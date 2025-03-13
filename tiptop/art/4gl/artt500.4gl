# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artt500.4gl
# Descriptions...: 請購分配單
# Date & Author..: No:FUN-870007 08/08/15 By Zhangyajun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0023 09/11/04 By baofei寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No:FUN-960130 09/11/24 By bnlent get tra-db
# Modify.........: No:TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:FUN-9C0069 09/12/14 By bnlent mark or replace rucplant/ruclegal 
# Modify.........: No:FUN-A10037 10/01/07 By bnlent 1.add rue36 2.新增採購類型統采代采處理邏輯 3.add rud05 
#                                                   4.由判斷是否同一DB改為判斷是否同一法人
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:FUN-A10123 10/01/22 By bnlent 配送分貨單須判斷asms250里sma140配送依收獲過賬
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach ADD oriu/orig
# Modify.........: No:FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-A80022 10/08/04 By destiny t500_pml_upd函数的update语句缺少一个括号
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No:TQC-A80037 10/08/10 By houlia 欄位xxxplant、xxxlegal不能為NULL，insert into的時候要賦值
# Modify.........: No:FUN-A70130 10/08/16 By huangtao  修改單據性質,q_smy改为q_oay
# Modify.........: No:FUN-AB0101 10/11/26 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號
# Modify.........: No:MOD-AC0177 10/12/18 By huangtao 數字類型如果為空，計算有誤
# Modify.........: No:TQC-AC0227 10/12/20 By suncx 第二單身的需求總量沒有抓數據，導致第一單身需求總量也異常
# Modify.........: No:MOD-AC0202 10/12/21 By huangtao 撥出量為0時,撥出營運中心必須輸入才可通過，需調整
# Modify.........: No:TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:MOD-AC0223 10/12/23 By huangtao 同法人下 多角流程代號不用控卡必輸入
# Modify.........: No:TQC-AC0383 10/12/29 By shiwuying 重新过单
# Modify.........: No:TQC-AC0375 10/12/30 By huangtao  
# Modify.........: No:TQC-B10151 01/01/14 By huangrh 多角調撥編號：調撥量>0 時，並且跨法人調撥的時候，多角調撥編號必須輸入 
#                                                    多角採購編號：採購量>0時，可輸入或不輸入都可以
# Modify.........: No:MOD-B10164 11/01/21 By shiwuying 产生请购单时，同构否=Y,采购中心取当前营运中心采购策略设置的采购中心
# Modify.........: No.TQC-B20003 11/02/09 By chenmoyan 調撥單產生時隻需產生"未確認"的撥出方調撥單
# Modify.........: No.TQC-B20123 11/02/22 By lixia action "產品資料","需求分配資料"隱藏,直接點選畫面子單身
# Modify.........: No.MOD-B20140 11/02/24 By lixia 判斷是否為同法人應判斷 azw_file
# Modify.........: No.TQC-B30144 11/03/18 By lilingyu 審核後產生的各營運中心採購單需要給原始到庫日也賦值
# Modify.........: No.TQC-B30162 11/03/22 By lilingyu 審核後產生的請購單的交貨、到廠、到貨日期重新調整
# Modify.........: No.TQC-B30197 11/03/28 By lilingyu 採購多角貿易流程欄位檢查與開窗條件不一致
# Modify.........: No:FUN-B40039 11/04/26 By shiwuying 增加料号库存明细查询功能
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B80203 11/08/22 By lixia 重新過單
# Modify.........: No.FUN-910088 11/11/25 By chenjing   增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C80103 12/08/16 By yangxf 分配人員不存在報錯：aap-038,清空分配人員的同時會把需求分配單別也清空
#                                                   當單身有相同兩筆資料時，調撥採購量的時候，產生的調撥單(artt256)中的單身，撥入數量/撥出數量會為空白
# Modify.........: No.TQC-C80117 12/08/22 By yangxf 產品信息數據在查詢前未清空
# Modify.........: No.TQC-C80132 12/08/22 By yangxf rue34的開窗最後一站必需是撥出營運中心 rue36的開窗最後一站必需是當前營運中心
# Modify.........: No.TQC-C80134 12/08/22 By yangxf 通過採購量欄位以後帶出時檢查，CALL t500_rue34(，如果不符合清空
# Modify.........: No.TQC-C80136 12/08/22 By yangxf 調撥量為0，清空撥出營運中心和調撥多角流程編號，且noentry
# Modify.........: No.FUN-C90129 12/09/27 By baogc 產生調撥單時,來源項次rup17給值單身項次
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CC0057 12/12/18 By xumeimei INSERT INTO ruc_file 时ruc33=' '

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rud    RECORD LIKE rud_file.*,
        g_rud_t  RECORD LIKE rud_file.*,
        g_rud_o  RECORD LIKE rud_file.*,
        g_rue1   DYNAMIC ARRAY OF RECORD        #單身一
                rue05      LIKE rue_file.rue05,
                ima02      LIKE ima_file.ima02,
                ima021     LIKE ima_file.ima021,
                ima1004    LIKE ima_file.ima1004,
                ima1005    LIKE ima_file.ima1005,
                ima1007    LIKE ima_file.ima1007,
                ima1009    LIKE ima_file.ima1009,
                rue15      LIKE rue_file.rue15,
                rue15_desc LIKE gfe_file.gfe02,
                sum1       LIKE rue_file.rue20,
                sum2       LIKE rue_file.rue16
                        END RECORD,
        g_rue1_t RECORD
                rue05      LIKE rue_file.rue05,
                ima02      LIKE ima_file.ima02,
                ima021     LIKE ima_file.ima021,
                ima1004    LIKE ima_file.ima1004,
                ima1005    LIKE ima_file.ima1005,
                ima1007    LIKE ima_file.ima1007,
                ima1009    LIKE ima_file.ima1009,
                rue15      LIKE rue_file.rue15,
                rue15_desc LIKE gfe_file.gfe02,
                sum1       LIKE rue_file.rue20,
                sum2       LIKE rue_file.rue16
                        END RECORD,       
        g_rue   DYNAMIC ARRAY OF RECORD       #單身三
                rue011     LIKE rue_file.rue011,
                rue00      LIKE rue_file.rue00,
                rue02      LIKE rue_file.rue02,
                rue02_desc LIKE azp_file.azp02,
                rue03      LIKE rue_file.rue03,
                rue04      LIKE rue_file.rue04,
                rue06      LIKE rue_file.rue06,
                rue06_desc LIKE azp_file.azp02,
                rue07      LIKE rue_file.rue07,
                rue08      LIKE rue_file.rue08,
                rue09      LIKE rue_file.rue09,
                rue10      LIKE rue_file.rue10,
                rue11      LIKE rue_file.rue11,
                rue11_desc LIKE azp_file.azp02,
                rue12      LIKE rue_file.rue12,
                rue12_desc LIKE pmc_file.pmc03,
                rue13      LIKE rue_file.rue13,
                rue14      LIKE rue_file.rue14,
                rue16      LIKE rue_file.rue16,
                rue17      LIKE rue_file.rue17,
                rue18      LIKE rue_file.rue18,
                rue18_desc LIKE gfe_file.gfe02,
                rue19      LIKE rue_file.rue19,
                rue20      LIKE rue_file.rue20,
                rue21      LIKE rue_file.rue21,
                rue23      LIKE rue_file.rue23,
                rue24      LIKE rue_file.rue24,
                rue25      LIKE rue_file.rue25,
                rue26      LIKE rue_file.rue26,
                rue26_desc LIKE gfe_file.gfe02,
                rue27      LIKE rue_file.rue27,
                rue28      LIKE rue_file.rue28,
                rue29      LIKE rue_file.rue29,
                rue30      LIKE rue_file.rue30,
                rue31      LIKE rue_file.rue31,
                rue32      LIKE rue_file.rue32,
                rue33      LIKE rue_file.rue33,
                rue34      LIKE rue_file.rue34,
                rue36      LIKE rue_file.rue36   #No.FUN-A10037
                        END RECORD,
        g_rue_t  RECORD 
                rue011     LIKE rue_file.rue011,
                rue00      LIKE rue_file.rue00,
                rue02      LIKE rue_file.rue02,
                rue02_desc LIKE azp_file.azp02,
                rue03      LIKE rue_file.rue03,
                rue04      LIKE rue_file.rue04,
                rue06      LIKE rue_file.rue06,
                rue06_desc LIKE azp_file.azp02,
                rue07      LIKE rue_file.rue07,
                rue08      LIKE rue_file.rue08,
                rue09      LIKE rue_file.rue09,
                rue10      LIKE rue_file.rue10,
                rue11      LIKE rue_file.rue11,
                rue11_desc LIKE azp_file.azp02,
                rue12      LIKE rue_file.rue12,
                rue12_desc LIKE pmc_file.pmc03,
                rue13      LIKE rue_file.rue13,
                rue14      LIKE rue_file.rue14,
                rue16      LIKE rue_file.rue16,
                rue17      LIKE rue_file.rue17,
                rue18      LIKE rue_file.rue18,
                rue18_desc LIKE gfe_file.gfe02,
                rue19      LIKE rue_file.rue19,
                rue20      LIKE rue_file.rue20,
                rue21      LIKE rue_file.rue21,
                rue23      LIKE rue_file.rue23,
                rue24      LIKE rue_file.rue24,
                rue25      LIKE rue_file.rue25,
                rue26      LIKE rue_file.rue26,
                rue26_desc LIKE gfe_file.gfe02,
                rue27      LIKE rue_file.rue27,
                rue28      LIKE rue_file.rue28,
                rue29      LIKE rue_file.rue29,
                rue30      LIKE rue_file.rue30,
                rue31      LIKE rue_file.rue31,
                rue32      LIKE rue_file.rue32,
                rue33      LIKE rue_file.rue33,
                rue34      LIKE rue_file.rue34,
                rue36      LIKE rue_file.rue36   #No.FUN-A10037
                        END RECORD,
        g_rue_o   RECORD 
                rue011     LIKE rue_file.rue011,
                rue00      LIKE rue_file.rue00,
                rue02      LIKE rue_file.rue02,
                rue02_desc LIKE azp_file.azp02,
                rue03      LIKE rue_file.rue03,
                rue04      LIKE rue_file.rue04,
                rue06      LIKE rue_file.rue06,
                rue06_desc LIKE azp_file.azp02,
                rue07      LIKE rue_file.rue07,
                rue08      LIKE rue_file.rue08,
                rue09      LIKE rue_file.rue09,
                rue10      LIKE rue_file.rue10,
                rue11      LIKE rue_file.rue11,
                rue11_desc LIKE azp_file.azp02,
                rue12      LIKE rue_file.rue12,
                rue12_desc LIKE pmc_file.pmc03,
                rue13      LIKE rue_file.rue13,
                rue14      LIKE rue_file.rue14,
                rue16      LIKE rue_file.rue16,
                rue17      LIKE rue_file.rue17,
                rue18      LIKE rue_file.rue18,
                rue18_desc LIKE gfe_file.gfe02,
                rue19      LIKE rue_file.rue19,
                rue20      LIKE rue_file.rue20,
                rue21      LIKE rue_file.rue21,
                rue23      LIKE rue_file.rue23,
                rue24      LIKE rue_file.rue24,
                rue25      LIKE rue_file.rue25,
                rue26      LIKE rue_file.rue26,
                rue26_desc LIKE gfe_file.gfe02,
                rue27      LIKE rue_file.rue27,
                rue28      LIKE rue_file.rue28,
                rue29      LIKE rue_file.rue29,
                rue30      LIKE rue_file.rue30,
                rue31      LIKE rue_file.rue31,
                rue32      LIKE rue_file.rue32,
                rue33      LIKE rue_file.rue33,
                rue34      LIKE rue_file.rue34,
                rue36      LIKE rue_file.rue36   #No.FUN-A10037
                        END RECORD
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_wc1   STRING,
        g_wc2   STRING,
        g_wc3   STRING,
        g_rec_b1 LIKE type_file.num5,
        g_rec_b2 LIKE type_file.num5,
        g_rec_b3 LIKE type_file.num5,
        l_ac     LIKE type_file.num5,
        l_ac_t     LIKE type_file.num5,
        l_ac_tt    LIKE type_file.num5,
        l_ac1     LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE  l_table  STRING
DEFINE  g_t1       LIKE oay_file.oayslip         #自動編號
DEFINE  g_action_flag STRING
DEFINE  g_errmsg STRING
DEFINE  l_ruc18  LIKE ruc_file.ruc18
DEFINE  g_first  LIKE type_file.chr1 #No.FUN-A10123
 
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
    LET g_forupd_sql="SELECT * FROM rud_file WHERE rud01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t500_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t500_w AT p_row,p_col WITH FORM "art/42f/artt500"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    CALL t500_menu()
    
    CLOSE WINDOW t500_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t500_bp1(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rue1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED,KEEP CURRENT ROW)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         IF l_ac_tt <> 0 THEN
            CALL FGL_SET_ARR_CURR(l_ac_t)
         END IF
         LET l_ac_tt = 0
         LET l_ac1 = ARR_CURR()
         LET l_ac_t = l_ac1
         CALL t500_b3_fill(" 1=1")
         DISPLAY ARRAY g_rue TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
          BEFORE DISPLAY
           EXIT DISPLAY
         END DISPLAY
         CALL cl_show_fld_cont()
 
      ON ACTION goods_info
         LET g_action_choice="goods_info"
         EXIT DISPLAY
      ON ACTION sheet_info
         LET g_action_choice="sheet_info"
         EXIT DISPLAY
      ON ACTION recollect #重新生成匯總單
         LET g_action_choice="recollect"
         EXIT DISPLAY 
      ON ACTION confirm  #審核
         LET g_action_choice="confirm"
         EXIT DISPLAY 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL t500_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL t500_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t500_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#        LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
     ON ACTION controlg
        LET g_action_choice="controlg"
        EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
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
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
FUNCTION t500_bp3(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rue TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION goods_info
         LET g_action_choice="goods_info"
         EXIT DISPLAY
      ON ACTION sheet_info
         LET g_action_choice="sheet_info"
         EXIT DISPLAY
      ON ACTION recollect #重新生成匯總單
         LET g_action_choice="recollect"
         EXIT DISPLAY 
      ON ACTION confirm  #審核
         LET g_action_choice="confirm"
         EXIT DISPLAY 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL t500_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL t500_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t500_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#        LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
     ON ACTION controlg
        LET g_action_choice="controlg"
        EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
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
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION

#TQC-AC0227 add begin------------------
FUNCTION t500_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rue1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index,g_row_count)
           
         BEFORE ROW
            IF l_ac_tt <> 0 THEN         
               CALL FGL_SET_ARR_CURR(l_ac_t)
            END IF        
            LET l_ac_tt = 0     
            LET l_ac1 = ARR_CURR()       
            LET l_ac_t = l_ac1        
            CALL t500_b3_fill(" 1=1")      
            CALL cl_show_fld_cont() 

#TQC-B20123  mark--str--
#         ON ACTION goods_info
#            LET g_action_choice="goods_info"
#            EXIT DIALOG
#            
#         ON ACTION sheet_info
#            LET g_action_choice="sheet_info"
#            EXIT DIALOG
#TQC-B20123  mark--end--
            
         ON ACTION recollect #重新生成匯總單
            LET g_action_choice="recollect"
            EXIT DIALOG 
            
         ON ACTION confirm  #審核
            LET g_action_choice="confirm"
            EXIT DIALOG 
            
        #FUN-B40039 Begin---
         ON ACTION sel_item_img
            LET g_action_choice = "sel_item_img"
            EXIT DIALOG
        #FUN-B40039 End-----

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG  
            
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
            
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
            
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
            
         ON ACTION first
            CALL t500_fetch('F')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
            
         ON ACTION previous
            IF g_curs_index>1 THEN
               CALL t500_fetch('P')
               CALL cl_navigator_setting(g_curs_index,g_row_count)
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DIALOG 
            
         ON ACTION jump
            CALL t500_fetch('/')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
            
         ON ACTION next
            IF g_curs_index<g_row_count THEN
               CALL t500_fetch('N')
               CALL cl_navigator_setting(g_curs_index,g_row_count)
               CALL fgl_set_arr_curr(1)
               ACCEPT DIALOG 
            END IF
            
         ON ACTION LAST
            CALL t500_fetch('L')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
            
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG  
             
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
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
            
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
            
         ON ACTION controls                    
            CALL cl_set_head_visible("","AUTO") 
             
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG
            
         AFTER DISPLAY
            CONTINUE DIALOG
 
      END DISPLAY
      
      DISPLAY ARRAY g_rue TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index,g_row_count)
           
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
            
#TQC-B20123  mark--str--
#         ON ACTION goods_info
#            LET g_action_choice="goods_info"
#            EXIT DIALOG
#            
#         ON ACTION sheet_info
#            LET g_action_choice="sheet_info"
#            EXIT DIALOG
#TQC-B20123  mark--end--
            
         ON ACTION recollect #重新生成匯總單
            LET g_action_choice="recollect"
            EXIT DIALOG 
            
         ON ACTION confirm  #審核
            LET g_action_choice="confirm"
            EXIT DIALOG 

        #FUN-B40039 Begin---
         ON ACTION sel_item_img
            LET g_action_choice = "sel_item_img"
            EXIT DIALOG
        #FUN-B40039 End-----

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
            
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG  
            
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
            
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
            
         ON ACTION first
            CALL t500_fetch('F')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
            
         ON ACTION previous
            IF g_curs_index>1 THEN
               CALL t500_fetch('P')
               CALL cl_navigator_setting(g_curs_index,g_row_count)
               CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DIALOG 
            
         ON ACTION jump
            CALL t500_fetch('/')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
            
         ON ACTION next
            IF g_curs_index<g_row_count THEN
               CALL t500_fetch('N')
               CALL cl_navigator_setting(g_curs_index,g_row_count)
               CALL fgl_set_arr_curr(1)
               ACCEPT DIALOG 
            END IF
            
         ON ACTION LAST
            CALL t500_fetch('L')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG 
            
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG  
             
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
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
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
            
         ON ACTION controls                    
            CALL cl_set_head_visible("","AUTO")  
            
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG
            
         AFTER DISPLAY
            CONTINUE DIALOG
 
      END DISPLAY
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#TQC-AC0227 add -end- ------------------ 
FUNCTION t500_menu()
 DEFINE l_ima01    STRING              #FUN-B40039
 DEFINE l_i        LIKE type_file.num5 #FUN-B40039

   WHILE TRUE
      CALL t500_bp("G")    #TQC-AC0227 add
      #TQC-AC0227 mark -begin------------------------------- 
      #CASE
      #   WHEN (g_action_flag = "goods_detail" OR (g_action_flag IS NULL))
      #        CALL t500_b1_fill(g_wc1)
      #        CALL t500_b3_fill(g_wc3)
      #        DISPLAY ARRAY g_rue TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      #         BEFORE DISPLAY
      #          EXIT DISPLAY
      #        END DISPLAY
      #        CALL t500_bp1("G")
      #   WHEN (g_action_flag = "sheet_detail")
      #        CALL cl_set_act_visible("detail",TRUE)
      #        CALL t500_b1_fill(g_wc1)
      #        DISPLAY ARRAY g_rue1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      #        BEFORE DISPLAY
      #          EXIT DISPLAY
      #        END DISPLAY
      #        CALL t500_b3_fill(g_wc3)
      #        CALL t500_bp3("G")
      #END CASE
      #TQC-AC0227 mark --end--------------------------------
      
      CASE g_action_choice
#TQC-B20123--mark--str--
#         WHEN "goods_info"       #商品信息
#            IF cl_chk_act_auth() THEN
#               LET g_action_flag = "goods_detail"
#               LET l_ac_tt = l_ac_t
#            END IF
#         WHEN "sheet_info"       #需求分配信息
#            IF cl_chk_act_auth() THEN
#               LET g_action_flag = "sheet_detail"
#            END IF
#TQC-B20123--mark--end--
         WHEN "recollect"  #重新生成匯總單
            IF cl_chk_act_auth() THEN
                  CALL t500_recollect()
                  CALL t500_b1_fill(" 1=1")
                  CALL t500_b3_fill(" 1=1")
                  LET g_action_flag = "goods_detail"
            END IF
         WHEN "confirm"    #審核
            IF cl_chk_act_auth() THEN
                  CALL t500_y()
            END IF
        #FUN-B40039 Begin---
         WHEN "sel_item_img"
            IF cl_chk_act_auth() THEN
               IF l_ac1 > 0 THEN
                  FOR l_i=1 TO g_rec_b1 
                     IF l_i=1 THEN
                        LET l_ima01=g_rue1[l_i].rue05
                     ELSE
                        LET l_ima01=l_ima01 CLIPPED,"|",g_rue1[l_i].rue05,""
                     END IF
                  END FOR
                  LET g_msg = " artq700 '",l_ima01,"' '",g_rud.rudplant,"'"
                  CALL cl_cmdrun_wait(g_msg)
               END IF
            END IF
        #FUN-B40039 End-----
           
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t500_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t500_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t500_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t500_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t500_b()     #TQC-B20123--add--
#TQC-B20123--mark--str--
#                  IF g_action_flag = 'goods_detail' OR
#                     g_action_flag IS NULL THEN           
#                     CALL t500_b()
#                     LET l_ac_tt = l_ac_t
#                  END IF            
#                  IF g_action_flag = 'sheet_detail' THEN             
#                     CALL t500_b()
#                     LET g_action_flag = "goods_detail"
#                     LET l_ac_tt = l_ac_t
#                  END IF                
#            ELSE
#               LET g_action_choice = NULL
#TQC-B20123--mark--end--
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t500_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rue),'','')
             END IF
         WHEN "related_document"   
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rud.rud01) THEN
                 LET g_doc.column1 = "rud01"
                 LET g_doc.value1 = g_rud.rud01
                 CALL cl_doc()
              END IF
           END IF             
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t500_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CONSTRUCT BY NAME g_wc ON                               
        rud01,rud02,rud03,rud05,rudconf,rudcond,rudconu,  #No.FUN-A10037
       #rudmksg,rud900,rudplant,rud04, #MOD-B10164
        rudplant,rud04,                #MOD-B10164
	ruduser,rudgrup,rudmodu,ruddate,rudacti,rudcrat
       ,rudoriu,rudorig                             #TQC-A30041 ADD
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rud01)   #分配單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rud01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rud01
                 NEXT FIELD rud01
              WHEN INFIELD(rud03)   #分配人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rud03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rud03
                 NEXT FIELD rud03
              #No.FUN-A10037 ...begin
              WHEN INFIELD(rud05)   #采购中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rud05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rud05
                 NEXT FIELD rud05
              #No.FUN-A10037 ...end
              WHEN INFIELD(rudconu) #審核人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rudconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rudconu
                 NEXT FIELD rudconu
              WHEN INFIELD(rudplant) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rudplant
                 NEXT FIELD rudplant
              OTHERWISE
                 EXIT CASE
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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)          
		
    END CONSTRUCT
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND ruduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rudgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rudgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruduser', 'rudgrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc1 ON rue05,rue15
                   FROM s_b1[1].rue05,s_b1[1].rue15
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rue05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue05
                 NEXT FIELD rue05
              WHEN INFIELD(rue15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue15"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue15
                 NEXT FIELD rue15
              OTHERWISE
                 EXIT CASE
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
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    IF INT_FLAG THEN 
        RETURN
    END IF
 
    CONSTRUCT g_wc3 ON rue011,rue00,rue02,rue03,rue04,rue06,rue07,rue08,
                       rue09,rue10,rue11,rue12,rue13,rue14,rue16,
                       rue17,rue18,rue19,rue20,rue21,rue23,
                       rue24,rue25,rue26,rue27,rue28,rue29,rue30,
                       rue31,rue32,rue33,rue34,rue36  #No.FUN-A10037
                  FROM s_b3[1].rue011,s_b3[1].rue00,s_b3[1].rue02,s_b3[1].rue03,
                       s_b3[1].rue04,s_b3[1].rue06,s_b3[1].rue07,s_b3[1].rue08,
                       s_b3[1].rue09,s_b3[1].rue10,s_b3[1].rue11,s_b3[1].rue12,
                       s_b3[1].rue13,s_b3[1].rue14,s_b3[1].rue16,
                       s_b3[1].rue17,s_b3[1].rue18,s_b3[1].rue19,s_b3[1].rue20,
                       s_b3[1].rue21,s_b3[1].rue23,s_b3[1].rue24,
                       s_b3[1].rue25,s_b3[1].rue26,s_b3[1].rue27,s_b3[1].rue28,
                       s_b3[1].rue29,s_b3[1].rue30,s_b3[1].rue31,s_b3[1].rue32,
                       s_b3[1].rue33,s_b3[1].rue34,s_b3[1].rue36 #No.FUN-A10037
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rue02)  #需求機構
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue02
                 NEXT FIELD rue02
              WHEN INFIELD(rue06) #源頭機構
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue06
                 NEXT FIELD rue06
              WHEN INFIELD(rue11) #取貨機構
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue11
                 NEXT FIELD rue11
              WHEN INFIELD(rue12) #供應商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue12"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue12
                 NEXT FIELD rue12
              WHEN INFIELD(rue18) #請購單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue18"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue18
                 NEXT FIELD rue18
              WHEN INFIELD(rue24) #請購單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue24"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue24
                 NEXT FIELD rue24
              WHEN INFIELD(rue26) #採購單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue26"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue26
                 NEXT FIELD rue26
              WHEN INFIELD(rue32) #配送中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue32"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue32
                 NEXT FIELD rue32
              WHEN INFIELD(rue34) #多角貿易流程
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue34"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue34
                 NEXT FIELD rue34
              #No.FUN-A10037 ..begin
              WHEN INFIELD(rue36) #採購多角貿易流程
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rue36"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rue36
                 NEXT FIELD rue36
              #No.FUN-A10037 ..end
              OTHERWISE
                 EXIT CASE
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
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc2 = g_wc2 CLIPPED
    LET g_wc3 = g_wc3 CLIPPED
    
    CASE 
      WHEN g_wc1<>" 1=1" OR g_wc3<>" 1=1"
        LET g_sql = "SELECT UNIQUE rud01",
                    "  FROM rud_file,rue_file",
                    " WHERE rud01=rue01 AND rudplant=rueplant",
#                   "   AND rudplant IN ",g_auth,
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc1 CLIPPED," AND ",g_wc3 CLIPPED,
                    " ORDER BY rud01,rudplant"                 
     OTHERWISE
        LET g_sql = "SELECT UNIQUE rud01",
                    "  FROM rud_file ",
                    " WHERE rudplant IN ",g_auth,
                    "   AND ",g_wc CLIPPED,
                    " ORDER BY rud01"
    END CASE   
    
    PREPARE t500_prepare FROM g_sql
    DECLARE t500_cs SCROLL CURSOR WITH HOLD FOR t500_prepare
    
    CASE 
      WHEN g_wc1<>" 1=1" OR g_wc3<>" 1=1"
        LET g_sql = "SELECT COUNT(DISTINCT rud_file.rud01)",
                    "  FROM rud_file,rue_file",
                    " WHERE rud01=rue01 AND rudplant=rueplant",
                    "   AND rudplant IN ",g_auth,
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc1 CLIPPED," AND ",g_wc3 CLIPPED
               
      OTHERWISE
        LET g_sql="SELECT COUNT(*) FROM rud_file ",
                  " WHERE rudplant IN ",g_auth," AND ",g_wc CLIPPED
    END CASE    
    PREPARE t500_precount FROM g_sql
    DECLARE t500_count CURSOR FOR t500_precount
END FUNCTION
 
FUNCTION t500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    INITIALIZE g_rud.* TO NULL
    CALL g_rue1.clear()     #TQC-C80117 add 
    CALL g_rue.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL t500_cs()              
            
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rud.* TO NULL
        CALL g_rue.clear()
        RETURN
    END IF
    
    OPEN t500_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rue.clear()
    ELSE
        OPEN t500_count
        FETCH t500_count INTO g_row_count
        #IF g_row_count>0 THEN   #No.FUN-A10037
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL t500_fetch('F') 
        #ELSE                    #No.FUN-A10037
        #   CALL cl_err('',100,0)#No.FUN-A10037
        #END IF                  #No.FUN-A10037
    END IF
END FUNCTION
 
FUNCTION t500_fetch(p_flrud)
DEFINE p_flrud         LIKE type_file.chr1           
    CASE p_flrud
        WHEN 'N' FETCH NEXT     t500_cs INTO g_rud.rud01
        WHEN 'P' FETCH PREVIOUS t500_cs INTO g_rud.rud01
        WHEN 'F' FETCH FIRST    t500_cs INTO g_rud.rud01
        WHEN 'L' FETCH LAST     t500_cs INTO g_rud.rud01
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
            FETCH ABSOLUTE g_jump t500_cs INTO g_rud.rud01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rud.rud01,SQLCA.sqlcode,0)
        INITIALIZE g_rud.* TO NULL  
        RETURN
    ELSE
      CASE p_flrud
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rud.* FROM rud_file    
       WHERE rud01=g_rud.rud01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rud_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rud.ruduser           
        LET g_data_group=g_rud.rudgrup
        LET g_data_plant=g_rud.rudplant  #TQC-A10128 ADD
        CALL t500_show()                   
    END IF
