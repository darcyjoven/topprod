# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arti100.4gl
# Descriptions...: 流通產品資本資料維護作業
# Date & Author..: No:FUN-BC0076 11/12/20 By fanbj                                         

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20070 12/02/10 By baogc 價格策略單身可錄入多單位
# Modify.........: No:TQC-C20136 12/02/13 By fanbj 產品策略單身錄入稅別資料修改為一筆，AFTER FIELD 營運中心check營運中心以及單身dialog跳轉修
# Modify.........: No:TQC-C20270 12/02/21 By fanbj 服飾行業別時子料件不可修改
# Modify.........: No:TQC-C20357 12/02/22 By baogc 產品策略多稅別中含稅否必須一致
# Modify.........: No:TQC-C20136 12/02/29 By fanbj 批量錄入時稅別資料沒插入rvy_file
# Modify.........: No:TQC-C20543 12/02/29 By fanbj 維護單身資料中，產品策略、價格策略頁簽   需要檢查是否為   “資料中心”
# Modify.........: No:MOD-C30653 12/03/13 By yangxf拿掉所有控卡含稅否一致
# Modify.........: No:FUN-C30306 12/04/02 By pauline 產品多稅別設定不自動彈窗供使用者維護  
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增栏位ima160,ima161,ima162以及相关控管
# Modify.........: No.CHI-C30107 12/06/14 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60050 12/07/09 By yangxf 给rtg12赋值,添加rtg11栏位
# Modify.........: No:FUN-C80049 12/08/13 By xumeimei 開窗多選時給rtg11，rtg12賦值
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80087 12/08/14 By yangxf 修改审核与取消审核后画面图片未及时更新
# Modify.........: No:FUN-D30006 13/03/04 By dongsz 添加ima1030(觸屏分類)欄位
# Modify.........: No:FUN-D30050 13/03/18 By dongsz 產品為券時,增加稅種的檢查
# Modify.........: No:FUN-D30047 13/03/22 By SunLM 增加自動新增價格策略畫面程序
# Modify.........: No:FUN-D30093 13/03/26 By dongsz 資料異動時，更新apci054的邏輯
# Modify.........: No.FUN-D40001 13/04/01 By xumm 条码重复检查逻辑调整
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40044 13/04/19 By dongsz 維護單位時，檢查是否存在庫存單位轉化率，存在時才能維護

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../aim/4gl/aimi100.global"
GLOBALS "../../sub/4gl/s_data_center.global"

DEFINE g_ima         RECORD LIKE ima_file.*,
       g_ima_t       RECORD LIKE ima_file.*,
       g_ima_o       RECORD LIKE ima_file.*,
       g_ima01_t            LIKE ima_file.ima01

DEFINE g_rta             DYNAMIC ARRAY OF RECORD
          rta02             LIKE rta_file.rta02,            
          rta03             LIKE rta_file.rta03,
          rta03_desc        LIKE gfe_file.gfe02,
          rta04             LIKE rta_file.rta04,
          rta05             LIKE rta_file.rta05,
          rtaacti           LIKE rta_file.rtaacti
                         END RECORD,
                         
       g_rta_t           RECORD
          rta02             LIKE rta_file.rta02,
          rta03             LIKE rta_file.rta03,
          rta03_desc        LIKE gfe_file.gfe02,
          rta04             LIKE rta_file.rta04,
          rta05             LIKE rta_file.rta05,
          rtaacti           LIKE rta_file.rtaacti 
                         END RECORD,       
                         
       g_rte             DYNAMIC ARRAY OF RECORD
          rte01             LIKE rte_file.rte01,
          rte02             LIKE rte_file.rte02,
          rte08             LIKE rte_file.rte08,
          taxtype           LIKE gec_file.gec02,
          rte04             LIKE rte_file.rte04,
          rte05             LIKE rte_file.rte05,
          rte06             LIKE rte_file.rte06,
          rte07             LIKE rte_file.rte07,
          rtepos            LIKE rte_file.rtepos 
                         END RECORD,
                         
       g_rte_t           RECORD
          rte01             LIKE rte_file.rte01,
          rte02             LIKE rte_file.rte02,
          rte08             LIKE rte_file.rte08,
          taxtype           LIKE gec_file.gec02,
          rte04             LIKE rte_file.rte04,
          rte05             LIKE rte_file.rte05,
          rte06             LIKE rte_file.rte06,
          rte07             LIKE rte_file.rte07,
          rtepos            LIKE rte_file.rtepos 
                         END RECORD,
                         
       g_rtg             DYNAMIC ARRAY OF RECORD 
          rtg01             LIKE rtg_file.rtg01,
          rtg02             LIKE rtg_file.rtg02, 
          rtg04             LIKE rtg_file.rtg04,
          rtg05             LIKE rtg_file.rtg05,
          rtg06             LIKE rtg_file.rtg06,
          rtg07             LIKE rtg_file.rtg07,
          rtg11             LIKE rtg_file.rtg11,      #FUN-C60050 add
          rtg08             LIKE rtg_file.rtg08,
          rtg10             LIKE rtg_file.rtg10,
          rtg09             LIKE rtg_file.rtg09,
          rtg12             LIKE rtg_file.rtg12,      #FUN-C60050 add
          rtgpos            LIKE rtg_file.rtgpos
                         END RECORD,
                         
       g_rtg_t           RECORD
          rtg01             LIKE rtg_file.rtg01,
          rtg02             LIKE rtg_file.rtg02,
          rtg04             LIKE rtg_file.rtg04,
          rtg05             LIKE rtg_file.rtg05,
          rtg06             LIKE rtg_file.rtg06,
          rtg07             LIKE rtg_file.rtg07,
          rtg11             LIKE rtg_file.rtg11,      #FUN-C60050 add
          rtg08             LIKE rtg_file.rtg08,
          rtg10             LIKE rtg_file.rtg10,
          rtg09             LIKE rtg_file.rtg09,
          rtg12             LIKE rtg_file.rtg12,      #FUN-C60050 add
          rtgpos            LIKE rtg_file.rtgpos       
                         END RECORD,
                         
       g_rty             DYNAMIC ARRAY OF RECORD
          rty01             LIKE rty_file.rty01,
          rty03             LIKE rty_file.rty03,
          rty04             LIKE rty_file.rty04,
          rty04_desc        LIKE geu_file.geu02,
          rty12             LIKE rty_file.rty12,
          rty12_desc        LIKE geu_file.geu02,
          rty05             LIKE rty_file.rty05,
          rty06             LIKE rty_file.rty06,
          rty07             LIKE rty_file.rty07,
          rty08             LIKE rty_file.rty08,
          rty13             LIKE rty_file.rty13,
          rty09             LIKE rty_file.rty09,
          rty10             LIKE rty_file.rty10,
          rty11             LIKE rty_file.rty11,
          rtyacti           LIKE rty_file.rtyacti    
                         END RECORD,
                         
       g_rty_t           RECORD
          rty01             LIKE rty_file.rty01,
          rty03             LIKE rty_file.rty03,
          rty04             LIKE rty_file.rty04,
          rty04_desc        LIKE geu_file.geu02,
          rty12             LIKE rty_file.rty12,
          rty12_desc        LIKE geu_file.geu02,
          rty05             LIKE rty_file.rty05,
          rty06             LIKE rty_file.rty06,
          rty07             LIKE rty_file.rty07,
          rty08             LIKE rty_file.rty08,
          rty13             LIKE rty_file.rty13,
          rty09             LIKE rty_file.rty09,
          rty10             LIKE rty_file.rty10,
          rty11             LIKE rty_file.rty11,
          rtyacti           LIKE rty_file.rtyacti  
                         END RECORD,

       g_errary          DYNAMIC ARRAY OF RECORD 
          db                LIKE type_file.chr21,
          VALUE             STRING,
          FIELD             LIKE ztb_file.ztb03,
          fname             LIKE gae_file.gae04,
          errno             LIKE ze_file.ze01,
          ename             LIKE ze_file.ze03
                         END RECORD,
       
       g_imax            DYNAMIC ARRAY OF RECORD   
          sel               LIKE type_file.chr1,
          ima01             LIKE ima_file.ima01
                         END RECORD,
  
       g_azp             DYNAMIC ARRAY OF RECORD  
          sel               LIKE type_file.chr1,
          azp01             LIKE azp_file.azp01,
          azp02             LIKE azp_file.azp02,
          azp03             LIKE azp_file.azp03
                         END RECORD,

       g_rvy             DYNAMIC ARRAY OF RECORD
           rvy02            LIKE rvy_file.rvy02,
           rte03            LIKE rte_file.rte03,
           rte03_n          LIKE ima_file.ima02,
           rvy03            LIKE rvy_file.rvy03,
           rvy04            LIKE rvy_file.rvy04,
           gec02            LIKE gec_file.gec02,
           gec04            LIKE gec_file.gec04,
           rvy06            LIKE rvy_file.rvy06
                         END RECORD,
                         
       g_rvy_t           RECORD
          rvy02             LIKE rvy_file.rvy02,
          rte03             LIKE rte_file.rte03,
          rte03_n           LIKE ima_file.ima02,
          rvy03             LIKE rvy_file.rvy03,
          rvy04             LIKE rvy_file.rvy04,
           gec02            LIKE gec_file.gec02,
           gec04            LIKE gec_file.gec04,
           rvy06            LIKE rvy_file.rvy06
                         END RECORD,
        g_rvy_o          RECORD
           rvy02            LIKE rvy_file.rvy02,
           rte03            LIKE rte_file.rte03,
           rte03_n          LIKE ima_file.ima02,
           rvy03            LIKE rvy_file.rvy03,
           rvy04            LIKE rvy_file.rvy04,
           gec02            LIKE gec_file.gec02,
           gec04            LIKE gec_file.gec04,
           rvy06            LIKE rvy_file.rvy06
                         END RECORD                

DEFINE g_sql                STRING 
DEFINE g_wc                 STRING 
DEFINE g_wc2,g_wc3          STRING 
DEFINE g_wc4,g_wc5          STRING 
DEFINE g_rec_b1,g_rec_b2    LIKE type_file.num10
DEFINE g_rec_b3,g_rec_b4    LIKE type_file.num10
DEFINE l_ac1,l_ac2          LIKE type_file.num10
DEFINE l_ac3,l_ac4          LIKE type_file.num10
DEFINE l_ac5                LIKE type_file.num10
DEFINE g_forupd_sql         STRING 
DEFINE g_before_input_done  LIKE type_file.num10
DEFINE g_cnt                LIKE type_file.num10
DEFINE msg                  LIKE ze_file.ze03
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num10
DEFINE g_str                STRING 
DEFINE g_flag_b             STRING 
DEFINE g_date               LIKE ima_file.imadate
DEFINE g_modu               LIKE ima_file.imamodu                         
DEFINE g_argv2              STRING   
DEFINE g_argv1              STRING                
DEFINE g_i1                 LIKE type_file.num5     
DEFINE g_icb02              LIKE icb_file.icb02     
DEFINE g_buf_2              LIKE ima_file.ima01     
DEFINE g_ima25_t            LIKE ima_file.ima25 
DEFINE g_gev04              LIKE gev_file.gev04     
DEFINE g_msg                LIKE ze_file.ze03
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_db_type            LIKE type_file.chr21
DEFINE g_ans                LIKE type_file.chr1
DEFINE g_chr2               LIKE type_file.chr1
DEFINE g_dbase              LIKE type_file.chr21
DEFINE g_on_change_02       LIKE type_file.num5    
DEFINE g_on_change_021      LIKE type_file.num5
DEFINE g_u_flag             LIKE type_file.chr1
DEFINE g_sw                 LIKE type_file.num5
DEFINE g_flag2              LIKE type_file.chr1 
DEFINE g_imaicd      RECORD LIKE imaicd_file.*  
DEFINE g_imaicd_t    RECORD LIKE imaicd_file.*  
DEFINE g_imaicd_o    RECORD LIKE imaicd_file.*  
DEFINE g_multi_rte01        STRING             
DEFINE g_multi_rtg01        STRING             
DEFINE g_multi_rty01        STRING              
DEFINE l_flag               LIKE type_file.chr1
DEFINE g_cmd                LIKE type_file.chr1
DEFINE g_n                  LIKE type_file.num5
DEFINE g_lpx38              LIKE lpx_file.lpx38    #FUN-D30050 add
DEFINE g_gca         RECORD LIKE gca_file.*        #FUN-D30093 add

