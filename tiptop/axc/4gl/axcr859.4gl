# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr859.4gl
# Descriptions...: 產銷量值表
# Date & Author..: 97/10/14
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify.........: No:8741 03/11/25 By Melody 取消 ima57=0判斷式
# Modify.........: No:9678 04/06/17 By Melody 重工領出部份應扣除部份,
#                  應該只含當月有重工入庫部份,且不應該以 ccc_file 的重工領出(ccc
#                  因為領出料與重工入庫的料可能不同,  依程式目前的寫法,  於寫入
#                  又將值為負部份 * -1 , 出來的數值不正確
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0099 05/01/04 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570077 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-660073 06/12/07 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 07/01/03 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.MOD-710122 07/01/23 By jamie CREATE TABLE欄位長度有誤 
# Modify.........: No.MOD-710129 07/01/23 By jamie MISC的判斷需取前四碼
# Modify.........: No.MOD-720042 07/02/27 by TSD.doris 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-780258 07/11/29 By Pengu 1.多扣除了一次銷貨折讓金額
#                                                  2.截止日期 g_edate 不應該在減一天
# Modify.........: No.FUN-7C0101 08/01/24 By shiwuying 成本改善，CR增加類別編號ccg07
# Modify.........: No.MOD-910088 09/02/03 By Pengu 1.無法產生資料列印
#                                                  2.當銷退數量大於銷售量時，列印的銷售數量會異常
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.TQC-980163 09/09/01 By liuxqa create table 名寫死。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0053 09/10/12 By Pengu 報表無法跑出資料列印
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-9C0073 10/01/26 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40139 10/04/29 By Carrier 1.MOD-980048追单 2.ctv_file不存在 3.create table fail
# Modify.........: No.FUN-A70084 10/07/27 By lutingting GP5.2報表修改
# Modify.........: No:MOD-A70199 10/07/28 By Sarah 重工部份抓不到作A領B的資料
# Modify.........: No:FUN-B90130 11/11/29 By wujie  增加oma75的条件 
# Modify.........: No.TQC-BB0182 12/01/13 By pauline 取消過濾plant條件
# Modify.........: No:CHI-C50069 12/06/26 By Sakura 原"列印樣品銷貨"欄位改用RadioBox(1.一般出貨,2.樣品出貨,3.全部)
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc LIKE type_file.chr1000       #No.FUN-680122CHAR(300)
   DEFINE tm  RECORD
              ima01   LIKE ima_file.ima01,    #MOD-A70199 mod ccg04->ima01 #料號
              ima131  LIKE ima_file.ima131,         # Prog. Version..: '5.30.06-13.03.12(04)             #產品分類 
              a       LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)     #是否依產品分類第一碼作彙總
              b       LIKE type_file.chr1,          #CHI-C50069 add
              plant_1,plant_2,plant_3,plant_4,plant_5 LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(10),
              plant_6,plant_7,plant_8 LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(10)
              yy1_b,mm1_b,mm1_e LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
              type    LIKE ccg_file.ccg06,           #No.FUN-7C0101 add
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              dec     LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)      #金額單位(1)元(2)千(3)萬
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(01)
              END RECORD,
	  g_bookno             LIKE type_file.chr2,          #No.FUN-680122CHAR(2)
          g_bdate,g_edate      LIKE type_file.dat,           #No.FUN-680122DATE
          g_base               LIKE type_file.num10,         #No.FUN-680122INTEGER
          g_tname1             LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)               #tmpfile name
          g_delsql1            LIKE type_file.chr50,                #execute sys_cmd        #No.FUN-680122CHAR(50)
          g_delsql             LIKE type_file.chr50,                #execute sys_cmd        #No.FUN-680122CHAR(50)
          g_tname              LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)               #tmpfile name
          g_idx,g_k            LIKE type_file.num10,         #No.FUN-680122INTEGER
          g_ary DYNAMIC ARRAY OF RECORD          #被選擇之工廠
                plant      LIKE type_file.chr10,        # Prog. Version..: '5.30.06-13.03.12(08) #No.TQC-6A0079
                dbs_new    LIKE type_file.chr21         #No.FUN-680122CHAR(21)
                END RECORD ,
           g_tmp DYNAMIC ARRAY OF RECORD          #被選擇之工廠
                p          LIKE type_file.chr10,        # Prog. Version..: '5.30.06-13.03.12(08) #No.TQC-6A0079
                d          LIKE type_file.chr21         #No.FUN-680122CHAR(21)
           END RECORD 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table     STRING                        ### CR11 add ###
