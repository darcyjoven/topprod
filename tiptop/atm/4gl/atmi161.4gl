# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi161.4gl
# Descriptions...: 集團銷售預測維護作業
# Date & Author..: 06/02/17 By Sarah
# Modify.........: No.FUN-620032 06/02/17 By Sarah 新增"集團銷售預測維護作業"
# Modify.........: No.FUN-630092 06/03/30 By Sarah 修改單身後,應馬上顯示總預測金額
# Modify.........: No.FUN-640268 06/04/28 By Sarah 增加"銷售預測產生"功能
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660104 06/06/20 By day   cl_err --> cl_err3
# Modify.........: No.FUN-680047 06/08/15 By Sarah 確認訊息加強(告知是何原因導致無法做確認)
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.CHI-6A0004 06/11/01 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/23 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件" 
# Modify.........: No.TQC-6C0217 06/12/30 By Rayven odc01輸入時控管資料一定要是有效的
# Modify.........: No.FUN-730069 07/04/07 By kim GP5.0 & 5.1 銷售預測
# Modify.........: No.TQC-740338 07/04/27 By sherry 查詢時狀態欄不能輸入。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/21 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-930229 09/03/24 By Dido 部門錯誤訊息不明確
# Modify.........: No.TQC-980159 09/08/21 By Dido AFTER FIELF odc07 應取消 gem_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/24 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40055 10/05/06 by destiny 单身显示改为dialog
# Modify.........: No.FUN-A50102 10/06/13 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao modify 
# Modify.........: No.TQC-AC0081 10/12/10 By houlia 修改page檔的oriu、orig的查詢及顯示；odc09/odd09做有效性控管；修改雙擊單身功能；調整odc02的查詢開窗
# Modify.........: No.TQC-B20164 11/02/24 By destiny 點擊右側明細維護功能鈕，程序DOWN出
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
 
DEFINE   g_odd1         DYNAMIC ARRAY OF RECORD
                         odd03  LIKE odd_file.odd03,
                         odd04  LIKE odd_file.odd04,
                         odd07  LIKE odd_file.odd07,
                         odd08  LIKE odd_file.odd08,
                         odd09  LIKE odd_file.odd09
                        END RECORD
DEFINE   g_odd1_t       RECORD
                         odd03  LIKE odd_file.odd03,
                         odd04  LIKE odd_file.odd04,
                         odd07  LIKE odd_file.odd07,
                         odd08  LIKE odd_file.odd08,
                         odd09  LIKE odd_file.odd09
                        END RECORD
DEFINE   g_ode          DYNAMIC ARRAY OF RECORD
                         ode04  LIKE ode_file.ode04,
                         ode05  LIKE ode_file.ode05,
                         ode06  LIKE ode_file.ode06,
                         ode07  LIKE ode_file.ode07,
                         ode071 LIKE ode_file.ode071,
                         ode08  LIKE ode_file.ode08,
                         ode09  LIKE ode_file.ode09,
                         ode10  LIKE ode_file.ode10,
                         ode14  LIKE ode_file.ode14,
                         ode15  LIKE ode_file.ode15 #FUN-730069
                        END RECORD
DEFINE   g_ode_t        RECORD
                         ode04  LIKE ode_file.ode04,
                         ode05  LIKE ode_file.ode05,
                         ode06  LIKE ode_file.ode06,
                         ode07  LIKE ode_file.ode07,
                         ode071 LIKE ode_file.ode071,
                         ode08  LIKE ode_file.ode08,
                         ode09  LIKE ode_file.ode09,
                         ode10  LIKE ode_file.ode10,
                         ode14  LIKE ode_file.ode14,
                         ode15  LIKE ode_file.ode15 #FUN-730069
                        END RECORD
DEFINE   g_odd2         DYNAMIC ARRAY OF RECORD
                         odd03  LIKE odd_file.odd03,
                         odd04  LIKE odd_file.odd04,
                         odd07  LIKE odd_file.odd07,
                         odd08  LIKE odd_file.odd08,
                         odd09  LIKE odd_file.odd09,
                         qty1a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty2a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty3a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty4a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty5a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty6a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty7a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty8a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty9a  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty10a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty11a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty12a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty13a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty14a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty15a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty16a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty17a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty18a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty19a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty20a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty21a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty22a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty23a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty24a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty25a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty26a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty27a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty28a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty29a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty30a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty31a LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)
                         qty32a LIKE aao_file.aao05           #No.FUN-680120  DEC(15,3)
                        END RECORD
DEFINE   g_odd3         DYNAMIC ARRAY OF RECORD
                         odd03  LIKE odd_file.odd03,
                         odd04  LIKE odd_file.odd04,
                         odd07  LIKE odd_file.odd07,
                         odd08  LIKE odd_file.odd08,
                         odd09  LIKE odd_file.odd09,
                         amt1b  LIKE aao_file.aao05,          #iiNo.FUN-nnn680120
                         amt2b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt3b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt4b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt5b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt6b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt7b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt8b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt9b  LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt10b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt11b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt12b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt13b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt14b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt15b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt16b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt17b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt18b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt19b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt20b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt21b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt22b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt23b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt24b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt25b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt26b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt27b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)   
                         amt28b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt29b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt30b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt31b LIKE aao_file.aao05,          #No.FUN-680120  DEC(15,3)  
                         amt32b LIKE aao_file.aao05           #No.FUN-680120  DEC(15,3)  
                        END RECORD
DEFINE   g_odc          RECORD LIKE odc_file.*,
         g_odc_t        RECORD LIKE odc_file.*,
          
         g_odc01_t      LIKE odc_file.odc01,
         g_odc02_t      LIKE odc_file.odc02,
         g_odd03        LIKE odd_file.odd03,
         g_odd04        LIKE odd_file.odd04,
         g_wc,g_wc2     STRING,  #No.FUN-580092 HCN
         g_sql          STRING,  #No.FUN-580092 HCN
         g_rec_b        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         g_rec_b1       LIKE type_file.num5           #No.FUN-680120 SMALLINT
DEFINE   g_tot          RECORD
                         tot1  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot2  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot3  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot4  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot5  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot6  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot7  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot8  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot9  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot10 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot11 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot12 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot13 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot14 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot15 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot16 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot17 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot18 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot19 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot20 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot21 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot22 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot23 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot24 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot25 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot26 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot27 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot28 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot29 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot30 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot31 LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                         tot32 LIKE type_file.num20_6           #No.FUN-680120 DECIMAL(20,6)
                        END RECORD 
DEFINE   g_dbs_atm      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(21)  #FUN-640268 add
DEFINE   p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_b_flag       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i            LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   l_ac           LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   l_ac1          LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_cnt          LIKE type_file.num5          #No.FUN-680120 SMALLINT 
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE   g_argv1        LIKE odc_file.odc01
DEFINE   g_argv2        LIKE odc_file.odc02
DEFINE   g_dbs_atm_tra  LIKE azw_file.azw05          #FUN-980091 add
DEFINE   l_plant_new    LIKE azp_file.azp01          #FUN-980091 add
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8          #No.FUN-6B0014
 
   OPTIONS                               #改變一些系統預設值
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
 
 
   LET g_forupd_sql= " SELECT * FROM odc_file WHERE odc01 = ? AND odc02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i161_cl CURSOR FROM g_forupd_sql
 
   #FUN-730069...........begin
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   #FUN-730069...........end
   
   LET p_row = 2  LET p_col = 9 
   OPEN WINDOW i161_w AT p_row,p_col WITH FORM "atm/42f/atmi161"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      CALL i161_q()
   END IF   
 
   #先將不用的欄位隱藏起來
   CALL i161_set_comp_unvisible()
 
   CALL i161_menu()
 
   CLOSE WINDOW i161_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i161_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN #FUN-730069
      LET g_wc = " odc01 = '",g_argv1,"'",
                 " AND odc02 = '",g_argv2,"'"
      LET g_wc2=" 1=1 "
   ELSE
      CLEAR FORM                             #清除畫面
      LET g_action_choice=" " 
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
      INITIALIZE g_odc.* TO NULL    #No.FUN-750051
      #No.FUN-A40055--begin
#      CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
#                odc01,odc02,odc04,odc05,odc06,odc07,odc08,odc09,
#                odc10,odc27,odc11,odc12,odc121,odc13,odc131,  #FUN-730069
#                odcuser,odcgrup,odcmodu,odcdate,      #No.TQC-740338   
#      
#               #FUN-840068 08/04/21  ---start---
#                odcud01,odcud02,odcud03,odcud04,odcud05,
#                odcud06,odcud07,odcud08,odcud09,odcud10,
#                odcud11,odcud12,odcud13,odcud14,odcud15
#               #FUN-840068 08/04/21  ----end----
#      
#         #No.FUN-580031 --start--     HCN
#         BEFORE CONSTRUCT
#            CALL cl_qbe_init()
#         #No.FUN-580031 --end--       HCN
#      
#         ON ACTION controlp
#            CASE WHEN INFIELD(odc01)   #預測版本
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_odb"
#                      LET g_qryparam.default1 = g_odc.odc01
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odc01
#                      NEXT FIELD odc01
#                 WHEN INFIELD(odc02)   #組織代號
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_tqd03"
#                      LET g_qryparam.default1 = g_odc.odc02
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odc02
#                      NEXT FIELD odc02
#                 WHEN INFIELD(odc07)   #業務員
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_gen"
#                      LET g_qryparam.default1 = g_odc.odc07
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odc07
#                      NEXT FIELD odc07
#                 WHEN INFIELD(odc08)   #部門
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_gem"
#                      LET g_qryparam.default1 = g_odc.odc08
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odc08
#                      NEXT FIELD odc08
#                 WHEN INFIELD(odc09)   #幣別
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_azi"
#                      LET g_qryparam.default1 = g_odc.odc09
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odc09
#                      NEXT FIELD odc09
#                 OTHERWISE EXIT CASE
#            END CASE
#      
#         ON ACTION forecast_data               #預測資料
#            LET g_b_flag = '1'
#      
#         ON ACTION forecast_total_qty_detail   #明細預測總數量
#            LET g_b_flag = '2'
#      
#         ON ACTION forecast_total_amt_detail   #明細預測總金額
#            LET g_b_flag = '3'
#      
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
#      
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#      
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
#      
#         ON ACTION controlg      #MOD-4C0121
#            CALL cl_cmdask()     #MOD-4C0121
#      
#         ON ACTION cancel
#            LET g_action_choice="exit"
#            EXIT CONSTRUCT
#      
#         ON ACTION exit
#            LET g_action_choice="exit"
#            EXIT CONSTRUCT
#      
#         #No.FUN-580031 --start--     HCN
#         ON ACTION qbe_select
#            CALL cl_qbe_list() RETURNING lc_qbe_sn
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#         #No.FUN-580031 --end--       HCN
#      END CONSTRUCT
#      
#      IF INT_FLAG OR g_action_choice = "exit" THEN    #MOD-4B0238 add 'exit'
#         RETURN
#      END IF
#      #資料權限的檢查
#      #Begin:FUN-980030
#      #      IF g_priv2='4' THEN                           #只能使用自己的資料
#      #         LET g_wc = g_wc clipped," AND odcuser = '",g_user,"'"
#      #      END IF
#      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
#      #         LET g_wc = g_wc clipped," AND odcgrup MATCHES '",g_grup CLIPPED,"*'"
#      #      END IF
#      
#      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
#      #         LET g_wc = g_wc clipped," AND odcgrup IN ",cl_chk_tgrup_list()
#      #      END IF
#      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('odcuser', 'odcgrup')
#      #End:FUN-980030
#      
#      CONSTRUCT g_wc2 ON odd03,odd04,odd07,odd08,odd09
#                    FROM s_odd1[1].odd03,s_odd1[1].odd04,s_odd1[1].odd07,
#                         s_odd1[1].odd08,s_odd1[1].odd09
#         #No.FUN-580031 --start--     HCN
#         BEFORE CONSTRUCT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#         #No.FUN-580031 --end--       HCN
#      
#         ON ACTION controlp
#            CASE WHEN INFIELD(odd04)   #預測料號
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_ima"
#                      LET g_qryparam.default1 = g_odd1[1].odd04
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odd04
#                      NEXT FIELD odd04
#                 WHEN INFIELD(odd09)   #銷售單位
#                      CALL cl_init_qry_var()
#                      LET g_qryparam.state    = "c"
#                      LET g_qryparam.form     = "q_gfe"
#                      LET g_qryparam.default1 = g_odd1[1].odd09
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO odd09
#                      NEXT FIELD odd09
#                 OTHERWISE EXIT CASE
#            END CASE
#      
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
#      
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#      
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
#      
#         ON ACTION controlg      #MOD-4C0121
#            CALL cl_cmdask()     #MOD-4C0121
#      
#         #No.FUN-580031 --start--     HCN
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 --end--       HCN
#      END CONSTRUCT
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
                   odc01,odc02,odc04,odc05,odc06,odc07,odc08,odc09,
                   odc10,odc27,odc11,odc12,odc121,odc13,odc131, 
                   odcuser,odcgrup,odcmodu,odcdate,odcoriu,odcorig,  #TQC-AC0081  add odcoriu,odcorig     
                   odcud01,odcud02,odcud03,odcud04,odcud05,
                   odcud06,odcud07,odcud08,odcud09,odcud10,
                   odcud11,odcud12,odcud13,odcud14,odcud15
         
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
         END CONSTRUCT      

         CONSTRUCT g_wc2 ON odd03,odd04,odd07,odd08,odd09
                       FROM s_odd1[1].odd03,s_odd1[1].odd04,s_odd1[1].odd07,
                            s_odd1[1].odd08,s_odd1[1].odd09
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

         END CONSTRUCT
         ON ACTION controlp
            CASE WHEN INFIELD(odc01)   #預測版本
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                     #LET g_qryparam.form     = "q_odb"    #TQC-AC0081  --modfiy
                      LET g_qryparam.form     = "q_odc_01"    #TQC-AC0081  --add
                      LET g_qryparam.default1 = g_odc.odc01
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO odc01
                      NEXT FIELD odc01
                 WHEN INFIELD(odc02)   #組織代號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_tqd03"
                      LET g_qryparam.default1 = g_odc.odc02
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO odc02
                      NEXT FIELD odc02
                 WHEN INFIELD(odc07)   #業務員
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_gen"
                      LET g_qryparam.default1 = g_odc.odc07
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO odc07
                      NEXT FIELD odc07
                 WHEN INFIELD(odc08)   #部門
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_gem"
                      LET g_qryparam.default1 = g_odc.odc08
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO odc08
                      NEXT FIELD odc08
                 WHEN INFIELD(odc09)   #幣別
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_azi"
                      LET g_qryparam.default1 = g_odc.odc09
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO odc09
                      NEXT FIELD odc09
                 WHEN INFIELD(odd04)   #預測料號
#FUN-AA0059---------mod------------str-----------------
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state    = "c"
#                     LET g_qryparam.form     = "q_ima"
#                     LET g_qryparam.default1 = g_odd1[1].odd04
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima(TRUE, "q_ima","",g_odd1[1].odd04,"","","","","",'')
                       RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                      DISPLAY g_qryparam.multiret TO odd04
                      NEXT FIELD odd04
                 WHEN INFIELD(odd09)   #銷售單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_gfe"
                      LET g_qryparam.default1 = g_odd1[1].odd09
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO odd09
                      NEXT FIELD odd09 
                 OTHERWISE EXIT CASE
            END CASE         
            ON ACTION accept
               #TQC-AC0081 --add
               LET g_action_choice="detail"
               LET l_ac = ARR_CURR()
               EXIT DIALOG          
               #TQC-AC0081 --end
            ON ACTION EXIT
               LET INT_FLAG = TRUE
               EXIT DIALOG 
       
            ON ACTION cancel
               LET INT_FLAG = TRUE
               EXIT DIALOG         
                     
            ON ACTION forecast_data               #預測資料
               LET g_b_flag = '1'
         
            ON ACTION forecast_total_qty_detail   #明細預測總數量
               LET g_b_flag = '2'
         
            ON ACTION forecast_total_amt_detail   #明細預測總金額
               LET g_b_flag = '3'
         
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG
         
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
         
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
         
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
         
            ON ACTION qbe_select
               CALL cl_qbe_list() RETURNING lc_qbe_sn
               CALL cl_qbe_display_condition(lc_qbe_sn)
                                
      END DIALOG
      #No.FUN-A40055--end      
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN
      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('odcuser', 'odcgrup')
   END IF
   IF g_wc2=' 1=1 ' THEN
      LET g_sql = "SELECT odc01,odc02 FROM odc_file",
                  " WHERE odc12!='X' AND ", g_wc CLIPPED,
                  " ORDER BY odc01,odc02"
   ELSE
      LET g_sql = "SELECT odc01,odc02 FROM odc_file,odd_file ",
                  " WHERE odc12!='X' AND ", g_wc CLIPPED," AND ", g_wc2 CLIPPED,
                  "   AND odc01=odd01 AND odc02=odd02 ",
                  " ORDER BY odc01,odc02"
   END IF
   PREPARE i161_prepare FROM g_sql
   DECLARE i161_cs SCROLL CURSOR WITH HOLD FOR i161_prepare
 
   IF g_wc2=' 1=1 ' THEN
      LET g_sql = "SELECT COUNT(*) FROM odc_file",
                  " WHERE odc12!='X' AND ", g_wc CLIPPED
   ELSE
      LET g_sql = "SELECT COUNT(*) FROM odc_file,odd_file ",
                  " WHERE odc12!='X' AND ", g_wc CLIPPED," AND ", g_wc2 CLIPPED,
                  "   AND odc01=odd01 AND odc02=odd02"
   END IF
   PREPARE i161_precount FROM g_sql
   DECLARE i161_count CURSOR FOR i161_precount
