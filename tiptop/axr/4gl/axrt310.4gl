# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: axrt310.4gl
# Descriptions...: 銷項發票維護
# Date & Author..: 96/05/14 By Roger
# Modify.........: 97/08/20 By sophia 發票日期修改update oma09
# Modify.........: No.A097 03/11/25 ching 紅字發票處理 append
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0049 04/12/09 By Nicola 權限控管修改
# Modify.........: No.MOD-520043 05/02/18 By Kitty 作廢的相關欄位應只能在作廢的功能鍵裡輸入
# Modify.........: No.FUN-560198 05/06/22 By ice 發票欄位加大后截位修改
# Modify.........: No.MOD-5A0210 05/10/21 By Smapmin 修改時稅率、聯式、課稅欄位應檢查是否與稅別之課稅別相同，
#                                                    避免造成發票資料與稅額不符
# Modify.........: No.MOD-5A0209 05/11/29 By Smapmin 作廢及刪除時要UPDATE oga54
# Modify.........: No.MOD-5C0155 05/12/29 By Smapmin 外銷時,統一編號可以不輸入
# Modify.........: No.MOD-630088 06/03/30 By Smampin 帳款類別為11時,不更新oga54
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.MOD-650036 06/05/09 By Carrier 發票刪除/作廢時,更新ogb60,CALL s_upd_ogb60
# Modify.........: No.FUN-650125 06/05/17 By Smapmin ome00已無2的選項
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-680123 06/08/29 By hongmei欄位類型轉換
# Modify.........: No.MOD-6A0018 06/10/17 By Smapmin 作廢理由碼開窗,應只開理由碼即可
# Modify.........: No.FUN-6A0095 06/11/06 By xumin l_time轉g_time
# Modify.........: No.MOD-6B0053 06/11/08 By Smampin 修改幣別取位問題
# Modify.........: No.FUN-6B0042 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6C0033 06/12/07 By Smapmin 銷退數量抓取計價數量
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-710085 07/04/13 By Smapmin 參數設定為帳款確認後才可開立發票時,未確認的帳款不可開立發票
# Modify.........: No.CHI-750012 07/05/09 By kim 刪除發票號,多帳期的發票號碼未刪除
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760006 07/06/04 By Smapmin 增加發票編號/發票日期/帳款編號相關控管,並回寫發票主檔/原帳款發票編號
# Modify.........: No.MOD-760035 07/06/13 By Smapmin 修改update oga54
# Modify.........: NO.MOD-760127 07/06/27 By Smapmin 取消update oha50
# Modify.........: No.TQC-790157 07/10/11 By Smapmin 修正MOD-760035
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810062 08/01/31 By Smapmin 帳款編號可能因為合併開發票而導致空白,故依照發票編號為回寫oga54等的依據
# Modify.........: No.MOD-830162 08/03/24 By Smapmin g_format要給初始值
# Modify.........: No.MOD-830227 08/03/27 By Smapmin 修改理由碼來源
# Modify.........: No.MOD-840115 08/04/15 By Smapmin 大陸的發票主檔起始與截止月份可能並非間隔二個月
# Modify.........: No.MOD-840126 08/04/16 By Smapmin 修改發票聯數/種類顯示
# Modify.........: No.FUN-850038 08/05/08 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE
# Modify.........: No.MOD-860321 08/06/27 By wujie 作廢時回寫沒有分是出貨還是銷退，全部回oga，需要分情況回寫
#                                                  取消作廢時，應該把作廢時從應收帳款資料中刪除的發票號碼還原，否則取消作廢后，不能再次作廢
# Modify.........: No.MOD-870032 08/07/08 By Sarah 延續MOD-5C0155,增加檢核ome08='1' AND ome212!='2'才需要檢核axr-410訊息
# Modify.........: No.TQC-870020 08/07/14 By lumx  修改發票日期的時候 發票主檔中的已開發票日期需要跟著變動
# Modify.........: No.MOD-870256 08/07/25 By Sarah 當oma33傳票編號不為NULL時,表示帳款已拋至總帳系統,不可修改/刪除/作廢發票
# Modify.........: No.TQC-880009 08/08/04 By chenyu b_omb-->l_omb
# Modify.........: No.MOD-880253 08/08/29 By Sarah aza26='0'時(台灣版),發票號碼檢核長度需輸入10碼
# Modify.........: No.MOD-8A0281 08/10/31 By Sarah 非大陸版才做ome171的檢核
# Modify.........: No.MOD-8B0274 08/11/26 By Sarah 程式裡若有要UPDATE oga_file,先判斷omb31是否有值,有值時才去UPDATE oga_file
# Modify.........: No.FUN-930106 09/03/19 By destiny omevoid2增加管控
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980093 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-970105 09/07/10 By Sarah 1.若是直接到axrt310開發票,用發票號碼串帳款會串不到,改用帳單號碼串
#                                                  2.人工輸入的發票號碼可能是之前沒開的空白發票,非最大號,故回寫oom_file前需先檢核是否需要回寫
#                                                  3.新增時也需檢核是否序時序號
# Modify.........: No.FUN-970108 09/08/20 By hognmei add ome60申報統編
# Modify.........: No.MOD-990269 09/10/14 By sabrina 刪除最後一張發票時，系統更新發票日期有問題
# Modify.........: No.TQC-9A0132 09/10/26 By liuxqa 修改ROWID. 
# Modify.........: No:TQC-9C0194 09/12/31 By sherry "稅前金額"、"稅額"對負數未作控管
# Modify.........: No:TQC-9C0196 09/12/31 By sherry "打印次數"對負數未作控管
# Modify.........: No.FUN-9C0072 10/01/07 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30136 10/03/25 By Carrier 大陆版时 ome212拿掉X选项
# Modify.........: No.TQC-A40008 10/04/01 By houlia  根據帳單號碼帶出相應的default值
# Modify.........: No.MOD-A40189 10/05/03 By sabrina axr-384其判斷應調整為以發票號回串應收單據是否已拋總帳，
#                                                    否則當合併發立發票時，原判斷方式有誤。
# Modify.........: No.TQC-A50003 10/05/04 By xiaofeizhu t310_ome16()¤¤ªº³ø®§mfg3044¤£­ã¡A§אּaxr-512
# Modify.........: No.TQC-A50017 10/05/05 By xiaofeizhu ¡§µ|Ã¡¨Ä¦ì¥i¥HÀ«K¿é¥ôȡAµ¹¥Xĵ§i«H®§¡A¦ýY®æ±±¡A¤´¥i­קï
# Modify.........: No:MOD-A50077 10/05/12 By sabrina 大陸帳務待客戶驗收後才開立發票，且大陸在發票開立上並未控管一定要序時序號
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/30 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A70028 10/08/26 By Summer 寫入ome_file時需同步增加寫入到發票與帳款對照檔(omee_file)
# Modify.........: No:MOD-A80246 10/09/01 By Dido 若已拋轉至 amd_file 則不可異動 
# Modify.........: No:MOD-B40083 11/04/14 By Dido 異動 ome_file key 值調整 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B80085 11/08/09 By Polly axrt310 FUNCTION t310_ome16 若 oma59 = 0 則增加 axr-325 錯誤訊息
# Modify.........: No.MOD-B80151 11/08/16 By Polly 增加t310_ome16抓取oma_file條件omavoid = 'N'
# Modify.........: No.FUN-B90024 11/09/05 By yangxf 本作業, 只抓取 ome70(POS開立否) <> 'Y' 的資料,新增axrt311 銷項發票維護作業-門市營業資料
# Modify.........: NO.FUN-B90114 11/09/05 By yangxf   參數1 : 是決定要執行axrt310或axrt311.參數2 : 是接收發票號碼
# Modify.........: NO.TQC-B90209 11/09/28 By Carrier ome7*字段insert前CHECK是来为空
# Modify.........: NO.MOD-BA0058 11/10/09 By Dido 新增時出貨應收回寫 ogb60 
# Modify.........: NO.TQC-BA0061 11/10/20 By yinhy 查詢時，資料建立者，資料建立部門無法下查詢條件
# Modify.........: No.FUN-B90130 11/10/12 BY wujie  增加g_argv2，发票代码
# Modify.........: No.MOD-BA0130 11/10/19 By Polly 修改段將ome04/ome043設定為 no entry
# Modify.........: NO.MOD-BB0055 11/11/03 By Sarah 刪除發票後要回寫oom_file,抓取last_no的程式段寫法有問題會變成無窮迴圈
# Modify.........: No.MOD-BB0015 11/11/04 By Polly 調整UPDATE omee_file 條件
# Modify.........: No.MOD-BC0107 11/12/13 By Polly 修正查詢時語法錯誤，給予g_wc預設值
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30218 12/03/13 By yinhy 增加列印功能
# Modify.........: No.MOD-C30842 12/03/23 By Polly ooz10/ooz16 都需要回寫至出貨單
# Modify.........: No:TQC-C40185 12/04/19 By lujh 台灣版本應將發票代碼隱藏掉
# Modify.........: No:TQC-C10002 12/04/23 By Elise 發票開立,若碼幾年前已存在(字軌四年輪回一次,可能會重複),導致無法開立今年度的發票
# Modify.........: No.MOD-C40057 12/04/06 By Polly 銷項發票作廢/取消作廢時，排除13類尾款回寫出貨單
# Modify.........: No.MOD-C40141 12/04/25 By Elise 於MOD單號 MOD-C40057 有提出 程式段有排除訂金(oga00=11)但卻沒排除(oga00=13)
# Modify.........: No.FUN-C40078 12/05/03 By Lori 新增電子發票欄位,ome22,ome23,ome24,ome25,ooh02
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No.FUN-C70030 12/07/10 By pauline 新增電子發票相關欄位
# Modify.........: No.FUN-C80002 12/08/02 By pauline axrt311 新增ome81,ome82欄位
# Modify.........: No.TQC-BC0083 12/10/08 By yinhy 資料更改日，資料建立者，資料建立部門更改
# Modify.........: No.FUN-C90104 13/01/23 By Lori 新增Action，電子發票列印
# Modify.........: No.TQC-D10091 13/01/31 By pauline 因為POS交易單號在各門店會重複, 所以join oga_file時應再加上plant 的條件
# Modify.........: No:MOD-D20104 13/02/20 By apo 若為串入axrt310時，將g_action_choice="query"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ome           RECORD  LIKE ome_file.*,
       g_ome_t         RECORD  LIKE ome_file.*,
       g_oma           RECORD  LIKE oma_file.*,
       g_oga           RECORD  LIKE oga_file.*,
       g_ogb           RECORD  LIKE ogb_file.*,
       g_ohb           RECORD  LIKE ohb_file.*,
       b_omb           RECORD  LIKE omb_file.*,
       g_ome01_t       LIKE ome_file.ome01,
       g_ome16_t       LIKE ome_file.ome16,       #MOD-760006
       g_oma33         LIKE oma_file.oma33,       #MOD-870256 add
       g_buf           LIKE azf_file.azf03,       #No.FUN-680123 VARCHAR(20)   #MOD-830227
       g_wc,g_sql      STRING,                    #No.FUN-580092 HCN  
       g_argv1         LIKE ome_file.ome01        #No.FUN-680123 VARCHAR(16) #No.FUN-560198
DEFINE g_forupd_sql    STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt           LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE g_msg           LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE g_curs_index    LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE g_jump          LIKE type_file.num10       #No.FUN-680123 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE l_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
DEFINE l_plant_new     LIKE azp_file.azp01        #FUN-980093 add
DEFINE g_ome59x        LIKE oma_file.oma59x       #TQC-A50017 Add
DEFINE g_flag          LIKE type_file.num5        #FUN-B90024 ADD
DEFINE cb              ui.ComboBox
DEFINE g_argv2         LIKE ome_file.ome03       #No.FUN-B90130
DEFINE g_ooh02         LIKE ooh_file.ooh02        #FUN-C40078
DEFINE g_oga01         LIKE oga_file.oga01        #FUN-C70030 add 
DEFINE g_ome03         LIKE ome_file.ome03        #FUN-C70030 add
DEFINE g_str           STRING                     #FUN-C90104 add

MAIN
    DEFINE
       #l_sql           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(200)
        l_sql           STRING                       #No.MOD-B80085 add
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680123 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
     
#   LET g_flag = ARG_VAL(1)                           #FUN-B90024  #FUN-B90114 mark
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AXR")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_argv1=ARG_VAL(1)                           #FUN-B90024  MARK   #FUN-B90114  
    LET g_argv2=ARG_VAL(2)                           #No.FUN-B90130
#FUN-B90056-------------begin-------------- 
#FUN-B90114 begin---
#    IF cl_null(g_flag) THEN 
#        LET g_prog = 'axrt310'
#    ELSE 
#        LET g_prog = 'axrt311'
#    END IF 
     IF g_argv1 = '1' THEN
         LET g_prog = 'axrt311'
         CALL cl_set_act_visible("print_incoive", TRUE)     #FUN-C90104 add
     ELSE 
         LET g_prog = 'axrt310'
         CALL cl_set_act_visible("print_incoive", FALSE)    #FUN-C90104 add
     END IF 
#FUN-B90114 end ---
#FUN-B90056-------------end---------------
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818   #No.FUN-6A0095
    INITIALIZE g_ome.* TO NULL
    INITIALIZE g_ome_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ome_file WHERE ome00 = ? AND ome01 = ? AND ome03 = ? FOR UPDATE"   #No.FUN-B90130 

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t310_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 3
   #FUN-B90024-------begin-------- 
#   IF cl_null(g_flag) THEN                            #FUN-B90114
    IF g_argv1 <> '1' OR cl_null(g_argv1) THEN                             #FUN-B90114
       OPEN WINDOW t310_w AT p_row,p_col
           WITH FORM "axr/42f/axrt310"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    ELSE
       OPEN WINDOW t310_w AT p_row,p_col
           WITH FORM "axr/42f/axrt311"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
    END IF 

    #TQC-C40185--add-str--
    IF g_aza.aza26 <> '2' THEN
      CALL cl_set_comp_visible('ome03',FALSE)
    ELSE
      CALL cl_set_comp_visible('ome03',TRUE)
    END IF
    #TQC-C40185--add-end--

    #FUN-C40078--Add Begin-------
       IF g_aza.aza26 <> '0' THEN
          CALL cl_set_comp_visible('ome22',FALSE)
          CALL cl_set_comp_visible('ome23',FALSE)
          CALL cl_set_comp_visible('ome24',FALSE)
          CALL cl_set_comp_visible('ome25',FALSE)
          CALL cl_set_comp_visible('ooh02',FALSE)
          CALL cl_set_comp_visible('Group2',FALSE)
       ELSE
          CALL cl_set_comp_visible('ome22',TRUE)
          CALL cl_set_comp_visible('ome23',TRUE)
          CALL cl_set_comp_visible('ome24',TRUE)
          CALL cl_set_comp_visible('ome25',TRUE)
          CALL cl_set_comp_visible('ooh02',TRUE)
          CALL cl_set_comp_visible('Group2',TRUE)
       END IF
       #FUN-C40078--Add End---------
    
   #FUN-B90024-------end---------
    CALL cl_ui_init()
   #   IF NOT cl_null(g_argv1) THEN CALL t310_q() END IF               #FUN-B90024  mark
   #IF g_argv1 <> '1' AND NOT cl_null(g_argv1) THEN CALL t310_q() END IF   #MOD-D20104 mark   #FUN-B90114
    LET g_action_choice=""
   #MOD-D20104--
    IF g_argv1 <> '1' AND NOT cl_null(g_argv1) THEN
      LET g_action_choice="query"
      CALL t310_q()
    END IF
   #MOD-D20104--
#   IF cl_null(g_flag) THEN            #FUN-B90114 mark
    IF g_argv1 <> '1' OR cl_null(g_argv1) THEN             #FUN-B90114  
       LET cb = ui.ComboBox.forName("ome00")
       CALL cb.removeItem('4')
    END IF 
    CALL t310_set_comb()   #MOD-840126
    CALL t310_menu()
    CLOSE WINDOW t310_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818    #No.FUN-6A0095
END MAIN
 
FUNCTION t310_curs()
    INITIALIZE g_ome.* TO NULL    #No.FUN-750051
   #IF cl_null(g_argv1) THEN      #FUN-B90024  mark        
#FUN-B90024-------begin--------
#   IF cl_null(g_flag) THEN       #FUN-B90114  mark
    IF cl_null(g_argv1) THEN         #FUN-B90114  #axrt310 
       CLEAR FORM
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
	         ome00,ome03,ome01,ome02,         #No.FUN-B90130 add ome03
                 ome16,ome05,ome08,
	         ome04,ome043,ome044,ome042,
	         ome21,ome211,ome212,ome213,
                 ome172,omeprsw,            #FUN-C40078 add ome22
                 ome59,ome59x,ome59t,
                 omevoid,omevoid2,omevoidu,omevoidd,
                 ome17,ome171,ome173,ome174,ome175,ome60,   #FUN-970108 add ome60
	         ome32,ome33,ome34 ,
	         omeuser,omegrup,omemodu,omedate,omemodd,
                 omeoriu,omeorig,                           #TQC-BA0061
                 omeud01,omeud02,omeud03,omeud04,omeud05,
                 omeud06,omeud07,omeud08,omeud09,omeud10,
                 omeud11,omeud12,omeud13,omeud14,omeud15
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            IF INFIELD(omevoid2) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf01a"                               #No.FUN-930106 
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_ome.omevoid2
               LET g_qryparam.arg1 ='F'   #MOD-6A0018                         #No.FUN-930106 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omevoid2
               NEXT FIELD omevoid2
            END IF
            IF INFIELD(ome21) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " gec011='2' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ome21
               NEXT FIELD ome21
            END IF
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
    ELSE          #axrt311 
        CLEAR FORM
        CONSTRUCT BY NAME g_wc ON                   
                  ome00,ome71,ome72,ome73,ome01,ome011,ome02,ome82,ome77,      #FUN-C80002 add ome82      
                  oga01,omexml,ome81,         #FUN-C70030 add   #FUN-C80002 add ome81
                  ome16,ome05,ome08,
                  ome04,ome043,ome044,ome042,
                  ome21,ome211,ome212,ome213,
                  ome172,ome26,ome22,omeprsw,                      #FUN-C40078 Add ome22  #FUN-C70030 add ome26
                 #ome24,ome23,ome25,ooh02,                   #FUN-C40078 Add  #FUN-C70030 mark
                  ome59,ome59x,ome59t,ome78,ome79,ome80,ome74,ome75,ome76, 
                  ome23,ome24,ome241,ome25,                         #FUN-C70030 add
                  omevoid,omevoid2,omevoidu,omevoidd,
                  omevoidt,omevoidn,omevoidm,                #FUN-C70030 add 
                  omecncl,omecncl2,omecnclu,omecncld,        #FUN-C70030 add
                  omecnclt,omecnclm,                         #FUN-C70030 add
                  ome17,ome171,ome173,ome174,ome175,ome60,
                  ome32,ome33,ome34 ,
                  omeuser,omegrup,omemodu,omedate,omemodd,
                  omeoriu,omeorig,                           #TQC-BA0061
                  omeud01,omeud02,omeud03,omeud04,omeud05,
                  omeud06,omeud07,omeud08,omeud09,omeud10,
                  omeud11,omeud12,omeud13,omeud14,omeud15
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          ON ACTION controlp
             IF INFIELD(omevoid2) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf01a"         
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_ome.omevoid2
                LET g_qryparam.arg1 ='F'   #MOD-6A0018              
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO omevoid2
                NEXT FIELD omevoid2
             END IF
             IF INFIELD(ome21) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gec"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " gec011='2' "
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ome21
                NEXT FIELD ome21
             END IF
             IF INFIELD(ome71) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ome71"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " ome73 = azw01 "
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ome71
             END IF
             IF INFIELD(ome73) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ome73"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " ome73 = azw01 "
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ome73
             END IF
             #FUN-C40078--Add Begin---
             IF INFIELD(ome25) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ooh"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ome25
                NEXT FIELD ome25
             END IF
             #FUN-C40078--Add End-----
            #FUN-C70030 add START
             IF INFIELD(oga01) THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oga"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga01 
                NEXT FIELD oga01
             END IF

            IF INFIELD(omecncl2) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_omecncl2"                            
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_ome.omevoid2
               LET g_qryparam.arg1 ='F'  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omecncl2
               NEXT FIELD omecncl2
            END IF
            #FUN-C70030 add END
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
    END IF 
