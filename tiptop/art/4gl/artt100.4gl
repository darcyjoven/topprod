# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt100.4gl
# Descriptions...: 策略批量審批調整單
# Date & Author..: No:FUN-BC0076 11/12/27 By fanbj
# Modify.........: No.TQC-C20070 12/02/08 By fanbj 更改價格策略編號+產品編號+單位的帶出值
# Modify.........: No.TQC-C20136 12/02/13 By fanbj 增加BEFORE DIALOG
# Modify.........: No.TQC-C20270 12/02/21 By fanbj 單身批量新增邏輯修改
# Modify.........: No.TQC-C20357 12/02/24 By baogc 採購策略產品編號開窗修正
# Modify.........: No.FUN-BC0130 12/02/29 By yangxf 確認時, 取消對稅別中的單價含稅否的一致性控卡.
# Modify.........: No.TQC-C30083 12/03/05 By pauline 輸入價格策略時將價格策略編號當為key值 
# Modify.........: No:TQC-C30076 12/03/07 by pauline 輸入的稅別必須要與almi660互相控卡
# Modify.........: No:TQC-C30322 12/03/07 by pauline 將計價單位當作PK值,接受同產品不同計價單位
# Modify.........: No:FUN-C30306 12/04/02 By pauline 產品多稅別設定不自動彈窗供使用者維護 
# Modify.........: No.FUN-C50036 12/05/21 By fanbj 增加最高退假欄位
# Modify.........: No.CHI-C30107 12/06/15 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-C80076 12/08/22 By nanbing 新增時，如果rtj25為空，則賦值為0
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑
# Modify.........: No:FUN-D20063 13/02/20 By Sakura 單身價格策略rtj13,rtj14,rtj15,rtj16,rtj17,rtj18,rtj25欄位控卡, 改成金額不可小於0
# Modify.........: No:FUN-D30050 13/03/18 By dongsz 產品為券時,增加稅種的檢查
# Modify.........: No:FUN-D30033 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D30033 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40044 13/04/19 By dongsz 維護單位時，檢查是否存在庫存單位轉化率，存在時才能維護

DATABASE ds  
 
GLOBALS "../../config/top.global"

DEFINE g_rti           RECORD LIKE rti_file.*,
       g_rti_t         RECORD LIKE rti_file.*,
       g_rti_o         RECORD LIKE rti_file.*,
       g_rti01_t              LIKE rti_file.rti01

DEFINE g_rtj               DYNAMIC ARRAY OF RECORD
          rtj24               LIKE rtj_file.rtj24,    #产品策略编号
          rtj03               LIKE rtj_file.rtj03,    #项次
          rtj04               LIKE rtj_file.rtj04,    #产品编号
          rtj04_desc          LIKE ima_file.ima02,    #产品名称
          rtj21               LIKE rtj_file.rtj21,    #税种
          rtj21_desc          LIKE gec_file.gec02,    #税种名称
          rtj06               LIKE rtj_file.rtj06,    #是否可采
          rtj07               LIKE rtj_file.rtj07,    #是否可售
          rtj08               LIKE rtj_file.rtj08,    #是否可退
          rtj20               LIKE rtj_file.rtj20     #有效否
                           END RECORD,

       g_rtj_t             RECORD
          rtj24               LIKE rtj_file.rtj24,    #产品策略编号
          rtj03               LIKE rtj_file.rtj03,    #项次
          rtj04               LIKE rtj_file.rtj04,    #产品编号
          rtj04_desc          LIKE ima_file.ima02,    #产品名称
          rtj21               LIKE rtj_file.rtj21,    #税种
          rtj21_desc          LIKE gec_file.gec02,    #税种名称
          rtj06               LIKE rtj_file.rtj06,    #是否可采
          rtj07               LIKE rtj_file.rtj07,    #是否可售
          rtj08               LIKE rtj_file.rtj08,    #是否可退
          rtj20               LIKE rtj_file.rtj20     #有效否
                           END RECORD, 
                           
      g_rtj_1              DYNAMIC ARRAY OF RECORD
         rtj24_1              LIKE rtj_file.rtj24,    #价格策略编号
         rtj03_1              LIKE rtj_file.rtj03,    #项次
         rtj04_1              LIKE rtj_file.rtj04,    #产品编号
         rtj04_desc1          LIKE ima_file.ima02,    #产品名称
         rtj09                LIKE rtj_file.rtj09,    #计价单位
         rtj09_desc           LIKE gfe_file.gfe02,    #单位名称
         rtj10                LIKE rtj_file.rtj10,    #原标准售价
         rtj11                LIKE rtj_file.rtj11,    #原标准会员价
         rtj12                LIKE rtj_file.rtj12,    #原标准最低价
         rtj13                LIKE rtj_file.rtj13,    #标准售价调价比例
         rtj14                LIKE rtj_file.rtj14,    #标准会员价调价比例
         rtj15                LIKE rtj_file.rtj15,    #标准最低价调价比例
         rtj16                LIKE rtj_file.rtj16,    #新标准售价
         rtj17                LIKE rtj_file.rtj17,    #新标准会员价
         rtj18                LIKE rtj_file.rtj18,    #新标准最低价
         rtj25                LIKE rtj_file.rtj25,    #最高退價  #FUN-C50036 add          
         rtj19                LIKE rtj_file.rtj19,    #允许自定价
         rtj23                LIKE rtj_file.rtj23,    #开价否
         rtj20                LIKE rtj_file.rtj20     #有效否    
                           END RECORD,
      g_rtj_1_t            RECORD
         rtj24_1              LIKE rtj_file.rtj24,    #价格策略编号
         rtj03_1              LIKE rtj_file.rtj03,    #项次
         rtj04_1              LIKE rtj_file.rtj04,    #产品编号
         rtj04_desc1          LIKE ima_file.ima02,    #产品名称    
         rtj09                LIKE rtj_file.rtj09,    #计价单位 
         rtj09_desc           LIKE gfe_file.gfe02,    #单位名称
         rtj10                LIKE rtj_file.rtj10,    #原标准售价 
         rtj11                LIKE rtj_file.rtj11,    #原标准会员价 
         rtj12                LIKE rtj_file.rtj12,    #原标准最低价
         rtj13                LIKE rtj_file.rtj13,    #标准售价调价比例 
         rtj14                LIKE rtj_file.rtj14,    #标准会员价调价比例
         rtj15                LIKE rtj_file.rtj15,    #标准最低价调价比例
         rtj16                LIKE rtj_file.rtj16,    #新标准售价
         rtj17                LIKE rtj_file.rtj17,    #新标准会员价
         rtj18                LIKE rtj_file.rtj18,    #新标准最低价
         rtj25                LIKE rtj_file.rtj25,    #最高退價  #FUN-C50036 add  
         rtj19                LIKE rtj_file.rtj19,    #允许自定价
         rtj23                LIKE rtj_file.rtj23,    #开价否
         rtj20                LIKE rtj_file.rtj20     #有效否    
                           END RECORD,        
                           
      g_ryn                DYNAMIC ARRAY OF RECORD
           ryn02              LIKE ryn_file.ryn02,    #變更類型
           ryn03              LIKE ryn_file.ryn03,    #變更機構
           ryn03_desc         LIKE azp_file.azp02,    #機構名
           ryn04              LIKE ryn_file.ryn04,    #商品編號
           ryn04_desc         LIKE ima_file.ima02,    #商品名稱
           ryn05              LIKE ryn_file.ryn05,    #採購類型
           ryn06              LIKE ryn_file.ryn06,    #配送中心
           ryn06_desc         LIKE geu_file.geu02,    #配送中心名稱
           ryn07              LIKE ryn_file.ryn07,    #主供應商
           ryn08              LIKE ryn_file.ryn08,    #經營方式
           ryn09              LIKE ryn_file.ryn09,    #可超交比率%
           ryn10              LIKE ryn_file.ryn10,    #安全庫存量
           ryn11              LIKE ryn_file.ryn11,    #再補貨點量
           ryn12              LIKE ryn_file.ryn12,    #採購多角流程代碼
           ryn13              LIKE ryn_file.ryn13,    #退貨多角流程代碼
           ryn15              LIKE ryn_file.ryn15,    #採購中心
           ryn15_desc         LIKE geu_file.geu02,    #採購中心名稱
           ryn14              LIKE ryn_file.ryn14     #有效否
                           END RECORD,
       g_ryn_t             RECORD
           ryn02              LIKE ryn_file.ryn02,    #變更類型
           ryn03              LIKE ryn_file.ryn03,    #變更機構
           ryn03_desc         LIKE azp_file.azp02,    #機構名
           ryn04              LIKE ryn_file.ryn04,    #商品編號
           ryn04_desc         LIKE ima_file.ima02,    #商品名稱
           ryn05              LIKE ryn_file.ryn05,    #採購類型
           ryn06              LIKE ryn_file.ryn06,    #配送中心
           ryn06_desc         LIKE geu_file.geu02,    #配送中心名稱
           ryn07              LIKE ryn_file.ryn07,    #主供應商
           ryn08              LIKE ryn_file.ryn08,    #經營方式
           ryn09              LIKE ryn_file.ryn09,    #可超交比率%
           ryn10              LIKE ryn_file.ryn10,    #安全庫存量
           ryn11              LIKE ryn_file.ryn11,    #再補貨點量
           ryn12              LIKE ryn_file.ryn12,    #採購多角流程代碼
           ryn13              LIKE ryn_file.ryn13,    #退貨多角流程代碼
           ryn15              LIKE ryn_file.ryn15,    #採購中心
           ryn15_desc         LIKE geu_file.geu02,    #採購中心名稱
           ryn14              LIKE ryn_file.ryn14     #有效否
                           END RECORD,      
        g_ruh              DYNAMIC ARRAY OF RECORD
           ruh02              LIKE ruh_file.ruh02,    #项次
           rtj04              LIKE rtj_file.rtj04,    #产品编号
           rtj04_n            LIKE ima_file.ima02,    #产品名称
           ruh03              LIKE ruh_file.ruh03,    #序号
           ruh04              LIKE ruh_file.ruh04,    #税种
           gec02              LIKE gec_file.gec02,    #税种名称
           gec04              LIKE gec_file.gec04,    #税率
           ruh06              LIKE ruh_file.ruh06     #固定税额
                           END RECORD,
       g_ruh_t             RECORD
           ruh02              LIKE ruh_file.ruh02,    #项次
           rtj04              LIKE rtj_file.rtj04,    #产品编号
           rtj04_n            LIKE ima_file.ima02,    #产品名称
           ruh03              LIKE ruh_file.ruh03,    #序号
           ruh04              LIKE ruh_file.ruh04,    #税种
           gec02              LIKE gec_file.gec02,    #税种名称
           gec04              LIKE gec_file.gec04,    #税率
           ruh06              LIKE ruh_file.ruh06     #固定税额
                           END RECORD,
        g_ruh_o            RECORD
           ruh02              LIKE ruh_file.ruh02,    #项次
           rtj04              LIKE rtj_file.rtj04,    #产品编号
           rtj04_n            LIKE ima_file.ima02,    #产品名称
           ruh03              LIKE ruh_file.ruh03,    #序号
           ruh04              LIKE ruh_file.ruh04,    #税种
           gec02              LIKE gec_file.gec02,    #税种名称
           gec04              LIKE gec_file.gec04,    #税率
           ruh06              LIKE ruh_file.ruh06     #固定税额
                           END RECORD
DEFINE tm1                 RECORD
          wc1                 STRING,
          wc2                 string,
          rtj21               LIKE rtj_file.rtj21,    #稅別
          rtj06               LIKE rtj_file.rtj06,    #是否可采
          rtj07               LIKE rtj_file.rtj07,    #是否可售
          rtj08               LIKE rtj_file.rtj08,    #是否可退
          rtj20               LIKE rtj_file.rtj20     #有效否
                           END RECORD,
       tm2                 RECORD 
          wc1                 STRING,
          wc2                 STRING,
          rtj09               LIKE rtj_file.rtj09,    #计价单位
          rtj16               LIKE rtj_file.rtj16,    #新标准售价
          rtj17               LIKE rtj_file.rtj17,    #新标准会员价
          rtj18               LIKE rtj_file.rtj18,    #新标准最低价
          rtj19               LIKE rtj_file.rtj19,    #允许自定价
          rtj23               LIKE rtj_file.rtj23,    #开价否
          rtj20               LIKE rtj_file.rtj20     #有效否
                           END RECORD,
       tm3                 RECORD 
          wc1                 STRING,
          wc2                 STRING,
          ryn05               LIKE ryn_file.ryn05,    #采购类型
          ryn06               LIKE ryn_file.ryn06,    #配送中心
          ryn15               LIKE ryn_file.ryn15,    #采购中心
          ryn07               LIKE ryn_file.ryn07,    #主供应商
          ryn09               LIKE ryn_file.ryn09,    #可超交比率
          ryn10               LIKE ryn_file.ryn10,    #安全库存量
          ryn12               LIKE ryn_file.ryn12,    #采购多角贸易流程
          ryn13               LIKE ryn_file.ryn13,    #退货多角贸易流程
          ryn14               LIKE ryn_file.ryn14     #有效否
                           END RECORD        

#TQC-C20070 Add Begin ---
DEFINE g_ruh_a             DYNAMIC ARRAY OF RECORD
          ruh03               LIKE ruh_file.ruh03,
          ruh04               LIKE ruh_file.ruh04,
          gec02               LIKE gec_file.gec02,
          gec04               LIKE gec_file.gec04,
          ruh06               LIKE ruh_file.ruh06
                           END RECORD

DEFINE g_ruh_a_t           RECORD
          ruh03               LIKE ruh_file.ruh03,
          ruh04               LIKE ruh_file.ruh04,
          gec02               LIKE gec_file.gec02,
          gec04               LIKE gec_file.gec04,
          ruh06               LIKE ruh_file.ruh06
                           END RECORD