END FUNCTION
 
FUNCTION t500_rud03(p_cmd)         
DEFINE    p_cmd      LIKE type_file.chr1, 
          l_genacti  LIKE rud_file.rudacti,            
          l_gen02    LIKE gen_file.gen02
          
   LET g_errno = ' '
   
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file 
    WHERE gen01 = g_rud.rud03
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='aap-038' 
                                 LET l_gen02=NULL 
        WHEN l_genacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.rud03_desc
  END IF
 
END FUNCTION
#No.FUN-A10037 ...begin
FUNCTION t500_rud05(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1
DEFINE  l_rud05_desc    LIKE geu_file.geu02,
        l_geuacti       LIKE geu_file.geuacti
        
    LET g_errno=''
    SELECT geu02,geuacti INTO l_rud05_desc,l_geuacti 
      FROM geu_file
     WHERE geu01 = g_rud.rud05 
       AND geu00 = '4'
   CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-591' 
                                 LET l_rud05_desc = NULL 
        WHEN l_geuacti='N'       LET g_errno='9028'
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_rud05_desc TO FORMONLY.rud05_desc
   END IF
END FUNCTION
#No.FUN-A10037 ...end
 
FUNCTION t500_show()
DEFINE l_rudconu_desc LIKE gen_file.gen02
DEFINE l_rudplant_desc  LIKE azp_file.azp02
 
    LET g_rud_t.* = g_rud.*
    LET g_rud_o.* = g_rud.*
    
    DISPLAY BY NAME g_rud.rud01,g_rud.rud02,g_rud.rud03,g_rud.rud05, #No.FUN-A10037
                    g_rud.rudoriu,g_rud.rudorig,
                    g_rud.rudconf,g_rud.rudcond,g_rud.rudconu,
                   #g_rud.rudmksg,g_rud.rud900,g_rud.rudplant, #MOD-B10164
                    g_rud.rudplant,                            #MOD-B10164
                    g_rud.rud04,g_rud.ruduser,g_rud.rudgrup,
                    g_rud.rudmodu,g_rud.ruddate,g_rud.rudacti,
                    g_rud.rudcrat
    CALL t500_rud03('d')
    CALL t500_rud05('d') #No.FUN-A10037
    CASE g_rud.rudconf
     WHEN 'N'       
       CALL cl_set_field_pic("","","","","",g_rud.rudacti)
     WHEN 'Y'
       CALL cl_set_field_pic('Y',"","","","","")
    END CASE
    IF NOT cl_null(g_rud.rudconu) THEN
       SELECT gen02 INTO l_rudconu_desc FROM gen_file
           WHERE gen01=g_rud.rudconu AND genacti='Y'
       DISPLAY l_rudconu_desc TO rudconu_desc
    ELSE
       CLEAR rudconu_desc
    END IF
    SELECT azp02 INTO l_rudplant_desc FROM azp_file
     WHERE azp01=g_rud.rudplant
    DISPLAY l_rudplant_desc TO rudplant_desc
    
    CASE  
     WHEN g_action_flag="goods_detail" OR g_action_flag IS NULL
          CALL t500_b1_fill(g_wc1) 
          CALL t500_b3_fill(g_wc3)          
     WHEN g_action_flag="sheet_detail"
          CALL t500_b3_fill(g_wc3) 
          CALL t500_b1_fill(g_wc1)
          DISPLAY ARRAY g_rue1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
               BEFORE DISPLAY
                EXIT DISPLAY
          END DISPLAY
    END CASE
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t500_b1_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT rue05,'','','','','','',rue15,'',",
                "SUM(rue20),SUM(COALESCE(rue21,0)+ COALESCE(rue23,0))",                
                " FROM rue_file",
                " WHERE rue01='",g_rud.rud01 CLIPPED,"'"
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql = g_sql," GROUP BY rue05,rue15"
    PREPARE t500_pb1 FROM g_sql
    DECLARE rue1_cs CURSOR FOR t500_pb1
 
    CALL g_rue1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rue1_cs INTO g_rue1[g_cnt].*  
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
      END IF
      SELECT ima02,ima021,ima1004,ima1005,ima1007,ima1009,gfe02
          INTO g_rue1[g_cnt].ima02,g_rue1[g_cnt].ima021,g_rue1[g_cnt].ima1004,
               g_rue1[g_cnt].ima1005,g_rue1[g_cnt].ima1007,g_rue1[g_cnt].ima1009,
               g_rue1[g_cnt].rue15_desc
            FROM ima_file LEFT JOIN gfe_file ON ima25=gfe01 AND gfeacti='Y'
            WHERE ima01 = g_rue1[g_cnt].rue05 AND imaacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rue1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t500_b3_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT rue011,rue00,rue02,'',rue03,rue04,rue06,'',",
                "rue07,rue08,rue09,rue10,rue11,'',rue12,'',rue13,",
                "rue14,rue16,rue17,rue18,'',rue19,rue20,rue21,",
                "rue23,rue24,rue25,rue26,'',rue27,rue28,rue29,rue30,",
                "rue31,rue32,rue33,rue34,rue36",   #No.FUN-A10037             
                " FROM rue_file",
                " WHERE rue01='",g_rud.rud01 CLIPPED,"'"
      
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    IF l_ac1=0 THEN
       LET l_ac1=1
    END IF
    LET g_sql=g_sql," AND rue05='",g_rue1[l_ac1].rue05 CLIPPED,
                    "' AND rue15='",g_rue1[l_ac1].rue15 CLIPPED,"'"
    PREPARE t500_pb FROM g_sql
    DECLARE rue_cs CURSOR FOR t500_pb
 
    CALL g_rue.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rue_cs INTO g_rue[g_cnt].*  
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
      END IF
      SELECT (SELECT azp02 FROM azp_file WHERE azp01=g_rue[g_cnt].rue02 ),
             (SELECT azp02 FROM azp_file WHERE azp01=g_rue[g_cnt].rue06 ),
             (SELECT azp02 FROM azp_file WHERE azp01=g_rue[g_cnt].rue11 )
         INTO g_rue[g_cnt].rue02_desc,g_rue[g_cnt].rue06_desc,g_rue[g_cnt].rue11_desc
         FROM azp_file   
      SELECT pmc03 INTO g_rue[g_cnt].rue12_desc FROM pmc_file
        WHERE pmc01=g_rue[g_cnt].rue12 AND pmcacti='Y'
      SELECT gfe02 INTO g_rue[g_cnt].rue18_desc
        FROM gfe_file
       WHERE gfe01=g_rue[g_cnt].rue18 AND gfeacti='Y'
      SELECT gfe02 INTO g_rue[g_cnt].rue26_desc
        FROM gfe_file
       WHERE gfe01=g_rue[g_cnt].rue26 AND gfeacti='Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rue.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t500_a()
DEFINE l_rudplant_desc LIKE azp_file.azp02
DEFINE li_result   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rue1.clear()
   CALL g_rue.clear()
   LET g_wc = NULL 
   LET g_wc1= NULL
   LET g_wc2= NULL 
   LET g_wc3= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rud.* LIKE rud_file.*                  
 
   LET g_rud_t.* = g_rud.*
   LET g_rud_o.* = g_rud.*
   
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rud.ruduser = g_user
      LET g_rud.rudoriu = g_user #FUN-980030
      LET g_rud.rudorig = g_grup #FUN-980030
      LET g_rud.rudgrup = g_grup
      LET g_rud.rudcrat = g_today
      LET g_rud.rudacti = 'Y'                    
      LET g_rud.rud02 = g_today        #分配日期
      LET g_rud.rud03 = g_user         #分配人員
      LET g_rud.rudconf = 'N'          #審核碼
      LET g_rud.rudmksg = 'N'          #簽核 #MOD-B10164
      LET g_rud.rud900 = '0'           #狀態
      LET g_rud.rudplant = g_plant  #當前機構
      LET g_data_plant = g_plant    #TQC-A10128 ADD
      SELECT azp02 INTO l_rudplant_desc FROM azp_file
       WHERE azp01 = g_plant
      SELECT azw02 INTO g_rud.rudlegal FROM azw_file WHERE azw01=g_plant
     #DISPLAY BY NAME g_rud.rudconf,g_rud.rud900,g_rud.rudplant, #MOD-B10164
      DISPLAY BY NAME g_rud.rudconf,g_rud.rudplant,              #MOD-B10164
                      g_rud.ruduser,g_rud.rudgrup,g_rud.rudcrat,
                      g_rud.rudacti,g_rud.rudoriu,g_rud.rudorig  #TQC-A30041 ADD

      DISPLAY l_rudplant_desc TO rudplant_desc
      
      CALL t500_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rud.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rud.rud01) THEN       
         CONTINUE WHILE
      END IF
      
      BEGIN WORK
#     CALL s_auto_assign_no("ART",g_rud.rud01,g_today,"2","rud_file","rud01","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("ART",g_rud.rud01,g_today,"I1","rud_file","rud01","","","") #FUN-A70130 mod
          RETURNING li_result,g_rud.rud01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_rud.rud01
      INSERT INTO rud_file VALUES (g_rud.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rud_file",g_rud.rud01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rud.* FROM rud_file
       WHERE rud01 = g_rud.rud01
      LET g_rud_t.* = g_rud.*
      CALL g_rue.clear()
      CALL g_rue1.clear()
      
      CALL t500_collect()
      CALL t500_b1_fill(g_wc1)
      CALL t500_b3_fill(g_wc3)            
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t500_i(p_cmd)
DEFINE     p_cmd        LIKE type_file.chr1,                
           l_n          LIKE type_file.num5,           
           li_result    LIKE type_file.num5
           
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_rud.rudoriu,g_rud.rudorig,
     #g_rud.rud01,g_rud.rud02,g_rud.rud03,g_rud.rud05,g_rud.rudmksg,g_rud.rud04  #No.FUN-A10037#MOD-B10164
      g_rud.rud01,g_rud.rud02,g_rud.rud03,g_rud.rud05,g_rud.rud04 #No.FUN-A10037 #MOD-B10164
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL t500_set_entry(p_cmd)
          CALL t500_set_no_entry(p_cmd)
          CALL cl_set_docno_format("rud01")
          LET g_before_input_done = TRUE
	
      AFTER FIELD rud01  #需求分配單號
         IF NOT cl_null(g_rud.rud01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rud.rud01 <> g_rud_t.rud01) THEN     
#               CALL s_check_no("ART",g_rud.rud01,g_rud_t.rud01,"2","rwr_file","rud01,rudplant","") #FUN-A70130 mark
                CALL s_check_no("ART",g_rud.rud01,g_rud_t.rud01,"I1","rwr_file","rud01,rudplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rud.rud01
                IF (NOT li_result) THEN                                                            
                    LET g_rud.rud01=g_rud_t.rud01                                                                 
                    NEXT FIELD rud01                                                                                      
                END IF  
            END IF
         END IF
         
      AFTER FIELD rud03    #分配人員
         IF NOT cl_null(g_rud.rud03) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                    
               g_rud.rud03 <> g_rud_o.rud03 OR cl_null(g_rud_o.rud03)) THEN
               CALL t500_rud03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rud02:',g_errno,1)
                 #LET g_rud.rud01 = g_rud_t.rud03     #TQC-C80103 mark
                  LET g_rud.rud03 = g_rud_t.rud03     #TQC-C80103 add
                  DISPLAY BY NAME g_rud.rud03
                  NEXT FIELD rud03
               ELSE 
                  LET g_rud_o.rud03 = g_rud.rud03
               END IF
            END IF
         ELSE
            LET g_rud_o.rud03=''
            CLEAR rud03_desc
         END IF
      #No.FUN-A10037 ..begin
      AFTER FIELD rud05    #分配人員
         IF NOT cl_null(g_rud.rud05) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                    
               g_rud.rud05 <> g_rud_o.rud05 OR cl_null(g_rud_o.rud05)) THEN
               CALL t500_rud05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rud05:',g_errno,1)
                 #LET g_rud.rud01 = g_rud_t.rud05 #FUN-C90129 Mark
                  LET g_rud.rud05 = g_rud_t.rud05 #FUN-C90129 Add
                  DISPLAY BY NAME g_rud.rud05
                  NEXT FIELD rud05
               ELSE 
                  LET g_rud_o.rud05 = g_rud.rud05
               END IF
            END IF
         ELSE
            LET g_rud_o.rud05=''
            CLEAR rud05_desc
         END IF
      #No.FUN-A10037 ..end
          
          
      AFTER INPUT
         LET g_rud.ruduser = s_get_data_owner("rud_file") #FUN-C10039
         LET g_rud.rudgrup = s_get_data_group("rud_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rud.rud01) THEN
               NEXT FIELD rud01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rud01) THEN
            LET g_rud.* = g_rud_t.*
            CALL t500_show()
            NEXT FIELD rud01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rud01)   #需求分配單號
              LET g_t1=s_get_doc_no(g_rud.rud01)
#             CALL q_smy(FALSE,FALSE,g_t1,'art','2') RETURNING g_t1  #FUN-A70130--mark--
              CALL q_oay(FALSE,FALSE,g_t1,'I1','art') RETURNING g_t1  #FUN-A70130--mod--
              LET g_rud.rud01=g_t1
              DISPLAY BY NAME g_rud.rud01
           WHEN INFIELD(rud03)   #分配人員
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rud.rud03
              CALL cl_create_qry() RETURNING g_rud.rud03
              DISPLAY BY NAME g_rud.rud03
              CALL t500_rud03('d')
              NEXT FIELD rud03
           #No.FUN-A10037 ..begin
           WHEN INFIELD(rud05)   #分配人員
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_geu"
              LET g_qryparam.default1 = g_rud.rud05
              LET g_qryparam.arg1 = '4'
              CALL cl_create_qry() RETURNING g_rud.rud05
              DISPLAY BY NAME g_rud.rud05
              CALL t500_rud05('d')
              NEXT FIELD rud05
           #No.FUN-A10037 ..end
 
           OTHERWISE
              EXIT CASE
        END CASE
 
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
 
END FUNCTION
 
FUNCTION t500_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rud01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t500_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rud01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t500_b_init() #單身帶出值
 
      SELECT (SELECT azp02 FROM azp_file WHERE azp01=g_rue[l_ac].rue02 ),
             (SELECT azp02 FROM azp_file WHERE azp01=g_rue[l_ac].rue06 ),
             (SELECT azp02 FROM azp_file WHERE azp01=g_rue[l_ac].rue11 )
         INTO g_rue[l_ac].rue02_desc,g_rue[l_ac].rue06_desc,g_rue[l_ac].rue11_desc
         FROM azp_file
      SELECT pmc03 INTO g_rue[l_ac].rue12_desc FROM pmc_file
        WHERE pmc01=g_rue[l_ac].rue12 AND pmcacti='Y'
      SELECT gfe02 INTO g_rue[l_ac].rue18_desc
        FROM gfe_file
       WHERE gfe01=g_rue[l_ac].rue18 AND gfeacti='Y'
      LET g_rue[l_ac].rue26 = g_rue[l_ac].rue18
     #FUN-910088--add--start--
      LET g_rue[l_ac].rue21 = s_digqty(g_rue[l_ac].rue21,g_rue[l_ac].rue26)
      LET g_rue[l_ac].rue23 = s_digqty(g_rue[l_ac].rue23,g_rue[l_ac].rue26)
     #FUN-910088--add--end--
      SELECT gfe02 INTO g_rue[l_ac].rue26_desc
        FROM gfe_file
       WHERE gfe01=g_rue[l_ac].rue26 AND gfeacti='Y'
      CALL t500_rue26('d')
      IF NOT cl_null(g_rue[l_ac].rue21) THEN
         CALL t500_getprice()
      END IF
      SELECT COALESCE(ruc18,0) INTO l_ruc18
        FROM ruc_file
       WHERE ruc00 = g_rue[l_ac].rue00
         AND ruc01 = g_rue[l_ac].rue02
         AND ruc02 = g_rue[l_ac].rue03
         AND ruc03 = g_rue[l_ac].rue04
         AND ruc04 = g_rue1[l_ac1].rue05
         #AND rucplant = g_rue[l_ac].rue02  #No.FUN-9C0069
END FUNCTION
 
FUNCTION t500_rue26(p_cmd)  #單位帶出名稱,check換算率
DEFINE    p_cmd      LIKE type_file.chr1   
DEFINE    l_gfeacti  LIKE gfe_file.gfeacti, 
          l_gfe02    LIKE gfe_file.gfe02, 
          l_gfe03    LIKE rta_file.rta03   
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac         
          
   LET g_errno = ' '
   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti FROM gfe_file
     WHERE gfe01=g_rue[l_ac].rue26
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-031' 
                                 LET l_gfe02=NULL 
        WHEN l_gfeacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) THEN
     CALL s_umfchk(g_rue1[l_ac].rue05,g_rue[l_ac].rue18,g_rue[l_ac].rue26) 
       RETURNING l_flag,l_fac
     IF l_flag = 1 THEN
        LET g_errno = 'art-032'
     END IF
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rue[l_ac].rue26_desc = l_gfe02
     LET g_rue[l_ac].rue27 = l_fac
     DISPLAY BY NAME g_rue[l_ac].rue26_desc,g_rue[l_ac].rue27
  END IF
  
END FUNCTION
 
FUNCTION t500_ins_rue34(l_rue34,l_rue24,l_rue02,l_rue05)
DEFINE l_poz01_max LIKE poz_file.poz01
DEFINE l_poz20 LIKE poz_file.poz20      #是否模版流程
DEFINE l_poy02_min LIKE poy_file.poy02  #多角貿易第一站
DEFINE l_poy02_max LIKE poy_file.poy02  #多角貿易最後站
DEFINE l_n,l_n1,l_n2 LIKE type_file.num5
DEFINE l_azp03 LIKE azp_file.azp03  #機構對應營運中心
DEFINE l_rue34 LIKE rue_file.rue34  #多角貿易流程
DEFINE l_rue24 LIKE rue_file.rue24  #撥出機構
DEFINE l_rue02 LIKE rue_file.rue02  #需求機構
DEFINE l_rue05 LIKE rue_file.rue05  #商品編號
DEFINE l_poy03 LIKE poy_file.poy03  #客戶編號
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_poz01 LIKE poz_file.poz01
 
    LET g_errno = ''
    
    IF NOT cl_null(l_rue34) THEN
       SELECT poz20 INTO l_poz20
         FROM poz_file
        WHERE poz01 = l_rue34
          AND poz00 = '2'
          AND pozacti = 'Y'
     
       IF l_poz20 = 'Y' THEN
          SELECT COUNT(*) INTO l_n
            FROM azp_file
           WHERE (azp01=l_rue24 OR azp01=l_rue02)
             AND azp03 IN (SELECT DISTINCT azp03 FROM azp_file,poy_file
                            WHERE azp01=poy04 AND poy01=l_rue34)
          IF l_n>0 THEN
             LET l_rue34 = ''
             CALL s_errmsg('rue34',l_rue34,'','art-299',1)
             RETURN l_rue34
          ELSE
          SELECT COUNT(*) INTO l_cnt FROM poy_file
             WHERE poy01 = l_rue34
            SELECT MIN(poy02) INTO l_poy02_min FROM poy_file
             WHERE poy01 = l_rue34
            SELECT MAX(poy02) INTO l_poy02_max FROM poy_file
             WHERE poy01 = l_rue34
 
            CASE l_cnt
             WHEN 2
            SELECT poz01 INTO l_poz01 
              FROM poy_file a,poy_file b,poz_file             
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = l_rue02
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=a.poy01) 
               AND b.poy04 = l_rue24
             WHEN 3
            SELECT poz01 INTO l_poz01
              FROM poy_file a,poy_file b,poy_file c,poz_file             
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = l_rue02
               AND a.poy01 = b.poy01
               AND b.poy01 = poz01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = l_rue24
               AND c.poy01 = b.poy01
               AND c.poy02 = (a.poy02+1)
               AND c.poy04 = (SELECT poy04 FROM poy_file 
                               WHERE poy01 = l_rue34 
                                 AND poy02 = c.poy02)
            WHEN 4
            SELECT poz01 INTO l_poz01 
              FROM poy_file a,poy_file b,poy_file c,poy_file d,poz_file             
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = l_rue02
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = l_rue24
               AND c.poy01 = b.poy01
               AND c.poy02 = a.poy02+1
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = l_rue34 
                                 AND poy02 = c.poy02)
               AND c.poy01 = d.poy01
               AND d.poy02 = (c.poy02+1) 
               AND d.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = l_rue34 AND poy02 = d.poy02)
            WHEN 5
            SELECT poz01 INTO l_poz01 
              FROM poy_file a,poy_file b,poy_file c,poy_file d,poy_file e,poz_file             
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = l_rue02
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = l_rue24
               AND c.poy01 = b.poy01
               AND c.poy02 = (a.poy02+1)
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE h.poy01 = l_rue34 AND poy02 = c.poy02)
               AND c.poy01 = d.poy01
               AND d.poy02 = (c.poy02+1) 
               AND d.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = l_rue34 AND poy02 = d.poy02)
               AND e.poy01 = d.poy01
               AND e.poy02 = (d.poy02+1) 
               AND e.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = l_rue34 AND poy02 = e.poy02)
            WHEN 6
            SELECT poz01 INTO l_poz01 
              FROM poy_file a,poy_file b,poy_file c,poy_file d,poy_file e,poy_file f,poz_file             
             WHERE poz00 = '2' AND poz20 = 'N' AND pozacti = 'Y'
               AND poz01 = a.poy01
               AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
               AND a.poy04 = l_rue02
               AND a.poy01 = b.poy01
               AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=b.poy01)
               AND b.poy04 = l_rue24
               AND c.poy01 = b.poy01
               AND c.poy02 = (a.poy02+1)
               AND c.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = l_rue34 AND poy02 = c.poy02)
               AND c.poy01 = d.poy01
               AND d.poy02 = (c.poy02+1) 
               AND d.poy04 = (SELECT poy04 FROM poy_file j
                               WHERE poy01 = l_rue34 AND poy02 = d.poy02)
               AND e.poy01 = d.poy01
               AND e.poy02 = (d.poy02+1) 
               AND e.poy04 = (SELECT poy04 FROM poy_file k
                               WHERE poy01 = l_rue34 AND poy02 = e.poy02)
               AND f.poy01 = e.poy01
               AND f.poy02 = (e.poy02+1) 
               AND f.poy04 = (SELECT poy04 FROM poy_file
                               WHERE poy01 = l_rue34 AND poy02 = f.poy02)
            END CASE            
            IF NOT cl_null(l_poz01) THEN
               RETURN l_poz01
            END IF
          INSERT INTO poz_temp
          SELECT * FROM poz_file
           WHERE poz01 = l_rue34
          SELECT MAX(poz01) + 1
            INTO l_n
            FROM poz_file
          LET l_poz01_max = l_n USING '&&&&&&&&'
           UPDATE poz_temp SET poz01 = l_poz01_max,
                               poz20 = 'N',
                               poz21 = l_rue34
          INSERT INTO poy_temp
          SELECT * FROM poy_file
           WHERE poy01 = l_rue34
          SELECT rty05 INTO l_poy03 FROM rty_file
           WHERE rty01 = l_rue02 AND rty02 = l_rue05
          IF SQLCA.sqlcode = 100 THEN
             CALL s_errmsg('rty05',l_rue02,'','art-312',1)
          END IF      
          UPDATE poy_temp SET poy01 = l_poz01_max,
                              poy04 = l_rue02,
                              poy03 = l_occ01,
                              poy05 = '',
                              poy20 = ''
           WHERE poy04 = 'xxx'
          SELECT rty05 INTO l_poy03 FROM rty_file
           WHERE rty01 = l_rue24 AND rty02 = l_rue05
          IF SQLCA.sqlcode = 100 THEN
             CALL s_errmsg('rty05',l_rue24,'','art-312',1)
          END IF
          UPDATE poy_temp SET poy01 = l_poz01_max,
                              poy04 = l_rue24,
                              poy03 = l_occ01 ,
                              poy05 = '',
                              poy20 = ''
           WHERE poy04 = 'yyy'
          INSERT INTO poz_file SELECT * FROM poz_temp
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('poz01',l_rue34,'INSERT INTO poz_file:',SQLCA.sqlcode,1)
          ELSE
             INSERT INTO poy_file SELECT * FROM poy_temp
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('poy01',l_rue34,'INSERT INTO poy_file:',SQLCA.sqlcode,1)
             ELSE
                INSERT INTO pox_temp
                SELECT * FROM pox_file WHERE pox01 = l_rue34
                UPDATE pox_temp SET pox01 = l_poz01_max
                INSERT INTO pox_file SELECT * FROM pox_temp
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('poy01',l_rue34,'INSERT INTO poy_file:',SQLCA.sqlcode,1)
                END IF
             END IF                
          END IF
       END IF
     ELSE
        SELECT COUNT(*) INTO l_n
         FROM poy_file a,poy_file b            
        WHERE a.poy01 = l_rue34
          AND a.poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01=a.poy01)
          AND a.poy04 = l_rue02
          AND a.poy01 = b.poy01
          AND b.poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01=a.poy01) 
          AND b.poy04 = l_rue24
        CALL s_errmsg('rue34',l_rue34,'','art-282',1)
        LET l_rue34 = ''
     END IF
   END IF
   SELECT poz01 INTO l_rue34 FROM poz_temp
   RETURN l_rue34
END FUNCTION
 
FUNCTION t500_rue34(l_rue34,l_rue24,l_rue02)
DEFINE l_n,l_n1,l_n2 LIKE type_file.num5
DEFINE l_rue34 LIKE rue_file.rue34  #多角貿易流程
DEFINE l_rue24 LIKE rue_file.rue24  #撥出機構
DEFINE l_rue02 LIKE rue_file.rue02  #需求機構
 
    LET g_errno = ''
    
    IF NOT cl_null(l_rue34) THEN  
       SELECT COUNT(*) INTO l_n
         FROM poz_file
        WHERE poz01 = l_rue34
          AND poz00 = '2'
          AND pozacti = 'Y'
          AND poz20 = 'N'        #TQC-B30197
       IF l_n=0 THEN
          LET g_errno = 'art-285'
       END IF
       IF cl_null(g_errno) THEN
          SELECT COUNT(DISTINCT poy04) INTO l_n1
            FROM poy_file,poz_file
           WHERE poy04 = l_rue02
             AND poz01 = poy01
             AND poz01 = l_rue34
             AND poz00 = '2'
             AND pozacti = 'Y'
             AND poz20 = 'N'        #TQC-B30197
             AND poy02 = (SELECT MIN(poy02) FROM poy_file,poz_file 
                                        WHERE poz01 = poy01
                                          AND poz01 = l_rue34
                                          AND poz20 = 'N'        #TQC-B30197
                                          AND poz00 = '2'
                                          AND pozacti = 'Y')
         SELECT COUNT(DISTINCT poy04) INTO l_n2
           FROM poy_file,poz_file
          WHERE poy04 = l_rue24
            AND poz01 = poy01
            AND poz01 = l_rue34
            AND poz00 = '2'
            AND pozacti = 'Y'
            AND poz20 = 'N'        #TQC-B30197
            AND poy02 = (SELECT MAX(poy02) FROM poy_file,poz_file 
                                          WHERE poz01 = poy01
                                            AND poz01 = l_rue34
                                            AND poz20 = 'N'        #TQC-B30197
                                            AND poz00 = '2'
                                            AND pozacti = 'Y')
         IF l_n1=0 OR l_n2=0 THEN
            LET g_errno = 'art-285'
         END IF
       END IF
   END IF
END FUNCTION
 
FUNCTION t500_b_check()
DEFINE l_azw07 LIKE azw_file.azw07
#MOD-AC0223 -----------------STA
DEFINE l_n     LIKE type_file.num5
DEFINE l_rty10 LIKE rty_file.rty10
    IF NOT cl_null(g_rue[l_ac].rue21) THEN
        CALL cl_set_comp_entry('rue36',TRUE)
        LET l_n = 0
        SELECT COUNT(*) INTO l_n
          FROM azw_file a,azw_file b
         WHERE a.azw02 = b.azw02
           AND a.azw01 = g_rue[l_ac].rue02
           AND b.azw01 = g_rud.rudplant
        SELECT rty10 INTO l_rty10
          FROM rty_file
         WHERE rty01 = g_rue[l_ac].rue02
           AND rty02 = g_rue1[l_ac1].rue05
     
        IF  (l_n = 0 AND g_rue[l_ac].rue14='2' AND NOT cl_null(l_rty10))
            OR (l_n = 0 AND g_rue[l_ac].rue14 ='4' ) THEN
