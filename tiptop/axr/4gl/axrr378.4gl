# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: axrr378.4gl
# Descriptions...: 銷貨收入明細表
# Date & Author..: 98/12/23 By Billy
# Modify.........: 02/01/23 By faith
# Modify.........: No.9579 04/07/13 ching 改為 omb04[1,4] <> 'MISC'
# Modify.........: No.FUN-4C0100 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-550071 05/05/27 By yoyo單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-560191 05/07/07 By Nicola 沒有算到銷退待抵的金額
# Modify.........: No.FUN-570244 05/07/22 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.FUN-580010 05/08/10 By will 報表轉XML格式
# Modify.........: No.MOD-5A0397 05/10/26 By Echo 資料對齊不正確
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5B0139 05/12/05 By ice 有發票待扺時,報表應負值呈現對應的待扺資料
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-670093 06/07/21 By Smapmin 顯示出貨日期
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.MOD-6A0095 06/11/28 By Smapmin 單價變為正值.數量變為負值
# Modify.........: No.TQC-6A0049 06/11/28 By Smapmin 畫面條件由ogb04改為omb04
# Modify.........: No.TQC-6B0007 06/12/11 By johnray 報表修改
# Modify.........: No.MOD-720047 07/03/06 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.CHI-760014 07/06/13 By jamie 1. oma00 條件調整為 in ('11','12','13') 
#                                                  2. 原報表欄位"類別"(顯示內外銷)改為"銷售碼";新增"類別"欄位則顯示為目前oma00(帳款類別)中文資料放置於"銷售碼"後面 bydido
#                                                  3. omb16(本幣金額) 當 oma00 = '11'(訂金)時  omb16 * (oma161/100)  -> 依 g_azi04 取位
#                                                                     當 oma00 = '12'(出貨)時  omb16 * (oma162/100)  -> 依 g_azi04 取位
#                                                                     當 oma00 = '13'(尾款)時  omb16 * (oma163/100)  -> 依 g_azi04 取位
#                                                  4. omb14(原幣金額) 當 oma00 = '11'(訂金)時  omb14 * (oma161/100)  -> 依 t_azi04 取位
#                                                                     當 oma00 = '12'(出貨)時  omb14 * (oma162/100)  -> 依 t_azi04 取位
#                                                                     當 oma00 = '13'(尾款)時  omb14 * (oma163/100)  -> 依 t_azi04 取位
#                                                  5. omb16t-omb16(稅額) = 當 oma00 = '11'(訂金)時  omb16t * (oma161/100)  -> 依 g_azi04 取位
#                                                                          當 oma00 = '12'(出貨)時  omb16t * (oma162/100)  -> 依 g_azi04 取位
#                                                  2.3.4.5.均改在rpt檔 修改的公式欄位是omb16_after、omb14_after、omb16t-omb16 
# Modify.........: No.MOD-7B0051 07/11/07 By Smapmin 金額欄位皆為0.幣別取位不正確 
# Modify.........: No.MOD-7B0142 07/11/15 By Smapmin 納入銷退資料
# Modify.........: No.CHI-850016 08/05/12 By Smapmin 增加訂金認列銷貨收入選項
# Modify.........: No.MOD-860260 08/07/04 By Sarah 報表增加omb05,群組以原先的欄位加上omb05為新群組來做加總
# Modify.........: No.MOD-870260 08/07/23 By Sarah 報表增加azi07,匯率(oma24)以azi07取位
# Modify.........: No.MOD-880001 08/08/06 By Sarah 當tm.c='Y'時,oma00條件不應包含'13'
# Modify.........: No.FUN-8C0019 08/12/11 By jan 提供INPUT加上關系人與營運中心
# Modify.........: No.MOD-930278 09/03/27 By chenl 調整sql語句。
# Modify.........: No.MOD-930324 09/03/31 By Sarah l_sql沒有加上tm.wc
# Modify.........: No.MOD-940138 09/04/10 By Sarah 修正FUN-8C0019沒抓到azi07問題
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-940013 09/04/30 By jan oma03,oma18 欄位增加開窗功能 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:MOD-B50224 11/05/26 BY Dido FOREACH 內的 DECLARE 移至前面宣告 
# Modify.........: No:CHI-B60008 11/07/01 BY Dido 效能改善架構調整 
# Modify.........: No:FUN-BB0173 12/01/13 by pauline 增加跨法人抓取資料 
# Modify.........: No:MOD-C40029 12/04/05 By Polly 調整小計總計依幣別取位
# Modify.........: No:MOD-CC0063 12/12/10 By Polly 將訂創認列銷貨收入tm.c預設值改為N

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition #No.FUN-680123 VARCHAR(1000)
              bdate   LIKE type_file.dat,           #No.FUN-680123 DATE
              edate   LIKE type_file.dat,           #No.FUN-680123 DATE
              b       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
              c       LIKE type_file.chr1,          #CHI-850016
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#             d       LIKE type_file.chr1,          #No.FUN-8C0019
              type    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
              sort    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
#              p1      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
#              p2      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10) 
#              p3      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
#              p4      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
#              p5      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
#              p6      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
#              p7      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
#              p8      LIKE azp_file.azp01,          #No.FUN-680123 VARCHAR(10)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
            #FUN-BB0173 add START
              plant_1 LIKE azw_file.azw01,
              plant_2 LIKE azw_file.azw01,
              plant_3 LIKE azw_file.azw01,
              plant_4 LIKE azw_file.azw01,
              plant_5 LIKE azw_file.azw01,
              plant_6 LIKE azw_file.azw01,
              plant_7 LIKE azw_file.azw01,
              plant_8 LIKE azw_file.azw01,
            #FUN-BB0173 add END
              more    LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)  # Input more condition(Y/N)
              END RECORD,
          g_yy,g_mm     LIKE type_file.num5,                 #No.FUN-680123 SMALLINT
          m_dbs         ARRAY[10] OF LIKE type_file.chr20    #No.FUN-680123 ARRAY[10] OF VARCHAR(20)
     DEFINE   g_title LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(160)
     DEFINE   g_amt   LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
              t_rate  LIKE ima_file.ima18           #No.FUN-680123 DEC(9,3)
                     
