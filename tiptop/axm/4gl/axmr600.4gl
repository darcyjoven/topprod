# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmr600.4gl
# Descriptions...: 出貨單
# Date & Author..: 95/01/17 by Nick
# Modify.........: 99/06/21 By Carol:add 備註列印   r600_oao()
# Modify.........: No.FUN-4A0020 04/10/04 By Echo 出貨單號要開窗
# Modify.........: No.MOD-540174 05/04/26 By kim 報表格式
# Modify.........: No.MOD-540179 05/04/26 By kim 報表格式
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570176 05/07/19 By yoyo 項次欄位加大
# Modify.........: No.MOD-560074 05/06/30 By kim 表頭位置,沒對齊
# Modify.........: No.FUN-580004 05/08/09 By wujie 雙單位報表格式修改
# Modify.........: No.MOD-580084 05/08/19 By Nicola 程式判斷tm.a沒有給值時會以1.列印指定倉庫儲位的出貨數量
# Modify.........: NO.MOD-590510 05/10/03 BY yiting 報表位置不正確、調整  請看貼圖(先不處理)
# Modify.........: No.FUN-5A0143 05/10/22 By Rosayu 調整報表格式
# Modify.........: No.MOD-5B0095 05/11/11 By Nicola 出貨單開窗修改
# Modify.........: No.TQC-5B0110 05/11/11 By CoCo 單據編號位置調整
# Modify.........: No.FUN-5C0075 05/12/23 by wujie 若成品替代oaz23 = Y，則多一選項：是否列印替代料號
# Modify.........: No.FUN-5C0075 06/01/04 by wujie 增加"檢驗否"
# Modify.........: No.MOD-610046 06/01/11 By Nicola g_m改用Like
# Modify.........: No.FUN-610020 06/01/18 By Carrier 新增oga09類型7/8,8時若有驗退資料,則列印其明細,清除大段的mark段落
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610076 06/05/04 By kim 報表格式調整
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650020 06/05/26 By kim 整合信用額度的錯誤訊息為一個視窗,不要每筆都秀
# Modify.........: No.MOD-660071 06/06/16 By Pengu 列印時無表頭欄位資料
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.MOD-680081 06/11/16 By Claire 多倉儲批時的筆數限制,及加入小計
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.MOD-710131 07/01/23 By claire 總重量未顯示
# Modify.........: No.FUN-710081 07/01/30 By yoyo  crystal report報表
# Modify.........: No.MOD-710194 07/01/31 By claire l_addr1 LIKE occ241
# Modify.........: No.FUN-730014 07/03/06 By chenl s_addr傳回5個參數
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-720014 07/04/10 By rainy 地址欄位加2個
# Modify.........: No.CHI-7A0011 07/10/06 By Sarah 1.修正單位註解重複問題
#                                                  2.修正合計數量Double問題
#                                                  3.增加列印特別說明
# Modify.........: No.TQC-7A0024 07/10/11 By Sarah l_addr1~l_addr5相關變數宣告時，參考來源的table改為occ_file.occ241
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-850070 08/05/13 By Smapmin 出貨單單身料件編號的品名欄位,應直接接取ogb06.
# Modify.........: No.FUN-860026 08/07/23 By baofei 增加子報表-列印批序號明細 
# Modify.........: No.MOD-8A0255 08/10/29 By Smapmin 注意事項未列印出來
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80083 10/08/16 By yinhy 畫面條件選項增加一個選項，打印额外品名规格
# Modify.........: No:CHI-A90032 10/10/06 By Summer oaz141若為0不檢查時,"注意"那一整行都不要顯示
# Modify.........: No:TQC-B30063 11/03/09 By zhangll l_sql -> STRING
# Modify.........: No:FUN-B10026 11/04/26 By wuxj  新增axmt629列印功能，報表標題修改
# Modify.........: No:MOD-B50154 11/05/25 By Summer 條件儲存功能只適用於CONSTRUCT
# Modify.........: No:MOD-B60181 11/06/21 By JoHung 加入tm.b列印備註的判斷
# Modify.........: No:MOD-B70043 11/07/06 By JoHung l_str3 在給值前先清空
# Modify.........: No:MOD-B70149 11/07/15 By JoHung 修改l_table1第一個欄位型態
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:MOD-B90173 11/09/22 By Vampire 外部參數少tm.d 
# Modify.........: No:FUN-940044 11/11/04 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位 
# Modify.........: No.TQC-C10039 12/01/17 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-BB0203 12/01/30 By Vampire 顯示批序號時會有重複
# Modify.........: No:TQC-BB0013 12/03/30 By lilingyu 借貨出貨單單號在開窗時，無法查詢到
# Modify.........: No.DEV-D30029 13/03/19 By TSD.JIE 與M-Barcode整合(aza131)='Y'時,列印單號條碼

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
#No.FUN-580004--end
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)             # Where condition
              wc      STRING,  #Mod No:TQC-B30063
              a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)              # print price
              d       LIKE type_file.chr1,        # No.FUN-690032 客戶料號
              b       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)              # print memo
              c       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)              # print Sub Item#      #No.FUN-5C0075
              e       LIKE type_file.chr1,        #No.FUN-860026  
              f       LIKE type_file.chr1,        #No.FUN-A80083  VARCHAR(01)
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)              # Input more condition(Y/N)
              END RECORD,
 #         g_x  ARRAY[35] OF VARCHAR(40),        # Report Heading & prompt #MOD-540174
#         g_m  ARRAY[40] OF VARCHAR(60),        # Report Memo
          g_m  ARRAY[40] OF LIKE oao_file.oao06,   #No.MOD-610046
          l_outbill   LIKE oga_file.oga01    # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137  VARCHAR(72)
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT
#FUN-580004--end
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oga01     LIKE oga_file.oga01,
          oga03     LIKE oga_file.oga03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE  g_oga01     LIKE oga_file.oga01   #FUN-650020
#FUN-710081--start
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  l_table3   STRING   #CHI-7A0011 add
DEFINE  l_table4   STRING                 #No.FUN-860026 
DEFINE  l_table5   STRING  
DEFINE  l_str      STRING
#FUN-710081--end
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   #MOD-B90173 --- start ---
   LET tm.d    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)
   LET tm.c    = ARG_VAL(11)
   LET tm.e    = ARG_VAL(12)
   LET tm.f    = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   #LET tm.b    = ARG_VAL(9)
   #LET tm.c    = ARG_VAL(10)
   #LET tm.e    = ARG_VAL(11)   #No.FUN-860026
   #LET tm.f    = ARG_VAL(12)   #No.FUN-A80083
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(13)
   #LET g_rep_clas = ARG_VAL(14)
   #LET g_template = ARG_VAL(15)
   #LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #MOD-B90173 ---  end ---
 #--------------No.TQC-610089 end
 #FUN-710081--start
    LET g_sql ="oga01.oga_file.oga01,  oga011.oga_file.oga011,",
               "oga02.oga_file.oga02,  oga16.oga_file.oga16,",
               "oga021.oga_file.oga021,oga15.oga_file.oga15,",
               "gem02.gem_file.gem02,  oga032.oga_file.oga032,",
               "oga033.oga_file.oga033,oga045.oga_file.oga45,",
               "oga03.oga_file.oga03,  oga04.oga_file.oga04,",
               "oga14.oga_file.oga14,  gen02.gen_file.gen02,",
               "occ02.occ_file.occ02,  addr1.occ_file.occ241,",   #TQC-7A0024 mod
               "addr2.occ_file.occ241, addr3.occ_file.occ241,",   #TQC-7A0024 mod
               "addr4.occ_file.occ241, addr5.occ_file.occ241,",   #TQC-7A0024 mod   #FUN-720014
               "ogb03.ogb_file.ogb03,  ogb04.ogb_file.ogb04,",
               "donum.type_file.chr20, ogb12.ogb_file.ogb12,",
               "ogb05.ogb_file.ogb05,  ima02.ima_file.ima02,",
               "weight.ogb_file.ogb12, ogb19.ogb_file.ogb19,",
               "ima021.ima_file.ima021,note.type_file.chr37,",
               "str3.type_file.chr1000,ogb11.ogb_file.ogb11,",
               "zo041.zo_file.zo041,   zo05.zo_file.zo05,",       #FUN-810029 add
