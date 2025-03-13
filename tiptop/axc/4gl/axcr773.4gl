# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr773.4gl
# Descriptions...:  在製品彙總表(axcr773)
# Input parameter: 
# Return code....: 
# Date & Author..: 98/12/10   By Billy 
# Modify  .......: 01/06/29 By Ostrich #No.B191 加工欄彙總有誤
# Modify ........: 01/06/29 By Ostrich #No.+324 加列合計欄,轉出(dl+oh+sub)獨立
# Modify.........: No.MOD-4A0312 04/10/26 By Carol 欄位沒對齊
# Modify.........: No.FUN-510041 05/01/27 By Carol 調整報表架構轉HTML格式
# Modify.........: No.FUN-4C0099 05/02/14 By kim 報表轉XML功能
# Modify.........: No.MOD-540064 05/04/27 By kim 報表欄位名稱沒有....(料號後面的欄位)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-5B0082 05/11/17 By Sarah 報表少印"其他"欄位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-620066 06/03/02 By Sarah 抓資料時,多抓重覆性生產料件資料(ima911='Y'),當ima911='Y'時,則ccg04印空白
# Modify.........: No.FUN-670058 06/07/18 By Sarah 增加抓拆件式工單資料(cct_file,ccu_file)
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將之前FUN-670058多抓cct_file,ccu_file的部份remove
# Modify.........: No.MOD-670141 06/08/01 By Claire 報表金額計算調整
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/28 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710061 07/01/26 By pengu "差異轉出"說明改為"總計"
# Modify.........: NO.MOD-720042 07/03/12 By TSD.miki 報表改寫由Crystal Report
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-740065 07/07/20 By jamie 程式已轉成用Crystal Report方式出報表，程式裡面不應取zaa的資料(以後zaa將不再用)，應將其修正
# Modify.........: No.TQC-790087 07/09/14 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-7B0042 07/11/14 By Sarah 1.Input增加 起始年月-截止年月
#                                                  2.Input增加 資料內容：1.一般工單 2.委外工單 3.全部
# Modify.........: No.FUN-7C0101 08/01/31 By shiwuying 成本改善，CR增加類別編號ccb07和各種制費
# Modify.........: No.MOD-820006 08/04/20 By Sarah 成本改善修正
# Modify.........: No.MOD-870186 08/07/16 By Pengu 成本分群小計的成本分群說明無法完全顯示
# Modiyf.........: No.MOD-940183 09/04/14 By lutingting由于寫法錯誤,導致程序在會死掉
# Modify.........: No.MOD-930228 09/03/23 By Pengu 製費總計金額有誤
# Modify.........: No.MOD-950263 09/05/26 By Pengu 製費三~五相關的欄位在exucute時，沒有execute正確的欄位
# Modify.........: No.MOD-980080 09/08/13 By Smapmin 修正變數型態
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.TQC-A40139 10/04/29 By Carrier MOD-9A0142/MOD-980189 追单 & main结构调整
# Modify.........: No:CHI-9B0031 10/11/26 By Summer 重複性生產無法產生工單領用資料
# Modify.........: No:CHI-9B0010 10/11/26 By Summer 當執行跨期時，期初與期末不加是加總
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C20374 12/02/23 By xianghui 修改773_outnam(),在其裏面撈出g_page_line等參數
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                         # Print condition RECORD
           wc      LIKE type_file.chr1000,                #No.FUN-680122 VARCHAR(300)      # Where condition
           yy      LIKE type_file.num5,    #起始年        #No.FUN-680122 SMALLINT
           mm      LIKE type_file.num5,    #起始月        #No.FUN-680122 SMALLINT
           yy2     LIKE type_file.num5,    #截止年        #FUN-7B0042 add
           mm2     LIKE type_file.num5,    #截止月        #FUN-7B0042 add
           type1   LIKE cch_file.cch06,    #No.FUN-7C0101 add
           type    LIKE type_file.chr1,    #資料內容(1.一般工單 2.委外工單 3.全部)    #FUN-7B0042 add
           a       LIKE type_file.chr1,    #應列印明細    #No.FUN-680122 VARCHAR(1)        # Input more condition(Y/N)
           more    LIKE type_file.chr1                    #No.FUN-680122 VARCHAR(1)         # Input more condition(Y/N)
           END RECORD,
       g_yy,g_mm       LIKE type_file.num5,               #No.FUN-680122 SMALLINT
       l_flag          LIKE type_file.chr1,               #No.FUN-680122 VARCHAR(1)
       g_bdate,g_edate LIKE type_file.dat                 #No.FUN-680122 DATE
DEFINE g_i             LIKE type_file.num5                #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table         STRING
DEFINE g_sql           STRING
DEFINE g_str           STRING
DEFINE g_tot           ARRAY[13] OF LIKE cae_file.cae07
DEFINE g_zaa04_value  LIKE zaa_file.zaa04   #FUN-710080 add
DEFINE g_zaa10_value  LIKE zaa_file.zaa10   #FUN-710080 add
DEFINE g_zaa11_value  LIKE zaa_file.zaa11   #FUN-710080 add
DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A40139  --Begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a     = 'N'
   LET tm.more  = 'N'
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.yy      = ARG_VAL(8)
   LET tm.mm      = ARG_VAL(9)
   LET tm.yy2     = ARG_VAL(10)   #FUN-7B0042 add
   LET tm.mm2     = ARG_VAL(11)   #FUN-7B0042 add
   LET tm.type1    = ARG_VAL(17)  #No.FUN-7C0101 add
   LET tm.type    = ARG_VAL(12)   #FUN-7B0042 add
   LET tm.a       = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = "k.type_file.num10,      m.type_file.num5,",
               "ccg01.type_file.chr1000,ccg04.type_file.chr1000,",
               "str.type_file.chr1000,  ccg11.ccg_file.ccg22,",
               "ccg12.ccg_file.ccg22,   ccg21.ccg_file.ccg22,",
               "ccg22.ccg_file.ccg22,   ccg31.ccg_file.ccg22,",
               "ccg32.ccg_file.ccg22,   ccg42.ccg_file.ccg22,",
               "ccg91.ccg_file.ccg22,   ccg92.ccg_file.ccg22,",
               "azi03.azi_file.azi03,   azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,   ccz27.ccz_file.ccz27,",
               "azf03.azf_file.azf03,   ccg07.ccg_file.ccg07"     #TQC-740065 add #No.FUN-7C0101 add ccg07
   LET l_table = cl_prt_temptable('axcr773',g_sql) CLIPPED   # 產生Temp Table
   IF l_table  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
 
   DROP TABLE r773_tmp  
   CREATE TEMP TABLE r773_tmp(  
       wo    LIKE type_file.chr20, 
       amt1  LIKE type_file.num20_6,
       amt2  LIKE type_file.num20_6,
       amt3  LIKE type_file.num20_6,
       amt4  LIKE type_file.num20_6,
       amt5  LIKE type_file.num20_6,    #No.TQC-A40139
       amt6  LIKE type_file.num20_6, 
       amt7  LIKE type_file.num20_6, 
       amt8  LIKE type_file.num20_6); 
#增加amt5  #No.FUN-7C0101 ADD amt6,amt7,amt8
   create unique index r773_01 on r773_tmp(wo) 
  #---------------------No:CHI-9B0010 add----------------
   DROP TABLE r773_tmp1  
   CREATE TEMP TABLE r773_tmp1(  
             tmp01  LIKE type_file.num10, 
             tmp02  LIKE type_file.num5,
             tmp03  LIKE type_file.chr1000,
             tmp04  LIKE type_file.chr1000,
             tmp05  LIKE type_file.chr1000,
             tmp06  LIKE ccg_file.ccg22,  
             tmp07  LIKE ccg_file.ccg22, 
             tmp08  LIKE ccg_file.ccg22, 
             tmp09  LIKE ccg_file.ccg22, 
             tmp10  LIKE ccg_file.ccg22, 
             tmp11  LIKE ccg_file.ccg22, 
             tmp12  LIKE ccg_file.ccg22, 
             tmp13  LIKE ccg_file.ccg22, 
             tmp14  LIKE ccg_file.ccg22, 
             tmp15  LIKE azi_file.azi03, 
             tmp16  LIKE azi_file.azi04, 
             tmp17  LIKE azi_file.azi05, 
             tmp18  LIKE ccz_file.ccz27, 
             tmp19  LIKE azf_file.azf03, 
             tmp20  LIKE ccg_file.ccg07); 
   create unique index r773_02 on r773_tmp1(tmp03,tmp05,tmp20) 
  #---------------------No:CHI-9B0010 add----------------
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
   #No.TQC-A40139  --End  
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'  THEN
      CALL axcr773_tm(0,0)
   ELSE 
      CALL axcr773()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr773_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000     #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW axcr773_w AT p_row,p_col WITH FORM "axc/42f/axcr773" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)    #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy  = g_ccz.ccz01
   LET tm.mm  = g_ccz.ccz02
   LET tm.yy2 = g_ccz.ccz01   #FUN-7B0042 add
   LET tm.mm2 = g_ccz.ccz02   #FUN-7B0042 add
   LET tm.type1 = g_ccz.ccz28 #No.FUN-7C0101 add
   LET tm.type= '3'           #FUN-7B0042 add
   LET tm.a   = 'N'
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima12,ima08,ccg01,ima57,ccg04 
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
            IF INFIELD(ccg04) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO ccg04                             
               NEXT FIELD ccg04                                                 
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
         LET INT_FLAG = 0 CLOSE WINDOW axcr773_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
 
      IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
      INPUT BY NAME tm.yy,tm.mm,tm.yy2,tm.mm2,tm.type1,tm.type,tm.a,tm.more  #FUN-7B0042 add tm.yy2,tm.mm2,tm.type #No.FUN-7C0101 add tm.type1
         WITHOUT DEFAULTS 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         AFTER FIELD yy     #起始年
            IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         AFTER FIELD mm     #起始月
            IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
         AFTER FIELD yy2    #截止年
            IF cl_null(tm.yy2) THEN NEXT FIELD yy2 END IF
            IF tm.yy2 < tm.yy  THEN NEXT FIELD yy2 END IF
         AFTER FIELD mm2    #截止月
            IF cl_null(tm.mm2) THEN NEXT FIELD mm2 END IF
            IF tm.yy2 = tm.yy THEN
               IF tm.mm2 < tm.mm THEN NEXT FIELD mm2 END IF
            END IF
         AFTER FIELD type   #資料內容
            IF tm.type NOT MATCHES'[123]' THEN
                NEXT FIELD type
            END IF
 
         AFTER FIELD type1                        #No.FUN-7C0101
            IF tm.type NOT MATCHES '[12345]' THEN #No.FUN-7C0101
               NEXT FIELD type1                   #No.FUN-7C0101
            END IF                                #No.FUN-7C0101
                    
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
         LET INT_FLAG = 0 CLOSE WINDOW axcr773_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcr773'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcr773','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.mm CLIPPED,"'" ,
                            " '",tm.yy2 CLIPPED,"'",         #FUN-7B0042 add 
                            " '",tm.mm2 CLIPPED,"'" ,        #FUN-7B0042 add
                            " '",tm.type1 CLIPPED,"'" ,      #FUN-7C0101 add
                            " '",tm.type CLIPPED,"'" ,       #FUN-7B0042 add
                            " '",tm.a CLIPPED,"'",           #TQC-610051 
                            " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                            " '",g_template CLIPPED,"'",     #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr773',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr773_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axcr773()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr773_w
END FUNCTION
 