DEFINE    g_cnt           LIKE type_file.num10      #No.FUN-680123 INTEGER
DEFINE    g_head1         LIKE type_file.chr1000    #Dash line #No.FUN-680123 VARCHAR(100)
DEFINE    g_i             LIKE type_file.num5       #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE    i               LIKE type_file.num5       #No.FUN-680123 SMALLINT
DEFINE    l_table         STRING,                   ### CR11 ###
          g_str           STRING,                   ### CR11 ###
          g_sql           STRING                    ### CR11 ###
DEFINE    l_table1        STRING                    #CHI-B60008
DEFINE    g_order         LIKE type_file.chr100     #CHI-B60008
DEFINE    g_order0        LIKE type_file.chr100     #CHI-B60008
#FUN-BB0173 add START
DEFINE plant   ARRAY[8]  OF LIKE azp_file.azp01
DEFINE   g_ary DYNAMIC ARRAY OF RECORD
           plant      LIKE azw_file.azw01           #plant
           END RECORD
DEFINE   g_ary_i        LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1         #記錄是否為流通
DEFINE   g_azw01_1      LIKE azw_file.azw01
DEFINE   g_azw01_2      LIKE azw_file.azw01
#FUN-BB0173 add END
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/03/06 TSD.Martin  *** ##
   LET g_sql =
       "oma03.oma_file.oma03  ,oma032.oma_file.oma032,", #帳款客戶編號,客戶簡稱
       "omb04.omb_file.omb04  ,occ21.occ_file.occ21,",   #機種(料號)  ,區域(國別)
       "oma01.oma_file.oma01  ,omb03.omb_file.omb03,",   #帳款編號    ,項次
       "omb05.omb_file.omb05  ,omb06.omb_file.omb06,",   #單位        ,品名   #MOD-860260 add omb05
       "omb12.omb_file.omb12  ,omb12_1.omb_file.omb12,", #數量        ,數量
       "omb15.omb_file.omb15  ,omb31.omb_file.omb31,",   #本幣單價    ,出貨單號
       "omb32.omb_file.omb32  ,oma23.oma_file.oma23,",   #出貨單號項次,幣別
       "oma24.oma_file.oma24  ,omb13.omb_file.omb13,",   #匯率        ,原幣單價
       "oma02.oma_file.oma02  ,oma08.oma_file.oma08,",   #立帳日      ,內/外銷
       "omb14t.omb_file.omb14t,omb14.omb_file.omb14,",   #原幣含稅金額,原幣未稅金額
       "omb16t.omb_file.omb16t,omb16.omb_file.omb16,",   #本幣含稅金額,原幣未稅金額
       "oma00.oma_file.oma00  ,oma10.oma_file.oma10,",
       "db.azp_file.azp02     ,l_geb02.geb_file.geb02,",
       "oma161.oma_file.oma161,oma162.oma_file.oma162,", #訂金應收比率,出貨應收比率  #CHI-760014 add 
       "oma163.oma_file.oma163,",                        #尾款應收比率               #CHI-760014 add     
       "azi03.azi_file.azi03  ,azi04.azi_file.azi04,",   #MOD-7B0051
       "azi05.azi_file.azi05  ,azi03_1.azi_file.azi03,", #MOD-7B0051
       "azi04_1.azi_file.azi04,azi05_1.azi_file.azi05,", #MOD-7B0051
       "azi07.azi_file.azi07,",                          #MOD-870260 add
       "plant.azp_file.azp01"                            #No.FUN-8C0019
 
   LET l_table = cl_prt_temptable('axrr378',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #CHI-B60008 
      EXIT PROGRAM 
   END IF                  # Temp Table產生
  #-CHI-B60008-mark-
  #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
  #            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
  #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"    #MOD-7B0051  #MOD-860260 add ?   #MOD-870260 add ? #FUN-8C0019 add ?
  #PREPARE insert_prep FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  #END IF
  #-CHI-B60008-add-
   LET g_sql =
       "oma03.oma_file.oma03,",
       "oma02.oma_file.oma02,",
       "oma23.oma_file.oma23,",
       "omb04.omb_file.omb04,",
       "omb05.omb_file.omb05,",
       "occ21.occ_file.occ21,",
       "omb12.omb_file.omb12,",
       "omb16_after.omb_file.omb16,",
       "omb14_after.omb_file.omb14,",
       "omb16t_omb16.omb_file.omb16,",
       "azi05.azi_file.azi05,",
       "azi05_1.azi_file.azi05"
   LET l_table1= cl_prt_temptable('axrr3781',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1= -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   
      EXIT PROGRAM 
   END IF                  # Temp Table產生
  #-CHI-B60008-end-
   #----------------------------------------------------------CR (1) ------------#
 
   DROP TABLE axrr378_tmp    #總計
   CREATE TEMP TABLE axrr378_tmp
     (curr LIKE azi_file.azi01,
      amt1 LIKE omb_file.omb12,
      amt2 LIKE omb_file.omb15,
      amt3 LIKE omb_file.omb13,
      amt4 LIKE omb_file.omb12)
 
   DROP TABLE axrr378_tmp1   #小計
   CREATE TEMP TABLE axrr378_tmp1
     (item LIKE type_file.chr1000,
      curr LIKE azi_file.azi01,
      amt1 LIKE omb_file.omb12,
      amt2 LIKE omb_file.omb15,
      amt3 LIKE omb_file.omb13,
      amt4 LIKE omb_file.omb12)
                                        
 
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type = ARG_VAL(10)
   LET tm.sort = ARG_VAL(11)
   LET tm.b = ARG_VAL(12)
   LET tm.c = ARG_VAL(13)    #CHI-850016
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   LET tm.p1 = ARG_VAL(14)
#   LET tm.p2 = ARG_VAL(15)
#   LET tm.p3 = ARG_VAL(16)
#   LET tm.p4 = ARG_VAL(17)
#   LET tm.p5 = ARG_VAL(18)
#   LET tm.p6 = ARG_VAL(19)
#   LET tm.p7 = ARG_VAL(20)
#   LET tm.p8 = ARG_VAL(21)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end   
#FUN-BB0173 mark START
#  LET g_rep_user = ARG_VAL(14)
#  LET g_rep_clas = ARG_VAL(15)
#  LET g_template = ARG_VAL(16)
#FUN-BB0173 mark END
#  LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
#FUN-BB0173 add START
   LET plant[1] = ARG_VAL(14)
   LET plant[2] = ARG_VAL(15)
   LET plant[3] = ARG_VAL(16)
   LET plant[4] = ARG_VAL(17)
   LET plant[5] = ARG_VAL(18)
   LET plant[6] = ARG_VAL(19)
   LET plant[7] = ARG_VAL(20)
   LET plant[8] = ARG_VAL(21)
   FOR g_i = 1 TO 8
      IF NOT cl_null(plant[g_i])THEN
         CALL chk_plant(plant[g_i]) RETURNING g_azw01_1
         IF NOT cl_null(g_azw01_1) THEN
            IF cl_null(g_azw01_2) THEN
               LET g_azw01_2 = "'",g_azw01_1,"'"
            ELSE
               LET g_azw01_2 = g_azw01_2,"'",g_azw01_1,"'"
            END IF
         END IF
      END IF
   END FOR
   IF NOT cl_null(g_azw01_2) THEN
      CALL r378_legal_db(g_azw01_2)
   END IF
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
#FUN-BB0173 add END
#  LET tm.d     = ARG_VAL(26)    ###GP5.2  #NO.FUN-A10098 dxfwo mark
   IF cl_null(tm.wc)
      THEN CALL r378_tm(0,0)             # Input print condition
   ELSE 
      CALL r378()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r378_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col     LIKE type_file.num5,         #No.FUN-680123 SMALLINT
       l_cmd           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
DEFINE l_n             LIKE type_file.num5          #No.FUN-680123 SMALLINT
#FUN-BB0173 add START
DEFINE  l_cnt          LIKE type_file.num5
DEFINE  l_string       STRING
DEFINE  l_plant        LIKE azw_file.azw01
DEFINE  l_ac           LIKE type_file.num5
#FUN-BB0173 add END
 
   LET p_row = 2 LET p_col = 18
 
   OPEN WINDOW r378_w AT p_row,p_col WITH FORM "axr/42f/axrr378"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r378_set_entry() RETURNING l_cnt    #FUN-BB0173 add
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.bdate = today
   LET tm.edate = today
   LET tm.b= 'Y'
  #LET tm.c= 'Y'                          #CHI-850016 #MOD-CC0063 mark
   LET tm.c= 'N'                          #MOD-CC0063 add
#  LET tm.p1 = g_plant                    ###GP5.2  #NO.FUN-A10098 dxfwo mark
   LET tm.plant_1 = g_plant   #FUN-BB0173 add
   LET tm.type = '3'
   LET tm.sort = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#  LET tm.d ='N'                          ###GP5.2  #NO.FUN-A10098 dxfwo mark
#  LET tm.p1=g_plant                      ###GP5.2  #NO.FUN-A10098 dxfwo mark
#   CALL p378_set_entry_1()               
#   CALL p378_set_no_entry_1()
#   CALL r378_set_comb()
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma08,oma01, oma10, omb04, oma03,   #TQC-6A0049
                              oma00,omauser,oma18,oma14
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
 
      ON ACTION CONTROLP
         IF INFIELD(omb04) THEN   #TQC-6A0049
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO omb04    #TQC-6A0049
            NEXT FIELD omb04                        #TQC-6A0049
         END IF
         IF INFIELD(oma03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form = "q_occ"
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO oma03
            NEXT FIELD oma03 
         END IF
         IF INFIELD(oma18) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state    = "c"
            LET g_qryparam.form = "q_aag"
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO oma18 
            NEXT FIELD oma18 
         END IF
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
  END CONSTRUCT
 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r378_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF

#FUN-BB0173 add START
   INPUT BY NAME tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
                 tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8

   WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD plant_1
         IF NOT cl_null(tm.plant_1) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_1
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_1
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_1) THEN
               NEXT FIELD plant_1
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_1 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_1 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_1 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_1 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_1 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_1 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_1 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_1
               END IF
            END IF
         END IF

      AFTER FIELD plant_2
         IF NOT cl_null(tm.plant_2) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_2
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_2
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_2) THEN
               NEXT FIELD plant_2
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_2 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_2 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_2 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_2 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_2 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_2 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_2 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_2
               END IF
            END IF
         END IF

      AFTER FIELD plant_3
         IF NOT cl_null(tm.plant_3) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_3
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_3
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_3) THEN
               NEXT FIELD plant_3
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_3 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_3 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_3 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_3 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_3 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_3 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_3 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_3
               END IF
            END IF
         END IF

      AFTER FIELD plant_4
         IF NOT cl_null(tm.plant_4) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_4
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_4
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_4) THEN
               NEXT FIELD plant_4
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_4 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_4 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_4 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_4 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_4 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_4 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_4 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_4
               END IF
            END IF
         END IF

      AFTER FIELD plant_5
         IF NOT cl_null(tm.plant_5) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_5
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_5
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_5) THEN
               NEXT FIELD plant_5
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_5 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_5 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_5 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_5 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_5 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_5 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_5 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_5
               END IF
            END IF
         END IF

      AFTER FIELD plant_6
         IF NOT cl_null(tm.plant_6) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_6
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_6
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_6) THEN
               NEXT FIELD plant_6
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_6 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_6 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_6 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_6 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_6 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_6 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_6 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_6
               END IF
            END IF
         END IF

      AFTER FIELD plant_7
         IF NOT cl_null(tm.plant_7) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_7
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_7
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_7) THEN
               NEXT FIELD plant_7
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_7 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_7 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_7 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_7 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_7 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_7 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
            IF NOT cl_null(tm.plant_8) THEN
               IF tm.plant_7 = tm.plant_8 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_7
               END IF
            END IF
         END IF

      AFTER FIELD plant_8
         IF NOT cl_null(tm.plant_8) THEN
           #判斷輸入之營運中心是否存在
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = tm.plant_8
            IF l_cnt < 1 THEN
               CALL cl_err('','apc-003',0)
               NEXT FIELD plant_8
            END IF
          #檢查使用者的資料庫使用權限
            IF NOT s_chk_demo(g_user,tm.plant_8) THEN
               NEXT FIELD plant_8
            END IF
          #營運中心不可重複
            IF NOT cl_null(tm.plant_1) THEN
               IF tm.plant_8 = tm.plant_1 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_2) THEN
               IF tm.plant_8 = tm.plant_2 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_3) THEN
               IF tm.plant_8 = tm.plant_3 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_4) THEN
               IF tm.plant_8 = tm.plant_4 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_5) THEN
               IF tm.plant_8 = tm.plant_5 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_6) THEN
               IF tm.plant_8 = tm.plant_6 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
            IF NOT cl_null(tm.plant_7) THEN
               IF tm.plant_8 = tm.plant_7 THEN
                   CALL cl_err('','aom-492',0)
                   NEXT FIELD plant_8
               END IF
            END IF
         END IF

      AFTER INPUT
         LET l_string = ''
         IF NOT cl_null(tm.plant_1) THEN
            CALL chk_plant(tm.plant_1) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_2) THEN
            CALL chk_plant(tm.plant_2) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_3) THEN
            CALL chk_plant(tm.plant_3) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_4) THEN
            CALL chk_plant(tm.plant_4) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_5) THEN
            CALL chk_plant(tm.plant_5) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_6) THEN
            CALL chk_plant(tm.plant_6) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_7) THEN
            CALL chk_plant(tm.plant_7) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

         IF NOT cl_null(tm.plant_8) THEN
            CALL chk_plant(tm.plant_8) RETURNING l_plant
            IF NOT cl_null(l_plant) THEN
               IF cl_null(l_string) THEN
                  LET l_string = "'",l_plant,"'"
               ELSE
                  LET l_string = l_string, ",'", l_plant,"'"
               END IF
            END IF
         END IF

          #營運中心不可為空
         IF cl_null(l_string) THEN
            CALL cl_err('','aom-423',0)
            NEXT FIELD plant_1
         END IF
         CALL r378_legal_db(l_string)

      ON ACTION CONTROLP
         CASE
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
         END CASE

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
      CLOSE WINDOW r378_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#FUN-BB0173 add END
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.sort,tm.b,tm.c,
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                 tm.d,   #CHI-850016 #FUN-8C0019 add tm.d
#                 tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
                 tm.more
          WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
         
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin      
#      AFTER FIELD d
#          IF NOT cl_null(tm.d)  THEN
#             IF tm.d NOT MATCHES "[YN]" THEN
#                NEXT FIELD d       
#             END IF
#          END IF
#                    
#       ON CHANGE  d
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL p378_set_entry_1()      
#          CALL p378_set_no_entry_1()
#          CALL r378_set_comb()
      
      AFTER FIELD sort
         IF cl_null(tm.sort) OR tm.sort NOT MATCHES '[12345]' THEN    #No.FUN-8C0019 add 5
            NEXT FIELD sort
         END IF
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)    #No.FUN-660116
#            NEXT FIELD p1 
#         END IF
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            END IF  
#         END IF              
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p2 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#         END IF
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p3 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#         END IF
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p4 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#         END IF
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p5 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#         END IF
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p6
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#         END IF
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p7
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#         END IF
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p8
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#         END IF
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

     #-CHI-B60008-add-
      AFTER INPUT
         CASE tm.sort
            WHEN '1'
               LET g_order0= ' ORDER BY oma03,omb05,oma02,omb04,occ21,oma23' 
               LET g_order = ' ORDER BY oma03,omb04,occ21 ' 
            WHEN '2'        
               LET g_order0= ' ORDER BY omb04,omb05,oma03,oma032,occ21,oma23' 
               LET g_order = ' ORDER BY omb04,oma03,occ21 ' 
            WHEN '3'        
               LET g_order0= ' ORDER BY occ21,omb05,oma03,oma032,omb04,oma23' 
               LET g_order = ' ORDER BY occ21,oma03,omb04 ' 
            WHEN '4'        
               LET g_order0= ' ORDER BY oma02,omb05,oma03,omb32,omb04,oma23' 
               LET g_order = ' ORDER BY oma02,omb04 '
         END CASE 
     #-CHI-B60008-end-

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION CONTROLP
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#        CASE
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#         OTHERWISE EXIT CASE
#    END CASE
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r378_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axrr378'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr378','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,
                         " '",tm.sort CLIPPED,"'" ,   
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,    #CHI-850016
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                         " '",tm.p1 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p2 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p3 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p4 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p5 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p6 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p7 CLIPPED,"'" ,   #TQC-610059
#                         " '",tm.p8 CLIPPED,"'" ,   #TQC-610059
            #FUN-BB0173 add START
                         " '",plant[1] CLIPPED,"'",
                         " '",plant[2] CLIPPED,"'",
                         " '",plant[3] CLIPPED,"'",
                         " '",plant[4] CLIPPED,"'",
                         " '",plant[5] CLIPPED,"'",
                         " '",plant[6] CLIPPED,"'",
                         " '",plant[7] CLIPPED,"'",
                         " '",plant[8] CLIPPED,"'",
            #FUN-BB0173 add END
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
#                        " '",tm.d CLIPPED,"'"                  #No.FUN-8C0019 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
         CALL cl_cmdat('axrr378',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r378_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r378()
   ERROR ""
END WHILE
   CLOSE WINDOW r378_w
END FUNCTION
 
FUNCTION r378()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
          l_sql     STRING ,
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_oob09   LIKE oob_file.oob09,
          l_oob10   LIKE oob_file.oob10,
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l1_i      LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_dbs     LIKE azp_file.azp03,
          sr        RECORD
                    order1   LIKE omb_file.omb04,        #No.FUN-680123 VARCHAR(40)
                    order2   LIKE   omb_file.omb32,      #No.FUN-680123 VARCHAR(16)
                    order3   LIKE   omb_file.omb04,      #No.FUN-680123 VARCHAR(12) 
                    order4   LIKE   omb_file.omb04,      #No.FUN-680123 VARCHAR(12)
                    oma03    LIKE   oma_file.oma03,      #帳款客戶編號
                    oma032   LIKE   oma_file.oma032,     #客戶簡稱
                    omb04    LIKE   omb_file.omb04,      #機種(料號)
                    occ21    LIKE   occ_file.occ21,      #區域(國別)
                    oma01    LIKE   oma_file.oma01,      #帳款編號
                    omb03    LIKE   omb_file.omb03,      #項次
                    omb05    LIKE   omb_file.omb05,      #單位   #MOD-860260 add
                    omb06    LIKE   omb_file.omb06,      #品名
                    omb12    LIKE   omb_file.omb12,      #數量
                    omb12_1  LIKE   omb_file.omb12,      #數量
                    omb15    LIKE   omb_file.omb15,      #本幣單價
                    omb31    LIKE   omb_file.omb31,      #出貨單號
                    omb32    LIKE   omb_file.omb32,      #出貨單號項次
                    oma23    LIKE   oma_file.oma23,      #幣別
                    oma24    LIKE   oma_file.oma24,      #匯率
                    omb13    LIKE   omb_file.omb13,      #原幣單價
                    oma02    LIKE   oma_file.oma02,      #立帳日
                    oma08    LIKE   oma_file.oma08,      #內/外銷
                    omb14t   LIKE   omb_file.omb14t,     #原幣含稅金額
                    omb14    LIKE   omb_file.omb14,      #原幣未稅金額
                    omb16t   LIKE   omb_file.omb16t,     #本幣含稅金額
                    omb16    LIKE   omb_file.omb16,      #本幣未稅金額
                    oma00    LIKE   oma_file.oma00,      #
                    oma10    LIKE   oma_file.oma10,      #發票金額
                    db       LIKE   azp_file.azp02,
                    oma161   LIKE   oma_file.oma161,     #訂金應收比率  #CHI-760014 add 
                    oma162   LIKE   oma_file.oma162,     #出貨應收比率  #CHI-760014 add  
                    oma163   LIKE   oma_file.oma163,     #尾款應收比率  #CHI-760014 add  
                    azi03    LIKE   azi_file.azi03,      #MOD-7B0051
                    azi04    LIKE   azi_file.azi04,      #MOD-7B0051
                    azi05    LIKE   azi_file.azi05,      #MOD-7B0051
                    azi07    LIKE   azi_file.azi07       #MOD-870260 add
                    END RECORD
   DEFINE l_geb02   LIKE geb_file.geb02
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
  #-CHI-B60008-add-
   CALL cl_del_data(l_table1) 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,", 
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"    #MOD-7B0051  #MOD-860260 add ?   #MOD-870260 add ? #FUN-8C0019 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
  #-CHI-B60008-end-
   #------------------------------ CR (2) ------------------------------#
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
 
   LET g_yy = YEAR(tm.bdate)
   LET g_mm = MONTH(tm.bdate)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
 
   LET g_pageno = 0
 
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
             " FROM axrr378_tmp1 ",
             " WHERE item=?  ",
             " GROUP BY curr ORDER BY curr "
   PREPARE r378_pr1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE tmp_curs1 CURSOR FOR r378_pr1
 
   LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
             " FROM axrr378_tmp ",
             " GROUP BY curr ORDER BY curr "
   PREPARE r378_pr2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE tmp_curs2 CURSOR FOR r378_pr2
 
   DELETE FROM axrr378_tmp1
   DELETE FROM axrr378_tmp
   LET g_cnt=0
   LET g_amt=0 LET t_rate=0
   LET g_pageno = 0
#  FOR l_i = 1 to 8
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-BB0173 add START
    LET l_i = 1
    FOR l_i = 1 TO g_ary_i
       IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
#FUN-BB0173 add END
         LET l_sql = " SELECT '','','','',",
                     "        oma03,oma032,omb04,occ21,",
                     "        oma01,omb03,omb05,omb06,omb12,omb12,omb15,",
                     "        omb31,omb32,oma23,oma24,omb13,",
                     "        oma02,oma08,omb14t,omb14,omb16t,",
                     "        omb16,oma00,oma10, ",
                     "        '',",
                     "        oma161,oma162,oma163",
#                   " FROM ",l_dbs CLIPPED,"oma_file,",l_dbs CLIPPED,"occ_file,",l_dbs CLIPPED,"omb_file LEFT OUTER JOIN (SELECT ogb01,ogb03,ogb04 FROM ",l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ogb_file WHERE oga01 = ogb01) tmp ON omb_file.omb31=tmp.ogb01 AND omb_file.omb32=tmp.ogb03 LEFT OUTER JOIN (SELECT ohb01,ohb03,ohb04 FROM ",l_dbs CLIPPED,"oha_file,",l_dbs CLIPPED,"ohb_file WHERE oha01 = ohb01) tmp1 ON omb_file.omb32 = tmp1.ohb03 AND omb_file.omb31=tmp1.ohb01",
                   #" FROM oma_file,occ_file,omb_file ",  #FUN-BB0173 mark 
                     " FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                     " ,",cl_get_target_table(g_ary[l_i].plant,'occ_file'),      #FUN-BB0173 add
                     " ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),      #FUN-BB0173 add
#                    " WHERE omb31 = tmp.ogb01 ",
#                    "   AND oma03 = occ01",
                     " WHERE oma03 = occ01",
#                    "   AND omb32 = tmp.ogb03",
#                    "   AND omb32 = tmp1.ohb03",
#                    "   AND omb31 = tmp1.ohb01",
                     "   AND oma01 = omb01 ",  
                 #   "   AND oma00 IN ('11','12','13','21') ",  #MOD-7B0142  #mark by lifang 171016
                     "   AND oma00 IN ('11','12','13','21','22') ",     #add by lifang 171016
                     "   AND omaconf = 'Y' ",
                     "   AND omavoid = 'N' ",
                     "   AND omb04[1,4] != 'MISC' ",    #No.9579
                     "   AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        IF tm.c = 'Y' THEN
        #  LET l_sql = l_sql,"   AND oma00 IN ('11','12','21') "       #MOD-880001  #mark by lifang 171016
           LET l_sql = l_sql,"   AND oma00 IN ('11','12','21','22') "  #add by lifang 171016  
        ELSE
        #  LET l_sql = l_sql,"   AND oma00 IN ('12','13','21') "       #mark by lifang 171016
           LET l_sql = l_sql,"   AND oma00 IN ('12','13','21','22') "  #add by lifang 171016
        END IF
       #只有大陸功能才有發票待扺
       IF g_aza.aza26 = '2' THEN
          LET l_sql = l_sql CLIPPED,
                      "   AND oma01 IN (SELECT DISTINCT oma01 ",
#                     "  FROM ",l_dbs CLIPPED," oma_file,",
#                               l_dbs CLIPPED," omb_file ",
                     #"  FROM oma_file,omb_file ",  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),   #FUN-BB0173 add
                      " ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),        #FUN-BB0173 add 
                      " WHERE oma01 = omb01 ",
                      "   AND ",tm.wc CLIPPED,
                      "  UNION ",
                      " SELECT DISTINCT oma01 ",
#                     "  FROM ",l_dbs CLIPPED," oma_file ",
                     #"  FROM oma_file ",   #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),     #FUN-BB0173 add
                      " WHERE oma01 IN (SELECT DISTINCT oot01 ",
#                     "  FROM ",l_dbs CLIPPED," oot_file ",
                     #"  FROM oot_file ",  #FUN-BB0173 mark
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oot_file'),  #FUN-BB0173 add
                      " WHERE oot03 IN (SELECT DISTINCT oma01 ",
#                     "  FROM ",l_dbs CLIPPED," oma_file,",
#                               l_dbs CLIPPED," omb_file ",
                     #"  FROM oma_file,omb_file ",
                      "  FROM ",cl_get_target_table(g_ary[l_i].plant,'oma_file'),  #FUN-BB0173 add
                      "  ,",cl_get_target_table(g_ary[l_i].plant,'omb_file'),      #FUN-BB0173 add
                      " WHERE oma01 = omb01 ",
                      "   AND omaconf = 'Y' ",
                      "   AND omavoid = 'N' ",
                      "   AND ",tm.wc CLIPPED,
                      " ))) "
          LET l_sql = l_sql CLIPPED,
                      "   AND ",tm.wc CLIPPED
       ELSE
          LET l_sql = l_sql CLIPPED,
                      "   AND ",tm.wc CLIPPED
       END IF
 
#display 'l_sql:',l_sql   #MOD-B50224 mark
       IF tm.type='1' THEN LET l_sql=l_sql CLIPPED," AND occ37='Y'" END IF
       IF tm.type='2' THEN LET l_sql=l_sql CLIPPED," AND occ37='N'" END IF
       LET l_sql=l_sql CLIPPED," AND ",tm.wc CLIPPED   #MOD-930324 add
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE r378_prepare1 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
          EXIT PROGRAM 
       END IF
       DECLARE r378_curs1 CURSOR FOR r378_prepare1

      #-MOD-B50224-add-
       LET l_sql = "SELECT geb02 ",                                                                              
                   "  FROM geb_file",
                   " WHERE geb01= ? "
       PREPARE geb_prepare2 FROM l_sql                                                                                          
       DECLARE geb_c2  CURSOR FOR geb_prepare2                                                                                 

      #LET l_sql = "SELECT azi03,azi04,azi07 ",            #MOD-C40029 mark
       LET l_sql = "SELECT azi03,azi04,azi07,azi05 ",      #MOD-C40029 add
                   "  FROM azi_file",
                   " WHERE azi01= ? "    
       PREPARE azi_prepare2 FROM l_sql                                                                                          
       DECLARE azi_c2  CURSOR FOR azi_prepare2                                                                                 
      #-MOD-B50224-end-

       FOREACH r378_curs1 INTO sr.*
          IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
             EXIT PROGRAM 
          END IF
         #-CHI-B60008-mark- 
         ##依何種方式排序
         #CASE
         #   WHEN tm.sort = '1'  #by客戶
         #        LET sr.order1 = sr.oma03
         #        LET sr.order2 = sr.oma032
         #        LET sr.order3 = sr.omb04
         #        LET sr.order4 = sr.occ21
         #   WHEN tm.sort = '2'  #by機種(料號)
         #        LET sr.order1 = sr.omb04
         #        LET sr.order2 = sr.oma03
         #        LET sr.order3 = sr.oma032
         #        LET sr.order4 = sr.occ21
         #   WHEN tm.sort = '3'  #by地區(國別)
         #        LET sr.order1 = sr.occ21
         #        LET sr.order2 = sr.oma03
         #        LET sr.order3 = sr.oma032
         #        LET sr.order4 = sr.omb04
         #   WHEN tm.sort = '4'  #by帳款日期
         #        #LET sr.order1 = sr.oma02 USING 'YY/MM/DD' #FUN-570250 mark
         #        LET sr.order1 = sr.oma02 #FUN-570250 add
         #        LET sr.order2 = sr.omb31
         #        LET sr.order3 = sr.omb32
         #        LET sr.order4 = sr.omb04
         #   OTHERWISE EXIT CASE
         #END CASE
         #-CHI-B60008-end- 
 
          IF sr.oma00='21' THEN
             LET sr.omb12=sr.omb12*-1   #MOD-6A0095
             LET sr.omb14=sr.omb14*-1   #No.FUN-5B0139
             LET sr.omb16=sr.omb16*-1
             LET sr.omb16t=sr.omb16t*-1
          END IF
          IF sr.oma00 = '21' AND sr.omb12_1 = 0 THEN
             LET sr.omb12_1 = 1
          END IF
 
          LET g_amt=g_amt+sr.omb16t
#         LET sr.db = m_dbs[l_i]
          LET l_geb02 = '' 
         #-MOD-B50224-mark-
         #LET l_sql = "SELECT geb02 ",                                                                              
#        #            "  FROM ",l_dbs CLIPPED,"geb_file",
         #            "  FROM geb_file",
         #            " WHERE geb01='",sr.occ21,"'"
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         #PREPARE geb_prepare2 FROM l_sql                                                                                          
         #DECLARE geb_c2  CURSOR FOR geb_prepare2                                                                                 
         #-MOD-B50224-end-
          OPEN geb_c2  USING sr.occ21                 #MOD-B50224 mod USING 
          FETCH geb_c2 INTO l_geb02
 
         #-MOD-B50224-mark-
         #LET l_sql = "SELECT azi03,azi04,azi07 ",  #MOD-940138 add azi07
#        #            "  FROM ",l_dbs CLIPPED,"azi_file",
         #            "  FROM azi_file",
         #           #" WHERE azi01='",g_aza.aza17,"'"  #MOD-940138 mark
         #            " WHERE azi01='",sr.oma23,"'"     #MOD-940138
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         #PREPARE azi_prepare2 FROM l_sql                                                                                          
         #DECLARE azi_c2  CURSOR FOR azi_prepare2                                                                                 
         #-MOD-B50224-end-
          OPEN azi_c2  USING sr.oma23                   #MOD-B50224 mod USING 
          FETCH azi_c2 INTO sr.azi03,sr.azi04,sr.azi07  #MOD-940138 add sr.azi07
         #FETCH azi_c2 INTO sr.azi03,sr.azi04,sr.azi07                      #MOD-940138 add sr.azi07 #MOD-C40029 mark
          FETCH azi_c2 INTO sr.azi03,sr.azi04,sr.azi07,sr.azi05             #MOD-C40029 add
         #SELECT azi05 INTO sr.azi05 FROM azi_file WHERE azi01=g_aza.aza17  #MOD-C40029 mark
            
          IF tm.c = 'N' THEN 
             LET sr.oma162=sr.oma161+sr.oma162
             LET sr.oma161=0
          END IF
          EXECUTE insert_prep USING 
             sr.oma03  , sr.oma032 , sr.omb04 , sr.occ21  , sr.oma01  ,   
             sr.omb03  , sr.omb05  , sr.omb06 , sr.omb12  , sr.omb12_1,   #MOD-860260 add omb05
             sr.omb15  , sr.omb31  , sr.omb32 , sr.oma23  , sr.oma24  , 
             sr.omb13  , sr.oma02  , sr.oma08 , sr.omb14t , sr.omb14  ,
#            sr.omb16t , sr.omb16  , sr.oma00 , sr.oma10  , sr.db     ,
             sr.omb16t , sr.omb16  , sr.oma00 , sr.oma10  , ''     ,
             l_geb02   , sr.oma161 , sr.oma162, sr.oma163 , sr.azi03  ,
             sr.azi04  , sr.azi05  , g_azi03  , g_azi04   , g_azi05       #MOD-7B0051
#           ,sr.azi07  , m_dbs[l_i]   #MOD-870260 add #FUN-8C0019 add m_dbs[l_i]
           #,sr.azi07  , ''  #FUN-BB0173 mark
            ,sr.azi07  , g_ary[l_i].plant    #FUN-BB0173 add
          #------------------------------ CR (3) ------------------------------#
       END FOREACH
#  END FOR
   END FOR  #FUN-BB0173 add
  #-CHI-B60008-add-
   LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16*oma161/100) omb16_after,",
             "       SUM(omb14*oma161/100) omb14_after,SUM((omb16t-omb16)*oma161/100) omb16t_omb16,",
             "       azi05,azi05_1,plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE oma00='11'",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant",  #FUN-BB0173 add plant
             " UNION ALL ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16*oma162/100) omb16_after,",
             "       SUM(omb14*oma162/100) omb14_after,SUM((omb16t-omb16)*oma162/100) omb16t_omb16,",
             "       azi05,azi05_1, plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE oma00='12'",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant",  #FUN-BB0173 add plant
             " UNION ALL ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16*oma163/100) omb16_after,",
             "       SUM(omb14*oma163/100) omb14_after,SUM(omb16t-omb16) omb16t_omb16,",
             "       azi05,azi05_1, plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE oma00='13'",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant",  #FUN-BB0173 add plant
             " UNION ALL ",
             "SELECT oma03,oma02,oma23,omb04,omb05,occ21,",
             "       SUM(omb12) omb12,SUM(omb16) omb16_after,",
             "       SUM(omb14) omb14_after,SUM(omb16t-omb16) omb16t_omb16,",
             "       azi05,azi05_1,plant ",   #FUN-BB0173 add plant
             "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " WHERE (oma00!='11' AND oma00!='12' AND oma00!='13') ",
             " GROUP BY oma03,oma02,oma23,omb04,omb05,occ21,azi05,azi05_1,plant"   #FUN-BB0173 add plant
   PREPARE insert_prep1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   
      EXIT PROGRAM
   END IF
   EXECUTE insert_prep1
  #-CHI-B60008-end-
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,g_order0   #FUN-710080 modify #CHI-B60008 add g_order0
  #-CHI-B60008-add-
   IF tm.b = 'Y' THEN
      LET l_sql = l_sql,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,g_order
   END IF
   LET l_sql = l_sql,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY oma23"
  #-CHI-B60008-end-

   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma08,oma01,oma10,omb04,oma03') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