#TQC-C20070 Add End -----

                      
DEFINE g_sql                  STRING
DEFINE g_wc                   STRING
DEFINE g_wc2,g_wc3,g_wc4      STRING
DEFINE g_rec_b1,g_rec_b2      LIKE type_file.num10
DEFINE g_rec_b3               LIKE type_file.num10
DEFINE l_ac1,l_ac2,l_ac3      LIKE type_file.num10
DEFINE l_ac                   LIKE type_file.num10
DEFINE l_ac_p                 LIKE type_file.num10   #產品策略批量新增時使用
DEFINE g_forupd_sql           STRING
DEFINE g_before_input_done    LIKE type_file.num10
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_msg                  LIKE ze_file.ze03
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10
DEFINE g_jump                 LIKE type_file.num10
DEFINE g_no_ask               LIKE type_file.num10
DEFINE l_table                STRING
DEFINE g_str                  STRING  
DEFINE g_flag_b               LIKE type_file.chr1
DEFINE g_date                 LIKE rti_file.rtidate
DEFINE g_modu                 LIKE rti_file.rtimodu
DEFINE g_t1                   LIKE oay_file.oayslip
DEFINE g_chr                  LIKE type_file.chr1 
DEFINE l_flag                 LIKE type_file.chr1
DEFINE g_cmd                  LIKE type_file.chr1
DEFINE g_rtj24                LIKE rtj_file.rtj24    #策略编号       
DEFINE g_rtj04                LIKE rtj_file.rtj04    #产品编号
DEFINE g_rtj05                LIKE rtj_file.rtj05    #类型
DEFINE g_success_sum          LIKE type_file.num10
DEFINE g_ryn02                LIKE ryn_file.ryn02    #变更类型         
DEFINE g_ryn03                LIKE ryn_file.ryn03    #变更营运中心
DEFINE g_ryn04                LIKE ryn_file.ryn04    #产品编号
DEFINE g_author               LIKE type_file.chr1000 
#TQC-C20070 Add Begin ---
DEFINE g_rtj21_t              LIKE rtj_file.rtj21
#TQC-C20070 Add End -----

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rti_file WHERE rti01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t100_w WITH FORM "art/42f/artt100"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_set_comp_visible("ryn02",FALSE) 
   CALL cl_set_comp_visible("rtj03",FALSE)
   CALL cl_set_comp_visible("rtj03_1",FALSE)
   CALL t100_menu()
   CLOSE WINDOW t100_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t100_cs()
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01
   DEFINE l_table         LIKE type_file.chr1000
   DEFINE l_where         LIKE type_file.chr1000
 
   CLEAR FORM
   CALL g_rtj.clear()
   CALL g_rtj_1.clear()
   CALL g_ryn.clear()
   
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_rti.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON rti01,rti02,rti03,rticonf,rticond,rticonu,
                                rti900,rtiplant,rti07,rtiuser,rtigrup,rtioriu,
                                rtimodu,rtidate,rtiorig,rtiacti,rticrat
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               #策略变更单号
               WHEN INFIELD(rti01)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rti01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rti01
                  NEXT FIELD rti01
           END CASE
      END CONSTRUCT

      CONSTRUCT g_wc2 ON rtj24,rtj04,rtj21,rtj06,rtj07,rtj08,rtj20
                    FROM s_rtj[1].rtj24,s_rtj[1].rtj04,s_rtj[1].rtj21,
                         s_rtj[1].rtj06,s_rtj[1].rtj07,s_rtj[1].rtj08,
                         s_rtj[1].rtj20      
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION controlp
            CASE 
               #产品策略编号
               WHEN INFIELD(rtj24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_rtj24"
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtj24
                 NEXT FIELD rtj24

              #产品编号
              WHEN INFIELD(rtj04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_rtj04"
                 LET g_qryparam.arg1 = '1'                 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtj04
                 NEXT FIELD rtj04

              #税种
              WHEN INFIELD(rtj21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_rtj21"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtj21
                 NEXT FIELD rtj21
               OTHERWISE EXIT CASE   
           END CASE     
      END CONSTRUCT  

      CONSTRUCT g_wc3 ON rtj24,rtj04,rtj09,rtj10,rtj11,rtj12,rtj13,rtj14,rtj15,
                         #rtj16,rtj17,rtj18,rtj19,rtj23,rtj20                            #FUN-C50036 mark
                         rtj16,rtj17,rtj18,rtj25,rtj19,rtj23,rtj20                       #FUN-C50036 add
                    FROM s_rtj_1[1].rtj24_1,s_rtj_1[1].rtj04_1,s_rtj_1[1].rtj09,
                         s_rtj_1[1].rtj10,s_rtj_1[1].rtj11,s_rtj_1[1].rtj12,
                         s_rtj_1[1].rtj13,s_rtj_1[1].rtj14,s_rtj_1[1].rtj15,
                         s_rtj_1[1].rtj16,s_rtj_1[1].rtj17,s_rtj_1[1].rtj18,
                         s_rtj_1[1].rtj25,                                               #FUN-C50036 add 
                         s_rtj_1[1].rtj19,s_rtj_1[1].rtj23,s_rtj_1[1].rtj20
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #价格策略编号
               WHEN INFIELD(rtj24_1)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rtj24"
                  LET g_qryparam.arg1 = '2'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtj24_1
                  NEXT FIELD rtj24_1

               #产品编号
               WHEN INFIELD(rtj04_1)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rtj04"
                  LET g_qryparam.arg1 = '2'                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtj04_1
                  NEXT FIELD rtj04_1

                #计价单位
                WHEN INFIELD(rtj09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rtj09"            
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtj09
                  NEXT FIELD rtj09  
                OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT

      CONSTRUCT g_wc4 ON ryn03,ryn04,ryn05,ryn06,ryn07,ryn08,ryn09,ryn10,
                         ryn11,ryn12,ryn13,ryn15,ryn14
                    FROM s_ryn[1].ryn03,s_ryn[1].ryn04,s_ryn[1].ryn05,
                         s_ryn[1].ryn06,s_ryn[1].ryn07,s_ryn[1].ryn08,
                         s_ryn[1].ryn09,s_ryn[1].ryn10,s_ryn[1].ryn11,
                         s_ryn[1].ryn12,s_ryn[1].ryn13,s_ryn[1].ryn15,
                         s_ryn[1].ryn14
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn) 

         ON ACTION controlp
            CASE 
               #变更营运中心
               WHEN INFIELD(ryn03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn03
                  NEXT FIELD ryn03

               #产品编号
               WHEN INFIELD(ryn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn04
                  NEXT FIELD ryn04
                  
              #配送中心   
              WHEN INFIELD(ryn06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn06
                  NEXT FIELD ryn06
                  
              #主供应商
              WHEN INFIELD(ryn07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn07"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn07
                  NEXT FIELD ryn07
                  
              #采购多角贸易流程
              WHEN INFIELD(ryn12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn12
                  NEXT FIELD ryn12
                  
              #退货多角贸易流程
              WHEN INFIELD(ryn13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn13
                  NEXT FIELD ryn13
                  
              #采购中心   
              WHEN INFIELD(ryn15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form="q_rvn15"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn15
                  NEXT FIELD ryn15
                  
               OTHERWISE EXIT CASE   
            END CASE
      END CONSTRUCT  

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
                 
      ON ACTION about 
         CALL cl_about()
                      
      ON ACTION HELP  
         CALL cl_show_help()
             
      ON ACTION controlg
         CALL cl_cmdask()
                
      ON ACTION qbe_save
         CALL cl_qbe_save() 

      ON ACTION ACCEPT
         ACCEPT DIALOG
 
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG

   END DIALOG

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT DISTINCT rti01 "
   LET l_table = " FROM rti_file "
   LET l_where = " WHERE ",g_wc
      
   IF g_wc2 <> " 1=1" THEN
      IF g_wc3 <> " 1=1" THEN
         LET l_table = l_table," ,rtj_file"
         LET l_where = " WHERE ",g_wc CLIPPED,
                       " AND rtj01 = rti01 AND ",
                       " (( rtj02 = '1' AND ",g_wc2,
                       ") OR (rtj02 = '2' AND ",g_wc3,
                       "))"
      ELSE
         LET l_table = l_table," ,rtj_file"
         LET l_where = l_where, " AND rtj01 = rti01 AND rtj02 = '1' AND ",g_wc2
      END IF 
   ELSE
      IF g_wc3 <> " 1=1" THEN
         LET l_table = l_table ," ,rtj_file"
         LET l_where = l_where ," AND rtj01 = rti01 AND rtj02 = '2' AND ",g_wc3
      END IF       
   END IF 

   IF g_wc4 <> " 1=1" THEN
      LET l_table = l_table,",ryn_file"
      LET l_where = l_where ," AND ryn01 = rti01 AND ",g_wc4
   END IF

   LET g_sql = g_sql,l_table,l_where," ORDER BY rti01"
 
   PREPARE t100_prepare FROM g_sql
   DECLARE t100_cs SCROLL CURSOR WITH HOLD FOR t100_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT rti01) ",l_table,l_where
   PREPARE t100_precount FROM g_sql
   DECLARE t100_count CURSOR FOR t100_precount
 
END FUNCTION
 
FUNCTION t100_menu()
   WHILE TRUE
      CALL t100_bp("G")

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t100_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t100_u('u')
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t100_b()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN 
               CALL t100_x()
            END IF    

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t100_copy() 
            END IF 

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_confirm() 
            END IF

         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t100_unconfirm() 
            END IF

          WHEN "ch_issued"
             IF cl_chk_act_auth() THEN
                CALL t100_ch()
             END IF   

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                            base.TypeInfo.create(g_rti),'','')
            END IF
 
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_rti.rti01 IS NOT NULL THEN
               LET g_doc.column1 = "rti01"
               LET g_doc.value1  = g_rti.rti01
               CALL cl_doc()
            END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> 'G' OR g_action_choice = "detail" THEN   #FUN-D30033 add
      RETURN    #FUN-D30033 add
   END IF       #FUN-D30033 add
   LET g_action_choice = NULL 
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rtj TO s_rtj.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b1 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '1'
            LET l_ac1 = 1
            EXIT DIALOG
         
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG   
      END DISPLAY  

      DISPLAY ARRAY g_rtj_1 TO s_rtj_1.* ATTRIBUTE(COUNT=g_rec_b2)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '2'
            LET l_ac2 = 1
            EXIT DIALOG
         
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac2 = ARR_CURR()
            EXIT DIALOG   
      END DISPLAY    

      DISPLAY ARRAY g_ryn TO s_ryn.* ATTRIBUTE(COUNT=g_rec_b3)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b3 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac3 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '3'
            LET l_ac3 = 1
            EXIT DIALOG
         
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '3'
            LET l_ac3 = ARR_CURR()
            EXIT DIALOG   
      END DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG

      #变更发出   
      ON ACTION ch_issued
         LET g_action_choice="ch_issued"
         EXIT DIALOG

      ON ACTION first
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION jump
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG 

      ON ACTION last
         CALL t100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG 

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG        
 
      ON ACTION close
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG   
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
      
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t100_a() 
   DEFINE li_result   LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   
   IF NOT s_data_center(g_plant) THEN RETURN END IF 
   MESSAGE ""

   #清空单头单身
   CLEAR FORM
   CALL g_rtj.clear()
   CALL g_rtj_1.clear()
   CALL g_ryn.clear()

   #初始化
   LET g_wc = NULL
   LET g_wc2= NULL
   LET g_wc3 = NULL
   LET g_wc4 = NULL

   INITIALIZE g_rti.* LIKE rti_file.*
   LET g_rti01_t = NULL
   LET g_rti_t.* = g_rti.*
   LET g_rti_o.* = g_rti.*
   CALL cl_opmsg('a')
  
   WHILE TRUE
      LET g_rti.rti02 = "1"
      LET g_rti.rticonf = "N"
      LET g_rti.rti900 = '0'
      LET g_rti.rtiplant = g_plant
      LET g_rti.rtiuser = g_user
      LET g_rti.rtigrup = g_grup
      LET g_rti.rtiacti = 'Y'
      LET g_rti.rtioriu = g_user
      LET g_rti.rtiorig = g_grup 
      LET g_rti.rtilegal = g_legal
   
      SELECT azp02 INTO l_azp02 
        FROM azp_file
       WHERE azp01 = g_rti.rtiplant

      DISPLAY l_azp02 TO FORMONLY.rtiplant_desc
      
      CALL t100_i("a")
      
      IF INT_FLAG THEN
         INITIALIZE g_rti.* TO NULL
         CALL g_rtj.clear()
         CALL g_rtj_1.clear()
         CALL g_ryn.clear()
         LET INT_FLAG = 0
         LET g_rti01_t = NULL  
         CALL cl_err('',9001,0)
         CLEAR FORM     
         RETURN      
      END IF

      #####自動編號########################
      CALL s_auto_assign_no("art",g_rti.rti01,g_today,'A1',"rti_file",
                            "rti01","","","") RETURNING li_result,g_rti.rti01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rti.rti01
      ###################################
 
      BEGIN WORK
      LET g_success = 'Y'
      INSERT INTO rti_file VALUES (g_rti.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","rti_file",g_rti.rti01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK 
         CONTINUE WHILE
      END IF

      CALL g_rtj.clear()
      CALL g_rtj_1.clear()
      CALL g_ryn.clear()
      
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0

      IF g_success = 'N' THEN
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         SELECT * INTO g_rti.*
           FROM rti_file
          WHERE rti01 = g_rti.rti01 
      END IF 
      CALL t100_b()
      EXIT WHILE
   END WHILE
   
END FUNCTION
 
FUNCTION t100_u(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rti.rti01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rti.*
     FROM rti_file
    WHERE rti01=g_rti.rti01

    IF g_rti.rtiplant <> g_plant THEN
      CALL cl_err(g_rti.rtiplant,'alm-399',0)
      RETURN
   END IF

   IF NOT cl_null(g_rti.rticonf) AND g_rti.rticonf !='N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rti01_t = g_rti.rti01
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_rti.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_date = g_rti.rtidate
   LET g_modu = g_rti.rtimodu
    
   IF p_cmd = 'c' THEN
      LET g_rti.rtimodu = NULL 
      LET g_rti.rtidate = g_today
      LET g_rti.rticonf = 'N'
      LET g_rti.rticond = NULL
      LET g_rti.rticonu = NULL
      LET g_rti.rti900 = '0'
   ELSE
      LET g_rti.rtimodu = g_user 
   END IF
  
   CALL t100_show()
   WHILE TRUE
      LET g_rti01_t = g_rti.rti01
      LET g_rti_o.* = g_rti.*
 
      CALL t100_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rti.*=g_rti_t.*
         LET g_rti_t.rtidate = g_date
         LET g_rti_t.rtimodu = g_modu
         CALL t100_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rti.rti01 != g_rti01_t THEN
         UPDATE rtj_file 
            SET rtj01 = g_rti.rti01
          WHERE rtj01 = g_rti01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rtj_file",g_rti01_t,"",
                                          SQLCA.sqlcode,"","rtj",1)
            CONTINUE WHILE
         END IF

         UPDATE ryn_file 
            SET ryn01 = g_rti.rti01
          WHERE ryn01 = g_rti01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ryn_file",g_rti01_t,"",
                                               SQLCA.sqlcode,"","ryn",1)
            CONTINUE WHILE
         END IF
         
         UPDATE ruh_file
            SET ruh01 = g_rti.rti01
          WHERE ruh01 = g_rti01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","ruh_file",g_rti01_t,"",
                                          SQLCA.sqlcode,"","rtj",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rti_file 
         SET rti_file.* = g_rti.*
       WHERE rti01 = g_rti01_t

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
         CALL cl_err3("upd","rti_file",g_rti01_t,"",
                                         SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF 
      EXIT WHILE 
   END WHILE
 
   CLOSE t100_cl
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF

   SELECT * INTO g_rti.*
     FROM rti_file
    WHERE rti01 = g_rti.rti01
    
   CALL t100_show()
   CALL t100_list_fill()
END FUNCTION
 
FUNCTION t100_i(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,
          l_date      LIKE type_file.dat,
          l_n         LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num10

   DISPLAY BY NAME g_rti.rti01,g_rti.rti02,g_rti.rti03,g_rti.rticonf,
                   g_rti.rticond,g_rti.rticonu,g_rti.rti900,g_rti.rtiplant,
                   g_rti.rti07,g_rti.rtiuser,g_rti.rtigrup,g_rti.rtioriu,
                   g_rti.rtimodu,g_rti.rtidate,g_rti.rtiorig,g_rti.rtiacti,
                   g_rti.rticrat

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_rti.rti01,g_rti.rti02,g_rti.rti03,g_rti.rticonf,
                   g_rti.rticond,g_rti.rticonu,g_rti.rti900,g_rti.rtiplant,
                   g_rti.rti07,g_rti.rtiuser,g_rti.rtigrup,g_rti.rtioriu,
                   g_rti.rtimodu,g_rti.rtidate,g_rti.rtiorig,g_rti.rtiacti,
                   g_rti.rticrat
                 WITHOUT DEFAULTS
                 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t100_set_entry(p_cmd)
         CALL t100_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD rti01
         IF NOT cl_null(g_rti.rti01) THEN
            IF (p_cmd = 'a' ) OR
               (p_cmd = 'u' AND g_rti.rti01 != g_rti_t.rti01) THEN
               CALL s_check_no("art",g_rti.rti01,g_rti01_t,"A1","rti_file",
                         "rti01","") RETURNING li_result,g_rti.rti01
               IF ( NOT li_result) THEN
                  LET g_rti.rti01 = g_rti_t.rti01
                  NEXT FIELD rti01
               END IF
               SELECT COUNT(*) INTO l_n 
                 FROM rti_file
                WHERE rti01 = g_rti.rti01 
                  AND rtiplant = g_rti.rtiplant
               IF l_n > 0 THEN
                  CALL cl_err('','art-049',0)
                  NEXT FIELD rti01 
               END IF    
            END IF 
         END IF

      AFTER FIELD rti02
         IF NOT cl_null(g_rti.rti02) THEN
            IF (p_cmd='a') OR (p_cmd='u' AND g_rti.rti02!=g_rti_t.rti02) THEN
               IF g_rti.rti02 = '1' THEN
                  CALL cl_set_comp_entry("rti03",FALSE)
                  CALL cl_set_comp_required("rti03",FALSE)
                  LET g_rti.rti03 = ''
                  DISPLAY BY NAME g_rti.rti03
               ELSE
                  CALL cl_set_comp_entry("rti03",TRUE)
                  CALL cl_set_comp_required("rti03",TRUE)
               END IF
            END IF
         END IF   

      ON CHANGE rti02
         IF g_rti.rti02 = '1' THEN
            CALL cl_set_comp_entry("rti03",FALSE)
            LET g_rti.rti03 = ''
            DISPLAY BY NAME g_rti.rti03
         ELSE
            CALL cl_set_comp_entry("rti03",TRUE)
         END IF
          
      BEFORE FIELD rti03
         IF cl_null(g_rti.rti02) THEN
            CALL cl_err('','alm1223',0)
            NEXT FIELD rti02
         END IF 

       AFTER FIELD rti03
          IF g_rti.rti02 = '2' THEN
             IF cl_null(g_rti.rti03) THEN
                CALL cl_err('','art-151',0)
                NEXT FIELD rti03
             END IF
          END IF   

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                               RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rti01)
                LET g_t1=s_get_doc_no(g_rti.rti01)
                CALL q_oay(FALSE,FALSE,g_t1,'A1','art') RETURNING g_t1       
                LET g_rti.rti01=g_t1
                DISPLAY BY NAME g_rti.rti01
                NEXT FIELD rti01
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
   END INPUT 
END FUNCTION
 
FUNCTION t100_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )

   INITIALIZE g_rti.* TO NULL
   INITIALIZE g_rti_t.* TO NULL
   INITIALIZE g_rti_o.* TO NULL
   LET g_rti01_t =NULL
   LET g_wc = NULL
   
   MESSAGE " "
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t100_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rti.* TO NULL
      LET g_rec_b1 = 0
      LET g_rec_b1 = 0
      LET g_rec_b1 = 0
      LET g_wc = NULL
      LET g_wc2 = NULL 
      LET g_wc3 = NULL
      LET g_wc4 = NULL 
      CALL g_rtj.clear()
      CALL g_rtj_1.clear()
      CALL g_ryn.clear()
      LET g_rti01_t = NULL
      RETURN
   END IF
 
   OPEN t100_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rti.* TO NULL
      LET g_wc = NULL
      LET g_rti01_t = NULL
   ELSE
      OPEN t100_count
      FETCH t100_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt 
      CALL t100_fetch('F')
   END IF 
END FUNCTION
 
FUNCTION t100_fetch(p_flag)
   DEFINE    p_flag  LIKE type_file.chr1 
   MESSAGE ''   

   CASE p_flag
      WHEN 'N' FETCH NEXT     t100_cs INTO g_rti.rti01
      WHEN 'P' FETCH PREVIOUS t100_cs INTO g_rti.rti01
      WHEN 'F' FETCH FIRST    t100_cs INTO g_rti.rti01
      WHEN 'L' FETCH LAST     t100_cs INTO g_rti.rti01
      WHEN '/'
         IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about
                   CALL cl_about()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION controlg
                   CALL cl_cmdask()
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump t100_cs INTO g_rti.rti01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      INITIALIZE g_rti.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_rti.* 
     FROM rti_file
    WHERE rti01 = g_rti.rti01
    
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rti_file",g_rti.rti01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rti.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rti.rtiuser
   LET g_data_group = g_rti.rtigrup
   LET g_data_plant = g_rti.rtiplant    
   CALL t100_show()
END FUNCTION
 
FUNCTION t100_show()
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_azp02    LIKE azp_file.azp02
   
   LET g_rti_t.* = g_rti.*
   LET g_rti_o.* = g_rti.*
   DISPLAY BY NAME g_rti.rti01,g_rti.rti02,g_rti.rti03,g_rti.rticonf,
                   g_rti.rticond,g_rti.rticonu,g_rti.rti900,g_rti.rtiplant,
                   g_rti.rti07,g_rti.rtiuser,g_rti.rtigrup,g_rti.rtioriu,
                   g_rti.rtimodu,g_rti.rtidate,g_rti.rtiorig,g_rti.rtiacti,
                   g_rti.rticrat
   SELECT gen02 INTO l_gen02 
     FROM gen_file
    WHERE gen01 = g_rti.rticonu
   DISPLAY l_gen02 TO FORMONLY.gen02

   SELECT azp02 INTO l_azp02
     FROM azp_file
    WHERE azp01 = g_rti.rtiplant
   DISPLAY l_azp02 TO FORMONLY.rtiplant_desc

   CALL t100_list_fill()
   CALL cl_show_fld_cont()
   CALL cl_set_field_pic(g_rti.rticonf,"","","","","")
END FUNCTION
  
FUNCTION t100_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rti.rti01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rti.* 
     FROM rti_file
    WHERE rti01=g_rti.rti01
 
   #不可異動其他門店資料
   IF g_rti.rtiplant <> g_plant THEN
      CALL cl_err(g_rti.rtiplant,'alm-399',0)
      RETURN
   END IF
 
   IF g_rti.rticonf = 'Y' THEN
      CALL cl_err('','abm-881',0)
      RETURN  
   END IF 

   IF g_rti.rticonf = 'X' THEN
      CALL cl_err('','abm-033',0)
      RETURN 
   END IF 

   MESSAGE ''
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_rti.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t100_show()
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL           
       LET g_doc.column1 = "rti01"          
       LET g_doc.value1  = g_rti.rti01           
       CALL cl_del_doc()  
       
      DELETE FROM rti_file WHERE rti01 = g_rti_t.rti01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rti_file",g_rti.rti01,"",SQLCA.SQLCODE,
                       "","(t100_r:delete rti)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM rtj_file WHERE rtj01 = g_rti_t.rti01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","rtj_file",g_rti.rti01,"",SQLCA.SQLCODE,
                       "","(t100_r:delete rtj)",1)
         LET g_success='N'
      END IF
      
      DELETE FROM ruh_file
            WHERE ruh01 = g_rti.rti01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ruh_file",g_rti.rti01,g_rti.rtiplant,
                               SQLCA.SQLCODE,"","(t100_r:delete ruh)",1)
         LET g_success='N'
      END IF  

      DELETE FROM ryn_file WHERE ryn01 = g_rti_t.rti01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","ryn_file",g_rti.rti01,"",SQLCA.SQLCODE,
                       "","(t100_r:delete ryn)",1)
         LET g_success='N'
      END IF 

      INITIALIZE g_rti.* TO NULL
  
      IF g_success = 'Y' THEN    
         COMMIT WORK
         CLEAR FORM
         
         LET g_rec_b1 = NULL
         LET g_rec_b2 = NULL
         LET g_rec_b3 = NULL
 
         CALL g_rtj.clear()
         CALL g_rtj_1.clear()
         CALL g_ryn.clear()
          
         OPEN t100_count
         IF STATUS THEN
            CLOSE t100_cs
            CLOSE t100_count
            COMMIT WORK
            RETURN
         END IF
      
         FETCH t100_count INTO g_row_count
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t100_cs
            CLOSE t100_count
            COMMIT WORK
            RETURN
         END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         
         OPEN t100_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t100_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t100_fetch('/')
         END IF
      ELSE  
         ROLLBACK WORK
         LET g_rti.* = g_rti_t.*
      END IF   
   END IF
 
   CLOSE t100_cl
   COMMIT WORK
   CALL t100_show()
END FUNCTION

FUNCTION t100_x()
   IF s_shut(0) THEN                                                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF g_rti.rti01 IS NULL OR g_rti.rtiplant IS NULL THEN                                                                                                      
      CALL cl_err("",-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF
   
   IF g_rti.rticonf = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF  
   
   IF g_rti.rticonf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   
   IF NOT s_data_center(g_plant) THEN 
      RETURN 
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'   
   OPEN t100_cl USING g_rti.rti01                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN t100_cl:", STATUS, 1)                                                                                       
      CLOSE t100_cl       
      ROLLBACK WORK                                                                                                          
      RETURN                                                                                                                        
   END IF
   
   FETCH t100_cl INTO g_rti.*                                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)                                                                                      
      RETURN                                                                                                                        
   END IF
   
   CALL t100_show()
   
   IF g_rti.rticonf = 'Y' THEN                                                                                                      
      CALL cl_err('','art-022',0)                                                                                                   
      RETURN                                                                                                                        
   END IF
 
   IF cl_exp(0,0,g_rti.rtiacti) THEN                                                                                                
      LET g_chr=g_rti.rtiacti                                                                                                       
      IF g_rti.rtiacti='Y' THEN                                                                                                     
         LET g_rti.rtiacti='N'                                                                                                      
      ELSE                                                                                                                          
         LET g_rti.rtiacti='Y'                                                                                                      
      END IF                                                                                                                        
                                                                                                                                    
      UPDATE rti_file 
         SET rtiacti=g_rti.rtiacti,                                                                                    
             rtimodu=g_user,                                                                                           
             rtidate=g_today                                                                                           
       WHERE rti01=g_rti.rti01                                                                                                     
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                   
         CALL cl_err3("upd","rti_file",g_rti.rti01,"",SQLCA.sqlcode,"","",1)                                         
         LET g_rti.rtiacti=g_chr                                                                                                    
      END IF                                                                                                                        
   END IF
 
   CLOSE t100_cl                                                                                                                    
                                                                                                                                    
   IF g_success = 'Y' THEN                                                                                                          
      COMMIT WORK                                                                                                                   
      CALL cl_flow_notify(g_rti.rti01,'V')                                                                                          
   ELSE                                                                                                                             
      ROLLBACK WORK                                                                                                                 
   END IF                                                                                                                           
                                                                                                                                    
   SELECT rtiacti,rtimodu,rtidate                                                                                                   
     INTO g_rti.rtiacti,g_rti.rtimodu,g_rti.rtidate
     FROM rti_file                                                                   
    WHERE rti01=g_rti.rti01                                                                                                       
   DISPLAY BY NAME g_rti.rtiacti,g_rti.rtimodu,g_rti.rtidate
END FUNCTION 

FUNCTION t100_copy()
   DEFINE l_n                LIKE type_file.num5
   DEFINE l_rti              RECORD LIKE rti_file.*
   DEFINE l_oldno1,l_newno   LIKE rti_file.rti01
   DEFINE l_oldno            LIKE rti_file.rti01
   DEFINE l_old_plant        LIKE rti_file.rtiplant
   DEFINE li_result          LIKE type_file.num5
  
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_rti.rti01 IS NULL OR g_rti.rti02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   IF NOT s_data_center(g_plant) THEN
      RETURN
   END IF
  
   LET l_oldno = g_rti.rti01
   LET l_old_plant = g_rti.rtiplant
 
   LET g_before_input_done = FALSE
   CALL t100_set_entry('a')
   CALL cl_set_head_visible("","YES")
   
   INPUT l_newno FROM rti01
      AFTER FIELD rti01
         IF cl_null(l_newno) THEN
            NEXT FIELD rti01
         ELSE
            CALL s_check_no("art",l_newno,"","A1","rti_file",
                             "rti01,rtiplant","") RETURNING li_result,l_newno
            IF (NOT li_result) THEN                                                                                            
               LET g_rti.rti01=g_rti_t.rti01                                                                                   
               NEXT FIELD rti01                                                                                                
            END IF
            BEGIN WORK
            CALL s_auto_assign_no("art",l_newno,g_today,"A1","rti_file",
                                   "rti01","","","") RETURNING li_result,l_newno                                                                                        
            IF (NOT li_result) THEN
               ROLLBACK WORK                                                                                   
               NEXT FIELD rti01
            ELSE
               COMMIT WORK                                                                                               
            END IF                                                                                                          
            DISPLAY l_newno TO rti01
         END IF
   
      ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(rti01)                                                                                                    
                LET g_t1=s_get_doc_no(l_newno)                                                                                  
                CALL q_oay(FALSE,FALSE,g_t1,'A1','art') RETURNING g_t1                                                        
                LET l_newno = g_t1                                                                                                
                DISPLAY l_newno TO rti01                                                                                       
                NEXT FIELD rti01                                                                                                    
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
  
      ON ACTION about
         CALL cl_about()
  
      ON ACTION HELP
         CALL cl_show_help()
  
      ON ACTION controlg
         CALL cl_cmdask()
  
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rti.rti01,g_rti.rti02
      RETURN
   END IF
   
   BEGIN WORK
   
   DROP TABLE rti_temp
   SELECT * FROM rti_file
    WHERE rti01=g_rti.rti01
     INTO TEMP rti_temp
   UPDATE rti_temp
      SET rti01 =l_newno,     #策略变更单号
          rti900 = '0',       #状况码
          rticonf ='N',       #审核码
          rticond=NULL,       #审核日期
          rticonu=NULL,       #审核人 
          rtiuser=g_user,     #资料所有者
          rtigrup=g_grup,     #资料所有部门
          rtioriu=g_user,     #资料建立者
          rtiorig=g_grup,     #资料建立部门
          rtimodu=NULL,       #资料更改者
          rtidate=NULL,       #最近更改日
          rticrat=g_today,    #资料创建日
          rtiacti='Y',        #资料有效码
          rtiplant = g_plant, #所属营运中心
          rtilegal = g_legal  #法人
          
   INSERT INTO rti_file SELECT * FROM rti_temp
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","rti_file",l_newno,'',SQLCA.SQLCODE,"","ins rti:",1)  
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
  
   DROP TABLE rtj_temp
   SELECT * FROM rtj_file     
    WHERE rtj01=g_rti.rti01   
    INTO TEMP rtj_temp
    
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg=g_rti.rti01 CLIPPED,'+',g_rti.rti02 CLIPPED
      CALL cl_err3("ins","rtj_temp",g_rti.rti01,g_rti.rtiplant,SQLCA.SQLCODE,"",g_msg,1)  
      RETURN
   END IF
   UPDATE rtj_temp
      SET rtj01 = l_newno,
          rtjplant = g_plant,
          rtjlegal = g_legal
   INSERT INTO rtj_file SELECT * FROM rtj_temp
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_msg=g_rti.rti01 CLIPPED,'+',g_rti.rti02 CLIPPED
      CALL cl_err3("ins","rtj_file",g_rti.rti01,g_rti.rti02,SQLCA.SQLCODE,"",g_msg,1) 
      ROLLBACK WORK
      RETURN
   END IF
   
   LET g_msg=l_newno CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'

   DROP TABLE ruh_temp
   SELECT * FROM ruh_file
    WHERE ruh01 = g_rti.rti01 INTO TEMP ruh_temp
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruh_temp","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   UPDATE ruh_temp SET ruh01 = l_newno
   INSERT INTO ruh_file
      SELECT * FROM ruh_temp
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruh_file","","",SQLCA.sqlcode,"","g_msg",1)
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE ryn_temp
   SELECT * FROM ryn_file
    WHERE ryn01=g_rti.rti01
     INTO TEMP ryn_temp
   IF SQLCA.SQLCODE THEN
      LET g_msg=g_rti.rti01 CLIPPED,'+',g_rti.rtiplant CLIPPED
      CALL cl_err3("ins","ryn_temp",g_rti.rti01,g_rti.rti02,SQLCA.SQLCODE,"",g_msg,1)
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE ryn_temp
      SET ryn01 = l_newno,
          rynplant= g_plant,
          rynlegal = g_legal
   INSERT INTO ryn_file SELECT * FROM ryn_temp
   
   IF SQLCA.SQLCODE THEN
      LET g_msg=g_rti.rti01 CLIPPED,'+',g_rti.rti02 CLIPPED
      CALL cl_err3("ins","ryn_file",l_newno,'',SQLCA.SQLCODE,"",g_msg,1)
      ROLLBACK WORK
      RETURN
   END IF

   COMMIT WORK
   SELECT rti_file.* INTO g_rti.* 
     FROM rti_file
    WHERE rti01 = l_newno 
      AND rtiplant = g_plant
      
   CALL t100_u('c')
   CALL t100_b()
   #FUN-C80046
   #SELECT rti_file.* INTO g_rti.* 
   #  FROM rti_file 
   # WHERE rti01 = l_oldno 
   #   AND rtiplant = l_old_plant
   #CALL t100_show()
   #FUN-C80046
END FUNCTION
 
FUNCTION t100_list_fill()

  #TQC-C20070 Add Begin ---
   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1" END IF
   IF cl_null(g_wc4) THEN LET g_wc4 = " 1=1" END IF
  #TQC-C20070 Add End -----

   LET g_sql = " SELECT rtj24,rtj03,rtj04,'',rtj21,'',rtj06,rtj07,rtj08,rtj20 ",
               "   FROM rtj_file ",
               "  WHERE rtj01 = '",g_rti.rti01,"'",
               "    AND rtj02 = '1'",
               "    AND ", g_wc2,
               "  ORDER BY rtj24"
   PREPARE t100_prepare1 FROM g_sql
   DECLARE t100_pb1 CURSOR FOR t100_prepare1

   LET g_sql = " SELECT rtj24,rtj03,rtj04,'',rtj09,'',rtj10,rtj11,rtj12,rtj13 ,",
               #"        rtj14,rtj15,rtj16,rtj17,rtj18,rtj19,rtj23,rtj20",                  #FUN-C50036 mark
               "        rtj14,rtj15,rtj16,rtj17,rtj18,rtj25,rtj19,rtj23,rtj20",             #FUN-C50036 add
               "   FROM rtj_file ",
               "  WHERE rtj01 = '",g_rti.rti01,"'",
               "    AND rtj02 = '2'", 
               "    AND ", g_wc3,
               "  ORDER BY rtj24"
   PREPARE t100_prepare2 FROM g_sql
   DECLARE t100_pb2 CURSOR FOR t100_prepare2

   LET g_sql = " SELECT ryn02,ryn03,'',ryn04,'',ryn05,ryn06,'',ryn07,ryn08,",
               "        ryn09,ryn10,ryn11,ryn12,ryn13,ryn15,'',ryn14",
               "   FROM ryn_file ",
               "  WHERE ryn01 = '",g_rti.rti01,"'",
               "    AND ", g_wc4,
               "  ORDER BY ryn03"
   PREPARE t100_prepare3 FROM g_sql
   DECLARE t100_pb3 CURSOR FOR t100_prepare3

   CALL g_rtj.clear()
   LET g_cnt = 1
   FOREACH t100_pb1 INTO g_rtj[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT ima02 INTO g_rtj[g_cnt].rtj04_desc
         FROM ima_file
        WHERE ima01 = g_rtj[g_cnt].rtj04

       SELECT gec02 INTO g_rtj[g_cnt].rtj21_desc
         FROM gec_file
        WHERE gec01 = g_rtj[g_cnt].rtj21
          AND gec011= '2'
          
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rtj.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn2

   CALL g_rtj_1.clear()
   LET g_cnt = 1
   FOREACH t100_pb2 INTO g_rtj_1[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT ima02 INTO g_rtj_1[g_cnt].rtj04_desc1
         FROM ima_file
        WHERE ima01 = g_rtj_1[g_cnt].rtj04_1

       SELECT gfe02 INTO g_rtj_1[g_cnt].rtj09_desc
         FROM gfe_file
        WHERE gfe01 = g_rtj_1[g_cnt].rtj09
          
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rtj_1.deleteElement(g_cnt)
 
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2

   CALL g_ryn.clear()
   LET g_cnt = 1
   FOREACH t100_pb3 INTO g_ryn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       
       SELECT azp02 INTO g_ryn[g_cnt].ryn03_desc
         FROM azp_file
        WHERE azp01 = g_ryn[g_cnt].ryn03
        
       SELECT ima02 INTO g_ryn[g_cnt].ryn04_desc
         FROM ima_file
        WHERE ima01 = g_ryn[g_cnt].ryn04

        SELECT geu02 INTO g_ryn[g_cnt].ryn06_desc
          FROM geu_file 
         WHERE geu01 = g_ryn[g_cnt].ryn06
           AND geu00 = '8'

       SELECT geu02 INTO g_ryn[g_cnt].ryn15_desc
          FROM geu_file 
         WHERE geu01 = g_ryn[g_cnt].ryn15
           AND geu00 = '4'    
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ryn.deleteElement(g_cnt)
 
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION

FUNCTION t100_b()
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_lock_sw       LIKE type_file.chr1
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_lock_sw       LIKE type_file.chr1   
   DEFINE l_fac           LIKE type_file.num20_6   
   DEFINE l_ac1_t         LIKE type_file.num10
   DEFINE l_ac2_t         LIKE type_file.num10
   DEFINE l_ac3_t         LIKE type_file.num10 
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_rtz05         LIKE rtz_file.rtz05   
   DEFINE l_flowno        LIKE poz_file.poz01

   IF s_shut(0) THEN RETURN END IF

   IF g_rti.rti01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_action_choice = ""
   
   IF cl_null(g_rti.rti01) THEN 
      RETURN 
   END IF

   IF cl_null(g_rti.rti01) OR cl_null(g_rti.rtiplant) THEN 
       RETURN 
   END IF 
   
   SELECT * INTO g_rti.* 
     FROM rti_file
    WHERE rti01 = g_rti.rti01

   IF g_rti.rticonf = 'Y' THEN 
      CALL cl_err('','art-024',0)
      RETURN 
   END IF  

   IF g_rti.rtiacti = 'N' THEN 
       CALL cl_err('','alm1499',0)
       RETURN 
   END IF 

   SELECT rtz05 INTO l_rtz05 
     FROM rtz_file 
    WHERE rtz01 = g_rti.rtiplant

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT rtj24,rtj03,rtj04,'',rtj21,'',rtj06,rtj07,rtj08,rtj20 ", 
                      "  FROM rtj_file ",
                      " WHERE rtj01=? AND rtj02='1' ",
                      "   AND rtj03=? ",
                      " FOR UPDATE   "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_bc1 CURSOR FROM g_forupd_sql 

   LET g_forupd_sql ="SELECT rtj24,rtj03,rtj04,'',rtj09,'',rtj10,rtj11,rtj12,rtj13,", 
                     #"       rtj14,rtj15,rtj16,rtj17,rtj18,rtj19,rtj23,rtj20",        #FUN-C50036 mark
                     "       rtj14,rtj15,rtj16,rtj17,rtj18,rtj25,rtj19,rtj23,rtj20",   #FUN-C50036 add         
                     "  FROM rtj_file ",
                     " WHERE rtj01=? AND rtj02='2' ",
                     "   AND rtj03=? ",
                     " FOR UPDATE   "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_bc2 CURSOR FROM g_forupd_sql
   
   LET g_forupd_sql =" SELECT ryn02,ryn03,'',ryn04,'',ryn05,ryn06,'',ryn07,",
                     "      ryn08,ryn09,ryn10,ryn11,ryn12,ryn13,ryn15,'',ryn14",
                     "  FROM ryn_file ",
                     " WHERE ryn01= ? ",
                     "   AND ryn03=? ",
                     "   AND ryn04=? ",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_bc3 CURSOR FROM g_forupd_sql 

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   IF g_rec_b1 > 0 THEN LET l_ac1 = 1 END IF   #FUND-30033 add
   IF g_rec_b2 > 0 THEN LET l_ac2 = 1 END IF   #FUND-30033 add
   IF g_rec_b3 > 0 THEN LET l_ac3 = 1 END IF   #FUND-30033 add

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT ARRAY g_rtj FROM s_rtj.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
            LET g_flag_b = '1' #FUND-30033 add
 
         BEFORE ROW
            LET p_cmd=''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'           
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t100_cl USING g_rti.rti01
            IF STATUS THEN
               CALL cl_err("OPEN t100_cl:", STATUS, 1)
               CLOSE t100_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t100_cl INTO g_rti.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_rti.rti01,SQLCA.SQLCODE,0)
               CLOSE t100_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b1>=l_ac1 THEN
               LET p_cmd='u'
               LET g_cmd = p_cmd              
               LET g_rtj_t.* = g_rtj[l_ac1].*  
               LET l_lock_sw = 'N'             
               OPEN t100_bc1 USING g_rti.rti01,g_rtj_t.rtj03
               IF STATUS THEN
                  CALL cl_err("OPEN t100_bc1:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t100_bc1 INTO g_rtj[l_ac1].*
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err(g_rtj_t.rtj03,SQLCA.SQLCODE , 1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT gec02 INTO g_rtj[l_ac1].rtj21_desc FROM gec_file        
                   WHERE  gec01 = g_rtj[l_ac1].rtj21 AND gec011 = '2'            
               END IF
               CALL t100_rtj04(g_rtj[l_ac1].rtj04,'d','1')
               CALL cl_show_fld_cont()
            END IF
 
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            BEGIN WORK                
            LET p_cmd='a'
            LET g_cmd = p_cmd        
            INITIALIZE g_rtj[l_ac1].* TO NULL
            LET g_rtj_t.* = g_rtj[l_ac1].*
            LET g_rtj[l_ac1].rtj06 = 'Y'
            LET g_rtj[l_ac1].rtj07 = 'Y'
            LET g_rtj[l_ac1].rtj08 = 'Y'
            LET g_rtj[l_ac1].rtj20 = 'Y'
            IF p_cmd = 'a' THEN
               SELECT MAX(rtj03)+1 INTO g_rtj[l_ac1].rtj03
                 FROM rtj_file
                WHERE rtj01 = g_rti.rti01
                  AND rtj02 = '1'
               IF cl_null(g_rtj[l_ac1].rtj03) THEN
                  LET g_rtj[l_ac1].rtj03 = 1
               END IF
            END IF
            CALL cl_show_fld_cont()
            NEXT FIELD rtj24

 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            INSERT INTO rtj_file(rtj01,rtj02,rtj03,rtj04,rtj05,rtj06,rtj07,rtj08,
                                 rtj20,rtjplant,rtjlegal,rtj21,rtj22,rtj24)
                #VALUES(g_rti.rti01,'1',g_rtj[l_ac1].rtj03,g_rtj[l_ac1].rtj04,'1',     #TQC-C20070 Mark
                 VALUES(g_rti.rti01,'1',g_rtj[l_ac1].rtj03,g_rtj[l_ac1].rtj04,g_rtj05, #TQC-C20070 Add
                        g_rtj[l_ac1].rtj06,g_rtj[l_ac1].rtj07,g_rtj[l_ac1].rtj08,
                        g_rtj[l_ac1].rtj20,g_rti.rtiplant,g_rti.rtilegal,
                        g_rtj[l_ac1].rtj21,'2',g_rtj[l_ac1].rtj24)      

            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rtj_file",g_rti.rti01,g_rti.rtiplant,
                             SQLCA.SQLCODE,"","",1)
                ROLLBACK WORK             
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b1=g_rec_b1+1   
            END IF        
 
         AFTER FIELD rtj24
            IF NOT cl_null(g_rtj[l_ac1].rtj24) THEN
               IF NOT cl_null(g_rtj[l_ac1].rtj04) THEN 
                  IF p_cmd = 'a' OR 
                     (p_cmd = 'u' AND g_rtj[l_ac1].rtj24 <> g_rtj_t.rtj24) THEN 
                     CALL t100_rtj24(g_rtj[l_ac1].rtj24,g_rtj[l_ac1].rtj04,'1')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0) 
                        LET g_rtj[l_ac1].rtj24 = g_rtj_t.rtj24
                        NEXT FIELD rtj24 
                     END IF
                     IF NOT cl_null(g_rtj[l_ac1].rtj04) THEN
                        SELECT count(*) INTO l_n
                          FROM rtj_file
                         WHERE rtj01 = g_rti.rti01 AND rtj02 = '1'
                           AND rtj04 = g_rtj[l_ac1].rtj04
                           AND rtj24 = g_rtj[l_ac1].rtj24
                        IF l_n > 0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtj[l_ac1].rtj24 = g_rtj_t.rtj24
                           NEXT FIELD rtj24
                        END IF
                       #TQC-C20070 Add Begin ---
                        LET l_n = 0 
                        SELECT COUNT(*) INTO l_n FROM rte_file WHERE rte01 = g_rtj[l_ac1].rtj24 AND rte03 = g_rtj[l_ac1].rtj04
                        IF l_n > 0 THEN
                           LET g_rtj05 = '2'
                        ELSE
                           LET g_rtj05 = '1'
                        END IF
                       #TQC-C20070 Add End -----
                     END IF
                  END IF 
               END IF
               CALL t100_rtj24_1(g_rtj[l_ac1].rtj24,'1')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  LET g_rtj[l_ac1].rtj24 = g_rtj_t.rtj24
                  NEXT FIELD rtj24
               END IF     
            END IF 
 
         AFTER FIELD rtj04
            IF NOT cl_null(g_rtj[l_ac1].rtj04) THEN
               IF g_rtj[l_ac1].rtj04 != g_rtj_t.rtj04 OR
                  g_rtj_t.rtj04 IS NULL THEN
                  CALL t100_rtj04(g_rtj[l_ac1].rtj04,p_cmd,'1')  
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rtj04
                  END IF
                  CALL t100_check_shop()  
                  IF NOT cl_null(g_errno) THEN                                                                                       
                     CALL cl_err('',g_errno,0)                                                                                       
                     NEXT FIELD rtj04                                                                                                
                  END IF
                  IF NOT cl_null(g_rtj[l_ac1].rtj24) THEN
                     SELECT count(*) INTO l_n
                       FROM rtj_file
                      WHERE rtj01 = g_rti.rti01 AND rtj02 = '1'
                        AND rtj04 = g_rtj[l_ac1].rtj04
                        AND rtj24 = g_rtj[l_ac1].rtj24
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_rtj[l_ac1].rtj04 = g_rtj_t.rtj04
                        NEXT FIELD rtj04
                     END IF
                    #TQC-C20070 Add Begin ---
                     LET l_n = 0 
                     SELECT COUNT(*) INTO l_n FROM rte_file WHERE rte01 = g_rtj[l_ac1].rtj24 AND rte03 = g_rtj[l_ac1].rtj04
                     IF l_n > 0 THEN
                        LET g_rtj05 = '2'
                     ELSE
                        LET g_rtj05 = '1'
                     END IF
                    #TQC-C20070 Add End -----
                  END IF
                 #TQC-C30076 add START
                  CALL t100_chk_rtj21(g_rtj[l_ac1].rtj03,g_rtj[l_ac1].rtj04,g_rtj[l_ac1].rtj21,0)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD rtj04
                  END IF
                 #TQC-C30076 add END
               END IF
               IF NOT cl_null(g_rtj[l_ac1].rtj24) THEN
                  IF p_cmd = 'a' OR 
                    (p_cmd = 'u' AND g_rtj[l_ac1].rtj24 <> g_rtj_t.rtj24) THEN 
                     CALL t100_rtj24(g_rtj[l_ac1].rtj24,g_rtj[l_ac1].rtj04,'1')   
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_rtj[l_ac1].rtj04 = g_rtj_t.rtj04
                        NEXT FIELD rtj04 
                     END IF 
                  END IF 
               END IF 
            END IF

         AFTER FIELD rtj21
            IF NOT cl_null(g_rtj[l_ac1].rtj21) THEN
               IF p_cmd = 'a' THEN 
                 #TQC-C30076 add START
                  CALL t100_chk_rtj21(g_rtj[l_ac1].rtj03,g_rtj[l_ac1].rtj04,g_rtj[l_ac1].rtj21,0)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD rtj21
                  END IF
                 #TQC-C30076 add END
                  CALL t100_rtj21()
                 #FUN-C30306 mark START
                 #IF l_flag = 'Y' THEN
                 #   CALL artt100_a('Y')
                 #END IF
                 #FUN-C30306 mark END
                  IF NOT cl_null(g_errno) THEN
                     NEXT FIELD rtj21 
                  ELSE
                     LET g_rtj_t.rtj21 = g_rtj[l_ac1].rtj21 
                  END IF
               ELSE
                  IF g_rtj[l_ac1].rtj21 <> g_rtj_t.rtj21 THEN
                    #TQC-C30076 add START
                     CALL t100_chk_rtj21(g_rtj[l_ac1].rtj03,g_rtj[l_ac1].rtj04,g_rtj[l_ac1].rtj21,0)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_errno = ' '
                        NEXT FIELD rtj21
                     END IF
                    #TQC-C30076 add END
                     CALL t100_rtj21()
                    #FUN-C30306 mark START
                    #IF l_flag = 'Y' THEN
                    #   CALL artt100_a('Y')     #维护多税种
                    #END IF
                    #FUN-C30306 mark END
                     IF NOT cl_null(g_errno) THEN
                        NEXT FIELD rtj21 
                     END IF
                  END IF
               END IF
            END IF
 
         BEFORE DELETE
            IF g_rtj_t.rtj03 > 0 AND g_rtj_t.rtj03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM rtj_file
                WHERE rtj01 = g_rti.rti01 AND rtj02 = '1'
                  AND rtj03 = g_rtj_t.rtj03

               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","rtj_file",g_rti.rti01,
                               g_rti.rti02,SQLCA.SQLCODE,"","",1) 
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF

               DELETE FROM ruh_file
                WHERE ruh01 = g_rti.rti01 AND ruh02 = g_rtj_t.rtj03
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","ruh_file",g_rti.rti01,g_rtj_t.rtj03,SQLCA.SQLCODE,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF           
            END IF
            LET g_rec_b1 = g_rec_b1-1
            COMMIT WORK
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rtj[l_ac1].* = g_rtj_t.*
               CLOSE t100_bc1
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rtj[l_ac1].rtj03,-263,1)
               LET g_rtj[l_ac1].* = g_rtj_t.*
            ELSE
               UPDATE rtj_file
                  SET rtj24 = g_rtj[l_ac1].rtj24,
                      rtj04 = g_rtj[l_ac1].rtj04,
                      rtj21 = g_rtj[l_ac1].rtj21,                 
                      rtj05 = g_rtj05,                 #TQC-C20070 Add
                      rtj06 = g_rtj[l_ac1].rtj06,
                      rtj07 = g_rtj[l_ac1].rtj07,
                      rtj08 = g_rtj[l_ac1].rtj08,
                      rtj20 = g_rtj[l_ac1].rtj20
                WHERE rtj01=g_rti.rti01 
                  AND rtj02='1'
                  AND rtj03=g_rtj_t.rtj03
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","rtj_file",g_rti.rti01,g_rti.rtiplant,
                               SQLCA.SQLCODE,"","",1)
                  LET g_rtj[l_ac1].* = g_rtj_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
         AFTER ROW
            LET l_ac1 = ARR_CURR()
            LET l_ac1_t = l_ac1
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_rtj[l_ac1].* = g_rtj_t.*
               END IF
               CLOSE t100_bc1
               ROLLBACK WORK
               CONTINUE DIALOG 
            END IF
            CLOSE t100_bc1
            COMMIT WORK
 
         ON ACTION controlp
            CASE
               WHEN INFIELD (rtj24)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rtd01"
                  LET g_qryparam.where = " rtd03 = '",g_plant,"' "
                  LET g_qryparam.default1 = g_rtj[l_ac1].rtj24
                  CALL cl_create_qry() RETURNING g_rtj[l_ac1].rtj24
                  DISPLAY BY NAME g_rtj[l_ac1].rtj24                   
                  NEXT FIELD rtj24 
                  
               WHEN INFIELD(rtj04)
                  CALL q_sel_ima(FALSE, "q_ima01","",g_rtj[l_ac1].rtj04,"","","","","",'' )         
                     RETURNING g_rtj[l_ac1].rtj04  
                  DISPLAY g_rtj[l_ac1].rtj04 TO rtj04
                  NEXT FIELD rtj04

               WHEN INFIELD(rtj21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gec011"
                  LET g_qryparam.default1 = g_rtj[l_ac1].rtj21
                  CALL cl_create_qry() RETURNING g_rtj[l_ac1].rtj21
                  DISPLAY BY NAME g_rtj[l_ac1].rtj21                   
                  NEXT FIELD rtj21                
 
            END CASE

         ON ACTION product_strategy
            CALL t100_product()
            CALL t100_list_fill()
           #CONTINUE DIALOG #TQC-C20070 Mark
           #TQC-C20270 Add Begin ---
            LET g_flag_b = '1'
            CALL t100_b()
           #TQC-C20270 Add End -----
            EXIT DIALOG     #TQC-C20070 Add
    
         ON ACTION tax_detail
            CALL artt100_a('Y')  
      END INPUT
    
      INPUT ARRAY g_rtj_1 FROM s_rtj_1.*
            ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)
   
         BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2) 
               LET l_ac2 = 1
            END IF
            LET g_flag_b = '2' #FUND-30033 add

         BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'           
            LET l_n  = ARR_COUNT()
            CALL cl_set_comp_entry("rtj19",TRUE)
            BEGIN WORK

            OPEN t100_cl USING g_rti.rti01
            IF STATUS THEN
               CALL cl_err("OPEN t100_cl:", STATUS, 1)
               CLOSE t100_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t100_cl INTO g_rti.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_rti.rti01,SQLCA.SQLCODE,0)
               ROLLBACK WORK
               RETURN
            END IF
            
            IF g_rec_b2>=l_ac2 THEN
               LET g_rtj_1_t.* = g_rtj_1[l_ac2].*  
               LET p_cmd='u'
               OPEN t100_bc2 USING g_rti.rti01,g_rtj_1[l_ac2].rtj03_1
               IF STATUS THEN
                  CALL cl_err("OPEN t100_bc2:", STATUS, 1)
                  CLOSE t100_bc2
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t100_bc2 INTO g_rtj_1[l_ac2].*
               IF SQLCA.SQLCODE THEN
                   CALL cl_err(g_rtj_1_t.rtj03_1,SQLCA.SQLCODE,1)
                   LET l_lock_sw = "Y"
               END IF
               CALL t100_rtj04(g_rtj_1[l_ac2].rtj04_1,'d','2')
               CALL t100_rtj09()
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rtj_1[l_ac2].* TO NULL
            LET g_rtj_1_t.* = g_rtj_1[l_ac2].*
            LET g_rtj_1[l_ac2].rtj19 = 'N'
            LET g_rtj_1[l_ac2].rtj23 = 'N' 
            LET g_rtj_1[l_ac2].rtj20 = 'Y'
            IF p_cmd = 'a' THEN
               SELECT MAX(rtj03)+1 INTO g_rtj_1[l_ac2].rtj03_1
                 FROM rtj_file
                WHERE rtj01 = g_rti.rti01
                  AND rtj02 = '2'
               IF cl_null(g_rtj_1[l_ac2].rtj03_1) THEN
                  LET g_rtj_1[l_ac2].rtj03_1 = 1
               END IF
            END IF
            CALL cl_show_fld_cont()
            NEXT FIELD rtj24_1

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #FUN-C80076 add sta
            IF cl_null(g_rtj_1[l_ac2].rtj25) THEN 
               LET g_rtj_1[l_ac2].rtj25 = 0
            END IF 
            #FUN-C80076 add end
            INSERT INTO rtj_file(rtj01,rtj02,rtj03,rtj04,rtj05,rtj09,rtj10,rtj11, 
                                 #rtj12,rtj13,rtj14,rtj15,rtj16,rtj17,rtj18,        #FUN-C50036 mark
                                 rtj12,rtj13,rtj14,rtj15,rtj16,rtj17,rtj18,rtj25,   #FUN-C50036 add           
                                 rtj19,rtj23,rtj20,rtj24,rtjplant,rtjlegal,rtj22)
                VALUES(g_rti.rti01,'2',g_rtj_1[l_ac2].rtj03_1,g_rtj_1[l_ac2].rtj04_1,
                      #'1',g_rtj_1[l_ac2].rtj09,g_rtj_1[l_ac2].rtj10,     #TQC-C20070 Mark
                       g_rtj05,g_rtj_1[l_ac2].rtj09,g_rtj_1[l_ac2].rtj10, #TQC-C20070 Add 
                       g_rtj_1[l_ac2].rtj11,g_rtj_1[l_ac2].rtj12,
                       g_rtj_1[l_ac2].rtj13,g_rtj_1[l_ac2].rtj14,
                       g_rtj_1[l_ac2].rtj15,g_rtj_1[l_ac2].rtj16,
                       g_rtj_1[l_ac2].rtj17,g_rtj_1[l_ac2].rtj18,
                       g_rtj_1[l_ac2].rtj25,                                         #FUN-C50036 add     
                       g_rtj_1[l_ac2].rtj19,g_rtj_1[l_ac2].rtj23,          
                       g_rtj_1[l_ac2].rtj20,g_rtj_1[l_ac2].rtj24_1,
                       g_rti.rtiplant,g_rti.rtilegal,'2')
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rtj_file",g_rti.rti01,g_rti.rtiplant,
                                                         SQLCA.SQLCODE,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b2=g_rec_b2+1
            END IF

         AFTER FIELD rtj24_1
            IF NOT cl_null(g_rtj_1[l_ac2].rtj24_1) THEN 
               IF NOT cl_null(g_rtj_1[l_ac2].rtj04_1) THEN
                  IF p_cmd = 'a' OR 
                     (p_cmd = 'u' AND g_rtj_1[l_ac2].rtj24_1 <> g_rtj_1_t.rtj24_1) THEN  
                     CALL t100_rtj24(g_rtj_1[l_ac2].rtj24_1,g_rtj_1[l_ac2].rtj04_1,'2')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_rtj_1[l_ac2].rtj24_1 = g_rtj_1_t.rtj24_1
                        NEXT FIELD rtj24_1 
                     END IF
                     IF NOT cl_null(g_rtj_1[l_ac2].rtj24_1) THEN
                        SELECT count(*) INTO l_n
                          FROM rtj_file
                         WHERE rtj01 = g_rti.rti01 AND rtj02 = '2'
                           AND rtj04 = g_rtj_1[l_ac2].rtj04_1
                           AND rtj24 = g_rtj_1[l_ac2].rtj24_1
                        IF l_n > 0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtj_1[l_ac2].rtj24_1 = g_rtj_1_t.rtj24_1
                           NEXT FIELD rtj24_1
                        END IF
                     END IF
                    #TQC-C20070 Add Begin ---
                     IF NOT cl_null(g_rtj_1[l_ac2].rtj09) THEN
                        LET l_n = 0 
                        SELECT COUNT(*) INTO l_n 
                          FROM rtg_file 
                         WHERE rtg01 = g_rtj_1[l_ac2].rtj24_1 
                           AND rtg03 = g_rtj_1[l_ac2].rtj04_1
                           AND rtg04 = g_rtj_1[l_ac2].rtj09
                        IF l_n > 0 THEN
                           LET g_rtj05 = '2'
                        ELSE
                           LET g_rtj05 = '1'
                        END IF
                     END IF
                    #TQC-C20070 Add End -----
                  END IF 
               END IF 
               CALL t100_rtj24_1(g_rtj_1[l_ac2].rtj24_1,'2')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_rtj_1[l_ac2].rtj24_1 = g_rtj_1_t.rtj24_1
                  NEXT FIELD rtj24_1 
               END IF
            END IF 

         AFTER FIELD rtj04_1
            IF NOT cl_null(g_rtj_1[l_ac2].rtj04_1) THEN
               IF NOT s_chk_item_no(g_rtj_1[l_ac2].rtj04_1,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rtj_1[l_ac2].rtj04_1 = g_rtj_1_t.rtj04_1
                  NEXT FIELD rtj04_1
               END IF
               IF g_rtj_1[l_ac2].rtj04_1 != g_rtj_1_t.rtj04_1 OR
                  g_rtj_1_t.rtj04_1 IS NULL THEN
                 #TQC-D40044--add--str---
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj09) THEN
                     SELECT ima25 INTO l_ima25
                       FROM ima_file
                      WHERE ima01 = g_rtj_1[l_ac2].rtj04_1

                     IF l_ima25 != g_rtj_1[l_ac2].rtj09 THEN
                        CALL s_umfchk(g_rtj_1[l_ac2].rtj04_1,l_ima25,g_rtj_1[l_ac2].rtj09)
                           RETURNING l_flag,l_fac
                        IF l_flag = 1 THEN
                           CALL cl_err('','art-214',0)
                           NEXT FIELD rtj04_1
                        END IF
                     END IF
                  END IF
                 #TQC-D40044--add--end---
                  CALL t100_rtj04(g_rtj_1[l_ac2].rtj04_1,p_cmd,'2')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rtj04_1
                  END IF
                  CALL t100_rtj10()
                  CALL t100_repate()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rtj04_1
                  END IF
               END IF
               IF NOT cl_null(g_rtj_1[l_ac2].rtj24_1) THEN
                  IF p_cmd = 'a' OR
                     (p_cmd = 'u' AND g_rtj_1[l_ac2].rtj24_1 <> g_rtj_1_t.rtj24_1) THEN 
                     CALL t100_rtj24(g_rtj_1[l_ac2].rtj24_1,g_rtj_1[l_ac2].rtj04_1,'2')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_rtj_1[l_ac2].rtj04_1 = g_rtj_1_t.rtj04_1
                        NEXT FIELD rtj04_1 
                     END IF 
                     IF NOT cl_null(g_rtj_1[l_ac2].rtj04_1) 
                        AND NOT cl_null(g_rtj_1[l_ac2].rtj09) THEN  #TQC-C30322 add
                        SELECT count(*) INTO l_n  
                          FROM rtj_file
                         WHERE rtj01 = g_rti.rti01 AND rtj02 = '2'
                           AND rtj04 = g_rtj_1[l_ac2].rtj04_1
                           AND rtj24 = g_rtj_1[l_ac2].rtj24_1
                           AND rtj09 = g_rtj_1[l_ac2].rtj09   #TQC-C30322 add
                        IF l_n > 0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtj_1[l_ac2].rtj04_1 = g_rtj_1_t.rtj04_1
                           NEXT FIELD rtj04_1
                        END IF
                     END IF
                    #TQC-C20070 Add Begin ---
                     IF NOT cl_null(g_rtj_1[l_ac2].rtj09) THEN
                        LET l_n = 0 
                        SELECT COUNT(*) INTO l_n 
                          FROM rtg_file 
                         WHERE rtg01 = g_rtj_1[l_ac2].rtj24_1 
                           AND rtg03 = g_rtj_1[l_ac2].rtj04_1
                           AND rtg04 = g_rtj_1[l_ac2].rtj09
                        IF l_n > 0 THEN
                           LET g_rtj05 = '2'
                        ELSE
                           LET g_rtj05 = '1'
                        END IF
                     END IF
                    #TQC-C20070 Add End -----
                  END IF  
               END IF 
            END IF
             
         AFTER FIELD rtj09
            IF NOT cl_null(g_rtj_1[l_ac2].rtj09) THEN
               IF g_rtj_1[l_ac2].rtj09 != g_rtj_1_t.rtj09 OR
                  g_rtj_1_t.rtj09 IS NULL THEN
                 #TQC-C30322 add START
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj04_1) 
                     AND NOT cl_null(g_rtj_1[l_ac2].rtj09) THEN  #TQC-C30322 add
                    #TQC-D40044--add--str---
                     SELECT ima25 INTO l_ima25
                       FROM ima_file
                      WHERE ima01 = g_rtj_1[l_ac2].rtj04_1
                  
                     IF l_ima25 != g_rtj_1[l_ac2].rtj09 THEN
                        CALL s_umfchk(g_rtj_1[l_ac2].rtj04_1,l_ima25,g_rtj_1[l_ac2].rtj09)
                           RETURNING l_flag,l_fac
                        IF l_flag = 1 THEN
                           CALL cl_err('','art-214',0)
                           NEXT FIELD rtj09
                        END IF
                     END IF
                    #TQC-D40044--add--end---
                     SELECT count(*) INTO l_n
                       FROM rtj_file
                      WHERE rtj01 = g_rti.rti01 AND rtj02 = '2'
                        AND rtj04 = g_rtj_1[l_ac2].rtj04_1
                        AND rtj24 = g_rtj_1[l_ac2].rtj24_1
                        AND rtj09 = g_rtj_1[l_ac2].rtj09   #TQC-C30322 add
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_rtj_1[l_ac2].rtj04_1 = g_rtj_1_t.rtj04_1
                        NEXT FIELD rtj04_1
                     END IF
                  END IF
                 #TQC-C30322 add END
                 #TQC-C20070 Add Begin ---
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj24_1) AND NOT cl_null(g_rtj_1[l_ac2].rtj04_1) THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n
                       FROM rtg_file
                      WHERE rtg01 = g_rtj_1[l_ac2].rtj24_1 
                        AND rtg03 = g_rtj_1[l_ac2].rtj04_1
                        AND rtg04 = g_rtj_1[l_ac2].rtj09
                     IF l_n > 0 THEN
                        LET g_rtj05 = '2'
                     ELSE
                        LET g_rtj05 = '1'
                     END IF
                  END IF
                 #TQC-C20070 Add End -----
                 #TQC-D40044--mark--str---
                 #SELECT ima25 INTO l_ima25
                 #  FROM ima_file 
                 # WHERE ima01 = g_rtj_1[l_ac2].rtj04_1
                 # 
                 #LET l_flag = NULL
                 #LET l_fac = NULL
                 #CALL s_umfchk(g_rtj_1[l_ac2].rtj04_1,l_ima25,g_rtj_1[l_ac2].rtj09)
                 #         RETURNING l_flag,l_fac
                 #IF l_flag = 1 THEN
                 #   CALL cl_err('','aic-052',0)
                 #   NEXT FIELD rtj09
                 #END IF
                 #TQC-D40044--mark--end---

                  CALL t100_rtj09()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rtj09
                  END IF

                  CALL t100_rtj10()
                  CALL t100_repate()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rtj09
                  END IF
               END IF
            END IF

         AFTER FIELD rtj13
            IF NOT cl_null(g_rtj_1[l_ac2].rtj13) THEN
               IF g_rtj_1[l_ac2].rtj13 != g_rtj_1_t.rtj13 OR
                  g_rtj_1_t.rtj13 IS NULL THEN
                 #IF g_rtj_1[l_ac2].rtj13 <= 0 THEN #FUN-D20063 mark
                    #CALL cl_err('','art-181',0)    #FUN-D20063 mark
                  IF g_rtj_1[l_ac2].rtj13 < 0 THEN  #FUN-D20063 add
                     CALL cl_err('','art-897',0)    #FUN-D20063 add
                     NEXT FIELD rtj13
                  END IF
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj10) AND 
                     g_rtj_1[l_ac2].rtj10 <> 0 THEN
                     LET g_rtj_1[l_ac2].rtj16 =
                         (g_rtj_1[l_ac2].rtj10*g_rtj_1[l_ac2].rtj13)/100
                  END IF
               END IF
            END IF

         AFTER FIELD rtj14
            IF NOT cl_null(g_rtj_1[l_ac2].rtj14) THEN
               IF g_rtj_1[l_ac2].rtj14 != g_rtj_1_t.rtj14 OR
                  cl_null(g_rtj_1_t.rtj14) THEN
                 #IF g_rtj_1[l_ac2].rtj14 <= 0 THEN #FUN-D20063 mark
                    #CALL cl_err('','art-181',0)    #FUN-D20063 mark
                  IF g_rtj_1[l_ac2].rtj14 < 0 THEN  #FUN-D20063 add
                     CALL cl_err('','art-897',0)    #FUN-D20063 add
                     NEXT FIELD rtj14
                  END IF
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj11) AND
                         g_rtj_1[l_ac2].rtj11 <> 0 THEN
                     LET g_rtj_1[l_ac2].rtj17 =
                         (g_rtj_1[l_ac2].rtj11*g_rtj_1[l_ac2].rtj14)/100
                  END IF
               END IF
            END IF

         AFTER FIELD rtj15
            IF NOT cl_null(g_rtj_1[l_ac2].rtj15) THEN
               IF g_rtj_1[l_ac2].rtj15 != g_rtj_1_t.rtj15 OR
                  cl_null(g_rtj_1_t.rtj15) THEN
                 #IF g_rtj_1[l_ac2].rtj15 <= 0 THEN #FUN-D20063 mark
                    #CALL cl_err('','art-181',0)    #FUN-D20063 mark
                  IF g_rtj_1[l_ac2].rtj15 < 0 THEN  #FUN-D20063 add 
                     CALL cl_err('','art-897',0)    #FUN-D20063 add 
                     NEXT FIELD rtj15
                  END IF
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj12) AND g_rtj_1[l_ac2].rtj12<>0 THEN
                     LET g_rtj_1[l_ac2].rtj18 =
                         (g_rtj_1[l_ac2].rtj12*g_rtj_1[l_ac2].rtj15)/100
                  END IF
               END IF
            END IF

         AFTER FIELD rtj16
            IF NOT cl_null(g_rtj_1[l_ac2].rtj16) THEN
               IF g_rtj_1[l_ac2].rtj16 != g_rtj_1_t.rtj16 OR
                  cl_null(g_rtj_1_t.rtj16) THEN
                 #IF g_rtj_1[l_ac2].rtj16 <= 0 THEN #FUN-D20063 mark
                    #CALL cl_err('','art-180',0)    #FUN-D20063 mark
                  IF g_rtj_1[l_ac2].rtj16 < 0 THEN  #FUN-D20063 add
                     CALL cl_err('','alm-450',0)    #FUN-D20063 add
                     NEXT FIELD rtj16
                  END IF
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj10) AND 
                     g_rtj_1[l_ac2].rtj10 <> 0 THEN
                     LET g_rtj_1[l_ac2].rtj13 =
                         (g_rtj_1[l_ac2].rtj16/g_rtj_1[l_ac2].rtj10)*100
                  END IF
               END IF
            END IF
             
         AFTER FIELD rtj17
            IF NOT cl_null(g_rtj_1[l_ac2].rtj17) THEN
               IF g_rtj_1[l_ac2].rtj17 != g_rtj_1_t.rtj17 OR
                  cl_null(g_rtj_1_t.rtj17) THEN
               #FUN-D20063---add---START 
                  IF g_rtj_1[l_ac2].rtj17 < 0 THEN 
                     CALL cl_err('','alm-450',0)
                     NEXT FIELD rtj17
                  END IF                  
               #FUN-D20063---add-----END
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj11) AND 
                     g_rtj_1[l_ac2].rtj11 <> 0 THEN
                     LET g_rtj_1[l_ac2].rtj14 =
                         (g_rtj_1[l_ac2].rtj17/g_rtj_1[l_ac2].rtj11)*100
                  END IF
               END IF
            END IF

         AFTER FIELD rtj18
            IF NOT cl_null(g_rtj_1[l_ac2].rtj18) THEN
               IF g_rtj_1[l_ac2].rtj18 != g_rtj_1_t.rtj18 OR
                  cl_null(g_rtj_1_t.rtj18) THEN
               #FUN-D20063---add---START
                  IF g_rtj_1[l_ac2].rtj18 < 0 THEN  
                     CALL cl_err('','alm-450',0)
                     NEXT FIELD rtj18
                  END IF
               #FUN-D20063---add-----END
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj12) AND 
                     g_rtj_1[l_ac2].rtj12 <> 0 THEN
                     LET g_rtj_1[l_ac2].rtj15 =
                         (g_rtj_1[l_ac2].rtj18/g_rtj_1[l_ac2].rtj12)*100
                  END IF
               END IF
            END IF

