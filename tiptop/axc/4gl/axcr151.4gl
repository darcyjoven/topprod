# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr151.4gl
# Descriptions...: 存貨淨變現價值表
# Date & Author..: No.FUN-890030 08/09/16 By sherry
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-8C0116 08/12/25 By sherry 增加成品跌價,原料溢價處理
# Modify.........: No.TQC-910009 09/01/07 By kim 如果不印庫存數量tm.b者, 則無法計算 "變現價值"金額.
# Modify.........: No.MOD-930027 09/03/03 By Pengu sr.amt_o,sr.amt_p,sr.amt_q 沒有清空舊值
# Modify.........: No.FUN-930100 09/03/31 By jan 打印資料增加 產品分類
# Modify.........: NO.FUN-950058 09/05/19 By kim for 十號公報-多項問題修正
# Modify.........: NO.CHI-970011 09/07/13 By jan 涉及到ccc_file的WHERE 條件新增ccc07/ccc08
# Modify.........: NO.FUN-960053 09/07/17 By jan 報表中"數量"欄位的值，需扣除從今日推算起"呆滯天數"以前的數量
# Modify.........: NO.TQC-970117 09/07/17 By jan 修改sr.amt的算法
# Modify.........: NO.CHI-980015 09/08/07 By mike 預設執行年度期別，請統一為預設帶axcs010之年度期別(ccz01、ccz02)。                 
                                            
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.CHI-980067 09/11/12 By jan 計算呆滯日期的起始日不應該用g_today,改用當期最後一天
# Modify.........: No.FUN-9C0170 10/01/05 By jan 新增ctype欄位及相關處理
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/19 By lutingting GP5.2跨DB處理 
# Modify.........: No.TQC-A50166 10/04/28 By Carrier GP5.2报表追单
# Modify.........: No.FUN-A70084 10/06/23 By lutingting GP5.2報表修改
# Modify.........: No.FUN-A80110 10/09/29 By vealxu 畫面多一個checkbox勾選是否多營運中心
# Modify.........: No:MOD-B70144 11/07/14 By Vampire (1) 追單 CHI-B30078 增加"最近異動日"計算
#                                                    (2) FOREACH r151_imk_cs1 中 SUM(cmc04)應補上CHI-B30078 的判斷
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:MOD-BB0286 11/12/13 By johung 呆滯天數的判斷應改為<=
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條
# Modify.........: No:MOD-C20080 12/02/10 By ck2yuan 扣除除外倉的數量後，imk09數量為0的資料不要顯示在報表上
# Modify.........: No:MOD-C30032 12/03/07 By ck2yuan 對imk09進行取位,並多傳一個參數到CR
# Modify.........: No:CHI-C20002 12/05/09 By bart 1.取消原”是否列印庫存明細”選項 
#                                                 2.原數量欄位，改顯示”月底結存量”不扣除呆滯量 
#                                                 3.於報表中，加印”呆滯量”欄位
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc1     STRING,                # Where condition   #FUN-A10098
              wc2     STRING,                # Where condition
              s1      LIKE type_file.chr1,   # 排序
              t1      LIKE type_file.chr1,   # 跳頁
              u1      LIKE type_file.chr1,   # 小計
              yy      LIKE type_file.num5,   # 年度
              mm      LIKE type_file.num5,   # 期別
              tt      LIKE type_file.num5,   # 呆滯天數  #FUN-960053
              ctype   LIKE type_file.chr1,   # FUN-9C0170
              a       LIKE type_file.chr1,   # 是否列印料號明細(Y/N)
              #b       LIKE type_file.chr1,   # 是否列印庫存明細(Y/N)  #CHI-C20002
              c       LIKE type_file.chr1,   # 是否列印原料溢價(Y/N) #FUN-8C0116
              d       LIKE type_file.chr1,   # 計算基準              #MOD-B70144 add
              o       LIKE type_file.chr1,   # 轉換幣別否(Y/N)
              a_curr  LIKE azi_file.azi01,   # 總帳幣別
              t_curr  LIKE azi_file.azi01,   # 轉換幣別
              rate    LIKE apa_file.apa14,   # 乘匯率
              p       LIKE type_file.chr1,   #FUN-A80110 add
              more    LIKE type_file.chr1    # Input more condition(Y/N)
             #FUN-A10098--add--str--
             ,plant_1,plant_2,plant_3,plant_4 LIKE cre_file.cre08,   
              plant_5,plant_6,plant_7,plant_8 LIKE cre_file.cre08
             #FUN-A10098--add--end
              END RECORD
  DEFINE l_table     STRING
  DEFINE g_sql       STRING
  DEFINE g_str       STRING
  DEFINE l_outimk09  LIKE imk_file.imk09        #FUN-950058
  DEFINE l_plant     ARRAY[8] OF  LIKE azp_file.azp01   #FUN-A10098 
  DEFINE g_tmp       ARRAY[8] OF  LIKE azp_file.azp01   #FUN-A10098 
  DEFINE g_atot,g_k  LIKE type_file.num5    #FUN-A10098-
  DEFINE m_legal           ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084

#====================================
# 主程式開始
#====================================
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN 
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   #FUN-A10098--add--str--
   FOR g_atot =1 to 8
     LET l_plant[g_atot]=''
   END FOR

   LET tm.plant_1 = l_plant[1]
   LET tm.plant_2 = l_plant[2]
   LET tm.plant_3 = l_plant[3]
   LET tm.plant_4 = l_plant[4]
   LET tm.plant_5 = l_plant[5]
   LET tm.plant_6 = l_plant[6]
   LET tm.plant_7 = l_plant[7]
   LET tm.plant_8 = l_plant[8]
   #FUN-A10098--add--end
   LET g_sql = "azp01.azp_file.azp01,",
               "chr20.type_file.chr20,",
               "chr50.type_file.chr50,",
               "ccc01.ccc_file.ccc01,",
               "imk02.imk_file.imk02,",
               "imk09.imk_file.imk09,",
               "ccc92.ccc_file.ccc92,",
               "ccc23.ccc_file.ccc23,",
              #No.TQC-A50166  --Begin
              #"cmd05.cmd_file.cmd05,",   #TQC-990129
              #"cmd06.cmd_file.cmd06,",   #TQC-990129
              #"cmd07.cmd_file.cmd07,",   #TQC-990129
              #"cmd08.cmd_file.cmd08,",   #TQC-990129
              #"cmd09.cmd_file.cmd09,",   #TQC-990129
               "cma25.cma_file.cma25,",   #TQC-990129
               "cma26.cma_file.cma26,",   #TQC-990129
               "cma27.cma_file.cma27,",   #TQC-990129
               "cma28.cma_file.cma28,",   #TQC-990129
               "cma29.cma_file.cma29,",   #TQC-990129
              #No.TQC-A50166  --End  
               "amt.ccc_file.ccc92,  ",
               "amt_m.ccc_file.ccc92,",
               "amt_o.ccc_file.ccc92,",
               "amt_p.ccc_file.ccc92,",
               "amt_q.ccc_file.ccc92,",
              #No.TQC-A50166  --Begin
              #"cmd12.cmd_file.cmd12,",   #TQC-990129
               "cma32.cma_file.cma32,",   #TQC-990129
              #No.TQC-A50166  --End  
               "d_price.type_file.chr1,",  #FUN-8C0116            
               "cma08.cma_file.cma08,",    #FUN-9C0170            
               "t_azi07.azi_file.azi07,",
               "cma24.cma_file.cma24,",    #FUN-930100  
               "cmc04.cmc_file.cmc04,",    #CHI-C20002 
               "cmc04a.ccc_file.ccc92"     #CHI-C20002          
               
   LET l_table = cl_prt_temptable('axcr151',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? )" #FUN-8C0116 #FUN-930100 add ?#FUN-9C0170 add? #CHI-C20002 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
                   
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #FUN-A10098--mod--str--
  #LET tm.wc1   = ARG_VAL(7)
  #LET tm.wc2   = ARG_VAL(8)
  #LET tm.s1    = ARG_VAL(9)
  #LET tm.t1    = ARG_VAL(10)
  #LET tm.u1    = ARG_VAL(11)
  #LET tm.yy    = ARG_VAL(12)
  #LET tm.mm    = ARG_VAL(13)
  #LET tm.tt    = ARG_VAL(14)  #FUN-960053
  #LET tm.a     = ARG_VAL(15)
  #LET tm.b     = ARG_VAL(16)
  #LET tm.o     = ARG_VAL(17)
  #LET tm.a_curr= ARG_VAL(18)
  #LET tm.t_curr= ARG_VAL(19)
  #LET tm.rate  = ARG_VAL(20)
  #LET g_rep_user = ARG_VAL(21)
  #LET g_rep_clas = ARG_VAL(22)
  #LET g_template = ARG_VAL(23)
  #LET tm.c       = ARG_VAL(24) #FUN-8C0116
  #LET tm.ctype   = ARG_VAL(25) #FUN-9C0170
   LET tm.wc2   = ARG_VAL(7)
   LET tm.s1    = ARG_VAL(8)
   LET tm.t1    = ARG_VAL(9)
   LET tm.u1    = ARG_VAL(10)
   LET tm.yy    = ARG_VAL(11)
   LET tm.mm    = ARG_VAL(12)
   LET tm.tt    = ARG_VAL(13)
   LET tm.a     = ARG_VAL(14)
   #LET tm.b     = ARG_VAL(15)  #CHI-C20002
   LET tm.o     = ARG_VAL(15)
   LET tm.a_curr= ARG_VAL(16)
   LET tm.t_curr= ARG_VAL(17)
   LET tm.rate  = ARG_VAL(18)
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET tm.c       = ARG_VAL(22)
   LET tm.ctype   = ARG_VAL(23)
   LET tm.plant_1 = ARG_VAL(24)  
   LET tm.plant_2 = ARG_VAL(25)
   LET tm.plant_3 = ARG_VAL(26)
   LET tm.plant_4 = ARG_VAL(27)
   LET tm.plant_5 = ARG_VAL(28)
   LET tm.plant_6 = ARG_VAL(29)
   LET tm.plant_7 = ARG_VAL(30)
   LET tm.plant_8 = ARG_VAL(31)
   LET tm.p       = ARG_VAL(32)          #FUN-A80110
   LET tm.d       = ARG_VAL(33)          #MOD-B70144 add
 