#FUN-B90024-------end----------
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
#FUN-B90024-------begin--------
#     ELSE
#        LET g_wc=" ome01='",g_argv1,"'"
#     END IF
#     IF cl_null(g_flag) THEN                 #FUN-B90114 mark
      IF cl_null(g_wc) THEN                   #MOD-BC0107 add
         LET g_wc = '1=1'                     #MOD-BC0107 add
      END IF                                  #MOD-BC0107 add
      IF g_argv1 = '1' THEN                   #FUN-B90114   #axrt311
         LET g_sql="SELECT ome00,ome01,ome03 FROM ome_file ", # 組合出 SQL 指令   #No.FUN-B90130 add ome03
#                  " WHERE ",g_wc CLIPPED, " ORDER BY ome01"       #FUN-B90024  MARK
                  #"    LEFT OUTER JOIN oga_file ON oga98 = ome72 ",     #FUN-C70030 add   #TQC-D10091 mark 
                   "    LEFT OUTER JOIN oga_file ON oga98 = ome72 AND ogaplant = ome73 ",     #TQC-D10091 add
                   " WHERE ",g_wc CLIPPED,                         #FUN-B90024 
                   "   AND ome70 = 'Y' ",                         #FUN-B90024
                   " ORDER BY ome01"                               #FUN-B90024
      ELSE 
        #FUN-B90114 begin ---
         IF g_argv1 <> '1' AND NOT cl_null(g_argv1) THEN
            LET g_wc=" ome01='",g_argv1,"' AND ome03 ='",g_argv2,"'"    #No.FUN-B90130 
         END IF  
        #FUN-B90114 END ---
         LET g_sql = "SELECT ome00,ome01,ome03 FROM ome_file ",   #No.FUN-B90130 add ome03                     
                     " WHERE ",g_wc CLIPPED,
                     "   AND ome70 <> 'Y' ",
                     " ORDER BY ome01"
     END IF 
DISPLAY g_sql
#FUN-B90024-------end----------
      PREPARE t310_prepare FROM g_sql           # RUNTIME 編譯
      DECLARE t310_cs                         # SCROLL CURSOR
          SCROLL CURSOR WITH HOLD FOR t310_prepare
#FUN-B90024-------begin--------
#     IF cl_null(g_flag) THEN                      #FUN-B90114 mark
      IF g_argv1 <> '1' OR cl_null(g_argv1) THEN   #FUN-B90114 
         LET g_sql=
             "SELECT COUNT(*) FROM ome_file WHERE ",g_wc CLIPPED,  #FUN-B90024   ADD ','
             "  AND ome70 <> 'Y' "                                 #FUN-B90024 
      ELSE 
         LET g_sql= "SELECT COUNT(*) FROM ome_file ",
                    "    LEFT OUTER JOIN oga_file ON oga98 = ome72 AND ogaplant = ome73 ",     #TQC-D10091 add
                    "  WHERE ",g_wc CLIPPED,
                    "   AND ome70 = 'Y' "  
      END IF 
#FUN-B90024-------end----------
      PREPARE t310_precount FROM g_sql
      DECLARE t310_count CURSOR FOR t310_precount
END FUNCTION
 
FUNCTION t310_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
#           IF NOT cl_null(g_flag) THEN   #FUN-B90114 mark
            IF g_argv1 = '1' THEN         #FUN-B90114
               CALL cl_set_act_visible("insert,modify,delete,qry_bill_detail,output_time",FALSE)
               CALL cl_set_act_visible("cncl,change_inv",TRUE)  #FUN-C70030 add
            ELSE
               CALL cl_set_act_visible("insert,modify,delete,qry_bill_detail,output_time",TRUE)
               CALL cl_set_act_visible("cncl,change_inv",FALSE)  #FUN-C70030 add
            END IF 
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t310_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t310_q()
            END IF
        ON ACTION next
            CALL t310_fetch('N')
        ON ACTION previous
            CALL t310_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t310_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t310_r()
            END IF
        ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
             # CALL t310x_set_entry('')        #No.MOD-520043  #FUN-C70030 mark
               CALL t310_x()
            END IF
        ON ACTION undovoid
            LET g_action_choice="undovoid"
            IF cl_chk_act_auth() THEN
               CALL t310_z()
            END IF
        #CHI-A70028 add --start--
        ON ACTION qry_bill_detail 
            LET g_action_choice="qry_bill_detail"
            IF cl_chk_act_auth() THEN
               CALL t310_qry_bill_detail()
            END IF
        #CHI-A70028 add --end--
        ON ACTION output_time
            LET g_action_choice="output_time"
            IF cl_chk_act_auth() THEN
               CALL t310_m()
            END IF
       #FUN-C70030 add START
        ON ACTION cncl   #註銷
            LET g_action_choice="cncl"
            IF cl_chk_act_auth() THEN
               CALL t310_cncl()
            END IF
        ON ACTION change_inv   #修改註銷發票 
            LET g_action_choice="change_inv"
            IF cl_chk_act_auth() THEN
               CALL t310_change_inv()
            END IF
       #FUN-C70030 add END
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL t310_set_comb()   #MOD-840126
           CALL cl_set_field_pic("","","","",g_ome.omevoid,"")
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t310_fetch('/')
        ON ACTION first
            CALL t310_fetch('F')
        ON ACTION last
            CALL t310_fetch('L')

        #FUN-C90104 add begin---
        ON ACTION print_incoive
           LET g_action_choice = "print_incoive"
           IF cl_chk_act_auth() THEN
              CALL t310_prt_inv()
            END IF
        #FUN-C90104 add end-----
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_ome.ome01 IS NOT NULL THEN
                LET g_doc.column1 = "ome01"
                LET g_doc.value1 = g_ome.ome01
                CALL cl_doc()
              END IF
           END IF
        #No.TQC-C30218  --Begin
        ON ACTION output
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_ome.ome01) THEN
                #LET g_msg = "axrr300 '' '' '",g_lang,"' 'Y' '' '' ", #FUN-C30085
                 LET g_msg = "axrg300 '' '' '",g_lang,"' 'Y' '' '' ", #FUN-C30085 
                             "'ome01 =\"",g_ome.ome01,"\"'"
                 CALL cl_cmdrun(g_msg)
              END IF
           END IF
        #No.TQC-C30218  --End
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t310_cs
END FUNCTION
 
 
FUNCTION t310_a()
    DEFINE l_oma RECORD LIKE oma_file.*   #MOD-760035
    DEFINE l_omb RECORD LIKE omb_file.*   #MOD-760035
    DEFINE tot   LIKE oga_file.oga54      #MOD-760035
    DEFINE l_omee RECORD LIKE omee_file.* #CHI-A70028 add
 
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_ome.* TO NULL
    LET g_ome01_t = NULL
    LET g_ome16_t = NULL   #MOD-760006
    LET g_ome.ome59  = 0
    LET g_ome.ome59x = 0
    LET g_ome.ome59t = 0
    LET g_ome_t.*=g_ome.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ome.omevoid='N'
        LET g_ome.omeprsw= 0
        LET g_ome.omeuser=g_user
        LET g_ome.omeoriu = g_user #FUN-980030
        LET g_ome.omeorig = g_grup #FUN-980030
        LET g_ome.omegrup=g_grup
        LET g_ome.omedate=g_today
        LET g_ome.omelegal = g_legal #FUN-980011 add
        LET g_ome.ome60 = g_oma.oma71  #FUN-970108
        CALL t310_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           INITIALIZE g_ome.* TO NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_ome.ome01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        IF cl_null(g_ome.ome03) THEN LET g_ome.ome03 = ' ' END IF #MOD-BA0058 
        #No.TQC-B90209  --Begin
        IF cl_null(g_ome.ome70) THEN LET g_ome.ome70 = 'N' END IF
        IF cl_null(g_ome.ome74) THEN LET g_ome.ome74 = 0 END IF
        IF cl_null(g_ome.ome75) THEN LET g_ome.ome75 = 0 END IF
        IF cl_null(g_ome.ome76) THEN LET g_ome.ome76 = 0 END IF
        IF cl_null(g_ome.ome77) THEN LET g_ome.ome77 = ' ' END IF
        IF cl_null(g_ome.ome78) THEN LET g_ome.ome78 = 0 END IF
        IF cl_null(g_ome.ome79) THEN LET g_ome.ome79 = 0 END IF
        IF cl_null(g_ome.ome80) THEN LET g_ome.ome80 = 0 END IF
        IF g_ome.ome03 IS NULL THEN LET g_ome.ome03 = ' ' END IF     #No.FUN-B90130
        IF cl_null(g_ome.ome22) THEN LET g_ome.ome22 = 'N' END IF    #No.FUN-C40078
        IF cl_null(g_ome.omecncl) THEN LET g_ome.omecncl = 'N' END IF  #FUN-C70030 add
        IF cl_null(g_ome.ome81) THEN LET g_ome.ome81 = '1' END IF  #FUN-C80002 add
        #No.TQC-B90209  --End
        INSERT INTO ome_file VALUES(g_ome.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","ome_file",g_ome.ome00,g_ome.ome01,SQLCA.sqlcode,"","",1)  #No.FUN-660116
           CONTINUE WHILE
        ELSE
           LET g_ome_t.* = g_ome.*                # 保存上筆資料
          #----97/08/20 modify 發票日期修改,update oma09
           BEGIN WORK

           #CHI-A70028 add --start--
           INITIALIZE l_omee.* TO NULL
           LET l_omee.omee01 = g_ome.ome01
           LET l_omee.omee02 = g_ome.ome16
           LET l_omee.omeedate = TODAY
           LET l_omee.omeegrup = g_grup
           LET l_omee.omeelegal = g_legal
           LET l_omee.omeeorig = g_grup
           LET l_omee.omeeoriu = g_user
           LET l_omee.omeeuser = g_user
           LET l_omee.omee03   = g_ome.ome03     #No.FUN-B90130 
           
           INSERT INTO omee_file VALUES(l_omee.*)
           IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
              CALL cl_err3("ins","omee_file",l_omee.omee01,l_omee.omee02,SQLCA.SQLCODE,"","ins omee",1)
              CONTINUE WHILE
           END IF
           #CHI-A70028 add --end--

#No.FUN-B90130 --begin
           IF g_aza.aza26 ='2' THEN 
              SELECT COUNT(*) INTO g_cnt FROM oma_file 
               WHERE oma10=g_ome.ome01 
                 AND oma75 = g_ome.ome03  
                 AND omavoid = 'N'
           ELSE 
              SELECT COUNT(*) INTO g_cnt FROM oma_file 
               WHERE oma10=g_ome.ome01  
                 AND omavoid = 'N'
           END IF  
#No.FUN-B90130 --end
           IF g_cnt > 0 THEN
#No.FUN-B90130 --begin
             IF g_aza.aza26 ='2' THEN 
              UPDATE oma_file SET oma09 = g_ome.ome02
               WHERE oma10 = g_ome.ome01 
                 AND oma75 = g_ome.ome03  
             ELSE 
              UPDATE oma_file SET oma09 = g_ome.ome02
               WHERE oma10 = g_ome.ome01             
             END IF  
#No.FUN-B90130 --end
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","oma_file",g_ome.ome01,"",SQLCA.sqlcode,"","upd oma09",1)  #No.FUN-660116
                 CONTINUE WHILE           #NO:4051
              END IF
           ELSE
              #若是直接到axrt310來開發票,用發票號碼串帳款會串不到,改用帳單號碼串
              IF NOT cl_null(g_ome.ome16) THEN
                 SELECT COUNT(*) INTO g_cnt FROM oma_file
                  WHERE oma01=g_ome.ome16
                    AND omavoid = 'N'
                 IF g_cnt > 0 THEN
                    UPDATE oma_file SET oma09 = g_ome.ome02
                     WHERE oma01 = g_ome.ome16
                    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                       CALL cl_err3("upd","oma_file",g_ome.ome01,"",SQLCA.sqlcode,"","upd oma09",1)
                       CONTINUE WHILE
                    END IF
                 END IF
              END IF
            END IF
 
            SELECT ome00,ome01 INTO g_ome.ome00,g_ome.ome01 FROM ome_file     #No.TQC-9A0132 mod
                WHERE ome01 = g_ome.ome01 AND ome00 = g_ome.ome00             #No.TQC-9A0132 mod
                  AND (ome03 = g_ome.ome03 OR ome03 =' ')    #No.FUN-B90130
        END IF
       #先檢查需不需要回寫發票簿檔
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM oom_file
         WHERE oom07 <= g_ome.ome01
           AND oom08 >= g_ome.ome01
           AND (g_ome.ome01 > oom09 OR oom09 IS NULL)
           AND (oom16 = g_ome.ome03 OR oom16 IS NULL)    #No.FUN-B90130
        IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
        IF g_cnt > 0 THEN 
           UPDATE oom_file SET oom09=g_ome.ome01,
                               oom10=g_ome.ome02
             WHERE oom07 <= g_ome.ome01 AND
                   oom08 >= g_ome.ome01 AND
                   (g_ome.ome01 > oom09 OR oom09 IS NULL)
                   AND (oom16 = g_ome.ome03 OR oom16 IS NULL)    #No.FUN-B90130
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err3("upd","oom_file",g_ome.ome01,"",SQLCA.sqlcode,"","upd oom09",1)  
              CONTINUE WHILE
           END IF
        END IF   #MOD-970105 add
        UPDATE oma_file SET oma10=g_ome.ome01,
                            oma71=g_ome.ome60,  #FUN-970108 add
                            oma75=g_ome.ome03   #No.FUN-B90130
          WHERE oma01 = g_ome.ome16
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","oma_file",g_ome.ome16,"",SQLCA.sqlcode,"","upd oma10",1)  
           CONTINUE WHILE
        END IF
        SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = g_ome.ome16 
        CALL s_upd_ogb60(l_oma.oma01)    #MOD-BA0058 
        IF l_oma.oma00 != '11' AND l_oma.oma00 != '14' AND
           l_oma.oma00 != '22' AND l_oma.oma00 != '23' AND
           l_oma.oma00 != '24' AND l_oma.oma00 != '25' AND
           l_oma.oma00 != '31' AND l_oma.oma00 != '13' THEN  #MOD-C40141 add '13'
           DECLARE omb_curs4 CURSOR FOR 
             SELECT * FROM omb_file WHERE omb01 = g_ome.ome16
           FOREACH omb_curs4 INTO l_omb.*
             SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file,oma_file
               WHERE omb31=l_omb.omb31 AND omb01=oma01 AND 
                     omb32=l_omb.omb32 AND 
                     omavoid='N' AND oma00=l_oma.oma00 AND 
                     oma10 IS NOT NULL AND oma10 != ' '
             IF cl_null(tot) THEN LET tot=0 END IF
             IF NOT cl_null(l_omb.omb31) THEN   #MOD-8B0274 add
                IF l_omb.omb38 != '3' THEN
                  #FUN-A60056--mod--str--
                  #UPDATE oga_file SET oga54 = oga54 + tot
                  #  WHERE oga01 = l_omb.omb31
                   LET g_sql = "UPDATE ",cl_get_target_table(l_omb.omb44,'oga_file'),
                               "   SET oga54 = oga54 + '",tot,"'",
                               " WHERE oga01 = '",l_omb.omb31,"'" 
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
                   PREPARE upd_oga FROM g_sql
                   EXECUTE upd_oga
                  #FUN-A60056--mod--end
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("upd","oga_file",l_omb.omb31,"",STATUS,"","upd oga54",1)  
                      CONTINUE WHILE
                   END IF
                ELSE
                  #FUN-A60056--mod-str--
                  #UPDATE oha_file SET oha54 = oha54 + tot
                  #  WHERE oha01 = l_omb.omb31
                   LET g_sql = "UPDATE ",cl_get_target_table(l_omb.omb44,'oha_file'),
                               "   SET oha54 = oha54 + '",tot,"'",
                               " WHERE oha01 = '",l_omb.omb31,"'" 
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
                   PREPARE upd_oha FROM g_sql
                   EXECUTE upd_oha
                  #FUN-A60056--mod--end
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("upd","oha_file",l_omb.omb31,"",STATUS,"","upd oha54",1)  
                      CONTINUE WHILE
                   END IF
                END IF
             END IF   #MOD-8B0274 add
           END FOREACH
        END IF   #TQC-790157
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t310_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680123 SMALLINT
        l_yy            LIKE type_file.num5,          #No.FUN-680123 SMALLINT
        l_mm            LIKE type_file.num5           #No.FUN-680123 SMALLINT
    DEFINE l_omaconf    LIKE oma_file.omaconf   #MOD-710085
    DEFINE l_oma10      LIKE oma_file.oma10   #MOD-760006
    DEFINE l_oom        RECORD LIKE oom_file.*   #MOD-760006
    DEFINE l_ome02a,l_ome02b      LIKE ome_file.ome02   #TQC-870020
    DEFINE l_ome01a,l_ome01b      LIKE ome_file.ome01   #TQC-870020
 
    INPUT BY NAME g_ome.omeoriu,g_ome.omeorig,
	         g_ome.ome00, g_ome.ome03,g_ome.ome01, g_ome.ome02,   #No.FUN-B90130  
           g_ome.ome16, g_ome.ome05, g_ome.ome08,
	         g_ome.ome04, g_ome.ome043,g_ome.ome044,  g_ome.ome042,
	         g_ome.ome21, g_ome.ome211,g_ome.ome212,  g_ome.ome213,
          #g_ome.ome172,g_ome.ome22,g_ome.omeprsw,                    #FUN-C40078 Add ome22  #FUN-C70030 mark
           g_ome.ome172,g_ome.omeprsw,                    #FUN-C40078 Add ome22  #FUN-C70030 add
          #g_ome.ome23,g_ome.ome24,g_ome.ome25,                       #FUN-C40078 Add  #FUN-C70030 mark 
           g_ome.ome59 ,g_ome.ome59x ,g_ome.ome59t,
           g_ome.omevoid,g_ome.omevoid2,g_ome.omevoidu,g_ome.omevoidd,
           g_ome.ome17  , g_ome.ome171 ,g_ome.ome173  ,g_ome.ome174,
           g_ome.ome175 ,g_ome.ome60,   #FUN-970108 add ome60
	         g_ome.ome32  , g_ome.ome33  ,g_ome.ome34 ,
	         g_ome.omeuser, g_ome.omegrup,g_ome.omemodu,
           g_ome.omedate,g_ome.omemodd,
           g_ome.omeud01,g_ome.omeud02,g_ome.omeud03,g_ome.omeud04,
           g_ome.omeud05,g_ome.omeud06,g_ome.omeud07,g_ome.omeud08,
           g_ome.omeud09,g_ome.omeud10,g_ome.omeud11,g_ome.omeud12,
           g_ome.omeud13,g_ome.omeud14,g_ome.omeud15
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t310_set_entry(p_cmd)
            CALL t310_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("ome16")
 
        AFTER FIELD ome00
            IF g_ome.ome00 NOT MATCHES '[13]' THEN
               NEXT FIELD ome00
            END IF
 
        AFTER FIELD ome01
            IF g_ome.ome01 IS NOT NULL AND g_ome.ome00 IS NOT NULL AND g_ome.ome03 IS NOT NULL THEN  #No.FUN-B90130
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_ome.ome01 != g_ome01_t) THEN
                   SELECT count(*) INTO l_n FROM ome_file
                       WHERE ome01 = g_ome.ome01
                         AND ome00 = g_ome.ome00 #MOD-B40083
                         AND (ome03 = g_ome.ome03 OR ome03 =' ')    #No.FUN-B90130
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_ome.ome01,-239,0)
                       LET g_ome.ome01 = g_ome01_t
                       DISPLAY BY NAME g_ome.ome01
                       NEXT FIELD ome01
                   END IF
               END IF
               IF cl_null(g_ome.ome02) THEN   #TQC-C10002 add
                  SELECT * INTO l_oom.* FROM oom_file
                    WHERE oom07 <= g_ome.ome01
                      AND oom08 >= g_ome.ome01
                      AND (oom16 = g_ome.ome03 OR oom16 IS NULL)    #No.FUN-B90130
                 #IF STATUS THEN
                 #   CALL cl_err(g_ome.ome01,'axr-128',0)
                 #   NEXT FIELD ome01
                 #END IF
              #TQC-C10002---S---
               ELSE
                  SELECT * INTO l_oom.* FROM oom_file
                    WHERE oom07 <= g_ome.ome01
                      AND oom08 >= g_ome.ome01
                      AND (oom16 = g_ome.ome03 OR oom16 IS NULL)    #No.FUN-B90130
                      AND oom01 = YEAR(g_ome.ome02)
               END IF
              #TQC-C10002---E---
               IF STATUS THEN
                  CALL cl_err(g_ome.ome01,'axr-128',0)
                  NEXT FIELD ome01
               END IF

               LET g_ome.ome60 = l_oom.oom13
               IF g_aza.aza94 = 'Y' AND cl_null(g_ome.ome60) THEN
                  CALL cl_err("","axr001",0)
                  NEXT FIELD ome01
               END IF    
               
               #台灣版發票長度需輸入10碼
               IF g_aza.aza26 != '2' THEN
                  IF LENGTH(g_ome.ome01) != 10 THEN
                     CALL cl_err(g_ome.ome01,'amd-010',0)
                     NEXT FIELD ome01
                  END IF
               END IF
            END IF
 
        BEFORE FIELD ome02
           SELECT * INTO l_oom.* FROM oom_file
             WHERE oom07 <= g_ome.ome01
               AND oom08 >= g_ome.ome01
               AND (oom16 = g_ome.ome03 OR oom16 IS NULL)    #No.FUN-B90130 
 
        AFTER FIELD ome02
            LET l_yy=YEAR(g_ome.ome02)     #判段年月是否存在發票簿檔中
            LET l_mm=MONTH(g_ome.ome02)
            IF g_aza.aza26 <> '2' THEN   #MOD-840115 
               SELECT count(*)  INTO l_n from oom_file
                WHERE oom01=l_yy AND (oom02=l_mm OR oom021=l_mm)
               IF l_n =0 THEN
                  CALL cl_err(g_ome.ome02,'axr-911',0)
                  LET g_ome.ome02=NULL
                  NEXT FIELD ome02
               END IF
            END IF   #MOD-840115
            IF g_ome.ome01 > l_oom.oom09 AND g_ome.ome02 < l_oom.oom10 THEN
               CALL cl_err(g_ome.ome01,'axr-208',0)
               NEXT FIELD ome02
            END IF
            IF l_oom.oom01 != YEAR(g_ome.ome02) OR
               l_mm < l_oom.oom02 OR l_mm > l_oom.oom021 THEN
               CALL cl_err(g_ome.ome01,'axr-314',0)
               NEXT FIELD ome02
            END IF
            IF p_cmd='u' OR p_cmd='a' THEN   #MOD-970105 add p_cmd='a'
               SELECT MAX(ome01),MIN(ome01) INTO l_ome01a,l_ome01b FROM ome_file 
                WHERE ome01 >= l_oom.oom07
                  AND ome01 <= l_oom.oom08 
                  AND ome00 = g_ome.ome00 #MOD-B40083
                  AND (ome03 = l_oom.oom16 OR ome03 = ' ')    #No.FUN-B90130 
               IF l_ome01b< g_ome.ome01 AND l_ome01a>g_ome.ome01 THEN
                  SELECT ome02 INTO l_ome02a FROM ome_file
                   WHERE ome01 = (SELECT MAX(ome01) FROM ome_file 
                                   WHERE ome01 < g_ome.ome01   #MOD-B40083 remove )
                                     AND ome00 = g_ome.ome00 AND (ome03 = g_ome.ome03 OR ome03 =' ') ) #MOD-B40083  #No.FUN-B90130 add ome03 
                     AND ome00 = g_ome.ome00 #MOD-B40083
                  SELECT ome02 INTO l_ome02b FROM ome_file
                   WHERE ome01 = (SELECT MIN(ome01) FROM ome_file 
                                   WHERE ome01 > g_ome.ome01   #MOD-B40083 remove )
                                     AND ome00 = g_ome.ome00 AND (ome03 = g_ome.ome03 OR ome03 =' ')) #MOD-B40083  #No.FUN-B90130
                     AND ome00 = g_ome.ome00 #MOD-B40083
                  IF g_ome.ome02 < l_ome02a OR g_ome.ome02 > l_ome02b 
                     AND g_aza.aza26 = '0' THEN    #MOD-A50077 add
                     CALL cl_err(g_ome.ome01,'axr-046',0)
                     NEXT FIELD ome02
                  END IF
               ELSE
                  IF g_ome.ome01 = l_ome01b AND g_ome.ome01 < l_ome01a THEN  
                     SELECT ome02 INTO l_ome02b FROM ome_file
                      WHERE ome01 = (SELECT MIN(ome01) FROM ome_file 
                                      WHERE ome01 > g_ome.ome01   #MOD-B40083 remove )
                                        AND ome00 = g_ome.ome00 AND (ome03 = g_ome.ome03 OR ome03 =' ')) #MOD-B40083  #No.FUN-B90130
                        AND ome00 = g_ome.ome00 #MOD-B40083
                      IF g_ome.ome02 > l_ome02b 
                         AND g_aza.aza26 = '0' THEN    #MOD-A50077 add
                         CALL cl_err(g_ome.ome01,'axr-046',0)
                         NEXT FIELD ome02
                      END IF
                  ELSE
                     IF g_ome.ome01 = l_ome01a AND g_ome.ome01 > l_ome01b THEN  
                        SELECT ome02 INTO l_ome02a FROM ome_file
                         WHERE ome01 = (SELECT MAX(ome01) FROM ome_file 
                                         WHERE ome01 < g_ome.ome01   #MOD-B40083 remove )
                                           AND ome00 = g_ome.ome00 AND (ome03 = g_ome.ome03 OR ome03 =' ')) #MOD-B40083  #No.FUN-B90130
                           AND ome00 = g_ome.ome00 #MOD-B40083
                         IF g_ome.ome02 < l_ome02a 
                            AND g_aza.aza26 = '0' THEN    #MOD-A50077 add
                            CALL cl_err(g_ome.ome01,'axr-046',0)
                            NEXT FIELD ome02
                         END IF
                      END IF
                  END IF
               END IF     
            END IF
         AFTER FIELD ome16
            IF g_ooz.ooz20 = 'Y' THEN
               LET l_omaconf = ''
               SELECT omaconf INTO l_omaconf FROM oma_file
                 WHERE oma01=g_ome.ome16 
               IF l_omaconf <> 'Y' THEN
                  CALL cl_err(g_ome.ome16,'axr-048',0)
                  NEXT FIELD ome16
               END IF
            END IF
            CALL t310_ome16()                     #TQC-A40008
            IF NOT cl_null(g_errno) THEN          #TQC-A40008
               CALL cl_err(g_ome.ome16,g_errno,0) #TQC-A40008
               NEXT FIELD ome16                   #TQC-A40008
            END IF                                #TQC-A40008
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ome.ome16 != g_ome16_t) THEN
               LET l_oma10 = ''
               SELECT oma10 INTO l_oma10 FROM oma_file
                 WHERE oma01=g_ome.ome16
               IF NOT cl_null(l_oma10) THEN
                  CALL cl_err(g_ome.ome16,'axr-348',0)
                  NEXT FIELD ome16
               END IF
            END IF
            
         AFTER FIELD ome05 
          CALL t310_ome60()
          IF g_aza.aza94 = 'Y' AND cl_null(g_ome.ome60) THEN
            CALL cl_err("","axr001",0)
            NEXT FIELD ome05
          END IF     
 
         AFTER FIELD ome21       #稅別
            IF NOT cl_null(g_ome.ome21) THEN
               CALL t310_ome21('')   #MOD-5C0155
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ome.ome21,g_errno,0)
                  NEXT FIELD ome21
               END IF
