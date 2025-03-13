# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq001.4gl/
# Descriptions...: 合併前科目各期餘額查詢
# Date & Author..: 01/09/18 By Debbie Hsu
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: NO.FUN-580072 05/08/17 BY yiting  加上幣別欄位
# Modify.........: No.FUN-590132 05/09/29 By Sarah 程式架構改變,將期別放到單頭,會計科目放到單身
# Modify.........: No.FUN-590124 05/10/05 By Dido 報表查詢順序有誤
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0211 06/12/31 By wujie 調整打印時金額位置
# Modify.........: No.TQC-710041 07/01/10 By Smapmin 增加餘額欄位
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740015 07/04/04 By Judy 匯出Excel出錯
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: NO.FUN-750076 07/05/18 BY Yiting 加入版本axg17
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760044 07/06/15 By Sarah 將版本欄位隱藏
# Modify.........: No.FUN-770069 07/08/28 By Sarah 計算筆數錯誤,應加上axg17
# Modify.........: No.FUN-830113 08/03/26 By Sunyanchun  老報表改CR
# Modify.........: No.FUN-910001 09/01/02 By Sarah axg01(群組代號)增加開窗功能
# Modify.........: No.FUN-920066 09/02/11 By jamie "族群帳別"改show上層公司的合併之後帳別
# Modify.........: No.FUN-950048 09/05/22 By jan 拿掉'版本'欄位
# Modify.........: No.FUN-960010 09/06/04 By lutingting畫面新增欄位axg18,axg19
# Modify.........: No.FUN-970076 09/07/26 By hongmei 合計sumaxg08,sumaxg09的SQL加入條件aag04 = tm.aag04
# Modify.........: No.TQC-980074 09/08/11 By Carrier b_fill時,卻掉axg18/axg19的join條件,因為這兩個字段并不是key
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼 
# Modify.........: No:MOD-A30061 10/03/11 By sabrina 報表會計科目名稱沒有顯示出來
# Modify.........: No.FUN-A30067 10/03/30 By vealxu 不做獨立合併會科時，DB取aaz641
# Modify.........: No:MOD-A30242 10/03/31 By sabrina 產生多筆相同資料，只有匯率不同 
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No.FUN-A80034 10/08/06 By wujie   追21区FUN-A30122
# Modify.........: No.FUN-A30122 10/08/23 By vealxu 修改FUN-A80034 追單 
# Modify.........: No.FUN-A80092 10/09/07 By chenmoyan 增加 下層記帳幣別借方 下層記帳幣別貸方 下層功能幣別借方 下層功能幣別貸方
# Modify.........: No.FUN-AA0097 11/01/27 By lixia 追21区FUN-AA0097 MOD-AC0270 FUN-AB0026
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No.MOD-C70309 12/08/03 By Polly 調整按action"說明"對進入不斷開啟IE的無窮迴圈問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0006 
#模組變數(Module Variables)
DEFINE
    tm     RECORD
      	    wc 	      STRING,                #TQC-630166
            aag04     LIKE aag_file.aag04    #FUN-950048
           END RECORD,
    g_aag  RECORD
            axg01     LIKE axg_file.axg01,
            axg00     LIKE axg_file.axg00,
            axg06     LIKE axg_file.axg06,
            axg07     LIKE axg_file.axg07,   #FUN-590132
            axg12     LIKE axg_file.axg12,   #NO.FUN-580072
            axg02     LIKE axg_file.axg02,
            axg03     LIKE axg_file.axg03,
            axg04     LIKE axg_file.axg04,
            axg041    LIKE axg_file.axg041   #,
           #,axg18     LIKE axg_file.axg18,   #FUN-960010 add #FUN-AA0097 mark
           # axg19     LIKE axg_file.axg19    #FUN-960010 add #FUN-AA0097 mark
           END RECORD,
    g_axg  DYNAMIC ARRAY OF RECORD
            #---FUN-AA0097 mark--
            #axg05     LIKE axg_file.axg05,   #FUN-590132
            #aag02     LIKE aag_file.aag02,   #FUN-590132
            #axg08     LIKE axg_file.axg08,
            #axg09     LIKE axg_file.axg09,
            #axg10     LIKE axg_file.axg10,
            #axg11     LIKE axg_file.axg11    #FUN-590132 mark
            #,axg13     LIKE axg_file.axg13,   #FUN-A80092
            #axg14     LIKE axg_file.axg14,   #FUN-A80092
            #axg15     LIKE axg_file.axg15,   #FUN-A80092
            #axg16     LIKE axg_file.axg16    #FUN-A80092
            #---FUN-AA0097 mark--
            #---FUN-AA0097 start------
            axg05     LIKE axg_file.axg05,
            aag02     LIKE aag_file.aag02,
            axg13     LIKE axg_file.axg13,
            axg14     LIKE axg_file.axg14,
            amt1      LIKE type_file.num20_6,
            axg18     LIKE axg_file.axg18,
            axg15     LIKE axg_file.axg15,
            axg16     LIKE axg_file.axg16,
            amt2      LIKE type_file.num20_6,
            axg19     LIKE axg_file.axg19,
            axg08     LIKE axg_file.axg08,
            axg09     LIKE axg_file.axg09,
            amt3      LIKE type_file.num20_6,
            axg10     LIKE axg_file.axg10,
            axg11     LIKE axg_file.axg11
            #---FUN-AA0097 end------
           END RECORD,
