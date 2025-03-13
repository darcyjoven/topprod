# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# prog. Version..: '5.20.01-09.03.15(00000)'     #
#
# Pattern name...: atmt100.4gl
# Descriptions...: 派車單維護作業
# Date & Author..: 03/12/02 By Carrier
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4B0082 04/11/10 By Carrier
# Modify.........: No.FUN-650065 06/05/26 By cl 1.程序更名為atmt100,原先程序名為axdt204
#                                               2.新增雙單位功能
# Modify.........: No.FUN-660104 06/06/19 By cl Error Message 調整
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-710033 07/01/25 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/21 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-940094 09/05/08 By mike 無效資料不可刪除  
# Modify.........: No.FUN-870007 09/07/14 By Zhangyajun 流通零售系統功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.TQC-A10101 10/01/11 By lilingyu 新增時,"機構別adkplant"欄位空白,但是adkplant_desc顯示有值
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30041 10/03/16 By Cockroach add oriu/orig 
# Modify.........: No.TQC-A40020 10/06/02 By Cockroach  審核顯示審核日期審核人員
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No:FUN-A70130 10/08/12 By huangtao 修改開窗q_oay3
# Modify.........: No:FUN-B30029 11/03/11 By huangtao 移除簽核相關欄位 
# Modify.........: No:TQC-B40096 11/04/13 By lilingyu "送貨上門"欄位ruc29不分業態,全部隱藏
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 12/01/11 By tanxc 增加數量欄位小數取位
# Modify.........: No.MOD-C50049 12/05/09 By Elise 按下ACTION'實際時間回饋'後,新增資料單身欄位無法維護,且未控卡axd-006
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20015 13/03/26 By xuxz 修改取消確認邏輯
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_adk    RECORD LIKE adk_file.*,       #派車單單頭檔
    g_adk_t  RECORD LIKE adk_file.*,       #派車單單頭檔(舊值)
    g_adk_o  RECORD LIKE adk_file.*,       #派車單單頭檔(舊值)
    g_adk01_t       LIKE adk_file.adk01,   #派車單單號(舊值)
    g_adk08_t       LIKE adk_file.adk08,   #派車單單號(舊值)
 g_adl           DYNAMIC ARRAY of RECORD    #派車單單身檔
        adl02       LIKE adl_file.adl02,   #項次
        adl11       LIKE adl_file.adl11,   #單據來源
        adl03       LIKE adl_file.adl03,   #撥出單號
        adl04       LIKE adl_file.adl04,   #撥出單項次
        ruc29       LIKE ruc_file.ruc29,   #送貨上門否 #FUN-870007
        oga04       LIKE oga_file.oga04,   #送貨客戶
        occ02       LIKE occ_file.occ02,   #簡稱
        oga044      LIKE oga_file.oga044,  #送貨地址碼
        ogb04       LIKE ogb_file.ogb04,   #產品編號
        ogb06       LIKE ogb_file.ogb06,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        adl20       LIKE adl_file.adl20,   #銷售單位
        adl05       LIKE adl_file.adl05,   #撥出數量
        adl15       LIKE adl_file.adl15,   #單位二
        adl16       LIKE adl_file.adl16,   #單位二轉換率
        adl17       LIKE adl_file.adl17,   #單位二數量
        adl12       LIKE adl_file.adl12,   #單位一
        adl13       LIKE adl_file.adl13,   #單位一轉換率
        adl14       LIKE adl_file.adl14,   #單位一數量
        adl18       LIKE adl_file.adl18,   #計價單位
        adl19       LIKE adl_file.adl19,   #計價數量
        adl06       LIKE adl_file.adl06,   #撥出件數
        adl07       LIKE adl_file.adl07,   #預計扺達日期
        adl08       LIKE adl_file.adl08,   #預計扺達時間
        adl09       LIKE adl_file.adl09,   #實際扺達日期
        adl10       LIKE adl_file.adl10,   #實際扺達時間
        adlud01     LIKE adl_file.adlud01,
        adlud02     LIKE adl_file.adlud02,
        adlud03     LIKE adl_file.adlud03,
        adlud04     LIKE adl_file.adlud04,
        adlud05     LIKE adl_file.adlud05,
        adlud06     LIKE adl_file.adlud06,
        adlud07     LIKE adl_file.adlud07,
        adlud08     LIKE adl_file.adlud08,
        adlud09     LIKE adl_file.adlud09,
        adlud10     LIKE adl_file.adlud10,
        adlud11     LIKE adl_file.adlud11,
        adlud12     LIKE adl_file.adlud12,
        adlud13     LIKE adl_file.adlud13,
        adlud14     LIKE adl_file.adlud14,
        adlud15     LIKE adl_file.adlud15
                    END RECORD,
 g_adl_t         RECORD                 #派車單單身檔 (舊值)
        adl02       LIKE adl_file.adl02,   #項次
        adl11       LIKE adl_file.adl11,   #單據來源
        adl03       LIKE adl_file.adl03,   #撥出單號
        adl04       LIKE adl_file.adl04,   #撥出單項次
        ruc29       LIKE ruc_file.ruc29,   #送貨上門否 #FUN-870007
        oga04       LIKE oga_file.oga04,   #送貨客戶
        occ02       LIKE occ_file.occ02,   #簡稱
        oga044      LIKE oga_file.oga044,  #送貨地址碼
        ogb04       LIKE ogb_file.ogb04,   #產品編號
        ogb06       LIKE ogb_file.ogb06,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        adl20       LIKE adl_file.adl20,   #銷售單位
        adl05       LIKE adl_file.adl05,   #撥出數量
        adl15       LIKE adl_file.adl15,   #單位二
        adl16       LIKE adl_file.adl16,   #單位二轉換率
        adl17       LIKE adl_file.adl17,   #單位二數量
        adl12       LIKE adl_file.adl12,   #單位一
        adl13       LIKE adl_file.adl13,   #單位一轉換率
        adl14       LIKE adl_file.adl14,   #單位一數量
        adl18       LIKE adl_file.adl18,   #計價單位
        adl19       LIKE adl_file.adl19,   #計價數量
        adl06       LIKE adl_file.adl06,   #撥出件數
        adl07       LIKE adl_file.adl07,   #預計扺達日期
        adl08       LIKE adl_file.adl08,   #預計扺達時間
        adl09       LIKE adl_file.adl09,   #實際扺達日期
        adl10       LIKE adl_file.adl10,   #實際扺達時間
        adlud01     LIKE adl_file.adlud01,
        adlud02     LIKE adl_file.adlud02,
        adlud03     LIKE adl_file.adlud03,
        adlud04     LIKE adl_file.adlud04,
        adlud05     LIKE adl_file.adlud05,
        adlud06     LIKE adl_file.adlud06,
        adlud07     LIKE adl_file.adlud07,
        adlud08     LIKE adl_file.adlud08,
        adlud09     LIKE adl_file.adlud09,
        adlud10     LIKE adl_file.adlud10,
        adlud11     LIKE adl_file.adlud11,
        adlud12     LIKE adl_file.adlud12,
        adlud13     LIKE adl_file.adlud13,
        adlud14     LIKE adl_file.adlud14,
        adlud15     LIKE adl_file.adlud15
                    END RECORD,
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(200)
    g_t1            LIKE oay_file.oayslip,     #No.FUN-550026     #No.FUN-680120 VARCHAR(05)
    g_wc,g_sql,g_wc2    string,  #No.FUN-580092 HCN
    g_adf       RECORD LIKE adf_file.*,
    g_adg       RECORD LIKE adg_file.*,
    g_ogb       RECORD LIKE ogb_file.*,
    g_oga       RECORD LIKE oga_file.*,
    g_tot              LIKE img_file.img10,
    g_factor           LIKE img_file.img21,
    g_factor1          LIKE img_file.img21,
    g_ima31            LIKE ima_file.ima31,
    g_ima906           LIKE ima_file.ima906,
    g_rec_b           LIKE type_file.num5,  #單身筆數        #No.FUN-680120 SMALLINT
    g_flag            LIKE type_file.chr1,                   #No.FUN-680120 VARCHAR(1)
    g_change          LIKE type_file.chr1,                   #No.FUN-680120 VARCHAR(1)
    g_buf             LIKE gfe_file.gfe02,                   #No.FUN-680120 VARCHAR(30)
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680120 SMALLINT
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg             LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(600)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE   g_adl20_t       LIKE adl_file.adl20          #No.FUN-BB0086
DEFINE   g_adl12_t       LIKE adl_file.adl12          #No.FUN-BB0086
DEFINE   g_adl15_t       LIKE adl_file.adl15          #No.FUN-BB0086
DEFINE   g_adl18_t       LIKE adl_file.adl18          #No.FUN-BB0086
DEFINE   g_void          LIKE type_file.chr1          #CHI-C80041

#主程式開始
MAIN
DEFINE
    l_tadl        LIKE type_file.chr8        #No.FUN-680120 VARCHAR(8)               #計算被使用時間
DEFINE lcbo_target ui.ComboBox
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
    LET g_adk01_t = NULL                   #清除鍵值
    LET g_change  = NULL
    INITIALIZE g_adk_t.* TO NULL
    INITIALIZE g_adk.* TO NULL
 
    LET p_row = 4 LET p_col = 3
 
    OPEN WINDOW t204_w AT p_row,p_col WITH FORM "atm/42f/atmt100"
         ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible('ruc29',FALSE)       #TQC-B40096    
 
    IF g_azw.azw04<>'2' THEN