FUNCTION axcr773()
   DEFINE l_name       LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
          l_sql        STRING,   #CHAR(1200),         #RDSQL STATEMENT   #FUN-670058 modify
          l_sql1       STRING,                        #FUN-7B0042 add
          l_za05       LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          bdate,edate  LIKE type_file.dat,            #FUN-7B0042 add
          sr     RECORD 
                 ccg       RECORD   LIKE ccg_file.* ,   #工單在製成本檔
                 ima12     LIKE     ima_file.ima12 ,    #分群碼     
                 ima02     LIKE     ima_file.ima02 ,    #     
                 ima021    LIKE     ima_file.ima021,    #     
                 ima911    LIKE     ima_file.ima911,    #是否為重覆性生產料件  #FUN-620066
                 sfb99     LIKE     sfb_file.sfb99      #重工否 
                 END RECORD
 
   DELETE FROM r773_tmp
   DELETE FROM r773_tmp1    #No:CHI-9B0010 add
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ,?)"  #TQC-740065 add ? #No.FUN-7C0101 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
 
  #---------------------No:CHI-9B0010 add----------------
   LET g_sql = "INSERT INTO r773_tmp1", 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)" 
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
  #---------------------No:CHI-9B0010 end----------------

   #起始年月(tm.yy,tm.mm)與截止年月(tm.yy2,tm.mm2)抓取起迄日期(g_bdate,g_edate)
   CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,bdate,edate
   LET g_bdate = bdate
   CALL s_azm(tm.yy2,tm.mm2) RETURNING l_flag,bdate,edate
   LET g_edate = edate
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   CASE tm.type
      WHEN '1'   #一般工單
           LET l_sql1 = " AND sfb02 != '7' AND sfb02 != '8'"
      WHEN '2'   #委外工單
           LET l_sql1 = " AND (sfb02 = '7' OR sfb02 = '8')"
      WHEN '3'   #全部
           LET l_sql1 = " AND 1=1"
   END CASE
 
   LET l_sql = "SELECT sfm03,sfm04,sfm05,sfm06",
               "  FROM sfm_file",
               " WHERE sfm01 = ?",
               "   AND sfm10 = '1'", 
               "   AND sfm03<= '",g_edate,"'",
               " ORDER BY sfm03,sfm04"
   PREPARE r773_presfm FROM l_sql
   IF STATUS THEN CALL cl_err('r773_presfm:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE r773_sfmcur CURSOR FOR r773_presfm  
 
#工單元件
   LET l_sql = "SELECT cch04,cch22a, cch22b, cch22c, cch22d, cch22e, cch22f, cch22g, cch22h,",#No.FUN-7C0101 add cch22f,g,h
               "             cch32a, cch32b, cch32c, cch32d, cch32e, cch32f, cch32g, cch32h,",#No.FUN-7C0101 add cch32f,g,h
               "             cch12a, cch12b, cch12c, cch12d, cch12e, cch12f, cch12g, cch12h,",#MOD-4A0312  #No.FUN-7C0101 add cch12f,g,h
               "             cch92a, cch92b, cch92c, cch92d, cch92e, cch92f, cch92g, cch92h ",#No.FUN-7C0101 add cch92f,g,h
              #CHI-9B0031 mod --start--
              #" FROM cch_file,sfb_file ",   #FUN-7B0042 add sfb_file
               " FROM cch_file LEFT JOIN sfb_file ON cch01 = sfb01", 
              #CHI-9B0031 mod --end--
               " WHERE cch01 =  ? ",
              #"   AND cch01 = sfb01 ",      #FUN-7B0042 add #CHI-9B0031 mark
              #-----------------No:CHI-9B0010 modify
              #"   AND (cch02*12+cch03 BETWEEN ",tm.yy*12+tm.mm,
              #"                           AND ",tm.yy2*12+tm.mm2,")",
               "   AND cch02 = ? ",
               "   AND cch03 = ? ",
              #-----------------No:CHI-9B0010 end
               "   AND cch06 ='",tm.type1,"'",  #No.FUN-7C0101 add
               "   AND cch04 = ' DL+OH+SUB'"
   LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0042 add
   PREPARE r773_precch FROM l_sql
   IF STATUS THEN CALL cl_err('r773_precch:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE r773_cchcur CURSOR FOR r773_precch  
 
  #---------------------- No:CHI-9B0031 add
   LET l_sql = "SELECT cch04,cch22a, cch22b, cch22c, cch22d, cch22e, cch22f, cch22g, cch22h,",#No.FUN-7C0101 add cch22f,g,h
               "             cch32a, cch32b, cch32c, cch32d, cch32e, cch32f, cch32g, cch32h,",#No.FUN-7C0101 add cch32f,g,h
               "             cch12a, cch12b, cch12c, cch12d, cch12e, cch12f, cch12g, cch12h,",#MOD-4A0312  #No.FUN-7C0101 add cch12f,g,h
               "             cch92a, cch92b, cch92c, cch92d, cch92e, cch92f, cch92g, cch92h ",#No.FUN-7C0101 add cch92f,g,h
               " FROM cch_file ", 
               " WHERE cch01 =  ? ",
               "   AND cch02 = ? ",
               "   AND cch03 = ? ",
               "   AND cch06 ='",tm.type1,"'",  
               "   AND cch04 = ' DL+OH+SUB'"
   PREPARE r773_precch1 FROM l_sql
   IF STATUS THEN CALL cl_err('r773_precch1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE r773_cchcur1 CURSOR FOR r773_precch1  
  #---------------------- No:CHI-9B0031 add

#工單主件
   LET l_sql = " SELECT ccg_file.* ,",
               "        ima12,ima02,ima021,ima911,sfb99",       #FUN-620066
               " FROM ccg_file ,ima_file ,sfb_file ",
               " WHERE ccg04=ima01 " ,
               "   AND ccg01=sfb01 " ,
               "   AND (ccg02*12+ccg03 BETWEEN ",tm.yy*12+tm.mm,
               "                           AND ",tm.yy2*12+tm.mm2,")",
               "   AND ccg06='",tm.type1,"'", #No.FUN-7C0101 add
               "   AND ", tm.wc CLIPPED  
   LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0042 add
   LET l_sql = l_sql CLIPPED,
               " UNION ",
               " SELECT ccg_file.* ,",
               "        ima12,ima02,ima021,ima911,''",
               " FROM ccg_file ,ima_file ",   #FUN-7B0042 add sfb_file  #No:CHI-9B0031 modify
               " WHERE ccg01=ima01 " ,
              #"   AND ccg01=sfb01 " ,   #FUN-7B0042 add #CHI-9B0031 mark
               "   AND ima911='Y' ",
               "   AND (ccg02*12+ccg03 BETWEEN ",tm.yy*12+tm.mm,
               "                           AND ",tm.yy2*12+tm.mm2,")",
               "   AND ccg06='",tm.type1,"'", #No.FUN-7C0101 add
               "   AND ", tm.wc CLIPPED
  #LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0042 add  #CHI-9B0031 mark
   PREPARE axcr773_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr773_curs1 CURSOR FOR axcr773_prepare1
 
   CALL r773_outnam() RETURNING l_name        #FUN-7B0042
   START REPORT axcr773_rep1 TO l_name
   LET g_pageno = 0
   FOREACH axcr773_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #-----------------No:CHI-9B0010 add
      IF (sr.ccg.ccg02*12+sr.ccg.ccg03) != (tm.yy*12+tm.mm) THEN
         LET sr.ccg.ccg11 = 0
         LET sr.ccg.ccg12 = 0
         LET sr.ccg.ccg12a = 0
         LET sr.ccg.ccg12b = 0
         LET sr.ccg.ccg12c = 0
         LET sr.ccg.ccg12d = 0
         LET sr.ccg.ccg12e = 0
         LET sr.ccg.ccg12f = 0
         LET sr.ccg.ccg12g = 0
         LET sr.ccg.ccg12h = 0
      END IF
      IF (sr.ccg.ccg02*12+sr.ccg.ccg03) != (tm.yy2*12+tm.mm2) THEN
         LET sr.ccg.ccg91 = 0
         LET sr.ccg.ccg92 = 0
         LET sr.ccg.ccg92a = 0
         LET sr.ccg.ccg92b = 0
         LET sr.ccg.ccg92c = 0
         LET sr.ccg.ccg92d = 0
         LET sr.ccg.ccg92e = 0
         LET sr.ccg.ccg92f = 0
         LET sr.ccg.ccg92g = 0
         LET sr.ccg.ccg92h = 0
      END IF
     #-----------------No:CHI-9B0010 end
      OUTPUT TO REPORT axcr773_rep1(sr.*)
   END FOREACH
 
   FINISH REPORT axcr773_rep1
 
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima12,ima08,ccg01,ima57,ccg04')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   #p1~p6
   LET g_str = g_str,";",tm.yy,";",tm.mm,
                     ";",tm.yy2,";",tm.mm2,";",tm.type   #FUN-7B0042 add
   IF tm.type1 MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr773','axcr773_1',l_sql,g_str)
   END IF
   IF tm.type1 MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr773','axcr773',l_sql,g_str)
   END IF
 
END FUNCTION
 
 
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r773_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
 
#=======================================
# 產生temp資料
#=======================================
REPORT axcr773_rep1(sr)
   DEFINE l_ima12 LIKE ima_file.ima12,
           a_cch12a,a_cch12b,a_cch12c,a_cch12d,a_cch12e,a_cch12f,a_cch12g,a_cch12h LIKE cch_file.cch12a,#No.FUN-7C0101 add a_cch12f,g,h
           a_cch22a,a_cch22b,a_cch22c,a_cch22d,a_cch22e,a_cch22f,a_cch22g,a_cch22h LIKE cch_file.cch22a,#No.FUN-7C0101 add a_cch22f,g,h
           a_cch32a,a_cch32b,a_cch32c,a_cch32d,a_cch32e,a_cch32f,a_cch32g,a_cch32h LIKE cch_file.cch22a,#No.FUN-7C0101 add a_cch32f,g,h
           a_cch42a,a_cch42b,a_cch42c,a_cch42d,a_cch42e,a_cch42f,a_cch42g,a_cch42h LIKE cch_file.cch22a,#No.FUN-7C0101 add a_cch42f,g,h
           a_cch92a,a_cch92b,a_cch92c,a_cch92d,a_cch92e,a_cch92f,a_cch92g,a_cch92h LIKE cch_file.cch22a,#No.FUN-7C0101 add a_cch92f,g,h
           a_cch12 ,a_cch22 ,a_cch32 ,a_cch42 ,a_cch92  LIKE cch_file.cch22a
 
   DEFINE l_last_sw  LIKE type_file.chr1, 
          l_subcch22a,l_totcch22a,l_sumcch22a,
          l_subcch22b,l_totcch22b,l_sumcch22b,
          l_subcch22c,l_totcch22c,l_sumcch22c,
          l_subcch22d,l_totcch22d,l_sumcch22d,
          l_subcch22e,l_totcch22e,l_sumcch22e,
          l_subcch22f,l_totcch22f,l_sumcch22f, #No.FUN-7C0101 add
          l_subcch22g,l_totcch22g,l_sumcch22g, #No.FUN-7C0101 add
          l_subcch22h,l_totcch22h,l_sumcch22h, #No.FUN-7C0101 add
          l_subcch32a,l_totcch32a,l_sumcch32a,
          l_subcch32b,l_totcch32b,l_sumcch32b,
          l_subcch32c,l_totcch32c,l_sumcch32c,
          l_subcch32d,l_totcch32d,l_sumcch32d,
          l_subcch32e,l_totcch32e,l_sumcch32e,
          l_subcch32f,l_totcch32f,l_sumcch32f, #No.FUN-7C0101 add
          l_subcch32g,l_totcch32g,l_sumcch32g, #No.FUN-7C0101 add
          l_subcch32h,l_totcch32h,l_sumcch32h, #No.FUN-7C0101 add
          l_subcch12a,l_totcch12a,l_sumcch12a,
          l_subcch12b,l_totcch12b,l_sumcch12b,
          l_subcch12c,l_totcch12c,l_sumcch12c,
          l_subcch12d,l_totcch12d,l_sumcch12d,
          l_subcch12e,l_totcch12e,l_sumcch12e,
          l_subcch12f,l_totcch12f,l_sumcch12f, #No.FUN-7C0101 add
          l_subcch12g,l_totcch12g,l_sumcch12g, #No.FUN-7C0101 add
          l_subcch12h,l_totcch12h,l_sumcch12h, #No.FUN-7C0101 add
          l_subcch92a,l_totcch92a,l_sumcch92a,
          l_subcch92b,l_totcch92b,l_sumcch92b,
          l_subcch92c,l_totcch92c,l_sumcch92c,
          l_subcch92d,l_totcch92d,l_sumcch92d,
          l_subcch92e,l_totcch92e,l_sumcch92e,
          l_subcch92f,l_totcch92f,l_sumcch92f, #No.FUN-7C0101 add
          l_subcch92g,l_totcch92g,l_sumcch92g, #No.FUN-7C0101 add
          l_subcch92h,l_totcch92h,l_sumcch92h LIKE cch_file.cch22a, #No.FUN-7C0101 add   #MOD-980080
          l_cch12a     LIKE cch_file.cch12a,
          l_cch12b     LIKE cch_file.cch12b,
          l_cch12c     LIKE cch_file.cch12c,
          l_cch12d     LIKE cch_file.cch12d,
          l_cch12e     LIKE cch_file.cch12e,
          l_cch12f     LIKE cch_file.cch12f, #No.FUN-7C0101 add
          l_cch12g     LIKE cch_file.cch12g, #No.FUN-7C0101 add
          l_cch12h     LIKE cch_file.cch12h, #No.FUN-7C0101 add
          l_cch92a     LIKE cch_file.cch92a,
          l_cch92b     LIKE cch_file.cch92b,
          l_cch92c     LIKE cch_file.cch92c,
          l_cch92d     LIKE cch_file.cch92d,
          l_cch92e     LIKE cch_file.cch92e,
          l_cch92f     LIKE cch_file.cch92f, #No.FUN-7C0101 add
          l_cch92g     LIKE cch_file.cch92g, #No.FUN-7C0101 add
          l_cch92h     LIKE cch_file.cch92h, #No.FUN-7C0101 add
          l_cch22a     LIKE cch_file.cch22a,
          l_cch22b     LIKE cch_file.cch22b,
          l_cch22c     LIKE cch_file.cch22c,
          l_cch22d     LIKE cch_file.cch22d,
          l_cch22e     LIKE cch_file.cch22e,
          l_cch22f     LIKE cch_file.cch22f, #No.FUN-7C0101 add
          l_cch22g     LIKE cch_file.cch22g, #No.FUN-7C0101 add
          l_cch22h     LIKE cch_file.cch22h, #No.FUN-7C0101 add
          l_cch32a     LIKE cch_file.cch32a,
          l_cch32b     LIKE cch_file.cch32b,
          l_cch32c     LIKE cch_file.cch32c,
          l_cch32d     LIKE cch_file.cch32d,
          l_cch32e     LIKE cch_file.cch32e,
          l_cch32f     LIKE cch_file.cch32f, #No.FUN-7C0101 add
          l_cch32g     LIKE cch_file.cch32g, #No.FUN-7C0101 add
          l_cch32h     LIKE cch_file.cch32h, #No.FUN-7C0101 add
          l_cch04      LIKE cch_file.cch04,
          l_dif,l_chg  LIKE ccg_file.ccg11,
          l_subchg,l_totchg,l_sumchg        LIKE ccg_file.ccg11,
          l_woqty      LIKE ccg_file.ccg11,
          l_subwoqty,l_totwoqty,l_sumwoqty  LIKE ccg_file.ccg11,
          l_sfm03      LIKE sfm_file.sfm03,
          l_sfm04      LIKE sfm_file.sfm04,
          l_sfm05      LIKE sfm_file.sfm05,
          l_sfm06      LIKE sfm_file.sfm06,
          l_cnt        LIKE type_file.num5,
          l_amt1,l_amt2,l_amt3,l_amt4  LIKE ccg_file.ccg22a,
          l_amt5       LIKE ccg_file.ccg22a,
          l_amt6,l_amt7,l_amt8  LIKE ccg_file.ccg22a,#No.FUN-7C0101 add
          l_azf03      LIKE azf_file.azf03,
          l_sql        STRING,
          l_buf        LIKE type_file.chr1000,
          l_i,l_j      LIKE type_file.num5, 
          l_k          LIKE type_file.num10,
          l_tot        ARRAY[7] OF LIKE type_file.num20_6,
          l_str        LIKE type_file.chr1000, 
         #-------------------------No:CHI-9B0010 add
          sr1    RECORD
                   tmp01  LIKE type_file.num10, 
                   tmp02  LIKE type_file.num5,
                   tmp03  LIKE type_file.chr1000,
                   tmp04  LIKE type_file.chr1000,
                   tmp05  LIKE type_file.chr1000,
                   tmp06  LIKE ccg_file.ccg22,  
                   tmp07  LIKE ccg_file.ccg22, 
                   tmp08  LIKE ccg_file.ccg22, 
                   tmp09  LIKE ccg_file.ccg22, 
                   tmp10  LIKE ccg_file.ccg22, 
                   tmp11  LIKE ccg_file.ccg22, 
                   tmp12  LIKE ccg_file.ccg22, 
                   tmp13  LIKE ccg_file.ccg22, 
                   tmp14  LIKE ccg_file.ccg22, 
                   tmp15  LIKE azi_file.azi03, 
                   tmp16  LIKE azi_file.azi04, 
                   tmp17  LIKE azi_file.azi05, 
                   tmp18  LIKE ccz_file.ccz27, 
                   tmp19  LIKE azf_file.azf03, 
                   tmp20  LIKE ccg_file.ccg07 
                 END RECORD,
         #-------------------------No:CHI-9B0010 end
          sr     RECORD
                   ccg      RECORD   LIKE ccg_file.* ,  #工單在製成本檔
                   ima12    LIKE    ima_file.ima12,     #分群碼
                   ima02    LIKE    ima_file.ima02 ,    #     
                   ima021   LIKE    ima_file.ima021,    #     
                   ima911   LIKE    ima_file.ima911,    #是否為重覆性生產料件 
                   sfb99    LIKE    sfb_file.sfb99      #重工否
                 END RECORD
          
  OUTPUT TOP MARGIN g_top_margin
        LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin 
        PAGE LENGTH g_page_line
 
  ORDER BY sr.ima12 ,sr.sfb99, sr.ccg.ccg01 
 
FORMAT                                          
   PAGE HEADER
      IF PAGENO = 1 THEN 
         LET l_sumcch22a = 0  LET l_sumcch22b = 0 
         LET l_sumcch22c = 0  LET l_sumcch22d = 0 
         LET l_sumcch22e = 0
         LET l_sumcch22f = 0  LET l_sumcch22g = 0 #No.FUN-7C0101 add
         LET l_sumcch22h = 0                      #No.FUN-7C0101 add
         LET l_sumcch32a = 0  LET l_sumcch32b = 0
         LET l_sumcch32c = 0  LET l_sumcch32d = 0
         LET l_sumcch32e = 0
         LET l_sumcch32f = 0  LET l_sumcch32g = 0 #No.FUN-7C0101 add
         LET l_sumcch32h = 0                      #No.FUN-7C0101 add
         LET l_sumcch12a = 0  LET l_sumcch12b = 0 
         LET l_sumcch12c = 0  LET l_sumcch12d = 0 
         LET l_sumcch12e = 0
         LET l_sumcch12f = 0  LET l_sumcch12g = 0 #No.FUN-7C0101 add
         LET l_sumcch12h = 0                      #No.FUN-7C0101 add
         LET l_sumcch92a = 0  LET l_sumcch92b = 0
         LET l_sumcch92c = 0  LET l_sumcch92d = 0
         LET l_sumcch92e = 0
         LET l_sumcch92f = 0  LET l_sumcch92g = 0 #No.FUN-7C0101 add
         LET l_sumcch92h = 0                      #No.FUN-7C0101 add
         LET l_sumwoqty  = 0  LET l_sumchg    = 0 
         LET l_k = 0
      END IF
 
   BEFORE GROUP OF sr.ima12
      LET l_totcch22a = 0 LET l_totcch22b = 0
      LET l_totcch22c = 0 LET l_totcch22d = 0 
      LET l_totcch22e = 0
      LET l_totcch22f = 0 LET l_totcch22g = 0 #No.FUN-7C0101 add
      LET l_totcch22h = 0                     #No.FUN-7C0101 add
      LET l_totcch32a = 0 LET l_totcch32b = 0 
      LET l_totcch32c = 0 LET l_totcch32d = 0
      LET l_totcch32e = 0
      LET l_totcch32f = 0 LET l_totcch32g = 0 #No.FUN-7C0101 add
      LET l_totcch32h = 0                     #No.FUN-7C0101 add
      LET l_totcch12a = 0 LET l_totcch12b = 0
      LET l_totcch12c = 0 LET l_totcch12d = 0 
      LET l_totcch12e = 0
      LET l_totcch12f = 0 LET l_totcch12g = 0 #No.FUN-7C0101 add
      LET l_totcch12h = 0                     #No.FUN-7C0101 add
      LET l_totcch92a = 0 LET l_totcch92b = 0 
      LET l_totcch92c = 0 LET l_totcch92d = 0
      LET l_totcch92e = 0
      LET l_totcch92f = 0 LET l_totcch92g = 0 #No.FUN-7C0101 add
      LET l_totcch92h = 0                     #No.FUN-7C0101 add
      LET l_totwoqty  = 0 LET l_totchg    = 0 
 
   BEFORE GROUP OF sr.sfb99
      LET l_subcch22a = 0 LET l_subcch22b = 0 
      LET l_subcch22c = 0 LET l_subcch22d = 0
      LET l_subcch22e = 0
      LET l_subcch22f = 0 LET l_subcch22g = 0 #No.FUN-7C0101 add
      LET l_subcch22h = 0                     #No.FUN-7C0101 add
      LET l_subcch32a = 0 LET l_subcch32b = 0 
      LET l_subcch32c = 0 LET l_subcch32d = 0
      LET l_subcch32e = 0
      LET l_subcch32f = 0 LET l_subcch32g = 0 #No.FUN-7C0101 add
      LET l_subcch32h = 0                     #No.FUN-7C0101 add
      LET l_subcch12a = 0 LET l_subcch12b = 0 
      LET l_subcch12c = 0 LET l_subcch12d = 0
      LET l_subcch12e = 0 
      LET l_subcch12f = 0 LET l_subcch12g = 0 #No.FUN-7C0101 add
      LET l_subcch12h = 0                     #No.FUN-7C0101 add
      LET l_subcch92a = 0 LET l_subcch92b = 0 
      LET l_subcch92c = 0 LET l_subcch92d = 0
      LET l_subcch92e = 0 
      LET l_subcch92f = 0 LET l_subcch92g = 0 #No.FUN-7C0101 add
      LET l_subcch92h = 0                     #No.FUN-7C0101 add
      LET l_subwoqty  = 0 LET l_subchg    = 0 
 
   ON EVERY ROW  
      #-->取本月之報廢量
      LET l_chg = 0    LET l_cnt = 0
      FOREACH r773_sfmcur USING sr.ccg.ccg01 
                          INTO l_sfm03,l_sfm04,l_sfm05,l_sfm06
         IF l_sfm03 < g_bdate THEN CONTINUE FOREACH END IF
         LET l_dif = l_sfm06 - l_sfm05
         LET l_chg = l_chg + l_dif
         LET l_cnt = l_cnt + 1
      END FOREACH 
      LET l_woqty = sr.ccg.ccg21 - l_chg
      LET l_chg = -(sr.ccg.ccg11+l_woqty+sr.ccg.ccg31-sr.ccg.ccg91)
      #-->取本月之' DL+OH+SUB'  WIP-元件 本期投入人工製費
     #-------------------------- No:CHI-9B0031 add
      IF sr.ima911 = 'Y' THEN
         OPEN r773_cchcur1 USING sr.ccg.ccg01,sr.ccg.ccg02,sr.ccg.ccg03   
         FETCH r773_cchcur1 INTO l_cch04, 
                                l_cch22a, l_cch22b, l_cch22c, l_cch22d, l_cch22e,l_cch22f, l_cch22g, l_cch22h,
                                l_cch32a, l_cch32b, l_cch32c, l_cch32d, l_cch32e,l_cch32f, l_cch32g, l_cch32h,
                                l_cch12a, l_cch12b, l_cch12c, l_cch12d, l_cch12e,l_cch12f, l_cch12g, l_cch12h,
                                l_cch92a, l_cch92b, l_cch92c, l_cch92d, l_cch92e,l_cch92f, l_cch92g, l_cch92h 
      ELSE
     #-------------------------- No:CHI-9B0031 end
         OPEN r773_cchcur USING sr.ccg.ccg01,sr.ccg.ccg02,sr.ccg.ccg03    #No:CHI-9B0010 modify
         FETCH r773_cchcur INTO l_cch04, 
                                l_cch22a, l_cch22b, l_cch22c, l_cch22d, l_cch22e,l_cch22f, l_cch22g, l_cch22h,#No.FUN-7C0101
                                l_cch32a, l_cch32b, l_cch32c, l_cch32d, l_cch32e,l_cch32f, l_cch32g, l_cch32h,#No.FUN-7C0101
                                l_cch12a, l_cch12b, l_cch12c, l_cch12d, l_cch12e,l_cch12f, l_cch12g, l_cch12h,#No.FUN-7C0101
                                l_cch92a, l_cch92b, l_cch92c, l_cch92d, l_cch92e,l_cch92f, l_cch92g, l_cch92h #No.FUN-7C0101
      END IF    # No:CHI-9B0031 add
      IF SQLCA.sqlcode THEN 
         LET l_cch22a = 0 LET l_cch22b = 0 LET l_cch22c = 0 LET l_cch22d = 0
         LET l_cch22e = 0 
         LET l_cch22f = 0 LET l_cch22g = 0 LET l_cch22h = 0 #No.FUN-7C0101 add
         LET l_cch32a = 0 LET l_cch32b = 0 LET l_cch32c = 0 LET l_cch32d = 0
         LET l_cch32e = 0 
         LET l_cch32f = 0 LET l_cch32g = 0 LET l_cch32h = 0 #No.FUN-7C0101 add
         LET l_cch12a = 0 LET l_cch12b = 0 LET l_cch12c = 0 LET l_cch12d = 0
         LET l_cch12e = 0 
         LET l_cch12f = 0 LET l_cch12g = 0 LET l_cch12h = 0 #No.FUN-7C0101 add
         LET l_cch92a = 0 LET l_cch92b = 0 LET l_cch92c = 0 LET l_cch92d = 0
         LET l_cch92e = 0 
         LET l_cch92f = 0 LET l_cch92g = 0 LET l_cch92h = 0 #No.FUN-7C0101 add
      END IF
     #--------- No:CHI-9B0031 add
      IF sr.ima911 = 'Y' THEN 
         CLOSE r773_cchcur
      ELSE
     #--------- No:CHI-9B0031 end
         CLOSE r773_cchcur
      END IF    # No:CHI-9B0031 add
      IF cl_null(l_cch22a) THEN LET l_cch22a = 0 END IF 
      IF cl_null(l_cch22b) THEN LET l_cch22b = 0 END IF
      IF cl_null(l_cch22c) THEN LET l_cch22c = 0 END IF
      IF cl_null(l_cch22d) THEN LET l_cch22d = 0 END IF
      IF cl_null(l_cch22e) THEN LET l_cch22e = 0 END IF
      IF cl_null(l_cch22f) THEN LET l_cch22f = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch22g) THEN LET l_cch22g = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch22h) THEN LET l_cch22h = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch32a) THEN LET l_cch32a = 0 END IF
      IF cl_null(l_cch32b) THEN LET l_cch32b = 0 END IF
      IF cl_null(l_cch32c) THEN LET l_cch32c = 0 END IF
      IF cl_null(l_cch32d) THEN LET l_cch32d = 0 END IF
      IF cl_null(l_cch32e) THEN LET l_cch32e = 0 END IF
      IF cl_null(l_cch32f) THEN LET l_cch32f = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch32g) THEN LET l_cch32g = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch32h) THEN LET l_cch32h = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch12a) THEN LET l_cch12a = 0 END IF 
      IF cl_null(l_cch12b) THEN LET l_cch12b = 0 END IF
      IF cl_null(l_cch12c) THEN LET l_cch12c = 0 END IF
      IF cl_null(l_cch12d) THEN LET l_cch12d = 0 END IF
      IF cl_null(l_cch12e) THEN LET l_cch12e = 0 END IF 
      IF cl_null(l_cch12f) THEN LET l_cch12f = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch12g) THEN LET l_cch12g = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch12h) THEN LET l_cch12h = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch92a) THEN LET l_cch92a = 0 END IF
      IF cl_null(l_cch92b) THEN LET l_cch92b = 0 END IF
      IF cl_null(l_cch92c) THEN LET l_cch92c = 0 END IF
      IF cl_null(l_cch92d) THEN LET l_cch92d = 0 END IF
      IF cl_null(l_cch92e) THEN LET l_cch92e = 0 END IF 
      IF cl_null(l_cch92f) THEN LET l_cch92f = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch92g) THEN LET l_cch92g = 0 END IF #No.FUN-7C0101 add
      IF cl_null(l_cch92h) THEN LET l_cch92h = 0 END IF #No.FUN-7C0101 add
     #-----------------No:CHI-9B0010 add
      IF (sr.ccg.ccg02*12+sr.ccg.ccg03) != (tm.yy*12+tm.mm) THEN
         LET l_cch12a = 0
         LET l_cch12b = 0
         LET l_cch12c = 0
         LET l_cch12d = 0
         LET l_cch12e = 0
         LET l_cch12f = 0
         LET l_cch12g = 0
         LET l_cch12h = 0
      END IF
      IF (sr.ccg.ccg02*12+sr.ccg.ccg03) != (tm.yy2*12+tm.mm2) THEN
         LET l_cch92a = 0
         LET l_cch92b = 0
         LET l_cch92c = 0
         LET l_cch92d = 0
         LET l_cch92e = 0
         LET l_cch92f = 0
         LET l_cch92g = 0
         LET l_cch92h = 0
      END IF
     #-----------------No:CHI-9B0010 end
      #--->列印數量 
      IF tm.a = 'Y' THEN
         LET l_buf = ''
         IF cl_null(sr.ima911) OR sr.ima911 != 'Y' THEN 
            LET l_buf = sr.ccg.ccg01 
         END IF
         LET l_k = l_k + 1
         LET l_str = '0' CLIPPED       #數量: #FUN-7B0042 add
         LET l_tot[7] = 1   #FUN-7B0042 mod 2->1
         EXECUTE insert_prep1 USING              #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,sr.ccg.ccg04,l_str,sr.ccg.ccg11,   #FUN-7B0042 mod
              l_tot[6],l_woqty,l_tot[6],sr.ccg.ccg31,l_tot[6],
              l_chg,sr.ccg.ccg91,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''   #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + sr.ccg.ccg11,
                                 tmp08 = tmp08 + l_woqty,
                                 tmp10 = tmp10 + sr.ccg.ccg31,
                                 tmp12 = tmp12 + l_chg,
                                 tmp13 = tmp13 + sr.ccg.ccg91
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印材料 
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '1' CLIPPED       #材料: #TQC-740065 mod
         LET l_tot[1] = sr.ccg.ccg22a+sr.ccg.ccg23a
         LET l_tot[7] = 1   #FUN-7B0042 mod 0->1
         EXECUTE insert_prep1 USING      #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,sr.ima02,l_str,sr.ccg.ccg12a,   #No:CHI-9B0010 modify
              l_tot[6],l_tot[1],l_tot[6],sr.ccg.ccg32a,l_tot[6],
              sr.ccg.ccg42a,sr.ccg.ccg92a,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + sr.ccg.ccg12a,
                                 tmp08 = tmp08 + l_tot[1],
                                 tmp10 = tmp10 + sr.ccg.ccg32a,
                                 tmp12 = tmp12 + sr.ccg.ccg42a,
                                 tmp13 = tmp13 + sr.ccg.ccg92a
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印人工
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '2' CLIPPED       #人工:  #TQC-740065 mod
         LET l_tot[1] = sr.ccg.ccg12b-l_cch12b
         LET l_tot[2] = sr.ccg.ccg22b+sr.ccg.ccg23b-l_cch22b
         LET l_tot[3] = sr.ccg.ccg32b - l_cch32b
         LET l_tot[4] = sr.ccg.ccg92b-l_cch92b
         LET l_tot[7] = 1   #FUN-7B0042 mod 0->1
         EXECUTE insert_prep1 USING       #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,sr.ima021,l_str,l_tot[1],  #No:CHI-9B0010 modify
              l_cch12b,l_tot[2],l_cch22b,l_tot[3],l_cch32b,
              sr.ccg.ccg42b,l_tot[4],l_cch92b,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12b,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22b,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32b,
                                 tmp12 = tmp12 + sr.ccg.ccg42b,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92b 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費一
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '3' CLIPPED       #製費一:  #TQC-740065 mod
         LET l_tot[1] = sr.ccg.ccg12c-l_cch12c
         LET l_tot[2] = sr.ccg.ccg22c+sr.ccg.ccg23c-l_cch22c
         LET l_tot[3] = sr.ccg.ccg32c - l_cch32c
         LET l_tot[4] = sr.ccg.ccg92c-l_cch92c
         LET l_tot[7] = 1   #FUN-7B0042 mod 0->1
         EXECUTE insert_prep1 USING      #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],  #No:CHI-9B0010 modify
              l_cch12c,l_tot[2],l_cch22c,l_tot[3],l_cch32c,
              sr.ccg.ccg42c,l_tot[4],l_cch92c,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12c,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22c,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32c,
                                 tmp12 = tmp12 + sr.ccg.ccg42c,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92c 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印加工
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '4' CLIPPED       #加工:  #TQC-740065 mod 
         LET l_tot[1] = sr.ccg.ccg12d-l_cch12d
         LET l_tot[2] = sr.ccg.ccg22d+sr.ccg.ccg23d-l_cch22d
         LET l_tot[3] = sr.ccg.ccg32d - l_cch32d
         LET l_tot[4] = sr.ccg.ccg92d-l_cch92d
         LET l_tot[7] = 1   #FUN-7B0042 mod 0->1
         EXECUTE insert_prep1 USING      #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],   #No:CHI-9B0010 modify
              l_cch12d,l_tot[2],l_cch22d,l_tot[3],l_cch32d,
              sr.ccg.ccg42d,l_tot[4],l_cch92d,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                               #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12d,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22d,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32d,
                                 tmp12 = tmp12 + sr.ccg.ccg42d,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92d 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費二
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '5' CLIPPED       #製費二:  #TQC-740065 mod 
         LET l_tot[1] = sr.ccg.ccg12e-l_cch12e
         LET l_tot[2] = sr.ccg.ccg22e+sr.ccg.ccg23e-l_cch22e
         LET l_tot[3] = sr.ccg.ccg32e-l_cch32e
         LET l_tot[4] = sr.ccg.ccg92e-l_cch92e
         LET l_tot[7] = 1   #FUN-7B0042 mod 0->1
         EXECUTE insert_prep1 USING      #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],   #No:CHI-9B0010 modify
              l_cch12e,l_tot[2],l_cch22e,l_tot[3],l_cch32e,
              sr.ccg.ccg42e,l_tot[4],l_cch92e,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                               #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12e,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22e,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32e,
                                 tmp12 = tmp12 + sr.ccg.ccg42e,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92e 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費三
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '6' CLIPPED       #製費三:
         LET l_tot[1] = sr.ccg.ccg12f-l_cch12f
         LET l_tot[2] = sr.ccg.ccg22f+sr.ccg.ccg23f-l_cch22f
         LET l_tot[3] = sr.ccg.ccg32f-l_cch32f
         LET l_tot[4] = sr.ccg.ccg92f-l_cch92f
         LET l_tot[7] = 1
         EXECUTE insert_prep1 USING     #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],  #No:CHI-9B0010 modify
              l_cch12f,l_tot[2],l_cch22f,l_tot[3],l_cch32f,
              sr.ccg.ccg42f,l_tot[4],l_cch92f,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,'' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12f,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22f,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32f,
                                 tmp12 = tmp12 + sr.ccg.ccg42f,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92f 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費四
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '7' CLIPPED       #製費四: 
         LET l_tot[1] = sr.ccg.ccg12g-l_cch12g
         LET l_tot[2] = sr.ccg.ccg22g+sr.ccg.ccg23g-l_cch22g
         LET l_tot[3] = sr.ccg.ccg32g-l_cch32g
         LET l_tot[4] = sr.ccg.ccg92g-l_cch92g
         LET l_tot[7] = 1 
         EXECUTE insert_prep1 USING      #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],   #No:CHI-9B0010 modify
              l_cch12g,l_tot[2],l_cch22g,l_tot[3],l_cch32g,
              sr.ccg.ccg42g,l_tot[4],l_cch92g,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07 
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12g,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22g,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32g,
                                 tmp12 = tmp12 + sr.ccg.ccg42g,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92g 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費五
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '8' CLIPPED       #製費五:
         LET l_tot[1] = sr.ccg.ccg12h-l_cch12h
         LET l_tot[2] = sr.ccg.ccg22h+sr.ccg.ccg23h-l_cch22h
         LET l_tot[3] = sr.ccg.ccg32h-l_cch32h
         LET l_tot[4] = sr.ccg.ccg92h-l_cch92h
         LET l_tot[7] = 1 
         EXECUTE insert_prep1 USING       #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],   #No:CHI-9B0010 modify
              l_cch12h,l_tot[2],l_cch22h,l_tot[3],l_cch32h,
              sr.ccg.ccg42h,l_tot[4],l_cch92h,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07 
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp07 = tmp07 + l_cch12h,
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp09 = tmp09 + l_cch22h,
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp11 = tmp11 + l_cch32h,
                                 tmp12 = tmp12 + sr.ccg.ccg42h,
                                 tmp13 = tmp13 + l_tot[4],
                                 tmp14 = tmp14 + l_cch92h 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印合計 
         INITIALIZE l_tot TO NULL
         LET l_k = l_k + 1
         LET l_str = '9' CLIPPED       #合計:  #TQC-740065 mod   #No.FUN-7C0101 6->9
         LET l_tot[1] = sr.ccg.ccg12a+sr.ccg.ccg12b+sr.ccg.ccg12c+sr.ccg.ccg12d+
                        sr.ccg.ccg12e
                        +sr.ccg.ccg12f+sr.ccg.ccg12g+sr.ccg.ccg12h #No.FUN-7C0101 add
         LET l_tot[2] = sr.ccg.ccg22a+sr.ccg.ccg22b+sr.ccg.ccg22c+sr.ccg.ccg22d+
                        sr.ccg.ccg22e+sr.ccg.ccg22f+sr.ccg.ccg22g+sr.ccg.ccg22h+   #TQC-A40139 add
                        sr.ccg.ccg23a+sr.ccg.ccg23b+sr.ccg.ccg23c+sr.ccg.ccg23d+
                        sr.ccg.ccg23e
                        +sr.ccg.ccg23f+sr.ccg.ccg23g+sr.ccg.ccg23h #No.FUN-7C0101 add
         LET l_tot[3] = sr.ccg.ccg32a+sr.ccg.ccg32b+sr.ccg.ccg32c+sr.ccg.ccg32d+
                        sr.ccg.ccg32e
                        +sr.ccg.ccg32f+sr.ccg.ccg32g+sr.ccg.ccg32h #No.FUN-7C0101 add
         LET l_tot[4] = sr.ccg.ccg42a+sr.ccg.ccg42b+sr.ccg.ccg42c+sr.ccg.ccg42d+
                        sr.ccg.ccg42e
                        +sr.ccg.ccg42f+sr.ccg.ccg42g+sr.ccg.ccg42h #No.FUN-7C0101 add
         LET l_tot[5] = sr.ccg.ccg92a+sr.ccg.ccg92b+sr.ccg.ccg92c+sr.ccg.ccg92d+
                        sr.ccg.ccg92e
                        +sr.ccg.ccg92f+sr.ccg.ccg92g+sr.ccg.ccg92h #No.FUN-7C0101 add
         LET l_tot[7] = 0
         EXECUTE insert_prep1 USING       #No:CHI-9B0010 modify
              l_k,l_tot[7],l_buf,l_tot[6],l_str,l_tot[1],   #No:CHI-9B0010 modify
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                               #No.FUN-7C0101 add
        #---------------------No:CHI-9B0010 add
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
            UPDATE r773_tmp1 SET tmp06 = tmp06 + l_tot[1],
                                 tmp08 = tmp08 + l_tot[2],
                                 tmp10 = tmp10 + l_tot[3],
                                 tmp12 = tmp12 + l_tot[4],
                                 tmp13 = tmp13 + l_tot[5] 
                           WHERE tmp03 = l_buf 
                             AND tmp05 = l_str
                             AND tmp20 = sr.ccg.ccg07
         END IF
        #---------------------No:CHI-9B0010 end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
        #-----------------------No:CHI-9B0010 mark
        #LET l_k = l_k + 1
        #LET l_tot[7] = 1
        #EXECUTE insert_prep USING
        #     l_k,l_tot[7],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
        #     l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
        #     l_tot[6],l_tot[6],l_tot[6],
        #     g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''
        #     ,sr.ccg.ccg07                               #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
        #-----------------------No:CHI-9B0010 end
      END IF
      LET l_amt1 =sr.ccg.ccg22a + sr.ccg.ccg23a - l_cch22a
      LET l_amt2 =sr.ccg.ccg22b + sr.ccg.ccg23b - l_cch22b
      LET l_amt3 =sr.ccg.ccg22c + sr.ccg.ccg23c - l_cch22c
      LET l_amt4 =sr.ccg.ccg22d + sr.ccg.ccg23d - l_cch22d
      LET l_amt5 =sr.ccg.ccg22e + sr.ccg.ccg23e - l_cch22e
      LET l_amt6 =sr.ccg.ccg22f + sr.ccg.ccg23f - l_cch22f #No.FUN-7C0101 add
      LET l_amt7 =sr.ccg.ccg22g + sr.ccg.ccg23g - l_cch22g #No.FUN-7C0101 add
      LET l_amt8 =sr.ccg.ccg22h + sr.ccg.ccg23h - l_cch22h #No.FUN-7C0101 add
      INSERT INTO r773_tmp VALUES(sr.ccg.ccg01,l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6,l_amt7,l_amt8)  #TQC-740065 mod #No.FUN-7C0101
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
         UPDATE r773_tmp  SET amt1 = amt1 + l_amt1,
                              amt2 = amt2 + l_amt2,
                              amt3 = amt3 + l_amt3,
                              amt4 = amt4 + l_amt4, 
                              amt5 = amt5 + l_amt5
                             ,amt6 = amt6 + l_amt6, #No.FUN-7C0101 add
                              amt7 = amt7 + l_amt7, #No.FUN-7C0101 add
                              amt8 = amt8 + l_amt8  #No.FUN-7C0101 add
          WHERE wo  = sr.ccg.ccg01
      END IF
      LET l_subcch22a = l_subcch22a + l_cch22a
      LET l_subcch22b = l_subcch22b + l_cch22b
      LET l_subcch22c = l_subcch22c + l_cch22c
      LET l_subcch22d = l_subcch22d + l_cch22d
      LET l_subcch22e = l_subcch22e + l_cch22e
      LET l_subcch22f = l_subcch22f + l_cch22f #No.FUN-7C0101 add
      LET l_subcch22g = l_subcch22g + l_cch22g #No.FUN-7C0101 add
      LET l_subcch22h = l_subcch22h + l_cch22h #No.FUN-7C0101 add
      LET l_subcch32a = l_subcch32a + l_cch32a
      LET l_subcch32b = l_subcch32b + l_cch32b
      LET l_subcch32c = l_subcch32c + l_cch32c
      LET l_subcch32d = l_subcch32d + l_cch32d
      LET l_subcch32e = l_subcch32e + l_cch32e
      LET l_subcch32f = l_subcch32f + l_cch32f #No.FUN-7C0101 add
      LET l_subcch32g = l_subcch32g + l_cch32g #No.FUN-7C0101 add
      LET l_subcch32h = l_subcch32h + l_cch32h #No.FUN-7C0101 add
      LET l_subcch12a = l_subcch12a + l_cch12a
      LET l_subcch12b = l_subcch12b + l_cch12b
      LET l_subcch12c = l_subcch12c + l_cch12c
      LET l_subcch12d = l_subcch12d + l_cch12d
      LET l_subcch12e = l_subcch12e + l_cch12e
      LET l_subcch12f = l_subcch12f + l_cch12f #No.FUN-7C0101 add
      LET l_subcch12g = l_subcch12g + l_cch12g #No.FUN-7C0101 add
      LET l_subcch12h = l_subcch12h + l_cch12h #No.FUN-7C0101 add
      LET l_subcch92a = l_subcch92a + l_cch12a
      LET l_subcch92b = l_subcch92b + l_cch92b
      LET l_subcch92c = l_subcch92c + l_cch92c
      LET l_subcch92d = l_subcch92d + l_cch92d
      LET l_subcch92e = l_subcch92e + l_cch92e
      LET l_subcch92f = l_subcch92f + l_cch92f #No.FUN-7C0101 add
      LET l_subcch92g = l_subcch92g + l_cch92g #No.FUN-7C0101 add
      LET l_subcch92h = l_subcch92h + l_cch92h #No.FUN-7C0101 add
      LET l_totcch22a = l_totcch22a + l_cch22a
      LET l_totcch22b = l_totcch22b + l_cch22b
      LET l_totcch22c = l_totcch22c + l_cch22c
      LET l_totcch22d = l_totcch22d + l_cch22d
      LET l_totcch22e = l_totcch22e + l_cch22e
      LET l_totcch22f = l_totcch22f + l_cch22f #No.FUN-7C0101 add
      LET l_totcch22g = l_totcch22g + l_cch22g #No.FUN-7C0101 add
      LET l_totcch22h = l_totcch22h + l_cch22h #No.FUN-7C0101 add
      LET l_totcch32a = l_totcch32a + l_cch32a
      LET l_totcch32b = l_totcch32b + l_cch32b
      LET l_totcch32c = l_totcch32c + l_cch32c
      LET l_totcch32d = l_totcch32d + l_cch32d
      LET l_totcch32e = l_totcch32e + l_cch32e
      LET l_totcch32f = l_totcch32f + l_cch32f #No.FUN-7C0101 add
      LET l_totcch32g = l_totcch32g + l_cch32g #No.FUN-7C0101 add
      LET l_totcch32h = l_totcch32h + l_cch32h #No.FUN-7C0101 add
      LET l_totcch12a = l_totcch12a + l_cch12a
      LET l_totcch12b = l_totcch12b + l_cch12b
      LET l_totcch12c = l_totcch12c + l_cch12c
      LET l_totcch12d = l_totcch12d + l_cch12d
      LET l_totcch12e = l_totcch12e + l_cch12e
      LET l_totcch12f = l_totcch12f + l_cch12f #No.FUN-7C0101 add
      LET l_totcch12g = l_totcch12g + l_cch12g #No.FUN-7C0101 add
      LET l_totcch12h = l_totcch12h + l_cch12h #No.FUN-7C0101 add
      LET l_totcch92a = l_totcch92a + l_cch92a
      LET l_totcch92b = l_totcch92b + l_cch92b
      LET l_totcch92c = l_totcch92c + l_cch92c
      LET l_totcch92d = l_totcch92d + l_cch92d
      LET l_totcch92e = l_totcch92e + l_cch92e
      LET l_totcch92f = l_totcch92f + l_cch92f #No.FUN-7C0101 add
      LET l_totcch92g = l_totcch92g + l_cch92g #No.FUN-7C0101 add
      LET l_totcch92h = l_totcch92h + l_cch92h #No.FUN-7C0101 add
      LET l_sumcch22a = l_sumcch22a + l_cch22a
      LET l_sumcch22b = l_sumcch22b + l_cch22b
      LET l_sumcch22c = l_sumcch22c + l_cch22c
      LET l_sumcch22d = l_sumcch22d + l_cch22d
      LET l_sumcch22e = l_sumcch22e + l_cch22e
      LET l_sumcch22f = l_sumcch22f + l_cch22f #No.FUN-7C0101 add
      LET l_sumcch22g = l_sumcch22g + l_cch22g #No.FUN-7C0101 add
      LET l_sumcch22h = l_sumcch22h + l_cch22h #No.FUN-7C0101 add
      LET l_sumcch32a = l_sumcch32a + l_cch32a
      LET l_sumcch32b = l_sumcch32b + l_cch32b
      LET l_sumcch32c = l_sumcch32c + l_cch32c
      LET l_sumcch32d = l_sumcch32d + l_cch32d
      LET l_sumcch32e = l_sumcch32e + l_cch32e
      LET l_sumcch32f = l_sumcch32f + l_cch32f #No.FUN-7C0101 add
      LET l_sumcch32g = l_sumcch32g + l_cch32g #No.FUN-7C0101 add
      LET l_sumcch32h = l_sumcch32h + l_cch32h #No.FUN-7C0101 add
      LET l_sumcch12a = l_sumcch12a + l_cch12a
      LET l_sumcch12b = l_sumcch12b + l_cch12b
      LET l_sumcch12c = l_sumcch12c + l_cch12c
      LET l_sumcch12d = l_sumcch12d + l_cch12d
      LET l_sumcch12e = l_sumcch12e + l_cch12e
      LET l_sumcch12f = l_sumcch12f + l_cch12f #No.FUN-7C0101 add
      LET l_sumcch12g = l_sumcch12g + l_cch12g #No.FUN-7C0101 add
      LET l_sumcch12h = l_sumcch12h + l_cch12h #No.FUN-7C0101 add
      LET l_sumcch92a = l_sumcch92a + l_cch92a
      LET l_sumcch92b = l_sumcch92b + l_cch92b
      LET l_sumcch92c = l_sumcch92c + l_cch92c
      LET l_sumcch92d = l_sumcch92d + l_cch92d
      LET l_sumcch92e = l_sumcch92e + l_cch92e
      LET l_sumcch92f = l_sumcch92f + l_cch92f #No.FUN-7C0101 add
      LET l_sumcch92g = l_sumcch92g + l_cch92g #No.FUN-7C0101 add
      LET l_sumcch92h = l_sumcch92h + l_cch92h #No.FUN-7C0101 add
      LET l_subwoqty  = l_subwoqty + l_woqty
      LET l_subchg    = l_subchg   + l_chg
      LET l_totwoqty  = l_totwoqty + l_woqty
      LET l_totchg    = l_totchg   + l_chg
      LET l_sumwoqty  = l_sumwoqty + l_woqty
      LET l_sumchg    = l_sumchg   + l_chg

  #-----------------No:CHI-9B0010 add-----------------------
   AFTER GROUP OF sr.ccg.ccg01  
      IF tm.a = 'Y' THEN
         DECLARE r773_ccg01cur CURSOR FOR
                 SELECT * FROM r773_tmp1 WHERE tmp03 = sr.ccg.ccg01
         FOREACH r773_ccg01cur INTO sr1.*
             IF sr1.tmp05 != '0' THEN LET sr1.tmp03 = NULL END IF
             EXECUTE insert_prep USING sr1.*
         END FOREACH
         LET l_k = l_k + 1
         LET l_tot[7] = 1
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''   #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012   
              ,l_tot[6]                              
      END IF
  #-----------------No:CHI-9B0010 end-----------------------
 
   AFTER GROUP OF sr.sfb99  
      LET l_buf = ''
      IF sr.sfb99 = 'Y' THEN 
           LET l_buf = '2' CLIPPED  #重工工單小計數量  #TQC-740065 mod
      ELSE
           LET l_buf = '1' CLIPPED  #一般工單小計數量  #TQC-740065 mod  
      END IF
      #--->列印數量 
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '0' CLIPPED       #數量: #FUN-7B0042 add
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg11)
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg31)
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg91)
      LET l_tot[7] = 0   #FUN-7B0042 mod 2->0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_buf,l_str,l_tot[1],   #FUN-7B0042 mod
              l_tot[6],l_subwoqty,l_tot[6],l_tot[2],l_tot[6],
              l_subchg,l_tot[3],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印材料 
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '1' CLIPPED       #材料: #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12a)
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22a+sr.ccg.ccg23a)
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32a)
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42a)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92a)
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印人工
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '2' CLIPPED       #人工: #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12b)-l_subcch12b
      LET l_tot[2] = (GROUP SUM(sr.ccg.ccg22b+sr.ccg.ccg23b)-l_subcch22b)
      LET l_tot[3] = (GROUP SUM(sr.ccg.ccg32b)-l_subcch32b)
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42b)
      LET l_tot[5] = (GROUP SUM(sr.ccg.ccg92b)-l_subcch92b)
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12b,l_tot[2],l_subcch22b,l_tot[3],l_subcch32b,
              l_tot[4],l_tot[5],l_subcch92b,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費一
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '3' CLIPPED      #製費一:  #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12c)-l_subcch12c
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22c+sr.ccg.ccg23c)-l_subcch22c
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32c)-l_subcch32c
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42c)
      LEt l_tot[5] = GROUP SUM(sr.ccg.ccg92c)-l_subcch92c
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12c,l_tot[2],l_subcch22c,l_tot[3],l_subcch32c,
              l_tot[4],l_tot[5],l_subcch92c,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印加工
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '4' CLIPPED      #加工: #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12d)-l_subcch12d
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22d+sr.ccg.ccg23d)-l_subcch22d
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32d)-l_subcch32d
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42d)
      LEt l_tot[5] = GROUP SUM(sr.ccg.ccg92d)-l_subcch92d
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12d,l_tot[2],l_subcch22d,l_tot[3],l_subcch32d,
              l_tot[4],l_tot[5],l_subcch92d,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費二
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '5' CLIPPED      #製費二:  #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12e)-l_subcch12e
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22e+sr.ccg.ccg23e)-l_subcch22e
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32e)-l_subcch32e
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42e)
      LEt l_tot[5] = GROUP SUM(sr.ccg.ccg92e)-l_subcch92e
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12e,l_tot[2],l_subcch22e,l_tot[3],l_subcch32e,
              l_tot[4],l_tot[5],l_subcch92e,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費三
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '6' CLIPPED      #製費三:      #MOD-820006 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12f)-l_subcch12f
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22f+sr.ccg.ccg23f)-l_subcch22f
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32f)-l_subcch32f
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42f)
      LEt l_tot[5] = GROUP SUM(sr.ccg.ccg92f)-l_subcch92f
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12f,l_tot[2],l_subcch22f,l_tot[3],l_subcch32f,
              l_tot[4],l_tot[5],l_subcch92f,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''    #CHI-C30012   
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012   
              ,sr.ccg.ccg07                          
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費四
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '7' CLIPPED      #製費四:      #MOD-820006 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12g)-l_subcch12g
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22g+sr.ccg.ccg23g)-l_subcch22g
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32g)-l_subcch32g
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42g)
      LEt l_tot[5] = GROUP SUM(sr.ccg.ccg92g)-l_subcch92g
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12g,l_tot[2],l_subcch22g,l_tot[3],l_subcch32g,
              l_tot[4],l_tot[5],l_subcch92g,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012   
              ,sr.ccg.ccg07                     
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費五
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '8' CLIPPED      #製費五:      #MOD-820006 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12h)-l_subcch12h
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22h+sr.ccg.ccg23h)-l_subcch22h
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32h)-l_subcch32h
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42h)
      LEt l_tot[5] = GROUP SUM(sr.ccg.ccg92h)-l_subcch92h
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_subcch12h,l_tot[2],l_subcch22h,l_tot[3],l_subcch32h,
              l_tot[4],l_tot[5],l_subcch92h,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012    
              ,sr.ccg.ccg07 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印合計
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '9' CLIPPED      #No.FUN-7C0101 6->9
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12a)+GROUP SUM(sr.ccg.ccg12b)+
                     GROUP SUM(sr.ccg.ccg12c)+GROUP SUM(sr.ccg.ccg12d)+
                     GROUP SUM(sr.ccg.ccg12e)
                     +GROUP SUM(sr.ccg.ccg12f)+GROUP SUM(sr.ccg.ccg12g)+  #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg12h)                             #No.FUN-7C0101 add
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22a)+GROUP SUM(sr.ccg.ccg22b)+
                     GROUP SUM(sr.ccg.ccg22c)+GROUP SUM(sr.ccg.ccg22d)+
                     GROUP SUM(sr.ccg.ccg22e)+ 
                     GROUP SUM(sr.ccg.ccg22f)+GROUP SUM(sr.ccg.ccg22g)+   #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg22h)+                            #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg23a)+GROUP SUM(sr.ccg.ccg23b)+
                     GROUP SUM(sr.ccg.ccg23c)+GROUP SUM(sr.ccg.ccg23d)+ 
                     GROUP SUM(sr.ccg.ccg23e)
                     +GROUP SUM(sr.ccg.ccg23f)+GROUP SUM(sr.ccg.ccg23g)+  #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg23h)                             #No.FUN-7C0101 add
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32a)+GROUP SUM(sr.ccg.ccg32b)+
                     GROUP SUM(sr.ccg.ccg32c)+GROUP SUM(sr.ccg.ccg32d)+
                     GROUP SUM(sr.ccg.ccg32e)
                     +GROUP SUM(sr.ccg.ccg32f)+GROUP SUM(sr.ccg.ccg32g)+  #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg32h)                             #No.FUN-7C0101 add
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42a)+GROUP SUM(sr.ccg.ccg42b)+
                     GROUP SUM(sr.ccg.ccg42c)+GROUP SUM(sr.ccg.ccg42d)+
                     GROUP SUM(sr.ccg.ccg42e)
                     +GROUP SUM(sr.ccg.ccg42f)+GROUP SUM(sr.ccg.ccg42g)+  #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg42h)                             #No.FUN-7C0101 add
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92a)+GROUP SUM(sr.ccg.ccg92b)+
                     GROUP SUM(sr.ccg.ccg92c)+GROUP SUM(sr.ccg.ccg92d)+
                     GROUP SUM(sr.ccg.ccg92e)
                     +GROUP SUM(sr.ccg.ccg92f)+GROUP SUM(sr.ccg.ccg92g)+  #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg92h)                             #No.FUN-7C0101 add
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      LET l_k = l_k + 1
      LET l_tot[7] = 0   #FUN-7B0042 mod 1->0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
 
   AFTER GROUP OF sr.ima12  
      LET l_buf = ''
      IF NOT cl_null(sr.ima12) THEN
         SELECT azf03 INTO l_azf03 FROM azf_file
          WHERE azf01=sr.ima12 AND azf02='G'
         IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF
         LET l_buf = '3'                              #TQC-740065 mod
      END IF
      #--->列印數量 
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '0' CLIPPED       #數量: #FUN-7B0042 add
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg11)
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg31)
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg91)
      LET l_tot[7] = 0   #FUN-7B0042 mod 2->0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_buf,l_str,l_tot[1],    #FUN-7B0042 mod
              l_tot[6],l_totwoqty,l_tot[6],l_tot[2],l_tot[6],
              l_totchg,l_tot[3],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,l_azf03      #TQC-740065 add l_azf03  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印材料 
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '1' CLIPPED      #材料: #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12a)
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22a+sr.ccg.ccg23a)
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32a)
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42a)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92a)
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印人工
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '2' CLIPPED     #人工: #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12b)-l_totcch12b
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22b+sr.ccg.ccg23b)-l_totcch22b
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32b)-l_totcch32b
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42b)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92b)-l_totcch92b
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12b,l_tot[2],l_totcch22b,l_tot[3],l_totcch32b,
              l_tot[4],l_tot[5],l_totcch92b,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費一
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '3' CLIPPED      #製費一:   #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12c)-l_totcch12c
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22c+sr.ccg.ccg23c)-l_totcch22c
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32c)-l_totcch32c
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42c)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92c)-l_totcch92c
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12c,l_tot[2],l_totcch22c,l_tot[3],l_totcch32c,
              l_tot[4],l_tot[5],l_totcch92c,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印加工
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '4' CLIPPED      #加工:　#TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12d)-l_totcch12d
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22d+sr.ccg.ccg23d)-l_totcch22d
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32d)-l_totcch32d
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42d)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92d)-l_totcch92d
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12d,l_tot[2],l_totcch22d,l_tot[3],l_totcch32d,
              l_tot[4],l_tot[5],l_totcch92d,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費二
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '5' CLIPPED      #製費二: #TQC-740065 mod
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12e)-l_totcch12e
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22e+sr.ccg.ccg23e)-l_totcch22e
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32e)-l_totcch32e
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42e)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92e)-l_totcch92e
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12e,l_tot[2],l_totcch22e,l_tot[3],l_totcch32e,
              l_tot[4],l_tot[5],l_totcch92e,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費三
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '6' CLIPPED          #製費三:
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12f)-l_totcch12f
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22f+sr.ccg.ccg23f)-l_totcch22f
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32f)-l_totcch32f
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42f)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92f)-l_totcch92f
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12f,l_tot[2],l_totcch22f,l_tot[3],l_totcch32f,
              l_tot[4],l_tot[5],l_totcch92f,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012  
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012  
              ,sr.ccg.ccg07                        
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費四
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '7' CLIPPED          #製費四:
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12g)-l_totcch12g
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22g+sr.ccg.ccg23g)-l_totcch22g
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32g)-l_totcch32g
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42g)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92g)-l_totcch92g
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12g,l_tot[2],l_totcch22g,l_tot[3],l_totcch32g,
              l_tot[4],l_tot[5],l_totcch92g,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''   #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012    
              ,sr.ccg.ccg07                         
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費五
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '8' CLIPPED          #製費五:
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12h)-l_totcch12h
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22h+sr.ccg.ccg23h)-l_totcch22h
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32h)-l_totcch32h
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42h)
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92h)-l_totcch92h
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_totcch12h,l_tot[2],l_totcch22h,l_tot[3],l_totcch32h,
              l_tot[4],l_tot[5],l_totcch92h,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012    
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012    
              ,sr.ccg.ccg07                  
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印合計
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '9' CLIPPED            #TQC-740065 mod #No.FUN-7C0101 6->9
      LET l_tot[1] = GROUP SUM(sr.ccg.ccg12a)+GROUP SUM(sr.ccg.ccg12b)+
                     GROUP SUM(sr.ccg.ccg12c)+GROUP SUM(sr.ccg.ccg12d)+
                     GROUP SUM(sr.ccg.ccg12e)
                    +GROUP SUM(sr.ccg.ccg12f)+GROUP SUM(sr.ccg.ccg12g)+ #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg12h)                           #No.FUN-7C0101 add
      LET l_tot[2] = GROUP SUM(sr.ccg.ccg22a)+GROUP SUM(sr.ccg.ccg22b)+
                     GROUP SUM(sr.ccg.ccg22c)+GROUP SUM(sr.ccg.ccg22d)+
                     GROUP SUM(sr.ccg.ccg22e)+
                     GROUP SUM(sr.ccg.ccg22f)+GROUP SUM(sr.ccg.ccg22g)+ #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg22h)+                          #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg23a)+GROUP SUM(sr.ccg.ccg23b)+
                     GROUP SUM(sr.ccg.ccg23c)+GROUP SUM(sr.ccg.ccg23d)+ 
                     GROUP SUM(sr.ccg.ccg23e)
                    +GROUP SUM(sr.ccg.ccg23f)+GROUP SUM(sr.ccg.ccg23g)+ #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg23h)                           #No.FUN-7C0101 add
      LET l_tot[3] = GROUP SUM(sr.ccg.ccg32a)+GROUP SUM(sr.ccg.ccg32b)+
                     GROUP SUM(sr.ccg.ccg32c)+GROUP SUM(sr.ccg.ccg32d)+
                     GROUP SUM(sr.ccg.ccg32e)
                    +GROUP SUM(sr.ccg.ccg32f)+GROUP SUM(sr.ccg.ccg32g)+ #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg32h)                           #No.FUN-7C0101 add
      LET l_tot[4] = GROUP SUM(sr.ccg.ccg42a)+GROUP SUM(sr.ccg.ccg42b)+
                     GROUP SUM(sr.ccg.ccg42c)+GROUP SUM(sr.ccg.ccg42d)+
                     GROUP SUM(sr.ccg.ccg42e)
                    +GROUP SUM(sr.ccg.ccg42f)+GROUP SUM(sr.ccg.ccg42g)+ #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg42h)                           #No.FUN-7C0101 add
      LET l_tot[5] = GROUP SUM(sr.ccg.ccg92a)+GROUP SUM(sr.ccg.ccg92b)+
                     GROUP SUM(sr.ccg.ccg92c)+GROUP SUM(sr.ccg.ccg92d)+
                     GROUP SUM(sr.ccg.ccg92e)
                    +GROUP SUM(sr.ccg.ccg92f)+GROUP SUM(sr.ccg.ccg92g)+ #No.FUN-7C0101 add
                     GROUP SUM(sr.ccg.ccg92h)                           #No.FUN-7C0101 add
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      LET l_k = l_k + 1
      LET l_tot[7] = 0   #FUN-7B0042 mod 1->0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      # 拆出生產該分群碼中, 領用各分群碼各多少 
      # 如生產半成品中, 領用半成品/材料各多少
      LET l_buf = tm.wc
      LET l_j = length(l_buf)-2    #MOD-940183 
      FOR l_i=1 TO l_j 
         IF l_buf[l_i,l_i+2]='ima' THEN 
            IF l_i -1 = 0 THEN 
               LET l_buf = '  ',l_buf[l_i,300]
            ELSE 
               #表已判斷
               IF l_buf[l_i-1,l_i-1] = '.' THEN CONTINUE FOR END IF
               LET l_buf = l_buf[1,l_i-1],'  ',l_buf[l_i,300]
            END IF
            LET l_buf[l_i,l_i+4]='A.ima' 
         END IF
      END FOR
      LET l_sql =" SELECT B.ima12, ",
                 " SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),SUM(cch12e),SUM(cch12f),SUM(cch12g),SUM(cch12h),",#No.FUN-7C0101
                 " SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),SUM(cch22f),SUM(cch22g),SUM(cch22h),",#No.FUN-7C0101
                 " SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),SUM(cch32e),SUM(cch32f),SUM(cch32g),SUM(cch32h),",#No.FUN-7C0101
                 " SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),SUM(cch42e),SUM(cch42f),SUM(cch42g),SUM(cch42h),",#No.FUN-7C0101
                 " SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),SUM(cch92e),SUM(cch92f),SUM(cch92g),SUM(cch92h),",#No.FUN-7C0101
                 " SUM(cch12 ),SUM(cch22 ),SUM(cch32 ),SUM(cch42 ),SUM(cch92 ) ",
                #CHI-9B0031 mod --start--
                #" FROM ccg_file ,ima_file A, cch_file,ima_file B ,sfb_file ",
                 " FROM ccg_file LEFT JOIN sfb_file ON ccg01=sfb01,ima_file A, cch_file,ima_file B ", 
                #CHI-9B0031 mod --end--
                 " WHERE ccg04=A.ima01 AND cch04 = B.ima01 " ,
                #CHI-9B0031 mod --start--
                #"   AND ccg01=sfb01 AND A.ima12 ='" ,sr.ima12,"' ",
                 "   AND A.ima12 ='" ,sr.ima12,"' ",
                #CHI-9B0031 mod --end--
                 "   AND ccg02 = ", tm.yy ,
                 "   AND ccg03 = ", tm.mm ,
                 "   AND ccg01 = cch01 ",
                 "   AND ccg02 = cch02 ",
                 "   AND ccg03 = cch03 ",
                 "   AND ccg06='",tm.type1,"'", #No.FUN-7C0101 add
                 "   AND cch06='",tm.type1,"'", #No.FUN-7C0101 add
                 "   AND ", l_buf CLIPPED,
                 " GROUP BY B.ima12 "
      IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
      PREPARE axcr773_prepare4 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
      END IF
      DECLARE axcr773_curs4 CURSOR FOR axcr773_prepare4
     #LET l_buf = '生產：',l_azf03 CLIPPED,'細項：'                 #FUN-710080 mark
      LET l_buf = '4'                                               #TQC-740065 mod  #FUN-710080 add
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
             l_k,l_tot[7],l_tot[6],l_buf,l_tot[6],l_tot[6],
             l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
             l_tot[6],l_tot[6],l_tot[6],
             #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,l_azf03      #TQC-740065 add l_azf03  #CHI-C30012
             g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,l_azf03  #CHI-C30012
             ,sr.ccg.ccg07                            #No.FUN-7C0101 add 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      FOREACH axcr773_curs4 INTO l_ima12, 
                a_cch12a,a_cch12b,a_cch12c,a_cch12d,a_cch12e,
                a_cch12f,a_cch12g,a_cch12h,                   #No.FUN-7C0101 add
                a_cch22a,a_cch22b,a_cch22c,a_cch22d,a_cch22e,
                a_cch22f,a_cch22g,a_cch22h,                   #No.FUN-7C0101 add
                a_cch32a,a_cch32b,a_cch32c,a_cch32d,a_cch32e,
                a_cch32f,a_cch32g,a_cch32h,                   #No.FUN-7C0101 add
                a_cch42a,a_cch42b,a_cch42c,a_cch42d,a_cch42e,
                a_cch42f,a_cch42g,a_cch42h,                   #No.FUN-7C0101 add
                a_cch92a,a_cch92b,a_cch92c,a_cch92d,a_cch92e ,
                a_cch92f,a_cch92g,a_cch92h,                   #No.FUN-7C0101 add
                a_cch12 ,a_cch22 ,a_cch32 ,a_cch42 ,a_cch92 
         IF NOT cl_null(l_ima12) THEN
            SELECT azf03 INTO l_azf03 FROM azf_file 
             WHERE azf01=l_ima12 AND azf02='G'
            IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF
   
            LET l_buf = '5'                               #TQC-740065 mod #FUN-710080 add
         ELSE                 #FUN-7B0042 add
            LET l_buf = ' '   #FUN-7B0042 add
         END IF
         #--->列印材料 
         LET l_k = l_k + 1
         LET l_str = '1' CLIPPED      #材料: #TQC-740065 mod
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_buf,l_str,a_cch12a,
              l_tot[6],a_cch22a,l_tot[6],a_cch32a,l_tot[6],
              a_cch42a,a_cch92a,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,l_azf03     #TQC-740065 add l_azf03  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,l_azf03  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add 
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印人工
         LET l_k = l_k + 1
         LET l_str = '2' CLIPPED       #人工: #TQC-740065 mod
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12b,
              l_tot[6],a_cch22b,l_tot[6],a_cch32b,l_tot[6],
              a_cch42b,a_cch92b,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費一
         LET l_k = l_k + 1
         LET l_str = '3' CLIPPED       #製費一:  #TQC-740065 mod
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12c,
              l_tot[6],a_cch22c,l_tot[6],a_cch32c,l_tot[6],
              a_cch42c,a_cch92c,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印加工
         LET l_k = l_k + 1
         LET l_str = '4' CLIPPED      #加工:  #TQC-740065 mod
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12d,
              l_tot[6],a_cch22d,l_tot[6],a_cch32d,l_tot[6],
              a_cch42d,a_cch92d,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費二
         LET l_k = l_k + 1
         LET l_str = '5' CLIPPED      #製費二: #TQC-740065 mod
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12e,
              l_tot[6],a_cch22e,l_tot[6],a_cch32e,l_tot[6],
              a_cch42e,a_cch92e,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費三
         LET l_k = l_k + 1
         LET l_str = '6' CLIPPED       #製費三:
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12f,  #MOD-820006 mod
              l_tot[6],a_cch22f,l_tot[6],a_cch32f,l_tot[6],   #MOD-820006 mod
              a_cch42f,a_cch92f,l_tot[6],                     #MOD-820006 mod
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                       
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費四
         LET l_k = l_k + 1
         LET l_str = '7' CLIPPED       #製費四:
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12g,  #MOD-820006 mod
              l_tot[6],a_cch22g,l_tot[6],a_cch32g,l_tot[6],   #MOD-820006 mod
              a_cch42g,a_cch92g,l_tot[6],                     #MOD-820006 mod
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''   #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                       
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印製費五
         LET l_k = l_k + 1
         LET l_str = '8' CLIPPED       #製費五:
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12h,  #MOD-820006 mod
              l_tot[6],a_cch22h,l_tot[6],a_cch32h,l_tot[6],   #MOD-820006 mod
              a_cch42h,a_cch92h,l_tot[6],                     #MOD-820006 mod
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                       
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         #--->列印合計
         LET l_k = l_k + 1
         LET l_str = '9' CLIPPED      #合計: #TQC-740065 mod
         LET l_tot[7] = 0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,a_cch12,
              l_tot[6],a_cch22,l_tot[6],a_cch32,l_tot[6],
              a_cch42,a_cch92,l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
         LET l_k = l_k + 1
         LET l_tot[7] = 0   #FUN-7B0042 mod 1->0
         EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(l_k,'9052',1)
         END IF
      END FOREACH 
 
   ON LAST ROW
      #--->列印數量 
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_buf = '6' CLIPPED        #總計  #TQC-740065 mod 
      LET l_str = '0' CLIPPED       #數量: #FUN-7B0042 add
      LET l_tot[1] = SUM(sr.ccg.ccg11)
      LET l_tot[2] = SUM(sr.ccg.ccg31)
      LET l_tot[3] = SUM(sr.ccg.ccg91)
      LET l_tot[7] = 0   #FUN-7B0042 mod 2->0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_buf,l_str,l_tot[1],   #TQC-740065 mod   #FUN-7B0042 mod
              l_tot[6],l_sumwoqty,l_tot[6],l_tot[2],l_tot[6],
              l_sumchg,l_tot[3],l_tot[6], 
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''        #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印材料 
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '1' CLIPPED      #材料: #TQC-740065 mod
      LET l_tot[1] = SUM(sr.ccg.ccg12a)
      LET l_tot[2] = SUM(sr.ccg.ccg22a+sr.ccg.ccg23a)
      LET l_tot[3] = SUM(sr.ccg.ccg32a)
      LET l_tot[4] = SUM(sr.ccg.ccg42a)
      LET l_tot[5] = SUM(sr.ccg.ccg92a)
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印人工
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '2' CLIPPED      #人工: #TQC-740065 mod
      LET l_tot[1] = SUM(sr.ccg.ccg12b)-l_sumcch12b
      LET l_tot[2] = SUM(sr.ccg.ccg22b+sr.ccg.ccg23b) - l_sumcch22b
      LET l_tot[3] = SUM(sr.ccg.ccg32b)-l_sumcch32b
      LET l_tot[4] = SUM(sr.ccg.ccg42b)
      LET l_tot[5] = SUM(sr.ccg.ccg92b)-l_sumcch92b
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12b,l_tot[2],l_sumcch22b,l_tot[3],l_sumcch32b,
              l_tot[4],l_tot[5],l_sumcch92b,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費一
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '3' CLIPPED     #製費一: #TQC-740065 mod
      LET l_tot[1] = SUM(sr.ccg.ccg12c)-l_sumcch12c
      LET l_tot[2] = SUM(sr.ccg.ccg22c+sr.ccg.ccg23c) - l_sumcch22c
      LET l_tot[3] = SUM(sr.ccg.ccg32c)-l_sumcch32c
      LET l_tot[4] = SUM(sr.ccg.ccg42c)
      LET l_tot[5] = SUM(sr.ccg.ccg92c)-l_sumcch92c
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12c,l_tot[2],l_sumcch22c,l_tot[3],l_sumcch32c,
              l_tot[4],l_tot[5],l_sumcch92c,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印加工
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '4' CLIPPED      #加工: #TQC-740065 mod
      LET l_tot[1] = SUM(sr.ccg.ccg12d)-l_sumcch12d
      LET l_tot[2] = SUM(sr.ccg.ccg22d+sr.ccg.ccg23d) -l_sumcch22d
      LET l_tot[3] = SUM(sr.ccg.ccg32d)-l_sumcch32d
      LET l_tot[4] = SUM(sr.ccg.ccg42d)
      LET l_tot[5] = SUM(sr.ccg.ccg92d)-l_sumcch92d
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12d,l_tot[2],l_sumcch22d,l_tot[3],l_sumcch32d,
              l_tot[4],l_tot[5],l_sumcch92d,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費二
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '5' CLIPPED     #製費二:  #TQC-740065 mod
      LET l_tot[1] = SUM(sr.ccg.ccg12e)-l_sumcch12e
      LET l_tot[2] = SUM(sr.ccg.ccg22e+sr.ccg.ccg23e) -l_sumcch22e
      LET l_tot[3] = SUM(sr.ccg.ccg32e)-l_sumcch32e
      LET l_tot[4] = SUM(sr.ccg.ccg42e)
      LET l_tot[5] = SUM(sr.ccg.ccg92e)-l_sumcch92e
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12e,l_tot[2],l_sumcch22e,l_tot[3],l_sumcch32e,
              l_tot[4],l_tot[5],l_sumcch92e,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add '' #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費三
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '6' CLIPPED          #製費三:
      LET l_tot[1] = SUM(sr.ccg.ccg12f)-l_sumcch12f
      LET l_tot[2] = SUM(sr.ccg.ccg22f+sr.ccg.ccg23f) -l_sumcch22f
      LET l_tot[3] = SUM(sr.ccg.ccg32f)-l_sumcch32f
      LET l_tot[4] = SUM(sr.ccg.ccg42f)
      LET l_tot[5] = SUM(sr.ccg.ccg92f)-l_sumcch92f
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12f,l_tot[2],l_sumcch22f,l_tot[3],l_sumcch32f,
              l_tot[4],l_tot[5],l_sumcch92f,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''   #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07           
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費四
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '7' CLIPPED          #製費四:
      LET l_tot[1] = SUM(sr.ccg.ccg12g)-l_sumcch12g
      LET l_tot[2] = SUM(sr.ccg.ccg22g+sr.ccg.ccg23g) -l_sumcch22g
      LET l_tot[3] = SUM(sr.ccg.ccg32g)-l_sumcch32g
      LET l_tot[4] = SUM(sr.ccg.ccg42g)
      LET l_tot[5] = SUM(sr.ccg.ccg92g)-l_sumcch92g
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12g,l_tot[2],l_sumcch22g,l_tot[3],l_sumcch32g,
              l_tot[4],l_tot[5],l_sumcch92g,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,'' #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07           
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印製費五
      INITIALIZE l_tot TO NULL
      LET l_k = l_k + 1
      LET l_str = '8' CLIPPED          #製費五:
      LET l_tot[1] = SUM(sr.ccg.ccg12h)-l_sumcch12h
      LET l_tot[2] = SUM(sr.ccg.ccg22h+sr.ccg.ccg23h) -l_sumcch22h
      LET l_tot[3] = SUM(sr.ccg.ccg32h)-l_sumcch32h
      LET l_tot[4] = SUM(sr.ccg.ccg42h)
      LET l_tot[5] = SUM(sr.ccg.ccg92h)-l_sumcch92h
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_sumcch12h,l_tot[2],l_sumcch22h,l_tot[3],l_sumcch32h,
              l_tot[4],l_tot[5],l_sumcch92h,
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''  #CHI-C30012
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07           
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      #--->列印合計
      INITIALIZE l_tot TO NULL
      LET l_str = '9' CLIPPED      #合計: #TQC-740065 mod  #No.FUN-7C0101 6->9
      LET l_k = l_k + 1
      LET l_tot[1] = SUM(sr.ccg.ccg12a)+SUM(sr.ccg.ccg12b)+
                     SUM(sr.ccg.ccg12c)+SUM(sr.ccg.ccg12d)+SUM(sr.ccg.ccg12e)
                    +SUM(sr.ccg.ccg12f)+SUM(sr.ccg.ccg12g)+SUM(sr.ccg.ccg12h) #No.FUN-7C0101 add
      LET l_tot[2] = SUM(sr.ccg.ccg22a)+SUM(sr.ccg.ccg22b)+
                     SUM(sr.ccg.ccg22c)+SUM(sr.ccg.ccg22d)+
                    #-----------------No:TQC-A40139 add
                     SUM(sr.ccg.ccg22e)+SUM(sr.ccg.ccg22f)+
                     SUM(sr.ccg.ccg22g)+SUM(sr.ccg.ccg22h)+
                    #-----------------No:TQC-A40139 end
                     SUM(sr.ccg.ccg23a)+SUM(sr.ccg.ccg23b)+
                     SUM(sr.ccg.ccg23c)+SUM(sr.ccg.ccg23d)+SUM(sr.ccg.ccg23e)
                    +SUM(sr.ccg.ccg23f)+SUM(sr.ccg.ccg23g)+SUM(sr.ccg.ccg23h) #No.FUN-7C0101 add
      LET l_tot[3] = SUM(sr.ccg.ccg32a)+SUM(sr.ccg.ccg32b)+
                     SUM(sr.ccg.ccg32c)+SUM(sr.ccg.ccg32d)+SUM(sr.ccg.ccg32e)
                    +SUM(sr.ccg.ccg32f)+SUM(sr.ccg.ccg32g)+SUM(sr.ccg.ccg32h) #No.FUN-7C0101 add
      LET l_tot[4] = SUM(sr.ccg.ccg42a)+SUM(sr.ccg.ccg42b)+
                     SUM(sr.ccg.ccg42c)+SUM(sr.ccg.ccg42d)+SUM(sr.ccg.ccg42e)
                    +SUM(sr.ccg.ccg42f)+SUM(sr.ccg.ccg42g)+SUM(sr.ccg.ccg42h) #No.FUN-7C0101 add
      LET l_tot[5] = SUM(sr.ccg.ccg92a)+SUM(sr.ccg.ccg92b)+
                     SUM(sr.ccg.ccg92c)+SUM(sr.ccg.ccg92d)+SUM(sr.ccg.ccg92e)
                    +SUM(sr.ccg.ccg92f)+SUM(sr.ccg.ccg92g)+SUM(sr.ccg.ccg92h) #No.FUN-7C0101 add
      LET l_tot[7] = 0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_str,l_tot[1],
              l_tot[6],l_tot[2],l_tot[6],l_tot[3],l_tot[6],
              l_tot[4],l_tot[5],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      LET l_k = l_k + 1
      LET l_tot[7] = 0   #FUN-7B0042 mod 1->0
      EXECUTE insert_prep USING
              l_k,l_tot[7],l_tot[6],l_tot[6],l_tot[6],l_tot[1],
              l_tot[6],l_tot[6],l_tot[6],l_tot[6],l_tot[6],
              l_tot[6],l_tot[6],l_tot[6],
              #g_azi03,g_azi04,g_azi05,g_ccz.ccz27,''      #TQC-740065 add ''  #CHI-C30012 
              g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27,''  #CHI-C30012 
              ,sr.ccg.ccg07                            #No.FUN-7C0101 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(l_k,'9052',1)
      END IF
      LET l_last_sw='y'
 