#No.FUN-A10098--add--end
  #IF cl_null(tm.wc1)   #FUN-A10098
   IF cl_null(tm.wc2)   #FUN-A10098
      THEN CALL r151_tm(0,0)             # Input print condition
      ELSE CALL r151()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#====================================
# 開窗輸入條件
#====================================
FUNCTION r151_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE l_a_curr_o     LIKE azi_file.azi01,
          l_t_curr_o     LIKE azi_file.azi01,
          l_exT          LIKE type_file.chr1
   DEFINE l_cmz09        LIKE cmz_file.cmz09  #FUN-960053
   DEFINE l_ac           LIKE type_file.num10 #FUN-A10098 
   DEFINE i              LIKE type_file.num5  #FUN-A10098
   DEFINE li_result      LIKE type_file.num5  #FUN-A10098 
   DEFINE l_cnt          LIKE type_file.num5           #No.FUN-A70084

   LET p_row = 1 LET p_col = 20
   OPEN WINDOW r151_w AT p_row,p_col WITH FORM "axc/42f/axcr151"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL r151_set_visible() RETURNING l_cnt    #FUN-A70084
   
   SELECT cmz09 INTO l_cmz09 FROM cmz_file WHERE cmz00 = '0'
  #MOD-B70144 --- mark --- start ---
  # IF l_cmz09 = '2' THEN
  #    CALL cl_set_comp_visible("tt",FALSE)
  # END IF
  #MOD-B70144 --- mark ---  end  ---
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.yy   = g_ccz.ccz01                                                                                                        
   LET tm.mm   = g_ccz.ccz02                                                                                                        
   LET tm.s1   = '1'
   LET tm.t1   = 'N'
   LET tm.u1   = 'N'
   LET tm.a    = 'N'
   #LET tm.b    = 'N'  #CHI-C20002
   LET tm.c    = 'Y' #FUN-8C0116
   LET tm.o    = 'N'
   LET tm.a_curr = g_aza.aza17
   LET tm.t_curr = g_aza.aza17
   LET tm.rate   = 1
   LET l_a_curr_o = tm.a_curr
   LET l_t_curr_o = tm.t_curr
   LET l_exT = 'S'
   LET tm.ctype = g_ccz.ccz28   #FUN-9C0170
   LET l_plant[1]=g_plant   #預設現行工廠 #No.FUN-A10098 
   LET tm.plant_1 = l_plant[1]#FUN-A80110 
   LET tm.p = 'N'             #FUN-A80110 
   LET tm.d    = l_cmz09      #MOD-B70144 add
WHILE TRUE
  
 #FUN-A10098--mark--str--
 ##QBE查詢條件1
 # CONSTRUCT BY NAME tm.wc1 ON azp01
 #    BEFORE CONSTRUCT
 #       CALL cl_qbe_init()
 
 #    ON ACTION locale
 #       CALL cl_show_fld_cont()
 #       LET g_action_choice = "locale"
 #       EXIT CONSTRUCT
 
 #    ON IDLE g_idle_seconds
 #       CALL cl_on_idle()
 #       CONTINUE CONSTRUCT
 
 #    ON ACTION controlp
 #       CASE
 #         WHEN INFIELD(azp01)   #料件
 #              CALL cl_init_qry_var()
 #              LET g_qryparam.form = "q_azp"
 #              LET g_qryparam.state = "c"
 #              CALL cl_create_qry() RETURNING g_qryparam.multiret
 #              DISPLAY g_qryparam.multiret TO azp01
 #              NEXT FIELD azp01
 #       END CASE
 
 #    ON ACTION about
 #       CALL cl_about()
 
 #    ON ACTION help
 #       CALL cl_show_help()
 
 #    ON ACTION controlg
 #       CALL cl_cmdask()
 
 #    ON ACTION exit
 #       LET INT_FLAG = 1
 #       EXIT CONSTRUCT
 
 #    ON ACTION qbe_select
 #       CALL cl_qbe_select()
 # END CONSTRUCT
 # LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 # IF g_action_choice = "locale" THEN
 #    LET g_action_choice = ""
 #    CALL cl_dynamic_locale()
 #    CONTINUE WHILE
 # END IF
 # IF INT_FLAG THEN
 #    LET INT_FLAG = 0
 #    CLOSE WINDOW r410_w
 #    CALL cl_used(g_prog,g_time,2) RETURNING g_time
 #    EXIT WHILE
 # END IF
 # IF tm.wc1 = " 1=1" THEN
 #    CALL cl_err('','9046',0)
 #    CONTINUE WHILE
 # END IF
 #FUN-A10098--mark--end 

   WHILE TRUE
     #QBE查詢條件2
      CONSTRUCT BY NAME tm.wc2 ON ima01,ima06,ima09,ima10,ima11,ima12,ima131
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlp
            CASE
              WHEN INFIELD(ima01)   #料件
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
              WHEN INFIELD(ima06)   #主分群碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_imz"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima06
                   NEXT FIELD ima06
              WHEN INFIELD(ima09)   #分群碼一
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "D"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima09
                   NEXT FIELD ima09
              WHEN INFIELD(ima10)   #分群碼二
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "E"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima10
                   NEXT FIELD ima10
              WHEN INFIELD(ima11)   #分群碼三
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "F"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima11
                   NEXT FIELD ima11
              WHEN INFIELD(ima12)   #分群碼四
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azf"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1  = "G"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima12
                   NEXT FIELD ima12
              WHEN INFIELD(ima131)  #產品分類
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_oba"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
            END CASE
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
      IF tm.wc2 = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   #INPUT BY NAME tm.s1,tm.t1,tm.u1,tm.yy,tm.mm,tm.tt,tm.ctype,tm.a,tm.b,tm.c,tm.d, #FUN-8C0116 #FUN-960053 add tm.tt#FUN-9C0170   #MOD-B70144 add tm.d  #CHI-C20002 mark
   INPUT BY NAME tm.s1,tm.t1,tm.u1,tm.yy,tm.mm,tm.tt,tm.ctype,tm.a,tm.c,tm.d, #CHI-C20002
                 tm.o,tm.a_curr,tm.t_curr,tm.rate,
                 tm.more,tm.p                                                 #FUN-A80110 add tm.p      
                #FUN-A10098--add--str--
                ,tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8
                #FUN-A10098--add--end
             WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         CALL r151_set_entry()
 
      AFTER FIELD s1
         IF cl_null(tm.s1) OR tm.s1 NOT MATCHES '[123456]' THEN
            NEXT FIELD s1
         END IF
 
      AFTER FIELD t1
         IF cl_null(tm.t1) OR tm.t1 NOT MATCHES '[YN]' THEN
            NEXT FIELD t1
         END IF
 
      AFTER FIELD u1
         IF cl_null(tm.u1) OR tm.u1 NOT MATCHES '[YN]' THEN
            NEXT FIELD u1
         END IF
 
      AFTER FIELD yy
         IF NOT cl_null(tm.yy) THEN
            IF tm.yy < 0 THEN
               CALL cl_err('','mfg5034',0)
               NEXT FIELD yy
            END IF
         END IF
 
      AFTER FIELD mm
         IF NOT cl_null(tm.mm) THEN
            IF tm.mm < 1 OR tm.mm > 12 THEN
               CALL cl_err('','aom-580',0)
               NEXT FIELD mm
            END IF
         END IF
 
      AFTER FIELD tt
         IF NOT cl_null(tm.tt) THEN
            IF tm.tt < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD tt
            END IF
         END IF
      
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
 
      ON CHANGE a
         #IF tm.a = 'N' THEN LET tm.b = 'N' END IF  #CHI-C20002
         #DISPLAY tm.b TO FORMONLY.b  #CHI-C20002
         CALL r151_set_entry()
      #CHI-C20002---begin mark
      #BEFORE FIELD b
      #   IF tm.a = 'N' THEN LET tm.b = 'N' END IF
      #   DISPLAY tm.b TO FORMONLY.b
      #   CALL r151_set_entry()
 
      #AFTER FIELD b
      #   IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
      #      NEXT FIELD b
      #   END IF
      #CHI-C20002---end
      AFTER FIELD o
         IF cl_null(tm.o) OR tm.o NOT MATCHES '[YN]' THEN
            NEXT FIELD o
         END IF
         CALL r151_set_entry()
 
      ON CHANGE o
         CALL r151_set_entry()
         IF tm.o = 'N' THEN
            LET tm.t_curr = tm.a_curr
            LET tm.rate = 1
            DISPLAY tm.t_curr TO FORMONLY.t_curr
            DISPLAY tm.rate TO FORMONLY.rate
            LET l_t_curr_o = tm.t_curr
         END IF
 
      BEFORE FIELD a_curr
         CALL r151_set_entry()
 
      AFTER FIELD a_curr
         IF NOT cl_null(tm.a_curr) THEN
            CALL r151_chk_azi(tm.a_curr) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD a_curr
            END IF
            IF tm.a_curr <> l_a_curr_o THEN
               LET tm.rate = s_exrate(tm.a_curr,tm.t_curr,l_exT)
               DISPLAY tm.rate TO FORMONLY.rate
            END IF
         END IF
         LET l_a_curr_o = tm.a_curr
 
      AFTER FIELD t_curr
         IF NOT cl_null(tm.t_curr) THEN
            CALL r151_chk_azi(tm.t_curr) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD t_curr
            END IF
            IF tm.t_curr <> l_t_curr_o THEN
               LET tm.rate = s_exrate(tm.a_curr,tm.t_curr,l_exT)
               DISPLAY tm.rate TO FORMONLY.rate
            END IF
         END IF
         LET l_t_curr_o = tm.t_curr

