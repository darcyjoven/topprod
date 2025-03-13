# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmg800.4gl
# Desc/riptions..: 訂單變更單列印
# Input parameter:
# Return code....:
# Date & Author..: 97/10/17 By Lynn
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/04 By wujie 雙單位報表格式修改
# Modify.........: No.MOD-560073 05/08/05 By Rosayu 表頭位置,沒對齊
# Modify.........: No.FUN-5A0143 05/10/24 By Rosayu 修正報表格式
# Modify.........: No.FUN-5A0181 05/10/31 By Rosayu 當"使用多單位",和"使用計價單有無勾選時,報表欄位位置對齊
# Modify.........: No.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-640471 06/04/17 By Mandy 客戶簡稱沒有印出
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-750136 07/05/23 By Nicole 列印條件依axmt800列印時的選擇視窗之語言別，進行顯示
# Modify.........: No.TQC-750137 07/05/24 By Sarah 計價單位與計價數量依照參數sma116設定決定是否顯示
# Modify.........: No.MOD-790110 07/09/20 By Pengu 變更前的單價取未異常
# Modify.........: No.CHI-790029 07/10/05 By jamie 備註改用新的子報表寫法
# Modify.........: No.FUN-810029 08/02/22 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.FUN-840165 08/06/92 By xiaofeizhu 類別為8或者9時動態地顯示title“借貨申請單資料”
# Modify.........: No.MOD-910218 09/01/20 By Smapmin 幣別未變更,不應印出變更後幣別
# Modify.........: No.FUN-910069 09/01/22 By Smapmin 增加列印價格條件與交運方式
# Modify.........: No.FUN-910012 09/01/08 By tsai_yen 在CR報表列印簽核欄
# Modify.........: No.MOD-970025 09/07/06 By Smapmin 客戶料號未顯示
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-990075 09/09/24 By mike 报表中其价格条件,交运方式,只带出代号，是否可加入列印其说明
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:FUN-A50041 10/05/10 by tsai_yen 報表簽核圖功能出現Error Messages -450,在fglrun Version 2.21.02中的blob必須先用LOCATE初始化
# Modify.........: No:CHI-AC0044 11/01/03 By Summer 若是借貨申請單,多列印變更前後的加預計歸還日與展延原因
# Modify.........: No.FUN-B30062 11/03/28 By xianghui 新增列印：變更理由碼、稅別、客戶訂單編號、專案代號、WBS編碼、活動代號、MOS
# Modify.........: No.FUN-B40092 11/05/10 By xujing 憑證報表轉GRW
# Modify.........: No:FUN-B80092 11/08/04 By jacklai GR簽核圖檔, 修正cl_used位置問題
# Modify.........: No:FUN-B80097 11/09/09 By jacklai GR背景作業
# Modify.........: No:FUN-BC0063 11/12/19 By jacklai 未與EasyFlow整合的報表改為顯示簽核關卡文字
# Modify.........: No:FUN-C10036 12/01/16 By lujh FUN-B80089追單
# Modify.........: No:FUN-C30012 12/03/14 By Downheal 刪除l_apr_loc改到cl_gre處理
# Modify.........: No:CHI-C30123 12/03/28 By Downheal 刪除g_cr_gcx01 已不需要此參數
# Modify.........: No:FUN-C50008 12/05/05 By wangrr GR程式優化
# Modify.........: No.FUN-C50140 12/06/13 By nanbing GR修改
# Modify.........: No:TQC-C90066 12/09/13 By dongsz 傳參g_zz05
# Modify.........: NO.FUN-CB0058 12/11/27 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點
# Modify.........: No.FUN-CC0087 12/12/24 By yangtt 過單處理

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   # No.FUN-680137 SMALLINT
END GLOBALS
   DEFINE
     tm  RECORD				# Print condition RECORD
       	 wc   LIKE type_file.chr1000,     # No.FUN-680137  VARCHAR(500)  # Where condition
         a    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
         d    LIKE type_file.chr1,        # No.FUN-690032 列印客戶料號
         more LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)
         END RECORD
   DEFINE g_rpt_name  LIKE type_file.chr20       # No.FUN-680137 VARCHAR(20)  # For TIPTOP 串 EasyFlow #BugNo:6535
   DEFINE g_rpt_title LIKE oea_file.oea00        # No.FUN-840165

DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE 	l_table     STRING                     #No.FUN-710090
DEFINE  g_sql       STRING                     #No.FUN-710090
DEFINE  g_str       STRING                     #No.FUN-710090
DEFINE 	l_table1    STRING                     #No.CHI-790029 add
###GENGRE###START
TYPE sr1_t RECORD
    oep01 LIKE oep_file.oep01,
    oep02 LIKE oep_file.oep02,
    oep04 LIKE oep_file.oep04,
    oea03 LIKE oea_file.oea03,
    oea00 LIKE oea_file.oea00,
    oea02 LIKE oea_file.oea02,
    oep06 LIKE oep_file.oep06,
    oep06b LIKE oep_file.oep06b,
    oep07 LIKE oep_file.oep07,
    oep07b LIKE oep_file.oep07b,
    oep08 LIKE oep_file.oep08,
    oep08b LIKE oep_file.oep08b,
    oep10 LIKE oep_file.oep10,
    oep10b LIKE oep_file.oep10b,
    oep11 LIKE oep_file.oep11,
    oep11b LIKE oep_file.oep11b,
    occ02 LIKE occ_file.occ02,
    oep13 LIKE oep_file.oep13,
    oep14 LIKE oep_file.oep14,
    oep14b LIKE oep_file.oep14b,
    oep15 LIKE oep_file.oep15,
    oep15b LIKE oep_file.oep15b,
    oeq03 LIKE oeq_file.oeq03,
    oeq04b LIKE oeq_file.oeq04b,
    oeq041b LIKE oeq_file.oeq041b,
    oeq26b LIKE oeq_file.oeq26b,
    oeq27b LIKE oeq_file.oeq27b,
    oeq05b LIKE oeq_file.oeq05b,
    oeq12b LIKE oeq_file.oeq12b,
    oeq13b LIKE oeq_file.oeq13b,
    oeq14b LIKE oeq_file.oeq14b,
    oeq15b LIKE oeq_file.oeq15b,
    oeq28b LIKE oeq_file.oeq28b,
    oeq29b LIKE oeq_file.oeq29b,
    oeq04a LIKE oeq_file.oeq04a,
    oeq041a LIKE oeq_file.oeq041a,
    oeq26a LIKE oeq_file.oeq26a,
    oeq27a LIKE oeq_file.oeq27a,
    oeq05a LIKE oeq_file.oeq05a,
    oeq12a LIKE oeq_file.oeq12a,
    oeq13a LIKE oeq_file.oeq13a,
    oeq14a LIKE oeq_file.oeq14a,
    oeq15a LIKE oeq_file.oeq15a,
    oeq28a LIKE oeq_file.oeq28a,
    oeq29a LIKE oeq_file.oeq29a,
    oeq31a LIKE oeq_file.oeq31a,
    oeq31b LIKE oeq_file.oeq31b,
    oeq32a LIKE oeq_file.oeq32a,
    oeq32b LIKE oeq_file.oeq32b,
    oeq33a LIKE oeq_file.oeq33a,
    oeq33b LIKE oeq_file.oeq33b,
    oeq50 LIKE oeq_file.oeq50,
    oag02 LIKE oag_file.oag02,
    oag02b LIKE oag_file.oag02,
    ima021_b LIKE ima_file.ima021,
    ima021_a LIKE ima_file.ima021,
    oeb11_a LIKE oeb_file.oeb11,
    oeb11_b LIKE oeb_file.oeb11,
    unit_ep_b LIKE type_file.chr50,
    unit_ep_a LIKE type_file.chr50,
    azi03a LIKE azi_file.azi03,
    azi04a LIKE azi_file.azi04,
    azi03b LIKE azi_file.azi03,
    azi04b LIKE azi_file.azi04,
    oah02 LIKE oah_file.oah02,
    oah02_1 LIKE oah_file.oah02,
    ged02 LIKE ged_file.ged02,
    ged02_1 LIKE ged_file.ged02,
    zo041 LIKE zo_file.zo041,
    zo05 LIKE zo_file.zo05,
    zo09 LIKE zo_file.zo09,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000,   #FUN-BC0063
    azp03 LIKE azp_file.azp03,
    gec04 LIKE gec_file.gec04,
    gec04b LIKE gec_file.gec04,
    gec07 LIKE gec_file.gec07,
    gec07b LIKE gec_file.gec07
END RECORD

