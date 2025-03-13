# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr150.4gl
# Descriptions...: 期間別量值表
# Date & Author..: 98/05/29 By Star
# 96/06/06 redefine 不含重工金額＝入庫金額－重工金額
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.MOD-4B0189 04/11/19 By ching   DROP TABLE 有錯
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0071 04/12/13 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                   #如果二個幣別相同時，匯率強制為
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580198 05/08/29 By Rosayu 打印應該是是COLUMN 19,cl_numfor(sr.qty1,22,g_azi03)
# Modify.........: No.TQC-5A0038 05/10/14 By Rosayu 料件編號放寬到40.
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680025 06/08/24 By cheunl voucher型報表轉template1
# Modify.........: No.FUN-680122 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-6A0146/FUN-680122改錯部分
# Modify.........: No.FUN-660073 06/12/07 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 06/12/25 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710129 07/01/23 By jamie MISC的判斷需取前四碼 
# Modify.........: No.MOD-770070 07/07/18 By Carol 將azi05,azi04取位改為使用azi03
# Modify.........: No.MOD-7B0110 07/11/29 By Pengu 確定後出現: predae: 準備敘述失敗或沒有執行
# Modify.........: No.FUN-7C0101 08/01/29 By douzh 成本改善功能增加成本計算類型(type)
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改                            
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-880105 08/01/29 By douzh 報表打印調整
# Modify.........: No.MOD-8C0086 08/12/10 By claire  create table,ima01定義長度放大
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.TQC-980163 09/09/01 By liuxqa 將產生的臨時表表名寫死。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0187 09/11/02 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-A10098 10/01/21 By wuxj GP5.2 跨DB報表，財務類  修改 
# Modify.........: No.FUN-9C0073 10/01/26 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A40130 10/04/28 By Carrier TQC-980163/ TQC-970305/ FUN-940102/ MOD-950210/ MOD-950210/                     
#                                                    MOD-960331/ MOD-960332/ MOD-960334/ MOD-960335 追单
# Modify.........: No.FUN-A70084 10/07/23 By lutingting GP5.2 報表修改
# Modify.........: No.FUN-A80109 10/08/19 By lutingting 修正FUN-A10098問題 cl_get_target_table()中應該傳PLANT
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:FUN-B90130 11/11/29 By wujie  增加oma75的条件  
# Modify.........: No.TQC-BB0182 12/01/13 By pauline 取消過濾plant條件
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc LIKE type_file.chr1000       #No.FUN-680122CHAR(300)
   DEFINE tm  RECORD
              ima01   LIKE ima_file.ima01, #料號
              ima12   LIKE ima_file.ima12, #分本分群
              ima131  LIKE ima_file.ima131,     # Prog. Version..: '5.30.06-13.03.12(04)  #產品分類
              ima11   LIKE ima_file.ima11,     # Prog. Version..: '5.30.06-13.03.12(04)  #會計分類
              data   LIKE type_file.chr1,           #No.FUN-680122CHAR(1)  #資料選擇 1:產品分類 2:會計分類
              order  LIKE type_file.num5,           #No.FUN-680122SMALLINT  #排名方式 1:產品 2:1-12期金額 3:合計
              title  LIKE type_file.chr1,           #No.FUN-680122CHAR(1)  #抬頭 1:生產 2:不含重工3:銷淨4:銷毛5:淨利析
              plant_1,plant_2,plant_3,plant_4,plant_5 LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
              plant_6,plant_7,plant_8 LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
              yy1_b,mm1_b,mm1_e,yy2_b,mm2_b,mm2_e,yy3_b,mm3_b,mm3_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              yy4_b,mm4_b,mm4_e,yy5_b,mm5_b,mm5_e,yy6_b,mm6_b,mm6_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              yy7_b,mm7_b,mm7_e,yy8_b,mm8_b,mm8_e,yy9_b,mm9_b,mm9_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              yy10_b,mm10_b,mm10_e,yy11_b,mm11_b,mm11_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              yy12_b,mm12_b,mm12_e LIKE type_file.num5,           #No.FUN-680122SMALLINT
              p_group  LIKE type_file.chr1,         #No.FUN-680122CHAR(1)   #印料號
              p_group1 LIKE type_file.chr1,         #No.FUN-680122CHAR(1)   #印分群
              sum_code LIKE type_file.chr1,         #No.FUN-680122CHAR(1)
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              type    LIKE type_file.chr1,          #No.FUN-7C0101
              dec     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)      #金額單位(1)元(2)千(3)萬
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)
              END RECORD
   DEFINE tmp_sql  LIKE type_file.chr1000       #No.FUN-680122CHAR(1000)
   DEFINE
      g_bdate,g_edate LIKE type_file.dat,            #No.FUN-680122DATE
      i  LIKE type_file.num5,          #No.FUN-680122 SMALLINT
      g_ym ARRAY [12] OF RECORD
           yy_e       LIKE type_file.num5,           #No.FUN-680122SMALLINT
           mm_b       LIKE type_file.num5,           #No.FUN-680122SMALLINT
           mm_e       LIKE type_file.num5            #No.FUN-680122SMALLINT
        END RECORD
 
   DEFINE g_dash3      LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
   DEFINE g_orderA      ARRAY[2] OF LIKE cre_file.cre08           #No.FUN-680122 VARCHAR(10)
   DEFINE g_bookno      LIKE aaa_file.aaa01   #No.FUN-670039
   DEFINE g_base      LIKE type_file.num10           #No.FUN-680122INTEGER
   DEFINE g_group LIKE type_file.chr20,              #No.FUN-680122CHAR(20)
           g_tname1   LIKE type_file.chr20,          #No.FUN-680122CHAR(20)               #tmpfile name
           g_delsql1  LIKE type_file.chr1000               #execute sys_cmd        #No.FUN-680122CHAR(50)
   DEFINE  #multi fac
           g_delsql   LIKE type_file.chr1000,              #execute sys_cmd        #No.FUN-680122CHAR(50)
           g_tname    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20),         #tmpfile name
           g_idx,g_k  LIKE type_file.num10,          #No.FUN-680122INTEGER,
           g_ary DYNAMIC ARRAY OF RECORD          #被選擇之工廠
           plant      LIKE cre_file.cre08,          #No.FUN-680122CHAR(10)
           dbs_new    LIKE type_file.chr21          #No.FUN-680122CHAR(21)
           END RECORD ,
           g_tmp DYNAMIC ARRAY OF RECORD          #被選擇之工廠
           p          LIKE cre_file.cre08,          #No.FUN-680122CHAR(10)
           d          LIKE type_file.chr21          #No.FUN-680122CHAR(21)
           END RECORD
   DEFINE  #dpm
           g_sum RECORD
            #  qty     LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)  #數量(內銷)#FUN-A20044
              qty     LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)  #數量(內銷)#FUN-A20044
              amt     LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #金額(內銷)
              cost    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6) #成本(內銷)
            #  qty1    LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)  #數量(內退)#FUN-A20044
              qty1    LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)  #數量(內退)#FUN-A20044
              amt1    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #金額(內退)
              cost1   LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)  #成本(內退)
              dae_amt LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6) #折讓
              dac_amt LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)  #雜項發票
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE m_legal           ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   LET tm.plant_1 = g_ary[1].plant
   LET tm.plant_2 = g_ary[2].plant
   LET tm.plant_3 = g_ary[3].plant
   LET tm.plant_4 = g_ary[4].plant
   LET tm.plant_5 = g_ary[5].plant
   LET tm.plant_6 = g_ary[6].plant
   LET tm.plant_7 = g_ary[7].plant
   LET tm.plant_8 = g_ary[8].plant
 
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_wc    = ARG_VAL(7)
   LET tm.title= ARG_VAL(8)
   LET tm.data = ARG_VAL(9)
   LET tm.order= ARG_VAL(10)
   LET tm.yy1_b= ARG_VAL(11)
   LET tm.mm1_b= ARG_VAL(12)
   LET tm.mm1_e= ARG_VAL(13)
   LET tm.yy2_b= ARG_VAL(14)
   LET tm.mm2_b= ARG_VAL(15)
   LET tm.mm2_e= ARG_VAL(16)
   LET tm.yy3_b= ARG_VAL(17)
   LET tm.mm3_b= ARG_VAL(18)
   LET tm.mm3_e= ARG_VAL(19)
   LET tm.yy4_b= ARG_VAL(20)
   LET tm.mm4_b= ARG_VAL(21)
   LET tm.mm4_e= ARG_VAL(22)
   LET tm.yy5_b= ARG_VAL(23)
   LET tm.mm5_b= ARG_VAL(24)
   LET tm.mm5_e= ARG_VAL(25)
   LET tm.yy6_b= ARG_VAL(26)
   LET tm.mm6_b= ARG_VAL(27)
   LET tm.mm6_e= ARG_VAL(28)
   LET tm.yy7_b= ARG_VAL(29)
   LET tm.mm7_b= ARG_VAL(30)
   LET tm.mm7_e= ARG_VAL(31)
   LET tm.yy8_b= ARG_VAL(32)
   LET tm.mm8_b= ARG_VAL(33)
   LET tm.mm8_e= ARG_VAL(34)
   LET tm.yy9_b= ARG_VAL(35)
   LET tm.mm9_b  = ARG_VAL(36)
   LET tm.mm9_e  = ARG_VAL(37)
   LET tm.yy10_b = ARG_VAL(38)
   LET tm.mm10_b = ARG_VAL(39)
   LET tm.mm10_e = ARG_VAL(40)
   LET tm.yy11_b = ARG_VAL(41)
   LET tm.mm11_b = ARG_VAL(42)
   LET tm.mm11_e = ARG_VAL(43)
   LET tm.plant_1= ARG_VAL(44)
   LET tm.plant_2= ARG_VAL(45)
   LET tm.plant_3= ARG_VAL(46)
   LET tm.plant_4= ARG_VAL(47)
   LET tm.plant_5= ARG_VAL(48)
   LET tm.plant_6= ARG_VAL(49)
   LET tm.plant_7= ARG_VAL(50)
   LET tm.plant_8= ARG_VAL(51)
   LET tm.azk01= ARG_VAL(52)
   LET tm.azk04= ARG_VAL(53)
   LET tm.type = ARG_VAL(62)                   #No.FUN-7C0101
   LET tm.dec= ARG_VAL(54)
   LET tm.p_group = ARG_VAL(55)
   LET tm.p_group1= ARG_VAL(56)
   LET tm.sum_code= ARG_VAL(57)
   LET g_rep_user = ARG_VAL(58)
   LET g_rep_clas = ARG_VAL(59)
   LET g_template = ARG_VAL(60)
   LET g_bookno = ARG_VAL(61)
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r150_tm(0,0)
   ELSE  
      CALL r150()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r150_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_date         LIKE type_file.dat,           #No.FUN-680122DATE
          l_cmd          LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
   DEFINE li_result      LIKE type_file.num5           #No.FUN-940102
   DEFINE l_cnt          LIKE type_file.num5           #No.FUN-A70084
 
   LET p_row = 1 LET p_col = 6
 
   OPEN WINDOW r150_w AT p_row,p_col WITH FORM "axc/42f/axcr150"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')

   CALL r150_set_entry() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL
   LET tm.dec= '1'
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
   LET tm.data = '1'
   LET tm.order = 0
   LET tm.title= '1'
   LET tm.p_group= 'N'
   LET tm.p_group1= 'Y'
   LET tm.more = 'N'
   LET tm.sum_code = 'N'
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.yy2_b = g_ccz.ccz01
   LET tm.yy3_b = g_ccz.ccz01
   LET tm.yy4_b = g_ccz.ccz01
   LET tm.yy5_b = g_ccz.ccz01
   LET tm.yy6_b = g_ccz.ccz01
   LET tm.yy7_b = g_ccz.ccz01
   LET tm.yy8_b = g_ccz.ccz01
   LET tm.yy9_b = g_ccz.ccz01
   LET tm.yy10_b = g_ccz.ccz01
   LET tm.yy11_b = g_ccz.ccz01
   LET tm.yy12_b = g_ccz.ccz01
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm2_b = 0
   LET tm.mm3_b = 0
   LET tm.mm4_b = 0
   LET tm.mm5_b = 0
   LET tm.mm6_b = 0
   LET tm.mm7_b = 0
   LET tm.mm8_b = 0
   LET tm.mm9_b = 0
   LET tm.mm10_b = 0
   LET tm.mm11_b = 0
   LET tm.mm12_b = 0
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.mm2_e = 0
   LET tm.mm3_e = 0
   LET tm.mm4_e = 0
   LET tm.mm5_e = 0
   LET tm.mm6_e = 0
   LET tm.mm7_e = 0
   LET tm.mm8_e = 0
   LET tm.mm9_e = 0
   LET tm.mm10_e = 0
   LET tm.mm11_e = 0
   LET tm.mm12_e = 0
   LET tm.azk01= g_aza.aza17  #No:8488
   LET tm.azk04=1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
 
