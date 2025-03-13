# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr111.4gl
# Descriptions...: 產品別單位成本分析表
# Date & Author..: 
# Modify.........: No:8488 tm.azk01='TWD' 改為 tm.azk01=g_aza.aza17
# Modify.........: No:8759 03/11/25 Apple 工廠編號 畫面可輸入10碼,但程式只宣告6碼(更正 宣告8碼)
# Modify.........: No:8741 03/11/25 By Melody 修改PRINT段 
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0099 04/12/27 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-580105 05/08/25 by rosayu 工廠可以開窗查詢
# Modify.........: No.FUN-5B0082 05/11/17 By Sarah 報表少印"委外","其他"欄位
# Modify.........: No.TQC-610051 06/02/13 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-620066 06/03/02 By Sarah 組SQL抓資料時,多抓重覆性生產料件資料(ima911='Y')
# Modify.........: No.MOD-630040 06/03/10 By Claire 金額全部以azi03取位
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/01/05 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-760141 07/06/15 By Sarah 報表的製表日期與FROM/頁次等..應該在雙線的上一行(標準)
# Modify.........: No.MOD-7A0164 07/10/26 By Carol ima01,ima02,oba02,order_l type放大
# Modify.........: No.FUN-7C0101 08/01/29 By Zhangyajun 成本改善增加成本計算類型字段(type)
# Modify.........: No.FUN-840005 08/04/10 By Zhangyajun 報表BUG修改
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-970305 09/07/30 By liuxqa create table 改為CREATE TEMP TABLE.
# Modify.........: No.MOD-970270 09/07/30 By mike 請改用LIKE方式定義欄位資料型態   
# Modify.........: No.TQC-980163 09/09/01 By liuxqa 調整出現-206的錯誤。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970165 09/09/21 By baofei IF tm.mm3_e >0 THEN  SQL中ccg07后少了一個','                                    
#                                                   SELECT azi07 INTO t_azi07 FROM azi_file WHERE zai01 = tm.azk01 <-- zai01        
# Modify.........: No:MOD-9B0144 09/11/24 By sabrina 總金額漏加製費3,4,5的金額
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡 
# Modify.........: No.FUN-A10098 10/01/21 By wuxj GP5.2跨DB報表，財務類
# Modify.........: No.TQC-A30006 10/03/03 By wuxj FUN-A10098， LEFT OUTER JOIN 問題修正  
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:MOD-A30221 10/03/30 By Summer 與axcr772報表不合,原為入庫數量=0的工單不撈取,調整成入庫成本=0的工單不撈取
# Modify.........: No:TQC-A40130 10/04/27 By Carrier create temp table报错误
# Modify.........: No.FUN-A70084 10/07/23 By lutingting GP5.2報表修改
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: No:MOD-C30791 12/03/20 By ck2yuan 避免直接按確定導致一些值沒給,故在AFTER INPUT給值
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc        LIKE type_file.chr1000       #No.FUN-680122CHAR(300)
   DEFINE l_fd1       LIKE type_file.chr1000        #No.FUN-680122CHAR(200)
   DEFINE l_fd2       LIKE type_file.chr1000        #No.FUN-680122CHAR(200)
   DEFINE l_fd3       LIKE type_file.chr1000        #No.FUN-680122CHAR(200)
   DEFINE l_fd4       LIKE type_file.chr1000        #No.FUN-680122CHAR(200)
   DEFINE tmp_sql     LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
   DEFINE first_flag  LIKE type_file.num5           #No.FUN-680122SMALLINT 
   DEFINE tm  RECORD            
              ima01   LIKE ima_file.ima01,
              ima131  LIKE ima_file.ima131,
              ima11   LIKE ima_file.ima11,
              ima57   LIKE ima_file.ima57,
              s_code  LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              yy1_b,mm1_b,mm1_e LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              yy2_b,mm2_b,mm2_e LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              yy3_b,mm3_b,mm3_e LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              yy4_b,mm4_b,mm4_e LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              yy5_b,mm5_b,mm5_e LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              yy6_b,mm6_b,mm6_e LIKE type_file.num5,           #No.FUN-680122SMALLINT 
              plant_1,plant_2,plant_3,plant_4,plant_5 LIKE cre_file.cre08,           #No.FUN-680122 VARCHAR(10) #No:8759
              plant_6,plant_7,plant_8 LIKE cre_file.cre08,           #No.FUN-680122 VARCHAR(10)                 #No:8759
              type    LIKE type_file.chr1,           #No.FUN-7C0101 VARCHAR(1)
              duc_code LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              detail  LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              dec     LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01)      #金額單位(1)元(2)千(3)萬
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(01)
              END RECORD
 
 
   DEFINE g_orderA    ARRAY[2] OF LIKE cre_file.cre08           #No.FUN-680122CHAR(10)
   DEFINE g_bookno    LIKE aaa_file.aaa01   #No.FUN-670039
   DEFINE g_base      LIKE type_file.num10          #No.FUN-680122INTEGER
   DEFINE  #multi fac
           g_delsql   LIKE type_file.chr1000,              #execute sys_cmd        #No.FUN-680122CHAR(50)
           g_tname    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)           #tmpfile name
           g_idx,g_k  LIKE type_file.num10,          #No.FUN-680122INTEGER
 
           g_ary DYNAMIC ARRAY OF RECORD          #被選擇之工廠
           plant      LIKE cre_file.cre08,           #No.FUN-680122 VARCHAR(10)                  #No:8759
           dbs_new    LIKE type_file.chr21          #No.FUN-680122CHAR(21)
           END RECORD ,
 
           g_tmp DYNAMIC ARRAY OF RECORD          #被選擇之工廠
           p          LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)                   #No:8759
           d          LIKE type_file.chr21           #No.FUN-680122CHAR(21)
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
 
 
   FOR g_idx =1 to 8
     let g_ary[g_idx].plant=''
     let g_ary[g_idx].dbs_new=''
   END FOR
 
   LET tm.plant_1 = g_ary[1].plant
   LET tm.plant_2 = g_ary[2].plant
   LET tm.plant_3 = g_ary[3].plant
   LET tm.plant_4 = g_ary[4].plant
   LET tm.plant_5 = g_ary[5].plant
   LET tm.plant_6 = g_ary[6].plant
   LET tm.plant_7 = g_ary[7].plant
   LET tm.plant_8 = g_ary[8].plant
 
   LET g_bookno= ARG_VAL(1)      
   LET g_pdate = ARG_VAL(2)      
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET g_wc  = ARG_VAL(8)
   LET tm.s_code  = ARG_VAL(9)
   LET tm.yy1_b  = ARG_VAL(10)
   LET tm.mm1_b  = ARG_VAL(11)
   LET tm.mm1_e  = ARG_VAL(13)
   LET tm.yy2_b  = ARG_VAL(14)
   LET tm.mm2_b  = ARG_VAL(15)
   LET tm.mm2_e  = ARG_VAL(16)
   LET tm.yy3_b  = ARG_VAL(17)
   LET tm.mm3_b  = ARG_VAL(18)
   LET tm.mm3_e  = ARG_VAL(19)
   LET tm.yy4_b  = ARG_VAL(20)
   LET tm.mm4_b  = ARG_VAL(21)
   LET tm.mm4_e  = ARG_VAL(22)
   LET tm.yy5_b  = ARG_VAL(23)
   LET tm.mm5_b  = ARG_VAL(24)
   LET tm.mm5_e  = ARG_VAL(25)
   LET tm.yy6_b  = ARG_VAL(26)
   LET tm.mm6_b  = ARG_VAL(27)
   LET tm.mm6_e  = ARG_VAL(28)
   LET tm.plant_1  = ARG_VAL(29)
   LET tm.plant_2  = ARG_VAL(30)
   LET tm.plant_3  = ARG_VAL(31)
   LET tm.plant_4  = ARG_VAL(32)
   LET tm.plant_5  = ARG_VAL(33)
   LET tm.plant_6  = ARG_VAL(34)
   LET tm.plant_7  = ARG_VAL(35)
   LET tm.plant_8  = ARG_VAL(36)
   LET tm.duc_code = ARG_VAL(37)
   LET tm.detail   = ARG_VAL(38)
   LET tm.azk01    = ARG_VAL(39)
   LET tm.azk04    = ARG_VAL(40)
   LET tm.dec      = ARG_VAL(41)
   LET g_rep_user  = ARG_VAL(42)
   LET g_rep_clas  = ARG_VAL(43)
   LET g_template  = ARG_VAL(44)
   LET tm.type     = ARG_VAL(45)   #No.FUN-7C0101 add
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r111_tm(0,0)        
      ELSE CALL r111()             
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
 
FUNCTION r111_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_date         LIKE type_file.dat,            #No.FUN-680122DATE,
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE li_result      LIKE type_file.num5          #No.FUN-940102
   DEFINE l_cnt          LIKE type_file.num5          #FUN-A70084 

   IF p_row = 0 THEN LET p_row = 2 LET p_col = 10 END IF
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r111_w AT p_row,p_col WITH FORM "axc/42f/axcr111" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   CALL r111_set_entry() RETURNING l_cnt    #FUN-A70084

   INITIALIZE tm.* TO NULL        
   LET tm.dec    = 1
   LET tm.s_code = 1
   LET tm.type   = g_ccz.ccz28   #No.FUN-7C0101 add
   LET tm.duc_code= 'Y'
   LET tm.detail= 'N'
   LET tm.more = 'N'
   LET tm.yy1_b = g_ccz.ccz01
   LET tm.yy2_b = 0
   LET tm.yy3_b = 0 
   LET tm.yy4_b = 0
   LET tm.yy5_b = 0
   LET tm.yy6_b = 0
 
   LET tm.mm1_b = g_ccz.ccz02
   LET tm.mm2_b = 0
   LET tm.mm3_b = 0
   LET tm.mm4_b = 0
   LET tm.mm5_b = 0
   LET tm.mm6_b = 0
 
   LET tm.mm1_e = g_ccz.ccz02
   LET tm.mm2_e = 0
   LET tm.mm3_e = 0
   LET tm.mm4_e = 0
   LET tm.mm5_e = 0
   LET tm.mm6_e = 0
 
   LET tm.azk01= g_aza.aza17  #No:8488 
   LET tm.azk04=1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
 
   LET tm.plant_1 = g_plant   #FUN-A70084

