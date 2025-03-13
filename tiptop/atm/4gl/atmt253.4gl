# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt253.4gl
# Descriptions...: 集團雜發申請單維護作業
# Date & Author..: 06/02/17 By ice
# Modify.........: TQC-640088 06/04/07 By Ray 修改執行刪除功能后未將變量清空 
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.TQC-650059 06/05/11 By ice 修改錯誤'不使用多單位時,單身子單位欄位還會出現'
# Modify.........: No.TQC-650091 06/05/22 By Rayven 增加多屬性功能
# Modify.........: No.FUN-660104 06/06/20 By cl  Error Message 調整
# Modify.........: No.TQC-660097 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容
# Modify.........: No.MOD-660090 06/06/22 By Rayven 料件多屬性補充修改，check_料號()內應再加傳p_cmd的參數
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0065 06/11/22 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 新增action"相關文件"
# Modify.........: No.FUN-710033 07/01/29 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-740039 07/04/10 By Ray 單身原因碼開窗出錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 將imaicd_file變為icd專用
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-870163 08/07/31 By sherry 預設申請數量=原異動數量
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.TQC-940184 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun t253_g_s傳參修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/09 By arman  GP5.2架構,修改SUB傳入相關參數
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980093 09/09/22 By TSD.sar2436 GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0078 11/11/18 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-B60093 11/06/29 By Pengu 依成本參數的成本類型抓取成本單價
# Modify.........: No:FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0085 11/11/29 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BB0086 12/01/18 By tanxc 增加數量欄位小數取位 
# Modify.........: No.FUN-BC0104 12/01/18 By xianghui 數量異動回寫qco20
# Modify.........: No.FUN-C20048 12/02/10 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/14 By fengrui 增加數量欄位小數取位
# Modify.........: No.TQC-C20183 12/02/16 By fengrui 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_tsg       RECORD LIKE tsg_file.*,
   g_tsg_t     RECORD LIKE tsg_file.*,
   g_tsg_o     RECORD LIKE tsg_file.*,
   g_tsg01_t          LIKE tsg_file.tsg01,       #調撥申請單號
   g_oga01            LIKE oga_file.oga01, 
   g_oga09            LIKE oga_file.oga09,
   b_tsh       RECORD LIKE tsh_file.*,
   g_ina       RECORD LIKE ina_file.*,
   g_inb       RECORD LIKE inb_file.*,
   g_azp02            LIKE azp_file.azp02,
   g_imd02            LIKE imd_file.imd02,
   g_pma02            LIKE pma_file.pma02,
   g_gen02            LIKE gen_file.gen02,
   g_gem02            LIKE gem_file.gem02,
   g_ima02            LIKE ima_file.ima02,
   g_ima135           LIKE ima_file.ima135,
   g_ima25            LIKE ima_file.ima25,
   l_ima25            LIKE ima_file.ima25,   #No.TQC-650091
   l_imaacti          LIKE ima_file.imaacti, #No.TQC-650091
   g_ima906           LIKE ima_file.ima906,
   g_ima907           LIKE ima_file.ima907,
   g_img09            LIKE img_file.img09,
   g_img10            LIKE img_file.img10,
   g_imgg10           LIKE imgg_file.imgg10,
   g_flag             LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_dbs              LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
   l_tsg03_dbs        LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
   l_tsg06_dbs        LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
   l_cmd              LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(72)
   l_tsg12            LIKE tsg_file.tsg12,
   l_tsg13            LIKE tsg_file.tsg13,
   l_tsg14            LIKE tsg_file.tsg14,
   g_wc,g_wc2,g_sql,l_sql    LIKE type_file.chr1000,#No.FUN-680120 VARCHAR(1000)
   l_sql2             LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(1600)
   g_tsh      DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
      tsh02           LIKE tsh_file.tsh02,       #項次
      tsh13           LIKE tsh_file.tsh13,       #原因碼
      tsh03           LIKE tsh_file.tsh03,       #料件編號
      #No.TQC-650091  --begin-- 
      att00           LIKE imx_file.imx00, 
      att01           LIKE imx_file.imx01,       #No.FUN-680120 VARCHAR(10)        
      att01_c         LIKE imx_file.imx01,       #No.FUN-680120 VARCHAR(10)
      att02           LIKE imx_file.imx02,       #No.FUN-680120 VARCHAR(10)
      att02_c         LIKE imx_file.imx02,       #No.FUN-680120 VARCHAR(10)
      att03           LIKE imx_file.imx03,       #No.FUN-680120 VARCHAR(10)
      att03_c         LIKE imx_file.imx03,       #No.FUN-680120 VARCHAR(10)
      att04           LIKE imx_file.imx04,       #No.FUN-680120 VARCHAR(10)
      att04_c         LIKE imx_file.imx04,       #No.FUN-680120 VARCHAR(10)
      att05           LIKE imx_file.imx05,       #No.FUN-680120 VARCHAR(10)
      att05_c         LIKE imx_file.imx05,       #No.FUN-680120 VARCHAR(10)
      att06           LIKE imx_file.imx06,       #No.FUN-680120 VARCHAR(10)
      att06_c         LIKE imx_file.imx06,       #No.FUN-680120 VARCHAR(10)
      att07           LIKE imx_file.imx07,       #No.FUN-680120 VARCHAR(10)
      att07_c         LIKE imx_file.imx07,       #No.FUN-680120 VARCHAR(10)
      att08           LIKE imx_file.imx08,       #No.FUN-680120 VARCHAR(10)
      att08_c         LIKE imx_file.imx08,       #No.FUN-680120 VARCHAR(10)
      att09           LIKE imx_file.imx09,       #No.FUN-680120 VARCHAR(10)
      att09_c         LIKE imx_file.imx09,       #No.FUN-680120 VARCHAR(10)
      att10           LIKE imx_file.imx10,       #No.FUN-680120 VARCHAR(10)
      att10_c         LIKE imx_file.imx10,       #No.FUN-680120 VARCHAR(10)
      #No.TQC-650091  --end--
      ima02	      LIKE ima_file.ima02,       #品名規格
      ima135	      LIKE ima_file.ima135,      #產品條碼編號
      tsh04           LIKE tsh_file.tsh04,       #單位
      tsh05           LIKE tsh_file.tsh05,       #數量
      tsh10           LIKE tsh_file.tsh10,       #單位二
      tsh11           LIKE tsh_file.tsh11,       #單位二轉換率
      tsh12           LIKE tsh_file.tsh12,       #單位二數量
      tsh07           LIKE tsh_file.tsh07,       #單位一
      tsh08           LIKE tsh_file.tsh08,       #單位一轉換率
      tsh09           LIKE tsh_file.tsh09,       #單位一數量
      tsh06           LIKE tsh_file.tsh06        #確認數量
                  END RECORD,
   g_tsh_t            RECORD                     #程式變數 (舊值)
      tsh02           LIKE tsh_file.tsh02,
      tsh13           LIKE tsh_file.tsh13,
      tsh03           LIKE tsh_file.tsh03,
      #No.TQC-650091  --begin-- 
      att00           LIKE imx_file.imx00, 
      att01           LIKE imx_file.imx01,       #No.FUN-680120 VARCHAR(10)
      att01_c         LIKE imx_file.imx01,       #No.FUN-680120 VARCHAR(10)
      att02           LIKE imx_file.imx02,       #No.FUN-680120 VARCHAR(10)
      att02_c         LIKE imx_file.imx02,       #No.FUN-680120 VARCHAR(10)
      att03           LIKE imx_file.imx03,       #No.FUN-680120 VARCHAR(10)
      att03_c         LIKE imx_file.imx03,       #No.FUN-680120 VARCHAR(10)
      att04           LIKE imx_file.imx04,       #No.FUN-680120 VARCHAR(10)
      att04_c         LIKE imx_file.imx04,       #No.FUN-680120 VARCHAR(10)
      att05           LIKE imx_file.imx05,       #No.FUN-680120 VARCHAR(10)
      att05_c         LIKE imx_file.imx05,       #No.FUN-680120 VARCHAR(10)
      att06           LIKE imx_file.imx06,       #No.FUN-680120 VARCHAR(10)
      att06_c         LIKE imx_file.imx06,       #No.FUN-680120 VARCHAR(10)
      att07           LIKE imx_file.imx07,       #No.FUN-680120 VARCHAR(10)
      att07_c         LIKE imx_file.imx07,       #No.FUN-680120 VARCHAR(10)
      att08           LIKE imx_file.imx08,       #No.FUN-680120 VARCHAR(10)
      att08_c         LIKE imx_file.imx08,       #No.FUN-680120 VARCHAR(10)
      att09           LIKE imx_file.imx09,       #No.FUN-680120 VARCHAR(10)
      att09_c         LIKE imx_file.imx09,       #No.FUN-680120 VARCHAR(10)
      att10           LIKE imx_file.imx10,       #No.FUN-680120 VARCHAR(10)
      att10_c         LIKE imx_file.imx10,       #No.FUN-680120 VARCHAR(10)
      #No.TQC-650091  --end--
      ima02	      LIKE ima_file.ima02,   
      ima135	      LIKE ima_file.ima135,
      tsh04           LIKE tsh_file.tsh04,
      tsh05           LIKE tsh_file.tsh05,
      tsh10           LIKE tsh_file.tsh10,
      tsh11           LIKE tsh_file.tsh11,
      tsh12           LIKE tsh_file.tsh12,
      tsh07           LIKE tsh_file.tsh07,
      tsh08           LIKE tsh_file.tsh08,
      tsh09           LIKE tsh_file.tsh09,
      tsh06           LIKE tsh_file.tsh06
                  END RECORD,
   g_buf              LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(78)
   g_argv1            LIKE tsg_file.tsg01,
   l_argv1            LIKE tsg_file.tsg01,
   g_argv2            LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)  
   g_t1               LIKE oay_file.oayslip,        #單別        #No.FUN-680120 VARCHAR(05)
   l_sfb09            LIKE type_file.num10,         #No.FUN-680120 INTEGER
   g_rec_b            LIKE type_file.num5,          #單身筆數               #No.FUN-680120 SMALLINT
   l_ac               LIKE type_file.num5,          #目前處理的ARRAY CNT    #No.FUN-680120 SMALLINT
   l_sl               LIKE type_file.num5           #No.FUN-680120 SMALLINT                #目前處理的SCREEN LINE
 
DEFINE g_forupd_sql   STRING #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680120 SMALLINT
DEFINE g_cmd          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(01)
DEFINE p_cmd          LIKE type_file.chr50         #No.FUN-680120 VARCHAR(50)
DEFINE g_sw           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(01)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE p_cnt          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE l_poz04        LIKE poz_file.poz04,
       l_poy03        LIKE poy_file.poy03,
       p_plant        LIKE azp_file.azp01,
       p_dbs          LIKE azp_file.azp03
 
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
      
DEFINE #g_flow         LIKE apm_file.apm08,         #No.FUN-680120 VARCHAR(8)  # TQC-6A0079        #多角流程代碼       No.7992
       g_oga   RECORD LIKE oga_file.*,
       g_oga_t RECORD LIKE oga_file.*,
       g_oga_o RECORD LIKE oga_file.*,
       g_oga_u RECORD LIKE oga_file.*,
       b_ogb   RECORD LIKE ogb_file.*,
       g_ima86        LIKE ima_file.ima86,
       g_oea   RECORD LIKE oea_file.*,
       g_oeb   RECORD LIKE oeb_file.*,
       g_ofa   RECORD LIKE ofa_file.*,                 #No.7992
       g_oea18        LIKE oea_file.oea18,
       g_oea23        LIKE oea_file.oea23,
       g_oea24        LIKE oea_file.oea24,
       l_oma00        LIKE oma_file.oma00,             #TQC-840066
       g_num          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_credit       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
       p_success      LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
       p_tot1	      LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3)
       p_tot2	      LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3) 
       p_tot3	      LIKE aao_file.aao05,             #No.FUN-680120 DEC(15,3) 
#      g_start,g_end  LIKE apm_file.apm08,             #No.FUN-680120 VARCHAR(10) # TQC-6A0079 
       exT            LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
       tot1,tot2,tot3 LIKE ogb_file.ogb12
DEFINE l_argv0        LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)              # 1.出貨通知單 2.出貨單
                                             # 4.三角貿易出貨單 5.三角貿易通知單
                                             # 6.代采買三角貿易
DEFINE g_argv3        LIKE tsg_file.tsg04,
       l_argv3        LIKE tsg_file.tsg04
 
DEFINE begin_no,end_no LIKE oea_file.oea01   #No.FUN-680120 VARCHAR(16)       # 單號
DEFINE g_ocf RECORD   LIKE ocf_file.*
 
#No.TQC-650091  --begin--
DEFINE   arr_detail    DYNAMIC ARRAY OF RECORD
         imx00         LIKE imx_file.imx00,
         imx           ARRAY[10] OF LIKE imx_file.imx01 
         END RECORD
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE   lg_smy62      LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE   lg_group      LIKE smy_file.smy62   #當前單身中采用的組別    
#No.TQC-650091  --end--  
DEFINE l_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
DEFINE l_plant_new     LIKE azp_file.azp01        #FUN-980093 add
DEFINE g_tsh04_t       LIKE tsh_file.tsh04        #No.FUN-BB0086 
DEFINE g_tsh07_t       LIKE tsh_file.tsh07        #No.FUN-BB0086 
DEFINE g_tsh10_t       LIKE tsh_file.tsh10        #No.FUN-BB0086 
#DEFINE g_sma894        LIKE type_file.chr1       #FUN-C80107 add #FUN-D30024 mark
DEFINE g_imd23         LIKE type_file.chr1        #FUN-D30024 add

MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6B0014
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
       EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_argv1=ARG_VAL(1)  #for axmp301 : 物流導入
   LET g_argv2=ARG_VAL(2)  #for axmp301 : 物流導入 過賬(atmt253)
    
   #若有傳參數則不用輸入畫面
   IF NOT cl_null(g_argv1)  AND g_argv2='G' THEN 
   ELSE 
      LET p_row = 1 LET p_col = 2
      OPEN WINDOW t253_w AT p_row,p_col
         WITH FORM "atm/42f/atmt253" 
         ATTRIBUTE (STYLE = g_win_style)
 
    #No.TQC-650091  --begin--                                                                                                           
    #初始化界面的樣式(沒有任何默認屬性組)                                                                                           
    LET lg_smy62 = ''                                                                                                               
    LET lg_group = ''                                                                                                               
    CALL t253_refresh_detail()                                                                                                      
    #No.TQC-650091  --end--
    
      CALL cl_ui_init()
      CALL t253_def_form()
      CALL t253()
      CLOSE WINDOW t253_w
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION t253()
   INITIALIZE g_tsg.* TO NULL
   INITIALIZE g_tsg_t.* TO NULL
   INITIALIZE g_tsg_o.* TO NULL
   CALL t253_lock_cur()
   CALL t253_menu()
END FUNCTION
 
FUNCTION t253_lock_cur()
   LET g_forupd_sql = " SELECT * FROM tsg_file WHERE tsg01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t253_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
END FUNCTION
 
FUNCTION t253_cs()
   DEFINE l_tsg03  LIKE tsg_file.tsg03,
          l_tsg06  LIKE tsg_file.tsg06
 
   CLEAR FORM
   CALL g_tsh.clear()
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tsg.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON
      tsg01,tsg02,tsg17,tsg18,tsg08,tsg09,tsg11,tsg03,tsg04,tsg06,
      tsg07,tsg19,tsg20,tsg21,tsg05,tsg15,tsg12,tsg13,tsg14,tsg10,
      tsg16,tsguser,tsggrup,tsgmodu,tsgdate,tsgacti
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask() 
        
      ON ACTION controlp
         CASE
            WHEN INFIELD(tsg01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_tsg"  
               LET g_qryparam.state = "c"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg01
               NEXT FIELD tsg01
            WHEN INFIELD(tsg08)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gen"
               LET g_qryparam.state = "c"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg08
               NEXT FIELD tsg08
            WHEN INFIELD(tsg09)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem"
               LET g_qryparam.state = "c"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg09
               NEXT FIELD tsg09
            WHEN INFIELD(tsg03)                                         
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_azp"
               LET g_qryparam.state = "c"                                   
               CALL cl_create_qry() RETURNING g_qryparam.multiret           
               DISPLAY g_qryparam.multiret TO tsg03    
               LET  l_tsg03 = g_qryparam.multiret                
               NEXT FIELD tsg03
            WHEN INFIELD(tsg04) 
               CALL t253_azp(l_tsg03) RETURNING l_dbs 
               #CALL q_m_imd(TRUE,FALSE,g_tsg.tsg04,'S',l_dbs) #FUN-980093 mark 
               CALL q_m_imd(TRUE,FALSE,g_tsg.tsg04,'S',l_tsg03) #FUN-980093 add
                  RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg04
               NEXT FIELD tsg04
            WHEN INFIELD(tsg06)                                         
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_azp"
               LET g_qryparam.state = "c"                                   
               CALL cl_create_qry() RETURNING g_qryparam.multiret           
               DISPLAY g_qryparam.multiret TO tsg06
               LET  l_tsg06 = g_qryparam.multiret             
               NEXT FIELD tsg06
            WHEN INFIELD(tsg07)                                         
               CALL t253_azp(l_tsg06) RETURNING l_dbs 
               #CALL q_m_imd(TRUE,FALSE,g_tsg.tsg07,'S',l_dbs)  #FUN-980093 mark
               CALL q_m_imd(TRUE,FALSE,g_tsg.tsg07,'S',l_tsg06)  #FUN-980093 add
                  RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsg07
               NEXT FIELD tsg07 
            WHEN INFIELD(tsg15)                                         
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_ocd1"
               LET g_qryparam.state = "c"                                   
               CALL cl_create_qry() RETURNING g_qryparam.multiret           
               DISPLAY g_qryparam.multiret TO tsg15
               NEXT FIELD tsg15
         END CASE
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON tsh02,tsh13,tsh03,tsh04,tsh05,tsh10,tsh11,tsh12,
                      tsh07,tsh08,tsh09,tsh06
                 FROM s_tsh[1].tsh02,s_tsh[1].tsh13,s_tsh[1].tsh03,
                      s_tsh[1].tsh04,s_tsh[1].tsh05,s_tsh[1].tsh10,
                      s_tsh[1].tsh11,s_tsh[1].tsh12,s_tsh[1].tsh07,
                      s_tsh[1].tsh08,s_tsh[1].tsh09,s_tsh[1].tsh06
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tsh13)
               CALL cl_init_qry_var()
#              LET g_qryparam.form  = "q_tqe1"     #No.FUN-6B0065
               LET g_qryparam.form  = "q_azf1"     #No.FUN-6B0065
               LET g_qryparam.state = "c"  
#              LET g_qryparam.where = " tqe03='4' "     #No.FUN-6B0065
#              LET g_qryparam.where = " azf09='4' "     #No.FUN-6B0065      #No.TQC-740039
               LET g_qryparam.where = " azf09='4' AND azf02 = '2'"     #No.FUN-6B0065      #No.TQC-740039
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsh13
               NEXT FIELD tsh03
            WHEN INFIELD(tsh03)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  = "q_ima"
#              LET g_qryparam.state = "c"  
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO tsh03
               NEXT FIELD tsh03
            WHEN INFIELD(tsh04)                                         
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gfe" 
               LET g_qryparam.state = "c"                                   
               CALL cl_create_qry() RETURNING g_qryparam.multiret           
               DISPLAY g_qryparam.multiret TO tsh04                     
               NEXT FIELD tsh04  
            WHEN INFIELD(tsh10)
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gfe" 
               LET g_qryparam.state = "c"                                   
               CALL cl_create_qry() RETURNING g_qryparam.multiret           
               DISPLAY g_qryparam.multiret TO tsh10
               NEXT FIELD tsh10
            WHEN INFIELD(tsh07)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gfe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret           
               DISPLAY g_qryparam.multiret TO tsh07
               NEXT FIELD tsh07
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
    
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND tsguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND tsggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tsggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tsguser', 'tsggrup')
    #End:FUN-980030
   IF g_wc2 = ' 1=1' THEN
      LET g_sql = "SELECT tsg01 ",
                  "  FROM tsg_file ",
                  " WHERE ",g_wc CLIPPED, 
                  " ORDER BY tsg01"
   ELSE 
      LET g_sql = "SELECT DISTINCT tsg_file.tsg01",
                  "  FROM tsg_file,tsh_file ",
                  " WHERE tsg01=tsh01",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " ORDER BY tsg01"
   END IF
   PREPARE t253_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t253_cs SCROLL CURSOR WITH HOLD FOR t253_prepare
   IF g_wc2 = ' 1=1' THEN
      LET g_sql = " SELECT COUNT(DISTINCT tsg01) FROM tsg_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql = " SELECT COUNT(DISTINCT tsg01) FROM tsg_file,tsh_file ",
                  "  WHERE ",g_wc CLIPPED,
                  "    AND ",g_wc2 CLIPPED,
                  "    AND tsg01 = tsh01 "
   END IF
   PREPARE t253_precount FROM g_sql
   DECLARE t253_count CURSOR FOR t253_precount
END FUNCTION
 
FUNCTION t253_menu()
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_poy11   LIKE poy_file.poy11
 
   WHILE TRUE
      CALL t253_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL t253_a()
            END IF
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t253_q()
            END IF
 
         WHEN "delete" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL t253_r()
            END IF
 
         WHEN "modify" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL t253_u()
            END IF
 
         WHEN "reproduce" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL t253_copy()
            END IF
 
         WHEN "detail" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL t253_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL t253_out()
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()            
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_tsh),'','')
            END IF
 
         WHEN "confirm"       #審核
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1 =' ') THEN 
               CALL t253_x()
            END IF
 
         WHEN "undo_confirm"   #取消審核
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL t253_xy()
            END IF
 
         WHEN "blank"           #                                           
            IF cl_chk_act_auth() THEN                                           
               CALL t253_v('0') 
            END IF   
               
         WHEN "undo_blank"      #                                           
            IF cl_chk_act_auth() THEN                                           
               CALL t253_v('1') 
            END IF 
                 
         WHEN "post"                                                     
            IF cl_chk_act_auth() THEN                                           
               CALL t253_p1() 
            END IF
            
         WHEN "undo_post"                                                     
            IF cl_chk_act_auth() THEN                                           
               CALL t253_p2() 
           END IF  
         
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tsg.tsg01 IS NOT NULL THEN
                 LET g_doc.column1 = "tsg01"
                 LET g_doc.value1 = g_tsg.tsg01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
 
      END CASE
   END WHILE
   CLOSE t253_cs
END FUNCTION
 
