# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axrt600.4gl
# Descriptions...: 集團代收維護作業
# Date & Author..: 06/09/26 BY day  
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6C0073 06/12/13 By day 審核無法通過，提示分錄無法產生 
# Modify.........: No.TQC-6C0087 06/12/15 By day 產生到axrt400時分錄的客戶和參考單號調整
# Modify.........: No.FUN-710050 07/02/01 By yjkhero 增加批處理錯誤統整功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/21 By wujie   網銀功能相關修改，nme新增欄位
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.TQC-740243 07/04/22 By Ray 無法審核
# Modify.........: No.MOD-740190 07/04/29 By Ray 審核后報錯有誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760074 07/06/08 By Rayven 審核時產生兩筆相同的內部帳戶
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/12 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.CHI-880003 08/08/06 By Sarah 將azr03改成aqg03
# Modify.........: No.FUN-8A0086 08/10/17 By dongbg 完善FUN-710050錯誤匯總修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980011 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Mofify.........: No.FUN-980020 09/09/03 By douzh 集團架構調整修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-9B0207 09/11/24 By jan 修改語法錯誤
# Modify.........: No.TQC-9B0219 09/11/26 By jan 確認時出現-239錯誤
# Modify.........: No.FUN-9B0147 09/11/27 By lutingting INSERT INTO ooa_file时给ooa37默认值N 
# Modify.........: No.FUN-9C0012 09/12/02 By destiny nem_file补PK，在insert表时给PK字段预设值
# Modify.........: No.TQC-9C0133 09/12/16 BY Carrier oma70/ooa38 赋值
# Modify.........: N0.FUN-9C0072 10/01/08 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXR
# Modify.........: No.FUN-A40055 10/04/30 By destiny 单身显示改为dialog
# Modify.........: No.FUN-A40076 10/07/02 By xiaofeizhu ooa37 = 'N' 改成 ooa37 = '1'
# Modify.........: No.FUN-A50102 10/07/05 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.CHI-A80036 10/08/31 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No.TQC-AB0421 10/12/03 By lixh1 錯誤訊息axr-405判斷式請修改為<0
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:TQC-B10069 11/01/13 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No:CHI-B10042 11/02/09 By Summer 將upd()段判斷狀況碼要為1.已核准才可以確認的段落往上搬到chk()段 
# Modify.........: No:TQC-B20128 11/02/21 By Sarah 整批確認檢查有錯誤要離開確認段時,要先將axrt600_6視窗關閉
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B40056 11/06/07 By guoch
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C40089 12/04/12 By lujh 狀態頁簽,“資料建立者”、“資料建立部門”無法下查詢條件
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_aqe           RECORD LIKE aqe_file.*,       
    g_aqe_t         RECORD LIKE aqe_file.*,      
    g_aqe_o         RECORD LIKE aqe_file.*,     
    g_aqe01_t       LIKE aqe_file.aqe01,       
    g_aqf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqf02           LIKE aqf_file.aqf02,
        aqf03           LIKE aqf_file.aqf03,
        aqf04           LIKE aqf_file.aqf04,
        aqf06           LIKE aqf_file.aqf06,
        omc04           LIKE omc_file.omc04,
        oma23           LIKE oma_file.oma23,
        omc06           LIKE omc_file.omc06,
        aqf05f          LIKE aqf_file.aqf05f,
        aqf05           LIKE aqf_file.aqf05,
        aqf11           LIKE aqf_file.aqf11,
        aqf12           LIKE aqf_file.aqf12,
        aqf13           LIKE aqf_file.aqf13,
        aqf14           LIKE aqf_file.aqf14,
        aqf15           LIKE aqf_file.aqf15,
        aqfud01         LIKE aqf_file.aqfud01,
        aqfud02         LIKE aqf_file.aqfud02,
        aqfud03         LIKE aqf_file.aqfud03,
        aqfud04         LIKE aqf_file.aqfud04,
        aqfud05         LIKE aqf_file.aqfud05,
        aqfud06         LIKE aqf_file.aqfud06,
        aqfud07         LIKE aqf_file.aqfud07,
        aqfud08         LIKE aqf_file.aqfud08,
        aqfud09         LIKE aqf_file.aqfud09,
        aqfud10         LIKE aqf_file.aqfud10,
        aqfud11         LIKE aqf_file.aqfud11,
        aqfud12         LIKE aqf_file.aqfud12,
        aqfud13         LIKE aqf_file.aqfud13,
        aqfud14         LIKE aqf_file.aqfud14,
        aqfud15         LIKE aqf_file.aqfud15
                    END RECORD,
    g_aqf_t         RECORD                 #程式變數 (舊值)
        aqf02           LIKE aqf_file.aqf02,
        aqf03           LIKE aqf_file.aqf03,
        aqf04           LIKE aqf_file.aqf04,
        aqf06           LIKE aqf_file.aqf06,
        omc04           LIKE omc_file.omc04,
        oma23           LIKE oma_file.oma23,
        omc06           LIKE omc_file.omc06,
        aqf05f          LIKE aqf_file.aqf05f,
        aqf05           LIKE aqf_file.aqf05,
        aqf11           LIKE aqf_file.aqf11,
        aqf12           LIKE aqf_file.aqf12,
        aqf13           LIKE aqf_file.aqf13,
        aqf14           LIKE aqf_file.aqf14,
        aqf15           LIKE aqf_file.aqf15,
        aqfud01         LIKE aqf_file.aqfud01,
        aqfud02         LIKE aqf_file.aqfud02,
        aqfud03         LIKE aqf_file.aqfud03,
        aqfud04         LIKE aqf_file.aqfud04,
        aqfud05         LIKE aqf_file.aqfud05,
        aqfud06         LIKE aqf_file.aqfud06,
        aqfud07         LIKE aqf_file.aqfud07,
        aqfud08         LIKE aqf_file.aqfud08,
        aqfud09         LIKE aqf_file.aqfud09,
        aqfud10         LIKE aqf_file.aqfud10,
        aqfud11         LIKE aqf_file.aqfud11,
        aqfud12         LIKE aqf_file.aqfud12,
        aqfud13         LIKE aqf_file.aqfud13,
        aqfud14         LIKE aqf_file.aqfud14,
        aqfud15         LIKE aqf_file.aqfud15
                    END RECORD,
    g_aqg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqg02           LIKE aqg_file.aqg02,
        aqg03           LIKE aqg_file.aqg03,
        aqg04           LIKE aqg_file.aqg04,
        aqg14           LIKE aqg_file.aqg14,
        aqg15           LIKE aqg_file.aqg15,
        aqg08           LIKE aqg_file.aqg08,
        aqg05           LIKE aqg_file.aqg05,
        aqg051          LIKE aqg_file.aqg051,
        aqg11           LIKE aqg_file.aqg11,
        nmc02           LIKE nmc_file.nmc02,
        aqg09           LIKE aqg_file.aqg09,
        aqg10           LIKE aqg_file.aqg10,
        aqg06f          LIKE aqg_file.aqg06f,
        aqg06           LIKE aqg_file.aqg06,
        aqgud01         LIKE aqg_file.aqgud01,
        aqgud02         LIKE aqg_file.aqgud02,
        aqgud03         LIKE aqg_file.aqgud03,
        aqgud04         LIKE aqg_file.aqgud04,
        aqgud05         LIKE aqg_file.aqgud05,
        aqgud06         LIKE aqg_file.aqgud06,
        aqgud07         LIKE aqg_file.aqgud07,
        aqgud08         LIKE aqg_file.aqgud08,
        aqgud09         LIKE aqg_file.aqgud09,
        aqgud10         LIKE aqg_file.aqgud10,
        aqgud11         LIKE aqg_file.aqgud11,
        aqgud12         LIKE aqg_file.aqgud12,
        aqgud13         LIKE aqg_file.aqgud13,
        aqgud14         LIKE aqg_file.aqgud14,
        aqgud15         LIKE aqg_file.aqgud15
                    END RECORD,
    g_aqg_t         RECORD
        aqg02           LIKE aqg_file.aqg02,
        aqg03           LIKE aqg_file.aqg03,
        aqg04           LIKE aqg_file.aqg04,
        aqg14           LIKE aqg_file.aqg14,
        aqg15           LIKE aqg_file.aqg15,
        aqg08           LIKE aqg_file.aqg08,
        aqg05           LIKE aqg_file.aqg05,
        aqg051          LIKE aqg_file.aqg051,
        aqg11           LIKE aqg_file.aqg11,
        nmc02           LIKE nmc_file.nmc02,
        aqg09           LIKE aqg_file.aqg09,
        aqg10           LIKE aqg_file.aqg10,
        aqg06f          LIKE aqg_file.aqg06f,
        aqg06           LIKE aqg_file.aqg06,
        aqgud01         LIKE aqg_file.aqgud01,
        aqgud02         LIKE aqg_file.aqgud02,
        aqgud03         LIKE aqg_file.aqgud03,
        aqgud04         LIKE aqg_file.aqgud04,
        aqgud05         LIKE aqg_file.aqgud05,
        aqgud06         LIKE aqg_file.aqgud06,
        aqgud07         LIKE aqg_file.aqgud07,
        aqgud08         LIKE aqg_file.aqgud08,
        aqgud09         LIKE aqg_file.aqgud09,
        aqgud10         LIKE aqg_file.aqgud10,
        aqgud11         LIKE aqg_file.aqgud11,
        aqgud12         LIKE aqg_file.aqgud12,
        aqgud13         LIKE aqg_file.aqgud13,
        aqgud14         LIKE aqg_file.aqgud14,
        aqgud15         LIKE aqg_file.aqgud15
                    END RECORD,
    g_aqg_o         RECORD LIKE aqg_file.*,
    g_wc,g_wc2,g_wc3,g_sql    STRING,  
    g_rec_b,g_rec_b2          LIKE type_file.num5,        
    g_qty1,g_qty2,g_qty3,g_qty4,g_qty5  LIKE type_file.num20_6,     
    g_add           LIKE type_file.chr1,  
    g_t1            LIKE oay_file.oayslip, 
    g_argv1         STRING,
    g_argv2         STRING,     
    l_ac            LIKE type_file.num5 
DEFINE g_ooa01      LIKE ooa_file.ooa01
DEFINE l_oma18      LIKE oma_file.oma18
DEFINE l_oma181     LIKE oma_file.oma181
DEFINE l_dbs        LIKE type_file.chr21 
DEFINE g_oob02_max  LIKE oob_file.oob02
DEFINE g_net        LIKE apv_file.apv04 
DEFINE g_aqf03      LIKE aqf_file.aqf03 
DEFINE g_aqf11      LIKE aqf_file.aqf11 
DEFINE g_aqf12      LIKE aqf_file.aqf12 
DEFINE g_aqf13      LIKE aqf_file.aqf13 
DEFINE g_amtf       LIKE aqf_file.aqf05f
DEFINE g_amt        LIKE aqf_file.aqf05
DEFINE  g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5 
DEFINE  g_chr           LIKE type_file.chr1 
DEFINE  g_cnt           LIKE type_file.num10 
DEFINE  g_i             LIKE type_file.num5  
DEFINE  g_msg           LIKE type_file.chr1000
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10 
DEFINE  g_no_ask       LIKE type_file.num5   
DEFINE  g_void          LIKE type_file.chr1    
DEFINE  g_chr2          LIKE type_file.chr1
DEFINE  g_chr3          LIKE type_file.chr1 
DEFINE  g_laststage     LIKE type_file.chr1  
DEFINE  g_b_flag        STRING  
MAIN
  DEFINE g_argv1       LIKE aqe_file.aqe01
  DEFINE g_argv2       STRING               
  DEFINE lc_plant      LIKE apb_file.apb03   
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
          INPUT NO WRAP
      DEFER INTERRUPT
   END IF
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET lc_plant=ARG_VAL(3)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_aza.aza69 <> 'Y' THEN
      CALL cl_err('','axr-949',1)
      EXIT PROGRAM
   END IF
 
   IF cl_null(lc_plant) THEN
      LET lc_plant = g_plant
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL t600()

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t600()
 
   LET g_forupd_sql = "SELECT * FROM aqe_file WHERE aqe01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW t600_w33 WITH FORM "axr/42f/axrt600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF g_aza.aza63 != 'Y' THEN
      CALL cl_set_comp_visible("aqg051",FALSE)   
   END IF
 
  #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
  #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2") #FUN-D20035 mark   
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")  #FUN-D20035 add undo_void 
     RETURNING g_laststage
 
   CALL t600_menu()
   CLOSE WINDOW t600_w33
END FUNCTION
 
#QBE 查詢資料
FUNCTION t600_cs()
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   
DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
 
   CLEAR FORM    
   CALL g_aqf.clear()
   CALL g_aqg.clear()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_aqe.* TO NULL    #No.FUN-750051
   #No.FUN-A40055--begin