WHILE TRUE
   LET g_wc=NULL
 
   CONSTRUCT BY NAME g_wc ON ima01,ima11,ima12,ima131,ima57,ima06
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
      
   DISPLAY BY NAME tm.more     
   INPUT BY NAME 
              tm.s_code,
              tm.yy1_b,tm.mm1_b,tm.mm1_e,
              tm.yy2_b,tm.mm2_b,tm.mm2_e,
              tm.yy3_b,tm.mm3_b,tm.mm3_e,
              tm.yy4_b,tm.mm4_b,tm.mm4_e,
              tm.yy5_b,tm.mm5_b,tm.mm5_e,
              tm.yy6_b,tm.mm6_b,tm.mm6_e,
              tm.plant_1,tm.plant_2,tm.plant_3,tm.plant_4,
              tm.plant_5,tm.plant_6,tm.plant_7,tm.plant_8,
              tm.type,     #No.FUN-7C0101 add tm.type
              tm.duc_code,
              tm.detail,
              tm.azk01,
              tm.azk04,
              tm.dec,
              tm.more
 
   WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
                EXIT INPUT
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
                   IF NOT r111_chkplant(tm.plant_1) THEN
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
             LET g_plant_new = tm.plant_2              #若重複傳回空白
             IF tm.plant_2 = g_plant  THEN
                LET g_dbs_new=' '
                LET g_ary[2].plant = tm.plant_2
                LET g_ary[2].dbs_new = g_dbs_new
                LET m_legal[2] = g_legal  #FUN-A70084
             ELSE
                IF NOT cl_null(tm.plant_2) THEN
                               # 檢查工廠並將新的資料庫放在g_dbs_new
                   IF NOT r111_chkplant(tm.plant_2) THEN
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
                IF NOT r111_chklegal(m_legal[2],1) THEN
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
                   IF NOT r111_chkplant(tm.plant_3) THEN
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
                IF NOT r111_chklegal(m_legal[3],2) THEN
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
                   IF NOT r111_chkplant(tm.plant_4) THEN
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
                IF NOT r111_chklegal(m_legal[4],3) THEN
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
                   IF NOT r111_chkplant(tm.plant_5) THEN
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
                IF NOT r111_chklegal(m_legal[5],4) THEN
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
                   IF NOT r111_chkplant(tm.plant_6) THEN
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
                IF NOT r111_chklegal(m_legal[6],5) THEN
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
                   IF NOT r111_chkplant(tm.plant_7) THEN
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
                IF NOT r111_chklegal(m_legal[7],6) THEN
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
                   IF NOT r111_chkplant(tm.plant_8) THEN
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
                IF NOT r111_chklegal(m_legal[8],7) THEN
                   CALL cl_err(tm.plant_8,g_errno,0)
                   NEXT FIELD plant_8
                END IF
             END IF
             #FUN-A70084--add--end
         
         AFTER FIELD type
             IF cl_null(tm.type) OR tm.type NOT MATCHES '[12345]' THEN
                NEXT FIELD type
             END IF
         
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
           IF tm.dec NOT MATCHES '[1-3]' THEN NEXT FIELD dec END IF
           CASE tm.dec
            WHEN 1 LET g_base = 1
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
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG CALL cl_cmdask()  
      
         ON ACTION controlp
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
                 #MOD-580105(end)
 
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
                OTHERWISE 
                     EXIT CASE
            END CASE
##
         AFTER INPUT
               IF INT_FLAG THEN
                  EXIT INPUT
               END IF
               IF cl_null(tm.azk01) THEN 
                  LET tm.azk04 = 0
                  DISPLAY BY NAME tm.azk04
               END IF  
               IF tm.azk01= g_aza.aza17 THEN
                  LET tm.azk04=1
                  DISPLAY BY NAME tm.azk04
               END IF
