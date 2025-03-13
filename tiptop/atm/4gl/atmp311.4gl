# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmp311.4gl
# Descriptions...: 銷貨銷退產生作業
# Date & Author..: 06/04/20 By Sarah
# Modify.........: No.FUN-640014 06/04/20 By Sarah 新增"銷貨銷退產生作業"
# Modify.........: NO.FUN-630015 06/05/24 BY yiting s_rdate2改call s_rdatem.4gl
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680022 06/08/30 By Tracy s_rdatem()增加一個參數 
# Modify.........: No.FUN-680120 06/09/11 By chen 類型轉換
# Modify.........: No.TQC-690044 06/09/12 By Sarah 當tut08=1時,產生一張出貨單,tut08=2時,產生一張銷退單
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.FUN-710033 07/01/19 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.CHI-710059 07/02/02 By jamie ogb14應為ogb917*ogb13
# Modify.........: No.MOD-740426 07/04/26 By Sarah 當執行後都沒有產生銷貨單或銷退單時,才show aap-129 
# Modify.........: No.MOD-790101 07/09/19 By claire oga162=100轉無訂單出貨單才合理
# Modify.........: No.MOD-790141 07/09/27 By Carol 產生的銷退單銷退方式改為1.銷退折讓
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-8B0287 08/11/28 By sherry 沒有給ogb1005,ogb1006,ogb1012賦值，這樣會造成后續這張出貨單無法立賬   
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.MOD-940188 09/04/14 By Dido oga31 請帶預設值-occ44
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Mofify.........: No.FUN-980020 09/09/10 By douzh 集團架構調整sub相關修改
# Modify.........: No.FUN-AB0061 10/11/16 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50,ohb71的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.TQC-AB0378 10/12/09 By huangtao 取價改成CALL s_fetch_price_new
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:CHI-B70039 11/08/17 By johung 金額 = 計價數量 x 單價
# Modify.........: No:MOD-B80124 11/08/17 By johung 產生無訂單出貨單時，輸入日期預設為g_today
# Modify.........: No.FUN-BB0085 11/12/20 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-910088 11/12/21 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BC0071 12/02/08 By huangtao 取價添加攤位字段 
# Modify.........: No.MOD-C50203 12/05/28 By Vampire oga32帶客戶基本資料的慣用收款條件occ45
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善  qiull 理由碼插入ohb_file時default值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD			          # Print condition RECORD
               wc          STRING,                # Where condition
               oga01       LIKE oga_file.oga01,   # 出貨單別
               oga02       LIKE oga_file.oga02,   # 出貨日期
               oha01       LIKE oha_file.oha01,   # 銷退單別
               oha02       LIKE oha_file.oha02    # 銷退日期
              END RECORD,
       g_tus  RECORD       LIKE tus_file.*,       #客戶庫存調整單頭檔
       g_tut  RECORD       LIKE tut_file.*,       #客戶庫存調整單身檔
       g_oga  RECORD       LIKE oga_file.*,       #出貨單頭
       g_ogb  RECORD       LIKE ogb_file.*,       #出貨單身
       g_oha  RECORD       LIKE oha_file.*,       #銷退單頭
       g_ohb  RECORD       LIKE ohb_file.*,       #銷退單身
       start_no1,end_no1   LIKE oga_file.oga01,
       start_no2,end_no2   LIKE oha_file.oha01
