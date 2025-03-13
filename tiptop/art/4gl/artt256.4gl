# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt256.4gl
# Descriptions...: 機構調撥單
# Date & Author..: NO.FUN-960130 09/07/11 By Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0157 09/12/07 By bnlent get tra-db
# Modify.........: No.FUN-9C0079 09/12/16 By bnlent ins log 拨入仓库有误 
# Modify.........: No.FUN-9C0088 09/12/17 By bnlent s_add_img-->s_madd_img
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/11 By Cockroach 添加pos相關管控
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add oriu/orig 
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No.MOD-A80096 10/08/11 By lilingyu 庫存量img10的檢驗函數中sql,儲位img03為空,調整具體欄位
# Modify.........: No.MOD-A80112 10/08/16 By lilingyu 更改程式中令img03為空的sql 
# Modify.........: No:FUN-A70130 10/08/19 By shaoyong q_smy改为q_oay
# Modify.........: No.FUN-AB0021 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0086 10/10/28 By lixia 調撥功能優化
# Modify.........: No.FUN-AC0046 10/12/17 By lixia報錯信息修改
# Modify.........: No.FUN-AC0040 10/12/18 By lixia調撥申請單時自動帶出在途倉
# Modify.........: No.TQC-AC0382 10/12/29 By lixia調撥調整修改
# Modify.........: No.TQC-B10152 11/01/14 By lixia調撥申請單時自動帶出經營方式
# Modify.........: No:MOD-B10139 11/01/19 By Smapmin 單身撥入倉庫開窗無法帶出撥入營運中心的倉庫別
# Modify.........: No:TQC-B20179 11/03/03 By lixia新增或刪除來源是調撥申請單的單據時，更新申請單狀態
# Modify.........: No:FUN-B30025 11/03/09 By lixia 無效功能拿掉,增加作廢功能
# Modify.........: No:FUN-B40030 11/04/12 By huangtao 來源為調撥申請時，輸入來源單號未帶出撥入營運中心的名稱 
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60153 11/06/30 By huangtao 增加列印功能
# Modify.........: No:FUN-B80017 11/08/03 By pauline 撥出/撥入倉庫必須屬於撥出/撥入營運中心
# Modify.........: No:FUN-B80075 11/08/08 By pauline 新增"查詢倉庫","查詢儲位批號"  調整調整倉儲批數量控卡
# Modify.........: No:TQC-B90001 11/09/01 By pauline 修改錯誤訊息,增加撥出確認控卡條件
# Modify.........: No.FUN-B90068 11/09/08 By pauline 母料號不可調撥
# Modify.........: No.FUN-BA0004 11/10/06 By pauline 調整在途倉/撥出倉/撥入倉控管
# Modify.........: No.TQC-BA0002 11/10/05 By pauline 單身撥出倉庫窗應傳撥出營運中心
# Modify.........: No:TQC-BA0063 11/10/28 By pauline 撥出確認控卡取消預設倉設定
# Modify.........: No:TQC-BA0179 11/10/31 By pauline 當允許負庫存時則可撥出確認
# Modify.........: No:FUN-B90101 11/11/03 By lixiang 服飾二維開發
# Modify.........: No:FUN-BA0097 11/12/12 By nanbing ruo02新增 6券調撥申請 
# Modify.........: No:FUN-910088 12/01/17 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C20002 12/02/02 By fanbj 券產品的倉庫調整
# Modify.........: No:FUN-C20006 12/02/03 By lixiang 服飾二維BUG修改(對多屬性料件的判斷等)
# Modify.........: No:TQC-C20039 12/02/04 By pauline "庫存不足允許調撥" 沒勾選時，於單身輸入數量後及撥出確認時，應判斷如庫存不足則應卡住不可調撥 
# Modify.........: No:TQC-C20140 12/02/13 By yangxf 添加控卡撥出數量不可大於申請單中的核准數量
# Modify.........: No:TQC-C20183 12/02/17 By chenjing 增加數量欄位小數取位
# Modify.........: No:TQC-C20348 12/02/22 By lixiang  服飾流通業母料件的開窗
# Modify.........: No:TQC-C20413 12/02/23 By lixiang 修改由於單號FUN-C20002修改後造成服飾業運行出錯的問題
# Modify.........: No:TQC-C20411 12/02/23 By lixiang 服飾中母單身倉儲批的開窗
# Modify.........: No:TQC-C20490 12/02/24 By lixiang 修改數量檢查庫存的邏輯判斷
# Modify.........: No:TQC-C20226 12/02/29 By pauline 撥入數量欄位調整為不允許輸入<0 資料(可輸入>=0)
# Modify.........: No:TQC-C30026 12/03/02 By yangxf 动态产生ruo02 ITEM时缺少一个,导致券发放维护作业产生调拨单后查询时显示的来源类型错误.
# Modify.........: No:TQC-C30061 12/03/03 By pauline 撥入確認時撥入數量欄位調整為不允許輸入<0 資料(可輸入>=0)
# Modify.........: No:TQC-C30196 12/03/10 By lixiang 服飾新增時錄入資料后，再返回來更改母料件,需將後面的數值金額欄位等重新賦值
# Modify.........: No:MOD-C30217 12/03/10 By xjll  控管數量欄位數量不可小於零
# Modify.........: No:MOD-C30217 12/03/12 By xjll  服飾bug 修改
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C60072 12/06/28 By qiaozy 只要數量為0在審核是就要報錯
# Modify.........: No:FUN-C60100 12/06/28 By qiaozy 快捷鍵controlb的問題，切換的標記在BEFORE INPUT 賦值
# Modify.........: No:FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維,不可審核數量為零的母單身資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C80095 12/08/27 By yangxf AFTER ROW中更新調撥申請單 CALL t256_upd_rvq('3')的邏輯移到撥出審核中，
#                                                   如果來源類型是5調撥申請，檢查來源單號不重複
#                                                   b_fill的時候，抓倉庫名稱，分別到對應營運中心去抓，否則如果多db，抓不到對應資料
# Modify.........: No:TQC-C90007 12/09/03 By yangxf 修改撥出審核時帶出撥入審核人員名稱BUG
# Modify.........: No:FUN-C80107 12/09/19 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:TQC-C90058 12/09/26 By yangxf 如果来源单号为空则隐藏来源项次
# Modify.........: No:FUN-CA0086 12/10/10 By shiwuying 增加调拨单退货
# Modify.........: No:FUN-C90049 12/10/20 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-CB0017 12/11/05 By Lori 修改FUN-C40049問題，錯取rupslk的產品編號應改取rup
# Modify.........: No:TQC-CB0020 12/11/07 By xuxz   光標在“撥入倉庫”欄位時，點擊右邊按鈕“查詢倉庫”無值顯示
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No.FUN-CC0057 12/12/17 By xumeimei 单身新增收货营运中心栏位
# Modify.........: No.FUN-D10106 13/01/22 By dongsz 錄入時添加成本關帳日期的檢查
# Modify.........: No:MOD-CC0179 13/01/29 By Elise 增加s_incchk的檢核
# Modify.........: No:MOD-CC0056 13/01/30 By Elise 單位轉換率修正為不可維護
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No:FUN-D30033 13/04/28 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40084 13/04/22 By qiull 服饰单身增加rup22
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No:FUN-D40103 13/05/16 By lixh1 增加庫位有效性檢查
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 拿掉部份FUN-D40103新增的儲位有效性檢查/庫位如果為空則給空格
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/s_slk.global"     #No.FUN-B90101
 
DEFINE g_ruo         RECORD LIKE ruo_file.*,
       g_ruo_t       RECORD LIKE ruo_file.*,
       g_ruo_o       RECORD LIKE ruo_file.*,
       g_ruo01_t     LIKE ruo_file.ruo01,
       g_ruoplant_t  LIKE ruo_file.ruoplant,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rup         DYNAMIC ARRAY OF RECORD
           rup02          LIKE rup_file.rup02,
           rup17          LIKE rup_file.rup17,  #FUN-AA0086
           rup22          LIKE rup_file.rup22,  #FUN-CC0057 
           rup06          LIKE rup_file.rup06,
           rup03          LIKE rup_file.rup03,                      
           rup03_desc     LIKE ima_file.ima02,
           rup04          LIKE rup_file.rup04,
           rup04_desc     LIKE gfe_file.gfe02,
           rup05          LIKE rup_file.rup05,
           rup07          LIKE rup_file.rup07,
           rup07_desc     LIKE gfe_file.gfe02,
           rup08          LIKE rup_file.rup08,
           rup19          LIKE rup_file.rup19,  #FUN-AA0086
           rup09          LIKE rup_file.rup09,
           rup09_desc     LIKE imd_file.imd02,
           rup10          LIKE rup_file.rup10,
           rup11          LIKE rup_file.rup11,
           rup12          LIKE rup_file.rup12,
           rup13          LIKE rup_file.rup13, 
           rup13_desc     LIKE imd_file.imd02,
           rup14          LIKE rup_file.rup14,
           rup15          LIKE rup_file.rup15,
           rup16          LIKE rup_file.rup16,
           rup18          LIKE rup_file.rup18   #FUN-AA0086          
                          END RECORD,
       g_rup_t            RECORD
           rup02          LIKE rup_file.rup02,
           rup17          LIKE rup_file.rup17,  #FUN-AA0086
           rup22          LIKE rup_file.rup22,  #FUN-CC0057
           rup06          LIKE rup_file.rup06,
           rup03          LIKE rup_file.rup03,
           rup03_desc     LIKE ima_file.ima02,
           rup04          LIKE rup_file.rup04,
           rup04_desc     LIKE gfe_file.gfe02,
           rup05          LIKE rup_file.rup05,           
           rup07          LIKE rup_file.rup07,
           rup07_desc     LIKE gfe_file.gfe02,
           rup08          LIKE rup_file.rup08,
           rup19          LIKE rup_file.rup19,  #FUN-AA0086
           rup09          LIKE rup_file.rup09,
           rup09_desc     LIKE imd_file.imd02,
           rup10          LIKE rup_file.rup10,
           rup11          LIKE rup_file.rup11,
           rup12          LIKE rup_file.rup12,
           rup13          LIKE rup_file.rup13, 
           rup13_desc     LIKE imd_file.imd02,
           rup14          LIKE rup_file.rup14,
           rup15          LIKE rup_file.rup15,
           rup16          LIKE rup_file.rup16,
           rup18          LIKE rup_file.rup18   #FUN-AA0086 
                          END RECORD,
       g_rup_o            RECORD 
           rup02          LIKE rup_file.rup02,
           rup17          LIKE rup_file.rup17,  #FUN-AA0086
           rup22          LIKE rup_file.rup22,  #FUN-CC0057
           rup06          LIKE rup_file.rup06,
           rup03          LIKE rup_file.rup03,
           rup03_desc     LIKE ima_file.ima02,
           rup04          LIKE rup_file.rup04,
           rup04_desc     LIKE gfe_file.gfe02,
           rup05          LIKE rup_file.rup05,
           rup07          LIKE rup_file.rup07,
           rup07_desc     LIKE gfe_file.gfe02,
           rup08          LIKE rup_file.rup08,
           rup19          LIKE rup_file.rup19,  #FUN-AA0086
           rup09          LIKE rup_file.rup09,
           rup09_desc     LIKE imd_file.imd02,
           rup10          LIKE rup_file.rup10,
           rup11          LIKE rup_file.rup11,
           rup12          LIKE rup_file.rup12,
           rup13          LIKE rup_file.rup13, 
           rup13_desc     LIKE imd_file.imd02,
           rup14          LIKE rup_file.rup14,
           rup15          LIKE rup_file.rup15,
           rup16          LIKE rup_file.rup16,
           rup18          LIKE rup_file.rup18   #FUN-AA0086 
                          END RECORD,
           g_sql          STRING,
           g_wc           STRING,
           g_wc2          STRING,
           g_rec_b        LIKE type_file.num5,
           l_ac           LIKE type_file.num5
DEFINE g_gec07            LIKE gec_file.gec07
DEFINE g_forupd_sql       STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE ruo_file.ruo01
DEFINE g_argv2             STRING 
DEFINE l_rup               RECORD  LIKE rup_file.*    
DEFINE g_img01             LIKE img_file.img01
DEFINE g_img02             LIKE img_file.img02
DEFINE g_img03             LIKE img_file.img03
DEFINE g_img04             LIKE img_file.img04
DEFINE cb                  ui.ComboBox           
DEFINE g_cb                DYNAMIC ARRAY OF STRING
DEFINE g_act               LIKE type_file.chr1000   #FUN-B80075 add
DEFINE g_yes               LIKE type_file.chr1000   #FUN-B80075 add
DEFINE g_cmd               LIKE type_file.chr1
DEFINE g_rup07_t           LIKE rup_file.rup07      #FUN-910088--add--
DEFINE g_check_img         LIKE type_file.chr1      #TQC-C20039 add
#FUN-B90101--add--begin--
DEFINE g_rupslk         DYNAMIC ARRAY OF RECORD
           rupslk02          LIKE rupslk_file.rupslk02,
           rupslk17          LIKE rupslk_file.rupslk17,  
           rupslk03          LIKE rupslk_file.rupslk03,
           rupslk03_desc     LIKE ima_file.ima02,
           rupslk04          LIKE rupslk_file.rupslk04,
           rupslk04_desc     LIKE gfe_file.gfe02,
           rupslk05          LIKE rupslk_file.rupslk05,   
           rupslk06          LIKE rupslk_file.rupslk06,           
           rupslk07          LIKE rupslk_file.rupslk07,
           rupslk07_desc     LIKE gfe_file.gfe02,
           rupslk08          LIKE rupslk_file.rupslk08,
           rupslk19          LIKE rupslk_file.rupslk19,  
           rupslk09          LIKE rupslk_file.rupslk09,
           rupslk09_desc     LIKE imd_file.imd02,
           rupslk10          LIKE rupslk_file.rupslk10,
           rupslk11          LIKE rupslk_file.rupslk11,
           rupslk12          LIKE rupslk_file.rupslk12,
           rupslk13          LIKE rupslk_file.rupslk13, 
           rupslk13_desc     LIKE imd_file.imd02,
           rupslk14          LIKE rupslk_file.rupslk14,
           rupslk15          LIKE rupslk_file.rupslk15,
           rupslk16          LIKE rupslk_file.rupslk16,
           rupslk18          LIKE rupslk_file.rupslk18,
           rupslk20          LIKE rupslk_file.rupslk20,
           rupslk21          LIKE rupslk_file.rupslk21,
           rupslk22          LIKE rupslk_file.rupslk22   
                          END RECORD,
       g_rupslk_t            RECORD
           rupslk02          LIKE rupslk_file.rupslk02,
           rupslk17          LIKE rupslk_file.rupslk17,  
           rupslk03          LIKE rupslk_file.rupslk03,
           rupslk03_desc     LIKE ima_file.ima02,
           rupslk04          LIKE rupslk_file.rupslk04,
           rupslk04_desc     LIKE gfe_file.gfe02,
           rupslk05          LIKE rupslk_file.rupslk05,   
           rupslk06          LIKE rupslk_file.rupslk06,           
           rupslk07          LIKE rupslk_file.rupslk07,
           rupslk07_desc     LIKE gfe_file.gfe02,
           rupslk08          LIKE rupslk_file.rupslk08,
           rupslk19          LIKE rupslk_file.rupslk19,  
           rupslk09          LIKE rupslk_file.rupslk09,
           rupslk09_desc     LIKE imd_file.imd02,
           rupslk10          LIKE rupslk_file.rupslk10,
           rupslk11          LIKE rupslk_file.rupslk11,
           rupslk12          LIKE rupslk_file.rupslk12,
           rupslk13          LIKE rupslk_file.rupslk13, 
           rupslk13_desc     LIKE imd_file.imd02,
           rupslk14          LIKE rupslk_file.rupslk14,
           rupslk15          LIKE rupslk_file.rupslk15,
           rupslk16          LIKE rupslk_file.rupslk16,
           rupslk18          LIKE rupslk_file.rupslk18,
           rupslk20          LIKE rupslk_file.rupslk20,
           rupslk21          LIKE rupslk_file.rupslk21,
           rupslk22          LIKE rupslk_file.rupslk22   
                          END RECORD,
       g_rupslk_o            RECORD 
           rupslk02          LIKE rupslk_file.rupslk02,
           rupslk17          LIKE rupslk_file.rupslk17,  
           rupslk03          LIKE rupslk_file.rupslk03,
           rupslk03_desc     LIKE ima_file.ima02,
           rupslk04          LIKE rupslk_file.rupslk04,
           rupslk04_desc     LIKE gfe_file.gfe02,
           rupslk05          LIKE rupslk_file.rupslk05,   
           rupslk06          LIKE rupslk_file.rupslk06,           
           rupslk07          LIKE rupslk_file.rupslk07,
           rupslk07_desc     LIKE gfe_file.gfe02,
           rupslk08          LIKE rupslk_file.rupslk08,
           rupslk19          LIKE rupslk_file.rupslk19,  
           rupslk09          LIKE rupslk_file.rupslk09,
           rupslk09_desc     LIKE imd_file.imd02,
           rupslk10          LIKE rupslk_file.rupslk10,
           rupslk11          LIKE rupslk_file.rupslk11,
           rupslk12          LIKE rupslk_file.rupslk12,
           rupslk13          LIKE rupslk_file.rupslk13, 
           rupslk13_desc     LIKE imd_file.imd02,
           rupslk14          LIKE rupslk_file.rupslk14,
           rupslk15          LIKE rupslk_file.rupslk15,
           rupslk16          LIKE rupslk_file.rupslk16,
           rupslk18          LIKE rupslk_file.rupslk18,
           rupslk20          LIKE rupslk_file.rupslk20,
           rupslk21          LIKE rupslk_file.rupslk21,
           rupslk22          LIKE rupslk_file.rupslk22   
                          END RECORD,
       g_wc3              STRING,
       g_rec_b2           LIKE type_file.num5,
       l_ac2              LIKE type_file.num5,
       g_rec_b3           LIKE type_file.num5,
       l_ac3              LIKE type_file.num5,
       li_a               LIKE type_file.chr1 
#FUN-B90101--add--end--
#DEFINE g_sma894           LIKE type_file.chr1       #FUN-C80107  #FUN-D30024 mark
DEFINE g_imd23            LIKE imd_file.imd23        #FUN-D30024
 
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
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)

  #FUN-CA0086 Begin---
   IF cl_null(g_argv2) THEN LET g_argv2 = '1' END IF
   IF g_argv2 = '2' THEN
      LET g_prog = 'artt257'
   END IF
  #FUN-CA0086 End-----
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM ruo_file WHERE ruo01 = ? AND ruoplant = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t256_cl CURSOR FROM g_forupd_sql

#FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      OPEN WINDOW t256_w WITH FORM "art/42f/artt256_slk"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   ELSE
#FUN-B90101--add--end--
      OPEN WINDOW t256_w WITH FORM "art/42f/artt256"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   END IF
#FUN-B90101 add END IF
   CALL cl_ui_init()

#FUN-AA0086---ADD---STR---
   LET cb = ui.ComboBox.forName("ruo02")
   LET g_cb[1]  = cb.getItemText(1)
   LET g_cb[2]  = cb.getItemText(2)
   LET g_cb[3]  = cb.getItemText(3)
   LET g_cb[4]  = cb.getItemText(4)
   LET g_cb[5]  = cb.getItemText(5)
   LET g_cb[6]  = cb.getItemText(6)
   LET g_cb[7]  = cb.getItemText(7)   #FUN-BA0097 add                      
   LET g_cb[8]  = cb.getItemText(8)   #FUN-CA0086
   LET g_cb[9]  = cb.getItemText(9)   #FUN-CC0057 add
   LET g_cb[10] = cb.getItemText(10)  #FUN-CC0057 add
   CALL cl_set_comp_visible('ruo14',g_sma.sma142 = "Y") 
   #CALL cl_set_comp_visible("ruopos",g_aza.aza88 = "Y") #TQC-AC0382
#FUN-AA0086---ADD---END---      
   #FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      CALL cl_set_comp_visible('rupslk06',FALSE)
   END IF
   CALL cl_set_act_visible('controlb',FALSE)
#FUN-B90101--add--end--
  #FUN-CA0086 Begin---
   IF g_argv2 = '2' THEN
      CALL cb.removeItem('1')
      CALL cb.removeItem('2')
      CALL cb.removeItem('3')
      CALL cb.removeItem('4')
      CALL cb.removeItem('5')
      CALL cb.removeItem('6')
      CALL cb.removeItem('8')   #FUN-CC0057 add
      CALL cb.removeItem('9')   #FUN-CC0057 add
      CALL cb.removeItem('P')
      DISPLAY '7' TO ruo02
   END IF
  #FUN-CA0086 End-----

   IF NOT cl_null(g_argv1) THEN
      CALL t256_q()
   END IF
 
   CALL t256_menu()
   CLOSE WINDOW t256_w
 
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION t256_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   DEFINE l_where     STRING   #FUN-CA0086
   DEFINE l_whereb    STRING   #FUN-CA0086
 
   CLEAR FORM 
   CALL g_rup.clear()
#FUN-B90101--add--begin--
   IF s_industry("slk") THEN 
      CALL g_rupslk.clear()
      CALL g_imx.clear()
   END IF
#FUN-B90101--add--end--

#FUN-AA0086 add ---str---
   IF g_argv2 <> '2' THEN #FUN-CA0086
     CALL cb.clear()
     CALL cb.addItem(1,g_cb[1])
     CALL cb.addItem(2,g_cb[2])
     CALL cb.addItem(3,g_cb[3])
     CALL cb.addItem(4,g_cb[4])
     CALL cb.addItem(5,g_cb[5])
     CALL cb.addItem(6,g_cb[6])       #TQC-C30026 add 
#    CALL cb.addItem('P',g_cb[6])     #TQC-C30026 MARK
    #CALL cb.addItem('P',g_cb[7])     #TQC-C30026 add  #FUN-CA0086
    #CALL cb.addItem('P',g_cb[8])     #FUN-CA0086      #FUN-CC0057 mark
     CALL cb.addItem('8',g_cb[8])     #FUN-CC0057 add
     CALL cb.addItem('9',g_cb[9])     #FUN-CC0057 add
     CALL cb.addItem('P',g_cb[10])    #FUN-CC0057 add
#FUN-AA0086 add ---end---
#    CALL cb.addItem('6',g_cb[7])  #FUN-BA0097 add     #TQC-C30026 MARK
   ELSE                   #FUN-CA0086
     DISPLAY '7' TO ruo02 #FUN-CA0086
   END IF                 #FUN-CA0086
   CALL cl_set_comp_visible("rup17",TRUE) #FUN-CA0086
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " ruo01 = '",g_argv1,"' "
      LET g_wc2= " 1=1"     #FUN-B90101 add
#FUN-B90101--add--begin--
      IF s_industry("slk") THEN
         LET g_wc3= " 1=1" 
      END IF
#FUN-B90101--add--end--
   ELSE
     #FUN-CA0086 Begin---
      IF g_argv2 = '2' THEN
         LET l_where = " ruo02 = '7' "
         LET l_whereb = " rup01 IN (SELECT ruo01 FROM ruo_file WHERE ruo02 = '7')"
      ELSE
         LET l_where = " ruo02 <> '7' "
         LET l_whereb = " rup01 IN (SELECT ruo01 FROM ruo_file WHERE ruo02 <> '7')"
      END IF
     #FUN-CA0086 End-----
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_ruo.* TO NULL
      #CONSTRUCT BY NAME g_wc ON ruo01,ruo02,ruo03,ruo07,ruo08,ruoplant,ruo04,ruo05,
      DIALOG ATTRIBUTES(UNBUFFERED)       
         CONSTRUCT BY NAME g_wc ON ruo01,ruo011,ruo02,ruo03,ruo07,ruo08,ruoplant,ruo04,ruo05,#TQC-AC0382 add ruo011
                                ruo14,ruo901,ruo99,ruoconf,ruo15,#TQC-AC0382
                                ruo10,ruo10t,ruo11,  #FUN-AA0086 drop ruo06
      	                        ruo12,ruo12t,ruo13,ruo09,  
                                ruouser,ruogrup,
                                ruomodu,ruodate,ruocrat      #FUN-B30025
                               ,ruooriu,ruoorig              #TQC-A30041 ADD
                                
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
#FUN-CA0086 Begin---
#         ON ACTION controlp
#            CASE
#               WHEN INFIELD(ruo01)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo01"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo01
#                  NEXT FIELD ruo01
#
###TQC-AC0382 add--str--
#               WHEN INFIELD(ruo011)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo011"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo011
#                  NEXT FIELD ruo011
##TQC-AC0382 add--end--
#                  
#               WHEN INFIELD(ruo02)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo02"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo02
#                  NEXT FIELD ruo02
#      
#               WHEN INFIELD(ruo03)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo03"
#                  LET g_qryparam.where = "rvq07 = rvqplant "  #TQC-AC0382
#                  LET g_qryparam.arg1 = g_plant
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo03
#                  NEXT FIELD ruo03
#                  
#               WHEN INFIELD(ruo04)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo04"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo04
#                  NEXT FIELD ruo04
#               
#               WHEN INFIELD(ruo05)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo05"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo05
#                  NEXT FIELD ruo05
#                  
## modify by FUN-AA0086---str---                  
##               WHEN INFIELD(ruo06)
##                  CALL cl_init_qry_var()
##                  LET g_qryparam.state = 'c'
##                  LET g_qryparam.form ="q_ruo06"
##                  CALL cl_create_qry() RETURNING g_qryparam.multiret
##                  DISPLAY g_qryparam.multiret TO ruo06
##                  NEXT FIELD ruo06
#
#               WHEN INFIELD(ruo14)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo14"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo14
#                  NEXT FIELD ruo14
#               
#               WHEN INFIELD(ruo99)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo99"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo99
#                  NEXT FIELD ruo99   
## modify by FUN-AA0086---end---  
#                
#               WHEN INFIELD(ruo08)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo08"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo08
#                  NEXT FIELD ruo08
#                  
#               WHEN INFIELD(ruo11)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo11"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo11
#                  NEXT FIELD ruo11
#                  
#               WHEN INFIELD(ruo13)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_ruo13"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO ruo13
#                  NEXT FIELD ruo13
#                  
#               OTHERWISE EXIT CASE
#            END CASE
#FUN-CA0086 End-----

#FUN-B90101--mark--begin--      
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#     
#        ON ACTION about
#           CALL cl_about()
#     
#        ON ACTION HELP
#           CALL cl_show_help()
#     
#        ON ACTION controlg
#           CALL cl_cmdask()
#     
#        ON ACTION qbe_select
#           CALL cl_qbe_list() RETURNING lc_qbe_sn
#           CALL cl_qbe_display_condition(lc_qbe_sn)
#FUN-B90101--mark--end--
      END CONSTRUCT
      
#FUN-B90101--mark--begin--
#     IF INT_FLAG THEN
#        RETURN
#     END IF
#  END IF
#
#  #Begin:FUN-980030
#  #   IF g_priv2='4' THEN
#  #      LET g_wc = g_wc clipped," AND ruouser = '",g_user,"'"
#  #   END IF
#
#  #   IF g_priv3='4' THEN
#  #      LET g_wc = g_wc clipped," AND ruogrup MATCHES '",g_grup CLIPPED,"*'"
#  #   END IF
#
#  #   IF g_priv3 MATCHES "[5678]" THEN
#  #      LET g_wc = g_wc clipped," AND ruogrup IN ",cl_chk_tgrup_list()
#  #   END IF
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruouser', 'ruogrup')
#  #End:FUN-980030
#
#  IF NOT cl_null(g_argv1) THEN
#     LET g_wc2 = ' 1=1'     
#  ELSE
#FUN-B90101--mark--end--

         CONSTRUCT g_wc3 ON rupslk02,rupslk17,rupslk03,rupslk04,rupslk05,rupslk07,rupslk08,
                         rupslk19,rupslk09,rupslk10,rupslk11,rupslk12,rupslk13,rupslk14,rupslk15,
                         rupslk16,rupslk18 
              FROM s_rupslk[1].rupslk02,s_rupslk[1].rupslk17,s_rupslk[1].rupslk03,
                   s_rupslk[1].rupslk04,s_rupslk[1].rupslk05,s_rupslk[1].rupslk07,
                   s_rupslk[1].rupslk08,s_rupslk[1].rupslk19,s_rupslk[1].rupslk09,s_rupslk[1].rupslk10,
                   s_rupslk[1].rupslk11,s_rupslk[1].rupslk12,s_rupslk[1].rupslk13,
                   s_rupslk[1].rupslk14,s_rupslk[1].rupslk15,s_rupslk[1].rupslk16,s_rupslk[1].rupslk18
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
#FUN-CA0086 Begin---
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(rupslk03)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_rupslk03"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO rupslk03
#                  NEXT FIELD rupslk03
# 
#               WHEN INFIELD(rupslk04)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_rupslk04"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO rupslk04
#                  NEXT FIELD rupslk04
#
#               WHEN INFIELD(rupslk07)
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.state = 'c'                                                                                        
#                  LET g_qryparam.form ="q_rupslk07"             
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                  DISPLAY g_qryparam.multiret TO rupslk07                                                                              
#                  NEXT FIELD rupslk07
# 
#               WHEN INFIELD(rupslk09)
#                  CALL cl_init_qry_var()       
#                  LET g_qryparam.state = 'c'        
#                  LET g_qryparam.form ="q_rupslk09" 
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret  
#                  DISPLAY g_qryparam.multiret TO rupslk09               
#                  NEXT FIELD rupslk09     
# 
#               WHEN INFIELD(rupslk10)
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.state = 'c'                                                                                        
#                  LET g_qryparam.form ="q_rupslk10"                                                                                  
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                  DISPLAY g_qryparam.multiret TO rupslk10                                                                              
#                  NEXT FIELD rupslk10
#      
#               WHEN INFIELD(rupslk11)                                                                                                  
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.state = 'c'                                                                                        
#                  LET g_qryparam.form ="q_rupslk11"                                                                                   
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                  DISPLAY g_qryparam.multiret TO rupslk11                                                                              
#                  NEXT FIELD rupslk11
# 
#               WHEN INFIELD(rupslk13)                                                                                                  
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.state = 'c'                                                                                        
#                  LET g_qryparam.form ="q_rupslk13"                                                                                
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                  DISPLAY g_qryparam.multiret TO rupslk13                                                                              
#                  NEXT FIELD rupslk13
# 
#               WHEN INFIELD(rupslk14)                                                                                                  
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.state = 'c'                                                                                        
#                  LET g_qryparam.form ="q_rupslk14"                                                                                   
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                  DISPLAY g_qryparam.multiret TO rupslk14                                                                              
#                  NEXT FIELD rupslk14
# 
#               WHEN INFIELD(rupslk15)                                                                                                  
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.state = 'c'                                                                                        
#                  LET g_qryparam.form ="q_rupslk15"                                                                                  
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                  DISPLAY g_qryparam.multiret TO rupslk15                                                                              
#                  NEXT FIELD rupslk15
#            END CASE
#FUN-CA0086 End-----
         END CONSTRUCT  
#FUN-B90101--add--end--
         CONSTRUCT g_wc2 ON rup02,rup17,rup06,rup03,rup04,rup05,rup07,rup08,
                            rup19,rup09,rup10,rup11,rup12,rup13,rup14,rup15,
                            rup16,rup18  #FUN-AA0086 ADD 17,18,19
                 FROM s_rup[1].rup02,s_rup[1].rup17,s_rup[1].rup06,s_rup[1].rup03,
                      s_rup[1].rup04,s_rup[1].rup05,s_rup[1].rup07,
                      s_rup[1].rup08,s_rup[1].rup19,s_rup[1].rup09,s_rup[1].rup10,
                      s_rup[1].rup11,s_rup[1].rup12,s_rup[1].rup13,
                      s_rup[1].rup14,s_rup[1].rup15,s_rup[1].rup16,s_rup[1].rup18
 
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
#FUN-CA0086 Begin---
#            ON ACTION CONTROLP
#               CASE
#                  WHEN INFIELD(rup03)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state = 'c'
#                     LET g_qryparam.form ="q_rup03"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO rup03
#                     NEXT FIELD rup03
# 
#                  WHEN INFIELD(rup04)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state = 'c'
#                     LET g_qryparam.form ="q_rup04"
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
#                     DISPLAY g_qryparam.multiret TO rup04
#                     NEXT FIELD rup04
#               
##FUN-AA0086 add---str---
#                 WHEN INFIELD(rup06)
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup06"             
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup06                                                                              
#                    NEXT FIELD rup06
##FUN-AA0086 add---end---
#
#                 WHEN INFIELD(rup07)
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup07"             
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup07                                                                              
#                    NEXT FIELD rup07
# 
#                 WHEN INFIELD(rup09)
#                    CALL cl_init_qry_var()       
#                    LET g_qryparam.state = 'c'        
#                    LET g_qryparam.form ="q_rup09" 
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret  
#                    DISPLAY g_qryparam.multiret TO rup09               
#                    NEXT FIELD rup09     
# 
#                 WHEN INFIELD(rup10)
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup10"                                                                                  
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup10                                                                              
#                    NEXT FIELD rup10
#      
#                 WHEN INFIELD(rup11)                                                                                                  
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup11"                                                                                   
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup11                                                                              
#                    NEXT FIELD rup11
# 
#                 WHEN INFIELD(rup13)                                                                                                  
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup13"                                                                                
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup13                                                                              
#                    NEXT FIELD rup13
# 
#                 WHEN INFIELD(rup14)                                                                                                  
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup14"                                                                                   
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup14                                                                              
#                    NEXT FIELD rup14
# 
#                 WHEN INFIELD(rup15)                                                                                                  
#                    CALL cl_init_qry_var()                                                                                            
#                    LET g_qryparam.state = 'c'                                                                                        
#                    LET g_qryparam.form ="q_rup15"                                                                                  
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
#                    DISPLAY g_qryparam.multiret TO rup15                                                                              
#                    NEXT FIELD rup15
#              END CASE
#FUN-CA0086 End---
#FUN-B90101--mark--begin-- 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT
#   
#        ON ACTION about
#           CALL cl_about()
#   
#        ON ACTION HELP
#           CALL cl_show_help()
#   
#        ON ACTION controlg
#           CALL cl_cmdask()
#   
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#FUN-B90101--mark--end--

         END CONSTRUCT

        #FUN-CA0086 Begin---
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruo01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo01"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo01
                  NEXT FIELD ruo01

               WHEN INFIELD(ruo011)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo011"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo011
                  NEXT FIELD ruo011
                  
               WHEN INFIELD(ruo02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo02"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo02
                  NEXT FIELD ruo02
      
               WHEN INFIELD(ruo03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo03"
                  LET g_qryparam.where = "rvq07 = rvqplant "  #TQC-AC0382
                  LET g_qryparam.where = g_qryparam.where," AND ",l_where #FUN-CA0086
                  LET g_qryparam.arg1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo03
                  NEXT FIELD ruo03
                  
               WHEN INFIELD(ruo04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo04"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo04
                  NEXT FIELD ruo04
               
               WHEN INFIELD(ruo05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo05"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo05
                  NEXT FIELD ruo05
                  
               WHEN INFIELD(ruo14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo14"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo14
                  NEXT FIELD ruo14
               
               WHEN INFIELD(ruo99)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo99"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo99
                  NEXT FIELD ruo99
                
               WHEN INFIELD(ruo08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo08"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo08
                  NEXT FIELD ruo08
                  
               WHEN INFIELD(ruo11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo11"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo11
                  NEXT FIELD ruo11
                  
               WHEN INFIELD(ruo13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruo13"
                  LET g_qryparam.where = l_where #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruo13
                  NEXT FIELD ruo13
                  
               WHEN INFIELD(rupslk03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rupslk03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rupslk03
                  NEXT FIELD rupslk03
 
               WHEN INFIELD(rupslk04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rupslk04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rupslk04
                  NEXT FIELD rupslk04

               WHEN INFIELD(rupslk07)
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rupslk07"             
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rupslk07                                                                              
                  NEXT FIELD rupslk07
 
               WHEN INFIELD(rupslk09)
                  CALL cl_init_qry_var()       
                  LET g_qryparam.state = 'c'        
                  LET g_qryparam.form ="q_rupslk09" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret  
                  DISPLAY g_qryparam.multiret TO rupslk09               
                  NEXT FIELD rupslk09     
 
               WHEN INFIELD(rupslk10)
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rupslk10"                                                                                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rupslk10                                                                              
                  NEXT FIELD rupslk10
      
               WHEN INFIELD(rupslk11)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rupslk11"                                                                                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rupslk11                                                                              
                  NEXT FIELD rupslk11
 
               WHEN INFIELD(rupslk13)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rupslk13"                                                                                
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rupslk13                                                                              
                  NEXT FIELD rupslk13
 
               WHEN INFIELD(rupslk14)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rupslk14"                                                                                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rupslk14                                                                              
                  NEXT FIELD rupslk14
 
               WHEN INFIELD(rupslk15)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rupslk15"                                                                                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rupslk15                                                                              
                  NEXT FIELD rupslk15
                  
               WHEN INFIELD(rup03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_rup03"
                   LET g_qryparam.where = l_whereb #FUN-CA0086
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rup03
                   NEXT FIELD rup03
 
                WHEN INFIELD(rup04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_rup04"
                   LET g_qryparam.where = l_whereb #FUN-CA0086
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rup04
                   NEXT FIELD rup04
                   
               WHEN INFIELD(rup06)
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup06"             
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup06                                                                              
                  NEXT FIELD rup06
                  
               WHEN INFIELD(rup07)
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup07"             
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup07                                                                              
                  NEXT FIELD rup07
 
               WHEN INFIELD(rup09)
                  CALL cl_init_qry_var()       
                  LET g_qryparam.state = 'c'        
                  LET g_qryparam.form ="q_rup09" 
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret  
                  DISPLAY g_qryparam.multiret TO rup09               
                  NEXT FIELD rup09     
 
               WHEN INFIELD(rup10)
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup10"                                                                                  
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup10                                                                              
                  NEXT FIELD rup10
      
               WHEN INFIELD(rup11)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup11"                                                                                   
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup11                                                                              
                  NEXT FIELD rup11
 
               WHEN INFIELD(rup13)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup13"                                                                                
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup13                                                                              
                  NEXT FIELD rup13
 
               WHEN INFIELD(rup14)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup14"                                                                                   
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup14                                                                              
                  NEXT FIELD rup14
 
               WHEN INFIELD(rup15)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rup15"                                                                                  
                  LET g_qryparam.where = l_whereb #FUN-CA0086
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rup15                                                                              
                  NEXT FIELD rup15
               OTHERWISE EXIT CASE
            END CASE
        #FUN-CA0086 End-----

##TQC-AC0382 add--str--
#FUN-B90101--add--begin--
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121

         ON ACTION qbe_save
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION accept
            EXIT DIALOG

         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG
         END DIALOG
#FUN-B90101--add--end-- 
    
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

#FUN-B90101--add--begin--
   IF g_wc2 IS NULL THEN
      LET g_wc2 = " 1=1"
   END IF
#FUN-B90101--add--end--
 
#FUN-CA0086 Begin---
#   IF g_wc2 = " 1=1" THEN
#      LET g_sql = "SELECT ruo01,ruoplant FROM ruo_file ",
#                  " WHERE ",g_wc CLIPPED,
#                  " ORDER BY ruo01"
##FUN-B90101--add--begin--
#      IF s_industry("slk") THEN 
#         IF g_wc3 != " 1=1"  THEN
#            LET g_sql = "SELECT UNIQUE ruo01,ruoplant ",
#                        "  FROM ruo_file, rupslk_file ",
#                        " WHERE ruo01 = rupslk01",
#                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
#                        " ORDER BY ruo01"
#         END IF
#      END IF 
##FUN-B90101--add--end--
#   ELSE
#      LET g_sql = "SELECT UNIQUE ruo01,ruoplant ",
#                  "  FROM ruo_file, rup_file ",
#                  " WHERE ruo01 = rup01",
#                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                  " ORDER BY ruo01"
##FUN-B90101--add--begin--
#      IF s_industry("slk") THEN   
#         IF g_wc3 != " 1=1"  THEN
#            LET g_sql = "SELECT UNIQUE ruo01,ruoplant ",
#                        "  FROM ruo_file, rup_file,rupslk_file ",
#                        " WHERE ruo01 = rupslk01",
#                        "   AND rup01 = rupslk01 AND rup21s = rupslk02 ",
#                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED,
#                        " ORDER BY ruo01"
#         END IF
#      END IF
##FUN-B90101--add--end--
#   END IF
# 
#   PREPARE t256_prepare FROM g_sql
#   DECLARE t256_cs
#       SCROLL CURSOR WITH HOLD FOR t256_prepare
# 
#   IF g_wc2 = " 1=1" THEN
#      LET g_sql="SELECT COUNT(*) FROM ruo_file WHERE ",g_wc CLIPPED
##FUN-B90101--add--begin--
#      IF s_industry("slk") THEN   
#         IF g_wc3 != " 1=1" THEN
#            LET g_sql="SELECT COUNT(DISTINCT ruo01||ruoplant) FROM ruo_file,rupslk_file WHERE ",
#                      "rupslk01=ruo01  AND ",
#                      g_wc CLIPPED," AND ",g_wc3 CLIPPED
#         END IF
#      END IF
##FUN-B90101--add--end--
#   ELSE
#      LET g_sql="SELECT COUNT(ruo01||ruoplant) FROM ruo_file,rup_file WHERE ",
#                "rup01=ruo01  AND ",
#                g_wc CLIPPED," AND ",g_wc2 CLIPPED
##FUN-B90101--add--begin--
#      IF s_industry("slk") THEN
#         IF g_wc3 != " 1=1" THEN
#            LET g_sql="SELECT COUNT(DISTINCT ruo01||ruoplant) FROM ruo_file,rup_file,rupslk_file WHERE ",
#                      "rupslk01=ruo01  AND rup01=rupslk01 AND rup21s=rupslk02 AND ",
#                      g_wc CLIPPED," AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED
#         END IF    
#      END IF
##FUN-B90101--add--end--
#   END IF

   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT ruo01,ruoplant FROM ruo_file ",
                  " WHERE ",g_wc CLIPPED
      IF s_industry("slk") THEN 
         IF g_wc3 != " 1=1"  THEN
            LET g_sql = "SELECT UNIQUE ruo01,ruoplant ",
                        "  FROM ruo_file, rupslk_file ",
                        " WHERE ruo01 = rupslk01",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
         END IF
      END IF 
   ELSE
      LET g_sql = "SELECT UNIQUE ruo01,ruoplant ",
                  "  FROM ruo_file, rup_file ",
                  " WHERE ruo01 = rup01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
      IF s_industry("slk") THEN   
         IF g_wc3 != " 1=1"  THEN
            LET g_sql = "SELECT UNIQUE ruo01,ruoplant ",
                        "  FROM ruo_file, rup_file,rupslk_file ",
                        " WHERE ruo01 = rupslk01",
                        "   AND rup01 = rupslk01 AND rup21s = rupslk02 ",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED
         END IF
      END IF
   END IF
   IF g_argv2 = '2' THEN
      LET g_sql = g_sql CLIPPED,"   AND ruo02 = '7' "
   ELSE
      LET g_sql = g_sql CLIPPED,"   AND ruo02 <> '7' "
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY ruo01"
   PREPARE t256_prepare FROM g_sql
   DECLARE t256_cs
       SCROLL CURSOR WITH HOLD FOR t256_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM ruo_file WHERE ",g_wc CLIPPED
      IF s_industry("slk") THEN   
         IF g_wc3 != " 1=1" THEN
            LET g_sql="SELECT COUNT(DISTINCT ruo01||ruoplant) FROM ruo_file,rupslk_file WHERE ",
                      "rupslk01=ruo01  AND ",
                      g_wc CLIPPED," AND ",g_wc3 CLIPPED
         END IF
      END IF
   ELSE
      LET g_sql="SELECT COUNT(ruo01||ruoplant) FROM ruo_file,rup_file WHERE ",
                "rup01=ruo01  AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
      IF s_industry("slk") THEN
         IF g_wc3 != " 1=1" THEN
            LET g_sql="SELECT COUNT(DISTINCT ruo01||ruoplant) FROM ruo_file,rup_file,rupslk_file WHERE ",
                      "rupslk01=ruo01  AND rup01=rupslk01 AND rup21s=rupslk02 AND ",
                      g_wc CLIPPED," AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED
         END IF    
      END IF
   END IF
   IF g_argv2 = '2' THEN
      LET g_sql = g_sql CLIPPED,"   AND ruo02 = '7' "
   ELSE
      LET g_sql = g_sql CLIPPED,"   AND ruo02 <> '7' "
   END IF
#FUN-CA0086 End-----
   PREPARE t256_precount FROM g_sql
   DECLARE t256_count CURSOR FOR t256_precount
 
END FUNCTION
 
FUNCTION t256_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t256_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t256_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t256_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t256_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t256_u()
            END IF
 
#FUN-B30025--mark--str--
#         WHEN "invalid"
#            IF cl_chk_act_auth() THEN
#                  CALL t256_x()
#            END IF
#FUN-B30025--mark--end--
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN 
                  CALL t256_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN 
                  CALL t256_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t256_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE

         WHEN "out_confirm"
            IF cl_chk_act_auth() THEN 
                  CALL t256_out_yes()
            END IF
   
         WHEN "in_confirm"
            IF cl_chk_act_auth() THEN 
                  CALL t256_in_yes()
            END IF
       
#modify by FUN-AA0086--str--            
#FUN-B30025--add--str--
         WHEN "void"                  #作廢功能
            IF cl_chk_act_auth() THEN 
               CALL t256_void(1)
            END IF
#FUN-B30025--add--end--
         #FUN-D20039 -----------sta
         WHEN "undo_void"                  #取消作廢功能
            IF cl_chk_act_auth() THEN
               CALL t256_void(2)
            END IF  
         #FUN-D20039 -----------end
         WHEN "triangletrade"         #多角貿易
             IF cl_chk_act_auth() THEN 
                CALL t256_v()
             END IF
#modify by FUN-AA0086--end--            
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rup),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_ruo.ruo01 IS NOT NULL THEN
                 LET g_doc.column1 = "ruo01"
                 LET g_doc.value1 = g_ruo.ruo01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t256_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_i     LIKE type_file.num5,   #No.FUN-B90101
            l_index LIKE type_file.num5    #No.FUN-B90101
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

#FUN-B90101---Add---Str--
   IF s_industry("slk") THEN
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_rupslk TO s_rupslk.*
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               CALL g_imx.clear()
               CALL t256_b_fill2(g_wc3,g_wc2)
               LET g_action_choice=""

            BEFORE ROW
               CALL cl_set_comp_visible("color",FALSE)
               FOR l_i = 1 TO 15
                   LET l_index = l_i USING '&&'
                   CALL cl_set_comp_visible("imx" || l_index,FALSE)
               END FOR
               LET l_ac2 = DIALOG.getCurrentRow("s_rupslk")
               IF l_ac2 != 0 THEN
                  CALL s_settext_slk(g_rupslk[l_ac2].rupslk03)
                  CALL s_fillimx_slk(g_rupslk[l_ac2].rupslk03,
                                      g_ruo.ruo01,g_rupslk[l_ac2].rupslk02)
                  LET g_rec_b3 = g_imx.getLength()
               END IF
         END DISPLAY

         DISPLAY ARRAY g_imx TO s_imx.*
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               LET g_action_choice=""

            BEFORE ROW
               LET l_ac3 = DIALOG.getCurrentRow("s_imx")
               CALL cl_show_fld_cont()
         END DISPLAY
         
         DISPLAY ARRAY g_rup TO s_rup.*                                        #FUN-B90101---Add---
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
      
            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont() 
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

        ON ACTION first
           CALL t256_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           CALL fgl_set_arr_curr(1)
           ACCEPT DIALOG

        ON ACTION previous
           CALL t256_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           CALL fgl_set_arr_curr(1)
           ACCEPT DIALOG

        ON ACTION jump
           CALL t256_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           CALL fgl_set_arr_curr(1)
           ACCEPT DIALOG

        ON ACTION next
           CALL t256_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           CALL fgl_set_arr_curr(1)
           ACCEPT DIALOG

        ON ACTION last
           CALL t256_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           CALL fgl_set_arr_curr(1)
           ACCEPT DIALOG

        ON ACTION detail
           LET g_action_choice="detail"
           LET l_ac = 1
           EXIT DIALOG

        ON ACTION output
           LET g_action_choice="output"
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
        
        ON ACTION out_confirm
           LET g_action_choice="out_confirm"
           EXIT DIALOG
        
        ON ACTION in_confirm
           LET g_action_choice="in_confirm"
           EXIT DIALOG
        
        ON ACTION triangletrade      #多角貿易
           LET g_action_choice="triangletrade"
           EXIT DIALOG
        
        ON ACTION void               #作廢功能
           LET g_action_choice="void"
           EXIT DIALOG 

        #FUN-D20039 ----------sta
        ON ACTION undo_void            #取消作廢功能
           LET g_action_choice="undo_void"
           EXIT DIALOG

        #FUN-D20039 ----------end

        ON ACTION controlg
           LET g_action_choice="controlg"
           EXIT DIALOG

        ON ACTION accept
           LET g_action_choice="detail"
           IF s_industry("slk") THEN
               LET l_ac2 = ARR_CURR()
           ELSE
              LET l_ac = ARR_CURR()
           END IF
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

        ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
           IF li_a THEN
              LET li_a = FALSE
              NEXT FIELD rupslk02
           ELSE
              LET li_a = TRUE
              NEXT FIELD color
           END IF
      END DIALOG  
   ELSE
#FUN-B90101---Add---End--
      DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
    
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
   
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
            CALL t256_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY
    
         ON ACTION previous
            CALL t256_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY
    
         ON ACTION jump
            CALL t256_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY
    
         ON ACTION next
            CALL t256_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY
    
         ON ACTION last
            CALL t256_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY
    
    #FUN-B30025--mark--str--
    #      ON ACTION invalid
    #         LET g_action_choice="invalid"
    #         EXIT DISPLAY
    #FUN-B30025--mark--end--
    
         #ON ACTION reproduce
         #   LET g_action_choice="reproduce"
         #   EXIT DISPLAY
    
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
    
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DISPLAY
   
         ON ACTION out_confirm
            LET g_action_choice="out_confirm"
            EXIT DISPLAY
         
         ON ACTION in_confirm
            LET g_action_choice="in_confirm"
            EXIT DISPLAY
         
    #modify by FUN-AA0086--str--
          ON ACTION triangletrade      #多角貿易
             LET g_action_choice="triangletrade"
             EXIT DISPLAY
    #FUN-B30025--add--str--
          ON ACTION void               #取消作廢功能 
             LET g_action_choice="void"
             EXIT DISPLAY
    #FUN-B30025--add--end--
    #modify by FUN-AA0086--end-- 
         #FUN-D20039 -----------sta
         ON ACTION undo_void               #取消作廢功能
             LET g_action_choice="undo_void"
             EXIT DISPLAY
         #FUN-D20039 -----------end
    
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
    
         AFTER DISPLAY
            CONTINUE DISPLAY
    
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
    
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DISPLAY
        
      END DISPLAY
 
   END IF    #FUN-B90101 add
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t256_in_yes()
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_gen02         LIKE gen_file.gen02 
   DEFINE l_rup03         LIKE rup_file.rup03
   DEFINE l_rup12         LIKE rup_file.rup12
   DEFINE l_rup13         LIKE rup_file.rup13
   DEFINE l_rup16         LIKE rup_file.rup16
   DEFINE l_rup02         LIKE rup_file.rup02
   DEFINE l_rup14         LIKE rup_file.rup14
   DEFINE l_rup15         LIKE rup_file.rup15
   DEFINE l_ruocont       LIKE ruo_file.ruo10t  
   DEFINE l_sql           STRING
   DEFINE l_n2            LIKE type_file.num5              #FUN-B80017 add
   DEFINE i               LIKE type_file.num5              #FUN-B80017 add
   DEFINE l_rupslk13      LIKE rup_file.rup13              #FUN-B90101 add
   DEFINE l_rupslk16      LIKE rup_file.rup16              #FUN-B90101 add
   DEFINE l_rupslk02      LIKE rup_file.rup02              #FUN-B90101 add
   DEFINE l_rupslk14      LIKE rup_file.rup14              #FUN-B90101 add
   DEFINE l_rupslk15      LIKE rup_file.rup15              #FUN-B90101 add
   DEFINE l_result        LIKE type_file.chr1              #MOD-CC0179 add
   DEFINE l_msg           STRING                           #MOD-CC0179 add
 
   IF g_ruo.ruo01 IS NULL OR g_ruo.ruoplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   SELECT * INTO g_ruo.* FROM ruo_file 
      WHERE ruo01=g_ruo.ruo01 
        AND ruoplant = g_ruo.ruoplant 
#modify--FUN-AA0086--str--
   #IF g_ruo.ruoconf <> '1' THEN CALL cl_err('','art-286',0) RETURN END IF
   IF g_ruo.ruoconf = '0' THEN CALL cl_err('','art-286',0)  RETURN END IF #開立狀態不能撥入審核
   IF g_ruo.ruoconf = '2' THEN CALL cl_err('','aim-100',0)  RETURN END IF #已撥入審核 
   IF g_ruo.ruoconf = '3' THEN CALL cl_err('','art-974',0)  RETURN END IF #已結案   
   #IF g_ruo.ruoacti = 'N' THEN CALL cl_err('','art-145',0)  RETURN END IF #無效
   IF g_ruo.ruoconf = 'X' THEN CALL cl_err('','art-380',0)  RETURN END IF #已作廢 #FUN-B30025
 
   IF g_ruo.ruo05 <> g_plant THEN #撥入審核時當前營運中心必須是撥入營運中心   
      CALL cl_err('','art-973',0)
      RETURN
   END IF

# FUN-B80017 add start
   LET l_n2  = g_rec_b
   FOR i=1 TO l_n2               #撥入倉庫是否屬於撥入營運中心
     IF NOT s_chk_ware1(g_rup[i].rup13,g_ruo.ruo05) THEN
        CALL cl_err('','art1006',0)
        RETURN
     END IF
   END FOR
# FUN-B80017 add end
#modify--FUN-AA0086--end-- 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rup_file
    WHERE rup01=g_ruo.ruo01 
      AND rupplant = g_ruo.ruoplant 
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #檢查商品是否有撥入數量和撥入倉庫
  #LET l_sql = "SELECT rup03,rup12,rup13,rup16 FROM rup_file WHERE rup01 = '",       #MOD-CC0179 mark 
   LET l_sql = "SELECT rup03,rup12,rup13,rup14,rup16 FROM rup_file WHERE rup01 = '", #MOD-CC0179 add
               g_ruo.ruo01,"' AND rupplant = '",g_ruo.ruoplant,"'"
   PREPARE t256_rupx FROM l_sql
   DECLARE rup_csx CURSOR FOR t256_rupx
  #FOREACH rup_csx INTO l_rup03,l_rup12,l_rup13,l_rup16         #MOD-CC0179 mark 
   FOREACH rup_csx INTO l_rup03,l_rup12,l_rup13,l_rup14,l_rup16 #MOD-CC0179 add
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #判斷是否有撥出數量
      IF l_rup12 IS NULL OR l_rup12 <= 0 THEN 
         CALL cl_err(l_rup03,'art-317',1)
         RETURN
      END IF
      #判斷是否有撥入倉庫     
      IF l_rup13 IS NULL THEN
         CALL cl_err(l_rup03,'art-318',1)
         RETURN
      END IF
      #判斷是否有撥入數量
     #IF l_rup16 IS NULL OR l_rup16 <= 0 THEN  #TQC-C30061 mark
      IF cl_null(l_rup16) OR l_rup16 < 0 THEN  #TQC-C30061 add 
         CALL cl_err(l_rup03,'art-319',1)
         RETURN
      END IF
      #MOD-CC0179 add start -----
      #撥入倉庫權限檢查
      CALL s_incchk(l_rup13,l_rup14,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET l_msg = l_rup13,'+',l_rup14
         CALL cl_err(l_msg,'asf-888',1)
         RETURN
      END IF
      #MOD-CC0179 add end   -----
     #FUN-CA0086 Begin---
     ##判斷撥入數量是否大于撥出數量
     #IF l_rup16 > l_rup12 THEN
     #   CALL cl_err(l_rup03,'art-320',1)
     #   RETURN
     #END IF
     #FUN-CA0086 End-----
   END FOREACH
 
   IF NOT cl_confirm('art-287') THEN RETURN END IF
   CALL t256_temp('1')   #FUN-AA0086
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t256_cl:", STATUS, 1)
      CLOSE t256_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t256_cl INTO g_ruo.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
      CLOSE t256_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
#mark by FUN-AA0086--str--
#   LET l_ruocont=TIME  
#   UPDATE ruo_file SET ruoconf='2',
#                       ruo12=g_today, 
#                       ruo13=g_user,
#                       ruo12t=l_ruocont  
#     WHERE ruo01=g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
#   IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
#      LET g_success='N'
#      CALL cl_err('','art-321',0)
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   #回寫撥出機構中的審核碼、撥入數量、撥入倉庫
#   UPDATE ruo_file SET ruoconf = '2' WHERE ruo01 = g_ruo.ruo01 
#      AND ruoplant = g_ruo.ruoplant 
#   IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   LET l_sql = "SELECT rup02,rup13,rup14,rup15,rup16 FROM rup_file WHERE rup01 = '",  
#               g_ruo.ruo01,"' AND rupplant = '",g_ruo.ruoplant,"'"                                                                      
#   PREPARE t256_rupx1 FROM l_sql                                                                                                   
#   DECLARE rup_csx1 CURSOR FOR t256_rupx1                                                                                        
#   FOREACH rup_csx1 INTO l_rup02,l_rup13,l_rup14,l_rup15,l_rup16                
#      IF SQLCA.sqlcode THEN                                                                                                         
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                    
#         EXIT FOREACH                                                                                                               
#      END IF
#      UPDATE rup_file SET rup13 = l_rup13,
#                          rup14 = l_rup14,
#                          rup15 = l_rup15,
#                          rup16 = l_rup16
#         WHERE rup01 = g_ruo.ruo01 AND rup02 = l_rup02
#           AND rupplant = g_ruo.ruoplant 
#      IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
#         CALL cl_err('',SQLCA.sqlcode,1)
#         ROLLBACK WORK
#         RETURN
#      END IF
#   END FOREACH 
#   CALL t256_s2()
#mark by FUN-AA0086--end--

#FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      LET l_sql = "SELECT rupslk02,rupslk13,rupslk14,rupslk15,rupslk16 FROM rupslk_file WHERE rupslk01 = '",
                  g_ruo.ruo01,"' AND rupslkplant = '",g_ruo.ruoplant,"'"
      PREPARE t256_rupslkx1 FROM l_sql
      DECLARE rupslk_csx1 CURSOR FOR t256_rupslkx1
      FOREACH rupslk_csx1 INTO l_rupslk02,l_rupslk13,l_rupslk14,l_rupslk15,l_rupslk16
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04,'rupslk_file'),
                     "   SET rupslk13 = '",l_rupslk13,"',",
                     "       rupslk14 = '",l_rupslk14,"',",
                     "       rupslk15 = '",l_rupslk15,"',",
                     "       rupslk16 = '",l_rupslk16,"'",
                     " WHERE rupslk01 = '",g_ruo.ruo011,"'",  #TQC-AC0382
                     "   AND rupslk02 = '",l_rupslk02,"'",
                     "   AND rupslkplant = '",g_ruo.ruo04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
         PREPARE rupslk_uprup FROM l_sql
         EXECUTE rupslk_uprup
         IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
            CALL cl_err('update rupslk_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_sql = "SELECT rup02,rup13,rup14,rup15,rup16 FROM rup_file WHERE rup01 = '",
                     g_ruo.ruo01,"' AND rupplant = '",g_ruo.ruoplant,"' AND rup21s = '",l_rupslk02,"'"
         PREPARE t256_rupx2 FROM l_sql
         DECLARE rup_csx2 CURSOR FOR t256_rupx2
         FOREACH rup_csx2 INTO l_rup02,l_rup13,l_rup14,l_rup15,l_rup16
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                        "   SET rup13 = '",l_rup13,"',",
                        "       rup14 = '",l_rup14,"',",
                        "       rup15 = '",l_rup15,"',",
                        "       rup16 = '",l_rup16,"'",
                        " WHERE rup01 = '",g_ruo.ruo011,"'",  #TQC-AC0382
                        "   AND rup02 = '",l_rup02,"'",
                        "   AND rup21s= '",l_rupslk02,"'",
                        "   AND rupplant = '",g_ruo.ruo04,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql
            PREPARE rup_uprup2 FROM l_sql
            EXECUTE rup_uprup2
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
               CALL cl_err('update rup_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END FOREACH 
      END FOREACH
   ELSE
   #add by FUN-AA0086--str--
      LET l_sql = "SELECT rup02,rup13,rup14,rup15,rup16 FROM rup_file WHERE rup01 = '",
                  g_ruo.ruo01,"' AND rupplant = '",g_ruo.ruoplant,"'"
      PREPARE t256_rupx1 FROM l_sql
      DECLARE rup_csx1 CURSOR FOR t256_rupx1
      FOREACH rup_csx1 INTO l_rup02,l_rup13,l_rup14,l_rup15,l_rup16
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_sql = "UPDATE ",cl_get_target_table(g_ruo.ruo04,'rup_file'),
                     "   SET rup13 = '",l_rup13,"',",
                     "       rup14 = '",l_rup14,"',",
                     "       rup15 = '",l_rup15,"',",
                     "       rup16 = '",l_rup16,"'",
                     #" WHERE rup01 = '",g_ruo.ruo01,"'",
                     " WHERE rup01 = '",g_ruo.ruo011,"'",  #TQC-AC0382
                     "   AND rup02 = '",l_rup02,"'",
                     "   AND rupplant = '",g_ruo.ruo04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
         CALL cl_parse_qry_sql(l_sql,g_ruo.ruo04) RETURNING l_sql 
         PREPARE rup_uprup FROM l_sql
         EXECUTE rup_uprup  
         IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
            CALL cl_err('update rup_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
   #add by FUN-AA0086--end--
   END IF    #FUN-B90101 add
   CALL s_showmsg_init()
   #CALL s_transfer(g_ruo.*,'2','N')#FUN-AA0086
   CALL t256_sub(g_ruo.*,'2','N')
   IF g_success = 'Y' THEN
      COMMIT WORK
      CLOSE t256_cl
   ELSE
      ROLLBACK WORK
      CLOSE t256_cl
      CALL s_showmsg()
   END IF
   CALL t256_temp('2')   #FUN-AA0086
   SELECT * INTO g_ruo.* FROM ruo_file WHERE ruo01=g_ruo.ruo01 
      AND ruoplant = g_ruo.ruoplant 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruo.ruo13
   DISPLAY BY NAME g_ruo.ruo13                                                                                         
   DISPLAY BY NAME g_ruo.ruo12                                                                                         
   DISPLAY BY NAME g_ruo.ruoconf
   DISPLAY l_gen02 TO FORMONLY.ruo13_desc
   DISPLAY BY NAME g_ruo.ruo12t    
   DISPLAY BY NAME g_ruo.ruo15
   DISPLAY BY NAME g_ruo.ruo99
   CALL t256_b_fill(" 1=1"," 1=1")   #FUN-AA0086    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
#FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      CALL t256_b_fill2(" 1=1"," 1=1")
   END IF
#FUN-B90101--add--end--
   
END FUNCTION
#撥入異動庫存
#mark by FUN-AA0086--str--
#FUNCTION t256_s2()
#DEFINE l_qty     LIKE rup_file.rup16
#DEFINE l_img10   LIKE img_file.img10
# 
#    DECLARE t256_s2_c CURSOR FOR SELECT * FROM rup_file 
#                                    WHERE rup01 = g_ruo.ruo01
#                                      AND rupplant = g_ruo.ruoplant 
#    FOREACH t256_s2_c INTO l_rup.*
#       IF STATUS THEN
#          EXIT FOREACH
#       END IF
#       LET g_sql = " SELECT img01,img02,img03,img04 FROM img_file ",
#                  "  WHERE img01= ? ",
#                  "    AND img02= ? ",
#                  "    AND img03= ? ",   #MOD-A80112 ' ' ->?
#                  "    AND img04= ? ",   #MOD-A80112 ' ' ->?
#                  " FOR UPDATE  "
#       LET g_sql=cl_forupd_sql(g_sql)
#
#       DECLARE img_lock_bu1 CURSOR FROM g_sql
#       OPEN img_lock_bu1 USING l_rup.rup03,l_rup.rup13
#                              ,l_rup.rup14,l_rup.rup15      #MOD-A80112 add
#       IF STATUS THEN
#          CALL cl_err("OPEN img_lock_bu1:", STATUS, 1)
#          CLOSE img_lock_bu1
#          LET g_success = 'N'
#          RETURN
#       END IF
#       FETCH img_lock_bu1 INTO g_img01,g_img02,g_img03,g_img04
#       IF STATUS THEN
#          CALL cl_err('img_lock_bu fail',STATUS,1)
#          LET g_success = 'N'
#          RETURN
#       END IF
#       SELECT img10 INTO l_img10 FROM img_file 
#         WHERE img01 = g_img01 AND img02 = g_img02
#           AND img03 = g_img03 AND img04 = g_img04
#       
#       LET l_qty = l_rup.rup16*l_rup.rup08
#       CALL s_upimg(g_img01,g_img02,g_img03,g_img04,+1,l_qty,g_today,l_rup.rup03,
#                    l_rup.rup13,' ',' ',l_rup.rup01,l_rup.rup02,
#                    l_rup.rup07,'',l_rup.rup16,'','','','','',0,0,
#                    '','') 
#       CALL t256_in_log()
#    END FOREACH
#    CALL s_showmsg()
#END FUNCTION
#FUNCTION t256_in_log()
#DEFINE l_img09     LIKE img_file.img09,                                                                        
#       l_img10     LIKE img_file.img10,                                                                        
#       l_img26     LIKE img_file.img26
# 
#    SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
#     #FROM img_file WHERE img01 = l_rup.rup03 AND img02 = l_rup.rup09 #No.FUN-9C0079 
#      FROM img_file WHERE img01 = l_rup.rup03 AND img02 = l_rup.rup13  #No.FUN-9C0079 
##                    AND img03 = ' ' AND img04 = ' '   #MOD-A80112
#                     AND img03 = l_rup.rup14     #MOD-A80112
#                     AND img04 = l_rup.rup15     #MOD-A80112
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3("sel","img_file",l_rup.rup03,"",SQLCA.sqlcode,"","ckp#log",1)
#       LET g_success = 'N'
#       RETURN
#    END IF
#    INITIALIZE g_tlf.* TO NULL
#    LET g_tlf.tlf01 = l_rup.rup03
#    LET g_tlf.tlf020 = g_plant
#    LET g_tlf.tlf02 = 57
#    LET g_tlf.tlf021 = l_rup.rup09
#    LET g_tlf.tlf022 = l_rup.rup10
#    LET g_tlf.tlf023 = l_rup.rup11
#    LET g_tlf.tlf024 = l_img10
#    LET g_tlf.tlf025 = l_rup.rup04
#    LET g_tlf.tlf026 = l_rup.rup01
#    LET g_tlf.tlf027 = l_rup.rup02
#    LET g_tlf.tlf03 = 50
#    LET g_tlf.tlf031 = l_rup.rup13
#    LET g_tlf.tlf032 = l_rup.rup14
#    LET g_tlf.tlf033 = l_rup.rup15
#    LET g_tlf.tlf035 = l_rup.rup04
#    LET g_tlf.tlf036 = l_rup.rup01 
#    LET g_tlf.tlf037 = l_rup.rup02
#    LET g_tlf.tlf04 = ' '                                                                                   
#    LET g_tlf.tlf05 = ' '
#    LET g_tlf.tlf06 = g_today
#    LET g_tlf.tlf07=g_today
#    LET g_tlf.tlf08=TIME
#    LET g_tlf.tlf09=g_user
#    LET g_tlf.tlf10=l_rup.rup16
#    LET g_tlf.tlf11=l_rup.rup04
#    LET g_tlf.tlf12=l_rup.rup08
#    LET g_tlf.tlf13='artt256'
#    LET g_tlf.tlf15=l_img26
#    LET g_tlf.tlf60=l_rup.rup08
#    LET g_tlf.tlf930 = l_rup.rupplant
#    LET g_tlf.tlf903 = ' '
#    LET g_tlf.tlf904 = ' '
#    LET g_tlf.tlf905 = l_rup.rup01
#    LET g_tlf.tlf906 = l_rup.rup02
#    LET g_tlf.tlf907 = 1
#    CALL s_tlf(1,0)
#END FUNCTION
#mark by FUN-AA0086--end--
FUNCTION t256_out_yes()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_gen02    LIKE gen_file.gen02 
   DEFINE l_ruocont  LIKE ruo_file.ruo10t
   DEFINE l_legal    LIKE azw_file.azw02
   DEFINE l_n2       LIKE type_file.num5              #FUN-B80017 add
   DEFINE i          LIKE type_file.num5              #FUN-B80017 add
   DEFINE l_rupslk16 LIKE rupslk_file.rupslk16        #FUN-C60072--ADD---
   DEFINE l_sql      STRING                           #FUN-C60072--ADD---
   DEFINE l_rupslk03 LIKE rupslk_file.rupslk03        #FUN-C60072--ADD---
   DEFINE l_rupslk12 LIKE rupslk_file.rupslk12        #FUN-C60072--ADD---
   DEFINE l_flag1    LIKE type_file.num5              #FUN-C80095 add
   DEFINE l_result   LIKE type_file.chr1              #MOD-CC0179 add
   DEFINE l_rup09    LIKE rup_file.rup09              #MOD-CC0179 add
   DEFINE l_rup10    LIKE rup_file.rup10              #MOD-CC0179 add
   DEFINE l_msg      STRING                           #MOD-CC0179 add
 
   IF g_ruo.ruo01 IS NULL OR g_ruo.ruoplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   SELECT * INTO g_ruo.* FROM ruo_file 
      WHERE ruo01=g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
     
#modify--FUN-AA0086---str---
   IF g_ruo.ruoconf = '1' THEN CALL cl_err('','art-289',0) RETURN END IF #已撥出審核
   IF g_ruo.ruoconf = '2' THEN CALL cl_err('','art-290',0) RETURN END IF #已撥入審核
   IF g_ruo.ruoconf = '3' THEN CALL cl_err('','art-974',0) RETURN END IF #已結案 
   #IF g_ruo.ruoconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF   
   #IF g_ruo.ruoacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF 
   IF g_ruo.ruoconf = 'X' THEN CALL cl_err('','art-380',0)  RETURN END IF #已作廢 #FUN-B30025
   IF g_ruo.ruo04 <> g_plant THEN  #撥出審核時當前營運中心必須為撥出營運中心
      CALL cl_err(g_ruo.ruo04,'art-972',0)
      RETURN
   END IF

# FUN-B80017 add start
   LET l_n2  = g_rec_b
   FOR i=1 TO l_n2             #撥出倉庫是否屬於撥出營運中心
     IF NOT s_chk_ware1(g_rup[i].rup09,g_ruo.ruo04) THEN
        CALL cl_err('','art1005',0)
        RETURN
     END IF
   END FOR
   IF  g_sma.sma142 = 'N' THEN   #不啟用在途倉
     FOR i=1 TO l_n2             #撥入倉庫是否屬於撥入營運中心
       IF NOT s_chk_ware1(g_rup[i].rup13,g_ruo.ruo05) THEN
          CALL cl_err('','art1006',0)
          RETURN
       END IF
     END FOR
   END IF
  #IF  g_sma.sma142 = 'Y' THEN   #啟用在途倉 #FUN-CA0086
   IF g_ruo.ruo02 NOT MATCHES '[89]' THEN                      #FUN-CC0057 add
         IF  g_sma.sma142 = 'Y' AND NOT (g_ruo.ruo02 = '7' AND NOT cl_null(g_ruo.ruo03)) THEN   #啟用在途倉 #FUN-CA0086
           CALL t256_ruo14()           #在途倉是否屬於歸屬營運中心
           IF NOT cl_null(g_errno) THEN
             IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
               CALL cl_err('','art1007',0)
               RETURN
             END IF
             IF g_sma.sma143 = '2' THEN   #調撥在途歸屬撥入方
               CALL cl_err('','art1008',0)
               RETURN
             END IF
           END IF
         END IF  
   END IF      #FUN-CC0057 add

#FUN-C60072-------ADD-----STR-----
   IF s_industry('slk') THEN
      IF g_azw.azw04='2' THEN
         LET l_sql="SELECT rupslk16,rupslk03,rupslk12 FROM rupslk_file WHERE rupslk01='",g_ruo.ruo01,"'"
         PREPARE t256_slk_pre1 FROM l_sql
         DECLARE t256_slk_cs1 CURSOR FOR t256_slk_pre1
         CALL s_showmsg_init()    #FUN-C70098
         FOREACH t256_slk_cs1 INTO l_rupslk16,l_rupslk03,l_rupslk12
            IF l_rupslk16<=0 OR l_rupslk12<=0 THEN
              #CALL cl_err(l_rupslk03,"art1072",1)   #FUN-C70098--mark
              #RETURN                                #FUN-C70098--mark
               CALL s_errmsg('', g_ruo.ruo01 ,l_rupslk03 ,'art1072',1)  #FUN-C70098--add
               LET g_success = 'N'                                      #FUN-C70098--add
            END IF
         END FOREACH
         CALL s_showmsg()         #FUN-C70098
         IF g_success = 'N' THEN  #FUN-C70098
            RETURN                #FUN-C70098
         END IF                   #FUN-C70098
      END IF
   END IF
#FUN-C60072-------ADD-----END-----
# FUN-B80017 add end 
#FUN-B80075 add BEGIN
   LET g_act = 'rup12'  #TQC-BA0179 add
#   LET g_act = 'out_yes'  #TQC-BA0179 mark
   CALL t256_check_img10()        #撥出數量必須小於庫存數量
   #TQC-C20039 add START
  #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
#FUN-D30024 --------Begin------------
#  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
#  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107  #FUN-D30024 mark
#  IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
   INITIALIZE g_imd23 TO NULL    
   CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                        #FUN-D30024 #TQC-D40078 g_ruo.ruo04
   IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
#FUN-D30024 --------End--------------
      CALL cl_err('','mfg3471',0)  
      RETURN   
   END IF  
   #TQC-C20039 add END 
   LET g_act = ''
   IF NOT cl_null(g_errno) THEN
#     CALL cl_err('','art1009',0)      #TQC-BA0179 mark
     CALL cl_err('',g_errno,0)  #TQC-BA0179 add
     RETURN
   END IF
#FUN-B80075 add END
   IF g_ruo.ruo901 = 'Y' AND cl_null(g_ruo.ruo904) THEN
      CALL cl_err(g_ruo.ruo01,'art-995',0)
      RETURN
   END IF
#modify--FUN-AA0086---end--- 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rup_file
    WHERE rup01=g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   #MOD-CC0179 add start -----
   LET l_sql = "SELECT rup09,rup10 FROM rup_file WHERE rup01 = '",
               g_ruo.ruo01,"' AND rupplant = '",g_ruo.ruoplant,"'"
   PREPARE t256_rup_out FROM l_sql
   DECLARE rup_cs_out CURSOR FOR t256_rup_out
   FOREACH rup_cs_out INTO l_rup09,l_rup10
      #撥出倉庫權限檢查
      CALL s_incchk(l_rup09,l_rup10,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET l_msg = l_rup09,'+',l_rup10
         CALL cl_err(l_msg,'asf-888',1)
         RETURN
      END IF
   END FOREACH
   #MOD-CC0179 add end   -----

   IF NOT cl_confirm('art-288') THEN RETURN END IF
   CALL t256_temp('1')   #FUN-AA0086
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t256_cl:", STATUS, 1)
      CLOSE t256_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t256_cl INTO g_ruo.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
      CLOSE t256_cl ROLLBACK WORK RETURN
   END IF
   #FUN-C80095 add begin ---
   #調撥單來源為調撥申請單時,更新申請單的審核碼
   IF g_ruo.ruo02 = '5' THEN
      CALL t256_upd_rvq('3') RETURNING l_flag1
      IF (NOT l_flag1) THEN
         CALL cl_err(g_ruo.ruo01,'art-855',1)
         ROLLBACK WORK
         CLOSE t256_cl
         RETURN
      END IF
   END IF
   #FUN-C80095 add end ---
   LET g_success = 'Y'
#FUN-AA0086--add--str--   
   CALL s_showmsg_init()
   #CALL s_transfer(g_ruo.*,'1','N')
   CALL t256_sub(g_ruo.*,'1','N')

   IF g_success = 'Y' THEN
      COMMIT WORK
      CLOSE t256_cl
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
      CLOSE t256_cl
   END IF
   CALL t256_temp('2')   #FUN-AA0086
#FUN-AA0086--add--end--
#mark by FUN-AA0086--str--
#   LET l_ruocont=TIME   
# 
#   UPDATE ruo_file SET ruoconf='1',
#                       ruo10=g_today, 
#                       ruo11=g_user,
#                       ruo10t=l_ruocont    
#     WHERE ruo01=g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
#   IF SQLCA.sqlerrd[3]=0 THEN
#      LET g_success='N'
#   END IF
# 
#   IF g_success = 'Y' THEN
#      LET g_ruo.ruoconf='1'
#      LET g_ruo.ruo10 = g_today
#      LET g_ruo.ruo11 = g_user
#      CALL t256_s1()
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#   #撥出審核時要復制一筆相同的資料到需求機構中去(機構別變成需求機構ruoplant-->ruo05)
#   #復制單頭資料到需求機構中
#   DROP TABLE y
#   SELECT * FROM ruo_file
#      WHERE ruo01=g_ruo.ruo01 
#        AND ruoplant = g_ruo.ruoplant 
#       INTO TEMP y
#   UPDATE y SET ruoplant = g_ruo.ruo05,
#                ruolegal = (SELECT azw02 FROM azw_file WHERE azw01 = g_ruo.ruo05)
#   INSERT INTO ruo_file SELECT * FROM y
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#      CALL cl_err3("ins","ruo_file","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
#   #復制單身資料到需求機構中
#   DROP TABLE x
#   SELECT * FROM rup_file
#       WHERE rup01=g_ruo.ruo01 
#         AND rupplant = g_ruo.ruoplant 
#       INTO TEMP x
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
#   SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = g_ruo.ruo05
#   UPDATE x SET rupplant = g_ruo.ruo05,
#                ruplegal = l_legal
#   INSERT INTO rup_file SELECT * FROM x
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#      DELETE FROM ruo_file WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruo05
#      CALL cl_err3("ins","rup_file","","",SQLCA.sqlcode,"","",1) 
#      RETURN
#   END IF
#mark by FUN-AA0086--end-- 
   SELECT * INTO g_ruo.* FROM ruo_file 
    WHERE ruo01=g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruo.ruo11
   DISPLAY BY NAME g_ruo.ruo10                                                                                         
   DISPLAY BY NAME g_ruo.ruo11                                                                                         
   DISPLAY BY NAME g_ruo.ruoconf
   DISPLAY l_gen02 TO FORMONLY.ruo11_desc
   DISPLAY BY NAME g_ruo.ruo10t 
   LET l_gen02 = ''                     #TQC-C90007 add 
#FUN-AA0086---add---str---
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruo.ruo13
   DISPLAY BY NAME g_ruo.ruo13
   DISPLAY BY NAME g_ruo.ruo12
   DISPLAY l_gen02 TO FORMONLY.ruo13_desc
   DISPLAY BY NAME g_ruo.ruo12t
   DISPLAY BY NAME g_ruo.ruo15
   DISPLAY BY NAME g_ruo.ruo99
   DISPLAY BY NAME g_ruo.ruo011  #TQC-AC0382
   CALL t256_b_fill(" 1=1"," 1=1")    #FUN-AA0086    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
#FUN-AA0086---add---end---

#FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      CALL t256_b_fill2(" 1=1"," 1=1")
   END IF
#FUN-B90101--add--end--
   
END FUNCTION
#mark by FUN-AA0086--str--
#異動庫存
#FUNCTION t256_s1()
#DEFINE   l_qty     LIKE rup_file.rup12
#DEFINE l_img10   LIKE img_file.img10
# 
#    CALL s_showmsg_init()
#    DECLARE t256_s1_c CURSOR FOR SELECT * FROM rup_file 
#                                    WHERE rup01 = g_ruo.ruo01
#                                      AND rupplant = g_ruo.ruoplant 
#   FOREACH t256_s1_c INTO l_rup.*
#      IF STATUS THEN
#         EXIT FOREACH
#      END IF
#       
#      LET g_sql = " SELECT img01,img02,img03,img04 FROM img_file ",
#                  "  WHERE img01= ? ",
#                  "    AND img02= ? ",
#                  "    AND img03= ? ",        #MOD-A80112 ' ' -> ?
#                  "    AND img04= ? ",        #MOD-A80112 ' ' -> ?
#                  " FOR UPDATE  "
#      LET g_sql=cl_forupd_sql(g_sql)
#
#      DECLARE img_lock_bu CURSOR FROM g_sql
#      OPEN img_lock_bu USING l_rup.rup03,l_rup.rup09
#                            ,l_rup.rup10,l_rup.rup11  #MOD-A80112 add
#      IF STATUS THEN
#         CALL cl_err("OPEN img_lock_bu:", STATUS, 1)
#         CLOSE img_lock_bu
#         ROLLBACK WORK
#         RETURN 0 
#      END IF
#      FETCH img_lock_bu INTO g_img01,g_img02,g_img03,g_img04
#      IF STATUS THEN
#         CALL cl_err('img_lock_bu fail',STATUS,1)
#         RETURN 0
#      END IF
#     
#      LET l_qty = l_rup.rup12*l_rup.rup08
#      CALL s_upimg(g_img01,g_img02,g_img03,g_img04,-1,l_qty,g_today,l_rup.rup03,
#                   l_rup.rup09,' ',' ',l_rup.rup01,l_rup.rup02,
#                   l_rup.rup07,'',l_rup.rup04,'','','','','',0,0,
#                   '','')
##--------產生異動記錄 
#      CALL t256_out_log()
#   END FOREACH
#   CALL s_showmsg()
#END FUNCTION
#FUNCTION t256_out_log()
#DEFINE l_img09     LIKE img_file.img09,       #庫存單位                                                                           
#       l_img10     LIKE img_file.img10,       #庫存數量                                                                           
#       l_img26     LIKE img_file.img26
# 
#    SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
#        FROM img_file WHERE img01 = l_rup.rup03 AND img02 = l_rup.rup09
##                      AND img03 = ' ' AND img04 = ' '   #MOD-A80112
#                       AND img03 = l_rup.rup10          #MOD-A80112
#                       AND img04 = l_rup.rup11          #MOD-A80112
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3("sel","img_file",l_rup.rup03,"",SQLCA.sqlcode,"","ckp#log",1)
#       LET g_success = 'N'
#       RETURN
#    END IF
#    INITIALIZE g_tlf.* TO NULL
# 
#    LET g_tlf.tlf01 = l_rup.rup03      #異動料件編號
#    LET g_tlf.tlf020 = g_plant         #機構別
#    LET g_tlf.tlf02 = 50               #來源狀況
#    LET g_tlf.tlf021 = l_rup.rup09     #倉庫(來源）
#    LET g_tlf.tlf022 = l_rup.rup10     #儲位(來源）
#    LET g_tlf.tlf023 = l_rup.rup11     #批號(來源）
#    LET g_tlf.tlf024 = l_img10         #異動後庫存數量
#    LET g_tlf.tlf025 = l_rup.rup04     #庫存單位
#    LET g_tlf.tlf026 = l_rup.rup01     #單據號碼
#    LET g_tlf.tlf027 = l_rup.rup02     #單據項次
#    LET g_tlf.tlf03 = 66               #資料目的
#    LET g_tlf.tlf031 = l_rup.rup13     #倉庫(目的)
#    LET g_tlf.tlf032 = l_rup.rup14     #儲位(目的)
#    LET g_tlf.tlf033 = l_rup.rup15     #批號(目的)
#    LET g_tlf.tlf035 = l_rup.rup04     #庫存單位
#    LET g_tlf.tlf036 = l_rup.rup01     #參考號碼
#    LET g_tlf.tlf037 = l_rup.rup02     #單據項次
#    LET g_tlf.tlf04 = ' '                #工作站                                                                                    
#    LET g_tlf.tlf05 = ' '                #作業序號
#    LET g_tlf.tlf06 = g_today            #日期
#    LET g_tlf.tlf07=g_today              #異動資料產生日期
#    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
#    LET g_tlf.tlf09=g_user               #產生人
#    LET g_tlf.tlf10=l_rup.rup12          #收料數量
#    LET g_tlf.tlf11=l_rup.rup04          #收料單位 
#    LET g_tlf.tlf12=l_rup.rup08          #收料/庫存轉換率
#    LET g_tlf.tlf13='artt256'            #異動命令代號
#    LET g_tlf.tlf15=l_img26              #倉儲會計科目
#    LET g_tlf.tlf60=l_rup.rup08          #異動單據單位對庫存單位之換算率
#    LET g_tlf.tlf930 = l_rup.rupplant
#    LET g_tlf.tlf903 = ' '
#    LET g_tlf.tlf904 = ' '
#    LET g_tlf.tlf905 = l_rup.rup01
#    LET g_tlf.tlf906 = l_rup.rup02
#    LET g_tlf.tlf907 = -1
#    CALL s_tlf(1,0)
#END FUNCTION
#mark by FUN-AA0086--end--

#modify by FUN-AA0086--str--
#FUN-B30025--add--str--
FUNCTION t256_void(p_type)              #取消作廢功能
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n        LIKE type_file.num5
DEFINE l_flag     LIKE type_file.num5    #FUN-B30025
DEFINE l_void     LIKE type_file.chr1  #y=要作廢，n=取消作廢
DEFINE l_rvqconf  LIKE rvq_file.rvqconf  #FUN-B30025
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_ruo.* FROM ruo_file 
      WHERE ruo01=g_ruo.ruo01 
        AND ruoplant = g_ruo.ruoplant 

   IF g_ruo.ruo01 IS NULL OR g_ruo.ruoplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ruo.ruoconf ='X' THEN RETURN END IF
    ELSE
       IF g_ruo.ruoconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_ruo.ruoconf = '1' OR g_ruo.ruoconf = '2' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF
   IF g_ruo.ruoconf = '3' THEN
      CALL cl_err('','amr-100',0)
      RETURN
   END IF
   
   #IF g_ruo.ruoacti = 'N' THEN CALL cl_err(g_ruo.ruo01,'art-142',0) RETURN END IF
#FUN-B30025--add--str--
   IF g_ruo.ruo02 <>'1' AND g_ruo.ruo02 <>'5' THEN
      CALL cl_err('','art-856',0)
      RETURN
   END IF
#FUN-B30025--add--end--
   BEGIN WORK
 
   OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
   IF STATUS THEN
      CALL cl_err("OPEN t256_cl:", STATUS, 1)
      CLOSE t256_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t256_cl INTO g_ruo.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
      CLOSE t256_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_ruo.ruoconf = 'X' THEN
      LET l_void='Y'
   ELSE
      LET l_void='N'
   END IF

   IF g_ruo.ruoconf = 'X'  AND  g_ruo.ruo02 = '5' THEN
      LET l_rvqconf = ''
      SELECT rvqconf INTO l_rvqconf FROM rvq_file
       WHERE rvq01 = g_ruo.ruo03
         AND rvqplant = g_ruo.ruoplant
      IF cl_null(l_rvqconf) OR l_rvqconf <> '2' THEN
         CALL cl_err(g_ruo.ruo01,'art-858',1)
         CLOSE t256_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF
 
   IF cl_void(0,0,l_void) THEN
      LET g_chr = g_ruo.ruoconf
      IF g_ruo.ruoconf = '0' THEN
         LET g_ruo.ruoconf = 'X'
         #FUN-B30025--add--str--
         #調撥單來源為調撥申請單時,更新申請單的審核碼
         IF g_ruo.ruo02 = '5' THEN
            CALL t256_upd_rvq('2') RETURNING l_flag
            IF (NOT l_flag) THEN
               CALL cl_err(g_ruo.ruo01,'art-857',1)
               CLOSE t256_cl
               ROLLBACK WORK
               RETURN
            END IF
         END IF 
         #FUN-B30025--add--end--
      ELSE
         LET g_ruo.ruoconf = '0'
         #FUN-B30025--add--str--
         #調撥單來源為調撥申請單時,更新申請單的審核碼
         IF g_ruo.ruo02 = '5' THEN
            CALL t256_upd_rvq('3') RETURNING l_flag
            IF (NOT l_flag) THEN
               CALL cl_err(g_ruo.ruo01,'art-857',1)
               CLOSE t256_cl
               ROLLBACK WORK
               RETURN
            END IF
         END IF  
         #FUN-B30025--add--end--
      END IF
      UPDATE ruo_file SET ruoconf=g_ruo.ruoconf,
                          ruomodu=g_user,
                          ruodate=g_today
       WHERE ruo01 = g_ruo.ruo01 
         AND ruoplant = g_ruo.ruoplant 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","up ruoconf",1)
          LET g_ruo.ruoconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t256_cl
   COMMIT WORK
 
   SELECT * INTO g_ruo.* FROM ruo_file WHERE ruo01=g_ruo.ruo01 
      AND ruoplant = g_ruo.ruoplant 
   DISPLAY BY NAME g_ruo.ruoconf                                                                                        
   DISPLAY BY NAME g_ruo.ruomodu                                                                                        
   DISPLAY BY NAME g_ruo.ruodate
END FUNCTION
#FUN-B30025--add--end--

FUNCTION t256_v()     #多角貿易
   DEFINE l_poz02   LIKE poz_file.poz02
   DEFINE l_poy03   LIKE poy_file.poy03
   DEFINE l_poy31   LIKE poy_file.poy03
   DEFINE l_poy32   LIKE poy_file.poy03
   DEFINE l_poy33   LIKE poy_file.poy03
   DEFINE l_poy34   LIKE poy_file.poy03
   DEFINE l_poy35   LIKE poy_file.poy03
   DEFINE l_poy36   LIKE poy_file.poy03
   DEFINE i         LIKE type_file.num5

   IF g_ruo.ruo01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_ruo.ruo901='N' THEN
      CALL cl_err("",'tri-014',0)
      RETURN
   END IF
   
   SELECT * INTO g_ruo.* FROM ruo_file WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
  #FUN-CA0086 Begin---
   IF g_argv2 = '2' THEN
      IF NOT cl_null(g_ruo.ruo03) THEN
         SELECT ruo904 INTO g_ruo.ruo904 FROM ruo_file
          WHERE ruo01 = g_ruo.ruo03
         UPDATE ruo_file SET * = g_ruo.* WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1)
         END IF
      END IF
   END IF
  #FUN-CA0086 End-----

   OPEN WINDOW t256_vw WITH FORM "art/42f/artt256_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("artt256_1")
   LET g_success = 'Y'
   MENU ""
      BEFORE MENU
         LET l_poz02 = NULL
         LET l_poy31 = NULL  LET l_poy32 = NULL
         LET l_poy33 = NULL  LET l_poy34 = NULL
         LET l_poy35 = NULL  LET l_poy36 = NULL
         IF NOT cl_null(g_ruo.ruo904) THEN
            SELECT poz02 INTO l_poz02 FROM poz_file WHERE poz01 = g_ruo.ruo904
            FOR i = 0 TO 5
               SELECT poy03 INTO l_poy03 FROM poy_file
                WHERE poy01 = g_ruo.ruo904 AND poy02 = i
               IF SQLCA.sqlcode = 100 THEN
                  LET l_poy03 = NULL
               END IF
               CASE i
                  WHEN 0 LET l_poy31 = l_poy03
                  WHEN 1 LET l_poy32 = l_poy03
                  WHEN 2 LET l_poy33 = l_poy03
                  WHEN 3 LET l_poy34 = l_poy03
                  WHEN 4 LET l_poy35 = l_poy03
                  WHEN 5 LET l_poy36 = l_poy03
               END CASE
            END FOR
            DISPLAY l_poz02 TO FORMONLY.poz02
            DISPLAY l_poy31 TO FORMONLY.poy31
            DISPLAY l_poy32 TO FORMONLY.poy32
            DISPLAY l_poy33 TO FORMONLY.poy33
            DISPLAY l_poy34 TO FORMONLY.poy34
            DISPLAY l_poy35 TO FORMONLY.poy35
            DISPLAY l_poy36 TO FORMONLY.poy36
            DISPLAY BY NAME g_ruo.ruo904
            IF g_ruo.ruoconf MATCHES '[123]' OR g_ruo.ruoacti = 'N' THEN
               CALL cl_set_act_visible("modify", FALSE)
            END IF
            IF g_ruo.ruoconf MATCHES '[123]' OR g_ruo.ruoacti = 'N' THEN
               CALL cl_set_act_visible("delete", FALSE)
            END IF
            CALL cl_set_act_visible("insert", FALSE)
         ELSE
            CALL t256_v_1()
            IF g_success = 'Y' THEN
               UPDATE ruo_file SET * = g_ruo.* WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1)
               END IF
            END IF            
            CALL cl_set_act_visible("insert", TRUE)
            CALL cl_set_act_visible("modify", FALSE)
            CALL cl_set_act_visible("delete", FALSE)
         END IF
        #FUN-CA0086 Begin---
         IF g_argv2 = '2' AND NOT cl_null(g_ruo.ruo03) THEN
            CALL cl_set_act_visible("insert", FALSE)
            CALL cl_set_act_visible("modify", FALSE)
            CALL cl_set_act_visible("delete", FALSE)
         END IF
        #FUN-CA0086 End-----

      ON ACTION modify
         IF cl_null(g_ruo.ruo904) THEN
            CALL cl_err(g_ruo.ruo904,100,0)
         ELSE
            CALL t256_v_1()
            IF g_success = 'Y' THEN
               UPDATE ruo_file SET * = g_ruo.* WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1)
               END IF
            END IF
         END IF

      ON ACTION delete
         IF cl_null(g_ruo.ruo904) THEN
            CALL cl_err(g_ruo.ruo904,100,0)
         ELSE
            IF cl_delete() THEN
                INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "ruo01"         #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_ruo.ruo01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                                 #No.FUN-9B0098 10/02/24
               LET g_ruo.ruo904 = NULL
               
               UPDATE ruo_file SET * = g_ruo.* WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1)
               END IF
               CLEAR FORM
               CALL cl_set_act_visible("insert", TRUE)
               CALL cl_set_act_visible("modify", FALSE)
               CALL cl_set_act_visible("delete", FALSE)
            END IF
         END IF

      ON ACTION insert
         CALL t256_v_1()
         IF g_success = 'Y' THEN
            UPDATE ruo_file SET * = g_ruo.* WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
         IF NOT cl_null(g_ruo.ruo904) THEN
            CALL cl_set_act_visible("modify", TRUE)
            CALL cl_set_act_visible("delete", TRUE)
            CALL cl_set_act_visible("insert", FALSE)
         ELSE
            CALL cl_set_act_visible("insert", TRUE)
         END IF

      ON ACTION exit               #"Esc.結束"
         EXIT MENU

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU

      ON ACTION about
         CALL cl_about()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION help
         CALL cl_show_help()

      COMMAND KEY(INTERRUPT)
         LET INT_FLAG = 0
         EXIT MENU

   END MENU
   CALL cl_set_act_visible("modify,delete,insert", TRUE)
   CLOSE WINDOW t256_vw

END FUNCTION

FUNCTION t256_v_1()
   DEFINE   l_poz02   LIKE poz_file.poz02,
            l_poy03   LIKE poy_file.poy03,
            l_poy31   LIKE poy_file.poy03,
            l_poy32   LIKE poy_file.poy03,
            l_poy33   LIKE poy_file.poy03,
            l_poy34   LIKE poy_file.poy03,
            l_poy35   LIKE poy_file.poy03,
            l_poy36   LIKE poy_file.poy03,
            i         LIKE type_file.num5
DEFINE l_poz          RECORD LIKE poz_file.*

   LET g_ruo_t.ruo904 = g_ruo.ruo904
   INPUT BY NAME g_ruo.ruo904 WITHOUT DEFAULTS
      AFTER FIELD ruo904
         IF NOT cl_null(g_ruo.ruo904)  THEN
            IF g_ruo.ruo904 != g_ruo_t.ruo904 OR g_ruo_t.ruo904 IS NULL THEN
               CALL t256_ruo904('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_ruo.ruo904,g_errno,1)
                  LET g_ruo.ruo904 = g_ruo_t.ruo904
                  DISPLAY BY NAME g_ruo.ruo904
                  NEXT FIELD ruo904
               END IF
               FOR i = 0 TO 6
                   SELECT poy03 INTO l_poy03 FROM poy_file
                    WHERE poy01 = g_ruo.ruo904 AND poy02 = i
                   IF SQLCA.sqlcode = 100 THEN
                      LET l_poy03 = NULL
                   END IF
                   CASE i
                      WHEN 0 LET l_poy31 = l_poy03
                      WHEN 1 LET l_poy32 = l_poy03
                      WHEN 2 LET l_poy33 = l_poy03
                      WHEN 3 LET l_poy34 = l_poy03
                      WHEN 4 LET l_poy35 = l_poy03
                      WHEN 5 LET l_poy36 = l_poy03
                   END CASE
               END FOR
               SELECT poz02 INTO l_poz02 FROM poz_file WHERE poz01 = g_ruo.ruo904
               DISPLAY l_poz02 TO FORMONLY.poz02
               DISPLAY l_poy31 TO FORMONLY.poy31
               DISPLAY l_poy32 TO FORMONLY.poy32
               DISPLAY l_poy33 TO FORMONLY.poy33
               DISPLAY l_poy34 TO FORMONLY.poy34
               DISPLAY l_poy35 TO FORMONLY.poy35
               DISPLAY l_poy36 TO FORMONLY.poy36               
               END IF
            END IF

         ON ACTION CONTROLP
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_poz1"
            LET g_qryparam.arg1 = '2'
            LET g_qryparam.default1 = g_ruo.ruo904
            CALL cl_create_qry() RETURNING g_ruo.ruo904
            DISPLAY BY NAME g_ruo.ruo904
            NEXT FIELD ruo904

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
            EXIT INPUT

      END INPUT
      IF INT_FLAG THEN
         LET g_success = 'N'
         LET INT_FLAG = 0
         LET g_ruo.ruo904 = g_ruo_t.ruo904
      END IF
END FUNCTION

FUNCTION t256_ruo904(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_poz       RECORD LIKE poz_file.*
   DEFINE l_poy04_min LIKE poy_file.poy04
   DEFINE l_poy04_max LIKE poy_file.poy04

   LET g_errno = NULL
   
   SELECT * INTO l_poz.* FROM poz_file
    WHERE poz01 = g_ruo.ruo904
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'tri-006'
       WHEN l_poz.pozacti='N'    LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) AND (l_poz.poz00 = '1' OR l_poz.poz011 = '1') THEN #類別必須為代採購
     LET g_errno= 'art-969'
     RETURN
  END IF
  IF cl_null(g_errno) AND p_cmd <> 'd' THEN
    #FUN-CA0086 Begin---
     IF g_argv2 = '2' THEN
        SELECT poy04 INTO l_poy04_min
          FROM poy_file
         WHERE poy01 = g_ruo.ruo904
           AND poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01 = g_ruo.ruo904)

        SELECT poy04 INTO l_poy04_max
          FROM poy_file
         WHERE poy01 = g_ruo.ruo904
           AND poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = g_ruo.ruo904)

        IF l_poy04_min <> g_ruo.ruo04 THEN
           LET g_errno = 'art-886'
           RETURN
        END IF
        IF l_poy04_max <> g_ruo.ruo05 THEN
           LET g_errno = 'art-887'
           RETURN
        END IF
     ELSE
    #FUN-CA0086 End-----
        SELECT poy04 INTO l_poy04_min
          FROM poy_file
         WHERE poy01 = g_ruo.ruo904
           AND poy02 = (SELECT MIN(poy02) FROM poy_file WHERE poy01 = g_ruo.ruo904)
           
        SELECT poy04 INTO l_poy04_max
          FROM poy_file
         WHERE poy01 = g_ruo.ruo904
           AND poy02 = (SELECT MAX(poy02) FROM poy_file WHERE poy01 = g_ruo.ruo904)
          
        IF l_poy04_min <> g_ruo.ruo05 THEN
           LET g_errno = 'art-970'
           RETURN
        END IF
        IF l_poy04_max <> g_ruo.ruo04 THEN
           LET g_errno = 'art-971'
           RETURN
        END IF
     END IF #FUN-CA0086
  END IF
  DISPLAY l_poz.poz02 TO FORMONLY.poz02
END FUNCTION
#modify by FUN-AA0086--end--

FUNCTION t256_bp_refresh()
  DISPLAY ARRAY g_rup TO s_rup.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t256_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   #DEFINE l_azp02     LIKE azp_file.azp02
   #DEFINE l_azp03     LIKE azp_file.azp03
   DEFINE l_azw08     LIKE azw_file.azw08   #FUN-AA0086   
   DEFINE l_gen02     LIKE gen_file.gen02
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rup.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruo.* LIKE ruo_file.*
   LET g_ruo01_t = NULL
   LET g_ruoplant_t = NULL
   
   LET g_ruo_t.* = g_ruo.*
   LET g_ruo_o.* = g_ruo.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruo.ruouser=g_user
      LET g_ruo.ruooriu = g_user #FUN-980030
      LET g_ruo.ruoorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #TQC-A10128 ADD
      LET g_ruo.ruogrup=g_grup
      LET g_ruo.ruoacti='Y'
      LET g_ruo.ruocrat = g_today
      LET g_ruo.ruoconf = '0'
      LET g_ruo.ruo02 = '1'          
      LET g_ruo.ruo04 = g_plant
      LET g_ruo.ruoplant = g_plant
      LET g_ruo.ruolegal = g_legal
      LET g_ruo.ruo07 = g_today
      LET g_ruo.ruo08 = g_user
#      LET g_ruo.ruopos='N'
      LET g_ruo.ruopos='Y'      #FUN-AA0086 
      LET g_ruo.ruo15 = 'N'     #FUN-AA0086 當前營運中心過帳否
      LET g_ruo.ruo901 = 'N'    #FUN-AA0086 多角貿易否
#modify FUN-AA0086---str---      
#      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo04
#      DISPLAY l_azp02 TO ruo04_desc
#      DISPLAY l_azp02 TO ruoplant_desc
      SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruo04
      DISPLAY l_azw08 TO ruo04_desc
      DISPLAY l_azw08 TO ruoplant_desc
#modify FUN-AA0086---end---       
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo08
      DISPLAY l_gen02 TO rto08_desc
      IF g_argv2 = '2' THEN LET g_ruo.ruo02 = '7' END IF #FUN-CA0086
      CALL t256_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_ruo.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruo.ruo01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_ruo.ruo01,g_today,"","ruo_file",     #FUN-A70130 mark                                                        
#                                  "ruo01","","","")                     #FUN-A70130 mark                                                           
      CALL s_auto_assign_no("art",g_ruo.ruo01,g_today,"J1","ruo_file",     #FUN-A70130 mod                                                        
                                   "ruo01","","","")                     #FUN-A70130 mod                                                           
                RETURNING li_result,g_ruo.ruo01
      IF (NOT li_result) THEN                                                                                                      
         CONTINUE WHILE                                                                                                           
      END IF                                                                                                                       
      DISPLAY BY NAME g_ruo.ruo01
      INSERT INTO ruo_file VALUES (g_ruo.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("ins","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ruo.ruo01,'I')
      END IF
 
      LET g_ruo01_t = g_ruo.ruo01
      LET g_ruo_t.* = g_ruo.*
      LET g_ruo_o.* = g_ruo.*
      #TQC-C90058 add begin ---
      IF cl_null(g_ruo.ruo03) THEN
         CALL cl_set_comp_visible("rup17",FALSE)
      ELSE
         CALL cl_set_comp_visible("rup17",TRUE)
      END IF
      #TQC-C90058 add end -----
#modify FUN-AA0086---str--- 
      IF g_ruo.ruo901 = 'Y' THEN
         CALL t256_v()                            #多角貿易流程代碼
      END IF 
 
      IF g_ruo.ruo02 = '1' THEN
         CALL g_rup.clear()
         LET g_rec_b = 0
#FUN-B90101--add--begin--
         IF s_industry("slk") THEN
            CALL g_rupslk.clear()
            CALL g_imx.clear()
            LET g_rec_b2 = 0
            LET g_rec_b3 = 0
         END IF       
#FUN-B90101--add--end--
      ELSE
         CALL t256_ruo03_1()
#FUN-B90101--add--begin--
         IF s_industry("slk") THEN
            CALL t256_b_fill2(" 1=1"," 1=1") 
         END IF
#FUN-B90101--add--end--
      END IF
      CALL t256_b()
#modify FUN-AA0086---end---
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t256_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruo.ruo01 IS NULL AND g_ruo.ruoplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruo.* FROM ruo_file
    WHERE ruo01=g_ruo.ruo01
      AND ruoplant = g_ruo.ruoplant 
 
#FUN-B30025--mark--str--
#   IF g_ruo.ruoacti ='N' THEN
#      CALL cl_err(g_ruo.ruo01,'mfg1000',0)
#      RETURN
#   END IF
#FUN-B30025--mark--end--
#FUN-B30025--add--str--
    IF g_ruo.ruoconf ='X' THEN
       CALL cl_err(g_ruo.ruo01,'art-025',0)
       RETURN
    END IF
#FUN-B30025--add--end--
   
   IF g_ruo.ruoconf = '1' OR g_ruo.ruoconf = '2' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF

#add--FUN-AA0086--str--
   IF g_ruo.ruoconf = '3' THEN   
      CALL cl_err('','amr-100',0)
      RETURN
   END IF
#add--FUN-AA0086--end--

#mark FUN-AA0086---str--- 
#   IF g_ruo.ruoconf = 'X' THEN
#      CALL cl_err('','art-025',0)
#      RETURN
#   END IF
#mark FUN-AA0086---end---   
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ruo01_t = g_ruo.ruo01
 
   BEGIN WORK
 
   OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t256_cl:", STATUS, 1)
      ROLLBACK WORK
      CLOSE t256_cl
      RETURN
   END IF
 
   FETCH t256_cl INTO g_ruo.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       CLOSE t256_cl
       RETURN
   END IF
 
   CALL t256_show()
 
   WHILE TRUE
      LET g_ruo01_t = g_ruo.ruo01
      LET g_ruoplant_t = g_ruo.ruoplant
      LET g_ruo_o.* = g_ruo.*
      LET g_ruo.ruomodu=g_user
      LET g_ruo.ruodate=g_today
      #LET g_ruo.ruopos='N' 
      CALL t256_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruo.*=g_ruo_t.*
         CALL t256_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruo.ruo01 != g_ruo01_t THEN
         UPDATE rup_file SET rup01 = g_ruo.ruo01,rupplant = g_ruo.ruoplant
           WHERE rup01 = g_ruo01_t AND rupplant = g_ruoplant_t 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rup_file",g_ruo01_t,"",SQLCA.sqlcode,"","rup",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF

      #FUN-A30030 ADD---------------------
      # IF g_aza.aza88='Y' THEN
      #    LET g_ruo.ruopos='N'
      # END IF 
      #FUN-A30030 END--------------------- 
      UPDATE ruo_file SET ruo_file.* = g_ruo.*
       WHERE ruo01 = g_ruo.ruo01
         AND ruoplant = g_ruo.ruoplant 
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruo_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t256_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruo.ruo01,'U')
 
   CALL t256_b_fill(" 1=1"," 1=1")   #FUN-AA0086    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
   CALL t256_bp_refresh()
 
END FUNCTION
 
FUNCTION t256_i(p_cmd)
DEFINE
   l_pmc05     LIKE pmc_file.pmc05,
   l_pmc30     LIKE pmc_file.pmc30,
   l_n         LIKE type_file.num5,
   p_cmd       LIKE type_file.chr1,
   li_result   LIKE type_file.num5,
#   l_azp02     LIKE azp_file.azp02,
   l_azw08     LIKE azw_file.azw08,   #FUN-AA0086
   l_gen02     LIKE gen_file.gen02
#   l_azp03     LIKE azp_file.azp03
 
   IF s_shut(0) THEN
      RETURN
   END IF
   LET g_cmd = p_cmd  #FUN-B90068 add
 
   #DISPLAY BY NAME g_ruo.ruo01,g_ruo.ruo02,g_ruo.ruo03,
   DISPLAY BY NAME g_ruo.ruo01,g_ruo.ruo011,g_ruo.ruo02,g_ruo.ruo03,#TQC-AC0382 add ruo011
                 #  g_ruo.ruo04,g_ruo.ruo05,g_ruo.ruo06,
                   g_ruo.ruo04,g_ruo.ruo05, #FUN-AA0086 drop 06
                   g_ruo.ruo07,g_ruo.ruo08,g_ruo.ruo10,
                   g_ruo.ruo11,g_ruo.ruo12,g_ruo.ruo13,
                   g_ruo.ruoconf,g_ruo.ruo10t,g_ruo.ruo12t,
                   #g_ruo.ruoplant,g_ruo.ruo09,g_ruo.ruopos, 
                   g_ruo.ruoplant,g_ruo.ruo09, #TQC-AC0382
                   g_ruo.ruo14,g_ruo.ruo15,g_ruo.ruo99,g_ruo.ruo901, #FUN-AA0086 add
                   g_ruo.ruouser,g_ruo.ruomodu,g_ruo.ruogrup,
                 # g_ruo.ruodate,g_ruo.ruoacti
                   g_ruo.ruodate,                     #FUN-B30025
                   g_ruo.ruooriu,g_ruo.ruoorig        #TQC-A30041 ADD

# modify by FUN-AA0086---str---                  
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo04
#   DISPLAY l_azp02 TO ruo04_desc
#   
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo05
#   DISPLAY l_azp02 TO ruo05_desc
#   
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo06
#   DISPLAY l_azp02 TO ruo06_desc 
# 
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruoplant
#   DISPLAY l_azp02 TO ruoplant_desc 
 
   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruo04
   DISPLAY l_azw08 TO ruo04_desc 
   
   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruo05
   DISPLAY l_azw08 TO ruo05_desc
   
   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruoplant
   DISPLAY l_azw08 TO ruoplant_desc 
# modify by FUN-AA0086---end---
   
   LET l_gen02 = NULL 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo08
   DISPLAY l_gen02 TO ruo08_desc
   
   LET l_gen02 = NULL 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo11
   DISPLAY l_gen02 TO ruo11_desc
   
   LET l_gen02 = NULL 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo13
   DISPLAY l_gen02 TO ruo13_desc                
 
   CALL cl_set_head_visible("","YES")
#modify by FUN-AA0086---str---   
#   INPUT BY NAME g_ruo.ruo01,g_ruo.ruo02,g_ruo.ruo03, g_ruo.ruooriu,g_ruo.ruoorig,
#                 g_ruo.ruo04,g_ruo.ruo05,g_ruo.ruo06,
#                 g_ruo.ruo07,g_ruo.ruo08,g_ruo.ruo10,
#                 g_ruo.ruo12,
#                 g_ruo.ruoconf,g_ruo.ruoplant,g_ruo.ruo09,
#                 g_ruo.ruouser,
#                 g_ruo.ruomodu,g_ruo.ruoacti,g_ruo.ruogrup,
#                 g_ruo.ruodate,g_ruo.ruocrat
   INPUT BY NAME g_ruo.ruo01,g_ruo.ruo02,g_ruo.ruo03,g_ruo.ruo07,
                 g_ruo.ruo08,g_ruo.ruoplant,g_ruo.ruo04,g_ruo.ruo05,
                 g_ruo.ruo14,g_ruo.ruo09
#modify by FUN-AA0086---end---                   
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t256_set_entry(p_cmd)
         CALL t256_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ruo01")
 
      AFTER FIELD ruo01
         IF NOT cl_null(g_ruo.ruo01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruo.ruo01 != g_ruo_t.ruo01) THEN
#              CALL s_check_no("art",g_ruo.ruo01,g_ruo01_t,"F","ruo_file","ruo01","")  #FUN-A70130 mark                                            
               CALL s_check_no("art",g_ruo.ruo01,g_ruo01_t,"J1","ruo_file","ruo01","")  #FUN-A70130 mod                                            
                    RETURNING li_result,g_ruo.ruo01                                                                                 
               IF (NOT li_result) THEN                                                                                              
                   LET g_ruo.ruo01=g_ruo01_t                                                                                        
                   NEXT FIELD ruo01                                                                                                 
               END IF
            END IF
         END IF

#FUN-AA0086 add ---str---
     BEFORE FIELD ruo02
        CALL cb.removeItem('2')
        CALL cb.removeItem('3')
        CALL cb.removeItem('4')
        CALL cb.removeItem('6') #FUN-BA0097 add 
        CALL cb.removeItem('8') #FUN-CC0057 add
        CALL cb.removeItem('9') #FUN-CC0057 add
        CALL cb.removeItem('P')
     ON CHANGE ruo02
        CALL t256_set_entry(p_cmd)
        CALL t256_set_no_entry(p_cmd)

     AFTER FIELD ruo03
        IF NOT cl_null(g_ruo.ruo03) THEN
           #FUN-C80095 add begin ---
            IF g_ruo.ruo02 = '5' THEN
               LET g_cnt = 0
               IF p_cmd = 'a' THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM ruo_file
                   WHERE ruo02 = '5'
                     AND ruo03 = g_ruo.ruo03
                     AND ruoplant = g_ruo.ruoplant
               ELSE 
                  SELECT COUNT(*) INTO g_cnt
                    FROM ruo_file
                   WHERE ruo02 = '5'
                     AND ruo03 = g_ruo.ruo03
                     AND ruoplant = g_ruo.ruoplant
                     AND ruo01 <> g_ruo_t.ruo01
               END IF 
               IF g_cnt > 0 THEN
                  CALL cl_err('','art1077',0)
                  LET g_ruo.ruo03 = g_ruo_t.ruo03
                  NEXT FIELD ruo03
               END IF
            END IF
           #FUN-C80095 add end ---
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruo.ruo03 != g_ruo_t.ruo03) THEN
               CALL t256_ruo03()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                               
                  CALL cl_err('',g_errno,0)                                                                                     
                  NEXT FIELD ruo03                                                                                            
               END IF
            END IF
         END IF

     #FUN-D10106--add--str---
      AFTER FIELD ruo07
         IF g_ruo.ruo07 <= g_sma.sma53 THEN
            CALL cl_err(g_ruo.ruoplant,'mfg9999',0)
            NEXT FIELD ruo07
         END IF
     #FUN-D10106--add--end---
      BEFORE FIELD ruo14
         IF cl_null(g_ruo.ruo04) THEN
            CALL cl_err('','art-964',0)
            NEXT FIELD ruo04
         END IF
         IF cl_null(g_ruo.ruo05) THEN
            CALL cl_err('','art-964',0)
            NEXT FIELD ruo05
         END IF
         
      AFTER FIELD ruo14
         IF NOT cl_null(g_ruo.ruo14) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruo.ruo14 != g_ruo_t.ruo14) THEN
               CALL t256_ruo14()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                               
                  CALL cl_err('',g_errno,0)                                                                                     
                  NEXT FIELD ruo14                                                                                            
               END IF
            END IF
         END IF  
#FUN-AA0086 add ---end---
         
      AFTER FIELD ruo05
         IF NOT cl_null(g_ruo.ruo05) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruo.ruo05 != g_ruo_t.ruo05) THEN
#mark by FUN-AA0086---STR--- #              
#               IF g_ruo.ruo05 = g_ruo.ruo04 THEN   
#                  CALL cl_err('','art-332',0)
#                  NEXT FIELD ruo05
#               END IF
#mark by FUN-AA0086---END---    
               CALL t256_ruo05()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                    
                  CALL cl_err('',g_errno,0)                                                                                         
                  NEXT FIELD ruo05              
               END IF
#FUN-AA0086 add ---SRT--- 
               CALL  t256_chk_azw02()  #法人不同時，為Y否則為N                                                                                   
#FUN-AA0086 add ---end--- 
            END IF
         END IF
         
#mark by FUN-AA0086---str---
#      AFTER FIELD ruo06
#         IF NOT cl_null(g_ruo.ruo06) THEN
#            IF p_cmd='a' OR 
#               (p_cmd='u' AND g_ruo.ruo06 != g_ruo_t.ruo06) THEN
#               CALL t256_ruo06()                                                                                                  
#               IF NOT cl_null(g_errno)  THEN                                                                                        
#                  CALL cl_err('',g_errno,0)                                                                                         
#                  NEXT FIELD ruo06                                                                                                  
#               END IF
#            END IF
#         END IF
#mark by FUN-AA0086---end---
      
      AFTER FIELD ruo08
         IF NOT cl_null(g_ruo.ruo08) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruo.ruo08 != g_ruo_t.ruo08) THEN
               CALL t256_ruo08()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                               
                  CALL cl_err('',g_errno,0)                                                                                     
                  NEXT FIELD ruo08                                                                                            
               END IF
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
            WHEN INFIELD(ruo01)
               LET g_t1=s_get_doc_no(g_ruo.ruo01)
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','F') RETURNING g_t1  #FUN-A70130--mark--
               CALL q_oay(FALSE,FALSE,g_t1,'J1','ART') RETURNING g_t1  #FUN-A70130--mod--
               LET g_ruo.ruo01 = g_t1
               DISPLAY BY NAME g_ruo.ruo01
               NEXT FIELD ruo01
            #開與出貨機構在同一運營中心的所有機構(除出貨機構外)
            WHEN INFIELD(ruo05)
               CALL cl_init_qry_var()
               #找出出貨機構對應的營運中心
#modify FUN-AA0086---str---               
#               SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_ruo.ruo04
#               LET g_qryparam.form ="q_azp01_1"
#               LET g_qryparam.arg1 = l_azp03
#               LET g_qryparam.arg2 = g_ruo.ruo04
               LET g_qryparam.form ="q_azw01_1"
#modify FUN-AA0086---end---                 
               LET g_qryparam.default1 = g_ruo.ruo05
               CALL cl_create_qry() RETURNING g_ruo.ruo05
               DISPLAY BY NAME g_ruo.ruo05
               CALL t256_ruo05()
               NEXT FIELD ruo05
 
#modify by FUN-AA0086---str---
#            WHEN INFIELD(ruo06)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_azp"
#               LET g_qryparam.default1 = g_ruo.ruo06
#               CALL cl_create_qry() RETURNING g_ruo.ruo06
#               DISPLAY BY NAME g_ruo.ruo06
#               CALL t256_ruo06()
#               NEXT FIELD ruo06              

            WHEN INFIELD(ruo03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ruo03"
               LET g_qryparam.where = "rvq07 = rvqplant "  #TQC-AC0382
               LET g_qryparam.arg1 = g_ruo.ruoplant
               CALL cl_create_qry() RETURNING g_ruo.ruo03
               DISPLAY BY NAME g_ruo.ruo03
               NEXT FIELD ruo03 

            WHEN INFIELD(ruo14)
               CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_imd"
               LET g_qryparam.form ="q_imd004"   #FUN-BA0004 add
               LET g_qryparam.arg1  ="W"
           #FUN-BA0004 add START
               IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
                  LET g_qryparam.arg2 = g_ruo.ruo04
               ELSE
                  LET g_qryparam.arg2 = g_ruo.ruo05
               END IF
           #FUN-BA0004 add END
               CALL cl_create_qry() RETURNING g_ruo.ruo14
               DISPLAY BY NAME g_ruo.ruo14
               NEXT FIELD ruo14            
#modify by FUN-AA0086---end---
 
            WHEN INFIELD(ruo08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_ruo.ruo08
               CALL cl_create_qry() RETURNING g_ruo.ruo08
               DISPLAY BY NAME g_ruo.ruo08
               CALL t256_ruo08()
               NEXT FIELD ruo08
               
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
 
END FUNCTION
 
# 
FUNCTION t256_ruo05()
DEFINE l_azw08     LIKE azw_file.azw08 #FUN-AA0086
DEFINE l_plant1    LIKE azp_file.azp01 #FUN-AA0086
      # l_azp02     LIKE azp_file.azp02,
      # l_azp03_1   LIKE azp_file.azp03,
      # l_azp03_2   LIKE azp_file.azp03
#DEFINE l_azw02_1   LIKE azw_file.azw02
#DEFINE l_azw02_2   LIKE azw_file.azw02
 
   LET g_errno = " "

#modify by FUN-AA0086---STR---   
#   SELECT azp02,azp03 
#     INTO l_azp02,l_azp03_1
#     FROM azp_file WHERE azp01 = g_ruo.ruo05
    SELECT azw08 INTO l_azw08 
      FROM azw_file 
     WHERE azw01 = g_ruo.ruo05 AND azwacti = 'Y'
#modify by FUN-AA0086---END---  
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-044'
                           RETURN
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_azw08 TO FORMONLY.ruo05_desc
   END CASE

#modify by FUN-AA0086---str--- 
    IF g_sma.sma142 = 'Y' THEN   #在途管理
       IF g_sma.sma143 = '1' THEN
          LET l_plant1 = g_ruo.ruo04
       ELSE
          LET l_plant1 = g_ruo.ruo05
       END IF
       SELECT imd01 INTO g_ruo.ruo14 FROM imd_file 
        WHERE imd10 = 'W' AND imd20 = l_plant1 AND imd22 = "Y"
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'art-965' #未維護默認倉資料
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                               DISPLAY BY NAME g_ruo.ruo14                           
       END CASE
    END IF
#   #No.FUN-9B0157 ..begin
#   #同一營運中心判斷該為同一法人
#   SELECT azw02 INTO l_azw02_1
#     FROM azw_file WHERE azw01 = g_ruo.ruo05
#   CASE WHEN SQLCA.SQLCODE = 100  
#                           LET g_errno = 100
#                           RETURN
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#   SELECT azw02 INTO l_azw02_2
#     FROM azw_file WHERE azw01 = g_ruo.ruo04
#   CASE WHEN SQLCA.SQLCODE = 100  
#                           LET g_errno = 100
#                           RETURN
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#  
#   #SELECT azp03 INTO l_azp03_2 FROM azp_file WHERE azp01 = g_ruo.ruo04
#   #IF l_azp03_1 IS NULL THEN LET l_azp03_1 = ' ' END IF
#   #IF l_azp03_2 IS NULL THEN LET l_azp03_2 = ' ' END IF
#   #出貨機構和需求機構必須為同一運營中心
#   #IF l_azp03_1 != l_azp03_2 THEN LET g_errno = 'art-291' END IF
#   IF l_azw02_1 != l_azw02_2 THEN LET g_errno = 'art-291' END IF
#   #No.FUN-9B0157 ..end
#modify by FUN-AA0086---end--- 
END FUNCTION
 
#modify by FUN-AA0086---str---
#FUNCTION t256_ruo06()
#DEFINE l_azp02     LIKE azp_file.azp02
# 
#   LET g_errno = " "
# 
#   SELECT azp02
#     INTO l_azp02
#     FROM azp_file WHERE azp01 = g_ruo.ruo06
# 
#   CASE WHEN SQLCA.SQLCODE = 100  
#                           LET g_errno = 'art-044'
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#                           DISPLAY l_azp02 TO FORMONLY.ruo06_desc
#   END CASE
#   
#END FUNCTION

#add by FUN-AA0086---str---
FUNCTION t256_chk_azw02()
   DEFINE l_azw02_1   LIKE azw_file.azw02
   DEFINE l_azw02_2   LIKE azw_file.azw02
   
   SELECT azw02 INTO l_azw02_1
     FROM azw_file WHERE azw01 = g_ruo.ruo05
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 100
                           RETURN
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   SELECT azw02 INTO l_azw02_2
     FROM azw_file WHERE azw01 = g_ruo.ruo04
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 100
                           RETURN
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF l_azw02_1 <> l_azw02_2 THEN
      LET g_ruo.ruo901 = "Y"
   ELSE
      LET g_ruo.ruo901 = "N"
   END IF
   DISPLAY BY NAME g_ruo.ruo901
   
END FUNCTION

FUNCTION t256_ruo03()
   DEFINE l_rvq      RECORD LIKE rvq_file.*
   DEFINE l_rvr      RECORD LIKE rvr_file.*
   DEFINE l_azw08    LIKE azw_file.azw08       #FUN-B40030 add   
   DEFINE l_ruo02    LIKE ruo_file.ruo02       #FUN-CA0086
   DEFINE l_ruo04    LIKE ruo_file.ruo04       #FUN-CA0086
   DEFINE l_ruo14    LIKE ruo_file.ruo14       #FUN-CA0086
   DEFINE l_ruoconf  LIKE ruo_file.ruoconf     #FUN-CA0086

   LET g_errno = " "  

  #FUN-CA0086 Begin---
   IF g_argv2 = '2' THEN
      SELECT ruo02,ruo04,ruo14,ruoconf INTO l_ruo02,l_ruo04,l_ruo14,l_ruoconf
        FROM ruo_file
       WHERE ruo01 = g_ruo.ruo03
         AND ruoplant = g_ruo.ruoplant
      CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'art-990'
           WHEN l_ruoconf <> '3'    LET g_errno = 'art-882'
           WHEN l_ruo02 = '4'       LET g_errno = 'art-883'
           WHEN l_ruo02 = '6'       LET g_errno = 'art-883'
           WHEN l_ruo02 = '7'       LET g_errno = 'art-883'
           OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF cl_null(g_errno) THEN
         LET g_ruo.ruo05 = l_ruo04
         SELECT azw08 INTO l_azw08
           FROM azw_file
          WHERE azw01 = g_ruo.ruo05
         LET g_ruo.ruo14 = l_ruo14
         DISPLAY BY NAME g_ruo.ruo05,g_ruo.ruo14
         DISPLAY l_azw08 TO FORMONLY.ruo05_desc
         CALL t256_chk_azw02()
        #IF g_sma.sma142 = "Y" THEN #調撥啟用在途管理
        #   CALL t256_ruo05()
        #END IF
         IF NOT cl_null(g_ruo.ruo03) THEN
            CALL cl_set_comp_entry("ruo05,ruo14",FALSE)
         ELSE
            CALL cl_set_comp_entry("ruo05,ruo14",TRUE)
         END IF
      END IF

      RETURN
   END IF
  #FUN-CA0086 End-----
 
   SELECT rvq01 FROM rvq_file 
    WHERE rvqconf = '2' AND rvqplant = g_plant
      AND rvq01 = g_ruo.ruo03 AND rvq00 = '1'
      AND rvqplant = rvq07   #TQC-AC0382
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-963'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                           
   END CASE
   IF cl_null(g_errno) THEN
      SELECT * INTO l_rvq.* FROM rvq_file
       WHERE rvq01 = g_ruo.ruo03 AND rvqplant = g_plant AND rvq00 = '1'
      LET g_ruo.ruo04 = l_rvq.rvq07    #TQC-AC0382
      LET g_ruo.ruo05 = l_rvq.rvq08
      LET g_ruo.ruo09 = l_rvq.rvq09
#FUN-B40030 ----------------STA
      SELECT azw08 INTO l_azw08
        FROM azw_file
       WHERE azw01 = g_ruo.ruo05 AND azwacti = 'Y'
#FUN-B40030 ----------------END
      DISPLAY BY NAME g_ruo.ruo04      #TQC-AC0382
      DISPLAY BY NAME g_ruo.ruo05
      DISPLAY l_azw08 TO FORMONLY.ruo05_desc     #FUN-B40030 add
      DISPLAY BY NAME g_ruo.ruo09 
      CALL t256_chk_azw02()
#FUN-AC0040--add--str--
      IF g_sma.sma142 = "Y" THEN #調撥啟用在途管理
         CALL t256_ruo05()
      END IF
#FUN-AC0040--add--end--
   END IF
   
END FUNCTION

FUNCTION t256_ruo03_1()
   DEFINE l_rvr      RECORD LIKE rvr_file.*
   DEFINE l_cnt      LIKE   type_file.num5
   DEFINE l_rup04    LIKE   rup_file.rup04 #庫存單位 
   DEFINE l_rup09    LIKE   rup_file.rup09
   DEFINE l_rup13    LIKE   rup_file.rup13
   DEFINE l_rup05    LIKE   rup_file.rup05 #TQC-B10152

   LET l_cnt = 1
   BEGIN WORK
   DECLARE cur_rvr1 CURSOR FOR SELECT rvr_file.* FROM rvr_file
                                WHERE rvr01 = g_ruo.ruo03
                                  AND rvrplant = g_plant       
                                  AND rvr00 = '1' 
   FOREACH cur_rvr1 INTO l_rvr.*
      LET l_rup04 = ''
      LET l_rup09 = ''
      LET l_rup13 = ''
      LET l_rup05 = ''
      SELECT ima25 INTO l_rup04 FROM ima_file WHERE ima01 = l_rvr.rvr04
     #SELECT rtz07 INTO l_rup09 FROM rtz_file WHERE rtz01 = g_ruo.ruo04     #FUN-C90049 mark
     #SELECT rtz07 INTO l_rup13 FROM rtz_file WHERE rtz01 = g_ruo.ruo05     #FUN-C90049 mark
      CALL s_get_coststore(g_ruo.ruo04,l_rvr.rvr04) RETURNING l_rup09                #FUN-C90049 add
      CALL s_get_coststore(g_ruo.ruo05,l_rvr.rvr04) RETURNING l_rup13                #FUN-C90049 add
      IF cl_null(l_rup09) THEN
         SELECT imd01 INTO l_rup09 FROM imd_file 
          WHERE imd10 = 'S' AND imd20 = g_ruo.ruo04  AND imd22 = "Y"   
      END IF
      IF cl_null(l_rup13) THEN
         SELECT imd01 INTO l_rup13 FROM imd_file
          WHERE imd10 = 'S' AND imd20 = g_ruo.ruo05  AND imd22 = "Y"
      END IF
#TQC-B10152--add--str--
      SELECT rty06 INTO l_rup05 FROM rty_file WHERE rty01= g_ruo.ruo04 AND rty02 = l_rvr.rvr04
      IF cl_null(l_rup05) THEN
         LET l_rup05 = '1'
      END IF
#TQC-B10152--add--end--
      INSERT INTO rup_file (rup01,rup02,rup03,rup04,rup05,rup06,rup07,rup08,rup09,rup10,rup11,rup12,rup13,
                            rup14,rup15,rup16,rup17,rup18,rup19,rup22,rupplant,ruplegal)                 #FUN-CC0057 add rup22
      VALUES(g_ruo.ruo01,l_cnt,l_rvr.rvr04,l_rup04,l_rup05,l_rvr.rvr05,l_rvr.rvr06,l_rvr.rvr07,l_rup09,'','',l_rvr.rvr09,
             l_rup13,'','',l_rvr.rvr09,l_rvr.rvr02,'N',l_rvr.rvr09,g_ruo.ruo05,g_plant,l_rvr.rvrlegal)   #FUN-CC0057 add g_ruo.ruo05,
      IF SQLCA.sqlcode THEN         
         CALL cl_err('ins rup_file',SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      END IF
      LET l_cnt = l_cnt + 1     
   END FOREACH
   #COMMIT WORK
   CALL t256_b_fill(" 1=1"," 1=1")   #FUN-AA0086    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
   CALL t256_bp_refresh()
END FUNCTION

#add by FUN-AA0086---end---

FUNCTION t256_ruo14()
   DEFINE l_imd20   LIKE imd_file.imd20
   DEFINE l_imd01   LIKE imd_file.imd01
    DEFINE l_cnt     LIKE type_file.num5   #TQC-BA0063 add   
   LET g_errno = " "
   
   IF g_sma.sma142 = "Y" AND g_sma.sma143 = '1' THEN #調撥在途歸屬撥出方
      LET l_imd20 = g_ruo.ruo04
   ELSE
      IF g_sma.sma142 = "Y" AND g_sma.sma143 = '2' THEN #調撥在途歸屬撥入方
         LET l_imd20 = g_ruo.ruo05
      END IF
   END IF
#TQC-BA0063 mark START   
#   SELECT imd01 INTO l_imd01 FROM imd_file 
#    WHERE imd10 = 'W' AND imd20 = l_imd20 AND imd22 = "Y"
# 
#   CASE WHEN SQLCA.SQLCODE = 100  
#                           LET g_errno = 'art-965' #未維護默認倉資料
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                           
#   END CASE
#TQC-BA0063 mark END

#TQC-BA0063 add START
   SELECT COUNT(*) INTO l_cnt FROM imd_file
     WHERE imd10 = 'W' AND imd20 = l_imd20 AND imd01 = g_ruo.ruo14
   IF l_cnt <= 0  THEN
      IF g_sma.sma143 = '1' THEN
         LET g_errno = 'art1007'
      ELSE
         LET g_errno = 'art1008'
      END IF
   END IF
#TQC-BA0063 add END

#FUN-BA0004 mark START
#   IF cl_null(g_errno) AND l_imd01 <> g_ruo.ruo14 THEN
#      LET g_errno = 'art-966'
#   END IF
#FUN-BA0004 mark END 
  
END FUNCTION
#modify by FUN-AA0086---end---
 
FUNCTION t256_ruo08()
DEFINE l_gen02     LIKE gen_file.gen02,
       l_genacti   LIKE gen_file.genacti
 
   LET g_errno = " "
 
   SELECT gen02,genacti
     INTO l_gen02,l_genacti
     FROM gen_file WHERE gen01 = g_ruo.ruo08
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-292'
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_gen02 TO FORMONLY.ruo08_desc
   END CASE
   
END FUNCTION
 
FUNCTION t256_rup03()
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_rtyacti     LIKE rty_file.rtyacti
DEFINE l_rtz04       LIKE rtz_file.rtz04
DEFINE l_rte07       LIKE rte_file.rte07
DEFINE l_rtaacti     LIKE rta_file.rtaacti
DEFINE l_rty06_1     LIKE rty_file.rty06
DEFINE l_rty06_2     LIKE rty_file.rty06
DEFINE l_flag          LIKE type_file.chr1,      #FUN-B90101 add
       l_fac           LIKE type_file.num20_6,   #FUN-B90101 add
       l_msg           LIKE type_file.chr1000    #FUN-B90101 add
    LET g_errno = ""
#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       IF NOT cl_null(g_rupslk[l_ac2].rupslk06) THEN 
           SELECT rta01,rta03,rtaacti INTO g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk07,l_rtaacti #FUN-AA0086
             FROM rta_file WHERE rta05 = g_rupslk[l_ac2].rupslk06
             
          CASE WHEN SQLCA.SQLCODE = 100  
                                  LET g_errno = 'art-298'
                                  RETURN
               WHEN l_rtaacti='N' LET g_errno = '9028'
                                  RETURN
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE          
       END IF
       #判斷產品編號是否存在于aimi100或arti120中
       IF NOT s_chk_item_no(g_rupslk[l_ac2].rupslk03,g_ruo.ruo04) THEN
          RETURN
       END IF
       IF NOT s_chk_item_no(g_rupslk[l_ac2].rupslk03,g_ruo.ruo05) THEN
          RETURN
       END IF 
   
       CALL t256_check_rup03(g_rupslk[l_ac2].rupslk03)
       IF NOT cl_null(g_errno) THEN
          RETURN
       END IF
       CALL t256_check_rup03_1(g_rupslk[l_ac2].rupslk03)
       IF NOT cl_null(g_errno) THEN
          RETURN
       END IF
       
       SELECT ima02,ima25,imaacti
           INTO g_rupslk[l_ac2].rupslk03_desc,g_rupslk[l_ac2].rupslk04,l_imaacti
           FROM ima_file WHERE ima01 = g_rupslk[l_ac2].rupslk03
    
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'art-037'
                               RETURN
            WHEN l_imaacti='N' LET g_errno = '9028'
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       
       SELECT gfe02,gfeacti INTO g_rupslk[l_ac2].rupslk04_desc,l_gfeacti 
          FROM gfe_file WHERE gfe01 = g_rupslk[l_ac2].rupslk04
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'mfg1200'
                               RETURN
            WHEN l_gfeacti='N' LET g_errno = 'art-293'
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE 
    
       DISPLAY g_rupslk[l_ac2].rupslk03_desc,g_rupslk[l_ac2].rupslk04,
               g_rupslk[l_ac2].rupslk04_desc,g_rupslk[l_ac2].rupslk05
    ELSE
#FUN-B90101--add--end--
       #由產品條碼帶出產品編號
       IF NOT cl_null(g_rup[l_ac].rup06) THEN 
    #      SELECT rta01,rtaacti INTO g_rup[l_ac].rup03,l_rtaacti
           SELECT rta01,rta03,rtaacti INTO g_rup[l_ac].rup03,g_rup[l_ac].rup07,l_rtaacti #FUN-AA0086
             FROM rta_file WHERE rta05 = g_rup[l_ac].rup06
             
          CASE WHEN SQLCA.SQLCODE = 100  
                                  LET g_errno = 'art-298'
                                  RETURN
               WHEN l_rtaacti='N' LET g_errno = '9028'
                                  RETURN
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE          
       END IF
   #FUN-AA0086--add--str--
       #判斷產品編號是否存在于aimi100或arti120中
       IF NOT s_chk_item_no(g_rup[l_ac].rup03,g_ruo.ruo04) THEN
          RETURN
       END IF
       IF NOT s_chk_item_no(g_rup[l_ac].rup03,g_ruo.ruo05) THEN
          RETURN
       END IF 
   
       CALL t256_check_rup03(g_rup[l_ac].rup03)
       IF NOT cl_null(g_errno) THEN
          RETURN
       END IF
       CALL t256_check_rup03_1(g_rup[l_ac].rup03)
       IF NOT cl_null(g_errno) THEN
          RETURN
       END IF
   #FUN-AA0086--add--end---
       
       SELECT ima02,ima25,imaacti
           INTO g_rup[l_ac].rup03_desc,g_rup[l_ac].rup04,l_imaacti
           FROM ima_file WHERE ima01 = g_rup[l_ac].rup03
    
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'art-037'
                               RETURN
            WHEN l_imaacti='N' LET g_errno = '9028'
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       
       SELECT gfe02,gfeacti INTO g_rup[l_ac].rup04_desc,l_gfeacti 
          FROM gfe_file WHERE gfe01 = g_rup[l_ac].rup04
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'mfg1200'
                               RETURN
            WHEN l_gfeacti='N' LET g_errno = 'art-293'
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE 
   #FUN-AA0086--mark--str--
   #    #查詢該商品在出貨機構中的經營方式
   #    SELECT rty06,rtyacti INTO l_rty06_1,l_rtyacti
   #       FROM rty_file WHERE rty01 = g_ruo.ruo04 
   #        AND rty02 = g_rup[l_ac].rup03
   #    CASE WHEN SQLCA.SQLCODE = 100  
   #                            LET g_errno = 'art-294'
   #                            RETURN
   #         WHEN l_rtyacti='N' LET g_errno = 'art-295'
   #                            RETURN
   #         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   #    END CASE
   #    #查詢該商品在需求機構中的經營方式
   #    LET l_rtyacti = ''
   #    SELECT rty06,rtyacti INTO l_rty06_2,l_rtyacti
   #       FROM rty_file WHERE rty01 = g_ruo.ruo05
   #        AND rty02 = g_rup[l_ac].rup03
   #    CASE WHEN SQLCA.SQLCODE = 100
   #                            LET g_errno = 'art-309'
   #                            RETURN
   #         WHEN l_rtyacti='N' LET g_errno = 'art-310'
   #                            RETURN
   #         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   #    END CASE
   #    IF l_rty06_1 IS NULL THEN LET l_rty06_1 = ' ' END IF
   #    IF l_rty06_2 IS NULL THEN LET l_rty06_2 = ' ' END IF
   #    #如果該商品在出貨機構和需求機構中的經營方式不相同，報錯
   #    IF l_rty06_1 <> l_rty06_2 THEN LET g_errno = 'art-311' RETURN END IF
   #    LET g_rup[l_ac].rup05 = l_rty06_1
   # 
   #    #如果當前機構是總部                                                                                                             
   #        
   #    SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_ruo.ruoplant
   #    SELECT rte07 INTO l_rte07 FROM rte_file,rtd_file 
   #       WHERE rtd01 = rte01 AND rtd01 = l_rtz04 AND rtdconf = 'Y'
   #         AND rte03 = g_rup[l_ac].rup03
   #        
   #    IF SQLCA.SQLCODE = 100 THEN
   #       LET g_errno = 'art-296'
   #       RETURN
   #    END IF
   #  
   #    IF l_rte07 = 'N' OR l_rte07 IS NULL THEN
   #       LET g_errno = 'art-297'
   #       RETURN
   #    END IF
   #FUN-AA0086--mark--end--
    
       DISPLAY g_rup[l_ac].rup03_desc,g_rup[l_ac].rup04,
               g_rup[l_ac].rup04_desc,g_rup[l_ac].rup05
   END IF   #No.FUN-B90101 add
END FUNCTION

#FUN-AA0086--add--str--
FUNCTION t256_check_rup03(l_rup03)
   DEFINE  l_rup03                     LIKE rup_file.rup03   #產品編號
   DEFINE  l_rtz05_1                   LIKE rtz_file.rtz05   #拨出营运中心價格策略
   DEFINE  l_rtz05_2                   LIKE rtz_file.rtz05   #拨入营运中心價格策略 　
   DEFINE  l_sql                       STRING
   DEFINE  l_cnt1,l_cnt2               LIKE type_file.num5
   DEFINE  l_aza88                     LIKE aza_file.aza88
   
   LET g_errno = "" 
   LET l_sql = " SELECT aza88 FROM ",cl_get_target_table(g_ruo.ruo05,'aza_file'),
               "  WHERE aza01 = '0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql            
   CALL cl_parse_qry_sql(l_sql, g_ruo.ruo05) RETURNING l_sql 
   PREPARE pre_aza  FROM l_sql
   EXECUTE pre_aza  INTO l_aza88
                
  IF g_aza.aza88 = "Y" THEN
     SELECT rtz05 INTO l_rtz05_1 FROM rtz_file  #獲取拨出营运中心價格策略代碼                                
      WHERE rtz01 = g_ruo.ruo04  
     IF NOT cl_null(l_rtz05_1) THEN 
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo.ruo04, 'rtg_file'),",",
                                            cl_get_target_table(g_ruo.ruo04, 'rtf_file'),
                    " WHERE rtg01=rtf01 AND rtfacti='Y' AND rtg09='Y' ",
                    "   AND rtg03= '",l_rup03,"'",
                    "   AND rtg01= '",l_rtz05_1,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
        CALL cl_parse_qry_sql(l_sql, g_ruo.ruo04) RETURNING l_sql
        PREPARE pre2 FROM l_sql
        EXECUTE pre2 INTO l_cnt1
        IF l_cnt1<=0 THEN
           LET g_errno = 'art-961' 
        END IF 
     END IF
   END IF
   IF l_aza88 = 'Y' THEN
      SELECT rtz05 INTO l_rtz05_2 FROM rtz_file  #獲取拨入营运中心價格策略代碼
       WHERE rtz01 = g_ruo.ruo05
      IF NOT cl_null(l_rtz05_2) THEN
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ruo.ruo05, 'rtg_file'),",",
                                            cl_get_target_table(g_ruo.ruo05, 'rtf_file'),
                    " WHERE rtg01=rtf01 AND rtfacti='Y' AND rtg09='Y' ",
                    "   AND rtg03= '",l_rup03,"'",
                    "   AND rtg01= '",l_rtz05_2,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
        CALL cl_parse_qry_sql(l_sql, g_ruo.ruo05) RETURNING l_sql
        PREPARE pre3 FROM l_sql
        EXECUTE pre3 INTO l_cnt2  
        IF l_cnt2<=0 THEN
           LET g_errno = 'art-962' 
        END IF   
     END IF
  END IF     
    
END FUNCTION

FUNCTION t256_check_rup03_1(l_rup03)    #經營方式
   DEFINE l_rup03       LIKE rup_file.rup03   #產品編號
   DEFINE l_rtyacti     LIKE rty_file.rtyacti
   DEFINE l_rty06_1     LIKE rty_file.rty06
   DEFINE l_rty06_2     LIKE rty_file.rty06
   DEFINE l_cnt         LIKE type_file.num5

   LET g_errno = ''
    #查詢該商品在撥出營運中心的經營方式
    SELECT rty06,rtyacti INTO l_rty06_1,l_rtyacti
       FROM rty_file WHERE rty01 = g_ruo.ruo04 
        AND rty02 = l_rup03
    IF l_rtyacti='N' THEN
       LET g_errno = 'art-992'  #FUN-AC0046
       RETURN
    END IF
    #查詢該商品在撥入營運中心的經營方式
    LET l_rtyacti = ''
    SELECT rty06,rtyacti INTO l_rty06_2,l_rtyacti
       FROM rty_file WHERE rty01 = g_ruo.ruo05
        AND rty02 = l_rup03
    IF l_rtyacti='N' THEN
       LET g_errno = 'art-993'  #FUN-AC0046
       RETURN
    END IF
    IF l_rty06_1 IS NULL THEN LET l_rty06_1 = '1' END IF
    IF l_rty06_2 IS NULL THEN LET l_rty06_2 = '1' END IF    
    
     SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = g_ruo.ruo04 AND azw02 IN
    (SELECT azw02 FROM  azw_file WHERE azw01 = g_ruo.ruo05)    
     IF l_cnt > 0 THEN
     #如果該商品在撥出營運中心和撥入營運中心的經營方式不相同，報錯
        IF l_rty06_1 <> l_rty06_2 THEN
            LET g_errno = 'art-311'
            RETURN
        END IF
     ELSE
        IF l_rty06_1 <> '1' OR l_rty06_2 <> '1' THEN
            LET g_errno = 'art-333'
            RETURN
        END IF        
     END IF   　　
#FUN-B90101--add--begin--
     IF s_industry("slk") THEN
        LET g_rupslk[l_ac2].rupslk05 = l_rty06_1
     ELSE
#FUN-B90101--add--end--
        LET g_rup[l_ac].rup05 = l_rty06_1
     END IF   #FUN-B90101 add
END FUNCTION
#FUN-AA0086--add--end--
 
FUNCTION t256_rup07()
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_smcacti     LIKE smc_file.smcacti
 
    LET g_errno = ""

#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       SELECT gfe02,gfeacti INTO g_rupslk[l_ac2].rupslk07_desc ,l_gfeacti
          FROM gfe_file
        WHERE gfe01 = g_rupslk[l_ac2].rupslk07    
    ELSE
#FUN-B90101--add--end--
       SELECT gfe02,gfeacti INTO g_rup[l_ac].rup07_desc ,l_gfeacti 
          FROM gfe_file
        WHERE gfe01 = g_rup[l_ac].rup07  
    END IF       #FUN-B90101 add
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'afa-319'
                            RETURN
         WHEN l_gfeacti='N' LET g_errno = 'art-061'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
#    SELECT smcacti INTO l_smcacti FROM smc_file 
#       WHERE smc01 = g_rup[l_ac].rup07
#    CASE WHEN SQLCA.SQLCODE = 100  
#                            LET g_errno = 'art-301'
#                            RETURN
#         WHEN l_smcacti='N' LET g_errno = 'art-302'
#                            RETURN
#         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
END FUNCTION
 
FUNCTION t256_rup09()
DEFINE l_imd20      LIKE imd_file.imd20
DEFINE l_imdacti    LIKE imd_file.imdacti
#FUN-C20002--start add-----------------------
DEFINE l_ima154     LIKE ima_file.ima154
DEFINE l_rcj03      LIKE rcj_file.rcj03
DEFINE l_rtz07      LIKE rtz_file.rtz07
DEFINE l_rtz08      LIKE rtz_file.rtz08
#FUN-C20002--end add-------------------------    

    LET g_errno = ""
   #FUN-C20002--start add---------------------------------------------
   IF g_azw.azw04 = '2' THEN
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = g_rup[l_ac].rup03
      IF l_ima154 = 'Y' AND g_rup[l_ac].rup03[1,4] <> 'MISC' THEN
         SELECT rcj03 INTO l_rcj03
           FROM rcj_file
          WHERE rcj00 = '0'
         #FUN-C90049 mark begin---
         #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
         #  FROM rtz_file
         # WHERE rtz01 = g_plant 
         #FUN-C90049 mark end-----
         CALL s_get_defstore(g_plant,g_rup[l_ac].rup03) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add

         IF l_rcj03 = '1' THEN
            IF g_rup[l_ac].rup09 <> l_rtz07 THEN
               LET g_errno = 'aim1142'
               RETURN
            END IF
         ELSE
            IF g_rup[l_ac].rup09 <> l_rtz08 THEN
               LET g_errno = 'aim1143'
               RETURN
            END IF
         END IF
      END IF
   END IF
   #FUN-C20002--end add----------------------------------------------- 
   #TQC-C20413--mark--
   #FUN-B90101--add--begin--
   #IF s_industry("slk") THEN
   #   SELECT imd02,imd20,imdacti
   #      INTO g_rup[l_ac].rup09_desc,l_imd20,l_imdacti
   #      FROM imd_file WHERE imd01 = g_rup[l_ac].rup09
   #ELSE
   #FUN-B90101--add--end--
   #TQC-C20413--mark--
   #FUN-C80095 mark begin ---
   #   SELECT imd02,imd20,imdacti 
   #      INTO g_rup[l_ac].rup09_desc,l_imd20,l_imdacti
   #      FROM imd_file WHERE imd01 = g_rup[l_ac].rup09
   #FUN-C80095 mark end ---
   #FUN-C80095 add begin ---
    LET g_sql = "SELECT imd02,imd20,imdacti FROM ",cl_get_target_table(g_ruo.ruo04,'imd_file'),
                " WHERE imd01 = '",g_rup[l_ac].rup09,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
    PREPARE t256_sel_imd02 FROM g_sql
    EXECUTE t256_sel_imd02 INTO g_rup[l_ac].rup09_desc,l_imd20,l_imdacti
   #FUN-C80095 add end ---
   #END IF   #TQC-C20413
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'mfg0094'
                            RETURN
         WHEN l_imdacti='N' LET g_errno = 'art-303'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
    
    IF l_imd20 <> g_ruo.ruo04 THEN
       LET g_errno = 'art-304'
       RETURN
    END IF
END FUNCTION
#檢查撥出倉庫、料件的數量是否大于撥出數量
FUNCTION t256_check_img10()
DEFINE l_img10     LIKE img_file.img10
DEFINE l_ima151    LIKE ima_file.ima151
 
    LET g_errno = ''
    LET g_check_img = ' '  #TQC-C20039 add 
#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       IF g_rec_b2 = 0  AND cl_null(g_cmd) THEN 
          RETURN
       END IF
       IF cl_null(g_rupslk[l_ac2].rupslk03) OR cl_null(g_rupslk[l_ac2].rupslk09)
          OR cl_null(g_rupslk[l_ac2].rupslk12) THEN
          RETURN
       END IF
       IF cl_null(g_rupslk[l_ac2].rupslk10) THEN
          LET g_rupslk[l_ac2].rupslk10 = ' '
       END IF
       IF cl_null(g_rupslk[l_ac2].rupslk11) THEN
          LET g_rupslk[l_ac2].rupslk11 = ' '
       END IF
       SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_rupslk[l_ac2].rupslk03
       IF l_ima151 = 'N' THEN
          SELECT img10 INTO l_img10 FROM img_file
               WHERE img01 = g_rupslk[l_ac2].rupslk03
                 AND img02 = g_rupslk[l_ac2].rupslk09
                 AND img03 = g_rupslk[l_ac2].rupslk10
                 AND img04 = g_rupslk[l_ac2].rupslk11
          IF l_img10 IS NULL THEN LET l_img10 = 0 END IF

          IF l_img10 < g_rupslk[l_ac2].rupslk12 THEN
       #FUN-D30024 --------Begin----------
          #  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
          #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024 
          #  IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
             INITIALIZE g_imd23 TO NULL 
             CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024  #TQC-D40078 g_ruo.ruo04
             IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
       #FUN-D30024 --------End------------
            #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN                                #FUN-C80107 mark
                  LET g_check_img = 'N'  
                  CALL cl_err(l_img10,'mfg3471',0)
               ELSE
                  IF NOT cl_confirm('mfg3469') THEN
                    LET g_errno = 'art-475'
                  END IF
               END IF
          END IF
       END IF
    ELSE
#FUN-B90101--add--end--
   #TQC-B90001 add START
       IF g_rec_b = 0  AND cl_null(g_cmd) THEN    #FUN-B90068 add cl_null(g_cmd)
          RETURN
       END IF
   #TQC-B90001 add END
       IF cl_null(g_rup[l_ac].rup03) OR cl_null(g_rup[l_ac].rup09)
          OR cl_null(g_rup[l_ac].rup12) THEN
          RETURN
       END IF
   #MOD-A80096 --begin--
       IF cl_null(g_rup[l_ac].rup10) THEN
          LET g_rup[l_ac].rup10 = ' ' 
       END IF 
       IF cl_null(g_rup[l_ac].rup11) THEN
          LET g_rup[l_ac].rup11 = ' ' 
       END IF     
   #MOD-A80096 --end-- 
       SELECT img10 INTO l_img10 FROM img_file
            WHERE img01 = g_rup[l_ac].rup03
              AND img02 = g_rup[l_ac].rup09
   #MOD-A80096 --modify --begin--
   #          AND img03 = ' '
   #          AND img04 = ' '
              AND img03 = g_rup[l_ac].rup10
              AND img04 = g_rup[l_ac].rup11
   #MOD-A80096 --mofiy --end--
       IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
    
       IF l_img10 < g_rup[l_ac].rup12 THEN
   #       LET g_errno = 'art-475'
   #FUN-B80075 add START
         #TQC-C20039 mark
         #IF g_act = 'out_yes'THEN
         #   LET g_errno = 'art-475'
         #   RETURN
         #END IF
         #TQC-C20039 mark
           #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN       #FUN-C80107 mark
      #FUN-D30024 -------Begin---------
         #  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
         #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
         #  IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
            INITIALIZE g_imd23 TO NULL
            CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                         #FUN-D30024  #TQC-D40078 g_ruo.ruo04
            IF g_imd23 = 'N' THEN
      #FUN-D30024 -------End-----------
               LET g_check_img = 'N'   #TQC-C20039 add
               CALL cl_err(l_img10,'mfg3471',0)
            ELSE
               IF NOT cl_confirm('mfg3469') THEN
                 LET g_errno = 'art-475'  
               END IF
            END IF
   #FUN-B80075 add END      
       END IF
   END IF  #FUN-B90101 add
END FUNCTION
#檢查撥入倉庫是否合法
#經營方式   1.經銷---------->成本倉庫
#           2.成本代銷------>非成本庫
#           3.扣率代銷------>非成本庫
#           4.聯營---------->非成本庫        
FUNCTION t256_check_in_store()
DEFINE l_n        LIKE type_file.num5
 
    LET g_errno = ''

#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       IF cl_null(g_rupslk[l_ac2].rupslk13) OR cl_null(g_rupslk[l_ac2].rupslk05) THEN
          RETURN
       END IF
       SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_rupslk[l_ac2].rupslk13
       IF l_n != 0 THEN             #倉庫為非成本倉庫，經營方式不能是：1.經銷
          IF g_rupslk[l_ac2].rupslk05 = '1' THEN
             LET g_errno = 'art-474'
             RETURN
          END IF
       ELSE                        #倉庫為成本倉庫，經營方式必須為經銷
          IF g_rupslk[l_ac2].rupslk05 != '1' THEN
             LET g_errno = 'art-473'
             RETURN
          END IF
       END IF
    ELSE
#FUN-B90101--add--end--
       IF cl_null(g_rup[l_ac].rup13) OR cl_null(g_rup[l_ac].rup05) THEN
          RETURN
       END IF
       SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_rup[l_ac].rup13
       IF l_n != 0 THEN             #倉庫為非成本倉庫，經營方式不能是：1.經銷
          IF g_rup[l_ac].rup05 = '1' THEN
             LET g_errno = 'art-474'
             RETURN
          END IF
       ELSE                        #倉庫為成本倉庫，經營方式必須為經銷
          IF g_rup[l_ac].rup05 != '1' THEN   
             LET g_errno = 'art-473'
             RETURN
          END IF
       END IF
    END IF   #FUN-B90101 add
END FUNCTION
#檢查撥出倉庫是否合法
#經營方式   1.經銷---------->成本倉庫
#           2.成本代銷------>非成本庫
#           3.扣率代銷------>非成本庫
#           4.聯營---------->非成本庫        
FUNCTION t256_check_out_store( )
DEFINE l_n        LIKE type_file.num5
 
    LET g_errno = ''

#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       IF cl_null(g_rupslk[l_ac2].rupslk09) OR cl_null(g_rupslk[l_ac2].rupslk05) THEN
          RETURN
       END IF 
 
       SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_rupslk[l_ac2].rupslk09
       IF l_n != 0 THEN             #倉庫為非成本倉庫，經營方式不能是：1.經銷 
          IF g_rupslk[l_ac2].rupslk05 = '1' THEN
             LET g_errno = 'art-474'
             RETURN
          END IF 
       ELSE                        #倉庫為成本倉庫，經營方式必須為經銷 
          IF g_rupslk[l_ac2].rupslk05 != '1' THEN   
             LET g_errno = 'art-473'
             RETURN
          END IF 
       END IF     
    ELSE
#FUN-B90101--add--end--
       IF cl_null(g_rup[l_ac].rup09) OR cl_null(g_rup[l_ac].rup05) THEN
          RETURN
       END IF
 
       SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_rup[l_ac].rup09
       IF l_n != 0 THEN             #倉庫為非成本倉庫，經營方式不能是：1.經銷
          IF g_rup[l_ac].rup05 = '1' THEN
             LET g_errno = 'art-474'
             RETURN
          END IF
       ELSE                        #倉庫為成本倉庫，經營方式必須為經銷
          IF g_rup[l_ac].rup05 != '1' THEN   
             LET g_errno = 'art-473'
             RETURN
          END IF
       END IF
    END IF      #No.FUN-B90101 add
END FUNCTION
 
FUNCTION t256_add_store(l_img01,l_img02,l_plant,l_img03,l_img04)  #MOD-A80112 add l_img03,l_img04
DEFINE l_img01 LIKE img_file.img01
DEFINE l_img02 LIKE img_file.img02
DEFINE l_img03 LIKE img_file.img03       #MOD-A80112
DEFINE l_img04 LIKE img_file.img04       #MOD-A80112
DEFINE l_sql   STRING
DEFINE l_plant LIKE azp_file.azp01 #仓库归属机构
DEFINE l_dbs   LIKE azp_file.azp03
 
     IF cl_null(l_img01) OR cl_null(l_img02) 
      OR cl_null(l_img03) OR cl_null(l_img04)   #MOD-A80112
     THEN
        RETURN
     END IF
     #No.FUN-9B0157 ..begin
     #LET g_plant_new = l_plant  #FUN-A50102
     #CALL s_gettrandbs()        #FUN-A50102   
     #LET l_dbs=g_dbs_tra        #FUN-A50102
     #檢查料倉儲批是否存在，不存在就增加            
     LET g_cnt = 0  
     #LET l_sql = " SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"img_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'img_file'), #FUN-A50102
                 " WHERE img01 = '",l_img01,"'  AND img02 = '",l_img02,"' ",
#                "   AND img03 = ' ' AND img04 = ' ' "   #MOD-A80112 
                 "   AND img03 = '",l_img03,"'",         #MOD-A80112
                 "   AND img04 = '",l_img04,"'"          #MOD-A80112
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	 CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102        
         PREPARE sel_img_cs FROM l_sql
         EXECUTE sel_img_cs INTO g_cnt
     #No.FUN-9B0157 ..end
      IF g_cnt = 0 OR g_cnt IS NULL THEN
         IF g_sma.sma892[3,3] ='Y' THEN
            IF NOT cl_confirm('mfg1401') THEN LET g_errno = 'SKIP' END IF 
         END IF
         #No.FUN-9C0088 ...begin
         #CALL s_add_img(l_img01,l_img02,' ',' ',
         #               g_ruo.ruo01,g_rup[l_ac].rup02,g_today)
#         CALL s_madd_img(l_img01,l_img02,' ',' ',           #MOD-A80112
#FUN-B91010--add--begin--
          IF s_industry("slk") THEN
              CALL s_madd_img(l_img01,l_img02,l_img03,l_img04, 
                              g_ruo.ruo01,g_rupslk[l_ac2].rupslk02,g_today,l_plant)
          ELSE
#FUN-B91010--add--end--
             CALL s_madd_img(l_img01,l_img02,l_img03,l_img04,   #MOD-A80112
                             g_ruo.ruo01,g_rup[l_ac].rup02,g_today,l_plant)
          END IF        #FUN-B91010 add
         #No.FUN-9C0088 ...end
     END IF
END FUNCTION
 
FUNCTION t256_rup13()
DEFINE l_imd20      LIKE imd_file.imd20
DEFINE l_imdacti    LIKE imd_file.imdacti
#FUN-C20002--start add-----------------------
DEFINE l_ima154     LIKE ima_file.ima154
DEFINE l_rcj03      LIKE rcj_file.rcj03
DEFINE l_rtz07      LIKE rtz_file.rtz07
DEFINE l_rtz08      LIKE rtz_file.rtz08
#FUN-C20002--end add-------------------------    

    LET g_errno = ""
   #FUN-C20002--start add---------------------------------------------
   IF g_azw.azw04 = '2' THEN
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = g_rup[l_ac].rup03
      IF l_ima154 = 'Y' AND g_rup[l_ac].rup03[1,4] <> 'MISC' THEN
         SELECT rcj03 INTO l_rcj03
           FROM rcj_file
          WHERE rcj00 = '0'
         #FUN-C90049 mark beign---
         #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
         #  FROM rtz_file
         # WHERE rtz01 = g_ruo.ruo05
         #FUN-C90049 mark end-----
         CALL s_get_defstore(g_ruo.ruo05,g_rup[l_ac].rup03) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add

         IF l_rcj03 = '1' THEN
            IF g_rup[l_ac].rup13 <> l_rtz07 THEN
               LET g_errno = 'aim1142'
               RETURN
            END IF
         ELSE
            IF g_rup[l_ac].rup13 <> l_rtz08 THEN
               LET g_errno = 'aim1143'
               RETURN
            END IF
         END IF
      END IF
   END IF
   #FUN-C20002--end add-----------------------------------------------  
 
#FUN-B91010--add--begin--
    IF s_industry("slk") THEN 
      #FUN-C80095 mark begin ---
      #SELECT imd02,imd20,imdacti
      #   INTO g_rupslk[l_ac2].rupslk13_desc,l_imd20,l_imdacti
      #   FROM imd_file WHERE imd01 = g_rupslk[l_ac2].rupslk13
      #FUN-C80095 mark end -----
      #FUN-C80095 add begin ---
       LET g_sql = "SELECT imd02,imd20,imdacti FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
                   " WHERE imd01 = '",g_rupslk[l_ac2].rupslk13,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
       PREPARE t256_sel_imd02_slk FROM g_sql
       EXECUTE t256_sel_imd02_slk INTO g_rupslk[l_ac2].rupslk13_desc,l_imd20,l_imdacti
      #FUN-C80095 add end ---
    ELSE
#FUN-B91010--add--begin--
      #FUN-C80095 mark begin ---
      #SELECT imd02,imd20,imdacti 
      #   INTO g_rup[l_ac].rup13_desc,l_imd20,l_imdacti
      #   FROM imd_file WHERE imd01 = g_rup[l_ac].rup13
      #FUN-C80095 mark end -----
      #FUN-C80095 add begin ---
       LET g_sql = "SELECT imd02,imd20,imdacti FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
                   " WHERE imd01 = '",g_rup[l_ac].rup13,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
       PREPARE t256_sel_imd02_1 FROM g_sql
       EXECUTE t256_sel_imd02_1 INTO g_rup[l_ac].rup13_desc,l_imd20,l_imdacti
      #FUN-C80095 add end ---
    END IF       #FUN-B91010 add
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'mfg0094'
                            RETURN
         WHEN l_imdacti='N' LET g_errno = 'art-303'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
    
    IF l_imd20 <> g_ruo.ruo05 THEN
       LET g_errno = 'art-306'
       RETURN
    END IF 
END FUNCTION
 
FUNCTION t256_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rup.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t256_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ruo.* TO NULL
      RETURN
   END IF
 
   OPEN t256_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ruo.* TO NULL
   ELSE
      OPEN t256_count
      FETCH t256_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t256_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t256_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t256_cs INTO g_ruo.ruo01,g_ruo.ruoplant
      WHEN 'P' FETCH PREVIOUS t256_cs INTO g_ruo.ruo01,g_ruo.ruoplant
      WHEN 'F' FETCH FIRST    t256_cs INTO g_ruo.ruo01,g_ruo.ruoplant
      WHEN 'L' FETCH LAST     t256_cs INTO g_ruo.ruo01,g_ruo.ruoplant
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
        FETCH ABSOLUTE g_jump t256_cs INTO g_ruo.ruo01,g_ruo.ruoplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
      INITIALIZE g_ruo.* TO NULL
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
 
   SELECT * INTO g_ruo.* FROM ruo_file WHERE ruo01 = g_ruo.ruo01
      AND ruoplant = g_ruo.ruoplant 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruo_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ruo.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_ruo.ruouser
   LET g_data_group = g_ruo.ruogrup
   LET g_data_plant = g_ruo.ruoplant  #TQC-A10128 ADD 

   CALL t256_show()
 
END FUNCTION
 
FUNCTION t256_show()
DEFINE  l_gen02  LIKE gen_file.gen02
#DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE  l_azw08  LIKE azw_file.azw08   #FUN-AA0086
 
   LET g_ruo_t.* = g_ruo.*
   LET g_ruo_o.* = g_ruo.*
   #DISPLAY BY NAME g_ruo.ruo01,g_ruo.ruo02,g_ruo.ruo03, g_ruo.ruooriu,g_ruo.ruoorig,
   DISPLAY BY NAME g_ruo.ruo01,g_ruo.ruo011,g_ruo.ruo02,g_ruo.ruo03, g_ruo.ruooriu,
                   g_ruo.ruoorig,#TQC-AC0382 add ruo011
                 #  g_ruo.ruo04,g_ruo.ruo05,g_ruo.ruo06,
                   g_ruo.ruo04,g_ruo.ruo05, #FUN-AA0086 drop ruo06
                   g_ruo.ruo07,g_ruo.ruo08,g_ruo.ruo10,
                   g_ruo.ruo11,g_ruo.ruo12,g_ruo.ruo13,
                   g_ruo.ruoconf,g_ruo.ruoplant,g_ruo.ruo09,
                   #g_ruo.ruouser,g_ruo.ruo10t,g_ruo.ruopos,g_ruo.ruo12t, 
                   g_ruo.ruouser,g_ruo.ruo10t,g_ruo.ruo12t, #TQC-AC0382
                 #  g_ruo.ruomodu,g_ruo.ruoacti,g_ruo.ruogrup,
                   g_ruo.ruomodu,g_ruo.ruogrup,             #FUN-B30025
                   g_ruo.ruodate,g_ruo.ruocrat
                   ,g_ruo.ruo14,g_ruo.ruo15,g_ruo.ruo99,g_ruo.ruo901 #FUN-AA0086 add
   
#modify by FUN-AA0086---str---- 
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo04
#   DISPLAY l_azp02 TO ruo04_desc
#   
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo05
#   DISPLAY l_azp02 TO ruo05_desc
#
#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruo06
#   DISPLAY l_azp02 TO ruo06_desc 

#   LET l_azp02 = NULL                
#   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruo.ruoplant
#   DISPLAY l_azp02 TO ruoplant_desc 

   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruo04
   DISPLAY l_azw08 TO ruo04_desc
   
   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruo05
   DISPLAY l_azw08 TO ruo05_desc
   
   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_ruo.ruoplant
   DISPLAY l_azw08 TO ruoplant_desc 
#modify by FUN-AA0086---end----
   
   LET l_gen02 = NULL 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo08
   DISPLAY l_gen02 TO ruo08_desc
   
   LET l_gen02 = NULL 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo11
   DISPLAY l_gen02 TO ruo11_desc
   
   LET l_gen02 = NULL 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruo.ruo13
   DISPLAY l_gen02 TO ruo13_desc    

   CALL cl_set_act_visible("triangletrade",g_ruo.ruo901='Y')  #FUN-AA0086
 # CALL t256_b_fill(g_wc2)   #FUN-B90101 

  #TQC-C90058 add begin ---
  IF cl_null(g_ruo.ruo03) THEN
     CALL cl_set_comp_visible("rup17",FALSE)
  ELSE
     CALL cl_set_comp_visible("rup17",TRUE)
  END IF
  #TQC-C90058 add end -----
 #FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      CALL t256_b_fill2(g_wc3,g_wc2)
      CALL t256_b_fill(g_wc2,g_wc3)
   ELSE
      CALL t256_b_fill(g_wc2,' 1=1')     #FUN-AA0086    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件 
   END IF 
 #FUN-B90101--add--end--
   CALL cl_show_fld_cont()
END FUNCTION
 
#FUN-B30025--mark--str--
#FUNCTION t256_x()
# 
#   IF s_shut(0) THEN
#      RETURN
#   END IF
# 
#   IF g_ruo.ruo01 IS NULL AND g_ruo.ruoplant IS NULL THEN
#      CALL cl_err("",-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_ruo.* FROM ruo_file
#    WHERE ruo01=g_ruo.ruo01 
#      AND ruoplant = g_ruo.ruoplant 
#    
#   IF g_ruo.ruoconf = '1' OR g_ruo.ruoconf = '2' THEN 
#      CALL cl_err('',9023,0) 
#      RETURN 
#   END IF
#   #IF g_ruo.ruoconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF  #FUN-AA0086
##add--FUN-AA0086--str--
#   IF g_ruo.ruoconf = '3' THEN   
#      CALL cl_err('','amr-100',0)
#      RETURN
#   END IF
##add--FUN-AA0086--end--
#   BEGIN WORK 
#   OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
#   IF STATUS THEN
#      CALL cl_err("OPEN t256_cl:", STATUS, 1)
#      CLOSE t256_cl
#      RETURN
#   END IF
# 
#   FETCH t256_cl INTO g_ruo.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
#      RETURN
#   END IF
# 
#   LET g_success = 'Y'
# 
#   CALL t256_show()
#   
#   IF cl_exp(0,0,g_ruo.ruoacti) THEN
#      LET g_chr=g_ruo.ruoacti
#      IF g_ruo.ruoacti='Y' THEN
#         LET g_ruo.ruoacti='N'
#      ELSE
#         LET g_ruo.ruoacti='Y'
#      END IF
# 
#      UPDATE ruo_file SET ruoacti=g_ruo.ruoacti,
#                          ruomodu=g_user,
#                          ruodate=g_today
#       WHERE ruo01=g_ruo.ruo01
#         AND ruoplant = g_ruo.ruoplant 
#      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err3("upd","ruo_file",g_ruo.ruo01,"",SQLCA.sqlcode,"","",1) 
#         LET g_ruo.ruoacti=g_chr
#         LET g_success = 'N'
#      END IF
#   END IF
# 
#   CLOSE t256_cl
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL cl_flow_notify(g_ruo.ruo01,'V')
#   ELSE
#      ROLLBACK WORK
#   END IF
# 
#   SELECT ruoacti,ruomodu,ruodate
#     INTO g_ruo.ruoacti,g_ruo.ruomodu,g_ruo.ruodate FROM ruo_file
#    WHERE ruo01=g_ruo.ruo01 
#      AND ruoplant = g_ruo.ruoplant 
#   DISPLAY BY NAME g_ruo.ruoacti,g_ruo.ruomodu,g_ruo.ruodate
# 
#END FUNCTION
#FUN-B30025--mark--end--
 
FUNCTION t256_r()
   DEFINE l_flag   LIKE type_file.num5 #TQC-B20179
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruo.ruo01 IS NULL OR g_ruo.ruoplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
  #FUN-A30030 ADD------------------------------------
  # IF g_aza.aza88='Y' THEN
  #    IF NOT (g_ruo.ruoacti='N' AND g_ruo.ruopos='Y') THEN
  #       CALL cl_err('', 'art-648', 1)
  #       RETURN
  #    END IF
  # END IF
  #FUN-A30030 END-----------------------------------
 
   SELECT * INTO g_ruo.* FROM ruo_file
    WHERE ruo01=g_ruo.ruo01 
      AND ruoplant = g_ruo.ruoplant 
 
   IF g_ruo.ruoconf = '1' OR g_ruo.ruoconf = '2' THEN
      CALL cl_err('','art-023',0)
      RETURN
   END IF

#add--FUN-AA0086--str--
   IF g_ruo.ruoconf = '3' THEN   
      CALL cl_err('','atm-905',0)
      RETURN
   END IF
  #IF g_ruo.ruo02 <>'1' AND g_ruo.ruo02 <>'5' THEN                        #FUN-CA0086
   IF g_ruo.ruo02 <>'1' AND g_ruo.ruo02 <>'5' AND g_ruo.ruo02 <> '7' THEN #FUN-CA0086
      CALL cl_err('','art-988',0)
      RETURN
   END IF
#add--FUN-AA0086--end--
   
#mark FUN-AA0086---str---   
#add FUN-B30025 ---str---
   IF g_ruo.ruoconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
#add FUN-B30025 ---end---
#mark FUN-AA0086---end---   
 
#   IF g_ruo.ruoacti = 'N' THEN
#      CALL cl_err('','aic-201',0)
#      RETURN
#   END IF
 
   BEGIN WORK
 
   OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
   IF STATUS THEN
      CALL cl_err("OPEN t256_cl:", STATUS, 1)
      ROLLBACK WORK
      CLOSE t256_cl
      RETURN
   END IF
 
   FETCH t256_cl INTO g_ruo.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t256_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruo01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruo.ruo01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM ruo_file WHERE ruo01 = g_ruo.ruo01
         AND ruoplant = g_ruo.ruoplant 
      DELETE FROM rup_file WHERE rup01 = g_ruo.ruo01 
         AND rupplant = g_ruo.ruoplant 
#FUN-B90101--add--begin--
      IF s_industry("slk") THEN
          DELETE FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01 AND rupslkplant = g_ruo.ruoplant  
      END IF
#FUN-B90101--add--end--
      #TQC-B20179---add--str--
      #調撥單來源為調撥申請單時,更新申請單的審核碼
      IF g_ruo.ruo02 = '5' THEN
         CALL t256_upd_rvq('2') RETURNING l_flag
         IF (NOT l_flag) THEN
            ROLLBACK WORK
            CALL cl_err(g_ruo.ruo01,'art-855',1)
            CLOSE t256_cl
            RETURN
         END IF
      END IF
      #TQC-B20179---add--end--
      CLEAR FORM
      CALL g_rup.clear()
#FUN-B90101--add--begin--
      IF s_industry("slk") THEN
         CALL g_rupslk.clear()
         CALL g_imx.clear()
      END IF
#FUN-B90101--add--end--

      OPEN t256_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t256_cs
         CLOSE t256_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t256_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t256_cs
         CLOSE t256_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t256_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t256_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t256_fetch('/')
      END IF
   END IF
 
   CLOSE t256_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruo.ruo01,'D')
END FUNCTION
 
FUNCTION t256_get_desc()
   SELECT ima02 INTO g_rup[l_ac].rup03_desc
      FROM ima_file WHERE ima01 = g_rup[l_ac].rup03
 
   SELECT gfe02 INTO g_rup[l_ac].rup04_desc FROM gfe_file
      WHERE gfe01 = g_rup[l_ac].rup04
   
   SELECT gfe02 INTO g_rup[l_ac].rup07_desc FROM gfe_file
       WHERE gfe01 = g_rup[l_ac].rup07
 
#FUN-C80095 mark begin ---
#  SELECT imd02 INTO g_rup[l_ac].rup09_desc FROM imd_file
#     WHERE imd01 = g_rup[l_ac].rup09
#  
#  SELECT imd02 INTO g_rup[l_ac].rup13_desc FROM imd_file 
#     WHERE imd01 = g_rup[l_ac].rup13
#FUN-C80095 mark end ----
#FUN-C80095 add begin ---
   CALL t256_sel_imd02_rup09()
   CALL t256_sel_imd02_rup13()
#FUN-C80095 add end ----
END FUNCTION
 
FUNCTION t256_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30, 
    l_flag          LIKE type_file.chr1,
    l_fac           LIKE type_file.num20_6,
    l_msg           LIKE type_file.chr1000,
    l_rtz04         LIKE rtz_file.rtz04,
    l_azp03         LIKE azp_file.azp03,
    sn1             LIKE type_file.num5,
    sn2             LIKE type_file.num5
DEFINE l_flag1      LIKE type_file.num5 #TQC-B20179
DEFINE l_warehouse  LIKE type_file.chr1        #FUN-B80075 add
DEFINE p_cmd2       LIKE type_file.chr1        #FUN-B80075 add
DEFINE l_ima151     LIKE type_file.chr1        #FUN-B90068 add
DEFINE l_flag_rup09 LIKE type_file.num5        #FUN-BA0004 add
DEFINE l_flag_rup13 LIKE type_file.num5        #FUN-BA0004 add
DEFINE l_flag_ruo14 LIKE type_file.num5        #FUN-BA0004 add
#FUN-B90101--add--begin--
DEFINE l_ac2_t      LIKE type_file.num5,
       p_cmd3       LIKE type_file.chr1,
       l_imaag      LIKE ima_file.imaag,
       l_sum        LIKE type_file.num5,
       l_sum1       LIKE type_file.num5, 
       l_sum_rup16  LIKE rup_file.rup16
DEFINE l_error      LIKE type_file.chr10       #TQC-C20348 add
DEFINE l_ima01      LIKE ima_file.ima01        #TQC-C20348 add
#FUN-B90101--add--end--
DEFINE l_case  STRING     #FUN-910088--add--
   
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ruo.ruo01 IS NULL OR g_ruo.ruoplant IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ruo.* FROM ruo_file
      WHERE ruo01=g_ruo.ruo01 
        AND ruoplant = g_ruo.ruoplant 
 
#FUN-B30025--mark--str--
#    IF g_ruo.ruoacti ='N' THEN
#       CALL cl_err(g_ruo.ruo01,'mfg1000',0)
#       RETURN
#    END IF
#FUN-B30025--mark--end--
  
    IF g_ruo.ruoconf = '2' THEN
       CALL cl_err('','mfg6071',0)
       RETURN
    END IF

#add--FUN-AA0086--str--
   IF g_ruo.ruoconf = '3' THEN   
      CALL cl_err('','amr-100',0)
      RETURN
   END IF
   IF g_ruo.ruoconf = '1' AND g_ruo.ruo05 <> g_plant THEN
      CALL cl_err('','art-989',0)
      RETURN
   END IF
#add--FUN-AA0086--end--

  #FUN-CA0086 Begin---
   IF g_ruo.ruoconf = '1' AND g_ruo.ruo02 = '7' THEN
      RETURN
   END IF
  #FUN-CA0086 End---

#mark FUN-AA0086---str---  
#FUN-B30025--add--str--
    IF g_ruo.ruoconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
#FUN-B30025--add--end--
#mark FUN-AA0086---end--- 

    #查詢當前機構是否是總部
    #No.FUN-9B0157 ..begin
    #SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = g_ruo.ruoplant                                                 
    LET g_plant_new = g_ruo.ruoplant
    CALL s_gettrandbs()
    LET l_azp03=g_dbs_tra
    #No.FUN-9B0157 ..end
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rup02,rup17,rup22,rup06,rup03,'',rup04,'',rup05,rup07,",  #FUN-CC0057 add rup22
                       "'',rup08,rup19,rup09,'',rup10,rup11,rup12,rup13,'',rup14,",
                       "rup15,rup16,rup18 ",   #FUN-AA0086 add 17 18 19
                       "  FROM rup_file ",
                       " WHERE rup01=? AND rupplant = ? AND rup02=?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t256_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#FUN-B90101--add--begin--  
    LET g_forupd_sql = "SELECT rupslk02,rupslk17,rupslk03,'',rupslk04,'',rupslk05,rupslk06,rupslk07,",
                       "'',rupslk08,rupslk19,rupslk09,'',rupslk10,rupslk11,rupslk12,rupslk13,'',rupslk14,",
                       "rupslk15,rupslk16,rupslk18,rupslk20,rupslk21,rupslk22 ", 
                       "  FROM rupslk_file ",
                       " WHERE rupslk01=? AND rupslkplant = ? AND rupslk02=?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t256_bcl_slk CURSOR FROM g_forupd_sql
#FUN-B90101--add--end--  
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #IF g_ruo.ruoconf = '1' THEN
   #IF g_ruo.ruoconf = '1' OR g_ruo.ruo02 <> '1' THEN   #FUN-AA0086 不為手動錄入時不可更改單身筆數 #FUN-CA0086
    IF g_ruo.ruoconf = '1' OR g_ruo.ruo02 NOT MATCHES '[17]' THEN #FUN-CA0086
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
    END IF
#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       DIALOG ATTRIBUTES(UNBUFFERED)
          INPUT ARRAY g_rupslk FROM s_rupslk.*
             ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)
 
           BEFORE INPUT
              DISPLAY "BEFORE INPUT!"
              LET li_a=FALSE                 #FUN-C60100 add
              IF g_rec_b2 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac2)
              END IF
              CALL cl_set_comp_entry("rupslk03,rupslk07                                                       
                         rupslk09,rupslk10,rupslk11",TRUE)
              CALL cl_set_comp_entry("rupslk02,rupslk18,rupslk21",FALSE)

           BEFORE ROW
              DISPLAY "BEFORE ROW!"
              LET p_cmd = ''
              LET l_ac2 = ARR_CURR()
              LET l_lock_sw = 'N'            #DEFAULT
              LET g_success = 'Y'
              LET l_n  = ARR_COUNT()
 
              BEGIN WORK
 
              OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
              IF STATUS THEN
                 CALL cl_err("OPEN t256_cl:", STATUS, 1)
                 CLOSE t256_cl
                 ROLLBACK WORK
                 RETURN
              END IF
 
              FETCH t256_cl INTO g_ruo.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
                 CLOSE t256_cl
                 ROLLBACK WORK
                 RETURN
              END IF
 
              IF g_rec_b2 >= l_ac2 THEN
                 LET p_cmd='u'
                 LET g_rupslk_t.* = g_rupslk[l_ac2].*  #BACKUP
                 LET g_rupslk_o.* = g_rupslk[l_ac2].*  #BACKUP
                 OPEN t256_bcl_slk USING g_ruo.ruo01,g_ruo.ruoplant,g_rupslk_t.rupslk02
                 IF STATUS THEN
                    CALL cl_err("OPEN t256_bcl_slk:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH t256_bcl_slk INTO g_rupslk[l_ac2].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rupslk_t.rupslk02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                    SELECT ima151 INTO l_ima151 FROM ima_file where ima01 = g_rupslk[l_ac2].rupslk03
                    IF l_ima151 = 'Y' THEN        #母料件
                       CALL cl_set_comp_entry("rupslk12,rupslk16,rupslk19",FALSE)
                    ELSE
                       CALL cl_set_comp_entry("rupslk12",TRUE)
                    END IF
                    SELECT ima02 INTO g_rupslk[l_ac2].rupslk03_desc
                        FROM ima_file WHERE ima01 = g_rupslk[l_ac2].rupslk03

                    SELECT gfe02 INTO g_rupslk[l_ac2].rupslk04_desc FROM gfe_file
                       WHERE gfe01 = g_rupslk[l_ac2].rupslk04
                 
                    SELECT gfe02 INTO g_rupslk[l_ac2].rupslk07_desc FROM gfe_file
                        WHERE gfe01 = g_rupslk[l_ac2].rupslk07
                 
                   #FUN-C80095 MARK BEGIN --
                   # SELECT imd02 INTO g_rupslk[l_ac2].rupslk09_desc FROM imd_file
                   #    WHERE imd01 = g_rupslk[l_ac2].rupslk09
                 
                   # SELECT imd02 INTO g_rupslk[l_ac2].rupslk13_desc FROM imd_file
                   #    WHERE imd01 = g_rupslk[l_ac2].rupslk13
                   #FUN-C80095 MARK end ----
                   CALL t256_sel_imd02slk_rup09()            #FUN-C80095 add
                   CALL t256_sel_imd02slk_rup13()            #FUN-C80095 add
                 END IF
                 #在撥出審核狀態下，只能維護撥入倉庫、儲位、批號、數量
                 IF g_ruo.ruoconf = '1' THEN
                    CALL cl_set_comp_entry("rupslk03,rupslk07,
                         rupslk08,rupslk09,rupslk10,rupslk11,rupslk12,rupslk16",FALSE)
                    IF g_ruo.ruo05 = g_plant THEN 
                       SELECT ima151 INTO l_ima151 FROM ima_file where ima01 = g_rupslk[l_ac2].rupslk03
                       IF l_ima151 = 'Y' THEN        #母料件
                          CALL cl_set_comp_entry("rupslk16",FALSE)
                       ELSE  
                          CALL cl_set_comp_entry("rupslk16",TRUE)
                       END IF 
                    END IF 
                 ELSE
                    CALL cl_set_comp_entry("rupslk03,rupslk07,
                         rupslk08,rupslk09,rupslk10,rupslk11",TRUE)
                 END IF
                 IF g_ruo.ruoconf = '0' THEN
                    IF g_ruo.ruo02 = '5' THEN
                       CALL cl_set_comp_entry("rupslk03,rupslk07,rupslk08",FALSE)
                    ELSE
                       CALL cl_set_comp_entry("rupslk03,rupslk07,rupslk08",TRUE)
                    END IF
                 END IF
              END IF 
              CALL s_settext_slk(g_rupslk[l_ac2].rupslk03)
              CALL s_fillimx_slk(g_rupslk[l_ac2].rupslk03,
                                 g_ruo.ruo01,g_rupslk[l_ac2].rupslk02)
              LET g_rec_b3 = g_imx.getLength() 

           BEFORE INSERT
              DISPLAY "BEFORE INSERT!"
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              LET p_cmd2 = 'a'           #FUN-B80110 add
              INITIALIZE g_rupslk[l_ac2].* TO NULL
              LET g_rupslk[l_ac2].rupslk18 = 'N'   #結案否默認為N
              LET g_rupslk[l_ac2].rupslk12 = 0
              LET g_rupslk[l_ac2].rupslk16 = 0
              LET g_rupslk[l_ac2].rupslk19 = 0  
              LET g_rupslk[l_ac2].rupslk17 = '0'  
              #撥出倉庫帶默認值
              IF g_sma.sma142 = 'Y' THEN   #啟用在途倉
                 IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
                    CALL s_check(g_ruo.ruo14,g_ruo.ruo04) RETURNING l_flag_ruo14
                 ELSE                         #調撥在途歸屬撥入方
                    CALL s_check(g_ruo.ruo14,g_ruo.ruo05) RETURNING l_flag_ruo14
                 END IF

                 IF l_flag_ruo14 THEN
                    #FUN-C90049 mark begin---
                    #SELECT rtz08 INTO g_rupslk[l_ac2].rupslk09 FROM rtz_file
                    #   WHERE rtz01 = g_ruo.ruo04
                    #FUN-C90049 mark end-----
                     CALL s_get_noncoststore(g_ruo.ruo04,g_rupslk[l_ac2].rupslk03) RETURNING g_rupslk[l_ac2].rupslk09   #FUN-C90049 add
                 ELSE
                    #FUN-C90049 mark begin---
                    #SELECT rtz07 INTO g_rupslk[l_ac2].rupslk09 FROM rtz_file
                    #   WHERE rtz01 = g_ruo.ruo04
                    #FUN-C90049 mark end-----
                    CALL s_get_coststore(g_ruo.ruo04,g_rupslk[l_ac2].rupslk03) RETURNING g_rupslk[l_ac2].rupslk09   #FUN-C90049 add
                 END IF
              ELSE
                 #FUN-C90049 mark begin---
                 #SELECT rtz07 INTO g_rupslk[l_ac2].rupslk09 FROM rtz_file
                 #   WHERE rtz01 = g_ruo.ruo04
                 #FUN-C90049 mark end-----
                 CALL s_get_coststore(g_ruo.ruo04,g_rupslk[l_ac2].rupslk03) RETURNING g_rupslk[l_ac2].rupslk09   #FUN-C90049 add
              END IF                                                          #FUN-BA0004 add
              IF cl_null(g_rupslk[l_ac2].rupslk09) THEN
                 SELECT imd01 INTO g_rupslk[l_ac2].rupslk09 FROM imd_file
                  WHERE imd10 = 'S' AND imd22 = 'Y' AND imd20 = g_ruo.ruo04
              END IF
             #FUN-C80095 mark begin ---
             # SELECT imd02 INTO g_rupslk[l_ac2].rupslk09_desc FROM imd_file
             #    WHERE imd01 = g_rupslk[l_ac2].rupslk09
             #FUN-C80095 mark end --
              CALL t256_sel_imd02slk_rup09()     #FUN-C80095 add
              #撥入倉庫帶默認值
              IF g_sma.sma142 = 'Y' THEN   #啟用在途倉
                 IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
                    CALL s_check(g_ruo.ruo14,g_ruo.ruo04) RETURNING l_flag_ruo14
                 ELSE                         #調撥在途歸屬撥入方
                    CALL s_check(g_ruo.ruo14,g_ruo.ruo05) RETURNING l_flag_ruo14
                 END IF

                 IF l_flag_ruo14 THEN
                    #FUN-C90049 mark beign---
                    #SELECT rtz08 INTO g_rupslk[l_ac2].rupslk13 FROM rtz_file
                    #   WHERE rtz01 = g_ruo.ruo05
                    #FUN-C90049 mark end-----
                    CALL s_get_noncoststore(g_ruo.ruo05,g_rupslk[l_ac2].rupslk03) RETURNING g_rupslk[l_ac2].rupslk13   #FUN-C90049 add
                 ELSE
                    #FUN-C90049 mark begin---
                    #SELECT rtz07 INTO g_rupslk[l_ac2].rupslk13 FROM rtz_file
                    #   WHERE rtz01 = g_ruo.ruo05
                    #FUN-C90049 mark end------
                    CALL s_get_coststore(g_ruo.ruo05,g_rupslk[l_ac2].rupslk03) RETURNING g_rupslk[l_ac2].rupslk13   #FUN-C90049 add
                 END IF
              ELSE
                 #FUN-C90049 mark begin---
                 #SELECT rtz07 INTO g_rupslk[l_ac2].rupslk13 FROM rtz_file 
                 #   WHERE rtz01 = g_ruo.ruo05
                 #FUN-C90049 mark end------
                 CALL s_get_coststore(g_ruo.ruo05,g_rupslk[l_ac2].rupslk03) RETURNING g_rupslk[l_ac2].rupslk13   #FUN-C90049 add
              END IF                                                          #FUN-BA0004 add
              IF cl_null(g_rupslk[l_ac2].rupslk13) THEN
                 SELECT imd01 INTO g_rupslk[l_ac2].rupslk13 FROM imd_file
                  WHERE imd10 = 'S' AND imd22 = 'Y' AND imd20 = g_ruo.ruo05
              END IF
             #FUN-C80095 mark begin ---
             # SELECT imd02 INTO g_rupslk[l_ac2].rupslk13_desc FROM imd_file 
             #    WHERE imd01 = g_rupslk[l_ac2].rupslk13
             #FUN-C80095 mark end --
              CALL t256_sel_imd02slk_rup13()     #FUN-C80095 add
 
              LET g_rupslk_t.* = g_rupslk[l_ac2].*
              LET g_rupslk_o.* = g_rupslk[l_ac2].*
              CALL cl_show_fld_cont()
              NEXT FIELD rupslk02
 
           AFTER INSERT
              DISPLAY "AFTER INSERT!"
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 CANCEL INSERT
              END IF
              CALL chk_store()
              IF NOT cl_null(g_errno) THEN
                 IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                    CALL cl_err('',g_errno, 0)
                    NEXT FIELD rupslk09
                 ELSE
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rupslk13
                 END IF    
              END IF
              
              INSERT INTO rupslk_file (rupslk01,rupslk02,rupslk03,rupslk04,rupslk05,rupslk06,rupslk07,
                                       rupslk08,rupslk09,rupslk10,rupslk11,rupslk12,rupslk13,
                                       rupslk14,rupslk15,rupslk16,rupslk17,rupslk18,rupslk19,
                                       rupslk20,rupslk21,rupslk22,rupslkplant,rupslklegal) 
                                   VALUES(g_ruo.ruo01,g_rupslk[l_ac2].rupslk02,g_rupslk[l_ac2].rupslk03,
                                          g_rupslk[l_ac2].rupslk04,g_rupslk[l_ac2].rupslk05,g_rupslk[l_ac2].rupslk06,
                                          g_rupslk[l_ac2].rupslk07,g_rupslk[l_ac2].rupslk08,g_rupslk[l_ac2].rupslk09,
                                          g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11,g_rupslk[l_ac2].rupslk12,
                                          g_rupslk[l_ac2].rupslk13,g_rupslk[l_ac2].rupslk14,g_rupslk[l_ac2].rupslk15,
                                          g_rupslk[l_ac2].rupslk16,g_rupslk[l_ac2].rupslk17,g_rupslk[l_ac2].rupslk18,
                                          g_rupslk[l_ac2].rupslk19,g_rupslk[l_ac2].rupslk20,g_rupslk[l_ac2].rupslk21,
                                          g_rupslk[l_ac2].rupslk22,g_ruo.ruoplant,g_ruo.ruolegal)
                    
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("ins","rupslk_file",g_ruo.ruo01,g_rupslk[l_ac2].rupslk02,SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rupslk[l_ac2].rupslk03
                 IF l_ima151 = 'N' THEN        #非子、母料件
                    LET g_rup_slk.rup01 = g_ruo.ruo01
                    SELECT MAX(rup02) INTO l_n FROM rup_file WHERE rup01 = g_ruo.ruo01
                    IF cl_null(l_n) THEN
                       LET l_n = 0
                    END IF
                    LET g_rup_slk.rup02 = l_n + 1
                    LET g_rup_slk.rup03 = g_rupslk[l_ac2].rupslk03
                    CALL t256_rupslk_move()
                    INSERT INTO rup_file VALUES(g_rup_slk.*)
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("ins","rup_file",g_ruo.ruo01,g_rupslk[l_ac2].rupslk02,SQLCA.sqlcode,"","",1)
                       CANCEL INSERT
                    END IF
                 END IF 
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 LET g_rec_b2=g_rec_b2+1
                 DISPLAY g_rec_b2 TO FORMONLY.cn2
                 SELECT SUM(rupslk20*rupslk16) INTO l_sum FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
                 SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
                 CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum
                 DISPLAY l_sum TO FORMONLY.sum
              
                 SELECT SUM(rupslk21*rupslk16) INTO l_sum1 FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                                             AND rupslkplant = g_ruo.ruoplant
                 CALL cl_digcut(l_sum1,t_azi04) RETURNING l_sum1
                 DISPLAY l_sum1 TO FORMONLY.sum1
                 SELECT SUM(rup16) INTO l_sum_rup16 FROM rup_file WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
                 DISPLAY l_sum_rup16 TO FORMONLY.qty 
              END IF
 
           BEFORE FIELD rupslk02
              IF g_rupslk[l_ac2].rupslk02 IS NULL OR g_rupslk[l_ac2].rupslk02 = 0 THEN
                 SELECT max(rupslk02)+1
                   INTO g_rupslk[l_ac2].rupslk02
                   FROM rupslk_file
                  WHERE rupslk01 = g_ruo.ruo01 
                    AND rupslkplant = g_ruo.ruoplant 
                 IF g_rupslk[l_ac2].rupslk02 IS NULL OR g_rupslk[l_ac2].rupslk02 = 0 THEN
                    LET g_rupslk[l_ac2].rupslk02 = 1
                 END IF
              END IF
 
           AFTER FIELD rupslk02
              IF NOT cl_null(g_rupslk[l_ac2].rupslk02) THEN
                 IF g_rupslk[l_ac2].rupslk02 != g_rupslk_t.rupslk02
                    OR g_rupslk_t.rupslk02 IS NULL THEN
                    SELECT count(*) INTO l_n
                      FROM rupslk_file
                     WHERE rupslk01 = g_ruo.ruo01
                       AND rupslk02 = g_rupslk[l_ac2].rupslk02
                       AND rupslkplant = g_ruo.ruoplant 
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_rupslk[l_ac2].rupslk02 = g_rupslk_t.rupslk02
                       NEXT FIELD rupslk02
                    END IF
                 END IF
              END IF
 
         BEFORE FIELD rupslk03
            IF g_rupslk[l_ac2].rupslk06 IS NULL THEN
               CALL cl_set_comp_entry("rupslk03",TRUE)
            ELSE
        	    CALL cl_set_comp_entry("rupslk03",FALSE)
            END IF
            
         AFTER FIELD rupslk03
            IF NOT cl_null(g_rupslk[l_ac2].rupslk03) THEN
               IF NOT s_chk_item_no(g_rupslk[l_ac2].rupslk03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rupslk[l_ac2].rupslk03= g_rupslk_t.rupslk03
                  NEXT FIELD rupslk03
               END IF
               #FUN-C20006--add--begin-- 
               SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rupslk[l_ac2].rupslk03 
                                                         AND ima1010='1' and imaacti='Y'
               IF l_n=0 THEN
                  CALL cl_err('','100',0)
                  LET g_rupslk[l_ac2].rupslk03=g_rupslk_t.rupslk03
                  NEXT FIELD rupslk03
               END IF   
               #FUN-C20006--add--end--    
               SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file where ima01 = g_rupslk[l_ac2].rupslk03
               IF l_ima151 = 'N' AND  l_imaag = '@CHILD' THEN
                  CALL cl_err('','axm1104',0)
                  NEXT FIELD rupslk03
               END IF
               IF l_ima151 = 'Y' THEN        #母料件
                  CALL cl_set_comp_entry('rupslk12,rupslk16,rupslk19',FALSE)
               ELSE
                  CALL cl_set_comp_entry('rupslk12',TRUE)
               END IF  
         #TQC-C30196--add--begin--
               IF g_rupslk[l_ac2].rupslk03 != g_rupslk_t.rupslk03 AND g_rupslk_t.rupslk03 IS NOT NULL THEN
                  LET g_rupslk[l_ac2].rupslk18 = 'N'   #結案否默認為N
                  LET g_rupslk[l_ac2].rupslk17 = '0' 
                  LET g_rupslk[l_ac2].rupslk20 = 0
                  LET g_rupslk[l_ac2].rupslk21 = 0
                  LET g_rupslk[l_ac2].rupslk22 = 0     
                  SELECT SUM(rup12),SUM(rup19),SUM(rup16) 
                   INTO g_rupslk[l_ac2].rupslk12,g_rupslk[l_ac2].rupslk16,g_rupslk[l_ac2].rupslk19 
                        FROM rup_file WHERE rup01 = g_ruo.ruo01
                                        AND rup21s= g_rupslk[l_ac2].rupslk02
                                        AND rup20s= g_rupslk[l_ac2].rupslk03
                                        AND rupplant = g_ruo.ruoplant
                 IF SQLCA.sqlcode OR cl_null(g_rupslk[l_ac2].rupslk12) THEN
                    LET g_rupslk[l_ac2].rupslk12 = 0
                 END IF
                 IF g_ruo.ruo02 = '1' THEN
                    LET g_rupslk[l_ac2].rupslk19 = g_rupslk[l_ac2].rupslk12
                 END IF
                 IF cl_null(g_rupslk[l_ac2].rupslk19) THEN
                    LET g_rupslk[l_ac2].rupslk19= 0
                 END IF
                 LET g_rupslk[l_ac2].rupslk16 = g_rupslk[l_ac2].rupslk12
               END IF
         #TQC-C30196--add--end--
               IF g_ruo.ruo02 ='1' THEN
                  SELECT ima128 INTO g_rupslk[l_ac2].rupslk21 FROM ima_file where ima01 = g_rupslk[l_ac2].rupslk03
               END IF
               IF g_rupslk_o.rupslk03 IS NULL OR
                  (g_rupslk[l_ac2].rupslk03 != g_rupslk_o.rupslk03 ) THEN
                  SELECT rvr05 INTO g_rupslk[l_ac2].rupslk06 FROM rvr_file
                      WHERE rvr04 = g_rupslk[l_ac2].rupslk03
                        AND rvrplant = g_ruo.ruoplant
                  CALL t256_rup03()      
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rupslk[l_ac2].rupslk03,g_errno,0)
                     LET g_rupslk[l_ac2].rupslk03 = g_rupslk_o.rupslk03
                     DISPLAY BY NAME g_rupslk[l_ac2].rupslk03
                     NEXT FIELD rupslk03
                  END IF

                  IF g_rupslk[l_ac2].rupslk07 IS NOT NULL AND 
                     g_rupslk[l_ac2].rupslk04 IS NOT NULL THEN 
                     LET l_flag = NULL
                     LET l_fac = NULL
                     CALL s_umfchk(g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk07,
                                   g_rupslk[l_ac2].rupslk04)
                        RETURNING l_flag,l_fac
                     IF l_flag = 1 THEN
                        LET l_msg = g_rupslk[l_ac2].rupslk07 CLIPPED,'->',
                                    g_rupslk[l_ac2].rupslk04 CLIPPED
                        CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                        NEXT FIELD rupslk03
                     END IF
                     LET g_rupslk[l_ac2].rupslk08 = l_fac  
                  END IF 
                  CALL t256_check_img10() 
                 #TQC-C20039 add START
                 #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN   
               #FUN-D30024 --------Begin--------
                 #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
                 #IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                  INITIALIZE g_imd23 TO NULL  
                  CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                  #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                  IF g_check_img = 'N' AND g_imd23 = 'N' THEN
               #FUN-D30024 --------End----------
                     CALL cl_err('','mfg3471',0)  
                     NEXT FIELD rupslk03 
                  END IF  
                 #TQC-C20039 add END
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rupslk03
                  END IF   
                  CALL s_settext_slk(g_rupslk[l_ac2].rupslk03)
                  CALL s_fillimx_slk(g_rupslk[l_ac2].rupslk03,
                                     g_ruo.ruo01,g_rupslk[l_ac2].rupslk02)
                  LET g_rec_b3 = g_imx.getLength() 
                  CALL t256_add_store(g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk09,g_ruo.ruoplant
                                     ,g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11) 
                  CALL t256_rupslk20(l_ac2)
               END IF  
            END IF 
                       
           AFTER FIELD rupslk07
              IF NOT cl_null(g_rupslk[l_ac2].rupslk07) THEN
                 CALL t256_rupslk07()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rupslk[l_ac2].rupslk07,g_errno,0)
                    LET g_rupslk[l_ac2].rupslk07 = g_rupslk_o.rupslk07
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk07
                    NEXT FIELD rupslk07
                 END IF
                 IF (NOT cl_null(g_rupslk[l_ac2].rupslk03)) AND 
                    (NOT cl_null(g_rupslk[l_ac2].rupslk04)) THEN
                    LET l_flag = NULL
                    LET l_fac = NULL
                    CALL s_umfchk(g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk07,
                                  g_rupslk[l_ac2].rupslk04)
                       RETURNING l_flag,l_fac
                    IF l_flag = 1 THEN
                       LET l_msg = g_rupslk[l_ac2].rupslk07 CLIPPED,'->',
                                   g_rupslk[l_ac2].rupslk04 CLIPPED
                       CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                       NEXT FIELD rupslk07
                    END IF
                    LET g_rupslk[l_ac2].rupslk08 = l_fac 
                 END IF 
              END IF
           
           AFTER FIELD rupslk05
              IF NOT cl_null(g_rupslk[l_ac2].rupslk05) THEN
                 CALL t256_check_out_store()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rupslk[l_ac2].rupslk05,g_errno,0)
                    NEXT FIELD rupslk05
                 END IF
              END IF
           BEFORE FIELD rupslk09              
             LET l_warehouse = '1'            
             LET g_yes = 'rupslk09'           
 
           AFTER FIELD rupslk09   #撥出倉庫
              IF NOT cl_null(g_rupslk[l_ac2].rupslk09) THEN
                 CALL t256_rupslk09()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rupslk[l_ac2].rupslk09,g_errno,0)
                    LET g_rupslk[l_ac2].rupslk09 = g_rupslk_o.rupslk09
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk09
                    NEXT FIELD rupslk09
                 END IF
              CALL chk_store()
              IF NOT cl_null(g_errno) THEN
                 IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                    CALL cl_err('',g_errno, 0)
                    NEXT FIELD rupslk09
                 ELSE
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rupslk13
                 END IF
              END IF
                 #檢查倉庫是否可用
              CALL s_swyn(g_rupslk[l_ac2].rupslk09) RETURNING sn1,sn2
              IF sn1 != 0 THEN
                 CALL cl_err(g_rupslk[l_ac2].rupslk09,'mfg6080',0)
                 NEXT FIELD rupslk09
              END IF
              SELECT COUNT(*) INTO g_cnt FROM img_file
                 WHERE img01 = g_rupslk[l_ac2].rupslk03
                   AND img02 = g_rupslk[l_ac2].rupslk09
                    AND img03 = g_rupslk[l_ac2].rupslk10
                    AND img04 = g_rupslk[l_ac2].rupslk11
                   AND img18 < g_today
              IF g_cnt > 0 THEN        #檢查該料件儲批是否已經過期
                 CALL cl_err('','aim-400',0)
                 NEXT FIELD rupslk09
              END IF
              #檢查倉庫和經營方式是否匹配
              CALL t256_check_out_store()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rupslk[l_ac2].rupslk09,g_errno,0)
                 NEXT FIELD rupslk09
              END IF
              IF g_rupslk[l_ac2].rupslk09 <> g_rupslk_o.rupslk09            
                 OR g_rupslk[l_ac2].rupslk10 <> g_rupslk_o.rupslk10          
                 OR g_rupslk[l_ac2].rupslk11 <> g_rupslk_o.rupslk11         
                 OR (NOT cl_null(g_rupslk[l_ac2].rupslk10) AND cl_null(g_rupslk_o.rupslk10))         
                 OR (NOT cl_null(g_rupslk[l_ac2].rupslk11) AND cl_null(g_rupslk_o.rupslk11))THEN                    
                 CALL t256_check_img10()
                 #TQC-C20039 add START
                 #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
              #FUN-D30024 ----------Begin----------
              #   INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
              #   CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
              #   IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                  INITIALIZE g_imd23 TO NULL 
                  CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                  #FUN-D30024  #TQC-D40078 g_ruo.ruo04
                  IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
              #FUN-D30024 ----------End------------
                     CALL cl_err('','mfg3471',0)
                     NEXT FIELD rupslk09
                  END IF 
                 #TQC-C20039 add END
                 IF NOT cl_null(g_errno) THEN            
                    NEXT FIELD rupslk09
                 ELSE
                    LET g_rupslk_o.rupslk09 = g_rupslk[l_ac2].rupslk09  
                    LET g_rupslk_o.rupslk10 = g_rupslk[l_ac2].rupslk10   
                    LET g_rupslk_o.rupslk11 = g_rupslk[l_ac2].rupslk11  
                 END IF
              END IF                                        
           END IF
       #FUN-D40103 -------Begin-------
           IF NOT s_imechk(g_rupslk[l_ac2].rupslk09,g_rupslk[l_ac2].rupslk10) THEN
              NEXT FIELD rupslk10
           END IF
       #FUN-D40103 -------End---------

           BEFORE FIELD rupslk10
             LET l_warehouse = '1'
             LET g_yes = 'rupslk10'

           AFTER FIELD rupslk10
              #FUN-D40103 mark-------Begin---------
              #IF (NOT cl_null(g_rupslk[l_ac2].rupslk10)) AND (NOT cl_null(g_rupslk[l_ac2].rupslk09)) THEN
              #   LET l_n = 0
              #   SELECT count(*) INTO l_n FROM ime_file
              #      WHERE ime01 = g_rupslk[l_ac2].rupslk09
              #        AND ime02 = g_rupslk[l_ac2].rupslk10
              #   IF l_n = 0 THEN
              #      CALL cl_err3("sel","ime_file",g_rupslk[l_ac2].rupslk09,g_rupslk[l_ac2].rupslk10,100,"","",0)
              #      NEXT FIELD rupslk10
              #   END IF
              #END IF
              #FUN-D40103 mark-------end---------
              IF (g_rupslk[l_ac2].rupslk10 <> g_rupslk_o.rupslk10  
                  OR (NOT cl_null(g_rupslk_o.rupslk10) AND g_rupslk[l_ac2].rupslk10 IS NULL)
                  OR (NOT cl_null(g_rupslk[l_ac2].rupslk10) AND cl_null(g_rupslk_o.rupslk10))
                  OR (NOT cl_null(g_rupslk[l_ac2].rupslk11) AND cl_null(g_rupslk_o.rupslk11)))THEN
                CALL t256_check_img10()
                 #TQC-C20039 add START
                 #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
                #FUN-D30024 ----------Begin------------
                # INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                # CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
                # IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                  INITIALIZE g_imd23 TO NULL 
                  CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024 #TQC-D40078 g_ruo.ruo04 
                  IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
                #FUN-D30024 ----------End--------------
                     CALL cl_err('','mfg3471',0)
                     NEXT FIELD rupslk10
                  END IF 
                 #TQC-C20039 add END
                IF NOT cl_null(g_errno) THEN
                   NEXT FIELD rupslk10
                ELSE
                   LET g_rupslk_o.rupslk09 = g_rupslk[l_ac2].rupslk09
                   LET g_rupslk_o.rupslk10 = g_rupslk[l_ac2].rupslk10
                   LET g_rupslk_o.rupslk11 = g_rupslk[l_ac2].rupslk11
                END IF
             END IF
             IF cl_null(g_rupslk[l_ac2].rupslk10) THEN LET g_rupslk[l_ac2].rupslk10 = ' ' END IF   #TQC-D50127
       #FUN-D40103 -------Begin-------
             IF NOT s_imechk(g_rupslk[l_ac2].rupslk09,g_rupslk[l_ac2].rupslk10) THEN
                NEXT FIELD rupslk10
             END IF
       #FUN-D40103 -------End---------
           BEFORE FIELD rupslk11
             LET l_warehouse = '1'
             LET g_yes = 'rupslk11'

           AFTER FIELD rupslk11
             IF (g_rupslk[l_ac2].rupslk11 <> g_rupslk_o.rupslk11 
                OR (NOT cl_null(g_rupslk_o.rupslk11) AND g_rupslk[l_ac2].rupslk11 IS NULL)
                OR (NOT cl_null(g_rupslk[l_ac2].rupslk10) AND cl_null(g_rupslk_o.rupslk10))
                OR (NOT cl_null(g_rupslk[l_ac2].rupslk11) AND cl_null(g_rupslk_o.rupslk11))) THEN
                CALL t256_check_img10()
                #TQC-C20039 add START
                #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
              #FUN-D30024 ----------Begin---------
              #  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
              #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
              #  IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                 IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
              #FUN-D30024 ----------End-----------
                    CALL cl_err('','mfg3471',0)
                    NEXT FIELD rupslk11
                 END IF 
                #TQC-C20039 add END
                IF NOT cl_null(g_errno) THEN
                   NEXT FIELD rupslk11
                ELSE
                   LET g_rupslk_o.rupslk09 = g_rupslk[l_ac2].rupslk09
                   LET g_rupslk_o.rupslk10 = g_rupslk[l_ac2].rupslk10
                   LET g_rupslk_o.rupslk11 = g_rupslk[l_ac2].rupslk11
                END IF
             END IF
       #FUN-D40103 -------Begin-------
             IF NOT s_imechk(g_rupslk[l_ac2].rupslk09,g_rupslk[l_ac2].rupslk10) THEN
                NEXT FIELD rupslk10
             END IF
       #FUN-D40103 -------End---------
 
           AFTER FIELD rupslk12
              IF NOT cl_null(g_rupslk[l_ac2].rupslk12) THEN
                 IF g_rupslk[l_ac2].rupslk12 <= 0 THEN
                    CALL cl_err('','art-305',0)
                    NEXT FIELD rupslk12
                 END IF
                 IF NOT cl_null(g_rupslk[l_ac2].rupslk09) THEN
                    CALL t256_check_out_store()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_rupslk[l_ac2].rupslk09,g_errno,0)
                       NEXT FIELD rupslk09
                    END IF
                 END IF
                 IF NOT cl_null(g_rupslk[l_ac2].rupslk13) THEN
                    CALL t256_check_in_store()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_rupslk[l_ac2].rupslk13,g_errno,0)
                       NEXT FIELD rupslk13
                    END IF
                 END IF
                 CALL chk_store()
                 IF NOT cl_null(g_errno) THEN
                    IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                       CALL cl_err('',g_errno, 0)
                       NEXT FIELD rupslk09
                    ELSE
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rupslk13
                    END IF
                 END IF
                 IF g_rupslk[l_ac2].rupslk12 <> g_rupslk_o.rupslk12   
                             OR p_cmd2='a'  THEN          
                   CALL t256_check_img10()
                 #TQC-C20039 add START
                  #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
                 #FUN-D30024 -----------Begin----------
                 # INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                 # CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
                 # IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                   INITIALIZE g_imd23 TO NULL  
                   CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                   IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
                 #FUN-D30024 -----------End------------
                      CALL cl_err('','mfg3471',0)
                      NEXT FIELD rupslk12
                   END IF 
                 #TQC-C20039 add END
                   IF NOT cl_null(g_errno) THEN         
                      NEXT FIELD rupslk12                    
                   END IF                                
                   LET g_rupslk_o.rupslk09 = g_rupslk[l_ac2].rupslk09  
                   LET g_rupslk_o.rupslk10 = g_rupslk[l_ac2].rupslk10 
                   LET g_rupslk_o.rupslk11 = g_rupslk[l_ac2].rupslk11  
                   LET g_rupslk_o.rupslk12 = g_rupslk[l_ac2].rupslk12  
                   LET g_rupslk[l_ac2].rupslk16 = g_rupslk[l_ac2].rupslk12
                   LET p_cmd2 = 'u'                       
                 END IF                                   
                 LET g_rupslk[l_ac2].rupslk16 = g_rupslk[l_ac2].rupslk12
              END IF

           ON CHANGE rupslk12
              IF g_ruo.ruo02 = '1' THEN
                 LET g_rupslk[l_ac2].rupslk19 = g_rupslk[l_ac2].rupslk12
              END IF    
           BEFORE FIELD rupslk13     
             LET l_warehouse = '2'   
           
           AFTER FIELD rupslk13
              IF NOT cl_null(g_rupslk[l_ac2].rupslk13) THEN
                 CALL t256_rupslk13()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rupslk[l_ac2].rupslk13,g_errno,0)
                    LET g_rupslk[l_ac2].rupslk13 = g_rupslk_o.rupslk13
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk13
                    NEXT FIELD rupslk13
                 END IF
                 CALL t256_check_in_store()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rupslk[l_ac2].rupslk13,g_errno,0)
                    NEXT FIELD rupslk13
                 END IF
                 CALL chk_store()
                 IF NOT cl_null(g_errno) THEN
                    IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                       CALL cl_err('',g_errno, 0)
                       NEXT FIELD rupslk09
                    ELSE
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rupslk13
                    END IF
                 END IF
                 CALL t256_add_store(g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk13,g_ruo.ruo05
                                    ,g_rupslk[l_ac2].rupslk14,g_rupslk[l_ac2].rupslk15   #MOD-A80112
                                    )
                 IF NOT cl_null(g_errno) THEN
                    IF g_errno = "SKIP" THEN 
                       NEXT FIELD rupslk14 
                    ELSE
                       CALL cl_err(g_rupslk[l_ac2].rupslk09,g_errno,0)
                       NEXT FIELD rupslk13
                    END IF
                 END IF
              END IF
       #FUN-D40103 -------Begin-------
             IF NOT s_imechk(g_rupslk[l_ac2].rupslk13,g_rupslk[l_ac2].rupslk14) THEN
                NEXT FIELD rupslk14
             END IF
       #FUN-D40103 -------End---------
           
           AFTER FIELD rupslk14
           #FUN-D40103 mark----------Begin------------
              #IF (NOT cl_null(g_rupslk[l_ac2].rupslk14)) AND (NOT cl_null(g_rupslk[l_ac2].rupslk13)) THEN
              #   LET l_n = 0
              #   SELECT count(*) INTO l_n FROM ime_file
              #      WHERE ime01 = g_rupslk[l_ac2].rupslk13 
              #        AND ime02 = g_rupslk[l_ac2].rupslk14 
              #   IF l_n = 0 THEN
              #      CALL cl_err3("sel","ime_file",g_rupslk[l_ac2].rupslk13,g_rupslk[l_ac2].rupslk14,100,"","",0)
              #      NEXT FIELD rupslk14 
              #   END IF 
              #END IF                 
           #FUN-D40103 ----------Begin------------
             IF cl_null(g_rupslk[l_ac2].rupslk14) THEN LET g_rupslk[l_ac2].rupslk14 = ' ' END IF   #TQC-D50127
       #FUN-D40103 -------Begin-------
             IF NOT s_imechk(g_rupslk[l_ac2].rupslk13,g_rupslk[l_ac2].rupslk14) THEN
                NEXT FIELD rupslk14
             END IF

           AFTER FIELD rupslk15
             IF NOT s_imechk(g_rupslk[l_ac2].rupslk13,g_rupslk[l_ac2].rupslk14) THEN
                NEXT FIELD rupslk14
             END IF
       #FUN-D40103 -------End---------
           AFTER FIELD rupslk16
              IF NOT cl_null(g_rupslk[l_ac2].rupslk16) THEN
                 IF g_rupslk[l_ac2].rupslk16 < 0 THEN
                    CALL cl_err('','art-307',0)
                    NEXT FIELD rupslk16
                 END IF
                 #撥入數量不能大于撥出數量
                 IF NOT cl_null(g_rupslk[l_ac2].rupslk12)  THEN
                    IF g_rupslk[l_ac2].rupslk16 > g_rupslk[l_ac2].rupslk12 THEN
                       CALL cl_err('','art-324',0)
                       NEXT FIELD rupslk16
                    END IF
                 END IF
              END IF   
           
           AFTER FIELD rupslk20							
              IF NOT cl_null(g_rupslk[l_ac2].rupslk20) THEN 							
                 IF g_rupslk[l_ac2].rupslk20<0 THEN 							
                    CALL cl_err(g_rupslk[l_ac2].rupslk20,'mfg-111',0)							
                    NEXT FIELD rupslk20							
                 END IF						
                 SELECT azi03 INTO t_azi03 FROM azi_file
                   WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
                 CALL cl_digcut(g_rupslk[l_ac2].rupslk20,t_azi03) RETURNING g_rupslk[l_ac2].rupslk20
                 IF (g_rupslk[l_ac2].rupslk20!=g_rupslk_t.rupslk20 OR g_rupslk_t.rupslk20 IS NULL ) THEN							
                      LET g_rupslk[l_ac2].rupslk22=g_rupslk[l_ac2].rupslk20*100/g_rupslk[l_ac2].rupslk21							
                 END IF 							
                 CALL cl_digcut(g_rupslk[l_ac2].rupslk22,t_azi03) RETURNING g_rupslk[l_ac2].rupslk22
                 DISPLAY BY NAME g_rupslk[l_ac2].rupslk22 
              END IF 							
             							
           AFTER FIELD rupslk22							
              IF NOT cl_null(g_rupslk[l_ac2].rupslk22) THEN 							
                 IF g_rupslk[l_ac2].rupslk22 <0 THEN 							
                    CALL cl_err('','atm-384',1)							
                    NEXT FIELD rupslk22							
                 END IF							
                 SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
                 CALL cl_digcut(g_rupslk[l_ac2].rupslk22,t_azi03) RETURNING g_rupslk[l_ac2].rupslk22
                 IF ((g_rupslk[l_ac2].rupslk22 <> g_rupslk_t.rupslk22 AND g_rupslk_t.rupslk22 IS NOT NULL) OR 
                     (cl_null(g_rupslk_t.rupslk22) AND cl_null(g_rupslk[l_ac2].rupslk20))) THEN 							
                    LET g_rupslk[l_ac2].rupslk20=g_rupslk[l_ac2].rupslk21*g_rupslk[l_ac2].rupslk22/100							
                    CALL cl_digcut(g_rupslk[l_ac2].rupslk20,t_azi03) RETURNING g_rupslk[l_ac2].rupslk20							
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk20							
                 END IF 							
              END IF							
          
           BEFORE DELETE
              DISPLAY "BEFORE DELETE"
              IF g_rupslk_t.rupslk02 > 0 AND g_rupslk_t.rupslk02 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM rupslk_file
                  WHERE rupslk01 = g_ruo.ruo01
                    AND rupslkplant = g_ruo.ruoplant 
                    AND rupslk02 = g_rupslk_t.rupslk02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rupslk_file",g_ruo.ruo01,g_rupslk_t.rupslk02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE
                    DELETE FROM rup_file 
                          WHERE rup01 = g_ruo.ruo01 
                            AND rupplant = g_ruo.ruoplant
                            AND rup21s = g_rupslk_t.rupslk02

                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","rup_file",g_ruo.ruo01,g_rupslk_t.rupslk02,SQLCA.sqlcode,"","",1) 
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                 END IF
                 LET g_rec_b2=g_rec_b2-1
                 DISPLAY g_rec_b2 TO FORMONLY.cn2
                 SELECT SUM(rupslk20*rupslk16) INTO l_sum FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
                 SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
                 CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum 
                 DISPLAY l_sum TO FORMONLY.sum

                 SELECT SUM(rupslk21*rupslk16) INTO l_sum1 FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                                             AND rupslkplant = g_ruo.ruoplant
                 CALL cl_digcut(l_sum1,t_azi04) RETURNING l_sum1
                 DISPLAY l_sum1 TO FORMONLY.sum1 
                 SELECT SUM(rup16) INTO l_sum_rup16 FROM rup_file WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
                 DISPLAY l_sum_rup16 TO FORMONLY.qty
              END IF
              COMMIT WORK
 
           ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET g_rupslk[l_ac2].* = g_rupslk_t.*
                 CLOSE t256_bcl_slk
                 ROLLBACK WORK
                 EXIT DIALOG
              END IF
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(g_rupslk[l_ac2].rupslk02,-263,1)
                 LET g_rupslk[l_ac2].* = g_rupslk_t.*
              ELSE
                 UPDATE rupslk_file SET rupslk02=g_rupslk[l_ac2].rupslk02,
                                        rupslk03=g_rupslk[l_ac2].rupslk03,
                                        rupslk04=g_rupslk[l_ac2].rupslk04,
                                        rupslk05=g_rupslk[l_ac2].rupslk05,
                                        rupslk06=g_rupslk[l_ac2].rupslk06,
                                        rupslk07=g_rupslk[l_ac2].rupslk07,
                                        rupslk08=g_rupslk[l_ac2].rupslk08,
                                        rupslk09=g_rupslk[l_ac2].rupslk09,
                                        rupslk10=g_rupslk[l_ac2].rupslk10,
                                        rupslk11=g_rupslk[l_ac2].rupslk11,
                                        rupslk12=g_rupslk[l_ac2].rupslk12,
                                        rupslk13=g_rupslk[l_ac2].rupslk13,
                                        rupslk14=g_rupslk[l_ac2].rupslk14,
                                        rupslk15=g_rupslk[l_ac2].rupslk15,
                                        rupslk16=g_rupslk[l_ac2].rupslk16,
                                        rupslk17=g_rupslk[l_ac2].rupslk17,
                                        rupslk18=g_rupslk[l_ac2].rupslk18,
                                        rupslk19=g_rupslk[l_ac2].rupslk19,
                                        rupslk20=g_rupslk[l_ac2].rupslk20,
                                        rupslk21=g_rupslk[l_ac2].rupslk21,
                                        rupslk22=g_rupslk[l_ac2].rupslk22 
                  WHERE rupslk01=g_ruo.ruo01
                    AND rupslkplant = g_ruo.ruoplant
                    AND rupslk02=g_rupslk_t.rupslk02
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rupslk_file",g_ruo.ruo01,g_rupslk_t.rupslk02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_rupslk[l_ac2].* = g_rupslk_t.*
                 ELSE
                    LET g_ruo.ruomodu = g_user                                                         
                    LET g_ruo.ruodate = g_today
                    IF g_rupslk[l_ac2].rupslk03 != g_rupslk_t.rupslk03 THEN
                       DELETE FROM rup_file WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
                                              AND rup21s = g_rupslk_t.rupslk02
                       SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rupslk[l_ac2].rupslk03
                       IF l_ima151 = 'N' THEN        #非子、母料件
                          LET g_rup_slk.rup01 = g_ruo.ruo01
                          SELECT MAX(rup02) INTO l_n FROM rup_file WHERE rup01 = g_ruo.ruo01
                          IF cl_null(l_n) THEN
                             LET l_n = 0
                          END IF
                          LET g_rup_slk.rup02 = l_n + 1
                          LET g_rup_slk.rup03 = g_rupslk[l_ac2].rupslk03
                          CALL t256_rupslk_move()
                          INSERT INTO rup_file VALUES(g_rup_slk.*)
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("ins","rup_file",g_ruo.ruo01,g_rupslk[l_ac2].rupslk02,SQLCA.sqlcode,"","",1)
                          END IF
                       END IF
                    ELSE
                       IF l_ima151 = 'N' THEN        #非子、母料件
                          UPDATE rup_file SET rup04=g_rupslk[l_ac2].rupslk04,
                                           rup05=g_rupslk[l_ac2].rupslk05,
                                           rup06=g_rupslk[l_ac2].rupslk06,
                                           rup07=g_rupslk[l_ac2].rupslk07,
                                           rup08=g_rupslk[l_ac2].rupslk08,
                                           rup09=g_rupslk[l_ac2].rupslk09,
                                           rup10=g_rupslk[l_ac2].rupslk10,
                                           rup11=g_rupslk[l_ac2].rupslk11,
                                           rup12=g_rupslk[l_ac2].rupslk12,
                                           rup13=g_rupslk[l_ac2].rupslk13,
                                           rup14=g_rupslk[l_ac2].rupslk14,
                                           rup15=g_rupslk[l_ac2].rupslk15,
                                           rup16=g_rupslk[l_ac2].rupslk16,
                                           rup17=g_rupslk[l_ac2].rupslk17,
                                           rup18=g_rupslk[l_ac2].rupslk18,
                                           rup19=g_rupslk[l_ac2].rupslk19
                          WHERE rup01=g_ruo.ruo01
                           AND rupplant = g_ruo.ruoplant
                           AND rup21s=g_rupslk[l_ac2].rupslk02
                       ELSE
                          UPDATE rup_file SET rup04=g_rupslk[l_ac2].rupslk04,
                                              rup05=g_rupslk[l_ac2].rupslk05,
                                              rup06=g_rupslk[l_ac2].rupslk06,
                                              rup07=g_rupslk[l_ac2].rupslk07,
                                              rup08=g_rupslk[l_ac2].rupslk08,
                                              rup09=g_rupslk[l_ac2].rupslk09,
                                              rup10=g_rupslk[l_ac2].rupslk10,
                                              rup11=g_rupslk[l_ac2].rupslk11,
                                              rup13=g_rupslk[l_ac2].rupslk13,
                                              rup14=g_rupslk[l_ac2].rupslk14,
                                              rup15=g_rupslk[l_ac2].rupslk15,
                                              rup17=g_rupslk[l_ac2].rupslk17,
                                              rup18=g_rupslk[l_ac2].rupslk18 
                            WHERE rup01=g_ruo.ruo01
                              AND rupplant = g_ruo.ruoplant
                              AND rup21s=g_rupslk[l_ac2].rupslk02
                       END IF
                    END IF
                    IF SQLCA.sqlcode THEN
                       ROLLBACK WORK
                    ELSE 
                       MESSAGE 'UPDATE O.K'
                       COMMIT WORK
                       SELECT SUM(rupslk20*rupslk16) INTO l_sum FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
                       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
                       CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum 
                       DISPLAY l_sum TO FORMONLY.sum
                    
                       SELECT SUM(rupslk21*rupslk16) INTO l_sum1 FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                                                   AND rupslkplant = g_ruo.ruoplant
                       CALL cl_digcut(l_sum1,t_azi04) RETURNING l_sum1 
                       DISPLAY l_sum1 TO FORMONLY.sum1  
                       SELECT SUM(rup16) INTO l_sum_rup16 FROM rup_file WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
                       DISPLAY l_sum_rup16 TO FORMONLY.qty  
                    END IF 
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
                    LET g_rupslk[l_ac2].* = g_rupslk_t.*
                 END IF
                 CLOSE t256_bcl_slk
                 ROLLBACK WORK
                 EXIT DIALOG 
              END IF
             #FUN-C80095 mark begin ---
             ##調撥單來源為調撥申請單時,更新申請單的審核碼
             #IF g_ruo.ruo02 = '5' THEN
             #   CALL t256_upd_rvq('3') RETURNING l_flag1
             #   IF (NOT l_flag1) THEN
             #      ROLLBACK WORK
             #      CALL cl_err(g_ruo.ruo01,'art-855',1)
             #      CLOSE t256_bcl_slk
             #      EXIT DIALOG 
             #   END IF
             #END IF
             #FUN-C80095 mark end ----
              CLOSE t256_bcl_slk
              COMMIT WORK
 
           ON ACTION CONTROLO
              IF INFIELD(rupslk02) AND l_ac2 > 1 THEN
                 LET g_rupslk[l_ac2].* = g_rupslk[l_ac2-1].*
                 LET g_rupslk[l_ac2].rupslk02 = g_rec_b2 + 1
                 NEXT FIELD rupslk02
              END IF
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(rupslk03)
                  # CALL cl_init_qry_var()                                     #TQC-C20348 mark
                  # LET g_qryparam.form ="q_ima01"                             #TQC-C20348 mark
                  # LET g_qryparam.default1 = g_rupslk[l_ac2].rupslk03         #TQC-C20348 mark
                  # CALL cl_create_qry() RETURNING g_rupslk[l_ac2].rupslk03    #TQC-C20348 mark
                    CALL q_sel_ima(FALSE, "q_ima01_slk","",g_rupslk[l_ac2].rupslk03,"","","","","",'' )  #TQC-C20348--addq_ima01_slk  
                        RETURNING g_rupslk[l_ac2].rupslk03                            
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk03
                    CALL t256_rup03()
                    NEXT FIELD rupslk03
                                     
                 WHEN INFIELD(rupslk07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_smc01"
                    LET g_qryparam.default1 = g_rupslk[l_ac2].rupslk07
                    CALL cl_create_qry() RETURNING g_rupslk[l_ac2].rupslk07
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk07
                    CALL t256_rupslk07()
                    NEXT FIELD rupslk07
                 
                 WHEN INFIELD(rupslk09) OR INFIELD(rupslk10) OR INFIELD(rupslk11)
                  #TQC-C20411--add--begin--
                    CALL q_img02(FALSE,TRUE,g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk09,
                                g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11,"A",g_rupslk[l_ac2].rupslk05,
                                g_ruo.ruo04)
                    RETURNING g_rupslk[l_ac2].rupslk09,g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11
                  #TQC-C20411--add--end--
                  #TQC-C20411--mark--
                  # CALL q_img42(FALSE,TRUE,g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk09,
                  #             g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11,"A",g_rupslk[l_ac2].rupslk05,
                  #             g_ruo.ruo04)           
                  # RETURNING g_rupslk[l_ac2].rupslk09,g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11
                  #TQC-C20411--mark--end--
                    IF cl_null(g_rupslk[l_ac2].rupslk09) THEN LET g_rupslk[l_ac2].rupslk09 = ' ' END IF 
                    IF cl_null(g_rupslk[l_ac2].rupslk10) THEN LET g_rupslk[l_ac2].rupslk10 = ' ' END IF 
                    IF cl_null(g_rupslk[l_ac2].rupslk11) THEN LET g_rupslk[l_ac2].rupslk11 = ' ' END IF 
                    DISPLAY g_rupslk[l_ac2].rupslk09 TO rupslk09
                    DISPLAY g_rupslk[l_ac2].rupslk10 TO rupslk10
                    DISPLAY g_rupslk[l_ac2].rupslk11 TO rupslk11                 
                    IF INFIELD(rupslk09) THEN NEXT FIELD rupslk09 END IF
                    IF INFIELD(rupslk10) THEN NEXT FIELD rupslk10 END IF
                    IF INFIELD(rupslk11) THEN NEXT FIELD rupslk11 END IF
                 
                 WHEN INFIELD(rupslk13) OR INFIELD(rupslk14) OR INFIELD(rupslk15)
                    CALL q_img42(FALSE,TRUE,g_rupslk[l_ac2].rupslk03,g_rupslk[l_ac2].rupslk13,
                                g_rupslk[l_ac2].rupslk14,g_rupslk[l_ac2].rupslk15,"A",g_rupslk[l_ac2].rupslk05,
                                g_ruo.ruo05)  
                    RETURNING g_rupslk[l_ac2].rupslk13,g_rupslk[l_ac2].rupslk14,g_rupslk[l_ac2].rupslk15
                    IF cl_null(g_rupslk[l_ac2].rupslk13) THEN LET g_rupslk[l_ac2].rupslk13 = ' ' END IF 
                    IF cl_null(g_rupslk[l_ac2].rupslk14) THEN LET g_rupslk[l_ac2].rupslk14 = ' ' END IF 
                    IF cl_null(g_rupslk[l_ac2].rupslk15) THEN LET g_rupslk[l_ac2].rupslk15 = ' ' END IF 
                    DISPLAY g_rupslk[l_ac2].rupslk13 TO rupslk13
                    DISPLAY g_rupslk[l_ac2].rupslk14 TO rupslk14
                    DISPLAY g_rupslk[l_ac2].rupslk15 TO rupslk15                 
                    IF INFIELD(rupslk13) THEN NEXT FIELD rupslk13 END IF
                    IF INFIELD(rupslk14) THEN NEXT FIELD rupslk14 END IF
                    IF INFIELD(rupslk15) THEN NEXT FIELD rupslk15 END IF
                   OTHERWISE EXIT CASE
                 END CASE

         ON ACTION q_imd    #查詢倉庫
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_imd_t256_1"
            CASE l_warehouse
               WHEN "1"
                    LET g_qryparam.default1 = g_rupslk[l_ac2].rupslk09
                    LET g_qryparam.arg1 = 'S,W'        #倉庫類別  
                    LET g_qryparam.arg2 = g_ruo.ruo04
                    CALL cl_create_qry() RETURNING g_rupslk[l_ac2].rupslk09
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk09
                    IF NOT cl_null(g_rupslk[l_ac2].rupslk09) THEN
                      CALL t256_check_out_store()
                      IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_rupslk[l_ac2].rupslk09,g_errno,0)
                        NEXT FIELD rupslk09
                      END IF
                      CALL chk_store()
                      IF NOT cl_null(g_errno) THEN
                         IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                         CALL cl_err('',g_errno, 0)
                         NEXT FIELD rupslk09
                      ELSE
                         CALL cl_err('',g_errno,0)
                         NEXT FIELD rupslk13
                         END IF
                      END IF
                    END IF
                    IF g_rupslk[l_ac2].rupslk09 <> g_rupslk_o.rupslk09
                       OR g_rupslk[l_ac2].rupslk10 <> g_rupslk_o.rupslk10           
                       OR g_rupslk[l_ac2].rupslk11 <> g_rupslk_o.rupslk11 THEN     
                      CALL t256_check_img10()                          
                     #TQC-C20039 add START
                     #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
                    #FUN-D30024 ----------Begin-----------
                     #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107  #FUN-D30024
                     #IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                      INITIALIZE g_imd23 TO NULL 
                      CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                      IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
                    #FUN-D30024 ----------End-------------
                         CALL cl_err('','mfg3471',0)
                         NEXT FIELD rupslk09
                      END IF 
                     #TQC-C20039 add END
                      IF NOT cl_null(g_errno) THEN                     
                         NEXT FIELD rupslk09                             
                      ELSE                                             
                         LET g_rupslk_o.rupslk09 = g_rupslk[l_ac2].rupslk09         
                         LET g_rupslk[l_ac2].rupslk10 = ''                    
                         LET g_rupslk[l_ac2].rupslk11 = ''                   
                         LET g_rupslk_o.rupslk10 = g_rupslk[l_ac2].rupslk10         
                         LET g_rupslk_o.rupslk11 = g_rupslk[l_ac2].rupslk11         
                      END IF                                           
                    END IF
                   #FUN-C80095  mark begin---
                   # SELECT imd02 INTO g_rupslk[l_ac2].rupslk09_desc           
                   #           FROM imd_file WHERE imd01 = g_rupslk[l_ac2].rupslk09 
                   #FUN-C80095  mark end ---
                    CALL t256_sel_imd02slk_rup09()     #FUN-C80095 add
                    NEXT FIELD rupslk12
               WHEN "2"
                   #TQC-CB0020--mark--str
                   #LET g_qryparam.default1 = g_rupslk[l_ac2].rupslk13
                   #LET g_qryparam.arg1 = 'S,W'        #倉庫類別  
                   #LET g_qryparam.arg2 = g_ruo.ruo05
                   #CALL cl_create_qry() RETURNING g_rupslk[l_ac2].rupslk13
                   #TQC-CB0020--mark--end
                   #TQC-CB0020--add--str
                    CALL q_imd1('FALSE','TRUE',g_rupslk[l_ac].rupslk13,'*',g_ruo.ruo05)
                    RETURNING g_rupslk[l_ac].rupslk13
                   #TQC-CB0020--add--end
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk13
                    CALL chk_store()
                    IF NOT cl_null(g_errno) THEN
                       IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                          CALL cl_err('',g_errno, 0)
                          NEXT FIELD rupslk09
                       ELSE
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD rupslk13
                       END IF
                    END IF
                   #FUN-C80095  mark begin---
                   # SELECT imd02 INTO g_rupslk[l_ac2].rupslk13_desc           
                   #           FROM imd_file WHERE imd01 = g_rupslk[l_ac2].rupslk13     
                   #FUN-C80095  mark end ---
                    CALL t256_sel_imd02slk_rup13()     #FUN-C80095 add
                    NEXT FIELD rupslk14
               OTHERWISE
                    LET g_qryparam.arg1 = 'S,W'        #倉庫類別  
                    CALL cl_create_qry() RETURNING g_msg
               END CASE
         ON ACTION q_ime    #查詢倉庫儲位
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ime_t256_1"
            CASE l_warehouse
               WHEN "1"       
                    LET g_qryparam.arg1 = g_rupslk[l_ac2].rupslk09
                    LET g_qryparam.default1 = g_rupslk[l_ac2].rupslk10
                    LET g_qryparam.default2 = g_rupslk[l_ac2].rupslk11
                    CALL cl_create_qry() RETURNING g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk10,g_rupslk[l_ac2].rupslk11
                    IF NOT cl_null(g_rupslk[l_ac2].rupslk09) THEN
                       CALL t256_check_out_store()
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_rupslk[l_ac2].rupslk09,g_errno,0)
                          NEXT FIELD rupslk09
                       END IF
                       CALL chk_store()
                       IF NOT cl_null(g_errno) THEN
                          IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                             CALL cl_err('',g_errno, 0)
                             NEXT FIELD rupslk09
                          ELSE
                             CALL cl_err('',g_errno,0)
                             NEXT FIELD rupslk13
                          END IF
                      END IF
                   END IF
                   IF g_rupslk[l_ac2].rupslk10 <> g_rupslk_o.rupslk10
                      OR g_rupslk[l_ac2].rupslk11 <> g_rupslk_o.rupslk11
                      OR g_rupslk[l_ac2].rupslk09 <> g_rupslk_o.rupslk09  
                      OR (NOT cl_null(g_rupslk_o.rupslk10) AND g_rupslk[l_ac2].rupslk10 IS NULL)
                      OR (NOT cl_null(g_rupslk_o.rupslk11) AND g_rupslk[l_ac2].rupslk11 IS NULL)
                      OR (NOT cl_null(g_rupslk[l_ac2].rupslk10) AND cl_null(g_rupslk_o.rupslk10))
                      OR (NOT cl_null(g_rupslk[l_ac2].rupslk11) AND cl_null(g_rupslk_o.rupslk11))THEN
                      LET g_act = 'rupslk12'
                      CALL t256_check_img10()
                     #TQC-C20039 add START
                     #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
                   #FUN-D30024 ----------Begin-----------
                   #  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                   #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
                   #  IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                      INITIALIZE g_imd23 TO NULL
                      CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                      IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
                   #FUN-D30024 ----------End-------------
                         CALL cl_err('','mfg3471',0)
                         CASE g_yes
                            WHEN 'rupslk09'
                              NEXT FIELD rupslk09
                            WHEN'rupslk10'
                              NEXT FIELD rupslk10
                            WHEN'rupslk11'
                              NEXT FIELD rupslk11
                         END CASE
                         LET g_yes = ''
                      END IF 
                     #TQC-C20039 add END
                      IF NOT cl_null(g_errno) THEN
                         CASE g_yes
                            WHEN 'rupslk09'
                              NEXT FIELD rupslk09
                            WHEN'rupslk10'
                              NEXT FIELD rupslk10
                            WHEN'rupslk11'
                              NEXT FIELD rupslk11
                         END CASE
                         LET g_yes = ''
                      ELSE
                         LET g_rupslk_o.rupslk09 = g_rupslk[l_ac2].rupslk09
                         LET g_rupslk_o.rupslk10 = g_rupslk[l_ac2].rupslk10
                         LET g_rupslk_o.rupslk11 = g_rupslk[l_ac2].rupslk11
                      END IF
                    END IF
                    NEXT FIELD rupslk12
               WHEN "2"         
                    LET g_qryparam.arg1 = g_rupslk[l_ac2].rupslk12  
                    CALL cl_create_qry() RETURNING g_rupslk[l_ac2].rupslk14,g_rupslk[l_ac2].rupslk15
                    DISPLAY BY NAME g_rupslk[l_ac2].rupslk14,g_rupslk[l_ac2].rupslk15
                    CALL chk_store()
                    IF NOT cl_null(g_errno) THEN
                       IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                          CALL cl_err('',g_errno, 0)
                          NEXT FIELD rupslk09
                       ELSE
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD rupslk13
                       END IF
                   END IF
                    NEXT FIELD rupslk14
               OTHERWISE
                    CALL cl_create_qry() RETURNING g_msg,g_msg
            END CASE

         END INPUT
         INPUT ARRAY g_imx FROM s_imx.*
                ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
             BEFORE INPUT
                 LET li_a=TRUE                     #FUN-C60100 add
                 IF g_rec_b3 != 0 THEN 
                    CALL fgl_set_arr_curr(l_ac3)
                 END IF
                 CALL cl_set_comp_required('color',TRUE)

             BEFORE ROW 
                LET p_cmd3 = ''
                LET l_ac3 = ARR_CURR()
                INITIALIZE g_imx_t.* TO NULL

                BEGIN WORK
 
                OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
                IF STATUS THEN
                   CALL cl_err("OPEN t256_cl:", STATUS, 1)
                   CLOSE t256_cl
                   ROLLBACK WORK
                   RETURN
                END IF
                FETCH t256_cl INTO g_ruo.*               # 對DB鎖定
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
                   CLOSE t256_cl
                   ROLLBACK WORK
                   RETURN
                END IF

                IF g_rec_b3 >= l_ac3 THEN
                   LET p_cmd3='u'
                   LET g_imx_t.* = g_imx[l_ac3].*  
                   LET l_lock_sw = 'N'           
                END IF
              
              BEFORE INSERT
                LET p_cmd3='a'
                LET l_ac3 = ARR_CURR()
                INITIALIZE g_imx_t.* TO NULL

              AFTER FIELD color          
                 IF NOT cl_null(g_imx[l_ac3].color) THEN
                    IF NOT t256_check_color() THEN
                       LET g_imx[l_ac3].color=g_imx_t.color
                       NEXT FIELD color
                    END IF
                #TQC-C20348--add--begin--
                    IF p_cmd3 ='a' OR (g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL) THEN
                       IF NOT s_chk_color_strategy(l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].color = g_imx_t.color
                          NEXT FIELD color
                       END IF
                    END IF
                 #TQC-C20348--add--end--
                    IF g_imx[l_ac3].color !=g_imx_t.color AND g_imx_t.color IS NOT NULL THEN
                       CALL s_updcolor_slk(l_ac3,g_rupslk[l_ac2].rupslk03,
                                        g_ruo.ruo01,g_rupslk[l_ac2].rupslk02) 
                    END IF
                 END IF             
 
              AFTER FIELD imx01
                 IF NOT cl_null(g_imx[l_ac3].imx01) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx01 !=g_imx_t.imx01 AND g_imx_t.imx01 IS NOT NULL) THEN
                       IF NOT t256_check_imx(1,g_imx[l_ac3].imx01,g_imx_t.imx01) THEN
                          LET g_imx[l_ac3].imx01 = g_imx_t.imx01 
                          NEXT FIELD imx01
                       END IF
                       IF NOT t256_check_ima(1,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx01 = g_imx_t.imx01 
                          NEXT FIELD imx01
                       END IF      
                    #TQC-C20490--add--begin-- 
                       IF NOT t256_chk_imx(l_ac3,1,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx01) THEN
                          LET g_imx[l_ac3].imx01 = g_imx_t.imx01
                          NEXT FIELD imx01
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,1,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx01) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx01 = g_imx_t.imx01
                          NEXT FIELD imx01
                       END IF
                    #TQC-C20348--add--end-- 
                    END IF
                 END IF
              AFTER FIELD imx02
                 IF NOT cl_null(g_imx[l_ac3].imx02) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx02 !=g_imx_t.imx02 AND g_imx_t.imx02 IS NOT NULL) THEN
                       IF NOT t256_check_imx(2,g_imx[l_ac3].imx02,g_imx_t.imx02) THEN
                          LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                          NEXT FIELD imx02
                       END IF
                       IF NOT t256_check_ima(2,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                          NEXT FIELD imx02
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,2,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx02) THEN
                          LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                          NEXT FIELD imx02
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,2,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx02) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx02 = g_imx_t.imx02
                          NEXT FIELD imx02
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF
              AFTER FIELD imx03
                 IF NOT cl_null(g_imx[l_ac3].imx03) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx03 !=g_imx_t.imx03 AND g_imx_t.imx03 IS NOT NULL) THEN
                       IF NOT t256_check_imx(3,g_imx[l_ac3].imx03,g_imx_t.imx03) THEN
                          LET g_imx[l_ac3].imx03 = g_imx_t.imx03  
                          NEXT FIELD imx03
                       END IF
                       IF NOT t256_check_ima(3,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx03 = g_imx_t.imx03 
                          NEXT FIELD imx03
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,3,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx03) THEN
                          LET g_imx[l_ac3].imx03 = g_imx_t.imx03
                          NEXT FIELD imx03
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,3,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx03) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx03 = g_imx_t.imx03
                          NEXT FIELD imx03
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF 
              AFTER FIELD imx04
                 IF NOT cl_null(g_imx[l_ac3].imx04) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx04 !=g_imx_t.imx04 AND g_imx_t.imx04 IS NOT NULL) THEN
                        IF NOT t256_check_imx(4,g_imx[l_ac3].imx04,g_imx_t.imx04) THEN
                           LET g_imx[l_ac3].imx04 = g_imx_t.imx04 
                           NEXT FIELD imx04
                        END IF
                       IF NOT t256_check_ima(4,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx04 = g_imx_t.imx04 
                          NEXT FIELD imx04
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,4,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx04) THEN
                          LET g_imx[l_ac3].imx04 = g_imx_t.imx04
                          NEXT FIELD imx04
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,4,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx04) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx04 = g_imx_t.imx04
                          NEXT FIELD imx04
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF  
              AFTER FIELD imx05
                 IF NOT cl_null(g_imx[l_ac3].imx05) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx05 !=g_imx_t.imx05 AND g_imx_t.imx05 IS NOT NULL) THEN
                       IF NOT t256_check_imx(5,g_imx[l_ac3].imx05,g_imx_t.imx05) THEN
                          LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                          NEXT FIELD imx05
                       END IF
                       IF NOT t256_check_ima(5,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx05 = g_imx_t.imx05 
                          NEXT FIELD imx05
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,5,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx05) THEN
                          LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                          NEXT FIELD imx05
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,5,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx05) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx05 = g_imx_t.imx05
                          NEXT FIELD imx05
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF   
              AFTER FIELD imx06
                 IF NOT cl_null(g_imx[l_ac3].imx06) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx06 !=g_imx_t.imx06 AND g_imx_t.imx06 IS NOT NULL) THEN
                       IF NOT t256_check_imx(6,g_imx[l_ac3].imx06,g_imx_t.imx06) THEN
                          LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                          NEXT FIELD imx06
                       END IF
                       IF NOT t256_check_ima(6,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx06 = g_imx_t.imx06 
                          NEXT FIELD imx06
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,6,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx06) THEN
                          LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                          NEXT FIELD imx06
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,6,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx06) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx06 = g_imx_t.imx06
                          NEXT FIELD imx06
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF  
              AFTER FIELD imx07
                 IF NOT cl_null(g_imx[l_ac3].imx07) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx07 !=g_imx_t.imx07 AND g_imx_t.imx07 IS NOT NULL) THEN
                       IF NOT t256_check_imx(7,g_imx[l_ac3].imx07,g_imx_t.imx07) THEN
                          LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                          NEXT FIELD imx07
                       END IF
                       IF NOT t256_check_ima(7,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx07 = g_imx_t.imx07 
                          NEXT FIELD imx07
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,7,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx07) THEN
                          LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                          NEXT FIELD imx07
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,7,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx07) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx07 = g_imx_t.imx07
                          NEXT FIELD imx07
                       END IF
                    #TQC-C20348--add--end--
                    END IF 
                 END IF
              AFTER FIELD imx08
                 IF NOT cl_null(g_imx[l_ac3].imx08) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx08 !=g_imx_t.imx08 AND g_imx_t.imx08 IS NOT NULL) THEN
                       IF NOT t256_check_imx(8,g_imx[l_ac3].imx08,g_imx_t.imx08) THEN
                          LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                          NEXT FIELD imx08
                       END IF
                       IF NOT t256_check_ima(8,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx08 = g_imx_t.imx08 
                          NEXT FIELD imx08
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,8,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx08) THEN
                          LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                          NEXT FIELD imx08
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,8,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx08) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx08 = g_imx_t.imx08
                          NEXT FIELD imx08
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF 
              AFTER FIELD imx09
                 IF NOT cl_null(g_imx[l_ac3].imx09) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx09 !=g_imx_t.imx09 AND g_imx_t.imx09 IS NOT NULL) THEN
                       IF NOT t256_check_imx(9,g_imx[l_ac3].imx09,g_imx_t.imx09) THEN
                          LET g_imx[l_ac3].imx09 = g_imx_t.imx09 
                          NEXT FIELD imx09
                       END IF
                       IF NOT t256_check_ima(9,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx09 = g_imx_t.imx09 
                          NEXT FIELD imx09
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,9,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx09) THEN
                          LET g_imx[l_ac3].imx09 = g_imx_t.imx09
                          NEXT FIELD imx09
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,9,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx09) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx09 = g_imx_t.imx09
                          NEXT FIELD imx09
                       END IF
                    #TQC-C20348--add--end-- 
                    END IF
                 END IF   
              AFTER FIELD imx10
                 IF NOT cl_null(g_imx[l_ac3].imx10) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx10 !=g_imx_t.imx10 AND g_imx_t.imx10 IS NOT NULL) THEN
                       IF NOT t256_check_imx(10,g_imx[l_ac3].imx10,g_imx_t.imx10) THEN
                          LET g_imx[l_ac3].imx10 = g_imx_t.imx10 
                          NEXT FIELD imx10
                       END IF
                       IF NOT t256_check_ima(10,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx10 = g_imx_t.imx10 
                          NEXT FIELD imx10
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,10,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx10) THEN
                          LET g_imx[l_ac3].imx10 = g_imx_t.imx10
                          NEXT FIELD imx10
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,10,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx10) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx10 = g_imx_t.imx10
                          NEXT FIELD imx10
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF       
              AFTER FIELD imx11
                 IF NOT cl_null(g_imx[l_ac3].imx11) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx11 !=g_imx_t.imx11 AND g_imx_t.imx11 IS NOT NULL) THEN
                       IF NOT t256_check_imx(11,g_imx[l_ac3].imx11,g_imx_t.imx11) THEN
                          LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                          NEXT FIELD imx11
                       END IF
                       IF NOT t256_check_ima(11,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx11 = g_imx_t.imx11 
                          NEXT FIELD imx11
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,11,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx11) THEN
                          LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                          NEXT FIELD imx11
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,11,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx11) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx11 = g_imx_t.imx11
                          NEXT FIELD imx11
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF
              AFTER FIELD imx12
                 IF NOT cl_null(g_imx[l_ac3].imx12) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx12 !=g_imx_t.imx12 AND g_imx_t.imx12 IS NOT NULL) THEN
                       IF NOT t256_check_imx(12,g_imx[l_ac3].imx12,g_imx_t.imx12) THEN
                          LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                          NEXT FIELD imx12
                       END IF
                       IF NOT t256_check_ima(12,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx12 = g_imx_t.imx12 
                          NEXT FIELD imx12
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,12,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx12) THEN
                          LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                          NEXT FIELD imx12
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,12,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx12) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx12 = g_imx_t.imx12
                          NEXT FIELD imx12
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF
              AFTER FIELD imx13
                 IF NOT cl_null(g_imx[l_ac3].imx13) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx13 !=g_imx_t.imx13 AND g_imx_t.imx13 IS NOT NULL) THEN
                       IF NOT t256_check_imx(13,g_imx[l_ac3].imx13,g_imx_t.imx13) THEN
                          LET g_imx[l_ac3].imx13 = g_imx_t.imx13 
                          NEXT FIELD imx13
                       END IF
                       IF NOT t256_check_ima(13,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx13 = g_imx_t.imx13 
                          NEXT FIELD imx13
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,13,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx13) THEN
                          LET g_imx[l_ac3].imx13 = g_imx_t.imx13
                          NEXT FIELD imx13
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,13,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx13) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx13 = g_imx_t.imx13
                          NEXT FIELD imx13
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF 
              AFTER FIELD imx14
                 IF NOT cl_null(g_imx[l_ac3].imx14) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx14 !=g_imx_t.imx14 AND g_imx_t.imx14 IS NOT NULL) THEN
                       IF NOT t256_check_imx(14,g_imx[l_ac3].imx14,g_imx_t.imx14) THEN
                          LET g_imx[l_ac3].imx14 = g_imx_t.imx14 
                          NEXT FIELD imx14
                       END IF
                       IF NOT t256_check_ima(14,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx14 = g_imx_t.imx14 
                          NEXT FIELD imx14
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,14,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx14) THEN
                          LET g_imx[l_ac3].imx14 = g_imx_t.imx14
                          NEXT FIELD imx14
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,14,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx14) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx14 = g_imx_t.imx14
                          NEXT FIELD imx14
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF  
              AFTER FIELD imx15
                 IF NOT cl_null(g_imx[l_ac3].imx15) THEN
                    IF p_cmd3='a' OR (g_imx[l_ac3].imx15 !=g_imx_t.imx15 AND g_imx_t.imx15 IS NOT NULL) THEN
                       IF NOT t256_check_imx(15,g_imx[l_ac3].imx15,g_imx_t.imx15) THEN
                          LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                          NEXT FIELD imx15
                       END IF
                       IF NOT t256_check_ima(15,l_ac3,g_rupslk[l_ac2].rupslk03) THEN
                          LET g_imx[l_ac3].imx15 = g_imx_t.imx15 
                          NEXT FIELD imx15
                       END IF
                    #TQC-C20490--add--begin--
                       IF NOT t256_chk_imx(l_ac3,15,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx15) THEN
                          LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                          NEXT FIELD imx15
                       END IF
                    #TQC-C20490--add--end--
                    #TQC-C20348--add--begin--
                       CALL s_chk_prod_strategy(l_ac3,15,g_rupslk[l_ac2].rupslk03,g_imx[l_ac3].imx15) RETURNING l_error,l_ima01
                       IF NOT cl_null(l_error) THEN   #檢查商品策略
                          CALL cl_err(l_ima01,l_error,0)
                          LET g_imx[l_ac3].imx15 = g_imx_t.imx15
                          NEXT FIELD imx15
                       END IF
                    #TQC-C20348--add--end--
                    END IF
                 END IF   

              BEFORE DELETE
                IF NOT cl_null(g_imx_t.color) THEN    #TQC-C20348 add 
                   IF NOT cl_delb(0,0) THEN
                      CANCEL DELETE
                   END IF
                   CALL s_ins_slk('r',l_ac3,g_rupslk[l_ac2].rupslk03,
                                  g_ruo.ruo01,g_rupslk[l_ac2].rupslk02)  
                   LET g_rec_b3=g_rec_b3-1
                   CALL t256_update_rupslk()
                   IF g_success = 'Y' THEN
                       COMMIT WORK
                   ELSE
                       ROLLBACK WORK
                   END IF
                END IF   #TQC-C20348 add

              AFTER INSERT
#MOD-C30217------add---begin-----------------
                 IF (g_imx[l_ac3].imx01 IS NULL OR g_imx[l_ac3].imx01 = 0) AND
                    (g_imx[l_ac3].imx02 IS NULL OR g_imx[l_ac3].imx02 = 0) AND
                    (g_imx[l_ac3].imx03 IS NULL OR g_imx[l_ac3].imx03 = 0) AND
                    (g_imx[l_ac3].imx04 IS NULL OR g_imx[l_ac3].imx04 = 0) AND
                    (g_imx[l_ac3].imx05 IS NULL OR g_imx[l_ac3].imx05 = 0) AND
                    (g_imx[l_ac3].imx06 IS NULL OR g_imx[l_ac3].imx06 = 0) AND
                    (g_imx[l_ac3].imx07 IS NULL OR g_imx[l_ac3].imx07 = 0) AND
                    (g_imx[l_ac3].imx08 IS NULL OR g_imx[l_ac3].imx08 = 0) AND
                    (g_imx[l_ac3].imx09 IS NULL OR g_imx[l_ac3].imx09 = 0) AND
                    (g_imx[l_ac3].imx10 IS NULL OR g_imx[l_ac3].imx10 = 0) AND
                    (g_imx[l_ac3].imx11 IS NULL OR g_imx[l_ac3].imx11 = 0) AND
                    (g_imx[l_ac3].imx12 IS NULL OR g_imx[l_ac3].imx12 = 0) AND
                    (g_imx[l_ac3].imx13 IS NULL OR g_imx[l_ac3].imx13 = 0) AND
                    (g_imx[l_ac3].imx14 IS NULL OR g_imx[l_ac3].imx14 = 0) AND
                    (g_imx[l_ac3].imx15 IS NULL OR g_imx[l_ac3].imx15 = 0)
                 THEN
                    CANCEL INSERT
                 END IF
#MOD-C30217------end-------------------------
                 CALL t256_rupslk_move() 
                 CALL s_ins_slk('a',l_ac3,g_rupslk[l_ac2].rupslk03,
                               g_ruo.ruo01,g_rupslk[l_ac2].rupslk02)
                 LET g_rec_b3=g_rec_b3+1
                 CALL t256_update_rupslk()
                 IF g_success = 'Y' THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK
                 END IF

              ON ROW CHANGE 
                 CALL t256_rupslk_move()
                 CALL s_ins_slk('u',l_ac3,g_rupslk[l_ac2].rupslk03,
                               g_ruo.ruo01,g_rupslk[l_ac2].rupslk02)
                 CALL t256_update_rupslk()
                 IF g_success = 'Y' THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK
                 END IF
                 
              AFTER ROW
                 IF g_success = 'Y' THEN
                    COMMIT WORK
                 ELSE
      	         ROLLBACK WORK 
                 END IF
                 CLOSE t256_cl

              AFTER INPUT 
                 IF INT_FLAG THEN                         # 若按了DEL鍵
                    LET INT_FLAG = 0
                    EXIT DIALOG
                 END IF

          END INPUT  
          ON ACTION CONTROLF
             CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name
             CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

          ON ACTION CONTROLR
             CALL cl_show_req_fields()

          ON ACTION CONTROLG
             CALL cl_cmdask()

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG

          ON ACTION about
             CALL cl_about()

          ON ACTION HELP
             CALL cl_show_help()

          ON ACTION controls
             CALL cl_set_head_visible("","AUTO")

          ON ACTION ACCEPT
             ACCEPT DIALOG

          ON ACTION CANCEL
             EXIT DIALOG
    
          ON ACTION controlb    #設置快捷鍵，用於“款號單身”與“多屬性單身”之間的切換
             SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_rupslk[l_ac2].rupslk03
             IF l_ima151 = 'Y' THEN
                IF li_a THEN
#                   LET li_a = FALSE      #FUN-C60100 mark
                   NEXT FIELD rupslk02
                ELSE
#                   LET li_a = TRUE       #FUN-C60100 mark

                   NEXT FIELD color
                END IF
             END IF
          END DIALOG 
       ELSE   
#FUN-B90101--add--end-- 
          INPUT ARRAY g_rup WITHOUT DEFAULTS FROM s_rup.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                          APPEND ROW=l_allow_insert)
 
              BEFORE INPUT
                 DISPLAY "BEFORE INPUT!"
                 IF g_rec_b != 0 THEN
                    CALL fgl_set_arr_curr(l_ac)
                 END IF
                 CALL cl_set_comp_entry("rup02,rup03,rup06,rup07,                                                       
                            rup09,rup10,rup11,rup12",TRUE)
                 CALL cl_set_comp_entry("rup16",FALSE)

              BEFORE ROW
                 DISPLAY "BEFORE ROW!"
                 LET p_cmd = ''
                 LET l_ac = ARR_CURR()
                 LET l_lock_sw = 'N'            #DEFAULT
                 LET l_n  = ARR_COUNT()
 
                 BEGIN WORK
 
                 OPEN t256_cl USING g_ruo.ruo01,g_ruo.ruoplant
                 IF STATUS THEN
                    CALL cl_err("OPEN t256_cl:", STATUS, 1)
                    CLOSE t256_cl
                    ROLLBACK WORK
                    RETURN
                 END IF
 
                 FETCH t256_cl INTO g_ruo.*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ruo.ruo01,SQLCA.sqlcode,0)
                    CLOSE t256_cl
                    ROLLBACK WORK
                    RETURN
                 END IF
 
                 IF g_rec_b >= l_ac THEN
                    LET p_cmd='u'
                    LET g_rup_t.* = g_rup[l_ac].*  #BACKUP
                    LET g_rup_o.* = g_rup[l_ac].*  #BACKUP
                    LET g_rup07_t = g_rup[l_ac].rup07    #FUN-910088--add--
                    OPEN t256_bcl USING g_ruo.ruo01,g_ruo.ruoplant,g_rup_t.rup02
                    IF STATUS THEN
                       CALL cl_err("OPEN t256_bcl:", STATUS, 1)
                       LET l_lock_sw = "Y"
                    ELSE
                       FETCH t256_bcl INTO g_rup[l_ac].*
                       IF SQLCA.sqlcode THEN
                          CALL cl_err(g_rup_t.rup02,SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                       END IF
                       CALL t256_get_desc() 
                    END IF
                    #在撥出審核狀態下，只能維護撥入倉庫、儲位、批號、數量
                    IF g_ruo.ruoconf = '1' THEN
                       CALL cl_set_comp_entry("rup02,rup03,rup06,rup07,
                            rup08,rup09,rup10,rup11,rup12,rup16",FALSE)
                       #IF g_ruo.ruo05 = g_plant AND g_ruo.ruopos <> 'P' THEN
                       IF g_ruo.ruo05 = g_plant THEN  #TQC-AC0382
                          CALL cl_set_comp_entry("rup16",TRUE)
                       END IF 
                    ELSE
                       CALL cl_set_comp_entry("rup02,rup03,rup06,rup07,
                            rup09,rup10,rup11,rup12",TRUE)        #MOD-CC0056 add
                           #rup08,rup09,rup10,rup11,rup12",TRUE)  #MOD-CC0056 mark
                    END IF
#FUN-AA0086--add---str---
                    IF g_ruo.ruoconf = '0' THEN
                       IF g_ruo.ruo02 = '5' THEN
                          CALL cl_set_comp_entry("rup02,rup03,rup06,rup07,rup08",FALSE)
                       ELSE
                          CALL cl_set_comp_entry("rup02,rup03,rup06,rup07",TRUE)        #MOD-CC0056 add
                         #CALL cl_set_comp_entry("rup02,rup03,rup06,rup07,rup08",TRUE)  #MOD-CC0056 mark
                       END IF
                    END IF
#FUN-AA0086--add---end--
                   #FUN-CA0086 Begin---
                    IF g_argv2 = '2' AND g_ruo.ruoconf = '0' THEN
                       IF NOT cl_null(g_ruo.ruo03) THEN
                          CALL cl_set_comp_entry("rup17",TRUE)
                          CALL cl_set_comp_required("rup17",TRUE)
                          CALL cl_set_comp_entry("rup03,rup06,rup07",FALSE)
                       ELSE
                          CALL cl_set_comp_entry("rup17",FALSE)
                          CALL cl_set_comp_required("rup17",FALSE)
                       END IF
                    END IF
                   #FUN-CA0086 End-----
                 END IF 
           
           BEFORE INSERT
              DISPLAY "BEFORE INSERT!"
              LET l_n = ARR_COUNT()
              LET p_cmd='a'
              LET p_cmd2 = 'a'           #FUN-B80110 add
              INITIALIZE g_rup[l_ac].* TO NULL
              LET g_rup07_t = NULL       #FUN-910088--add--
              LET g_rup[l_ac].rup18 = 'N'   #FUN-AA0086結案否默認為N
              LET g_rup[l_ac].rup22 = g_ruo.ruo05            #FUN-CC0057
              IF g_argv2 <> '2' OR cl_null(g_ruo.ruo03) THEN #FUN-CA0086
                 LET g_rup[l_ac].rup17 = '0'                 #FUN-AA0086
              END IF                                         #FUN-CA0086
              #撥出倉庫帶默認值
           #FUN-BA0004 add START
              IF  g_sma.sma142 = 'Y' THEN   #啟用在途倉
                IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
                   CALL s_check(g_ruo.ruo14,g_ruo.ruo04) RETURNING l_flag_ruo14
                ELSE                         #調撥在途歸屬撥入方
                   CALL s_check(g_ruo.ruo14,g_ruo.ruo05) RETURNING l_flag_ruo14
                END IF

                IF l_flag_ruo14 THEN
                   #FUN-C90049 mark beign---
                   #SELECT rtz08 INTO g_rup[l_ac].rup09 FROM rtz_file
                   #   WHERE rtz01 = g_ruo.ruo04
                   #FUN-C90049 mark end-----
                   #CALL s_get_noncoststore(g_ruo.ruo04,g_rupslk[l_ac2].rupslk03) RETURNING g_rup[l_ac].rup09   #FUN-C90049 add    #FUN-CB0017 mark
                    CALL s_get_noncoststore(g_ruo.ruo04,g_rup[l_ac].rup03) RETURNING g_rup[l_ac].rup09          #FUN-CB0017 add
                ELSE
                   #FUN-C90049 mark begin----
                   #SELECT rtz07 INTO g_rup[l_ac].rup09 FROM rtz_file
                   #   WHERE rtz01 = g_ruo.ruo04
                   #FUN-C90049 mark end-----
                   #CALL s_get_coststore(g_ruo.ruo04,g_rupslk[l_ac2].rupslk03) RETURNING g_rup[l_ac].rup09      #FUN-C90049 add    #FUN-CB0017 mark
                   #CALL s_get_coststore(g_ruo.ruo04,g_rup[l_ac].rup03) RETURNING g_rup[l_ac].rup09             #FUN-CB0017 add
                END IF
              ELSE
           #FUN-BA0004 add END
                 #FUN-C90049 mark begin---
                 #SELECT rtz07 INTO g_rup[l_ac].rup09 FROM rtz_file
                 #   WHERE rtz01 = g_ruo.ruo04
                 #FUN-C90049 mark end-----
                 #CALL s_get_coststore(g_ruo.ruo04,g_rupslk[l_ac2].rupslk03) RETURNING g_rup[l_ac].rup09        #FUN-C90049 add    #FUN-CB0017 mark
                  CALL s_get_coststore(g_ruo.ruo04,g_rup[l_ac].rup03) RETURNING g_rup[l_ac].rup09               #FUN-CB0017 add
              END IF                                                          #FUN-BA0004 add
#FUN-AA0086--add--str---
             IF cl_null(g_rup[l_ac].rup09) THEN
                SELECT imd01 INTO g_rup[l_ac].rup09 FROM imd_file
                 WHERE imd10 = 'S' AND imd22 = 'Y' AND imd20 = g_ruo.ruo04
             END IF
#FUN-AA0086--add--str---
            #FUN-C80095 mark begin ---
            # SELECT imd02 INTO g_rup[l_ac].rup09_desc FROM imd_file
            #    WHERE imd01 = g_rup[l_ac].rup09
            #FUN-C80095 MARK END ---
             CALL t256_sel_imd02_rup09()      #FUN-C80095 add
             #撥入倉庫帶默認值
          #FUN-BA0004 add START
             IF  g_sma.sma142 = 'Y' THEN   #啟用在途倉
               IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
                  CALL s_check(g_ruo.ruo14,g_ruo.ruo04) RETURNING l_flag_ruo14
               ELSE                         #調撥在途歸屬撥入方
                  CALL s_check(g_ruo.ruo14,g_ruo.ruo05) RETURNING l_flag_ruo14
               END IF

               IF l_flag_ruo14 THEN
                  #FUN-C90049 mark begin---
                  #SELECT rtz08 INTO g_rup[l_ac].rup13 FROM rtz_file
                  #   WHERE rtz01 = g_ruo.ruo05
                  #FUN-C90049 mark end-----
                  #CALL s_get_noncoststore(g_ruo.ruo05,g_rupslk[l_ac2].rupslk03) RETURNING g_rup[l_ac].rup13   #FUN-C90049 add    #FUN-CB0017 mark
                  CALL s_get_noncoststore(g_ruo.ruo05,g_rup[l_ac].rup03) RETURNING g_rup[l_ac].rup13           #FUN-CB0017 add
               ELSE
                  #FUN-C90049 mark begin---
                  #SELECT rtz07 INTO g_rup[l_ac].rup13 FROM rtz_file
                  #   WHERE rtz01 = g_ruo.ruo05
                  #FUN-C90049 mark end------
                  #CALL s_get_coststore(g_ruo.ruo05,g_rupslk[l_ac2].rupslk03) RETURNING g_rup[l_ac].rup13      #FUN-C90049 add    #FUN-CB0017 mark
                  CALL s_get_coststore(g_ruo.ruo05,g_rup[l_ac].rup03) RETURNING g_rup[l_ac].rup13              #FUN-CB0017 add
               END IF
             ELSE
          #FUN-BA0004 add END
                #FUN-C90049 mark begin---
                #SELECT rtz07 INTO g_rup[l_ac].rup13 FROM rtz_file 
                #   WHERE rtz01 = g_ruo.ruo05
                #FUN-C90049 mark end------
                #CALL s_get_coststore(g_ruo.ruo05,g_rupslk[l_ac2].rupslk03) RETURNING g_rup[l_ac].rup13         #FUN-C90049 add   #FUN-CB0017 mark
                #CALL s_get_coststore(g_ruo.ruo05,g_rup[l_ac].rup03) RETURNING g_rup[l_ac].rup13                #FUN-CB0017 add
             END IF                                                          #FUN-BA0004 add
#FUN-AA0086--add--str---
             IF cl_null(g_rup[l_ac].rup13) THEN
                SELECT imd01 INTO g_rup[l_ac].rup13 FROM imd_file
                 WHERE imd10 = 'S' AND imd22 = 'Y' AND imd20 = g_ruo.ruo05
             END IF
#FUN-AA0086--add--str---
            #FUN-C80095 mark begin ---
            # SELECT imd02 INTO g_rup[l_ac].rup13_desc FROM imd_file 
            #    WHERE imd01 = g_rup[l_ac].rup13
            #FUN-C80095 MARK END ---
             CALL t256_sel_imd02_rup13()      #FUN-C80095 add 
             LET g_rup_t.* = g_rup[l_ac].*
             LET g_rup_o.* = g_rup[l_ac].*
            #FUN-CA0086 Begin---
             IF g_argv2 = '2' THEN
                IF NOT cl_null(g_ruo.ruo03) THEN
                   CALL cl_set_comp_entry("rup17",TRUE)
                   CALL cl_set_comp_required("rup17",TRUE)
                   CALL cl_set_comp_entry("rup03,rup06,rup07",FALSE)
                ELSE
                   CALL cl_set_comp_entry("rup17",FALSE)
                   CALL cl_set_comp_required("rup17",FALSE)
                END IF
             END IF
            #FUN-CA0086 End-----
             CALL cl_show_fld_cont()
             NEXT FIELD rup02
 
          AFTER INSERT
             DISPLAY "AFTER INSERT!"
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CANCEL INSERT
             END IF
    #FUN-BA0004 add START
             CALL chk_store()
             IF NOT cl_null(g_errno) THEN
                IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                   CALL cl_err('',g_errno, 0)
                   NEXT FIELD rup09
                ELSE
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rup13
                END IF    
             END IF
    #FUN-BA0004 add END
           
             IF cl_null(g_rup[l_ac].rup11) THEN LET g_rup[l_ac].rup11 = ' ' END IF #FUN-CA0086
             IF cl_null(g_rup[l_ac].rup15) THEN LET g_rup[l_ac].rup15 = ' ' END IF #FUN-CA0086
             INSERT INTO rup_file (rup01,rup02,rup03,rup04,rup05,rup06,rup07,rup08,rup09,rup10,rup11,rup12,rup13,
                                  rup14,rup15,rup16,rup17,rup18,rup19,rup22,rupplant,ruplegal)        #FUN-CC0057 add rup22
                                  VALUES(g_ruo.ruo01,g_rup[l_ac].rup02,g_rup[l_ac].rup03,
                                         g_rup[l_ac].rup04,g_rup[l_ac].rup05,g_rup[l_ac].rup06,
                                         g_rup[l_ac].rup07,g_rup[l_ac].rup08,g_rup[l_ac].rup09,
                                         g_rup[l_ac].rup10,g_rup[l_ac].rup11,g_rup[l_ac].rup12,
                                         g_rup[l_ac].rup13,g_rup[l_ac].rup14,g_rup[l_ac].rup15,
                                         g_rup[l_ac].rup16,
                                         g_rup[l_ac].rup17,g_rup[l_ac].rup18,
                                         g_rup[l_ac].rup19,g_rup[l_ac].rup22,g_ruo.ruoplant,g_ruo.ruolegal)#FUN-AA0086 add 17 18 19      #FUN-CC0057 add rup22
                   
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("ins","rup_file",g_ruo.ruo01,g_rup[l_ac].rup02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
 
          BEFORE FIELD rup02
             IF g_rup[l_ac].rup02 IS NULL OR g_rup[l_ac].rup02 = 0 THEN
                SELECT max(rup02)+1
                  INTO g_rup[l_ac].rup02
                  FROM rup_file
                 WHERE rup01 = g_ruo.ruo01 
                   AND rupplant = g_ruo.ruoplant 
                IF g_rup[l_ac].rup02 IS NULL OR g_rup[l_ac].rup02 = 0 THEN
                   LET g_rup[l_ac].rup02 = 1
                END IF
             END IF
 
          AFTER FIELD rup02
             IF NOT cl_null(g_rup[l_ac].rup02) THEN
                IF g_rup[l_ac].rup02 != g_rup_t.rup02
                   OR g_rup_t.rup02 IS NULL THEN
                   SELECT count(*)
                     INTO l_n
                     FROM rup_file
                    WHERE rup01 = g_ruo.ruo01
                      AND rup02 = g_rup[l_ac].rup02
                      AND rupplant = g_ruo.ruoplant 
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_rup[l_ac].rup02 = g_rup_t.rup02
                      NEXT FIELD rup02
                   END IF
                END IF
             END IF

         #FUN-CA0086 Begin---
          AFTER FIELD rup17
             IF NOT cl_null(g_rup[l_ac].rup17) AND g_argv2 = '2' THEN
                IF g_rup[l_ac].rup17 != g_rup_t.rup17 OR g_rup_t.rup17 IS NULL THEN
                   LET g_cnt = 0
                   SELECT COUNT(*) INTO g_cnt FROM ruo_file,rup_file
                    WHERE ruo01 = rup01
                      AND rup01 = g_ruo.ruo01
                      AND rup17 = g_rup[l_ac].rup17
                   IF g_cnt > 0 THEN
                      CALL cl_err(g_rup[l_ac].rup17,'-239',0)
                      LET g_rup[l_ac].rup17 = g_rup_o.rup17
                      DISPLAY BY NAME g_rup[l_ac].rup17
                      NEXT FIELD rup17
                   END IF

                   CALL t256_rup17(p_cmd)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rup[l_ac].rup17,g_errno,0)
                      LET g_rup[l_ac].rup17 = g_rup_o.rup17
                      DISPLAY BY NAME g_rup[l_ac].rup17
                      NEXT FIELD rup17
                   END IF
                END IF
             END IF
         #FUN-CA0086 End-----

      BEFORE FIELD rup03
         IF g_rup[l_ac].rup06 IS NULL THEN
            CALL cl_set_comp_entry("rup03",TRUE)
         ELSE
     	    CALL cl_set_comp_entry("rup03",FALSE)
         END IF
         
      AFTER FIELD rup03
         IF NOT cl_null(g_rup[l_ac].rup03) THEN
#FUN-AB0021 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rup[l_ac].rup03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rup[l_ac].rup03= g_rup_t.rup03
               NEXT FIELD rup03
            END IF
#FUN-AB0021 ---------------------end-------------------------------
     #FUN-B90068 add START
            SELECT ima151 INTO l_ima151 FROM ima_file where ima01 = g_rup[l_ac].rup03
            IF l_ima151 = 'Y' THEN
               CALL cl_err('','art-865',0)
               NEXT FIELD rup03
            END IF
     #FUN-B90068 add END
            IF g_rup_o.rup03 IS NULL OR
               (g_rup[l_ac].rup03 != g_rup_o.rup03 ) THEN
               CALL t256_rup03()      
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rup[l_ac].rup03,g_errno,0)
                  LET g_rup[l_ac].rup03 = g_rup_o.rup03
                  DISPLAY BY NAME g_rup[l_ac].rup03
                  NEXT FIELD rup03
               END IF
               
               IF g_rup[l_ac].rup07 IS NOT NULL AND 
                  g_rup[l_ac].rup04 IS NOT NULL THEN 
                  LET l_flag = NULL
                  LET l_fac = NULL
                  CALL s_umfchk(g_rup[l_ac].rup03,g_rup[l_ac].rup07,
                                g_rup[l_ac].rup04)
                     RETURNING l_flag,l_fac
                  IF l_flag = 1 THEN
                     LET l_msg = g_rup[l_ac].rup07 CLIPPED,'->',
                                 g_rup[l_ac].rup04 CLIPPED
                     CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                     NEXT FIELD rup03
                  END IF
                  LET g_rup[l_ac].rup08 = l_fac  
               END IF 
               CALL t256_check_img10() 
              #TQC-C20039 add START
              #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
           #FUN-D30024 ------Begin-------
              #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
              #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107  #FUN-D30024
              #IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
               INITIALIZE g_imd23 TO NULL    
               CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                        #FUN-D30024 #TQC-D40078 g_ruo.ruo04
               IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
           #FUN-D30024 ------End---------
                  CALL cl_err('','mfg3471',0)
                  NEXT FIELD rup03
               END IF
              #TQC-C20039 add END
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rup03
               END IF   
               CALL t256_add_store(g_rup[l_ac].rup03,g_rup[l_ac].rup09,g_ruo.ruoplant
                                  ,g_rup[l_ac].rup10,g_rup[l_ac].rup11  #MOD-A80112 add
                                  )
            END IF  
         END IF 
         
        AFTER FIELD rup06
           IF NOT cl_null(g_rup[l_ac].rup06) THEN
#FUN-AB0021 ---------------------start----------------------------
#              IF NOT s_chk_item_no(g_rup[l_ac].rup06,"") THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_rup[l_ac].rup06= g_rup_t.rup06
#                 NEXT FIELD rup06
#              END IF
#FUN-AB0021 ---------------------end-------------------------------
              IF g_rup_o.rup06 IS NULL OR 
                 (g_rup[l_ac].rup06 != g_rup_o.rup06 ) THEN
                 CALL t256_rup03()      
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rup[l_ac].rup06,g_errno,0)
                    LET g_rup[l_ac].rup06 = g_rup_o.rup06
                    LET g_rup[l_ac].rup03 = g_rup_o.rup03
                    DISPLAY BY NAME g_rup[l_ac].rup06,g_rup[l_ac].rup03
                    NEXT FIELD rup06
                 END IF
              END IF
           END IF 

#FUN-AA0086---add---str---
       ON CHANGE rup06
           IF g_rup[l_ac].rup06 IS NULL THEN
              CALL cl_set_comp_entry("rup03",TRUE)
           ELSE
     	      CALL cl_set_comp_entry("rup03",FALSE)
           END IF
#FUN-AA0086---add---end---
           
        AFTER FIELD rup07
           IF NOT cl_null(g_rup[l_ac].rup07) THEN
              CALL t256_rup07()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rup[l_ac].rup07,g_errno,0)
                 LET g_rup[l_ac].rup07 = g_rup_o.rup07
                 DISPLAY BY NAME g_rup[l_ac].rup07
                 NEXT FIELD rup07
              END IF
              IF g_rup[l_ac].rup03 IS NOT NULL AND 
                 g_rup[l_ac].rup04 IS NOT NULL THEN
                 LET l_flag = NULL
                 LET l_fac = NULL
                 CALL s_umfchk(g_rup[l_ac].rup03,g_rup[l_ac].rup07,
                               g_rup[l_ac].rup04)
                    RETURNING l_flag,l_fac
                 IF l_flag = 1 THEN
                    LET l_msg = g_rup[l_ac].rup07 CLIPPED,'->',
                                g_rup[l_ac].rup04 CLIPPED
                    CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                    NEXT FIELD rup07
                 END IF
                 LET g_rup[l_ac].rup08 = l_fac 
              END IF 
           #FUN-910088--add--start--
              LET l_case = NULL
              CASE t256_rup12_check(p_cmd2)
                 WHEN "rup09"
                    LET l_case = "rup09"
                 WHEN "rup12"
                    LET l_case = "rup12"
                 WHEN "rup13"
                    LET l_case = "rup13"
                 OTHERWISE EXIT CASE
              END CASE
              LET g_rup07_t = g_rup[l_ac].rup07
              LET g_rup[l_ac].rup16 = s_digqty(g_rup[l_ac].rup16,g_rup[l_ac].rup07)    #TQC-C20183
              DISPLAY BY NAME g_rup[l_ac].rup16                                        #TQC-C20183
              CASE l_case
                 WHEN "rup09"
                    NEXT FIELD rup09     
                 WHEN "rup12"
                    NEXT FIELD rup12    
                 WHEN "rup13"
                    NEXT FIELD rup13    
                 OTHERWISE EXIT CASE
              END CASE
           #FUN-910088--add--end--
           END IF
        
        AFTER FIELD rup05
           IF NOT cl_null(g_rup[l_ac].rup05) THEN
              CALL t256_check_out_store()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rup[l_ac].rup05,g_errno,0)
                 NEXT FIELD rup05
              END IF
              #No.FUN-9B0157 mark begin
              #CALL t256_check_in_store()
              #IF NOT cl_null(g_errno) THEN
              #   CALL cl_err('',g_errno,0)
              #   NEXT FIELD rup13
              #END IF 
              #No.FUN-9B0157 mark end
           END IF
        BEFORE FIELD rup09                 #FUN-B80075 add
          LET l_warehouse = '1'            #FUN-B80075 add
          LET g_yes = 'rup09'              #FUN-B80075 add
 
        AFTER FIELD rup09   #撥出倉庫
           IF NOT cl_null(g_rup[l_ac].rup09) THEN
              CALL t256_rup09()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
                 LET g_rup[l_ac].rup09 = g_rup_o.rup09
                 DISPLAY BY NAME g_rup[l_ac].rup09
                 NEXT FIELD rup09
              END IF
#FUN-BA0004 add START
           CALL chk_store()
           IF NOT cl_null(g_errno) THEN
              IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                 CALL cl_err('',g_errno, 0)
                 NEXT FIELD rup09
              ELSE
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD rup13
              END IF
           END IF
#FUN-BA0004 add END 
              #檢查倉庫是否可用
              CALL s_swyn(g_rup[l_ac].rup09) RETURNING sn1,sn2
              IF sn1 != 0 THEN
                 CALL cl_err(g_rup[l_ac].rup09,'mfg6080',0)
                 NEXT FIELD rup09
              END IF
              SELECT COUNT(*) INTO g_cnt FROM img_file
                 WHERE img01 = g_rup[l_ac].rup03
                   AND img02 = g_rup[l_ac].rup09
#MOD-A80112 --begin--                   
#                   AND img03 = ' ' 
#                   AND img04 = ' '
                    AND img03 = g_rup[l_ac].rup10
                    AND img04 = g_rup[l_ac].rup11
#MOD-A80112 --end--
                   AND img18 < g_today
              IF g_cnt > 0 THEN        #檢查該料件儲批是否已經過期
                 CALL cl_err('','aim-400',0)
                 NEXT FIELD rup09
              END IF
              #檢查倉庫和經營方式是否匹配
              CALL t256_check_out_store()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
                 NEXT FIELD rup09
              END IF
           #   CALL t256_check_img10()               #FUN-B80075 mark 
           #   IF NOT cl_null(g_errno) THEN          #FUN-B80075 mark
           #       CALL cl_err('',g_errno,0)         #FUN-B80075 mark
           #       NEXT FIELD rup09                  #FUN-B80075 mark
           #   END IF                                #FUN-B80075 mark
       #FUN-B80075 add START
              IF
                g_rup[l_ac].rup09 <> g_rup_o.rup09            
                 OR g_rup[l_ac].rup10 <> g_rup_o.rup10          
                 OR g_rup[l_ac].rup11 <> g_rup_o.rup11         
                 OR (NOT cl_null(g_rup[l_ac].rup10) AND cl_null(g_rup_o.rup10))         
                 OR (NOT cl_null(g_rup[l_ac].rup11) AND cl_null(g_rup_o.rup11))THEN                    
                 CALL t256_check_img10()
              #TQC-C20039 add START
               # IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
              #FUN-D30024 ---------Begin---------
               # INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
               # CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
               # IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                         #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                 IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL)  THEN
              #FUN-D30024 ---------End-----------
                    CALL cl_err('','mfg3471',0)
                    NEXT FIELD rup09
                 END IF
              #TQC-C20039 add END
                 IF NOT cl_null(g_errno) THEN            
                    NEXT FIELD rup09
                 ELSE
                    LET g_rup_o.rup09 = g_rup[l_ac].rup09  
                    LET g_rup_o.rup10 = g_rup[l_ac].rup10   
                    LET g_rup_o.rup11 = g_rup[l_ac].rup11  
                 END IF
              END IF                                        
       #FUN-B80075 add END  

       #TQC-D50127 ------Begin---------
        ##FUN-D40103 --------Begin--------
        #     IF NOT s_imechk(g_rup[l_ac].rup09,g_rup[l_ac].rup10) THEN
        #        NEXT FIELD rup10
        #     END IF
        ##FUN-D40103 --------End----------
       #TQC-D50127 ------End----------

           END IF


#FUN-B80075 add START
        BEFORE FIELD rup10
          LET l_warehouse = '1'
          LET g_yes = 'rup10'
        AFTER FIELD rup10
          IF 
              (g_rup[l_ac].rup10 <> g_rup_o.rup10  
               OR (NOT cl_null(g_rup_o.rup10) AND g_rup[l_ac].rup10 IS NULL)
               OR (NOT cl_null(g_rup[l_ac].rup10) AND cl_null(g_rup_o.rup10))
               OR (NOT cl_null(g_rup[l_ac].rup11) AND cl_null(g_rup_o.rup11)))THEN
             CALL t256_check_img10()
             #TQC-C20039 add START
             #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
            #FUN-D30024 ----------Begin-----------
            # INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
            # CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024
            # IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
              INITIALIZE g_imd23 TO NULL
              CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                        #FUN-D30024 #TQC-D40078 g_ruo.ruo04
              IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN 
            #FUN-D30024 ----------End-------------
                 CALL cl_err('','mfg3471',0)
                 NEXT FIELD rup10
              END IF
             #TQC-C20039 add END
             IF NOT cl_null(g_errno) THEN
                NEXT FIELD rup10
             ELSE
                LET g_rup_o.rup09 = g_rup[l_ac].rup09
                LET g_rup_o.rup10 = g_rup[l_ac].rup10
                LET g_rup_o.rup11 = g_rup[l_ac].rup11
             END IF
          END IF

       #TQC-D50127 --------Begin---------
        ##FUN-D40103 --------Begin--------
        # IF NOT s_imechk(g_rup[l_ac].rup09,g_rup[l_ac].rup10) THEN
        #    NEXT FIELD rup10
        # END IF
        ##FUN-D40103 --------End----------
       #TQC-D50127 --------End-----------

        BEFORE FIELD rup11
          LET l_warehouse = '1'
          LET g_yes = 'rup11'

        AFTER FIELD rup11
          IF 
             (g_rup[l_ac].rup11 <> g_rup_o.rup11 
             OR (NOT cl_null(g_rup_o.rup11) AND g_rup[l_ac].rup11 IS NULL)
             OR (NOT cl_null(g_rup[l_ac].rup10) AND cl_null(g_rup_o.rup10))
             OR (NOT cl_null(g_rup[l_ac].rup11) AND cl_null(g_rup_o.rup11))) THEN
             CALL t256_check_img10()
             #TQC-C20039 add START
             #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
           #FUN-D30024 ----------Begin-----------
             #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107   #FUN-D30024
             #IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
              INITIALIZE g_imd23 TO NULL
              CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                        #FUN-D30024  #TQC-D40078 g_ruo.ruo04
              IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
           #FUN-D30024 ----------End-------------
                 CALL cl_err('','mfg3471',0)
                 NEXT FIELD rup11
              END IF
             #TQC-C20039 add END
             IF NOT cl_null(g_errno) THEN
                NEXT FIELD rup11
             ELSE
                LET g_rup_o.rup09 = g_rup[l_ac].rup09
                LET g_rup_o.rup10 = g_rup[l_ac].rup10
                LET g_rup_o.rup11 = g_rup[l_ac].rup11
             END IF
          END IF
#FUN-B80075 add END
 
        #TQC-D50127 -------Begin------
        ##FUN-D40103 --------Begin--------
        # IF NOT s_imechk(g_rup[l_ac].rup09,g_rup[l_ac].rup10) THEN
        #    NEXT FIELD rup10
        # END IF
        ##FUN-D40103 --------End----------
        #TQC-D50127 -------End--------

        AFTER FIELD rup12
          #IF NOT t256_rup12_check(p_cmd2) THEN NEXT FIELD rup12 END IF    #FUN-910088--add--  #TQC-C30061 add
           IF NOT cl_null(t256_rup12_check(p_cmd2)) THEN NEXT FIELD rup12 END IF  #TQC-C30061 add 
             #TQC-C20039 add START
              IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,0) NEXT FIELD rup12 END IF 
              IF NOT cl_null(g_rup[l_ac].rup12) THEN
           #FUN-D30024 ---------Begin------------
              #  INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
              #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024 
              # #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN         #FUN-C80107 mark
              #  IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                 INITIALIZE g_imd23 TO NULL    
                 CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                         #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                 IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
           #FUN-D30024 ---------End--------------
                    CALL cl_err('','mfg3471',0)
                    NEXT FIELD rup12
                 END IF
                 #TQC-C20140 add begin---
                 IF g_rup[l_ac].rup12 > g_rup[l_ac].rup19 THEN
                    CALL cl_err('','art-895',0)
                    NEXT FIELD rup12
                 END IF 
                 #TQC-C20140 add end ----
              END IF
             #TQC-C20039 add END
#FUN-910088--mark--start--       
#          IF NOT cl_null(g_rup[l_ac].rup12) THEN
#             IF g_rup[l_ac].rup12 <= 0 THEN
#                CALL cl_err('','art-305',0)
#                NEXT FIELD rup12
#             END IF
#   #FUN-BA0004 add START
#             IF NOT cl_null(g_rup[l_ac].rup09) THEN
#                CALL t256_check_out_store()
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
#                   NEXT FIELD rup09
#                END IF
#             END IF
#             IF NOT cl_null(g_rup[l_ac].rup13) THEN
#                CALL t256_check_in_store()
#                IF NOT cl_null(g_errno) THEN
#                   CALL cl_err(g_rup[l_ac].rup13,g_errno,0)
#                   NEXT FIELD rup13
#                END IF
#             END IF
#             CALL chk_store()
#             IF NOT cl_null(g_errno) THEN
#                IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
#                   CALL cl_err('',g_errno, 0)
#                   NEXT FIELD rup09
#                ELSE
#                   CALL cl_err('',g_errno,0)
#                   NEXT FIELD rup13
#                END IF
#             END IF
#   #FUN-BA0004 add END
#        #     CALL t256_check_img10()         #FUN-B80075 mark 
#        #     IF NOT cl_null(g_errno) THEN    #FUN-B80075 mark
#        #        CALL cl_err('',g_errno,0)    #FUN-B80075 mark
#        #        NEXT FIELD rup12             #FUN-B80075 mark
#        #     END IF                          #FUN-B80075 mark
#FUN-B80075 add START
#             IF g_rup[l_ac].rup12 <> g_rup_o.rup12   
#                         OR p_cmd2='a'  THEN          
#               CALL t256_check_img10()
#               IF NOT cl_null(g_errno) THEN         
#                  NEXT FIELD rup12                    
#               END IF                                
#               LET g_rup_o.rup09 = g_rup[l_ac].rup09  
#               LET g_rup_o.rup10 = g_rup[l_ac].rup10 
#               LET g_rup_o.rup11 = g_rup[l_ac].rup11  
#               LET g_rup_o.rup12 = g_rup[l_ac].rup12  
#               LET g_rup[l_ac].rup16 = g_rup[l_ac].rup12
#               LET p_cmd2 = 'u'                       
#             END IF                                   
#FUN-B80075 add END
#             LET g_rup[l_ac].rup16 = g_rup[l_ac].rup12
#          END IF
#FUN-910088--mark--end--

#FUN-AA0086---add---str---
        ON CHANGE rup12
           IF g_ruo.ruo02 = '1' THEN
              LET g_rup[l_ac].rup19 = g_rup[l_ac].rup12
           END IF    
#FUN-AA0086---add---end---
        BEFORE FIELD rup13         #FUN-B80075 add
          LET l_warehouse = '2'    #FUN-B80075 add
        
        AFTER FIELD rup13
           IF NOT cl_null(g_rup[l_ac].rup13) THEN
              CALL t256_rup13()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rup[l_ac].rup13,g_errno,0)
                 LET g_rup[l_ac].rup13 = g_rup_o.rup13
                 DISPLAY BY NAME g_rup[l_ac].rup13
                 NEXT FIELD rup13
              END IF
    #FUN-BA0004 add START
              CALL t256_check_in_store()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rup[l_ac].rup13,g_errno,0)
                 NEXT FIELD rup13
              END IF
              CALL chk_store()
              IF NOT cl_null(g_errno) THEN
                 IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                    CALL cl_err('',g_errno, 0)
                    NEXT FIELD rup09
                 ELSE
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rup13
                 END IF
              END IF
    #FUN-BA0004 add END
 
              #No.FUN-9B0157 mark begin
              #CALL t256_check_in_store()
              #IF NOT cl_null(g_errno) THEN
              #   CALL cl_err('',g_errno,0)
              #   NEXT FIELD rup13
              #END IF 
              #No.FUN-9B0157 mark end
 
              CALL t256_add_store(g_rup[l_ac].rup03,g_rup[l_ac].rup13,g_ruo.ruo05
                                 ,g_rup[l_ac].rup14,g_rup[l_ac].rup15   #MOD-A80112
                                 )#No.FUN-9B0157
              IF NOT cl_null(g_errno) THEN
                 IF g_errno = "SKIP" THEN 
                    NEXT FIELD rup14 
                 ELSE
                    CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
                    NEXT FIELD rup13
                 END IF
              END IF
       #TQC-D50127 --------Begin--------
        ##FUN-D40103 --------Begin--------
        #     IF NOT s_imechk(g_rup[l_ac].rup13,g_rup[l_ac].rup14) THEN
        #        NEXT FIELD rup14
        #     END IF
        ##FUN-D40103 --------End----------
       #TQC-D50127 --------End----------
           END IF

     #TQC-D50127 ------Begin--------
     ##FUN-D40103 -------Begin---------
     #  AFTER FIELD rup14
     #     IF cl_null(g_rup[l_ac].rup14) THEN
     #        LET g_rup[l_ac].rup14 = ' '
     #     END IF
     #     IF NOT s_imechk(g_rup[l_ac].rup13,g_rup[l_ac].rup14) THEN
     #        NEXT FIELD rup14
     #     END IF   

     #  AFTER FIELD rup15
     #     IF NOT s_imechk(g_rup[l_ac].rup13,g_rup[l_ac].rup14) THEN
     #        NEXT FIELD rup14
     #     END IF
     ##FUN-D40103 -------End-----------
     #TQC-D50127 ------End-----------
           
        AFTER FIELD rup16
           IF NOT cl_null(g_rup[l_ac].rup16) THEN
              LET g_rup[l_ac].rup16 = s_digqty(g_rup[l_ac].rup16,g_rup[l_ac].rup07)    
              DISPLAY BY NAME g_rup[l_ac].rup16
             #IF g_rup[l_ac].rup16 <= 0 THEN  #TQC-C20226 mark
              IF g_rup[l_ac].rup16 < 0 THEN   #TQC-C20226 add
                 CALL cl_err('','art-307',0)
                 NEXT FIELD rup16
              END IF
             #FUN-CA0086 Begin---
             ##撥入數量不能大于撥出數量
             #IF g_rup[l_ac].rup12 IS NOT NULL THEN
             #   IF g_rup[l_ac].rup16 > g_rup[l_ac].rup12 THEN
             #      CALL cl_err('','art-324',0)
             #      NEXT FIELD rup16
             #   END IF
             #END IF
             #FUN-CA0086 End-----
           END IF   
               
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rup_t.rup02 > 0 AND g_rup_t.rup02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rup_file
               WHERE rup01 = g_ruo.ruo01
                 AND rupplant = g_ruo.ruoplant 
                 AND rup02 = g_rup_t.rup02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rup_file",g_ruo.ruo01,g_rup_t.rup02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              #TQC-AC0382--mark--str--
              #FUN-A30030 ADD------------------------
              #ELSE
              #   IF g_aza.aza88 ='Y'  THEN
              #      LET g_ruo.ruopos='N'
              #      UPDATE ruo_file SET ruopos=g_ruo.ruopos
              #       WHERE ruo01=g_ruo.ruo01
              #         AND ruoplant=g_ruo.ruoplant
              #      DISPLAY BY NAME g_ruo.ruopos               
              #   END IF
              #FUN-A30030 END-------------------------
              #TQC-AC0382--mark--end--
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rup[l_ac].* = g_rup_t.*
              CLOSE t256_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
        #TQC-AC0382--mark--str--
        #FUN-A30030 ADD------------------------
        #   #IF g_aza.aza88 ='Y'  THEN
        #   IF g_ruo.ruo02 ='P' AND g_aza.aza88 ='Y'  THEN #FUN-AA0086
        #      LET g_ruo.ruopos='N'
        #      UPDATE ruo_file SET ruopos=g_ruo.ruopos
        #       WHERE ruo01=g_ruo.ruo01
        #         AND ruoplant=g_ruo.ruoplant
        #      DISPLAY BY NAME g_ruo.ruopos
        #   END IF
        #FUN-A30030 END------------------------
        #TQC-AC0382--mark--end--
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rup[l_ac].rup02,-263,1)
              LET g_rup[l_ac].* = g_rup_t.*
           ELSE
             IF cl_null(g_rup[l_ac].rup11) THEN LET g_rup[l_ac].rup11 = ' ' END IF #FUN-CA0086
             IF cl_null(g_rup[l_ac].rup15) THEN LET g_rup[l_ac].rup15 = ' ' END IF #FUN-CA0086
              UPDATE rup_file SET rup02=g_rup[l_ac].rup02,
                                  rup03=g_rup[l_ac].rup03,
                                  rup04=g_rup[l_ac].rup04,
                                  rup05=g_rup[l_ac].rup05,
                                  rup06=g_rup[l_ac].rup06,
                                  rup07=g_rup[l_ac].rup07,
                                  rup08=g_rup[l_ac].rup08,
                                  rup09=g_rup[l_ac].rup09,
                                  rup10=g_rup[l_ac].rup10,
                                  rup11=g_rup[l_ac].rup11,
                                  rup12=g_rup[l_ac].rup12,
                                  rup13=g_rup[l_ac].rup13,
                                  rup14=g_rup[l_ac].rup14,
                                  rup15=g_rup[l_ac].rup15,
                                  rup16=g_rup[l_ac].rup16,
                                  rup17=g_rup[l_ac].rup17,
                                  rup18=g_rup[l_ac].rup18,
                                  rup22=g_rup[l_ac].rup22,  #FUN-CC0057 add
                                  rup19=g_rup[l_ac].rup19   #FUN-AA0086 add 17 18 19
               WHERE rup01=g_ruo.ruo01
                 AND rupplant = g_ruo.ruoplant
                 AND rup02=g_rup_t.rup02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rup_file",g_ruo.ruo01,g_rup_t.rup02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rup[l_ac].* = g_rup_t.*
              ELSE
                 LET g_ruo.ruomodu = g_user                                                         
                 LET g_ruo.ruodate = g_today 
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rup[l_ac].* = g_rup_t.*
          #FUN-D30033--add--str--
              ELSE
                 CALL g_rup.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
          #FUN-D30033--add--end--
              END IF
              CLOSE t256_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033
          #FUN-C80095 mark begin ---
          ##TQC-B20179---add--str--
          ##調撥單來源為調撥申請單時,更新申請單的審核碼
          #IF g_ruo.ruo02 = '5' THEN
          #   CALL t256_upd_rvq('3') RETURNING l_flag1
          #   IF (NOT l_flag1) THEN
          #      ROLLBACK WORK
          #      CALL cl_err(g_ruo.ruo01,'art-855',1)
          #      CLOSE t256_bcl
          #      EXIT INPUT
          #   END IF
          #END IF
          ##TQC-B20179---add--end--
          #FUN-C80095 mark end ---
           CLOSE t256_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rup02) AND l_ac > 1 THEN
              LET g_rup[l_ac].* = g_rup[l_ac-1].*
              LET g_rup[l_ac].rup02 = g_rec_b + 1
              NEXT FIELD rup02
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rup03)
#FUN-AB0021---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruo.ruo04
#                IF cl_null(l_rtz04) THEN
#                    LET g_qryparam.form = "q_ima"
                    CALL q_sel_ima(FALSE, "q_ima","",g_rup[l_ac].rup03,"","","","","",'' ) #FUN-AB0021 add 
                        RETURNING g_rup[l_ac].rup03                                        #FUN-AB0021 add
#                ELSE
#                    LET g_qryparam.form = "q_ima01_3"
#                    LET g_qryparam.arg1 = l_rtz04
#                    CALL q_sel_ima(FALSE, "q_ima01_3","",g_rup[l_ac].rup03,l_rtz04,"","","","",'' ) 
#                       RETURNING g_rup[l_ac].rup03
#                END IF
#                 LET g_qryparam.default1 = g_rup[l_ac].rup03
#                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup03
#FUN-AB0021---------mod------------end-----------------
                 DISPLAY BY NAME g_rup[l_ac].rup03
                 CALL t256_rup03()
                 NEXT FIELD rup03
                 
              WHEN INFIELD(rup06)
                 CALL cl_init_qry_var()
                 IF g_rup[l_ac].rup03 IS NULL THEN 
                    LET g_qryparam.form = "q_rta05_2"
                 ELSE
                    LET g_qryparam.arg1 = g_rup[l_ac].rup03
                    LET g_qryparam.form = "q_rta05_1"
                 END IF 
                 LET g_qryparam.default1 = g_rup[l_ac].rup06
                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup06
                 DISPLAY BY NAME g_rup[l_ac].rup06
                 #CALL t256_rup06()
                 NEXT FIELD rup06
                 
              WHEN INFIELD(rup07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_smc01"
                 LET g_qryparam.default1 = g_rup[l_ac].rup07
                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup07
                 DISPLAY BY NAME g_rup[l_ac].rup07
                 CALL t256_rup07()
                 NEXT FIELD rup07
              
              WHEN INFIELD(rup09) OR INFIELD(rup10) OR INFIELD(rup11)
                 CALL q_img42(FALSE,TRUE,g_rup[l_ac].rup03,g_rup[l_ac].rup09,
                             g_rup[l_ac].rup10,g_rup[l_ac].rup11,"A",g_rup[l_ac].rup05,
                         #    g_ruo.ruoplant)          #TQC-BA0002 mark  
                             g_ruo.ruo04)              #TQC-BA0002 add
                 RETURNING g_rup[l_ac].rup09,g_rup[l_ac].rup10,g_rup[l_ac].rup11
                 IF cl_null(g_rup[l_ac].rup09) THEN LET g_rup[l_ac].rup09 = ' ' END IF 
                 IF cl_null(g_rup[l_ac].rup10) THEN LET g_rup[l_ac].rup10 = ' ' END IF 
                 IF cl_null(g_rup[l_ac].rup11) THEN LET g_rup[l_ac].rup11 = ' ' END IF 
                 DISPLAY g_rup[l_ac].rup09 TO rup09
                 DISPLAY g_rup[l_ac].rup10 TO rup10
                 DISPLAY g_rup[l_ac].rup11 TO rup11                 
                 IF INFIELD(rup09) THEN NEXT FIELD rup09 END IF
                 IF INFIELD(rup10) THEN NEXT FIELD rup10 END IF
                 IF INFIELD(rup11) THEN NEXT FIELD rup11 END IF
              
              WHEN INFIELD(rup13) OR INFIELD(rup14) OR INFIELD(rup15)
                 CALL q_img42(FALSE,TRUE,g_rup[l_ac].rup03,g_rup[l_ac].rup13,
                             g_rup[l_ac].rup14,g_rup[l_ac].rup15,"A",g_rup[l_ac].rup05,
                            # g_ruo.ruoplant)   #MOD-B10139
                             g_ruo.ruo05)   #MOD-B10139
                 RETURNING g_rup[l_ac].rup13,g_rup[l_ac].rup14,g_rup[l_ac].rup15
                 IF cl_null(g_rup[l_ac].rup13) THEN LET g_rup[l_ac].rup13 = ' ' END IF 
                 IF cl_null(g_rup[l_ac].rup14) THEN LET g_rup[l_ac].rup14 = ' ' END IF 
                 IF cl_null(g_rup[l_ac].rup15) THEN LET g_rup[l_ac].rup15 = ' ' END IF 
                 DISPLAY g_rup[l_ac].rup13 TO rup13
                 DISPLAY g_rup[l_ac].rup14 TO rup14
                 DISPLAY g_rup[l_ac].rup15 TO rup15                 
                 IF INFIELD(rup13) THEN NEXT FIELD rup13 END IF
                 IF INFIELD(rup14) THEN NEXT FIELD rup14 END IF
                 IF INFIELD(rup15) THEN NEXT FIELD rup15 END IF
                OTHERWISE EXIT CASE
              END CASE
#FUN-B80075 add BEGIN
      ON ACTION q_imd    #查詢倉庫
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_imd_t256_1"
         CASE l_warehouse
            WHEN "1"
                 LET g_qryparam.default1 = g_rup[l_ac].rup09
             #    LET g_qryparam.arg1 = 'S'        #倉庫類別
                 LET g_qryparam.arg1 = 'S,W'        #倉庫類別  #FUN-BA0004 add
                 LET g_qryparam.arg2 = g_ruo.ruo04
                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup09
                 DISPLAY BY NAME g_rup[l_ac].rup09
                 IF NOT cl_null(g_rup[l_ac].rup09) THEN
                   CALL t256_check_out_store()
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
                     NEXT FIELD rup09
                   END IF
    #FUN-BA0004 add START
                   CALL chk_store()
                   IF NOT cl_null(g_errno) THEN
                      IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                      CALL cl_err('',g_errno, 0)
                      NEXT FIELD rup09
                   ELSE
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rup13
                      END IF
                   END IF
    #FUN-BA0004 add END
                 END IF
                 IF g_rup[l_ac].rup09 <> g_rup_o.rup09
                    OR g_rup[l_ac].rup10 <> g_rup_o.rup10           
                    OR g_rup[l_ac].rup11 <> g_rup_o.rup11 THEN     
                   CALL t256_check_img10()                          
                  #TQC-C20039 add START
                 #FUN-D30024 -------Begin----------
                  # INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                  # CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024 
                  ##IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN         #FUN-C80107 mark
                  # IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                    INITIALIZE g_imd23 TO NULL  
                    CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                         #FUN-D30024 #TQC-D40078 g_ruo.ruo04
                    IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
                 #FUN-D30024 -------End------------
                       CALL cl_err('','mfg3471',0)
                       NEXT FIELD rup09
                    END IF
                  #TQC-C20039 add END
                   IF NOT cl_null(g_errno) THEN                     
                      NEXT FIELD rup09                             
                   ELSE                                             
                      LET g_rup_o.rup09 = g_rup[l_ac].rup09         
                      LET g_rup[l_ac].rup10 = ''                    
                      LET g_rup[l_ac].rup11 = ''                   
                      LET g_rup_o.rup10 = g_rup[l_ac].rup10         
                      LET g_rup_o.rup11 = g_rup[l_ac].rup11         
                   END IF                                           
                 END IF
                 #FUN-C80095 mark begin ---
                 #SELECT imd02 INTO g_rup[l_ac].rup09_desc           
                 #          FROM imd_file WHERE imd01 = g_rup[l_ac].rup09 
                 #FUN-C80095 mark end ---
                 CALL t256_sel_imd02_rup09()      #FUN-C80095 add
                 NEXT FIELD rup12
            WHEN "2"
                 LET g_qryparam.default1 = g_rup[l_ac].rup13
               #  LET g_qryparam.arg1 = 'S'        #倉庫類別
                 LET g_qryparam.arg1 = 'S,W'        #倉庫類別  #FUN-BA0004 add
                 LET g_qryparam.arg2 = g_ruo.ruo05
                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup13
                 DISPLAY BY NAME g_rup[l_ac].rup13
    #FUN-BA0004 add START
                 CALL chk_store()
                 IF NOT cl_null(g_errno) THEN
                    IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                       CALL cl_err('',g_errno, 0)
                       NEXT FIELD rup09
                    ELSE
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rup13
                    END IF
                 END IF
    #FUN-BA0004 add END
                 #FUN-C80095 mark begin ---
                 #SELECT imd02 INTO g_rup[l_ac].rup13_desc           
                 #          FROM imd_file WHERE imd01 = g_rup[l_ac].rup13     
                 #FUN-C80095 mark end ---
                 CALL t256_sel_imd02_rup13()       #FUN-C80095 add
                 NEXT FIELD rup14
            OTHERWISE
              #   LET g_qryparam.arg1 = 'S'        #倉庫類別
                 LET g_qryparam.arg1 = 'S,W'        #倉庫類別  #FUN-BA0004 add 
                 CALL cl_create_qry() RETURNING g_msg
            END CASE
      ON ACTION q_ime    #查詢倉庫儲位
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_ime_t256_1"
         CASE l_warehouse
            WHEN "1"       
                 LET g_qryparam.arg1 = g_rup[l_ac].rup09
                 LET g_qryparam.default1 = g_rup[l_ac].rup10
                 LET g_qryparam.default2 = g_rup[l_ac].rup11
                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup10,g_rup[l_ac].rup11
                 DISPLAY BY NAME g_rup[l_ac].rup10,g_rup[l_ac].rup11
                 IF NOT cl_null(g_rup[l_ac].rup09) THEN
                   CALL t256_check_out_store()
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
                     NEXT FIELD rup09
                   END IF
    #FUN-BA0004 add START
                CALL chk_store()
                IF NOT cl_null(g_errno) THEN
                   IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                      CALL cl_err('',g_errno, 0)
                      NEXT FIELD rup09
                   ELSE
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD rup13
                   END IF
               END IF
    #FUN-BA0004 add END
                 END IF
          IF g_rup[l_ac].rup10 <> g_rup_o.rup10
             OR g_rup[l_ac].rup11 <> g_rup_o.rup11
             OR g_rup[l_ac].rup09 <> g_rup_o.rup09  
             OR (NOT cl_null(g_rup_o.rup10) AND g_rup[l_ac].rup10 IS NULL)
             OR (NOT cl_null(g_rup_o.rup11) AND g_rup[l_ac].rup11 IS NULL)
             OR (NOT cl_null(g_rup[l_ac].rup10) AND cl_null(g_rup_o.rup10))
             OR (NOT cl_null(g_rup[l_ac].rup11) AND cl_null(g_rup_o.rup11))THEN
                   LET g_act = 'rup12'
                   CALL t256_check_img10()
                  #TQC-C20039 add START
             #FUN-D30024 -----------Begin-----------
               #   INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
               #   CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rup[l_ac].rup09) RETURNING g_sma894      #FUN-C80107 #FUN-D30024 
               #  #IF g_check_img = 'N' AND g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN          #FUN-C80107 mark
               #   IF g_check_img = 'N' AND g_sma894 = 'N' THEN                                              #FUN-C80107
                   INITIALIZE g_imd23 TO NULL 
                   CALL s_inv_shrt_by_warehouse(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING g_imd23                         #FUN-D30024  #TQC-D40078 g_ruo.ruo04
                   IF g_check_img = 'N' AND (g_imd23 = 'N' OR g_imd23 IS NULL) THEN
             #FUN-D30024 -----------End-------------
                      CALL cl_err('','mfg3471',0)
                      CASE g_yes
                         WHEN 'rup09'
                           NEXT FIELD rup09
                         WHEN'rup10'
                           NEXT FIELD rup10
                         WHEN'rup11'
                           NEXT FIELD rup11
                      END CASE
                      LET g_yes = ''
                   END IF
                 #TQC-C20039 add END
                   IF NOT cl_null(g_errno) THEN
                      CASE g_yes
                         WHEN 'rup09'
                           NEXT FIELD rup09
                         WHEN'rup10'
                           NEXT FIELD rup10
                         WHEN'rup11'
                           NEXT FIELD rup11
                      END CASE
                      LET g_yes = ''
                   ELSE
                      LET g_rup_o.rup09 = g_rup[l_ac].rup09
                      LET g_rup_o.rup10 = g_rup[l_ac].rup10
                      LET g_rup_o.rup11 = g_rup[l_ac].rup11
                   END IF
                 END IF
                 NEXT FIELD rup12
            WHEN "2"         
                 LET g_qryparam.arg1 = g_rup[l_ac].rup12  
                 CALL cl_create_qry() RETURNING g_rup[l_ac].rup14,g_rup[l_ac].rup15
                 DISPLAY BY NAME g_rup[l_ac].rup14,g_rup[l_ac].rup15
    #FUN-BA0004 add START
                 CALL chk_store()
                 IF NOT cl_null(g_errno) THEN
                    IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
                       CALL cl_err('',g_errno, 0)
                       NEXT FIELD rup09
                    ELSE
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rup13
                    END IF
                END IF
    #FUN-BA0004 add END 
                 NEXT FIELD rup14
            OTHERWISE
                 CALL cl_create_qry() RETURNING g_msg,g_msg
         END CASE
#FUN-B80075 add END

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
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
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")

      END INPUT

    END IF

    IF p_cmd = 'u' THEN
       UPDATE ruo_file SET ruomodu = g_ruo.ruomodu,
                           ruodate = g_ruo.ruodate
       WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
      
       DISPLAY BY NAME g_ruo.ruomodu,g_ruo.ruodate
    END IF 
    
#FUN-B90101--add--begin--
    IF s_industry("slk") THEN
       CLOSE t256_bcl_slk
    ELSE
#FUN-B90101--add--end--
       CLOSE t256_bcl
    END IF                 #FUN-B90101 add
    COMMIT WORK
#   CALL t256_delall()   #CHI-C30002 mark
    CALL t256_delHeader()     #CHI-C30002 add
    CALL t256_b_fill(' 1=1',' 1=1')   #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件 
END FUNCTION

#FUN-CA0086 Begin---
FUNCTION t256_rup17(p_cmd)
 DEFINE p_cmd        LIKE type_file.chr1
 DEFINE l_rup12      LIKE rup_file.rup12
 DEFINE l_rup        RECORD LIKE rup_file.*

   LET g_errno = ''

   SELECT * INTO l_rup.* FROM rup_file
    WHERE rup01 = g_ruo.ruo03
      AND rup02 = g_rup[l_ac].rup17
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'art503'
        
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT SUM(rup12) INTO l_rup12 FROM ruo_file,rup_file
       WHERE ruo01 = rup01
         AND ruo03 = g_ruo.ruo03
         AND rup17 = g_rup[l_ac].rup17
      IF cl_null(l_rup12) THEN LET l_rup12 = 0 END IF
      IF l_rup12 = l_rup.rup16 THEN
         LET g_errno = 'art-884'
      END IF
   END IF
   IF cl_null(g_errno) THEN
      LET g_rup[l_ac].rup06 = l_rup.rup06
      LET g_rup[l_ac].rup03 = l_rup.rup03
      LET g_rup[l_ac].rup04 = l_rup.rup04
      LET g_rup[l_ac].rup05 = l_rup.rup05
      LET g_rup[l_ac].rup07 = l_rup.rup07
      LET g_rup[l_ac].rup08 = l_rup.rup08
      LET g_rup[l_ac].rup09 = l_rup.rup13
      LET g_rup[l_ac].rup10 = l_rup.rup14
      LET g_rup[l_ac].rup11 = l_rup.rup15
      LET g_rup[l_ac].rup13 = l_rup.rup09
      LET g_rup[l_ac].rup14 = l_rup.rup10
      LET g_rup[l_ac].rup15 = l_rup.rup11
      LET g_rup[l_ac].rup12 = l_rup.rup16 - l_rup12
      LET g_rup[l_ac].rup16 = l_rup.rup16 - l_rup12
      LET g_rup[l_ac].rup19 = l_rup.rup16 - l_rup12
      CALL t256_get_desc()
   END IF

END FUNCTION
#FUN-CA0086 End-----

#CHI-C30002 -------- add -------- begin
FUNCTION t256_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF s_industry("slk") THEN
      SELECT COUNT(*) INTO g_cnt FROM rupslk_file
       WHERE rupslk01 = g_ruo.ruo01 AND rupslkplant = g_ruo.ruoplant
   ELSE
      SELECT COUNT(*) INTO g_cnt FROM rup_file
       WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
   END IF  
   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruo.ruo01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruo_file ",
                  "  WHERE ruo01 LIKE '",l_slip,"%' ",
                  "    AND ruo01 > '",g_ruo.ruo01,"'"
      PREPARE t256_pb1 FROM l_sql 
      EXECUTE t256_pb1 INTO l_cnt
      
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
         CALL t256_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruo_file WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
         INITIALIZE g_ruo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t256_delall()

#FUN-B90101--add--begin--
#  IF s_industry("slk") THEN
#     SELECT COUNT(*) INTO g_cnt FROM rupslk_file
#      WHERE rupslk01 = g_ruo.ruo01 AND rupslkplant = g_ruo.ruoplant
#  ELSE
#FUN-B90101--add--end 
#     SELECT COUNT(*) INTO g_cnt FROM rup_file
#      WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
#  END IF  #FUN-B90101 add
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ruo_file WHERE ruo01 = g_ruo.ruo01 AND ruoplant = g_ruo.ruoplant
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t256_b_fill(p_wc2,p_wc3)    #FUN-B90101 add 第二個參數，服飾業中母料件單身的條件
DEFINE p_wc2   STRING
DEFINE p_wc3   STRING                #FUN-B90101 add 
         
   #LET g_sql = "SELECT rup02,rup17,rup03,'',rup04,'',rup05,rup06,rup07,'',",
#FUN-B90101--add--begin--
   IF cl_null(p_wc3) THEN
      LET p_wc3 = " 1=1"
   END IF
   IF cl_null(p_wc2) THEN
      LET p_wc2 = " 1=1"
   END IF
   IF s_industry("slk") THEN
      LET g_sql = "SELECT DISTINCT rup02,rup17,rup22,rup06,rup03,'',rup04,'',rup05,rup07,'',",#FUN-AA0086  #FUN-D40084 add>rup22
                  "rup08,rup19,rup09,'',rup10,rup11,rup12,rup13,'',",
                  "rup14,rup15,rup16,rup18 ",    #FUN-AA0086 add rup17,18,19
                  "  FROM rup_file,rupslk_file",
                  " WHERE rup01 ='",g_ruo.ruo01,"' ",
                  " AND rupplant = '",g_ruo.ruoplant,"'", 
                  " AND rupslk01 = rup01 AND rupslk02 = rup21s ",
                  " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                  " ORDER BY rup02 "
   ELSE
#FUN-B90101--add--end--
      LET g_sql = "SELECT DISTINCT rup02,rup17,rup22,rup06,rup03,'',rup04,'',rup05,rup07,'',",#FUN-AA0086   #FUN-CC0057 add
                  "rup08,rup19,rup09,'',rup10,rup11,rup12,rup13,'',",
                  "rup14,rup15,rup16,rup18 ",    #FUN-AA0086 add rup17,18,19
                  "  FROM rup_file",
                  " WHERE rup01 ='",g_ruo.ruo01,"' ",
                  " AND rupplant = '",g_ruo.ruoplant,"'"
 
      IF NOT cl_null(p_wc2) THEN
         LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
      END IF
      LET g_sql=g_sql CLIPPED," ORDER BY rup02 "
   END IF    #FUN-B90101 add
   #DISPLAY g_sql
 
   PREPARE t256_pb FROM g_sql
   DECLARE rup_cs CURSOR FOR t256_pb
 
   CALL g_rup.clear()
   LET g_cnt = 1
 
   FOREACH rup_cs INTO g_rup[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02 INTO g_rup[g_cnt].rup03_desc FROM ima_file
           WHERE ima01 = g_rup[g_cnt].rup03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rup[g_cnt].rup03,"",SQLCA.sqlcode,"","",0)  
          LET g_rup[g_cnt].rup03_desc = NULL
       END IF
       
       SELECT gfe02 INTO g_rup[g_cnt].rup04_desc FROM gfe_file
          WHERE gfe01 = g_rup[g_cnt].rup04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","gfe_file",g_rup[g_cnt].rup04,"",SQLCA.sqlcode,"","",0)  
          LET g_rup[g_cnt].rup04_desc = NULL
       END IF
       
       SELECT gfe02 INTO g_rup[g_cnt].rup07_desc FROM gfe_file
          WHERE gfe01 = g_rup[g_cnt].rup07
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","gfe_file",g_rup[g_cnt].rup07,"",SQLCA.sqlcode,"","",0)  
          LET g_rup[g_cnt].rup07_desc = NULL
       END IF
      #FUN-C80095 mark begin --- 
      #SELECT imd02 INTO g_rup[g_cnt].rup09_desc FROM imd_file 
      #   WHERE imd01 = g_rup[g_cnt].rup09
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","imd_file",g_rup[g_cnt].rup09,"",SQLCA.sqlcode,"","",0)  
      #   LET g_rup[g_cnt].rup09_desc = NULL
      #END IF
      #
      #SELECT imd02 INTO g_rup[g_cnt].rup13_desc FROM imd_file 
      #   WHERE imd01 = g_rup[g_cnt].rup13
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","imd_file",g_rup[g_cnt].rup13,"",SQLCA.sqlcode,"","",0)  
      #   LET g_rup[g_cnt].rup13_desc = NULL
      #END IF
      #FUN-C80095 mark end ----
       
      #FUN-C80095 add begin ---
       LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo04,'imd_file'),
                   " WHERE imd01 = '",g_rup[g_cnt].rup09,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
       PREPARE t256_sel_imd FROM g_sql
       EXECUTE t256_sel_imd INTO g_rup[g_cnt].rup09_desc
       IF SQLCA.sqlcode THEN
          LET g_rup[g_cnt].rup09_desc = NULL
       END IF
       LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
                   " WHERE imd01 = '",g_rup[g_cnt].rup13,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
       PREPARE t256_sel_imd1 FROM g_sql
       EXECUTE t256_sel_imd1 INTO g_rup[g_cnt].rup13_desc
       IF SQLCA.sqlcode THEN
          LET g_rup[g_cnt].rup13_desc = NULL
       END IF
      #FUN-C80095 add end -----
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rup.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

#FUN-C80095 add begin --
FUNCTION t256_sel_imd02_rup09()
   LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo04,'imd_file'),
               " WHERE imd01 = '",g_rup[l_ac].rup09,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
   PREPARE t256_sel_imd5 FROM g_sql
   EXECUTE t256_sel_imd5 INTO g_rup[l_ac].rup09_desc
END FUNCTION 

FUNCTION t256_sel_imd02_rup13()
   LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
               " WHERE imd01 = '",g_rup[l_ac].rup13,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
   PREPARE t256_sel_imd6 FROM g_sql
   EXECUTE t256_sel_imd6 INTO g_rup[l_ac].rup13_desc
   IF SQLCA.sqlcode THEN
      LET g_rup[l_ac].rup13_desc = NULL
   END IF
END FUNCTION

FUNCTION t256_sel_imd02slk_rup09()
   LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo04,'imd_file'),
               " WHERE imd01 = '",g_rupslk[l_ac2].rupslk09,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
   PREPARE t256_sel_imd7 FROM g_sql
   EXECUTE t256_sel_imd7 INTO g_rupslk[l_ac2].rupslk09_desc
END FUNCTION 

FUNCTION t256_sel_imd02slk_rup13()
   LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
               " WHERE imd01 = '",g_rupslk[l_ac2].rupslk13,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
   PREPARE t256_sel_imd8 FROM g_sql
   EXECUTE t256_sel_imd8 INTO g_rupslk[l_ac2].rupslk13_desc
END FUNCTION
#FUN-C80095 add end ---

#FUN-B90101--add--begin--
FUNCTION t256_b_fill2(p_wc3,p_wc2)
DEFINE p_wc3   STRING
DEFINE p_wc2   STRING
DEFINE l_sum_rup16  LIKE rup_file.rup16,
       l_sum        LIKE rupslk_file.rupslk21,
       l_sum1       LIKE rupslk_file.rupslk21

   IF cl_null(p_wc3) THEN
      LET p_wc3 = " 1=1"
   END IF
   IF cl_null(p_wc2) OR p_wc2 = " 1=1" THEN
      LET g_sql = "SELECT DISTINCT rupslk02,rupslk17,rupslk03,'',rupslk04,'',rupslk05,rupslk06,rupslk07,'',",
                  "rupslk08,rupslk19,rupslk09,'',rupslk10,rupslk11,rupslk12,rupslk13,'',",
                  "rupslk14,rupslk15,rupslk16,rupslk18,rupslk20,rupslk21,rupslk22 ",
                  "  FROM rupslk_file",
                  " WHERE rupslk01 ='",g_ruo.ruo01,"' ",
                  " AND rupslkplant = '",g_ruo.ruoplant,"'",
                  " AND ",p_wc3 CLIPPED,
                  " ORDER BY rupslk02 " 
   ELSE
      LET g_sql = "SELECT DISTINCT rupslk02,rupslk17,rupslk03,'',rupslk04,'',rupslk05,rupslk06,rupslk07,'',",
                  "rupslk08,rupslk19,rupslk09,'',rupslk10,rupslk11,rupslk12,rupslk13,'',",
                  "rupslk14,rupslk15,rupslk16,rupslk18,rupslk20,rupslk21,rupslk22 ",    
                  "  FROM rupslk_file,rup_file",
                  " WHERE rupslk01 ='",g_ruo.ruo01,"' ",
                  " AND rupslkplant = '",g_ruo.ruoplant,"'",
                  " AND rupslk01 = rup01 AND rupslk02 = rup02 ",
                  " AND ",p_wc3 CLIPPED," AND ",p_wc2 CLIPPED,
                  " ORDER BY rupslk02 "
   END IF
   PREPARE t256_pb2 FROM g_sql
   DECLARE rupslk_cs CURSOR FOR t256_pb2
 
   CALL g_rupslk.clear()
   CALL g_imx.clear()
   LET g_cnt = 1
 
   FOREACH rupslk_cs INTO g_rupslk[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02 INTO g_rupslk[g_cnt].rupslk03_desc FROM ima_file
           WHERE ima01 = g_rupslk[g_cnt].rupslk03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rupslk[g_cnt].rupslk03,"",SQLCA.sqlcode,"","",0)  
          LET g_rupslk[g_cnt].rupslk03_desc = NULL
       END IF
       
       SELECT gfe02 INTO g_rupslk[g_cnt].rupslk04_desc FROM gfe_file
          WHERE gfe01 = g_rupslk[g_cnt].rupslk04
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","gfe_file",g_rupslk[g_cnt].rupslk04,"",SQLCA.sqlcode,"","",0)  
          LET g_rupslk[g_cnt].rupslk04_desc = NULL
       END IF
       
       SELECT gfe02 INTO g_rupslk[g_cnt].rupslk07_desc FROM gfe_file
          WHERE gfe01 = g_rupslk[g_cnt].rupslk07
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","gfe_file",g_rupslk[g_cnt].rupslk07,"",SQLCA.sqlcode,"","",0)  
          LET g_rupslk[g_cnt].rupslk07_desc = NULL
       END IF
       
      #FUN-C80095 mark begin ---
      #SELECT imd02 INTO g_rupslk[g_cnt].rupslk09_desc FROM imd_file 
      #   WHERE imd01 = g_rupslk[g_cnt].rupslk09
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","imd_file",g_rupslk[g_cnt].rupslk09,"",SQLCA.sqlcode,"","",0)  
      #   LET g_rupslk[g_cnt].rupslk09_desc = NULL
      #END IF
      #
      #SELECT imd02 INTO g_rupslk[g_cnt].rupslk13_desc FROM imd_file 
      #   WHERE imd01 = g_rupslk[g_cnt].rupslk13
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","imd_file",g_rupslk[g_cnt].rupslk13,"",SQLCA.sqlcode,"","",0)  
      #   LET g_rupslk[g_cnt].rupslk13_desc = NULL
      #END IF
      #FUN-C80095 mark end ---
      #FUN-C80095 add begin ---
       LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo04,'imd_file'),
                   " WHERE imd01 = '",g_rupslk[g_cnt].rupslk09,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
       PREPARE t256_sel_imdslk FROM g_sql
       EXECUTE t256_sel_imdslk INTO g_rupslk[g_cnt].rupslk09_desc
       IF SQLCA.sqlcode THEN
          LET g_rupslk[g_cnt].rupslk09_desc = NULL
       END IF 
       LET g_sql = "SELECT imd02 FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
                   " WHERE imd01 = '",g_rupslk[g_cnt].rupslk13,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
       PREPARE t256_sel_imdslk_1 FROM g_sql
       EXECUTE t256_sel_imdslk_1 INTO g_rupslk[g_cnt].rupslk13_desc
       IF SQLCA.sqlcode THEN
          LET g_rupslk[g_cnt].rupslk13_desc = NULL
       END IF
      #FUN-C80095 add end -----
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rupslk.deleteElement(g_cnt) 
 
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0

   SELECT SUM(rup16) INTO l_sum_rup16 FROM rup_file WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
   DISPLAY l_sum_rup16 TO FORMONLY.qty

   SELECT SUM(rupslk20*rupslk16) INTO l_sum FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
   CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum
   DISPLAY l_sum TO FORMONLY.sum

   SELECT SUM(rupslk21*rupslk16) INTO l_sum1 FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
   CALL cl_digcut(l_sum1,t_azi04) RETURNING l_sum1
   DISPLAY l_sum1 TO FORMONLY.sum1  
END FUNCTION

FUNCTION t256_check_imx(p_index,p_qty,p_qty_t)
   DEFINE p_index     LIKE type_file.num5,
          p_qty       LIKE rup_file.rup12,
          p_qty_t     LIKE rup_file.rup12

    LET g_errno = ''
    IF cl_null(g_rupslk[l_ac2].rupslk03)  THEN
       RETURN FALSE
    END IF
#MOD-C30217---add------------------
    IF p_qty < 0 THEN
       CALL cl_err('','art-040',0) 
       RETURN FALSE
    END IF
#MOD-C30217---end------------------
    RETURN TRUE
END FUNCTION

FUNCTION t256_check_color()
  DEFINE i          LIKE type_file.num5
  DEFINE l_flag     LIKE type_file.chr1

    FOR i=1 TO g_imx.getLength()
      IF g_imx[i].color=g_imx[l_ac3].color AND i<>l_ac3 THEN
         LET l_flag='N'
         EXIT FOR
      END IF
    END FOR
    IF l_flag='N' THEN
       CALL cl_err('',1120,0)
       RETURN FALSE
    END IF
    RETURN TRUE

END FUNCTION

FUNCTION t256_check_ima(p_index,p_ac3,p_ima01)
   DEFINE p_index     LIKE type_file.num5,
          p_ac3       LIKE type_file.num5,
          p_ima01     LIKE ima_file.ima01,
          l_ima01     LIKE ima_file.ima01,
          l_ps        LIKE sma_file.sma46,
          l_n         LIKE type_file.num5  

   LET g_errno = ' '
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,
                 g_imx[p_ac3].color,l_ps,
                 g_imxtext[p_ac3].detail[p_index].size

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = l_ima01
   IF l_n = 0 THEN
      CALL cl_err(l_ima01,'mfg-113',0)
      RETURN FALSE
   END IF
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx000 = l_ima01
   IF l_n = 0 THEN
      CALL cl_err(l_ima01,'mfg-112',0)
      RETURN FALSE
   END IF
   RETURN TRUE
 
END FUNCTION

FUNCTION t256_update_rupslk()
   DEFINE l_sum_rup12   LIKE rup_file.rup12,
          l_sum_rup19   LIKE rup_file.rup19,
          l_sum_rup16   LIKE rup_file.rup16,
          l_sum         LIKE rupslk_file.rupslk21,
          l_sum1        LIKE rupslk_file.rupslk21

   SELECT SUM(rup12),SUM(rup19),SUM(rup16) INTO l_sum_rup12,l_sum_rup19,l_sum_rup16
                                      FROM rup_file WHERE rup01 = g_ruo.ruo01
                                                      AND rup21s= g_rupslk[l_ac2].rupslk02
                                                      AND rupplant = g_ruo.ruoplant
   IF SQLCA.sqlcode OR cl_null(l_sum_rup12) THEN
      LET l_sum_rup12 = 0
   END IF
   IF g_ruo.ruo02 = '1' THEN
      LET l_sum_rup19 = l_sum_rup12
   END IF
   IF cl_null(l_sum_rup19) THEN
      LET l_sum_rup19 = 0
   END IF
   LET l_sum_rup16 = l_sum_rup12 

   UPDATE rupslk_file SET rupslk12 = l_sum_rup12,
                          rupslk16 = l_sum_rup16,
                          rupslk19 = l_sum_rup19
        WHERE rupslk01 = g_ruo.ruo01
          AND rupslk02 = g_rupslk[l_ac2].rupslk02
          AND rupslkplant = g_ruo.ruoplant

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rupslk_file",g_ruo.ruo01,g_rupslk[l_ac2].rupslk02,STATUS,"","x_upd rupslk",1)
      LET g_success = 'N'
   ELSE
      LET g_success = 'Y' 
   END IF

   LET g_rupslk[l_ac2].rupslk12 = l_sum_rup12
   LET g_rupslk[l_ac2].rupslk16 = l_sum_rup16
   LET g_rupslk[l_ac2].rupslk19 = l_sum_rup19

   SELECT SUM(rup16) INTO l_sum_rup16 FROM rup_file WHERE rup01 = g_ruo.ruo01 AND rupplant = g_ruo.ruoplant
   DISPLAY l_sum_rup16 TO FORMONLY.qty
 
   SELECT SUM(rupslk20*rupslk16) INTO l_sum FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
   CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum
   DISPLAY l_sum TO FORMONLY.sum

   SELECT SUM(rupslk21*rupslk16) INTO l_sum1 FROM rupslk_file WHERE rupslk01 = g_ruo.ruo01
                                                               AND rupslkplant = g_ruo.ruoplant
   CALL cl_digcut(l_sum1,t_azi04) RETURNING l_sum1
   DISPLAY l_sum1 TO FORMONLY.sum1    
END FUNCTION

FUNCTION t256_rupslk_move()
   LET g_rup_slk.rup01 = g_ruo.ruo01
   LET g_rup_slk.rup03 = g_rupslk[l_ac2].rupslk03
   LET g_rup_slk.rup04 = g_rupslk[l_ac2].rupslk04
   LET g_rup_slk.rup05 = g_rupslk[l_ac2].rupslk05
   LET g_rup_slk.rup06 = g_rupslk[l_ac2].rupslk06
   LET g_rup_slk.rup07 = g_rupslk[l_ac2].rupslk07
   LET g_rup_slk.rup08 = g_rupslk[l_ac2].rupslk08
   LET g_rup_slk.rup09 = g_rupslk[l_ac2].rupslk09
   LET g_rup_slk.rup10 = g_rupslk[l_ac2].rupslk10
   LET g_rup_slk.rup11 = g_rupslk[l_ac2].rupslk11
   LET g_rup_slk.rup12 = g_rupslk[l_ac2].rupslk12
   LET g_rup_slk.rup13 = g_rupslk[l_ac2].rupslk13
   LET g_rup_slk.rup14 = g_rupslk[l_ac2].rupslk14
   LET g_rup_slk.rup15 = g_rupslk[l_ac2].rupslk15
   LET g_rup_slk.rup16 = g_rupslk[l_ac2].rupslk16
   LET g_rup_slk.rup17 = g_rupslk[l_ac2].rupslk17
   LET g_rup_slk.rup18 = g_rupslk[l_ac2].rupslk18
   LET g_rup_slk.rup19 = g_rupslk[l_ac2].rupslk19
   LET g_rup_slk.rup20s= g_rupslk[l_ac2].rupslk03
   LET g_rup_slk.rup21s= g_rupslk[l_ac2].rupslk02
   LET g_rup_slk.rup22 = g_ruo.ruo05                #FUN-CC0057 add
   LET g_rup_slk.rupplant = g_ruo.ruoplant
   LET g_rup_slk.ruplegal = g_ruo.ruolegal
END FUNCTION

FUNCTION t256_rupslk20(p_ac)												
   DEFINE l_sql      STRING,												
          l_dbs      LIKE azp_file.azp03,												
          p_ac       LIKE type_file.num5,												
          l_occ01    LIKE occ_file.occ01,												
          l_azw07    LIKE azw_file.azw07,												
          l_ogaslk02 LIKE oga_file.ogaslk02,												
          l_oga01    LIKE oga_file.oga01,												
          l_ogbslk03 LIKE ogbslk_file.ogbslk03												
												
   LET l_occ01=NULL												
   LET l_azw07=NULL												
   LET l_ogaslk02=NULL												
   LET l_oga01=NULL												
   LET l_ogbslk03=NULL												
												
   SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01=g_ruo.ruo04												
   LET g_plant_new = l_azw07												
   CALL s_gettrandbs()												
   LET l_dbs=g_dbs_tra												
   IF l_azw07=g_ruo.ruo06 THEN												
      SELECT occ01 INTO l_occ01 FROM occ_file WHERE occ930=g_ruo.ruo04												
      LET l_sql="SELECT MAX(ogaslk02) FROM ",s_dbstring(l_dbs CLIPPED),"oga_file,",s_dbstring(l_dbs CLIPPED),"ogbslk_file ",												
                "WHERE oga01=ogbslk01 AND oga09='2' AND ogbslk04='",g_rupslk[p_ac].rupslk03,"' AND oga03='",l_occ01,"'"												
      DECLARE t256_c1_1 CURSOR FROM l_sql												
      OPEN t256_c1_1												
      FETCH t256_c1_1 INTO l_ogaslk02												
      CLOSE t256_c1_1												
      LET l_sql="SELECT MAX(oga01) FROM ",s_dbstring(l_dbs CLIPPED),"oga_file,",s_dbstring(l_dbs CLIPPED),"ogbslk_file ",												
                "WHERE oga01=ogbslk01 AND oga09='2' AND ogbslk04='",g_rupslk[p_ac].rupslk03,"' AND ogaslk02='",l_ogaslk02,"' AND oga03='",l_occ01,"'"												
      DECLARE t256_c2_1 CURSOR FROM l_sql												
      OPEN t256_c2_1												
      FETCH t256_c2_1 INTO l_oga01												
      CLOSE t256_c2_1												
      LET l_sql="SELECT MAX(ogbslk03) FROM ",s_dbstring(l_dbs CLIPPED),"ogbslk_file ",												
                "WHERE ogbslk01='",l_oga01,"' AND ogbslk04='",g_rupslk[p_ac].rupslk03,"'"												
      DECLARE t256_c3_1 CURSOR FROM l_sql												
      OPEN t256_c3_1												
      FETCH t256_c3_1 INTO l_ogbslk03												
      CLOSE t256_c3_1												
      LET l_sql="SELECT ogbslk13*ogbslk1006/100 FROM ",s_dbstring(l_dbs CLIPPED),"ogbslk_file ",												
                "WHERE ogbslk01='",l_oga01,"' AND ogbslk03=",l_ogbslk03												
      DECLARE t256_c4_1 CURSOR FROM l_sql												
      OPEN t256_c4_1												
      FETCH t256_c4_1 INTO g_rupslk[p_ac].rupslk20												
      SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_aza.aza17 AND aziacti = 'Y'
      CALL cl_digcut(g_rupslk[p_ac].rupslk20,t_azi03) RETURNING g_rupslk[p_ac].rupslk20
      CLOSE t256_c4_1												
   END IF												
END FUNCTION	

#TQC-C20413--add--begin--
FUNCTION t256_rupslk09()
DEFINE l_imd20      LIKE imd_file.imd20
DEFINE l_imdacti    LIKE imd_file.imdacti

    LET g_errno = ""
   #FUN-C80095 mark begin --
   # SELECT imd02,imd20,imdacti
   #    INTO g_rupslk[l_ac2].rupslk09_desc,l_imd20,l_imdacti
   #    FROM imd_file WHERE imd01 = g_rupslk[l_ac2].rupslk09
   #FUN-C80095 mark end ---
   #FUN-C80095 add begin ---
    LET g_sql = "SELECT imd02,imd20,imdacti FROM ",cl_get_target_table(g_ruo.ruo04,'imd_file'),
                " WHERE imd01 = '",g_rupslk[l_ac2].rupslk09,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_ruo.ruo04) RETURNING g_sql
    PREPARE t256_sel_imd3 FROM g_sql
    EXECUTE t256_sel_imd3 INTO g_rupslk[l_ac2].rupslk09_desc,l_imd20,l_imdacti
    IF SQLCA.sqlcode THEN
       LET g_rupslk[l_ac2].rupslk09_desc = NULL
    END IF 
   #FUN-C80095 add end -----
    CASE WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'mfg0094'
                            RETURN
         WHEN l_imdacti='N' LET g_errno = 'art-303'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF l_imd20 <> g_ruo.ruo04 THEN
       LET g_errno = 'art-304'
       RETURN
    END IF
END FUNCTION	
#TQC-C20413--add--end--

FUNCTION t256_rupslk13()
DEFINE l_imd20      LIKE imd_file.imd20
DEFINE l_imdacti    LIKE imd_file.imdacti

    LET g_errno = ""

   #FUN-C80095 mark begin ---
   # SELECT imd02,imd20,imdacti
   #    INTO g_rupslk[l_ac2].rupslk13_desc,l_imd20,l_imdacti
   #    FROM imd_file WHERE imd01 = g_rupslk[l_ac2].rupslk13
   #FUN-C80095 mark end ---
   #FUN-C80095 add begin ---
    LET g_sql = "SELECT imd02,imd20,imdacti FROM ",cl_get_target_table(g_ruo.ruo05,'imd_file'),
                " WHERE imd01 = '",g_rupslk[l_ac2].rupslk13,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_ruo.ruo05) RETURNING g_sql
    PREPARE t256_sel_imd4 FROM g_sql
    EXECUTE t256_sel_imd4 INTO g_rupslk[l_ac2].rupslk13_desc,l_imd20,l_imdacti
    IF SQLCA.sqlcode THEN
       LET g_rupslk[l_ac2].rupslk13_desc = NULL
    END IF
   #FUN-C80095 add end -----
    CASE WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'mfg0094'
                            RETURN
         WHEN l_imdacti='N' LET g_errno = 'art-303'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF l_imd20 <> g_ruo.ruo05 THEN
       LET g_errno = 'art-306'
       RETURN
    END IF
END FUNCTION		

FUNCTION t256_rupslk07()
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_smcacti     LIKE smc_file.smcacti

    LET g_errno = ""

    SELECT gfe02,gfeacti INTO g_rupslk[l_ac2].rupslk07_desc ,l_gfeacti
       FROM gfe_file
     WHERE gfe01 = g_rupslk[l_ac2].rupslk07
    CASE WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'afa-319'
                            RETURN
         WHEN l_gfeacti='N' LET g_errno = 'art-061'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

END FUNCTION								
#FUN-B90101--add--end--

FUNCTION t256_copy()
   DEFINE l_newno       LIKE ruo_file.ruo01,
          l_oldno       LIKE ruo_file.ruo01,
          li_result     LIKE type_file.num5,
          l_n           LIKE type_file.num5,
          l_old_plant   LIKE ruo_file.ruoplant
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ruo.ruo01 IS NULL OR g_ruo.ruoplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t256_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ruo01
 
       AFTER FIELD ruo01
          IF l_newno IS NULL THEN
             NEXT FIELD rxa01
          ELSE
#            CALL s_check_no("art",l_newno,"","F","ruo_file","ruo01","") #FUN-A70130 mark
             CALL s_check_no("art",l_newno,"","J1","ruo_file","ruo01","") #FUN-A70130 mod
                RETURNING li_result,l_newno
             IF (NOT li_result) THEN 
                LET g_ruo.ruo01=g_ruo_t.ruo01
                NEXT FIELD ruo01
             END IF 
             BEGIN WORK
#            CALL s_auto_assign_no("art",l_newno,g_today,"","ruo_file",  #FUN-A70130 mark
#                                  "ruo01","","","")                     #FUN-A70130 mark
             CALL s_auto_assign_no("art",l_newno,g_today,"J1","ruo_file",  #FUN-A70130 mod
                                   "ruo01","","","")                     #FUN-A70130 mod
                RETURNING li_result,l_newno 
             IF (NOT li_result) THEN
                ROLLBACK WORK
                NEXT FIELD ruo01 
             ELSE
                COMMIT WORK
             END IF
                                                                                                                                    
             DISPLAY l_newno TO ruo01
          END IF          	  
 
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
      DISPLAY BY NAME g_ruo.ruo01 
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM ruo_file
       WHERE ruo01=g_ruo.ruo01
         AND ruoplant = g_ruo.ruoplant
       INTO TEMP y
 
   UPDATE y
       SET ruo01=l_newno,
           ruo011 = NULL,
           ruoconf = '0',
           ruo10 = NULL,
           ruo11 = NULL,
           ruo12 = NULL,
           ruo13 = NULL,
           ruoplant = g_plant,
           ruolegal =g_legal,
           ruouser = g_user,
           ruogrup = g_grup,
           ruooriu=g_user,   #TQC-A30041 ADD
           ruoorig=g_grup,   #TQC-A30041 ADD
           ruomodu = NULL,
           ruodate = NULL,
           ruoacti = 'Y',
           ruocrat = g_today,
           ruopos = 'Y',
           ruocont = ''  
 
   INSERT INTO ruo_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruo_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF

#FUN-B90101--add--begin--
   IF s_industry("slk") THEN
      DROP TABLE x
 
      SELECT * FROM rupslk_file
          WHERE rupslk01=g_ruo.ruo01 
            AND rupslkplant = g_ruo.ruoplant
          INTO TEMP x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
    
      UPDATE x SET rupslk01=l_newno,rupslkplant = g_plant,rupslklegal=g_legal
    
      INSERT INTO rupslk_file
          SELECT * FROM x
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rupslk_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      ELSE
          COMMIT WORK
      END IF
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'  
   END IF
#FUN-B90101--add--end--
 
   DROP TABLE x
 
   SELECT * FROM rup_file
       WHERE rup01=g_ruo.ruo01 
         AND rupplant = g_ruo.ruoplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rup01=l_newno,rupplant = g_plant,ruplegal=g_legal
 
   INSERT INTO rup_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rup_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_ruo.ruo01
   LET l_old_plant = g_ruo.ruoplant
   SELECT ruo_file.* INTO g_ruo.* FROM ruo_file WHERE ruo01 = l_newno AND ruoplant = g_plant
   CALL t256_u()
   CALL t256_b()
   #SELECT ruo_file.* INTO g_ruo.*   #FUN-C80046
   #   FROM ruo_file WHERE ruo01 = l_oldno  AND ruoplant = l_old_ruoplant  #FUN-C80046
   #CALL t256_show()  #FUN-C80046
 
END FUNCTION
 
#FUN-B60153 -------------STA
#FUNCTION t256_out()
#DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
#    
#   IF g_wc IS NULL AND g_ruo.ruo01 IS NOT NULL THEN
#      LET g_wc = "ruo01='",g_ruo.ruo01,"'"
#   END IF        
#    
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
#                                                                                                                 
#   IF g_wc2 IS NULL THEN                                                                                                           
#      LET g_wc2 = ' 1=1'                                                                                                     
#   END IF                                                                                                                   
#                                                                                                                                   
#   LET l_cmd='p_query "artt256" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
#   CALL cl_cmdrun(l_cmd)
#END FUNCTION
FUNCTION t256_out()
DEFINE l_cmd   LIKE type_file.chr1000
  
  LET g_wc = "ruo01='",g_ruo.ruo01,"'"
 #LET l_cmd='artr256 "" "" "" "Y" "" "" "',g_wc CLIPPED,'" "',g_ruo.ruoconf,'" "',g_ruo.ruo15,'" "" "" "" ""'  #FUN-C30085
  LET l_cmd='artg256 "" "" "" "Y" "" "" "',g_wc CLIPPED,'" "',g_ruo.ruoconf,'" "',g_ruo.ruo15,'" "" "" "" ""'  #FUN-C30085
  CALL cl_cmdrun(l_cmd) 
 
END FUNCTION




#FUN-B60153 -------------END

FUNCTION t256_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ruo01,ruo05",TRUE)
    END IF
#FUN-AA0086--add---str---
    IF g_ruo.ruo02 = '5' AND p_cmd = 'a' THEN
       CALL cl_set_comp_entry("ruo03",TRUE)
       CALL cl_set_comp_required("ruo03",TRUE)
    END IF
#FUN-AA0086--add---end---    
 
END FUNCTION
 
FUNCTION t256_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
#       CALL cl_set_comp_entry("ruo01,ruo05",FALSE)
        CALL cl_set_comp_entry("ruo01,ruo02,ruo05",FALSE) #FUN-AA0086
    END IF
#FUN-AA0086--add---str---
    IF g_ruo.ruo02 <> '5' THEN
       CALL cl_set_comp_entry("ruo03",FALSE)
       CALL cl_set_comp_entry("ruo05",TRUE)
    END IF
    IF g_ruo.ruo02 = '5' AND p_cmd = 'u' THEN
       CALL cl_set_comp_entry("ruo03",FALSE)
    END IF
    IF g_ruo.ruo02 = '5' AND p_cmd = 'a' THEN
       CALL cl_set_comp_entry("ruo05,ruo14",FALSE)
    END IF
#FUN-AA0086--add---end---       
   #FUN-CA0086 Begin---
    IF g_argv2 = '2' THEN
       CALL cl_set_comp_entry("ruo02",FALSE)
       CALL cl_set_comp_entry("ruo03",TRUE)
       CALL cl_set_comp_required("ruo03",FALSE)
       IF NOT cl_null(g_ruo.ruo03) THEN
          CALL cl_set_comp_entry("ruo05,ruo14",FALSE)
       ELSE
          CALL cl_set_comp_entry("ruo05,ruo14",TRUE)
       END IF
    END IF
   #FUN-CA0086 End-----
 
END FUNCTION

#FUN-AA0086--add--srt--

FUNCTION t256_temp(l_flag)
   DEFINE l_flag  LIKE type_file.num5
   IF l_flag = '1' THEN
      SELECT * FROM ruo_file WHERE 1=0 INTO TEMP ruo_temp
      SELECT * FROM rup_file WHERE 1=0 INTO TEMP rup_temp
#FUN-B90101--add--begin--
      IF s_industry("slk") THEN
          SELECT * FROM rupslk_file WHERE 1=0 INTO TEMP rupslk_temp
      END IF
#FUN-B90101--add--end--
      CREATE TEMP TABLE p801_file(
        p_no     LIKE type_file.num5,
        so_no    LIKE pmm_file.pmm01,   #採購單號
        so_item  LIKE type_file.num5,
        so_price LIKE oeb_file.oeb13,   #單價
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073
        so_curr  LIKE pmm_file.pmm22)   #幣種

      CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,
       pab_no      LIKE oea_file.oea01, #訂單單號
       pab_item    LIKE type_file.num5,
       pab_price   LIKE type_file.num20_6)

     #FUN-CA0086 Begin---
      DROP TABLE p840_file
      CREATE TEMP TABLE p840_file(
         p_no      LIKE type_file.num5,
         pab_no    LIKE pmn_file.pmn01,
         pab_item  LIKE type_file.num5,
         pab_price LIKE oeb_file.oeb13)
     #FUN-CA0086 End-----
   ELSE
      DROP TABLE p840_file #FUN-CA0086
      DROP TABLE p801_file
      DROP TABLE p900_file
      DROP TABLE ruo_temp
      DROP TABLE rup_temp
#FUN-B90101--add--begin--
      IF s_industry("slk") THEN
         DROP TABLE rupslk_temp 
      END IF
#FUN-B90101--add--end--
   END IF
END FUNCTION
#FUN-AA0086--add--end--
# NO.FUN-960130----end-------------- 
#TQC-B20179---add--str--
#調撥單來源為調撥申請單時,更新申請單
FUNCTION t256_upd_rvq(p_rvqconf)
   DEFINE l_sql       STRING
   DEFINE p_rvqconf   LIKE rvq_file.rvqconf
   DEFINE l_rvq01     LIKE rvq_file.rvq01
   DEFINE l_rvq05     LIKE rvq_file.rvq05  #申請營運中心
   DEFINE l_rvq06     LIKE rvq_file.rvq06  #申請單號
   DEFINE l_rvq07     LIKE rvq_file.rvq07  #撥出營運中心
   DEFINE l_rvq08     LIKE rvq_file.rvq08  #撥入營運中心
   DEFINE l_rvqconf   LIKE rvq_file.rvqconf
   DEFINE l_azw07     LIKE azw_file.azw07
   DEFINE l_cnt       LIKE type_file.num5

   LET l_rvqconf = p_rvqconf
   LET l_azw07 = ''
   LET l_cnt = ''
   
   SELECT rvq01,rvq05,rvq06,rvq07,rvq08 INTO l_rvq01,l_rvq05,l_rvq06,l_rvq07,l_rvq08
     FROM rvq_file
    WHERE rvq01 = g_ruo.ruo03
      AND rvqplant = g_ruo.ruoplant  
   IF cl_null(l_rvq06) THEN
      LET l_rvq06 = l_rvq01
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw07 = l_rvq08 AND azw01 = l_rvq07 AND azwacti='Y'
 　IF l_cnt > 0 THEN        #撥出營運中心的上級是撥入營運中心
      LET l_azw07 = l_rvq08
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw07 = l_rvq07 AND azw01 = l_rvq08  AND azwacti='Y'
　　　　IF l_cnt>0 THEN      #判讀撥入營運中心的上級是否是撥出營運中心
          LET l_azw07 = l_rvq07
       END IF
   END IF
   IF cl_null(l_azw07) THEN #撥入撥出沒有上下級關係，抓取撥出的上級營運中心
      SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = l_rvq07  AND azwacti='Y'
   END IF
　　IF cl_null(l_azw07) THEN
       LET l_azw07 = l_rvq07 #撥出營運中心為最上級營運中心
   END IF
   #更新撥出營運中心
   LET l_sql = " UPDATE ",cl_get_target_table(l_rvq07,'rvq_file'),
               "    SET rvqconf = '",l_rvqconf,"' ",
               "  WHERE rvq01 = '",l_rvq01,"'",
               "    AND rvqplant = '",l_rvq07,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_rvq07) RETURNING l_sql
   PREPARE pre_upd_rvq1 FROM l_sql
   EXECUTE pre_upd_rvq1
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      RETURN FALSE
   END IF
   #不是撥出營運中心申請，更新申請營運中心
   IF l_rvq07 <> l_rvq05 THEN
      LET l_sql = " UPDATE ",cl_get_target_table(l_rvq05,'rvq_file'),
                  "    SET rvqconf = '",l_rvqconf,"' ",
                  "  WHERE rvq01 = '",l_rvq06,"'",
                  "    AND rvqplant = '",l_rvq05,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_rvq05) RETURNING l_sql
      PREPARE pre_upd_rvq2 FROM l_sql
      EXECUTE pre_upd_rvq2
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         RETURN FALSE
      END IF
   END IF
   #上級營運中心不是撥出營運中心也不是申請營運中心，更新上級營運中心
   IF l_azw07 <> l_rvq07 AND l_azw07 <> l_rvq05 THEN
      LET l_sql = " UPDATE ",cl_get_target_table(l_azw07,'rvq_file'),
                  "    SET rvqconf = '",l_rvqconf,"' ",
                  "  WHERE rvq05 = '",l_rvq05,"'",
                  "    AND rvq06 = '",l_rvq06,"'",
                  "    AND rvqplant = '",l_azw07,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_azw07) RETURNING l_sql
      PREPARE pre_upd_rvq3 FROM l_sql
      EXECUTE pre_upd_rvq3
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         RETURN FALSE
      END IF      
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BA0004 add START
FUNCTION chk_store()   #判斷在途倉/撥出倉/撥入倉是否相同為成本倉或非成本倉
DEFINE l_flag_rup09    LIKE type_file.num5        
DEFINE l_flag_rup13    LIKE type_file.num5        
DEFINE l_flag_ruo14    LIKE type_file.num5       
DEFINE l_flag_rupslk09 LIKE type_file.num5     #FUN-B90101 add
DEFINE l_flag_rupslk13 LIKE type_file.num5     #FUN-B90101 add

   LET g_errno = NULL

#FUN-B90101--add--begin-- 
   IF s_industry("slk") THEN
      IF g_sma.sma142 = 'N' THEN   #不啟用在途倉時,撥出倉與撥入倉必須相同為成本倉或非成本倉
         IF NOT cl_null(g_rupslk[l_ac2].rupslk09) AND NOT cl_null(g_rupslk[l_ac2].rupslk13) THEN
             CALL s_check(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING l_flag_rupslk09
             CALL s_check(g_rupslk[l_ac2].rupslk13,g_ruo.ruo05) RETURNING l_flag_rupslk13
             IF l_flag_rupslk09 THEN
                IF NOT l_flag_rupslk13 THEN
                   LET g_errno = 'art-874'
                END IF
             ELSE
                IF l_flag_rupslk13 THEN
                   LET g_errno = 'art-875'
                END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
          END IF
      ELSE                          #啟用在途倉,撥出/撥入倉必須與在途倉相同為成本倉或非成本倉
         IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
            IF (g_rupslk[l_ac2].rupslk09 = g_ruo.ruo14) THEN
               LET g_errno = 'art-876'
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
            CALL s_check(g_ruo.ruo14,g_ruo.ruo04) RETURNING l_flag_ruo14
            IF NOT cl_null(g_rupslk[l_ac2].rupslk09) THEN
            CALL s_check(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING l_flag_rupslk09
            IF l_flag_ruo14  THEN
               IF NOT l_flag_rupslk09 THEN
                  LET g_errno = 'art-871'
               END IF
            ELSE
               IF l_flag_rupslk09 THEN
                  LET g_errno = 'art-870'
               END IF
            END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
         ELSE                         #調撥在途歸屬撥入方
            IF (g_rupslk[l_ac2].rupslk13 = g_ruo.ruo14) THEN
               LET g_errno = 'art-877'            
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
            CALL s_check(g_ruo.ruo14,g_ruo.ruo05) RETURNING l_flag_ruo14
            CALL s_check(g_rupslk[l_ac2].rupslk13,g_ruo.ruo05) RETURNING l_flag_rupslk13
            IF l_flag_ruo14  THEN
               IF NOT l_flag_rupslk13 THEN
                  LET g_errno = 'art-873'
               END IF
            ELSE
               IF l_flag_rupslk13 THEN
                  LET g_errno = 'art-872'
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF 
         END IF
      END IF
   ELSE
#FUN-B90101--add--end-- 
      IF g_sma.sma142 = 'N' THEN   #不啟用在途倉時,撥出倉與撥入倉必須相同為成本倉或非成本倉
         IF NOT cl_null(g_rup[l_ac].rup09) AND NOT cl_null(g_rup[l_ac].rup13) THEN
             CALL s_check(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING l_flag_rup09
             CALL s_check(g_rup[l_ac].rup13,g_ruo.ruo05) RETURNING l_flag_rup13
             IF l_flag_rup09 THEN
                IF NOT l_flag_rup13 THEN
                   LET g_errno = 'art-874'
                #   CALL cl_err('','art-874',0)
                #   NEXT FIELD rup13
                END IF
             ELSE
                IF l_flag_rup13 THEN
                   LET g_errno = 'art-875'
                #   CALL cl_err('','art-875',0)
                #   NEXT FIELD rup13
                END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
          END IF
      ELSE                          #啟用在途倉,撥出/撥入倉必須與在途倉相同為成本倉或非成本倉
         IF g_sma.sma143 = '1' THEN   #調撥在途歸屬撥出方
            IF (g_rup[l_ac].rup09 = g_ruo.ruo14) THEN
               LET g_errno = 'art-876'
             #  CALL cl_err('','art-876',0)         #在途倉與撥入倉相同
             #  NEXT FIELD rup09
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
            CALL s_check(g_ruo.ruo14,g_ruo.ruo04) RETURNING l_flag_ruo14
            IF NOT cl_null(g_rup[l_ac].rup09) THEN
               CALL s_check(g_rup[l_ac].rup09,g_ruo.ruo04) RETURNING l_flag_rup09
               IF l_flag_ruo14  THEN
                  IF NOT l_flag_rup09 THEN
                     LET g_errno = 'art-871'
                   #  CALL cl_err('','art-871',0)
                   #  NEXT FIELD rup09
                  END IF
               ELSE
                  IF l_flag_rup09 THEN
                     LET g_errno = 'art-870'
                   #  CALL cl_err('','art-870',0)
                   #  NEXT FIELD rup09
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
         ELSE                         #調撥在途歸屬撥入方
            IF (g_rup[l_ac].rup13 = g_ruo.ruo14) THEN
               LET g_errno = 'art-877'            
            #   CALL cl_err('','art-877',0)         #在途倉與撥入倉相同
            #   NEXT FIELD rup13 
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF
            CALL s_check(g_ruo.ruo14,g_ruo.ruo05) RETURNING l_flag_ruo14
            CALL s_check(g_rup[l_ac].rup13,g_ruo.ruo05) RETURNING l_flag_rup13
            IF l_flag_ruo14  THEN
               IF NOT l_flag_rup13 THEN
                  LET g_errno = 'art-873'
              #    CALL cl_err('','art-873',0)
              #    NEXT FIELD rup13
               END IF
            ELSE
               IF l_flag_rup13 THEN
                  LET g_errno = 'art-872'
               #   CALL cl_err('','art-872',0)
               #   NEXT FIELD rup13
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               RETURN
            END IF 
         END IF
      END IF
   END IF   #FUN-B90101 add
END FUNCTION
#FUN-BA0004 add END
#TQC-B20179---add--end--

#FUN-910088--add--start--
FUNCTION t256_rup12_check(p_cmd2)
 DEFINE p_cmd2     LIKE type_file.chr1
 DEFINE l_rup12    LIKE rup_file.rup12 #FUN-CA0086
 DEFINE l_rup16    LIKE rup_file.rup16 #FUN-CA0086

   IF NOT cl_null(g_rup[l_ac].rup12) AND NOT cl_null(g_rup[l_ac].rup07) THEN
      IF cl_null(g_rup07_t) OR cl_null(g_rup_t.rup12) OR g_rup07_t != g_rup[l_ac].rup07 OR g_rup_t.rup12 != g_rup[l_ac].rup12 THEN
         LET g_rup[l_ac].rup12 = s_digqty(g_rup[l_ac].rup12,g_rup[l_ac].rup07)
         DISPLAY BY NAME g_rup[l_ac].rup12
      END IF
   END IF
   IF NOT cl_null(g_rup[l_ac].rup12) THEN
      IF g_rup[l_ac].rup12 <= 0 THEN
         CALL cl_err('','art-305',0)
         RETURN "rup12"
      END IF
      IF NOT cl_null(g_rup[l_ac].rup09) THEN
         CALL t256_check_out_store()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_rup[l_ac].rup09,g_errno,0)
            RETURN "rup09"
         END IF
      END IF
      IF NOT cl_null(g_rup[l_ac].rup13) THEN
         CALL t256_check_in_store()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_rup[l_ac].rup13,g_errno,0)
            RETURN "rup13"
         END IF
      END IF
      CALL chk_store()
      IF NOT cl_null(g_errno) THEN
         IF g_errno = 'art-870' OR g_errno = 'art-871' OR g_errno = 'art-876' THEN
            CALL cl_err('',g_errno, 0)
            RETURN "rup09"  
         ELSE
            CALL cl_err('',g_errno,0)
            RETURN "rup13"   
         END IF
      END IF
      IF g_rup[l_ac].rup12 <> g_rup_o.rup12   
                  OR p_cmd2='a'  THEN          
        CALL t256_check_img10()
        IF NOT cl_null(g_errno) THEN         
           RETURN "rup12"                      
        END IF                                
        LET g_rup_o.rup09 = g_rup[l_ac].rup09  
        LET g_rup_o.rup10 = g_rup[l_ac].rup10 
        LET g_rup_o.rup11 = g_rup[l_ac].rup11  
        LET g_rup_o.rup12 = g_rup[l_ac].rup12  
        LET g_rup[l_ac].rup16 = g_rup[l_ac].rup12
        LET p_cmd2 = 'u'                       
      END IF                                   
      LET g_rup[l_ac].rup16 = g_rup[l_ac].rup12
   END IF
  #FUN-CA0086 Begin---
   IF g_argv2 = '2' AND NOT cl_null(g_ruo.ruo03) THEN
      SELECT rup16 INTO l_rup16 FROM rup_file
       WHERE rup01 = g_ruo.ruo03
         AND rup02 = g_rup[l_ac].rup17
      IF cl_null(l_rup16) THEN LET l_rup16 = 0 END IF
      SELECT SUM(rup12) INTO l_rup12 FROM rup_file,ruo_file
       WHERE ruo01 = rup01
         AND ruo03 = g_ruo.ruo03
         AND rup17 = g_rup[l_ac].rup17
         AND rup01 <> g_ruo.ruo01
      IF cl_null(l_rup12) THEN LET l_rup12 = 0 END IF
      IF l_rup12 + g_rup[l_ac].rup12 > l_rup16 THEN
         CALL cl_err(g_rup[l_ac].rup12,'art-885',0)
         RETURN "rup12"
      END IF
      LET g_rup[l_ac].rup16 = g_rup[l_ac].rup12
      LET g_rup[l_ac].rup19 = g_rup[l_ac].rup12
   END IF
  #FUN-CA0086 End-----
   RETURN ""
END FUNCTION

#TQC-C20490--add--begin--
FUNCTION t256_chk_imx(p_ac,p_index,p_ima01,p_qty)
  DEFINE p_ac        LIKE type_file.num5,
         p_index     LIKE type_file.num5,
         p_ima01     LIKE ima_file.ima01,
         l_ima01     LIKE ima_file.ima01,
         l_ps        LIKE sma_file.sma46,
         p_qty       LIKE rup_file.rup12,
         l_img10     LIKE img_file.img10

   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,
                 g_imx[p_ac].color,l_ps,
                 g_imxtext[p_ac].detail[p_index].size

   IF cl_null(l_ima01) OR cl_null(g_rupslk[l_ac2].rupslk09)
      OR cl_null(p_qty) THEN
      RETURN
   END IF
   IF cl_null(g_rupslk[l_ac2].rupslk10) THEN
      LET g_rupslk[l_ac2].rupslk10 = ' '
   END IF
   IF cl_null(g_rupslk[l_ac2].rupslk11) THEN
      LET g_rupslk[l_ac2].rupslk11 = ' '
   END IF
   
   SELECT img10 INTO l_img10 FROM img_file
        WHERE img01 = l_ima01
          AND img02 = g_rupslk[l_ac2].rupslk09
          AND img03 = g_rupslk[l_ac2].rupslk10
          AND img04 = g_rupslk[l_ac2].rupslk11
   IF l_img10 IS NULL THEN LET l_img10 = 0 END IF

   IF l_img10 < p_qty THEN
   #FUN-D30024 --------Begin-----------
#     INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
#  #  CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_rupslk[l_ac2].rupslk09) RETURNING g_sma894       #FUN-C80107  #FUN-D30024
#    #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN                                #FUN-C80107 mark
#     IF g_sma894 = 'N' THEN          #FUN-C80107 
      INITIALIZE g_imd23 TO NULL
      CALL s_inv_shrt_by_warehouse(g_rupslk[l_ac2].rupslk09,g_ruo.ruo04) RETURNING g_imd23                 #FUN-D30024 #TQC-D40078 g_ruo.ruo04
      IF g_imd23 = 'N' OR g_imd23 IS NULL THEN
   #FUN-D30024 --------End-------------         
         CALL cl_err(l_img10,'mfg3471',0)
         RETURN FALSE
      ELSE
         IF NOT cl_confirm('mfg3469') THEN
            LET g_errno = 'art-475'
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#TQC-C20490--add--end--
#FUN-910088--add--end--