#      CALL cl_set_comp_visible('adkcond,adkconu,adkconu_desc,adkplant,adkplant_desc,ruc29',FALSE) #TQC-B40096 
       CALL cl_set_comp_visible('adkcond,adkconu,adkconu_desc,adkplant,adkplant_desc',FALSE)       #TQC-B40096 
       LET lcbo_target = ui.ComboBox.forName('adl11')    
       CALL lcbo_target.removeItem('3')
    END IF
 
    CALL t100_mu_ui()    #FUN-650065
    CALL g_x.clear()
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    LET g_forupd_sql="SELECT * FROM adk_file WHERE adk01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t204_cl CURSOR FROM g_forupd_sql
    CALL t204_menu()    #中文
 
    CLOSE WINDOW t204_w                 #結束畫面
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION t204_cs()
     DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  #No.FUN-580031
 
     CLEAR FORM                             #清除畫面
     CALL g_adl.clear()
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
  CONSTRUCT BY NAME g_wc ON
                  adk01,adk02,adk03,adk04,adk05,adk06,adk07,#螢幕上取單頭條件
                  adk16,adk13,adk14,adk15,adk08,
  #                adk09,adk10,adk11,adk12,adk17,adkconf,adkmksg,        #FUN-B30029 mark
                  adk09,adk10,adk11,adk12,adkconf,                       #FUN-B30029
                  adkcond,adkconu,adkplant,                     #No.FUN-870007
                  adkoriu,adkorig,                              #TQC-A30041 ADD
                  adkuser,adkgrup,adkmodu,adkdate,adkacti,
                  adkud01,adkud02,adkud03,adkud04,adkud05,
                  adkud06,adkud07,adkud08,adkud09,adkud10,
                  adkud11,adkud12,adkud13,adkud14,adkud15
 
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adk01)     
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adk01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk01
                    NEXT FIELD adk01
                WHEN INFIELD(adk03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adj"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk03
                    NEXT FIELD adk03
                WHEN INFIELD(adk13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk13
                    NEXT FIELD adk13
                WHEN INFIELD(adk14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk14
                    NEXT FIELD adk14
                WHEN INFIELD(adk15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk15
                    NEXT FIELD adk15
                WHEN INFIELD(adk08)
                    CALL q_obw(FALSE,TRUE,g_adk.adk08,g_adk.adk04,g_adk.adk05,g_adk.adk06,g_adk.adk07) RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk08
                    NEXT FIELD adk08
                WHEN INFIELD(adk09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk09
                    NEXT FIELD adk09
                WHEN INFIELD(adk10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk10
                    NEXT FIELD adk10
                WHEN INFIELD(adk11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk11
                    NEXT FIELD adk11
                WHEN INFIELD(adk12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk12
                    NEXT FIELD adk12
                WHEN INFIELD(adkconu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adkconu"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adkconu
                    NEXT FIELD adkconu
                WHEN INFIELD(adkplant)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azp"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adkplant
                    NEXT FIELD adkplant
                OTHERWISE EXIT CASE
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     
     CONSTRUCT g_wc2 ON adl02,adl03,adl04,
                        adl20,adl05,adl15,adl16,   #FUN-650065
                        adl17,adl12,adl13,adl14,adl18,adl19,adl06,  #螢幕上取單身條件 #FUN-650065
                        adl07,adl08,adl09,adl10
                        ,adlud01,adlud02,adlud03,adlud04,adlud05
                        ,adlud06,adlud07,adlud08,adlud09,adlud10
                        ,adlud11,adlud12,adlud13,adlud14,adlud15
        FROM s_adl[1].adl02,s_adl[1].adl03,s_adl[1].adl04, #FUN-650065
             s_adl[1].adl20, #FUN-650065
             s_adl[1].adl05,s_adl[1].adl15,s_adl[1].adl16,s_adl[1].adl17, #FUN-650065
             s_adl[1].adl12,s_adl[1].adl13,s_adl[1].adl14,s_adl[1].adl18, #FUN-650065
             s_adl[1].adl19, #FUN-650065
             s_adl[1].adl06,s_adl[1].adl07,s_adl[1].adl08,s_adl[1].adl09,
             s_adl[1].adl10
             ,s_adl[1].adlud01,s_adl[1].adlud02,s_adl[1].adlud03
             ,s_adl[1].adlud04,s_adl[1].adlud05,s_adl[1].adlud06
             ,s_adl[1].adlud07,s_adl[1].adlud08,s_adl[1].adlud09
             ,s_adl[1].adlud10,s_adl[1].adlud11,s_adl[1].adlud12
             ,s_adl[1].adlud13,s_adl[1].adlud14,s_adl[1].adlud15
 
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adl03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_adl01_1"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adl[1].adl03
                     NEXT FIELD adl03
                WHEN INFIELD(adl04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_adl01_2"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adl[1].adl04
                     NEXT FIELD adl04
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_save
          CALL cl_qbe_save()
 
     END CONSTRUCT
 
     IF INT_FLAG THEN  RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('adkuser', 'adkgrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  adk01 FROM adk_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY adk01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  adk01 ",
                  "  FROM adk_file, adl_file ",
                  " WHERE adk01 = adl01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY adk01"
    END IF
    PREPARE t204_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM 
    END IF
    DECLARE t204_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t204_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM adk_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct adk01)",
                  " FROM adk_file,adl_file WHERE ",
                  " adk01=adl01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE t204_precount FROM g_sql
    DECLARE t204_count CURSOR FOR t204_precount
 
END FUNCTION
 
#中文的MENU
FUNCTION t204_menu()
 
   WHILE TRUE
      CALL t204_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t204_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t204_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t204_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t204_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL t204_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t204_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "actual_time"
           IF cl_chk_act_auth() THEN
              CALL t100_time()
           END IF
         #@WHEN "其他托運物品"
         WHEN "btn01"
            IF NOT cl_null(g_adk.adk01) THEN
               LET g_cmd = "atmi186 '",g_adk.adk01,"'"
               CALL cl_cmdrun(g_cmd CLIPPED)
            END IF
         WHEN "confirm"
             IF cl_chk_act_auth() THEN #NO.MOD-4B0082  --begin
               CALL t204_y()
                CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
             END IF #NO.MOD-4B0082  --begin
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t204_z()
                CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t204_x()
                CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t204_out('o')
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_adk.adk01 IS NOT NULL THEN
                   LET g_doc.column1 = "adk01"
                   LET g_doc.value1 = g_adk.adk01
                   CALL cl_doc()
                END IF
              END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t100_v()
               IF g_adk.adkconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_adk.adkconf,"","","",g_void,g_adk.adkacti)
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t204_a()
DEFINE   l_time LIKE type_file.chr8             #No.FUN-680120 VARCHAR(8) 
DEFINE   li_result   LIKE type_file.num5        #No.FUN-550026        #No.FUN-680120 SMALLINT
DEFINE l_adkplant_desc LIKE azp_file.azp02 #No.FUN-870007
 
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    CALL g_adl.clear()
 
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無新增之功能
    INITIALIZE g_adk.* LIKE adk_file.*
    LET g_adk01_t = NULL
    LET g_adk08_t = NULL
    LET g_adk_t.*=g_adk.*
    LET g_adk.adk04 = g_today                    #FUN-650065
    LET l_time=TIME                              #FUN-650065
    LET g_adk.adk05 = l_time[1,2],l_time[4,5]    #FUN-650065
    LET g_adk.adk02 = g_today                    #DEFAULT
    LET g_adk.adk13 = g_user                     #DEFAULT
    LET g_adk.adk14 = g_grup                     #DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_adk.adkacti ='Y'                   #有效的資料
        LET g_adk.adkconf ='N'                   #有效的資料
        LET g_adk.adkuser = g_user
        LET g_adk.adkoriu = g_user #FUN-980030
        LET g_adk.adkorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_adk.adkgrup = g_grup               #使用者所屬群
        LET g_adk.adkdate = g_today
        LET g_adk.adk17 = '0'
        LET g_adk.adkplant = g_plant
        LET g_adk.adklegal = g_legal
        SELECT azp02 INTO l_adkplant_desc FROM azp_file
         WHERE azp01 = g_plant
        DISPLAY l_adkplant_desc TO adkplant_desc
        CALL t204_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_adk.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_adk.adk01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
        #CALL s_auto_assign_no("axm",g_adk.adk01,g_adk.adk02,"19","adk_file","adk01","","","") #FUN-A70130
        CALL s_auto_assign_no("atm",g_adk.adk01,g_adk.adk02,"U8","adk_file","adk01","","","") #FUN-A70130
             RETURNING li_result,g_adk.adk01
        CALL s_showmsg()        #No.FUN-710033
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_adk.adk01
        INSERT INTO adk_file VALUES(g_adk.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","",1)  #FUN-660104
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT adk01 INTO g_adk.adk01 FROM adk_file
         WHERE adk01 = g_adk.adk01
        LET g_adk01_t = g_adk.adk01        #保留舊值
        LET g_adk08_t = g_adk.adk08        #保留舊值
        LET g_adk_t.* = g_adk.*
 
        CALL g_adl.clear()
        LET g_rec_b=0
        CALL t204_b()                   #輸入單身
 
        EXIT WHILE
    END WHILE
    SELECT * FROM adk_file WHERE adk01 = g_adk.adk01
    IF SQLCA.sqlcode = 0 THEN
       IF g_oay.oayconf = 'Y' THEN CALL t204_y() END IF #TQC-840066
       IF g_oay.oayprnt = 'Y' THEN CALL t204_prt() END IF #TQC-840066
    END IF
END FUNCTION
 
FUNCTION t204_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1) #檢查必要欄位是否空白
        p_cmd           LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_obw           RECORD LIKE obw_file.*
    DEFINE li_result    LIKE type_file.num5        #No.FUN-550026        #No.FUN-680120 SMALLINT
 
    CALL t204_adk17() 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_adk.adk01,g_adk.adk02,g_adk.adk03,g_adk.adk04, g_adk.adkoriu,g_adk.adkorig,
                  g_adk.adk05,g_adk.adk06,g_adk.adk07,g_adk.adk16,#FUN-650065
 #                 g_adk.adk13,g_adk.adk14,g_adk.adk15,g_adk.adk17,#FUN-650065             #FUN-B30029 mark
                  g_adk.adk13,g_adk.adk14,g_adk.adk15,                                      #FUN-B30029
                  g_adk.adk08,g_adk.adk09,g_adk.adk10,g_adk.adk11,#FUN-650065
 #                 g_adk.adk12,g_adk.adkmksg,g_adk.adksign,g_adk.adkplant,  #TQC-A10101    #FUN-B30029 mark
                  g_adk.adk12,g_adk.adkplant,                                              #FUN-B30029
                  g_adk.adkconf,g_adk.adkuser,g_adk.adkgrup,
                  g_adk.adkmodu,g_adk.adkdate,g_adk.adkacti,
                  g_adk.adkud01,g_adk.adkud02,g_adk.adkud03,g_adk.adkud04,
                  g_adk.adkud05,g_adk.adkud06,g_adk.adkud07,g_adk.adkud08,
                  g_adk.adkud09,g_adk.adkud10,g_adk.adkud11,g_adk.adkud12,
                  g_adk.adkud13,g_adk.adkud14,g_adk.adkud15 
                  WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t204_set_entry(p_cmd)
            CALL t204_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("adk01")
 
 
        AFTER FIELD adk01
            IF g_adk.adk01 IS NOT NULL AND (g_adk.adk01!=g_adk01_t) THEN
    #CALL s_check_no("axm",g_adk.adk01,g_adk01_t,"19","adk_file","adk01","") #FUN-A70130
    CALL s_check_no("atm",g_adk.adk01,g_adk01_t,"U8","adk_file","adk01","") #FUN-A70130
         RETURNING li_result,g_adk.adk01
    DISPLAY BY NAME g_adk.adk01
       IF (NOT li_result) THEN
          NEXT FIELD adk01
       END IF
               IF p_cmd = "a" THEN
         #FUN-B30029 --------------------STA   
                  LET g_adk.adkmksg=g_oay.oayapr #TQC-840066
                  LET g_adk.adksign=g_oay.oaysign #TQC-840066
         #        DISPLAY BY NAME g_adk.adkmksg
         #        DISPLAY BY NAME g_adk.adksign
         #FUN-B30029 ---------------------END
               END IF
            END IF
 
     AFTER FIELD adk03
            IF NOT cl_null(g_adk.adk03) THEN
               SELECT COUNT(*) INTO l_n FROM adj_file
                WHERE adj01 = g_adk.adk03
               IF l_n = 0 THEN
                  CALL cl_err(g_adk.adk03,100,0)
                  NEXT FIELD adk03
               END IF
            END IF
 
        AFTER FIELD adk05
            IF NOT cl_null(g_adk.adk05) THEN
               IF g_adk.adk05 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
                  CALL cl_err(g_adk.adk05,'axd-006',0)
                  NEXT FIELD adk05
               END IF
               IF g_adk.adk05 >= '2400' THEN
                  CALL cl_err(g_adk.adk05,'axd-006',0)
                  NEXT FIELD adk05
               END IF
            END IF
 
        AFTER FIELD adk06
            IF g_adk.adk06 < g_adk.adk04 THEN
               CALL cl_err(g_adk.adk06,'axd-001',0)
               NEXT FIELD adk06
            END IF
 
        AFTER FIELD adk07
            IF g_adk.adk07 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
               CALL cl_err(g_adk.adk07,'axd-006',0)
               NEXT FIELD adk07
            END IF
            IF g_adk.adk07 >= '2400' THEN
               CALL cl_err(g_adk.adk07,'axd-006',0)
               NEXT FIELD adk07
            END IF
            IF g_adk.adk06 = g_adk.adk04 AND g_adk.adk07 < g_adk.adk05 THEN
               CALL cl_err(g_adk.adk07,'axd-001',0)
               NEXT FIELD adk06
            END IF
 
     AFTER FIELD adk13
            IF NOT cl_null(g_adk.adk13) THEN
               CALL t204_gen02('a','1')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk13 = g_adk_t.adk13
                  DISPLAY BY NAME g_adk.adk13
                  NEXT FIELD adk13
               END IF
               SELECT gen03 INTO g_adk.adk14 FROM gen_file
                WHERE gen01 = g_adk.adk13
               DISPLAY BY NAME g_adk.adk14
            END IF
 
     AFTER FIELD adk14
            IF NOT cl_null(g_adk.adk14) THEN
               CALL t204_adk14('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk14 = g_adk_t.adk14
                  DISPLAY BY NAME g_adk.adk14
                  NEXT FIELD adk14
               END IF
            END IF
 
       AFTER FIELD adk15
            IF NOT cl_null(g_adk.adk15) THEN
               SELECT COUNT(*) INTO l_n FROM obn_file
                WHERE obn01 = g_adk.adk15
               IF l_n = 0 THEN
                  CALL cl_err(g_adk.adk15,100,0)
                  NEXT FIELD adk15
               END IF
            END IF
 
    AFTER FIELD adk08
            IF NOT cl_null(g_adk.adk08) THEN
               SELECT * INTO l_obw.* FROM obw_file
                WHERE obw01 = g_adk.adk08 AND obw07 = '1'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","obw_file",g_adk.adk08,"","axd-002","","",1) #FUN-660104
                  LET g_adk.adk08 = g_adk_t.adk08
                  NEXT FIELD adk08
               END IF
               CALL t204_oby()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk08 = g_adk_t.adk08
                  DISPLAY BY NAME g_adk.adk08
                  NEXT FIELD adk08
               END IF
               IF g_adk.adk08 <> g_adk08_t OR cl_null(g_adk08_t) THEN
                  LET g_adk.adk09 = l_obw.obw16
                  LET g_adk.adk10 = l_obw.obw17
                  LET g_adk.adk11 = l_obw.obw18
                  LET g_adk.adk12 = l_obw.obw19
                  DISPLAY BY NAME g_adk.adk09
                  DISPLAY BY NAME g_adk.adk10
                  DISPLAY BY NAME g_adk.adk11
                  DISPLAY BY NAME g_adk.adk12
               END IF
            END IF
 
     AFTER FIELD adk09
            IF NOT cl_null(g_adk.adk09) THEN
               CALL t204_gen02('a','2')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk09 = g_adk_t.adk09
                  DISPLAY BY NAME g_adk.adk09
                  NEXT FIELD adk09
               END IF
            END IF
 
     AFTER FIELD adk10
            IF NOT cl_null(g_adk.adk10) THEN
               CALL t204_gen02('a','3')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk10 = g_adk_t.adk10
                  DISPLAY BY NAME g_adk.adk10
                  NEXT FIELD adk10
               END IF
            END IF
 
     AFTER FIELD adk11
            IF NOT cl_null(g_adk.adk11) THEN
               CALL t204_gen02('a','4')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk11 = g_adk_t.adk11
                  DISPLAY BY NAME g_adk.adk11
                  NEXT FIELD adk11
               END IF
            END IF
 
     AFTER FIELD adk12
            IF NOT cl_null(g_adk.adk12) THEN
               CALL t204_gen02('a','5')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk12 = g_adk_t.adk12
                  DISPLAY BY NAME g_adk.adk12
                  NEXT FIELD adk12
               END IF
            END IF
 
 
        AFTER FIELD adkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            CALL t204_oby()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD adk08
            END IF
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adk01)        #need modify
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oay3"
                  # LET g_qryparam.arg1 = '19'
                    LET g_qryparam.arg1 = 'U8'
                    LET g_qryparam.arg2 = 'atm'  #FUN-A70130
                    CALL cl_create_qry() RETURNING g_adk.adk01
                    DISPLAY BY NAME g_adk.adk01
                    NEXT FIELD adk01
                WHEN INFIELD(adk03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adj"
                    LET g_qryparam.default1 = g_adk.adk03
                    CALL cl_create_qry() RETURNING g_adk.adk03
                    DISPLAY BY NAME g_adk.adk03
                    NEXT FIELD adk03
                WHEN INFIELD(adk13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk13
                    CALL cl_create_qry() RETURNING g_adk.adk13
                    DISPLAY BY NAME g_adk.adk13
                    NEXT FIELD adk13
                WHEN INFIELD(adk14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adk.adk14
                    CALL cl_create_qry() RETURNING g_adk.adk14
                    DISPLAY BY NAME g_adk.adk14
                    NEXT FIELD adk14
                WHEN INFIELD(adk15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn"
                    LET g_qryparam.default1 = g_adk.adk15
                    CALL cl_create_qry() RETURNING g_adk.adk15
                    DISPLAY BY NAME g_adk.adk15
                    NEXT FIELD adk15
                WHEN INFIELD(adk08)
                    CALL q_obw(FALSE,FALSE,g_adk.adk08,g_adk.adk04,g_adk.adk05,g_adk.adk06,g_adk.adk07)
                         RETURNING g_adk.adk08
                    DISPLAY BY NAME g_adk.adk08
                    NEXT FIELD adk08
                WHEN INFIELD(adk09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk09
                    CALL cl_create_qry() RETURNING g_adk.adk09
                    DISPLAY BY NAME g_adk.adk09
                    NEXT FIELD adk09
                WHEN INFIELD(adk10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk10
                    CALL cl_create_qry() RETURNING g_adk.adk10
                    DISPLAY BY NAME g_adk.adk10
                    NEXT FIELD adk10
                WHEN INFIELD(adk11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk11
                    CALL cl_create_qry() RETURNING g_adk.adk11
                    DISPLAY BY NAME g_adk.adk11
                    NEXT FIELD adk11
                WHEN INFIELD(adk12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk12
                    CALL cl_create_qry() RETURNING g_adk.adk12
                    DISPLAY BY NAME g_adk.adk12
                    NEXT FIELD adk12
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                       # 欄位說明
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
 
FUNCTION t204_adk17()
    DEFINE l_str LIKE ze_file.ze03               #No.FUN-680120 VARCHAR(08)     
 
    CASE g_adk.adk17
#         WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str    #CHI-B40058
#         WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str    #CHI-B40058
#         WHEN '2' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str    #CHI-B40058
#         WHEN '3' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str    #CHI-B40058
#         WHEN '4' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str    #CHI-B40058
         WHEN '0' CALL cl_getmsg('mfg3211',g_lang) RETURNING l_str     #CHI-B40058
         WHEN '1' CALL cl_getmsg('mfg3212',g_lang) RETURNING l_str     #CHI-B40058
         WHEN '2' CALL cl_getmsg('mfg3546',g_lang) RETURNING l_str     #CHI-B40058
         WHEN '3' CALL cl_getmsg('mfg3548',g_lang) RETURNING l_str     #CHI-B40058
         WHEN '4' CALL cl_getmsg('mfg3556',g_lang) RETURNING l_str     #CHI-B40058
    END CASE
    DISPLAY l_str TO FORMONLY.desc
 
END FUNCTION
 
FUNCTION t204_adl04(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_occ02    LIKE occ_file.occ02,
        l_ima021   LIKE ima_file.ima021
DEFINE l_rvn RECORD LIKE rvn_file.*              #No.FUN-870007
 
        LET g_errno = ' '
     IF g_adl[l_ac].adl11 = '3' THEN
        SELECT * INTO l_rvn.* FROM rvn_file 
         WHERE rvn01 = g_adl[l_ac].adl03
           AND rvn02 = g_adl[l_ac].adl02
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.sqlcode USING '-------'
        ELSE
           SELECT occ02 INTO g_adl[l_ac].occ02 FROM occ_file
            WHERE occ01 = l_rvn.rvn06
              AND occacti = 'Y'
           SELECT ima02,ima021 INTO g_adl[l_ac].ogb06,g_adl[l_ac].ima021
             FROM ima_file
            WHERE ima01 = l_rvn.rvn09 AND imaacti = 'Y'
           SELECT ruc16 INTO g_adl[l_ac].adl20 FROM ruc_file
            WHERE ruc01 = l_rvn.rvn06 AND ruc02 = l_rvn.rvn03
              AND ruc03 = l_rvn.rvn04
           LET g_adl[l_ac].oga04 = l_rvn.rvn06
           LET g_adl[l_ac].ogb04 = l_rvn.rvn09
           LET g_adl[l_ac].adl05 = l_rvn.rvn10
           #No.FUN-BB0086--add--begin--
           LET g_adl[l_ac].adl05 = s_digqty(g_adl[l_ac].adl05,g_adl[l_ac].adl20)  
           DISPLAY BY NAME g_adl[l_ac].adl05
           #No.FUN-BB0086--add--end--
        END IF
     ELSE           
        SELECT oga_file.*,ogb_file.* INTO g_oga.*,g_ogb.*
          FROM oga_file,ogb_file
        WHERE oga01=ogb01
          AND ogb01=g_adl[l_ac].adl03
          AND ogb03=g_adl[l_ac].adl04
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.SQLCODE USING '-------'
        END IF
        IF cl_null(g_errno) THEN               #OR p_cmd = 'd' THEN
           LET g_adl[l_ac].oga04 = g_oga.oga04
           IF NOT cl_null(g_adl[l_ac].oga04) THEN
              SELECT occ02 INTO l_occ02 FROM occ_file
                WHERE occ01=g_adl[l_ac].oga04
              IF SQLCA.sqlcode=0 THEN
                 LET g_adl[l_ac].occ02 = l_occ02
              END IF
           END IF
           LET g_adl[l_ac].oga044= g_oga.oga044
           LET g_adl[l_ac].ogb04 = g_ogb.ogb04
           IF NOT cl_null(g_adl[l_ac].ogb04) THEN
              SELECT ima021 INTO l_ima021 FROM ima_file
                WHERE ima01=g_adl[l_ac].ogb04
              IF SQLCA.sqlcode=0 THEN
                 LET g_adl[l_ac].ima021= l_ima021
              END IF
           END IF
           LET g_adl[l_ac].ogb06 = g_ogb.ogb06
           LET g_adl[l_ac].adl20 = g_ogb.ogb05
        END IF
        IF cl_null(g_errno) Or p_cmd = 'a' THEN
           IF cl_null(g_ogb.ogb913) THEN
              SELECT ima31 INTO g_ogb.ogb913 
                FROM ima_file
               WHERE ima01=g_ogb.ogb04
              IF SQLCA.SQLcode=100 THEN
                 CALL cl_err3("sel","ima_file",g_ogb.ogb04,"","atm-132","","",1) #FUN-660104
                 IF SQLCA.sqlcode=0 THEN 
                    LET g_adl[l_ac].adl17 = 0
                 END IF
              END IF
           END IF
           IF cl_null(g_adl[l_ac].adl15) THEN
              LET g_adl[l_ac].adl15 = g_ogb.ogb913
           END IF
           LET g_adl[l_ac].adl16 = g_ogb.ogb914
           IF cl_null(g_adl[l_ac].adl12) THEN
              LET g_adl[l_ac].adl12 = g_ogb.ogb910
           END IF
           LET g_adl[l_ac].adl13 = g_ogb.ogb911
           IF cl_null(g_adl[l_ac].adl18) THEN   
              LET g_adl[l_ac].adl18 = g_ogb.ogb916
           END IF
        END IF
    END IF  #No.FUN-870007
END FUNCTION
 
FUNCTION t204_gen02(p_cmd,p_code)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        p_code      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_gen01     LIKE gen_file.gen01,
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  CASE WHEN p_code = '1' LET l_gen01 = g_adk.adk13
       WHEN p_code = '2' LET l_gen01 = g_adk.adk09
       WHEN p_code = '3' LET l_gen01 = g_adk.adk10
       WHEN p_code = '4' LET l_gen01 = g_adk.adk11
       WHEN p_code = '5' LET l_gen01 = g_adk.adk12
       WHEN p_code = '6' LET l_gen01 = g_adk.adkconu#CHI-D20015 add
  END CASE
  SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
   WHERE gen01 = l_gen01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET l_gen01 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
  CASE WHEN p_code = '1' DISPLAY l_gen02 TO FORMONLY.gen02
       WHEN p_code = '2' DISPLAY l_gen02 TO FORMONLY.gen02a
       WHEN p_code = '3' DISPLAY l_gen02 TO FORMONLY.gen02b
       WHEN p_code = '4' DISPLAY l_gen02 TO FORMONLY.gen02c
       WHEN p_code = '5' DISPLAY l_gen02 TO FORMONLY.gen02d
       WHEN p_code = '6' DISPLAY l_gen02 TO FORMONLY.adkconu_desc #CHI-D20015 add
  END CASE
  END IF
END FUNCTION
 
FUNCTION t204_oby()
DEFINE l_n  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    LET g_errno = ' '
    #用于判斷預計出車時間或是返回時間是否在暫停使用記錄中存在
    #如果這兩者之一的時間在區域內表示當前不能用
    SELECT COUNT(*) INTO l_n FROM oby_file
     WHERE oby01 = g_adk.adk08
       AND (((oby02 < g_adk.adk04 OR    #出車時間在暫停範圍內
             (oby02 = g_adk.adk04 AND oby03 < g_adk.adk05)) AND
             (oby04 > g_adk.adk04 OR
             (oby04 = g_adk.adk04 AND oby05 > g_adk.adk05)))
        OR  ((oby02 < g_adk.adk06 OR    #返回時間在暫停範圍內
             (oby02 = g_adk.adk06 AND oby03 < g_adk.adk07)) AND
             (oby04 > g_adk.adk06 OR
             (oby04 = g_adk.adk06 AND oby05 > g_adk.adk07)))
        OR  ((oby02 > g_adk.adk04 OR    #暫停時間包含在範圍內
             (oby02 = g_adk.adk04 AND oby03 >= g_adk.adk05)) AND
             (oby04 < g_adk.adk06 OR
             (oby04 = g_adk.adk06 AND oby05 <= g_adk.adk07))))
    IF l_n > 0 THEN
       LET g_errno = 'axd-005'
    END IF
END FUNCTION
 
FUNCTION t204_adk14(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = g_adk.adk14
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_adk.adk14 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION t204_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_adk.* TO NULL              #No.FUN-6B0043
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_adl.clear()
 
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL t204_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN t204_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL
    ELSE
        OPEN t204_count
        FETCH t204_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t204_t('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t204_t(p_flag)
    DEFINE
        p_flag           LIKE type_file.chr1,        #No.FUN-680120 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t204_cs INTO g_adk.adk01
        WHEN 'P' FETCH PREVIOUS t204_cs INTO g_adk.adk01
        WHEN 'F' FETCH FIRST    t204_cs INTO g_adk.adk01
        WHEN 'L' FETCH LAST     t204_cs INTO g_adk.adk01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
            FETCH ABSOLUTE g_jump t204_cs INTO g_adk.adk01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL   #No.TQC-6B0105
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
 
    SELECT * INTO g_adk.* FROM adk_file            # 重讀DB,因TEMP有不被更新特性
       WHERE adk01 = g_adk.adk01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","",1)  #FUN-660104
    ELSE
         LET g_data_owner=g_adk.adkuser           #FUN-4C0052權限控管
         LET g_data_group=g_adk.adkgrup
         LET g_data_plant = g_adk.adkplant #FUN-980030
 
        CALL t204_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t204_show()
    DEFINE l_str LIKE ze_file.ze03           #No.FUN-680120 VARCHAR(08)
DEFINE l_adkplant_desc LIKE azp_file.azp02   #No.FUN-870007
DEFINE l_adkconu_desc LIKE gen_file.gen02    #No.FUN-870007
 
    LET g_adk_t.* = g_adk.*
 DISPLAY BY NAME g_adk.adk01,g_adk.adk02,g_adk.adk03,g_adk.adk04,
                    g_adk.adk05,g_adk.adk06,g_adk.adk07,g_adk.adk16,
       #             g_adk.adk13,g_adk.adk14,g_adk.adk15,g_adk.adk17,              #FUN-B30029  mark
                    g_adk.adk13,g_adk.adk14,g_adk.adk15,                           #FUN-B30029
                    g_adk.adk08,g_adk.adk09,g_adk.adk10,g_adk.adk11,
        #            g_adk.adk12,g_adk.adkmksg,g_adk.adksign,g_adk.adkuser,        #FUN-B30029  mark
                    g_adk.adk12,g_adk.adkuser,                                     #FUN-B30029
                    g_adk.adkgrup,g_adk.adkmodu,g_adk.adkdate,g_adk.adkacti,
                    g_adk.adkconf,
                    g_adk.adkcond,g_adk.adkconu,g_adk.adkplant,              #No.FUN-870007
                    g_adk.adkoriu,g_adk.adkorig,                         #TQC-A30041 ADD
                    g_adk.adkud01,g_adk.adkud02,g_adk.adkud03,g_adk.adkud04,
                    g_adk.adkud05,g_adk.adkud06,g_adk.adkud07,g_adk.adkud08,
                    g_adk.adkud09,g_adk.adkud10,g_adk.adkud11,g_adk.adkud12,
                    g_adk.adkud13,g_adk.adkud14,g_adk.adkud15 
     #CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082 #CHI-C80041
     IF g_adk.adkconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
     CALL cl_set_field_pic(g_adk.adkconf,"","","",g_void,g_adk.adkacti)   #CHI-C80041
    IF g_adk.adkconf='Y' THEN
       SELECT gen02 INTO l_adkconu_desc FROM gen_file
        WHERE gen01 = g_adk.adkconu
          AND genacti= 'Y'
    END IF
    SELECT azp02 INTO l_adkplant_desc FROM azp_file
     WHERE azp01 = g_adk.adkplant
    DISPLAY l_adkconu_desc,l_adkplant_desc TO adkconu_desc,adkplant_desc
    CALL t204_gen02('d','1')
    CALL t204_gen02('d','2')
    CALL t204_gen02('d','3')
    CALL t204_gen02('d','4')
    CALL t204_gen02('d','5')
    CALL t204_gen02('d','6')#CHI-D20015 add
    CALL t204_adk14('d')
    CALL t204_adk17()
    CALL t204_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t204_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'mfg1000',0)
        RETURN
    END IF
    IF g_adk.adkconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_adk01_t = g_adk.adk01
    LET g_adk08_t = g_adk.adk08
    LET g_adk_t.* = g_adk.*
    LET g_adk_o.* = g_adk.*
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
       CLOSE t204_cl ROLLBACK WORK RETURN
    END IF
    LET g_adk.adkmodu=g_user                     #修改者
    LET g_adk.adkdate = g_today                  #修改日期
    CALL t204_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t204_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_adk.*=g_adk_t.*
            CALL t204_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_adk.adk01 != g_adk01_t THEN
            UPDATE adl_file SET adl01= g_adk.adk01
                    WHERE adl01 = g_adk01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","adl_file",g_adk01_t,"",SQLCA.sqlcode,"","",1)  #FUN-660104
               CONTINUE WHILE
            END IF
        END IF
        UPDATE adk_file SET adk_file.* = g_adk.*    # 更新DB
         WHERE adk01 = g_adk01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","",1) #FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t204_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t204_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t204_show()
    IF cl_exp(0,0,g_adk.adkacti) THEN
        LET g_chr=g_adk.adkacti
        IF g_adk.adkacti='Y' THEN
            LET g_adk.adkacti='N'
        ELSE
            LET g_adk.adkacti='Y'
        END IF
        UPDATE adk_file
            SET adkacti=g_adk.adkacti,
               adkmodu=g_user, adkdate=g_today
            WHERE adk01=g_adk.adk01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","",1)  #FUN-660104
            LET g_adk.adkacti=g_chr
        END IF
        DISPLAY BY NAME g_adk.adkoriu,g_adk.adkorig, g_adk.adkacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE t204_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t204_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adk.adkconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
    IF g_adk.adkacti='N' THEN                                                                                                       
       CALL cl_err(g_adk.adk01,'abm-950',0)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t204_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "adk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_adk.adk01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM adk_file WHERE adk01 = g_adk.adk01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","",1)   #FUN-660104
        ELSE
           DELETE FROM adl_file WHERE adl01=g_adk.adk01
           CLEAR FORM
           CALL g_adl.clear()
--mi
         OPEN t204_cs          #FUN-650065
         OPEN t204_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t204_cs
            CLOSE t204_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t204_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t204_cs
            CLOSE t204_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t204_cl
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t204_t('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t204_t('/')
         END IF
--#
        END IF
    END IF
    CLOSE t204_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t204_b()
DEFINE
    l_buf           LIKE type_file.chr1000,             #儲存尚在使用中之下游檔案之檔名     #No.FUN-680120
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT                  #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用                         #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否                         #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                           #No.FUN-680120 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,                #No.FUN-680120 VARCHAR(1)              #'1':表存放位置有值,'2':則為NULL
    l_allow_insert  LIKE type_file.num5,                #可新增否                           #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                           #No.FUN-680120 SMALLINT
DEFINE
    l_adl05         LIKE adl_file.adl05,
    l_ogb12         LIKE ogb_file.ogb12,
    l_adl14         LIKE adl_file.adl14,
    l_adl17         LIKE adl_file.adl17,
    l_ima906        LIKE ima_file.ima906,
    l_time          LIKE type_file.chr8,             #No.FUN-680120 VARCHAR(8) 
    l_flag          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_factor        LIKE oeb_file.oeb12              #No.FUN-680120 DECIMAL(16,8) 
DEFINE l_gfeacti LIKE gfe_file.gfeacti  #No.FUN-870007
DEFINE l_tf         LIKE type_file.chr1   #No.FUN-BB0086
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkacti MATCHES'[Nn]' THEN
       CALL cl_err(g_adk.adk01,'mfg1000',0)
       RETURN
    END IF
    IF g_adk.adkconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql=" SELECT adl02,adl11,adl03,adl04,'','','','','','','',adl20,adl05,",  #No.FUN-870007
                     "        adl15,adl16,adl17,adl12,adl13,adl14,adl18,adl19,",       #FUN-650065
                     "        adl06,adl07,adl08,adl09,adl10,",
                     "        adlud01,adlud02,adlud03,adlud04,adlud05,",
                     "        adlud06,adlud07,adlud08,adlud09,adlud10,",
                     "        adlud11,adlud12,adlud13,adlud14,adlud15", 
                     "   FROM adl_file",
                     "   WHERE adl02 = ?  AND adl01=?",
                     "    FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t204_bcl CURSOR FROM g_forupd_sql
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        INPUT ARRAY g_adl WITHOUT DEFAULTS FROM s_adl.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_before_input_done = FALSE  
           LET g_before_input_done = TRUE
           #No.FUN-BB0086--add--begin---
           LET g_adl12_t = NULL 
           LET g_adl15_t = NULL
           LET g_adl18_t = NULL
           LET g_adl20_t = NULL
           #No.FUN-BB0086--add--end---
 
    BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n = ARR_COUNT()
 
            BEGIN WORK
            OPEN t204_cl USING g_adk.adk01
            IF STATUS THEN
               CALL cl_err("OPEN t204_cl:", STATUS, 1)
               CLOSE t204_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t204_cl INTO g_adk.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
                CLOSE t204_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_adl_t.* = g_adl[l_ac].*  #BACKUP
                LET g_adl20_t = g_adl[l_ac].adl20   #No.FUN-BB0086
                LET g_adl12_t = g_adl[l_ac].adl12   #No.FUN-BB0086
                LET g_adl15_t = g_adl[l_ac].adl15   #No.FUN-BB0086
                LET g_adl18_t = g_adl[l_ac].adl18   #No.FUN-BB0086
                OPEN t204_bcl USING g_adl_t.adl02,g_adk.adk01
                IF STATUS THEN
                   CALL cl_err("OPEN t204_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH t204_bcl INTO g_adl[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adl_t.adl02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   CALL t204_adl04('d')#FUN-650065
               SELECT ruc29 INTO g_adl[l_ac].ruc29
                 FROM ruc_file
                WHERE EXISTS (SELECT 1 FROM rvn_file
                               WHERE rvn03 = ruc02
                                 AND rvn04 = ruc03
                                 AND rvn01 = g_adl[l_ac].adl03
                                 AND rvn02 = g_adl[l_ac].adl04)
                IF cl_null(g_adl[l_ac].ruc29) THEN LET g_adl[l_ac].ruc29='N' END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adl[l_ac].* TO NULL      #900423
            LET g_adl_t.* = g_adl[l_ac].*     #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            LET g_adl[l_ac].adl07 = g_adk.adk06   #FUN-650065
            LET g_adl[l_ac].adl08 = g_adk.adk07   #FUN-650065
            CALL t100_set_entry_b()
            CALL t100_set_no_entry_b()
            NEXT FIELD adl02
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_sma.sma115='Y' THEN
               CALL t100_set_origin_field()
            END IF
            INSERT INTO adl_file(adl01,adl02,adl03,adl04,adl05,adl06,
                                 adl07,adl08,adl09,adl10,adl11,adl12,     #FUN-650065
                                 adl13,adl14,adl15,adl16,adl17,adl18,
                                 adl19,adl20,  #No.MOD-470041  #FUN-650065
                                 adlplant,adllegal,                       #No.FUN-870007
                                 adlud01,adlud02,adlud03,adlud04,adlud05,adlud06,
                                 adlud07,adlud08,adlud09,adlud10,adlud11,adlud12,
                                 adlud13,adlud14,adlud15 )
                        VALUES(g_adk.adk01,
                               g_adl[l_ac].adl02, g_adl[l_ac].adl03,
                               g_adl[l_ac].adl04, g_adl[l_ac].adl05,
                               g_adl[l_ac].adl06, g_adl[l_ac].adl07,
                               g_adl[l_ac].adl08, g_adl[l_ac].adl09,
                               g_adl[l_ac].adl10, g_adl[l_ac].adl11,
                               g_adl[l_ac].adl12, g_adl[l_ac].adl13,
                               g_adl[l_ac].adl14, g_adl[l_ac].adl15,
                               g_adl[l_ac].adl16, g_adl[l_ac].adl17,
                               g_adl[l_ac].adl18, g_adl[l_ac].adl19,
                               g_adl[l_ac].adl20,
                               g_adk.adkplant,g_adk.adklegal,               #No.FUN-870007
                               g_adl[l_ac].adlud01,g_adl[l_ac].adlud02,
                               g_adl[l_ac].adlud03,g_adl[l_ac].adlud04,
                               g_adl[l_ac].adlud05,g_adl[l_ac].adlud06,
                               g_adl[l_ac].adlud07,g_adl[l_ac].adlud08,
                               g_adl[l_ac].adlud09,g_adl[l_ac].adlud10,
                               g_adl[l_ac].adlud11,g_adl[l_ac].adlud12,
                               g_adl[l_ac].adlud13,g_adl[l_ac].adlud14,
                               g_adl[l_ac].adlud15)
            IF SQLCA.SQLcode  THEN
                CALL cl_err3("ins","adl_file",g_adl[l_ac].adl02,"",SQLCA.sqlcode,"","",1)   #FUN-660104
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE FIELD adl02                        # dgeeault 序號
            IF g_adl[l_ac].adl02 IS NULL or g_adl[l_ac].adl02 = 0 THEN
                SELECT max(adl02)+1 INTO g_adl[l_ac].adl02 FROM adl_file
                    WHERE adl01 = g_adk.adk01
                IF g_adl[l_ac].adl02 IS NULL THEN
                    LET g_adl[l_ac].adl02 = 1
                END IF
            END IF
 
        AFTER FIELD adl02
            IF g_adl[l_ac].adl02 IS NOT NULL AND
               (g_adl[l_ac].adl02 != g_adl_t.adl02 OR
                g_adl_t.adl02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM adl_file
                 WHERE adl01 = g_adk.adk01
                   AND adl02 = g_adl[l_ac].adl02
                IF l_n > 0 THEN
                    CALL cl_err(g_adl[l_ac].adl02,-239,0)
                    LET g_adl[l_ac].adl02 = g_adl_t.adl02
                    NEXT FIELD adl02
                END IF
            END IF
 
        BEFORE FIELD adl11
            IF p_cmd='a' THEN
               LET g_adl[l_ac].adl11='1'      #初始為"1"
               DISPLAY BY NAME g_adl[l_ac].adl11 
            END IF
 
        AFTER FIELD adl03
            IF NOT cl_null(g_adl[l_ac].adl03) THEN
               IF g_adl[l_ac].adl11='1' THEN
                  SELECT *  FROM oga_file WHERE oga01=g_adl[l_ac].adl03
                    AND (oga_file.oga09='1' OR oga_file.oga09='5') 
                    AND oga_file.ogaconf='Y'
               ELSE 
                 IF g_adl[l_ac].adl11='2' THEN
                    SELECT *  FROM oga_file WHERE oga01=g_adl[l_ac].adl03
                      AND (oga_file.oga09='2' OR oga_file.oga09='3' OR 
                           oga_file.oga09='4' OR oga_file.oga09='6') 
                      AND oga_file.ogaconf='Y'
                 END IF     
               END IF
               IF SQLCA.sqlcode THEN 
                  CALL cl_err3("sel","oga_file",g_adl[l_ac].adl03,"",SQLCA.sqlcode,"","",1)   #FUN-660104
                  LET g_adl[l_ac].adl03 = g_adl_t.adl03
                  DISPLAY BY NAME g_adl[l_ac].adl03
                  NEXT FIELD adl03
               END IF
 
            END IF
 
        AFTER FIELD adl04
            IF NOT cl_null(g_adl[l_ac].adl04) THEN
               CALL t204_adl04('d')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adl[l_ac].adl04 = g_adl_t.adl04
                  DISPLAY BY NAME g_adl[l_ac].adl04
                  NEXT FIELD adl04
               END IF
               SELECT ima31,ima906 INTO g_ima31,g_ima906 FROM ima_file
                WHERE ima01=g_adl[l_ac].ogb04
               CALL t100_du_data_to_correct()
               CALL t100_set_entry_b()
               CALL t100_set_no_entry_b()
            ELSE 
               NEXT FIELD adl04
            END IF
     
        AFTER FIELD adl20
            IF cl_null(g_adl[l_ac].adl20) THEN
               NEXT FIELD adl20
            ELSE
               SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_adl[l_ac].adl20
               IF SQLCA.sqlcode=100 THEN
                  CALL cl_err(g_adl[l_ac].adl20,'afa-319',0)
                  NEXT FIELD adl20
               ELSE
                  IF l_gfeacti='N' THEN
                     CALl cl_err(g_adl[l_ac].adl20,'9028',0)
                     NEXT FIELD adl20
                  END IF
               END IF
               #No.FUN-BB0086--add--start--
               IF NOT cl_null(g_adl[l_ac].adl05) THEN
                  IF NOT t100_adl05_check(l_adl05) THEN 
                     LET g_adl20_t = g_adl[l_ac].adl20
                     NEXT FIELD adl20
                  END IF 
               END IF 
               LET g_adl20_t = g_adl[l_ac].adl20 
               #No.FUN-BB0086--add--end--
            END IF
 
        BEFORE FIELD adl05
            IF cl_null(g_adl[l_ac].adl11)THEN
               NEXT FIELD adl11 
            ELSE
               CASE
                  WHEN cl_null(g_adl[l_ac].adl03)
                       NEXT FIELD adl03
                  WHEN cl_null(g_adl[l_ac].adl04)
                       NEXT FIELD adl04
                  OTHERWISE
                       SELECT SUM(adl05),COUNT(*) INTO l_adl05,l_n FROM adl_file
                        WHERE adl03=g_adl[l_ac].adl03
                          AND adl04=g_adl[l_ac].adl04
                          AND adl11=g_adl[l_ac].adl11
                       IF STATUS THEN
                          CALL cl_err("sum(adl)",STATUS,0)
                       END IF 
                       IF l_n >0 THEN
                          LET l_adl05=g_ogb.ogb12-l_adl05
                          IF cl_null(g_adl[l_ac].adl05) THEN
                             LET g_adl[l_ac].adl05=l_adl05
                          END IF
                       ELSE
                          LET l_adl05=g_ogb.ogb12 
                          IF cl_null(g_adl[l_ac].adl05) THEN
                             LET g_adl[l_ac].adl05=l_adl05
                          END IF
                       END IF
               END CASE 
            END IF
 
        AFTER FIELD adl05
           IF NOT t100_adl05_check(l_adl05) THEN NEXT FIELD adl05 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start--
            #IF g_adl_t.adl05 IS NULL AND g_adl[l_ac].adl05 IS NOT NULL OR
            #   g_adl_t.adl05 IS NOT NULL AND g_adl[l_ac].adl05 IS NULL OR
            #   g_adl_t.adl05 <> g_adl[l_ac].adl05 THEN
            #   LET g_change='Y'     
            #END IF 
            #IF NOT cl_null(g_adl[l_ac].adl05) THEN
            #  IF g_adl[l_ac].adl05 < 0 THEN NEXT FIELD adl05 END IF
            #  IF g_adl[l_ac].adl05 > l_adl05 THEN
            #     CALL cl_err(g_adl[l_ac].adl05,'axd-004',0)
            #     NEXT FIELD adl05
            #  END IF
            #END IF
            #IF g_change='Y' THEN
            #   CALL t100_set_adl19()
            #END IF
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD adl15
            CALL t100_set_no_required_b1('')
 
        AFTER FIELD adl15  #第二單位
            IF g_adl_t.adl15 IS NULL AND g_adl[l_ac].adl15 IS NOT NULL OR
               g_adl_t.adl15 IS NOT NULL AND g_adl[l_ac].adl15 IS NULL OR
               g_adl_t.adl15 <> g_adl[l_ac].adl15 THEN
               LET g_change='Y'
            END IF
            IF NOT cl_null(g_adl[l_ac].adl15) THEN
               SELECT gfe02 INTO g_buf FROM gfe_file
                WHERE gfe01=g_adl[l_ac].adl15
                  AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_adl[l_ac].adl15,"",STATUS,"","gfe:",1)   #FUN-660104
                 NEXT FIELD adl15 
              END IF
              CALL s_du_umfchk(g_adl[l_ac].ogb04,'','','',                                                                          
                               g_ima31,g_adl[l_ac].adl15,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_adl[l_ac].adl15,g_errno,0)
                 NEXT FIELD adl15
              END IF
              IF cl_null(g_adl_t.adl15) OR g_adl_t.adl15 <> g_adl[l_ac].adl15 THEN
                 LET g_adl[l_ac].adl16=g_factor
              END IF
            END IF
            IF g_change='Y' THEN
               CALL t100_set_adl19()
            END IF
            CALL t100_set_required_b1('')
            CALL cl_show_fld_cont()
            #No.FUN-BB0086--add--start--
            IF NOT cl_null(g_adl[l_ac].adl15) AND NOT cl_null(g_adl[l_ac].adl17) THEN
               IF NOT t100_adl17_check(p_cmd,l_adl17) THEN 
                  LET g_adl15_t = g_adl[l_ac].adl15
                  NEXT FIELD adl17
               END IF  
            END IF
            LET g_adl15_t = g_adl[l_ac].adl15
            #No.FUN-BB0086--add--end--
           
        AFTER FIELD adl16  #第二轉換率
            IF g_adl_t.adl16 IS NULL AND g_adl[l_ac].adl16 IS NOT NULL OR
               g_adl_t.adl16 IS NOT NULL AND g_adl[l_ac].adl16 IS NULL OR
               g_adl_t.adl16 <> g_adl[l_ac].adl16 THEN
               LET g_change = 'Y'
            END IF
            IF NOT cl_null(g_adl[l_ac].adl16) THEN
               IF g_adl[l_ac].adl16 = 0 THEN
                  NEXT FIELD adl16
               END IF
            END IF
 
        BEFORE FIELD adl17
            IF (p_cmd='a' OR p_cmd='u') AND (g_ima906 MATCHES'[23]') THEN
               SELECT COUNT(*) INTO l_n FROM adl_file      #查找是否已存在相同出貨單中的同一料號
                WHERE adl11= g_adl[l_ac].adl11
                  AND adl03= g_adl[l_ac].adl03
                  AND adl04= g_adl[l_ac].adl04
              IF NOT cl_null(l_n) AND l_n>0 THEN
                 CALL t100_qty(g_adl[l_ac].ogb04,g_adl[l_ac].adl03,g_adl[l_ac].adl04,
                               g_adl[l_ac].adl11,'',g_ogb.ogb913)
                   RETURNING l_adl17                         #同一出貨單相同料號的派車量
                 IF g_adl[l_ac].adl15=g_ogb.ogb913 THEN
                    LET l_adl17 = g_ogb.ogb915-l_adl17
                 ELSE 
                    CALL s_umfchk(g_adl[l_ac].adl04,g_adl[l_ac].adl15,g_ogb.ogb913)
                         RETURNING l_flag,l_factor
                    IF l_flag THEN
                       CALL cl_err ('',"abm-731",0)
                       NEXT FIELD adl15
                     ELSE
                       LET l_adl17=(g_ogb.ogb915-l_adl17)*l_factor
                     END IF
                 END IF
                 IF cl_null(g_adl[l_ac].adl17) THEN
                    LET g_adl[l_ac].adl17 = l_adl17
                 END IF
              ELSE
                 LET l_adl17 = g_ogb.ogb915 
                 IF cl_null(g_adl[l_ac].adl17) THEN
                    LET g_adl[l_ac].adl17 =g_ogb.ogb915
                 END IF
              END IF
            END IF
 
 
        AFTER FIELD adl17 #單位二數量
           IF NOT t100_adl17_check(p_cmd,l_adl17) THEN NEXT FIELD adl17 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start--
            #IF p_cmd='a' THEN
            #   IF g_adl[l_ac].adl17>l_adl17 THEN
            #      CALL cl_err('',"atm-100",1)
            #      NEXT FIELD adl17
            #   END IF
            #ELSE
            #   IF g_adl[l_ac].adl17>g_adl_t.adl17+l_adl17 THEN
            #      CALL cl_err('',"atm-100",1)
            #      NEXT FIELD adl17
            #   END IF
            #END IF
            #IF g_adl_t.adl17 IS NULL AND g_adl[l_ac].adl17 IS NOT NULL OR
            #   g_adl_t.adl17 IS NOT NULL AND g_adl[l_ac].adl17 IS NULL OR
            #   g_adl_t.adl17 <> g_adl[l_ac].adl17 THEN
            #   LET g_change = 'Y'
            #END IF
            #IF NOT cl_null(g_adl[l_ac].adl17) THEN
            #   IF g_adl[l_ac].adl17 < 0 THEN
            #      CALL cl_err('','aim391',0)
            #      NEXT FIELD adl17
            #   END IF
            #   IF p_cmd = 'a' THEN
            #      IF g_ima906='3' THEN
            #         LET g_tot=g_adl[l_ac].adl17*g_adl[l_ac].adl16
            #         IF cl_null(g_adl[l_ac].adl14) OR g_adl[l_ac].adl14=0 THEN #CHI-960022
            #            LET g_adl[l_ac].adl14=g_tot*g_adl[l_ac].adl13
            #            DISPLAY BY NAME g_adl[l_ac].adl14                      #CHI-960022
            #         END IF                                                    #CHI-960022
            #      END IF
            #   END IF
            #END IF
            #IF g_change='Y' THEN
            #   CALL t100_set_adl19()   #設置計價數量
            #END IF
            #CALL cl_show_fld_cont()
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD adl12
            CALL t100_set_no_required_b1('')             
  
        AFTER FIELD adl12  #第一單位
            LET l_tf = ""  #FUN-BB0086 add
            IF g_adl_t.adl12 IS NULL AND g_adl[l_ac].adl12 IS NOT NULL OR
               g_adl_t.adl12 IS NOT NULL AND g_adl[l_ac].adl12 IS NULL OR
               g_adl_t.adl12 <> g_adl[l_ac].adl12 THEN
               LET g_change = 'Y'
               IF NOT cl_null(g_adl[l_ac].adl14) THEN                  #FUN-BB0086 add
                  CALL t100_adl14_check(p_cmd,l_adl14) RETURNING l_tf  #FUN-BB0086 add
               END IF                                                  #FUN-BB0086 add
            END IF
            IF NOT cl_null(g_adl[l_ac].adl12) THEN
               SELECT gfe02 INTO g_buf FROM gfe_file
                WHERE gfe01=g_adl[l_ac].adl12
                  AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_adl[l_ac].adl12,"",STATUS,"","gfe:",1)   #FUN-660104
                 NEXT FIELD adl12 
              END IF
              CALL s_du_umfchk(g_adl[l_ac].ogb04,'','','',
                               g_adl[l_ac].adl20,g_adl[l_ac].adl12,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_adl[l_ac].adl12,g_errno,0)
                 NEXT FIELD adl12
              END IF
              IF cl_null(g_adl_t.adl12) OR g_adl_t.adl12 <> g_adl[l_ac].adl12 THEN
                 LET g_adl[l_ac].adl13 = g_factor
              END IF
            END IF
            #No.FUN-BB0086--add--start--
            LET g_adl12_t = g_adl[l_ac].adl12
            IF NOT l_tf THEN
               NEXT FIELD adl14
            END IF 
            #No.FUN-BB0086--add--end--
        
        AFTER FIELD adl13     #第一單位轉換率
            IF g_adl_t.adl13 IS NULL AND g_adl[l_ac].adl13 IS NOT NULL OR
               g_adl_t.adl13 IS NOT NULL AND g_adl[l_ac].adl13 IS NULL OR
               g_adl_t.adl13 <> g_adl[l_ac].adl13 THEN
               LET g_change='Y' 
            END IF
            IF NOT cl_null(g_adl[l_ac].adl13) THEN
               IF g_adl[l_ac].adl13 = 0 THEN
                  NEXT FIELD adl13
               END IF
            END IF
           
        BEFORE FIELD adl14
            IF p_cmd='a' OR p_cmd='u' THEN
               SELECT COUNT(*) INTO l_n FROM adl_file
                WHERE adl11= g_adl[l_ac].adl11
                  AND adl03= g_adl[l_ac].adl03
                  AND adl04= g_adl[l_ac].adl04
              IF NOT cl_null(l_n) AND l_n>0 THEN
                 CALL t100_qty(g_adl[l_ac].ogb04,g_adl[l_ac].adl03,g_adl[l_ac].adl04,
                               g_adl[l_ac].adl11,g_ogb.ogb910,'')
                   RETURNING l_adl14
                 IF g_adl[l_ac].adl12=g_ogb.ogb910 THEN
                    LET l_adl14= g_ogb.ogb912-l_adl14
                 ELSE
                    CALL s_umfchk(g_adl[l_ac].adl04,g_adl[l_ac].adl12,g_ogb.ogb910)
                         RETURNING l_flag,l_factor
                    IF l_flag THEN
                       CALL cl_err ('',"abm-731",0)
                       NEXT FIELD adl12
                    ELSE 
                       LET l_adl14 =(g_ogb.ogb912-l_adl14)*l_factor
                    END IF
                 END IF
                 IF cl_null(g_adl[l_ac].adl14) THEN
                    LET g_adl[l_ac].adl14=l_adl14
                 END IF
              ELSE
                    LET l_adl14 = g_ogb.ogb912
                    IF cl_null(g_adl[l_ac].adl14) THEN
                       LET g_adl[l_ac].adl14=g_ogb.ogb912 
                    END IF
              END IF
           END IF
 
        AFTER FIELD adl14    #第一單位數量
           IF NOT t100_adl14_check(p_cmd,l_adl14) THEN NEXT FIELD adl14 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start--
            #IF p_cmd='a' THEN
            #   IF g_adl[l_ac].adl14>l_adl14 THEN
            #      CALL cl_err('',"atm-100",1)
            #      NEXT FIELD adl14
            #   END IF
            #ELSE 
            #   IF g_adl[l_ac].adl14>g_adl_t.adl14+l_adl14 THEN
            #      CALL cl_err('',"atm-100",1)
            #      NEXT FIELD adl14
            #   END IF
            #END IF
            #IF g_adl_t.adl14 IS NULL AND g_adl[l_ac].adl14 IS NOT NULL OR
            #   g_adl_t.adl14 IS NOT NULL AND g_adl[l_ac].adl14 IS NULL OR
            #   g_adl_t.adl14 <> g_adl[l_ac].adl14 THEN
            #   LET g_change='Y'
            #END IF
            #No.FUN-BB0086--mark--end-- 
       
        BEFORE FIELD adl18        
            CALL t100_set_no_required_b1('')                     
 
        AFTER FIELD adl18   #計價單位
            IF g_adl_t.adl18 IS NULL AND g_adl[l_ac].adl18 IS NOT NULL OR
               g_adl_t.adl18 IS NOT NULL AND g_adl[l_ac].adl18 IS NULL OR
               g_adl_t.adl18 <> g_adl[l_ac].adl18 THEN
               LET g_change='Y'
            END IF
            IF NOT cl_null(g_adl[l_ac].adl18) THEN
               SELECT gfe02 INTO g_buf FROM gfe_file
                WHERE gfe01=g_adl[l_ac].adl18
                  AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_adl[l_ac].adl18,"",STATUS,"","gfe:",1)   #FUN-660104
                 NEXT FIELD adl18 
              END IF
              CALL s_du_umfchk(g_adl[l_ac].ogb04,'','','',                                                                          
                               g_ima31,g_adl[l_ac].adl18,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_adl[l_ac].adl18,g_errno,0)
                 NEXT FIELD adl18
              END IF
              IF NOT cl_null(g_adl[l_ac].ogb04) THEN
                 IF g_adl_t.adl18 IS NULL OR g_adl_t.adl18 <> g_adl[l_ac].adl18 THEN
                    IF g_change = 'Y' THEN
                       CALL t100_set_adl19()
                    END IF
                 END IF
              END IF
              #No.FUN-BB0086--add--start---
              IF NOT t100_adl19_check() THEN 
                 LET g_adl18_t = g_adl[l_ac].adl18
                 NEXT FIELD adl19
              END IF 
              LET g_adl18_t = g_adl[l_ac].adl18
              #No.FUN-BB0086--add--end---
            END IF
        
        BEFORE FIELD adl19
            IF g_change='Y' THEN
               CALL t100_set_adl19()
            END IF
       
        AFTER FIELD adl19   #計價數量
           IF NOT t100_adl19_check() THEN NEXT FIELD adl19 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start---
            #IF NOT cl_null(g_adl[l_ac].adl19) THEN
            #   IF g_adl[l_ac].adl19 < 0 THEN
            #      CALL cl_err('','aim-391',0)
            #      NEXT FIELD adl19
            #   END IF
            #END IF
            #No.FUN-BB0086--mark--end---
              
        AFTER FIELD adl06
            IF g_adl[l_ac].adl06 < 0 THEN
               NEXT FIELD adl06
            END IF
        
        AFTER FIELD adl08 
            IF NOT cl_null(g_adl[l_ac].adl08) THEN
               IF g_adl[l_ac].adl08 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
                  CALL cl_err(g_adl[l_ac].adl08,'axd-006',0)
                  NEXT FIELD adl08
               END IF
               IF g_adl[l_ac].adl08 >= '2400' THEN
                  CALL cl_err(g_adl[l_ac].adl08,'axd-006',0)
                  NEXT FIELD adl08
               END IF
            END IF

       #MOD-C50049---S---
        AFTER FIELD adl10
            IF NOT cl_null(g_adl[l_ac].adl10) THEN
               IF g_adl[l_ac].adl10 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
                  CALL cl_err(g_adl[l_ac].adl10,'axd-006',0)
                  NEXT FIELD adl10
               END IF
               IF g_adl[l_ac].adl10 >= '2400' THEN
                  CALL cl_err(g_adl[l_ac].adl10,'axd-006',0)
                  NEXT FIELD adl10
               END IF
            END IF
       #MOD-C50049---E---
 
 
        AFTER FIELD adlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD adlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_adl_t.adl02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adl_file
                    WHERE adl01=g_adk.adk01 AND adl02 = g_adl_t.adl02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","adl_file",g_adl_t.adl02,"",SQLCA.sqlcode,"","",1)   #FUN-660104
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete OK"  
                CLOSE t204_bcl
                COMMIT WORK
            END IF
 
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adl[l_ac].* = g_adl_t.*
               CLOSE t204_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adl[l_ac].adl02,-263,1)
               LET g_adl[l_ac].* = g_adl_t.*
            ELSE
               IF g_sma.sma115='Y' THEN
                  CALL t100_set_origin_field()
               END IF
               UPDATE adl_file SET(adl02,adl03,adl04,adl05,adl06,
                                   adl07,adl08,adl09,adl10,adl11,
                                   adl12,adl13,adl14,adl15,adl16,
                                   adl17,adl18,adl19,adl20,
                                   adlud01,adlud02,adlud03,adlud04,adlud05,
                                   adlud06,adlud07,adlud08,adlud09,adlud10,
                                   adlud11,adlud12,adlud13,adlud14,adlud15)
                          =(g_adl[l_ac].adl02,g_adl[l_ac].adl03,
                            g_adl[l_ac].adl04,g_adl[l_ac].adl05,
                            g_adl[l_ac].adl06,g_adl[l_ac].adl07,
                            g_adl[l_ac].adl08,g_adl[l_ac].adl09,
                            g_adl[l_ac].adl10,g_adl[l_ac].adl11,
                            g_adl[l_ac].adl12,g_adl[l_ac].adl13,
                            g_adl[l_ac].adl14,g_adl[l_ac].adl15,
                            g_adl[l_ac].adl16,g_adl[l_ac].adl17,
                            g_adl[l_ac].adl18,g_adl[l_ac].adl19,
                            g_adl[l_ac].adl20, 
                            g_adl[l_ac].adlud01,g_adl[l_ac].adlud02,
                            g_adl[l_ac].adlud03,g_adl[l_ac].adlud04,
                            g_adl[l_ac].adlud05,g_adl[l_ac].adlud06,
                            g_adl[l_ac].adlud07,g_adl[l_ac].adlud08,
                            g_adl[l_ac].adlud09,g_adl[l_ac].adlud10,
                            g_adl[l_ac].adlud11,g_adl[l_ac].adlud12,
                            g_adl[l_ac].adlud13,g_adl[l_ac].adlud14,
                            g_adl[l_ac].adlud15)
 
                     WHERE CURRENT OF t204_bcl
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","adl_file",g_adl[l_ac].adl02,"",SQLCA.sqlcode,"","",1)   #FUN-660104
                  LET g_adl[l_ac].* = g_adl_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
    AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_adl[l_ac].* = g_adl_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_adl.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE t204_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30033 add
            CLOSE t204_bcl
            COMMIT WORK
        ON ACTION CONTROLN
            CALL t204_b_askkey()
            EXIT INPUT
 
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adl03)
                  IF g_adl[l_ac].adl11='1' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oga03_1"
                     LET g_qryparam.default1 = g_adl[l_ac].adl03
                     LET g_qryparam.default1 = g_adl[l_ac].adl04
                     CALL cl_create_qry() RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                     NEXT FIELD adl03
                  ELSE 
                     IF g_adl[l_ac].adl11='2' THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_oga03_2"
                        LET g_qryparam.default1 = g_adl[l_ac].adl03
                        LET g_qryparam.default1 = g_adl[l_ac].adl04
                        CALL cl_create_qry() RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                        NEXT FIELD adl03
                     END IF
                     IF g_adl[l_ac].adl11='3' THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_rvn01"
                        LET g_qryparam.arg1 = g_plant
                        LET g_qryparam.default1 = g_adl[l_ac].adl03
                        LET g_qryparam.default2 = g_adl[l_ac].adl04
                        CALL cl_create_qry() RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                        NEXT FIELD adl03
                     END IF
                  END IF
                WHEN INFIELD(adl04)
                  IF g_adl[l_ac].adl11='1' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oga03_1"
                     LET g_qryparam.default1 = g_adl[l_ac].adl03
                     LET g_qryparam.default1 = g_adl[l_ac].adl04
                     CALL cl_create_qry() RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                     NEXT FIELD adl04
                  ELSE 
                     IF g_adl[l_ac].adl11='2' THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_oga03_2"
                        LET g_qryparam.default1 = g_adl[l_ac].adl03
                        LET g_qryparam.default1 = g_adl[l_ac].adl04
                        CALL cl_create_qry() RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                        NEXT FIELD adl04
                     END IF
                     IF g_adl[l_ac].adl11='3' THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_rvn02"
                        LET g_qryparam.arg1 = g_plant
                        LET g_qryparam.default1 = g_adl[l_ac].adl03
                        LET g_qryparam.default2 = g_adl[l_ac].adl04
                        CALL cl_create_qry() RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                        NEXT FIELD adl04
                     END IF
                  END IF
                WHEN INFIELD(adl20)
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.form ="q_gfe"                                                                                  
                      LET g_qryparam.default1 = g_adl[l_ac].adl20                                                                   
                      LET g_qryparam.construct= 'N'                                                                                 
                      CALL cl_create_qry() RETURNING g_adl[l_ac].adl20                                                              
                      NEXT FIELD adl20                              
                WHEN INFIELD(adl15)
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.form ="q_gfe"                                                                                  
                      LET g_qryparam.default1 = g_adl[l_ac].adl15                                                                   
                      LET g_qryparam.construct= 'N'                                                                                 
                      CALL cl_create_qry() RETURNING g_adl[l_ac].adl15                                                              
                      NEXT FIELD adl15                              
                WHEN INFIELD(adl12)
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.form ="q_gfe"                                                                                  
                      LET g_qryparam.default1 = g_adl[l_ac].adl12                                                                   
                      LET g_qryparam.construct= 'N'                                                                                 
                      CALL cl_create_qry() RETURNING g_adl[l_ac].adl12                                                              
                      NEXT FIELD adl12                              
                WHEN INFIELD(adl18)
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.form ="q_gfe"                                                                                  
                      LET g_qryparam.default1 = g_adl[l_ac].adl18                                                                   
                      LET g_qryparam.construct= 'N'                                                                                 
                      CALL cl_create_qry() RETURNING g_adl[l_ac].adl18                                                              
                      NEXT FIELD adl18                              
           END CASE
 
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
 
        END INPUT
 
     LET g_adk.adkmodu = g_user
     LET g_adk.adkdate = g_today
     UPDATE adk_file SET adkmodu = g_adk.adkmodu,adkdate = g_adk.adkdate
      WHERE adk01 = g_adk.adk01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","upd adk",1)   #FUN-660104
     END IF
     DISPLAY BY NAME g_adk.adkmodu,g_adk.adkdate
 
    CLOSE t204_bcl
    COMMIT WORK
    CALL t204_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t204_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_adk.adk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM adk_file ",
                  "  WHERE adk01 LIKE '",l_slip,"%' ",
                  "    AND adk01 > '",g_adk.adk01,"'"
      PREPARE t100_pb1 FROM l_sql 
      EXECUTE t100_pb1 INTO l_cnt       
      
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
         CALL t100_v()
         IF g_adk.adkconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_adk.adkconf,"","","",g_void,g_adk.adkacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM adk_file WHERE adk01 = g_adk.adk01
         INITIALIZE g_adk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t204_delall()
    SELECT COUNT(*) INTO g_cnt FROM adl_file
        WHERE adl01 = g_adk.adk01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM adk_file WHERE adk01 = g_adk.adk01
    END IF
END FUNCTION
 
FUNCTION t204_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    CONSTRUCT l_wc ON adl02,adl11,adl03,adld04,adl20,adl05,adl15,adl16,
                      adl17,adl12,adl13,adl14,adl18,adl19,adl06,  #螢幕上取單身條件
                      adl07,adl08,adl09,adl10
                      ,adlud01,adlud02,adlud03,adlud04,adlud05
                      ,adlud06,adlud07,adlud08,adlud09,adlud10
                      ,adlud11,adlud12,adlud13,adlud14,adlud15
       FROM s_adl[1].adl02,s_adl[1].adl11,s_adl[1].adl03,s_adl[1].adl04,s_adl[1].adl20,s_adl[1].adl05,
            s_adl[1].adl15,s_adl[1].adl16,s_adl[1].adl17,s_adl[1].adl12,s_adl[1].adl13,s_adl[1].adl14,  #TQC-A40020 ADD adl17
            s_adl[1].adl18,s_adl[1].adl19,
            s_adl[1].adl06,s_adl[1].adl07,s_adl[1].adl08,s_adl[1].adl09,
            s_adl[1].adl10
            ,s_adl[1].adlud01,s_adl[1].adlud02,s_adl[1].adlud03
            ,s_adl[1].adlud04,s_adl[1].adlud05,s_adl[1].adlud06
            ,s_adl[1].adlud07,s_adl[1].adlud08,s_adl[1].adlud09
            ,s_adl[1].adlud10,s_adl[1].adlud11,s_adl[1].adlud12
            ,s_adl[1].adlud13,s_adl[1].adlud14,s_adl[1].adlud15
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adl03)
                  IF g_adl[l_ac].adl11='1' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oga03_1"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adl[1].adl03
                     NEXT FIELD adl03
                  ELSE 
                     IF g_adl[l_ac].adl11='2' THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_oga03_2"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO s_adl[1].adl03
                        NEXT FIELD adl03
                     END IF
                  END IF
                WHEN INFIELD(adl04)
                  IF g_adl[l_ac].adl11='1' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oga03_1"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adl[1].adl04
                     NEXT FIELD adl04
                  ELSE 
                     IF g_adl[l_ac].adl11='2' THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_oga03_2"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO s_adl[1].adl04
                        NEXT FIELD adl04
                     END IF
                  END IF
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
     END CONSTRUCT
    CALL t204_b_fill(l_wc)
END FUNCTION
 
FUNCTION t204_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
 
    LET g_sql =
     "SELECT adl02,adl11,adl03,adl04,'','','','','','','',adl20,adl05,",  #No.FUN-870007
       "       adl15,adl16,adl17,adl12,adl13,adl14,adl18,adl19,adl06,",
       "       adl07,adl08,adl09,adl10,",
       "       adlud01,adlud02,adlud03,adlud04,adlud05,",
       "       adlud06,adlud07,adlud08,adlud09,adlud10,",
       "       adlud11,adlud12,adlud13,adlud14,adlud15 ", 
       " FROM adl_file ",
       " WHERE adl01 = '",g_adk.adk01,"'"  # AND ",p_wc CLIPPED , #FUN-8B0123 mark
 
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY adl02 " 
    DISPLAY g_sql
 
 
    PREPARE t204_prepare2 FROM g_sql      #預備一下
    DECLARE adl_cs CURSOR FOR t204_prepare2
 
    #單身 ARRAY 乾洗
    CALL g_adl.clear()
    LET g_cnt = 1
    FOREACH adl_cs INTO g_adl[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)      
            EXIT FOREACH
        END IF
        LET l_ac = g_cnt
        CALL t204_adl04('d')
        SELECT ruc29 INTO g_adl[g_cnt].ruc29
          FROM ruc_file
         WHERE EXISTS (SELECT 1 FROM rvn_file
                        WHERE rvn03 = ruc02
                          AND rvn04 = ruc03
                          AND rvn01 = g_adl[g_cnt].adl03
                          AND rvn02 = g_adl[g_cnt].adl04)
 
        IF cl_null(g_adl[g_cnt].ruc29) THEN LET g_adl[g_cnt].ruc29 = 'N' END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL s_errmsg('','','','9035',0)     #No.FUN-710033                             
          EXIT FOREACH        #No.FUN-710033  
        END IF
    END FOREACH
    CALL g_adl.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t204_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adl TO s_adl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
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
         CALL t204_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t204_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t204_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t204_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t204_t('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t100_mu_ui()    #TQC-710032
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end
      ON ACTION actual_time
         LET g_action_choice="actual_time"
         EXIT DISPLAY
      #@ON ACTION 其他托運物品
      ON ACTION btn01
         LET g_action_choice="btn01"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t204_copy()
DEFINE
    l_newno         LIKE adk_file.adk01,
    l_oldno         LIKE adk_file.adk01
DEFINE li_result   LIKE type_file.num5        #No.FUN-550026        #No.FUN-680120 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL t204_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM adk01
	  BEFORE INPUT
	     CALL cl_set_docno_format("adk01")
 
        AFTER FIELD adk01
            IF l_newno IS NULL THEN
                NEXT FIELD adk01
            END IF
    #CALL s_check_no("axm",l_newno,"","19","adk_file","adk01","") #FUN-A70130
    CALL s_check_no("atm",l_newno,"","U8","adk_file","adk01","") #FUN-A70130
         RETURNING li_result,l_newno
    DISPLAY l_newno TO adk01
       IF (NOT li_result) THEN
          NEXT FIELD adk01
       END IF
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adk01)        #need modify
                    LET g_t1 = s_get_doc_no(l_newno)       #No.FUN-550026
                    CALL q_adz(FALSE,FALSE,g_t1,19,'ATM') RETURNING g_t1  #TQC-670008
                    LET l_newno = g_t1       #No.FUN-550026
                    DISPLAY l_newno TO adk01
                    NEXT FIELD adk01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM adk_file
        WHERE adk01=g_adk.adk01
        INTO TEMP y
    UPDATE y
        SET y.adk01=l_newno,    #資料鍵值
            y.adkuser = g_user,
            y.adkgrup = g_grup,
            y.adkoriu = g_user,     #TQC-A30041 ADD
            y.adkorig = g_grup,     #TQC-A30041 ADD
            y.adkdate = g_today,
            y.adkacti = 'Y',
            y.adkconf = 'N'
    INSERT INTO adk_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","adk_file",l_newno,"",SQLCA.sqlcode,"","",1)   #FUN-660104
    END IF
    DROP TABLE x
    SELECT * FROM adl_file
       WHERE adl01 = g_adk.adk01
       INTO TEMP x
    UPDATE x
       SET adl01 = l_newno
    INSERT INTO adl_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","adl_file",l_newno,"",SQLCA.sqlcode,"","",1)   #FUN-660104
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_adk.adk01
        SELECT * INTO g_adk.* FROM adk_file
               WHERE adk01 =  l_newno
        CALL t204_u()
        CALL t204_show()
        #FUN-C80046---begin
        #LET g_adk.adk01 = l_oldno
        #SELECT * INTO g_adk.* FROM adk_file
        #       WHERE adk01 = g_adk.adk01
        #CALL t204_show()
        #FUN-C80046---end
    END IF
    DISPLAY BY NAME g_adk.adk01
END FUNCTION
 
FUNCTION t204_y() #確認
    IF g_adk.adk01 IS NULL THEN RETURN END IF
    IF g_adk.adk08 IS NULL THEN RETURN END IF
#CHI-C30107 --------------- add ---------------- begin
    IF g_adk.adkconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_adk.adkconf='Y' THEN RETURN END IF
    IF g_adk.adkacti='N' THEN RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM adm_file WHERE adm01 = g_adk.adk01
    IF g_cnt = 0 THEN
       IF NOT cl_confirm('axd-015') THEN RETURN END IF
    ELSE
       IF NOT cl_confirm('axm-108') THEN RETURN END IF
    END IF
#CHI-C30107 --------------- add ---------------- end
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_adk.adkconf='Y' THEN RETURN END IF
    IF g_adk.adkacti='N' THEN RETURN END IF
 
    CALL t204_oby()
    IF NOT cl_null(g_errno)  THEN
       CALL cl_err('',g_errno,0)
       RETURN
    END IF
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        CLOSE t204_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL t204_y1()
    IF SQLCA.SQLCODE THEN LET g_success='N' END IF
 
    IF g_success = 'Y' THEN
       UPDATE adk_file SET adkconf='Y',adk17='1'
                          ,adkconu=g_user,adkcond=g_today            #TQC-A40020 ADD
        WHERE adk01 = g_adk.adk01
       IF STATUS THEN
          CALL cl_err3("upd","adk_file",g_adk.adk01,"",STATUS,"","upd adkconf",1)   #FUN-660104
          ROLLBACK WORK
          RETURN
       ELSE
         COMMIT WORK
       END IF
    ELSE
       ROLLBACK WORK
       RETURN
    END IF
    SELECT adkconf,adk17,adkcond,adkconu INTO g_adk.adkconf,g_adk.adk17,g_adk.adkcond,g_adk.adkconu FROM adk_file
        WHERE adk01 = g_adk.adk01
    DISPLAY BY NAME g_adk.adkconf
    DISPLAY BY NAME g_adk.adkcond
    DISPLAY BY NAME g_adk.adkconu
    CALL t204_gen02('d','6')#CHI-D20015 add
#    DISPLAY BY NAME g_adk.adk17                                      #FUN-B30029 mark
    CALL t204_adk17()
END FUNCTION
 
FUNCTION t204_y1()
  DEFINE b_adl RECORD
               adl02  LIKE adl_file.adl02,   #項次
               adl03  LIKE adl_file.adl03,   #撥出單號
               adl04  LIKE adl_file.adl04,   #撥出單項次
               adl05  LIKE adl_file.adl05    #撥出數量
               END RECORD
 
  #對于adl中的每一筆都要insert到adq_file中
  DECLARE t204_y1_c1 CURSOR FOR
   SELECT adl02,adl03,adl04,adl05 FROM adl_file WHERE adl01=g_adk.adk01
  CALL s_showmsg_init()   #No.FUN-710033 
  FOREACH t204_y1_c1 INTO b_adl.*
      IF STATUS THEN EXIT FOREACH END IF
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
      IF cl_null(b_adl.adl03) THEN CONTINUE FOREACH END IF
      CALL t204_y2(b_adl.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
 
END FUNCTION
 
FUNCTION t204_y2(p_adl)
  DEFINE p_adl   RECORD
                 adl02  LIKE adl_file.adl02,   #項次
                 adl03  LIKE adl_file.adl03,   #撥出單號
                 adl04  LIKE adl_file.adl04,   #撥出單項次
                 adl05  LIKE adl_file.adl05    #撥出數量
                 END RECORD,
         l_buf   LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(100)
         l_adl05 LIKE adl_file.adl05,
         l_adg12 LIKE adg_file.adg12
 
  SELECT adg12-adg17 INTO l_adg12 FROM adg_file,adf_file   #當前撥出單總數量
   WHERE adg01 = p_adl.adl03 AND adg02 = p_adl.adl04 
     AND adf01 = adg01 AND adfacti = 'Y'
     AND adf10 = '1'
 
  SELECT SUM(adl05) INTO l_adl05 FROM adl_file,adk_file   #已撥出數量
   WHERE adk01 = adl01
     AND adl01 <> g_adk.adk01
     AND adl03 = p_adl.adl03
     AND adl04 = p_adl.adl04
     AND adkacti = 'Y'
     AND adkconf = 'Y'
   GROUP BY adl03,adl04
 
  IF l_adl05 + p_adl.adl05 > l_adg12 THEN
     LET l_buf = p_adl.adl03 CLIPPED,' ',p_adl.adl04 CLIPPED,
                 ' ',p_adl.adl05 CLIPPED               
     CALL s_errmsg('','',l_buf CLIPPED,'axd-009',1)  #No.FUN-710033
     LET g_success = 'N' RETURN
  END IF
END FUNCTION
 
FUNCTION t204_z() #取消確認
    IF g_adk.adk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_adk.adkconf='N' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        CLOSE t204_cl
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE adk_file SET adkconf='N',adk17='0'
                      #,adkconu='',adkcond=''       #TQC-A40020 ADD#CHI-D20015 mark
                       ,adkconu=g_user,adkcond = g_today #CHI-D20015 add
        WHERE adk01 = g_adk.adk01
    IF STATUS THEN
        CALL cl_err3("upd","adk_file",g_adk.adk01,"",STATUS,"","upd cofconf",1)   #FUN-660104
        LET g_success='N'
    END IF
    CALL s_showmsg()        #No.FUN-710033 
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT adkconf,adk17,adkconu,adkcond INTO g_adk.adkconf,g_adk.adk17,g_adk.adkconu,g_adk.adkcond FROM adk_file           #TQC-A40020 ADD
        WHERE adk01 = g_adk.adk01
    DISPLAY BY NAME g_adk.adkconf
    DISPLAY BY NAME g_adk.adkcond           #TQC-A40020 ADD
    DISPLAY BY NAME g_adk.adkconu           #TQC-A40020 ADD
    CALL t204_gen02('d','6')#CHI-D20015 add
#    DISPLAY BY NAME g_adk.adk17                                    #FUN-B30029  mark
    CALL t204_adk17()
END FUNCTION
 
FUNCTION t204_prt()
   IF cl_confirm('mfg3242') THEN CALL t204_out('a') END IF
END FUNCTION
 
FUNCTION t204_out(p_cmd)
   DEFINE l_cmd         LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(200)
          p_cmd         LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_prog        LIKE zaa_file.zaa01,          #No.FUN-680120 VARCHAR(10)
          l_wc,l_wc2    LIKE zz_file.zz21,           #No.FUN-680120 VARCHAR(50)
          l_prtway      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_lang        LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)  #No:6715可選擇列印(0.中文/1.英文/2.簡體)
 
   IF cl_null(g_adk.adk01) THEN CALL cl_err('','-400',0) RETURN END IF
   MENU ""
        ON ACTION Vehicle_Dispatching_List
                 LET l_prog='atmr170'
                 EXIT MENU
        ON ACTION Vehicle_Dispatching_Detail_List
                 LET l_prog='atmr171'
                 EXIT MENU
 
       ON ACTION exit
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
   END MENU
   IF NOT cl_null(l_prog) THEN #BugNo:5548
      IF l_prog = 'atmr170' OR p_cmd = 'a' THEN
         LET l_wc='adk01="',g_adk.adk01,'"'
      ELSE
         LET l_wc=g_wc CLIPPED,' AND ',g_wc2
      END IF
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
       WHERE zz01 = l_prog
      IF SQLCA.sqlcode OR l_wc2 IS NULL OR l_wc = ' ' THEN
         LET l_wc2 = " 'Y' 'Y' 'Y' "
      END IF
      LET l_cmd = l_prog CLIPPED,
              " '",g_today CLIPPED,"' '",g_user,"' ", #TQC-610088
              " '",g_lang CLIPPED,"' 'Y' ' ' '1'",    #TQC-610088
              " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   END IF
END FUNCTION
 
 
FUNCTION t204_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adk01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t204_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("adk01",FALSE)
       END IF
   END IF
 
END FUNCTION
 
FUNCTION t100_set_adl19()
  DEFINE      l_item    LIKE ima_file.ima01,      #料號
              l_ima25   LIKE ima_file.ima25,      #ima單位
              l_ima31   LIKE ima_file.ima31,      #ima單位
              l_ima906  LIKE ima_file.ima906,     
              l_fac2    LIKE ima_file.ima21,      #第二轉換率
              l_qty2    LIKE img_file.img10,      #第二數量  
              l_fac1    LIKE img_file.img21,      #第一轉換率 
              l_qty1    LIKE img_file.img10,      #第一數量 
              l_tot     LIKE img_file.img10,      #計價數量 
              l_factor  LIKE oeb_file.oeb12       #No.FUN-680120 DECIMAL(16,8)
 
    SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906 
      FROM ima_file WHERE ima01=g_adl[l_ac].ogb04
    IF SQLCA.sqlcode = 100 THEN 
       IF g_adl[l_ac].ogb04 MATCHES 'MISC*' THEN 
          SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF   
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF
       
    LET l_fac2=g_adl[l_ac].adl16
    LET l_qty2=g_adl[l_ac].adl17
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_adl[l_ac].adl13
       LET l_qty1=g_adl[l_ac].adl14
    ELSE
       LET l_fac1=1
       LET l_qty1=g_adl[l_ac].adl05
       CALL s_umfchk(g_adl[l_ac].ogb04,g_adl[l_ac].adl20,l_ima31)
            RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF                                                                                     
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF                                                                                     
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF                                                                                     
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF   
    IF g_sma.sma115 = 'Y' THEN                                                                                                      
       CASE l_ima906                                                                                                                
          WHEN '1' LET l_tot=l_qty1*l_fac1                                                                                          
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2                                                                            
          WHEN '3' LET l_tot=l_qty1*l_fac1                                                                                          
       END CASE                                                                                                                     
    ELSE  #不使用雙單位                                                                                                             
       LET l_tot=l_qty1*l_fac1                                                                                                      
    END IF                                                                                                                          
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF                                                                                     
    LET l_factor = 1                    
    IF g_sma.sma115='Y' THEN
       CALL s_umfchk(g_adl[l_ac].ogb04,g_adl[l_ac].adl20,g_adl[l_ac].adl18)
             RETURNING g_cnt,l_factor
    ELSE
    CALL s_umfchk(g_adl[l_ac].ogb04,l_ima31,g_adl[l_ac].adl18)
          RETURNING g_cnt,l_factor                                                                                                  
    END IF                                #No.CHI-960052
    IF g_cnt = 1 THEN                                                                                                               
       LET l_factor = 1                                                                                                             
    END IF                                                                                                                          
    LET l_tot = l_tot * l_factor
    LET g_adl[l_ac].adl19=l_tot
    LET g_adl[l_ac].adl19 = s_digqty(g_adl[l_ac].adl19,g_adl[l_ac].adl18) #FUN-BB0086 add
 
END FUNCTION
 
FUNCTION t100_set_required_b1(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
  IF g_sma.sma115 = 'Y' THEN
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_adl[l_ac].ogb04 
     IF g_ima906 = '3' THEN 
        CALL cl_set_comp_required("adl15,adl17,adl12,adl14",TRUE)
     END IF
     IF NOT cl_null(g_adl[l_ac].adl12) THEN
         CALL cl_set_comp_required("adl14",TRUE)
     END IF
     IF NOT cl_null(g_adl[l_ac].adl15) AND g_ima906 MATCHES '[23]' THEN
        CALL cl_set_comp_required("adl17",TRUE)
     END IF
  END IF
  IF g_sma.sma116 MATCHES '[23]' THEN
     IF NOT cl_null(g_adl[l_ac].adl18) THEN
        CALL cl_set_comp_required("adl19",TRUE)
     END IF
  END IF
END FUNCTION
 
FUNCTION t100_set_no_required_b1(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
  IF g_sma.sma115 = 'Y' THEN
     CALL cl_set_comp_required("adl15,adl16,adl17,adl12,adl13,dal14",FALSE)
  END IF
  IF g_sma.sma116 MATCHES '[23]' THEN 
     CALL cl_set_comp_required("adl18,adl19",FALSE)
  END IF
 
END FUNCTION
 
FUNCTION t100_du_data_to_correct()
  
  IF cl_null(g_adl[l_ac].adl15) THEN
     LET g_adl[l_ac].adl16 = NULL
     LET g_adl[l_ac].adl17 = NULL
  END IF
 
  IF cl_null(g_adl[l_ac].adl12) THEN
     LET g_adl[l_ac].adl13 = NULL
     LET g_adl[l_ac].adl14 = NULL
  END IF
 
  DISPLAY BY NAME g_adl[l_ac].adl15
  DISPLAY BY NAME g_adl[l_ac].adl16
  DISPLAY BY NAME g_adl[l_ac].adl17
  DISPLAY BY NAME g_adl[l_ac].adl12
  DISPLAY BY NAME g_adl[l_ac].adl13
  DISPLAY BY NAME g_adl[l_ac].adl14
END FUNCTION
 
FUNCTION t100_mu_ui()
 
  CALL cl_set_comp_visible("adl16,adl13",FALSE)
 
  IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("adl15,adl16,adl17",FALSE)
      CALL cl_set_comp_visible("adl12,adl13,adl14",FALSE)
   ELSE                                                                                                                             
      CALL cl_set_comp_visible("adl20,adl05",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[01]' THEN
      CALL cl_set_comp_visible("adl18,adl19",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN                                                                                                       
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl15",g_msg CLIPPED)                                                                            
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl17",g_msg CLIPPED)                                                                            
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl12",g_msg CLIPPED)                                                                            
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl14",g_msg CLIPPED)                                                                            
   END IF  
   IF g_sma.sma122 ='2' THEN                                                                                                       
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl15",g_msg CLIPPED)                                                                            
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl17",g_msg CLIPPED)                                                                            
      CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl12",g_msg CLIPPED)                                                                            
      CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg                                                                             
      CALL cl_set_comp_att_text("adl14",g_msg CLIPPED)                                                                            
   END IF  
END FUNCTION
 
FUNCTION t100_set_entry_b()
  IF g_sma.sma115='Y' THEN
     CALL cl_set_comp_entry("adl15,adl17,adl19",TRUE)
  END IF

 #MOD-C50049---S---
  CALL cl_set_comp_entry("adl02,adl11,adl03,adl04,oga04,occ02,oga044,
                          ogb04,ogb06,ima021,adl20,adl05,adl15,adl16,
                          adl17,adl12,adl13,adl14,adl18,adl19,adl06,
                          adl07,adl08",TRUE)
 #MOD-C50049---E---
 
END FUNCTION
 
FUNCTION t100_set_no_entry_b()
  IF g_sma.sma115 = 'Y' THEN
     CASE
       WHEN g_ima906 = '1'
         CALL cl_set_comp_entry("adl15,adl16,adl17",FALSE)
       WHEN g_ima906 = '2'
         CALL cl_set_comp_entry("adl13,adl16",FALSE)
       WHEN g_ima906 = '3'
         CALL cl_set_comp_entry("adl15",FALSE)
       OTHERWISE EXIT CASE
     END CASE
  END IF
  IF g_sma.sma116 MATCHES '[01]' THEN
     CALL cl_set_comp_entry("adl18,adl19",FALSE)
  END IF
 
END FUNCTION
 
#統計已有數量
FUNCTION t100_qty(p_ogb04,p_adl03,p_adl04,p_adl11,p_adl12,p_adl15)
  DEFINE l_sql1     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(1000)
         l_flag     LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         l_factor   LIKE oeb_file.oeb12,          #No.FUN-680120 DECIMAL(16,8) 
         l_n        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         p_ogb04    LIKE ogb_file.ogb04,
         p_adl03    LIKE adl_file.adl03,
         p_adl04    LIKE adl_file.adl04,
         p_adl11    LIKE adl_file.adl11,
         p_adl12    LIKE adl_file.adl12,
         p_adl15    LIKE adl_file.adl15,
  l_adl             RECORD
           adl12    LIKE adl_file.adl12,
           adl13    LIKE adl_file.adl13,
           adl14    LIKE adl_file.adl14,
           adl15    LIKE adl_file.adl15,
           adl16    LIKE adl_file.adl16,
           adl17    LIKE adl_file.adl17
                    END RECORD,
         t_adl14    LIKE adl_file.adl14,
         t_adl17    LIKE adl_file.adl17
 
  LET t_adl14 = 0
  LET t_adl17 = 0
  LET l_sql1=" SELECT adl12,adl13,adl14,adl15,adl16,adl17 ",
             " FROM adl_file ",
             " WHERE adl03= '",p_adl03,"'",
             " AND   adl04= '",p_adl04,"'",
             " AND   adl11= '",p_adl11,"'"
  PREPARE t100_qty_prepare FROM l_sql1
  IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
     EXIT PROGRAM 
  END IF
  DECLARE t100_qty_cs CURSOR FOR t100_qty_prepare
 
  FOREACH t100_qty_cs INTO l_adl.*
     IF SQLCA.sqlcode then
        CALL cl_err('FOREACH:',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
     IF cl_null(l_adl.adl14) THEN
        LET l_adl.adl14=0
     END IF
     IF cl_null(l_adl.adl17) THEN
        LET l_adl.adl17=0
     END IF
     IF NOT cl_null(p_adl12) AND (l_adl.adl12 != p_adl12 )THEN
        CALL s_umfchk(p_ogb04,p_adl12,l_adl.adl12)
             RETURNING l_flag,l_factor
        IF l_flag THEN
           CALL cl_err('',"abm-731",1)
           EXIT FOREACH
        ELSE
           LET l_adl.adl14 = l_adl.adl14 * l_factor
        END IF             
     END IF
     IF NOT cl_null(p_adl15) and (l_adl.adl15 != p_adl15) THEN
        CALL s_umfchk(p_ogb04,p_adl15,l_adl.adl15)
             RETURNING l_flag,l_factor
        IF l_flag THEN
           CALL cl_err('',"abm-731",1)
           EXIT FOREACH
        ELSE
           LET l_adl.adl17 = l_adl.adl17 * l_factor
        END IF
     END IF
     IF NOT cl_null(p_adl12) THEN
        LET t_adl14 = t_adl14+l_adl.adl14
     END IF
     IF NOT cl_null(p_adl15) THEN
        LET t_adl17 = t_adl17+l_adl.adl17
     END IF
  END FOREACH
 
  IF cl_null(p_adl15) AND cl_null(p_adl12) THEN
     LET t_adl17=NULL
     RETURN t_adl17
  END IF
  IF NOT cl_null(p_adl15) THEN
     RETURN t_adl17
  END IF  
  IF NOT cl_null(p_adl12) THEN
     RETURN t_adl14
  END IF
END FUNCTION
 
FUNCTION t100_set_origin_field()                                                                                              
   DEFINE l_ima906   LIKE ima_file.ima906,                                                                                          
          l_ima907   LIKE ima_file.ima907,                                                                                          
          l_img09    LIKE img_file.img09,     #img單位                                                                              
          l_tot      LIKE img_file.img10,                                                                                           
          l_fac2     LIKE adl_file.adl16,                                                                                          
          l_qty2     LIKE adl_file.adl17,                                                                                          
          l_fac1     LIKE adl_file.adl13,                                                                                          
          l_qty1     LIKE adl_file.adl14,                                                                                          
          l_factor   LIKE oeb_file.oeb12,      #No.FUN-680120 DECIMAL(16,8)                                                                                           
          l_ima25    LIKE ima_file.ima25,      
          l_ima31    LIKE ima_file.ima31,                                                                                           
          p_code     LIKE type_file.chr1       #No.FUN-680120 VARCHAR(01)                                                                                                
                                                                                                                                    
   IF g_sma.sma115 = 'N' THEN                                                                                                       
      RETURN                                                                                                                        
   END IF                                                                                                                           

   SELECT ima25,ima31 INTO l_ima25,l_ima31                                                                                          
     FROM ima_file                                                                                                                  
    WHERE ima01 = g_adl[l_ac].ogb04                                                                                                 
   IF SQLCA.sqlcode = 100 THEN                                                                                                      
      IF g_adl[l_ac].ogb04 MATCHES 'MISC*' THEN                                                                                     
         SELECT ima25,ima31 INTO l_ima25,l_ima31                                                                                    
           FROM ima_file
          WHERE ima01='MISC'                                                                                                        
      END IF                                                                                                                        
   END IF                                                                                                                           
                               
   IF cl_null(l_ima31) THEN     
      LET l_ima31 = l_ima25      
   END IF                         
                                   
   LET l_fac2 = g_adl[l_ac].adl16   
   LET l_qty2 = g_adl[l_ac].adl17    
   LET l_fac1 = g_adl[l_ac].adl13     
   LET l_qty1 = g_adl[l_ac].adl14      
                                        
   IF cl_null(l_fac1) THEN LET l_fac1 = 1 END IF                                                                                    
   IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF                                                                                    
   IF cl_null(l_fac2) THEN LET l_fac2 = 1 END IF                                                                                    
   IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF                                                                                    
                                                                                                                                    
   IF g_sma.sma115 = 'Y' THEN                                                                                                       
      CASE g_ima906                                                                                                                 
         WHEN '1' LET g_adl[l_ac].adl20 = g_adl[l_ac].adl12                                                                        
                  LET g_adl[l_ac].adl05 = l_qty1
         WHEN '2' LET l_tot = l_fac1 * l_qty1 + l_fac2 * l_qty2                                                                     
                  LET g_adl[l_ac].adl20 = l_ima31                                                                                   
                  LET g_adl[l_ac].adl05 = l_tot  
 		  LET g_adl[l_ac].adl05 = s_digqty(g_adl[l_ac].adl05,g_adl[l_ac].adl20)   #No.FUN-BB0086                                                                                   
         WHEN '3' LET g_adl[l_ac].adl20 = g_adl[l_ac].adl12                                                                        
                  LET g_adl[l_ac].adl05 = l_qty1                                                                                    
                  IF l_qty2 <> 0 THEN                                                                                               
                     LET g_adl[l_ac].adl16 = l_qty1 / l_qty2                                                                       
                  ELSE                                                                                                              
                     LET g_adl[l_ac].adl16 = 0                                                                                     
                  END IF                                                                                                            
      END CASE                                                                                                                      
   END IF                                                                                                                           
                                                                                                                                    
   LET g_factor = 1                                                                                                                 
                                                                                                                                    
   CALL s_umfchk(g_adl[l_ac].ogb04,g_adl[l_ac].adl20,l_ima25)                                                                       
       RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN                                                                                                                
      LET g_factor = 1                                                                                                              
   END IF                                                                                                                           
                                                                                                                                    

END FUNCTION     
 
FUNCTION t100_time()
  DEFINE l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         l_lock_sw       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
         l_time          LIKE type_file.chr8,          #No.FUN-680120 VARCHAR(8)
         l_ac_t          LIKE type_file.num5,          #No.FUN-680120 SMALLINT
         l_adl02_t       LIKE adl_file.adl02,
         l_adl09_t       LIKE adl_file.adl09,
         l_adl10_t       LIKE adl_file.adl10
 
  IF s_shut(0) THEN RETURN END IF
 
  IF g_adk.adk01 IS NULL THEN
     RETURN
  END IF
 
  SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
 
  IF g_adk.adk17!='1' THEN
     CALL cl_err('',"amm-109",0)
     RETURN
  END IF
 
    LET g_forupd_sql=" SELECT adl02,adl11,adl03,adl04,'','','','','','','',adl20,adl05,", #No.FUN-870007
                     "        adl15,adl16,adl17,adl12,adl13,adl14,adl18,adl19,", 
                     "        adl06,adl07,adl08,adl09,adl10",
                     "   FROM adl_file",                   
                     "   WHERE adl02 = ?  AND adl01=?",                                                                                 
                     "    FOR UPDATE"                                                                                               
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t204_bc2 CURSOR FROM g_forupd_sql
 
     INPUT ARRAY g_adl WITHOUT DEFAULTS FROM s_adl.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE ,DELETE ROW=FALSE ,APPEND ROW=FALSE )
       BEFORE INPUT
         DISPLAY "BEFORE INPUT actualtime"
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         
       BEFORE ROW
         DISPLAY "BEFORE ROW actualtime"
         LET l_ac = ARR_CURR()
         LET l_n = ARR_COUNT()
         LET l_lock_sw = 'N' 
         BEGIN WORK
         OPEN t204_cl USING g_adk.adk01
         IF STATUS THEN
            CALL cl_err("OPEN t204_cl:", STATUS, 1)
            CLOSE t204_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t204_cl INTO g_adk.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
            CLOSE t204_cl ROLLBACK WORK RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET l_adl09_t = g_adl[l_ac].adl09
            LET l_adl09_t = g_adl[l_ac].adl09
            OPEN t204_bc2 USING g_adl[l_ac].adl02,g_adk.adk01
            IF STATUS THEN
               CALL cl_err("OPEN t204_bc2:", STATUS, 1)
               LET l_lock_sw='Y'
            ELSE
               FETCH t204_bc2 INTO g_adl[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adl_t.adl02,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               END IF
               CALL t204_adl04('d')
               SELECT ruc29 INTO g_adl[l_ac].ruc29
                 FROM ruc_file
                WHERE EXISTS (SELECT 1 FROM rvn_file
                               WHERE rvn03 = ruc02
                                 AND rvn04 = ruc03
                                 AND rvn01 = g_adl[l_ac].adl03
                                 AND rvn02 = g_adl[l_ac].adl04)
            END IF
            CALL cl_show_fld_cont()
          END IF
   
       BEFORE FIELD adl02
         CALL t100_set_entry_b1()
         CALL t100_set_no_entry_b1()
   
       BEFORE FIELD adl09
         IF g_adl[l_ac].adl09 IS NULL THEN
            LET g_adl[l_ac].adl09 = g_today
         END IF
 
       BEFORE FIELD adl10
         IF g_adl[l_ac].adl10 IS NULL THEN
            LET l_time=TIME
            LET g_adl[l_ac].adl10 = l_time[1,2],l_time[4,5]
         END IF
 
       AFTER FIELD adl10
         IF NOT cl_null(g_adl[l_ac].adl10) THEN
            IF g_adl[l_ac].adl10 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
               CALL cl_err(g_adl[l_ac].adl10,'axd-006',0)
               NEXT FIELD adl10
            END IF
            IF g_adl[l_ac].adl10 >= '2400' THEN
               CALL cl_err(g_adl[l_ac].adl10,'axd-006',0)
               NEXT FIELD adl10
            END IF
         END IF
         
       AFTER ROW
         DISPLAY "AFTER ROW actualtime"
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_adl[l_ac].adl09 = l_adl09_t
            LET g_adl[l_ac].adl10 = l_adl10_t
            CLOSE t204_bc2
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_adl[l_ac].adl02,-263,1)
            LET g_adl[l_ac].adl09 = l_adl09_t
            LET g_adl[l_ac].adl10 = l_adl10_t
         ELSE
            UPDATE adl_file
               SET (adl09,adl10) = (g_adl[l_ac].adl09,g_adl[l_ac].adl10)
             WHERE CURRENT OF t204_bc2
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","adl_file",g_adl[l_ac].adl02,"",SQLCA.sqlcode,"","",1)   #FUN-660104
               LET g_adl[l_ac].adl09 = l_adl09_t
               LET g_adl[l_ac].adl10 = l_adl10_t
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         CLOSE t204_bc2
         COMMIT WORK
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        
        ON ACTION help          
           CALL cl_show_help()  
 
     END INPUT
 
     LET g_adk.adkmodu = g_user
     LET g_adk.adkdate = g_today
     UPDATE adk_file SET adkmodu = g_adk.adkmodu,adkdate = g_adk.adkdate
      WHERE adk01 = g_adk.adk01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","upd adk",1)   #FUN-660104
     END IF
     DISPLAY BY NAME g_adk.adkmodu,g_adk.adkdate
     CLOSE t204_bc2
     COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t100_set_entry_b1()
    CALL cl_set_comp_entry("adl09,adl10",TRUE)
END FUNCTION
 
FUNCTION t100_set_no_entry_b1()
    CALL cl_set_comp_entry("adl02,adl11,adl03,adl04,oga04,occ02,oga044,
                            ogb04,ogb06,ima021,adl20,adl05,adl15,adl16,
                            adl17,adl12,adl13,adl14,adl18,adl19,adl06,
                            adl07,adl08",FALSE)
 
END FUNCTION
# No.FUN-9C0073 ---------------By chenls  10/01/08

#No.FUN-BB0086--add--start--
FUNCTION t100_adl05_check(l_adl05)
DEFINE l_adl05         LIKE adl_file.adl05
   IF NOT cl_null(g_adl[l_ac].adl05) AND NOT cl_null(g_adl[l_ac].adl20) THEN
      IF cl_null(g_adl_t.adl05) OR cl_null(g_adl20_t) OR g_adl_t.adl05 != g_adl[l_ac].adl05 OR g_adl20_t != g_adl[l_ac].adl20 THEN
         LET g_adl[l_ac].adl05=s_digqty(g_adl[l_ac].adl05,g_adl[l_ac].adl20)
         DISPLAY BY NAME g_adl[l_ac].adl05
      END IF
   END IF
   
   IF g_adl_t.adl05 IS NULL AND g_adl[l_ac].adl05 IS NOT NULL OR
      g_adl_t.adl05 IS NOT NULL AND g_adl[l_ac].adl05 IS NULL OR
      g_adl_t.adl05 <> g_adl[l_ac].adl05 THEN
      LET g_change='Y'     
   END IF 
   IF NOT cl_null(g_adl[l_ac].adl05) THEN
     IF g_adl[l_ac].adl05 < 0 THEN RETURN FALSE END IF
     IF g_adl[l_ac].adl05 > l_adl05 THEN
        CALL cl_err(g_adl[l_ac].adl05,'axd-004',0)
        RETURN FALSE 
     END IF
   END IF
   IF g_change='Y' THEN
      CALL t100_set_adl19()
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t100_adl14_check(p_cmd,l_adl14)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_adl14         LIKE adl_file.adl14
   IF NOT cl_null(g_adl[l_ac].adl14) AND NOT cl_null(g_adl[l_ac].adl12) THEN
      IF cl_null(g_adl_t.adl14) OR cl_null(g_adl12_t) OR g_adl_t.adl14 != g_adl[l_ac].adl14 OR g_adl12_t != g_adl[l_ac].adl12 THEN
         LET g_adl[l_ac].adl14=s_digqty(g_adl[l_ac].adl14,g_adl[l_ac].adl12)
         DISPLAY BY NAME g_adl[l_ac].adl14
      END IF
   END IF
   
   IF p_cmd='a' THEN
      IF g_adl[l_ac].adl14>l_adl14 THEN
         CALL cl_err('',"atm-100",1)
         RETURN FALSE 
      END IF
   ELSE 
      IF g_adl[l_ac].adl14>g_adl_t.adl14+l_adl14 THEN
         CALL cl_err('',"atm-100",1)
         RETURN FALSE 
      END IF
   END IF
   IF g_adl_t.adl14 IS NULL AND g_adl[l_ac].adl14 IS NOT NULL OR
      g_adl_t.adl14 IS NOT NULL AND g_adl[l_ac].adl14 IS NULL OR
      g_adl_t.adl14 <> g_adl[l_ac].adl14 THEN
      LET g_change='Y'
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t100_adl17_check(p_cmd,l_adl17)
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE l_adl17         LIKE adl_file.adl17
   IF NOT cl_null(g_adl[l_ac].adl17) AND NOT cl_null(g_adl[l_ac].adl15) THEN
      IF cl_null(g_adl_t.adl17) OR cl_null(g_adl15_t) OR g_adl_t.adl17 != g_adl[l_ac].adl17 OR g_adl15_t != g_adl[l_ac].adl15 THEN
         LET g_adl[l_ac].adl17=s_digqty(g_adl[l_ac].adl17,g_adl[l_ac].adl15)
         DISPLAY BY NAME g_adl[l_ac].adl17
      END IF
   END IF

   IF p_cmd='a' THEN
      IF g_adl[l_ac].adl17>l_adl17 THEN
         CALL cl_err('',"atm-100",1)
         RETURN FALSE 
      END IF
   ELSE
      IF g_adl[l_ac].adl17>g_adl_t.adl17+l_adl17 THEN
         CALL cl_err('',"atm-100",1)
         RETURN FALSE 
      END IF
   END IF
   IF g_adl_t.adl17 IS NULL AND g_adl[l_ac].adl17 IS NOT NULL OR
      g_adl_t.adl17 IS NOT NULL AND g_adl[l_ac].adl17 IS NULL OR
      g_adl_t.adl17 <> g_adl[l_ac].adl17 THEN
      LET g_change = 'Y'
   END IF
   IF NOT cl_null(g_adl[l_ac].adl17) THEN
      IF g_adl[l_ac].adl17 < 0 THEN
         CALL cl_err('','aim391',0)
         RETURN FALSE 
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_adl[l_ac].adl17*g_adl[l_ac].adl16
            IF cl_null(g_adl[l_ac].adl14) OR g_adl[l_ac].adl14=0 THEN #CHI-960022
               LET g_adl[l_ac].adl14=g_tot*g_adl[l_ac].adl13
               DISPLAY BY NAME g_adl[l_ac].adl14                      #CHI-960022
            END IF                                                    #CHI-960022
         END IF
      END IF
   END IF
   IF g_change='Y' THEN
      CALL t100_set_adl19()   #設置計價數量
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION 

FUNCTION t100_adl19_check()
   IF NOT cl_null(g_adl[l_ac].adl19) AND NOT cl_null(g_adl[l_ac].adl18) THEN
      IF cl_null(g_adl_t.adl19) OR cl_null(g_adl18_t) OR g_adl_t.adl19 != g_adl[l_ac].adl19 OR g_adl18_t != g_adl[l_ac].adl18 THEN
         LET g_adl[l_ac].adl19=s_digqty(g_adl[l_ac].adl19,g_adl[l_ac].adl18)
         DISPLAY BY NAME g_adl[l_ac].adl19
      END IF
   END IF
   
   IF NOT cl_null(g_adl[l_ac].adl19) THEN
      IF g_adl[l_ac].adl19 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION 
#No.FUN-BB0086--add--end--
#CHI-C80041---begin
FUNCTION t100_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_adk.adk01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t204_cl USING g_adk.adk01
   IF STATUS THEN
      CALL cl_err("OPEN t204_cl:", STATUS, 1)
      CLOSE t204_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t204_cl INTO g_adk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t204_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_adk.adkconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_adk.adkconf)   THEN 
        LET l_chr=g_adk.adkconf
        IF g_adk.adkconf='N' THEN 
            LET g_adk.adkconf='X' 
        ELSE
            LET g_adk.adkconf='N'
        END IF
        UPDATE adk_file
            SET adkconf=g_adk.adkconf,  
                adkmodu=g_user,
                adkdate=g_today
            WHERE adk01=g_adk.adk01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","adk_file",g_adk.adk01,"",SQLCA.sqlcode,"","",1)  
            LET g_adk.adkconf=l_chr 
        END IF
        DISPLAY BY NAME g_adk.adkconf
   END IF
 
   CLOSE t204_cl
   COMMIT WORK
   CALL cl_flow_notify(g_adk.adk01,'V')
 
END FUNCTION
#CHI-C80041---end