END FUNCTION
 
FUNCTION i161_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      #No.FUN-A40055--begin
#      CASE g_b_flag
#         WHEN '1'
#            CALL i161_bp1("G")
#         WHEN '2'
#            CALL i161_bp2("G")
#         WHEN '3'
#            CALL i161_bp3("G")
#         OTHERWISE
#            CALL i161_bp1("G")
#      END CASE
       CALL i161_bp("G")
      #No.FUN-A40055--end
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i161_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i161_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i161_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i161_u()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i161_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i161_b()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         #@WHEN "時距明細"
         WHEN "bucket_detail"
            CALL i161_b1_fill()
            LET g_b_flag = "1"
 
         #@WHEN "明細預測總數量"
         WHEN "forecast_total_qty_detail"
            CALL i161_b2_fill()
            LET g_b_flag = "2"
 
         #@WHEN "明細預測總金額"
         WHEN "forecast_total_amt_detail"
            CALL i161_b3_fill()
            LET g_b_flag = "3"
 
         #@WHEN "銷售預測產生"
         WHEN "gen_sales_forecast"
            IF cl_chk_act_auth() THEN
               CALL i161_gen()
            END IF
 
         #@WHEN "明細維護"
         WHEN "mantain_detail"
            IF cl_chk_act_auth() THEN
               CALL i161_b_1('u')
            END IF
 
         #@WHEN "明細查詢"
         #No.FUN-A40055--begin
         #WHEN "query_detail"
         #   IF cl_chk_act_auth() THEN
         #      CALL i161_bp1_1("G")
         #   END IF
         #No.FUN-A40055--end
         #@WHEN "預測確認"
         WHEN "confirm_forecast"
            IF cl_chk_act_auth() THEN
               CALL i161_y()
            END IF
 
         #@WHEN "預測取消確認"
         WHEN "undo_confirm_forecast"
            IF cl_chk_act_auth() THEN
               CALL i161_z()
            END IF
 
         #@WHEN "目標數量調整"
         WHEN "adjust_target_qty"
            IF cl_chk_act_auth() THEN
               CALL i161_adjust_target_qty()
            END IF
 
         #@WHEN "目標數量確認"
         WHEN "confirm_target_qty"
            IF cl_chk_act_auth() THEN
               CALL i161_target_qty_y()
            END IF
 
         #@WHEN "目標數量取消確認"
         WHEN "undo_confirm_target_qty"
            IF cl_chk_act_auth() THEN
               CALL i161_target_qty_z()
            END IF
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_odc.odc01 IS NOT NULL THEN
                LET g_doc.column1 = "odc01"
                LET g_doc.column2 = "odc02"
                LET g_doc.value1 = g_odc.odc01
                LET g_doc.value2 = g_odc.odc02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i161_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_odd1.clear()
   CALL g_ode.clear()
   CALL g_odd2.clear()
   CALL g_odd3.clear()
   INITIALIZE g_odc.* LIKE odc_file.*
   LET g_odc01_t = NULL
   LET g_odc02_t = NULL
   LET g_odc.odc10 = 1
   LET g_odc.odc11 = 0
   LET g_odc.odc12 = 'N'
   LET g_odc.odc121= 'N'
   LET g_odc.odc13 = 'N'
   LET g_odc.odc131= 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_odc.odcuser = g_user
       LET g_odc.odcgrup = g_grup               # 使用者所屬群
       LET g_odc.odcoriu = g_user               #TQC-AC0081
       LET g_odc.odcorig = g_grup               #TQC-AC0081 
       LET g_odc.odcmodu = NULL
       LET g_odc.odcdate = g_today
       CALL i161_i("a")                         # 各欄位輸入
       IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_odd1.clear()
           CALL g_ode.clear()
           CALL g_odd2.clear()
           CALL g_odd3.clear()
           EXIT WHILE
       END IF
       IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN     # KEY 不可空白
          CONTINUE WHILE
       END IF
       LET g_odc.odcoriu = g_user      #No.FUN-980030 10/01/04
       LET g_odc.odcorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO odc_file VALUES(g_odc.*)     # DISK WRITE
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)  #No.FUN-660104
          CALL cl_err3("ins","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
          CONTINUE WHILE
       ELSE
          LET g_odc_t.* = g_odc.*               # 保存上筆資料
          SELECT odc01 INTO g_odc.odc01 FROM odc_file
           WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
       END IF
       LET g_rec_b=0
       CALL i161_b()
       EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i161_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_odc.* FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc12='Y' THEN CALL cl_err('','9022',0) RETURN END IF
 
   LET g_success = 'Y'
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_odc01_t = g_odc.odc01
   LET g_odc02_t = g_odc.odc02
   LET g_odc_t.* = g_odc.*
   BEGIN WORK
   OPEN i161_cl USING g_odc.odc01,g_odc.odc02
   FETCH i161_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i161_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CALL i161_show()
   WHILE TRUE
      LET g_odc01_t = g_odc.odc01
      LET g_odc02_t = g_odc.odc02
      LET g_odc.odcmodu=g_user
      LET g_odc.odcdate=g_today
      CALL i161_i("u")                      #欄位更改
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_odc.*=g_odc_t.*
          CALL i161_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
      END IF
      UPDATE odc_file SET odc_file.* = g_odc.* WHERE odc01 = g_odc01_t AND odc02 = g_odc02_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
         CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i161_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i161_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_n          LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_m          LIKE type_file.num5,          #No.TQC-AC0081
          l_odb02      LIKE odb_file.odb02,
          l_odb07      LIKE odb_file.odb07,
          l_tqb02      LIKE tqb_file.tqb02,
          l_gen02      LIKE gen_file.gen02,
          l_gem02      LIKE gem_file.gem02
 
   DISPLAY BY NAME
      g_odc.odc01,g_odc.odc02, g_odc.odc04,g_odc.odc05, g_odc.odc06,
      g_odc.odc07,g_odc.odc08, g_odc.odc09,g_odc.odc10, g_odc.odc11,
      g_odc.odc12,g_odc.odc121,g_odc.odc13,g_odc.odc131,
      g_odc.odcuser,g_odc.odcgrup,g_odc.odcmodu,g_odc.odcdate,
 
     #FUN-840068 08/04/21  ---start---
      g_odc.odcud01,g_odc.odcud02,g_odc.odcud03,g_odc.odcud04,g_odc.odcud05,
      g_odc.odcud06,g_odc.odcud07,g_odc.odcud08,g_odc.odcud09,g_odc.odcud10,
      g_odc.odcud11,g_odc.odcud12,g_odc.odcud13,g_odc.odcud14,g_odc.odcud15, 
     #FUN-840068 08/04/21  ----end----
      g_odc.odcoriu,g_odc.odcorig                              #TQC-AC0081   add

   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME
          g_odc.odc01,g_odc.odc02,g_odc.odc04,g_odc.odc05,g_odc.odc06,
          g_odc.odc07,g_odc.odc08,g_odc.odc09,g_odc.odc10,
        
         #FUN-840068 08/04/21  ---start---
          g_odc.odcud01,g_odc.odcud02,g_odc.odcud03,g_odc.odcud04,g_odc.odcud05,
          g_odc.odcud06,g_odc.odcud07,g_odc.odcud08,g_odc.odcud09,g_odc.odcud10,
          g_odc.odcud11,g_odc.odcud12,g_odc.odcud13,g_odc.odcud14,g_odc.odcud15 
         #FUN-840068 08/04/21  ----end----
     
       WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i161_set_entry(p_cmd)
           CALL i161_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
       AFTER FIELD odc01   #預測版本
           IF NOT cl_null(g_odc.odc01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_odc.odc01!=g_odc_t.odc01) THEN
                 SELECT odb02,odb04,odb05,odb06,odb07,odb09 
                   INTO l_odb02,g_odc.odc04,g_odc.odc05,g_odc.odc06,l_odb07,g_odc.odc09
                   FROM odb_file WHERE odb01 = g_odc.odc01
                                   AND odbacti = 'Y'        #No.TQC-6C0217
                 IF STATUS THEN
                    LET l_odb02 = ''
                    LET g_odc.odc04 = ''
                    LET g_odc.odc05 = ''
                    LET g_odc.odc06 = ''
                    LET l_odb07 = ''
                    LET g_odc.odc09 = ''
#                   CALL cl_err(g_odc.odc01,'mfg-012',0)   #No.FUN-660104
                    CALL cl_err3("sel","odb_file",g_odc.odc01,"","mfg-012","","",1)  #No.FUN-660104
                    NEXT FIELD odc01
                 END IF
                 DISPLAY l_odb02 TO FORMONLY.odb02
                 DISPLAY BY NAME g_odc.odc04,g_odc.odc05,g_odc.odc06,g_odc.odc09
              END IF
           END IF
 
       AFTER FIELD odc02   #組織代號
           IF NOT cl_null(g_odc.odc02) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_odc.odc02!=g_odc_t.odc02) THEN
                 SELECT tqb02 INTO l_tqb02 FROM tqb_file WHERE tqb01=g_odc.odc02
                 IF STATUS THEN 
                    LET l_tqb02 = '' 
#                   CALL cl_err(g_odc.odc02,'mfg-012',0)  #No.FUN-660104
                    CALL cl_err3("sel","tqb_file",g_odc.odc02,"","mfg-012","","",1)  #No.FUN-660104
                    NEXT FIELD odc02
                 END IF
                 DISPLAY l_tqb02 TO FORMONLY.tqb02
              END IF
           END IF
 
       AFTER FIELD odc07   #業務員
           IF NOT cl_null(g_odc.odc07) THEN
             #SELECT gen02,gen03,gem02 INTO l_gen02,g_odc.odc08,l_gem02 #MOD-930229 mark
              SELECT gen02,gen03 INTO l_gen02,g_odc.odc08               #MOD-930229
               #FROM gen_file,gem_file		#TQC-980159 mark 
                FROM gen_file 			#TQC-980159
              #WHERE gen01=g_odc.odc07 AND gen03=gem01  #MOD-930229 mark
               WHERE gen01=g_odc.odc07                  #MOD-930229
              IF STATUS THEN 
#                CALL cl_err('sel gen:',STATUS,1)   #No.FUN-660104
                 CALL cl_err3("sel","gen_file,gem_file",g_odc.odc07,"",STATUS,"","sel gen",1)  #No.FUN-660104
                 NEXT FIELD odc07   #MOD-930229 Add
              END IF
 
              #MOD-930229 Add
              IF NOT cl_null(g_odc.odc08) THEN
                 SELECT gem02 INTO l_gem02 
                   FROM gem_file 
                  WHERE gem01=g_odc.odc08 
                    AND gemacti='Y'   #NO:6950
                 IF SQLCA.SQLCODE THEN  
                    CALL cl_err3("sel","gem_file",g_odc.odc08,"",STATUS,"","sel gem",1)  #No.FUN-660104
                    NEXT FIELD odc08
                 END IF
              END IF
              #MOD-930229 End 
 
              DISPLAY BY NAME g_odc.odc08
              DISPLAY l_gen02,l_gem02 TO FORMONLY.gen02,FORMONLY.gem02
           END IF
 
       AFTER FIELD odc08   #部門
           IF NOT cl_null(g_odc.odc08) THEN
              SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_odc.odc08
                 AND gemacti='Y'   #NO:6950
              IF STATUS THEN 
#                CALL cl_err('sel gem:',STATUS,1)  #No.FUN-660104
                 CALL cl_err3("sel","gem_file",g_odc.odc08,"",STATUS,"","sel gem",1)  #No.FUN-660104
                 NEXT FIELD odc08   #MOD-930229 Add
              END IF 
              DISPLAY l_gem02 TO FORMONLY.gem02
           END IF
 
       AFTER FIELD odc09   #幣別
           IF NOT cl_null(g_odc.odc09) THEN
         #TQC-AC0081 --add
              SELECT count(*) INTO l_m FROM azi_file
               WHERE azi01=g_odc.odc09
                 AND aziacti='Y'
              IF l_m <= 0 THEN
                 CALL cl_err('','odb-002',0)
                 NEXT FIELD odc09
              END IF
         #TQC-AC0081  --end
              SELECT azi03,azi04 INTO t_azi03,t_azi04  #No.CHI-6A0004
                FROM azi_file WHERE azi01=g_odc.odc09
              IF STATUS THEN
                 LET t_azi03 = 0   #單價小數位數  #No.CHI-6A0004
                 LET t_azi04 = 0   #金額小數位數  #No.CHI-6A0004
              END IF 
              CALL s_curr3(g_odc.odc09,g_today,g_oaz.oaz52)
                   RETURNING g_odc.odc10
              DISPLAY BY NAME g_odc.odc10
           END IF
      #FUN-840068  08/04/21   ---start---
 
       AFTER FIELD odcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD odcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD odcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD odcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD odcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER FIELD odcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #FUN-840068  08/04/21   ----end----
     
       #MOD-650040 --start
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #    IF INFIELD(odc01) THEN
       #       LET g_odc.* = g_odc_t.*
       #       CALL i161_show()
       #       NEXT FIELD odc01
       #    END IF
       #MOD-650040 --end
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(odc01)  #預測版本
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_odb"
                 LET g_qryparam.default1 = g_odc.odc01
                 CALL cl_create_qry() RETURNING g_odc.odc01
                 DISPLAY BY NAME g_odc.odc01
              WHEN INFIELD(odc02)  #成本中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_tqd03"
                 LET g_qryparam.default1 = g_odc.odc02
                 CALL cl_create_qry() RETURNING g_odc.odc02
                 DISPLAY BY NAME g_odc.odc02
              WHEN INFIELD(odc07)   #業務員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gen"
                 LET g_qryparam.default1 = g_odc.odc07
                 CALL cl_create_qry() RETURNING g_odc.odc07
                 DISPLAY BY NAME g_odc.odc07
                 NEXT FIELD odc07
              WHEN INFIELD(odc08)   #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.default1 = g_odc.odc08
                 CALL cl_create_qry() RETURNING g_odc.odc08
                 DISPLAY BY NAME g_odc.odc08
                 NEXT FIELD odc08
              WHEN INFIELD(odc09)   #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_azi"
                 LET g_qryparam.default1 = g_odc.odc09
                 CALL cl_create_qry() RETURNING g_odc.odc09
                 DISPLAY BY NAME g_odc.odc09
                 NEXT FIELD odc09
              OTHERWISE EXIT CASE
           END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF                        # 欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
   END INPUT
END FUNCTION
 
FUNCTION i161_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_odc.* TO NULL               #No.FUN-6B0043
   LET g_rec_b  = 0
   LET g_rec_b1 = 0
   DISPLAY g_rec_b  TO cn2
   DISPLAY g_rec_b1 TO cn3
   DISPLAY g_rec_b1 TO cn4
   DISPLAY g_rec_b1 TO cn5
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i161_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_odc.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN i161_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_odc.* TO NULL
   ELSE
      OPEN i161_count
      FETCH i161_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i161_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION i161_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
            l_abso   LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i161_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'P' FETCH PREVIOUS i161_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'F' FETCH FIRST    i161_cs INTO g_odc.odc01,g_odc.odc02
      WHEN 'L' FETCH LAST     i161_cs INTO g_odc.odc01,g_odc.odc02
      WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
            
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
            
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump i161_cs INTO g_odc.odc01,g_odc.odc02
         LET mi_no_ask = FALSE   #No.FUN-6A0072
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_odc.* TO NULL
      CALL g_odd1.clear()
      CALL g_ode.clear()
      CALL g_odd2.clear()
      CALL g_odd3.clear()
      CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
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
   SELECT * INTO g_odc.* FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF SQLCA.sqlcode THEN
      INITIALIZE g_odc.* TO NULL
      CALL g_odd1.clear()
      CALL g_ode.clear()
      CALL g_odd2.clear()
      CALL g_odd3.clear()