#No.FUN-B90130 --begin 
               IF l_oom.oom15 != g_ome.ome212 AND g_aza.aza26 ='2' THEN
                  CALL cl_err(g_ome.ome01,'axr-127',0)
                  NEXT FIELD ome21
               END IF 
               IF l_oom.oom04 != g_ome.ome212 AND g_aza.aza26 <> '2' THEN
                  CALL cl_err(g_ome.ome01,'axr-129',0)
                  NEXT FIELD ome21
               END IF 

#               IF l_oom.oom04 != g_ome.ome212 THEN
#                  IF g_aza.aza26 = '2' THEN
#                     CALL cl_err(g_ome.ome01,'axr-127',0)
#                  ELSE
#                     CALL cl_err(g_ome.ome01,'axr-129',0)
#                  END IF
#                  NEXT FIELD ome21
#               END IF
#No.FUN-B90130 --end 
            END IF
         AFTER FIELD ome211
               CALL t310_ome21_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ome.ome211,g_errno,0)
                  NEXT FIELD ome211
               END IF
         AFTER FIELD ome212
               CALL t310_ome21_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ome.ome212,g_errno,0)
                  NEXT FIELD ome212
               END IF
 
         AFTER FIELD ome172
               CALL t310_ome21_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ome.ome172,g_errno,0)
                  NEXT FIELD ome172
               END IF

       #FUN-C70030 add START
       ##FUN-C40078--Add Begin--- 
       #AFTER FIELD ome22
       #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

       #AFTER FIELD ome23
       #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

       #AFTER FIELD ome24
       #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

       #AFTER FIELD ome25
       #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       ##FUN-C40078--Add End-----
       #FUN-C70030 add END
        
        AFTER FIELD ome213
              CALL t310_ome21_chk()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ome.ome213,g_errno,0)
                 NEXT FIELD ome213
              END IF
 
         #no.A010依幣別取位
         AFTER FIELD  ome59
            IF cl_null(g_ome.ome59) THEN LET g_ome.ome59 = 0 END IF
            IF g_ome.ome59 < 0 THEN
               CALL cl_err(g_ome.ome59,'axm-179',0)
               NEXT FIELD ome59
            END IF
            LET g_ome.ome59 = cl_digcut(g_ome.ome59,g_azi04)   #MOD-6B0053
            LET g_ome.ome59t = g_ome.ome59 + g_ome.ome59x    #No:7985
            LET g_ome.ome59t = cl_digcut(g_ome.ome59t,g_azi04)   #MOD-6B0053
            DISPLAY BY NAME g_ome.ome59,g_ome.ome59t
 
         AFTER FIELD  ome59x
            IF cl_null(g_ome.ome59x) THEN LET g_ome.ome59x = 0 END IF
            IF g_ome.ome59x < 0 THEN
               CALL cl_err(g_ome.ome59x,'axm-179',0)
               NEXT FIELD ome59x
            END IF
            #TQC-A50017--Add--Begin                                                                                                 
            IF g_ome.ome59x > g_ome59x THEN                                                                                         
               CALL cl_err(g_ome.ome59x,'axr-420',0)                                                                                
            END IF                                                                                                                  
            #TQC-A50017--Add--End
            LET g_ome.ome59x = cl_digcut(g_ome.ome59x,g_azi04)   #MOD-6B0053
            LET g_ome.ome59t = g_ome.ome59 + g_ome.ome59x    #No:7985
            LET g_ome.ome59t = cl_digcut(g_ome.ome59t,g_azi04)   #MOD-6B0053
            DISPLAY BY NAME g_ome.ome59x,g_ome.ome59t        #No:7985
 
         AFTER FIELD ome042
            IF g_aza.aza21 = 'Y' AND NOT cl_null(g_ome.ome042) THEN
               IF NOT s_chkban(g_ome.ome042) THEN
                  CALL cl_err('chkban-ome042:','aoo-080',1)
               END IF
	    END IF
            IF g_ome.ome08='1' AND
               g_ome.ome212!='2' AND    #MOD-870032 add
               cl_null(g_ome.ome042) THEN
               CALL cl_err('','axr-410',0)
               NEXT FIELD ome042
            END IF
#No.FUN-B90130 --begin

         AFTER FIELD ome03 
            IF g_ome.ome01 IS NOT NULL AND g_ome.ome00 IS NOT NULL AND g_ome.ome03 IS NOT NULL THEN  #No.FUN-B90130 
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_ome.ome03 != g_ome_t.ome03) THEN
                   SELECT count(*) INTO l_n FROM ome_file
                       WHERE ome01 = g_ome.ome01
                         AND ome00 = g_ome.ome00 #MOD-B40083 
                         AND (ome03 = g_ome.ome03 OR ome03 =' ')     #No.FUN-B90130 
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_ome.ome03,-239,0)
                       LET g_ome.ome03 = g_ome_t.ome03                      
                       DISPLAY BY NAME g_ome.ome03
                       NEXT FIELD ome03
                   END IF
                   SELECT * INTO l_oom.* FROM oom_file
                     WHERE oom07 <= g_ome.ome01
                       AND oom08 >= g_ome.ome01 
                       AND (oom16 = g_ome.ome03 OR oom16 IS NULL)
                       AND oom01 = YEAR(g_ome.ome02)    #TQC-C10002 add ome02
                   IF STATUS THEN
                      CALL cl_err(g_ome.ome03,'axr-128',0)
                      NEXT FIELD ome03
                   END IF
               END IF
            END IF
            IF g_ome.ome03 IS NULL THEN LET g_ome.ome03 =' ' END IF    
#No.FUN-B90130 --end 
        AFTER FIELD omeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD omeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD omeprsw
           IF g_ome.omeprsw < 0 THEN
              CALL cl_err(g_ome.omeprsw,'axm-179',0)
              NEXT FIELD omeprsw
           END IF
        AFTER INPUT
           LET g_ome.omeuser = s_get_data_owner("ome_file") #FUN-C10039
           LET g_ome.omegrup = s_get_data_group("ome_file") #FUN-C10039
            LET l_flag = 'N'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(g_ome.ome211)  THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ome.ome211
            END IF
            IF cl_null(g_ome.ome212)  THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ome.ome212
            END IF
            IF cl_null(g_ome.ome213)  THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ome.ome213
            END IF
            IF g_aza.aza26 != '2' THEN   #非大陸版才做ome171的檢核  #MOD-8A0281 add
               IF cl_null(g_ome.ome171)  THEN
                  LET l_flag='Y'
                  DISPLAY BY NAME g_ome.ome171
               END IF
            END IF   #MOD-8A0281 add
            IF cl_null(g_ome.ome172)  THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ome.ome172
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD ome21
            END IF
            IF g_ome.ome08='1' AND
               g_ome.ome212!='2' AND    #MOD-870032 add
               cl_null(g_ome.ome042) THEN
               CALL cl_err('','axr-410',0)
               NEXT FIELD ome042
            END IF
 
        ON ACTION controlp
           IF INFIELD(omevoid2) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf01a"                                 #No.FUN-930106     
              LET g_qryparam.default1 = g_ome.omevoid2
              LET g_qryparam.arg1 ='F'                                         #No.FUN-930106     
              CALL cl_create_qry() RETURNING g_ome.omevoid2
              DISPLAY BY NAME g_ome.omevoid2
              NEXT FIELD omevoid2
           END IF
           IF INFIELD(ome21) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gec"
              LET g_qryparam.default1 = g_ome.ome21
              LET g_qryparam.arg1 = '2'
              CALL cl_create_qry() RETURNING g_ome.ome21
              DISPLAY BY NAME g_ome.ome21
              NEXT FIELD ome21
           END IF
 
 
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