##
 
               IF cl_null(tm.plant_1) AND cl_null(tm.plant_2) AND
                  cl_null(tm.plant_3) AND cl_null(tm.plant_4) AND
                  cl_null(tm.plant_5) AND cl_null(tm.plant_6) AND
                  cl_null(tm.plant_7) AND cl_null(tm.plant_8) THEN
                  CALL cl_err(0,'aap-136',0) 
                  NEXT FIELD plant_1
               END IF

              #MOD-C30791 str add--------
               IF tm.plant_1 = g_plant  THEN
                  LET g_dbs_new =' '
                  LET g_ary[1].plant = tm.plant_1
                  LET g_ary[1].dbs_new = g_dbs_new
                  LET m_legal[1] = g_legal
               END IF
              #MOD-C30791 end add--------      

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
      CLOSE WINDOW r111_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr111'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr111','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.s_code  CLIPPED,"'",
                         " '",tm.yy1_b   CLIPPED,"'",
                         " '",tm.mm1_b   CLIPPED,"'",
                         " '",tm.mm1_e   CLIPPED,"'",
                         " '",tm.yy2_b   CLIPPED,"'",
                         " '",tm.mm2_b   CLIPPED,"'",
                         " '",tm.mm2_e   CLIPPED,"'",
                         " '",tm.yy3_b   CLIPPED,"'",
                         " '",tm.mm3_b   CLIPPED,"'",
                         " '",tm.mm3_e   CLIPPED,"'",
                         " '",tm.yy4_b   CLIPPED,"'",
                         " '",tm.mm4_b   CLIPPED,"'",
                         " '",tm.mm4_e   CLIPPED,"'",
                         " '",tm.yy5_b   CLIPPED,"'",
                         " '",tm.mm5_b   CLIPPED,"'",
                         " '",tm.mm5_e   CLIPPED,"'",
                         " '",tm.yy6_b   CLIPPED,"'",
                         " '",tm.mm6_b   CLIPPED,"'",
                         " '",tm.mm6_e   CLIPPED,"'",
                         " '",tm.plant_1  CLIPPED,"'",
                         " '",tm.plant_2  CLIPPED,"'",
                         " '",tm.plant_3  CLIPPED,"'",
                         " '",tm.plant_4  CLIPPED,"'",
                         " '",tm.plant_5  CLIPPED,"'",
                         " '",tm.plant_6  CLIPPED,"'",
                         " '",tm.plant_7  CLIPPED,"'",
                         " '",tm.plant_8  CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",      #No.FUN-7C0101 add
                         " '",tm.duc_code CLIPPED,"'",
                         " '",tm.detail   CLIPPED,"'",
                         " '",tm.azk01    CLIPPED,"'",
                         " '",tm.azk04    CLIPPED,"'",
                         " '",tm.dec      CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas  CLIPPED,"'",
                         " '",g_template  CLIPPED,"'"
         CALL cl_cmdat('axcr111',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r111()
   ERROR ""
END WHILE
   CLOSE WINDOW r111_w
END FUNCTION
 
FUNCTION r111()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122 VARCHAR(2000),
          l_item    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20),       
          l_ima01   LIKE type_file.chr20,          #No.FUN-680122CHAR(20),
          l_tmp     LIKE cre_file.cre08,           #No.FUN-680122CHAR(8),
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40),
          l_chk     LIKE type_file.chr1,           #No.FUN-680122CHAR(01),
          l_cta     RECORD
              ima01  LIKE ima_file.ima01,         #No.FUN-680122 VARCHAR(20), 
              ima131 LIKE ima_file.ima131,           #No.FUN-680122CHAR(10), 
              ima11  LIKE ima_file.ima11,           #No.FUN-680122CHAR(4),
              ima02  LIKE ima_file.ima02,         #No.FUN-680122CHAR(30)
              oba02  LIKE oba_file.oba02,         #No.FUN-680122CHAR(30)
              ym   LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              ccg07  LIKE ccg_file.ccg07,           #NO.FUN-840005
             # qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3),#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3),#FUN-A20044
              amt1   LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2   LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3   LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4   LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6) #FUN-5B0082
              amt5   LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6) #FUN-5B0082
              amt51  LIKE type_file.num20_6,        #No.FUN-7C0101 DEC(20,6)
              amt52  LIKE type_file.num20_6,        #No.FUN-7C0101 DEC(20,6)
              amt53  LIKE type_file.num20_6,        #No.FUN-7C0101 DEC(20,6)
              amt6   LIKE type_file.num20_6        #No.FUN-680122 DECIMAL(20,6)
          END RECORD,
 
          sr  RECORD
              order_l LIKE ima_file.ima01,        #No.FUN-680122char(20),  #MOD-7A0164 VARCHAR(20)-> ima01
              ima01   LIKE ima_file.ima01,        #No.FUN-680122char(20),
              ima131  LIKE ima_file.ima131,       #No.FUN-680122 VARCHAR(10),
              ima11   LIKE ima_file.ima11,        #No.FUN-680122CHAR(4),
              ima02   LIKE ima_file.ima02,        #No.FUN-680122CHAR(30),
              oba02   LIKE oba_file.oba02,        #No.FUN-680122CHAR(30),
              ccg07    LIKE ccg_file.ccg07,           #FUN-840005
            #  qty_ym1 LIKE ima_file.ima26,        #No.FUN-680122DEC(15,3),##FUN-A20044
              qty_ym1 LIKE type_file.num15_3,        #No.FUN-680122DEC(15,3),##FUN-A20044
              amt1_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
              amt51_ym1 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym1 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym1 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
             # qty_ym2  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty_ym2  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
              amt51_ym2 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym2 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym2 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
            #  qty_ym3  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty_ym3  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
              amt51_ym3 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym3 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym3 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
           #   qty_ym4  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty_ym4  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
              amt51_ym4 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym4 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym4 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
             # qty_ym5  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty_ym5  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
              amt1_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
              amt51_ym5 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym5 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym5 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
             # qty_ym6  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
              qty_ym6  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUNA20044
              amt1_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)  #FUN-5B0082
              amt51_ym6 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym6 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym6 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym6 LIKE type_file.num20_6         #No.FUN-680122 DEC(20,6)   #FUN-5B0082              
          END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #--------------------------------------
     # qty 數量
     # amt1料
     # amt2工
     # amt3費
     # amt4小計(amt1+amt2+amt3)
     ## amt4 小計(amt1+amt2+amt3)             #FUN-5B0082 mark
     # amt4 加工                             #FUN-5B0082
     # amt5 其他                             #FUN-5B0082
     # amt6 小計(amt1+amt2+amt3+amt4+amt5)   #FUN-5B0082
     #---------------------------------------
     LET sr.qty_ym1=0
     LET sr.amt1_ym1=0
     LET sr.amt2_ym1=0
     LET sr.amt3_ym1=0
     LET sr.amt4_ym1=0
     LET sr.amt5_ym1=0   #FUN-5B0082
     LET sr.amt51_ym1=0  #No.FUN-7C0101
     LET sr.amt52_ym1=0  #No.FUN-7C0101
     LET sr.amt53_ym1=0  #No.FUN-7C0101
     LET sr.amt6_ym1=0   #FUN-5B0082
     LET sr.qty_ym2=0
     LET sr.amt1_ym2=0
     LET sr.amt2_ym2=0
     LET sr.amt3_ym2=0
     LET sr.amt4_ym2=0
     LET sr.amt5_ym2=0   #FUN-5B0082
     LET sr.amt51_ym2=0  #No.FUN-7C0101
     LET sr.amt52_ym2=0  #No.FUN-7C0101
     LET sr.amt53_ym2=0  #No.FUN-7C0101
     LET sr.amt6_ym2=0   #FUN-5B0082
     LET sr.qty_ym3=0
     LET sr.amt1_ym3=0
     LET sr.amt2_ym3=0
     LET sr.amt3_ym3=0
     LET sr.amt4_ym3=0
     LET sr.amt5_ym3=0   #FUN-5B0082
     LET sr.amt51_ym3=0  #No.FUN-7C0101
     LET sr.amt52_ym3=0  #No.FUN-7C0101
     LET sr.amt53_ym3=0  #No.FUN-7C0101
     LET sr.amt6_ym3=0   #FUN-5B0082
     LET sr.qty_ym4=0
     LET sr.amt1_ym4=0
     LET sr.amt2_ym4=0
     LET sr.amt3_ym4=0
     LET sr.amt4_ym4=0
     LET sr.amt5_ym4=0   #FUN-5B0082
     LET sr.amt51_ym4=0  #No.FUN-7C0101
     LET sr.amt52_ym4=0  #No.FUN-7C0101
     LET sr.amt53_ym4=0  #No.FUN-7C0101
     LET sr.amt6_ym4=0   #FUN-5B0082
     LET sr.qty_ym5=0
     LET sr.amt1_ym5=0
     LET sr.amt2_ym5=0
     LET sr.amt3_ym5=0
     LET sr.amt4_ym5=0
     LET sr.amt5_ym5=0   #FUN-5B0082
     LET sr.amt51_ym5=0  #No.FUN-7C0101
     LET sr.amt52_ym5=0  #No.FUN-7C0101
     LET sr.amt53_ym5=0  #No.FUN-7C0101
     LET sr.amt6_ym5=0   #FUN-5B0082
     LET sr.qty_ym6=0
     LET sr.amt1_ym6=0
     LET sr.amt2_ym6=0
     LET sr.amt3_ym6=0
     LET sr.amt4_ym6=0
     LET sr.amt5_ym6=0   #FUN-5B0082
     LET sr.amt51_ym6=0  #No.FUN-7C0101
     LET sr.amt52_ym6=0  #No.FUN-7C0101
     LET sr.amt53_ym6=0  #No.FUN-7C0101
     LET sr.amt6_ym6=0   #FUN-5B0082
 
     CALL get_tmpfile()
 
     LET l_fd4="ORDER BY ima01"
 
     LET l_sql =
             " SELECT ima01,ima131,ima11,ima02,oba02,ym,ccg07,",    #FUN-840005
             " SUM(qty),SUM(amt1),SUM(amt2),SUM(amt3),",
             " SUM(amt4) ",
             ",SUM(amt5),SUM(amt51),SUM(amt52),SUM(amt53),SUM(amt6) ",   #FUN-5B0082   #No.FUN-7C0101 add amt51,amt52,amt53
             " FROM ",g_tname,
             " GROUP BY ima01,ima131,ima11,ima02,oba02,ym,ccg07 ",
             " ORDER BY ima01,ima131,ima11,ima02,oba02,ym,ccg07 "
             PREPARE r111_prepare1 FROM l_sql
             IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare1:',SQLCA.sqlcode,1)    
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
                EXIT PROGRAM 
             END IF
 
             DECLARE r111_curs1 CURSOR FOR r111_prepare1
 
             CALL cl_outnam('axcr111') RETURNING l_name
 
             START REPORT r111_rep TO l_name
             LET g_pageno = 0
             LET first_flag=0
             LET l_item=null
             LET l_ima01=null
          FOREACH r111_curs1 INTO l_cta.*
 
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
             END IF
             LET sr.ccg07 = l_cta.ccg07 #FUN-840005
             IF first_flag = 0 THEN
                LET l_ima01=l_cta.ima01
                CASE tm.s_code
                  when 1
                    let sr.order_l=l_cta.ima01
                  when 2
                    let sr.order_l=l_cta.ima131
                  when 3
                    let sr.order_l=l_cta.ima11
                END CASE
                let sr.ima01 = l_cta.ima01
                let sr.ima131 = l_cta.ima131
                let sr.ima11 = l_cta.ima11
                let sr.ima02 = l_cta.ima02
                let sr.oba02 = l_cta.oba02
                let first_flag=1
             END IF
          IF (l_ima01 <> l_cta.ima01) OR l_ima01 IS NULL THEN
                OUTPUT TO REPORT r111_rep(sr.*)
                LET l_ima01=l_cta.ima01
                CASE tm.s_code
                  when 1
                    let sr.order_l=l_cta.ima01
                  when 2
                    let sr.order_l=l_cta.ima131
                  when 3
                    let sr.order_l=l_cta.ima11
                END CASE
                  let sr.ima01 = l_cta.ima01
                  let sr.ima131 = l_cta.ima131
                  let sr.ima11 = l_cta.ima11
                  let sr.ima02 = l_cta.ima02
                  let sr.oba02 = l_cta.oba02
                   LET sr.qty_ym1=0
                   LET sr.amt1_ym1=0
                   LET sr.amt2_ym1=0
                   LET sr.amt3_ym1=0
                   LET sr.amt4_ym1=0
                   LET sr.amt5_ym1=0   #FUN-5B0082
                   LET sr.amt51_ym1=0  #No.FUN-7C0101
                   LET sr.amt52_ym1=0  #No.FUN-7C0101
                   LET sr.amt53_ym1=0  #No.FUN-7C0101
                   LET sr.amt6_ym1=0   #FUN-5B0082
                   LET sr.qty_ym2=0
                   LET sr.amt1_ym2=0
                   LET sr.amt2_ym2=0
                   LET sr.amt3_ym2=0
                   LET sr.amt4_ym2=0
                   LET sr.amt5_ym2=0   #FUN-5B0082
                   LET sr.amt51_ym2=0  #No.FUN-7C0101
                   LET sr.amt52_ym2=0  #No.FUN-7C0101
                   LET sr.amt53_ym2=0  #No.FUN-7C0101
                   LET sr.amt6_ym2=0   #FUN-5B0082
                   LET sr.qty_ym3=0
                   LET sr.amt1_ym3=0
                   LET sr.amt2_ym3=0
                   LET sr.amt3_ym3=0
                   LET sr.amt4_ym3=0
                   LET sr.amt5_ym3=0   #FUN-5B0082
                   LET sr.amt51_ym3=0  #No.FUN-7C0101
                   LET sr.amt52_ym3=0  #No.FUN-7C0101
                   LET sr.amt53_ym3=0  #No.FUN-7C0101
                   LET sr.amt6_ym3=0   #FUN-5B0082
                   LET sr.qty_ym4=0
                   LET sr.amt1_ym4=0
                   LET sr.amt2_ym4=0
                   LET sr.amt3_ym4=0
                   LET sr.amt4_ym4=0
                   LET sr.amt5_ym4=0   #FUN-5B0082
                   LET sr.amt51_ym4=0  #No.FUN-7C0101
                   LET sr.amt52_ym4=0  #No.FUN-7C0101
                   LET sr.amt53_ym4=0  #No.FUN-7C0101
                   LET sr.amt6_ym4=0   #FUN-5B0082
                   LET sr.qty_ym5=0
                   LET sr.amt1_ym5=0
                   LET sr.amt2_ym5=0
                   LET sr.amt3_ym5=0
                   LET sr.amt4_ym5=0
                   LET sr.amt5_ym5=0   #FUN-5B0082
                   LET sr.amt51_ym5=0  #No.FUN-7C0101
                   LET sr.amt52_ym5=0  #No.FUN-7C0101
                   LET sr.amt53_ym5=0  #No.FUN-7C0101
                   LET sr.amt6_ym5=0   #FUN-5B0082
                   LET sr.qty_ym6=0
                   LET sr.amt1_ym6=0
                   LET sr.amt2_ym6=0
                   LET sr.amt3_ym6=0
                   LET sr.amt4_ym6=0
                   LET sr.amt5_ym6=0   #FUN-5B0082
                   LET sr.amt51_ym6=0  #No.FUN-7C0101
                   LET sr.amt52_ym6=0  #No.FUN-7C0101
                   LET sr.amt53_ym6=0  #No.FUN-7C0101
                   LET sr.amt6_ym6=0   #FUN-5B0082
             END IF
 
             LET l_cta.amt1=l_cta.amt1/g_base
             LET l_cta.amt2=l_cta.amt2/g_base
             LET l_cta.amt3=l_cta.amt3/g_base
             LET l_cta.amt4=l_cta.amt4/g_base
             LET l_cta.amt5=l_cta.amt5/g_base
             LET l_cta.amt51=l_cta.amt51/g_base    #No.FUN-7C0101
             LET l_cta.amt52=l_cta.amt52/g_base    #No.FUN-7C0101
             LET l_cta.amt53=l_cta.amt53/g_base    #No.FUN-7C0101
             LET l_cta.amt6=l_cta.amt1+l_cta.amt2+l_cta.amt3+l_cta.amt4+l_cta.amt5
                            +l_cta.amt51+l_cta.amt52+l_cta.amt53   #No:MOD-9B0144 add
               IF tm.azk04 >0 THEN
                  LET l_cta.amt1=l_cta.amt1/tm.azk04
                  LET l_cta.amt2=l_cta.amt2/tm.azk04
                  LET l_cta.amt3=l_cta.amt3/tm.azk04
                  LET l_cta.amt4=l_cta.amt4/tm.azk04
                  LET l_cta.amt5=l_cta.amt5/tm.azk04   #FUN-5B0082
                  LET l_cta.amt51=l_cta.amt51/tm.azk04    #No.FUN-7C0101
                  LET l_cta.amt52=l_cta.amt52/tm.azk04    #No.FUN-7C0101
                  LET l_cta.amt53=l_cta.amt53/tm.azk04    #No.FUN-7C0101
                  LET l_cta.amt6=l_cta.amt6/tm.azk04   #FUN-5B0082
               END IF
 
               CASE l_cta.ym 
               WHEN '1'
                  LET sr.qty_ym1=l_cta.qty
                  LET sr.amt1_ym1=l_cta.amt1
                  LET sr.amt2_ym1=l_cta.amt2
                  LET sr.amt3_ym1=l_cta.amt3
                  LET sr.amt4_ym1=l_cta.amt4
                  LET sr.amt5_ym1=l_cta.amt5   #FUN-5B0082
                  LET sr.amt51_ym1=l_cta.amt51   #No.FUN-7C0101
                  LET sr.amt52_ym1=l_cta.amt52   #No.FUN-7C0101
                  LET sr.amt53_ym1=l_cta.amt53   #No.FUN-7C0101
                  LET sr.amt6_ym1=l_cta.amt6   #FUN-5B0082
               WHEN '2'
                  LET sr.qty_ym2=l_cta.qty
                  LET sr.amt1_ym2=l_cta.amt1
                  LET sr.amt2_ym2=l_cta.amt2
                  LET sr.amt3_ym2=l_cta.amt3
                  LET sr.amt4_ym2=l_cta.amt4
                  LET sr.amt5_ym2=l_cta.amt5   #FUN-5B0082
                  LET sr.amt51_ym2=l_cta.amt51   #No.FUN-7C0101
                  LET sr.amt52_ym2=l_cta.amt52   #No.FUN-7C0101
                  LET sr.amt53_ym2=l_cta.amt53   #No.FUN-7C0101
                  LET sr.amt6_ym2=l_cta.amt6   #FUN-5B0082
               WHEN '3'
                  LET sr.qty_ym3=l_cta.qty
                  LET sr.amt1_ym3=l_cta.amt1
                  LET sr.amt2_ym3=l_cta.amt2
                  LET sr.amt3_ym3=l_cta.amt3
                  LET sr.amt4_ym3=l_cta.amt4
                  LET sr.amt5_ym3=l_cta.amt5   #FUN-5B0082
                  LET sr.amt51_ym3=l_cta.amt51   #No.FUN-7C0101
                  LET sr.amt52_ym3=l_cta.amt52   #No.FUN-7C0101
                  LET sr.amt53_ym3=l_cta.amt53   #No.FUN-7C0101
                  LET sr.amt6_ym3=l_cta.amt6   #FUN-5B0082
               WHEN '4'
                  LET sr.qty_ym4=l_cta.qty
                  LET sr.amt1_ym4=l_cta.amt1
                  LET sr.amt2_ym4=l_cta.amt2
                  LET sr.amt3_ym4=l_cta.amt3
                  LET sr.amt4_ym4=l_cta.amt4
                  LET sr.amt5_ym4=l_cta.amt5   #FUN-5B0082
                  LET sr.amt51_ym4=l_cta.amt51   #No.FUN-7C0101
                  LET sr.amt52_ym4=l_cta.amt52   #No.FUN-7C0101
                  LET sr.amt53_ym4=l_cta.amt53   #No.FUN-7C0101
                  LET sr.amt6_ym4=l_cta.amt6   #FUN-5B0082
               WHEN '5'
                  LET sr.qty_ym5=l_cta.qty
                  LET sr.amt1_ym5=l_cta.amt1
                  LET sr.amt2_ym5=l_cta.amt2
                  LET sr.amt3_ym5=l_cta.amt3
                  LET sr.amt4_ym5=l_cta.amt4
                  LET sr.amt5_ym5=l_cta.amt5   #FUN-5B0082
                  LET sr.amt51_ym5=l_cta.amt51   #No.FUN-7C0101
                  LET sr.amt52_ym5=l_cta.amt52   #No.FUN-7C0101
                  LET sr.amt53_ym5=l_cta.amt53   #No.FUN-7C0101
                  LET sr.amt6_ym5=l_cta.amt6   #FUN-5B0082
               WHEN '6'
                  LET sr.qty_ym6=l_cta.qty
                  LET sr.amt1_ym6=l_cta.amt1
                  LET sr.amt2_ym6=l_cta.amt2
                  LET sr.amt3_ym6=l_cta.amt3
                  LET sr.amt4_ym6=l_cta.amt4
                  LET sr.amt5_ym6=l_cta.amt5   #FUN-5B0082
                  LET sr.amt51_ym6=l_cta.amt51   #No.FUN-7C0101
                  LET sr.amt52_ym6=l_cta.amt52   #No.FUN-7C0101
                  LET sr.amt53_ym6=l_cta.amt53   #No.FUN-7C0101
                  LET sr.amt6_ym6=l_cta.amt6   #FUN-5B0082
               END CASE
 
             END FOREACH
 
 
      IF sr.qty_ym1  IS NULL THEN LET sr.qty_ym1=0 END IF 
      IF sr.amt1_ym1 IS NULL THEN LET sr.amt1_ym1=0 END IF 
      IF sr.amt2_ym1 IS NULL THEN LET sr.amt2_ym1=0 END IF 
      IF sr.amt3_ym1 IS NULL THEN LET sr.amt3_ym1=0 END IF 
      IF sr.amt4_ym1 IS NULL THEN LET sr.amt4_ym1=0 END IF 
      IF sr.amt5_ym1 IS NULL THEN LET sr.amt5_ym1=0 END IF   #FUN-5B0082
      IF sr.amt51_ym1 IS NULL THEN LET sr.amt51_ym1=0 END IF #No.FUN-7C0101
      IF sr.amt52_ym1 IS NULL THEN LET sr.amt52_ym1=0 END IF #No.FUN-7C0101
      IF sr.amt53_ym1 IS NULL THEN LET sr.amt53_ym1=0 END IF #No.FUN-7C0101
      IF sr.amt6_ym1 IS NULL THEN LET sr.amt6_ym1=0 END IF   #FUN-5B0082
      IF sr.qty_ym2  IS NULL THEN LET sr.qty_ym2=0 END IF
      IF sr.amt1_ym2  IS NULL THEN LET sr.amt1_ym2=0 END IF 
      IF sr.amt2_ym2  IS NULL THEN LET sr.amt2_ym2=0 END IF 
      IF sr.amt3_ym2  IS NULL THEN LET sr.amt3_ym2=0 END IF 
      IF sr.amt4_ym2  IS NULL THEN LET sr.amt4_ym2=0 END IF 
      IF sr.amt5_ym2  IS NULL THEN LET sr.amt5_ym2=0 END IF   #FUN-5B0082
      IF sr.amt51_ym2 IS NULL THEN LET sr.amt51_ym2=0 END IF #No.FUN-7C0101
      IF sr.amt52_ym2 IS NULL THEN LET sr.amt52_ym2=0 END IF #No.FUN-7C0101
      IF sr.amt53_ym2 IS NULL THEN LET sr.amt53_ym2=0 END IF #No.FUN-7C0101
      IF sr.amt6_ym2  IS NULL THEN LET sr.amt6_ym2=0 END IF   #FUN-5B0082
      IF sr.qty_ym3  IS NULL THEN LET sr.qty_ym3=0 END IF
      IF sr.amt1_ym3 IS NULL THEN LET sr.amt1_ym3=0 END IF 
      IF sr.amt2_ym3  IS NULL THEN LET sr.amt2_ym3=0 END IF
      IF sr.amt3_ym3  IS NULL THEN LET sr.amt3_ym3=0 END IF
      IF sr.amt4_ym3  IS NULL THEN LET sr.amt4_ym3=0 END IF 
      IF sr.amt5_ym3 IS NULL THEN LET sr.amt5_ym3=0 END IF   #FUN-5B0082
      IF sr.amt51_ym3 IS NULL THEN LET sr.amt51_ym3=0 END IF #No.FUN-7C0101
      IF sr.amt52_ym3 IS NULL THEN LET sr.amt52_ym3=0 END IF #No.FUN-7C0101
      IF sr.amt53_ym3 IS NULL THEN LET sr.amt53_ym3=0 END IF #No.FUN-7C0101
      IF sr.amt6_ym3 IS NULL THEN LET sr.amt6_ym3=0 END IF   #FUN-5B0082
      IF sr.qty_ym4  IS NULL THEN LET sr.qty_ym4=0 END IF
      IF sr.amt1_ym4  IS NULL THEN LET sr.amt1_ym4=0 END IF
      IF sr.amt2_ym4  IS NULL THEN LET sr.amt2_ym4=0 END IF
      IF sr.amt3_ym4 IS NULL THEN LET sr.amt3_ym4=0 END IF
      IF sr.amt4_ym4 IS NULL THEN LET sr.amt4_ym4=0 END IF
      IF sr.amt5_ym4 IS NULL THEN LET sr.amt5_ym4=0 END IF   #FUN-5B0082
      IF sr.amt51_ym4 IS NULL THEN LET sr.amt51_ym4=0 END IF #No.FUN-7C0101
      IF sr.amt52_ym4 IS NULL THEN LET sr.amt52_ym4=0 END IF #No.FUN-7C0101
      IF sr.amt53_ym4 IS NULL THEN LET sr.amt53_ym4=0 END IF #No.FUN-7C0101
      IF sr.amt6_ym4 IS NULL THEN LET sr.amt6_ym4=0 END IF   #FUN-5B0082
      IF sr.qty_ym5 IS NULL THEN LET sr.qty_ym5=0 END IF
      IF sr.amt1_ym5 IS NULL THEN LET sr.amt1_ym5=0 END IF 
      IF sr.amt2_ym5 IS NULL THEN LET sr.amt2_ym5=0 END IF 
      IF sr.amt3_ym5 IS NULL THEN LET sr.amt3_ym5=0 END IF 
      IF sr.amt4_ym5 IS NULL THEN LET sr.amt4_ym5=0 END IF 
      IF sr.amt5_ym5 IS NULL THEN LET sr.amt5_ym5=0 END IF   #FUN-5B0082
      IF sr.amt51_ym5 IS NULL THEN LET sr.amt51_ym5=0 END IF #No.FUN-7C0101
      IF sr.amt52_ym5 IS NULL THEN LET sr.amt52_ym5=0 END IF #No.FUN-7C0101
      IF sr.amt53_ym5 IS NULL THEN LET sr.amt53_ym5=0 END IF #No.FUN-7C0101
      IF sr.amt6_ym5 IS NULL THEN LET sr.amt6_ym5=0 END IF   #FUN-5B0082
      IF sr.qty_ym6 IS NULL THEN LET sr.qty_ym6=0 END IF
      IF sr.amt1_ym6  IS NULL THEN LET sr.amt1_ym6=0 END IF
      IF sr.amt2_ym6 IS NULL THEN LET sr.amt2_ym6=0 END IF
      IF sr.amt3_ym6 IS NULL THEN LET sr.amt3_ym6=0 END IF
      IF sr.amt4_ym6 IS NULL THEN LET sr.amt4_ym6=0 END IF
      IF sr.amt5_ym6 IS NULL THEN LET sr.amt5_ym6=0 END IF   #FUN-5B0082
      IF sr.amt51_ym6 IS NULL THEN LET sr.amt51_ym6=0 END IF #No.FUN-7C0101
      IF sr.amt52_ym6 IS NULL THEN LET sr.amt52_ym6=0 END IF #No.FUN-7C0101
      IF sr.amt53_ym6 IS NULL THEN LET sr.amt53_ym6=0 END IF #No.FUN-7C0101
      IF sr.amt6_ym6 IS NULL THEN LET sr.amt6_ym6=0 END IF   #FUN-5B0082
             #因為重覆性生產的qty為零,所以改成判斷如果有其中一個amt不是零就列印
             IF sr.amt1_ym1 <>0 OR sr.amt2_ym1 <>0 OR sr.amt3_ym1 <>0 OR                
                sr.amt4_ym1 <>0 OR sr.amt5_ym1 <>0 OR sr.amt6_ym1 <>0 OR
                sr.amt51_ym1 <>0 OR sr.amt52_ym1 <>0 OR sr.amt53_ym1 <>0 OR      #No.FUN-7C0101 add
                sr.amt1_ym2 <>0 OR sr.amt2_ym2 <>0 OR sr.amt3_ym2 <>0 OR
                sr.amt4_ym2 <>0 OR sr.amt5_ym2 <>0 OR sr.amt6_ym2 <>0 OR
                sr.amt51_ym2 <>0 OR sr.amt52_ym2 <>0 OR sr.amt53_ym2 <>0 OR      #No.FUN-7C0101 add
                sr.amt1_ym3 <>0 OR sr.amt2_ym3 <>0 OR sr.amt3_ym3 <>0 OR
                sr.amt4_ym3 <>0 OR sr.amt5_ym3 <>0 OR sr.amt6_ym3 <>0 OR
                sr.amt51_ym3 <>0 OR sr.amt52_ym3 <>0 OR sr.amt53_ym3 <>0 OR      #No.FUN-7C0101 add
                sr.amt1_ym4 <>0 OR sr.amt2_ym4 <>0 OR sr.amt3_ym4 <>0 OR
                sr.amt4_ym4 <>0 OR sr.amt5_ym4 <>0 OR sr.amt6_ym4 <>0 OR
                sr.amt51_ym4 <>0 OR sr.amt52_ym4 <>0 OR sr.amt53_ym4 <>0 OR      #No.FUN-7C0101 add
                sr.amt1_ym5 <>0 OR sr.amt2_ym5 <>0 OR sr.amt3_ym5 <>0 OR
                sr.amt4_ym5 <>0 OR sr.amt5_ym5 <>0 OR sr.amt6_ym5 <>0 OR
                sr.amt51_ym5 <>0 OR sr.amt52_ym5 <>0 OR sr.amt53_ym5 <>0 OR      #No.FUN-7C0101 add
                sr.amt1_ym6 <>0 OR sr.amt2_ym6 <>0 OR sr.amt3_ym6 <>0 OR
                sr.amt4_ym6 <>0 OR sr.amt5_ym6 <>0 OR sr.amt6_ym6 <>0 OR 
                sr.amt51_ym6 <>0 OR sr.amt52_ym6 <>0 OR sr.amt53_ym6 <>0 THEN    #No.FUN-7C0101 add
                OUTPUT TO REPORT r111_rep(sr.*)
                LET sr.qty_ym1=0
                LET sr.amt1_ym1=0
                LET sr.amt2_ym1=0
                LET sr.amt3_ym1=0
                LET sr.amt4_ym1=0
                LET sr.amt5_ym1=0   #FUN-5B0082
                LET sr.amt51_ym1=0  #No.FUN-7C0101
                LET sr.amt52_ym1=0  #No.FUN-7C0101
                LET sr.amt53_ym1=0  #No.FUN-7C0101
                LET sr.amt6_ym1=0   #FUN-5B0082
                LET sr.qty_ym2=0
                LET sr.amt1_ym2=0
                LET sr.amt2_ym2=0
                LET sr.amt3_ym2=0
                LET sr.amt4_ym2=0
                LET sr.amt5_ym2=0   #FUN-5B0082
                LET sr.amt51_ym2=0  #No.FUN-7C0101
                LET sr.amt52_ym2=0  #No.FUN-7C0101
                LET sr.amt53_ym2=0  #No.FUN-7C0101
                LET sr.amt6_ym2=0   #FUN-5B0082
                LET sr.qty_ym3=0
                LET sr.amt1_ym3=0
                LET sr.amt2_ym3=0
                LET sr.amt3_ym3=0
                LET sr.amt4_ym3=0
                LET sr.amt5_ym3=0   #FUN-5B0082
                LET sr.amt51_ym3=0  #No.FUN-7C0101
                LET sr.amt52_ym3=0  #No.FUN-7C0101
                LET sr.amt53_ym3=0  #No.FUN-7C0101
                LET sr.amt6_ym3=0   #FUN-5B0082
                LET sr.qty_ym4=0
                LET sr.amt1_ym4=0
                LET sr.amt2_ym4=0
                LET sr.amt3_ym4=0
                LET sr.amt4_ym4=0
                LET sr.amt5_ym4=0   #FUN-5B0082
                LET sr.amt51_ym4=0  #No.FUN-7C0101
                LET sr.amt52_ym4=0  #No.FUN-7C0101
                LET sr.amt53_ym4=0  #No.FUN-7C0101
                LET sr.amt6_ym4=0   #FUN-5B0082
                LET sr.qty_ym5=0
                LET sr.amt1_ym5=0
                LET sr.amt2_ym5=0
                LET sr.amt3_ym5=0
                LET sr.amt4_ym5=0
                LET sr.amt5_ym5=0   #FUN-5B0082
                LET sr.amt51_ym5=0  #No.FUN-7C0101
                LET sr.amt52_ym5=0  #No.FUN-7C0101
                LET sr.amt53_ym5=0  #No.FUN-7C0101
                LET sr.amt6_ym5=0   #FUN-5B0082
                LET sr.qty_ym6=0
                LET sr.amt1_ym6=0
                LET sr.amt2_ym6=0
                LET sr.amt3_ym6=0
                LET sr.amt4_ym6=0
                LET sr.amt5_ym6=0   #FUN-5B0082
                LET sr.amt51_ym6=0  #No.FUN-7C0101
                LET sr.amt52_ym6=0  #No.FUN-7C0101
                LET sr.amt53_ym6=0  #No.FUN-7C0101
                LET sr.amt6_ym6=0   #FUN-5B0082
             END IF
 
     FINISH REPORT r111_rep
     PREPARE del_cmd FROM g_delsql
     EXECUTE del_cmd
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
 