DEFINE g_sql       STRING                        ### CR11 add ###
DEFINE g_str       STRING                        ### CR11 add ###
DEFINE m_legal       ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084

 
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
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "item.ccg_file.ccg04,",
               "oba02.oba_file.oba02,",
               "ccg04.ccg_file.ccg04,",
               "ccg07.ccg_file.ccg07,",      #No.FUN-7C0101 add
          #     "qty1.ima_file.ima26,",#FUN-A20044
               "qty1.type_file.num15_3,",#FUN-A20044
               "amt1.ima_file.ima32,",
             #  "qty2.ima_file.ima26,",#FUN-A20044
               "qty2.type_file.num15_3,",#FUN-A20044
               "amt2.ima_file.ima32" 
 
   LET l_table = cl_prt_temptable('axcr859',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
           #    " VALUES(?,?,?,?,?, ?,?) "    #No.FUN-7C0101
               " VALUES(?,?,?,?,?, ?,?,?) "   #No.FUN-7C0101
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
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
   LET tm.a       = ARG_VAL(8)
   LET tm.yy1_b  = ARG_VAL(9)
   LET tm.mm1_b  = ARG_VAL(10)
   LET tm.mm1_e  = ARG_VAL(11)
   LET tm.plant_1= ARG_VAL(12)
   LET tm.plant_2= ARG_VAL(13)
   LET tm.plant_3= ARG_VAL(14)
   LET tm.plant_4= ARG_VAL(15)
   LET tm.plant_5= ARG_VAL(16)
   LET tm.plant_6= ARG_VAL(17)
   LET tm.plant_7= ARG_VAL(18)
   LET tm.plant_8= ARG_VAL(19)
   LET tm.type   = ARG_VAL(27)  #No.FUN-7C0101 add 
   LET tm.azk01  = ARG_VAL(20)
   LET tm.azk04  = ARG_VAL(21)
   LET tm.dec= ARG_VAL(22)
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_bookno = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r859_tm(0,0)        
      ELSE CALL r859()             
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r859_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_date         LIKE type_file.dat,           #No.FUN-680122DATE
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_cnt          LIKE type_file.num5          #No.FUN-A70084
  
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 5 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 5
   END IF
   OPEN WINDOW r859_w AT p_row,p_col WITH FORM "axc/42f/axcr859" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r859_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL        
   LET tm.dec= '1'
   LET tm.more = 'N'
   LET tm.yy1_b = YEAR(g_today)
   LET tm.mm1_b = MONTH(g_today)
   LET tm.mm1_e = MONTH(g_today)
   LET tm.type = g_ccz.ccz28  #No.FUN-7C0101 add
   LET tm.azk01= g_aza.aza17  #No.8488
   LET tm.azk04=1
   LET tm.a='N'
   LET tm.b='3'  #CHI-C50069 add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
 
WHILE TRUE
   LET g_wc=NULL 
   CONSTRUCT g_wc ON ima131,ima01 FROM ima131,ima01   #MOD-A70199 mod ccg04->ima01
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
        IF INFIELD(ima01) THEN   #MOD-A70199 mod ccg04->ima01
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima5"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01  #MOD-A70199 mod ccg04->ima01
           NEXT FIELD ima01  #MOD-A70199 mod ccg04->ima01
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r859_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      
   DISPLAY BY NAME tm.more     
   INPUT BY NAME 
              tm.a,tm.yy1_b,tm.mm1_b,tm.mm1_e,tm.b, #CHI-C50069 add tm.b
              tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
              tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,
              tm.type,                                       #No.FUN-7C0101 add
              tm.azk01, tm.azk04, tm.dec, tm.more
 
   WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a    
             IF tm.a IS NULL OR tm.a='  ' THEN
                NEXT FIELD a
             END IF 
	     IF tm.a NOT MATCHES '[YN]' THEN
		NEXT FIELD a
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
                EXIT INPUT        #將不會I/P plant_2 plant_3 ....
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
                   IF NOT r859_chkplant(tm.plant_1) THEN
                      CALL cl_err(tm.plant_1,g_errno,0)
                      NEXT FIELD plant_1
                   END IF
                   LET g_ary[1].plant = tm.plant_1
                   LET g_ary[1].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.plant_1   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_1) THEN  
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
                   IF NOT r859_chkplant(tm.plant_2) THEN
                      CALL cl_err(tm.plant_2,g_errno,0)
                      NEXT FIELD plant_2
                   END IF
                   LET g_ary[2].plant = tm.plant_2
                   LET g_ary[2].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.plant_2   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_2) THEN  
                      NEXT FIELD plant_2 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[2].plant = tm.plant_2
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_2) THEN
                IF NOT r859_chklegal(m_legal[2],1) THEN
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
                   IF NOT r859_chkplant(tm.plant_3) THEN
                      CALL cl_err(tm.plant_3,g_errno,0)
                      NEXT FIELD plant_3
                   END IF
                   LET g_ary[3].plant = tm.plant_3
                   LET g_ary[3].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.plant_3   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_3) THEN  
                      NEXT FIELD plant_3 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[3].plant = tm.plant_3
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_3) THEN
                IF NOT r859_chklegal(m_legal[3],2) THEN
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
                   IF NOT r859_chkplant(tm.plant_4) THEN
                      CALL cl_err(tm.plant_4,g_errno,0)
                      NEXT FIELD plant_4
                   END IF
                   LET g_ary[4].plant = tm.plant_4
                   LET g_ary[4].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.plant_4  #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_4) THEN  
                      NEXT FIELD plant_4 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[4].plant = tm.plant_4
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_4) THEN
                IF NOT r859_chklegal(m_legal[4],3) THEN
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
                   IF NOT r859_chkplant(tm.plant_5) THEN
                      CALL cl_err(tm.plant_5,g_errno,0)
                      NEXT FIELD plant_5
                   END IF
                   LET g_ary[5].plant = tm.plant_5
                   LET g_ary[5].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.plant_5  #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_5) THEN  
                      NEXT FIELD plant_5 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[5].plant = tm.plant_5
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_5) THEN
                IF NOT r859_chklegal(m_legal[5],4) THEN
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
                   IF NOT r859_chkplant(tm.plant_6) THEN
                      CALL cl_err(tm.plant_6,g_errno,0)
                      NEXT FIELD plant_6
                   END IF
                   LET g_ary[6].plant = tm.plant_6
                   LET g_ary[6].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.plant_6   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_6) THEN  
                      NEXT FIELD plant_6 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[6].plant = tm.plant_6
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_6) THEN
                IF NOT r859_chklegal(m_legal[6],5) THEN
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
                   IF NOT r859_chkplant(tm.plant_7) THEN
                      CALL cl_err(tm.plant_7,g_errno,0)
                      NEXT FIELD plant_7
                   END IF
                   LET g_ary[7].plant = tm.plant_7
                   LET g_ary[7].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.plant_7  #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_7) THEN  
                      NEXT FIELD plant_7 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[7].plant = tm.plant_7
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_7) THEN
                IF NOT r859_chklegal(m_legal[7],6) THEN
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
                   IF NOT r859_chkplant(tm.plant_8) THEN
                      CALL cl_err(tm.plant_8,g_errno,0)
                      NEXT FIELD plant_8
                   END IF
                   LET g_ary[8].plant = tm.plant_8
                   LET g_ary[8].dbs_new = g_dbs_new
                   SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.plant_8   #FUN-A70084
                   IF NOT s_chk_demo(g_user,tm.plant_8) THEN  
                      NEXT FIELD plant_8 
                   END IF              
                ELSE           # 輸入之工廠編號為' '或NULL
                   LET g_ary[8].plant = tm.plant_8
                END IF
             END IF 
             #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
             IF NOT cl_null(tm.plant_8) THEN
                IF NOT r859_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end
 
         AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
                
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
##
 
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
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_1
                    CALL cl_create_qry() RETURNING tm.plant_1
                    DISPLAY BY NAME tm.plant_1
                    NEXT FIELD plant_1
 
               WHEN INFIELD(plant_2)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_2
                    CALL cl_create_qry() RETURNING tm.plant_2
                    DISPLAY BY NAME tm.plant_2
                    NEXT FIELD plant_2
 
               WHEN INFIELD(plant_3)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_3
                    CALL cl_create_qry() RETURNING tm.plant_3
                    DISPLAY BY NAME tm.plant_3
                    NEXT FIELD plant_3
 
               WHEN INFIELD(plant_4)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_4
                    CALL cl_create_qry() RETURNING tm.plant_4
                    DISPLAY BY NAME tm.plant_4
                    NEXT FIELD plant_4
 
               WHEN INFIELD(plant_5)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_5
                    CALL cl_create_qry() RETURNING tm.plant_5
                    DISPLAY BY NAME tm.plant_5
                    NEXT FIELD plant_5
 
               WHEN INFIELD(plant_6)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_6
                    CALL cl_create_qry() RETURNING tm.plant_6
                    DISPLAY BY NAME tm.plant_6
                    NEXT FIELD plant_6
 
               WHEN INFIELD(plant_7)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
                    LET g_qryparam.default1 = tm.plant_7
                    CALL cl_create_qry() RETURNING tm.plant_7
                    DISPLAY BY NAME tm.plant_7
                    NEXT FIELD plant_7
 
               WHEN INFIELD(plant_8)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                    LET g_qryparam.arg1 = g_user                #No.FUN-940102
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
##
 
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
               cl_null(tm.plant_7) AND cl_null(tm.plant_8) AND l_cnt <=1 THEN  #FUN-A70084 add l_cnt<=1
               CALL cl_err(0,'aap-136',0) 
               NEXT FIELD plant_1
            END IF
          #FUN-A70084--add--str--Single DB
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
          END IF     #FUN-A70084
 
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
      CLOSE WINDOW r859_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr859'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr859','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.a      CLIPPED,"'",
                         " '",tm.yy1_b   CLIPPED,"'",
                         " '",tm.mm1_b   CLIPPED,"'",
                         " '",tm.mm1_e   CLIPPED,"'",
                         " '",tm.plant_1 CLIPPED,"'",
                         " '",tm.plant_2 CLIPPED,"'",
                         " '",tm.plant_3 CLIPPED,"'",
                         " '",tm.plant_4 CLIPPED,"'",
                         " '",tm.plant_5 CLIPPED,"'",
                         " '",tm.plant_6 CLIPPED,"'",
                         " '",tm.plant_7 CLIPPED,"'",
                         " '",tm.plant_8 CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,           #No.FUN-7C0101 add
                         " '",tm.azk01   CLIPPED,"'",
                         " '",tm.azk04   CLIPPED,"'",
                         " '",tm.dec CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template  CLIPPED,"'",
                         " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr859',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   CALL cl_wait()
   CALL r859()
   ERROR ""
 