TYPE sr2_t RECORD
    oep01 LIKE oep_file.oep01,
    oep02 LIKE oep_file.oep02,
    oer03 LIKE oer_file.oer03,
    oer04 LIKE oer_file.oer04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126   #FUN-C10036   mark

   LET g_sql= "oep01.oep_file.oep01,     oep02.oep_file.oep02,",
              "oep04.oep_file.oep04,     oea03.oea_file.oea03,",
              "oea00.oea_file.oea00,",                            #CHI-AC0044 add
              "oea02.oea_file.oea02,     oep06.oep_file.oep06,",
              "oep06b.oep_file.oep06b,   oep07.oep_file.oep07,",
              "oep07b.oep_file.oep07b,   oep08.oep_file.oep08,",
              "oep08b.oep_file.oep08b,   oep10.oep_file.oep10,",   #FUN-910069
              "oep10b.oep_file.oep10b,   oep11.oep_file.oep11,",   #FUN-910069
              "oep11b.oep_file.oep11b,   occ02.occ_file.occ02,",   #FUN-910069
              "oep13.oep_file.oep13,",                             #FUN-B30062
              "oep14.oep_file.oep14,     oep14b.oep_file.oep14b,", #FUN-B30062
              "oep15.oep_file.oep15,     oep15b.oep_file.oep15b,", #FUN-B30062
              "oeq03.oeq_file.oeq03,     oeq04b.oeq_file.oeq04b,",
              "oeq041b.oeq_file.oeq041b, oeq26b.oeq_file.oeq26b,",
              "oeq27b.oeq_file.oeq27b,   oeq05b.oeq_file.oeq05b,",
              "oeq12b.oeq_file.oeq12b,   oeq13b.oeq_file.oeq13b,",
              "oeq14b.oeq_file.oeq14b,   oeq15b.oeq_file.oeq15b,",
              "oeq28b.oeq_file.oeq28b,   oeq29b.oeq_file.oeq29b,", #CHI-AC0044 add
              "oeq04a.oeq_file.oeq04a,   oeq041a.oeq_file.oeq041a,",
              "oeq26a.oeq_file.oeq26a,   oeq27a.oeq_file.oeq27a,",
              "oeq05a.oeq_file.oeq05a,   oeq12a.oeq_file.oeq12a,",
              "oeq13a.oeq_file.oeq13a,   oeq14a.oeq_file.oeq14a,",
             #"oeq15a.oeq_file.oeq15a,   oeq50.oeq_file.oeq50,",   #CHI-AC0044 mark
              "oeq15a.oeq_file.oeq15a,   oeq28a.oeq_file.oeq28a,", #CHI-AC0044
              "oeq29a.oeq_file.oeq29a,   ",   #CHI-AC0044
              "oeq31a.oeq_file.oeq31a,     oeq31b.oeq_file.oeq31b,",  #FUN-B30062
              "oeq32a.oeq_file.oeq32a,     oeq32b.oeq_file.oeq32b,",  #FUN-B30062
              "oeq33a.oeq_file.oeq33a,     oeq33b.oeq_file.oeq33b,",  #FUN-B30062
              "oeq50.oeq_file.oeq50,", #CHI-AC0044
              "oag02.oag_file.oag02,     oag02b.oag_file.oag02,",
              "ima021_b.ima_file.ima021, ima021_a.ima_file.ima021,",
              "oeb11_a.oeb_file.oeb11,   oeb11_b.oeb_file.oeb11,",
              "unit_ep_b.type_file.chr50,unit_ep_a.type_file.chr50,",
              "azi03a.azi_file.azi03,    azi04a.azi_file.azi04,",
              "azi03b.azi_file.azi03,    azi04b.azi_file.azi04,",
              "oah02.oah_file.oah02,     oah02_1.oah_file.oah02,", #FUN-990075
              "ged02.ged_file.ged02,     ged02_1.ged_file.ged02,", #FUN-990075
              "zo041.zo_file.zo041,      zo05.zo_file.zo05,",   #FUN-810029 add
              "zo09.zo_file.zo09,",                               #FUN-810029 add
              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-910012
              "sign_show.type_file.chr1, sign_str.type_file.chr1000,",  #FUN-BC0063 Add sign_str                               #是否顯示簽核資料(Y/N)  #FUN-910012
              "azp03.azp_file.azp03,",                               #FUN-B30062
              "gec04.gec_file.gec04,     gec04b.gec_file.gec04,",   #FUN-B30062
              "gec07.gec_file.gec07,     gec07b.gec_file.gec07"     #FUN-B30062

    LET l_table = cl_prt_temptable('axmg800',g_sql) CLIPPED
    #No.FUN-B80092 --start-- #add cl_used()
    IF l_table = -1 THEN
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-C10036   mark
        EXIT PROGRAM 
    END IF
    #No.FUN-B80092 --end--
    
   LET g_sql="oep01.oep_file.oep01,",
             "oep02.oep_file.oep02,",
             "oer03.oer_file.oer03,",
             "oer04.oer_file.oer04"
    LET l_table1 = cl_prt_temptable('axmg8001',g_sql) CLIPPED

    #No.FUN-B80092 --start-- #add cl_used()
    IF l_table1  = -1 THEN
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-C10036   mark
        EXIT PROGRAM
    END IF
    #No.FUN-B80092 --end--
    
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #No.FUN-B80097 --start--
   LET tm.d  = ARG_VAL(9)
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   #LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #LET g_rpt_title = ARG_VAL(13) #No.FUN-840165
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
   LET g_rpt_title = ARG_VAL(14)
   #No.FUN-B80097 --end--

   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g800_tm(0,0)		# Input print condition
      ELSE CALL axmg800()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN

FUNCTION g800_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)

   LET p_row = 6 LET p_col = 17

   OPEN WINDOW g800_w AT p_row,p_col WITH FORM "axm/42f/axmg800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '1'
   LET tm.d    = 'N'  #FUN-690032 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oep01,oep04,oep02
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF


   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM

   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.d,tm.more  # Condition  #FUN-690032 add tm.d
   INPUT BY NAME tm.a,tm.d,tm.more WITHOUT DEFAULTS  #FUN-690032 add tm.d

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD d
         IF tm.d NOT MATCHES "[YN]"
            THEN NEXT FIELD d
         END IF

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW g800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM

   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmg800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg800','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",  #FUN-690032 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg800',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg800()
   ERROR ""
END WHILE
   CLOSE WINDOW g800_w
END FUNCTION

FUNCTION axmg800()
DEFINE l_name        LIKE type_file.chr20,      # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
       l_sql         LIKE type_file.chr1000,    # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
       l_chr         LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
       l_za05        LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(40)
       l_oea23       LIKE oea_file.oea23,
       l_oea03       LIKE oea_file.oea03,
       l_zo041       LIKE zo_file.zo041,        #FUN-810029 add
       l_zo05        LIKE zo_file.zo05,         #FUN-810029 add
       l_zo09        LIKE zo_file.zo09,         #FUN-810029 add
     sr   RECORD
          oep01  LIKE oep_file.oep01,  #訂單單號
          oep02  LIKE oep_file.oep02,  #訂單序號
          oep04  LIKE oep_file.oep04,  #訂單日期
          oea03  LIKE oea_file.oea03,  #帳款客戶
          oea00  LIKE oea_file.oea00,  #CHI-AC0044 add
          oea02  LIKE oea_file.oea02,  #單據日期
          oep06  LIKE oep_file.oep06,
          oep06b LIKE oep_file.oep06b,
          oep07  LIKE oep_file.oep07,
          oep07b LIKE oep_file.oep07b,
          oep08  LIKE oep_file.oep08,
          oep08b LIKE oep_file.oep08b,
          oep10   LIKE oep_file.oep10,
          oep10b  LIKE oep_file.oep10b,
          oep11   LIKE oep_file.oep11,
          oep11b  LIKE oep_file.oep11b,
          oep13  LIKE oep_file.oep13,         #FUN-B30062
          oep14  LIKE oep_file.oep14,         #FUN-B30062
          oep14b LIKE oep_file.oep14b,        #FUN-B30062
          oep15  LIKE oep_file.oep15,         #FUN-B30062
          oep15b LIKE oep_file.oep15b,        #FUN-B30062
          occ02  LIKE occ_file.occ02,
          oeq    RECORD LIKE oeq_file.*
          END RECORD
