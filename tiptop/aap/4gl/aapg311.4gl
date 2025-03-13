# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapg311.4gl
# Descriptions...: 付款單列印作業
# Date & Author..: 93/01/07  By  Felicity  Tseng
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-590468 05/09/30 By Dido 報表調整
# Modify.........: No.TQC-5B0043 05/11/08 By Smapmin 調整報表
# Modify.........: No.MOD-610122 06/01/20 By Smapmin 條件修正
# Modify.........: No.MOD-640183 06/04/11 By Dido 未稅金額有誤
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690080 06/10/18 By ice aapt331報表打印
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0088 06/11/13 By baogui 加CLIPPED
# Modify.........: No.TQC-6B0128 06/11/24 By Rayven 科目或帳款欄位太短，數據溢出
# Modify.........: No.FUN-710086 07/02/07 By wujie 使用水晶報表打印 
# Modify.........: No.TQC-730088 07/03/22 By Nicole 新增 CR 參數
# Modify.........: No.FUN-730064 07/04/03 By arman  會計科目加帳套
# Modify.........: No.FUN-740023 07/04/09 By Sarah 傳到cl_prt_cs3()的g_sql忘記加上g_cr_db_str CLIPPED字串
# Modify.........: No.MOD-720121 07/04/30 By Smapmin 修改幣別取位問題
# Modify.........: No.TQC-750030 07/05/09 By Sarah 發票明細沒有列印出來
# Modify.........: No.TQC-750048 07/05/11 By jamie 重新過單
# Modify.........: No.FUN-750044 07/05/15 By Sarah 傳入cs3()的g_sql語法修改(原寫法太長,導致l_url被截斷,無法正常出報表)
# Modify.........: No.TQC-750104 07/05/21 By rainy 5.0複測
# Modify.........: No.TQC-750115 07/05/23 By yiting gen02未印出，apf04列印的欄位名稱有誤，非負責人員
# Modify.........: No.TQC-750226 07/05/29 By rainy  aag02錯誤,有驗收資料未印出,卻有表頭!
# Modify.........: No.MOD-7A0137 07/10/30 By Sarah 原有3張發票,卻只印出一張,應改成子報表寫法
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.MOD-810257 08/01/31 By Smapmin 條件選項拿掉預付與沖帳
# Modify.........: No.MOD-810217 08/01/31 By Smapmin 付款資料,原幣與本幣金額放相反了
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.MOD-840125 08/04/16 By Smapmin 修改付款類別顯示名稱
# Modify.........: No.FUN-940041 09/05/04 By TSD.odyliao 在CR報表列印簽核欄
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No:CHI-910030 09/05/14 By Sarah r311_cpay的SQL可先不抓apb_file,rvb_file資料,當tm.d=1或2才需要串抓這兩個Table的資料 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-A10098 10/01/20 By chenls 跨DB改為不跨DB
# Modify.........: NO.CHI-A40017 10/05/05 By liuxqa modify execute insert_prep
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A10034 10/09/30 By sabrina 新增一個子報表, 用來計算子報表sub1的幣別合計
# Modify.........: NO.FUN-B20014 11/02/12 By lilingyu SQL增加apf00<>'32' or apf00<>'36'的條件
# Modify.........: No.FUN-B40097 11/05/11 By chenying 憑證類CR報表轉成GR
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90058 11/09/06 By chenying 程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C40019 12/04/09 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/04/28 By yangtt GR程式優化
# Modify.........: No.FUN-C10024 12/05/15 By lutingting 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.FUN-CA0099 12/10/16 By chenjing GR报表更改
# Modify.........: No.FUN-D20056 13/02/19 By lujh FUN-CA0099還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                             # Print condition RECORD                 #TQC-750048 add
           wc      LIKE type_file.chr1000,    # Where condition                        #No.FUN-690028 VARCHAR(600)
           a       LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(0.全部 1.預付 2.沖帳 3.付款)  #No.FUN-690028 VARCHAR(1)
           b       LIKE type_file.chr1,       # 巳列印應再列印                         #No.FUN-690028 VARCHAR(1)
           c       LIKE type_file.chr1,       # 列印額外備註                           #No.FUN-690028 VARCHAR(1)
           d       LIKE type_file.chr1,       # 資料性質(1.驗收 2.折讓明細 0.無)       #No.FUN-690028 VARCHAR(1)
           h       LIKE type_file.chr1,       # 資料狀態(1.已確認 2.位確認 3.全部)     #No.FUN-690028 VARCHAR(1)
           more    LIKE type_file.chr1        # Input more condition(Y/N)              #No.FUN-690028 VARCHAR(1)
           END RECORD
DEFINE g_i           LIKE type_file.num5      #count/index for any purpose             #No.FUN-690028 SMALLINT
DEFINE l_table       STRING                   #FUN-710086 add 
DEFINE l_table1      STRING                   #FUN-710086 add 
DEFINE l_table2      STRING                   #FUN-710086 add 
DEFINE l_table3      STRING                   #FUN-710086 add 
DEFINE g_sql         STRING                   #FUN-710086 add
DEFINE g_str         STRING                   #FUN-710086 add
DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-730064
DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-730064
DEFINE g_flag        LIKE type_file.chr1      #FUN-730064 
 
###GENGRE###START
TYPE sr1_t RECORD
    apf01 LIKE apf_file.apf01,
    apf02 LIKE apf_file.apf02,
    apf03 LIKE apf_file.apf03,
    apf04 LIKE apf_file.apf04,
    gen02 LIKE gen_file.gen02,
    apf05 LIKE apf_file.apf05,
    apf06 LIKE apf_file.apf06,
    apf07 LIKE apf_file.apf07,
    apf08f LIKE apf_file.apf08f,
    apf09f LIKE apf_file.apf09f,
    apf10f LIKE apf_file.apf10f,
    apf08 LIKE apf_file.apf08,
    apf09 LIKE apf_file.apf09,
    apf10 LIKE apf_file.apf10,
    apf43 LIKE apf_file.apf43,
    apf44 LIKE apf_file.apf44,
    apf41 LIKE apf_file.apf41,
    apfmksg LIKE apf_file.apfmksg,
    apfprno LIKE apf_file.apfprno,
    apf12 LIKE apf_file.apf12,
    azi03_t LIKE azi_file.azi03,
    azi04_t LIKE azi_file.azi04,
    azi05_t LIKE azi_file.azi05,
    azi03_g LIKE azi_file.azi03,
    azi04_g LIKE azi_file.azi04,
    azi05_g LIKE azi_file.azi05,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    aph01 LIKE aph_file.aph01,
    aph02 LIKE aph_file.aph02,
    aph03 LIKE aph_file.aph03,
    aph04 LIKE aph_file.aph04,
    aph05 LIKE aph_file.aph05,
    aph05f LIKE aph_file.aph05f,
    aph06 LIKE aph_file.aph06,
    aph07 LIKE aph_file.aph07,
    aph08 LIKE aph_file.aph08,
    aph09 LIKE aph_file.aph09,
    aph13 LIKE aph_file.aph13,
    aph14 LIKE aph_file.aph14,
    aag02 LIKE aag_file.aag02,
    nma02 LIKE nma_file.nma02,
    azi03_2 LIKE azi_file.azi03,
    azi04_2 LIKE azi_file.azi04,
    azi05_2 LIKE azi_file.azi05,
    azi07_2 LIKE azi_file.azi07,
    azi03_g LIKE azi_file.azi03,
    azi04_g LIKE azi_file.azi04,
    azi05_g LIKE azi_file.azi05,
    apw02 LIKE apw_file.apw02
END RECORD