#---FUN-AA0097 start---------
    g_axk  DYNAMIC ARRAY OF RECORD
            axk05     LIKE axk_file.axk05,
            aag02_1   LIKE aag_file.aag02,
            axk06     LIKE axk_file.axk06,
            axk07     LIKE axk_file.axk07,
            axk18     LIKE axk_file.axk18,
            axk19     LIKE axk_file.axk19,
            amt4      LIKE type_file.num20_6,
            axk16     LIKE axk_file.axk16,
            axk20     LIKE axk_file.axk20,
            axk21     LIKE axk_file.axk21,
            amt5      LIKE type_file.num20_6,
            axk17     LIKE axk_file.axk17,
            axk10     LIKE axk_file.axk10,
            axk11     LIKE axk_file.axk11,
            amt6      LIKE type_file.num20_6,
            axk12     LIKE axk_file.axk12,
            axk13     LIKE axk_file.axk13
           END RECORD,
#--FUN-AA0097 end--------------
 
    g_bookno          LIKE axg_file.axg00,      # INPUT ARGUMENT - 1
    g_wc,g_sql        STRING,        #TQC-630166       
    p_row,p_col       LIKE type_file.num5,        #No.FUN-680098     SMALLINT
    g_rec_b           LIKE type_file.num5         #單身筆數   #No.FUN-680098  SMALLINT   
DEFINE   g_sumaxg08   LIKE type_file.num20_6      #借方合計   #FUN-590132   #No.FUN-680098 DECIMAL(20,6)
DEFINE   g_sumaxg09   LIKE type_file.num20_6      #貸方合計   #FUN-590132   #No.FUN-680098 DECIMAL(20,6)
DEFINE   g_cnt        LIKE type_file.num10         #No.FUN-680098 INTEGR
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg        LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72) 
DEFINE   g_row_count  LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump       LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   l_table      STRING                       #No.FUN-8E0113
DEFINE   g_str        STRING                       #No.FUN-8E0113 
DEFINE   g_dbs_axz03     LIKE type_file.chr21      #FUN-920066  add
DEFINE   g_plant_axz03   LIKE azp_file.azp01       #FUN-A50102
DEFINE   g_dbs_gl     LIKE  azp_file.azp03         #FUN-950048 add 090531
DEFINE   g_plant_gl   LIKE azp_file.azp01          #FUN-A50102
DEFINE g_rec_b2       LIKE type_file.num5          #FUN-AA0097
 