#TQC-A40008                     ---start---
FUNCTION t310_ome16()
    DEFINE l_oma04   LIKE oma_file.oma04
    DEFINE l_occ18   LIKE occ_file.occ18
    DEFINE l_oma044  LIKE oma_file.oma044
    DEFINE l_oma042  LIKE oma_file.oma042
    DEFINE l_oma21   LIKE oma_file.oma21 
    DEFINE l_oma211  LIKE oma_file.oma211
    DEFINE l_oma212  LIKE oma_file.oma212
    DEFINE l_oma213  LIKE oma_file.oma213
    DEFINE l_oma59   LIKE oma_file.oma59 
    DEFINE l_oma59x  LIKE oma_file.oma59x
    DEFINE l_oma75   LIKE oma_file.oma75    #No.FUN-B90130

    LET g_ome59x = 0                             #TQC-A50017 Add
    LET g_errno = ' '
    SELECT oma04,occ18,oma044,oma042,oma21,oma211,oma212,oma213,oma59,oma59x
      INTO l_oma04,l_occ18,l_oma044,l_oma042,l_oma21,l_oma211,l_oma212,l_oma213,l_oma59,l_oma59x
      FROM oma_file,occ_file
     WHERE oma01 = g_ome.ome16
       AND oma04 = occ01 
       AND omavoid = 'N'           #No.MOD-B80151 add

#   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'                    #TQC-A50003 Mark                                       
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'axr-512'                    #TQC-A50003 Add
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----' 
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
#-----------------No.MOD-B80085-------------------start
    IF l_oma59 = 0 THEN
       LET g_errno = 'axr-325'
    END IF
#-----------------No.MOD-B80085---------------------end
    LET g_ome.ome04  = l_oma04
    LET g_ome.ome043 = l_occ18
    LET g_ome.ome044 = l_oma044
    LET g_ome.ome042 = l_oma042
    LET g_ome.ome21  = l_oma21
    LET g_ome.ome211 = l_oma211
    LET g_ome.ome212 = l_oma212
    LET g_ome.ome213 = l_oma213
    LET g_ome.ome59  = l_oma59
    LET g_ome.ome59x = l_oma59x
    LET g_ome59x = l_oma59x                     #TQC-A50017 Add
    IF g_errno = ' ' THEN
       DISPLAY BY NAME g_ome.ome04,g_ome.ome043,g_ome.ome044,g_ome.ome042,g_ome.ome21,g_ome.ome211,
                       g_ome.ome212,g_ome.ome213,g_ome.ome59,g_ome.ome59x
    END IF
END FUNCTION

#TQC-A40008                                ---end--- 
FUNCTION t310_ome21(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
    DEFINE l_gec04   LIKE gec_file.gec04
    DEFINE l_gec05   LIKE gec_file.gec05
    DEFINE l_gec06   LIKE gec_file.gec06
    DEFINE l_gec07   LIKE gec_file.gec07
    DEFINE l_gec08   LIKE gec_file.gec08
    DEFINE l_gecacti LIKE gec_file.gecacti
 
    LET g_errno = ' '
    SELECT gec04,gec05,gec06,gec07,gec08,gecacti
      INTO l_gec04,l_gec05,l_gec06,l_gec07,l_gec08,l_gecacti
      FROM gec_file
     WHERE gec01 = g_ome.ome21 AND gec011='2'  #銷項
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gecacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_ome.ome211 = l_gec04        #稅率
    LET g_ome.ome212 = l_gec05        #聯數
    LET g_ome.ome213 = l_gec07        #含稅否
    LET g_ome.ome171 = l_gec08        #格式
    LET g_ome.ome172 = l_gec06        #課稅別
    IF g_errno = ' ' OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_ome.ome211,g_ome.ome212,g_ome.ome213,
                       g_ome.ome171,g_ome.ome172
    END IF
END FUNCTION
 
FUNCTION t310_ome21_chk()
    DEFINE l_gec04   LIKE gec_file.gec04
    DEFINE l_gec05   LIKE gec_file.gec05
    DEFINE l_gec06   LIKE gec_file.gec06
    DEFINE l_gec07   LIKE gec_file.gec07
 
    LET g_errno = ' '
    SELECT gec04,gec05,gec06,gec07
      INTO l_gec04,l_gec05,l_gec06,l_gec07
      FROM gec_file
     WHERE gec01 = g_ome.ome21 AND gec011='2'  #銷項
 
    IF g_ome.ome211 <> l_gec04 OR
       g_ome.ome212 <> l_gec05 OR
       g_ome.ome172 <> l_gec06 OR
       g_ome.ome213 <> l_gec07 THEN
       LET g_errno = 'axr-008'
    END IF
 
END FUNCTION
 
FUNCTION t310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ome.* TO NULL                #No.FUN-6B0042 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t310_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN t310_count
    FETCH t310_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
       INITIALIZE g_ome.* TO NULL
    ELSE
       CALL t310_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t310_fetch(p_flome)
    DEFINE
        p_flome         LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680123 INTEGER
 
    CASE p_flome
        WHEN 'N' FETCH NEXT     t310_cs INTO g_ome.ome00,g_ome.ome01,g_ome.ome03    #No.FUN-B90130   
        WHEN 'P' FETCH PREVIOUS t310_cs INTO g_ome.ome00,g_ome.ome01,g_ome.ome03    #No.FUN-B90130 
        WHEN 'F' FETCH FIRST    t310_cs INTO g_ome.ome00,g_ome.ome01,g_ome.ome03    #No.FUN-B90130 
        WHEN 'L' FETCH LAST     t310_cs INTO g_ome.ome00,g_ome.ome01,g_ome.ome03    #No.FUN-B90130 
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t310_cs INTO g_ome.ome00,g_ome.ome01,g_ome.ome03    #No.FUN-B90130
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0) 
        INITIALIZE g_ome.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flome
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT *
      INTO g_ome.* FROM ome_file
       WHERE ome00 = g_ome.ome00 AND ome01 = g_ome.ome01 AND (ome03 = g_ome.ome03 OR ome03 =' ')   #No.FUN-B90130 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ome_file",g_ome.ome01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
    ELSE
       LET g_data_owner = g_ome.omeuser     #No.FUN-4C0049
       LET g_data_group = g_ome.omegrup     #No.FUN-4C0049
       LET g_ome03 = g_ome.ome03            #FUN-C70030 add   #將ome03儲存,避免ome清空錯誤
       CALL t310_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t310_show()
#FUN-B90024-------begin--------
#   IF cl_null(g_flag) THEN
    IF g_argv1 <> '1' OR cl_null(g_argv1) THEN   #FUN-B90114
       DISPLAY BY NAME g_ome.omeoriu,g_ome.omeorig,
      	               g_ome.ome00,g_ome.ome03,g_ome.ome01,g_ome.ome02,g_ome.ome16,   #No.FUN-B90130 add ome03
                       g_ome.ome08,g_ome.ome05,
   	               g_ome.ome04,g_ome.ome042,g_ome.ome043,g_ome.ome044,
                       g_ome.ome21,g_ome.ome211,g_ome.ome212,g_ome.ome213,
   	               g_ome.ome17,g_ome.ome171,g_ome.ome172,
   	               g_ome.ome173,g_ome.ome174,g_ome.ome175,g_ome.ome60,   #FUN-970108 add ome60
   	               g_ome.ome32,g_ome.ome33,g_ome.ome34 ,
   	               g_ome.ome59,g_ome.ome59x,g_ome.ome59t,
   	               g_ome.omeprsw,g_ome.omevoid,g_ome.omevoid2,
   	               g_ome.omevoidu,g_ome.omevoidd,
   	               g_ome.omeuser,g_ome.omedate,g_ome.omegrup,
   	               g_ome.omemodu,g_ome.omemodd,
   	               g_ome.omeoriu,g_ome.omeorig,          #TQC-BA0061
                       g_ome.omeud01,g_ome.omeud02,g_ome.omeud03,g_ome.omeud04,
                       g_ome.omeud05,g_ome.omeud06,g_ome.omeud07,g_ome.omeud08,
                       g_ome.omeud09,g_ome.omeud10,g_ome.omeud11,g_ome.omeud12,
                       g_ome.omeud13,g_ome.omeud14,g_ome.omeud15
    ELSE   #axrt311 
       DISPLAY BY NAME g_ome.omeoriu,g_ome.omeorig,
                       g_ome.ome00,g_ome.ome71,g_ome.ome72,g_ome.ome73,g_ome.ome01,g_ome.ome011,g_ome.ome02,g_ome.ome77,                              
                       g_ome.ome16,g_ome.ome08,g_ome.ome05,
                       g_ome.ome04,g_ome.ome042,g_ome.ome043,g_ome.ome044,
                       g_ome.ome21,g_ome.ome211,g_ome.ome212,g_ome.ome213,
                       g_ome.ome17,g_ome.ome171,g_ome.ome172,
                       g_ome.ome22,g_ome.ome23,g_ome.ome24,g_ome.ome25,               #FUN-C40078
                       g_ome.ome173,g_ome.ome174,g_ome.ome175,g_ome.ome60,  
                       g_ome.ome32,g_ome.ome33,g_ome.ome34 ,
                       g_ome.ome59,g_ome.ome59x,g_ome.ome59t,
                       g_ome.ome78,g_ome.ome79,g_ome.ome80,g_ome.ome74,g_ome.ome75,g_ome.ome76,  
                       g_ome.omeprsw,g_ome.omevoid,g_ome.omevoid2,
                       g_ome.omevoidu,g_ome.omevoidd,
                       g_ome.omeuser,g_ome.omedate,g_ome.omegrup,
                       g_ome.omemodu,g_ome.omemodd,
   	               g_ome.omeoriu,g_ome.omeorig,          #TQC-BA0061
                       g_ome.omeud01,g_ome.omeud02,g_ome.omeud03,g_ome.omeud04,
                       g_ome.omeud05,g_ome.omeud06,g_ome.omeud07,g_ome.omeud08,
                       g_ome.omeud09,g_ome.omeud10,g_ome.omeud11,g_ome.omeud12,
                       g_ome.omeud13,g_ome.omeud14,g_ome.omeud15,
                       g_ome.ome241,g_ome.ome26,g_ome.omevoidt,g_ome.omevoidn,g_ome.omevoidm,      #FUN-C70030 add
                       g_ome.omecncl,g_ome.omecncl2,g_ome.omecncld,g_ome.omecnclu,g_ome.omecncld,  #FUN-C70030 add 
                       g_ome.omecnclt,g_ome.omecnclm,g_ome.omexml,                                 #FUN-C70030 add 
                       g_ome.ome81,g_ome.ome82                                                     #FUN-C80002 add
      #FUN-C70030 add START
       LET g_oga01 = ' '
       SELECT oga01 INTO g_oga01 FROM oga_file
         WHERE oga98 = g_ome.ome72 
           AND ogaplant = g_ome.ome73  #TQC-D10091 add
       DISPLAY g_oga01 TO oga01
      #FUN-C70030 add END
    END IF 
#FUN-B90024-------end--------
    CALL cl_set_field_pic("","","","",g_ome.omevoid,"")
    DISPLAY '' TO azf03   #MOD-830227
    IF g_ome.omevoid='Y' THEN
       LET g_msg=''
       SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=g_ome.omevoid2 AND azf02='2'    #No.FUN-930106
       DISPLAY g_msg TO azf03   #MOD-830227
       DISPLAY BY NAME g_ome.omevoid, g_ome.omevoid2,
	               g_ome.omevoidu, g_ome.omevoidd,
                       g_ome.omevoidt,g_ome.omevoidn,g_ome.omevoidm   #FUN-C70030 add	
    END IF
   #FUN-C70030 add START
    DISPLAY '' TO azf1  
    IF g_ome.omecncl='Y' AND g_argv1 = '1' THEN
       LET g_msg=''
       SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=g_ome.omecncl2 AND azf02='2'    
       DISPLAY g_msg TO azf1  
       DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2,
                       g_ome.omecnclu, g_ome.omecncld,
                       g_ome.omecnclt, g_ome.omecnclm
    END IF
   #FUN-C70030 add END 
    #FUN-C40078--Begin---
    LET g_ooh02 = ' '  #FUN-C70030 add 
    IF NOT cl_null(g_ome.ome25) THEN
       SELECT ooh02 INTO g_ooh02 FROM ooh_file WHERE ooh01 = g_ome.ome25
       DISPLAY g_ooh02 TO ooh02
   #FUN-C70030 add START
    ELSE 
       DISPLAY '' TO ooh02 
   #FUN-C70030 add END
    END IF
    #FUN-C40078--End-----

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t310_u()
    DEFINE l_oom09 LIKE oom_file.oom09   #TQC-870020
    DEFINE l_omee    RECORD LIKE omee_file.* #CHI-A70028 add
 
    IF g_ome.ome01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ome.* FROM ome_file WHERE ome01 = g_ome.ome01
                                          AND ome00 = g_ome.ome00
                                          AND ome03 = g_ome.ome03    #No.FUN-B90130
    IF g_ome.ome173 IS NOT NULL THEN CALL cl_err('','axr-308',0) RETURN END IF
    IF g_ome.omevoid = 'Y' THEN CALL cl_err('','axr-103',1) RETURN END IF
   #當oma33傳票編號不為NULL時,表示帳款已拋至總帳系統,不可異動
    LET g_oma33 = ''
   #SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma01=g_ome.ome16     #MOD-A40189 mark 
#No.FUN-B90130 --begin 
    IF g_aza.aza26 ='2' THEN 
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01 AND oma75 = g_ome.ome03  
    ELSE 
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01   
    END IF 
#No.FUN-B90130 --end    
    IF NOT cl_null(g_oma33) THEN CALL cl_err('','axr-384',0) RETURN END IF
   #-MOD-A80246-add-
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt
      FROM amd_file
     WHERE amd03 = g_ome.ome01
    IF g_cnt > 0 THEN
       CALL cl_err('','amd-030',0) 
       RETURN
    END IF
   #-MOD-A80246-add-
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ome01_t = g_ome.ome01
    LET g_ome16_t = g_ome.ome16   #MOD-760006
    LET g_ome_t.* = g_ome.*
    BEGIN WORK
    LET g_success = 'Y'

    LET g_ome03 = g_ome.ome03    #FUN-C70030 add 
    OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03     #No.FUN-B90130 
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_ome.*               # 對DB鎖定
    LET g_ome.ome03 = g_ome03                #FUN-C70030 add 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
        ROLLBACK WORK RETURN
    END IF
    CALL t310_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ome.omemodu = g_user
        LET g_ome.omemodd = g_today            #TQC-BC0083
        #LET g_ome.omedate = g_today           #TQC-BC0083 mark
        CALL t310_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ome.*=g_ome_t.*
           CALL t310_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE ome_file SET * = g_ome.*
            WHERE ome00 = g_ome.ome00 AND ome01 = g_ome_t.ome01 AND (ome03 = g_ome_t.ome03 OR ome03 =' ') # COLAUTH?   #No.FUN-B90130 add ome03 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ome_file",g_ome01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
           CONTINUE WHILE
        END IF
        #CHI-A70028 add --start--
        LET l_omee.omee01 = g_ome.ome01
        LET l_omee.omee02 = g_ome.ome16
        LET l_omee.omeedate = g_today
        LET l_omee.omeemodu = g_user
        UPDATE omee_file SET omee01 = l_omee.omee01,
                             omee02 = l_omee.omee02,
                             omeedate = l_omee.omeedate,
                             omeemodu = l_omee.omeemodu
        #WHERE omee01 = g_ome_t.ome01 AND omee02 = g_moe_t.ome16   #MOD-BB0015 mark
         WHERE omee01 = g_ome_t.ome01 AND omee02 = g_ome_t.ome16   #MOD-BB0015 add
           AND (omee03 = g_ome_t.ome03 OR omee03 = ' ')            #No.FUN-B90130

        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","omee_file",g_ome_t.ome01,"",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF
        #CHI-A70028 add --end-- 
        SELECT oom09 INTO l_oom09 FROM oom_file 
         WHERE oom07 <= g_ome.ome01 
           AND oom08 >= g_ome.ome01
           AND (oom16 = g_ome.ome03 OR oom16 IS NULL )  #No.FUN-B90130
        IF STATUS THEN RETURN END IF
        IF g_ome.ome01 >= l_oom09 THEN 
           UPDATE oom_file SET oom09=g_ome.ome01,
                               oom10=g_ome.ome02
             WHERE oom07 <= g_ome.ome01
               AND oom08 >= g_ome.ome01
               AND (oom16 = g_ome.ome03 OR oom16 IS NULL )  #No.FUN-B90130
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err3("upd","oom_file",g_ome.ome01,"",SQLCA.sqlcode,"","upd oom09",1)  
              CONTINUE WHILE
           END IF
        END IF
        IF g_ome.ome02 != g_ome_t.ome02 THEN
#No.FUN-B90130 --begin 
        IF g_aza.aza26 ='2' THEN 
           UPDATE oma_file SET oma09 = g_ome.ome02
            WHERE oma10 = g_ome.ome01 
              AND oma75 = g_ome.ome03   
        ELSE 
           UPDATE oma_file SET oma09 = g_ome.ome02
            WHERE oma10 = g_ome.ome01 
        END IF 
#No.FUN-B90130 --end 
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("upd","oma_file",g_ome.ome01,"",SQLCA.sqlcode,"","upd oma",1)  #No.FUN-660116
              LET g_success ='N'
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t310_cl
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t310_r()
    DEFINE tot     LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6) #MOD-5A0209
 
    IF g_ome.ome01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ome.* FROM ome_file WHERE ome01 = g_ome.ome01
                                          AND ome00 = g_ome.ome00
                                          AND (ome03 = g_ome.ome03 OR ome03 =' ')    #No.FUN-B90130
    IF g_ome.ome173 IS NOT NULL THEN CALL cl_err('','axr-308',0) RETURN END IF
    IF g_ome.omevoid = 'Y' THEN CALL cl_err('','axr-103',0) RETURN END IF
   #當oma33傳票編號不為NULL時,表示帳款已拋至總帳系統,不可異動
    LET g_oma33 = ''
   #SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma01=g_ome.ome16     #MOD-A40189 mark 
#No.FUN-B90130 --begin 
    IF g_aza.aza26 ='2' THEN 
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01 AND oma75 = g_ome.ome03     
    ELSE 
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01   
    END IF 