WHILE TRUE
   LET g_wc=NULL
 
   CONSTRUCT g_wc ON ima01,ima131,ima12,ima11
   FROM ima01,ima131,ima12,ima11
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
       
   IF g_wc = ' 1=1' THEN                    #FUN-870151
      CALL cl_err('','9046',0)              #FUN-870151
      CONTINUE WHILE                        #FUN-870151
   END IF                                   #FUN-870151
 
   INPUT BY NAME
              tm.title,
              tm.data,
              tm.order,
              tm.yy1_b,tm.mm1_b,tm.mm1_e,
              tm.yy2_b,tm.mm2_b,tm.mm2_e,
              tm.yy3_b,tm.mm3_b,tm.mm3_e,
              tm.yy4_b,tm.mm4_b,tm.mm4_e,
              tm.yy5_b,tm.mm5_b,tm.mm5_e,
              tm.yy6_b,tm.mm6_b,tm.mm6_e,
              tm.yy7_b,tm.mm7_b,tm.mm7_e,
              tm.yy8_b,tm.mm8_b,tm.mm8_e,
              tm.yy9_b,tm.mm9_b,tm.mm9_e,
              tm.yy10_b,tm.mm10_b,tm.mm10_e,
              tm.yy11_b,tm.mm11_b,tm.mm11_e,
              tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
              tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,
              tm.azk01,
              tm.azk04,
              tm.type,               #No.FUN-7C0101
              tm.dec,
              tm.p_group,
              tm.p_group1,
              tm.sum_code,
              tm.more
 
   WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD data
           IF tm.data NOT MATCHES '[12]' THEN
              NEXT FIELD data
           END IF
 
         AFTER FIELD order
           IF tm.order <0 OR tm.order > 13  THEN
              NEXT FIELD order
           END IF
 
         BEFORE FIELD plant_1
             LET tm.plant_1 = g_plant
             DISPLAY tm.plant_1 TO FORMONLY.plant_1
             IF g_multpl= 'N' THEN             # 不為多工廠環境
                LET tm.plant_1 = g_plant
                LET g_plant_new = NULL
                LET g_dbs_new   = NULL
                LET g_ary[1].plant = g_plant
                LET g_ary[1].dbs_new = g_dbs_new
                DISPLAY tm.plant_1 TO FORMONLY.plant_1
                NEXT FIELD azk01
             END IF
 
         AFTER FIELD plant_1
             LET g_plant_new = tm.plant_1
             IF tm.plant_1 = g_plant  THEN
                LET g_dbs_new =' '
                LET g_ary[1].plant = tm.plant_1
                LET g_ary[1].dbs_new = g_dbs_new
                LET m_legal[1] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_1) THEN
                                #檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_1) THEN
                     CALL cl_err(tm.plant_1,g_errno,0)
                     NEXT FIELD plant_1
                   END IF
                   LET g_ary[1].plant = tm.plant_1
                   LET g_ary[1].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_1) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_1
                END IF 
                ELSE            # 輸入之工廠編號為' '或NULL
                   LET g_ary[1].plant = tm.plant_1
                END IF
             END IF
             
         AFTER FIELD plant_2
             LET tm.plant_2 = duplicate(tm.plant_2,1)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_2
             IF tm.plant_2 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[2].plant = tm.plant_2
                LET g_ary[2].dbs_new = g_dbs_new
                LET m_legal[2] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_2) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_2) THEN
                     CALL cl_err(tm.plant_2,g_errno,0)
                     NEXT FIELD plant_2
                   END IF
                   LET g_ary[2].plant = tm.plant_2
                   LET g_ary[2].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.plant_2   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_2) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_2
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[2].plant = tm.plant_2
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_2) THEN
                IF NOT r150_chklegal(m_legal[2],1) THEN
                   CALL cl_err(tm.plant_2,g_errno,0)
                   NEXT FIELD plant_2
                END IF
             END IF
             #FUN-A70084--add--end

         AFTER FIELD plant_3
             LET tm.plant_3 = duplicate(tm.plant_3,2)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_3
             IF tm.plant_3 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[3].plant = tm.plant_3
                LET g_ary[3].dbs_new = g_dbs_new
                LET m_legal[3] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_3) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_3) THEN
                     CALL cl_err(tm.plant_3,g_errno,0)
                     NEXT FIELD plant_3
                   END IF
                   LET g_ary[3].plant = tm.plant_3
                   LET g_ary[3].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.plant_3   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_3) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_3
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[3].plant = tm.plant_3
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_3) THEN
                IF NOT r150_chklegal(m_legal[3],2) THEN
                   CALL cl_err(tm.plant_3,g_errno,0)
                   NEXT FIELD plant_3
                END IF
             END IF
             #FUN-A70084--add--end

 
         AFTER FIELD plant_4
             LET tm.plant_4 = duplicate(tm.plant_4,3)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_4
             IF tm.plant_4 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[4].plant = tm.plant_4
                LET g_ary[4].dbs_new = g_dbs_new
                LET m_legal[4] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_4) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_4) THEN
                     CALL cl_err(tm.plant_4,g_errno,0)
                     NEXT FIELD plant_4
                   END IF
                   LET g_ary[4].plant = tm.plant_4
                   LET g_ary[4].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.plant_4  #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_4) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_4
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[4].plant = tm.plant_4
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_4) THEN
                IF NOT r150_chklegal(m_legal[4],3) THEN
                   CALL cl_err(tm.plant_4,g_errno,0)
                   NEXT FIELD plant_4
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD plant_5
             LET tm.plant_5 = duplicate(tm.plant_5,4)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_5
             IF tm.plant_5 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[5].plant = tm.plant_5
                LET g_ary[5].dbs_new = g_dbs_new
                LET m_legal[5] = g_legal   #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_5) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_5) THEN
                     CALL cl_err(tm.plant_5,g_errno,0)
                     NEXT FIELD plant_5
                   END IF
                   LET g_ary[5].plant = tm.plant_5
                   LET g_ary[5].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.plant_5  #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_5) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_5
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[5].plant = tm.plant_5
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_5) THEN
                IF NOT r150_chklegal(m_legal[5],4) THEN
                   CALL cl_err(tm.plant_5,g_errno,0)
                   NEXT FIELD plant_5
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD plant_6
             LET tm.plant_6 = duplicate(tm.plant_6,5)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_6
             IF tm.plant_6 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[6].plant = tm.plant_6
                LET g_ary[6].dbs_new = g_dbs_new
                LET m_legal[6] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_6) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_6) THEN
                     CALL cl_err(tm.plant_6,g_errno,0)
                     NEXT FIELD plant_6
                   END IF
                   LET g_ary[6].plant = tm.plant_6
                   LET g_ary[6].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.plant_6   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_6) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_6
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[6].plant = tm.plant_6
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_6) THEN
                IF NOT r150_chklegal(m_legal[6],5) THEN
                   CALL cl_err(tm.plant_6,g_errno,0)
                   NEXT FIELD plant_6
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD plant_7
             LET tm.plant_7 = duplicate(tm.plant_7,6)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_7
             IF tm.plant_7 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[7].plant = tm.plant_7
                LET g_ary[7].dbs_new = g_dbs_new
                LET m_legal[7] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_7) THEN
                  # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_7) THEN
                     CALL cl_err(tm.plant_7,g_errno,0)
                     NEXT FIELD plant_7
                   END IF
                   LET g_ary[7].plant = tm.plant_7
                   LET g_ary[7].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.plant_7  #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_7) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_7
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[7].plant = tm.plant_7
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_7) THEN
                IF NOT r150_chklegal(m_legal[7],6) THEN
                   CALL cl_err(tm.plant_7,g_errno,0)
                   NEXT FIELD plant_7
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD plant_8
             LET tm.plant_8 = duplicate(tm.plant_8,7)  # 不使工廠編號重覆
             LET g_plant_new = tm.plant_8
             IF tm.plant_8 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[8].plant = tm.plant_8
                LET g_ary[8].dbs_new = g_dbs_new
                LET m_legal[8] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_8) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r150_chkplant(tm.plant_8) THEN
                     CALL cl_err(tm.plant_8,g_errno,0)
                     NEXT FIELD plant_8
                   END IF
                   LET g_ary[8].plant = tm.plant_8
                   LET g_ary[8].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
               CALL s_chk_demo(g_user,tm.plant_8) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD plant_8
                END IF 
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[8].plant = tm.plant_8
                END IF
             END IF
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r150_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD azk01
             IF NOT cl_null(tm.azk01) THEN
                SELECT * FROM azi_file
                WHERE azi01 = tm.azk01
                IF STATUS != 0 THEN
                   CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)   #No.FUN-660127
                   NEXT FIELD azk01
                END IF
 
                # azk04 賣出匯率
                SELECT MAX(azk02) INTO l_date FROM azk_file
                SELECT azk04 INTO tm.azk04 FROM azk_file
                WHERE azk01 = tm.azk01 AND azk02 =l_date
                DISPLAY BY NAME  tm.azk04
             ELSE
                LET tm.azk04 = 0
                DISPLAY BY NAME tm.azk04
             END IF
 
           AFTER FIELD azk04                                  #FUN-4C0071
             IF NOT cl_null(tm.azk04) THEN
                IF tm.azk01=g_aza.aza17 THEN
                   LET tm.azk04=1
                   DISPLAY tm.azk04 TO azk04
                END IF
             END IF
 
         AFTER FIELD type                                                            #No.FUN-7C0101
           IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF              #No.FUN-7C0101
 
         AFTER FIELD dec
           IF tm.dec NOT MATCHES '[123]' THEN NEXT FIELD dec END IF
           CASE tm.dec WHEN 1 LET g_base = 1
                       WHEN 2 LET g_base = 1000
                       WHEN 3 LET g_base = 10000
                       OTHERWISE NEXT FIELD dec
           END CASE
 
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(plant_1)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_1
                    CALL cl_create_qry() RETURNING tm.plant_1
                    DISPLAY BY NAME tm.plant_1
                    NEXT FIELD plant_1
 
               WHEN INFIELD(plant_2)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_2
                    CALL cl_create_qry() RETURNING tm.plant_2
                    DISPLAY BY NAME tm.plant_2
                    NEXT FIELD plant_2
 
               WHEN INFIELD(plant_3)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_3
                    CALL cl_create_qry() RETURNING tm.plant_3
                    DISPLAY BY NAME tm.plant_3
                    NEXT FIELD plant_3
 
               WHEN INFIELD(plant_4)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_4
                    CALL cl_create_qry() RETURNING tm.plant_4
                    DISPLAY BY NAME tm.plant_4
                    NEXT FIELD plant_4
 
               WHEN INFIELD(plant_5)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_5
                    CALL cl_create_qry() RETURNING tm.plant_5
                    DISPLAY BY NAME tm.plant_5
                    NEXT FIELD plant_5
 
               WHEN INFIELD(plant_6)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_6
                    CALL cl_create_qry() RETURNING tm.plant_6
                    DISPLAY BY NAME tm.plant_6
                    NEXT FIELD plant_6
 
               WHEN INFIELD(plant_7)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_7
                    CALL cl_create_qry() RETURNING tm.plant_7
                    DISPLAY BY NAME tm.plant_7
                    NEXT FIELD plant_7
 
               WHEN INFIELD(plant_8)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                    LET g_qryparam.arg1 = g_user    #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_8
                    CALL cl_create_qry() RETURNING tm.plant_8
                    DISPLAY BY NAME tm.plant_8
                    NEXT FIELD plant_8
 
                WHEN INFIELD(azk01) #幣別檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = tm.azk01
                     CALL cl_create_qry() RETURNING tm.azk01
                     DISPLAY BY NAME tm.azk01
                     NEXT FIELD azk01
                WHEN INFIELD(azk04)
                     CALL s_rate(tm.azk01,tm.azk04) RETURNING tm.azk04
                     DISPLAY BY NAME tm.azk04
                     NEXT FIELD azk04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()
 
         AFTER INPUT
             IF INT_FLAG THEN
                EXIT INPUT
             END IF
             IF cl_null(tm.azk01) THEN
                LET tm.azk04 = 0
                DISPLAY BY NAME tm.azk04
             END IF