#            CALL cl_set_comp_required("rue36",TRUE)    #TQC-B10151
      
        ELSE
            CALL cl_set_comp_required("rue36",FALSE)
        END IF
     ELSE
        CALL cl_set_comp_entry('rue36',FALSE)
     END IF
#MOD-AC0223 ------------------END
 
#MOD-AC0202 -------------mark
#     SELECT azw07 INTO l_azw07 FROM azw_file
#      WHERE azw01=g_rue[l_ac].rue02 AND azwacti='Y'
#     IF cl_null(l_azw07) THEN
#        CALL cl_err('','art-236',0)
#     ELSE
#       IF l_azw07=g_plant THEN
#          CALL cl_set_comp_entry("rue23",TRUE)
#          IF cl_null(g_rue[l_ac].rue24) THEN
#             CALL cl_set_comp_entry("rue24",FALSE)
#          ELSE
#             CALL cl_set_comp_entry("rue24",TRUE)
#          END IF
#       ELSE
#          CALL cl_set_comp_entry("rue23,rue24",FALSE)
#       END IF
#     END IF
#MOD-AC0202 -------------mark
     #IF cl_null(g_rue[l_ac].rue21) THEN                           #TQC-C80135 mark
      IF cl_null(g_rue[l_ac].rue21) OR g_rue[l_ac].rue21 = 0 THEN  #TQC-C80135 add
         CALL cl_set_comp_required("rue29",FALSE)
      ELSE
         CALL cl_set_comp_required("rue29",TRUE)
      END IF
     #TQC-C80135 add begin ---
      IF NOT cl_null(g_rue[l_ac].rue23) AND g_rue[l_ac].rue23 > 0 THEN
         CALL cl_set_comp_entry("rue24,rue34",TRUE)
      ELSE
         CALL cl_set_comp_entry("rue24,rue34",FALSE) 
      END IF 
     #TQC-C80135 add end -----
END FUNCTION
 
FUNCTION t500_getprice()
DEFINE l_pmc17 LIKE pmc_file.pmc17 #TQC-AC0257
DEFINE l_pmc49 LIKE pmc_file.pmc49 #TQC-AC0257
DEFINE l_pmc22 LIKE pmc_file.pmc22
DEFINE l_pmc47 LIKE pmc_file.pmc47
DEFINE l_price,l_price1 LIKE rue_file.rue28
DEFINE l_rate  LIKE gec_file.gec04
DEFINE l_rue30 LIKE rue_file.rue30
DEFINE l_rue31 LIKE rue_file.rue31
DEFINE l_dbs   LIKE azp_file.azp03
 
    LET g_errno = ''
    IF NOT cl_null(g_rue[l_ac].rue21) AND NOT cl_null(g_rue[l_ac].rue26) AND
       NOT cl_null(g_rue[l_ac].rue12) THEN
       CALL t500_azp(g_rue[l_ac].rue02) RETURNING l_dbs
       #LET g_sql ="SELECT pmc22,pmc47,gec04 FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
       LET g_sql ="SELECT pmc17,pmc49,pmc22,pmc47,gec04 FROM ",cl_get_target_table(g_rue[l_ac].rue02, 'pmc_file'), #FUN-A50102 #TQC-AC0257
                 #" LEFT JOIN ",s_dbstring(l_dbs CLIPPED),"gec_file ON pmc47=gec01 AND gec011='1'", #FUN-A50102
                 " LEFT JOIN ",cl_get_target_table(g_rue[l_ac].rue02, 'gec_file')," ON pmc47=gec01 AND gec011='1'", #FUN-A50102
                 " WHERE pmc01 = '",g_rue[l_ac].rue12,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql, g_rue[l_ac].rue02) RETURNING g_sql  #FUN-A50102           
      PREPARE pmc_sel1 FROM g_sql
      EXECUTE pmc_sel1 INTO l_pmc17,l_pmc49,l_pmc22,l_pmc47,l_rate
      IF l_rate IS NULL THEN LET l_rate=0 END IF
      #TQC-AC0257 mark----begin--------------------
      #CALL s_defprice_A6(g_rue1[l_ac1].rue05,g_rue[l_ac].rue12,g_today,l_pmc22,
      #                    l_pmc47,l_rate,g_rue[l_ac].rue26,g_rue[l_ac].rue02)
      #    RETURNING l_price,l_price1,l_rue30,l_rue31
      #TQC-AC0257 mark-----end---------------------
     #MOD-B10164 Begin---
      CALL s_defprice_new(g_rue1[l_ac1].rue05,g_rue[l_ac].rue12,l_pmc22,g_today,g_rue[l_ac].rue21,'',
                          l_pmc47,l_rate,'1',g_rue[l_ac].rue26,'',l_pmc49,l_pmc17,g_rue[l_ac].rue02)
                RETURNING l_price,l_price1,l_rue30,l_rue31 #TQC-AC0257
      IF cl_null(l_rue30) THEN LET l_rue30 = '4' END IF
     #MOD-B10164 End-----
       IF cl_null(g_errno) THEN
          LET g_rue[l_ac].rue28 = l_price1
          IF g_rue[l_ac].rue28 IS NULL THEN LET g_rue[l_ac].rue28 = 0 END IF
          LET g_rue[l_ac].rue30 = l_rue30
          LET g_rue[l_ac].rue31 = l_rue31
          DISPLAY BY NAME g_rue[l_ac].rue28,g_rue[l_ac].rue30,g_rue[l_ac].rue31
       END IF
    END IF
END FUNCTION
 
FUNCTION t500_b()
DEFINE         l_ac_t    LIKE type_file.num5,
               l_n       LIKE type_file.num5,
               l_lock_sw LIKE type_file.chr1,
               p_cmd     LIKE type_file.chr1
DEFINE li_num  LIKE rue_file.rue21
DEFINE l_chkrue34 LIKE type_file.chr1  #是否模版
DEFINE l_sma133 LIKE sma_file.sma133
DEFINE l_maxnum LIKE rue_file.rue21
DEFINE l_rty10  LIKE rty_file.rty10  #No.FUN-A10037
DEFINE l_rty06_1  LIKE rty_file.rty06       #TQC-AC0375
DEFINE l_rty06_2  LIKE rty_file.rty06       #TQC-AC0375

                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rud.rud01) THEN
                RETURN 
        END IF
        
        SELECT * INTO g_rud.* FROM rud_file
         WHERE rud01=g_rud.rud01
        IF g_rud.rudacti='N' THEN 
           CALL cl_err(g_rud.rud01,'mfg1000',0)
           RETURN 
        END IF
        IF g_rud.rudconf<>'N' THEN
           CALL cl_err('','apm-267',0)
           RETURN 
        END IF
        CALL cl_opmsg('b')
        SELECT sma133 INTO l_sma133 FROM sma_file
        
        LET g_forupd_sql="SELECT rue011,rue00,rue02,'',rue03,rue04,rue06,'',",
                         "rue07,rue08,rue09,rue10,rue11,'',rue12,'',rue13,",
                         "rue14,rue16,rue17,rue18,'',rue19,rue20,rue21,",
                         "rue23,rue24,rue25,rue26,'',rue27,rue28,rue29,rue30,",
                         "rue31,rue32,rue33,rue34,rue36",  #No.FUN-A10037
                         "  FROM rue_file",
                         " WHERE rue01 = ? ",
                         "   AND rue011 = ?",
                         " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

        DECLARE t500_bcl CURSOR FROM g_forupd_sql
      
        INPUT ARRAY g_rue WITHOUT DEFAULTS FROM s_b3.*
                ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,
                        APPEND ROW= FALSE)
        BEFORE INPUT
                IF g_rec_b3 !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN t500_cl USING g_rud.rud01
                IF STATUS THEN
                        CALL cl_err("OPEN t500_cl:",STATUS,1)
                        CLOSE t500_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t500_cl INTO g_rud.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rud.rud01,SQLCA.sqlcode,0)
                        CLOSE t500_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b3>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rue_t.*=g_rue[l_ac].*
                        LET g_rue_o.*=g_rue[l_ac].*
                        OPEN t500_bcl USING g_rud.rud01,g_rue_t.rue011
                        IF STATUS THEN
                                CALL cl_err("OPEN t500_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH t500_bcl INTO g_rue[l_ac].*
                                IF SQLCA.sqlcode THEN
                                    CALL cl_err(g_rue_t.rue011,SQLCA.sqlcode,1)
                                    LET l_lock_sw="Y"
                                END IF
                                CALL t500_b_init()
                                CALL t500_b_check()
                        END IF
                        CALL t500_compentry_rue34()  #TQC-B10151
                        CALL t500_compentry_rue36()  #TQC-B10151
                END IF
      
      AFTER FIELD rue011  #項次
        IF NOT cl_null(g_rue[l_ac].rue011) THEN
           IF p_cmd='a' OR (p_cmd='u' 
              AND g_rue[l_ac].rue011<>g_rue_t.rue011) THEN
              IF g_rue[l_ac].rue011<=0 THEN
                   CALl cl_err(g_rue[l_ac].rue011,'aec-994',0)
                   NEXT FIELD rue011
              ELSE
                 SELECT COUNT(*) INTO l_n
                   FROM rue_file
                  WHERE rue01 = g_rud.rud01
                    AND rue011 = g_rue[l_ac].rue011
                 IF l_n > 0 THEN
                    CALL cl_err(g_rue[l_ac].rue011,'-239',0)
                    NEXT FIELD rue011
                 END IF
              END IF
            END IF
        END IF
        
      AFTER FIELD rue21,rue23 #採購量&調撥量
        LET li_num = FGL_DIALOG_GETBUFFER()
        IF NOT cl_null(li_num) THEN
           IF li_num<0 THEN
              CALL cl_err('','art-184',0)
              NEXT FIELD CURRENT
           ELSE              
              LET g_errmsg = cl_getmsg('art-422',g_lang)
              LET l_maxnum = l_ruc18 * (100+l_sma133)/100
              IF INFIELD(rue21) THEN
                 CALL cl_set_comp_entry("rue26",TRUE)
                 CALL t500_getprice()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD CURRENT
                 END IF
                 IF cl_null(g_rue[l_ac].rue23) THEN
                    IF l_maxnum < g_rue[l_ac].rue21+g_rue[l_ac].rue16 THEN
                       ERROR g_rue[l_ac].rue21,'+',g_rue[l_ac].rue16,g_errmsg,l_sma133,'%)=',l_maxnum
                       NEXT FIELD CURRENT
                    END IF
                 ELSE
                    IF  l_maxnum< g_rue[l_ac].rue21 + g_rue[l_ac].rue23+g_rue[l_ac].rue16 THEN
                       ERROR g_rue[l_ac].rue21,'+',g_rue[l_ac].rue23,'+',g_rue[l_ac].rue16,g_errmsg,l_sma133,'%)=',l_maxnum
                       NEXT FIELD CURRENT
                    END IF
                 END IF
              END IF
              IF INFIELD(rue23) THEN
                 CALL cl_set_comp_entry("rue24",TRUE)
                 IF cl_null(g_rue[l_ac].rue21) THEN
                    IF l_maxnum < g_rue[l_ac].rue23+g_rue[l_ac].rue16 THEN
                       ERROR g_rue[l_ac].rue23,'+',g_rue[l_ac].rue16,g_errmsg,l_sma133,'%)=',l_maxnum
                       NEXT FIELD CURRENT
                    END IF
                 ELSE
                    IF l_maxnum < g_rue[l_ac].rue21 + g_rue[l_ac].rue23+g_rue[l_ac].rue16 THEN
                       ERROR g_rue[l_ac].rue21,'+',g_rue[l_ac].rue23,'+',g_rue[l_ac].rue16,g_errmsg,l_sma133,'%)=',l_maxnum
                       NEXT FIELD CURRENT
                    END IF
                 END IF
                #TQC-C80134 add begin ---
                 IF g_rue[l_ac].rue23 = 0 THEN
                    CALL cl_set_comp_entry("rue24,rue34",FALSE)     #TQC-C80136 add
                    LET g_rue[l_ac].rue24 = NULL
                    LET g_rue[l_ac].rue34 = NULL
                    DISPLAY BY NAME g_rue[l_ac].rue24,g_rue[l_ac].rue34 
                 END IF
                #TQC-C80134 add end ----
              END IF             
           END IF  
        ELSE
           IF INFIELD(rue21) THEN
              CALL cl_set_comp_entry("rue26",FALSE)
              LET g_rue[l_ac].rue26 = NULL
              LET g_rue[l_ac].rue26_desc = NULL
              LET g_rue[l_ac].rue27 = NULL
              LET g_rue[l_ac].rue28 = NULL
              LET g_rue[l_ac].rue30 = NULL
              LET g_rue[l_ac].rue31 = NULL
              DISPLAY BY NAME g_rue[l_ac].rue26,g_rue[l_ac].rue26_desc,
                              g_rue[l_ac].rue27,g_rue[l_ac].rue28,
                              g_rue[l_ac].rue30,g_rue[l_ac].rue31
           END IF
           IF INFIELD(rue23) THEN
             #CALL cl_set_comp_entry("rue24",FALSE)                  #TQC-C80135 mark
              CALL cl_set_comp_entry("rue24,rue34",FALSE)            #TQC-C80135 add
              LET g_rue[l_ac].rue24 = NULL
              LET g_rue[l_ac].rue34 = NULL                           #TQC-C80135 add
              DISPLAY BY NAME g_rue[l_ac].rue24,g_rue[l_ac].rue34    #TQC-C80135 add g_rue[l_ac].rue34
           END IF
        END IF
        #No.FUN-A10037 ...begin
        IF INFIELD(rue21) THEN                  #TQC-C80134 add
          #IF NOT cl_null(g_rue[l_ac].rue21) THEN                              #TQC-C80134 mark
           IF NOT cl_null(g_rue[l_ac].rue21) AND g_rue[l_ac].rue21 > 0 THEN    #TQC-C80134 add
              CALL cl_set_comp_entry('rue36',TRUE)
              LET l_n = 0
              SELECT COUNT(*) INTO l_n
                FROM azw_file a,azw_file b
               WHERE a.azw02 = b.azw02
                 AND a.azw01 = g_rue[l_ac].rue02
                 AND b.azw01 = g_rud.rudplant
              SELECT rty10 INTO l_rty10
                FROM rty_file 
               WHERE rty01 = g_rue[l_ac].rue02
                 AND rty02 = g_rue1[l_ac1].rue05
              IF cl_null(g_rue[l_ac].rue36) THEN
                 LET g_rue[l_ac].rue36 = l_rty10
                 DISPLAY BY NAME g_rue[l_ac].rue36
              END IF
             #TQC-C80134 add begin ---
              CALL t500_rue34(g_rue[l_ac].rue36,g_rud.rudplant,g_rue[l_ac].rue02)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rue[l_ac].rue36,g_errno,0)
                 LET g_rue[l_ac].rue36 = ''
                 NEXT FIELD rue36
              END IF
             #TQC-C80134 add end -----
              IF  (l_n = 0 AND g_rue[l_ac].rue14='2' AND NOT cl_null(l_rty10))
                  OR (l_n = 0 AND g_rue[l_ac].rue14 ='4' ) THEN
   #              CALL cl_set_comp_required("rue36",TRUE)                           #TQC-B10151
                  CALL t500_rue34(g_rue[l_ac].rue36,g_rud.rudplant,g_rue[l_ac].rue02)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rue[l_ac].rue36,g_errno,0)
                     NEXT FIELD rue36
                  END IF
              ELSE
                  CALL cl_set_comp_required("rue36",FALSE)
              END IF
           ELSE 
              CALL cl_set_comp_entry('rue36',FALSE)
             #TQC-C80134 add begin ---
              LET g_rue[l_ac].rue36 = NULL
              DISPLAY BY NAME g_rue[l_ac].rue36
             #TQC-C80134 add end ----
           END IF
        #No.FUN-A10037 ...end
        END IF                  #TQC-C80134 add
        CALL t500_compentry_rue34()   #TQC-B10151
        CALL t500_compentry_rue36()   #TQC-B10151
     #FUN-910088--add--start--
        LET g_rue[l_ac].rue21 = s_digqty(g_rue[l_ac].rue21,g_rue[l_ac].rue26)
        LET g_rue[l_ac].rue23 = s_digqty(g_rue[l_ac].rue23,g_rue[l_ac].rue26)
        DISPLAY BY NAME g_rue[l_ac].rue21,g_rue[l_ac].rue23
     #FUN-910088--add--end--
        

     BEFORE FIELD rue24
 #      IF cl_null(g_rue[l_ac].rue23) THEN                    #MOD-AC0202 mark
        IF cl_null(g_rue[l_ac].rue23) OR g_rue[l_ac].rue23 = 0 THEN  #MOD-AC0202
           CALL cl_set_comp_entry('rue24',FALSE)
        ELSE
           CALL cl_set_comp_entry('rue24',TRUE)
        END IF
            
     AFTER FIELD rue24 #撥出機構       
        IF NOT cl_null(g_rue[l_ac].rue24) THEN
           IF p_cmd='a' OR (p_cmd='u' 
              AND (g_rue[l_ac].rue24<>g_rue_t.rue24 OR cl_null(g_rue_t.rue24))) THEN
              IF g_rue[l_ac].rue24 = g_rue[l_ac].rue02 THEN
                 CALL cl_err(g_rue[l_ac].rue24,'art-412',0)
                 LET g_rue[l_ac].rue24 = g_rue_t.rue24
                 DISPLAY BY NAME g_rue[l_ac].rue24
                 NEXT FIELD rue24
              END IF
#TQC-AC0375 ---------------STA
              IF NOT s_chk_item_no(g_rue1[l_ac1].rue05,g_rue[l_ac].rue24) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rue[l_ac].rue24 = g_rue_t.rue24
                 NEXT FIELD rue24
              END IF
#TQC-AC0375 ---------------END
              SELECT COUNT(*) INTO l_n FROM azp_file
               WHERE azp01 = g_rue[l_ac].rue24
              IF l_n = 0 THEN
                 CALL cl_err(g_rue[l_ac].rue24,'art-002',0)
                 LET g_rue[l_ac].rue24 = g_rue_t.rue24
                 DISPLAY BY NAME g_rue[l_ac].rue24
                 NEXT FIELD rue24
              ELSE
#MOD-B20140 -- mark -- str --
#                 SELECT COUNT(*) INTO l_n FROM azp_file a,azp_file b
#                  WHERE a.azp03 = b.azp03
#                    AND a.azp01 = g_rue[l_ac].rue02
#                    AND b.azp01 = g_rue[l_ac].rue24
#MOD-B20140 -- mark -- end --
#MOD-B20140 -- add -- str --
                 SELECT COUNT(*) INTO l_n  FROM azw_file a,azw_file b
                  WHERE a.azw02 = b.azw02               #法人
                    AND a.azw01 = g_rue[l_ac].rue02
                    AND b.azw01 = g_rue[l_ac].rue24
#MOD-B20140 -- add -- end --
                 IF l_n = 0 THEN
#TQC-AC0375 ---------------STA
#                   SELECT COUNT(*) INTO l_n FROM rty_file a,rty_file b
#                    WHERE a.rty06 = b.rty06
#                      AND a.rty01 = g_rue[l_ac].rue02
#                      AND b.rty01 = g_rue[l_ac].rue24
#                      AND a.rty02 = b.rty02
#                      AND a.rty02 = g_rue1[l_ac1].rue05
#                      AND a.rty06 = '1'
#                      AND a.rtyacti = 'Y'
#                      AND b.rtyacti = 'Y'
#                   IF l_n = 0 THEN
#                      CALL cl_err('','art-333',0)
#                      LET g_rue[l_ac].rue24 = g_rue_t.rue24
#                      DISPLAY BY NAME g_rue[l_ac].rue24
#                      NEXT FIELD rue24
#                   ELSE
#                      CALL cl_set_comp_required("rue34",TRUE)
#                   END IF

                    SELECT rty06 INTO l_rty06_1 FROM rty_file
                     WHERE rty01 = g_rue[l_ac].rue02
                       AND rtyacti = 'Y'
                       AND rty02 = g_rue1[l_ac1].rue05
                    IF cl_null(l_rty06_1) THEN
                       LET l_rty06_1 = '1'
                    END IF                 
                    SELECT rty06 INTO l_rty06_2 FROM rty_file 
                     WHERE rty01 = g_rue[l_ac].rue24
                       AND rtyacti = 'Y'
                       AND rty02 = g_rue1[l_ac1].rue05
                    IF cl_null(l_rty06_2) THEN
                       LET l_rty06_2 = '1'
                    END IF
                    IF l_rty06_1<>l_rty06_2 THEN
                       CALL cl_err('','art-333',0)
                       LET g_rue[l_ac].rue24 = g_rue_t.rue24
                       DISPLAY BY NAME g_rue[l_ac].rue24
                       NEXT FIELD rue24
                    ELSE
                       CALL cl_set_comp_required("rue34",TRUE)
                    END IF
#TQC-AC0375 ----------------END
                  ELSE
                     CALL cl_set_comp_required("rue34",FALSE)
                  END IF
              END IF
            END IF
         ELSE
            CALL cl_set_comp_required("rue34",FALSE)
         END IF
        CALL t500_compentry_rue34()      #TQC-B10151
        CALL t500_compentry_rue36()      #TQC-B10151

         
      AFTER FIELD rue26 #採購單位
        IF NOT cl_null(g_rue[l_ac].rue26) THEN
     #FUN-910088--add--start--
        LET g_rue[l_ac].rue21 = s_digqty(g_rue[l_ac].rue21,g_rue[l_ac].rue26)
        LET g_rue[l_ac].rue23 = s_digqty(g_rue[l_ac].rue23,g_rue[l_ac].rue26)
        DISPLAY BY NAME g_rue[l_ac].rue21,g_rue[l_ac].rue23
     #FUN-910088--add--end--
           IF p_cmd='a' OR (p_cmd='u' OR cl_null(g_rue_t.rue26)
              AND g_rue[l_ac].rue26<>g_rue_t.rue26 OR cl_null(g_rue_o.rue26)) THEN              
              CALL t500_rue26('a') 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD rue26
              ELSE
                 LET g_rue_o.rue26=g_rue[l_ac].rue26
                 CALL t500_getprice()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rue26
                 END IF
              END IF
           END IF
        ELSE
              LET g_rue_o.rue26=NULL
              LET g_rue[l_ac].rue26 = NULL
              LET g_rue[l_ac].rue26_desc = NULL
              LET g_rue[l_ac].rue27 = NULL
              DISPLAY BY NAME g_rue[l_ac].rue26,g_rue[l_ac].rue26_desc,
                              g_rue[l_ac].rue27
        END IF
      
      AFTER FIELD rue28 #採購單價
        IF NOT cl_null(g_rue[l_ac].rue28) THEN
           IF p_cmd='a' OR (p_cmd='u' 
              AND g_rue[l_ac].rue28<>g_rue_t.rue28) THEN
              IF g_rue[l_ac].rue28 <= 0 THEN
                 CALL cl_err(g_rue[l_ac].rue28,'art-180',0)
                 NEXT FIELD rue28
              END IF
           END IF
        END IF
      
      BEFORE FIELD rue34
       #IF cl_null(g_rue[l_ac].rue24) THEN                                #TQC-C80136 mark
        IF cl_null(g_rue[l_ac].rue24) OR g_rue[l_ac].rue24 = 0 THEN       #TQC-C80136 add
           CALL cl_set_comp_entry('rue34',FALSE)
        ELSE
           CALL cl_set_comp_entry('rue34',TRUE)
        END IF
          
      AFTER FIELD rue34 #多角貿易流程
        IF NOT cl_null(g_rue[l_ac].rue34) THEN
           #IF p_cmd='a' OR (p_cmd='u' 
           #   AND g_rue[l_ac].rue34<>g_rue_t.rue34) THEN
              CALL t500_rue34(g_rue[l_ac].rue34,g_rue[l_ac].rue24,g_rue[l_ac].rue02)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rue[l_ac].rue34,g_errno,0)
                 NEXT FIELD rue34
              END IF
           #END IF
        END IF
      #No.FUN-A10037 ...begin
      BEFORE FIELD rue36
      AFTER FIELD rue36 #多角貿易流程
        IF NOT cl_null(g_rue[l_ac].rue36) THEN
           #IF p_cmd='a' OR (p_cmd='u' 
           #   AND g_rue[l_ac].rue36<>g_rue_t.rue36) THEN
              CALL t500_rue34(g_rue[l_ac].rue36,g_rud.rudplant,g_rue[l_ac].rue02)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rue[l_ac].rue36,g_errno,0)
                 NEXT FIELD rue36
              END IF
           #END IF
        END IF
      #No.FUN-A10037 ...end
        
        
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rue[l_ac].* = g_rue_t.*
              CLOSE t500_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rue[l_ac].rue02,-263,1)
              LET g_rue[l_ac].* = g_rue_t.*
           ELSE
             
              UPDATE rue_file SET  rue011 = g_rue[l_ac].rue011,
                                   rue16 = g_rue[l_ac].rue16,
                                   rue21 = g_rue[l_ac].rue21,
                                   rue23 = g_rue[l_ac].rue23,
                                   rue24 = g_rue[l_ac].rue24,
                                   rue25 = g_rue[l_ac].rue25,
                                   rue26 = g_rue[l_ac].rue26,
                                   rue27 = g_rue[l_ac].rue27,
                                   rue28 = g_rue[l_ac].rue28,
                                   rue29 = g_rue[l_ac].rue29,
                                   rue30 = g_rue[l_ac].rue30,
                                   rue31 = g_rue[l_ac].rue31,
                                   rue34 = g_rue[l_ac].rue34,
                                   rue36 = g_rue[l_ac].rue36  #No.FUN-A10037
                 WHERE rue01 = g_rud.rud01
                   AND rue011 = g_rue_t.rue011
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rue_file",g_rud.rud01,g_rue_t.rue04,SQLCA.sqlcode,"","",1) 
                 LET g_rue[l_ac].* = g_rue_t.*
              ELSE
                 LET g_rud.rudmodu = g_user
                 LET g_rud.ruddate = g_today
                 UPDATE rud_file SET rudmodu = g_rud.rudmodu,ruddate = g_rud.ruddate
                  WHERE rud01 = g_rud.rud01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rud_file",g_rud.rudmodu,g_rud.ruddate,SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_rud.rudmodu,g_rud.ruddate
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rue[l_ac].* = g_rue_t.*
              END IF
              CLOSE t500_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t500_bcl
           COMMIT WORK
           
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rue24)#撥出機構                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.default1 = g_rue[l_ac].rue24
               CALL cl_create_qry() RETURNING g_rue[l_ac].rue24
               DISPLAY BY NAME g_rue[l_ac].rue24
               NEXT FIELD rue24
            WHEN INFIELD(rue26)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe01" 
               LET g_qryparam.default1 = g_rue[l_ac].rue26
               LET g_qryparam.arg1 = g_rue[l_ac].rue18
               CALL cl_create_qry() RETURNING g_rue[l_ac].rue26
               DISPLAY BY NAME g_rue[l_ac].rue26
               CALL t500_rue26('d')
               NEXT FIELD rue26
            WHEN INFIELD(rue34)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz7" 
               LET g_qryparam.default1 = g_rue[l_ac].rue34
               LET g_qryparam.arg1 = g_rue[l_ac].rue02
              #TQC-C80132 add begin ---
               LET g_qryparam.where = "poy01 IN (SELECT poy01 ",
                                      "            FROM poy_file",
                                      "           WHERE poy04 = '",g_rue[l_ac].rue24,"'",
                                      "             AND poy01 = poz01",
                                      "             AND poy02 = (SELECT MAX(poy02)",
                                      "                            FROM poy_file",
                                      "                           WHERE poy01 = poz01))"
              #TQC-C80132 add end ---
               CALL cl_create_qry() RETURNING g_rue[l_ac].rue34
               CALL t500_rue34(g_rue[l_ac].rue34,g_rue[l_ac].rue24,g_rue[l_ac].rue02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rue34
               END IF
               DISPLAY BY NAME g_rue[l_ac].rue34
               NEXT FIELD rue34
            #No.FUN-A10037  ..begin
            WHEN INFIELD(rue36)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz7" 
               LET g_qryparam.default1 = g_rue[l_ac].rue36
               LET g_qryparam.arg1 = g_rue[l_ac].rue02
              #TQC-C80132 add begin ---
               LET g_qryparam.where = "poy01 IN (SELECT poy01 ",
                                      "            FROM poy_file",
                                      "           WHERE poy04 = '",g_plant,"'",
                                      "             AND poy01 = poz01",
                                      "             AND poy02 = (SELECT MAX(poy02)",
                                      "                            FROM poy_file",
                                      "                           WHERE poy01 = poz01))"
              #TQC-C80132 add end ---
               CALL cl_create_qry() RETURNING g_rue[l_ac].rue36
               CALL t500_rue34(g_rue[l_ac].rue36,g_rud.rudplant,g_rue[l_ac].rue02)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rue36
               END IF
               DISPLAY BY NAME g_rue[l_ac].rue36
               NEXT FIELD rue36
            #No.FUN-A10037  ..end
            OTHERWISE EXIT CASE
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE t500_bcl
    COMMIT WORK
    CALL t500_delall()
    CALL t500_show()
END FUNCTION                             
 
FUNCTION t500_delall()
DEFINE l_n  LIKE type_file.num5
 
   SELECT COUNT(*) INTO l_n FROM rue_file
     WHERE rue01 = g_rud.rud01
           
   IF l_n=0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rud_file WHERE rud01 = g_rud.rud01
      CLEAR FORM
   END IF
 
END FUNCTION
                                
FUNCTION t500_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rud.rud01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rud.* FROM rud_file
    WHERE rud01=g_rud.rud01 
 
   IF g_rud.rudacti ='N' THEN    
      CALL cl_err(g_rud.rud01,'mfg1000',0)
      RETURN
   END IF
   IF g_rud.rudconf<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
    END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t500_cl USING g_rud.rud01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_rud.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rud.rud01,SQLCA.sqlcode,0)    
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t500_show()
 
   WHILE TRUE
 
      LET g_rud.rudmodu=g_user
      LET g_rud.ruddate=g_today
 
      CALL t500_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rud.*=g_rud_t.*
         CALL t500_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rud.rud01 <> g_rud_t.rud01 THEN            
         UPDATE rue_file SET rue01 = g_rud.rud01
          WHERE rue01 = g_rud_t.rud01 AND rudplant=g_rud_t.rudplant 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rue_file",g_rud_t.rud01,"",SQLCA.sqlcode,"","rue",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rud_file SET rud_file.* = g_rud.*
       WHERE rud01=g_rud.rud01 AND rudplant=g_rud.rudplant 
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rud_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t500_cl
   COMMIT WORK
   CALL t500_show()
 