MAIN
       DEFINE
          l_sl		LIKE type_file.num5                                    #No.FUN-680098  SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AGL")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
    LET g_sql = "axg00.axg_file.axg00,",
               "axg01.axg_file.axg01,",
               "axg02.axg_file.axg02,",
               "axg03.axg_file.axg03,",
               "axg04.axg_file.axg04,",
               "axg041.axg_file.axg041,",
               "axg05.axg_file.axg05,",
               "axg06.axg_file.axg06,",
               "axg07.axg_file.axg07,",
               "axg08.axg_file.axg08,",
               "axg09.axg_file.axg09,",
               "axg12.axg_file.axg12,",
               "aag02.aag_file.aag02,",
               "ch.type_file.chr1,",
               "axg18.axg_file.axg18,",  #FUN-960010 add
               "axg19.axg_file.axg19"    #FUN-960010 add
    LET l_table = cl_prt_temptable('aglq001',g_sql) CLIPPED
    IF  l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?)" #FUN-950048   #FUN-960010 add ?,?
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep3:',status,1)                                                                                        
       EXIT PROGRAM                                                                                                                 
    END IF 
 
    LET g_bookno = ARG_VAL(1)          #參數值(1) Part#
 
    LET p_row = 1 LET p_col = 1
    OPEN WINDOW q001_w AT p_row,p_col WITH FORM 'agl/42f/aglq001'
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL s_shwact(0,0,g_bookno)
 
    IF NOT cl_null(g_bookno) THEN CALL q001_q() END IF
    IF cl_null(g_bookno) THEN
       LET g_bookno = g_aaz.aaz64
    END IF
    CALL s_dsmark(g_bookno)
 
    CALL q001_menu()
    CLOSE WINDOW q001_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q001_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_axg.clear()
   CALL g_axk.clear()   #FUN-AA0097
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
 
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON  # 螢幕上取單頭條件
            # axg01,axg00,axg02,axg03,axg04,axg041,axg06,axg07,axg12,axg18,axg19   #FUN-590132  #NO.FUN-750076 #FUN-950048   #FUN-960010 add axg18,axg19
              axg01,axg00,axg02,axg03,axg04,axg041,axg06,axg07,axg12   #FUN-AA0097 mod
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(axg01) #族群編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_axg"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axg01
                NEXT FIELD axg01
             WHEN INFIELD(axg12) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = g_aag.axg12
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axg12
                  NEXT FIELD axg12
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET tm.aag04 = '1' 
   INPUT BY NAME tm.aag04 WITHOUT DEFAULTS 
 
      AFTER FIELD aag04 
         IF NOT cl_null(tm.aag04) THEN
            IF tm.aag04 != '1' AND tm.aag04 != '2' THEN
               NEXT FIELD aag04
            END IF 
         END IF
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
   END INPUT 
   IF INT_FLAG THEN RETURN END IF
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
 
  #MOD-A30242---modify---start--- 
  #LET g_sql=" SELECT DISTINCT axg01,axg02,axg03,axg04,axg041,axg18,axg19,",  #NO.FUN-750076  #FUN-950048 拿掉axg17   #FUN-960010 add axg18,axg19
  #          " axg06,axg07,axg12,axg00 ",   #FUN-590132
  #          "   FROM axg_file ",  #NO.FUN-580072   #FUN-950048 mod  #FUN-950048 090531
  #          " WHERE ",tm.wc CLIPPED,
  #          " ORDER BY axg00,axg01,axg02,axg03,axg04,axg041,axg18,axg19,axg06,axg07,axg12"   #TQC-710041  #NO.FUN-750076 #FUN-950048 拿掉axg17   #FUN-960010 add axg18,axg19
   CALL return_dbs() RETURNING g_dbs_gl            
   #LET g_sql=" SELECT DISTINCT axg01,axg02,axg03,axg04,axg041,axg18,axg19,", 
   LET g_sql=" SELECT DISTINCT axg01,axg02,axg03,axg04,axg041,",   #FUN-AA0097  mod
             " axg06,axg07,axg12,axg00 ",  
            #" FROM axg_file,",g_dbs_gl,"aag_file",   #FUN-A50102
             " FROM axg_file,",cl_get_target_table(g_plant_gl,'aag_file'),    #FUN-A50102          
             " WHERE ",tm.wc CLIPPED,
             "   AND axg05 = aag01 ",
             "   AND axg00 = aag00 ",
             "   AND aag04 = '",tm.aag04,"' ", 
            #" ORDER BY axg00,axg01,axg02,axg03,axg04,axg041,axg18,axg19,axg06,axg07,axg12"   
             " ORDER BY axg00,axg01,axg02,axg03,axg04,axg041,axg06,axg07,axg12"     #FUN-AA0097 mod
  #MOD-A30242---modify---end---
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql   #FUN-A50102 
   PREPARE q001_prepare FROM g_sql
   DECLARE q001_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q001_prepare
 
  #MOD-A30242---modify---start--- 
  #LET g_sql=" SELECT UNIQUE axg01,axg02,axg03,axg04,axg041,axg18,axg19",   #FUN-960010 add axg18,axg19
  #          " axg06,axg07,axg12,axg00 ",   #FUN-590132   #FUN-770069 add axg17 #FUN-950048 拿掉axg17 
  #          "  FROM axg_file ",  #FUN-950048 090531
  #          "  WHERE ",tm.wc CLIPPED,
  #          "   INTO TEMP x "
   CALL return_dbs() RETURNING g_dbs_gl           
   #LET g_sql=" SELECT UNIQUE axg01,axg02,axg03,axg04,axg041,axg18,axg19",   #FUN-960010 add axg18,axg19
   LET g_sql=" SELECT UNIQUE axg01,axg02,axg03,axg04,axg041,", #FUN-AA0097 mod
             " axg06,axg07,axg12,axg00 ",  
            #" FROM axg_file,",g_dbs_gl,"aag_file",   #FUN-A50102
             " FROM axg_file,",cl_get_target_table(g_plant_gl,'aag_file'),   #FUN-A50102 
             " WHERE ",tm.wc CLIPPED,
             "   AND axg05 = aag01 ",
             "   AND axg00 = aag00 ",
             "   AND aag04 = '",tm.aag04,"' ", 
             "   INTO TEMP x "
  #MOD-A30242---modify---end---
   DROP TABLE x
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_plant_gl) RETURNING g_sql   #FUN-A50102
   PREPARE q001_prepare_x FROM g_sql
   EXECUTE q001_prepare_x
 
   LET g_sql = "SELECT COUNT(*) FROM x "
   PREPARE q001_prepare_cnt FROM g_sql
   DECLARE q001_count CURSOR FOR q001_prepare_cnt
END FUNCTION
 