#     CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)  #No.FUN-660104
      CALL cl_err3("sel","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
      RETURN
   END IF
 
   #先將不用的欄位隱藏起來
   CALL i161_set_comp_unvisible()
   CALL i161_show()
END FUNCTION
 
FUNCTION i161_show()
   DEFINE l_odb02    LIKE odb_file.odb02
   DEFINE l_tqb02    LIKE tqb_file.tqb02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_gem02    LIKE gem_file.gem02
   DEFINE l_ode14_1  LIKE ode_file.ode14
 
   DISPLAY BY NAME
      g_odc.odc01,g_odc.odc02, g_odc.odc04,g_odc.odc05, g_odc.odc06,
      g_odc.odc07,g_odc.odc08, g_odc.odc09,g_odc.odc10, g_odc.odc27,g_odc.odc11, #FUN-730069
      g_odc.odc12,g_odc.odc121,g_odc.odc13,g_odc.odc131,
      g_odc.odcuser,g_odc.odcgrup,g_odc.odcmodu,g_odc.odcdate,
 
     #FUN-840068 08/04/21  ---start---
      g_odc.odcud01,g_odc.odcud02,g_odc.odcud03,g_odc.odcud04,g_odc.odcud05,
      g_odc.odcud06,g_odc.odcud07,g_odc.odcud08,g_odc.odcud09,g_odc.odcud10,
      g_odc.odcud11,g_odc.odcud12,g_odc.odcud13,g_odc.odcud14,g_odc.odcud15 
     #FUN-840068 08/04/21  ----end----
 
   #圖形顯示
   CALL cl_set_field_pic(g_odc.odc12,"","","","","")
 
   SELECT odb02 INTO l_odb02 FROM odb_file WHERE odb01=g_odc.odc01
   IF STATUS THEN LET l_odb02 = '' END IF
   DISPLAY l_odb02 TO FORMONLY.odb02
 
   SELECT tqb02 INTO l_tqb02 FROM tqb_file WHERE tqb01=g_odc.odc02
   IF STATUS THEN LET l_tqb02 = '' END IF
   DISPLAY l_tqb02 TO FORMONLY.tqb02
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_odc.odc07
   IF STATUS THEN LET l_gen02 = '' END IF
   DISPLAY l_gen02 TO FORMONLY.gen02
 
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_odc.odc08
   IF STATUS THEN LET l_gem02 = '' END IF
   DISPLAY l_gem02 TO FORMONLY.gem02
 
   SELECT SUM(ode14) INTO l_ode14_1 FROM ode_file 
    WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
   IF STATUS THEN LET l_ode14_1 = 0 END IF
   DISPLAY l_ode14_1 TO FORMONLY.ode14_1
 
   CALL i161_b1_fill()
   CALL i161_b2_fill()
   CALL i161_b3_fill()
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i161_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
   l_m             LIKE type_file.num5,                # TQC-AC0081
   l_qty           LIKE type_file.num10,               #No.FUN-680120   INTEGER           #
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否           #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否           #No.FUN-680120 SMALLINT
   l_cnt           LIKE type_file.num5                 #MOD-5C0031         #No.FUN-680120 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
   IF g_odc.odc12='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT odd03,odd04,odd07,odd08,odd09 ",
                      "  FROM odd_file ",
                      "  WHERE odd01=? AND odd02=? ",
                      "   AND odd03=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i161_bc1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_odd1 WITHOUT DEFAULTS FROM s_odd1.*
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
 
           OPEN i161_cl USING g_odc.odc01,g_odc.odc02
           IF STATUS THEN
              CALL cl_err("OPEN i161_cl:", STATUS, 1)
              CLOSE i161_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i161_cl INTO g_odc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
              CLOSE i161_cl
              ROLLBACK WORK
              RETURN
           END IF
           CALL i161_b1_fill_1(g_odd1[l_ac].odd03)
           CALL i161_bp1_refresh()
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_odd1_t.* = g_odd1[l_ac].*  #BACKUP
              LET l_lock_sw = 'N'              #DEFAULT
              OPEN i161_bc1 USING g_odc.odc01,g_odc.odc02,g_odd1_t.odd03
              IF STATUS THEN
                 CALL cl_err("OPEN i161_bc1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i161_bc1 INTO g_odd1[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_odd1_t.odd03,SQLCA.sqlcode , 1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_odd1[l_ac].* TO NULL      #900423
           LET g_odd1_t.* = g_odd1[l_ac].*        #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD odd03
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO odd_file(odd01,odd02,odd03,odd04,odd07,odd08,odd09)
                         VALUES(g_odc.odc01,g_odc.odc02,
                                g_odd1[l_ac].odd03,g_odd1[l_ac].odd04,
                                g_odd1[l_ac].odd07,g_odd1[l_ac].odd08,
                                g_odd1[l_ac].odd09)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_odd1[l_ac].odd03,SQLCA.sqlcode,0) #No.FUN-660104
              CALL cl_err3("ins","odd_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              LET g_odd03 = g_odd1[l_ac].odd03
              LET g_odd04 = g_odd1[l_ac].odd04
              #產生單身時距預設值
              CALL i161_g(g_odd1[l_ac].odd03,g_odd1[l_ac].odd04)    
              CALL i161_b_1('u')
           END IF
 
       BEFORE FIELD odd03                        #default 序號
           IF g_odd1[l_ac].odd03 IS NULL OR
              g_odd1[l_ac].odd03 = 0 THEN
              SELECT max(odd03)+1 INTO g_odd1[l_ac].odd03
                FROM odd_file
               WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
              IF g_odd1[l_ac].odd03 IS NULL THEN
                 LET g_odd1[l_ac].odd03 = 1
              END IF
           END IF
 
       AFTER FIELD odd03                        #check 序號是否重複
           IF NOT cl_null(g_odd1[l_ac].odd03) THEN
              IF g_odd1[l_ac].odd03 != g_odd1_t.odd03 OR
                 g_odd1_t.odd03 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM odd_file
                  WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
                    AND odd03 = g_odd1[l_ac].odd03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_odd1[l_ac].odd03 = g_odd1_t.odd03
                    NEXT FIELD odd03
                 END IF
              END IF
           END IF
 
       AFTER FIELD odd04
           IF NOT cl_null(g_odd1[l_ac].odd04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_odd1[l_ac].odd04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_odd1[l_ac].odd04= g_odd1_t.odd04
                 NEXT FIELD odd04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_odd1[l_ac].odd04 != g_odd1_t.odd04 OR   #check料號是否重複
                 g_odd1_t.odd04 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM odd_file
                  WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
                    AND odd04 = g_odd1[l_ac].odd04
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_odd1[l_ac].odd04 = g_odd1_t.odd04
                    NEXT FIELD odd04
                 END IF
              END IF
              IF g_odd1[l_ac].odd04[1,4] = 'MISC' THEN
                 CALL i161_set_entry('')
              ELSE
                 CALL i161_set_no_entry('')
                 SELECT ima02,ima021,ima31 
                   INTO g_odd1[l_ac].odd07,g_odd1[l_ac].odd08,g_odd1[l_ac].odd09
                   FROM ima_file WHERE ima01 = g_odd1[l_ac].odd04
                 IF STATUS THEN 
                    LET g_odd1[l_ac].odd07 = ''
                    LET g_odd1[l_ac].odd08 = ''
                    LET g_odd1[l_ac].odd09 = ''
#                   CALL cl_err(g_odd1[l_ac].odd04, STATUS, 1) #No.FUN-660104
                    CALL cl_err3("sel","ima_file",g_odd1[l_ac].odd04,"",STATUS,"","",1)  #No.FUN-660104
                    NEXT FIELD odd04
                 END IF
                 DISPLAY BY NAME g_odd1[l_ac].odd07,g_odd1[l_ac].odd08,g_odd1[l_ac].odd09
              END IF
           END IF
 

   #TQC-AC0081 --add
        AFTER FIELD odd09
          IF NOT cl_null(g_odd1[l_ac].odd09) THEN
             SELECT count(*) INTO l_m FROM gfe_file
              WHERE gfe01=g_odd1[l_ac].odd09
                AND gfeacti='Y'
             IF l_m <= 0 THEN
                CALL cl_err('','odd-009',0)
                NEXT FIELD odd09
             END IF
        END IF      
   #TQC-AC0081 --end
 
       BEFORE DELETE                            #是否取消單身
           IF g_odd1_t.odd03 > 0 AND g_odd1_t.odd03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM odd_file
               WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
                 AND odd03 = g_odd1_t.odd03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_odd1_t.odd03,SQLCA.sqlcode,0) #No.FUN-660104
                 CALL cl_err3("del","odd_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              DELETE FROM ode_file
               WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
                 AND ode03 = g_odd1_t.odd03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_odd1_t.odd03,SQLCA.sqlcode,0) #No.FUN-660104
                 CALL cl_err3("del","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              #FUN-730069............begin
              IF g_odc.odc27="4" THEN
                 LET g_cnt=0
                 SELECT COUNT(*) INTO g_cnt FROM odg_file 
                                           WHERE odg01=g_odc.odc01
                                             AND odg02=g_odc.odc02
                                             AND odg03=g_odd1[l_ac].odd04
                                             AND odg12='Y'
                 IF g_cnt>0 THEN
                    UPDATE odg_file SET odg12='N'
                                  WHERE odg01=g_odc.odc01
                                    AND odg02=g_odc.odc02
                                    AND odg03=g_odd1[l_ac].odd04
                                    AND odg12='Y'
                    IF SQLCA.sqlerrd[3]<>g_cnt THEN
                       CALL cl_err3("upd","odg_file",g_odc.odc01,g_odc.odc02,"9050","","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                 END IF
              END IF
              #FUN-730069............end
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_odd1[l_ac].* = g_odd1_t.*
              CLOSE i161_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_odd1[l_ac].odd03,-263,1)
              LET g_odd1[l_ac].* = g_odd1_t.*
           ELSE
              UPDATE odd_file SET odd03 = g_odd1[l_ac].odd03,
                                  odd04 = g_odd1[l_ac].odd04,
                                  odd07 = g_odd1[l_ac].odd07,
                                  odd08 = g_odd1[l_ac].odd08,
                                  odd09 = g_odd1[l_ac].odd09
               WHERE odd01=g_odc.odc01 AND odd02=g_odc.odc02
                 AND odd03=g_odd1_t.odd03
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_odd1[l_ac].odd03,SQLCA.sqlcode,0) #No.FUN-660104
                 CALL cl_err3("upd","odd_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_odd1[l_ac].* = g_odd1_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET g_odd03 = g_odd1[l_ac].odd03
                 LET g_odd04 = g_odd1[l_ac].odd04
                 CALL i161_b_1('u')
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_odd1[l_ac].* = g_odd1_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_odd1.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i161_bc1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i161_bc1
           COMMIT WORK
 
       ON ACTION controlp
          CASE WHEN INFIELD(odd04)   #預測料號
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   LET g_qryparam.default1 = g_odd1[l_ac].odd04
#                   CALL cl_create_qry() RETURNING g_odd1[l_ac].odd04
                    CALL q_sel_ima(FALSE, "q_ima","",g_odd1[l_ac].odd04,"","","","","",'' ) 
                         RETURNING   g_odd1[l_ac].odd04
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_odd1[l_ac].odd04 TO odd04
                    NEXT FIELD odd04
               WHEN INFIELD(odd09)   #銷售單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_odd1[l_ac].odd09
                    CALL cl_create_qry() RETURNING g_odd1[l_ac].odd09
                    DISPLAY g_odd1[l_ac].odd09 TO odd09
                    NEXT FIELD odd09
          END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(odd03) AND l_ac > 1 THEN
             LET g_odd1[l_ac].* = g_odd1[l_ac-1].*
             NEXT FIELD odd03
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
   END INPUT
 
   LET g_odc.odcmodu = g_user
   LET g_odc.odcdate = g_today
   UPDATE odc_file SET odcmodu = g_odc.odcmodu,
                       odcdate = g_odc.odcdate
    WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#     CALL cl_err('upd odc',SQLCA.SQLCODE,1)  #No.FUN-660104
      CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc",1)  #No.FUN-660104
   END IF
   DISPLAY BY NAME g_odc.odcmodu,g_odc.odcdate
 
   CLOSE i161_bc1
   COMMIT WORK
   CALL i161_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i161_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
         INITIALIZE g_odc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i161_b_1(p_cmd)
DEFINE
   l_ac1_t         LIKE type_file.num5,             #No.FUN-680120  SMALLINT             #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
   l_qty           LIKE type_file.num10,            #No.FUN-680120  INTEGER            #
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680120 VARCHAR(1)
     p_cmd           LIKE type_file.chr1,               #處理狀態        #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                 #可新增否        #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,                 #可刪除否        #No.FUN-680120 SMALLINT
   l_cnt           LIKE type_file.num5,                #MOD-5C0031       #No.FUN-680120 SMALLINT
   l_ode14_1       LIKE ode_file.ode14    #FUN-630092 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
   IF g_odc.odc12='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = 
       "SELECT ode04,ode05,ode06,ode07,ode071,ode08,ode09,ode10,ode14,ode15 ", #FUN-730069
       "  FROM ode_file ",
       "  WHERE ode01=? AND ode02=? ",
       "   AND ode03=? AND ode04=? ",
       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i161_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac1_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_allow_insert = FALSE
 
   INPUT ARRAY g_ode WITHOUT DEFAULTS FROM s_ode.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1) #mod by john
              LET l_ac1 = 1
           END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN i161_cl USING g_odc.odc01,g_odc.odc02
           IF STATUS THEN
              CALL cl_err("OPEN i161_cl:", STATUS, 1)
              CLOSE i161_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i161_cl INTO g_odc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac1 THEN
              LET g_ode_t.* = g_ode[l_ac1].*  #BACKUP
              LET p_cmd='u'
 
              OPEN i161_bc2 USING g_odc.odc01,g_odc.odc02,g_odd03,g_ode_t.ode04
              IF STATUS THEN
                 CALL cl_err("OPEN i161_bc2:", STATUS, 1)
                 CLOSE i161_bc2
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH i161_bc2 INTO g_ode[l_ac1].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ode_t.ode04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       AFTER FIELD ode06
           IF NOT cl_null(g_ode[l_ac1].ode06) THEN
              IF g_ode[l_ac1].ode06 < 0 THEN
                 CALL cl_err(g_ode[l_ac1].ode06,'mfg5034',1)
                 NEXT FIELD ode06
              END IF
              LET g_ode[l_ac1].ode09 = g_ode[l_ac1].ode06 + g_ode[l_ac1].ode07 + 
                                       g_ode[l_ac1].ode071+ g_ode[l_ac1].ode08
              DISPLAY BY NAME g_ode[l_ac1].ode09
              IF NOT cl_null(g_ode[l_ac1].ode10) OR g_ode[l_ac1].ode10>=0 THEN
                 LET g_ode[l_ac1].ode14=g_ode[l_ac1].ode09*g_ode[l_ac1].ode10
                 CALL cl_digcut(g_ode[l_ac1].ode14,t_azi04)  #No.CHI-6A0004
                      RETURNING g_ode[l_ac1].ode14
                 DISPLAY BY NAME g_ode[l_ac1].ode14
              END IF
           END IF
 
       AFTER FIELD ode10
           IF NOT cl_null(g_ode[l_ac1].ode10) THEN
              IF g_ode[l_ac1].ode10 < 0 THEN
                 CALL cl_err(g_ode[l_ac1].ode10,'mfg5034',1)
                 NEXT FIELD ode10
              ELSE
                 LET g_ode[l_ac1].ode14=g_ode[l_ac1].ode09*g_ode[l_ac1].ode10
                 CALL cl_digcut(g_ode[l_ac1].ode14,t_azi04)  #No.CHI-6A0004
                      RETURNING g_ode[l_ac1].ode14
                 DISPLAY BY NAME g_ode[l_ac1].ode14
              END IF
           END IF
           CALL cl_digcut(g_ode[l_ac1].ode10,t_azi03)  #No.CHI-6A0004
                RETURNING g_ode[l_ac1].ode10
 
       BEFORE DELETE                            #是否取消單身
           IF g_odd03 IS NOT NULL AND g_ode_t.ode04 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ode_file
               WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
                 AND ode03 = g_odd03 AND ode04 = g_ode_t.ode04
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ode_t.ode04,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("del","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn3
              COMMIT WORK
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ode[l_ac1].* = g_ode_t.*
              CLOSE i161_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ode[l_ac1].ode04,-263,1)
              LET g_ode[l_ac1].* = g_ode_t.*
           ELSE
              UPDATE ode_file SET ode06 = g_ode[l_ac1].ode06,
                                  ode09 = g_ode[l_ac1].ode09,
                                  ode10 = g_ode[l_ac1].ode10,
                                  ode11 = g_ode[l_ac1].ode06*g_ode[l_ac1].ode10,
                                  ode14 = g_ode[l_ac1].ode14,
                                  ode15 = g_ode[l_ac1].ode15 #FUN-730069
               WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
                 AND ode03=g_odd03 AND ode04=g_ode[l_ac1].ode04
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ode[l_ac1].ode04,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_ode[l_ac1].* = g_ode_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                #start FUN-630092 add
                 SELECT SUM(ode14) INTO l_ode14_1 FROM ode_file
                  WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
                 IF STATUS THEN LET l_ode14_1 = 0 END IF
                 DISPLAY l_ode14_1 TO FORMONLY.ode14_1
                #end FUN-630092 add
              END IF
           END IF
 
       AFTER ROW
           LET l_ac1= ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ode[l_ac1].* = g_ode_t.*
              END IF
              CLOSE i161_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i161_bc2
           COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(ode04) AND l_ac1 > 1 THEN
             LET g_ode[l_ac1].* = g_ode[l_ac1-1].*
             NEXT FIELD ode04
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
   END INPUT
 
   CLOSE i161_bc2
   COMMIT WORK
END FUNCTION
 
FUNCTION i161_adjust_target_qty()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
   l_qty           LIKE type_file.num10,               #No.FUN-680120  INTEGER             #
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                 #可新增否        #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5,                 #可刪除否        #No.FUN-680120 SMALLINT
   l_cnt           LIKE type_file.num5,                 #MOD-5C0031      #No.FUN-680120 SMALLINT
   l_ode14_1       LIKE ode_file.ode14    #FUN-630092 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
   LET g_msg = ''
   CALL cl_get_feldname('odc13',g_lang) RETURNING g_msg
   IF g_odc.odc13 ='N' THEN CALL cl_err(g_msg,'aim-305',0) RETURN END IF
   IF g_odc.odc131='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT ode04,ode05,ode06,ode07,ode071,ode08,ode09,ode10,ode14 ",
       "  FROM ode_file ",
       "  WHERE ode01=? AND ode02=? ",
       "   AND ode03=? AND ode04=? ",
       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i161_bc3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ode WITHOUT DEFAULTS FROM s_ode.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           CALL i161_set_entry('u')
           CALL i161_set_no_entry('u')
 
       BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           OPEN i161_cl USING g_odc.odc01,g_odc.odc02
           IF STATUS THEN
              CALL cl_err("OPEN i161_cl:", STATUS, 1)
              CLOSE i161_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i161_cl INTO g_odc.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b1>=l_ac THEN
              LET g_ode_t.* = g_ode[l_ac].*  #BACKUP
              LET p_cmd='u'
 
              OPEN i161_bc3 USING g_odc.odc01,g_odc.odc02,g_odd03,g_ode_t.ode04
              IF STATUS THEN
                 CALL cl_err("OPEN i161_bc3:", STATUS, 1)
                 CLOSE i161_bc3
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH i161_bc3 INTO g_ode[l_ac].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ode_t.ode04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ode[l_ac].* = g_ode_t.*
              CLOSE i161_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ode[l_ac].ode04,-263,1)
              LET g_ode[l_ac].* = g_ode_t.*
           ELSE
              UPDATE ode_file SET ode08 = g_ode[l_ac].ode08,
                                  ode09 = g_ode[l_ac].ode09,
                                  ode13 = g_ode[l_ac].ode08*g_ode[l_ac].ode10,
                                  ode14 = g_ode[l_ac].ode09*g_ode[l_ac].ode10
               WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
                 AND ode03=g_odd03 AND ode04=g_ode[l_ac].ode04
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ode[l_ac].ode04,SQLCA.sqlcode,0) #No.FUN-660104
                 CALL cl_err3("upd","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_ode[l_ac].* = g_ode_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                #start FUN-630092 add
                 SELECT SUM(ode14) INTO l_ode14_1 FROM ode_file
                  WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
                 IF STATUS THEN LET l_ode14_1 = 0 END IF
                 DISPLAY l_ode14_1 TO FORMONLY.ode14_1
                #end FUN-630092 add
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           CALL g_ode.deleteElement(g_rec_b1+1) #MOD-490200
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ode[l_ac].* = g_ode_t.*
              END IF
              CLOSE i161_bc3
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i161_bc3
           COMMIT WORK
 
       AFTER FIELD ode08
           IF g_ode[l_ac].ode08 < 0 THEN
              CALL cl_err(g_ode[l_ac].ode08,'mfg5034',1)
              NEXT FIELD ode08
           ELSE
              LET g_ode[l_ac].ode09 = g_ode[l_ac].ode06+g_ode[l_ac].ode07+
                                      g_ode[l_ac].ode071+g_ode[l_ac].ode08
              LET g_ode[l_ac].ode14 = g_ode[l_ac].ode09 * g_ode[l_ac].ode10
              DISPLAY BY NAME g_ode[l_ac].ode09,g_ode[l_ac].ode10
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
   END INPUT
 
   CLOSE i161_bc3
   COMMIT WORK
END FUNCTION
 
FUNCTION i161_b1_fill()
 
   DECLARE i161_1_c1 CURSOR FOR
      SELECT odd03,odd04,odd07,odd08,odd09 FROM odd_file
       WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
       ORDER BY odd03
 
   CALL g_odd1.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH i161_1_c1 INTO g_odd1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_odd1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
 #  LET g_cnt = 1         #FUN-AA0059  mark by huangtao
   IF g_cnt > 0 THEN      #FUN-AA0059  add by huangtao
      LET g_cnt = 1       #FUN-AB0025  add
      CALL i161_b1_fill_1(g_odd1[g_cnt].odd03)
   END IF                 #FUN-AA0059  add by huangtao
END FUNCTION
 
FUNCTION i161_b1_fill_1(l_odd03)
   DEFINE l_odd03  LIKE odd_file.odd03,
          l_qty  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
          l_amt  LIKE type_file.num20_6           #No.FUN-680120 DECIMAL(20,6)
 
   DECLARE i161_1_c2 CURSOR FOR
      SELECT ode04,ode05,ode06,ode07,ode071,ode08,ode09,ode10,ode14,ode15 #FUN-730069
        FROM ode_file
       WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
         AND ode03 = l_odd03
       ORDER BY ode04
 
   CALL g_ode.clear()
 
   LET g_rec_b1 = 0
   LET g_cnt = 1
   FOREACH i161_1_c2 INTO g_ode[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_ode[g_cnt].ode05)  THEN LET g_ode[g_cnt].ode05=0  END IF
      IF cl_null(g_ode[g_cnt].ode06)  THEN LET g_ode[g_cnt].ode06=0  END IF
      IF cl_null(g_ode[g_cnt].ode07)  THEN LET g_ode[g_cnt].ode07=0  END IF
      IF cl_null(g_ode[g_cnt].ode071) THEN LET g_ode[g_cnt].ode071=0 END IF
      IF cl_null(g_ode[g_cnt].ode08)  THEN LET g_ode[g_cnt].ode08=0  END IF
      IF cl_null(g_ode[g_cnt].ode09)  THEN LET g_ode[g_cnt].ode09=0  END IF
      IF cl_null(g_ode[g_cnt].ode10)  THEN LET g_ode[g_cnt].ode10=0  END IF
      IF cl_null(g_ode[g_cnt].ode14)  THEN LET g_ode[g_cnt].ode14=0  END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_ode.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   
   SELECT SUM(ode09),SUM(ode14) INTO l_qty,l_amt FROM ode_file
    WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
   DISPLAY l_qty,l_amt TO FORMONLY.tqty,FORMONLY.tamt
 
END FUNCTION
 
FUNCTION i161_bp1_refresh()
  DISPLAY ARRAY g_ode TO s_ode.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION i161_b2_fill()
 
   DECLARE i161_2_c1 CURSOR FOR
      SELECT odd03,odd04,odd07,odd08,odd09,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,0,0
        FROM odd_file
       WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02 
 
   CALL g_odd2.clear()
   LET g_rec_b1 = 0
   CALL i161_tot_0()   #將合計欄位值清成0
 
   LET g_cnt = 1
   FOREACH i161_2_c1 INTO g_odd2[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i161_b2_title_set(g_odd2[g_cnt].odd03,g_cnt)
 
      LET g_cnt=g_cnt+1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_odd2.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn4
 
   DISPLAY g_tot.* 
   TO FORMONLY.tot1a, FORMONLY.tot2a, FORMONLY.tot3a, FORMONLY.tot4a, FORMONLY.tot5a,
      FORMONLY.tot6a, FORMONLY.tot7a, FORMONLY.tot8a, FORMONLY.tot9a, FORMONLY.tot10a,
      FORMONLY.tot11a,FORMONLY.tot12a,FORMONLY.tot13a,FORMONLY.tot14a,FORMONLY.tot15a,
      FORMONLY.tot16a,FORMONLY.tot17a,FORMONLY.tot18a,FORMONLY.tot19a,FORMONLY.tot20a,
      FORMONLY.tot21a,FORMONLY.tot22a,FORMONLY.tot23a,FORMONLY.tot24a,FORMONLY.tot25a,
      FORMONLY.tot26a,FORMONLY.tot27a,FORMONLY.tot28a,FORMONLY.tot29a,FORMONLY.tot30a,
      FORMONLY.tot31a,FORMONLY.tot32a
 
END FUNCTION
 
FUNCTION i161_bp2_refresh()
  DISPLAY ARRAY g_odd2 TO s_odd2.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION i161_b3_fill()
 
   DECLARE i161_3_c1 CURSOR FOR
      SELECT odd03,odd04,odd07,odd08,odd09,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,0,0
        FROM odd_file
       WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02 
 
   CALL g_odd3.clear()
   LET g_rec_b1 = 0
   CALL i161_tot_0()   #將合計欄位值清成0
 
   LET g_cnt = 1
   FOREACH i161_3_c1 INTO g_odd3[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i161_b3_title_set(g_odd3[g_cnt].odd03,g_cnt)
 
      LET g_cnt=g_cnt+1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
   CALL g_odd3.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn5
 
   DISPLAY g_tot.* 
   TO FORMONLY.tot1b, FORMONLY.tot2b, FORMONLY.tot3b, FORMONLY.tot4b, FORMONLY.tot5b,
      FORMONLY.tot6b, FORMONLY.tot7b, FORMONLY.tot8b, FORMONLY.tot9b, FORMONLY.tot10b,
      FORMONLY.tot11b,FORMONLY.tot12b,FORMONLY.tot13b,FORMONLY.tot14b,FORMONLY.tot15b,
      FORMONLY.tot16b,FORMONLY.tot17b,FORMONLY.tot18b,FORMONLY.tot19b,FORMONLY.tot20b,
      FORMONLY.tot21b,FORMONLY.tot22b,FORMONLY.tot23b,FORMONLY.tot24b,FORMONLY.tot25b,
      FORMONLY.tot26b,FORMONLY.tot27b,FORMONLY.tot28b,FORMONLY.tot29b,FORMONLY.tot30b,
      FORMONLY.tot31b,FORMONLY.tot32b
 
END FUNCTION
 
FUNCTION i161_bp3_refresh()
  DISPLAY ARRAY g_odd3 TO s_odd3.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
#No.FUN-A40055--begin
FUNCTION i161_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN   #FUN-D30033 add detail
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)    
   DISPLAY ARRAY g_odd1 TO s_odd1.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            CALL i161_b1_fill_1(g_odd1[l_ac].odd03)
#            CALL i161_bp1_refresh()
         END IF
   END DISPLAY 
   DISPLAY ARRAY g_ode TO s_ode.* ATTRIBUTE(COUNT = g_rec_b1)
   END DISPLAY   
   DISPLAY ARRAY g_odd2 TO s_odd2.* ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
   END DISPLAY 
   
   DISPLAY ARRAY g_odd3 TO s_odd3.* ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR() 
   END DISPLAY         
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END       
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

#TQC-AC0081
      ON ACTION accept 
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
#TQC-AC0081
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
 
      ON ACTION first
         CALL i161_fetch('F')
         EXIT DIALOG
 
      ON ACTION previous
         CALL i161_fetch('P')
         EXIT DIALOG
 
      ON ACTION jump
         CALL i161_fetch('/')
         EXIT DIALOG
 
      ON ACTION next
         CALL i161_fetch('N')
         EXIT DIALOG
 
      ON ACTION last
         CALL i161_fetch('L')
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc12,"","","","","")
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DIALOG
 
      #@WHEN "時距明細"
      ON ACTION bucket_detail
         LET g_action_choice="bucket_detail"
         EXIT DIALOG
 
      #@WHEN "明細預測總數量"
      ON ACTION forecast_total_qty_detail
         LET g_action_choice="forecast_total_qty_detail"
         EXIT DIALOG
 
      #@WHEN "明細預測總金額"
      ON ACTION forecast_total_amt_detail
         LET g_action_choice="forecast_total_amt_detail"
         EXIT DIALOG
 
      #@WHEN "銷售預測產生"
      ON ACTION gen_sales_forecast
         LET g_action_choice="gen_sales_forecast"
         EXIT DIALOG
 
      #@WHEN "明細維護"
      ON ACTION mantain_detail
         LET g_action_choice="mantain_detail"
         #TQC-B20164--begin
         IF NOT cl_null(g_odc.odc01) THEN 
            LET g_odd03 = g_odd1[l_ac].odd03
            LET g_odd04 = g_odd1[l_ac].odd04
         END IF 
         #TQC-B20164--end
         EXIT DIALOG
 
      #@WHEN "明細查詢"
      #No.FUN-A40055--begin
      #ON ACTION query_detail
      #   LET g_action_choice="query_detail"
      #   EXIT DIALOG
      #No.FUN-A40055--end 
      #@WHEN "預測確認"
      ON ACTION confirm_forecast
         LET g_action_choice="confirm_forecast"
         EXIT DIALOG
 
      #@WHEN "預測取消確認"
      ON ACTION undo_confirm_forecast
         LET g_action_choice="undo_confirm_forecast"
         EXIT DIALOG
 
      #@WHEN "目標數量調整"
      ON ACTION adjust_target_qty
         LET g_action_choice="adjust_target_qty"
         #TQC-B20164--begin
         IF NOT cl_null(g_odc.odc01) THEN 
            LET g_odd03 = g_odd1[l_ac].odd03
            LET g_odd04 = g_odd1[l_ac].odd04
         END IF 
         #TQC-B20164--end
         EXIT DIALOG
 
      #@WHEN "目標數量確認"
      ON ACTION confirm_target_qty
         LET g_action_choice="confirm_target_qty"
         EXIT DIALOG
 
      #@WHEN "目標數量取消確認"
      ON ACTION undo_confirm_target_qty
         LET g_action_choice="undo_confirm_target_qty"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION  

#FUNCTION i161_bp1(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
# 
#   IF p_ud <> "G" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_odd1 TO s_odd1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         IF l_ac != 0 THEN
#            CALL i161_b1_fill_1(g_odd1[l_ac].odd03)
#            CALL i161_bp1_refresh()
#         END IF
##NO.FUN-6B0031--BEGIN                                                                                                               
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
##NO.FUN-6B0031--END       
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#  
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
# 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
# 
#      ON ACTION first
#         CALL i161_fetch('F')
#         EXIT DISPLAY
# 
#      ON ACTION previous
#         CALL i161_fetch('P')
#         EXIT DISPLAY
# 
#      ON ACTION jump
#         CALL i161_fetch('/')
#         EXIT DISPLAY
# 
#      ON ACTION next
#         CALL i161_fetch('N')
#         EXIT DISPLAY
# 
#      ON ACTION last
#         CALL i161_fetch('L')
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()   #FUN-550037(smin)
#         #圖形顯示
#         CALL cl_set_field_pic(g_odc.odc12,"","","","","")
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      #@WHEN "時距明細"
#      ON ACTION bucket_detail
#         LET g_action_choice="bucket_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "明細預測總數量"
#      ON ACTION forecast_total_qty_detail
#         LET g_action_choice="forecast_total_qty_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "明細預測總金額"
#      ON ACTION forecast_total_amt_detail
#         LET g_action_choice="forecast_total_amt_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "銷售預測產生"
#      ON ACTION gen_sales_forecast
#         LET g_action_choice="gen_sales_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "明細維護"
#      ON ACTION mantain_detail
#         LET g_action_choice="mantain_detail"
#         LET g_odd03 = g_odd1[l_ac].odd03
#         LET g_odd04 = g_odd1[l_ac].odd04
#         EXIT DISPLAY
# 
#      #@WHEN "明細查詢"
#      ON ACTION query_detail
#         LET g_action_choice="query_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "預測確認"
#      ON ACTION confirm_forecast
#         LET g_action_choice="confirm_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "預測取消確認"
#      ON ACTION undo_confirm_forecast
#         LET g_action_choice="undo_confirm_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量調整"
#      ON ACTION adjust_target_qty
#         LET g_action_choice="adjust_target_qty"
#         LET g_odd03 = g_odd1[l_ac].odd03
#         LET g_odd04 = g_odd1[l_ac].odd04
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量確認"
#      ON ACTION confirm_target_qty
#         LET g_action_choice="confirm_target_qty"
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量取消確認"
#      ON ACTION undo_confirm_target_qty
#         LET g_action_choice="undo_confirm_target_qty"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#      
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#      
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION related_document                #No.FUN-6B0043  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
# 
#      #No.FUN-7C0050 add
#      &include "qry_string.4gl"
# 
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", TRUE)
# 
#END FUNCTION
 
#FUNCTION i161_bp2(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
# 
#   IF p_ud <> "G" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
#   DISPLAY ARRAY g_odd2 TO s_odd2.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
##NO.FUN-6B0031--BEGIN                                                                                                               
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
##NO.FUN-6B0031--END       
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#  
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
# 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
# 
#      ON ACTION first
#         CALL i161_fetch('F')
#         EXIT DISPLAY
# 
#      ON ACTION previous
#         CALL i161_fetch('P')
#         EXIT DISPLAY
# 
#      ON ACTION jump
#         CALL i161_fetch('/')
#         EXIT DISPLAY
# 
#      ON ACTION next
#         CALL i161_fetch('N')
#         EXIT DISPLAY
# 
#      ON ACTION last
#         CALL i161_fetch('L')
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()   #FUN-550037(smin)
#         #圖形顯示
#         CALL cl_set_field_pic(g_odc.odc12,"","","","","")
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      #@WHEN "時距明細"
#      ON ACTION bucket_detail
#         LET g_action_choice="bucket_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "明細預測總數量"
#      ON ACTION forecast_total_qty_detail
#         LET g_action_choice="forecast_total_qty_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "明細預測總金額"
#      ON ACTION forecast_total_amt_detail
#         LET g_action_choice="forecast_total_amt_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "銷售預測產生"
#      ON ACTION gen_sales_forecast
#         LET g_action_choice="gen_sales_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "明細維護"
#      ON ACTION mantain_detail
#         LET g_action_choice="mantain_detail"
#         LET g_odd03 = g_odd1[l_ac].odd03
#         LET g_odd04 = g_odd1[l_ac].odd04
#         EXIT DISPLAY
# 
#      #@WHEN "明細查詢"
#      ON ACTION query_detail
#         LET g_action_choice="query_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "預測確認"
#      ON ACTION confirm_forecast
#         LET g_action_choice="confirm_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "預測取消確認"
#      ON ACTION undo_confirm_forecast
#         LET g_action_choice="undo_confirm_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量調整"
#      ON ACTION adjust_target_qty
#         LET g_action_choice="adjust_target_qty"
#         LET g_odd03 = g_odd1[l_ac].odd03
#         LET g_odd04 = g_odd1[l_ac].odd04
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量確認"
#      ON ACTION confirm_target_qty
#         LET g_action_choice="confirm_target_qty"
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量取消確認"
#      ON ACTION undo_confirm_target_qty
#         LET g_action_choice="undo_confirm_target_qty"
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#      
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#      
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION related_document                #No.FUN-6B0043  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
# 
#      #No.FUN-7C0050 add
#      &include "qry_string.4gl"
# 
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", TRUE)
# 
#END FUNCTION
 
#FUNCTION i161_bp3(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
# 
#   IF p_ud <> "G" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A0139
#   DISPLAY ARRAY g_odd3 TO s_odd3.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
##NO.FUN-6B0031--BEGIN                                                                                                               
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
##NO.FUN-6B0031--END       
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#  
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
# 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
# 
#      ON ACTION first
#         CALL i161_fetch('F')
#         EXIT DISPLAY
# 
#      ON ACTION previous
#         CALL i161_fetch('P')
#         EXIT DISPLAY
# 
#      ON ACTION jump
#         CALL i161_fetch('/')
#         EXIT DISPLAY
# 
#      ON ACTION next
#         CALL i161_fetch('N')
#         EXIT DISPLAY
# 
#      ON ACTION last
#         CALL i161_fetch('L')
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()   #FUN-550037(smin)
#         #圖形顯示
#         CALL cl_set_field_pic(g_odc.odc12,"","","","","")
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      #@WHEN "時距明細"
#      ON ACTION bucket_detail
#         LET g_action_choice="bucket_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "明細預測總數量"
#      ON ACTION forecast_total_qty_detail
#         LET g_action_choice="forecast_total_qty_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "明細預測總金額"
#      ON ACTION forecast_total_amt_detail
#         LET g_action_choice="forecast_total_amt_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "銷售預測產生"
#      ON ACTION gen_sales_forecast
#         LET g_action_choice="gen_sales_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "明細維護"
#      ON ACTION mantain_detail
#         LET g_action_choice="mantain_detail"
#         LET g_odd03 = g_odd1[l_ac].odd03
#         LET g_odd04 = g_odd1[l_ac].odd04
#         EXIT DISPLAY
# 
#      #@WHEN "明細查詢"
#      ON ACTION query_detail
#         LET g_action_choice="query_detail"
#         EXIT DISPLAY
# 
#      #@WHEN "預測確認"
#      ON ACTION confirm_forecast
#         LET g_action_choice="confirm_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "預測取消確認"
#      ON ACTION undo_confirm_forecast
#         LET g_action_choice="undo_confirm_forecast"
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量調整"
#      ON ACTION adjust_target_qty
#         LET g_action_choice="adjust_target_qty"
#         LET g_odd03 = g_odd1[l_ac].odd03
#         LET g_odd04 = g_odd1[l_ac].odd04
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量確認"
#      ON ACTION confirm_target_qty
#         LET g_action_choice="confirm_target_qty"
#         EXIT DISPLAY
# 
#      #@WHEN "目標數量取消確認"
#      ON ACTION undo_confirm_target_qty
#         LET g_action_choice="undo_confirm_target_qty"
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#      
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#      
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION related_document                #No.FUN-6B0043  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
# 
#      #No.FUN-7C0050 add
#      &include "qry_string.4gl"
# 
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", TRUE)
# 
#END FUNCTION
#No.FUN-A40055--END 
FUNCTION i161_bp1_1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept", FALSE)
   DISPLAY ARRAY g_ode TO s_ode.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         #圖形顯示
         CALL cl_set_field_pic(g_odc.odc12,"","","","","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
 
   LET g_action_choice = " "
   IF INT_FLAG THEN LET INT_FLAG = FALSE END IF
   CALL cl_set_act_visible("accept", TRUE)
 
END FUNCTION
 
#start FUN-640268 add
FUNCTION i161_gen()
   DEFINE tm          RECORD
                       a      LIKE odb_file.odb01,
                       a_desc LIKE odb_file.odb02, 
                       b      LIKE tqb_file.tqb01,
                       b_desc LIKE tqb_file.tqb02, 
                       c      LIKE type_file.chr1,             #No.FUN-680120  VARCHAR(1)
                       d1     LIKE odc_file.odc05,
                       d2     LIKE odc_file.odc06,
                       e      LIKE odc_file.odc01,
                       e_desc LIKE odb_file.odb02, 
                       f      LIKE odc_file.odc02,
                       f_desc LIKE tqb_file.tqb02, 
                       g      LIKE type_file.chr1              #No.FUN-680120  VARCHAR(1)  
                      END RECORD,
          l_flag      LIKE type_file.num5                      #No.FUN-680120  SMALLINT
 
   OPEN WINDOW i161_gen_w AT p_row,p_col WITH FORM "atm/42f/atmi161_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("atmi161_g")
 
   WHILE TRUE 
      INPUT BY NAME tm.a,tm.a_desc,tm.b,tm.b_desc,
                    tm.c,tm.d1,tm.d2,
                    tm.e,tm.e_desc,tm.f,tm.f_desc,
                    tm.g WITHOUT DEFAULTS
         BEFORE INPUT
            LET tm.d1 = ''
            LET tm.d2 = ''
            DISPLAY tm.d1,tm.d2 TO FORMONLY.d1,FORMONLY.d2
 
         AFTER FIELD a
            IF cl_null(tm.a) THEN 
               CALL cl_err('','mfg5103',0)
               NEXT FIELD a 
            ELSE
               SELECT odb02 INTO tm.a_desc FROM odb_file WHERE odb01=tm.a
               IF STATUS THEN
                  LET tm.a_desc = ''
#                 CALL cl_err(tm.a,'mfg-012',0) #No.FUN-660104
                  CALL cl_err3("sel","odb_file",tm.a,"","mfg-012","","",1)  #No.FUN-660104
                  NEXT FIELD a
               END IF
               DISPLAY tm.a_desc TO FORMONLY.a_desc
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) THEN 
               CALL cl_err('','mfg5103',0)
               NEXT FIELD b 
            ELSE
               SELECT tqb02 INTO tm.b_desc FROM tqb_file WHERE tqb01=tm.b
               IF STATUS THEN
                  LET tm.b_desc = ''
#                 CALL cl_err(tm.b,'mfg-012',0)  #No.FUN-660104
                  CALL cl_err3("sel","tqb_file",tm.b,"","mfg-012","","",1)  #No.FUN-660104
                  NEXT FIELD b
               END IF
               DISPLAY tm.b_desc TO FORMONLY.b_desc
            END IF
 
         AFTER FIELD c
            IF tm.c NOT MATCHES '[1-4]' THEN #FUN-730069
               CALL cl_err('','-1152',0)
               NEXT FIELD c
            END IF
            #FUN-730069................begin            
            IF tm.c="4" THEN
               CALL cl_set_comp_required("d1,d2,e,f,g",FALSE)
               CALL cl_set_comp_entry("d1,d2,e,f,g",FALSE)
            ELSE
               CALL cl_set_comp_required("d1,d2,e,f,g",TRUE)
               CALL cl_set_comp_entry("d1,d2,e,f,g",TRUE)
            END IF
            #FUN-730069................end
 
         AFTER FIELD d1
            IF NOT cl_null(tm.d1) THEN 
               IF NOT cl_null(tm.d2) AND tm.d2 < tm.d1 THEN
                  CALL cl_err('','mfg6164',0)
                  NEXT FIELD d1
               END IF
            ELSE
               CALL cl_err('','mfg5103',0)
               NEXT FIELD d1
            END IF
 
         AFTER FIELD d2
            IF NOT cl_null(tm.d2) THEN 
               IF NOT cl_null(tm.d1) AND tm.d2 < tm.d1 THEN
#                  CALL cl_err('','apy-065',0)       #CHI-B40058
                  CALL cl_err('','atm-269',0)        #CHI-B40058
                  NEXT FIELD d2
               END IF
            ELSE
               CALL cl_err('','mfg5103',0)
               NEXT FIELD d1
            END IF
 
         AFTER FIELD e
            IF cl_null(tm.e) THEN 
               CALL cl_err('','mfg5103',0)
               NEXT FIELD e 
            ELSE
               SELECT odb02 INTO tm.e_desc FROM odb_file WHERE odb01=tm.e
               IF STATUS THEN
                  LET tm.e_desc = ''
#                 CALL cl_err(tm.e,'mfg-012',0)   #No.FUN-660104
                  CALL cl_err3("sel","odb_file",tm.e,"","mfg-012","","",1)  #No.FUN-660104
                  NEXT FIELD e
               END IF
               DISPLAY tm.e_desc TO FORMONLY.e_desc
            END IF
 
         AFTER FIELD f
            IF cl_null(tm.f) THEN 
               CALL cl_err('','mfg5103',0)
               NEXT FIELD f 
            ELSE
               SELECT tqb02 INTO tm.f_desc FROM tqb_file WHERE tqb01=tm.f
               IF STATUS THEN
                  LET tm.f_desc = ''
#                 CALL cl_err(tm.f,'mfg-012',0)  #No.FUN-660104
                  CALL cl_err3("sel","tqb_file",tm.f,"","mfg-012","","",1)  #No.FUN-660104
                  NEXT FIELD f
               END IF
               DISPLAY tm.f_desc TO FORMONLY.f_desc
            END IF
 
         AFTER FIELD g
            IF tm.g NOT MATCHES '[1-2]' THEN
               CALL cl_err('','-1152',0)
               NEXT FIELD g
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(a)  #預測版本
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_odb"
                  LET g_qryparam.default1 = tm.a
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY tm.a TO FORMONLY.a
               WHEN INFIELD(b)  #下層組織
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqb"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO FORMONLY.b
               WHEN INFIELD(e)  #來源版本
                  LET g_qryparam.form  = "q_odb"
                  LET g_qryparam.default1 = tm.e
                  CALL cl_create_qry() RETURNING tm.e
                  DISPLAY tm.e TO FORMONLY.e
                  CALL cl_init_qry_var()
               WHEN INFIELD(f)  #來源組織
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqb"
                  LET g_qryparam.default1 = tm.f
                  CALL cl_create_qry() RETURNING tm.f
                  DISPLAY tm.f TO FORMONLY.f
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i161_gen_w
         RETURN
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i161_gen_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'
 
         CALL i161_gen1(tm.*)
 
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE
 
   CLOSE WINDOW i161_gen_w
 
END FUNCTION
 
FUNCTION i161_gen1(tm)
   DEFINE tm          RECORD
                       a      LIKE odb_file.odb01,
                       a_desc LIKE odb_file.odb02, 
                       b      LIKE tqb_file.tqb01,
                       b_desc LIKE tqb_file.tqb02, 
                       c      LIKE type_file.chr1,             #No.FUN-680120  VARCHAR(1)
                       d1     LIKE odc_file.odc05,
                       d2     LIKE odc_file.odc06,
                       e      LIKE odc_file.odc01,
                       e_desc LIKE odb_file.odb02, 
                       f      LIKE odc_file.odc02,
                       f_desc LIKE tqb_file.tqb02, 
                       g      LIKE type_file.chr1              #No.FUN-680120  VARCHAR(1)
                      END RECORD,
          l_odb       RECORD LIKE odb_file.*,     #集團銷售預測版本資料檔
          l_odc       RECORD LIKE odc_file.*,     #集團銷售預測資料單頭檔
          l_odd       RECORD LIKE odd_file.*,     #集團銷售預測資料單身檔
          l_ode       DYNAMIC ARRAY OF RECORD LIKE ode_file.*,
          l_sql       STRING,
          l_tqd03     LIKE tqd_file.tqd03,        #下級組織機構代碼
          l_tqb04     LIKE tqb_file.tqb04,        #是否記錄營運中心
          l_tqb05     LIKE tqb_file.tqb05,        #營運中心代碼
          l_aza17     LIKE aza_file.aza17,        #本國幣別
          l_oaz52     LIKE oaz_file.oaz52,        #內銷使用匯率 B/S/M/C/D
          l_ogb12     LIKE ogb_file.ogb12,        #實際出貨數量
          l_ogb05_fac LIKE ogb_file.ogb05_fac,    #銷售/庫存彙總單位換算率
          l_ima98     LIKE ima_file.ima98,        #月加權平均售價
          l_ode05     LIKE ode_file.ode05,
          i,j,k       LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          l_mm        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #月
          l_dd        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #日
          l_yy        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #年
          date1       LIKE type_file.dat,              #No.FUN-680120 DATE
          date2       LIKE type_file.dat               #No.FUN-680120 DATE
 
  #IF tm.c MATCHES '[13]' THEN #FUN-730069
   CASE  #FUN-730069
      WHEN tm.c MATCHES '[13]' #FUN-730069
         SELECT * INTO l_odb.* FROM odb_file WHERE odb01=tm.a
         
         LET l_sql="SELECT tqd03,tqb04,tqb05 ",
                   "  FROM tqd_file,tqb_file ",
                   " WHERE tqd01 = '",l_odb.odb07,"' ",   #最上層組織
                   "   AND tqd03 = '",tm.b,"' ",
                   "   AND tqb01 = tqd03 "
         PREPARE i161_gen_pre1 FROM l_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err('i161_gen_pre1',SQLCA.SQLCODE,1)
            LET g_success='N'
            RETURN
         END IF
         DECLARE i161_gen_c1 CURSOR FOR i161_gen_pre1
         FOREACH i161_gen_c1 INTO l_tqd03,l_tqb04,l_tqb05
            IF l_tqb04='N' THEN            #是否記錄營運中心
               LET g_plant_new = g_plant
            ELSE
               LET g_plant_new = l_tqb05   #營運中心代碼
            END IF
            #CALL s_getdbs() #FUN-A50102 mark 
            #LET g_dbs_atm = g_dbs_new CLIPPED
           # FUN-980091 add----GP5.2 Modify #改抓Transaction DB
            #LET l_plant_new = g_plant_new
            #CALL s_gettrandbs() #FUN-A50102 mark
            #LET g_dbs_atm_tra = g_dbs_tra
           #--End   FUN-980091 add-------------------------------------
         
            #幣別
            #LET l_sql="SELECT aza17 FROM ",g_dbs_atm,"aza_file" #FUN-A50102
            LET l_sql="SELECT aza17 FROM ",cl_get_target_table(g_plant_new, 'aza_file') #FUN-A50102
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	          CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102
            PREPARE i161_aza_p FROM l_sql
            IF STATUS THEN CALL cl_err('i161_aza_p',STATUS,1) END IF
            DECLARE i161_aza_c CURSOR FOR i161_aza_p
            OPEN i161_aza_c
            FETCH i161_aza_c INTO l_aza17
         
            #內銷使用匯率 B/S/M/C/D
            #LET l_sql="SELECT oaz52 FROM ",g_dbs_atm,"oaz_file" #FUN-A50102
            LET l_sql="SELECT oaz52 FROM ",cl_get_target_table(g_plant_new, 'oaz_file') #FUN-A50102
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	          CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102
            PREPARE i161_oaz_p FROM l_sql
            IF STATUS THEN CALL cl_err('i161_oaz_p',STATUS,1) END IF
            DECLARE i161_oaz_c CURSOR FOR i161_oaz_p
            OPEN i161_oaz_c
            FETCH i161_oaz_c INTO l_oaz52
         
            #匯率
            CALL s_curr3(l_aza17,g_today,l_oaz52) RETURNING l_odc.odc10
         
            #---------------INSERT HEAD---------------
            LET l_odc.odc01  =tm.a
            LET l_odc.odc02  =tm.b
            LET l_odc.odc04  =l_odb.odb04
            LET l_odc.odc05  =l_odb.odb05
            LET l_odc.odc06  =l_odb.odb06
            LET l_odc.odc07  =g_user
            LET l_odc.odc08  =g_grup
            LET l_odc.odc09  =l_aza17
            LET l_odc.odc11  =0
            LET l_odc.odc12  ='N'
            LET l_odc.odc121 ='N'
            LET l_odc.odc13  ='N'
            LET l_odc.odc131 ='N'
            LET l_odc.odc27  =tm.c #FUN-730069
            LET l_odc.odcuser=g_user
            LET l_odc.odcgrup=g_grup
            LET l_odc.odcmodu=''
            LET l_odc.odcdate=g_today                 
            LET l_odc.odcoriu = g_user      #No.FUN-980030 10/01/04
            LET l_odc.odcorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO odc_file VALUES(l_odc.*)
            IF STATUS THEN
#              CALL cl_err('ins odc:',STATUS,1) #No.FUN-660104
               CALL cl_err3("ins","odc_file",l_odc.odc01,l_odc.odc02,STATUS,"","ins odc:",1)  #No.FUN-660104
               LET g_success='N'
               RETURN
            END IF
         
            LET l_sql="SELECT ogb04,ima02,ima021,ima25,ogb12,ogb05_fac,ima98 ",
                      #"  FROM ",g_dbs_atm,"oga_file,",g_dbs_atm,"ogb_file,", #FUN-980091 mark
                      #          g_dbs_atm,"occ_file,",g_dbs_atm,"ima_file ", #FUN-980091 mark
                      "  FROM ",cl_get_target_table(g_plant_new, 'oga_file'),",",cl_get_target_table(g_plant_new, 'ogb_file'),",", #FUN-980091 add
                                cl_get_target_table(g_plant_new, 'occ_file'),",",cl_get_target_table(g_plant_new, 'ima_file'), #FUN-980091 add
                      " WHERE oga01=ogb01 ",
                      "   AND ogb04 NOT MATCHES 'MISC*' ",
                      "   AND occ01=oga03 ",
                      "   AND occ1005='",tm.b,"' ",
                      "   AND ogb04=ima01 ",
                      "   AND oga02 between '",tm.d1,"' AND '",tm.d2,"'",
                      "   AND ogaconf='Y' ",
                      "   AND ogapost='Y' ",
                      "   AND oga09 IN ('2','3','4','6','8') ",
                      " ORDER BY ogb04,ima25"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980091
            PREPARE i161_gen_pre2 FROM l_sql
            DECLARE i161_gen_c2 CURSOR FOR i161_gen_pre2
            FOREACH i161_gen_c2 INTO l_odd.odd04,l_odd.odd07,l_odd.odd08,
                                     l_odd.odd09,l_ogb12,l_ogb05_fac,l_ima98
               #---------------INSERT BODY1---------------
               IF l_odd.odd03 IS NULL OR l_odd.odd03 = 0 THEN
                  SELECT max(odd03)+1 INTO l_odd.odd03 FROM odd_file
                   WHERE odd01 = tm.a AND odd02 = tm.b
                  IF l_odd.odd03 IS NULL THEN LET l_odd.odd03 = 1 END IF
               END IF
         
               INSERT INTO odd_file (odd01,odd02,odd03,odd04,odd07,odd08,odd09)
                             VALUES (tm.a,tm.b,l_odd.odd03,l_odd.odd04,
                                     l_odd.odd07,l_odd.odd08,l_odd.odd09)
               IF STATUS THEN
#                 CALL cl_err('ins odd:',STATUS,1)  #No.FUN-660104
                  CALL cl_err3("ins","odd_file",tm.a,tm.b,STATUS,"","ins odd:",1)  #No.FUN-660104
                  LET g_success='N'
                  RETURN
               END IF
         
               #---------------INSERT BODY2---------------
               CASE l_odc.odc04   #計算期數
                  WHEN '1' #季
                     LET j=((YEAR(l_odc.odc06)-YEAR(l_odc.odc05))*12+MONTH(l_odc.odc06)-MONTH(l_odc.odc05)+1)/3
                  WHEN '2' #月
                     LET j=((YEAR(l_odc.odc06)-YEAR(l_odc.odc05))*12+MONTH(l_odc.odc06)-MONTH(l_odc.odc05)+1)
                  WHEN '3' #旬
                     LET j=((YEAR(l_odc.odc06)-YEAR(l_odc.odc05))*365+(MONTH(l_odc.odc06)-MONTH(l_odc.odc05)+1)*30)/10
                  WHEN '4' #週
                     LET j=((YEAR(l_odc.odc06)-YEAR(l_odc.odc05))*365+(MONTH(l_odc.odc06)-MONTH(l_odc.odc05)+1)*30)/7
                  WHEN '5' #天
                     LET j=l_odc.odc06-l_odc.odc05+1
               END CASE
               FOR i = 1 TO j
                  LET l_mm = MONTH(l_odc.odc05)
                  LET l_dd = DAY(l_odc.odc05)
                  LET l_yy = YEAR(l_odc.odc05)
                  CASE l_odc.odc04
                    WHEN '1' #季
                      IF i = 1 THEN
                         LET l_ode[i].ode04 = MDY(l_mm,1,l_yy)
                      ELSE
                         LET l_ode[i].ode04 = l_ode[i-1].ode04 + 3 UNITS MONTH
                      END IF                  
                      IF tm.c='1' THEN
                         LET date1 = l_ode[i].ode04 - 3*j UNITS MONTH
                      ELSE 
                         LET date1 = l_ode[i].ode04 - 1 UNITS YEAR
                      END IF
                      LET date2 = date1 + 3 UNITS MONTH - 1 UNITS DAY 
                    WHEN '2' #月
                      IF i = 1 THEN
                         LET l_ode[i].ode04 = MDY(l_mm,1,l_yy)
                      ELSE
                         LET l_ode[i].ode04 = l_ode[i-1].ode04 + 1 UNITS MONTH
                      END IF                  
                      IF tm.c='1' THEN
                         LET date1 = l_ode[i].ode04 - j UNITS MONTH
                      ELSE 
                         LET date1 = l_ode[i].ode04 - 1 UNITS YEAR
                      END IF
                      LET date2 = date1 + 1 UNITS MONTH - 1 UNITS DAY 
                    WHEN '3' #旬
                      IF i = 1 THEN
                         IF l_dd != 1 THEN
                            LET l_ode[i].ode04 = MDY(l_mm,1,l_yy)
                         ELSE
                            LET l_ode[i].ode04 = l_odc.odc05
                         END IF
                      ELSE
                         LET l_ode[i].ode04 = l_ode[i-1].ode04 + 10 UNITS DAY
                      END IF                 
                      LET k = i MOD 3
                      IF k = 1 THEN
                         LET l_mm = MONTH(g_ode[i].ode04)
                         LET l_dd = DAY(g_ode[i].ode04)
                         LET l_yy = YEAR(g_ode[i].ode04)
                         IF l_dd != 1 THEN
                            LET g_ode[i].ode04 = MDY(l_mm+1,1,l_yy) 
                         END IF
                      END IF
                      IF tm.c='1' THEN
                         LET date1 = l_ode[i].ode04 - 10*j UNITS DAY
                      ELSE 
                         LET date1 = l_ode[i].ode04 - 1 UNITS YEAR
                      END IF
                      LET date2 = date1 + 9 UNITS DAY
                    WHEN '4' #週
                      LET l_ode[i].ode04 = l_odc.odc05 + (i-1)*7 UNITS DAY
                      IF tm.c='1' THEN
                         LET date1 = l_ode[i].ode04 - 7*j UNITS DAY
                      ELSE 
                         LET date1 = l_ode[i].ode04 - 1 UNITS YEAR
                      END IF
                      LET date2 = date1 + 6 UNITS DAY
                    WHEN '5' #天
                      LET l_ode[i].ode04 = l_odc.odc05 + (i-1)*1 UNITS DAY
                      IF tm.c='1' THEN
                         LET date1 = l_ode[i].ode04 - j UNITS DAY
                      ELSE 
                         LET date1 = l_ode[i].ode04 - 1 UNITS YEAR
                      END IF
                      LET date2 = date1
                  END CASE
         
                  LET l_sql ="SELECT SUM(ogb12*ogb05_fac) ",
                             #"  FROM ",g_dbs_atm,"oga_file,",g_dbs_atm,"ogb_file,", #FUN-980091 mark
                             #          g_dbs_atm,"occ_file ", #FUN-980091 mark
                             #"  FROM ",g_dbs_atm_tra,"oga_file,",g_dbs_atm_tra,"ogb_file,", #FUN-980091 add #FUN-A50102
                             #          g_dbs_atm_tra,"occ_file ", #FUN-980091 add  #FUN-A50102
                             "  FROM ",cl_get_target_table(g_plant_new, 'oga_file'),",",cl_get_target_table(g_plant_new, 'ogb_file'),",", #FUN-980091 add #FUN-A50102
                                       cl_get_target_table(g_plant_new, 'occ_file'), #FUN-980091 add  #FUN-A50102
                             " WHERE oga01=ogb01",
                             "   AND ogb04='",l_odd.odd04,"'",
                             "   AND occ01=oga03 ",
                             "   AND occ1005='",tm.b,"'",
                             "   AND oga02 between '",date1,"' AND '",date2,"'",
                             "   AND ogaconf='Y'",
                             "   AND ogapost='Y'",
                             "   AND oga09 IN ('2','3','4','6','8')"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980091
                  PREPARE i161_gen_pre3 FROM l_sql
                  DECLARE i161_gen_c3 CURSOR FOR i161_gen_pre3
                  FOREACH i161_gen_c3 INTO l_ode05   #歷史量
                     IF cl_null(l_ode05) THEN LET l_ode05 = 0 END IF
                     INSERT INTO ode_file (ode01,ode02,ode03,ode031,ode04,
                                           ode05,ode06,ode07,ode071,ode08,
                                           ode09,ode10,ode11,ode12,ode121,
                                           ode13,ode14,ode15)
                                   VALUES (tm.a,tm.b,l_odd.odd03,l_odd.odd04,l_ode[i].ode04,
                                           l_ode05,0,0,0,0,
                                           l_ode05,l_ima98*l_odc.odc10,0,0,0,
                                           0,l_ode05*l_ima98*l_odc.odc10,0)
                     IF STATUS THEN
#                       CALL cl_err('ins ode:',STATUS,1)  #No.FUN-660104
                        CALL cl_err3("ins","ode_file",tm.a,tm.b,STATUS,"","ins ode:",1)  #No.FUN-660104
                        LET g_success='N'
                        RETURN
                     END IF
                  END FOREACH
               END FOR
            END FOREACH
         END FOREACH
   #ELSE                             #tm.c='2' 前期預測歷史 #FUN-730069
      WHEN tm.c MATCHES '[2]' #FUN-730069
         #---------------INSERT HEAD---------------
         DROP TABLE y
         SELECT * FROM odc_file
          WHERE odc01=tm.e AND odc02=tm.f
           INTO TEMP y
         UPDATE y
            SET odc01  =tm.a,     #預測版本
                odc02  =tm.b,     #組織代號
                odc12  ='N',
                odc121 ='N',
                odc13  ='N',
                odc131 ='N',
                odcuser=g_user,   #資料所有者
                odcgrup=g_grup,   #資料所有者所屬群
                odcmodu=NULL,     #資料修改日期
                odcdate=g_today   #資料建立日期
         INSERT INTO odc_file SELECT * FROM y
         IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins odc: ',SQLCA.SQLCODE,1) #No.FUN-660104
            CALL cl_err3("ins","odc_file",tm.a,tm.b,SQLCA.sqlcode,"","ins odc:",1)  #No.FUN-660104
            LET g_success='N'
            RETURN
         END IF
       
         #---------------INSERT BODY1---------------
         DROP TABLE x1
         SELECT * FROM odd_file
          WHERE odd01=tm.e AND odd02=tm.f
           INTO TEMP x1
         UPDATE x1 SET odd01=tm.a,
                       odd02=tm.b
         INSERT INTO odd_file SELECT * FROM x1
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ins odd: ',SQLCA.SQLCODE,1)  #No.FUN-660104
            CALL cl_err3("ins","odd_file",tm.a,tm.b,SQLCA.sqlcode,"","ins odd:",1)  #No.FUN-660104
            LET g_success='N'
            RETURN
         END IF
       
         #---------------INSERT BODY2---------------
         DROP TABLE x2
         SELECT * FROM ode_file         #單身複製
          WHERE ode01=tm.e AND ode02=tm.f
           INTO TEMP x2
         UPDATE x2 SET ode01 = tm.a, 
                       ode02 = tm.b,
                       ode05 = ode09,
                       ode06 = 0,
                       ode07 = 0,
                       ode071= 0,
                       ode08 = 0,
                       ode09 = 0,
                       ode11 = 0,
                       ode12 = 0,
                       ode121= 0,
                       ode13 = 0,
                       ode14 = 0,
                       ode15 = 0  #FUN-730069
                      #ode14 = ode09*ode10
         INSERT INTO ode_file SELECT * FROM x2
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ins ode: ',SQLCA.SQLCODE,1)  #No.FUN-660104
            CALL cl_err3("ins","ode_file",tm.a,tm.b,SQLCA.sqlcode,"","ins ode:",1)  #No.FUN-660104
            LET g_success='N'
            RETURN
         END IF
  #END IF  #FUN-730069
      #FUN-730069...............begin
      WHEN tm.c MATCHES '[4]' 
         LET l_sql= "atmt500 '",tm.a,"' '",
                    tm.b,"'"
         CALL cl_cmdrun_wait(l_sql)
      #FUN-730069...............end
   END CASE #FUN-730069
 
END FUNCTION
#end FUN-640268 add
 
FUNCTION i161_y()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc12='Y' THEN 
      CALL cl_err('','9023',0) RETURN 
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM odd_file
    WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
 
   IF cl_confirm('axm-108') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN i161_cl USING g_odc.odc01,g_odc.odc02
      FETCH i161_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i161_cl ROLLBACK WORK RETURN
      END IF
      IF g_success = 'Y' THEN
         UPDATE odc_file SET odc12='Y'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
 
      CLOSE i161_cl
      IF g_success='N' THEN
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      #如果是最上層,直接將上層調整確認碼寫成Y
      SELECT COUNT(*) INTO g_cnt FROM odb_file
       WHERE odb01=g_odc.odc01 AND odb07=g_odc.odc02
      IF g_cnt != 0 THEN 
         UPDATE odc_file set odc121='Y'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            RETURN
         END IF
      END IF
 
      SELECT * INTO g_odc.* FROM odc_file
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      DISPLAY BY NAME g_odc.odc12,g_odc.odc121
   END IF
   CALL cl_set_field_pic(g_odc.odc12,"","","","","")
END FUNCTION
 
FUNCTION i161_z()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc12='N' OR g_odc.odc13='Y' OR g_odc.odc131='Y' THEN 
      RETURN 
   END IF
 
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN i161_cl USING g_odc.odc01,g_odc.odc02
      FETCH i161_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i161_cl ROLLBACK WORK RETURN
      END IF
      IF g_success = 'Y' THEN
         UPDATE odc_file SET odc12='N'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
 
      CLOSE i161_cl
      IF g_success='N' THEN
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      #如果是最上層,直接將上層調整確認碼寫成N
      SELECT COUNT(*) INTO g_cnt FROM odb_file
       WHERE odb01=g_odc.odc01 AND odb07=g_odc.odc02
      IF g_cnt != 0 THEN 
         UPDATE odc_file set odc121='N'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            RETURN
         END IF
      END IF
 
      SELECT * INTO g_odc.* FROM odc_file
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      DISPLAY BY NAME g_odc.odc12,g_odc.odc121
   END IF
   CALL cl_set_field_pic(g_odc.odc12,"","","","","")
END FUNCTION
 
FUNCTION i161_r()
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN 
      CALL cl_err('',-400,2) RETURN 
   END IF
   SELECT * INTO g_odc.* FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc12='Y' THEN CALL cl_err('','9022',0) RETURN END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN i161_cl USING g_odc.odc01,g_odc.odc02
   FETCH i161_cl INTO g_odc.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)
      CLOSE i161_cl ROLLBACK WORK RETURN
   END IF
   LET g_odc_t.* = g_odc.*
   CALL i161_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "odc01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "odc02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_odc.odc01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_odc.odc02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      SELECT COUNT(*) INTO l_cnt FROM odd_file
       WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
      IF l_cnt > 0 THEN
         DELETE FROM odd_file WHERE odd01 = g_odc.odc01 AND odd02 = g_odc.odc02
         IF SQLCA.sqlcode THEN