END FUNCTION          
                
FUNCTION t500_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rud.rud01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t500_cl USING g_rud.rud01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_rud.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rud.rud01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rud.rudacti='N' THEN 
      CALL cl_err(g_rud.rud01,'mfg1000',0)
      RETURN 
   END IF
   IF g_rud.rudconf<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
   END IF
   CALL t500_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rud01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rud.rud01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM rud_file WHERE rud01 = g_rud.rud01
      DELETE FROM rue_file WHERE rue01 = g_rud.rud01
      CLEAR FORM
      CALL g_rue1.clear()
      CALL g_rue.clear()
      OPEN t500_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t500_cs
         CLOSE t500_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t500_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t500_cs
         CLOSE t500_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t500_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t500_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t500_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t500_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t500_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rud.rud01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t500_cl USING g_rud.rud01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_rud.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rud.rud01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rud.rudconf<>'N' THEN
      CALL cl_err('','art-050',0)
      RETURN 
   END IF
   LET g_success = 'Y'
 
   CALL t500_show()
 
   IF cl_exp(0,0,g_rud.rudacti) THEN                   
      LET g_chr=g_rud.rudacti
      IF g_rud.rudacti='Y' THEN
         LET g_rud.rudacti='N'
      ELSE
         LET g_rud.rudacti='Y'
      END IF
 
      UPDATE rud_file SET  rudacti=g_rud.rudacti,
                           rudmodu=g_user,
                           ruddate=g_today
       WHERE rud01=g_rud.rud01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rud_file",g_rud.rud01,"",SQLCA.sqlcode,"","",1)  
         LET g_rud.rudacti=g_chr
      END IF
   END IF
 
   CLOSE t500_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_set_field_pic("","","","","",g_rud.rudacti)
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rudacti,rudmodu,ruddate
     INTO g_rud.rudacti,g_rud.rudmodu,g_rud.ruddate FROM rud_file
    WHERE rud01=g_rud.rud01 
   DISPLAY BY NAME g_rud.rudacti,g_rud.rudmodu,g_rud.ruddate
   CALL cl_set_field_pic('','','','','',g_rud.rudacti)
END FUNCTION  
 
FUNCTION t500_recollect()
DEFINE l_n     LIKE type_file.num5
 
    IF cl_null(g_rud.rud01) THEN
      CALL cl_err("",-400,0)
      RETURN
    END IF
    BEGIN WORK
 
    OPEN t500_cl USING g_rud.rud01
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t500_cl INTO g_rud.*               
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_rud.rud01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
    END IF
 
    IF g_rud.rudconf<>'N' THEN
      CALL cl_err('','apm-267',0)
      RETURN 
    END IF
    IF cl_confirm('art-256') THEN       
       SELECT COUNT(*) INTO l_n FROM rue_file
        WHERE rue01 = g_rud.rud01
       IF l_n>0 THEN
          DELETE FROM rue_file WHERE rue01 = g_rud.rud01
       END IF
    ELSE
       RETURN
    END IF
    CALL t500_collect()
END FUNCTION
 
FUNCTION t500_collect()  #過濾條件
DEFINE lc_qbe_sn  LIKE gbm_file.gbm01       
DEFINE l_wc STRING
DEFINE l_ruc05_bdate,l_ruc05_edate LIKE ruc_file.ruc05
DEFINE l_ruc27_bdate,l_ruc27_edate LIKE ruc_file.ruc05
DEFINE l_azw07 LIKE azw_file.azw07
DEFINE l_rue   RECORD LIKE rue_file.*
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_pmc58 LIKE pmc_file.pmc58
DEFINE l_sql STRING
DEFINE l_pmc17 LIKE pmc_file.pmc17 #TQC-AC0257
DEFINE l_pmc49 LIKE pmc_file.pmc49 #TQC-AC0257
DEFINE l_pmc22 LIKE pmc_file.pmc22
DEFINE l_pmc47 LIKE pmc_file.pmc47
DEFINE l_price,l_price1 LIKE rue_file.rue28
DEFINE l_rate  LIKE gec_file.gec04
DEFINE l_ruc29 LIKE ruc_file.ruc29   
DEFINE l_rue20 LIKE rue_file.rue20  #FUN-AB0101
DEFINE l_ruc18 LIKE ruc_file.ruc18  #FUN-AB0101
 
    LET p_row = 2 LET p_col = 21
    OPEN WINDOW t500a AT p_row,p_col WITH FORM "art/42f/artt500a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt500a")
    CONSTRUCT BY NAME l_wc ON ruc01,ruc06,ruc26,ruc10,ima131,ruc28
      BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
          
      ON ACTION qbe_save
         CALL cl_qbe_save()
           
      ON ACTION controlp
           CASE
              WHEN INFIELD(ruc01) #需求機構
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ruc01" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruc01
                   NEXT FIELD ruc01
              WHEN INFIELD(ruc06)     #取貨機構
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ruc06" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruc06
                   NEXT FIELD ruc06
              WHEN INFIELD(ruc26)     #配送中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ruc26"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruc26
                   NEXT FIELD ruc26
              WHEN INFIELD(ruc10)     #供應商
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ruc10"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruc10
                   NEXT FIELD ruc10
              WHEN INFIELD(ima131)     #類別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ima131"   
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
              WHEN INFIELD(ruc28)     #需求類型
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ruc28"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ruc28
                   NEXT FIELD ruc28
              OTHERWISE EXIT CASE
           END CASE
           
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t500a
      RETURN
   END IF
 
   INPUT l_ruc05_bdate,l_ruc05_edate,l_ruc27_bdate,l_ruc27_edate
         FROM ruc05_bdate,ruc05_edate,ruc27_bdate,ruc27_edate
 
      AFTER FIELD ruc05_bdate
         IF NOT cl_null(l_ruc05_bdate) THEN
            IF NOT cl_null(l_ruc05_edate) THEN
               IF l_ruc05_bdate>l_ruc05_edate THEN
               CALL cl_err('','art-201',0)
               NEXT FIELD ruc05_bdate
               END IF
            END IF
         END IF
 
      AFTER FIELD ruc05_edate
         IF NOT cl_null(l_ruc05_edate) THEN
            IF NOT cl_null(l_ruc05_bdate) THEN
               IF l_ruc05_bdate>l_ruc05_edate THEN
               CALL cl_err('','art-201',0)
               NEXT FIELD ruc05_edate
               END IF
            END IF
         END IF
         
      AFTER FIELD ruc27_bdate
         IF NOT cl_null(l_ruc27_bdate) THEN
            IF NOT cl_null(l_ruc27_edate) THEN
               IF l_ruc27_bdate>l_ruc27_edate THEN
               CALL cl_err('','art-201',0)
               NEXT FIELD ruc27_bdate
               END IF
            END IF
         END IF
 
      AFTER FIELD ruc27_edate
         IF NOT cl_null(l_ruc27_edate) THEN
            IF NOT cl_null(l_ruc27_bdate) THEN
               IF l_ruc27_bdate>l_ruc27_edate THEN
               CALL cl_err('','art-201',0)
               NEXT FIELD ruc27_edate
               END IF
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
       LET INT_FLAG=0
       CLOSE WINDOW t500a
       RETURN
    END IF
 
    LET g_sql = "SELECT ruc00,'','',ruc01,ruc02,ruc03,ruc04,ruc23,ruc24,",
                      " ruc25,ruc05,ruc07,ruc06,ruc10,ruc11,ruc12,ruc13,",
                      " COALESCE(ruc19,0)+COALESCE(ruc20,0)+COALESCE(ruc21,0),ruc14,ruc16,ruc17,",
                      " COALESCE(ruc18,0)-COALESCE(ruc19,0)-COALESCE(ruc20,0)-COALESCE(ruc21,0),",
                      " '','','','','N','','','',ruc05,'','',",
                      " ruc26,ruc27,'',ruc28,'','','',ruc29",   #No.FUN-A10037
                 " FROM ruc_file,ima_file ",
                " WHERE ruc04 = ima01 AND ruc30='",g_rud.rud05,"' AND ",l_wc CLIPPED  #No.FUN-A10037
                
    IF NOT cl_null(l_ruc05_bdate) THEN
       LET g_sql = g_sql," AND ruc05>='",l_ruc05_bdate,"'"
    END IF
    IF NOT cl_null(l_ruc05_edate) THEN
       LET g_sql = g_sql," AND ruc05<='",l_ruc05_edate,"'"
    END IF
    IF NOT cl_null(l_ruc27_bdate) THEN
       LET g_sql = g_sql," AND ruc27>='",l_ruc27_bdate,"'"
    END IF
    IF NOT cl_null(l_ruc27_edate) THEN
       LET g_sql = g_sql," AND ruc27<='",l_ruc27_edate,"'"
    END IF
    
    #LET g_sql = g_sql," AND ruc00='1' AND ruc12='2' AND ruc22 IS NULL"  #No.FUN-A10037
    LET g_sql = g_sql," AND ruc00='1' AND (ruc12='2' OR ruc12='4') AND ruc22 IS NULL"  #No.FUN-A10037
    LET g_sql = g_sql," ORDER BY ruc00,ruc01,ruc02,ruc03"
    PREPARE ruc_pre FROM g_sql
    DECLARE ruc_cs CURSOR FOR ruc_pre      
    
    LET g_cnt = 1  
    #No.FUN-A10037...begin 規範修改 變量一一列出
    FOREACH ruc_cs INTO l_rue.rue00,l_rue.rue01,l_rue.rue011,l_rue.rue02,l_rue.rue03,
                        l_rue.rue04,l_rue.rue05,l_rue.rue06 ,l_rue.rue07,l_rue.rue08,
                        l_rue.rue09,l_rue.rue10,l_rue.rue11 ,l_rue.rue12,l_rue.rue13,
                        l_rue.rue14,l_rue.rue15,l_rue.rue16 ,l_rue.rue17,l_rue.rue18,
                        l_rue.rue19,l_rue.rue20,l_rue.rue21 ,l_rue.rue22,l_rue.rue23,
                        l_rue.rue24,l_rue.rue25,l_rue.rue26 ,l_rue.rue27,l_rue.rue28,
                        l_rue.rue29,l_rue.rue30,l_rue.rue31 ,l_rue.rue32,l_rue.rue33,
                        l_rue.rue34,l_rue.rue35,l_rue.ruelegal,l_rue.rueplant,l_rue.rue36,l_ruc29
    #No.FUN-A10037...end


      IF STATUS THEN
          CALL cl_err('',STATUS,1)
          EXIT FOREACH
      END IF
#MOD-AC0177 ----------------STA
      IF cl_null(l_rue.rue16) THEN
         LET l_rue.rue16 = 0
      END IF
      IF cl_null(l_rue.rue20) THEN
         LET l_rue.rue20 = 0
      END IF
      IF cl_null(l_rue.rue21) THEN
         LET l_rue.rue21 = 0
      END IF
      IF cl_null(l_rue.rue22) THEN
         LET l_rue.rue22 = 0
      END IF
      IF cl_null(l_rue.rue23) THEN
         LET l_rue.rue23 = 0
      END IF
#MOD-AC0177 ----------------END
      #No.FUN-A10037 ..begin
      #SELECT azw07 INTO l_azw07 FROM azw_file
      #  WHERE azw01=l_rue.rue02 AND azwacti='Y'
      #IF cl_null(l_azw07) THEN
      #   CONTINUE FOREACH
      #ELSE
      #  IF l_azw07=g_plant THEN
      #     IF l_rue.rue14<>'2' THEN
      #        CONTINUE FOREACH
      #     END IF
      #  ELSE
      #     CONTINUE FOREACH
      #  END IF
      #END IF
      #No.FUN-A10037 ..end
      #FUN-AB0101 --------add start--------------
      SELECT SUM(rue20) INTO l_rue20 FROM rue_file,rud_file
       WHERE rue01 = rud01 
         AND rue02 = l_rue.rue02 AND rue03 = l_rue.rue03 AND rue04  = l_rue.rue04
         AND rudconf = 'N'
      SELECT ruc18 INTO l_ruc18 FROM ruc_file
       WHERE ruc00 = l_rue.rue00 AND ruc01 = l_rue.rue02 AND ruc02 = l_rue.rue03 AND ruc03  = l_rue.rue04
#MOD-AC0177 ----------------STA
      IF cl_null(l_rue20) THEN
         LET l_rue20 =0
      END IF
      IF cl_null(l_ruc18) THEN
         LET l_ruc18 =0
      END IF
#MOD-AC0177 ----------------END
      IF cl_null(l_rue.rue16) THEN LET l_rue.rue16 = 0 END IF   #TQC-AC0227 add

      IF l_rue.rue16 + l_rue20 >= l_ruc18 THEN
         CONTINUE FOREACH
      ELSE
         LET l_rue.rue16 = l_rue.rue16 + l_rue20
         LET l_rue.rue20 = l_ruc18 - l_rue.rue16
      END IF 
      #FUN-AB0101 ---------add end-------------------   

      CALL t500_azp(l_rue.rue02) RETURNING l_dbs
 
      LET l_sql ="SELECT pmc17,pmc49,pmc22,pmc47,COALESCE(pmc58,0),gec04 ", #TQC-AC0257
                  #" FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
                  " FROM ",cl_get_target_table(l_rue.rue02, 'pmc_file'), #FUN-A50102
                  #" LEFT JOIN ",s_dbstring(l_dbs CLIPPED),"gec_file ON pmc47=gec01 AND gec011='1'", #FUN-A50102
                  " LEFT JOIN ",cl_get_target_table(l_rue.rue02, 'gec_file')," ON pmc47=gec01 AND gec011='1'", #FUN-A50102
                 " WHERE pmc01 = '",l_rue.rue12,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql  #FUN-A50102           
      PREPARE pmc_sel FROM l_sql
      EXECUTE pmc_sel INTO l_pmc17,l_pmc49,l_pmc22,l_pmc47,l_pmc58,l_rate #TQC-AC0257
      IF l_rate IS NULL THEN LET l_rate=0 END IF
      LET l_rue.rue29 = l_rue.rue29 + l_pmc58
      LET l_rue.rue21 = l_rue.rue20
      LET l_rue.rue26 = l_rue.rue18
      LET l_rue.rue27 = 1 
      IF l_ruc29 = 'Y' THEN
         LET l_rue.rue11 = ''
      END IF
      #TQC-AC0257 mark----begin------------------------
      #CALL s_defprice_A6(l_rue.rue05,l_rue.rue12,g_today,l_pmc22,
      #                   l_pmc47,l_rate,l_rue.rue26,l_rue.rue02)
      #    RETURNING l_price,l_rue.rue28,l_rue.rue30,l_rue.rue31
      #TQC-AC0257 mark-----end-------------------------
     #MOD-B10164 Begin---
      CALL s_defprice_new(l_rue.rue05,l_rue.rue12,l_pmc22,g_today,l_rue.rue21,'',
                          l_pmc47,l_rate,'1',l_rue.rue26,'',l_pmc49,l_pmc17,l_rue.rue02)
                RETURNING l_price,l_rue.rue28,l_rue.rue30,l_rue.rue31
      IF cl_null(l_rue.rue30) THEN LET l_rue.rue30 = '4' END IF
     #MOD-B10164 End-----
      LET l_rue.rue011 = g_cnt
      LET l_rue.rue01 = g_rud.rud01
      LET l_rue.rueplant = g_rud.rudplant
      LET l_rue.ruelegal = g_rud.rudlegal
      LET l_rue.rue16 = s_digqty(l_rue.rue16,l_rue.rue18)    #FUN-910088--add--
      LET l_rue.rue20 = s_digqty(l_rue.rue20,l_rue.rue18)    #FUN-910088--add--
      INSERT INTO rue_file VALUES(l_rue.*)
      LET g_cnt=g_cnt+1
    END FOREACH
    COMMIT WORK
    CLOSE WINDOW t500a
END FUNCTION                                                    
                    
