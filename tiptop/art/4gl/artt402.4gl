# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt402.4gl
# Descriptions...: 一般促銷變更維護作業
# Date & Author..: No.FUN-A70048 10/07/14 By Cockroach 
# Modify.........: No.FUN-AA0059 10/10/29 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0033 10/11/10 By wangxin  促銷BUG調整
# Modify.........: No.FUN-AB0101 10/11/26 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號
# Modify.........: No.MOD-AC0179 10/12/18 By shenyang 修改5.25CT1 bug
# Modify.........: No.MOD-AC0190 10/12/20 By shenyang 修改5.25CT1 bug
# Modify.........: No:TQC-AC0326 10/12/24 By wangxin 促銷變更單要管控，審核、發布後的才可變更,
#                                                    生效營運中心中有對應的促銷單並且審核、發布， 才可審核對應的變更單,
#                                                    生效營運中心中有對應的促銷單的未審核變更單則不可審核當前促銷變更單
# Modify.........: No:FUN-B30028 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-BC0072 11/12/20 By pauline GP5.3 artt402 一般促銷變更單促銷功能優化

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20328 12/02/21 By pauline 增加artt402_2參數,避免在輸入會員促銷方式組別時錯誤 
# Modify.........: No.TQC-C20378 12/02/22 By pauline 把原會員促銷方式的有效碼UPDATE為'N'  
# Modify.........: No:FUN-C30154 12/03/14 By pauline 一般促銷增加價格區間
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C60041 12/06/15 By huangtao 變更生效門店時，對相應的門店資料做更顯
# Modify.........: No:FUN-D30033 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rbb           RECORD LIKE rbb_file.*,   
    g_rbb_t         RECORD LIKE rbb_file.*,  
    g_rbb_o         RECORD LIKE rbb_file.*, 
    g_rbb01_t       LIKE rbb_file.rbb01,
    g_rbb02_t       LIKE rbb_file.rbb02,          #變更單號 (舊值)
    g_rbb03_t       LIKE rbb_file.rbb03,          #變更序號 (舊值)   
    g_rbbplant_t    LIKE rbb_file.rbbplant,      
  
    g_rbc           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        type        LIKE type_file.chr1,   #類型 0.新增 1.修改

        before      LIKE type_file.chr1,   #0:初始 
        rbc06_1       LIKE rbc_file.rbc06,   #
        rbc07_1       LIKE rbc_file.rbc07,   #
        rbc08_1       LIKE rbc_file.rbc08,   #
        rbc09_1       LIKE rbc_file.rbc09,   #
        rbc10_1       LIKE rbc_file.rbc10,   #
        rbc11_1       LIKE rbc_file.rbc11,   #
        rbc12_1       LIKE rbc_file.rbc12,   #
        rbc13_1       LIKE rbc_file.rbc13,   #
        rbc14_1       LIKE rbc_file.rbc14,   #
       #FUN-BC0072 mark START
       #rbc15_1       LIKE rbc_file.rbc15,
       #rbc16_1       LIKE rbc_file.rbc16,
       #rbc17_1       LIKE rbc_file.rbc17,
       #rbc18_1       LIKE rbc_file.rbc18,
       #FUN-BC0072 mark END
        rbcacti_1     LIKE rbc_file.rbcacti,

        after         LIKE type_file.chr1,   #1:修改
        rbc06       LIKE rbc_file.rbc06,   #
        rbc07       LIKE rbc_file.rbc07,   #
        rbc08       LIKE rbc_file.rbc08,   #
        rbc09       LIKE rbc_file.rbc09,   #
        rbc10       LIKE rbc_file.rbc10,   #
        rbc11       LIKE rbc_file.rbc11,   #
        rbc12       LIKE rbc_file.rbc12,   #
        rbc13       LIKE rbc_file.rbc13,   #
        rbc14       LIKE rbc_file.rbc14,   #
       #FUN-BC0072 mark START
       #rbc15       LIKE rbc_file.rbc15,
       #rbc16       LIKE rbc_file.rbc16,
       #rbc17       LIKE rbc_file.rbc17,
       #rbc18       LIKE rbc_file.rbc18,
       #FUN-BC0072 mark END 
        rbcacti     LIKE rbc_file.rbcacti 
                    END RECORD,
    g_rbc_t         RECORD                 #程式變數 (舊值)
        type        LIKE type_file.chr1,   #類型 0.新增 1.修改

        before      LIKE type_file.chr1,   #0:初始 
        rbc06_1       LIKE rbc_file.rbc06,   #
        rbc07_1       LIKE rbc_file.rbc07,   #
        rbc08_1       LIKE rbc_file.rbc08,   #
        rbc09_1       LIKE rbc_file.rbc09,   #
        rbc10_1       LIKE rbc_file.rbc10,   #
        rbc11_1       LIKE rbc_file.rbc11,   #
        rbc12_1       LIKE rbc_file.rbc12,   #
        rbc13_1       LIKE rbc_file.rbc13,   #
        rbc14_1       LIKE rbc_file.rbc14,   #
       #FUN-BC0072 mark START
       #rbc15_1       LIKE rbc_file.rbc15,
       #rbc16_1       LIKE rbc_file.rbc16,
       #rbc17_1       LIKE rbc_file.rbc17,
       #rbc18_1       LIKE rbc_file.rbc18,
       #FUN-BC0072 mark END
        rbcacti_1     LIKE rbc_file.rbcacti,

        after         LIKE type_file.chr1,   #1:修改
        rbc06       LIKE rbc_file.rbc06,   #
        rbc07       LIKE rbc_file.rbc07,   #
        rbc08       LIKE rbc_file.rbc08,   #
        rbc09       LIKE rbc_file.rbc09,   #
        rbc10       LIKE rbc_file.rbc10,   #
        rbc11       LIKE rbc_file.rbc11,   #
        rbc12       LIKE rbc_file.rbc12,   #
        rbc13       LIKE rbc_file.rbc13,   #
        rbc14       LIKE rbc_file.rbc14,   #
       #FUN-BC0072 mark START
       #rbc15       LIKE rbc_file.rbc15,
       #rbc16       LIKE rbc_file.rbc16,
       #rbc17       LIKE rbc_file.rbc17,
       #rbc18       LIKE rbc_file.rbc18,
       #FUN-BC0072 mark END
        rbcacti     LIKE rbc_file.rbcacti
                    END RECORD,
    g_rbc_o         RECORD                 #程式變數 (舊值)
        type        LIKE type_file.chr1,   #類型 0.新增 1.修改

        before      LIKE type_file.chr1,   #0:初始 
        rbc06_1       LIKE rbc_file.rbc06,   #
        rbc07_1       LIKE rbc_file.rbc07,   #
        rbc08_1       LIKE rbc_file.rbc08,   #
        rbc09_1       LIKE rbc_file.rbc09,   #
        rbc10_1       LIKE rbc_file.rbc10,   #
        rbc11_1       LIKE rbc_file.rbc11,   #
        rbc12_1       LIKE rbc_file.rbc12,   #
        rbc13_1       LIKE rbc_file.rbc13,   #
        rbc14_1       LIKE rbc_file.rbc14,   #
       #FUN-BC0072 mark START
       #rbc15_1       LIKE rbc_file.rbc15,
       #rbc16_1       LIKE rbc_file.rbc16,
       #rbc17_1       LIKE rbc_file.rbc17,
       #rbc18_1       LIKE rbc_file.rbc18,
       #FUN-BC0072 mark END
        rbcacti_1     LIKE rbc_file.rbcacti,

        after         LIKE type_file.chr1,   #1:修改
        rbc06       LIKE rbc_file.rbc06,   #
        rbc07       LIKE rbc_file.rbc07,   #
        rbc08       LIKE rbc_file.rbc08,   #
        rbc09       LIKE rbc_file.rbc09,   #
        rbc10       LIKE rbc_file.rbc10,   #
        rbc11       LIKE rbc_file.rbc11,   #
        rbc12       LIKE rbc_file.rbc12,   #
        rbc13       LIKE rbc_file.rbc13,   #
        rbc14       LIKE rbc_file.rbc14,   #
       #FUN-BC0072 mark START
       #rbc15       LIKE rbc_file.rbc15,
       #rbc16       LIKE rbc_file.rbc16,
       #rbc17       LIKE rbc_file.rbc17,
       #rbc18       LIKE rbc_file.rbc18,
       #FUN-BC0072 mark END
        rbcacti     LIKE rbc_file.rbcacti
                    END RECORD
DEFINE  
   g_rbd            DYNAMIC ARRAY OF RECORD  
        type1           LIKE type_file.chr1,
       
        before1         LIKE type_file.chr1,
        rbd06_1         LIKE rbd_file.rbd06,
        rbd07_1         LIKE rbd_file.rbd07,
        rbd08_1         LIKE rbd_file.rbd08,
        rbd08_1_desc    LIKE ima_file.ima02,
        rbd09_1         LIKE rbd_file.rbd09,
        rbd09_1_desc    LIKE gfe_file.gfe02,
        rbdacti_1       LIKE rbd_file.rbdacti,

        after1          LIKE type_file.chr1,
        rbd06           LIKE rbd_file.rbd06,  
        rbd07           LIKE rbd_file.rbd07,  
        rbd08           LIKE rbd_file.rbd08,  
        rbd08_desc      LIKE ima_file.ima02,  
        rbd09           LIKE rbd_file.rbd09,  
        rbd09_desc      LIKE gfe_file.gfe02,  
        rbdacti         LIKE rbd_file.rbdacti  
                    END RECORD,
   g_rbd_t          RECORD 
        type1           LIKE type_file.chr1,

        before1         LIKE type_file.chr1,
        rbd06_1         LIKE rbd_file.rbd06,
        rbd07_1         LIKE rbd_file.rbd07,
        rbd08_1         LIKE rbd_file.rbd08,
        rbd08_1_desc    LIKE ima_file.ima02,
        rbd09_1         LIKE rbd_file.rbd09,
        rbd09_1_desc    LIKE gfe_file.gfe02,
        rbdacti_1       LIKE rbd_file.rbdacti,

        after1          LIKE type_file.chr1,
        rbd06           LIKE rbd_file.rbd06,
        rbd07           LIKE rbd_file.rbd07,
        rbd08           LIKE rbd_file.rbd08,
        rbd08_desc      LIKE ima_file.ima02,
        rbd09           LIKE rbd_file.rbd09,
        rbd09_desc      LIKE gfe_file.gfe02,
        rbdacti         LIKE rbd_file.rbdacti
                    END RECORD,
   g_rbd_o          RECORD
        type1           LIKE type_file.chr1,

        before1         LIKE type_file.chr1,
        rbd06_1         LIKE rbd_file.rbd06,
        rbd07_1         LIKE rbd_file.rbd07,
        rbd08_1         LIKE rbd_file.rbd08,
        rbd08_1_desc    LIKE ima_file.ima02,
        rbd09_1         LIKE rbd_file.rbd09,
        rbd09_1_desc    LIKE gfe_file.gfe02,
        rbdacti_1       LIKE rbd_file.rbdacti,

        after1          LIKE type_file.chr1,
        rbd06           LIKE rbd_file.rbd06,
        rbd07           LIKE rbd_file.rbd07,
        rbd08           LIKE rbd_file.rbd08,
        rbd08_desc      LIKE ima_file.ima02,
        rbd09           LIKE rbd_file.rbd09,
        rbd09_desc      LIKE gfe_file.gfe02,
        rbdacti         LIKE rbd_file.rbdacti
                    END RECORD    

DEFINE
   #g_rbc03_o       LIKE rbc_file.rbc03,  #MOD-9B0165 
    g_wc,g_wc1,g_wc2,g_sql    string,  #No.FUN-580092 HCN
   #g_rbc04             LIKE rbc_file.rbc04b,
   #g_rbc80             LIKE rbc_file.rbc80b,
   #g_rbc81             LIKE rbc_file.rbc81b,
   #g_rbc82             LIKE rbc_file.rbc82b,
   #g_rbc83             LIKE rbc_file.rbc83b,
   #g_rbc84             LIKE rbc_file.rbc84b,
   #g_rbc85             LIKE rbc_file.rbc85b,
   #g_rbc86             LIKE rbc_file.rbc86b,
   #g_rbc87             LIKE rbc_file.rbc87b,
   #g_img09             LIKE img_file.img09,
   #g_ima44             LIKE ima_file.ima44,
   #g_ima31             LIKE ima_file.ima31,
   #g_ima906            LIKE ima_file.ima906,
   #g_ima907            LIKE ima_file.ima907,
   #g_ima908            LIKE ima_file.ima908,
   #g_factor            LIKE pmn_file.pmn09,
   #g_factor2           LIKE pmn_file.pmn09,   #CHI-870031
   #g_tot               LIKE img_file.img10,
   #g_qty               LIKE img_file.img10,
   #g_flag              LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   #g_buf               LIKE gfe_file.gfe02,
   #g_change            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
   #l_gae04             LIKE gae_file.gae04,    #No.FUN-680136 VARCHAR(255) #TQC-5B0103
    l_flag              LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    g_flag_b            LIKE type_file.chr1,
    g_argv1     	LIKE pmn_file.pmn01,    # INPUT ARGUMENT - 1
    g_argv2             LIKE pmn_file.pmn02,    #FUN-580147
    g_argv3             STRING,                 #FUN-640184
   #g_delete            LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
   #g_cmd               LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
   #g_pmm               RECORD LIKE pmm_file.*,
   #g_pmm02             LIKE pmm_file.pmm02,
   #g_pmm43             LIKE pmm_file.pmm43,    #No.FUN-550089
   #g_gec07             LIKE gec_file.gec07,    #No.FUN-550089
    g_rec_b1            LIKE type_file.num5,    #單身筆數 
    g_rec_b2            LIKE type_file.num5,    #單身筆數
    g_t1                LIKE oay_file.oayslip,  #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
    g_sta               LIKE ze_file.ze03,      #No.FUN-680136 VARCHAR(16) #No.FUN-550060
    l_ac_1              LIKE type_file.num5,    #No.FUN-680136 SMALLINT #TQC-660120
    l_ac1               LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_ac2               LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE   g_laststage    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  #FUN-580147
DEFINE   p_row,p_col    LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE   g_forupd_sql   STRING     #SELECT ...  FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE   g_chr2         LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE   g_before_input_done  LIKE type_file.num5     #NO.FUN-570109  #No.FUN-680136 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE   g_smy62        LIKE smy_file.smy62     #No.TQC-650108
DEFINE   g_error        LIKE type_file.chr10
DEFINE   g_term         LIKE rbb_file.rbb10     #NO.FUN-930148
DEFINE   g_price        LIKE rbb_file.rbb09     #No.FUN-930148
DEFINE   l_dbs_tra      LIKE azw_file.azw05    #FUN-980093 add
DEFINE   l_plant_new    LIKE azp_file.azp01    #FUN-980093 add
 
DEFINE l_azp02             LIKE azp_file.azp02
DEFINE g_rtz05             LIKE rtz_file.rtz05  #價格策略
DEFINE g_rtz04             LIKE rtz_file.rtz04  #FUN-AB0101
DEFINE l_tt   DATETIME YEAR TO FRACTION(4)
DEFINE l_tp   DATETIME YEAR TO FRACTION(4)
define l_tt1 like type_file.chr30
DEFINE g_b_flag         STRING                  #FUN-D30033 Add 
#FUN-BC0072 add START
DEFINE
       g_rbk         DYNAMIC ARRAY OF RECORD
           type2          LIKE type_file.chr1,   #類型 0.新增 1.修改
           before2        LIKE type_file.chr1,   #0:初始
           rbk07_1        LIKE rbk_file.rbk07,
           rbk08_1        LIKE rbk_file.rbk08,
           rbk09_1        LIKE rbk_file.rbk09,
           rbk10_1        LIKE rbk_file.rbk10,
           rbk11_1        LIKE rbk_file.rbk11,
           rbk12_1        LIKE rbk_file.rbk12,
           rbk13_1        LIKE rbk_file.rbk13,
           rbk14_1        LIKE rbk_file.rbk13,
           rbkacti_1      LIKE rbk_file.rbkacti,
           after2         LIKE type_file.chr1,   #1:修改 
           rbk07          LIKE rbk_file.rbk07,
           rbk08          LIKE rbk_file.rbk08,
           rbk09          LIKE rbk_file.rbk09,
           rbk10          LIKE rbk_file.rbk10,
           rbk11          LIKE rbk_file.rbk11,
           rbk12          LIKE rbk_file.rbk12,
           rbk13          LIKE rbk_file.rbk13,
           rbk14          LIKE rbk_file.rbk13,
           rbkacti        LIKE rbk_file.rbkacti
                     END RECORD,
       g_rbk_t       RECORD
           type2          LIKE type_file.chr1,   #類型 0.新增 1.修改
           before2        LIKE type_file.chr1,   #0:初始
           rbk07_1        LIKE rbk_file.rbk07,
           rbk08_1        LIKE rbk_file.rbk08,
           rbk09_1        LIKE rbk_file.rbk09,
           rbk10_1        LIKE rbk_file.rbk10,
           rbk11_1        LIKE rbk_file.rbk11,
           rbk12_1        LIKE rbk_file.rbk12,
           rbk13_1        LIKE rbk_file.rbk13,
           rbk14_1        LIKE rbk_file.rbk13,
           rbkacti_1      LIKE rbk_file.rbkacti,
           after2         LIKE type_file.chr1,   #1:修改
           rbk07          LIKE rbk_file.rbk07,
           rbk08          LIKE rbk_file.rbk08,
           rbk09          LIKE rbk_file.rbk09,
           rbk10          LIKE rbk_file.rbk10,
           rbk11          LIKE rbk_file.rbk11,
           rbk12          LIKE rbk_file.rbk12,
           rbk13          LIKE rbk_file.rbk13,
           rbk14          LIKE rbk_file.rbk13,
           rbkacti        LIKE rbk_file.rbkacti
                     END RECORD,
       g_rbk_o       RECORD
           type2          LIKE type_file.chr1,   #類型 0.新增 1.修改
           before2        LIKE type_file.chr1,   #0:初始
           rbk07_1        LIKE rbk_file.rbk07,
           rbk08_1        LIKE rbk_file.rbk08,
           rbk09_1        LIKE rbk_file.rbk09,
           rbk10_1        LIKE rbk_file.rbk10,
           rbk11_1        LIKE rbk_file.rbk11,
           rbk12_1        LIKE rbk_file.rbk12,
           rbk13_1        LIKE rbk_file.rbk13,
           rbk14_1        LIKE rbk_file.rbk13,
           rbkacti_1      LIKE rbk_file.rbkacti,
           after2         LIKE type_file.chr1,   #1:修改
           rbk07          LIKE rbk_file.rbk07,
           rbk08          LIKE rbk_file.rbk08,
           rbk09          LIKE rbk_file.rbk09,    
           rbk10          LIKE rbk_file.rbk10,
           rbk11          LIKE rbk_file.rbk11,
           rbk12          LIKE rbk_file.rbk12,
           rbk13          LIKE rbk_file.rbk13,
           rbk14          LIKE rbk_file.rbk13,
           rbkacti        LIKE rbk_file.rbkacti
                     END RECORD
DEFINE g_wc3               STRING,
       g_rec_b3            LIKE type_file.num5,    #單身筆數
       l_ac3               LIKE type_file.num5,
       g_n                 LIKE type_file.num5

#FUN-BC0072 add END
MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP   # ,
          #FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730068
      #DEFER INTERRUPT
    END IF

    DISPLAY EXTEND ( TODAY, YEAR TO FRACTION(4) )

   #LET l_tt =CURRENT YEAR TO FRACTION(4)
   #LET l_tt1 = l_tt
   #LET l_tt1 = l_tt1[1,4],l_tt1[6,7],l_tt1[9,10],l_tt1[12,13],l_tt1[15,16],l_tt1[18,19],l_tt1[21,22]
   #LET l_tt = (CURRENT YEAR TO FRACTION(4)) USING 'YYYYMMDDHH24MISSFF'
   #LET l_tt1 = g_today USING 'YYYYMMDD'," ",TIME