##
 
             IF cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND
                cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
                cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
                cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt <=1 THEN   #FUN-A70084 add l_cnt<=1
                CALL cl_err(0,'aap-136',0)
                NEXT FIELD plant_1
             END IF
           #FUN-A70084--add--str--
           IF l_cnt >1 THEN
              LET g_k = 1
              LET g_ary[1].plant = g_plant
           ELSE
           #FUN-A70084--add--end
             LET g_k=0
             FOR g_idx = 1  TO  8
                 IF cl_null(g_ary[g_idx].plant) THEN
                    CONTINUE FOR
                 END IF
                 LET g_k=g_k+1
                 LET g_tmp[g_k].p=g_ary[g_idx].plant
                 LET g_tmp[g_k].d=g_ary[g_idx].dbs_new
             END FOR
             FOR g_idx = 1  TO 8
                 IF  g_idx > g_k THEN
                     LET g_ary[g_idx].plant=NULL
                     LET g_ary[g_idx].dbs_new=NULL
                 ELSE
                     LET g_ary[g_idx].plant=g_tmp[g_idx].p
                     LET g_ary[g_idx].dbs_new=g_tmp[g_idx].d
                 END IF
             END FOR
            END IF   #FUN-A70084
             LET g_ym[1].yy_e=tm.yy1_b
             LET g_ym[2].yy_e=tm.yy2_b
             LET g_ym[3].yy_e=tm.yy3_b
             LET g_ym[4].yy_e=tm.yy4_b
             LET g_ym[5].yy_e=tm.yy5_b
             LET g_ym[6].yy_e=tm.yy6_b
             LET g_ym[7].yy_e=tm.yy7_b
             LET g_ym[8].yy_e=tm.yy8_b
             LET g_ym[9].yy_e=tm.yy9_b
             LET g_ym[10].yy_e=tm.yy10_b
             LET g_ym[11].yy_e=tm.yy11_b
             LET g_ym[12].yy_e=tm.yy12_b
             LET g_ym[1].mm_b=tm.mm1_b
             LET g_ym[2].mm_b=tm.mm2_b
             LET g_ym[3].mm_b=tm.mm3_b
             LET g_ym[4].mm_b=tm.mm4_b
             LET g_ym[5].mm_b=tm.mm5_b
             LET g_ym[6].mm_b=tm.mm6_b
             LET g_ym[7].mm_b=tm.mm7_b
             LET g_ym[8].mm_b=tm.mm8_b
             LET g_ym[9].mm_b=tm.mm9_b
             LET g_ym[10].mm_b=tm.mm10_b
             LET g_ym[11].mm_b=tm.mm11_b
             LET g_ym[12].mm_b=tm.mm12_b
             LET g_ym[1].mm_e=tm.mm1_e
             LET g_ym[2].mm_e=tm.mm2_e
             LET g_ym[3].mm_e=tm.mm3_e
             LET g_ym[4].mm_e=tm.mm4_e
             LET g_ym[5].mm_e=tm.mm5_e
             LET g_ym[6].mm_e=tm.mm6_e
             LET g_ym[7].mm_e=tm.mm7_e
             LET g_ym[8].mm_e=tm.mm8_e
             LET g_ym[9].mm_e=tm.mm9_e
             LET g_ym[10].mm_e=tm.mm10_e
             LET g_ym[11].mm_e=tm.mm11_e
             LET g_ym[12].mm_e=tm.mm12_e
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr150','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.title CLIPPED,"'",
                         " '",tm.data  CLIPPED,"'",
                         " '",tm.order CLIPPED,"'",
                         " '",tm.yy1_b CLIPPED,"'",
                         " '",tm.mm1_b CLIPPED,"'",
                         " '",tm.mm1_e CLIPPED,"'",
                         " '",tm.yy2_b CLIPPED,"'",
                         " '",tm.mm2_b CLIPPED,"'",
                         " '",tm.mm2_e CLIPPED,"'",
                         " '",tm.yy3_b CLIPPED,"'",
                         " '",tm.mm3_b CLIPPED,"'",
                         " '",tm.mm3_e CLIPPED,"'",
                         " '",tm.yy4_b CLIPPED,"'",
                         " '",tm.mm4_b CLIPPED,"'",
                         " '",tm.mm4_e CLIPPED,"'",
                         " '",tm.yy5_b CLIPPED,"'",
                         " '",tm.mm5_b CLIPPED,"'",
                         " '",tm.mm5_e CLIPPED,"'",
                         " '",tm.yy6_b CLIPPED,"'",
                         " '",tm.mm6_b CLIPPED,"'",
                         " '",tm.mm6_e CLIPPED,"'",
                         " '",tm.yy7_b CLIPPED,"'",
                         " '",tm.mm7_b CLIPPED,"'",
                         " '",tm.mm7_e CLIPPED,"'",
                         " '",tm.yy8_b CLIPPED,"'",
                         " '",tm.mm8_b CLIPPED,"'",
                         " '",tm.mm8_e CLIPPED,"'",
                         " '",tm.yy9_b CLIPPED,"'",
                         " '",tm.mm9_b CLIPPED,"'",
                         " '",tm.mm9_e CLIPPED,"'",
                         " '",tm.yy10_b  CLIPPED,"'",
                         " '",tm.mm10_b  CLIPPED,"'",
                         " '",tm.mm10_e  CLIPPED,"'",
                         " '",tm.yy11_b  CLIPPED,"'",
                         " '",tm.mm11_b  CLIPPED,"'",
                         " '",tm.mm11_e  CLIPPED,"'",
                         " '",tm.plant_1 CLIPPED,"'",
                         " '",tm.plant_2 CLIPPED,"'",
                         " '",tm.plant_3 CLIPPED,"'",
                         " '",tm.plant_4 CLIPPED,"'",
                         " '",tm.plant_5 CLIPPED,"'",
                         " '",tm.plant_6 CLIPPED,"'",
                         " '",tm.plant_7 CLIPPED,"'",
                         " '",tm.plant_8 CLIPPED,"'",
                         " '",tm.azk01 CLIPPED,"'",
                         " '",tm.azk04 CLIPPED,"'",
                         " '",tm.type  CLIPPED,"'",                         #No.FUN-7C0101
                         " '",tm.dec  CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template  CLIPPED,"'",
                         " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr150',g_time,l_cmd)    # Execute cmd at later time
      END IF                     
      CLOSE WINDOW axcr111_w     
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r150()
   ERROR ""
END WHILE
   CLOSE WINDOW r150_w
END FUNCTION
 