#FUN-D20063---add---START 
         AFTER FIELD rtj25
            IF NOT cl_null(g_rtj_1[l_ac2].rtj25) THEN
               IF g_rtj_1[l_ac2].rtj25 < 0 THEN
                  CALL cl_err('','alm-450',0)
                  NEXT FIELD rtj25
               END IF
            END IF
#FUN-D20063---add-----END
             
         BEFORE FIELD rtj19
            CALL cl_set_comp_entry("rtj19",TRUE)
              
         BEFORE DELETE
            IF g_rtj_1_t.rtj03_1 IS NOT NULL AND g_rtj_1_t.rtj03_1 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               
               DELETE FROM rtj_file
                WHERE rtj01 = g_rti.rti01 AND rtj02 = '2'
                  AND rtj03 = g_rtj_1[l_ac2].rtj03_1
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","rtj_file",g_rti.rti01,g_rti.rti02,
                                                    SQLCA.SQLCODE,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b2=g_rec_b2-1
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rtj_1[l_ac2].* = g_rtj_1_t.*
               CLOSE t100_bc2
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rtj_1[l_ac2].rtj04_1,-263,1)
               LET g_rtj_1[l_ac2].* = g_rtj_1_t.*
            ELSE
               UPDATE rtj_file 
                  SET rtj02 = '2',
                      rtj05 = g_rtj05,       #TQC-C20070 add             
                      rtj03 = g_rtj_1[l_ac2].rtj03_1,
                      rtj04 = g_rtj_1[l_ac2].rtj04_1,
                      rtj09 = g_rtj_1[l_ac2].rtj09,
                      rtj10 = g_rtj_1[l_ac2].rtj10,
                      rtj11 = g_rtj_1[l_ac2].rtj11,
                      rtj12 = g_rtj_1[l_ac2].rtj12,
                      rtj13 = g_rtj_1[l_ac2].rtj13,
                      rtj14 = g_rtj_1[l_ac2].rtj14,
                      rtj15 = g_rtj_1[l_ac2].rtj15,
                      rtj16 = g_rtj_1[l_ac2].rtj16,
                      rtj17 = g_rtj_1[l_ac2].rtj17,
                      rtj18 = g_rtj_1[l_ac2].rtj18,
                      rtj25 = g_rtj_1[l_ac2].rtj25,     #FUN-C50036 add
                      rtj19 = g_rtj_1[l_ac2].rtj19,
                      rtj23 = g_rtj_1[l_ac2].rtj23, 
                      rtj24 = g_rtj_1[l_ac2].rtj24_1,   #TQC-C30083 add
                      rtj20 = g_rtj_1[l_ac2].rtj20
                WHERE rtj01=g_rti.rti01
                  AND rtj02='2'
                  AND rtj03=g_rtj_1_t.rtj03_1
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","rtj_file",g_rti.rti01,
                                         g_rti.rtiplant,SQLCA.SQLCODE,"","",1) 
                  LET g_rtj_1[l_ac2].* = g_rtj_1_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac2= ARR_CURR()
            LET l_ac2_t = l_ac2
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_rtj_1[l_ac2].* = g_rtj_1_t.*
               END IF
               CLOSE t100_bc2
               ROLLBACK WORK
               CONTINUE DIALOG
            END IF
            CLOSE t100_bc2
            COMMIT WORK
             
         ON ACTION controlp
            CASE
               WHEN INFIELD (rtj24_1)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rtf01"
                  LET g_qryparam.default1 = g_rtj_1[l_ac2].rtj24_1
                  CALL cl_create_qry() RETURNING g_rtj_1[l_ac2].rtj24_1
                  DISPLAY BY NAME g_rtj_1[l_ac2].rtj24_1
                  NEXT FIELD rtj24_1   

               WHEN INFIELD(rtj04_1)
                  IF cl_null(l_rtz05) THEN
                      CALL q_sel_ima(FALSE, "q_ima01","",g_rtj_1[l_ac2].rtj04_1,
                                                              "","","","","",'' )                     
                        RETURNING g_rtj_1[l_ac2].rtj04_1                                            
                  ELSE
                     CALL cl_init_qry_var()                   
                     LET g_qryparam.form = "q_rtg03_1"
                     LET g_qryparam.arg1 = l_rtz05
                     LET g_qryparam.default1 = g_rtj_1[l_ac2].rtj04_1      
                     CALL cl_create_qry() RETURNING g_rtj_1[l_ac2].rtj04_1   
                  END IF
                  NEXT FIELD rtj04_1

               WHEN INFIELD(rtj09)
                  CALL cl_init_qry_var()
                 # LET g_qryparam.arg1 = g_rtj_1[l_ac2].rtj04_1     #TQC-C20070 mark
                 # LET g_qryparam.form = "q_gfe"                    #TQC-C20070 mark
                  #TQC-C20070--start add---------------------------
                  LET g_qryparam.default1 = g_rtj_1[l_ac2].rtj09
                  IF NOT cl_null(g_rtj_1[l_ac2].rtj04_1) THEN
                     LET g_qryparam.form ="q_gfe02"
                     SELECT ima25 INTO l_ima25 FROM ima_file
                      WHERE ima01 = g_rtj_1[l_ac2].rtj04_1
                     LET g_qryparam.arg1=l_ima25
                  ELSE
                     LET g_qryparam.form ="q_gfe"
                  END IF
                  #TQC-C20070--end add-----------------------------
                  CALL cl_create_qry() RETURNING g_rtj_1[l_ac2].rtj09
                  DISPLAY g_rtj_1[l_ac2].rtj09 TO rtj09
                  NEXT FIELD rtj09
            END CASE

         #价格策略批量产生
         ON ACTION pricing_strategy
            CALL t100_price()
            CALL t100_list_fill()
           #TQC-C20270 Add Begin ---
            LET g_flag_b = '2'
            CALL t100_b()
           #TQC-C20270 Add End -----
           #CONTINUE DIALOG #TQC-C20070 Mark
            EXIT DIALOG     #TQC-C20070 Add
      END INPUT      
 
      INPUT ARRAY g_ryn FROM s_ryn.*
           ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b3 != 0 THEN
               CALL fgl_set_arr_curr(l_ac3)
            END IF
            LET g_flag_b = '3' #FUND-30033 add

         BEFORE ROW
            LET p_cmd=''
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'            
            LET l_n  = ARR_COUNT()

            BEGIN WORK

            OPEN t100_cl USING g_rti.rti01
            IF STATUS THEN
               CALL cl_err("OPEN t100_cl:", STATUS, 1)
               CLOSE t100_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH t100_cl INTO g_rti.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_rti.rti01,SQLCA.SQLCODE,0)
               CLOSE t100_cl
               ROLLBACK WORK
               RETURN
            END IF
             
            IF g_rec_b3 >= l_ac3 THEN
               LET p_cmd='u'
               LET g_ryn_t.* = g_ryn[l_ac3].*

               OPEN t100_bc3 USING g_rti.rti01,g_ryn_t.ryn03,g_ryn_t.ryn04
               IF STATUS THEN
                  CALL cl_err("OPEN t100_bc3:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t100_bc3 INTO g_ryn[l_ac3].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ryn_t.ryn04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL t100_b_init(l_ac3)
               END IF
            END IF 
            
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ryn[l_ac3].* TO NULL
            LET g_ryn[l_ac3].ryn02 = '1'
            LET g_ryn[l_ac3].ryn14 = 'Y' 
            LET g_ryn_t.* = g_ryn[l_ac3].*
            CALL cl_show_fld_cont()
            NEXT FIELD ryn03
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            INSERT INTO ryn_file(ryn01,ryn02,ryn03,ryn04,ryn05,ryn06,ryn07,
                                 ryn08,ryn09,ryn10,ryn11,ryn12,ryn13,ryn14,
                                 ryn15,rynplant,rynlegal)
            VALUES(g_rti.rti01,g_ryn[l_ac3].ryn02,g_ryn[l_ac3].ryn03,
                   g_ryn[l_ac3].ryn04,g_ryn[l_ac3].ryn05,g_ryn[l_ac3].ryn06,
                   g_ryn[l_ac3].ryn07,g_ryn[l_ac3].ryn08,g_ryn[l_ac3].ryn09,
                   g_ryn[l_ac3].ryn10,g_ryn[l_ac3].ryn11,g_ryn[l_ac3].ryn12,
                   g_ryn[l_ac3].ryn13,g_ryn[l_ac3].ryn14,g_ryn[l_ac3].ryn15,
                   g_rti.rtiplant,g_legal)
                  
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("ins","ryn_file",g_rti.rti01,
                                 g_ryn[l_ac3].ryn04,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b3 = g_rec_b3 + 1
               DISPLAY g_rec_b3 TO FORMONLY.cn2
            END IF
 
         AFTER FIELD ryn03 #變更機構
            IF NOT cl_null(g_ryn[l_ac3].ryn03) THEN
               IF g_ryn[l_ac3].ryn03 <> '*' THEN
                  IF cl_null(g_ryn_t.ryn03) OR 
                     (g_ryn[l_ac3].ryn03 != g_ryn_t.ryn03 ) THEN
                     CALL t100_ryn03(p_cmd)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_ryn[l_ac3].ryn03,g_errno,0)
                        LET g_ryn[l_ac3].ryn03 = g_ryn_t.ryn03
                        DISPLAY BY NAME g_ryn[l_ac3].ryn03
                        NEXT FIELD ryn03
                     END IF
                     IF NOT cl_null(g_ryn[l_ac3].ryn04) THEN
                        SELECT COUNT(*) INTO l_n FROM ryn_file
                         WHERE ryn01 = g_rti.rti01
                           AND ryn03 = g_ryn[l_ac3].ryn03 AND ryn04 = g_ryn[l_ac3].ryn04
                        IF l_n > 0 THEN
                           CALL cl_err('','-239',0)
                           NEXT FIELD ryn03
                        END IF
                     END IF
                  END IF
               END IF
            END IF
            
         BEFORE FIELD ryn04 
            IF cl_null(g_ryn[l_ac3].ryn03) THEN
               NEXT FIELD ryn03
            END IF

         AFTER FIELD ryn04 #商品編號
            IF NOT cl_null(g_ryn[l_ac3].ryn04) THEN
               IF NOT s_chk_item_no(g_ryn[l_ac3].ryn04,g_ryn[l_ac3].ryn03) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ryn[l_ac3].ryn04= g_ryn_t.ryn04
                  NEXT FIELD ryn04
               END IF
              #TQC-C20357 Add Begin ---
               IF NOT s_internal_item(g_ryn[l_ac3].ryn04,g_plant) THEN
                  CALL cl_err('','art-701',1)
                  LET g_ryn[l_ac3].ryn04= g_ryn_t.ryn04
                  NEXT FIELD ryn04
               END IF
              #TQC-C20357 Add End -----

               IF cl_null(g_ryn_t.ryn04) OR
                  (g_ryn[l_ac3].ryn04 != g_ryn_t.ryn04 ) THEN 
                  CALL t100_ryn04(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ryn[l_ac3].ryn04,g_errno,0)
                     LET g_ryn[l_ac3].ryn04 = g_ryn_t.ryn04
                     DISPLAY BY NAME g_ryn[l_ac3].ryn04
                     NEXT FIELD ryn04
                  END IF
                  #檢查該商品是否是商品策略範圍內的商品
                  CALL t100_chk_in()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ryn[l_ac3].ryn04,g_errno,0)       
                     NEXT FIELD ryn04
                  END IF
                  IF NOT cl_null(g_ryn[l_ac3].ryn03) THEN
                     SELECT COUNT(*) INTO l_n FROM ryn_file 
                      WHERE ryn01 = g_rti.rti01
                        AND ryn03 = g_ryn[l_ac3].ryn03 AND ryn04 = g_ryn[l_ac3].ryn04
                     IF l_n > 0 THEN
                        CALL cl_err('','-239',0)
                        NEXT FIELD ryn04
                     END IF
                  END IF 
               END IF  
            END IF  
 
         AFTER FIELD ryn05 #採購類型
            IF NOT cl_null(g_ryn[l_ac3].ryn05) THEN 
               CALL t100_ryn05()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ryn05
               END IF
            END IF
 
         AFTER FIELD ryn06
            IF NOT cl_null(g_ryn[l_ac3].ryn06) THEN
               IF p_cmd ='a' OR 
                  (p_cmd = 'u' AND g_ryn[l_ac3].ryn06<>g_ryn_t.ryn06 
                  OR cl_null(g_ryn_t.ryn06)) THEN
                  CALL t100_ryn06(p_cmd,g_ryn[l_ac3].ryn06)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ryn[l_ac3].ryn06,g_errno,0)
                     LET g_ryn[l_ac3].ryn06 = g_ryn_t.ryn06
                     DISPLAY BY NAME g_ryn[l_ac3].ryn06
                     NEXT FIELD ryn06
                  END IF
               END IF
            END IF
            
         AFTER FIELD ryn07 #主供商
            IF NOT cl_null(g_ryn[l_ac3].ryn07) THEN
               IF p_cmd ='a' OR (p_cmd = 'u' AND g_ryn[l_ac3].ryn07<>g_ryn_t.ryn07) THEN
                  CALL t100_ryn07(p_cmd,g_ryn[l_ac3].ryn07)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ryn[l_ac3].ryn07,g_errno,0)
                     LET g_ryn[l_ac3].ryn07 = g_ryn_t.ryn07
                     DISPLAY BY NAME g_ryn[l_ac3].ryn07
                     NEXT FIELD ryn07
                  END IF
               END IF
            END IF
            
         AFTER FIELD ryn09,ryn10,ryn11
            IF FGL_DIALOG_GETBUFFER()<0 THEN
               CALL cl_err('','aic-005',0)
               NEXT FIELD CURRENT
            END IF
            
         AFTER FIELD ryn12,ryn13
            LET l_flowno = FGL_DIALOG_GETBUFFER()
            IF NOT cl_null(l_flowno) THEN
               CALL t100_chk_flowno(l_flowno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD CURRENT
               END IF
            END IF
         
         AFTER FIELD ryn15   #採購中心
            IF NOT cl_null(g_ryn[l_ac3].ryn15) THEN
               IF p_cmd ='a' OR (p_cmd = 'u' AND g_ryn[l_ac3].ryn15<>g_ryn_t.ryn15) THEN
                  CALL t100_ryn15(p_cmd,g_ryn[l_ac3].ryn15)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ryn[l_ac3].ryn15,g_errno,0)
                     LET g_ryn[l_ac3].ryn15 = g_ryn_t.ryn15
                     DISPLAY BY NAME g_ryn[l_ac3].ryn15
                     NEXT FIELD ryn15
                  END IF
               END IF
            END IF
 
         BEFORE DELETE
            IF g_ryn_t.ryn03 IS NOT NULL AND 
               g_ryn_t.ryn04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM ryn_file
                WHERE ryn01 = g_rti.rti01
                  AND ryn03 = g_ryn_t.ryn03
                  AND ryn04 = g_ryn_t.ryn04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ryn_file",g_rti.rti01,g_ryn_t.ryn02,
                                                  SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b3 =g_rec_b3 - 1
               DISPLAY g_rec_b3 TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ryn[l_ac3].* = g_ryn_t.*
               CLOSE t100_bc3
               ROLLBACK WORK
               EXIT DIALOG 
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ryn[l_ac3].ryn02,-263,1)
               LET g_ryn[l_ac3].* = g_ryn_t.*
            ELSE
               UPDATE ryn_file 
                  SET ryn02 = g_ryn[l_ac3].ryn02,
                      ryn03 = g_ryn[l_ac3].ryn03,
                      ryn04 = g_ryn[l_ac3].ryn04,
                      ryn05 = g_ryn[l_ac3].ryn05,
                      ryn06 = g_ryn[l_ac3].ryn06,
                      ryn07 = g_ryn[l_ac3].ryn07,
                      ryn08 = g_ryn[l_ac3].ryn08,
                      ryn09 = g_ryn[l_ac3].ryn09,
                      ryn10 = g_ryn[l_ac3].ryn10,
                      ryn11 = g_ryn[l_ac3].ryn11,
                      ryn12 = g_ryn[l_ac3].ryn12,
                      ryn13 = g_ryn[l_ac3].ryn13,
                      ryn14 = g_ryn[l_ac3].ryn14,
                      ryn15 = g_ryn[l_ac3].ryn15
                WHERE ryn01 = g_rti.rti01
                  AND ryn03 = g_ryn_t.ryn03
                  AND ryn04 = g_ryn_t.ryn04
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ryn_file",g_rti.rti01,g_ryn_t.ryn02,
                                                         SQLCA.sqlcode,"","",1)
                  LET g_ryn[l_ac3].* = g_ryn_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
         AFTER ROW
            LET l_ac3 = ARR_CURR()
            LET l_ac3_t = l_ac3
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ryn[l_ac3].* = g_ryn_t.*
               END IF
               CLOSE t100_bc3
               ROLLBACK WORK
               EXIT DIALOG 
            END IF
            CLOSE t100_bc3
            COMMIT WORK
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ryn04)   #商品
                  CALL q_sel_ima(FALSE, "q_ima","",g_ryn[l_ac3].ryn04,"","",
                                  "","","",g_ryn[l_ac3].ryn03 )
                     RETURNING  g_ryn[l_ac3].ryn04 
                  CALL t100_ryn04('d')
                  NEXT FIELD ryn04 
                  
              WHEN INFIELD(ryn03)  #變更機構
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azp"
                  LET g_qryparam.default1 = g_ryn[l_ac3].ryn03
                  CALL cl_create_qry() RETURNING g_ryn[l_ac3].ryn03
                  DISPLAY BY NAME g_ryn[l_ac3].ryn03
                  CALL t100_ryn03('d')
                  NEXT FIELD ryn03
                  
              WHEN INFIELD(ryn06)  #配送中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_geu"
                  LET g_qryparam.arg1='8'
                  LET g_qryparam.default1 = g_ryn[l_ac3].ryn06
                  CALL cl_create_qry() RETURNING g_ryn[l_ac3].ryn06
                  DISPLAY BY NAME g_ryn[l_ac3].ryn06
                  CALL t100_ryn06('d',g_ryn[l_ac3].ryn06)
                  NEXT FIELD ryn06
                  
              WHEN INFIELD(ryn07)  #主供應商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc2"
                  LET g_qryparam.default1 = g_ryn[l_ac3].ryn07
                  CALL cl_create_qry() RETURNING g_ryn[l_ac3].ryn07
                  DISPLAY BY NAME g_ryn[l_ac3].ryn07
                  CALL t100_ryn07('d',g_ryn[l_ac3].ryn07)
                  NEXT FIELD ryn07
                  
              WHEN INFIELD(ryn12)  #採購多角貿易流程代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_poz01"
                  LET g_qryparam.default1 = g_ryn[l_ac3].ryn12
                  CALL cl_create_qry() RETURNING g_ryn[l_ac3].ryn12
                  DISPLAY BY NAME g_ryn[l_ac3].ryn12
                  NEXT FIELD ryn12
                  
              WHEN INFIELD(ryn13)  #退貨多角貿易流程代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_poz01"
                  LET g_qryparam.default1 = g_ryn[l_ac3].ryn13
                  CALL cl_create_qry() RETURNING g_ryn[l_ac3].ryn13
                  DISPLAY BY NAME g_ryn[l_ac3].ryn13
                  NEXT FIELD ryn13
                  
              WHEN INFIELD(ryn15)  #採購中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_geu"
                  LET g_qryparam.default1 = g_ryn[l_ac3].ryn15
                  CALL cl_create_qry() RETURNING g_ryn[l_ac3].ryn15
                  DISPLAY BY NAME g_ryn[l_ac3].ryn15
                  CALL t100_ryn15('d',g_ryn[l_ac3].ryn15)
                  NEXT FIELD ryn15
               OTHERWISE EXIT CASE
            END CASE

         ON ACTION procurement_strategy
            CALL t100_purchase()
            CALL t100_list_fill()
           #TQC-C20270 Add Begin ---
            LET g_flag_b = '3'
            CALL t100_b()
           #TQC-C20270 Add End -----
           #CONTINUE DIALOG #TQC-C20070 Mark
            EXIT DIALOG     #TQC-C20070 Add
      END INPUT           

      #TQC-C20136--start add--------------------------   
      BEFORE DIALOG
         CASE g_flag_b
            WHEN '1'
               NEXT FIELD rtj24
            WHEN '2'
               NEXT FIELD rtj24_1
            WHEN '3'
               NEXT FIELD ryn03    
         END CASE  
      #TQC-C20136--end add----------------------------
      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION CANCEL
         #FUN-D30033--add--begin---
         IF p_cmd = 'a' THEN
            IF g_flag_b ='1' AND g_rec_b1 != 0 THEN
               LET g_action_choice = "detail"
            END IF
            IF g_flag_b ='2' AND g_rec_b2 != 0 THEN
               LET g_action_choice = "detail"
            END IF
            IF g_flag_b ='3' AND g_rec_b3 != 0 THEN
               LET g_action_choice = "detail"
            END IF
         END IF  
         #FUN-D30033--add--end---
         EXIT DIALOG
     
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
                                                                                                            
      ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO") 
   END DIALOG 
      
   IF p_cmd = 'u' THEN
      LET g_rti.rtimodu = g_user
      LET g_rti.rtidate = g_today
      
      UPDATE rti_file 
         SET rtimodu = g_rti.rtimodu,
             rtidate = g_rti.rtidate
       WHERE rti01 = g_rti.rti01

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","rti_file",g_rti.rti01,"",
                                          SQLCA.SQLCODE,"","upd rti",1)
      END IF

      DISPLAY BY NAME g_rti.rtimodu,g_rti.rtidate
   END IF

   CLOSE t100_bc1
   CLOSE t100_bc2
   CLOSE t100_bc3
   CALL t100_delall()
   CALL t100_list_fill()  #TQC-C30083 add
   COMMIT WORK 