#No.FUN-B90130 --end 
    IF NOT cl_null(g_oma33) THEN CALL cl_err('','axr-384',0) RETURN END IF
   #-MOD-A80246-add-
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt
      FROM amd_file
     WHERE amd03 = g_ome.ome01
    IF g_cnt > 0 THEN
       CALL cl_err('','amd-030',0) 
       RETURN
    END IF
   #-MOD-A80246-add-
 
    LET g_success = 'Y'   #MOD-5A0209
    BEGIN WORK
    LET g_ome03 = g_ome.ome03       #FUN-C70030 add 
    OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03     #No.FUN-B90130 
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_ome.*
    LET g_ome.ome03 = g_ome03                #FUN-C70030 add
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
    END IF
    CALL t310_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ome01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ome.ome01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ome_file WHERE ome00 = g_ome.ome00
                              AND ome01 = g_ome.ome01
                              AND (ome03 = g_ome.ome03 OR ome03 =' ')     #No.FUN-B90130 
       #CHI-A70028 add --start--
       DELETE FROM omee_file WHERE omee01 = g_ome.ome01  AND omee03 = g_ome.ome03  #No.FUN-B90130
       #CHI-A70028 add --end--
       CALL t310_r_minus_invno()
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)      #FUN-980011 add
          VALUES ('axrt310',g_user,g_today,g_msg,g_ome.ome01,'delete',g_plant,g_legal)  #FUN-980011 add
    DECLARE oma_curs2 CURSOR FOR
     SELECT * FROM oma_file WHERE oma10 = g_ome.ome01 AND (oma75 = g_ome.ome03 OR oma75 IS NULL )  #No.FUN-B90130
    FOREACH oma_curs2 INTO g_oma.*
       IF STATUS THEN
          CALL cl_err('foreach oma:',STATUS,1) LET g_success = 'N'
          EXIT FOREACH #MOD-630088
       END IF
       IF g_oma.omavoid = 'Y' THEN
          CALL cl_err(g_oma.oma01,'axr-103',0) LET g_success = 'N'
          EXIT FOREACH #MOD-630088
       END IF
       UPDATE omc_file SET omc12='' WHERE omc12=g_ome.ome01   #MOD-810062
#No.FUN-B90130 --begin 
       IF g_aza.aza26 ='2' THEN 
          UPDATE oma_file SET oma10 = NULL,
                              oma71 = NULL,   #FUN-970108 add 
                              oma75 = NULL    #No.FUN-B90130 
           WHERE oma10 = g_ome.ome01   #MOD-810062 
             AND oma75 = g_ome.ome03   #No.FUN-B90130        
       ELSE 
          UPDATE oma_file SET oma10 = NULL,
                              oma71 = NULL,   #FUN-970108 add 
                              oma75 = NULL    #No.FUN-B90130 
           WHERE oma10 = g_ome.ome01   #MOD-810062 
       END IF 
#No.FUN-B90130 --end 
       CALL s_upd_ogb60(g_oma.oma01)       #MOD-810062
       LET g_plant_new=g_oma.oma66
       CALL s_getdbs()
 
      LET g_plant_new = g_oma.oma66
      LET l_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra
 
       IF g_oma.oma00 = '11' OR g_oma.oma00 = '14' OR
          g_oma.oma00 = '22' OR g_oma.oma00 = '23' OR
          g_oma.oma00 = '24' OR g_oma.oma00 = '25' OR
          g_oma.oma00 = '31' OR g_oma.oma00 = '13' THEN   #MOD-C40057 add 13類
          CONTINUE FOREACH
       END IF
       DECLARE omb_curs2 CURSOR FOR SELECT * FROM omb_file WHERE omb01=g_oma.oma01
       FOREACH omb_curs2 INTO b_omb.*
          IF STATUS THEN
             CALL cl_err('foreach omb:',STATUS,1) LET g_success = 'N'
             EXIT FOREACH #MOD-630088
          END IF
          SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file   #MOD-630088   #MOD-760035   取消mark
            WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omavoid='N'   #MOD-760035
              AND omb32=b_omb.omb32    #MOD-760035
              AND oma00=g_oma.oma00
          IF cl_null(tot) THEN LET tot = 0 END IF
          
          IF NOT cl_null(b_omb.omb31) THEN   #MOD-8B0274 add
             IF b_omb.omb38 !='3' THEN
                #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," oga_file", #FUN-980093 add
                LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                            "   SET oga54 = oga54 - ? ",
                            " WHERE oga01 = ? "
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
                PREPARE t310_upd_oga1 FROM g_sql
                EXECUTE t310_upd_oga1 USING tot,b_omb.omb31
             ELSE
                #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," oha_file",  #FUN-980093 add
                LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                            "   SET oha54 = oha54 - ? ",
                            " WHERE oha01 = ? "
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
                PREPARE t310_upd_oha1 FROM g_sql
                EXECUTE t310_upd_oha1 USING tot,b_omb.omb31
             END IF
 
             IF STATUS THEN
                CALL cl_err('upd oga54',SQLCA.SQLCODE,1) 
                LET g_success='N'
                EXIT FOREACH #MOD-630088
             END IF
             IF SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err('upd oga54','axr-134',1) LET g_success='N'
                EXIT FOREACH #MOD-630088
             END IF
          END IF   #MOD-8B0274 add
       END FOREACH
    END FOREACH
    END IF
    CLOSE t310_cl
   IF g_success = 'Y' THEN
      CLEAR FORM
      INITIALIZE g_ome.* TO NULL
      MESSAGE ""
      CLEAR FORM
      OPEN t310_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t310_cs
         CLOSE t310_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t310_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t310_cs
         CLOSE t310_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t310_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t310_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t310_fetch('/')
      END IF
      COMMIT WORK
   ELSE
      ROLLBACK WORK RETURN
   END IF
END FUNCTION
 
FUNCTION t310_r_minus_invno()
  #DEFINE l_oom07            LIKE oom_file.oom07 #CHI-A70028 mark
  #DEFINE l_oom11            LIKE oom_file.oom11 #CHI-A70028 mark
  #DEFINE l_oom12            LIKE oom_file.oom12 #CHI-A70028 mark
   DEFINE l_last_no          LIKE oom_file.oom09
   DEFINE l_i                LIKE type_file.num5          #No.FUN-680123 SMALLINT
   DEFINE g_format           LIKE oom_file.oom07          #No.FUN-680123 VARCHAR(16)
   DEFINE l_last_date        LIKE type_file.dat           #No.FUN-680123 DATE
   DEFINE l_oom RECORD LIKE oom_file.*   #CHI-A70028 add

   LET l_last_no = g_ome.ome01
   LET l_last_date = g_ome.ome02 #NO:3921
  #SELECT oom07,oom11,oom12 INTO l_oom07,l_oom11,l_oom12   #No.FUN-560198 #CHI-A70028 mark
   SELECT * INTO l_oom.*   #CHI-A70028
   FROM oom_file WHERE oom09=g_ome.ome01
   IF STATUS THEN RETURN END IF
   #CHI-A70028 mod l_oom->l_oom.oom --start--
   WHILE TRUE
      LET g_format = ''   #MOD-830162
      IF cl_null(l_oom.oom11) THEN LET l_oom.oom11 = 3 END IF  #CHI-A70028 mod 
      IF cl_null(l_oom.oom12) THEN LET l_oom.oom12 = 10 END IF #CHI-A70028 mod
      FOR l_i = l_oom.oom11 TO l_oom.oom12 #CHI-A70028 mod
         LET g_format = '&',g_format CLIPPED
      END FOR
      IF l_last_no[l_oom.oom11,l_oom.oom12]-1 >= 0 THEN   #MOD-BB0055 add
         IF l_oom.oom11 > 1 THEN #CHI-A70028 mod
            LET l_last_no=l_last_no[1,l_oom.oom11-1], #CHI-A70028 mod
               (l_last_no[l_oom.oom11,l_oom.oom12]-1) USING g_format #CHI-A70028 mod
         ELSE
            LET l_last_no=l_last_no[l_oom.oom11,l_oom.oom12]-1 USING g_format #CHI-A70028 mod
         END IF
     #str MOD-BB0055 add
      ELSE
         LET l_last_no  =NULL
         LET l_last_date=NULL
         EXIT WHILE
      END IF
     #end MOD-BB0055 add
      IF l_last_no<l_oom.oom07 THEN #CHI-A70028 mod
          LET l_last_no = NULL
          LET l_last_date=NULL
      EXIT WHILE END IF
      SELECT ome01 FROM ome_file WHERE ome01=l_last_no
                                   AND ome00 = g_ome.ome00 #MOD-B40083
                                   AND (ome03 = g_ome.ome03 OR ome03 =' ')  #No.FUN-B90130
      SELECT ome02 INTO l_last_date FROM ome_file WHERE ome01=l_last_no      #MOD-990269 add
                                                    AND ome00 = g_ome.ome00  #MOD-B40083
                                                    AND (ome03 = g_ome.ome03 OR ome03 =' ')  #No.FUN-B90130
      IF STATUS=0 THEN EXIT WHILE END IF
   END WHILE
   UPDATE oom_file SET oom09 = l_last_no , oom10=l_last_date #NO:3921
      #CHI-A70028 mod --start--
      #WHERE oom01=l_oom01 AND oom02 =l_oom02 AND oom021=l_oom021 and oom03=l_oom03 AND oom04=l_oom04 AND oom05=l_oom05
       WHERE oom01=l_oom.oom01 
         AND oom02 =l_oom.oom02 
         AND oom021=l_oom.oom021 
         AND oom03=l_oom.oom03 
         AND oom04=l_oom.oom04 
         AND oom05=l_oom.oom05
         AND oom15=l_oom.oom15   #No.FUN-B90130
      #CHI-A70028 mod --end--
   MESSAGE 'invoice no return to:',l_last_no RETURN
   #CHI-A70028 mod l_oom->l_oom.oom --end--
END FUNCTION
 
FUNCTION t310_m()
 DEFINE old_prsw LIKE ome_file.omeprsw

   IF g_ome.omevoid = 'Y' THEN RETURN END IF
   IF cl_null(g_ome.ome01) THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK

   LET g_ome03 = g_ome.ome03          #FUN-C70030 add 
   OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03     #No.FUN-B90130
    
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl:", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_ome.*               # 對DB鎖定
   LET g_ome.ome03 = g_ome03                #FUN-C70030 add
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
   END IF
    INPUT BY NAME g_ome.omeprsw WITHOUT DEFAULTS
        AFTER FIELD omeprsw
           IF g_ome.omeprsw < 0 THEN
              CALL cl_err(g_ome.omeprsw,'axm-179',0)
              NEXT FIELD omeprsw
           END IF
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
       LET g_ome.omeprsw = old_prsw
       DISPLAY BY NAME g_ome.omeprsw
       RETURN
    END IF
 
 
    UPDATE ome_file SET omeprsw = g_ome.omeprsw WHERE ome01 = g_ome.ome01
                                                  AND ome00 = g_ome.ome00 #MOD-B40083
                                                  AND (ome03 = g_ome.ome03 OR ome03 =' ')  #No.FUN-B90130

    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       LET g_success = 'N'
       CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.sqlcode,"","upd omeprsw",1)  #No.FUN-660116
    END IF
    IF g_success = 'Y'
    THEN COMMIT WORK
    ELSE ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t310_x() 			# when g_ome.omevoid='N' (Turn to 'Y')
   DEFINE tot       LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)   #MOD-5A0209
   DEFINE l_azf09   LIKE azf_file.azf09          #No.FUN-930106

   IF cl_null(g_ome.ome01) OR cl_null(g_ome.ome00) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
   SELECT * INTO g_ome.* FROM ome_file    #FUN-C70030 add
     WHERE ome00 = g_ome.ome00 AND ome01 = g_ome.ome01   #FUN-C70030 add
       AND ome03 = g_ome.ome03    #FUN-C70030 add
   LET g_ome_t.*  = g_ome.*   #FUN-C70030 add
   IF g_ome.ome173 IS NOT NULL THEN CALL cl_err('','axr-308',0) RETURN END IF  
   IF g_ome.omevoid='Y' THEN 
      CALL cl_err('','axr006',0)   #FUN-C70030 add
      RETURN 
    END IF
   #當oma33傳票編號不為NULL時,表示帳款已拋至總帳系統,不可異動
    LET g_oma33 = ''
   #SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma01=g_ome.ome16     #MOD-A40189 mark 
#No.FUN-B90130 --begin 
    IF g_aza.aza26 ='2' THEN 
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01 AND oma75 = g_ome.ome03    
    ELSE 
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01  
    END IF 
#No.FUN-B90130 --end 
    IF NOT cl_null(g_oma33) THEN CALL cl_err('','axr-384',0) RETURN END IF
   #-MOD-A80246-add-
    LET g_cnt = 0
#FUN-B90024-------begin----------
#   IF cl_null(g_flag) THEN      #FUN-B90114  mark
    IF g_argv1 <> '1' OR cl_null(g_argv1) THEN       #FUN-B90114
       SELECT COUNT(*) INTO g_cnt
         FROM amd_file
        WHERE amd03 = g_ome.ome01
    ELSE   #axrt311 
      #FUN-C70030 add START
       IF g_ome.ome22 = 'Y' THEN  #為電子發票 
          IF cl_null(g_ome.omexml) THEN    #當電子發票匯出序號為null時不可作廢
             CALL cl_err('','axr004',0)
             RETURN
          END IF
          IF g_ome.omecncl = 'Y' THEN       #當電子發票已註銷,則提醒user是否將註銷資料刪除
             IF NOT cl_confirm('axr005') THEN RETURN END IF   
             LET g_ome.omecncl = 'N'
             LET g_ome.omecncl2 = NULL
             LET g_ome.omecnclu = NULL
             LET g_ome.omecncld = NULL
             LET g_ome.omecnclt = NULL
             LET g_ome.omecnclm = NULL
             LET g_ome.omexml   = NULL
             DISPLAY ' ' TO azf1 
             DISPLAY BY NAME g_ome.omexml
             DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                             g_ome.omecnclt,g_ome.omecnclm
          END IF
       END IF
      #FUN-C70030 add END  
       SELECT COUNT(*) INTO g_cnt
         FROM amd_file
        WHERE amd25 = g_ome.ome73
          AND amd26 = YEAR(g_ome.ome02) 
          AND amd27 = MONTH(g_ome.ome02)
          AND amd126 = g_ome.ome71
    END IF 