#FUN-A80110 --------------add start-----------------------      
      AFTER FIELD p
         IF cl_null(tm.p) OR tm.p NOT MATCHES '[YN]' THEN
            NEXT FIELD p
         END IF        
         CALL r151_set_entry()         

      ON CHANGE p
         CALL r151_set_entry()
#FUN-A80110 -------------add end------------------------

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #FUN-A10098--add--str--
      BEFORE FIELD plant_1
         LET tm.plant_1 = g_plant
         DISPLAY tm.plant_1 TO FORMONLY.plant_1
         IF g_multpl= 'N' THEN             # 不為多工廠環境
            LET tm.plant_1 = g_plant
            LET l_plant[1] = g_plant
            DISPLAY tm.plant_1 TO FORMONLY.plant_1
            EXIT INPUT
         END IF

      AFTER FIELD plant_1
         IF NOT cl_null(tm.plant_1) THEN
            IF NOT r151_chkplant(tm.plant_1) THEN
               CALL cl_err(tm.plant_1,g_errno,0)
               NEXT FIELD plant_1
            END IF
            LET l_plant[1] = tm.plant_1
            CALL s_chk_demo(g_user,tm.plant_1) RETURNING li_result
            IF not li_result THEN
               NEXT FIELD plant_1
            END IF
            SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1    #FUN-A70084
         END IF 

      AFTER FIELD plant_2
             LET tm.plant_2 = duplicate(tm.plant_2,1)  # 不使工廠編號重覆
             IF tm.plant_2 = g_plant  THEN
                LET l_plant[2] = tm.plant_2
                LET m_legal[2] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_2) THEN
                   IF NOT r151_chkplant(tm.plant_2) THEN
                      CALL cl_err(tm.plant_2,g_errno,0)
                      NEXT FIELD plant_2
                   END IF
                   LET l_plant[2] = tm.plant_2
                   SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.plant_2   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_2) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_2
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[2] = tm.plant_2
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_2) THEN
                IF NOT r151_chklegal(m_legal[2],1) THEN
                   CALL cl_err(tm.plant_2,g_errno,0)
                   NEXT FIELD plant_2
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_3
             LET tm.plant_3 = duplicate(tm.plant_3,2)  # 不使工廠編號重覆
             IF tm.plant_3 = g_plant  THEN
                LET l_plant[3] = tm.plant_3
                LET m_legal[3] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_3) THEN
                   IF NOT r151_chkplant(tm.plant_3) THEN
                      CALL cl_err(tm.plant_3,g_errno,0)
                      NEXT FIELD plant_3
                   END IF
                   LET l_plant[3] = tm.plant_3
                   SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.plant_3   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_3) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_3
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[3] = tm.plant_3
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_3) THEN
                IF NOT r151_chklegal(m_legal[3],2) THEN
                   CALL cl_err(tm.plant_3,g_errno,0)
                   NEXT FIELD plant_3
                END IF
             END IF
             #FUN-A70084--add--end


      AFTER FIELD plant_4
             LET tm.plant_4 = duplicate(tm.plant_4,3)  # 不使工廠編號重覆
             IF tm.plant_4 = g_plant  THEN
                LET l_plant[4] = tm.plant_4
                LET m_legal[4] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_4) THEN
                   IF NOT r151_chkplant(tm.plant_4) THEN
                      CALL cl_err(tm.plant_4,g_errno,0)
                      NEXT FIELD plant_4
                   END IF
                   LET l_plant[4] = tm.plant_4
                   SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.plant_4  #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_4) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_4
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[4] = tm.plant_4
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_4) THEN
                IF NOT r151_chklegal(m_legal[4],3) THEN
                   CALL cl_err(tm.plant_4,g_errno,0)
                   NEXT FIELD plant_4
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_5
             LET tm.plant_5 = duplicate(tm.plant_5,4)  # 不使工廠編號重覆
             IF tm.plant_5 = g_plant  THEN
                LET l_plant[5] = tm.plant_5
                LET m_legal[5] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_5) THEN
                   IF NOT r151_chkplant(tm.plant_5) THEN
                      CALL cl_err(tm.plant_5,g_errno,0)
                      NEXT FIELD plant_5
                   END IF
                   LET l_plant[5] = tm.plant_5
                   SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.plant_5  #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_5) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_5
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[5] = tm.plant_5
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_5) THEN
                IF NOT r151_chklegal(m_legal[5],4) THEN
                   CALL cl_err(tm.plant_5,g_errno,0)
                   NEXT FIELD plant_5
                END IF
             END IF
             #FUN-A70084--add--end

      AFTER FIELD plant_6
             LET tm.plant_6 = duplicate(tm.plant_6,5)  # 不使工廠編號重覆
             IF tm.plant_6 = g_plant  THEN
                LET l_plant[6] = tm.plant_6
                LET m_legal[6] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_6) THEN
                   IF NOT r151_chkplant(tm.plant_6) THEN
                      CALL cl_err(tm.plant_6,g_errno,0)
                      NEXT FIELD plant_6
                   END IF
                   LET l_plant[6] = tm.plant_6
                   SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.plant_6   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_6) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_6
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[6] = tm.plant_6
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_6) THEN
                IF NOT r151_chklegal(m_legal[6],5) THEN
                   CALL cl_err(tm.plant_6,g_errno,0)
                   NEXT FIELD plant_6
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_7
             LET tm.plant_7 = duplicate(tm.plant_7,6)  # 不使工廠編號重覆
             IF tm.plant_7 = g_plant  THEN
                LET l_plant[7] = tm.plant_7
                LET m_legal[7] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_7) THEN
                   IF NOT r151_chkplant(tm.plant_7) THEN
                      CALL cl_err(tm.plant_7,g_errno,0)
                      NEXT FIELD plant_7
                   END IF
                   LET l_plant[7] = tm.plant_7
                   SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.plant_7  #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_7) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_7
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[7] = tm.plant_7
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_7) THEN
                IF NOT r151_chklegal(m_legal[7],6) THEN
                   CALL cl_err(tm.plant_7,g_errno,0)
                   NEXT FIELD plant_7
                END IF
             END IF
             #FUN-A70084--add--end

  
      AFTER FIELD plant_8
             LET tm.plant_8 = duplicate(tm.plant_8,7)  # 不使工廠編號重覆
             IF tm.plant_8 = g_plant  THEN
                LET l_plant[8] = tm.plant_8
                LET m_legal[8] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_8) THEN
                   IF NOT r151_chkplant(tm.plant_8) THEN
                      CALL cl_err(tm.plant_8,g_errno,0)
                      NEXT FIELD plant_8
                   END IF
                   LET l_plant[8] = tm.plant_8
                   SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
                   CALL s_chk_demo(g_user,tm.plant_8) RETURNING li_result
                   IF not li_result THEN
                      NEXT FIELD plant_8
                   END IF
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET l_plant[8] = tm.plant_8
                END IF
             END IF     
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r151_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end
      #FUN-A10098--add--end
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #FUN-A10098--add--str--
         IF tm.p = 'Y' AND cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND  #FUN-A80110 add tm.p ='Y'
            cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
            cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
            cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt <=1 THEN   #FUN-A70084 add l_cnt<=1
            CALL cl_err(0,'aap-137',0)
            NEXT FIELD plant_1
         END IF
       #FUN-A70084--add--str--
        IF l_cnt >1 THEN
           LET g_k = 1
           LET l_plant[1] = g_plant
        ELSE
        #FUN-A70084--add--end 
           LET g_k=0
           FOR g_atot = 1  TO  8
               IF cl_null(l_plant[g_atot]) THEN
                  CONTINUE FOR
               END IF
               LET g_k=g_k+1
               LET g_tmp[g_k]=l_plant[g_atot]
           END FOR

           FOR g_atot = 1  TO 8
               IF  g_atot > g_k THEN
                   LET l_plant[g_atot]=NULL
               ELSE
                   LET l_plant[g_atot]=g_tmp[g_atot]
               END IF
           END FOR
         #FUN-A10098--add--end
        END IF     #FUN-A70084
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(a_curr)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azi"
                   LET g_qryparam.default1 = tm.a_curr
                   CALL cl_create_qry() RETURNING tm.a_curr
                   DISPLAY tm.a_curr TO FORMONLY.a_curr
              WHEN INFIELD(t_curr)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azi"
                   LET g_qryparam.default1 = tm.t_curr
                   CALL cl_create_qry() RETURNING tm.t_curr
                   DISPLAY tm.a_curr TO FORMONLY.t_curr
              #FUN-A10098--add--str--
              WHEN INFIELD(plant_1)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"  
                     LET g_qryparam.arg1 = g_user 
                     LET g_qryparam.default1 = tm.plant_1
                     CALL cl_create_qry() RETURNING tm.plant_1
                     DISPLAY BY NAME tm.plant_1
                     NEXT FIELD plant_1

                WHEN INFIELD(plant_2)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"  
                     LET g_qryparam.arg1 = g_user  
                     LET g_qryparam.default1 = tm.plant_2
                     CALL cl_create_qry() RETURNING tm.plant_2
                     DISPLAY BY NAME tm.plant_2
                     NEXT FIELD plant_2

                WHEN INFIELD(plant_3)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"  
                     LET g_qryparam.arg1 = g_user  
                     LET g_qryparam.default1 = tm.plant_3
                     CALL cl_create_qry() RETURNING tm.plant_3
                     DISPLAY BY NAME tm.plant_3
                     NEXT FIELD plant_3

                WHEN INFIELD(plant_4)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy" 
                     LET g_qryparam.arg1 = g_user 
                     LET g_qryparam.default1 = tm.plant_4
                     CALL cl_create_qry() RETURNING tm.plant_4
                     DISPLAY BY NAME tm.plant_4
                     NEXT FIELD plant_4

                WHEN INFIELD(plant_5)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy" 
                     LET g_qryparam.arg1 = g_user 
                     LET g_qryparam.default1 = tm.plant_5
                     CALL cl_create_qry() RETURNING tm.plant_5
                     DISPLAY BY NAME tm.plant_5
                     NEXT FIELD plant_5

                WHEN INFIELD(plant_6)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy" 
                     LET g_qryparam.arg1 = g_user 
                     LET g_qryparam.default1 = tm.plant_6
                     CALL cl_create_qry() RETURNING tm.plant_6
                     DISPLAY BY NAME tm.plant_6
                     NEXT FIELD plant_6

                WHEN INFIELD(plant_7)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy" 
                     LET g_qryparam.arg1 = g_user 
                     LET g_qryparam.default1 = tm.plant_7
                     CALL cl_create_qry() RETURNING tm.plant_7
                     DISPLAY BY NAME tm.plant_7
                     NEXT FIELD plant_7

                WHEN INFIELD(plant_8)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_zxy"
                     LET g_qryparam.arg1 = g_user
                     LET g_qryparam.default1 = tm.plant_8
                     CALL cl_create_qry() RETURNING tm.plant_8
                     DISPLAY BY NAME tm.plant_8
                     NEXT FIELD plant_8
              #FUN-A10098--add--end--
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
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
       WHERE zz01='axcr151'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axcr151','9031',1)
      ELSE
        #LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")   #FUN-A10098
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                        #" '",tm.wc1 CLIPPED,"'" ,  #FUN-A10098
                         " '",tm.wc2 CLIPPED,"'" ,
                         " '",tm.s1 CLIPPED,"'" ,
                         " '",tm.t1 CLIPPED,"'" ,
                         " '",tm.u1 CLIPPED,"'" ,
                         " '",tm.yy CLIPPED,"'" ,
                         " '",tm.mm CLIPPED,"'" ,
                         " '",tm.tt CLIPPED,"'" ,  #FUN-960053
                         " '",tm.a CLIPPED,"'" ,
                         #" '",tm.b CLIPPED,"'" ,  #CHI-C20002
                         " '",tm.o CLIPPED,"'" ,
                         " '",tm.a_curr CLIPPED,"'" ,
                         " '",tm.t_curr CLIPPED,"'" ,
                         " '",tm.rate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",tm.c CLIPPED,"'", #FUN-8C0116
                         " '",tm.ctype CLIPPED,"'" #FUN-9C0170
                        ," '",tm.p CLIPPED,"'"  #FUN-A80110 
                         #FUN-A10098--add--str--
                        ," '",l_plant[1] CLIPPED,"'",
                         " '",l_plant[2] CLIPPED,"'",
                         " '",l_plant[3] CLIPPED,"'",
                         " '",l_plant[4] CLIPPED,"'",
                         " '",l_plant[5] CLIPPED,"'",
                         " '",l_plant[6] CLIPPED,"'",
                         " '",l_plant[7] CLIPPED,"'",
                         " '",l_plant[8] CLIPPED,"'",    #MOD-B70144 add ,
                         #FUN-A10098--add--end
                         " '",tm.d CLIPPED,"'"           #MOD-B70144 add
         CALL cl_cmdat('axcr151',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r151_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r151()
   ERROR ""
 END WHILE
 CLOSE WINDOW r151_w
 
END FUNCTION
 
#====================================
# 欄位是否可輸入
#====================================
FUNCTION r151_set_entry()
 
   CALL cl_set_comp_entry("a_curr,t_curr,rate,b",TRUE)
   CALL cl_set_comp_entry("plant_1,plant_2,plant_3,plant_4,plant_5,plant_6,plant_7,plant_8",TRUE)   #FUN-A80110
   IF cl_null(tm.o) OR tm.o = 'N' THEN
      CALL cl_set_comp_entry("a_curr,t_curr,rate",FALSE)
   END IF
   #CHI-C20002---begin mark
   #IF cl_null(tm.a) OR tm.a = 'N' THEN
   #   CALL cl_set_comp_entry("b",FALSE)
   #END IF
   #CHI-C20002---END
#FUN-A80110  ------------add start----------------------------
   IF cl_null(tm.p) OR tm.p = 'N' THEN                  
      CALL cl_set_comp_entry("plant_1,plant_2,plant_3,plant_4,plant_5,plant_6,plant_7,plant_8",FALSE)
   END IF                                               
#FUN-A80110 ------------add end---------------------------------
  
END FUNCTION
 
#====================================
# 檢查幣別
#====================================
FUNCTION r151_chk_azi(p_azi01)
   DEFINE p_azi01         LIKE azi_file.azi01,
          l_aziacti       LIKE azi_file.aziacti
 
   LET g_errno = ''
 
   SELECT aziacti INTO l_aziacti FROM azi_file
    WHERE azi01 = p_azi01
   CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'axs-001'
        WHEN l_aziacti <> 'Y'       LET g_errno = '9028'
        OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '------'
   END CASE
END FUNCTION
 
#====================================
# 資料處理
#====================================
FUNCTION r151()
   DEFINE l_name      LIKE type_file.chr20,        # External(Disk) file name
          l_time      LIKE type_file.chr8,         # Used time for running the job
          l_sql       STRING,
          l_azp01     LIKE azp_file.azp01,        #營運中心代碼
          l_azp03     LIKE azp_file.azp03,        #資料庫代碼
          l_dbs_n     LIKE type_file.chr21,                #資料庫代碼(有含.)
          l_flag      LIKE type_file.num5,
          l_fac       LIKE ima_file.ima31_fac,
          l_tot       LIKE ccc_file.ccc92,        #By料號加總成本金額
          l_diff      LIKE ccc_file.ccc92,        #成本金額差異
          sr          RECORD
            order1    LIKE azp_file.azp01,        #營運中心
            order2    LIKE type_file.chr20,                #產品種類
            desc      LIKE type_file.chr50,                #產品種類_中文說明
            ccc01     LIKE ccc_file.ccc01,        #料號
            imk02     LIKE imk_file.imk02,        #倉庫別
            imk09     LIKE imk_file.imk09,        #數量
            ccc92     LIKE ccc_file.ccc92,        #本月結存金額
            ccc23     LIKE ccc_file.ccc23,        #成本單價
            cma25     LIKE cma_file.cma25,        #淨變現單價    #TQC-990129
            cma26     LIKE cma_file.cma26,        #巿價          #TQC-990129
            cma27     LIKE cma_file.cma27,        #參考單號      #TQC-990129
            cma28     LIKE cma_file.cma28,        #參考項次      #TQC-990129
            cma29     LIKE cma_file.cma29,        #逆推-成品料號 #TQC-990129
            amt       LIKE ccc_file.ccc92,        #成本金額
            amt_m     LIKE ccc_file.ccc92,        #淨變現價值
            amt_o     LIKE ccc_file.ccc92,        #個別項目
            amt_p     LIKE ccc_file.ccc92,        #備抵跌價損失
            amt_q     LIKE ccc_file.ccc92,        #備抵跌價利益
            cma32     LIKE cma_file.cma32,        #銷售費用率 #TQC-990129
            d_price   LIKE type_file.chr1,        #成品跌價否 #FUN-8C0116
            cma08     LIKE cma_file.cma08         #FUN-9C0170
                      END RECORD,
          sr1         RECORD
            ima06     LIKE ima_file.ima06,        #主分群碼
            ima09     LIKE ima_file.ima09,        #分群碼一
            ima10     LIKE ima_file.ima10,        #分群碼二
            ima11     LIKE ima_file.ima11,        #分群碼三
            ima12     LIKE ima_file.ima12,        #成本分群
            ima131    LIKE ima_file.ima131,       #產品分類
            ima25     LIKE ima_file.ima25,        #料件庫存單位
            imz02     LIKE imz_file.imz02,        #主分群碼說明
            oba02     LIKE oba_file.oba02,        #產品分類說明
            img09     LIKE img_file.img09         #倉儲批庫存單位
                      END RECORD
     DEFINE l_cma24   LIKE cma_file.cma24         #FUN-8C0116
     DEFINE l_cma29_c  LIKE cma_file.cma25         #FUN-8C0116
     DEFINE l_cma29_n  LIKE cma_file.cma25         #FUN-8C0116
     DEFINE l_cma291  LIKE cma_file.cma291        #逆推成品平均成本單價    #FUN-950058
     DEFINE l_cma292  LIKE cma_file.cma292        #逆推成品平均淨變現單價  #FUN-950058
     DEFINE l_cmc04   LIKE cmc_file.cmc04         #FUN-960053
     DEFINE l_plant_n LIKE type_file.chr10        #FUN-980020
     DEFINE l_correct LIKE type_file.chr1         #CHI-980067
     DEFINE l_bdate   LIKE type_file.dat          #CHI-980067
     DEFINE l_edate   LIKE type_file.dat          #CHI-980067
     DEFINE l_b1    STRING    #FUN-9C0170
     DEFINE l_b2    STRING    #FUN-9C0170
     DEFINE l_b3    STRING    #FUN-9C0170
     DEFINE l_i       LIKE type_file.num5         #No.FUN-A10098 
     DEFINE l_cmc04a  LIKE ccc_file.ccc92         #CHI-C20002
     
     CALL cl_del_data(l_table)
     
    # CALL cl_used(g_prog,l_time,1) RETURNING l_time              #FUN-B80056  MARK
     CALL cl_used(g_prog,g_time,1) RETURNING g_time               #FUN-B80056  ADD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   
     IF tm.p = 'Y' THEN                         #FUN-A80110 add
        IF tm.a = 'N' THEN
           LET l_name = 'axcr151_1'
        ELSE
           #IF tm.b= 'Y' THEN            #CHI-C20002
           #   LET l_name = 'axcr151'    #CHI-C20002
           #ELSE                         #CHI-C20002
              LET l_name = 'axcr151_2'
           #END IF                       #CHI-C20002
        END IF
#FUN-A80110 -----add start-----------------
     ELSE
        IF tm.a = 'N' THEN
           LET l_name = 'axcr151_4'
        ELSE
           #IF tm.b= 'Y' THEN            #CHI-C20002
           #   LET l_name = 'axcr151_3'  #CHI-C20002
           #ELSE                         #CHI-C20002
              LET l_name = 'axcr151_5'
           #END IF                       #CHI-C20002
        END IF
     END IF 
#FUN-A80110 ----add end-------------------
     SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05
       FROM azi_file
      WHERE azi01 = tm.t_curr
    
     CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_bdate, l_edate #CHI-980067
 
    #FUN-A10098--mod--str--
    #LET l_sql = "SELECT azp01,azp03 FROM azp_file ",
    #            " WHERE ", tm.wc1 CLIPPED
    #PREPARE r151_pre1 FROM l_sql
    #IF SQLCA.sqlcode != 0 THEN
    #   CALL cl_err('r151_pre1:',SQLCA.sqlcode,1)
    #   EXIT PROGRAM
    #END IF
    #DECLARE r151_cs1 CURSOR FOR r151_pre1
    #FOREACH r151_cs1 INTO l_azp01,l_azp03
    #   IF SQLCA.SQLCODE THEN
    #      CALL cl_err('FOREACH r151_cs1:',SQLCA.SQLCODE,0)
    #      EXIT FOREACH
    #   END IF
    #   LET l_plant_n = l_azp01               #FUN-980020
    #   LET l_dbs_n = s_dbstring(l_azp03 CLIPPED)
     LET l_i = 1
     FOR l_i = 1 TO g_k     #g_k的值為實際的資料庫數目
        IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
    #FUN-A10098--mod--end
        LET l_sql = "SELECT '','','',",
                    "       ccc01,'',ccc91,ccc92,ccc23,",    #FUN-950058
                    "       cma25,cma26,cma27,cma28,cma29,", #FUN-8B0047
                    "       0,0,0,0,0,cma32,'',cma08,", #FUN-8B0047 #FUN-8C0116 #FUN-9C0170
                    "       ima06,ima09,ima10,ima11,ima12,ima131,ima25,",
                    "       imz02,oba02,'',cma24,cma291,cma292 ", #FUN-8C0116  #FUN-950058
#FUN-A10098--mod--str--
#"  FROM ",l_dbs_n CLIPPED, "ccc_file LEFT OUTER JOIN ",l_dbs_n CLIPPED, "cma_file ON ccc01 = cma01 AND ccc02 = cma021 AND ccc07=cma07 AND ccc08=cma08 AND ccc03 = cma022 ,", #FUN-9C0170
#"       ",l_dbs_n CLIPPED, "ima_file LEFT OUTER JOIN ",l_dbs_n CLIPPED, "imz_file ON ima06 = imz01 ",
#"                                    LEFT OUTER JOIN ",l_dbs_n CLIPPED, "oba_file ON ima131= oba01 ",
 "  FROM ",cl_get_target_table(l_plant[l_i],'ccc_file'),
 "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'cma_file')," ON ccc01 = cma01 AND ccc02 = cma021  AND ccc07=cma07 AND ccc08=cma08 AND ccc03 = cma022 ,",
           cl_get_target_table(l_plant[l_i],'ima_file'),
 "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'imz_file')," ON ima06 = imz01 ",
 "  LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'oba_file')," ON ima131= oba01 ",
#FUN-A10098--mod--end
                    " WHERE ccc01 = ima_file.ima01 ",
                    "   AND ccc02 = ", tm.yy,
                    "   AND ccc03 = ", tm.mm,
                    "   AND ccc07 = '",tm.ctype,"' ",  #FUN-9C0170
                    "   AND ccc91 != 0 " ,    #FUN-950058
                    "   AND ", tm.wc2 CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       #CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
        PREPARE r151_pre2 FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('r151_pre2:',SQLCA.sqlcode,1)
          #EXIT FOREACH     #FUN-A10098
           EXIT FOR         #FUN-A10098
        END IF
        DECLARE r151_cs2 CURSOR FOR r151_pre2
        FOREACH r151_cs2 INTO sr.*,sr1.*,l_cma24,l_cma291,l_cma292 #FUN-8C0116  #FUN-950058
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('FOREACH r151_cs2:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF sr.ccc01 IS NULL THEN LET sr.ccc01 = 0 END IF
           IF sr.imk09 IS NULL THEN LET sr.imk09 = 0 END IF
           IF sr.ccc23 IS NULL THEN LET sr.ccc23 = 0 END IF
           IF sr.cma25 IS NULL THEN LET sr.cma25 = 0 END IF  #TQC-990129
           IF sr.cma26 IS NULL THEN LET sr.cma26 = 0 END IF  #TQC-990129
           IF sr.cma28 IS NULL THEN LET sr.cma28 = 0 END IF  #TQC-990129
           IF sr.amt IS NULL THEN LET sr.amt = 0 END IF
           IF sr.amt_m IS NULL THEN LET sr.amt_m = 0 END IF
           IF sr.amt_o IS NULL THEN LET sr.amt_o = 0 END IF
           IF sr.amt_p IS NULL THEN LET sr.amt_p = 0 END IF
           IF sr.amt_q IS NULL THEN LET sr.amt_q = 0 END IF
           IF sr.cma32 IS NULL THEN LET sr.cma32 = 0 END IF  #TQC-990129
           IF NOT cl_null(tm.tt) THEN
           #MOD-B70144 --- modify --- start ---
              IF tm.d = '2' THEN
                 LET l_cmc04 = 0
                 SELECT SUM(cma15) INTO l_cmc04 FROM cma_file
                 #WHERE cma16 < l_edate - tm.tt    #MOD-BB0286 mark
                  WHERE cma16 <= l_edate - tm.tt   #MOD-BB0286
                    AND cma01 = sr.ccc01
                    AND cma021 = tm.yy
                    AND cma022 = tm.mm
                 IF cl_null(l_cmc04) THEN LET l_cmc04 = 0 END IF
                 #LET sr.imk09 = sr.imk09 - l_cmc04    #CHI-C20002 mark
                 IF sr.imk09 = 0 THEN CONTINUE FOREACH END IF
              ELSE
                 LET l_cmc04 = 0
           #MOD-B70144 --- modify ---  end  ---
                 SELECT SUM(cmc04) INTO l_cmc04 FROM cmc_file
                 #WHERE cmc03 < l_edate - tm.tt #CHI-980067   #MOD-BB0286 mark
                  WHERE cmc03 <= l_edate - tm.tt              #MOD-BB0286
                    AND cmc01 = sr.ccc01
                    AND cmc021 = tm.yy
                    AND cmc022 = tm.mm
                 IF cl_null(l_cmc04) THEN LET l_cmc04 = 0 END IF
                 #LET sr.imk09 = sr.imk09 - l_cmc04    #CHI-C20002
                 IF sr.imk09 = 0 THEN CONTINUE FOREACH END IF   #MOD-B70144 add
              END IF                                            #MOD-B70144 add
           END IF
           
           SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.t_curr 
           
          #本月結存金額
           LET sr.ccc92 = sr.ccc92 * tm.rate
          #LET sr.ccc92 = cl_digcut(sr.ccc92,g_azi04)        #CHI-990002
          #成本單價
           IF sr.ccc23 IS NULL THEN LET sr.ccc23 = 0 END IF
           LET sr.ccc23 = sr.ccc23 * tm.rate
          #LET sr.ccc23 = cl_digcut(sr.ccc23,g_azi03)        #CHI-990002
          #淨變現單價 
           IF sr.cma25 IS NULL THEN LET sr.cma25 = 0 END IF  #TQC-990129
           LET sr.cma25 = sr.cma25 * tm.rate                 #TQC-990129
          #LET sr.cmd05 = cl_digcut(sr.cmd05,g_azi03)        #CHI-990002
          #市價
           LET sr.cma26 = sr.cma26 * tm.rate                 #TQC-990129
          #LET sr.cmd06 = cl_digcut(sr.cmd06,g_azi03)        #CHI-990002
          #營運中心
          #LET sr.order1 = l_azp01     #FUN-A10098
           LET sr.order1 = l_plant[l_i]   #FUN-A10098
           CASE tm.s1
               WHEN '1'
                    LET sr.order2 = sr1.ima06
                    LET sr.desc = sr1.imz02
               WHEN '2'
                    LET sr.order2 = sr1.ima09
                    #CALL r151_get_azf03(l_dbs_n,sr1.ima09,'D') RETURNING sr.desc   #FUN-A10098
                    CALL r151_get_azf03(l_plant[l_i],sr1.ima09,'D') RETURNING sr.desc   #FUN-A10098
               WHEN '3'
                    LET sr.order2 = sr1.ima10
                    #CALL r151_get_azf03(l_dbs_n,sr1.ima10,'E') RETURNING sr.desc   #FUN-A10098
                    CALL r151_get_azf03(l_plant[l_i],sr1.ima10,'E') RETURNING sr.desc   #FUN-A10098
               WHEN '4'
                    LET sr.order2 = sr1.ima11
                    #CALL r151_get_azf03(l_dbs_n,sr1.ima11,'F') RETURNING sr.desc   #FUN-A10098
                    CALL r151_get_azf03(l_plant[l_i],sr1.ima11,'F') RETURNING sr.desc   #FUN-A10098
               WHEN '5'
                    LET sr.order2 = sr1.ima12
                    #CALL r151_get_azf03(l_dbs_n,sr1.ima12,'G') RETURNING sr.desc   #FUN-A10098
                    CALL r151_get_azf03(l_plant[l_i],sr1.ima12,'G') RETURNING sr.desc   #FUN-A10098
               WHEN '6'
                    LET sr.order2 = sr1.ima131
                    LET sr.desc = sr1.oba02
           END CASE
           MESSAGE sr.order1 CLIPPED, ' / ', sr.order2 CLIPPED 
           CALL ui.Interface.refresh()
           #CHI-C20002---begin mark
           #IF tm.b = 'Y' THEN
           #   LET l_tot = 0
           #   LET l_diff = 0
           #   LET l_sql =""  #FUN-9C0170
           #   IF tm.ctype MATCHES '[124]' THEN  #FUN-9C0170
           #      LET l_sql = "SELECT imk02,imk09,img09",
           #                 #FUN-A10098--mod--str--
           #                 #"  FROM ", l_dbs_n CLIPPED, "imk_file ",
           #                 #" LEFT OUTER JOIN ", l_dbs_n CLIPPED, "img_file ON imk01 = img01 AND imk02 = img02 AND imk03 = img03 AND imk04 = img04",
           #                  "  FROM ",cl_get_target_table(l_plant[l_i],'imk_file'),
           #                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'img_file'),
           #                  "                   ON imk01 = img01 AND imk02 = img02 AND imk03 =img03 AND imk04 = img04",
           #                 #FUN-A10098--mod--end
           #                  "   WHERE imk01 = '", sr.ccc01, "' " #FUN-9C0170
           #   ELSE
           #      LET l_sql = "SELECT imk02,imk09,img09",
           #                 #FUN-A10098--mod--str--
           #                 #"  FROM ", l_dbs_n CLIPPED, "imd_file,",
           #                 #"       ", l_dbs_n CLIPPED, "imk_file ",
           #                 #" LEFT OUTER JOIN ", l_dbs_n CLIPPED, "img_file ON imk01 = img01 AND imk02 = img02 AND imk03 = img03 AND imk04 = img04",
           #                  "  FROM ",cl_get_target_table(l_plant[l_i],'imd_file'),",",
           #                            cl_get_target_table(l_plant[l_i],'imk_file'),
           #                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant[l_i],'img_file'),
           #                  "      ON imk01 = img01 AND imk02 = img02 AND imk03 =img03 AND imk04 = img04",
           #                 #FUN-A10098--mod--end
           #                  "   WHERE imk01 = '", sr.ccc01, "' "
           #   END IF
	       #   LET l_b1 =  "   imk05 = ", tm.yy,  #FUN-9C0170
           #               "   AND imk06 = ", tm.mm,
           #              # 排除非成本倉 且庫存為0的倉庫
           #               "   AND imk02 NOT IN (SELECT jce02 FROM jce_file) ",  
           #               "   AND imk09 != 0 ",
           #              # 排除非成本倉
           #               "   AND imk02 NOT IN (SELECT cmw01 FROM cmw_file) "  #FUN-930100
           #  LET l_b2 = "  imd01 = imk02 AND imd09 = '",sr.cma08,"'"
           #  LET l_b3 = "  imd01 = imk02 AND imk04 = '",sr.cma08,"'"
           #  IF tm.ctype MATCHES '[124]' THEN
           #     LET l_sql = l_sql,"AND",l_b1
           #  END IF
           #  IF tm.ctype = '5' THEN
           #     LET l_sql = l_sql,"AND",l_b1,"AND",l_b2
           #  END IF
           #  IF tm.ctype = '3' THEN
           #     LET l_sql = l_sql,"AND",l_b1,"AND",l_b3
           #  END IF
      	   #  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           #  #CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
           #   PREPARE r151_imk_p1 FROM l_sql
           #   DECLARE r151_imk_cs1 CURSOR FOR r151_imk_p1
           #   FOREACH r151_imk_cs1 INTO sr.imk02,sr.imk09,sr1.img09
           #      IF SQLCA.SQLCODE THEN
           #         CALL cl_err('FOREACH r151_imk_cs1:',SQLCA.SQLCODE,1)
           #         EXIT FOREACH
           #      END IF
           #      IF sr.imk09 IS NULL THEN LET sr.imk09 = 0 END IF
           #      IF NOT cl_null(tm.tt) THEN
           #        #MOD-B70144 --- modify --- start ---
           #         IF tm.d = '2' THEN
           #            LET l_cmc04 = 0
           #            SELECT SUM(cma15) INTO l_cmc04 FROM cma_file
           #            #WHERE cma16 < l_edate - tm.tt   #MOD-BB0286 mark
           #             WHERE cma16 <= l_edate - tm.tt  #MOD-BB0286
           #               AND cma01 = sr.ccc01
           #               AND cma021 = tm.yy
           #               AND cma022 = tm.mm
           #            IF cl_null(l_cmc04) THEN LET l_cmc04 = 0 END IF
           #            #LET sr.imk09 = sr.imk09 - l_cmc04   #CHI-C20002
           #            IF sr.imk09 = 0 THEN CONTINUE FOREACH END IF
           #         ELSE
           #            LET l_cmc04 = 0
           #        #MOD-B70144 --- modify ---  end  ---
           #            SELECT SUM(cmc04) INTO l_cmc04 FROM cmc_file
           #            #WHERE cmc03 < l_edate - tm.tt  #CHI-980067   #MOD-BB0286 mark
           #             WHERE cmc03 <= l_edate - tm.tt               #MOD-BB0286 
           #               AND cmc01 = sr.ccc01
           #               AND cmc021 = tm.yy
           #               AND cmc022 = tm.mm
           #            IF cl_null(l_cmc04) THEN LET l_cmc04 = 0 END IF
           #            #LET sr.imk09 = sr.imk09 - l_cmc04   #CHI-C20002
           #            IF sr.imk09 = 0 THEN CONTINUE FOREACH END IF   #MOD-B70144 add
           #         END IF                                            #MOD-B70144 add
           #      END IF
           #      IF cl_null(l_cmc04) THEN LET l_cmc04 = 0 END IF  #CHI-C20002
           #     #取得單位換算率
           #      IF NOT(sr1.img09 = sr1.ima25) THEN
           #         CALL s_umfchkm(sr.ccc01,sr1.img09,sr1.ima25,l_plant_n)   #FUN-980020
           #              RETURNING l_flag,l_fac
           #         IF l_flag THEN
           #            LET l_fac = 0
           #         END IF
           #         LET sr.imk09 = sr.imk09 * l_fac
           #         LET l_cmc04  = l_cmc04 * l_fac  #CHI-C20002
           #      END IF
           #      LET l_cmc04 = l_cmc04 * -1  #CHI-C20002
           #     #成本金額
           #      LET sr.amt = sr.ccc23 * sr.imk09
           #     #LET sr.amt = cl_digcut(sr.amt,g_azi04)  #CHI-990002
           #     #淨變現價值
           #      LET sr.amt_m = sr.imk09 * sr.cma25      #TQC-990129
           #     #LET sr.amt_m = cl_digcut(sr.amt_m,g_azi04)  #CHI-990002
           #      LET sr.d_price=NULL #FUN-8C0116 kim add
           #     #個別項目,備抵跌價損失,備抵跌價利益
           #      LET sr.amt_o = 0 
           #      LET sr.amt_p = 0 
           #      LET sr.amt_q = 0 
           #      IF sr.amt > sr.amt_m THEN
           #         LET sr.amt_o = sr.amt_m
           #         LET sr.amt_p = sr.amt_m - sr.amt
           #         IF l_cma24='3' AND NOT cl_null(sr.cma29) THEN #TQC-990129
           #            LET l_cma29_c=0
           #            LET l_cma29_n=0
           #            IF sr.cma29 = 'AVG' THEN     #TQC-990129
           #               LET l_cma29_c = l_cma291
           #               LET l_cma29_n = l_cma292
           #            ELSE
           #            SELECT cma14,cma25 INTO l_cma29_c,l_cma29_n
           #              FROM cma_file 
           #             WHERE cma01=sr.cma29 #TQC-990129
           #               AND cma021=tm.yy
           #               AND cma022=tm.mm
           #            END IF
           #            IF cl_null(l_cma29_c) THEN LET l_cma29_c=0 END IF
           #            IF cl_null(l_cma29_n) THEN LET l_cma29_n=0 END IF
           #            IF l_cma29_c < l_cma29_n THEN
           #               LET sr.d_price='N'
           #               LET sr.amt_o = 0
           #               LET sr.amt_p = 0
           #            END IF
           #         END IF
           #         LET sr.amt_q  = 0    #No.MOD-930027 add
           #      ELSE
           #         IF l_cma24='3' AND tm.c='N' THEN #FUN-8C0116
           #            CONTINUE FOREACH #FUN-8C0116
           #         END IF #FUN-8C0116
           #         LET sr.amt_o = sr.amt
           #         LET sr.amt_q = sr.amt_m - sr.amt
           #         LET sr.amt_p  = 0    #No.MOD-930027 add
           #      END IF
           #         
           #      IF (NOT cl_null(sr.cma29)) AND (cl_null(sr.d_price)) THEN  #FUN-8C0116 kim add #TQC-990129
           #         IF sr.amt_p < 0 THEN                    
           #            LET sr.d_price='Y'
           #         ELSE
           #            LET sr.d_price='N'
           #         END IF
           #      END IF
           #      LET l_tot = l_tot + sr.amt
           #      LET sr.imk09 = cl_digcut(sr.imk09,g_ccz.ccz27)    #MOD-C30032
           #      EXECUTE insert_prep USING sr.*,t_azi07,l_cma24,l_cmc04   #FUN-930100  #CHI-C20002
           #   END FOREACH
           #ELSE
           #CHI-C20002---end
             #成本金額
              LET l_outimk09 = 0
              LET l_sql = "SELECT sum(imk09) ",
                          #"  FROM ", l_dbs_n CLIPPED, "imk_file ",   #FUN-A10098
                          "  FROM ",cl_get_target_table(l_plant[l_i],'imk_file'),   #FUN-A10098
                          " WHERE imk01 = '", sr.ccc01, "' ",
                          "   AND imk05 = ", tm.yy,
                          "   AND imk06 = ", tm.mm,
                          " AND imk02 IN (SELECT cmw01 FROM ",
                          " cmw_file WHERE cmw01=imk02) ",
                          " AND NOT EXISTS (SELECT jce02 FROM jce_file ",
                          " WHERE jce02=imk02) " 
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             #CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
              PREPARE r151_pre3 FROM l_sql
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('r151_pre3:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              DECLARE r151_cs3 CURSOR FOR r151_pre3
              FOREACH r151_cs3 INTO l_outimk09
                 EXIT FOREACH
              END FOREACH
              IF cl_null(l_outimk09) THEN
                 LET l_outimk09 = 0
              END IF
              IF l_outimk09 <> 0 THEN 
                 LET sr.imk09 = sr.imk09 - l_outimk09
                 LET sr.amt = sr.ccc23 * sr.imk09
              ELSE
                 LET sr.amt = sr.ccc23 * sr.imk09   #TQC-970117
              END IF   #FUN-950058
              IF sr.imk09 = 0 THEN CONTINUE FOREACH END IF   #MOD-C20080 add
             #LET sr.amt = cl_digcut(sr.amt,g_azi04)  #CHI-990002
             #淨變現價值
              LET sr.amt_m = sr.imk09 * sr.cma25 #TQC-910009 mark  #FUN-950058 解除mark #TQC-990129
             #LET sr.amt_m= cl_digcut(sr.amt_m,g_azi04) #CHI-990002
              LET sr.d_price=NULL #FUN-8C0116
             #個別項目,備抵跌價損失,備抵跌價利益
              LET sr.amt_o = 0 
              LET sr.amt_p = 0 
              LET sr.amt_q = 0 
              IF sr.amt > sr.amt_m THEN
                 LET sr.amt_o = sr.amt_m
                 LET sr.amt_p = sr.amt_m - sr.amt
                 IF l_cma24='3' AND NOT cl_null(sr.cma29) THEN #TQC-990129
                    LET l_cma29_c=0
                    LET l_cma29_n=0
                    IF sr.cma29 = 'AVG' THEN    #TQC-990129
                       LET l_cma29_c = l_cma291
                       LET l_cma29_n = l_cma292
                    ELSE
                    SELECT cma14,cma25 INTO l_cma29_c,l_cma29_n
                      FROM cma_file 
                     WHERE cma01=sr.cma29  #TQC-990129
                       AND cma021=tm.yy
                       AND cma022=tm.mm
                    END IF
                    IF cl_null(l_cma29_c) THEN LET l_cma29_c=0 END IF
                    IF cl_null(l_cma29_n) THEN LET l_cma29_n=0 END IF
                    IF l_cma29_c < l_cma29_n THEN
                       LET sr.d_price='N'
                       LET sr.amt_o = 0
                       LET sr.amt_p = 0
                    END IF
                 END IF
                 LET sr.amt_q  = 0    #No.MOD-930027 add
              ELSE
                 LET sr.amt_o = sr.amt
                 LET sr.amt_q = sr.amt_m - sr.amt
                 LET sr.amt_p  = 0    #No.MOD-930027 add
                 IF l_cma24='3' AND tm.c='N' THEN #FUN-8C0116
                    CONTINUE FOREACH #FUN-8C0116
                 END IF #FUN-8C0116
              END IF
              IF (NOT cl_null(sr.cma29)) AND (cl_null(sr.d_price)) THEN  #FUN-8C0116 kim add #TQC-990129
                 IF sr.amt_p < 0 THEN                    
                    LET sr.d_price='Y'
                 ELSE
                    LET sr.d_price='N'
                 END IF
              END IF
              LET sr.imk09 = cl_digcut(sr.imk09,g_ccz.ccz27)        #MOD-C30032
              IF cl_null(l_cmc04) THEN LET l_cmc04 = 0 END IF       #CHI-C20002
              LET l_cmc04a = l_cmc04 * sr.ccc23                     #CHI-C20002
              EXECUTE insert_prep USING sr.*,t_azi07,l_cma24,l_cmc04,l_cmc04a #FUN-930100  #CHI-C20002
           #END IF   #CHI-C20002
        END FOREACH
    #END FOREACH   #FUN-A10098
    END FOR    #FUN-A10098
    
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
   #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
      #CALL cl_wcchp(tm.wc1,'azp01,ima01,ima06,ima09,ima10,ima11,ima12,ima131')   #FUN-A10098
       CALL cl_wcchp(tm.wc2,'ima01,ima06,ima09,ima10,ima11,ima12,ima131')   #FUN-A10098
         RETURNING g_str
    END IF
    #LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.t_curr,";",tm.rate,";",g_azi03     #CHI-C30012
    LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.t_curr,";",tm.rate,";",g_ccz.ccz26  #CHI-C30012
                #,";",g_azi04,";",tm.a,";",tm.b,";",tm.t1,";",tm.u1,";",tm.ctype,";",tm.p,";",g_ccz.ccz27  #FUN-9C0170   #FUN-A80110 add tm.p  #MOD-C30032 add g_ccz.ccz27 #CHI-C20002 mark
                #,";",g_azi04,";",tm.a,";",'',";",tm.t1,";",tm.u1,";",tm.ctype,";",tm.p,";",g_ccz.ccz27    #CHI-C20002 #CHI-C30012
                ,";",g_ccz.ccz26,";",tm.a,";",'',";",tm.t1,";",tm.u1,";",tm.ctype,";",tm.p,";",g_ccz.ccz27 #CHI-C30012
    CALL cl_prt_cs3('axcr151',l_name,l_sql,g_str)   
END FUNCTION
 
#====================================
# 取得azf03
#====================================
#FUNCTION r151_get_azf03(p_dbs,p_azf01,p_azf02)   #FUN-A10098
FUNCTION r151_get_azf03(p_plant,p_azf01,p_azf02)   #FUN-A10098
   DEFINE p_dbs       VARCHAR(21)
   DEFINE p_azf01     LIKE azf_file.azf01
   DEFINE p_azf02     LIKE azf_file.azf02
   DEFINE l_sql       STRING
   DEFINE l_azf03     LIKE azf_file.azf03
   DEFINE p_plant     LIKE azf_file.azf01   #FUN-A10098 

   #LET l_sql = "SELECT azf03 FROM ", p_dbs CLIPPED, "azf_file ",   #FUN-A10098
    LET l_sql = "SELECT azf03 FROM ",cl_get_target_table(p_plant,'azf_file'),  #FUN-A10098
               " WHERE azf01 = '", p_azf01, "' ",
               "   AND azf02 = '", p_azf02, "' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
  #CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A10098  #TQC-BB0182 mark
   PREPARE r151_azf_p1 FROM l_sql
   DECLARE r151_azf_cs1 CURSOR FOR r151_azf_p1
   OPEN r151_azf_cs1
   FETCH r151_azf_cs1 INTO l_azf03
   RETURN l_azf03
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18

#FUN-A10098--add--str--
FUNCTION r151_chkplant(l_plant)
   DEFINE l_plant     LIKE azp_file.azp01

   SELECT azp01 FROM azp_file
    WHERE azp01 = l_plant
   IF SQLCA.SQLCODE THEN
      LET g_errno='aom-300'
      RETURN 0
   ELSE
      RETURN 1
   END IF
END FUNCTION

FUNCTION duplicate(li_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE li_plant     LIKE azp_file.azp01
   DEFINE l_idx,n      LIKE type_file.num10  

   FOR l_idx = 1 TO n
       IF l_plant[l_idx] = li_plant THEN
          LET li_plant = ''
       END IF
   END FOR
   RETURN li_plant
END FUNCTION
#FUN-A10098--add--end 
#FUN-A70084--add--str--
FUNCTION r151_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("gb14",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r151_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF
   END FOR
   RETURN 1
END FUNCTION
#FUN-A70084--add--end