FUNCTION r150()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(2000)
          l_item    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_ima01   LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_tmp     LIKE type_file.chr8,           #No.FUN-680122CHAR(8)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_flag    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_cta     RECORD
              item   LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
              tdesc  LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(30)
              ima01  LIKE ima_file.ima01,          #No.FUN-680122CHAR(20)
              ima02  LIKE ima_file.ima02,          #No.FUN-680122 VARCHAR(30)
              mm     LIKE type_file.num5,          #No.FUN-680122SMALLINT
              ccc08  LIKE ccc_file.ccc08,          #No.FUN-7C0101
           #   qty    LIKE ima_file.ima26,          #No.FUN-680122DEC(15,3)#FUN-A20044
              qty    LIKE type_file.num15_3,          #No.FUN-680122DEC(15,3)#FUN-A20044
              amt    LIKE oeb_file.oeb13,          #No.FUN-680122 DECIMAL(20,6)
              cost   LIKE oeb_file.oeb13           #No.FUN-680122DEC(20,6)
              END RECORD,
          sr  RECORD
              order  LIKE type_file.num10,        #No.FUN-680122INTEGER
              item   LIKE type_file.chr20,        #No.FUN-680122CHAR(20)
              gaa02  LIKE type_file.chr1000,      #No.FUN-680122 VARCHAR(30)
              ima01  LIKE ima_file.ima01,         #No.FUN-680122CHAR(20)
              ccc08  LIKE ccc_file.ccc08,         #No.FUN-7C0101
              ima02  LIKE ima_file.ima01,         #No.FUN-680122 VARCHAR(30)
           #   qty1   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty1   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost1  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
           #  qty2   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
             qty2   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt2   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost2  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  qty3   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty3   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt3   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost3  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  qty4   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty4   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt4   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost4  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
             # qty5   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty5   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt5   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost5  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
             # qty6   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty6   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt6   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost6  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
             # qty7   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty7   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt7   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost7  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  qty8   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty8   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt8   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost8  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
             # qty9   LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty9   LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt9   LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost9  LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  qty10  LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty10  LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt10  LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost10 LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  qty11  LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)
              qty11  LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt11  LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost11 LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
           #   qty12  LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty12  LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt12  LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost12 LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)
            #  tl_qty LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              tl_qty LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              tl_amt LIKE oeb_file.oeb13,        #No.FUN-680122 DECIMAL(20,6)
              tl_cost LIKE oeb_file.oeb13        #No.FUN-680122DEC(20,6)
              END RECORD
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr150'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     # 定義報表之寬度
     FOR g_i = 1 TO g_len
	 LET g_dash2[g_i,g_i] = '='
	 LET g_dash3[g_i,g_i] = '-'
     END FOR
     #Oracle 在Finish Report會把 Table 關掉，
     #所以將Create Table 放在此處------------------------------
 
     LET g_tname='r150_tmp'                           #No.TQC-980163 mod
     LET g_delsql= " DROP TABLE ",g_tname CLIPPED
     PREPARE del_cmd FROM g_delsql
     EXECUTE del_cmd
     LET tmp_sql=
           #FUN-A10098   ---start--- 
           #   "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
           #  "(item   VARCHAR(20),",
           #  " tdesc  VARCHAR(30),",
           #  " ima01  VARCHAR(40),",
           #  " ima02  VARCHAR(40),",
           #  " mm     SMALLINT,",
           #  " ccc08  VARCHAR(40),",                                     #No.FUN-7C0101
           #  " qty    DEC(15,3),",
           #  " amt    DEC(20,6),",
           #  " cost   DEC(20,6))"
              "CREATE TEMP TABLE ",g_tname CLIPPED,
            "(item   LIKE type_file.chr20, ",
            " tdesc  LIKE type_file.chr30,",
            " ima01  LIKE ima_file.ima01,",
            " ima02  LIKE ima_file.ima02,",
            " mm     LIKE ima_file.ima89,",
            " ccc08  LIKE ima_file.ima01,",
            " qty    LIKE type_file.num15_3,",#FUN-A20044  #No.TQC-A40130
            " amt    LIKE ima_file.ima32,",
            " cost   LIKE ima_file.ima32)"
           #FUN-A10098  ---end---
 
     PREPARE cre_p1 FROM tmp_sql
     EXECUTE cre_p1
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err(g_tname ,SQLCA.sqlcode,1)   
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
 
     LET g_tname1='r150_tmp1'                      #No.TQC-980163 mod
     LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
     PREPARE del_dpm FROM g_delsql1
     EXECUTE del_dpm  #no.6446
     LET tmp_sql=
        #NO.FUN-A10098 ---start---
        # "CREATE TEMP TABLE ",g_tname1 CLIPPED,  #No.TQC-970305 mod
        #     "(ima01  VARCHAR(40),",   #MOD-8C0086 modify 20->40
        #     " item   VARCHAR(20),",
        #     " ima02  VARCHAR(30),",
        #     " mm     SMALLINT,",
        #     " qty    DEC(15,3),",  #數量(銷)
        #     " amt    DEC(20,6),",  #金額(銷)
        #     " cost   DEC(20,6),",  #成本(銷)
        #     " qty1   DEC(15,3),",  #數量(退)
        #     " amt1   DEC(20,6),",  #金額(退)
        #     " cost1  DEC(20,6),",  #成本(退)
        #     " dae_amt DEC(20,6),", #折讓
        #     " dac_amt DEC(20,6))" #雜項發票
        "CREATE TEMP TABLE ",g_tname1 CLIPPED,
             "(ima01   LIKE ima_file.ima01,",
             " item    LIKE ima_file.ima03,",
             " ima02   LIKE type_file.chr30,",
             " mm      LIKE ima_file.ima89,",
             " qty     LIKE type_file.num15_3,", #FUN-A20044  #No.TQC-A40130
             " amt     LIKE ima_file.ima32,",
             " cost    LIKE ima_file.ima32,",
             " qty1    LIKE type_file.num15_3,",#FUN-A20044  #No.TQC-A40130
             " amt1    LIKE ima_file.ima32,",
             " cost1   LIKE ima_file.ima32,",
             " dae_amt LIKE ima_file.ima32,",
             " dac_amt LIKE ima_file.ima32)"  
        #FUN-A10098  ---end---
    PREPARE cre_dpm FROM tmp_sql
    EXECUTE cre_dpm
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('Create tmp_dpm:' ,SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
 
     CALL get_tmpfile()
     IF tm.p_group matches '[Yy]' THEN #要印料件
        IF tm.p_group1 matches '[Yy]' THEN #要印分類
           LET l_sql=" SELECT item,'',ima01,'',mm,ccc08,sum(qty),sum(amt),",                      #No.FUN-7C0101
             " sum(cost) ", " FROM ",g_tname,
             " GROUP BY item,ima01,mm,ccc08 ORDER BY item,ima01,mm,ccc08"
        ELSE
           LET l_sql=" SELECT '','',ima01,'',mm,ccc08,sum(qty),sum(amt),",                        #No.FUN-7C0101 
             " sum(cost) ", " FROM ",g_tname,
             " GROUP BY ima01,mm,ccc08 ORDER BY ima01,mm,ccc08"
        END IF
     ELSE
        IF tm.p_group1 matches '[Yy]' THEN #要印分類
           LET l_sql=" SELECT item,'','','',mm,ccc08,sum(qty),sum(amt),",                         #No.FUN-7C0101 
             " sum(cost) ", " FROM ",g_tname,
             " GROUP BY item,mm,ccc08 ORDER BY item,mm,ccc08"
        ELSE
           LET l_sql=" SELECT '','','','',mm,ccc08,sum(qty),sum(amt),",                           #No.FUN-7C0101
             " sum(cost) ", " FROM ",g_tname,
             " GROUP BY mm,ccc08 ORDER BY mm,ccc08"
        END IF
     END IF
	     PREPARE r150_prepare1 FROM l_sql
	     IF SQLCA.sqlcode != 0 THEN
		CALL cl_err('prepare1:',SQLCA.sqlcode,1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
		EXIT PROGRAM
	     END IF
	     DECLARE r150_curs1 CURSOR FOR r150_prepare1
 
	     CALL cl_outnam('axcr150') RETURNING l_name
              FOR i=1 TO 12                                                                                                          
               IF g_ym[i].mm_b=0 THEN                                                                                               
                  LET g_zaa[33+i].zaa06='Y'                                                                                         
               ELSE                                                                                                                 
                  LET g_zaa[33+i].zaa06='N'                                                                                         
               END IF                                                                                                               
             END FOR                                                                                                                
             IF tm.type MATCHES '[12]' THEN
                LET g_zaa[32].zaa06 = "Y" 
             ELSE
                LET g_zaa[32].zaa06 = "N"
             END IF
             CALL cl_prt_pos_len()
	     START REPORT r150_rep TO l_name
	     LET g_pageno = 0
             LET l_flag=null
             LET l_item=null
             LET l_ima01=null
             LET sr.tl_qty=0
             LET sr.tl_amt=0
             LET sr.tl_cost=0
	     FOREACH r150_curs1 INTO l_cta.*
               IF l_cta.item IS NULL OR l_cta.item='' THEN
                  LET l_cta.item='0'
               END IF
	       IF SQLCA.sqlcode != 0 THEN
	          CALL cl_err('foreach:',SQLCA.sqlcode,1)
               END IF
               IF l_cta.amt IS NULL THEN LET l_cta.amt = 0 END IF
               IF l_cta.cost IS NULL THEN LET l_cta.cost = 0 END IF
               IF l_cta.qty IS NULL THEN LET l_cta.qty = 0 END IF
               IF l_flag IS NULL THEN
                  LET l_ima01=l_cta.ima01
                  LET l_item=l_cta.item
                  LET l_flag='N'
               END IF
               LET l_cta.amt=l_cta.amt/g_base
               LET l_cta.cost=l_cta.cost/g_base
               IF tm.azk04 >0 THEN
                  LET l_cta.amt=l_cta.amt/tm.azk04
                  LET l_cta.cost=l_cta.cost/tm.azk04
               END IF
               IF (l_item <> l_cta.item OR l_ima01 <> l_cta.ima01) THEN
                     IF sr.tl_qty <> 0 OR sr.tl_amt <>0 OR sr.tl_cost <>0 THEN
                        LET sr.order=get_order(sr.*)
                        OUTPUT TO REPORT r150_rep(sr.*)
                        INITIALIZE sr.* TO NULL
                        LET sr.tl_qty=0
                        LET sr.tl_amt=0
                        LET sr.tl_cost=0
                     END IF
               END IF
               LET l_ima01=l_cta.ima01
               LET l_item=l_cta.item
               LET sr.ima01=l_cta.ima01
               LET sr.item=l_cta.item
               LET sr.ima02=l_cta.ima02
               LET sr.gaa02=l_cta.tdesc
               CASE l_cta.mm
               WHEN 1
                 LET sr.qty1=l_cta.qty
                 LET sr.amt1=l_cta.amt
                 LET sr.cost1=l_cta.cost
               WHEN 2
                 LET sr.qty2=l_cta.qty
                 LET sr.amt2=l_cta.amt
                 LET sr.cost2=l_cta.cost
               WHEN 3
                 LET sr.qty3=l_cta.qty
                 LET sr.amt3=l_cta.amt
                 LET sr.cost3=l_cta.cost
               WHEN 4
                 LET sr.qty4=l_cta.qty
                 LET sr.amt4=l_cta.amt
                 LET sr.cost4=l_cta.cost
               WHEN 5
                 LET sr.qty5=l_cta.qty
                 LET sr.amt5=l_cta.amt
                 LET sr.cost5=l_cta.cost
               WHEN 6
                 LET sr.qty6=l_cta.qty
                 LET sr.amt6=l_cta.amt
                 LET sr.cost6=l_cta.cost
               WHEN 7
                 LET sr.qty7=l_cta.qty
                 LET sr.amt7=l_cta.amt
                 LET sr.cost7=l_cta.cost
               WHEN 8
                 LET sr.qty8=l_cta.qty
                 LET sr.amt8=l_cta.amt
                 LET sr.cost8=l_cta.cost
               WHEN 9
                 LET sr.qty9=l_cta.qty
                 LET sr.amt9=l_cta.amt
                 LET sr.cost9=l_cta.cost
               WHEN 10
                 LET sr.qty10=l_cta.qty
                 LET sr.amt10=l_cta.amt
                 LET sr.cost10=l_cta.cost
               WHEN 11
                 LET sr.qty11=l_cta.qty
                 LET sr.amt11=l_cta.amt
                 LET sr.cost11=l_cta.cost
               WHEN 12
                 LET sr.qty12=l_cta.qty
                 LET sr.amt12=l_cta.amt
                 LET sr.cost12=l_cta.cost
               END CASE
               LET sr.tl_qty=sr.tl_qty+l_cta.qty
               LET sr.tl_amt=sr.tl_amt+l_cta.amt
               LET sr.tl_cost=sr.tl_cost+l_cta.cost
             END FOREACH
             IF sr.tl_qty<>0 OR sr.tl_amt<>0 OR sr.tl_cost<>0 THEN
                LET sr.order=get_order(sr.*)
                OUTPUT TO REPORT r150_rep(sr.*)
             END IF
     FINISH REPORT r150_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     LET g_delsql= " DROP TABLE ",g_tname CLIPPED
     PREPARE del_cmdm1 FROM g_delsql
     EXECUTE del_cmdm1
     LET g_delsql= " DROP TABLE ",g_tname1 CLIPPED
     PREPARE del_dpmm2 FROM g_delsql
     EXECUTE del_dpmm2
 
END FUNCTION
 
FUNCTION get_tmpfile()
DEFINE l_dot     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
DEFINE l_fd1     LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_fd2     LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_groupby LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_fd2x    LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_duc_sql LIKE type_file.chr1000        #No.FUN-680122CHAR(100)
DEFINE l_col    LIKE type_file.chr1000         #No.FUN-680122CHAR(100)
#DEFINE l_qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
DEFINE l_qty    LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
       l_amt    LIKE oeb_file.oeb13,           #No.FUN-680122 DECIMAL(20,6)
       l_cost   LIKE oeb_file.oeb13            #No.FUN-680122DEC(20,6)
#DEFINE       de_qty LIKE ima_file.ima26,          #No.FUN-680122DEC(15,3)
DEFINE       de_qty LIKE type_file.num15_3,          #No.FUN-680122DEC(15,3)#FUN-A20044
             de_amt  LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
             de_cost LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)
DEFINE gettmp   RECORD
              item   LIKE type_file.chr20,        #No.FUN-680122CHAR(20)
              tdesc  LIKE type_file.chr1000,      #No.FUN-680122 VARCHAR(30)
              ima01  LIKE ima_file.ima01,         #No.FUN-680122CHAR(20)
              ima02  LIKE ima_file.ima02,         #No.FUN-680122 VARCHAR(30)
              mm     LIKE type_file.num5,         #No.FUN-680122 # 期別
              ccc08  LIKe ccc_file.ccc08,         #No:MOD-960331 add
          #    qty    LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)#FUN-A20044
              qty    LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)#FUN-A20044
              amt    LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
              cost   LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)
       END RECORD
 
LET l_col = ""
 
    IF tm.data ='1'  THEN #資料選擇
       LET l_fd1=" ima131,''," #產品分類
    ELSE
       LET l_fd1=" ima11,''," #會計分類
    END IF
    IF tm.title='1' THEN #生產量值表
       LET l_fd1=l_fd1 CLIPPED,"ima01,'',"
       LET l_duc_sql= ' 1=1 '
         # 加總工單的
       LET l_fd2="sum(ccg32*-1) "
       LET l_fd2x="sum(ccu32*-1) "
       FOR g_idx=1 TO g_k
         FOR i=1 TO 12
          IF g_ym[i].mm_e=0 THEN CONTINUE FOR END IF
          LET l_groupby = l_fd1 CLIPPED     #FUN-5B0123
          IF cl_null(g_wc) THEN LET g_wc='1=1' END IF                                         #No.FUN-7C0101
          LET tmp_sql= " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,i,",ccg07,sum(ccg31*-1),",l_fd2 CLIPPED,",0",              #No.FUN-7C0101
        #FUN-A10098  ---A10098 ---- 
        # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          #" FROM ",cl_get_target_table(g_ary[g_idx].dbs_new,'ccg_file'),",",   #FUN-A80109
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",      #FUN-A80109
                   cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
        #FUN-A10098 ---A10098----
          " WHERE ",g_wc CLIPPED,
          " AND ccg02=",g_ym[i].yy_e,
          " AND ccg03 BETWEEN ",g_ym[i].mm_b," AND ",g_ym[i].mm_e,
          " AND ccg06='",tm.type,"'",                                                        #No.FUN-7C0101  #No.TQC-A40130
          " AND ima01 = ccg04 ",
          " AND ",l_duc_sql CLIPPED,
          " GROUP BY ",s_groupby(l_groupby CLIPPED),",ccg07"                                  #No.FUN-7C0101
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r854_prepare2 FROM tmp_sql
          EXECUTE r854_prepare2
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare2:',SQLCA.sqlcode,1)
             EXECUTE del_cmd #delete tmpfile
             CALL cl_used(g_prog,g_time,2) RETURNING g_time                                    #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM
          END IF
 
        END FOR #for i  ym
      END FOR  #for g_inx  dbs
    ELSE #銷售量值表
      LET l_fd1=l_fd1 CLIPPED,"ccc01,'',"
      IF tm.title>='3' THEN #3.銷售淨額 4.銷售毛額 5.毛利分析
         #           銷售淨量  銷售淨收入  銷售淨成本
         LET l_col=',(sum(ccc61*-1)+sum(ccc81*-1)),sum(ccc63),(sum(ccc62*-1)+sum(ccc82*-1))'  #No.FUN-660073
      END IF
      FOR g_idx=1 TO g_k
         FOR i=1 TO 12
          IF g_ym[i].mm_e=0 THEN CONTINUE FOR END IF
          LET l_groupby = l_fd1 CLIPPED     #FUN-5B0123
          IF tm.title = '3' OR tm.title = '5' THEN
             LET tmp_sql= " INSERT INTO ",g_tname,
                   " SELECT ",l_fd1 CLIPPED,i,",ccc08",l_col CLIPPED,                          #No.FUN-7C0101
#FUN-A10098  ---start--- 
#                  " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file ON ccc02=",g_ym[i].yy_e," AND ccc03 BETWEEN ",g_ym[i].mm_b," AND ",g_ym[i].mm_e,
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
 " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file')," ON ccc02=",g_ym[i].yy_e," AND ccc03 BETWEEN ",g_ym[i].mm_b," AND ",g_ym[i].mm_e,
#FUN-A10098  ---end---
"                                                                                      AND ccc07='",tm.type,"' AND ccc01=ima01 ",
                   " WHERE ",g_wc CLIPPED,
                   " GROUP BY ",s_groupby(l_groupby CLIPPED),",ccc08"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
             PREPARE r854_prepare3 FROM tmp_sql
             EXECUTE r854_prepare3
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare3:',SQLCA.sqlcode,1)
                EXECUTE del_cmd #delete tmpfile
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
                EXIT PROGRAM
             END IF
          ELSE #4.銷售毛額 -- > 要將銷退部份加回來
             CALL s_ymtodate(g_ym[i].yy_e,g_ym[i].mm_b,
                             g_ym[i].yy_e,g_ym[i].mm_e)
             RETURNING g_bdate,g_edate
             # 準備Insert Into Temp File
             LET tmp_sql= " INSERT INTO ",g_tname CLIPPED,
                          " (item, tdesc , ima01 , ima02,mm,ccc08, qty, amt,cost) ",#No.FUN-7C0101
                          " VALUES(?,?,?,?,?,?,?,?,?)"                              #No.FUN-7C0101
             PREPARE r150_ins FROM tmp_sql
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('r150_ins:',SQLCA.sqlcode,1)
                EXECUTE del_cmd #delete tmpfile
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
                EXIT PROGRAM
             END IF
 
     LET tmp_sql =    #出貨單刪除