FUNCTION t500_y() #審核
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_rue   RECORD LIKE rue_file.*
DEFINE l_sql   STRING
DEFINE l_rty03 LIKE rty_file.rty03
DEFINE l_pmm   RECORD LIKE pmm_file.*
DEFINE l_pmn   RECORD LIKE pmn_file.*
 
   IF cl_null(g_rud.rud01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
     
#CHI-C30107 ------------- add ------------- begin
    IF g_rud.rudacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
    END IF

    IF g_rud.rudconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
    END IF

    IF g_rud.rudconf='X' THEN
      CALL cl_err('',9024,0)
      RETURN
    END IF
   IF NOT cl_confirm('axm-108') THEN
       RETURN
   END IF
   SELECT * INTO g_rud.* FROM rud_file WHERE rud01 = g_rud.rud01
#CHI-C30107 ------------- add ------------- end
   LET g_success = 'Y'
   LET g_errno = ''
    DROP TABLE pmn_temp
    DROP TABLE pmm_temp
    DROP TABLE pml_temp
    DROP TABLE rue_temp2 
    DROP TABLE tsk_temp
    DROP TABLE tsl_temp
    DROP TABLE rue_temp
    DROP TABLE ruo_temp
    DROP TABLE rup_temp
    DROP TABLE poz_temp
    DROP TABLE poy_temp
    DROP TABLE pox_temp
    SELECT * FROM pmm_file WHERE 1=0 INTO TEMP pmm_temp
    SELECT * FROM pmn_file WHERE 1=0 INTO TEMP pmn_temp             
    SELECT * FROM pmk_file WHERE 1=0 INTO TEMP pmk_temp
    SELECT * FROM pml_file WHERE 1=0 INTO TEMP pml_temp
    SELECT * FROM rue_file WHERE 1 = 0 INTO TEMP rue_temp
    SELECT * FROM rue_file WHERE 1 = 0 INTO TEMP rue_temp2
    SELECT * FROM tsk_file WHERE 1 = 0 INTO TEMP tsk_temp
    SELECT * FROM tsl_file WHERE 1 = 0 INTO TEMP tsl_temp
    SELECT * FROM ruo_file WHERE 1 = 0 INTO TEMP ruo_temp
    SELECT * FROM rup_file WHERE 1 = 0 INTO TEMP rup_temp
    SELECT * FROM poz_file WHERE 1 = 0 INTO TEMP poz_temp
    SELECT * FROM poy_file WHERE 1 = 0 INTO TEMP poy_temp
    SELECT * FROM pox_file WHERE 1 = 0 INTO TEMP pox_temp
   BEGIN WORK
   OPEN t500_cl USING g_rud.rud01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_rud.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
    END IF
 
    IF g_rud.rudacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
    END IF
   
    IF g_rud.rudconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
   
    IF g_rud.rudconf='X' THEN
      CALL cl_err('',9024,0)
      RETURN
    END IF
    SELECT COUNT(*) INTO l_cnt FROM rue_file
     WHERE rue01 = g_rud.rud01
    IF l_cnt = 0 THEN
       CALL cl_err('','art-486',0)
       RETURN
    END IF
#CHI-C30107 ------------- mark --------------- begin
#   IF NOT cl_confirm('axm-108') THEN 
#       RETURN
#   END IF 
#CHI-C30107 ------------- mark --------------- end
    CALL s_showmsg_init()
    
    CALL t500_y_chk()
    IF g_success = 'N' THEN
       CLOSE t500_cl
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
 
#產生機構調撥單
    CALL t500_Transfer()
    IF g_success = 'N' THEN
       CLOSE t500_cl
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
    #No.FUN-A10037 ..begin
    CALL t500_Transfer1()
    IF g_success = 'N' THEN
       CLOSE t500_cl
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
    #No.FUN-A10037 ..end
    #產生採購單
    #CALL t500_PO()  #No.FUN-A10037
    CALL t500_PO_new() #No.FUN-A10037
    IF g_success = 'N' THEN
       CLOSE t500_cl
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
    #產生請購單
    CALL t500_PR()
    IF g_success = 'N' THEN
       CLOSE t500_cl       
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
#TQC-B20004 mark --str--0216--
#    #產生集團調撥單
#    CALL t500_Transfer2()
#    IF g_success = 'N' THEN
#       CLOSE t500_cl      
#       CALL s_showmsg()
#       ROLLBACK WORK
#       RETURN
#    END IF
#    #No.FUN-A10037  ..begin
#    CALL t500_transfer4()
#    IF g_success = 'N' THEN
#       CLOSE t500_cl      
#       CALL s_showmsg()
#       ROLLBACK WORK
#       RETURN
#    END IF
#    #No.FUN-A10037  ..end
#TQC-B20004 mark --end--0216--
 
    #回寫需求匯總表ruc_file
    CALL t500_update()
    IF g_success = 'N' THEN
       CLOSE t500_cl
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF
    
           UPDATE rud_file SET rudconf = 'Y',
                               rudconu = g_user,
                               rudcond = g_today,
                               rudmodu = g_user,
                               ruddate = g_today
            WHERE rud01 = g_rud.rud01
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rud_file",g_rud.rud01,"",STATUS,"","",1) 
              LET g_success = 'N'
            ELSE
            IF SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","rud_file",g_rud.rud01,"","9050","","",1) 
              LET g_success = 'N'          
            END IF                         
            END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rud.rudconf = 'Y'
      LET g_rud.rudconu = g_user
      LET g_rud.rudcond = g_today
      LET g_rud.rudmodu = g_user
      LET g_rud.ruddate = g_today
      DISPLAY BY NAME g_rud.rudconf,g_rud.rudconu,g_rud.rudcond,
                      g_rud.rudmodu,g_rud.ruddate
      CALL cl_set_field_pic('Y',"","","","","")
   ELSE
      CLOSE t500_cl
      ROLLBACK WORK
   END IF
   
END FUNCTION           
 
FUNCTION t500_y_chk()
DEFINE l_rty03 LIKE rty_file.rty03
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_sma133 LIKE sma_file.sma133
DEFINE l_ruc18  LIKE ruc_file.ruc18
DEFINE l_ruc19  LIKE ruc_file.ruc19
DEFINE l_ruc21  LIKE ruc_file.ruc21
DEFINE l_ruc22  LIKE ruc_file.ruc22
DEFINE l_maxnum LIKE ruc_file.ruc18
     
     SELECT sma133 INTO l_sma133 FROM sma_file
     
     DECLARE rue_chk CURSOR FOR SELECT rue00,rue02,rue03,rue04,rue05,
                                       COALESCE(rue21,0),COALESCE(rue23,0),rue25
                                  FROM rue_file
                                 WHERE rue01 = g_rud.rud01
     FOREACH rue_chk INTO l_rue.rue00,l_rue.rue02,l_rue.rue03,
                           l_rue.rue04,l_rue.rue05,
                           l_rue.rue21,l_rue.rue23,l_rue.rue25
       SELECT rty03 INTO l_rty03 FROM rty_file
             WHERE rty01 = g_rud.rudplant
               AND rty02 = l_rue.rue05
               AND rtyacti = 'Y'
            IF cl_null(l_rty03) THEN
               LET g_success = 'N'
               CALL s_errmsg('rue05',l_rue.rue05,'','art-481',1)
               CONTINUE FOREACH
            END IF
      SELECT ruc18,COALESCE(ruc19,0),COALESCE(ruc21,0),ruc22
        INTO l_ruc18,l_ruc19,l_ruc21,l_ruc22
        FROM ruc_file
       WHERE ruc00 = l_rue.rue00
         AND ruc01 = l_rue.rue02
         AND ruc02 = l_rue.rue03
         AND ruc03 = l_rue.rue04
         AND ruc04 = l_rue.rue05
         #AND rucplant = l_rue.rue02 #No.FUN-9C0069
        IF l_ruc22 MATCHES '[678]' THEN
           LET g_success = 'N'
           CALL s_errmsg('rue05',l_rue.rue05,'ruc_file','art-503',1)
        END IF
        LET l_maxnum = l_ruc18 * (100+l_sma133)/100
        IF (l_ruc19+l_rue.rue21)+(l_ruc21+l_rue.rue23)>l_maxnum THEN
           LET g_success = 'N'
           CALL s_errmsg('rue05',l_rue.rue05,'ruc_file','art-504',1)
        END IF
    END FOREACH     
END FUNCTION
#No.FUN-A10123  ..begin 
FUNCTION t500_PO_new()#生成採購單
DEFINE l_sql STRING  #No.FUN-A10037
DEFINE l_n    LIKE type_file.num5
DEFINE l_pmm51 LIKE pmm_file.pmm51
DEFINE l_pmm52 LIKE pmm_file.pmm52
DEFINE l_pmm53 LIKE pmm_file.pmm53
DEFINE l_pmm09 LIKE pmm_file.pmm09
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_pmm904 LIKE pmm_file.pmm904
DEFINE l_rue14 LIKE rue_file.rue14
DEFINE l_dbs_f LIKE azp_file.azp03
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_success LIKE type_file.chr1
DEFINE l_poy02_min LIKE poy_file.poy02
DEFINE l_poy02_max LIKE poy_file.poy02
DEFINE l_poy02 LIKE poy_file.poy02
DEFINE l_poy04 LIKE poy_file.poy04

       DELETE FROM rue_temp
       INSERT INTO rue_temp
       SELECT * FROM rue_file WHERE rue01 = g_rud.rud01

       UPDATE rue_temp 
          SET rue06 = rueplant,
              rue03 = ' ',
#             rue04 = ' ',   #TQC-B20003
              rue04 = 0,     #TQC-B20003
              rue07 = ' ', 
#             rue08 = ' '    #TQC-B20003
              rue08 = 0      #TQC-B20003
        WHERE rue01 = g_rud.rud01
          AND rue14 = '4'
       #將rue_temp非多角貿易的單據rue36置为空,後續將此作為判斷多角的依據
       UPDATE rue_temp SET rue36 = ''
        WHERE rue01 = g_rud.rud01
          AND rue14 = '2'
          AND rue011 IN 
              (SELECT DISTINCT rue011 
                FROM azw_file a,azw_file b,rue_temp,rty_file
               WHERE a.azw01 = rue06
                 AND a.azw02 = b.azw02
                 AND b.azw01 = rueplant
                 AND rue01 = g_rud.rud01
                 AND rue14 = '2'
                 AND rue21 > 0 AND rue21 IS NOT NULL
                 AND rty01=rueplant AND rue05=rty02
                 AND rtyacti='Y' AND rty03='1')
       UPDATE rue_temp SET rue12 = ' '
        WHERE rue01 = g_rud.rud01
          AND rue14 = '2'
          AND rue011 IN 
              (SELECT DISTINCT rue011 
                FROM azw_file a,azw_file b,rue_temp,rty_file
               WHERE a.azw01 = rue06
                 AND a.azw02 <> b.azw02
                 AND b.azw01 = rueplant
                 AND rue01 = g_rud.rud01
                 AND rue14 = '2'
                 AND rue21 > 0 AND rue21 IS NOT NULL
                 AND rty01=rueplant AND rue05=rty02
                 AND rtyacti='Y' AND rty03='1')

       LET l_sql = "SELECT DISTINCT rue06,rue12,rue13,rue14,rue32,rue36", 
                   " FROM rue_temp,rty_file",
                   " WHERE rue01=? ",
                   " AND rue21>0 AND rue21 IS NOT NULL",
                   " AND rty01=rueplant AND rue05=rty02",
                   " AND rtyacti='Y' AND rty03='1'"
       PREPARE rue_pre1 FROM l_sql  
       DECLARE rue_cs1 CURSOR FOR rue_pre1
       FOREACH rue_cs1 USING g_rud.rud01            
                       INTO l_pmm52,l_pmm09,l_pmm51,l_rue14, 
                            l_pmm53,l_pmm904     
         IF STATUS THEN
            CALL s_errmsg('','','Foreach rue_cs1',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF      
         LET g_first = 'N'
         IF l_rue14 = '2' AND l_pmm904 IS NOT NULL THEN
            #產生多角採購單及訂單
            SELECT MIN(poy02),MAX(poy02)
              INTO l_poy02_min,l_poy02_max
              FROM poy_file
             WHERE poy01 = l_pmm904
            LET l_sql = "SELECT poy02,poy04 FROM poy_file ",
                        " WHERE poy01 = '",l_pmm904,"'",
                        " ORDER BY poy02"
            DECLARE poy_cs CURSOR FROM l_sql
            FOREACH poy_cs INTO l_poy02,l_poy04
              LET l_dbs_f = l_dbs
              CALL t500_azp(l_poy04) RETURNING l_dbs
              LET g_first = 'N'
              IF l_poy02 = l_poy02_min THEN
                 LET g_first = 'Y'
                 LET g_from_plant = l_poy04
                 CALL s_flowauno('pmm',l_pmm904,g_today) RETURNING l_success,l_pmm99
                 IF l_success THEN
                    CALL s_errmsg("","","","tri-011",1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
              END IF
              IF (l_poy02 >= l_poy02_min) AND (l_poy02 < l_poy02_max) THEN
                 #採購單 
                 SELECT poy03 INTO l_pmm09 FROM poy_file WHERE poy01 = l_pmm904 AND poy02 = l_poy02+1
                 CALL t500_PO(l_pmm53,l_pmm09,l_pmm904,l_pmm99,l_poy04,l_dbs,l_pmm51)
              END IF
              IF l_poy02 = l_poy02_min THEN
                 #CALL t500_pml_upd(l_dbs) #FUN-A50102
                  CALL t500_pml_upd(l_poy04) #FUN-A50102
              END IF
              IF (l_poy02 > l_poy02_min) AND (l_poy02 <= l_poy02_max) THEN
                 #訂單 
                 SELECT * FROM oea_file WHERE 1=0 INTO TEMP oea_temp
                 SELECT * FROM oeb_file WHERE 1=0 INTO TEMP oeb_temp
                 CREATE TEMP TABLE price_temp(
                 plant1   LIKE azp_file.azp01,
                 plant2   LIKE azp_file.azp01,
                 plant3   LIKE azp_file.azp01,
                 item     LIKE rth_file.rth01,
                 unit     LIKE rth_file.rth02,
                 ima131   LIKE ima_file.ima131,
                 rtl04    LIKE rtl_file.rtl04,
                 rtl05    LIKE rtl_file.rtl05,
                 rtl06    LIKE rtl_file.rtl06,
                 price    LIKE rth_file.rth04,
                 rtg08    LIKE rtg_file.rtg08);
                 CALL t255_sub_order(l_pmm904,l_pmm99,l_dbs_f,l_poy02)  #產生多角訂單
                 DROP TABLE oea_temp
                 DROP TABLE oeb_temp
                 DROP TABLE price_temp
              END IF
            END FOREACH
         ELSE
            #產生一盤採購單據
            CALL t500_azp(l_pmm52) RETURNING l_dbs
            CALL t500_PO(l_pmm53,l_pmm09,l_pmm904,'',l_pmm52,l_dbs,l_pmm51)
            #CALL t500_pml_upd(l_dbs) #FUN-A50102
            CALL t500_pml_upd(l_pmm52) #FUN-A50102
         END IF
       END FOREACH
END FUNCTION
#FUNCTION t500_pml_upd(l_dbs)  #FUN-A50102
FUNCTION t500_pml_upd(l_plant) #FUN-A50102
DEFINE l_sql STRING
#DEFINE l_dbs LIKE azp_file.azp03  #FUN-A50102
DEFINE l_plant LIKE poy_file.poy04 #FUN-A50102

   #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"pml_file a ", #FUN-A50102
  #LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'pml_file a '), #FUN-A50102  #No.TQC-A80022
   LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'pml_file')," a ",           #No.TQC-A80022
               "   SET pml21= (SELECT pmn20 FROM pmn_temp  ",
              #" WHERE pmn24 =a.pml01 AND pmn25 = a.pml02 "   #No.TQC-A80022
               " WHERE pmn24 =a.pml01 AND pmn25 = a.pml02 )"  #No.TQC-A80022
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102            
   PREPARE pml_upd FROM l_sql
   EXECUTE pml_upd 
END FUNCTION
#No.FUN-A10123  .. end
FUNCTION t500_PO(l_pmm53,l_pmm09,l_pmm904,l_pmm99,l_pmmplant,l_dbs,l_pmm51)  #生成採購單
DEFINE l_pmm RECORD LIKE pmm_file.*
DEFINE l_pmn RECORD LIKE pmn_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_flag LIKE type_file.chr1  #標誌是否滿足產生多角代碼   #No.FUN-A10123
DEFINE l_dbs_f LIKE azp_file.azp03  #No.FUN-A10123
DEFINE l_poy04 LIKE poy_file.poy04  #No.FUN-A10123
DEFINE l_dbs  LIKE azp_file.azp03
DEFINE p_dbs  LIKE type_file.chr21
DEFINE l_sql STRING
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_autoconfirm LIKE smy_file.smydmy4
DEFINE l_no  LIKE pmm_file.pmm01
DEFINE l_gec07 LIKE gec_file.gec07
DEFINE l_pmn31 LIKE pmn_file.pmn31
DEFINE l_pmm09 LIKE pmm_file.pmm09
DEFINE l_pmm51 LIKE pmm_file.pmm51
DEFINE l_pmm52 LIKE pmm_file.pmm52
DEFINE l_pmm53 LIKE pmm_file.pmm53
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_pmm904 LIKE pmm_file.pmm904
DEFINE l_pmmplant LIKE pmm_file.pmmplant
 

       #No.FUN-A10123 ...begin
       LET l_pmm.pmm09 = l_pmm09 
       LET l_pmm.pmm99 = l_pmm99 
       LET l_pmm.pmm904 = l_pmm904 
       LET l_pmm.pmmplant = l_pmmplant 
       LET l_pmm.pmm51 = l_pmm51
       LET l_pmm.pmm52 = l_pmm52
       LET l_pmm.pmm53 = l_pmm53
       LET l_flag = 'N'
       IF NOT cl_null(l_pmm.pmm99) THEN
          LET l_flag = 'Y'
          LET l_pmm09 = ' '
       END IF
       #No.FUN-A10123 ..end
              
       LET l_sql = " SELECT rue011,COALESCE(rue07,rue03),rue05,",
                   " COALESCE(rue08,rue04),rue15,rue17,",
                   " rue21/rue27,rue26,rue27,rue28,rue30,rue31,rue33 ", #No.FUN-960130
                   " FROM rue_temp,rty_file",
                   " WHERE rue01=?  ",
                   " AND rue13 = ? AND rue21>0 AND rue21 IS NOT NULL",
                   " AND COALESCE(rue06,'X') = COALESCE(?,'X')",
                   " AND COALESCE(rue12,'X') = COALESCE(?,'X')", 
                   " AND COALESCE(rue32,'X') = COALESCE(?,'X')", 
                   " AND COALESCE(rue36,'X') = COALESCE(?,'X')",  #No.FUN-A10037
                   " AND rty01=rueplant AND rue05 = rty02",
                   " AND rtyacti = 'Y' AND rty03 = '1'"
       PREPARE rue_pre2 FROM l_sql 
       DECLARE rue_cs2 CURSOR FOR rue_pre2                               
       
       SELECT * INTO g_sma.* FROM sma_file
        #機構DB
#取默認單別arti099
         #LET l_sql ="SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file",  #FUN-A50102
         #FUN-C90050 mark begin---
         #LET l_sql ="SELECT rye03 FROM ",cl_get_target_table(l_pmmplant, 'rye_file'),  #FUN-A50102
         #           " WHERE rye01 = 'apm'",
         #           "   AND rye02 = '2'",
         #           "   AND ryeacti = 'Y'"
         #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
         #CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102           
         #PREPARE rye_po FROM l_sql
         #EXECUTE rye_po INTO l_no
         #FUN-C90050 mark end-----
  
         CALL s_get_defslip('apm','2',l_pmmplant,'N') RETURNING l_no   #FUN-C90050 add

         IF cl_null(l_no) THEN
            CALL s_errmsg('','','','art-330',1)
            LET g_success = 'N'
         END IF
#判斷是否直接審核
         #LET l_sql="SELECT smydmy4 FROM ",s_dbstring(l_dbs CLIPPED),"smy_file", #FUN-A50102
         LET l_sql="SELECT smydmy4 FROM ",cl_get_target_table(l_pmmplant, 'smy_file'), #FUN-A50102
                   " WHERE smyslip=?"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102          
         PREPARE smy_po FROM l_sql
         EXECUTE smy_po USING l_no INTO l_autoconfirm  
         IF l_autoconfirm='Y' OR l_flag = 'Y' THEN   #No.FUN-A10123
            LET l_pmm.pmm25 = '2'
            LET l_pmm.pmm18 = 'Y'         #審核碼
            LET l_pmm.pmmcond = g_today
            LET l_pmm.pmmconu = g_user
            LET l_pmm.pmmcont = TIME
         ELSE
            LET l_pmm.pmm25 = '0'
            LET l_pmm.pmm18 = 'N'         #審核碼
            LET l_pmm.pmmcond = ''
            LET l_pmm.pmmconu = ''
            LET l_pmm.pmmcont = ''
         END IF
         LET l_pmm.pmm52 = l_pmm.pmmplant  
         SELECT azw02 INTO l_pmm.pmmlegal FROM azw_file WHERE azw01 = l_pmm.pmmplant
         CALL s_auto_assign_no("apm",l_no,g_today,"2","pmm_file","pmm01",l_pmm.pmmplant,"","")
             RETURNING li_result,l_pmm.pmm01
         IF (NOT li_result) THEN                                                                           
            LET g_success = 'N'   
            CALL s_errmsg('pmm01',l_pmm.pmm01,'','sub-145',1)
         END IF
         SELECT pmc17,pmc49,pmc22,pmc47,COALESCE(gec04,0),gec07 
           INTO l_pmm.pmm20,l_pmm.pmm41,l_pmm.pmm22,l_pmm.pmm21,l_pmm.pmm43,l_gec07
           FROM pmc_file LEFT JOIN gec_file ON pmc47=gec01 AND gec011='1'
          WHERE pmc01 = l_pmm.pmm09 AND pmc05 = '1'
         IF g_aza.aza17 = l_pmm.pmm22 THEN
            LET l_pmm.pmm42 = 1
         ELSE
            CALL s_curr3(l_pmm.pmm22,g_today,g_sma.sma904) RETURNING l_pmm.pmm42
         END IF
         DELETE FROM pmm_temp
         DELETE FROM pmn_temp  #No.FUN-A10123 不能放foreach裏面
     #   INSERT INTO pmm_temp(pmm01,pmm51,pmmpos) VALUES(l_pmm.pmm01,l_pmm.pmm51,'N')#TQC-A80037 mark 
         INSERT INTO pmm_temp(pmm01,pmm51,pmmpos,pmmplant,pmmlegal) VALUES(l_pmm.pmm01,l_pmm.pmm51,'N',g_plant,g_legal) #TQC-A80037 add
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL s_errmsg('','','ins pmm_temp',SQLCA.sqlcode,1)
         END IF
         LET l_pmm.pmm40 = 0
         LET l_pmm.pmm40t = 0                               
         LET g_cnt = 1
         FOREACH rue_cs2 USING g_rud.rud01,   #No.FUN-A10037
                               l_pmm.pmm51,l_pmm.pmm52,l_pmm09,
                               l_pmm.pmm53,l_pmm.pmm904  
                          INTO l_pmn.pmn76,l_pmn.pmn24,l_pmn.pmn04,
                               l_pmn.pmn25,l_pmn.pmn08,l_pmn.pmn72,
                               l_pmn.pmn20,l_pmn.pmn07,l_pmn.pmn09,l_pmn31,
                               l_pmn.pmn73,l_pmn.pmn74,l_pmn.pmn33 
            LET l_pmn.pmn20 = s_digqty(l_pmn.pmn20,l_pmn.pmn07)    #FUN-910088--add--
            IF STATUS THEN
               CALL s_errmsg('','','Foreach rue_cs2',STATUS,1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF           
            IF l_flag ='Y' THEN  #No.FUN-A10123
               LET l_pmm.pmm02='TAP'
            ELSE 
               LET l_pmm.pmm02='REG' 
            END IF  
            LET p_dbs = s_dbstring(l_dbs CLIPPED)
            CALL s_defprice_new(l_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,g_today,l_pmn.pmn20,'',
                             l_pmm.pmm21,l_pmm.pmm43,'1',l_pmn.pmn07,'',l_pmm.pmm41,l_pmm.pmm20,l_pmm.pmmplant)
                  RETURNING l_pmn.pmn31,l_pmn.pmn31t,
                            l_pmn.pmn73,l_pmn.pmn74    #TQC-AC0257 add
 
            LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn31*l_pmn.pmn20
            LET l_pmm.pmm40t = l_pmm.pmm40t + l_pmn.pmn31t*l_pmn.pmn20
            IF cl_null(l_pmn.pmn73) THEN LET l_pmn.pmn73 = '4'   END IF         #FUN-AB0101
            INSERT INTO pmn_temp(pmn01,pmn02,pmn20,pmn31,pmn42,pmn50,pmn51,
#                                pmn53,pmn55,pmn57,pmn61,pmn62,pmn73)      #TQC-9B0203
#                                pmn53,pmn55,pmn57,pmn58,pmn61,pmn62,pmn73,pmn09)  #No.FUN-A10123#TQC-A80037 modify
                                 pmn53,pmn55,pmn57,pmn58,pmn61,pmn62,pmn73,pmn09,pmnplant,pmnlegal)  #No.TQC-A80037 modify
                          VALUES(l_pmm.pmm01,g_cnt,l_pmn.pmn20,l_pmn.pmn31,0,
#                                0,0,0,0,0,l_pmn.pmn04,1,l_pmn.pmn73)      #TQC-9B0203
#                                0,0,0,0,0,0,l_pmn.pmn04,1,l_pmn.pmn73,l_pmn.pmn09) #No.FUN-A10123 #TQC-A80037 modify
                                 0,0,0,0,0,0,l_pmn.pmn04,1,l_pmn.pmn73,l_pmn.pmn09,g_plant,g_legal) #No.FUN-A10123 #TQC-A80037 modify
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               CALL s_errmsg('','','ins pmn_temp',SQLCA.sqlcode,1)
            END IF
            IF cl_null(l_pmn.pmn33) OR l_pmn.pmn33 < g_today THEN LET l_pmn.pmn33 = g_today END IF #No.FUN-A10037
            UPDATE pmn_temp SET pmn76 = l_pmn.pmn76,   #來源項次
                                pmnlegal = l_pmm.pmmlegal,
                                pmnplant = l_pmm.pmmplant,
                                pmn24 = l_pmn.pmn24,   #請購單號
                                pmn04 = l_pmn.pmn04,   #商品編號
                                pmn25 = l_pmn.pmn25,   #請購單號項次
                                pmn08 = l_pmn.pmn08,   #庫存單位
                                pmn72 = l_pmn.pmn72,   #商品條碼
                                pmn07 = l_pmn.pmn07,   #採購單位
                                pmn74 = l_pmn.pmn74,   #價格來源
                                pmn16 = l_pmm.pmm25,   #狀況碼
                                pmn38 = 'Y',           #
                                pmn63 = "N",   
                                pmn64 = "N",  
                                pmn65 = '1',   
                                pmn90 = 0,     
                                pmn75 = g_rud.rud01,
                                pmn77 = g_rud.rudplant,
                                pmn30 = l_pmn.pmn30,
                                pmn31t = l_pmn.pmn31t,
                                pmn35  = l_pmn.pmn33,       #TQC-B30144 add         
                                pmn011 = l_pmm.pmm02,
                                #No.FUN-960130 begin
                                #pmn33 = g_today,
                                #pmn34 = g_today,
                                pmn33 = l_pmn.pmn33,
                                pmn34 = l_pmn.pmn33, 
                                #No.FUN-960130 end
                                pmn11 = 'N',                               
                                pmn041 = (SELECT ima02 FROM ima_file WHERE ima01 = l_pmn.pmn04 AND imaacti = 'Y')
            WHERE pmn01 = l_pmm.pmm01 AND pmn02 = g_cnt  
            UPDATE pmn_temp SET pmn86 = pmn07,pmn87 = pmn20    #NO.FUN-A10123 計價單位 數量
            LET g_cnt = g_cnt+1
        END FOREACH
          
         #No.FUN-A10123  begin
         IF l_flag ='N' THEN 
             LET l_pmm.pmm904 = NULL 
             LET l_pmm.pmm901 = 'N'
         ELSE
             LET l_pmm.pmm901 = 'Y'
         END IF 
         IF g_first = 'Y' THEN
            LET l_pmm.pmm906 = 'Y'
         ELSE
            LET l_pmm.pmm906 = 'N'
         END IF
         #No.FUN-A10123  end
         UPDATE pmm_temp SET pmm02 = l_pmm.pmm02,  #採購單性質
                             pmm09 = l_pmm.pmm09,  #廠商
                             pmm52 = l_pmm.pmm52,  #採購機構
                             pmm53 = l_pmm.pmm53,  #配送中心
                             pmm904 = l_pmm.pmm904,#多角貿易流程代碼
                             pmm99 = l_pmm.pmm99,#多角貿易流程代碼
                             pmmplant = l_pmm.pmmplant, #當前機構
                             pmmlegal = l_pmm.pmmlegal,
                             pmm04 = g_today,      #採購日期
                             pmm31 = (SELECT azn02 FROM azn_file WHERE azn01 = g_today),#會計年度		
                             pmm03 = 0,	         #更動序號
                             pmm12 = g_user,     #採購員
                             pmm13 = g_grup,     #採購部門
                             pmm20 = l_pmm.pmm20,#付款方式
                             pmm41 = l_pmm.pmm41,#價格條件
                             pmm21 = l_pmm.pmm21,#稅種
                             pmm22 = l_pmm.pmm22,#幣別	
                             pmm42 = l_pmm.pmm42,#匯率
                             pmm43 = l_pmm.pmm43,#稅率
                             pmm25 = l_pmm.pmm25,#開立
                             pmm27 = g_today,    #異動日期
                             pmm30 = 'N',        #收貨單打印否
                             pmm40 = l_pmm.pmm40,#未稅總金額
                             pmm40t = l_pmm.pmm40t,#含稅總金額
                             pmm401= 0,          #代買總金額
                             pmm44 = '1',        #扣抵區分   
                             pmm45 = 'Y',        #可用
                             pmm46 = 0,          #預付比率
                             pmm47 = 0,          #預付金額
                             pmm48 = 0,          #已結帳金額
                             pmm902= 'N',        #最終採購單否
                             pmm905= 'Y',        #多角貿易拋轉
                             pmm906= l_pmm.pmm906,#多角貿易來源採購單 #No.FUN-A10123
                             pmmdays = 0,        #列印次數
                             pmmprno = 0,        #列印次數
                             pmmsmax = 0,        #己簽順序
                             pmmsseq = 0,        #應簽順序
                             pmmprsw = 'Y',      #列印控制
                             pmmmksg = 'N',      #是否簽核
                             pmmacti ='Y',       #有效的資料
                             pmmuser = g_user,
                             pmmgrup = g_grup,    #使用者所屬群
                             pmmoriu = g_user,
                             pmmorig = g_grup,    #使用者所屬群
                             pmmcrat = g_today,            
                             pmm909 = "6",   
                             pmm901 = l_pmm.pmm901, #No.FUN-A10123  
                             pmm18 = l_pmm.pmm18, #審核碼
                             pmmconu = l_pmm.pmmconu,
                             pmmcond = l_pmm.pmmcond,
                             pmmcont = l_pmm.pmmcont
           WHERE pmm01 = l_pmm.pmm01
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'pmn_file'), #FUN-A50102
                    " SELECT * FROM pmn_temp WHERE pmn01 = ?"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102            
        PREPARE pmn_ins FROM l_sql
        EXECUTE pmn_ins USING l_pmm.pmm01
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('pmn01',l_pmm.pmm01,'INSERT INTO pmn_file:',SQLCA.sqlcode,1)
        END IF
        IF SQLCA.sqlerrd[3]<>0 THEN
           #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pmm_file", #FUN-A50102
           LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'pmm_file'), #FUN-A50102
                       " SELECT * FROM pmm_temp WHERE pmm01 = ?"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
           CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102            
           PREPARE pmm_ins FROM l_sql
           EXECUTE pmm_ins USING l_pmm.pmm01
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','INSERT INTO pmm_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
        END IF
        #如果要立即審核,則直接調用artt500_sub中的函數進行審核
        IF l_autoconfirm='Y' OR l_flag = 'Y' THEN  #No.FUN-A10123
           SELECT * INTO l_pmm.* FROM pmm_temp WHERE pmm01=l_pmm.pmm01
           CALL t500sub_y_chk(l_pmm.*)          
             IF g_success = "Y" THEN
                CALL t500sub_y_upd(l_pmm.*)  
             END IF
             IF g_success = 'Y' THEN
                   CALL t500sub_issue(l_pmm.*,FALSE)
             END IF    
             IF g_success = 'N' THEN
                RETURN
             END IF
        END IF     
END FUNCTION
 
#請購審核時回寫ruc_file,從sapmt420拷貝過來
FUNCTION t500_PR_trans(l_pmk,l_dbs)   
DEFINE l_pmk RECORD LIKE pmk_file.*
DEFINE l_ruc RECORD LIKE ruc_file.*
DEFINE l_flag LIKE type_file.chr1
DEFINE l_rate LIKE ruc_file.ruc17
DEFINE l_dbs LIKE azp_file.azp03
       
   LET g_sql="SELECT '','',pml01,pml02,pml04,'','','',pml24,pml25,pml48,pml49,pml50,'',",
             " pml47,pml041,pml07,'',pml20,'','','','',",
             " pml51,pml52,pml53,'',pml33,pml54,'',pml191,pml55 ",      
             #" FROM ",s_dbstring(l_dbs CLIPPED),"pml_file WHERE pml01='",l_pmk.pmk01,"' ORDER BY pml02 " #FUN-A50102
             " FROM ",cl_get_target_table(l_pmk.pmkplant, 'pml_file')," WHERE pml01='",l_pmk.pmk01,"' ORDER BY pml02 " #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, l_pmk.pmkplant) RETURNING g_sql  #FUN-A50102          
   PREPARE t420_prepsel FROM g_sql
   DECLARE t420_curssel CURSOR FOR t420_prepsel 
   FOREACH t420_curssel INTO l_ruc.*
      IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
      END IF
      SELECT ima25 INTO l_ruc.ruc13 FROM ima_file WHERE ima01=l_ruc.ruc04
      IF SQLCA.sqlcode=100 THEN LET l_ruc.ruc13=NULL END IF
      CALL s_umfchk(l_ruc.ruc04,l_ruc.ruc16,l_ruc.ruc13)
         RETURNING l_flag,l_rate
      IF l_flag='Y' THEN
         LET l_ruc.ruc17=l_rate
      END IF 
      LET l_ruc.ruc00='1'
      LET l_ruc.ruc01=l_pmk.pmkplant
      LET l_ruc.ruc05=l_pmk.pmkcond
      LET l_ruc.ruc06=l_pmk.pmk47
      IF cl_null(l_ruc.ruc06) THEN
         LET l_ruc.ruc06 = l_pmk.pmkplant
         LET l_ruc.ruc29 = 'Y' #送貨上門
      ELSE
         LET l_ruc.ruc29 = 'N'
      END IF
      SELECT rty04 INTO l_ruc.ruc26 FROM rty_file
       WHERE rty01=l_ruc.ruc06 AND rty02=l_ruc.ruc04
      LET l_ruc.ruc07=l_pmk.pmk46
      LET l_ruc.ruc27=l_pmk.pmk04                                                                                                   
      #LET l_ruc.rucplant=l_pmk.pmkplant #No.FUN-9C0069
      #LET l_ruc.ruclegal=l_pmk.pmklegal #No.FUN-9C0069
      LET l_ruc.ruc33 = ' '              #FUN-CC0057 add
      IF l_ruc.ruc12='2' OR l_ruc.ruc12='3' OR l_ruc.ruc12='4' THEN  #No.FUN-A10037
         INSERT INTO ruc_file VALUES(l_ruc.*) 
         IF STATUS THEN                                                                                                       
            CALL cl_err3("ins","ruc_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1) 
            EXIT FOREACH                                                                                              
         END IF
      END IF
      IF NOT cl_null(l_ruc.ruc23) AND l_ruc.ruc23<>g_plant THEN
         #LET g_sql="UPDATE ",s_dbstring(l_dbs CLIPPED),"pml_file SET pml11='Y'", #FUN-A50102
         LET g_sql="UPDATE ",cl_get_target_table(l_pmk.pmkplant, 'pml_file')," SET pml11='Y'", #FUN-A50102
                   " WHERE pml01=? AND pml02=?"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
         CALL cl_parse_qry_sql(g_sql, l_pmk.pmkplant) RETURNING g_sql  #FUN-A50102          
         PREPARE pml_upd1 FROM g_sql
         EXECUTE pml_upd1 USING l_ruc.ruc02,l_ruc.ruc03
         IF STATUS THEN                                                                                                             
            CALL cl_err3("upd","pml_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1)                                                                                             
            EXIT FOREACH                                                                                                            
         END IF    
      END IF 
      INITIALIZE l_ruc.* TO NULL 
   END FOREACH                             
END FUNCTION
 
FUNCTION t500_PR() #請購單
DEFINE l_pmk RECORD LIKE pmk_file.*
DEFINE l_pml RECORD LIKE pml_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_dbs  LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_autoconfirm LIKE smy_file.smydmy4
DEFINE l_gec07 LIKE gec_file.gec07
DEFINE l_pml31 LIKE pml_file.pml31
DEFINE l_no     LIKE pmk_file.pmk01
DEFINE l_flag    LIKE type_file.num5
DEFINE l_fac     LIKE ima_file.ima31_fac
             
       LET l_sql = "SELECT DISTINCT rueplant,rue11,rue12,rue36 ",  #No.FUN-A10037
                   " FROM rue_file,rty_file ",
                   " WHERE rue01=? ",
                   #" AND rue14=? AND rue21>0 AND rue21 IS NOT NULL", #No.FUN-A10037
                   " AND rue21>0 AND rue21 IS NOT NULL",              #No.FUN-A10037
                   " AND rty01=rueplant AND rue05=rty02",
                   " AND rtyacti='Y' AND rty03<>'1'"
       PREPARE rue_pre3 FROM l_sql
       #EXECUTE rue_pre3 USING g_rud.rud01,'2' #No.FUN-A10037
       EXECUTE rue_pre3 USING g_rud.rud01      #No.FUN-A10037
       IF SQLCA.sqlcode=100 THEN
          RETURN
       END IF
       DECLARE rue_cs3 CURSOR FOR rue_pre3
       LET l_sql = " SELECT rue01,rue05,rue011,",
                   " rue15,rue17,rue21/rue27,rue26,rue28,rue13,",
                   " rue14,COALESCE(rue06,rue02),COALESCE(rue07,rue03),COALESCE(rue08,rue04) ",
                   " FROM rue_file,rty_file",
                   #" WHERE rue01=? AND rue14= ? ", #No.FUN-A10037
                   " WHERE rue01=?  ",              #No.FUN-A10037
                   " AND rue21>0 AND rue21 IS NOT NULL",
                   " AND COALESCE(rue11,'X') = COALESCE(?,'X')",
                   " AND COALESCE(rue12,'X') = COALESCE(?,'X')", 
                   " AND COALESCE(rue36,'X') = COALESCE(?,'X')",  #No.FUN-A10037 rue34-->rue36
                   " AND rty01=rueplant AND rue05 = rty02",
                   " AND rtyacti = 'Y' AND rty03 <> '1'"
       PREPARE rue_pre4 FROM l_sql
       DECLARE rue_cs4 CURSOR FOR rue_pre4             
 
       
       #FOREACH rue_cs3 USING g_rud.rud01,'2' #No.FUN-A10037
       FOREACH rue_cs3 USING g_rud.rud01      #No.FUN-A10037
                       INTO l_pmk.pmkplant,l_pmk.pmk47,l_pmk.pmk09,l_rue.rue36 #No.FUN-A10037
         IF STATUS THEN
            CALL s_errmsg('','','Foreach rue_cs3',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         IF l_rue.rue36 IS NULL THEN  #No.FUN-A10037 rue34-->rue36
            LET l_pmk.pmk02 = 'REG'	
         ELSE
            LET l_pmk.pmk02 = 'TAP'
         END IF
#機構DB               
         CALL t500_azp(l_pmk.pmkplant) RETURNING l_dbs    
#取默認單別arti099
         #LET l_sql = "SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file", #FUN-A50102
         #FUN-C90050 mark begin---
         #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_pmk.pmkplant, 'rye_file'), #FUN-A50102
         #            " WHERE rye01 = 'apm'",
         #            "   AND rye02 = '1'",
         #            "   AND ryeacti = 'Y'"
         #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
         #CALL cl_parse_qry_sql(l_sql, l_pmk.pmkplant) RETURNING l_sql  #FUN-A50102            
         #PREPARE rye_pr FROM l_sql
         #EXECUTE rye_pr INTO l_no
         #FUN-C90050 add end-----

         CALL s_get_defslip('apm','1',l_pmk.pmkplant,'N') RETURNING l_no   #FUN-C90050 add

         IF cl_null(l_no) THEN
            CALL s_errmsg('','','','art-330',1)
            LET g_success = 'N'
         END IF
#判斷是否直接審核
         #LET l_sql="SELECT smydmy4 FROM ",s_dbstring(l_dbs CLIPPED),"smy_file", #FUN-A50102
         LET l_sql="SELECT smydmy4 FROM ",cl_get_target_table(l_pmk.pmkplant, 'smy_file'), #FUN-A50102
                   " WHERE smyslip=?"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmk.pmkplant) RETURNING l_sql  #FUN-A50102          
         PREPARE smy_pr FROM l_sql
         EXECUTE smy_pr USING l_no INTO l_autoconfirm  
         IF l_autoconfirm = 'Y' THEN
            LET l_pmk.pmk25 = '1'
            LET l_pmk.pmk18 = 'Y'         #審核碼
            LET l_pmk.pmkcond = g_today
            LET l_pmk.pmkconu = g_user
            LET l_pmk.pmkcont = TIME
            LET l_pml.pml56 = '2'
         ELSE
            LET l_pmk.pmk25 = '0'
            LET l_pmk.pmk18 = 'N'         #審核碼
            LET l_pmk.pmkcond = ''
            LET l_pmk.pmkconu = ''
            LET l_pmk.pmkcont = ''
            LET l_pml.pml56='1'
         END IF
         
         CALL s_auto_assign_no("apm",l_no,g_today,"1","pmk_file","pmk01",l_pmk.pmkplant,"","")
             RETURNING li_result,l_pmk.pmk01
         IF (NOT li_result) THEN                                                                           
            LET g_success = 'N'            
            CALL s_errmsg('pmk01',l_pmk.pmk01,'','sub-145',1)
            CONTINUE FOREACH                                                         
         END IF
         SELECT pmc17,pmc49,pmc22,pmc47,COALESCE(gec04,0),gec07 
           INTO l_pmk.pmk20,l_pmk.pmk41,l_pmk.pmk22,l_pmk.pmk21,l_pmk.pmk43,l_gec07
           FROM pmc_file LEFT JOIN gec_file ON pmc47=gec01 AND gec011='1'
          WHERE pmc01 = l_pmk.pmk09 AND pmc05 = '1'
         IF g_aza.aza17 = l_pmk.pmk22 THEN
            LET l_pmk.pmk42 = 1
         ELSE
            CALL s_curr3(l_pmk.pmk22,g_today,g_sma.sma904) RETURNING l_pmk.pmk42
         END IF
         LET l_pmk.pmk48 = TIME
         SELECT azw02 INTO l_pmk.pmklegal FROM azw_file WHERE azw01 = l_pmk.pmkplant
       # INSERT INTO pmk_temp(pmk01,pmk46) VALUES(l_pmk.pmk01,'4')
         INSERT INTO pmk_temp(pmk01,pmk46,pmkplant,pmklegal) VALUES(l_pmk.pmk01,'4',g_plant,g_legal)  #TQC-A80037
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL s_errmsg('','','ins pmk_temp',SQLCA.sqlcode,1)
         END IF
         UPDATE pmk_temp SET pmk02 = l_pmk.pmk02,
                             pmk09 = l_pmk.pmk09,
                             pmkplant = l_pmk.pmkplant,
                             pmklegal = l_pmk.pmklegal,
                             pmk04 = g_today, #請購日期
                             pmk31 = (SELECT azn02 FROM azn_file WHERE azn01 = g_today), #會計年度	
                             pmk03 = 0,	
                             pmk12 = g_user,	
                             pmk13 = g_grup,    	
                             pmk20 = l_pmk.pmk20,#付款方式
                             pmk41 = l_pmk.pmk41,#價格條件
                             pmk21 = l_pmk.pmk21,#稅種
                             pmk22 = l_pmk.pmk22,#幣別	
                             pmk42 = l_pmk.pmk42,#匯率
                             pmk43 = l_pmk.pmk43,#稅率	
                             pmk25 = l_pmk.pmk25, 
                             pmk27 = g_today,
                             pmk30 = 'N',
                             pmk45 = 'Y',         #可用
                             pmk47 = l_pmk.pmk47,
                             pmkdays = 0,         #列印次數
                             pmkprno = 0,         #列印次數
                             pmksmax = 0,         #己簽順序
                             pmksseq = 0,         #應簽順序
                             pmkprsw = 'Y',
                             pmkmksg = 'N',
                             pmkacti ='Y',        #有效的資料
                             pmkuser = g_user,
                             pmkgrup = g_grup,    #使用者所屬群
                             pmkcrat = g_today,            
                             pmk18 = l_pmk.pmk18,
                             pmkcond = l_pmk.pmkcond,
                             pmkconu = l_pmk.pmkconu,
                             pmkcont = l_pmk.pmkcont,
                             pmk48 = l_pmk.pmk48
           WHERE pmk01 = l_pmk.pmk01                                   
         LET g_cnt=1
         #FOREACH rue_cs4 USING g_rud.rud01,'2',#No.FUN-A10037
         FOREACH rue_cs4 USING g_rud.rud01,     #No.FUN-A10037
                               l_pmk.pmk47,l_pmk.pmk09,l_rue.rue36  #No.FUN-A10037
                          INTO l_pml.pml24,l_pml.pml04,l_pml.pml25,
                               l_pml.pml08,l_pml.pml47,l_pml.pml20,
                               l_pml.pml07,l_pml31,l_pml.pml49,
                               l_pml.pml50,l_pml.pml51,l_pml.pml52,l_pml.pml53
            LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)    #FUN-910088--add--
            IF STATUS THEN
                LET g_success = 'N'
                CALL s_errmsg('','','Foreach rue_cs4',STATUS,1)
                CONTINUE FOREACH
            END IF              
                      
#            INSERT INTO pml_temp(pml01,pml02,pml42,pml49,pml50,pml54,pml56,pml91) #FUN-9B0023
#                          VALUES(l_pmk.pmk01,g_cnt,0,l_pml.pml49,l_pml.pml50,'2',l_pml.pml56,'N')  #FUN-9B0023
#           INSERT INTO pml_temp(pml01,pml02,pml42,pml49,pml50,pml54,pml56,pml91,pml92)                #FUN-9B0023 #TQC-A80037 mark
#                         VALUES(l_pmk.pmk01,g_cnt,0,l_pml.pml49,l_pml.pml50,'2',l_pml.pml56,'N','N')  #FUN-9B0023 #TQC-A80037 mark
            INSERT INTO pml_temp(pml01,pml02,pml42,pml49,pml50,pml54,pml56,pml91,pml92,pmlplant,pmllegal)                #FUN-9B0023 #TQC-A80037 add
                          VALUES(l_pmk.pmk01,g_cnt,0,l_pml.pml49,l_pml.pml50,'2',l_pml.pml56,'N','N',g_plant,g_legal)  #FUN-9B0023 #TQC-A80037 add
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               CALL s_errmsg('','','ins pml_temp',SQLCA.sqlcode,1)
            END IF
#            IF l_gec07 = 'Y' THEN
#               LET l_pml.pml31t = cl_digcut(l_pml31,t_azi03)   
#               LET l_pml.pml31 = l_pml.pml31t / ( 1 + l_pmk.pmk43 / 100)    
#               LET l_pml.pml31 = cl_digcut(l_pml.pml31,t_azi03)
#            ELSE
               LET l_pml.pml31 = cl_digcut(l_pml31,t_azi03)   
               LET l_pml.pml31t = l_pml.pml31 * ( 1 + l_pmk.pmk43 / 100)    
               LET l_pml.pml31t = cl_digcut(l_pml.pml31t,t_azi03)
#            END IF
            CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_pml.pml08) RETURNING l_flag,l_fac
            LET l_pml.pml09 = l_fac
            CALL s_overate(l_pml.pml04) RETURNING l_pml.pml13
            LET l_pml.pml14 =g_sma.sma886[1,1]         #部份交貨
            LET l_pml.pml15 =g_sma.sma886[2,2]         #部份交貨
            LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)   #FUN-910088--add--
            LET l_pml.pml88 =l_pml.pml31*l_pml.pml20
            LET l_pml.pml88t = l_pml.pml31t*l_pml.pml20
            LET l_pml.pml55 = TIME
           #MOD-B10164 Begin---
            SELECT rty12 INTO l_pml.pml191 FROM rty_file
             WHERE rty01=l_pmk.pmkplant
               AND rty02=l_pml.pml04
           #MOD-B10164 End-----
            UPDATE pml_temp SET pmlplant = l_pmk.pmkplant,
                                pmllegal = l_pmk.pmklegal,
                                pml24 = l_pml.pml24,
                                pml04 = l_pml.pml04,
                                pml25 = l_pml.pml25,
                                pml08 = l_pml.pml08,
                                pml47 = l_pml.pml47,
                                pml20 = l_pml.pml20,
                                pml07 = l_pml.pml07,
                                pml31t = l_pml.pml31t,
                                pml31 = l_pml.pml31,
                                pml48 = l_pmk.pmk09,
                                pml49 = l_pml.pml49,
                                pml50 = l_pml.pml50,
                                pml51 = l_pml.pml51,
                                pml52 = l_pml.pml52,
                                pml53 = l_pml.pml53,
                                pml16 = l_pmk.pmk25,
                                pml38 = 'Y',
                                pml01 = l_pmk.pmk01,
                                pml011 = l_pmk.pmk02,
                               #pml190 = 'N',          #MOD-B10164
                                pml190 = 'Y',          #MOD-B10164
                                pml191 = l_pml.pml191, #MOD-B10164
                                pml192 = 'N',