#FUN-B90024-------end------------
    IF g_cnt > 0 THEN
       CALL cl_err('','amd-030',0) 
       RETURN
    END IF
   #-MOD-A80246-add-
 
   LET g_success = 'Y'
   BEGIN WORK
 
   LET g_ome03 = g_ome.ome03         #FUN-C70030 add
   OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03   #No.FUN-B90130
    
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl:", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_ome.*               # 對DB鎖定
   LET g_ome.ome03  = g_ome03               #FUN-C70030 add
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
   END IF
   LET g_ome.omevoid = 'Y'           #FUN-C70030 add
   DISPLAY BY NAME g_ome.omevoid     #FUN-C70030 add
   IF g_argv1 = '1' THEN   #artx311   #FUN-C70030 add
      INPUT BY NAME g_ome.omevoid2 ,g_ome.omevoidn, g_ome.omevoidm   #FUN-C70030 add omevoidn,omevoidm
          WITHOUT DEFAULTS
 
        AFTER FIELD omevoid2
           SELECT azf03,azf09 INTO g_buf,l_azf09 FROM azf_file WHERE azf01 = g_ome.omevoid2      #No.FUN-930106
                                                   AND azf02 = '2'   
           IF STATUS THEN 
              CALL cl_err3("sel","azf_file",g_ome.omevoid2,"",STATUS,"","",1)  #No.FUN-660116   #MOD-830227
              NEXT FIELD omevoid2 
           ELSE                               #No.FUN-930106
              IF l_azf09 !='F' THEN 
                 CALL cl_err('','aoo-414',1)
                 NEXT FIELD omevoid2  
              END IF 
           END IF
           DISPLAY g_buf TO azf03   #MOD-830227
        ON ACTION controlp
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_azf01a"                                  #No.FUN-930106
           LET g_qryparam.default1 = g_ome.omevoid2
           LET g_qryparam.arg1 ='F'                                          #No.FUN-930106
           CALL cl_create_qry() RETURNING g_ome.omevoid2
           DISPLAY BY NAME g_ome.omevoid2
           SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=g_ome.omevoid2 AND azf02='2'   #FUN-C70030 add 
           DISPLAY g_msg TO azf03    #FUN-C70030 add 
           NEXT FIELD omevoid2
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
  #FUN-C70030 add START
   ELSE
      INPUT BY NAME g_ome.omevoid2 
          WITHOUT DEFAULTS

        AFTER FIELD omevoid2
           SELECT azf03,azf09 INTO g_buf,l_azf09 FROM azf_file WHERE azf01 = g_ome.omevoid2      #No.FUN-930106
                                                   AND azf02 = '2'
           IF STATUS THEN
              CALL cl_err3("sel","azf_file",g_ome.omevoid2,"",STATUS,"","",1)  #No.FUN-660116   #MOD-830227
              NEXT FIELD omevoid2
           ELSE                               #No.FUN-930106
              IF l_azf09 !='F' THEN
                 CALL cl_err('','aoo-414',1)
                 NEXT FIELD omevoid2
              END IF
           END IF
           DISPLAY g_buf TO azf03   #MOD-830227
        ON ACTION controlp
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_azf01a"                                  #No.FUN-930106
           LET g_qryparam.default1 = g_ome.omevoid2
           LET g_qryparam.arg1 ='F'                                          #No.FUN-930106
           CALL cl_create_qry() RETURNING g_ome.omevoid2
           SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=g_ome.omevoid2 AND azf02='2'   #FUN-C70030 add
           DISPLAY g_msg TO azf03    #FUN-C70030 add 
           DISPLAY BY NAME g_ome.omevoid2
           NEXT FIELD omevoid2
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
   END IF
  #FUN-C70030 add END
   IF INT_FLAG THEN 
      LET INT_FLAG=0 
     #FUN-C70030 add START
      LET g_ome.* = g_ome_t.*   
      DISPLAY ' ' TO azf03 
      IF g_argv1 = '1' THEN
         DISPLAY BY NAME g_ome.omexml,  g_ome.omevoid, g_ome.omevoid2, g_ome.omevoidu, g_ome.omevoidd,
                         g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm
         DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                         g_ome.omecnclt,g_ome.omecnclm
      ELSE
         DISPLAY BY NAME g_ome.omevoid, g_ome.omevoid2
      END IF
     #FUN-C70030 add END
      COMMIT WORK 
   RETURN END IF
 
   CALL t310_s1()
   DECLARE oma_curs3 CURSOR FOR
      SELECT * FROM oma_file WHERE oma10 = g_ome.ome01 AND (oma75 = g_ome.ome03 OR oma75 IS NULL )  #No.FUN-B90130


   FOREACH oma_curs3 INTO g_oma.*
     IF STATUS THEN
        CALL cl_err('foreach oma:',STATUS,1) LET g_success = 'N'
        EXIT FOREACH #MOD-630088
     END IF
     IF g_oma.omavoid = 'Y' THEN
        CALL cl_err(g_oma.oma01,'axr-103',0) LET g_success = 'N'
        EXIT FOREACH #MOD-630088
     END IF
     IF g_aza.aza26 = '2' OR 
        g_ome.ome00 = '1' OR g_ome.ome00 = '3' THEN 
        UPDATE oma_file SET oma10 = NULL,
                            oma71 = NULL,    #FUN-970108 add
                            oma75 = NULL     #No.FUN-B90130
         WHERE oma01 = g_oma.oma01
        IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.SQLCODE,"","upd oma10",1)  
           LET g_success = 'N' 
           EXIT FOREACH
        END IF
        CALL s_upd_ogb60(g_oma.oma01)     
      END IF
      LET g_plant_new=g_oma.oma66
      CALL s_getdbs()
      LET g_plant_new = g_oma.oma66
      LET l_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra
      IF g_oma.oma00 = '11' OR g_oma.oma00 = '14' OR
         g_oma.oma00 = '22' OR g_oma.oma00 = '23' OR
         g_oma.oma00 = '24' OR g_oma.oma00 = '25' OR
         g_oma.oma00 = '31' OR g_oma.oma00 = '13' THEN  #MOD-C40141 add '13'
         CONTINUE FOREACH
      END IF
      DECLARE omb_curs3 CURSOR FOR SELECT * FROM omb_file WHERE omb01=g_oma.oma01
      FOREACH omb_curs3 INTO b_omb.*
        IF STATUS THEN
           CALL cl_err('foreach omb:',STATUS,1) LET g_success = 'N'
           EXIT FOREACH #MOD-630088
        END IF
        SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file   #MOD-630088   #MOD-760035   取消mark
          WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omavoid='N'   #MOD-760035
            AND omb32=b_omb.omb32    #MOD-760035
            AND oma00=g_oma.oma00
        IF cl_null(tot) THEN LET tot = 0 END IF
        IF NOT cl_null(b_omb.omb31) THEN   #MOD-8B0274 add
           IF b_omb.omb38 !='3' THEN         
              #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," oga_file", #FUN-980093 add
              LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                          "   SET oga54 = oga54 - ? ",
                          " WHERE oga01 = ? "
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
              CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
              PREPARE t310_upd_oga2 FROM g_sql
              EXECUTE t310_upd_oga2 USING tot,b_omb.omb31
           ELSE
              #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," oha_file",  #FUN-980093 add
              LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                          "   SET oha54 = oha54 - ? ",
                          " WHERE oha01 = ? "
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
              CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
              PREPARE t310_upd_oha2 FROM g_sql
              EXECUTE t310_upd_oha2 USING tot,b_omb.omb31
           END IF
           IF STATUS THEN
              CALL cl_err('upd oga54',SQLCA.SQLCODE,1)
              LET g_success='N'
              EXIT FOREACH #MOD-630088
           END IF
           IF SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err('upd oga54','axr-134',1) LET g_success='N'
              EXIT FOREACH #MOD-630088
           END IF
        END IF   #MOD-8B0274 add
     END FOREACH
  END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_ome.omevoid='Y'
      LET g_ome.omevoidu=g_user
      LET g_ome.omevoidd=TODAY
      DISPLAY BY NAME g_ome.omevoid
      DISPLAY BY NAME g_ome.omevoidu
      DISPLAY BY NAME g_ome.omevoidd
     #FUN-C70030 add START
      LET g_ome.omecncl = 'N'
      LET g_ome.omecncl2 = NULL
      LET g_ome.omecnclu = NULL
      LET g_ome.omecncld = NULL
      LET g_ome.omecnclt = NULL
      LET g_ome.omecnclm = NULL
      LET g_ome.omexml   = NULL
      DISPLAY BY NAME g_ome.omexml, g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm 
      DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                      g_ome.omecnclt,g_ome.omecnclm
     #FUN-C70030 add END
   ELSE 
      LET g_ome.omevoid='N' 
     #FUN-C70030 add START
      LET g_ome.* = g_ome_t.*
      DISPLAY BY NAME g_ome.omexml,  g_ome.omevoid, g_ome.omevoid2, g_ome.omevoidu, g_ome.omevoidd,
                      g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm
      DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                      g_ome.omecnclt,g_ome.omecnclm
     #FUN-C70030 add END
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","",g_ome.omevoid,"")
END FUNCTION
 
FUNCTION t310_s1()
#FUN-B90024-------begin----------
#  IF cl_null(g_flag) THEN            #FUN-B90114 mark
   IF g_argv1 <> '1' OR cl_null(g_argv1) THEN
      UPDATE ome_file SET omevoid='Y',
                          omevoid2=g_ome.omevoid2,
                          omevoidu=g_user,
                          omevoidd=TODAY
       WHERE ome01=g_ome.ome01
         AND ome00 = g_ome.ome00 #MOD-B40083
         AND (ome03 = g_ome.ome03 OR ome03 =' ') #No.FUN-B90130
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1)  #No.FUN-660116
          LET g_success='N' RETURN
       END IF
   ELSE     #axrt311
      LET g_ome.omevoidt = TIME
      UPDATE ome_file SET omevoid='Y',
                          omevoid2=g_ome.omevoid2,
                          omevoidu=g_user,
                          omevoidd=TODAY,
                          omevoidt= g_ome.omevoidt,    #FUN-C70030 add
                          omevoidn = g_ome.omevoidn,   #FUN-C70030 add
                          omevoidm = g_ome.omevoidm,   #FUN-C70030 add
                          omexml = '',                 #FUN-C70030 add
                          omecncl = 'N',               #FUN-C70030 add
                          omecncl2 = NULL,             #FUN-C70030 add
                          omecnclu = NULL,             #FUN-C70030 add
                          omecncld = NULL,             #FUN-C70030 add
                          omecnclt = NULL,             #FUN-C70030 add
                          omecnclm = NULL,             #FUN-C70030 add        
                          omemodu = g_user,
                          omemodd = g_today
       WHERE ome00 = g_ome.ome00 
         AND ome01 = g_ome.ome01 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1) 
          LET g_success='N' RETURN
       END IF
   END IF 
#FUN-B90024-------end------------
END FUNCTION
 
FUNCTION t310_z()   #undo_void
 DEFINE l_oma10      LIKE oma_file.oma10,
        l_omaconf    LIKE oma_file.omaconf,
        l_omavoid    LIKE oma_file.omavoid
 DEFINE l_oma RECORD LIKE oma_file.*   #MOD-760035
 DEFINE l_omb RECORD LIKE omb_file.*   #MOD-760035
 DEFINE tot   LIKE oga_file.oga54      #MOD-760035
 
 
   IF cl_null(g_ome.ome01) OR cl_null(g_ome.ome00) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
   SELECT * INTO g_ome.* FROM ome_file    #FUN-C70030 add
     WHERE ome00 = g_ome.ome00 AND ome01 = g_ome.ome01   #FUN-C70030 add
       AND ome03 = g_ome.ome03    #FUN-C70030 add
   IF g_ome.ome173 IS NOT NULL THEN CALL cl_err('','axr-308',0) RETURN END IF 
   IF g_ome.omevoid='N' THEN 
      CALL cl_err('','axr007',0)    #FUN-C70030 add
      RETURN 
   END IF
#FUN-B90024-------begin----------
#  IF g_ome.omevoid='Y' AND NOT cl_null(g_flag) THEN   #FUN-B90114 mark
   IF g_ome.omevoid='Y' AND g_argv1  = '1' THEN        #FUN-B90114  
       SELECT COUNT(*) INTO g_cnt
         FROM amd_file 
        WHERE amd25 = g_ome.ome73
          AND amd26 = YEAR(g_ome.ome02)
          AND amd27 = MONTH(g_ome.ome02)
          AND amd126 = g_ome.ome71
       IF g_cnt > 0 THEN
          CALL cl_err('','amd-036',0)
          RETURN
       END IF
   END IF
  #FUN-C70030 add START
   IF g_ome.ome22 = 'Y' THEN  #為電子發票時,不可直接取取消作廢
      CALL cl_err('','axr008',0) 
      RETURN
   END IF
  #FUN-C70030 add END
#FUN-B90024-------end------------
  #CHI-A70028 mark --start--
  #IF cl_null(g_ome.ome16) THEN 
  #   CALL cl_err('','axr-072',1) 
  #   UPDATE ome_file SET omevoid='N',
  #                       omevoid2=null,
  #                       omevoidu=null,
  #                       omevoidd=null,
  #                       omemodu =g_user,
  #                       omemodd =g_today
  #          WHERE ome01=g_ome.ome01
  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #      CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1) 
  #   END IF
  #   SELECT omevoid,omevoid2,omevoidu,omevoidd,omemodu,omemodd 
  #     INTO g_ome.omevoid,g_ome.omevoid2,g_ome.omevoidu,g_ome.omevoidd,
  #          g_ome.omemodu,g_ome.omemodd
  #     FROM ome_file
  #     WHERE ome01 = g_ome.ome01
  #   DISPLAY BY NAME g_ome.omevoid,g_ome.omevoid2,g_ome.omevoidu,
  #                   g_ome.omevoidd,g_ome.omemodu,g_ome.omemodd 
  #   CALL cl_set_field_pic("","","","",g_ome.omevoid,"")
  #   RETURN 
  #END IF 
  #CHI-A70028 mark --end--
   LET g_success = 'Y'
   BEGIN WORK

   LET g_ome03 = g_ome.ome03       #FUN-C70030 add 
   OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03   #No.FUN-B90130
   
    
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl:", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_ome.*               # 對DB鎖定
   LET g_ome.ome03 = g_ome03                #FUN-C70030 add
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
   END IF
   #CHI-A70028 add --start--
   DECLARE omee_curs CURSOR FOR
     SELECT omee02 FROM omee_file WHERE omee01 = g_ome.ome01 AND omee03 = g_ome.ome03    #No.FUN-B90130
   FOREACH omee_curs INTO g_ome.ome16 
   #CHI-A70028 add --end--
      #-->要先鎖住oma_file 以免有人去修正oma_file
 
      LET g_forupd_sql='SELECT oma10,omaconf,omavoid FROM oma_file ',
                       ' WHERE oma01= ?  FOR UPDATE'
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE oma_lock CURSOR FROM g_forupd_sql
      OPEN oma_lock USING g_ome.ome16
      IF SQLCA.SQLCODE THEN
         CALL cl_err('open oma_lock',SQLCA.SQLCODE,1)
         ROLLBACK WORK
         RETURN
      END IF
 
      FETCH oma_lock INTO l_oma10,l_omaconf,l_omavoid
      IF SQLCA.SQLCODE THEN
         CALL cl_err('fetch oma_lock',SQLCA.SQLCODE,1)
         ROLLBACK WORK
         RETURN
      END IF
      IF g_ooz.ooz20 = 'Y' THEN        #確認才可開發票
         IF l_omaconf = 'N' THEN
            CALL cl_err(g_ome.ome16,'axr-048',0)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      IF l_omavoid = 'Y'  THEN   #void碼己為'Y'
         CALL cl_err(g_ome.ome16,'axr-049',0)
         ROLLBACK WORK
         RETURN
      END IF
      IF not cl_null(l_oma10) THEN     #有發票資料
         CALL cl_err(g_ome.ome16,'axr-050',0)
         ROLLBACK WORK
         RETURN
      END IF
      #若為發票, 才須更新出貨單之發票號碼
      IF g_ome.ome00 = '1' OR g_ome.ome00 = '3' THEN
         UPDATE oma_file SET oma10 = g_ome.ome01,
                             oma71 = g_ome.ome60,    #FUN-970108 add
                             oma75 = g_ome.ome03     #No.FUN-B90130
                       WHERE oma01 = g_ome.ome16
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","oma_file",g_ome.ome16,"",SQLCA.SQLCODE,"","upd oma10",1)  #No.FUN-660116
            LET g_success = 'N'
         END IF
         CALL s_upd_ogb60(g_ome.ome16)  #No.MOD-650036
      END IF
     #CHI-A70028 mark --start-- 
     #UPDATE ome_file SET omevoid='N',
     #                    omevoid2=null,
     #                    omevoidu=null,
     #                    omevoidd=null,
     #                    omemodu =g_user,
     #                    omemodd =g_today
     #       WHERE ome01=g_ome.ome01
     #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #   CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1)  #No.FUN-660116
     #   LET g_success='N'
     #END IF
     #CHI-A70028 mark --end--
      SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = g_ome.ome16
      IF l_oma.oma00 != '11' AND l_oma.oma00 != '14' AND
         l_oma.oma00 != '22' AND l_oma.oma00 != '23' AND
         l_oma.oma00 != '24' AND l_oma.oma00 != '25' AND
         l_oma.oma00 != '31' AND l_oma.oma00 != '13' THEN   #MOD-C40057 add 13類
         DECLARE omb_curs5 CURSOR FOR
           SELECT * FROM omb_file WHERE omb01 = g_ome.ome16
         FOREACH omb_curs5 INTO l_omb.*
           SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file,oma_file
             WHERE omb31=l_omb.omb31 AND omb01=oma01 AND
                   omb32=l_omb.omb32 AND
                   omavoid='N' AND oma00=l_oma.oma00 AND
                   oma10 IS NOT NULL AND oma10 != ' '
           IF cl_null(tot) THEN LET tot=0 END IF
           IF NOT cl_null(l_omb.omb31) THEN   #MOD-8B0274 add
              IF l_omb.omb38 !='3' THEN    #TQC-880009 b_omb-->l_omb
                #FUN-A60056--mod--str--
                #UPDATE oga_file SET oga54 = oga54 + tot
                #  WHERE oga01 = l_omb.omb31
                 LET g_sql = "UPDATE ",cl_get_target_table(l_omb.omb44,'oga_file'),
                             "   SET oga54 = oga54 + '",tot,"'",
                             " WHERE oga01 = '",l_omb.omb31,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
                 PREPARE upd_oga54 FROM g_sql
                 EXECUTE upd_oga54
                #FUN-A60056--mod--end
              ELSE
                #FUN-A60056--mod--str--
                #UPDATE oha_file SET oha54 = oha54 + tot
                #  WHERE oha01 = l_omb.omb31
                 LET g_sql = "UPDATE ",cl_get_target_table(l_omb.omb44,'oha_file'),
                             "   SET oha54 = oha54 + '",tot,"'",
                             " WHERE oha01 = '",l_omb.omb31,"'"  
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
                 PREPARE upd_oha_cs1 FROM g_sql
                 EXECUTE upd_oha_cs1
                #FUN-A60056--mod--end
              END IF
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("upd","oga_file",l_omb.omb31,"",STATUS,"","upd oga54",1)  
                 LET g_success='N'
              END IF
           END IF   #MOD-8B0274 add
           UPDATE oma_file SET oma10 =g_ome.ome01,
                               oma71 = g_ome.ome60,    #FUN-970108 add
                               oma75 = g_ome.ome03     #No.FUN-B90130
            WHERE oma01 =g_ome.ome16     #No.MOD-860321
         END FOREACH
      END IF    #TQC-790157
   END FOREACH #CHI-A70028 add
   #CHI-A70028 add --start-- 
#FUN-B90024-------begin----------
#  IF cl_null(g_flag) THEN                  #FUN-B90114 mark
   IF g_argv1 <> '1' OR cl_null(g_argv1) THEN                    #FUN-B90114
      UPDATE ome_file SET omevoid='N',
                          omevoid2=null,
                          omevoidu=null,
                          omevoidd=null,
                          omevoidt= NULL,              #FUN-C70030 add
                          omevoidn = NULL,             #FUN-C70030 add
                          omevoidm = NULL,             #FUN-C70030 add
                          omexml = '',                 #FUN-C70030 add
                          omecncl = 'N',               #FUN-C70030 add
                          omecncl2 = NULL,             #FUN-C70030 add
                          omecnclu = NULL,             #FUN-C70030 add
                          omecncld = NULL,             #FUN-C70030 add
                          omecnclt = NULL,             #FUN-C70030 add
                          omecnclm = NULL,             #FUN-C70030 add
                          omemodu =g_user,
                          omemodd =g_today
             WHERE ome01=g_ome.ome01
               AND ome00 = g_ome.ome00 #MOD-B40083
               AND (ome03 = g_ome.ome03 OR ome03 = ' ')   #No.FUN-B90130
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1)  #No.FUN-660116
         LET g_success='N'
      END IF
  ELSE
      UPDATE ome_file SET omevoid='N',
                          omevoid2=null,
                          omevoidu=null,
                          omevoidd=null,
                          omevoidt= NULL,              #FUN-C70030 add
                          omevoidn = NULL,             #FUN-C70030 add
                          omevoidm = NULL,             #FUN-C70030 add
                          omexml = '',                 #FUN-C70030 add
                          omecncl = 'N',               #FUN-C70030 add
                          omecncl2 = NULL,             #FUN-C70030 add
                          omecnclu = NULL,             #FUN-C70030 add
                          omecncld = NULL,             #FUN-C70030 add
                          omecnclt = NULL,             #FUN-C70030 add
                          omecnclm = NULL,             #FUN-C70030 add
                          omemodu =g_user,
                          omemodd =g_today
             WHERE ome01=g_ome.ome01
               AND ome00 = g_ome.ome00  
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1) 
         LET g_success='N'
      END IF      
  END IF 
#FUN-B90024-------end-----------
   #CHI-A70028 add --end--
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_ome.omevoid='N'
      LET g_ome.omevoid2=null
      LET g_ome.omevoidu=null
      LET g_ome.omevoidd=null
      LET g_ome.omemodu =g_user
      LET g_ome.omemodd =g_today
      DISPLAY BY NAME g_ome.omevoid, g_ome.omevoid2,g_ome.omevoidu,
                     g_ome.omevoidd,g_ome.omemodu, g_ome.omemodd
      DISPLAY ' ' TO azf03   #MOD-830227
     #FUN-C70030 add START
      LET g_ome.omevoidt = NULL
      LET g_ome.omevoidn = NULL
      LET g_ome.omevoidm = NULL
      LET g_ome.omexml   = NULL
      IF g_argv1 = '1' THEN
         DISPLAY BY NAME g_ome.omexml, g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm 
         DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                         g_ome.omecnclt,g_ome.omecnclm
      END IF
     #FUN-C70030 add END 
   ELSE 
     ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","",g_ome.omevoid,"")