#               "zo09.zo_file.zo09"                                #FUN-810029 add  #No.FUN-860026
               "zo09.zo_file.zo09,flag.type_file.num5,flag1.type_file.num5,",             #No.FUN-860026 
               "message.type_file.chr1000,ogb07.ogb_file.ogb07,",   #MOD-8A0255  #FUN-A80083 add ogb07
               "l_count.type_file.num5,",
               "sign_type.type_file.chr1,",       #FUN-940044 add
               "sign_img.type_file.blob,",        #FUN-940044 add
               "sign_show.type_file.chr1,",       #FUN-940044 add
               "sign_str.type_file.chr1000"       #TQC-C10039
   LET l_table = cl_prt_temptable('axmr600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
#  LET g_sql ="ogc01.ogc_file.ogc01,",   #MOD-B70149 mark
   LET g_sql ="ogc01.ogb_file.ogb04,",   #MOD-B70149
              "ogb03.ogb_file.ogb03,",   #CHI-7A0011 add
              "i1.type_file.num5,",
              "loc.type_file.chr37,",
              "ogc16.ogc_file.ogc16"
   LET l_table1 = cl_prt_temptable('axmr6001',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="ogc01.ogc_file.ogc01,",
              "ogb03.ogb_file.ogb03,",   #CHI-7A0011 add
              "i2.type_file.num5,",
              "ogc17.ogc_file.ogc17,",
              "ogc12.ogc_file.ogc12,",
              "ima02t.ima_file.ima02"
   LET l_table2 = cl_prt_temptable('axmr6002',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
  #str CHI-7A0011 add
   #備註
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao04.oao_file.oao04,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06"
   LET l_table3 = cl_prt_temptable('axmr6003',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
  #end CHI-7A0011 add
 #FUN-710081--end
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",                                                                                          
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ogb06.ogb_file.ogb06,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ogb05.ogb_file.ogb05,",                                                                                             
               "ogb12.ogb_file.ogb12,",                                                                                             
               "img09.img_file.img09"                                                                                               
   LET l_table4 = cl_prt_temptable('axmr6004',g_sql) CLIPPED                                                                        
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF                                                                                       
#No.FUN-860026---end  
   #No.FUN-A80083 --start--
   LET g_sql = "imc01.imc_file.imc01,",
               "imc02.imc_file.imc02,",
               "imc03.imc_file.imc03,",
               "imc04.imc_file.imc04,",
               "oga01.oga_file.oga01,",
               "ogb03.ogb_file.ogb03"
    LET l_table5 = cl_prt_temptable('axmr6005',g_sql) CLIPPED
    IF  l_table5 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80083 --end--   
   IF cl_null(tm.wc) THEN
      CALL axmr600_tm(0,0)             # Input print condition
   ELSE
     #LET tm.wc="oga01 ='",tm.wc CLIPPED,"' " CLIPPED    #No.TQC-610089 mark
      LET tm.a = "1"    #No.MOD-580084
      CALL axmr600()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr600_tm(p_row,p_col)
#DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031 #MOD-B50154 mark
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr600_w AT p_row,p_col WITH FORM "axm/42f/axmr600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#No.FUN-5C0075--begin
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
#No.FUN-5C0075--end
 
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oga01,oga02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         #### No.FUN-4A0020
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  #No.TQC-5B0095
                 LET g_qryparam.arg1 = "2','3','4','6','7','8','A"   #No.TQC-5B0095 #No.FUN-610020   #TQC-BB0013 add "A"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
            END CASE
         ### END  No.FUN-4A0020
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

         #MOD-B50154 add --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #MOD-B50154 add --end--
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmr600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.a = '1'
      LET tm.d = 'N'  #FUN-690032 add
      LET tm.b = 'Y'
      LET tm.c = 'N'     #No.FUN-5C0075
      LET tm.e = 'N'  #No.FUN-860026
      LET tm.f = 'N'  #No.FUN-A80083
      INPUT BY NAME tm.a,tm.d,tm.b,tm.c,tm.e,tm.f,tm.more WITHOUT DEFAULTS   #No.FUN-5C0075  #FUN-690032 add tm.d #No.FUN-860026 #FUN-A80083 tm.f
 
        #MOD-B50154 mark --start--
        ##No.FUN-580031 --start--
        #BEFORE INPUT
        #    CALL cl_qbe_display_condition(lc_qbe_sn)
        ##No.FUN-580031 ---end---
        #MOD-B50154 mark --end--
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
               NEXT FIELD a
            END IF
 
        #FUN-690032 add--begin
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
               NEXT FIELD d
            END IF
        #FUN-690032 add--end 
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
#No.FUN-5C0075--begin
        AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
             NEXT FIELD c
          END IF
#No.FUN-5C0075--end
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD e    #列印批序號明細                                                                                              
         IF tm.e NOT MATCHES "[YN]" OR cl_null(tm.e)                                                                                
            THEN NEXT FIELD e                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END   
         #FUN-A80083 add--begin
         AFTER FIELD f
            IF cl_null(tm.f) OR tm.f NOT MATCHES '[YN]' THEN
               NEXT FIELD f
            END IF
        #FUN-A80083 add--end 
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
            CALL cl_cmdask()
 
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
 
        #MOD-B50154 mark --start--
        ##No.FUN-580031 --start--
        #ON ACTION qbe_save
        #   CALL cl_qbe_save()
        ##No.FUN-580031 ---end---
        #MOD-B50154 mark --end--
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmr600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'axmr600'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr600','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,  #FUN-690032 add
                       #---------
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                        " '",tm.e CLIPPED,"'",                 #No.FUN-860026 
                        " '",tm.f CLIPPED,"'",                 #No.FUN-A80083
                       #------------No.TQC-610089 end
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmr600',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axmr600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL axmr600()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axmr600_w
 
END FUNCTION
 
FUNCTION axmr600()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
     #    l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,  #Mod No:TQC-B30063
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_count    LIKE type_file.num5,         #No.FUN-A80083
          sr        RECORD
                       oga01     LIKE oga_file.oga01,
                       oaydesc   LIKE oay_file.oaydesc,
                       oga02     LIKE oga_file.oga02,
                       oga021    LIKE oga_file.oga021,
                       oga011    LIKE oga_file.oga011,
                       oga14     LIKE oga_file.oga14,
                       oga15     LIKE oga_file.oga15,
                       oga16     LIKE oga_file.oga16,
                       oga032    LIKE oga_file.oga032,
                       oga03     LIKE oga_file.oga03,
                       oga033    LIKE oga_file.oga033,   #統一編號
                       oga45     LIKE oga_file.oga45,    #聯絡人
                       occ02     LIKE occ_file.occ02,
                       oga04     LIKE oga_file.oga04,
                       oga044    LIKE oga_file.oga044,
                       ogb03     LIKE ogb_file.ogb03,
                       ogb31     LIKE ogb_file.ogb31,
                       ogb32     LIKE ogb_file.ogb32,
                       ogb04     LIKE ogb_file.ogb04,
                       ogb092    LIKE ogb_file.ogb092,
                       ogb05     LIKE ogb_file.ogb05,
                       ogb12     LIKE ogb_file.ogb12,
                       ogb06     LIKE ogb_file.ogb06,
                       ogb11     LIKE ogb_file.ogb11,
                       ogb17     LIKE ogb_file.ogb17,
                       ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
                       ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                       ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                       ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                       ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
                       ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
                       ima18     LIKE ima_file.ima18,
                       ogb07     LIKE ogb_file.ogb07
                    END RECORD,
           #No.FUN-A80083  --start--
           sr1        RECORD
                      imc01     LIKE imc_file.imc01,
                      imc02     LIKE imc_file.imc02,
                      imc03     LIKE imc_file.imc03,
                      imc04     LIKE imc_file.imc04
                      END RECORD
          #No.FUN-A80083  --end--
   DEFINE oao       RECORD LIKE oao_file.*                  #CHI-7A0011 add
   DEFINE l_msg     STRING    #FUN-650020
   DEFINE l_msg2    STRING    #FUN-650020
   DEFINE lc_gaq03  LIKE gaq_file.gaq03   #FUN-650020
   DEFINE l_zo041   LIKE zo_file.zo041    #FUN-810029 add
   DEFINE l_zo05    LIKE zo_file.zo05     #FUN-810029 add
   DEFINE l_zo09    LIKE zo_file.zo09     #FUN-810029 add
#NO.FUN-710081--start
#yoyo--start
   DEFINE  l_ogb       RECORD LIKE ogb_file.*
  #MOD-710194-begin
  #DEFINE         l_addr1    LIKE aaf_file.aaf03
  #DEFINE         l_addr2    LIKE aaf_file.aaf03
  #DEFINE         l_addr3    LIKE aaf_file.aaf03
   DEFINE         l_addr1,l_addr2,l_addr3 LIKE occ_file.occ241
  #MOD-710194-end
   DEFINE         l_addr4,l_addr5 LIKE occ_file.occ241   #No.FUN-730014
   DEFINE         l_gen02    LIKE gen_file.gen02
   DEFINE         l_oag02    LIKE oag_file.oag02
   DEFINE         l_gem02    LIKE gem_file.gem02
   DEFINE         l_ogb12    LIKE ogb_file.ogb12
   DEFINE         l_str2     STRING
   DEFINE         l_str3     LIKE type_file.chr1000
   DEFINE         l_ogc      RECORD
                    ogc09     LIKE ogc_file.ogc09,
                    ogc091    LIKE ogc_file.ogc091,
                    ogc16     LIKE ogc_file.ogc16,
                    ogc092    LIKE ogc_file.ogc092
                             END RECORD
   DEFINE         l_loc      LIKE type_file.chr37
   DEFINE         l_weight   LIKE ogb_file.ogb12
   DEFINE         l_donum    LIKE type_file.chr20
   DEFINE         l_ima906   LIKE ima_file.ima906
   DEFINE         l_ima021   LIKE ima_file.ima021  
   DEFINE         l_ima02    LIKE ima_file.ima02
   DEFINE         l_ogb915   STRING
   DEFINE         l_ogb912   STRING
   DEFINE         l_note     LIKE type_file.chr37
   DEFINE         l_oga09    LIKE oga_file.oga09
   DEFINE         l_oaz23    LIKE oaz_file.oaz23
   DEFINE         g_ogc      RECORD
                   ogc12      LIKE ogc_file.ogc12,
                   ogc17      LIKE ogc_file.ogc17
                             END RECORD
#No.710081--end
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09
     DEFINE        l_str1      LIKE type_file.chr1000                                                                                  
     DEFINE        flag        LIKE type_file.num5
     DEFINE        flag1        LIKE type_file.num5
#No.FUN-860026---end   
   
   #FUN-B940044 START
   DEFINE l_img_blob         LIKE type_file.blob
#TQC-C10039-start mark-
#   DEFINE l_ii               INTEGER                   
#   DEFINE l_key              RECORD 
#          v1                 LIKE oga_file.oga01
#          END RECORD 
#TQC-C10039-end mark-
   #FUN-B940044 END    
   
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)   #CHI-7A0011 add
   CALL cl_del_data(l_table4)   #No.FUN-860026  
   CALL cl_del_data(l_table5)   #No.FUN-A80083
   LOCATE l_img_blob IN MEMORY   #FUN-B940044
  #str FUN-810029 mod
  #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_rlang
  #end FUN-810029 mod
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #MOD-540174..................begin
#  DECLARE axmr600_za_cur CURSOR FOR
#          SELECT za02,za05 FROM za_file
#           WHERE za01 = "axmr600" AND za03 = g_rlang
#  FOREACH axmr600_za_cur INTO g_i,l_za05
#     LET g_x[g_i] = l_za05
#  END FOREACH
   #MOD-540174..................end
#FUN-710081--start
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr600' 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr600'  
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
#               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  #FUN-720014 add 2欄位   #FUN-810029 32?->35?   #No.FUN-860026 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?,?)"   #TQC-C10039 add 1?   #FUN-B940044 add 3?  #No.FUN-860026   #MOD-8A0255 37->38
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " values(?,?,?,?,?)"      #CHI-7A0011 add ?
   PREPARE insert1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " values(?,?,?,?,?, ?)"   #CHI-7A0011 add ?
   PREPARE insert2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF  
  #str CHI-7A0011 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " values(?,?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep3:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
  #end CHI-7A0011 add
#No.FUN-860026---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep4 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep4:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-860026---END
#No.FUN-A80083---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep5 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep5:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-A80083---END
#   LET g_len = 134           #No.FUN-570176
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#FUN-710081--end
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
#No.FUN-B10026 ---begin---
   LET l_sql="SELECT oga09 FROM oga_file WHERE ",tm.wc CLIPPED
   PREPARE oga09_pre FROM l_sql
   EXECUTE oga09_pre INTO l_oga09
##No.FUN-B10026 ---end---
 
   LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16,",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogb03,",
             "       ogb31,ogb32,ogb04,ogb092,ogb05,ogb12,ogb06,ogb11,",
             "       ogb17,ogb19,ogb910,ogb912,ogb913,ogb915,ogb916,ima18,ogb07",  #No.FUN-580004 #TQC-5B0127 add ogb916 AND FUN-5C0075  #FUN-A80083 add ogb07
             " FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE ltrim(rtrim(oay_file.oayslip)) || '-%' ",
                            " LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogb_file ",
                            " LEFT OUTER JOIN ima_file ON ogb_file.ogb04 = ima_file.ima01 ",
             " WHERE oga01 = ogb01 ", 
#No.FUN-550070--end
           # "   AND oga09 != '1' AND oga09 != '5' AND oga09 !='9'", #No.FUN-610020# No.FUN-B10026 mark
             "   AND oga09 != '1' AND oga09 != '5' ",                              #No.FUN-B10026 add 
             "   AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' " #01/08/20 mandy

#No.FUN-B10026 ---begin---
   IF l_oga09 = '9' THEN
      LET l_sql = l_sql CLIPPED," AND oga09 !='8' "
   ELSE
      LET l_sql = l_sql CLIPPED," AND oga09 !='9' "
   END IF
#No.FUN-B10026 ---end---

   LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
 
   PREPARE axmr600_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
#FUN-710081--start
   DECLARE axmr600_curs1 CURSOR FOR axmr600_prepare1

#TQC-C10039--START MARK--
#   #FUN-940044 START
#   LET l_sql="SELECT oga01",
#              " FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE ltrim(rtrim(oay_file.oayslip)) || '-%' ",
#                            " LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogb_file ",
#                            " LEFT OUTER JOIN ima_file ON ogb_file.ogb04 = ima_file.ima01 ",
#             " WHERE oga01 = ogb01 ", 
#             "   AND oga09 != '1' AND oga09 != '5' ",      
#             "   AND ",tm.wc CLIPPED,
#             "   AND ogaconf != 'X' " 
#
#   IF l_oga09 = '9' THEN
#      LET l_sql = l_sql CLIPPED," AND oga09 !='8' "
#   ELSE
#      LET l_sql = l_sql CLIPPED," AND oga09 !='9' "
#   END IF
#
#   LET l_sql= l_sql CLIPPED," ORDER BY oga01"
# 
#   PREPARE axmr600_prepare4 FROM l_sql
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare4:',SQLCA.sqlcode,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
#      EXIT PROGRAM
#   END IF
# 
#   DECLARE r600_cs4 CURSOR FOR axmr600_prepare4
#   #FUN-940044 END
#TQC-C10039--END MARK--
   
#   CALL cl_outnam('axmr600') RETURNING l_name
 
   #FUN-580004--begin
   SELECT sma115 INTO g_sma115 FROM sma_file
#  IF g_sma115 = "Y" THEN
#     LET g_zaa[34].zaa06 = "N"
#    #LET g_zaa[45].zaa06 = "N" #FUN-5A0181 mark
#  ELSE
#     LET g_zaa[34].zaa06 = "Y"
#    #LET g_zaa[45].zaa06 = "Y" #FUN-5A0181 mark
#  END IF
 
 #FUN-690032 add--begin  #列印客戶料號
#  IF tm.d = 'N' THEN
#     LET g_zaa[56].zaa06 = 'Y'
#  ELSE
#     LET g_zaa[56].zaa06 = 'N'
#  END IF
 #FUN-690032 add--end
 
#   CALL cl_prt_pos_len()
   #No.FUN-580004--end
 
#   START REPORT axmr600_rep TO l_name
 
#   LET g_pageno = 0
 
#FUN-710081--end
   CALL g_show_msg.clear() #FUN-650020
   
   FOREACH axmr600_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.ogb092 IS NULL THEN
         LET sr.ogb092 = ' '
      END IF
 
     #-----MOD-8A0255---------
     LET g_msg=NULL
     IF g_oaz.oaz141 = "1" THEN
        CALL s_ccc_logerr() 
        LET g_oga01=sr.oga01 
        CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
        IF r600_err_ana(g_showmsg) THEN
        END IF
        IF g_errno = 'N' THEN
           CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
        END IF
     END IF
     #-----END MOD-8A0255-----
      
#FUN-710081--start
      SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
      IF STATUS THEN
         LET l_gen02 = ''
      END IF
 
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
      IF STATUS THEN
         LET l_gem02 = ''
      END IF
 
      CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
           RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5  #No.FUN-730014 addr4/addr5
      IF SQLCA.SQLCODE THEN
         LET l_addr1 = ''
         LET l_addr2 = ''
         LET l_addr3 = ''
         LET l_addr4 = ''    #No.FUN-730014 
         LET l_addr5 = ''    #No.FUN-730014 
      END IF
         
#TQC-5B0127--add
      LET flag1 = 0    #No.FUN-860026
      IF tm.b = 'Y' THEN  #MOD-B60181 add 
     #str CHI-7A0011 mod
      #列印單身備註
         DECLARE oao_c2 CURSOR FOR
          SELECT * FROM oao_file
           WHERE oao01=sr.oga01 AND oao03=sr.ogb03 AND (oao05='1' OR oao05='2')
         FOREACH oao_c2 INTO oao.*
             LET flag1 = 1   #No.FUN-860026
            IF NOT cl_null(oao.oao06) THEN
               EXECUTE insert_prep3 USING
                  sr.oga01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
            END IF
         END FOREACH
     #end CHI-7A0011 mod
      END IF              #MOD-B60181 add

      #-----MOD-850070---------
      #SELECT ima02,ima021,ima906 #FUN-650005 add ima02   
      #  INTO l_ima02,l_ima021,l_ima906 #FUN-650005 add ima02
      SELECT ima021,ima906 #FUN-650005 add ima02   
        INTO l_ima021,l_ima906 #FUN-650005 add ima02
      #-----END MOD-850070-----
        FROM ima_file
       WHERE ima01=sr.ogb04
      LEt l_ima02 = sr.ogb06   #MOD-850070
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                  END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
        #IF sr.ogb910 <> sr.ogb916 THEN   #NO.TQC-6B0137 mark
         IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
            CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
            LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
         END IF
      END IF
      LET l_donum = sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###'
      LET l_weight = sr.ogb12*sr.ima18
      LET l_note = l_str2 clipped
#TQC-5B0127--end
      #No.FUN-610020  --Begin 打印客戶驗退數量
      IF l_oga09 = '8' THEN
         SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
          WHERE oga01 = ogb01 AND oga011 = sr.oga011
            AND ogb03 = sr.ogb03 AND oga09 = '9'
         LET l_str3 = ''   #MOD-B70043 add
         IF SQLCA.sqlcode = 0 THEN
            IF g_sma115 = "Y" THEN
               CASE l_ima906
                  WHEN "2"
                      CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                      LET l_str3 = l_ogb915 , l_ogb.ogb913 CLIPPED
                      IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
                          CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                          LET l_str3 = l_ogb912, l_ogb.ogb910 CLIPPED
                      ELSE
                         IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
                            CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                            LET l_str3 = l_str3 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
                         END IF
                        END IF
                  WHEN "3"
                      IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
                          CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                          LET l_str3 = l_ogb915 , l_ogb.ogb913 CLIPPED
                      END IF
               END CASE
            END IF
            IF g_sma.sma116 MATCHES '[23]' THEN           #No.FUN-610076
                 #IF l_ogb.ogb910 <> l_ogb.ogb916 THEN    #No.TQC-6B0137 mark
                  IF l_ogb.ogb05  <> l_ogb.ogb916 THEN    #NO.TQC-6B0137 mod
                     CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
                     LET l_str3 = l_str3 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
                  END IF
            END IF
            LET l_str3=l_str3 CLIPPED,(21-LENGTH(l_str3 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
         END IF
      END IF
      #No.FUN-610020  --End
      IF tm.a ='1' THEN
         CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
            WHEN 'Y'
               LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
                         " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
            WHEN 'N'
               LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
                         " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
         END CASE
      ELSE
         LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
                   " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
                   "   AND img10 > 0 "
      END IF
 
      PREPARE r600_p2 FROM l_sql
      DECLARE r600_c2 CURSOR FOR r600_p2
      LET i=1
      FOREACH r600_c2 INTO l_ogc.*
         LET l_loc = "(",l_ogc.ogc09 clipped
         IF l_ogc.ogc091 IS NOT NULL THEN
            LET l_loc = l_loc clipped,"/",l_ogc.ogc091 clipped
         END IF
         IF l_ogc.ogc092 IS NOT NULL THEN
            LET l_loc = l_loc clipped,"/",l_ogc.ogc092 clipped
         END IF
         LET l_loc = l_loc clipped,")"
         IF STATUS THEN EXIT FOREACH END IF
         IF tm.a ='1' THEN
            EXECUTE insert1 USING 
               sr.oga01,sr.ogb03,i,l_loc,l_ogc.ogc16   #CHI-7A0011 mod
         ELSE  
            EXECUTE insert1 USING 
               sr.ogb04,sr.ogb03,i,l_loc,l_ogc.ogc16   #CHI-7A0011 mod
         END IF
         LET i = i+1
 
      END FOREACH
#No.FUN-5C0075--begin
      SELECT oaz23 INTO l_oaz23 FROM oaz_file
      IF l_oaz23 = 'Y'  AND tm.c = 'Y' THEN
         LET g_sql = "SELECT ogc12,ogc17 ",
                     "  FROM ogc_file",
                     " WHERE ogc01 = '",sr.oga01,"'"
         PREPARE ogc_prepare FROM g_sql
         DECLARE ogc_cs CURSOR FOR ogc_prepare
         LET i = 1
         FOREACH ogc_cs INTO g_ogc.*
            SELECT ima02 INTO l_ima02 FROM ima_file
             WHERE ima01 = g_ogc.ogc17 
            EXECUTE insert2 USING 
               sr.oga01,sr.ogb03,i,g_ogc.ogc17,g_ogc.ogc12,l_ima02   #CHI-7A0011 mod
            LET i = i+1
         END FOREACH
      END IF
#No.FUN-5C0075--end           
#No.FUN-860026---begin                                                                                                              
    LET flag = 0                                                                                                                                    
    SELECT img09 INTO l_img09  FROM img_file,ogb_file                                                                               
               WHERE img01 = sr.ogb04                                                                                               
               AND img02 = ogb09 AND img03 = ogb091                                                                                 
               AND img04 = ogb092 AND ogb01 = sr.oga01                                                                              
               AND ogb03 = sr.ogb03                                                                                                 
    DECLARE r920_c  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = sr.oga01 AND rvbs02 = sr.ogb03     
                  AND rvbs00 <> 'aqct800'   #MOD-BB0203 add                  
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_c INTO l_rvbs.*                    
         LET flag = 1                                                                                
         EXECUTE insert_prep4 USING  sr.oga01,sr.ogb03,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     l_ima02,l_ima021,sr.ogb05,sr.ogb12,                                                            
                                     l_img09                                                                                        
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end    
#      OUTPUT TO REPORT axmr600_rep(sr.*)
      #No.FUN-A80083  --start  列印額外品名規格說明
      IF tm.f = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM imc_file
             WHERE imc01=sr.ogb04 AND imc02=sr.ogb07
          IF l_count !=0  THEN
            DECLARE imc_cur CURSOR FOR
            SELECT * FROM imc_file    
              WHERE imc01=sr.ogb04 AND imc02=sr.ogb07 
            ORDER BY imc03                                        
            FOREACH imc_cur INTO sr1.*                            
              EXECUTE insert_prep5 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,sr.oga01,sr.ogb03
            END FOREACH
          END IF
       END IF    
       #No.FUN-A80083  --end
      EXECUTE insert_prep USING 
         sr.oga01,sr.oga011,sr.oga02,sr.oga16,sr.oga021,sr.oga15,
         l_gem02,sr.oga032,sr.oga033,sr.oga45,sr.oga03,sr.oga04,
         sr.oga14,l_gen02,sr.occ02,l_addr1,
         l_addr2,l_addr3,l_addr4,l_addr5,sr.ogb03,sr.ogb04,l_donum, #FUN-720014 add l_addr4/l_addr5
         sr.ogb12,sr.ogb05,l_ima02,l_weight,sr.ogb19,
         l_ima021,l_note,l_str3,sr.ogb11,
         l_zo041,l_zo05,l_zo09,flag,flag1,g_msg,   #FUN-810029 add    #No.FUN-860026  add flag,flag1   #MOD-8A0255 add g_msg
         sr.ogb07,l_count,  #FUN-A80083
         "",l_img_blob,"N",""    #TQC-C10039 add ""   #FUN-940044
   END FOREACH
 
   IF tm.b = 'Y' THEN   #MOD-B60181 add
  #str CHI-7A0010 add
   #列印整張備註
      LET l_sql = "SELECT oga01 FROM oga_file ",
                  " WHERE ",tm.wc CLIPPED,
                  "   ORDER BY oga01"
      PREPARE r600_prepare2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
      DECLARE r600_cs2 CURSOR FOR r600_prepare2
 
      FOREACH r600_cs2 INTO sr.oga01
         DECLARE oao_c1 CURSOR FOR
          SELECT * FROM oao_file
           WHERE oao01=sr.oga01 AND oao03=0 AND (oao05='1' OR oao05='2')
         FOREACH oao_c1 INTO oao.*
            IF NOT cl_null(oao.oao06) THEN
               EXECUTE insert_prep3 USING
                  sr.oga01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
            END IF
         END FOREACH
      END FOREACH
  #end CHI-7A0010 add
   END IF               #MOD-B60181 add

   #p1,p2
   IF l_oga09 = '7' THEN
      LET l_str = sr.oaydesc CLIPPED," ",g_x[26]
   ELSE
      IF l_oga09 = '8' THEN
         LET l_str = sr.oaydesc CLIPPED," ",g_x[27]
      ELSE
      	 LET l_str = sr.oaydesc CLIPPED," ",g_x[1]
      END IF
   END IF
   
   #p3
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'oga01,oga02')                                            
      RETURNING tm.wc 
#      LET l_str = l_str CLIPPED,";",tm.wc  #No.FUN-860026
       LET l_str1 = tm.wc
   END IF 
 
   #p4~p8
   LET l_str = l_str CLIPPED,";",l_str1,";",tm.c,";",tm.d,
                             ";",l_oaz23 CLIPPED,";",l_oga09,
                             ";",tm.a,";",tm.e,";",tm.f   #CHI-7A0011 add  #No.FUN-860026 add tm.e #FUN-A80083 add tm.f
                             ,";",g_oaz.oaz141 #CHI-A90032 add
                             ,";",g_aza.aza131 #DEV-D30029

   #-----MOD-8A0255---------
   #LET g_msg=NULL
   #IF g_oaz.oaz141 = "1" THEN
   #   CALL s_ccc_logerr() #FUN-650020
   #   LET g_oga01=sr.oga01 #FUN-650020
   #   CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
   #   #FUN-650020...............begin
   #   IF r600_err_ana(g_showmsg) THEN
   #      
   #   END IF
   #   #FUN-650020...............end
   #   IF g_errno = 'N' THEN
   #      CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
   #   END IF
   #END IF
   #-----END MOD-8A0255-----
   
  #str CHI-7A0011 mod 
  #LET l_sql = " SELECT A.*,B.i1,B.loc,B.ogc16,C.i2,C.ogc17,C.ogc12,C.ima02t ",
  #         ## "   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",   #TQC-730088
  #            "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A, ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B, ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C",
  #            " WHERE A.oga01 = B.ogc01(+)",
  #            " AND A.oga01 = C.ogc01(+)"
  #修改成新的子報表的寫法(可組一句主要SQL,十五句子報表SQL)
#No.FUN-860026---begin
#   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
#               " WHERE oao03 =0 AND oao05='1'","|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
#               " WHERE oao03!=0 AND oao05='1'","|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
#               " WHERE oao03!=0 AND oao05='2'","|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
#               " WHERE oao03 =0 AND oao05='2'"
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                            
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                           
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",                                                           
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
               " WHERE oao03 =0 AND oao05='1'","|",                                                                                 
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
               " WHERE oao03!=0 AND oao05='1'","|",                                                                                 
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
               " WHERE oao03!=0 AND oao05='2'","|",                                                                                 
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
               " WHERE oao03 =0 AND oao05='2'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED
#No.FUN-860026---end
  #end CHI-7A0011 mod
  
#TQC-C10039-start  mark-
   #FUN-940044  START
   LET g_cr_table = l_table
#   LET g_cr_gcx01 = "axmi010"
   LET g_cr_apr_key_f = "oga01"

#   LET l_ii = 1

#   CALL g_cr_apr_key.clear()  

#   FOREACH r600_cs4 INTO l_key.* 
#     LET g_cr_apr_key[l_ii].v1 = l_key.v1
#     LET l_ii = l_ii + 1 
#   END FOREACH
   #FUN-940044  END 
#TQC-C10039-end mark-
   
 # CALL cl_prt_cs3('axmr600',l_sql,l_str)        #TQC-730088   
   CALL cl_prt_cs3('axmr600','axmr600',l_sql,l_str)    
 
#   FINISH REPORT axmr600_rep
#FUN-710081--end
 
   #FUN-650020...............begin
   IF g_show_msg.getlength()>0 THEN
      CALL cl_get_feldname("oga01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("oga03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
   END IF
   #FUN-650020...............end
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len) #NO.FUN-710081
 
END FUNCTION
 
#No.FUN-710081--start
{
REPORT axmr600_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          sr           RECORD
                          oga01     LIKE oga_file.oga01,
                          oaydesc   LIKE oay_file.oaydesc,
                          oga02     LIKE oga_file.oga02,
                          oga021    LIKE oga_file.oga021,
                          oga011    LIKE oga_file.oga011,
                          oga14     LIKE oga_file.oga14,
                          oga15     LIKE oga_file.oga15,
                          oga16     LIKE oga_file.oga16,
                          oga032    LIKE oga_file.oga032,
                          oga03     LIKE oga_file.oga03,
                          oga033    LIKE oga_file.oga033,  #統一編號
                          oga45     LIKE oga_file.oga45,   #聯絡人
                          occ02     LIKE occ_file.occ02,
                          oga04     LIKE oga_file.oga04,
                          oga044    LIKE oga_file.oga044,
                          ogb03     LIKE ogb_file.ogb03,
                          ogb31     LIKE ogb_file.ogb31,
                          ogb32     LIKE ogb_file.ogb32,
                          ogb04     LIKE ogb_file.ogb04,
                          ogb092    LIKE ogb_file.ogb092,
                          ogb05     LIKE ogb_file.ogb05,
                          ogb12     LIKE ogb_file.ogb12,
                          ogb06     LIKE ogb_file.ogb06,
                          ogb11     LIKE ogb_file.ogb11,
                          ogb17     LIKE ogb_file.ogb17,
                          ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
                          ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                          ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                          ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                          ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
                          ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
                          ima18     LIKE ima_file.ima18
                       END RECORD,
            l_ogc      RECORD
                          ogc09     LIKE ogc_file.ogc09,
                          ogc091    LIKE ogc_file.ogc091,
                          ogc16     LIKE ogc_file.ogc16,
                          ogc092    LIKE ogc_file.ogc092
                       END RECORD,
           #MOD-680081-begin
           #l_buf      ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)
           #l_buf3     ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)   #FUN-5A0143 add
           #l_buf4     ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)   #FUN-5A0143 add
           #l_buf2     ARRAY[10] OF LIKE ogc_file.ogc16,
            l_buf   DYNAMIC  ARRAY OF LIKE type_file.chr1000,
            l_buf3  DYNAMIC  ARRAY OF LIKE type_file.chr1000,
            l_buf4  DYNAMIC  ARRAY OF LIKE type_file.chr1000,
            l_buf2  DYNAMIC  ARRAY OF LIKE ogc_file.ogc16,
           #MOD-680081-end
            l_flag     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
            l_addr1    LIKE occ_file.occ241,      # No.FUN-680137 VARCHAR(36)
            l_addr2    LIKE occ_file.occ241,      # No.FUN-680137 VARCHAR(36)
            l_addr3    LIKE occ_file.occ241,      # No.FUN-680137 VARCHAR(36)
            l_gen02    LIKE gen_file.gen02,
            l_oag02    LIKE oag_file.oag02,
            l_gem02    LIKE gem_file.gem02,
            l_ogb12    LIKE ogb_file.ogb12,
            l_sql      LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(1000)
            i,j,l_n    LIKE type_file.num5        #No.FUN-680137 SMALLINT
#No.FUN-580004--begin
   DEFINE  l_ogb915    STRING
   DEFINE  l_ogb912    STRING
   DEFINE  l_str2      STRING
   DEFINE  l_ima906    LIKE ima_file.ima906
   DEFINE  l_ima021    LIKE ima_file.ima021 #TQC-5B0127
#No.FUN-580004--end
   DEFINE  l_oga09     LIKE oga_file.oga09
   DEFINE  l_ogb       RECORD LIKE ogb_file.*
#No.FUN-5C0075--begin
 DEFINE
#     g_ogg        RECORD
#                  ogg10 LIKE ogg_file.ogg10,
#                  ogg12 LIKE ogg_file.ogg12,
#                  ogg17 LIKE ogg_file.ogg17
#             END RECORD,
      g_ogc        RECORD
                   ogc12 LIKE ogc_file.ogc12,
                   ogc17 LIKE ogc_file.ogc17
              END RECORD,
      l_oaz23  LIKE oaz_file.oaz23,
      l_ima02  LIKE ima_file.ima02,
      g_sql    LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
#No.FUN-5C0075--end
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.oga01,sr.ogb03
 
   FORMAT
      PAGE HEADER
         LET g_pageno= g_pageno+1
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED           #No.FUN-580004
         PRINT g_x[11] CLIPPED,sr.oga01 CLIPPED,
               COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
         #No.FUN-610020  -Begin
         SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
         IF l_oga09 = '7' THEN
               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
                     ((g_len-FGL_WIDTH(g_x[26]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[26]
         ELSE
            IF l_oga09 = '8' THEN
               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
                     ((g_len-FGL_WIDTH(g_x[27]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[27]
            ELSE
               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
                     ((g_len-FGL_WIDTH(g_x[1]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[1]
            END IF
         END IF
         #No.FUN-610020  -End
         LET g_msg=NULL
         IF g_oaz.oaz141 = "1" THEN
            CALL s_ccc_logerr() #FUN-650020
            LET g_oga01=sr.oga01 #FUN-650020
            CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
            #FUN-650020...............begin
            IF r600_err_ana(g_showmsg) THEN
               
            END IF
            #FUN-650020...............end
            IF g_errno = 'N' THEN
               CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
            END IF
         END IF
         PRINT g_msg CLIPPED
         LET l_last_sw = 'n'                    #FUN-550127
 
      BEFORE GROUP OF sr.oga01
         SKIP TO TOP OF PAGE
 
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
         IF STATUS THEN
            LET l_gen02 = ''
         END IF
 
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
         IF STATUS THEN
            LET l_gem02 = ''
         END IF
 
         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
              RETURNING l_addr1,l_addr2,l_addr3
         IF SQLCA.SQLCODE THEN
            LET l_addr1 = ''
            LET l_addr2 = ''
            LET l_addr3 = ''
         END IF
 
         PRINT g_x[12] CLIPPED,sr.oga02 CLIPPED,
               COLUMN 28,g_x[13] CLIPPED,sr.oga032 CLIPPED,sr.oga033 CLIPPED, ##TQC-5B0110&051112 ##
               sr.oga45 CLIPPED,##sr.oga032 CLIPPED,
               COLUMN 71,'(',sr.oga03 CLIPPED,')'
         PRINT g_x[14] CLIPPED,sr.oga021,
               COLUMN 28,g_x[15] CLIPPED,sr.occ02 CLIPPED, ##TQC-5B0110&051112 ##
               COLUMN 71,'(',sr.oga04 CLIPPED,')'
         PRINT g_x[16] CLIPPED,sr.oga011,
               COLUMN 28,g_x[17] CLIPPED,l_addr1 ##TQC-5B0110&051112 ##
         PRINT g_x[18] CLIPPED,sr.oga16,
               COLUMN 35,l_addr2
         PRINT g_x[19] CLIPPED,l_gen02 CLIPPED,
               COLUMN 28,g_x[20] CLIPPED,l_gem02 CLIPPED, #MOD-560074 19->26 ##TQC-5B0110&051112 ##
               COLUMN 35,l_addr3
 
         IF tm.b = 'Y'  THEN     #列印備註於表頭
            CALL r600_oao(sr.oga01,0,'1')
            FOR l_n = 1 TO 40
               IF NOT cl_null(g_m[l_n]) THEN
                  PRINT g_m[l_n]  CLIPPED
               ELSE
                  LET l_n = 40
               END IF
            END FOR
         END IF
 
         PRINT g_dash[1,g_len]
#no.FUN-550070-begin
#no.FUN-580004--begin
         #FUN-650005...............begin
         #FUN-5A0143 add
         #PRINTX name = H1 g_x[31],g_x[32],g_x[35],g_x[36],g_x[38],g_x[40]
         #PRINTX name = H2 g_x[39],g_x[51],g_x[37],g_x[47],g_x[48],g_x[52]    #No.FUN-5C0075
         #PRINTX name = H3 g_x[43],g_x[33],g_x[34]
         #PRINTX name = H4 g_x[50],g_x[41]
         #FUN-5A0143 end
         PRINTX name = H1 g_x[31],g_x[32],g_x[52],g_x[35],g_x[36],g_x[40]
         PRINTX name = H2 g_x[39],g_x[33],g_x[34]
         PRINTX name = H3 g_x[43],g_x[41]
         PRINTX name = H4 g_x[50],g_x[51]
        #FUN-690032 --begin
         PRINTX name = H5 g_x[55],g_x[56]
        #H5->H6 
        #PRINTX name = H5 g_x[53],g_x[54],g_x[37],g_x[47],g_x[48],g_x[38]
         PRINTX name = H6 g_x[53],g_x[54],g_x[37],g_x[47],g_x[48],g_x[38]
        #FUN-690032 --end 
        #FUN-650005...............end
         PRINT g_dash1
#no.FUN-580004--end
 
      ON EVERY ROW
        #MOD-680081-begin-add
         #FOR i = 1 TO 10
         #    INITIALIZE l_buf[i]  TO NULL
         #    INITIALIZE l_buf2[i] TO NULL
         #    INITIALIZE l_buf3[i] TO NULL   #FUN-5A0143 add
         #    INITIALIZE l_buf4[i]  TO NULL  #FUN-5A0143 add
         #END FOR
          CALL l_buf.clear()
          CALL l_buf2.clear()
          CALL l_buf3.clear()
          CALL l_buf4.clear()
        #MOD-680081-end-add
 
         IF tm.a ='1' THEN
            CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
               WHEN 'Y'
                  LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
                            " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
               WHEN 'N'
                  LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
                            " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
            END CASE
         ELSE
            LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
                      " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
                      "   AND img10 > 0 "
         END IF
 
         PREPARE r600_p2 FROM l_sql
         DECLARE r600_c2 CURSOR FOR r600_p2
         #FUN-650005...............begin  #本段移到下面去做
         #LET i = 1
         #FOREACH r600_c2 INTO l_ogc.*
         #   IF STATUS THEN EXIT FOREACH END IF
         #   LET l_buf[i][ 1,10]=l_ogc.ogc09  #FUN-5A0143 add
         #   LET l_buf3[i]=l_ogc.ogc091       #FUN-5A0143add
         #   LET l_buf4[i]=l_ogc.ogc092       #FUN-5A0143add
         #   LET l_buf2[i]=l_ogc.ogc16
         #   LET i=i+1
         #   IF i > 10 THEN LET i=10 EXIT FOREACH END IF
         #END FOREACH
         #FUN-650005...............end
         IF tm.b = 'Y'  THEN     #列印備註於單身前
            CALL r600_oao(sr.oga01,sr.ogb03,'1')
            FOR l_n = 1 TO 40
               IF NOT cl_null(g_m[l_n]) THEN
                  PRINT g_m[l_n]  CLIPPED
               ELSE
                  LET l_n = 40
               END IF
            END FOR
         END IF
#TQC-5B0127--add
 
      SELECT ima02,ima021,ima906 #FUN-650005 add ima02
        INTO l_ima02,l_ima021,l_ima906 #FUN-650005 add ima02
        FROM ima_file
       WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                  END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
           #IF sr.ogb910 <> sr.ogb916 THEN   #NO.TQC-6B0137 mark
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
#TQC-5B0127--end
 
#no.FUN-570176--start--
#no.FUN-580004--begin
         #FUN-5A0143 add
         PRINTX name = D1
               #FUN-650005...............begin
               #COLUMN g_c[31],sr.ogb03 USING '####',
               #COLUMN g_c[32],sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###',
               #COLUMN g_c[35],sr.ogb05,
               #COLUMN g_c[36],sr.ogb12 USING '###,###,##&.###',
               #COLUMN g_c[38],l_buf2[1] USING '###,###,##&.###',
               #COLUMN g_c[40],sr.ima18*sr.ogb12 USING '#####.###'
               COLUMN g_c[31],cl_numfor(sr.ogb03,31,0),
               COLUMN g_c[32],sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###',
               COLUMN g_c[52],sr.ogb19,
               COLUMN g_c[35],sr.ogb05,
               COLUMN g_c[36],cl_numfor(sr.ogb12,36,3),
               COLUMN g_c[40],cl_numfor(sr.ima18*sr.ogb12,40,3)
               #FUN-650005...............end
         #FUN-5A0143 end
         #FUN-5A0143 add
         PRINTX name = D2
               #FUN-650005...............begin
               #COLUMN g_c[39], '',
               #COLUMN g_c[37],l_buf[1] CLIPPED,
               #COLUMN g_c[47],l_buf3[1] CLIPPED,
               #COLUMN g_c[48],l_buf4[1] CLIPPED,
               #COLUMN g_c[52],sr.ogb19
                COLUMN g_c[33],sr.ogb04 CLIPPED,
                COLUMN g_c[34],l_str2 CLIPPED
               #FUN-650005...............end
         #FUN-5A0143 end
         #FUN-5A0143 add
         PRINTX name = D3
              #FUN-650005...............begin
              #COLUMN g_c[33],sr.ogb04 CLIPPED,
              #COLUMN g_c[34],l_str2 CLIPPED
               COLUMN g_c[41],l_ima02 CLIPPED
              #FUN-650005...............end
         PRINTX name = D4
              #FUN-650005...............begin
              #COLUMN g_c[41],sr.ogb06 CLIPPED
              COLUMN g_c[51],l_ima021 CLIPPED
              #FUN-650005...............end
 
         PRINTX name = D5 COLUMN g_c[56],sr.ogb11 CLIPPED  #FUN-690032 add
 
         #FUN-650005...............begin     
         #FOR j = 3 TO i
         #    PRINTX name = D2
         #          COLUMN g_c[37],l_buf[j] CLIPPED,
         #          COLUMN g_c[47],l_buf3[j] CLIPPED,
         #          COLUMN g_c[48],l_buf4[j] CLIPPED
         #    PRINTX name = D1
         #          COLUMN g_c[38],l_buf2[j] USING '###,###,##&.###'
         ##FUN-5A0143 end
         #END FOR
          LET i=0
          FOREACH r600_c2 INTO l_ogc.*
             IF STATUS THEN EXIT FOREACH END IF
            
            #FUN-690032 D5->D6
            #PRINTX name = D5
             PRINTX name = D6
                   COLUMN g_c[37],l_ogc.ogc09,
                   COLUMN g_c[47],l_ogc.ogc091,
                   COLUMN g_c[48],l_ogc.ogc092,
                   COLUMN g_c[38],cl_numfor(l_ogc.ogc16,38,3)
             LET i=i+1
            #IF i > 10 THEN LET i=10 EXIT FOREACH END IF   #MOD-680081 add
          END FOREACH         
         #FUN-650005...............end
#no.FUN-580004--end
         #No.FUN-610020  --Begin 打印客戶驗退數量
         IF l_oga09 = '8' THEN
            SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
             WHERE oga01 = ogb01 AND oga011 = sr.oga011
               AND ogb03 = sr.ogb03 AND oga09 = '9'
            IF SQLCA.sqlcode = 0 THEN
               IF g_sma115 = "Y" THEN
                  CASE l_ima906
                     WHEN "2"
                         CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                         LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
                         IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
                             CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                             LET l_str2 = l_ogb912, l_ogb.ogb910 CLIPPED
                         ELSE
                            IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
                               CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                               LET l_str2 = l_str2 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
                            END IF
                           END IF
                     WHEN "3"
                         IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
                             CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                             LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
                         END IF
                  END CASE
               END IF
               IF g_sma.sma116 MATCHES '[23]' THEN           #No.FUN-610076
                    #IF l_ogb.ogb910 <> l_ogb.ogb916 THEN    #No.TQC-6B0137 mark
                     IF l_ogb.ogb05  <> l_ogb.ogb916 THEN    #NO.TQC-6B0137 mod
                        CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
                        LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
                     END IF
               END IF
               LET l_str2=l_str2 CLIPPED,(21-LENGTH(l_str2 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
               PRINTX name = D3
                     COLUMN g_c[33],g_x[28] CLIPPED,
                     COLUMN g_c[34],l_str2 CLIPPED
               PRINTX name = D2
                     COLUMN g_c[37],l_ogb.ogb09,
                     COLUMN g_c[47],l_ogb.ogb091,
                     COLUMN g_c[48],l_ogb.ogb092
            END IF
         END IF
         #No.FUN-610020  --End
 
#No.FUN-5C0075--begin
            SELECT oaz23 INTO l_oaz23 FROM oaz_file
            IF l_oaz23 = 'Y' AND tm.c = 'Y' THEN
              PRINTX name = S1
                    COLUMN g_c[32],g_x[23],
                    COLUMN g_c[36],g_x[24]
            END IF
            IF l_oaz23 = 'Y'  AND tm.c = 'Y' THEN
               LET g_sql = "SELECT ogc12,ogc17 ",
                           "  FROM ogc_file",
                           " WHERE ogc01 = '",sr.oga01,"'"
            PREPARE ogc_prepare FROM g_sql
            DECLARE ogc_cs CURSOR FOR ogc_prepare
            FOREACH ogc_cs INTO g_ogc.*
               SELECT ima02 INTO l_ima02 FROM ima_file
                WHERE ima01 = g_ogc.ogc17
               PRINTX name = D1
                     COLUMN g_c[32],g_ogc.ogc17,
                     COLUMN g_c[36],g_ogc.ogc12 USING '###,###,##&.###'
               PRINTX name = D1
                     COLUMN g_c[32],l_ima02
            END FOREACH
            END IF
#No.FUN-5C0075--end
#no.FUN-570176--end--
         IF tm.b = 'Y'  THEN     #列印備註於單身後
            CALL r600_oao(sr.oga01,sr.ogb03,'2')
            FOR l_n = 1 TO 40
               IF NOT cl_null(g_m[l_n]) THEN
                  PRINT g_m[l_n] CLIPPED
               ELSE
                  LET l_n = 40
               END IF
            END FOR
         END IF
 
      AFTER GROUP OF sr.oga01
         LET l_ogb12= GROUP SUM(sr.ogb12)
#no.FUN-580004--begin
         #PRINT  COLUMN g_c[36],'---------------',COLUMN g_c[40],'--------------------' #FUN-650005
         #PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],COLUMN g_c[40],g_dash2[1,g_w[40]] #FUN-650005
#no.FUN-570176--start--
        #MOD-710131-begin-add  
         PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],COLUMN g_c[40],g_dash2[1,g_w[40]] #FUN-650005
         #FUN-5A0143 add
         #PRINTX name = D1 COLUMN g_c[35],g_x[21] CLIPPED,
         #                 COLUMN g_c[36],l_ogb12 USING '###,###,##&.###',
         #                 COLUMN g_c[40]-7,g_x[22] ClIPPED,
         #                 COLUMN g_c[40],GROUP SUM(sr.ima18*sr.ogb12) USING '#####.###';
         #FUN-5A0143 end
         PRINTX name = D1 COLUMN g_c[52],g_x[21] CLIPPED,
                          COLUMN g_c[36],l_ogb12 USING '###,###,##&.###'
         PRINTX name = D1 COLUMN g_c[52],g_x[22] ClIPPED,
                          COLUMN g_c[40],cl_numfor(GROUP SUM(sr.ima18*sr.ogb12),40,3)
       #MOD-710131-end-add  
#no.FUN-580004--end
#no.FUN-570176--end--
#no.FUN-550070-end
 
         PRINT ''
         IF tm.b = 'Y'  THEN     #列印備註於表尾
            CALL r600_oao(sr.oga01,0,'2')
            FOR l_n = 1 TO 40
                IF NOT cl_null(g_m[l_n]) THEN
                   PRINT g_m[l_n] CLIPPED
                ELSE
                   LET l_n = 40
                END IF
            END FOR
         END IF
## FUN-550127
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED,COLUMN 41,g_x[5]
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
            PRINT g_x[4]
            PRINT g_memo
         ELSE
            PRINT
            PRINT
         END IF
      ELSE
         PRINT g_x[4]
         PRINT g_memo
      END IF
## END FUN-550127
 
END REPORT
}
#No.FUN-710081--end
 
FUNCTION r600_oao(l_p1,l_p3,l_p5)
   DEFINE l_p1   LIKE oao_file.oao01,
          l_p3   LIKE oao_file.oao03,
          l_p5   LIKE oao_file.oao05,
          l_n    LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   FOR l_n = 1 TO 40
      LET g_m[l_n] = ''
   END FOR
 
   DECLARE r600_c5 CURSOR FOR SELECT oao06 FROM oao_file
                               WHERE oao01 = l_p1
                                 AND oao03 = l_p3
                                 AND oao05 = l_p5
 
   LET l_n = 1
 
   FOREACH r600_c5 INTO g_m[l_n]
      LET l_n = l_n + 1
   END FOREACH
 
END FUNCTION
 
FUNCTION r600_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oga03    LIKE oga_file.oga03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oga03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oga03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oga01   = g_oga01
   LET g_show_msg[li_newerrno].oga03   = lc_oga03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
#Patch....NO.TQC-610037 <> #