END WHILE
CLOSE WINDOW r859_w
 
END FUNCTION
 
FUNCTION r859()
   DEFINE l_name    LIKE type_file.chr20,       #No.FUN-680122CHAR(20)        # External(Disk) file name
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680122 VARCHAR(2000)
          l_item    LIKE ccg_file.ccg04,        #No.FUN-680122 VARCHAR(20)    
          l_ccg04   LIKE ccg_file.ccg04,        #No.FUN-680122 VARCHAR(20)  
          l_tmp     LIKE type_file.chr10,       #No.FUN-680122 VARCHAR(8)  #No.TQC-6A0079
          l_za05    LIKE ima_file.ima01,        #No.FUN-680122 VARCHAR(40)   
          l_flag    LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
          l_cta     RECORD
              item   LIKE ccg_file.ccg04,        #No.FUN-680122CHAR(20)
              descc  LIKE oba_file.oba02,        #No.FUN-680122CHAR(30)     
              ccg04  LIKE ccg_file.ccg04,        #No.FUN-680122CHAR(20)     
              ccg07  LIKE ccg_file.ccg07,        #No.FUN-7C0101 add
              ima02  LIKE ima_file.ima02,        #No.FUN-680122CHAR(30)     
          #    qty1   LIKE ima_file.ima26,        #No.FUN-680122DEC(15,3)#FUN-A20044
              qty1   LIKE type_file.num15_3,        #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1   LIKE type_file.num20_6,     #No.FUN-680122 DEC(20,6)     
           #   qty2   LIKE ima_file.ima26,        #No.FUN-680122DEC(15,3)     #FUN-A20044
              qty2   LIKE type_file.num15_3,        #No.FUN-680122DEC(15,3)     #FUN-A20044
              amt2   LIKE type_file.num20_6      #No.FUN-680122 DEC(20,6)     
              END RECORD,
          sr  RECORD
              item   LIKE ccg_file.ccg04,        #No.FUN-680122CHAR(20)     
              oba02  LIKE oba_file.oba02,        #No.FUN-680122CHAR(30)     
              ccg04  LIKE ccg_file.ccg04,        #No.FUN-680122CHAR(20)   
              ccg07  LIKE ccg_file.ccg07,        #No.FUN-7C0101 add
              ima02  LIKE ima_file.ima02,        #No.FUN-680122CHAR(30)     
            #  qty1   LIKE ima_file.ima26,        #No.FUN-680122DEC(15,3)     #FUN-A20044
              qty1   LIKE type_file.num15_3,        #No.FUN-680122DEC(15,3)     #FUN-A20044
              amt1  LIKE type_file.num20_6,      #No.FUN-680122DEC(20,6)     
            #  qty2  LIKE ima_file.ima26,         #No.FUN-680122DEC(15,3)     #FUN-A20044
              qty2  LIKE type_file.num15_3,         #No.FUN-680122DEC(15,3)     #FUN-A20044
              amt2  LIKE type_file.num20_6       #No.FUN-680122DEC(20,6)     
              END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720042 add
 
   CALL get_tmpfile()
   IF tm.a='N' THEN
      LET l_sql=" SELECT item,descc,'',ccg07,'',SUM(qty1),SUM(amt1),",  #No.FUN-7C0101 add ccg07
                " SUM(qty2),SUM(amt2) ",
                "  FROM ",g_tname,
                " GROUP BY item,descc,ccg07 ORDER BY item,descc,ccg07"  #No.FUN-7C0101 add ccg07
   ELSE
      LET l_sql=" SELECT item[1,1],'','',ccg07,'',SUM(qty1),SUM(amt1),",#No.FUN-7C0101 add ccg07
                " SUM(qty2),SUM(amt2) ",
                "  FROM ",g_tname,
                " GROUP BY item,ccg07 ORDER BY item[1,1],ccg07"   #NO:6620 #No.FUN-7C0101 add ccg07
   END IF
   PREPARE r859_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE r859_curs1 CURSOR FOR r859_prepare1
 
   LET g_pageno = 0
   LET l_flag=null
   LET l_item=null
   LET l_ccg04=null
   FOREACH r859_curs1 INTO l_cta.*
      IF l_cta.item IS NULL OR l_cta.item='' THEN 
         LET l_cta.item='0'
      END IF 
      IF SQLCA.SQLCODE != 0 THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
      END IF
      IF l_cta.amt1 < 0 THEN LET l_cta.amt1 = l_cta.amt1 * -1 END IF
      IF l_cta.qty1 < 0 THEN LET l_cta.qty1 = l_cta.qty1 * -1 END IF
      LET l_cta.qty2 = l_cta.qty2 * -1 
      LET l_cta.amt1=l_cta.amt1/g_base
      LET l_cta.amt2=l_cta.amt2/g_base
      IF tm.azk04 >0 THEN
         LET l_cta.amt1=l_cta.amt1/tm.azk04
         LET l_cta.amt2=l_cta.amt2/tm.azk04
      END IF
      LET sr.ccg04=l_cta.ccg04
      LET sr.ccg07=l_cta.ccg07  #No.FUN-7C0101 add
      LET sr.item=l_cta.item
      LET sr.ima02=l_cta.ima02
      LET sr.oba02=l_cta.descc 
      LET sr.qty1=l_cta.qty1
      LET sr.amt1=l_cta.amt1
      LET sr.qty2=l_cta.qty2
      LET sr.amt2=l_cta.amt2
      IF sr.qty1=0 AND sr.amt1=0 AND sr.qty2=0 AND sr.amt2=0  THEN
         CONTINUE FOREACH
      END IF
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
              sr.item,sr.oba02,sr.ccg04,sr.ccg07,sr.qty1,sr.amt1,sr.qty2,sr.amt2 #No.FUN-7C0101 add ccg07
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'ima131,ima01')   #MOD-A70199 mod ccg04->ima01
           RETURNING g_wc
      LET g_str = g_wc
   ELSE
      LET g_str = " "
   END IF
   LET g_str = g_str,";",tm.a,";",tm.yy1_b,";",tm.mm1_b,";",
                         tm.mm1_e,";",tm.plant_1,";",
                         tm.plant_2,";",tm.plant_3,";",tm.plant_4,";",
                         tm.plant_5,";",tm.plant_6,";",tm.plant_7,";",
                         #tm.plant_8,";",g_ccz.ccz27,";",g_azi03,";",tm.type    #FUN-710080 modify   #No.FUN-7C0101 add tm.type #CHI-C30012
                         tm.plant_8,";",g_ccz.ccz27,";",g_ccz.ccz26,";",tm.type #CHI-C30012
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr859','axcr859_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr859','axcr859',l_sql,g_str)
   END IF
 
   PREPARE del_cmd FROM g_delsql   #No.MOD-9A0053 add
   EXECUTE del_cmd