END FUNCTION 

#单身为空，删除单头
FUNCTION t100_delall()
   DEFINE l_n    LIKE type_file.num5

   SELECT count(*) INTO l_n
     FROM rtj_file
    WHERE rtj01 = g_rti.rti01

   IF l_n = 0 THEN
      SELECT COUNT(*) INTO l_n
        FROM ryn_file
       WHERE ryn01 = g_rti.rti01
      IF l_n = 0 THEN  
         CALL cl_getmsg('9044',g_lang) RETURNING g_msg
            ERROR g_msg CLIPPED
         DELETE FROM rti_file where rti01 = g_rti.rti01
      END IF    
   END IF
END FUNCTION

#审核
FUNCTION t100_confirm()
   DEFINE l_gen02        LIKE gen_file.gen02
   DEFINE l_gec07        LIKE gec_file.gec07
   DEFINE l_gec07s       LIKE gec_file.gec07
   DEFINE l_rtj24        LIKE rtj_file.rtj24
   DEFINE l_rtj03        LIKE rtj_file.rtj03
   DEFINE l_ruh04        LIKE ruh_file.ruh04
   DEFINE l_ruh05        LIKE ruh_file.ruh05
   DEFINE l_msg          STRING
   DEFINE l_msg1         STRING 
   DEFINE l_msg2         STRING
   DEFINE l_rtj24_1      STRING
   DEFINE l_ruh04_1      STRING

   IF s_shut(0) THEN 
      RETURN 
   END IF 
   
   IF cl_null(g_rti.rti01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------------ add ------------------- begin
   IF g_rti.rticonf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_rti.rticonf = 'X' THEN
      CALL cl_err(g_rti.rti01,'9024',0)
      RETURN
   END IF

   IF g_rti.rtiacti = 'N' THEN
      CALL cl_err(g_rti.rti01,'art-142',0)
      RETURN
   END IF

   IF NOT s_data_center(g_plant) THEN
      RETURN
   END IF
   
   IF NOT cl_confirm('art-026') THEN
      RETURN
   END IF
#CHI-C30107 ------------------ add ------------------- end
   SELECT * INTO g_rti.* 
     FROM rti_file 
    WHERE rti01 = g_rti.rti01 
      AND rtiplant = g_rti.rtiplant
      
   IF g_rti.rticonf = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF
   
   IF g_rti.rticonf = 'X' THEN 
      CALL cl_err(g_rti.rti01,'9024',0) 
      RETURN 
   END IF
   
   IF g_rti.rtiacti = 'N' THEN 
      CALL cl_err(g_rti.rti01,'art-142',0) 
      RETURN 
   END IF
   
   IF NOT s_data_center(g_plant) THEN 
      RETURN 
   END IF

#CHI-C30107 ------------ mark -------------- begin
#  IF NOT cl_confirm('art-026') THEN 
#     RETURN 
#  END IF
#CHI-C30107 ------------ mark -------------- end

   BEGIN WORK
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t100_cl INTO g_rti.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL s_showmsg_init()
   LET g_success = 'Y'
#FUN-BC0130 MARK begin ------  
#   #FUN-BC0076--start add--------------------------------------------- 
#   #在产品策略变更中，异动产品的税别，在单身策略内，含税否必须一致，不一致集中报错 
#   LET g_sql = " SELECT DISTINCT rtj24,rtj03 FROM rtj_file ",
#               "  WHERE rtj01 = '",g_rti.rti01,"'",
#               "    AND rtj02 = '1' "
#   PREPARE t100_chk_pre1 FROM g_sql
#   DECLARE t100_chk_cs1 CURSOR FOR t100_chk_pre1
#
#   FOREACH t100_chk_cs1 INTO l_rtj24,l_rtj03
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      SELECT DISTINCT gec07 INTO l_gec07
#        FROM rte_file
#       INNER JOIN rvy_file 
#          ON rte01 = rvy01
#         AND rte02 = rvy02
#       INNER JOIN gec_file
#          ON rvy04 = gec01
#         AND rvy05 = gec011
#       WHERE rvy01 = l_rtj24
#         AND rte07 = 'Y'
# 
#      LET g_sql = " SELECT DISTINCT ruh04,ruh05 FROM ruh_file ",
#                  "  WHERE ruh01 = '",g_rti.rti01,"'",
#                  "    AND ruh02 = '",l_rtj03,"'"
#      PREPARE t100_chk_pre2 FROM g_sql
#      DECLARE t100_chk_cs2 CURSOR FOR t100_chk_pre2
#
#      FOREACH t100_chk_cs2 INTO l_ruh04,l_ruh05 
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#
#         SELECT gec07 INTO l_gec07s
#           FROM gec_file
#          WHERE gec01 = l_ruh04
#            AND gec011 = l_ruh05
#         IF l_gec07s <> l_gec07 THEN
#            LET l_rtj24_1 = l_rtj24
#            LET l_ruh04_1 = l_ruh04  
#            CALL cl_getmsg('art1040',g_lang) RETURNING l_msg
#            CALL cl_getmsg('art1041',g_lang) RETURNING l_msg1
#            LET l_msg2 = l_ruh04_1.trim(),l_msg,l_rtj24_1.trim(),l_msg1   
#            CALL s_errmsg('rti01',g_rti.rti01,l_msg2,'',1)
#            LET g_success='N' 
#         END IF    
#      END FOREACH     
#   END FOREACH 
#   #FUN-BC0076--end add------------------------------------------------------
#FUN-BC0130 MARK end --------------
   UPDATE rti_file 
      SET rticonf = 'Y',
          rti900  = '1',
          rticond = g_today,
          rticonu = g_user
    WHERE rti01=g_rti.rti01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rti_file",g_rti.rti01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_rti.rticonf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rti.rti01,'Y')
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
   END IF

   SELECT * INTO g_rti.* 
     FROM rti_file 
    WHERE rti01=g_rti.rti01
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rti.rticonu
   DISPLAY BY NAME g_rti.rti900,g_rti.rticonf,g_rti.rticond,g_rti.rticonu
   DISPLAY l_gen02 TO FORMONLY.gen02
   
   IF g_rti.rticonf='X' THEN 
      LET g_chr='Y' 
   ELSE 
     LET g_chr='N' 
   END IF
   CALL cl_set_field_pic(g_rti.rticonf,"","","",g_chr,"")

   CALL cl_flow_notify(g_rti.rti01,'V')
END FUNCTION

FUNCTION t100_unconfirm()
   DEFINE l_chr          LIKE type_file.chr1
   DEFINE l_gen02        LIKE gen_file.gen02

   IF s_shut(0) THEN
      RETURN  
   END IF 
   
   IF cl_null(g_rti.rti01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_rti.* 
     FROM rti_file 
    WHERE rti01=g_rti.rti01 
      AND rtiplant=g_rti.rtiplant
      
   IF g_rti.rti900 = '2' THEN 
      CALL cl_err('','art-123',0) 
      RETURN 
   END IF
   
   IF g_rti.rticonf = 'N' THEN 
      CALL cl_err('',9025,0) 
      RETURN 
   END IF
   
   IF g_rti.rticonf = 'X' THEN 
      CALL cl_err(g_rti.rti01,'9024',0) 
      RETURN 
   END IF
   
   IF NOT s_data_center(g_plant) THEN
      RETURN 
   END IF

   IF NOT cl_confirm('aco-729') THEN 
      RETURN 
   END IF

   BEGIN WORK
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t100_cl INTO g_rti.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'
   UPDATE rti_file
      SET rticonf = 'N',
          rti900  = '0',
          rticond = '',
          rticonu = ''
    WHERE rti01=g_rti.rti01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rti_file",g_rti.rti01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_rti.rticonf='N'
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT * INTO g_rti.* 
     FROM rti_file 
    WHERE rti01=g_rti.rti01
    
   SELECT gen02 INTO l_gen02 
     FROM gen_file 
    WHERE gen01 = g_rti.rticonu
    
   DISPLAY BY NAME g_rti.rti900,g_rti.rticonf,g_rti.rticond,g_rti.rticonu

   DISPLAY l_gen02 TO FORMONLY.gen02
   IF g_rti.rticonf='X' THEN 
      LET g_chr='Y' 
   ELSE 
      LET g_chr='N' 
   END IF
   CALL cl_set_field_pic(g_rti.rticonf,"","","",g_chr,"")
END FUNCTION

FUNCTION t100_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rti01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rti01",FALSE)
   END IF
END FUNCTION

FUNCTION t100_rtj04(p_rtj04,p_cmd,p_flag)
   DEFINE l_imaacti    LIKE ima_file.imaacti
   DEFINE l_ima1010    LIKE ima_file.ima1010
   DEFINE p_rtj04      LIKE rtj_file.rtj04
   DEFINE l_ima02      LIKE ima_file.ima02
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE p_flag       LIKE type_file.chr1

   LET g_errno = ' '
    
   IF p_rtj04[1,4] = 'MISC' THEN
      SELECT ima02,imaacti,ima1010 
        INTO l_ima02,l_imaacti,l_ima1010
        FROM ima_file 
       WHERE ima01='MISC'
   ELSE
      SELECT ima02,imaacti,ima1010 
        INTO l_ima02,l_imaacti,l_ima1010
        FROM ima_file 
       WHERE ima01 = p_rtj04
   END IF
   
   CASE 
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-013'
      WHEN l_imaacti='N'
         LET g_errno = '9028'
      WHEN l_ima1010<>'1' OR l_ima1010 IS NULL
         LET g_errno = 'art-182'
      OTHERWISE 
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      CASE p_flag
         WHEN '1'
            LET g_rtj[l_ac1].rtj04_desc = l_ima02
         WHEN '2'
            LET g_rtj_1[l_ac2].rtj04_desc1 = l_ima02
      END CASE 
   END IF 
END FUNCTION

FUNCTION t100_check_shop()
   DEFINE l_rtz04  LIKE   rtz_file.rtz04
   DEFINE l_n      LIKE   type_file.num5

   LET g_errno = ' '
   
   SELECT rtz04 INTO l_rtz04         #獲取當前機構的組織機構類型和商品策略代碼
     FROM rtz_file 
    WHERE rtz01 = g_rti.rtiplant

   #檢查當前機構是否總部
   IF cl_null(l_rtz04) THEN
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n 
     FROM rtd_file,rte_file
    WHERE rtd01=rte01 
      AND rtd01 = l_rtz04
      AND rte03 = g_rtj[l_ac1].rtj04
      
   IF l_n = 0 OR l_n IS NULL THEN
      LET g_errno = 'art-054'
      RETURN
   END IF
END FUNCTION

FUNCTION  t100_rtj21()
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gec02   LIKE gec_file.gec02
   DEFINE l_gecacti LIKE gec_file.gecacti
   DEFINE l_count   LIKE type_file.num10
   DEFINE l_count1  LIKE type_file.num10
   DEFINE l_count2  LIKE type_file.num10
   DEFINE l_ruh03   LIKE ruh_file.ruh03
   
   LET g_errno = " "
   LET l_flag = 'N'
   SELECT gec02,gecacti INTO l_gec02,l_gecacti 
     FROM gec_file
    WHERE gec01 = g_rtj[l_ac1].rtj21 
      AND gec011 = '2'

   CASE
      WHEN SQLCA.sqlcode = 100  
         LET g_errno = 'art-931'
      WHEN l_gecacti = 'N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) THEN
      #检查当前策略变更单号，当前项次，当前税种是否存在ruh_file表中
      LET g_rtj[l_ac1].rtj21_desc = l_gec02
      SELECT COUNT(*) INTO l_count 
        FROM ruh_file 
       WHERE ruh01= g_rti.rti01 
         AND ruh02 = g_rtj[l_ac1].rtj03 
         AND ruh04 = g_rtj[l_ac1].rtj21
         
      #检查修改前的税种是否存在ruh_file表中
      SELECT COUNT(*) INTO l_count1 
        FROM ruh_file
       WHERE ruh01= g_rti.rti01 
         AND ruh02 = g_rtj[l_ac1].rtj03 
         AND ruh04 = g_rtj_t.rtj21

      SELECT COUNT(ruh03) INTO l_count2 
        FROM ruh_file
       WHERE ruh01 =  g_rti.rti01
         AND ruh02 =  g_rtj[l_ac1].rtj03
       IF l_count2 = 0 THEN
          LET l_ruh03 = 1
       ELSE
          SELECT MAX(ruh03)+1 INTO l_ruh03 
            FROM ruh_file
           WHERE ruh01 =  g_rti.rti01
             AND ruh02 =  g_rtj[l_ac1].rtj03
       END IF
       IF l_count1 >0 THEN
          IF g_rtj[l_ac1].rtj21 != g_rtj_t.rtj21 THEN  
             IF cl_confirm('art-975') THEN
                DELETE FROM ruh_file  
                      WHERE ruh01 = g_rti.rti01 
                        AND ruh02 = g_rtj[l_ac1].rtj03
                        AND ruh04 = g_rtj_t.rtj21
             ELSE
                LET g_rtj[l_ac1].rtj21 = g_rtj_t.rtj21
                LET  g_errno = '9001'
                RETURN
             END IF             
          END IF
          LET l_flag = 'Y'
       END IF 
       IF l_count = 0 THEN
          INSERT INTO ruh_file(ruh01,ruh02,ruh03,ruh04,ruh05,ruh06,ruhlegal,ruhplant)
               VALUES(g_rti.rti01,g_rtj[l_ac1].rtj03,l_ruh03,g_rtj[l_ac1].rtj21, 
                      '2','0',g_legal,g_plant)  
          LET l_flag = 'Y'
       END IF
   ELSE 
      CALL cl_err('',g_errno,0)
      LET g_rtj[l_ac1].rtj21 = g_rtj_t.rtj21
   END IF   
END FUNCTION

FUNCTION t100_rtj24_1(p_rtd01,p_cmd)
   DEFINE l_rtdconf  LIKE rtd_file.rtdconf
   DEFINE l_rtdacti  LIKE rtd_file.rtdacti
   DEFINE l_rtfconf  LIKE rtf_file.rtfconf
   DEFINE l_rtfacti  LIKE rtf_file.rtfacti
   DEFINE p_rtd01    LIKE rtd_file.rtd01
   DEFINE l_n        LIKE type_file.num5
   DEFINE p_cmd      LIKE type_file.chr1 

   LET g_errno = ''

   IF p_cmd = '1' THEN 
      SELECT rtdconf,rtdacti INTO l_rtdconf,l_rtdacti
        FROM rtd_file
       WHERE rtd01 = p_rtd01

      CASE 
         WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'atm-341'
         WHEN l_rtdconf <> 'Y'
            LET g_errno = 'art-434'
         WHEN l_rtdacti = 'N'
            LET g_errno = 'art-943'   
      END CASE
      
      SELECT count(*) INTO l_n 
        FROM rtd_file
       WHERE rtd01 = p_rtd01
         AND rtd03 = g_plant

      IF cl_null(l_n) THEN LET l_n = 0 END IF 
      IF l_n = 0 THEN 
         LET g_errno = 'art1028'
      END IF   
   END IF 
   IF p_cmd = '2' THEN
      SELECT rtdconf,rtdacti INTO l_rtfconf,l_rtfacti
        FROM rtf_file
       WHERE rtf01 = p_rtd01

      CASE
         WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'art-342'
         WHEN l_rtfconf <> 'Y'
            LET g_errno = 'art-140'
         WHEN l_rtfacti = 'N'
            LET g_errno = 'art-945'
      END CASE

      SELECT count(*) INTO l_n
        FROM rtf_file
       WHERE rtf01 = p_rtd01
         AND rtf03 = g_plant

      IF cl_null(l_n) THEN LET l_n = 0 END IF
      IF l_n = 0 THEN
         LET g_errno = 'art1028'
      END IF 
   END IF 
END FUNCTION 

FUNCTION t100_rtj24(p_rtj24,p_rtj04,p_rtj02)
   DEFINE p_rtj02   LIKE rtj_file.rtj02
   DEFINE p_rtj04   LIKE rtj_file.rtj04
   DEFINE p_rtj24   LIKE rtj_file.rtj24
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_rtd03   LIKE rtd_file.rtd03
   DEFINE l_rtf03   LIKE rtf_file.rtf03
   DEFINE l_rtdacti LIKE rtd_file.rtdacti
   DEFINE l_rtdconf LIKE rtd_file.rtdconf
   DEFINE l_rtfacti LIKE rtf_file.rtfacti
   DEFINE l_rtfconf LIKE rtf_file.rtfconf
 
   LET g_errno = ''
   
   IF p_rtj02 = '1' THEN
      SELECT rtdacti,rtdconf,rtd03 INTO l_rtdacti,l_rtdconf,l_rtd03
        FROM rtd_file
       WHERE rtd01 = p_rtj24

      CASE
         WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'art-172'
         WHEN l_rtdacti = 'N'
            LET g_errno = 'art1031'
         WHEN l_rtdconf <> 'Y'
            LET g_errno = 'art1032'
         WHEN l_rtd03 <> g_plant
            LET g_errno = 'art1033'
      END CASE
   END IF

   IF p_rtj02 = '2' THEN
      SELECT rtfacti,rtfconf,rtf03 INTO l_rtfacti,l_rtfconf,l_rtf03
        FROM rtf_file
       WHERE rtf01 = p_rtj24
      CASE
         WHEN SQLCA.SQLCODE = 100
            LET g_errno = 'art-342'
         WHEN l_rtfacti = 'N'
            LET g_errno = 'art-945'
         WHEN l_rtfconf <> 'Y'
            LET g_errno = 'atm-140'
         WHEN l_rtf03 <> g_plant
            LET g_errno = 'art1033'
      END CASE

      SELECT rtg05,rtg06,rtg07 
        INTO g_rtj_1[l_ac2].rtj10,g_rtj_1[l_ac2].rtj11,g_rtj_1[l_ac2].rtj12
        FROM rtg_file
       WHERE rtg01 = p_rtj24
         AND rtg03 = g_rtj_1[l_ac2].rtj04_1
   END IF
END FUNCTION 

FUNCTION  artt100_a(l_t)
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_ruhk_sw       LIKE type_file.chr1
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE  p_cmd          LIKE type_file.chr1
   DEFINE  l_t            LIKE type_file.chr1
   DEFINE  l_gecacti      LIKE gec_file.gecacti

   LET l_ac =1
   
   IF cl_null(g_rti.rti01) THEN RETURN END IF
 
   IF g_cmd = 'a' OR g_cmd = 'u' THEN
      DECLARE t100_ruh_curs CURSOR FOR
         SELECT ruh02,'','',ruh03,ruh04,'','',ruh06
           FROM ruh_file
          WHERE ruh01 = g_rti.rti01 
            AND ruh02 = g_rtj[l_ac1].rtj03
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare t100_ruh_curs',SQLCA.sqlcode,1)
         RETURN
      END IF

      CALL g_ruh.clear()
      LET g_cnt = 1
      FOREACH t100_ruh_curs INTO g_ruh[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach t100_ruh_curs',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         
         LET g_ruh[g_cnt].rtj04 = g_rtj[l_ac1].rtj04
         LET g_ruh[g_cnt].rtj04_n = g_rtj[l_ac1].rtj04_desc
         SELECT gec02,gec04 INTO g_ruh[g_cnt].gec02,g_ruh[g_cnt].gec04
          FROM gec_file
         WHERE gec01 = g_ruh[g_cnt].ruh04 AND gec011 = '2' 
        LET g_cnt = g_cnt + 1    
      END FOREACH  
      CALL g_ruh.deleteElement(g_cnt)
      LET g_cnt = g_cnt - 1
   ELSE 
      DECLARE t100_ruh_curs1 CURSOR FOR
        SELECT ruh02,'','',ruh03,ruh04,'','',ruh06
          FROM ruh_file
         WHERE ruh01 = g_rti.rti01
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare t100_ruh_curs1',SQLCA.sqlcode,1)
         RETURN
      END IF

      CALL g_ruh.clear()
      LET g_cnt = 1
      FOREACH t100_ruh_curs1 INTO g_ruh[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach t100_ruh_curs1',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 

         SELECT rtj04 INTO g_ruh[g_cnt].rtj04 
           FROM rtj_file
          WHERE rtj01 = g_rti.rti01 
            AND rtj03 = g_ruh[g_cnt].ruh02 
            AND rtj02 = '1'

         SELECT ima02 INTO g_ruh[g_cnt].rtj04_n 
           FROM ima_file
          WHERE ima01 = g_ruh[g_cnt].rtj04
          
         SELECT gec02,gec04 INTO g_ruh[g_cnt].gec02,g_ruh[g_cnt].gec04 
           FROM gec_file
          WHERE gec01 = g_ruh[g_cnt].ruh04 
            AND gec011 = '2' 
        LET g_cnt = g_cnt + 1
     END FOREACH    
     CALL g_ruh.deleteElement(g_cnt)
     LET g_cnt = g_cnt - 1        
   END IF

   OPEN WINDOW t121_a_w WITH FORM "art/42f/artt121_a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("artt121_a")
   DISPLAY g_cnt TO FORMONLY.cnt
   DISPLAY ARRAY g_ruh TO s_ruh.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
        IF g_rti.rticonf = 'N' THEN
           EXIT DISPLAY
        END IF
    END DISPLAY
        IF g_rti.rticonf <> 'N' THEN
      CLOSE WINDOW t121_a_w
      RETURN
   END IF
   
   LET g_forupd_sql = " SELECT ruh02,'','',ruh03,ruh04,'','',ruh06 ",
                      " FROM ruh_file ",
                      " WHERE ruh01 = '",g_rti.rti01,"'",
                      " AND ruh02 = ? AND ruh03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_ruh_bcl CURSOR FROM g_forupd_sql
   
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare t100_ruh_bcl',SQLCA.sqlcode,1)
      CLOSE WINDOW t121_a_w
      RETURN
   END IF

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ruh WITHOUT DEFAULTS FROM s_ruh.*
      ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
               INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
               APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET g_ruhk_sw = 'N'
         LET l_n  = ARR_COUNT()
         IF l_t = 'N' THEN
            BEGIN WORK
            OPEN t100_cl USING g_rti.rti01 
            IF STATUS THEN
               CALL cl_err("OPEN t100_cl:", STATUS, 1)
               CLOSE t100_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            FETCH t100_cl INTO g_rti.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)      # 資料被他人lnvK
               CLOSE t100_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
         END IF

         IF g_cnt >= l_ac THEN
            LET p_cmd = 'u'
            LET g_ruh_t.* = g_ruh[l_ac].*
            OPEN t100_ruh_bcl USING  g_ruh_t.ruh02,g_ruh_t.ruh03
            IF STATUS THEN
               CALL cl_err("OPEN t100_ruh_bcl:", STATUS, 1)
               LET g_ruhk_sw = "Y"
            END IF
            FETCH t100_ruh_bcl INTO g_ruh[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ruh_t.ruh02,SQLCA.sqlcode,1)
               LET g_ruhk_sw = "Y"
            END IF
            IF g_cmd = 'a' THEN
               LET g_ruh[l_ac].rtj04 = g_rtj[l_ac1].rtj04
               LET g_ruh[l_ac].rtj04_n = g_rtj[l_ac1].rtj04_desc
            ELSE
               SELECT rtj04 INTO g_ruh[l_ac].rtj04 
                 FROM rtj_file
                WHERE rtj01 = g_rti.rti01 
                  AND rtj03 = g_ruh[l_ac].ruh02 AND rtj02 = '1'
               IF NOT cl_null(g_ruh[l_ac].rtj04) THEN
                  SELECT ima02 INTO g_ruh[l_ac].rtj04_n FROM ima_file
                   WHERE ima01 = g_ruh[l_ac].rtj04
               END IF
            END IF
            SELECT gec02,gec04 
              INTO g_ruh[l_ac].gec02,g_ruh[l_ac].gec04 
              FROM gec_file
             WHERE gec01 = g_ruh[l_ac].ruh04 
               AND gec011 = '2'
            LET g_before_input_done = FALSE
            CALL t100_ruh_set_entry_b()
            CALL t100_ruh_set_no_entry_b()
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

           
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ruh[l_ac].* TO NULL
            IF g_cmd='a' OR g_cmd = 'u' THEN
               LET g_ruh[l_ac].ruh02 = g_rtj[l_ac1].rtj03
               LET g_ruh[l_ac].rtj04 = g_rtj[l_ac1].rtj04
               LET g_ruh[l_ac].rtj04_n = g_rtj[l_ac1].rtj04_desc
               CALL cl_set_comp_entry("ruh02",FALSE)

               SELECT COUNT(ruh03) 
                 INTO l_cnt 
                 FROM ruh_file
                WHERE ruh01 =  g_rti.rti01
                  AND ruh02 =  g_rtj[l_ac1].rtj03

               IF l_cnt = 0 THEN
                  LET g_ruh[l_ac].ruh03 = 1
               ELSE              
                  SELECT MAX(ruh03)+1 INTO g_ruh[l_ac].ruh03 
                    FROM ruh_file
                   WHERE ruh01 =  g_rti.rti01
                     AND ruh02 =  g_rtj[l_ac1].rtj03
               END IF
               LET g_ruh[l_ac].ruh06 = '0'
            END IF
            LET g_ruh_t.* = g_ruh[l_ac].*
            LET g_before_input_done = FALSE
            CALL t100_ruh_set_entry_b()
            CALL t100_ruh_set_no_entry_b()
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
            NEXT FIELD ruh02
            
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               CANCEL INSERT
            END IF

            INSERT INTO ruh_file(ruh01,ruh02,ruh03,ruh04,ruh05,ruh06,ruhlegal,ruhplant)
            VALUES(g_rti.rti01,g_ruh[l_ac].ruh02,g_ruh[l_ac].ruh03,
                   g_ruh[l_ac].ruh04,'2',g_ruh[l_ac].ruh06,g_legal,g_plant)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ruh_file",g_rti.rti01,g_ruh[l_ac].ruh02,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               IF l_t = 'N' THEN
                  COMMIT WORK
               END IF
               LET g_cnt = g_cnt + 1
               DISPLAY g_cnt TO FORMONLY.cnt
            END IF

         AFTER FIELD ruh02
            IF g_cmd = 'a' OR g_cmd = 'u' THEN
            ELSE
               IF p_cmd = 'a' THEN 
                 SELECT rtj04 INTO g_ruh[l_ac].rtj04 FROM rtj_file
                  WHERE rtj01 = g_rti.rti01 AND rtj03 = g_ruh[l_ac].ruh02 AND rtj02 = '1'
                 SELECT ima02 INTO g_ruh[l_ac].rtj04_n FROM ima_file
                  WHERE ima01 = g_ruh[l_ac].rtj04
                 SELECT COUNT(ruh03) INTO l_cnt FROM ruh_file
                  WHERE ruh01 =  g_rti.rti01
                    AND ruh02 =  g_ruh[l_ac].ruh02
                 IF l_cnt = 0 THEN
                    LET g_ruh[l_ac].ruh03 = 1
                 ELSE 
                    SELECT MAX(ruh03)+1 INTO g_ruh[l_ac].ruh03 FROM ruh_file
                     WHERE ruh01 =  g_rti.rti01
                       AND ruh02 =  g_ruh[l_ac].ruh02 
                 END IF                
               END IF 
            END IF

         AFTER FIELD ruh03
            IF NOT cl_null(g_ruh[l_ac].ruh03) THEN
               IF g_ruh[l_ac].ruh03 != g_ruh_t.ruh03 OR
                  g_ruh_t.ruh03 IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt 
                    FROM ruh_file
                   WHERE ruh01 = g_rti.rti01
                     AND ruh02 = g_ruh[l_ac].ruh02
                     AND ruh03 = g_ruh[l_ac].ruh03
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_ruh[l_ac].ruh03,'art-934',0)
                     LET g_ruh[l_ac].ruh03 = g_ruh_t.ruh03
                     NEXT FIELD ruh03
                  END IF
               END IF
            END IF              
              
         AFTER FIELD ruh04
            IF NOT cl_null(g_ruh[l_ac].ruh04) THEN
               IF g_ruh[l_ac].ruh04 != g_ruh_t.ruh04 OR
                  g_ruh_t.ruh04 IS NULL THEN
                 #TQC-C30076 add START
                 #CALL t100_chk_rtj21(g_ruh[l_ac].ruh02,'',g_ruh[l_ac].ruh04,g_ruh[l_ac].ruh06)   #FUN-D30050 mark
                  CALL t100_chk_rtj21(g_ruh[l_ac].ruh02,g_ruh[l_ac].rtj04,g_ruh[l_ac].ruh04,g_ruh[l_ac].ruh06)  #FUN-D30050 add
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD ruh04
                  END IF
                 #TQC-C30076 add END
                  SELECT gecacti INTO l_gecacti 
                    FROM gec_file
                   WHERE gec01 = g_ruh[l_ac].ruh04
                   AND gec011 = '2'  
                  IF STATUS =100 THEN
                     CALL cl_err(g_ruh[l_ac].ruh04,'art-931',0)
                     LET g_ruh[l_ac].ruh04 = g_ruh_t.ruh04
                     NEXT FIELD ruh04
                  ELSE
                     IF l_gecacti = 'N' THEN
                        CALL cl_err('','9028',0)
                        LET g_ruh[l_ac].ruh04 = g_ruh_t.ruh04
                        NEXT FIELD ruh04
                     END IF
                     SELECT COUNT(*) INTO l_cnt FROM ruh_file
                     WHERE ruh01 = g_rti.rti01
                       AND ruh02 = g_ruh[l_ac].ruh02
                       AND ruh04 = g_ruh[l_ac].ruh04
                     IF l_cnt >0 THEN
                       CALL cl_err(g_ruh[l_ac].ruh04,'art-935',0)
                       LET g_ruh[l_ac].ruh04 = g_ruh_t.ruh04
                       NEXT FIELD ruh04
                     ELSE 
                        SELECT gec02,gec04 INTO g_ruh[l_ac].gec02,g_ruh[l_ac].gec04
                          FROM gec_file 
                         WHERE gec01 = g_ruh[l_ac].ruh04 
                           AND gec011 = '2'
                       #TQC-C20070 Add Begin ---
                        IF NOT cl_null(g_ruh[l_ac].gec04) AND g_ruh[l_ac].gec04>0 THEN
                           LET g_ruh[l_ac].ruh06 = 0
                           CALL cl_set_comp_entry("ruh06",FALSE)
                        ELSE
                           CALL cl_set_comp_entry("ruh06",TRUE)
                        END IF
                       #TQC-C20070 Add End -----
                     END IF 
                  END IF                    
               END IF
            END IF  

        #TQC-C20070 Add Begin ---
         BEFORE FIELD ruh06
            IF NOT cl_null(g_ruh[l_ac].gec04) AND g_ruh[l_ac].gec04>0 THEN
               LET g_ruh[l_ac].ruh06 = 0
               CALL cl_set_comp_entry("ruh06",FALSE)
            ELSE
               CALL cl_set_comp_entry("ruh06",TRUE)
            END IF
        #TQC-C20070 Add End -----

         AFTER FIELD ruh06
            IF g_ruh[l_ac].gec04>0 THEN
              #CALL cl_set_comp_entry("ruh06",FALSE) #TQC-C20070 Mark 
            ELSE
               IF g_ruh[l_ac].ruh06 < 0 OR cl_null(g_ruh[l_ac].ruh06) THEN
                  CALL cl_err('','art-939',0)
                  NEXT FIELD ruh06
               END IF         
              #TQC-C30076 add START
              #CALL t100_chk_rtj21(g_ruh[l_ac].ruh02,'',g_ruh[l_ac].ruh04,g_ruh[l_ac].ruh06)   #FUN-D30050 mark
               CALL t100_chk_rtj21(g_ruh[l_ac].ruh02,g_ruh[l_ac].rtj04,g_ruh[l_ac].ruh04,g_ruh[l_ac].ruh06)  #FUN-D30050 add
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_errno = ' '
                  NEXT FIELD ruh04
               END IF
              #TQC-C30076 add END
            END IF

         BEFORE DELETE 
            SELECT COUNT(*) INTO l_cnt FROM rtj_file
             WHERE rtj01 = g_rti.rti01
               AND rtj03 = g_ruh[l_ac].ruh02
               AND rtj21 = g_ruh[l_ac].ruh04
               AND rtj02 = '1' 
            IF g_cmd <> 'a' AND g_cmd <>'u' AND l_cnt>0 THEN
                CALL cl_err('','art-933',0)
                CANCEL DELETE
            END IF            
            IF g_ruh[l_ac].ruh04 = g_rtj[l_ac1].rtj21 AND (g_cmd = 'a' OR g_cmd = 'u') THEN
               CALL cl_err('','art-933',0)
               CANCEL DELETE
            END IF
            IF g_ruhk_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            IF cl_confirm('lib-001') THEN
               DELETE FROM ruh_file
                WHERE ruh01 = g_rti.rti01
                  AND ruh02 =  g_ruh[l_ac].ruh02
                  AND ruh03 =  g_ruh[l_ac].ruh03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ruh_file",g_rti.rti01,g_ruh[l_ac].ruh02,SQLCA.sqlcode,"","",1)
                  IF l_t = 'N' THEN
                     ROLLBACK WORK
                  END IF
                  CANCEL DELETE
               END IF
               LET g_cnt = g_cnt - 1
               DISPLAY g_cnt TO FORMONLY.cnt
            ELSE 
               CANCEL DELETE
            END IF
            IF l_t = 'N' THEN
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET g_ruh[l_ac].* = g_ruh_t.*
               CLOSE t100_ruh_bcl
               IF l_t = 'N' THEN
                  ROLLBACK WORK
               END IF
               EXIT INPUT
            END IF    
            IF g_ruhk_sw = 'Y' THEN
               CALL cl_err(g_ruh[l_ac].ruh03,-263,1)
               LET g_ruh[l_ac].* = g_ruh_t.*
            ELSE
               UPDATE ruh_file 
                  SET ruh01 = g_rti.rti01,
                      ruh02 = g_ruh[l_ac].ruh02,
                      ruh03 = g_ruh[l_ac].ruh03,
                      ruh04 = g_ruh[l_ac].ruh04,
                      ruh05 = '2',
                      ruh06 = g_ruh[l_ac].ruh06
                WHERE ruh01 = g_rti.rti01
                  AND ruh02 = g_ruh[l_ac].ruh02
                  AND ruh03 = g_ruh_t.ruh03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ruh_file",g_rti.rti01,g_ruh[l_ac].ruh02,SQLCA.sqlcode,'','',1)
                  LET g_ruh[l_ac].* = g_ruh_t.*
                  IF l_t = 'N' THEN
                     ROLLBACK WORK
                  END IF
               ELSE
                  MESSAGE 'UPDATE O.K'
                  IF l_t = 'N' THEN
                     COMMIT WORK
                  END IF
               END IF
            END IF  
          
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET g_ruh[l_ac].* = g_ruh_t.*
               CLOSE t100_ruh_bcl
               IF l_t = 'N' THEN
                  ROLLBACK WORK
               END IF
               EXIT INPUT
            END IF
            CLOSE t100_ruh_bcl
            IF l_t = 'N' THEN
               COMMIT WORK
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(ruh04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gec011"
                     LET g_qryparam.default1 = g_ruh[l_ac].ruh04
                     CALL cl_create_qry() RETURNING g_ruh[l_ac].ruh04
                     DISPLAY BY NAME g_ruh[l_ac].ruh04                   
                    NEXT FIELD ruh04
              OTHERWISE EXIT CASE
            END CASE        

         ON ACTION CONTROLG
            CALL cl_cmdask()
            
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG=0
      CALL cl_err('',9001,0)
   END IF

   CLOSE t100_ruh_bcl
   IF l_t = 'N' THEN
      COMMIT WORK
   END IF
   CLOSE WINDOW t121_a_w        
END FUNCTION 

FUNCTION t100_rtj10()
   DEFINE l_rtz05     LIKE rtz_file.rtz05

   #TQC-C20070--start mark----------------------------
   #IF g_rtj_1[l_ac2].rtj04_1 IS NOT NULL
   #   AND g_rtj_1[l_ac2].rtj09 IS NOT NULL THEN
   #   SELECT rtz05 INTO l_rtz05 
   #     FROM rtz_file 
   #    WHERE rtz01 = g_rti.rtiplant
   #TQC-C20070--end mark------------------------------

   #TQC-C20070--start add-----------------------------
   IF NOT cl_null(g_rtj_1[l_ac2].rtj04_1) AND 
      NOT cl_null(g_rtj_1[l_ac2].rtj09) AND 
      NOT cl_null(g_rtj_1[l_ac2].rtj24_1) THEN
   #TQC-C20070--end add-------------------------------  
     # IF NOT cl_null(l_rtz05) THEN                      #TQC-C20070 mark
      #SELECT rtg05,rtg06,rtg07,rtg08,rtg10              #FUN-C50036 mark
      SELECT rtg05,rtg06,rtg07,rtg08,rtg10,rtg11         #FUN-C50036 add
        INTO g_rtj_1[l_ac2].rtj10,g_rtj_1[l_ac2].rtj11,
             g_rtj_1[l_ac2].rtj12,g_rtj_1[l_ac2].rtj19,g_rtj_1[l_ac2].rtj23,
             g_rtj_1[l_ac2].rtj25                       #FUN-C50036 add
        FROM rtg_file
      # WHERE rtg01=l_rtz05                             #TQC-C20070 mark
       WHERE rtg01 = g_rtj_1[l_ac2].rtj24_1             #TQC-C20070 add 
         AND rtg03 = g_rtj_1[l_ac2].rtj04_1
         AND rtg04 = g_rtj_1[l_ac2].rtj09
      #END IF                                           #TQC-C20070 mark
       
      IF cl_null(g_rtj_1[l_ac2].rtj10) THEN 
         LET g_rtj_1[l_ac2].rtj10 = 0 
      END IF
      
      IF cl_null(g_rtj_1[l_ac2].rtj11) THEN 
         LET g_rtj_1[l_ac2].rtj11 = 0 
      END IF
      
      IF cl_null(g_rtj_1[l_ac2].rtj12) THEN
         LET g_rtj_1[l_ac2].rtj12 = 0 
      END IF
      
      IF cl_null(g_rtj_1[l_ac2].rtj19) THEN
         LET g_rtj_1[l_ac2].rtj19 = 'Y' 
      END IF
      
      IF cl_null(g_rtj_1[l_ac2].rtj23) THEN 
         LET g_rtj_1[l_ac2].rtj23 = 'N' 
      END IF
      #TQC-C20070--start add-----------------------------
      DISPLAY BY NAME g_rtj_1[l_ac2].rtj10,g_rtj_1[l_ac2].rtj11,
                      g_rtj_1[l_ac2].rtj12,g_rtj_1[l_ac2].rtj19,
                      g_rtj_1[l_ac2].rtj23 
      #TQC-C20070--end add-------------------------------
   END IF
END FUNCTION

FUNCTION t100_repate()
   DEFINE l_n    LIKE type_file.num5

   LET g_errno = ""
   IF cl_null(g_rtj_1[l_ac2].rtj04_1) OR g_rtj_1[l_ac2].rtj09 IS NULL THEN
      RETURN
   END IF

    #檢查單身中是否有重復的商品
   SELECT count(*) INTO l_n
     FROM rtj_file
    WHERE rtj01 = g_rti.rti01 
      AND rtj02 = '2'
      AND rtj04 = g_rtj_1[l_ac2].rtj04_1
      AND rtj09 = g_rtj_1[l_ac2].rtj09
      AND rtj24 = g_rtj_1[l_ac2].rtj24_1   #TQC-C30083 add
   IF l_n > 0 THEN
      LET g_errno = 'art-518'
   END IF
END FUNCTION

FUNCTION t100_rtj09()
   DEFINE l_gfe02     LIKE  gfe_file.gfe02
   DEFINE l_gfeacti   LIKE  gfe_file.gfeacti

   SELECT gfe02,gfeacti INTO g_rtj_1[l_ac2].rtj09_desc,l_gfeacti 
     FROM gfe_file
    WHERE gfe01 = g_rtj_1[l_ac2].rtj09

   CASE 
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-047'
      WHEN l_gfeacti = 'N' 
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
      DISPLAY g_rtj_1[l_ac2].rtj09_desc TO FORMONLY.rtj09_desc
   END CASE

END FUNCTION

FUNCTION t100_ryn03(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_ryn03_desc LIKE azp_file.azp02
 
   LET g_errno = ''

   LET g_sql= "SELECT COUNT(*) FROM azp_file WHERE azp01=? AND azp01 IN ",g_auth
   PREPARE azp_count FROM g_sql
   EXECUTE azp_count USING g_ryn[l_ac3].ryn03 INTO l_n
   IF l_n = 0 THEN 
      LET g_errno = 'art1033'
   END IF 

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT azp02 INTO g_ryn[l_ac3].ryn03_desc 
        FROM azp_file
       WHERE azp01 = g_ryn[l_ac3].ryn03 
      DISPLAY BY NAME g_ryn[l_ac3].ryn03_desc
   END IF
END FUNCTION

FUNCTION t100_ryn04(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_ima02 LIKE ima_file.ima02

   LET g_errno = " "

   IF g_ryn[l_ac3].ryn04[1,4] = 'MISC' THEN
      SELECT ima02,imaacti
        INTO l_ima02,l_imaacti
        FROM ima_file
       WHERE ima01 = 'MISC'
   ELSE
      SELECT ima02,imaacti
        INTO l_ima02,l_imaacti
        FROM ima_file
       WHERE ima01 = g_ryn[l_ac3].ryn04
   END IF

   CASE 
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-037'
      WHEN l_imaacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ryn[l_ac3].ryn04_desc = l_ima02
   END IF
END FUNCTION

FUNCTION t100_chk_in()
   DEFINE l_rtz04    LIKE rtz_file.rtz04
   DEFINE l_rte04    LIKE rte_file.rte04
   DEFINE l_rte07    LIKE rte_file.rte07

   LET g_errno = ""

   SELECT rtz04 INTO l_rtz04 
     FROM rtz_file
    WHERE rtz01 = g_ryn[l_ac3].ryn03

   IF cl_null(l_rtz04) THEN
      RETURN
   END IF
   
   SELECT rte04,rte07 INTO l_rte04,l_rte07 
     FROM rte_file
    WHERE rte01 = l_rtz04
    
   IF SQLCA.SQLCODE = 100 THEN
      LET g_errno = 'art-054'
   END IF
   
   IF cl_null(g_errno) THEN
      IF l_rte07 = 'N' THEN LET g_errno = 'art-522' END IF
   END IF
   
   IF cl_null(g_errno) THEN
      IF l_rte04 = 'N' THEN LET g_errno = 'art-523' END IF
   END IF
END FUNCTION

FUNCTION t100_ryn05()
   DEFINE l_ima913 LIKE ima_file.ima913
   DEFINE l_ima914 LIKE ima_file.ima914

   LET g_errno=''
   IF NOT cl_null(g_ryn[l_ac3].ryn04) THEN
      SELECT ima913,ima914
        INTO l_ima913,l_ima914
        FROM ima_file
       WHERE ima01 = g_ryn[l_ac3].ryn04
      IF l_ima913='Y' THEN
         IF g_ryn[l_ac3].ryn05 MATCHES '[24]' THEN
            CALL cl_set_comp_entry("ryn15",FALSE)
            LET g_ryn[l_ac3].ryn15 = l_ima914
            CALL t100_ryn15('d',g_ryn[l_ac3].ryn15)
         ELSE
            LET g_errno='art-119'
         END IF
      ELSE
         CALL cl_set_comp_entry("ryn15",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION t100_ryn06(p_cmd,p_ryn06)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE p_ryn06 LIKE ryn_file.ryn06
   DEFINE l_geu02 LIKE geu_file.geu02
   DEFINE l_geuacti LIKE geu_file.geuacti

   LET g_errno = ''
   SELECT geu02,geuacti INTO l_geu02,l_geuacti
     FROM geu_file
    WHERE geu01 = p_ryn06
      AND geu00 = '8'
   CASE 
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-188'
      WHEN l_geuacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ryn[l_ac3].ryn06_desc = l_geu02
      DISPLAY BY NAME g_ryn[l_ac3].ryn06_desc
   END IF
END FUNCTION

FUNCTION t100_ryn06_1(p_cmd,p_ryn06)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE p_ryn06 LIKE ryn_file.ryn06
   DEFINE l_geu02 LIKE geu_file.geu02
   DEFINE l_geuacti LIKE geu_file.geuacti

   LET g_errno = ''
   SELECT geu02,geuacti INTO l_geu02,l_geuacti
     FROM geu_file
    WHERE geu01 = p_ryn06
      AND geu00 = '8'
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-188'
      WHEN l_geuacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t100_ryn07_1(p_cmd,p_ryn07)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE p_ryn07   LIKE ryn_file.ryn07
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
   DEFINE l_ryn08   LIKE ryn_file.ryn08

   LET g_errno = ''
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = p_ryn07
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-312'
      WHEN l_pmcacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t100_ryn07(p_cmd,p_ryn07)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE p_ryn07   LIKE ryn_file.ryn07
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
   DEFINE l_dbs     LIKE azp_file.azp03
   DEFINE l_ryn08   LIKE ryn_file.ryn08

   LET g_errno = ''
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = p_ryn07
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-312'
      WHEN l_pmcacti='N' 
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) AND p_cmd <> 's' THEN
      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_ryn[l_ac3].ryn03
      LET g_sql =" SELECT DISTINCT rto06 ",
                   " FROM ",cl_get_target_table(g_ryn[l_ac3].ryn03, 'rtt_file'),",",
                    cl_get_target_table(g_ryn[l_ac3].ryn03, 'rts_file'),",", 
                    cl_get_target_table(g_ryn[l_ac3].ryn03, 'rto_file'),
                  " WHERE rtt04 = '",g_ryn[l_ac3].ryn04,"' ",
                  "   AND rttplant = '",g_ryn[l_ac3].ryn03,"' AND rtt15 = 'Y' ",
                  "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                  "   AND rto01 = rts04 AND rto03 = rts02  ",
                  "   AND rtsplant = '",g_ryn[l_ac3].ryn03,"' ",
                  "   AND rtsconf = 'Y' AND rto05 = '",g_ryn[l_ac3].ryn07,"' ",
                  "   AND rtoconf ='Y' ",
                  "   AND rto08 <= '",g_today,"' ",
                  "   AND rto09 >= '",g_today,"' ",
                  "   AND rtoplant = '",g_ryn[l_ac3].ryn03,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
      CALL cl_parse_qry_sql(g_sql, g_ryn[l_ac3].ryn03) RETURNING g_sql
      PREPARE rto06_cs FROM g_sql
      EXECUTE rto06_cs INTO l_ryn08
      IF l_ryn08 IS NULL THEN
         LET l_ryn08 = '1'
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ryn[l_ac3].ryn08 = l_ryn08
      DISPLAY BY NAME g_ryn[l_ac3].ryn08
   END IF
END FUNCTION

FUNCTION t100_ryn15(p_cmd,p_ryn15)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE p_ryn15   LIKE ryn_file.ryn15
   DEFINE l_geu02   LIKE geu_file.geu02
   DEFINE l_geuacti LIKE geu_file.geuacti

   LET g_errno = ''
   SELECT geu02,geuacti INTO l_geu02,l_geuacti
     FROM geu_file
    WHERE geu01 = p_ryn15
      AND geu00 = '4'
     
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-122'
      WHEN l_geuacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ryn[l_ac3].ryn15_desc = l_geu02
   END IF
END FUNCTION

FUNCTION t100_chk_flowno(p_flowno)
   DEFINE p_flowno LIKE poz_file.poz01
   DEFINE l_poz20  LIKE poz_file.poz20
   DEFINE l_n     LIKE type_file.num5

   IF NOT cl_null(p_flowno) THEN
      SELECT poz20 INTO l_poz20
        FROM poz_file
       WHERE poz01 = p_rvnn08
         AND poz00 = '2'
         AND pozacti = 'Y'
      IF l_poz20 = 'Y' THEN
        SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 = 'xxx'
          AND poy02 = (SELECT MIN(poy02) FROM poy_file
                                        WHERE poy01 = p_flowno)
       SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 = 'yyy'
          AND poy02 = (SELECT MAX(poy02) FROM poy_file
                                        WHERE poy01 = p_flowno)
     ELSE
       SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 <> 'xxx'
          AND poy02 = (SELECT MIN(poy02) FROM poy_file
                                        WHERE poy01 = p_flowno)
       SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 <> 'yyy'
          AND poy02 = (SELECT MAX(poy02) FROM poy_file
                                        WHERE poy01 = p_flowno)
     END IF
       IF l_n = 0 THEN
          LET g_errno = 'art-285'
       END IF
   END IF
END FUNCTION

FUNCTION t100_ruh_set_entry_b()
   IF g_before_input_done = FALSE THEN
      CALL cl_set_comp_entry("ruh04,ruh06",TRUE)
   END IF
END FUNCTION

FUNCTION  t100_ruh_set_no_entry_b()
   DEFINE  l_cnt LIKE type_file.num5
   IF g_ruh[l_ac].ruh04 = g_rtj[l_ac1].rtj21 AND 
                     (g_cmd = 'a' OR g_cmd = 'u')  THEN
      CALL cl_set_comp_entry("ruh04",FALSE)
   ELSE
      CALL cl_set_comp_required("ruh04",TRUE)
   END IF
   IF g_cmd = 'a' OR g_cmd = 'u' THEN
      CALL cl_set_comp_entry("ruh02",FALSE)
   END IF
   
   SELECT COUNT(*) INTO l_cnt 
     FROM rtj_file
    WHERE rtj01 = g_rti.rti01
      AND rtj03 = g_ruh[l_ac].ruh02
      AND rtj21 = g_ruh[l_ac].ruh04
      AND rtj02 = '1'
   IF g_cmd <> 'a' AND g_cmd <>'u' AND l_cnt>0 THEN
      CALL cl_set_comp_entry("ruh04",FALSE)
   ELSE
      CALL cl_set_comp_required("ruh04",TRUE)
   END IF
   IF g_ruh[l_ac].gec04 >0 THEN
      CALL cl_set_comp_entry("ruh06",FALSE)
  #TQC-C20070 Add Begin ---
   ELSE
      CALL cl_set_comp_entry("ruh06",TRUE)
  #TQC-C20070 Add End -----
   END IF
END FUNCTION

FUNCTION t100_b_init(p_cnt)
   DEFINE p_cnt LIKE type_file.num5

   SELECT azp02 INTO g_ryn[p_cnt].ryn03_desc
     FROM azp_file
    WHERE azp01 = g_ryn[p_cnt].ryn03
    
   SELECT ima02 INTO g_ryn[p_cnt].ryn04_desc
     FROM ima_file
    WHERE ima01 = g_ryn[p_cnt].ryn04
      AND imaacti = 'Y'
   IF g_ryn[p_cnt].ryn04[1,4] = 'MISC' THEN
      SELECT ima02 INTO g_ryn[p_cnt].ryn04_desc 
        FROM ima_file
       WHERE ima01 = 'MISC'
   END IF
    
   SELECT geu02 INTO g_ryn[p_cnt].ryn06_desc
     FROM geu_file
    WHERE geu01 = g_ryn[p_cnt].ryn06
      AND geu00='8'
      AND geuacti='Y'
      
   SELECT geu02 INTO g_ryn[p_cnt].ryn15_desc
     FROM geu_file
    WHERE geu01 = g_ryn[p_cnt].ryn15
      AND geu00='4'
      AND geuacti='Y'
END FUNCTION

FUNCTION t100_product()
   DEFINE l_n LIKE type_file.num10 

   IF s_shut(0) THEN 
      RETURN 
   END IF 
   
   IF cl_null(g_rti.rti01) THEN
      CALL cl_err('',-400,1)
      RETURN    
   END IF 

   DROP TABLE ruh_tmp  
   SELECT ruh03,ruh04,ruh06 FROM ruh_file WHERE 1=0 INTO TEMP ruh_tmp

   BEGIN WORK 
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN 
      CALL cl_err("OPEN t100_cl:",STATUS,0)
      CLOSE t100_cl
      ROLLBACK WORK 
      RETURN 
   END IF
   FETCH t100_cl INTO g_rti.rti01 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   OPEN WINDOW t100_1_w WITH FORM "art/42f/artt100_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("artt100_1") 
   
   LET tm1.rtj06 = 'Y'
   LET tm1.rtj07 = 'Y'
   LET tm1.rtj08 = 'Y'
   LET tm1.rtj20 = 'Y'
 
   CALL t100_1_askkey1()

   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t100_1_w
      RETURN 
   END IF   
   
   CLOSE WINDOW t100_1_w
   CALL s_showmsg_init()

   LET g_success = 'Y'
   LET g_success_sum= 0
   
   CALL t100_get_data1()

   IF g_success = 'Y' THEN
      COMMIT WORK 
      CALL cl_err('','',0)
   ELSE 
     #CALL s_showmsg()         #FUN-D30050 mark
      ROLLBACK WORK
      CALL cl_err('','',0)   
   END IF 
   CALL s_showmsg()            #FUN-D30050 add
   CLOSE t100_cl
   COMMIT WORK 
END FUNCTION 

FUNCTION t100_1_askkey1()
DEFINE l_n  LIKE type_file.num5 #TQC-C20070 Add

   DIALOG ATTRIBUTE (UNBUFFERED)
      CONSTRUCT BY NAME tm1.wc1 ON rtd01
         BEFORE CONSTRUCT 
            CALL cl_qbe_init()
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(rtd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rtd01"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " rtd03 = '",g_plant,"' AND rtdacti = 'Y' AND rtdconf = 'Y' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtd01
                  NEXT FIELD rtd01
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT   

      CONSTRUCT BY NAME tm1.wc2 ON ima01,ima131,ima1005,ima1006
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",g_rti.rtiplant)
                      RETURNING  g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01

               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima131_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131

               WHEN INFIELD(ima1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima1005"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1005
                  NEXT FIELD ima1005

               WHEN INFIELD(ima1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima1006"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1006
                  NEXT FIELD ima1006
                  
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
   END DIALOG

   IF INT_FLAG THEN
      RETURN
   END IF

   INITIALIZE g_rtj21_t TO NULL

   INPUT BY NAME tm1.rtj21,tm1.rtj06,tm1.rtj07,tm1.rtj08,tm1.rtj20 
                 WITHOUT DEFAULTS

      AFTER FIELD rtj21
         IF NOT cl_null(tm1.rtj21) THEN
            CALL t100_rtj21_p1()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rtj21
            END IF
           #TQC-C20070 Add Begin ---
            IF cl_null(g_rtj21_t) THEN
               LET g_rtj21_t = tm1.rtj21
            ELSE
               LET l_n = 0 
               SELECT COUNT(*) INTO l_n FROM ruh_tmp WHERE ruh04 = g_rtj21_t
               IF l_n > 0 AND g_rtj21_t <> tm1.rtj21 THEN
                  IF cl_confirm('art-975') THEN
                     DELETE FROM ruh_tmp WHERE ruh04 = g_rtj21_t
                  ELSE
                     LET tm1.rtj21 = g_rtj21_t
                     DISPLAY BY NAME tm1.rtj21
                     NEXT FIELD rtj21
                  END IF
               END IF
            END IF
            IF NOT t100_rtj21_chk() THEN
               NEXT FIELD rtj21
            END IF
            CALL artt100_p_a()
           #TQC-C20070 Add End -----
         END IF
         
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(rtj21)
               CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_gec011"    #TQC-C20070 Mark
               LET g_qryparam.form ="q_gec_rtj21" #TQC-C20070 Add
               LET g_qryparam.default1 = tm1.rtj21
               CALL cl_create_qry() RETURNING tm1.rtj21
               DISPLAY BY NAME tm1.rtj21
               NEXT FIELD rtj21
            OTHERWISE 
               EXIT CASE  
         END CASE
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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

      ON ACTION tax_detail
         CALL artt100_p_a()
   END INPUT
   
   IF INT_FLAG THEN
      RETURN
   END IF   
END FUNCTION 

FUNCTION t100_get_data1()
   DEFINE l_n      LIKE type_file.num10
   DEFINE l_sql    STRING 
   DEFINE l_rtj03  LIKE rtj_file.rtj03   
   DEFINE l_rtd03  LIKE rtd_file.rtd03
   DEFINE l_rtj21  LIKE rtj_file.rtj21 #TQC-C20070 Add
   DEFINE l_rtz04  LIKE rtz_file.rtz04 #TQC-C20070 Add

   LET g_sql = "SELECT rtd01 FROM rtd_file WHERE ",tm1.wc1 CLIPPED," AND rtd03 = '",g_plant,"' AND rtdconf = 'Y' " 
   DECLARE t100_ins_rtj11 CURSOR FROM g_sql 

   LET g_sql = "SELECT ima01 FROM ima_file WHERE ",tm1.wc2 CLIPPED," AND imaacti = 'Y' " 
  #TQC-C20070 Add Begin ---
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
   IF NOT cl_null(l_rtz04) THEN 
      LET g_sql = g_sql CLIPPED," AND ima01 IN (SELECT rte03 FROM rte_file WHERE rte01 = '",l_rtz04,"')"
   END IF
  ##TQC-C20070 Add End -----
   DECLARE t100_ins_rtj12 CURSOR FROM g_sql

   FOREACH t100_ins_rtj11 INTO g_rtj24
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
     #TQC-C20070 Add Begin ---
      CALL t100_gec07_chk()
      IF g_success = 'N' THEN
         CONTINUE FOREACH
      END IF
     #TQC-C20070 Add End -----

      FOREACH t100_ins_rtj12 INTO g_rtj04
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         SELECT count(*) INTO l_n 
           FROM rtj_file
          WHERE rtj24 = g_rtj24
            AND rtj04 = g_rtj04
            AND rtj02 = '1'
            AND rtj01 = g_rti.rti01

         IF l_n > 0 THEN 
            CONTINUE FOREACH 
         END IF    

        #FUN-D30050--add--str---
         CALL t100_chk_rtj21(0,g_rtj04,tm1.rtj21,0)
         IF NOT cl_null(g_errno) THEN
            CALL s_errmsg(tm1.rtj21,g_rtj04,g_rtj24,g_errno,1)
            CONTINUE FOREACH
         END IF
        #FUN-D30050--add--end---

         SELECT count(*) INTO l_n
           FROM rte_file
          WHERE rte01 = g_rtj24
            AND rte03 = g_rtj04
         IF cl_null(l_n) THEN LET l_n = 0 END IF
         
         IF l_n >0 THEN
            LET g_rtj05 = '2'
         ELSE 
            LET g_rtj05 = '1'   
         END IF 
         SELECT MAX(rtj03)+1 INTO l_rtj03
           FROM rtj_file
          WHERE rtj01 = g_rti.rti01
            AND rtj02 = '1'

         IF cl_null(l_rtj03) THEN LET l_rtj03 = 1 END IF 
         LET l_sql = "INSERT INTO rtj_file(rtj01,rtj02,rtj03,rtj04,rtj05, ",
                   "                     rtj06,rtj07,rtj08,rtj20,rtjplant, ",
                   "                     rtjlegal,rtj21,rtj22,rtj24)",              
                   " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
         PREPARE ins_rtj_pre1 FROM l_sql
         EXECUTE ins_rtj_pre1 USING g_rti.rti01,'1',l_rtj03,g_rtj04,g_rtj05,
                                    tm1.rtj06,tm1.rtj07,tm1.rtj08,tm1.rtj20,
                                    g_plant,g_legal,tm1.rtj21,'2',g_rtj24
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtj03',l_rtj03,'ins rtj',SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE
           #TQC-C20070 Add Begin ---
            CALL t100_ins_ruh(l_rtj03)
            IF g_success = 'Y' THEN
           #TQC-C20070 Add End -----
               LET g_success_sum = g_success_sum + 1  #成功新增筆數
            END IF #TQC-C20070 Add
        END IF                           
      END FOREACH   
   END FOREACH  
END FUNCTION 

FUNCTION t100_price()
   DEFINE l_n LIKE type_file.num10 

   IF s_shut(0) THEN 
      RETURN 
   END IF 
   
   IF cl_null(g_rti.rti01) THEN
      CALL cl_err('',-400,1)
      RETURN    
   END IF 

   BEGIN WORK 
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN 
      CALL cl_err("OPEN t100_cl:",STATUS,0)
      CLOSE t100_cl
      ROLLBACK WORK 
      RETURN 
   END IF
   FETCH t100_cl INTO g_rti.rti01 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   OPEN WINDOW t100_2_w WITH FORM "art/42f/artt100_2"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("artt100_2") 

   LET tm2.rtj19 = 'N'
   LET tm2.rtj23 = 'N'
   LET tm2.rtj20 = 'Y' 
   CALL t100_2_askkey()

   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t100_2_w
      RETURN 
   END IF   
   
   CLOSE WINDOW t100_2_w
   CALL s_showmsg_init()

   LET g_success = 'Y'
   LET g_success_sum= 0
   
   CALL t100_get_data2()

   IF g_success = 'Y' THEN
      COMMIT WORK 
      CALL cl_err('','',0)
   ELSE 
     #CALL s_showmsg()            #TQC-D40044 mark
      ROLLBACK WORK
      CALL cl_err('','',0)   
   END IF 
   CALL s_showmsg()               #TQC-D40044 add
   CLOSE t100_cl
   COMMIT WORK 
END FUNCTION 

FUNCTION t100_2_askkey()
   
   DIALOG ATTRIBUTE (UNBUFFERED)
      CONSTRUCT BY NAME tm2.wc1 ON rtf01
         BEFORE CONSTRUCT 
            CALL cl_qbe_init()
            
         ON ACTION controlp
           CASE
              WHEN INFIELD(rtf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtf01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " rtf03 = '",g_plant,"' AND rtfacti = 'Y' AND rtfconf = 'Y' "  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtf01
                 NEXT FIELD rtf01
              OTHERWISE
                 EXIT CASE
           END CASE
      END CONSTRUCT   

      CONSTRUCT BY NAME tm2.wc2 ON ima01,ima131,ima1005,ima1006
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",g_rti.rtiplant)
                      RETURNING  g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01

               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima131_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131

               WHEN INFIELD(ima1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima1005"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1005
                  NEXT FIELD ima1005

               WHEN INFIELD(ima1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima1006"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1006
                  NEXT FIELD ima1006
                  
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
   END DIALOG

   IF INT_FLAG THEN
      RETURN
   END IF

   INPUT BY NAME tm2.rtj09,tm2.rtj16,tm2.rtj17,tm2.rtj18,tm2.rtj19,
                 tm2.rtj23,tm2.rtj20 
                 WITHOUT DEFAULTS
      AFTER FIELD rtj16
         IF NOT cl_null(tm2.rtj16) THEN
            IF tm2.rtj16 <= 0 THEN
               CALL cl_err('','art-180',0)
               NEXT FIELD rtj16
            END IF 
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(rtj09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = tm2.rtj09
               CALL cl_create_qry() RETURNING tm2.rtj09
               DISPLAY tm2.rtj09 TO rtj09
               NEXT FIELD rtj09
            OTHERWISE 
               EXIT CASE  
         END CASE
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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
      RETURN
   END IF   
END FUNCTION 

FUNCTION t100_get_data2()
   DEFINE l_n      LIKE type_file.num10
   DEFINE l_sql    STRING 
   DEFINE l_rtj03  LIKE rtj_file.rtj03   
   DEFINE l_rtf03  LIKE rtf_file.rtf03
   DEFINE l_rtz04  LIKE rtz_file.rtz04 #TQC-C20070 add
   DEFINE l_rtj25  LIKE rtj_file.rtj25 #FUN-C80076 add
   DEFINE l_ima25  LIKE ima_file.ima25      #TQC-D40044 add
   DEFINE l_flag   LIKE type_file.chr1      #TQC-D40044 add
   DEFINE l_fac    LIKE type_file.num20_6   #TQC-D40044 add
   LET g_sql = "SELECT rtf01 FROM rtf_file WHERE ",tm2.wc1 CLIPPED," AND rtf03 = '",g_plant,"'  AND rtfconf = 'Y' " 
   DECLARE t100_ins_rtj21 CURSOR FROM g_sql 

   LET g_sql = "SELECT ima01 FROM ima_file WHERE ",tm2.wc2 CLIPPED," AND imaacti = 'Y' " 
  #TQC-C20070 Add Begin ---
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
   IF NOT cl_null(l_rtz04) THEN 
      LET g_sql = g_sql CLIPPED," AND ima01 IN (SELECT rte03 FROM rte_file WHERE rte01 = '",l_rtz04,"')"
   END IF
  ##TQC-C20070 Add End -----
   DECLARE t100_ins_rtj22 CURSOR FROM g_sql

   FOREACH t100_ins_rtj21 INTO g_rtj24
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      FOREACH t100_ins_rtj22 INTO g_rtj04
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         IF NOT s_chk_item_no(g_rtj04,"") THEN         
            CONTINUE FOREACH
         END IF   
 
        #TQC-D40044--add--str---
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rtj04
         IF l_ima25 != tm2.rtj09 THEN
            CALL s_umfchk(g_rtj04,l_ima25,tm2.rtj09) RETURNING l_flag,l_fac
            IF l_flag = 1 THEN
               CALL s_errmsg('ima01',g_rtj04,'','art-214',1)  
               CONTINUE FOREACH
            END IF
         END IF
        #TQC-D40044--add--end---

         SELECT count(*) INTO l_n 
           FROM rtj_file
          WHERE rtj24 = g_rtj24
            AND rtj04 = g_rtj04
            AND rtj02 = '1'
            AND rtj01 = g_rti.rti01

         IF l_n > 0 THEN 
            CONTINUE FOREACH 
         END IF    

         SELECT count(*) INTO l_n
           FROM rtg_file
          WHERE rtg01 = g_rtj24
            AND rtg03 = g_rtj04
            AND rtg04 = tm2.rtj09 #TQC-C20070 Add
         IF cl_null(l_n) THEN LET l_n = 0 END IF
         
         IF l_n >0 THEN
            LET g_rtj05 = '2'
         ELSE 
            LET g_rtj05 = '1'   
         END IF 
         SELECT MAX(rtj03)+1 INTO l_rtj03
           FROM rtj_file
          WHERE rtj01 = g_rti.rti01
            AND rtj02 = '2'

         IF cl_null(l_rtj03) THEN LET l_rtj03 = 1 END IF 
         LET l_rtj25 = 0 #FUN-C80076 add
         
         LET l_sql = "INSERT INTO rtj_file(rtj01,rtj02,rtj03,rtj04,rtj05,rtj09,",
                   "                      rtj16,rtj17,rtj18,rtj19,rtj23,rtj20,",
                   "                      rtjplant,rtjlegal,rtj22,rtj24,rtj25)", #FUN-C80076 add rtj25              
                   " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" #FUN-C80076 add 1?
         PREPARE ins_rtj_pre2 FROM l_sql
         EXECUTE ins_rtj_pre2 USING g_rti.rti01,'2',l_rtj03,g_rtj04,g_rtj05,
                                    tm2.rtj09,tm2.rtj16,tm2.rtj17,tm2.rtj18,
                                    tm2.rtj19,tm2.rtj23,tm2.rtj20,g_plant,
                                    g_legal,'2',g_rtj24,l_rtj25  #FUN-C80076 add l_rtj25
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtj03',l_rtj03,'ins rtj',SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE
            LET g_success_sum = g_success_sum + 1  #成功新增筆數
         END IF                           
      END FOREACH   
   END FOREACH  
END FUNCTION 

FUNCTION t100_purchase()
   DEFINE l_n LIKE type_file.num10 

   IF s_shut(0) THEN 
      RETURN 
   END IF 
   
   IF cl_null(g_rti.rti01) THEN
      CALL cl_err('',-400,1)
      RETURN    
   END IF 

   BEGIN WORK 
   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN 
      CALL cl_err("OPEN t100_cl:",STATUS,0)
      CLOSE t100_cl
      ROLLBACK WORK 
      RETURN 
   END IF
   FETCH t100_cl INTO g_rti.rti01 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   OPEN WINDOW t100_3_w WITH FORM "art/42f/artt100_3"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("artt100_3") 

   LET tm3.ryn14 = 'Y' 
   CALL t100_3_askkey()

   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW t100_3_w
      RETURN 
   END IF   
   
   CLOSE WINDOW t100_3_w
   CALL s_showmsg_init()

   LET g_success = 'Y'
   LET g_success_sum= 0
   
   CALL t100_get_data3()

   IF g_success = 'Y' THEN
      COMMIT WORK 
      CALL cl_err('','',0)
   ELSE 
      CALL s_showmsg()
      ROLLBACK WORK
      CALL cl_err('','',0)   
   END IF 
   CLOSE t100_cl
   COMMIT WORK 
END FUNCTION 

FUNCTION t100_3_askkey()
   DEFINE l_rtz05        LIKE rtz_file.rtz05
   DEFINE l_flowno       LIKE poz_file.poz01   

   DIALOG ATTRIBUTE (UNBUFFERED)
      CONSTRUCT BY NAME tm3.wc1 ON azp01
         BEFORE CONSTRUCT 
            CALL cl_qbe_init()
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(azp01)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_azp"
                  LET g_qryparam.form = "q_azw01_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azp01
                  NEXT FIELD azp01
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT   

      CONSTRUCT BY NAME tm3.wc2 ON ima01,ima131,ima1005,ima1006
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",g_rti.rtiplant) 
                      RETURNING  g_qryparam.multiret  
                  DISPLAY g_qryparam.multiret TO ima01   
                  NEXT FIELD ima01

               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima131_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131

               WHEN INFIELD(ima1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima1005"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1005
                  NEXT FIELD ima1005

               WHEN INFIELD(ima1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima1006"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1006
                  NEXT FIELD ima1006
                  
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
   END DIALOG

   IF INT_FLAG THEN
      RETURN
   END IF

   INPUT BY NAME tm3.ryn05,tm3.ryn06,tm3.ryn15,tm3.ryn07,tm3.ryn09,tm3.ryn10,
                 tm3.ryn12,tm3.ryn13,tm3.ryn14  
                 WITHOUT DEFAULTS
                 
      AFTER FIELD ryn05 #採購類型
         IF NOT cl_null(tm3.ryn05) THEN
            IF tm3.ryn05 MATCHES '[24]' THEN
               CALL cl_set_comp_entry("ryn15",FALSE)
            ELSE
               CALL cl_set_comp_entry("ryn15",TRUE)  
            END IF
            CALL t100_ryn05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ryn05
            END IF
         END IF

      AFTER FIELD ryn06
        IF NOT cl_null(tm3.ryn06) THEN
           CALL t100_ryn06_1('a',tm3.ryn06)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(tm3.ryn06,g_errno,0)
              LET tm3.ryn06 = NULL 
              NEXT FIELD ryn06
           END IF
        END IF

      AFTER FIELD ryn15   #採購中心
         IF NOT cl_null(tm3.ryn15) THEN 
            CALL t100_ryn15('a',tm3.ryn15)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm3.ryn15,g_errno,0)
               LET tm3.ryn15 = g_ryn_t.ryn15
               NEXT FIELD ryn15
            END IF
         END IF     

      AFTER FIELD ryn07 #主供商
         IF NOT cl_null(tm3.ryn07) THEN
            CALL t100_ryn07_1('a',tm3.ryn07)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm3.ryn07,g_errno,0)
               LET tm3.ryn07 = g_ryn_t.ryn07
               DISPLAY BY NAME tm3.ryn07
               NEXT FIELD ryn07
            END IF
         END IF     

      AFTER FIELD ryn09,ryn10
         IF FGL_DIALOG_GETBUFFER()<0 THEN
            CALL cl_err('','aic-005',0)
            NEXT FIELD CURRENT
         END IF   

      AFTER FIELD ryn12,ryn13
         LET l_flowno = FGL_DIALOG_GETBUFFER()
         IF NOT cl_null(l_flowno) THEN
            CALL t100_chk_flowno(l_flowno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD CURRENT
            END IF
         END IF
          
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(ryn06)  #配送中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.arg1='8'
                 LET g_qryparam.default1 = tm3.ryn06
                 CALL cl_create_qry() RETURNING tm3.ryn06
                 DISPLAY BY NAME tm3.ryn06
                 NEXT FIELD ryn06

            WHEN INFIELD(ryn15)  #採購中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.default1 = tm3.ryn15
                 CALL cl_create_qry() RETURNING tm3.ryn15
                 DISPLAY BY NAME tm3.ryn15
                 NEXT FIELD ryn15     

            WHEN INFIELD(ryn07)  #主供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc2"
                 LET g_qryparam.default1 = tm3.ryn07
                 CALL cl_create_qry() RETURNING tm3.ryn07
                 DISPLAY BY NAME tm3.ryn07
                 NEXT FIELD ryn07 

            WHEN INFIELD(ryn12)  #採購多角貿易流程代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz01"
                 LET g_qryparam.default1 = tm3.ryn12
                 CALL cl_create_qry() RETURNING tm3.ryn12
                 DISPLAY BY NAME tm3.ryn12
                 NEXT FIELD ryn12

             WHEN INFIELD(ryn13)  #退貨多角貿易流程代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz01"
                 LET g_qryparam.default1 = tm3.ryn13
                 CALL cl_create_qry() RETURNING tm3.ryn13
                 DISPLAY BY NAME tm3.ryn13
                 NEXT FIELD ryn13        
            OTHERWISE 
               EXIT CASE  
         END CASE
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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
      RETURN
   END IF   
END FUNCTION 

FUNCTION t100_get_data3()
   DEFINE l_n      LIKE type_file.num10
   DEFINE l_sql    STRING 
   DEFINE l_ryn08  LIKE ryn_file.ryn08   
   DEFINE l_dbs    LIKE azp_file.azp03
   DEFINE l_rtz04  LIKE rtz_file.rtz04 #TQC-C20070 add

   LET g_sql = "SELECT azp01 FROM azp_file WHERE ",tm3.wc1 CLIPPED," AND azp01 IN", g_auth 
   DECLARE t100_ins_ryn1 CURSOR FROM g_sql 

  #LET g_sql = "SELECT ima01 FROM ima_file WHERE ",tm3.wc2 CLIPPED," AND imaacti = 'Y' "                  #TQC-C20357 Mark
   LET g_sql = "SELECT ima01 FROM ima_file WHERE ",tm3.wc2 CLIPPED," AND imaacti = 'Y' AND ima120 = '1' " #TQC-C20357 Add
  #TQC-C20070 Add Begin ---
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_plant
   IF NOT cl_null(l_rtz04) THEN 
      LET g_sql = g_sql CLIPPED," AND ima01 IN (SELECT rte03 FROM rte_file WHERE rte01 = '",l_rtz04,"')"
   END IF
  ##TQC-C20070 Add End -----
   DECLARE t100_ins_ryn2 CURSOR FROM g_sql

   FOREACH t100_ins_ryn1 INTO g_ryn03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      FOREACH t100_ins_ryn2 INTO g_ryn04
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         SELECT count(*) INTO l_n 
           FROM ryn_file
          WHERE ryn03 = g_ryn03
            AND ryn04 = g_ryn04
            AND ryn01 = g_rti.rti01

         IF l_n > 0 THEN 
            CONTINUE FOREACH 
         END IF    

         SELECT count(*) INTO l_n
           FROM rty_file
          WHERE rty01 = g_rtj24
            AND rty02 = g_rtj04
         IF cl_null(l_n) THEN LET l_n = 0 END IF
         
         IF l_n >0 THEN
            LET g_ryn02 = '1'
         ELSE 
            LET g_ryn02 = '2'   
         END IF 
         
         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_ryn03
         LET g_sql =" SELECT DISTINCT rto06 ",
                    " FROM ",cl_get_target_table(g_ryn03, 'rtt_file'),",",
                    cl_get_target_table(g_ryn03, 'rts_file'),",",
                    cl_get_target_table(g_ryn03, 'rto_file'),
                  " WHERE rtt04 = '",g_ryn04,"' ",
                  "   AND rttplant = '",g_ryn03,"' AND rtt15 = 'Y' ",
                  "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                  "   AND rto01 = rts04 AND rto03 = rts02  ",
                  "   AND rtsplant = '",g_ryn03,"' ",
                  "   AND rtsconf = 'Y' AND rto05 = '",tm3.ryn07,"' ",
                  "   AND rtoconf ='Y' ",
                  "   AND rto08 <= '",g_today,"' ",
                  "   AND rto09 >= '",g_today,"' ",
                  "   AND rtoplant = '",g_ryn03,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql, g_ryn03) RETURNING g_sql
         PREPARE rto06_cs1 FROM g_sql
         EXECUTE rto06_cs1 INTO l_ryn08
         IF l_ryn08 IS NULL THEN
            LET l_ryn08 = '1'
         END IF

         LET l_sql = "INSERT INTO ryn_file(ryn01,ryn02,ryn03,ryn04,ryn05,ryn06,",
                   "                      ryn07,ryn08,ryn09,ryn10,ryn12,ryn13,ryn14,",
                   "                      ryn15,rynplant,rynlegal)",              
                   " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
         PREPARE ins_ryn_pre1 FROM l_sql
         EXECUTE ins_ryn_pre1 USING g_rti.rti01,g_ryn02,g_ryn03,g_ryn04,tm3.ryn05,
                                    tm3.ryn06,tm3.ryn07,l_ryn08,tm3.ryn09,tm3.ryn10,
                                    tm3.ryn12,tm3.ryn13,tm3.ryn14,tm3.ryn15,
                                    g_plant,g_legal
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('ryn03',g_ryn03,'ins ryn',SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE
            LET g_success_sum = g_success_sum + 1  #成功新增筆數
         END IF                           
      END FOREACH   
   END FOREACH  
END FUNCTION 

FUNCTION t100_get_author()
   DEFINE l_azw01 LIKE azw_file.azw01

   LET g_sql = "SELECT azw01 FROM azw_file WHERE azw07 = '",g_rti.rtiplant,"'",
               "   AND azwacti = 'Y' "
   PREPARE pre_azw FROM g_sql
   DECLARE cur1_azw CURSOR FOR pre_azw

   LET g_author = " ('"
   FOREACH cur1_azw INTO l_azw01
      IF l_azw01 IS NULL THEN CONTINUE FOREACH END IF
      LET g_author = g_author,l_azw01,"','"
   END FOREACH

   LET g_author = g_author[1,LENGTH(g_author)-2]
   IF LENGTH(g_author) != 0 THEN
      LET g_author = g_author,") "
   END IF
END FUNCTION

FUNCTION  t100_rtj21_p1()
   DEFINE l_gec02     LIKE gec_file.gec02
   DEFINE l_gecacti   LIKE gec_file.gecacti
   DEFINE l_gec07_old LIKE gec_file.gec07 #TQC-C20270 Add
   DEFINE l_gec07_new LIKE gec_file.gec07 #TQC-C20270 Add

   LET g_errno = ''
   SELECT gec02,gecacti INTO l_gec02,l_gecacti
     FROM gec_file
    WHERE gec01 = tm1.rtj21
      AND gec011 = '2'

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'art-931'
      WHEN l_gecacti = 'N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

#TQC-C20270 Add Begin ---
   IF cl_null(g_errno) AND NOT cl_null(g_rtj21_t) AND NOT cl_null(tm1.rtj21) THEN
      IF g_rtj21_t <> tm1.rtj21 THEN
         SELECT DISTINCT gec07 INTO l_gec07_old 
           FROM gec_file 
          WHERE gec01 IN (SELECT ruh04 
                            FROM ruh_tmp 
                           WHERE ruh04 <> g_rtj21_t)
            AND gec011 = '2'
         SELECT DISTINCT gec07 INTO l_gec07_new 
           FROM gec_file 
          WHERE gec01 = tm1.rtj21 AND gec011 = '2'
         IF NOT cl_null(l_gec07_old) AND NOT cl_null(l_gec07_new) THEN
            IF l_gec07_old <> l_gec07_new THEN
               LET g_errno = 'art1048'
            END IF
         END IF
      END IF
   END IF
#TQC-C20270 Add End -----
END FUNCTION

FUNCTION t100_ch()
   IF s_shut(0) THEN
      RETURN
   END IF 

   IF cl_null(g_rti.rti01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_rti.* FROM rti_file WHERE rti01 = g_rti.rti01

   IF g_rti.rti900 = '0' THEN CALL cl_err('','art-124',0) RETURN END IF
   IF g_rti.rti900 = '2' THEN CALL cl_err('','art-125',0) RETURN END IF
   IF g_rti.rti02 = '2' AND g_rti.rti03 <> g_today THEN CALL cl_err('','art-126',0) RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF

   IF NOT cl_confirm('alm-207') THEN RETURN END IF

   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success = 'Y'

   OPEN t100_cl USING g_rti.rti01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t100_cl INTO g_rti.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rti.rti01,SQLCA.sqlcode,0)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF

   UPDATE rti_file SET rti900 = '2'
    WHERE rti01 = g_rti.rti01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('rti01',g_rti.rti01,'upd rti_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   
   CALL t100_sub(g_rti.rti01,g_plant)

   IF g_success = 'Y' THEN
      LET g_rti.rti900 = '2'
      COMMIT WORK
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
   END IF

   DISPLAY BY NAME g_rti.rti900
END FUNCTION

#TQC-C20070 Add Begin ---
FUNCTION t100_gec07_chk()
DEFINE l_gec07_old LIKE gec_file.gec07
DEFINE l_gec07_new LIKE gec_file.gec07
DEFINE l_sql       STRING

   SELECT DISTINCT gec07 INTO l_gec07_old 
     FROM gec_file 
    WHERE gec01 IN (SELECT rvy04 FROM rvy_file WHERE rvy01 = g_rtj24)
   LET l_sql = "SELECT DISTINCT gec07 FROM gec_file WHERE gec01 IN (SELECT ruh04 FROM ruh_tmp)"
   PREPARE sel_gec07_chk FROM l_sql
   EXECUTE sel_gec07_chk INTO l_gec07_new
   IF l_gec07_old <> l_gec07_new THEN
      CALL s_errmsg('rtj24',g_rtj24,'','art1047',1)
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION t100_rtj21_chk()
DEFINE l_rtj21     LIKE rtj_file.rtj21
DEFINE l_n         LIKE type_file.num5
DEFINE l_ruh03     LIKE ruh_file.ruh03

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ruh_tmp WHERE ruh04 = tm1.rtj21
   IF l_n = 0 THEN
      SELECT MAX(ruh03)+1 INTO l_ruh03 FROM ruh_tmp
      IF cl_null(l_ruh03) THEN LET l_ruh03 = 1 END IF
      INSERT INTO ruh_tmp (ruh03,ruh04,ruh06) VALUES (l_ruh03,tm1.rtj21,0)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('ins ruh_tmp',SQLCA.sqlcode,0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t100_ins_ruh(p_rtj03)
DEFINE p_rtj03       LIKE rtj_file.rtj03
DEFINE l_ruh         RECORD LIKE ruh_file.*
DEFINE l_sql         STRING

   LET l_sql = "SELECT ruh03,ruh04,ruh06 FROM ruh_tmp ORDER BY ruh03"
   PREPARE sel_ruh_pre2 FROM l_sql
   DECLARE sel_ruh_cs2 CURSOR FOR sel_ruh_pre2
   FOREACH sel_ruh_cs2 INTO l_ruh.ruh03,l_ruh.ruh04,l_ruh.ruh06
      LET l_ruh.ruh01 = g_rti.rti01
      LET l_ruh.ruh02 = p_rtj03
      LET l_ruh.ruh05 = '2'
      LET l_ruh.ruhlegal = g_legal
      LET l_ruh.ruhplant = g_plant
     #FUN-D30050--add--str---
      CALL t100_chk_rtj21(0,g_rtj04,l_ruh.ruh04,l_ruh.ruh06)
      IF NOT cl_null(g_errno) THEN
         CALL s_errmsg(l_ruh.ruh04,g_rtj04,'ins ruh',g_errno,1)
         CONTINUE FOREACH
      END IF
     #FUN-D30050--add--end---
      INSERT INTO ruh_file VALUES(l_ruh.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('','','ins ruh',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      INITIALIZE l_ruh.* TO NULL
   END FOREACH
END FUNCTION
#TAC-C20070 Add End -----

#TQC-C20070 Add Begin ---
FUNCTION  artt100_p_a()
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_ruh_ak_sw     LIKE type_file.chr1
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_gecacti       LIKE gec_file.gecacti
      
   LET l_ac_p =1

   DECLARE sel_ruh_tmp_cs CURSOR FOR
      SELECT ruh03,ruh04,'','',ruh06
        FROM ruh_tmp
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare sel_ruh_tmp_cs',SQLCA.sqlcode,1)
      RETURN
   END IF 
    
   CALL g_ruh_a.clear()
   LET g_cnt = 1
   FOREACH sel_ruh_tmp_cs INTO g_ruh_a[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach sel_ruh_tmp_cs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      SELECT gec02,gec04
        INTO g_ruh_a[g_cnt].gec02,g_ruh_a[g_cnt].gec04 
        FROM gec_file 
       WHERE gec01 = g_ruh_a[g_cnt].ruh04
         AND gec011 = '2'
      LET g_cnt = g_cnt + 1
   END FOREACH  
   CALL g_ruh_a.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1

   OPEN WINDOW t100_a_w WITH FORM "art/42f/artt100_a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("artt100_a")
   DISPLAY g_cnt TO FORMONLY.cnt
   DISPLAY ARRAY g_ruh_a TO s_ruh_a.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
        IF g_rti.rticonf = 'N' THEN
           EXIT DISPLAY
        END IF
   END DISPLAY
   IF g_rti.rticonf <> 'N' THEN
      CLOSE WINDOW t100_a_w
      RETURN
   END IF
      
   LET g_forupd_sql = " SELECT ruh03,ruh04,'','',ruh06 ",
                      "   FROM ruh_tmp ",
                      "  WHERE ruh03 = ? ",
                      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE sel_ruh_tmp_bcl CURSOR FROM g_forupd_sql
         
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare sel_ruh_tmp_bcl',SQLCA.sqlcode,1)
      CLOSE WINDOW t100_a_w
      RETURN
   END IF   
            
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
           
   INPUT ARRAY g_ruh_a WITHOUT DEFAULTS FROM s_ruh_a.*
      ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
               INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
               APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_ac_p)
         END IF
      BEFORE ROW
         LET l_ac_p = ARR_CURR()
         LET g_ruh_ak_sw = 'N'
         LET l_n  = ARR_COUNT()

         IF g_cnt >= l_ac_p THEN
            LET p_cmd = 'u'
            LET g_ruh_a_t.* = g_ruh_a[l_ac_p].*
            OPEN sel_ruh_tmp_bcl USING g_ruh_a_t.ruh03
            IF STATUS THEN
               CALL cl_err("OPEN sel_ruh_tmp_bcl:", STATUS, 1)
               LET g_ruh_ak_sw = "Y"
            END IF
            FETCH sel_ruh_tmp_bcl INTO g_ruh_a[l_ac_p].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ruh_a_t.ruh03,SQLCA.sqlcode,1)
               LET g_ruh_ak_sw = "Y"
            END IF
            SELECT gec02,gec04
              INTO g_ruh_a[l_ac_p].gec02,g_ruh_a[l_ac_p].gec04
              FROM gec_file
             WHERE gec01 = g_ruh_a[l_ac_p].ruh04
               AND gec011 = '2'
            IF NOT cl_null(g_ruh_a[l_ac_p].gec04) AND g_ruh_a[l_ac_p].gec04>0 THEN
               LET g_ruh_a[l_ac_p].ruh06 = 0
               CALL cl_set_comp_entry("ruh06",FALSE)
            ELSE
               CALL cl_set_comp_entry("ruh06",TRUE)
            END IF
            CALL cl_show_fld_cont()
         END IF
               
               
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ruh_a[l_ac_p].* TO NULL        
            SELECT MAX(ruh03)+1 INTO g_ruh_a[l_ac_p].ruh03 FROM ruh_tmp
            IF cl_null(g_ruh_a[l_ac_p].ruh03) THEN
               LET g_ruh_a[l_ac_p].ruh03 = 1
            END IF
            LET g_ruh_a[l_ac_p].ruh06 = '0'
            LET g_ruh_a_t.* = g_ruh_a[l_ac_p].*
            CALL cl_show_fld_cont()
            NEXT FIELD ruh03
              
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0) 
               CANCEL INSERT
            END IF
            
            INSERT INTO ruh_tmp(ruh03,ruh04,ruh06)
            VALUES(g_ruh_a[l_ac_p].ruh03,g_ruh_a[l_ac_p].ruh04,g_ruh_a[l_ac_p].ruh06)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ruh_tmp",'',g_ruh_a[l_ac_p].ruh03,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               LET g_cnt = g_cnt + 1
               DISPLAY g_cnt TO FORMONLY.cnt
            END IF

         AFTER FIELD ruh03
            IF NOT cl_null(g_ruh_a[l_ac_p].ruh03) THEN
               IF g_ruh_a[l_ac_p].ruh03 != g_ruh_a_t.ruh03 OR
                  g_ruh_a_t.ruh03 IS NULL THEN
                  SELECT COUNT(*) INTO l_cnt
                    FROM ruh_tmp
                   WHERE ruh03 = g_ruh_a[l_ac_p].ruh03
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_ruh_a[l_ac_p].ruh03,'-239',0)
                     LET g_ruh_a[l_ac_p].ruh03 = g_ruh_a_t.ruh03
                     NEXT FIELD ruh03
                  END IF
               END IF 
            END IF
               
         AFTER FIELD ruh04
            IF NOT cl_null(g_ruh_a[l_ac_p].ruh04) THEN
               IF g_ruh_a[l_ac_p].ruh04 != g_ruh_a_t.ruh04 OR
                  g_ruh_a_t.ruh04 IS NULL THEN
                  SELECT gecacti INTO l_gecacti
                    FROM gec_file
                   WHERE gec01 = g_ruh_a[l_ac_p].ruh04
                     AND gec011 = '2'   
                  IF STATUS =100 THEN
                     CALL cl_err(g_ruh_a[l_ac_p].ruh04,'art-931',0)
                     LET g_ruh_a[l_ac_p].ruh04 = g_ruh_a_t.ruh04
                     NEXT FIELD ruh04
                  ELSE
                     IF l_gecacti = 'N' THEN
                        CALL cl_err('','9028',0)
                        LET g_ruh_a[l_ac_p].ruh04 = g_ruh_a_t.ruh04
                        NEXT FIELD ruh04
                     END IF 
                     SELECT COUNT(*) INTO l_cnt FROM ruh_tmp
                      WHERE ruh04 = g_ruh_a[l_ac_p].ruh04
                     IF l_cnt >0 THEN
                       CALL cl_err(g_ruh_a[l_ac_p].ruh04,'art-935',0)
                       LET g_ruh_a[l_ac_p].ruh04 = g_ruh_a_t.ruh04
                       NEXT FIELD ruh04
                     ELSE
                        IF NOT t100_p_chk_ruh04() THEN NEXT FIELD ruh04 END IF
                        SELECT gec02,gec04 INTO g_ruh_a[l_ac_p].gec02,g_ruh_a[l_ac_p].gec04
                          FROM gec_file 
                         WHERE gec01 = g_ruh_a[l_ac_p].ruh04
                           AND gec011 = '2'
                        IF NOT cl_null(g_ruh_a[l_ac_p].gec04) AND g_ruh_a[l_ac_p].gec04>0 THEN
                           LET g_ruh_a[l_ac_p].ruh06 = 0
                           CALL cl_set_comp_entry("ruh06",FALSE)
                        ELSE
                           CALL cl_set_comp_entry("ruh06",TRUE)
                        END IF
                     END IF 
                  END IF         
               END IF
            END IF   

         BEFORE FIELD ruh06
            IF NOT cl_null(g_ruh_a[l_ac_p].gec04) AND g_ruh_a[l_ac_p].gec04>0 THEN
               LET g_ruh_a[l_ac_p].ruh06 = 0
               CALL cl_set_comp_entry("ruh06",FALSE)
            ELSE
               CALL cl_set_comp_entry("ruh06",TRUE)
            END IF

                     
         AFTER FIELD ruh06
            IF g_ruh_a[l_ac_p].gec04>0 THEN
            ELSE
               IF g_ruh_a[l_ac_p].ruh06 < 0 OR cl_null(g_ruh_a[l_ac_p].ruh06) THEN
                  CALL cl_err('','art-939',0)
                  NEXT FIELD ruh06
               END IF
            END IF

         BEFORE DELETE
            IF g_ruh_ak_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            IF NOT cl_null(tm1.rtj21) AND tm1.rtj21 = g_ruh_a[l_ac_p].ruh04 THEN
               CALL cl_err("","art1050",1)
               CANCEL DELETE
            END IF
            IF cl_confirm('lib-001') THEN
               DELETE FROM ruh_tmp
                WHERE ruh03 = g_ruh_a[l_ac_p].ruh03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ruh_tmp",'',g_ruh_a[l_ac_p].ruh03,SQLCA.sqlcode,"","",1)
                  CANCEL DELETE
               END IF
               LET g_cnt = g_cnt - 1
               DISPLAY g_cnt TO FORMONLY.cnt
            ELSE
               CANCEL DELETE
            END IF
               
         ON ROW CHANGE 
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET g_ruh_a[l_ac_p].* = g_ruh_a_t.*
               CLOSE sel_ruh_tmp_bcl
               EXIT INPUT
            END IF    
            IF g_ruh_ak_sw = 'Y' THEN
               CALL cl_err(g_ruh_a[l_ac_p].ruh03,-263,1)
               LET g_ruh_a[l_ac_p].* = g_ruh_a_t.*
            ELSE
               UPDATE ruh_tmp
                  SET ruh03 = g_ruh_a[l_ac_p].ruh03,
                      ruh04 = g_ruh_a[l_ac_p].ruh04,
                      ruh06 = g_ruh_a[l_ac_p].ruh06
                WHERE ruh03 = g_ruh_a_t.ruh03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ruh_tmp",'',g_ruh_a[l_ac_p].ruh03,SQLCA.sqlcode,'','',1)
                  LET g_ruh_a[l_ac_p].* = g_ruh_a_t.*
               ELSE
                  IF NOT cl_null(tm1.rtj21) AND tm1.rtj21 <> g_ruh_a[l_ac_p].ruh04 AND tm1.rtj21 = g_ruh_a_t.ruh04 THEN
                     LET tm1.rtj21 = g_ruh_a[l_ac_p].ruh04
                     DISPLAY BY NAME tm1.rtj21
                  END IF
                  MESSAGE 'UPDATE O.K'
               END IF
            END IF  
            
         AFTER ROW
            LET l_ac_p = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET g_ruh_a[l_ac_p].* = g_ruh_a_t.*
               CLOSE sel_ruh_tmp_bcl
               EXIT INPUT
            END IF
            CLOSE sel_ruh_tmp_bcl

         ON ACTION controlp
            CASE
               WHEN INFIELD(ruh04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gec011"
                     LET g_qryparam.default1 = g_ruh_a[l_ac_p].ruh04
                     CALL cl_create_qry() RETURNING g_ruh_a[l_ac_p].ruh04
                     DISPLAY BY NAME g_ruh_a[l_ac_p].ruh04
                     NEXT FIELD ruh04
              OTHERWISE EXIT CASE
            END CASE

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG=0
      CALL cl_err('',9001,0)
   END IF
   CLOSE sel_ruh_tmp_bcl
   CLOSE WINDOW t100_a_w
END FUNCTION

FUNCTION t100_p_chk_ruh04()
DEFINE l_gec07_old LIKE gec_file.gec07
DEFINE l_gec07_new LIKE gec_file.gec07

   IF NOT cl_null(g_ruh_a_t.ruh04) THEN
      SELECT DISTINCT gec07 INTO l_gec07_old 
        FROM gec_file 
       WHERE gec01 IN (SELECT ruh04 
                         FROM ruh_tmp 
                        WHERE ruh04 <> g_ruh_a_t.ruh04) 
         AND gec011 = '2'
   ELSE
      SELECT DISTINCT gec07 INTO l_gec07_old
        FROM gec_file
       WHERE gec01 IN (SELECT ruh04
                         FROM ruh_tmp)
         AND gec011 = '2'
   END IF
   SELECT gec07 INTO l_gec07_new 
     FROM gec_file  
    WHERE gec01 = g_ruh_a[l_ac_p].ruh04 AND gec011 = '2'
   IF NOT cl_null(l_gec07_old) AND NOT cl_null(l_gec07_new) THEN
      IF l_gec07_old <> l_gec07_new THEN
         CALL cl_err('','art1048',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#TQC-C20070 Add End -----

#FUN-BC0076-----------------------------------------------------
#TQC-C30076 add START
FUNCTION t100_chk_rtj21(p_rtj03,p_rtj04,p_rtj21,p_ruh06)
DEFINE p_rtj03   LIKE rtj_file.rtj03
DEFINE p_rtj04   LIKE rtj_file.rtj04
DEFINE p_rtj21   LIKE rtj_file.rtj21
DEFINE p_ruh06   LIKE ruh_file.ruh06
DEFINE l_n       LIKE type_file.num10
DEFINE l_rtj04   LIKE rtj_file.rtj04
#DEFINE l_lpx26   LIKE lpx_file.lpx26  #FUN-D10040 mark
DEFINE l_lpx38    LIKE lpx_file.lpx38  #FUN-D10040 add
DEFINE l_lpx33   LIKE lpx_file.lpx33
DEFINE l_sql     STRING
DEFINE l_gec04   LIKE gec_file.gec04
   LET g_errno = ' '
   LET l_n = 0
   IF NOT cl_null(p_rtj04) THEN
      LET l_rtj04= p_rtj04
   ELSE
      SELECT rtj04 INTO l_rtj04 FROM rtj_file
        WHERE rtj03 = p_rtj03
          AND rtj01 = g_rti.rti01
   END IF
   IF cl_null(l_rtj04) THEN
      RETURN
   END IF
   IF cl_null(p_rtj21) THEN
      RETURN
   END IF
   IF cl_null(p_ruh06) THEN
      LET p_ruh06 = 0
   END IF
   SELECT COUNT(*) INTO l_n
         FROM lpx_file
         WHERE lpx32 = l_rtj04
   IF l_n > 0 THEN  #almi660內存在同產品料的資料
      #LET l_sql= "SELECT DISTINCT lpx26,lpx33 ",  #FUN-D10040 mark
      LET l_sql= "SELECT DISTINCT lpx38,lpx33 ",   #FUN-D10040 add
                 "  FROM lpx_file",
                 "    WHERE lpx32 = '",l_rtj04,"'"
      PREPARE t100_lpx_pre FROM l_sql
      DECLARE t100_lpx_cs CURSOR FOR t100_lpx_pre
      #FOREACH t100_lpx_cs INTO l_lpx26,l_lpx33    #FUN-D10040 mark
      FOREACH t100_lpx_cs INTO l_lpx38,l_lpx33     #FUN-D10040 add
         #IF l_lpx26 = '1' THEN  #已開發票的禮券   #FUN-D10040 mark
         IF l_lpx38 = 'Y' THEN   #已開發票的禮券   #FUN-D10040 add
            IF NOT cl_null(p_rtj21) THEN
               IF p_rtj21 <> l_lpx33 THEN
                  LET g_errno = 'alm-h18'
                  RETURN
               END IF
            END IF
         END IF
         #IF l_lpx26 = '2' THEN  #未開發票的禮券   #FUN-D10040 mark
         IF l_lpx38 = 'N' THEN   #已開發票的禮券   #FUN-D10040 add
            SELECT gec04 INTO l_gec04
              FROM gec_file
               WHERE gec01 = p_rtj21
                 AND gec011 = '2'
            IF NOT cl_null(l_gec04) AND l_gec04 > 0 THEN
               LET g_errno = 'alm-h17'
               RETURN
            END IF
            IF NOT cl_null(p_ruh06) AND p_ruh06 > 0 THEN
               LET g_errno = 'alm-h17'
               RETURN
            END IF
         END IF
      END FOREACH
   END IF
END FUNCTION
#TQC-C30076 add END