#  #LET l_tt =DATETIME(CURRENT)
#  #LET l_tt =DATETIME(CURRENT) YEAR TO FRACTION(4)
#  #LET l_tp =INTERVAL (CURRENT  ) YEAR TO FRACTION(4)

 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ART")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_wc2=' 1=1'
    LET g_wc1=' 1=1'
    LET g_forupd_sql = "SELECT * FROM rbb_file WHERE rbb01 = ? AND rbb02 = ? AND rbb03 =? AND rbbplant = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t402_cl CURSOR FROM g_forupd_sql
 
    LET g_rbb.rbb01 = g_plant
    LET g_argv1     = ARG_VAL(1)          # 參數值(1) - 制定機構
    LET g_argv2     = ARG_VAL(2)          # 參數值(1) - 促銷單號  
    LET g_argv3     = ARG_VAL(3)          # 參數值(3) - 營運中心       #FUN-640184
 
 
 
    OPEN WINDOW t402_w WITH FORM "art/42f/artt402"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_set_comp_visible("rbb05,rbb06,rbb08,rbb09",FALSE)  #FUN-BC0072 add
    CALL cl_set_comp_visible("rbb05t,rbb06t,rbb08t,rbb09t",FALSE)  #FUN-BC0072 add
    CALL cl_set_comp_required("rbk14",FALSE)   #FUN-BC0072 add
    LET g_rbb.rbb01=g_plant
    DISPLAY BY NAME g_rbb.rbb01 
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_plant
    DISPLAY l_azp02 TO rbb01_desc
    SELECT rtz05 INTO g_rtz05 FROM rtz_file WHERE rtz01=g_plant
    SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01 = g_plant   #FUN-AB0101
  
 
    CALL t402_menu()
    CLOSE t402_cl
    CLOSE WINDOW t402_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION t402_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "rbb01 = '",g_argv1,"' "
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc," AND rbb02='",g_argv2,"'"
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc," AND rbbplant='",g_argv3,"'"
         END IF
      END IF
      LET g_wc1= " 1=1"
      LET g_wc2= " 1=1"
      LET g_rbb.rbb01=g_argv1
      DISPLAY BY NAME g_rbb.rbb01
      LET g_rbb.rbb02=g_argv2      
      DISPLAY BY NAME g_rbb.rbb02 
      LET g_rbb.rbbplant=g_argv3     
      DISPLAY BY NAME g_rbb.rbbplant 
   ELSE
      CLEAR FORM          
      CALL g_rbc.clear()
      CALL g_rbd.clear()
      CALL g_rbk.clear()  #FUN-BC0072 add
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_rbb.* TO NULL    
      CONSTRUCT BY NAME g_wc ON rbb01,rbb02,rbb03,rbbplant,rbb11,
                                rbb04,rbb05,rbb06, rbb04t,rbb05t,rbb06t,
 #                               rbbmksg,rbb900,rbbconf,rbbcond,rbbcont,rbbconu,      #FUN-B30028 mark
                                rbbconf,rbbcond,rbbcont,rbbconu,                      #FUN-B30028
                                rbb07,rbb08,rbb09,rbb10, 
                                rbb07t,rbb08t,rbb09t,rbb10t,
                                rbbuser,rbbgrup,rbboriu,  rbbmodu,rbbdate,rbborig, rbbacti,rbbcrat

              
         BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
         ON ACTION CONTROLP
           #CASE      #查詢符合條件的單號
              #WHEN INFIELD(rbb01)
              #     CALL q_pmm2(TRUE,TRUE,g_rbb.rbb01,'2') RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb01
              #     NEXT FIELD rbb01
              #WHEN INFIELD(rbb11) #查詢地址資料檔 (0:表送貨地址)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pme"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb11
              #     NEXT FIELD rbb11
              #WHEN INFIELD(rbb12) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pme"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb12
              #     NEXT FIELD rbb12
              #WHEN INFIELD(rbb10) #查詢付款條件資料檔(pma_file)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pma"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb10
              #     NEXT FIELD rbb10
              #WHEN INFIELD(rbb09) #價格條件
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pnz01" #FUN-930113
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb09
              #     NEXT FIELD rbb09
              #WHEN INFIELD(rbb08) #查詢幣別資料檔
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_azi"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb08
              #     NEXT FIELD rbb08
              #WHEN INFIELD(rbb11b) #查詢地址資料檔 (0:表送貨地址)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pme"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb11b
              #     NEXT FIELD rbb11b
              #WHEN INFIELD(rbb12b) #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pme"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb12b
              #     NEXT FIELD rbb12b
              #WHEN INFIELD(rbb10b) #查詢付款條件資料檔(pma_file)
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pma"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb10b
              #     NEXT FIELD rbb10b
              #WHEN INFIELD(rbb09b) #價格條件
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_pnz01" #FUN-930113
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb09b
              #     NEXT FIELD rbb09b
              #WHEN INFIELD(rbb08b) #查詢幣別資料檔
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_azi"
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb08b
              #     NEXT FIELD rbb08b
              #WHEN INFIELD(rbb15) #查詢碼別代號說明資料檔
              #     CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_azf01a"      #FUN-920186
              #     LET g_qryparam.arg1 = 'B'             #FUN-920186
              #     LET g_qryparam.state = 'c'
              #     CALL cl_create_qry() RETURNING g_qryparam.multiret
              #     DISPLAY g_qryparam.multiret TO rbb15
              #     NEXT FIELD rbb15
              ##-----FUN-A20057---------
              #WHEN INFIELD(rbb16) #變更人員
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.form = "q_gen"
              #    LET g_qryparam.state = 'c'
              #    CALL cl_create_qry() RETURNING g_qryparam.multiret
              #    DISPLAY g_qryparam.multiret TO rbb16
              #    CALL t402_peo('a',g_rbb.rbb16)
              #    NEXT FIELD rbb16 
              ##-----END FUN-A20057-----
              #OTHERWISE EXIT CASE
           #END CASE
 
         #FUN-BC0072 add START
            CASE
               WHEN INFIELD(rbb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rab01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbb01 
                  NEXT FIELD rbb01

               WHEN INFIELD(rbb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rab021"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbb02
                  NEXT FIELD rbb02

               WHEN INFIELD(rbbplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rabplant"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbeplant
                  NEXT FIELD rbbplant

               WHEN INFIELD(rbbconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rabconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rbbconu
                  NEXT FIELD rbbconu

               OTHERWISE EXIT CASE
            END CASE
         #FUN-BC0072 add END

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about    
            CALL cl_about()
 
         ON ACTION help   
            CALL cl_show_help()  
 
         ON ACTION controlg     
            CALL cl_cmdask()   
 
         ON ACTION qbe_select
	    CALL cl_qbe_list() RETURNING lc_qbe_sn
	    CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT
      IF INT_FLAG THEN  RETURN END IF
 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rbbuser', 'rbbgrup')
 
      DIALOG ATTRIBUTES(UNBUFFERED)    #FUN-BC0072 add
      CONSTRUCT g_wc1 ON b.rbc06,b.rbc07,b.rbc08,b.rbc09,b.rbc10,b.rbc11,b.rbc12,
                        #b.rbc13,b.rbc14,b.rbc15,b.rbc16,b.rbc17,b.rbc18,b.rbcacti  #FUN-BC0072 mark 
                         b.rbc13,b.rbc14,b.rbcacti    #FUN-BC0072 add
           FROM s_rbc[1].rbc06,s_rbc[1].rbc07,s_rbc[1].rbc08,s_rbc[1].rbc09,
                s_rbc[1].rbc10,s_rbc[1].rbc11,s_rbc[1].rbc12,s_rbc[1].rbc13,
               #s_rbc[1].rbc14,s_rbc[1].rbc15,s_rbc[1].rbc16,s_rbc[1].rbc17,  #FUN-BC0072 mark
               #s_rbc[1].rbc18,s_rbc[1].rbcacti                               #FUN-BC0072 mark
                s_rbc[1].rbc14,s_rbc[1].rbcacti      #FUN-BC0072 add

       	BEFORE CONSTRUCT
       	   CALL cl_qbe_display_condition(lc_qbe_sn)
     #FUN-BC0072 mark START
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE CONSTRUCT
 
     #   ON ACTION about        
     #      CALL cl_about()     
 
     #   ON ACTION help        
     #      CALL cl_show_help() 
 
     #   ON ACTION controlg    
     #      CALL cl_cmdask()  

     #  #ON ACTION controlp

     #   ON ACTION qbe_save
     #      CALL cl_qbe_save()
     #FUN-BC0072 mark END

      END CONSTRUCT
     #IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF  #FUN-BC0072 mark

#FUN-BC0072 add START
      CONSTRUCT g_wc3 ON rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,rbk13,rab14,rbkacti
          FROM s_rbk[1].rbk07,s_rbk[1].rbk08,s_rbk[1].rbk09,s_rbk[1].rbk10,
               s_rbk[1].rbk11,s_rbk[1].rbk12,s_rbk[1].rbk13,s_rbk[1].rbk14, s_rbk[1].rbkacti

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
#FUN-BC0072 add END

      CONSTRUCT g_wc2 ON b.rbd06,b.rbd07,b.rbd08,b.rbd09,b.rbdacti
           FROM s_rbd[1].rbd06,s_rbd[1].rbd07,s_rbd[1].rbd08,s_rbd[1].rbd09,s_rbd[1].rbdacti

               BEFORE CONSTRUCT
                  CALL cl_qbe_display_condition(lc_qbe_sn)
     #FUN-BC0072 mark START
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE CONSTRUCT

     #   ON ACTION about
     #      CALL cl_about()

     #   ON ACTION help
     #      CALL cl_show_help()

     #   ON ACTION controlg
     #      CALL cl_cmdask()

     #  #ON ACTION controlp

     #   ON ACTION qbe_save
     #      CALL cl_qbe_save()
     #FUN-BC0072 mark END

      END CONSTRUCT

    #FUN-BC0072 add START
      ON ACTION ACCEPT
          ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_save
         CALL cl_qbe_save()

    #FUN-BC0072 add END

      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      END DIALOG
   END IF

   LET g_wc1 = g_wc1 CLIPPED
   LET g_wc2 = g_wc2 CLIPPED
   LET g_wc  = g_wc  CLIPPED
   LET g_wc3 = g_wc3 CLIPPED  #FUN-BC0072add
   IF cl_null(g_wc) THEN
      LET g_wc =" 1=1"
   END IF
   IF cl_null(g_wc1) THEN
      LET g_wc1=" 1=1"
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2=" 1=1"
   END IF
   #FUN-BC0072 add START
   IF cl_null(g_wc3) THEN
      LET g_wc3 =" 1=1"
   END IF 
   #FUN-BC0072 add END


   LET g_sql= "SELECT UNIQUE rbb01,rbb02,rbb03,rbbplant ",
#modify by lixia ---start---  
#              " FROM rbb_file,rbc_file LEFT OUTER JOIN rbd_file ",
#             #"      ON (rbc01=rbd01 AND rbc02=rbd02 AND rbc03=rbd03 AND rbcplant=rbdplant AND ",g_wc2,") ",
#              "      ON (rbc01=rbd01 AND rbc02=rbd02 AND rbc03=rbd03 AND rbcplant=rbdplant ) ",  #cockroach 100920 add
#              " WHERE rbb01 = rbc01 ",
#              "  AND  rbb02 = rbc02 ",
#              "  AND  rbb03 = rbc03 ",
#              "  AND  rbbplant = rbcplant ",
              #FUN-AB0033 add ------------start--------------               
              #" FROM rbb_file,rbc_file b LEFT OUTER JOIN rbd_file b",
              "  FROM rbb_file LEFT OUTER JOIN rbc_file b ",
              "      ON (b.rbc01=rbb01 AND b.rbc02=rbb02 AND b.rbc03=rbb03 AND b.rbcplant=rbbplant)",  
              " LEFT OUTER JOIN rbd_file b",
              "      ON (b.rbc01=b.rbd01 AND b.rbc02=b.rbd02 AND b.rbc03=b.rbd03 AND b.rbcplant=b.rbdplant ) ", 
              #" WHERE rbb01 = b.rbc01 ",
              #"  AND  rbb02 = b.rbc02 ",
              #"  AND  rbb03 = b.rbc03 ",
              #"  AND  rbbplant = b.rbcplant ",
              #FUN-AB0033 add -------------end---------------
#modify by lixia ---end---                
              "  WHERE ", g_wc CLIPPED, "  AND  ", g_wc1 CLIPPED, "  AND  ", g_wc2 CLIPPED,   #cockroach 100920      
              " ORDER BY rbb01,rbb02,rbbplant "
   PREPARE t402_prepare FROM g_sql      #預備一下
   DECLARE t402_cs                      #宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR t402_prepare

   LET g_sql= "SELECT COUNT(DISTINCT rbb01||rbb02||rbb03||rbbplant) ",
#modify by lixia ---start---   
#              "  FROM rbb_file,rbc_file LEFT OUTER JOIN rbd_file ",
#             #"       ON (rbc01=rbd01 AND rbc02=rbd02 AND rbc03=rbd03 AND rbcplant=rbdplant AND ",g_wc2,") ",
#              "       ON (rbc01=rbd01 AND rbc02=rbd02 AND rbc03=rbd03 AND rbcplant=rbdplant ) ",  #cockroach 100920
#              " WHERE rbb01 = rbc01 ",
#              "  AND  rbb02 = rbc02 ",
#              "  AND  rbb03 = rbc03 ",
#              "  AND  rbbplant = rbcplant ",
              #FUN-AB0033 add ------------start--------------  
              #"  FROM rbb_file,rbc_file b LEFT OUTER JOIN rbd_file b", 
              "  FROM rbb_file LEFT OUTER JOIN rbc_file b ",
              "       ON (b.rbc01=rbb01 AND b.rbc02=rbb02 AND b.rbc03=rbb03 AND b.rbcplant=rbbplant)",  
              " LEFT OUTER JOIN rbd_file b",
              "       ON (b.rbc01=b.rbd01 AND b.rbc02=b.rbd02 AND b.rbc03=b.rbd03 AND b.rbcplant=b.rbdplant ) ", 
              #" WHERE rbb01 = b.rbc01 ",
              #"  AND  rbb02 = b.rbc02 ",
              #"  AND  rbb03 = b.rbc03 ",
              #"  AND  rbbplant = b.rbcplant ",
              #FUN-AB0033 add -------------end---------------
#modify by lixia ---end---                 
             #"  AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
              "  WHERE ", g_wc CLIPPED, " AND ", g_wc1 CLIPPED, " AND ", g_wc2 CLIPPED,
              " ORDER BY rbb01,rbb02,rbbplant "
   PREPARE t402_precount FROM g_sql
   DECLARE t402_count CURSOR FOR t402_precount

END FUNCTION
 
FUNCTION t402_menu()
  #DEFINE l_creator     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) #「不准」時是否退回填表人 #FUN-580147
  #DEFINE l_flowuser    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) # 是否有指定加簽人員      #FUN-580147
  #DEFINE l_partnum    STRING   #GPM料號
  #DEFINE l_supplierid STRING   #GPM廠商
  #DEFINE l_status     LIKE type_file.num10  #GPM傳回值
  #DEFINE l_suppy      LIKE pmm_file.pmm09  #廠商代碼
 
  #LET l_flowuser = "N"   #FUN-580147
 
   WHILE TRUE
      CALL t402_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t402_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t402_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t402_r()
            END IF
            
#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL t402_copy()
#            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t402_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
              #FUN-BC0072 mark START
              #IF g_flag_b = '1' THEN
              #   CALL t402_b1()
              #ELSE
              #   CALL t402_b2()
              #END IF
              #FUN-BC0072 mark END
               CALL t402_b()  #FUN-BC0072 add
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t402_x()
            END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
              #CALL t402_out()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "alter_organization" #生效機構
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rbb.rbb02) THEN
                  CALl t402_1(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "alter_memberlevel"    #會員等級促銷
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rbb.rbb02) THEN
                 IF NOT cl_null(g_rbc[l_ac1].rbc11) AND g_rbc[l_ac1].rbc11 <> '0' THEN  #FUN-BC0072 add
                   #CALl t402_2(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf,'')  #FUN-BC0072 mark
                    CALl t402_2(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf,
                                g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc06)  #FUN-BC0072 add  #TQC-C20328 add rbc06
                 END IF  #FUN-BC0072  add
              ELSE
                 CALL cl_err('',-400,0)
              END IF
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               #CALL t402_y_chk()          #CALL 原確認的 check 段
               #IF g_success = "Y" THEN
                CALL t402_y()      #CALL 原確認的 update 段
               #END IF
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
             # CALL t402_z()
            END IF
           
         #FUN-AB0033 mark ------------start------------  
         #WHEN "void"
         #   IF cl_chk_act_auth() THEN
         #      CALL t402_v()
         #   END IF
         

         #WHEN "alteration_issuance"              #發布
         #   IF cl_chk_act_auth() THEN
         #      CALL t402_iss()
         #   END IF
         #FUN-AB0033 mark -------------end-------------

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rbc),'','')
            END IF

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rbb.rbb02 IS NOT NULL THEN
                 LET g_doc.column1 = "rbb02"
                 LET g_doc.value1 = g_rbb.rbb02
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t402_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_rbc TO s_rbc.*  ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='1'     #FUN-D30033 Add
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
      CALL cl_show_fld_cont()                   
#FUN-BC0072 mark START 
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DIALOG

#        ON ACTION query
#           LET g_action_choice="query"
#           EXIT DIALOG

#        ON ACTION delete
#           LET g_action_choice="delete"
#           EXIT DIALOG

#        ON ACTION modify
#           LET g_action_choice="modify"
#           EXIT DIALOG

#        ON ACTION first
#           CALL t402_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION previous
#           CALL t402_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION jump
#           CALL t402_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION next
#           CALL t402_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION last
#           CALL t402_fetch('L')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           EXIT DIALOG

#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG

#        ON ACTION detail
#           LET g_action_choice="detail"
#           LET g_flag_b = '1'
#           LET l_ac1 = 1
#           LET l_ac2 = 1
#           EXIT DIALOG

#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DIALOG

#        ON ACTION help
#           LET g_action_choice="help"
#           EXIT DIALOG

#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()

#        ON ACTION exit
#           LET g_action_choice="exit"
#           EXIT DIALOG

#        ON ACTION alter_organization                #生效機構
#           LET g_action_choice = "alter_organization" 
#           EXIT DIALOG

#        ON ACTION alter_memberlevel               #會員等級促銷 
#           LET g_action_choice= "alter_memberlevel"   
#           EXIT DIALOG

#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           EXIT DIALOG
#        
#        #FUN-AB0033 mark ----------start-----------   
#        #ON ACTION void
#        #   LET g_action_choice="void"
#        #   EXIT DIALOG

#        #ON ACTION alteration_issuance                    #發布
#        #   LET g_action_choice = "alteration_issuance"     
#        #   EXIT DIALOG 
#        #FUN-AB0033 mark -----------end------------

#        ON ACTION controlg
#           LET g_action_choice="controlg"
#           EXIT DIALOG

#        ON ACTION accept
#           LET g_action_choice="detail"
#           LET g_flag_b = '1'
#           LET l_ac1 = ARR_CURR()
#           EXIT DIALOG

#        ON ACTION cancel
#           LET INT_FLAG=FALSE
#           LET g_action_choice="exit"
#           EXIT DIALOG

#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DIALOG

#        ON ACTION about
#           CALL cl_about()

#        ON ACTION exporttoexcel
#           LET g_action_choice = 'exporttoexcel'
#           EXIT DIALOG

#        AFTER DISPLAY
#           CONTINUE DIALOG

#        ON ACTION controls
#           CALL cl_set_head_visible("","AUTO")

#        ON ACTION related_document
#           LET g_action_choice="related_document"
#           EXIT DIALOG
#FUN-BC0072 mark END
      END DISPLAY

#FUN-BC0072 add START
   DISPLAY ARRAY g_rbk TO s_rbk.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'   #FUN-D30033 Add

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY
#FUN-BC0072 add END

#chenmoyan
      DISPLAY ARRAY g_rbd TO s_rbd.* ATTRIBUTE(COUNT=g_rec_b2)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='3'    #FUN-D30033 Add
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
#FUN-BC0072 mark START
#        ON ACTION insert
#           LET g_action_choice="insert"
#           EXIT DIALOG

#        ON ACTION query
#           LET g_action_choice="query"
#           EXIT DIALOG

#        ON ACTION delete
#           LET g_action_choice="delete"
#           EXIT DIALOG

#        ON ACTION modify
#           LET g_action_choice="modify"
#           EXIT DIALOG

#        ON ACTION first
#           CALL t402_fetch('F')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION previous
#           CALL t402_fetch('P')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION jump
#           CALL t402_fetch('/')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION next
#           CALL t402_fetch('N')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION last
#           CALL t402_fetch('L')
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#           ACCEPT DIALOG

#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           EXIT DIALOG

#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            EXIT DIALOG

#        ON ACTION detail
#           LET g_action_choice="detail"
#           LET g_flag_b = '2'
#           LET l_ac2 = 1
#           EXIT DIALOG

#        ON ACTION output
#           LET g_action_choice="output"
#           EXIT DIALOG

#        ON ACTION help
#           LET g_action_choice="help"
#           EXIT DIALOG

#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()

#        ON ACTION exit
#           LET g_action_choice="exit"
#           EXIT DIALOG

#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           EXIT DIALOG
#    
#        #FUN-AB0033 mark ---------start-----------
#        #ON ACTION void
#        #   LET g_action_choice="void"
#        #   EXIT DIALOG
#        
#        #ON ACTION alteration_issuance                    #發布
#        #   LET g_action_choice = "alteration_issuance"     
#        #   EXIT DIALOG 
#        #FUN-AB0033 mark ----------end------------

#        ON ACTION alter_organization                #生效機構
#           LET g_action_choice = "alter_organization" 
#           EXIT DIALOG
#  
#        ON ACTION alter_memberlevel               #會員等級促銷 
#           LET g_action_choice= "alter_memberlevel"   
#           EXIT DIALOG

#        ON ACTION controlg
#           LET g_action_choice="controlg"
#           EXIT DIALOG

#        ON ACTION accept
#           LET g_action_choice="detail"
#           LET g_flag_b = '2'
#           LET l_ac2 = ARR_CURR()
#           EXIT DIALOG

#        ON ACTION cancel
#           LET INT_FLAG=FALSE
#           LET g_action_choice="exit"
#           EXIT DIALOG

#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DIALOG

#        ON ACTION about
#           CALL cl_about()

#        ON ACTION exporttoexcel
#           LET g_action_choice = 'exporttoexcel'
#           EXIT DIALOG

#        ON ACTION controls
#           CALL cl_set_head_visible("","AUTO")

#        ON ACTION related_document
#           LET g_action_choice="related_document"
#           EXIT DIALOG
#FUN-BC0072 mark END
      END DISPLAY
#chenmoyan
#FUN-BC0072 add START
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
 
         ON ACTION first
            CALL t402_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t402_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t402_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t402_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t402_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = 1
            LET l_ac2 = 1
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
 
         ON ACTION alter_organization                #生效機構
            LET g_action_choice = "alter_organization"
            EXIT DIALOG
 
         ON ACTION alter_memberlevel               #會員等級促銷
            LET g_action_choice= "alter_memberlevel"
            EXIT DIALOG
 
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
 
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION cancel
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
#FUN-BC0072 add END
   END DIALOG

   CALL cl_set_act_visible("accept,cancel", TRUE)


END FUNCTION

#Query 查詢
FUNCTION t402_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL cl_msg("")      
 
    CLEAR FORM
    CALL g_rbc.clear()
    CALL t402_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t402_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rbb.rbb02 TO NULL
    ELSE
        CALL t402_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN t402_count
        FETCH t402_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t402_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  
 
    CALL cl_msg("")                              #FUN-640184
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     t402_cs INTO g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
       WHEN 'P' FETCH PREVIOUS t402_cs INTO g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
       WHEN 'F' FETCH FIRST    t402_cs INTO g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
       WHEN 'L' FETCH LAST     t402_cs INTO g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
       WHEN '/'
          IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
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
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE g_jump t402_cs INTO g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
          LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        INITIALIZE g_rbb.* TO NULL 
        CALL cl_err(g_rbb.rbb01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_rbb.* FROM rbb_file
     WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02 
       AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_rbb.rbb01,SQLCA.sqlcode,0)
        INITIALIZE g_rbb.* TO NULL   
        RETURN
    END IF
    LET g_data_owner = g_rbb.rbbuser     
    LET g_data_group = g_rbb.rbbgrup    
    LET g_data_plant = g_rbb.rbbplant 
    CALL t402_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t402_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
#DEFINE  l_raa03  LIKE raa_file.raa03

   LET g_rbb_t.* = g_rbb.*
   LET g_rbb_o.* = g_rbb.*
 

    DISPLAY BY NAME g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant,g_rbb.rbb11,
                    g_rbb.rbb04,g_rbb.rbb05,g_rbb.rbb06,   g_rbb.rbb04t,g_rbb.rbb05t,g_rbb.rbb06t,
#                    g_rbb.rbbmksg,g_rbb.rbb900,g_rbb.rbbconf,g_rbb.rbbcond,g_rbb.rbbcont,g_rbb.rbbconu,   #FUN-B30028  mark
                    g_rbb.rbbconf,g_rbb.rbbcond,g_rbb.rbbcont,g_rbb.rbbconu,                               #FUN-B30028
                    g_rbb.rbb07, g_rbb.rbb08, g_rbb.rbb09, g_rbb.rbb10,
                    g_rbb.rbb07t,g_rbb.rbb08t,g_rbb.rbb09t,g_rbb.rbb10t,
                    g_rbb.rbbuser,g_rbb.rbbgrup,g_rbb.rbboriu,g_rbb.rbbmodu,
                    g_rbb.rbbdate,g_rbb.rbborig,g_rbb.rbbacti,g_rbb.rbbcrat

 
    #CKP
  # IF NOT g_rbb.rbb05='X' THEN LET g_chr='N' END IF #MOD-AC0190 
   #IF g_rbb.rbb13='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   #CALL cl_set_field_pic(g_rbb.rbb05,g_chr2,"","",g_chr,"")
   #MOD-AC0190--add-begin
   IF NOT g_rbb.rbbconf='X' THEN LET g_chr='N' END IF
    IF g_rbb.rbbconf='I' OR g_rbb.rbbconf='Y' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_chr2,"","","",g_chr,"")
   #MOD-AC0190--add-end  
    CALL t402_b1_fill(g_wc1)          #單身1
    CALL t402_b2_fill(g_wc2)          #單身2
    CALL t402_b3_fill(g_wc3)          #FUN-BC0072 add
    CALL cl_show_fld_cont()       
END FUNCTION
 
FUNCTION t402_b1_fill(p_wc1)              #BODY FILL UP
DEFINE p_wc1        STRING   
 
    LET g_sql = " SELECT '',a.rbc05,a.rbc06,a.rbc07,a.rbc08,a.rbc09,a.rbc10,a.rbc11, ",
               #"           a.rbc12,a.rbc13,a.rbc14,a.rbc15,a.rbc16,a.rbc17,a.rbc18,a.rbcacti,",  #FUN-BC0072 mark 
                "           a.rbc12,a.rbc13,a.rbc14,a.rbcacti,",  #FUN-BC0072 add
                "           b.rbc05,b.rbc06,b.rbc07,b.rbc08,b.rbc09,b.rbc10,b.rbc11, ",
               #"           b.rbc12,b.rbc13,b.rbc14,b.rbc15,b.rbc16,b.rbc17,b.rbc18,b.rbcacti ",  #FUN-BC0072 mark
                "           b.rbc12,b.rbc13,b.rbc14,b.rbcacti ",  #FUN-BC0072 add 
                "   FROM rbc_file b LEFT OUTER JOIN rbc_file a",
                "                   ON (b.rbc01=a.rbc01 AND b.rbc02=a.rbc02 AND b.rbc03=a.rbc03 AND ",
                "                       b.rbc04=a.rbc04 AND b.rbc06=a.rbc06 AND b.rbcplant=a.rbcplant AND b.rbc05<>a.rbc05 ) ",
                "  WHERE b.rbc01 = '",g_rbb.rbb01, "' AND b.rbcplant='",g_rbb.rbbplant,"'",
                "    AND b.rbc05='1' ",  #AND a.rbc05='0' ",
                "    AND b.rbc02 = '",g_rbb.rbb02, "' AND b.rbc03=",g_rbb.rbb03," AND ", p_wc1 CLIPPED,
                "  ORDER BY b.rbc04 " 
    PREPARE t402_b1_prepare FROM g_sql                     #預備一下
    DECLARE rbc_cs CURSOR FOR t402_b1_prepare
    CALL g_rbc.clear()
    LET g_rec_b1 = 0
    LET g_cnt = 1
    FOREACH rbc_cs INTO g_rbc[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF g_rbc[g_cnt].before='0' THEN
           LET g_rbc[g_cnt].type='1'
        ELSE 
           LET g_rbc[g_cnt].type='0'
        END IF
       #DISPLAY BY NAME g_rbc[g_cnt].type,g_rbc[g_cnt].before,g_rbc[g_cnt].after
        
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rbc.deleteElement(g_cnt)
    CALL cl_set_comp_entry("type",FALSE) 
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn1
 
END FUNCTION
 
FUNCTION t402_b2_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2          STRING 
 
    LET g_sql = " SELECT '',a.rbd05,a.rbd06,a.rbd07,a.rbd08,'',a.rbd09,'',a.rbdacti, ",
                "           b.rbd05,b.rbd06,b.rbd07,b.rbd08,'',b.rbd09,'',b.rbdacti  ",
                "   FROM rbd_file b LEFT OUTER JOIN rbd_file a",
                "                   ON (b.rbd01=a.rbd01 AND b.rbd02=a.rbd02 AND b.rbd03=a.rbd03 AND b.rbd04=a.rbd04 AND ",
                "                       b.rbd06=a.rbd06 AND b.rbd07=a.rbd07 AND b.rbdplant=a.rbdplant AND b.rbd05<>a.rbd05 ) ",
                "  WHERE b.rbd01 = '",g_rbb.rbb01, "' AND b.rbdplant='",g_rbb.rbbplant,"'",
                "    AND b.rbd05='1'  ", #AND a.rbd05='0' ",
                "    AND b.rbd02 = '",g_rbb.rbb02, "' AND b.rbd03=",g_rbb.rbb03," AND ", p_wc2 CLIPPED,
                "  ORDER BY b.rbd04 " 
    PREPARE t402_b2_prepare FROM g_sql                     #預備一下
    DECLARE rbd_cs CURSOR FOR t402_b2_prepare
    CALL g_rbd.clear()
    LET g_rec_b2 = 0
    LET g_cnt = 1
    FOREACH rbd_cs INTO g_rbd[g_cnt].*
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF g_rbd[g_cnt].before1='0' THEN
           LET g_rbd[g_cnt].type1='1'
        ELSE 
           LET g_rbd[g_cnt].type1='0'
        END IF
        SELECT gfe02 INTO g_rbd[g_cnt].rbd09_desc FROM gfe_file
           WHERE gfe01 = g_rbd[g_cnt].rbd09
        SELECT gfe02 INTO g_rbd[g_cnt].rbd09_1_desc FROM gfe_file
           WHERE gfe01 = g_rbd[g_cnt].rbd09  
        CALL t402_rbd08('d',g_cnt)
        CALL t402_rbd08_1('d',g_cnt)            
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rbd.deleteElement(g_cnt)
    CALL cl_set_comp_entry("type1",FALSE) 
 
    LET g_rec_b2 = g_cnt-1
   #DISPLAY g_rec_b2 TO FORMONLY.cn2
    DISPLAY g_rec_b2 TO FORMONLY.cn3 #FUN-BC0072 add
 
END FUNCTION
 

FUNCTION t402_a()
DEFINE l_n    LIKE  type_file.num5
  
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_rbc.clear()
    CALL g_rbd.clear()
    CALL g_rbk.clear()   #FUN-BC0072 add

    INITIALIZE g_rbb.* LIKE rbb_file.*               #DEFAULT 設定
    INITIALIZE g_rbb_t.* LIKE rbb_file.*             #DEFAULT 設定
    INITIALIZE g_rbb_o.* LIKE rbb_file.*             #DEFAULT 設定
    LET g_rbb.rbb01 = g_plant 
    CALL cl_opmsg('a')
    WHILE TRUE 
        LET g_rbb.rbb04  = 'N'
        LET g_rbb.rbb05  = 'N'
        LET g_rbb.rbb06  = 'N'
        LET g_rbb.rbb07  = 'N'
        LET g_rbb.rbb08  = 'N'
        LET g_rbb.rbb09  = 'N'
        LET g_rbb.rbb10  = 'N'
        LET g_rbb.rbb04t = 'N'
        LET g_rbb.rbb05t = 'N'
        LET g_rbb.rbb06t = 'N'
        LET g_rbb.rbb07t = 'N'
        LET g_rbb.rbb08t = 'N'
        LET g_rbb.rbb09t = 'N'
        LET g_rbb.rbb10t = 'N'
        DISPLAY BY NAME g_rbb.rbb04, g_rbb.rbb05, g_rbb.rbb06,g_rbb.rbb07,
                        g_rbb.rbb08, g_rbb.rbb09, g_rbb.rbb10,
                        g_rbb.rbb04t,g_rbb.rbb05t,g_rbb.rbb06t,g_rbb.rbb07t,
                        g_rbb.rbb08t,g_rbb.rbb09t,g_rbb.rbb10t       

        LET g_rbb.rbb900  = '0'                    #開立   
        LET g_rbb.rbbconf = 'N' 
        LET g_rbb.rbbmksg = 'N' 
        LET g_rbb.rbbacti = 'Y'
        LET g_rbb.rbbgrup = g_grup
        LET g_rbb.rbbcrat = g_today
        LET g_rbb.rbbuser = g_user
        LET g_rbb.rbboriu = g_user 
        LET g_rbb.rbborig = g_grup 
        LET g_rbb.rbbplant= g_plant  
        LET g_rbb.rbblegal= g_legal 
        LET g_data_plant  = g_plant 
 
        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbb.rbb01
        DISPLAY l_azp02 TO rbb01_desc
        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rbb.rbbplant
        DISPLAY l_azp02 TO rbbplant_desc
        #INITIALIZE g_rbc_t.* TO NULL  

        CALL t402_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_rbb.* TO NULL
            LET INT_FLAG = 0
            EXIT WHILE
        END IF

       IF cl_null(g_rbb.rbb02) THEN
          CONTINUE WHILE
       END IF

       BEGIN WORK
          INSERT INTO rbb_file VALUES(g_rbb.*)
          IF SQLCA.sqlcode THEN
          #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
             CALL cl_err3("ins","rbb_file",g_rbb.rbb02,"",SQLCA.sqlcode,"","",1)
             ROLLBACK WORK         #FUN-B80085--add--
             CONTINUE WHILE
          ELSE
              SELECT COUNT(*) INTO l_n
                FROM rbq_file
               WHERE rbq01 = g_rbb.rbb01 AND rbq02 = g_rbb.rbb02 
                 AND rbqplant = g_rbb.rbbplant AND rbq03='1' 
             #IF l_n>0 THEN
             #   INSERT  INTO rbq_file()
             #END IF
 
             #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             #   ROLLBACK WORK
             #   CALL cl_err3("ins","raq_file",g_rbb.rbb02,"",SQLCA.sqlcode,"","",1)
             #   CONTINUE WHILE
             #ELSE
                 COMMIT WORK
                 CALL cl_flow_notify(g_rbb.rbb02,'I')
             #END IF

          END IF

        SELECT * INTO g_rbb.* FROM rbb_file
         WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02
           AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
        LET g_rbb_t.* = g_rbb.*
        LET g_rbb_o.* = g_rbb.*
        #CALL t402_1(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf) #FUN-AB0033 mark
        CALL g_rbc.clear()
        CALL g_rbd.clear()
        CALL g_rbk.clear()   #FUN-BC0072 add
        LET g_rec_b1 = 0
        LET g_rec_b2 = 0
        LET g_rec_b3 = 0   #FUN-BC0072 add
       #FUN-BC0072 mark START
       #CALL t402_b1()
       #CALL t402_b2()
       #FUN-BC0072 mark END 
        CALL t402_b()  #FUN-BC0072 add
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t402_u()

    IF s_shut(0) THEN RETURN END IF

    IF g_rbb.rbb02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

   SELECT * INTO g_rbb.* FROM rbb_file
    WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
      AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant

    IF g_rbb.rbbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbb.rbb02,9027,0)
       RETURN
    END IF
     
    IF g_rbb.rbbconf = 'Y' THEN  #FUN-AB0033 add
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    #TQC-AC0326 add ---------begin----------
    IF g_rbb.rbb01 <> g_rbb.rbbplant THEN 
       CALL cl_err('','art-977',0) 
       RETURN 
    END IF 
    #TQC-AC0326 add ----------end-----------
    #FUN-AB0033 mark ------start------
    #IF g_rbb.rbbconf = 'X' THEN
    #   CALL cl_err('','art-025',0)
    #   RETURN
    #END IF
    #FUN-AB0033 mark -------end-------
 
    CALL cl_opmsg('u')

    LET g_rbb01_t = g_rbb.rbb01
    LET g_rbb02_t = g_rbb.rbb02  
    LET g_rbb03_t = g_rbb.rbb03  
    LET g_rbbplant_t = g_rbb.rbbplant 
    LET g_rbb_o.* = g_rbb.*

    BEGIN WORK
    LET g_success ='Y'
 
    OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
    IF STATUS THEN
       CALL cl_err("OPEN t402_cl:", STATUS, 1)
       CLOSE t402_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t402_cl INTO g_rbb.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rbb.rbb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t402_cl
        ROLLBACK WORK
        RETURN
    END IF

    CALL t402_show()

    WHILE TRUE
        LET g_rbb01_t = g_rbb.rbb01
        LET g_rbb02_t = g_rbb.rbb02   
        LET g_rbb03_t = g_rbb.rbb03   
        LET g_rbbplant_t = g_rbb.rbbplant 
        LET g_rbb.rbbmodu=g_user
        LET g_rbb.rbbdate=g_today

        CALL t402_i("u")                      #欄位更改

        IF INT_FLAG THEN
            LET g_success ='N'
            LET INT_FLAG = 0
            LET g_rbb.*=g_rbb_o.*
            CALL t402_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF

        UPDATE rbb_file SET rbb_file.* = g_rbb.*
            WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02
              AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","rbb_file","","",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF 
        EXIT WHILE
    END WHILE

    CLOSE t402_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rbb.rbb02,'U')

    CALL t402_b1_fill("1=1")
    CALL t402_b2_fill("1=1")
    CALL t402_b3_fill(" 1=1")  #FUN-BC0072 add 
    COMMIT WORK
END FUNCTION
 
 
FUNCTION t402_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  
    l_cmd           LIKE type_file.chr1000, 
    l_rbb03         LIKE type_file.num5,    #變更序號
    l_n             LIKE type_file.num5     
   #l_rbb01    LIKE rbb_file.rbb01,
   #l_pmm25    LIKE pmm_file.pmm25,
   #l_pmm04    LIKE pmm_file.pmm04,       
   #l_rbbconf  LIKE rbb_file.rbbconf,       #
   #l_str      LIKE type_file.chr50      

    CALL cl_set_head_visible("","YES")   

    DISPLAY BY NAME
#FUN-B30028 --------------STA
#        g_rbb.rbb01,g_rbb.rbbplant,g_rbb.rbb900,g_rbb.rbbconf,
#        g_rbb.rbbmksg,g_rbb.rbboriu,g_rbb.rbborig,g_rbb.rbbuser,
         g_rbb.rbb01,g_rbb.rbbplant,g_rbb.rbbconf,
         g_rbb.rbboriu,g_rbb.rbborig,g_rbb.rbbuser,
#FUN-B30028 ---------------END
         g_rbb.rbbgrup,g_rbb.rbbcrat,g_rbb.rbbacti
  
    INPUT BY NAME g_rbb.rbb02,g_rbb.rbb04t,g_rbb.rbb05t,g_rbb.rbb06t,