FUNCTION q001_menu()
 
   WHILE TRUE
      CALL q001_bp("G")        #FUN-AA0097 #MOD-C70309 remak
     #-------MOD-C70309--mark
     ##--FUN-AA0097 start--
     #IF cl_null(g_action_choice) THEN 
     #   CALL q001_bp("G")
     #END IF     
     ##--FUN-AA0097 end--
     #-------MOD-C70309--mark
      CASE g_action_choice
         #--FUN-AA0097 start-
         WHEN "page1"
            CALL q001_bp("G")
         
         WHEN "page2"
            CALL q001_bp2()
         #--FUN-AA0097 end---

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q001_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = NULL   #MOD-AC0270
#---FUN-AA0097 mark---
#         WHEN "exporttoexcel"   #No.FUN-4B0010
#            IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axg),'','')   #TQC-740015
#            END IF
#---FUN-AA0097 mark---
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q001_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       LET g_action_choice = NULL   #FUN-AA0097
       RETURN 
    END IF
    MESSAGE "SERCHING!"
    OPEN q001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.SQLCODE THEN
       CALL cl_err('',SQLCA.SQLCODE,0)
    ELSE
       OPEN q001_count
       FETCH q001_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q001_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098    VARCHAR(1)     
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098  INTEGER
 
  CASE p_flag
      WHEN 'N' FETCH NEXT     q001_cs INTO g_aag.axg01,g_aag.axg02,g_aag.axg03,   #NO.FUN-750076#FUN-950048 拿掉axg17 
                                           g_aag.axg04,g_aag.axg041,              #FUN-590132
                                           #g_aag.axg18,g_aag.axg19,              #FUN-960010 add #FUN-AA0097 mark
                                           g_aag.axg06,g_aag.axg07,g_aag.axg12,g_aag.axg00   #FUN-590132
      WHEN 'P' FETCH PREVIOUS q001_cs INTO g_aag.axg01,g_aag.axg02,g_aag.axg03,  #NO.FUN-750076 #FUN-950048 拿掉axg17 
                                           g_aag.axg04,g_aag.axg041,             #FUN-590132
                                           #g_aag.axg18,g_aag.axg19,             #FUN-960010  add #FUN-AA0097 mark
                                           g_aag.axg06,g_aag.axg07,g_aag.axg12,g_aag.axg00   #FUN-590132
      WHEN 'F' FETCH FIRST    q001_cs INTO g_aag.axg01,g_aag.axg02,g_aag.axg03,  #NO.FUN-750076 #FUN-950048 拿掉axg17 
                                           g_aag.axg04,g_aag.axg041,             #FUN-590132
                                           #g_aag.axg18,g_aag.axg19,             #FUN-960010  add #FUN-AA0097 mark
                                           g_aag.axg06,g_aag.axg07,g_aag.axg12,g_aag.axg00   #FUN-590132
      WHEN 'L' FETCH LAST     q001_cs INTO g_aag.axg01,g_aag.axg02,g_aag.axg03,  #NO.FUN-750076 #FUN-950048 拿掉axg17 
                                           g_aag.axg04,g_aag.axg041,             #FUN-590132
                                           #g_aag.axg18,g_aag.axg19,             #FUN-960010  add #FUN-AA0097 mark 
                                           g_aag.axg06,g_aag.axg07,g_aag.axg12,g_aag.axg00   #FUN-590132
      WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
 
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
                     LET g_action_choice = NULL   #MOD-AC0270
 
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
                     LET g_action_choice = NULL   #MOD-AC0270
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q001_cs INTO g_aag.axg01,g_aag.axg02,g_aag.axg03,  #NO.FUN-750076 #FUN-950048 拿掉axg17 
                                           g_aag.axg04,g_aag.axg041,               #FUN-590132
                                           #g_aag.axg18,g_aag.axg19,               #FUN-960010  add #FUN-AA0097 mark
                                           g_aag.axg06,g_aag.axg07,g_aag.axg12,g_aag.axg00   #FUN-590132
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.SQLCODE THEN
        CALL cl_err(g_aag.axg01,SQLCA.SQLCODE,0)
        INITIALIZE g_aag.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q001_show()
END FUNCTION
 
FUNCTION q001_show()
 
 
   DISPLAY g_aag.axg01,g_aag.axg02,g_aag.axg03,               #NO.FUN-750076  #FUN-950048 拿掉axg17 
           g_aag.axg04,g_aag.axg041,                                      #FUN-590132
           #g_aag.axg18,g_aag.axg19,                          #FUN-960010  add#FUN-AA0097 mark 
           g_aag.axg06,g_aag.axg07,g_aag.axg12,g_aag.axg00                #FUN-590132
        #TO axg01,axg02,axg03,axg04,axg041,axg18,axg19,axg06,axg07,axg12,axg00   #FUN-590132   #NO.FUN-750076 #FUN-950048 拿掉axg17 #FUN-960010 add axg18,axg19
        TO axg01,axg02,axg03,axg04,axg041,axg06,axg07,axg12,axg00    #FUN-AA0097 mod
 
   CALL q001_axg01('d',g_aag.axg02)      #FUN-920066 mod
 
   CALL q001_b_fill() #單身
   CALL q001_b_fill_2()              #FUN-AA0097
   LET g_action_choice = "page1"     #FUN-AA0097
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q001_axg01(p_cmd,p_axg02)           #FUN-920066 mod
 
  DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1) 
         l_aag02 LIKE aag_file.aag02,
         l_aag06 LIKE aag_file.aag06,
         l_aagacti LIKE aag_file.aagacti
  DEFINE p_axg02   LIKE axg_file.axg02        #FUN-920066 add 
  DEFINE l_axz03   LIKE axz_file.axz03        #FUN-920066 add 
  DEFINE l_axa09   LIKE axz_file.axz09        #FUN-A30067
 
    LET g_errno = ' '
 
    SELECT axz03 INTO l_axz03    
      FROM axz_file
     WHERE axz01 = p_axg02

#No.FUN-A80034 --begin
##No.FUN-A30067 ---start---
#    SELECT axa09 INTO l_axa09 FROM axa_file
#     WHERE axa01 = g_aag.axg01
#       AND axa02 = g_aag.axg02
#    IF l_axa09 = 'Y' THEN
#       LET g_dbs_axz03 = s_dbstring(l_axz03 CLIPPED)
#       LET g_plant_axz03 = l_axz03
#    ELSE
#       LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#       LET g_plant_axz03 = g_plant  #FUN-A50102
#    END IF  
##   LET g_plant_new = l_axz03      #營運中心
##   CALL s_getdbs()
##   LET g_dbs_axz03 = g_dbs_new    #所屬DB
##No.FUN-A30067 ----end---
# 
#    #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
#     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_axz03,'aaz_file'),   #FUN-A50102
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql  #FUN-A50102
#     PREPARE q001_pre FROM g_sql
#     DECLARE q001_cur CURSOR FOR q001_pre
#     OPEN q001_cur
#     FETCH q001_cur INTO g_aag.axg00    #合併後帳別
#     IF cl_null(g_aag.axg00) THEN
#         CALL cl_err(l_axz03,'agl-601',1)
#     END IF
#    CALL s_aaz641_dbs(g_aag.axg01,g_aag.axg02) RETURNING g_dbs_axz03     #FUN-A30122 mark
#No.FUN-A80034 --end
     CALL s_aaz641_dbs(g_aag.axg01,g_aag.axg02) RETURNING g_plant_axz03   #FUN-A30122 add
     DISPLAY BY NAME g_aag.axg00
 