#           CALL cl_err('(i161_r:delete odd)',SQLCA.sqlcode,1) #No.FUN-660104
            CALL cl_err3("del","odd_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","(i161_r:delete odd)",1)  #No.FUN-660104
            LET g_success='N'
         END IF
 
         DELETE FROM ode_file WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
         IF SQLCA.sqlcode THEN
#           CALL cl_err('(i161_r:delete ode)',SQLCA.sqlcode,1)  #No.FUN-660104
            CALL cl_err3("del","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","(i161_r:delete ode)",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
      DELETE FROM odc_file WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
      IF SQLCA.sqlcode THEN
#        CALL cl_err('(i161_r:delete odc)',SQLCA.sqlcode,1) #No.FUN-660104
         CALL cl_err3("del","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","(i161_r:delete odc)",1)  #No.FUN-660104
         LET g_success='N'
      END IF
      #FUN-730069............begin
      IF g_odc.odc27="4" THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM odg_file 
                                   WHERE odg01=g_odc.odc01
                                     AND odg02=g_odc.odc02
                                     AND odg12='Y'
         IF g_cnt>0 THEN
            UPDATE odg_file SET odg12='N'
                          WHERE odg01=g_odc.odc01
                            AND odg02=g_odc.odc02
                            AND odg12='Y'
            IF SQLCA.sqlerrd[3]<>g_cnt THEN
               CALL cl_err3("upd","odg_file",g_odc.odc01,g_odc.odc02,"9050","","",1)
               LET g_success='N'
            END IF
         END IF
      END IF
      #FUN-730069............end
      INITIALIZE g_odc.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         LET g_odc_t.* = g_odc.*
         CALL g_odd1.clear()
         CALL g_ode.clear()
         OPEN i161_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i161_cs
            CLOSE i161_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH i161_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i161_cs
            CLOSE i161_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i161_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i161_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE    #No.FUN-6A0072
            CALL i161_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_odc.* = g_odc_t.*
      END IF
   END IF
   CALL i161_show()
END FUNCTION
 
FUNCTION i161_copy()
   DEFINE  l_n                LIKE type_file.num5,          #No.FUN-680120 SMALLINT
           l_odc              RECORD LIKE odc_file.*,
           l_oldno1,l_newno1  LIKE odc_file.odc01,
           l_oldno2,l_newno2  LIKE odc_file.odc02,
           l_odb02            LIKE odb_file.odb02,
           l_odb07            LIKE odb_file.odb07,
           l_tqb02            LIKE tqb_file.tqb02
  
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   LET g_before_input_done = FALSE
   CALL i161_set_entry('a')
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031  
   INPUT l_newno1,l_newno2 FROM odc01,odc02
      AFTER FIELD odc01
         IF cl_null(l_newno1) THEN
            NEXT FIELD odc01
         ELSE
            SELECT odb02,odb04,odb05,odb06,odb07 
              INTO l_odb02,g_odc.odc04,g_odc.odc05,g_odc.odc06,l_odb07
              FROM odb_file WHERE odb01 = l_newno1
                              AND odbacti = 'Y'        #No.TQC-6C0217
            IF STATUS THEN
               LET l_odb02 = ''
               LET g_odc.odc04 = ''
               LET g_odc.odc05 = ''
               LET g_odc.odc06 = ''
               LET l_odb07 = ''
#              CALL cl_err(l_newno1,'mfg-012',0) #No.FUN-660104
               CALL cl_err3("sel","odb_file",l_newno1,"","mfg-012","","",1)  #No.FUN-660104
               NEXT FIELD odc01
            END IF
            DISPLAY BY NAME l_newno1
            DISPLAY l_odb02 TO FORMONLY.odb02
            DISPLAY BY NAME g_odc.odc04,g_odc.odc05,g_odc.odc06
         END IF
  
      AFTER FIELD odc02
         IF cl_null(l_newno2) THEN
            NEXT FIELD odc02
         ELSE
            SELECT tqb02 INTO l_tqb02 FROM tqb_file WHERE tqb01=l_newno2
            IF STATUS THEN 
               LET l_tqb02 = '' 
#              CALL cl_err(l_newno2,'mfg-012',0) #No.FUN-660104
               CALL cl_err3("sel","tqb_file",l_newno2,"","mfg-012","","",1)  #No.FUN-660104
               NEXT FIELD odc02
            END IF
            DISPLAY BY NAME l_newno2
            DISPLAY l_tqb02 TO FORMONLY.tqb02
         END IF
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM odc_file
          WHERE odc01 = l_newno1 AND odc02 = l_newno2
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD odc01
         END IF
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM odd_file
          WHERE odd01 = l_newno1 AND odd02 = l_newno2
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD odc01
         END IF
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM ode_file
          WHERE ode01 = l_newno1 AND ode02 = l_newno2
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD odc01
         END IF
  
      ON ACTION controlp
         CASE
            WHEN INFIELD(odc01)  #預測版本
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_odb"
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO odc01
            WHEN INFIELD(odc02)  #成本中心
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_tqd03"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO odc02
         END CASE
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
  
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_odc.odc01,g_odc.odc02
      RETURN
   END IF
  
   #---------------COPY HEAD---------------
   DROP TABLE y
   SELECT * FROM odc_file
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
     INTO TEMP y
   UPDATE y
      SET odc01 =l_newno1,  #預測版本
          odc02 =l_newno2,  #組織代號
          odc12 ='N',       #預測確認碼
          odc121='N',       #上層調整確認碼
          odc13 ='N',       #目標金額確認碼
          odc131='N',       #目標數量確認碼
          odcuser=g_user,   #資料所有者
          odcgrup=g_grup,   #資料所有者所屬群
          odcmodu=NULL,     #資料修改日期
          odcdate=g_today   #資料建立日期
   INSERT INTO odc_file SELECT * FROM y
   IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err('ins odc: ',SQLCA.SQLCODE,1) #No.FUN-660104
      CALL cl_err3("ins","odc_file",l_newno1,l_newno2,SQLCA.sqlcode,"","ins odc:",1)  #No.FUN-660104
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
  
   #---------------COPY BODY(1)------------
   DROP TABLE x
   SELECT * FROM odd_file         #單身複製
    WHERE odd01=g_odc.odc01 AND odd02=g_odc.odc02
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      LET g_msg=g_odc.odc01 CLIPPED,'+',g_odc.odc02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660104
      CALL cl_err3("ins","x",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660104
      RETURN
   END IF
   UPDATE x SET odd01 = l_newno1 , odd02 = l_newno2
   INSERT INTO odd_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      LET g_msg=g_odc.odc01 CLIPPED,'+',g_odc.odc02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660104
      CALL cl_err3("ins","odd_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660104
      RETURN
   END IF
   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
  
   #---------------COPY BODY(2)------------
   DROP TABLE z
   SELECT * FROM ode_file         #單身複製
    WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
     INTO TEMP z
   IF SQLCA.sqlcode THEN
      LET g_msg=g_odc.odc01 CLIPPED,'+',g_odc.odc02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660104
      CALL cl_err3("ins","z",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660104
      RETURN
   END IF
   UPDATE z SET ode01 = l_newno1 , ode02 = l_newno2
   INSERT INTO ode_file SELECT * FROM z
   IF SQLCA.sqlcode THEN
      LET g_msg=g_odc.odc01 CLIPPED,'+',g_odc.odc02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660104
      CALL cl_err3("ins","ode_file",l_newno1,l_newno2,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660104
      RETURN
   END IF
   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED
  
   LET l_oldno1 = g_odc.odc01
   LET l_oldno2 = g_odc.odc02
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01 = l_newno1 AND odc02 = l_newno2
   CALL i161_u()
   CALL i161_b()
   #FUN-C80046---begin
   #LET g_odc.odc01 = l_oldno1
   #LET g_odc.odc02 = l_oldno2
   #SELECT * INTO g_odc.* FROM odc_file 
   # WHERE odc01 = l_oldno1 AND odc02 = l_oldno2
   #CALL i161_show()
   #FUN-C80046---end
   DISPLAY BY NAME g_odc.odc01,g_odc.odc02
END FUNCTION
 
FUNCTION i161_target_qty_y()
   DEFINE l_odc131     LIKE odc_file.odc131
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
   
   LET g_success = 'Y'
   LET g_cnt = 0
   SELECT COUNT(tqd03) INTO g_cnt FROM odc_file,tqd_file
    WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01
   IF g_cnt > 0 THEN   
      #當有下層組織時,需確認下層的目標數量確認碼皆為Y(因為要捲算下層量)
      DECLARE i161_y2_c1 CURSOR FOR
         SELECT odc131 FROM odc_file
          WHERE odc01 = g_odc.odc01
            AND odc02 IN 
              (SELECT tqd03 FROM odc_file,tqd_file
                WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
      FOREACH i161_y2_c1 INTO l_odc131
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #檢查目標數量確認碼odc131
         IF l_odc131 = 'N' THEN
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
      END FOREACH   
   END IF   
   IF g_success = 'N' THEN 
      #尚有未執行目標數量確認之下層組織,請先執行下層組織之目標數量確認!
      CALL cl_err(g_odc.odc02,'atm-551',1)   #FUN-680047 add
      RETURN 
   END IF
 
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc131='Y' THEN 
      CALL cl_err('','9023',0) RETURN 
   END IF
 
   IF cl_confirm('axm-108') THEN
      MESSAGE "WORKING !"
      BEGIN WORK
 
      OPEN i161_cl USING g_odc.odc01,g_odc.odc02
      FETCH i161_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i161_cl ROLLBACK WORK RETURN
      END IF
 
      IF g_success = 'Y' THEN
         UPDATE odc_file SET odc131='Y'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
 
      CLOSE i161_cl
      IF g_success='N' THEN
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      SELECT * INTO g_odc.* FROM odc_file
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      DISPLAY BY NAME g_odc.odc131
   END IF
   CALL cl_set_field_pic(g_odc.odc131,"","","","","")
 
   CALL i161_upd_lower()   #計算下層量
   CALL i161_show()
END FUNCTION
 
FUNCTION i161_target_qty_z()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_odc.odc01 IS NULL OR g_odc.odc02 IS NULL THEN RETURN END IF
 
   SELECT * INTO g_odc.* FROM odc_file
    WHERE odc01 = g_odc.odc01 AND odc02 = g_odc.odc02
   IF g_odc.odc131='N' THEN RETURN END IF
 
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
      LET g_success = 'Y'
      BEGIN WORK
      OPEN i161_cl USING g_odc.odc01,g_odc.odc02
      FETCH i161_cl INTO g_odc.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_odc.odc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE i161_cl ROLLBACK WORK RETURN
      END IF
      IF g_success = 'Y' THEN
         UPDATE odc_file SET odc131='N'
          WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd odc_file',SQLCA.SQLCODE,0) #No.FUN-660104
            CALL cl_err3("upd","odc_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upd odc_file",1)  #No.FUN-660104
            LET g_success='N'
         END IF
      END IF
 
      CLOSE i161_cl
      IF g_success='N' THEN
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(1)
      END IF
 
      #將下層量清為0
      UPDATE ode_file SET ode071=0,ode121=0
       WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd ode_file',SQLCA.SQLCODE,0) #No.FUN-660104
         CALL cl_err3("upd","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upe ode_file",1)  #No.FUN-660104
         RETURN
      END IF
      CALL i161_cal_tot(g_odc.odc01,g_odc.odc02)
 
      SELECT * INTO g_odc.* FROM odc_file
       WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02
      DISPLAY BY NAME g_odc.odc131
   END IF
   CALL cl_set_field_pic(g_odc.odc131,"","","","","")
   CALL i161_show()
END FUNCTION
 
#計算下層量
FUNCTION i161_upd_lower()
   DEFINE l_ode03      LIKE ode_file.ode03,
          l_ode04      LIKE ode_file.ode04,
          l_ode071     LIKE ode_file.ode071,
          l_ode121     LIKE ode_file.ode121
 
   DECLARE i161_y2_c2 CURSOR FOR
      SELECT ode03,ode04,SUM(ode09),SUM(ode14) FROM ode_file
       WHERE ode01=g_odc.odc01
         AND ode02 IN (SELECT tqd03 FROM odc_file,tqd_file
                        WHERE odc01=g_odc.odc01 AND odc02=g_odc.odc02 AND odc02=tqd01)
       GROUP BY ode03,ode04
   FOREACH i161_y2_c2 INTO l_ode03,l_ode04,l_ode071,l_ode121
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE ode_file SET ode071=l_ode071,ode121=l_ode121
       WHERE ode01=g_odc.odc01 AND ode02=g_odc.odc02 
         AND ode03=l_ode03 AND ode04=l_ode04
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd ode_file',SQLCA.SQLCODE,0) #No.FUN-660104
         CALL cl_err3("upd","ode_file",g_odc.odc01,g_odc.odc02,SQLCA.sqlcode,"","upe ode_file",1)  #No.FUN-660104
         RETURN
      END IF
      CALL i161_cal_tot(g_odc.odc01,g_odc.odc02)
   END FOREACH
END FUNCTION
 
#計算總預測量ode09,總預測金額ode14
FUNCTION i161_cal_tot(l_ode01,l_ode02)
   DEFINE l_ode01   LIKE ode_file.ode01,
          l_ode02   LIKE ode_file.ode02,
          l_ode03   LIKE ode_file.ode03,
          l_ode04   LIKE ode_file.ode04,
          l_ode09   LIKE ode_file.ode09,
          l_ode14   LIKE ode_file.ode14
 
   DECLARE i161_cal_c1 CURSOR FOR
      SELECT ode03,ode04,SUM(ode06+ode07+ode071+ode08),SUM(ode11+ode12+ode121+ode13)
        FROM ode_file
       WHERE ode01=l_ode01 AND ode02=l_ode02
       GROUP BY ode03,ode04
   FOREACH i161_cal_c1 INTO l_ode03,l_ode04,l_ode09,l_ode14
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE ode_file SET ode09 = l_ode09 , ode14 = l_ode14
       WHERE ode01=l_ode01 AND ode02=l_ode02 
         AND ode03=l_ode03 AND ode04=l_ode04
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(l_ode04,SQLCA.sqlcode,0) #No.FUN-660104
         CALL cl_err3("upd","ode_file",l_ode01,l_ode02,SQLCA.sqlcode,"","",1)  #No.FUN-660104
         RETURN
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i161_tot_0()
  LET g_tot.tot1 =0  LET g_tot.tot2 =0  LET g_tot.tot3 =0  LET g_tot.tot4 =0
  LET g_tot.tot5 =0  LET g_tot.tot6 =0  LET g_tot.tot7 =0  LET g_tot.tot8 =0
  LET g_tot.tot9 =0  LET g_tot.tot10=0
  LET g_tot.tot11=0  LET g_tot.tot12=0  LET g_tot.tot13=0  LET g_tot.tot14=0
  LET g_tot.tot15=0  LET g_tot.tot16=0  LET g_tot.tot17=0  LET g_tot.tot18=0
  LET g_tot.tot19=0  LET g_tot.tot20=0
  LET g_tot.tot21=0  LET g_tot.tot22=0  LET g_tot.tot23=0  LET g_tot.tot24=0
  LET g_tot.tot25=0  LET g_tot.tot26=0  LET g_tot.tot27=0  LET g_tot.tot28=0
  LET g_tot.tot29=0  LET g_tot.tot30=0  LET g_tot.tot31=0  LET g_tot.tot32=0
END FUNCTION
 
FUNCTION i161_g(l_odd03,l_odd04)
   DEFINE l_odd03  LIKE odd_file.odd03,
          l_odd04  LIKE odd_file.odd04,
          i        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          j        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          k        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_m1     LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_mm     LIKE type_file.num5,          #No.FUN-680120 SMALLINT  #月
          l_dd     LIKE type_file.num5,          #No.FUN-680120 SMALLINT  #日
          l_yy     LIKE type_file.num5           #No.FUN-680120 SMALLINT  #年
 
   LET g_success='Y'
   BEGIN WORK
   LET g_rec_b1 = 0   #add by john
   CASE g_odc.odc04   #計算期數
      WHEN '1' #季
         LET j=((YEAR(g_odc.odc06)-YEAR(g_odc.odc05))*12+MONTH(g_odc.odc06)-MONTH(g_odc.odc05)+1)/3
      WHEN '2' #月
         LET j=((YEAR(g_odc.odc06)-YEAR(g_odc.odc05))*12+MONTH(g_odc.odc06)-MONTH(g_odc.odc05)+1)
      WHEN '3' #旬
         LET j=((YEAR(g_odc.odc06)-YEAR(g_odc.odc05))*365+(MONTH(g_odc.odc06)-MONTH(g_odc.odc05)+1)*30)/10
      WHEN '4' #週
         LET j=((YEAR(g_odc.odc06)-YEAR(g_odc.odc05))*365+(MONTH(g_odc.odc06)-MONTH(g_odc.odc05)+1)*30)/7
      WHEN '5' #天
         LET j=g_odc.odc06-g_odc.odc05+1
   END CASE
   FOR i = 1 TO j
       LET g_rec_b1 = g_rec_b1 + 1  #add by john
       CASE g_odc.odc04
            WHEN '1' #季
                 IF i = 1 THEN
                     LET l_mm = MONTH(g_odc.odc05)
                     LET l_dd = 1
                     LET l_yy = YEAR(g_odc.odc05)
                     LET g_ode[i].ode04 = MDY(l_mm,l_dd,l_yy)
                 ELSE
                     LET g_ode[i].ode04 = g_ode[i-1].ode04 + 3 UNITS MONTH
                 END IF                  
            WHEN '2' #月
                 IF i = 1 THEN
                     LET l_mm = MONTH(g_odc.odc05)
                     LET l_dd = 1
                     LET l_yy = YEAR(g_odc.odc05)
                     LET g_ode[i].ode04 = MDY(l_mm,l_dd,l_yy)
                 ELSE
                     LET g_ode[i].ode04 = g_ode[i-1].ode04 + 1 UNITS MONTH
                 END IF                  
            WHEN '3' #旬
                 #當時距類別為3.旬時, 起始日期應為該月1號,
                 #以該月之最後一天為下旬最後一天
                  IF i = 1 THEN
                     LET l_mm = MONTH(g_odc.odc05)
                     LET l_dd = 1
                     LET l_yy = YEAR(g_odc.odc05)
                     LET g_ode[i].ode04 = MDY(l_mm,l_dd,l_yy)
                  ELSE
                     LET g_ode[i].ode04 = g_ode[i-1].ode04 + 10
                  END IF
                  LET k = i MOD 3
                  IF k = 1 THEN
                     LET l_mm = MONTH(g_ode[i].ode04)
                     LET l_dd = DAY(g_ode[i].ode04)
                     LET l_yy = YEAR(g_ode[i].ode04)
                     IF l_dd != 1 THEN
                        LET g_ode[i].ode04 = MDY(l_mm+1,1,l_yy) 
                     END IF
                  END IF
            WHEN '4' #週
                 LET g_ode[i].ode04 = g_odc.odc05 + (i-1)*7
            WHEN '5' #天
                 LET g_ode[i].ode04 = g_odc.odc05 + (i-1)*1
       END CASE
       LET g_ode[i].ode05 = 0
       LET g_ode[i].ode06 = 0
       LET g_ode[i].ode07 = 0
       LET g_ode[i].ode071= 0
       LET g_ode[i].ode08 = 0
       LET g_ode[i].ode09 = 0
       LET g_ode[i].ode10 = 0
       LET g_ode[i].ode14 = 0
   END FOR
 
   #將 array 裡的資料 insert into ode_file
   FOR i = 1 TO j
       INSERT INTO ode_file(ode01,ode02,ode03,ode031,ode04,ode05,ode06,
                            ode07,ode071,ode08,ode09,ode10,ode11,ode12,
                            ode121,ode13,ode14,ode15) #FUN-730069
                     VALUES(g_odc.odc01,g_odc.odc02,l_odd03,l_odd04,
                            g_ode[i].ode04,g_ode[i].ode05,g_ode[i].ode06,
                            g_ode[i].ode07,g_ode[i].ode071,g_ode[i].ode08,
                            g_ode[i].ode09,g_ode[i].ode10,0,0,0,0,
                            g_ode[i].ode14,g_ode[i].ode15) #FUN-730069
       IF STATUS THEN
#         CALL cl_err('ins ode:',STATUS,1)  #No.FUN-660104
          CALL cl_err3("ins","ode_file",g_odc.odc01,g_odc.odc02,STATUS,"","ins ode:",1)  #No.FUN-660104
          LET g_success='N'
       END IF
   END FOR
   IF g_success='N' THEN 
      ROLLBACK WORK 
   ELSE 
      COMMIT WORK 
   END IF
END FUNCTION
 
FUNCTION i161_b2_title_set(l_odd03,l_cnt)
   DEFINE l_i      LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_odd03  LIKE odd_file.odd03,
          l_cnt    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_qty32a LIKE aao_file.aao05,          #No.FUN-680120 DEC(15,3) 
          l_ode04  LIKE ode_file.ode04,
          l_ode09  LIKE ode_file.ode09,
          l_msg    STRING   #組需要顯示出來的欄位
 
   DECLARE i161_2_c2 CURSOR FOR
      SELECT ode04,ode09 FROM ode_file
       WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
         AND ode03 = l_odd03
 
   LET l_i = 1
   FOREACH i161_2_c2 INTO l_ode04,l_ode09
      #將時距值塞到Title
      CASE l_i
         WHEN 1  CALL cl_set_comp_att_text("qty1a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty1a = l_ode09
                 LET g_tot.tot1 = g_tot.tot1 + l_ode09
                 LET l_msg = "qty1a,",
                             "tot1a"
         WHEN 2  CALL cl_set_comp_att_text("qty2a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty2a = l_ode09
                 LET g_tot.tot2 = g_tot.tot2 + l_ode09
                 LET l_msg = "qty1a,qty2a,",
                             "tot1a,tot2a"
         WHEN 3  CALL cl_set_comp_att_text("qty3a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty3a = l_ode09
                 LET g_tot.tot3 = g_tot.tot3 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,",
                             "tot1a,tot2a,tot3a"
         WHEN 4  CALL cl_set_comp_att_text("qty4a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty4a = l_ode09
                 LET g_tot.tot4 = g_tot.tot4 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,",
                             "tot1a,tot2a,tot3a,tot4a"
         WHEN 5  CALL cl_set_comp_att_text("qty5a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty5a = l_ode09
                 LET g_tot.tot5 = g_tot.tot5 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a"
         WHEN 6  CALL cl_set_comp_att_text("qty6a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty6a = l_ode09
                 LET g_tot.tot6 = g_tot.tot6 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a"
         WHEN 7  CALL cl_set_comp_att_text("qty7a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty7a = l_ode09
                 LET g_tot.tot7 = g_tot.tot7 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a"
         WHEN 8  CALL cl_set_comp_att_text("qty8a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty8a = l_ode09
                 LET g_tot.tot8 = g_tot.tot8 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a"
         WHEN 9  CALL cl_set_comp_att_text("qty9a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty9a = l_ode09
                 LET g_tot.tot9 = g_tot.tot9 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a"
         WHEN 10 CALL cl_set_comp_att_text("qty10a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty10a = l_ode09
                 LET g_tot.tot10 = g_tot.tot10 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a"
         WHEN 11 CALL cl_set_comp_att_text("qty11a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty11a = l_ode09
                 LET g_tot.tot11 = g_tot.tot11 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a"
         WHEN 12 CALL cl_set_comp_att_text("qty12a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty12a = l_ode09
                 LET g_tot.tot12 = g_tot.tot12 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a"
         WHEN 13 CALL cl_set_comp_att_text("qty13a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty13a = l_ode09
                 LET g_tot.tot13 = g_tot.tot13 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a"
         WHEN 14 CALL cl_set_comp_att_text("qty14a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty14a = l_ode09
                 LET g_tot.tot14 = g_tot.tot14 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a"
         WHEN 15 CALL cl_set_comp_att_text("qty15a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty15a = l_ode09
                 LET g_tot.tot15 = g_tot.tot15 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a"
         WHEN 16 CALL cl_set_comp_att_text("qty16a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty16a = l_ode09
                 LET g_tot.tot16 = g_tot.tot16 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a"
         WHEN 17 CALL cl_set_comp_att_text("qty17a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty17a = l_ode09
                 LET g_tot.tot17 = g_tot.tot17 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a"
         WHEN 18 CALL cl_set_comp_att_text("qty18a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty18a = l_ode09
                 LET g_tot.tot18 = g_tot.tot18 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a"
         WHEN 19 CALL cl_set_comp_att_text("qty19a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty19a = l_ode09
                 LET g_tot.tot19 = g_tot.tot19 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a"
         WHEN 20 CALL cl_set_comp_att_text("qty20a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty20a = l_ode09
                 LET g_tot.tot20 = g_tot.tot20 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a"
         WHEN 21 CALL cl_set_comp_att_text("qty21a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty21a = l_ode09
                 LET g_tot.tot21 = g_tot.tot21 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a"
         WHEN 22 CALL cl_set_comp_att_text("qty22a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty22a = l_ode09
                 LET g_tot.tot22 = g_tot.tot22 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a"
         WHEN 23 CALL cl_set_comp_att_text("qty23a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty23a = l_ode09
                 LET g_tot.tot23 = g_tot.tot23 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a"
         WHEN 24 CALL cl_set_comp_att_text("qty24a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty24a = l_ode09
                 LET g_tot.tot24 = g_tot.tot24 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a"
         WHEN 25 CALL cl_set_comp_att_text("qty25a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty25a = l_ode09
                 LET g_tot.tot25 = g_tot.tot25 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a"
         WHEN 26 CALL cl_set_comp_att_text("qty26a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty26a = l_ode09
                 LET g_tot.tot26 = g_tot.tot26 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a"
         WHEN 27 CALL cl_set_comp_att_text("qty27a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty27a = l_ode09
                 LET g_tot.tot27 = g_tot.tot27 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,qty27a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a,tot27a"
         WHEN 28 CALL cl_set_comp_att_text("qty28a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty28a = l_ode09
                 LET g_tot.tot28 = g_tot.tot28 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,qty27a,qty28a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a,tot27a,tot28a"
         WHEN 29 CALL cl_set_comp_att_text("qty29a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty29a = l_ode09
                 LET g_tot.tot29 = g_tot.tot29 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,qty27a,qty28a,qty29a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a,tot27a,tot28a,tot29a"
         WHEN 30 CALL cl_set_comp_att_text("qty30a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty30a = l_ode09
                 LET g_tot.tot30 = g_tot.tot30 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,qty27a,qty28a,qty29a,qty30a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a,tot27a,tot28a,tot29a,tot30a"
         WHEN 31 CALL cl_set_comp_att_text("qty31a",l_ode04 CLIPPED)
                 LET g_odd2[l_cnt].qty31a = l_ode09
                 LET g_tot.tot31 = g_tot.tot31 + l_ode09
                 LET l_msg = "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
                             "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
                             "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,qty27a,qty28a,qty29a,qty30a,qty31a,",
                             "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
                             "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
                             "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a,tot27a,tot28a,tot29a,tot30a,tot31a"
      END CASE
      LET l_i = l_i + 1
   END FOREACH
 
   #合計
   SELECT SUM(ode09) INTO l_qty32a FROM ode_file
    WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
      AND ode03 = l_odd03
   LET g_odd2[l_cnt].qty32a = l_qty32a
   LET g_tot.tot32 = g_tot.tot32 + l_qty32a
   DISPLAY BY NAME g_odd2[l_cnt].qty32a
 
   #將有資料的欄位顯示出來
   CALL cl_set_comp_visible(l_msg,TRUE)
END FUNCTION
 
FUNCTION i161_b3_title_set(l_odd03,l_cnt)
   DEFINE l_i      LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_odd03  LIKE odd_file.odd03,
          l_cnt    LIKE type_file.num5,          #No.FUN-680120 SMALLINT
          l_amt32b LIKE aao_file.aao05,          #No.FUN-680120 DEC(15,3)
          l_ode04  LIKE ode_file.ode04,
          l_ode14  LIKE ode_file.ode14,
          l_msg    STRING
 
   DECLARE i161_3_c2 CURSOR FOR
      SELECT ode04,ode14 FROM ode_file
       WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
         AND ode03 = l_odd03
 
   LET l_i = 1
   FOREACH i161_3_c2 INTO l_ode04,l_ode14
      #將時距值塞到Title
      CASE l_i
         WHEN 1  CALL cl_set_comp_att_text("amt1b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt1b = l_ode14
                 LET g_tot.tot1 = g_tot.tot1 + l_ode14
                 LET l_msg = "amt1b,",
                             "tot1b"
         WHEN 2  CALL cl_set_comp_att_text("amt2b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt2b = l_ode14
                 LET g_tot.tot2 = g_tot.tot2 + l_ode14
                 LET l_msg = "amt1b,amt2b,",
                             "tot1b,tot2b"
         WHEN 3  CALL cl_set_comp_att_text("amt3b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt3b = l_ode14
                 LET g_tot.tot3 = g_tot.tot3 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,",
                             "tot1b,tot2b,tot3b"
         WHEN 4  CALL cl_set_comp_att_text("amt4b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt4b = l_ode14
                 LET g_tot.tot4 = g_tot.tot4 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,",
                             "tot1b,tot2b,tot3b,tot4b"
         WHEN 5  CALL cl_set_comp_att_text("amt5b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt5b = l_ode14
                 LET g_tot.tot5 = g_tot.tot5 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b"
         WHEN 6  CALL cl_set_comp_att_text("amt6b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt6b = l_ode14
                 LET g_tot.tot6 = g_tot.tot6 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b"
         WHEN 7  CALL cl_set_comp_att_text("amt7b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt7b = l_ode14
                 LET g_tot.tot7 = g_tot.tot7 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b"
         WHEN 8  CALL cl_set_comp_att_text("amt8b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt8b = l_ode14
                 LET g_tot.tot8 = g_tot.tot8 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b"
         WHEN 9  CALL cl_set_comp_att_text("amt9b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt9b = l_ode14
                 LET g_tot.tot9 = g_tot.tot9 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b"
         WHEN 10 CALL cl_set_comp_att_text("amt10b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt10b = l_ode14
                 LET g_tot.tot10 = g_tot.tot10 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b"
         WHEN 11 CALL cl_set_comp_att_text("amt11b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt11b = l_ode14
                 LET g_tot.tot11 = g_tot.tot11 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b"
         WHEN 12 CALL cl_set_comp_att_text("amt12b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt12b = l_ode14
                 LET g_tot.tot12 = g_tot.tot12 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b"
         WHEN 13 CALL cl_set_comp_att_text("amt13b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt13b = l_ode14
                 LET g_tot.tot13 = g_tot.tot13 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b"
         WHEN 14 CALL cl_set_comp_att_text("amt14b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt14b = l_ode14
                 LET g_tot.tot14 = g_tot.tot14 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b"
         WHEN 15 CALL cl_set_comp_att_text("amt15b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt15b = l_ode14
                 LET g_tot.tot15 = g_tot.tot15 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b"
         WHEN 16 CALL cl_set_comp_att_text("amt16b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt16b = l_ode14
                 LET g_tot.tot16 = g_tot.tot16 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b"
         WHEN 17 CALL cl_set_comp_att_text("amt17b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt17b = l_ode14
                 LET g_tot.tot17 = g_tot.tot17 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b"
         WHEN 18 CALL cl_set_comp_att_text("amt18b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt18b = l_ode14
                 LET g_tot.tot18 = g_tot.tot18 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b"
         WHEN 19 CALL cl_set_comp_att_text("amt19b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt19b = l_ode14
                 LET g_tot.tot19 = g_tot.tot19 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b"
         WHEN 20 CALL cl_set_comp_att_text("amt20a",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt20b = l_ode14
                 LET g_tot.tot20 = g_tot.tot20 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b"
         WHEN 21 CALL cl_set_comp_att_text("amt21b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt21b = l_ode14
                 LET g_tot.tot21 = g_tot.tot21 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b"
         WHEN 22 CALL cl_set_comp_att_text("amt22b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt22b = l_ode14
                 LET g_tot.tot22 = g_tot.tot22 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b"
         WHEN 23 CALL cl_set_comp_att_text("amt23b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt23b = l_ode14
                 LET g_tot.tot23 = g_tot.tot23 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b"
         WHEN 24 CALL cl_set_comp_att_text("amt24b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt24b = l_ode14
                 LET g_tot.tot24 = g_tot.tot24 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b"
         WHEN 25 CALL cl_set_comp_att_text("amt25b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt25b = l_ode14
                 LET g_tot.tot25 = g_tot.tot25 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b"
         WHEN 26 CALL cl_set_comp_att_text("amt26b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt26b = l_ode14
                 LET g_tot.tot26 = g_tot.tot26 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b"
         WHEN 27 CALL cl_set_comp_att_text("amt27b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt27b = l_ode14
                 LET g_tot.tot27 = g_tot.tot27 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,amt27b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b,tot27b"
         WHEN 28 CALL cl_set_comp_att_text("amt28b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt28b = l_ode14
                 LET g_tot.tot28 = g_tot.tot28 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,amt27b,amt28b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b,tot27b,tot28b"
         WHEN 29 CALL cl_set_comp_att_text("amt29b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt29b = l_ode14
                 LET g_tot.tot29 = g_tot.tot29 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,amt27b,amt28b,amt29b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b,tot27b,tot28b,tot29b"
         WHEN 30 CALL cl_set_comp_att_text("amt30a",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt30b = l_ode14
                 LET g_tot.tot30 = g_tot.tot30 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,amt27b,amt28b,amt29b,amt30b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b,tot27b,tot28b,tot29b,tot30b"
         WHEN 31 CALL cl_set_comp_att_text("amt31b",l_ode04 CLIPPED)
                 LET g_odd3[l_cnt].amt31b = l_ode14
                 LET g_tot.tot31 = g_tot.tot31 + l_ode14
                 LET l_msg = "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
                             "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
                             "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,amt27b,amt28b,amt29b,amt30b,amt31b,",
                             "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
                             "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
                             "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b,tot27b,tot28b,tot29b,tot30b,tot31b"
      END CASE
      LET l_i = l_i + 1
   END FOREACH
 
   #合計
   SELECT SUM(ode14) INTO l_amt32b FROM ode_file
    WHERE ode01 = g_odc.odc01 AND ode02 = g_odc.odc02
      AND ode03 = l_odd03
   LET g_odd3[l_cnt].amt32b = l_amt32b
   LET g_tot.tot32 = g_tot.tot32 + l_amt32b
   DISPLAY BY NAME g_odd3[l_cnt].amt32b
 
   #將有資料的欄位顯示出來
   CALL cl_set_comp_visible(l_msg,TRUE)
END FUNCTION
 
FUNCTION i161_set_comp_unvisible()
   DEFINE   l_msg       STRING
 
   LET l_msg = 
       "qty1a,qty2a,qty3a,qty4a,qty5a,qty6a,qty7a,qty8a,qty9a,qty10a,",
       "qty11a,qty12a,qty13a,qty14a,qty15a,qty16a,qty17a,qty18a,qty19a,qty20a,",
       "qty21a,qty22a,qty23a,qty24a,qty25a,qty26a,qty27a,qty28a,qty29a,qty30a,qty31a,",
       "tot1a,tot2a,tot3a,tot4a,tot5a,tot6a,tot7a,tot8a,tot9a,tot10a,",
       "tot11a,tot12a,tot13a,tot14a,tot15a,tot16a,tot17a,tot18a,tot19a,tot20a,",
       "tot21a,tot22a,tot23a,tot24a,tot25a,tot26a,tot27a,tot28a,tot29a,tot30a,tot31a,",
       "amt1b,amt2b,amt3b,amt4b,amt5b,amt6b,amt7b,amt8b,amt9b,amt10b,",
       "amt11b,amt12b,amt13b,amt14b,amt15b,amt16b,amt17b,amt18b,amt19b,amt20b,",
       "amt21b,amt22b,amt23b,amt24b,amt25b,amt26b,amt27b,amt28b,amt29b,amt30b,amt31b,",
       "tot1b,tot2b,tot3b,tot4b,tot5b,tot6b,tot7b,tot8b,tot9b,tot10b,",
       "tot11b,tot12b,tot13b,tot14b,tot15b,tot16b,tot17b,tot18b,tot19b,tot20b,",
       "tot21b,tot22b,tot23b,tot24b,tot25b,tot26b,tot27b,tot28b,tot29b,tot30b,tot31b"
   CALL cl_set_comp_visible(l_msg,FALSE)
 
END FUNCTION
 
FUNCTION i161_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("odc01,odc02",TRUE)
   END IF
 
   IF INFIELD(odd04) THEN
      CALL cl_set_comp_entry("odd07,odd08",TRUE)
   END IF
 
   IF g_odc.odc13 = 'Y' AND g_action_choice = "adjust_target_qty" THEN
      CALL cl_set_comp_entry("ode08",TRUE)
   END IF
END FUNCTION
 
FUNCTION i161_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("odc01,odc02",FALSE)
   END IF
 
   IF INFIELD(odd04) THEN
      CALL cl_set_comp_entry("odd07,odd08",FALSE)
   END IF
 
   IF g_odc.odc13 = 'N' OR g_action_choice != "adjust_target_qty" THEN
      CALL cl_set_comp_entry("ode08",FALSE)
   ELSE
      CALL cl_set_comp_entry("ode06,ode10",FALSE)
   END IF
END FUNCTION