#TQC-B30162 --begin--
#                               pml33 = g_today,
#                               pml34 = g_today,
#                               pml35 = g_today,
                                pml33 = l_pml.pml33,
                                pml34 = l_pml.pml33,
                                pml35 = l_pml.pml33,
#TQC-B30162 --end--                                
                                pml11 = 'N',
                                pml041 = (SELECT ima02 FROM ima_file WHERE ima01 = l_pml.pml04),
                                pml21 = 0,
                                pml23 = 'Y',
                                pml30 = 0,
                                pml86 = l_pml.pml07,
                                pml87 = l_pml.pml20,
                                pml88 = l_pml.pml88,
                                pml88t = l_pml.pml88t,
                                pml55 = l_pml.pml55
                WHERE pml01 = l_pmk.pmk01 AND pml02 = g_cnt            
        LET g_cnt = g_cnt+1
        END FOREACH
         
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pml_file", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmk.pmkplant, 'pml_file'), #FUN-A50102
                    " SELECT * FROM pml_temp WHERE pml01 = ?"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmk.pmkplant) RETURNING l_sql  #FUN-A50102            
        PREPARE pml_ins FROM l_sql
        EXECUTE pml_ins USING l_pmk.pmk01
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('','','INSERT INTO pml_file:',SQLCA.sqlcode,1)
           CONTINUE FOREACH
        END IF           
        IF SQLCA.sqlerrd[3]<>0 THEN
           #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"pmk_file", #FUN-A50102
           LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmk.pmkplant, 'pmk_file'), #FUN-A50102
                       " SELECT * FROM pmk_temp WHERE pmk01 = ?"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
           CALL cl_parse_qry_sql(l_sql, l_pmk.pmkplant) RETURNING l_sql  #FUN-A50102
           PREPARE pmk_ins FROM l_sql
           EXECUTE pmk_ins USING l_pmk.pmk01
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL s_errmsg('','','INSERT INTO pmk_file:',SQLCA.sqlcode,1)
           END IF
        END IF
        IF l_autoconfirm='Y' AND g_success = 'Y' THEN  
           CALL t500_PR_trans(l_pmk.*,l_dbs)
        END IF
       END FOREACH
                      
END FUNCTION

FUNCTION t500_Transfer()#機構調撥單
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_ruo RECORD LIKE ruo_file.*
DEFINE l_rup RECORD LIKE rup_file.*
DEFINE l_sql STRING
DEFINE l_flag LIKE type_file.num5
DEFINE l_fac  LIKE ima_file.ima31_fac
DEFINE l_dbs LIKE azp_file.azp03
DEFINE li_result LIKE type_file.num5
DEFINE l_n   LIKE type_file.num5
DEFINE l_no  LIKE ruo_file.ruo01   #默認單別
DEFINE l_time LIKE ruo_file.ruo12t
DEFINE l_ruo01 LIKE ruo_file.ruo01
DEFINE l_azw02_1 LIKE azw_file.azw02  #TQC-B20003
DEFINE l_azw02_2 LIKE azw_file.azw02  #TQC-B20003
DEFINE l_sma142  LIKE sma_file.sma142 #TQC-B20004
DEFINE l_sma143  LIKE sma_file.sma143 #TQC-B20004
DEFINE l_ruo14   LIKE ruo_file.ruo14  #TQC-B20004
DEFINE l_imd20   LIKE imd_file.imd20  #TQC-B20004
 
    #No.FUN-A10037 ..begin
    #SELECT COUNT(*) INTO l_n
    #  FROM azp_file a,azp_file b,rue_file 
    # WHERE a.azp03 = b.azp03
    #   AND a.azp01 <> b.azp01
    #   AND a.azp01 = rue02
    #   AND b.azp01 = rue24
    #   AND rue01 = g_rud.rud01
    #   AND rue23 > 0 AND rue23 IS NOT NULL
    #TQC-B20003--mark--str--0216---
    #SELECT COUNT(*) INTO l_n
    #  FROM azw_file a,azw_file b,rue_file 
    # WHERE a.azw02 = b.azw02
    #   AND a.azw01 <> b.azw01
    #   AND a.azw01 = rue02
    #   AND b.azw01 = rue24
    #   AND rue01 = g_rud.rud01
    #   AND rue23 > 0 AND rue23 IS NOT NULL
    #TQC-B20003--mark--end--0216---
    #TQC-B20003--add--str--0216---
    SELECT COUNT(*) INTO l_n
      FROM rue_file
     WHERE rue01 = g_rud.rud01
       AND rue23 > 0 AND rue23 IS NOT NULL
    #TQC-B20003--add--end--0216---
    IF l_n = 0 THEN
       RETURN
    END IF
 
    DELETE FROM rue_temp
    DELETE FROM ruo_temp
    DELETE FROM rup_temp

    #No.FUN-A10037 ..begin
    #INSERT INTO rue_temp
    #SELECT rue_file.* 
    #  FROM azp_file a,azp_file b,rue_file 
    # WHERE a.azp03 = b.azp03
    #   AND a.azp01 <> b.azp01
    #   AND a.azp01 = rue02
    #   AND b.azp01 = rue24
    #   AND rue01 = g_rud.rud01
    #   AND rue23 > 0 AND rue23 IS NOT NULL
    #TQC-B20003--mark--str--0216---
    #INSERT INTO rue_temp
    #SELECT rue_file.* 
    #  FROM azw_file a,azw_file b,rue_file 
    # WHERE a.azw02 = b.azw02
    #   AND a.azw01 <> b.azw01
    #   AND a.azw01 = rue02
    #   AND b.azw01 = rue24
    #   AND rue01 = g_rud.rud01
    #   AND rue23 > 0 AND rue23 IS NOT NULL
    #TQC-B20003--mark--end--0216---
    #TQC-B20003--add--str--0216---
    INSERT INTO rue_temp
    SELECT rue_file.*
      FROM rue_file
     WHERE rue01 = g_rud.rud01
       AND rue23 > 0 AND rue23 IS NOT NULL
    #TQC-B20003--add--end--0216---
    #No.FUN-A10037 ..end
    #DECLARE rue_cs_1 CURSOR FOR SELECT DISTINCT rue02,rue11,rue24 FROM rue_temp
    DECLARE rue_cs_1 CURSOR FOR SELECT DISTINCT rue02,rue24,rue34 FROM rue_temp #TQC-B20003 0216
    
    #TQC-B20003--mark--str--0216---
    #LET l_sql  = "SELECT rue03,rue04,rue05,rue23",
    #             "  FROM rue_temp",
    #             " WHERE rue02 = ? ",
    #             "   AND rue11 = ? ",
    #             "   AND rue24 = ? "  
    #DECLARE rue_cs_2 CURSOR FROM l_sql
    #TQC-B20003--mark--end--0216---
 
    #FOREACH rue_cs_1 INTO l_rue.rue02,l_rue.rue11,l_rue.rue24
    FOREACH rue_cs_1 INTO l_rue.rue02,l_rue.rue24,l_rue.rue34 #TQC-B20003 0216
      #CALL t500_azp(l_rue.rue02) RETURNING l_dbs
      #IF NOT cl_null(g_errno) THEN
      #     LET g_success = 'N'
      #     CALL s_errmsg('','','',g_errno,1)
      #     EXIT FOREACH
      #END IF
#取默認單別arti099
      #LET l_sql="SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file", #FUN-A50102
      #LET l_sql="SELECT rye03 FROM ",cl_get_target_table(l_rue.rue02, 'rye_file'), #FUN-A50102
      #FUN-C90050 mark begin---
      #LET l_sql="SELECT rye03 FROM ",cl_get_target_table(l_rue.rue24, 'rye_file'),  #TQC-B20003 0216
      #          " WHERE rye01 = 'art'",
      #          "   AND rye02 = 'J1'",       #FUN-A70130
      #          "   AND ryeacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      ##CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql  #FUN-A50102          
      #CALL cl_parse_qry_sql(l_sql, l_rue.rue24) RETURNING l_sql   #TQC-B20003 0216
      #PREPARE rye_trans FROM l_sql
      #EXECUTE rye_trans INTO l_no
      #FUN-C90050 mark end------

      CALL s_get_defslip('art','J1',l_rue.rue24,'N') RETURNING l_no    #FUN-C90050 add

      IF cl_null(l_no) THEN
         LET g_success = 'N'
         CALL s_errmsg('rye03','F','Transfer','art-330',1)
         EXIT FOREACH
      END IF
#     CALL s_auto_assign_no("art",l_no,g_today,"F","ruo_file","ruo01",l_rue.rue02,"","") #FUN-A70130 mark
      #CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_rue.rue02,"","") #FUN-A70130 mod
      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_rue.rue24,"","")  #TQC-B20003 0216
          RETURNING li_result,l_ruo.ruo01
      IF (NOT li_result) THEN                                                                           
          LET g_success = 'N'
          CALL s_errmsg('','','','sub-145',1)
          EXIT FOREACH
      END IF
      LET l_time = TIME
      SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01 = l_rue.rue24
 
 #    INSERT INTO ruo_temp (ruo01,ruopos,ruoplant)VALUES(l_ruo.ruo01,'N',l_rue.rue24) # TQC-A80037 modify
      INSERT INTO ruo_temp (ruo01,ruopos,ruoplant,ruolegal)VALUES(l_ruo.ruo01,'N',l_rue.rue24,g_legal)# TQC-A80037 modify    
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ruoplant',l_rue.rue24,'ins ruo_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   
#TQC-B20003 --Begin
      SELECT azw02 INTO l_azw02_1
        FROM azw_file WHERE azw01 = l_rue.rue24
      SELECT azw02 INTO l_azw02_2
        FROM azw_file WHERE azw01 = l_rue.rue02
      IF l_azw02_1 <> l_azw02_2 THEN
         LET l_ruo.ruo901 = 'Y'
         LET l_ruo.ruo904 = l_rue.rue34
      ELSE
         LET l_ruo.ruo901 = 'N'
         LET l_ruo.ruo904 = NULL
      END IF
      #TQC-B20003 0216
      LET l_sql = "SELECT sma142,sma143 FROM ",cl_get_target_table(l_rue.rue24,'sma_file')
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_rue.rue24) RETURNING l_sql
      PREPARE sma_pre FROM l_sql
      EXECUTE sma_pre INTO l_sma142,l_sma143
      IF l_sma142 = 'Y' THEN   #在途管理
         IF l_sma143 = '1' THEN
            LET l_imd20 = l_rue.rue24
         ELSE
            LET l_imd20 = l_rue.rue02
         END IF
         LET l_sql = "SELECT imd01 FROM ",cl_get_target_table(l_imd20,'imd_file'),
                     " WHERE imd10 = 'W' AND imd22 = 'Y' ",
                     "   AND imd20 = '",l_imd20,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_imd20) RETURNING l_sql
         PREPARE imd01_pre FROM l_sql
         EXECUTE imd01_pre INTO l_ruo14
      ELSE
         LET l_ruo14 = NULL
      END IF
#TQC-B20003 --End
      UPDATE ruo_temp SET ruo02 = '2',
                          ruo03 = g_rud.rud01,
                          ruo04 = l_rue.rue24,
                          ruo05 = l_rue.rue02,
                          ruo06 = l_rue.rue11,
                          ruo07 = g_today,
                          ruo08 = g_user,
#                         ruo10 = g_today,  #TQC-B20003
#                         ruo11 = g_user,   #TQC-B20003 0216
#                         ruo12 = g_today,  #TQC-B20003
#                         ruo13 = g_user,   #TQC-B20003 0216
#                         ruoconf = '1',    #TQC-B20003
                          ruoconf = '0',    #TQC-B20003
                          ruo14 = l_ruo14,  #TQC-B20003
                          ruo15 = 'N',      #TQC-B20003 0216
                          ruouser = g_user,
                          ruogrup = g_grup,
                          ruocrat = g_today,
                          ruoacti = 'Y',
                          ruolegal = l_ruo.ruolegal,
                          ruo901  = l_ruo.ruo901, #TQC-B20003
                          ruo904  = l_ruo.ruo904  #TQC-B20003
#TQC-B20003 --Begin mark
#                         ruo10t = l_time,
#                         ruo12t = l_time
#TQC-B20003 --End mark
        WHERE ruo01 = l_ruo.ruo01
       LET g_cnt = 1
#TQC-B20003 add -- str--0216
       LET l_sql  = "SELECT rue03,rue04,rue05,rue23,rue011 ", #FUN-C90129 Add rue011
                    "  FROM rue_temp",
                    " WHERE rue02 = '",l_rue.rue02,"'",
                    "   AND rue24 = '",l_rue.rue24,"'"
       IF cl_null(l_rue.rue34) THEN
          LET l_sql = l_sql,"  AND rue34 IS NULL "  
       ELSE
          LET l_sql = l_sql,"  AND rue34 = '",l_rue.rue34,"'"
       END IF
       LET l_sql = l_sql CLIPPED," ORDER BY rue011 "          #FUN-C90129 Add
       DECLARE rue_cs_2 CURSOR FROM l_sql
       #TQC-B20003 add -- end--0216
       #FOREACH rue_cs_2 USING l_rue.rue02,l_rue.rue11,l_rue.rue24
       FOREACH rue_cs_2  #TQC-B20003 add 0216
                         INTO l_rue.rue03,l_rue.rue04,
                              l_rue.rue05,l_rue.rue23,l_rue.rue011 #FUN-C90129 Add rue011
          SELECT ima25 INTO l_rup.rup04
            FROM ima_file
           WHERE ima01 = l_rue.rue05
             AND imaacti = 'Y'      
          SELECT ruc11,ruc14,ruc16
            INTO l_rup.rup05,l_rup.rup06,l_rup.rup07
            FROM ruc_file
           WHERE ruc01 = l_rue.rue02
             AND ruc02 = l_rue.rue03
             AND ruc03 = l_rue.rue04
          CALL s_umfchk('',l_rup.rup04,l_rup.rup07) RETURNING l_flag,l_fac
          SELECT DISTINCT (SELECT rtz07 FROM rtz_file WHERE rtz01 = l_rue.rue02 ),
                          (SELECT rtz07 FROM rtz_file WHERE rtz01 = l_rue.rue24 )
            INTO l_rup.rup13,l_rup.rup09
            FROM azp_file
          SELECT COUNT(*) INTO l_n FROM rup_temp
           WHERE rup03 = l_rue.rue05
             AND rup01 = l_ruo.ruo01   #TQC-B20003 0216
             AND COALESCE(rup05,'X') = COALESCE(l_rup.rup05,'X')
             AND COALESCE(rup06,'X') = COALESCE(l_rup.rup06,'X')
             AND COALESCE(rup07,'X') = COALESCE(l_rup.rup07,'X')
          IF l_n>0 THEN
             UPDATE rup_temp SET rup12 = rup12 + l_rue.rue23,
                                 rup16 = rup16 + l_rue.rue23
              WHERE rup01 = l_ruo.ruo01 AND rup03 = l_rue.rue05
          ELSE
          #  INSERT INTO rup_temp (rup01,rup02,rupplant)VALUES(l_ruo.ruo01,g_cnt,l_rue.rue24)    #TQC-A80037 modify
          #  INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal)VALUES(l_ruo.ruo01,g_cnt,l_rue.rue24,g_legal) #TQC-A80037 modify   
            #INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17)VALUES(l_ruo.ruo01,g_cnt,l_rue.rue24,g_legal,0)  #MOD-AC0223 #FUN-C90129 Mark
            #INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17)VALUES(l_ruo.ruo01,g_cnt,l_rue.rue24,g_legal,l_rue.rue011)   #FUN-C90129 Add  #FUN-CC0057 mark
             INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17,rup22)VALUES(l_ruo.ruo01,g_cnt,l_rue.rue24,g_legal,l_rue.rue011,l_rue.rue02)        #FUN-CC0057 add
             IF SQLCA.sqlcode THEN
                LET g_success='N'
                CALL s_errmsg('','','ins rup_temp',SQLCA.sqlcode,1)
             END IF
             UPDATE rup_temp SET rup03 = l_rue.rue05,
                                 rup04 = l_rup.rup04,
                                 rup05 = l_rup.rup05,
                                 rup06 = l_rup.rup06,
                                 rup07 = l_rup.rup07,
                                 rup08 = l_fac,
                                 rup09 = l_rup.rup09,
                                 rup12 = l_rue.rue23,
                                 rup13 = l_rup.rup13,
                                 rup16 = l_rue.rue23,
                                 rup18 = 'N',        #TQC-B20003 0216
                                 ruplegal = l_ruo.ruolegal
               WHERE rup01 = l_ruo.ruo01 AND rup02 = g_cnt
              LET g_cnt = g_cnt + 1
           END IF         
        END FOREACH
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ruo_file SELECT * FROM ruo_temp WHERE ruo01 = ?" #FUN-A50102
        #LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue02, 'ruo_file')," SELECT * FROM ruo_temp WHERE ruo01 = ?" #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue24, 'ruo_file'),
                    " SELECT * FROM ruo_temp WHERE ruo01 = ?"       #TQC-B20003 0216
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                #FUN-A50102
        #CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql  #FUN-A50102 
        CALL cl_parse_qry_sql(l_sql, l_rue.rue24) RETURNING l_sql   #TQC-B20003 0216
        PREPARE ruo_ins FROM l_sql
        EXECUTE ruo_ins USING l_ruo.ruo01
     END FOREACH

      DECLARE ruo_temp_cs CURSOR FOR SELECT ruo01 FROM ruo_temp
      FOREACH ruo_temp_cs INTO l_ruo.ruo01
#撥出單
        SELECT ruo04,ruo05 INTO l_ruo.ruo04,l_ruo.ruo05 FROM ruo_temp WHERE ruo01=l_ruo.ruo01