END FUNCTION
 
FUNCTION q001_b_fill()              #BODY FILL UP
 
    DEFINE l_axg  DYNAMIC ARRAY OF RECORD
            axg05     LIKE axg_file.axg05,   #FUN-590132
            aag02     LIKE aag_file.aag02,   #FUN-590132
            axg08     LIKE axg_file.axg08,
            axg09     LIKE axg_file.axg09,
            axg10     LIKE axg_file.axg10,
            axg11     LIKE axg_file.axg11    #FUN-590132 mark
           ,axg13     LIKE axg_file.axg13,   #FUN-A80092
            axg14     LIKE axg_file.axg14,   #FUN-A80092
            axg15     LIKE axg_file.axg15,   #FUN-A80092
            axg16     LIKE axg_file.axg16    #FUN-A80092
           END RECORD
 
   DEFINE l_sql     STRING         #TQC-630166  
   DEFINE l_sql2    STRING         #TQC-630166  
   DEFINE l_n       LIKE type_file.num5   #FUN-590132 mark  #No.FUN-680098 smallint   #TQC-710041 取消mark
   DEFINE l_aag06   LIKE aag_file.aag06   #TQC-710041
   DEFINE l_cnt     LIKE type_file.num5   #FUN-590132 mark
 
   CALL return_dbs() RETURNING g_dbs_gl 
   LET l_sql =
       #FUN-A50102--mod--str--
       #"SELECT axg05,'',axg08,axg09,axg10,axg11 FROM axg_file,",g_dbs_gl,"aag_file",  #FUN-590132#FUN-950048 #FUN-090531 modify 090531
       # "SELECT axg05,'',axg08,axg09,axg10,axg11 ",                         #FUN-AA0097 mark
       # "      ,axg13,axg14,axg15,axg16 ",                  #FUN-A80092 add #FUN-AA0097 mark
        "SELECT axg05,'',axg13,axg14,(axg13-axg14),axg18,axg15,axg16,(axg15-axg16),",   #FUN-AA0097 mod
        "       axg19,axg08,axg09,(axg08-axg09),axg10,axg11",                           #FUN-AA0097 mod
        "  FROM axg_file,",cl_get_target_table(g_plant_gl,'aag_file'),  
       #FUN-A50102--mod--end
        " WHERE axg00='",g_aag.axg00,"'",
        "  AND axg05=aag01",  #FUN-950048 add 090531
        "  AND aag04 = '",tm.aag04,"' ",  #FUN-950048 090531
        "  AND axg01 ='",g_aag.axg01,"'",
        "  AND axg02 ='",g_aag.axg02,"'",
        "  AND axg03 ='",g_aag.axg03,"'",
        "  AND axg04 ='",g_aag.axg04,"'",
        "  AND axg041='",g_aag.axg041,"'",
        #"  AND axg18 ='",g_aag.axg18,"'",     #MOD-A30242 add #FUN-AA0097 mark
        #"  AND axg19 ='",g_aag.axg19,"'",     #MOD-A30242 add #FUN-AA0097 mark
        "  AND axg06 ='",g_aag.axg06,"'",
        "  AND axg12 ='",g_aag.axg12,"'",  #NO.FUN-580072
        "  AND axg07 ='",g_aag.axg07,"'",  #FUN-590132
        "  AND aag01 = axg05 ",            #FUN-950048
        "  AND aag00 = axg00 ",            #FUN-950048
        "  ORDER BY axg05 "   #TQC-710041
 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
    CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql  #FUN-A50102
    PREPARE q001_pb FROM l_sql
    DECLARE q001_bcs CURSOR FOR q001_pb    #BODY CURSOR
 
   LET l_sql2=
        #"SELECT axg05,'',axg08,axg09,axg10,axg11 ",                        #FUN-AA0097 mark
        #"      ,axg13,axg14,axg15,axg16 ",                  #FUN-A80092 add#FUN-AA0097 mark
        "SELECT axg05,'',axg13,axg14,(axg13-axg14),axg18,axg15,axg16,(axg15-axg16),",    #FUN-AA0097 mod
        "       axg19,axg08,axg09,(axg08-axg09),axg10,axg11",                            #FUN-AA0097 mod
        "  FROM axg_file",  #FUN-590132#FUN-950048 
        " WHERE axg00 ='",g_aag.axg00,"'  ",
        "   AND axg01 ='",g_aag.axg01,"'  ",
        "   AND axg02 ='",g_aag.axg02,"'  ",
        "   AND axg03 ='",g_aag.axg03,"'  ",
        "   AND axg04 ='",g_aag.axg04,"'  ",
        "   AND axg041='",g_aag.axg041,"' ",
        #"   AND axg18 ='",g_aag.axg18,"' ",     #MOD-A30242 add #FUN-AA0097 mark
        #"   AND axg19 ='",g_aag.axg19,"' ",     #MOD-A30242 add #FUN-AA0097 mark
        "   AND axg12 ='",g_aag.axg12,"'  ",  #NO.FUN-580072
        "   AND axg06 =",g_aag.axg06,
        "   AND axg07 =?                  ",  #FUN-590132
        "   AND axg05 =?                   "
 
    PREPARE q001_pb2 FROM l_sql2
    DECLARE q001_bcs2 CURSOR FOR q001_pb2    #BODY CURSOR
 
    CALL g_axg.clear()                     #將資料放入Array前，先將裡面清空
    LET g_rec_b=0
    LET g_cnt=1                            #指定由第一筆開始塞資料
    FOREACH q001_bcs INTO g_axg[g_cnt].*        #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          IF NOT cl_null(g_axg[g_cnt].axg05) THEN
 
            #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",   #FUN-A50102
             LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),  #FUN-A50102
                         " WHERE aag01 = '",g_axg[g_cnt].axg05,"'",                
                         "   AND aag00 = '",g_aag.axg00,"'"                
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
             CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql  #FUN-A50102 
             PREPARE q001_pre_1 FROM g_sql
             DECLARE q001_cur_1 CURSOR FOR q001_pre_1
             OPEN q001_cur_1
             FETCH q001_cur_1 INTO g_axg[g_cnt].aag02 
 
             IF SQLCA.SQLCODE THEN
                LET g_axg[g_cnt].aag02=''
             END IF
          END IF
       END IF
 
       CALL l_axg.clear()                     #將資料放入Array前，先將裡面清空
 
       LET l_cnt = 0
       SELECT aag06 INTO l_aag06 FROM aag_file
        WHERE aag01=g_axg[g_cnt].axg05 AND aag00 = g_aag.axg00  #No.FUN-740020
       IF l_aag06 = '1' THEN
          LET l_n = 1
       ELSE
          LET l_n = -1
       END IF
       FOR l_cnt = 1 TO g_aag.axg07+1
           LET g_i = l_cnt - 1
           OPEN q001_bcs2 USING g_i,g_axg[g_cnt].axg05
           IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
              CALL cl_err('',SQLCA.sqlcode,1)
              EXIT FOR
           END IF
           FETCH q001_bcs2 INTO l_axg[l_cnt].*
           IF SQLCA.sqlcode = 100 THEN
              LET l_axg[l_cnt].axg08 = 0
              LET l_axg[l_cnt].axg09 = 0
              LET l_axg[l_cnt].axg10 = 0
              LET l_axg[l_cnt].axg11 = 0
              LET l_axg[l_cnt].axg13 = 0
              LET l_axg[l_cnt].axg14 = 0
              LET l_axg[l_cnt].axg15 = 0
              LET l_axg[l_cnt].axg16 = 0
           END IF
           CLOSE q001_bcs2 
       END FOR
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN               #若超過系統指定最大單身筆數，
          CALL cl_err( '', 9035, 0 )           #則停止匯入資料
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_axg.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt -1
    CALL q001_showamt()   #FUN-590132
    #DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY g_rec_b TO FORMONLY.cnt3    #FUN-AA0097