TYPE sr3_t RECORD
    apg01 LIKE apg_file.apg01,
    apg02 LIKE apg_file.apg02,
    apg03 LIKE apg_file.apg03,
    apg04 LIKE apg_file.apg04,
    apg05f LIKE apg_file.apg05f,
    apg05 LIKE apg_file.apg05,
    apa02 LIKE apa_file.apa02,
    apa08 LIKE apa_file.apa08,
    apa09 LIKE apa_file.apa09,
    apa12 LIKE apa_file.apa12,
    apa13 LIKE apa_file.apa13,
    apa14 LIKE apa_file.apa14,
    apa24 LIKE apa_file.apa24,
    apa31 LIKE apa_file.apa31,
    apa32 LIKE apa_file.apa32,
    apa34 LIKE apa_file.apa34,
    apa60 LIKE apa_file.apa60,
    apa61 LIKE apa_file.apa61,
    apb04 LIKE apb_file.apb04,
    apb06 LIKE apb_file.apb06,
    apb08 LIKE apb_file.apb08,
    apb09 LIKE apb_file.apb09,
    apb10 LIKE apb_file.apb10,
    apb13 LIKE apb_file.apb13,
    apb15 LIKE apb_file.apb15,
    apb14 LIKE apb_file.apb14,
    rvb05 LIKE rvb_file.rvb05,
    apk03 LIKE apk_file.apk03,
    apk05 LIKE apk_file.apk05,
    apk06 LIKE apk_file.apk06,
    apk07 LIKE apk_file.apk07,
    apk08 LIKE apk_file.apk08,
    azi03_1 LIKE azi_file.azi03,
    azi04_1 LIKE azi_file.azi04,
    azi05_1 LIKE azi_file.azi05,
    azi03_t LIKE azi_file.azi03,
    azi04_t LIKE azi_file.azi04,
    azi05_t LIKE azi_file.azi05,
    azi03_g LIKE azi_file.azi03,
    azi04_g LIKE azi_file.azi04,
    azi05_g LIKE azi_file.azi05
END RECORD

TYPE sr4_t RECORD
    apd01 LIKE apd_file.apd01,
    apd02 LIKE apd_file.apd02,
    apd03 LIKE apd_file.apd03
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #No.FUN-BB0047 mark
 
   LET g_sql = "apf01.apf_file.apf01,",    
               "apf02.apf_file.apf02,",    
               "apf03.apf_file.apf03,",    
               "apf04.apf_file.apf04,",    
               "gen02.gen_file.gen02,",   #NO.TQC-750115    
               "apf05.apf_file.apf05,",    
               "apf06.apf_file.apf06,",    
               "apf07.apf_file.apf07,",    
               "apf08f.apf_file.apf08f,",  
               "apf09f.apf_file.apf09f,",  
               "apf10f.apf_file.apf10f,",  
               "apf08.apf_file.apf08,",    
               "apf09.apf_file.apf09,",    
               "apf10.apf_file.apf10,",    
               "apf43.apf_file.apf43,",    
               "apf44.apf_file.apf44,",    
               "apf41.apf_file.apf41,",    
               "apfmksg.apf_file.apfmksg,",
               "apfprno.apf_file.apfprno,",
               "apf12.apf_file.apf12,",    
               "azi03_t.azi_file.azi03,",
               "azi04_t.azi_file.azi04,",
               "azi05_t.azi_file.azi05,",
               "azi03_g.azi_file.azi03,",
               "azi04_g.azi_file.azi04,",
               "azi05_g.azi_file.azi05,",                                  
               "sign_type.type_file.chr1, ", #簽核方式  #FUN-940041
               "sign_img.type_file.blob,",   #簽核圖檔  #FUN-940041 
               "sign_show.type_file.chr1,",  #是否顯示簽核資料(Y/N)  #FUN-940041
               "sign_str.type_file.chr1000"  #FUN-C40019 add
 
   LET l_table = cl_prt_temptable('aapg311',g_sql) CLIPPED 
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B40097 #FUN-BB0047 mark                                                        
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097#FUN-C10036 mark
      EXIT PROGRAM END IF 
 
   #付款部份
   LET g_sql = "aph01.aph_file.aph01,",    
               "aph02.aph_file.aph02,",    
               "aph03.aph_file.aph03,",    
               "aph04.aph_file.aph04,",    
               "aph05.aph_file.aph05,",    
               "aph05f.aph_file.aph05f,",  
               "aph06.aph_file.aph06,",    
               "aph07.aph_file.aph07,",    
               "aph08.aph_file.aph08,",    
               "aph09.aph_file.aph09,",    
               "aph13.aph_file.aph13,",    
               "aph14.aph_file.aph14,",    
               "aag02.aag_file.aag02,",    
               "nma02.nma_file.nma02,",   
               "azi03_2.azi_file.azi03,",                 
               "azi04_2.azi_file.azi04,",                 
               "azi05_2.azi_file.azi05,",
               "azi07_2.azi_file.azi07,",   #MOD-720121                  
               "azi03_g.azi_file.azi03,",
               "azi04_g.azi_file.azi04,",
               "azi05_g.azi_file.azi05,",                                   
               "apw02.apw_file.apw02"      #MOD-840125
   LET l_table1 = cl_prt_temptable('aapg3111',g_sql) CLIPPED 
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40097  #FUN-BB0047 mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097#FUN-C10036 mark
      EXIT PROGRAM 
   END IF 
 
   #帳款部份
   LET g_sql = "apg01.apg_file.apg01,",      #MOD-7A0137 add
               "apg02.apg_file.apg02,",      #MOD-7A0137 add
               "apg03.apg_file.apg03,",      #MOD-7A0137 add
               "apg04.apg_file.apg04,",      
               "apg05f.apg_file.apg05f,",    #MOD-7A0137 add
               "apg05.apg_file.apg05,",      #MOD-7A0137 add
               "apa02.apa_file.apa02,",    
               "apa08.apa_file.apa08,",    
               "apa09.apa_file.apa09,",    
               "apa12.apa_file.apa12,",    
               "apa13.apa_file.apa13,",    
               "apa14.apa_file.apa14,",    
               "apa24.apa_file.apa24,",    
               "apa31.apa_file.apa31,",    
               "apa32.apa_file.apa32,",    
               "apa34.apa_file.apa34,",    
               "apa60.apa_file.apa60,",    
               "apa61.apa_file.apa61,",    
               "apb04.apb_file.apb04,",    
               "apb06.apb_file.apb06,",    
               "apb08.apb_file.apb08,",    
               "apb09.apb_file.apb09,",    
               "apb10.apb_file.apb10,",    
               "apb13.apb_file.apb13,",    
               "apb15.apb_file.apb15,",    
               "apb14.apb_file.apb14,",    
               "rvb05.rvb_file.rvb05,",    
               "apk03.apk_file.apk03,",  
               "apk05.apk_file.apk05,",  
               "apk06.apk_file.apk06,",  
               "apk07.apk_file.apk07,",  
               "apk08.apk_file.apk08,",  
               "azi03_1.azi_file.azi03,",
               "azi04_1.azi_file.azi04,",                 
               "azi05_1.azi_file.azi05,",     
               "azi03_t.azi_file.azi03,",   #MOD-7A0137 add                
               "azi04_t.azi_file.azi04,",   #MOD-7A0137 add                
               "azi05_t.azi_file.azi05,",   #MOD-7A0137 add
               "azi03_g.azi_file.azi03,",   #MOD-7A0137 add                
               "azi04_g.azi_file.azi04,",   #MOD-7A0137 add                
               "azi05_g.azi_file.azi05"     #MOD-7A0137 add
   LET l_table2 = cl_prt_temptable('aapg3112',g_sql) CLIPPED 
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40097 #FUN-BB0047 mark                                                        
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097#FUN-C10036 mark
      EXIT PROGRAM 
   END IF 
 
   LET g_sql = "apd01.apd_file.apd01,",    
               "apd02.apd_file.apd02,",   #MOD-7A0137 add    
               "apd03.apd_file.apd03"    
   LET l_table3 = cl_prt_temptable('aapg3113',g_sql) CLIPPED 
   IF l_table3 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40097  #FUN-BB0047 mark                                                        
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097#FUN-C10036 mark
      EXIT PROGRAM 
   END IF 
 
   LET g_pdate  = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.h  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g311_tm(0,0)        # Input print condition
      ELSE CALL g311()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
END MAIN
 