END REPORT
 
 
FUNCTION r773_outnam()
   DEFINE l_name            LIKE type_file.chr20,
          l_sw              LIKE type_file.chr1,
          l_n               LIKE type_file.num5,
          l_waitsec         LIKE type_file.num5,
          l_buf             LIKE type_file.chr6,
          l_n2              LIKE type_file.num5
#TQC-C20374--------add--------Begin------
   DEFINE p_code                LIKE zz_file.zz01,  
          l_chr                 LIKE type_file.chr1,
          l_cnt                 LIKE type_file.num5,
          l_zaa02               LIKE type_file.num5,
          l_zaa08               LIKE type_file.chr1000,
          l_cmd                 LIKE type_file.chr1000,
          l_zaa08_s             STRING,
          l_zaa14               LIKE zaa_file.zaa14,
          l_zaa16               LIKE zaa_file.zaa16,
          l_cust                LIKE type_file.num5,
          l_sql                 STRING
   DEFINE l_gay03               LIKE gay_file.gay03
   DEFINE l_str                 STRING
   DEFINE l_azp02               LIKE azp_file.azp02
#TQC-C20374--------add--------End--------
 
   SELECT zz06 INTO l_sw FROM zz_FILE WHERE zz01 = g_prog
   IF l_sw = '1' THEN
      LET l_name = g_prog CLIPPED,'.out'
   ELSE
      SELECT zz16,zz24  INTO l_n,l_waitsec FROM zz_FILE WHERE zz01 = g_prog
      IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
      LET l_n = l_n + 1
      IF l_n > 30000 THEN  LET l_n = 0  END IF
      LET l_buf = l_n USING "&&&&&&"
      IF g_aza.aza49 = '1' THEN   #01r-09r
         LET l_name = g_prog CLIPPED,".0",l_buf[6,6],"r"
      ELSE
         CASE g_aza.aza49
            WHEN '2'   #01r-19r
                 LET l_n2 = l_n MOD 20
            WHEN '3'   #01r-29r
                 LET l_n2 = l_n MOD 30
            WHEN '4'   #01r-39r
                 LET l_n2 = l_n MOD 40
            WHEN '5'   #01r-49r
                 LET l_n2 = l_n MOD 50
         END CASE
         LET l_buf = l_n2 USING "&&&&&&"
         LET l_name = g_prog CLIPPED,".",l_buf[5,6],"r"
      END IF
   END IF
   UPDATE zz_file SET zz16 = l_n WHERE zz01 = g_prog