#FUN-B20003 --Begin mark 無需庫存異動
#       #庫存異動
#       DECLARE rup_cs CURSOR FOR SELECT * FROM rup_temp WHERE rup01=l_ruo.ruo01
#       FOREACH rup_cs INTO l_rup.*
#          CALL t500_s1(l_rup.*)
#          IF g_success = 'N' THEN
#             CONTINUE FOREACH
#          END IF
#       END FOREACH
#       IF g_success = 'N' THEN
#          CONTINUE FOREACH
#       END IF
#TQC-B20003 --End mark
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rup_file ",        #FUN-A50102
        #LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue02, 'rup_file'), #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo04, 'rup_file'),  #TQC-B20003 0216
                    " SELECT * FROM rup_temp WHERE rup01=?"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        #CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql    #FUN-A50102            
        CALL cl_parse_qry_sql(l_sql,l_ruo.ruo04) RETURNING l_sql     #TQC-B20003 0216
        PREPARE rup_ins FROM l_sql
        EXECUTE rup_ins USING l_ruo.ruo01
#FUN-B20003 --Begin mark 無需庫存異動
#撥入單        
#       CALL t500_azp(l_ruo.ruo05) RETURNING l_dbs
#       IF NOT cl_null(g_errno) THEN
#          LET g_success = 'N'
#          CALL s_errmsg('','','',g_errno,1)
#          CONTINUE FOREACH
#       END IF
#       SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01=l_ruo.ruo05
#       UPDATE ruo_temp SET ruoplant = l_ruo.ruo05,
#                           ruolegal = l_ruo.ruolegal,
#                           ruoconf = '2'
#        WHERE ruo01 = l_ruo.ruo01
#       UPDATE rup_temp SET rupplant = l_ruo.ruo05,
#                           ruplegal = l_ruo.ruolegal
#        WHERE rup01 = l_ruo.ruo01
#       #庫存異動
#       DECLARE rup_cs1 CURSOR FOR SELECT * FROM rup_temp WHERE rupplant = l_ruo.ruo05
#       FOREACH rup_cs1 INTO l_rup.*
#          CALL t500_s2(l_rup.*)
#          IF g_success = 'N' THEN
#             CONTINUE FOREACH
#          END IF
#       END FOREACH
#       IF g_success = 'N' THEN
#          CONTINUE FOREACH
#       END IF
#       #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ruo_file ", #FUN-A50102
#       LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue02, 'ruo_file'), #FUN-A50102
#                   " SELECT ruo_temp.* FROM ruo_temp WHERE ruoplant=?"
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
#       CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql  #FUN-A50102            
#       PREPARE ruo_ins1 FROM l_sql
#       EXECUTE ruo_ins1 USING l_ruo.ruo05
#       #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rup_file ", #FUN-A50102
#       LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue02, 'rup_file'), #FUN-A50102
#                   " SELECT rup_temp.* FROM rup_temp WHERE rupplant=? "
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
#       CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql  #FUN-A50102            
#       PREPARE rup_ins1 FROM l_sql
#       EXECUTE rup_ins1 USING l_ruo.ruo05
#TQC-B20003 --End mark
      END FOREACH
END FUNCTION
 
#No.FUN-A10037 ..begin
FUNCTION t500_Transfer1()#機構調撥單
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_ruo RECORD LIKE ruo_file.*
DEFINE l_rup RECORD LIKE rup_file.*
DEFINE l_sql STRING
DEFINE l_flag LIKE type_file.num5
DEFINE l_fac  LIKE ima_file.ima31_fac
DEFINE l_dbs LIKE azp_file.azp03
DEFINE li_result LIKE type_file.num5
DEFINE l_n   LIKE type_file.num5
DEFINE l_no  LIKE ruo_file.ruo01   #默認單別
DEFINE l_time LIKE ruo_file.ruo12t
DEFINE l_ruo01 LIKE ruo_file.ruo01
DEFINE l_cnt   LIKE type_file.num5    #TQC-B20003
DEFINE l_azw02_1 LIKE azw_file.azw02  #TQC-B20003
DEFINE l_azw02_2 LIKE azw_file.azw02  #TQC-B20003
DEFINE l_sma142  LIKE sma_file.sma142 #TQC-B20004
DEFINE l_sma143  LIKE sma_file.sma143 #TQC-B20004
DEFINE l_ruo14   LIKE ruo_file.ruo14  #TQC-B20004
DEFINE l_imd20   LIKE imd_file.imd20  #TQC-B20004
 
#TQC-B20003 mark--str--0216
#    SELECT COUNT(*) INTO l_n 
#      FROM azw_file a,azw_file b,rue_file,rty_file
#     WHERE a.azw01 = rue02
#       AND a.azw02 = b.azw02
#       AND a.azw01 <> b.azw01
#       AND b.azw01 = rueplant
#       AND rue01 = g_rud.rud01
#       AND rue14 = '4'
#       AND rue21 > 0 AND rue21 IS NOT NULL
#       AND rty01=rueplant AND rue05=rty02
#       AND rtyacti='Y' AND rty03='1'
#TQC-B20003 mark--end--0216
#TQC-B20003 add--str--0216
    SELECT COUNT(*) INTO l_n
      FROM rue_file,rty_file
     WHERE rue01 = g_rud.rud01
       AND rue14 = '4'
       AND rue21 > 0 AND rue21 IS NOT NULL
       AND rty01=rueplant AND rue05=rty02
       AND rtyacti='Y' AND rty03='1'
#TQC-B20003 add--end--0216
    IF l_n = 0 THEN
       RETURN
    END IF
    DELETE FROM rue_temp
    DELETE FROM ruo_temp
    DELETE FROM rup_temp
 
#TQC-B20003 mark--str--0216
#    INSERT INTO rue_temp
#    SELECT DISTINCT rue_file.* 
#      FROM azw_file a,azw_file b,rue_file,rty_file
#     WHERE a.azw01 = rue02
#       AND a.azw02 = b.azw02
#       AND a.azw01 <> b.azw01
#       AND b.azw01 = rueplant
#       AND rue01 = g_rud.rud01
#       AND rue14 = '4'
#       AND rue21 > 0 AND rue21 IS NOT NULL
#       AND rty01=rueplant AND rue05=rty02
#       AND rtyacti='Y' AND rty03='1'
#TQC-B20003 mark--end--0216
#TQC-B20003 add--str--0216
     INSERT INTO rue_temp
     SELECT DISTINCT rue_file.*
       FROM rue_file,rty_file
      WHERE rue01 = g_rud.rud01
       AND rue14 = '4'
       AND rue21 > 0 AND rue21 IS NOT NULL
       AND rty01=rueplant AND rue05=rty02
       AND rtyacti='Y' AND rty03='1'
#TQC-B20003 add--end--0216
    #DECLARE rue_cs_11 CURSOR FOR SELECT DISTINCT rue02,rue11,rueplant FROM rue_temp
    DECLARE rue_cs_11 CURSOR FOR SELECT DISTINCT rue02,rueplant,rue36 FROM rue_temp  #TQC-B20003 0216
#TQC-B20003 mark--str--0216
#    LET l_sql  = "SELECT rue03,rue04,rue05,rue21",
#                 "  FROM rue_temp",
#                 " WHERE rue02 = ? ",
#                 "   AND rue11 = ? ",
#                 "   AND rueplant = ? "
#    DECLARE rue_cs_21 CURSOR FROM l_sql
#TQC-B20003 mark--end--0216
 
    #FOREACH rue_cs_11 INTO l_rue.rue02,l_rue.rue11,l_rue.rueplant
    FOREACH rue_cs_11 INTO l_rue.rue02,l_rue.rueplant,l_rue.rue36 #TQC-B20003 0216
      #CALL t500_azp(l_rue.rue02) RETURNING l_dbs
      #IF NOT cl_null(g_errno) THEN
      #     LET g_success = 'N'
      #     CALL s_errmsg('','','',g_errno,1)
      #     EXIT FOREACH
      #END IF
#取默認單別arti099
      #LET l_sql="SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file",         #FUN-A50102
      #LET l_sql="SELECT rye03 FROM ",cl_get_target_table(l_rue.rue02, 'rye_file'), #FUN-A50102
      #FUN-C90050 mark begin------
      #LET l_sql="SELECT rye03 FROM ",cl_get_target_table(l_rue.rueplant, 'rye_file'),      #TQC-B20003 0216
      #          " WHERE rye01 = 'art'",
      #          "   AND rye02 = 'J1'",              #FUN-A70130
      #          "   AND ryeacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      ##CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql    #FUN-A50102          
      #CALL cl_parse_qry_sql(l_sql, l_rue.rueplant) RETURNING l_sql  #TQC-B20003 0216
      #PREPARE rye_trans1 FROM l_sql
      #EXECUTE rye_trans1 INTO l_no
      #FUN-C90050 mark end-----

      CALL s_get_defslip('art','J1',l_rue.rueplant,'N') RETURNING l_no   #FUN-C90050 add

      IF cl_null(l_no) THEN
         LET g_success = 'N'
         CALL s_errmsg('rye03','F','Transfer','art-330',1)
         EXIT FOREACH
      END IF
#     CALL s_auto_assign_no("art",l_no,g_today,"F","ruo_file","ruo01",l_rue.rue02,"","")   #FUN-A70130 mark
      #CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_rue.rue02,"","") #FUN-A70130 mod
      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01",l_rue.rueplant,"","")  #TQC-B20003 0216
          RETURNING li_result,l_ruo.ruo01
      IF (NOT li_result) THEN                                                                           
          LET g_success = 'N'
          CALL s_errmsg('','','','sub-145',1)
          EXIT FOREACH
      END IF
      LET l_time = TIME
      SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01 = l_rue.rueplant
 
  #   INSERT INTO ruo_temp (ruo01,ruopos,ruoplant)VALUES(l_ruo.ruo01,'N',l_rue.rueplant) #TQC-A80037 modify
      INSERT INTO ruo_temp (ruo01,ruopos,ruoplant,ruolegal)VALUES(l_ruo.ruo01,'N',l_rue.rueplant,g_legal)# TQC-A80037 modify
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ruoplant',l_rue.rueplant,'ins ruo_temp',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
#TQC-B20003 --Begin
      SELECT azw02 INTO l_azw02_1
      #  FROM azw_file WHERE azw01 = l_rue.rue24
         FROM azw_file WHERE azw01 = l_rue.rueplant  #TQC-B20003 0216
      SELECT azw02 INTO l_azw02_2
        FROM azw_file WHERE azw01 = l_rue.rue02
      IF l_azw02_1 <> l_azw02_2 THEN
         LET l_ruo.ruo901 = 'Y'
         #LET l_ruo.ruo904 = l_rue.rue34
         LET l_ruo.ruo904 = l_rue.rue36  #TQC-B20003 0216
      ELSE
         LET l_ruo.ruo901 = 'N'
         LET l_ruo.ruo904 = NULL
      END IF
      LET l_sql = "SELECT sma142,sma143 FROM ",cl_get_target_table(l_rue.rueplant,'sma_file')
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_rue.rueplant) RETURNING l_sql
      PREPARE sma_pre1 FROM l_sql
      EXECUTE sma_pre1 INTO l_sma142,l_sma143
      IF l_sma142 = 'Y' THEN   #在途管理
         IF l_sma143 = '1' THEN
            LET l_imd20 = l_rue.rueplant
         ELSE
            LET l_imd20 = l_rue.rue02
         END IF
         LET l_sql = "SELECT imd01 FROM ",cl_get_target_table(l_imd20,'imd_file'),
                     " WHERE imd10 = 'W' AND imd22 = 'Y' ",
                     "   AND imd20 = '",l_imd20,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_imd20) RETURNING l_sql
         PREPARE imd01_pre1 FROM l_sql
         EXECUTE imd01_pre1 INTO l_ruo14
      ELSE
         LET l_ruo14 = NULL
      END IF 
#TQC-B20003 --End
      UPDATE ruo_temp SET ruo02 = '2',
                          ruo03 = g_rud.rud01,
                          ruo04 = l_rue.rueplant,
                          ruo05 = l_rue.rue02,
                          ruo06 = l_rue.rue11,
                          ruo07 = g_today,
                          ruo08 = g_user,
#                         ruo10 = g_today, #TQC-B20003
#                         ruo11 = g_user,  #TQC-B20003 0216
#                         ruo12 = g_today, #TQC-B20003
#                         ruo13 = g_user,  #TQC-B20003 0216
#                         ruoconf = '1',   #TQC-B20003
                          ruoconf = '0',   #TQC-B20003
                          ruo14 = l_ruo14, #TQC-B20003 0216
                          ruo15 = 'N',     #TQC-B20003 0216
                          ruouser = g_user,
                          ruogrup = g_grup,
                          ruocrat = g_today,
                          ruoacti = 'Y',
                          ruolegal = l_ruo.ruolegal,
                          ruo901  = l_ruo.ruo901, #TQC-B20003
                          ruo904  = l_ruo.ruo904  #TQC-B20003
#TQC-B20003 --Begin mark
#                         ruo10t = l_time,
#                         ruo12t = l_time
#TQC-B20003 --End mark
        WHERE ruo01 = l_ruo.ruo01
       LET g_cnt = 1
#TQC-B20003 add--str--0216
       LET l_sql  = "SELECT rue03,rue04,rue05,rue21,rue011 ", #FUN-C90129 Add rue011
                    "  FROM rue_temp",
                    " WHERE rue02 = '",l_rue.rue02,"'",
                    "   AND rueplant = '",l_rue.rueplant,"'"
       IF cl_null(l_rue.rue36) THEN
          LET l_sql = l_sql,"   AND rue36 IS NULL "
       ELSE
          LET l_sql = l_sql,"   AND rue36 = '",l_rue.rue36,"'"
       END IF
       LET l_sql = l_sql CLIPPED," ORDER BY rue011 "          #FUN-C90129 Add
       DECLARE rue_cs_21 CURSOR FROM l_sql                    #FUN-C90129 Mod
#TQC-B20003 add--end--0216
       #FOREACH rue_cs_21 USING l_rue.rue02,l_rue.rue11,l_rue.rueplant
       FOREACH rue_cs_21  #TQC-B20003 0216
                       INTO l_rue.rue03,l_rue.rue04,
                       #     l_rue.rue05,l_rue.rue23
                            l_rue.rue05,l_rue.rue21,l_rue.rue011   #TQC-B20003 0216 #FUN-C90129 Add rue011
         SELECT ima25 INTO l_rup.rup04
           FROM ima_file
          WHERE ima01 = l_rue.rue05
            AND imaacti = 'Y'      
         SELECT ruc11,ruc14,ruc16
           INTO l_rup.rup05,l_rup.rup06,l_rup.rup07
           FROM ruc_file
          WHERE ruc01 = l_rue.rue02
            AND ruc02 = l_rue.rue03
            AND ruc03 = l_rue.rue04
         CALL s_umfchk('',l_rup.rup04,l_rup.rup07) RETURNING l_flag,l_fac
         SELECT DISTINCT (SELECT rtz07 FROM rtz_file WHERE rtz01 = l_rue.rue02 ),
                         (SELECT rtz07 FROM rtz_file WHERE rtz01 = l_rue.rueplant )
           INTO l_rup.rup13,l_rup.rup09
           FROM azp_file
         SELECT COUNT(*) INTO l_n FROM rup_temp
          WHERE rup03 = l_rue.rue05
            AND rup01 = l_ruo.ruo01   #TQC-B20003 0216
            AND COALESCE(rup05,'X') = COALESCE(l_rup.rup05,'X')
            AND COALESCE(rup06,'X') = COALESCE(l_rup.rup06,'X')
            AND COALESCE(rup07,'X') = COALESCE(l_rup.rup07,'X')
         IF l_n>0 THEN
           #UPDATE rup_temp SET rup12 = rup12 + l_rue.rue23,          #TQC-C80103 mark
           #                    rup16 = rup16 + l_rue.rue23           #TQC-C80103 mark
            UPDATE rup_temp SET rup12 = rup12 + l_rue.rue21,          #TQC-C80103 add
                                rup16 = rup16 + l_rue.rue21           #TQC-C80103 add
             WHERE rup01 = l_ruo.ruo01 AND rup03 = l_rue.rue05
         ELSE
   #        INSERT INTO rup_temp (rup01,rup02,rupplant)VALUES(l_ruo.ruo01,g_cnt,l_rue.rueplant)    #TQC-A80037 modify
   #         INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal)VALUES(l_ruo.ruo01,g_cnt,l_rue.rueplant,g_legal) #TQC-A80037 modify    #TQC-AC0375 mark
            #INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17)VALUES(l_ruo.ruo01,g_cnt,l_rue.rueplant,g_legal,0)               #TQC-AC0375 #FUN-C90129 Mark
            #INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17)VALUES(l_ruo.ruo01,g_cnt,l_rue.rueplant,g_legal,l_rue.rue011)                #FUN-C90129 Add  #FUN-CC0057 mark
             INSERT INTO rup_temp (rup01,rup02,rupplant,ruplegal,rup17,rup22)VALUES(l_ruo.ruo01,g_cnt,l_rue.rueplant,g_legal,l_rue.rue011,l_rue.rue02)               #FUN-CC0057 add
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               CALL s_errmsg('','','ins rup_temp',SQLCA.sqlcode,1)
            END IF
#TQC-B20003 --Begin
            LET l_rup.rup10 = ' '
            LET l_rup.rup11 = ' '
            LET l_rup.rup14 = ' '
            LET l_rup.rup15 = ' '
#TQC-B20003 --End
            UPDATE rup_temp SET rup03 = l_rue.rue05,
                                rup04 = l_rup.rup04,
                                rup05 = l_rup.rup05,
                                rup06 = l_rup.rup06,
                                rup07 = l_rup.rup07,
                                rup08 = l_fac,
                                rup09 = l_rup.rup09,
#TQC-B20003 --Begin
                                rup10 = l_rup.rup10,
                                rup11 = l_rup.rup11,
                                rup14 = l_rup.rup14,
                                rup15 = l_rup.rup15,
#TQC-B20003 --End
                               #rup12 = l_rue.rue23,
                                rup12 = l_rue.rue21,  #TQC-B20003 0216
                                rup13 = l_rup.rup13,
                               #rup16 = l_rue.rue23,
                                rup18 = 'N',          #TQC-B20003 0216
                                rup16 = l_rue.rue21,  #TQC-B20003 0216
                                ruplegal = l_ruo.ruolegal
              WHERE rup01 = l_ruo.ruo01 AND rup02 = g_cnt
             LET g_cnt = g_cnt + 1
#FUN-B20003 --add --str--0216
#檢查撥入撥出倉儲批是否存在
        LET l_rup.rup03 = l_rue.rue05
        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rue.rueplant,'img_file'),
                    "  WHERE img01 = '",l_rup.rup03,"'",
                    "    AND img02 = '",l_rup.rup09,"'",
                    "    AND img03 = '",l_rup.rup10,"'",
                    "    AND img04 = '",l_rup.rup11,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_rue.rueplant) RETURNING l_sql
        PREPARE sel_img_cs FROM l_sql
        EXECUTE sel_img_cs INTO l_cnt
        IF l_cnt = 0 THEN
           CALL s_madd_img(l_rup.rup03,l_rup.rup09,l_rup.rup10,l_rup.rup11,l_ruo.ruo01,'',g_today,l_rue.rueplant)
        END IF
        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rue.rue02,'img_file'),
                    "  WHERE img01 = '",l_rup.rup03,"'",
                    "    AND img02 = '",l_rup.rup13,"'",
                    "    AND img03 = '",l_rup.rup14,"'",
                    "    AND img04 = '",l_rup.rup15,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_rue.rue02) RETURNING l_sql
        PREPARE sel_img_cs1 FROM l_sql
        EXECUTE sel_img_cs1 INTO l_cnt
        IF l_cnt = 0 THEN
           CALL s_madd_img(l_rup.rup03,l_rup.rup13,l_rup.rup14,l_rup.rup15,l_ruo.ruo01,'',g_today,l_rue.rue02)
        END IF
#FUN-B20003 --add--end-- 0216
          END IF         
        END FOREACH
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ruo_file SELECT * FROM ruo_temp WHERE ruo01 = ?" #FUN-A50102
        #LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue02, 'ruo_file')," SELECT * FROM ruo_temp WHERE ruo01 = ?" #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rueplant, 'ruo_file'),  #TQC-B20003 0216
                    " SELECT * FROM ruo_temp WHERE ruo01 = ?"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
        #CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql    #FUN-A50102 
        CALL cl_parse_qry_sql(l_sql, l_rue.rueplant) RETURNING l_sql     #TQC-B20003 0216
        PREPARE ruo_ins2 FROM l_sql
        EXECUTE ruo_ins2 USING l_ruo.ruo01
#FUN-B20003 mark --str--0216
#FUN-B20003 --Begin 
#檢查撥入撥出倉儲批是否存在
#        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_ruo.ruo04,'img_file'),
#                    "  WHERE img01 = '",l_rup.rup03,"'",
#                    "    AND img02 = '",l_rup.rup09,"'",
#                    "    AND img03 = '",l_rup.rup10,"'",
#                    "    AND img04 = '",l_rup.rup11,"'"
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql,l_ruo.ruo04) RETURNING l_sql
#        PREPARE sel_img_cs FROM l_sql
#        EXECUTE sel_img_cs INTO l_cnt
#        IF l_cnt = 0 THEN
#           CALL s_madd_img(l_rup.rup03,l_rup.rup09,l_rup.rup10,l_rup.rup11,l_ruo.ruo01,'',g_today,l_ruo.ruo04)
#        END IF
#        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_ruo.ruo05,'img_file'),
#                    "  WHERE img01 = '",l_rup.rup03,"'",
#                    "    AND img02 = '",l_rup.rup13,"'",
#                    "    AND img03 = '",l_rup.rup14,"'",
#                    "    AND img04 = '",l_rup.rup15,"'"
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql,l_ruo.ruo05) RETURNING l_sql
#        PREPARE sel_img_cs1 FROM l_sql
#        EXECUTE sel_img_cs1 INTO l_cnt
#        IF l_cnt = 0 THEN
#           CALL s_madd_img(l_rup.rup03,l_rup.rup13,l_rup.rup14,l_rup.rup15,l_ruo.ruo01,'',g_today,l_ruo.ruo05)
#        END IF
#FUN-B20003 --End
#FUN-B20003 mark --end--0216
      END FOREACH
      
      DECLARE ruo_temp_cs2 CURSOR FOR SELECT ruo01 FROM ruo_temp
      FOREACH ruo_temp_cs2 INTO l_ruo.ruo01
#撥出單
        SELECT ruo04,ruo05 INTO l_ruo.ruo04,l_ruo.ruo05 FROM ruo_temp WHERE ruo01=l_ruo.ruo01
#TQC-B20003 --Begin mark
#        #庫存異動
#        DECLARE rup_cs2 CURSOR FOR SELECT * FROM rup_temp WHERE rup01=l_ruo.ruo01
#        FOREACH rup_cs2 INTO l_rup.*
#           CALL t500_s1(l_rup.*)
#           IF g_success = 'N' THEN
#              CONTINUE FOREACH
#           END IF
#        END FOREACH
#        IF g_success = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#TQC-B20003 --End mark
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rup_file ", #FUN-A50102
         #LET l_sql = "INSERT INTO ",cl_get_target_table(l_rue.rue02, 'rup_file'), #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo04, 'rup_file'),  #TQC-B20003 0216
                     " SELECT * FROM rup_temp WHERE rup01=?"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
         #CALL cl_parse_qry_sql(l_sql, l_rue.rue02) RETURNING l_sql    #FUN-A50102            
         CALL cl_parse_qry_sql(l_sql, l_ruo.ruo04) RETURNING l_sql     #TQC-B20003 0216
         PREPARE rup_ins2 FROM l_sql
         EXECUTE rup_ins2 USING l_ruo.ruo01
#TQC-B20003 --Begin mark
##撥入單        
#        CALL t500_azp(l_ruo.ruo05) RETURNING l_dbs
#        IF NOT cl_null(g_errno) THEN
#           LET g_success = 'N'
#           CALL s_errmsg('','','',g_errno,1)
#           CONTINUE FOREACH
#        END IF
#        SELECT azw02 INTO l_ruo.ruolegal FROM azw_file WHERE azw01=l_ruo.ruo05
#        UPDATE ruo_temp SET ruoplant = l_ruo.ruo05,
#                            ruolegal = l_ruo.ruolegal,
#                            ruoconf = '2'
#         WHERE ruo01 = l_ruo.ruo01
#        UPDATE rup_temp SET rupplant = l_ruo.ruo05,
#                            ruplegal = l_ruo.ruolegal
#         WHERE rup01 = l_ruo.ruo01
#        #庫存異動
#        DECLARE rup_cs21 CURSOR FOR SELECT * FROM rup_temp WHERE rupplant = l_ruo.ruo05
#        FOREACH rup_cs21 INTO l_rup.*
#           CALL t500_s2(l_rup.*)
#           IF g_success = 'N' THEN
#              CONTINUE FOREACH
#           END IF
#        END FOREACH
#        IF g_success = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ruo_file ", #FUN-A50102
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo05, 'rup_file'), #FUN-A50102
#                    " SELECT ruo_temp.* FROM ruo_temp WHERE ruoplant=?"
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql, l_ruo.ruo05) RETURNING l_sql  #FUN-A50102            
#        PREPARE ruo_ins21 FROM l_sql
#        EXECUTE ruo_ins21 USING l_ruo.ruo05
#        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rup_file ", #FUN-A50102
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_ruo.ruo05, 'rup_file'), #FUN-A50102
#                    " SELECT rup_temp.* FROM rup_temp WHERE rupplant=? "
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
#        CALL cl_parse_qry_sql(l_sql, l_ruo.ruo05) RETURNING l_sql  #FUN-A50102            
#        PREPARE rup_ins21 FROM l_sql
#        EXECUTE rup_ins21 USING l_ruo.ruo05
#TQC-B20003 --End mark
       END FOREACH
END FUNCTION
#No.FUN-A10037 ..end
 