FUNCTION t253_a()
   DEFINE li_result       LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清畫面欄位內容
   CALL g_tsh.clear()
   INITIALIZE g_tsg.* LIKE tsg_file.*
   LET g_tsg_t.*=g_tsg.*
   LET g_tsg_o.*=g_tsg.*
   LET g_tsg01_t     = NULL
   LET g_tsg.tsg05   = '1'
   LET g_tsg.tsguser = g_user
   LET g_tsg.tsgoriu = g_user #FUN-980030
   LET g_tsg.tsgorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_tsg.tsgdate = g_today
   LET g_tsg.tsggrup = g_grup
   LET g_tsg.tsgacti = 'Y'
   LET g_tsg.tsg08   = g_user
   LET g_tsg.tsg09   = g_grup
   LET g_tsg.tsg16   = 'N'
   LET g_tsg.tsg19   = '0'
   LET g_tsg.tsg20   = 0
   LET g_tsg.tsg21   = 0
   LET g_tsg_t.* = g_tsg.*
   LET g_tsg_o.* = g_tsg.*
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t253_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_tsg.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_tsh.clear()
         EXIT WHILE
      END IF
      IF g_tsg.tsg01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 并且其單號為空白, 則自動賦予單號             
      BEGIN WORK                                                                
      CALL s_auto_assign_no("aim",g_tsg.tsg01,g_tsg.tsg02,"E","tsg_file","tsg01","","","")
         RETURNING li_result,g_tsg.tsg01
      IF (NOT li_result) THEN
         ROLLBACK WORK 
         CONTINUE WHILE
      END IF 
      DISPLAY BY NAME g_tsg.tsg01
 
      LET g_tsg.tsgplant = g_plant #FUN-980009
      LET g_tsg.tsglegal = g_legal #FUN-980009
 
      INSERT INTO tsg_file VALUES(g_tsg.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
      #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)  #No.FUN-660104
         CALL cl_err3("ins","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         ROLLBACK WORK 
         CONTINUE WHILE
      ELSE
         LET g_tsg_t.* = g_tsg.*               # 保存上筆資料
         SELECT tsg01 INTO g_tsg.tsg01 FROM tsg_file
          WHERE tsg01 = g_tsg.tsg01
         COMMIT WORK
      END IF
      CALL g_tsh.clear()
      LET g_rec_b=0 
      CALL t253_b('0')
      EXIT WHILE
   END WHILE
   LET g_wc=' '
END FUNCTION
   
FUNCTION t253_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_oyo04t        LIKE type_file.chr21          #No.FUN-680120 VARCHAR(21)   
   DEFINE li_result       LIKE type_file.num5           #No.FUN-680120 SMALLINT
   
   DISPLAY BY NAME g_tsg.tsg05,g_tsg.tsg08,g_tsg.tsg09,
       g_tsg.tsg16,g_tsg.tsg19,g_tsg.tsg20,g_tsg.tsg21,
       g_tsg.tsguser,g_tsg.tsgmodu,
       g_tsg.tsggrup,g_tsg.tsgdate,g_tsg.tsgacti
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_tsg.tsgoriu,g_tsg.tsgorig,
      g_tsg.tsg01,g_tsg.tsg02,g_tsg.tsg17,g_tsg.tsg18,
      g_tsg.tsg08,g_tsg.tsg09,g_tsg.tsg11,g_tsg.tsg03,
      g_tsg.tsg04,g_tsg.tsg06,g_tsg.tsg07,g_tsg.tsg19,
      g_tsg.tsg20,g_tsg.tsg21,g_tsg.tsg05,g_tsg.tsg15,
      g_tsg.tsg12,g_tsg.tsg13,g_tsg.tsg14,g_tsg.tsg10
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t253_set_entry(p_cmd)
         CALL t253_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tsg01")
       
      BEFORE FIELD tsg01
         IF p_cmd='a' THEN            
            LET g_tsg.tsg02=g_today
            LET g_tsg.tsg17=g_today+1              
            LET g_tsg.tsg03=g_plant
            DISPLAY BY NAME g_tsg.tsg02,g_tsg.tsg17
            CALL t253_tsg08('d')
            CALL t253_tsg09('d')
            DISPLAY g_gen02 TO FORMONLY.gen02
            DISPLAY g_gem02 TO FORMONLY.gem02
            LET g_azp02 = t253_tsg03(g_plant)
            DISPLAY g_plant TO tsg03
            DISPLAY g_azp02 TO FORMONLY.azp02
         END IF
                
      AFTER FIELD tsg01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_tsg.tsg01) THEN                                  
            #No.TQC-650091  --begin--                                                                                                   
            LET g_t1 = s_get_doc_no(g_tsg.tsg01)                                                                                    
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN                                                                   
               #讀取smy_file中指定作業對應的默認屬性群組                                                                            
               SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1                                                        
               #刷新界面顯示                                                                                                        
               CALL t253_refresh_detail()                                                                                           
            ELSE                                                                                                                    
               LET lg_smy62 = ''                                                                                                    
            END IF                                                                                                                  
            #No.TQC-650091  --end--
 
            CALL s_check_no("aim",g_tsg.tsg01,g_tsg01_t,"E","tsg_file","tsg01","") RETURNING li_result,g_tsg.tsg01
            DISPLAY BY NAME g_tsg.tsg01
            IF (NOT li_result) THEN
               LET g_tsg.tsg01=g_tsg_o.tsg01
               NEXT FIELD tsg01
            END IF
         #No.TQC-650091  --begin--                                                                                                      
         ELSE                                                                                                                       
            IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                       
               LET lg_smy62 = ''                                                                                                    
               CALL t253_refresh_detail()                                                                                           
            END IF                                                                                                                  
         #No.TQC-650091  --end--
         END IF
 
      AFTER FIELD tsg08                                                   
         IF NOT cl_null(g_tsg.tsg08) THEN                             
            IF (g_tsg.tsg08 != g_tsg_t.tsg08)                  
               OR (g_tsg_t.tsg08 IS NULL) THEN                        
               CALL t253_tsg08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsg.tsg08,g_errno,0)
                  LET g_tsg.tsg08 = g_tsg_t.tsg08            
                  DISPLAY BY NAME g_tsg.tsg08                      
                  NEXT FIELD tsg08                                     
               ELSE                                                         
                  DISPLAY g_gen02 TO FORMONLY.gen02                        
                  LET g_tsg_t.tsg08 = g_tsg.tsg08            
                  CALL t253_tsg09('d')
                  DISPLAY BY NAME g_tsg.tsg09
                  DISPLAY g_gem02 TO FORMONLY.gem02
               END IF                                                       
            END IF                                                           
         END IF
 
      BEFORE FIELD tsg09                                                  
         CALL t253_tsg09('d')
         DISPLAY BY NAME g_tsg.tsg09
         DISPLAY g_gem02 TO FORMONLY.gem02
 
      AFTER FIELD tsg09                                                  
         IF NOT cl_null(g_tsg.tsg09) THEN                             
            IF (g_tsg.tsg09 != g_tsg_t.tsg09)                  
               OR (g_tsg_t.tsg09 IS NULL) THEN                        
               CALL t253_tsg09('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tsg.tsg09,g_errno,0)
                  LET g_tsg.tsg09 = g_tsg_t.tsg09            
                  DISPLAY BY NAME g_tsg.tsg09                       
                  NEXT FIELD tsg09                                     
               ELSE                                                         
                  DISPLAY g_gem02 TO FORMONLY.gem02                        
                  LET g_tsg_t.tsg09 = g_tsg.tsg09
               END IF                                                       
            END IF                                                           
         END IF
 
      AFTER FIELD tsg03
         IF NOT cl_null(g_tsg.tsg03) THEN                             
            IF (g_tsg.tsg03 != g_tsg_t.tsg03) 
               OR (g_tsg_t.tsg03 IS NULL) THEN  
               SELECT azp02 INTO g_azp02 FROM azp_file
                WHERE azp01 = g_tsg.tsg03                     
               IF STATUS THEN              
               #  CALL cl_err('azp01',STATUS,0)    #No.FUN-660104                         
                  CALL cl_err3("sel","azp_file",g_tsg.tsg03,"",STATUS,"","azp01",1)  #No.FUN-660104
                  LET g_tsg.tsg03 = g_tsg_t.tsg03
                  DISPLAY BY NAME g_tsg.tsg03                       
                  NEXT FIELD tsg03                                     
               ELSE
                  DISPLAY g_azp02 TO FORMONLY.azp02
               END IF                                                       
               LET g_tsg_t.tsg03 = g_tsg.tsg03
               IF NOT cl_null(g_tsg.tsg06) AND g_tsg.tsg03 = g_tsg.tsg06 THEN
                  CALL cl_err('azp01','atm-398',0)                           
                  LET g_tsg.tsg03 = g_tsg_t.tsg03
                  DISPLAY BY NAME g_tsg.tsg03                       
                  NEXT FIELD tsg03                                     
               END IF
               IF NOT cl_null(g_tsg.tsg04) THEN
                  CALL t253_azp(g_tsg.tsg03) RETURNING l_tsg03_dbs 
                  #CALL t253_imd(g_tsg.tsg04,l_tsg03_dbs) RETURNING g_sw #FUN-980093 mark
                  CALL t253_imd(g_tsg.tsg04,g_tsg.tsg03) RETURNING g_sw  #FUN-980093 add
                  IF g_sw THEN                                               
                     CALL cl_err('',g_errno,0)
                     LET g_tsg.tsg03 = g_tsg_t.tsg03
                     DISPLAY BY NAME g_tsg.tsg03
                     NEXT FIELD tsg03
                  END IF
               END IF
            LET g_tsg_t.tsg03 = g_tsg.tsg03
            END IF
            #FUN-980093 add --(S)
            IF NOT s_chk_plant(g_tsg.tsg03) THEN
               NEXT FIELD tsg03
            END IF
            #FUN-980093 add --(E)
         END IF
 
      AFTER FIELD tsg04                                                   
         IF NOT cl_null(g_tsg.tsg04) THEN          
            IF (g_tsg.tsg04 != g_tsg_t.tsg04)                  
               OR (g_tsg_t.tsg04 IS NULL) THEN                        
            #FUN-AB0078  --add
             IF NOT s_chk_ware1(g_tsg.tsg04,g_tsg.tsg03) THEN
                NEXT FIELD tsg04
             END IF         
            #FUN-AB0078  --end                                                          
               CALL t253_azp(g_tsg.tsg03) RETURNING l_tsg03_dbs 
               #CALL t253_imd(g_tsg.tsg04,l_tsg03_dbs) RETURNING g_sw #FUN-980093 mark
               CALL t253_imd(g_tsg.tsg04,g_tsg.tsg03) RETURNING g_sw  #FUN-980093 add
               IF g_sw THEN                                               
                  CALL cl_err('',g_errno,0)
                  LET g_tsg.tsg04 = g_tsg_t.tsg04            
                  DISPLAY BY NAME g_tsg.tsg04                       
                  NEXT FIELD tsg04                                     
               ELSE                                                         
                  #CALL t253_imd02(g_tsg.tsg04,l_tsg03_dbs) RETURNING g_imd02 #FUN-980093 mark
                  CALL t253_imd02(g_tsg.tsg04,g_tsg.tsg03) RETURNING g_imd02  #FUN-980093 add
                  DISPLAY g_imd02 TO FORMONLY.imd02                        
               END IF                                                       
               LET g_tsg_t.tsg04 = g_tsg.tsg04
            END IF  
         END IF
          
 
      AFTER FIELD tsg06
         IF NOT cl_null(g_tsg.tsg06) THEN
            IF (g_tsg.tsg06 != g_tsg_t.tsg06) 
               OR (g_tsg_t.tsg06 IS NULL) THEN  
               SELECT azp02 INTO g_azp02 FROM azp_file
                WHERE azp01 = g_tsg.tsg06
               IF STATUS THEN              
               #  CALL cl_err('azp01',STATUS,0)      #No.FUN-660104                        
                  CALL cl_err3("sel","azp_file",g_tsg.tsg06,"",STATUS,"","azp01",1)   #No.FUN-660104
                  LET g_tsg.tsg06 = g_tsg_t.tsg06
                  DISPLAY BY NAME g_tsg.tsg06
                  NEXT FIELD tsg06
               ELSE
                  DISPLAY g_azp02 TO FORMONLY.azp02a
               END IF                                                       
               LET g_tsg_t.tsg06 = g_tsg.tsg06
               IF p_cmd = 'u' THEN
                  IF NOT cl_confirm('atm-399') THEN 
                     LET g_tsg.tsg06 = g_tsg_t.tsg06
                     DISPLAY BY NAME g_tsg.tsg06                       
                     NEXT FIELD tsg15                                     
                  END IF
               END IF
               IF NOT cl_null(g_tsg.tsg03) AND g_tsg.tsg03 = g_tsg.tsg06 THEN
                  CALL cl_err('azp01','atm-398',0)                           
                  LET g_tsg.tsg06 = g_tsg_t.tsg06
                  DISPLAY BY NAME g_tsg.tsg06                       
                  NEXT FIELD tsg06                                     
               END IF
               IF NOT cl_null(g_tsg.tsg07) THEN
                  CALL t253_azp(g_tsg.tsg06) RETURNING l_tsg06_dbs 
                  #CALL t253_imd(g_tsg.tsg07,l_tsg06_dbs) RETURNING g_sw #FUN-980093 mark
                  CALL t253_imd(g_tsg.tsg07,g_tsg.tsg06) RETURNING g_sw  #FUN-980093 add
                  IF g_sw THEN                                               
                     CALL cl_err('',g_errno,0)
                     LET g_tsg.tsg06 = g_tsg_t.tsg06
                     DISPLAY BY NAME g_tsg.tsg06
                     NEXT FIELD tsg06
                  END IF
               END IF
            END IF
            #FUN-980093 add --(S)
            IF NOT s_chk_plant(g_tsg.tsg06) THEN
               NEXT FIELD tsg06
            END IF
            #FUN-980093 add --(E)
         END IF
 
      AFTER FIELD tsg07
         IF NOT cl_null(g_tsg.tsg07) THEN                             
            IF (g_tsg.tsg07 != g_tsg_t.tsg07)                  
               OR (g_tsg_t.tsg07 IS NULL) THEN                        
               IF p_cmd = 'u' THEN
                  IF NOT cl_confirm('atm-399') THEN 
                     LET g_tsg.tsg07 = g_tsg_t.tsg07
                     DISPLAY BY NAME g_tsg.tsg07                       
                     NEXT FIELD tsg15                                     
                  END IF
               END IF
            #FUN-AB0078  --add
             IF NOT s_chk_ware1(g_tsg.tsg07,g_tsg.tsg06) THEN
                NEXT FIELD tsg07
             END IF         
            #FUN-AB0078  --end                                
               CALL t253_azp(g_tsg.tsg06) RETURNING l_tsg06_dbs
               #CALL t253_imd(g_tsg.tsg07,l_tsg06_dbs) RETURNING g_sw #FUN-980093 mark
               CALL t253_imd(g_tsg.tsg07,g_tsg.tsg06) RETURNING g_sw #FUN-980093 add
               IF g_sw THEN                                               
                  CALL cl_err('',g_errno,0)                            
                  LET g_tsg.tsg07 = g_tsg_t.tsg07            
                  DISPLAY BY NAME g_tsg.tsg07                       
                  NEXT FIELD tsg07                                     
               ELSE                                                         
                  #CALL t253_imd02(g_tsg.tsg07,l_tsg06_dbs) RETURNING g_imd02 #FUN-980093 mark
                  CALL t253_imd02(g_tsg.tsg07,g_tsg.tsg03) RETURNING g_imd02  #FUN-980093 add
                  DISPLAY g_imd02 TO FORMONLY.imd02a
               END IF                                                       
               LET g_tsg_t.tsg07 = g_tsg.tsg07            
            END IF                            
         END IF
 
      AFTER FIELD tsg15
         IF NOT cl_null(g_tsg.tsg15) THEN                             
            IF (g_tsg.tsg15 != g_tsg_t.tsg15)                  
               OR (g_tsg_t.tsg15 IS NULL) THEN                        
               IF cl_null(g_tsg.tsg06) THEN
                  NEXT FIELD tsg06
               END IF
               CALL t253_azp(g_tsg.tsg06) RETURNING l_tsg06_dbs
               #CALL t253_tsg15(l_tsg06_dbs) RETURNING g_flag #FUN-980093 mark
               CALL t253_tsg15(g_tsg.tsg06) RETURNING g_flag #FUN-980093 add
               IF g_flag = 'N' THEN                                               
                  CALL cl_err('tsg15',g_errno,0)                            
                  LET g_tsg.tsg15 = g_tsg_t.tsg15            
                  DISPLAY BY NAME g_tsg.tsg15 
                  NEXT FIELD tsg15 
               ELSE                                                         
                  LET g_tsg.tsg12 = l_tsg12
                  LET g_tsg.tsg13 = l_tsg13
                  LET g_tsg.tsg14 = l_tsg14
                  DISPLAY g_tsg.tsg12 TO tsg12
                  DISPLAY g_tsg.tsg13 TO tsg13
                  DISPLAY g_tsg.tsg14 TO tsg14
                  LET g_tsg_t.tsg15 = g_tsg.tsg15
               END IF                                                       
            END IF                                                           
         END IF
 
       #MOD-650015 --start 
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(tsg01) THEN
       #      LET g_tsg.* = g_tsg_t.*
       #      CALL t253_show()
       #      NEXT FIELD tsg01
       #   END IF
       #MOD-650015 --end
 
      ON ACTION controlp
         CASE                                                                
            WHEN INFIELD(tsg01)
               LET g_t1=s_get_doc_no(g_tsg.tsg01)
              #CALL q_smy(FALSE,FALSE,g_t1,'aim','E') RETURNING g_t1  #TQC-670008
               CALL q_smy(FALSE,FALSE,g_t1,'AIM','E') RETURNING g_t1  #TQC-670008
               LET g_tsg.tsg01 = g_t1
               DISPLAY BY NAME g_tsg.tsg01
               NEXT FIELD tsg01
            WHEN INFIELD(tsg08)                
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gen"
               CALL cl_create_qry() RETURNING g_tsg.tsg08
               DISPLAY BY NAME g_tsg.tsg08
               NEXT FIELD tsg08
            WHEN INFIELD(tsg09)            
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gem"
               CALL cl_create_qry() RETURNING g_tsg.tsg09
               DISPLAY BY NAME g_tsg.tsg09
               NEXT FIELD tsg09
            WHEN INFIELD(tsg03)                                   
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_azp"
               LET g_qryparam.construct = 'N'
               CALL cl_create_qry() RETURNING g_tsg.tsg03            
               DISPLAY BY NAME g_tsg.tsg03 
               NEXT FIELD tsg03
            WHEN INFIELD(tsg04) 
              #FUN-AB0078 --modify
              #CALL t253_azp(g_tsg.tsg03) RETURNING l_dbs 
              ##CALL q_m_imd(FALSE,FALSE,g_tsg.tsg04,'S',l_dbs) #FUN-980093 mark
              #CALL q_m_imd(FALSE,FALSE,g_tsg.tsg04,'S',g_tsg.tsg03) #FUN-980093 add
               CALL cl_init_qry_var()
               CALL q_imd_1(FALSE,TRUE,"","",g_tsg.tsg03,"","")
              #FUN-AB0078 --end
                  RETURNING g_tsg.tsg04
               DISPLAY BY NAME g_tsg.tsg04
               NEXT FIELD tsg04
            WHEN INFIELD(tsg06)                                   
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_azp"
               LET g_qryparam.construct = 'N'
               CALL cl_create_qry() RETURNING g_tsg.tsg06
               DISPLAY BY NAME g_tsg.tsg06
               NEXT FIELD tsg06
            WHEN INFIELD(tsg07)                                         
               #FUN-AB0078 --MODIFY
              #CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs 
              ##CALL q_m_imd(FALSE,FALSE,g_tsg.tsg07,'S',l_dbs) #FUN-980093 mark
              #CALL q_m_imd(FALSE,FALSE,g_tsg.tsg07,'S',g_tsg.tsg06)  #FUN-980093 add
               CALL cl_init_qry_var()
               CALL q_imd_1(FALSE,TRUE,"","",g_tsg.tsg06,"","")
              #FUN-AB0078 --END
                  RETURNING g_tsg.tsg07
               DISPLAY BY NAME g_tsg.tsg07
               NEXT FIELD tsg07 
            WHEN INFIELD(tsg15)
               CALL cl_init_qry_var()                                       
               SELECT azp03 INTO l_dbs FROM azp_file 
                WHERE azp01 = g_tsg.tsg06
#              LET g_qryparam.arg1 = l_dbs        #No.FUN-980025 mark
               LET g_qryparam.plant = g_tsg.tsg06 #No.FUN-980025 add   
               LET g_qryparam.form = "q_ocd2"
               CALL cl_create_qry() RETURNING g_tsg.tsg15
               DISPLAY BY NAME g_tsg.tsg15
               NEXT FIELD tsg15
         END CASE
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
        CALL cl_about()
 
      ON ACTION help 
         CALL cl_show_help()
    
   END INPUT
END FUNCTION
 
FUNCTION t253_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tsg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t253_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tsg01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t253_set_entry_b(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
                                                                                
   IF g_sma.sma115 = 'Y' THEN
      CALL cl_set_comp_entry("tsh10,tsh12,tsh07,tsh09",TRUE)
   END IF
END FUNCTION                                                                    
 
FUNCTION t253_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
                                                                                
   IF g_sma.sma115 = 'Y' AND g_sma.sma122 ='2' THEN                 #參考單位
      CALL cl_set_comp_entry("tsh10",FALSE) 
   END IF
END FUNCTION
 
FUNCTION t253_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
 
   #No.TQC-660097 --start--                                                                                                         
   IF g_sma.sma120 = 'Y'  THEN                                                                                                      
      LET lg_smy62 = ''                                                                                                             
      LET lg_group = ''                                                                                                             
      CALL t253_refresh_detail()                                                                                                    
   END IF                                                                                                                           
   #No.TQC-660097 --end--   
 
   CALL t253_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_tsh.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! " 
   OPEN t253_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)
      INITIALIZE g_tsg.* TO NULL
   ELSE
      OPEN t253_count
      FETCH t253_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t253_fetch('F')                 # 讀出TEMP第一筆并顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t253_fetch(p_fltsg)
   DEFINE
      p_fltsg         LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
   DEFINE l_slip      LIKE tsg_file.tsg01             #No.FUN-680120 VARCHAR(10)           #No.TQC-650091
 
   CASE p_fltsg
      WHEN 'N' FETCH NEXT     t253_cs INTO g_tsg.tsg01
      WHEN 'P' FETCH PREVIOUS t253_cs INTO g_tsg.tsg01
      WHEN 'F' FETCH FIRST    t253_cs INTO g_tsg.tsg01
      WHEN 'L' FETCH LAST     t253_cs INTO g_tsg.tsg01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump t253_cs INTO g_tsg.tsg01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)
      INITIALIZE g_tsg.* TO NULL       #TQC-640088
      RETURN
   ELSE
      CASE p_fltsg
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   #No.TQC-650091  --begin--                                                                                                            
   #在使用Q查詢的情況下得到當前對應的屬性組smy62                                                                                    
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                                
      LET l_slip = g_tsg.tsg01[1,g_doc_len]                                                                                         
      SELECT smy62 INTO lg_smy62 FROM smy_file                                                                                      
         WHERE smyslip = l_slip                                                                                                     
   END IF                                                                                                                           
   #No.TQC-650091  --end--
 
   SELECT * INTO g_tsg.* FROM tsg_file       # 重讀DB,因TEMP有不被更新特性
    WHERE tsg01 = g_tsg.tsg01
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
      CALL cl_err3("sel","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      INITIALIZE g_tsg.* TO NULL
   ELSE                                      #FUN-4C0042權限控管
      LET g_data_owner=g_tsg.tsguser
      LET g_data_group=g_tsg.tsggrup
      LET g_data_plant = g_tsg.tsgplant #FUN-980030
      CALL t253_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t253_show()
 
   LET g_tsg_t.* = g_tsg.*
   LET g_tsg_o.* = g_tsg.*
   DISPLAY BY NAME g_tsg.tsgoriu,g_tsg.tsgorig,
      g_tsg.tsg01,g_tsg.tsg02,g_tsg.tsg17,g_tsg.tsg18,
      g_tsg.tsg08,g_tsg.tsg09,g_tsg.tsg11,g_tsg.tsg03,
      g_tsg.tsg04,g_tsg.tsg06,g_tsg.tsg07,g_tsg.tsg19,
      g_tsg.tsg20,g_tsg.tsg21,g_tsg.tsg05,g_tsg.tsg15,
      g_tsg.tsg12,g_tsg.tsg13,g_tsg.tsg14,g_tsg.tsg10,
      g_tsg.tsguser,g_tsg.tsggrup,g_tsg.tsgmodu,
      g_tsg.tsgdate, g_tsg.tsgacti
 
   CALL t253_tsg08('d')
   CALL t253_tsg09('d')
   DISPLAY g_gen02 TO FORMONLY.gen02
   DISPLAY g_gem02 TO FORMONLY.gem02
 
   LET g_azp02 = t253_tsg03(g_tsg.tsg03)
   DISPLAY g_azp02 TO FORMONLY.azp02
   CALL t253_azp(g_tsg.tsg03) RETURNING l_dbs
   #CALL t253_imd02(g_tsg.tsg04,l_dbs) RETURNING g_imd02  #FUN-980093 mark
   CALL t253_imd02(g_tsg.tsg04,g_tsg.tsg03) RETURNING g_imd02 #FUN-980093 add
   IF  cl_null(g_tsg.tsg04) THEN LET g_imd02 = NULL END IF
   DISPLAY g_imd02 TO FORMONLY.imd02  
 
   LET g_azp02 = t253_tsg03(g_tsg.tsg06)
   DISPLAY g_azp02 TO FORMONLY.azp02a
   CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
   #CALL t253_imd02(g_tsg.tsg07,l_dbs) RETURNING g_imd02       #FUN-980093 mark
   CALL t253_imd02(g_tsg.tsg07,g_tsg.tsg06) RETURNING g_imd02  #FUN-980093 add    
   IF  cl_null(g_tsg.tsg06) THEN LET g_imd02 = NULL END IF                                           
   DISPLAY g_imd02 TO FORMONLY.imd02a   
 
   CALL t253_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t253_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #-->已審核不可修改
   IF g_tsg.tsg05 = '2' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsg.tsg05 = '3' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsg.tsg05='4' THEN CALL cl_err('post=Y','9024',0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
   OPEN t253_cl USING g_tsg.tsg01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t253_cl INTO g_tsg.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE t253_cl
      RETURN
   END IF
   LET g_tsg01_t = g_tsg.tsg01
   LET g_tsg_t.*=g_tsg.*
   LET g_tsg_o.*=g_tsg.*
   LET g_tsg.tsgmodu = g_user    
   LET g_tsg.tsggrup = g_grup                  
   CALL t253_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t253_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tsg.*=g_tsg_o.*
         CALL t253_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE tsg_file SET tsg_file.* = g_tsg.*    # 更新DB
                    WHERE tsg01 = g_tsg01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
      #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t253_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t253_r()   #刪除
   DEFINE l_chr   LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
          l_cnt   LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tsg.tsg05 = '2' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsg.tsg05 = '3' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsg.tsg05='4' THEN CALL cl_err('post=Y','9024',0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t253_cl USING g_tsg.tsg01
    IF STATUS THEN
       CALL cl_err("OPEN t253_cl:", STATUS, 1)
       CLOSE t253_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t253_cl INTO g_tsg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE t253_cl
        RETURN
    END IF
    CALL t253_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tsg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tsg.tsg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM tsg_file WHERE tsg01=g_tsg.tsg01
    #   IF STATUS THEN CALL cl_err('del tsg:',STATUS,0) RETURN END IF   #No.FUN-660104
        IF STATUS THEN   #No.FUN-660104
           CALL cl_err3("del","tsg_file",g_tsg.tsg01,"",STATUS,"","del tsg:",1)   #No.FUN-660104
           RETURN   #No.FUN-660104
        END IF   #No.FUN-660104
        DELETE FROM tsh_file WHERE tsh01 = g_tsg.tsg01
   #    IF STATUS THEN CALL cl_err('del tsh:',STATUS,0) RETURN END IF   #No.FUN-660104
        IF STATUS THEN
           CALL cl_err3("del","tsh_file",g_tsg.tsg01,"",STATUS,"","del tsh:",1)   #No.FUN-660104
           RETURN
        END IF
        INITIALIZE g_tsg.* TO NULL
        CLEAR FORM
        CALL g_tsh.clear()
        OPEN t253_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t253_cs
           CLOSE t253_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end--
        FETCH t253_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t253_cs
           CLOSE t253_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t253_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t253_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t253_fetch('/')
        END IF
    END IF
    CLOSE t253_cl
    COMMIT WORK
END FUNCTION
   
FUNCTION t253_x()    #審核
   DEFINE l_cnt  LIKE type_file.num5           #No.FUN-680120 SMALLINT
   
   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 ----------------- add --------------- begin
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tsg.tsg05='2' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_tsg.tsg05='3' THEN CALL cl_err('post=Y','mfg0175',0) RETURN END IF
   IF g_tsg.tsg05='4' THEN CALL cl_err('post=Y','9024',0) RETURN END IF
   IF NOT cl_confirm('axr-108') THEN RETURN END IF
    SELECT * INTO g_tsg.* FROM tsg_file WHERE tsg01 = g_tsg.tsg01
#CHI-C30107 ----------------- add --------------- end
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM tsh_file WHERE tsh01 = g_tsg.tsg01
   IF l_cnt = 0 THEN CALL cl_err('','mfg3464',0) RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t253_cl USING g_tsg.tsg01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t253_cl INTO g_tsg.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t253_cl ROLLBACK WORK RETURN
   END IF
 
   IF g_tsg.tsg05='2' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_tsg.tsg05='3' THEN CALL cl_err('post=Y','mfg0175',0) RETURN END IF 
   IF g_tsg.tsg05='4' THEN CALL cl_err('post=Y','9024',0) RETURN END IF
   
      #FUN-AB0078  --add
      IF NOT s_chk_ware1(g_tsg.tsg04,g_tsg.tsg03) THEN
         LET g_success = 'N'
         CLOSE t253_cl
         ROLLBACK WORK  
         RETURN
      END IF 
      IF NOT s_chk_ware1(g_tsg.tsg07,g_tsg.tsg06) THEN
         LET g_success = 'N'
         CLOSE t253_cl
         ROLLBACK WORK  
         RETURN
      END IF
      #FUN-AB0078  --end
#  IF cl_confirm('axr-108') THEN  #CHI-C30107 mark
      #CALL t253_b('1')
      CALL cl_set_act_visible("insert,delete",TRUE)
      IF g_success = 'N' THEN
         CALL cl_err(g_tsg.tsg01,9001,0)
         ROLLBACK WORK
         RETURN
      END IF       
      IF g_tsg.tsg05 = '1' THEN
         LET g_tsg.tsg05 ='2'
      END IF

      UPDATE tsg_file SET tsg05=g_tsg.tsg05,
                          tsgmodu=g_user,
                          tsgdate=g_today
                    WHERE tsg01  =g_tsg.tsg01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_tsg.tsg05 = '1'
         ROLLBACK WORK
      END IF
      DISPLAY BY NAME g_tsg.tsg05 
#  END IF #CHI-C30107 mark
   CLOSE t253_cl  
   COMMIT WORK
END FUNCTION
 
FUNCTION t253_xy()    #取消審核
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t253_cl USING g_tsg.tsg01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t253_cl INTO g_tsg.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t253_cl 
      ROLLBACK WORK 
      RETURN
   END IF
 
   IF g_tsg.tsg05='1' THEN CALL cl_err('','9025',0) RETURN END IF
   IF g_tsg.tsg05='3' THEN CALL cl_err('post=Y','mfg0175',0) RETURN END IF
   IF g_tsg.tsg05='4' THEN CALL cl_err('post=Y','9024',0) RETURN END IF
 
   IF cl_confirm('axr-109') THEN 
      IF g_tsg.tsg05 ='2'  THEN
         LET g_tsg.tsg05='1'
      END IF
      UPDATE tsg_file SET tsg05=g_tsg.tsg05,
                          tsgmodu=g_user,
                          tsgdate=g_today
                      WHERE tsg01  =g_tsg.tsg01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_tsg.tsg05 = '2'
         ROLLBACK WORK
      END IF
      DISPLAY BY NAME g_tsg.tsg05 
   END IF     
   CLOSE t253_cl  
   COMMIT WORK
END FUNCTION
 
FUNCTION t253_out()
   IF g_tsg.tsg01 IS NULL THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   LET l_cmd = "atmr253 '",g_tsg.tsg01,"' "
   CALL cl_cmdrun(l_cmd)
  
END FUNCTION
 
FUNCTION t253_b(p_flag)
   #No.TQC-650091  --begin--                                                                                                            
   DEFINE   li_i         LIKE type_file.num5             #No.FUN-680120 SMALLINT                                                                                  
   DEFINE   l_count      LIKE type_file.num5             #No.FUN-680120 SMALLINT                                                                                         
   DEFINE   l_temp       LIKE ima_file.ima01                                                                                        
   DEFINE   l_imaag      LIKE ima_file.imaag
   DEFINE   l_check_res  LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)                                                                         
   #No.TQC-650091  --end--
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
          l_m,l_n         LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
          l_sfb38         LIKE type_file.dat,              #No.FUN-680120 DATE
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680120 SMALLINT
          p_flag          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          p_ima25         LIKE ima_file.ima25,
          l_fac           LIKE inb_file.inb08_fac,
          l_tsg20         LIKE tsg_file.tsg20,   #重量
          l_tsg21         LIKE tsg_file.tsg21,   #體積
          l_tsg20_t       LIKE tsg_file.tsg20,
          l_tsg21_t       LIKE tsg_file.tsg21,
          l_tsh09         LIKE tsh_file.tsh09,
          l_tsh12         LIKE tsh_file.tsh12
   DEFINE l_azf09         LIKE azf_file.azf09    #No.FUN-930104
   DEFINE l_tf            LIKE type_file.chr1    #No.FUN-BB0086
   DEFINE l_case          STRING    #No.FUN-BB0086
 
   LET l_tsh09 = 0
   LET l_tsh12 = 0
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN 
      CALL cl_err('',-400,0)      #TQC-640088
      RETURN 
   END IF
   #-->已審核或結案不可修改
   IF g_tsg.tsg05 = '2' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsg.tsg05 = '3' THEN CALL cl_err('','axr-101',0) RETURN END IF
   IF g_tsg.tsg05='4' THEN CALL cl_err('post=Y','9024',0) RETURN END IF
    
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT tsh02,tsh13,tsh03,'','', ",
                      "  '','','','','','','','','','','','','','','','','','','','','',", #No.TQC-650091
                      "        tsh04,tsh05,tsh10,tsh11,tsh12, ",
#                     "        tsh10,tsh11,tsh12, ",
                      "        tsh07,tsh08,tsh09,tsh06 ",
                      "   FROM tsh_file ",
                      "   WHERE tsh01=? ",
                      "    AND tsh02=? ",
                      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t253_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tsh WITHOUT DEFAULTS FROM s_tsh.* 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_entry("tsh02,tsh13,tsh03,tsh04,tsh05,tsh10,tsh11,tsh12,tsh07,tsh08,tsh09,tsh06",TRUE)
         IF p_flag = '0' THEN
            CALL cl_set_comp_entry("tsh06",FALSE)
         ELSE
            LET g_success = 'Y'
            CALL cl_set_comp_entry("tsh02,tsh13,tsh03,tsh04,tsh05,tsh10,tsh11,tsh12,tsh07,tsh08,tsh09",FALSE)
            CALL cl_set_act_visible("insert,delete",FALSE)
         END IF 
         #No.FUN-BB0086--add--begin--
         LET g_tsh04_t = NULL 
         LET g_tsh07_t = NULL 
         LET g_tsh10_t = NULL 
         #No.FUN-BB0086--add--end--
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n = ARR_COUNT()
 
         BEGIN WORK
         OPEN t253_cl USING g_tsg.tsg01
         IF STATUS THEN
            CALL cl_err("OPEN t253_cl:", STATUS, 1)
            CLOSE t253_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t253_cl INTO g_tsg.*               # 對DB鎖定
         IF SQLCA.sqlcode THEN
             CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)
             ROLLBACK WORK
             CLOSE t253_cl
             RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_tsh_t.* = g_tsh[l_ac].*  #BACKUP
            #No.FUN-BB0086--add--begin--
            LET g_tsh04_t = g_tsh[l_ac].tsh04
            LET g_tsh07_t = g_tsh[l_ac].tsh07
            LET g_tsh10_t = g_tsh[l_ac].tsh10
            #No.FUN-BB0086--add--end--
            OPEN t253_bcl USING g_tsg.tsg01,g_tsh_t.tsh02
            IF STATUS THEN
               CALL cl_err("OPEN t253_bcl:", STATUS, 1)
               CLOSE t253_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t253_bcl INTO g_tsh[l_ac].*
 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tsh_t.tsh02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
               #得到該料件對應的父料件和所有屬性
                  SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                         imx07,imx08,imx09,imx10 INTO
                         g_tsh[l_ac].att00,g_tsh[l_ac].att01,g_tsh[l_ac].att02,
                         g_tsh[l_ac].att03,g_tsh[l_ac].att04,g_tsh[l_ac].att05,
                         g_tsh[l_ac].att06,g_tsh[l_ac].att07,g_tsh[l_ac].att08,
                         g_tsh[l_ac].att09,g_tsh[l_ac].att10
                  FROM imx_file WHERE imx000 = g_tsh[l_ac].tsh03
 
                  LET g_tsh[l_ac].att01_c = g_tsh[l_ac].att01
                  LET g_tsh[l_ac].att02_c = g_tsh[l_ac].att02
                  LET g_tsh[l_ac].att03_c = g_tsh[l_ac].att03
                  LET g_tsh[l_ac].att04_c = g_tsh[l_ac].att04
                  LET g_tsh[l_ac].att05_c = g_tsh[l_ac].att05
                  LET g_tsh[l_ac].att06_c = g_tsh[l_ac].att06
                  LET g_tsh[l_ac].att07_c = g_tsh[l_ac].att07
                  LET g_tsh[l_ac].att08_c = g_tsh[l_ac].att08
                  LET g_tsh[l_ac].att09_c = g_tsh[l_ac].att09
                  LET g_tsh[l_ac].att10_c = g_tsh[l_ac].att10
                   
               END IF
               CALL t253_tsh03('d')
               CALL cl_show_fld_cont()
               IF p_flag = '0' THEN
                  CALL t253_set_entry_b(p_cmd)
                  CALL t253_set_no_entry_b(p_cmd)
               END IF
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
                     RETURNING g_flag,g_ima906,g_ima907
                  IF g_ima906 = '1' THEN                #單一單位
                     CALL cl_set_comp_entry("tsh10,tsh12",FALSE) 
                  END IF
                  IF g_ima906 = '3' THEN                #參考單位
                     CALL cl_set_comp_entry("tsh10",FALSE) 
                  END IF
               END IF
            END IF
         ELSE
            IF p_flag = '1' THEN
               RETURN 
            END IF
         END IF
 
      BEFORE FIELD tsh02
         IF p_cmd='a' THEN
   	    SELECT MAX(tsh02)+1 INTO g_cnt FROM tsh_file
             WHERE tsh01 = g_tsg.tsg01
            IF cl_null(g_cnt) THEN
               LET g_cnt = 1
            END IF
            LET g_tsh[l_ac].tsh02 = g_cnt               
         END IF
 
      AFTER FIELD tsh02
         IF NOT cl_null(g_tsh[l_ac].tsh02) THEN 
            IF (g_tsh[l_ac].tsh02 != g_tsh_t.tsh02)
               OR (g_tsh_t.tsh02 IS NULL) THEN
               SELECT COUNT(*) INTO g_cnt FROM tsh_file 
                WHERE tsh01 = g_tsg.tsg01 
                  AND tsh02 = g_tsh[l_ac].tsh02
               IF g_cnt>0 THEN
                  CALL cl_err('tsh02',-239,0)                            
                  LET g_tsh[l_ac].tsh02 = g_tsh_t.tsh02 
                  DISPLAY BY NAME g_tsh[l_ac].tsh02  
                  NEXT FIELD tsh02                                     
               END IF                                                       
            END IF                                                           
         END IF 
 
      AFTER FIELD tsh13                                                   
         IF NOT cl_null(g_tsh[l_ac].tsh13) THEN                       
            IF p_cmd='a' OR (p_cmd='u'AND g_tsh_t.tsh13<>g_tsh[l_ac].tsh13) THEN                        
#No.FUN-6B0065 --begin                                                                                                          
#              SELECT COUNT(*) INTO g_cnt FROM tqe_file
#               WHERE tqe01 = g_tsh[l_ac].tsh13 
#                 AND tqe03 = '4'
               SELECT COUNT(*) INTO g_cnt FROM azf_file
                WHERE azf01 = g_tsh[l_ac].tsh13 
                  AND azf09 = '4'
                  AND azf02 = '2'  #No.FUN-930104 
#No.FUN-930104 --begin--
               SELECT azf09 INTO l_azf09 FROM azf_file
                WHERE azf01 = g_tsh[l_ac].tsh13
                  AND azf02 = '2'  
                  IF l_azf09 != '4' THEN 
                    CALL cl_err('','aoo-403',1)
                  END IF   
#No.FUN-930104 --end--                  
#No.FUN-6B0065 --end
               IF g_cnt = 0 THEN
                  CALL cl_err('tsh13','mfg3088',0)                            
                  LET g_tsh[l_ac].tsh13 = g_tsh_t.tsh13 
                  DISPLAY BY NAME g_tsh[l_ac].tsh13
                  NEXT FIELD tsh13
               END IF                                                       
            END IF
         END IF
 
      BEFORE FIELD tsh03
         CALL t253_set_entry_b(p_cmd)
         CALL t253_set_no_entry_b(p_cmd)
         CALL t253_set_no_required()
 
#No.TQC-650091  --begin--
      AFTER FIELD tsh03   
         LET l_case = ""   #No.FUN-BB0086      
         #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
#FUN-AA0059 ---------------------start----------------------------
         IF NOT cl_null(g_tsh[l_ac].tsh03) THEN
            IF NOT s_chk_item_no(g_tsh[l_ac].tsh03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_tsh[l_ac].tsh03= g_tsh_t.tsh03
               NEXT FIELD tsh03
            END IF
         END IF
#FUN-AA0059 ---------------------end-------------------------------
            CALL t253_check_tsh03('tsh03',l_ac,p_cmd) RETURNING #No.MOD-660090
                  l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
            #No.FUN-BB0086--add--begin--
            IF NOT cl_null(g_tsh[l_ac].tsh05) AND g_tsh[l_ac].tsh05<>0 THEN  #FUN-C20068
               IF NOT t253_tsh05_check() THEN
                  LET l_case = "tsh05"
               END IF 
            END IF                                                           #FUN-C20068
            IF NOT cl_null(g_tsh[l_ac].tsh06) AND g_tsh[l_ac].tsh06<>0 THEN  #FUN-C20068
               IF p_flag = '0' THEN                                                      #TQC-C20183
                  LET g_tsh[l_ac].tsh06=s_digqty(g_tsh[l_ac].tsh06,g_tsh[l_ac].tsh04)    #TQC-C20183
                  DISPLAY BY NAME g_tsh[l_ac].tsh06                                      #TQC-C20183
               ELSE                                                                      #TQC-C20183
                  IF NOT t253_tsh06_check() THEN
                     LET l_case = "tsh06"
                  END IF 
               END IF                                                        #TQC-C20183
            END IF                                                           #FUN-C20068             
            #No.FUN-BB0086--add--end--
            IF l_check_res = '1' THEN NEXT FIELD tsh03 END IF
            IF l_check_res = '2' THEN NEXT FIELD tsh07 END IF
            SELECT imaag INTO l_imaag FROM ima_file                                                                                  
             WHERE ima01 = g_tsh[l_ac].tsh03                                                                                         
            IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN                                                                     
               LET g_tsh[l_ac].ima02 = ''
               LET g_tsh[l_ac].tsh04 = ''
               LET g_tsh[l_ac].tsh05 = ''
               CALL cl_err(g_tsh[l_ac].tsh03,'aim1004',0)
               NEXT FIELD tsh03                                                                                                      
            ELSE
               SELECT ima02 INTO g_tsh[l_ac].ima02
                 FROM ima_file
                WHERE ima01 = g_tsh[l_ac].tsh03
            END IF
            #No.FUN-BB0086--add--begin--
            LET g_tsh04_t = g_tsh[l_ac].tsh04
            CASE l_case 
               WHEN "tsh05"
                  NEXT FIELD tsh05
               WHEN "tsh06"
                  NEXT FIELD tsh06
               OTHERWISE EXIT CASE 
            END CASE 
            #No.FUN-BB0086--add--end--
 
      # Add , 當sma908 <> 'Y'的時候,即不准通過單身來新增子料件,這時
      #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
      #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
      #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
      #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
      #其他分支就不需要這么麻煩了
      BEFORE FIELD att00
#         IF g_sma.sma908 <> 'Y' THEN
#            #否則開窗選的是子料件并且要回寫各個明細屬性到各個列中
#            CALL cl_init_qry_var()
#            LET g_qryparam.form ="q_ima_q"
#            LET g_qryparam.arg1 = lg_group
#            CALL cl_create_qry() RETURNING g_tsh[l_ac].tsh03
#            DISPLAY BY NAME g_tsh[l_ac].att00   
                       
            #根據子料件找到母料件及各個屬性
            SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                   imx06,imx07,imx08,imx09,imx10 
            INTO g_tsh[l_ac].att00, g_tsh[l_ac].att01, g_tsh[l_ac].att02,
                 g_tsh[l_ac].att03, g_tsh[l_ac].att04, g_tsh[l_ac].att05,
                 g_tsh[l_ac].att06, g_tsh[l_ac].att07, g_tsh[l_ac].att08,
                 g_tsh[l_ac].att09, g_tsh[l_ac].att10
            FROM imx_file
            WHERE imx000 = g_tsh[l_ac].tsh03
            #賦值所有屬性
            LET g_tsh[l_ac].att01_c = g_tsh[l_ac].att01
            LET g_tsh[l_ac].att02_c = g_tsh[l_ac].att02
            LET g_tsh[l_ac].att03_c = g_tsh[l_ac].att03
            LET g_tsh[l_ac].att04_c = g_tsh[l_ac].att04
            LET g_tsh[l_ac].att05_c = g_tsh[l_ac].att05
            LET g_tsh[l_ac].att06_c = g_tsh[l_ac].att06
            LET g_tsh[l_ac].att07_c = g_tsh[l_ac].att07
            LET g_tsh[l_ac].att08_c = g_tsh[l_ac].att08
            LET g_tsh[l_ac].att09_c = g_tsh[l_ac].att09
            LET g_tsh[l_ac].att10_c = g_tsh[l_ac].att10
            #顯示所有屬性
            DISPLAY BY NAME 
              g_tsh[l_ac].att01, g_tsh[l_ac].att01_c,
              g_tsh[l_ac].att02, g_tsh[l_ac].att02_c,
              g_tsh[l_ac].att03, g_tsh[l_ac].att03_c,
              g_tsh[l_ac].att04, g_tsh[l_ac].att04_c,
              g_tsh[l_ac].att05, g_tsh[l_ac].att05_c,
              g_tsh[l_ac].att06, g_tsh[l_ac].att06_c,
              g_tsh[l_ac].att07, g_tsh[l_ac].att07_c,
              g_tsh[l_ac].att08, g_tsh[l_ac].att08_c,
              g_tsh[l_ac].att09, g_tsh[l_ac].att09_c,
              g_tsh[l_ac].att10, g_tsh[l_ac].att10_c
#           NEXT FIELD tsh04                                
#        END IF
 
      #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
      #下面是十個輸入型屬性欄位的判斷語句
      AFTER FIELD att00
         LET l_case = ""   #No.FUN-BB0086
          #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
          SELECT COUNT(ima01) INTO l_count FROM ima_file 
            WHERE ima01 = g_tsh[l_ac].att00 AND imaag = lg_smy62
          IF l_count = 0 THEN
             CALL cl_err_msg('','aim-909',lg_smy62,0)
             NEXT FIELD att00          
          END IF
 
          #如果設置為不允許新增
#         IF g_sma.sma908 <> 'Y' THEN
             CALL t253_check_tsh03('imx00',l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
            #No.FUN-BB0086--add--begin--
            LET g_tsh[l_ac].tsh09 = s_digqty(g_tsh[l_ac].tsh09,g_tsh[l_ac].tsh07)
            LET g_tsh[l_ac].tsh12 = s_digqty(g_tsh[l_ac].tsh12,g_tsh[l_ac].tsh10)
            DISPLAY BY NAME g_tsh[l_ac].tsh09,g_tsh[l_ac].tsh12
            IF NOT cl_null(g_tsh[l_ac].tsh05) AND g_tsh[l_ac].tsh05<>0 THEN  #FUN-C20068
               IF NOT t253_tsh05_check() THEN
                  LET l_case = "tsh05"
               END IF 
            END IF                                                           #FUN-C20068
            IF NOT cl_null(g_tsh[l_ac].tsh06) AND g_tsh[l_ac].tsh06<>0 THEN  #FUN-C20068
               IF p_flag = '0' THEN                                                      #TQC-C20183
                  LET g_tsh[l_ac].tsh06=s_digqty(g_tsh[l_ac].tsh06,g_tsh[l_ac].tsh04)    #TQC-C20183
                  DISPLAY BY NAME g_tsh[l_ac].tsh06                                      #TQC-C20183
               ELSE                                                                      #TQC-C20183
                  IF NOT t253_tsh06_check() THEN
                     LET l_case = "tsh06"
                  END IF  
               END IF                                                        #TQC-C20183
            END IF                                                           #FUN-C20068
            #No.FUN-BB0086--add--end--
             IF l_check_res = '1' THEN NEXT FIELD att00 END IF
#         END IF
            #No.FUN-BB0086--add--begin--
            LET g_tsh04_t = g_tsh[l_ac].tsh04
            CASE l_case 
               WHEN "tsh05"
                  NEXT FIELD tsh05
               WHEN "tsh06"
                  NEXT FIELD tsh06
               OTHERWISE EXIT CASE 
            END CASE 
            #No.FUN-BB0086--add--end--
      
      AFTER FIELD att01
          CALL t253_check_att0x(g_tsh[l_ac].att01,1,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att01 END IF              
      AFTER FIELD att02
          CALL t253_check_att0x(g_tsh[l_ac].att02,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att02 END IF
      AFTER FIELD att03
          CALL t253_check_att0x(g_tsh[l_ac].att03,3,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att03 END IF
      AFTER FIELD att04
          CALL t253_check_att0x(g_tsh[l_ac].att04,4,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att04 END IF
      AFTER FIELD att05
          CALL t253_check_att0x(g_tsh[l_ac].att05,5,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att05 END IF          
      AFTER FIELD att06
          CALL t253_check_att0x(g_tsh[l_ac].att06,6,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att06 END IF
      AFTER FIELD att07
          CALL t253_check_att0x(g_tsh[l_ac].att07,7,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att07 END IF
      AFTER FIELD att08
          CALL t253_check_att0x(g_tsh[l_ac].att08,8,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att08 END IF
      AFTER FIELD att09
          CALL t253_check_att0x(g_tsh[l_ac].att09,9,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att09 END IF
      AFTER FIELD att10
          CALL t253_check_att0x(g_tsh[l_ac].att10,10,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att10 END IF
      #下面是十個輸入型屬性欄位的判斷語句
      AFTER FIELD att01_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att01_c,1,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att01_c END IF      
      AFTER FIELD att02_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att02_c,2,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att02_c END IF
      AFTER FIELD att03_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att03_c,3,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att03_c END IF
      AFTER FIELD att04_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att04_c,4,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att04_c END IF
      AFTER FIELD att05_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att05_c,5,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att05_c END IF
      AFTER FIELD att06_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att06_c,6,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att06_c END IF
      AFTER FIELD att07_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att07_c,7,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att07_c END IF
      AFTER FIELD att08_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att08_c,8,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att08_c END IF
      AFTER FIELD att09_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att09_c,9,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att09_c END IF
      AFTER FIELD att10_c
          CALL t253_check_att0x_c(g_tsh[l_ac].att10_c,10,l_ac,p_cmd) RETURNING #No.MOD-660090
               l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
          IF l_check_res = '1' THEN NEXT FIELD att10_c END IF
 
#      AFTER FIELD tsh03                                                   
#         IF NOT cl_null(g_tsh[l_ac].tsh03) THEN                       
#            SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_tsh[l_ac].tsh03
#            CALL t253_tsh03('a')
#            IF p_cmd='a' OR (p_cmd='u' AND g_tsh_t.tsh03<>g_tsh[l_ac].tsh03) THEN  
#               CALL t253_tsh03('a')
#               IF NOT cl_null(g_errno)  THEN                                              
#                  CALL cl_err(g_tsh[l_ac].tsh03,g_errno,1)                             
#                  LET g_tsh[l_ac].tsh03 = g_tsh_t.tsh03      
#                  DISPLAY BY NAME g_tsh[l_ac].tsh03                 
#                  NEXT FIELD tsh03                                     
#               END IF
#               CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
#               CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',l_dbs)
#                  RETURNING g_flag,g_img09,g_img10
#               IF g_flag = 1 THEN
#                  CALL cl_err('sel img:','axm-244',0)                                                                                
#                  NEXT FIELD tsh03
#               END IF
#               LET g_cnt = t253_mchk_img18(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',g_tsg.tsg17,l_dbs)                                                     
#               IF g_cnt > 0 THEN
#                 CALL cl_err('','aim-400',0)
#                 NEXT FIELD tsh07                                                                                                   
#              END IF
#               LET g_tsh[l_ac].tsh04 = g_ima25
#               CALL t253_qty_def()
#            END IF                                                           
#            IF g_sma.sma115 = 'Y' THEN
#               CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
#                  RETURNING g_flag,g_ima906,g_ima907
#               IF g_flag=1 THEN
#                  NEXT FIELD tsh03
#               END IF
#               IF g_ima906 = '1' THEN                #單一單位
#                  CALL cl_set_comp_entry("tsh10,tsh12",FALSE) 
#               END IF
#               IF g_ima906 = '3' THEN                #參考單位
#                  CALL cl_set_comp_entry("tsh10",FALSE) 
#               END IF
#               IF p_cmd='a' OR (p_cmd='u' AND g_tsh_t.tsh03<>g_tsh[l_ac].tsh03) THEN  
#                  LET g_tsh[l_ac].tsh07 = g_ima25
#                  LET g_tsh[l_ac].tsh10 = g_ima907
#               END IF
#               LET g_tsh_t.* = g_tsh[l_ac].*
#            END IF
#         END IF
#         CALL t253_set_required()
#No.TQC-650091  --end--
 
      AFTER FIELD tsh04
         LET l_case = ""   #No.FUN-BB0086
         IF NOT cl_null(g_tsh[l_ac].tsh04) THEN
            IF (g_tsh[l_ac].tsh04 != g_tsh_t.tsh04)            
               OR (g_tsh_t.tsh04 IS NULL) THEN                        
               SELECT COUNT(*) INTO g_cnt
                 FROM gfe_file
                WHERE gfe01 = g_tsh[l_ac].tsh04  
               IF g_cnt=0 THEN  
                  CALL cl_err(g_tsh[l_ac].tsh04,'mfg3377',0)                             
                  LET g_tsh[l_ac].tsh04 = g_tsh_t.tsh04      
                  DISPLAY BY NAME g_tsh[l_ac].tsh04                 
                  NEXT FIELD tsh04                                     
               END IF
               SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_tsh[l_ac].tsh03
               CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh04,g_ima25)
                  RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  LET g_tsh[l_ac].tsh04 = g_tsh_t.tsh04      
                  DISPLAY BY NAME g_tsh[l_ac].tsh04                 
                  NEXT FIELD tsh04
               END IF
               IF g_tsh[l_ac].tsh05 > 0 THEN
                  CALL t253_img10('0')
                  IF g_flag = 1 THEN
                     NEXT FIELD tsh05
                  END IF
               END IF
            END IF   
            #No.FUN-BB0086--add--begin--
            IF NOT cl_null(g_tsh[l_ac].tsh05) AND g_tsh[l_ac].tsh05<>0 THEN  #FUN-C20068
               IF NOT t253_tsh05_check() THEN
                  LET l_case = "tsh05"
               END IF 
            END IF                                                           #FUN-C20068
            IF NOT cl_null(g_tsh[l_ac].tsh06) AND g_tsh[l_ac].tsh06<>0 THEN  #FUN-C20068
               IF p_flag = '0' THEN                                                      #TQC-C20183
                  LET g_tsh[l_ac].tsh06=s_digqty(g_tsh[l_ac].tsh06,g_tsh[l_ac].tsh04)    #TQC-C20183
                  DISPLAY BY NAME g_tsh[l_ac].tsh06                                      #TQC-C20183
               ELSE                                                                      #TQC-C20183
                  IF NOT t253_tsh06_check() THEN
                     LET l_case = "tsh06"
                  END IF 
               END IF                                                        #TQC-C20183
            END IF                                                           #FUN-C20068
            LET g_tsh04_t = g_tsh[l_ac].tsh04
            CASE l_case 
               WHEN "tsh05"
                  NEXT FIELD tsh05
               WHEN "tsh06"
                  NEXT FIELD tsh06
               OTHERWISE EXIT CASE 
            END CASE 
            #No.FUN-BB0086--add--end--
         END IF  
 
      AFTER FIELD tsh05
         IF NOT t253_tsh05_check() THEN NEXT FIELD tsh05 END IF   #No.FUN-BB0086
         #No.FUN-BB0086--mark--begin--
         #IF NOT cl_null(g_tsh[l_ac].tsh05) THEN                       
         #   IF g_tsh[l_ac].tsh05<=0 THEN
         #      CALL cl_err('g_tsh[l_ac].tsh05','mfg4012',0)
         #      LET g_tsh[l_ac].tsh05 = g_tsh_t.tsh05      
         #      DISPLAY BY NAME g_tsh[l_ac].tsh05                 
         #      NEXT FIELD tsh05                                     
         #   END IF
         #   CALL t253_img10('0')
         #   IF g_flag = 1 THEN
         #      NEXT FIELD tsh05
         #   END IF
         #END IF
         #No.FUN-BB0086--mark--end--
         
      BEFORE FIELD tsh10
         CALL t253_set_no_required()
 
      AFTER FIELD tsh10
         IF NOT cl_null(g_tsh[l_ac].tsh10) THEN
            IF (g_tsh[l_ac].tsh10 != g_tsh_t.tsh10)            
               OR (g_tsh_t.tsh10 IS NULL) THEN                        
               SELECT COUNT(*) INTO g_cnt
                 FROM gfe_file
                WHERE gfe01 = g_tsh[l_ac].tsh10  
               IF g_cnt=0 THEN
                  CALL cl_err(g_tsh[l_ac].tsh10,'mfg3377',0)                             
                  LET g_tsh[l_ac].tsh10 = g_tsh_t.tsh10      
                  DISPLAY BY NAME g_tsh[l_ac].tsh10              
                  NEXT FIELD tsh10                                     
               END IF
               SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_tsg.tsg06
               CALL s_mchk_imgg(g_tsh[l_ac].tsh03,g_tsg.tsg07,
                               #'','',g_tsh[l_ac].tsh10,l_dbs) #FUN-980094 mark
                                '','',g_tsh[l_ac].tsh10,g_tsg.tsg06) #FUN-980094 add
                  RETURNING g_flag
               IF g_flag = 1 THEN
                  CALL cl_err('sel imgg:','axm-244',0)
                  CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
                     RETURNING g_flag,g_ima906,g_ima907
                  IF g_ima906 = '2' THEN
                     NEXT FIELD tsh10
                  ELSE
                     NEXT FIELD tsh03
                  END IF 
               END IF
               SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_tsh[l_ac].tsh03
               CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh10,g_ima25)
                  RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  LET g_tsh[l_ac].tsh10 = g_tsh_t.tsh10      
                  DISPLAY BY NAME g_tsh[l_ac].tsh10                 
                  NEXT FIELD tsh10
               END IF
               LET g_tsh[l_ac].tsh11 = l_fac                                                                                                            
               IF (g_tsh[l_ac].tsh11 != g_tsh_t.tsh11) THEN
                  IF g_ima906 = '2' THEN                #母子單位
                     LET l_tsh12 = g_tsh[l_ac].tsh11*g_tsh[l_ac].tsh12
                     IF g_tsh[l_ac].tsh09 > 0 THEN
                        LET l_tsh09 = g_tsh[l_ac].tsh09 * g_tsh[l_ac].tsh08
                     END IF
                  END IF
               END IF
               IF g_tsh[l_ac].tsh12 > 0 THEN
                  CALL t253_imgg10('0')
                  IF g_flag = 1 THEN
                     NEXT FIELD tsh12
                  END IF
               END IF
            END IF   
            #No.FUN-BB0086--add--begin--
            LET g_tsh[l_ac].tsh12 = s_digqty(g_tsh[l_ac].tsh12,g_tsh[l_ac].tsh10)
            DISPLAY BY NAME g_tsh[l_ac].tsh12
            #No.FUN-BB0086--add--end-- 
         ELSE
            LET l_tsh12 = 0
         END IF  
         CALL t253_set_required()
         CALL cl_show_fld_cont() 
 
      BEFORE FIELD tsh12
         SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_tsh[l_ac].tsh03
         CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh10,g_ima25)
            RETURNING g_cnt,l_fac
         LET g_tsh[l_ac].tsh11 = l_fac
         IF NOT cl_null(g_tsh[l_ac].tsh10) THEN
            IF (g_tsh[l_ac].tsh10 != g_tsh_t.tsh10)            
               OR (g_tsh_t.tsh10 IS NULL) THEN 
               SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_tsg.tsg06
               CALL s_mchk_imgg(g_tsh[l_ac].tsh03,g_tsg.tsg07,
                               #'','',g_tsh[l_ac].tsh10,l_dbs) #FUN-980094 mark
                                '','',g_tsh[l_ac].tsh10,g_tsg.tsg06) #FUN-980094 add
                  RETURNING g_flag
               IF g_flag = 1 THEN
                  CALL cl_err('sel imgg:','axm-244',0)
                  CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
                     RETURNING g_flag,g_ima906,g_ima907
                  IF g_ima906 = '2' THEN
                     NEXT FIELD tsh10
                  ELSE
                     NEXT FIELD tsh03
                  END IF 
               END IF
            END IF                                                                          
         END IF 
         
      AFTER FIELD tsh12
         IF NOT t253_tsh12_check(l_tsh09,l_tsh12,l_fac) THEN NEXT FIELD tsh12 END IF   #No.FUN-BB0086
         #No.FUN-BB0086--add--begin--
         #IF NOT cl_null(g_tsh[l_ac].tsh12) THEN                       
         #   IF g_tsh[l_ac].tsh12<=0 THEN
         #      CALL cl_err('g_tsh[l_ac].tsh12','mfg4012',0)
         #      LET g_tsh[l_ac].tsh12 = g_tsh_t.tsh12      
         #      DISPLAY BY NAME g_tsh[l_ac].tsh12                 
         #      NEXT FIELD tsh12                                     
         #   END IF
         #   CALL t253_imgg10('0')
         #   IF g_flag = 1 THEN
         #      NEXT FIELD tsh12
         #   END IF
         #   IF g_ima906 = '2' THEN                #母子單位
         #      LET l_tsh12 = g_tsh[l_ac].tsh11*g_tsh[l_ac].tsh12
         #      IF g_tsh[l_ac].tsh09 > 0 THEN
         #         LET l_tsh09 = g_tsh[l_ac].tsh09 * g_tsh[l_ac].tsh08
         #      END IF
         #   END IF
         #   #carrier  --Begin
         #  #IF p_cmd = 'a' THEN
         #      IF g_ima906='3' THEN
         #         IF cl_null(g_tsh[l_ac].tsh09) OR g_tsh[l_ac].tsh09=0 OR
         #            g_tsh[l_ac].tsh12 <> g_tsh_t.tsh12 OR cl_null(g_tsh_t.tsh12)
         #         THEN
         #            LET l_fac = 1
         #            CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh10,
         #                           g_tsh[l_ac].tsh07)
         #                 RETURNING g_cnt,l_fac
         #            IF g_cnt = 1 THEN
         #            ELSE
         #              #LET g_tsh[l_ac].tsh09=g_tsh[l_ac].tsh12*g_tsh[l_ac].tsh11
         #               LET g_tsh[l_ac].tsh09=g_tsh[l_ac].tsh12*l_fac
         #            END IF
         #            DISPLAY BY NAME g_tsh[l_ac].tsh09                 
         #         END IF
         #      END IF
         #   #END IF
         #   #carrier  --End  
         #END IF
         #No.FUN-BB0086--add--end--
 
      BEFORE FIELD tsh07
         CALL t253_set_no_required()
 
      AFTER FIELD tsh07
         #No.FUN-BB0086--add--begin--
         LET l_tf = ""
         LET l_case = ""
         #No.FUN-BB0086--add--end--
         IF NOT cl_null(g_tsh[l_ac].tsh07) THEN
            IF (g_tsh[l_ac].tsh07 != g_tsh_t.tsh07)            
               OR (g_tsh_t.tsh07 IS NULL) THEN                        
               SELECT COUNT(*) INTO g_cnt
                 FROM gfe_file
                WHERE gfe01 = g_tsh[l_ac].tsh07  
               IF g_cnt=0 THEN
                  CALL cl_err(g_tsh[l_ac].tsh07,'mfg3377',0)                             
                  LET g_tsh[l_ac].tsh07 = g_tsh_t.tsh07      
                  DISPLAY BY NAME g_tsh[l_ac].tsh07              
                  NEXT FIELD tsh07                                     
               END IF
               SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_tsg.tsg06
               CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
                  RETURNING g_flag,g_ima906,g_ima907
               IF g_ima906 = '2' THEN
                  CALL s_mchk_imgg(g_tsh[l_ac].tsh03,g_tsg.tsg07,
                                  #'','',g_tsh[l_ac].tsh07,l_dbs) #FUN-980094 mark
                                   '','',g_tsh[l_ac].tsh07,g_tsg.tsg06) #FUN-980094 add
                     RETURNING g_flag
               ELSE
                  CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
                  #CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',l_dbs) #FUN-980093 mark
                  CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',g_tsg.tsg06) #FUN-980093 add
                     RETURNING g_flag,g_img09,g_img10
               END IF
               IF g_flag = 1 THEN
                  CALL cl_err('sel imgg:','axm-244',0)
                  NEXT FIELD tsh07                                                                                
               END IF
               SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_tsh[l_ac].tsh03
               CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh07,g_ima25)
                  RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  LET g_tsh[l_ac].tsh07 = g_tsh_t.tsh07      
                  DISPLAY BY NAME g_tsh[l_ac].tsh07                 
                  NEXT FIELD tsh07
               END IF
               LET g_tsh[l_ac].tsh08 = l_fac
               IF cl_null(g_tsh[l_ac].tsh08) THEN LET g_tsh[l_ac].tsh08 = 1 END IF
               IF (g_tsh[l_ac].tsh08 != g_tsh_t.tsh08) THEN
                  LET l_tsh09 = g_tsh[l_ac].tsh08*g_tsh[l_ac].tsh09 
                  CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
                     RETURNING g_flag,g_ima906,g_ima907
                  IF g_ima906 = '2' THEN
                     IF g_tsh[l_ac].tsh12 > 0 THEN
                        LET l_tsh12 = g_tsh[l_ac].tsh12 * g_tsh[l_ac].tsh11
                     END IF
                  ELSE
                     LET l_tsh12 = 0
                  END IF
               END IF
               #carrier  --Begin
               IF g_ima906 = '3' THEN
                  IF cl_null(g_tsh[l_ac].tsh09) OR g_tsh[l_ac].tsh09=0 OR
                     g_tsh[l_ac].tsh07 <> g_tsh_t.tsh07 THEN
                     LET l_fac = 1
                     CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh10,
                                    g_tsh[l_ac].tsh07)
                          RETURNING g_cnt,l_fac
                     IF g_cnt = 1 THEN
                     ELSE
                        LET g_tsh[l_ac].tsh09=g_tsh[l_ac].tsh12*l_fac
                     END IF
                     DISPLAY BY NAME g_tsh[l_ac].tsh09                 
                  END IF
               END IF
               #carrier  --End  
               IF g_tsh[l_ac].tsh09 > 0 THEN
                  IF g_ima906 = '2' THEN
                     CALL t253_imgg10('1')
                  ELSE
                     CALL t253_img10('1')
                  END IF
                  IF g_flag = 1 THEN
                     NEXT FIELD tsh09
                  END IF
               END IF
            END IF
            #No.FUN-BB0086--add--begin--     
            IF NOT cl_null(g_tsh[l_ac].tsh09) AND g_tsh[l_ac].tsh09<>0 THEN  #FUN-C20068
               CALL t253_tsh09_check(l_tsh09,l_tsh12) RETURNING l_tf,l_case 
            END IF                                                           #FUN-C20068
            LET g_tsh07_t = g_tsh[l_ac].tsh07
            IF NOT l_tf THEN 
               CASE l_case 
                  WHEN "tsh09"
                     NEXT FIELD tsh09
                  WHEN "tsh07"
                     NEXT FIELD tsh07
                  OTHERWISE EXIT CASE 
                END CASE 
            END IF 
            #No.FUN-BB0086--add--end--       
         ELSE
            LET l_tsh09 = 0
         END IF  
         CALL t253_set_required()
         CALL cl_show_fld_cont() 
 
      BEFORE FIELD tsh09
         SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_tsh[l_ac].tsh03
         CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh07,g_ima25)
            RETURNING g_cnt,l_fac
         LET g_tsh[l_ac].tsh08 = l_fac
 
      AFTER FIELD tsh09
         #No.FUN-BB0086--add--begin--
         LET l_case = ""
         LET l_tf = ""
         CALL t253_tsh09_check(l_tsh09,l_tsh12) RETURNING l_tf,l_case 
         IF NOT l_tf THEN 
            CASE l_case 
               WHEN "tsh09"
                  NEXT FIELD tsh09
               WHEN "tsh07"
                  NEXT FIELD tsh07
               OTHERWISE EXIT CASE 
            END CASE 
         END IF 
         #No.FUN-BB0086--add--end--
         #No.FUN-BB0086--mark--begin--
         #IF NOT cl_null(g_tsh[l_ac].tsh09) THEN                       
         #   IF g_tsh[l_ac].tsh09<=0 THEN
         #      CALL cl_err('g_tsh[l_ac].tsh09','mfg4012',0)
         #      LET g_tsh[l_ac].tsh09 = g_tsh_t.tsh09      
         #      DISPLAY BY NAME g_tsh[l_ac].tsh09                 
         #      NEXT FIELD tsh09                
         #   END IF
         #   CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
         #      RETURNING g_flag,g_ima906,g_ima907
         #   IF g_ima906 = '2' THEN
         #      CALL t253_imgg10('1')
         #   ELSE
         #      CALL t253_img10('1')
         #   END IF
         #   IF g_flag = 1 THEN
         #      NEXT FIELD tsh09
         #   END IF 
         #   IF cl_null(g_tsh[l_ac].tsh08) THEN LET g_tsh[l_ac].tsh08 = 1 END IF
         #   LET l_tsh09 = g_tsh[l_ac].tsh08*g_tsh[l_ac].tsh09 
         #   CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
         #      RETURNING g_flag,g_ima906,g_ima907
         #   IF g_ima906 = '2' THEN
         #      IF g_tsh[l_ac].tsh12 > 0 THEN
         #         LET l_tsh12 = g_tsh[l_ac].tsh12 * g_tsh[l_ac].tsh11
         #      END IF
         #   ELSE
         #      LET l_tsh12 = 0
         #   END IF
         #   CALL t253_du_data_to_correct()
         #   LET g_tsh[l_ac].tsh05 = l_tsh12 + l_tsh09
         #   IF g_tsh[l_ac].tsh05 IS NULL OR g_tsh[l_ac].tsh05=0 THEN
         #      IF g_ima906 MATCHES '[23]' THEN
         #         NEXT FIELD tsh09
         #      ELSE
         #         NEXT FIELD tsh07
         #      END IF
         #   END IF
         #ELSE
         #   LET l_tsh09 = 0
         #END IF
         #CALL cl_show_fld_cont()
         #No.FUN-BB0086--mark--end--
   
      BEFORE FIELD tsh06
         IF cl_null(g_tsh[l_ac].tsh06) THEN
            LET g_tsh[l_ac].tsh06 = g_tsh[l_ac].tsh05 
            DISPLAY BY NAME g_tsh[l_ac].tsh06                 
         END IF
 
      AFTER FIELD tsh06   
         IF NOT t253_tsh06_check() THEN NEXT FIELD tsh06 END IF   #No.FUN-BB0086
         #No.FUN-BB0086--mark--begin--      
         #IF NOT cl_null(g_tsh[l_ac].tsh06) THEN                       
         #   IF (g_tsh[l_ac].tsh06 != g_tsh_t.tsh06)            
         #      OR (g_tsh_t.tsh06 IS NULL) THEN                        
         #      IF g_tsh[l_ac].tsh06<=0 THEN                           
         #         CALL cl_err('g_tsh[l_ac].tsh06','mfg4012',0)                             
         #         LET g_tsh[l_ac].tsh06 = g_tsh_t.tsh06      
         #         DISPLAY BY NAME g_tsh[l_ac].tsh06                 
         #         NEXT FIELD tsh06                                     
         #      END IF                                                       
         #   END IF                                                           
         #END IF
         #No.FUN-BB0086--mark--end--  
         
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tsh[l_ac].* TO NULL      #900423
         INITIALIZE arr_detail[l_ac].* TO NULL #No.TQC-650091
         LET g_tsh[l_ac].tsh05 =  0            #Body default
         LET g_tsh[l_ac].tsh12 =  0            #Body default
         LET g_tsh[l_ac].tsh09 =  0            #Body default
         LET g_tsh_t.* = g_tsh[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         CALL t253_set_entry_b(p_cmd)
         CALL t253_set_no_entry_b(p_cmd)
         NEXT FIELD tsh02
 
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_success = 'N'
            CANCEL INSERT
         END IF
         IF g_sma.sma115 = 'Y' THEN
            CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
               RETURNING g_flag,g_ima906,g_ima907
            IF g_flag=1 THEN
               NEXT FIELD tsh03
            END IF
            CALL t253_du_data_to_correct()
            #carrier  --Begin
            CALL t253_set_origin_field()
            #carrier  --End   
         END IF
         #carrier --Begin
        #IF l_tsh09 >0 OR l_tsh12 >  0 THEN
        #   LET g_tsh[l_ac].tsh05 = l_tsh09 + l_tsh12
        #END IF
         #carrier --End    
         INSERT INTO tsh_file(tsh01,tsh02,tsh03,tsh04,
                              tsh05,tsh06,tsh07,tsh08,
                              tsh09,tsh10,tsh11,tsh12,tsh13,
                              tshplant,tshlegal) #FUN-980009
                       VALUES(g_tsg.tsg01,g_tsh[l_ac].tsh02,g_tsh[l_ac].tsh03,
                              g_tsh[l_ac].tsh04,g_tsh[l_ac].tsh05,g_tsh[l_ac].tsh06,
                              g_tsh[l_ac].tsh07,g_tsh[l_ac].tsh08,g_tsh[l_ac].tsh09,
                              g_tsh[l_ac].tsh10,g_tsh[l_ac].tsh11,g_tsh[l_ac].tsh12,
                              g_tsh[l_ac].tsh13,
                              g_plant,g_legal)   #FUN-980009
         IF SQLCA.sqlcode THEN
         #  CALL cl_err(g_tsh[l_ac].tsh02,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("ins","tsh_file",g_tsh[l_ac].tsh02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            CALL t253_weight_cubage('0')
            LET g_rec_b = g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      BEFORE DELETE                            #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF g_tsh_t.tsh02 > 0 AND g_tsh_t.tsh02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tsh_file
             WHERE tsh01 = g_tsg.tsg01
               AND tsh02 = g_tsh_t.tsh02
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_tsh_t.tsh02,SQLCA.sqlcode,0)   #No.FUN-660104
               CALL cl_err3("del","tsh_file",g_tsh_t.tsh02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            CALL t253_weight_cubage('0')
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_success = 'N'
            LET g_tsh[l_ac].* = g_tsh_t.*
            CLOSE t253_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tsh[l_ac].tsh02,-263,1)
            LET g_tsh[l_ac].* = g_tsh_t.*
         ELSE
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
                  RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD tsh03
               END IF
               CALL t253_du_data_to_correct()
               #carrier  --Begin
               CALL t253_set_origin_field()
               #carrier  --End   
            END IF
            IF cl_null(g_tsh[l_ac].tsh02) THEN    #重要欄位空白,無效
               INITIALIZE g_tsh[l_ac].* TO NULL
            END IF
            #carrier --Begin
           #IF l_tsh09 >0 OR l_tsh12 >  0 THEN
           #   LET g_tsh[l_ac].tsh05 = l_tsh09 + l_tsh12
           #END IF
            #carrier --End  
            UPDATE tsh_file SET tsh02=g_tsh[l_ac].tsh02,
                                tsh13=g_tsh[l_ac].tsh13,
                                tsh03=g_tsh[l_ac].tsh03,
                                tsh04=g_tsh[l_ac].tsh04,
                                tsh05=g_tsh[l_ac].tsh05,
                                tsh10=g_tsh[l_ac].tsh10,
                                tsh11=g_tsh[l_ac].tsh11,
                                tsh12=g_tsh[l_ac].tsh12,
                                tsh07=g_tsh[l_ac].tsh07,
                                tsh08=g_tsh[l_ac].tsh08,
                                tsh09=g_tsh[l_ac].tsh09,
                                tsh06=g_tsh[l_ac].tsh06
                          WHERE tsh01=g_tsg.tsg01
                            AND tsh02=g_tsh_t.tsh02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_tsh[l_ac].* = g_tsh_t.*
                DISPLAY g_tsh[l_ac].* TO s_tsh[l_sl].*
            ELSE
                MESSAGE 'UPDATE O.K'
                CALL t253_weight_cubage('0')
                COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_success = 'N'
            IF p_cmd = 'u' THEN
               LET g_tsh[l_ac].* = g_tsh_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_tsh.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE t253_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D30033 add
        #FUN-D30033---mark---begin---
        #IF p_flag = '1' THEN
        #   SELECT COUNT(*) INTO g_cnt 
        #     FROM tsh_file
        #    WHERE tsh01 = g_tsg.tsg01
        #      AND tsh06 > 0
        #   IF g_cnt < g_rec_b THEN
        #      LET l_ac = l_ac + 1
        #      CALL t253_b('1')
        #   END IF
        #   IF l_ac = g_rec_b THEN
        #      RETURN
        #   END IF
        #END IF
        #FUN-D30033---mark---end---
         CLOSE t253_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO 
         IF INFIELD(tsh02) AND l_ac > 1 THEN
            LET g_tsh[l_ac].* = g_tsh[l_ac-1].*
            LET g_tsh[l_ac].tsh02 = 0
            NEXT FIELD tsh02
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            #No.TQC-650091  --begin--
            #新增的母料件開窗
            #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
            #BEFORE FIELD att00來做開窗了            
            #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
            WHEN INFIELD(att00)
               #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_ima_p"
#              LET g_qryparam.arg1 = lg_group
#              CALL cl_create_qry() RETURNING g_tsh[l_ac].att00
               CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group,"","","","",'' ) 
                   RETURNING  g_tsh[l_ac].att00 
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_tsh[l_ac].att00      
               NEXT FIELD att00              
            #No.TQC-650091  --end--
            WHEN INFIELD(tsh13)
               CALL cl_init_qry_var()
#No.FUN-6B0065 --begin                                                                                                          
#              LET g_qryparam.form  = "q_tqe1"
#              LET g_qryparam.where = " tqe03='4' "
               LET g_qryparam.form  = "q_azf1"
#              LET g_qryparam.where = " azf09='4' "      #No.TQC-740039
               LET g_qryparam.where = " azf09='4' AND azf02 = '2'"     #No.TQC-740039
#No.FUN-6B0065 --end
               CALL cl_create_qry() RETURNING g_tsh[l_ac].tsh13
               DISPLAY BY NAME g_tsh[l_ac].tsh13
               NEXT FIELD tsh03
            WHEN INFIELD(tsh03)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  = "q_ima" 
#              CALL cl_create_qry() RETURNING g_tsh[l_ac].tsh03
               CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                RETURNING   g_tsh[l_ac].tsh03
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_tsh[l_ac].tsh03 
               NEXT FIELD tsh03
            WHEN INFIELD(tsh04)                                         
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gfe" 
               CALL cl_create_qry() RETURNING g_tsh[l_ac].tsh04      
               DISPLAY BY NAME g_tsh[l_ac].tsh04
               NEXT FIELD tsh04  
            WHEN INFIELD(tsh10)                                       
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gfe" 
               CALL cl_create_qry() RETURNING g_tsh[l_ac].tsh10
               DISPLAY BY NAME g_tsh[l_ac].tsh10
               NEXT FIELD tsh10
            WHEN INFIELD(tsh07)                                         
               CALL cl_init_qry_var()                                       
               LET g_qryparam.form  = "q_gfe" 
               CALL cl_create_qry() RETURNING g_tsh[l_ac].tsh07
               DISPLAY BY NAME g_tsh[l_ac].tsh07
               NEXT FIELD tsh07
         END CASE
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
   END INPUT
 
   CLOSE t253_bcl
   COMMIT WORK
#  CALL t253_delall() #CHI-C30002 mark
   CALL t253_delHeader()     #CHI-C30002 add
   CALL t253_weight_cubage('0')
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t253_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tsg.tsg01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tsg_file ",
                  "  WHERE tsg01 LIKE '",l_slip,"%' ",
                  "    AND tsg01 > '",g_tsg.tsg01,"'"
      PREPARE t253_pb1 FROM l_sql 
      EXECUTE t253_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t253_v('0')
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  tsg_file WHERE tsg01 = g_tsg.tsg01
         INITIALIZE g_tsg.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#CHI-C30002 -------- mark -------- begin
#FUNCTION t253_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM tsh_file
#   WHERE tsh01 = g_tsg.tsg01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM tsg_file WHERE tsg01 = g_tsg.tsg01
#     INITIALIZE g_tsg.* TO NULL
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t253_tsh03(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_imaacti   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
   LET g_errno = ''
   #顯示品名
   SELECT ima02,ima135,ima25,imaacti
     INTO g_tsh[l_ac].ima02,g_tsh[l_ac].ima135,g_ima25,l_imaacti
     FROM ima_file
    WHERE ima01=g_tsh[l_ac].tsh03
    
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = STATUS  
                                  LET g_tsh[l_ac].ima02 ='' 
                                  LET g_tsh[l_ac].ima135 ='' 
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'  #No.FUN-690022 add
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      LET g_tsh[l_ac].ima02 = g_tsh_t.ima02
      LET g_tsh[l_ac].ima135 = g_tsh_t.ima135
   END IF
   DISPLAY g_tsh[l_ac].ima02  TO FORMONLY.ima02
   DISPLAY g_tsh[l_ac].ima135  TO FORMONLY.ima135 
 
END FUNCTION
 
FUNCTION t253_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   IF cl_null(p_wc2) THEN 
      LET p_wc2 = "  1=1"
   END IF 
   LET g_sql = " SELECT tsh02,tsh13,tsh03,'','','','','','','','','','','','','','','','','','','','','','','',tsh04,tsh05, ", #No.TQC-650091 ADD 21個''
               "        tsh10,tsh11,tsh12,tsh07,tsh08,tsh09,tsh06 ",
               "   FROM tsh_file ",
               "  WHERE tsh01 = '",g_tsg.tsg01,"' ",
               "    AND ",p_wc2 CLIPPED,
               "  ORDER BY tsh02"
   PREPARE t253_pb FROM g_sql
   DECLARE tsh_curs CURSOR FOR t253_pb
 
   CALL g_tsh.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH tsh_curs INTO g_tsh[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02,ima135
        INTO g_tsh[g_cnt].ima02,g_tsh[g_cnt].ima135
        FROM ima_file
       WHERE ima01=g_tsh[g_cnt].tsh03
 
      #No.TQC-650091  --begin--    
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_tsh[g_cnt].att00,g_tsh[g_cnt].att01,g_tsh[g_cnt].att02,
                g_tsh[g_cnt].att03,g_tsh[g_cnt].att04,g_tsh[g_cnt].att05,
                g_tsh[g_cnt].att06,g_tsh[g_cnt].att07,g_tsh[g_cnt].att08,
                g_tsh[g_cnt].att09,g_tsh[g_cnt].att10
         FROM imx_file WHERE imx000 = g_tsh[g_cnt].tsh03
 
         LET g_tsh[g_cnt].att01_c = g_tsh[g_cnt].att01
         LET g_tsh[g_cnt].att02_c = g_tsh[g_cnt].att02
         LET g_tsh[g_cnt].att03_c = g_tsh[g_cnt].att03
         LET g_tsh[g_cnt].att04_c = g_tsh[g_cnt].att04
         LET g_tsh[g_cnt].att05_c = g_tsh[g_cnt].att05
         LET g_tsh[g_cnt].att06_c = g_tsh[g_cnt].att06
         LET g_tsh[g_cnt].att07_c = g_tsh[g_cnt].att07
         LET g_tsh[g_cnt].att08_c = g_tsh[g_cnt].att08
         LET g_tsh[g_cnt].att09_c = g_tsh[g_cnt].att09
         LET g_tsh[g_cnt].att10_c = g_tsh[g_cnt].att10
                
      END IF
      #No.TQC-650091  --end--      
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
   CALL g_tsh.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
 
   CALL t253_refresh_detail() #No.TQC-650091
END FUNCTION
 
FUNCTION t253_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tsh TO s_tsh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL t253_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION previous
         CALL t253_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION jump 
         CALL t253_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
 
      ON ACTION next
         CALL t253_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION last 
         CALL t253_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CALL t253_def_form()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
         
      #@ON ACTION 審核
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      #@ON ACTION 取消審核
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION blank                                                                                                          
         LET g_action_choice="blank"                                                                                                 
         EXIT DISPLAY
         
      ON ACTION undo_blank                                                                                                          
         LET g_action_choice="undo_blank"                                                                                                 
         EXIT DISPLAY
         
      ON ACTION post                                                                                                          
         LET g_action_choice="post"                                                                                                 
         EXIT DISPLAY
         
      ON ACTION undo_post                                                                                                          
         LET g_action_choice="undo_post"                                                                                                 
         EXIT DISPLAY
         
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t253_copy()
   DEFINE l_newno         LIKE tsg_file.tsg01,
          l_oldno         LIKE tsg_file.tsg01
   DEFINE li_result       LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tsg.tsg05='4' THEN CALL cl_err('','9024',0) RETURN END IF
 
   LET g_before_input_done = FALSE                                        
   CALL t253_set_entry('a')
 
   LET l_oldno = g_tsg.tsg01
   LET l_newno = NULL
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT l_newno FROM tsg01
      BEFORE INPUT
         CALL cl_set_docno_format("tsg01")
 
      AFTER FIELD tsg01
         CALL s_check_no("aim",l_newno,"","E","tsg_file","tsg01","")
            RETURNING li_result,l_newno
         DISPLAY l_newno TO tsg01
         IF (NOT li_result) THEN
            LET g_tsg.tsg01 = g_tsg_o.tsg01
            NEXT FIELD tsg01
         END IF
         BEGIN WORK
         CALL s_auto_assign_no("aim",l_newno,g_today,"E","tsg_file","tsg01","","","")
            RETURNING li_result,l_newno
         IF (NOT li_result) THEN
            NEXT FIELD tsg01
         END IF
         DISPLAY l_newno TO tsg01
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tsg01) #單據編號
               LET g_t1 = s_get_doc_no(l_newno) 
              #CALL q_smy(FALSE,FALSE,g_t1,'aim','E') RETURNING g_t1  #TQC-670008
               CALL q_smy(FALSE,FALSE,g_t1,'AIM','E') RETURNING g_t1  #TQC-670008
               LET l_newno = g_t1 
               DISPLAY BY NAME l_newno
               NEXT FIELD tsg01
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
    
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_tsg.tsg01 
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM tsg_file         #單頭復制
    WHERE tsg01=g_tsg.tsg01
     INTO TEMP y
 
   UPDATE y SET tsg01=l_newno,    #新的鍵值
                tsg05='1',
                tsg19='0',
                tsguser=g_user,   #資料所有者
                tsggrup=g_grup,   #資料所有者所屬群
                tsgmodu=NULL,     #資料修改日期
                tsgdate=g_today,  #資料建立日期
                tsgacti='Y'       #有效資料
 
   INSERT INTO tsg_file
      SELECT * FROM y
 
   DROP TABLE x
 
   SELECT * FROM tsh_file         #單身復制
    WHERE tsh01=g_tsg.tsg01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
   #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
      CALL cl_err3("ins","x",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      RETURN
   END IF
 
   UPDATE x SET tsh01=l_newno
 
   INSERT INTO tsh_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","tsh_file",l_newno,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104      #FUN-B80061   ADD
      ROLLBACK WORK 
   #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
   #   CALL cl_err3("ins","tsh_file",l_newno,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104     #FUN-B80061   MARK
      RETURN
   ELSE
      COMMIT WORK 
   END IF
        
   LET l_oldno = g_tsg.tsg01
   SELECT tsg_file.* INTO g_tsg.* FROM tsg_file WHERE tsg01 = l_newno
   CALL t253_u()
   CALL t253_b('0')
   #SELECT tsg_file.* INTO g_tsg.* FROM tsg_file WHERE tsg01 = l_oldno  #FUN-C80046
   #CALL t253_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t253_azp(l_azp01)
   DEFINE l_azp01  LIKE azp_file.azp01,
          l_azp03  LIKE azp_file.azp03,
          l_dbs    LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
 
    LET g_errno=' '
    SELECT azp03 INTO l_azp03 FROM azp_file 
     WHERE azp01=l_azp01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   #LET l_dbs = s_dbstring(l_azp03 CLIPPED) #TQC-940184  
    LET l_dbs = s_dbstring(l_azp03 CLIPPED)  #TQC-940184     
    RETURN l_dbs
END FUNCTION
 
#FUNCTION t253_imd(p_imd01,p_dbs)  #FUN-980093 mark
FUNCTION t253_imd(p_imd01,p_plant) #FUN-980093 add
  DEFINE p_imd01   LIKE imd_file.imd01,
         l_imd11   LIKE imd_file.imd11,
         l_imdacti LIKE imd_file.imdacti,
         p_dbs     LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
         l_sql     LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(400)
  DEFINE l_dbs     LIKE azp_file.azp03   #FUN-980093 add
  DEFINE l_azp03   LIKE azp_file.azp03   #FUN-980093 add
  DEFINE p_plant   LIKE azp_file.azp01   #FUN-980093 add
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant  #FUN-A50102
      #LET p_dbs = s_dbstring(l_azp03)                                #FUN-A50102
 
      LET g_plant_new = p_plant
      #CALL s_gettrandbs()        #FUN-A50102
      #LET l_dbs = g_dbs_tra      #FUN-A50102
   END IF
   #--End   FUN-980093 add-------------------------------------
 
   LET g_errno=''
   #LET l_sql = "SELECT imd11,imdacti FROM ",p_dbs CLIPPED,"imd_file",
   LET l_sql = "SELECT imd11,imdacti FROM ",cl_get_target_table( p_plant, 'imd_file' ), #FUN-A50102
               " WHERE imd01 = '",p_imd01,"'",
               "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre FROM l_sql
   DECLARE imd_cs CURSOR FOR imd_pre
   OPEN imd_cs
   FETCH imd_cs INTO l_imd11,l_imdacti
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
        WHEN l_imd11 = 'N' OR l_imdacti = 'N' 
           LET g_errno = 'axm-993'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE imd_cs
   IF cl_null(g_errno) THEN 
      LET g_sw = 0
   ELSE 
      LET g_sw = 1
   END IF 
   
   RETURN g_sw 
END FUNCTION
 
#FUNCTION t253_imd02(p_imd01,p_dbs) #FUN-980093 mark
FUNCTION t253_imd02(p_imd01,p_plant) #FUN-980093 add
   DEFINE p_imd01   LIKE imd_file.imd01,
          l_imd02   LIKE imd_file.imd02,
          p_dbs     LIKE type_file.chr21,        #No.FUN-680120 VARCHAR(21)
          l_sql     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   DEFINE l_dbs     LIKE azp_file.azp03  #FUN-980093 add
   DEFINE l_azp03   LIKE azp_file.azp03  #FUN-980093 add
   DEFINE p_plant   LIKE azp_file.azp01  #FUN-980093 add
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant #FUN-A50102
      #LET p_dbs = s_dbstring(l_azp03)                               #FUN-A50102
 
      LET g_plant_new = p_plant
      #CALL s_gettrandbs()     #FUN-A50102
      #LET l_dbs = g_dbs_tra   #FUN-A50102
   END IF
   #--End   FUN-980093 add-------------------------------------
 
   LET g_errno=''
   LET l_sql = "SELECT imd02 ",
               #"  FROM ",p_dbs CLIPPED,"imd_file",
               "  FROM ",cl_get_target_table( p_plant, 'imd_file' ),  #FUN-A50102
               " WHERE imd01 = '",p_imd01,"'",
               "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre1 FROM l_sql
   DECLARE imd_cs1 CURSOR FOR imd_pre1
   OPEN imd_cs1
   FETCH imd_cs1 INTO l_imd02
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CLOSE imd_cs1
   IF NOT cl_null(g_errno) THEN 
      LET l_imd02 = NULL
   END IF 
 
   RETURN l_imd02 
END FUNCTION
 
FUNCTION t253_tsg08(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,gen03,genacti 
     INTO g_gen02,l_gen03,l_genacti 
     FROM gen_file
    WHERE gen01 = g_tsg.tsg08
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF p_cmd = 'a' AND cl_null(g_errno) THEN
      LET g_tsg.tsg09 = l_gen03
   END IF
END FUNCTION
 
FUNCTION t253_tsg09(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   DEFINE l_gemacti LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gem02,gemacti 
     INTO g_gem02,l_gemacti 
    FROM gem_file
    WHERE gem01 = g_tsg.tsg09
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t253_tsg03(p_azp01)
   DEFINE p_azp01   LIKE azp_file.azp01,
          l_azp02   LIKE azp_file.azp02
 
   SELECT azp02 INTO l_azp02 FROM azp_file
    WHERE azp01 = p_azp01
  
   RETURN l_azp02
END FUNCTION
 
#FUNCTION t253_tsg15(p_dbs) #FUN-980093 mark
FUNCTION t253_tsg15(p_plant) #FUN-980093 add
   DEFINE l_flag   LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          p_dbs    LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
          l_sql    LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(200)
          l_n      LIKE type_file.num5           #No.FUN-680120 SMALLINT
  DEFINE l_dbs     LIKE azp_file.azp03   #FUN-980093 add
  DEFINE l_azp03   LIKE azp_file.azp03   #FUN-980093 add
  DEFINE p_plant   LIKE azp_file.azp01  #FUN-980093 add
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant #FUN-A50102
      #LET p_dbs = s_dbstring(l_azp03)                               #FUN-A50102
 
      LET g_plant_new = p_plant
      #CALL s_gettrandbs()    #FUN-A50102
      #LET l_dbs = g_dbs_tra  #FUN-A50102
   END IF
   #--End   FUN-980093 add-------------------------------------
 
   LET l_flag = 'N'
   LET g_errno=''
       LET l_sql = "SELECT COUNT(*) ",
       #"  FROM ",p_dbs CLIPPED,"ocd_file",
       "  FROM ",cl_get_target_table(p_plant,'ocd_file'), #FUN-A50102
       " WHERE ocd02 = '",g_tsg.tsg15,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032  #No.TQC-9A0145
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE ocd_pre FROM l_sql
   EXECUTE ocd_pre INTO l_n
   IF l_n = 0 THEN 
      LET g_errno = '100'
      RETURN l_flag
   END IF
   LET l_sql = "SELECT ocd221,ocd222,ocd223 ",
               #"  FROM ",p_dbs CLIPPED,"ocd_file",
               "  FROM ",cl_get_target_table(p_plant,'ocd_file'),   #FUN-A50102
               " WHERE ocd02 = '",g_tsg.tsg15,"'",
               " ORDER BY ocd221,ocd222,ocd223 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE ocd_pre1 FROM l_sql
   DECLARE ocd_cs1 CURSOR FOR ocd_pre1
   OPEN ocd_cs1
   FOREACH ocd_cs1 INTO l_tsg12,l_tsg13,l_tsg14
      IF SQLCA.sqlcode THEN 
         LET g_errno = SQLCA.sqlcode 
         EXIT FOREACH 
      END IF                                        
      IF l_flag = 'Y' THEN
         EXIT FOREACH
      END IF
      LET l_flag = 'Y'
   END FOREACH
   RETURN l_flag
   
END FUNCTION
 
FUNCTION t253_def_form()
 
    CALL cl_set_comp_visible("tsh08,tsh11,tsh06",FALSE)
    IF g_sma.sma115 ='N' THEN 
       CALL cl_set_comp_visible("tsh07,tsh08,tsh09",FALSE)
       CALL cl_set_comp_visible("tsh10,tsh11,tsh12",FALSE) 
    ELSE
       CALL cl_set_comp_visible("tsh04,tsh05",FALSE)                                                                                
    END IF
    IF g_sma.sma122 ='1' THEN                                                                                                       
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh10",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh12",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh07",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh09",g_msg CLIPPED)                                                                            
    END IF                                                                                                                          
    IF g_sma.sma122 ='2' THEN                                                                                                       
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh10",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh12",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-351',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh07",g_msg CLIPPED)                                                                            
       CALL cl_getmsg('asm-352',g_lang) RETURNING g_msg                                                                             
       CALL cl_set_comp_att_text("tsh09",g_msg CLIPPED) 
    END IF
END FUNCTION
 
FUNCTION t253_weight_cubage(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_tsh02   LIKE tsh_file.tsh02, 
          l_tsh03   LIKE tsh_file.tsh03, 
          l_tsh04   LIKE tsh_file.tsh04, 
          l_tsh05   LIKE tsh_file.tsh05, 
          l_tsh06   LIKE tsh_file.tsh06,
          l_tsg20   LIKE tsg_file.tsg20,  
          l_tsg21   LIKE tsg_file.tsg21    
   
   LET g_tsg.tsg20 = 0
   LET g_tsg.tsg21 = 0
   DECLARE t253_b2_b CURSOR FOR 
     SELECT tsh02,tsh03,tsh04,tsh05,tsh06
       FROM tsh_file
      WHERE tsh01 = g_tsg.tsg01
      ORDER BY tsh02
      
   FOREACH t253_b2_b INTO l_tsh02,l_tsh03,l_tsh04,l_tsh05,l_tsh06
      CALL s_weight_cubage(l_tsh03,l_tsh04,l_tsh05)
         RETURNING l_tsg20,l_tsg21
      LET g_tsg.tsg20 = g_tsg.tsg20 + l_tsg20
      LET g_tsg.tsg21 = g_tsg.tsg21 + l_tsg21
   END FOREACH
   IF g_tsg.tsg20 > 0 OR g_tsg.tsg21 > 0 THEN
      UPDATE tsg_file SET tsg20 = g_tsg.tsg20,
                          tsg21 = g_tsg.tsg21
                    WHERE tsg01 = g_tsg.tsg01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
   #     CALL cl_err('upd tsg_file: ',SQLCA.SQLCODE,1)   #No.FUN-660104
         CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","upd tsg_file: ",1)   #No.FUN-660104
         RETURN
      END IF
      DISPLAY BY NAME g_tsg.tsg20
      DISPLAY BY NAME g_tsg.tsg21
   END IF
  
END FUNCTION
 
FUNCTION t253_v(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_tsg05 LIKE tsg_file.tsg05
   
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_tsg.tsg05='2' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_tsg.tsg05='3' THEN CALL cl_err('','mfg0175',0) RETURN END IF
   IF p_cmd = '0' THEN
      IF g_tsg.tsg05='4' THEN CALL cl_err('','9024',0) RETURN END IF
   ELSE
      IF g_tsg.tsg05='1' THEN CALL cl_err('','atm-400',0) RETURN END IF
   END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t253_cl USING g_tsg.tsg01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t253_cl INTO g_tsg.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t253_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   
   LET l_tsg05 = g_tsg.tsg05
    
   IF p_cmd = '0' THEN
      IF cl_confirm('axr-152') THEN 
         LET g_tsg.tsg05 = '4'
      ELSE 
         ROLLBACK WORK 
         RETURN
      END IF 
   ELSE
      IF cl_confirm('amm-014') THEN
         LET g_tsg.tsg05 = '1' 
      ELSE 
         ROLLBACK WORK 
         RETURN
      END IF
   END IF 
   UPDATE tsg_file SET tsg05   = g_tsg.tsg05,
                       tsgmodu = g_user,
                       tsgdate = g_today
                 WHERE tsg01   = g_tsg.tsg01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
   #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
      CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      LET g_tsg.tsg05 = l_tsg05
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_tsg.tsg05  
   CLOSE t253_cl  
   COMMIT WORK
END FUNCTION
 
#過帳
FUNCTION t253_p1()
   DEFINE l_tsg05 LIKE tsg_file.tsg05,
          l_dbs   LIKE type_file.chr21            #No.FUN-680120 VARCHAR(21)
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF       
   IF g_tsg.tsg05 = '1' THEN CALL cl_err('','aco-174',0) RETURN END IF
   IF g_tsg.tsg05 = '3' THEN CALL cl_err('','asf-812',0) RETURN END IF
   IF g_tsg.tsg05 = '4' THEN CALL cl_err('','9024',0) RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t253_cl USING g_tsg.tsg01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t253_cl INTO g_tsg.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t253_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #No:CHI-B60093 add
   
   IF cl_confirm('mfg0176') THEN 
      LET l_tsg05 = g_tsg.tsg05
      LET g_tsg.tsg05 = '3' 
      CALL t253_ina_ins()
      IF g_success = 'N' THEN
         LET g_tsg.tsg05 = l_tsg05
         CLOSE t253_cl
         ROLLBACK WORK
         RETURN
      END IF
      #庫存異動過帳
      CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
#      CALL t253_g_s(g_ina.ina01,l_dbs)       #No.FUN-870007-mark
      CALL t253_g_s(g_ina.ina01,g_tsg.tsg06)  #No.FUN-870007
      IF g_success = 'N' THEN
         LET g_tsg.tsg05 = l_tsg05
         CLOSE t253_cl
         ROLLBACK WORK
         RETURN
      END IF
      SELECT * INTO g_sma.* FROM sma_file
      UPDATE tsg_file SET tsg05   = g_tsg.tsg05,
                          tsgmodu = g_user,
                          tsgdate = g_today
                    WHERE tsg01   = g_tsg.tsg01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_tsg.tsg05 = l_tsg05
         LET g_success = 'N'
      END IF
   END IF
   CALL s_showmsg()        #No.FUN-710033
   IF g_success = 'N' THEN
      CALL cl_err(g_tsg.tsg01,'abm-020',1)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   
   DISPLAY BY NAME g_tsg.tsg05  
   CLOSE t253_cl  
 
END FUNCTION
 
FUNCTION t253_p2()
   DEFINE l_tsg05   LIKE tsg_file.tsg05,
          l_sql     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   DEFINE l_azp03   LIKE azp_file.azp03   #FUN-980093 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tsg.tsg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF       
   IF g_tsg.tsg05 != '3' THEN CALL cl_err('','mfg0178',0) RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t253_cl USING g_tsg.tsg01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t253_cl INTO g_tsg.*                       #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t253_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   
   IF cl_confirm('asf-663') THEN 
      LET l_tsg05 = g_tsg.tsg05
      LET g_tsg.tsg05 = '2' 
      CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
 
      #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
         #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_tsg.tsg06 #FUN-A50102
         #LET l_dbs = s_dbstring(l_azp03)                                   #FUN-A50102
   
         LET g_plant_new = g_tsg.tsg06
         LET l_plant_new = g_plant_new
         #CALL s_gettrandbs()          #FUN-A50102
         #LET l_dbs_tra = g_dbs_tra    #FUN-A50102
      #--End   FUN-980093 add-------------------------------------
 
      #LET l_sql = " SELECT ina01 FROM ",l_dbs CLIPPED,"ina_file ",  #FUN-980093 mark
      #LET l_sql = " SELECT ina01 FROM ",l_dbs_tra CLIPPED,"ina_file ",  #FUN-980093 add
      LET l_sql = " SELECT ina01 FROM ",cl_get_target_table(l_plant_new,'ina_file'), 
                  "  WHERE ina1018 = '",g_tsg.tsg01,"' "
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980093
      PREPARE sel_ina_p1 FROM l_sql                                       
      DECLARE sel_ina_cs CURSOR FOR sel_ina_p1
      OPEN sel_ina_cs 
      FETCH sel_ina_cs INTO g_ina.ina01
      IF SQLCA.SQLCODE THEN 
         CALL cl_err(g_tsg.tsg01,SQLCA.SQLCODE,1)
         LET g_tsg.tsg05 = l_tsg05
         CLOSE t253_cl 
         ROLLBACK WORK 
         RETURN
      END IF
      #庫存異動過帳還原
      #CALL t253_p2_s(g_ina.ina01,l_dbs)  #FUN-980093 mark
      CALL t253_p2_s(g_ina.ina01,g_tsg.tsg06)  #FUN-980093 add
      IF g_success = 'N' THEN
         LET g_tsg.tsg05 = l_tsg05
         CLOSE t253_cl 
         ROLLBACK WORK 
         RETURN
      END IF
      #CALL t253_del_ina(l_dbs) #FUN-980093 mark
      CALL t253_del_ina(g_tsg.tsg06)  #FUN-980093 add
      IF g_success = 'N' THEN
         LET g_tsg.tsg05 = l_tsg05
         CLOSE t253_cl 
         ROLLBACK WORK 
         RETURN
      END IF
      SELECT * INTO g_sma.* FROM sma_file
      UPDATE tsg_file SET tsg05   = g_tsg.tsg05,
                          tsgmodu = g_user,
                          tsgdate = g_today
                    WHERE tsg01   = g_tsg.tsg01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tsg_file",g_tsg.tsg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_tsg.tsg05 = l_tsg05
         CLOSE t253_cl 
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   IF g_success = 'N' THEN
      CALL cl_err(g_tsg.tsg01,'abm-020',1)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   DISPLAY BY NAME g_tsg.tsg05  
   CLOSE t253_cl
END FUNCTION
 
FUNCTION t253_ina_ins()
   DEFINE l_legal         LIKE tsg_file.tsglegal #FUN-980009
   DEFINE l_azp03         LIKE azp_file.azp03    #FUN-980009
   DEFINE l_dbs      LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
          l_sql      LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(800)
          l_occ09    LIKE occ_file.occ09,
          l_occ07    LIKE occ_file.occ07,
          l_occ1023  LIKE occ_file.occ1023,
          l_occ1025  LIKE occ_file.occ1025,
          l_occ1005  LIKE occ_file.occ1005,
          l_occ1006  LIKE occ_file.occ1006,
          l_occ42    LIKE occ_file.occ42,
          li_result  LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_dbs_tra LIKE azp_file.azp03     #FUN-980093 add
          
   LET g_ina.ina1020 = 0
   LET g_ina.ina00   = '1'             
   SELECT tsj02 INTO g_ina.ina01 FROM tsj_file 
    WHERE tsj01 = g_tsg.tsg06
   LET g_t1=s_get_doc_no(g_tsg.tsg01)
   LET g_ina.ina02   = g_today
   LET g_ina.ina03   = g_tsg.tsg02
   LET g_ina.ina04   = ''
   LET g_ina.ina06   = ''
   LET g_ina.ina1018 = g_tsg.tsg01
   LET g_ina.ina07   = g_tsg.tsg10
   LET g_ina.ina1001 = g_tsg.tsg03
   CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
   LET p_plant = g_tsg.tsg06       #No.FUN-980059
   LET l_sql = "SELECT occ09,occ07,occ1023,occ1025,occ1005,occ1006,occ42 ",
               #"  FROM ",l_dbs CLIPPED,"occ_file ",
               "  FROM ",cl_get_target_table(g_tsg.tsg06,'occ_file'),  #FUN-A50102
               " WHERE occ01 = '",g_tsg.tsg03,"' ",
               "   AND occacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_tsg.tsg06) RETURNING l_sql #FUN-A50102
   PREPARE t253_occ FROM l_sql                                                                                                       
   DECLARE occ_cs CURSOR FOR t253_occ                                                                                                
   OPEN occ_cs                                                                                                                      
   FETCH occ_cs INTO l_occ09,l_occ07,l_occ1023,l_occ1025,
                     l_occ1005,l_occ1006,l_occ42
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET g_ina.ina1003 = l_occ09
   LET g_ina.ina1002 = l_occ07
   LET g_ina.ina1004 = l_occ1023
   LET g_ina.ina1011 = l_occ1025
   LET g_ina.ina1010 = l_occ1005
   LET g_ina.ina1012 = l_occ1006
   LET g_ina.ina1013 = g_tsg.tsg17
   LET g_ina.ina1025 = l_occ42
   LET g_ina.ina1024 = s_curr3(g_ina.ina1025,g_tsg.tsg02,g_oaz.oaz52)
   LET g_ina.ina1015 = g_tsg.tsg20
   LET g_ina.ina1016 = g_tsg.tsg21
   LET g_ina.ina1021 = 'N'
   LET g_ina.ina1022 = '0'
   LET g_ina.ina1005 = g_tsg.tsg15
   LET g_ina.ina1006 = g_tsg.tsg12
   LET g_ina.ina1007 = g_tsg.tsg13
   LET g_ina.ina1008 = g_tsg.tsg14
   LET g_ina.inaprsw = 0
   LET g_ina.inaconf = 'Y'
   LET g_ina.inapost = 'N'
   LET g_ina.inauser = g_user
   LET g_ina.inagrup = g_grup
   LET g_ina.inamodu = ' '
   LET g_ina.inadate = g_today
  #CALL s_auto_assign_no("aim",g_ina.ina01,g_today,g_ina.ina00,"ina_file","ina01",l_dbs,"","") #FUN-980094 mark
   CALL s_auto_assign_no("aim",g_ina.ina01,g_today,g_ina.ina00,"ina_file","ina01",g_tsg.tsg06,"","") #FUN-980094 add
      RETURNING li_result,g_ina.ina01
   IF (NOT li_result) THEN                                                                                                       
      LET g_success="N"                                                                                                          
#     CALL cl_err('','asf-377',0)                                                                                                
      CALL s_errmsg('','','','asf-377',0)     #No.FUN-710033
      RETURN                                                                                                              
   END IF 
    #CALL t253_inb_ins(l_dbs,l_occ42) #FUN-980093 mark
    CALL t253_inb_ins(g_tsg.tsg06,l_occ42) #FUN-980093 add
   IF g_success = "N" THEN RETURN END IF
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_tsg.tsg06 #FUN-A50102
      #LET l_dbs = s_dbstring(l_azp03)                                   #FUN-A50102
 
      LET g_plant_new = g_tsg.tsg06
      LET l_plant_new = g_plant_new
      #CALL s_gettrandbs()       #FUN-A50102
      #LET l_dbs_tra = g_dbs_tra #FUN-A50102
   END IF
   #--End   FUN-980093 add-------------------------------------
 
   
  #LET l_sql = "INSERT INTO ",l_dbs CLIPPED,"ina_file ", #FUN-980093 mark
  #LET l_sql = "INSERT INTO ",l_dbs_tra CLIPPED,"ina_file ", #FUN-980093 add
  LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant_new,'ina_file'),   #FUN-A50102
              "   (ina00,ina01,ina02,ina03, ",
              "    ina04,ina06,ina1018,ina07, ",
              "    ina1001,ina1003,ina1002,ina1004, ",
              "    ina1011,ina1010,ina1012,ina1013, ",
              "    ina1025,ina1024,ina1015,ina1016, ",
              "    ina1021,ina1022,ina1005,ina1006, ",
              "    ina1007,ina1008,inaprsw,inaconf, ",
              "    inapost,inauser,inagrup,inamodu, ",
              "    inadate,ina1020, ", 
              "    inaplant,inalegal,inaoriu,inaorig) ",    #FUN-980009  #FUN-A10036
              "  VALUES( ?,?,?,?, ?,?,?,?, ",
              "          ?,?,?,?, ?,?,?,?, ",
              "          ?,?,?,?, ?,?,?,?, ",
              "          ?,?,?,?, ?,?,?,?, ",
              "          ?,? ,  ",
              "          ?,?,?,? ) " #FUN-980009  #FUN-A10036
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE ins_ina FROM l_sql
 
   #FUN-980009
   CALL s_getlegal(g_tsg.tsg06) RETURNING l_legal 
   #FUN-980009
   
 
   EXECUTE ins_ina USING g_ina.ina00,g_ina.ina01,g_ina.ina02,g_ina.ina03,
                         g_ina.ina04,g_ina.ina06,g_ina.ina1018,g_ina.ina07,
                         g_ina.ina1001,g_ina.ina1003,g_ina.ina1002,g_ina.ina1004,
                         g_ina.ina1011,g_ina.ina1010,g_ina.ina1012,g_ina.ina1013,
                         g_ina.ina1025,g_ina.ina1024,g_ina.ina1015,g_ina.ina1016, 
                         g_ina.ina1021,g_ina.ina1022,g_ina.ina1005,g_ina.ina1006,
                         g_ina.ina1007,g_ina.ina1008,g_ina.inaprsw,g_ina.inaconf,
                         g_ina.inapost,g_ina.inauser,g_ina.inagrup,g_ina.inamodu,
                         g_ina.inadate,g_ina.ina1020,
                         g_tsg.tsg06,l_legal,g_user,g_grup    #FUN-980009 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)
      CALL s_errmsg('','',g_tsg.tsg01,SQLCA.sqlcode,0) #No.FUN-710033
      LET g_success="N" 
      RETURN
   END IF
END FUNCTION
 
#FUNCTION t253_inb_ins(p_dbs,p_occ42)  #FUN-980093 mark
FUNCTION t253_inb_ins(p_plant,p_occ42)   #FUN-980093 add
   DEFINE l_legal         LIKE tsg_file.tsglegal #FUN-980009
   DEFINE l_azp03         LIKE azp_file.azp03    #FUN-980009
   DEFINE p_dbs      LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
          l_sql      LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(800)
          l_inb03    LIKE inb_file.inb03,
          l_ima908   LIKE ima_file.ima908,
          l_fac      LIKE inb_file.inb903,                                                                                         
          l_no       LIKE tqm_file.tqm01,                                                                                         
          l_success  LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(01)
          l_ccc23a    LIKE ccc_file.ccc23a,
#FUN-AB0089--add--begin
          l_ccc23b   LIKE ccc_file.ccc23b,
          l_ccc23c   LIKE ccc_file.ccc23c,
          l_ccc23d   LIKE ccc_file.ccc23d,
          l_ccc23e   LIKE ccc_file.ccc23e,
           l_ccc23f   LIKE ccc_file.ccc23f,
          l_ccc23g   LIKE ccc_file.ccc23g,
          l_ccc23h   LIKE ccc_file.ccc23h,
          l_ccc08    LIKE ccc_file.ccc08,      #No:CHI-B60093 add
          
#FUN-AB0089--add--end
          l_price    LIKE tqn_file.tqn05,
          #carrier  --Begin
          l_ima906   LIKE ima_file.ima906,
          l_img09    LIKE img_file.img09,
          l_fac1     LIKE img_file.img21,
          l_qty1     LIKE img_file.img10,
          l_fac2     LIKE img_file.img21,
          l_qty2     LIKE img_file.img10,
          #carrier  --End
          p_occ42    LIKE occ_file.occ42
   DEFINE p_plant    LIKE azp_file.azp01     #FUN-980093 add
   DEFINE l_dbs      LIKE azp_file.azp03     #FUN-980093 add
   DEFINE l_inbi     RECORD LIKE inbi_file.* #FUN-B70074 add
          
 
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
      LET p_dbs = s_dbstring(l_azp03)      
   
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
   #--End   FUN-980093 add-------------------------------------
 
   DECLARE t253_b3_b CURSOR FOR                                                                                                     
      SELECT * FROM tsh_file                                                                                                               
       WHERE tsh01 = g_tsg.tsg01
   IF STATUS THEN 
#     CALL cl_err('',SQLCA.sqlcode,1)
      CALL s_errmsg('','','',SQLCA.sqlcode,1)   #No.FUN-710033 
      LET g_success="N" 
      RETURN
   END IF
   LET l_inb03 = 1
   CALL s_showmsg_init()   #No.FUN-710033
   FOREACH t253_b3_b INTO b_tsh.*                                                                                                  
      IF STATUS THEN 
         LET g_success="N" 
         EXIT FOREACH 
      END IF
#No.FUN-710033--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710033--end
      LET g_inb.inb01 = g_ina.ina01
      LET g_inb.inb03 = l_inb03
      LET g_inb.inb04 = b_tsh.tsh03
      LET g_inb.inb05 = g_tsg.tsg07
      LET g_inb.inb06 = ' '
      LET g_inb.inb07 = ' '
      #carrier --Begin
      #LET g_sql = " SELECT img09 FROM ",p_dbs CLIPPED,"img_file", #FUN-980093 mark
      #LET g_sql = " SELECT img09 FROM ",l_dbs CLIPPED,"img_file",  #FUN-980093 add
      LET g_sql = " SELECT img09 FROM ",cl_get_target_table(p_plant,'img_file'),  #FUN-A50102
                  "  WHERE img01 = '",b_tsh.tsh03,"'",
                  "    AND img02 = '",g_tsg.tsg07,"'",
                  "    AND img03 = ' '",
                  "    AND img04 = ' '"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql  #FUN-980093
      PREPARE t253_img FROM g_sql
      DECLARE img_curs CURSOR FOR t253_img
      OPEN img_curs
      IF SQLCA.sqlcode THEN
#        CALL cl_err('open img_curs',SQLCA.sqlcode,0)
         CALL s_errmsg('','','open img_curs',SQLCA.sqlcode,0)  #No.FUN-710033
         LET g_success = 'N'
#        RETURN             #No.FUN-710033
         CONTINUE FOREACH   #No.FUN-710033
      END IF
      FETCH img_curs INTO l_img09
      IF SQLCA.sqlcode THEN
#        CALL cl_err('fetch img_curs',SQLCA.sqlcode,0)          #No.FUN-710033 
         CALL s_errmsg('','','fetch img_curs',SQLCA.sqlcode,0)  #No.FUN-710033 
         LET g_success = 'N'
#        RETURN
         
      END IF
      IF g_sma.sma115 = 'Y' THEN
         LET l_fac = 1
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_tsh.tsh03
         IF NOT cl_null(b_tsh.tsh07) THEN
            #CALL s_umfchkm(b_tsh.tsh03,b_tsh.tsh07,l_img09,p_dbs) #FUN-980093 mark
            CALL s_umfchkm(b_tsh.tsh03,b_tsh.tsh07,l_img09,p_plant)  #FUN-980093 add
                RETURNING g_cnt,l_fac
            IF g_cnt THEN
               LET l_fac = 1
            END IF
            LET b_tsh.tsh08 = l_fac
         END IF
         IF l_ima906 = '2' THEN
            IF NOT cl_null(b_tsh.tsh10) THEN
               #CALL s_umfchkm(b_tsh.tsh03,b_tsh.tsh10,l_img09,p_dbs) #FUN-980093 mark
               CALL s_umfchkm(b_tsh.tsh03,b_tsh.tsh10,l_img09,p_plant) #FUN-980093 add
                    RETURNING g_cnt,l_fac
               IF g_cnt THEN
                  LET l_fac = 1
               END IF
               LET b_tsh.tsh11 = l_fac
            END IF
         END IF
         LET g_inb.inb905 = b_tsh.tsh10
         LET g_inb.inb906 = b_tsh.tsh11
         LET g_inb.inb907 = b_tsh.tsh12
         LET g_inb.inb902 = b_tsh.tsh07
         LET g_inb.inb903 = b_tsh.tsh08
         LET g_inb.inb904 = b_tsh.tsh09
         LET l_fac1 = b_tsh.tsh08
         LET l_qty1 = b_tsh.tsh09
         LET l_fac2 = b_tsh.tsh11
         LET l_qty2 = b_tsh.tsh12
         IF cl_null(l_fac1) THEN LET l_fac1 = 1 END IF
         IF cl_null(l_fac2) THEN LET l_fac2 = 1 END IF
         IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF
         IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF
         CASE l_ima906
              WHEN '1'  LET g_inb.inb08 = b_tsh.tsh07
                        LET g_inb.inb09 = b_tsh.tsh09
              WHEN '2'  LET g_inb.inb08 = l_img09
                        LET g_inb.inb09 = l_qty1*l_fac1+l_qty2*l_fac2
              WHEN '3'  LET g_inb.inb08 = b_tsh.tsh07
                        LET g_inb.inb09 = b_tsh.tsh09
         END CASE
         #CALL s_umfchkm(b_tsh.tsh03,g_inb.inb08,l_img09,p_dbs)  #FUN-980093 mark
         CALL s_umfchkm(b_tsh.tsh03,g_inb.inb08,l_img09,p_plant)  #FUN-980093 add
              RETURNING g_cnt,l_fac
         IF g_cnt THEN
            LET l_fac = 1
         END IF
         LET g_inb.inb08_fac = l_fac
         LET g_inb.inb09 = s_digqty(g_inb.inb09,g_inb.inb08)  #FUN-BB0085
      END IF
      SELECT ima25,ima908 INTO g_ima25,l_ima908 FROM ima_file WHERE ima01 = g_inb.inb04
      IF g_sma.sma115 = 'N' THEN
         LET g_inb.inb08 = b_tsh.tsh04
         #CALL s_umfchkm(g_inb.inb04,g_inb.inb08,l_img09,p_dbs) #FUN-980093 mark
         CALL s_umfchkm(g_inb.inb04,g_inb.inb08,l_img09,p_plant) #FUN-980093 add
             RETURNING g_cnt,l_fac
         LET g_inb.inb08_fac = l_fac
         LET g_inb.inb09  = b_tsh.tsh05
      END IF
      #carrier --End  
      IF g_sma.sma116 != '0' THEN
         LET g_inb.inb1004 = l_ima908
         #CALL s_umfchkm(g_inb.inb04,g_inb.inb1004,g_ima25,p_dbs)  #FUN-980093 mark
         CALL s_umfchkm(g_inb.inb04,g_inb.inb1004,g_ima25,p_plant)  #FUN-980093 add
            RETURNING g_cnt,l_fac
         LET g_inb.inb1005 = b_tsh.tsh05*l_fac
         LET g_inb.inb1005 = s_digqty(g_inb.inb1005,g_inb.inb1004)  #FUN-BB0085
#        CALL s_fetch_price2(g_tsg.tsg03,g_inb.inb04,g_inb.inb1004,g_tsg.tsg17,'4',p_dbs,p_occ42)    #No.FUN-980059
         CALL s_fetch_price2(g_tsg.tsg03,g_inb.inb04,g_inb.inb1004,g_tsg.tsg17,'4',p_plant,p_occ42)  #No.FUN-980059
            RETURNING l_no,l_price,l_success
         IF g_success = 'N' THEN
#           CALL cl_err('','axm-333',0)          #No.FUN-710033
            CALL s_errmsg('','','','axm-333',0)  #No.FUN-710033
#          RETURN
           CONTINUE FOREACH                      #No.FUN-710033 
         END IF 
         LET g_inb.inb1001 = l_no
         LET g_inb.inb1002 = ''
         LET g_inb.inb1003 = l_price
         LET g_inb.inb1006 = g_inb.inb1005*g_inb.inb1003
      ELSE
#        CALL s_fetch_price2(g_tsg.tsg03,g_inb.inb04,g_inb.inb08,g_tsg.tsg17,'4',p_dbs,p_occ42)     #No.FUN-980059
         CALL s_fetch_price2(g_tsg.tsg03,g_inb.inb04,g_inb.inb08,g_tsg.tsg17,'4',p_plant,p_occ42)   #No.FUN-980059
            RETURNING l_no,l_price,l_success
         IF g_success = 'N' THEN
#           CALL cl_err('','axm-333',0)         #No.FUN-710033  
            CALL s_errmsg('','','','axm-333',0) #No.FUN-710033   
#           RETURN
            CONTINUE FOREACH                    #No.FUN-710033  
         END IF 
         LET g_inb.inb1001 = l_no
         LET g_inb.inb1002 = ''
         LET g_inb.inb1003 = l_price
         LET g_inb.inb1006 = g_inb.inb09*g_inb.inb1003
      END IF
      LET g_inb.inb11 = g_tsg.tsg01
      LET g_inb.inb12 = g_tsg.tsg01
      LET g_inb.inb901= ''
      LET g_inb.inb908=YEAR(g_today)
      LET g_inb.inb909=MONTH(g_today)
      LET g_inb.inb910='' 
     #------------------No:CHI-B60093 add
      CASE g_ccz.ccz28 
           WHEN '3' 
                 LET l_ccc08 = g_inb.inb07
           WHEN '5' 
                 SELECT imd09 INTO l_ccc08 FROM imd_file WHERE imd01 = g_inb.inb05
           OTHERWISE
                 LET l_ccc08 = ' '
      END CASE
     #------------------No:CHI-B60093 end
      LET l_sql = "SELECT cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h ",  #FUN-AB0089
                  #"  FROM ",p_dbs CLIPPED,"cca_file ", #FUN-980093 mark
                  #"  FROM ",l_dbs CLIPPED,"cca_file ",  #FUN-980093 add
                  "  FROM ",cl_get_target_table(p_plant,'cca_file'),  #FUN-A50102
                  " WHERE cca01 = '",g_inb.inb04,"' ",
                  "   AND cca02 = ",g_inb.inb908,  #No:CHI-B60093 modify
                  "   AND cca03 = ",g_inb.inb909,  #No:CHI-B60093 modify 
                  "   AND cca06 = '",g_ccz.ccz28,"'",    #No:CHI-B60093 add
                  "   AND cca07 = '",l_ccc08,"'"         #No:CHI-B60093 add
               
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
      PREPARE t253_cca FROM l_sql                                                                                                       
      DECLARE cca_cs CURSOR FOR t253_cca                                                                                                
      OPEN cca_cs                                                                                                                      
      FETCH cca_cs INTO l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-AB0089
      IF SQLCA.sqlcode = 100 THEN
         LET l_sql = "SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h ",       #FUN-AB0089
                     #"  FROM ",p_dbs CLIPPED,"ccc_file ",
                     "  FROM ",cl_get_target_table(p_plant,'ccc_file'),  #FUN-A50102
                     " WHERE ccc01 = '",g_inb.inb04,"' ",
                     "   AND ccc02 = ",g_inb.inb908,        #No:CHI-B60093 modify
                     "   AND ccc03 = ",g_inb.inb909,      #No:CHI-B60093 modify
                    #"   AND ccc07 = '1' ",                 #No.FUN-840041   #No:CHI-B60093 mark
                     "   AND ccc07 = '",g_ccz.ccz28,"'",    #No:CHI-B60093 add
                     "   AND ccc08 = '",l_ccc08,"'"         #No:CHI-B60093 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql#FUN-A50102
         PREPARE t253_ccc FROM l_sql                                                                                                       
         DECLARE ccc_cs CURSOR FOR t253_ccc                                                                                                
         OPEN ccc_cs  
         FETCH ccc_cs INTO l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e,l_ccc23f,l_ccc23g,l_ccc23h  #FUN-AB0089
         IF SQLCA.sqlcode  = 100 THEN
            LET l_ccc23a = 0
  #FUN-AB0089--add--begin
            LET l_ccc23b = 0
            LET l_ccc23c = 0
            LET l_ccc23d = 0
            LET l_ccc23e = 0
            LET l_ccc23g = 0
            LET l_ccc23f = 0
            LET l_ccc23h = 0
  #FUN-AB0089--add-end
         END IF
      END IF
      LET g_inb.inb13 = l_ccc23a
  #FUN-AB0089--add--begin
      LET g_inb.inb132 = l_ccc23b
      LET g_inb.inb133 = l_ccc23c
      LET g_inb.inb134 = l_ccc23d
      LET g_inb.inb135 = l_ccc23e
      LET g_inb.inb136 = l_ccc23f
      LET g_inb.inb137 = l_ccc23g
      LET g_inb.inb138 = l_ccc23h
  #FUN-AB0089--add-end
      LET g_inb.inb14 = g_inb.inb13*g_inb.inb09+g_inb.inb132*g_inb.inb09+g_inb.inb133*g_inb.inb09+g_inb.inb134*g_inb.inb09
                        +g_inb.inb135*g_inb.inb09+g_inb.inb136*g_inb.inb09+g_inb.inb137*g_inb.inb09+g_inb.inb138*g_inb.inb09     #FUN-AB0089
      LET g_inb.inb15 = b_tsh.tsh13
      #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"inb_file  ", #FUN-980093 mark
      #LET l_sql = "INSERT INTO ",l_dbs CLIPPED,"inb_file  ",  #FUN-980093 add
      LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant,'inb_file'),  #FUN-A50102 
                  " (inb01,inb03,inb04,inb05, ",
                  "  inb06,inb07,inb08,inb08_fac, ",
                  "  inb09,inb905,inb906,inb907, ",
                  "  inb902,inb903,inb904,inb1004, ",
                  "  inb1005,inb1001,inb1002,inb1003, ",
                  "  inb1006,inb11,inb12,inb13,inb132,inb133,inb134,inb135,inb136,inb137,inb138, ", #FUN-AB0089
                  "  inb14,inb15,inb16,inb901,inb908, ",    #No.FUN-870163
                  "  inb909,inb910 , ",
                  "  inbplant,inblegal ) ",     #FUN-980009
                  "  VALUES( ?,?,?,?, ?,?,?,?, ",
                  "          ?,?,?,?, ?,?,?,?, ",
                  "          ?,?,?,?, ?,?,?,?, ",
                  "          ?,?,?,?, ?,?,? ,  ",   #No.FUN-870163
                  "          ?,? ) " #FUN-980009
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql#FUN-A50102
      PREPARE ins_inb FROM l_sql
 
      #FUN-980009
      CALL s_getlegal(g_tsg.tsg06) RETURNING l_legal 
      #FUN-980009
 
      EXECUTE ins_inb USING g_inb.inb01,g_inb.inb03,g_inb.inb04,g_inb.inb05,
                            g_inb.inb06,g_inb.inb07,g_inb.inb08,g_inb.inb08_fac,
                            g_inb.inb09,g_inb.inb905,g_inb.inb906,g_inb.inb907,
                            g_inb.inb902,g_inb.inb903,g_inb.inb904,g_inb.inb1004,
                            g_inb.inb1005,g_inb.inb1001,g_inb.inb1002,g_inb.inb1003,
                            g_inb.inb1006,g_inb.inb11,g_inb.inb12,g_inb.inb13,
                            g_inb.inb14,g_inb.inb15,g_inb.inb09,    #No.FUN-870163
                            g_inb.inb901,g_inb.inb908,
                            g_inb.inb909,g_inb.inb910,
                            g_tsg.tsg06,l_legal    #FUN-980009 
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_tsg.tsg01,SQLCA.sqlcode,0)           #No.FUN-710033  
         CALL s_errmsg('','',g_tsg.tsg01,SQLCA.sqlcode,0)   #No.FUN-710033 
         LET g_success="N" 
#        RETURN
         CONTINUE FOREACH                    #No.FUN-710033 
#FUN-B70074--add--insert--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_inbi.* TO NULL
            LET l_inbi.inbi01 = g_inb.inb01
            LET l_inbi.inbi03 = g_inb.inb03
            IF NOT s_ins_inbi(l_inbi.*,p_plant) THEN
               LET g_success = 'N'
               CONTINUE FOREACH 
            END IF
         END IF 
#FUN-B70074--add--insert--
      END IF
      LET l_inb03 = l_inb03 + 1
      LET g_ina.ina1020 = g_ina.ina1020 + g_inb.inb1006 
   END FOREACH
#No.FUN-710033--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710033--end
   
END FUNCTION
 
#FUNCTION t253_del_ina(p_dbs)  #FUN-980093 mark
FUNCTION t253_del_ina(p_plant) #FUN-980093 add
   DEFINE p_dbs      LIKE type_file.chr21,        #No.FUN-680120 VARCHAR(21)
          l_sql      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
   DEFINE p_plant LIKE azp_file.azp01     #FUN-980093 add
   DEFINE l_dbs   LIKE azp_file.azp03     #FUN-980093 add
   DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980093 add
   #FUN-BC0104-add-str--
   DEFINE l_inb01  LIKE inb_file.inb01
   DEFINE l_inb03  LIKE inb_file.inb03
   DEFINE l_inb46  LIKE inb_file.inb46
   DEFINE l_inb47  LIKE inb_file.inb47
   DEFINE l_inb48  LIKE inb_file.inb48
   DEFINE l_flagg  LIKE type_file.chr1
   DEFINE l_qcl05  LIKE qcl_file.qcl05
   DEFINE l_type1  LIKE type_file.chr1
   DEFINE l_cn     LIKE  type_file.num5
   DEFINE l_c      LIKE  type_file.num5
   DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
          inb01    LIKE  inb_file.inb01,
          inb03    LIKE  inb_file.inb03,
          inb48    LIKE  inb_file.inb48,
          inb46    LIKE  inb_file.inb46,
          inb47    LIKE  inb_file.inb47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   #FUN-BC0104-add-end--
          
   #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
      LET p_dbs = s_dbstring(l_azp03)
 
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
   #--End   FUN-980093 add-------------------------------------
 
   #LET l_sql = "DELETE FROM ",p_dbs CLIPPED,"ina_file",  #FUN-980093 mark
   #LET l_sql = "DELETE FROM ",l_dbs CLIPPED,"ina_file",   #FUN-980093 add
   LET l_sql = "DELETE FROM ",cl_get_target_table(p_plant,'ina_file'), #FUN-A50102
               " WHERE ina01= ? "  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE del_ina FROM l_sql                                       
   EXECUTE del_ina USING g_ina.ina01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN                 
      LET g_success="N" 
      RETURN 
   END IF
 
   #FUN-BC0104-add-str--
   LET l_cn =1
   DECLARE upd_qco20 CURSOR FOR
    SELECT inb03 FROM inb_file WHERE inb01 = g_ina.ina01
   FOREACH upd_qco20 INTO l_inb03
      CALL s_iqctype_inb(g_ina.ina01,l_inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg
      LET l_inb_a[l_cn].inb01 = l_inb01
      LET l_inb_a[l_cn].inb03 = l_inb03
      LET l_inb_a[l_cn].inb46 = l_inb46
      LET l_inb_a[l_cn].inb48 = l_inb48
      LET l_inb_a[l_cn].inb47 = l_inb47
      LET l_inb_a[l_cn].flagg = l_flagg
      LET l_cn = l_cn + 1
   END FOREACH
   #FUN-BC0104-add-end--   

   #LET l_sql = "DELETE FROM ",p_dbs CLIPPED,"inb_file",  #FUN-980093 mark
   #LET l_sql = "DELETE FROM ",l_dbs CLIPPED,"inb_file",   #FUN-980093 add
   LET l_sql = "DELETE FROM ",cl_get_target_table(p_plant,'inb_file'), #FUN-A50102
               " WHERE inb01= ? "  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980093
   PREPARE del_inb FROM l_sql                                       
   EXECUTE del_inb USING g_ina.ina01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN                 
      LET g_success="N" 
      RETURN 
#FUN-B70074-add-delete--
   ELSE 
       #FUN-BC0104-add-str--
       FOR l_c=1 TO l_cn-1
          IF l_inb_a[l_c].flagg = 'Y' THEN
             CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
             IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
             IF NOT s_iqctype_upd_qco20(l_inb_a[l_c].inb01,l_inb_a[l_c].inb03,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) THEN 
                LET g_success="N"
                RETURN
             END IF
          END IF
       END FOR
       #FUN-BC0104-add-end--
      IF NOT s_industry('std') THEN 
         IF NOT s_del_inbi(g_ina.ina01,'',p_plant) THEN 
            LET g_success="N" 
            RETURN  
         END IF 
      END IF
#FUN-B70074-add-end--
   END IF 
END FUNCTION
 
FUNCTION t253_qty_def()
 
   IF g_tsh[l_ac].tsh08 <> 0  THEN
      LET g_tsh[l_ac].tsh08 = 0
   END IF
   IF g_tsh[l_ac].tsh09 <> 0  THEN
      LET g_tsh[l_ac].tsh09 = 0
   END IF
   IF g_tsh[l_ac].tsh11 <> 0  THEN
      LET g_tsh[l_ac].tsh11 = 0
   END IF
   IF g_tsh[l_ac].tsh12 <> 0  THEN
      LET g_tsh[l_ac].tsh12 = 0
   END IF
END FUNCTION
 
FUNCTION t253_img10(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_unit  LIKE img_file.img09,
          l_qty   LIKE img_file.img10,
          l_fac   LIKE inb_file.inb08_fac
   
   LET g_flag = 0
   IF p_cmd = '0' THEN
      LET l_unit = g_tsh[l_ac].tsh04
      LET l_qty = g_tsh[l_ac].tsh05
   ELSE
      LET l_unit = g_tsh[l_ac].tsh07
      LET l_qty = g_tsh[l_ac].tsh09
   END IF
   #CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',l_dbs)  #FUN-980093 mark
   CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',g_tsg.tsg06)  #FUN-980093 add
      RETURNING g_flag,g_img09,g_img10
   CALL s_umfchk(g_tsh[l_ac].tsh03,l_unit,g_img09)
      RETURNING g_cnt,l_fac 
   IF l_qty*l_fac > g_img10 THEN
     #IF g_sma.sma894[1,1] = 'N' OR g_sma.sma894[1,1] IS NULL THEN                     #FUN-C80107 mark                                 
     #FUN-D30024--modify--str--
     #INITIALIZE g_sma894 TO NULL                                                      #FUN-C80107
     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsg.tsg07) RETURNING g_sma894   #FUN-C80107
     #IF g_sma894 = 'N' THEN                                                           #FUN-C80107
      INITIALIZE g_imd23 TO NULL
      CALL s_inv_shrt_by_warehouse(g_tsg.tsg07,g_tsg.tsg06) RETURNING g_imd23       #TQC-D40078 g_tsg.tsg06
      IF g_imd23 = 'N' THEN                                    
     #FUN-D30024--modify--end--
         CALL cl_err('','mfg1303',0)
         LET g_flag = 1                                                                                           
      ELSE
         IF NOT cl_confirm('mfg3469') THEN 
            LET g_flag = 1                                                                           
         END IF
      END IF  
   END IF 
END FUNCTION
 
FUNCTION t253_imgg10(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_unit  LIKE imgg_file.imgg09,
          l_qty   LIKE imgg_file.imgg10
   
   LET g_flag = 0
   IF p_cmd = '0' THEN
      LET l_qty = g_tsh[l_ac].tsh12
      LET l_unit = g_tsh[l_ac].tsh10
   ELSE
      LET l_qty = g_tsh[l_ac].tsh09
      LET l_unit = g_tsh[l_ac].tsh07
   END IF
   CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
  #CALL t253_mchk_imgg10(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',l_unit,l_dbs)
   CALL t253_mchk_imgg10(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',l_unit,g_tsg.tsg06) #FUN-980094 add
      RETURNING g_imgg10
   IF l_qty > g_imgg10 THEN
     #IF g_sma.sma894[1,1] = 'N' OR g_sma.sma894[1,1] IS NULL THEN                     #FUN-C80107 mark                                 
     #FUN-D30024--modify--str--
     #INITIALIZE g_sma894 TO NULL                                                      #FUN-C80107
     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsg.tsg07) RETURNING g_sma894   #FUN-C80107
     #IF g_sma894 = 'N' THEN                                                           #FUN-C80107
      INITIALIZE g_imd23 TO NULL
      CALL s_inv_shrt_by_warehouse(g_tsg.tsg07,g_tsg.tsg06) RETURNING g_imd23  #TQC-D40078 g_tsg.tsg06
      IF g_imd23 = 'N' THEN
     #FUN-D30024--modify--end--
         CALL cl_err('','mfg1303',0)
         LET g_flag = 1                                                                                           
      ELSE
         IF NOT cl_confirm('mfg3469') THEN 
            LET g_flag = 1                                                                           
         END IF
      END IF  
   END IF 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t253_du_data_to_correct()
 
   IF cl_null(g_tsh[l_ac].tsh07) THEN
      LET g_tsh[l_ac].tsh08 = NULL
      LET g_tsh[l_ac].tsh09 = NULL
   END IF
 
   IF cl_null(g_tsh[l_ac].tsh10) THEN
      LET g_tsh[l_ac].tsh11 = NULL
      LET g_tsh[l_ac].tsh12 = NULL
   END IF
   DISPLAY BY NAME g_tsh[l_ac].tsh08
   DISPLAY BY NAME g_tsh[l_ac].tsh09
   DISPLAY BY NAME g_tsh[l_ac].tsh11
   DISPLAY BY NAME g_tsh[l_ac].tsh12
 
END FUNCTION
 
FUNCTION t253_set_required()
 
  IF g_sma.sma115 = 'Y' THEN   #No.TQC-650059
     #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
     CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
        RETURNING g_flag,g_ima906,g_ima907
     IF g_ima906 = '3' THEN
        CALL cl_set_comp_required("tsh10,tsh12,tsh07,sh09",TRUE)
     END IF
     IF g_ima906 = '1' THEN
        CALL cl_set_comp_required("tsh07,sh09",TRUE)
     END IF
     #單位不同,轉換率,數量必KEY
     IF NOT cl_null(g_tsh[l_ac].tsh07) THEN
        CALL cl_set_comp_required("tsh09",TRUE)
     END IF
     IF NOT cl_null(g_tsh[l_ac].tsh10) THEN
        CALL cl_set_comp_required("tsh12",TRUE)
     END IF
  END IF   #No.TQC-650059
END FUNCTION
 
FUNCTION t253_set_no_required()
 
   CALL cl_set_comp_required("tsh10,tsh12,tsh07,tsh09",FALSE)
END FUNCTION
 
#carrier --Begin
#對原來數量/換算率/單位的賦值
FUNCTION t253_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima25  LIKE ima_file.ima25,
            l_unit   LIKE ima_file.ima25,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE tsh_file.tsh11,
            l_qty2   LIKE tsh_file.tsh12,
            l_fac1   LIKE tsh_file.tsh08,
            l_fac    LIKE tsh_file.tsh08,
            l_qty1   LIKE tsh_file.tsh09,
            l_factor LIKE oeb_file.oeb12                #No.FUN-680120 DECIMAL(16,8)
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file
     WHERE ima01=g_tsh[l_ac].tsh03
 
    LET l_fac = 1
    IF l_ima25 <> g_tsh[l_ac].tsh07 THEN
       CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh07,l_ima25)
            RETURNING g_cnt,l_fac
       IF g_cnt = 1 THEN
          LET l_fac = 1
       END IF
    END IF
    LET g_tsh[l_ac].tsh08 = l_fac
    IF l_ima906 = '2' THEN
       LET l_fac = 1
       IF l_ima25 <> g_tsh[l_ac].tsh10 THEN
          CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh10,l_ima25)
               RETURNING g_cnt,l_fac
          IF g_cnt = 1 THEN
             LET l_fac = 1
          END IF
       END IF
       LET g_tsh[l_ac].tsh11 = l_fac
    END IF
    LET l_fac2=g_tsh[l_ac].tsh11
    LET l_qty2=g_tsh[l_ac].tsh12
    LET l_fac1=g_tsh[l_ac].tsh08
    LET l_qty1=g_tsh[l_ac].tsh09
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    LET g_tsh[l_ac].tsh04 = l_ima25
 
    CASE l_ima906
       WHEN '1' LET l_unit = g_tsh[l_ac].tsh07
                LET l_tot  = l_qty1
       WHEN '2' LET l_tot  = l_fac1*l_qty1+l_fac2*l_qty2
                LET l_unit = l_ima25
       WHEN '3' LET l_unit = g_tsh[l_ac].tsh07
                LET l_tot  = l_qty1
                IF l_qty2 <> 0 THEN
                   LET g_tsh[l_ac].tsh11 = l_qty1 / l_qty2
                ELSE
                   LET g_tsh[l_ac].tsh11 = 0
                END IF
    END CASE
  
    LET l_fac = 1
    IF l_ima25 <> l_unit THEN
       CALL s_umfchk(g_tsh[l_ac].tsh03,l_unit,l_ima25)
            RETURNING g_cnt,l_fac
       IF g_cnt = 1 THEN
          LET l_fac = 1
       END IF
    END IF
       
    LET g_tsh[l_ac].tsh05 = l_tot * l_fac
 
END FUNCTION
#carrier --End  
 
#No.TQC-650091  --begin--
FUNCTION t253_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62    
  DEFINE li_col_count       LIKE type_file.num5             #No.FUN-680120 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5             #No.FUN-680120 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') AND NOT cl_null(lg_smy62) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_tsh.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_tsh.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_tsh[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_tsh[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_smy62 THEN
            LET lg_group = ''
            EXIT FOR
         END IF
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替tsh03子料件編號來顯示
     #得到當前語言別下tsh03的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'tsh03' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'tsh03,ima02'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'tsh03,ima02'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'tsh03'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把oeb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_tsh[l_ac]都被改成g_tsh[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t253_check_oeb04(.....)  THEN NEXT FIELD XXX END IF        
FUNCTION t253_check_tsh03(p_field,p_ac,p_cmd) #No.MOD-660090
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,             #No.FUN-680120 SMALLINT  #g_tsh數組中的當前記錄下標
                              
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  ls_value                    STRING,
  g_value                     LIKE ima_file.ima01,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING, 
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE ade_file.ade04,          #No.FUN-680120 VARCHAR(04)
  l_n                         LIKE type_file.num5,          #No.FUN-680120 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_imaag                     LIKE ima_file.imaag,
  l_qty                       LIKE type_file.num10,          #No.FUN-680120 INTEGER
# p_cmd                       STRING,   #No.MOD-660090 MARK
  p_cmd                       LIKE type_file.chr1,   #No.MOD-660090        #No.FUN-680120 VARCHAR(1)
  l_check                     LIKE ade_file.ade04    #No.FUN-680120 VARCHAR(04)
 
DEFINE l_flag                 LIKE type_file.chr1    #No.FUN-7B0018
 
  
  #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
  #新的子料件編號并把值填入到已經隱藏起來的oeb04中（如果imxXX能夠顯示，oeb04一定是隱藏的）
  #下面就可以直接沿用oeb04的檢核邏輯了
  #如果不是，則看看是不是oeb04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
  IF (p_field = 'imx00') OR (p_field = 'imx01') OR (p_field = 'imx02') OR
     (p_field = 'imx03') OR (p_field = 'imx04') OR (p_field = 'imx05') OR
     (p_field = 'imx06') OR (p_field = 'imx07') OR (p_field = 'imx08') OR
     (p_field = 'imx09') OR (p_field = 'imx10')  THEN
     
     #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
     #全部被輸入完成了才進行后續的操作
     LET ls_pid   = g_tsh[p_ac].att00   # ls_pid 父料件編號
     LET ls_value = g_tsh[p_ac].att00   # ls_value 子料件編號
     IF cl_null(ls_pid) THEN 
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被注釋掉
        CALL t253_set_required()
 
        RETURN '0',g_buf,g_ima135,l_ima25,l_imaacti
     END IF  #注意這里沒有錯，所以返回TRUE
     
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 = 
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
     IF l_cnt = 0 THEN
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t253_set_required()
         
        RETURN '0',g_buf,g_ima135,l_ima25,l_imaacti
     END IF
     
     FOR li_i = 1 TO l_cnt
         #如果有任何一個明細屬性應該輸而沒有輸的則退出
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN 
            #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
            #注釋掉
            CALL t253_set_required()
            
            RETURN '0',g_buf,g_ima135,l_ima25,l_imaacti
         END IF  
     END FOR
 
     #得到系統定義的標准分隔符sma46
     SELECT sma46 INTO l_ps FROM sma_file    
     
     #合成子料件的名稱
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
       WHERE ima01 = ls_pid
     LET ls_spec = ls_pname  # ls_spec 子料件名稱
     #方法:循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
     #替換初始名稱，如果找不到則就用原來的名稱
     FOR li_i = 1 TO l_cnt  
         LET lc_agd03 = ""
         LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
         SELECT agd03 INTO lc_agd03 FROM agd_file
          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
         IF cl_null(lc_agd03) THEN
            LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
         ELSE
            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
         END IF
     END FOR     
     
     #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
     LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
     LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
     LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                  "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                  "ORDER BY agb02"  
     DECLARE param_curs CURSOR FROM ls_sql
     FOREACH param_curs INTO lc_agb03
       #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
       IF cl_null(l_param_list) THEN
          LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
       ELSE
          LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
       END IF
     END FOREACH     
 
     #不允許新增ima_file里面沒有的子料件，故在此檢查一下                                                                   
     LET g_value=ls_value
     SELECT count(*) INTO l_n FROM ima_file                                                                                      
      WHERE ima01 = g_value                                                                                                       
     IF l_n =0 THEN                                                                                                              
        CALL cl_err('g_value','atm-523',1)                                                                                        
        RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti                                                                          
     END IF
     
     #調用cl_copy_ima將新生成的子料件插入到數據庫中
     IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
        #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
        LET ls_value_fld = ls_value 
        INSERT INTO imx_file VALUES(ls_value_fld,arr_detail[p_ac].imx[1],
          arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
          arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
          arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10],
          ls_pid)
        #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
        #記錄的完全同步
       IF SQLCA.sqlcode THEN
       #  CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)   #No.FUN-660104
          CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)  #No.FUN-660104
          DELETE FROM ima_file WHERE ima01 = ls_value_fld
          #No.FUN-7B0018 080304 add --begin
#         IF NOT s_industry('std') THEN   #No.FUN-830132 mark
          IF s_industry('icd') THEN       #No.FUN-830132 add
             LET l_flag = s_del_imaicd(ls_value_fld,'')
          END IF
          #No.FUN-7B0018 080304 add --end
          RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
        END IF
     END IF 
     #把生成的子料件賦給tsh03，否則下面的檢查就沒有意義了
     LET g_tsh[p_ac].tsh03 = ls_value
  ELSE 
    IF ( p_field <> 'tsh03' )AND( p_field <> 'imx00' ) THEN 
       RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
    END IF
  END IF
  
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照oeb04進行判斷了
  
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD oeb04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
 
  IF NOT cl_null(g_tsh[l_ac].tsh03) THEN                       
 
     #新增一個判斷,如果lg_smy62不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_smy62) THEN
       IF g_sma.sma120 = 'Y' THEN
          CALL cl_itemno_multi_att("tsh03",g_tsh[l_ac].tsh03,"",'1','7') RETURNING l_check,g_tsh[l_ac].tsh03,g_tsh[l_ac].ima02
          DISPLAY g_tsh[l_ac].tsh03 TO tsh03
          DISPLAY g_tsh[l_ac].ima02 TO ima02
       END IF
     END IF
     
     SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_tsh[l_ac].tsh03                                                           
     IF l_n=0 THEN                                                                                                                  
        CALL cl_err('tsh03','ams-003',1)                                                                                            
        RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti                                                                               
     END IF
 
     SELECT ima02,ima135,ima25,imaacti
       INTO g_buf,g_ima135,g_ima25,l_imaacti
       FROM ima_file
      WHERE ima01=g_tsh[l_ac].tsh03
        IF NOT cl_null(g_errno)  THEN                                              
            CALL cl_err(g_tsh[l_ac].tsh03,g_errno,1)                             
            LET g_tsh[l_ac].tsh03 = g_tsh_t.tsh03      
            DISPLAY BY NAME g_tsh[l_ac].tsh03                 
            RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
         END IF
         CALL t253_azp(g_tsg.tsg06) RETURNING l_dbs
         #CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',l_dbs) #FUN-980093 mark
         CALL t253_mchk_img(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',g_tsg.tsg06)  #FUN-980093 add
               RETURNING g_flag,g_img09,g_img10
         IF g_flag = 1 THEN
            SELECT imaag INTO l_imaag 
              FROM ima_file 
             WHERE ima01 = g_tsh[l_ac].tsh03
            IF l_imaag = '' OR l_imaag = '@CHILD' THEN
               CALL cl_err('sel img:','axm-244',0)                                                                                
               RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
            END IF
         END IF
         #LET g_cnt = t253_mchk_img18(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',g_tsg.tsg17,l_dbs) #FUN-980093 mark
         LET g_cnt = t253_mchk_img18(g_tsh[l_ac].tsh03,g_tsg.tsg07,'','',g_tsg.tsg17,g_tsg.tsg06) #FUN-980093 add
         IF g_cnt > 0 THEN
            CALL cl_err('','aim-400',0)
            RETURN '2',g_buf,g_ima135,l_ima25,l_imaacti
         END IF
         LET g_tsh[l_ac].tsh04 = g_ima25
         CALL t253_qty_def()
     IF g_sma.sma115 = 'Y' THEN
        CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
        RETURNING g_flag,g_ima906,g_ima907
        IF g_flag=1 THEN
           RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
        END IF
        IF g_ima906 = '1' THEN                #單一單位
           CALL cl_set_comp_entry("tsh10,tsh12",FALSE) 
        END IF
        IF g_ima906 = '3' THEN                #參考單位
           CALL cl_set_comp_entry("tsh10",FALSE) 
        END IF
        IF p_cmd='a' OR (p_cmd='u' AND g_tsh_t.tsh03<>g_tsh[l_ac].tsh03) THEN  
           LET g_tsh[l_ac].tsh07 = g_ima25
           LET g_tsh[l_ac].tsh10 = g_ima907
        END IF
        LET g_tsh_t.* = g_tsh[l_ac].*
     END IF
     CALL t253_set_required()
 
     DISPLAY g_tsh[l_ac].ima02  TO FORMONLY.ima02
     DISPLAY g_tsh[l_ac].ima135  TO FORMONLY.ima135 
 
     
     CALL t253_set_required()
 
     RETURN '0',g_buf,g_ima135,l_ima25,l_imaacti
  ELSE
     #如果是由oeb04來觸發的,說明當前用的是舊的流程,那么oeb04為空是可以的
     #如果是由att00來觸發,原理一樣
     IF (p_field = 'tsh03') OR (p_field = 'imx00') THEN 
        #所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t253_set_required()
 
        RETURN '0',g_buf,g_ima135,l_ima25,l_imaacti
     ELSE 
        #如果不是oeb,則是由attxx來觸發的,則非輸不可
        RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
     END IF #如果為空則不允許新增
  END IF
 
  RETURN '0',g_buf,g_ima135,l_ima25,l_imaacti
 
END FUNCTION
         
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t253_check_tsh03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t253_check_att0x(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,          #No.FUN-680120 SMALLINT
  p_row        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  p_cmd        LIKE type_file.chr1,   #No.MOD-660090        #No.FUN-680120 VARCHAR(1)
  l_check_res     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
  l_b2            LIKE nma_file.nma04,             #No.FUN-680120 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
  l_ima131        LIKE ima_file.ima131,             #No.FUN-680120 VARCHAR(10)
  l_ima25         LIKE ima_file.ima25 
  
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成tsh03料件編號
  IF cl_null(p_value) THEN 
     RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t253_refresh_detail()函數在較早的時候填充
  
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t253_check_tsh03('imx' || l_index ,p_row,p_cmd)  #No.MOD-660090
    RETURNING l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
 
  RETURN l_check_res,g_buf,g_ima135,l_ima25,l_imaacti 
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t253_check_tsh03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t253_check_att0x_c(p_value,p_index,p_row,p_cmd) #No.MOD-660090
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,          #No.FUN-680120 SMALLINT
  p_row    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
  l_index  STRING,
  p_cmd    LIKE type_file.chr1,    #No.MOD-660090  #No.FUN-680120 VARCHAR(1)
  l_check_res     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
  l_b2            LIKE nma_file.nma04,             #No.FUN-680120 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
  l_ima131        LIKE ima_file.ima131,            #No.FUN-680120 VARCHAR(10)
  l_ima25         LIKE ima_file.ima25
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN 
     RETURN '1',g_buf,g_ima135,l_ima25,l_imaacti
  END IF       
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了  
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t253_check_tsh03('imx'||l_index,p_row,p_cmd) #No.MOD-660090
    RETURNING l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
  RETURN l_check_res,g_buf,g_ima135,l_ima25,l_imaacti
END FUNCTION         
 
#No.TQC-650091  --end-- 

#No.FUN-BB0086--add--begin--
FUNCTION t253_tsh05_check()
   IF NOT cl_null(g_tsh[l_ac].tsh05) AND NOT cl_null(g_tsh[l_ac].tsh04) THEN
      IF cl_null(g_tsh_t.tsh05) OR cl_null(g_tsh04_t) OR g_tsh_t.tsh05 != g_tsh[l_ac].tsh05 OR g_tsh04_t != g_tsh[l_ac].tsh04 THEN
         LET g_tsh[l_ac].tsh05=s_digqty(g_tsh[l_ac].tsh05,g_tsh[l_ac].tsh04)
         DISPLAY BY NAME g_tsh[l_ac].tsh05
      END IF
   END IF
   
   IF NOT cl_null(g_tsh[l_ac].tsh05) THEN                       
      IF g_tsh[l_ac].tsh05<=0 THEN
         CALL cl_err('g_tsh[l_ac].tsh05','mfg4012',0)
         LET g_tsh[l_ac].tsh05 = g_tsh_t.tsh05      
         DISPLAY BY NAME g_tsh[l_ac].tsh05                 
         RETURN FALSE                               
      END IF
      CALL t253_img10('0')
      IF g_flag = 1 THEN
         RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t253_tsh06_check()
   IF NOT cl_null(g_tsh[l_ac].tsh06) AND NOT cl_null(g_tsh[l_ac].tsh04) THEN
      IF cl_null(g_tsh_t.tsh06) OR cl_null(g_tsh04_t) OR g_tsh_t.tsh06 != g_tsh[l_ac].tsh06 OR g_tsh04_t != g_tsh[l_ac].tsh04 THEN
         LET g_tsh[l_ac].tsh06=s_digqty(g_tsh[l_ac].tsh06,g_tsh[l_ac].tsh04)
         DISPLAY BY NAME g_tsh[l_ac].tsh06
      END IF
   END IF
   
   IF NOT cl_null(g_tsh[l_ac].tsh06) THEN                       
      IF (g_tsh[l_ac].tsh06 != g_tsh_t.tsh06)            
         OR (g_tsh_t.tsh06 IS NULL) THEN                        
         IF g_tsh[l_ac].tsh06<=0 THEN                           
            CALL cl_err('g_tsh[l_ac].tsh06','mfg4012',0)                             
            LET g_tsh[l_ac].tsh06 = g_tsh_t.tsh06      
            DISPLAY BY NAME g_tsh[l_ac].tsh06                 
            RETURN FALSE                                 
         END IF                                                       
      END IF                                                           
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t253_tsh09_check(l_tsh09,l_tsh12)
   DEFINE l_tsh09   LIKE tsh_file.tsh09
   DEFINE l_tsh12   LIKE tsh_file.tsh12
   IF NOT cl_null(g_tsh[l_ac].tsh09) AND NOT cl_null(g_tsh[l_ac].tsh07) THEN
      IF cl_null(g_tsh_t.tsh09) OR cl_null(g_tsh07_t) OR g_tsh_t.tsh09 != g_tsh[l_ac].tsh09 OR g_tsh07_t != g_tsh[l_ac].tsh07 THEN
         LET g_tsh[l_ac].tsh09=s_digqty(g_tsh[l_ac].tsh09,g_tsh[l_ac].tsh07)
         DISPLAY BY NAME g_tsh[l_ac].tsh09
      END IF
   END IF
   
   IF NOT cl_null(g_tsh[l_ac].tsh09) THEN                       
      IF g_tsh[l_ac].tsh09<=0 THEN
         CALL cl_err('g_tsh[l_ac].tsh09','mfg4012',0)
         LET g_tsh[l_ac].tsh09 = g_tsh_t.tsh09      
         DISPLAY BY NAME g_tsh[l_ac].tsh09                 
         RETURN FALSE,'tsh09'                
      END IF
      CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
         RETURNING g_flag,g_ima906,g_ima907
      IF g_ima906 = '2' THEN
         CALL t253_imgg10('1')
      ELSE
         CALL t253_img10('1')
      END IF
      IF g_flag = 1 THEN
         RETURN FALSE,'tsh09' 
      END IF 
      IF cl_null(g_tsh[l_ac].tsh08) THEN LET g_tsh[l_ac].tsh08 = 1 END IF
      LET l_tsh09 = g_tsh[l_ac].tsh08*g_tsh[l_ac].tsh09 
      CALL s_chk_va_setting(g_tsh[l_ac].tsh03)
         RETURNING g_flag,g_ima906,g_ima907
      IF g_ima906 = '2' THEN
         IF g_tsh[l_ac].tsh12 > 0 THEN
            LET l_tsh12 = g_tsh[l_ac].tsh12 * g_tsh[l_ac].tsh11
         END IF
      ELSE
         LET l_tsh12 = 0
      END IF
      CALL t253_du_data_to_correct()
      LET g_tsh[l_ac].tsh05 = l_tsh12 + l_tsh09
      IF g_tsh[l_ac].tsh05 IS NULL OR g_tsh[l_ac].tsh05=0 THEN
         IF g_ima906 MATCHES '[23]' THEN
            RETURN FALSE,'tsh09' 
         ELSE
            RETURN FALSE,'tsh07' 
         END IF
      END IF
   ELSE
      LET l_tsh09 = 0
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE,''
END FUNCTION

FUNCTION t253_tsh12_check(l_tsh09,l_tsh12,l_fac)
   DEFINE l_tsh09   LIKE tsh_file.tsh09
   DEFINE l_tsh12   LIKE tsh_file.tsh12
   DEFINE l_fac     LIKE inb_file.inb08_fac
   IF NOT cl_null(g_tsh[l_ac].tsh12) AND NOT cl_null(g_tsh[l_ac].tsh10) THEN
      IF cl_null(g_tsh_t.tsh12) OR cl_null(g_tsh10_t) OR g_tsh_t.tsh12 != g_tsh[l_ac].tsh12 OR g_tsh10_t != g_tsh[l_ac].tsh10 THEN
         LET g_tsh[l_ac].tsh12=s_digqty(g_tsh[l_ac].tsh12,g_tsh[l_ac].tsh10)
         DISPLAY BY NAME g_tsh[l_ac].tsh12
      END IF
   END IF
   
   IF NOT cl_null(g_tsh[l_ac].tsh12) THEN                       
      IF g_tsh[l_ac].tsh12<=0 THEN
         CALL cl_err('g_tsh[l_ac].tsh12','mfg4012',0)
         LET g_tsh[l_ac].tsh12 = g_tsh_t.tsh12      
         DISPLAY BY NAME g_tsh[l_ac].tsh12                 
         RETURN FALSE                                  
      END IF
      CALL t253_imgg10('0')
      IF g_flag = 1 THEN
         RETURN FALSE   
      END IF
      IF g_ima906 = '2' THEN               
         LET l_tsh12 = g_tsh[l_ac].tsh11*g_tsh[l_ac].tsh12
         IF g_tsh[l_ac].tsh09 > 0 THEN
            LET l_tsh09 = g_tsh[l_ac].tsh09 * g_tsh[l_ac].tsh08
         END IF
      END IF
         IF g_ima906='3' THEN
            IF cl_null(g_tsh[l_ac].tsh09) OR g_tsh[l_ac].tsh09=0 OR
               g_tsh[l_ac].tsh12 <> g_tsh_t.tsh12 OR cl_null(g_tsh_t.tsh12)
            THEN
               LET l_fac = 1
               CALL s_umfchk(g_tsh[l_ac].tsh03,g_tsh[l_ac].tsh10,
                              g_tsh[l_ac].tsh07)
                    RETURNING g_cnt,l_fac
               IF g_cnt = 1 THEN
               ELSE
                 #LET g_tsh[l_ac].tsh09=g_tsh[l_ac].tsh12*g_tsh[l_ac].tsh11
                  LET g_tsh[l_ac].tsh09=g_tsh[l_ac].tsh12*l_fac
               END IF
               DISPLAY BY NAME g_tsh[l_ac].tsh09                 
            END IF
         END IF
      END IF 
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086--add--end--
#No.FUN-C20048 Modify