END FUNCTION
 
FUNCTION get_tmpfile()
  DEFINE tmp_sql   LIKE type_file.chr1000       #No.FUN-680122CHAR(1000)
  DEFINE l_col1    LIKE type_file.chr1000       #CHI-C50069 add
  DEFINE l_col2    LIKE type_file.chr1000       #CHI-C50069 add
 
LET g_tname='r859_tmp'                          #No.TQC-980163 mod
LET g_delsql= " DROP TABLE ",g_tname CLIPPED
PREPARE del_cmdx FROM g_delsql
EXECUTE del_cmdx
LET tmp_sql=
#FUN-A10098---BEGIN
#     "CREATE TEMP TABLE ",g_tname CLIPPED,   #No.TQC-970305 mod
#             #MOD-710122---mod---end---
#             #"(item  VARCHAR(20),",
#             #" descc  VARCHAR(30),",
#             #" ccg04  VARCHAR(20),",
#             #" ima02  VARCHAR(30),",
#              "(item  VARCHAR(40),",
#              " descc  VARCHAR(60),",
#              " ccg04  VARCHAR(40),",
#              " ccg07  VARCHAR(40),",    #No.FUN-7C0101 add
#              " ima02  VARCHAR(60),",
#             #MOD-710122---mod---end---
#              " qty1   DEC(15,3),",
#              " amt1   DEC(20,6),",
#              " qty2   DEC(15,3),",
#              " amt2   DEC(20,6)) "
     "CREATE TEMP TABLE ",g_tname CLIPPED,   #No.TQC-970305 mod
              "(item   LIKE ccg_file.ccg04,",
              " descc  LIKE ima_file.ima02,",
              " ccg04  LIKE ccg_file.ccg04,",
              " ccg07  LIKE ccg_file.ccg07,",    #No.FUN-7C0101 add
              " ima02  LIKE ima_file.ima02,",
              " qty1   LIKE type_file.num15_3,",#FUN-A20044  #No.TQC-A40139
              " amt1   LIKE type_file.num20_6,",
              " qty2   LIKE type_file.num15_3,",#FUN-A20044  #No.TQC-A40139
              " amt2   LIKE type_file.num20_6) "