END FUNCTION

#---FUN-AA0097 start--
FUNCTION q001_b_fill_2()              #BODY FILL UP
   DEFINE l_sql     STRING   

   LET l_sql =
        "SELECT axk05,aag02,axk06,axk07,axk18,axk19,(axk18-axk19),",
        "       axk16,axk20,axk21,(axk20-axk21),axk17,axk10,axk11,",
        "       (axk10-axk11),axk12,axk13",
        "  FROM axk_file,aag_file ",
        " WHERE axk00 = aag00 ",
        "   AND axk05 = aag01",
        "   AND aag04 = '",tm.aag04,"' ",
        "   AND axk00 ='",g_aag.axg00,"'  ",
        "   AND axk01 ='",g_aag.axg01,"'  ",
        "   AND axk02 ='",g_aag.axg02,"'  ",
        "   AND axk03 ='",g_aag.axg03,"'  ",
        "   AND axk04 ='",g_aag.axg04,"'  ",
        "   AND axk041='",g_aag.axg041,"' ",
        "   AND axk06 = '99'",
        "   AND axk14 ='",g_aag.axg12,"'  ", 
        "   AND axk08 =",g_aag.axg06,
        "   AND axk09 =",g_aag.axg07
    PREPARE q001_pb3 FROM l_sql
    DECLARE q001_bcs3              
        CURSOR FOR q001_pb3

    CALL g_axk.clear()
    LET g_rec_b2=0
    LET g_cnt = 1
    FOREACH q001_bcs3 INTO g_axk[g_cnt].*
        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100 THEN
           CALL cl_err('',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN               #若超過系統指定最大單身筆數，
           CALL cl_err( '', 9035, 0 )           #則停止匯入資料
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_axk.DeleteElement(g_cnt)
    LET g_rec_b2=g_cnt -1
    DISPLAY g_rec_b2 TO FORMONLY.cnt4
END FUNCTION
#--FUN-AA0097 end-----------------------
 
FUNCTION q001_showamt()
  DEFINE l_sql  STRING   #FUN-950048 090531 
   LET l_sql = "SELECT SUM(axg08),SUM(axg09)",
              #"  FROM axg_file,",g_dbs_gl,"aag_file",  #FUN-A50102
               "  FROM axg_file,",cl_get_target_table(g_plant_gl,'aag_file'),  #FUN-A50102 
               " WHERE axg00=aag00 ",
               "   AND axg05=aag01 ",
               "   AND axg01 ='",g_aag.axg01,"'",
               "   AND axg02='",g_aag.axg02,"'", 
               "   AND axg03='",g_aag.axg03,"'",
               "   AND axg04='",g_aag.axg04,"'",
               "   AND axg041='",g_aag.axg041,"'",
               "   AND axg06='",g_aag.axg06,"'",
               "   AND axg07 ='",g_aag.axg07,"'",
               "   AND axg12='",g_aag.axg12,"'",
               "   AND aag04= '",tm.aag04, "'"     #FUN-970076
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql     #FUN-A50102
  CALL cl_parse_qry_sql(l_sql,g_plant_gl) RETURNING l_sql   #FUN-A50102
  PREPARE prep_count FROM l_sql 
  EXECUTE prep_count INTO g_sumaxg08,g_sumaxg09
   IF SQLCA.SQLCODE THEN
      LET g_sumaxg08 = 0
      LET g_sumaxg09 = 0
   END IF
 
   IF cl_null(g_sumaxg08) THEN LET g_sumaxg08 = 0 END IF
   IF cl_null(g_sumaxg09) THEN LET g_sumaxg09 = 0 END IF
 
   DISPLAY g_sumaxg08 TO FORMONLY.sumaxg08
   DISPLAY g_sumaxg09 TO FORMONLY.sumaxg09
END FUNCTION
 
FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axg TO s_axg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION page2                   #FUN-AA0097
         LET g_action_choice="page2"    #FUN-AA0097
         EXIT DISPLAY                   #FUN-AA0097

      BEFORE ROW
         CALL cl_show_fld_cont()                          #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#---FUN-AA0097 start--
#      ON ACTION exporttoexcel   #No.FUN-4B0010
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#--FUN-AA0097 end-----
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#---FUN-AA0097 start--
FUNCTION q001_bp2()

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axk TO s_axk.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      #FUN-AB0026 add --start--
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-AB0026 add --end--
 
      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#--FUN-AA0097 end----

#--FUN-AA0097 mark---
#FUNCTION q001_out()
#    DEFINE
#        l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
#        l_name          LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680098  VARCHAR(20) 
#        l_axg  RECORD
#                axg00	LIKE axg_file.axg00,
#                axg01	LIKE axg_file.axg01,
#                axg02	LIKE axg_file.axg02,
#                axg03	LIKE axg_file.axg03,
#                axg04	LIKE axg_file.axg04,
#                axg041	LIKE axg_file.axg041,
#                axg05	LIKE axg_file.axg05,
#                axg06	LIKE axg_file.axg06,
#                axg07	LIKE axg_file.axg07,
#                axg08   LIKE axg_file.axg08,
#                axg09   LIKE axg_file.axg09,
#                axg10   LIKE axg_file.axg10,
#                axg11   LIKE axg_file.axg11,
#                axg12	LIKE axg_file.axg12,   #NO.FUN-580072
#                order   LIKE type_file.chr1000,      #TQC-710041
#                axg18   LIKE axg_file.axg18,   #FUN-960010
#                axg19   LIKE axg_file.axg19    #FUN-960010 
#        END RECORD,
#        l_aag02         LIKE aag_file.aag02,
#        l_aag06         LIKE aag_file.aag06,
#        l_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
# 
#    IF cl_null(tm.wc) THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    CALL cl_del_data(l_table)
#    SELECT aaf03 INTO g_company FROM aaf_file
#       WHERE aaf01 = g_bookno AND aaf02 = g_lang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglq001'
# 
#    LET g_sql="SELECT axg00,axg01,axg02,axg03,axg04,axg041,axg05,axg06,axg07,",  #NO.FUN-750076 #FUN-950048 拿掉axg17 
#              " axg08,axg09,axg10,axg11,axg12,'',axg18,axg19 ",   #TQC-710041  #FUN-960010 add axg18,axg19
#              " FROM axg_file LEFT OUTER JOIN aag_file ON axg05=aag_file.aag01 AND axg00=aag_file.aag00 ",     # 組合出 SQL 指令
#              " WHERE ",tm.wc CLIPPED,
# 
#              " ORDER BY axg00,axg01,axg02,axg03,axg04,axg041,axg06,axg07,axg12,axg05"    #TQC-710041  #NO.FUN-750076 #FUN-950048 拿掉axg17 
#    PREPARE q001_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE q001_co CURSOR FOR q001_p1
# 
# 
#    FOREACH q001_co INTO l_axg.*
#        IF SQLCA.SQLCODE THEN
#            CALL cl_err('Foreach:',SQLCA.SQLCODE,1)
#            EXIT FOREACH
#        END IF
#       #MOD-A30061---add---start---
#       #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file", #FUN-A50102
#        LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),  #FUN-A50102
#                    " WHERE aag01 = '",l_axg.axg05,"'",                
#                    "   AND aag00 = '",l_axg.axg00,"'"                
#        CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
#        CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql   #FUN-A50102
#        PREPARE q001_pre_2 FROM g_sql
#        DECLARE q001_cur_2 CURSOR FOR q001_pre_2
#        OPEN q001_cur_2
#        FETCH q001_cur_2 INTO l_aag02
#       #MOD-A30061---add---end---
#        IF SQLCA.SQLCODE THEN LET l_aag02 = ' ' END IF
# 
#        SELECT aag06 INTO l_aag06 FROM aag_file
#           WHERE aag01=l_axg.axg05 AND aag00=l_axg.axg00
# 
#        EXECUTE insert_prep USING l_axg.axg00,l_axg.axg01,l_axg.axg02,
#                  l_axg.axg03,l_axg.axg04,l_axg.axg041,l_axg.axg05,
#                  l_axg.axg06,l_axg.axg07,l_axg.axg08,l_axg.axg09,
#                  l_axg.axg12,l_aag02,'Y',l_axg.axg18,l_axg.axg19  #FUN-950048  #FUN-960010 add axg18,axg19
# 
#    END FOREACH
# 
# 
#    CLOSE q001_co
#    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#    IF g_zz05='Y' THEN
#        CALL cl_wcchp(tm.wc,'axg01,axg00,axg02,axg03,axg04,  #FUN-950048 拿掉axg17 
#                 axg041,axg06,axg07,axg12') RETURNING tm.wc
#     ELSE
#        LET tm.wc=""
#     END IF
#     LET g_str = tm.wc,";",g_azi05
#     CALL cl_prt_cs3('aglq001','aglq001',g_sql,g_str)
#END FUNCTION
#--FUN-AA0097 mark---
 
FUNCTION return_dbs()
 
DEFINE l_axz04     LIKE axz_file.axz04,
       l_axz03     LIKE axz_file.axz03,
       g_axa_count LIKE type_file.num5,
       l_axb02     LIKE axb_file.axb02,
       l_axa09     LIKE axa_file.axa09,
       g_axz03     LIKE axz_file.axz03
 
#使用tiptop否(axz04)=N,表示為非TIPTOP公司,預設目前所在DB給他
  SELECT axz03,axz04 INTO l_axz03,l_axz04 FROM axz_file  
    WHERE axz01 = g_aag.axg04
 
  IF l_axz04 = 'N' THEN 
      LET l_axz03=g_plant 
  ELSE
      SELECT COUNT(*) INTO g_axa_count
        FROM axb_file
       WHERE axb04 = g_aag.axg04   #公司編號
         AND axb01 = g_aag.axg01   #群組
 
      IF g_axa_count > 0 THEN        #在公司層級中為下層公司時
          #先抓出上一層的公司是哪個PLANT
          SELECT axb02 INTO l_axb02
            FROM axb_file
           WHERE axb01 = g_aag.axg01 #族群
             AND axb04 = g_aag.axg04  #公司編號
 
          SELECT axa09 INTO l_axa09 FROM axa_file,axb_file
           WHERE axa01 = axb01
             AND axa02 = axb02
             AND axa01 = g_aag.axg01  #群組
             AND axb02 = l_axb02      #上層公司
             AND axb04 = g_aag.axg04  #下層公司編號
      ELSE   
          SELECT axa09 INTO l_axa09 FROM axa_file
           WHERE axa01 = g_aag.axg01   #群組
             AND axa02 = g_aag.axg04  #公司編號
      END IF
  
 
      IF l_axa09 = 'Y' THEN      
           SELECT axz03 INTO g_axz03 FROM axz_file
           WHERE axz01 = g_aag.axg04
           LET g_plant_new = g_axz03      #營運中心
           CALL s_getdbs()
           LET g_dbs_gl= g_dbs_new   
           LET g_plant_gl = g_axz03   #FUN-A50102
      ELSE
           LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)    #目前DB
           LET g_dbs_gl    = g_dbs_axz03
           LET g_plant_gl = g_plant    #FUN-A50102
      END IF
  END IF
 
   RETURN g_dbs_gl
      
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
 