#         " SELECT SUM(tlf10),SUM(ogb12*ogb13*oga24)*-1,SUM(tlfc21)  ",             #No.FUN-7C0101 tlf21---->tlfc21   #CHI-B70039 mark
          " SELECT SUM(tlf10),SUM(ogb917*ogb13*oga24)*-1,SUM(tlfc21)  ",            #CHI-B70039
        #FUN-A10098  ---start---
        # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
        # " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"tlfc_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'tlfc_file'),
        #FUN-A10098 ---end---
          " ON tlfc_file.tlfc01 = tlf_file.tlf01 AND tlfc_file.tlfc02 = tlf_file.tlf02 ",
          " AND tlfc_file.tlfc03 = tlf_file.tlf03 AND tlfc_file.tlfc06 = tlf_file.tlf06",
          " AND tlfc_file.tlfc13 = tlf_file.tlf13",
          " AND tlfc_file.tlfc902 = tlf_file.tlf902 AND tlfc_file.tlfc903 = tlf_file.tlf903",
          " AND tlfc_file.tlfc904 = tlf_file.tlf904 AND tlfc_file.tlfc905 = tlf_file.tlf905",
          " AND tlfc_file.tlfc906 = tlf_file.tlf906 AND tlfc_file.tlfc907 = tlf_file.tlf907",
          " AND tlfc_file.tlfctype='",tm.type,"'",
       # FUN-A10098 ----start---
       #  " ,",g_ary[g_idx].dbs_new CLIPPED,"smy_file",
       #  " ,",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",                      
       #  " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
       #  " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
       #  " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " ,",cl_get_target_table(g_ary[g_idx].plant,'smy_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
       #FUN-A10098  ---end--
          " WHERE ",g_wc CLIPPED,
          " AND tlf61=smyslip AND smydmy1 = 'Y' ",
          " AND (tlf03 = 723 OR tlf03 = 725) AND tlf02 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",

          " AND tlf01=ccc01 ",
          " AND ccc02=YEAR(tlf06) AND ccc03=MONTH(tlf06) ",
          " AND ccc07='",tm.type,"'",                                                    #No.FUN-7C0101 
          " AND tlf01=ima01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 AND oga09 IN ('2','3','8') ",  #No.FUN-610020  #No.TQC-A40130
          " AND oga65 ='N' "                                                             #No.FUN-610020
          IF tm.data ='1'  THEN #資料選擇
             LET tmp_sql=tmp_sql CLIPPED," AND ima131=? AND ima01=? " #產品分類
          ELSE
             LET tmp_sql=tmp_sql CLIPPED," AND ima11=? AND ima01=? " #會計分類
          END IF
          LET tmp_sql=tmp_sql CLIPPED," AND tlfcost=?"                                    #No.FUN-7C0101
          LET tmp_sql=tmp_sql CLIPPED, " AND oga00 NOT IN ('A','3','7') "    #No.MOD-950210 add
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
             PREPARE r150_prepare4x_r FROM tmp_sql
	     DECLARE r150_curs4x_r CURSOR FOR r150_prepare4x_r
 
             #讀出銷售總額, 總量
             LET tmp_sql=
                   "SELECT sum(ogb16),sum(ogb13*ogb16*oga24),sum(ogb16*ccc23)",
                 #FUN-A10098 ---start--- 
                 # "  FROM ",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
                 # ",",      g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
                 # " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
                   "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
                   ",",      cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
                   " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
                 #FUN-A10098 ---end---
                   " ON ccc_file.ccc01=ogb_file.ogb04 ",
                   " AND ccc_file.ccc02=YEAR(oga_file.oga02) ",
                   " AND ccc_file.ccc03=MONTH(oga_file.oga02) AND ccc_file.ccc07='",tm.type,"'",
                 # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",                #FUN-A10098
                   " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),   #FUN-A10098
                   " WHERE ",g_wc CLIPPED,
                   " AND ima01=ogb04 AND oga01 = ogb01 ",
                   " AND (oga02 BETWEEN '",g_bdate,"' AND '",g_edate,"') ",
                   " AND oga09 IN ('2','8') AND ogaconf = 'Y' AND ogapost = 'Y' ", #No.FUN-610020
                   " AND oga65 ='N' "                                              #No.FUN-610020
          IF tm.data ='1'  THEN #資料選擇
             LET tmp_sql=tmp_sql CLIPPED," AND ima131=? AND ccc_file.ccc01=? " #產品分類
          ELSE
             LET tmp_sql=tmp_sql CLIPPED," AND ima11=? AND ccc_file.ccc01=? " #會計分類
          END IF
          LET tmp_sql=tmp_sql CLIPPED, " AND oga00 NOT IN ('A','3','7') "    #No.MOD-950210 add
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
             PREPARE r150_prepare4x FROM tmp_sql
	     DECLARE r150_curs4x CURSOR FOR r150_prepare4x
 
             LET l_groupby = l_fd1 CLIPPED     #FUN-5B0123
             LET tmp_sql= #" INSERT INTO ",g_tname,
                   " SELECT ",l_fd1 CLIPPED,i,",ccc08,0,0,0", #l_col CLIPPED,            #No.FUN-7C0101
#FUN-A10098  ---start---
#                  " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file ON ccc02=",g_ym[i].yy_e," AND ccc03 BETWEEN ",g_ym[i].mm_b," AND ",g_ym[i].mm_e,
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
 " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file')," ON ccc02=",g_ym[i].yy_e," AND ccc03 BETWEEN ",g_ym[i].mm_b," AND ",g_ym[i].mm_e,
#FUN-A10098   ---end--- 
"                                                                                      AND ccc07='",tm.type,"' AND ccc01=ima01 ",
                   " WHERE ",g_wc CLIPPED,
                   " AND ccc07 ='",tm.type,"'",                                          #No.FUN-7C0101   
                   " GROUP BY ",s_groupby(l_groupby CLIPPED),",ccc08"
 
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
             PREPARE r150_prepare4 FROM tmp_sql
	     DECLARE r150_curs4 CURSOR FOR r150_prepare4
             FOREACH r150_curs4 INTO gettmp.*
                IF SQLCA.sqlcode != 0 THEN
                   CALL cl_err('prepare4:',SQLCA.sqlcode,1)
                   EXECUTE del_cmd #delete tmpfile
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
                   EXIT PROGRAM
                END IF
                LET l_qty = 0 LET l_amt = 0 LET l_cost = 0
                IF cl_null(gettmp.qty) THEN LET gettmp.qty = 0 END IF
                IF cl_null(gettmp.amt) THEN LET gettmp.amt = 0 END IF
                IF cl_null(gettmp.cost) THEN LET gettmp.cost = 0 END IF
                LET de_qty = 0 LET de_amt = 0 LET de_cost = 0
	        OPEN r150_curs4x_r USING gettmp.item,gettmp.ima01
	        FETCH r150_curs4x_r INTO de_qty,de_amt,de_cost
	        CLOSE r150_curs4x_r
	        OPEN r150_curs4x USING gettmp.item,gettmp.ima01
	        FETCH r150_curs4x INTO l_qty,l_amt,l_cost
	        CLOSE r150_curs4x
                IF cl_null(de_qty) THEN LET de_qty = 0 END IF
                IF cl_null(de_amt) THEN LET de_amt = 0 END IF
                IF cl_null(de_cost) THEN LET de_cost = 0 END IF
 
                IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                IF cl_null(l_amt) THEN LET l_amt = 0 END IF
                IF cl_null(l_cost) THEN LET l_cost = 0 END IF
                LET gettmp.qty =  l_qty + de_qty
                LET gettmp.amt =  l_amt + de_amt
                LET gettmp.cost = l_cost + de_cost
                EXECUTE r150_ins USING gettmp.*
             END FOREACH
          END IF
        END FOR        #for i  ym
      END FOR          #for g_inx  dbs
      CALL get_dpm()   #內部自用,雜發票,折讓
   END IF
END FUNCTION
 
REPORT r150_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1       #No.FUN-680122CHAR(1)
DEFINE dec_name LIKE cre_file.cre08           #No.FUN-680122CHAR(10) 
DEFINE l_str1   LIKE type_file.chr1000        #No.FUN-680122CHAR(400)                                                                                                  
DEFINE l_str2   LIKE type_file.chr1000        #No.FUN-680122CHAR(400)                                                                                                
DEFINE l_str3   LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
#DEFINE l_qty1,l_qty2,l_qty3,l_qty4,l_qty5,l_qty6 LIKE ima_file.ima26        #No.FUN-680122 DECIMAL(15,3)#FUN-A20044 
DEFINE l_qty1,l_qty2,l_qty3,l_qty4,l_qty5,l_qty6 LIKE type_file.num15_3        #No.FUN-680122 DECIMAL(15,3)#FUN-A20044 
DEFINE l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6 LIKE oeb_file.oeb13        #No.FUN-680122 DECIMAL(20,6)
#DEFINE l_pert1,l_pert2,l_pert3,l_pert4 LIKE ima_file.ima26                  #No.FUN-680122 DECIMAL(15,3) #FUN-A20044
DEFINE l_pert1,l_pert2,l_pert3,l_pert4 LIKE type_file.num15_3                  #No.FUN-680122 DECIMAL(15,3) #FUN-A20044
DEFINE
     sr  RECORD                                                            
              order  LIKE type_file.num10,        #No.FUN-680122 INTEGER              
              item   LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(20)              
              gaa02  LIKE type_file.chr1000,      #No.FUN-680122 VARCHAR(30)              
              ima01  LIKE ima_file.ima01,         #No.FUN-680122 VARCHAR(20)              
              ima02  LIKE ima_file.ima02,         #No.FUN-680122 VARCHAR(30)              
              ccc08  LIKE ccc_file.ccc08,         #No.FUN-7C0101
             # qty1   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              qty1   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              amt1   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost1  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
           #   qty2   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              qty2   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              amt2   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost2  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
            #  qty3   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              qty3   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              amt3   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost3  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
             # qty4   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3)              
              qty4   LIKE type_file.num15_3,         #FUN-A200444                                                                     
              amt4   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost4  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
            #  qty5   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              qty5   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              amt5   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost5  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
            #  qty6   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3)   #FUN-A20044           
              qty6   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3)   #FUN-A20044           
              amt6   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost6  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
            #  qty7   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3)   #FUN-A20044           
              qty7   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3)   #FUN-A20044           
              amt7   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost7  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
           #   qty8   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3)     #FUN-A20044         
              qty8   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3)     #FUN-A20044         
              amt8   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost8  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
             # qty9   LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3)#FUN-A20044              
              qty9   LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3)#FUN-A20044              
              amt9   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost9  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
            #  qty10  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044              
              qty10  LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044              
              amt10  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost10 LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)               
            #  qty11  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3)   #FUN-A20044           
              qty11  LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3)   #FUN-A20044           
              amt11  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost11 LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)               
          #    qty12  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              qty12  LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044             
              amt12  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)                
              cost12 LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)               
           #   tl_qty LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3) #FUN-A20044            
              tl_qty LIKE type_file.num15_3,         #No.FUN-680122 DEC(15,3) #FUN-A20044            
              tl_amt LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)               
              tl_cost LIKE oeb_file.oeb13         #No.FUN-680122 DEC(20,6)    
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order,sr.item,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1                                                                                                   
      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
      PRINT g_head CLIPPED,pageno_total
      CALL get_head(tm.title)
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_head       #No.FUN-680025
      IF tm.dec ='2' THEN
         LET dec_name=g_x[17]
      ELSE IF tm.dec='3' THEN	
              LET dec_name=g_x[18]
           ELSE
              LET dec_name=g_x[16]
           END IF
      END IF
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01     #No.FUN-870151
      PRINT COLUMN 1,g_x[11] CLIPPED,
                  #tm.azk01 clipped,'/',tm.azk04 using '<<&.&&',         #No.FUN-870151
                   tm.azk01 clipped,'/',cl_numfor(tm.azk04,7,t_azi07),   #No.FUN-870151                   
#           COLUMN g_len-15,dec_name clipped,g_group CLIPPED
            COLUMN g_len-17,dec_name clipped,g_group CLIPPED      #No:MOD-960334
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
          FOR i=1 TO 12
            IF g_ym[i].mm_b=0 THEN    LET g_ym[i].yy_e='     '            END IF                                                       
         IF g_ym[i].mm_b>0 THEN LET l_str2= '/'; ELSE LET l_str2= ' '; END IF                                                       
         IF g_ym[i].mm_b>0 THEN LET l_str3= '-'; ELSE LET l_str3= ' '; END IF                                                       
         LET l_str1=g_ym[i].yy_e USING '<<<<' CLIPPED,l_str2,g_ym[i].mm_b USING '<<' CLIPPED,l_str3,g_ym[i].mm_e USING '<<' CLIPPED