DEFINE    l_cnt     LIKE type_file.num5           #No.FUN-580004        #No.FUN-680137 SMALLINT
DEFINE    l_i       LIKE type_file.num5           #No.FUN-580004        #No.FUN-680137 SMALLINT
DEFINE    l_oer04     LIKE oer_file.oer04
DEFINE    l_oag02     LIKE oag_file.oag02
DEFINE    l_oag02b    LIKE oag_file.oag02
DEFINE    l_ima021_b  LIKE ima_file.ima021
DEFINE    l_gec04     LIKE gec_file.gec04         #FUN-B30062
DEFINE    l_gec04b    LIKE gec_file.gec04         #FUN-B30062
DEFINE    l_gec07     LIKE gec_file.gec07         #FUN-B30062
DEFINE    l_gec07b    LIKE gec_file.gec07         #FUN-B30062
DEFINE    l_azp03     LIKE azp_file.azp03         #FUN-B30062
DEFINE    l_ima021_a  LIKE ima_file.ima021
DEFINE    l_oeb11_a   LIKE oeb_file.oeb11
DEFINE    l_oeb11_b   LIKE oeb_file.oeb11
DEFINE    l_unit_ep_b LIKE type_file.chr50
DEFINE    l_unit_ep_a LIKE type_file.chr50
DEFINE    l_ima906_b  LIKE ima_file.ima906
DEFINE    l_ima906_a  LIKE ima_file.ima906
DEFINE    l_str2      STRING
DEFINE    l_oeq25b    STRING
DEFINE    l_oeq22b    STRING
DEFINE    l_oeq25a    STRING
DEFINE    l_oeq22a    STRING
DEFINE    l_oeq12a    STRING
DEFINE    l_oeq12b    STRING
DEFINE    l_azi03a    LIKE azi_file.azi03
DEFINE    l_azi04a    LIKE azi_file.azi04
DEFINE    l_azi03b    LIKE azi_file.azi03
DEFINE    l_azi04b    LIKE azi_file.azi04
DEFINE    l_lang_t    LIKE type_file.chr1   #TQC-750136
DEFINE    l_oep08b    LIKE oep_file.oep08b  #MOD-910218
DEFINE    l_oer03     LIKE oer_file.oer03   #CHI-790029 add
DEFINE l_img_blob     LIKE type_file.blob
#FUN-BC0063 --start-- mark
#DEFINE l_ii           INTEGER
#DEFINE l_key          RECORD                  #主鍵
          #v1          LIKE oep_file.oep01,
          #v2          LIKE oep_file.oep02
          #END RECORD