#TQC-C20374--------add--------Begin---------------------------------------
   LET g_memo = ""
   SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang
   IF not SQLCA.sqlcode AND l_cnt>0 THEN   ## get data from zaa_file
      SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa11 = 'voucher'
      IF l_cnt > 0 THEN   ## voucher
         SELECT count(*) INTO l_cnt FROM zaa_file
              WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04='default' AND
                    zaa11 = 'voucher' AND zaa10='Y'
         IF l_cnt > 0 THEN  ## customerize
            LET g_zaa10_value = 'Y'
         ELSE
            LET g_zaa10_value = 'N'
         END IF
         CASE cl_db_get_database_type() 
            WHEN "ORA"
               LET l_sql = "SELECT count(*) FROM ",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                           "' OR zaa17= '",g_clas CLIPPED,"'))" 
            WHEN "IFX"
               LET l_sql = "SELECT count(*) FROM table(multiset",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                           "' OR zaa17= '",g_clas CLIPPED,"')))" 
            WHEN "MSV"
               LET l_sql = "( SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
                                 " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
            WHEN "ASE"   
               LET l_sql = " SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
                                 " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
         END CASE   
         PREPARE zaa_pre1 FROM l_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err("prepare zaa_cur4: ", SQLCA.SQLCODE, 0)
            #RETURN FALSE
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM      

         END IF
         EXECUTE zaa_pre1 INTO l_cust
          IF cl_null(g_bgjob) OR g_bgjob = 'N' OR  
            (g_bgjob='Y' AND (cl_null(g_rep_user) OR cl_null(g_rep_clas)
             OR cl_null(g_template)))
         THEN

            IF l_cust > 1 THEN
               CALL cl_prt_pos_t()
            ELSE
               SELECT unique zaa04,zaa17 INTO g_zaa04_value,g_zaa17_value
               FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10 =
                   g_zaa10_value AND ((zaa04='default' AND zaa17='default')
                   OR zaa04 =g_user OR zaa17= g_clas )
            END IF
         ELSE  
            SELECT unique zaa04,zaa17 INTO g_zaa04_value,g_zaa17_value
            FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang
             AND zaa10 = g_zaa10_value AND zaa11 = g_template
             AND zaa04 = g_rep_user AND zaa17 = g_rep_clas
         END IF

         DECLARE zaa_cur CURSOR FOR
          SELECT zaa02,zaa08,zaa14,zaa16 FROM zaa_file
           WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND
                 zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value
           ORDER BY zaa02
         FOREACH zaa_cur INTO l_zaa02,l_zaa08,l_zaa14,l_zaa16
            IF SQLCA.SQLCODE THEN
               CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
               EXIT PROGRAM
            END IF
            LET l_zaa08 = cl_outnam_zab(l_zaa08,l_zaa14,l_zaa16)
            LET l_zaa08_s = l_zaa08 CLIPPED
            LET g_x[l_zaa02] = l_zaa08_s
         END FOREACH
         ### for g_page_line ###
          SELECT unique zaa12,zaa19,zaa20,zaa21 into g_page_line,g_left_margin,g_top_margin,g_bottom_margin 
          FROM zaa_file   #MOD-560029
          WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND
                zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value

         SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = g_prog
      ELSE
        LET g_xml_rep = l_name CLIPPED,".xml"
        CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED))
        CALL cl_prt_pos(p_code)
      END IF
   END IF
   LET l_str = p_code
   IF l_str.subString(4,4) != 'p' AND g_x.getLength() = 0 THEN
      SELECT gay03 INTO l_gay03 FROM gay_file
        WHERE gay01 = g_rlang AND gayacti = "Y" 
      LET l_str = g_rlang CLIPPED, ":",l_gay03 CLIPPED
      CALL cl_err_msg(g_prog,'lib-358',l_str,10)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   IF g_page_line = 0 or g_page_line is null THEN
      LET g_page_line = 66
   END IF
   LET g_line = g_page_line
   IF g_left_margin IS NULL THEN
      LET g_left_margin = 0
   END IF

   IF g_top_margin IS NULL THEN
      LET g_top_margin = 1 #預設報表上邊界為1
   END IF
   IF g_bottom_margin IS NULL THEN
      LET g_bottom_margin = 5 #預設報表下邊界為5
   END IF

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   LET g_company = g_company CLIPPED,"[",g_plant CLIPPED,":",l_azp02 CLIPPED,"]"
#TQC-C20374--------add--------End-----------------------------------------  
   RETURN l_name
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12