FUNCTION g311_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,    #No.FUN-580031
       p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 18
   ELSE 
      LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW g311_w AT p_row,p_col WITH FORM "aap/42f/aapg311"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '0'
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = '0'
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apf01,apf02,apf03,apf04,apf05,apf06
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
    #FUN-CA0099--str----
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(apf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apf1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf01
               WHEN INFIELD(apf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apf03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf03
               WHEN INFIELD(apf04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apf04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf04
               WHEN INFIELD(apf05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apf05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf05
               WHEN INFIELD(apf06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apf06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf06
               OTHERWISE EXIT CASE
            END CASE
    #FUN-CA0099--end----  

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
         LET INT_FLAG = 0 CLOSE WINDOW g311_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40097                                                         
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.a, tm.d, tm.h, tm.b, tm.c, tm.more
            WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[01]'  OR cl_null(tm.a) THEN   #MOD-810257
               NEXT FIELD a
            END IF
         AFTER FIELD b
            IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
         AFTER FIELD c
            IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c) THEN
               NEXT FIELD c
            END IF
         AFTER FIELD d
            IF tm.d NOT MATCHES "[012]" OR cl_null(tm.d) THEN
               NEXT FIELD d
            END IF
         AFTER FIELD h
            IF tm.h NOT MATCHES '[123]'  OR cl_null(tm.h) THEN
               NEXT FIELD h
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
         LET INT_FLAG = 0 CLOSE WINDOW g311_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40097                                                         
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='aapg311'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapg311','9031',1)
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
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                        " '",g_template CLIPPED,"'",     #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapg311',g_time,l_cmd)    #Execute cmd at later time
         END IF
         CLOSE WINDOW g311_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40097                                                         
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g311()
      ERROR ""
   END WHILE
   CLOSE WINDOW g311_w
END FUNCTION
 
FUNCTION g311()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF    LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
          sr1       RECORD apf01   LIKE apf_file.apf01, #付款單單頭檔
                           apf02   LIKE apf_file.apf02,
                           apf03   LIKE apf_file.apf03,
                           apf04   LIKE apf_file.apf04,
                           gen02   LIKE gen_file.gen02,   #no.TQC-750115
                           apf05   LIKE apf_file.apf05,
                           apf06   LIKE apf_file.apf06,
                           apf07   LIKE apf_file.apf07,
                           apf08f  LIKE apf_file.apf08f,
                           apf09f  LIKE apf_file.apf09f,
                           apf10f  LIKE apf_file.apf10f,
                           apf08   LIKE apf_file.apf08,
                           apf09   LIKE apf_file.apf09,
                           apf10   LIKE apf_file.apf10,
                           apf43   LIKE apf_file.apf43,
                           apf44   LIKE apf_file.apf44,
                           apf41   LIKE apf_file.apf41,
                           apfmksg LIKE apf_file.apfmksg,
                           apfprno LIKE apf_file.apfprno,
                           apf12   LIKE apf_file.apf12,
                           azi03_t LIKE azi_file.azi03,
                           azi04_t LIKE azi_file.azi04,
                           azi05_t LIKE azi_file.azi05,
                           azi03_g LIKE azi_file.azi03,
                           azi04_g LIKE azi_file.azi04,
                           azi05_g LIKE azi_file.azi05
                     END RECORD                                                                       #FUN-A10098 ----add
#                    END RECORD,                                                                      #FUN-A10098 ----mark
#          l_dbs_anm,l_dbs LIKE type_file.chr21       # No.FUN-690028 VARCHAR(20)  #No.FUN-7B0012     #FUN-A10098 ----mark

   DEFINE sr2       RECORD aph01  LIKE aph_file.aph01,
                           aph02  LIKE aph_file.aph02,
                           aph03  LIKE aph_file.aph03,
                           aph04  LIKE aph_file.aph04,
                           aph05  LIKE aph_file.aph05,   #MOD-810217
                           aph05f LIKE aph_file.aph05f,  #MOD-810217
                           aph06  LIKE aph_file.aph06,
                           aph07  LIKE aph_file.aph07,
                           aph08  LIKE aph_file.aph08,
                           aph09  LIKE aph_file.aph09,
                           aph13  LIKE aph_file.aph13,
                           aph14  LIKE aph_file.aph14,
                           aag02  LIKE aag_file.aag02,
                           nma02  LIKE nma_file.nma02,
                           azi03  LIKE azi_file.azi03,
                           azi04  LIKE azi_file.azi04,
                           azi05  LIKE azi_file.azi05,
                           azi07  LIKE azi_file.azi07    #MOD-720121
                    END RECORD,
          srapg     RECORD LIKE apg_file.*,             #MOD-7A0137 add
          sr12      RECORD apa02 LIKE apa_file.apa02,
                           apa08 LIKE apa_file.apa08,
                           apa09 LIKE apa_file.apa09, 
                           apa12 LIKE apa_file.apa12,
                           apa13 LIKE apa_file.apa13,
                           apa14 LIKE apa_file.apa14,
                           apa24 LIKE apa_file.apa24,
                           apa31 LIKE apa_file.apa31,
                           apa32 LIKE apa_file.apa32,
                           apa34 LIKE apa_file.apa34,
                           apa60 LIKE apa_file.apa60,
                           apa61 LIKE apa_file.apa61,
                           apb04 LIKE apb_file.apb04,   #應付帳款單身檔
                           apb06 LIKE apb_file.apb06,
                           apb08 LIKE apb_file.apb08,
                           apb09 LIKE apb_file.apb09,
                           apb10 LIKE apb_file.apb10,
                           apb13 LIKE apb_file.apb13,
                           apb15 LIKE apb_file.apb15,
                           apb14 LIKE apb_file.apb14,
                           rvb05 LIKE rvb_file.rvb05    #驗收單身檔
                    END RECORD,
      l_flag_apk    LIKE type_file.chr1,                #MOD-7A0137 add
      l_flag        LIKE type_file.chr1,        
      l_cnt         LIKE type_file.num5,                #CHI-910030 add
      l_pritem      LIKE type_file.num5,        
      l_miscnum     LIKE type_file.num5,        
      l_amt         LIKE type_file.num20_6,     
      l_tot1f,l_tot2f,l_tot3f  LIKE type_file.num20_6,   
      l_tot1,l_tot2,l_tot3     LIKE type_file.num20_6, 
      l_apa08       LIKE apa_file.apa08,
      l_apk03       LIKE apk_file.apk03,
      l_apk05       LIKE apk_file.apk05,
      l_apk06       LIKE apk_file.apk06,
      l_apk07       LIKE apk_file.apk07,
      l_apk08       LIKE apk_file.apk08,
      l_apd         RECORD LIKE apd_file.*,    #備註檔   #MOD-7A0137 add
      l_azi03       LIKE azi_file.azi03,
      l_azi04       LIKE azi_file.azi04,
      l_azi05       LIKE azi_file.azi05,
      l_apw02       LIKE apw_file.apw02        #MOD-840125
 DEFINE l_img_blob     LIKE type_file.blob
 DEFINE l_sign_type    LIKE type_file.chr1   #CHI-A40017 add
 DEFINE l_sign_show    LIKE type_file.chr1   #CHI-A40017 add
 DEFINE l_ii           INTEGER
 DEFINE l_key          RECORD                  #主鍵
           v1          LIKE apf_file.apf01 
           END RECORD
 DEFINE l_plant     LIKE type_file.chr10       #FUN-980020
 
 
   #清除CR暫存檔裡的資料
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?", #NO.TQC-750115 加上一個?   #MOD-7A0137 mod 31?->26?
               "        ,?,?,?,?)"  #FUN-940041 加三個?      #FUN-C40019 add 1?
   PREPARE insert_prep FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM    
   END IF                           
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",   #MOD-7A0137 mod 
               "        ?,?)"  #MOD-720121               #MOD-7A0137 mod 19?->21?   #MOD-840125  
   PREPARE insert_prep1 FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM    
   END IF                           
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?)"   #TQC-750030 35個?->30個?   #MOD-7A0137 mod 30?->41?
   PREPARE insert_prep2 FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM    
   END IF                           
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED, 
               " VALUES(?,?,?)"   #MOD-7A0137 add 1?  
   PREPARE insert_prep3 FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM    
   END IF                           
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapg311'
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
 
   LET l_sql = "SELECT ",
              #" apf01, apf02, apf03, apf04,  apf05,  apf06,",
              #" apf01, apf02, apf03, apf04,  '',     apf05, apf06,",   #NO.TQC-750115 #FUN-C5003 mark
               " apf01, apf02, apf03, apf04,  gen02,  apf05, apf06,",   #FUN-C50003 add
               " apf07, apf08f,apf09f,apf10f, apf08,  apf09, apf10,",
               " apf43, apf44, apf41, apfmksg,apfprno,apf12,",
               " azi03, azi04,azi05",             #FUN-C50003 add
              #" apg02, apg03, apg04, apg05f, apg05   ",   #MOD-7A0137 mark
               " FROM apf_file",  # ,apg_file ",           #MOD-7A0137 mod
               " LEFT OUTER JOIN gen_file ON gen01 = apf04",  #FUN-C50003 add
               " LEFT OUTER JOIN azi_file ON azi01 = apf06",  #FUN-C50003 add
              #" WHERE apf01 = apg01 ",                    #MOD-7A0137 mark
               " WHERE apf41 <> 'X' ",                     #MOD-7A0137 mod
               "   AND (apf00 <> '32' OR apf00 <> '36')",  #FUN-B20014                
               "   AND apf00 <> '11' ",   #MOD-810257
               "   AND ",tm.wc CLIPPED

   IF tm.a ='1' THEN 
      LET l_sql = l_sql CLIPPED, " AND (apf00 ='33' OR apf00 = '34') "   
   END IF
   IF tm.b = 'N' THEN
      LET l_sql = l_sql CLIPPED, " AND (apfprno = 0 OR apfprno IS NULL)"
   END IF
   CASE WHEN tm.h ='1' LET l_sql = l_sql CLIPPED, " AND apf41 ='Y' "
        WHEN tm.h ='2' LET l_sql = l_sql CLIPPED, " AND apf41 ='N' "
        OTHERWISE EXIT CASE
   END CASE
   PREPARE g311_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM
   END IF
   DECLARE g311_curs1 CURSOR FOR g311_prepare1
 
   #-->列印付款單的貸方
   LET l_plant = g_apz.apz04p                       #FUN-980020
#No.FUN-A10098 -----mark start
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_apz.apz04p
#   IF l_dbs IS NOT NULL AND l_dbs != ' '
#   THEN LET l_dbs_anm = s_dbstring(l_dbs clipped)   #TQC-940178 ADD
#   ELSE LET l_dbs_anm = ' '
#   END IF
#
#    LET l_dbs=s_dbstring(l_dbs CLIPPED)     #FUN-820017
#No.FUN-A10098 -----mark end
     #FUN-C10024--mark--str--
     #  CALL s_get_bookno1(NULL,l_plant)     #FUN-980020
     #       RETURNING g_flag,g_bookno1,g_bookno2
     #  IF g_flag = '1' THEN
     #     CALL  cl_err(g_aza.aza01,'aoo-081',1)
     #  END IF
     #FUN-C10024--mark--end
   LET l_sql = " SELECT aph_file.aph01, aph_file.aph02,",
               "        aph_file.aph03, aph_file.aph04,",  
               "        aph_file.aph05,aph_file.aph05f,",    #MOD-810217
               "        aph_file.aph06, aph_file.aph07,",
               "        aph_file.aph08, aph_file.aph09,", 
               "        aph_file.aph13, aph_file.aph14,", 
               "        aag02,nma02 ,",             
               "        azi03,azi04,azi05,azi07",       #FUN-C50003 add
#               "   FROM aph_file, OUTER aag_file,",               #No.FUN-A10098 -----mark
#               "    OUTER ",l_dbs_anm clipped," nma_file ",       #No.FUN-A10098 -----mark
             # "   FROM aph_file, OUTER aag_file, OUTER nma_file ",    #No.FUN-A10098 -----add  #FUN-C50003 mark
             # "   FROM aph_file LEFT OUTER JOIN aag_file ON aph04=aag01 AND aag00 ='",g_bookno1,"' ",   #FUN-C50003 add   #FUN-C10024
               "   FROM aph_file LEFT OUTER JOIN aag_file ON aph04=aag01 AND aag00 =? ",                 #FUN-C10024
               "   LEFT OUTER JOIN nma_file ON aph08 = nma01",               #FUN-C50003 add
               "   LEFT OUTER JOIN azi_file ON azi01 = aph13",               #FUN-C50003 add
               " WHERE aph01 = ?  "
             # "   AND aph_file.aph04 = aag_file.aag01 AND aph_file.aph08 = nma_file.nma01 ",  #FUN-C50003 mark
             # "   AND aag_file.aag00 = '",g_bookno1,"' "         #NO.FUN-730064  #FUN-C50003 mark
   PREPARE aph_prepare FROM l_sql
   DECLARE aph_curs CURSOR FOR aph_prepare
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('perpare aph_fiie error!',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM
   END IF
 
  #-->抓取帳款部份(apg_file)的資料
   LET l_sql = "SELECT * FROM apg_file WHERE apg01 = ?"
   PREPARE apg_prepare FROM l_sql
   DECLARE apg_curs CURSOR FOR apg_prepare
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('perpare apg_fiie error!',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM
   END IF
 
   #-->額外備註列印
   LET l_sql = " SELECT * FROM apd_file ",
               "  WHERE apd01 =  ? "
   PREPARE apd_prepare FROM l_sql
   DECLARE apd_curs CURSOR FOR apd_prepare
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('perpare apd_fiie error!',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
      EXIT PROGRAM
   END IF
 
#FUN-C50003----add----str---
         LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
                   " FROM  apk_file ",             
                   " WHERE apk01 =  ? "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE g311_premisc FROM l_sql
         DECLARE g311_misc CURSOR FOR g311_premisc

         #str CHI-910030 add
         LET l_sql = "SELECT COUNT(*)",
                     "  FROM ",g_dbs_new CLIPPED," apb_file,",
                     " OUTER ",g_dbs_new CLIPPED," rvb_file",
                     " WHERE apb01 = ?",
                     "   AND apb04 = rvb01 ",     #驗收單號
                     "   AND apb05 = rvb02 "      #驗收項次
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
         PREPARE r311_ppay_cnt FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)      
            EXIT PROGRAM
         END IF
         DECLARE r311_cpay_cnt CURSOR FOR r311_ppay_cnt

         LET l_sql = "SELECT apb04,apb06,apb08,apb09,apb10,apb13,apb15,apb14,",
                     "       rvb05",
                     "  FROM ",g_dbs_new CLIPPED," apb_file,",
                     " OUTER ",g_dbs_new CLIPPED," rvb_file",
                     " WHERE apb01 = ?",
                     "   AND apb04 = rvb01 ",     #驗收單號
                     "   AND apb05 = rvb02 "      #驗收項次
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE r311_ppay1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-580184  #No.FUN-6A0055
            CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)      
            EXIT PROGRAM
         END IF
         DECLARE r311_cpay1 CURSOR FOR r311_ppay1
        #end CHI-910030 add

         #-->各廠的請款資料讀取
         LET l_sql = " SELECT apa02, apa08, apa09, apa12, apa13,apa14,apa24,",
                     " apa31, apa32, apa34, apa60, apa61,",
                     " '', '', 0, 0, 0, 0, 0, 0,",       
                     " '', azi03, azi04, azi05 ",    
                     " FROM apa_file ",
                     " LEFT OUTER JOIN  azi_file ON apa13=azi01",
                     " WHERE apa01 = ? ",
                     "   AND apa41 = 'Y' AND apa42='N'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
         CALL cl_parse_qry_sql(l_sql,srapg.apg03) RETURNING l_sql  
         PREPARE g311_ppay FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) 
            EXIT PROGRAM
         END IF
         DECLARE g311_cpay CURSOR FOR g311_ppay
#FUN-C50003----add---end----

   FOREACH g311_curs1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

#FUN-C50003-----mark---str---
#     SELECT gen02 INTO sr1.gen02
#       FROM gen_file
#      WHERE gen01 = sr1.apf04
#     
#     SELECT azi03,azi04,azi05
#       INTO sr1.azi03_t,sr1.azi04_t,sr1.azi05_t
#       FROM azi_file
#      WHERE azi01=sr1.apf06
#FUN-C50003-----mark---end---
      LET sr1.azi03_g =g_azi03
      LET sr1.azi04_g =g_azi04
      LET sr1.azi05_g =g_azi05
   
      LET l_sign_type = ''    #CHI-A40017 add
      LET l_sign_show = 'N'   #CHI-A40017 add 
      EXECUTE insert_prep USING sr1.*
                          ,l_sign_type,l_img_blob,l_sign_show,""    #FUN-940041  #CHI-A40017 mod #FUN-C40019 add ""
                          #,"",l_img_blob,"N"    #FUN-940041 
 
      #FUN-C10024--add--str--
        CALL s_get_bookno1(YEAR(sr1.apf02),l_plant)    
             RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag = '1' THEN
           CALL  cl_err(g_aza.aza01,'aoo-081',1)
        END IF
     #FUN-C10024--add--end
      #--->列印付款單貸方資料
      #FOREACH aph_curs USING sr1.apf01 INTO sr2.*    #FUN-C10024
      FOREACH aph_curs USING g_bookno1,sr1.apf01 INTO sr2.*     #FUN-C10024
        #FUN-C50003----mark---str---
        #SELECT azi03,azi04,azi05,azi07   #MOD-720121
        #  INTO sr2.azi03,sr2.azi04,sr2.azi05,sr2.azi07    #MOD-720121
        #  FROM azi_file
        # WHERE azi01=sr2.aph13
        #IF SQLCA.sqlcode != 0 THEN
        #   CALL cl_err3("sel","azi_file",sr2.aph13,"",SQLCA.sqlcode,"","foreach apf_file error !",1)  
        #   EXIT FOREACH
        #END IF
        #FUN-C50003----mark---end---
         IF sr2.aph03 NOT MATCHES "[123456789ABCZ]" THEN
            LET l_apw02 = ''
            SELECT apw02 INTO l_apw02 FROM apw_file
              WHERE apw01=sr2.aph03
            IF NOT cl_null(l_apw02) THEN
               LET l_apw02 = sr2.aph03 CLIPPED,'.',l_apw02 CLIPPED
            END IF
         END IF
         EXECUTE insert_prep1 USING sr2.*,g_azi03,g_azi04,g_azi05,l_apw02   #MOD-7A0137   #MOD-840125
      END FOREACH
 
      #以帳款部份的帳款編號去抓取各廠的帳款資料
      FOREACH apg_curs USING sr1.apf01 INTO srapg.*   
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach pag:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_flag_apk = 'N'        #MOD-7A0137 add
         INITIALIZE sr12.* TO NULL   #MOD-7A0137 add
         LET l_azi03 = '' LET l_azi04 = '' LET l_azi05 = ''
         LET g_plant_new = srapg.apg03   #MOD-7A0137
#         CALL s_getdbs()                                            #No.FUN-A10098 -----mark
#FUN-C50003----mark---str---
#        LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
#                   " FROM  ",g_dbs_new CLIPPED," apk_file ",        #No.FUN-A10098 -----mark
#                  " FROM  apk_file ",                               #No.FUN-A10098 -----add 
#                  " WHERE apk01 =  ? "
#	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#        PREPARE g311_premisc FROM l_sql
#        DECLARE g311_misc CURSOR FOR g311_premisc

#        #str CHI-910030 add
#        LET l_sql = "SELECT COUNT(*)",
#                    "  FROM ",g_dbs_new CLIPPED," apb_file,",
#                    " OUTER ",g_dbs_new CLIPPED," rvb_file",
#                    " WHERE apb01 = ?",
#                    "   AND apb04 = rvb01 ",     #驗收單號
#                    "   AND apb05 = rvb02 "      #驗收項次
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-920032
#        PREPARE r311_ppay_cnt FROM l_sql
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-580184  #No.FUN-6A0055
#           CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
#           EXIT PROGRAM
#        END IF
#        DECLARE r311_cpay_cnt CURSOR FOR r311_ppay_cnt

#        LET l_sql = "SELECT apb04,apb06,apb08,apb09,apb10,apb13,apb15,apb14,",
#                    "       rvb05",
#                    "  FROM ",g_dbs_new CLIPPED," apb_file,",
#                    " OUTER ",g_dbs_new CLIPPED," rvb_file",
#                    " WHERE apb01 = ?",
#                    "   AND apb04 = rvb01 ",     #驗收單號
#                    "   AND apb05 = rvb02 "      #驗收項次
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-920032
#        PREPARE r311_ppay1 FROM l_sql
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-580184  #No.FUN-6A0055
#           CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
#           EXIT PROGRAM
#        END IF
#        DECLARE r311_cpay1 CURSOR FOR r311_ppay1
#       #end CHI-910030 add     
#
#        #-->各廠的請款資料讀取
#        LET l_sql = " SELECT apa02, apa08, apa09, apa12, apa13,apa14,apa24,",
#                    " apa31, apa32, apa34, apa60, apa61,",
#                   #" apb04, apb06, apb08, apb09, apb10, apb13, apb15, apb14,",  #CHI-910030 mark
#                    " '', '', 0, 0, 0, 0, 0, 0,",                                #CHI-910030
#                   #" rvb05, azi03, azi04, azi05 ",   #CHI-910030 mark
#                    " '', azi03, azi04, azi05 ",      #CHI-910030           
#No.FUN-A10098 -----mark start
#                     " FROM   ",g_dbs_new CLIPPED," apa_file,OUTER (",
#                                g_dbs_new CLIPPED," apb_file,",
#                     " OUTER  ",g_dbs_new CLIPPED," rvb_file),",
#                     " LEFT OUTER JOIN ",g_dbs_new CLIPPED," azi_file ON apa13=azi01 ",
#No.FUN-A10098 -----mark end
#FUN-A60056--mod--str--
##No.FUN-A10098 -----add start
#                    " FROM  apa_file,OUTER (apb_file, OUTER   rvb_file), LEFT OUTER JOIN  azi_file ON apa13=azi01 ",
#                    " WHERE apa_file.apa01 = apb_file.apb01 ",
#                    "   AND apa01 = '",srapg.apg04,"'",   #MOD-7A0137
#                    "   AND apa41 = 'Y' AND apa42='N'",     #wujie 091019 add ','
#                    "   AND apb05 = rvb_file.rvb02 "            #驗收項次  #wujie 091019
##No.FUN-A10098 -----add end
#                    #str CHI-910030 mod
#                   #" FROM  apa_file LEFT OUTER JOIN apb_file LEFT OUTER JOIN  ",
#                   #                        cl_get_target_table(srapg.apg03,'rvb_file'),
#                   #"                        ON apb05 = rvb_file.rvb02 ",
#                   #"           ON apa_file.apa01 = apb_file.apb01 ",
#                    " FROM apa_file ",
#                   #str CHI-910030 mod   
#                    " LEFT OUTER JOIN  azi_file ON apa13=azi01",
#                    " WHERE apa01 = '",srapg.apg04,"'", 
#                    "   AND apa41 = 'Y' AND apa42='N'"
#FUN-A60056--mod--end
#	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#        CALL cl_parse_qry_sql(l_sql,srapg.apg03) RETURNING l_sql   #FUN-A60056
#        PREPARE g311_ppay FROM l_sql
#        IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time
#           CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40097
#           EXIT PROGRAM
#        END IF
#        DECLARE g311_cpay CURSOR FOR g311_ppay
#FUN-C50003----mark---end---
         FOREACH g311_cpay USING srapg.apg04 INTO sr12.*,l_azi03,l_azi04,l_azi05
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreac g311_cpay',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_flag_apk = "Y"   #MOD-7A0137 add
            LET l_amt = sr12.apa31 + sr12.apa32 - sr12.apa60 - sr12.apa61
            #str CHI-910030 add
            OPEN r311_cpay_cnt
            FETCH r311_cpay_cnt INTO l_cnt
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
           #end CHI-910030 add 
            IF sr12.apa08 = 'MISC' THEN   #表示是多發票,需抓apk_file
               LET l_flag =0
               FOREACH g311_misc USING srapg.apg04   #MOD-7A0137
                            INTO l_apk03,l_apk05,l_apk06,l_apk07,l_apk08
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  #str CHI-910030 add
                  IF tm.d='1' OR tm.d='2' THEN
                     IF l_cnt > 0 THEN
                        FOREACH r311_cpay1 USING srapg.apg04
                                            INTO sr12.apb04,sr12.apb06,sr12.apb08,
                                                 sr12.apb09,sr12.apb10,sr12.apb13,
                                                 sr12.apb15,sr12.apb14,sr12.rvb05
                           IF SQLCA.sqlcode THEN
                              CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                              EXIT FOREACH
                           END IF
                           EXECUTE insert_prep2 USING
                             #sr1.apg04,                                        #MOD-7A0137 mark
                              srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                              srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                              sr12.*,l_apk03,l_apk05,l_apk06,l_apk07,l_apk08,
                              l_azi03,l_azi04,l_azi05,
                              sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                              g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                           LET l_flag =1
                        END FOREACH
                     ELSE
                        EXECUTE insert_prep2 USING
                          #sr1.apg04,                                        #MOD-7A0137 mark
                           srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                           srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                           sr12.*,l_apk03,l_apk05,l_apk06,l_apk07,l_apk08,
                           l_azi03,l_azi04,l_azi05,
                           sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                           g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                        LET l_flag =1
                     END IF
                  ELSE
                 #end CHI-910030 add
                     EXECUTE insert_prep2 USING 
                        srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                        srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                        sr12.*,l_apk03,l_apk05,l_apk06,l_apk07,l_apk08,
                        l_azi03,l_azi04,l_azi05,
                        sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                        g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                     LET l_flag =1
                  END IF   #CHI-910030 add 
               END FOREACH
               IF l_flag =0 THEN
                  #str CHI-910030 add
                  IF tm.d='1' OR tm.d='2' THEN
                     IF l_cnt > 0 THEN
                        FOREACH r311_cpay1 USING srapg.apg04
                                            INTO sr12.apb04,sr12.apb06,sr12.apb08,
                                                 sr12.apb09,sr12.apb10,sr12.apb13,
                                                 sr12.apb15,sr12.apb14,sr12.rvb05
                           IF SQLCA.sqlcode THEN
                              CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                              EXIT FOREACH
                           END IF
                           EXECUTE insert_prep2 USING
                             #sr1.apg04,                                        #MOD-7A0137 mark
                              srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                              srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                              sr12.*,'',g_today,'','','',
                              l_azi03,l_azi04,l_azi05,
                              sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                              g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                        END FOREACH
                     ELSE
                        EXECUTE insert_prep2 USING
                          #sr1.apg04,                                        #MOD-7A0137 mark
                           srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                           srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                           sr12.*,'',g_today,'','','',
                           l_azi03,l_azi04,l_azi05,
                           sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                           g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                     END IF
                  ELSE
                 #end CHI-910030 add   
                     EXECUTE insert_prep2 USING  
                         srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                         srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                         sr12.*,'',g_today,'','','',
                         l_azi03,l_azi04,l_azi05,
                         sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                         g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                  END IF   #CHI-910030 add                                          
               END IF
            ELSE   #表示是單張發票,直接抓帳款單頭發票資訊寫入
               #str CHI-910030 add
               IF tm.d='1' OR tm.d='2' THEN
                  IF l_cnt > 0 THEN
                     FOREACH r311_cpay1 USING srapg.apg04
                                         INTO sr12.apb04,sr12.apb06,sr12.apb08,
                                              sr12.apb09,sr12.apb10,sr12.apb13,
                                              sr12.apb15,sr12.apb14,sr12.rvb05
                        IF SQLCA.sqlcode THEN
                           CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                           EXIT FOREACH
                        END IF
                        EXECUTE insert_prep2 USING
                           srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,
                           srapg.apg05f,srapg.apg05,
                           sr12.*,
                           sr12.apa08,sr12.apa09,sr12.apa34,sr12.apa32,sr12.apa31,
                           l_azi03,l_azi04,l_azi05,
                           sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,
                           g_azi03,g_azi04,g_azi05
                     END FOREACH
                  ELSE
                     EXECUTE insert_prep2 USING
                        srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,
                        srapg.apg05f,srapg.apg05,
                        sr12.*,
                        sr12.apa08,sr12.apa09,sr12.apa34,sr12.apa32,sr12.apa31,
                        l_azi03,l_azi04,l_azi05,
                        sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,
                        g_azi03,g_azi04,g_azi05
                  END IF
               ELSE
              #end CHI-910030 add           
                  EXECUTE insert_prep2 USING 
                  srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,
                  srapg.apg05f,srapg.apg05,
                  sr12.*,
                  sr12.apa08,sr12.apa09,sr12.apa34,sr12.apa32,sr12.apa31,
                  l_azi03,l_azi04,l_azi05,
                  sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,
                  g_azi03,g_azi04,g_azi05
               END IF   #CHI-910030 add      
            END IF
         END FOREACH
         IF l_flag_apk = 'N' THEN
            #str CHI-910030 add
            IF tm.d='1' OR tm.d='2' THEN
               IF l_cnt > 0 THEN
                  FOREACH r311_cpay1 USING srapg.apg04
                                      INTO sr12.apb04,sr12.apb06,sr12.apb08,
                                           sr12.apb09,sr12.apb10,sr12.apb13,
                                           sr12.apb15,sr12.apb14,sr12.rvb05
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                        EXIT FOREACH
                     END IF
                     EXECUTE insert_prep2 USING
                        srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                        srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                        sr12.*,'',g_today,'','','',
                        l_azi03,l_azi04,l_azi05,
                        sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                        g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                     LET l_flag_apk = 'Y'
                  END FOREACH
               ELSE
                  EXECUTE insert_prep2 USING
                     srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                     srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                     sr12.*,'',g_today,'','','',
                     l_azi03,l_azi04,l_azi05,
                     sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                     g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                  LET l_flag_apk = 'Y'
               END IF
            ELSE
           #end CHI-910030 add
               EXECUTE insert_prep2 USING
                  srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                  srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                  sr12.*,'',g_today,'','','',
                  l_azi03,l_azi04,l_azi05,
                  sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                  g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
               LET l_flag_apk = 'Y'
            END IF   #CHI-910030 add
         END IF
      END FOREACH   #MOD-7A0137 add
      #-->列印額外備註
      IF tm.c = 'Y' THEN
         FOREACH apd_curs USING sr1.apf01 INTO l_apd.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach apd erroe ',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            EXECUTE insert_prep3 USING l_apd.*   #MOD-7A0137 mod
         END FOREACH
      END IF
      CALL g311_upd(sr1.apf01)       #更改"列印次數"
   END FOREACH
 

###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3,"|",     #CHI-A10034 取消l_table3後面的mark
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1          #CHI-A10034 add

   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apf01,apf02,apf03,apf04,apf05,apf06') RETURNING tm.wc     #MOD-810257
   ELSE
      LET tm.wc = ' '
   END IF
###GENGRE###   LET g_str = tm.d,";",tm.c,";",tm.wc         
 
  LET g_cr_table = l_table                 #主報表的temp table名稱
  LET g_cr_gcx01 = "aapi103"               #單別維護程式
  LET g_cr_apr_key_f = "apf01"             #報表主鍵欄位名稱，用"|"隔開
  LET l_sql = "SELECT DISTINCT apf01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  PREPARE key_pr FROM l_sql
  DECLARE key_cs CURSOR FOR key_pr
  LET l_ii = 1
  #報表主鍵值
  CALL g_cr_apr_key.clear()                #清空
  FOREACH key_cs INTO l_key.*
     LET g_cr_apr_key[l_ii].v1 = l_key.v1
     LET l_ii = l_ii + 1
  END FOREACH

 
###GENGRE###   CALL cl_prt_cs3('aapg311','aapg311',g_sql,g_str)  
    CALL aapg311_grdata()    ###GENGRE###
   #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105  MARK
#  CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)   #FUN-B90058 mark
END FUNCTION
 
FUNCTION g311_upd(l_apf01)
   DEFINE l_apf01 LIKE apf_file.apf01
 
   UPDATE apf_file SET apfprno = apfprno + 1 
    WHERE apf01 = l_apf01
      AND (apf00 <> '32' OR apf00 <> '36')  #FUN-B20014            
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err3("upd","apf_file",l_apf01,"",SQLCA.sqlcode,"","update apfprno:",1)  #No.FUN-660122
   END IF
END FUNCTION
 
#No.FUN-9C0077 程式精簡

###GENGRE###START
FUNCTION aapg311_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aapg311")
        IF handler IS NOT NULL THEN
            START REPORT aapg311_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY apf01"    #FUN-B40097          

            DECLARE aapg311_datacur1 CURSOR FROM l_sql
            FOREACH aapg311_datacur1 INTO sr1.*
                OUTPUT TO REPORT aapg311_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg311_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aapg311_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE l_lineno         LIKE type_file.num5
    #FUN-B40097----add----str-------------
    DEFINE l_apf04_gen02    STRING
    DEFINE l_sql            STRING
    DEFINE l_apf08_fmt      STRING
    DEFINE l_apf09_fmt      STRING
    DEFINE l_apf10_fmt      STRING
    DEFINE l_apf08f_fmt      STRING
    DEFINE l_apf09f_fmt      STRING
    DEFINE l_apf10f_fmt      STRING
    DEFINE l_azi05           LIKE azi_file.azi05
    #FUN-B40097----add----end-------------

    
    ORDER EXTERNAL BY sr1.apf01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.apf01
            LET l_lineno = 0
            #FUN-B40097----add----str-------------
            IF NOT cl_null(sr1.apf04) AND NOT cl_null(sr1.gen02) THEN
               LET l_apf04_gen02 = sr1.apf04,' ',sr1.gen02
            ELSE
               IF NOT cl_null(sr1.apf04) AND cl_null(sr1.gen02) THEN
                 LET l_apf04_gen02 = sr1.apf04
               END IF
               IF cl_null(sr1.apf04) AND NOT cl_null(sr1.gen02) THEN
                  LET l_apf04_gen02 = sr1.gen02
               END IF
            END IF
            PRINTX l_apf04_gen02

        #FUN-D20056--mark-str--
        #FUN-CA0099--add--str---
        #   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
        #               " WHERE apg01 = '",sr1.apf01,"'",
        #               " ORDER BY apg02"
        #   START REPORT aapg311_subrep02 
        #   DECLARE aapg311_repcur2 CURSOR FROM l_sql
        #   FOREACH aapg311_repcur2 INTO sr3.*
        #       OUTPUT TO REPORT aapg311_subrep02(sr3.*)
        #   END FOREACH
        #   FINISH REPORT aapg311_subrep02
        #FUN-CA0099--add--end---
        #FUN-D20056--mark--end--

            LET l_sql = "SELECT  A.*,B.azi05_t,B.apf01 FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED, " A LEFT OUTER JOIN ",
                         g_cr_db_str CLIPPED,l_table CLIPPED," B ON A.aph01 = B.apf01 ",
                        " WHERE aph01 = '",sr1.apf01,"'",
                        " ORDER BY aph03"
                  #     "   AND aag00 = '",g_bookno1,"'"   
            START REPORT aapg311_subrep01
            DECLARE aapg311_repcur1 CURSOR FROM l_sql
            FOREACH aapg311_repcur1 INTO sr2.*,l_azi05
                OUTPUT TO REPORT aapg311_subrep01(sr2.*,l_azi05)
            END FOREACH
            FINISH REPORT aapg311_subrep01 

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE aph01 = '",sr1.apf01,"'",
                        " ORDER BY aph13"                    
                  #     "   AND aag00 = '",g_bookno1,"' "
            START REPORT aapg311_subrep04
            DECLARE aapg311_repcur4 CURSOR FROM l_sql
            FOREACH aapg311_repcur4 INTO sr2.*
                OUTPUT TO REPORT aapg311_subrep04(sr2.*)
            END FOREACH
            FINISH REPORT aapg311_subrep04 
     
       #FUN-D20056--mark--str-- 
       #FUN-CA009--add--str----
       #    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
       #                " WHERE aph01 = '",sr1.apf01,"'",
       #                " ORDER BY aph03"                    
       #    START REPORT aapg311_subrep05
       #    DECLARE aapg311_repcur5 CURSOR FROM l_sql
       #    FOREACH aapg311_repcur5 INTO sr2.*
       #        OUTPUT TO REPORT aapg311_subrep05(sr2.*)
       #    END FOREACH
       #    FINISH REPORT aapg311_subrep05
       #FUN-CA0099--add--end---
       #FUN-D20056--mark--end--

      #FUN-D20056--unmark--str-- 
      #FUN-CA0099--mark--str---
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                       " WHERE apg01 = '",sr1.apf01,"'",  
                       " ORDER BY apg02"
           START REPORT aapg311_subrep02 
           DECLARE aapg311_repcur2 CURSOR FROM l_sql
           FOREACH aapg311_repcur2 INTO sr3.*
               OUTPUT TO REPORT aapg311_subrep02(sr3.*)
           END FOREACH
           FINISH REPORT aapg311_subrep02
      #FUN-CA0099--mark--end---
      #FUN-D20056--unmark--end--
            
        
            LET l_apf08_fmt = cl_gr_numfmt('apf_file','apf08',g_azi04)
            LET l_apf09_fmt = cl_gr_numfmt('apf_file','apf09',g_azi04)
            LET l_apf10_fmt = cl_gr_numfmt('apf_file','apf10',g_azi04)
            LET l_apf08f_fmt = cl_gr_numfmt('apf_file','apf08f',sr1.azi04_t)
            LET l_apf09f_fmt = cl_gr_numfmt('apf_file','apf09f',sr1.azi04_t)
            LET l_apf10f_fmt = cl_gr_numfmt('apf_file','apf10f',sr1.azi04_t)            
            PRINTX l_apf08_fmt
            PRINTX l_apf09_fmt
            PRINTX l_apf10_fmt
            PRINTX l_apf08f_fmt
            PRINTX l_apf09f_fmt
            PRINTX l_apf10f_fmt

            #FUN-B40097----add----end-------------

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

    #FUN-D20056--unmark--str--
    #FUN-CA0099---mark--str-----
       AFTER GROUP OF sr1.apf01
           #FUN-B40097----add----str-------------
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                       " WHERE apd01 = '",sr1.apf04,"'"
           START REPORT aapg311_subrep03 
           DECLARE aapg311_repcur3 CURSOR FROM l_sql
           FOREACH aapg311_repcur3 INTO sr4.*
               OUTPUT TO REPORT aapg311_subrep03(sr4.*)
           END FOREACH
           FINISH REPORT aapg311_subrep03
           #FUN-B40097----add----end-------------
    #FUN-CA0099---mark--end-----
    #FUN-D20056--unmark--end--
        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-B40097----add----str-------------
REPORT aapg311_subrep01(sr2,l_azi05)
    DEFINE sr2            sr2_t
    DEFINE l_payment      STRING
    DEFINE l_aph05f_sum        LIKE aph_file.aph05f
    DEFINE l_aph05_sum         LIKE aph_file.aph05
    DEFINE l_aph14_fmt         STRING
    DEFINE l_aph05_fmt         STRING
    DEFINE l_aph05f_fmt        STRING
    DEFINE l_aph05_sum_fmt     STRING
    DEFINE l_aph05f_sum_fmt    STRING
    DEFINE l_azi05    LIKE azi_file.azi05
    #DEFINE l_aph04             STRING     #FUN-CA0099  #FUN-D20056 mark

    ORDER EXTERNAL BY sr2.aph01

    FORMAT
        ON EVERY ROW
 
            IF sr2.aph03 ='1' OR sr2.aph03 = '2' OR sr2.aph03 = '3' OR sr2.aph03 = '4' OR sr2.aph03 = '5' OR sr2.aph03 = '6'
               OR sr2.aph03 = '7' OR sr2.aph03 = '8' OR sr2.aph03 = '9' OR sr2.aph03 = 'A' OR sr2.aph03 = 'B' OR sr2.aph03 = 'C'
               OR sr2.aph03 = 'Z' THEN
               LET l_payment = sr2.aph03,'.',cl_gr_getmsg("gre-059",g_lang,sr2.aph03)
            ELSE
               LET l_payment = sr2.apw02
            END IF 
            PRINTX l_payment
            #LET l_aph04 = sr2.aph04,' ',sr2.aag02       #FUN-CA0099  #FUN-D20056 mark
            #PRINTX l_aph04                              #FUN-CA0099  #FUN-D20056 mark
            PRINTX sr2.*

            LET l_aph14_fmt = cl_gr_numfmt('aph_file','aph14',sr2.azi07_2)
            LET l_aph05_fmt = cl_gr_numfmt('aph_file','aph05',g_azi04)
            LET l_aph05f_fmt = cl_gr_numfmt('aph_file','aph05f',sr2.azi04_2)
            PRINTX l_aph14_fmt
            PRINTX l_aph05_fmt
            PRINTX l_aph05f_fmt

        AFTER GROUP OF sr2.aph01
            LET l_aph05f_sum = GROUP SUM(sr2.aph05f)
            PRINTX l_aph05f_sum

            LET l_aph05_sum = GROUP SUM(sr2.aph05)
            PRINTX l_aph05_sum

            LET l_aph05_sum_fmt = cl_gr_numfmt('aph_file','aph05',g_azi05)
            LET l_aph05f_sum_fmt = cl_gr_numfmt('aph_file','aph05f',l_azi05)
            PRINTX l_aph05_sum_fmt
            PRINTX l_aph05f_sum_fmt
    


END REPORT

REPORT aapg311_subrep02(sr3)
    DEFINE sr3          sr3_t
    DEFINE sr3_o        sr3_t
    DEFINE l_apa60      LIKE apa_file.apa60
    DEFINE l_apa61      LIKE apa_file.apa61
    DEFINE l_apg05_sum  LIKE apg_file.apg05
    DEFINE l_apg05f_sum LIKE apg_file.apg05f
    DEFINE l_display    STRING
    DEFINE l_display1   STRING
    DEFINE l_display2   STRING
    DEFINE l_display3   STRING
    DEFINE l_display4   STRING
    DEFINE l_sql        STRING
    DEFINE l_cnt        LIKE type_file.num5  
    DEFINE l_apg05_fmt        STRING
    DEFINE l_apg05f_fmt       STRING
    DEFINE l_apg05_sum_fmt    STRING
    DEFINE l_apg05f_sum_fmt   STRING
    DEFINE l_apk08_fmt        STRING
    DEFINE l_apk07_fmt        STRING
    DEFINE l_apk06_fmt        STRING
    DEFINE l_apa31_fmt        STRING
    DEFINE l_apa32_fmt        STRING
    DEFINE l_apa34_fmt        STRING


    ORDER EXTERNAL BY sr3.apg01,sr3.apg02 

    FORMAT
        #FUN-D20056--add 0220
        BEFORE GROUP OF sr3.apg01
            LET l_apg05_sum = 0
            LET l_apg05f_sum = 0
        #FUN-D20056--add 0220

        ON EVERY ROW
            PRINTX tm.*
            LET g_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE apk03 = '",sr3.apk03,"'"
            DECLARE aapg311_rep2cur CURSOR FROM g_sql
            FOREACH aapg311_rep2cur INTO l_cnt
            END FOREACH    
            IF l_cnt = 0 THEN  LET l_display3 = 'N' ELSE LET l_display3 = 'Y' END IF
            PRINTX l_display3   

            IF cl_null(sr3.apa08) AND cl_null( sr3.apk03) THEN LET l_display4 = 'N' ELSE LET l_display4 = 'Y' END IF
            PRINTX l_display4
               
            IF cl_null(l_apa60) THEN 
               LET l_apa60 = 0
            ELSE
               LET l_apa60 = -sr3.apa60
            END IF 
            PRINTX l_apa60
            IF cl_null(l_apa61) THEN
               LET l_apa61 = 0
            ELSE
               LET l_apa61 = -sr3.apa61
            END IF
            PRINTX l_apa61
              
            LET l_display = "Y"
          # IF NOT cl_null(sr3_o.apg01) AND NOT cl_null(sr3_o.apg02) AND NOT cl_null(sr3_o.apk03) THEN
               IF sr3.apa08 = "MISC" AND NOT cl_null(sr3.apk03) THEN
                  IF sr3_o.apg01 = sr3.apg01 AND sr3_o.apg02 = sr3.apg02 AND sr3_o.apk03 = sr3.apk03 THEN
                     LET l_display = "N"
                  ELSE
                     LET l_display = "Y"
                  END IF
              ELSE
                  LET l_display = "N"
              END IF 
          #END IF
           PRINTX l_display

           LET l_display1 = "Y"
          #IF NOT cl_null(sr3_o.apg01) AND NOT cl_null(sr3_o.apg02) AND NOT cl_null(sr3_o.apa08) THEN
              IF sr3.apa08 != "MISC" AND NOT cl_null(sr3.apa08) THEN
                  IF sr3_o.apg01 = sr3.apg01 AND sr3_o.apg02 = sr3.apg02 AND sr3_o.apa08 = sr3.apa08 THEN
                     LET l_display1 = "N"
                  ELSE
                     LET l_display1 = "Y"
                  END IF
               ELSE
                  LET l_display1 = "N"
               END IF
          #END IF
           PRINTX l_display1

            IF sr3_o.apg01 = sr3.apg01 THEN
               LET l_display2 = "Y"
            ELSE
               IF l_apa60 <> 0 OR l_apa61 <> 0 THEN 
                  LET l_display2 = "N"
               ELSE
                  LET l_display2 = "Y"
               END IF
            END IF
            PRINTX l_display2
             
            LET l_apg05_fmt = cl_gr_numfmt('apg_file','apg05',sr3.azi04_g)
            PRINTX l_apg05_fmt
            LET l_apg05f_fmt = cl_gr_numfmt('apg_file','apg05f',sr3.azi04_t)
            PRINTX l_apg05f_fmt 
            LET l_apk08_fmt = cl_gr_numfmt('apk_file','apk08',sr3.azi04_t)
            PRINTX l_apk08_fmt
            LET l_apk07_fmt = cl_gr_numfmt('apk_file','apk07',sr3.azi04_t)
            PRINTX l_apk07_fmt  
            LET l_apk06_fmt = cl_gr_numfmt('apk_file','apk06',sr3.azi04_t)
            PRINTX l_apk06_fmt
            LET l_apa31_fmt = cl_gr_numfmt('apa_file','apa31',sr3.azi04_g)
            PRINTX l_apa31_fmt
            LET l_apa32_fmt = cl_gr_numfmt('apa_file','apa32',sr3.azi04_g)
            PRINTX l_apa32_fmt
            LET l_apa34_fmt = cl_gr_numfmt('apa_file','apa34',sr3.azi04_g)
            PRINTX l_apa34_fmt

            #FUN-D20056--add --0220
            IF NOT cl_null(sr3_o.apg02) AND NOT cl_null(sr3_o.apg04) THEN 
               IF (sr3_o.apg04 = sr3.apg04 AND sr3_o.apg02 != sr3.apg02) OR sr3_o.apg04 != sr3.apg04  THEN 
                  LET l_apg05_sum = sr3.apg05 + l_apg05_sum 
                  LET l_apg05f_sum = sr3.apg05f + l_apg05f_sum 
               END IF
            ELSE
               LET l_apg05_sum = sr3.apg05
               LET l_apg05f_sum = sr3.apg05f
            END IF   
            #FUN-D20056--add --0220
  

            PRINTX sr3.*
            LET sr3_o.* = sr3.*

        AFTER GROUP OF sr3.apg01
           #LET l_apg05_sum = GROUP SUM(sr3.apg05)     #FUN-D20056 add 0220
            PRINTX l_apg05_sum
           #LET l_apg05f_sum = GROUP SUM(sr3.apg05f)   #FUN-D20056 add 0220
            PRINTX l_apg05f_sum
            
            LET l_apg05_sum_fmt = cl_gr_numfmt('apg_file','apg05',sr3.azi05_g)
            PRINTX l_apg05_sum_fmt
            LET l_apg05f_sum_fmt = cl_gr_numfmt('apg_file','apg05f',sr3.azi05_t)
            PRINTX l_apg05f_sum_fmt

    

        AFTER GROUP OF sr3.apg02
 
END REPORT

#FUN-D20056--unmark--str--
#FUN-CA0099---mark--str--
REPORT aapg311_subrep03(sr4)
    DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT
#FUN-CA0099---mark--end--
#FUN-D20056--unmark--end--

REPORT aapg311_subrep04(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_aph05f_sum        LIKE aph_file.aph05 
    DEFINE l_aph05_sum         LIKE aph_file.aph05
    DEFINE l_aph05_sum_fmt     STRING
    DEFINE l_aph05f_sum_fmt    STRING

    ORDER EXTERNAL BY sr2.aph13              

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*


        AFTER GROUP OF sr2.aph13
            LET l_aph05f_sum = GROUP SUM(sr2.aph05f)
            PRINTX l_aph05f_sum
            
            LET l_aph05_sum = GROUP SUM(sr2.aph05)
            PRINTX l_aph05_sum

            LET l_aph05_sum_fmt = cl_gr_numfmt('aph_file','aph05',g_azi05)
            LET l_aph05f_sum_fmt = cl_gr_numfmt('aph_file','aph05f',sr2.azi05_g)
            PRINTX l_aph05_sum_fmt
            PRINTX l_aph05f_sum_fmt
        
END REPORT
#FUN-B40097----add----end-------------

#FUN-D20056--mark--str--
#FUN-CA0099--add--str---
#REPORT aapg311_subrep05(sr2)
#  DEFINE sr2 sr2_t
#  DEFINE l_n                 LIKE type_file.num5   
#  DEFINE l_aph05_tot         LIKE aph_file.aph05  
#  DEFINE l_aph05_tot_up      STRING                
#  DEFINE l_aph03             STRING                
#  DEFINE sr2_o  sr2_t
#  DEFINE l_aph05_tot_fmt     STRING               
#  DEFINE l_display           STRING
#  DEFINE l_aph05             STRING

#  ORDER EXTERNAL BY sr2.aph03
#   FORMAT
#      BEFORE GROUP OF sr2.aph03              
#      ON EVERY ROW
#          PRINTX sr2.*
#      AFTER GROUP OF sr2.aph03
#         LET l_aph03 = cl_gr_getmsg("gre-059",g_lang,sr2.aph03),':'
#         PRINTX l_aph03
#         LET l_aph05_tot = GROUP SUM(sr2.aph05)  
#         PRINTX l_aph05_tot  
#         LET l_aph05_tot_fmt = cl_gr_numfmt('aph_file','aph05',g_azi05)
#         PRINTX l_aph05_tot_fmt
#         LET l_aph05_tot_up = s_sayc2(l_aph05_tot,50) 
#         PRINTX l_aph05_tot_up  
#         LET l_aph05 = l_aph05_tot_up,'  ',l_aph05_tot
#         PRINTX l_aph05
#         IF NOT cl_null(sr2_o.aph03) AND sr2.aph03 != sr2_o.aph03 THEN 
#            LET l_display = 'N'
#         ELSE 
#            LET l_display = 'Y'
#         END IF 
#         LET sr2_o.aph03 = sr2.aph03
#         PRINTX l_display

#         ON LAST ROW
#            LET sr2_o.aph03 = NULL
#END REPORT
#FUN-CA0099--add--end---
#FUN-D20056--mark--end--