FUNCTION t500_transfer2() #集團調撥單
DEFINE l_sql STRING
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_tsk RECORD LIKE tsk_file.*
DEFINE l_tsl RECORD LIKE tsl_file.*
DEFINE l_dbs LIKE azp_file.azp03
DEFINE li_result LIKE type_file.num5
DEFINE l_no  LIKE tsk_file.tsk01
DEFINE l_n   LIKE type_file.num5
 
    #No.FUN-A10037 ...begin
    #SELECT COUNT(*) INTO l_n
    #  FROM azp_file a,azp_file b,rue_file
    # WHERE a.azp01 = rue02
    #   AND b.azp01 = rue24
    #   AND a.azp03 <> b.azp03
    #   AND rue01 = g_rud.rud01
    #   AND rue23 > 0 AND rue23 IS NOT NULL
    SELECT COUNT(*) INTO l_n 
      FROM azw_file a,azw_file b,rue_file
     WHERE a.azw01 = rue02
       AND b.azw01 = rue24
       AND a.azw02 <> b.azw02
       AND rue01 = g_rud.rud01
       AND rue23 > 0 AND rue23 IS NOT NULL
    #No.FUN-A10037 ...end
    IF l_n = 0 THEN
       RETURN 
    END IF
 
    INSERT INTO rue_temp2
    #No.FUN-A10037 ..begin
    #SELECT DISTINCT rue_file.* 
    #  FROM azp_file a,azp_file b,rue_file
    # WHERE a.azp01 = rue02
    #   AND b.azp01 = rue24
    #   AND a.azp03 <> b.azp03
    #   AND rue01 = g_rud.rud01
    #   AND rue23 > 0 AND rue23 IS NOT NULL
    SELECT DISTINCT rue_file.* 
      FROM azw_file a,azw_file b,rue_file
     WHERE a.azw01 = rue02
       AND b.azw01 = rue24
       AND a.azw02 <> b.azw02
       AND rue01 = g_rud.rud01
       AND rue23 > 0 AND rue23 IS NOT NULL
    #No.FUN-A10037 ..end
    DECLARE rue_cs7 CURSOR FOR SELECT DISTINCT rue02,rue24,rue34,rueplant FROM rue_temp2
    LET l_sql = "SELECT rue011,rue05,rue18,rue23 FROM rue_temp2",
                " WHERE rue02 = ? AND rue24 = ?",
                "   AND rue34 = ? AND rueplant = ?"
    PREPARE rue_cs8_pre FROM l_sql
    DECLARE rue_cs8 CURSOR FOR rue_cs8_pre
 
    FOREACH rue_cs7 INTO l_rue.rue02,l_rue.rue24,
                        l_rue.rue34,l_rue.rueplant
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rue_cs:',STATUS,1)
         EXIT FOREACH
      END IF
      CALL t500_azp(l_rue.rue24) RETURNING l_dbs
      IF NOT cl_null(g_errno) THEN
         CALL s_errmsg('','','',g_errno,1)
         LET g_success = 'N'
      END IF
      #取默認單別arti099
      #LET l_sql="SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file", #FUN-A50102

      #FUN-C90050 mark begin---
      #LET l_sql="SELECT rye03 FROM ",cl_get_target_table(l_rue.rue24, 'rye_file'), #FUN-A50102
      #          " WHERE rye01 = 'apm'",
      #          "   AND rye02 = '9'",
      #          "   AND ryeacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      #CALL cl_parse_qry_sql(l_sql, l_rue.rue24) RETURNING l_sql  #FUN-A50102          
      #PREPARE rye_trans2 FROM l_sql
      #EXECUTE rye_trans2 INTO l_no
      #FUN-C90050 mark end-----
    
      CALL s_get_defslip('apm','9',l_rue.rue24,'N')  RETURNING l_no   #FUN-C90050 add

      IF cl_null(l_no) THEN
         CALL s_errmsg('','','','art-330',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL s_auto_assign_no("apm",l_no,g_today,"9","tsk_file","tsk01",l_rue.rue24,"","")
         RETURNING li_result,l_tsk.tsk01
      IF (NOT li_result) THEN
          LET g_success = 'N'
          CALL s_errmsg('','','','asf-377',1)
          EXIT FOREACH
      END IF 
    # INSERT INTO tsk_temp(tsk01,tsk23)VALUES(l_tsk.tsk01,'2')  #TQC-A80037 modify
      INSERT INTO tsk_temp(tsk01,tsk23,tskplant,tsklegal)VALUES(l_tsk.tsk01,'2',g_plant,g_legal)  #TQC-A80037 modify
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins tsk_temp',SQLCA.sqlcode,1)
      END IF
      SELECT rtz07
        INTO l_tsk.tsk17
        FROM rtz_file 
       WHERE rtz01 = l_rue.rue02
      SELECT DISTINCT (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue34 AND poy02 = 0),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue34 AND poy02 = 1),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue34 AND poy02 = 2),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue34 AND poy02 = 3),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue34 AND poy02 = 4),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue34 AND poy02 = 5)
       INTO l_tsk.tsk11,l_tsk.tsk12,l_tsk.tsk13,l_tsk.tsk14,l_tsk.tsk16
       FROM poy_file
      SELECT azw02 INTO l_tsk.tsklegal FROM azw_file WHERE azw01 = l_rue.rue24
      UPDATE tsk_temp SET  tsk02 = g_today,
                           tsk03 = l_rue.rue02,
                           tsk05 = '1',
                           tsk07 = l_rue.rue34,
                           tsk08 = g_user,
                           tsk09 = g_grup,
                           tsk11 = l_tsk.tsk11,
                           tsk12 = l_tsk.tsk12,
                           tsk13 = l_tsk.tsk13,
                           tsk14 = l_tsk.tsk14,
                           tsk15 = l_tsk.tsk15,
                           tsk16 = l_tsk.tsk16,
                           tsk17 = l_tsk.tsk17,
                           tsk18 = g_today,
                           tsk19 = NULL,
                           tsk20 = '0',
                           tsk21 = 0,
                           tsk22 = 0,
                           tskuser = g_user,
                           tskgrup = g_grup,
                           tskdate = g_today,
                           tskacti = 'Y',
                           tsk24 = l_rue.rue02,
                           tsk25 = g_rud.rudplant,
                           tsk26 = g_rud.rud01,
                           tskplant = l_rue.rue24
      WHERE tsk01 = l_tsk.tsk01
    LET g_cnt = 1
    FOREACH rue_cs8 USING l_rue.rue02,l_rue.rue24,l_rue.rue34,l_rue.rueplant
                    INTO l_tsl.tsl13,l_tsl.tsl03,l_tsl.tsl04,l_tsl.tsl05
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rue_cs8:',STATUS,1)
         EXIT FOREACH
      END IF
      INSERT INTO tsl_temp(tsl01,tsl02,tsl03,tsl04,tsl05,tsl13,tslplant,tsllegal)
           VALUES(l_tsk.tsk01,g_cnt,l_tsl.tsl03,l_tsl.tsl04,l_tsl.tsl05,l_tsl.tsl13,l_rue.rue24,l_tsk.tsklegal)
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins tsl_temp',SQLCA.sqlcode,1)
      END IF
      LET g_cnt = g_cnt + 1
    END FOREACH
    END FOREACH
    DECLARE tsk_temp_cs CURSOR FOR SELECT tskplant FROM tsk_temp
    FOREACH tsk_temp_cs INTO l_tsk.tskplant
    #No.FUN-960130 ..begin
    #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_tsk.tskplant
    LET g_plant_new = l_tsk.tskplant
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra
    #No.FUN-960130 ..end
    #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tsk_file SELECT * FROM tsk_temp WHERE tskplant = ?" #FUN-A50102
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_tsk.tskplant, 'tsk_file')," SELECT * FROM tsk_temp WHERE tskplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_tsk.tskplant) RETURNING l_sql  #FUN-A50102
    PREPARE tsk_ins FROM l_sql
    EXECUTE tsk_ins USING l_tsk.tskplant
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL s_errmsg('','','INSERT INTO tsk_file:',SQLCA.sqlcode,1)
    END IF
    #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tsl_file SELECT * FROM tsl_temp WHERE tslplant = ?" #FUN-A50102
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_tsk.tskplant, 'tsl_file')," SELECT * FROM tsl_temp WHERE tslplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_tsk.tskplant) RETURNING l_sql  #FUN-A50102
    PREPARE tsl_ins FROM l_sql
    EXECUTE tsl_ins USING l_tsk.tskplant
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL s_errmsg('','','INSERT INTO tsl_file:',SQLCA.sqlcode,1)
    END IF
    END FOREACH
END FUNCTION
#No.FUN-A10037 ...begin
FUNCTION t500_transfer4() #集團調撥單
DEFINE l_sql STRING
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_tsk RECORD LIKE tsk_file.*
DEFINE l_tsl RECORD LIKE tsl_file.*
DEFINE l_dbs LIKE azp_file.azp03
DEFINE li_result LIKE type_file.num5
DEFINE l_no  LIKE tsk_file.tsk01
DEFINE l_n   LIKE type_file.num5
 
    SELECT COUNT(*) INTO l_n 
      FROM azw_file a,azw_file b,rue_file,rty_file
     WHERE a.azw01 = rue02
       AND a.azw02 <> b.azw02
       AND b.azw01 = rueplant
       AND rue01 = g_rud.rud01
       AND rue14 = '4'
       AND rue21 > 0 AND rue21 IS NOT NULL
       AND rty01=rueplant AND rue05=rty02
       AND rtyacti='Y' AND rty03='1'
    IF l_n = 0 THEN
       RETURN 
    END IF
    DELETE FROM rue_temp2
    DELETE FROM tsk_temp
    DELETE FROM tsl_temp
 
    INSERT INTO rue_temp2
    SELECT DISTINCT rue_file.* 
      FROM azw_file a,azw_file b,rue_file,rty_file
     WHERE a.azw01 = rue02
       AND a.azw02 <> b.azw02
       AND b.azw01 = rueplant
       AND rue01 = g_rud.rud01
       AND rue14 = '4'
       AND rue21 > 0 AND rue21 IS NOT NULL 
       AND rty01=rueplant AND rue05=rty02
       AND rtyacti='Y' AND rty03='1'
    DECLARE rue_cs71 CURSOR FOR SELECT DISTINCT rue02,rue36,rueplant FROM rue_temp2
    LET l_sql = "SELECT rue011,rue05,rue18,rue21 FROM rue_temp2",
                " WHERE rue02 = ? ",
                "   AND rue36 = ? AND rueplant = ?"
    PREPARE rue_cs81_pre FROM l_sql
    DECLARE rue_cs81 CURSOR FOR rue_cs81_pre
 
    FOREACH rue_cs71 INTO l_rue.rue02,
                        l_rue.rue36,l_rue.rueplant
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rue_cs:',STATUS,1)
         EXIT FOREACH
      END IF
      CALL t500_azp(l_rue.rueplant) RETURNING l_dbs
      IF NOT cl_null(g_errno) THEN
         CALL s_errmsg('','','',g_errno,1)
         LET g_success = 'N'
      END IF
      #取默認單別arti099
      #LET l_sql="SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file", #FUN-A50102
      #FUN-C90050 mark begin---
      #LET l_sql="SELECT rye03 FROM ",cl_get_target_table(l_rue.rueplant, 'rye_file'), #FUN-A50102
      #          " WHERE rye01 = 'apm'",
      #          "   AND rye02 = '9'",
      #          "   AND ryeacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      #CALL cl_parse_qry_sql(l_sql, l_rue.rueplant) RETURNING l_sql  #FUN-A50102          
      #PREPARE rye_trans21 FROM l_sql
      #EXECUTE rye_trans21 INTO l_no
      #FUN-C90050 mark end------

      CALL s_get_defslip('apm','9',l_rue.rueplant,'N') RETURNING l_no    #FUN-C90050 add

      IF cl_null(l_no) THEN
         CALL s_errmsg('','','','art-330',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL s_auto_assign_no("apm",l_no,g_today,"9","tsk_file","tsk01",l_rue.rueplant,"","")
         RETURNING li_result,l_tsk.tsk01
      IF (NOT li_result) THEN
          LET g_success = 'N'
          CALL s_errmsg('','','','asf-377',1)
          EXIT FOREACH
      END IF 
    # INSERT INTO tsk_temp(tsk01,tsk23)VALUES(l_tsk.tsk01,'2')  #TQC-A80037 modify
      INSERT INTO tsk_temp(tsk01,tsk23,tskplant,tsklegal)VALUES(l_tsk.tsk01,'2',g_plant,g_legal)  #TQC-A80037 modify
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins tsk_temp',SQLCA.sqlcode,1)
      END IF
      SELECT rtz07
        INTO l_tsk.tsk17
        FROM rtz_file 
       WHERE rtz01 = l_rue.rue02
      SELECT DISTINCT (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue36 AND poy02 = 0),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue36 AND poy02 = 1),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue36 AND poy02 = 2),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue36 AND poy02 = 3),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue36 AND poy02 = 4),
                      (SELECT poy03 FROM poy_file WHERE poy01 = l_rue.rue36 AND poy02 = 5)
       INTO l_tsk.tsk11,l_tsk.tsk12,l_tsk.tsk13,l_tsk.tsk14,l_tsk.tsk16
       FROM poy_file
      SELECT azw02 INTO l_tsk.tsklegal FROM azw_file WHERE azw01 = l_rue.rueplant
      UPDATE tsk_temp SET  tsk02 = g_today,
                           tsk03 = l_rue.rue02,
                           tsk05 = '1',
                           tsk07 = l_rue.rue36,
                           tsk08 = g_user,
                           tsk09 = g_grup,
                           tsk11 = l_tsk.tsk11,
                           tsk12 = l_tsk.tsk12,
                           tsk13 = l_tsk.tsk13,
                           tsk14 = l_tsk.tsk14,
                           tsk15 = l_tsk.tsk15,
                           tsk16 = l_tsk.tsk16,
                           tsk17 = l_tsk.tsk17,
                           tsk18 = g_today,
                           tsk19 = NULL,
                           tsk20 = '0',
                           tsk21 = 0,
                           tsk22 = 0,
                           tskuser = g_user,
                           tskgrup = g_grup,
                           tskdate = g_today,
                           tskacti = 'Y',
                           tsk24 = l_rue.rue02,
                           tsk25 = g_rud.rudplant,
                           tsk26 = g_rud.rud01,
                           tskplant = l_rue.rueplant
      WHERE tsk01 = l_tsk.tsk01
    LET g_cnt = 1
    FOREACH rue_cs81 USING l_rue.rue02,l_rue.rue36,l_rue.rueplant
                    INTO l_tsl.tsl13,l_tsl.tsl03,l_tsl.tsl04,l_tsl.tsl05
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rue_cs81:',STATUS,1)
         EXIT FOREACH
      END IF
      INSERT INTO tsl_temp(tsl01,tsl02,tsl03,tsl04,tsl05,tsl13,tslplant,tsllegal)
           VALUES(l_tsk.tsk01,g_cnt,l_tsl.tsl03,l_tsl.tsl04,l_tsl.tsl05,l_tsl.tsl13,l_rue.rueplant,l_tsk.tsklegal)
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins tsl_temp',SQLCA.sqlcode,1)
      END IF
      LET g_cnt = g_cnt + 1
    END FOREACH
    END FOREACH
    DECLARE tsk_temp_cs2 CURSOR FOR SELECT tskplant FROM tsk_temp
    FOREACH tsk_temp_cs2 INTO l_tsk.tskplant
    #No.FUN-960130 ..begin
    #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_tsk.tskplant
    LET g_plant_new = l_tsk.tskplant
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra
    #No.FUN-960130 ..end
    #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tsk_file SELECT * FROM tsk_temp WHERE tskplant = ?" #FUN-A50102
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_tsk.tskplant, 'tsk_file')," SELECT * FROM tsk_temp WHERE tskplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_rue.rueplant) RETURNING l_sql  #FUN-A50102
    PREPARE tsk_ins2 FROM l_sql
    EXECUTE tsk_ins2 USING l_tsk.tskplant
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL s_errmsg('','','INSERT INTO tsk_file:',SQLCA.sqlcode,1)
    END IF
    #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tsl_file SELECT * FROM tsl_temp WHERE tslplant = ?" #FUN-A50102
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_tsk.tskplant, 'tsl_file')," SELECT * FROM tsl_temp WHERE tslplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_rue.rueplant) RETURNING l_sql  #FUN-A50102
    PREPARE tsl_ins2 FROM l_sql
    EXECUTE tsl_ins2 USING l_tsk.tskplant
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL s_errmsg('','','INSERT INTO tsl_file:',SQLCA.sqlcode,1)
    END IF
    END FOREACH
END FUNCTION
#No.FUN-A10037 ...end
 
FUNCTION t500_update() #更新需求匯總表
DEFINE l_rue RECORD LIKE rue_file.*
DEFINE l_ruc22 LIKE ruc_file.ruc22
DEFINE l_ruc21 LIKE ruc_file.ruc21
DEFINE l_ruc19 LIKE ruc_file.ruc19
DEFINE l_ruc18 LIKE ruc_file.ruc18
    
    LET g_sql="SELECT rue00,rue02,rue03,rue04,",
              "rue21,rue23,rue25",
              " FROM rue_file ",
              "WHERE rue01 = '",g_rud.rud01,"'"
    DECLARE rue_sel CURSOR FROM g_sql
    FOREACH rue_sel INTO l_rue.rue00,l_rue.rue02,l_rue.rue03,
                         l_rue.rue04,
                         l_rue.rue21,l_rue.rue23,l_rue.rue25
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach rue_sel:',STATUS,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_rue.rue21) THEN LET l_rue.rue21=0 END IF
      IF cl_null(l_rue.rue23) THEN LET l_rue.rue23=0 END IF
      LET l_ruc22 = ''
      SELECT ruc18,ruc19,ruc21 INTO l_ruc18,l_ruc19,l_ruc21
        FROM ruc_file
       WHERE ruc00 = l_rue.rue00
         AND ruc01 = l_rue.rue02
         AND ruc02 = l_rue.rue03
         AND ruc03 = l_rue.rue04
         #AND rucplant = l_rue.rue02  #No.FUN-9C0069
      IF l_ruc18 = (l_ruc19+l_ruc21)+(l_rue.rue21 + l_rue.rue23) THEN
            LET l_ruc22 = '6'
      END IF
      IF l_ruc18 < (l_ruc19+l_ruc21)+(l_rue.rue21 + l_rue.rue23) THEN
            LET l_ruc22 = '7'
      END IF
      IF l_ruc18 > (l_ruc19+l_ruc21)+(l_rue.rue21 + l_rue.rue23) THEN
         IF l_rue.rue25 = 'Y' THEN
             LET l_ruc22 = '8'
         END IF
      END IF
      UPDATE ruc_file SET ruc19 = COALESCE(ruc19,0) + l_rue.rue21,
                          ruc21 = COALESCE(ruc21,0) + l_rue.rue23,
                          ruc22 = l_ruc22
       WHERE ruc00 = l_rue.rue00
         AND ruc01 = l_rue.rue02
         AND ruc02 = l_rue.rue03
         AND ruc03 = l_rue.rue04
         #AND rucplant = l_rue.rue02 #No.FUN-9C0069
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL s_errmsg('','','UPDATE ruc_file:',SQLCA.sqlcode,1)
       END IF
     END FOREACH
END FUNCTION
 
#撥入異動庫存copy and modify from artt256
FUNCTION t500_s2(l_rup)
DEFINE l_rup RECORD LIKE rup_file.*
DEFINE l_qty     LIKE rup_file.rup16
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE g_img RECORD LIKE img_file.*
 
       CALL t500_azp(l_rup.rupplant) RETURNING l_dbs
       IF NOT cl_null(g_errno) THEN
          LET g_success = 'N'
          CALL s_errmsg('','','',g_errno,1)
       END IF
       #LET g_sql = " SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
       LET g_sql = " SELECT * FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                   "  WHERE img01= ? ",
                   "    AND img02= ? ",
                   "    AND img03= ' ' ",
                   "    AND img04= ' ' ",
                   " FOR UPDATE "
       LET g_sql = cl_forupd_sql(g_sql)

       DECLARE img_lock_bu1 CURSOR FROM g_sql
       OPEN img_lock_bu1 USING l_rup.rup03,l_rup.rup13
       FETCH img_lock_bu1 INTO g_img.*
       IF cl_null(g_img.img01) THEN
          CALL s_madd_img(l_rup.rup03,l_rup.rup13,'','',l_rup.rup01,
                          l_rup.rup02,g_today,l_rup.rupplant)
       END IF
       IF g_success='Y' THEN
       LET l_qty = l_rup.rup16*l_rup.rup08
       CALL s_mupimg(+1,l_rup.rup03,l_rup.rup13,'','',l_qty,g_today,l_rup.rupplant,'',l_rup.rup01,l_rup.rup02)
       IF g_success = 'Y' THEN
          CALL t500_in_log(l_rup.*,l_dbs)
       END IF
       END IF
END FUNCTION
 
FUNCTION t500_in_log(l_rup,l_dbs)
DEFINE l_rup       RECORD LIKE rup_file.*
DEFINE l_dbs       LIKE azp_file.azp03
DEFINE l_img09     LIKE img_file.img09,                                                                        
       l_img10     LIKE img_file.img10,                                                                        
       l_img26     LIKE img_file.img26
 
    LET g_sql = "SELECT img09,img10,img26 ",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
                "  FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                " WHERE img01 = '",l_rup.rup03,
                "'  AND img02 = '",l_rup.rup13,
                "'  AND img03 = ' ' AND img04 = ' '"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, l_rup.rupplant) RETURNING g_sql  #FUN-A50102            
    PREPARE img_sel FROM g_sql
    EXECUTE img_sel INTO l_img09,l_img10,l_img26
    IF SQLCA.sqlcode THEN
       CALL s_errmsg("rup03",l_rup.rup03,"sel img_file",SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
    END IF
    INITIALIZE g_tlf.* TO NULL
    LET g_tlf.tlf01 = l_rup.rup03
    LET g_tlf.tlf020 = g_plant
    LET g_tlf.tlf02 = 57
    LET g_tlf.tlf021 = l_rup.rup09
    LET g_tlf.tlf022 = l_rup.rup10
    LET g_tlf.tlf023 = l_rup.rup11
    LET g_tlf.tlf024 = l_img10
    LET g_tlf.tlf025 = l_rup.rup04
    LET g_tlf.tlf026 = l_rup.rup01
    LET g_tlf.tlf027 = l_rup.rup02
    LET g_tlf.tlf03 = 50 
    LET g_tlf.tlf031 = l_rup.rup13
    LET g_tlf.tlf032 = l_rup.rup14
    LET g_tlf.tlf033 = l_rup.rup15
    LET g_tlf.tlf035 = l_rup.rup04
    LET g_tlf.tlf036 = l_rup.rup01 
    LET g_tlf.tlf037 = l_rup.rup02
    LET g_tlf.tlf04 = ' '                                                                                   
    LET g_tlf.tlf05 = ' '
    LET g_tlf.tlf06 = g_today
    LET g_tlf.tlf07 = g_today
    LET g_tlf.tlf08 = TIME
    LET g_tlf.tlf09 = g_user
    LET g_tlf.tlf10 = l_rup.rup16
    LET g_tlf.tlf11 = l_rup.rup04
    LET g_tlf.tlf12 = l_rup.rup08
    LET g_tlf.tlf13 = 'artt500'
    LET g_tlf.tlf15 = l_img26
    LET g_tlf.tlf60 = l_rup.rup08
    LET g_tlf.tlfplant = l_rup.rupplant
    LET g_tlf.tlflegal = l_rup.ruplegal
    LET g_tlf.tlf902 = l_rup.rup13
    LET g_tlf.tlf903 = ' '
    LET g_tlf.tlf904 = ' '
    LET g_tlf.tlf905 = l_rup.rup01
    LET g_tlf.tlf906 = l_rup.rup02
    LET g_tlf.tlf907 = 1
    CALL s_tlf2(1,0,l_rup.rupplant)
END FUNCTION
 
#撥出異動庫存
FUNCTION t500_s1(l_rup)
DEFINE   l_rup     RECORD LIKE rup_file.*
DEFINE   l_qty     LIKE rup_file.rup12
DEFINE   l_img10   LIKE img_file.img10
DEFINE   l_dbs     LIKE azp_file.azp03
DEFINE   g_img   RECORD LIKE img_file.*
 
    CALL t500_azp(l_rup.rupplant) RETURNING l_dbs
    IF NOT cl_null(g_errno) THEN
       LET g_success = 'N'
       CALL s_errmsg('','','',g_errno,1)
    END IF
    #LET g_sql = " SELECT * FROM ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
    LET g_sql = " SELECT * FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                  "  WHERE img01= ? ",
                  "    AND img02= ? ",
                  "    AND img03= ' ' ",
                  "    AND img04= ' ' ", " FOR UPDATE "
    LET g_sql = cl_forupd_sql(g_sql)

      DECLARE img_lock_bu CURSOR FROM g_sql
      OPEN img_lock_bu USING l_rup.rup03,l_rup.rup09
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('','','img_lock_bu fail',STATUS,1)
         CLOSE img_lock_bu
      END IF
      FETCH img_lock_bu INTO g_img.*
      IF STATUS THEN
         LET g_success = 'N'
         CALL s_errmsg('img01',l_rup.rup03,"SELECT img_file:",'art-502', 1)
      END IF
      IF g_success = 'Y' THEN
      LET l_qty = l_rup.rup12*l_rup.rup08
      CALL s_mupimg(-1,l_rup.rup03,l_rup.rup09,'','',l_qty,g_today,l_rup.rupplant,'',l_rup.rup01,l_rup.rup02)
      IF g_success = 'Y' THEN
#--------產生異動記錄 
         CALL t500_out_log(l_rup.*,l_dbs)
      END IF
      END IF
END FUNCTION
 
FUNCTION t500_out_log(l_rup,l_dbs)
DEFINE l_rup       RECORD LIKE rup_file.*
DEFINE l_dbs       LIKE azp_file.azp03
DEFINE l_img09     LIKE img_file.img09,       #庫存單位                                                                           
       l_img10     LIKE img_file.img10,       #庫存數量                                                                           
       l_img26     LIKE img_file.img26
 
    LET g_sql = "SELECT img09,img10,img26",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "  FROM ",cl_get_target_table(l_rup.rupplant, 'img_file'), #FUN-A50102
                " WHERE img01 = '",l_rup.rup03,
                "'  AND img02 = '",l_rup.rup09,
                "'  AND img03 = ' ' AND img04 = ' '"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(g_sql, l_rup.rupplant) RETURNING g_sql  #FUN-A50102            
    PREPARE img_sel1 FROM g_sql
    EXECUTE img_sel1 INTO l_img09,l_img10,l_img26
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('rup03',l_rup.rup03,"sel img_file",SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
    INITIALIZE g_tlf.* TO NULL
 
    LET g_tlf.tlf01 = l_rup.rup03      #異動料件編號
    LET g_tlf.tlf020 = g_plant         #機構別
    LET g_tlf.tlf02 = 50               #來源狀況
    LET g_tlf.tlf021 = l_rup.rup09     #倉庫(來源）
    LET g_tlf.tlf022 = l_rup.rup10     #儲位(來源）
    LET g_tlf.tlf023 = l_rup.rup11     #批號(來源）
    LET g_tlf.tlf024 = l_img10         #異動後庫存數量
    LET g_tlf.tlf025 = l_rup.rup04     #庫存單位
    LET g_tlf.tlf026 = l_rup.rup01     #單據號碼
    LET g_tlf.tlf027 = l_rup.rup02     #單據項次
    LET g_tlf.tlf03 = 66               #資料目的
    LET g_tlf.tlf031 = l_rup.rup13     #倉庫(目的)
    LET g_tlf.tlf032 = l_rup.rup14     #儲位(目的)
    LET g_tlf.tlf033 = l_rup.rup15     #批號(目的)
    LET g_tlf.tlf035 = l_rup.rup04     #庫存單位
    LET g_tlf.tlf036 = l_rup.rup01     #參考號碼
    LET g_tlf.tlf037 = l_rup.rup02     #單據項次
    LET g_tlf.tlf04 = ' '              #工作站                                                                                    
    LET g_tlf.tlf05 = ' '              #作業序號
    LET g_tlf.tlf06 = g_today          #日期
    LET g_tlf.tlf07 = g_today          #異動資料產生日期
    LET g_tlf.tlf08 = TIME             #異動資料產生時:分:秒
    LET g_tlf.tlf09 = g_user           #產生人
    LET g_tlf.tlf10 = l_rup.rup12      #收料數量
    LET g_tlf.tlf11 = l_rup.rup04      #收料單位 
    LET g_tlf.tlf12 = l_rup.rup08      #收料/庫存轉換率
    LET g_tlf.tlf13 = 'artt500'        #異動命令代號
    LET g_tlf.tlf15 = l_img26          #倉儲會計科目
    LET g_tlf.tlf60 = l_rup.rup08      #異動單據單位對庫存單位之換算率
    LET g_tlf.tlfplant = l_rup.rupplant
    LET g_tlf.tlflegal = l_rup.ruplegal
    LET g_tlf.tlf902 = l_rup.rup09
    LET g_tlf.tlf903 = ' '
    LET g_tlf.tlf904 = ' '
    LET g_tlf.tlf905 = l_rup.rup01
    LET g_tlf.tlf906 = l_rup.rup02     
    LET g_tlf.tlf907 = -1
    CALL s_tlf2(1,0,l_rup.rupplant)
END FUNCTION
 
FUNCTION t500_azp(l_azp01)
   DEFINE l_azp01  LIKE azp_file.azp01,
          l_azp03  LIKE azp_file.azp03
 
    LET g_errno=' '
    #No.FUN-960130 ..begin
    #SELECT azp03 INTO l_azp03 FROM azp_file 
    # WHERE azp01=l_azp01
    LET g_plant_new = l_azp01
    CALL s_gettrandbs()
    LET l_azp03=g_dbs_tra
    #No.FUN-960130 ..end
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-025'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_azp03 CLIPPED
END FUNCTION
#FUN-870007
#TQC-AC0383

#TQC-B10151-----begin--------------------------------------------------------
FUNCTION t500_compentry_rue34()
DEFINE   l_n      LIKE type_file.num5

#MOD-B20140 -- mark -- str --
#     SELECT COUNT(*) INTO l_n FROM azp_file a,azp_file b
#      WHERE a.azp03 = b.azp03
#        AND a.azp01 = g_rue[l_ac].rue02
#        AND b.azp01 = g_rue[l_ac].rue24
#MOD-B20140 -- mark -- end --
#MOD-B20140 -- add -- str --
     SELECT COUNT(*) INTO l_n  FROM azw_file a,azw_file b
      WHERE a.azw02 = b.azw02               #法人
        AND a.azw01 = g_rue[l_ac].rue02
        AND b.azw01 = g_rue[l_ac].rue24
#MOD-B20140 -- add -- end --
     IF l_n = 0 AND g_rue[l_ac].rue23 >0 THEN 
        CALL cl_set_comp_entry('rue34',TRUE)
        CALL cl_set_comp_required("rue34",TRUE)
     END IF

END FUNCTION

FUNCTION t500_compentry_rue36()

     IF g_rue[l_ac].rue21 >0 THEN
        CALL cl_set_comp_entry('rue36',TRUE)
     ELSE
        CALL cl_set_comp_entry('rue36',FALSE)
     END IF

END FUNCTION
#MOD-B80203
#TQC-B10151-----------end------------------------------------------------------