#        LET g_zaa[32+i].zaa08 = l_str1
         LET g_zaa[33+i].zaa08 = l_str1     #No:MOD-960334 modify
          END FOR
      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]             #No.FUN-7C0101
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.item
      IF tm.p_group1 matches '[Yy]' THEN
         CASE tm.data
             WHEN '1'
                 SELECT oba02 INTO sr.gaa02 FROM oba_file
                  WHERE oba01=sr.item
             WHEN '2'
                 SELECT azf03 INTO sr.gaa02 FROM azf_file
                  WHERE azf01=sr.item AND azf02 = 'F'  #6818
         END CASE
         IF STATUS=NOTFOUND THEN LET sr.gaa02=null END IF
          PRINTX name = D1 sr.item CLIPPED,' ',sr.gaa02
      END IF
   ON EVERY ROW
         PRINTX name = D1 COLUMN g_c[31],sr.ima01 CLIPPED,          
                          COLUMN g_c[32],sr.ccc08 CLIPPED;
        PRINTX name = D1 COLUMN g_c[33],g_x[13] CLIPPED,                                                                              
             COLUMN g_c[34],cl_numfor(sr.qty1,34,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                                        
             COLUMN g_c[35],cl_numfor(sr.qty2,35,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[36],cl_numfor(sr.qty3,36,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[37],cl_numfor(sr.qty4,37,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[38],cl_numfor(sr.qty5,38,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[39],cl_numfor(sr.qty6,39,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[40],cl_numfor(sr.qty7,40,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[41],cl_numfor(sr.qty8,41,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[42],cl_numfor(sr.qty9,42,  g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                             
             COLUMN g_c[43],cl_numfor(sr.qty10,43, g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                            
             COLUMN g_c[44],cl_numfor(sr.qty11,44, g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                            
             COLUMN g_c[45],cl_numfor(sr.qty12,45, g_ccz.ccz27), #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101                                                            
             COLUMN g_c[46],cl_numfor(sr.tl_qty,46,g_ccz.ccz27)  #CHI-690007 g_azi04->ccz27            #No.FUN-7C0101
      IF tm.p_group matches '[Yy]' THEN #要印料件
         SELECT ima02 INTO sr.ima02 FROM ima_file
         WHERE ima01=sr.ima01
         IF STATUS=NOTFOUND THEN LET sr.ima02=null END IF
      END IF
       PRINTX name = D1 COLUMN g_c[33],g_x[14] CLIPPED,                                                                               
            COLUMN g_c[34],cl_numfor(sr.amt1,34,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[35],cl_numfor(sr.amt2,35,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[36],cl_numfor(sr.amt3,36,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[37],cl_numfor(sr.amt4,37,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[38],cl_numfor(sr.amt5,38,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[39],cl_numfor(sr.amt6,39,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[40],cl_numfor(sr.amt7,40,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                    
            COLUMN g_c[41],cl_numfor(sr.amt8,41,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[42],cl_numfor(sr.amt9,42,g_ccz.ccz26) ,    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                    
            COLUMN g_c[43],cl_numfor(sr.amt10,43,g_ccz.ccz26),    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[44],cl_numfor(sr.amt11,44,g_ccz.ccz26),    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[45],cl_numfor(sr.amt12,45,g_ccz.ccz26),    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                     
            COLUMN g_c[46],cl_numfor(sr.tl_amt,46,g_ccz.ccz26)    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
 
      IF tm.title='5' THEN #銷貨毛利
         PRINTX name = D1 COLUMN g_c[33],g_x[15] CLIPPED,  #MOD-580198 14->18#TQC-5A0038                                                
            COLUMN g_c[34],cl_numfor(sr.cost1,34,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[35],cl_numfor(sr.cost2,35,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[36],cl_numfor(sr.cost3,36,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[37],cl_numfor(sr.cost4,37,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[38],cl_numfor(sr.cost5,38,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[39],cl_numfor(sr.cost6,39,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[40],cl_numfor(sr.cost7,40,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[41],cl_numfor(sr.cost8,41,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[42],cl_numfor(sr.cost9,42,g_ccz.ccz26) , #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[43],cl_numfor(sr.cost10,43,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[44],cl_numfor(sr.cost11,44,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[45],cl_numfor(sr.cost12,45,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[46],cl_numfor(sr.tl_cost,46,g_ccz.ccz26) #TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINTX name = D1 COLUMN g_c[33],g_x[25] CLIPPED,   #MOD-580198 14->18 #TQC-5A0038                                               
            COLUMN g_c[34],cl_numfor((sr.amt1-sr.cost1),34,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[35],cl_numfor((sr.amt2-sr.cost2),35,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[36],cl_numfor((sr.amt3-sr.cost3),36,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[37],cl_numfor((sr.amt4-sr.cost4),37,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[38],cl_numfor((sr.amt5-sr.cost5),38,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[39],cl_numfor((sr.amt6-sr.cost6),39,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[40],cl_numfor((sr.amt7-sr.cost7),40,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[41],cl_numfor((sr.amt8-sr.cost8),41,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[42],cl_numfor((sr.amt9-sr.cost9),42,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                 
            COLUMN g_c[43],cl_numfor((sr.amt10-sr.cost10),43,g_ccz.ccz26), #TQC-5A0038 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                
            COLUMN g_c[44],cl_numfor((sr.amt11-sr.cost11),44,g_ccz.ccz26), #TQC-5A0038 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                                
            COLUMN g_c[45],cl_numfor((sr.amt12-sr.cost12),45,g_ccz.ccz26), #TQC-5A0038 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                               
            COLUMN g_c[46],cl_numfor((sr.tl_amt-sr.tl_cost),46,g_ccz.ccz26)#TQC-5A0038 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINTX name = D1 COLUMN g_c[33],g_x[26] CLIPPED,  #MOD-580198 14->18#TQC-5A0038  #No.FUN-7C0101                                              
            COLUMN g_c[34],cl_numfor(chk_zero(sr.amt1,sr.cost1),34,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[35],cl_numfor(chk_zero(sr.amt2,sr.cost2),35,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[36],cl_numfor(chk_zero(sr.amt3,sr.cost3),36,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[37],cl_numfor(chk_zero(sr.amt4,sr.cost4),37,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[38],cl_numfor(chk_zero(sr.amt5,sr.cost5),38,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[39],cl_numfor(chk_zero(sr.amt6,sr.cost6),39,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[40],cl_numfor(chk_zero(sr.amt7,sr.cost7),40,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                        
            COLUMN g_c[41],cl_numfor(chk_zero(sr.amt8,sr.cost8),41,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[42],cl_numfor(chk_zero(sr.amt9,sr.cost9),42,g_ccz.ccz26) ,#TQC-5A0038  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[43],cl_numfor(chk_zero(sr.amt10,sr.cost10),43,g_ccz.ccz26) ,#TQC-5A0038 #No.FUN-7C0101  #CHI-C30012 g_azi03->g_ccz.ccz26                                        
            COLUMN g_c[44],cl_numfor(chk_zero(sr.amt11,sr.cost11),44,g_ccz.ccz26) ,#TQC-5A0038 #No.FUN-7C0101  #CHI-C30012 g_azi03->g_ccz.ccz26                                        
            COLUMN g_c[45],cl_numfor(chk_zero(sr.amt12,sr.cost12),45,g_ccz.ccz26) ,#TQC-5A0038 #No.FUN-7C0101  #CHI-C30012 g_azi03->g_ccz.ccz26                                        
            COLUMN g_c[46],cl_numfor(chk_zero(sr.tl_amt,sr.tl_cost),46,g_ccz.ccz26) #TQC-5A0038 #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
      INITIALIZE sr.* TO NULL
      IF tm.title='5' THEN #銷貨毛利
         NEED 5 LINES
      ELSE
         NEED 2 LINES
      END IF
   ON LAST ROW
       PRINT g_dash1
       PRINTX name = S1 COLUMN g_c[31],g_x[24] clipped,                                                                              
            COLUMN g_c[33],g_x[13] CLIPPED,  #MOD-580198 14->18                                                                     
            COLUMN g_c[34],cl_numfor(sum(sr.qty1),34,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101 
            COLUMN g_c[35],cl_numfor(sum(sr.qty2),35,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                  
            COLUMN g_c[36],cl_numfor(sum(sr.qty3),36,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                 
            COLUMN g_c[37],cl_numfor(sum(sr.qty4),37,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                  
            COLUMN g_c[38],cl_numfor(sum(sr.qty5),38,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                 
            COLUMN g_c[39],cl_numfor(sum(sr.qty6),39,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                 
            COLUMN g_c[40],cl_numfor(sum(sr.qty7),40,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                 
            COLUMN g_c[41],cl_numfor(sum(sr.qty8),41,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                 
            COLUMN g_c[42],cl_numfor(sum(sr.qty9),42,  g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                 
            COLUMN g_c[43],cl_numfor(sum(sr.qty10),43, g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                
            COLUMN g_c[44],cl_numfor(sum(sr.qty11),44, g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                
            COLUMN g_c[45],cl_numfor(sum(sr.qty12),45, g_ccz.ccz27) ,#CHI-690007 g_azi04->ccz27   #No.FUN-7C0101                                                                
            COLUMN g_c[46],cl_numfor(sum(sr.tl_qty),46,g_ccz.ccz27)  #CHI-690007 g_azi04->ccz27   #No.FUN-7C0101 
       PRINTX name = S1 COLUMN g_c[33],g_x[14] CLIPPED, #MOD-580198 14->18                        #No.FUN-7C0101                                   
            COLUMN g_c[34],cl_numfor(sum(sr.amt1),34,g_ccz.ccz26),    #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26              
            COLUMN g_c[35],cl_numfor(sum(sr.amt2),35,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[36],cl_numfor(sum(sr.amt3),36,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[37],cl_numfor(sum(sr.amt4),37,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[38],cl_numfor(sum(sr.amt5),38,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                
            COLUMN g_c[39],cl_numfor(sum(sr.amt6),39,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                
            COLUMN g_c[40],cl_numfor(sum(sr.amt7),40,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[41],cl_numfor(sum(sr.amt8),41,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[42],cl_numfor(sum(sr.amt9),42,g_ccz.ccz26) ,   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[43],cl_numfor(sum(sr.amt10),43,g_ccz.ccz26) ,  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[44],cl_numfor(sum(sr.amt11),44,g_ccz.ccz26) ,  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                 
            COLUMN g_c[45],cl_numfor(sum(sr.amt12),45,g_ccz.ccz26) ,  #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26                                
            COLUMN g_c[46],cl_numfor(sum(sr.tl_amt),46,g_ccz.ccz26)   #No.FUN-7C0101 #CHI-C30012 g_azi03->g_ccz.ccz26
 
      IF tm.title='5' THEN #銷貨毛利
          PRINTX name = S1 COLUMN g_c[33],g_x[15] CLIPPED, #MOD-580198 14->18                                                           
            COLUMN g_c[34],cl_numfor(sum(sr.cost1),34,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[35],cl_numfor(sum(sr.cost2),35,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[36],cl_numfor(sum(sr.cost3),36,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[37],cl_numfor(sum(sr.cost4),37,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[38],cl_numfor(sum(sr.cost5),38,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[39],cl_numfor(sum(sr.cost6),39,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[40],cl_numfor(sum(sr.cost7),40,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[41],cl_numfor(sum(sr.cost8),41,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                   
            COLUMN g_c[42],cl_numfor(sum(sr.cost9),42,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                  
            COLUMN g_c[43],cl_numfor(sum(sr.cost10),43,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                  
            COLUMN g_c[44],cl_numfor(sum(sr.cost11),44,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                  
            COLUMN g_c[45],cl_numfor(sum(sr.cost12),45,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                                  
            COLUMN g_c[46],cl_numfor(sum(sr.tl_cost),46,g_ccz.ccz26)  #CHI-C30012 g_azi03->g_ccz.ccz26
          PRINTX name = S1 COLUMN g_c[33],g_x[25] CLIPPED,  #MOD-580198 14->18                                                          
            COLUMN g_c[34],cl_numfor(sum(sr.amt1-sr.cost1),34,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[35],cl_numfor(sum(sr.amt2-sr.cost2),35,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[36],cl_numfor(sum(sr.amt3-sr.cost3),36,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[37],cl_numfor(sum(sr.amt4-sr.cost4),37,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[38],cl_numfor(sum(sr.amt5-sr.cost5),38,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[39],cl_numfor(sum(sr.amt6-sr.cost6),39,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[40],cl_numfor(sum(sr.amt7-sr.cost7),40,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[41],cl_numfor(sum(sr.amt8-sr.cost8),41,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                           
            COLUMN g_c[42],cl_numfor(sum(sr.amt9-sr.cost9),42,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                          
            COLUMN g_c[43],cl_numfor(sum(sr.amt10-sr.cost10),43,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                         
            COLUMN g_c[44],cl_numfor(sum(sr.amt11-sr.cost11),44,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                         
            COLUMN g_c[45],cl_numfor(sum(sr.amt12-sr.cost12),45,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                        
            COLUMN g_c[46],cl_numfor(sum(sr.tl_amt-sr.tl_cost),46,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
            LET sr.tl_amt=sum(sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+
                sr.amt6+sr.amt7+sr.amt8+sr.amt9+sr.amt10+sr.amt11+sr.amt12)
            LET sr.tl_cost=sum(sr.cost1+sr.cost2+sr.cost3+sr.cost4+sr.cost5+
            sr.cost6+sr.cost7+sr.cost8+sr.cost9+sr.cost10+sr.cost11+sr.cost12)
            LET sr.amt1=sum(sr.amt1)
            LET sr.cost1=sum(sr.cost1)
            LET sr.amt2=sum(sr.amt2)
            LET sr.cost2=sum(sr.cost2)
            LET sr.amt3=sum(sr.amt3)
            LET sr.cost3=sum(sr.cost3)
            LET sr.amt4=sum(sr.amt4)
            LET sr.cost4=sum(sr.cost4)
            LET sr.amt5=sum(sr.amt5)
            LET sr.cost5=sum(sr.cost5)
            LET sr.amt6=sum(sr.amt6)
            LET sr.cost6=sum(sr.cost6)
            LET sr.amt7=sum(sr.amt7)
            LET sr.cost7=sum(sr.cost7)
            LET sr.amt8=sum(sr.amt8)
            LET sr.cost8=sum(sr.cost8)
            LET sr.amt9=sum(sr.amt9)
            LET sr.cost9=sum(sr.cost9)
            LET sr.amt10=sum(sr.amt10)
            LET sr.cost10=sum(sr.cost10)
            LET sr.amt11=sum(sr.amt11)
            LET sr.cost11=sum(sr.cost11)
            LET sr.amt12=sum(sr.amt12)
            LET sr.cost12=sum(sr.cost12)
            IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
            IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
            IF sr.amt3 IS NULL THEN LET sr.amt3=0 END IF
            IF sr.amt4 IS NULL THEN LET sr.amt4=0 END IF
            IF sr.amt5 IS NULL THEN LET sr.amt5=0 END IF
            IF sr.amt6 IS NULL THEN LET sr.amt6=0 END IF
            IF sr.amt7 IS NULL THEN LET sr.amt7=0 END IF
            IF sr.amt8 IS NULL THEN LET sr.amt8=0 END IF
            IF sr.amt9 IS NULL THEN LET sr.amt9=0 END IF
            IF sr.amt10 IS NULL THEN LET sr.amt10=0 END IF
            IF sr.amt11 IS NULL THEN LET sr.amt11=0 END IF
            IF sr.amt12 IS NULL THEN LET sr.amt12=0 END IF
            IF sr.cost1 IS NULL THEN LET sr.cost1=0 END IF
            IF sr.cost2 IS NULL THEN LET sr.cost2=0 END IF
            IF sr.cost3 IS NULL THEN LET sr.cost3=0 END IF
            IF sr.cost4 IS NULL THEN LET sr.cost4=0 END IF
            IF sr.cost5 IS NULL THEN LET sr.cost5=0 END IF
            IF sr.cost6 IS NULL THEN LET sr.cost6=0 END IF
            IF sr.cost7 IS NULL THEN LET sr.cost7=0 END IF
            IF sr.cost8 IS NULL THEN LET sr.cost8=0 END IF
            IF sr.cost9 IS NULL THEN LET sr.cost9=0 END IF
            IF sr.cost10 IS NULL THEN LET sr.cost10=0 END IF
            IF sr.cost11 IS NULL THEN LET sr.cost11=0 END IF
            IF sr.cost12 IS NULL THEN LET sr.cost12=0 END IF
            LET sr.tl_amt=(sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+
                sr.amt6+sr.amt7+sr.amt8+sr.amt9+sr.amt10+sr.amt11+sr.amt12)
            LET sr.tl_cost=(sr.cost1+sr.cost2+sr.cost3+sr.cost4+sr.cost5+
            sr.cost6+sr.cost7+sr.cost8+sr.cost9+sr.cost10+sr.cost11+sr.cost12)
          PRINTX name = S1 COLUMN g_c[33],g_x[26] CLIPPED, #MOD-580198 14->18                                                           
            COLUMN g_c[34],cl_numfor(chk_zero(sr.amt1,sr.cost1),34,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                            
            COLUMN g_c[35],cl_numfor(chk_zero(sr.amt2,sr.cost2),35,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[36],cl_numfor(chk_zero(sr.amt3,sr.cost3),36,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[37],cl_numfor(chk_zero(sr.amt4,sr.cost4),37,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[38],cl_numfor(chk_zero(sr.amt5,sr.cost5),38,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[39],cl_numfor(chk_zero(sr.amt6,sr.cost6),39,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[40],cl_numfor(chk_zero(sr.amt7,sr.cost7),40,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[41],cl_numfor(chk_zero(sr.amt8,sr.cost8),41,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[42],cl_numfor(chk_zero(sr.amt9,sr.cost9),42,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                      
            COLUMN g_c[43],cl_numfor(chk_zero(sr.amt10,sr.cost10),43,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                    
            COLUMN g_c[44],cl_numfor(chk_zero(sr.amt11,sr.cost11),44,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                    
            COLUMN g_c[45],cl_numfor(chk_zero(sr.amt12,sr.cost12),45,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26                                                    
            COLUMN g_c[46],cl_numfor(chk_zero(sr.tl_amt,sr.tl_cost),46,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
      LET l_last_sw = 'y'
      PRINT g_dash2[1,g_len]
      PRINT 'data from : ',
            g_ary[1].plant CLIPPED,' ', g_ary[2].plant CLIPPED,' ',
            g_ary[3].plant CLIPPED,' ', g_ary[4].plant CLIPPED,' ',
            g_ary[5].plant CLIPPED,' ', g_ary[6].plant CLIPPED,' ',
            g_ary[7].plant CLIPPED,' ', g_ary[8].plant CLIPPED
      IF tm.sum_code matches '[Yy]' AND tm.title MATCHES '[345]' THEN
        #------------------No:MOD-960334 modify
        #PRINT COLUMN   8,g_x[35],      #No:FUN-7C0101
        #      COLUMN  23,g_x[36],      #No:FUN-7C0101 
        #      COLUMN  42,g_x[37],      #No:FUN-7C0101
        #      COLUMN  61,g_x[38],      #No:FUN-7C0101 
        #      COLUMN  77,g_x[39],      #No:FUN-7C0101  
        #      COLUMN  96,g_x[40],      #No:FUN-7C0101
        #      COLUMN 117,g_x[41],      #No:FUN-7C0101 
        #      COLUMN 135,g_x[42]       #No:FUN-7C0101
         PRINT COLUMN   8,g_x[54],      #No:FUN-7C0101
               COLUMN  23,g_x[55],      #No:FUN-7C0101 
               COLUMN  42,g_x[56],      #No:FUN-7C0101
               COLUMN  61,g_x[57],      #No:FUN-7C0101 
               COLUMN  77,g_x[58],      #No:FUN-7C0101  
               COLUMN  96,g_x[59],      #No:FUN-7C0101
               COLUMN 117,g_x[60],      #No:FUN-7C0101 
               COLUMN 135,g_x[61]       #No:FUN-7C0101
        #------------------No:MOD-960334 end
 
         PRINT cl_numfor(g_sum.qty,15,g_ccz.ccz27) , #CHI-690007 2->ccz27
               cl_numfor(g_sum.amt,18,g_ccz.ccz26) ,  #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.cost,18,g_ccz.ccz26) , #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.qty1,15,g_ccz.ccz27) , #CHI-690007 2->ccz27
               cl_numfor(g_sum.amt1,18,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.cost1,15,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.dae_amt,18,g_ccz.ccz26), #折讓 #CHI-C30012 g_azi03->g_ccz.ccz26
               cl_numfor(g_sum.dac_amt,18,g_ccz.ccz26)  #雜項發票 #CHI-C30012 g_azi03->g_ccz.ccz26
      END IF
      PRINT g_dash2[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash2[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
FUNCTION chk_dev1(tmp1,tmp2)
DEFINE tmp1,tmp2 LIKE type_file.num10          #No.FUN-680122INTEGER
#DEFINE tmp3 LIKE ima_file.ima26           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
DEFINE tmp3 LIKE type_file.num15_3           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
      IF tmp2 <>0 AND tmp2 IS NOT NULL THEN
         LET tmp3=tmp1/tmp2
      ELSE
         LET tmp3=0
      END IF
   RETURN tmp3
END FUNCTION
 
FUNCTION chk_dev(tmp1,tmp2)
DEFINE tmp1,tmp2 LIKE type_file.num10          #No.FUN-680122INTEGER                   
#DEFINE tmp3 LIKE ima_file.ima26           #No.FUN-680122 DECIMAL(15,3) #FUN-A20044
DEFINE tmp3 LIKE type_file.num15_3           #No.FUN-680122 DECIMAL(15,3) #FUN-A20044
      IF tmp2 <>0 AND tmp2 IS NOT NULL THEN
         LET tmp3=tmp1/tmp2*100
      ELSE
         LET tmp3=0
      END IF
   RETURN tmp3
END FUNCTION
 
FUNCTION duplicate(l_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_idx,n     LIKE type_file.num10          #No.FUN-680122INTGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
FUNCTION get_head(title)
DEFINE title LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   CASE title
   WHEN 1
        LET g_head=g_x[1]
        LET g_group=g_x[19]
   WHEN 2
        LET g_head=g_x[1]
        LET g_group=g_x[20]
   WHEN 3
        LET g_head=g_x[9]
        LET g_group=g_x[21]
   WHEN 4
        LET g_head=g_x[9]
        LET g_group=g_x[22]
   WHEN 5
        LET g_head=g_x[10]
        LET g_group=g_x[21]
   END CASE
END FUNCTION
 
FUNCTION get_order(sr)
DEFINE
          sr  RECORD
              order    LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(20)              
              item     LIKE type_file.chr20,        #No.FUN-680122 VARCHAR(20)              
              gaa02    LIKE type_file.chr1000,      #No.FUN-680122 VARCHAR(30)              
              ima01    LIKE ima_file.ima01,         #No.FUN-680122 VARCHAR(20)              
              ccc08    LIKE ccc_file.ccc08,         #No.FUN-7C0101
              ima02    LIKE ima_file.ima02,         #No.FUN-680122 VARCHAR(30)              
              qty1     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt1     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost1    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty2     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt2     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost2    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty3     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt3     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost3    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty4     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt4     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost4    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty5     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt5     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost5    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty6     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt6     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost6    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)         
              qty7     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt7     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost7    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty8     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt8     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost8    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty9     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt9     LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                
              cost9    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              qty10    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt10    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost10   LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                
              qty11    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt11    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost11   LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                
              qty12    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)               
              amt12    LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                 
              cost12   LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                
              tl_qty   LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)              
              tl_amt   LIKE oeb_file.oeb13,         #No.FUN-680122dec(20,6)                
              tl_cost  LIKE oeb_file.oeb13          #No.FUN-680122dec(20,6)      
 
              END RECORD
    CASE tm.order #排名方式
    WHEN 1
      LET sr.order=sr.amt1
    WHEN 1
      LET sr.order=sr.amt1
    WHEN 2
      LET sr.order=sr.amt2
    WHEN 3
      LET sr.order=sr.amt3
    WHEN 4
      LET sr.order=sr.amt4
    WHEN 5
      LET sr.order=sr.amt5
    WHEN 6
      LET sr.order=sr.amt6
    WHEN 7
      LET sr.order=sr.amt7
    WHEN 8
      LET sr.order=sr.amt8
    WHEN 9
      LET sr.order=sr.amt9
    WHEN 10
      LET sr.order=sr.amt10
    WHEN 11
      LET sr.order=sr.amt11
    WHEN 12
      LET sr.order=sr.amt12
    WHEN 13
      LET sr.order=sr.tl_amt
    OTHERWISE
      LET sr.order=0
    END CASE
    RETURN sr.order
END FUNCTION
 
FUNCTION chk_zero(a,b)
DEFINE a,b,d LIKE oeb_file.oeb13         #No.FUN-680122dec(20,6)
  IF a<>0 THEN
     LET d=(a-b)/a*100
  ELSE
     LET d=null
  END IF
  RETURN d
END FUNCTION
 
FUNCTION get_dpm()
DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
       l_wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
       l_sql1    LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
       tmp_sql   LIKE type_file.chr1000,       #No.FUN-680122CHAR(1000)
       f1,f2,f3  LIKE occ_file.occ15,          #No.FUN-680122DECIMAL(15,0)
       l_fd1     LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_groupby LIKE type_file.chr1000,       #No.FUN-680122CHAR(100)
       l_dpm RECORD
              ima01  LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
              item   LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
              ima02  LIKE type_file.chr1000,       #No.FUN-680122CHAR(30)
              mm     LIKE type_file.num5,          #No.FUN-680122SMALLINT
              qty    LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6) #數量(銷)
              amt    LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6) #金額(銷)
              cost   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6) #成本(銷)
              qty1   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6) #數量(退)
              amt1   LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6) #金額(退)
              cost1  LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6) #成本(退)
              dae_amt LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6) #折讓
              dac_amt LIKE oeb_file.oeb13         #No.FUN-680122 DEC(20,6) #雜項發票
              END RECORD
 
    IF tm.data ='1'  THEN #資料選擇
       LET l_fd1=" ima131,ima02," #產品分類
    ELSE
       LET l_fd1=" ima11,ima02," #會計分類
    END IF
 
###內部自用銷貨
    LET l_wc=g_wc
    FOR g_idx=1 TO g_k
       FOR i=1 TO 12
          LET l_groupby = "ima01,",l_fd1 CLIPPED     #FUN-5B0123
          IF g_ym[i].mm_e=0 THEN CONTINUE FOR END IF
          CALL s_ymtodate(g_ym[i].yy_e,g_ym[i].mm_b,
                          g_ym[i].yy_e,g_ym[i].mm_e)
          RETURNING g_bdate,g_edate
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ima01,",l_fd1 CLIPPED,i,",",
     #       異動數量                 銷售金額          成會異動成本
        " sum(tlf10*tlf60),sum(ogb14*oga24),sum(tlf21), ",
          " 0,0,0,0,0",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " WHERE ",g_wc CLIPPED,
          " AND (tlf03 = 724 OR tlf03 = 72) AND tlf02 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf01=ima01 AND tlf19 = occ01 AND occ37 = 'Y' ",
          " AND tlf036=ogb01 AND tlf037=ogb03 AND ogb01=oga01 AND oga09 IN ('2','8') ",  #No.FUN-610020
          " AND oga65 ='N' ",  #No.FUN-610020
          # AND oga00 != '3' ",   #FUN-5B0123  #No.MOD-950210 mark
          " AND oga00 NOT IN ('A','3','7') ",     #No.MOD-950210 add
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY ",s_groupby(l_groupby CLIPPED)
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r854_predpm FROM tmp_sql
          EXECUTE r854_predpm
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('predpm:',SQLCA.sqlcode,1)
             EXECUTE del_dpm
         END IF
      END FOR
    END FOR
###內部自用退貨
    FOR g_idx=1 TO g_k
       FOR i=1 TO 12
          IF g_ym[i].mm_e=0 THEN CONTINUE FOR END IF
          LET l_groupby = "ima01,",l_fd1 CLIPPED     #FUN-5B0123
          CALL s_ymtodate(g_ym[i].yy_e,g_ym[i].mm_b,
                          g_ym[i].yy_e,g_ym[i].mm_e)
          RETURNING g_bdate,g_edate
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT ima01,",l_fd1 CLIPPED,i,",",
        " 0,0,0,sum(tlf10),sum(ohb14*oha24), ",
        " sum(tlf21),0,0 ",
        #FUN-A10098   ---start---
        # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
        #FUN-A10098  ---end---
          " WHERE ",g_wc CLIPPED,
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf01=ima01 AND oha03 = occ01 AND occ37 = 'Y' ",
          " AND tlf036=ohb01 AND tlf037=ohb03 AND ohb01=oha01 ",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY ",s_groupby(l_groupby CLIPPED)
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r854_pregsl FROM tmp_sql
          EXECUTE r854_pregsl
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('pregsl:',SQLCA.sqlcode,1)
             EXECUTE del_dpm
          END IF
      END FOR
    END FOR
###折讓
    LET l_wc=g_wc
    FOR g_idx=1 TO g_k
       FOR i=1 TO 12
          IF g_ym[i].mm_e=0 THEN CONTINUE FOR END IF
          LET l_groupby = "omb04,",l_fd1 CLIPPED     #FUN-5B0123
          CALL s_ymtodate(g_ym[i].yy_e,g_ym[i].mm_b,
                          g_ym[i].yy_e,g_ym[i].mm_e)
          RETURNING g_bdate,g_edate
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT omb04,",l_fd1 CLIPPED,i,",",     #No.MOD-7B0110 add clipped
          " 0,0,0,0,0,0,SUM(omb16),0 ",
        #FUN-A10098 ----start--- 
        # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
        # " LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED,"ima_file ON omb04 = ima01",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'ima_file')," ON omb04 = ima01",
        #FUN-A10098 ---end---
          " WHERE oma00='25' ", #銷貨折讓
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
          " AND omb01=oma01 ",
          " GROUP BY ",s_groupby(l_groupby CLIPPED)
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r854_predae FROM tmp_sql
          EXECUTE r854_predae
          IF SQLCA.sqlcode != 0 THEN
             EXECUTE del_dpm
             CALL cl_err('predae:',SQLCA.sqlcode,1)
          END IF
      END FOR
    END FOR
###雜項發票
    FOR g_idx=1 TO g_k
       FOR i=1 TO 12
          IF g_ym[i].mm_e=0 THEN CONTINUE FOR END IF
          CALL s_ymtodate(g_ym[i].yy_e,g_ym[i].mm_b,
                          g_ym[i].yy_e,g_ym[i].mm_e)
          RETURNING g_bdate,g_edate
          LET l_groupby = "omb04,",l_fd1 CLIPPED     #FUN-5B0123
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT omb04,",l_fd1 CLIPPED,i,",",      #No.MOD-7B0110 add clipped
          " 0,0,0,0,0,0,0,SUM(omb16) ",
        #FUN-A10098  ---start---
        # " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
        #FUN-A10098  ---end--
          " WHERE oma00='14' ",
          " AND ",l_wc CLIPPED,
          " AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND oma10=ome01 AND omb04[1,4] <> 'MISC'", #MOD-710129 mod
          " AND omb01=oma01 AND omevoid = 'N' ",
          " AND omb04=ima01 ",
          " AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130 
          " GROUP BY ",s_groupby(l_groupby CLIPPED)
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r854_predac FROM tmp_sql
          EXECUTE r854_predac
          IF SQLCA.sqlcode != 0 THEN
             EXECUTE del_dpm
             CALL cl_err('predac:',SQLCA.sqlcode,1)
          END IF
      END FOR
    END FOR
 
  LET l_sql=" SELECT * FROM ",g_tname1
	     PREPARE r150_union FROM l_sql
	     IF SQLCA.sqlcode != 0 THEN
		CALL cl_err('prepare union_tmp:',SQLCA.sqlcode,1)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
		EXIT PROGRAM
	     END IF
 
  DECLARE union_cur CURSOR FOR r150_union
  FOREACH union_cur INTO l_dpm.*
    IF l_dpm.ima01 IS NULL THEN CONTINUE FOREACH END IF
    IF tm.title='4'  THEN #毛額
       LET f1=-l_dpm.qty
       LET f2=-l_dpm.amt+l_dpm.dac_amt
       LET f3=-l_dpm.cost
    ELSE           #淨額&毛利
       LET f1=-l_dpm.qty
       LET f2=-l_dpm.amt+l_dpm.dac_amt-l_dpm.dae_amt
       LET f3=-l_dpm.cost
    END IF
    IF f1 IS NULL THEN LET f1=0 END IF
    IF f2 IS NULL THEN LET f2=0 END IF
    IF f3 IS NULL THEN LET f3=0 END IF
    LET l_sql1=" INSERT INTO ",g_tname,
               " VALUES ('",l_dpm.item CLIPPED,"'",
                           ",''",
                           ",'",l_dpm.ima01 CLIPPED,"'",
                           ",''",
                           ",",l_dpm.mm,
                           ",''",        #No:MOD-960331 add
                           ",",f1,
                           ",",f2,
                           ",",f3,
                           ")"
    PREPARE pre_sql1 FROM l_sql1
    EXECUTE pre_sql1
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('insert gtname error:',SQLCA.sqlcode,1)
    END IF
  END FOREACH
  IF tm.sum_code matches '[Yy]' AND tm.title MATCHES '[345]' THEN
     LET l_sql=" SELECT sum(qty),sum(amt),sum(cost),",
            "sum(qty1),sum(amt1),sum(cost1),sum(dae_amt),sum(dac_amt)",
            " FROM ",g_tname1 CLIPPED
	     PREPARE r854_sum FROM l_sql
             DECLARE sum_cursor CURSOR FOR r854_sum
             OPEN sum_cursor
             FETCH sum_cursor INTO g_sum.*
            #--------------------No:MOD-960335 modify
            #IF g_sum.qty=0 THEN LET g_sum.qty=0 END IF
            #IF g_sum.amt=0 THEN LET g_sum.amt=0 END IF
            #IF g_sum.cost=0 THEN LET g_sum.cost=0 END IF
            #IF g_sum.qty1=0 THEN LET g_sum.qty1=0 END IF
            #IF g_sum.amt1=0 THEN LET g_sum.amt1=0 END IF
            #IF g_sum.cost1=0 THEN LET g_sum.cost1=0 END IF
            #IF g_sum.dae_amt=0 THEN LET g_sum.dae_amt=0 END IF
            #IF g_sum.dac_amt=0 THEN LET g_sum.dac_amt=0 END IF
             IF cl_null(g_sum.qty) THEN LET g_sum.qty=0 END IF
             IF cl_null(g_sum.amt) THEN LET g_sum.amt=0 END IF
             IF cl_null(g_sum.cost) THEN LET g_sum.cost=0 END IF
             IF cl_null(g_sum.qty1) THEN LET g_sum.qty1=0 END IF
             IF cl_null(g_sum.amt1) THEN LET g_sum.amt1=0 END IF
             IF cl_null(g_sum.cost1) THEN LET g_sum.cost1=0 END IF
             IF cl_null(g_sum.dae_amt) THEN LET g_sum.dae_amt=0 END IF
             IF cl_null(g_sum.dac_amt) THEN LET g_sum.dac_amt=0 END IF
            #--------------------No:MOD-960335 end
  END IF
  EXECUTE del_dpm
END FUNCTION
 
FUNCTION change_string(old_string, old_sub, new_sub)
DEFINE query_text   LIKE type_file.chr1000       #No.FUN-680122char(300)
DEFINE AA           LIKE type_file.chr1          #No.FUN-680122char(1)
 
DEFINE old_string   LIKE type_file.chr1000,       #No.FUN-680122char(300)
       xxx_string   LIKE type_file.chr1000,       #No.FUN-680122char(300)
       old_sub      LIKE type_file.chr1000,       #No.FUN-680122char(128) ,
       new_sub      LIKE type_file.chr1000,       #No.FUN-680122char(128) ,
       first_byte   LIKE type_file.chr1,           #No.FUN-680122char(01),
       nowx_byte    LIKE type_file.chr1,           #No.FUN-680122char(01),
       next_byte    LIKE type_file.chr1,           #No.FUN-680122char(01),
       this_byte    LIKE type_file.chr1,           #No.FUN-680122char(01),
       length1, length2, length3   LIKE type_file.num5,           #No.FUN-680122smallint,
                     pu1, pu2      LIKE type_file.num5,           #No.FUN-680122smallint
       ii, jj, kk, ff, tt          LIKE type_file.num5            #No.FUN-680122smallint
 
LET length1 = length(old_string)
LET length2 = length(old_sub)
LET length3 = length(new_sub)
LET first_byte = old_sub[1,1]
LET xxx_string = " "
let pu1 = 0
 
FOR ii = 1 TO length1
    LET this_byte = old_string[ii, ii]
    LET nowx_byte = this_byte
    IF this_byte = first_byte THEN
        FOR jj = 2 TO length2
            let this_byte = old_string[ ii + jj - 1, ii + jj - 1]
            let next_byte = old_sub[ jj, jj]
            IF this_byte <> next_byte THEN
                let jj = 29999
                exit for
            END IF
        END FOR
        IF jj < 29999 THEN
           let pu1 = pu1 + 1
           let pu2 = pu1 + length3 - 1
           LET xxx_string[pu1, pu2] = new_sub CLIPPED
           LET ii = ii + length2 - 1
           LET pu1 = pu2
        ELSE
            let pu1 = pu1 + 1
            LET xxx_string[pu1,pu1] = nowx_byte
        END IF
    ELSE
        LET pu1 = pu1 + 1
        LET xxx_string[pu1,pu1] = nowx_byte
    END IF
end for
let query_text = xxx_string
#DISPLAY QUERY_TEXT CLIPPED AT 10,1
            LET INT_FLAG = 0  ######add for prompt bug
#    PROMPT " " FOR CHAR AA
RETURN query_text
end function
 
#FUN-660126 add--start
FUNCTION r150_chkplant(l_plant)
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
#No.FUN-9C0073 -----By chenls 10/01/26

#FUN-A70084--add--str--
FUNCTION r150_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group06",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r150_chklegal(l_legal,n)
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