#FUN-A10098---END
    PREPARE cre_p1 FROM tmp_sql
    EXECUTE cre_p1
    IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err(g_tname ,SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
 
    CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_b,tm.mm1_e) RETURNING g_bdate,g_edate
#生產量值
    FOR g_idx=1 TO g_k
        LET tmp_sql= " INSERT INTO ",g_tname,
        " SELECT ima131,oba02,ccg04,ccg07,' ',SUM(ccg31*-1),", #No.FUN-7C0101 add ccg07
          "        SUM(ccg32*-1),0,0",
#FUN-A10098---BEGIN
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),
              " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
              " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
#              " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#              " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
#FUN-A10098---END
          " WHERE ",g_wc CLIPPED,
          "   AND ccg02=",tm.yy1_b,
          "   AND ccg03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e,
          "   AND ccg06='",tm.type,"'",                #No.FUN-7C0101 add
          "   AND ccg04=ima01 ",
          "   AND ima_file.ima131=oba_file.oba01 ",
          " GROUP BY ima131,oba02,ccg04,ccg07"         #No.FUN-7C0101 add ccg07
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r859_prepare2 FROM tmp_sql
          EXECUTE r859_prepare2
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM 
          END IF
      
    END FOR  #for g_inx  dbs
 
##------重工部分-----------
        FOR g_idx=1 TO g_k
            LET tmp_sql= " INSERT INTO ",g_tname,
            " SELECT ima131,oba02,ccg04,ccg07,' ',SUM(cch21*-1),", #No.FUN-7C0101 add ccg07
              "        SUM(cch22*-1),0,0",
#FUN-A10098---BEGIN
#              " FROM ",g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
#                 " ,",g_ary[g_idx].dbs_new CLIPPED,"cch_file",
#                 " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#                 " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
              " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),
                 " ,",cl_get_target_table(g_ary[g_idx].plant,'cch_file'),
                 " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
                 " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#FUN-A10098---END
              " WHERE ",g_wc CLIPPED,
              "   AND ccg02=",tm.yy1_b,
              "   AND ccg03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e,
              "   AND ccg06='",tm.type,"'",               #No.FUN-7C0101 add 
              "   AND ccg01 = cch01 AND ccg02=cch02 AND ccg03=cch03",
              "   AND ccg06 = cch06 AND ccg07=cch07",     #No.FUN-7C0101 add
              "   AND cch05='R' AND cch31 < 0",
             #"   AND ccg04=ima01 ",                                        #MOD-A70199 mark
             #"   AND ccg04=cch04",                       #No.TQC-A40139    #MOD-A70199 mark
              "   AND ((ccg04=ima01 AND ccg04=cch04) OR cch04=ima01) ",     #MOD-A70199
              "   AND ima_file.ima131=oba_file.oba01 ",
              " GROUP BY ima131,oba02,ccg04,ccg07"        #No.FUN-7C0101 add ccg07
 
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
       #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
        PREPARE r859_prepare10 FROM tmp_sql
        EXECUTE r859_prepare10
        IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
            EXECUTE del_cmdx #delete tmpfile
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
            EXIT PROGRAM 
        END IF
    END FOR
#銷售量值
#CHI-C50069---add---START
    CASE tm.b
      WHEN '1'
        LET l_col1 = "ima131,oba02,ccc01,ccc08,' ',0,0,SUM(ccc61),SUM(ccc63)"
        LET l_col2 = "(ccc61!=0 OR ccc63!=0 OR ccc62!=0) "
      WHEN '2'
        LET l_col1 = "ima131,oba02,ccc01,ccc08,' ',0,0,SUM(ccc81),0"
        LET l_col2 = "ccc81!=0 "
      WHEN '3'
        LET l_col1 = "ima131,oba02,ccc01,ccc08,' ',0,0,(SUM(ccc61)+SUM(ccc81)),SUM(ccc63)"
        LET l_col2 = "(ccc61!=0 OR ccc63!=0 OR ccc62!=0 OR ccc81!=0) "
    END CASE