#FUN-AA0097 add --start--
FUNCTION q001_out()

    IF g_aag.axg01 IS NULL THEN
       LET g_action_choice = " "
       RETURN 
    END IF

    CLOSE WINDOW screen

    CALL cl_set_act_visible("accept,cancel", TRUE)
    MENU "" #ATTRIBUTE(STYLE="popup")

       ON ACTION print_aglr017
         #LET g_msg = "aglr017", #FUN-C30085 mark
          LET g_msg = "aglg017", #FUN-C30085 add
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '' '1'",
                      " '",g_aag.axg01,"' '",g_aag.axg02,"' '",g_aag.axg03,"' ", 
                      " '",g_aag.axg06,"' '' '",g_aag.axg07,"' '' '' '1'" 
          CALL cl_cmdrun(g_msg)

       ON ACTION print_aglr017_1
         #LET g_msg = "aglr017",  #FUN-C30085 mark
          LET g_msg = "aglg017",  #FUN-C30085 add
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '' '1'",
                      " '",g_aag.axg01,"' '",g_aag.axg02,"' '",g_aag.axg03,"' ", 
                      " '",g_aag.axg06,"' '' '",g_aag.axg07,"' '' '' '2'" 
          CALL cl_cmdrun(g_msg)

       ON ACTION cancel
          LET INT_FLAG=FALSE
          LET g_action_choice = " "
          EXIT MENU

       ON ACTION exit
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CALL cl_set_act_visible("accept,cancel", FALSE)

END FUNCTION
#FUN-AA0097 add --end--