#                  g_rbb.rbbmksg,                                            #FUN-B30028 mark
                  g_rbb.rbb07t,g_rbb.rbb08t,g_rbb.rbb09t,g_rbb.rbb10t
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
          CALL cl_set_docno_format("rbb02")
 
        LET  g_before_input_done = FALSE
        CALL t402_set_entry(p_cmd)
        CALL t402_set_no_entry(p_cmd)
        LET  g_before_input_done = TRUE
 
        BEFORE FIELD rbb02
          #CALL cl_set_comp_entry("rbb04t,rbb05t,rbb06t,rbb07t,rbb08t,rbb09t,rbb10t",FALSE)
 
 
        AFTER FIELD rbb02                   #促銷單號
            IF NOT cl_null(g_rbb.rbb02) THEN
               IF cl_null(g_rbb_t.rbb02) OR (g_rbb.rbb02 != g_rbb_t.rbb02) THEN
                  CALL t402_rbb02()  
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rbb.rbb02,g_errno,0)
                     NEXT FIELD rbb02
                  END IF
               END IF
            ELSE
               NEXT FIELD rbb02
            END IF           
 
 
 
        AFTER INPUT
           LET g_rbb.rbbuser = s_get_data_owner("rbb_file") #FUN-C10039
           LET g_rbb.rbbgrup = s_get_data_group("rbb_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
           #IF g_rbb.rbb02 IS NULL THEN            #單號
           #   LET l_flag='Y'
           #   DISPLAY  g_rbb.rbb02 TO rbb02
           #END IF
 
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD rbb02
            END IF
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add
 
 
        ON ACTION CONTROLP
           CASE   
                WHEN INFIELD(rbb02) #查詢符合條件的單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rab02"
                     LET g_qryparam.default1 = g_rbb.rbb02
                     LET g_qryparam.arg1 = g_plant            
                     CALL cl_create_qry() RETURNING g_rbb.rbb02
                     DISPLAY BY NAME g_rbb.rbb02
                     #CALL t402_rbb02()
                     NEXT FIELD rbb02
               OTHERWISE EXIT CASE
             END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about   
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION controlg   
         CALL cl_cmdask() 
 
 
    END INPUT
END FUNCTION
 
 
FUNCTION t402_r()
    DEFINE l_flag LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rbb.rbb02 IS NULL THEN
       CALL cl_err("",-400,0)                  
       RETURN
    END IF
 
    SELECT * INTO g_rbb.* FROM rbb_file
    WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
      AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant

    IF g_rbb.rbbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbb.rbb02,9027,0)
       RETURN
    END IF
    
    #IF g_rbb.rbbconf = 'Y' THEN
    #IF g_rbb.rbbconf = 'Y' OR  g_rbb.rbbconf = 'I' THEN  #modify by lixia #FUN-AB0033 mark 
    IF g_rbb.rbbconf = 'Y' THEN  #FUN-AB0033 add
       CALL cl_err('','art-023',0)
       RETURN
    END IF
    #FUN-AB0033 mark ------start------
    #IF g_rbb.rbbconf = 'X' THEN
    #   CALL cl_err('','9024',0)
    #   RETURN
    #END IF
    #FUN-AB0033 mark -------end-------
  
 
    BEGIN WORK
 
    OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
    IF STATUS THEN
       CALL cl_err("OPEN t402_cl:", STATUS, 1)
       CLOSE t402_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t402_cl INTO g_rbb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t402_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL            
        LET g_doc.column1 = "rbb01"          
        LET g_doc.column2 = "rbb02"           
        LET g_doc.value1 = g_rbb.rbb01        
        LET g_doc.value2 = g_rbb.rbb02       
        CALL cl_del_doc()               
         DELETE FROM rbb_file WHERE rbb01 = g_rbb.rbb01
                                AND rbb02 = g_rbb.rbb02
                                AND rbb03 = g_rbb.rbb03
                                AND rbbplant = g_rbb.rbbplant
         DELETE FROM rbc_file WHERE rbc01 = g_rbb.rbb01
                                AND rbc02 = g_rbb.rbb02
                                AND rbc03 = g_rbb.rbb03
                                AND rbcplant = g_rbb.rbbplant
         DELETE FROM rbd_file WHERE rbd01 = g_rbb.rbb01
                                AND rbd02 = g_rbb.rbb02 
                                AND rbd03 = g_rbb.rbb03
                                AND rbdplant = g_rbb.rbbplant 
         DELETE FROM rbq_file WHERE rbq01 = g_rbb.rbb01
                                AND rbq02 = g_rbb.rbb02 
                                AND rbq03 = g_rbb.rbb03
                                AND rbqplant = g_rbb.rbbplant
         DELETE FROM rbp_file WHERE rbp01 = g_rbb.rbb01
                                AND rbp02 = g_rbb.rbb02
                                AND rbp03 = g_rbb.rbb03
                                AND rbpplant = g_rbb.rbbplant                                             
       #FUN-BC0072 add START
         DELETE FROM rbk_file WHERE rbk01 = g_rbb.rbb01
                                AND rbk02 = g_rbb.rbb02
                                AND rbk03 = g_rbb.rbb03
                                AND rbkplant = g_rbb.rbbplant
       #FUN-BC0072 add END
         INITIALIZE g_rbb.* TO NULL
         CLEAR FORM
         CALL g_rbc.clear()
         CALL g_rbk.clear()  #FUN-BC0072 add 
         OPEN t402_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t402_cs
            CLOSE t402_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t402_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t402_cs
            CLOSE t402_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t402_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t402_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t402_fetch('/')
         END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身1
{
FUNCTION t402_b1()
DEFINE l_sql      STRING
DEFINE
    l_ac1_t         LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #No.MOD-650101 add  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    p_cmd           LIKE type_file.chr1                  #處理狀態  #No.FUN-680136 VARCHAR(1)
   #l_misc          LIKE type_file.chr4,                #No.FUN-680136 VARCHAR(04)
   #l_cmd           LIKE type_file.chr1,                #採購單身是否為新增  #No.FUN-680136 VARCHAR(1)
   #l_no            LIKE pmn_file.pmn04,
   #l_qty           LIKE rbc_file.rbc20a,		#Qty
   #l_up            LIKE rbc_file.rbc31a,		#Unit Price
   #lt_up           LIKE rbc_file.rbc32a,		#Unit Tax Price #No.FUN-610018
 
   #l_rvv17         LIKE rvv_file.rvv17,
   #l_rvb87         LIKE rvb_file.rvb87,   #No.MOD-640426 add
   #l_rbc20a        LIKE rbc_file.rbc20a,
   #l_rvu01         LIKE rvu_file.rvu01,
   #l_rate          LIKE sma_file.sma343,  #No.FUN-680136 DEC(5,2)
   #l_possible      LIKE type_file.num5,   #No.FUN-680136 SMALLINT    #用來設定判斷重複的可能性
   #l_new,l_old     LIKE rbc_file.rbc20a,
   #l_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
   #l_rvb07         LIKE rvb_file.rvb07,
   #l_sfb100        LIKE sfb_file.sfb100,
   #l_newline       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)   #Y:為新的項次 No:7629
   #l_rbb13         LIKE rbb_file.rbb13,    #MOD-5A0416

   #l_price,lt_price LIKE ima_file.ima53,
   #l_rbb08    LIKE rbb_file.rbb08,
   #l_rbc20    LIKE rbc_file.rbc20b,
   #l_rbc07    LIKE rbc_file.rbc07b, 
 
 
#DEFINE  l_task   LIKE ecm_file.ecm04,   #CHI-8A0022
#        l_type   LIKE type_file.chr1    #CHI-8A0022

DEFINE   l_rbc04_curr  LIKE rbc_file.rbc04 
DEFINE l_price    LIKE rac_file.rac05
DEFINE l_discount LIKE rac_file.rac06
DEFINE l_date     LIKE rac_file.rac12
DEFINE l_time1    LIKE type_file.num5
DEFINE l_time2    LIKE type_file.num5

DEFINE l_rbc      RECORD LIKE rbc_file.*  #100921

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_rbb.rbb02) THEN
       RETURN
    END IF
    SELECT * INTO g_rbb.* FROM rbb_file
      WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02 
        AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant

    IF g_rbb.rbbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbb.rbb01||g_rbb.rbb02,'mfg1000',1)
       RETURN
    END IF 
    #IF g_rbb.rbbconf = 'Y' THEN
    #IF g_rbb.rbbconf = 'Y' OR  g_rbb.rbbconf = 'I' THEN  #modify by lixia #FUN-AB0033 mark
    IF g_rbb.rbbconf = 'Y' THEN  #FUN-AB0033 add
       CALL cl_err('','art-024',1)
       RETURN
    END IF
    #TQC-AC0326 add ---------begin----------
    IF g_rbb.rbb01 <> g_rbb.rbbplant THEN 
       CALL cl_err('','art-977',0) 
       RETURN 
    END IF
    #TQC-AC0326 add ----------end-----------
    #FUN-AB0033 mark ------start------
    #IF g_rbb.rbbconf = 'X' THEN
    #   CALL cl_err('','art-025',1)
    #   RETURN
    #END IF
    #FUN-AB0033 mark ------start------
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT * ",
                       "   FROM rbc_file ",
                       "  WHERE rbc01 = ?  AND rbc02 = ? AND rbc03= ? AND rbcplant= ? ",
                       "    AND rbc06 = ? ",
                       "    AND rbc05='1' ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t402_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac1_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rbc WITHOUT DEFAULTS FROM s_rbc.*
              ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
           #LET l_newline = 'N' #No:7629 一開始先設 "為新增的項次否='N'"
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()  
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)          #NO.MOD-AC0179
            BEGIN WORK
     
            OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
            IF STATUS THEN
               CALL cl_err("OPEN t402_cl:", STATUS, 1)
               CLOSE t402_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t402_cl INTO g_rbb.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rbb.rbb01||g_rbb.rbb02,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t402_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b1>=l_ac1 THEN
                LET p_cmd='u'
                LET g_rbc_t.* = g_rbc[l_ac1].*  #BACKUP
                LET g_rbc_o.* = g_rbc[l_ac1].*  #BACKUP
               #LET g_rbc04_o = g_rbc[l_ac1].rbc04   
               #LET g_rbc05_o = g_rbc[l_ac1].rbc05   
               #LET g_rbc06_o = g_rbc[l_ac1].rbc06   
 
              #100921 cockroach add--
               LET l_sql = " SELECT b.rbc04,'',a.rbc05,a.rbc06,a.rbc07,a.rbc08,a.rbc09,a.rbc10,a.rbc11, ",
                          #"                   a.rbc12,a.rbc13,a.rbc14,a.rbc15,a.rbc16,a.rbc17,a.rbc18,a.rbcacti,",  #FUN-BC0072 mark
                           "                   a.rbc12,a.rbc13,a.rbc14,a.rbcacti,",  #FUN-BC0072 add
                           "                   b.rbc05,b.rbc06,b.rbc07,b.rbc08,b.rbc09,b.rbc10,b.rbc11, ",
                          #"                   b.rbc12,b.rbc13,b.rbc14,b.rbc15,b.rbc16,b.rbc17,b.rbc18,b.rbcacti ",  #FUN-BC0072mark
                           "                   b.rbc12,b.rbc13,b.rbc14,b.rbcacti ",  #FUN-BC0072 add
                           "   FROM rbc_file b LEFT OUTER JOIN rbc_file a",
                           "                   ON (b.rbc01=a.rbc01 AND b.rbc02=a.rbc02 AND b.rbc03=a.rbc03 ",
                           "                       AND b.rbc04=a.rbc04 AND b.rbc06=a.rbc06 AND b.rbcplant=a.rbcplant AND b.rbc05<>a.rbc05 ) ",#lixia
                           "  WHERE b.rbc01 = '",g_rbb.rbb01,"'  AND b.rbc02 = '",g_rbb.rbb02,"'",
                           "    AND b.rbc03=  '",g_rbb.rbb03,"'  AND b.rbcplant= '",g_rbb.rbbplant,"'",
                           "    AND b.rbc06 = '",g_rbc_t.rbc06,"' ",
                           "    AND b.rbc05='1' "
               PREPARE sel_rbc_row FROM l_sql
               EXECUTE sel_rbc_row INTO l_rbc04_curr,g_rbc[l_ac1].*
              #100921 cockroach add end--
                OPEN t402_bcl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant,
                                    g_rbc_t.rbc06 
                IF STATUS THEN
                    CALL cl_err("OPEN t402_bcl:", STATUS, 1)
                ELSE
                   #FETCH t402_bcl INTO l_rbc04_curr,g_rbc[l_ac1].*  #cockroach 100921 mark
                    FETCH t402_bcl INTO l_rbc.*                      #FUN-BC0072 add
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rbc_t.type||g_rbc_t.rbc06,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    IF g_rbc[l_ac1].before='0' THEN
                       LET g_rbc[l_ac1].type ='1'
                    ELSE
                       LET g_rbc[l_ac1].type ='0'
                    END IF
                  #  CALL t402_set_no_entry_b1() #MOD-5A0416 add
                  #  CALL t402_set_no_required(l_newline) #MOD-530022
                  #  CALL t402_set_required(l_newline)    #MOD-530022
                END IF
               #   CALL t402_set_entry_b()
               #   CALL t402_set_no_entry_b()
               #   CALL t402_set_no_entry_b1() #MOD-5A0416 add
               #   CALL t402_set_no_required(l_newline)
               #   CALL t402_set_required(l_newline)
 
                CALL cl_show_fld_cont()      
            END IF
       
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_rbc[l_ac1].type= '0' THEN
               INSERT INTO rbc_file(rbc01,rbc02,rbc03,rbc04,rbc05,
                                    rbc06,rbc07,rbc08,rbc09,rbc10,
                                   #rbc11,rbc12,rbc13,rbc14,rbc15,  #FUN-BC0072 mark
                                   #rbc16,rbc17,rbc18,rbc19,rbc20,  #FUN-BC0072 mark
                                    rbc11,rbc12,rbc13,rbc14,        #FUN-BC0072 add
                                    rbc19,rbc20,                    #FUN-BC0072 add
                                    rbcacti,rbcplant,rbclegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbc04_curr,g_rbc[l_ac1].after,
                      g_rbc[l_ac1].rbc06,g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc09,g_rbc[l_ac1].rbc10,
                     #g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,g_rbc[l_ac1].rbc14,g_rbc[l_ac1].rbc15, #FUN-BC0072 mark 
                     #g_rbc[l_ac1].rbc16,g_rbc[l_ac1].rbc17,g_rbc[l_ac1].rbc18,' ',' ',                               #FUN-BC0072 mark
                      g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,g_rbc[l_ac1].rbc14,' ' ,' ',           #FUN-BC0072 add 
                      g_rbc[l_ac1].rbcacti,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbc_file",g_rbb.rbb02||g_rbc[l_ac1].after||g_rbc[l_ac1].rbc06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b1=g_rec_b1+1
                  DISPLAY g_rec_b1 TO FORMONLY.cn1
               END IF
           
            ELSE
               INSERT INTO rbc_file(rbc01,rbc02,rbc03,rbc04,rbc05,
                                    rbc06,rbc07,rbc08,rbc09,rbc10,
                                   #rbc11,rbc12,rbc13,rbc14,rbc15,  #FUN-BC0072 mark
                                   #rbc16,rbc17,rbc18,rbc19,rbc20,  #FUN-BC0072 mark
                                    rbc11,rbc12,rbc13,rbc14,        #FUN-BC0072 add
                                    rbc19,rbc20,                    #FUN-BC0072 add
                                    rbcacti,rbcplant,rbclegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbc04_curr,g_rbc[l_ac1].after,
                      g_rbc[l_ac1].rbc06,g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc09,g_rbc[l_ac1].rbc10,
                     #g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,g_rbc[l_ac1].rbc14,g_rbc[l_ac1].rbc15, #FUN-BC0072 mark
                     #g_rbc[l_ac1].rbc16,g_rbc[l_ac1].rbc17,g_rbc[l_ac1].rbc18,' ',' ', #FUN-BC0072 mark
                      g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,g_rbc[l_ac1].rbc14,' ',' ',  #FUN-BC0072 add
                      g_rbc[l_ac1].rbcacti,g_rbb.rbbplant,g_rbb.rbblegal)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbc_file",g_rbb.rbb02||g_rbc[l_ac1].after||g_rbc[l_ac1].rbc06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT 
               ELSE
                  MESSAGE 'INSERT value.after O.K' 
               END IF
               INSERT INTO rbc_file(rbc01,rbc02,rbc03,rbc04,rbc05,
                                    rbc06,rbc07,rbc08,rbc09,rbc10,
                                   #rbc11,rbc12,rbc13,rbc14,rbc15, #FUN-BC0072 mark 
                                   #rbc16,rbc17,rbc18,rbc19,rbc20, #FUN-BC0072 mark
                                    rbc11,rbc12,rbc13,rbc14,        #FUN-BC0072 add
                                    rbc19,rbc20,                    #FUN-BC0072 add
                                    rbcacti,rbcplant,rbclegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbc04_curr,g_rbc[l_ac1].before,
                      g_rbc[l_ac1].rbc06_1,g_rbc[l_ac1].rbc07_1,g_rbc[l_ac1].rbc08_1,g_rbc[l_ac1].rbc09_1,g_rbc[l_ac1].rbc10_1,
                     #g_rbc[l_ac1].rbc11_1,g_rbc[l_ac1].rbc12_1,g_rbc[l_ac1].rbc13_1,g_rbc[l_ac1].rbc14_1,g_rbc[l_ac1].rbc15_1, #FUN-BC0072 mark
                     #g_rbc[l_ac1].rbc16_1,g_rbc[l_ac1].rbc17_1,g_rbc[l_ac1].rbc18_1,' ',' ',  #FUN-BC0072 mark
                      g_rbc[l_ac1].rbc11_1,g_rbc[l_ac1].rbc12_1,g_rbc[l_ac1].rbc13_1,g_rbc[l_ac1].rbc14_1,' ',' ',  #FUN-BC0072 add
                      g_rbc[l_ac1].rbcacti_1,g_rbb.rbbplant,g_rbb.rbblegal)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbc_file",g_rbb.rbb02||g_rbc[l_ac1].before||g_rbc[l_ac1].rbc06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT value.before O.K'
                  COMMIT WORK
                  LET g_rec_b1=g_rec_b1+1
                  DISPLAY g_rec_b1 TO FORMONLY.cn1
               END IF
            END IF

 
        BEFORE INSERT
            DISPLAY "BEFORE INSERT!"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rbc[l_ac1].* TO NULL 
            LET g_rbc[l_ac1].type = '0'      
            LET g_rbc[l_ac1].before = '0'
            LET g_rbc[l_ac1].after  = '1' 
            LET g_rbc_t.* = g_rbc[l_ac1].*         #新輸入資料
            LET g_rbc_o.* = g_rbc[l_ac1].*
            SELECT MAX(rbc04)+1 INTO l_rbc04_curr 
              FROM rbc_file
             WHERE rbc01=g_rbb.rbb01
               AND rbc02=g_rbb.rbb02 
               AND rbc03=g_rbb.rbb03 
               AND rbcplant=g_rbb.rbbplant
              IF l_rbc04_curr IS NULL OR l_rbc04_curr=0 THEN
                 LET l_rbc04_curr = 1
              END IF                          
           #CALL cl_show_fld_cont()     #FUN-550037(smin)
           #CALL t402_set_no_required(l_newline) #MOD-530022
           #CALL t402_set_no_entry_b1() #FUN-610018
           #CALL t402_set_entry_b2('N')  #FUN-690129 add
            
           CALL cl_show_fld_cont()
           NEXT FIELD rbc06
 
     # BEFORE FIELD type 
     #    CALL t402_set_entry_b1() 
     # ON CHANGE type 
     #       CALL t402_set_entry_b1()
     # AFTER FIELD type 
     #      IF NOT cl_null(g_rbc[l_ac1].type) THEN
     #         IF g_rbc[l_ac1].type NOT MATCHES '[01]' THEN 
     #            NEXT FIELD type 
     #         ELSE 
     #            CALL t402_set_entry_b1()       
     #         END IF
     #      END IF
        
        #FUN-AB0033 mark --------------start-----------------
        #BEFORE FIELD rbc06
        #   IF g_rbc[l_ac1].rbc06 IS NULL OR g_rbc[l_ac1].rbc06 = 0 THEN
        #      SELECT max(rbc06)+1
        #        INTO g_rbc[l_ac1].rbc06
        #        FROM rbc_file
        #       WHERE rbc02 = g_rbb.rbb02 AND rbc01 = g_rbb.rbb01
        #         AND rbc03 = g_rbb.rbb03 AND rbcplant = g_rbb.rbbplant
        #      IF g_rbc[l_ac1].rbc06 IS NULL THEN
        #         LET g_rbc[l_ac1].rbc06 = 1
        #      END IF
        #   END IF     
        #FUN-AB0033 mark ---------------end------------------
     
       AFTER FIELD rbc06
           IF NOT cl_null(g_rbc[l_ac1].rbc06) THEN
              IF (g_rbc[l_ac1].rbc06 <> g_rbc_t.rbc06
                 OR cl_null(g_rbc_t.rbc06)) THEN 
                 SELECT COUNT(*) INTO l_n 
                   FROM rac_file
                  WHERE rac01=g_rbb.rbb01 AND rac02=g_rbb.rbb02
                    AND racplant=g_rbb.rbbplant AND rac03=g_rbc[l_ac1].rbc06
                 IF l_n=0 THEN
                    IF NOT cl_confirm('art-677') THEN   #確定新增?
                       NEXT FIELD rbc06
                    ELSE
                       CALL t402_b1_init()
                    END IF
                 ELSE
                    IF NOT cl_confirm('art-676') THEN   #確定修改?
                       NEXT FIELD rbc06
                    ELSE
                       CALL t402_b1_find()   
                    END IF           
                 END IF
              END IF       
           END IF
           
      AFTER FIELD rbc07
         IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
            IF g_rbc_o.rbc07 IS NULL OR
               (g_rbc[l_ac1].rbc07 != g_rbc_o.rbc07 ) THEN
               IF g_rbc[l_ac1].rbc07 NOT MATCHES '[123]' THEN
                  LET g_rbc[l_ac1].rbc07= g_rbc_o.rbc07
                  NEXT FIELD rbc07
            #  ELSE                                          #NO.MOD-AC0179
            #     CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)    #NO.MOD-AC0179
               END IF
            END IF
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)          #NO.MOD-AC0179
         END IF

      ON CHANGE rbc07
         IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)
         END IF                             
                    
      ON CHANGE rbc11
         IF NOT cl_null(g_rbc[l_ac1].rbc11) THEN
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)
         END IF         

      BEFORE FIELD rbc08,rbc09,rbc10,rbc12,rbc13,rbc14
         IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)
         END IF
      AFTER FIELD rbc08,rbc12    #特賣價
      IF g_rbc[l_ac1].rbc07 = '1' THEN   #MOD-AC0179
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-180',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc12
           #DISPLAY BY NAME CURRENT
         END IF
      END IF               #MOD-AC0179
      AFTER FIELD rbc09,rbc13   #折扣率
         IF g_rbc[l_ac1].rbc07 = '2' THEN   #MOD-AC0179
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rbc[l_ac1].rbc09,g_rbc[l_ac1].rbc13
           END IF
        END IF               #MOD-AC0179
     AFTER FIELD rbc10,rbc14    #折讓額
        IF g_rbc[l_ac1].rbc07 = '3' THEN   #MOD-AC0179
         LET l_price = FGL_DIALOG_GETBUFFER()
         IF l_price <= 0 THEN
            CALL cl_err('','art-653',0)
            NEXT FIELD CURRENT
         ELSE
            DISPLAY BY NAME g_rbc[l_ac1].rbc10,g_rbc[l_ac1].rbc14
           #DISPLAY BY NAME CURRENT
         END IF
    END IF               #MOD-AC0179
       #FUN-AB0033 mark ------------start----------------- 
       #AFTER FIELD rbc15,rbc16  #開始,結束日期
       #    LET l_date = FGL_DIALOG_GETBUFFER()
       #    IF p_cmd='a' OR (p_cmd='u' AND 
       #             (DATE(l_date)<>g_rbc_t.rbc15 OR DATE(l_date)<>g_rbc_t.rbc16)) THEN       
       #            #(DATE(l_date)<>g_rbc_t.rbc15 AND DATE(l_date)<>g_rbc_t.rbc16)) THEN       
       #          IF INFIELD(rbc15) THEN
       #             IF NOT cl_null(g_rbc[l_ac1].rbc16) THEN
       #                IF DATE(l_date)>g_rbc[l_ac1].rbc16 THEN
       #                   CALL cl_err('','art-201',0)
       #                   NEXT FIELD rbc15
       #                END IF
       #             END IF
       #          END IF
       #          IF INFIELD(rbc16) THEN
       #             IF NOT cl_null(g_rbc[l_ac1].rbc15) THEN
       #                IF DATE(l_date)<g_rbc[l_ac1].rbc15 THEN
       #                   CALL cl_err('','art-201',0)
       #                   NEXT FIELD rbc16
       #                END IF
       #             END IF
       #          END IF 
       #   END IF
         
          
       #AFTER FIELD rbc17  #開始時間
       #  IF NOT cl_null(g_rbc[l_ac1].rbc17) THEN
       #     IF p_cmd = "a" OR                    
       #            (p_cmd = "u" AND g_rbc[l_ac1].rbc17<>g_rbc_t.rbc17) THEN 
       #        CALL t402_chktime(g_rbc[l_ac1].rbc17) RETURNING l_time1
       #        IF NOT cl_null(g_errno) THEN
       #            CALL cl_err('',g_errno,0)
       #            NEXT FIELD rbc17
       #        ELSE
       #          IF NOT cl_null(g_rbc[l_ac1].rbc18) THEN
       #             CALL t402_chktime(g_rbc[l_ac1].rbc18) RETURNING l_time2
       #             IF l_time1>=l_time2 THEN
       #                CALL cl_err('','art-207',0)
       #                NEXT FIELD rbc17   
       #             END IF
       #          END IF
       #        END IF
       #      END IF
       #  END IF
       #  
       #AFTER FIELD rbc18  #結束時間
       #  IF NOT cl_null(g_rbc[l_ac1].rbc18) THEN
       #     IF p_cmd = "a" OR                    
       #            (p_cmd = "u" AND g_rbc[l_ac1].rbc18<>g_rbc_t.rbc18) THEN 
       #         CALL t402_chktime(g_rbc[l_ac1].rbc18) RETURNING l_time2
       #         IF NOT cl_null(g_errno) THEN
       #            CALL cl_err('',g_errno,0)
       #            NEXT FIELD rbc18
       #         ELSE
       #            IF NOT cl_null(g_rbc[l_ac1].rbc17) THEN
       #               CALL t402_chktime(g_rbc[l_ac1].rbc17) RETURNING l_time1
       #               IF l_time1>=l_time2 THEN
       #                  CALL cl_err('','art-207',0)
       #                  NEXT FIELD rbc18
       #               END IF
       #            END IF
       #         END IF
       #     END IF
       #  END IF              
       #FUN-AB0033 mark -------------end------------------  
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rbc_t.rbc06 > 0 AND g_rbc_t.rbc06 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
             # SELECT COUNT(*) INTO l_n FROM rad_file
             SELECT COUNT(*) INTO l_n FROM rbd_file     #lixia
               WHERE rbd01=g_rbb.rbb01 AND rbd02=g_rbb.rbb02
                 AND rbd03=g_rbb.rbb03 AND rbdplant=g_rbb.rbbplant
                 AND rbd06=g_rbc_t.rbc06
              IF l_n>0 THEN
                 CALL cl_err(g_rbc_t.rbc06,'art-664',0)
                 CANCEL DELETE
              ELSE 
                 SELECT COUNT(*) INTO l_n FROM rap_file
                  WHERE rap01=g_rbb.rbb01 AND rap02=g_rbb.rbb02 AND rap04='1'
                    AND rap03=g_rbb.rbb03 AND rapplant=g_rbb.rbbplant
                    AND rap07=g_rbc_t.rbc06
                 IF l_n>0 THEN
                    CALL cl_err(g_rbc_t.rbc06,'art-665',0)
                    CANCEL DELETE 
                 END IF
              END IF
             #IF g_aza.aza88='Y' THEN
             #  #IF NOT (g_rbc[l_ac1].rbcacti='N' AND g_rbc[l_ac1].rbcpos='Y') THEN
             #  #   CALL cl_err('', 'art-648', 1)
             #  #   CANCEL DELETE
             #  #END IF
             #END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rbc_file
               WHERE rbc02 = g_rbb.rbb02 AND rbc01 = g_rbb.rbb01
                 AND rbc03 = g_rbb.rbb03 AND rbc04 = l_rbc04_curr
                # AND rbc06 = g_rbc_t.rbc06  
                 AND rbcplant = g_rbb.rbbplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rbc_file",g_rbb.rbb01,g_rbc_t.rbc06,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              CALL t402_upd_log() 
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbc[l_ac1].* = g_rbc_t.*
              CLOSE t402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rbc[l_ac1].rbc07) THEN
              NEXT FIELD rbc07
           END IF
          #IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbc[l_ac1].rbc06,-263,1)
              LET g_rbc[l_ac1].* = g_rbc_t.*
           ELSE
             #IF g_aza.aza88='Y' THEN
             #  #LET g_rbc[l_ac1].rbcpos='N' 
             #  #DISPLAY BY NAME g_rbc[l_ac1].rbcpos
             #END IF
              UPDATE rbc_file SET rbc07  =g_rbc[l_ac1].rbc07,
                                  rbc08  =g_rbc[l_ac1].rbc08,
                                  rbc09  =g_rbc[l_ac1].rbc09,
                                  rbc10  =g_rbc[l_ac1].rbc10,
                                  rbc11  =g_rbc[l_ac1].rbc11,
                                  rbc12  =g_rbc[l_ac1].rbc12,
                                  rbc13  =g_rbc[l_ac1].rbc13,
                                  rbc14  =g_rbc[l_ac1].rbc14,
                                 #FUN-BC0072 mark START
                                 #rbc15  =g_rbc[l_ac1].rbc15,
                                 #rbc16  =g_rbc[l_ac1].rbc16,
                                 #rbc17  =g_rbc[l_ac1].rbc17,
                                 #rbc18  =g_rbc[l_ac1].rbc18,
                                 #FUN-BC0072 mark END
                                  rbcacti=g_rbc[l_ac1].rbcacti
               WHERE rbc02 = g_rbb.rbb02 AND rbc01=g_rbb.rbb01
                 AND rbc03 = g_rbb.rbb03 AND rbc04=l_rbc04_curr AND rbc05='1'
                 AND rbc06=g_rbc_t.rbc06 AND rbcplant = g_rbb.rbbplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rbc_file",g_rbb.rbb01,g_rbc_t.rbc06,SQLCA.sqlcode,"","",1) 
                 LET g_rbc[l_ac1].* = g_rbc_t.*
              ELSE
               #FUN-BC0072 mark START
               # IF g_rbc[l_ac1].rbc15<>g_rbc_t.rbc15 OR
               #    g_rbc[l_ac1].rbc16<>g_rbc_t.rbc16 OR
               #    g_rbc[l_ac1].rbc17<>g_rbc_t.rbc17 OR
               #    g_rbc[l_ac1].rbc18<>g_rbc_t.rbc18 THEN
               #   #CALL t402_repeat(g_rbc[l_ac1].rbc06)  #check
               # END IF 
               #FUN-BC0072 mark END
                 MESSAGE 'UPDATE rbc_file O.K'
                 CALL t402_upd_log() 
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbc[l_ac1].* = g_rbc_t.*
              END IF
              CLOSE t402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF  
           
           #FUN-AB0033 add ----------------start-------------------
          #FUN-BC0072 mark START
          #IF NOT cl_null(g_rbc[l_ac1].rbc15) AND NOT cl_null(g_rbc[l_ac1].rbc16) THEN
          #   IF g_rbc[l_ac1].rbc15>g_rbc[l_ac1].rbc16 THEN
          #      CALL cl_err('','art-201',0)
          #      NEXT FIELD rbc15
          #   END IF
          #END IF
          #
          #IF NOT cl_null(g_rbc[l_ac1].rbc17) AND NOT cl_null(g_rbc[l_ac1].rbc18) THEN
          #   CALL t402_chktime(g_rbc[l_ac1].rbc17) RETURNING l_time1
          #   CALL t402_chktime(g_rbc[l_ac1].rbc18) RETURNING l_time2
          #   IF l_time1>=l_time2 THEN
          #      CALL cl_err('','art-207',0)
          #      NEXT FIELD rbc17
          #   END IF   
          #END IF
          #FUN-BC0072 mark END 
           #FUN-AB0033 add -----------------end--------------------
           CLOSE t402_bcl
           COMMIT WORK
 
        ON ACTION alter_memberlevel    #會員等級促銷
           IF NOT cl_null(g_rbb.rbb02) THEN
              IF g_rbc[l_ac1].rbc11 <> '0' AND NOT cl_null(g_rbc[l_ac1].rbc11) THEN  #FUN-BC0072 add
                #CALl t402_2(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf,'')  #FUN-BC0072 mark
                 CALl t402_2(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf,
                             g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc06)  #FUN-BC0072 add   #TQC-C20328 add rbc06
              END IF #FUN-BC0072 add
           ELSE
              CALL cl_err('',-400,0)
           END IF

        ON ACTION CONTROLO
           IF INFIELD(rbc06) AND l_ac1 > 1 THEN
              LET g_rbc[l_ac1].* = g_rbc[l_ac1-1].*
             #LET l_rbc04_curr = l_rbc04_curr + 1
              LET g_rec_b1 = g_rec_b1+1
              NEXT FIELD rbc06
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       #ON ACTION controlp
       #   CASE
       #      WHEN INFIELD(rbc07)
       #      WHEN INFIELD(rbc08)
       #      WHEN INFIELD(rbc09)
       #      OTHERWISE EXIT CASE
       #    END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
    CLOSE t402_bcl
    COMMIT WORK
    #CALL s_showmsg()
    #CALL t402_delall() #FUN-AB0033 mark
 
END FUNCTION          


FUNCTION t402_b2()
DEFINE l_sql      STRING
DEFINE
    l_ac2_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE l_ima25      LIKE ima_file.ima25
DEFINE l_rbd04_curr LIKE rbd_file.rbd04