#  IF tm.d = 'Y' THEN                                   
#     LET l_name = 'axrr378_1'                          
#  ELSE                                                 
#     LET l_name = 'axrr378'   #CHI-B60008 mark 
#  END IF
  #-CHI-B60008-add-
   IF g_flag = TRUE  THEN   #流通  #FUN-BB0173 add
      IF tm.b = 'Y' THEN
         CASE tm.sort
            WHEN '1'
               LET l_name = 'axrr378_s1' 
            WHEN '2'        
               LET l_name = 'axrr378_s2' 
            WHEN '3'        
               LET l_name = 'axrr378_s3' 
            WHEN '4'        
               LET l_name = 'axrr378_s4'
         END CASE 
      ELSE
         CASE tm.sort
            WHEN '1'
               LET l_name = 'axrr378_b1' 
            WHEN '2'        
               LET l_name = 'axrr378_b2' 
            WHEN '3'        
               LET l_name = 'axrr378_b3' 
            WHEN '4'        
               LET l_name = 'axrr378_b4'
         END CASE 
      END IF
#FUN-BB0173 add START
  ELSE
      IF tm.b = 'Y' THEN
         CASE tm.sort
            WHEN '1'
               LET l_name = 'axrr378_s5'
            WHEN '2'
               LET l_name = 'axrr378_s6'
            WHEN '3'
               LET l_name = 'axrr378_s7'
            WHEN '4'
               LET l_name = 'axrr378_s8'
         END CASE
      ELSE
         CASE tm.sort
            WHEN '1'
               LET l_name = 'axrr378_b5'
            WHEN '2'
               LET l_name = 'axrr378_b6'
            WHEN '3'
               LET l_name = 'axrr378_b7'
            WHEN '4'
               LET l_name = 'axrr378_b8'
         END CASE
      END IF
  END IF