#CHI-C50069---add-----END
    LET g_wc=change_string(g_wc,"ima01","ccc01") #No: 9678   #MOD-A70199 mod ccg04->ima01
    FOR g_idx=1 TO g_k
        LET tmp_sql= " INSERT INTO ",g_tname,
                  #" SELECT ima131,oba02,ccc01,ccc08,' ',0,0,(SUM(ccc61)+sum(ccc81)),SUM(ccc63)",  #No.FUN-660073 #No.FUN-7C0101 add ccc08 #CHI-C50069 mark
                   " SELECT ",l_col1 CLIPPED,  #CHI-C50069 add
#FUN-A10098---BEGIN
#                   "   FROM ",g_ary[g_idx].dbs_new CLIPPED,"ccc_file",
#                   " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#                   " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
                   "   FROM ",cl_get_target_table(g_ary[g_idx].plant,'ccc_file'),
                   " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
                   " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#FUN-A10098---END
                   " WHERE ",g_wc CLIPPED,
                   "   AND ccc02=",tm.yy1_b,"",
                   "   AND ccc03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e,"",
                   "   AND ccc07='",tm.type,"'",       #No.FUN-7C0101 add   #No.MOD-910088 modify
                   "   AND ccc01=ima01",
                   "   AND ima_file.ima131=oba_file.oba01",
                   "   AND (ccc61!=0 OR ccc63!=0 OR ccc62!=0) ",
                  #"   AND (ccc61!=0 OR ccc63!=0 OR ccc62!=0) ", #CHI-C50069 mark
                   "   AND ",l_col2 CLIPPED, #CHI-C50069 add
                   " GROUP BY ima131,oba02,ccc01,ccc08" #No.FUN-7C0101 add ccc08
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
         #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
          PREPARE r859_prepare3 FROM tmp_sql
          EXECUTE r859_prepare3
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM 
          END IF
    END FOR  #for g_inx  dbs
END FUNCTION
 
FUNCTION get_dpm()
  DEFINE l_wc     LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
         tmp_sql  LIKE type_file.chr1000,       #No.FUN-680122CHAR(1000)
         f1,f2,f3 LIKE type_file.num20_6,       #No.FUN-680122DECIMAL(20,6)
         l_dpm RECORD
                ctv01  LIKE type_file.chr20,    #No.FUN-680122CHAR(20)   
                ima02  LIKE ima_file.ima02,     #No.FUN-680122CHAR(30)  
                item   LIKE oba_file.oba02,     #No.FUN-680122CHAR(20)  
                oba02  LIKE oba_file.oba02,     #No.FUN-680122CHAR(20)  
                qty    LIKE aao_file.aao06,     #No.FUN-680122DEC(15,3)    #數量(銷)
                amt    LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6)   #金額(銷)
               # qty1   LIKE ima_file.ima26,     #No.FUN-680122DEC(15,3)    #數量(退)#FUN-A20044
                qty1   LIKE type_file.num15_3,     #No.FUN-680122DEC(15,3)    #數量(退)#FUN-A20044
                amt1   LIKE type_file.num20_6,  #No.FUN-680122 DEC(20,6) #金額(退)
                dae_amt LIKE type_file.num20_6,  #No.FUN-680122DEC(20,6) #折讓
                dac_amt LIKE type_file.num20_6  #No.FUN-680122DEC(20,6)  #雜項發票
              END RECORD
 
    LET g_tname1='r859_tmp1'                            #No.TQC-980163 mod
    LET g_delsql1= " DROP TABLE ",g_tname1 CLIPPED
    PREPARE del_dpm FROM g_delsql1
    EXECUTE del_dpm
#FUN-A10098---BEGIN
#      LET tmp_sql= "CREATE TEMP TABLE ",g_tname1 CLIPPED,  #No.TQC-970305 mod
#                #MOD-710122---mod---str---
#               #"(ctv01  VARCHAR(20),",
#               #" ima02  VARCHAR(30),",
#               #" item  VARCHAR(20),",
#               #" oba02  VARCHAR(20),",
#                "(ctv01  VARCHAR(40),",
#                " ima02  VARCHAR(60),",
#                " item  VARCHAR(40),",
#                " oba02  VARCHAR(40),",
#                #MOD-710122---mod---end---
#                  " qty    DEC(15,3),",  #數量(銷)
#                  " amt    DEC(20,6),",  #金額(銷)
#                  " qty1   DEC(15,3),",  #數量(退)
#                  " amt1   DEC(20,6),",  #金額(退)
#                  " dae_amt DEC(20,6),", #折讓
#                  " dac_amt DEC(20,6))"  #雜項發票
      LET tmp_sql= "CREATE TEMP TABLE ",g_tname1 CLIPPED,  #No.TQC-970305 mod
                "(ctv01  LIKE ima_file.ima01,",  #No.TQC-A40139
                " ima02  LIKE ima_file.ima02,",
                " item   LIKE ima_file.ima01,",  #No.TQC-A40139
                " oba02  LIKE oba_file.oba02,",
                  " qty    LIKE type_file.num15_3,",  #數量(銷)#FUN-A20044  #No.TQC-A40139
                  " amt    LIKE type_file.num20_6,",  #金額(銷)
                  " qty1   LIKE type_file.num15_3,",  #數量(退)#FUN-A20044  #No.TQC-A40139
                  " amt1   LIKE type_file.num20_6,",  #金額(退)
                  " dae_amt LIKE type_file.num20_6,", #折讓
                  " dac_amt LIKE type_file.num20_6)"  #雜項發票

#FUN-A10098---END
    PREPARE cre_dpm FROM tmp_sql
    EXECUTE cre_dpm
    IF SQLCA.sqlcode != 0 THEN 
       CALL cl_err('Create tmp_dpm:' ,SQLCA.sqlcode,1) 
 
     # EXECUTE del_cmdx
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM
    END IF
 