FUNCTION get_tmpfile()
   DEFINE l_dot     LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
   DEFINE l_duc_sql LIKE type_file.chr1000       #No.FUN-680122CHAR(20)
 
   LET g_tname ='r111_tmp'                        #No.TQC-980163 mod
   LET g_delsql= " DROP TABLE ",g_tname CLIPPED
   PREPARE cre_px FROM g_delsql
 
   PREPARE del_cmd1 FROM g_delsql      #No.TQC-980163 移至前面，否則會出現-206的錯誤。
   EXECUTE cre_px
 
   LET tmp_sql=
               "CREATE TEMP TABLE ",g_tname CLIPPED,  #No.TQC-970305 mod
               "( ima01   LIKE ima_file.ima01,",     #MOD-970270 add                                                                                
               "  ima131  LIKE ima_file.ima131,",    #MOD-970270 add                                                                                    
               "  ima11   LIKE ima_file.ima11,",     #MOD-970270 add                                                                                     
               "  ima02   LIKE ima_file.ima02,",     #MOD-970270 add                                                                                    
               "  oba02   LIKE oba_file.oba02,",     #MOD-970270 add                                                                                    
               "  ym      LIKE type_file.chr1,",     #MOD-970270 add                                                                                     
               "  ccg07   LIKE ccg_file.ccg07,",     #MOD-970270 add                                                                                    
               "  qty     LIKE type_file.num15_3,",  #MOD-970270 add    #FUN-A20044  #No.TQC-A40130
               "  amt1    LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt2    LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt3    LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt4    LIKE ima_file.ima32,",     #MOD-970270 add                                                                                     
               "  amt5    LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt51   LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt52   LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt53   LIKE ima_file.ima32,",     #MOD-970270 add                                                                                    
               "  amt6    LIKE ima_file.ima32)"      #MOD-970270 add     
   PREPARE cre_p1 FROM tmp_sql
   EXECUTE cre_p1
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('Create axcr111_tmp:' ,SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   LET l_fd1=" ima01,ima131,ima11,ima02,oba02 "
 
   IF tm.duc_code='N' THEN #不含重工
      LET l_duc_sql=null
      LET l_fd2= " and ccg01=sfb01 and sfb99 NOT IN ('Y','y') "
   ELSE 
      LET l_duc_sql=null 
      LET l_fd2= ' '
   END IF
 
 
  # g_k 的值為實際的資料庫數目
 
   FOR g_idx=1 TO g_k
      CASE tm.duc_code
        WHEN 'N'
  #       LET l_fd3= ",",g_ary[g_idx].dbs_new CLIPPED,"sfb_file"                 #FUN-A10098
          LET l_fd3= ",",cl_get_target_table(g_ary[g_idx].plant,'sfb_file')    #FUN-A10098
      WHEN 'Y'
          LET l_fd3=''
      END CASE
 
      LET tmp_sql=null
      LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",   #FUN-5B0082
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1, ",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
       #FUN-A10098  ---start---
       #       g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
       #  " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
       #  " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),         #TQC-A30006 去掉 ",", 
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
       #FUN-A10098  ---end---
               l_fd3 CLIPPED,
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg04 ",
      #   " AND ima_file.ima131=oba_file.oba01 ",   #TQC-A30006 mark
         #" AND ccg31<>0 ",l_fd2 CLIPPED,           #No.MOD-A30221 mark
          " AND ccg32<>0 ",l_fd2 CLIPPED,           #No.MOD-A30221
          " AND ccg02=",tm.yy1_b,
          " AND ccg03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
         CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark 
         PREPARE r854_prepare21 FROM tmp_sql
         EXECUTE r854_prepare21
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('prepare21:',SQLCA.sqlcode,1) 
            EXECUTE del_cmd1                #delete tmpfile
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
            EXIT PROGRAM 
         END IF
 
      LET tmp_sql=null
      LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1, ",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098  ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),     #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131=oba01 ",
        #FUN-A10098   ---end---
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg01 ",
        # " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
          " AND ima911='Y' ",
          " AND ccg02=",tm.yy1_b,
          " AND ccg03 BETWEEN ",tm.mm1_b," AND ",tm.mm1_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
 
         CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
        #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
         PREPARE r854_prepare21_1 FROM tmp_sql
         EXECUTE r854_prepare21_1
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('prepare21_1:',SQLCA.sqlcode,1) 
            EXECUTE del_cmd1                #delete tmpfile
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
            EXIT PROGRAM 
         END IF
 
      # For 拆件式入庫
 
      IF tm.mm2_e >0 THEN
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'2',ccg07,",              #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1,",   #FUN-5B0082
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
         #FUN-A10098   ---start---
         #     g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
         #" ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
         #" , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'), #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131=oba01 ",
         #FUN-A10098   ---end---
               l_fd3 CLIPPED,
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg04 ",
       #  " AND ima_file.ima131=oba_file.oba01 ",   #TQC-A30006
         #" AND ccg31<>0 ",l_fd2 CLIPPED,           #No.MOD-A30221 mark
          " AND ccg32<>0 ",l_fd2 CLIPPED,           #No.MOD-A30221
          " AND ccg02=",tm.yy2_b,
          " AND ccg03 BETWEEN ",tm.mm2_b," AND ",tm.mm2_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare22 FROM tmp_sql
            EXECUTE r854_prepare22
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare22:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1 #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
          LET tmp_sql=null
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098  ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),    #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ---end---
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg01 ",
        # " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
          " AND ima911='Y' ",
          " AND ccg02=",tm.yy2_b,
          " AND ccg03 BETWEEN ",tm.mm2_b," AND ",tm.mm2_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare22_1 FROM tmp_sql
            EXECUTE r854_prepare22_1
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare22_1:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1                #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
      # For 拆件式入庫
            #For 拆件式
      END IF
 
      IF tm.mm3_e >0 THEN
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'3',ccg07,",              #No.FUN-7C0101 add ccg07 #TQC-970165 
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1,",   #FUN-5B0082
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098 ----start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),    #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ---end---
               l_fd3 CLIPPED,
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg04 ",
        # " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
         #" AND ccg31<>0 ",l_fd2 CLIPPED,          #No.MOD-A30221 mark
          " AND ccg32<>0 ",l_fd2 CLIPPED,          #No.MOD-A30221
          " AND ccg02=",tm.yy3_b,
          " AND ccg03 BETWEEN ",tm.mm3_b," AND ",tm.mm3_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7 
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare23 FROM tmp_sql
            EXECUTE r854_prepare23
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare23:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1 #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
          LET tmp_sql=null
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098   ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),    #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ---end---
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg01 ",
        # " AND ima_file.ima131=oba_file.oba01 ", #TQC-A30006
          " AND ima911='Y' ",
          " AND ccg02=",tm.yy3_b,
          " AND ccg03 BETWEEN ",tm.mm3_b," AND ",tm.mm3_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare23_1 FROM tmp_sql
            EXECUTE r854_prepare23_1
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare23_1:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1                #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
            #For 拆件式
      END IF
 
      IF tm.mm4_e >0 THEN
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'4',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,", 
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1,",   #FUN-5B0082
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
         #FUN-A10098   ---start---
         #     g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
         #" ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
         #" ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),   #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
         #FUN-A10098  ---end--- 
               l_fd3 CLIPPED,
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg04 ",
        # " AND ima_file.ima131=oba_file.oba01 ", #TQC-A30006
         #" AND ccg31<>0 ",l_fd2 CLIPPED,         #No.MOD-A30221 mark 
          " AND ccg32<>0 ",l_fd2 CLIPPED,         #No.MOD-A30221 
          " AND ccg02=",tm.yy4_b,
          " AND ccg03 BETWEEN ",tm.mm4_b," AND ",tm.mm4_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7 
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare24 FROM tmp_sql
            EXECUTE r854_prepare24
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare24:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1 #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
          LET tmp_sql=null
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",           #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098  ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),   #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ----end---
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg01 ",
        # " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
          " AND ima911='Y' ",
          " AND ccg02=",tm.yy4_b,
          " AND ccg03 BETWEEN ",tm.mm4_b," AND ",tm.mm4_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7 
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare24_1 FROM tmp_sql
            EXECUTE r854_prepare24_1
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare24_1:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1                #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
            #For 拆件式
      END IF
 
      IF tm.mm5_e >0 THEN
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'5',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1,",   #FUN-5B0082
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098   ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),   #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ----end---
               l_fd3 CLIPPED,
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg04 ",
       #  " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
         #" AND ccg31<>0 ",l_fd2 CLIPPED,          #No.MOD-A30221 mark
          " AND ccg32<>0 ",l_fd2 CLIPPED,          #No.MOD-A30221
          " AND ccg02=",tm.yy5_b,
          " AND ccg03 BETWEEN ",tm.mm5_b," AND ",tm.mm5_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7 
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare25 FROM tmp_sql
            EXECUTE r854_prepare25
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare25:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1 #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
          LET tmp_sql=null
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",           #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098  ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),   #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ----end---
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg01 ",
        # " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
          " AND ima911='Y' ",
          " AND ccg02=",tm.yy5_b,
          " AND ccg03 BETWEEN ",tm.mm5_b," AND ",tm.mm5_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7 
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare25_1 FROM tmp_sql
            EXECUTE r854_prepare25_1
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare25_1:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1                #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
      END IF
 
      IF tm.mm6_e >0 THEN
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'6',ccg07,",            #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1,",   #FUN-5B0082
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098  ---- start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " ,OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),  #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ----end---
               l_fd3 CLIPPED,
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg04 ",
        # " AND ima_file.ima131=oba_file.oba01 ",  #TQC-A30006
         #" AND ccg31<>0 ",l_fd2 CLIPPED,          #No.MOD-A30221 mark
          " AND ccg32<>0 ",l_fd2 CLIPPED,          #No.MOD-A30221
          " AND ccg02=",tm.yy6_b,
          " AND ccg03 BETWEEN ",tm.mm6_b," AND ",tm.mm6_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare26 FROM tmp_sql
            EXECUTE r854_prepare26
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare26:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1          #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
          LET tmp_sql=null
          LET tmp_sql=
          " INSERT INTO ",g_tname,
          " SELECT ",l_fd1 CLIPPED,",'1',ccg07,",             #No.FUN-7C0101 add ccg07
          " SUM(ccg31)*-1,SUM(ccg32a)*-1,SUM(ccg32b)*-1,",
          " SUM(ccg32c)*-1,SUM(ccg32d)*-1,SUM(ccg32e)*-1, ",
          " SUM(ccg32f)*-1,SUM(ccg32g)*-1,SUM(ccg32h)*-1,",   #No.FUN-7C0101 add
          " SUM(ccg32)*-1",
          " FROM ",
        #FUN-A10098  ---start---
        #      g_ary[g_idx].dbs_new CLIPPED,"ccg_file",
        # " ,",g_ary[g_idx].dbs_new CLIPPED,"ima_file",
        # " , OUTER ",g_ary[g_idx].dbs_new CLIPPED,"oba_file",
               cl_get_target_table(g_ary[g_idx].plant,'ccg_file'),",",
               cl_get_target_table(g_ary[g_idx].plant,'ima_file'),   #TQC-A30006 去掉 ",",
          " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oba_file')," ON ima131 = oba01 ",
        #FUN-A10098   ----end---
          " WHERE ",g_wc CLIPPED,
          " AND ima01=ccg01 ",
        # " AND ima_file.ima131=oba_file.oba01 ", #TQC-A30006
          " AND ima911='Y' ",
          " AND ccg02=",tm.yy6_b,
          " AND ccg03 BETWEEN ",tm.mm6_b," AND ",tm.mm6_e,
          " AND ccg06= '",tm.type,"'",                        #No.FUN-7C0101 add
          " GROUP BY ",l_fd1,",ccg07"                          #No.FUN-7C0101 add 7
 
            CALL cl_replace_sqldb(tmp_sql) RETURNING tmp_sql     #No.TQC-980163 add
           #CALL cl_parse_qry_sql(tmp_sql,g_ary[g_idx].plant) RETURNING tmp_sql  #FUN-A10098  #TQC-BB0182 mark
            PREPARE r854_prepare26_1 FROM tmp_sql
            EXECUTE r854_prepare26_1
            IF SQLCA.sqlcode != 0 THEN 
               CALL cl_err('prepare26_1:',SQLCA.sqlcode,1) 
               EXECUTE del_cmd1                #delete tmpfile
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
               EXIT PROGRAM 
            END IF
 
          # For 拆件式
      END IF
 
    END FOR