#FUN-BC0063 --end--
DEFINE    l_oah02     LIKE oah_file.oah02
DEFINE    l_oah02_1   LIKE oah_file.oah02
DEFINE    l_ged02     LIKE ged_file.ged02
DEFINE    l_ged02_1   LIKE ged_file.ged02

   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)    #CHI-790029 add
   LOCATE l_img_blob IN MEMORY   #FUN-A50041

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmg800'

  #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_rlang

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oepuser', 'oepgrup')

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",    #FUN-B30062  21?->25?
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,",  #FUn-B3062   46>->51?
              #CHI-AC0044 add 5? --start--
              #"        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   #FUN-810029 45?->47?   #FUN-910069  #FUN-910012加3個 #FUN-990075 add 4个？
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"    #FUN-B30062 add 最後5個?   #FUN-BC0063 add 1個?
              #CHI-AC0044 add 5? --end--
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      #No.FUN-B80092 --start-- #add cl_used()
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
      #No.FUN-B80092 --end--
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?) "
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      #No.FUN-B80092 --start-- #add cl_used()
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
      #No.FUN-B80092 --end--
   END IF

   LET l_sql = " SELECT oep01,oep02,oep04,oea03,oea00,oea02, ", #CHI-AC0044 add oea00
              #"        oep06,oep06b,oep07,oep07b,oep08,oep08b,oep10,oep10b,oep11,oep11b,oep13,oep14,oep14b,oep15,oep15b,'', ",   #FUN-910069    #FUN-B30062 addoep13,oep14,oep14b,oep15,oep15b #FUN-C50008 mark--
               "        oep06,oep06b,oep07,oep07b,oep08,oep08b,oep10,oep10b,",  #FUN-C50008 Add 
               "        oep11,oep11b,oep13,oep14,oep14b,oep15,oep15b,occ02, ",  #FUN-C50008 Add ''-->occ02 
               "        oeq_file.*,oea23,oea03 ",
              #"   FROM oep_file,OUTER oeq_file,oea_file ", #FUN-C50008 mark--
               "   FROM oep_file LEFT OUTER JOIN oeq_file ON (oep01=oeq01 AND oep02=oeq02),", #FUN-C50008 add LEFT OUTER
               "        oea_file LEFT OUTER JOIN occ_file ON (oea03=occ01)  ",                #FUN-C50008 add LEFT OUTER
               "  WHERE oep01=oea01 ",
              # "    AND oep_file.oep01=oeq_file.oeq01",  #FUN-C50008 mark--
              # "    AND oep_file.oep02=oeq_file.oeq02",  #FUN-C50008 mark--
               "    AND oepacti = 'Y' ",
               "    AND oeaconf != 'X' ", #01/08/16 mandy
               "    AND ",tm.wc CLIPPED
   CASE tm.a
     WHEN '1' LET l_sql=l_sql CLIPPED," AND oepconf='N' "
     WHEN '2' LET l_sql=l_sql CLIPPED," AND oepconf='Y' "
     WHEN '3' LET l_sql=l_sql CLIPPED," AND oepconf!='X' " #01/08/07 mandy
   END CASE
   LET l_sql = l_sql CLIPPED," ORDER BY oep_file.oep01,oep_file.oep02"   #FUN-910012

   PREPARE g800_pr1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
     DECLARE g800_cs1 CURSOR FOR g800_pr1


   #FUN-BC0063 --start-- mark
   #單據key值
   #LET l_sql = " SELECT oep01,oep02 ",
               #"  FROM oep_file,OUTER oeq_file,oea_file ",
               #"  WHERE oep_file.oep01=oea_file.oea01 ",
               #"    AND oep_file.oep01=oeq_file.oeq01 AND oep_file.oep02=oeq_file.oeq02 ",
               #"    AND oep_file.oepacti = 'Y' ",
               #"    AND oeaconf <> 'X' ",
               #"    AND ",tm.wc CLIPPED
   #CASE tm.a
      #WHEN '1' LET l_sql=l_sql CLIPPED," AND oepconf='N' "
      #WHEN '2' LET l_sql=l_sql CLIPPED," AND oepconf='Y' "
      #WHEN '3' LET l_sql=l_sql CLIPPED," AND oepconf!='X' "
   #END CASE
   #LET l_sql = l_sql CLIPPED," GROUP BY oep01,oep02"
   #PREPARE g800_pr4 FROM l_sql
   #IF SQLCA.sqlcode THEN
      #CALL cl_err('prepare g800_pr4:',SQLCA.sqlcode,0)
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      #EXIT PROGRAM
   #END IF
   #DECLARE g800_cs4 CURSOR FOR g800_pr4
   #FUN-BC0063 --end--

   FOREACH g800_cs1 INTO sr.*,l_oea23
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
     LET l_oeb11_a = ''
     LET l_oeb11_b = ''
     SELECT oeb11 INTO l_oeb11_a FROM oeb_file
         WHERE oeb01 = sr.oeq.oeq01
           AND oeb03 = sr.oeq.oeq03
     IF SQLCA.sqlcode THEN
         LET l_oeb11_a = ''
     END IF
     LET l_oeb11_b = l_oeb11_a
    #SELECT occ02 INTO sr.occ02 FROM occ_file WHERE occ01 = sr.oea03 #MOD-640471  #FUN-C50008 mark--
     SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr.oep07
     IF SQLCA.sqlcode THEN LET l_oag02=' ' END IF
     SELECT oag02 INTO l_oag02b FROM oag_file WHERE oag01=sr.oep07b
     IF SQLCA.sqlcode THEN LET l_oag02b=' ' END IF
     SELECT oer04 INTO l_oer04 FROM oer_file WHERE oer01=sr.oep01 AND oer02=sr.oep02
     IF SQLCA.sqlcode THEN LET l_oer04=' ' END IF
     #FUN-B30062-add-start--
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=sr.oep13
     SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file WHERE gec01=sr.oep14 AND gec011='2'
     IF SQLCA.sqlcode THEN
        LET l_gec04=' '
        LET l_gec07=' '
     END IF
     SELECT gec04,gec07 INTO l_gec04b,l_gec07b FROM gec_file WHERE gec01=sr.oep14b AND gec011='2'
     IF SQLCA.sqlcode THEN
        LET l_gec04b=' '
        LET l_gec07b=' '
     END IF
     #FUN-B30062-add-end--
     SELECT ima021,ima906 INTO l_ima021_b,l_ima906_b FROM ima_file where ima01=sr.oeq.oeq04b
     IF SQLCA.sqlcode THEN
        LET l_ima021_b=' '
        LET l_ima906_b=' '
     END IF
     SELECT ima021,ima906 INTO l_ima021_a,l_ima906_a FROM ima_file where ima01=sr.oeq.oeq04a
     IF SQLCA.sqlcode THEN
        LET l_ima021_a=' '
        LET l_ima906_a=' '
     END IF
     LET l_str2 = ""
     LET l_unit_ep_b = ""
     IF g_sma115 = "Y" THEN
        CASE l_ima906_b
           WHEN "2"
               CALL cl_remove_zero(sr.oeq.oeq25b) RETURNING l_oeq25b
               LET l_str2 = l_oeq25b , sr.oeq.oeq23b CLIPPED
               IF cl_null(sr.oeq.oeq25b) OR sr.oeq.oeq25b = 0 THEN
                   CALL cl_remove_zero(sr.oeq.oeq22b) RETURNING l_oeq22b
                   LET l_str2 = l_oeq22b, sr.oeq.oeq20b CLIPPED
               ELSE
                  IF NOT cl_null(sr.oeq.oeq22b) AND sr.oeq.oeq22b > 0 THEN
                     CALL cl_remove_zero(sr.oeq.oeq22b) RETURNING l_oeq22b
                     LET l_str2 = l_str2 CLIPPED,',',l_oeq22b, sr.oeq.oeq20b CLIPPED
                  END IF
               END IF
           WHEN "3"
               IF NOT cl_null(sr.oeq.oeq25b) AND sr.oeq.oeq25b > 0 THEN
                   CALL cl_remove_zero(sr.oeq.oeq25b) RETURNING l_oeq25b
                   LET l_str2 = l_oeq25b , sr.oeq.oeq23b CLIPPED
               END IF
        END CASE
     END IF
     IF g_sma.sma116 MATCHES '[23]' THEN
           IF sr.oeq.oeq05b <> sr.oeq.oeq26b THEN
              CALL cl_remove_zero(sr.oeq.oeq12b) RETURNING l_oeq12b
              LET l_str2 = l_str2 CLIPPED,"(",l_oeq12b,sr.oeq.oeq05b CLIPPED,")"
           END IF
     END IF
     LET l_unit_ep_b = l_str2
     LET l_str2 = ""
     LET l_unit_ep_a = " "
     IF g_sma115 = "Y" THEN
        CASE l_ima906_a
           WHEN "2"
               CALL cl_remove_zero(sr.oeq.oeq25a) RETURNING l_oeq25a
               LET l_str2 = l_oeq25a , sr.oeq.oeq23a CLIPPED
               IF cl_null(sr.oeq.oeq25a) OR sr.oeq.oeq25a = 0 THEN
                   CALL cl_remove_zero(sr.oeq.oeq22a) RETURNING l_oeq22a
                   LET l_str2 = l_oeq22a, sr.oeq.oeq20a CLIPPED
               ELSE
                  IF NOT cl_null(sr.oeq.oeq22a) AND sr.oeq.oeq22a > 0 THEN
                     CALL cl_remove_zero(sr.oeq.oeq22a) RETURNING l_oeq22a
                     LET l_str2 = l_str2 CLIPPED,',',l_oeq22a, sr.oeq.oeq20a CLIPPED
                  END IF
               END IF
           WHEN "3"
               IF NOT cl_null(sr.oeq.oeq25a) AND sr.oeq.oeq25a > 0 THEN
                   CALL cl_remove_zero(sr.oeq.oeq25a) RETURNING l_oeq25a
                   LET l_str2 = l_oeq25a , sr.oeq.oeq23a CLIPPED
               END IF
        END CASE
     END IF
     IF g_sma.sma116 MATCHES '[23]' THEN
           IF sr.oeq.oeq05a <> sr.oeq.oeq26a THEN
              CALL cl_remove_zero(sr.oeq.oeq12a) RETURNING l_oeq12a
              LET l_str2 = l_str2 CLIPPED,"(",l_oeq12a,sr.oeq.oeq05a CLIPPED,")"
           END IF
     END IF
     LET l_unit_ep_a = l_str2

      IF cl_null(sr.oep08b) THEN
         LET l_oep08b = sr.oep08
      ELSE
         LET l_oep08b = sr.oep08b
      END IF

     SELECT azi03,azi04 INTO l_azi03a,l_azi04a FROM  azi_file
      WHERE azi01=l_oep08b   #MOD-910218
     SELECT azi03,azi04 INTO l_azi03b,l_azi04b FROM  azi_file
      WHERE azi01=sr.oep08

     SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=sr.oep10
     SELECT oah02 INTO l_oah02_1 FROM oah_file WHERE oah01=sr.oep10b
     SELECT ged02 INTO l_ged02 FROM ged_file WHERE ged01=sr.oep11
     SELECT ged02 INTO l_ged02_1 FROM ged_file WHERE ged01=sr.oep11b
     EXECUTE insert_prep USING
        sr.oep01,     sr.oep02,     sr.oep04,     sr.oea03,      sr.oea00, sr.oea02, #CHI-AC0044 add oea00
        sr.oep06,     sr.oep06b,    sr.oep07,     sr.oep07b,     sr.oep08,
        sr.oep08b,    sr.oep10,     sr.oep10b,    sr.oep11,      sr.oep11b, sr.occ02,  #FUN-910069
        sr.oep13,     sr.oep14,     sr.oep14b,    sr.oep15,      sr.oep15b,   #FUN-B30062
        sr.oeq.oeq03, sr.oeq.oeq04b, sr.oeq.oeq041b,    #FUN-910069
        sr.oeq.oeq26b,sr.oeq.oeq27b,sr.oeq.oeq05b,sr.oeq.oeq12b, sr.oeq.oeq13b,
        sr.oeq.oeq14b,sr.oeq.oeq15b,sr.oeq.oeq28b,sr.oeq.oeq29b,sr.oeq.oeq04a,sr.oeq.oeq041a,sr.oeq.oeq26a, #CHI-AC0044 add oeq28b,oeq29b
        sr.oeq.oeq27a,sr.oeq.oeq05a,sr.oeq.oeq12a,sr.oeq.oeq13a, sr.oeq.oeq14a,
        sr.oeq.oeq15a,sr.oeq.oeq28a,sr.oeq.oeq29a,                                  #CHI-AC0044 add oeq28a,oeq29a
        sr.oeq.oeq31a,sr.oeq.oeq31b,sr.oeq.oeq32a,sr.oeq.oeq32b,sr.oeq.oeq33a,sr.oeq.oeq33b,   #FUN-B30062
        sr.oeq.oeq50, l_oag02,      l_oag02b,      l_ima021_b,
        l_ima021_a,   l_oeb11_a,    l_oeb11_b,    l_unit_ep_b,   l_unit_ep_a,
        l_azi03a,     l_azi04a,     l_azi03b,     l_azi04b,
        l_oah02,      l_oah02_1,    l_ged02,      l_ged02_1,   #FUN-990075
        l_zo041,      l_zo05,       l_zo09,    #FUN-810029 add
        "",           l_img_blob,   "N",          "",          #FUN-910012 #FUN-BC0063 行尾新增 "",
        l_azp03,      l_gec04,      l_gec04b,     l_gec07,     l_gec07b      #FUN-B30062

  END FOREACH


  LET l_sql= "SELECT oep01,oep02 FROM oep_file ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY oep01,oep02"
  PREPARE g800_pr2 FROM l_sql
  IF SQLCA.sqlcode != 0 THEN
     CALL cl_err('pr2:',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-B80092
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #No.FUN-B80092
     EXIT PROGRAM
  END IF
  DECLARE g800_cs2 CURSOR FOR g800_pr2

  #FUN-C50008--add--str
  DECLARE g800_cs3 CURSOR FOR
     SELECT oer03,oer04 FROM oer_file
      WHERE oer01=? AND oer02=?
  #FUN-C50008--add--end

  FOREACH g800_cs2 INTO sr.oep01,sr.oep02
  #FUN-C50008--mark--str   
  #   DECLARE g800_cs3 CURSOR FOR
  #    SELECT oer03,oer04 FROM oer_file
  #     WHERE oer01=sr.oep01 AND oer02=sr.oep02
  #   FOREACH g800_cs3 INTO l_oer03,l_oer04
  #FUN-C50008--mark--end
     FOREACH g800_cs3 USING sr.oep01,sr.oep02 INTO l_oer03,l_oer04  #FUN-C50008 add
        EXECUTE insert_prep1 USING sr.oep01,sr.oep02,l_oer03,l_oer04
     END FOREACH
  END FOREACH

###GENGRE###  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, "|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED

   IF g_zz05='Y' THEN
      LET l_lang_t  = g_lang   #TQC-750136
      LET g_lang    = g_rlang  #TQC-750136
      CALL cl_wcchp(tm.wc,'oep01,oep04,oep02') RETURNING tm.wc
      LET g_lang    = l_lang_t #TQC-750136
   END IF
###GENGRE###   LET g_str = tm.wc,";",g_sma.sma116,";",tm.d,";",g_rpt_title,";",g_aza.aza08   #TQC-750137 add sma116  #FUN-810029 add tm.d  #FUN-840165 add g_rpt_title   #FUN-B30062 add g_aza.aza08

   LET g_cr_table = l_table                 #主報表的temp table名稱
   #LET g_cr_gcx01 = "axmi010"              #單別維護程式 CHI-C30123 不需要此參數
   LET g_cr_apr_key_f = "oep01|oep02"       #報表主鍵欄位名稱，用"|"隔開

   #FUN-BC0063 --start-- mark
   #LET l_ii = 1
   #報表主鍵值
   #CALL g_cr_apr_key.clear()                #清空
   #FOREACH g800_cs4 INTO l_key.*
      #LET g_cr_apr_key[l_ii].v1 = l_key.v1
      #LET g_cr_apr_key[l_ii].v2 = l_key.v2
      #LET l_ii = l_ii + 1
   #END FOREACH
   #FUN-BC0063 --end--
   
###GENGRE###   CALL cl_prt_cs3('axmg800','axmg800',g_sql,g_str)
    CALL axmg800_grdata()    ###GENGRE###
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

###GENGRE###START
FUNCTION axmg800_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #No.FUN-B80092
    CALL cl_gre_init_apr()          #No.FUN-B80092

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("axmg800")
        IF handler IS NOT NULL THEN
            START REPORT axmg800_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oep01,oep02,oeq03"     #FUN-B40092
            DECLARE axmg800_datacur1 CURSOR FROM l_sql
            FOREACH axmg800_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg800_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg800_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg800_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    #FUN-B40092------add------str
    DEFINE l_option     STRING
    DEFINE l_option1    STRING
    DEFINE l_unit_ep_a  STRING
    DEFINE l_unit_ep_b  STRING
    DEFINE l_sql STRING
    DEFINE l_oeq13b_fmt STRING
    DEFINE l_oeq14b_fmt STRING
    DEFINE l_oeq13a_fmt STRING
    DEFINE l_oeq14a_fmt STRING
    DEFINE l_display    LIKE type_file.chr1
    #FUN-B40092------add------end
    DEFINE l_lineno LIKE type_file.num5
    #DEFINE l_sign_img_disp  LIKE type_file.chr1     #No.FUN-B80092  #隱藏簽核圖檔
    #DEFINE l_apr_loc        STRING #No.FUN-B80092 簽核圖檔位置 #FUN-C30012 mark
    #FUN-C50140 sta
    DEFINE l_oeq27b   STRING 
    DEFINE l_oeq26b   STRING 
    DEFINE l_oeq28b   STRING 
    DEFINE l_oeq29b   STRING 
    DEFINE l_msg      STRING
    #FUN-C50140 end
    #FUN-CB0058----add---str---
    DEFINE l_oeq12b      LIKE oeq_file.oeq12b
    DEFINE l_oeq27b_1    LIKE oeq_file.oeq27b
    DEFINE l_oeq26b_1    LIKE oeq_file.oeq26b
    DEFINE l_oeq12a      LIKE oeq_file.oeq12a
    DEFINE l_oeq27a_1    LIKE oeq_file.oeq27a
    DEFINE l_oeq26a_1    LIKE oeq_file.oeq26a
    #FUN-CB0058----add---end---

    ORDER EXTERNAL BY sr1.oep01,sr1.oep02

    FORMAT
        FIRST PAGE HEADER
        # FUN-B40092------add------str
           IF g_rpt_title ='8' OR g_rpt_title ='9' THEN
              LET l_option = cl_gr_getmsg("gre-013",g_lang,sr1.oea00)
                 LET g_grPageHeader.title2 = g_grPageHeader.title2," - ",l_option
           END IF
        # FUN-B40092------add------end
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*

            #FUN-C30012 --start-- 註解掉移至cl_gre.4gl處理
            #No.FUN-B80092 --start--
            #LET l_apr_loc = cl_gre_apr_loc()
            #PRINTX l_apr_loc  
            #No.FUN-B80092 --end--
            #FUN-C30012 -- end --

        BEFORE GROUP OF sr1.oep02
            PRINTX g_aza.aza08
            LET l_lineno = 0

        ON EVERY ROW
            #No.FUN-B80092 --start--
            #IF sr1.sign_img IS NULL THEN
            #    LET l_sign_img_disp = "N"
            #ELSE
            #    LET l_sign_img_disp = "Y"
            #END IF
            #PRINTX l_sign_img_disp
            #No.FUN-B80092 --end--
        # FUN-B40092------add------str
            IF g_sma.sma116 = '0' OR g_sma.sma116 = '1' THEN
               LET l_display = 'N'
               LET l_oeq27a_1 = "  "      #FUN-CB0058
               LET l_oeq27b_1 = "  "      #FUN-CB0058
               LET l_oeq26a_1 = "  "      #FUN-CB0058
               LET l_oeq26b_1 = "  "      #FUN-CB0058
            ELSE
               LET l_display = 'Y'
               LET l_oeq27a_1 = sr1.oeq27a    #FUN-CB0058
               LET l_oeq26a_1 = sr1.oeq26a    #FUN-CB0058
               LET l_oeq26b_1 = sr1.oeq26b    #FUN-CB0058
               LET l_oeq27b_1 = sr1.oeq27b    #FUN-CB0058
            END IF
            PRINTX l_display
            PRINTX l_oeq27a_1      #FUN-CB0058
            PRINTX l_oeq27b_1      #FUN-CB0058
            PRINTX l_oeq26a_1      #FUN-CB0058
            PRINTX l_oeq26b_1      #FUN-CB0058

            IF sr1.oeq12b = 0 THEN    #FUN-CB0058 
               LET l_oeq12b = NULL    #FUN-CB0058
            ELSE                      #FUN-CB0058
               LET l_oeq12b = sr1.oeq12b  #FUN-CB0058
            END IF           #FUN-CB0058
            PRINTX l_oeq12b   #FUN-CB0058

            #FUN-C50140 sta
            LET l_oeq27b = cl_gr_getmsg('gre-270',g_lang,l_display)
            PRINTX l_oeq27b
            LET l_oeq26b = cl_gr_getmsg('gre-269',g_lang,l_display)
            PRINTX l_oeq26b
            IF sr1.oea00 = '8' THEN 
               LET l_msg = 'Y'
            ELSE 
               LET l_msg = 'N' 
            END IF    
            LET l_oeq28b = cl_gr_getmsg('gre-280',g_lang,l_msg)
            PRINTX l_oeq28b
            LET l_oeq29b = cl_gr_getmsg('gre-281',g_lang,l_msg)
            PRINTX l_oeq29b
            #FUN-C50140 end
            
            LET l_oeq13b_fmt = cl_gr_numfmt('oeq_file','oeq13b',sr1.azi03b)
            PRINTX l_oeq13b_fmt
            LET l_oeq14b_fmt = cl_gr_numfmt('oeq_file','oeq14b',sr1.azi04b)
            PRINTX l_oeq14b_fmt
            LET l_oeq13a_fmt = cl_gr_numfmt('oeq_file','oeq13a',sr1.azi03a)
            PRINTX l_oeq13a_fmt
            LET l_oeq14a_fmt = cl_gr_numfmt('oeq_file','oeq14a',sr1.azi04a)
            PRINTX l_oeq14a_fmt

            LET l_option1 = cl_gr_getmsg("gre-014",g_lang,0)
            IF NOT cl_null(sr1.unit_ep_b) AND NOT cl_null(sr1.unit_ep_b) THEN
               LET l_unit_ep_a = l_option1,sr1.unit_ep_a
            END IF
            IF NOT cl_null(sr1.unit_ep_b) AND NOT cl_null(sr1.unit_ep_b) THEN
               LET l_unit_ep_b = l_option1,sr1.unit_ep_b
            END IF


        # FUN-B40092------add------end
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX l_unit_ep_a
            PRINTX l_unit_ep_b
            PRINTX sr1.*
            PRINTX g_aza.aza08
            PRINTX g_zz05                     #TQC-C90066 add
        AFTER GROUP OF sr1.oep02
          # FUN-B40092------add------str
            #單身後單據備註
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oer01 = '",sr1.oep01 CLIPPED,"'",
                        " AND oer02 = ",sr1.oep02 CLIPPED
            START REPORT axmg800_subrep01
            DECLARE axmg800_repcur1 CURSOR FROM l_sql
            FOREACH axmg800_repcur1 INTO sr2.*

                OUTPUT TO REPORT axmg800_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg800_subrep01

         # FUN-B40092------add------end
        ON LAST ROW

END REPORT
# FUN-B40092------add------str
REPORT axmg800_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT
# FUN-B40092------add------end
###GENGRE###END
#FUN-CC0087