###內部自用銷貨
    LET l_wc=g_wc
    LET l_wc=change_string(l_wc,"ccc01","tlf01")
    FOR g_idx=1 TO g_k
        LET tmp_sql= " INSERT INTO ",g_tname1,
                     " SELECT tlf01,ima02,ima131,oba02,",
                      " SUM(tlf10*tlf60*tlf907),SUM(ogb14t*oga24*tlf907),0,0,0,0", #MOD-570077
#FUN-A10098---BEGIN
#                     " FROM ",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"oga_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"ogb_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#                     " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
                     " FROM ",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
                     " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#FUN-A10098---END
                     " WHERE ",l_wc CLIPPED,
                     " AND tlf03 = 724  AND tlf02 = 50 ",
                     " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                     " AND tlf01=ima01 AND tlf19 = occ01 AND occ37 = 'Y' ",
                     " AND tlf026=ogb01 AND tlf027=ogb03 AND ogb01=oga01 ",
                     " AND ima131 = oba_file.oba01",
                     " AND oga00 NOT IN ('A','3','7') ",      #No.MOD-950210 add
                     " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                     " GROUP BY tlf01,ima02,ima131,oba02"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
       #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
        PREPARE r859_predpm FROM tmp_sql 
        EXECUTE r859_predpm
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('predpm:',SQLCA.sqlcode,1) 
          #  EXECUTE del_dpm 
         END IF
    END FOR
###內部自用退貨
    FOR g_idx=1 TO g_k
          LET tmp_sql= " INSERT INTO ",g_tname1,
          " SELECT tlf01,ima02,ima131,oba02,0,0,",
           " SUM(tlf10*tlf60*tlf907),SUM(ohb14t*oha24*tlf907),0,0", #MOD-570077
#FUN-A10098---BEGIN
#          " FROM ",g_ary[g_idx].dbs_new CLIPPED,"occ_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"tlf_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"oha_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ohb_file",
#          " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#          " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'tlf_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),
          " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
          " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#FUN-A10098---END
          " WHERE ",l_wc CLIPPED,
          " AND tlf02 = 731 AND tlf03 = 50 ",
          " AND tlf13 = 'aomt800'",
          " AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
          " AND tlf01=ima01 AND oha03 = occ01 AND occ37 = 'Y'",
          " AND tlf036=ohb01 AND tlf037=ohb03 AND ohb01=oha01 ",
          " AND ima131 = oba_file.oba01",
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " GROUP BY tlf01,ima02,ima131,oba02"
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
      #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark 
       PREPARE r859_pregsl FROM tmp_sql
       EXECUTE r859_pregsl
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('pregsl:',SQLCA.sqlcode,1) 
      #   EXECUTE del_dpm
       END IF
    END FOR
###折讓
    LET l_wc=g_wc
    LET l_wc=change_string(l_wc,"ccc01","omb04")
    FOR g_idx=1 TO g_k
        LET tmp_sql= " INSERT INTO ",g_tname1,
                     " SELECT omb04,ima02,ima131,oba02,",
                     " 0,0,0,0,omb16,0 ",
#FUN-A10098---BEGIN
#                     " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#                     " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
                     " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
                     " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#FUN-A10098---END
                     " WHERE oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                     "   AND oma01 = omb01",
                     "   AND omb04[1,4] <> 'MISC'",   #MOD-710129 mod
                     "   AND oma00 = '21'",
                     "   AND omb04 = ima01",
                     "   AND ima131 = oba_file.oba01",
                     "   AND ",l_wc CLIPPED
 
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
      #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098   #TQC-BB0182 mark
       PREPARE r859_predae FROM tmp_sql
        EXECUTE r859_predae
          IF SQLCA.sqlcode != 0 THEN 
           # EXECUTE del_dpm
             CALL cl_err('predae:',SQLCA.sqlcode,1) 
          END IF
    END FOR
###雜項發票 
    FOR g_idx=1 TO g_k
        LET tmp_sql= " INSERT INTO ",g_tname1,
                     " SELECT omb04,ima02,ima131,oba02,",
                     " 0,0,0,0,0,omb16 ",
#FUN-A10098---BEGIN
#                     " FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"omb_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
#                     " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
#                     " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
                     " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),
                     " ,",cl_get_target_table(g_ary[g_idx].plant,'ima_file'),
                     " ,OUTER ",cl_get_target_table(g_ary[g_idx].plant,'oba_file'),