END FUNCTION
 
REPORT r111_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1           #No.FUN-680122CHAR(1)
DEFINE dec_name LIKE cre_file.cre08           #No.FUN-680122 VARCHAR(10) 
#DEFINE l_qty1,l_qty2,l_qty3,l_qty4,l_qty5,l_qty6 LIKE ima_file.ima26           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
DEFINE l_qty1,l_qty2,l_qty3,l_qty4,l_qty5,l_qty6 LIKE type_file.num15_3           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
DEFINE l_amt1,l_amt2,l_amt3,l_amt4,l_amt5,l_amt6 LIKE type_file.num20_6       #No.FUN-680122 DECIMAL(20,6)
#DEFINE l_pert1,l_pert2,l_pert3,l_pert4 LIKE ima_file.ima26           #No.FUN-680122DECIMAL(15,3)
DEFINE l_pert1,l_pert2,l_pert3,l_pert4 LIKE type_file.num15_3           #No.FUN-680122DECIMAL(15,3) #FUN-A20044
DEFINE l_dt1,l_dt2,l_dt3,l_dt4,l_dt5,l_dt6 STRING
DEFINE l_ima02 LIKE ima_file.ima02,
       sr  RECORD
              order_l LIKE ima_file.ima01,         #No.FUN-680122char(20), #CHI-690007
              ima01   LIKE ima_file.ima01,        #No.FUN-680122char(20),
              ima131  LIKE ima_file.ima131,           #No.FUN-680122CHAR(10),
              ima11   LIKE ima_file.ima11,           #No.FUN-680122CHAR(4),
              ima02   LIKE ima_file.ima02,        #No.FUN-680122 VARCHAR(30),
              oba02   LIKE oba_file.oba02,        #No.FUN-680122 VARCHAR(30),
              ccg07    LIKE ccg_file.ccg07,           #No.FUN-840005
             # qty_ym1  LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_ym1  LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
              amt51_ym1 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym1 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym1 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym1 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
           #   qty_ym2  LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_ym2  LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
              amt51_ym2 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym2 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym2 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym2 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
            #  qty_ym3  LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)
              qty_ym3  LIKE type_file.num15_3,        ##FUN-A20044
              amt1_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
              amt51_ym3 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym3 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym3 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym3 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
            #  qty_ym4  LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_ym4  LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
              amt51_ym4 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym4 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym4 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym4 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
            #  qty_ym5  LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_ym5  LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
              amt51_ym5 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym5 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym5 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym5 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
           #   qty_ym6  LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              qty_ym6  LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3)#FUN-A20044
              amt1_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt2_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt3_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt4_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
              amt5_ym6 LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),  #FUN-5B0082
              amt51_ym6 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt52_ym6 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt53_ym6 LIKE type_file.num20_6,       #No.FUN-7C0101 DEC(20,6)
              amt6_ym6 LIKE type_file.num20_6         #No.FUN-680122 DEC(20,6)  #FUN-5B0082
          END RECORD