#      CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqeinpd,aqe03,aqe11,
#                                aqe14,aqemksg,aqe15,aqe06,aqe04,aqe05,  
#                                aqe08f,aqe09f,aqe08,aqe09,
#                                aqeuser,aqegrup,aqemodu,
#                                aqedate,aqeacti,
#                                aqeud01,aqeud02,aqeud03,aqeud04,aqeud05,
#                                aqeud06,aqeud07,aqeud08,aqeud09,aqeud10,
#                                aqeud11,aqeud12,aqeud13,aqeud14,aqeud15
#      BEFORE CONSTRUCT
#          CALL cl_qbe_init()    
# 
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(aqe01)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_aqe"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqe01
#               NEXT FIELD aqe01
#            WHEN INFIELD(aqe03) 
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_occ"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqe03
#               CALL t600_aqe03_occ('d')
#            WHEN INFIELD(aqe04) # Employee CODE
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_gen"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqe04
#            WHEN INFIELD(aqe05) # Dept CODE
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_gem"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqe05
#            WHEN INFIELD(aqe06) # CURRENCY
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_azi"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqe06
#            OTHERWISE EXIT CASE
#         END CASE
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
# 
#      ON ACTION controlg      
#         CALL cl_cmdask()     
# 
#      ON ACTION qbe_select
#         CALL cl_qbe_list() RETURNING lc_qbe_sn
# 
#      END CONSTRUCT
# 
#      IF INT_FLAG THEN
#         RETURN
#      END IF
# 
#      LET g_wc2 = " 1=1"
#      CONSTRUCT g_wc2 ON aqg02,aqg03,aqg04,aqg14,aqg15,aqg08,
#                         aqg05,aqg051,aqg11,aqg09,aqg10,aqg06f,aqg06
#                        ,aqgud01,aqgud02,aqgud03,aqgud04,aqgud05
#                        ,aqgud06,aqgud07,aqgud08,aqgud09,aqgud10
#                        ,aqgud11,aqgud12,aqgud13,aqgud14,aqgud15
#           FROM s_aqg[1].aqg02,s_aqg[1].aqg03,s_aqg[1].aqg04,
#                s_aqg[1].aqg14,s_aqg[1].aqg15,s_aqg[1].aqg08,s_aqg[1].aqg05,s_aqg[1].aqg051,
#                s_aqg[1].aqg11,s_aqg[1].aqg09,s_aqg[1].aqg10,
#                s_aqg[1].aqg06f,s_aqg[1].aqg06
#               ,s_aqg[1].aqgud01,s_aqg[1].aqgud02,s_aqg[1].aqgud03
#               ,s_aqg[1].aqgud04,s_aqg[1].aqgud05,s_aqg[1].aqgud06
#               ,s_aqg[1].aqgud07,s_aqg[1].aqgud08,s_aqg[1].aqgud09
#               ,s_aqg[1].aqgud10,s_aqg[1].aqgud11,s_aqg[1].aqgud12
#               ,s_aqg[1].aqgud13,s_aqg[1].aqgud14,s_aqg[1].aqgud15
# 
#      BEFORE CONSTRUCT
#         CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#       ON ACTION controls                             #No.FUN-6A0092
#         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
# 
#      ON ACTION controlp
#        CASE
#           WHEN INFIELD(aqg03)
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_azp"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aqg03
#           WHEN INFIELD(aqg08)
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_nma"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aqg08
#           WHEN INFIELD(aqg11)
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_nmc"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aqg11
#           WHEN INFIELD(aqg05)
#              CALL s_get_bookno(YEAR(g_aqe.aqe02)) RETURNING l_flag,l_bookno1,l_bookno2
#              IF l_flag = '1' THEN
#                 CALL cl_err(YEAR(g_aqe.aqe02),'aoo-081',1)
#              END IF
#              CALL q_aapact(TRUE,TRUE,'2',g_aqg[1].aqg05,l_bookno1)        #No.FUN-740009
#                   RETURNING g_aqg[1].aqg05
#              DISPLAY g_aqg[1].aqg05 TO aqg05
#           WHEN INFIELD(aqg051)
#              CALL s_get_bookno(YEAR(g_aqe.aqe02)) RETURNING l_flag,l_bookno1,l_bookno2
#              IF l_flag = '1' THEN
#                 CALL cl_err(YEAR(g_aqe.aqe02),'aoo-081',1)
#              END IF
#              CALL q_aapact(TRUE,TRUE,'2',g_aqg[1].aqg051,l_bookno2)       #No.FUN-740009
#                   RETURNING g_aqg[1].aqg051
#              DISPLAY g_aqg[1].aqg051 TO aqg051
#           WHEN INFIELD(aqg09) # CURRENCY
#              CALL cl_init_qry_var()
#              LET g_qryparam.state = "c"
#              LET g_qryparam.form ="q_azi"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO aqg09
#           OTHERWISE
#              EXIT CASE
#        END CASE
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
# 
#      ON ACTION controlg      
#         CALL cl_cmdask()     
# 
#      ON ACTION qbe_select
#         CALL cl_qbe_list() RETURNING lc_qbe_sn
#         CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      END CONSTRUCT
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG=0
#         RETURN
#      END IF
# 
#      LET g_wc3 = " 1=1"
#      CONSTRUCT g_wc3 ON aqf02,aqf03,aqf04,aqf06,aqf05f,aqf05,
#                         aqf11,aqf12,aqf13,aqf14,aqf15
#                        ,aqfud01,aqfud02,aqfud03,aqfud04,aqfud05
#                        ,aqfud06,aqfud07,aqfud08,aqfud09,aqfud10
#                        ,aqfud11,aqfud12,aqfud13,aqfud14,aqfud15
#            FROM s_aqf[1].aqf02,s_aqf[1].aqf03,s_aqf[1].aqf04,
#                 s_aqf[1].aqf06,s_aqf[1].aqf05f,s_aqf[1].aqf05,
#                 s_aqf[1].aqf11,s_aqf[1].aqf12,s_aqf[1].aqf13,
#                 s_aqf[1].aqf14,s_aqf[1].aqf15
#                ,s_aqf[1].aqfud01,s_aqf[1].aqfud02,s_aqf[1].aqfud03
#                ,s_aqf[1].aqfud04,s_aqf[1].aqfud05,s_aqf[1].aqfud06
#                ,s_aqf[1].aqfud07,s_aqf[1].aqfud08,s_aqf[1].aqfud09
#                ,s_aqf[1].aqfud10,s_aqf[1].aqfud11,s_aqf[1].aqfud12
#                ,s_aqf[1].aqfud13,s_aqf[1].aqfud14,s_aqf[1].aqfud15
# 
#      BEFORE CONSTRUCT
#         CALL cl_qbe_display_condition(lc_qbe_sn)
# 
#      ON ACTION controlp
#         CASE
#            WHEN INFIELD(aqf03)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_azp"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqf03
#            WHEN INFIELD(aqf11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_ool01"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqf11
#               NEXT FIELD aqf11  
#            WHEN INFIELD(aqf12)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_oag01"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqf12
#               NEXT FIELD aqf12
#            WHEN INFIELD(aqf13)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_gec3"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqf13
#               NEXT FIELD aqf13
#            WHEN INFIELD(aqf14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_nma6"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqf14
#               NEXT FIELD aqf14 
#            WHEN INFIELD(aqf15)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form ="q_nmc04"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO aqf15
#            OTHERWISE
#               EXIT CASE
#         END CASE
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()  
# 
#      ON ACTION controlg      
#         CALL cl_cmdask()     
# 
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
# 
#      END CONSTRUCT
##
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqeinpd,aqe03,aqe11,
                                   aqe14,aqemksg,aqe15,aqe06,aqe04,aqe05,  
                                   aqe08f,aqe09f,aqe08,aqe09,
                                   aqeuser,aqegrup,aqeoriu,aqeorig,aqemodu,   #TQC-C40089  add aqeoriu,aqeorig,
                                   aqedate,aqeacti,
                                   aqeud01,aqeud02,aqeud03,aqeud04,aqeud05,
                                   aqeud06,aqeud07,aqeud08,aqeud09,aqeud10,
                                   aqeud11,aqeud12,aqeud13,aqeud14,aqeud15
         BEFORE CONSTRUCT
             CALL cl_qbe_init()    

         END CONSTRUCT

         CONSTRUCT g_wc2 ON aqg02,aqg03,aqg04,aqg14,aqg15,aqg08,
                            aqg05,aqg051,aqg11,aqg09,aqg10,aqg06f,aqg06
                           ,aqgud01,aqgud02,aqgud03,aqgud04,aqgud05
                           ,aqgud06,aqgud07,aqgud08,aqgud09,aqgud10
                           ,aqgud11,aqgud12,aqgud13,aqgud14,aqgud15
              FROM s_aqg[1].aqg02,s_aqg[1].aqg03,s_aqg[1].aqg04,
                   s_aqg[1].aqg14,s_aqg[1].aqg15,s_aqg[1].aqg08,s_aqg[1].aqg05,s_aqg[1].aqg051,
                   s_aqg[1].aqg11,s_aqg[1].aqg09,s_aqg[1].aqg10,
                   s_aqg[1].aqg06f,s_aqg[1].aqg06
                  ,s_aqg[1].aqgud01,s_aqg[1].aqgud02,s_aqg[1].aqgud03
                  ,s_aqg[1].aqgud04,s_aqg[1].aqgud05,s_aqg[1].aqgud06
                  ,s_aqg[1].aqgud07,s_aqg[1].aqgud08,s_aqg[1].aqgud09
                  ,s_aqg[1].aqgud10,s_aqg[1].aqgud11,s_aqg[1].aqgud12
                  ,s_aqg[1].aqgud13,s_aqg[1].aqgud14,s_aqg[1].aqgud15
         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         END CONSTRUCT
         
         CONSTRUCT g_wc3 ON aqf02,aqf03,aqf04,aqf06,aqf05f,aqf05,
                            aqf11,aqf12,aqf13,aqf14,aqf15
                           ,aqfud01,aqfud02,aqfud03,aqfud04,aqfud05
                           ,aqfud06,aqfud07,aqfud08,aqfud09,aqfud10
                           ,aqfud11,aqfud12,aqfud13,aqfud14,aqfud15
               FROM s_aqf[1].aqf02,s_aqf[1].aqf03,s_aqf[1].aqf04,
                    s_aqf[1].aqf06,s_aqf[1].aqf05f,s_aqf[1].aqf05,
                    s_aqf[1].aqf11,s_aqf[1].aqf12,s_aqf[1].aqf13,
                    s_aqf[1].aqf14,s_aqf[1].aqf15
                   ,s_aqf[1].aqfud01,s_aqf[1].aqfud02,s_aqf[1].aqfud03
                   ,s_aqf[1].aqfud04,s_aqf[1].aqfud05,s_aqf[1].aqfud06
                   ,s_aqf[1].aqfud07,s_aqf[1].aqfud08,s_aqf[1].aqfud09
                   ,s_aqf[1].aqfud10,s_aqf[1].aqfud11,s_aqf[1].aqfud12
                   ,s_aqf[1].aqfud13,s_aqf[1].aqfud14,s_aqf[1].aqfud15
         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         END CONSTRUCT    
         
         ON ACTION controlp
            CASE
               WHEN INFIELD(aqe01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aqe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqe01
                  NEXT FIELD aqe01
               WHEN INFIELD(aqe03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_occ"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqe03
                  CALL t600_aqe03_occ('d')
               WHEN INFIELD(aqe04) # Employee CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqe04
               WHEN INFIELD(aqe05) # Dept CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqe05
               WHEN INFIELD(aqe06) # CURRENCY
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqe06
              WHEN INFIELD(aqg03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aqg03
              WHEN INFIELD(aqg08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_nma"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aqg08
              WHEN INFIELD(aqg11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_nmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aqg11
              WHEN INFIELD(aqg05)
                 CALL s_get_bookno(YEAR(g_aqe.aqe02)) RETURNING l_flag,l_bookno1,l_bookno2
                 IF l_flag = '1' THEN
                    CALL cl_err(YEAR(g_aqe.aqe02),'aoo-081',1)
                 END IF
                 CALL q_aapact(TRUE,TRUE,'2',g_aqg[1].aqg05,l_bookno1)        #No.FUN-740009
                      RETURNING g_aqg[1].aqg05
                 DISPLAY g_aqg[1].aqg05 TO aqg05
              WHEN INFIELD(aqg051)
                 CALL s_get_bookno(YEAR(g_aqe.aqe02)) RETURNING l_flag,l_bookno1,l_bookno2
                 IF l_flag = '1' THEN
                    CALL cl_err(YEAR(g_aqe.aqe02),'aoo-081',1)
                 END IF
                 CALL q_aapact(TRUE,TRUE,'2',g_aqg[1].aqg051,l_bookno2)       #No.FUN-740009
                      RETURNING g_aqg[1].aqg051
                 DISPLAY g_aqg[1].aqg051 TO aqg051
              WHEN INFIELD(aqg09) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aqg09 
               WHEN INFIELD(aqf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqf03
               WHEN INFIELD(aqf11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_ool01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqf11
                  NEXT FIELD aqf11  
               WHEN INFIELD(aqf12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oag01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqf12
                  NEXT FIELD aqf12
               WHEN INFIELD(aqf13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gec3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqf13
                  NEXT FIELD aqf13
               WHEN INFIELD(aqf14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_nma6"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqf14
                  NEXT FIELD aqf14 
               WHEN INFIELD(aqf15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_nmc04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aqf15                                  
               OTHERWISE EXIT CASE
            END CASE
            
          ON ACTION controls                             #No.FUN-6A0092
            CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
           
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn

         ON ACTION accept
            EXIT DIALOG
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG 
             
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG          
                                    
      END DIALOG
      IF cl_null(g_wc2) THEN 
         LET g_wc2 = " 1=1"
      END IF 
      IF cl_null(g_wc3) THEN 
         LET g_wc3 = " 1=1"
      END IF 
#No.FUN-A40055--end
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN
      END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aqeuser', 'aqegrup')
   
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT aqe01 FROM aqe_file ",
                     " WHERE ", g_wc CLIPPED,
                     "   AND aqe00 = '1'",
                     " ORDER BY aqe01"
      ELSE                                    # 若單身有輸入條件
         LET g_sql = "SELECT aqe01 ",
                     "  FROM aqe_file,aqg_file ",
                     " WHERE aqe01=aqg01 AND ", g_wc CLIPPED,
                     "   AND aqe00 = '1'",
                     "   AND ",g_wc2 CLIPPED,
                     " ORDER BY aqe01"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT UNIQUE aqe_file.aqe01 ",
                     "  FROM aqe_file, aqf_file ",
                     " WHERE aqe01 = aqf01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                     "   AND aqe00 = '1'",
                     " ORDER BY aqe01"
      ELSE                                    # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE aqe_file.aqe01 ",
                     "  FROM aqe_file,aqf_file,aqg_file ",
                     " WHERE aqe01 = aqf01 AND aqe01=aqg01 ",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND ",g_wc3 CLIPPED,
                     "   AND aqe00 = '1'",
                     " ORDER BY aqe01"
      END IF
   END IF
 
   PREPARE t600_prepare FROM g_sql
   DECLARE t600_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t600_prepare
 
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(*) FROM aqe_file WHERE ",g_wc CLIPPED,
                   "   AND aqe00 = '1'"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT aqe01) FROM aqe_file,aqg_file WHERE ",
                   "aqg01=aqe01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "   AND aqe00 = '1'"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(DISTINCT aqe01) FROM aqe_file,aqf_file WHERE ",
                   "aqf01=aqe01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                   "   AND aqe00 = '1'"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT aqe01) ",
                   "  FROM aqe_file,aqf_file,aqg_file  ",
                   "  WHERE aqf01=aqe01 AND aqe01=aqg01 ",
                   "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "    AND ",g_wc3 CLIPPED,
                   "   AND aqe00 = '1'"
      END IF
   END IF
   PREPARE t600_precount FROM g_sql
   DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_menu()
   DEFINE l_creator   LIKE type_file.chr1          #是否退回填表人
   DEFINe l_flowuser  LIKE type_file.chr1          #是否有指定加簽人員     
 
   LET l_flowuser = "N"
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "insert"
            LET g_add = 'Y'
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
            LET g_add = NULL
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_b_flag='1' THEN 
                  CALL t600_b_aqg()
               ELSE 
               	 CALL t600_b_aqf()
               END IF
            ELSE 
            	 LET g_action_choice = NULL
            END IF 
            
         WHEN "receive_detail"    #收款單身
            IF cl_chk_act_auth() THEN
               CALL t600_b_aqg()
            ELSE
               LET g_action_choice = NULL
            END IF
         #NO.FUN-A40055-begin
        #WHEN "qry_receive_detail"
        #   IF cl_chk_act_auth() THEN
        #      CALL t600_bp2('G')
        #   ELSE
        #      LET g_action_choice = NULL
        #   END IF
        #NO.FUN-A40055--end
         WHEN "account_detail"    #帳款單身
            IF cl_chk_act_auth() THEN
               CALL t600_b_aqf()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069
               LET g_success = "Y"            #TQC-B10069 add
               CALL t600_firm1_chk()          #CALL 原確認的 check 段
               CALL t600_firm1_chk1()         #No.CHI-A80036  add
               IF g_success = "Y" THEN        
                  CALL t600_firm1_upd()       #CALL 原確認的 update 段
               ELSE                           #TQC-B20128 add
                  CLOSE WINDOW t600_w6        #TQC-B20128 add
               END IF
               CALL s_showmsg()               #TQC-B10069
               IF g_aqe.aqe14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_firm2()
               IF g_aqe.aqe14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_aqe.aqe15 = '1' THEN
                  LET g_chr2='Y' ELSE LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t600_x() #FUN-D20035 mark
               CALL t600_x(1) #FUN-D20035 add
               IF g_aqe.aqe14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_aqe.aqe15 = '1' THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
            END IF
         #FUN-D20035 add
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t600_x(2)
               IF g_aqe.aqe14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_aqe.aqe15 = '1' THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
            END IF
         #FUN-D20035 add end   
         #@WHEN "准"
         WHEN "agree"
            CALL s_showmsg_init()          #TQC-B10069  
            IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加>
               CALL t600_firm1_upd()      #CALL 原確認的 update 段
            ELSE
               LET g_success = "Y"
               IF NOT aws_efapp_formapproval() THEN
                  LET g_success = "N"
               END IF
            END IF
            CALL s_showmsg()               #TQC-B10069
            IF g_success = 'Y' THEN
               IF cl_confirm('aws-081') THEN  #詢問是否繼續下一筆資料的簽核
                  IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                     LET l_flowuser = "N"
                     LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                     IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                        CALL t600_q()
                        #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                        #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")     #No.FUN-680029 #FUN-D20035 mark
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")     #FUN-D20035 add undo_void
                             RETURNING g_laststage
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               ELSE
                  EXIT WHILE
               END IF
            END IF
 
         #@WHEN "不准"
         WHEN "deny"
            LET l_creator = aws_efapp_backflow()
            IF l_creator IS NOT NULL THEN #退回關卡
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_aqe.aqe15= 'R'
                     DISPLAY BY NAME g_aqe.aqe15
                  END IF
                  IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽>
                     IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                        LET l_flowuser = "N"
                        LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                        IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                           CALL t600_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")     #No.FUN-680029 #FUN-D20035 mark
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")     #FUN-D20035 add undo_void
                           RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
            END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
         WHEN "easyflow_approval"  
           IF cl_chk_act_auth() THEN
              CALL t600_ef()
           END IF
 
         WHEN "approval_status"   
           IF cl_chk_act_auth() THEN  #DISPLAY ONLY
              IF aws_condition2() THEN
                  CALL aws_efstat2()   
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t600_a()
   DEFINE   li_result   LIKE type_file.num5   
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_aqg.clear()
   CALL g_aqf.clear()
   INITIALIZE g_aqe.* LIKE aqe_file.*
   LET g_aqe01_t = NULL
   LET g_aqe.aqe00='1'
   LET g_aqe.aqe02=g_today
   LET g_aqe.aqeinpd=g_today
   LET g_aqe.aqe06=g_aza.aza17
   LET g_aqe.aqe08=0
   LET g_aqe.aqe08f=0
   LET g_aqe.aqe09=0
   LET g_aqe.aqe09f=0
   LET g_aqe_o.* = g_aqe.*
   LET g_aqe.aqemksg='N'
   LET g_aqe.aqe14='N'
   LET g_aqe.aqe15='0'
   LET g_aqe.aqeuser=g_user
   LET g_aqe.aqeoriu = g_user #FUN-980030
   LET g_aqe.aqeorig = g_grup #FUN-980030
   LET g_aqe.aqegrup=g_grup
   LET g_aqe.aqedate=g_today
   LET g_aqe.aqeacti='Y'              #資料有效
   LET g_aqe.aqelegal=g_legal         #FUN-980011 add
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t600_i("a")                #輸入單頭
      IF INT_FLAG THEN                #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_aqe.* TO NULL
         EXIT WHILE
      END IF
      IF g_aqe.aqe01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      CALL s_auto_assign_no("axr",g_aqe.aqe01,g_aqe.aqe02,"35","aqe_file","aqe01","","","")
        RETURNING li_result,g_aqe.aqe01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_aqe.aqe01
 
      INSERT INTO aqe_file VALUES (g_aqe.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)      #FUN-B80072    ADD
         ROLLBACK WORK   
        # CALL cl_err3("ins","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)     #FUN-B80072    MARK
         CONTINUE WHILE
      END IF
      SELECT aqe01 INTO g_aqe.aqe01 FROM aqe_file
       WHERE aqe01 = g_aqe.aqe01
      LET g_aqe01_t = g_aqe.aqe01        #保留舊值
      LET g_aqe_t.* = g_aqe.*
      CALL g_aqg.clear()
      CALL t600_b_aqg()                   #輸入單身-1
      SELECT COUNT(*) INTO g_cnt FROM aqg_file WHERE aqg01 = g_aqe.aqe01
      IF g_cnt = 0 THEN RETURN END IF
      CALL g_aqf.clear()
      CALL t600_b_aqf()                   #輸入單身-2
      LET g_t1=s_get_doc_no(g_aqe.aqe01)
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
      IF NOT cl_null(g_aqe.aqe01) AND g_ooy.ooyconf='Y'       #確認
         AND g_ooy.ooyapr <> 'Y' THEN                                
         LET g_action_choice = "insert"    
         CALL s_showmsg_init()          #TQC-B10069
         LET g_success = 'Y'            #TQC-B10069
         CALL t600_firm1_chk()          #CALL 原確認的 check 段
         IF g_success = "Y" THEN
            CALL t600_firm1_upd()       #CALL 原確認的 update 段
         END IF
         CALL s_showmsg()               #TQC-B10069
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t600_u()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
 
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_aqe.aqe15 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
 
   IF g_aqe.aqeacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aqe.aqe01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aqe01_t = g_aqe.aqe01
   LET g_aqe_o.* = g_aqe.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t600_cl USING g_aqe.aqe01
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN t600_cl:", SQLCA.sqlcode, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t600_show()
   WHILE TRUE
      LET g_aqe01_t = g_aqe.aqe01
      LET g_aqe.aqemodu=g_user
      LET g_aqe.aqedate=g_today
      CALL t600_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_aqe.*=g_aqe_t.*
         CALL t600_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_aqe.aqe01 != g_aqe01_t THEN            # 更改單號
         UPDATE aqg_file SET aqg01 = g_aqe.aqe01
          WHERE aqg01 = g_aqe01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","aqg_file",g_aqe01_t,"",SQLCA.sqlcode,"","upd aqg",1) 
            CONTINUE WHILE
         END IF
      END IF
      LET g_aqe.aqe15 = '0'    
      UPDATE aqe_file SET aqe_file.* = g_aqe.* WHERE aqe01 = g_aqe.aqe01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aqe_file",g_aqe01_t,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_aqe.aqe15     
      IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
      IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
      EXIT WHILE
   END WHILE
   CLOSE t600_cl
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqe.aqe01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#處理INPUT
FUNCTION t600_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #CHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改  #CHAR(1)
    l_yy,l_mm       LIKE type_file.num5   
DEFINE  li_result   LIKE type_file.num5  
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_aqe.aqeoriu,g_aqe.aqeorig,
          g_aqe.aqe01,g_aqe.aqe02,g_aqe.aqeinpd,g_aqe.aqe03,g_aqe.aqe11,
          g_aqe.aqe14,g_aqe.aqemksg,g_aqe.aqe15,
          g_aqe.aqe06,g_aqe.aqe04,g_aqe.aqe05,
          g_aqe.aqe08f,g_aqe.aqe09f,
          g_aqe.aqe08,g_aqe.aqe09,
          g_aqe.aqeuser,g_aqe.aqegrup,g_aqe.aqemodu,g_aqe.aqedate,g_aqe.aqeacti,
          g_aqe.aqeud01,g_aqe.aqeud02,g_aqe.aqeud03,g_aqe.aqeud04,
          g_aqe.aqeud05,g_aqe.aqeud06,g_aqe.aqeud07,g_aqe.aqeud08,
          g_aqe.aqeud09,g_aqe.aqeud10,g_aqe.aqeud11,g_aqe.aqeud12,
          g_aqe.aqeud13,g_aqe.aqeud14,g_aqe.aqeud15
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t600_set_entry(p_cmd)
         CALL t600_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("aqe01")
 
        AFTER FIELD aqe01      #代收單號
           IF NOT cl_null(g_aqe.aqe01) THEN
#             CALL s_check_no(g_sys,g_aqe.aqe01,g_aqe01_t,"35","aqe_file","aqe01","") 
              CALL s_check_no("axr",g_aqe.aqe01,g_aqe01_t,"35","aqe_file","aqe01","")    #No.FUN-A40041
                   RETURNING li_result,g_aqe.aqe01
              DISPLAY BY NAME g_aqe.aqe01
              IF (NOT li_result) THEN
                 NEXT FIELD aqe01
              END IF
              LET g_t1=g_aqe.aqe01[1,g_doc_len]  
           END IF
           SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
           IF g_ooy.ooytype !='35' THEN                                         
              CALL cl_err(g_aqe.aqe01,'afa-095',1)                              
              LET g_aqe.aqe01 =NULL                                             
              NEXT FIELD aqe01                                                  
           END IF                    
           IF g_ooy.ooydmy1 != 'N' THEN
              CALL cl_err(g_t1,'anm-036',0)
              NEXT FIELD aqe01
           END IF
           IF p_cmd = 'a' THEN      
              LET g_aqe.aqemksg = g_ooy.ooyapr
              LET g_aqe.aqe15 = "0"
           END IF
           DISPLAY BY NAME g_aqe.aqemksg,g_aqe.aqe15
 
        AFTER FIELD aqe02                  #收款日期不可小於關帳日期
           IF NOT cl_null(g_aqe.aqe02) THEN
              IF g_aqe.aqe02 <= g_ooz.ooz09 THEN
                 CALL cl_err(g_aqe.aqe02,'aap-176',0)
                 NEXT FIELD aqe02
              END IF
              IF g_ooz.ooz07 = 'Y' THEN
                 LET l_yy = YEAR(g_aqe.aqe02)
                 LET l_mm = MONTH(g_aqe.aqe02)
               # IF (l_yy*12+l_mm) - (g_ooz.ooz05*12+g_ooz.ooz06) > 1 THEN      #TQC-AB0421
                 IF (l_yy*12+l_mm) - (g_ooz.ooz05*12+g_ooz.ooz06) < 0 THEN      #TQC-AB0421
                    CALL cl_err(g_aqe.aqe02,'axr-405',0)
                    NEXT FIELD aqe02
                 END IF
                 IF (l_yy*12+l_mm) - (g_ooz.ooz05*12+g_ooz.ooz06) = 0 THEN
                    CALL cl_err(g_aqe.aqe02,'axr-406',0) 
                    NEXT FIELD aqe02
                 END IF
              END IF
           END IF
 
        BEFORE FIELD aqe03
          CALL t600_set_entry(p_cmd)
 
        AFTER FIELD aqe03   #收款客戶 
           IF NOT cl_null(g_aqe.aqe03) THEN
              IF cl_null(g_aqe_t.aqe03) OR g_aqe.aqe03 != g_aqe_t.aqe03 THEN
                 CALL t600_aqe03_occ('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe03,g_errno,0)
                    LET g_aqe.aqe03 = g_aqe_o.aqe03
                    DISPLAY BY NAME g_aqe.aqe03
                    NEXT FIELD aqe03
                 END IF
              END IF
           END IF
           LET g_aqe_o.aqe03 = g_aqe.aqe03
           CALL t600_set_no_entry(p_cmd)
 
        AFTER FIELD aqe11  #客戶簡稱
            IF cl_null(g_aqe.aqe11) THEN NEXT FIELD aqe11 END IF
            IF g_aqe.aqe11[1,1]='.' THEN
               LET g_msg = g_aqe.aqe11[2,9]
               SELECT gen02 INTO g_aqe.aqe11 FROM gen_file WHERE gen01=g_msg
               DISPLAY BY NAME g_aqe.aqe11
               IF SQLCA.sqlcode THEN NEXT FIELD aqe11 END IF
            END IF
 
        AFTER FIELD aqe04    #人員
           IF NOT cl_null(g_aqe.aqe04) THEN
              IF p_cmd = 'a' OR g_aqe.aqe04 != g_aqe_t.aqe04 THEN
                 CALL t600_aqe04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe04,g_errno,0)
                    NEXT FIELD aqe04
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqe05   #部門
           IF NOT cl_null(g_aqe.aqe05) THEN
              IF p_cmd = 'a' OR g_aqe.aqe05 != g_aqe_t.aqe05 THEN
                 CALL t600_aqe05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe05,g_errno,0)
                    NEXT FIELD aqe05
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqe06    #幣別
           IF NOT cl_null(g_aqe.aqe06) THEN
              IF p_cmd = 'a' OR g_aqe.aqe06 != g_aqe_t.aqe06 THEN
                 CALL t600_aqe06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe06,g_errno,0)
                    NEXT FIELD aqe06
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqemksg
           IF NOT cl_null(g_aqe.aqemksg) THEN
              IF g_aqe.aqemksg NOT MATCHES "[YN]" THEN NEXT FIELD aqemksg END IF
           END IF
 
        AFTER FIELD aqeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aqe.aqeuser = s_get_data_owner("aqe_file") #FUN-C10039
           LET g_aqe.aqegrup = s_get_data_group("aqe_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF cl_null(g_aqe.aqe03) THEN
              LET l_flag='Y'
              DISPLAY BY NAME g_aqe.aqe03
           END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD aqe01
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqe01) #查詢單据
                 LET g_t1=s_get_doc_no(g_aqe.aqe01) 
                 CALL q_ooy(FALSE,FALSE,g_t1,'35','AXR') RETURNING g_t1 
                 LET g_aqe.aqe01=g_t1 
                 DISPLAY BY NAME g_aqe.aqe01
                 NEXT FIELD aqe01
              WHEN INFIELD(aqe03) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.default1 = g_aqe.aqe03
                 CALL cl_create_qry() RETURNING g_aqe.aqe03
                 DISPLAY BY NAME g_aqe.aqe03
                 CALL t600_aqe03_occ('d')
              WHEN INFIELD(aqe04) # Employee CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_aqe.aqe04
                 CALL cl_create_qry() RETURNING g_aqe.aqe04
                 DISPLAY BY NAME g_aqe.aqe04
              WHEN INFIELD(aqe05) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_aqe.aqe05
                 CALL cl_create_qry() RETURNING g_aqe.aqe05
                 DISPLAY BY NAME g_aqe.aqe05
              WHEN INFIELD(aqe06) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aqe.aqe06
                 CALL cl_create_qry() RETURNING g_aqe.aqe06
                 DISPLAY BY NAME g_aqe.aqe06
              OTHERWISE EXIT CASE
        END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
 
    END INPUT
END FUNCTION
 
FUNCTION t600_aqe03_occ(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #CHAR(1)
   DEFINE l_occ   RECORD LIKE occ_file.*
 
   SELECT * INTO l_occ.*
     FROM occ_file
    WHERE occ01 = g_aqe.aqe03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'anm-045'
        WHEN l_occ.occacti = 'N'     LET g_errno = '9028'
        WHEN l_occ.occacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN SQLCA.SQLCODE != 0                 LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_aqe.aqe11 = l_occ.occ02
      LET g_aqe.aqe06 = l_occ.occ42
      DISPLAY BY NAME g_aqe.aqe06,g_aqe.aqe11
   END IF
END FUNCTION
 
FUNCTION t600_aqe04(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #CHAR(1)
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen03,genacti INTO l_gen03,l_genacti
     FROM gen_file WHERE gen01 = g_aqe.aqe04
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_aqe.aqe05 = l_gen03
   DISPLAY BY NAME g_aqe.aqe05
END FUNCTION
 
FUNCTION t600_aqe05(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #CHAR(1)
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gemacti INTO l_gemacti
     FROM gem_file WHERE gem01 = g_aqe.aqe05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
END FUNCTION
 
FUNCTION t600_aqe06(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #CHAR(1)
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_aqe.aqe06
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
        WHEN l_aziacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t600_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_msg("")       
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aqg.clear()
   CALL g_aqf.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t600_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")  
 
   OPEN t600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aqe.* TO NULL
   ELSE
      OPEN t600_count
      FETCH t600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")       
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t600_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t600_cs INTO g_aqe.aqe01
      WHEN 'P' FETCH PREVIOUS t600_cs INTO g_aqe.aqe01
      WHEN 'F' FETCH FIRST    t600_cs INTO g_aqe.aqe01
      WHEN 'L' FETCH LAST     t600_cs INTO g_aqe.aqe01
      WHEN '/'
         IF NOT g_no_ask THEN
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t600_cs INTO g_aqe.aqe01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)
      INITIALIZE g_aqe.* TO NULL  #TQC-6B0105
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
   END IF
   SELECT * INTO g_aqe.* FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_aqe.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_aqe.aqeuser     
      LET g_data_group = g_aqe.aqegrup    
      CALL t600_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t600_show()
   LET g_aqe_t.* = g_aqe.*                #保存單頭舊值
   DISPLAY BY NAME g_aqe.aqeoriu,g_aqe.aqeorig,
          g_aqe.aqe01,g_aqe.aqe02,g_aqe.aqeinpd,g_aqe.aqe03,g_aqe.aqe11,
          g_aqe.aqe14,g_aqe.aqemksg,g_aqe.aqe15, 
          g_aqe.aqe06,g_aqe.aqe04,  g_aqe.aqe05,
          g_aqe.aqe08f,g_aqe.aqe09f,
          g_aqe.aqe08,g_aqe.aqe09,
          g_aqe.aqeuser,g_aqe.aqegrup,g_aqe.aqemodu,g_aqe.aqedate,g_aqe.aqeacti,
          g_aqe.aqeud01,g_aqe.aqeud02,g_aqe.aqeud03,g_aqe.aqeud04,
          g_aqe.aqeud05,g_aqe.aqeud06,g_aqe.aqeud07,g_aqe.aqeud08,
          g_aqe.aqeud09,g_aqe.aqeud10,g_aqe.aqeud11,g_aqe.aqeud12,
          g_aqe.aqeud13,g_aqe.aqeud14,g_aqe.aqeud15
           
   CALL t600_aqe03_occ('d')
   CALL t600_b_aqg_fill(g_wc2)                 #單身
   CALL t600_b_aqf_fill(g_wc3)                 #單身
   IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
   CALL cl_show_fld_cont()   
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t600_r()
DEFINE i                LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_aqe.aqe15 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_aqe.aqe15 matches '[Ss1]' THEN  
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t600_cl USING g_aqe.aqe01
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN t600_cl:", SQLCA.sqlcode, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t600_show()
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM aqg_file WHERE aqg01 = g_aqe.aqe01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aqg_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","del aqg:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqf_file WHERE aqf01 = g_aqe.aqe01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aqf_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","del aqf:",1) 
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","del aqe:",1) 
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_aqe.* TO NULL
      CLEAR FORM
      CALL g_aqg.clear()
      CALL g_aqf.clear()
      OPEN t600_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t600_cl
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t600_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t600_cl
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t600_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t600_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t600_fetch('/')
      END IF
   END IF
   CLOSE t600_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqe.aqe01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_b_aqf()
DEFINE l_azp03  LIKE azp_file.azp03
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
   l_n             LIKE type_file.num5,                #檢查重複用  
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
   p_cmd           LIKE type_file.chr1,                #處理狀態  
   l_exit_sw       LIKE type_file.chr1,               
   l_allow_insert  LIKE type_file.num5,                #可新增否 
   l_allow_delete  LIKE type_file.num5,                #可刪除否
   l_aqe15         LIKE aqe_file.aqe15,
   l_gec04         LIKE gec_file.gec04,
   l_cnt           LIKE type_file.num5     #SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
   LET l_aqe15 = g_aqe.aqe15  
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_aqe.aqeacti ='N' THEN CALL cl_err(g_aqe.aqe01,'9027',0) RETURN END IF
   IF g_aqe.aqe15 matches '[Ss]' THEN 
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_rec_b FROM aqf_file WHERE aqf01=g_aqe.aqe01
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT aqf02,aqf03,aqf04,aqf06,'','','',",
                      "       aqf05f,aqf05,aqf11,aqf12,aqf13,aqf14,aqf15,",
                      "       aqfud01,aqfud02,aqfud03,aqfud04,aqfud05,",
                      "       aqfud06,aqfud07,aqfud08,aqfud09,aqfud10,",
                      "       aqfud11,aqfud12,aqfud13,aqfud14,aqfud15 ",
                      " FROM aqf_file",
                      " WHERE aqf01=? AND aqf02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_aqe.aqemodu=g_user
   LET g_aqe.aqedate=g_today
   DISPLAY BY NAME g_aqe.aqemodu,g_aqe.aqedate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   WHILE TRUE
   LET l_exit_sw = 'y'
   INPUT ARRAY g_aqf WITHOUT DEFAULTS FROM s_aqf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          OPEN t600_cl USING g_aqe.aqe01
          IF SQLCA.sqlcode THEN
             CALL cl_err("OPEN t600_cl:", SQLCA.sqlcode, 1)
             CLOSE t600_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE t600_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_aqf_t.* = g_aqf[l_ac].*  #BACKUP
             OPEN t600_b2cl USING g_aqe.aqe01,g_aqf_t.aqf02
             IF SQLCA.sqlcode THEN
                CALL cl_err("OPEN t600_b2cl:", SQLCA.sqlcode, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t600_b2cl INTO g_aqf[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_aqf_t.aqf02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             LET g_aqf[l_ac].omc04 = g_aqf_t.omc04                              
             LET g_aqf[l_ac].oma23 = g_aqf_t.oma23                              
             LET g_aqf[l_ac].omc06 = g_aqf_t.omc06   
             CALL cl_show_fld_cont()   
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_aqf[l_ac].* TO NULL 
          LET g_aqf[l_ac].aqf05f= 0
          LET g_aqf[l_ac].aqf05 = 0
          LET g_aqf_t.* = g_aqf[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()   
          NEXT FIELD aqf02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO aqf_file(aqf00,aqf01,aqf02,aqf03,aqf04,aqf05f,aqf05,aqf06,
                               aqf11,aqf12,aqf13,aqf14,aqf15,
                               aqfud01,aqfud02,aqfud03,
                               aqfud04,aqfud05,aqfud06,
                               aqfud07,aqfud08,aqfud09,
                               aqfud10,aqfud11,aqfud12,
                               aqfud13,aqfud14,aqfud15,
                               aqflegal )     #FUN-980011 add
            VALUES('1',g_aqe.aqe01,g_aqf[l_ac].aqf02,g_aqf[l_ac].aqf03,
                   g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf05f,g_aqf[l_ac].aqf05,
                   g_aqf[l_ac].aqf06,g_aqf[l_ac].aqf11, g_aqf[l_ac].aqf12,
                   g_aqf[l_ac].aqf13,g_aqf[l_ac].aqf14, g_aqf[l_ac].aqf15,
                   g_aqf[l_ac].aqfud01,g_aqf[l_ac].aqfud02,
                   g_aqf[l_ac].aqfud03,g_aqf[l_ac].aqfud04,
                   g_aqf[l_ac].aqfud05,g_aqf[l_ac].aqfud06,
                   g_aqf[l_ac].aqfud07,g_aqf[l_ac].aqfud08,
                   g_aqf[l_ac].aqfud09,g_aqf[l_ac].aqfud10,
                   g_aqf[l_ac].aqfud11,g_aqf[l_ac].aqfud12,
                   g_aqf[l_ac].aqfud13,g_aqf[l_ac].aqfud14,
                   g_aqf[l_ac].aqfud15,
                   g_legal)     #FUN-980011 add
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","aqf_file",g_aqe.aqe01,g_aqf[l_ac].aqf02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn4
             IF g_success='Y' THEN
                COMMIT WORK
                LET l_aqe15 = '0'         
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       BEFORE FIELD aqf02                        #default 序號
          IF g_aqf[l_ac].aqf02 IS NULL OR g_aqf[l_ac].aqf02 = 0 THEN
             SELECT max(aqf02)+1
               INTO g_aqf[l_ac].aqf02
               FROM aqf_file
              WHERE aqf01 = g_aqe.aqe01
             IF g_aqf[l_ac].aqf02 IS NULL THEN
                LET g_aqf[l_ac].aqf02 = 1
             END IF
          END IF
 
       AFTER FIELD aqf02                        #check 序號是否重複
          IF g_aqf[l_ac].aqf02 IS NULL THEN
             LET g_aqf[l_ac].aqf02 = g_aqf_t.aqf02
             NEXT FIELD aqf02
          END IF
          IF g_aqf[l_ac].aqf02 != g_aqf_t.aqf02 OR
             g_aqf_t.aqf02 IS NULL THEN
             SELECT count(*)
               INTO l_n
               FROM aqf_file
              WHERE aqf01 = g_aqe.aqe01
                AND aqf02 = g_aqf[l_ac].aqf02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_aqf[l_ac].aqf02 = g_aqf_t.aqf02
                NEXT FIELD aqf02
             END IF
          END IF
 
       AFTER FIELD aqf03
          IF NOT cl_null(g_aqf[l_ac].aqf03) THEN
             LET g_plant_new = g_aqf[l_ac].aqf03
             IF (g_plant_new!=g_plant) THEN
             IF NOT s_chknplt(g_plant_new,'AXR','AXR') THEN
                CALL cl_err(g_plant_new,g_errno,0)
                  NEXT FIELD aqf03
             END IF
             ELSE
                LET g_dbs_new = NULL
             END IF
             IF g_aqf_t.aqf03 IS NULL OR g_aqf[l_ac].aqf03 != g_aqf_t.aqf03 THEN
                CALL t600_aqf03()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('aqd',g_errno,0)
                   LET g_aqf[l_ac].aqf03=g_aqf_t.aqf03
                   NEXT FIELD aqf03
                END IF 
                CALL s_getdbs()
                #LET g_sql ="SELECT azp03 FROM ",g_dbs_new CLIPPED,"azp_file",
                LET g_sql ="SELECT azp03 FROM ",cl_get_target_table(g_plant_new,'azp_file'), #FUN-A50102
                           " WHERE azp01 ='",g_aqf[l_ac].aqf03,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                PREPARE t600_sel_azp022_p FROM g_sql
                IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
                EXECUTE t600_sel_azp022_p INTO l_azp03
                IF cl_null(l_azp03) THEN LET l_azp03 = ' ' END IF
             END IF
          END IF
 
       AFTER FIELD aqf06
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM aqe_file,aqf_file
             WHERE aqe01 = aqf01 AND aqf04 = g_aqf[l_ac].aqf04 AND 
                   aqe01 = g_aqe.aqe01 AND aqf06 = g_aqf[l_ac].aqf06
               AND aqf03 = g_aqf[l_ac].aqf03
           IF g_aqf_t.aqf04 IS NULL OR
              g_aqf[l_ac].aqf04 != g_aqf_t.aqf04 OR
              g_aqf_t.aqf06 IS NULL OR
              g_aqf[l_ac].aqf06 != g_aqf_t.aqf06 THEN
	      IF l_cnt > 0 THEN
                 CALL cl_err('','aap-112',1)
                 NEXT FIELD aqf04
              END IF
           END IF
           IF NOT cl_null(g_aqf[l_ac].aqf06) THEN
              IF g_aqf_t.aqf06 IS NULL OR
                 g_aqf[l_ac].aqf04 != g_aqf_t.aqf04 OR
                 g_aqf[l_ac].aqf06 != g_aqf_t.aqf06 OR
                 g_aqf[l_ac].aqf03 != g_aqf_t.aqf03 THEN
                 CALL t600_aqf04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_aqf[l_ac].aqf04=g_aqf_t.aqf04
                    LET g_aqf[l_ac].aqf06=g_aqf_t.aqf06
                    DISPLAY BY NAME g_aqf[l_ac].aqf04
                    DISPLAY BY NAME g_aqf[l_ac].aqf06
                    NEXT FIELD aqf04
                 END IF
              END IF
           END IF
 
       BEFORE FIELD aqf05f
           LET g_sql = "SELECT omc08,omc10,omc08-omc10  ",   
                       #"  FROM ",g_dbs_new,"omc_file  ",
                       "  FROM ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                       " WHERE omc01 = ?  AND omc02=? "
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
           PREPARE t600_p4 FROM g_sql
           DECLARE t600_c4 CURSOR FOR t600_p4
           OPEN t600_c4 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06  
           FETCH t600_c4 INTO g_qty1,g_qty2,g_qty4
           #考慮收款未確認部分
           LET g_sql = "SELECT SUM(aqf05f)",
                       #"  FROM ",g_dbs_new,"aqf_file,",g_dbs_new,"aqe_file",
                       "  FROM ",cl_get_target_table(g_plant_new,'aqf_file'),",", #FUN-A50102
                                 cl_get_target_table(g_plant_new,'aqe_file'),     #FUN-A50102
                       " WHERE aqf04 = ? AND aqf06 = ? ",  
                       "   AND aqf01 <> '",g_aqe.aqe01,"'",
                       "   AND aqf01 = aqe01 AND aqe14='N'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
           PREPARE t600_p5 FROM g_sql
           DECLARE t600_c5 CURSOR FOR t600_p5
           OPEN t600_c5 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06  
           FETCH t600_c5 INTO g_qty5
           IF cl_null(g_qty5) THEN LET g_qty5=0 END IF
           IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF
           LET g_qty4=g_qty4 - g_qty5
           CALL cl_getmsg('axr-943',g_lang) RETURNING g_msg
           LET g_msg[6,13] = g_qty1 USING '--------'
           LET g_msg[20,27] = g_qty2 USING '--------'
           LET g_msg[50,57] = g_qty5 USING '--------'
           ERROR g_msg CLIPPED,g_qty4 USING '--------'
           LET g_aqf_t.aqf05f = g_aqf[l_ac].aqf05f
 
       AFTER FIELD aqf05f
          IF NOT cl_null(g_aqf[l_ac].aqf05f) THEN
             IF g_aqf[l_ac].aqf05f > 0 THEN
                IF g_aqf[l_ac].aqf05f > g_qty4 THEN
                   CALL cl_err('','aap-069',1)
                   NEXT FIELD aqf05f
                END IF
                IF g_aqf[l_ac].aqf05f = g_aqf_t.aqf05f THEN ELSE
                   LET g_aqf[l_ac].aqf05=g_aqf[l_ac].aqf05f*g_aqf[l_ac].omc06
                   CALL cl_digcut(g_aqf[l_ac].aqf05,g_azi04)
                        RETURNING g_aqf[l_ac].aqf05
                   DISPLAY BY NAME g_aqf[l_ac].aqf05
                END IF
             ELSE
                CALL cl_err(g_aqf[l_ac].aqf05f,'aap-201',1)
                NEXT FIELD aqf05f
             END IF
          END IF
 
       BEFORE FIELD aqf05
           LET g_sql = "SELECT omc09,omc11,omc09-omc11", 
                       #"  FROM ",g_dbs_new,"oma_file ,",            
                       #          g_dbs_new,"omc_file  ",
                       "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),",", #FUN-A50102
                                 cl_get_target_table(g_plant_new,'omc_file'),     #FUN-A50102          
                       " WHERE omc01 = ? AND omc02=?  ",          
                       "   AND oma01=omc01  "                    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
           PREPARE t600_p6 FROM g_sql
           DECLARE t600_c6 CURSOR FOR t600_p6
           OPEN t600_c6 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
           FETCH t600_c6 INTO g_qty1,g_qty2,g_qty4
           LET g_sql = "SELECT SUM(aqf05)",
                       #"  FROM ",g_dbs_new,"aqf_file,",g_dbs_new,"aqe_file",
                       "  FROM ",cl_get_target_table(g_plant_new,'aqf_file'),",", #FUN-A50102
                                 cl_get_target_table(g_plant_new,'aqe_file'),     #FUN-A50102          
                       " WHERE aqf04 = ? AND aqf06 = ? ",
                       "   AND aqf01 <> '",g_aqe.aqe01,"'",
                       "   AND aqf01 = aqe01 AND aqe14='N'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
           PREPARE t600_p7 FROM g_sql
           DECLARE t600_c7 CURSOR FOR t600_p7
           OPEN t600_c7 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06   
           FETCH t600_c7 INTO g_qty5
           IF cl_null(g_qty5) THEN LET g_qty5=0 END IF
           IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF
           LET g_qty4=g_qty4 - g_qty5
           CALL cl_getmsg('axr-943',g_lang) RETURNING g_msg
           LET g_msg[6,13] = g_qty1 USING '--------'
           LET g_msg[20,27] = g_qty2 USING '--------'
           LET g_msg[50,57] = g_qty5 USING '--------'
           ERROR g_msg CLIPPED,g_qty4 USING '--------'
           LET g_aqf_t.aqf05 = g_aqf[l_ac].aqf05
 
       AFTER FIELD aqf05
          IF NOT cl_null(g_aqf[l_ac].aqf05) THEN
             IF g_aqf[l_ac].aqf05 > 0 THEN
                IF g_aqf[l_ac].aqf05 > g_qty4 THEN
                   CALL cl_err('','aap-069',1)
                   NEXT FIELD aqf05
                END IF
                IF g_aqf[l_ac].aqf05 != g_aqf_t.aqf05 THEN
                   CALL cl_digcut(g_aqf[l_ac].aqf05,g_azi04)
                        RETURNING g_aqf[l_ac].aqf05
                   DISPLAY BY NAME g_aqf[l_ac].aqf05
                END IF
             ELSE
                CALL cl_err(g_aqf[l_ac].aqf05,'aap-201',1)
                NEXT FIELD aqf05
             END IF
          END IF  
 
       AFTER FIELD aqf13
           IF NOT cl_null(g_aqf[l_ac].aqf13) THEN
              LET g_sql = " SELECT COUNT(*) ",
                          #" FROM ",g_dbs_new CLIPPED ,"gec_file ",
                          " FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102
                          " WHERE gec01='",g_aqf[l_ac].aqf13 CLIPPED,"'",
                          "   AND gecacti='Y'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE t600_04 FROM g_sql
              DECLARE t600_04_cs CURSOR FOR t600_04
              OPEN t600_04_cs
              FETCH t600_04_cs INTO l_cnt
              IF cl_null(l_cnt) OR l_cnt = 0 THEN
                 CALL cl_err3("sel","gec_file",g_aqf[l_ac].aqf13,"",SQLCA.sqlcode,"","sel gec_file",0)
                 LET g_aqf[l_ac].aqf13 = g_aqf_t.aqf13
                 NEXT FIELD aqf13
              END IF 
              LET g_sql = "SELECT gec04",
                          #"  FROM ",g_dbs_new,"gec_file,",
                          "  FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102
                          " WHERE gec01 ='",g_aqf[l_ac].aqf13, 
                          "   AND gecacti='Y'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE t600_gec_p FROM g_sql
              DECLARE t600_gec_c CURSOR FOR t600_gec_p
              OPEN t600_gec_c 
              FETCH t600_gec_c INTO l_gec04
              IF l_gec04 !='0' THEN
                 CALL cl_err(g_aqf[l_ac].aqf13,'aap-985',1)
                 LET g_aqf[l_ac].aqf13 =NULL
                 NEXT FIELD aqf13
              END IF
           END IF
 
       AFTER FIELD aqf11   #帳款類型
           IF NOT cl_null(g_aqf[l_ac].aqf11) THEN
              LET g_sql = " SELECT COUNT(*) ",
                          #" FROM ",g_dbs_new CLIPPED ,"ool_file ",
                          " FROM ",cl_get_target_table(g_plant_new,'ool_file'), #FUN-A50102
                          " WHERE ool01='",g_aqf[l_ac].aqf11 CLIPPED,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE t600_01 FROM g_sql
              DECLARE t600_01_cs CURSOR FOR t600_01
              OPEN t600_01_cs
              FETCH t600_01_cs INTO l_cnt
              IF cl_null(l_cnt) OR l_cnt = 0 THEN
                 CALL cl_err3("sel","ool_file",g_aqf[l_ac].aqf11,"",SQLCA.sqlcode,"","sel ool_file",0)
                 LET g_aqf[l_ac].aqf11 = g_aqf_t.aqf11
                 NEXT FIELD aqf11
              END IF 
           END IF
     
       AFTER FIELD aqf12   #收款條件
           IF NOT cl_null(g_aqf[l_ac].aqf12) THEN
              LET g_sql = " SELECT COUNT(*) ",
                          #" FROM ",g_dbs_new CLIPPED ,"oag_file ",
                          " FROM ",cl_get_target_table(g_plant_new,'oag_file'), #FUN-A50102
                          " WHERE oag01='",g_aqf[l_ac].aqf12 CLIPPED,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE t600_02 FROM g_sql
              DECLARE t600_02_cs CURSOR FOR t600_02
              OPEN t600_02_cs
              FETCH t600_02_cs INTO l_cnt
              IF cl_null(l_cnt) OR l_cnt = 0 THEN
                 CALL cl_err3("sel","oag_file",g_aqf[l_ac].aqf12,"",SQLCA.sqlcode,"","sel oag_file",0)
                 LET g_aqf[l_ac].aqf12 = g_aqf_t.aqf12
                 NEXT FIELD aqf12
              END IF 
           END IF
 
       AFTER FIELD aqf14   #內部帳戶
           IF NOT cl_null(g_aqf[l_ac].aqf14) THEN
              #LET g_sql=" SELECT COUNT(*) FROM ",g_dbs_new CLIPPED,"nma_file ",
              LET g_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102
                         "  WHERE nma01='",g_aqf[l_ac].aqf14,"' AND nma37='0' AND nmaacti='Y'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE t600_03 FROM g_sql
              DECLARE t600_03_cs CURSOR FOR t600_03
              OPEN t600_03_cs
              FETCH t600_03_cs INTO l_cnt
              IF cl_null(l_cnt) OR l_cnt = 0 THEN
                 CALL cl_err3("sel","nma_file",g_aqf[l_ac].aqf14,"",SQLCA.sqlcode,"","sel nma_file",0)
                 LET g_aqf[l_ac].aqf14 = g_aqf_t.aqf14
                 NEXT FIELD aqf14
              END IF 
           END IF
 
       AFTER FIELD aqf15   #異動碼
           IF NOT cl_null(g_aqf[l_ac].aqf15) THEN
              LET g_sql = " SELECT COUNT(*) ",
                          #" FROM ",g_dbs_new CLIPPED ,"nmc_file ",
                          " FROM ",cl_get_target_table(g_plant_new,'nmc_file'), #FUN-A50102
                          " WHERE nmc01='",g_aqf[l_ac].aqf15 CLIPPED,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE t600_05 FROM g_sql
              DECLARE t600_05_cs CURSOR FOR t600_05
              OPEN t600_05_cs
              FETCH t600_05_cs INTO l_cnt
              IF cl_null(l_cnt) OR l_cnt = 0 THEN
                 CALL cl_err3("sel","nmc_file",g_aqf[l_ac].aqf15,"",SQLCA.sqlcode,"","sel nmc_file",0)
                 LET g_aqf[l_ac].aqf15 = g_aqf_t.aqf15
                 NEXT FIELD aqf15
              END IF 
           END IF
 
        AFTER FIELD aqfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_aqf_t.aqf02 > 0 AND
             g_aqf_t.aqf02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM aqf_file
              WHERE aqf01 = g_aqe.aqe01
                AND aqf02 = g_aqf_t.aqf02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","aqf_file",g_aqe.aqe01,g_aqf_t.aqf02,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn4
             LET g_plant_new = g_aqf_t.aqf03 CALL s_getdbs()
             IF g_success='Y' THEN
                CALL t600_b_aqf_tot()
                COMMIT WORK
                 LET l_aqe15 = '0'    
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_aqf[l_ac].* = g_aqf_t.*
             CLOSE t600_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_aqf[l_ac].aqf02,-263,1)
             LET g_aqf[l_ac].* = g_aqf_t.*
          ELSE
             UPDATE aqf_file SET aqf02 = g_aqf[l_ac].aqf02,
                                 aqf03 = g_aqf[l_ac].aqf03,
                                 aqf04 = g_aqf[l_ac].aqf04,
                                 aqf05f= g_aqf[l_ac].aqf05f,
                                 aqf05 = g_aqf[l_ac].aqf05,
                                 aqf06 = g_aqf[l_ac].aqf06,  
                                 aqf11 = g_aqf[l_ac].aqf11, 
                                 aqf12 = g_aqf[l_ac].aqf12, 
                                 aqf13 = g_aqf[l_ac].aqf13, 
                                 aqf14 = g_aqf[l_ac].aqf14, 
                                 aqf15 = g_aqf[l_ac].aqf15,
                                 aqfud01 = g_aqf[l_ac].aqfud01,
                                 aqfud02 = g_aqf[l_ac].aqfud02,
                                 aqfud03 = g_aqf[l_ac].aqfud03,
                                 aqfud04 = g_aqf[l_ac].aqfud04,
                                 aqfud05 = g_aqf[l_ac].aqfud05,
                                 aqfud06 = g_aqf[l_ac].aqfud06,
                                 aqfud07 = g_aqf[l_ac].aqfud07,
                                 aqfud08 = g_aqf[l_ac].aqfud08,
                                 aqfud09 = g_aqf[l_ac].aqfud09,
                                 aqfud10 = g_aqf[l_ac].aqfud10,
                                 aqfud11 = g_aqf[l_ac].aqfud11,
                                 aqfud12 = g_aqf[l_ac].aqfud12,
                                 aqfud13 = g_aqf[l_ac].aqfud13,
                                 aqfud14 = g_aqf[l_ac].aqfud14,
                                 aqfud15 = g_aqf[l_ac].aqfud15
              WHERE aqf01=g_aqe.aqe01 AND aqf02=g_aqf_t.aqf02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","aqf_file",g_aqe.aqe01,g_aqf_t.aqf02,SQLCA.sqlcode,"","",1) 
                LET g_aqf[l_ac].* = g_aqf_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                IF g_success='Y' THEN
                   COMMIT WORK
                   LET l_aqe15 = '0'      
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_action_choice=NULL       #No.FUN-A40055
             IF p_cmd = 'u' THEN
                LET g_aqf[l_ac].* = g_aqf_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_aqf.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET g_b_flag='1'
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end--
             END IF
             CLOSE t600_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032
          CLOSE t600_b2cl
          COMMIT WORK
          CALL t600_b_aqf_tot()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(aqf03)   
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_aqf[l_ac].aqf03
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf03
               DISPLAY g_aqf[l_ac].aqf03 TO aqf03
            WHEN INFIELD(aqf11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ool01"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03 #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf11
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf11
               DISPLAY BY NAME g_aqf[l_ac].aqf11
               NEXT FIELD aqf11  
            WHEN INFIELD(aqf12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oag01"
               LET g_qryparam.plant= g_aqf[l_ac].aqf03 #No.FUN-980025 add 
               LET g_qryparam.default1 = g_aqf[l_ac].aqf12
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf12
               DISPLAY BY NAME g_aqf[l_ac].aqf12
               NEXT FIELD aqf12
            WHEN INFIELD(aqf13)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec3"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03 #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf13
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf13
               DISPLAY BY NAME g_aqf[l_ac].aqf13
               NEXT FIELD aqf13
            WHEN INFIELD(aqf14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nma6"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03 #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf14
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf14
               DISPLAY BY NAME g_aqf[l_ac].aqf14
               NEXT FIELD aqf14 
            WHEN INFIELD(aqf15)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nmc03"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03 #No.FUN-980025 add
               IF g_aqf[l_ac].aqf03 =g_plant THEN
                  LET g_qryparam.arg1 ='1'  #No.FUN-980025 mark
               ELSE
                  LET g_qryparam.arg1 ='2'
               END IF
               LET g_qryparam.default1 = g_aqf[l_ac].aqf15
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf15
               DISPLAY BY NAME g_aqf[l_ac].aqf15
               NEXT FIELD aqf15 
            WHEN INFIELD(aqf04)  
               CALL q_oma5(FALSE,TRUE,g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf02,
                           g_aqf[l_ac].aqf03,g_aqe.aqe03,'1*')              
                    RETURNING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf05f,   
                              g_aqf[l_ac].aqf05,g_aqf[l_ac].aqf06   
               DISPLAY g_aqf[l_ac].aqf04 TO aqf04
               DISPLAY g_aqf[l_ac].aqf06 TO aqf06  
               DISPLAY g_aqf[l_ac].aqf05 TO aqf05      
               DISPLAY g_aqf[l_ac].aqf05f TO aqf05f  
               NEXT FIELD aqf04
            OTHERWISE
               EXIT CASE
         END CASE
 
       ON ACTION CONTROLS                        #No.FUN-6A0092
          CALL cl_set_head_visible("","AUTO")    #No.FUN-6A0092
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aqf02) AND l_ac > 1 THEN
               LET g_aqf[l_ac].* = g_aqf[l_ac-1].*
               LET g_aqf[l_ac].aqf02 = NULL 
               NEXT FIELD aqf02
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
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
 
   UPDATE aqe_file SET aqemodu=g_aqe.aqemodu,aqe15=l_aqe15,
                       aqedate=g_aqe.aqedate
    WHERE aqe01=g_aqe.aqe01
   LET g_aqe.aqe15 = l_aqe15
   DISPLAY BY NAME g_aqe.aqe15
   IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
 
   IF g_aqe.aqe09f != 0 AND g_aqe.aqe09f != g_aqe.aqe08f THEN
      WHILE TRUE
         IF g_aqe.aqe09f < g_aqe.aqe08f THEN                 # 不足
            CALL cl_getmsg('axr-942',g_lang) RETURNING g_msg
         END IF
         IF g_aqe.aqe09f > g_aqe.aqe08f THEN                 # 超過
            CALL cl_getmsg('axr-942',g_lang) RETURNING g_msg
         END IF
         WHILE TRUE
            LET g_chr=' '
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED FOR CHAR g_chr
               ON IDLE g_idle_seconds
                  CALL cl_on_idle() 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 END IF
            IF g_chr MATCHES "[12Ee]" THEN EXIT WHILE END IF
         END WHILE
         IF g_chr MATCHES '[Ee]' THEN LET l_exit_sw = 'y' EXIT WHILE END IF
         IF g_chr = '2' THEN LET l_exit_sw = 'n' EXIT WHILE END IF
         IF g_chr = '1' THEN
            LET l_n = ARR_COUNT()
            CALL t600_b_aqg()
         END IF
         EXIT WHILE
      END WHILE
   END IF
 
   IF l_exit_sw = 'y' THEN
      EXIT WHILE
   ELSE
      CONTINUE WHILE
   END IF
   END WHILE
 
   CALL t600_b_aqf_tot()
   CLOSE t600_b2cl
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t600_b_aqf_tot()  #更新單頭帳款金額
   SELECT SUM(aqf05f),SUM(aqf05) INTO g_aqe.aqe08f,g_aqe.aqe08 FROM aqf_file
    WHERE aqf01=g_aqe.aqe01
   IF g_aqe.aqe08f IS NULL THEN LET g_aqe.aqe08f=0 END IF
   IF g_aqe.aqe08  IS NULL THEN LET g_aqe.aqe08 =0 END IF
   DISPLAY BY NAME g_aqe.aqe08f,g_aqe.aqe08
   UPDATE aqe_file SET aqe08f=g_aqe.aqe08f,
                       aqe08 =g_aqe.aqe08
    WHERE aqe01=g_aqe.aqe01
END FUNCTION
 
FUNCTION t600_b_aqg_tot()   #更新單頭收款金額
   SELECT SUM(aqg06f),SUM(aqg06) INTO g_aqe.aqe09f,g_aqe.aqe09 FROM aqg_file
    WHERE aqg01=g_aqe.aqe01
   IF g_aqe.aqe09f IS NULL THEN LET g_aqe.aqe09f=0 END IF
   IF g_aqe.aqe09  IS NULL THEN LET g_aqe.aqe09 =0 END IF
   DISPLAY BY NAME g_aqe.aqe09f,g_aqe.aqe09
   UPDATE aqe_file SET aqe09f=g_aqe.aqe09f,
                       aqe09 =g_aqe.aqe09
    WHERE aqe01=g_aqe.aqe01
END FUNCTION
 
FUNCTION t600_aqf04(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1    
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6
   DEFINE l_oma00         LIKE oma_file.oma00
   DEFINE l_oma03         LIKE oma_file.oma03
   DEFINE l_oma032        LIKE oma_file.oma032
   DEFINE l_omaconf       LIKE oma_file.omaconf
   DEFINE l_omavoid       LIKE oma_file.omavoid
   DEFINE l_omc08         LIKE omc_file.omc08 
   DEFINE l_omc09         LIKE omc_file.omc09 
   DEFINE l_omc10         LIKE omc_file.omc10 
   DEFINE l_omc11         LIKE omc_file.omc11
   DEFINE l_omc13         LIKE omc_file.omc13
   DEFINE l_omc06         LIKE omc_file.omc06
   DEFINE l_omc07         LIKE omc_file.omc07
   DEFINE l_oma23         LIKE oma_file.oma23
   DEFINE l_aqf05f        LIKE aqf_file.aqf05f
   DEFINE l_aqf05         LIKE aqf_file.aqf05
   DEFINE l_amt3          LIKE apa_file.apa73  
   DEFINE g_t1            LIKE oay_file.oayslip   #CHAR(5)
 
   LET g_errno = ' '
   LET g_plant_new = g_aqf[l_ac].aqf03
   CALL s_getdbs()
   
   IF g_ooz.ooz07 = 'N' THEN                          
      LET g_sql = "SELECT omc04,oma23,omc06,omc08-omc10,omc09-omc11, ",
                  "       oma03,oma032,oma00,omaconf,omavoid ",
                  #"  FROM ",g_dbs_new,"oma_file, ",
                  #          g_dbs_new,"omc_file  ",
                  "  FROM ",cl_get_target_table(g_aqf[l_ac].aqf03,'oma_file'),",", #FUN-A50102
                            cl_get_target_table(g_aqf[l_ac].aqf03,'omc_file'),     #FUN-A50102
                  "  WHERE omc01 = ? AND omc02=? ",
                  "    AND oma01 = omc01 ",
                  "    AND oma00[1,1] = '1'"
   ELSE
      LET g_sql = "SELECT omc04,oma23,omc06,omc08-omc10,omc13, ",
                  "       oma03,oma032,oma00,omaconf,omavoid ",
                  #"  FROM ",g_dbs_new,"oma_file, ",
                  #          g_dbs_new,"omc_file  ",
                  "  FROM ",cl_get_target_table(g_aqf[l_ac].aqf03,'oma_file'),",", #FUN-A50102
                            cl_get_target_table(g_aqf[l_ac].aqf03,'omc_file'),     #FUN-A50102
                  "  WHERE omc01 = ? AND omc02=? ",
                  "    AND oma01 = omc01 ",
                  "    AND oma00[1,1] = '1'"
   END IF
   
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_aqf[l_ac].aqf03) RETURNING g_sql #FUN-A50102
   PREPARE t600_p3 FROM g_sql DECLARE t600_c3 CURSOR FOR t600_p3
   OPEN t600_c3 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06 
       
   FETCH t600_c3 INTO g_aqf[l_ac].omc04,g_aqf[l_ac].oma23,g_aqf[l_ac].omc06,
                      l_amtf,l_amt,l_oma03,l_oma032,l_oma00,l_omaconf,l_omavoid
 
   DISPLAY BY NAME g_aqf[l_ac].omc04
   DISPLAY BY NAME g_aqf[l_ac].oma23
   DISPLAY BY NAME g_aqf[l_ac].omc06
 
   IF p_cmd = 'd' THEN RETURN END IF
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axr-937'  
      WHEN l_omaconf  = 'N'       LET g_errno = 'aap-141'
      WHEN l_omavoid  = 'Y'       LET g_errno = 'aap-165'
      WHEN l_oma03 != g_aqe.aqe03 LET g_errno = 'aap-040'
      WHEN l_oma032!= g_aqe.aqe11 LET g_errno = 'aap-155'
      WHEN l_oma23 != g_aqe.aqe06 LET g_errno = 'aap-041'
      WHEN l_amtf<=0 AND l_amt<=0 LET g_errno = 'aap-076'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   LET g_sql = " SELECT omc08 ,omc10 ,omc09,omc11,omc06,omc07,omc13 ",  
               #"   FROM ",g_dbs_new CLIPPED,"omc_file ",
               "   FROM ",cl_get_target_table(g_aqf[l_ac].aqf03,'omc_file'), #FUN-A50102
               "  WHERE omc01= ? ",
               "    AND omc02= ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_aqf[l_ac].aqf03) RETURNING g_sql #FUN-A50102
   PREPARE t600_str1 FROM g_sql
   DECLARE t600_z1 CURSOR FOR t600_str1
   OPEN t600_z1 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06 
   FETCH t600_z1 INTO l_omc08 ,l_omc10 ,l_omc09,l_omc11,l_omc06,l_omc07,l_omc13  
 
   CLOSE t600_z1
 
   SELECT SUM(aqf05f),SUM(aqf05) INTO l_aqf05f,l_aqf05
     FROM aqf_file,aqe_file
    WHERE aqf04=g_aqf[l_ac].aqf04
      AND aqf06=g_aqf[l_ac].aqf06 
      AND aqf01<>g_aqe.aqe01
      AND aqf01=aqe01 AND aqe14='N'
   IF cl_null(l_aqf05f) THEN LET l_aqf05f = 0 END IF
   IF cl_null(l_aqf05)  THEN LET l_aqf05 = 0 END IF
 
   IF l_aqf05f > l_amtf OR 
      l_aqf05 > l_amt THEN 
      LET g_errno='axr-946'
   END IF
 
   IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_aqf[l_ac].aqf05f= l_amtf
   LET g_aqf[l_ac].aqf05 = l_amt
   IF g_aqf[l_ac].oma23 != g_aza.aza17 THEN
      LET l_amt3 = g_aqf[l_ac].aqf05f * g_aqf[l_ac].omc06 
      #未付金額-已KEY未確認
      LET g_aqf[l_ac].aqf05 = l_amt3 - l_aqf05 
      CALL cl_digcut(g_aqf[l_ac].aqf05,g_azi04) RETURNING g_aqf[l_ac].aqf05
   END IF
   DISPLAY BY NAME g_aqf[l_ac].aqf05
   DISPLAY BY NAME g_aqf[l_ac].aqf05f
END FUNCTION
 
FUNCTION t600_b_aqg()
   DEFINE l_nmh            RECORD LIKE nmh_file.*
   DEFINE l_nmg            RECORD LIKE nmg_file.*
   DEFINE l_npk            RECORD LIKE npk_file.*
   DEFINE l_amt            LIKE nmh_file.nmh40
   DEFINE l_flag           LIKE type_file.chr1
   DEFINE l_flag1          LIKE type_file.chr1
   DEFINE m_npk01          LIKE npk_file.npk01
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用
    n               LIKE type_file.num5,                #檢查重複用  
    l_n1            LIKE type_file.num5,                #檢查重複用 
    l_cnt           LIKE type_file.num5,  
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    l_exit_sw       LIKE type_file.chr1,   
    l_t1            LIKE type_file.chr3, 
    l_aqe15         LIKE aqe_file.aqe15,  
    l_aqg08         LIKE aqg_file.aqg08,  
    l_aqg09         LIKE aqg_file.aqg09,  
    l_aqg10         LIKE aqg_file.aqg10,  
    l_aqg11         LIKE aqg_file.aqg11,  
    l_aqg14         LIKE aqg_file.aqg14,  
    l_aqg15         LIKE aqg_file.aqg15,  
    l_aqg06         LIKE aqg_file.aqg06,  
    l_aqg06f        LIKE aqg_file.aqg06f  
DEFINE
    l_amt3          LIKE apa_file.apa72,
    l_aqg05         LIKE aqg_file.aqg05,
    l_aqg051        LIKE aqg_file.aqg051,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #SMALLINT
    l_aqg07         LIKE aqg_file.aqg07,  
    l_nma28         LIKE nma_file.nma28  
    DEFINE l_plant  LIKE aqg_file.aqg03
    DEFINE l_azp03  LIKE azp_file.azp03
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aqe.aqe01 IS NULL THEN RETURN END IF
    SELECT * INTO g_aqe.* FROM aqe_file
     WHERE aqe01=g_aqe.aqe01
    LET l_aqe15 = g_aqe.aqe15  
    IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_aqe.aqeacti ='N' THEN CALL cl_err(g_aqe.aqe01,'9027',0) RETURN END IF
    IF g_aqe.aqe15 matches '[Ss]' THEN      
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
 
   SELECT COUNT(*) INTO g_rec_b2 FROM aqg_file WHERE aqg01=g_aqe.aqe01           
   IF g_rec_b2 = 0 THEN                                                          
      CALL t600_g_b_aqg()            # Auto Generate Body                           
      CALL t600_b_aqg_fill(' 1=1')                                                  
   END IF                        
 
    LET g_forupd_sql = "SELECT aqg02,aqg03,aqg04,aqg14,aqg15,aqg08,aqg05,",
                       "       aqg051,aqg11,'',aqg09,aqg10,aqg06f,aqg06,",  
                       "       aqgud01,aqgud02,aqgud03,aqgud04,aqgud05,",
                       "       aqgud06,aqgud07,aqgud08,aqgud09,aqgud10,",
                       "       aqgud11,aqgud12,aqgud13,aqgud14,aqgud15 ",
                       "  FROM aqg_file",
                       " WHERE aqg01=? AND aqg02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_aqe.aqemodu=g_user
    LET g_aqe.aqedate=g_today
    DISPLAY BY NAME g_aqe.aqemodu,g_aqe.aqedate
    CALL t600_b_aqg_fill(g_wc2)                 #單身
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE
    LET l_exit_sw = 'y'
    INPUT ARRAY g_aqg WITHOUT DEFAULTS FROM s_aqg.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           LET g_success = 'Y'
           OPEN t600_cl USING g_aqe.aqe01
           IF SQLCA.sqlcode THEN
              CALL cl_err("OPEN t600_cl:", SQLCA.sqlcode, 1)
              CLOSE t600_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t600_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_aqg_t.* = g_aqg[l_ac].*  #BACKUP
              LET l_flag = 'N'
              OPEN t600_bcl USING g_aqe.aqe01,g_aqg_t.aqg02
              IF SQLCA.sqlcode THEN
                 CALL cl_err("OPEN t600_bcl:", SQLCA.sqlcode, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t600_bcl INTO g_aqg[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aqg_t.aqg02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_sql = "SELECT nmc02 ",
              #" FROM ",g_dbs_new CLIPPED,"nmc_file ",
              " FROM ",cl_get_target_table(g_plant_new,'nmc_file'), #FUN-A50102
              " WHERE nmc01 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
              PREPARE nmc_13_p1 FROM g_sql
              DECLARE nmc_13_curs CURSOR FOR nmc_13_p1
              OPEN nmc_13_curs USING g_aqg[l_ac].aqg11
              FETCH nmc_13_curs INTO g_aqg[l_ac].nmc02
              CALL cl_show_fld_cont()     
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aqg[l_ac].* TO NULL
           LET g_aqg[l_ac].aqg03 = g_plant 
           LET g_plant_new = g_aqg[l_ac].aqg03
           CALL s_getdbs()
           LET g_aqg[l_ac].aqg06f = 0
           LET g_aqg[l_ac].aqg06  = 0
           LET g_aqg_t.* = g_aqg[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()    
           NEXT FIELD aqg02         
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_aqg[l_ac].aqg14) THEN
              CALL g_aqg.deleteElement(l_ac)
              NEXT FIELD aqg02
              CANCEL INSERT
           END IF
           INSERT INTO aqg_file(aqg00,aqg01,aqg02,aqg03,aqg04,aqg08,aqg14,aqg15,aqg05,aqg051,aqg11, 
                                aqg09,aqg10,aqg06f,aqg06,
                                aqgud01,aqgud02,aqgud03,
                                aqgud04,aqgud05,aqgud06,
                                aqgud07,aqgud08,aqgud09,
                                aqgud10,aqgud11,aqgud12,
                                aqgud13,aqgud14,aqgud15,
                                aqglegal)   #FUN-980011 add
            VALUES('1',g_aqe.aqe01,g_aqg[l_ac].aqg02,g_aqg[l_ac].aqg03,
                   g_aqg[l_ac].aqg04,g_aqg[l_ac].aqg08,g_aqg[l_ac].aqg14,g_aqg[l_ac].aqg15, 
                   g_aqg[l_ac].aqg05,g_aqg[l_ac].aqg051,g_aqg[l_ac].aqg11,  
                   g_aqg[l_ac].aqg09,g_aqg[l_ac].aqg10,
                   g_aqg[l_ac].aqg06f,g_aqg[l_ac].aqg06,  
                   g_aqg[l_ac].aqgud01,g_aqg[l_ac].aqgud02,
                   g_aqg[l_ac].aqgud03,g_aqg[l_ac].aqgud04,
                   g_aqg[l_ac].aqgud05,g_aqg[l_ac].aqgud06,
                   g_aqg[l_ac].aqgud07,g_aqg[l_ac].aqgud08,
                   g_aqg[l_ac].aqgud09,g_aqg[l_ac].aqgud10,
                   g_aqg[l_ac].aqgud11,g_aqg[l_ac].aqgud12,
                   g_aqg[l_ac].aqgud13,g_aqg[l_ac].aqgud14,
                   g_aqg[l_ac].aqgud15,
                   g_legal)     #FUN-980011 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aqg_file",g_aqe.aqe01,g_aqg[l_ac].aqg02,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
              IF g_success='Y' THEN
                 LET l_aqe15 = '0'      
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        BEFORE FIELD aqg02                        #default 序號
           IF g_aqg[l_ac].aqg02 IS NULL OR g_aqg[l_ac].aqg02 = 0 THEN
              SELECT max(aqg02)+1
                INTO g_aqg[l_ac].aqg02
                FROM aqg_file
               WHERE aqg01 = g_aqe.aqe01
              IF g_aqg[l_ac].aqg02 IS NULL THEN
                 LET g_aqg[l_ac].aqg02 = 1
              END IF
           END IF
 
        AFTER FIELD aqg02                        #check 序號是否重複
           IF NOT cl_null(g_aqg[l_ac].aqg02) THEN
              IF g_aqg[l_ac].aqg02 != g_aqg_t.aqg02 OR g_aqg_t.aqg02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM aqg_file
                  WHERE aqg01 = g_aqe.aqe01
                    AND aqg02 = g_aqg[l_ac].aqg02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aqg[l_ac].aqg02 = g_aqg_t.aqg02
                    NEXT FIELD aqg02
                 END IF
              END IF
           END IF
        AFTER FIELD aqg04
           IF NOT cl_null(g_aqg[l_ac].aqg04) THEN
              IF g_aqg[l_ac].aqg04 NOT MATCHES "[12]" THEN
                 NEXT FIELD aqg04
              END IF
              IF g_aqg[l_ac].aqg04 != g_aqg_t.aqg04 THEN
                 LET l_flag = 'Y'
              ELSE
                 LET l_flag = 'N'
              END IF
           END IF   
 
        AFTER FIELD aqg14
           IF NOT cl_null(g_aqg[l_ac].aqg14) THEN
              IF l_flag = 'N' AND
                 (p_cmd = 'u' AND g_aqg[l_ac].aqg14 = g_aqg_t.aqg14) THEN
                 LET l_flag1 = 'N'
              ELSE 
                 LET l_flag1 = 'Y'
              END IF
              IF g_aqg[l_ac].aqg04 = '1' THEN
                 LET g_sql = "SELECT COUNT(*) ",
                 #" FROM ",g_dbs_new CLIPPED,"nmh_file ",
                 " FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102
                 " WHERE nmh01 = ? AND nmh38 = 'Y' "
 	            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                   PREPARE nmh_count_p1 FROM g_sql
                   DECLARE nmh_count_curs CURSOR FOR nmh_count_p1
                   OPEN nmh_count_curs USING g_aqg[l_ac].aqg14
                   FETCH nmh_count_curs INTO l_n
                  IF l_n = 0 THEN
                     CALL cl_err(g_aqg[l_ac].aqg14,'axr-944',1)
                     NEXT FIELD aqg14
                  ELSE   #帶出后面的資料，并check金額
                     SELECT COUNT(*) INTO l_cnt FROM aqe_file,aqg_file
                       WHERE aqe01 = aqg01 
                         AND aqg14 = g_aqg[l_ac].aqg14 
                         AND aqe01 = g_aqe.aqe01  
                         AND aqe00 = '1'
                         AND aqe00 = aqg00
                     IF g_aqg_t.aqg14 IS NULL OR
                        g_aqg[l_ac].aqg14 != g_aqg_t.aqg14 THEN
                        IF l_cnt > 0 THEN
                           CALL cl_err('','aap-112',1)
                           NEXT FIELD aqg14
                        END IF
                     END IF
                     LET g_sql = "SELECT nmh_file.* ",
                     #" FROM ",g_dbs_new CLIPPED,"nmh_file ",
                     " FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102
                     " WHERE nmh01 = ? AND nmh38 = 'Y'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                     PREPARE nmh_check_p1 FROM g_sql
                     DECLARE nmh_check_curs CURSOR FOR nmh_check_p1
                     OPEN nmh_check_curs USING g_aqg[l_ac].aqg14
                     FETCH nmh_check_curs INTO l_nmh.*
                     LET l_amt = l_nmh.nmh40/l_nmh.nmh28   #原幣未衝金額
                     IF l_nmh.nmh40 = 0 THEN 
                        CALL cl_err(g_aqg[l_ac].aqg14,'aap-076',1)
                        NEXT FIELD aqg14
                     END IF                        
                     IF l_amt = 0 THEN 
                        CALL cl_err(g_aqg[l_ac].aqg14,'aap-076',1)
                        NEXT FIELD aqg14
                     END IF                        
                     IF l_nmh.nmh03 != g_aqe.aqe06 THEN 
                        CALL cl_err(l_nmh.nmh03,'aap-014',1)
                        NEXT FIELD aqg14
                     END IF                        
                     IF l_nmh.nmh11 != g_aqe.aqe03 THEN 
                        CALL cl_err(l_nmh.nmh11,'axr-947',1)
                        NEXT FIELD aqg14
                     END IF                        
                     IF p_cmd = 'a' OR (p_cmd ='u' AND g_aqg[l_ac].aqg14 != g_aqg_t.aqg14) THEN
                        LET g_aqg[l_ac].aqg08 = l_nmh.nmh06
                        LET g_aqg[l_ac].aqg05 = l_nmh.nmh26
                        LET g_aqg[l_ac].aqg051= l_nmh.nmh261
                        LET g_aqg[l_ac].aqg11 = ' '
                        LET g_aqg[l_ac].aqg15 = ' '
                        LET g_aqg[l_ac].nmc02 = ' '
                        LET g_aqg[l_ac].aqg09 = l_nmh.nmh03
                        LET g_aqg[l_ac].aqg10 = l_nmh.nmh28
                        LET g_aqg[l_ac].aqg06f= l_nmh.nmh02
                        LET g_aqg[l_ac].aqg06 = l_nmh.nmh32
                     END IF
                  END IF
               END IF
           END IF
 
        AFTER FIELD aqg15
           IF NOT cl_null(g_aqg[l_ac].aqg15) THEN
              IF g_aqg[l_ac].aqg04 = '2' THEN
                 LET g_sql = "SELECT COUNT(*) ",
                 #" FROM ",g_dbs_new CLIPPED,"nmg_file,",
                 #"      ",g_dbs_new CLIPPED,"npk_file ",
                 " FROM ",cl_get_target_table(g_plant_new,'nmg_file'),",", #FUN-A50102
                 "      ",cl_get_target_table(g_plant_new,'npk_file'),     #FUN-A50102
                 " WHERE nmg00 = ? AND npk01 = ? ",
                 "   AND nmgconf = 'Y' ",
                 "   AND nmg00 = npk00 "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                 PREPARE nmg_count_p1 FROM g_sql
                 DECLARE nmg_count_curs CURSOR FOR nmg_count_p1
                 OPEN nmg_count_curs USING g_aqg[l_ac].aqg14,g_aqg[l_ac].aqg15
                 FETCH nmg_count_curs INTO l_n
                 IF l_n = 0 THEN
                    CALL cl_err(g_aqg[l_ac].aqg14,'axr-945',1)
                    NEXT FIELD aqg14
                 ELSE   #帶出后面的資料，并check金額
                    SELECT COUNT(*) INTO l_cnt FROM aqe_file,aqg_file
                     WHERE aqe01 = aqg01 
                       AND aqg14 = g_aqg[l_ac].aqg14
                       AND aqg15 = g_aqg[l_ac].aqg15
                       AND aqe01 = g_aqe.aqe01 
                       AND aqe00 = '1'
                       AND aqe00 = aqg00
                    IF g_aqg_t.aqg14 IS NULL OR
                       g_aqg[l_ac].aqg14 != g_aqg_t.aqg14 OR  
                       g_aqg_t.aqg15 IS NULL OR
                       g_aqg[l_ac].aqg15 != g_aqg_t.aqg15 THEN
                       IF l_cnt > 0 THEN
                          CALL cl_err('','aap-112',1)
                          NEXT FIELD aqg14
                       END IF
                    END IF
                    LET g_sql = "SELECT nmg_file.*,npk_file.* ",
                    #" FROM ",g_dbs_new CLIPPED,"nmg_file, ",
                    #"      ",g_dbs_new CLIPPED,"npk_file ",
                    " FROM ",cl_get_target_table(g_plant_new,'nmg_file'),",", #FUN-A50102
                    "      ",cl_get_target_table(g_plant_new,'npk_file'),     #FUN-A50102
                    " WHERE nmg00 = ? ",
                    "   AND npk01 = ? ",
                    "   AND npk00 = nmg00 ",
                    "   AND nmgconf = 'Y'  ",
                    "   AND npk05 ='",g_aqe.aqe06,"'",
                    "   AND nmg18 ='",g_aqe.aqe03,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                    PREPARE nmg_check_p1 FROM g_sql
                    DECLARE nmg_check_curs CURSOR FOR nmg_check_p1
                    OPEN nmg_check_curs USING g_aqg[l_ac].aqg14,g_aqg[l_ac].aqg15
                    FETCH nmg_check_curs INTO l_nmg.*,l_npk.*
                    IF l_nmg.nmg23 = l_nmg.nmg24 THEN
                       CALL cl_err(g_aqg[l_ac].aqg14,'aap-076',1)
                       NEXT FIELD aqg14
                    END IF
                    LET l_nmh.nmh40 = (l_nmg.nmg23 -l_nmg.nmg24)*l_npk.npk06   #本幣未衝金額
                    LET l_amt = l_nmg.nmg23 - l_nmg.nmg24
                    IF l_amt = 0 THEN 
                       CALL cl_err(g_aqg[l_ac].aqg14,'aap-076',1)
                       NEXT FIELD aqg14
                    END IF                        
                    IF p_cmd = 'a' OR (p_cmd ='u' AND g_aqg[l_ac].aqg14 != g_aqg_t.aqg14) THEN
                       LET g_aqg[l_ac].aqg08 = l_npk.npk04
                       LET g_aqg[l_ac].aqg05 = l_npk.npk07
                       LET g_aqg[l_ac].aqg051= l_npk.npk072
                       LET g_aqg[l_ac].aqg11 = l_npk.npk02
                       LET g_sql = "SELECT nmc02 ",
                       #" FROM ",g_dbs_new CLIPPED,"nmc_file ",
                       " FROM ",cl_get_target_table(g_plant_new,'nmc_file'), #FUN-A50102
                       " WHERE nmc01 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                       PREPARE nmc_check_p1 FROM g_sql
                       DECLARE nmc_check_curs CURSOR FOR nmc_check_p1
                       OPEN nmc_check_curs USING g_aqg[l_ac].aqg11
                       FETCH nmc_check_curs INTO g_aqg[l_ac].nmc02
                       LET g_aqg[l_ac].aqg09 = l_npk.npk05
                       LET g_aqg[l_ac].aqg10 = l_npk.npk06
                       LET g_aqg[l_ac].aqg06f= l_npk.npk08
                       LET g_aqg[l_ac].aqg06 = l_npk.npk09
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqg06f
           IF NOT cl_null(g_aqg[l_ac].aqg06f) THEN
              IF g_aqg[l_ac].aqg06f > 0 THEN
                 LET l_aqg06f = 0
                 SELECT SUM(aqg06f) INTO l_aqg06f
                   FROM aqg_file,aqe_file
                  WHERE aqg00 = '1' AND aqg01 = aqe01
                    AND aqg14 = g_aqg[l_ac].aqg14
                    AND aqg04 = g_aqg[l_ac].aqg04
                    AND aqg03 = g_aqg[l_ac].aqg03
                    AND aqe14 = 'Y'
                 IF cl_null(l_aqg06f) THEN LET l_aqg06f = 0 END IF
                 IF l_flag = 'N' AND l_flag1 = 'N' THEN
                    IF l_amt < (l_aqg06f + g_aqg[l_ac].aqg06f - g_aqg_t.aqg06f) THEN
                       CALL cl_err('','axr-946',1)
                       NEXT FIELD aqg06f
                    END IF
                    ELSE
                    IF l_amt < (l_aqg06f + g_aqg[l_ac].aqg06f ) THEN
                       CALL cl_err('','axr-946',1)
                       NEXT FIELD aqg06f
                    END IF
                 END IF
              ELSE
                 CALL cl_err(g_aqg[l_ac].aqg06f,'aap-201',1)
                 NEXT FIELD aqg06f
              END IF
           END IF
 
        BEFORE FIELD aqg06
           IF g_aqg[l_ac].aqg06f != g_aqg_t.aqg06f OR 
              g_aqg[l_ac].aqg06 = 0 OR cl_null(g_aqg[l_ac].aqg06) THEN
              LET g_aqg[l_ac].aqg06 = g_aqg[l_ac].aqg06f * g_aqg[l_ac].aqg10 
              CALL cl_digcut(g_aqg[l_ac].aqg06,g_azi04) RETURNING g_aqg[l_ac].aqg06
           END IF
           DISPLAY BY NAME g_aqg[l_ac].aqg06
 
        AFTER FIELD aqg06
           IF NOT cl_null(g_aqg[l_ac].aqg06) THEN
              IF g_aqg[l_ac].aqg06 > 0 THEN
                 LET l_aqg06 = 0
                 SELECT SUM(aqg06) INTO l_aqg06
                   FROM aqg_file,aqe_file
                  WHERE aqg00 = '1' AND aqg01 = aqe01
                    AND aqg14 = g_aqg[l_ac].aqg14
                    AND aqg04 = g_aqg[l_ac].aqg04
                    AND aqg03 = g_aqg[l_ac].aqg03
                    AND aqe14 = 'Y'
                 IF cl_null(l_aqg06) THEN LET l_aqg06 = 0 END IF
                 IF l_flag = 'N' AND l_flag1 = 'N' THEN
                    IF l_nmh.nmh40 < (l_aqg06 + g_aqg[l_ac].aqg06 - g_aqg_t.aqg06) THEN
                       CALL cl_err('','axr-946',1)
                       NEXT FIELD aqg06
                    END IF
                    ELSE
                    IF l_nmh.nmh40 < (l_aqg06 + g_aqg[l_ac].aqg06 ) THEN
                       CALL cl_err('','axr-946',1)
                       NEXT FIELD aqg06
                    END IF
                 END IF
              ELSE
                 CALL cl_err(g_aqg[l_ac].aqg06,'aap-201',1)
                 NEXT FIELD aqg06
              END IF
           END IF
 
        AFTER FIELD aqgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_aqg_t.aqg02 > 0 AND g_aqg_t.aqg02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM aqg_file
               WHERE aqg01 = g_aqe.aqe01
                 AND aqg02 = g_aqg_t.aqg02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","aqg_file",g_aqe.aqe01,g_aqg_t.aqg02,SQLCA.sqlcode,"","",1)
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
              IF g_success='Y' THEN
                  LET l_aqe15 = '0'     
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
           CALL t600_b_aqg_tot()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aqg[l_ac].* = g_aqg_t.*
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aqg[l_ac].aqg02,-263,1)
               LET g_aqg[l_ac].* = g_aqg_t.*
            ELSE
               UPDATE aqg_file SET aqg02 = g_aqg[l_ac].aqg02,
                                   aqg03 = g_aqg[l_ac].aqg03,
                                   aqg04 = g_aqg[l_ac].aqg04,  
                                   aqg08 = g_aqg[l_ac].aqg08, 
                                   aqg14 = g_aqg[l_ac].aqg14,
                                   aqg15 = g_aqg[l_ac].aqg15,
                                   aqg05 = g_aqg[l_ac].aqg05,
                                   aqg051= g_aqg[l_ac].aqg051,
                                   aqg11 = g_aqg[l_ac].aqg11,
                                   aqg09 = g_aqg[l_ac].aqg09,
                                   aqg10 = g_aqg[l_ac].aqg10,
                                   aqg06f= g_aqg[l_ac].aqg06f,
                                   aqg06 = g_aqg[l_ac].aqg06,
                                   aqgud01 = g_aqg[l_ac].aqgud01,
                                   aqgud02 = g_aqg[l_ac].aqgud02,
                                   aqgud03 = g_aqg[l_ac].aqgud03,
                                   aqgud04 = g_aqg[l_ac].aqgud04,
                                   aqgud05 = g_aqg[l_ac].aqgud05,
                                   aqgud06 = g_aqg[l_ac].aqgud06,
                                   aqgud07 = g_aqg[l_ac].aqgud07,
                                   aqgud08 = g_aqg[l_ac].aqgud08,
                                   aqgud09 = g_aqg[l_ac].aqgud09,
                                   aqgud10 = g_aqg[l_ac].aqgud10,
                                   aqgud11 = g_aqg[l_ac].aqgud11,
                                   aqgud12 = g_aqg[l_ac].aqgud12,
                                   aqgud13 = g_aqg[l_ac].aqgud13,
                                   aqgud14 = g_aqg[l_ac].aqgud14,
                                   aqgud15 = g_aqg[l_ac].aqgud15
                WHERE aqg01 = g_aqe.aqe01
                  AND aqg02 = g_aqg_t.aqg02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","aqg_file",g_aqe.aqe01,g_aqg_t.aqg02,SQLCA.sqlcode,"","",1) 
                  LET g_aqg[l_ac].* = g_aqg_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  UPDATE aqe_file SET aqemodu=g_user,aqedate=g_today
                   WHERE aqe01=g_aqe.aqe01
                  IF g_success='Y' THEN
                     LET l_aqe15 = '0'        
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_action_choice=NULL       #No.FUN-A40055
               IF p_cmd = 'u' THEN
                  LET g_aqg[l_ac].* = g_aqg_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aqg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET g_b_flag='1'
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            CLOSE t600_bcl
            COMMIT WORK
            CALL t600_b_aqg_tot()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqg03)   #營運中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg03
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg03
                 DISPLAY g_aqg[l_ac].aqg03 TO aqg03
              WHEN INFIELD(aqg14)   
                 CALL cl_init_qry_var()
                 IF g_aqg[l_ac].aqg04 = '2' THEN
                    LET g_qryparam.form ="q_nmg2"
                    LET g_qryparam.arg1 = g_aqe.aqe03
                    LET g_qryparam.arg2 = g_aqe.aqe06
                    LET g_qryparam.default1 = g_aqg[l_ac].aqg14
                    LET g_qryparam.default2 = g_aqg[l_ac].aqg15
                    CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg14,g_aqg[l_ac].aqg15
                 ELSE
                    LET g_qryparam.form ="q_nmh2"
                    LET g_qryparam.arg1 = g_aqe.aqe03
                    LET g_qryparam.arg2 = g_aqe.aqe06
                    LET g_qryparam.default1 = g_aqg[l_ac].aqg14
                    CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg14
                    LET g_aqg[l_ac].aqg15 = ' '
                 END IF
                 DISPLAY g_aqg[l_ac].aqg14 TO aqg14
                 DISPLAY g_aqg[l_ac].aqg15 TO aqg15
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aqg02) AND l_ac > 1 THEN
               LET g_aqg[l_ac].* = g_aqg[l_ac-1].*
               LET g_aqg[l_ac].aqg02 = NULL 
               NEXT FIELD aqg02
           END IF
 
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
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
 
   IF g_action_choice = "detail" THEN RETURN END IF #FUN-D30032
   UPDATE aqe_file SET aqemodu=g_aqe.aqemodu,aqe15=l_aqe15, 
                       aqedate=g_aqe.aqedate
   WHERE aqe01=g_aqe.aqe01
   LET g_aqe.aqe15 = l_aqe15
   DISPLAY BY NAME g_aqe.aqe15
   IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
 
   IF l_exit_sw = 'y' THEN                                                     
      EXIT WHILE                                                               
   ELSE                                                                        
      CONTINUE WHILE 
   END IF
 
   END WHILE
 
   CALL t600_b_aqg_tot()
   CLOSE t600_bcl
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_b_aqf_fill(p_wc3)
DEFINE
    p_wc3         STRING       #NO.FUN-910082
 
    LET g_sql = "SELECT aqf02,aqf03,aqf04,aqf06,'','','',",
                "       aqf05f,aqf05,aqf11,aqf12,aqf13,aqf14,aqf15,",
                "       aqfud01,aqfud02,aqfud03,aqfud04,aqfud05,",
                "       aqfud06,aqfud07,aqfud08,aqfud09,aqfud10,",
                "       aqfud11,aqfud12,aqfud13,aqfud14,aqfud15 ",
                "  FROM aqf_file",
                " WHERE aqf01 ='",g_aqe.aqe01,"'",
                "   AND ",p_wc3 CLIPPED,
                " ORDER BY aqf02"
    PREPARE t600_pb FROM g_sql
    DECLARE aqf_curs                       CURSOR FOR t600_pb
 
    CALL g_aqf.clear()
    LET l_ac = 1
    FOREACH aqf_curs INTO g_aqf[l_ac].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
      LET g_plant_new = g_aqf[l_ac].aqf03
      CALL s_getdbs()
      LET g_sql = "SELECT omc04,oma23,omc06 ",
                  #"   FROM ",g_dbs_new CLIPPED,"oma_file, ",
                  #           g_dbs_new CLIPPED,"omc_file  ",
                  "   FROM ",cl_get_target_table(g_aqf[l_ac].aqf03,'oma_file'),",", #FUN-A50102
                             cl_get_target_table(g_aqf[l_ac].aqf03,'omc_file'),     #FUN-A50102
                 "  WHERE omc01 = ? AND omc02= ? ",
                 "    AND oma01 = omc01 ",
                 "    AND oma00[1,1] = '1'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_aqf[l_ac].aqf03) RETURNING g_sql #FUN-A50102
      PREPARE t600_str6 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('sel omc',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DECLARE z9_curs CURSOR FOR t600_str6
      OPEN z9_curs USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
      FETCH z9_curs INTO g_aqf[l_ac].omc04,g_aqf[l_ac].oma23,g_aqf[l_ac].omc06
      CLOSE z9_curs
      CALL t600_aqf04('d')
      LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_aqf.deleteElement(l_ac)
    LET g_rec_b = l_ac-1
    LET g_dbs_new = ''
    DISPLAY g_rec_b TO FORMONLY.cn4
END FUNCTION
 
FUNCTION t600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #No.FUN-A40055--begin
#     DISPLAY ARRAY g_aqg TO s_aqg.* ATTRIBUTE(COUNT=g_rec_b2)
#         BEFORE DISPLAY
#            EXIT DISPLAY
#      
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE DISPLAY
#         ON ACTION about         
#            CALL cl_about()      
#         ON ACTION help          
#            CALL cl_show_help()  
#         ON ACTION controlg      
#            CALL cl_cmdask()     
#      
#         AFTER DISPLAY
#            CONTINUE DISPLAY
#      
#         ON ACTION controls                       #No.FUN-6A0092                                                                       
#            CALL cl_set_head_visible("","AUTO")   #No.FUN-6A0092
#      
#         &include "qry_string.4gl"
#      END DISPLAY
#      
#      DISPLAY ARRAY g_aqf TO s_aqf.* ATTRIBUTE(COUNT=g_rec_b)
#         BEFORE DISPLAY
#            CALL cl_navigator_setting( g_curs_index, g_row_count )
#      
#         BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()         
#      
#         ON ACTION insert
#            LET g_action_choice="insert"
#            EXIT DISPLAY
#      
#         ON ACTION query
#            LET g_action_choice="query"
#            EXIT DISPLAY
#      
#         ON ACTION delete
#            LET g_action_choice="delete"
#            EXIT DISPLAY
#      
#         ON ACTION modify
#            LET g_action_choice="modify"
#            EXIT DISPLAY
#      
#         ON ACTION first
#            CALL t600_fetch('F')
#            ACCEPT DISPLAY  
#            EXIT DISPLAY
#      
#         ON ACTION previous
#            CALL t600_fetch('P')
#            ACCEPT DISPLAY
#            EXIT DISPLAY
#      
#         ON ACTION jump
#            CALL t600_fetch('/')
#            ACCEPT DISPLAY 
#            EXIT DISPLAY
#      
#         ON ACTION next
#            CALL t600_fetch('N')
#            ACCEPT DISPLAY  
#            EXIT DISPLAY
#      
#         ON ACTION last
#            CALL t600_fetch('L')
#            ACCEPT DISPLAY 
#            EXIT DISPLAY
#      
#         ON ACTION qry_receive_detail 
#            LET g_action_choice="qry_receive_detail"
#            EXIT DISPLAY
#      
#         ON ACTION help
#            LET g_action_choice="help"
#            EXIT DISPLAY
#      
#         ON ACTION locale
#            CALL cl_dynamic_locale()
#            CALL cl_show_fld_cont()          
#            IF g_aqe.aqe14 = 'X' THEN
#               LET g_void = 'Y' ELSE LET g_void = 'N'
#            END IF
#            IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#            CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
#            EXIT DISPLAY
#      
#         ON ACTION exit
#            LET g_action_choice="exit"
#            EXIT DISPLAY
#      
#         ON ACTION controls                             #No.FUN-6A0092
#            CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
#      
#         ON ACTION controlg
#            LET g_action_choice="controlg"
#            EXIT DISPLAY
#      
#         ON ACTION account_detail #帳款單身
#            LET g_action_choice="account_detail"
#            EXIT DISPLAY
#         ON ACTION receive_detail #收款單身
#            LET g_action_choice="receive_detail"
#            EXIT DISPLAY
#      
#         ON ACTION easyflow_approval      
#           LET g_action_choice = "easyflow_approval"
#           EXIT DISPLAY
#      
#         ON ACTION confirm     #確認
#            LET g_action_choice="confirm"
#            EXIT DISPLAY
#      
#         ON ACTION undo_confirm     #取消確認
#            LET g_action_choice="undo_confirm"
#            EXIT DISPLAY
#      
#         ON ACTION agree
#            LET g_action_choice = 'agree'
#            EXIT DISPLAY
#      
#         ON ACTION deny
#            LET g_action_choice = 'deny'
#            EXIT DISPLAY
#      
#         ON ACTION modify_flow
#            LET g_action_choice = 'modify_flow'
#            EXIT DISPLAY
#      
#         ON ACTION withdraw
#            LET g_action_choice = 'withdraw'
#            EXIT DISPLAY
#      
#         ON ACTION org_withdraw
#            LET g_action_choice = 'org_withdraw'
#            EXIT DISPLAY
#      
#         ON ACTION phrase
#            LET g_action_choice = 'phrase'
#            EXIT DISPLAY
#      
#         ON ACTION void   #作廢
#            LET g_action_choice="void"
#            EXIT DISPLAY
#      
#         ON ACTION accept
#            LET g_action_choice="payment_detail"
#            LET l_ac = ARR_CURR()
#            EXIT DISPLAY
#      
#         ON ACTION cancel
#            LET INT_FLAG=FALSE 		
#            LET g_action_choice="exit"
#            EXIT DISPLAY
#      
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE DISPLAY
#      
#         ON ACTION about        
#            CALL cl_about()     
#      
#         ON ACTION ExportToExcel
#            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aqg),base.TypeInfo.create(g_aqf),'')
#            EXIT DISPLAY
#      
#       #@ON ACTION 簽核狀況
#         ON ACTION approval_status 
#            LET g_action_choice="approval_status"
#            EXIT DISPLAY
#      
#         &include "qry_string.4gl"
#      END DISPLAY  
         
   DIALOG ATTRIBUTES(UNBUFFERED)     
      DISPLAY ARRAY g_aqg TO s_aqg.* ATTRIBUTE(COUNT=g_rec_b2)    
         BEFORE DISPLAY     
          LET g_b_flag='1'        
      BEFORE ROW
         LET l_ac = DIALOG.getCurrentRow("s_aqg")
         CALL cl_show_fld_cont() 
      END DISPLAY
      
      DISPLAY ARRAY g_aqf TO s_aqf.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            LET g_b_flag='1'
            CALL cl_navigator_setting( g_curs_index, g_row_count )
      
         BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("s_aqf")
            CALL cl_show_fld_cont()         
     END DISPLAY 

         #NO.FUN-A40055--begin 
         BEFORE DIALOG 
            CALL cl_show_fld_cont()
         #NO.FUN-A40055--end 
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
            CALL t600_fetch('F')
            EXIT DIALOG
      
         ON ACTION previous
            CALL t600_fetch('P')
            EXIT DIALOG
      
         ON ACTION jump
            CALL t600_fetch('/')
            EXIT DIALOG
      
         ON ACTION next
            CALL t600_fetch('N')
            EXIT DIALOG
      
         ON ACTION last
            CALL t600_fetch('L')
            EXIT DIALOG
         #NO.FUN-A40055--begin 
        #ON ACTION qry_receive_detail 
        #   LET g_action_choice="qry_receive_detail"
        #   EXIT DIALOG
         #NO.FUN-A40055--end 
         
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
      
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()          
            IF g_aqe.aqe14 = 'X' THEN
               LET g_void = 'Y' ELSE LET g_void = 'N'
            END IF
            IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
            CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
            EXIT DIALOG
      
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ON ACTION controls                             #No.FUN-6A0092
            CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
      
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
      
         ON ACTION account_detail #帳款單身
            LET g_action_choice="account_detail"
            EXIT DIALOG
         ON ACTION receive_detail #收款單身
            LET g_action_choice="receive_detail"
            EXIT DIALOG
      
         ON ACTION easyflow_approval      
           LET g_action_choice = "easyflow_approval"
           EXIT DIALOG
      
         ON ACTION confirm     #確認
            LET g_action_choice="confirm"
            EXIT DIALOG
      
         ON ACTION undo_confirm     #取消確認
            LET g_action_choice="undo_confirm"
            EXIT DIALOG
      
         ON ACTION agree
            LET g_action_choice = 'agree'
            EXIT DIALOG
      
         ON ACTION deny
            LET g_action_choice = 'deny'
            EXIT DIALOG
      
         ON ACTION modify_flow
            LET g_action_choice = 'modify_flow'
            EXIT DIALOG
      
         ON ACTION withdraw
            LET g_action_choice = 'withdraw'
            EXIT DIALOG
      
         ON ACTION org_withdraw
            LET g_action_choice = 'org_withdraw'
            EXIT DIALOG
      
         ON ACTION phrase
            LET g_action_choice = 'phrase'
            EXIT DIALOG
      
         ON ACTION void   #作廢
            LET g_action_choice="void"
            EXIT DIALOG
#FUN-D20035 add 
         ON ACTION undo_void   #取消作廢
            LET g_action_choice="undo_void"
            EXIT DIALOG
#FUN-D20035 add            
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
               
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
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
      
         ON ACTION ExportToExcel
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aqg),base.TypeInfo.create(g_aqf),'')
            EXIT DIALOG
      
       #@ON ACTION 簽核狀況
         ON ACTION approval_status 
            LET g_action_choice="approval_status"
            EXIT DIALOG
      
          &include "qry_string.4gl"
      
   END DIALOG 
   #No.FUN-A40055--begin   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t600_b_aqg_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         STRING       #NO.FUN-910082
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT aqg02,aqg03,aqg04,aqg14,aqg15,aqg08,aqg05,aqg051,aqg11,'',aqg09,aqg10,",  
                "       aqg06f,aqg06,",
                "       aqgud01,aqgud02,aqgud03,aqgud04,aqgud05,",
                "       aqgud06,aqgud07,aqgud08,aqgud09,aqgud10,",
                "       aqgud11,aqgud12,aqgud13,aqgud14,aqgud15 ",
                " FROM aqg_file",
                " WHERE aqg01 ='",g_aqe.aqe01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY aqg02"
    PREPARE t600_pb2 FROM g_sql
    DECLARE aqg_curs CURSOR FOR t600_pb2
 
    CALL g_aqg.clear()
    LET g_cnt = 1
    FOREACH aqg_curs INTO g_aqg[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_plant_new=g_aqg[g_cnt].aqg03 CALL s_getdbs() 
       LET g_sql = "SELECT nmc02 ",
       #" FROM ",g_dbs_new CLIPPED,"nmc_file ",
       " FROM ",cl_get_target_table(g_aqg[g_cnt].aqg03,'nmc_file'), #FUN-A50102
       " WHERE nmc01 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_aqg[g_cnt].aqg03) RETURNING g_sql #FUN-A50102
       PREPARE nmc_14_p1 FROM g_sql
       DECLARE nmc_14_curs CURSOR FOR nmc_14_p1
       OPEN nmc_14_curs USING g_aqg[g_cnt].aqg11
       FETCH nmc_14_curs INTO g_aqg[g_cnt].nmc02
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_aqg.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_dbs_new = ''
END FUNCTION
 
FUNCTION t600_firm1_chk()
   DEFINE l_aqg03 LIKE aqg_file.aqg03,   
          g_sql   STRING  
 
   IF g_aqe.aqe14 = 'X' THEN
   #  CALL cl_err('','9024',0)                        #TQC-B10069
      CALL s_errmsg("aqe14","",g_aqe.aqe14,'9024',1)  #TQC-B10069
      LET g_success = 'N'
   #  RETURN    #TQC-B10069
   END IF
   IF g_aqe.aqe14 = 'Y' THEN
   #  CALL cl_err('','9023',0)                        #TQC-B10069 
      CALL s_errmsg("aqe14","",g_aqe.aqe14,'9023',1)  #TQC-B10069
      LET g_success = 'N'
   #  RETURN    #TQC-B10069
   END IF
   SELECT COUNT(*) INTO g_cnt FROM aqg_file WHERE aqg01 = g_aqe.aqe01
   IF g_cnt = 0 THEN 
   #  CALL cl_err('','amr-304',0)                   #TQC-B10069
      CALL s_errmsg("","",g_aqe.aqe01,'amr-304',1)  #TQC-B10069 
      LET g_success = 'N'
   #  RETURN    #TQC-B10069
   END IF
   SELECT COUNT(*) INTO g_cnt FROM aqf_file WHERE aqf01 = g_aqe.aqe01
   IF g_cnt = 0 THEN 
   #  CALL cl_err('','amr-304',0)                   #TQC-B10069
      CALL s_errmsg("","",g_aqe.aqe01,'amr-304',1)  #TQC-B10069
      LET g_success = 'N'
   #  RETURN    #TQC-B10069
   END IF

   #CHI-B10042 add --start--
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  
   THEN
      IF g_aqe.aqemksg='Y' THEN
         IF g_aqe.aqe15 != '1' THEN
            CALL s_errmsg("aqe15","",g_aqe.aqe15,'aws-078',1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
   #CHI-B10042 add --end--
END FUNCTION
 
#No.CHI-A80036   ----BEGIN---
FUNCTION t600_firm1_chk1()
 DEFINE  only_one  LIKE type_file.chr1 
 
   LET only_one = '1'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  
   THEN
      IF g_action_choice CLIPPED = "insert" THEN #CHI-B10042 add 
         IF g_aqe.aqemksg='Y' THEN
            IF g_aqe.aqe15 != '1' THEN
            #  CALL cl_err('','aws-078',1)                        #TQC-B10069   
               CALL s_errmsg("aqe15","",g_aqe.aqe15,'aws-078',1)  #TQC-B10069
               LET g_success = 'N'
            #  RETURN      #TQC-B10069
            END IF
         END IF
      END IF #CHI-B10042 add
 
      OPEN WINDOW t600_w6 AT 8,6 WITH FORM "axr/42f/axrt600_6"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("axrt600_6")
 
      LET only_one = '1'
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      INPUT BY NAME only_one WITHOUT DEFAULTS
         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
               END IF
               IF only_one = '1' AND g_aqe.aqe01 IS NULL OR g_aqe.aqe01= ' ' THEN
                  NEXT FIELD only_one
               END IF
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
         CLOSE WINDOW t600_w6
         RETURN
      END IF
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " aqe01 = '",g_aqe.aqe01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqe04,aqe05
 
            BEFORE CONSTRUCT
              CALL cl_qbe_init()
 
            ON ACTION controlp
              CASE
                 WHEN INFIELD(aqe01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_aqe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aqe01
                    NEXT FIELD aqe01
                 WHEN INFIELD(aqe04) # Employee CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aqe04
                 WHEN INFIELD(aqe05) # Dept CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aqe05
                 OTHERWISE EXIT CASE
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
 
      ON ACTION qbe_select
        CALL cl_qbe_select()
      ON ACTION qbe_save
        CALL cl_qbe_save()
		   
       END CONSTRUCT
       IF INT_FLAG THEN
          LET INT_FLAG=0
          CLOSE WINDOW t600_w6
          RETURN
       END IF
   END IF
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"   
   THEN
       IF NOT cl_confirm('aap-222') THEN
          LET g_success = 'N'
          CLOSE WINDOW t600_w6
          RETURN
       END IF
   END IF
#CHI-C30107 --------------- add -------------- begin
   IF only_one = '1' THEN 
      SELECT * INTO g_aqe.* FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      CALL t600_firm1_chk()
   END IF
#CHI-C30107 --------------- add -------------- end
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t600_w6
      RETURN
   END IF
   IF only_one != '1' THEN
      LET g_sql = " SELECT * FROM aqe_file WHERE ",g_wc CLIPPED
      PREPARE aqe_pre FROM g_sql
      DECLARE aqe_curs CURSOR FOR aqe_pre
      LET g_aqe_t.* = g_aqe.*
      FOREACH aqe_curs INTO g_aqe.*
         IF STATUS THEN
          # CALL cl_err('foreach:',STATUS,1)          #TQC-B10069
            CALL s_errmsg("","",'foreach:','STATUS',1)  #TQC-B10069
            LET g_success = 'N'
            EXIT FOREACH
         END IF 
         CALL t600_firm1_chk()
         IF g_success = 'N' THEN
         #  EXIT FOREACH             #TQC-B10069
            CONTINUE FOREACH         #TQC-B10069
         END IF
      END FOREACH
      LET g_aqe.* = g_aqe_t.*
      CLOSE WINDOW t600_w6   #TQC-B20128 add
   END IF
END FUNCTION 
#No.CHI-A80036   ---END---

FUNCTION t600_firm1_upd()
 DEFINE  only_one  LIKE type_file.chr1 
 DEFINE  l_amt     LIKE type_file.num20_6 
 DEFINE  l_aqe01   LIKE aqe_file.aqe01
 DEFINE  l_aqe02   LIKE aqe_file.aqe02
 DEFINE  l_aqe08f  LIKE aqe_file.aqe08f
 DEFINE  l_aqe09f  LIKE aqe_file.aqe09f
 DEFINE  l_aqf04   LIKE aqf_file.aqf04
 DEFINE  l_aqf03   LIKE aqf_file.aqf03  #No.TQC-6C0073
 DEFINE  l_aqf05   LIKE aqf_file.aqf05
 DEFINE  l_aqf06   LIKE aqf_file.aqf06
 DEFINE  l_omc11   LIKE omc_file.omc11
 DEFINE  l_omc09   LIKE omc_file.omc09
 DEFINE  l_oma00   LIKE oma_file.oma00
 
   LET g_success = 'Y'
#No.CHI-A80036  ---MARK---BEGIN
#
#  LET only_one = '1'
#
#  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"  
#  THEN
#     IF g_aqe.aqemksg='Y' THEN
#        IF g_aqe.aqe15 != '1' THEN
#           CALL cl_err('','aws-078',1)
#           LET g_success = 'N'
#           RETURN
#        END IF
#     END IF
#
#     OPEN WINDOW t600_w6 AT 8,6 WITH FORM "axr/42f/axrt600_6"
#           ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#     CALL cl_ui_locale("axrt600_6")
#
#     LET only_one = '1'
#     CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
#     INPUT BY NAME only_one WITHOUT DEFAULTS
#        AFTER FIELD only_one
#           IF NOT cl_null(only_one) THEN
#              IF only_one NOT MATCHES "[12]" THEN
#                 NEXT FIELD only_one
#              END IF
#              IF only_one = '1' AND g_aqe.aqe01 IS NULL OR g_aqe.aqe01= ' ' THEN
#                 NEXT FIELD only_one
#              END IF
#           END IF
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about        
#           CALL cl_about()     
#
#        ON ACTION help         
#           CALL cl_show_help()  
#
#        ON ACTION controlg      
#           CALL cl_cmdask()    
#
#     END INPUT
#
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW t600_w6
#        RETURN
#     END IF
#  END IF
#
#  IF only_one = '1' THEN
#     LET g_wc = " aqe01 = '",g_aqe.aqe01,"' "
#  ELSE
#     CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
#
#     CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqe04,aqe05
#
#           BEFORE CONSTRUCT
#             CALL cl_qbe_init()
#
#           ON ACTION controlp
#             CASE
#                WHEN INFIELD(aqe01) #查詢單据
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_aqe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aqe01
#                   NEXT FIELD aqe01
#                WHEN INFIELD(aqe04) # Employee CODE
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gen"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aqe04
#                WHEN INFIELD(aqe05) # Dept CODE
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gem"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aqe05
#                OTHERWISE EXIT CASE
#          END CASE
#          
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
#
#     ON ACTION about         
#        CALL cl_about()     
#
#     ON ACTION help         
#        CALL cl_show_help() 
#
#     ON ACTION controlg     
#        CALL cl_cmdask()   
#
#     ON ACTION qbe_select
#       CALL cl_qbe_select()
#     ON ACTION qbe_save
#       CALL cl_qbe_save()
#       	   
#      END CONSTRUCT
#      IF INT_FLAG THEN
#         LET INT_FLAG=0
#         CLOSE WINDOW t600_w6
#         RETURN
#      END IF
#  END IF
#
#  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"   
#  THEN
#      IF NOT cl_confirm('aap-222') THEN
#         LET g_success = 'N'
#         CLOSE WINDOW t600_w6
#         RETURN
#      END IF
#  END IF
#
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     CLOSE WINDOW t600_w6
#     RETURN
#  END IF
#
#No.CHI-A80036   ----MARK----END
 
   CALL cl_msg("WORKING !")       
 
   BEGIN WORK
 
   LET g_sql = "SELECT SUM(aqe09f) FROM aqe_file",
               " WHERE aqe14 = 'N' AND ",g_wc clipped
   PREPARE t600_firm1_p2 FROM g_sql
   DECLARE t600_firm1_c2 CURSOR FOR t600_firm1_p2
   OPEN t600_firm1_c2
   FETCH t600_firm1_c2 INTO l_amt
   IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
   DISPLAY BY NAME l_amt
   
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT ooz09 FROM ooz_file ",
              " WHERE ooz00 = '0'"
   PREPARE t600_ooz09_p FROM g_sql
   EXECUTE t600_ooz09_p INTO g_ooz.ooz09
#FUN-B50090 add -end--------------------------
   LET g_sql = "SELECT aqe01,aqe02,aqe08f,aqe09f FROM aqe_file",
               " WHERE aqe14 = 'N' AND aqe00 = '1' AND ",g_wc clipped
   PREPARE t600_firm1_p3 FROM g_sql
   DECLARE t600_firm1_c3 CURSOR FOR t600_firm1_p3
 # CALL s_showmsg_init()       #NO.FUN-710050     #TQC-B10069
   FOREACH t600_firm1_c3 INTO l_aqe01,l_aqe02,l_aqe08f,l_aqe09f
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
      IF l_aqe02<=g_ooz.ooz09 THEN
         LET g_showmsg='N',"/",'1'           #NO.FUN-710050
         CALL s_errmsg('aqe14,aqe00',g_showmsg,l_aqe02,'aap-176',1) #NO.FUN-710050
         LET g_totsuccess='N'                                                   
         LET g_success='Y'
         CONTINUE FOREACH                    #NO.FUN-710050     
      END IF
      IF l_aqe09f < l_aqe08f THEN
         LET g_showmsg='N',"/",'1'           #NO.FUN-710050
         CALL s_errmsg('aqe14,aqe00',g_showmsg,l_aqe09f,'axr-941',1) #NO.FUN-710050      #No.MOD-740190
         LET g_totsuccess='N'                                                   
         LET g_success='Y'
         CONTINUE FOREACH                    #NO.FUN-710050     
      END IF
      IF l_aqe09f > l_aqe08f THEN
         LET g_showmsg='N',"/",'1'           #NO.FUN-710050
         CALL s_errmsg('aqe14,aqe00',g_showmsg,'','axr-940',1) #NO.FUN-710050
         LET g_totsuccess='N'                                                   
         LET g_success='Y'
         CONTINUE FOREACH                    #NO.FUN-710050     
      END IF
      DECLARE t600_firm1_c4 CURSOR FOR SELECT aqf03,aqf04,aqf05,aqf06  FROM aqf_file
                                        WHERE aqf01 =l_aqe01
      FOREACH t600_firm1_c4 INTO l_aqf03,l_aqf04,l_aqf05,l_aqf06
          LET g_plant_new=l_aqf03 CALL s_getdbs() 
          LET g_sql = "SELECT omc11,omc09 ",
          #" FROM ",g_dbs_new CLIPPED,"omc_file ",
          " FROM ",cl_get_target_table(l_aqf03,'omc_file'), #FUN-A50102
          " WHERE omc01 = ? AND omc02 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_aqf03) RETURNING g_sql #FUN-A50102
          PREPARE omc_14_p1 FROM g_sql
          DECLARE omc_14_curs CURSOR FOR omc_14_p1
          OPEN omc_14_curs USING l_aqf04,l_aqf06
          FETCH omc_14_curs INTO l_omc11,l_omc09
        LET g_net = 0                                                                                                                   
        IF g_ooz.ooz07 = 'Y' THEN                                                                                                       
          LET g_sql = "SELECT SUM(oox10) ",
          #" FROM ",g_dbs_new CLIPPED,"oox_file ",
          " FROM ",cl_get_target_table(l_aqf03,'oox_file'), #FUN-A50102
          " WHERE oox00 = 'AR' AND oox03 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_aqf03) RETURNING g_sql #FUN-A50102
          PREPARE oox_14_p1 FROM g_sql
          DECLARE oox_14_curs CURSOR FOR oox_14_p1
          OPEN oox_14_curs USING l_aqf04
          FETCH oox_14_curs INTO g_net
           IF cl_null(g_net) THEN                                                                                                       
              LET g_net = 0                                                                                                             
           END IF                                                                                                                       
        END IF                                                                                                                          
          LET g_sql = "SELECT oma00 ",
          #" FROM ",g_dbs_new CLIPPED,"oma_file ",
          " FROM ",cl_get_target_table(l_aqf03,'oma_file'), #FUN-A50102
          " WHERE oma01 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_aqf03) RETURNING g_sql #FUN-A50102
          PREPARE oma_14_p1 FROM g_sql
          DECLARE oma_14_curs CURSOR FOR oma_14_p1
          OPEN oma_14_curs USING l_aqf04
          FETCH oma_14_curs INTO l_oma00
          IF l_oma00 MATCHES '1*' THEN LET g_net = g_net * ( -1) END IF                                                                   
                                                                                                                                    
         IF  l_aqf05 + l_omc11 >  l_omc09 + g_net  THEN
             CALL s_errmsg('oma01',l_aqf04,l_aqf05,'axr-939',1) #NO.FUN-710050
             LET g_success='Y'
             LET g_totsuccess='N'                                                   
           # EXIT FOREACH           #NO.FUN-710050 #TQC-B10069
             CONTINUE FOREACH       #TQC-B10069                          
         END IF
      END FOREACH   
   END FOREACH
   IF g_totsuccess="N" THEN                                                        
      CLOSE WINDOW t600_w6
      LET g_success="N"                                                           
   END IF                                  
 
   CALL t600_bu()   
   
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     
   THEN
      CLOSE WINDOW t600_w6
   END IF
   IF g_success = 'Y' THEN
      IF g_aqe.aqemksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_aqe.aqe14="N"
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET g_aqe.aqe14="N"
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_aqe.aqe15='1'              #執行成功, 狀態值顯示為 '1' 已核准
         LET g_aqe.aqe14='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         UPDATE aqe_file SET aqe14 = g_aqe.aqe14,                               
                             aqe15 = g_aqe.aqe15                                
         WHERE aqe01 = g_aqe.aqe01                   
         DISPLAY BY NAME g_aqe.aqe14
         DISPLAY BY NAME g_aqe.aqe15
         COMMIT WORK
         CALL cl_flow_notify(g_aqe.aqe01,'Y')
      ELSE
         LET g_aqe.aqe14='N'
         LET g_success = 'N'
         ROLLBACK WORK
      #  CALL s_showmsg()     #NO.FUN-710050    #TQC-B10069
      END IF
   ELSE
      LET g_aqe.aqe14='N'
      LET g_success = 'N'
      ROLLBACK WORK
   #  CALL s_showmsg()        #NO.FUN-710050    #TQC-B10069 
   END IF
   SELECT * INTO g_aqe.* FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   IF g_aqe.aqe14='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_aqe.aqe15='1' OR
      g_aqe.aqe15='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   IF g_aqe.aqe15='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"",g_chr3,g_chr,g_aqe.aqeacti)
END FUNCTION
 
FUNCTION t600_ef()
   CALL s_showmsg_init()     #TQC-B10069
   LET g_success = 'Y'       #TQC-B10069
   CALL t600_firm1_chk()     #CALL 原確認的 check 段 
   CALL s_showmsg()          #TQC-B10069 
   IF g_success = "N" THEN
       RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
  IF aws_efcli2(base.TypeInfo.create(g_aqe),base.TypeInfo.create(g_aqf),base.TypeInfo.create(g_aqg),'','','') THEN
     LET g_success = 'Y'
     LET g_aqe.aqe15 = 'S'
     DISPLAY BY NAME g_aqe.aqe15
  ELSE
     LET g_success = 'N'
  END IF
 
END FUNCTION
 
FUNCTION t600_del_nme(p_plant)
   DEFINE p_plant      LIKE azp_file.azp01  
   DEFINE l_n      LIKE type_file.num5    #SMALLINT
   DEFINE l_ooa01  LIKE ooa_file.ooa01
 
   #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
   IF g_ooz.ooz04 = 'N' THEN RETURN END IF
   #LET g_sql="SELECT ooa01 FROM ",l_dbs CLIPPED,"ooa_file",
   LET g_sql="SELECT ooa01 FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
             " WHERE ooa992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
   PREPARE t600_sel_ooa_p17 FROM g_sql
   IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
   DECLARE t600_sel_ooa_c17 CURSOR FOR t600_sel_ooa_p17                            
   FOREACH t600_sel_ooa_c17 INTO l_ooa01       
      #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"nme_file",
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'nme_file'), #FUN-A50102
                " WHERE nme12='",l_ooa01,"'"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_z_nme_p FROM g_sql
      EXECUTE t600_z_nme_p
      IF SQLCA.sqlcode THEN
         CALL cl_err('del nme:',SQLCA.sqlcode,1)
         LET g_success='N'
         ROLLBACK WORK
         RETURN
      END IF
      IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021   
      #FUN-B40056  --begin
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
                " WHERE tic04='",l_ooa01,"'"  
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql 
      PREPARE t600_z_tic_p FROM g_sql
      EXECUTE t600_z_tic_p
      IF SQLCA.sqlcode THEN
         CALL cl_err('del tic:',SQLCA.sqlcode,1)
         LET g_success='N'
         ROLLBACK WORK
         RETURN
      END IF
      #FUN-B40056  --end
      END IF                 #No.TQC-B70021 
   END FOREACH
 
END FUNCTION
 
FUNCTION t600_firm2()
   DEFINE l_amt   LIKE type_file.num20_6   
   DEFINE l_cnt   LIKE type_file.num5     
   DEFINE g_sql   STRING
   DEFINE l_dbs   STRING             
   DEFINE l_aqf03  LIKE aqf_file.aqf03
   DEFINE l_aqf04  LIKE aqf_file.aqf04
   DEFINE l_aqf05f LIKE aqf_file.aqf05f
   DEFINE l_aqf05  LIKE aqf_file.aqf05
 
   IF g_aqe.aqe01 IS NULL THEN RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
      AND aqe00='1'
   IF g_aqe.aqe14 = 'N' THEN RETURN END IF
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_aqe.aqe15 = "S" THEN
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND aqeuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND aqegrup = '",g_grup,"'"
   END IF
   
   LET g_sql = "SELECT SUM(aqe09) FROM aqe_file",
               " WHERE aqe14 != 'N' AND aqe00 = '1' ",
               "   AND aqe01 = '",g_aqe.aqe01,"' AND ",g_wc clipped
   PREPARE t600_firm2_p2 FROM g_sql
   DECLARE t600_firm2_c2 CURSOR FOR t600_firm2_p2
   OPEN t600_firm2_c2
   FETCH t600_firm2_c2 INTO l_amt
   IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
   END IF
   IF g_aqe.aqe01 IS NOT NULL THEN
      SELECT aqe14 INTO g_aqe.aqe14 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      DISPLAY BY NAME g_aqe.aqe14
      SELECT aqe15 INTO g_aqe.aqe15 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      DISPLAY BY NAME g_aqe.aqe15
   END IF
   
   LET g_sql ="SELECT UNIQUE aqf03 FROM aqf_file",
              " WHERE aqf00 ='",g_aqe.aqe00,"'",
              "   AND aqf01 ='",g_aqe.aqe01,"'"
   PREPARE t600_sel_aqf_p3 FROM g_sql
   IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
   DECLARE t600_sel_aqf_c3 CURSOR FOR t600_sel_aqf_p3
   
   BEGIN WORK
     LET g_success ='Y'
     CALL s_showmsg_init()     #FUN-8A0086 add
     
 
     #在收款法人體數據庫中刪除收款單axrt400的資料
     #先查axrt400是否已拋轉過總帳（ooa33和對應的分錄底稿nppglno），如果已拋轉過則全部回轉
     CALL t600_chk_voucher(g_plant)
     IF g_success ='Y' THEN
        CALL t600_omac_upd('1')                    #根據帳款單身更新各數據庫中該客戶的應收款已收款金額
        CALL t600_upd_nmhg(g_plant,'1')            #更新對應的銀行異動資料
        CALL t600_del_npp(g_plant)                 #如果沒有拋轉過則刪除對應的分錄底稿單頭資料
        CALL t600_del_npq(g_plant)                 #如果沒有拋轉過則刪除對應的分錄底稿單身資料
        CALL t600_del_nme(g_plant)                 #如果沒有拋轉過則刪除對應的內部帳戶資料
        CALL t600_del_oob(g_plant)                 #如果沒有拋轉過則刪除對應的收款單收款單身和帳款資料
        CALL t600_del_ooa(g_plant)                 #如果沒有拋轉過則刪除對應的付款單單頭資
      ELSE
      	 ROLLBACK WORK
      	 RETURN
      END IF             
     
     #在收款法人體數據庫刪除對被收法人體的待扺應收款axrt300的資料
     #先檢查對被收款法人的待扺帳款axrt300有沒有被衝過帳，如有衝過則全部回轉
     CALL t600_chk_contra(g_plant)
     IF g_success ='Y' THEN
        CALL t600_del_omac(g_plant)                #如果沒被衝過則刪除對應的待扺帳款單資料
      ELSE
      	 ROLLBACK WORK
      	 RETURN
      END IF             
     
     #在被收款法人體數據庫刪除收款單axrt400的資料
     #先檢查有沒有拋轉過總帳(ooa33和對應的分錄底稿nppglno),如果已拋轉過則全部回轉   
     FOREACH t600_sel_aqf_c3 INTO l_aqf03
       IF SQLCA.sqlcode THEN 
          CALL cl_err('t600_sel_aqf_c3',SQLCA.sqlcode,0)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       IF l_aqf03 = g_plant THEN                                                 
          CONTINUE FOREACH                                                      
       END IF     
       CALL t600_chk_voucher(l_aqf03)
       IF g_success ='Y' THEN
          CALL t600_del_npp(l_aqf03)
          CALL t600_del_npq(l_aqf03)
          CALL t600_del_nme(l_aqf03)     
          CALL t600_del_oob(l_aqf03)
          CALL t600_del_ooa(l_aqf03)
       ELSE
          ROLLBACK WORK
          RETURN
       END IF             
       #在被收款法人體數據庫刪除對收款法人體的應收帳款axrt300的資料
       #先檢查對收款法人的應收帳款axrt300有沒有被衝過帳，如有衝過則全部回轉
       CALL t600_chk_contra(l_aqf03)
       IF g_success ='Y' THEN
          CALL t600_del_omac(l_aqf03)                #如果沒被衝過則刪除對應的應付帳款單資料
       ELSE
          ROLLBACK WORK
          RETURN
       END IF
     END FOREACH
     CALL s_showmsg()       #FUN-8A0086 add 
     IF g_success ='Y' THEN
        LET g_aqe.aqe15='0'              #執行成功, 狀態值顯示為 '0' 已核准
        LET g_aqe.aqe14='N'              #執行成功, 確認碼顯示為 'N' 已確認
        UPDATE aqe_file SET aqe14 = g_aqe.aqe14,
                            aqe15 = g_aqe.aqe15   
        WHERE aqe01 = g_aqe.aqe01
          AND aqe00='1'
        DISPLAY BY NAME g_aqe.aqe14
        DISPLAY BY NAME g_aqe.aqe15
        COMMIT WORK
     ELSE
       	ROLLBACK WORK
     END IF 
   
END FUNCTION
 
#FUNCTION t600_x() #FUN-D20035 mark
FUNCTION t600_x(p_type) #FUN-D20035 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add 
   IF s_shut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
    IF g_aqe.aqe15 matches '[Ss1]' THEN   
      CALL cl_err("","mfg3557",0)
      RETURN
    END IF
 
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   #FUN-D20035---begin 
   IF p_type = 1 THEN 
      IF g_aqe.aqe14='X' THEN RETURN END IF
   ELSE
      IF g_aqe.aqe14<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20035---end    
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t600_cl USING g_aqe.aqe01
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN t600_cl:", SQLCA.sqlcode, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_aqe.aqe14) THEN
      IF g_aqe.aqe14 ='N' THEN    #切換為作廢
         LET g_aqe.aqe14='X'
         LET g_aqe.aqe15='9'  
      ELSE                        #取消作廢
         LET g_aqe.aqe14='N'
         LET g_aqe.aqe15='0'   
      END IF
      UPDATE aqe_file SET aqe14 = g_aqe.aqe14,
                          aqe15 = g_aqe.aqe15  
       WHERE aqe01 = g_aqe.aqe01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1) 
         LET g_success = 'N'
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('','aap-161',0) LET g_success='N'
      END IF
   END IF
   SELECT aqe14 INTO g_aqe.aqe14 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   SELECT aqe15 INTO g_aqe.aqe15 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   DISPLAY BY NAME g_aqe.aqe14
   DISPLAY BY NAME g_aqe.aqe15
   CLOSE t600_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqe.aqe01,'V')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aqe01",TRUE)
    END IF
 
    IF INFIELD(aqe03) THEN
       CALL cl_set_comp_entry("aqe11",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aqe01",FALSE)
    END IF
 
    IF INFIELD(aqe03) THEN
       IF g_aqe.aqe03 != 'MISC' AND g_aqe.aqe03 != 'EMPL' THEN
          CALL cl_set_comp_entry("aqe11",FALSE)
       END IF
    END IF
 
END FUNCTION

FUNCTION t600_aqf03()
   DEFINE p_cmd     LIKE type_file.chr1    
   DEFINE l_aqdacti LIKE aqd_file.aqdacti
   DEFINE l_aqd     RECORD LIKE aqd_file.*
 
   SELECT * INTO l_aqd.* FROM aqd_file WHERE aqd01 = g_aqf[l_ac].aqf03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_aqd.aqdacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) THEN
      LET g_aqf[l_ac].aqf11 =l_aqd.aqd02
      LET g_aqf[l_ac].aqf12 =l_aqd.aqd04
      LET g_aqf[l_ac].aqf13 =l_aqd.aqd07
      LET g_aqf[l_ac].aqf14 =l_aqd.aqd06
      IF (g_aqf[l_ac].aqf03 !=g_plant) THEN 
         LET g_aqf[l_ac].aqf15 =l_aqd.aqd15 
      ELSE
      	 LET g_aqf[l_ac].aqf15 =l_aqd.aqd16
      END IF
   END IF
END FUNCTION
 
FUNCTION t600_bu()
   DEFINE l_aza63     LIKE aza_file.aza63
   DEFINE l_aqf03     LIKE aqf_file.aqf03
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
      #在當前數據庫產生正式收款單據axrt400
      CALL t600_ins_ooa(g_plant)                     #產生收款單頭ooa_file數據
      IF g_success = 'N' THEN
         RETURN
      END IF
      CALL t600_ins_oob2(g_plant)                    #產生收款單帳款單身oob_file數據
      IF g_success = 'N' THEN
         RETURN
      END If
      CALL t600_ins_oob1(g_plant)                    #產生收款單收款單身oob_file數據
      IF g_success = 'N' THEN
         RETURN
      END IF
      CALL t600_ins_npq(g_plant,'0',g_ooa01)         #產生分錄底稿單身>
      CALL s_get_bookno(YEAR(g_aqe.aqe02)) RETURNING l_flag,l_bookno1,l_bookno2
      IF l_flag = '1' THEN
      #  CALL cl_err(YEAR(g_aqe.aqe02),'aoo-081',1)               #TQC-B10069
         CALL s_errmsg("aqe02",YEAR(g_aqe.aqe02),"",'aoo-081',1)  #TQC-B10069
         LET g_success = 'N'
      END IF
 
      CALL s_chknpq3(g_ooa01,'AR',1,'0',g_plant,l_bookno1)     #No.TQC-6C0073       #No.FUN-740009
 
      IF g_aza.aza63 ='Y' THEN                                                    
         CALL t600_ins_npq(g_plant,'1',g_ooa01)                               
      END IF                                                                      
 
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN                                
         CALL s_chknpq3(g_ooa01,'AR',1,'1',g_plant,l_bookno2)          #No.FUN-740009
      END IF                   
 
      LET g_ooa01 = NULL
 
      CALL t600_upd_nmhg(g_plant,'0')                #更新銀行異動資料nmh_file或nmg_file數據
      IF g_success = 'N' THEN
         RETURN
      END IF
 
      #根據帳款單身更新各數據庫中該客戶的應付款已收款金額
      CALL t600_omac_upd('0')
      IF g_success = 'N' THEN
         RETURN
      END IF
      
      #在當前數據庫產生對被代收法人體的待扺應收帳款axrt300
      #產生待扺應收款單頭oma_file、單身omb_file和多帳期檔案omc_file數據
      CALL t600_omac_ins(g_plant)  
      IF g_success = 'N' THEN
         RETURN
      END IF
      
      #在被收法人體的數據庫中產生對客戶的收款衝賬單axrt400
      DECLARE t600_sel_aqf_c2 CURSOR FOR                                           
        SELECT UNIQUE aqf03 FROM aqf_file                                                 
         WHERE aqf01 =g_aqe.aqe01                                                  
      FOREACH t600_sel_aqf_c2 INTO l_aqf03       
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('aqf01',g_aqe.aqe01,'t600_sel_aqf_c2',SQLCA.sqlcode,1) #NO.FUN-710050
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF l_aqf03 = g_plant THEN                                                 
            CONTINUE FOREACH                                                      
         END IF     
         CALL t600_ins_ooa(l_aqf03)                            #產生收款單頭ooa_file數據
         IF g_success = 'N' THEN
            CONTINUE FOREACH      #NO.FUN-710050
         END IF
         CALL t600_ins_oob2(l_aqf03)                           #產生付款單帳款單身oob_file數據
         IF g_success = 'N' THEN
            CONTINUE FOREACH      #NO.FUN-710050
         END IF
         CALL t600_ins_oob1(l_aqf03)                           #產生收款單收款單身oob_file數據(無銀行收支)
         IF g_success = 'N' THEN
            CONTINUE FOREACH      #NO.FUN-710050
         END IF
         CALL t600_ins_npq(l_aqf03,'0',g_ooa01)                #產生分錄底稿單身>
         CALL s_chknpq3(g_ooa01,'AR',1,'0',l_aqf03,l_bookno1)            #No.TQC-6C0073
         #LET g_plant_new=l_aqf03 CALL s_getdbs() LET l_dbs=g_dbs_new#FUN-A50102
         LET g_sql = " SELECT aza63 ",  
                     #"   FROM ",l_dbs CLIPPED,"aza_file ",
                     "   FROM ",cl_get_target_table(l_aqf03,'aza_file'), #FUN-A50102
                     "  WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_aqf03) RETURNING g_sql #FUN-A50102
         PREPARE t600_aza63 FROM g_sql
         DECLARE t600_aza_c CURSOR FOR t600_aza63 
         OPEN t600_aza_c  
         FETCH t600_aza_c INTO l_aza63
         IF l_aza63 ='Y' THEN                                                    
            CALL t600_ins_npq(l_aqf03,'1',g_ooa01)                               
         END IF                                                                      
         IF l_aza63 = 'Y' AND g_success = 'Y' THEN                                
            CALL s_chknpq3(g_ooa01,'AR',1,'1',l_aqf03,l_bookno2)          #No.FUN-740009
         END IF                   
     
         CALL t600_ins_nme('0',l_aqf03)                 #產生內部銀行異動資料nme_file數據
         IF g_success = 'N' THEN
            RETURN
         END IF                        
     
         #在被代收法人體的數據庫中產生對代收法人體的應收帳款axrt300
         #產生雜項應收款單頭oma_file,單身omb_file和多帳期檔案omc_file數據
         CALL t600_omac_ins(l_aqf03)  
         IF g_success = 'N' THEN
            RETURN
         END IF
     
         LET g_ooa01 = NULL
      END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
  
END FUNCTION
 
FUNCTION t600_upd_nmhg(p_plant,p_code)
    DEFINE p_plant          LIKE type_file.chr21 
    DEFINE p_code           LIKE type_file.chr1
    DEFINE l_aqg            RECORD LIKE aqg_file.*
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    LET g_sql ="SELECT * FROM aqg_file",
               " WHERE aqg00 ='",g_aqe.aqe00,"'",
               "   AND aqg01 ='",g_aqe.aqe01,"'"
    PREPARE t600_aqg11_p FROM g_sql                                                                                                 
    IF SQLCA.sqlcode THEN 
       LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01
       CALL s_errmsg('aqg00,aqg01',g_showmsg,'',SQLCA.sqlcode,0) #NO.FUN-710050
    END IF                                                       #NO.FUN-710050
    DECLARE t600_aqg11_c CURSOR FOR t600_aqg11_p
    FOREACH t600_aqg11_c INTO l_aqg.*
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
       IF SQLCA.sqlcode THEN 
          LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01                 #NO.FUN-710050
          CALL s_errmsg('aqg00,aqg01',g_showmsg,'',SQLCA.sqlcode,0) #NO.FUN-710050
          LET g_success = 'N'
          ROLLBACK WORK
          CONTINUE FOREACH                                          #NO.FUN-710050    
       END IF
       IF l_aqg.aqg04 = '1' THEN   ## update nmh
          IF p_code = '0' THEN
             #LET g_sql="UPDATE ",l_dbs CLIPPED,"nmh_file",
             LET g_sql="UPDATE ",cl_get_target_table(p_plant,'nmh_file'), #FUN-A50102
                        " SET nmh17 = nmh17 + '",l_aqg.aqg06f,"',nmh40 = nmh40 - '",l_aqg.aqg06,"' ",
                        " WHERE nmh01 = '",l_aqg.aqg14,"' "
          ELSE
             #LET g_sql="UPDATE ",l_dbs CLIPPED,"nmh_file",
             LET g_sql="UPDATE ",cl_get_target_table(p_plant,'nmh_file'), #FUN-A50102
                        " SET nmh17 = nmh17 - '",l_aqg.aqg06f,"',nmh40 = nmh40 + '",l_aqg.aqg06,"' ",
                        " WHERE nmh01 = '",l_aqg.aqg14,"'"
          END IF
       END IF
       IF l_aqg.aqg04 = '2' THEN   ## update nmg
          IF p_code = '0' THEN
             #LET g_sql="UPDATE ",l_dbs CLIPPED,"nmg_file",
             LET g_sql="UPDATE ",cl_get_target_table(p_plant,'nmg_file'), #FUN-A50102
                        " SET nmg24 = nmg24 + '",l_aqg.aqg06f,"',nmg10 = nmg10 - '",l_aqg.aqg06,"' ",
                        " WHERE nmg00 ='",l_aqg.aqg14,"' "
          ELSE
             #LET g_sql="UPDATE ",l_dbs CLIPPED,"nmg_file",
             LET g_sql="UPDATE ",cl_get_target_table(p_plant,'nmg_file'), #FUN-A50102
                        " SET nmg24 = nmg24 - '",l_aqg.aqg06f,"',nmg10 = nmg10 + '",l_aqg.aqg06,"' ",
                        " WHERE nmg00 ='",l_aqg.aqg14,"'"
          END IF
       END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_upd_nmgh_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL s_errmsg('nmg00',l_aqg.aqg14,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050
       EXECUTE t600_upd_nmgh_p
       IF SQLCA.sqlcode THEN 
          CALL s_errmsg('nmg00',l_aqg.aqg14,'',SQLCA.sqlcode,1) #NO.FUN-710050
          LET g_success = 'N'
          ROLLBACK WORK
          CONTINUE FOREACH #NO.FUN-710050
       END IF
    END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
 
END FUNCTION
 
FUNCTION t600_ins_ooa(p_plant)
    DEFINE li_result   LIKE type_file.num5    
    DEFINE p_plant     LIKE type_file.chr21 
    DEFINE l_ooa       RECORD LIKE ooa_file.*
    DEFINE l_dbs       STRING
    DEFINE l_aqd02     LIKE aqd_file.aqd02
    DEFINE l_aqd11     LIKE aqd_file.aqd11
    DEFINE l_aza63     LIKE aza_file.aza63
    
    LET l_ooa.ooa00 = '1'
    LET l_ooa.ooa02= g_aqe.aqe02
    
    SELECT aqd02,aqd11 INTO l_aqd02,l_aqd11 FROM aqd_file
     WHERE aqd01 = p_plant
     
    LET l_ooa.ooa01 =  l_aqd11
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new#FUN-A50102
    CALL s_auto_assign_no("axr",l_ooa.ooa01,l_ooa.ooa02,"33","ooa_file","ooa01",p_plant,"","")  #FUN-980094 add
         RETURNING li_result,l_ooa.ooa01 
    IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
    END IF
 
    LET l_ooa.ooa021 = l_ooa.ooa02
    LET l_ooa.ooa03  = g_aqe.aqe03  
    LET l_ooa.ooa032 = g_aqe.aqe11 
    LET l_ooa.ooa13  = l_aqd02
    LET l_ooa.ooa14  = g_aqe.aqe04
    LET l_ooa.ooa15  = g_aqe.aqe05
    LET l_ooa.ooa20  = 'Y'
    LET l_ooa.ooa23  = g_aqe.aqe06
    LET l_ooa.ooa25  = '0'
    LET l_ooa.ooa31d = 0
    LET l_ooa.ooa31c = 0
    LET l_ooa.ooa32d = 0
    LET l_ooa.ooa32c = 0
    LET l_ooa.ooa34  = '1'
    LET l_ooa.ooaconf= 'Y'
    LET l_ooa.ooa992 = g_aqe.aqe01
    LET l_ooa.ooaprsw= 0
    LET l_ooa.ooauser= g_aqe.aqeuser
    LET l_ooa.ooagrup= g_aqe.aqegrup
    LET l_ooa.ooamodu= g_aqe.aqemodu
    LET l_ooa.ooadate= g_aqe.aqedate
    LET l_ooa.ooamksg= g_aqe.aqemksg
#   LET l_ooa.ooa37 = 'N'     #FUN-9B0147          #FUN-A40076 Mark
    LET l_ooa.ooa37 = '1'                          #FUN-A40076 Add 
    LET l_ooa.ooa38 = '2'     #手工  #No.TQC-9C0133
 
    #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
              "(ooa00,ooa01,ooa02,ooa021,ooa03,ooa032, ",
              " ooa13,ooa14,ooa15,ooa20, ooa23,  ",
              " ooa25,ooa31d,ooa31c,ooa32d,ooa32c,ooa34,",
              " ooaconf,ooaprsw,ooauser,ooagrup,ooadate,",
              " ooamksg,ooa992,ooalegal,ooa37,ooa38,ooaoriu,ooaorig)",  #FUN-A10036  #FUN-980011 add   #FUN-9B0147 add ooa37  #No.TQC-9C0133
              " VALUES(?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)" #FUN-A10036 #FUN-980011 add   #FUN-9B0147 add ?  #No.TQC-9C0133
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_y_ooa_p FROM g_sql
    EXECUTE t600_y_ooa_p USING l_ooa.ooa00,l_ooa.ooa01,l_ooa.ooa02,l_ooa.ooa021,l_ooa.ooa03,l_ooa.ooa032,
                            l_ooa.ooa13,l_ooa.ooa14,l_ooa.ooa15,l_ooa.ooa20,l_ooa.ooa23,
                            l_ooa.ooa25,l_ooa.ooa31d,l_ooa.ooa31c,l_ooa.ooa32d,l_ooa.ooa32c,l_ooa.ooa34,
                            l_ooa.ooaconf,l_ooa.ooaprsw,l_ooa.ooauser,l_ooa.ooagrup,l_ooa.ooadate,
                            l_ooa.ooamksg,l_ooa.ooa992,g_legal,l_ooa.ooa37,l_ooa.ooa38,g_user,g_grup #FUN-A10036   #FUN-980011 add   #FUN-9B0147 add ooa37  #No.TQC-9C0133
 
    IF SQLCA.sqlcode THEN
       LET g_showmsg=l_ooa.ooa01,"/",l_ooa.ooa03   #NO.FUN-710050        
       CALL s_errmsg('ooa01,ooa03',g_showmsg,'ins ooa:',SQLCA.sqlcode,1) #NO.FUN-710050
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg=l_ooa.ooa01,"/",l_ooa.ooa03   #NO.FUN-710050        
       CALL s_errmsg('ooa01,ooa03',g_showmsg,'ins ooa:',SQLCA.sqlcode,1) #NO.FUN-710050
       LET g_success='N' 
       RETURN           
    END IF
    IF p_plant <> g_plant THEN
       CALL t600_ins_npp(p_plant,'0',l_ooa.ooa01)                #產生分錄底稿單頭>
       #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       LET g_sql = " SELECT aza63 ",  
                   #"   FROM ",l_dbs CLIPPED,"aza_file ",
                   "   FROM ",cl_get_target_table(p_plant,'aza_file'), #FUN-A50102
                   "  WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_aza63_1 FROM g_sql
       DECLARE t600_aza_1_c CURSOR FOR t600_aza63_1 
       OPEN t600_aza_1_c
       FETCH t600_aza_1_c INTO l_aza63
       IF l_aza63 ='Y' THEN                                                    
          CALL t600_ins_npp(p_plant,'1',l_ooa.ooa01)                               
       END IF                                                                      
    ELSE
       CALL t600_ins_npp(p_plant,'0',l_ooa.ooa01)        
       IF g_aza.aza63 = 'Y' THEN
          CALL t600_ins_npp(p_plant,'1',l_ooa.ooa01)    
       END IF
    END IF
    LET g_ooa01 =l_ooa.ooa01  
 
END FUNCTION
 
FUNCTION t600_ins_oob1(p_plant)   #收款單身
    DEFINE li_result   LIKE type_file.num5    
    DEFINE p_plant     LIKE type_file.chr21 
    DEFINE l_oob       RECORD LIKE oob_file.*
    DEFINE l_aqg       RECORD LIKE aqg_file.*
    DEFINE l_dbs       STRING
    DEFINE l_ooa01     LIKE ooa_file.ooa01
    DEFINE l_aqf11     LIKE aqf_file.aqf11
    DEFINE l_amt1      LIKE aqg_file.aqg06
    DEFINE l_amtf1     LIKE aqg_file.aqg06f
    DEFINE l_sumf1     LIKE aqg_file.aqg06f
    DEFINE l_sum1      LIKE aqg_file.aqg06
  
    LET l_oob.oob02 = g_oob02_max
    LET l_amtf1 = 0 
    LET l_amt1  = 0
    LET l_sum1  = 0
    LET l_sumf1 = 0
    
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new#FUN-A50102
    
    IF p_plant = g_plant THEN         
       LET g_sql ="SELECT * FROM aqg_file",
                  " WHERE aqg00 ='",g_aqe.aqe00,"'",
                  "   AND aqg01 ='",g_aqe.aqe01,"'"
       PREPARE t600_aqg1_p FROM g_sql                                                                                                 
       IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01                 #NO.FUN-710050  
         CALL s_errmsg('aqg00,aqg01',g_showmsg,'',SQLCA.sqlcode,0) #NO.FUN-710050
       END IF
       DECLARE t600_aqg1_c CURSOR FOR t600_aqg1_p
       FOREACH t600_aqg1_c INTO l_aqg.*
          IF SQLCA.sqlcode THEN 
             LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01                 #NO.FUN-710050  
             CALL s_errmsg('aqg00,aqg01',g_showmsg,'',SQLCA.sqlcode,1) #NO.FUN-710050
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          IF g_success='N' THEN                                                    
           LET g_totsuccess='N'                                                   
           LET g_success='Y' 
          END IF                                                     
          LET l_oob.oob01 = g_ooa01       
          LET l_oob.oob02 = l_oob.oob02 + 1
          LET l_oob.oob03 = '1'
          LET l_oob.oob04 = l_aqg.aqg04
          LET l_oob.oob05 = l_aqg.aqg03
          LET l_oob.oob06 = l_aqg.aqg14
          LET l_oob.oob07 = l_aqg.aqg09
          LET l_oob.oob08 = l_aqg.aqg10
          LET l_oob.oob09 = l_aqg.aqg06f
          LET l_oob.oob10 = l_aqg.aqg06
          IF cl_null(l_oob.oob09) THEN
             LET l_oob.oob09 = 0
          END IF
          IF cl_null(l_oob.oob10) THEN
             LET l_oob.oob10 = 0
          END IF
          LET l_sum1  = l_sum1  + l_oob.oob09
          LET l_sumf1 = l_sumf1 + l_oob.oob10
          IF l_aqg.aqg03 = g_plant THEN
             LET l_amtf1 = l_amtf1 + l_aqg.aqg06f
             LET l_amt1  = l_amt1  + l_aqg.aqg06
          END IF
          LET l_oob.oob11 = l_aqg.aqg05
          LET l_oob.oob111= l_aqg.aqg051
          LET l_oob.oob12 = l_aqg.aqg13
          LET l_oob.oob13 = l_aqg.aqg12
          LET l_oob.oob14 = l_aqg.aqg16
          LET l_oob.oob15 = l_aqg.aqg15
          LET l_oob.oob17 = l_aqg.aqg08
          LET l_oob.oob18 = l_aqg.aqg11
 
          #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"oob_file",
          LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'oob_file'), #FUN-A50102
                    "(oob01,oob02,oob03,oob04,oob05,oob06, ", 
                    " oob07,oob08,oob09,oob10,oob11,oob111,",
                    " oob12,oob13,oob14,oob15,oob17,oob18,ooblegal)",   #FUN-980011 add
                    " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,?,?,?)"  #FUN-980011 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
          PREPARE t600_ins_oob2_p FROM g_sql
          IF SQLCA.sqlcode THEN                                        #NO.FUN-710050
             CALL s_errmsg('','','',SQLCA.sqlcode,1)                   #NO.FUN-710050
          END IF 
          EXECUTE t600_ins_oob2_p USING l_oob.oob01,l_oob.oob02,l_oob.oob03,l_oob.oob04,l_oob.oob05,l_oob.oob06,
                                     l_oob.oob07,l_oob.oob08,l_oob.oob09,l_oob.oob10,l_oob.oob11,l_oob.oob111,
                                     l_oob.oob12,l_oob.oob13,l_oob.oob14,l_oob.oob15,l_oob.oob17,l_oob.oob18,                                                                                  
                                     g_plant   #FUN-980011 add
          IF SQLCA.sqlcode THEN                                                                                                                  
             LET g_showmsg=l_oob.oob01,"/",l_oob.oob02  #NO.FUN-710050
             CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob:',SQLCA.sqlcode,1) #NO.FUN-710050                                                                                
             LET g_success='N'                                                                                                            
          END IF                                                                                                                          
          IF SQLCA.SQLERRD[3]=0 THEN                                                                                                      
             LET g_showmsg=l_oob.oob01,"/",l_oob.oob02  #NO.FUN-710050
             CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob:',SQLCA.sqlcode,1) #NO.FUN-710050                                                                                
             LET g_success='N'                                                                                                            
             CONTINUE FOREACH                          #NO.FUN-710050 
          END IF   
       END FOREACH
       IF g_totsuccess="N" THEN                                                        
         LET g_success="N"                                                           
       END IF                                                                          
 
       #LET g_sql="UPDATE ",l_dbs CLIPPED,"ooa_file",   
       LET g_sql="UPDATE ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102    
                 "   SET ooa31d ='",l_sum1,"',ooa32d ='",l_sumf1,"'",
                 " WHERE ooa01  ='",l_oob.oob01,"'"     
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102     
       PREPARE t600_upd_ooa2_p FROM g_sql                                                                                               
       IF SQLCA.sqlcode THEN CALL s_errmsg('ooa01',l_oob.oob01,' ',SQLCA.sqlcode,1) END IF   #NO.FUN-710050                                                                              
       EXECUTE t600_upd_ooa2_p                                                                                                          
       IF SQLCA.sqlcode THEN                                                                                                                  
          CALL s_errmsg('ooa01',l_oob.oob01,'upd ooa:',SQLCA.sqlcode,1) #NO.FUN-710050
          LET g_success='N'                                                                                                                   
       END IF               
    ELSE    
       LET l_oob.oob01 = g_ooa01
       LET l_oob.oob02 = l_oob.oob02 + 1
       LET l_oob.oob03 = '1'
       LET l_oob.oob04 = 'X'
       LET l_oob.oob05 = p_plant
       LET l_oob.oob06 = g_aqe.aqe01
       LET l_oob.oob07 = g_aqe.aqe06
       
       #LET g_sql="SELECT SUM(oob09),SUM(oob10) FROM ",l_dbs CLIPPED,"oob_file",
       LET g_sql="SELECT SUM(oob09),SUM(oob10) FROM ",cl_get_target_table(p_plant,'oob_file'), #FUN-A50102    
                 " WHERE oob01 ='",g_ooa01,"' AND oob03 = 2 "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_sel_oob11_p FROM g_sql
       IF SQLCA.sqlcode THEN                                        #NO.FUN-710050
         LET g_showmsg=g_ooa01,"/",'2'                                #NO.FUN-710050
         CALL s_errmsg('oob01,oob03',g_showmsg,'',SQLCA.sqlcode,0)    #NO.FUN-710050
       END IF                                                         #NO.FUN-710050 
       EXECUTE t600_sel_oob11_p INTO l_oob.oob09,l_oob.oob10  
       IF cl_null(l_oob.oob09) THEN
          LET l_oob.oob09 = 0
       END IF
       IF cl_null(l_oob.oob10) THEN
          LET l_oob.oob10 = 0
       END IF  
       LET l_oob.oob08 = l_oob.oob10/l_oob.oob09  #No.TQC-760074
 
       LET g_sql ="SELECT aqf11 FROM aqf_file",
                  " WHERE aqf00 ='",g_aqe.aqe00,"'",
                  "   AND aqf01 ='",g_aqe.aqe01,"'"
       PREPARE t600_aqf8_p FROM g_sql                                                                                                 
       IF SQLCA.sqlcode THEN
          LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01
          CALL s_errmsg('aqf00,aqf01',g_showmsg,'',SQLCA.sqlcode,0)  #NO.FUN-710050
       END IF                                                        #NO.FUN-710050       
       DECLARE t600_aqf8_c CURSOR FOR t600_aqf8_p
       FOREACH t600_aqf8_c INTO l_aqf11
           LET g_sql = " SELECT ool11,ool111 ",  
                       #"   FROM ",l_dbs CLIPPED,"ool_file ",
                       "   FROM ",cl_get_target_table(p_plant,'ool_file'), #FUN-A50102    
                       "  WHERE ool01 = '",l_aqf11,"' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
           PREPARE t600_str27 FROM g_sql
           DECLARE t600_str28 CURSOR FOR t600_str27
           OPEN t600_str28  
           FETCH t600_str28 INTO l_oob.oob11,l_oob.oob111
       END FOREACH
 
       #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"oob_file",
       LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'oob_file'), #FUN-A50102    
                 "(oob01,oob02,oob03,oob04,oob05,oob06, ", 
                 " oob07,oob08,oob09,oob10,oob11,oob111,ooblegal)",   #FUN-980011 add
                 " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?)"                #FUN-980011 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_ins_oob3_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
       EXECUTE t600_ins_oob3_p USING l_oob.oob01,l_oob.oob02,l_oob.oob03,l_oob.oob04,l_oob.oob05,l_oob.oob06,
                                  l_oob.oob07,l_oob.oob08,l_oob.oob09,l_oob.oob10,l_oob.oob11,l_oob.oob111,
                                  g_legal   #FUN-980011 add
       IF SQLCA.sqlcode THEN                                                                                                                  
          LET g_showmsg=l_oob.oob01,"/",l_oob.oob02      #NO.FUN-710050 
          CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob:',SQLCA.sqlcode,1)   #NO.FUN-710050                                                                                        
          LET g_success='N'                                                                                                            
       END IF                                                                                                                          
       IF SQLCA.SQLERRD[3]=0 THEN                                                                                                      
          LET g_showmsg=l_oob.oob01,l_oob.oob02      #NO.FUN-710050 
          CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob:',SQLCA.sqlcode,1)   #NO.FUN-710050                                                                                        
          LET g_success='N'                                                                                                            
          RETURN                                                                                                                       
       END IF  
               
       #LET g_sql="UPDATE ",l_dbs CLIPPED,"ooa_file",
       LET g_sql="UPDATE ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102           
                 "   SET ooa31d ='",l_oob.oob09,"',ooa32d ='",l_oob.oob10,"'",
                 " WHERE ooa01  ='",l_oob.oob01,"'"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_upd_ooa3_p FROM g_sql                                                                                               
       IF SQLCA.sqlcode THEN                                         #NO.FUN-710050       
          CALL s_errmsg('ooa01',l_oob.oob01,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050                                                           
       EXECUTE t600_upd_ooa3_p                                                                                                          
       IF SQLCA.sqlcode THEN                                                                                                                  
          CALL s_errmsg('ooa01',l_oob.oob01,'',SQLCA.sqlcode,0)  #NO.FUN-710050                                                           
          LET g_success='N'                                                                                                            
       END IF                    
    END IF
 
END FUNCTION
 
FUNCTION t600_ins_oob2(p_plant)   #帳款
    DEFINE li_result   LIKE type_file.num5 
    DEFINE p_plant     LIKE type_file.chr21 
    DEFINE l_oob       RECORD LIKE oob_file.*
    DEFINE l_aqf       RECORD LIKE aqf_file.*
    DEFINE l_dbs       STRING
    DEFINE l_amt       LIKE aqf_file.aqf05
    DEFINE l_amtf      LIKE aqf_file.aqf05f
    DEFINE l_sumf      LIKE aqf_file.aqf05f
    DEFINE l_sum       LIKE aqf_file.aqf05
 
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new   #FUN-A50102
      
    LET g_sql ="SELECT * FROM aqf_file",
               " WHERE aqf00 ='",g_aqe.aqe00,"'",
               "   AND aqf01 ='",g_aqe.aqe01,"'"
    PREPARE t600_aqf1_p FROM g_sql                                                                                                 
    IF SQLCA.sqlcode THEN
     LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01
     CALL s_errmsg('aqf00,aqf01',g_showmsg,'',SQLCA.sqlcode,0) 
    END IF
    DECLARE t600_aqf1_c CURSOR FOR t600_aqf1_p
    LET l_amtf = 0 
    LET l_amt  = 0
    LET l_sum  = 0
    LET l_sumf = 0
    LET g_oob02_max = 0
    FOREACH t600_aqf1_c INTO l_aqf.*
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
       IF l_aqf.aqf03 <> p_plant AND p_plant <> g_plant THEN 
          CONTINUE FOREACH
       END IF
       LET l_oob.oob01 =  g_ooa01
       LET l_oob.oob02 =  l_aqf.aqf02
       IF g_oob02_max < l_oob.oob02 THEN
          LET g_oob02_max = l_oob.oob02
       END IF
       LET l_oob.oob03 =  '2'
       LET l_oob.oob04 =  '1'
       LET l_oob.oob05 = l_aqf.aqf03
       LET l_oob.oob06 = l_aqf.aqf04
       LET l_oob.oob19 = l_aqf.aqf06
       LET l_oob.oob07 = g_aqe.aqe06
       LET l_oob.oob08 = l_aqf.aqf05/l_aqf.aqf05f  #No.TQC-760074
       LET l_oob.oob09 = l_aqf.aqf05f
       LET l_oob.oob10 = l_aqf.aqf05
 
       IF p_plant = g_plant THEN
          IF l_aqf.aqf03 = g_plant THEN
             #LET g_plant_new=g_plant CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102 
             LET g_sql = " SELECT oma18,oma181 ",  
                         #"   FROM ",l_dbs CLIPPED,"oma_file ",
                         "   FROM ",cl_get_target_table(g_plant,'oma_file'), #FUN-A50102
                         "  WHERE oma01= '",l_aqf.aqf04,"' "
          ELSE
              #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
              LET g_sql = " SELECT ool11,ool111 ",  
                         #"   FROM ",l_dbs CLIPPED,"ool_file ",
                         "   FROM ",cl_get_target_table(p_plant,'ool_file'), #FUN-A50102
                         "  WHERE ool01 = '",l_aqf.aqf11,"' "
          END IF
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       ELSE
         #LET g_plant_new=l_aqf.aqf03 CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102 
         LET g_sql = " SELECT oma18,oma181 ",  
                     #"   FROM ",l_dbs CLIPPED,"oma_file ",
                     "   FROM ",cl_get_target_table(l_aqf.aqf03 ,'oma_file'), #FUN-A50102
                     "  WHERE oma01= '",l_aqf.aqf04,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_aqf.aqf03) RETURNING g_sql #FUN-A50102
       END IF 	   
       PREPARE t600_str17 FROM g_sql
       DECLARE t600_str18 CURSOR FOR t600_str17
       OPEN t600_str18  
       FETCH t600_str18 INTO l_oob.oob11,l_oob.oob111
       IF cl_null(l_oob.oob09) THEN
          LET l_oob.oob09 =0
       END IF
       IF cl_null(l_oob.oob10) THEN
          LET l_oob.oob10 =0
       END IF
       LET l_sum  = l_sum  + l_oob.oob09
       LET l_sumf = l_sumf + l_oob.oob10
       IF l_aqf.aqf03 = g_plant THEN
          LET l_amtf = l_amtf + l_aqf.aqf05f
          LET l_amt  = l_amt  + l_aqf.aqf05
       END IF
 
       #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102 
       #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"oob_file",
       LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'oob_file'), #FUN-A50102
                 "(oob01,oob02,oob03,oob04,oob05,oob06, ", 
                 " oob07,oob08,oob09,oob10,oob11,oob111,oob19,ooblegal)", #FUN-980011 add
                 " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?)"     #FUN-980011 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_ins_oob1_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,0) END IF #NO.FUN-710050 
       EXECUTE t600_ins_oob1_p USING l_oob.oob01,l_oob.oob02,l_oob.oob03,l_oob.oob04,l_oob.oob05,l_oob.oob06,
                                  l_oob.oob07,l_oob.oob08,l_oob.oob09,l_oob.oob10,l_oob.oob11,l_oob.oob111,
                                  l_oob.oob19,g_legal  #FUN-980011 add
       
       IF SQLCA.sqlcode THEN                                                                                                                  
          LET g_showmsg=l_oob.oob01,"/",l_oob.oob02                         #NO.FUN-710050 
          CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob:',SQLCA.sqlcode,1) #NO.FUN-710050
          LET g_success='N'                                                                                                            
       END IF                                                                                                                          
       IF SQLCA.SQLERRD[3]=0 THEN                                                                                                      
          LET g_showmsg=l_oob.oob01,"/",l_oob.oob02                         #NO.FUN-710050 
          CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob:',SQLCA.sqlcode,1) #NO.FUN-710050
          LET g_success='N'                                                                                                            
          CONTINUE FOREACH                                                  #NO.FUN-710050                                                                                                                       
       END IF      
    END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
    #LET g_sql="UPDATE ",l_dbs CLIPPED,"ooa_file", 
    LET g_sql="UPDATE ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102  
              "   SET ooa31c ='",l_sum,"',ooa32c ='",l_sumf,"'",
              " WHERE ooa01  ='",l_oob.oob01,"' "
                                                                                                            
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_upd_ooa1_p FROM g_sql                                                                                               
    IF SQLCA.sqlcode THEN CALL s_errmsg('ooa01',l_oob.oob01,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050
    EXECUTE t600_upd_ooa1_p                                                                                                          
    IF SQLCA.sqlcode THEN                                                                                                                  
       CALL s_errmsg('ooa01',l_oob.oob01,'upd ooa:',SQLCA.sqlcode,1)#NO.FUN-710050
       LET g_success='N'                                                                                                            
    END IF 
 
END FUNCTION
 
FUNCTION t600_ins_npp(p_plant,p_npptype,p_arno)
   DEFINE p_plant          LIKE type_file.chr21 
   DEFINE p_npptype        LIKE npp_file.npptype
   DEFINE p_arno           LIKE ooa_file.ooa01
   DEFINE l_dbs            STRING
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_ooa            RECORD LIKE ooa_file.*
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102 
    #LET g_sql="SELECT * FROM ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="SELECT * FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102  
             " WHERE ooa01 ='",p_arno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_ooa4_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    EXECUTE t600_sel_ooa4_p INTO l_ooa.*
 
    LET l_npp.nppsys = 'AR'                                                       
    LET l_npp.npp00  = 3                                                   
    LET l_npp.npp01  = l_ooa.ooa01                                            
    LET l_npp.npp011 = 1                                             
    LET l_npp.npp02  = l_ooa.ooa02                                       
    LET l_npp.npp03  = NULL  
    LET l_npp.npp04  = NULL                                         
    LET l_npp.npp05  = NULL                                      
    LET l_npp.nppglno= NULL     
    LET l_npp.npptype= p_npptype
    
 
    #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"npp_file",
    LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'npp_file'), #FUN-A50102  
              "(nppsys,npp00,npp01,npp011,npp02,npp03,",
              " npp04,npp05,nppglno,npptype,npplegal)", #FUN-980011 add
              " VALUES(?,?,?,?,?,?, ?,?,?,?,?)"         #FUN-980011 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_ins_npp_p FROM g_sql
    EXECUTE t600_ins_npp_p USING l_npp.nppsys,l_npp.npp00,l_npp.npp01,l_npp.npp011,l_npp.npp02,l_npp.npp03,
                              l_npp.npp04,l_npp.npp05,l_npp.nppglno,l_npp.npptype,
                              g_legal #FUN-980011 add
    IF SQLCA.sqlcode THEN
       LET  g_showmsg=l_npp.npp00,"/",l_npp.npp01,"/",l_npp.npp011              #NO.FUN-710050
       CALL s_errmsg('npp00,npp01,npp011',g_showmsg,'ins npp:',SQLCA.sqlcode,1) #NO.FUN-710050
       LET g_success='N'
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       LET  g_showmsg=l_npp.npp00,"/",l_npp.npp01,"/",l_npp.npp011              #NO.FUN-710050
       CALL s_errmsg('npp00,npp01,npp011',g_showmsg,'ins npp:',SQLCA.SQLCODE,1) #NO.FUN-710050
       LET g_success='N'
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t600_ins_npq(p_plant,p_npqtype,p_arno)
   DEFINE p_code           LIKE type_file.chr1  
   DEFINE p_plant          LIKE type_file.chr21 
   DEFINE p_npqtype        LIKE npq_file.npqtype
   DEFINE p_arno           LIKE ooa_file.ooa01
   DEFINE l_dbs            STRING
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_oob            RECORD LIKE oob_file.*
   DEFINE l_ooa            RECORD LIKE ooa_file.*
   DEFINE l_aag181         LIKE aag_file.aag181
   DEFINE l_aag05          LIKE aag_file.aag05 
   DEFINE l_occ37          LIKE occ_file.occ37 
   DEFINE l_occ02          LIKE occ_file.occ02 
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_str            STRING
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
   DEFINE  l_bookno3      LIKE aza_file.aza82       #No.FUN-740009
   DEFINE  l_plant        LIKE type_file.chr10      #FUN-980020
 
      
    LET l_plant = p_plant                           #FUN-980020
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102      
    CALL s_get_bookno1(YEAR(g_aqe.aqe02),l_plant) RETURNING l_flag,l_bookno1,l_bookno2  #FUN-980020
    IF l_flag = '1' THEN
       CALL cl_err(YEAR(g_aqe.aqe02),'aoo-081',1)
       LET g_success = 'N'
    END IF
    #LET g_sql="SELECT * FROM ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="SELECT * FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
             " WHERE ooa01 ='",p_arno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_ooa5_p FROM g_sql
    IF SQLCA.sqlcode THEN                                 #NO.FUN-710050
     CALL s_errmsg('ooa01',p_arno,'',SQLCA.sqlcode,0)   #NO.FUN-710050
    END IF                                                #NO.FUN-710050
    EXECUTE t600_sel_ooa5_p INTO l_ooa.*
       
    LET l_npq.npqsys = 'AR'                                          
    LET l_npq.npq00  = 3                                            
    LET l_npq.npq01  = l_ooa.ooa01                                  
    LET l_npq.npq011 = 1                                         
    LET l_npq.npq21  = l_ooa.ooa03                                   
    LET l_npq.npq22  = l_ooa.ooa032
    LET l_npq.npq02  = 1
    LET l_npq.npqtype= p_npqtype
    
    #LET g_sql="SELECT occ02,occ37 FROM ",l_dbs CLIPPED,"occ_file",
    LET g_sql="SELECT occ02,occ37 FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
             " WHERE occ01 ='",l_ooa.ooa03,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_occ02_p FROM g_sql
    IF SQLCA.sqlcode THEN                                    #NO.FUN-710050
      CALL s_errmsg('occ01',l_ooa.ooa03,'',SQLCA.sqlcode,0)#NO.FUN-710050
    END IF                                                   #NO.FUN-710050    
    EXECUTE t600_sel_occ02_p INTO l_occ02,l_occ37 
    #LET g_sql="SELECT * FROM ",l_dbs CLIPPED,"oob_file",
    LET g_sql="SELECT * FROM ",cl_get_target_table(p_plant,'oob_file'), #FUN-A50102
             " WHERE oob01 ='",p_arno,"' ",
             "  ORDER BY oob02 "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_oob_p FROM g_sql
    IF SQLCA.sqlcode THEN                                     #NO.FUN-710050  
         CALL s_errmsg('oob01',p_arno,'',SQLCA.sqlcode,0 )  #NO.FUN-710050
    END IF                                                    #NO.FUN-710050
    DECLARE t600_sel_oob_c CURSOR FOR t600_sel_oob_p
    FOREACH t600_sel_oob_c INTO l_oob.*
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
       IF SQLCA.sqlcode THEN 
          CONTINUE FOREACH
       END IF
       IF p_npqtype = '0' THEN              
          LET l_npq.npq03 = l_oob.oob11
       ELSE                               
          LET l_npq.npq03 = l_oob.oob111  
       END IF                             
       LET l_npq.npq04 = l_oob.oob12
       #多此aag151判斷,異動碼4才不會全塞l_occ02值
       #異動碼四應該判斷aag181
       LET l_aag181=' '
       LET l_aag05=' '
     
       #LET g_sql="SELECT aag181,aag05 FROM ",l_dbs CLIPPED,"aag_file",
       LET g_sql="SELECT aag181,aag05 FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                " WHERE aag01 ='",l_oob.oob11,"'",
                "   AND aag00 ='",l_bookno1,"'"       #No.FUN-740009
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_sel_aag181_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL s_errmsg('aag01',l_oob.oob11,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050
       EXECUTE t600_sel_aag181_p INTO l_aag181,l_aag05
 
       IF l_occ37='Y' AND l_aag181 MATCHES '[23]' THEN  
          LET l_npq.npq14=l_occ02 CLIPPED
       ELSE
          LET l_npq.npq14=NULL
       END IF
 
       IF l_aag05='Y' THEN
          LET l_npq.npq05 = l_oob.oob13
       ELSE
          LET l_npq.npq05 = ' '
       END IF
       LET l_npq.npq06 = l_oob.oob03
       LET l_npq.npq07f= l_oob.oob09
       LET l_npq.npq07 = l_oob.oob10
       LET l_npq.npq23 = l_oob.oob06
       LET l_npq.npq24 = l_oob.oob07
       LET l_npq.npq25 = l_oob.oob08
       CASE
         WHEN l_oob.oob03='1' AND l_oob.oob04='1' 
              #LET g_sql="SELECT nmh11,nmh30 FROM ",l_dbs CLIPPED,"nmh_file",
              LET g_sql="SELECT nmh11,nmh30 FROM ",cl_get_target_table(p_plant,'nmh_file'), #FUN-A50102
                       " WHERE nmh01 ='",l_oob.oob06,"' AND nmh38 = 'Y'"
         WHEN l_oob.oob03='1' AND l_oob.oob04='2' 
              #LET g_sql="SELECT nmg18,nmg19 FROM ",l_dbs CLIPPED,"nmg_file",
              LET g_sql="SELECT nmg18,nmg19 FROM ",cl_get_target_table(p_plant,'nmg_file'), #FUN-A50102
                       " WHERE nmg00 ='",l_oob.oob06,"' AND nmgconf = 'Y'"
         WHEN l_oob.oob03='1' AND l_oob.oob04='3' 
              #LET g_sql="SELECT oma03,oma032 FROM ",l_dbs CLIPPED,"oma_file",
              LET g_sql="SELECT oma03,oma032 FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
                       " WHERE oma01 ='",l_oob.oob06,"' "
         WHEN l_oob.oob03='1' AND l_oob.oob04='9' 
              #LET g_sql="SELECT apa06,apa07  FROM ",l_dbs CLIPPED,"apa_file",
              LET g_sql="SELECT apa06,apa07  FROM ",cl_get_target_table(p_plant,'apa_file'), #FUN-A50102
                       " WHERE apa01 ='",l_oob.oob06,"' "
         WHEN l_oob.oob03='2' AND l_oob.oob04='1' 
              #LET g_sql="SELECT oma03,oma032 FROM ",l_dbs CLIPPED,"oma_file",
              LET g_sql="SELECT oma03,oma032 FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
                       " WHERE oma01 ='",l_oob.oob06,"' "
         WHEN l_oob.oob03='2' AND l_oob.oob04='9' 
              #LET g_sql="SELECT apa06,apa07  FROM ",l_dbs CLIPPED,"apa_file",
              LET g_sql="SELECT apa06,apa07  FROM ",cl_get_target_table(p_plant,'apa_file'), #FUN-A50102
                       " WHERE apa01 ='",l_oob.oob06,"' "
         OTHERWISE 
              LET l_npq.npq21 = l_ooa.ooa03 
              LET l_npq.npq22 = l_ooa.ooa032
       END CASE         
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_sel_qq_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL s_errmsg(' ',' ','',SQLCA.sqlcode,0) END IF#NO.FUN-710050
       EXECUTE t600_sel_qq_p INTO l_npq.npq21,l_npq.npq22
       IF cl_null(l_npq.npq21) THEN LET l_npq.npq21=l_ooa.ooa03 END IF
       IF cl_null(l_npq.npq22) THEN LET l_npq.npq22=l_ooa.ooa032 END IF
 
       MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
 
       IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
       IF l_npq.npqtype = '0' THEN
          LET l_bookno3 = l_bookno1
       ELSE
          LET l_bookno3 = l_bookno2
       END IF
 
       #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102       
       #LET g_sql="SELECT COUNT(*) FROM ",l_dbs CLIPPED,"aag_file",
       LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
                 " WHERE aag01 ='",l_npq.npq03,"'",
                 "   AND aag00 ='",l_bookno3,"'"       #No.FUN-740009
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_sel_aag_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL s_errmsg('aag01',l_npq.npq03,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050
       EXECUTE t600_sel_aag_p INTO l_n
       IF l_n <= 0 THEN
          LET l_str = l_oob.oob05 CLIPPED,' ',l_npq.npq03
          LET g_showmsg = l_bookno3,'/',l_npq.npq03                 
          CALL s_errmsg('aag00,aag01',g_showmsg,'',100,1)    
          LET g_success='N'
       END IF
       IF l_oob.oob03='1' AND l_oob.oob04='X' THEN
              LET l_npq.npq21 = l_ooa.ooa03 
              LET l_npq.npq22 = l_ooa.ooa032
       END IF
 
       IF l_oob.oob03 = '2' AND l_oob.oob05 <> g_plant THEN
          IF p_plant = g_plant THEN
             LET l_npq.npq21 = l_oob.oob05
             SELECT azp02 INTO l_npq.npq22 FROM azp_file
              WHERE azp01 = l_npq.npq21
             LET l_npq.npq23 = g_aqe.aqe01
          END IF
       END IF
       IF l_oob.oob03 = '1' AND l_oob.oob05 <> g_plant THEN
          IF p_plant <> g_plant THEN
             LET l_npq.npq21 = g_plant
             SELECT azp02 INTO l_npq.npq22 FROM azp_file
              WHERE azp01 = l_npq.npq21
             LET l_npq.npq23 = g_aqe.aqe01
          END IF
       END IF
 
       #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new   #FUN-A50102     
       #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"npq_file",
       LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
                "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,npq06,",
                " npq07f,npq07,npq08,npq21,",
                " npq22,npq23,npq24,npq25,",
                " npqtype,npqlegal)",    #FUN-980011 add
                " VALUES(?,?,?,?,?,?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?)"   #FUN-980011 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_ins_npq_p FROM g_sql
      EXECUTE t600_ins_npq_p USING l_npq.npqsys,l_npq.npq00,l_npq.npq01,l_npq.npq011,l_npq.npq02,l_npq.npq03,l_npq.npq04,l_npq.npq05,l_npq.npq06,
                                l_npq.npq07f,l_npq.npq07,l_npq.npq08,l_npq.npq21,
                                l_npq.npq22,l_npq.npq23,l_npq.npq24,l_npq.npq25,
                                l_npq.npqtype,g_legal    #FUN-980011 add
       IF SQLCA.sqlcode THEN
          LET g_showmsg=l_npq.npq00,"/",l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02     #NO.FUN-710050 
          CALL s_errmsg('npq00,npq01,npq011,npq02',g_showmsg,'ins npq:',SQLCA.sqlcode,1) #NO.FUN-710050
          LET g_success='N'
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          LET g_showmsg=l_npq.npq00,"/",l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02     #NO.FUN-710050 
          CALL s_errmsg('npq00,npq01,npq011,npq02',g_showmsg,'ins npq:',SQLCA.sqlcode,1) #NO.FUN-710050
          LET g_success='N'
          CONTINUE FOREACH       #NO.FUN-710050
       END IF  
       LET l_npq.npq02  = l_npq.npq02 + 1  
    END FOREACH
    CALL s_flows('3','',l_npq.npq01,g_aqe.aqe02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021 
    IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
    END IF                                                                          
    CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
    MESSAGE g_msg CLIPPED    
    
END FUNCTION
 
FUNCTION t600_ins_nme(p_code,p_plant)
   DEFINE p_code           LIKE type_file.chr1  
   DEFINE p_plant          LIKE type_file.chr21 
   DEFINE l_dbs            STRING
   DEFINE l_nme            RECORD LIKE nme_file.*
   DEFINE l_aqf            RECORD LIKE aqf_file.*
   DEFINE l_azp02          LIKE azp_file.azp02
   DEFINE l_aqd15          LIKE aqd_file.aqd15
   DEFINE l_aqd16          LIKE aqd_file.aqd16
   DEFINE l_aqd06          LIKE aqd_file.aqd06

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    IF cl_null(l_nme.nme04) THEN
       LET l_nme.nme04 = 0
    END IF
    IF cl_null(l_nme.nme08) THEN
       LET l_nme.nme08 = 0
    END IF
    LET g_sql=" SELECT SUM(aqf05f),SUM(aqf05) FROM aqf_file ",                   
              "  WHERE aqf01 ='",g_aqe.aqe01,"'",                                
              "    AND aqf03!='",g_plant,"'",                                    
              "    AND aqf03 ='",p_plant,"'"                                     
    PREPARE t600_sel_aqf05_c0 FROM g_sql                                           
    IF STATUS THEN                                        #NO.FUN-710050
        CALL s_errmsg('aqf01',g_aqe.aqe01,'',STATUS,0)  #NO.FUN-710050
    END IF                                                #NO.FUN-710050
    EXECUTE t600_sel_aqf05_c0 INTO l_nme.nme04,l_nme.nme08                         
    IF STATUS THEN                                                               
       CALL s_errmsg('aqf01',g_aqe.aqe01, 'sel aqf05:',STATUS,1)#NO.FUN-710050     
       LET g_success='N'                                                         
       RETURN                                                                    
    END IF                            
 
      LET l_nme.nme00 = 0    
      SELECT aqd06,aqd16 INTO l_nme.nme01,l_nme.nme03 FROM aqd_file WHERE aqd01 = p_plant
      LET l_nme.nme02 = g_aqe.aqe02                                                    
      LET l_nme.nme07 = l_nme.nme08/l_nme.nme04           
      #LET g_sql=" SELECT ooa01,oob02,oob04 FROM ",l_dbs,"ooa_file,",l_dbs,"oob_file",    #No.TQC-760074 
      LET g_sql=" SELECT ooa01,oob02,oob04 FROM ",cl_get_target_table(p_plant,'ooa_file'),",", #FUN-A50102
                                                  cl_get_target_table(p_plant,'oob_file'),     #FUN-A50102     
                "  WHERE ooa992='",g_aqe.aqe01,"'",  #No.FUN-730032
                "    AND ooa01 =oob01",              #No.FUN-730032                              
                "    AND oob03 = '1' ",              #No.TQC-760074
                "    AND oob04 = 'X' "               #No.TQC-760074
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_sel_aqf112_p FROM g_sql                                         
      IF STATUS THEN                                              #NO.FUN-710050
       CALL s_errmsg('ooa992',g_aqe.aqe01,'',STATUS,0)          #NO.FUN-710050     
      END IF                                                     
      LET l_nme.nme13 = g_aqe.aqe11
      LET l_nme.nme25 = g_aqe.aqe03                                  #No.FUN-730032
 
      #LET g_sql ="SELECT nmc05 FROM ",l_dbs CLIPPED,"nmc_file",
      LET g_sql ="SELECT nmc05 FROM ",cl_get_target_table(p_plant,'nmc_file'), #FUN-A50102
                 " WHERE nmc01 ='",l_nme.nme03,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_sel_nmc_p FROM g_sql
         CALL s_errmsg('nmc01',l_nme.nme03,'',SQLCA.sqlcode,0) #NO.FUN-710050     
      EXECUTE t600_sel_nmc_p INTO l_nme.nme14
 
      IF cl_null(l_nme.nme14) THEN LET l_nme.nme14 = ' ' END IF
      LET l_nme.nme17   = ""
      LET l_nme.nmeacti = 'Y'                                          
      LET l_nme.nmeuser = g_user                                          
      LET l_nme.nmegrup = g_grup                                           
      LET l_nme.nmedate = g_today 
      LET l_nme.nme15   = g_aqe.aqe05
      LET l_nme.nme16   = g_aqe.aqe02
      #LET g_sql="INSERT INTO ",l_dbs,"nme_file", 
      LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'nme_file'), #FUN-A50102     
                "(nme00,nme01,nme02,nme03,nme04, nme08,nme07,nme12,nme13,",
                " nme14,nme17,",
                " nmeacti,nmeuser,nmegrup,nmedate,nme15,nme16,nme21,nme22,nme23,nme24,nme25,",       #No.FUN-730032
#               " nmelegal,nmeoriu,nmeorig) ",   #FUN-A10036 #FUN-980011 add   #FUN-B30166--Mark
                " nme27,nmelegal,nmeoriu,nmeorig) ",   #FUN-B30166  Add
#               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,  ?,?,?)"  #FUN-A10036 #No.FUN-730032 #FUN-980011 add #FUN-B30166--Mark
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-B30166  Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_ins_nme_p1 FROM g_sql
       IF SQLCA.sqlcode THEN                          #NO.FUN-710050
            CALL s_errmsg(' ',' ','',SQLCA.sqlcode,0) #NO.FUN-710050 
       END IF                                         #NO.FUN-710050
      DECLARE t600_sel_aqf112_c CURSOR FOR t600_sel_aqf112_p
      OPEN t600_sel_aqf112_c
      FOREACH t600_sel_aqf112_c INTO l_nme.nme12,l_nme.nme21,l_nme.nme23
         IF STATUS THEN 
            CALL s_errmsg('ooa992',g_aqe.aqe01,'sel ooa01:',STATUS,1)  
            LET g_success='N'                                                      
            RETURN                                                                 
         END IF
         LET l_nme.nme22 ='X'
         LET l_nme.nme24 ='9'

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

         EXECUTE t600_ins_nme_p1 USING l_nme.nme00,l_nme.nme01,l_nme.nme02,l_nme.nme03,l_nme.nme04,
                                  l_nme.nme08,l_nme.nme07,l_nme.nme12,l_nme.nme13,
                                  l_nme.nme14,l_nme.nme17,
                                  l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmedate,
                                  l_nme.nme15,l_nme.nme16,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,
#                                 g_legal,g_user,g_grup  #FUN-A10036    #FUN-980011 add   #FUN-B30166--Mark
                                  l_nme27,g_legal,g_user,g_grup  #FUN-B30166  Add
         
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('nme02',l_nme.nme02,'ims nme:',SQLCA.sqlcode,1)  #NO.FUN-710050
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('nme02',l_nme.nme02,'ims nme:',SQLCA.SQLCODE,1)  #NO.FUN-710050
            LET g_success='N'
            RETURN
         END IF
         CALL s_flows_nme(l_nme.*,'1',p_plant)   #No.FUN-B90062   
      END FOREACH
      #在總部插入與分公司的nme對應的nme資料                                           
      SELECT aqd06,aqd16 INTO  l_nme.nme01,l_nme.nme03                          
        FROM aqd_file                                                           
       WHERE aqd01 = g_plant                                                    
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file WHERE nmc01 =l_nme.nme03      
      IF STATUS THEN                                                            
         CALL s_errmsg('aqd01',g_plant,'sel nmc05:',STATUS,1)           #NO.FUN-710050
         LET g_success='N'                                                      
         RETURN                                                                 
      END IF                                                                    
      DECLARE t600_sel_aqf112_p1 CURSOR FOR
       SELECT ooa01,oob02,oob04 FROM ooa_file,oob_file                              
        WHERE ooa992=g_aqe.aqe01 
          AND ooa01 =oob01                                                
          AND oob03 = '1'  #No.TQC-760074
      IF STATUS THEN                                                            
         CALL s_errmsg('ooa992',g_aqe.aqe01,'sel nmc05:',STATUS,1)           #NO.FUN-710050
         LET g_success='N'                                                      
         RETURN                                                                 
      END IF                 
 
      FOREACH t600_sel_aqf112_p1 INTO l_nme.nme12,l_nme.nme21,l_nme.nme23         
         IF STATUS THEN 
            CALL s_errmsg('ooa992',g_aqe.aqe01,'sel ooa01:',STATUS,1)  
            LET g_success='N'                                                      
            RETURN                                                                 
         END IF
         LET l_nme.nme22 ='X'
         LET l_nme.nme24 ='9'
         LET l_nme.nme00=0                     #No.FUN-9C0012
         LET l_nme.nme02=g_aqe.aqe02           #No.FUN-9C0012
         INSERT INTO nme_file
            (nme00,nme01,nme02,nme03,nme04, nme08,nme07,nme12,nme13,
             nme14,nme17,
             nmeacti,nmeuser,nmegrup,nmedate,nme15,nme16,nme21,nme22,nme23,nme24,nme25,
             nmelegal,nmeoriu,nmeorig)       #FUN-980011 add
             VALUES(l_nme.nme00,l_nme.nme01,l_nme.nme02,l_nme.nme03,l_nme.nme04,
                    l_nme.nme08,l_nme.nme07,l_nme.nme12,l_nme.nme13,
                    l_nme.nme14,l_nme.nme17,
                    l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmedate,
                    l_nme.nme15,l_nme.nme16,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,
                    g_legal, g_user, g_grup) #FUN-980011 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
         
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('nme02',l_nme.nme02,'ins nme:',SQLCA.sqlcode,1)     #NO.FUN-710050
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('nme02',l_nme.nme02,'ins nme:',SQLCA.sqlcode,1)     #NO.FUN-710050
            LET g_success='N'
            RETURN
         END IF
         CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
      END FOREACH
 
END FUNCTION
 
FUNCTION t600_ins_oma(p_plant,p_artype,p_arno,p_aqf11)
    DEFINE p_artype     LIKE oma_file.oma00
    DEFINE l_oma       RECORD LIKE oma_file.*
    DEFINE l_omb       RECORD LIKE omb_file.*
    DEFINE l_omc       RECORD LIKE omc_file.*
    DEFINE li_result   LIKE type_file.num5  
    DEFINE p_plant     LIKE type_file.chr21 
    DEFINE p_arno      LIKE ooa_file.ooa01
    DEFINE p_aqf11     LIKE aqf_file.aqf11
    DEFINE l_aqf11     LIKE aqf_file.aqf11
    DEFINE l_dbs       STRING
    DEFINE l_azp02     LIKE azp_file.azp02
    DEFINE l_oma04     LIKE oma_file.oma04
    DEFINE l_oma05     LIKE oma_file.oma05
    DEFINE l_oma044    LIKE oma_file.oma044
    DEFINE l_oma043    LIKE oma_file.oma043
    DEFINE l_plant     LIKE type_file.chr10        #FUN-980020
      
    LET l_oma.oma00 = p_artype
    LET l_oma.oma02 = g_aqe.aqe02
    LET l_oma.oma01 = p_arno
    
    IF p_artype = '22' THEN
       LET l_plant = g_plant                       #FUN-980020
       LET g_plant_new=g_plant CALL s_getdbs() LET l_dbs=g_dbs_new 
    ELSE
       LET l_plant = p_plant                       #FUN-980020
       LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new 
    END IF
 
    CALL s_auto_assign_no("axr",l_oma.oma01,l_oma.oma02,p_artype,"oma_file","oma01",g_plant_new,"","")  #FUN-980094 add #TQC-9B0219 mod
         RETURNING li_result,l_oma.oma01 
    IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
    END IF
      
    IF p_artype = '14' THEN   #被收
       LET l_oma.oma03 = g_plant  #收款法人體  
    ELSE
       LET l_oma.oma03 = p_plant  #被收款法人體
    END IF
    #LET g_sql="SELECT azp02 FROM ",l_dbs CLIPPED,"azp_file",
    LET g_sql="SELECT azp02 FROM ",cl_get_target_table(l_plant,'azp_file'), #FUN-A50102
             " WHERE azp01 ='",l_oma.oma03,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_azp_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL s_errmsg('azp01',l_oma.oma03,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050 
    EXECUTE t600_sel_azp_p INTO l_azp02
   
    LET l_oma.oma032= l_azp02 
    LET l_oma.oma68 = l_oma.oma03
    LET l_oma.oma69 = l_oma.oma032
 
    #LET g_sql="SELECT occ1022,occ18,occ231,occ08 FROM ",l_dbs CLIPPED,"occ_file",
LET g_sql="SELECT occ1022,occ18,occ231,occ08 FROM ",cl_get_target_table(l_plant,'occ_file'), #FUN-A50102  
              " WHERE occ01 ='",l_oma.oma03,"'"                                  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_occ_p FROM g_sql                                           
    IF SQLCA.sqlcode THEN CALL s_errmsg('occ01',l_oma.oma03,'',SQLCA.sqlcode,0) END IF #NO.FUN-710050 
    EXECUTE t600_sel_occ_p INTO l_oma04,l_oma043,l_oma044,l_oma05
   
    LET l_oma.oma06 = ''
    LET l_oma.oma07 = 'N'
    LET l_oma.oma08 = '1'
    LET l_oma.oma09 = l_oma.oma02
    CALL s_rdatem(l_oma.oma03,l_oma.oma32,l_oma.oma02,l_oma.oma09,
                  l_oma.oma02,l_plant)        #FUN-980020
        RETURNING l_oma.oma11,l_oma.oma12
 
    LET l_oma.oma13 = g_aqf11
    LET l_oma.oma14 = g_aqe.aqe04
    LET l_oma.oma15 = g_aqe.aqe05
    LET l_oma.oma161=0
    LET l_oma.oma162=100
    LET l_oma.oma163=0
    LET l_oma.oma70 = '2'    #手工  #No.TQC-9C0133
 
    LET g_sql ="SELECT aqf11 FROM aqf_file",
               " WHERE aqf00 ='",g_aqe.aqe00,"'",
               "   AND aqf01 ='",g_aqe.aqe01,"'"
    PREPARE t600_aqf48_p FROM g_sql                                                                                                 
    IF SQLCA.sqlcode THEN                                         #NO.FUN-710050   
      LET g_showmsg=g_aqe.aqe00,"/",g_aqe.aqe01                   #NO.FUN-710050  
      CALL s_errmsg('aqf00,aqf01',g_showmsg,'',SQLCA.sqlcode,0)   #NO.FUN-710050
    END IF                                                        #NO.FUN-710050 
    DECLARE t600_aqf48_c CURSOR FOR t600_aqf48_p
    FOREACH t600_aqf48_c INTO l_aqf11
        LET g_sql = " SELECT ool11,ool111 ",  
                    #"   FROM ",l_dbs CLIPPED,"ool_file ",
                    "   FROM ",cl_get_target_table(l_plant,'ool_file'), #FUN-A50102  
                    "  WHERE ool01 = '",l_aqf11,"' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE t600_str37 FROM g_sql
        DECLARE t600_str38 CURSOR FOR t600_str37
        OPEN t600_str38  
        FETCH t600_str38 INTO l_oma.oma18,l_oma.oma181
    END FOREACH
 
    LET l_oma.oma20 = 'Y'
    LET l_oma.oma21 = g_aqf13
 
    #LET g_sql="SELECT gec04,gec05,gec07 FROM ",l_dbs CLIPPED,"gec_file",
    LET g_sql="SELECT gec04,gec05,gec07 FROM ",cl_get_target_table(l_plant,'gec_file'), #FUN-A50102      
              " WHERE gec01 ='",l_oma.oma21,"' AND gec02 = '2' "                                  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_gec1_p FROM g_sql                                           
    IF SQLCA.sqlcode THEN
      LET g_showmsg=l_oma.oma21,"/",'2'
      CALL s_errmsg('gec01,gec02',g_showmsg,'',SQLCA.sqlcode,0)
    END IF  
    EXECUTE t600_sel_gec1_p INTO l_oma.oma211,l_oma.oma212,l_oma.oma213
 
    LET l_oma.oma23 = g_aqe.aqe06
    LET l_oma.oma32 = g_aqf12
    LET l_oma.oma40 = 'Y'
    LET l_oma.oma50 = g_amtf
    LET l_oma.oma50t= g_amtf
    LET l_oma.oma51f = 0
    LET l_oma.oma51  = 0
    LET l_oma.oma65  = '1'
    LET l_oma.oma52 = 0 
    LET l_oma.oma53 = 0
    LET l_oma.oma54 = g_amtf
    LET l_oma.oma54x= 0
    LET l_oma.oma54t= g_amtf
    LET l_oma.oma55 = 0       
    LET l_oma.oma56 = g_amt
    LET l_oma.oma56x= 0
    LET l_oma.oma56t= g_amt
    LET l_oma.oma57 = 0  
    LET l_oma.oma24 = g_amt/g_amtf
    LET l_oma.oma58 = l_oma.oma24
    LET l_oma.oma59 = g_amt
    LET l_oma.oma59x= g_amt
    LET l_oma.oma59t= g_amt
    LET l_oma.oma60 = l_oma.oma24
    LET l_oma.oma61 = g_amt
    LET l_oma.oma992  = g_aqe.aqe01
    LET l_oma.omaconf = 'Y'
    LET l_oma.omavoid = 'N'
    LET l_oma.omaprsw = 0
    LET l_oma.omauser = g_aqe.aqeuser
    LET l_oma.omagrup = g_aqe.aqegrup
    LET l_oma.omamodu = g_aqe.aqemodu
    LET l_oma.omadate = g_aqe.aqedate
    LET l_oma.omamksg = g_aqe.aqemksg
    LET l_oma.oma64   = '1'
 
#No.FUN-AB0034 --begin
    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
       #LET g_sql="INSERT INTO ",l_dbs,"oma_file", 
       LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'oma_file'), #FUN-A50102       
                 "(oma00,oma01,oma02,oma03,oma032, ",
                 " oma04,oma043,oma044,oma05,oma06,",
                 " oma07,oma08,oma09,oma11,oma12,  ",
                 " oma13,oma14,oma15,oma161,oma162,",
                 " oma163,oma18,oma181,oma20,oma21,",
                 " oma211,oma212,oma213,oma23,oma32,",
                 " oma40,oma50,oma50t,oma51f,oma51, ",
                 " oma65,oma52,oma53,oma54,oma54x,  ",
                 " oma54t,oma55,oma56,oma56x,oma56t,",
                 " oma57,oma24,oma58,oma59,oma59x,  ",
                 " oma59t,oma60,oma61,oma992,omaconf,",
                 " omavoid,omaprsw,omauser,omagrup,omamodu,",
                 " omadate,omamksg,oma64,oma68,oma69, ",
                 " omalegal,oma70,omaoriu,omaorig,oma73,oma73f,oma74 ) ", #FUN-A10034 #FUN-980011 add  #No.TQC-9C0133  FUN-AB0034 add oma73,oma73f,oma74
                                                    
            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                    "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                    "?,?,?,?,?, ",
                    "?,?,?,?,?,?,? )"     #FUN-A10036  #FUN-980011 add  #No.TQC-9C0133   FUN-AB0034 add ???
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_ins_oma_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL s_errmsg('','','',SQLCA.sqlcode,1) END IF #NO.FUN-710050 
       EXECUTE t600_ins_oma_p USING l_oma.oma00,l_oma.oma01,l_oma.oma02,l_oma.oma03,l_oma.oma032,
                                 l_oma04,l_oma043,l_oma044,l_oma05,l_oma.oma06,
                                 l_oma.oma07,l_oma.oma08,l_oma.oma09,l_oma.oma11,l_oma.oma12,
                                 l_oma.oma13,l_oma.oma14,l_oma.oma15,l_oma.oma161,l_oma.oma162,
                                 l_oma.oma163,l_oma.oma18,l_oma.oma181,l_oma.oma20,l_oma.oma21,
                                 l_oma.oma211,l_oma.oma212,l_oma.oma213,l_oma.oma23,l_oma.oma32,
                                 l_oma.oma40,l_oma.oma50,l_oma.oma50t,l_oma.oma51f,l_oma.oma51,
                                 l_oma.oma65,l_oma.oma52,l_oma.oma53,l_oma.oma54,l_oma.oma54x,
                                 l_oma.oma54t,l_oma.oma55,l_oma.oma56,l_oma.oma56x,l_oma.oma56t,
                                 l_oma.oma57,l_oma.oma24,l_oma.oma58,l_oma.oma59,l_oma.oma59x,
                                 l_oma.oma59t,l_oma.oma60,l_oma.oma61,l_oma.oma992,l_oma.omaconf,
                                 l_oma.omavoid,l_oma.omaprsw,l_oma.omauser,l_oma.omagrup,l_oma.omamodu,
                                 l_oma.omadate,l_oma.omamksg,l_oma.oma64,l_oma.oma68,l_oma.oma69,
                                 g_legal,l_oma.oma70,g_user,g_grup,l_oma.oma73,l_oma.oma73f,l_oma.oma74    #FUN-A10036    #FUN-9A0099  #No.FUN-9C0133  FUN-AB0034 add oma73,oma73f,oma74
 
    IF SQLCA.sqlcode THEN
       LET g_showmsg=l_oma.oma01,"/",l_oma.oma02  #NO.FUN-710050
       CALL s_errmsg('oma01,oma02',g_showmsg,'ins oma:',SQLCA.sqlcode,1) #NO.FUN-710050 
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg=l_oma.oma01,"/",l_oma.oma02  #NO.FUN-710050
       CALL s_errmsg('oma01,oma02',g_showmsg,'ins oma:',SQLCA.SQLCODE,1) #NO.FUN-710050 
       LET g_success='N'
       RETURN
    END IF
 
    LET l_omb.omb00 = l_oma.oma00
    LET l_omb.omb01 = l_oma.oma01
    LET l_omb.omb03 = 1
    LET l_omb.omb14 = l_oma.oma54
    LET l_omb.omb14t= l_oma.oma54t
    LET l_omb.omb16 = l_oma.oma56
    LET l_omb.omb16t= l_oma.oma56t
    LET l_omb.omb33 = l_oma.oma18
    LET l_omb.omb331= l_oma.oma181
    LET l_omb.omb34 = l_oma.oma55
    LET l_omb.omb35 = l_oma.oma57
    LET l_omb.omb36 = l_oma.oma60
    LET l_omb.omb37 = l_oma.oma61
    LET l_omb.omb930= l_oma.oma930
 
    LET l_omb.omb04 = 'MISC'
    LET l_omb.omb06 = 'MISC'
    LET l_omb.omb05 = 'PCS'
    LET l_omb.omb12 = 1
    LET l_omb.omb13 = l_omb.omb14
    LET l_omb.omb17 = l_omb.omb13
    LET l_omb.omb18 = l_omb.omb16
    LET l_omb.omb18t= l_omb.omb16t
    LET l_omb.omb15 = l_omb.omb16
    
    #LET g_sql="INSERT INTO ",l_dbs,"omb_file",
    LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'omb_file'), #FUN-A50102   
              "(omb00,omb01,omb03, ",
              " omb14,omb14t,omb16,omb16t,",
              " omb33,omb331,omb34,omb35,omb36,",
              " omb37,omb930,",
              " omb04,omb06,omb05,omb12,omb13,omb17,omb18,omb18t,omb15,",    
              " omblegal) ",   #FUN-980011 add #TQC-9B0207  
         " VALUES(?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?, ?,?,?,?,?,?,?,?,?,?)"  #FUN-980011 add 
    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_ins_omb_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL s_errmsg('','','',SQLCA.sqlcode,1) END IF #NO.FUN-710050 
    EXECUTE t600_ins_omb_p USING l_omb.omb00,l_omb.omb01,l_omb.omb03,
                              l_omb.omb14,l_omb.omb14t,l_omb.omb16,l_omb.omb16t,
                              l_omb.omb33,l_omb.omb331,l_omb.omb34,l_omb.omb35,l_omb.omb36,
                              l_omb.omb37,l_omb.omb930,
                              l_omb.omb04,l_omb.omb06,l_omb.omb05,l_omb.omb12,
                              l_omb.omb13,l_omb.omb17,l_omb.omb18,l_omb.omb18t,
                              l_omb.omb15,g_legal    #FUN-980011 add
 
    IF SQLCA.sqlcode THEN
       LET g_showmsg=l_omb.omb01,"/",l_omb.omb03  #NO.FUN-710050
       CALL s_errmsg('omb01,omb02',g_showmsg,'ins omb:',SQLCA.sqlcode,1) #NO.FUN-710050 
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg=l_omb.omb01,"/",l_omb.omb03  #NO.FUN-710050
       CALL s_errmsg('omb01,omb03',g_showmsg,'ins omb:',SQLCA.SQLCODE,1) #NO.FUN-710050 
       LET g_success='N'
       RETURN
    END IF
    
    LET l_omc.omc01 = l_oma.oma01
    LET l_omc.omc02 = 1
    LET l_omc.omc03 = l_oma.oma32
    LET l_omc.omc04 = l_oma.oma11
    LET l_omc.omc05 = l_oma.oma12
    LET l_omc.omc06 = l_oma.oma24
    LET l_omc.omc07 = l_oma.oma60
    LET l_omc.omc08 = l_oma.oma54t
    LET l_omc.omc09 = l_oma.oma56t
    LET l_omc.omc10 = l_oma.oma55
    LET l_omc.omc11 = l_oma.oma57
    LET l_omc.omc13 = l_oma.oma61
    LET l_omc.omc14 = l_oma.oma51
    LET l_omc.omc15 = l_oma.oma51f
 
    #LET g_sql="INSERT INTO ",l_dbs,"omc_file",
    LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'omc_file'), #FUN-A50102      
              "(omc01,omc02,omc03,omc04,omc05, ",
              " omc06,omc07,omc08,omc09,omc10, ",
              " omc11,omc13,omc14,omc15,omclegal)",  #FUN-980011 add
         " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  #FUN-980011 add
    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_ins_omc_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL s_errmsg('','','',SQLCA.sqlcode,1) END IF #NO.FUN-710050 
    EXECUTE t600_ins_omc_p USING l_omc.omc01,l_omc.omc02,l_omc.omc03,l_omc.omc04,l_omc.omc05,
                              l_omc.omc06,l_omc.omc07,l_omc.omc08,l_omc.omc09,l_omc.omc10,
                              l_omc.omc11,l_omc.omc13,l_omc.omc14,l_omc.omc15,
                              g_legal
 
    IF SQLCA.sqlcode THEN
       LET g_showmsg=l_omc.omc01,"/",l_omc.omc02  #NO.FUN-710050
       CALL s_errmsg('omc01,omc02',g_showmsg,'ins omc:',SQLCA.SQLCODE,1) #NO.FUN-710050 
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       LET g_showmsg=l_omc.omc01,"/",l_omc.omc02  #NO.FUN-710050
       CALL s_errmsg('omc01,omc02',g_showmsg,'ins omc:',SQLCA.sqlcode,1) #NO.FUN-710050 
       LET g_success='N'
       RETURN
    END IF    
 
END FUNCTION
 
FUNCTION t600_omac_ins(p_plant)
  DEFINE l_aqd         RECORD LIKE aqd_file.* 
  DEFINE p_plant       LIKE type_file.chr21 
 
  DECLARE t600_aqf_1c CURSOR FOR
   SELECT aqf03,aqf11,aqf12,aqf13,SUM(aqf05f),SUM(aqf05) FROM aqf_file
    WHERE aqf01 = g_aqe.aqe01
      AND aqf00 = g_aqe.aqe00
    GROUP BY aqf03,aqf11,aqf12,aqf13
    ORDER BY aqf03
   FOREACH t600_aqf_1c INTO g_aqf03,g_aqf11,g_aqf12,g_aqf13,g_amtf,g_amt
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
     IF SQLCA.sqlcode THEN 
        CONTINUE FOREACH
     END IF   
     IF g_aqf03 <> p_plant AND p_plant <> g_plant THEN                         
        CONTINUE FOREACH                                                       
     END IF  
     SELECT * INTO l_aqd.* FROM aqd_file WHERE aqd01 = p_plant
     IF p_plant = g_plant THEN
        IF g_aqf03 = g_plant THEN CONTINUE FOREACH END IF
        CALL t600_ins_oma(g_aqf03,'22',l_aqd.aqd10,g_aqf11)    #No.TQC-6C0073
     ELSE
        CALL t600_ins_oma(p_plant,'14',l_aqd.aqd09,g_aqf11)
     END IF   
   END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
END FUNCTION
 
FUNCTION t600_omac_upd(p_code)
   DEFINE p_code      LIKE type_file.chr1
   DEFINE l_aqf03     LIKE aqf_file.aqf03
   DEFINE l_aqf04     LIKE aqf_file.aqf04
   DEFINE l_aqf06     LIKE aqf_file.aqf06
   DEFINE l_aqf05f    LIKE aqf_file.aqf05f
   DEFINE l_aqf05     LIKE aqf_file.aqf05
   
  DECLARE t600_aqf_2c CURSOR FOR
   SELECT aqf03,aqf04,aqf06,aqf05,aqf05f FROM aqf_file
    WHERE aqf01 = g_aqe.aqe01
      AND aqf00=g_aqe.aqe00
   FOREACH t600_aqf_2c INTO l_aqf03,l_aqf04,l_aqf06,l_aqf05,l_aqf05f
      IF SQLCA.sqlcode THEN 
         CONTINUE FOREACH
      END IF   
   CALL t600_upd_omc(l_aqf03,l_aqf04,l_aqf06,l_aqf05,l_aqf05f,p_code)
   END FOREACH
 
END FUNCTION
 
FUNCTION t600_upd_omc(p_plant,p_arno,p_line,p_amt,p_amtf,p_code)
   DEFINE p_plant          LIKE type_file.chr21
   DEFINE p_line           LIKE aqf_file.aqf06
   DEFINE p_amt            LIKE aqf_file.aqf05
   DEFINE p_amtf           LIKE aqf_file.aqf05f
   DEFINE p_arno           LIKE aqf_file.aqf04
   DEFINE l_dbs            STRING
   DEFINE l_oma            RECORD LIKE oma_file.*
   DEFINE l_omc            RECORD LIKE omc_file.* 
   DEFINE p_code           LIKE type_file.chr1
         
      #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
      IF p_code ='0' THEN     #審核更新
         #LET g_sql="UPDATE ",l_dbs CLIPPED,"oma_file",
         LET g_sql="UPDATE ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
                   " SET oma55 = oma55 + '",p_amtf,"',oma57 = oma57 + '",p_amt,"',",
                   "     oma61 = oma61 - '",p_amt,"'",
                   " WHERE oma01 ='",p_arno,"'"
      ELSE                    #撤銷審核更新
         #LET g_sql="UPDATE ",l_dbs CLIPPED,"oma_file",
         LET g_sql="UPDATE ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
                   " SET oma55 = oma55 - '",p_amtf,"',oma57 = oma57 - '",p_amt,"',",
                   "     oma61 = oma61 + '",p_amt,"'",
                   " WHERE oma01 ='",p_arno,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_upd_oma_p FROM g_sql
      IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
      EXECUTE t600_upd_oma_p
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd oma:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
      
      IF p_code ='0' THEN     #審核更新
         #LET g_sql="UPDATE ",l_dbs CLIPPED,"omc_file",
         LET g_sql="UPDATE ",cl_get_target_table(p_plant,'omc_file'), #FUN-A50102
                   " SET omc10 = omc10 + '",p_amt,"',omc11 = omc11 + '",p_amtf,"',",
                   "     omc13 = omc13 - '",p_amt,"'",
                   " WHERE omc01 ='",p_arno,"'",
                   "   AND omc02 ='",p_line,"'"
      ELSE                    #撤銷審核更新
         #LET g_sql="UPDATE ",l_dbs CLIPPED,"omc_file",
         LET g_sql="UPDATE ",cl_get_target_table(p_plant,'omc_file'), #FUN-A50102
                   " SET omc10 = omc10 - '",p_amt,"',omc11 = omc11 - '",p_amtf,"',",
                   "     omc13 = omc13 + '",p_amt,"'",
                   " WHERE omc01 ='",p_arno,"'",
                   "   AND omc02 ='",p_line,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE t600_upd_omc_p FROM g_sql
      IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
      EXECUTE t600_upd_omc_p
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd omc:',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
 
END FUNCTION
	
FUNCTION t600_chk_voucher(p_plant)
   DEFINE   l_ooa01        LIKE ooa_file.ooa01
   DEFINE   l_ooa33        LIKE ooa_file.ooa33
   DEFINE   l_nppglno      LIKE npp_file.nppglno
   DEFINE   l_nppglno1     LIKE npp_file.nppglno
   DEFINE   p_plant        LIKE azp_file.azp01  
   
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET g_sql="SELECT ooa01,ooa33 FROM ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="SELECT ooa01,ooa33 FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
             " WHERE ooa992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_ooa33_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    DECLARE t600_sel_ooa33_c CURSOR FOR t600_sel_ooa33_p
    FOREACH t600_sel_ooa33_c INTO l_ooa01,l_ooa33
       #LET g_sql="SELECT nppglno FROM ",l_dbs CLIPPED,"npp_file",
       LET g_sql="SELECT nppglno FROM ",cl_get_target_table(p_plant,'npp_file'), #FUN-A50102
                " WHERE npp01 ='",l_ooa01,"'",
                "   AND nppsys='AR'",
                "   AND npp00 ='3'",
                "   AND npp011='1'",
                "   AND npptype ='0'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
       PREPARE t600_sel_nppglno_p FROM g_sql
       IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
       EXECUTE t600_sel_nppglno_p INTO l_nppglno
       IF g_aza.aza63 ='Y' THEN
          #LET g_sql="SELECT nppglno FROM ",l_dbs CLIPPED,"npp_file",
          LET g_sql="SELECT nppglno FROM ",cl_get_target_table(p_plant,'npp_file'), #FUN-A50102
                    " WHERE npp01 ='",l_ooa01,"'",
                    "   AND nppsys='AR'",
                    "   AND npp00 ='3'",
                    "   AND npp011='1'",
                    "   AND npptype ='1'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
          PREPARE t600_sel_nppglno_p1 FROM g_sql
          IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
          EXECUTE t600_sel_nppglno_p1 INTO l_nppglno1
          IF NOT cl_null(l_ooa33) OR NOT cl_null(l_nppglno) OR NOT cl_null(l_nppglno1) THEN
             CALL cl_err('','axm-316','1')
             LET g_success ='N'
             RETURN
          END IF
       ELSE
          IF NOT cl_null(l_ooa33) OR NOT cl_null(l_nppglno)  THEN
             CALL cl_err('','axm-316','1')
             LET g_success ='N'
             RETURN
          END IF     	
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION t600_chk_contra(p_plant)
   DEFINE p_plant     LIKE azp_file.azp01  
   DEFINE l_oma55     LIKE oma_file.oma55
   DEFINE l_oma57     LIKE oma_file.oma57
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET g_sql="SELECT oma55,oma57 FROM ",l_dbs CLIPPED,"oma_file",
    LET g_sql="SELECT oma55,oma57 FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
             " WHERE oma992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_oma55_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    DECLARE t600_sel_oma55_c CURSOR FOR t600_sel_oma55_p
    FOREACH t600_sel_oma55_c INTO l_oma55,l_oma57
        IF cl_null(l_oma55) THEN LET l_oma55 = 0 END IF
        IF cl_null(l_oma57) THEN LET l_oma57 = 0 END IF
        IF l_oma55 > 0 OR l_oma57 > 0 THEN
           CALL cl_err('','axm-316','1')
           LET g_success ='N'
           ROLLBACK WORK
           RETURN
        END IF
    END FOREACH          
END FUNCTION
 
FUNCTION t600_del_npp(p_plant)
   DEFINE  p_plant     LIKE azp_file.azp01  
   DEFINE  l_ooa01     LIKE ooa_file.ooa01                                      
                                                                                
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102               
    #LET g_sql="SELECT ooa01 FROM ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="SELECT ooa01 FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102    
             "  WHERE ooa992 ='",g_aqe.aqe01,"'"                                 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_ooa_p9 FROM g_sql                                          
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF                              
    EXECUTE t600_sel_ooa_p9 INTO l_ooa01                
      
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"npp_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'npp_file'), #FUN-A50102
              " WHERE npp01 = '",l_ooa01,"' ",
              "   AND nppsys= 'AR'",
              "   AND npp00 = '3' ",
              "   AND npp011= '1' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_npp_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    EXECUTE t600_del_npp_p
    IF SQLCA.sqlcode THEN
       CALL cl_err('del npp:',SQLCA.sqlcode,1)
       LET g_success='N'
       ROLLBACK WORK 
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t600_del_npq(p_plant)
   DEFINE  p_plant     LIKE azp_file.azp01  
   DEFINE  l_ooa01     LIKE ooa_file.ooa01                                      
                                                                                
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102                
    #LET g_sql="SELECT ooa01 FROM ",l_dbs CLIPPED,"ooa_file", 
    LET g_sql="SELECT ooa01 FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
             "  WHERE ooa992 ='",g_aqe.aqe01,"'"                                 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_ooa_p8 FROM g_sql                                          
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF                              
    EXECUTE t600_sel_ooa_p8 INTO l_ooa01                
    
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"npq_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
              " WHERE npq01 = '",l_ooa01,"' ",
              "   AND npqsys= 'AR'",
              "   AND npq00 = '3' ",
              "   AND npq011= '1' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_npq_p FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    EXECUTE t600_del_npq_p
    IF SQLCA.sqlcode THEN
       CALL cl_err('del npq:',SQLCA.sqlcode,1)
       LET g_success='N'
       ROLLBACK WORK 
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t600_del_oob(p_plant)
   DEFINE  p_plant     LIKE azp_file.azp01  
   DEFINE  l_ooa01     LIKE ooa_file.ooa01
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET g_sql="SELECT ooa01 FROM ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="SELECT ooa01 FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
              " WHERE ooa992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_ooa_p7 FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    EXECUTE t600_sel_ooa_p7 INTO l_ooa01
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"oob_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'oob_file'), #FUN-A50102
             " WHERE oob01 = '",l_ooa01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_oob_p FROM g_sql
    EXECUTE t600_del_oob_p
    IF SQLCA.sqlcode THEN
       LET g_success ='N'
       ROLLBACK WORK 
       RETURN
    END IF
END FUNCTION
 
FUNCTION t600_del_ooa(p_plant)
   DEFINE  p_plant     LIKE azp_file.azp01  
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102    
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"ooa_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'ooa_file'), #FUN-A50102
             " WHERE ooa992 = '",g_aqe.aqe01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_ooa_p FROM g_sql
    EXECUTE t600_del_ooa_p
    IF SQLCA.sqlcode THEN
       LET g_success ='N'
       ROLLBACK WORK 
       RETURN
    END IF
END FUNCTION
 
FUNCTION t600_del_omac(p_plant)
   DEFINE   l_oma01    LIKE oma_file.oma01
   DEFINE  p_plant     LIKE azp_file.azp01  
 
    #LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    #LET g_sql="SELECT oma01 FROM ",l_dbs CLIPPED,"oma_file",
    LET g_sql="SELECT oma01 FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
              " WHERE oma992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_sel_oma_p7 FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
    DECLARE t600_sel_oma_c7 CURSOR FOR t600_sel_oma_p7                            
    FOREACH t600_sel_oma_c7 INTO l_oma01       
   
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"omb_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'omb_file'), #FUN-A50102
             " WHERE omb01 = '",l_oma01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_omb_p FROM g_sql
    EXECUTE t600_del_omb_p
    IF SQLCA.sqlcode THEN
       CALL cl_err('del omb',SQLCA.sqlcode,0)
       LET g_success ='N'
       ROLLBACK WORK 
       RETURN
    END IF
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"omc_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'omc_file'), #FUN-A50102
             " WHERE omc01 = '",l_oma01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_omc_p FROM g_sql
    EXECUTE t600_del_omc_p
    IF SQLCA.sqlcode THEN
       CALL cl_err('del omc',SQLCA.sqlcode,0)
       LET g_success ='N'
       ROLLBACK WORK 
       RETURN
    END IF
    #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"oma_file",
    LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
             " WHERE oma01 = '",l_oma01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
    PREPARE t600_del_oma_p FROM g_sql
    EXECUTE t600_del_oma_p
    IF SQLCA.sqlcode THEN
       CALL cl_err('del oma',SQLCA.sqlcode,0)
       LET g_success ='N'
       ROLLBACK WORK 
       RETURN
    END IF 
  END FOREACH
END FUNCTION
 
FUNCTION t600_g_b_aqg()                                                             
   CALL t600_g_b1()                                                             
END FUNCTION  
 
FUNCTION t600_g_b1()                                                            
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01                                  
DEFINE body_sw          LIKE type_file.chr1    
DEFINE b                LIKE type_file.chr1     
DEFINE aqg03            LIKE aqg_file.aqg03     #CHI-880003 mod azr03->aqg03
DEFINE p06f,p06         LIKE type_file.num20_6
DEFINE l_aqg06f         LIKE aqg_file.aqg06f
DEFINE l_aqg06          LIKE aqg_file.aqg06 
DEFINE l_aba19          LIKE aba_file.aba19                                     
DEFINE g_t1             LIKE oay_file.oayslip
DEFINE g_wc4            STRING
                                                                                
   IF g_aqe.aqe01 IS NULL THEN RETURN END IF                                    
                                                                                
   OPEN WINDOW t600_g_b_w AT 4,24 WITH FORM "axr/42f/axrt600_1"                 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)                                
                                                                                
    CALL cl_ui_locale("axrt600_1")                                              
                                                                                
   INPUT BY NAME body_sw WITHOUT DEFAULTS                            
      BEFORE INPUT
        LET body_sw = '2'
 
      AFTER FIELD body_sw                                                       
         IF NOT cl_null(body_sw) THEN                                           
            IF body_sw NOT MATCHES "[12]" THEN                                  
               NEXT FIELD body_sw                                               
            END IF                                                              
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
      CLOSE WINDOW t600_g_b_w                                                   
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_dbs_new = NULL                                                         
   CASE WHEN body_sw = '2'                                                      
             CLOSE WINDOW t600_g_b_w                                            
             RETURN                                                             
        WHEN body_sw = '1'                                                      
                                                                                
        OPEN WINDOW t600_g_b_w2 AT 10,20 WITH FORM "axr/42f/axrt600_2"       
              ATTRIBUTE (STYLE = g_win_style CLIPPED)                        
                                                                             
        CALL cl_ui_locale("axrt600_2")                    
 
      INPUT BY NAME aqg03,b     #CHI-880003 mod azr03->aqg03
      BEFORE INPUT
        LET b = '1'
        LET aqg03 = g_plant     #CHI-880003 mod azr03->aqg03
        DISPLAY BY NAME aqg03   #CHI-880003 mod azr03->aqg03
 
      AFTER FIELD b
        IF NOT cl_null(b) THEN
           IF b NOT MATCHES "[12]" THEN
              NEXT FIELD b
           END IF
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
         CLOSE WINDOW t600_g_b_w2
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t600_g_b_w
         RETURN
      END IF
   END CASE
   CLOSE WINDOW t600_g_b_w
 
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t600_cl USING g_aqe.aqe01
   IF SQLCA.sqlcode THEN
      CALL cl_err("OPEN t600_cl:", SQLCA.sqlcode, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK 
      RETURN
   END IF
   LET l_ac = 1
     
   LET g_plant_new=g_plant CALL s_getdbs() LET l_dbs=g_dbs_new
 
   IF b = '1' THEN
      LET g_sql = "SELECT 0,'",g_plant_new,"','",b,"',nmh01,' ',nmh06,nmh26,nmh261, ",
                  "       '','',nmh03,nmh28,nmh02,nmh32 ",
                  #" FROM ",g_dbs_new CLIPPED,"nmh_file ",
                  " FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102
                  " WHERE nmh03 ='",g_aqe.aqe06,"'",
                  "   AND nmh11 ='",g_aqe.aqe03,"'",
                  "   AND nmh40 > 0 ",
                  "   AND nmh38 = 'Y' ",
                  " ORDER BY nmh01"
   ELSE
      LET g_sql = "SELECT 0,'",g_plant_new,"','",b,"',nmg00,npk01,npk04,npk07,npk072, ",
                  "       npk02,'',npk05,npk06,npk08,npk09 ",
                  #" FROM ",g_dbs_new CLIPPED,"nmg_file, ",g_dbs_new CLIPPED,"npk_file ",
                  " FROM ",cl_get_target_table(g_plant_new,'nmg_file'),",",  #FUN-A50102
                           cl_get_target_table(g_plant_new,'npk_file'),      #FUN-A50102
                  " WHERE npk05 ='",g_aqe.aqe06,"'",
                  "   AND nmg18 ='",g_aqe.aqe03,"'",
                  "   AND (nmg23-nmg24) > 0 AND npk00 = nmg00 ",
                  "   AND nmgconf = 'Y' ",
                  " ORDER BY npk04,nmg00"
   END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE t600_g_b_p1 FROM g_sql
   DECLARE t600_g_b_c1 CURSOR WITH HOLD FOR t600_g_b_p1
   FOREACH t600_g_b_c1 INTO g_aqg[l_ac].*
      IF SQLCA.sqlcode THEN CALL cl_err('for aqg',SQLCA.sqlcode,1) EXIT FOREACH END IF
      SELECT max(aqg02)+1 INTO g_aqg[l_ac].aqg02
        FROM aqg_file
       WHERE aqg01 = g_aqe.aqe01
      IF g_aqg[l_ac].aqg02 IS NULL THEN LET g_aqg[l_ac].aqg02 = 1 END IF
 
      LET g_aqg[l_ac].aqg06 = cl_digcut(g_aqg[l_ac].aqg06,g_azi04)
      MESSAGE '>:',g_aqg[l_ac].aqg02,' ',
                   g_aqg[l_ac].aqg14,' ',g_aqg[l_ac].aqg06f
 
      INSERT INTO aqg_file(aqg00,aqg01,aqg02,aqg03,aqg04,aqg08,aqg14,aqg15,
                           aqg05,aqg051,aqg11,aqg09,aqg10,aqg06f,aqg06,
                           aqglegal)  #FUN-980011 add
       VALUES('1',g_aqe.aqe01,
              g_aqg[l_ac].aqg02,g_aqg[l_ac].aqg03,g_aqg[l_ac].aqg04,
              g_aqg[l_ac].aqg08,g_aqg[l_ac].aqg14,g_aqg[l_ac].aqg15,g_aqg[l_ac].aqg05,g_aqg[l_ac].aqg051,
              g_aqg[l_ac].aqg11,g_aqg[l_ac].aqg09,g_aqg[l_ac].aqg10,
              g_aqg[l_ac].aqg06f,g_aqg[l_ac].aqg06,g_legal) #FUN-980011 add
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aqg_file",g_aqe.aqe01,g_aqg[l_ac].aqg02,SQLCA.sqlcode,"","",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_ac = l_ac + 1
   END FOREACH
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CALL t600_b_aqg_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t600_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #CHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_aqg TO s_aqg.* ATTRIBUTE(COUNT=g_rec_b2)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
      ON ACTION controls                       #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6A0092
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