#FUN-A10098---END
                     " WHERE ",l_wc CLIPPED,
                     "   AND oma02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                     "   AND oma01=omb01 AND oma00 = '14'",
                     "   AND oma10 = ome01",
                     "   AND omevoid = 'N'",
                     "   AND (oma75 = ome03 OR oma75 IS NULL)",    #No.FUN-B90130 
                     "   AND omb04[1,4] <> 'MISC'",  #MOD-710129 mod
                     "   AND omavoid = 'N'",
                     "   AND omb04=ima01 AND ima_file.ima131=oba_file.oba01 "
 	 CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql        #FUN-920032
      #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
        PREPARE r859_predac FROM tmp_sql
        EXECUTE r859_predac
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('predac:',SQLCA.sqlcode,1) 
          END IF
    END FOR
 
    LET tmp_sql=" SELECT * FROM ",g_tname1 CLIPPED
    PREPARE r859_union FROM tmp_sql
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('prepare union_tmp:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM 
      END IF
 
    DECLARE union_cur CURSOR FOR r859_union
    FOREACH union_cur INTO l_dpm.*
      IF l_dpm.ctv01 IS NULL THEN CONTINUE FOREACH END IF
      LET f1=-l_dpm.qty
      LET f2=-l_dpm.amt+l_dpm.dac_amt-l_dpm.dae_amt 
      IF f1 IS NULL THEN LET f1=0 END IF
      IF f2 IS NULL THEN LET f2=0 END IF
      LET tmp_sql=" INSERT INTO ",g_tname,
                 " VALUES ('",l_dpm.item CLIPPED,"'",
                           ",'",l_dpm.oba02 CLIPPED,"'",
                           ",'",l_dpm.ctv01 CLIPPED,"'",
                           ",'',0,0",
                           ",",f1,
                           ",",f2,
                           ")"
      PREPARE pre_sql1 FROM tmp_sql
      EXECUTE pre_sql1
      IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('insert gtname error:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
    END FOREACH 
END FUNCTION
#No.TQC-A40130  --Begin
#REPORT r859_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
#         dec_name     LIKE type_file.chr20,       #No.FUN-680122 VARCHAR(10)
#          sr  RECORD
#              item   LIKE oba_file.oba02,        #No.FUN-680122 VARCHAR(20)
#              oba02  LIKE oba_file.oba02,        #No.FUN-680122 VARCHAR(30)
#              ccg04  LIKE ccg_file.ccg04,        #No.FUN-680122 VARCHAR(20)
#              ima02  LIKE ima_file.ima02,        #No.FUN-680122 VARCHAR(30)
#           #   qty1   LIKE ima_file.ima26,        #No.FUN-680122DEC(15,3)#FUN-A20044
#              qty1   LIKE type_file.num15_3,        #No.FUN-680122DEC(15,3)#FUN-A20044
#              amt1   LIKE type_file.num20_6,     #No.FUN-680122 DECIMAL(20,6)
#           #   qty2   LIKE ima_file.ima26,        #No.FUN-680122DEC(15,3)#FUN-A20044
#              qty2   LIKE type_file.num15_3,        #No.FUN-680122DEC(15,3)#FUN-A20044
#              amt2   LIKE type_file.num20_6     #No.FUN-680122 DECIMAL(20,6)
#              END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.item,sr.ccg04 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[11],tm.yy1_b USING '####', '/',
#            tm.mm1_b using '##', ' -',
#            tm.mm1_e using '##'
#      PRINT g_dash
#      PRINT COLUMN 62,g_x[16],COLUMN 87,g_x[17]
#      PRINT COLUMN g_c[33],g_dash2[1,g_w[33]+g_w[34]+1],
#            COLUMN g_c[35],g_dash2[1,g_w[35]+g_w[36]+1]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#   
#   ON EVERY ROW 
#      PRINT COLUMN g_c[31],sr.item[1,10] CLIPPED,
#            COLUMN g_c[32],sr.oba02,
#            COLUMN g_c[33],cl_numfor(sr.qty1,33,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[34], cl_numfor(sr.amt1,34,g_azi03),    #FUN-570190
#            COLUMN g_c[35], cl_numfor(sr.qty2,35,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[36], cl_numfor(sr.amt2,36,g_azi03)    #FUN-570190
#   ON LAST ROW
#      PRINT g_dash2
#      PRINT COLUMN g_c[32],g_x[15] CLIPPED,
#            COLUMN g_c[33],cl_numfor(SUM(sr.qty1),33,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[34],cl_numfor(SUM(sr.amt1),34,g_azi03),    #FUN-570190
#            COLUMN g_c[35],cl_numfor(SUM(sr.qty2),35,g_ccz.ccz27), #CHI-690007 0->ccz27
#            COLUMN g_c[36],cl_numfor(SUM(sr.amt2),36,g_azi03)    #FUN-570190
# 
#      LET l_last_sw = 'y'
#      PRINT g_dash
#      PRINT 'DATA FROM : ',
#            g_ary[1].plant CLIPPED,' ', g_ary[2].plant CLIPPED,' ',
#            g_ary[3].plant CLIPPED,' ', g_ary[4].plant CLIPPED,' ',
#            g_ary[5].plant CLIPPED,' ', g_ary[6].plant CLIPPED,' ',
#            g_ary[7].plant CLIPPED,' ', g_ary[8].plant CLIPPED
#      PRINT g_dash
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9,g_x[7] CLIPPED     #No.TQC-710016
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash2[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9,g_x[6] CLIPPED     #No.TQC-710016
#      ELSE SKIP 2 LINE
#      END IF
#END REPORT 
#No.TQC-A40130  --End  
FUNCTION duplicate(l_plant,n)               #檢查輸入之工廠編號是否重覆
   DEFINE l_plant     LIKE azp_file.azp01,
          l_idx,n     LIKE type_file.num10         #No.FUN-680122INTGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = '' 
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
FUNCTION change_string(old_string, old_sub, new_sub)
  DEFINE query_text   LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
         AA           LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
         old_string   LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
         xxx_string   LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)
         old_sub      LIKE type_file.chr1000,       #No.FUN-680122CHAR(128)
         new_sub      LIKE type_file.chr1000,       #No.FUN-680122CHAR(128)
         first_byte   LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
         nowx_byte    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
         next_byte    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
         this_byte    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
         length1, length2, length3   LIKE type_file.num5,          #No.FUN-680122SMALLINT
         pu1, pu2                    LIKE type_file.num5,          #No.FUN-680122SMALLINT
         ii, jj, kk, ff, tt          LIKE type_file.num5           #No.FUN-680122SMALLINT
 
LET length1 = length(old_string)
LET length2 = length(old_sub)
LET length3 = length(new_sub)
LET first_byte = old_sub[1,1]
LET xxx_string = " "
LET pu1 = 0
 
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
END FOR
LET query_text = xxx_string
            LET INT_FLAG = 0  ######add for prompt bug
RETURN query_text
END FUNCTION
 
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r859_getStartPos(l_sta,l_end,l_str)
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
 
FUNCTION r859_chkplant(l_plant)
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
FUNCTION r859_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group02",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r859_chklegal(l_legal,n)
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