END FUNCTION

#CHI-A70028 add --start--
FUNCTION t310_qry_bill_detail()
  DEFINE l_omee   DYNAMIC ARRAY OF RECORD 
                          omee01 LIKE omee_file.omee01,
                          omee02 LIKE omee_file.omee02,
                          omeeuser LIKE omee_file.omeeuser,
                          omeegrup LIKE omee_file.omeegrup,
                          omeeoriu LIKE omee_file.omeeoriu,
                          omeeorig LIKE omee_file.omeeorig,
                          omeemodu LIKE omee_file.omeemodu,
                          omeedate LIKE omee_file.omeedate,
                          omeelegal LIKE omee_file.omeelegal
                          END RECORD
  DEFINE l_sql    STRING, 
         l_maxac  LIKE type_file.num5,
         l_ac     LIKE type_file.num5

   OPEN WINDOW t3101_w WITH FORM "axr/42f/axrt3101"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axrt3101")

     CALL cl_opmsg('w')
     LET l_sql = "SELECT omee01,omee02,omeeuser,omeegrup,omeeoriu, ", 
                 "       omeeorig,omeemodu,omeedate,omeelegal ", 
                 "  FROM omee_file ",
                 " WHERE omee01 ='",g_ome.ome01,"'",
                 "   AND omee03 ='",g_ome.ome03,"'"   #No.FUN-B90130 
     PREPARE t310_omee_prepare FROM l_sql
     DECLARE t310_omee_curs CURSOR FOR t310_omee_prepare
     LET l_ac = 1
     FOREACH t310_omee_curs INTO l_omee[l_ac].*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        LET l_ac = l_ac + 1
     END FOREACH
     LET l_maxac = l_ac - 1
 
     DISPLAY l_maxac TO cnt
     DISPLAY ARRAY l_omee TO s_omee.* ATTRIBUTE(COUNT=l_maxac,UNBUFFERED)

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
    
     ON ACTION about         
        CALL cl_about()      
    
     ON ACTION help          
        CALL cl_show_help()  
    
     ON ACTION controlg      
        CALL cl_cmdask()     
     END DISPLAY
 
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     CLOSE WINDOW t3101_w

END FUNCTION
#CHI-A70028 add --end--
 
## No. 增加對前端資料(應收,出貨)判斷及回寫----------
FUNCTION t310_upinv()
  DEFINE p_flag 		LIKE type_file.chr1  	  #'y':確認  'z':取消確認  #No.FUN-680123 VARCHAR(1)
  DEFINE p_oma01		LIKE oma_file.oma01       #No.FUN-680123 VARCHAR(16)  #No.FUN-550071
 
  IF cl_null(g_ome.ome01) THEN LET g_success = 'N' RETURN END IF
  DECLARE oma_curs CURSOR FOR
   SELECT * FROM oma_file WHERE oma01 = g_ome.ome16
  FOREACH oma_curs INTO g_oma.*
     IF STATUS THEN
        CALL cl_err('sel oma:',STATUS,1) LET g_success = 'N' RETURN 1
     END IF
     IF g_oma.omavoid = 'Y' THEN
        CALL cl_err(g_oma.oma01,'axr-103',0) LET g_success = 'N' RETURN 1
     END IF
     DECLARE omb_curs CURSOR FOR SELECT * FROM omb_file WHERE omb01=g_oma.oma01
     FOREACH omb_curs INTO b_omb.*
        CALL s_ar_update()
        IF g_success = 'N' THEN RETURN 1 END IF
     END FOREACH
  END FOREACH
  IF g_success='N'
     THEN RETURN 1
     ELSE RETURN 0
  END IF
END FUNCTION
 
FUNCTION s_ar_update() 				#更新出貨單/銷退單身
DEFINE tot,tot1,tot2		LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6) #FUN-4C0013
DEFINE l_oga RECORD  LIKE oga_file.*              #MOD-C30842 add
DEFINE l_ogb RECORD  LIKE ogb_file.*              #MOD-C30842 add

   IF g_oma.oma00 = '12' AND NOT cl_null(b_omb.omb31) THEN
      SELECT SUM(omb12) INTO tot FROM omb_file, oma_file
          WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
            AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
            AND oma00=g_oma.oma00
            AND oma10 IS NOT NULL AND oma10 != ' '# 98.08.10 Star 已開發票數量
      IF cl_null(tot) THEN LET tot = 0 END IF
     #FUN-A60056--mod--str--
     #SELECT * INTO g_ogb.* FROM ogb_file
     #       WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
      LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                  " WHERE ogb01 = '",b_omb.omb31,"'",
                  "   AND ogb03 = '",b_omb.omb32,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
      PREPARE sel_ogb FROM g_sql
      EXECUTE sel_ogb INTO g_ogb.*
     #FUN-A60056--mod--end
      IF STATUS THEN 
         CALL cl_err3("upd","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)  #No.FUN-660116
         LET g_success = 'N' 
         RETURN
      END IF
      IF cl_null(g_ogb.ogb917) THEN LET g_ogb.ogb917 = 0 END IF
      IF tot > g_ogb.ogb917 THEN		# 發票數量大於出貨單數量
         CALL cl_err('s_ar_upinv:omb12>ogb917','axr-174',1)
         LET g_success = 'N' RETURN
      END IF
      IF g_ooz.ooz16='Y' THEN 	# 發票確認時將發票單價更新回出貨單(Y/N)
         LET g_ogb.ogb13 = b_omb.omb13
         LET g_ogb.ogb14 = b_omb.omb14
         LET g_ogb.ogb14t= b_omb.omb14t
      END IF
       LET g_plant_new=g_oma.oma66
       CALL s_getdbs()
 
      LET g_plant_new = g_oma.oma66
      LET l_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra
 
       #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," ogb_file SET ogb13=?, ogb14=?, ogb14t=?, ogb60=?",  #FUN-980093 add
       LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
                    "  SET ogb13=?, ogb14=?, ogb14t=?, ogb60=?", 
                   " WHERE ogb01 = ? AND ogb03 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
       PREPARE t310_upd_ogb1 FROM g_sql
       EXECUTE t310_upd_ogb1 USING g_ogb.ogb13,g_ogb.ogb14,g_ogb.ogb14t,tot,b_omb.omb31,b_omb.omb32
 
      IF STATUS THEN
         CALL cl_err('upd ogb60',STATUS,1) LET g_success = 'N'
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd ogb60','axr-134',1) LET g_success = 'N' RETURN
      END IF
      IF g_ooz.ooz16='Y' THEN 	# 發票確認時將發票金額更新回出貨單頭
        #FUN-A60056--mod--str--
        #SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = b_omb.omb31
        #SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file
        #                                    WHERE ogb01 = b_omb.omb31
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                     " WHERE oga01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_oga FROM g_sql
         EXECUTE sel_oga INTO g_oga.*

         LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql 
         PREPARE sel_ogb14 FROM g_sql
         EXECUTE sel_ogb14 INTO g_oga.oga50
        #FUN-A60056--mod--end
         IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
         LET g_oga.oga21 = g_oma.oma21
         LET g_oga.oga211= g_oma.oma211
         LET g_oga.oga212= g_oma.oma212
         LET g_oga.oga213= g_oma.oma213
         LET g_oga.oga23 = g_oma.oma23
         LET g_oga.oga24 = g_oma.oma24
         LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
         LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
        #FUN-A60056--mod--str--
        #UPDATE oga_file SET *=g_oga.* WHERE oga01 = g_oga.oga01
         LET g_sql = "UPDATE ",cl_get_target_table(g_oga.ogaplant,'oga_file'),
                     "   SET oga50 = '",g_oga.oga50,"',",
                     "       oga21 = '",g_oga.oga21,"',",
                     "       oga211= '",g_oga.oga211,"',",
                     "       oga212= '",g_oga.oga212,"',",
                     "       oga213= '",g_oga.oga213,"',",
                     "       oga23 = '",g_oga.oga23,"',",
                     "       oga24 = '",g_oga.oga24,"',",
                     "       oga52 = '",g_oga.oga52,"',",
                     "       oga53 = '",g_oga.oga53,"'",
                     " WHERE oga01 = '",g_oga.oga01,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_oga.ogaplant) RETURNING g_sql
         PREPARE upd_oga_pre FROM g_sql
         EXECUTE upd_oga_pre
        #FUN-A60056--mod--end
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("upd","oga_file",g_oga.oga01,"",STATUS,"","upd oga50",1)  #No.FUN-660116
            LET g_success = 'N'
         END IF
      END IF
     #---------------------------------MOD-C30842----------------------------start
      IF g_ooz.ooz16 ='Y' AND g_oga.oga09 = '8' THEN            #出貨單走簽收流程
        #發票確認時將發票單價更新回出貨單
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 = '",g_oga.oga011,"'",
                     "   AND ogb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ogb2 FROM g_sql
         EXECUTE sel_ogb2 INTO l_ogb.*

         IF STATUS THEN
            CALL cl_err3("upd","ogb_file",g_oga.oga011,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)
            LET g_success = 'N'
            RETURN
         END IF
         IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
         IF tot > l_ogb.ogb917 THEN                                 #發票數量大於出貨單數量
            CALL cl_err('s_ar_upinv:omb12>ogb917','axr-174',1)
            LET g_success = 'N' RETURN
         END IF
         LET l_ogb.ogb13 = b_omb.omb13
         LET l_ogb.ogb14 = b_omb.omb14
         LET l_ogb.ogb14t = b_omb.omb14t
         LET g_plant_new = g_oma.oma66
         CALL s_getdbs()

         LET g_plant_new = g_oma.oma66
         LET l_plant_new = g_plant_new
         CALL s_gettrandbs()
         LET l_dbs_tra = g_dbs_tra

         LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ogb_file'),
                     "  SET ogb13=?, ogb14=?, ogb14t=?, ogb60=?",
                     " WHERE ogb01 = ? AND ogb03 = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql
         PREPARE t310_upd2_ogb1 FROM g_sql
         EXECUTE t310_upd2_ogb1 USING l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t,tot,g_oga.oga011,b_omb.omb32

         IF STATUS THEN
            CALL cl_err('upd ogb60',STATUS,1) LET g_success = 'N'
            RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('upd ogb60','axr-134',1) LET g_success = 'N' RETURN
         END IF

        #發票確認時將發票金額更新回出貨單頭
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                     " WHERE oga01 = '",g_oga.oga011,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_oga2 FROM g_sql
         EXECUTE sel_oga2 INTO l_oga.*

         LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 = '",g_oga.oga011,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ogb142 FROM g_sql
         EXECUTE sel_ogb142 INTO l_oga.oga50

         IF cl_null(l_oga.oga50) THEN LET l_oga.oga50 = 0 END IF
         LET l_oga.oga21 = g_oma.oma21
         LET l_oga.oga211= g_oma.oma211
         LET l_oga.oga212= g_oma.oma212
         LET l_oga.oga213= g_oma.oma213
         LET l_oga.oga23 = g_oma.oma23
         LET l_oga.oga24 = g_oma.oma24
         LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
         LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162 + l_oga.oga163)/100

         LET g_sql = "UPDATE ",cl_get_target_table(g_oga.ogaplant,'oga_file'),
                     "   SET oga50 = '",l_oga.oga50,"',",
                     "       oga21 = '",l_oga.oga21,"',",
                     "       oga211= '",l_oga.oga211,"',",
                     "       oga212= '",l_oga.oga212,"',",
                     "       oga213= '",l_oga.oga213,"',",
                     "       oga23 = '",l_oga.oga23,"',",
                     "       oga24 = '",l_oga.oga24,"',",
                     "       oga52 = '",l_oga.oga52,"',",
                     "       oga53 = '",l_oga.oga53,"'",
                     " WHERE oga01 = '",l_oga.oga01,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_oga.ogaplant) RETURNING g_sql
         PREPARE upd_oga2_pre FROM g_sql
         EXECUTE upd_oga2_pre
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("upd","oga_file",l_oga.oga01,"",STATUS,"","upd oga50",1)
            LET g_success = 'N'
         END IF
      END IF
     #---------------------------------MOD-C30842------------------------------end
      #未稅金額 * 出貨應收比率
      SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file
        WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
          AND oma00=g_oma.oma00
          AND oma10 IS NOT NULL AND oma10 != ' '#980810Star原幣已開發票未稅金額
      IF cl_null(tot) THEN LET tot = 0 END IF
 
      LET g_plant_new=g_oma.oma66
      CALL s_getdbs()
      LET g_plant_new = g_oma.oma66
      LET l_plant_new = g_plant_new
      CALL s_gettrandbs()
      LET l_dbs_tra = g_dbs_tra
      IF b_omb.omb38 !='3' THEN
             #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," oga_file SET oga54 = ? ",  #FUN-980093 add
             LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                          "  SET oga54 = ? ",
                         " WHERE oga01 = ? "
    	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
             PREPARE t310_upd_oga3 FROM g_sql
             EXECUTE t310_upd_oga3 USING tot,b_omb.omb31
      ELSE
             #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED," oha_file SET oha54 = oha54 - ? ",  #FUN-980093 add
             LET g_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102
                          "  SET oha54 = oha54 - ? ",
                         " WHERE oha01 = ? "
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql #FUN-980093
             PREPARE t310_upd_oha3 FROM g_sql
             EXECUTE t310_upd_oha3 USING tot,b_omb.omb31
      END IF
 
      IF STATUS THEN
         CALL cl_err('upd oga54',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oga54','axr-134',1) LET g_success = 'N' RETURN
      END IF
   END IF
   IF g_oma.oma00 = '21' AND NOT cl_null(b_omb.omb31) THEN
     #---98/07/08 modify 確認時將單價更新回銷退單
      SELECT SUM(omb12) INTO tot FROM omb_file, oma_file
       WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
         AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
         AND oma00=g_oma.oma00
      IF cl_null(tot) THEN LET tot = 0 END IF
     #FUN-A60056--mod--str--
     #SELECT * INTO g_ohb.* FROM ohb_file
     # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
      LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                  " WHERE ohb01 = '",b_omb.omb31,"'",
                  "   AND ohb03 = '",b_omb.omb32,"'" 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
      PREPARE sel_oha FROM g_sql
      EXECUTE sel_oha INTO g_ohb.*
     #FUN-A60056--mod--end
      IF STATUS THEN 
         CALL cl_err3("sel","ohb_file",b_omb.omb31,"",STATUS,"","s_ar_upinv:sel ogb",1)  #No.FUN-660116
         LET g_success = 'N' RETURN
      END IF
      IF cl_null(g_ohb.ohb917) THEN LET g_ohb.ohb917 = 0 END IF
      IF tot > g_ohb.ohb917 THEN
         CALL cl_err('tot>ohb917','axr-174',1) LET g_success = 'N' RETURN
      END IF
      IF g_ooz.ooz16='Y' THEN 	# 發票確認時將發票單價更新回出貨單(Y/N)
         LET g_ohb.ohb13 = b_omb.omb13
         LET g_ohb.ohb13 = b_omb.omb13
         LET g_ohb.ohb14 = b_omb.omb14
         LET g_ohb.ohb14t= b_omb.omb14t
      END IF
         #FUN-A60056--mod--str--
         #UPDATE ohb_file SET ohb13=g_ohb.ohb13,
         #                    ohb14=g_ohb.ohb14,
         #                    ohb14t=g_ohb.ohb14t,
         #                    ohb60=tot
         #WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
          LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                      "   SET ohb13='",g_ohb.ohb13,"',",
                      "       ohb14='",g_ohb.ohb14,"',",
                      "       ohb14t='",g_ohb.ohb14t,"',",
                      "       ohb60='",tot,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
          PREPARE upd_ohb13 FROM g_sql
          EXECUTE upd_ohb13
         #FUN-A60056--mod--end
      IF STATUS THEN
         CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,STATUS,"","upd ohb60",1)  #No.FUN-660116
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd ogb60','axr-134',1) LET g_success = 'N' RETURN
      END IF
      SELECT SUM(omb14) INTO tot FROM omb_file, oma_file
        WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
          AND oma00=g_oma.oma00
      IF cl_null(tot) THEN LET tot = 0 END IF
      #FUN-A60056--mod--str--
      #UPDATE oha_file SET oha21=g_oma.oma21,
      #                    oha211=g_oma.oma211,
      #                    oha212=g_oma.oma212,
      #                    oha213=g_oma.oma213,
      #                    oha24=g_oma.oma24,
      #                    #oha50=tot,   #MOD-760127
      #                    oha54=tot
      #WHERE oha01 = b_omb.omb31
       LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
                   "   SET oha21='",g_oma.oma21,"',",
                   "       oha211='",g_oma.oma211,"',",
                   "       oha212='",g_oma.oma212,"',",
                   "       oha213='",g_oma.oma213,"',",
                   "       oha24='",g_oma.oma24,"',",
                   "       oha54='",tot,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
      PREPARE upd_oha21 FROM g_sql
      EXECUTE upd_oha21
      #FUN-A60056--mod--end
      IF STATUS THEN
         CALL cl_err3("upd","oha_file",b_omb.omb31,"",STATUS,"","upd oha54",1)  #No.FUN-660116
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oha54','axr-134',1) LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION
FUNCTION t310_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ome00,ome01",TRUE)     #No.MOD-520043
      CALL cl_set_comp_entry("ome04,ome043",TRUE)    #MOD-BA0130
   END IF
 
END FUNCTION
 
FUNCTION t310_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ome00,ome01",FALSE)    #MOD-6A0018
   END IF
  #------------------------#MOD-BA0130------------------------start
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("ome04,ome043",FALSE)
   END IF
  #------------------------#MOD-BA0130--------------------------end
   CALL cl_set_comp_entry("omevoid,omevoid2,omevoidu,omevoidd",FALSE)        #MOD-6A0018
 
END FUNCTION
 
 FUNCTION t310x_set_entry(p_cmd)     #No.MOD-520043 add
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   CALL cl_set_comp_entry("omevoid,omevoid2,omevoidu,omevoidd",TRUE)
 
END FUNCTION
 
FUNCTION t310_set_comb()
  DEFINE comb_value STRING
  DEFINE comb_item  LIKE type_file.chr1000    
 
    IF g_aza.aza26='2' THEN                                                                                                           
    #  LET comb_value = 'A,B,C,X'      #No.TQC-A30136                           
       LET comb_value = 'A,B,C'        #No.TQC-A30136
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axr-960' AND ze02=g_lang                                                                                       
    ELSE 