#FUN-BB0173 add END
  #-CHI-B60008-end-
   LET g_str = g_str ,";",tm.type,";",tm.bdate,";",tm.edate,";",tm.sort,";",tm.b 
   CALL cl_prt_cs3('axrr378',l_name,l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
END FUNCTION
#FUN-BB0173 add START
#流通業將營運中心隱藏
FUNCTION r378_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("Group1",FALSE)
     LET g_flag = TRUE  #流通
     LET g_ary_i = 1
     LET g_ary[g_ary_i].plant = g_plant      #流通業則將array存入 g_plant
  END IF
  RETURN l_cnt
END FUNCTION

#將plant放入array
FUNCTION r378_legal_db(p_string)
DEFINE p_string  STRING
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azw09   LIKE azw_file.azw09
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_sql     STRING
   IF cl_null(p_string) THEN
      LET p_string = g_plant
   END IF
   LET g_ary_i = 1
   LET g_errno = ' '

   LET l_sql = "SELECT DISTINCT azw01 FROM azw_file ",
               "  WHERE azw01 IN ( ",p_string," ) "
   PREPARE r140_azw01_pre FROM l_sql
   DECLARE r140_azw01_cs CURSOR FOR r140_azw01_pre
   FOREACH r140_azw01_cs INTO g_ary[g_ary_i].plant
      LET g_ary_i = g_ary_i + 1
   END FOREACH
   LET g_ary_i = g_ary_i - 1

END FUNCTION
#FUN-BB0173 add END
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#FUNCTION p378_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
# 
#FUNCTION p378_set_no_entry_1()
#    IF tm.d = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm.sort = '5' THEN                                                                                                         
#          LET tm.sort = ' '                                                                                                          
#       END IF                                                                                                                       
#    END IF
#END FUNCTION
# 
#FUNCTION r378_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.d ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-385' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-389' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('sort',comb_value,comb_item)
#END FUNCTION
#No.FUN-9C0072 精簡程式碼 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