DEFINE l_rbd        RECORD LIKE rbd_file.*  #100921 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rbb.rbb02 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rbb.* FROM rbb_file
     WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
       AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
 
    IF g_rbb.rbbacti ='N' THEN
       CALL cl_err(g_rbb.rbb02,'mfg1000',0)
       RETURN
    END IF
    
    #IF g_rbb.rbbconf = 'Y' THEN
    #IF g_rbb.rbbconf = 'Y' OR  g_rbb.rbbconf = 'I' THEN  #nodify by lixia #FUN-AB0033 mark
    IF g_rbb.rbbconf = 'Y' THEN #FUN-AB0033 add
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    #TQC-AC0326 add ---------begin----------
    IF g_rbb.rbb01 <> g_rbb.rbbplant THEN 
       CALL cl_err('','art-977',0) 
       RETURN 
    END IF
    #TQC-AC0326 add ----------end-----------
    #FUN-AB0033 mark ------start------
    #IF g_rbb.rbbconf = 'X' THEN                                                                                             
    #   CALL cl_err('','art-025',0)                                                                                          
    #   RETURN                                                                                                               
    #END IF
    #FUN-AB0033 mark ------start------
    CALL cl_opmsg('b')
    #CALL s_showmsg_init()


    LET g_forupd_sql = " SELECT * ",
                       "   FROM rbd_file ",
                       "  WHERE rbd01=? AND rbd02 = ? ",
                       "    AND rbd03=? AND rbdplant=?  AND rbd06=? AND rbd07=? AND rbd09 = ?",  #FUN-BC0072 add rbd09  
                       "    AND rbd05='1'",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR         


    LET l_ac2_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        
    INPUT ARRAY g_rbd WITHOUT DEFAULTS FROM s_rbd.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           CALL t402_rbd07_chk() 
 
           BEGIN WORK
 
           OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
           IF STATUS THEN
              CALL cl_err("OPEN t402_cl:", STATUS, 1)
              CLOSE t402_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t402_cl INTO g_rbb.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
              CLOSE t402_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u'
              LET g_rbd_t.* = g_rbd[l_ac2].*  #BACKUP
              LET g_rbd_o.* = g_rbd[l_ac2].*  #BACKUP
             #cockroach 100921 add---
              LET l_sql = " SELECT b.rbd04,'',a.rbd05,a.rbd06,a.rbd07,a.rbd08,'',a.rbd09,'',a.rbdacti, ",
                          "                   b.rbd05,b.rbd06,b.rbd07,b.rbd08,'',b.rbd09,'',b.rbdacti  ",
                          "   FROM rbd_file b LEFT OUTER JOIN rbd_file a",
                          "        ON (b.rbd01=a.rbd01 AND b.rbd02=a.rbd02 AND b.rbd03=a.rbd03 AND b.rbd04=a.rbd04 ",
                          "            AND b.rbd06=a.rbd06 AND b.rbd07=a.rbd07 AND b.rbdplant=a.rbdplant AND b.rbd05<>a.rbd05 ) ",   #lixia
                         #MODIFY BY LIXIA ----START-----
                         # "  WHERE b.rbd01 = ? AND b.rbd02 = ? ",
                         # "    AND b.rbd03=? AND b.rbdplant=?  AND b.rbd06=? AND b.rbd07=? ",  
                         # "    AND b.rbd05='1'" 
                         # " FOR UPDATE   "    
                          "  WHERE b.rbd01 = '",g_rbb.rbb01,"'  AND b.rbd02 = '",g_rbb.rbb02,"'",
                          "    AND b.rbd03 ='",g_rbb.rbb03,"'   AND b.rbdplant='",g_rbb.rbbplant,"'",
                          "    AND b.rbd06 ='",g_rbd_t.rbd06,"' AND b.rbd07='",g_rbd_t.rbd07,"' ",
                          "    AND b.rbd05='1'"
                         #MODIFY BY LIXIA ----END-----
              PREPARE sel_rbd_row FROM l_sql
              EXECUTE sel_rbd_row INTO l_rbd04_curr,g_rbd[l_ac2].*
              OPEN t4021_bcl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant,
                                   g_rbd_t.rbd06,g_rbd_t.rbd07,g_rbd_t.rbd09   #FUN-BC0072 add rbd09
              IF STATUS THEN
                 CALL cl_err("OPEN t4021_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                #FETCH t4021_bcl INTO l_rbd04_curr,g_rbd[l_ac2].*  #cockroach mark 100921
                 FETCH t4021_bcl INTO l_rbd.*                      #FUN-BC0072 add
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rbd_t.rbd06,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t402_rbd07()   
                 CALL t402_rbd08('d',l_ac2)
                 CALL t402_rbd09('d')
              END IF
           END IF 
 
                  #  CALL t402_set_no_entry_b1()  
                  #  CALL t402_set_no_required(l_newline)  
                  #  CALL t402_set_required(l_newline)     
             
               #   CALL t402_set_entry_b()
               #   CALL t402_set_no_entry_b()
               #   CALL t402_set_no_entry_b1() 
 
  
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
 
            IF g_rbd[l_ac2].type1= '0' THEN
               INSERT INTO rbd_file(rbd01,rbd02,rbd03,rbd04,rbd05,
                                    rbd06,rbd07,rbd08,rbd09, 
                                    rbdacti,rbdplant,rbdlegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbd04_curr,g_rbd[l_ac2].after1,
                      g_rbd[l_ac2].rbd06,g_rbd[l_ac2].rbd07,g_rbd[l_ac2].rbd08,g_rbd[l_ac2].rbd09, 
                      g_rbd[l_ac2].rbdacti,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbd[l_ac2].after1||g_rbd[l_ac2].rbd06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b2=g_rec_b2+1
                 #DISPLAY g_rec_b2 TO FORMONLY.cn2
                  DISPLAY g_rec_b2 TO FORMONLY.cn3 #FUN-BC0072 add
               END IF
           
            ELSE
               INSERT INTO rbd_file(rbd01,rbd02,rbd03,rbd04,rbd05,
                                    rbd06,rbd07,rbd08,rbd09, 
                                    rbdacti,rbdplant,rbdlegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbd04_curr,g_rbd[l_ac2].after1,
                      g_rbd[l_ac2].rbd06,g_rbd[l_ac2].rbd07,g_rbd[l_ac2].rbd08,g_rbd[l_ac2].rbd09, 
                      g_rbd[l_ac2].rbdacti,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbd[l_ac2].after1||g_rbd[l_ac2].rbd06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT 
               ELSE
                  MESSAGE 'INSERT value.after O.K' 
               END IF
               INSERT INTO rbd_file(rbd01,rbd02,rbd03,rbd04,rbd05,
                                    rbd06,rbd07,rbd08,rbd09, 
                                    rbdacti,rbdplant,rbdlegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbd04_curr,g_rbd[l_ac2].before1,
                      g_rbd[l_ac2].rbd06_1,g_rbd[l_ac2].rbd07_1,g_rbd[l_ac2].rbd08_1,g_rbd[l_ac2].rbd09_1, 
                      g_rbd[l_ac2].rbdacti_1,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbd[l_ac2].before1||g_rbd[l_ac2].rbd06_1,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT               
               ELSE
                  MESSAGE 'INSERT value.before O.K'
                  COMMIT WORK
                  LET g_rec_b2=g_rec_b2+1
                 #DISPLAY g_rec_b2 TO FORMONLY.cn2
                  DISPLAY g_rec_b2 TO FORMONLY.cn3 #FUN-BC0072 add
               END IF
            END IF

 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rbd[l_ac2].* TO NULL 
            LET g_rbd[l_ac2].type1 = '0'      
            LET g_rbd[l_ac2].before1 = '0'
            LET g_rbd[l_ac2].after1  = '1'  
           #LET g_rbd[l_ac2].rbd07   = '1'             #Body default
            LET g_rbd[l_ac2].rbdacti = 'Y' 
           SELECT MIN(rbc06) INTO g_rbd[l_ac2].rbd06 FROM rbc_file
            WHERE rbc01=g_rbb.rbb01 AND rbc02=g_rbb.rbb02 
              AND rbc03=g_rbb.rbb03 AND rbcplant=g_rbb.rbbplant

                      
            LET g_rbd_t.* = g_rbd[l_ac2].*         #新輸入資料  #FUN-C30154 mark
            LET g_rbd_o.* = g_rbd[l_ac2].*         #新輸入資料  #FUN-C30154 mark
            
            SELECT MAX(rbd04)+1 INTO l_rbd04_curr 
              FROM rbd_file
             WHERE rbd01=g_rbb.rbb01
               AND rbd02=g_rbb.rbb02 
               AND rbd03=g_rbb.rbb03 
               AND rbdplant=g_rbb.rbbplant
              IF l_rbd04_curr IS NULL OR l_rbd04_curr=0 THEN
                 LET l_rbd04_curr = 1
              END IF                
           #CALL cl_show_fld_cont()      
           #CALL t402_set_no_required(l_newline)  
           #CALL t402_set_no_entry_b1()  
           #CALL t402_set_entry_b2('N')   
           CALL cl_show_fld_cont()
           NEXT FIELD rbd06 

 
      AFTER FIELD rbd06
         IF NOT cl_null(g_rbd[l_ac2].rbd06) THEN
            IF g_rbd_o.rbd06 IS NULL OR
               (g_rbd[l_ac2].rbd06 != g_rbd_o.rbd06 ) THEN
               CALL t402_rbd06()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbd[l_ac2].rbd06,g_errno,0)
                  LET g_rbd[l_ac2].rbd06 = g_rbd_o.rbd06
                  NEXT FIELD rbd06
               END IF
               IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
                  SELECT COUNT(*) INTO l_n 
                   FROM rad_file
                  WHERE rad01=g_rbb.rbb01 AND rad02=g_rbb.rbb02
                    AND radplant=g_rbb.rbbplant 
                    AND rad03=g_rbd[l_ac2].rbd06
                    AND rad04=g_rbd[l_ac2].rbd07
                  IF l_n=0 THEN
                     IF NOT cl_confirm('art-678') THEN
                        NEXT FIELD rbd06
                     ELSE
                        CALL t402_b2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN
                        NEXT FIELD rbd06
                     ELSE
                        CALL t402_b2_find()   
                     END IF           
                  END IF
               END IF  
            END IF  
         END IF 

      BEFORE FIELD rbd07 
         IF NOT cl_null(g_rbd[l_ac2].rbd06) THEN
            CALL t402_rbd07_chk()
         END IF

      AFTER FIELD rbd07
         IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
            IF g_rbd_o.rbd07 IS NULL OR
               (g_rbd[l_ac2].rbd07 != g_rbd_o.rbd07 ) THEN
               IF NOT cl_null(g_rbd[l_ac2].rbd06) THEN
                  SELECT COUNT(*) INTO l_n 
                   FROM rad_file
                  WHERE rad01=g_rbb.rbb01 AND rad02=g_rbb.rbb02
                    AND radplant=g_rbb.rbbplant 
                    AND rad03=g_rbd[l_ac2].rbd06
                    AND rad04=g_rbd[l_ac2].rbd07
                  IF l_n=0 THEN
                     IF NOT cl_confirm('art-678') THEN    #確定新增?
                        NEXT FIELD rbd07
                     ELSE
                        CALL t402_b2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN    #確定修改?
                        NEXT FIELD rbd07
                     ELSE
                        CALL t402_b2_find()   
                     END IF           
                  END IF
               END IF  
               CALL t402_rbd07() 
               #FUN-AB0033 mark --------------start-----------------
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err(g_rbd[l_ac2].rbd07,g_errno,0)
               #   LET g_rbd[l_ac2].rbd07 = g_rbd_o.rbd07
               #   NEXT FIELD rbd07
               #END IF
               #FUN-AB0033 mark ---------------end------------------
            END IF  
         END IF  

      ON CHANGE rbd07
         IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
            CALL t402_rbd07()   
            LET g_rbd[l_ac2].rbd08=NULL
            LET g_rbd[l_ac2].rbd08_desc=NULL
            LET g_rbd[l_ac2].rbd09=NULL
            LET g_rbd[l_ac2].rbd09_desc=NULL

            DISPLAY BY NAME g_rbd[l_ac2].rbd08,g_rbd[l_ac2].rbd08_desc
            DISPLAY BY NAME g_rbd[l_ac2].rbd09,g_rbd[l_ac2].rbd09_desc
         END IF
  
      BEFORE FIELD rbd08,rbd09
         IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
            CALL t402_rbd07()   
           #IF g_rbd[l_ac2].rbd07='1' THEN
           #   CALL cl_set_comp_entry("rbd09",TRUE)
           #   CALL cl_set_comp_required("rbd09",TRUE)
           #ELSE
           #   CALL cl_set_comp_entry("rbd09",FALSE)
           #END IF
         END IF

      AFTER FIELD rbd08
         IF NOT cl_null(g_rbd[l_ac2].rbd08) THEN
         IF g_rbd[l_ac2].rbd07 = '01' THEN #FUN-AB0033 add
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rbd[l_ac2].rbd08,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD rbd08
            END IF
#FUN-AA0059 ---------------------end-------------------------------
         END IF #FUN-AB0033 add
            IF g_rbd_o.rbd08 IS NULL OR
               (g_rbd[l_ac2].rbd08 != g_rbd_o.rbd08 ) THEN
               CALL t402_rbd08('a',l_ac2) 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbd[l_ac2].rbd08,g_errno,0)
                  LET g_rbd[l_ac2].rbd08 = g_rbd_o.rbd08
                  NEXT FIELD rbd08
               END IF
            END IF  
         END IF  

      AFTER FIELD rbd09
         IF NOT cl_null(g_rbd[l_ac2].rbd09) THEN
            IF g_rbd_o.rbd09 IS NULL OR
               (g_rbd[l_ac2].rbd09 != g_rbd_o.rbd09 ) THEN
               CALL t402_rbd09('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbd[l_ac2].rbd09,g_errno,0)
                  LET g_rbd[l_ac2].rbd09 = g_rbd_o.rbd09
                  NEXT FIELD rbd09
               END IF
            END IF  
         END IF
        
        
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rbd_t.rbd06 > 0 AND g_rbd_t.rbd06 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rbd_file
               WHERE rbd02 = g_rbb.rbb02 AND rbd01 = g_rbb.rbb01
                 AND rbd03 = g_rbb.rbb03 AND rbd04 = l_rbd04_curr
                # AND rbd06 = g_rbd_t.rbd06 AND rbd07 = g_rbd_t.rbd07 
                 AND rbdplant = g_rbb.rbbplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rbd_file",g_rbb.rbb02,g_rbd_t.rbd06,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              #LET g_rec_b1=g_rec_b1-1
              LET g_rec_b2=g_rec_b2-1     #lixia
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbd[l_ac2].* = g_rbd_t.*
              CLOSE t4021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbd[l_ac2].rbd06,-263,1)
              LET g_rbd[l_ac2].* = g_rbd_t.*
           ELSE
              IF g_rbd[l_ac2].rbd06<>g_rbd_t.rbd06 OR
                 g_rbd[l_ac2].rbd07<>g_rbd_t.rbd07 THEN
                 SELECT COUNT(*) INTO l_n FROM rbd_file
                  WHERE rbd01 =g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                    AND rbd03=g_rbb.rbb03
                    AND rbd06 = g_rbd[l_ac2].rbd06 
                    AND rbd07 = g_rbd[l_ac2].rbd07
                    AND rbdplant = g_rbb.rbbplant
                 IF l_n>0 THEN 
                    CALL cl_err('',-239,0)
                   #LET g_rbd[l_ac2].* = g_rbd_t.*
                    NEXT FIELD rbd06
                 END IF
              END IF
              UPDATE rbd_file SET rbd06=g_rbd[l_ac2].rbd06,
                                  rbd07=g_rbd[l_ac2].rbd07,
                                  rbd08=g_rbd[l_ac2].rbd08,
                                  rbd09=g_rbd[l_ac2].rbd09,
                                  rbdacti=g_rbd[l_ac2].rbdacti
               WHERE rbd02 = g_rbb.rbb02 AND rbd01=g_rbb.rbb01 AND rbd03=g_rbb.rbb03 
                 AND rbd04 = l_rbd04_curr AND rbd05='1'
                 AND rbd06=g_rbd_t.rbd06 AND rbd07=g_rbd_t.rbd07 AND rbdplant = g_rbb.rbbplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rbd_file",g_rbb.rbb02,g_rbd_t.rbd06,SQLCA.sqlcode,"","",1) 
                 LET g_rbd[l_ac2].* = g_rbd_t.*
              ELSE
                # CALL t402_repeat(g_rbd[l_ac2].rbd06)  #check
                #IF NOT cl_null(g_errno) THEN
                #   LET g_rbd[l_ac2].* = g_rbd_t.*
                #   NEXT FIELD CURRENT
                #ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                #END IF
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbd[l_ac2].* = g_rbd_t.*
              END IF
              CLOSE t4021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
          #CALL t402_repeat(g_rbd[l_ac2].rbd06)  #check
           CLOSE t4021_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rbd06) AND l_ac2 > 1 THEN
              LET g_rbd[l_ac2].* = g_rbd[l_ac2-1].*
              LET g_rec_b2 = g_rec_b2+1
             #LET l_rbd04_curr=l_rbd04_curr+1
              NEXT FIELD rbd06
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             #WHEN INFIELD(rbd06)
             #WHEN INFIELD(rbd07)
              WHEN INFIELD(rbd08)
                 CALL cl_init_qry_var()
                 CASE g_rbd[l_ac2].rbd07
                    #WHEN '1'
                    WHEN '01'  #FUN-A80104
                     # IF cl_null(g_rtz05) THEN         #FUN-AB0101 mark
#                         LET g_qryparam.form="q_ima"
                          CALL q_sel_ima(FALSE, "q_ima","",g_rbd[l_ac2].rbd08,"","","","","",'' ) #FUN-AA0059 add
                            RETURNING g_rbd[l_ac2].rbd08                                          #FUN-AA0059 add
                     # ELSE                                   #FUN-AB0101 mark
                     #    LET g_qryparam.form = "q_rtg03_1"   #FUN-AB0101 mark
                     #    LET g_qryparam.arg1 = g_rtz05       #FUN-AB0101 mark
                     # END IF                                 #FUN-AB0101 mark
                    #WHEN '2'
                    WHEN '02'  #FUN-A80104
                       LET g_qryparam.form ="q_oba01"
                    #WHEN '3'
                    WHEN '03'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '1'
                    #WHEN '4'
                    WHEN '04'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '2'
                    #WHEN '5'
                    WHEN '05'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '3'
                    #WHEN '6'
                    WHEN '06'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '4'
                    #WHEN '7'
                    WHEN '07'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '5'
                    #WHEN '8'
                    WHEN '08'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '6'
                    #WHEN '9'
                    WHEN '09'  #FUN-A80104
                       LET g_qryparam.form ="q_tqa"
                       LET g_qryparam.arg1 = '27'
                 END CASE
               # IF g_rbd[l_ac2].rbd07 != '01' OR (g_rbd[l_ac2].rbd07 = '01' AND NOT cl_null(g_rtz05)) THEN #FUN-AA0059    #FUN-AB0101 mark
                 IF g_rbd[l_ac2].rbd07 != '01' THEN                           #FUN-AB0101
                    LET g_qryparam.default1 = g_rbd[l_ac2].rbd08
                    CALL cl_create_qry() RETURNING g_rbd[l_ac2].rbd08
                 END IF     #FUN-AA0059
                 CALL t402_rbd08('d',l_ac2)
                 NEXT FIELD rbd08
              WHEN INFIELD(rbd09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe02"
                 SELECT DISTINCT ima25
                   INTO l_ima25
                   FROM ima_file
                  WHERE ima01=g_rbd[l_ac2].rbd08  
                 LET g_qryparam.arg1 = l_ima25
                 LET g_qryparam.default1 = g_rbd[l_ac2].rbd09
                 CALL cl_create_qry() RETURNING g_rbd[l_ac2].rbd09
                 CALL t402_rbd09('d')
                 NEXT FIELD rbd09
              OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
     
    CALL t402_upd_log() 
    
    CLOSE t4021_bcl
    COMMIT WORK
   #CALL s_showmsg()
 
END FUNCTION
}

FUNCTION t402_rbd07_chk() 
DEFINE l_rbc07   LIKE rbc_file.rbc07
DEFINE comb_value STRING  #FUN-C30154 add 
DEFINE comb_item LIKE ze_file.ze03  #FUN-C30154 add

   SELECT DISTINCT rbc07 INTO l_rbc07 FROM rbc_file
    WHERE rbc01=g_rbb.rbb01 AND rbc02=g_rbb.rbb02
      AND rbcplant=g_rbb.rbbplant AND rbc05='1'
#modify by lixia----start-----
      #AND rbc03=g_rbd[l_ac2].rbd06
      AND rbc03=g_rbb.rbb03
      AND rbc06=g_rbd[l_ac2].rbd06
#modify by lixia----end------

   IF cl_null(l_rbc07) THEN
      SELECT DISTINCT rac04 INTO l_rbc07 FROM rac_file
       WHERE rac01=g_rbb.rbb01 AND rac02 = g_rbb.rbb02
         AND racplant =g_rbb.rbbplant 
         AND rac03=g_rbd[l_ac2].rbd06
   END IF

   IF l_rbc07 = '1' THEN
      #LET g_rbd[l_ac2].rbd07='1'
     #LET g_rbd[l_ac2].rbd07='01'  #FUN-A80104  #FUN-C30154 mark
     #CALL cl_set_comp_entry("rbd07",FALSE)   #FUN-C30154 mark
     #FUN-C30154  add START
      LET comb_value = '01,09'
      SELECT ze03 INTO comb_item FROM ze_file
        WHERE ze01 = 'art-787' AND ze02 = g_lang
      CALL cl_set_combo_items('rbd07', comb_value, comb_item)  #FUN-C30154 add
     #FUN-C30154 add END
   ELSE
     #CALL cl_set_comp_entry("rbd07",TRUE)  #FUN-C30154 mark
    #FUN-C30154 add START
     LET comb_value = '01,02,03,04,05,06,07,08,09'
     SELECT ze03 INTO comb_item FROM ze_file
       WHERE ze01 = 'art-788' AND ze02 = g_lang
     CALL cl_set_combo_items('rbd07', comb_value, comb_item)  #FUN-C30154 add
    #FUN-C30154 add END
   END IF
END FUNCTION

#FUN-C30154 add START
#顯示之前先將下拉選項重新產生一遍,避免名稱不顯示的問題
FUNCTION t402_rbd07_combo()
DEFINE comb_value STRING   
DEFINE comb_item LIKE ze_file.ze03  
    
   LET comb_value = '01,02,03,04,05,06,07,08,09'
   SELECT ze03 INTO comb_item FROM ze_file
     WHERE ze01 = 'art-788' AND ze02 = g_lang
   CALL cl_set_combo_items('rbd07', comb_value, comb_item)

END FUNCTION
#FUN-C30154 add END

FUNCTION t402_rbd06() 
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti

   LET g_errno = ' '
   LET l_n=0

   SELECT COUNT(*) INTO l_n FROM rbc_file
    WHERE rbc01 = g_rbb.rbb01 AND rbc02 = g_rbb.rbb02
      AND rbc03 = g_rbb.rbb03 AND rbcplant=g_rbb.rbbplant
      AND rbc06 = g_rbd[l_ac2].rbd06 AND rbc05='1'
      AND rbcacti='Y'

   IF l_n<1 THEN  
      SELECT COUNT(*) INTO l_n FROM rac_file
       WHERE rac01=g_rbb.rbb01 AND rac02=g_rbb.rbb02
         AND racplant=g_rbb.rbbplant 
         AND rac03=g_rbd[l_ac2].rbd06
         AND racacti='Y'
      IF l_n<1 THEN
         LET g_errno = 'art-669'     #當前組別不在第一單身中,也不在原促銷單中
      END IF
   END IF
END FUNCTION
 

FUNCTION t402_rbd07()

   #IF g_rbd[l_ac2].rbd07='1' THEN
   IF g_rbd[l_ac2].rbd07='01' THEN   #FUN-A80104
      CALL cl_set_comp_entry("rbd09",TRUE)
      CALL cl_set_comp_required("rbd09",TRUE)
   ELSE
      CALL cl_set_comp_entry("rbd09",FALSE)
   END IF
END FUNCTION


FUNCTION t402_rbd08(p_cmd,p_cnt)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 
DEFINE p_cnt       LIKE type_file.num5 

DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06

   LET g_errno = ' '
    
   
   CASE g_rbd[p_cnt].rbd07
      #WHEN '1'
      WHEN '01'  #FUN-A80104
      # IF cl_null(g_rtz05) THEN     #FUN-AB0101 
        IF cl_null(g_rtz04) THEN     #FUN-AB0101
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rbd[p_cnt].rbd08  
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno=100
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
        ELSE    
           SELECT DISTINCT ima02,ima25,rte07
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file,rte_file
            WHERE ima01 = rte03 AND ima01=g_rbd[p_cnt].rbd08
              AND rte01 = g_rtz04                              #FUN-AB0101 
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF
      #WHEN '2'
      WHEN '02'  #FUN-A80104
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rbd[p_cnt].rbd08 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '3'
      WHEN '03'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '4'
      WHEN '04'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '5'
      WHEN '05'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '6'
      WHEN '06'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '7'
      WHEN '07'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '8'
      WHEN '08'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '9'
      WHEN '09'  #FUN-A80104
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rbd[p_cnt].rbd07
         #WHEN '1'
         WHEN '01'  #FUN-A80104
            LET g_rbd[p_cnt].rbd08_desc = l_ima02
            IF cl_null(g_rbd[p_cnt].rbd09) THEN
               LET g_rbd[p_cnt].rbd09      = l_ima25
            END IF
            SELECT gfe02 INTO g_rbd[p_cnt].rbd09_desc FROM gfe_file
             WHERE gfe01=g_rbd[p_cnt].rbd09 AND gfeacti='Y'
         #WHEN '2'
         WHEN '02'  #FUN-A80104
            LET g_rbd[p_cnt].rbd09 = ''
            LET g_rbd[p_cnt].rbd09_desc = ''
            LET g_rbd[p_cnt].rbd08_desc = l_oba02
         #WHEN '9'
         WHEN '09'  #FUN-A80104
            LET g_rbd[p_cnt].rbd09 = ''
            LET g_rbd[p_cnt].rbd09_desc = ''
            LET g_rbd[p_cnt].rbd08_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbd[p_cnt].rbd08_desc = g_rbd[p_cnt].rbd08_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbd[p_cnt].rbd08_desc = g_rbd[p_cnt].rbd08_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rbd[p_cnt].rbd09 = ''
            LET g_rbd[p_cnt].rbd09_desc = ''
            LET g_rbd[p_cnt].rbd08_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbd[p_cnt].rbd08_desc,g_rbd[p_cnt].rbd09,g_rbd[p_cnt].rbd09_desc
   END IF

END FUNCTION


FUNCTION t402_rbd08_1(p_cmd,p_cnt)
DEFINE l_n         LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1 
DEFINE p_cnt       LIKE type_file.num5 

DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06

   LET g_errno = ' '
    
   
   CASE g_rbd[p_cnt].rbd07_1
      #WHEN '1'
      WHEN '01'  #FUN-A80104
      # IF cl_null(g_rtz05) THEN                   #FUN-AB0101
        IF cl_null(g_rtz04) THEN                   #FUN-AB0101
           SELECT DISTINCT ima02,ima25,imaacti
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file
            WHERE ima01=g_rbd[p_cnt].rbd08_1  
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno=100
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
        ELSE    
           SELECT DISTINCT ima02,ima25,rte07
             INTO l_ima02,l_ima25,l_imaacti
             FROM ima_file,rte_file
            WHERE ima01 = rte03 AND ima01=g_rbd[p_cnt].rbd08_1
              AND rte01 = g_rtz04                                #FUN-AB0101 
           CASE
              WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
                                       LET l_ima02=NULL
              WHEN l_imaacti='N'       LET g_errno='9028'
              OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
           END CASE
         END IF
      #WHEN '2'
      WHEN '02'  #FUN-A80104
         SELECT DISTINCT oba02,obaacti 
           INTO l_oba02,l_obaacti
           FROM oba_file
          WHERE oba01=g_rbd[p_cnt].rbd08_1 AND obaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_oba02=NULL
            WHEN l_obaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '3'
      WHEN '03'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='1' AND tqaacti='Y' 
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '4'
      WHEN '04'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='2' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '5'
      WHEN '05'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='3' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '6'
      WHEN '06'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='4' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '7'
      WHEN '07'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='5' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '8'
      WHEN '08'  #FUN-A80104
         SELECT DISTINCT tqa02,tqaacti
           INTO l_tqa02,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='6' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      #WHEN '9'
      WHEN '09'  #FUN-A80104
         SELECT DISTINCT tqa02,tqa05,tqa06,tqaacti
           INTO l_tqa02,l_tqa05,l_tqa06,l_tqaacti
           FROM tqa_file
          WHERE tqa01=g_rbd[p_cnt].rbd08_1 AND tqa03='27' AND tqaacti='Y'
         CASE
            WHEN SQLCA.sqlcode=100   LET g_errno=100
                                     LET l_tqa02=NULL
                                     LET l_tqa05=NULL
                                     LET l_tqa06=NULL
            WHEN l_tqaacti='N'       LET g_errno='9028'
            OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
         END CASE
      END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE g_rbd[p_cnt].rbd07_1
         #WHEN '1'
         WHEN '01'  #FUN-A80104
            LET g_rbd[p_cnt].rbd08_1_desc = l_ima02
            IF cl_null(g_rbd[p_cnt].rbd09_1) THEN
               LET g_rbd[p_cnt].rbd09_1   = l_ima25
            END IF
            SELECT gfe02 INTO g_rbd[p_cnt].rbd09_1_desc FROM gfe_file
             WHERE gfe01=g_rbd[p_cnt].rbd09_1 AND gfeacti='Y'
         #WHEN '2'
         WHEN '02'  #FUN-A80104
            LET g_rbd[p_cnt].rbd09_1 = ''
            LET g_rbd[p_cnt].rbd09_1_desc = ''
            LET g_rbd[p_cnt].rbd08_1_desc = l_oba02
         #WHEN '9'
         WHEN '09'  #FUN-A80104
            LET g_rbd[p_cnt].rbd09_1 = ''
            LET g_rbd[p_cnt].rbd09_1_desc = ''
            LET g_rbd[p_cnt].rbd08_1_desc = l_tqa02 CLIPPED,">"
            LET l_tqa02 = l_tqa05
            LET g_rbd[p_cnt].rbd08_1_desc = g_rbd[p_cnt].rbd08_1_desc CLIPPED,":",l_tqa02 CLIPPED,"-"
            LET l_tqa02 = l_tqa06
            LET g_rbd[p_cnt].rbd08_1_desc = g_rbd[p_cnt].rbd08_1_desc CLIPPED,l_tqa02 CLIPPED
         OTHERWISE
            LET g_rbd[p_cnt].rbd09_1 = ''
            LET g_rbd[p_cnt].rbd09_1_desc = ''
            LET g_rbd[p_cnt].rbd08_1_desc = l_tqa02
      END CASE
      DISPLAY BY NAME g_rbd[p_cnt].rbd08_1_desc,g_rbd[p_cnt].rbd09_1,g_rbd[p_cnt].rbd09_1_desc
   END IF

END FUNCTION

FUNCTION t402_rbd09(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1   
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac    

   LET g_errno = ' '
   #IF g_rbd[l_ac2].rbd07<>'1' THEN
   IF g_rbd[l_ac2].rbd07<>'01' THEN  #FUN-A80104
      RETURN
   END IF
   IF NOT cl_null(g_rbd[l_ac2].rbd08) THEN
      SELECT DISTINCT ima25
        INTO l_ima25
        FROM ima_file
       WHERE ima01=g_rbd[l_ac2].rbd08  

      CALL s_umfchk(g_rbd[l_ac2].rbd08,l_ima25,g_rbd[l_ac2].rbd09)
         RETURNING l_flag,l_fac   
      IF l_flag = 1 THEN
         LET g_errno = 'ams-823'
         RETURN
      END IF
   END IF
   SELECT gfe02,gfeacti
     INTO l_gfe02,l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_rbd[l_ac2].rbd09 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      WHEN l_gfeacti='N'       LET g_errno ='9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN 
      LET g_rbd[l_ac2].rbd09_desc=l_gfe02
      DISPLAY BY NAME g_rbd[l_ac2].rbd09_desc
   END IF    
END FUNCTION 
 


FUNCTION t402_upd_log()
   LET g_rbb.rbbmodu = g_user
   LET g_rbb.rbbdate = g_today
   UPDATE rbb_file SET rbbmodu = g_rbb.rbbmodu,
                       rbbdate = g_rbb.rbbdate
    WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02
      AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rbb_file",g_rbb.rbbmodu||g_rbb.rbbdate,"",SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rbb.rbbmodu,g_rbb.rbbdate
   MESSAGE 'UPDATE rbb_file O.K.'
END FUNCTION

FUNCTION t402_chktime(p_time)  #check 時間格式
DEFINE p_time LIKE type_file.chr5
DEFINE l_hour LIKE type_file.num5
DEFINE l_min  LIKE type_file.num5
 
      LET g_errno=''
      IF p_time[1,1] MATCHES '[012]' AND
         p_time[2,2] MATCHES '[0123456789]' AND
         p_time[3,3] =':' AND
         p_time[4,4] MATCHES '[012345]' AND 
         p_time[5,5] MATCHES '[0123456789]' THEN
         IF p_time[1,2]<'00' OR p_time[1,2]>='24' OR
            p_time[4,5]<'00' OR p_time[4,5]>='60' THEN
            LET g_errno='art-209' 
         END IF
      ELSE
         LET g_errno='art-209'
      END IF
      IF cl_null(g_errno) THEN         
         LET l_hour=p_time[1,2]
         LET l_min = p_time[4,5]
         RETURN l_hour*60+l_min
      ELSE
         RETURN NULL
      END IF
END FUNCTION


FUNCTION t402_rbc_entry(p_rbc07)
DEFINE p_rbc07    LIKE rbc_file.rbc07   

          CASE p_rbc07
             WHEN '1'
                CALL cl_set_comp_entry("rbc08",TRUE)
                CALL cl_set_comp_entry("rbc09",FALSE)
                CALL cl_set_comp_entry("rbc10",FALSE)
                LET g_rbc[l_ac1].rbc09=''
                LET g_rbc[l_ac1].rbc10=0
             WHEN '2'
                CALL cl_set_comp_entry("rbc08",FALSE)
                CALL cl_set_comp_entry("rbc09",TRUE)
                CALL cl_set_comp_entry("rbc10",FALSE)
                LET g_rbc[l_ac1].rbc08=0
                LET g_rbc[l_ac1].rbc10=0
             WHEN '3'
                CALL cl_set_comp_entry("rbc08",FALSE)
                CALL cl_set_comp_entry("rbc09",FALSE)
                CALL cl_set_comp_entry("rbc10",TRUE)
                LET g_rbc[l_ac1].rbc08=0
                LET g_rbc[l_ac1].rbc09=''
             OTHERWISE
                CALL cl_set_comp_entry("rbc08",TRUE)
                CALL cl_set_comp_entry("rbc09",TRUE)
                CALL cl_set_comp_entry("rbc10",TRUE)
          END CASE
           
         #IF g_rbc[l_ac1].rbc11='Y' THEN  #FUN-BC0072 mark
          IF g_rbc[l_ac1].rbc11 <> '0' THEN
             CALL cl_set_comp_entry("rbc12,rbc13,rbc14",FALSE)
             LET g_rbc[l_ac1].rbc12=0
             LET g_rbc[l_ac1].rbc13=''
             LET g_rbc[l_ac1].rbc14=0
          ELSE
             CASE p_rbc07
                WHEN '1'
                   CALL cl_set_comp_entry("rbc12",TRUE)
                   CALL cl_set_comp_entry("rbc13",FALSE)
                   CALL cl_set_comp_entry("rbc14",FALSE)
                   LET g_rbc[l_ac1].rbc13=''
                   LET g_rbc[l_ac1].rbc14=0
                WHEN '2'
                   CALL cl_set_comp_entry("rbc12",FALSE)
                   CALL cl_set_comp_entry("rbc13",TRUE)
                   CALL cl_set_comp_entry("rbc14",FALSE)
                   LET g_rbc[l_ac1].rbc12=0
                   LET g_rbc[l_ac1].rbc14=0
                WHEN '3'
                   CALL cl_set_comp_entry("rbc12",FALSE)
                   CALL cl_set_comp_entry("rbc13",FALSE)
                   CALL cl_set_comp_entry("rbc14",TRUE)
                   LET g_rbc[l_ac1].rbc12=0
                   LET g_rbc[l_ac1].rbc13=''
                OTHERWISE
                   CALL cl_set_comp_entry("rbc12",TRUE)
                   CALL cl_set_comp_entry("rbc13",TRUE)
                   CALL cl_set_comp_entry("rbc14",TRUE)
             END CASE
          END IF
       
       CASE p_rbc07
          WHEN '1'
             DISPLAY ' ' TO g_rbc[l_ac1].rbc10
             DISPLAY ' ' TO g_rbc[l_ac1].rbc14
             IF g_rbc[l_ac1].rbc11='Y' THEN
                DISPLAY ' ' TO g_rbc[l_ac1].rbc12  
             END IF
          WHEN '2'
             DISPLAY ' ' TO g_rbc[l_ac1].rbc08
             DISPLAY ' ' TO g_rbc[l_ac1].rbc10
             DISPLAY ' ' TO g_rbc[l_ac1].rbc12
             DISPLAY ' ' TO g_rbc[l_ac1].rbc14
          WHEN '3'
             DISPLAY ' ' TO g_rbc[l_ac1].rbc08
             DISPLAY ' ' TO g_rbc[l_ac1].rbc12
             IF g_rbc[l_ac1].rbc11='Y' THEN
                DISPLAY ' ' TO g_rbc[l_ac1].rbc14
             END IF
       END CASE   

           
END FUNCTION

FUNCTION t402_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rbc_file
    WHERE rbc02 = g_rbb.rbb02 AND rbc01 = g_rbb.rbb01
      AND rbc03 = g_rbb.rbb03 AND rbcplant = g_rbb.rbbplant
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rbb_file WHERE rbb01 = g_rbb.rbb01 AND rbb02=g_rbb.rbb02 
                             AND rbb03 = g_rbb.rbb03 AND rbbplant=g_rbb.rbbplant
      DELETE FROM rbq_file WHERE rbq01 = g_rbb.rbb01 AND rbq02=g_rbb.rbb02 
                             AND rbq03 = g_rbb.rbb03 AND rbq04='1' AND rbqplant=g_rbb.rbbplant
      CALL g_rbc.clear()
   END IF
END FUNCTION
   
 
FUNCTION t402_set_entry_b1(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1
     IF p_cmd='a' THEN
        CALL cl_set_comp_entry("rbc06,rbc07,rbc08,rbc09,rbc10,rbc11",TRUE)
       #CALL cl_set_comp_entry("rbc12,rbc13,rbc14,rbc15,rbc16,rbc17,rbc18,rbcacti",TRUE) #FUN-BC0072 mark
        CALL cl_set_comp_entry("rbc12,rbc13,rbc14,rbcacti",TRUE) #FUN-BC0072 add
     ELSE
        CALL cl_set_comp_entry("rbc07,rbc08,rbc09,rbc10,rbc11",TRUE)
       #CALL cl_set_comp_entry("rbc12,rbc13,rbc14,rbc15,rbc16,rbc17,rbc18,rbcacti",TRUE) #FUN-BC0072 mark
        CALL cl_set_comp_entry("rbc12,rbc13,rbc14,rbcacti",TRUE) #FUN-BC0072 add
     END IF
END FUNCTION

FUNCTION t402_set_no_entry_b1(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1
     
     CALL cl_set_comp_entry("type,before,rbc06_1,rbc07_1,rbc08_1,rbc09_1,rbc10_1",FALSE)
    #CALL cl_set_comp_entry("rbc11_1,rbc12_1,rbc13_1,rbc14_1,rbc15_1,rbc16_1,rbc17_1,rbc18_1,rbcacti_1,after",FALSE)  #FUN-BC0072 mark
     CALL cl_set_comp_entry("rbc11_1,rbc12_1,rbc13_1,rbc14_1,rbcacti_1,after",FALSE)  #FUN-BC0072 add
     IF p_cmd='u' THEN
        CALL cl_set_comp_entry("rbc06",FALSE)
     END IF   

END FUNCTION 

FUNCTION t402_set_entry_b2()
       CALL cl_set_comp_entry("rbd06,rbd07,rbd08,rbd09,rbdacti",TRUE)
END FUNCTION
 
FUNCTION t402_set_no_entry_b2(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1
     IF p_cmd='a' THEN
        CALL cl_set_comp_entry("rbd06,rbd07",FALSE)
     END IF   
     CALL cl_set_comp_entry("type1,before1,after1,rbd06_1,rbd07_1,rbd08_1,rbd09_1,rbdacti_1",FALSE)
END FUNCTION
 
 
   
 
FUNCTION t402_out()
 MESSAGE 'Developing'
END FUNCTION
 
FUNCTION t402_y()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
#FUN-BC0072 add END
DEFINE l_rbc11    LIKE rbc_file.rbc11  
DEFINE l_rbc11_1  LIKE rbc_file.rbc11 
DEFINE l_n        LIKE type_file.num5  
DEFINE l_rbc06    LIKE rbc_file.rbc06 
#FUN-BC0072 add END

   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_rbb.rbb02 IS NULL THEN CALL cl_err(g_rbb.rbb02,-400,0) RETURN END IF
#CHI-C30107 -------------- add ---------------- begin
   IF g_rbb.rbbconf = 'Y' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF
   IF g_rbb.rbbacti = 'N' THEN CALL cl_err(g_rbb.rbb02,'art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 -------------- add ---------------- end
 
   #TQC-AC0326 add --------------------begin----------------------
   #生效營運中心中有對應的促銷單並且審核、發布， 才可審核對應的變更單
   LET l_cnt = 0
    
   SELECT COUNT(*) INTO l_cnt FROM rab_file,raq_file
    WHERE raq01 =  g_rbb.rbb01  AND raq02 = g_rbb.rbb02  AND  raq03 = '1'
      AND raq04 =  g_rbb.rbbplant AND  raqplant = g_rbb.rbbplant AND  raqacti = 'Y'
      AND rab01 =  raq01
      AND rab02 =  raq02
      AND rabplant = raqplant 
      AND (rabconf != 'Y' OR raq05 = 'N')    
   IF l_cnt > 0 THEN
      CALL cl_err(g_rbb.rbb02,'art-998',0)
      RETURN   
   END IF
   
   #生效營運中心中有對應的促銷單的未審核變更單序號最小的才可以變更
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rbb_file 
    WHERE rbb01=g_rbb.rbb01 
      AND rbb02=g_rbb.rbb02 
      AND rbb03<g_rbb.rbb03
      AND rbbconf = 'N'  
      AND rbbplant=g_rbb.rbbplant
   IF l_cnt > 0 THEN
      CALL cl_err(g_rbb.rbb02,'art-997',0)
      RETURN
   END IF
   #TQC-AC0326 add ---------------------end-----------------------

   #FUN-BC0072 add START
   LET g_sql = " SELECT b.rbc06,b.rbc11,a.rbc11 ",
               "   FROM rbc_file b LEFT OUTER JOIN rbc_file a",
               "                   ON (b.rbc01=a.rbc01 AND b.rbc02=a.rbc02 AND b.rbc03=a.rbc03 AND ",
               "                       b.rbc04=a.rbc04 AND b.rbc06=a.rbc06 AND b.rbcplant=a.rbcplant AND b.rbc05<>a.rbc05 ) ",
               "  WHERE b.rbc01 = '",g_rbb.rbb01, "' AND b.rbcplant='",g_rbb.rbbplant,"'",
               "    AND b.rbc05='1' ", 
               "    AND b.rbc02 = '",g_rbb.rbb02, "' AND b.rbc03=",g_rbb.rbb03
   PREPARE t402_b1_prepare1 FROM g_sql                     #預備一下
   DECLARE rbc_cs1 CURSOR FOR t402_b1_prepare1
   FOREACH rbc_cs1 INTO l_rbc06, l_rbc11,l_rbc11_1 
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rbc11 <> '0' AND (l_rbc11 <> l_rbc11_1 OR cl_null(l_rbc11_1))  THEN
          LET l_n = 0 
          SELECT COUNT(*) INTO l_n FROM rbp_file
            WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
              AND rbp03 = g_rbb.rbb03 AND rbp04 = '1' 
              AND rbp12 = l_rbc11 AND rbpacti = 'Y'
              AND rbp06 = '1' AND rbp12 = l_rbc11 
              AND rbpplant = g_rbb.rbbplant
              AND rbp07 = l_rbc06
          IF l_n < 1 THEN
             CALL cl_err('','art-795',0)
             RETURN
          END IF
       END IF
   END FOREACH
   LET g_sql = " SELECT b.rbc06 ",
               "   FROM rbc_file b LEFT OUTER JOIN rbc_file a",
               "                   ON (b.rbc01=a.rbc01 AND b.rbc02=a.rbc02 AND b.rbc03=a.rbc03 AND ",
               "                       b.rbc04=a.rbc04 AND b.rbc06=a.rbc06 AND b.rbcplant=a.rbcplant AND b.rbc05<>a.rbc05 ) ",
               "  WHERE b.rbc01 = '",g_rbb.rbb01, "' AND b.rbcplant='",g_rbb.rbbplant,"'",
               "    AND b.rbc05='1' AND RTRIM(a.rbc06) IS NULL ",
               "    AND b.rbc02 = '",g_rbb.rbb02, "' AND b.rbc03=",g_rbb.rbb03 
   PREPARE t402_b1_prepare3 FROM g_sql
   DECLARE rbc_cs2 CURSOR FOR t402_b1_prepare3
   FOREACH rbc_cs2 INTO l_rbc06
      SELECT COUNT(*) INTO l_n FROM rbd_file
         WHERE rbd01 = g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
           AND rbd03 = g_rbb.rbb03 AND rbd06 = l_rbc06
           AND rbdplant = g_rbb.rbbplant
      IF l_n < 1 THEN
         CALL cl_err('','art-790',0)
         RETURN
      END IF
   END FOREACH 
   #FUN-BC0072 add END
   SELECT * INTO g_rbb.* FROM rbb_file 
      WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
        AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   IF g_rbb.rbbconf = 'Y' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF
   #IF g_rbb.rbbconf = 'X' THEN CALL cl_err(g_rbb.rbb02,'9024',0) RETURN END IF  #FUN-AB0033 mark
   IF g_rbb.rbbacti = 'N' THEN CALL cl_err(g_rbb.rbb02,'art-145',0) RETURN END IF
   #IF g_rbb.rbbconf = 'I' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF  #add by lixia  #FUN-AB0033 mark
   
   #FUN-AB0033 mark --------------start-----------------
   #LET l_cnt=0
   #SELECT COUNT(*) INTO l_cnt
   #  FROM rbc_file
   # WHERE rbc02 = g_rbb.rbb02 AND rbc01=g_rbb.rbb01
   #   AND rbc03=g_rbb.rbb03 AND rbcplant = g_rbb.rbbplant
   #IF l_cnt=0 OR l_cnt IS NULL THEN
   #   CALL cl_err('','mfg-009',0)
   #   RETURN
   #END IF
   #FUN-AB0033 mark ---------------end------------------
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   CALL t402_create_temp_table()    #FUN-C60041 add
   BEGIN WORK
   OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t402_cl:", STATUS, 1)
      CLOSE t402_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t402_cl INTO g_rbb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
      CLOSE t402_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rbb_file SET rbbconf='Y',
                       rbbcond=g_today, 
                       rbbcont=g_time, 
                       rbbconu=g_user
     WHERE  rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
       AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      CALL t402sub_y_upd(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant)
   END IF
#FUN-C60041 -------------STA
   IF g_success = 'Y' THEN
      CALL t402_iss()
   END IF
#FUN-C60041 -------------END
   IF g_success = 'Y' THEN
      #LET g_rbb.rbbconf='Y'  #FUN-AB0033 mark
      COMMIT WORK
      CALL cl_flow_notify(g_rbb.rbb02,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rbb.* FROM rbb_file 
      WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01 
        AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rbb.rbbconu
   DISPLAY BY NAME g_rbb.rbbconf                                                                                         
   DISPLAY BY NAME g_rbb.rbbcond                                                                                         
   DISPLAY BY NAME g_rbb.rbbcont                                                                                         
   DISPLAY BY NAME g_rbb.rbbconu
   DISPLAY l_gen02 TO FORMONLY.rbbconu_desc
    #CKP
#MOD-AC0190--add-begin
    IF NOT g_rbb.rbbconf='X' THEN LET g_chr='N' END IF
    IF g_rbb.rbbconf='I' OR g_rbb.rbbconf='Y' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_chr2,"","","",g_chr,"")
   #MOD-AC0190--add-end
 #  IF NOT g_rbb.rbbconf='X' THEN LET g_chr='N' END IF     #MOD-AC0190
 #  CALL cl_set_field_pic(g_rbb.rbbconf,"","","",g_chr,"")  #MOD-AC0190
 #FUN-C60041 ---------------MARK -----------BEGIN
 #  #TQC-AC0326 add -----------begin------------
 #  IF g_success = 'Y' THEN 
 #     CALL t402_iss() 
 #  ELSE
 #    ROLLBACK WORK    
 #  END IF    
 #  #TQC-AC0326 add -----------begin------------ 
 #FUN-C60041 ---------------MARK--------------END  
   CALL t402_drop_temp_table()     #FUN-C60041 add
END FUNCTION
  
 
FUNCTION t402_z() 
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04

   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_rbb.rbb02 IS NULL THEN CALL cl_err(g_rbb.rbb02,-400,0) RETURN END IF
 
   SELECT * INTO g_rbb.* FROM rbb_file 
      WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
        AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   IF g_rbb.rbbconf = 'Y' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF
   #IF g_rbb.rbbconf = 'X' THEN CALL cl_err(g_rbb.rbb02,'9024',0) RETURN END IF #FUN-AB0033 mark 
   IF g_rbb.rbbacti = 'N' THEN CALL cl_err(g_rbb.rbb02,'art-145',0) RETURN END IF
   #IF g_rbb.rbbconf = 'I' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF   #add by lixia  #FUN-AB0033 mark
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rbc_file
    WHERE rbc02 = g_rbb.rbb02 AND rbc01=g_rbb.rbb01
      AND rbc03=g_rbb.rbb03 AND rbcplant = g_rbb.rbbplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t402_cl:", STATUS, 1)
      CLOSE t402_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t402_cl INTO g_rbb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
      CLOSE t402_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y' 
 
   UPDATE rbb_file SET rbbconf='N',
                       rbbcond=NULL, 
                       rbbcont=NULL, 
                       rbbconu=NULL
     WHERE  rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
       AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rbb.rbbconf='N'
      COMMIT WORK 
   ELSE
      LET g_rbb.rbbconf='Y'
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rbb.* FROM rbb_file 
    WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01 
      AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rbb.rbbconu
   DISPLAY BY NAME g_rbb.rbbconf                                                                                         
   DISPLAY BY NAME g_rbb.rbbcond                                                                                         
   DISPLAY BY NAME g_rbb.rbbcont                                                                                         
   DISPLAY BY NAME g_rbb.rbbconu
   DISPLAY l_gen02 TO FORMONLY.rbbconu_desc
    #CKP
   IF NOT g_rbb.rbbconf='X' THEN LET g_chr='N' END IF  
   CALL cl_set_field_pic(g_rbb.rbbconf,"","","",g_chr,"")  
    
END FUNCTION


FUNCTION t402_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rbb.rbb02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rbb.rbbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #IF g_rbb.rbbconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF   #FUN-AB0033 mark
   #IF g_rbb.rbbconf = 'I' THEN CALL cl_err('',9023,0) RETURN END IF   #add by lixia  #FUN-AB0033 mark
   BEGIN WORK 
   OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
   IF STATUS THEN
      CALL cl_err("OPEN t402_cl:", STATUS, 1)
      CLOSE t402_cl
      RETURN
   END IF
 
   FETCH t402_cl INTO g_rbb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rbb.rbb01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t402_show()
 
   IF cl_exp(0,0,g_rbb.rbbacti) THEN
      LET g_chr=g_rbb.rbbacti
      IF g_rbb.rbbacti='Y' THEN
         LET g_rbb.rbbacti='N'
      ELSE
         LET g_rbb.rbbacti='Y'
      END IF
 
      UPDATE rbb_file SET rbbacti=g_rbb.rbbacti,
                          rbbmodu=g_user,
                          rbbdate=g_today
       WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
         AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rbb_file",g_rbb.rbb01,"",SQLCA.sqlcode,"","",1) 
         LET g_rbb.rbbacti=g_chr
      END IF
   END IF
 
   CLOSE t402_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rbb.rbb02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rbbacti,rbbmodu,rbbdate
     INTO g_rbb.rbbacti,g_rbb.rbbmodu,g_rbb.rbbdate FROM rbb_file 
       WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
         AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant

   DISPLAY BY NAME g_rbb.rbbacti,g_rbb.rbbmodu,g_rbb.rbbdate


END FUNCTION 

#FUN-AB0033 mark ---------------------------start----------------------------
#FUNCTION t402_v()
#   IF s_shut(0) THEN RETURN END IF
#   IF cl_null(g_rbb.rbb02) THEN CALL cl_err('',-400,0) RETURN END IF    
#   
#   SELECT * INTO g_rbb.* FROM rbb_file 
#      WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
#        AND rbb03=g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant 
#        
#   IF g_rbb.rbbconf = 'Y' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF
#   IF g_rbb.rbbacti = 'N' THEN CALL cl_err(g_rbb.rbb02,'art-142',0) RETURN END IF
#   IF g_rbb.rbbconf = 'X' THEN CALL cl_err(g_rbb.rbb02,'art-148',0) RETURN END IF
#   IF g_rbb.rbbconf = 'I' THEN CALL cl_err(g_rbb.rbb02,9023,0) RETURN END IF  #add by lixia
#   
#   BEGIN WORK
# 
#   OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
#   IF STATUS THEN
#      CALL cl_err("OPEN t402_cl:", STATUS, 1)
#      CLOSE t402_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH t402_cl INTO g_rbb.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
#      CLOSE t402_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   IF cl_void(0,0,g_rbb.rbbconf) THEN
#      LET g_chr = g_rbb.rbbconf
#      IF g_rbb.rbbconf = 'N' THEN
#         LET g_rbb.rbbconf = 'X'
#      ELSE
#         LET g_rbb.rbbconf = 'N'
#      END IF
# 
#      UPDATE rbb_file SET rbbconf=g_rbb.rbbconf,
#                          rbbmodu=g_user,
#                          rbbdate=g_today
#       WHERE rbb01 = g_rbb.rbb01  AND rbb02 = g_rbb.rbb02
#         AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant  
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("upd","rbb_file",g_rbb.rbb02,"",SQLCA.sqlcode,"","upd rbbconf",1)
#          LET g_rbb.rbbconf = g_chr
#          ROLLBACK WORK
#          RETURN
#       END IF
#   END IF
# 
#   CLOSE t402_cl
#   COMMIT WORK
# 
#   SELECT * INTO g_rbb.* FROM rbb_file 
#    WHERE rbb01 = g_rbb.rbb01  AND rbb02 = g_rbb.rbb02
#      AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant  
#   DISPLAY BY NAME g_rbb.rbbconf                                                                                        
#   DISPLAY BY NAME g_rbb.rbbmodu                                                                                        
#   DISPLAY BY NAME g_rbb.rbbdate
#    #CKP
#   IF g_rbb.rbbconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   CALL cl_set_field_pic(g_rbb.rbbconf,"","","",g_chr,"")
# 
#   CALL cl_flow_notify(g_rbb.rbb02,'V')    
# 
#END FUNCTION
#FUN-AB0033 mark --------------------------end----------------------------
 
FUNCTION t402_rbb02()
DEFINE l_rab04   LIKE  rab_file.rab04
DEFINE l_rab05   LIKE  rab_file.rab05
DEFINE l_rab06   LIKE  rab_file.rab06
DEFINE l_rab07   LIKE  rab_file.rab07
DEFINE l_rab08   LIKE  rab_file.rab08
DEFINE l_rab09   LIKE  rab_file.rab09
DEFINE l_rab10   LIKE  rab_file.rab10
DEFINE l_rabconf LIKE  rab_file.rabconf
DEFINE l_rabacti   LIKE  rab_file.rabacti

DEFINE l_n     LIKE type_file.num5      #No.TQC-7C0002
DEFINE l_n1    LIKE type_file.num5


    LET g_errno = ''
    LET l_n1 = 0

   SELECT rab04,rab05,rab06,rab07,rab08,rab09,rab10,rabconf,rabacti
     INTO l_rab04,l_rab05,l_rab06,l_rab07,l_rab08,l_rab09,l_rab10,l_rabconf,l_rabacti
     FROM rab_file
    WHERE rab01=g_rbb.rbb01 AND rab02=g_rbb.rbb02 AND rabplant=g_rbb.rbbplant
     
  CASE                          
     WHEN SQLCA.sqlcode=100   LET g_errno='art-196'  
     WHEN l_rabacti='N'       LET g_errno='9028'    
     WHEN l_rabconf<>'Y'      LET g_errno='art-195' 
    OTHERWISE   
    LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE      
  
  SELECT MAX(rbb03) INTO l_n FROM rbb_file
   WHERE rbb01=g_rbb.rbb01 AND rbb02=g_rbb.rbb02 AND rbbplant=g_rbb.rbbplant
  IF cl_null(l_n) OR l_n=0 THEN
     LET g_rbb.rbb03=1 
  ELSE 
     LET g_rbb.rbb03=l_n+1 
  END IF
  IF cl_null(g_errno) THEN
#add by lixia----start----  
     SELECT COUNT(*) INTO l_n1 FROM rbb_file 
      WHERE rbb01=g_rbb.rbb01 
        AND rbb02=g_rbb.rbb02 
        AND rbb03<g_rbb.rbb03
        #AND rbbconf NOT IN('I','X') #FUN-AB0033 mark
        AND rbbconf = 'N'  #FUN-AB0033 add
        AND rbbplant=g_rbb.rbbplant
     IF l_n1 > 0 THEN
        LET g_errno='art-682'
        RETURN
     END IF 
#add by lixia----end----  

     #TQC-AC0326 add --------------------begin---------------------
     LET l_n1 = 0
     SELECT COUNT(*) INTO l_n1 FROM raq_file 
      WHERE raq01=g_rbb.rbb01 AND raq02=g_rbb.rbb02 AND raqplant=g_rbb.rbbplant 
      AND raq03='1' AND raqacti='Y' AND raq05='N'
     IF l_n1 > 0 THEN
        LET g_errno='art-999'
        RETURN
     END IF
     #TQC-AC0326 add ---------------------end----------------------
     
     LET g_rbb.rbb04=l_rab04 
     LET g_rbb.rbb05=l_rab05 
     LET g_rbb.rbb06=l_rab06 
     LET g_rbb.rbb07=l_rab07 
     LET g_rbb.rbb08=l_rab08 
     LET g_rbb.rbb09=l_rab09 
     LET g_rbb.rbb10=l_rab10               
     DISPLAY BY NAME g_rbb.rbb04,g_rbb.rbb05,g_rbb.rbb06,g_rbb.rbb07,
                     g_rbb.rbb08,g_rbb.rbb09,g_rbb.rbb10
     IF cl_null(g_rbb_t.rbb02) THEN  
        LET g_rbb.rbb04t=l_rab04 
        LET g_rbb.rbb05t=l_rab05 
        LET g_rbb.rbb06t=l_rab06 
        LET g_rbb.rbb07t=l_rab07 
        LET g_rbb.rbb08t=l_rab08 
        LET g_rbb.rbb09t=l_rab09 
        LET g_rbb.rbb10t=l_rab10               
        DISPLAY BY NAME g_rbb.rbb03,g_rbb.rbb04t,g_rbb.rbb05t,g_rbb.rbb06t,g_rbb.rbb07t,
                        g_rbb.rbb08t,g_rbb.rbb09t,g_rbb.rbb10t
     END IF                     
  END IF

END FUNCTION




FUNCTION t402_b1_find()
#DEFINE

   LET g_rbc[l_ac1].type  ='1'
   LET g_rbc[l_ac1].before='0'
   LET g_rbc[l_ac1].after ='1'
   
   SELECT rac03,rac04,rac05,rac06,
          rac07,rac08,rac09,rac10,
         #rac11,rac12,rac13,rac14,  #FUN-BC0072 mark
         #rac15,racacti             #FUN-BC0072 mark
          rac11,racacti           #FUN-BC0072 add 
     INTO g_rbc[l_ac1].rbc06_1,g_rbc[l_ac1].rbc07_1,g_rbc[l_ac1].rbc08_1,g_rbc[l_ac1].rbc09_1,
          g_rbc[l_ac1].rbc10_1,g_rbc[l_ac1].rbc11_1,g_rbc[l_ac1].rbc12_1,g_rbc[l_ac1].rbc13_1,
         #g_rbc[l_ac1].rbc14_1,g_rbc[l_ac1].rbc15_1,g_rbc[l_ac1].rbc16_1,g_rbc[l_ac1].rbc17_1,  #FUN-BC0072 mark
         #g_rbc[l_ac1].rbc18_1,g_rbc[l_ac1].rbcacti_1  #FUN-BC0072 mark
          g_rbc[l_ac1].rbc14_1,g_rbc[l_ac1].rbcacti_1  #FUN-BC0072 add
     FROM rac_file
    WHERE rac01=g_rbb.rbb01 AND rac02=g_rbb.rbb02 
      AND rac03=g_rbc[l_ac1].rbc06 AND racplant=g_rbb.rbbplant
   
   #FUN-AB0033 add -----------------start-----------------  
   LET g_rbc[l_ac1].rbc06 = g_rbc[l_ac1].rbc06_1
   LET g_rbc[l_ac1].rbc07 = g_rbc[l_ac1].rbc07_1
   LET g_rbc[l_ac1].rbc08 = g_rbc[l_ac1].rbc08_1
   LET g_rbc[l_ac1].rbc09 = g_rbc[l_ac1].rbc09_1
   LET g_rbc[l_ac1].rbc10 = g_rbc[l_ac1].rbc10_1
   LET g_rbc[l_ac1].rbc11 = g_rbc[l_ac1].rbc11_1
   LET g_rbc[l_ac1].rbc12 = g_rbc[l_ac1].rbc12_1
   LET g_rbc[l_ac1].rbc13 = g_rbc[l_ac1].rbc13_1
   LET g_rbc[l_ac1].rbc14 = g_rbc[l_ac1].rbc14_1
  #FUN-BC0072 mark START
  #LET g_rbc[l_ac1].rbc15 = g_rbc[l_ac1].rbc15_1
  #LET g_rbc[l_ac1].rbc16 = g_rbc[l_ac1].rbc16_1
  #LET g_rbc[l_ac1].rbc17 = g_rbc[l_ac1].rbc17_1
  #LET g_rbc[l_ac1].rbc18 = g_rbc[l_ac1].rbc18_1
  #FUN-BC0072 mark END
   LET g_rbc[l_ac1].rbcacti = g_rbc[l_ac1].rbcacti_1
   
   DISPLAY BY NAME g_rbc[l_ac1].rbc06,g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc09,
                   g_rbc[l_ac1].rbc10,g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,
                  #g_rbc[l_ac1].rbc14,g_rbc[l_ac1].rbc15,g_rbc[l_ac1].rbc16,g_rbc[l_ac1].rbc17,  #FUN-BC0072 mark
                  #g_rbc[l_ac1].rbc18,g_rbc[l_ac1].rbcacti  #FUN-BC0072 mark
                   g_rbc[l_ac1].rbc14,g_rbc[l_ac1].rbcacti   #FUN-BC0072 add
   #FUN-AB0033 add ------------------end------------------  
   DISPLAY BY NAME g_rbc[l_ac1].rbc06_1,g_rbc[l_ac1].rbc07_1,g_rbc[l_ac1].rbc08_1,g_rbc[l_ac1].rbc09_1,
                   g_rbc[l_ac1].rbc10_1,g_rbc[l_ac1].rbc11_1,g_rbc[l_ac1].rbc12_1,g_rbc[l_ac1].rbc13_1,
                  #g_rbc[l_ac1].rbc14_1,g_rbc[l_ac1].rbc15_1,g_rbc[l_ac1].rbc16_1,g_rbc[l_ac1].rbc17_1, #FUN-BC0072 mark
                  #g_rbc[l_ac1].rbc18_1,g_rbc[l_ac1].rbcacti_1    #FUN-BC0072 mark
                   g_rbc[l_ac1].rbc14_1,g_rbc[l_ac1].rbcacti_1 #FUN-BC0072 add
      
   DISPLAY BY NAME g_rbc[l_ac1].type,g_rbc[l_ac1].before,g_rbc[l_ac1].after
       
END FUNCTION 

FUNCTION t402_b2_find()

   LET g_rbd[l_ac2].type1  ='1'
   LET g_rbd[l_ac2].before1='0'
   LET g_rbd[l_ac2].after1 ='1'
   
   SELECT rad03,rad04,rad05,rad06,radacti  
     INTO g_rbd[l_ac2].rbd06_1,g_rbd[l_ac2].rbd07_1,g_rbd[l_ac2].rbd08_1,
          g_rbd[l_ac2].rbd09_1,g_rbd[l_ac2].rbdacti_1
     FROM rad_file
    WHERE rad01=g_rbb.rbb01 AND rad02=g_rbb.rbb02 AND radplant=g_rbb.rbbplant
      AND rad03=g_rbd[l_ac2].rbd06 AND rad04=g_rbd[l_ac2].rbd07
      
   CALL t402_rbd08_1('d',l_ac2)
   IF NOT cl_null(g_rbd[l_ac2].rbd09_1) THEN
      SELECT gfe02 INTO g_rbd[l_ac2].rbd09_1_desc 
        FROM gfe_file
       WHERE gfe01 = g_rbd[l_ac2].rbd09_1  
      DISPLAY BY NAME g_rbd[l_ac2].rbd09_1_desc
   END IF   
   DISPLAY BY NAME g_rbd[l_ac2].rbd06_1,g_rbd[l_ac2].rbd07_1,g_rbd[l_ac2].rbd08_1,
                   g_rbd[l_ac2].rbd09_1,g_rbd[l_ac2].rbdacti_1
      
   DISPLAY BY NAME g_rbd[l_ac2].type1,g_rbd[l_ac2].before1,g_rbd[l_ac2].after1
   
END FUNCTION 
 
FUNCTION t402_copy()

END FUNCTION 


#FUNCTION t402_iss() 
#DEFINE l_cnt      LIKE type_file.num5
#DEFINE l_dbs      LIKE azp_file.azp03   
#DEFINE l_sql      STRING
#DEFINE l_raq04    LIKE raq_file.raq04
#DEFINE l_rtz11    LIKE rtz_file.rtz11
#DEFINE l_rbblegal LIKE rbb_file.rbblegal
#DEFINE l_n        LIKE type_file.num5

# 
#  IF s_shut(0) THEN
#     RETURN
#  END IF

#  IF g_rbb.rbb02 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#
#  SELECT * INTO g_rbb.* FROM rbb_file 
#     WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
#       AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant

#  #IF g_rbb.rbb01<>g_rbb.rbbplant THEN   #FUN-AB0033 mark
#  #   CALL cl_err('','art-663',0)        #FUN-AB0033 mark
#  #   RETURN                             #FUN-AB0033 mark
#  #END IF                                #FUN-AB0033 mark

#  IF g_rbb.rbbacti ='N' THEN
#     CALL cl_err(g_rbb.rbb01,'mfg1000',0)
#     RETURN
#  END IF
#  
#  IF g_rbb.rbbconf = 'N' THEN
#     CALL cl_err('','art-656',0)   #此筆資料未確認不可發布
#     RETURN
#  END IF
#
#  #FUN-AB0033 mark ------start------
#  #IF g_rbb.rbbconf = 'X' THEN  
#  #   CALL cl_err('','art-661',0)
#  #   RETURN
#  #END IF
#  #FUN-AB0033 mark -------end-------

##modify by lixia ----start----   
##   SELECT COUNT(*) INTO l_cnt FROM rbq_file 
##    WHERE rbq01 = g_rbb.rbb01 AND rbq02=g_rbb.rbb02 
##      AND rbb03 = g_rbb.rbb03 AND rbqplant=g_rbb.rbbplant 
##      AND rbq04='1' AND rbqacti='Y' AND rbq08='N'
##   IF l_cnt=0 THEN
##      CALL cl_err('','art-662',0)
##      RETURN
##  END IF
#   #FUN-AB0033 mark ------start------
#   #IF g_rbb.rbbconf = 'I' THEN
#   #  CALL cl_err('','art-662',0)
#   #  RETURN
#   #END IF
#   #FUN-AB0033 mark -------end-------
##modify by lixia ----end----    
##mark by lixia --start-- 
##   OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
##   IF STATUS THEN
##      CALL cl_err("OPEN t402_cl:", STATUS, 1)
##      CLOSE t402_cl
##      ROLLBACK WORK
##      RETURN
##   END IF
##mark by lixia --end-- 
   
#  #FUN-AB0033 mark --------------start-----------------
#  #SELECT COUNT(*) INTO l_cnt FROM rbc_file
#  # WHERE rbc01 = g_rbb.rbb01 AND rbc02 = g_rbb.rbb02
#  #   AND rbc03 = g_rbb.rbb03 AND rbcplant = g_rbb.rbbplant 
#  #IF l_cnt = 0 THEN
#  #   CALL cl_err('','art-548',0)
#  #   RETURN
#  #END IF
#  
#  #IF NOT cl_confirm('art-660') THEN 
#  #   RETURN
#  #END IF     
#  #FUN-AB0033 mark ---------------end------------------
#  
#  #BEGIN WORK  #TQC-AC0326 mark 將確認和發佈放到一個事務中
#  LET g_success = 'Y'
##add by lixia ----start----   
##   UPDATE rbb_file SET rbbconf='I'
##    WHERE rbb02 = g_rbb.rbb02 AND rbb01 = g_rbb.rbb01
##      AND rbb03 = g_rbb.rbb03  AND rbbplant = g_rbb.rbbplant
##   IF SQLCA.sqlerrd[3]=0 THEN
##      LET g_success='N'
##   END IF
##add by lixia ----end----    
#  CALL s_showmsg_init()
#  
#  DROP TABLE rbb_temp
#  SELECT * FROM rbb_file WHERE 1 = 0 INTO TEMP rbb_temp
#  DROP TABLE rbc_temp
#  SELECT * FROM rbc_file WHERE 1 = 0 INTO TEMP rbc_temp
#  DROP TABLE rbd_temp
#  SELECT * FROM rbd_file WHERE 1 = 0 INTO TEMP rbd_temp  
#  DROP TABLE rbp_temp
#  SELECT * FROM rbp_file WHERE 1 = 0 INTO TEMP rbp_temp  
#  DROP TABLE rbq_temp
#  SELECT * FROM rbq_file WHERE 1 = 0 INTO TEMP rbq_temp 
#  DROP TABLE rbk_temp                 #FUN-BC0072 add
#  SELECT * FROM rbk_file WHERE 1 = 0 INTO TEMP rbk_temp  #FUN-BC0072 add

#  DROP TABLE rab_temp
#  SELECT * FROM rab_file WHERE 1 = 0 INTO TEMP rab_temp
#  DROP TABLE rac_temp
#  SELECT * FROM rac_file WHERE 1 = 0 INTO TEMP rac_temp
#  DROP TABLE rad_temp
#  SELECT * FROM rad_file WHERE 1 = 0 INTO TEMP rad_temp
#  DROP TABLE rap_temp
#  SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp
#  DROP TABLE raq_temp
#  SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp
#  DROP TABLE rak_temp             #FUN-BC0072 add
#  SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp     #FUN-BC0072 add

#  CALL t402_iss_upd()  

#  IF g_success = 'N' THEN
#     CALL s_showmsg()
#     ROLLBACK WORK
#     RETURN
#  END IF
#  IF g_success = 'Y' THEN #拋磚成功
#     COMMIT WORK
#     MESSAGE "OK !"
#     LET g_rbb.rbbconf='Y'         
#     DISPLAY BY NAME g_rbb.rbbconf  #add by lixia  
#     CALL s_showmsg()
#     
#  END IF

#  DROP TABLE rbb_temp
#  DROP TABLE rbc_temp
#  DROP TABLE rbd_temp
#  DROP TABLE rbp_temp
#  DROP TABLE rbq_temp
#  DROP TABLE rbk_temp   #FUN-BC0072 add

#  DROP TABLE rab_temp
#  DROP TABLE rac_temp
#  DROP TABLE rad_temp
#  DROP TABLE rap_temp
#  DROP TABLE rak_temp   #FUN-BC0072 add

#END FUNCTION 
#FUN-C60041 -----------------STA
FUNCTION t402_iss()
   SELECT * INTO g_rbb.* FROM rbb_file
    WHERE rbb02 = g_rbb.rbb02 AND rbb01=g_rbb.rbb01
      AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
   CALL s_showmsg_init()
   CALL t402_iss_upd()
   IF g_success = 'N' THEN
      CALL s_showmsg()
   END IF
END FUNCTION
#FUN-C60041 -----------------END

FUNCTION t402_iss_upd() 
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_dbs      LIKE azp_file.azp03   
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rtz11    LIKE rtz_file.rtz11
DEFINE l_rbblegal LIKE rbb_file.rbblegal
DEFINE l_raqacti  LIKE raq_file.raqacti
DEFINE l_raq04    LIKE raq_file.raq04
  #LET l_sql="SELECT raq04,raqacti FROM raq_file ",  #FUN-BC0072 mark
   LET l_sql="SELECT DISTINCT raq04 FROM raq_file ",  #FUN-BC0072 add
             " WHERE raq01=? AND raq02=?",
             "   AND raq03='1' AND raqplant=?"
   PREPARE raq_pre FROM l_sql
   DECLARE raq_cs CURSOR FOR raq_pre
   FOREACH raq_cs USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbbplant
                 #INTO l_raq04,l_raqacti   #FUN-BC0072 mark
                  INTO l_raq04   #FUN-BC0072 add
     #FUN-BC0072 add START
      LET l_n = 0
      LET l_sql="SELECT COUNT(*) FROM raq_file ",  
                " WHERE raq01='",g_rbb.rbb01,"'",
                " AND raq02= '",g_rbb.rbb02,"'",
                "   AND raq03='1' AND raqplant='",g_rbb.rbbplant,"'",
                "   AND raq04='",l_raq04,"'",
                "   AND raqacti = 'Y' "
      PREPARE raq_pre1 FROM l_sql       
      EXECUTE raq_pre1 INTO l_n 
      IF l_n = 0 OR cl_null(l_n) THEN
         LET l_raqacti = 'N'
      ELSE
         LET l_raqacti = 'Y'
      END IF
     #FUN-BC0072 add END
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rbq_cs:',SQLCA.sqlcode,1)                         
         EXIT FOREACH 
      END IF   
      IF g_rbb.rbbplant<>l_raq04 THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file
          WHERE azw07 = g_rbb.rbbplant
            AND azw01 = l_raq04
         IF l_cnt = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
      SELECT azw02 INTO l_rbblegal FROM azw_file
       WHERE azw01 = l_raq04 AND azwacti='Y'
      SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

      IF l_raqacti='N' THEN #營運中心無效時
         IF g_rbb.rbbplant <> l_raq04 THEN
            CALL t402_iss_chk(l_raq04) RETURNING l_n
    
            IF l_n>0 THEN    #UPDATE     #若營運中心l_raq04下有資料則先插入此變更單再走審核段
               CALL t402_iss_trans(l_raq04) 
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
               IF l_rtz11='N' THEN  
                 #CALL s_showmsg_init()       #FUN-AB0033 add    #FUN-C60041 mark
                  LET g_errno=' '             #FUN-AB0033 add
                  CALL t402sub_y_upd(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_raq04) 
                 #CALL s_showmsg()            #FUN-AB0033 add    #FUN-C60041 mark
                 IF NOT cl_null(g_errno) THEN #FUN-AB0033 add
                     LET g_success = 'N'      #FUN-AB0033 add
                    #ROLLBACK WORK            #FUN-AB0033 add    #FUN-C60041 mark
                  END IF                      #FUN-AB0033 add
               END IF 
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
            END IF
            IF g_success = 'N' THEN
               EXIT FOREACH
            ELSE 
               CONTINUE FOREACH
            END IF
         END IF
      ELSE                 #營運中心有效時  
#FUN-C60041 -------------mark----------begin      	 
#        CALL t402_iss_trans(l_raq04) 
#        IF g_success = 'N' THEN
#           EXIT FOREACH
#        END IF
#FUN-C60041 -------------mark ---------end
         CALL t402_iss_chk(l_raq04) RETURNING l_n
         IF l_n>0 THEN    #UPDATE
#FUN-C60041 --------------STA
           CALL t402_iss_trans(l_raq04)
           IF g_success = 'N' THEN
              EXIT FOREACH
           END IF
#FUN-C60041 --------------END
            IF l_rtz11='N' THEN     #若營運中心l_raq04下有資料則直接走審核段 
              #CALL s_showmsg_init()        #FUN-AB0033 add   #FUN-C60041 mark                                                                                      
               LET g_errno=' '              #FUN-AB0033 add
               CALL t402sub_y_upd(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_raq04)  
              #CALL s_showmsg()             #FUN-AB0033 add   #FUN-C60041 mark
               IF NOT cl_null(g_errno) THEN #FUN-AB0033 add
                  LET g_success = 'N'       #FUN-AB0033 add
                 #ROLLBACK WORK             #FUN-AB0033 add   #FUN-C60041 mark
               END IF                       #FUN-AB0033 add
               IF g_success = 'N' THEN
                  EXIT FOREACH
               END IF
            END IF 
         ELSE   #INSERT #或者是此l_raq04為新增有效或原來無效變更為有效，此時走原artt302發布邏輯
            CALL t402_iss_pretrans(l_raq04)
            IF g_success = 'N' THEN
               EXIT FOREACH
            END IF
         END IF  #UPDATE&INSERT 
      END IF
   END FOREACH

END FUNCTION
 
 
#判斷營運中心l_raq04下是否有資料
#返回值：l_n
FUNCTION t402_iss_chk(l_raq04)
DEFINE l_n      LIKE type_file.num5
DEFINE l_sql    STRING
DEFINE l_raq04  LIKE raq_file.raq04

   LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_raq04, 'rab_file'),
             " WHERE rab01='",g_rbb.rbb01,"'",
             "   AND rab02='",g_rbb.rbb02,"'",
             "   AND rabplant='",l_raq04,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
   PREPARE trans_cnt_rab FROM l_sql
   EXECUTE trans_cnt_rab INTO l_n

   RETURN l_n

END FUNCTION

#拋磚當前變更單到營運中心l_raq04下
#返回值:全局變量g_success 
FUNCTION t402_iss_trans(l_raq04) 

DEFINE l_raq04  LIKE raq_file.raq04
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rtz11    LIKE rtz_file.rtz11
DEFINE l_rbblegal LIKE rbb_file.rbblegal

   SELECT azw02 INTO l_rbblegal FROM azw_file
    WHERE azw01 = l_raq04 AND azwacti='Y'
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

      IF g_rbb.rbbplant = l_raq04 THEN #與當前機構相同則不拋
         UPDATE raq_file SET raq05='Y' 
          WHERE raq01=g_rbb.rbb01 AND raq02=g_rbb.rbb02 
            AND raq03='1' AND raq04=l_raq04 AND raqplant=g_rbb.rbbplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rbb.rbb02,"",STATUS,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM rbq_file
          WHERE rbq01=g_rbb.rbb01 AND rbq02=g_rbb.rbb02 AND rbq03=g_rbb.rbb03
            AND rbq04='1' AND rbq07=l_raq04 AND rbqplant=g_rbb.rbbplant
         IF l_n>0 THEN    #此生效機構有變更記錄
            UPDATE rbq_file SET rbq08='Y' 
             WHERE rbq01=g_rbb.rbb01 AND rbq02=g_rbb.rbb02 AND rbq03=g_rbb.rbb03
               AND rbq04='1' AND rbq06='1' AND rbq07=l_raq04 AND rbqplant=g_rbb.rbbplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rbq_file",g_rbb.rbb02,"",STATUS,"","",1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      ELSE
         UPDATE raq_file SET raq05='Y' 
          WHERE raq01=g_rbb.rbb01 AND raq02=g_rbb.rbb02 
            AND raq03='1' AND raq04=l_raq04 AND raqplant=g_rbb.rbbplant
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raq_file",g_rbb.rbb02,"",STATUS,"","",1) 
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_n FROM rbq_file
          WHERE rbq01=g_rbb.rbb01 AND rbq02=g_rbb.rbb02 AND rbq03=g_rbb.rbb03
            AND rbq04='1' AND rbq07=l_raq04 AND rbqplant=g_rbb.rbbplant
         IF l_n>0 THEN    #此生效機構有變更記錄
            UPDATE rbq_file SET rbq08='Y' 
             WHERE rbq01=g_rbb.rbb01 AND rbq02=g_rbb.rbb02 AND rbq03=g_rbb.rbb03
               AND rbq04='1' AND rbq06='1' AND rbq07=l_raq04 AND rbqplant=g_rbb.rbbplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rbq_file",g_rbb.rbb02,"",STATUS,"","",1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
        #將數據放入臨時表中處理
         DELETE FROM rbb_temp
         DELETE FROM rbc_temp
         DELETE FROM rbd_temp  
         DELETE FROM rbq_temp
         DELETE FROM rbp_temp
         DELETE FROM rbk_temp   #FUN-BC0072 add

         INSERT INTO rbc_temp SELECT rbc_file.* FROM rbc_file
                               WHERE rbc01 = g_rbb.rbb01 AND rbc02 = g_rbb.rbb02
                                 AND rbc03 = g_rbb.rbb03 AND rbcplant = g_rbb.rbbplant
         UPDATE rbc_temp SET rbcplant=l_raq04,
                             rbclegal = l_rbblegal

         INSERT INTO rbd_temp SELECT rbd_file.* FROM rbd_file
                               WHERE rbd01 = g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                                 AND rbd03 = g_rbb.rbb03 AND rbdplant = g_rbb.rbbplant
         UPDATE rbd_temp SET rbdplant=l_raq04,
                             rbdlegal = l_rbblegal

         INSERT INTO rbp_temp SELECT rbp_file.* FROM rbdpfile
                               WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
                                 AND rbp03 = g_rbb.rbb03 AND rbpplant = g_rbb.rbbplant
         UPDATE rbp_temp SET rbpplant=l_raq04,
                             rbplegal = l_rbblegal

         INSERT INTO rbb_temp SELECT * FROM rbb_file
          WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02
            AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant
         IF l_rtz11='Y' THEN
            UPDATE rbb_temp SET rbbplant = l_raq04,
                                rbblegal = l_rbblegal,
                                rbbconf = 'N',
                                rbbcond = NULL,
                                rbbcont = NULL,
                                rbbconu = NULL
         ELSE
            UPDATE rbb_temp SET rbbplant = l_raq04,
                                rbblegal = l_rbblegal,
                                rbbconf = 'Y',
                                rbbcond = g_today,
                                rbbcont = g_time,
                                rbbconu = g_user
         END IF

         INSERT INTO rbq_temp SELECT * FROM rbq_file
          WHERE rbq01=g_rbb.rbb01 AND rbq02 = g_rbb.rbb02
            AND rbq03=g_rbb.rbb03 AND rbq04 ='1' 
            AND rbqplant = g_rbb.rbbplant
         UPDATE rbq_temp SET rbqplant = l_raq04,
                             rbq08    = 'Y',
                             rbqlegal = l_rbblegal
       #FUN-BC0072 add START
         INSERT INTO rbk_temp SELECT * FROM rbk_file
          WHERE rbk01=g_rbb.rbb01 AND rbk02 = g_rbb.rbb02
            AND rbk03=g_rbb.rbb03 AND rbk04 ='1'
            AND rbkplant = g_rbb.rbbplant
         UPDATE rbk_temp SET rbkplant = l_raq04,
                             rbklegal = l_rbblegal
       #FUN-BC0072 add END


         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbb_file'),
                     " SELECT * FROM rbb_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rbb FROM l_sql
         EXECUTE trans_ins_rbb
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbb_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
         
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbc_file'), 
                     " SELECT * FROM rbc_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbc FROM l_sql
         EXECUTE trans_ins_rbc
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbc_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbd_file'), 
                     " SELECT * FROM rbd_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbd FROM l_sql
         EXECUTE trans_ins_rbd
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbd_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbp_file'), 
                     " SELECT * FROM rbp_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql 
         PREPARE trans_ins_rbp FROM l_sql
         EXECUTE trans_ins_rbp
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbp_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF 

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbq_file'), 
                     " SELECT * FROM rbq_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql  
         PREPARE trans_ins_rbq FROM l_sql
         EXECUTE trans_ins_rbq
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbq_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
       #FUN-BC0072 add START
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rbk_file'),
                     " SELECT * FROM rbk_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
         PREPARE trans_ins_rbk FROM l_sql
         EXECUTE trans_ins_rbk
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO rbk_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
         END IF
       #FUN-BC0072 add END
      END IF       

END FUNCTION

#變更新增有效營運中心或變更原促銷當中無效營運中心為有效時
#即：若營運中心l_raq04下無此筆促銷變更單時直接插入變更後的一般促銷單
#即：走artt302發布邏輯
#返回值：全局變量g_success
FUNCTION t402_iss_pretrans(l_raq04)
DEFINE l_raq04  LIKE raq_file.raq04
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_rtz11    LIKE rtz_file.rtz11
DEFINE l_rbblegal LIKE rbb_file.rbblegal

   SELECT azw02 INTO l_rbblegal FROM azw_file
    WHERE azw01 = l_raq04 AND azwacti='Y'
   SELECT rtz11 INTO l_rtz11 FROM rtz_file WHERE rtz01 = l_raq04

            DELETE FROM rab_temp
            DELETE FROM rac_temp
            DELETE FROM rad_temp
            DELETE FROM raq_temp
            DELETE FROM rap_temp
            DELETE FROM rak_temp   #FUN-BC0072 add

            INSERT INTO rac_temp SELECT rac_file.* FROM rac_file
                                  WHERE rac01 = g_rbb.rbb01 AND rac02 = g_rbb.rbb02
                                    AND racplant = g_rbb.rbbplant
            UPDATE rac_temp SET racplant=l_raq04,
                                raclegal = l_rbblegal
   
            INSERT INTO rad_temp SELECT rad_file.* FROM rad_file
                                  WHERE rad01 = g_rbb.rbb01 AND rad02 = g_rbb.rbb02
                                    AND radplant = g_rbb.rbbplant
            UPDATE rad_temp SET radplant=l_raq04,
                                radlegal = l_rbblegal
   
            INSERT INTO rap_temp SELECT rap_file.* FROM radpfile
                                  WHERE rap01 = g_rbb.rbb01 AND rap02 = g_rbb.rbb02
                                    AND rapplant = g_rbb.rbbplant
            UPDATE rap_temp SET rapplant=l_raq04,
                                raplegal = l_rbblegal
   
            INSERT INTO rab_temp SELECT * FROM rab_file
             WHERE rab01 = g_rbb.rbb01 AND rab02 = g_rbb.rbb02
               AND rabplant = g_rbb.rbbplant
            IF l_rtz11='Y' THEN
               UPDATE rab_temp SET rabplant = l_raq04,
                                   rablegal = l_rbblegal,
                                   rabconf = 'N',
                                   rabcond = NULL,
                                   rabcont = NULL,
                                   rabconu = NULL
            ELSE
               UPDATE rab_temp SET rabplant = l_raq04,
                                   rablegal = l_rbblegal,
                                   rabconf = 'Y',
                                   rabcond = g_today,
                                   rabcont = g_time,
                                   rabconu = g_user
            END IF
   
            INSERT INTO raq_temp SELECT * FROM raq_file
             WHERE raq01=g_rbb.rbb01 AND raq02 = g_rbb.rbb02
               AND raq03 ='1' AND raqplant = g_rbb.rbbplant
            UPDATE raq_temp SET raqplant = l_raq04,
                                raq05    = 'Y',
                                raqlegal = l_rbblegal
            #FUN-C60041 -----------STA
                                ,raq06 = g_today,
                                raq07 = g_time
            #FUN-C60041 -----------END

          #FUN-BC0072 add START
            INSERT INTO rak_temp SELECT * FROM rak_file
             WHERE rak01=g_rbb.rbb01 AND rak02 = g_rbb.rbb02
               AND rak03 ='1' AND rakplant = g_rbb.rbbplant
            UPDATE rak_temp SET rakplant = l_raq04,
                                raklegal = l_rbblegal            
          #FUN-BC0072 add END

            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rab_file'),
                        " SELECT * FROM rab_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rab FROM l_sql
            EXECUTE trans_ins_rab
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rab_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rac_file'),
                        " SELECT * FROM rac_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rac FROM l_sql
            EXECUTE trans_ins_rac
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rac_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rad_file'),
                        " SELECT * FROM rad_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rad FROM l_sql
            EXECUTE trans_ins_rad
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rad_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rap_file'),
                        " SELECT * FROM rap_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rap FROM l_sql
            EXECUTE trans_ins_rap
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
   
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'raq_file'),
                        " SELECT * FROM raq_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_raq FROM l_sql
            EXECUTE trans_ins_raq
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF 

         #FUN-BC0072 add START
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04, 'rak_file'),
                        " SELECT * FROM rak_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_raq04) RETURNING l_sql
            PREPARE trans_ins_rak FROM l_sql
            EXECUTE trans_ins_rak
            IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO rak_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
            END IF
         #FUN-BC0072 add END

END FUNCTION

FUNCTION t402_b1_init()
#DEFINE 
           LET g_rbc[l_ac1].rbc07 = '1'      #促銷方式 1:特價 2:折扣 3:折價
           LET g_rbc[l_ac1].rbc08 = 0        #特賣價
           LET g_rbc[l_ac1].rbc10 = 0        #折讓額
          #LET g_rbc[l_ac1].rbc11 = 'N'      #會員等級促銷否
           LET g_rbc[l_ac1].rbc11 = '0'  #FUN-BC0072 add
           LET g_rbc[l_ac1].rbc12 = 0        #會員特賣價
           LET g_rbc[l_ac1].rbc14 = 0        #會員折讓額
          #FUN-BC0072 mark START
          #LET g_rbc[l_ac1].rbc15 = g_today        #促銷開始日期
          #LET g_rbc[l_ac1].rbc17 = '00:00:00'     #促銷開始時間
          #LET g_rbc[l_ac1].rbc16 = g_today        #促銷結束日期
          #LET g_rbc[l_ac1].rbc18 = '23:59:59'     #促銷結束時間
          #FUN-BC0072 mark END
           LET g_rbc[l_ac1].rbcacti = 'Y'

           LET g_rbc[l_ac1].type    ='0'
           LET g_rbc[l_ac1].before  =' '
           LET g_rbc[l_ac1].after   ='1'

           LET g_rbc[l_ac1].rbc06_1 = NULL 
           LET g_rbc[l_ac1].rbc07_1 = NULL 
           LET g_rbc[l_ac1].rbc08_1 = NULL 
           LET g_rbc[l_ac1].rbc09_1 = NULL 
           LET g_rbc[l_ac1].rbc10_1 = NULL 
           LET g_rbc[l_ac1].rbc11_1 = NULL 
           LET g_rbc[l_ac1].rbc12_1 = NULL 
           LET g_rbc[l_ac1].rbc13_1 = NULL 
           LET g_rbc[l_ac1].rbc14_1 = NULL 
          #FUN-BC0072 mark START
          #LET g_rbc[l_ac1].rbc15_1 = NULL 
          #LET g_rbc[l_ac1].rbc16_1 = NULL 
          #LET g_rbc[l_ac1].rbc17_1 = NULL 
          #LET g_rbc[l_ac1].rbc18_1 = NULL 
          #FUN-BC0072 mark END
           LET g_rbc[l_ac1].rbcacti_1 = NULL 



          #LET g_rbc[l_ac1].rbc09 = 100      #折扣率%
          #LET g_rbc[l_ac1].rbc13 = 100      #會員折扣率%
          #IF NOT cl_null(g_rbb.rbb0) THEN
          #   SELECT raa05,raa06 INTO g_rbc[l_ac1].rbc15,g_rbc[l_ac1].rbc16
          #     FROM raa_file
          #   WHERE raa01=g_rab.rab01 AND raa02=g_rab.rab03
          #END IF
          #IF cl_null(g_rac[l_ac].rac12) THEN
          #   LET g_rac[l_ac].rac12 = g_today        #促銷開始日期
          #END IF
          #IF cl_null(g_rac[l_ac].rac13) THEN
          #   LET g_rac[l_ac].rac13 = g_today        #促銷結束日期
          #END IF

END FUNCTION

FUNCTION t402_b2_init()

           LET g_rbd[l_ac2].type1    ='0'
           LET g_rbd[l_ac2].before1  =' '
           LET g_rbd[l_ac2].after1   ='1'

           LET g_rbd[l_ac2].rbd06_1 = NULL
           LET g_rbd[l_ac2].rbd07_1 = NULL
           LET g_rbd[l_ac2].rbd08_1 = NULL
           LET g_rbd[l_ac2].rbd09_1 = NULL
           LET g_rbd[l_ac2].rbdacti_1 = NULL
          
           CALL t402_rbd07()
END FUNCTION
   
  
#FUNCTION t402_set_required(p_newline)
#   DEFINE p_newline LIKE type_file.chr1     #No.FUN-680136 VARCHAR(01)
# 
#   IF p_newline='Y' THEN
#      CALL cl_set_comp_required("rbc04a,rbc31a,rbc32a,rbc33a",TRUE)  #No.FUN-550089  #No.TQC-5C0105
#      IF g_sma.sma115 = "N" THEN
#         CALL cl_set_comp_required("rbc20",TRUE)
#      END IF
#   END IF
# 
#   IF p_newline='Y' AND g_pmm02 <> 'SUB' THEN
#      IF g_sma.sma115 = "N" THEN
#         CALL cl_set_comp_required("rbc07a",TRUE)
#      END IF
#   END IF
# 
# #  #是新增且請採購要勾稽時，請購單號，項次必需要輸入
#   IF p_newline='Y' AND g_sma.sma32='Y' THEN
#      CALL cl_set_comp_required("rbc90,rbc91",TRUE)
#   END IF
#END FUNCTION
# 
#FUNCTION t402_set_entry_b2(p_newline)
#  DEFINE p_newline LIKE type_file.chr1
#  IF p_newline = 'N' THEN
#     CALL cl_set_comp_entry("rbc04a",TRUE)
#  END IF
#  IF p_newline = 'Y' AND g_sma.sma32='Y' THEN
#     #參數設勾稽請採購,必須輸入請購單號，序號
#     CALL cl_set_comp_entry("rbc90,rbc91",TRUE)
#  END IF
#END FUNCTION
# 
#FUNCTION t402_set_no_entry_b2(p_newline)
#  DEFINE p_newline  LIKE type_file.chr1
# 
#  IF p_newline = 'Y' AND g_sma.sma32='Y' THEN
#     CALL cl_set_comp_entry("rbc04a",FALSE)
#  END IF
#END FUNCTION
# 
#FUNCTION t402_set_no_required(p_newline)
#   DEFINE p_newline LIKE type_file.chr1     #No.FUN-680136 VARCHAR(01)
# 
#   CALL cl_set_comp_required("rbc04a,rbc20a,rbc31a,rbc32a,rbc33a,rbc07a,rbc90,rbc91",FALSE) #No.FUN-550089   #No.TQC-5C0015  #FUN-690129 add rbc90,rbc91
# 
# 
#END FUNCTION
  
FUNCTION t402_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rbb02",TRUE)
     CALL cl_set_comp_required("rbb02",TRUE)
  END IF
  CALL cl_set_comp_entry("rbb04t,rbb05t,rbb06t,rbb07t,rbb08t,rbb09t,rbb10t",TRUE)
  #CALL cl_set_comp_entry("rbbmksg",TRUE) #FUN-AB0033 mark
#  CALL cl_set_comp_entry("rbbmksg",FALSE) #FUN-AB0033 add         #FUN-B30028 mark
END FUNCTION
 
FUNCTION t402_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("rbb02",FALSE)  
  END IF
END FUNCTION
#FUN-A70048   
#FUN-BC0072 add START
FUNCTION t402_b()
DEFINE l_sql      STRING
DEFINE
    l_ac1_t         LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
    l_cnt           LIKE type_file.num5,                #No.MOD-650101 add  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    p_cmd           LIKE type_file.chr1                  #處理狀態  #No.FUN-680136 VARCHAR(1)
DEFINE   l_rbc04_curr  LIKE rbc_file.rbc04 
DEFINE l_price    LIKE rac_file.rac05
DEFINE l_discount LIKE rac_file.rac06
DEFINE l_date     LIKE rac_file.rac12
DEFINE l_time1    LIKE type_file.num5
DEFINE l_time2    LIKE type_file.num5
DEFINE l_rbc      RECORD LIKE rbc_file.*  
DEFINE
       l_ac2_t      LIKE type_file.num5
DEFINE l_ima25      LIKE ima_file.ima25
DEFINE l_rbd04_curr LIKE rbd_file.rbd04
DEFINE l_rbd        RECORD LIKE rbd_file.*
DEFINE l_rbk        RECORD LIKE rbk_file.*
DEFINE l_ac3_t      LIKE type_file.num5
DEFINE l_rbk04_curr LIKE rbk_file.rbk04 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_rbb.rbb02) THEN
       RETURN
    END IF
    SELECT * INTO g_rbb.* FROM rbb_file
      WHERE rbb01 = g_rbb.rbb01 AND rbb02 = g_rbb.rbb02 
        AND rbb03 = g_rbb.rbb03 AND rbbplant = g_rbb.rbbplant

    IF g_rbb.rbbacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_rbb.rbb01||g_rbb.rbb02,'mfg1000',1)
       RETURN
    END IF 

    IF g_rbb.rbbconf = 'Y' THEN  #FUN-AB0033 add
       CALL cl_err('','art-024',1)
       RETURN
    END IF

    IF g_rbb.rbb01 <> g_rbb.rbbplant THEN 
       CALL cl_err('','art-977',0) 
       RETURN 
    END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT * ",
                       "   FROM rbc_file ",
                       "  WHERE rbc01 = ?  AND rbc02 = ? AND rbc03= ? AND rbcplant= ? ",
                       "    AND rbc06 = ? ",
                       "    AND rbc05='1' ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t402_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac1_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    LET g_forupd_sql = "SELECT * ",
                       "  FROM rbk_file ",
                       " WHERE rbk01=? AND rbk02=? AND rbk03=? AND rbk05 = '1' ",
                       "   AND rbk06 = '1' AND rbk07 = ? AND rbk08 = ? AND rbkplant = ? ",
                       " FOR UPDATE  " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4022_bcl CURSOR FROM g_forupd_sql
    LET l_ac3_t = 0
 
    LET g_forupd_sql = " SELECT * ",
                       "   FROM rbd_file ",
                       "  WHERE rbd01=? AND rbd02 = ? ",
                       "    AND rbd03=? AND rbdplant=?  AND rbd06=? AND rbd07=? ",  
                       "    AND rbd05='1'",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR         
    LET l_ac2_t = 0

    DIALOG ATTRIBUTES(UNBUFFERED)

        INPUT ARRAY g_rbc FROM s_rbc.*
              ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
            LET g_b_flag = '1'   #FUN-D30033 add
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()  
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)          #NO.MOD-AC0179
            BEGIN WORK
     
            OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
            IF STATUS THEN
               CALL cl_err("OPEN t402_cl:", STATUS, 1)
               CLOSE t402_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t402_cl INTO g_rbb.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rbb.rbb01||g_rbb.rbb02,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t402_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b1>=l_ac1 THEN
                LET p_cmd='u'
                LET g_rbc_t.* = g_rbc[l_ac1].*  #BACKUP
                LET g_rbc_o.* = g_rbc[l_ac1].*  #BACKUP
 
               LET l_sql = " SELECT b.rbc04,'',a.rbc05,a.rbc06,a.rbc07,a.rbc08,a.rbc09,a.rbc10,a.rbc11, ",
                           "                   a.rbc12,a.rbc13,a.rbc14,a.rbcacti,",
                           "                   b.rbc05,b.rbc06,b.rbc07,b.rbc08,b.rbc09,b.rbc10,b.rbc11, ",
                           "                   b.rbc12,b.rbc13,b.rbc14,b.rbcacti ",
                           "   FROM rbc_file b LEFT OUTER JOIN rbc_file a",
                           "                   ON (b.rbc01=a.rbc01 AND b.rbc02=a.rbc02 AND b.rbc03=a.rbc03 ",
                           "                       AND b.rbc04=a.rbc04 AND b.rbc06=a.rbc06 AND b.rbcplant=a.rbcplant AND b.rbc05<>a.rbc05 ) ",#lixia
                           "  WHERE b.rbc01 = '",g_rbb.rbb01,"'  AND b.rbc02 = '",g_rbb.rbb02,"'",
                           "    AND b.rbc03=  '",g_rbb.rbb03,"'  AND b.rbcplant= '",g_rbb.rbbplant,"'",
                           "    AND b.rbc06 = '",g_rbc_t.rbc06,"' ",
                           "    AND b.rbc05='1' "
               PREPARE sel_rbc_row FROM l_sql
               EXECUTE sel_rbc_row INTO l_rbc04_curr,g_rbc[l_ac1].*
               OPEN t402_bcl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant,
                                    g_rbc_t.rbc06 
                IF STATUS THEN
                    CALL cl_err("OPEN t402_bcl:", STATUS, 1)
                ELSE
                   #FETCH t402_bcl INTO l_rbc04_curr,g_rbc[l_ac1].*  #cockroach 100921 mark
                    FETCH t402_bcl INTO l_rbc.*                      #FUN-BC0072 add
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rbc_t.type||g_rbc_t.rbc06,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    IF g_rbc[l_ac1].before='0' THEN
                       LET g_rbc[l_ac1].type ='1'
                    ELSE
                       LET g_rbc[l_ac1].type ='0'
                    END IF
                END IF
                CALL cl_show_fld_cont()      
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            IF g_rbc[l_ac1].type= '0' THEN
               INSERT INTO rbc_file(rbc01,rbc02,rbc03,rbc04,rbc05,
                                    rbc06,rbc07,rbc08,rbc09,rbc10,
                                    rbc11,rbc12,rbc13,rbc14,
                                    rbc19,rbc20,
                                    rbcacti,rbcplant,rbclegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbc04_curr,g_rbc[l_ac1].after,
                      g_rbc[l_ac1].rbc06,g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc09,g_rbc[l_ac1].rbc10,
                      g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,g_rbc[l_ac1].rbc14,' ',' ',
                      g_rbc[l_ac1].rbcacti,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbc_file",g_rbb.rbb02||g_rbc[l_ac1].after||g_rbc[l_ac1].rbc06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b1=g_rec_b1+1
                  DISPLAY g_rec_b1 TO FORMONLY.cn1
               END IF           
            ELSE
               INSERT INTO rbc_file(rbc01,rbc02,rbc03,rbc04,rbc05,
                                    rbc06,rbc07,rbc08,rbc09,rbc10,
                                    rbc11,rbc12,rbc13,rbc14,
                                    rbc19,rbc20,
                                    rbcacti,rbcplant,rbclegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbc04_curr,g_rbc[l_ac1].after,
                      g_rbc[l_ac1].rbc06,g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc09,g_rbc[l_ac1].rbc10,
                      g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc12,g_rbc[l_ac1].rbc13,g_rbc[l_ac1].rbc14,' ',' ',
                      g_rbc[l_ac1].rbcacti,g_rbb.rbbplant,g_rbb.rbblegal)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbc_file",g_rbb.rbb02||g_rbc[l_ac1].after||g_rbc[l_ac1].rbc06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT 
               ELSE
                  MESSAGE 'INSERT value.after O.K' 
               END IF
               INSERT INTO rbc_file(rbc01,rbc02,rbc03,rbc04,rbc05,
                                    rbc06,rbc07,rbc08,rbc09,rbc10,
                                    rbc11,rbc12,rbc13,rbc14,
                                    rbc19,rbc20,
                                    rbcacti,rbcplant,rbclegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbc04_curr,g_rbc[l_ac1].before,
                      g_rbc[l_ac1].rbc06_1,g_rbc[l_ac1].rbc07_1,g_rbc[l_ac1].rbc08_1,g_rbc[l_ac1].rbc09_1,g_rbc[l_ac1].rbc10_1,
                      g_rbc[l_ac1].rbc11_1,g_rbc[l_ac1].rbc12_1,g_rbc[l_ac1].rbc13_1,g_rbc[l_ac1].rbc14_1,' ' ,' ', 
                      g_rbc[l_ac1].rbcacti_1,g_rbb.rbbplant,g_rbb.rbblegal)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbc_file",g_rbb.rbb02||g_rbc[l_ac1].before||g_rbc[l_ac1].rbc06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT value.before O.K'
                  COMMIT WORK
                  LET g_rec_b1=g_rec_b1+1
                  DISPLAY g_rec_b1 TO FORMONLY.cn1
               END IF
            END IF

        BEFORE INSERT
            DISPLAY "BEFORE INSERT!"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rbc[l_ac1].* TO NULL 
            LET g_rbc[l_ac1].type = '0'      
            LET g_rbc[l_ac1].before = '0'
            LET g_rbc[l_ac1].after  = '1' 
            LET g_rbc_t.* = g_rbc[l_ac1].*         #新輸入資料
            LET g_rbc_o.* = g_rbc[l_ac1].*
            SELECT MAX(rbc04)+1 INTO l_rbc04_curr 
              FROM rbc_file
             WHERE rbc01=g_rbb.rbb01
               AND rbc02=g_rbb.rbb02 
               AND rbc03=g_rbb.rbb03 
               AND rbcplant=g_rbb.rbbplant
              IF l_rbc04_curr IS NULL OR l_rbc04_curr=0 THEN
                 LET l_rbc04_curr = 1
              END IF                          
           CALL cl_show_fld_cont()
           NEXT FIELD rbc06

       AFTER FIELD rbc06
           IF NOT cl_null(g_rbc[l_ac1].rbc06) THEN
              IF (g_rbc[l_ac1].rbc06 <> g_rbc_t.rbc06
                 OR cl_null(g_rbc_t.rbc06)) THEN 
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM rbc_file
                     WHERE rbc01=g_rbb.rbb01 AND rbc02=g_rbb.rbb02
                       AND rbc03 = g_rbb.rbb03  #TQC-C20328 add
                       AND rbcplant=g_rbb.rbbplant AND rbc06=g_rbc[l_ac1].rbc06
                 IF l_n > 0 THEN
                    CALL cl_err('','-239',0)
                    NEXT FIELD rbc06
                 END IF
                 SELECT COUNT(*) INTO l_n 
                   FROM rac_file
                  WHERE rac01=g_rbb.rbb01 AND rac02=g_rbb.rbb02
                    AND racplant=g_rbb.rbbplant AND rac03=g_rbc[l_ac1].rbc06
                 IF l_n=0 THEN
                    IF NOT cl_confirm('art-677') THEN   #確定新增?
                       NEXT FIELD rbc06
                    ELSE
                       CALL t402_b1_init()
                    END IF
                 ELSE
                    IF NOT cl_confirm('art-676') THEN   #確定修改?
                       NEXT FIELD rbc06
                    ELSE
                       CALL t402_b1_find()   
                    END IF           
                 END IF
              END IF       
           END IF

      AFTER FIELD rbc07
         IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
            IF g_rbc_o.rbc07 IS NULL OR
               (g_rbc[l_ac1].rbc07 != g_rbc_o.rbc07 ) THEN
               IF g_rbc[l_ac1].rbc07 NOT MATCHES '[123]' THEN
                  LET g_rbc[l_ac1].rbc07= g_rbc_o.rbc07
                  NEXT FIELD rbc07
               END IF
            END IF
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)        
         END IF

      ON CHANGE rbc07
         IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
            CALL t402_chkrbp()  
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)
         END IF                             
                    
      ON CHANGE rbc11
         IF NOT cl_null(g_rbc[l_ac1].rbc11) THEN
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)
        #FUN-BC0072 add START
            IF g_rbc[l_ac1].rbc11 <> g_rbc_t.rbc11 THEN
               LET l_n =0 
               SELECT COUNT(*) INTO l_n FROM rbp_file
                  WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
                    AND rbp04 = '1' AND rbpplant = g_rbb.rbbplant
                    AND rbp03 = g_rbb.rbb03
                    AND rbp07 = g_rbc[l_ac1].rbc06
               IF l_cnt > 0 THEN
                  IF NOT cl_confirm('art-756') THEN
                     LET g_rbc[l_ac1].rbc11 = g_rbc_t.rbc11
                  ELSE
                     DELETE FROM rbp_file
                      WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
                        AND rbp03 = '1' AND rbpplant = g_rbb.rbbplant
                        AND rbp04 = g_rbc[l_ac1].rbc06
                  END IF
               END IF
            END IF
        #FUN-BC0072 add END
         END IF
      
      AFTER FIELD rbc11
         IF NOT cl_null(g_rbc[l_ac1].rbc11) THEN
            IF NOT cl_null(g_rbc[l_ac1].rbc11_1) THEN
               IF( g_rbc[l_ac1].rbc11_1 <> g_rbc[l_ac1].rbc11 AND g_rbc[l_ac1].rbc11_1 <> '0') THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM rap_file
                    WHERE rap01 = g_rbb.rbb01 AND rap02 = g_rbb.rbb02
                      AND rap03 = '1' AND rap04 = g_rbc[l_ac1].rbc06_1
                      AND rap09 = g_rbc[l_ac1].rbc11_1
                      AND rapplant = g_rbb.rbbplant
                   IF l_n > 0 THEN
                      IF NOT cl_confirm('art-789') THEN
                        NEXT FIELD rbc11 
                      ELSE
                        CALL t402_rbp()
                      END IF    
                  END IF
               END IF
            END  IF
            IF (g_rbc[l_ac1].rbc11_1 = g_rbc[l_ac1].rbc11 AND g_rbc[l_ac1].rbc11_1 <> '0') THEN
              CALL t402_delrbp()
            END IF  
         END IF

      BEFORE FIELD rbc08,rbc09,rbc10,rbc12,rbc13,rbc14
         IF NOT cl_null(g_rbc[l_ac1].rbc07) THEN
            CALL t402_rbc_entry(g_rbc[l_ac1].rbc07)
         END IF

      AFTER FIELD rbc08,rbc12    #特賣價
         IF g_rbc[l_ac1].rbc07 = '1' THEN   #MOD-AC0179
            LET l_price = FGL_DIALOG_GETBUFFER()
            IF l_price <= 0 THEN
               CALL cl_err('','art-180',0)
               NEXT FIELD CURRENT
            ELSE
               DISPLAY BY NAME g_rbc[l_ac1].rbc08,g_rbc[l_ac1].rbc12
            END IF
         END IF 

      AFTER FIELD rbc09,rbc13   #折扣率
         IF g_rbc[l_ac1].rbc07 = '2' THEN   #MOD-AC0179
           LET l_discount = FGL_DIALOG_GETBUFFER()
           IF l_discount < 0 OR l_discount > 100 THEN
              CALL cl_err('','atm-384',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rbc[l_ac1].rbc09,g_rbc[l_ac1].rbc13
           END IF
        END IF  

     AFTER FIELD rbc10,rbc14    #折讓額
        IF g_rbc[l_ac1].rbc07 = '3' THEN   #MOD-AC0179
           LET l_price = FGL_DIALOG_GETBUFFER()
           IF l_price <= 0 THEN
              CALL cl_err('','art-653',0)
              NEXT FIELD CURRENT
           ELSE
              DISPLAY BY NAME g_rbc[l_ac1].rbc10,g_rbc[l_ac1].rbc14
           END IF
       END IF 

     BEFORE DELETE
        IF g_rbc_t.rbc06 > 0 AND g_rbc_t.rbc06 IS NOT NULL THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           SELECT COUNT(*) INTO l_n FROM rbd_file     #lixia
               WHERE rbd01=g_rbb.rbb01 AND rbd02=g_rbb.rbb02
                 AND rbd03=g_rbb.rbb03 AND rbdplant=g_rbb.rbbplant
                 AND rbd06=g_rbc_t.rbc06
           IF l_n>0 THEN
              CALL cl_err(g_rbc_t.rbc06,'art-664',0)
              CANCEL DELETE
           ELSE 
              SELECT COUNT(*) INTO l_n FROM rap_file
               WHERE rap01=g_rbb.rbb01 AND rap02=g_rbb.rbb02 AND rap04='1'
                 AND rap03='1' AND rapplant=g_rbb.rbbplant
                 AND rap07=g_rbc_t.rbc06
              IF l_n>0 THEN
                 CALL cl_err(g_rbc_t.rbc06,'art-665',0)
                 CANCEL DELETE 
              END IF
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM rbc_file
            WHERE rbc02 = g_rbb.rbb02 AND rbc01 = g_rbb.rbb01
              AND rbc03 = g_rbb.rbb03 AND rbc04 = l_rbc04_curr
              AND rbcplant = g_rbb.rbbplant
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","rbc_file",g_rbb.rbb01,g_rbc_t.rbc06,SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK
              CANCEL DELETE 
           END IF
          #TQC-C20328 add START
           LET l_n = 0  #當使用者選擇刪除,也必須把rbp_file的相關資料刪除
           SELECT COUNT(*) INTO l_n FROM rbp_file
            WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
              AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
              AND rbp06 = '1' AND rbp07 = g_rbc[l_ac1].rbc06
              AND rbp12 = g_rbc[l_ac1].rbc11
           IF l_n > 0 THEN
              DELETE FROM rbp_file
               WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
                 AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
                 AND rbp07 = g_rbc[l_ac1].rbc06
           END IF
          #TQC-C20328 add END
           CALL t402_upd_log() 
           LET g_rec_b1=g_rec_b1-1
        END IF
        COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbc[l_ac1].* = g_rbc_t.*
              CLOSE t402_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF cl_null(g_rbc[l_ac1].rbc07) THEN
              NEXT FIELD rbc07
           END IF
              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbc[l_ac1].rbc06,-263,1)
              LET g_rbc[l_ac1].* = g_rbc_t.*
           ELSE
              UPDATE rbc_file SET rbc07  =g_rbc[l_ac1].rbc07,
                                  rbc08  =g_rbc[l_ac1].rbc08,
                                  rbc09  =g_rbc[l_ac1].rbc09,
                                  rbc10  =g_rbc[l_ac1].rbc10,
                                  rbc11  =g_rbc[l_ac1].rbc11,
                                  rbc12  =g_rbc[l_ac1].rbc12,
                                  rbc13  =g_rbc[l_ac1].rbc13,
                                  rbc14  =g_rbc[l_ac1].rbc14,
                                  rbcacti=g_rbc[l_ac1].rbcacti
               WHERE rbc02 = g_rbb.rbb02 AND rbc01=g_rbb.rbb01
                 AND rbc03 = g_rbb.rbb03 AND rbc04=l_rbc04_curr AND rbc05='1'
                 AND rbc06=g_rbc_t.rbc06 AND rbcplant = g_rbb.rbbplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rbc_file",g_rbb.rbb01,g_rbc_t.rbc06,SQLCA.sqlcode,"","",1) 
                 LET g_rbc[l_ac1].* = g_rbc_t.*
              ELSE
                 CALL t402_delrbp()  #TQC-C20378 add
                 MESSAGE 'UPDATE rbc_file O.K'
                 CALL t402_upd_log() 
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           LET l_ac1 = ARR_CURR()
          #LET l_ac1_t = l_ac1      #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbc[l_ac1].* = g_rbc_t.*
              END IF
              CLOSE t402_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF  
           LET l_ac1_t = l_ac1      #FUN-D30033 Add
           CLOSE t402_bcl
           COMMIT WORK
    END INPUT

    INPUT ARRAY g_rbk FROM s_rbk.*
          ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac3)
           END IF
           LET g_b_flag = '2'   #FUN-D30033 add

        BEFORE ROW
           LET l_ac3 = ARR_CURR()
           LET p_cmd = '' 
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK

           OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
           IF STATUS THEN
              CALL cl_err("OPEN t402_cl:", STATUS, 1)
              CLOSE t402_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t402_cl INTO g_rbb.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
              CLOSE t402_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b3 >= l_ac3 THEN
              LET g_rbk_t.* = g_rbk[l_ac3].*  #BACKUP
              LET g_rbk_o.* = g_rbk[l_ac3].*  #BACKUP
              LET l_sql = " SELECT b.rbk04,'',a.rbk06,a.rbk07,a.rbk08,a.rbk09,a.rbk10,a.rbk11,a.rbk12,a.rbk13,a.rbk14,a.rbkacti, ",
                          "                   b.rbk06,b.rbk07,b.rbk08,b.rbk09,b.rbk10,b.rbk11,b.rbk12,b.rbk13,b.rbk14,b.rbkacti  ",
                          " FROM rbk_file b LEFT OUTER JOIN rbk_file a ",
                          "          ON (b.rbk01=a.rbk01 AND b.rbk02=a.rbk02 AND b.rbk03=a.rbk03 AND b.rbk04=a.rbk04 ",
                          "              AND b.rbk07=a.rbk07 AND b.rbk08=a.rbk08 AND b.rbkplant=a.rbkplant AND b.rbk06<>a.rbk06 )",
                          "   WHERE b.rbk01 = '",g_rbb.rbb01,"'  AND b.rbk02 = '",g_rbb.rbb02,"' ",
                          "     AND b.rbk03 = '",g_rbb.rbb03,"' AND b.rbkplant='",g_rbb.rbbplant,"' ",
                          "     AND b.rbk08 ='",g_rbk_t.rbk08,"' AND b.rbk07='",g_rbk_t.rbk07,"' ",
                          "     AND b.rbk06='1' AND b.rbk05 = '1' "
              PREPARE sel_rbk_row FROM l_sql
              EXECUTE sel_rbk_row INTO l_rbk04_curr,g_rbk[l_ac3].*
              OPEN t4022_bcl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbk_t.rbk07,
                                   g_rbk_t.rbk08,g_rbb.rbbplant
              IF STATUS THEN
                 CALL cl_err("OPEN t4022_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t4022_bcl INTO l_rbk.*                      #FUN-BC0072 add
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rbk_t.rbk07,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
           END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_rbk[l_ac3].rbk14) THEN LET g_rbk[l_ac3].rbk14 = ' ' END IF 
            IF cl_null(g_rbk[l_ac3].rbk14_1) THEN LET g_rbk[l_ac3].rbk14_1 = ' ' END IF
            IF g_rbk[l_ac3].type2= '0' THEN           #不存在於原促銷單, 新增
               INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                    rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                    rbk13,rbk14,rbkacti,rbkpos,
                                    rbklegal,rbkplant)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbk04_curr,'1',
                      g_rbk[l_ac3].after2,g_rbk[l_ac3].rbk07,g_rbk[l_ac3].rbk08,
                      g_rbk[l_ac3].rbk09,g_rbk[l_ac3].rbk10,g_rbk[l_ac3].rbk11,
                      g_rbk[l_ac3].rbk12,g_rbk[l_ac3].rbk13,g_rbk[l_ac3].rbk14,
                      g_rbk[l_ac3].rbkacti,'1',g_rbb.rbblegal,g_rbb.rbbplant)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk07,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b3=g_rec_b3 + 1
                  DISPLAY g_rec_b3 TO FORMONLY.cn2
               END IF
            ELSE                                      #存在於原促銷單, 修改
               INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                    rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                    rbk13,rbk14,rbkacti,rbkpos,
                                    rbklegal,rbkplant)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbk04_curr,'1',
                      g_rbk[l_ac3].after2,g_rbk[l_ac3].rbk07,g_rbk[l_ac3].rbk08,
                      g_rbk[l_ac3].rbk09,g_rbk[l_ac3].rbk10,g_rbk[l_ac3].rbk11,
                      g_rbk[l_ac3].rbk12,g_rbk[l_ac3].rbk13,g_rbk[l_ac3].rbk14,
                      g_rbk[l_ac3].rbkacti,'1',g_rbb.rbblegal,g_rbb.rbbplant)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk07,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT                       
               ELSE
                  MESSAGE 'INSERT value.after O.K' 
               END IF
               INSERT INTO rbk_file(rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,
                                    rbk07,rbk08,rbk09,rbk10,rbk11,rbk12,
                                    rbk13,rbk14,rbkacti,rbkpos,
                                    rbklegal,rbkplant)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbk04_curr,'1',
                      g_rbk[l_ac3].before2,g_rbk[l_ac3].rbk07_1,g_rbk[l_ac3].rbk08_1,
                      g_rbk[l_ac3].rbk09_1,g_rbk[l_ac3].rbk10_1,g_rbk[l_ac3].rbk11_1,
                      g_rbk[l_ac3].rbk12_1,g_rbk[l_ac3].rbk13_1,g_rbk[l_ac3].rbk14_1,
                      g_rbk[l_ac3].rbkacti_1,'1',g_rbb.rbblegal,g_rbb.rbbplant)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbk[l_ac3].after2||g_rbk[l_ac3].rbk07,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT                       
               ELSE
                  MESSAGE 'INSERT value.before O.K' 
                  COMMIT WORK
                  LET g_rec_b3=g_rec_b3 + 1
                  DISPLAY g_rec_b3 TO FORMONLY.cn2
               END IF
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rbk[l_ac3].* TO NULL 
            LET g_rbk[l_ac3].type2 = '0'      
            LET g_rbk[l_ac3].before2 = '0'
            LET g_rbk[l_ac3].after2 = '1'  
            LET g_rbk[l_ac3].rbkacti = 'Y'
            DISPLAY BY NAME g_rbk[l_ac3].type2,g_rbk[l_ac3].before2,g_rbk[l_ac3].after2,g_rbk[l_ac3].rbkacti
            IF l_ac3 = 1 THEN
               SELECT MIN(rbc06) INTO g_rbk[l_ac3].rbk07 FROM rbc_file
                 WHERE rbc01=g_rbb.rbb01 AND rbc02=g_rbb.rbb02 
                   AND rbc03=g_rbb.rbb03 AND rbcplant=g_rbb.rbbplant
            ELSE
               LET g_rbk[l_ac3].rbk07 = g_rbk[l_ac3-1].rbk07
            END IF
            LET g_rbk_t.* = g_rbk[l_ac3].*         #新輸入資料
            LET g_rbk_o.* = g_rbk[l_ac3].*         #新輸入資料

            SELECT MAX(rbk04) INTO l_rbk04_curr FROM rbk_file 
             WHERE rbk01=g_rbb.rbb01
               AND rbk02=g_rbb.rbb02 
               AND rbk03=g_rbb.rbb03
               AND rbk05 = 1 
               AND rbkplant=g_rbb.rbbplant
              IF cl_null(l_rbk04_curr) OR l_rbk04_curr=0 THEN
                 LET l_rbk04_curr = 1
              ELSE 
                 LET l_rbk04_curr = l_rbk04_curr + 1
              END IF                
            CALL cl_show_fld_cont()
            NEXT FIELD rbk07 

       AFTER FIELD rbk07
          IF NOT cl_null(g_rbk[l_ac3].rbk07) THEN
             IF p_cmd = 'a' OR
               (p_cmd = 'u' AND g_rbk[l_ac3].rbk07<> g_rbk[l_ac3].rbk07)THEN
                IF NOT cl_null(g_rbk[l_ac3].rbk08) THEN
                   LET l_n = 0 
                   SELECT COUNT(*) INTO l_n FROM rbk_file
                     WHERE rbk01 = g_rbb.rbb01 AND rbk02 = g_rbb.rbb02
                       AND rbk03 = g_rbb.rbb03 AND rbk05 = '1'
                       AND rbk07 = g_rbk[l_ac3].rbk07
                       AND rbk08 = g_rbk[l_ac3].rbk08
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                      NEXT FIELD rbk07
                   END IF 
                END IF 
             END IF
          END IF

       AFTER FIELD rbk08 
          IF NOT cl_null(g_rbk[l_ac3].rbk08) THEN
             IF NOT cl_null(g_rbk[l_ac3].rbk07) THEN
                IF p_cmd = 'a' OR
                   (p_cmd = 'u' AND g_rbk[l_ac3].rbk08 <> g_rbk_t.rbk08) THEN
                   IF NOT cl_null(g_rbk[l_ac3].rbk07) THEN
                      LET l_n = 0
                       SELECT COUNT(*) INTO l_n FROM rbk_file
                        WHERE rbk01 = g_rbb.rbb01 AND rbk02 = g_rbb.rbb02
                          AND rbk03 = g_rbb.rbb03 AND rbk05 = '1'
                          AND rbk07 = g_rbk[l_ac3].rbk07
                          AND rbk08 = g_rbk[l_ac3].rbk08
                      IF l_n > 0 THEN
                         CALL cl_err('','-239',0)
                         NEXT FIELD rbk08
                      END IF
                   END IF
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM rak_file
                      WHERE rak01 = g_rbb.rbb01 AND rak02 = g_rbb.rbb02
                        AND rak03 = '1' AND rak04 = g_rbk[l_ac3].rbk07
                        AND rak05 = g_rbk[l_ac3].rbk08 AND rakplant = g_rbb.rbbplant
                   IF l_n = 0 OR cl_null(l_n) THEN       #未存在於原本促銷單中,新增
                      IF NOT cl_confirm('art-677') THEN   #確定新增?
                         NEXT FIELD rbk08
                      ELSE
                         CALL t402_b3_init()
                     END IF
                   ELSE                                  #存在於原本促銷單中,修改
                      IF NOT cl_confirm('art-676') THEN  #確定修改? 
                         NEXT FIELD rbk08
                      ELSE
                         CALL t402_b3_find()   
                      END IF 
                   END IF
                END IF
             END IF
          END IF

       AFTER FIELD rbk09
          IF NOT cl_null(g_rbk[l_ac3].rbk09) THEN
            
             IF NOT cl_null(g_rbk[l_ac3].rbk10) THEN
                IF g_rbk[l_ac3].rbk09 > g_rbk[l_ac3].rbk10 THEN
                   CALL cl_err('','art-201',0)
                   NEXT FIELD rbk09
                END IF
             END IF
          END IF

       AFTER FIELD rbk10
          IF NOT cl_null(g_rbk[l_ac3].rbk10) THEN
             IF NOT cl_null(g_rbk[l_ac3].rbk09) THEN
                IF g_rbk[l_ac3].rbk09 > g_rbk[l_ac3].rbk10 THEN
                   CALL cl_err('','art-201',0)
                   NEXT FIELD rbk10
                END IF
             END IF
          END IF

       AFTER FIELD rbk11
         IF NOT cl_null(g_rbk[l_ac3].rbk11) THEN
            IF p_cmd = "a" OR
                   (p_cmd = "u" AND g_rbk[l_ac3].rbk11<>g_rbk_t.rbk11) THEN
               CALL t402_chktime(g_rbk[l_ac3].rbk11) RETURNING l_time1
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rbk11
               ELSE
                 IF NOT cl_null(g_rbk[l_ac3].rbk12) THEN
                    CALL t402_chktime(g_rbk[l_ac3].rbk12) RETURNING l_time2
                    IF l_time1>=l_time2 THEN
                       CALL cl_err('','art-207',0)
                       NEXT FIELD rbk11
                    END IF
                 END IF
               END IF
             END IF
         END IF
        
       AFTER FIELD rbk12
         IF NOT cl_null(g_rbk[l_ac3].rbk12) THEN
             IF p_cmd = "a" OR
                    (p_cmd = "u" AND g_rbk[l_ac3].rbk12<>g_rbk_t.rbk12) THEN
                 CALL t402_chktime(g_rbk[l_ac3].rbk12) RETURNING l_time2
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rbk12
                 ELSE
                    IF NOT cl_null(g_rbk[l_ac3].rbk11) THEN
                       CALL t402_chktime(g_rbk[l_ac3].rbk11) RETURNING l_time1
                       IF l_time1>=l_time2 THEN
                          CALL cl_err('','art-207',0)
                          NEXT FIELD rbk12
                       END IF
                    END IF
                 END IF
             END IF
          END IF

       ON CHANGE rbk13
          CALL t402_set_entry_rbk()

       ON CHANGE rbk14
          CALL t402_set_entry_rbk()

       BEFORE DELETE
          IF g_rbk_t.rbk07 > 0 AND NOT cl_null(g_rbk_t.rbk07) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM rbk_file
              WHERE rbk02 = g_rbb.rbb02 AND rbk01 = g_rbb.rbb01
                AND rbk03 = g_rbb.rbb03 AND rbk04 = l_rbk04_curr
                AND rbk05 = '1' 
                AND rbkplant = g_rbb.rbbplant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rbk_file",g_rbb.rbb01,g_rbk_t.rbk07,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE 
             END IF
             CALL t402_upd_log() 
             LET g_rec_b3=g_rec_b3-1
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rbk[l_ac3].* = g_rbk_t.*
             CLOSE t4022_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF
          IF cl_null(g_rbk[l_ac3].rbk07) THEN
             NEXT FIELD rbk07
          END IF
             
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_rbk[l_ac3].rbk07,-263,1)
             LET g_rbk[l_ac3].* = g_rbk_t.*
          ELSE
             UPDATE rbk_file SET rbk07  =g_rbk[l_ac3].rbk07,
                                 rbk08  =g_rbk[l_ac3].rbk08,
                                 rbk09  =g_rbk[l_ac3].rbk09,
                                 rbk10  =g_rbk[l_ac3].rbk10,
                                 rbk11  =g_rbk[l_ac3].rbk11,
                                 rbk12  =g_rbk[l_ac3].rbk12,
                                 rbk13  =g_rbk[l_ac3].rbk13,
                                 rbk14  =g_rbk[l_ac3].rbk14,
                                 rbkacti=g_rbk[l_ac3].rbkacti
              WHERE rbk02 = g_rbb.rbb02 AND rbk01=g_rbb.rbb01
                AND rbk03 = g_rbb.rbb03 AND rbk04=l_rbk04_curr AND rbk05='1'
                AND rbk06= '1' AND rbkplant = g_rbb.rbbplant
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","rbk_file",g_rbb.rbb01,g_rbk_t.rbk07,SQLCA.sqlcode,"","",1) 
                LET g_rbk[l_ac3].* = g_rbk_t.*
             ELSE
                MESSAGE 'UPDATE rbk_file O.K'
                CALL t402_upd_log() 
                COMMIT WORK
             END IF
          END IF

       AFTER ROW
          LET l_ac3 = ARR_CURR()
         #LET l_ac3_t = l_ac3     #FUN-D30033 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_rbk[l_ac3].* = g_rbk_t.*
             END IF
             CLOSE t4022_bcl
             ROLLBACK WORK
             EXIT DIALOG 
          END IF  
          LET l_ac3_t = l_ac3     #FUN-D30033 Add
          CLOSE t4022_bcl
          COMMIT WORK

    END INPUT


    INPUT ARRAY g_rbd FROM s_rbd.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac2)
           END IF
           LET g_b_flag = '3'   #FUN-D30033 add
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
          #CALL t402_rbd07_chk()   #FUN-C30154 mark
           BEGIN WORK

           OPEN t402_cl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant
           IF STATUS THEN
              CALL cl_err("OPEN t402_cl:", STATUS, 1)
              CLOSE t402_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t402_cl INTO g_rbb.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
              CLOSE t402_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u'
              LET g_rbd_t.* = g_rbd[l_ac2].*  #BACKUP
              LET g_rbd_o.* = g_rbd[l_ac2].*  #BACKUP
              LET l_sql = " SELECT b.rbd04,'',a.rbd05,a.rbd06,a.rbd07,a.rbd08,'',a.rbd09,'',a.rbdacti, ",
                          "                   b.rbd05,b.rbd06,b.rbd07,b.rbd08,'',b.rbd09,'',b.rbdacti  ",
                          "   FROM rbd_file b LEFT OUTER JOIN rbd_file a",
                          "        ON (b.rbd01=a.rbd01 AND b.rbd02=a.rbd02 AND b.rbd03=a.rbd03 AND b.rbd04=a.rbd04 ",
                          "            AND b.rbd06=a.rbd06 AND b.rbd07=a.rbd07 AND b.rbdplant=a.rbdplant AND b.rbd05<>a.rbd05 ) ",   #lixia
                          "  WHERE b.rbd01 = '",g_rbb.rbb01,"'  AND b.rbd02 = '",g_rbb.rbb02,"'",
                          "    AND b.rbd03 ='",g_rbb.rbb03,"'   AND b.rbdplant='",g_rbb.rbbplant,"'",
                          "    AND b.rbd06 ='",g_rbd_t.rbd06,"' AND b.rbd07='",g_rbd_t.rbd07,"' ",
                          "    AND b.rbd05='1'"
              PREPARE sel_rbd_row FROM l_sql
              EXECUTE sel_rbd_row INTO l_rbd04_curr,g_rbd[l_ac2].*
              OPEN t4021_bcl USING g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,g_rbb.rbbplant,
                                   g_rbd_t.rbd06,g_rbd_t.rbd07
              IF STATUS THEN
                 CALL cl_err("OPEN t4021_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t4021_bcl INTO l_rbd.*                      #FUN-BC0072 add
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rbd_t.rbd06,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t402_rbd07()   
                 CALL t402_rbd08('d',l_ac2)
                 CALL t402_rbd09('d')
              END IF
           END IF 

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_rbd[l_ac2].type1= '0' THEN
               INSERT INTO rbd_file(rbd01,rbd02,rbd03,rbd04,rbd05,
                                    rbd06,rbd07,rbd08,rbd09, 
                                    rbdacti,rbdplant,rbdlegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbd04_curr,g_rbd[l_ac2].after1,
                      g_rbd[l_ac2].rbd06,g_rbd[l_ac2].rbd07,g_rbd[l_ac2].rbd08,g_rbd[l_ac2].rbd09, 
                      g_rbd[l_ac2].rbdacti,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbd[l_ac2].after1||g_rbd[l_ac2].rbd06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b2=g_rec_b2+1
                 #DISPLAY g_rec_b2 TO FORMONLY.cn2
                  DISPLAY g_rec_b2 TO FORMONLY.cn3 #FUN-BC0072 add
               END IF
            ELSE
               INSERT INTO rbd_file(rbd01,rbd02,rbd03,rbd04,rbd05,
                                    rbd06,rbd07,rbd08,rbd09, 
                                    rbdacti,rbdplant,rbdlegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbd04_curr,g_rbd[l_ac2].after1,
                      g_rbd[l_ac2].rbd06,g_rbd[l_ac2].rbd07,g_rbd[l_ac2].rbd08,g_rbd[l_ac2].rbd09, 
                      g_rbd[l_ac2].rbdacti,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbd[l_ac2].after1||g_rbd[l_ac2].rbd06,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT 
               ELSE
                  MESSAGE 'INSERT value.after O.K' 
               END IF
               INSERT INTO rbd_file(rbd01,rbd02,rbd03,rbd04,rbd05,
                                    rbd06,rbd07,rbd08,rbd09, 
                                    rbdacti,rbdplant,rbdlegal)
               VALUES(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,l_rbd04_curr,g_rbd[l_ac2].before1,
                      g_rbd[l_ac2].rbd06_1,g_rbd[l_ac2].rbd07_1,g_rbd[l_ac2].rbd08_1,g_rbd[l_ac2].rbd09_1, 
                      g_rbd[l_ac2].rbdacti_1,g_rbb.rbbplant,g_rbb.rbblegal) 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rbd_file",g_rbb.rbb02||g_rbd[l_ac2].before1||g_rbd[l_ac2].rbd06_1,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT               
               ELSE
                  MESSAGE 'INSERT value.before O.K'
                  COMMIT WORK
                  LET g_rec_b2=g_rec_b2+1
                 #DISPLAY g_rec_b2 TO FORMONLY.cn2
                  DISPLAY g_rec_b2 TO FORMONLY.cn3 #FUN-BC0072 add
               END IF
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rbd[l_ac2].* TO NULL 
            LET g_rbd[l_ac2].type1 = '0'      
            LET g_rbd[l_ac2].before1 = '0'
            LET g_rbd[l_ac2].after1  = '1'  
            LET g_rbd[l_ac2].rbdacti = 'Y' 
            LET g_rbd_t.* = g_rbd[l_ac2].*         #新輸入資料  #FUN-C30154 add
            LET g_rbd_o.* = g_rbd[l_ac2].*         #新輸入資料  #FUN-C30154 add
           SELECT MIN(rbc06) INTO g_rbd[l_ac2].rbd06 FROM rbc_file
            WHERE rbc01=g_rbb.rbb01 AND rbc02=g_rbb.rbb02 
              AND rbc03=g_rbb.rbb03 AND rbcplant=g_rbb.rbbplant
           #LET g_rbd_t.* = g_rbd[l_ac2].*         #新輸入資料  #FUN-C30154 mark
           #LET g_rbd_o.* = g_rbd[l_ac2].*         #新輸入資料  #FUN-C30154 mark
            
            SELECT MAX(rbd04)+1 INTO l_rbd04_curr 
              FROM rbd_file
             WHERE rbd01=g_rbb.rbb01
               AND rbd02=g_rbb.rbb02 
               AND rbd03=g_rbb.rbb03 
               AND rbdplant=g_rbb.rbbplant
              IF l_rbd04_curr IS NULL OR l_rbd04_curr=0 THEN
                 LET l_rbd04_curr = 1
              END IF                
           CALL cl_show_fld_cont()
           NEXT FIELD rbd06 

      AFTER FIELD rbd06
         IF NOT cl_null(g_rbd[l_ac2].rbd06) THEN
            IF cl_null(g_rbd_o.rbd06) OR
               (g_rbd[l_ac2].rbd06 != g_rbd_o.rbd06 ) THEN
               CALL t402_rbd06()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbd[l_ac2].rbd06,g_errno,0)
                  LET g_rbd[l_ac2].rbd06 = g_rbd_o.rbd06
                  NEXT FIELD rbd06
               END IF
               LET l_n = 0
               IF NOT cl_null(g_rbd[l_ac2].rbd07) AND NOT cl_null(g_rbd[l_ac2].rbd08) THEN
                  SELECT COUNT(*) INTO l_n FROM rbd_file
                     WHERE rbd01 = g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                       AND rbd03 = g_rbb.rbb03 AND rbd06 = g_rbd[l_ac2].rbd06
                       AND rbd07 = g_rbd[l_ac2].rbd07
                       AND rbd08 = g_rbd[l_ac2].rbd08
                  IF l_n > 0 THEN
                     CALL cl_err('','-239',0)
                     NEXT FIELD rbd06
                  END IF
               END IF
               LET g_n = 0       
               IF NOT cl_null(g_rbd[l_ac2].rbd07) AND NOT cl_null(g_rbd[l_ac2].rbd08) THEN  
                  CALL t402_chk_rbd()  #判斷是否在原促銷單中存在
                  LET l_n= g_n
                  IF l_n < 1  THEN
                     IF NOT cl_confirm('art-678') THEN
                        NEXT FIELD rbd06
                     ELSE
                        CALL t402_b2_init()
                     END IF
                  ELSE
                     IF NOT cl_confirm('art-679') THEN
                        NEXT FIELD rbd06
                     ELSE
                        CALL t402_b2_find()   
                     END IF           
                  END IF  
               END IF  
           END IF
         END IF 

      BEFORE FIELD rbd07 
         IF NOT cl_null(g_rbd[l_ac2].rbd06) THEN
            IF cl_null(g_rbd_o.rbd06) OR  #FUN-C30154 add
               (g_rbd[l_ac2].rbd06 != g_rbd_o.rbd06 ) THEN  #FUN-C30154 add
               CALL t402_rbd07_chk()
            END IF   #FUN-C30154 add
         END IF

      AFTER FIELD rbd07
         IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
            IF cl_null(g_rbd_o.rbd07) OR
               (g_rbd[l_ac2].rbd07 != g_rbd_o.rbd07 ) THEN
               LET l_n = 0
               IF NOT cl_null(g_rbd[l_ac2].rbd06) AND NOT cl_null(g_rbd[l_ac2].rbd07) THEN
                  SELECT COUNT(*) INTO l_n FROM rbd_file
                     WHERE rbd01 = g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                       AND rbd03 = g_rbb.rbb03 AND rbd06 = g_rbd[l_ac2].rbd06
                       AND rbd07 = g_rbd[l_ac2].rbd07
                       AND rbd08 = g_rbd[l_ac2].rbd08
                  IF l_n > 0 THEN
                     CALL cl_err('','-239',0)
                     NEXT FIELD rbd07
                  END IF
               END IF
               IF NOT cl_null(g_rbd[l_ac2].rbd06) THEN
                  LET g_n = 0
                  IF NOT cl_null(g_rbd[l_ac2].rbd06) AND NOT cl_null(g_rbd[l_ac2].rbd08) THEN
                     CALL t402_chk_rbd()  ##判斷是否在原促銷單中存在
                     LET l_n = g_n
                     IF l_n=0 THEN 
                        IF NOT cl_confirm('art-678') THEN    #確定新增?
                           NEXT FIELD rbd07
                        ELSE
                           CALL t402_b2_init()
                        END IF
                     ELSE
                        IF NOT cl_confirm('art-679') THEN    #確定修改?
                           NEXT FIELD rbd07
                        ELSE
                           CALL t402_b2_find()   
                        END IF           
                     END IF
                  END IF
               END IF  
               CALL t402_rbd07() 
            END IF  
         END IF 

      ON CHANGE rbd07
         IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
            CALL t402_rbd07()   
            LET g_rbd[l_ac2].rbd08=NULL
            LET g_rbd[l_ac2].rbd08_desc=NULL
            LET g_rbd[l_ac2].rbd09=NULL
            LET g_rbd[l_ac2].rbd09_desc=NULL

            DISPLAY BY NAME g_rbd[l_ac2].rbd08,g_rbd[l_ac2].rbd08_desc
            DISPLAY BY NAME g_rbd[l_ac2].rbd09,g_rbd[l_ac2].rbd09_desc
         END IF
  
      BEFORE FIELD rbd08,rbd09
         IF NOT cl_null(g_rbd[l_ac2].rbd07) THEN
            CALL t402_rbd07()   
         END IF

      AFTER FIELD rbd08
         IF NOT cl_null(g_rbd[l_ac2].rbd08) THEN
            IF g_rbd[l_ac2].rbd07 = '01' THEN #FUN-AB0033 add
               IF NOT s_chk_item_no(g_rbd[l_ac2].rbd08,"") THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD rbd08
               END IF
            END IF 
            IF g_rbd_o.rbd08 IS NULL OR
               (g_rbd[l_ac2].rbd08 != g_rbd_o.rbd08 ) THEN
               CALL t402_rbd08('a',l_ac2) 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbd[l_ac2].rbd08,g_errno,0)
                  LET g_rbd[l_ac2].rbd08 = g_rbd_o.rbd08
                  NEXT FIELD rbd08
               END IF
               LET l_n = 0
               IF NOT cl_null(g_rbd[l_ac2].rbd07) AND NOT cl_null(g_rbd[l_ac2].rbd08) THEN
                  SELECT COUNT(*) INTO l_n FROM rbd_file
                     WHERE rbd01 = g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                       AND rbd03 = g_rbb.rbb03 AND rbd06 = g_rbd[l_ac2].rbd06
                       AND rbd07 = g_rbd[l_ac2].rbd07
                       AND rbd08 = g_rbd[l_ac2].rbd08
                  IF l_n > 0 THEN
                     CALL cl_err('','-239',0)
                     NEXT FIELD rbd08
                  END IF
               END IF
            END IF 
            LET g_n  = 0 
            IF NOT cl_null(g_rbd[l_ac2].rbd07) AND NOT cl_null(g_rbd[l_ac2].rbd06) THEN
               CALL t402_chk_rbd()  #判斷是否在原促銷單中存在
               LET l_n = g_n
               IF l_n=0 THEN
                  IF NOT cl_confirm('art-678') THEN  #確定新增? 
                     NEXT FIELD rbd08
                  ELSE
                     CALL t402_b2_init()
                     LET l_n = 0 
                     SELECT COUNT(*) INTO l_n FROM rbd_file
                       WHERE rbd01 = g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                         AND rbd03 = g_rbb.rbb03 AND rbd05 = '1'
                         AND rbd06 = g_rbd[l_ac2].rbd06 
                         AND rbd07 = g_rbd[l_ac2].rbd07
                         AND rbd08 = g_rbd[l_ac2].rbd08
                         AND rbdplant = g_rbb.rbbplant
                     IF l_n > 0 THEN
                        CALL cl_err('','',0)
                        NEXT FIELD rbd08
                     END IF
                  END IF
               ELSE
                  IF NOT cl_confirm('art-679') THEN  #確定修改? 
                     NEXT FIELD rbd07
                  ELSE
                     CALL t402_b2_find()
                  END IF
               END IF
            END IF 
         END IF  

      AFTER FIELD rbd09
         IF NOT cl_null(g_rbd[l_ac2].rbd09) THEN
            IF g_rbd_o.rbd09 IS NULL OR
               (g_rbd[l_ac2].rbd09 != g_rbd_o.rbd09 ) THEN
               CALL t402_rbd09('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rbd[l_ac2].rbd09,g_errno,0)
                  LET g_rbd[l_ac2].rbd09 = g_rbd_o.rbd09
                  NEXT FIELD rbd09
               END IF
            END IF  
         END IF

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rbd_t.rbd06 > 0 AND g_rbd_t.rbd06 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rbd_file
               WHERE rbd02 = g_rbb.rbb02 AND rbd01 = g_rbb.rbb01
                 AND rbd03 = g_rbb.rbb03 AND rbd04 = l_rbd04_curr
                 AND rbdplant = g_rbb.rbbplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rbd_file",g_rbb.rbb02,g_rbd_t.rbd06,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1     
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rbd[l_ac2].* = g_rbd_t.*
              CLOSE t4021_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rbd[l_ac2].rbd06,-263,1)
              LET g_rbd[l_ac2].* = g_rbd_t.*
           ELSE
              IF g_rbd[l_ac2].rbd06<>g_rbd_t.rbd06 OR
                 g_rbd[l_ac2].rbd07<>g_rbd_t.rbd07 THEN
                 SELECT COUNT(*) INTO l_n FROM rbd_file
                  WHERE rbd01 =g_rbb.rbb01 AND rbd02 = g_rbb.rbb02
                    AND rbd03=g_rbb.rbb03
                    AND rbd06 = g_rbd[l_ac2].rbd06 
                    AND rbd07 = g_rbd[l_ac2].rbd07
                    AND rbdplant = g_rbb.rbbplant
                 IF l_n>0 THEN 
                    CALL cl_err('',-239,0)
                    NEXT FIELD rbd06
                 END IF
              END IF
              UPDATE rbd_file SET rbd06=g_rbd[l_ac2].rbd06,
                                  rbd07=g_rbd[l_ac2].rbd07,
                                  rbd08=g_rbd[l_ac2].rbd08,
                                  rbd09=g_rbd[l_ac2].rbd09,
                                  rbdacti=g_rbd[l_ac2].rbdacti
               WHERE rbd02 = g_rbb.rbb02 AND rbd01=g_rbb.rbb01 AND rbd03=g_rbb.rbb03 
                 AND rbd04 = l_rbd04_curr AND rbd05='1'
                 AND rbd06=g_rbd_t.rbd06 AND rbd07=g_rbd_t.rbd07 AND rbdplant = g_rbb.rbbplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rbd_file",g_rbb.rbb02,g_rbd_t.rbd06,SQLCA.sqlcode,"","",1) 
                 LET g_rbd[l_ac2].* = g_rbd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac2 = ARR_CURR()
          #LET l_ac2_t = l_ac2      #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rbd[l_ac2].* = g_rbd_t.*
              END IF
              CLOSE t4021_bcl
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           LET l_ac2_t = l_ac2      #FUN-D30033 Add
           CLOSE t4021_bcl
           COMMIT WORK

    END INPUT

    #FUN-D30033--add--begin--
    BEFORE DIALOG
       CASE g_b_flag
            WHEN '1' NEXT FIELD rbc06 
            WHEN '2' NEXT FIELD rbk07
            WHEN '3' NEXT FIELD rbd06
       END CASE
    #FUN-D30033--add--end---

    ON ACTION ACCEPT
       ACCEPT DIALOG

    ON ACTION CANCEL
      #TQC-C20328 add START
       LET l_n = 0  #當使用者選擇放棄,也必須把rbp_file的相關資料刪除 
       SELECT COUNT(*) INTO l_n FROM rbc_file 
         WHERE rbc01 = g_rbb.rbb01 AND rbc02 = g_rbb.rbb02 
           AND rbc03 = g_rbb.rbb03 AND rbc06 = g_rbc[l_ac1].rbc06
           AND rbc11 <> '0' AND rbc05 = '1'
       IF l_n = 0 THEN
          LET l_n = 0 
          SELECT COUNT(*) INTO l_n FROM rbp_file 
           WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02 
             AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
             AND rbp06 = '1' AND rbp07 = g_rbc[l_ac1].rbc06
             AND rbp12 = g_rbc[l_ac1].rbc11
          IF l_n > 0 THEN
             DELETE FROM rbp_file 
              WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02 
                AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
                AND rbp07 = g_rbc[l_ac1].rbc06
          END IF
       END IF
      #TQC-C20328 add END
       #FUN-D30033--add--str--
       IF g_b_flag = '1' THEN
          IF p_cmd = 'u' THEN
             LET g_rbc[l_ac1].* = g_rbc_t.*
          ELSE
             CALL g_rbc.deleteElement(l_ac1)
             IF g_rec_b1 != 0 THEN
                LET g_action_choice = "detail"
             END IF
          END IF
          CLOSE t402_bcl
          ROLLBACK WORK
       END IF
       IF g_b_flag = '2' THEN
          IF p_cmd = 'u' THEN
             LET g_rbk[l_ac3].* = g_rbk_t.*
          ELSE
             CALL g_rbk.deleteElement(l_ac3)
             IF g_rec_b3 != 0 THEN
                LET g_action_choice = "detail"
             END IF
          END IF
          CLOSE t4022_bcl
          ROLLBACK WORK
       END IF
       IF g_b_flag = '3' THEN
          IF p_cmd = 'u' THEN
             LET g_rbd[l_ac2].* = g_rbd_t.*
          ELSE
             CALL g_rbd.deleteElement(l_ac2)
             IF g_rec_b2 != 0 THEN
                LET g_action_choice = "detail"
             END IF
          END IF
          CLOSE t4021_bcl
          ROLLBACK WORK
       END IF
       #FUN-D30033--add--end--
       EXIT DIALOG

    ON ACTION alter_memberlevel    #會員等級促銷
       IF NOT cl_null(g_rbb.rbb02) THEN
          IF NOT cl_null(g_rbc[l_ac1].rbc11) AND g_rbc[l_ac1].rbc11 <> '0' THEN
             #CALl t402_2(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf,'')  #FUN-BC0072 mark
              CALl t402_2(g_rbb.rbb01,g_rbb.rbb02,g_rbb.rbb03,'1',g_rbb.rbbplant,g_rbb.rbbconf,
                          g_rbc[l_ac1].rbc07,g_rbc[l_ac1].rbc11,g_rbc[l_ac1].rbc06)  #FUN-BC0072 add  #TQC-C20328 add rbc06
          END IF
       ELSE
          CALL cl_err('',-400,0)
       END IF
    
    ON ACTION CONTROLO
       IF INFIELD(rbc06) AND l_ac1 > 1 THEN
          LET g_rbc[l_ac1].* = g_rbc[l_ac1-1].*
          LET g_rec_b1 = g_rec_b1+1
          NEXT FIELD rbc06
       END IF
    
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
    
    ON ACTION CONTROLG
       CALL cl_cmdask()
    
    ON ACTION controlp
       CASE
          WHEN INFIELD(rbd08)
             CALL cl_init_qry_var()
             CASE g_rbd[l_ac2].rbd07
    
                WHEN '01'  
                      CALL q_sel_ima(FALSE, "q_ima","",g_rbd[l_ac2].rbd08,"","","","","",'' )
                        RETURNING g_rbd[l_ac2].rbd08                                         
                WHEN '02'  
                   LET g_qryparam.form ="q_oba01"
                WHEN '03'  
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '1'
                WHEN '04'  
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '2'
                WHEN '05'  
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '3'
                WHEN '06' 
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '4'
                WHEN '07' 
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '5'
                WHEN '08'  
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '6'
                WHEN '09' 
                   LET g_qryparam.form ="q_tqa"
                   LET g_qryparam.arg1 = '27'
             END CASE
             IF g_rbd[l_ac2].rbd07 != '01' THEN                         
                LET g_qryparam.default1 = g_rbd[l_ac2].rbd08
                CALL cl_create_qry() RETURNING g_rbd[l_ac2].rbd08
             END IF    
             CALL t402_rbd08('d',l_ac2)
             NEXT FIELD rbd08
          WHEN INFIELD(rbd09)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gfe02"
             SELECT DISTINCT ima25
               INTO l_ima25
               FROM ima_file
              WHERE ima01=g_rbd[l_ac2].rbd08  
             LET g_qryparam.arg1 = l_ima25
             LET g_qryparam.default1 = g_rbd[l_ac2].rbd09
             CALL cl_create_qry() RETURNING g_rbd[l_ac2].rbd09
             CALL t402_rbd09('d')
             NEXT FIELD rbd09
          OTHERWISE EXIT CASE
        END CASE
    
    ON ACTION CONTROLF
       CALL cl_set_focus_form(ui.Interface.getRootNode()) 
          RETURNING g_fld_name,g_frm_name
       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
    
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE DIALOG 
    
    ON ACTION about
       CALL cl_about()
    
    ON ACTION HELP
       CALL cl_show_help()
    
    ON ACTION controls         
       CALL cl_set_head_visible("","AUTO")


    END DIALOG
    
    CALL t402_upd_log()
    CLOSE t402_bcl
    CLOSE t4021_bcl
    COMMIT WORK

    CALL t402_b1_fill(g_wc1)          #單身1
    CALL t402_b2_fill(g_wc2)          #單身2
    CALL t402_b3_fill(g_wc3)          #單身3

END FUNCTION 

FUNCTION t402_b3_fill(p_wc)
DEFINE p_wc            STRING
DEFINE l_sql           STRING

   CALL t402_rbd07_combo()  #FUN-C30154 add   #顯示之前先將下拉選項重新產生一遍,避免名稱不顯示的問題

   LET g_sql = " SELECT '',a.rbk06,a.rbk07,a.rbk08,a.rbk09,a.rbk10,a.rbk11,a.rbk12,a.rbk13,a.rbk14,a.rbkacti, ",
               "           b.rbk06,b.rbk07,b.rbk08,b.rbk09,b.rbk10,b.rbk11,b.rbk12,b.rbk13,b.rbk14,b.rbkacti  ",
               " FROM rbk_file b LEFT OUTER JOIN rbk_file a ",
               "          ON (b.rbk01=a.rbk01 AND b.rbk02=a.rbk02 AND b.rbk03=a.rbk03 AND b.rbk04=a.rbk04 ",
               "              AND b.rbk07=a.rbk07 AND b.rbk08=a.rbk08 AND b.rbkplant=a.rbkplant AND b.rbk06<>a.rbk06 )",
               "   WHERE b.rbk01 = '",g_rbb.rbb01 CLIPPED ,"'  AND b.rbk02 = '",g_rbb.rbb02 CLIPPED ,"' ",
               "     AND b.rbk03 = '",g_rbb.rbb03 CLIPPED ,"' AND b.rbkplant='",g_rbb.rbbplant CLIPPED ,"' ",
               "     AND b.rbk06='1' AND b.rbk05 = '1'"
   IF NOT cl_null(p_wc) THEN
      LET l_sql = l_sql ," AND ", p_wc
   END IF 

   PREPARE t402_b3_prepare FROM g_sql                     #預備一下
   DECLARE rbk_cs CURSOR FOR t402_b3_prepare
   CALL g_rbk.clear()
   LET g_rec_b3 = 0
   LET g_cnt = 1

   FOREACH rbk_cs INTO g_rbk[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF g_rbk[g_cnt].before2='0' THEN
         LET g_rbk[g_cnt].type2='1'
      ELSE 
         LET g_rbk[g_cnt].type2='0'
      END IF

      LET g_cnt = g_cnt + 1 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_rbk.deleteElement(g_cnt)
   LET g_rec_b3 = g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION

FUNCTION t402_b3_init() 

   LET g_rbk[l_ac3].rbk09 = g_today        #促銷開始日期
   LET g_rbk[l_ac3].rbk11 = '00:00:00'     #促銷開始時間
   LET g_rbk[l_ac3].rbk10 = g_today        #促銷結束日期
   LET g_rbk[l_ac3].rbk12 = '23:59:59'     #促銷結束時間
   LET g_rbk[l_ac3].rbkacti = 'Y'

   LET g_rbk[l_ac3].type2    ='0'
   LET g_rbk[l_ac3].before2  =' '
   LET g_rbk[l_ac3].after2   ='1'
   CALL t402_set_entry_rbk()

END FUNCTION

FUNCTION t402_b3_find()

   LET g_rbk[l_ac3].type2  ='1'
   LET g_rbk[l_ac3].before2 ='0'
   LET g_rbk[l_ac3].after2 ='1'

   SELECT rak04, rak05,rak06, rak07, rak08, rak09, rak10, rak11, rakacti 
         INTO g_rbk[l_ac3].rbk07_1, g_rbk[l_ac3].rbk08_1,
              g_rbk[l_ac3].rbk09_1, g_rbk[l_ac3].rbk10_1, 
              g_rbk[l_ac3].rbk11_1, g_rbk[l_ac3].rbk12_1,
              g_rbk[l_ac3].rbk13_1, g_rbk[l_ac3].rbk14_1, 
              g_rbk[l_ac3].rbkacti_1
     FROM rak_file
         WHERE rak01 = g_rbb.rbb01 AND rak02 = g_rbb.rbb02
           AND rak03 = '1' AND rak04 = g_rbk[l_ac3].rbk07
           AND rak05 = g_rbk[l_ac3].rbk08 AND rakplant = g_rbb.rbbplant

   LET g_rbk[l_ac3].rbk09 = g_rbk[l_ac3].rbk09_1
   LET g_rbk[l_ac3].rbk10 = g_rbk[l_ac3].rbk10_1
   LET g_rbk[l_ac3].rbk11 = g_rbk[l_ac3].rbk11_1
   LET g_rbk[l_ac3].rbk12 = g_rbk[l_ac3].rbk12_1
   LET g_rbk[l_ac3].rbk13 = g_rbk[l_ac3].rbk13_1
   LET g_rbk[l_ac3].rbk14 = g_rbk[l_ac3].rbk14_1
   LET g_rbk[l_ac3].rbkacti = g_rbk[l_ac3].rbkacti_1

   DISPLAY BY NAME g_rbk[l_ac3].rbk07_1, g_rbk[l_ac3].rbk08_1,
                   g_rbk[l_ac3].rbk09_1, g_rbk[l_ac3].rbk10_1,
                   g_rbk[l_ac3].rbk11_1, g_rbk[l_ac3].rbk12_1, 
                   g_rbk[l_ac3].rbk13_1, g_rbk[l_ac3].rbk14_1,
                   g_rbk[l_ac3].rbkacti_1

   DISPLAY BY NAME g_rbk[l_ac3].rbk09, g_rbk[l_ac3].rbk10,
                   g_rbk[l_ac3].rbk11, g_rbk[l_ac3].rbk12,
                   g_rbk[l_ac3].rbk13, g_rbk[l_ac3].rbk14,
                   g_rbk[l_ac3].rbkacti

   DISPLAY BY NAME g_rbk[l_ac3].type2,g_rbk[l_ac3].before2,g_rbk[l_ac3].after2
   CALL t402_set_entry_rbk()   

END FUNCTION
#原促銷方式已有設定資料，將 rap相關資料INSERT 至 rbp_file 且變更後的有效碼為'N'
FUNCTION t402_rbp()
DEFINE l_sql             STRING
DEFINE l_rap             RECORD LIKE rap_file.*
DEFINE l_rbp05           LIKE rbp_file.rbp05
DEFINE l_n               LIKE type_file.num5

   IF g_rbc[l_ac1].rbc11_1 = g_rbc[l_ac1].rbc11 THEN RETURN END IF 
   SELECT COUNT(*) INTO l_n FROM rbp_file
      WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02 
        AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
        AND rbp06 = '1' AND rbp12 = g_rbc[l_ac1].rbc11_1
        AND rbpacti = 'N'
   IF l_n > 0 THEN
      RETURN
   END IF  

   SELECT MAX(rbp05) INTO l_rbp05 FROM rbp_file
     WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
       AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
   IF l_rbp05 = 0 OR cl_null(l_rbp05) THEN
      LET l_rbp05 = 1
   END IF
   LET l_sql = " SELECT * FROM rap_file ",
               " WHERE rap01 = '",g_rbb.rbb01,"' AND rap02 = '",g_rbb.rbb02,"'",
               " AND rap03 = '1' AND rap04 = '",g_rbc[l_ac1].rbc06_1,"'",
               " AND rap09 = '",g_rbc[l_ac1].rbc11_1, "'",
               " AND rapplant = '",g_rbb.rbbplant, "'"
   PREPARE t402_sel_rbp FROM l_sql
   DECLARE t402sub_sel_rbp_cs CURSOR FOR t402_sel_rbp
   FOREACH t402sub_sel_rbp_cs INTO l_rap.*
      LET l_rap.rapacti = 'N'
    
      IF cl_null(l_rap.rap07) THEN LET l_rap.rap07 = 0 END IF  
      LET l_sql = "INSERT INTO rbp_file (rbp01,rbp02,rbp03,rbp04,rbp05,rbp06, ",
                  "                      rbp07,rbp08,rbp09,rbp10,rbp11,rbp12, ",
                  "                      rbpacti,rbplegal,rbpplant )",
                  " VALUES ('",g_rbb.rbb01,"','",g_rbb.rbb02,"',",g_rbb.rbb03,",",
                  "         '1',",l_rbp05,",'1',",l_rap.rap04,",'",l_rap.rap05,"',",
                  "          ",l_rap.rap06,",",l_rap.rap07,",",l_rap.rap08,",'",l_rap.rap09,"',",
                  "          '",l_rap.rapacti,"','",g_rbb.rbblegal,"','",g_rbb.rbbplant,"')" 

                      
      PREPARE trans_ins_rap1 FROM l_sql
      EXECUTE trans_ins_rap1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rap_file",g_rbb.rbb02,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
END FUNCTION
#
FUNCTION t402_delrbp() 
DEFINE l_sql         STRING
DEFINE l_n           LIKE type_file.num5

  #IF g_rbc[l_ac1].rbc11_1 <> g_rbc[l_ac1].rbc11 THEN RETURN END IF 
   IF g_rbc[l_ac1].rbc11_1 = g_rbc[l_ac1].rbc11 THEN
      SELECT COUNT(*) INTO l_n FROM rbp_file
         WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
           AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
           AND rbp06 = '1' AND rbp12 = g_rbc[l_ac1].rbc11_1
           AND rbpacti = 'N'
      IF l_n > 0 THEN
         DELETE FROM rbp_file
            WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
              AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
              AND rbp06 = '1' AND rbp12 = g_rbc[l_ac1].rbc11_1
              AND rbpacti = 'N'  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rap_file",g_rbb.rbb02,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF 
      END IF
   END IF
  #TQC-C20378 add START
   IF g_rbc_o.rbc11 <> g_rbc[l_ac1].rbc11 THEN  
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM rbp_file
         WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
           AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
           AND rbpplant = g_rbb.rbbplant 
           AND rbp12 = g_rbc_o.rbc11
           AND rbpacti = 'Y'  
      IF l_n > 0 THEN
         DELETE FROM rbp_file
            WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
              AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
              AND rbp12 = g_rbc_o.rbc11
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rap_file",g_rbb.rbb02,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #TQC-C20378 add END

END FUNCTION

FUNCTION t402_set_entry_rbk()
 
   IF cl_null(g_rbk[l_ac3].rbk13) AND cl_null(g_rbk[l_ac3].rbk14) THEN
      CALL cl_set_comp_entry("rbk14",TRUE)
      CALL cl_set_comp_entry("rbk13",TRUE)
   END IF
   IF NOT cl_null(g_rbk[l_ac3].rbk13) THEN
      CALL cl_set_comp_entry("rbk14",FALSE)
   ELSE
      CALL cl_set_comp_entry("rbk14",TRUE)
   END IF
   IF NOT cl_null(g_rbk[l_ac3].rbk14) THEN
      CALL cl_set_comp_entry("rbk13",FALSE)
   ELSE
      CALL cl_set_comp_entry("rbk13",TRUE)
   END IF
END FUNCTION

FUNCTION t402_chk_rbd()
DEFINE l_n           LIKE type_file.num5
   LET g_n = 0
   IF cl_null(g_rbd[l_ac2].rbd06) THEN RETURN END IF
   IF cl_null(g_rbd[l_ac2].rbd07) THEN RETURN END IF
   IF cl_null(g_rbd[l_ac2].rbd08) THEN RETURN END IF
   LET l_n = 0
   SELECT COUNT(*) INTO l_n
     FROM rad_file
      WHERE rad01=g_rbb.rbb01 AND rad02=g_rbb.rbb02
        AND radplant=g_rbb.rbbplant
        AND rad03=g_rbd[l_ac2].rbd06
        AND rad04=g_rbd[l_ac2].rbd07
        AND rad05=g_rbd[l_ac2].rbd08
   LET g_n = l_n
END FUNCTION

FUNCTION t402_chkrbp()  #促銷方式更改,提醒user
   DEFINE l_n      LIKE type_file.num5

   IF g_rbc[l_ac1].rbc11 = 0 THEN RETURN END IF  
   LET l_n= 0 
   SELECT COUNT(*) INTO l_n FROM rbp_file 
      WHERE rbp01 = g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
        AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
        AND rbp06 = '1' AND rbp12 = g_rbc_o.rbc11
        AND rbpplant = g_rbb.rbbplant
        AND rbp07 = g_rbc_o.rbc06 
   
   IF l_n > 0 THEN
     IF NOT cl_confirm('art-797') THEN
        LET g_rbc[l_ac1].rbc07 = g_rbc_o.rbc07
        RETURN
     END IF
     IF g_rbc_o.rbc07 = 1 THEN  #特價
        UPDATE rbp_file SET rbp09 = 0
           WHERE rbp01 =g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
             AND rbp03 = g_rbb.rbb03 AND rbp04 = '1' 
             AND rbp06 = '1' AND rbp12 =  g_rbc_o.rbc11
             AND rbpplant = g_rbb.rbbplant
             AND rbp07 =  g_rbc_o.rbc06
     END IF
     IF g_rbc_o.rbc07 = 2 THEN  #折扣
        UPDATE rbp_file SET rbp10 = 0
           WHERE rbp01 =g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
             AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
             AND rbp06 = '1' AND rbp12 =  g_rbc_o.rbc11
             AND rbpplant = g_rbb.rbbplant
             AND rbp07 =  g_rbc_o.rbc06
     END IF
     IF g_rbc_o.rbc07 = 3 THEN  #折讓
        UPDATE rbp_file SET rbp11 = 0
           WHERE rbp01 =g_rbb.rbb01 AND rbp02 = g_rbb.rbb02
             AND rbp03 = g_rbb.rbb03 AND rbp04 = '1'
             AND rbp06 = '1' AND rbp12 =  g_rbc_o.rbc11
             AND rbpplant = g_rbb.rbbplant
             AND rbp07 =  g_rbc_o.rbc06
     END IF
   END IF
END FUNCTION

#FUN-BC0072 add END
#FUN-C60041 -------------------STA
FUNCTION t402_create_temp_table()
   DROP TABLE rbb_temp
   SELECT * FROM rbb_file WHERE 1 = 0 INTO TEMP rbb_temp
   DROP TABLE rbc_temp
   SELECT * FROM rbc_file WHERE 1 = 0 INTO TEMP rbc_temp
   DROP TABLE rbd_temp
   SELECT * FROM rbd_file WHERE 1 = 0 INTO TEMP rbd_temp
   DROP TABLE rbp_temp
   SELECT * FROM rbp_file WHERE 1 = 0 INTO TEMP rbp_temp
   DROP TABLE rbq_temp
   SELECT * FROM rbq_file WHERE 1 = 0 INTO TEMP rbq_temp
   DROP TABLE rbk_temp                 
   SELECT * FROM rbk_file WHERE 1 = 0 INTO TEMP rbk_temp     

   DROP TABLE rab_temp
   SELECT * FROM rab_file WHERE 1 = 0 INTO TEMP rab_temp
   DROP TABLE rac_temp
   SELECT * FROM rac_file WHERE 1 = 0 INTO TEMP rac_temp
   DROP TABLE rad_temp
   SELECT * FROM rad_file WHERE 1 = 0 INTO TEMP rad_temp
   DROP TABLE rap_temp
   SELECT * FROM rap_file WHERE 1 = 0 INTO TEMP rap_temp
   DROP TABLE raq_temp
   SELECT * FROM raq_file WHERE 1 = 0 INTO TEMP raq_temp
   DROP TABLE rak_temp                 
   SELECT * FROM rak_file WHERE 1 = 0 INTO TEMP rak_temp  
END FUNCTION
FUNCTION t402_drop_temp_table()
   DROP TABLE rbb_temp
   DROP TABLE rbc_temp
   DROP TABLE rbd_temp
   DROP TABLE rbp_temp
   DROP TABLE rbq_temp
   DROP TABLE rbk_temp       

   DROP TABLE rab_temp
   DROP TABLE rac_temp
   DROP TABLE rad_temp
   DROP TABLE rap_temp
   DROP TABLE rak_temp 
END FUNCTION
#FUN-C60041 -------------------END