#FUN-B90024------------begin----------------
#      IF cl_null(g_flag) THEN                   #FUN-B90114 mark 
       IF g_argv1 <> '1' OR cl_null(g_argv1) THEN                    #FUN-B90114 
          LET comb_value = '0,2,3,X'   
          SELECT ze03 INTO comb_item FROM ze_file                                                                                      
            WHERE ze01='axr-961' AND ze02=g_lang     
       ELSE 
          LET comb_value = '0,2,3,X,5,6'                                                                                  
          SELECT ze03 INTO comb_item FROM ze_file
            WHERE ze01='axr-961' AND ze02=g_lang 
       END IF
    END IF 
#FUN-B90024------------end------------------
    CALL cl_set_combo_items('ome212',comb_value,comb_item)
END FUNCTION
 
FUNCTION t310_ome60()
  SELECT oom13 INTO g_ome.ome60 FROM oom_file
   WHERE oom07 <= g_ome.ome01
     AND oom08 >= g_ome.ome01
     AND oom03  = g_ome.ome05 
     AND (oom16 = g_ome.ome03 OR oom16 IS NULL )  #No.FUN-B90130 
  IF SQLCA.sqlcode THEN 
     LET g_ome.ome60 = NULL 
  END IF 
  DISPLAY BY NAME g_ome.ome60     
END FUNCTION 
#No.FUN-9C0072 精簡程式碼

#FUN-C70030 add START
FUNCTION t310_cncl()
   DEFINE tot       LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)   #MOD-5A0209
   DEFINE l_azf09   LIKE azf_file.azf09          #No.FUN-930106

    IF g_argv1 <> '1' OR cl_null(g_argv1) THEN RETURN END IF
    IF cl_null(g_ome.ome01) OR cl_null(g_ome.ome00) THEN CALL cl_err('',-400,0) RETURN END IF 
    SELECT * INTO g_ome.* FROM ome_file    
      WHERE ome00 = g_ome.ome00 AND ome01 = g_ome.ome01 
        AND ome03 = g_ome.ome03   
    LET g_ome_t.* = g_ome.* 
    IF g_ome.ome173 IS NOT NULL THEN CALL cl_err('','axr-308',0) RETURN END IF
    IF g_ome.omecncl='Y' THEN
      CALL cl_err('','axr010',0) 
      RETURN
    END IF
    IF g_ome.ome22 = 'N' THEN  #非電子發票不可註銷
       CALL cl_err('','axr012',0)
       RETURN
    END IF 
   #當oma33傳票編號不為NULL時,表示帳款已拋至總帳系統,不可異動
    LET g_oma33 = ''
    IF g_aza.aza26 ='2' THEN
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01 AND oma75 = g_ome.ome03
    ELSE
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01
    END IF
    IF NOT cl_null(g_oma33) THEN CALL cl_err('','axr-384',0) RETURN END IF
    LET g_cnt = 0
    IF g_ome.ome22 = 'Y' THEN  #為電子發票
       IF cl_null(g_ome.omexml) THEN    #當電子發票匯出序號為null時不可註銷
          CALL cl_err('','axr009',0)
          RETURN
       END IF
       IF g_ome.omevoid = 'Y' THEN       #當電子發票已作廢,則提醒user是否將作廢資料刪除
          IF NOT cl_confirm('axr011') THEN RETURN END IF
             LET g_ome.ome172 = NULL
             LET g_ome.omevoid = 'N'
             LET g_ome.omevoid2 = NULL
             LET g_ome.omevoidu = NULL
             LET g_ome.omevoidd = NULL
             LET g_ome.omevoidt = NULL
             LET g_ome.omevoidn = NULL
             LET g_ome.omevoidm = NULL
             LET g_ome.omexml   = NULL
             DISPLAY ' ' TO azf03
             DISPLAY BY NAME g_ome.ome172,g_ome.omexml, g_ome.omevoid, g_ome.omevoid2, g_ome.omevoidu,
                             g_ome.omevoidd,g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm
       END IF
    END IF
    SELECT COUNT(*) INTO g_cnt
      FROM amd_file
     WHERE amd25 = g_ome.ome73
       AND amd26 = YEAR(g_ome.ome02)
       AND amd27 = MONTH(g_ome.ome02)
       AND amd126 = g_ome.ome71
    IF g_cnt > 0 THEN
       CALL cl_err('','amd-030',0)
       RETURN
    END IF

   LET g_success = 'Y'
   BEGIN WORK

   LET g_ome03 = g_ome.ome03       #FUN-C70030 add
   OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03   

   IF STATUS THEN
      CALL cl_err("OPEN t310_cl:", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_ome.*               # 對DB鎖定
   LET g_ome.ome03 = g_ome03                #FUN-C70030 add
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
   END IF
   LET g_ome.omecncl = 'Y' 
   LET g_ome.ome172 = NULL 
   DISPLAY BY NAME g_ome.ome172,g_ome.omecncl
   INPUT BY NAME g_ome.omecncl2 ,g_ome.omecnclm  
       WITHOUT DEFAULTS

     AFTER FIELD omecncl2
        SELECT azf03,azf09 INTO g_buf,l_azf09 FROM azf_file 
           WHERE azf01 = g_ome.omecncl2      
             AND azf02 = '2'
        IF STATUS THEN
           CALL cl_err3("sel","azf_file",g_ome.omevoid2,"",STATUS,"","",1)  
           NEXT FIELD omecncl2
        ELSE                            
           IF l_azf09 !='F' THEN
              CALL cl_err('','aoo-414',1)
              NEXT FIELD omecncl2
           END IF
        END IF
        DISPLAY g_buf TO azf1   
     ON ACTION controlp
        CALL cl_init_qry_var()
        LET g_qryparam.form = "q_azf01a"                                 
        LET g_qryparam.default1 = g_ome.omecncl2
        LET g_qryparam.arg1 ='F'                                         
        CALL cl_create_qry() RETURNING g_ome.omecncl2
        SELECT azf03 INTO g_msg FROM azf_file WHERE azf01=g_ome.omecncl2 AND azf02='2'   
        DISPLAY g_msg TO azf03   
        DISPLAY BY NAME g_ome.omecncl2
        NEXT FIELD omecncl2

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
      LET g_ome.* = g_ome_t.*
      DISPLAY ' ' TO azf1
      DISPLAY BY NAME g_ome.ome172,  g_ome.omexml,   g_ome.omevoid, g_ome.omevoid2, g_ome.omevoidu, g_ome.omevoidd,
                      g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm
      DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                      g_ome.omecnclt,g_ome.omecnclm
      COMMIT WORK 
      RETURN 
   END IF
   CALL t310_cncl2()
   IF g_success = 'Y' THEN
      COMMIT WORK     
      LET g_ome.ome172 = NULL
      LET g_ome.omevoid = 'N'
      LET g_ome.omevoid2 = NULL
      LET g_ome.omevoidu = NULL 
      LET g_ome.omevoidd = NULL
      LET g_ome.omevoidt = NULL
      LET g_ome.omevoidn = NULL
      LET g_ome.omevoidm = NULL
      LET g_ome.omexml   = NULL 
      LET g_ome.omecnclu = g_user
      LET g_ome.omecncld = TODAY
      LET g_ome.omecnclt = TIME
      DISPLAY BY NAME g_ome.ome172,  g_ome.omexml, g_ome.omevoid, g_ome.omevoid2, g_ome.omevoidu, g_ome.omevoidd,
                      g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm
      DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                      g_ome.omecnclt,g_ome.omecnclm
   ELSE
      LET g_ome.omecncl = 'N' 
      LET g_ome.* = g_ome_t.*
      ROLLBACK WORK
      DISPLAY BY NAME g_ome.omexml,  g_ome.omevoid, g_ome.omevoid2, g_ome.omevoidu, g_ome.omevoidd,
                      g_ome.omevoidt,g_ome.omevoidn, g_ome.omevoidm
      DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecnclu, g_ome.omecncld,
                      g_ome.omecnclt,g_ome.omecnclm 
   END IF
   CALL t310_show()

END FUNCTION

FUNCTION t310_cncl2()
   IF g_argv1 <> '1' OR cl_null(g_argv1) THEN RETURN END IF
   LET g_ome.omecnclt = TIME
   UPDATE ome_file SET ome172   = NULL,
                       omevoid  = 'N',
                       omevoid2 = NULL,
                       omevoidu = NULL,
                       omevoidd = NULL,
                       omevoidt = NULL,             
                       omevoidn = NULL,   
                       omevoidm = NULL,   
                       omexml   = '',                 
                       omecncl  = 'Y',               
                       omecncl2 = g_ome.omecncl2,             
                       omecnclu = g_user,             
                       omecncld = TODAY,             
                       omecnclt = g_ome.omecnclt,             
                       omecnclm = g_ome.omecnclm,             
                       omemodu = g_user,
                       omemodd = g_today
      WHERE ome00 = g_ome.ome00
        AND ome01 = g_ome.ome01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ome_file",g_ome.ome01,"",SQLCA.SQLCODE,"","upd ome",1)
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION t310_change_inv()
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_yy      LIKE type_file.num5
   DEFINE l_mm      LIKE type_file.num5
   DEFINE tot       LIKE type_file.num20_6      
   DEFINE l_azf09   LIKE azf_file.azf09         

    IF g_argv1 <> '1' OR cl_null(g_argv1) THEN RETURN END IF
    IF cl_null(g_ome.ome01) OR cl_null(g_ome.ome00) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ome.* FROM ome_file
      WHERE ome00 = g_ome.ome00 AND ome01 = g_ome.ome01
        AND ome03 = g_ome.ome03
    LET g_ome_t.* = g_ome.*
    IF g_ome.ome173 IS NOT NULL THEN CALL cl_err('','axr-308',0) RETURN END IF
    IF g_ome.ome22 = 'N' THEN  #非電子發票不可修改
       CALL cl_err('','axr014',0)
       RETURN
    END IF
   #當oma33傳票編號不為NULL時,表示帳款已拋至總帳系統,不可異動
    LET g_oma33 = ''
    IF g_aza.aza26 ='2' THEN
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01 AND oma75 = g_ome.ome03
    ELSE
       SELECT oma33 INTO g_oma33 FROM oma_file WHERE oma10=g_ome.ome01
    END IF
    IF NOT cl_null(g_oma33) THEN CALL cl_err('','axr-384',0) RETURN END IF
    LET g_cnt = 0
    IF g_ome.ome22 = 'Y' THEN  #為電子發票
       IF g_ome.omecncl = 'N' THEN
          CALL cl_err('','axr015',0)
          RETURN
       ELSE
          IF cl_null(g_ome.omexml) THEN
             CALL cl_err('','axr016',0)
             RETURN
          END IF
       END IF
    END IF
 
    CALL cl_opmsg('u')
    LET g_success = 'Y'
    LET g_ome_t.* = g_ome.*

    BEGIN WORK
    LET g_ome03 = g_ome.ome03
    OPEN t310_cl USING g_ome.ome00,g_ome.ome01,g_ome.ome03 
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       LET g_ome.* = g_ome_t.*
       CALL t310_show() 
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_ome.*               # 對DB鎖定
    LET g_ome.ome03 = g_ome03               
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ome.ome01,SQLCA.sqlcode,0)
        LET g_ome.* = g_ome_t.* 
        CALL t310_show()
        ROLLBACK WORK 
        RETURN
    END IF
    LET g_ome.omecncl = 'N'
    LET g_ome.omecncl2 = NULL
    LET g_ome.omecncld = NULL
    LET g_ome.omecnclu = NULL
    LET g_ome.omecnclt = NULL
    LET g_ome.omecnclm = NULL
    LET g_ome.omexml = NULL
    DISPLAY BY NAME g_ome.omecncl, g_ome.omecncl2, g_ome.omecncld, g_ome.omecnclu,
                    g_ome.omecnclt, g_ome.omecnclm,g_ome.omexml
    DISPLAY '' TO azf1
   #CALL t310_show()  
    
    INPUT BY NAME g_ome.ome02,g_ome.ome82,g_ome.ome04,g_ome.ome043,g_ome.ome044,   #FUN-C80002 add ome82
                  g_ome.ome042,g_ome.ome59,g_ome.ome59x,g_ome.ome59t,
                  g_ome.ome78,g_ome.ome79,g_ome.ome80,g_ome.ome25,
                  g_ome.ome60
        WITHOUT DEFAULTS

        BEFORE INPUT
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE

        AFTER FIELD ome02
            LET l_yy=YEAR(g_ome.ome02)     #判段年月是否存在發票簿檔中
            LET l_mm=MONTH(g_ome.ome02)
            IF g_aza.aza26 <> '2' THEN   
               SELECT count(*)  INTO l_n from oom_file
                WHERE oom01=l_yy AND (oom02=l_mm OR oom021=l_mm)
               IF l_n =0 THEN
                  CALL cl_err(g_ome.ome02,'axr-911',0)
                  LET g_ome.ome02=NULL
                  NEXT FIELD ome02
               END IF
            END IF

        #no.A010依幣別取位
        AFTER FIELD  ome59
           IF cl_null(g_ome.ome59) THEN LET g_ome.ome59 = 0 END IF
           IF g_ome.ome59 < 0 THEN
              CALL cl_err(g_ome.ome59,'axm-179',0)
              NEXT FIELD ome59
           END IF
           LET g_ome.ome59 = cl_digcut(g_ome.ome59,g_azi04)   
           LET g_ome.ome59t = g_ome.ome59 + g_ome.ome59x   
           LET g_ome.ome59t = cl_digcut(g_ome.ome59t,g_azi04)  
           DISPLAY BY NAME g_ome.ome59,g_ome.ome59t
 
        AFTER FIELD  ome59x
           IF cl_null(g_ome.ome59x) THEN LET g_ome.ome59x = 0 END IF
           IF g_ome.ome59x < 0 THEN
              CALL cl_err(g_ome.ome59x,'axm-179',0)
              NEXT FIELD ome59x
           END IF
           IF g_ome.ome59x > g_ome59x THEN                                                                                         
              CALL cl_err(g_ome.ome59x,'axr-420',0)                                                                                
           END IF                                                                                                                  
           LET g_ome.ome59x = cl_digcut(g_ome.ome59x,g_azi04)  
           LET g_ome.ome59t = g_ome.ome59 + g_ome.ome59x    
           LET g_ome.ome59t = cl_digcut(g_ome.ome59t,g_azi04)   
           DISPLAY BY NAME g_ome.ome59x,g_ome.ome59t      

        AFTER FIELD ome042
           IF g_aza.aza21 = 'Y' AND NOT cl_null(g_ome.ome042) THEN
              IF NOT s_chkban(g_ome.ome042) THEN
                 CALL cl_err('chkban-ome042:','aoo-080',1)
              END IF
           END IF

        AFTER FIELD ome25 
           IF NOT cl_null(g_ome.ome25) THEN
              SELECT COUNT(*) INTO l_n FROM ooh_file
                WHERE ooh01 = g_ome.ome25 
                  AND oohacti = 'Y' 
              IF l_n = 0 OR cl_null(l_n) THEN
                 CALL cl_err('','axr017',0)
                 NEXT FIELD ome25
              END IF
           END IF

        AFTER INPUT
           LET g_ome.omeuser = s_get_data_owner("ome_file") 
           LET g_ome.omegrup = s_get_data_group("ome_file") 
           IF INT_FLAG THEN 
              EXIT INPUT 
           END IF

        ON ACTION CONTROLP
            IF INFIELD(ome25) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ooh"                     
               LET g_qryparam.default1 = g_ome.ome25
               LET g_qryparam.where = " oohacti = 'Y' "
               CALL cl_create_qry() RETURNING g_ome.ome25
               LET g_ooh02 = '' 
               SELECT ooh02 INTO g_ooh02 FROM ooh_file WHERE ooh01 = g_ome.ome25
               DISPLAY g_ooh02 TO ooh02
               DISPLAY BY NAME g_ome.ome25
               NEXT FIELD ome25
            END IF

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
       
        ON ACTION about         
           CALL cl_about()      
       
        ON ACTION help          
           CALL cl_show_help()  

    END INPUT  

    IF INT_FLAG THEN                         # 若按了DEL鍵
       LET INT_FLAG = 0
       LET g_ome.* = g_ome_t.*
       CALL cl_err('',9001,0)
       LET g_ome.* = g_ome_t.*
       CALL t310_show()
       ROLLBACK WORK
       RETURN
    END IF
 
    UPDATE ome_file SET omexml   = NULL,  
                        ome02    = g_ome.ome02, 
                        ome82    = g_ome.ome82,     #FUN-C80002 add
                        ome04    = g_ome.ome04,
                        ome042   = g_ome.ome042,
                        ome043   = g_ome.ome043,
                        ome044   = g_ome.ome044,
                        ome59    = g_ome.ome59,
                        ome59t   = g_ome.ome59t, 
                        ome59x   = g_ome.ome59x,
                        ome78    = g_ome.ome78,
                        ome79    = g_ome.ome79,
                        ome80    = g_ome.ome80,
                        ome25    = g_ome.ome25,  
                        ome60    = g_ome.ome60,
                        omecncl  = 'N' , 
                        omecncl2 = NULL,
                        omecncld = NULL, 
                        omecnclu = NULL,
                        omecnclt = NULL,
                        omecnclm = NULL  
            WHERE ome00 = g_ome_t.ome00 
              AND ome01 = g_ome_t.ome01
              AND ome03 = g_ome_t.ome03
    IF SQLCA.SQLCODE THEN
       ROLLBACK WORK
       LET g_ome.* = g_ome_t.*
    ELSE
       COMMIT WORK
       LET g_ome_t.* = g_ome.*
    END IF

    CALL t310_show() 


END FUNCTION

#FUN-C90104 add begin---
FUNCTION t310_prt_inv()
   IF cl_null(g_ome.ome01) THEN
      CALL cl_err('','axr1006',1)
      RETURN
   END IF 

   IF g_ome.ome00 = '4' THEN
      CALL cl_err('','axr1002',1)
      RETURN
   END IF

   IF g_ome.ome22 = 'N' THEN
      CALL cl_err('','axr1003',1)
      RETURN
   END IF

   IF g_ome.omevoid = 'Y' THEN
      CALL cl_err('','axr1004',1)
      RETURN
   END IF

   IF g_ome.omecncl = 'Y' THEN
      CALL cl_err('','axr1005',1)
      RETURN
   END IF

   LET g_str = "axrg304"," '",g_ome.ome01,"'"
   CALL cl_cmdrun_wait(g_str)
END FUNCTION
#FUN-C90104 add end-----

#FUN-C70030 add END