DEFINE g_sql               STRING 
DEFINE g_dbs2              LIKE type_file.chr30   #TQC-680074
DEFINE g_plant2            LIKE type_file.chr10   #FUN-980020
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   OPEN WINDOW p311_w WITH FORM "atm/42f/atmp311"
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
#  #-----TQC-680074--------- 
#  IF cl_db_get_database_type() = 'IFX' THEN
#     LET g_dbs2 = g_dbs CLIPPED,':'
#  ELSE
#     LET g_dbs2 = g_dbs CLIPPED,'.'
#  END IF
#  #-----END TQC-680074-----
   LET g_plant2 = g_plant                    #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-920166
 
   CALL p311()
 
   CLOSE WINDOW p311_w                                                                                                      
   EXIT PROGRAM
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION p311() 
   DEFINE l_flag       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
          l_i          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          li_result    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          g_t1         LIKE oay_file.oayslip
 
   WHILE TRUE
      LET g_action_choice = ""
      CLEAR FORM
 
      CONSTRUCT BY NAME tm.wc ON tus03,tus09,tus02  
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tus03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tus03
                  NEXT FIELD tus03
               WHEN INFIELD(tus09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tus09
                  NEXT FIELD tus09
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about  
            CALL cl_about()
 
         ON ACTION help  
            CALL cl_show_help()
 
         ON ACTION controlg 
            CALL cl_cmdask() 
          
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tususer', 'tusgrup') #FUN-980030
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN RETURN END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET start_no1 = NULL 
      LET end_no1   = NULL
      LET start_no2 = NULL 
      LET end_no2   = NULL
      LET tm.oga02  = g_today
      LET tm.oha02  = g_today
      DISPLAY g_today TO oga02
      DISPLAY g_today TO oha02
 
      INPUT BY NAME tm.oga01,tm.oga02,tm.oha01,tm.oha02 WITHOUT DEFAULTS
         BEFORE INPUT 
            CALL cl_set_doctype_format("oga01")
            CALL cl_set_doctype_format("oha01")
 
         AFTER FIELD oga01 
            IF NOT cl_null(tm.oga01) THEN
               CALL s_check_no("AXM",tm.oga01,"",'50',"oga_file","oga01","")
                  RETURNING li_result,tm.oga01
               DISPLAY tm.oga01 TO oga01
               IF (NOT li_result) THEN
                  NEXT FIELD oga01
               END IF
            ELSE
               CALL cl_err('','mfg0037',0)
               NEXT FIELD oga01
            END IF
 
         AFTER FIELD oga02 
            IF cl_null(tm.oga02) THEN
               CALL cl_err('','mfg0037',0)
               NEXT FIELD oga02
            END IF
 
         AFTER FIELD oha01 
            IF NOT cl_null(tm.oha01) THEN
               CALL s_check_no("AXM",tm.oha01,"",'60',"oha_file","oha01","")
                  RETURNING li_result,tm.oha01
               DISPLAY tm.oha01 TO oha01
               IF (NOT li_result) THEN
                  NEXT FIELD oha01
               END IF
            ELSE
               CALL cl_err('','mfg0037',0)
               NEXT FIELD oha01
            END IF
 
         AFTER FIELD oha02 
            IF cl_null(tm.oha02) THEN
               CALL cl_err('','mfg0037',0)
               NEXT FIELD oha02
            END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                  CALL q_oay(FALSE,FALSE,g_t1,'50','AXM') RETURNING g_t1
                  LET tm.oga01 = g_t1
                  DISPLAY tm.oga01 TO oga01
                  NEXT FIELD oga01
               WHEN INFIELD(oha01)
                  CALL q_oay(FALSE,FALSE,g_t1,'60','AXM') RETURNING g_t1
                  LET tm.oha01 = g_t1
                  DISPLAY tm.oha01 TO oha01
                  NEXT FIELD oha01
            END CASE
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about  
            CALL cl_about()
 
         ON ACTION help  
            CALL cl_show_help()
 
         ON ACTION controlg 
            CALL cl_cmdask() 
 
      END INPUT
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         RETURN 
      END IF
 
      IF cl_sure(20,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p311_process()
         CALL s_showmsg()        #No.FUN-710033
         IF g_success = 'Y' THEN
            DISPLAY start_no1 TO start_no1
            DISPLAY end_no1 TO end_no1
            DISPLAY start_no2 TO start_no2
            DISPLAY end_no2 TO end_no2
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN 
            CONTINUE WHILE
         ELSE
            EXIT WHILE 
         END IF
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p311_process()
   DEFINE l_change      LIKE type_file.chr1      #No.FUN-680120 VARCHAR(1)   #TQC-690044 add
 
   LET l_change = 'N'   #TQC-690044 add
 
   LET g_sql = "SELECT tus_file.*,tut_file.* FROM tus_file,tut_file",
               " WHERE tus01=tut01",
               "   AND tusconf='Y'",
               "   AND tuspost='Y'",
               "   AND tus12='N'",
               "   AND tus08='2'",
               "   AND ",tm.wc CLIPPED
 
   PREPARE p311_prepare FROM g_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p311_cs CURSOR WITH HOLD FOR p311_prepare
   CALL s_showmsg_init()             # No.FUN-710033
   FOREACH p311_cs INTO g_tus.*,g_tut.* 
      #NO. FUN-710033--BEGIN          
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
      #NO. FUN-710033--END
      IF SQLCA.sqlcode THEN 
#        CALL cl_err('prepare:',SQLCA.sqlcode,1)  #NO. FUN-710033
         CALL s_errmsg('','','',SQLCA.sqlcode,1) #NO. FUN-710033 
         LET g_success = 'N'
         RETURN 
      END IF
 
      #當庫存異動類別tut08=1.客戶銷售時,產生一張出貨單
      IF g_tut.tut08='1' THEN    #TQC-690044 add
         #產生無訂單出貨單
         INITIALIZE g_oga.*  LIKE oga_file.*   #DEFAULT 設定
         CALL p311_ins_oga()   #無訂單出貨單
         CALL p311_upd_oga()
         LET l_change = 'Y'      #TQC-690044 add
      END IF                     #TQC-690044 add
 
      #當庫存異動類別tut08=2.客戶銷退時,產生一張銷退單
      IF g_tut.tut08='2' THEN    #TQC-690044 add
         #產生銷退單
         INITIALIZE g_oha.*  LIKE oha_file.*   #DEFAULT 設定
         CALL p311_ins_oha()   #銷退單
         CALL p311_upd_oha()
         LET l_change = 'Y'      #TQC-690044 add
      END IF                     #TQC-690044 add
 
      IF l_change = 'Y' THEN     #TQC-690044 add
         UPDATE tus_file SET tus12 = 'Y' WHERE tus01 = g_tus.tus01
         IF SQLCA.sqlcode THEN
#           CALL cl_err('update tus_file',SQLCA.sqlcode,0)  #No.FUN-660104 MARK
#           CALL cl_err3("upd","tus_file",g_tus.tus01,"",SQLCA.sqlcode,"","update tus_file",0)  #No.FUN-660104 #NO. FUN-710033
            CALL s_errmsg('tus01',g_tus.tus01,'',SQLCA.sqlcode,0)          #NO. FUN-710033  
            RETURN
         END IF
      END IF                     #TQC-690044 add
 
      LET l_change = 'N'   #TQC-690044 add
      INITIALIZE g_tus.*  LIKE tus_file.*   #DEFAULT 設定
      INITIALIZE g_tut.*  LIKE tut_file.*   #DEFAULT 設定
   END FOREACH
 
  #IF cl_null(start_no1) OR cl_null(start_no2) THEN     #MOD-740426 mark
   IF cl_null(start_no1) AND cl_null(start_no2) THEN    #MOD-740426
      CALL cl_err('','aap-129',1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION p311_ins_oga()
   DEFINE l_oaz32   LIKE oaz_file.oaz32,   #三角貿易使用匯率 S/B/C/D 
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_date1   LIKE type_file.dat,              #No.FUN-680120 DATE
          l_date2   LIKE type_file.dat              #No.FUN-680120 DATE
 
   LET g_oga.oga00   ='1'
   LET g_oga.oga02   =tm.oga02
   LET g_oga.oga021  =tm.oga02
   LET g_oga.oga03   =g_tus.tus03
   LET g_oga.oga04   =g_tus.tus09
   LET g_oga.oga07   ='N'
   LET g_oga.oga08   ='1'
   LET g_oga.oga09   ='3'
   LET g_oga.oga1005 ='N'
   LET g_oga.oga14   =g_tus.tus04
   LET g_oga.oga15   =g_tus.tus05
   LET g_oga.oga16   =g_tus.tus01
   LET g_oga.oga161  =0      #MOD-790101 modify 100->0 
   LET g_oga.oga162  =100    #MOD-790101 modify 0->100
   LET g_oga.oga163  =0
   #SELECT occ02,occ11,occ08,occ07,occ41,occ42,occ43,occ44  #MOD-940188 add occ44 #MOD-C50203 mark 
   SELECT occ02,occ11,occ08,occ07,occ41,occ42,occ43,occ44,occ45  #MOD-C50203 add 
     INTO g_oga.oga032,g_oga.oga033,g_oga.oga05,
          #g_oga.oga18,g_oga.oga21,g_oga.oga23,g_oga.oga25,g_oga.oga31 #MOD-940188 add oga31 #MOD-C50203 mark
          g_oga.oga18,g_oga.oga21,g_oga.oga23,g_oga.oga25,g_oga.oga31,g_oga.oga32 #MOD-C50203 add
     FROM occ_file WHERE occ01=g_oga.oga03 
   IF STATUS THEN 
      LET g_oga.oga032 = ''
      LET g_oga.oga033 = ''
      LET g_oga.oga05 = ''
      LET g_oga.oga18 = ''
      LET g_oga.oga21 = ''
      LET g_oga.oga23 = '' 
      LET g_oga.oga25 = ''
      LET g_oga.oga31 = ''   #MOD-940188
      LET g_oga.oga32 = ''   #MOD-C50203 add
   ELSE
      SELECT gec04,gec05,gec07
        INTO g_oga.oga211,g_oga.oga212,g_oga.oga213
        FROM gec_file WHERE gec01=g_oga.oga21 AND gec011='2'
      IF STATUS THEN
         LET g_oga.oga211 = 0
         LET g_oga.oga212 = ''
         LET g_oga.oga213 = ''
      END IF
   END IF
   CALL s_curr3(g_oga.oga23,g_oga.oga02,g_oaz.oaz52) RETURNING g_oga.oga24
   IF cl_null(g_oga.oga24) THEN
      LET g_oga.oga24 = 1
   END IF
   LET g_oga.oga20  = 'Y'                #分錄底稿是否可重新產生
   LET g_oga.oga30  = 'N'                #包裝單確認碼
   LET g_oga.oga50  = 0                  #原幣出貨金額
   LET g_oga.oga501 = 0                  #本幣出貨金額
   LET g_oga.oga51  = 0                  #原幣出貨金額(含稅)
   LET g_oga.oga511 = 0                  #本幣出貨金額 
   LET g_oga.oga52  = 0                  #原幣預收訂金轉銷貨收入金額
   LET g_oga.oga53  = 0                  #原幣應開發票未稅金額
   LET g_oga.oga54  = 0                  #原幣已開發票未稅金額 
   LET g_oga.oga55  = '0'                #狀態碼
   LET g_oga.oga57  = '1'                #FUN-AC0055 add
   LET g_oga.oga65  = 'N'
   LET g_oga.oga69  = g_today            #MOD-B80124 add
   LET g_oga.oga905 = 'N'                #已轉三角貿易出貨單否
   LET g_oga.oga906 = 'Y'                #起始出貨單否
   LET g_oga.oga909 = 'N'
   LET g_oga.ogaconf= 'N'                #確認否/作廢碼
   LET g_oga.ogapost= 'N'                #出貨扣帳否
   LET g_oga.ogaprsw= 0                  #列印次數
   LET g_oga.ogauser= g_user             #資料所有者
   LET g_oga.ogagrup= g_grup             #資料所有部門
   LET g_oga.ogamodu= ''                 #資料修改者
   LET g_oga.ogadate= g_today            #最近修改日
   LET g_oga.ogamksg= 'N'                #簽核
   #應收款日,容許票據到期日
   #CALL s_rdate2(g_oga.oga03,g_oga.oga32,g_oga.oga02,g_oga.oga02)
   CALL s_rdatem(g_oga.oga03,g_oga.oga32,g_oga.oga02,g_oga.oga02,
                 #g_oga.oga02,g_dbs)  #NO.FUN-630015 #No.FUN-680022 add oga02   #TQC-680074
#                g_oga.oga02,g_dbs2)  #NO.FUN-630015 #No.FUN-680022 add oga02   #TQC-680074 #FUN-980020 mark
                 g_oga.oga02,g_plant2)  #FUN-980020
      RETURNING l_date1,l_date2
   IF cl_null(g_oga.oga11) THEN 
      LET g_oga.oga11 = l_date1 
   END IF
   IF cl_null(g_oga.oga12) THEN 
      LET g_oga.oga12 = l_date2 
   END IF
#No.FUN-870007-start-
   IF cl_null(g_oga.oga85) THEN
      LET g_oga.oga85=' '
   END IF
   IF cl_null(g_oga.oga94) THEN
      LET g_oga.oga94='N'
   END IF
#No.FUN-870007--end--
   
   CALL s_auto_assign_no("axm",tm.oga01,g_oga.oga02,"","oga_file","oga01","","","")
        RETURNING li_result,g_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET g_oga.ogaplant = g_plant #FUN-980009
   LET g_oga.ogalegal = g_legal #FUN-980009
 
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES(g_oga.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p311_ins_oga():',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
#     CALL cl_err3("ins","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","p311_ins_oga():",1)  #No.FUN-660104  #NO. FUN-710033
      CALL s_errmsg('','','',SQLCA.sqlcode,1)         #NO. FUN-710033 
     LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(start_no1) THEN 
      LET start_no1 = g_oga.oga01
   END IF
   LET end_no1=g_oga.oga01
 
   INITIALIZE g_ogb.*  LIKE ogb_file.*   #DEFAULT 設定
   CALL p311_ins_ogb()
END FUNCTION
 
FUNCTION p311_ins_ogb()
   DEFINE l_flag   LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_factor LIKE ogb_file.ogb911,            #No.FUN-680120 DECIMAL(16,8)
          l_ima25  LIKE ima_file.ima25,
          l_ima55  LIKE ima_file.ima55,
          l_ima906 LIKE ima_file.ima906,
          l_ima907 LIKE ima_file.ima907
   DEFINE l_ogbi   RECORD LIKE ogbi_file.*          #No.FUN-7B0018
   DEFINE l_ima135 LIKE ima_file.ima135             #TQC-AB0378
 
   LET g_ogb.ogb01=g_oga.oga01
   LET g_ogb.ogb03=g_tut.tut02
   LET g_ogb.ogb04=g_tut.tut03
   LET g_ogb.ogb05=g_tut.tut05
 
   #銷售/庫存匯總單位換算率
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_ogb.ogb04
   CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,l_ima25)
        RETURNING l_flag,l_factor
   IF l_flag > 0 THEN
      LET l_factor = 1 
   END IF
   LET g_ogb.ogb05_fac = l_factor
 
   #品名、規格
    SELECT ima02,ima021 INTO g_ogb.ogb06,g_ogb.ogb07                     
      FROM ima_file WHERE ima01=g_ogb.ogb04                          
#  SELECT ima02,ima021,ima135 INTO g_ogb.ogb06,g_ogb.ogb07,l_ima135      #TQC-AB0378
#    FROM ima_file WHERE ima01=g_ogb.ogb04                               #TQC-AB0378    
   IF STATUS THEN 
      LET g_ogb.ogb06 = '' 
      LET g_ogb.ogb07 = '' 
#     LET l_ima135 = ''
   END IF
 
   #預設寄銷倉庫、預設寄銷儲位
   SELECT tuo04,tuo05 INTO g_ogb.ogb09,g_ogb.ogb091
     FROM tuo_file WHERE tuo01=g_oga.oga03 AND tuo02=g_oga.oga04
   IF STATUS THEN
      LET g_ogb.ogb09 = ' '
      LET g_ogb.ogb091= ' '
   END IF
 
   LET g_ogb.ogb092=' '
   LET g_ogb.ogb12 =g_tut.tut06
 
 # CALL p311_b_get_price('1') RETURNING g_ogb.ogb13       #TQC-AB0378 mark
   LET g_ogb.ogb917= g_ogb.ogb12                   #計價數量  #CHI-710059 mod
   LET g_ogb.ogb917 = s_digqty(g_ogb.ogb917,g_ogb.ogb916)    #FUN-910088--add--
#TQC-AB0378 ------------STA
#  SELECT DISTINCT tqx01 INTO g_ogb.ogb1004 FROM tqx_file,tqy_file,tqz_file,tsa_file
#      WHERE tqx01=tqy01 AND tqx01=tqz01
#        AND tqx01=tsa01 AND tqy02=tsa02
#        AND tqz02=tsa03 AND tqy03=g_oga.oga03  #No.TQC-640123
#        AND tqy37= 'Y'  AND tqx07= '3'
#        AND (tqz03 =g_ogb.ogb04 OR
#             tqz03 IN (SELECT ima01 FROM ima_file
#                        WHERE ima135=l_ima135))
   CALL s_fetch_price_new(g_oga.oga03,g_ogb.ogb04,g_ogb.ogb48,g_ogb.ogb05,g_oga.oga69,     #FUN-BC0071
                         '2',g_oga.ogaplant,g_oga.oga23,g_oga.oga31,g_oga.oga32,
                          g_oga.oga01,g_ogb.ogb03,g_ogb.ogb917,
                          g_ogb.ogb1004,'a')
                          RETURNING g_ogb.ogb13,g_ogb.ogb37
 
#TQC-AB0378 -------------END 
   IF g_oga.oga213 = 'N' THEN
     #LET g_ogb.ogb14 =g_ogb.ogb12 *g_ogb.ogb13   #CHI-710059 mod
      LET g_ogb.ogb14 =g_ogb.ogb917*g_ogb.ogb13   #CHI-710059 mod
      LET g_ogb.ogb14t=g_ogb.ogb14*(1+g_oga.oga211/100)
   ELSE
     #LET g_ogb.ogb14t=g_ogb.ogb12 *g_ogb.ogb13   #CHI-710059 mod
      LET g_ogb.ogb14t=g_ogb.ogb917*g_ogb.ogb13   #CHI-710059 mod
      LET g_ogb.ogb14 =g_ogb.ogb14t/(1+g_oga.oga211/100)
   END IF
   CALL cl_digcut(g_ogb.ogb14,g_azi04) RETURNING g_ogb.ogb14
   CALL cl_digcut(g_ogb.ogb14t,g_azi04)RETURNING g_ogb.ogb14t
 
   #庫存明細單位由廠/倉/儲/批自動得出
   SELECT img09 INTO g_ogb.ogb15 FROM img_file
    WHERE img01=g_ogb.ogb04  AND img02=g_ogb.ogb09
      AND img03=g_ogb.ogb091 AND img04=g_ogb.ogb092
   IF STATUS THEN 
      LET g_ogb.ogb15 = ' ' 
   END IF
 
   CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,g_ogb.ogb15) 
        RETURNING l_flag,l_factor
   IF l_flag > 0 THEN
      LET l_factor = 1
   END IF
   LET g_ogb.ogb15_fac = l_factor
 
   LET g_ogb.ogb16=g_ogb.ogb12 * g_ogb.ogb15_fac
   LET g_ogb.ogb16 = s_digqty(g_ogb.ogb16,g_ogb.ogb15)   #FUN-910088--add--
   IF cl_null(g_ogb.ogb16) THEN
      LET g_ogb.ogb16 = 0
   END IF
   LET g_ogb.ogb17='N'
   LET g_ogb.ogb18=g_ogb.ogb12
   IF cl_null(g_ogb.ogb18) THEN
      LET g_ogb.ogb18 = 0
   END IF
   LET g_ogb.ogb19='N'
   LET g_ogb.ogb60=0
   LET g_ogb.ogb63=0
   LET g_ogb.ogb64=0
 
   IF g_sma.sma115 = 'Y' THEN
      LET g_ogb.ogb910 = g_ogb.ogb05               #單位一
      SELECT ima55,ima906,ima907
        INTO l_ima55,l_ima906,l_ima907   #生產單位,單位使用方式,第二單位
        FROM ima_file
       WHERE ima01=g_ogb.ogb04
      CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb910,l_ima55)
           RETURNING l_flag,l_factor
      IF l_flag > 0 THEN
         LET l_factor = 1
      END IF
      LET g_ogb.ogb911 = l_factor                     #單位一換算率(與銷售單位)
      LET g_ogb.ogb912 = g_ogb.ogb12 * g_ogb.ogb911   #單位一數量
      LET g_ogb.ogb912 = s_digqty(g_ogb.ogb912,g_ogb.ogb910)   #FUN-910088--add--
      IF l_ima906 = '1' THEN  #不使用雙單位
         LET g_ogb.ogb913 = NULL
         LET g_ogb.ogb914 = NULL
         LET g_ogb.ogb915 = NULL
      ELSE
         LET g_ogb.ogb913 = l_ima907               #單位二
         CALL s_du_umfchk(g_ogb.ogb04,'','','',l_ima55,l_ima907,l_ima906)
              RETURNING l_flag,l_factor
         IF l_flag > 0 THEN
            LET l_factor = 1
         END IF
         LET g_ogb.ogb914 = l_factor               #單位二換算率(與銷售單位)
         LET g_ogb.ogb915 = 0                      #單位二數量
      END IF
   END IF
#FUN-AB0061 -----------add start----------------                             
   IF cl_null(g_ogb.ogb37) OR g_ogb.ogb37=0 THEN           
      LET g_ogb.ogb37=g_ogb.ogb13                         
   END IF                                                                             
#FUN-AB0061 -----------add end----------------  
   LET g_ogb.ogb916= g_ogb.ogb05                   #計價單位
  #LET g_ogb.ogb917= g_ogb.ogb12                   #計價數量  #CHI-710059 mod
   LET g_ogb.ogb930= s_costcenter(g_oga.oga15)     #FUN-680006
   #MOD-8B0287---Begin                                                                                                              
   LET g_ogb.ogb1005= '1'                                                                                                           
   LET g_ogb.ogb1006= 100                                                                                                           
   LET g_ogb.ogb1012= 'N'                                                                                                           
   #MOD-8B0287---End   
#No.FUN-870007-start-
   IF cl_null(g_ogb.ogb44) THEN
      LET g_ogb.ogb44='1'
   END IF
   IF cl_null(g_ogb.ogb47) THEN
      LET g_ogb.ogb47=0
   END IF
#No.FUN-870007--end--
   LET g_ogb.ogbplant = g_plant #FUN-980009
   LET g_ogb.ogblegal = g_legal #FUN-980009
   #FUN-AC0055 mark ---------------------begin-----------------------
   ##FUN-AB0096 -------add start--------------
   #IF cl_null(g_ogb.ogb50) THEN
   #   LET g_ogb.ogb50 = '1'
   #END IF
   ##FUN-AB0096 -------add end ---------------
   #FUN-AC0055 mark ---------------------begin-----------------------
   #FUN-C50097 ADD BEGIN-----
   IF cl_null(g_ogb.ogb50) THEN
     LET g_ogb.ogb50 = 0
   END IF
   IF cl_null(g_ogb.ogb51) THEN
     LET g_ogb.ogb51 = 0
   END IF
   IF cl_null(g_ogb.ogb52) THEN
     LET g_ogb.ogb52 = 0
   END IF
   IF cl_null(g_ogb.ogb53) THEN
     LET g_ogb.ogb53 = 0
   END IF
   IF cl_null(g_ogb.ogb54) THEN
     LET g_ogb.ogb54 = 0
   END IF
   IF cl_null(g_ogb.ogb55) THEN
     LET g_ogb.ogb55 = 0
   END IF   
   #FUN-C50097 ADD END-------   
   #FUN-CB0087--add--str--
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(g_ogb.ogb01,g_ogb.ogb31,'',g_ogb.ogb04,g_ogb.ogb09,g_oga.oga14,g_oga.oga15) RETURNING g_ogb.ogb1001
      IF cl_null(g_ogb.ogb1001) THEN
         CALL cl_err(g_ogb.ogb1001,'aim-425',1)
         LET g_success="N"
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--end--
   INSERT INTO ogb_file VALUES(g_ogb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p311_ins_ogb():',SQLCA.sqlcode,1)   #No.FUN-660104 MARK
#     CALL cl_err3("ins","ogb_file",g_ogb.ogb01,g_ogb.ogb03,SQLCA.sqlcode,"","p311_ins_ogb():",1)  #No.FUN-660104  #NO. FUN-710033
      CALL s_errmsg('','',"p311_ins_ogb():",SQLCA.sqlcode,1)        #NO. FUN-710033  
      LET g_success = 'N'
      RETURN
   #No.FUN-7B0018 080304 add --begin
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ogbi.* TO NULL
         LET l_ogbi.ogbi01 = g_ogb.ogb01
         LET l_ogbi.ogbi03 = g_ogb.ogb03
         IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   #No.FUN-7B0018 080304 add --end  
   END IF
 
END FUNCTION
 
FUNCTION p311_upd_oga()
 
   SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file WHERE ogb01=g_oga.oga01
 
   UPDATE oga_file SET oga50 = g_oga.oga50,          #原幣出貨金額
                       oga52 = g_oga.oga50           #原幣預收訂金轉銷貨收入金額
                 WHERE oga01 = g_oga.oga01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p311_upd_oga():',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
      CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","p311_upd_oga():",1)  #No.FUN-660104
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION p311_ins_oha()
   DEFINE l_oaz32   LIKE oaz_file.oaz32,   #三角貿易使用匯率 S/B/C/D 
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_date1   LIKE type_file.dat,              #No.FUN-680120 DATE
          l_date2   LIKE type_file.dat               #No.FUN-680120 DATE
 
   LET g_oha.oha02   =tm.oha02                     #銷退日期
   LET g_oha.oha03   =g_tus.tus03                  #帳款客戶編號
   LET g_oha.oha04   =g_tus.tus09                  #退貨客戶編號
   LET g_oha.oha05   ='1'                          #單據別
   LET g_oha.oha08   ='1'                          #1.內銷
#MOD-790141-modify
#  LET g_oha.oha09   ='5'                          #銷退處理方式:5.折讓
   LET g_oha.oha09   ='1'                          #銷退處理方式:1.銷退折讓
#MOD-790141-modify-end
   LET g_oha.oha14   =g_tus.tus04                  #人員編號
   LET g_oha.oha15   =g_tus.tus05                  #部門編號
   SELECT occ02,occ41,occ42,occ43,occ44 
     INTO g_oha.oha032,g_oha.oha21,g_oha.oha23,g_oha.oha25,g_oha.oha31
     FROM occ_file WHERE occ01=g_oha.oha03 
   IF STATUS THEN 
      LET g_oha.oha032 = ''                        #帳款客戶簡稱
      LET g_oha.oha21  = ''                        #稅別
      LET g_oha.oha23  = ''                        #幣別
      LET g_oha.oha25  = ''                        #銷售分類一
      LET g_oha.oha31  = ''                        #價格條件
   ELSE
      SELECT gec04,gec05,gec07
        INTO g_oha.oha211,g_oha.oha212,g_oha.oha213
        FROM gec_file WHERE gec01=g_oha.oha21 AND gec011='2'
      IF STATUS THEN
         LET g_oha.oha211 = 0                      #稅率
         LET g_oha.oha212 = ''                     #聯數
         LET g_oha.oha213 = ''                     #含稅否
      END IF
   END IF
   CALL s_curr3(g_oha.oha23,g_oha.oha02,g_oaz.oaz52) RETURNING g_oha.oha24
   IF cl_null(g_oha.oha24) THEN
      LET g_oha.oha24 = 1                          #匯率
   END IF
   LET g_oha.oha41   ='N'                          #三角貿易銷退單否
   LET g_oha.oha42   ='N'                          #是否入庫存
   LET g_oha.oha43   ='N'                          #起始三角貿易銷退單否
   LET g_oha.oha44   ='N'                          #拋轉否
   LET g_oha.oha50   =0                            #原幣銷退總未稅金額
   LET g_oha.oha53   =0                            #原幣銷退應開折讓未稅金額
   LET g_oha.oha54   =0                            #原幣銷退已開折讓未稅金額
   LET g_oha.oha55   ='0'                          #狀況碼
   LET g_oha.ohaconf= 'N'                          #確認否
   LET g_oha.ohapost= 'N'                          #庫存扣帳否
   LET g_oha.ohaprsw= 0                            #列印次數
   LET g_oha.ohauser= g_user                       #資料所有者
   LET g_oha.ohagrup= g_grup                       #資料所有部門
   LET g_oha.ohamodu= ''                           #資料修改者
   LET g_oha.ohadate= g_today                      #最近修改日
   LET g_oha.ohamksg= 'N'                          #簽核否
#No.FUN-870007-start-
   IF cl_null(g_oha.oha85) THEN
      LET g_oha.oha85=' '
   END IF
   IF cl_null(g_oha.oha94) THEN
      LET g_oha.oha94='N'
   END IF
#No.FUN-870007--end--
   
   CALL s_auto_assign_no("axm",tm.oha01,g_oha.oha02,"1","oha_file","oha01","","","")
        RETURNING li_result,g_oha.oha01            #銷退單號
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET g_oha.ohaplant = g_plant #FUN-980009
   LET g_oha.ohalegal = g_legal #FUN-980009
   LET g_oha.ohaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oha.ohaorig = g_grup      #No.FUN-980030 10/01/04
   IF cl_null(g_oha.oha57) THEN LET g_oha.oha57 = '1' END IF #FUN-AC0055 add
   INSERT INTO oha_file VALUES(g_oha.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p311_ins_oha():',SQLCA.sqlcode,1)   #No.FUN-660104 MARK
#     CALL cl_err3("ins","oha_file",g_oha.oha01,"",SQLCA.sqlcode,"","p311_ins_oha():",1)  #No.FUN-660104  #NO. FUN-710033
      CALL s_errmsg('','','',SQLCA.sqlcode,1)  #NO. FUN-710033
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(start_no2) THEN 
      LET start_no2 = g_oha.oha01
   END IF
   LET end_no2=g_oha.oha01
 
   INITIALIZE g_ohb.*  LIKE ohb_file.*   #DEFAULT 設定
   CALL p311_ins_ohb()
END FUNCTION
 
FUNCTION p311_ins_ohb()
   DEFINE l_flag   LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_factor LIKE ogb_file.ogb911,            #No.FUN-680120 DECIMAL(16,8)
          l_ima25  LIKE ima_file.ima25,
          l_ima55  LIKE ima_file.ima55,
          l_ima906 LIKE ima_file.ima906,
          l_ima907 LIKE ima_file.ima907
   DEFINE l_ima135 LIKE ima_file.ima135             #TQC-AB0378
   DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074 add
   DEFINE g_oha14       LIKE oha_file.oha14,     #FUN-CB0087
          g_oha15       LIKE oha_file.oha15      #FUN-CB0087
   
   LET g_ohb.ohb01=g_oha.oha01                  #銷退單號 
   LET g_ohb.ohb03=g_tut.tut02                  #項次 
   LET g_ohb.ohb04=g_tut.tut03                  #產品編號 
   LET g_ohb.ohb05=g_tut.tut05                  #銷售單位 
 
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_ohb.ohb04
   CALL s_umfchk(g_ohb.ohb04,g_ohb.ohb05,l_ima25)
        RETURNING l_flag,l_factor
   IF l_flag > 0 THEN 
      LET l_factor = 1
   END IF
   LET g_ohb.ohb05_fac = l_factor               #銷售/庫存單位換算率
 
    SELECT ima02,ima021 INTO g_ohb.ohb06,g_ohb.ohb07                     
      FROM ima_file WHERE ima01=g_ohb.ohb04                              
#   SELECT ima02,ima021,ima135 INTO g_ohb.ohb06,g_ohb.ohb07,l_ima135     #TQC-AB0378 
#     FROM ima_file WHERE ima01=g_ohb.ohb04                              #TQC-AB0378
   IF STATUS THEN 
      LET g_ohb.ohb06 = ''                      #品名規格
      LET g_ohb.ohb07 = ''                      #額外品名編號
#     LET l_ima135 = ''
   END IF
 
   SELECT tuo04,tuo05 INTO g_ohb.ohb09,g_ohb.ohb091
     FROM tuo_file WHERE tuo01=g_oha.oha03 AND tuo02=g_oha.oha04
   IF STATUS THEN
      LET g_ohb.ohb09 = ' '                     #銷退入庫倉庫編號
      LET g_ohb.ohb091= ' '                     #銷退入庫儲位編號
   END IF
 
   LET g_ohb.ohb092=' '                         #銷退入庫批號編號
   LET g_ohb.ohb12 =g_tut.tut06                 #數量
 
#  CALL p311_b_get_price('2') RETURNING g_ohb.ohb13   #原幣單價       #TQC-AB0378 mark
#TQC-AB0378 ------------STA
#  SELECT DISTINCT tqx01 INTO g_ohb.ohb1002 FROM tqx_file,tqy_file,tqz_file,tsa_file
#      WHERE tqx01=tqy01 AND tqx01=tqz01
#        AND tqx01=tsa01 AND tqy02=tsa02
#        AND tqz02=tsa03 AND tqy03=g_oha.oha03
#        AND tqy37= 'Y'  AND tqx07= '3'
#        AND (tqz03 =g_ohb.ohb04 OR
#             tqz03 IN (SELECT ima01 FROM ima_file
#                        WHERE ima135=l_ima135))
   CALL s_fetch_price_new(g_oha.oha03,g_ohb.ohb04,g_ohb.ohb69,g_ohb.ohb05,g_oha.oha02,         #FUN-BC0071 
                          '3',g_oha.ohaplant,g_oha.oha23,g_oha.oha31,'',
                           g_oha.oha01,g_ohb.ohb03,g_ohb.ohb12,
                           g_ohb.ohb1002,'a')
                        RETURNING g_ohb.ohb13,g_ohb.ohb37
#TQC-AB0378 ------------END 

   LET g_ohb.ohb917 = g_ohb.ohb12   #CHI-B70039 add

   IF g_oha.oha213 = 'N' THEN
#     LET g_ohb.ohb14 =g_ohb.ohb12*g_ohb.ohb13  #原幣未稅金額   #CHI-B70039 mark
      LET g_ohb.ohb14 =g_ohb.ohb917*g_ohb.ohb13                 #CHI-B70039
      LET g_ohb.ohb14t=g_ohb.ohb14*(1+g_oha.oha211/100)
   ELSE
#     LET g_ohb.ohb14t=g_ohb.ohb12*g_ohb.ohb13  #原幣含稅金額   #CHI-B70039 mark
      LET g_ohb.ohb14t=g_ohb.ohb917*g_ohb.ohb13                 #CHI-B70039
      LET g_ohb.ohb14 =g_ohb.ohb14t/(1+g_oha.oha211/100)
   END IF
   CALL cl_digcut(g_ohb.ohb14,g_azi04)  RETURNING g_ohb.ohb14
   CALL cl_digcut(g_ohb.ohb14t,g_azi04) RETURNING g_ohb.ohb14t
 
   SELECT img09 INTO g_ohb.ohb15 FROM img_file
    WHERE img01=g_ohb.ohb04  AND img02=g_ohb.ohb09
      AND img03=g_ohb.ohb091 AND img04=g_ohb.ohb092
   IF STATUS THEN 
      LET g_ohb.ohb15 = ' '                   #庫存明細單位由廠/倉/儲/批自動得出
   END IF
 
   CALL s_umfchk(g_ohb.ohb04,g_ohb.ohb05,g_ohb.ohb15) 
        RETURNING l_flag,l_factor
   IF l_flag > 0 THEN
      LET l_factor = 1
   END IF
   LET g_ohb.ohb15_fac = l_factor             #銷售/庫存明細單位換算率
 
   LET g_ohb.ohb16=g_ohb.ohb12 * g_ohb.ohb15_fac   #數量
   IF cl_null(g_ohb.ohb16) THEN
      LET g_ohb.ohb16 = 0
   END IF
 
   LET g_ohb.ohb60=0                               #已開折讓數量
 
   IF g_sma.sma115 = 'Y' THEN
      LET g_ohb.ohb910 = g_ohb.ohb05               #單位一
      SELECT ima55,ima906,ima907
        INTO l_ima55,l_ima906,l_ima907   #生產單位,單位使用方式,第二單位
        FROM ima_file
       WHERE ima01=g_ohb.ohb04
      CALL s_umfchk(g_ohb.ohb04,g_ohb.ohb910,l_ima55)
           RETURNING l_flag,l_factor
      IF l_flag > 0 THEN
         LET l_factor = 1
      END IF
      LET g_ohb.ohb911 = l_factor                     #單位一換算率(與銷售單位)
      LET g_ohb.ohb912 = g_ohb.ohb12 * g_ohb.ohb911   #單位一數量
      IF l_ima906 = '1' THEN  #不使用雙單位
         LET g_ohb.ohb913 = NULL
         LET g_ohb.ohb914 = NULL
         LET g_ohb.ohb915 = NULL
      ELSE
         LET g_ohb.ohb913 = l_ima907               #單位二
         CALL s_du_umfchk(g_ohb.ohb04,'','','',l_ima55,l_ima907,l_ima906)
              RETURNING l_flag,l_factor
         IF l_flag > 0 THEN
            LET l_factor = 1
         END IF
         LET g_ohb.ohb914 = l_factor               #單位二換算率(與銷售單位)
         LET g_ohb.ohb915 = 0                      #單位二數量
      END IF
   END IF
   LET g_ohb.ohb916= g_ohb.ohb05                   #計價單位
   LET g_ohb.ohb917= g_ohb.ohb12                   #計價數量
   LET g_ohb.ohb930= g_ogb.ogb930                  #FUN-680006
#No.FUN-870007-start-
   IF cl_null(g_ohb.ohb64) THEN
      LET g_ohb.ohb64='1'
   END IF
   IF cl_null(g_ohb.ohb67) THEN
      LET g_ohb.ohb67=0
   END IF
   IF cl_null(g_ohb.ohb68) THEN
      LET g_ohb.ohb68='N'
   END IF
#No.FUN-870007--end--
   LET g_ohb.ohbplant = g_plant #FUN-980009
   LET g_ohb.ohblegal = g_legal #FUN-980009
   LET g_ohb.ohb16  = s_digqty(g_ohb.ohb16,g_ohb.ohb15)    #FUN-BB0085
   LET g_ohb.ohb912 = s_digqty(g_ohb.ohb912,g_ohb.ohb910)  #FUN-BB0085
   #FUN-AB0061----------add---------------str----------------
   IF cl_null(g_ohb.ohb37) OR g_ohb.ohb37 = 0 THEN
      LET g_ohb.ohb37 = g_ohb.ohb13
   END IF
   #FUN-AB0061----------add---------------end---------------
   #FUN-AB0096 ---------add start--------------------------
   #IF cl_null(g_ohb.ohb71) THEN   #FUN-AC0055 mark 
   #   LET g_ohb.ohb71 = '1'
   #END IF
   #FUN-AB0096 ---------add end----------------------------
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT oha14,oha15 INTO g_oha14,g_oha15 FROM oha_file WHERE oha01 = g_ohb.ohb01
      CALL s_reason_code(g_ohb.ohb01,g_ohb.ohb31,'',g_ohb.ohb04,g_ohb.ohb09,g_oha14,g_oha15) RETURNING g_ohb.ohb50
      IF cl_null(g_ohb.ohb50) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-CB0087---add---end---
   INSERT INTO ohb_file VALUES(g_ohb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p311_ins_ohb():',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
#     CALL cl_err3("ins","ohb_file",g_ohb.ohb01,g_ohb.ohb03,SQLCA.sqlcode,"","p311_ins_ohb():",1)  #No.FUN-660104 #NO. FUN-710033
      CALL s_errmsg('','','',SQLCA.sqlcode,1)                              #NO. FUN-710033 
      LET g_success = 'N'
      RETURN
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ohbi.* TO NULL
         LET l_ohbi.ohbi01 = g_ohb.ohb01
         LET l_ohbi.ohbi03 = g_ohb.ohb03
         IF NOT s_ins_ohbi(l_ohbi.*,g_ohb.ohbplant ) THEN
            LET g_success = 'N'  
            RETURN
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF
 
END FUNCTION
 
FUNCTION p311_upd_oha()
 
   SELECT SUM(ohb14) INTO g_oha.oha50 
     FROM ohb_file WHERE ohb01=g_oha.oha01
 
   UPDATE oha_file SET oha50 = g_oha.oha50,     #原幣銷退總未稅金額
                       oha53 = g_oha.oha50      #原幣銷退應開折讓未稅金額
                 WHERE oha01 = g_oha.oha01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p311_upd_oha():',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
#     CALL cl_err3("upd","oha_file",g_oha.oha01,"",SQLCA.sqlcode,"","p311_upd_oha():",1)  #No.FUN-660104  #NO. FUN-710033
      CALL s_errmsg('oha',g_oha.oha01,'',SQLCA.sqlcode,1) #NO. FUN-710033
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

#TQC-AB0378  ------------------------------mark 
#FUNCTION p311_b_get_price(l_opt)
#  DEFINE l_opt         LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)               #1=oga,2=oha
#  DEFINE l_oah03       LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)               #單價取價方式
#  DEFINE l_ima131      LIKE ima_file.ima03             #No.FUN-680120 VARCHAR(20)              #Product Type
#  DEFINE l_ogb13       LIKE ogb_file.ogb13
#  DEFINE l_ohb13       LIKE ohb_file.ohb13
#
#  IF l_opt = '1' THEN
#     SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oga.oga31
#
#     CASE WHEN l_oah03 = '0' RETURN
#          WHEN l_oah03 = '1'
#               IF g_oga.oga213='Y' THEN   #含稅否
#                  SELECT ima128 INTO l_ogb13 FROM ima_file 
#                   WHERE ima01=g_ogb.ogb04
#               ELSE 
#                  SELECT ima127 INTO l_ogb13 FROM ima_file 
#                   WHERE ima01=g_ogb.ogb04
#               END IF
#               #->將單價除上匯率
#               LET l_ogb13=l_ogb13/g_oga.oga24
#          WHEN l_oah03 = '2'
#               IF cl_null(g_ogb.ogb916) THEN
#                  LET g_ogb.ogb916=g_ogb.ogb05
#               END IF
#               SELECT ima131 INTO l_ima131 FROM ima_file 
#                WHERE ima01=g_ogb.ogb04
#               DECLARE p311_b_get_price_c1 CURSOR FOR
#                  SELECT obg21,
#                         obg01,obg02,obg03,obg04,obg05,
#                         obg06,obg07,obg08,obg09,obg10
#                    FROM obg_file
#                   WHERE (obg01 = l_ima131          OR obg01 = '*')
#                     AND (obg02 = g_ogb.ogb04 OR obg02 = '*'      )
#                     AND (obg03 = g_ogb.ogb916                    )
#                     AND (obg04 = g_oga.oga25       OR obg04 = '*')
#                     AND (obg05 = g_oga.oga31       OR obg05 = '*')
#                     AND (obg06 = g_oga.oga03       OR obg06 = '*')
#                     AND (obg09 = g_oga.oga23                     )
#                     AND (obg10 = g_oga.oga21       OR obg10 = '*')
#                   ORDER BY 2 DESC,3 DESC,4 DESC,5 DESC,6 DESC,7 DESC,
#                            8 DESC,9 DESC,10 DESC
#               FOREACH p311_b_get_price_c1 INTO l_ogb13
#                 IF STATUS THEN
#                 CALL cl_err('foreach obg',STATUS,1) #NO. FUN-710033
#                 CALL s_errmsg('','','',STATUS,1)    #NO. FUN-710033 
#                 END IF
#                 EXIT FOREACH
#               END FOREACH
#          WHEN l_oah03 = '3'
#             SELECT obk08 INTO l_ogb13 FROM obk_file
#              WHERE obk01 = g_ogb.ogb04 AND obk02 = g_oga.oga03
#                AND obk05 = g_oga.oga23
#          WHEN l_oah03 = '4'
#             CALL s_price(g_oga.oga02,g_oga.oga31,g_oga.oga23,g_oga.oga32,
#                          g_oga.oga03,g_ogb.ogb04,g_ogb.ogb05,g_ogb.ogb12,l_oah03)
#             RETURNING l_ogb13
#     END CASE
#     IF cl_null(l_ogb13) THEN LET l_ogb13 = 0 END IF
#
#     RETURN l_ogb13
#  ELSE
#     SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oha.oha31
#
#     CASE WHEN l_oah03 = '0' RETURN
#          WHEN l_oah03 = '1'
#               IF g_oga.oga213='Y' THEN   #含稅否
#                  SELECT ima128 INTO l_ohb13 FROM ima_file 
#                   WHERE ima01=g_ohb.ohb04
#               ELSE 
#                  SELECT ima127 INTO l_ohb13 FROM ima_file 
#                   WHERE ima01=g_ohb.ohb04
#               END IF
#               #->將單價除上匯率
#               LET l_ohb13=l_ohb13/g_oha.oha24
#          WHEN l_oah03 = '2'
#               SELECT ima131 INTO l_ima131 FROM ima_file 
#                WHERE ima01=g_ohb.ohb04
#               DECLARE p311_b_get_price_c2 CURSOR FOR
#                  SELECT obg21,
#                         obg01,obg02,obg03,obg04,obg05,
#                         obg06,obg07,obg08,obg09,obg10
#                    FROM obg_file
#                   WHERE (obg01 = l_ima131          OR obg01 = '*')
#                     AND (obg02 = g_ohb.ohb04       OR obg02 = '*')
#                     AND (obg03 = g_ohb.ohb05                     )
#                     AND (obg04 = g_oha.oha25       OR obg04 = '*')
#                     AND (obg05 = g_oha.oha31       OR obg05 = '*')
#                     AND (obg06 = g_oha.oha03       OR obg06 = '*')
#                     AND (obg09 = g_oha.oha23                     )
#                     AND (obg10 = g_oha.oha21       OR obg10 = '*')
#                   ORDER BY 2,3,4,5,6,7,8,9,10,11
#               FOREACH p311_b_get_price_c2 INTO l_ohb13
#                 IF STATUS THEN 
#                 CALL cl_err('foreach obg',STATUS,1)#NO. FUN-710033 
#                 CALL s_errmsg('','','',STATUS,1)   #NO. FUN-710033
#                 END IF
#                 EXIT FOREACH
#               END FOREACH
#          WHEN l_oah03 = '3'
#             SELECT obk08 INTO l_ohb13 FROM obk_file
#              WHERE obk01 = g_ohb.ohb04 AND obk02 = g_oha.oha03
#     END CASE
#     IF cl_null(l_ohb13) THEN LET l_ohb13 = 0 END IF
#     
#     RETURN l_ohb13
#  END IF
#END FUNCTION
#TQC-AB0378 --------------------------------mark