MAIN
   DEFINE l_sma120      LIKE sma_file.sma120    
 
   OPTIONS              #改變一些系統預設值
      INPUT NO WRAP     
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)  

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
   LET g_forupd_sql = " SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE i100_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i100_w WITH FORM "art/42f/arti100" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   CALL i100_init()

   IF g_azw.azw04 = '2' THEN
      CALL cl_set_comp_visible("ima149",TRUE)
   ELSE
      CALL cl_set_comp_visible("ima149",FALSE)
   END IF
  
   CALL cl_set_comp_visible("imaag",FALSE)    
   CALL cl_set_comp_visible("rtg12",FALSE)            #FUN-C60050 add 
   CALL cl_set_comp_visible("ima941,ima940",g_sma.sma124='slk')  
   CALL cl_set_act_visible("produce_sub_parts",g_sma.sma124='slk')
   CALL cl_set_comp_visible("rta02,rte02,rtg02",FALSE) 
   SELECT sma120 INTO l_sma120 FROM sma_file
   IF l_sma120="Y" THEN
      CALL cl_set_comp_visible("ima151",TRUE)
   ELSE
      CALL cl_set_comp_visible("ima151",FALSE)
   END IF
 
  #TQC-C20070 Add Begin ---
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('rtepos',FALSE)
      CALL cl_set_comp_visible("rtgpos",FALSE)
   END IF
  #TQC-C20070 Add End -----
 
   LET g_action_choice = ""
   CALL i100_menu()
 
   CLOSE WINDOW i100_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION i100_cs()
   DEFINE   l_ima151           LIKE ima_file.ima151               
   DEFINE   l_n                LIKE type_file.num5
   DEFINE   lc_qbe_sn          LIKE  gbm_file.gbm01 
   DEFINE   l_table            STRING 
   DEFINE   l_where            STRING 

   CLEAR FORM
 
   #IF cl_null(g_argv1) THEN
   INITIALIZE g_ima.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)    
      CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima06,ima08,ima131,ima1005,                
                             ima1006,ima1030,ima154,ima151,ima940,ima941,imaag,       #FUN-D30006 add ima1030
                             ima120,ima25,ima44,ima31,
                             ima54,ima12,ima39,ima149,ima1010,ima916,
                             ima160,ima161,ima162,                                    #FUN-C50036 add 
                             ima1004,ima1007,ima1008,ima1009,ima915,ima45,
                             ima46,ima47,ima09,ima10,ima11,ima53,ima91,
                             ima531,ima33,imauser,imagrup,imaoriu,imamodu,
                             imadate,imaorig,imaacti
                             
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            IF g_sma.sma124 = 'slk' THEN
               CALL cl_set_comp_visible("ima940,ima941",TRUE) 
            ELSE
               CALL cl_set_comp_visible("ima940,ima941",FALSE)
            END IF
            
         AFTER FIELD ima151
            LET l_ima151=GET_FLDBUF(ima151)
            IF l_ima151="Y" THEN
               CALL cl_set_comp_visible("imaag",TRUE)
               NEXT FIELD imaag
            ELSE
               CALL cl_set_comp_visible("imaag",FALSE)
            END IF
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01) #料件編號   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
                  
               WHEN INFIELD(ima06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imz"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06

               WHEN INFIELD(ima131) #產品分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima131_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131

               WHEN INFIELD(ima1005) #品牌
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima1005_2"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1005
                  NEXT FIELD ima1005

               WHEN INFIELD(ima1006) #系列
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima1006_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1006
                  NEXT FIELD ima1006

              #FUN-D30006--add--str---
               WHEN INFIELD(ima1030) #觸屏分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rzh01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1030
                  NEXT FIELD ima1030
              #FUN-D30006--add--end---

               WHEN INFIELD(ima940) #顏色/組
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima940"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima940
                  NEXT FIELD ima940   

               WHEN INFIELD(ima941) #尺寸/組
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima941"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima941
                  NEXT FIELD ima941
            
               WHEN INFIELD(imaag) #屬性組
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imaag"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaag
                  NEXT FIELD imaag

               WHEN INFIELD(ima25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima25"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "D"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima25
                  NEXT FIELD ima25
                  
               WHEN INFIELD(ima44) #採購單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima44"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima44
                  NEXT FIELD ima44

               WHEN INFIELD(ima31) #銷售單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima31"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima31
                  NEXT FIELD ima31
                  
               WHEN INFIELD(ima54) #主供應商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima54"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima54
                  NEXT FIELD ima54

               WHEN INFIELD(ima12) #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima12_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima12
                  NEXT FIELD ima12
                  
               WHEN INFIELD(ima39) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima39"   
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima39
                  NEXT FIELD ima39

               WHEN INFIELD(ima149) #代銷科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima149" 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima149
                  NEXT FIELD ima149

               WHEN INFIELD(ima916) #資料來源
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima916" 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima916
                  NEXT FIELD ima916

#FUN-C50036 add begin ---
               WHEN INFIELD(ima162) #称重单位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima162"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima162
                  NEXT FIELD ima162
#FUN-C50036 add end   ---

               WHEN INFIELD(ima1004) #類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa" 
                  LET g_qryparam.arg1 = '1'     
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1004
                  NEXT FIELD ima1004
                  
               WHEN INFIELD(ima1007) #型別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa" 
                  LET g_qryparam.arg1 = '4'    
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1007
                  NEXT FIELD ima1007
                  
               WHEN INFIELD(ima1008) #規格
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa" 
                  LET g_qryparam.arg1 = '5'     
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1008
                  NEXT FIELD ima1008
                  
               WHEN INFIELD(ima1009) #屬性
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa" 
                  LET g_qryparam.arg1 = '6'     
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1009
                  NEXT FIELD ima1009
                  
               WHEN INFIELD(ima09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf" 
                  LET g_qryparam.arg1 = "D"     
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima09
                  NEXT FIELD ima09
                  
               WHEN INFIELD(ima10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf" 
                  LET g_qryparam.arg1 = "E"     
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima10
                  NEXT FIELD ima10
                  
               WHEN INFIELD(ima11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf" 
                  LET g_qryparam.arg1 = "F"     
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima11
                  NEXT FIELD ima11
 
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT 

      CONSTRUCT g_wc2 ON rta03,rta04,rta05,traacti
                    FROM s_rta[1].rta03,s_rta[1].rta04,s_rta[1].rta05,
                         s_rta[1].rtaacti   
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION controlp
            CASE 
               #條碼資料頁簽單位編號
               WHEN INFIELD(rta03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rta03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rta03
                  NEXT FIELD rta03
               OTHERWISE EXIT CASE
            END CASE              
      END CONSTRUCT 

      CONSTRUCT g_wc3 ON rte01,rte08,rte04,rte05,rte06,rte07,rtepos
                    FROM s_rte[1].rte01,s_rte[1].rte08,s_rte[1].rte04,
                         s_rte[1].rte05,s_rte[1].rte06,s_rte[1].rte07,
                         s_rte[1].rtepos   
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION controlp
            CASE 
               #產品策略編號
               WHEN INFIELD(rte01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rte01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rte01
                  NEXT FIELD rte01
         
               #稅種
               WHEN INFIELD(rte08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rte08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rte08
                  NEXT FIELD rte08          
                  
               OTHERWISE EXIT CASE
            END CASE              
      END CONSTRUCT

      CONSTRUCT g_wc4 ON rtg01,rtg04,rtg05,rtg06,rtg07,rtg11,rtg08,rtg10,             #FUN-C60050 add rtg11
                         rtg09,rtg12,rtepos                                           #FUN-C60050 add rtg12
                    FROM s_rtg[1].rtg01,s_rtg[1].rtg04,s_rtg[1].rtg05,
                         s_rtg[1].rtg06,s_rtg[1].rtg07,s_rtg[1].rtg11,s_rtg[1].rtg08, #FUN-C60050 add rtg11
                         s_rtg[1].rtg10,s_rtg[1].rtg09,s_rtg[1].rtg12,s_rtg[1].rtgpos #FUN-C60050 add rtg12   
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION controlp
            CASE 
               #價格策略編號
               WHEN INFIELD(rtg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rtg01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtg01
                  NEXT FIELD rtg01
         
               #計價單位
               WHEN INFIELD(rtg04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rtg04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtg04
                  NEXT FIELD rtg04          
                  
               OTHERWISE EXIT CASE
            END CASE              
      END CONSTRUCT  

      CONSTRUCT g_wc5 ON rty01,rty03,rty04,rty12,rty05,rty06,rty07,rty08,
                         rty13,rty09,rty10,rty11,rtyacti
                    FROM s_rty[1].rty01,s_rty[1].rty03,s_rty[1].rty04,
                         s_rty[1].rty12,s_rty[1].rty05,s_rty[1].rty06,
                         s_rty[1].rty07,s_rty[1].rty08,s_rty[1].rty13,
                         s_rty[1].rty09,s_rty[1].rty10,s_rty[1].rty11,
                         s_rty[1].rtyacti   
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION controlp
            CASE 
               #營運中心編號
               WHEN INFIELD(rty01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rty01_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty01
                  NEXT FIELD rty01
         
               #配送中心
               WHEN INFIELD(rty04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rty04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty04
                  NEXT FIELD rty04          

               #採購中心
               WHEN INFIELD(rty12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rty12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty12
                  NEXT FIELD rty12   

               #主供應商
               WHEN INFIELD(rty05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rty05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty05
                  NEXT FIELD rty05

               #採購多角流程
               WHEN INFIELD(rty10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rty10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty10
                  NEXT FIELD rty10 

               #退貨多角流程
               WHEN INFIELD(rty11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rty11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty11
                  NEXT FIELD rty11 
            
               OTHERWISE EXIT CASE
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

      ON ACTION ACCEPT
         ACCEPT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG   
   END DIALOG 
  # ELSE
  #    LET g_wc = "ima01 = '",g_argv1,"'"
  # END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
   
   CALL cl_set_comp_visible("imaag",FALSE)                 

  #LET g_sql = " SELECT * "     #FUN-C60050 Mark
   LET g_sql = " SELECT ima01 " #FUN-C60050 ADD By baogc
   LET l_table = " FROM ima_file "
   LET l_where = " WHERE ",g_wc CLIPPED 

   IF g_wc2 <> ' 1=1' THEN
      LET l_table = l_table, " ,rta_file "
      LET l_where = l_where, " AND rta01 = ima01 AND ",g_wc2 CLIPPED  
   END IF 

   IF g_wc3 <> ' 1=1' THEN
      LET l_table = l_table, " ,rte_file "
      LET l_where = l_where, " AND rte03 = ima01 AND ",g_wc3 CLIPPED   
   END IF 

   IF g_wc4 <> ' 1=1' THEN 
      LET l_table = l_table, " ,rtg_file "
      LET l_where = l_where, " AND rtg03 = ima01 AND ",g_wc4 CLIPPED 
   END IF 

   IF g_wc5 <> ' 1=1' THEN 
      LET l_table = l_table, " ,rty_file "
      LET l_where = l_where, " AND rty02 = ima01 AND ",g_wc5 CLIPPED 
   END IF 

   LET g_sql = g_sql,l_table,l_where," ORDER BY ima01"
   PREPARE i100_prepare FROM g_sql
   DECLARE i100_cs SCROLL CURSOR WITH HOLD FOR i100_prepare

   LET g_sql = "SELECT DISTINCT COUNT(ima01) ",l_table,l_where 
   PREPARE i100_precount FROM g_sql
   DECLARE i100_count CURSOR FOR i100_precount
END FUNCTION
  
FUNCTION i100_menu()
   DEFINE l_cmd    STRING 
 
   WHILE TRUE
      CALL i100_bp("G")
      
      CASE g_action_choice   
         WHEN "insert"
            IF g_aza.aza60 = 'N' THEN      #不使用客戶申請作業時,才可按新增!
                IF cl_chk_act_auth() THEN    
                     CALL i100_a()
                END IF
            ELSE
                CALL cl_err('','aim-152',1)
                #不使用客戶申請作業時,才可按新增!
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u('u')
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i100_x()
               CALL i100_show()           
            END IF
 
         WHEN "reproduce"
            IF g_aza.aza60 = 'N' THEN  #CHI-740027 add if判斷
                IF cl_chk_act_auth() THEN
                   CALL i100_copy() 
                END IF
            ELSE
                #參數設定使用料件申請作業時,不可做複製!
                CALL cl_err('','aim-154',1)
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF   

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rta),base.TypeInfo.create(g_rte),base.TypeInfo.create(g_rtg))
            END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE 
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_ima.ima01 IS NOT NULL THEN
                  LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i100_confirm()
            END IF    
 
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL i100_unconfirm()
            END IF 

         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL i100_carry()
            END IF
 
         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ima.ima01) THEN 
                  IF NOT cl_null(g_ima.ima916) THEN
                     SELECT gev04 INTO g_gev04 
                       FROM gev_file
                      WHERE gev01 = '1'
                        AND gev02 = g_ima.ima916
                  ELSE      #歷史資料,即沒有ima916的值
                     SELECT gev04 INTO g_gev04
                       FROM gev_file
                      WHERE gev01 = '1'
                        AND gev02 = g_plant
                  END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "1" "',g_prog,'" "',g_ima.ima01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF      

         WHEN "add_multi_attr_sub"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_ima.ima01) THEN
                  CALL cl_err('',-400,1)
               ELSE
                  IF g_ima.ima1010 !='1' THEN
                     CALL cl_err(g_ima.ima01,'aim-450',1)
                  ELSE
                     CALL saimi311(g_ima.ima01)
                     IF g_sma.sma124 = 'slk' THEN
                        CALL i100_upd_ima()
                     END IF
                     LET INT_FLAG=0
                     CALL i100_show()
                     IF g_ima.ima151 = 'Y' THEN
                        CALL i100_carry_sub()
                     END IF
                  END IF
               END IF
            END IF

         WHEN "produce_sub_parts"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_ima.ima01) THEN
                  CALL cl_err('',-400,1)
               ELSE
                  CALL i100_produce_sub_parts()
                  IF g_ima.ima151 = 'Y' THEN
                     CALL i100_carry_sub()
                  END IF
               END IF
            END IF

         END CASE
   END WHILE
END FUNCTION 

FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   LET g_action_choice = NULL 
   LET g_cmd = ' ' 

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rta TO s_rta.* ATTRIBUTE(COUNT=g_rec_b1)
 
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

      DISPLAY ARRAY g_rte TO s_rte.* ATTRIBUTE(COUNT=g_rec_b2)
 
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
                   
         #TQC-C20136--start add-------------------
         ON ACTION tax_detail1
            #LET g_action_choice = "tax_detail1"
            CALL i100_detail()    
            #EXIT DIALOG
         #TQC-C20136--end add---------------------
      END DISPLAY    

      DISPLAY ARRAY g_rtg TO s_rtg.* ATTRIBUTE(COUNT=g_rec_b3)
 
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

      DISPLAY ARRAY g_rty TO s_rty.* ATTRIBUTE(COUNT=g_rec_b4)
 
         BEFORE DISPLAY
            DISPLAY g_rec_b4 TO FORMONLY.cn2
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac4 = ARR_CURR()
            CALL cl_show_fld_cont()

         ON ACTION detail
            LET g_action_choice = "detail"
            LET g_flag_b = '4'
            LET l_ac4 = 1
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '4'
            LET l_ac4 = ARR_CURR()
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
         LET g_action_choice = "reproduce"     
         EXIT DIALOG 
         
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG
         
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG

      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG 

      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         EXIT DIALOG 

      #確認  
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG 

      #取消確認   
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG

      #資料拋磚   
      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DIALOG 

      #資料拋磚歷史
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DIALOG    
         
      #新增多屬性子料件
      ON ACTION add_multi_attr_sub
         LET g_action_choice="add_multi_attr_sub" 
         EXIT DIALOG

      #自動產生多屬性子料件
      ON ACTION produce_sub_parts
         LET g_action_choice="produce_sub_parts"
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
 
FUNCTION i100_a()
   MESSAGE ""

   IF s_shut(0) THEN RETURN END IF
   
   CLEAR FORM
   CALL g_rta.clear()
   CALL g_rte.clear()
   CALL g_rtg.clear()
   CALL g_rty.clear()

   LET g_wc = NULL 
   LET g_wc2 = NULL 
   LET g_wc3 = NULL 
   LET g_wc4 = NULL 
   LET g_wc5 = NULL 
   
   INITIALIZE g_ima.* LIKE ima_file.*
   LET g_ima01_t = NULL
   LET g_ima_t.* = g_ima.*
   LET g_ima_o.*=g_ima.*
   CALL cl_opmsg('a')
      
   WHILE TRUE
      LET g_ima.ima08 = 'P'
      LET g_ima.ima120 = '1'                       
      LET g_ima.ima45 = 0
      LET g_ima.ima46 = 0
      LET g_ima.ima47 = 0
      LET g_ima.ima910 = ' '
      LET g_ima.ima915 = '0'
      LET g_ima.ima916 = g_plant
      LET g_ima.ima150 = ' '
      LET g_ima.ima151 = 'N'
      LET g_ima.ima154 = 'N'
      LET g_ima.ima152 = ' '
      LET g_ima.ima926 = 'N'
      LET g_ima.ima022 = '0'
      LET g_ima.ima156 = 'N'
      LET g_ima.ima158 = 'N'
      LET g_ima.ima927 = 'N'
      LET g_ima.ima159 = '3'
      LET g_ima.ima928 = 'N'
      LET g_ima.ima1010 = '0'
      LET g_ima.ima160 = 'N'       #FUN-C50036 add
      LET g_ima.imauser = g_user
      LET g_ima.imagrup = g_grup
      LET g_ima.imadate = g_today
      LET g_ima.imaacti = 'Y'
      LET g_ima.imaoriu = g_user
      LET g_ima.imaorig = g_grup
      
      CALL cl_set_comp_visible("imaag",FALSE)
      IF g_aza.aza28 = 'Y' THEN
         CALL s_auno(g_ima.ima01,'1','') RETURNING g_ima.ima01,g_ima.ima02
      END IF
     
      CALL i100_i("a")                      
 
      IF INT_FLAG THEN          
         INITIALIZE g_ima.* TO NULL
         CALL g_rta.clear()
         CALL g_rte.clear()
         CALL g_rtg.clear()
         CALL g_rty.clear()
         LET INT_FLAG = 0
         LET g_ima01_t = NULL 
         CALL cl_err('',9001,0)
         CALL cl_set_comp_visible("imaag",FALSE)
         CLEAR FORM
         RETURN 
      END IF
 
      IF cl_null(g_ima.ima01) THEN 
         CONTINUE WHILE
      END IF
 
      CALL i100_a_inschk()
      LET g_success = 'Y'
      BEGIN WORK  
      INSERT INTO ima_file VALUES g_ima.*
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE 
         COMMIT WORK 
         SELECT * INTO g_ima.* 
           FROM ima_file
          WHERE ima01 = g_ima.ima01
         CALL i100_show()
      END IF
      
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i100_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_ima120     LIKE ima_file.ima120
   DEFINE l_n          LIKE type_file.num10       
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_gca07      LIKE gca_file.gca07   #FUN-D30093 add
   DEFINE l_gcb09      LIKE gcb_file.gcb09   #FUN-D30093 add
   DEFINE l_rzk05      LIKE rzk_file.rzk05   #FUN-D30093 add
   DEFINE l_str        LIKE type_file.chr100 #FUN-D30093 add

   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima06,
                   g_ima.ima08,g_ima.ima131,g_ima.ima1005,g_ima.ima1006,g_ima.ima1030,    #FUN-D30006 add g_ima.ima1030
                   g_ima.ima154,g_ima.ima151,g_ima.ima940,g_ima.ima941,
                   g_ima.imaag,g_ima.ima120,g_ima.ima25,g_ima.ima44,
                   g_ima.ima31,g_ima.ima54,g_ima.ima12,g_ima.ima39,
#                  g_ima.ima149,g_ima.ima1010,g_ima.ima916,g_ima.ima1004,                                             #FUN-C50036 mark
                   g_ima.ima149,g_ima.ima1010,g_ima.ima916,g_ima.ima160,g_ima.ima161,g_ima.ima162,g_ima.ima1004,      #FUN-C50036 add
                   g_ima.ima1007,g_ima.ima1008,g_ima.ima1009,g_ima.ima915,
                   g_ima.ima45,g_ima.ima46,g_ima.ima47,g_ima.ima09,
                   g_ima.ima10,g_ima.ima11,g_ima.ima53,g_ima.ima91,
                   g_ima.ima531,g_ima.ima33,g_ima.imauser,g_ima.imagrup,
                   g_ima.imaoriu,g_ima.imamodu,g_ima.imadate,g_ima.imaorig,
                   g_ima.imaacti 

   INPUT BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima06,
                   g_ima.ima08,g_ima.ima131,g_ima.ima1005,g_ima.ima1006,g_ima.ima1030,    #FUN-D30006 add g_ima.ima1030
                   g_ima.ima154,g_ima.ima151,g_ima.ima940,g_ima.ima941,
                   g_ima.imaag,g_ima.ima120,g_ima.ima25,g_ima.ima44,
                   g_ima.ima31,g_ima.ima54,g_ima.ima12,g_ima.ima39,
#                  g_ima.ima149,g_ima.ima1010,g_ima.ima916,g_ima.ima1004,                                              #FUN-C50036 mark
                   g_ima.ima149,g_ima.ima1010,g_ima.ima916,g_ima.ima160,g_ima.ima161,g_ima.ima162,g_ima.ima1004,       #FUN-C50036 add
                   g_ima.ima1007,g_ima.ima1008,g_ima.ima1009,g_ima.ima915,
                   g_ima.ima45,g_ima.ima46,g_ima.ima47,g_ima.ima09,
                   g_ima.ima10,g_ima.ima11,g_ima.ima53,g_ima.ima91,
                   g_ima.ima531,g_ima.ima33,g_ima.imauser,g_ima.imagrup,
                   g_ima.imaoriu,g_ima.imamodu,g_ima.imadate,g_ima.imaorig,
                   g_ima.imaacti WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)       
         LET g_before_input_done = TRUE
         #IF p_cmd = 'u' THEN
         #   LET g_ima25_t = g_ima.ima25
         #END IF
         #IF p_cmd = 'a' THEN
         #   LET g_ima25_t = NULL
         #END IF
         #CALL cl_chg_comp_att("ima01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")

      BEFORE FIELD ima01
         IF g_sma.sma60 = 'Y' THEN# 若須分段輸入
            CALL s_inp5(6,14,g_ima.ima01) RETURNING g_ima.ima01
            DISPLAY BY NAME g_ima.ima01
         END IF

      #产品编号
      AFTER FIELD ima01
         IF NOT i100_chk_ima01(p_cmd) THEN
            NEXT FIELD CURRENT
         END IF

      BEFORE FIELD ima02
         IF g_sma.sma64='Y' AND cl_null(g_ima.ima02) THEN
            CALL s_desinp(6,4,g_ima.ima02) RETURNING g_ima.ima02
            DISPLAY BY NAME g_ima.ima02
         END IF 
      
      ON CHANGE ima151
        CALL cl_set_comp_visible("imaag",g_ima.ima151='Y')
        IF NOT i100_chk_imaag() THEN
            NEXT FIELD CURRENT
        END IF

      BEFORE FIELD ima151
         IF p_cmd = 'u' THEN
            IF g_ima.ima1010 = '1' THEN
               CALL cl_set_comp_entry("ima151",FALSE)
            END IF
         END IF
      
      AFTER FIELD ima151
         IF g_ima.ima151="Y" THEN
            IF g_sma.sma124 = 'slk' THEN
               CALL cl_set_comp_visible("ima940,ima941",TRUE)
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_n =0 ) THEN            
                  CALL cl_set_comp_entry("ima940,ima941",TRUE)             
               END IF                                                      
               CALL cl_set_comp_entry("imaag",FALSE)                       
               IF g_azw.azw04 = '1'  THEN
                  CALL cl_set_comp_entry("ima940,ima941",FALSE)
                  IF p_cmd='a' THEN
                     CALL cl_set_comp_entry("imaag",TRUE)
                     CALL cl_set_comp_required("imaag",TRUE)
                  END IF
               END IF
            END IF
         ELSE
            CALL cl_set_comp_entry("ima940",FALSE)
            CALL cl_set_comp_entry("ima941",FALSE)
            LET g_ima.ima940 = NULL
            LET g_ima.ima941 = NULL
            LET g_ima.imaag  = NULL
            DISPLAY BY NAME g_ima.ima940,g_ima.ima941,g_ima.imaag
         END IF

      AFTER FIELD ima940
         IF g_azw.azw04 <> '1' THEN
            IF g_ima.ima940 IS NOT NULL THEN
               IF p_cmd = "a" OR
                   (p_cmd = "u" AND g_ima.ima940 != g_ima_t.ima940) THEN
                   CALL i100_ima940('d')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('g_ima.ima940:',g_errno,1)
                      LET g_ima.ima940 = g_ima_t.ima940
                      DISPLAY BY NAME g_ima.ima940
                      NEXT FIELD ima940
                   END IF
               END IF
            ELSE
               IF g_ima.ima151 = 'Y' THEN
                  CALL cl_err('',-1124,1)
                  NEXT FIELD ima940
               END IF
            END IF
         END IF

      AFTER FIELD ima941
         IF g_azw.azw04 <> '1' THEN
            IF g_ima.ima941 IS NOT NULL THEN
               IF p_cmd = "a" OR
                   (p_cmd = "u" AND g_ima.ima941 != g_ima_t.ima941) THEN
                   CALL i100_ima941('d')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('g_ima.ima941:',g_errno,1)
                      LET g_ima.ima941 = g_ima_t.ima941
                      DISPLAY BY NAME g_ima.ima941
                      NEXT FIELD ima941
                   END IF
               END IF
            ELSE
               IF g_ima.ima151 = 'Y' THEN
                  CALL cl_err('',-1124,1)
                  NEXT FIELD ima941
               END IF
            END IF
         END IF
 
      ON CHANGE ima02
         IF (g_aza.aza44 = "Y") AND cl_null(g_ima.ima01) THEN
            NEXT FIELD ima01
         END IF 
         CALL i100_chg_ima02()
 
      ON CHANGE ima021
         IF (g_aza.aza44 = "Y") AND cl_null(g_ima.ima01) THEN
            NEXT FIELD ima01
         END IF   
         CALL i100_chg_ima021()

      AFTER FIELD ima06                     #分群碼
         IF NOT i100_chk_ima06(p_cmd) THEN
            NEXT FIELD CURRENT
         ELSE
            IF cl_null(g_errno) AND g_ans = "1"  THEN
               SELECT imz150,imz152,imz156,imz157,imz158 
                 INTO g_ima.ima150,g_ima.ima152,g_ima.ima156,g_ima.ima157,g_ima.ima158
                 FROM imz_file
                WHERE imz01 = g_ima.ima06
               LET g_errno = ''
               CALL i100_show()
            END IF
            IF NOT cl_null(g_errno) AND g_ans = "1" THEN
               LET INT_FLAG = 1
               EXIT INPUT
            END IF
         END IF

      AFTER FIELD ima131
         IF NOT cl_null(g_ima.ima131) THEN
            CALL i100_ima131()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_ima.ima131 = g_ima_t.ima131
               DISPLAY BY NAME g_ima.ima131
               NEXT FIELD ima131
            END IF  
         END IF    

     #FUN-D30006--add--str---
      AFTER FIELD ima1030
         IF NOT cl_null(g_ima.ima1030) THEN
            CALL i100_ima1030()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ima.ima1030 = g_ima_t.ima1030
               DISPLAY BY NAME g_ima.ima1030
               NEXT FIELD ima1030
            END IF
         END IF
     #FUN-D30006--add--end---
 
      AFTER FIELD imaag
         IF NOT i100_chk_imaag() THEN
            NEXT FIELD CURRENT
         END IF
 
      BEFORE FIELD ima08
         CALL i100_set_entry(p_cmd)
 
      AFTER FIELD ima08  #來源碼
         IF NOT i100_chk_ima08(p_cmd) THEN
            NEXT FIELD CURRENT
         END IF
  
      AFTER FIELD ima09                     #其他分群碼一
         IF NOT i100_chk_ima09() THEN
            NEXT FIELD CURRENT
         END IF
         LET g_ima_o.ima09 = g_ima.ima09
 
      AFTER FIELD ima10                     #其他分群碼二
         IF NOT i100_chk_ima10() THEN
            NEXT FIELD CURRENT
         END IF
         LET g_ima_o.ima10 = g_ima.ima10
 
      AFTER FIELD ima11                     #其他分群碼三
         IF NOT i100_chk_ima11() THEN
            NEXT FIELD CURRENT
         END IF
         LET g_ima_o.ima11 = g_ima.ima11

      AFTER FIELD ima12                     #其他分群碼四
         IF NOT i100_chk_ima12() THEN
            NEXT FIELD CURRENT
         END IF
         LET g_ima_o.ima12 = g_ima.ima12
 
      AFTER FIELD ima25            #庫存單位
         IF NOT i100_chk_ima25() THEN
            NEXT FIELD CURRENT
         END IF
         IF NOT cl_null(g_ima.ima25) AND p_cmd='u' THEN
            SELECT COUNT(*) INTO l_n 
              FROM ima_file
             WHERE (ima63 <> g_ima.ima25 OR
                    ima31 <> g_ima.ima25 OR
                    ima44 <> g_ima.ima25 OR
                    ima55 <> g_ima.ima25 
                   )
               AND ima01=g_ima.ima01
            IF l_n > 0 THEN
               LET g_msg=cl_getmsg('aim-020',g_lang)
               IF cl_prompt(0,0,g_msg) THEN
                  CALL i100_a_updchk()
               END IF
            ELSE
               IF g_ima.ima25<>g_ima_o.ima25 THEN
                  CALL i100_a_updchk()
               END IF
            END IF
         END IF
        #新增時,若有修改庫存單位(ima25)也應詢問aim-020 
         IF NOT cl_null(g_ima.ima25) AND p_cmd='a' THEN
            IF g_ima.ima25 <> g_ima_o.ima25 OR
               g_ima.ima63 <> g_ima.ima25 OR
               g_ima.ima31 <> g_ima.ima25 OR
               g_ima.ima44 <> g_ima.ima25 OR
               g_ima.ima55 <> g_ima.ima25 THEN
               LET g_msg=cl_getmsg('aim-020',g_lang)
               IF cl_prompt(0,0,g_msg) THEN
                  CALL i100_a_updchk()
               END IF
            END IF
         END IF
         IF cl_null(g_ima.ima31) THEN
            LET g_ima.ima31 = g_ima.ima25
            LET g_ima.ima31_fac = 1
         END IF
         IF cl_null(g_ima.ima44) THEN
            LET g_ima.ima44 = g_ima.ima25
            LET g_ima.ima44_fac = 1
         END IF
         DISPLAY BY NAME g_ima.ima31,g_ima.ima31_fac,g_ima.ima44,g_ima.ima44_fac

         LET g_ima_o.ima25 = g_ima.ima25
         LET g_ima.ima86=g_ima.ima25
         CALL i100_unit_fac()
         LET g_ima25_t = g_ima.ima25

      AFTER FIELD ima44
         IF NOT cl_null(g_ima.ima44) THEN 
            CALL i100_gfe(g_ima.ima44)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ima.ima44 = g_ima_t.ima44
               DISPLAY BY NAME g_ima.ima44
               NEXT FIELD ima44 
            END IF 
            CALL s_umfchk(g_ima.ima01,g_ima.ima44,g_ima.ima25)
            RETURNING g_sw,g_ima.ima44_fac
            DISPLAY BY NAME g_ima.ima44_fac
         END IF    

      AFTER FIELD ima31
         IF NOT cl_null(g_ima.ima31) THEN
            CALL i100_gfe(g_ima.ima31)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_ima.ima31 = g_ima.ima31
               DISPLAY BY NAME g_ima.ima31
               NEXT FIELD ima31
            END IF  
            CALL s_umfchk(g_ima.ima01,g_ima.ima31,g_ima.ima25)
            RETURNING g_sw,g_ima.ima31_fac
            DISPLAY BY NAME g_ima.ima31_fac
         END IF    
             
      AFTER FIELD ima39
         IF NOT cl_null(g_ima.ima39) OR g_ima.ima39 != ' '  THEN
            IF NOT i100_chk_ima39() THEN
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag02"                                   
               LET g_qryparam.default1 = g_ima.ima39  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima39 CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_ima.ima39
               DISPLAY BY NAME g_ima.ima39  
               NEXT FIELD ima39
            END IF
            SELECT aag02 INTO l_aag02 FROM aag_file
                   WHERE aag01 = g_ima.ima39
                      AND aag07 != '1' 
                      AND aag00 = g_aza.aza81
            MESSAGE l_aag02 CLIPPED
         END IF
         LET g_ima_o.ima39 = g_ima.ima39
 
      AFTER FIELD ima149
         IF NOT cl_null(g_ima.ima149) OR g_ima.ima149 != ' '  THEN
            IF NOT i100_chk_ima149() THEN
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag02"                                   
               LET g_qryparam.default1 = g_ima.ima149  
               LET g_qryparam.construct = 'N'                
               LET g_qryparam.arg1 = g_aza.aza81  
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_ima.ima149  CLIPPED,"%' "                                                                        
               CALL cl_create_qry() RETURNING g_ima.ima149  
               DISPLAY BY NAME g_ima.ima149    
               NEXT FIELD ima149
            END IF
            SELECT aag02 INTO l_aag02 FROM aag_file
                   WHERE aag01 = g_ima.ima149
                      AND aag07 != '1' 
                      AND aag00 = g_aza.aza81
            MESSAGE l_aag02 CLIPPED
         END IF
         LET g_ima_o.ima149 = g_ima.ima149

      AFTER FIELD ima1005
         IF NOT cl_null(g_ima.ima1005) THEN 
            CALL i100_tqa(g_ima.ima1005,'2')  
            IF NOT cl_null(g_errno) THEN  
               CALL cl_err('',g_errno,0)
               LET g_ima.ima1005 = g_ima_t.ima1005
               DISPLAY BY NAME g_ima.ima1005
               NEXT FIELD ima1005 
            END IF 
         END IF 

      AFTER FIELD ima1006   
         IF NOT cl_null(g_ima.ima1006) THEN 
            CALL i100_tqa(g_ima.ima1006,'3')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET g_ima.ima1006 = g_ima_t.ima1006
               DISPLAY BY NAME g_ima.ima1006
               NEXT FIELD ima1006 
            END IF 
         END IF

      AFTER FIELD ima54
         IF NOT cl_null(g_ima.ima54) THEN 
             CALL i100_ima54()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_ima.ima54 = g_ima_t.ima54
                DISPLAY BY NAME g_ima.ima54
                NEXT FIELD ima54 
             END IF 
          END IF

      AFTER FIELD ima1004    
         IF NOT cl_null(g_ima.ima1004) THEN 
             CALL i100_tqa(g_ima.ima1004,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_ima.ima1004 = g_ima_t.ima1004
                DISPLAY BY NAME g_ima.ima1004
                NEXT FIELD ima1004 
             END IF 
          END IF

      AFTER FIELD ima1007
         IF NOT cl_null(g_ima.ima1007) THEN 
             CALL i100_tqa(g_ima.ima1007,'4')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_ima.ima1007 = g_ima_t.ima1007
                DISPLAY BY NAME g_ima.ima1007
                NEXT FIELD ima1007 
             END IF 
          END IF    

      AFTER FIELD ima1008
         IF NOT cl_null(g_ima.ima1008) THEN 
            CALL i100_tqa(g_ima.ima1008,'5')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ima.ima1008 = g_ima_t.ima1008
               DISPLAY BY NAME g_ima.ima1008
               NEXT FIELD ima1008 
            END IF 
         END IF

      AFTER FIELD ima1009
         IF NOT cl_null(g_ima.ima1009) THEN 
             CALL i100_tqa(g_ima.ima1009,'6')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_ima.ima1009 = g_ima_t.ima1009
                DISPLAY BY NAME g_ima.ima1009
                NEXT FIELD ima1009
             END IF 
         END IF      

      AFTER FIELD ima45
         IF NOT cl_null(g_ima.ima45) THEN 
            IF g_ima.ima45 < 0 THEN
               CALL cl_err('','alm1495',0)
               LET g_ima.ima45 = g_ima_t.ima45
               DISPLAY BY NAME g_ima.ima45
               NEXT FIELD ima45 
            END IF 
         END IF     

      AFTER FIELD ima46
         IF NOT cl_null(g_ima.ima46) THEN 
            IF g_ima.ima46 < 0 THEN
               CALL cl_err('','alm1496',0)
               LET g_ima.ima46 = g_ima_t.ima46
               DISPLAY BY NAME g_ima.ima46
               NEXT FIELD ima46 
            END IF 
         END IF   

      AFTER FIELD ima47
         IF NOT cl_null(g_ima.ima47) THEN 
            IF g_ima.ima47 < 0 THEN
               CALL cl_err('','alm1497',0)
               LET g_ima.ima47 = g_ima_t.ima47
               DISPLAY BY NAME g_ima.ima47
               NEXT FIELD ima47 
            END IF 
         END IF   

#FUN-C50036 add begin ---
      ON CHANGE ima160
         IF g_ima.ima160 = 'Y' THEN
            CALL cl_set_comp_entry("ima161,ima162",TRUE)
            CALL cl_set_comp_required("ima161,ima162",TRUE)
         ELSE 
            CALL cl_set_comp_entry("ima161,ima162",FALSE)
            CALL cl_set_comp_required("ima161,ima162",FALSE)
            LET g_ima.ima161 = ''
            LET g_ima.ima162 = ''
            DISPLAY BY NAME g_ima.ima161,g_ima.ima162
         END IF 

      AFTER FIELD ima162
         IF NOT cl_null(g_ima.ima162) THEN
            CALL i100_ima162() 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ima.ima162 = g_ima_t.ima162
               NEXT FIELD ima162
            END IF 
         END IF 
#FUN-C50036 add end -----
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         #LET g_flag='N'
         LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
         LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
         IF INT_FLAG THEN
             EXIT INPUT
         END IF
         IF g_sma.sma124 = 'slk' THEN
            IF g_azw.azw04 <> '1' THEN
               LET g_ima.imaag = g_ima.ima940,"-",g_ima.ima941
               DISPLAY BY NAME g_ima.imaag
               IF g_ima.imaag IS NULL OR g_ima.imaag = " " THEN
                   CALL cl_err('',-1124,1)
                   NEXT FIELD imaag
               ELSE
                   SELECT  count(*) INTO l_n FROM aga_file WHERE aga01 = g_ima.imaag
                   IF l_n = 0 THEN
                      CALL i100_insert310()
                   END IF
               END IF
               IF g_ima.ima151 = 'Y' THEN
                  CALL cl_set_act_visible("produce_sub_parts",TRUE)
               ELSE
                  CALL cl_set_act_visible("produce_sub_parts",FALSE)
               END IF
             END IF
         END IF
            
      ON ACTION controlp
         CASE
            WHEN INFIELD(ima06) #分群碼
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imz"
               LET g_qryparam.default1 = g_ima.ima06
               CALL cl_create_qry() RETURNING g_ima.ima06
               DISPLAY BY NAME g_ima.ima06
               NEXT FIELD ima06

            WHEN INFIELD(ima131) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba01"
               LET g_qryparam.default1 = g_ima.ima131
               CALL cl_create_qry() RETURNING g_ima.ima131
               DISPLAY BY NAME g_ima.ima131
               NEXT FIELD ima131 
               
           #FUN-D30006--add--str---
            WHEN INFIELD(ima1030)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rzh01"
               LET g_qryparam.default1 = g_ima.ima1030
               CALL cl_create_qry() RETURNING g_ima.ima1030
               DISPLAY BY NAME g_ima.ima1030
               NEXT FIELD ima1030
           #FUN-D30006--add--end---

            WHEN INFIELD(imaag)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aga"
               LET g_qryparam.default1 = g_ima.imaag
               CALL cl_create_qry() RETURNING g_ima.imaag
               DISPLAY BY NAME g_ima.imaag
               NEXT FIELD imaag
               
            WHEN INFIELD(ima09) #其他分群碼一
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.default1 = g_ima.ima09
               LET g_qryparam.arg1 = "D"
               CALL cl_create_qry() RETURNING g_ima.ima09 
               DISPLAY BY NAME g_ima.ima09
               NEXT FIELD ima09
               
            WHEN INFIELD(ima10) #其他分群碼二
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.default1 = g_ima.ima10
               LET g_qryparam.arg1 = "E"
               CALL cl_create_qry() RETURNING g_ima.ima10 
               DISPLAY BY NAME g_ima.ima10
               NEXT FIELD ima10
               
            WHEN INFIELD(ima11) #其他分群碼三
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.default1 = g_ima.ima11
               LET g_qryparam.arg1 = "F"
               CALL cl_create_qry() RETURNING g_ima.ima11
               DISPLAY BY NAME g_ima.ima11
               NEXT FIELD ima11
               
            WHEN INFIELD(ima12) #其他分群碼四
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.default1 = g_ima.ima12
               LET g_qryparam.arg1 = "G"
               CALL cl_create_qry() RETURNING g_ima.ima12
               DISPLAY BY NAME g_ima.ima12
               NEXT FIELD ima12

            WHEN INFIELD(ima1004)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqa"
               LET g_qryparam.default1 = g_ima.ima1004
               LET g_qryparam.arg1 = "1"
               CALL cl_create_qry() RETURNING g_ima.ima1004
               DISPLAY BY NAME g_ima.ima1004
               NEXT FIELD ima1004

            WHEN INFIELD(ima1005)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqa"
               LET g_qryparam.default1 = g_ima.ima1005
               LET g_qryparam.arg1 = "2"
               CALL cl_create_qry() RETURNING g_ima.ima1005
               DISPLAY BY NAME g_ima.ima1005
               NEXT FIELD ima1005

            WHEN INFIELD(ima1006)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqa"
               LET g_qryparam.default1 = g_ima.ima1006
               LET g_qryparam.arg1 = "3"
               CALL cl_create_qry() RETURNING g_ima.ima1006
               DISPLAY BY NAME g_ima.ima1006
               NEXT FIELD ima1006
               
            WHEN INFIELD(ima1007)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqa"
               LET g_qryparam.default1 = g_ima.ima1007
               LET g_qryparam.arg1 = "4"
               CALL cl_create_qry() RETURNING g_ima.ima1007
               DISPLAY BY NAME g_ima.ima1007
               NEXT FIELD ima1007

            WHEN INFIELD(ima1008)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqa"
               LET g_qryparam.default1 = g_ima.ima1008
               LET g_qryparam.arg1 = "5"
               CALL cl_create_qry() RETURNING g_ima.ima1008
               DISPLAY BY NAME g_ima.ima1008
               NEXT FIELD ima1008

            WHEN INFIELD(ima1009)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqa"
               LET g_qryparam.default1 = g_ima.ima1009
               LET g_qryparam.arg1 = "6"
               CALL cl_create_qry() RETURNING g_ima.ima1009
               DISPLAY BY NAME g_ima.ima1009
               NEXT FIELD ima1009

            WHEN INFIELD(ima54)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc3"
               LET g_qryparam.default1 = g_ima.ima54
               CALL cl_create_qry() RETURNING g_ima.ima54
               DISPLAY BY NAME g_ima.ima54
               NEXT FIELD ima54   

            WHEN INFIELD(ima31)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_ima.ima31
               CALL cl_create_qry() RETURNING g_ima.ima31
               DISPLAY BY NAME g_ima.ima31
               NEXT FIELD ima31
         
            WHEN INFIELD(ima25) #庫存單位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_ima.ima25
               CALL cl_create_qry() RETURNING g_ima.ima25
               DISPLAY BY NAME g_ima.ima25
               NEXT FIELD ima25

            WHEN INFIELD(ima44)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_ima.ima44
               CALL cl_create_qry() RETURNING g_ima.ima44
               DISPLAY BY NAME g_ima.ima44
               NEXT FIELD ima44
               
               
            WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag02"
               LET g_qryparam.default1 = g_ima.ima39
               LET g_qryparam.arg1     = g_aza.aza81
               CALL cl_create_qry() RETURNING g_ima.ima39
               DISPLAY BY NAME g_ima.ima39
               NEXT FIELD ima39
               
            WHEN INFIELD(ima149)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag02"
               LET g_qryparam.default1 = g_ima.ima149
               LET g_qryparam.arg1     = g_aza.aza81
               CALL cl_create_qry() RETURNING g_ima.ima149
               DISPLAY BY NAME g_ima.ima149
               NEXT FIELD ima149

            WHEN INFIELD(ima940) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agc"
               LET g_qryparam.where = "agc07 = '1'"
               LET g_qryparam.default1 = g_ima.ima940
               CALL cl_create_qry() RETURNING g_ima.ima940
               DISPLAY g_ima.ima940 TO ima940
               NEXT FIELD ima940
            WHEN INFIELD(ima941)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agc"
               LET g_qryparam.where = "agc07 = '2'"
               LET g_qryparam.default1 = g_ima.ima941
               CALL cl_create_qry() RETURNING g_ima.ima941
               DISPLAY g_ima.ima941 TO ima941
               NEXT FIELD ima941

#FUN-C50036 add begin ---
            WHEN INFIELD(ima162) #称重单位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe01_1"
               LET g_qryparam.default1 = g_ima.ima162
               CALL cl_create_qry() RETURNING g_ima.ima162
               DISPLAY g_ima.ima162 TO ima162
               NEXT FIELD ima162
#FUN-C50036 add end   ---
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION update
         IF NOT cl_null(g_ima.ima01) THEN
            LET g_doc.column1 = "ima01"
            LET g_doc.value1 = g_ima.ima01
            CALL cl_fld_doc("ima04")
           #FUN-D30093--add--str---
            LET l_str = "ima01=",g_ima.ima01
            SELECT gca_file.* INTO g_gca.*
              FROM gca_file
             WHERE gca01 = l_str
               AND gca02 = ' '
               AND gca03 = ' '
               AND gca04 = ' '
               AND gca05 = ' '
               AND gca08 = 'FLD'
               AND gca09 = 'ima04'
               AND gca11 = 'Y'
            LOCATE l_rzk05 IN MEMORY
            SELECT gcb09 INTO l_rzk05 FROM gcb_file WHERE gcb01 = g_gca.gca07
                                                      AND gcb02 = g_gca.gca08
                                                      AND gcb03 = g_gca.gca09
                                                      AND gcb04 = g_gca.gca10
            UPDATE rzk_file SET rzk05 = l_rzk05 WHERE rzk02 = g_ima.ima01
            UPDATE rzi_file SET rzipos = '2' 
             WHERE (rzipos = '3' OR rzipos = '4')
               AND rzi01 IN (SELECT DISTINCT rzk01 FROM rzk_file WHERE rzk02 = g_ima.ima01)  
           #FUN-D30093--add--end---
         END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
   END INPUT
   IF g_sma.sma124 = 'slk' THEN
      IF g_ima.ima151 = 'Y'THEN
         CALL cl_set_act_visible("produce_sub_parts",TRUE)
      END IF
   END IF
END FUNCTION

#FUN-C50036 add begin ---
FUNCTION i100_ima162()
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
   LET g_errno = ''
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file 
    WHERE gfe01 = g_ima.ima162
   CASE 
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art1068'
      WHEN l_gfeacti <> 'Y'     LET g_errno = 'art1069'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
END FUNCTION
#FUN-C50036 add end -----

FUNCTION i100_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   CLEAR FORM
   CALL g_rta.clear()
   CALL g_rte.clear()
   CALL g_rtg.clear()
   CALL g_rty.clear()
   INITIALIZE g_ima.* TO NULL 
   INITIALIZE g_ima_t.* TO NULL 
   INITIALIZE g_ima_o.* TO NULL 
   LET g_ima01_t = NULL 
   LET g_wc = NULL 
   LET g_wc2 = NULL 
   LET g_wc3 = NULL 
   LET g_wc4 = NULL 
   LET g_wc5 = NULL 
   
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY ' ' TO FORMONLY.cnt
   
   CALL i100_cs()
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ima.* TO NULL
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
      LET g_rec_b4 = 0
      LET g_wc = NULL 
      LET g_wc2 = NULL 
      LET g_wc3 = NULL 
      LET g_wc4 = NULL 
      LET g_wc5 = NULL
      LET g_ima01_t = NULL 
      CALL cl_set_comp_visible("imaag",FALSE)                    
      CLEAR FORM
      RETURN
   END IF
   
   MESSAGE "Searching!"
   
   OPEN i100_count
   FETCH i100_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i100_cs                 # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
   ELSE
       CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示    
   END IF
END FUNCTION
 
FUNCTION i100_fetch(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1 
 
   CASE p_cmd
      WHEN 'N' FETCH NEXT     i100_cs INTO g_ima.ima01
      WHEN 'P' FETCH PREVIOUS i100_cs INTO g_ima.ima01
      WHEN 'F' FETCH FIRST    i100_cs INTO g_ima.ima01
      WHEN 'L' FETCH LAST     i100_cs INTO g_ima.ima01
      WHEN '/'
         IF (NOT g_no_ask) THEN 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         
                  CALL cl_about()
                     
               ON ACTION HELP
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i100_cs INTO g_ima.ima01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
        RETURN
   ELSE
      CASE p_cmd
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
   END IF
 
   SELECT * INTO g_ima.* 
     FROM ima_file            # 重讀DB,因TEMP有不被更新特性
    WHERE ima01 = g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_ima.* TO NULL 
      RETURN        
   ELSE
       LET g_data_owner = g_ima.imauser  
       LET g_data_group = g_ima.imagrup
       CALL i100_show()   # 重新顯示
   END IF
END FUNCTION
 
FUNCTION i100_list_fill()

   IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF
   IF cl_null(g_wc3) THEN LET g_wc3 = ' 1=1' END IF
   IF cl_null(g_wc4) THEN LET g_wc4 = ' 1=1' END IF
   IF cl_null(g_wc5) THEN LET g_wc5 = ' 1=1' END IF

   LET g_sql = "SELECT rta02,rta03,'',rta04,rta05,rtaacti ",
               "  FROM rta_file",
               " WHERE rta01 = '",g_ima.ima01,"'",
               "   AND ", g_wc2,
               "  ORDER BY rta01"
   PREPARE i100_rta_pre FROM g_sql
   DECLARE i100_rta_cs CURSOR FOR i100_rta_pre

   LET g_sql = "SELECT rte01,rte02,rte08,'',rte04,rte05,rte06,rte07,rtepos",
               "  FROM rte_file,rtd_file ",
               " WHERE rte03 = '",g_ima.ima01,"'",
               "   AND ", g_wc3,
               "   AND rte01 = rtd01 ",
               "   AND (rtd03 = '",g_plant,"' OR rtd01 IN (SELECT rtz04 FROM rtz_file WHERE rtz01 = '",g_plant,"')) ", #過濾營運中心
               "  ORDER BY rte01"
   PREPARE i100_rte_pre FROM g_sql
   DECLARE i100_rte_cs CURSOR FOR i100_rte_pre

   LET g_sql = "SELECT rtg01,rtg02,rtg04,rtg05,rtg06,rtg07,rtg11,rtg08,rtg10,rtg09,rtg12,rtgpos",                #FUN-C60050 add rtg11,rtg12
               "  FROM rtg_file,rtf_file ",
               " WHERE rtg03 = '",g_ima.ima01,"'",
               "   AND ", g_wc4,
               "   AND rtg01 = rtf01 ",
               "   AND (rtf03 = '",g_plant,"' OR rtf01 IN (SELECT rtz05 FROM rtz_file WHERE rtz01 = '",g_plant,"')) ", #過濾營運中心
               "  ORDER BY rtg01"
   PREPARE i100_rtg_pre FROM g_sql
   DECLARE i100_rtg_cs CURSOR FOR i100_rtg_pre

   LET g_sql = "SELECT rty01,rty03,rty04,'',rty12,'',rty05,rty06,rty07,",
               "       rty08,rty13,rty09,rty10,rty11,rtyacti",
               "  FROM rty_file",
               " WHERE rty02 = '",g_ima.ima01,"'",
               "   AND ", g_wc5,
               "   AND rty01 IN ",g_auth CLIPPED, #過濾營運中心
               "  ORDER BY rty01"
   PREPARE i100_rty_pre FROM g_sql
   DECLARE i100_rty_cs CURSOR FOR i100_rty_pre

   LET g_cnt = 1
   CALL g_rta.clear()
   FOREACH i100_rta_cs INTO g_rta[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      SELECT gfe02 INTO g_rta[g_cnt].rta03_desc
        FROM gfe_file 
       WHERE gfe01 = g_rta[g_cnt].rta03
       
      LET g_cnt = g_cnt +1 
   END FOREACH
   LET g_rec_b1 = g_cnt - 1
   CALL g_rta.deleteElement(g_cnt)
   DISPLAY g_rec_b1 TO FORMONLY.cn2

   LET g_cnt = 1
   CALL g_rte.clear()
   FOREACH i100_rte_cs INTO g_rte[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      SELECT gec02 INTO g_rte[g_cnt].taxtype
        FROM gec_file 
       WHERE gec01 = g_rte[g_cnt].rte08
       
      LET g_cnt = g_cnt +1 
   END FOREACH
   LET g_rec_b2 = g_cnt - 1
   CALL g_rte.deleteElement(g_cnt)
   DISPLAY g_rec_b2 TO FORMONLY.cn2

   LET g_cnt = 1
   CALL g_rtg.clear()
   FOREACH i100_rtg_cs INTO g_rtg[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt +1 
   END FOREACH
   LET g_rec_b3 = g_cnt - 1
   CALL g_rtg.deleteElement(g_cnt)
   DISPLAY g_rec_b3 TO FORMONLY.cn2

   LET g_cnt = 1
   CALL g_rty.clear()
   FOREACH i100_rty_cs INTO g_rty[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      SELECT geu02 INTO g_rty[g_cnt].rty04_desc
        FROM geu_file 
       WHERE geu01 = g_rty[g_cnt].rty04

     SELECT geu02 INTO g_rty[g_cnt].rty12_desc
       FROM geu_File
      WHERE geu01 = g_rty[g_cnt].rty12  
       
      LET g_cnt = g_cnt +1 
   END FOREACH
   LET g_rec_b4 = g_cnt - 1
   CALL g_rty.deleteElement(g_cnt) 
   DISPLAY g_rec_b4 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i100_show()
   LET g_ima_t.* = g_ima.*
   LET g_ima_o.* = g_ima.*
    
   IF g_sma.sma120 != 'Y' THEN
      CALL cl_set_comp_visible("imaag",FALSE)
   END IF
 
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima06,
                   g_ima.ima08,g_ima.ima131,g_ima.ima1005,g_ima.ima1006,g_ima.ima1030,    #FUN-D30006 add g_ima.ima1030
                   g_ima.ima154,g_ima.ima151,g_ima.ima940,g_ima.ima941,
                   g_ima.imaag,g_ima.ima120,g_ima.ima25,g_ima.ima44,
                   g_ima.ima44_fac,g_ima.ima31_fac,g_ima.ima31,g_ima.ima54,
                   g_ima.ima12,g_ima.ima39,g_ima.ima149,g_ima.ima1010,
                   g_ima.ima916,g_ima.ima160,g_ima.ima161,g_ima.ima162,g_ima.ima1004,g_ima.ima1007,g_ima.ima1008,            #FUN-C50036 add g_ima.ima160,g_ima.ima161,g_ima.ima162
                   g_ima.ima1009,g_ima.ima915,g_ima.ima45,g_ima.ima46,
                   g_ima.ima47,g_ima.ima09,g_ima.ima10,g_ima.ima11,g_ima.ima53,
                   g_ima.ima91,g_ima.ima531,g_ima.ima33,g_ima.imauser,
                   g_ima.imagrup,g_ima.imaoriu,g_ima.imamodu,g_ima.imadate,
                   g_ima.imaorig,g_ima.imaacti

   IF NOT cl_null(g_ima.imaag) AND g_ima.imaag <> '@CHILD' THEN
      CALL cl_set_act_visible("add_multi_attr_sub",TRUE)
   ELSE
      CALL cl_set_act_visible("add_multi_attr_sub",FALSE)
   END IF

   IF g_ima.ima151="Y" THEN
      IF g_sma.sma124 = 'slk' THEN
         CALL cl_set_act_visible("produce_sub_parts",TRUE)
         CALL cl_set_comp_visible("ima940,ima941",TRUE)
      ELSE
         CALL cl_set_act_visible("produce_sub_parts",FALSE)
         CALL cl_set_comp_visible("ima940,ima941",FALSE)
      END IF
   ELSE
      CALL cl_set_act_visible("produce_sub_parts",FALSE)
   END IF

   IF g_sma.sma120 != 'Y' THEN
      CALL cl_set_comp_visible("imaag",FALSE)
   ELSE
      IF g_ima.ima151 = 'Y' THEN
         CALL cl_set_comp_visible("imaag",TRUE)
      END IF
   END IF

   LET g_doc.column1 = "ima01"
   LET g_doc.value1 = g_ima.ima01
   CALL cl_get_fld_doc("ima04")

   CALL i100_list_fill()
   IF g_ima.ima1010 = '1' THEN
      LET g_chr = 'Y'
   ELSE 
      LET g_chr = 'N'
   END IF 
   CALL cl_set_field_pic1(g_chr,"","","","",g_ima.imaacti,"","")
END FUNCTION
 
FUNCTION i100_u(p_w)
   DEFINE p_w      LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_ima RECORD LIKE ima_file.*
   
   IF s_shut(0) THEN 
      RETURN 
   END IF
    
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
    
   SELECT * INTO g_ima.* 
     FROM ima_file 
    WHERE ima01=g_ima.ima01
     
   IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_ima.ima01,'mfg1000',0)
      RETURN
   END IF
    
   IF cl_null(g_ima.ima1006) THEN
      LET g_ima.ima1006 = '001'
   END IF
    
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ima01_t = g_ima.ima01
   LET g_ima_o.* = g_ima.*
    
   IF g_action_choice <> "reproduce" THEN 
      BEGIN WORK
   END IF

   OPEN i100_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      CLOSE i100_cl
      ROLLBACK WORK 
      RETURN    
   END IF
   
   FETCH i100_cl INTO g_ima.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      CLOSE i100_cl
      ROLLBACK WORK 
      RETURN
   END IF
   
  #TQC-C20270 Add Begin ---
   IF g_sma.sma124 = 'slk' THEN
      IF g_ima.ima151 = 'N' AND g_ima.imaag = '@CHILD' THEN
         CALL cl_err(g_ima.ima01,'art1051',0)   #子料件資料不能進行修改
         RETURN
      END IF
   END IF
  #TQC-C20270 Add End -----
   SELECT COUNT(*) INTO g_n FROM imx_file WHERE imx00=g_ima.ima01
   IF g_n > 0 AND NOT cl_null(g_n) THEN
      CALL cl_set_comp_entry("imaag,ima151,ima940,ima941",FALSE)
   END IF

   LET g_date = g_ima.imadate
   LET g_modu = g_ima.imamodu

   IF p_w = "u" THEN
      LET g_ima.imamodu = g_user
      LET g_ima.imadate = g_today
   END IF 
   IF p_w = "c" THEN  
      LET g_ima.imamodu = NULL    
   END IF 
   CALL i100_show()                          # 顯示最新資料
   WHILE TRUE
      CALL cl_set_comp_visible("imaag",g_ima.ima151)
      IF p_w = 'c' THEN 
         CALL i100_i("a")                      # 欄位更改
      ELSE 
         CALL i100_i("u")
      END IF 
       
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ima.*=g_ima_t.*
         LET g_ima_t.imadate = g_date
         LET g_ima_t.imamodu = g_modu
         CALL i100_show()
         CALL cl_err('',9001,0)
         ROLLBACK WORK #TQC-C20270 Add
         EXIT WHILE
      END IF

      IF g_ima.ima01 <> g_ima_t.ima01 THEN
         UPDATE rta_file
            SET rta01 = g_ima.ima01
          WHERE rta01 = g_ima_t.ima01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rta_file",g_ima01_t,"",
                                       SQLCA.sqlcode,"","rta",1)
            CONTINUE WHILE
         END IF 

         UPDATE rte_file
            SET rte03 = g_ima.ima01
          WHERE rte03 = g_ima_t.ima01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rte_file",g_ima01_t,"",
                                       SQLCA.sqlcode,"","rte",1)
            CONTINUE WHILE
         END IF 

         UPDATE rtg_file
            SET rt301 = g_ima.ima01
          WHERE rt301 = g_ima_t.ima01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rtg_file",g_ima01_t,"",
                                       SQLCA.sqlcode,"","rtg",1)
            CONTINUE WHILE
         END IF 

         UPDATE rty_file
            SET rty02 = g_ima.ima01
          WHERE rty02 = g_ima_t.ima01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rty_file",g_ima01_t,"",
                                       SQLCA.sqlcode,"","rty",1)
            CONTINUE WHILE
         END IF 
      END IF  

      SELECT * INTO l_ima.*
        FROM ima_file
       WHERE ima01 = g_ima.ima01

     #FUN-D30093--add--str---
      IF g_ima.ima131 <> l_ima.ima131 THEN
         UPDATE rzk_file SET rzkacti = 'N'
          WHERE rzk01 IN (SELECT DISTINCT rzi01 FROM rzi_file WHERE rzi09 = '1')
            AND rzk02 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rzk_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
         UPDATE rzi_file SET rzipos = '2'
          WHERE rzi01 IN (SELECT DISTINCT rzk01 FROM rzk_file WHERE rzk02 = g_ima.ima01)
            AND rzi09 = '1'
            AND rzipos IN ('3','4')
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rzi_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
      END IF
      IF g_ima.ima1030 <> l_ima.ima1030 THEN
         UPDATE rzk_file SET rzkacti = 'N'
          WHERE rzk01 IN (SELECT DISTINCT rzi01 FROM rzi_file WHERE rzi09 = '2')  
            AND rzk02 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rzk_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
         UPDATE rzi_file SET rzipos = '2'
          WHERE rzi01 IN (SELECT DISTINCT rzk01 FROM rzk_file WHERE rzk02 = g_ima.ima01)
            AND rzi09 = '2'
            AND rzipos IN ('3','4') 
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","rzi_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
      END IF
     #FUN-D30093--add--end---
        
      IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
         OR l_ima.ima25 <> g_ima.ima25 OR l_ima.ima45 <> g_ima.ima45
         OR l_ima.ima131 <> g_ima.ima131 OR l_ima.ima151 <> g_ima.ima151
         OR l_ima.ima154 <> g_ima.ima154 OR l_ima.ima1004 <> g_ima.ima1004 OR l_ima.ima1005 <> g_ima.ima1005  #FUN-D30093 add l_ima.ima1005 <> g_ima.ima1005 
         OR l_ima.ima1007 <> g_ima.ima1007 OR l_ima.ima1008 <> g_ima.ima1008 OR l_ima.ima1009 <> g_ima.ima1009  #FUN-D30093 add
         OR l_ima.ima160 <> g_ima.ima160 OR l_ima.ima161 <> g_ima.ima161 OR l_ima.ima162 <> g_ima.ima162        #FUN-D30093 add
         OR l_ima.ima1006 <> g_ima.ima1006 OR l_ima.ima1030 <> g_ima.ima1030 THEN    #FUN-D30006 add l_ima.ima1030 <> g_ima.ima1030
         IF g_aza.aza88 = 'Y' THEN
            UPDATE rte_file 
               SET rtepos = '2' 
             WHERE rte03 = g_ima.ima01 
              #AND rtepos = '3'           #FUN-D30093 mark
               AND (rtepos = '3' OR rtepos = '4')   #FUN-D30093 add
         END IF
      END IF 

      CALL i100_u_upd()
      CLOSE i100_cl
      IF g_success = 'N' THEN
         ROLLBACK WORK
      ELSE
         COMMIT WORK
      END IF  
      EXIT WHILE
   END WHILE
   CLOSE i100_cl #TQC-C20270 Add
   SELECT * INTO g_ima.*
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   CALL i100_show()
   CALL i100_list_fill() 
END FUNCTION
 
FUNCTION i100_copy()
   DEFINE l_ima   RECORD LIKE ima_file.*
   DEFINE l_newno,l_oldno LIKE ima_file.ima01
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_newno1  LIKE ima_file.ima01
   DEFINE l_ima120  LIKE ima_file.ima120

   IF cl_null(g_ima.ima01) THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF 

   IF s_shut(0) THEN 
       RETURN 
   END IF

   LET g_before_input_done = FALSE
   CALL i100_set_entry('a')
   LET g_before_input_done = TRUE 
   LET l_oldno = g_ima.ima01

   IF g_aza.aza28 = 'Y' THEN
      CALL s_auno(g_ima.ima01,'1','') RETURNING l_newno1,l_ima02    
   END IF

   INPUT l_newno FROM ima01

   BEFORE FIELD ima01
      IF g_sma.sma60 = 'Y' THEN      # 若須分段輸入
         CALL s_inp5(6,14,l_newno) RETURNING l_newno
         DISPLAY l_newno TO ima01
      END IF
      IF NOT cl_null(l_newno1) THEN 
         LET l_newno = l_newno1 
      END IF

   AFTER FIELD ima01
      IF NOT cl_null(g_ima.ima01) THEN 
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            LET g_ima.ima01 = NULL 
            NEXT FIELD ima01 
            DISPLAY BY NAME g_ima.ima01 
         END IF 
      END IF 

   AFTER INPUT 
      IF INT_FLAG THEN 
         EXIT INPUT 
      END IF    
      
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
      CALL cl_set_comp_entry("ima25",FALSE)
      DISPLAY BY NAME g_ima.ima01
      RETURN 
   END IF
    
   #增加再次詢問的確定,以免不必要的新增
   IF NOT cl_confirm('mfg-003') THEN
      CALL cl_set_comp_entry("ima25",FALSE)
      RETURN
   END IF
   
   #MESSAGE '新增料件基本資料中....!'
   CALL cl_err('','aim-993','0')
   DROP TABLE ima_temp 
   SELECT * FROM ima_file
    WHERE ima01 = g_ima.ima01
     INTO TEMP ima_temp
   UPDATE ima_temp
      SET ima01 = l_newno,
          ima916 = g_plant,
          imamodu = NULL,
          imadate = NULL,
          ima1010 = '0',
          ima02 = NULL
   INSERT INTO ima_file SELECT * FROM ima_temp
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(l_newno,SQLCA.sqlcode ,0)
      #ROLLBACK WORK 
   ELSE 
      COMMIT WORK 
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno = g_ima.ima01
      LET g_ima.ima01 = l_newno 
      SELECT ima_file.* INTO g_ima.*
        FROM ima_file
       WHERE ima01 = l_newno 

      CALL i100_u('c')
      CALL i100_b()
      
      #SELECT ima_file.* INTO g_ima.*  #FUN-C80046
      #  FROM ima_file                 #FUN-C80046
      # WHERE ima01 = l_oldno          #FUN-C80046

   END IF  
   #LET g_ima.ima01 = l_oldno          #FUN-C80046
   #SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01  #FUN-C80046
   CALL i100_show()
END FUNCTION
 
FUNCTION i100_init() #初始環境設定 
   INITIALIZE g_ima.* TO NULL
   INITIALIZE g_ima_t.* TO NULL
   INITIALIZE g_ima_o.* TO NULL
   LET g_db_type=cl_db_get_database_type()
 
   CALL cl_set_comp_visible("imaag",g_sma.sma120 = 'Y') 
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
 
   IF g_aza.aza60 = 'N' THEN #不使用客戶申請作業時,才可按確認/取消確認/新增
      CALL cl_set_act_visible("confirm,unconfirm,insert",TRUE)
   ELSE
      CALL cl_set_act_visible("confirm,unconfirm,insert",FALSE)
   END IF
END FUNCTION
 
FUNCTION i100_set_entry_b2(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rte01",TRUE)
   END IF
END FUNCTION

FUNCTION i100_set_no_entry_b2(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   

   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rte01",FALSE)
   END IF
END FUNCTION

FUNCTION i100_set_entry_b3(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rtg01",TRUE)
   END IF
END FUNCTION

FUNCTION i100_set_no_entry_b3(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rtg01",FALSE)
   END IF
END FUNCTION 

FUNCTION i100_set_entry_b4(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rty01",TRUE)
   END IF
END FUNCTION

FUNCTION i100_set_no_entry_b4(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rty01",FALSE)
   END IF
END FUNCTION

FUNCTION i100_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima01,ima25,ima55",TRUE)                   
      CALL cl_set_comp_visible("imaag",g_ima.ima151 = 'Y' )
      IF g_sma.sma124 = 'slk' THEN
         CALL cl_set_comp_entry("imaag",FALSE)
      END IF
      CALL cl_set_comp_entry("ima02,ima021",TRUE)          
   END IF

   CALL cl_set_comp_entry('ima151',TRUE)
#FUN-C50036 add begin ---
   IF g_ima.ima160 = 'Y' THEN
      CALL cl_set_comp_entry("ima161,ima162",TRUE)
      CALL cl_set_comp_required("ima161,ima162",TRUE)
   END IF 
#FUN-C50036 add end -----
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE li_count  LIKE type_file.num5
   DEFINE lc_sql    STRING
   DEFINE l_errno   STRING
  
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima01",FALSE)
   END IF
   
   #當參數設定使用料件申請作業時,修改時不可更改料號/品名/規格
   IF g_aza.aza60 = 'Y' AND p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ima01,ima02,ima021",FALSE)
   END IF
 
   IF p_cmd <> 'a' THEN 
      CALL s_chkitmdel(g_ima.ima01) RETURNING l_errno
      CALL cl_set_comp_entry("ima25",cl_null(l_errno))#有errmsg表示庫存單位不可修改狀態
      IF g_ima.imaag ='@CHILD' THEN 
         CALL cl_set_comp_entry("ima151",FALSE)
      END IF    
   END IF
 
   IF (p_cmd = 'u' )AND( g_sma.sma120 = 'Y')  THEN
      IF g_ima.imaag = '@CHILD' THEN
         CALL cl_set_comp_visible("imaag",FALSE)
      ELSE
         #如果該料件已經包含了子料件則不允許修改他的屬性群組
         LET lc_sql = "SELECT COUNT(*) FROM ima_file WHERE imaag = '@CHILD' ",
                      "AND imaag1 = '",g_ima.imaag,"' AND ima01 LIKE '",
                      g_ima.ima01,"%' "
 
         DECLARE lcurs_qry_ima CURSOR FROM lc_sql
 
         OPEN lcurs_qry_ima
         FETCH lcurs_qry_ima INTO li_count
         IF li_count > 0 THEN
            CALL cl_set_comp_visible("imaag",FALSE)
         ELSE
            CALL cl_set_comp_visible("imaag",g_ima.ima151 = 'Y')
         END IF
         CLOSE lcurs_qry_ima
      END IF
   END IF   

#FUN-C50036 add begin ---
   IF g_ima.ima160 <> 'Y' THEN
      CALL cl_set_comp_entry("ima161,ima162",FALSE)
      CALL cl_set_comp_required("ima161,ima162",FALSE)
   END IF
#FUN-C50036 add end -----
END FUNCTION

FUNCTION i100_rvy_set_entry_b()
   IF g_before_input_done = FALSE THEN
      CALL cl_set_comp_entry("rvy04,rvy06",TRUE)
   END IF
END FUNCTION

FUNCTION i100_rvy_set_no_entry_b()
   DEFINE  l_cnt LIKE type_file.num5

   IF g_rvy[l_ac5].rvy04 = g_rte[l_ac2].rte08
      AND (g_cmd = 'a' OR g_cmd = 'u')  THEN
      CALL cl_set_comp_entry("rvy04",FALSE)
   ELSE
     CALL cl_set_comp_required("rvy04",TRUE)
   END IF

   IF g_cmd = 'a' OR g_cmd = 'u' THEN
     CALL cl_set_comp_entry("rvy02",FALSE)
   END IF

   SELECT COUNT(*) INTO l_cnt 
     FROM rte_file
    WHERE rte01 = g_rte[l_ac2].rte01
      AND rte02 = g_rvy[l_ac5].rvy02
      AND rte08 = g_rvy[l_ac5].rvy04
   IF g_cmd <> 'a' AND g_cmd <>'u' AND l_cnt>0 THEN
      CALL cl_set_comp_entry("rvy04",FALSE)
   ELSE
     CALL cl_set_comp_required("rvy04",TRUE)
   END IF
   IF g_rvy[l_ac5].gec04>0 THEN
      CALL cl_set_comp_entry("rvy06",FALSE)
   END IF
END FUNCTION

FUNCTION i100_chk_ima06(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_n   LIKE type_file.num5 

   IF g_ima.ima06 IS NOT NULL AND  g_ima.ima06 != ' ' THEN 
      IF (g_ima_o.ima06 IS NULL) OR (g_ima.ima06 != g_ima_o.ima06) THEN 
         IF p_cmd='u' THEN 
            CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
         ELSE
            LET g_errno=NULL
         END IF
         IF cl_null(g_errno) THEN 
            LET g_ans = ''
            CALL i100_ima06('Y') #default 預設值
            IF g_ans="1" THEN 
               IF NOT i100_chk_rel_ima06(p_cmd) THEN
                  #後面有要用到g_ima_o.ima06判斷,所以這邊要先給值
                  LET g_ima_o.ima06 = g_ima.ima06   
                  RETURN FALSE
               END IF
            END IF
         ELSE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1) #只提示
            END IF
            #若單據還原後,單純改分群碼
            IF g_errno='mfg9199' THEN
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM tlf_file
               WHERE tlf01 = g_ima.ima01
              IF l_n=0 THEN
                 IF NOT cl_confirm('mfg9187') THEN
                    LET g_ans='1'
                    RETURN TRUE
                 END IF
              END IF
            END IF
            CALL i100_ima06('N') #只check 對錯,不詢問
         END IF
      ELSE
         CALL i100_ima06('N') #只check 對錯,不詢問
      END IF
      CALL s_field_chk(g_ima.ima06,'1',g_plant,'ima06') RETURNING g_flag2
      IF g_flag2 = '0' THEN
         LET g_errno = 'aoo-043'
      END IF

      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_ima.ima06,g_errno,0)
         LET g_ima.ima06 = g_ima_o.ima06
         DISPLAY BY NAME g_ima.ima06
         RETURN FALSE
      END IF
   END IF
   LET g_ima_o.ima06 = g_ima.ima06
   RETURN TRUE
END FUNCTION
  
FUNCTION i100_ima06(p_def)
   DEFINE p_def          LIKE type_file.chr1
   DEFINE l_msg          LIKE ze_file.ze03
   DEFINE l_imzacti      LIKE imz_file.imzacti
 
   LET g_errno = ' '
   LET g_ans=' ' # l_ans->g_ans
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_ima.ima06
    CASE
       WHEN SQLCA.SQLCODE = 100
          LET g_errno = 'mfg3179'
       WHEN l_imzacti='N'
          LET g_errno = '9028'
       OTHERWISE
          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
    IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN 
     #當輸入值與舊值不同時,才開出訊問視窗
     IF cl_null(g_ima_o.ima06) OR g_ima_o.ima06 != g_ima.ima06 THEN
        CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
        CALL cl_confirm('mfg5033') RETURNING g_ans
        IF g_ans THEN 
           CALL i100_set_rel_ima06()
       END IF 
    END IF
  END IF
END FUNCTION

#將imz_file相關欄位套用到ima_file,由i100_chk_ima06搬過來
FUNCTION i100_set_rel_ima06()
   DEFINE l_imz02        LIKE imz_file.imz02
   DEFINE l_imaacti      LIKE ima_file.imaacti
   DEFINE l_imauser      LIKE ima_file.imauser
   DEFINE l_imagrup      LIKE ima_file.imagrup
   DEFINE l_imamodu      LIKE ima_file.imamodu
   DEFINE l_imadate      LIKE ima_file.imadate

   SELECT imz01,imz02,imz03,imz04,
          imz07,imz08,imz09,imz10,
          imz11,imz12,imz14,imz15,
          imz17,imz19,imz21,
          imz23,imz24,imz25,imz27,
          imz28,imz31,imz31_fac,imz34,
          imz35,imz36,imz37,imz38,
          imz39,imz42,imz43,imz44,
          imz44_fac,imz45,imz46,imz47,
          imz48,imz49,imz491,imz50,
          imz51,imz52,imz54,imz55,
          imz55_fac,imz56,imz561,imz562,
          imz571,
          imz59,imz60,imz61,imz62,
          imz63,imz63_fac,imz64,imz641,
          imz65,imz66,imz67,imz68,
          imz69,imz70,imz71,imz86,
          imz86_fac,imz87,imz871,imz872,
          imz873,imz874,imz88,imz89,
          imz90,imz94,imz99,imz100,
          imz101,imz102 ,imz103,imz105,
          imz106,imz107,imz108,imz109,
          imz110,imz130,imz131,imz132,
          imz133,imz134, 
          imz147,imz148,imz903,
          imzacti,imzuser,imzgrup,imzmodu,imzdate,
          imz906,imz907,imz908,imz909,
          imz911,
          imz136,imz137,imz391,imz1321,
          imz72,imz153,imz601,
          imz926,
          imz156,imz157,imz158,
          imz022,imz251,imz159,

          imzicd01,imzicd04,imzicd05,imzicd16,
          imzicd08,imzicd09,imzicd10,
          imzicd12,imzicd14,imzicd15

     INTO g_ima.ima06,l_imz02,g_ima.ima03,g_ima.ima04,
          g_ima.ima07,g_ima.ima08,g_ima.ima09,g_ima.ima10,
          g_ima.ima11,g_ima.ima12,g_ima.ima14,g_ima.ima15,
          g_ima.ima17,g_ima.ima19,g_ima.ima21,
          g_ima.ima23,g_ima.ima24,g_ima.ima25,g_ima.ima27,
          g_ima.ima28,g_ima.ima31,g_ima.ima31_fac,g_ima.ima34,
          g_ima.ima35,g_ima.ima36,g_ima.ima37,g_ima.ima38,
          g_ima.ima39,g_ima.ima42,g_ima.ima43,g_ima.ima44,
          g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima47,
          g_ima.ima48,g_ima.ima49,g_ima.ima491,g_ima.ima50,
          g_ima.ima51,g_ima.ima52,g_ima.ima54,g_ima.ima55,
          g_ima.ima55_fac,g_ima.ima56,g_ima.ima561,g_ima.ima562,
          g_ima.ima571,
          g_ima.ima59, g_ima.ima60,g_ima.ima61,g_ima.ima62,
          g_ima.ima63, g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
          g_ima.ima65, g_ima.ima66,g_ima.ima67,g_ima.ima68,
          g_ima.ima69, g_ima.ima70,g_ima.ima71,g_ima.ima86,
          g_ima.ima86_fac, g_ima.ima87,g_ima.ima871,g_ima.ima872,
          g_ima.ima873, g_ima.ima874,g_ima.ima88,g_ima.ima89,
          g_ima.ima90,g_ima.ima94,g_ima.ima99,g_ima.ima100,
          g_ima.ima101,g_ima.ima102,g_ima.ima103,g_ima.ima105,
          g_ima.ima106,g_ima.ima107,g_ima.ima108,g_ima.ima109,
          g_ima.ima110,g_ima.ima130,g_ima.ima131,g_ima.ima132,
          g_ima.ima133,g_ima.ima134,
          g_ima.ima147,g_ima.ima148,g_ima.ima903,
          l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
          g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima909,
          g_ima.ima911,
          g_ima.ima136,g_ima.ima137,g_ima.ima391,g_ima.ima1321,
          g_ima.ima915,g_ima.ima153,g_ima.ima601,
          g_ima.ima926,
          g_ima.ima156,g_ima.ima157,g_ima.ima158,
          g_ima.ima022,g_ima.ima251,g_ima.ima159,
          g_imaicd.imaicd01,g_imaicd.imaicd04,g_imaicd.imaicd05,g_imaicd.imaicd16,
          g_imaicd.imaicd08,g_imaicd.imaicd09,g_imaicd.imaicd10,
          g_imaicd.imaicd12,g_imaicd.imaicd14,g_imaicd.imaicd15
     FROM imz_file
    WHERE imz01 = g_ima.ima06
   IF g_ima.ima99 IS NULL THEN LET g_ima.ima99 = 0 END IF
   IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
   IF g_ima.ima01[1,4]='MISC' THEN
      LET g_ima.ima08='Z'
   END IF
END FUNCTION

FUNCTION i100_chk_rel_ima06(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1    

   IF NOT i100_chk_ima09() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima10() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima11() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima12() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima31() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima39() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima44() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima54() THEN
      RETURN FALSE
   END IF
   IF NOT i100_chk_ima131() THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i100_ima131()
   DEFINE l_obaacti LIKE oba_file.obaacti

   LET g_errno = ''
   SELECT obaacti INTO l_obaacti
     FROM oba_file
    WHERE oba01 = g_ima.ima131
      AND oba14 = 0 

   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'alm-040' 
      WHEN l_obaacti = 'N'
         LET g_errno = 'alm-781'
      OTHERWISE 
         LET g_errno = SQLCA.sqlcode USING '-------------'   
   END CASE   
END FUNCTION 

#FUN-D30006--add--str---
FUNCTION i100_ima1030()
DEFINE l_rzhacti  LIKE rzh_file.rzhacti

   LET g_errno = ''
   SELECT rzhacti INTO l_rzhacti
     FROM rzh_file
    WHERE rzh01 = g_ima.ima1030
      AND rzh05 = 0

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'art1127'
      WHEN l_rzhacti = 'N'
         LET g_errno = 'art1128'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------------'
   END CASE
END FUNCTION
#FUN-D30006--add--end---

FUNCTION i100_gfe(p_gfe01)
   DEFINE l_gfeacti LIKE gfe_file.gfeacti
   DEFINE p_gfe01   LIKE gfe_file.gfe01
   
   LET g_errno = ''
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = p_gfe01
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'afa-319'
      WHEN l_gfeacti = 'N'
         LET g_errno = 'alm1493'
      OTHERWISE 
         LET g_errno = SQLCA.sqlcode USING '-------------'   
   END CASE 
END FUNCTION 

FUNCTION i100_tqa(p_tqa01,p_tqa03)
   DEFINE l_tqaacti   LIKE tqa_file.tqaacti
   DEFINE p_tqa01     LIKE tqa_file.tqa01
   DEFINE p_tqa03     LIKE tqa_file.tqa03
   
   LET g_errno = ''

   SELECT tqaacti INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = p_tqa01
      AND tqa03 = p_tqa03

   CASE 
      WHEN SQLCA.sqlcode = 100
         IF p_tqa03 = '2' THEN 
            LET g_errno = 'alm-046'
         END IF 
         IF p_tqa03 = '3' THEN
            LET g_errno = 'atm-143'
         END IF
         IF p_tqa03 = '1' THEN
            LET g_errno = 'art-248'
         END IF
         IF p_tqa03 = '4' THEN
            LET g_errno = 'atm-144'
         END IF
         IF p_tqa03 = '5' THEN
            LET g_errno = 'atm-145'
         END IF
         IF p_tqa03 = '6' THEN
            LET g_errno = 'atm-146'
         END IF
      WHEN l_tqaacti = 'N'
         IF p_tqa03 = '2' THEN
            LET g_errno = 'alm-139'
         END IF
         IF p_tqa03 = '3' THEN
            LET g_errno = 'alm1494'
         ELSE
            LET g_errno = '9028'
         END IF
  
      OTHERWISE 
         LET g_errno = SQLCA.sqlcode USING '-------------'
   END CASE    
END FUNCTION  

FUNCTION i100_ima54()
   DEFINE l_pmcacti    LIKE pmc_file.pmcacti

   LET g_errno = ''

   SELECT pmcacti INTO l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_ima.ima54

   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'mfg3001'
      WHEN l_pmcacti = 'N'
         LET g_errno = 'mfg3001'
      OTHERWISE 
         LET g_errno = SQLCA.sqlcode USING '-------------'
   END CASE 
END FUNCTION 

FUNCTION i100_x()
   DEFINE l_chr            LIKE type_file.chr1
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_prog           LIKE type_file.chr8 
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3
   DEFINE l_unavl_stk      LIKE type_file.num15_3
   DEFINE l_avl_stk        LIKE type_file.num15_3          

   LET g_errno = ''
    
   IF s_shut(0) THEN RETURN END IF
    
   IF g_ima.ima01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
    
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF

   #--->產品結構(bma_file,bmb_file)須有效BOM
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM bma_file
    WHERE bma01 = g_ima.ima01  
      AND bmaacti = 'Y'
   IF l_n > 0 THEN
      CALL cl_err(g_ima.ima01,'aim-022',1)
      RETURN
   END IF
    
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM bmb_file,bma_file
    WHERE bmb03 = g_ima.ima01
      AND bma01 = bmb01 AND bma06 = bmb29
      AND (bmb04<=g_today OR bmb04 IS NULL)
      AND (bmb05> g_today OR bmb05 IS NULL)
      AND bmaacti = 'Y'

   IF l_n > 0 THEN
      CALL cl_err(g_ima.ima01,'aim-022',1)
      RETURN
   END IF

   LET l_n = 0
   SELECT COUNT(DISTINCT ina01) INTO l_n
     FROM ina_file,inb_file  
    WHERE inb01 = ina01 
      AND inb04 = g_ima.ima01
      AND inaconf = 'N'
   IF l_n > 0 THEN
      CALL cl_err(g_ima.ima01,'aim-026',1)
      RETURN
   END IF
    
   BEGIN WORK
   OPEN i100_cl USING g_ima.ima01
   FETCH i100_cl INTO g_ima.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK 
      CLOSE i100_cl
      RETURN
   END IF
   CALL s_getstock(g_ima.ima01,g_plant) 
          RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
 
   IF l_avl_stk_mpsmrp > 0 THEN
      CALL cl_err('','mfg9165',0) 
      ROLLBACK WORK
      CLOSE i100_cl
      RETURN 
   END IF
   IF l_unavl_stk > 0 THEN 
      CALL cl_err('','mfg9166',0) 
      ROLLBACK WORK 
      CLOSE i100_cl 
      RETURN 
   END IF
   IF l_avl_stk > 0 THEN
      CALL cl_err('','mfg9167',0) 
      ROLLBACK WORK
      CLOSE i100_cl
      RETURN 
   END IF
 
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM sfb_file     #判斷是否有工單
    WHERE sfb05 = g_ima.ima01 AND sfb04 < '8'   
      AND sfb87 != 'X' 
      
   IF cl_null(l_n) OR l_n = 0 THEN
      SELECT COUNT(*) INTO l_n FROM pmn_file,pmm_file  #判斷是否有採購單
       WHERE pmn04 = g_ima.ima01 AND pmn16 < '6'
         AND pmn01 = pmm01 AND pmm18 != 'X'
      IF cl_null(l_n) OR l_n = 0 THEN
         SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file   #判斷是否有訂單
          WHERE oeb04 = g_ima.ima01 AND oeb70 != 'Y'
            AND oeb01 = oea01 AND oeaconf !='X'
      END IF
   END IF
 
   IF NOT cl_null(l_n) AND l_n != 0 THEN
      IF NOT cl_confirm('aim-141') THEN
         ROLLBACK WORK
         CLOSE i100_cl
         RETURN
      END IF
   END IF
 
   SELECT COUNT(*) INTO l_n FROM img_file
    WHERE img01=g_ima.ima01
      AND img10 <> 0
       
   IF l_n > 0 THEN 
      LET g_errno='mfg9163' 
      CALL cl_err('',g_errno,0)
      ROLLBACK WORK 
      CLOSE i100_cl 
      RETURN 
   END IF
   
   IF cl_exp(0,0,g_ima.imaacti) THEN
      LET g_chr=g_ima.imaacti
      LET g_chr2=g_ima.ima1010   #No.FUN-610013
      CASE g_ima.ima1010
         WHEN '0' #開立
            IF g_ima.imaacti='N' THEN
               LET g_ima.imaacti='Y'
            ELSE
               LET g_ima.imaacti='N'
            END IF
         WHEN '1' #確認
            IF g_ima.imaacti='N' THEN
               LET g_ima.imaacti='Y'
            ELSE
               LET g_ima.imaacti='N'
            END IF
      END CASE
      UPDATE ima_file
         SET imaacti=g_ima.imaacti,
             imamodu=g_user,
             imadate=g_today
       WHERE ima01 = g_ima.ima01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)
         LET g_ima.imaacti=g_chr
         LET g_ima.ima1010=g_chr2
         LET g_success = 'N' 
      END IF
        
      IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" 
                                        AND g_ima.ima1010 = '1' THEN          
         IF g_ima.imaacti='N' THEN 
            #確認資料由有效變無效,則傳送刪除MES
            #CALL i100sub_mes(g_ima.ima08,'delete',g_ima.ima01)
         ELSE 
            #確認資料由無效變有效,則傳送新增MES
            #CALL i100sub_mes(g_ima.ima08,'insert',g_ima.ima01)    
         END IF 
      END IF

      IF g_success = 'N' THEN
         ROLLBACK WORK
         CLOSE i100_cl
         RETURN
      END IF
       
      DISPLAY BY NAME g_ima.ima1010
      DISPLAY BY NAME g_ima.imaacti
      CALL i100_list_fill()
   END IF
   CLOSE i100_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i100_r()
   DEFINE l_chr    LIKE type_file.chr1
   DEFINE l_azo06  LIKE azo_file.azo06
   DEFINE l_n      LIKE type_file.num5
    
 
   IF s_shut(0) THEN RETURN FALSE END IF
   
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'r') THEN
       CALL cl_err(g_ima.ima916,'aoo-044',1)
       RETURN
   END IF
   
   IF g_ima.imaacti = 'N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err(g_ima.ima01,'aim-153',0)
      RETURN
   END IF
   
   IF g_ima.ima1010 <> '0' THEN
      #此筆資料已確認
      CALL cl_err(g_ima.ima01,'aim-073',0)
      RETURN
   END IF
 
   BEGIN WORK
   OPEN i100_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK 
      RETURN
   END IF
   
   FETCH i100_cl INTO g_ima.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "ima01"
      LET g_doc.value1 = g_ima.ima01
      CALL cl_del_doc()
      #如果當前料件是子料件則要刪除其在imx_file中對應的紀錄
      IF g_ima.imaag = '@CHILD' THEN
         DELETE FROM imx_file WHERE imx000 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","imx_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
 
      IF (NOT cl_del_itemname("ima_file","ima02", g_ima.ima01)) THEN
          ROLLBACK WORK
          RETURN
      END IF
      
      IF (NOT cl_del_itemname("ima_file","ima021",g_ima.ima01)) THEN
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM ima_file WHERE ima01 = g_ima.ima01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN 
      ELSE
         CALL cl_del_pic("ima01",g_ima.ima01,"ima04")
         DELETE  FROM vmk_file where vmk01 = g_ima.ima01
         UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
 
         DELETE FROM imc_file WHERE imc01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","imc_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            ROLLBACK WORK
            RETURN
         END IF
           
         DELETE FROM ind_file WHERE ind01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","ind_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            ROLLBACK WORK
            RETURN
         END IF
         
         DELETE FROM imb_file WHERE imb01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","imb_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            ROLLBACK WORK
            RETURN
         END IF
         
         DELETE FROM smd_file WHERE smd01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","smd_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF
         
         DELETE FROM imt_file WHERE imt01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","imt_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF
         
         DELETE FROM vmi_file WHERE vmi01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","vmi_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF

         DELETE FROM rta_file WHERE rta01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","rta_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF

         DELETE FROM rte_file WHERE rte03 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","rte_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF

         DELETE FROM rtg_file WHERE rtg03 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","rtg_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF

         DELETE FROM rty_file WHERE rty02 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","rty_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF
         
         UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01

         DELETE FROM imac_file WHERE imac01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","imac_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF
   
         LET g_msg=TIME
           #增加記錄料號
         LET l_azo06='delete'

         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
         VALUES ('aimi100',g_user,g_today,g_msg,g_ima.ima01,l_azo06,g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","azo_file","aimi100","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN 
         END IF

         CLEAR FORM

         OPEN i100_count
         FETCH i100_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i100_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i100_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i100_fetch('/')
         END IF
         CALL i100_list_fill()
      END IF
      COMMIT WORK 
      CLOSE i100_cl
   END IF
   CLOSE i100_cl
END FUNCTION
 
FUNCTION i100_confirm()
   DEFINE l_imaag    LIKE ima_file.imaag
   DEFINE l_sql      STRING
   DEFINE l_prog     LIKE type_file.chr8
   DEFINE l_gew03   LIKE gew_file.gew03
   DEFINE l_cnt       LIKE type_file.num10
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF s_shut(0) THEN
      RETURN  
   END IF 
#CHI-C30107 -------------- add -------------- begin
   IF g_ima.ima1010 <> '0' THEN
      CALL cl_err('','alm1500',0)
      RETURN
   END IF

   IF g_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err('','aim-153',1)
   END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
#CHI-C30107 -------------- add -------------- end
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
  
   IF g_ima.ima1010 <> '0' THEN 
      CALL cl_err('','alm1500',0)
      RETURN     
   END IF 
 
   IF g_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err('','aim-153',1)
   ELSE
#     IF cl_confirm('aap-222') THEN   #CHI-C30107 mark
         LET g_success = 'Y'
         
         BEGIN WORK
         UPDATE ima_file
            SET ima1010 = '1', #'1':確認
                imaacti = 'Y'  #'Y':確認
          WHERE ima01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                         "ima1010",1)
            LET g_success = 'N'
         ELSE
            LET g_ima.ima1010 = '1'
            LET g_ima.imaacti = 'Y'
            DISPLAY BY NAME g_ima.ima1010
            DISPLAY BY NAME g_ima.imaacti
           #TQC-C80087 add begin ---
            IF g_ima.ima1010 = '1' THEN
               LET g_chr = 'Y'
            ELSE
               LET g_chr = 'N'
            END IF
            CALL cl_set_field_pic1(g_chr,"","","","",g_ima.imaacti,"","")    
           #TQC-C80087 add end -----
            IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
               LET l_prog=''
               CASE g_ima.ima08
                  WHEN 'P' LET l_prog = 'aimi100' 
                  WHEN 'M' LET l_prog = 'axmi121'
                  OTHERWISE LET l_prog= ' '
               END CASE 
            END IF
         END IF

         IF g_success = 'Y' THEN 
            SELECT imaag INTO l_imaag
              FROM ima_file
             WHERE ima01 = g_ima.ima01
            IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
               LET l_sql = " UPDATE ima_file SET ima1010 = '1',imaacti='Y' ",
                          "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
               PREPARE ima_cs3 FROM l_sql
               EXECUTE ima_cs3
               IF STATUS THEN
                  CALL cl_err('ima1010',STATUS,1)  # 0->1  
                  LET g_success = 'N'
               END IF
            END IF
         END IF

         IF g_success = 'N' THEN
            ROLLBACK WORK
            RETURN
         ELSE
            CALL i100_list_fill()
            COMMIT WORK
         END IF
#     END IF  #CHI-C30107 mark
   END IF
   
   SELECT gev04 INTO g_gev04
     FROM gev_file                                     
    WHERE gev01 = '1'
      AND gev02 = g_plant                                      
      AND gev03 = 'Y'
      
   IF NOT cl_null(g_gev04) THEN
      SELECT DISTINCT gew03 INTO l_gew03 
        FROM gew_file
       WHERE gew01 = g_gev04 AND gew02 = '1'
      IF l_gew03 = '1' THEN #自动抛转
         LET l_sql = "SELECT COUNT(*) FROM &ima_file ",
                     " WHERE ima01='",g_ima.ima01,"'" 
         CALL s_dc_sel_db1(g_gev04,'1',l_sql)
         IF INT_FLAG THEN                                                       
            LET INT_FLAG=0                                                      
            RETURN                                                              
         END IF                                                                 
                                                                               
         CALL g_imax.clear()                                                    
         LET g_imax[1].sel = 'Y'                                                
         LET g_imax[1].ima01 = g_ima.ima01

         FOR l_cnt = 1 TO g_azp1.getLength()                                      
            LET g_azp[l_cnt].sel   = g_azp1[l_cnt].sel                              
            LET g_azp[l_cnt].azp01 = g_azp1[l_cnt].azp01                            
            LET g_azp[l_cnt].azp02 = g_azp1[l_cnt].azp02                            
            LET g_azp[l_cnt].azp03 = g_azp1[l_cnt].azp03                            
         END FOR                                                                
                                                                               
         CALL s_showmsg_init()                                                  
         CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
         CALL s_showmsg()                                                       
      END IF                                                                    
   END IF
END FUNCTION
 
FUNCTION i100_unconfirm()
   DEFINE l_imaag    LIKE ima_file.imaag
   DEFINE l_sql      STRING
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_rte01    LIKE rte_file.rte01 
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF s_shut(0) THEN 
      RETURN 
   END IF 
 
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx00 = g_ima.ima01
   IF l_n > 0 THEN 
      CALL cl_err('','aim-451',1)
      RETURN 
   END  IF  
   
   LET g_sql =" SELECT rte01 FROM rte_file WHERE rte03 = '",g_ima.ima01,"'"
   PREPARE i100_rte_pre1 FROM g_sql
   DECLARE i100_rte_curs CURSOR FOR i100_rte_pre1
   
   FOREACH i100_rte_curs INTO l_rte01 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      
      IF NOT cl_null(l_rte01) THEN
         EXIT FOREACH
      END IF 
   END FOREACH
   
   IF NOT cl_null(l_rte01) THEN
      CALL cl_err('','aim-670',1)
      RETURN 
   END IF

   IF g_ima.ima1010 != '1' OR g_ima.imaacti='N' THEN
      #無效或尚未確認，不能取消確認
      CALL cl_err('','atm-365',0)
   ELSE
     #料件取消確認時，比照刪除邏輯判斷
      CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,1) RETURN
      END IF
      
      IF cl_confirm('aap-224') THEN
         LET g_success = 'Y'
         BEGIN WORK
         UPDATE ima_file
            SET ima1010 = '0',
                imaacti = 'P'
          WHERE ima01 = g_ima.ima01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                         "ima1010",1)
            LET g_success = 'N'
         ELSE
            LET g_ima.ima1010 = '0'
            LET g_ima.imaacti = 'P'
            DISPLAY BY NAME g_ima.ima1010
            DISPLAY BY NAME g_ima.imaacti
           #TQC-C80087 add begin ---
            IF g_ima.ima1010 = '1' THEN
               LET g_chr = 'Y'
            ELSE
               LET g_chr = 'N'
            END IF
            CALL cl_set_field_pic1(g_chr,"","","","",g_ima.imaacti,"","")
           #TQC-C80087 add end -----
         END IF

         IF g_success = 'Y' THEN
            SELECT imaag INTO l_imaag
              FROM ima_file
             WHERE ima01 = g_ima.ima01
            IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
               LET l_sql = " UPDATE ima_file SET ima1010 = '0',imaacti = 'P' ",
                           "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
               PREPARE ima_cs4 FROM l_sql
               EXECUTE ima_cs4
               IF STATUS THEN
                  CALL cl_err('ima1010',STATUS,0)
                  LET g_success = 'N'
               END IF
            END IF
         END IF 

         IF g_success = 'N' THEN
            ROLLBACK WORK
            RETURN
         ELSE
            CALL i100_list_fill()
            COMMIT WORK
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_chk_cur(p_sql)
   DEFINE p_sql     STRING
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_result  LIKE type_file.chr1
   DEFINE l_dbase   LIKE type_file.chr21
   
   #指定資料庫,Table Name 前面加上資料庫名稱,如果有兩個Tablename,則此處理必須改寫
   IF NOT cl_null(g_dbase) THEN  
      LET l_dbase=" FROM ",s_dbstring(g_dbase)
      CALL cl_replace_once()
      LET p_sql=cl_replace_str(p_sql," FROM ",l_dbase)
      CALL cl_replace_init()
   END IF
   
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql

   PREPARE i100_chk_cur_p FROM p_sql
   DECLARE i100_chk_cur_c CURSOR FOR i100_chk_cur_p

   OPEN i100_chk_cur_c
   FETCH i100_chk_cur_c INTO l_cnt

   IF SQLCA.sqlcode OR l_cnt=0 THEN
      LET l_result = FALSE
   ELSE
      LET l_result = TRUE
   END IF

   FREE i100_chk_cur_p
   CLOSE i100_chk_cur_c
   RETURN l_result
END FUNCTION
 
FUNCTION i100_chk_ima09()
   IF cl_null(g_ima.ima09) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              " WHERE azf01='",g_ima.ima09,"'",
              "   AND azf02='D' ", 
              "   AND azfacti='Y'"
              
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN 
         CALL cl_err3("sel","azf_file",g_ima.ima09,"","mfg1306","","",1)
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima09
         LET g_errary[g_cnt].field="ima09"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
      
      LET g_ima.ima09 = g_ima_o.ima09
      DISPLAY BY NAME g_ima.ima09
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima10()
   IF cl_null(g_ima.ima10) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              " WHERE azf01='",g_ima.ima10,"'",
              "   AND azf02='E' ",
              "   AND azfacti='Y'"

   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN 
         CALL cl_err3("sel","azf_file",g_ima.ima10,"","mfg1306","","",1)
         LET g_ima.ima10 = g_ima_o.ima10
         DISPLAY BY NAME g_ima.ima10
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima10
         LET g_errary[g_cnt].field="ima10"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima11()
   IF cl_null(g_ima.ima11) THEN
      RETURN TRUE
   END IF
   
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              " WHERE azf01='",g_ima.ima11,"'",
              "   AND azf02='F' ",
              "   AND azfacti='Y'"

   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err3("sel","azf_file",g_ima.ima11,"","mfg1306","","",1)  
         LET g_ima.ima11 = g_ima_o.ima11
         DISPLAY BY NAME g_ima.ima11
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima11
         LET g_errary[g_cnt].field="ima11"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima12()
   IF cl_null(g_ima.ima12) THEN
      RETURN TRUE
   END IF

   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              " WHERE azf01='",g_ima.ima12,"'",
              "   AND azf02='G' ",
              "   AND azfacti='Y'"
              
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN 
         CALL cl_err3("sel","azf_file",g_ima.ima12,"","mfg1306","","",1)
         LET g_ima.ima12 = g_ima_o.ima12
         DISPLAY BY NAME g_ima.ima12
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima12
         LET g_errary[g_cnt].field="ima12"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima25()
   IF cl_null(g_ima.ima25) THEN
      CALL cl_err(g_ima.ima25,'asf-031',1)
      RETURN FALSE
   END IF

   LET g_sql= "SELECT COUNT(*) FROM gfe_file ",
              " WHERE gfe01='",g_ima.ima25,"' ",
              "   AND gfeacti IN ('y','Y')"
              
   IF NOT i100_chk_cur(g_sql) THEN 
      IF cl_null(g_dbase) THEN 
         CALL cl_err3("sel","gfe_file",g_ima.ima25,"","mfg1200","","",1)
         DISPLAY BY NAME g_ima.ima25
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima25
         LET g_errary[g_cnt].field="ima25"
         LET g_errary[g_cnt].errno="mfg1200"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima31()
   IF cl_null(g_ima.ima31) THEN
      RETURN TRUE
   END IF

   LET g_sql= "SELECT COUNT(*) FROM gfe_file ",
              " WHERE gfe01='",g_ima.ima31,"' ",
              "   AND gfeacti IN ('y','Y')"
              
   IF NOT i100_chk_cur(g_sql) THEN 
      IF cl_null(g_dbase) THEN 
         CALL cl_err3("sel","gfe_file",g_ima.ima31,"","mfg1311","","",1)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima31
         LET g_errary[g_cnt].field="ima31"
         LET g_errary[g_cnt].errno="mfg1311"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
  
FUNCTION i100_chk_ima39()
   IF cl_null(g_ima.ima39) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima39,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza81,"'"
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima39,"anm-001",0)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima39
         LET g_errary[g_cnt].field="ima39"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      IF g_sma.sma03='Y' THEN
         IF NOT s_actchk3(g_ima.ima39,g_aza.aza81) THEN  
             CALL cl_err(g_ima.ima39,'mfg0018',1)
             RETURN FALSE
         ELSE
            RETURN TRUE
         END IF
      ELSE
         RETURN TRUE
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima44()
   IF cl_null(g_ima.ima44) THEN
      RETURN TRUE
   END IF

   LET g_sql= "SELECT COUNT(*) FROM gfe_file ",
              " WHERE gfe01='",g_ima.ima44,"' ",
              "   AND gfeacti IN ('y','Y')"
              
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err3("sel","gfe_file",g_ima.ima44,"","apm-047","","",1)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima44
         LET g_errary[g_cnt].field="ima44"
         LET g_errary[g_cnt].errno="apm-047"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima54()
   IF cl_null(g_ima.ima54) THEN
      RETURN TRUE
   END IF
   
   LET g_sql="SELECT COUNT(*) FROM pmc_file ",
             " WHERE pmc01 = '",g_ima.ima54,"' ",
             "   AND pmcacti='Y'"
             
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima54,'mfg3001',1)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima54
         LET g_errary[g_cnt].field="ima54"
         LET g_errary[g_cnt].errno="mfg3001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
  
FUNCTION i100_chk_ima131()
   IF cl_null(g_ima.ima131) THEN
      RETURN TRUE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM oba_file ",
             "WHERE oba01='",g_ima.ima131,"' "
             
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima131,'aim-142',1)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima131
         LET g_errary[g_cnt].field="ima131"
         LET g_errary[g_cnt].errno="aim-142"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i100_chk_ima01(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_ima01 STRING
   DEFINE l_ima120 LIKE ima_file.ima120   
 
   IF NOT cl_null(g_ima.ima01) THEN
      IF p_cmd = "a" OR   
         (p_cmd = "u" AND g_ima.ima01 != g_ima01_t) THEN
         SELECT COUNT(*) INTO l_cnt 
           FROM ima_file
          WHERE ima01 = g_ima.ima01
         IF l_cnt > 0 THEN
            SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_ima.ima01         
            IF l_ima120 = '1' THEN
               CALL cl_err(g_ima.ima01,'aim-023',0) 
            ELSE
               IF l_ima120 = '2' THEN
                  CALL cl_err(g_ima.ima120,'aim-024',0)
               END IF 
            END IF 
            LET g_ima.ima01 = g_ima01_t
            DISPLAY BY NAME g_ima.ima01
            RETURN FALSE
         END IF
         LET l_ima01 = g_ima.ima01
         IF l_ima01.getIndexOf("*",1) OR l_ima01.getIndexOf(":",1)
            OR l_ima01.getIndexOf("|",1) OR l_ima01.getIndexOf("?",1)
            OR l_ima01.getIndexOf("!",1) OR l_ima01.getIndexOf("%",1)
            OR l_ima01.getIndexOf("&",1) OR l_ima01.getIndexOf("^",1)
            OR l_ima01.getIndexOf("<",1) OR l_ima01.getIndexOf(">",1) THEN
            CALL cl_err(g_ima.ima01,"aim-122",0)
            LET g_ima.ima01 = g_ima01_t
            DISPLAY BY NAME g_ima.ima01
            RETURN FALSE
         END IF
         IF g_ima.ima01[1,1] = ' ' THEN
            CALL cl_err(g_ima.ima01,"aim-671",0)
            LET g_ima.ima01 = g_ima01_t
            DISPLAY BY NAME g_ima.ima01
            RETURN FALSE
         END IF
      END IF
      IF g_ima.ima01[1,4]='MISC' AND
         (NOT cl_null(g_ima.ima01[5,10])) THEN
         SELECT COUNT(*) INTO l_cnt FROM ima_file   #至少要有一筆'MISC'先存在
          WHERE ima01='MISC'                      #才可以打其它MISCXX資料
         IF l_cnt=0 THEN
            CALL cl_err('','aim-806',1)
            RETURN FALSE
         END IF
      END IF
      IF g_ima.ima01[1,4]='MISC' THEN
         LET g_ima.ima08='Z'
         DISPLAY BY NAME g_ima.ima08
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chg_ima02()
   IF g_aza.aza44 = "Y" THEN
      IF g_zx14 = "Y" AND g_on_change_02 THEN
         CALL cl_show_fld_cont()
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_chg_ima021()
   IF g_aza.aza44 = "Y" THEN
      IF g_zx14 = "Y" AND g_on_change_021 THEN
         CALL cl_show_fld_cont()
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_chk_imaag()
   DEFINE l_cnt LIKE type_file.num5
 
   IF NOT cl_null(g_ima.imaag) THEN
      SELECT count(*) INTO l_cnt FROM aga_file
          WHERE aga01 = g_ima.imaag
      IF l_cnt <= 0 THEN
          CALL cl_err('','aim-910',1)
          RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_chk_ima08(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_misc LIKE type_file.chr4
   DEFINE l_cnt  LIKE type_file.num5
 
   IF NOT cl_null(g_ima.ima08) THEN
      IF g_ima_o.ima08 != g_ima.ima08 AND NOT cl_null(g_ima_o.ima08) THEN
         IF g_ima_o.ima08 MATCHES "[PVZ]" THEN
            SELECT COUNT(*) INTO l_cnt 
              FROM bma_file,bmb_file,ima_file
             WHERE bmb03 = g_ima.ima01
               AND (bmb05 IS NULL OR bmb05 >= g_today)
               AND bmb01 = bma01 AND bmb29 = bma06
               AND bma05 IS NOT NULL
               AND bma01 = ima01
               AND ima08 IN ('P','V','Z')
 
            IF l_cnt > 0  AND g_ima.ima08 NOT MATCHES "[PVZ]" THEN
               CALL cl_err('','abm-043',1)
               RETURN FALSE
            END IF
         END  IF
      END IF
 
      IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVRZS]"
         OR g_ima.ima08 IS NULL THEN
         CALL cl_err(g_ima.ima08,'mfg1001',0)
         LET g_ima.ima08 = g_ima_o.ima08
         DISPLAY BY NAME g_ima.ima08
         RETURN FALSE
      ELSE 
         IF g_ima.ima08 != 'T' THEN
            LET g_ima.ima13 = NULL
            DISPLAY BY NAME g_ima.ima13
         END IF
      END IF
      #NO:6808(養生)
      LET l_misc=g_ima.ima01[1,4]
      IF l_misc='MISC' AND g_ima.ima08 <>'Z' THEN
         CALL cl_err('','aim-805',0)
         RETURN FALSE
      END IF
      
      LET g_ima_o.ima08 = g_ima.ima08
      IF g_ima.ima08 NOT MATCHES "[MTS]" THEN
         LET g_ima.ima903 = 'N'
         LET g_ima.ima905 = 'N'
         DISPLAY BY NAME g_ima.ima903,g_ima.ima905
      END IF
   END IF
   CALL i100_set_no_entry(p_cmd)
   RETURN TRUE
END FUNCTION
     
FUNCTION i100_a_inschk()
   IF g_ima.ima31 IS NULL THEN
      LET g_ima.ima31=g_ima.ima25
      LET g_ima.ima31_fac=1
   END IF
 
   IF g_ima.ima44 IS NULL OR g_ima.ima44=' ' THEN
      LET g_ima.ima44=g_ima.ima25   #採購單位
      LET g_ima.ima44_fac=1
   END IF
 
   IF g_ima.ima131 IS NULL THEN
      LET g_ima.ima131 = ' ' 
   END IF 
END FUNCTION
 
FUNCTION i100_a_updchk()
   LET g_ima.ima31=g_ima.ima25
   LET g_ima.ima31_fac=1
 
   LET g_ima.ima44=g_ima.ima25   #採購單位
   LET g_ima.ima44_fac=1 
END FUNCTION
 
FUNCTION i100_a_ins()
   LET g_ima.ima01  = g_ima.ima01 CLIPPED

   LET g_ima.ima154 = 'N'

   LET g_ima.imaoriu = g_user
   LET g_ima.imaorig = g_grup

   IF cl_null(g_ima.ima022) THEN
     LET g_ima.ima022 = 0 
   END IF 

   LET g_ima.ima120='1'
   INSERT INTO ima_file VALUES(g_ima.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,
                   "","",1)
      RETURN FALSE
   ELSE
      LET g_ima_t.* = g_ima.*                # 保存上筆資料
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i100_u_upd()
   DEFINE l_imzacti  LIKE imz_file.imzacti
   DEFINE l_prog LIKE type_file.chr8  
   DEFINE l_n    LIKE type_file.num5

   LET g_errno=' '
   SELECT imzacti INTO l_imzacti 
     FROM imz_file
    WHERE imz01 = g_ima.ima06
    
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3179'
      WHEN l_imzacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(g_ima.ima06,g_errno,1)
      DISPLAY BY NAME g_ima.ima06
      LET g_success = 'N'
      RETURN 
   END IF
   
   IF cl_null(g_ima01_t) THEN  
      UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
       WHERE ima01 = g_ima.ima01 
   ELSE
      UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
       WHERE ima01 = g_ima01_t
   END IF
   
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N' 
      RETURN 
   ELSE
      LET g_errno = TIME
      LET g_msg = 'Chg No:',g_ima.ima01
      LET g_u_flag='0'
 
      INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
        VALUES ('aimi100',g_user,g_today,g_errno,g_ima.ima01,g_msg,g_plant,g_legal)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","azo_file","aimi100","",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
END FUNCTION

FUNCTION i100_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_gew03   LIKE gew_file.gew03
   DEFINE l_cnt     LIKE type_file.num5
 
   IF cl_null(g_ima.ima01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF s_shut(0) THEN 
      RETURN 
   END IF 
   
   IF g_ima.imaacti <> 'Y' THEN
      CALL cl_err(g_ima.ima01,'aoo-090',1)
      RETURN
   END IF

   SELECT ima1010 INTO g_ima.ima1010                                            
     FROM ima_file                                                              
    WHERE ima01 = g_ima.ima01                                                   
   IF g_ima.ima1010 <> '1' THEN                                                 
      CALL cl_err(g_ima.ima01,'aoo-092',3)                                      
      RETURN                                                                    
   END IF

   LET g_gev04 = NULL
 
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 
     FROM gev_file 
    WHERE gev01 = '1' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
 
   IF cl_null(g_gev04) THEN 
      RETURN
   END IF
  
   SELECT DISTINCT gew03 INTO l_gew03
     FROM gew_file 
    WHERE gew01 = g_gev04 AND gew02 = '1'                                       
   IF NOT cl_null(l_gew03) THEN                                                 
      IF l_gew03 = '2' THEN                                                     
         IF NOT cl_confirm('anm-929') THEN 
            RETURN 
         END IF  #询问是否执行抛转    
      END IF

      #開窗選擇拋轉的db清單
      LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",g_ima.ima01,"'"
      CALL s_dc_sel_db1(g_gev04,'1',l_sql)
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN
      END IF
 
      CALL g_imax.clear()
      LET g_imax[1].sel = 'Y'
      LET g_imax[1].ima01 = g_ima.ima01

      IF g_ima.ima151 = 'Y' THEN
         LET l_cnt = 2
         LET l_sql = "SELECT 'Y',imx000 FROM imx_file WHERE imx00 = '",g_ima.ima01,"' "
         PREPARE sel_imx_pre FROM l_sql
         DECLARE sel_imx_cs CURSOR FOR sel_imx_pre
         FOREACH sel_imx_cs INTO g_imax[l_cnt].sel,g_imax[l_cnt].ima01
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL g_imax.deleteElement(l_cnt)
      END IF

      FOR l_i = 1 TO g_azp1.getLength()
         LET g_azp[l_i].sel   = g_azp1[l_i].sel
         LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
         LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
         LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
      END FOR
 
      CALL s_showmsg_init()
      CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
      CALL s_showmsg()
   END IF
END FUNCTION
  
 
FUNCTION i100_unit_fac()
   IF cl_null(g_ima.ima31) THEN LET g_ima.ima31 = g_ima.ima25 END IF
   IF cl_null(g_ima.ima44) THEN LET g_ima.ima44 = g_ima.ima25 END IF
      
   #銷售單位轉換 
   IF g_ima.ima31 = g_ima.ima25 THEN
      LET g_ima.ima31_fac = 1
   ELSE
      IF g_sw = '1' THEN
         CALL cl_err(g_ima.ima31,'mfg1206',0)
         DISPLAY BY NAME  g_ima.ima25
      END IF
   END IF
    
   #采購單位轉換
   IF g_ima.ima44 = g_ima.ima25
      THEN LET g_ima.ima44_fac = 1
   ELSE 
      IF g_sw = '1' THEN
         CALL cl_err(g_ima.ima25,'mfg1206',0)
         DISPLAY BY NAME  g_ima.ima25     
      END IF
   END IF 
END FUNCTION            

FUNCTION i100_chk_ima149()
   IF cl_null(g_ima.ima149) THEN
      RETURN TRUE
   END IF
   
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima149,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",g_aza.aza81,"'"
   IF NOT i100_chk_cur(g_sql) THEN
      IF cl_null(g_dbase) THEN
         CALL cl_err(g_ima.ima149,"anm-001",0)
         RETURN FALSE
      ELSE
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima149
         LET g_errary[g_cnt].field="ima149"
         LET g_errary[g_cnt].errno="anm-001"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i100_b()
   DEFINE l_ac1_t         LIKE type_file.num10
   DEFINE l_ac2_t         LIKE type_file.num10
   DEFINE l_ac3_t         LIKE type_file.num10
   DEFINE l_ac4_t         LIKE type_file.num10 
   DEFINE l_n             LIKE type_file.num10
   DEFINE l_lock_sw       LIKE type_file.chr1
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_allow_insert  LIKE type_file.chr1
   DEFINE l_allow_delete  LIKE type_file.chr1
   DEFINE l_rta02         LIKE rta_file.rta02
   DEFINE l_ima25         LIKE ima_file.ima25
   DEFINE l_flag1         LIKE type_file.chr1
   DEFINE l_fac           LIKE type_file.num20_6
   DEFINE l_rte02         LIKE rte_file.rte02 
   DEFINE l_rtg02         LIKE rtg_file.rtg02
   DEFINE l_i             LIKE type_file.num10
   DEFINE l_line          LIKE type_file.num10
   DEFINE l_rtepos        LIKE rte_file.rtepos
   DEFINE l_rtgpos        LIKE rtg_file.rtgpos
   DEFINE l_rtd03         LIKE rtd_file.rtd03
   DEFINE l_rtf03         LIKE rtf_file.rtf03
   DEFINE l_rtz05         LIKE rtz_file.rtz05

   IF s_shut(0) THEN RETURN END IF

   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_ima.* 
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   
   IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err('','alm1499',0)
      RETURN
   END IF 

   IF g_ima.ima1010 <> '1' THEN 
      CALL cl_err('','alm1498',0)
      RETURN 
   END IF 
      
   LET l_line = 0         
   CALL cl_opmsg('b')
   LET g_action_choice = ""
           
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
                 
   LET g_forupd_sql = "SELECT rta02,rta03,'',rta04,rta05,rtaacti",
                      "  FROM rta_file ",
                      " WHERE rta01= '",g_ima.ima01,"'",
                      "   AND rta02 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl_1 CURSOR FROM g_forupd_sql

   LET g_forupd_sql = "SELECT rte01,rte02,rte08,'',rte04,rte05,rte06,rte07,rtepos",
                      "  FROM rte_file " ,
                      " WHERE rte03= '",g_ima.ima01,"'",
                      "   AND rte01 = ? AND rte02 = ? ", 
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl_2 CURSOR FROM g_forupd_sql

   LET g_forupd_sql = "SELECT rtg01,rtg02,rtg04,rtg05,rtg06,rtg07,rtg11,rtg08,rtg10,",    #FUN-C60050 add rtg11
                      "       rtg09,rtg12,rtgpos",                                   #FUN-C60050 add  rtg12
                      "  FROM rtg_file ",
                      " WHERE rtg03 = '",g_ima.ima01,"'",
                      "   AND rtg01 = ? AND rtg02 = ? ", #Add By baogc
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl_3 CURSOR FROM g_forupd_sql

   LET g_forupd_sql = "SELECT rty01,rty03,rty04,'',rty12,'',rty05,rty06,rty07,",
                      "       rty08,rty13,rty09,rty10,rty11,rtyacti",
                      "  FROM rty_file ",
                      " WHERE rty02= '",g_ima.ima01,"'",
                      "   AND rty01 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl_4 CURSOR FROM g_forupd_sql

  
   DIALOG ATTRIBUTE(UNBUFFERED)

      INPUT ARRAY g_rta FROM s_rta.*
         ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()

            BEGIN WORK
            OPEN i100_cl USING g_ima.ima01
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               EXIT DIALOG 
            END IF

            FETCH i100_cl INTO g_ima.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
               CLOSE i100_cl
               ROLLBACK WORK
               EXIT DIALOG 
            END IF


            IF g_rec_b1>=l_ac1 THEN
               LET p_cmd='u'
               LET g_rta_t.* = g_rta[l_ac1].*

               OPEN i100_bcl_1 USING g_rta_t.rta02 
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i100_bcl_1 INTO g_rta[l_ac1].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rta_t.rta03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT gfe02 INTO g_rta[l_ac1].rta03_desc
                       FROM gfe_file
                      WHERE gfe01 = g_rta[l_ac1].rta03
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rta[l_ac1].* TO NULL
            LET g_rta_t.* = g_rta[l_ac1].*
            LET g_rta[l_ac1].rtaacti = 'Y'
            CALL cl_show_fld_cont()
            NEXT FIELD rta03

         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i100_bcl_1
               CANCEL INSERT
            END IF

            SELECT MAX(rta02)+1 INTO l_rta02
              FROM rta_file
             WHERE rta01 = g_ima.ima01 

            IF cl_null(l_rta02) THEN
               LET l_rta02 = 1  
            END IF 
            LET g_rta[l_ac1].rta02 = l_rta02
           
            INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti)
            VALUES(g_ima.ima01,l_rta02,g_rta[l_ac1].rta03,g_rta[l_ac1].rta04,
                   g_rta[l_ac1].rta05,g_rta[l_ac1].rtaacti)
           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rta_file",g_ima.ima01,"",
                                                SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b1=g_rec_b1+1
               DISPLAY g_rec_b1 TO FORMONLY.cn2
               COMMIT WORK
            END IF
                 
         AFTER FIELD rta03           
            IF NOT cl_null(g_rta[l_ac1].rta03) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_rta[l_ac1].rta03 <> g_rta_t.rta03) THEN
                   CALL s_umfchk(g_ima.ima01,g_ima.ima25,g_rta[l_ac1].rta03)
                       RETURNING l_flag1,l_fac
                  IF l_flag1 = 1 THEN
                     CALL cl_err('','art-214',0)
                    NEXT FIELD rta03
                  END IF  
                  
                  IF NOT cl_null(g_rta[l_ac1].rta04) THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n 
                       FROM rta_file
                      WHERE rta01 = g_ima.ima01
                        AND rta03 = g_rta[l_ac1].rta03
                     IF l_n > 0 THEN
                        CALL cl_err('','alm-151',0)
                        DISPLAY g_rta_t.rta03 TO rta03
                        NEXT FIELD rta03
                     END IF
                  END IF
                  
                  CALL i100_rta03_desc(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_rta[l_ac1].rta03 = g_rta_t.rta03
                     NEXT FIELD rta03
                  END IF
               END IF
            END IF   
                    
         AFTER FIELD rta05
            IF NOT cl_null(g_rta[l_ac1].rta05) THEN 
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_rta_t.rta05 <> g_rta[l_ac1].rta05) THEN
                  CALL i100_rta05()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,0)
                     LET g_rta[l_ac1].rta05 = g_rta_t.rta05 
                     NEXT FIELD rta05 
                  END IF 
                  IF NOT i100_chk_repeat() THEN
                    #CALL cl_err(g_rta[l_ac1].rta05,'art-016',0)   #FUN-D40001 Mark
                     CALL cl_err(g_rta[l_ac1].rta05,'art-154',0)   #FUN-D40001 Add
                     LET g_rta[l_ac1].rta05 = g_rta_t.rta05
                     NEXT FIELD rta05
                  END IF
                  #FUN-D40001----Add-----Str
                  IF NOT i100_chk_repeat1() THEN
                     CALL cl_err(g_rta[l_ac1].rta05,'art-803',0) 
                     LET g_rta[l_ac1].rta05 = g_rta_t.rta05
                     NEXT FIELD rta05
                  END IF
                  #FUN-D40001----Add-----End
               END IF    
            END IF 
         
         #FUN-D40001----Add-----Str  
         AFTER FIELD rtaacti
            IF g_rta[l_ac1].rtaacti = 'Y' THEN
               IF NOT i100_chk_repeat1() THEN
                  CALL cl_err(g_rta[l_ac1].rtaacti,'art-803',0)
                  LET g_rta[l_ac1].rtaacti = g_rta_t.rtaacti
                  NEXT FIELD rtaacti
               END IF 
            END IF 
         #FUN-D40001----Add-----End
 
         BEFORE DELETE
            IF (g_ima.ima01 IS NOT NULL) THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF

               INITIALIZE g_doc.* TO NULL 
               LET g_doc.column1 = "rta03" 
               LET g_doc.value1 = g_rta[l_ac1].rta03
               CALL cl_del_doc()
               
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM rta_file WHERE rta02 = g_rta_t.rta02
                                      AND rta01 = g_ima.ima01
                          
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rta_file",g_rta_t.rta03,"",
                                SQLCA.sqlcode,"","",1)
                  LET l_ac1_t = l_ac1              
                  EXIT DIALOG
               END IF 
               
               LET g_rec_b1=g_rec_b1-1
               DISPLAY g_rec_b1 TO FORMONLY.cn2
               MESSAGE "delete ok"
               CLOSE i100_bcl_1
               COMMIT WORK
            END IF
         
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rta[l_ac1].* = g_rta_t.*
               CLOSE i100_bcl_1
               ROLLBACK WORK 
               EXIT DIALOG
            END IF  
                
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_rta[l_ac1].rta03,-263,0)
               LET g_rta[l_ac1].* = g_rta_t.*
            ELSE  
              #FUN-D40001----Add-----Str
              IF g_aza.aza88 = 'Y' THEN 
                  UPDATE rtg_file SET rtgpos = '2'
                   WHERE rtg03 = g_ima.ima01
                     AND rtg04 = g_rta[l_ac1].rta03
                     AND rtgpos = '3'
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","rtg_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
                  END IF
               END IF 
               #FUN-D40001----Add-----End
               UPDATE rta_file
                  SET rta03 = g_rta[l_ac1].rta03,
                      rta04 = g_rta[l_ac1].rta04,
                      rta05 = g_rta[l_ac1].rta05,
                      rtaacti = g_rta[l_ac1].rtaacti
                WHERE rta03 = g_rta_t.rta03
                  AND rta01 = g_ima.ima01
                  
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rta_file",g_rta_t.rta03,"",
                                                SQLCA.sqlcode,"","",1)
                  LET g_rta[l_ac1].* = g_rta_t.*                            
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            LET l_ac1 = ARR_CURR()
           #LET l_ac1_t = l_ac1     #FUN-D30033 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_rta[l_ac1].* = g_rta_t.*
               ELSE
                  CALL g_rta.deleteElement(l_ac1)
                  #FUN-D30033--add--str--
                  IF g_rec_b1 != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac1 = l_ac1_t
                  END IF
                  #FUN-D30033--add--end--
               END IF
               CLOSE i100_bcl_1
               ROLLBACK WORK 
               EXIT DIALOG
            END IF
            LET l_ac1_t = l_ac1     #FUN-D30033 Add
            CLOSE i100_bcl_1
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(rta03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_rta[l_ac1].rta03
                  CALL cl_create_qry() RETURNING g_rta[l_ac1].rta03
                  DISPLAY g_rta[l_ac1].rta03 TO rta03
                  NEXT FIELD rta03
            END CASE    

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_rta.deleteElement(l_ac1)
            END IF
            EXIT DIALOG
           
         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rta03) AND l_ac1 > 1 THEN
               LET g_rta[l_ac1].* = g_rta[l_ac1-1].*
               DISPLAY g_rta[l_ac1].* TO s_rta[l_ac1].*
               NEXT FIELD rta03
            END IF
      END INPUT
      INPUT ARRAY g_rte FROM s_rte.*
         ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

         BEFORE INPUT
           #TQC-C20357 Add Begin ---
            IF NOT s_chk_item_no(g_ima.ima01,'') THEN
               CALL cl_err('',g_errno,1)
               EXIT DIALOG
            END IF
           #TQC-C20357 Add End -----
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()

            IF g_rec_b2>=l_ac2 THEN
               LET p_cmd='u'
               LET g_cmd = p_cmd
               LET g_rte_t.* = g_rte[l_ac2].*
              
               LET g_before_input_done = FALSE
               CALL i100_set_entry_b2(p_cmd)
               CALL i100_set_no_entry_b2(p_cmd)
               LET g_before_input_done = TRUE              

               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rte_file 
                     SET rtepos = '4'
                   WHERE rte01 = g_rte[l_ac2].rte01
                     AND rte02 = g_rte[l_ac2].rte02
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rte_file",g_rte_t.rte01,"",SQLCA.sqlcode,"","",1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET l_rtepos = g_rte[l_ac2].rtepos
                  LET g_rte[l_ac2].rtepos = '4'
                  DISPLAY BY NAME g_rte[l_ac2].rtepos
               END IF

               BEGIN WORK
               OPEN i100_cl USING g_ima.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i100_cl:", STATUS, 1)
                  CLOSE i100_cl
                  ROLLBACK WORK
                  EXIT DIALOG
               END IF

               FETCH i100_cl INTO g_ima.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
                  CLOSE i100_cl
                  ROLLBACK WORK
                  EXIT DIALOG
               END IF

               OPEN i100_bcl_2 USING g_rte_t.rte01,g_rte_t.rte02
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl_2:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i100_bcl_2 INTO g_rte[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ima.ima01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT gec02 INTO g_rte[l_ac2].taxtype
                       FROM gec_file
                      WHERE gec01 = g_rte[l_ac2].rte08
                        AND gec011 = '2'
                  END IF
               END IF
               CALL cl_show_fld_cont()
            ELSE
               BEGIN WORK
               OPEN i100_cl USING g_ima.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i100_cl:", STATUS, 1)
                  CLOSE i100_cl
                  ROLLBACK WORK
                  EXIT DIALOG
               END IF

               FETCH i100_cl INTO g_ima.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
                  CLOSE i100_cl
                  ROLLBACK WORK
                  EXIT DIALOG
               END IF
            END IF 
               
         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'                    
            LET g_cmd = p_cmd          #TQC-C20136 add
            LET g_before_input_done = FALSE 
            CALL i100_set_entry_b2(p_cmd)          
            CALL i100_set_no_entry_b2(p_cmd)
            LET g_before_input_done = TRUE                
            INITIALIZE g_rte[l_ac2].* TO NULL
            LET g_rte[l_ac2].rte04 = 'Y'
            LET g_rte[l_ac2].rte05 = 'Y'
            LET g_rte[l_ac2].rte06 = 'Y'
            LET g_rte[l_ac2].rte07 = 'Y'
            IF g_aza.aza88 = 'Y' THEN
               LET g_rte[l_ac2].rtepos = '1'
               LET l_rtepos = '1'
            END IF 
            IF l_ac2 <= 1 THEN
               LET g_rte[l_ac2].rte08 = ''
            ELSE 
               LET g_rte[l_ac2].rte08 = g_rte[l_ac2-1].rte08   
            END IF  
            DISPLAY BY NAME g_rte[l_ac2].rtepos
            CALL cl_set_comp_entry("rtepos",FALSE)
            LET g_rte_t.* = g_rte[l_ac2].*
            CALL cl_show_fld_cont()    
            NEXT FIELD rte01
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i100_bcl_2
               CANCEL INSERT
            END IF
           #FUN-D30050--add--str---
            CALL i100_chk_tax(g_ima.ima01,g_rte[l_ac2].rte08)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ima.ima01,g_errno,1)
               ROLLBACK WORK
               CANCEL INSERT
            END IF
           #FUN-D30050--add--end---
           #FUN-D40001--add--str---
           CALL i100_rte08(p_cmd)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_rte[l_ac2].rte08,g_errno,1)
              ROLLBACK WORK
              CANCEL INSERT
           END IF
           #FUN-D40001--add--end---
            
            INSERT INTO rte_file(rte01,rte02,rte03,rte04,rte05,rte06,rte07,
                                 rte08,rte09,rtepos)
            VALUES(g_rte[l_ac2].rte01,g_rte[l_ac2].rte02,g_ima.ima01,g_rte[l_ac2].rte04,
                    g_rte[l_ac2].rte05,g_rte[l_ac2].rte06,g_rte[l_ac2].rte07,
                    g_rte[l_ac2].rte08,'2',g_rte[l_ac2].rtepos)
               
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rte_file",g_ima.ima01,"",
                                            SQLCA.sqlcode,"","",1)
               ROLLBACK WORK                              
               CANCEL INSERT
            ELSE
               CALL i100_rte01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  ROLLBACK WORK
                  CANCEL INSERT
               ELSE
#MOD-C30653 mark begin ---
#                  SELECT COUNT(DISTINCT gec07) INTO g_cnt
#                    FROM rte_file
#                   INNER JOIN rvy_file
#                      ON rte01 = rvy01
#                     AND rte02 = rvy02
#                   INNER JOIN gec_file
#                      ON rvy04 = gec01
#                     AND rvy05 = gec011
#                   WHERE rvy01 = g_rte[l_ac2].rte01
#                     AND rte07 = 'Y'
#                  IF g_cnt > 1 THEN
#                     CALL cl_err('','art1039',0)
#                     ROLLBACK WORK
#                     CANCEL INSERT   
#                  ELSE 
#MOD-C30653 mark end ----
                     MESSAGE 'INSERT O.K'
                     LET g_rec_b2=g_rec_b2+1
                     DISPLAY g_rec_b2 TO FORMONLY.cn2
                     COMMIT WORK
#                 END IF                                #MOD-C30653 mark 
               END IF
            END IF

         AFTER FIELD rte01
            IF NOT cl_null(g_rte[l_ac2].rte01) THEN
               IF p_cmd = 'a' THEN
                  SELECT MAX(rte02)+1 INTO l_rte02
                    FROM rte_file
                   WHERE rte01 = g_rte[l_ac2].rte01
                  IF cl_null(l_rte02) THEN
                     LET l_rte02 = 1
                  END IF
                  LET g_rte[l_ac2].rte02 = l_rte02
               END IF
 
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_rte[l_ac2].rte01 <> g_rte_t.rte01) THEN  
                  SELECT COUNT(*) INTO l_n 
                    FROM rte_file 
                   WHERE rte01 = g_rte[l_ac2].rte01 AND rte03 = g_ima.ima01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     NEXT FIELD rte01
                  END IF
                 #TQC-C20136--start add---------------------------------------
                  CALL i100_rte01_1()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,0)
                     LET g_rte[l_ac2].rte01 = g_rte_t.rte01
                     NEXT FIELD rte01
                  END IF 
                 #TQC-C20136--end add----------------------------------------- 
               END IF 
            END IF 
            
         AFTER FIELD rte08
            IF NOT cl_null(g_rte[l_ac2].rte08)  THEN
              #FUN-D30050--add--str---
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rte[l_ac2].rte08 <> g_rte_t.rte08) THEN
                  CALL i100_chk_tax(g_ima.ima01,g_rte[l_ac2].rte08)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ima.ima01,g_errno,1)
                     LET g_rte[l_ac2].rte08 = g_rte_t.rte08
                     NEXT FIELD rte08
                  END IF
               END IF
              #FUN-D30050--add--end---
               IF p_cmd = 'a' THEN
                  CALL i100_rte08(p_cmd)
                 #FUN-C30306 mark START
                 #IF l_flag = 'Y' THEN
                 #   CALL i100_a_rvy('Y')
                 #END IF 
                 #FUN-C30306 mark END
                  IF NOT cl_null(g_errno) THEN
                     NEXT FIELD rte08 
                  ELSE
                     LET g_rte_t.rte08 = g_rte[l_ac2].rte08
                  END IF
               ELSE
                  IF g_rte[l_ac2].rte08 <> g_rte_t.rte08 THEN
                     CALL i100_rte08(p_cmd)
                    #FUN-C30306 mark START
                    #IF l_flag = 'Y' THEN
                    #    CALL i100_a_rvy('Y')
                    #END IF
                    #FUN-C30306 mark END
                     IF NOT cl_null(g_errno) THEN
                        NEXT FIELD rte08
                     END IF 
                  END IF
               END IF
            END IF

         AFTER FIELD rte04
            IF NOT cl_null(g_rte[l_ac2].rte04) THEN
               IF g_rte[l_ac2].rte04 NOT MATCHES '[YN]' THEN
                  NEXT FIELD rte04
               END IF
            END IF
        
        AFTER FIELD rte05
           IF NOT cl_null(g_rte[l_ac2].rte05) THEN
              IF g_rte[l_ac2].rte05 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte05
              END IF
           END IF
           
        AFTER FIELD rte06
           IF NOT cl_null(g_rte[l_ac2].rte06) THEN
              IF g_rte[l_ac2].rte06 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte06
              END IF
           END IF
           
        AFTER FIELD rte07
           IF NOT cl_null(g_rte[l_ac2].rte07) THEN
              IF g_rte[l_ac2].rte07 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte07
              END IF
           END IF
        
        AFTER FIELD rtepos
           IF NOT cl_null(g_rte[l_ac2].rtepos) THEN
              IF g_rte[l_ac2].rtepos NOT MATCHES '[123]' THEN
                 NEXT FIELD rtepos
              END IF
           END IF    
                  
         BEFORE DELETE
            IF g_ima.ima01 IS NOT NULL THEN

               INITIALIZE l_rtd03 TO NULL
               SELECT rtd03 INTO l_rtd03 FROM rtd_file WHERE rtd01 = g_rte_t.rte01
               IF l_rtd03 <> g_plant THEN 
                  CALL cl_err('','art-977',0)
                  CANCEL DELETE
               END IF
               
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF g_aza.aza88 = 'Y' THEN
                  IF NOT ((l_rtepos='3' AND g_rte[l_ac2].rte07='N')
                            OR (l_rtepos='1'))  THEN
                    CALL cl_err('','apc-139',0)
                    CANCEL DELETE 
                 END IF 
               END IF 
               
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "rte01" 
               LET g_doc.value1 = g_rte[l_ac2].rte01
               CALL cl_del_doc()
               
               IF l_lock_sw = "Y" THEN  
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM rte_file WHERE rte03 = g_ima.ima01
                                      AND rte01 = g_rte_t.rte01

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rte_file",g_rte_t.rte01,"",
                                                 SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK 
                  CANCEL DELETE 
               ELSE
                  #缺删除rvy表
                  DELETE FROM rvy_file
                   WHERE rvy01 =  g_rte[l_ac2].rte01
                     AND rvy02 = g_rte_t.rte02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","rvy_file",g_rte[l_ac2].rte01,g_rte_t.rte02,SQLCA.sqlcode,"","",1)  
                     ROLLBACK WORK
                     CANCEL DELETE
                  END IF
                  #策略單身無資料時，刪除策略單頭
                  SELECT COUNT(*) INTO l_n FROM rte_file WHERE rte01 = g_rte_t.rte01
                  IF l_n = 0 THEN 
                     DELETE FROM rtd_file WHERE rtd01 = g_rte_t.rte01
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","rtd_file",g_rte_t.rte01,'',SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK
                        CANCEL DELETE
                     END IF
                  END IF
               END IF
               LET g_rec_b2=g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn2
               COMMIT WORK
            END IF
                     
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rte[l_ac2].* = g_rte_t.*
               CLOSE i100_bcl_2
               ROLLBACK WORK
               EXIT DIALOG  
            END IF       
            IF g_aza.aza88 = 'Y' THEN 
               IF l_rtepos <> '1' THEN
                  LET g_rte[l_ac2].rtepos = '2'
               ELSE 
                  LET g_rte[l_ac2].rtepos = '1' 
               END IF
            END IF       
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_rte[l_ac2].rte01,-263,0)
               LET g_rte[l_ac2].* = g_rte_t.*
            ELSE             
               INITIALIZE l_rtd03 TO NULL
               SELECT rtd03 INTO l_rtd03 FROM rtd_file WHERE rtd01 = g_rte_t.rte01
               IF l_rtd03 <> g_plant THEN 
                  CALL cl_err('','art-977',0)
                  LET g_rte[l_ac2].* = g_rte_t.*
               ELSE
                  UPDATE rte_file 
                     SET rte08=g_rte[l_ac2].rte08, 
                         rte04=g_rte[l_ac2].rte04,
                         rte05=g_rte[l_ac2].rte05,
                         rte06=g_rte[l_ac2].rte06,
                         rte07=g_rte[l_ac2].rte07,
                         rtepos=g_rte[l_ac2].rtepos
                   WHERE rte03 = g_ima.ima01
                     AND rte01 = g_rte_t.rte01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","rte_file",g_rte_t.rte01,"",
                                                    SQLCA.sqlcode,"","",1)
                     LET g_rte[l_ac2].* = g_rte_t.*
                  ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                  END IF
               END IF
            END IF

         AFTER ROW
            LET l_ac2 = ARR_CURR()            # 新增
           #LET l_ac2_t = l_ac2               # 新增   #FUN-D30033 Mark

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i100_bcl_2
               ROLLBACK WORK 
               IF p_cmd='u' THEN
                  IF g_aza.aza88 = 'Y' THEN
                     UPDATE rte_file 
                        SET rtepos = l_rtepos
                      WHERE rte01 = g_rte[l_ac2].rte01 
                        AND rte02 = g_rte[l_ac2].rte02
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","rte_file",g_rte_t.rte01,"",SQLCA.sqlcode,"","",1)
                     END IF
                     LET g_rte[l_ac2].rtepos = l_rtepos
                     DISPLAY BY NAME g_rte[l_ac2].rtepos
                  END IF
                  LET g_rte[l_ac2].* = g_rte_t.*
               ELSE
                  CALL g_rte.deleteElement(l_ac2)
                  #FUN-D30033--add--str--
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac2 = l_ac2_t
                  END IF
                  #FUN-D30033--add--end--
               END IF
               EXIT DIALOG
            END IF

            LET l_ac2_t = l_ac2              #FUN-D30033 Add
            CLOSE i100_bcl_2   
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(rte01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rtd01"
                  LET g_qryparam.default1 = g_rte[l_ac2].rte01
                  IF p_cmd = 'a' THEN
                    #FUN-C30306 mark START
                    #LET g_qryparam.state = "c"
                    #LET g_qryparam.where = " rtdacti='Y' AND rtdconf = 'Y' AND rtd03 = '",g_plant,"' "
                    #CALL cl_create_qry() RETURNING g_multi_rte01
                    #IF NOT cl_null(g_multi_rte01) THEN
                    #   CALL i100_multi_rte01()
                    #   CALL i100_list_fill()
                    #   LET g_flag_b = '2'    #TQC-C20270  add
                    #   CALL i100_b()         #TQC-C20136  add        
                    #   EXIT DIALOG
                    #ELSE
                    #   NEXT FIELD rte01
                    #END IF
                    #FUN-C30306 mark END
                    #FUN-C30306 add START
                     LET g_qryparam.where = " rtdacti='Y' AND rtdconf = 'Y' AND rtd03 = '",g_plant,"' "
                     CALL cl_create_qry() RETURNING g_rte[l_ac2].rte01 
                     NEXT FIELD rte01
                    #FUN-C30306 add END 
                  ELSE
                     LET g_qryparam.where = " rtd03 = '",g_plant,"' "
                     CALL cl_create_qry() RETURNING g_rte[l_ac2].rte01
                     NEXT FIELD rte01
                  END IF

               WHEN INFIELD(rte08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gec011"
                    LET g_qryparam.default1 = g_rte[l_ac2].rte08
                    CALL cl_create_qry() RETURNING g_rte[l_ac2].rte08
                    DISPLAY BY NAME g_rte[l_ac2].rte08
                    NEXT FIELD rte08
            END CASE


         ON ACTION ACCEPT 
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_rte.deleteElement(l_ac2)
            ELSE
               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rte_file
                     SET rtepos = l_rtepos
                   WHERE rte01 = g_rte[l_ac2].rte01
                     AND rte02 = g_rte[l_ac2].rte02
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rte_file",g_rte_t.rte01,"",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_rte[l_ac2].rtepos = l_rtepos
                  DISPLAY BY NAME g_rte[l_ac2].rtepos
               END IF
               LET g_rte[l_ac2].* = g_rte_t.*
            END IF
            EXIT DIALOG
         ON ACTION tax_detail
            CALL i100_a_rvy('Y') 
                  
         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rte01) AND l_ac2 > 1 THEN
               LET g_rte[l_ac2].* = g_rte[l_ac2-1].*
               NEXT FIELD rte01
            END IF
      END INPUT

      INPUT ARRAY g_rtg FROM s_rtg.*
         ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
         BEFORE INPUT
           #TQC-C20357 Add Begin ---
            IF NOT s_chk_item_no(g_ima.ima01,'') THEN
               CALL cl_err('',g_errno,1)
               EXIT DIALOG
            END IF
           #TQC-C20357 Add End -----
            IF g_rec_b3 != 0 THEN
               CALL fgl_set_arr_curr(l_ac3)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac3 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()

            IF g_rec_b3 >= l_ac3 THEN
               LET p_cmd='u'
               LET g_rtg_t.* = g_rtg[l_ac3].*
               LET g_before_input_done = FALSE
               CALL i100_set_entry_b3(p_cmd)
               CALL i100_set_no_entry_b3(p_cmd)
               LET g_before_input_done = TRUE              

               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rtg_file 
                     SET rtgpos = '4'
                   WHERE rtg01 = g_rtg[l_ac3].rtg01
                     AND rtg02 = g_rtg[l_ac3].rtg02
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rtg_file",g_rtg_t.rtg01,"",SQLCA.sqlcode,"","",1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET l_rtgpos = g_rtg[l_ac3].rtgpos
                  LET g_rtg[l_ac3].rtgpos = '4'
                  DISPLAY BY NAME g_rtg[l_ac3].rtgpos
               END IF       
 
               BEGIN WORK

               OPEN i100_cl USING g_ima.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i100_cl:", STATUS, 1)
                  CLOSE i100_cl
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH i100_cl INTO g_ima.*
               IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
                 CLOSE i100_cl
                 ROLLBACK WORK
                 RETURN
               END IF

               OPEN i100_bcl_3 USING g_rtg_t.rtg01,g_rtg_t.rtg02
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl_3:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i100_bcl_3 INTO g_rtg[l_ac3].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ima.ima01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i100_rtg04()
               END IF
               CALL cl_show_fld_cont()
            ELSE
               BEGIN WORK

               OPEN i100_cl USING g_ima.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i100_cl:", STATUS, 1)
                  CLOSE i100_cl
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH i100_cl INTO g_ima.*
               IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
                 CLOSE i100_cl
                 ROLLBACK WORK
                 RETURN
               END IF  
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'       
            LET g_before_input_done = FALSE
            CALL i100_set_entry_b3(p_cmd)
            CALL i100_set_no_entry_b3(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_rtg[l_ac3].* TO NULL
            LET g_rtg_t.* = g_rtg[l_ac3].*
            LET g_rtg[l_ac3].rtg08 = 'N'
            LET g_rtg[l_ac3].rtg10 = 'N'
            LET g_rtg[l_ac3].rtg09 = 'Y'
            LET g_rtg[l_ac3].rtg12=g_today       #FUN-C60050
            IF g_aza.aza88 = 'Y' THEN  
               LET g_rtg[l_ac3].rtgpos = '1'
               LET l_rtgpos = '1' 
            END IF   

            CALL cl_show_fld_cont()
            NEXT FIELD rtg01
                  
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i100_bcl_3
               CANCEL INSERT   
            END IF  

            INSERT INTO rtg_file(rtg01,rtg02,rtg03,rtg04,rtg05,rtg06,rtg07,
                                 rtg11,rtg08,rtg09,rtg10,rtg12,rtgpos)                           #FUN-C60050 add rtg11,rtg12
            VALUES(g_rtg[l_ac3].rtg01,g_rtg[l_ac3].rtg02,g_ima.ima01,g_rtg[l_ac3].rtg04,
                   g_rtg[l_ac3].rtg05,g_rtg[l_ac3].rtg06,g_rtg[l_ac3].rtg07,g_rtg[l_ac3].rtg11,  #FUN-C60050 add rtg11
                   g_rtg[l_ac3].rtg08,g_rtg[l_ac3].rtg09,g_rtg[l_ac3].rtg10,
                   g_rtg[l_ac3].rtg12,g_rtg[l_ac3].rtgpos)                                     #FUN-C60050 add rtg12
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rtg_file",g_rtg[l_ac3].rtg01,"",
                                                 SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               CALL i100_rtg01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  ROLLBACK WORK
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b3 = g_rec_b3 + 1
                  DISPLAY g_rec_b3 TO FORMONLY.cn2
                  COMMIT WORK
               END IF
            END IF
            
         AFTER FIELD rtg01
            IF NOT cl_null(g_rtg[l_ac3].rtg01) THEN
               IF p_cmd = 'a' THEN 
                  SELECT MAX(rtg02)+1 INTO l_rtg02
                    FROM rtg_file
                   WHERE rtg01 = g_rtg[l_ac3].rtg01

                  IF cl_null(l_rtg02) THEN
                     LET l_rtg02 = 1
                  END IF
                  LET g_rtg[l_ac3].rtg02 = l_rtg02 
               END IF 

               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rtg[l_ac3].rtg01 <> g_rtg_t.rtg01) THEN
                 #TQC-C20070 Mark Begin ---
                 #SELECT COUNT(*) INTO l_n 
                 #  FROM rtg_file 
                 # WHERE rtg01 = g_rtg[l_ac3].rtg01 AND rtg03 = g_ima.ima01
                 #IF l_n > 0 THEN
                 #   CALL cl_err('','-239',0)
                 #   NEXT FIELD rtg01
                 #END IF
                 #TQC-C20070 Mark End ---
                 #TQC-C20070 Add Begin ---
                  IF NOT i100_chk_rtg01() THEN
                     CALL cl_err('','art1046',0)
                     NEXT FIELD rtg01
                  END IF
                  IF NOT i100_chk_include() THEN
                     CALL cl_err('','art-060',0)
                     NEXT FIELD rtg01
                  END IF
                 #TQC-C20070 Add End -----
                 #TQC-C20136--start add---------------------------  
                  CALL i100_rtg01_1()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_rtg[l_ac3].rtg01 = g_rtg_t.rtg01
                     NEXT FIELD rtg01
                  END IF 
                 #TQC-C20136--end add------------------------------
                  IF NOT cl_null(g_rtg[l_ac3].rtg04) THEN
                     CALL i100_rtg01_chk()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_rtg[l_ac3].rtg01 = g_rtg_t.rtg01
                        NEXT FIELD rtg01 
                     END IF  
                  END IF
               END IF
            END IF 

         AFTER FIELD rtg04
            IF NOT cl_null(g_rtg[l_ac3].rtg04) THEN
               IF g_rtg_t.rtg04 IS NULL OR
                  (g_rtg[l_ac3].rtg04 != g_rtg_t.rtg04 ) THEN
                 #TQC-D40044--add--str---
                  IF g_rtg[l_ac3].rtg04 != g_ima.ima25 THEN
                     CALL s_umfchk(g_ima.ima01,g_ima.ima25,g_rtg[l_ac3].rtg04)
                        RETURNING l_flag1,l_fac  
                     IF l_flag1 = 1 THEN
                        CALL cl_err('','art-214',0)
                        LET g_rtg[l_ac3].rtg04 = g_rtg_t.rtg04
                        DISPLAY BY NAME g_rtg[l_ac3].rtg04
                        NEXT FIELD rtg04
                     END IF
                  END IF
                 #TQC-D40044--add--end--- 
                  CALL i100_rtg04()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rtg[l_ac3].rtg04,g_errno,0)
                     LET g_rtg[l_ac3].rtg04 = g_rtg_t.rtg04
                     DISPLAY BY NAME g_rtg[l_ac3].rtg04
                     NEXT FIELD rtg04
                  END IF
                 #TQC-C20070 Add Begin ---
                  IF NOT i100_chk_rtg01() THEN
                     CALL cl_err('','art1046',0)
                     NEXT FIELD rtg04
                  END IF
                  IF NOT i100_chk_include() THEN
                     CALL cl_err('','art-060',0)
                     NEXT FIELD rtg04
                  END IF
                 #TQC-C20070 Add End -----
                  CALL i100_get_price()
               END IF
            END IF         

         AFTER FIELD rtg06
            IF NOT cl_null(g_rtg[l_ac3].rtg06) THEN
               IF g_rtg[l_ac3].rtg06>g_rtg[l_ac3].rtg05 THEN
                  CALL cl_err('','art-981',0)
               END IF
            END IF

         AFTER FIELD rtg07
            IF NOT cl_null(g_rtg[l_ac3].rtg07) THEN
               IF g_rtg[l_ac3].rtg07 > g_rtg[l_ac3].rtg05 OR g_rtg[l_ac3].rtg07>g_rtg[l_ac3].rtg06 THEN
                  CALL cl_err('','art-980',0)
               END IF
            END IF

         AFTER FIELD rtg08
            IF NOT cl_null(g_rtg[l_ac3].rtg08) THEN
               IF g_rtg[l_ac3].rtg08 NOT MATCHES '[YN]' THEN
                  NEXT FIELD rtg08
               END IF
            END IF

         AFTER FIELD rtg09
            IF NOT cl_null(g_rtg[l_ac3].rtg09) THEN
               IF g_rtg[l_ac3].rtg09 NOT MATCHES '[YN]' THEN
                  NEXT FIELD rtg09
               END IF
            END IF    

         BEFORE DELETE                      
            IF g_rtg_t.rtg01 IS NOT NULL THEN

               INITIALIZE l_rtf03 TO NULL
               SELECT rtf03 INTO l_rtf03 FROM rtf_file WHERE rtf01 = g_rtg_t.rtg01
               IF l_rtf03 <> g_plant THEN
                  CALL cl_err('','art-977',0)
                  CANCEL DELETE
               END IF

               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF      
               
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "rtg01"
               LET g_doc.value1 = g_rtg[l_ac3].rtg01
               CALL cl_del_doc()
               IF g_aza.aza88 = 'Y' THEN
                  IF NOT ((l_rtgpos='3' AND g_rtg[l_ac3].rtg09='N')
                            OR (l_rtgpos='1'))  THEN
                    CALL cl_err('','apc-139',0)
                    CANCEL DELETE
                    RETURN
                 END IF   
               END IF 
               
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM rtg_file WHERE rtg01 = g_rtg_t.rtg01
                                      AND rtg03 = g_ima.ima01
                                      AND rtg02 = g_rtg_t.rtg02

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rtg_file",g_rtg_t.rtg01,"",
                                               SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK 
                  CANCEL DELETE 
                  EXIT DIALOG
               ELSE
                  #策略單身無資料時，刪除策略單頭
                  SELECT COUNT(*) INTO l_n FROM rtg_file WHERE rtg01 = g_rtg_t.rtg01
                  IF l_n = 0 THEN
                     DELETE FROM rtf_file WHERE rtf01 = g_rtg_t.rtg01
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("del","rtf_file",g_rtg_t.rtg01,'',SQLCA.sqlcode,"","",1)
                        ROLLBACK WORK
                        CANCEL DELETE
                     END IF
                  END IF 
               END IF
               LET g_rec_b3=g_rec_b3-1
               DISPLAY g_rec_b3 TO FORMONLY.cn2
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rtg[l_ac3].* = g_rtg_t.*
               CLOSE i100_bcl_3
               ROLLBACK WORK
               EXIT DIALOG
            END IF

            IF g_aza.aza88 = 'Y' THEN
               IF l_rtgpos <> '1' THEN
                  LET g_rtg[l_ac3].rtgpos='2'
               ELSE 
                  LET g_rtg[l_ac3].rtgpos='1'  
               END IF 
               DISPLAY BY NAME g_rtg[l_ac3].rtgpos
            END IF 
            
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_rtg[l_ac3].rtg01,-263,0)
               LET g_rtg[l_ac3].* = g_rtg_t.*
            ELSE
               INITIALIZE l_rtf03 TO NULL
               SELECT rtf03 INTO l_rtf03 FROM rtf_file WHERE rtf01 = g_rtg_t.rtg01
               IF l_rtf03 <> g_plant THEN
                  CALL cl_err('','art-977',0)
                  LET g_rtg[l_ac3].* = g_rtg_t.*
               ELSE
                  UPDATE rtg_file 
                     SET rtg01=g_rtg[l_ac3].rtg01,
                         rtg04=g_rtg[l_ac3].rtg04,
                         rtg05=g_rtg[l_ac3].rtg05,
                         rtg06=g_rtg[l_ac3].rtg06,
                         rtg07=g_rtg[l_ac3].rtg07,
                         rtg11=g_rtg[l_ac3].rtg11,         #FUN-C60050 add
                         rtg08=g_rtg[l_ac3].rtg08,
                         rtg10=g_rtg[l_ac3].rtg10,
                         rtg09=g_rtg[l_ac3].rtg09,
                         rtg12=g_rtg[l_ac3].rtg12,         #FUN-C60050 add 
                         rtgpos=g_rtg[l_ac3].rtgpos
                   WHERE rtg01 = g_rtg_t.rtg01
                     AND rtg03 = g_ima.ima01
                     AND rtg02 = g_rtg_t.rtg02

                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","rtg_file",g_rtg_t.rtg01,"",
                                                  SQLCA.sqlcode,"","",1)
                     LET g_rtg[l_ac3].* = g_rtg_t.*             
                  ELSE
                     MESSAGE 'UPDATE O.K'                                        
                     COMMIT WORK 
                  END IF
               END IF
            END IF
               
         AFTER ROW
            LET l_ac3 = ARR_CURR()            # 新增
           #LET l_ac3_t = l_ac3               # 新增   #FUN-D30033 Mark
                      
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i100_bcl_3 
               ROLLBACK WORK  
               IF p_cmd='u' THEN
                  IF g_aza.aza88 = 'Y' THEN
                     UPDATE rtg_file 
                        SET rtgpos = l_rtgpos
                      WHERE rtg01 = g_rtg[l_ac3].rtg01 
                        AND rtg02 = g_rtg[l_ac3].rtg02
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL cl_err3("upd","rtg_file",g_rtg_t.rtg01,"",SQLCA.sqlcode,"","",1)
                     END IF
                     LET g_rtg[l_ac3].rtgpos = l_rtgpos
                     DISPLAY BY NAME g_rtg[l_ac3].rtgpos
                  END IF
                  LET g_rtg[l_ac3].* = g_rtg_t.*
               ELSE
                  CALL g_rtg.deleteElement(l_ac3)
                  #FUN-D30033--add--str--
                  IF g_rec_b3 != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac3 = l_ac3_t
                  END IF
                  #FUN-D30033--add--end--
               END IF
               EXIT DIALOG
            END IF 
              
            LET l_ac3_t = l_ac3              #FUN-D30033 Add 
            CLOSE i100_bcl_3    
            COMMIT WORK
               
         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rtg01) AND l_ac3 > 1 THEN
               LET g_rtg[l_ac3].* = g_rtg[l_ac3-1].*
               NEXT FIELD rtg01 
            END IF                 
                                   
         ON ACTION controlp                      
            CASE                      
               WHEN INFIELD(rtg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rtf01"
                  LET g_qryparam.default1 = g_rtg[l_ac3].rtg01
                  IF p_cmd = 'a' THEN
                     LET g_qryparam.state = "c"
                     LET g_qryparam.where = " rtfacti='Y' AND rtfconf='Y' AND rtf03 = '",g_plant,"' "
                     CALL cl_create_qry() RETURNING g_multi_rtg01
                     IF NOT cl_null(g_multi_rtg01) THEN
                        CALL i100_multi_rtg01()
                        CALL i100_list_fill()
                        LET g_flag_b = '3'    #TQC-C20270  add
                        CALL i100_b()         #TQC-C20136  add
                        EXIT DIALOG      
                     ELSE
                        NEXT FIELD rtg01
                     END IF
                  ELSE
                     LET g_qryparam.where = " rtf03 = '",g_plant,"' "
                     CALL cl_create_qry() RETURNING g_rtg[l_ac3].rtg01
                     NEXT FIELD rte01
                  END IF

              #TQC-C20070 Add Begin ---
              WHEN INFIELD(rtg04)
                 CALL cl_init_qry_var()
                 SELECT rtz05 INTO l_rtz05 FROM rtz_file
                  WHERE rtz01=g_plant
                 IF cl_null(l_rtz05) THEN
                    LET g_qryparam.form ="q_gfe"
                 ELSE
                    LET g_qryparam.arg1 = g_ima.ima01
                    LET g_qryparam.arg2 = l_rtz05
                    LET g_qryparam.arg3 = l_rtz05
                    LET g_qryparam.form ="q_rtg04"
                 END IF
                 LET g_qryparam.default1 = g_rtg[l_ac3].rtg04
                 CALL cl_create_qry() RETURNING g_rtg[l_ac3].rtg04
                 DISPLAY BY NAME g_rtg[l_ac3].rtg04    
                 CALL i100_rtg04()
                 NEXT FIELD rtg04
              #TQC-C20070 Add End -----

               OTHERWISE
                  EXIT CASE
            END CASE

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_rtg.deleteElement(l_ac3)
            ELSE
               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rtg_file
                     SET rtgpos = l_rtgpos
                   WHERE rtg01 = g_rtg[l_ac3].rtg01
                     AND rtg02 = g_rtg[l_ac3].rtg02
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rtg_file",g_rtg_t.rtg01,"",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_rtg[l_ac3].rtgpos = l_rtgpos
                  DISPLAY BY NAME g_rtg[l_ac3].rtgpos
               END IF
               LET g_rtg[l_ac3].* = g_rtg_t.*
            END IF
            EXIT DIALOG

      END INPUT

      INPUT ARRAY g_rty FROM s_rty.*
         ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
         BEFORE INPUT
           #TQC-C20357 Add Begin ---
            IF NOT s_chk_item_no(g_ima.ima01,'') THEN
               CALL cl_err('',g_errno,1) 
               EXIT DIALOG
            END IF
            IF NOT s_internal_item(g_ima.ima01,g_plant) THEN
               CALL cl_err('','art-701',1)
               EXIT DIALOG
            END IF
           #TQC-C20357 Add End -----
            IF g_rec_b4 != 0 THEN
               CALL fgl_set_arr_curr(l_ac4)
            END IF

         BEFORE ROW
            LET p_cmd=''
            LET l_ac4 = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()

            BEGIN WORK 

            OPEN i100_cl USING g_ima.ima01
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1) 
               CLOSE i100_cl
               ROLLBACK WORK  
               RETURN 
            END IF  
            FETCH i100_cl INTO g_ima.*
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
              CLOSE i100_cl
              ROLLBACK WORK
              RETURN
            END IF

            IF g_rec_b4 >= l_ac4 THEN
               LET p_cmd='u'
               LET g_rty_t.* = g_rty[l_ac4].*
               IF g_rty[l_ac4].rty03 = "1" THEN
                  CALL cl_set_comp_entry("rty04",FALSE)
                  LET g_rty[l_ac4].rty04 = '' 
                  LET g_rty[l_ac4].rty04_desc = ''
                  DISPLAY BY NAME g_rty[l_ac4].rty04
                  DISPLAY BY NAME g_rty[l_ac4].rty04_desc
               ELSE 
                  CALL cl_set_comp_entry("rty04",TRUE)
               END IF 

               IF g_rty[l_ac4].rty03 ='2' OR g_rty[l_ac4].rty03='4' THEN
                  CALL cl_set_comp_required("rty12",TRUE)
               ELSE
                  CALL cl_set_comp_required("rty12",FALSE)
               END IF
                
               OPEN i100_bcl_4 USING g_rty_t.rty01 
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl_4:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i100_bcl_4 INTO g_rty[l_ac4].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rty_t.rty03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i100_rty04_desc('d')
                  CALL i100_rty12_desc('d')
               END IF
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'       
            INITIALIZE g_rty[l_ac4].* TO NULL
            LET g_rty_t.* = g_rty[l_ac4].*
            LET g_rty[l_ac4].rtyacti = 'Y'
            CALL cl_show_fld_cont()
            NEXT FIELD rty01
                  
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i100_bcl_4
               CANCEL INSERT   
            END IF   

            IF cl_null(g_rty[l_ac4].rty03) OR cl_null(g_rty[l_ac4].rty05) 
               OR cl_null(g_rty[l_ac4].rty06) THEN
               LET g_rty[l_ac4].rtyacti = 'N'
            ELSE
               LET g_rty[l_ac4].rtyacti = 'Y'
            END IF
            
            INSERT INTO rty_file(rty01,rty02,rty03,rty04,rty05,rty06,rty07,
                                 rty08,rty09,rty10,rty11,rty12,rty13,rtyacti)
            VALUES(g_rty[l_ac4].rty01,g_ima.ima01,g_rty[l_ac4].rty03,
                   g_rty[l_ac4].rty04,g_rty[l_ac4].rty05,g_rty[l_ac4].rty06,
                   g_rty[l_ac4].rty07,g_rty[l_ac4].rty08,g_rty[l_ac4].rty09,
                   g_rty[l_ac4].rty10,g_rty[l_ac4].rty11,g_rty[l_ac4].rty12,
                   g_rty[l_ac4].rty13,g_rty[l_ac4].rtyacti)
            
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rty_file",g_rty[l_ac4].rty01,"",
                                                 SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b4 = g_rec_b4 + 1
               DISPLAY g_rec_b4 TO FORMONLY.cn2
               COMMIT WORK
            END IF
            
         AFTER FIELD rty01
            IF NOT cl_null(g_rty[l_ac4].rty01) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_rty[l_ac4].rty01 <> g_rty_t.rty01) THEN  
                  CALL i100_rty01()
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,0)
                     LET g_rty[l_ac4].rty01 = g_rty_t.rty01 
                     NEXT FIELD rty01
                  END IF
               END IF 
            END IF 

         ON CHANGE rty03 
            IF g_rty[l_ac4].rty03 = '1' THEN
               CALL cl_set_comp_entry("rty04",FALSE)
               LET g_rty[l_ac4].rty04 = ''
               LET g_rty[l_ac4].rty04_desc = ''
            ELSE 
               CALL cl_set_comp_entry("rty04",TRUE)  
            END IF    
            
         AFTER FIELD rty04 
            IF NOT cl_null(g_rty[l_ac4].rty04) THEN 
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_rty[l_ac4].rty01 <> g_rty_t.rty01) THEN
                  CALL i100_rty04_desc(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_rty[l_ac4].rty01 = g_rty_t.rty01 
                     NEXT FIELD rty04  
                  END IF 
               END IF 
            END IF 
            IF cl_null(g_rty[l_ac4].rty04) THEN
               LET g_rty[l_ac4].rty04_desc = '' 
            END IF 

            IF cl_null(g_rty[l_ac4].rty04) AND g_rty[l_ac4].rty03 = '3' THEN
              CALL cl_err(g_rty[l_ac4].rty03,'art-994',0)
              NEXT FIELD rty04
            END IF
            
         AFTER FIELD rty05
            IF NOT cl_null(g_rty[l_ac4].rty05) THEN 
               IF g_rty[l_ac4].rty03 MATCHES '[1234]' THEN 
                  IF p_cmd = 'a' OR 
                     (p_cmd = 'u' AND g_rty[l_ac4].rty05 <> g_rty_t.rty05 ) THEN 
                     CALL i100_rty05(p_cmd)
                     IF NOT cl_null(g_errno) THEN 
                        CALL cl_err('',g_errno,0)
                        LET g_rty[l_ac4].rty05 = g_rty_t.rty05 
                        NEXT FIELD rty05 
                     END IF 
                     IF g_rty[l_ac4].rty03 = '3' AND 
                        g_rty[l_ac4].rty06 = '2' THEN
                        CALL cl_err('','art-521',0)
                        LET g_rty[l_ac4].rty05 = g_rty_t.rty05
                        NEXT FIELD rty05 
                     END IF     
                  END IF    
               END IF 
            END IF 
            IF cl_null(g_rty[l_ac4].rty05) THEN
               LET g_rty[l_ac4].rty06 = '' 
            END IF 

         AFTER FIELD rty07
            IF g_rty[l_ac4].rty07<=0 THEN
               CALL cl_err('','art-185',0)
               LET g_rty[l_ac4].rty07 = g_rty_t.rty07
               NEXT FIELD rty07
            END IF

         AFTER FIELD rty08
            IF g_rty[l_ac4].rty08<0 THEN
                CALL cl_err('','art-184',0)
                LET g_rty[l_ac4].rty08 = g_rty_t.rty08
                NEXT FIELD rty08
            END IF

         AFTER FIELD rty09
            IF g_rty[l_ac4].rty09<0 THEN
                CALL cl_err('','art-184',0)
                LET g_rty[l_ac4].rty09 = g_rty_t.rty09
                NEXT FIELD rty09
            END IF   

         AFTER FIELD rty10
            IF NOT cl_null(g_rty[l_ac4].rty10) THEN
               SELECT COUNT(*) INTO l_n 
                 FROM poz_file 
                WHERE poz01 = g_rty[l_ac4].rty10 
                  AND pozacti = 'Y'
               IF l_n = 0 THEN
                  CALL cl_err('','art-217',0)
                  LET g_rty[l_ac4].rty10 = g_rty_t.rty10
                  DISPLAY BY NAME g_rty[l_ac4].rty10
                  NEXT FIELD rty10
               END IF
            END IF

         AFTER FIELD rty11
            IF NOT cl_null(g_rty[l_ac4].rty11) THEN
               SELECT COUNT(*) INTO l_n 
                 FROM poz_file
                WHERE poz01 = g_rty[l_ac4].rty11 
                  AND pozacti = 'Y'
               IF l_n = 0 THEN
                  CALL cl_err('','art-217',0)
                  LET g_rty[l_ac4].rty11 = g_rty_t.rty11
                  NEXT FIELD rty11
               END IF
            END IF 

         BEFORE FIELD rty12
            IF g_rty[l_ac4].rty03 ='2' OR g_rty[l_ac4].rty03='4' THEN
                CALL cl_set_comp_required("rty12",TRUE)
             ELSE
                CALL cl_set_comp_required("rty12",FALSE)
             END IF 

         AFTER FIELD rty12
            IF NOT cl_null(g_rty[l_ac4].rty12) THEN
               IF p_cmd = "a" OR (p_cmd = "u" AND
                  g_rty[l_ac4].rty12 <> g_rty_t.rty12 OR cl_null(g_rty_t.rty12)) THEN
                  CALL i100_rty12_desc(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('rty12:',g_errno,1)
                     LET g_rty[l_ac4].rty12 = g_rty_t.rty12
                     NEXT FIELD rty12
                  ELSE
                     LET g_rty_t.rty12 = g_rty[l_ac4].rty12
                  END IF
               END IF
            END IF
            IF cl_null(g_rty[l_ac4].rty12) THEN
               LET g_rty[l_ac4].rty12_desc=''
            END IF     
         
         BEFORE DELETE                      
            IF NOT cl_null(g_rty_t.rty01) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF      
               
               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "rty01"
               LET g_doc.value1 = g_rty[l_ac4].rty01
               CALL cl_del_doc()
               
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM rty_file WHERE rty01 = g_rty_t.rty01
                                      AND rty02 = g_ima.ima01

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rty_file",g_rty_t.rty03,"",
                                               SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK 
                  CANCEL DELETE 
                  EXIT DIALOG
               END IF
               LET g_rec_b4=g_rec_b4-1
               DISPLAY g_rec_b4 TO FORMONLY.cn2
               COMMIT WORK
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rty[l_ac4].* = g_rty_t.*
               CLOSE i100_bcl_4
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_rty[l_ac4].rty01,-263,0)
               LET g_rty[l_ac4].* = g_rty_t.*
            ELSE
               UPDATE rty_file 
                  SET rty01=g_rty[l_ac4].rty01,
                      rty03=g_rty[l_ac4].rty03,  
                      rty04=g_rty[l_ac4].rty04,
                      rty05=g_rty[l_ac4].rty05,
                      rty06=g_rty[l_ac4].rty06,
                      rty07=g_rty[l_ac4].rty07,
                      rty08=g_rty[l_ac4].rty08,
                      rty10=g_rty[l_ac4].rty10,
                      rty09=g_rty[l_ac4].rty09,
                      rty11=g_rty[l_ac4].rty11,
                      rty12=g_rty[l_ac4].rty12,
                      rty13=g_rty[l_ac4].rty13,
                      rtyacti=g_rty[l_ac4].rtyacti
                WHERE rty01 = g_rty_t.rty01
                  AND rty02 = g_ima.ima01

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rty_file",g_rty_t.rty01,"",
                                               SQLCA.sqlcode,"","",1)
                  LET g_rty[l_ac4].* = g_rty_t.*             
               ELSE
                  MESSAGE 'UPDATE O.K'                                        
                  COMMIT WORK 
               END IF
            END IF
              
         AFTER ROW
            LET l_ac4 = ARR_CURR()            # 新增
           #LET l_ac4_t = l_ac4               # 新增    #FUN-D30033 Mark
                      
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_rty[l_ac4].* = g_rty_t.*
               ELSE
                  CALL g_rty.deleteElement(l_ac4)
                  #FUN-D30033--add--str--
                  IF g_rec_b4 != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac4 = l_ac4_t
                  END IF
                  #FUN-D30033--add--end--
               END IF
               CLOSE i100_bcl_4 
               ROLLBACK WORK  
               EXIT DIALOG
            END IF 
              
            LET l_ac4_t = l_ac4               #FUN-D30033 Add 
            CLOSE i100_bcl_4    
            COMMIT WORK

         AFTER INPUT
            IF g_rec_b4 <> 0 THEN
               FOR l_i = 1 TO g_rec_b4
                  IF cl_null(g_rty[l_i].rty03) THEN
                     CALL cl_err("","art-689",0)
                     NEXT FIELD rty03
                  END IF
               END FOR
               IF cl_null(g_rty[l_ac4].rty03) AND p_cmd = 'a'  THEN
                  NEXT FIELD rty03
               END IF
            END IF
            CLOSE i100_bcl_4
            COMMIT WORK   
               
         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rty01) AND l_ac4 > 1 THEN
               LET g_rty[l_ac4].* = g_rty[l_ac4-1].*
               NEXT FIELD rty01 
            END IF                 
                                   
         ON ACTION controlp                      
            CASE    
               WHEN INFIELD(rty01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azp"
                  LET g_qryparam.where = " azp01 IN ",g_auth CLIPPED
                  IF p_cmd = 'a' THEN
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_multi_rty01
                     IF NOT cl_null(g_multi_rty01) THEN
                        CALL i100_multi_rty01()
                        CALL i100_list_fill()
                        LET g_flag_b = '4'    #TQC-C20270  add
                        CALL i100_b()         #TQC-C20136  add
                        EXIT DIALOG          
                     ELSE
                        NEXT FIELD rty01
                     END IF
                  ELSE
                     CALL cl_create_qry() RETURNING g_rty[l_ac4].rty01
                     NEXT FIELD rty01
                  END IF 

               WHEN INFIELD(rty04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_geu"
                  LET g_qryparam.default1 = g_rty[l_ac4].rty04
                  LET g_qryparam.arg1 = '8'
                  CALL cl_create_qry() RETURNING g_rty[l_ac4].rty04
                  DISPLAY BY NAME g_rty[l_ac4].rty04
                  NEXT FIELD rty04

               WHEN INFIELD(rty05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc2"
                  LET g_qryparam.default1 = g_rty[l_ac4].rty05
                  CALL cl_create_qry() RETURNING g_rty[l_ac4].rty05
                  DISPLAY BY NAME g_rty[l_ac4].rty05
                  NEXT FIELD rty05

               WHEN INFIELD(rty10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_poz01"
                  LET g_qryparam.default1 = g_rty[l_ac4].rty10
                  CALL cl_create_qry() RETURNING g_rty[l_ac4].rty10
                  DISPLAY BY NAME g_rty[l_ac4].rty10
                  NEXT FIELD rty10

               WHEN INFIELD(rty11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_poz01"
                  LET g_qryparam.default1 = g_rty[l_ac4].rty11
                  CALL cl_create_qry() RETURNING g_rty[l_ac4].rty11
                  DISPLAY BY NAME g_rty[l_ac4].rty11
                  NEXT FIELD rty11

               WHEN INFIELD(rty12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_geu"
                  LET g_qryparam.default1 = g_rty[l_ac4].rty12
                  LET g_qryparam.arg1 = '4'
                  CALL cl_create_qry() RETURNING g_rty[l_ac4].rty12
                  DISPLAY BY NAME g_rty[l_ac4].rty12
                  NEXT FIELD rty12
               OTHERWISE EXIT CASE
          END CASE

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            IF p_cmd = 'a' THEN
               CALL g_rty.deleteElement(l_ac4)
            END IF
            EXIT DIALOG

      END INPUT
      #TQC-C20136--start add-------------------------
      BEFORE DIALOG
         CASE g_flag_b
            WHEN '1' 
               NEXT FIELD rta03
            WHEN '2'
               #TQC-C20543--start add----------------  
               IF NOT s_data_center(g_plant) THEN 
                  RETURN
               ELSE
                  NEXT FIELD rte01 
               END IF   
               #TQC-C20543--end add------------------
               #NEXT FIELD rte01   #TQC-C20543 mark
            WHEN '3'
               #TQC-C20543--start add----------------
               IF NOT s_data_center(g_plant) THEN
                  RETURN
               ELSE
                  NEXT FIELD rtg01
               END IF   
               #TQC-C20543--end add------------------
               #NEXT FIELD rtg01    #TQC-C20543 mark
            WHEN '4'
               NEXT FIELD rty01
         END CASE   
      #TQC-C20136--end add-------------------------- 

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                                   RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END DIALOG 
          
   CLOSE i100_bcl_1
   CLOSE i100_bcl_2
   CLOSE i100_bcl_3
   CLOSE i100_bcl_4
   COMMIT WORK
END FUNCTION 

FUNCTION i100_rta03_desc(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_gfeacti    LIKE gfe_file.gfeacti
   DEFINE l_gfe02      LIKE gfe_file.gfe02

   LET g_errno = ''

   SELECT gfeacti,gfe02 INTO l_gfeacti,l_gfe02
     FROM gfe_file
    WHERE gfe01 = g_rta[l_ac1].rta03

   CASE 
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'art-066'
      WHEN l_gfeacti = 'N'
         LET g_errno = '9028'
      OTHERWISE 
         LET g_errno = SQLCA.SQLCODE USING '----------'
   END CASE  

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_rta[l_ac1].rta03_desc = l_gfe02 
   END IF 
END FUNCTION 

FUNCTION i100_rta05()
   DEFINE l_n         LIKE type_file.num10
   DEFINE l_length    LIKE type_file.num10
   DEFINE l_i         LIKE type_file.num10

   LET g_errno = ''
   LET l_length = LENGTH(g_rta[l_ac1].rta05)
   IF g_rta[l_ac1].rta04 = '2' THEN RETURN END IF
   IF l_length = 12 OR l_length = 7 THEN
      FOR l_n=1 TO l_length
         IF g_rta[l_ac1].rta05[l_n] NOT MATCHES "[0-9]" THEN
            LET g_errno = 'art-015'
            RETURN
         END IF
      END FOR
   ELSE
      IF l_length = 13 OR l_length = 8 THEN
         FOR l_i=1 TO l_length
            IF g_rta[l_ac1].rta05[l_i] NOT MATCHES "[0-9]" THEN
               LET g_errno = 'art-015'
               RETURN
            END IF
         END FOR
         CALL i100_chk_code()
      ELSE
         LET g_errno = 'art-015'
         RETURN
      END IF
   END IF
END FUNCTION 

FUNCTION i100_chk_code()
   DEFINE l_length      LIKE  type_file.num5
   DEFINE l_i           LIKE  type_file.num5
   DEFINE l_mod         LIKE  type_file.num5
   DEFINE l_num1        LIKE  type_file.num5
   DEFINE l_num2        LIKE  type_file.num5
   DEFINE l_total       LIKE  type_file.num5
   DEFINE l_result      LIKE  type_file.num5
   DEFINE l_temp        STRING
   DEFINE l_rta05       LIKE  rta_file.rta05

   LET l_temp = g_rta[l_ac1].rta05
   LET l_temp = l_temp.trim()
   LET g_rta[l_ac1].rta05 = l_temp
   LET l_length = LENGTH(g_rta[l_ac1].rta05)
   LET l_temp = ''
   LET g_errno = ' '
   FOR l_i=1 TO l_length-1
      LET l_temp = l_temp,g_rta[l_ac1].rta05[l_i]
   END FOR

   CALL i100_create_code(l_temp) RETURNING l_num1
   LET l_num2 = g_rta[l_ac1].rta05[l_length]
   IF l_num1 != l_num2 THEN
      LET g_errno = 'art-017'
      RETURN
   END IF
END FUNCTION

FUNCTION i100_create_code(p_code)
   DEFINE l_length      LIKE  type_file.num5
   DEFINE l_i           LIKE  type_file.num5
   DEFINE l_mod         LIKE  type_file.num5
   DEFINE l_num1        LIKE  type_file.num5
   DEFINE l_num2        LIKE  type_file.num5
   DEFINE l_total       LIKE  type_file.num5
   DEFINE l_result      LIKE  type_file.num5
   DEFINE l_temp        STRING
   DEFINE p_code        LIKE  type_file.chr1000

   LET l_length = LENGTH(p_code)
   LET l_num1 = 0
   LET l_num2 = 0
   FOR l_i=1 TO l_length
      LET l_mod = l_i MOD 2
      IF l_mod = 0 THEN
         LET l_num2 = l_num2 + p_code[l_i]
      ELSE
         LET l_num1 = l_num1 + p_code[l_i]
      END IF
   END FOR

   LET l_total = l_num1 + l_num2*3
   LET l_result = 10 - (l_total MOD 10)
   IF l_result = 10 THEN
      LET l_result = 0
   END IF
   LET l_temp = l_result
   LET l_temp = l_temp.trim()

   LET l_result = l_temp
   RETURN l_result
END FUNCTION

FUNCTION i100_chk_repeat()
   DEFINE  l_n             LIKE type_file.num5
 
  #FUN-D40001-----Mark&Add----Str 
  #SELECT COUNT(*) INTO l_n FROM rta_file
  #   WHERE rta05=g_rta[l_ac1].rta05
   SELECT COUNT(*) INTO l_n FROM rta_file
    WHERE rta01=g_ima.ima01
      AND rta05=g_rta[l_ac1].rta05
  #FUN-D40001-----Mark&Add----End
   IF l_n > 0 THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

#FUN-D40001-----Add----Str
FUNCTION i100_chk_repeat1()
   DEFINE  l_n             LIKE type_file.num5

   SELECT COUNT(*) INTO l_n FROM rta_file
    WHERE rta01<>g_ima.ima01
      AND rta05=g_rta[l_ac1].rta05
      AND rtaacti = 'Y'
   IF l_n > 0 THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40001-----Add----End

#TQC-C20136--start add--------------------------
FUNCTION i100_rte01_1() 
   DEFINE l_rtd03           LIKE rtd_file.rtd03
   DEFINE l_rtdacti         LIKE rtd_file.rtdacti
   DEFINE l_rtdconf         LIKE rtd_file.rtdconf

   LET g_errno = ''
   SELECT count(*) INTO g_cnt
     FROM rtd_file
    WHERE rtd01 = g_rte[l_ac2].rte01
  
   IF g_cnt >0 THEN
      SELECT rtd03 INTO l_rtd03
        FROM rtd_file
       WHERE rtd01 = g_rte[l_ac2].rte01
      IF NOT cl_null (l_rtd03) THEN
         IF l_rtd03 <> g_plant THEN
            LET g_errno = 'art1028'
            RETURN
         END IF
      END IF
   END IF 
   SELECT rtdacti,rtdconf INTO l_rtdacti,l_rtdconf
     FROM rtd_file
    WHERE rtd01 = g_rte[l_ac2].rte01

   CASE
      WHEN l_rtdacti = 'N'
         LET g_errno = 'art1031'
      WHEN l_rtdconf <> 'Y'
         LET g_errno = 'art1032'
   END CASE
END FUNCTION
#TQC-C20136--end add----------------------------

FUNCTION i100_rte01()
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_rtd     RECORD LIKE rtd_file.*
   DEFINE l_rtd03          LIKE rtd_file.rtd03
   DEFINE l_rtdacti        LIKE rtd_file.rtdacti
   DEFINE l_rtdconf        LIKE rtd_file.rtdconf

   LET g_errno = ''
   SELECT COUNT(*) INTO l_n
     FROM rtd_file
    WHERE rtd01 = g_rte[l_ac2].rte01

   IF cl_null(l_n) THEN LET l_n = 0 END IF 

   IF l_n = 0 THEN 
      IF cl_confirm('art1030') THEN
        #TQC-C20136 Add Begin ---
         OPEN WINDOW i100_rte_w WITH FORM "art/42f/arti100_rte"
              ATTRIBUTE(STYLE=g_win_style CLIPPED)
         CALL cl_ui_locale("arti100_rte")
         LET l_rtd.rtd01 = g_rte[l_ac2].rte01
         DISPLAY BY NAME l_rtd.rtd01
         INPUT BY NAME l_rtd.rtd01,l_rtd.rtd02,l_rtd.rtd05 WITHOUT DEFAULTS
            AFTER INPUT
               IF INT_FLAG THEN
                  EXIT INPUT
               END IF

            ON ACTION CONTROLG
               CALL cl_cmdask()

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()
         END INPUT
         CLOSE WINDOW i100_rte_w
         IF INT_FLAG THEN LET INT_FLAG = 0 LET g_errno = '9001' RETURN END IF
        #TQC-C20136 Add Begin -----

         LET l_rtd.rtd03 = g_plant
         LET l_rtd.rtdacti = 'Y'
         LET l_rtd.rtdcond = g_today
         LET l_rtd.rtdconf = 'Y'
         LET l_rtd.rtdconu = g_user
         LET l_rtd.rtdcrat = g_today
         LET l_rtd.rtddate = g_today
         LET l_rtd.rtdgrup = g_grup
         LET l_rtd.rtduser = g_user
         LET l_rtd.rtdoriu = g_user
         LET l_rtd.rtdorig = g_grup
         INSERT INTO rtd_file VALUES l_rtd.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","rtd_file",g_rte[l_ac2].rte01,"",SQLCA.sqlcode,"","",1)
            LET g_errno = '9001'
            RETURN
         END IF
         RETURN 
      ELSE
         LET g_errno = 100
      END IF 
   ELSE 
      SELECT rtd03 INTO l_rtd03 
        FROM rtd_file
       WHERE rtd01 = g_rte[l_ac2].rte01
      IF NOT cl_null (l_rtd03) THEN 
         IF l_rtd03 <> g_plant THEN 
            LET g_errno = 'art1028'
            RETURN 
         END IF 
      END IF 
      SELECT rtdacti,rtdconf INTO l_rtdacti,l_rtdconf
        FROM rtd_file
       WHERE rtd01 = g_rte[l_ac2].rte01

      CASE 
         WHEN l_rtdacti = 'N'
            LET g_errno = 'art1031'
         WHEN l_rtdconf <> 'Y'
            LET g_errno = 'art1032' 
      END CASE   
   END IF
END FUNCTION 

FUNCTION i100_rte08(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gec02   LIKE gec_file.gec02
   DEFINE l_gecacti LIKE gec_file.gecacti
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_count1  LIKE type_file.num5
   DEFINE l_count2  LIKE type_file.num5
   DEFINE l_rvy03   LIKE rvy_file.rvy03
   DEFINE l_rte02   LIKE rte_file.rte02
   DEFINE l_gec07_n LIKE type_file.num5 #TQC-C20357 Add

   LET g_errno = " "
   LET l_flag = 'N'
   SELECT gec02 ,gecacti INTO l_gec02,l_gecacti 
     FROM gec_file
    WHERE gec01 = g_rte[l_ac2].rte08 
      AND gec011 = '2'
      
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'art-931'
      WHEN l_gecacti = 'N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

  #TQC-C20357 Add Begin ---
#MOD-C30653 mark begin ----
#   IF cl_null(g_errno) THEN
#      LET l_gec07_n = 0
#      IF p_cmd = 'a' THEN 
#         SELECT COUNT(DISTINCT gec07) INTO l_gec07_n
#           FROM gec_file 
#          WHERE (gec01 IN (SELECT rvy04 
#                             FROM rvy_file 
#                            WHERE rvy01 = g_rte[l_ac2].rte01)
#             OR gec01 = g_rte[l_ac2].rte08)
#            AND gec011 = '2'
#      ELSE
#         SELECT COUNT(DISTINCT gec07) INTO l_gec07_n
#           FROM gec_file 
#          WHERE (gec01 IN (SELECT rvy04 
#                             FROM rvy_file 
#                            WHERE rvy01 = g_rte[l_ac2].rte01  
#                              AND rvy02 <> g_rte_t.rte02 
#                              AND rvy04 <> g_rte_t.rte08)
#             OR gec01 = g_rte[l_ac2].rte08)
#            AND gec011 = '2'
#      END IF
#      IF l_gec07_n > 1 THEN
#         LET g_errno = 'art1039'
#      END IF
#   END IF
#MOD-C30653 mark end ----
  #TQC-C20357 Add End -----
   
   IF cl_null(g_errno) THEN
      LET g_rte[l_ac2].taxtype = l_gec02

      SELECT COUNT(*) INTO l_count 
        FROM rvy_file
       WHERE rvy01 = g_rte[l_ac2].rte01 
         AND rvy02 = g_rte[l_ac2].rte02 
         AND rvy04 = g_rte[l_ac2].rte08
         
     SELECT COUNT(*) INTO l_count1 
       FROM  rvy_file
       WHERE rvy01 = g_rte[l_ac2].rte01 
         AND rvy02 = g_rte[l_ac2].rte02 
         AND rvy04 = g_rte_t.rte08
         
     SELECT COUNT(rvy03) INTO l_count2 
       FROM rvy_file
      WHERE rvy01 = g_rte[l_ac2].rte01
        AND rvy02 = g_rte[l_ac2].rte02
        
     IF l_count2 = 0 THEN
        LET l_rvy03 = 1
     ELSE
        SELECT MAX(rvy03)+1 INTO l_rvy03 
          FROM rvy_file
         WHERE rvy01 = g_rte[l_ac2].rte01
           AND rvy02 = g_rte[l_ac2].rte02
     END IF
     
     IF l_count1 >0 THEN
        IF  g_rte[l_ac2].rte08 != g_rte_t.rte08 THEN
            IF cl_confirm('art-932') THEN  
               DELETE FROM  rvy_file  
                     WHERE rvy01 = g_rte[l_ac2].rte01
                       AND rvy02 = g_rte[l_ac2].rte02
                       AND rvy04 = g_rte_t.rte08
            ELSE
               LET g_rte[l_ac2].rte08 = g_rte_t.rte08
               LET  g_errno = '9001'
               RETURN
            END IF
        END IF
        LET l_flag = 'Y'
     END IF
     IF l_count = 0 THEN
        INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvygrup,rvyorig,
                             rvyoriu,rvyuser)
        VALUES(g_rte[l_ac2].rte01,g_rte[l_ac2].rte02,l_rvy03,g_rte[l_ac2].rte08,'2'
                    ,g_grup,g_grup,g_user,g_user)
         LET l_flag = 'Y' 
      END IF
   ELSE
      CALL cl_err('',g_errno,0)
      LET g_rte[l_ac2].rte08 = g_rte_t.rte08
   END IF
END FUNCTION 

#TQC-C20136--start add--------------------------
FUNCTION i100_detail()
   DEFINE l_sql       STRING 

   IF cl_null(l_ac2) OR l_ac2 = 0 THEN LET l_ac2 = '1' END IF   #FUN-C30306 add
   IF cl_null(g_rte[l_ac2].rte01) THEN RETURN END IF

   DECLARE i100_rvy_curs2 CURSOR FOR
      SELECT rvy02,'','',rvy03,rvy04,'','',rvy06
        FROM rvy_file
       WHERE rvy01 = g_rte[l_ac2].rte01
         AND rvy02 = g_rte[l_ac2].rte02
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare i100_rvy_curs2',SQLCA.sqlcode,1)
      RETURN
   END IF

   CALL g_rvy.clear()
   LET g_cnt = 1

   FOREACH i100_rvy_curs2 INTO g_rvy[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach i100_rvy_curs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_rvy[g_cnt].rte03 = g_ima.ima01
      LET g_rvy[g_cnt].rte03_n = g_ima.ima02
      SELECT gec02,gec04 INTO g_rvy[g_cnt].gec02,g_rvy[g_cnt].gec04
        FROM gec_file
       WHERE gec01 = g_rvy[g_cnt].rvy04
         AND gec011 = '2'

   LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_rvy.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1  

   OPEN WINDOW i120_a_w WITH FORM "art/42f/arti120_a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("arti120_a")
   DISPLAY g_cnt TO FORMONLY.cnt
   DISPLAY ARRAY g_rvy TO s_rvy.* ATTRIBUTE(COUNT=g_cnt)
   #END DISPLAY  
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i120_a_w    
   END IF 
   CLOSE WINDOW i120_a_w
END FUNCTION
#TQC-C20136--end add----------------------------

FUNCTION i100_a_rvy(l_t)
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_rvyk_sw       LIKE type_file.chr1
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE  p_cmd          LIKE type_file.chr1
   DEFINE  l_t            LIKE type_file.chr1
   DEFINE l_gecacti       LIKE gec_file.gecacti
   DEFINE l_rte02         LIKE rte_file.rte02

   LET l_ac1 =1

   IF cl_null(g_rte[l_ac2].rte01) THEN RETURN END IF
   IF g_cmd = 'a' OR g_cmd = 'u' THEN

      DECLARE i100_rvy_curs CURSOR FOR
         SELECT rvy02,'','',rvy03,rvy04,'','',rvy06 
           FROM rvy_file
          WHERE rvy01 = g_rte[l_ac2].rte01 
            AND rvy02 = g_rte[l_ac2].rte02
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare i100_rvy_curs',SQLCA.sqlcode,1)
         RETURN
      END IF
      
      CALL g_rvy.clear()
      LET g_cnt = 1
      
      FOREACH i100_rvy_curs INTO g_rvy[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach i100_rvy_curs',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         
         LET g_rvy[g_cnt].rte03 = g_ima.ima01
         LET g_rvy[g_cnt].rte03_n = g_ima.ima02
         SELECT gec02,gec04 INTO g_rvy[g_cnt].gec02,g_rvy[g_cnt].gec04
           FROM gec_file
          WHERE gec01 = g_rvy[g_cnt].rvy04 
            AND gec011 = '2'
          
      LET g_cnt = g_cnt + 1
      END FOREACH
      CALL g_rvy.deleteElement(g_cnt)
      LET g_cnt = g_cnt - 1
   ELSE
      DECLARE i100_rvy_curs1 CURSOR FOR
         SELECT rvy02,'','',rvy03,rvy04,'','',rvy06
           FROM rvy_file
          WHERE rvy01 = g_rte[l_ac2].rte01
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare i100_rvy_curs1',SQLCA.sqlcode,1)
         RETURN
      END IF
      
      CALL g_rvy.clear()
      LET g_cnt = 1
      
      FOREACH i100_rvy_curs1 INTO g_rvy[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach i100_rvy_curs1',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_rvy[g_cnt].rte03 = g_ima.ima01
         LET g_rvy[g_cnt].rte03_n = g_ima.ima02
         
         SELECT gec02,gec04 INTO g_rvy[g_cnt].gec02,g_rvy[g_cnt].gec04 
           FROM gec_file
          WHERE gec01 = g_rvy[g_cnt].rvy04 
            AND gec011 = '2'
     LET g_cnt = g_cnt + 1
     END FOREACH
     CALL g_rvy.deleteElement(g_cnt)
     LET g_cnt = g_cnt - 1
   END IF

   OPEN WINDOW i120_a_w WITH FORM "art/42f/arti120_a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("arti120_a")
   DISPLAY g_cnt TO FORMONLY.cnt
   DISPLAY ARRAY g_rvy TO s_rvy.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
      
   LET g_forupd_sql = " SELECT rvy02,'','',rvy03,rvy04,'','',rvy06 ",         
                      "   FROM rvy_file ",
                      "  WHERE rvy01 = '",g_rte[l_ac2].rte01,"'",
                      "    AND rvy02 = ? AND rvy03 = ?",
                      "    FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_rvy_bcl CURSOR FROM g_forupd_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare i100_rvy_bcl',SQLCA.sqlcode,1)
      CLOSE WINDOW i120_a_w
      RETURN
   END IF

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_rvy WITHOUT DEFAULTS FROM s_rvy.*
         ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_cnt != 0 THEN
            CALL fgl_set_arr_curr(l_ac5)
         END IF
      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         LET g_rvyk_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF l_t = 'N' THEN
            OPEN i100_cl USING g_ima.ima01
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            FETCH i100_cl INTO g_ima.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   # 資料被他人lnvK
               CLOSE i100_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
         END IF
         IF g_cnt >= l_ac5 THEN
            LET p_cmd = 'u'
            LET g_rvy_t.* = g_rvy[l_ac5].*
            OPEN i100_rvy_bcl USING  g_rvy_t.rvy02,g_rvy_t.rvy03
            IF STATUS THEN
               CALL cl_err("OPEN i100_rvy_bcl:", STATUS, 1)
               LET g_rvyk_sw = "Y"
            END IF
            FETCH i100_rvy_bcl INTO g_rvy[l_ac5].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rvy_t.rvy02,SQLCA.sqlcode,1)
               LET g_rvyk_sw = "Y"
            END IF
            LET g_rvy[l_ac5].rte03 = g_ima.ima01
            LET g_rvy[l_ac5].rte03_n = g_ima.ima02             
 
            SELECT gec02,gec04 INTO g_rvy[l_ac5].gec02,g_rvy[l_ac5].gec04 
              FROM gec_file
             WHERE gec01 = g_rvy[l_ac5].rvy04 
               AND gec011 = '2'
            LET g_before_input_done = FALSE
            CALL i100_rvy_set_entry_b()
            CALL i100_rvy_set_no_entry_b()
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

          BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             INITIALIZE g_rvy[l_ac5].* TO NULL
             IF g_cmd='a' OR g_cmd = 'u' THEN
                #LET g_rvy[l_ac5].rvy02 = l_rte02
                LET g_rvy[l_ac5].rvy02 = g_rte[l_ac2].rte02 
                LET g_rvy[l_ac5].rte03 = g_ima.ima01
                LET g_rvy[l_ac5].rte03_n = g_ima.ima02
                
                CALL cl_set_comp_entry("rvy02",FALSE)
                SELECT COUNT(rvy03) INTO l_cnt 
                  FROM rvy_file
                 WHERE rvy01 = g_rte[l_ac2].rte01
                   #AND rvy02 = l_rte02
                   AND rvy02 = g_rte[l_ac2].rte02
                IF l_cnt = 0 THEN
                   LET g_rvy[l_ac5].rvy03 = 1
                ELSE
                   SELECT MAX(rvy03)+1 INTO g_rvy[l_ac5].rvy03 
                     FROM rvy_file
                    WHERE rvy01 =  g_rte[l_ac2].rte01
                      AND rvy02 =  g_rte[l_ac2].rte02
                END IF
                LET g_rvy[l_ac5].rvy06 = '0'
             END IF
             LET g_rvy_t.* = g_rvy[l_ac5].*
             LET g_before_input_done = FALSE
             CALL i100_rvy_set_entry_b()
             CALL i100_rvy_set_no_entry_b()
             LET g_before_input_done = TRUE
             CALL cl_show_fld_cont()
             NEXT FIELD rvy02

          AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                CANCEL INSERT
             END IF
            #FUN-D30050--add--str---
             CALL i100_chk_tax(g_ima.ima01,g_rvy[l_ac5].rvy04)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ima.ima01,g_errno,1)
                CANCEL INSERT
             ELSE
                IF g_lpx38 = 'N' AND NOT cl_null(g_rvy[l_ac5].rvy06) THEN
                   IF g_rvy[l_ac5].rvy06 != 0 THEN
                      CALL cl_err(g_ima.ima01,'art1131',1)
                      CANCEL INSERT
                   END IF
                END IF
             END IF
            #FUN-D30050--add--end---
             INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvy06,rvygrup,rvyorig,rvyoriu,rvyuser)
             VALUES (g_rte[l_ac2].rte01,g_rvy[l_ac5].rvy02,g_rvy[l_ac5].rvy03,
                     g_rvy[l_ac5].rvy04,'2',g_rvy[l_ac5].rvy06,g_grup,g_grup,g_user,g_user)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rvy_file",g_rte[l_ac2].rte01,g_rvy[l_ac5].rvy02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                IF l_t = 'N' THEN
                   COMMIT WORK
                END IF
                LET g_cnt = g_cnt + 1
                DISPLAY g_cnt TO FORMONLY.cnt
             END IF
             
          AFTER FIELD rvy02
             IF g_cmd = 'a' OR g_cmd = 'u' THEN
             ELSE
                IF p_cmd = 'a' THEN
                   LET g_rvy[l_ac5].rte03 = g_ima.ima01
                   LET g_rvy[l_ac5].rte03 = g_ima.ima01        
                   SELECT COUNT(rvy03) INTO l_cnt FROM rvy_file
                    WHERE rvy01 =  g_rte[l_ac2].rte01
                      AND rvy02 =  g_rvy[l_ac5].rvy02
                    IF l_cnt = 0 THEN
                       LET g_rvy[l_ac5].rvy03 = 1
                    ELSE
                       SELECT MAX(rvy03)+1 INTO g_rvy[l_ac5].rvy03 FROM rvy_file
                        WHERE rvy01 = g_rte[l_ac2].rte01
                         AND rvy02 =  g_rvy[l_ac5].rvy02
                    END IF
                END IF                                  
             END IF
               
          AFTER FIELD rvy03
             IF NOT cl_null(g_rvy[l_ac5].rvy03) THEN
                IF g_rvy[l_ac5].rvy03 != g_rvy_t.rvy03 OR
                   g_rvy_t.rvy03 IS NULL THEN
                   SELECT COUNT(*) INTO l_cnt FROM rvy_file
                    WHERE rvy01 = g_rte[l_ac2].rte01
                      AND rvy02 = g_rvy[l_ac5].rvy02
                      AND rvy03 = g_rvy[l_ac5].rvy03
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_rvy[l_ac5].rvy03,'art-934',0)
                      LET g_rvy[l_ac5].rvy03 = g_rvy_t.rvy03
                      NEXT FIELD rvy03
                   END IF
                END IF
             END IF

          AFTER FIELD rvy04
             IF NOT cl_null(g_rvy[l_ac5].rvy04) THEN
                IF g_rvy[l_ac5].rvy04 != g_rvy_t.rvy04 OR
                   g_rvy_t.rvy04 IS NULL THEN
                   SELECT gecacti INTO l_gecacti FROM gec_file
                    WHERE gec01 = g_rvy[l_ac5].rvy04
                      AND gec011 = '2'
                   IF STATUS = 100 THEN
                      CALL cl_err(g_rvy[l_ac5].rvy04,'art-931',0)
                      LET g_rvy[l_ac5].rvy04 = g_rvy_t.rvy04
                      NEXT FIELD rvy04
                   ELSE
                      IF l_gecacti = 'N' THEN
                         CALL cl_err('','9028',0)
                         LET g_rvy[l_ac5].rvy04 = g_rvy_t.rvy04
                         NEXT FIELD rvy04
                      END IF
                      SELECT COUNT(*) INTO l_cnt FROM rvy_file
                       WHERE rvy01 = g_rte[l_ac2].rte01
                         AND rvy02 = g_rvy[l_ac5].rvy02
                         AND rvy04 = g_rvy[l_ac5].rvy04
                        
                      IF l_cnt >0 THEN
                        CALL cl_err(g_rvy[l_ac5].rvy04,'art-935',0)
                        LET g_rvy[l_ac5].rvy04 = g_rvy_t.rvy04
                        NEXT FIELD rvy04
                      ELSE
                         IF NOT i100_chk_gec07(p_cmd) THEN NEXT FIELD rvy04 END IF #TQC-C20357 Add
                         SELECT gec02,gec04 INTO g_rvy[l_ac5].gec02,g_rvy[l_ac5].gec04
                           FROM gec_file
                          WHERE gec01 = g_rvy[l_ac5].rvy04
                            AND gec011 = '2'
                      END IF
                   END IF
                  #FUN-D30050--add--str---
                   CALL i100_chk_tax(g_ima.ima01,g_rvy[l_ac5].rvy04)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_ima.ima01,g_errno,1)
                      LET g_rvy[l_ac5].rvy04 = g_rvy_t.rvy04
                      NEXT FIELD rvy04
                   ELSE
                      IF g_lpx38 = 'N' AND NOT cl_null(g_rvy[l_ac5].rvy06) THEN
                         IF g_rvy[l_ac5].rvy06 != 0 THEN
                            CALL cl_err(g_ima.ima01,'art1131',1) 
                            LET g_rvy[l_ac5].rvy04 = g_rvy_t.rvy04
                            NEXT FIELD rvy04
                         END IF
                      END IF
                   END IF
                  #FUN-D30050--add--end---
                END IF
             END IF

          AFTER FIELD rvy06
             IF g_rvy[l_ac5].rvy06 < 0 OR cl_null(g_rvy[l_ac5].rvy06) THEN
                CALL cl_err('','art-939',0)
                NEXT FIELD rvy06
             END IF
            #FUN-D30050--add--str---
             INITIALIZE g_lpx38 TO NULL
             SELECT lpx38 INTO g_lpx38 FROM lpx_file WHERE lpx32 = g_ima.ima01 
             IF g_lpx38 = 'N' THEN
                IF g_rvy[l_ac5].rvy06 != 0 THEN
                   CALL cl_err(g_ima.ima01,'art1131',1)
                   NEXT FIELD rvy06
                END IF
             END IF
            #FUN-D30050--add--end---

          BEFORE DELETE
             SELECT COUNT(*) INTO l_cnt FROM rte_file
              WHERE rte01 = g_rte[l_ac2].rte01
                AND rte02 = g_rvy[l_ac5].rvy02
                AND rte08 = g_rvy[l_ac5].rvy04
             IF g_cmd <> 'a' AND g_cmd <>'u' AND l_cnt>0 THEN
                 CALL cl_err('','art1038',0)
                 CANCEL DELETE
             END IF
             IF g_rvy[l_ac5].rvy04 = g_rte[l_ac2].rte08 AND (g_cmd = 'a' OR g_cmd = 'u') THEN
                 CALL cl_err('','art1038',0)
                 CANCEL DELETE
             END IF
             IF g_rvyk_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             IF cl_confirm('lib-001') THEN
                DELETE FROM rvy_file
                 WHERE rvy01 = g_rte[l_ac2].rte01
                   AND rvy02 =  g_rvy[l_ac5].rvy02
                   AND rvy03 =  g_rvy[l_ac5].rvy03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rvy_file",g_rte[l_ac2].rte01,g_rvy[l_ac5].rvy02,SQLCA.sqlcode,"","",1)
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
                LET g_rvy[l_ac5].* = g_rvy_t.*
                CLOSE i100_rvy_bcl
                IF l_t = 'N' THEN
                   ROLLBACK WORK
                END IF
                EXIT INPUT
             END IF
             IF g_rvyk_sw = 'Y' THEN
                CALL cl_err(g_rvy[l_ac5].rvy03,-263,1)
                LET g_rvy[l_ac5].* = g_rvy_t.*
             ELSE
                UPDATE rvy_file
                   SET rvy01 = g_rte[l_ac2].rte01,
                       rvy02 = g_rvy[l_ac5].rvy02,
                       rvy03 = g_rvy[l_ac5].rvy03,
                       rvy04 = g_rvy[l_ac5].rvy04,
                       rvy05 = '2',
                       rvy06 = g_rvy[l_ac5].rvy06,
                       rvydate = g_today,
                       rvymodu = g_user
                 WHERE rvy01 = g_rte[l_ac2].rte01
                   AND rvy02 = g_rvy[l_ac5].rvy02
                   AND rvy03 = g_rvy_t.rvy03
                 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","rvy_file",g_rte[l_ac2].rte01,g_rvy[l_ac5].rvy02,SQLCA.sqlcode,'','',1)
                   LET g_rvy[l_ac5].* = g_rvy_t.*
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
             LET l_ac1 = ARR_CURR()
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET g_rvy[l_ac5].* = g_rvy_t.*
                CLOSE i100_rvy_bcl
                IF l_t = 'N' THEN
                   ROLLBACK WORK
                END IF
                EXIT INPUT
             END IF
             CLOSE i100_rvy_bcl
             IF l_t = 'N' THEN
                COMMIT WORK
             END IF
             
          ON ACTION controlp
             CASE
                WHEN INFIELD(rvy04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gec011"
                      LET g_qryparam.default1 = g_rvy[l_ac5].rvy04
                      CALL cl_create_qry() RETURNING g_rvy[l_ac5].rvy04
                      DISPLAY BY NAME g_rvy[l_ac5].rvy04
                     NEXT FIELD rvy04
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
      CLOSE WINDOW i120_a_w    #TQC-C20136
      CALL cl_err('',9001,0)
   END IF
   CLOSE i100_cl #TQC-C20270 Add
   CLOSE i100_rvy_bcl
   IF l_t = 'N' THEN
      COMMIT WORK
   END IF
   CLOSE WINDOW i120_a_w
END FUNCTION
                        
FUNCTION i100_rtg01()
   DEFINE l_rtfacti        LIKE rtf_file.rtfacti
   DEFINE l_rtfconf        LIKE rtf_file.rtfconf
   DEFINE l_rtf     RECORD LIKE rtf_file.*
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_rtf03          LIKE rtf_file.rtf03  

   LET g_errno = ''

   SELECT COUNT(*) INTO l_n 
     FROM rtf_file
    WHERE rtf01 = g_rtg[l_ac3].rtg01

   IF cl_null(l_n) THEN LET l_n = 0 END IF 
 
   IF l_n = 0 THEN 
      IF cl_confirm('art1030') THEN 
        #FUN-D30047 Add Begin ---
         OPEN WINDOW i100_rtf_w WITH FORM "art/42f/arti100_rtf"
              ATTRIBUTE(STYLE=g_win_style CLIPPED)
         CALL cl_ui_locale("arti100_rtf")
         LET l_rtf.rtf01 = g_rtg[l_ac3].rtg01
         DISPLAY BY NAME l_rtf.rtf01
         INPUT BY NAME l_rtf.rtf01,l_rtf.rtf02,l_rtf.rtf05 WITHOUT DEFAULTS
            AFTER INPUT
               IF INT_FLAG THEN
                  EXIT INPUT
               END IF

            ON ACTION CONTROLG
               CALL cl_cmdask()

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT

            ON ACTION about
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()
         END INPUT
         CLOSE WINDOW i100_rtf_w
         IF INT_FLAG THEN LET INT_FLAG = 0 LET g_errno = '9001' RETURN END IF
        #FUN-D30047 Add End -----         
         #LET l_rtf.rtf01 = g_rtg[l_ac3].rtg01
         LET l_rtf.rtf03 = g_plant
         LET l_rtf.rtfacti = 'Y'
         LET l_rtf.rtfcond = g_today
         LET l_rtf.rtfconf = 'Y'
         LET l_rtf.rtfconu = g_user
         LET l_rtf.rtfcrat = g_today
         LET l_rtf.rtfdate = g_today
         LET l_rtf.rtfgrup = g_grup
         LET l_rtf.rtfuser = g_user
         LET l_rtf.rtforiu = g_user
         LET l_rtf.rtforig = g_grup
         INSERT INTO rtf_file VALUES l_rtf.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","rtf_file",g_rtg[l_ac3].rtg01,"",SQLCA.sqlcode,"","",1)
            LET g_errno = ''
            RETURN
         END IF
         RETURN 
      ELSE
         LET g_errno = 100
      END IF 
   ELSE
      SELECT rtf03 INTO l_rtf03
        FROM rtf_file
       WHERE rtf01 = g_rtg[l_ac3].rtg01
      IF NOT cl_null(l_rtf03) THEN
         IF l_rtf03 <> g_plant THEN 
            LET g_errno = 'art1028'
            RETURN 
         END IF 
      END IF 
      SELECT rtfacti,rtfconf INTO l_rtfacti,l_rtfconf
        FROM rtf_file
       WHERE rtf01 = g_rtg[l_ac3].rtg01

      CASE
         WHEN SQLCA.sqlcode = 100
            LET g_errno = 'art-902'
         WHEN l_rtfacti = 'N'
            LET g_errno = 'art-945'
         WHEN l_rtfconf = 'N'
            LET g_errno = 'atm-140'
         OTHERWISE
      END CASE 
   END IF 
END FUNCTION  

#TQC-C20136--start add-----------------------
FUNCTION i100_rtg01_1()
   DEFINE l_rtfacti        LIKE rtf_file.rtfacti
   DEFINE l_rtfconf        LIKE rtf_file.rtfconf
   DEFINE l_rtf03          LIKE rtf_file.rtf03

   LET g_errno = ''

   SELECT COUNT(*) INTO g_cnt
     FROM rtf_file
    WHERE rtf01 = g_rtg[l_ac3].rtg01

   IF g_cnt > 0 THEN
      SELECT rtf03 INTO l_rtf03
        FROM rtf_file
       WHERE rtf01 = g_rtg[l_ac3].rtg01
      IF NOT cl_null(l_rtf03) THEN
         IF l_rtf03 <> g_plant THEN
            LET g_errno = 'art1028'
            RETURN
         END IF
      END IF
   END IF 

   SELECT rtfacti,rtfconf INTO l_rtfacti,l_rtfconf
     FROM rtf_file
    WHERE rtf01 = g_rtg[l_ac3].rtg01

   CASE
     #TQC-C20357 Mark Begin ---
     #WHEN SQLCA.sqlcode = 100
     #   LET g_errno = 'art-902'
     #TQC-C20357 Mark End -----
      WHEN l_rtfacti = 'N'
         LET g_errno = 'art-945'
      WHEN l_rtfconf = 'N'
         LET g_errno = 'atm-140'
      OTHERWISE
   END CASE
END FUNCTION 
#TQC-C20136--end  add------------------------

FUNCTION i100_rtg01_chk()
   DEFINE l_n       LIKE type_file.num10

   LET g_errno = ''
   SELECT count(*) INTO l_n 
     FROM rtg_file
    WHERE rtg01 = g_rtg[l_ac3].rtg01 
      AND rtg03 = g_ima.ima01
      AND rtg04 = g_rtg[l_ac3].rtg04

   IF l_n > 0 THEN 
      LET g_errno = 'alm1486'
   END IF    
END FUNCTION 

FUNCTION i100_rtg04()
   DEFINE l_gfeacti       LIKE gfe_file.gfeacti 

   LET g_errno = ''
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_rtg[l_ac3].rtg04

   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'art-061'
      WHEN l_gfeacti = 'N'
         LET g_errno = '9028'
      OTHERWISE 
         LET g_errno = SQLCA.sqlcode USING '----------'   
   END CASE  
END FUNCTION 

FUNCTION i100_chk_rtg03()
   DEFINE  l_n  LIKE  type_file.num10

   SELECT COUNT(*) INTO l_n 
     FROM rtg_file
    WHERE rtg01 = g_rtg[l_ac3].rtg01 
      AND rtg03 = g_ima.ima01
      AND rtg04 = g_rtg[l_ac3].rtg04
   IF l_n > 0 THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i100_get_price()
   DEFINE l_rtz05     LIKE rtz_file.rtz05

   IF cl_null(g_rtg[l_ac3].rtg04) THEN
      RETURN
   END IF

   SELECT rtz05 INTO l_rtz05 
     FROM rtz_file 
    WHERE rtz01 = g_plant
     
   IF cl_null(l_rtz05) THEN RETURN END IF

   #SELECT rtg05,rtg06,rtg07,rtg08                                     #FUN-C80049 mark
   SELECT rtg05,rtg06,rtg07,rtg08,rtg11                                #FUN-C80049 add
     INTO g_rtg[l_ac3].rtg05,g_rtg[l_ac3].rtg06,
   #       g_rtg[l_ac3].rtg07,g_rtg[l_ac3].rtg08                       #FUN-C80049 mark
          g_rtg[l_ac3].rtg07,g_rtg[l_ac3].rtg08,g_rtg[l_ac3].rtg11     #FUN-C80049 add
     FROM rtg_file
    WHERE rtg01 = l_rtz05 
      AND rtg03 = g_ima.ima01
      AND rtg04 = g_rtg[l_ac3].rtg04
   #LET g_rtg[l_ac3].rtg11 = g_rtg[l_ac3].rtg05     #FUN-C60050 add     #FUN-C80049 mark
   #FUN-C80049--------add----str
   IF cl_null(g_rtg[l_ac3].rtg05) THEN LET g_rtg[l_ac3].rtg05 = 0 END IF
   IF cl_null(g_rtg[l_ac3].rtg06) THEN LET g_rtg[l_ac3].rtg06 = 0 END IF
   IF cl_null(g_rtg[l_ac3].rtg07) THEN LET g_rtg[l_ac3].rtg07 = 0 END IF
   IF cl_null(g_rtg[l_ac3].rtg11) THEN LET g_rtg[l_ac3].rtg11 = 0 END IF
   #FUN-C80049--------add----end
   IF cl_null(g_rtg[l_ac3].rtg08) THEN 
      LET g_rtg[l_ac3].rtg08 = 'N' 
   END IF
END FUNCTION
     
FUNCTION i100_rty01()
   DEFINE l_n         LIKE type_file.num10 
   DEFINE p_cmd       LIKE type_file.chr1 

   LET g_errno = ''
   
   LET g_sql= "SELECT COUNT(*) FROM azp_file WHERE azp01=? AND azp01 IN ",g_auth
   PREPARE azp_count FROM g_sql
   EXECUTE azp_count USING g_rty[l_ac4].rty01 INTO l_n
   IF l_n > 0 THEN
      SELECT count(*) INTO l_n 
        FROM rty_file
       WHERE rty01 = g_rty[l_ac4].rty01
         AND rty02 = g_ima.ima01
      IF l_n > 0 THEN
         LET g_errno = 'alm1487' 
      END IF    
   ELSE 
      LET g_errno = 'art-457'
   END IF    
END FUNCTION 

FUNCTION i100_rty04_desc(p_cmd)
   DEFINE p_cmd            LIKE type_file.chr1 
   DEFINE l_rty04_desc     LIKE geu_file.geu02 
   DEFINE l_geuacti        LIKE geu_file.geuacti 

   LET g_errno = ''

   IF g_rty[l_ac4].rty03 MATCHES '[234]' THEN
      SELECT geu02,geuacti INTO l_rty04_desc,l_geuacti
        FROM geu_file
       WHERE geu00 = '8' 
         AND geu01 = g_rty[l_ac4].rty04 
   END IF  
   CASE 
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'art-188'
      WHEN l_geuacti = 'N'
         LET g_errno = '9028'
      OTHERWISE 
         LET g_errno = SQLCA.sqlcode USING '-----------'
   END CASE 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rty[l_ac4].rty04_desc = l_rty04_desc 
   END IF 
END FUNCTION 

FUNCTION i100_rty12_desc(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_rty12_desc LIKE geu_file.geu02 
   DEFINE l_geuacti    LIKE geu_file.geuacti

   LET g_errno = ''

   SELECT geu02,geuacti INTO l_rty12_desc,l_geuacti
     FROM geu_file
    WHERE geu01 = g_rty[l_ac4].rty12
      AND geu00 = '4'
   CASE 
      WHEN SQLCA.sqlcode = 100 
         LET g_errno = 'art-591'
      WHEN l_geuacti = 'N'
         LET g_errno = '9028'
      OTHERWISE 
        LET g_errno=SQLCA.sqlcode USING '------'   
   END CASE    
   IF p_cmd = 'd' OR cl_null(g_errno) THEN 
      LET g_rty[l_ac4].rty12_desc = l_rty12_desc
   END IF 
END FUNCTION 

FUNCTION i100_rty05(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1
   DEFINE  l_rty01    LIKE azp_file.azp01
   DEFINE  l_rty06    LIKE gem_file.gem02
   DEFINE  l_rtoconf  LIKE gem_file.gemacti
   DEFINE  l_rtt01    LIKE rtt_file.rtt01
   DEFINE  l_rtt02    LIKE rtt_file.rtt02
   DEFINE  l_rts04    LIKE rts_file.rts04
   DEFINE  l_n        LIKE type_file.num5
   DEFINE  l_sql      STRING

    LET l_n = 0
    LET l_sql = ''
    LET g_errno=''
    LET l_sql =" SELECT COUNT(*) FROM ",cl_get_target_table(g_rty[l_ac4].rty01,'rtt_file'),",",
                                         cl_get_target_table(g_rty[l_ac4].rty01,'rts_file'),",",    
                                         cl_get_target_table(g_rty[l_ac4].rty01,'rto_file'),       
               " WHERE rtt04 = '",g_ima.ima01,"' ",
               "   AND rttplant = '",g_rty[l_ac4].rty01,"' AND rtt15 = 'Y' ",
               "   AND rts01 = rtt01 AND rts02 = rtt02  ",
               "   AND rto01 = rts04 AND rto03 = rts02  ",
               "   AND rtsplant = '",g_rty[l_ac4].rty01,"' ",
               "   AND rtsconf = 'Y' AND rto05 = '",g_rty[l_ac4].rty05,"' ",
               "   AND rtoconf ='Y' ",
               "   AND rto08 <= '",g_today,"' ",
               "   AND rto09 >= '",g_today,"' ",
               "   AND rtoplant = '",g_rty[l_ac4].rty01,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
    CALL cl_parse_qry_sql(l_sql,g_rty[l_ac4].rty01) RETURNING l_sql   
    PREPARE s_rtt_pb FROM l_sql
    EXECUTE s_rtt_pb INTO l_n
    IF l_n>0 THEN
    LET l_sql =" SELECT DISTINCT rto06 FROM ",cl_get_target_table(g_rty[l_ac4].rty01,'rtt_file'),",", 
                                              cl_get_target_table(g_rty[l_ac4].rty01,'rts_file'),",", 
                                              cl_get_target_table(g_rty[l_ac4].rty01,'rto_file'),    
               " WHERE rtt04 = '",g_ima.ima01,"' ",
               "   AND rttplant = '",g_rty[l_ac4].rty01,"' AND rtt15 = 'Y' ",
               "   AND rts01 = rtt01 AND rts02 = rtt02  ",
               "   AND rto01 = rts04 AND rto03 = rts02  ",
               "   AND rtsplant = '",g_rty[l_ac4].rty01,"' ",
               "   AND rtsconf = 'Y' AND rto05 = '",g_rty[l_ac4].rty05,"' ",
               "   AND rtoconf ='Y' ",
               "   AND rto08 <= '",g_today,"' ",
               "   AND rto09 >= '",g_today,"' ",
               "   AND rtoplant = '",g_rty[l_ac4].rty01,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
            CALL cl_parse_qry_sql(l_sql,g_rty[l_ac4].rty01) RETURNING l_sql  
            PREPARE s_rtt1_pb FROM l_sql
            EXECUTE s_rtt1_pb INTO l_rty06
    END IF


   IF NOT cl_null(l_rty06) THEN
      LET g_rty[l_ac4].rty06 = l_rty06
      DISPLAY BY NAME g_rty[l_ac4].rty06
   END IF

   IF l_n=0 THEN
      LET l_sql =" SELECT COUNT(*) ",
                 "   FROM  ",cl_get_target_table(g_rty[l_ac4].rty01,'pmc_file'),              
                 "  WHERE pmc01= '",g_rty[l_ac4].rty05,"'  ",
                 "    AND pmcacti='Y' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
      CALL cl_parse_qry_sql(l_sql,g_rty[l_ac4].rty01) RETURNING l_sql    
      PREPARE s_pmc_pb FROM l_sql
      EXECUTE s_pmc_pb INTO l_n
      IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pmc_file",g_rty[l_ac4].rty05,"",SQLCA.sqlcode,"","",1)
        RETURN
      END IF
      IF l_n >0 THEN
         LET g_rty[l_ac4].rty06 = '1'
         DISPLAY BY NAME g_rty[l_ac4].rty06
      ELSE
         LET g_errno = 100
      END IF
   END IF

END FUNCTION

FUNCTION i100_multi_rte01()
   DEFINE   tok         base.StringTokenizer
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_rte       RECORD LIKE rte_file.*
   DEFINE   l_success   LIKE type_file.chr1
   DEFINE   l_gec02     LIKE gec_file.gec02
   DEFINE   l_gecacti   LIKE gec_file.gecacti
   DEFINE   l_rvy03     LIKE rvy_file.rvy03    #TQC-C20136 add

   INITIALIZE l_rte.* TO NULL
   LET l_rte.rte04 = 'Y'
   LET l_rte.rte05 = 'Y'
   LET l_rte.rte06 = 'Y'
   OPEN WINDOW i100_w_b2 AT 8,15 WITH FORM "art/42f/arti120_1"
     ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_locale("arti120_1")
   DISPLAY l_rte.rte04 TO FORMONLY.rte04
   DISPLAY l_rte.rte05 TO FORMONLY.rte05
   DISPLAY l_rte.rte06 TO FORMONLY.rte06
   INPUT l_rte.rte08,l_rte.rte04,l_rte.rte05,l_rte.rte06  WITHOUT DEFAULTS
      FROM FORMONLY.rte08,FORMONLY.rte04,FORMONLY.rte05,FORMONLY.rte06
      BEFORE INPUT

      AFTER FIELD rte08
          IF NOT cl_null(l_rte.rte08) THEN
             SELECT gec02 ,gecacti INTO l_gec02,l_gecacti FROM gec_file
              WHERE gec01 = l_rte.rte08 AND gec011 = '2'
             CASE  WHEN SQLCA.sqlcode = 100
                      LET g_errno = 'art-931'
                   WHEN l_gecacti = 'N'
                      LET g_errno = '9028'
                   OTHERWISE
                      LET g_errno = SQLCA.SQLCODE USING '-------'
             END CASE
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD rte08
             END IF
          END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            WHEN INFIELD(rte08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec011"
               LET g_qryparam.default1 = l_rte.rte08
               CALL cl_create_qry() RETURNING l_rte.rte08
               DISPLAY BY NAME l_rte.rte08
               NEXT FIELD rte08

            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i100_w_b2
      RETURN
   END IF
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   LET l_rte.rte03 = g_ima.ima01
   LET l_rte.rte07 = 'Y'
   LET l_rte.rte09 = '2'
   LET l_rte.rtepos = '1'
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_rte01,"|")
   WHILE tok.hasMoreTokens()
      LET l_rte.rte01 = tok.nextToken()
      SELECT COUNT(*) INTO l_n FROM rte_file WHERE rte01 = l_rte.rte01 AND rte03 = g_ima.ima01
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE
         SELECT MAX(rte02)+1 INTO l_rte.rte02 FROM rte_file WHERE rte01 = l_rte.rte01
         IF cl_null(l_rte.rte02) THEN LET l_rte.rte02 = 1 END IF
         INSERT INTO rte_file VALUES(l_rte.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rte01',l_rte.rte01,'ins rte_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
            CONTINUE WHILE
         #TQC-C20136--start add---------------------------------------------------     
         ELSE
            SELECT MAX(rvy03)+1 INTO l_rvy03 
              FROM rvy_file 
             WHERE rvy01 = l_rte.rte01
               AND rvy02 = l_rte.rte02
            IF cl_null(l_rvy03) THEN 
               LET l_rvy03 = 1
            END IF 

            INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvygrup,rvyorig,
                             rvyoriu,rvyuser)
            VALUES(l_rte.rte01,l_rte.rte02,l_rvy03,l_rte.rte08,'2'
                    ,g_grup,g_grup,g_user,g_user) 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rvy01',l_rte.rte01,'ins rvy_file',SQLCA.sqlcode,1)
               LET l_success = 'N'
               CONTINUE WHILE
            END IF
         #TQC-C20136--end add-----------------------------------------------------   
         END IF
      END IF
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   CLOSE WINDOW i100_w_b2
END FUNCTION

FUNCTION i100_multi_rtg01()
   DEFINE   tok         base.StringTokenizer
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_rtg       RECORD LIKE rtg_file.*
   DEFINE   l_success   LIKE type_file.chr1
   DEFINE   l_rtz05     LIKE rtz_file.rtz05

   INITIALIZE l_rtg.* TO NULL
   LET l_rtg.rtg03 = g_ima.ima01
   SELECT ima25 INTO l_rtg.rtg04 FROM ima_file WHERE ima01 = l_rtg.rtg03
   SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01 = g_plant
   IF NOT cl_null(l_rtz05) THEN
      #SELECT rtg05,rtg06,rtg07,rtg08                                       #FUN-C80049 mark
      #  INTO l_rtg.rtg05,l_rtg.rtg06,l_rtg.rtg07,l_rtg.rtg08               #FUN-C80049 mark
      SELECT rtg05,rtg06,rtg07,rtg08,rtg11                                  #FUN-C80049 add
        INTO l_rtg.rtg05,l_rtg.rtg06,l_rtg.rtg07,l_rtg.rtg08,l_rtg.rtg11    #FUN-C80049 add
        FROM rtg_file
       WHERE rtg03 = l_rtg.rtg03 AND rtg04 = l_rtg.rtg04
         AND rtg09 = 'Y' AND rtg01 = l_rtz05
   ELSE
      LET l_rtg.rtg05 = 0
      LET l_rtg.rtg06 = 0
      LET l_rtg.rtg07 = 0
      LET l_rtg.rtg08 = 'Y'
      LET l_rtg.rtg11 = 0   #FUN-C80049 add
   END IF
   IF cl_null(l_rtg.rtg05) THEN LET l_rtg.rtg05 = 0   END IF
   IF cl_null(l_rtg.rtg06) THEN LET l_rtg.rtg06 = 0   END IF
   IF cl_null(l_rtg.rtg07) THEN LET l_rtg.rtg07 = 0   END IF
   IF cl_null(l_rtg.rtg08) THEN LET l_rtg.rtg08 = 'N' END IF
   IF cl_null(l_rtg.rtg11) THEN LET l_rtg.rtg11 = 0   END IF    #FUN-C60050 add
   LET l_rtg.rtg09 = 'Y'
   LET l_rtg.rtg10 = 'N'
   LET l_rtg.rtgpos = '1'
   LET l_rtg.rtg12 = g_today         #FUN-C60050 add
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_rtg01,"|")
   WHILE tok.hasMoreTokens()
      LET l_rtg.rtg01 = tok.nextToken()
      SELECT COUNT(*) INTO l_n FROM rtg_file WHERE rtg01 = l_rtg.rtg01 AND rtg03 = l_rtg.rtg03
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE
         SELECT MAX(rtg02)+1 INTO l_rtg.rtg02 FROM rtg_file WHERE rtg01 = l_rtg.rtg01
         IF cl_null(l_rtg.rtg02) THEN LET l_rtg.rtg02 = 1 END IF
         INSERT INTO rtg_file VALUES(l_rtg.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtg01',l_rtg.rtg01,'ins rtg_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF
      END IF   
   END WHILE   
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION

FUNCTION i100_multi_rty01()
   DEFINE tok         base.StringTokenizer
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_rty       RECORD LIKE rty_file.*
   DEFINE l_success   LIKE type_file.chr1
   DEFINE l_sql       STRING 
   DEFINE l_rty06     LIKE rty_file.rty06
   DEFINE l_rty07     LIKE rty_file.rty07

   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_rty01,"|")
   WHILE tok.hasMoreTokens()
      LET l_rty.rty01 = tok.nextToken()
      LET g_cnt = 0
      LET g_sql= "SELECT COUNT(*) FROM azp_file WHERE azp01=? AND azp01 IN ",g_auth
      PREPARE azp_count1 FROM g_sql
      EXECUTE azp_count1 USING l_rty.rty01 INTO l_n
      IF l_n > 0 THEN 
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rty.rty01,'rty_file'),
                     "  WHERE rty01 = '",l_rty.rty01,"' AND rty02 = '",g_ima.ima01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_rty.rty01) RETURNING l_sql
         PREPARE sel_rty01_pre FROM l_sql
         EXECUTE sel_rty01_pre INTO g_cnt
        
         IF g_cnt > 0 THEN
           CALL s_errmsg('rty01',l_rty.rty01,'INS rty_file','-239',1)
           CONTINUE WHILE
         END IF
         LET l_rty.rty02 = g_ima.ima01
         LET l_rty.rty03 =  '1'
         LET l_rty.rty04 =  NULL
         LET l_rty.rty05 = g_ima.ima54
         IF NOT cl_null(l_rty.rty05) THEN
            LET l_sql  = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rty.rty01,'rtt_file'),",",
                                            cl_get_target_table(l_rty.rty01,'rts_file'),",",
                                            cl_get_target_table(l_rty.rty01,'rto_file'),
                         " WHERE rtt04 = '",g_ima.ima01,"' ",
                         "   AND rttplant = '",l_rty.rty01,"' AND rtt15 = 'Y' ",
                         "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                         "   AND rto01 = rts04 AND rto03 = rts02  ",
                         "   AND rtsplant = '",l_rty.rty01,"' ",
                         "   AND rtsconf = 'Y' AND rto05 = '",l_rty.rty05,"' ",
                         "   AND rtoconf ='Y' ",
                         "   AND rto08 <= '",g_today,"' ",
                         "   AND rto09 >= '",g_today,"' ",
                         "   AND rtoplant = '",l_rty.rty01,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_rty.rty01) RETURNING l_sql
            PREPARE s_rtt01_pb FROM l_sql
            EXECUTE s_rtt01_pb INTO l_n
            IF l_n>0 THEN
               LET l_sql = " SELECT DISTINCT rto06 FROM ",cl_get_target_table(l_rty.rty01,'rtt_file'),",",
                                                  cl_get_target_table(l_rty.rty01,'rts_file'),",",
                                                  cl_get_target_table(l_rty.rty01,'rto_file'),
                           " WHERE rtt04 = '",g_ima.ima01,"' ",
                           "   AND rttplant = '",l_rty.rty01,"' AND rtt15 = 'Y' ",
                           "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                           "   AND rto01 = rts04 AND rto03 = rts02  ",
                           "   AND rtsplant = '",l_rty.rty01,"' ",
                           "   AND rtsconf = 'Y' AND rto05 = '",l_rty.rty05,"' ",
                           "   AND rtoconf ='Y' ",
                           "   AND rto08 <= '",g_today,"' ",
                           "   AND rto09 >= '",g_today,"' ",
                           "   AND rtoplant = '",l_rty.rty01,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_rty.rty01) RETURNING l_sql
               PREPARE s_rtt02_pb FROM l_sql
               EXECUTE s_rtt02_pb INTO l_rty06
            END IF   
            IF NOT cl_null(l_rty06) THEN
               LET l_rty.rty06 = l_rty06
            END IF
            
            IF l_n=0 THEN
               LET l_sql =" SELECT COUNT(*) ",
                          "   FROM  ",cl_get_target_table(l_rty.rty01,'pmc_file'),
                          "  WHERE pmc01= '",l_rty.rty05,"'  ",
                          "    AND pmcacti='Y' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_rty.rty01) RETURNING l_sql
               PREPARE s_pmc01_pb FROM l_sql
               EXECUTE s_pmc01_pb INTO l_n
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('rty01',l_rty.rty01,'SEL pmc_file','SQLCA.sqlcode',1)
                  CONTINUE WHILE
               END IF
               IF l_n >0 THEN
                  LET l_rty.rty06 = '1'
               END IF
            END IF
         END IF #TQC-C20357 Add
         IF NOT cl_null(l_rty.rty02) THEN
           CALL  s_overate(l_rty.rty02)  RETURNING l_rty07 
           LET l_rty.rty07 = l_rty07
         END IF
         LET l_rty.rty10 =  NULL
         LET l_rty.rty11 =  NULL
         LET l_rty.rty12 =  NULL
         LET l_rty.rtyacti =  'Y'
         INSERT INTO rty_file VALUES l_rty.*
         IF STATUS THEN
           CALL s_errmsg('rty01',l_rty.rty01,'INS rty_file',STATUS,1)
           CONTINUE WHILE
         END IF   
        #END IF #TQC-C20357 Mark
      ELSE
         CALL s_errmsg('rty01',l_rty.rty01,'art-457',STATUS,1)  
         CONTINUE WHILE
      END IF  
   END WHILE
   CALL s_showmsg()
END FUNCTION

FUNCTION i100_upd_ima()   # 回寫子料件某些欄位
   DEFINE l_imx000 LIKE imx_file.imx000
   DEFINE l_imx01  LIKE imx_file.imx01
   DEFINE l_imx02  LIKE imx_file.imx02
   DEFINE l_ima571 LIKE ima_file.ima571
   DEFINE l_ima94  LIKE ima_file.ima94
   DEFINE l_imaag  LIKE ima_file.imaag

   LET l_imx000=NULL
   LET l_imx01=NULL
   LET l_imx02=NULL
   LET l_ima571=NULL
   LET l_ima94=NULL
   LET l_imaag=NULL
   SELECT imaag INTO l_imaag FROM ima_file WHERE ima01=g_ima.ima01
   DECLARE i100_upd CURSOR FOR
      SELECT imx000,imx01,imx02 FROM imx_file WHERE imx00=g_ima.ima01
   FOREACH i100_upd INTO l_imx000,l_imx01,l_imx02
      IF SQLCA.sqlcode  THEN
          EXIT FOREACH
      END IF
      LET l_ima571= l_imx000
      LET l_ima94 = ''
      UPDATE ima_file SET ima940=l_imx01,ima941=l_imx02,ima571=l_imx000,ima94='',imaag1=l_imaag
        WHERE ima01=l_imx000
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION

FUNCTION i100_ima940(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_agc02  LIKE agc_file.agc02
   LET g_errno = ''
   SELECT agc02 INTO l_agc02 FROM agc_file WHERE agc01 = g_ima.ima940 AND agc07 = '1'
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "aim-070"
         LET l_agc02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION

FUNCTION i100_ima941(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_agc02  LIKE agc_file.agc02
   LET g_errno = ''
   SELECT agc02 INTO l_agc02 FROM agc_file WHERE agc01 = g_ima.ima941 AND agc07 = '2'
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "aim-070"
         LET l_agc02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION

FUNCTION i100_insert310()
   DEFINE l_aga02   LIKE aga_file.aga02,
          l_agc021  LIKE agc_file.agc02,
          l_agc022  LIKE agc_file.agc02
   SELECT agc02 INTO l_agc021 FROM agc_file WHERE agc01 = g_ima.ima940 AND agc07 = '1'
   SELECT agc02 INTO l_agc022 FROM agc_file WHERE agc01 = g_ima.ima941 AND agc07 = '2'
   LET l_aga02 = l_agc021,"-",l_agc022
   INSERT INTO aga_file(aga01,aga02,agauser,agadate,agagrup,agaacti) VALUES(g_ima.imaag,l_aga02,g_user,g_today,g_grup,'Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aga_file",g_ima.imaag,"",SQLCA.sqlcode,"","",1)

   ELSE
      MESSAGE "INSERT O.K"
   END IF
   INSERT INTO agb_file(agb01,agb02,agb03) VALUES(g_ima.imaag,'1',g_ima.ima940)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","agb_file",g_ima.ima940,"",SQLCA.sqlcode,"","",1)

   ELSE
      MESSAGE "INSERT O.K"
   END IF
   INSERT INTO agb_file(agb01,agb02,agb03) VALUES(g_ima.imaag,'2',g_ima.ima941)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","agb_file",g_ima.ima941,"",SQLCA.sqlcode,"","",1)

   ELSE
      MESSAGE "INSERT O.K"
   END IF
END FUNCTION

FUNCTION i100_produce_sub_parts()
   DEFINE l_sql1    STRING
   DEFINE l_sql2    STRING
   DEFINE l_msg     STRING
   DEFINE l_agd021  LIKE  agd_file.agd02
   DEFINE l_agd022  LIKE  agd_file.agd02
   DEFINE l_agd031  LIKE  agd_file.agd03
   DEFINE l_agd032  LIKE  agd_file.agd03
   DEFINE l_ima02   LIKE  ima_file.ima02
   DEFINE l_n1      LIKE  type_file.num5
   DEFINE l_n2      LIKE  type_file.num5
   DEFINE l_nt      LIKE  type_file.num5
   DEFINE l_nt2     LIKE  type_file.num5
   DEFINE l_cmd1    LIKE  type_file.num5
   DEFINE l_cmd2    LIKE  type_file.num5
   DEFINE l_n       LIKE  type_file.num5
   DEFINE l_ima01_t LIKE  ima_file.ima01
   DEFINE l_ima02_t LIKE  ima_file.ima02
   DEFINE l_ima940_t LIKE ima_file.ima940
   DEFINE l_ima941_t LIKE ima_file.ima941
   DEFINE l_confirm  LIKE ze_file.ze03
   DEFINE l_ps       LIKE sma_file.sma46
   DEFINE l_imaag1   LIKE ima_file.imaag1
   DEFINE i          LIKE type_file.num5

      IF g_ima.ima1010 <> '1' THEN   #審核後才可自動產生子料件
         CALL cl_err('','aap-717',0)
         RETURN
      END IF
      SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = g_ima.ima01
      LET l_ima940_t = g_ima.ima940
      LET l_ima941_t = g_ima.ima941
      LET l_ima01_t  = g_ima.ima01
      LET l_imaag1   = g_ima.imaag
      LET l_ima02_t  = g_ima.ima02
      LET l_cmd1 = 1
      LET l_cmd2 = 1
      SELECT sma46 INTO l_ps FROM sma_file
      LET l_sql1 = "SELECT agd02,agd03 FROM agd_file WHERE agd01 ='",g_ima.ima940,"'"
      DECLARE i100_sub_cs1 CURSOR  FROM l_sql1
      LET l_sql2 = "SELECT agd02,agd03 FROM agd_file WHERE agd01 ='",g_ima.ima941,"'"
      DECLARE i100_sub_cs2 CURSOR  FROM l_sql2
      SELECT count(agd02) INTO l_n1 FROM agd_file WHERE agd01 = g_ima.ima940
      SELECT count(agd02) INTO l_n2 FROM agd_file WHERE agd01 = g_ima.ima941
      LET l_nt = 0
      LET l_nt2 = 0
      IF(l_n1 = 0 OR l_n2 = 0) THEN
         CALL cl_err('','aim1102',1)
      ELSE
        IF(cl_confirm('aim1101')) THEN
           FOREACH i100_sub_cs1 INTO l_agd021,l_agd031
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              FOREACH i100_sub_cs2 INTO l_agd022,l_agd032
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET g_ima.ima01 = l_ima01_t,l_ps,l_agd021,l_ps,l_agd022
              LET g_ima.ima02 = l_ima02_t,l_ps,l_agd031,l_ps,l_agd032
              LET g_ima.imaag = '@CHILD'
              LET g_ima.imaag1 = l_imaag1
              LET g_ima.ima151 = 'N'
              LET g_ima.ima120 = '1'
              LET g_ima.ima571=g_ima.ima01
              LET g_ima.ima94 = ''
              IF g_ima.ima151 = 'N' THEN
                 LET g_ima.ima940 = l_agd021
                 LET g_ima.ima941 = l_agd022
              END IF
              SELECT count(*) INTO l_n FROM ima_file WHERE ima01 = g_ima.ima01
              IF l_n = 0 THEN
                 IF cl_null(g_ima.ima156) THEN LET g_ima.ima156 = 'N' END IF
                 IF cl_null(g_ima.ima157) THEN LET g_ima.ima157 = ' ' END IF
                 IF cl_null(g_ima.ima158) THEN LET g_ima.ima158 = 'N' END IF
                 LET g_ima.ima927 = 'N'
                 IF cl_null(g_ima.ima912) THEN LET g_ima.ima912 =  0  END IF
                 IF cl_null(g_ima.ima159) THEN LET g_ima.ima159 = '3' END IF 
                 IF cl_null(g_ima.ima160) THEN LET g_ima.ima160 = 'N' END IF      #FUN-C50036  add
                 INSERT INTO ima_file VALUES(g_ima.*)
                 IF SQLCA.sqlcode THEN 
                    CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
                 ELSE 
                    INSERT INTO imx_file(imx000,imx00,imx01,imx02) 
                       VALUES(g_ima.ima01,l_ima01_t,g_ima.ima940,g_ima.ima941)
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("ins","imx_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
                       DELETE FROM ima_file WHERE ima01 = g_ima.ima01
                       CONTINUE FOREACH
                    ELSE
                       LET l_nt = l_nt + 1
                       MESSAGE "INSERT O.K"
                    END IF
                 END IF
              ELSE 
                 LET l_nt2 = l_nt2 + 1
              END IF
            END FOREACH
          END FOREACH
          LET g_ima.ima01 = l_ima01_t
          LET g_ima.ima02 = l_ima02_t
          LET g_ima.ima151 = 'Y'
          LET g_ima.ima940 = l_ima940_t
          LET g_ima.ima941 = l_ima941_t
       END IF 
       CALL l_confirm2('aim1104','aim1105',l_nt,l_nt2)
     END IF
END FUNCTION

FUNCTION l_confirm2(ps_msg,ps_msg2,l_nt,l_nt2)
   DEFINE   ps_msg          STRING
   DEFINE   ps_msg2         STRING
   DEFINE   l_nt            LIKE type_file.num5
   DEFINE   l_nt2           LIKE type_file.num5
   DEFINE   ls_msg          LIKE type_file.chr1000
   DEFINE   ls_msg2         LIKE type_file.chr1000
   DEFINE   lc_msg          LIKE type_file.chr1000
   DEFINE   lc_msg2         LIKE type_file.chr1000
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   lc_title        LIKE ze_file.ze03

   WHENEVER ERROR CALL cl_err_msg_log

   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF

   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF

   LET ls_msg = ps_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   LET ls_msg2 = ps_msg2.trim()
   SELECT ze03 INTO lc_msg2 FROM ze_file WHERE ze01 = ls_msg2 AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
      LET ps_msg =lc_msg CLIPPED
      LET ps_msg2 =lc_msg2 CLIPPED
      LET ps_msg =l_nt2,ps_msg,l_nt,ps_msg2
   END IF 

    LET li_result = FALSE

    LET lc_title=lc_title CLIPPED,'(',ls_msg,')','(',ls_msg2,')'

   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
      ON ACTION accept
         EXIT MENU          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()  
         CONTINUE MENU      
   
   END MENU 
   
   IF (INT_FLAG) THEN       
      LET INT_FLAG = FALSE  
   END IF   
END FUNCTION

FUNCTION i100_carry_sub()
DEFINE l_n     LIKE type_file.num5
DEFINE l_sql   STRING
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_gew03 LIKE gew_file.gew03

   LET l_n = 0
   SELECT COUNT(*) INTO l_n 
     FROM ima_file 
    WHERE ima01 IN (SELECT imx000 
                      FROM imx_file 
                     WHERE imx00 = g_ima.ima01)
      AND ima1010 = '1'
   IF l_n > 0 THEN
      INITIALIZE g_gev04 TO NULL
      SELECT gev04 INTO g_gev04
        FROM gev_file
       WHERE gev01 = '1' 
         AND gev02 = g_plant
         AND gev03 = 'Y'
      IF NOT cl_null(g_gev04) THEN
         INITIALIZE l_gew03 TO NULL
         SELECT DISTINCT gew03 INTO l_gew03
           FROM gew_file
          WHERE gew01 = g_gev04
            AND gew02 = '1'
         IF l_gew03 = '1' THEN
            IF NOT cl_confirm("art1042") THEN RETURN END IF
            LET l_sql = "SELECT COUNT(*) FROM &ima_file ",
                        " WHERE ima01 = '",g_ima.ima01,"' " 
            CALL s_dc_sel_db1(g_gev04,'1',l_sql)
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               RETURN
            END IF

            CALL g_imax.clear()
            LET l_cnt = 1
            LET l_sql = "SELECT 'Y',imx000 FROM imx_file WHERE imx00 = '",g_ima.ima01,"' "
            PREPARE sel_imx_pre3 FROM l_sql
            DECLARE sel_imx_cs3 CURSOR FOR sel_imx_pre3
            FOREACH sel_imx_cs3 INTO g_imax[l_cnt].sel,g_imax[l_cnt].ima01
               IF SQLCA.sqlcode THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  EXIT FOREACH
               END IF
               LET l_cnt = l_cnt + 1
            END FOREACH
            
            CALL g_azp.clear()
            FOR l_cnt = 1 TO g_azp1.getLength()
                LET g_azp[l_cnt].sel   = g_azp1[l_cnt].sel
                LET g_azp[l_cnt].azp01 = g_azp1[l_cnt].azp01
                LET g_azp[l_cnt].azp02 = g_azp1[l_cnt].azp02
                LET g_azp[l_cnt].azp03 = g_azp1[l_cnt].azp03
            END FOR
            CALL s_showmsg_init()
            CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
            CALL s_showmsg()
         END IF
      END IF
   END IF
END FUNCTION

#TQC-C20070 Add Begin ---
FUNCTION i100_chk_rtg01()
DEFINE l_n  LIKE  type_file.num5
    IF NOT cl_null(g_rtg[l_ac3].rtg01) AND NOT cl_null(g_rtg[l_ac3].rtg04) THEN
       SELECT COUNT(*) INTO l_n FROM rtg_file
        WHERE rtg01 = g_rtg[l_ac3].rtg01 AND rtg03 = g_ima.ima01
          AND rtg04 = g_rtg[l_ac3].rtg04
       IF l_n > 0 THEN
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i100_chk_include()
DEFINE l_n         LIKE type_file.num5
DEFINE l_rtz05     LIKE rtz_file.rtz05

    IF NOT cl_null(g_rtg[l_ac3].rtg01) AND NOT cl_null(g_rtg[l_ac3].rtg04) THEN
       SELECT rtz05 INTO l_rtz05 FROM rtz_file
        WHERE rtz01 = g_plant
       IF cl_null(l_rtz05) THEN RETURN TRUE END IF
       SELECT COUNT(*) INTO l_n FROM rtg_file,rtf_file
        WHERE rtg01 = rtf01 AND rtf01 = l_rtz05 AND rtg03 = g_ima.ima01
          AND rtg04 = g_rtg[l_ac3].rtg04
       IF l_n > 0 THEN
          RETURN TRUE
       ELSE
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION
#TQC-C20070 Add End -----

#TQC-C20357 Add Begin ---
FUNCTION i100_chk_gec07(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_sql       STRING
DEFINE l_n         LIKE type_file.num5
DEFINE l_gec07_old LIKE gec_file.gec07
DEFINE l_gec07_new LIKE gec_file.gec07

#MOD-C30653 mark begin ---
#   IF p_cmd = 'u' THEN
#      LET l_sql = "SELECT COUNT(DISTINCT gec07) ",
#                  "  FROM gec_file ",
#                  " WHERE gec011 = '2' ",
#                  "   AND gec01 IN (SELECT rvy04 ",
#                  "                   FROM rvy_file ",
#                  "                  WHERE rvy01 = '",g_rte[l_ac2].rte01,"' ", 
#                  "                    AND rvy02 <> '",g_rvy[l_ac5].rvy02,"' AND rvy04 <> '",g_rvy_t.rvy04,"') "
#   ELSE
#      LET l_sql = "SELECT COUNT(DISTINCT gec07) ",
#                  "  FROM gec_file ",
#                  " WHERE gec011 = '2' ",
#                  "   AND gec01 IN (SELECT rvy04 ",
#                  "                   FROM rvy_file ",
#                  "                  WHERE rvy01 = '",g_rte[l_ac2].rte01,"') " 
#   END IF
#   PREPARE sel_count_gec07 FROM l_sql
#   EXECUTE sel_count_gec07 INTO l_n 
#   IF l_n > 1 THEN
#      CALL  cl_err('','art1039',0)
#      RETURN FALSE
#   ELSE
#MOD-C30653 mark end ---
      IF p_cmd = 'u' THEN
         LET l_sql = "SELECT DISTINCT gec07 ",
                     "  FROM gec_file ",
                     " WHERE gec011 = '2' ",
                     "   AND gec01 IN (SELECT rvy04 ",
                     "                   FROM rvy_file ",
                     "                  WHERE rvy01 = '",g_rte[l_ac2].rte01,"' ",
                     "                    AND rvy02 <> '",g_rvy[l_ac5].rvy02,"' AND rvy04 <> '",g_rvy_t.rvy04,"') "
      ELSE
         LET l_sql = "SELECT DISTINCT gec07 ",
                     "  FROM gec_file ",
                     " WHERE gec011 = '2' ",
                     "   AND gec01 IN (SELECT rvy04 ",
                     "                   FROM rvy_file ",
                     "                  WHERE rvy01 = '",g_rte[l_ac2].rte01,"') "
      END IF
      PREPARE sel_gec07_pre FROM l_sql
      EXECUTE sel_gec07_pre INTO l_gec07_old
      SELECT gec07 INTO l_gec07_new FROM gec_file WHERE gec01 = g_rvy[l_ac5].rvy04 AND gec011 = '2'
      IF NOT cl_null(l_gec07_old) AND NOT cl_null(l_gec07_new) THEN
         IF l_gec07_old <> l_gec07_new THEN
            CALL cl_err('','art1047',0)
            RETURN FALSE
         END IF
      END IF
#  END IF                        #MOD-C30653 mark
   RETURN TRUE
END FUNCTION
#TQC-C20357 Add End -----

#FUN-BC0076--------------------------------------------------------------------

#FUN-D30050--add--str---
FUNCTION i100_chk_tax(p_rte03,p_rte08)
DEFINE p_rte03   LIKE rte_file.rte03
DEFINE p_rte08   LIKE rte_file.rte08
DEFINE l_lpx33   LIKE lpx_file.lpx33
DEFINE l_gec011  LIKE gec_file.gec011
DEFINE l_gec04   LIKE gec_file.gec04

   LET g_errno = ' '
   IF g_ima.ima154 = 'Y' THEN
      INITIALIZE g_lpx38 TO NULL
      SELECT lpx38 INTO g_lpx38 FROM lpx_file WHERE lpx32 = p_rte03 
      IF g_lpx38 = 'Y' THEN
         SELECT lpx33 INTO l_lpx33 FROM lpx_file WHERE lpx32 = p_rte03 
         IF NOT cl_null(l_lpx33) THEN
            IF p_rte08 != l_lpx33 THEN
               LET g_errno = 'art1129'
               RETURN
            END IF
         END IF
      ELSE
         IF g_lpx38 = 'N' THEN
            SELECT gec011,gec04 INTO l_gec011,l_gec04 FROM gec_file WHERE gec01 = p_rte08
            IF NOT (l_gec011 = '2' AND l_gec04 = 0) THEN
               LET g_errno = 'art1130'
               RETURN
            END IF
         END IF
      END IF
   END IF

END FUNCTION
#FUN-D30050--add--end---