DEFINE l_ccg07 STRING   #FUN-840005
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order_l #sr.ima01,sr.ima131,sr.ima11
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0078
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      IF tm.dec ='2' THEN
         LET dec_name=g_x[11]
      ELSE IF tm.dec='3' THEN   
              LET dec_name=g_x[12]
           ELSE 
              LET dec_name=g_x[10]
           END IF
      END IF
      IF tm.type MATCHES '[12]' THEN
         LET l_ccg07=''
      ELSE 
         LET l_ccg07=g_x[24],sr.ccg07 CLIPPED
      END IF
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01    #No.FUN-870151    #TQC-970165 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[9]))/2)+1,g_x[9] CLIPPED,
                   tm.azk01 clipped,'/',cl_numfor(tm.azk04,9,t_azi07),  #No.FUN-870151
             COLUMN g_c[40],dec_name clipped,  #FUN-840005
             COLUMN g_c[42],l_ccg07 clipped   #FUN-840005
      PRINT g_head CLIPPED,pageno_total    #TQC-760141
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_dt1=tm.yy1_b USING '&&&&','/',tm.mm1_b using '&&',' - ',
                tm.yy1_b USING '&&&&','/',tm.mm1_e using '&&'
      LET l_dt2=tm.yy2_b USING '&&&&','/',tm.mm2_b using '&&',' - ',
                tm.yy2_b USING '&&&&','/',tm.mm2_e using '&&'
      LET l_dt3=tm.yy3_b USING '&&&&','/',tm.mm3_b using '&&',' ',' - ',
                tm.yy3_b USING '&&&&','/',tm.mm3_e using '&&'
      LET l_dt4=tm.yy4_b USING '&&&&','/',tm.mm4_b using '&&',' ',' - ',
                tm.yy4_b USING '&&&&','/',tm.mm4_e using '&&'
      LET l_dt5=tm.yy5_b USING '&&&&','/',tm.mm5_b using '&&',' ',' - ',
                tm.yy5_b USING '&&&&','/',tm.mm5_e using '&&'
      LET l_dt6=tm.yy6_b USING '&&&&','/',tm.mm6_b using '&&',' ',' - ',
                tm.yy6_b USING '&&&&','/',tm.mm6_e using '&&'
 
      PRINT COLUMN r111_getStartPos(33,34,l_dt1),l_dt1,
            COLUMN r111_getStartPos(35,36,l_dt2),l_dt2,
            COLUMN r111_getStartPos(37,38,l_dt3),l_dt3,
            COLUMN r111_getStartPos(39,40,l_dt4),l_dt4,
            COLUMN r111_getStartPos(41,42,l_dt5),l_dt5,
            COLUMN r111_getStartPos(43,44,l_dt6),l_dt6
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 
   AFTER GROUP OF sr.order_l
      NEED 6 LINES
      LET  l_qty1=GROUP SUM(sr.qty_ym1)
      LET  l_qty2=GROUP SUM(sr.qty_ym2)
      LET  l_qty3=GROUP SUM(sr.qty_ym3)
      LET  l_qty4=GROUP SUM(sr.qty_ym4)
      LET  l_qty5=GROUP SUM(sr.qty_ym5)
      LET  l_qty6=GROUP SUM(sr.qty_ym6)
      LET  l_amt1=GROUP SUM(sr.amt6_ym1)
      LET  l_amt2=GROUP SUM(sr.amt6_ym2)
      LET  l_amt3=GROUP SUM(sr.amt6_ym3)
      LET  l_amt4=GROUP SUM(sr.amt6_ym4)
      LET  l_amt5=GROUP SUM(sr.amt6_ym5)
      LET  l_amt6=GROUP SUM(sr.amt6_ym6)
 
 
      PRINT COLUMN g_c[31],sr.order_l clipped,
            COLUMN g_c[32],g_x[13] CLIPPED,
            COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz27), #CHI-690007 #l_qty1 USING '###,###,###,###,##&.&&&', #MOD-630040 cl_numfor(l_qty1,33,g_azi04) ,
            COLUMN g_c[34];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt1,l_qty1) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt1,l_qty1) USING '##&.&&';
                   END IF
      PRINT column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz27), #CHI-690007 l_qty2 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty2,35,g_azi04),
            column g_c[36];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt2,l_qty2) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt2,l_qty2) USING '##&.&&';
                   END IF
      PRINT column g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz27), #CHI-690007 l_qty3 USING '###,###,###,###,##&.&&&', #MOD-630040 cl_numfor(l_qty3,37,g_azi04),
            column g_c[38];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt3,l_qty3) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt3,l_qty3) USING '##&.&&';
                   END IF
      PRINT column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz27), #CHI-690007 l_qty4 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty4,39,g_azi04),
            column g_c[40];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt4,l_qty4) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt4,l_qty4) USING '##&.&&';
                   END IF
      PRINT column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz27), #CHI-690007 l_qty5 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty5,41,g_azi04),
            column g_c[42];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt5,l_qty5) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt5,l_qty5) USING '##&.&&';
                   END IF
      PRINT column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz27), #CHI-690007 l_qty6 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty6,43,g_azi04),
            column g_c[44];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt6,l_qty6) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt6,l_qty6) USING '##&.&&';
                   END IF
      PRINT column g_c[45],cl_numfor(l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6,45,g_ccz.ccz27), #CHI-690007
            column g_c[46];
                   IF tm.dec=1 THEN 
                      PRINT (l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6)/
                            (l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6) 
                             USING '#####&'
                   ELSE
                      PRINT (l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6)/
                            (l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6) 
                             USING '##&.&&'
                   END IF
      #材料
      LET  l_qty1=GROUP SUM(sr.amt1_ym1)
      LET  l_qty2=GROUP SUM(sr.amt1_ym2)
      LET  l_qty3=GROUP SUM(sr.amt1_ym3)
      LET  l_qty4=GROUP SUM(sr.amt1_ym4)
      LET  l_qty5=GROUP SUM(sr.amt1_ym5)
      LET  l_qty6=GROUP SUM(sr.amt1_ym6)
      IF tm.s_code = '1' THEN 
         PRINT COLUMN g_c[31],sr.ima131 CLIPPED ;
      ELSE 
         PRINT  ' ';
      END IF 
      PRINT column g_c[32],g_x[14] CLIPPED,
            column g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
            column g_c[37] ,cl_numfor(l_qty3,37,g_ccz.ccz26), #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
            column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
            column g_c[45],(l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6) #MOD-630040 
                           USING '###,###,###,###,##&.&&&',  #MOD-630040
            column g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6)*100/
                           (l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6) USING '##&.&&'
     #人工
      LET  l_qty1=GROUP SUM(sr.amt2_ym1)
      LET  l_qty2=GROUP SUM(sr.amt2_ym2)
      LET  l_qty3=GROUP SUM(sr.amt2_ym3)
      LET  l_qty4=GROUP SUM(sr.amt2_ym4)
      LET  l_qty5=GROUP SUM(sr.amt2_ym5)
      LET  l_qty6=GROUP SUM(sr.amt2_ym6)
 
 
      LET l_ima02 = '' 
      CASE tm.s_code
          WHEN '1'
                SELECT ima02 INTO l_ima02 FROM ima_file
                 WHERE ima01=sr.order_l
          WHEN '2'
                SELECT oba02 INTO l_ima02 FROM oba_file 
                 WHERE oba01=sr.order_l
          WHEN '3'
                SELECT azf03 INTO l_ima02 FROM azf_file 
                 WHERE azf01=sr.order_l AND azf02 = 'F' #6818
      END CASE 
      IF tm.detail = 'Y' THEN 
         SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.order_l
      END IF 
 
       PRINT COLUMN g_c[31],l_ima02 CLIPPED;  #MOD-4A0238
 
      PRINT column g_c[32],g_x[15] CLIPPED,
            column g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
            column g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&', 
            column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26),  #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
            column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                        l_qty5+l_qty6),45,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6)*100/
                           (l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6) USING '##&.&&'
      #製費
      LET  l_qty1=GROUP SUM(sr.amt3_ym1)
      LET  l_qty2=GROUP SUM(sr.amt3_ym2)
      LET  l_qty3=GROUP SUM(sr.amt3_ym3)
      LET  l_qty4=GROUP SUM(sr.amt3_ym4)
      LET  l_qty5=GROUP SUM(sr.amt3_ym5)
      LET  l_qty6=GROUP SUM(sr.amt3_ym6)
      PRINT column g_c[32],g_x[16] CLIPPED,
            column g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
            column g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&', 
            column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
            column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                           l_qty5+l_qty6),45,g_ccz.ccz26),    #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6)*100/
                           (l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6) USING '##&.&&'
         #加工
          LET  l_qty1=GROUP SUM(sr.amt4_ym1)
          LET  l_qty2=GROUP SUM(sr.amt4_ym2)
          LET  l_qty3=GROUP SUM(sr.amt4_ym3)
          LET  l_qty4=GROUP SUM(sr.amt4_ym4)
          LET  l_qty5=GROUP SUM(sr.amt4_ym5)
          LET  l_qty6=GROUP SUM(sr.amt4_ym6)
          PRINT COLUMN g_c[32],g_x[19] CLIPPED,
                COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
                COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
                COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
                COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
                COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
                COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
                COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                               l_qty5+l_qty6),45,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                               l_qty5+l_qty6)*100/
                               (l_amt1+l_amt2+l_amt3+l_amt4+
                               l_amt5+l_amt6) USING '##&.&&'
 
          #其他
          LET  l_qty1=GROUP SUM(sr.amt5_ym1)
          LET  l_qty2=GROUP SUM(sr.amt5_ym2)
          LET  l_qty3=GROUP SUM(sr.amt5_ym3)
          LET  l_qty4=GROUP SUM(sr.amt5_ym4)
          LET  l_qty5=GROUP SUM(sr.amt5_ym5)
          LET  l_qty6=GROUP SUM(sr.amt5_ym6)
          PRINT COLUMN g_c[32],g_x[20] CLIPPED,
                COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
                COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
                COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
                COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
                COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
                COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
                COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                               l_qty5+l_qty6),45,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                                l_qty5+l_qty6)*100/
                               (l_amt1+l_amt2+l_amt3+l_amt4+
                                l_amt5+l_amt6) USING '##&.&&'
          LET  l_qty1=GROUP SUM(sr.amt51_ym1)
          LET  l_qty2=GROUP SUM(sr.amt51_ym2)
          LET  l_qty3=GROUP SUM(sr.amt51_ym3)
          LET  l_qty4=GROUP SUM(sr.amt51_ym4)
          LET  l_qty5=GROUP SUM(sr.amt51_ym5)
          LET  l_qty6=GROUP SUM(sr.amt51_ym6)
          PRINT COLUMN g_c[32],g_x[21] CLIPPED,
                COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
                COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
                COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
                COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
                COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
                COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
                COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                               l_qty5+l_qty6),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                                l_qty5+l_qty6)*100/
                               (l_amt1+l_amt2+l_amt3+l_amt4+
                                l_amt5+l_amt6) USING '##&.&&'
          #                                                     
          LET  l_qty1=GROUP SUM(sr.amt52_ym1)
          LET  l_qty2=GROUP SUM(sr.amt52_ym2)
          LET  l_qty3=GROUP SUM(sr.amt52_ym3)
          LET  l_qty4=GROUP SUM(sr.amt52_ym4)
          LET  l_qty5=GROUP SUM(sr.amt52_ym5)
          LET  l_qty6=GROUP SUM(sr.amt52_ym6)
          PRINT COLUMN g_c[32],g_x[22] CLIPPED,
                COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
                COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
                COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
                COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
                COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
                COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
                COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                               l_qty5+l_qty6),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                                l_qty5+l_qty6)*100/
                               (l_amt1+l_amt2+l_amt3+l_amt4+
                                l_amt5+l_amt6) USING '##&.&&'
          #                                                     
          LET  l_qty1=GROUP SUM(sr.amt53_ym1)
          LET  l_qty2=GROUP SUM(sr.amt53_ym2)
          LET  l_qty3=GROUP SUM(sr.amt53_ym3)
          LET  l_qty4=GROUP SUM(sr.amt53_ym4)
          LET  l_qty5=GROUP SUM(sr.amt53_ym5)
          LET  l_qty6=GROUP SUM(sr.amt53_ym6)
          PRINT COLUMN g_c[32],g_x[23] CLIPPED,
                COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
                COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
                COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
                COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
                COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
                COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
                COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                               l_qty5+l_qty6),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                                l_qty5+l_qty6)*100/
                               (l_amt1+l_amt2+l_amt3+l_amt4+
                                l_amt5+l_amt6) USING '##&.&&'
      PRINT g_dash1
      PRINT column g_c[32],g_x[18] CLIPPED,
            column g_c[33],cl_numfor(l_amt1,33,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_amt1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_amt2,35,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_amt2,l_amt2) USING '##&.&&',
            column g_c[37],cl_numfor(l_amt3,37,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_amt3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_amt4,39,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_amt4,l_amt4) USING '##&.&&', 
            column g_c[41],cl_numfor(l_amt5,41,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_amt5,l_amt5) USING '##&.&&', 
            column g_c[43],cl_numfor(l_amt6,43,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_amt6,l_amt6) USING '##&.&&', 
            column g_c[45],cl_numfor((l_amt1+l_amt2+l_amt3+l_amt4+
                           l_amt5+l_amt6),45,g_ccz.ccz26)     #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            #olumn 239,'100.00'
      PRINT g_dash2
 
 
   ON LAST ROW
      NEED 9 LINES
      LET  l_qty1=SUM(sr.qty_ym1)
      LET  l_qty2=SUM(sr.qty_ym2)
      LET  l_qty3=SUM(sr.qty_ym3)
      LET  l_qty4=SUM(sr.qty_ym4)
      LET  l_qty5=SUM(sr.qty_ym5)
      LET  l_qty6=SUM(sr.qty_ym6)
      LET  l_amt1=SUM(sr.amt6_ym1)
      LET  l_amt2=SUM(sr.amt6_ym2)
      LET  l_amt3=SUM(sr.amt6_ym3)
      LET  l_amt4=SUM(sr.amt6_ym4)
      LET  l_amt5=SUM(sr.amt6_ym5)
      LET  l_amt6=SUM(sr.amt6_ym6)
 
      PRINT COLUMN g_c[31],g_x[18] clipped,
            COLUMN g_c[32],g_x[13] CLIPPED,
            COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz27), #CHI-690007 l_qty1 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty1,33,g_azi05),   
            column g_c[34];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt1,l_qty1) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt1,l_qty1) USING '##&.&&';
                   END IF
      PRINT column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz27), #CHI-690007 l_qty2 USING '###,###,###,###,##&.&&&',   #MOD-630040 cl_numfor(l_qty2,35,g_azi03),  
            column g_c[36];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt2,l_qty2) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt2,l_qty2) USING '##&.&&';
                   END IF
      PRINT column g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz27), #CHI-690007 l_qty3 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty3,37,g_azi03),    
            column g_c[38];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt3,l_qty3) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt3,l_qty3) USING '##&.&&';
                   END IF
      PRINT column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz27), #CHI-690007 l_qty4 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty4,39,g_azi03),   
            column g_c[40];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt4,l_qty4) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt4,l_qty4) USING '##&.&&';
                   END IF
      PRINT column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz27), #CHI-690007 l_qty5 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty5,41,g_azi03),    
            column g_c[42];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt5,l_qty5) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt5,l_qty5) USING '##&.&&';
                   END IF
      PRINT column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz27), #l_qty6 USING '###,###,###,###,##&.&&&',  #MOD-630040 cl_numfor(l_qty6,43,g_azi03),    
            column g_c[44];
                   IF tm.dec=1 THEN PRINT chk_dev1(l_amt6,l_qty6) USING '#####&';
                      ELSE PRINT chk_dev1(l_amt6,l_qty6) USING '##&.&&';
                   END IF
     #PRINT column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6),17,g_azi05),   #TQC-5B0019 mark
     #PRINT column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6),45,g_azi03),   #TQC-5B0019  #MOD-630040
      PRINT column g_c[45],cl_numfor(l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6,45,g_ccz.ccz27), #CHI-690007  USING '###,###,###,###,##&.&&&',    #MOD-630040
            column g_c[46];
                   IF tm.dec=1 THEN 
                      PRINT (l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6)/
                          (l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6) USING '#####&'
                   ELSE
                      PRINT (l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6)/
                          (l_qty1+l_qty2+l_qty3+l_qty4+l_qty5+l_qty6) USING '##&.&&'
                   END IF
    #材料    
      LET  l_qty1=SUM(sr.amt1_ym1)
      LET  l_qty2=SUM(sr.amt1_ym2)
      LET  l_qty3=SUM(sr.amt1_ym3)
      LET  l_qty4=SUM(sr.amt1_ym4)
      LET  l_qty5=SUM(sr.amt1_ym5)
      LET  l_qty6=SUM(sr.amt1_ym6)
      PRINT 
            column g_c[32],g_x[14] CLIPPED,
            column g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26),    #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
            column g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26),    #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26),     #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26),      #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
            column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26),      #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
            column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6),45,g_ccz.ccz26),       #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6)*100/
                           (l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6) USING '##&.&&'
     #人工
      LET  l_qty1=SUM(sr.amt2_ym1)
      LET  l_qty2=SUM(sr.amt2_ym2)
      LET  l_qty3=SUM(sr.amt2_ym3)
      LET  l_qty4=SUM(sr.amt2_ym4)
      LET  l_qty5=SUM(sr.amt2_ym5)
      LET  l_qty6=SUM(sr.amt2_ym6)
      PRINT column g_c[32],g_x[15] CLIPPED,
            column g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
            column g_c[37] ,cl_numfor(l_qty3,37,g_ccz.ccz26),  #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
            column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26),  #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
            column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6),45,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6)*100/
                           (l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6) USING '##&.&&'
      #製費
      LET  l_qty1=SUM(sr.amt3_ym1)
      LET  l_qty2=SUM(sr.amt3_ym2)
      LET  l_qty3=SUM(sr.amt3_ym3)
      LET  l_qty4=SUM(sr.amt3_ym4)
      LET  l_qty5=SUM(sr.amt3_ym5)
      LET  l_qty6=SUM(sr.amt3_ym6)
      PRINT column g_c[32],g_x[16] CLIPPED,
            column g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
            column g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
            column g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
            column g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                        l_qty5+l_qty6),45,g_ccz.ccz26),   #MOD-630040 #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                            l_qty5+l_qty6)*100/
                           (l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6) USING '##&.&&'
     #加工
     LET  l_qty1=SUM(sr.amt4_ym1)
     LET  l_qty2=SUM(sr.amt4_ym2)
     LET  l_qty3=SUM(sr.amt4_ym3)
     LET  l_qty4=SUM(sr.amt4_ym4)
     LET  l_qty5=SUM(sr.amt4_ym5)
     LET  l_qty6=SUM(sr.amt4_ym6)
     PRINT COLUMN g_c[32],g_x[19] CLIPPED,
           COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
           COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
           COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
           COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
           COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
           COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
           COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                       l_qty5+l_qty6),45,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                           l_qty5+l_qty6)*100/
                          (l_amt1+l_amt2+l_amt3+l_amt4+
                           l_amt5+l_amt6) USING '##&.&&'
 
     #其他
     LET  l_qty1=SUM(sr.amt5_ym1)
     LET  l_qty2=SUM(sr.amt5_ym2)
     LET  l_qty3=SUM(sr.amt5_ym3)
     LET  l_qty4=SUM(sr.amt5_ym4)
     LET  l_qty5=SUM(sr.amt5_ym5)
     LET  l_qty6=SUM(sr.amt5_ym6)
     PRINT COLUMN g_c[32],g_x[20] CLIPPED,
           COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
           COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
           COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
           COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
           COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
           COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
           COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                       l_qty5+l_qty6),45,g_ccz.ccz26), #No.FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                           l_qty5+l_qty6)*100/
                          (l_amt1+l_amt2+l_amt3+l_amt4+
                           l_amt5+l_amt6) USING '##&.&&'
    #
     LET  l_qty1=SUM(sr.amt51_ym1)
     LET  l_qty2=SUM(sr.amt51_ym2)
     LET  l_qty3=SUM(sr.amt51_ym3)
     LET  l_qty4=SUM(sr.amt51_ym4)
     LET  l_qty5=SUM(sr.amt51_ym5)
     LET  l_qty6=SUM(sr.amt51_ym6)
     PRINT COLUMN g_c[32],g_x[21] CLIPPED,
           COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26 
           COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
           COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
           COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
           COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
           COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
           COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
           COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                       l_qty5+l_qty6),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                           l_qty5+l_qty6)*100/
                          (l_amt1+l_amt2+l_amt3+l_amt4+
                           l_amt5+l_amt6) USING '##&.&&'
    
    #
     LET  l_qty1=SUM(sr.amt52_ym1)
     LET  l_qty2=SUM(sr.amt52_ym2)
     LET  l_qty3=SUM(sr.amt52_ym3)
     LET  l_qty4=SUM(sr.amt52_ym4)
     LET  l_qty5=SUM(sr.amt52_ym5)
     LET  l_qty6=SUM(sr.amt52_ym6)
     PRINT COLUMN g_c[32],g_x[22] CLIPPED,
           COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
           COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
           COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
           COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
           COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
           COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
           COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                       l_qty5+l_qty6),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                           l_qty5+l_qty6)*100/
                          (l_amt1+l_amt2+l_amt3+l_amt4+
                           l_amt5+l_amt6) USING '##&.&&'
    
    #
     LET  l_qty1=SUM(sr.amt53_ym1)
     LET  l_qty2=SUM(sr.amt53_ym2)
     LET  l_qty3=SUM(sr.amt53_ym3)
     LET  l_qty4=SUM(sr.amt53_ym4)
     LET  l_qty5=SUM(sr.amt53_ym5)
     LET  l_qty6=SUM(sr.amt53_ym6)
     PRINT COLUMN g_c[32],g_x[23] CLIPPED,
           COLUMN g_c[33],cl_numfor(l_qty1,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[34],chk_dev(l_qty1,l_amt1) USING '##&.&&',
           COLUMN g_c[35],cl_numfor(l_qty2,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[36],chk_dev(l_qty2,l_amt2) USING '##&.&&',
           COLUMN g_c[37],cl_numfor(l_qty3,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[38],chk_dev(l_qty3,l_amt3) USING '##&.&&',
           COLUMN g_c[39],cl_numfor(l_qty4,39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[40],chk_dev(l_qty4,l_amt4) USING '##&.&&',
           COLUMN g_c[41],cl_numfor(l_qty5,41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[42],chk_dev(l_qty5,l_amt5) USING '##&.&&',
           COLUMN g_c[43],cl_numfor(l_qty6,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[44],chk_dev(l_qty6,l_amt6) USING '##&.&&',
           COLUMN g_c[45],cl_numfor((l_qty1+l_qty2+l_qty3+l_qty4+
                       l_qty5+l_qty6),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           COLUMN g_c[46],(l_qty1+l_qty2+l_qty3+l_qty4+
                           l_qty5+l_qty6)*100/
                          (l_amt1+l_amt2+l_amt3+l_amt4+
                           l_amt5+l_amt6) USING '##&.&&'
 
      PRINT g_dash1
      PRINT column g_c[32],g_x[18] CLIPPED,
            column g_c[33],cl_numfor(l_amt1,33,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[34],chk_dev(l_amt1,l_amt1) USING '##&.&&',
            column g_c[35],cl_numfor(l_amt2,35,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[36],chk_dev(l_amt2,l_amt2) USING '##&.&&',
            column g_c[37],cl_numfor(l_amt3,37,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[38],chk_dev(l_amt3,l_amt3) USING '##&.&&',
            column g_c[39],cl_numfor(l_amt4,39,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[40],chk_dev(l_amt4,l_amt4) USING '##&.&&',
            column g_c[41],cl_numfor(l_amt5,41,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[42],chk_dev(l_amt5,l_amt5) USING '##&.&&', 
            column g_c[43],cl_numfor(l_amt6,43,g_ccz.ccz26),   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            column g_c[44],chk_dev(l_amt6,l_amt6) USING '##&.&&', 
            column g_c[45],cl_numfor((l_amt1+l_amt2+l_amt3+l_amt4+
                            l_amt5+l_amt6),45,g_ccz.ccz26)   #MOD-630040 #CHI-C30012 g_azi03->g_ccz.ccz26
            #olumn 239,'100.00'
      LET l_last_sw = 'y'
      PRINT g_dash2
      PRINT COLUMN g_c[31],'data from : ',
            g_ary[1].plant CLIPPED,' ', g_ary[2].plant CLIPPED,' ',
            g_ary[3].plant CLIPPED,' ', g_ary[4].plant CLIPPED,' ',
            g_ary[5].plant CLIPPED,' ', g_ary[6].plant CLIPPED,' ',
            g_ary[7].plant CLIPPED,' ', g_ary[8].plant CLIPPED
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
 
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION chk_dev1(tmp1,tmp2)
DEFINE tmp1,tmp2 LIKE occ_file.occ15         #No.FUN-680122dec(15,0)
DEFINE tmp3 LIKE sgm_file.sgm15         #No.FUN-680122DECIMAL(15,2)
      IF tmp2 <>0 AND tmp2 IS NOT NULL THEN
         LET tmp3=tmp1/tmp2
      ELSE 
         LET tmp3=0
      END IF
   RETURN tmp3
END FUNCTION
 
FUNCTION chk_dev(tmp1,tmp2)
DEFINE tmp1,tmp2   LIKE occ_file.occ15         #No.FUN-680122dec(15,0)
DEFINE tmp3 LIKE sgm_file.sgm15         #No.FUN-680122DECIMAL(15,2)
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
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r111_getStartPos(l_sta,l_end,l_str)
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
 
FUNCTION r111_chkplant(l_plant)
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
#No.FUN-9C0073 ----------------By chenls  10/01/12

#FUN-A70084--add--str--
FUNCTION r111_set_entry() 
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file 
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN 
     CALL cl_set_comp_visible("group04",FALSE)
  END IF 
  RETURN l_cnt
END FUNCTION

FUNCTION r111_chklegal(l_legal,n)
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
