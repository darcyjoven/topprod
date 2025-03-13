# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt610.4gl
# Descriptions...: 費用收入單維護作業
# Date & Author..: FUN-960130 2009/02/16 By Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控 
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A50102 10/06/12 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80105 10/08/20 By shaoyong 費用單來源作業修改,畫面欄位調整
# Modify.........: No:FUN-A80105 10/08/24 By lixh1  MARK 掉 oaj06 程式碼
# Modify.........: No:FUN-A80105 10/10/29 By vealxu 費用單來源修正
# Modify.........: No:TQC-AB0013 10/11/02 By Carrier 报错字段修改
# Modify.........: No:TQC-AB0019 10/11/03 By Carrier 单头税率修改,单身/单头金额要重算
# Modify.........: No:TQC-AB0369 10/11/30 By huangtao 
# Modify.........: No:TQC-AC0138 10/12/21 By suncx 單身無資料能審核BUG調整
# Modify.........: No:FUN-AC0062 10/12/22 By lixh1 因lua05欄位no use,故mark掉lua05的所有邏輯
# Modify.........: No:TQC-B10002 11/01/05 By huangtao 取消簽核
# Modify.........: No:TQC-B10084 11/01/11 By lua32增加3-散客
# Modify.........: No:TQC-B20095 11/02/17 By elva g_oma.oma00取不到值
# Modify.........: No:TQC-B20160 11/02/25 By lilingyu刪除費用單時未刪除交款表rxx_file/rxy_file 
# Modify.........: No:FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:FUN-B40041 11/04/26 By shiwuying 费用单号开窗修改
# Modify.........: No:FUN-B50007 11/05/05 By huangtao artt802共用此程式
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B50132 11/06/07 By lixia AFTER FIELD lub03增加管控
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60278 11/06/22 By suncx  lub03欄位管控BUG修正       
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:MOD-B80180 11/08/18 By lixia 付款后審核無分錄底稿資料
# Modify.........: No:MOD-B90154 11/09/20 By suncx 該程式無列印功能，將列印action拿掉
# Modify.........: No:FUN-B90056 11/10/14 By baogc 確認成功后，清空右下角的依單別取號中的提示信息
# Modify.........: No:FUN-BB0117 11/11/24 By baogc 招商歐亞達回收 - 費用單相關邏輯修改
# Modify.........: No:FUN-C20009 12/02/03 By shiwuying 隐藏单身lub15
# Modify.........: No:FUN-C20004 12/02/08 By zhangweib 新增ACTION拋轉財務
# Modify.........: No.TQC-C20163 12/02/15 By lutingting修改調用axrp601參數
# Modify.........: No:TQC-C20204 12/02/15 By xuxz mark 調用axrp601時候的報錯
# Modify.........: No:TQC-C20259 12/02/20 By fanbj 單頭單身部份欄位mark
# Modify.........: No:TQC-C20261 12/02/20 By fanbj 費用單取號時應依單據日期取號
# Modify.........: No:TQC-C20276 12/02/24 By xumeimei artt802右方ACTION 交款單交款,交款單查詢,支出單查詢,拋轉財務 隱藏不顯示
# Modify.........: No:TQC-C20430 12/02/28 By wangrr 拋磚財務中，修改判斷是否已經存在財務編號的SQL語句
# Modify.........: No:TQC-C20525 12/02/29 By fanbj 確認更新結案，取消確認還原確認碼
# Modify.........: No:TQC-C30008 12/03/01 By shiwuying 交款单交款BUG修改
# Modify.........: No:TQC-C30027 12/03/02 By shiwuying 交款单交款BUG修改
# Modify.........: No:MOD-C30098 12/03/09 By yuhuabao 輸入客戶編號后要帶出稅別
# Modify.........: No:TQC-C30211 12/03/12 By pauline artt802單身畫面"開始日期","結束日期","立帳日期"隱藏
# Modify.........: No:FUN-C30170 12/03/12 By pauline 當客戶為散客時攤位編號為no entry
# Modify.........: No:FUN-C30137 12/03/15 By fanbj 刪除費用單時要判斷是否是自動產生的，且來自于almi870，是的話要更新almi的費用單號為空
# Modify.........: No:TQC-C30265 12/03/19 By baogc 客戶來源為0.採購供應商時的部份BUG修改
# Modify.........: No:FUN-C30029 12/03/12 By zhangweib 新增ACTION拋轉財務還原
# Modify.........: No:TQC-C30290 12/03/28 By fanbj 單身費用編號開窗，費用總類外聯
# Modify.........: No:TQC-C30340 12/04/01 By fanbj BUG修改
# Modify.........: No:TQC-C40019 12/04/06 By suncx 已拋轉財務的費用單點擊‘拋轉財務’需提示已拋轉
# Modify.........: No:TQC-C40058 12/04/11 By zhangweib 拋磚財務還原action增加年度、期別條件
# Modify.........: No:FUN-C30072 12/04/17 By yangxf 费用支出与预收/收入分单处理
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-C90050 12/10/25 By Loria預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-CB0008 12/11/05 By Lori 1.單頭的稅「率」改變，不詢問直接自動更新單身。
#                                                 2.單頭的「稅率」不變，但「是否含稅」改變，才需要顯示詢問視窗。
#                                                 3.單身若進入單價後，單價無任何異動時，亦不能更新後面的金額。
# Modify.........: No.FUN-CB0076 12/12/04 By xumeimei 添加GR打印功能
# Modify.........: No.CHI-C80041 13/01/22 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/26 BY minpp 审核人员，日期修改为审核异动人员，审核异动日期，取消审核也给值
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_lua         RECORD LIKE lua_file.*,
       g_lua_t       RECORD LIKE lua_file.*,
       g_lua_o       RECORD LIKE lua_file.*,
       g_oma         RECORD LIKE oma_file.*,
       g_omb         RECORD LIKE omb_file.*,      
       g_npq         RECORD LIKE npq_file.*, 
       g_ooa         RECORD LIKE ooa_file.*,
       g_ool         RECORD LIKE ool_file.*,
       g_oow         RECORD LIKE oow_file.*, 
       g_oob         RECORD LIKE oob_file.*, 
       g_npp         RECORD LIKE npp_file.*, 
       g_nmh         RECORD LIKE nmh_file.*, 
       g_nms         RECORD LIKE nms_file.*, 
       g_omc         RECORD LIKE omc_file.*,
       g_type        LIKE npp_file.npptype,
       g_trno        LIKE oma_file.oma01,
       li_result     LIKE type_file.num5, 
       g_aag05       LIKE aag_file.aag05, 
       g_net         LIKE type_file.num5,
       g_aag23       LIKE aag_file.aag23, 
       g_bookno1     LIKE type_file.chr20,
       g_bookno2     LIKE type_file.chr20, 
       g_bookno3     LIKE type_file.chr20,
       g_flag        LIKE type_file.chr1,
       g_lua01_t     LIKE lua_file.lua01,
       g_lub         DYNAMIC ARRAY OF RECORD
           lub02     LIKE lub_file.lub02,
           lub03     LIKE lub_file.lub03,
           oaj02     LIKE oaj_file.oaj02,
           oaj031    LIKE oaj_file.oaj031,
           lnj02     LIKE lnj_file.lnj02,
          #FUN-BB0117 Add Begin ---
           lub09     LIKE lub_file.lub09,  #費用類型
           lub07     LIKE lub_file.lub07,  #開始日期
           lub08     LIKE lub_file.lub08,  #結束日期
           lub10     LIKE lub_file.lub10,  #立帳日期
           lub04     LIKE lub_file.lub04,  #未稅金額
           lub04t    LIKE lub_file.lub04t, #含稅金額
           lub11     LIKE lub_file.lub11,  #已收金額
           amt_2     LIKE lub_file.lub11,  #未收金額
           lub12     LIKE lub_file.lub12,  #清算金額
          #FUN-BB0117 Add End -----
           oaj04     LIKE oaj_file.oaj04,
           aag02     LIKE aag_file.aag02,
           oaj041    LIKE oaj_file.oaj041,
           aag02_1   LIKE aag_file.aag02,
#          oaj06     LIKE oaj_file.oaj06,    #FUN-A80105
          #FUN-BB0117 Add&Mark Begin ---
          #lub04     LIKE lub_file.lub04,
          #lub04t    LIKE lub_file.lub04t,
           lub13     LIKE lub_file.lub13,  #結案否
           lub14     LIKE lub_file.lub14,  #財務單號
           lub15     LIKE lub_file.lub15,  #財務待抵單號
          #FUN-BB0117 Add&Mark End -----
           lub05     LIKE lub_file.lub05,
           lub16     LIKE lub_file.lub16   #合同版本號 #FUN-BB0117 Add
                     END RECORD,
       g_lub_t       RECORD
           lub02     LIKE lub_file.lub02,
           lub03     LIKE lub_file.lub03,
           oaj02     LIKE oaj_file.oaj02,
           oaj031    LIKE oaj_file.oaj031,
           lnj02     LIKE lnj_file.lnj02,
          #FUN-BB0117 Add Begin ---
           lub09     LIKE lub_file.lub09,  #費用類型
           lub07     LIKE lub_file.lub07,  #開始日期
           lub08     LIKE lub_file.lub08,  #結束日期
           lub10     LIKE lub_file.lub10,  #立帳日期
           lub04     LIKE lub_file.lub04,  #未稅金額
           lub04t    LIKE lub_file.lub04t, #含稅金額
           lub11     LIKE lub_file.lub11,  #已收金額
           amt_2     LIKE lub_file.lub11,  #未收金額
           lub12     LIKE lub_file.lub12,  #清算金額
          #FUN-BB0117 Add End -----
           oaj04     LIKE oaj_file.oaj04,
           aag02     LIKE aag_file.aag02,
           oaj041    LIKE oaj_file.oaj041,
           aag02_1   LIKE aag_file.aag02,
#          oaj06     LIKE oaj_file.oaj06,    #FUN-A80105
          #FUN-BB0117 Add&Mark Begin ---
          #lub04     LIKE lub_file.lub04,
          #lub04t    LIKE lub_file.lub04t,
           lub13     LIKE lub_file.lub13,  #結案否
           lub14     LIKE lub_file.lub14,  #財務單號
           lub15     LIKE lub_file.lub15,  #財務待抵單號
          #FUN-BB0117 Add&Mark End -----
           lub05     LIKE lub_file.lub05,
           lub16     LIKE lub_file.lub16   #合同版本號 #FUN-BB0117 Add
                     END RECORD,
       g_lub_o       RECORD 
           lub02     LIKE lub_file.lub02,
           lub03     LIKE lub_file.lub03,
           oaj02     LIKE oaj_file.oaj02,
           oaj031    LIKE oaj_file.oaj031,
           lnj02     LIKE lnj_file.lnj02,
          #FUN-BB0117 Add Begin ---
           lub09     LIKE lub_file.lub09,  #費用類型
           lub07     LIKE lub_file.lub07,  #開始日期
           lub08     LIKE lub_file.lub08,  #結束日期
           lub10     LIKE lub_file.lub10,  #立帳日期
           lub04     LIKE lub_file.lub04,  #未稅金額
           lub04t    LIKE lub_file.lub04t, #含稅金額
           lub11     LIKE lub_file.lub11,  #已收金額
           amt_2     LIKE lub_file.lub11,  #未收金額
           lub12     LIKE lub_file.lub12,  #清算金額
          #FUN-BB0117 Add End -----
           oaj04     LIKE oaj_file.oaj04,
           aag02     LIKE aag_file.aag02,
           oaj041    LIKE oaj_file.oaj041,
           aag02_1   LIKE aag_file.aag02,
#          oaj06     LIKE oaj_file.oaj06,    #FUN-A80105
          #FUN-BB0117 Add&Mark Begin ---
          #lub04     LIKE lub_file.lub04,
          #lub04t    LIKE lub_file.lub04t,
           lub13     LIKE lub_file.lub13,  #結案否
           lub14     LIKE lub_file.lub14,  #財務單號
           lub15     LIKE lub_file.lub15,  #財務待抵單號
          #FUN-BB0117 Add&Mark End -----
           lub05     LIKE lub_file.lub05,
           lub16     LIKE lub_file.lub16   #合同版本號 #FUN-BB0117 Add
                     END RECORD,
       g_sql,g_str   STRING,
       g_sql1        LIKE type_file.chr1000,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5

#FUN-B50007 -------------STA 
#  DEFINE g_argv1             LIKE lua_file.lua01
#  DEFINE g_argv2             LIKE lua_file.lua04
#  DEFINE g_argv3             LIKE lua_file.lua12
DEFINE g_argv1             LIKE type_file.chr1
DEFINE g_argv2             LIKE lua_file.lua01
DEFINE g_argv3             LIKE lua_file.lua04
DEFINE g_argv4             LIKE lua_file.lua12
#FUN-B50007 -------------END
DEFINE g_void              LIKE type_file.chr1 
DEFINE g_approve           LIKE type_file.chr1 
DEFINE g_confirm           LIKE type_file.chr1
DEFINE p_row,p_col         LIKE type_file.num5   
DEFINE g_forupd_sql        STRING              #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_chr2              LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_dbs2              LIKE type_file.chr30
#DEFINE g_t1                LIKE lrk_file.lrkslip    #FUN-A70130  mark
DEFINE g_t1                LIKE oay_file.oayslip     #FUN-A70130
DEFINE cb                  ui.ComboBox               #FUN-B50007 add
DEFINE g_rcj     RECORD LIKE rcj_file.*   #FUN-B50007
DEFINE g_lui               RECORD LIKE lui_file.*    #FUN-BB0117 Add
DEFINE g_luj               RECORD LIKE luj_file.*    #FUN-BB0117 Add
#FUN-CB0076----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    luaplant  LIKE lua_file.luaplant,
    lua01     LIKE lua_file.lua01,
    lua04     LIKE lua_file.lua04,
    lua20     LIKE lua_file.lua20,
    lua06     LIKE lua_file.lua06,
    lua061    LIKE lua_file.lua061,
    lua09     LIKE lua_file.lua09,
    lua07     LIKE lua_file.lua07,
    lua17     LIKE lua_file.lua17,
    lua16     LIKE lua_file.lua16,
    lub02     LIKE lub_file.lub02,
    lub03     LIKE lub_file.lub03,
    lub05     LIKE lub_file.lub05,
    lub06     LIKE lub_file.lub06,
    lub09     LIKE lub_file.lub09,
    lub07     LIKE lub_file.lub07,
    lub08     LIKE lub_file.lub08,
    lub04t    LIKE lub_file.lub04t,
    lub11     LIKE lub_file.lub11,
    lub12     LIKE lub_file.lub12,
    lua18     LIKE lua_file.lua18,
    rtz13     LIKE rtz_file.rtz13,
    gen02     LIKE gen_file.gen02,
    oaj02     LIKE oaj_file.oaj02,
    amt       LIKE lub_file.lub11
END RECORD
#FUN-CB0076----add---end

MAIN
   DEFINE p_row,p_col         LIKE type_file.num5
   
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)         #FUN-B50007 add  

#FUN-B50007 --------------STA
   CASE WHEN g_argv1='1' OR cl_null(g_argv1)  #Add By shi Add OR
             LET g_prog= 'artt610'
        WHEN g_argv1='2'
             LET g_prog= 'artt802'
   END CASE   
#FUN-B50007 --------------END
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
   SELECT rcj01 INTO g_rcj.rcj01 FROM rcj_file WHERE rcj00 = '0'  #FUN-B50007 add   

   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time
 
   INITIALIZE g_lua.* TO NULL
 
   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="luaplant.lua_file.luaplant,",
              "lua01.lua_file.lua01,",
              "lua04.lua_file.lua04,",
              "lua20.lua_file.lua20,",
              "lua06.lua_file.lua06,",
              "lua061.lua_file.lua061,",
              "lua09.lua_file.lua09,",
              "lua07.lua_file.lua07,",
              "lua17.lua_file.lua17,",
              "lua16.lua_file.lua16,",
              "lub02.lub_file.lub02,",
              "lub03.lub_file.lub03,",
              "lub05.lub_file.lub05,",
              "lub06.lub_file.lub06,",
              "lub09.lub_file.lub09,",
              "lub07.lub_file.lub07,",
              "lub08.lub_file.lub08,",
              "lub04t.lub_file.lub04t,",
              "lub11.lub_file.lub11,",
              "lub12.lub_file.lub12,",
              "lua18.lua_file.lua18,",
              "rtz13.rtz_file.rtz13,",
              "gen02.gen_file.gen02,",
              "oaj02.oaj_file.oaj02,",
              "amt.lub_file.lub11"
   LET l_table = cl_prt_temptable('artt610',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end 
   LET g_forupd_sql = "SELECT * FROM lua_file WHERE lua01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t610_cl CURSOR FROM g_forupd_sql
 
   LET p_row =5   LET p_col = 10
   OPEN WINDOW t610_w AT p_row,p_col WITH FORM "art/42f/artt610"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("artt610")  
   LET g_pdate = g_today  
   CALL cl_ui_init()
   IF g_prog = 'artt610' THEN
      CALL cl_set_comp_visible("lua03",FALSE)
      LET   cb = ui.ComboBox.forName("lua32")
      CALL cb.removeItem("4")
   END IF
   CALL cl_set_comp_visible("oaj041,aag02_1",g_aza.aza63='Y')
#FUN-B50007 -------------STA
   IF g_prog = 'artt802' THEN
      CALL cl_set_act_visible("pay_money,money_detail",FALSE)
      CALL cl_set_act_visible("pay_from_paynote,qry_paynote,qry_expendnote,spin_fin",FALSE)   #TQC-C20276 add
      CALL cl_set_comp_visible("lua04,lua20,lua07,lua12,lua24",FALSE)
      CALL cl_set_comp_visible("lua33,lua34,lnt30,tqa02",FALSE) #FUN-BC0117
      CALL cl_set_comp_visible("lua35,lua36,lua37,amt,lua38,gen02,lua39,gem02",FALSE)  #TQC-C20259 add
      CALL cl_set_comp_visible("lub11,amt_2,lub12,lub16",FALSE)  #TQC-C20259 add
      CALL cl_set_comp_visible("lub13,lub14",FALSE) #TQC-C20276 add
      CALL cl_set_comp_visible("lub07,lub08,lub10",FALSE)  #TQC-C30211 add
     #LET g_lua.lua02 = '10' #FUN-BB0117 Mark
      LET g_lua.lua32 = '4'
      LET g_lua.lua11 = '0'
     #DISPLAY BY NAME g_lua.lua02,g_lua.lua32,g_lua.lua11  #FUN-BB0117 Mark
      DISPLAY BY NAME g_lua.lua32,g_lua.lua11              #FUN-BB0117 Add
   END IF
#FUN-B50007 -------------END 
   CALL cl_set_comp_visible("lub15",FALSE) #FUN-C20009
   LET g_plant = g_plant
   LET g_action_choice=""
  
#FUN-B50007 -------------STA
#  IF NOT cl_null(g_argv3) THEN
#     SELECT COUNT(*) INTO g_cnt FROM lua_file
#      WHERE lua12 = g_argv3
#        AND lua10 = 'Y'
# #      AND lua11 = '0'      #FUN-A80105--mark--
#        AND lua11 = '4'      #FUN-A80105--mod--
   IF NOT cl_null(g_argv4) THEN        
      SELECT COUNT(*) INTO g_cnt FROM lua_file
       WHERE lua12 = g_argv4
         AND lua10 = 'Y'
         AND lua11 = '4'
#FUN-B50007 -------------END
      IF g_cnt > 0 THEN
         CALL t610_q()
      END IF
   ELSE
#FUN-B50007 -------------STA
#  IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
#     IF NOT cl_null(g_argv1) THEN
#        SELECT count(*) INTO g_cnt FROM lua_file
#         WHERE lua01=g_argv1
   IF NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN
      IF NOT cl_null(g_argv2) THEN
          SELECT count(*) INTO g_cnt FROM lua_file
          WHERE lua01=g_argv2
#FUN-B50007 -------------END
         IF g_cnt > 0 THEN
            CALL t610_q()
         ELSE 
            CALL t610_a()
         END IF
      ELSE
#FUN-B50007 -------------STA
#        IF NOT cl_null(g_argv2) THEN
#           SELECT count(*) INTO g_cnt FROM lua_file  
#            WHERE lua04=g_argv2
         IF NOT cl_null(g_argv3) THEN
            SELECT count(*) INTO g_cnt FROM lua_file
            WHERE lua04=g_argv3
#FUN-B50007 -------------END
            IF g_cnt > 0 THEN 
               CALL t610_q()
            ELSE
               CALL t610_a() 
            END IF
         END IF
      END IF
   END IF
   END IF
 
   CALL t610_menu()
   CLOSE WINDOW t610_w 
   CALL cl_used(g_prog,g_time,2) 
      RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN
 
FUNCTION t610_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM 
   CALL g_lub.clear()
 
#FUN-B50007 -------------STA
#  IF NOT cl_null(g_argv3) THEN
# #   LET g_wc = " lua12='",g_argv3,"' AND lua10 = 'Y' AND lua11 = '0' "   #FUN-A80105--mark--
#     LET g_wc = " lua12='",g_argv3,"' AND lua10 = 'Y' AND lua11 = '4' "   #FUN-A80105--mod--
#     LET g_wc2=" 1=1"
#  ELSE
#  IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
#     IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
#        LET g_wc=" lua01='",g_argv1,"' AND lua04 = '",g_argv2,"' "
#        LET g_wc2=" 1=1"
#     ELSE
#        IF NOT cl_null(g_argv1) THEN
#           LET g_wc=" lua01 = '",g_argv1,"' "
#           LET g_wc2=" 1=1"
#        END IF
#        IF NOT cl_null(g_argv2) THEN
#           LET g_wc=" lua04='",g_argv2,"' "
#           LET g_wc2=" 1=1" 
#        END IF
#     END IF
#  ELSE
   IF NOT cl_null(g_argv4) THEN
      LET g_wc = " lua12='",g_argv4,"' AND lua10 = 'Y' AND lua11 = '4' " 
      LET g_wc2=" 1=1"
   ELSE
      IF NOT cl_null(g_argv2) OR NOT cl_null(g_argv3) THEN
         IF NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN
            LET g_wc=" lua01='",g_argv2,"' AND lua04 = '",g_argv3,"' "
            LET g_wc2=" 1=1"
         ELSE
            IF NOT cl_null(g_argv2) THEN
               LET g_wc=" lua01 = '",g_argv2,"' "
               LET g_wc2=" 1=1"
            END IF
            IF NOT cl_null(g_argv3) THEN
               LET g_wc=" lua04='",g_argv3,"' "
               LET g_wc2=" 1=1"
            END IF
         END IF
      ELSE
#FUN-B50007 -------------END   

         CALL cl_set_head_visible("","YES")          
         INITIALIZE g_lua.* TO NULL      
#FUN-B50007 -------------STA
         IF g_prog = 'artt802' THEN
           #LET g_lua.lua02 = '10' #FUN-BB0117 Mark
            LET g_lua.lua32 = '4'
            LET g_lua.lua11 = '0'
           #DISPLAY BY NAME g_lua.lua02,g_lua.lua32, g_lua.lua11 #FUN-BB0117 Mark
            DISPLAY BY NAME g_lua.lua32, g_lua.lua11             #FUN-BB0117 Add
           #FUN-BB0117 Add&Mark Begin ---
           #CONSTRUCT BY NAME g_wc ON lua01,lua04,lua20,lua06,lua061,lua07,
           #                          lua21,lua22,lua23,lua08,lua08t,luaplant,lua19,lua09,lua10,
           #                          lua12,lua24,lua15,lua16,lua17,lua18,  
           #                          luauser,luagrup,luaoriu,luacrat,luamodu,luaorig,luaacti,luadate
            CONSTRUCT BY NAME g_wc ON lua01,lua09,luaplant,lualegal,lua06,lua061,
                                      lua07,lua05,lua04,lua20,lua33,lua34,lua37,lua10,lua12,
                                      lua21,lua22,lua23,lua08,lua08t,lua35,lua36,
                                      lua38,lua39,lua14,lua15,lua16,lua17,lua18,
                                      luauser,luagrup,luaoriu,luamodu,luadate,luaorig,luaacti,luacrat
           #FUN-BB0117 Add&Mark End -----
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
                ON ACTION controlp
                   CASE
                      WHEN INFIELD(lua01)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua01_1"
                        #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                         LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua01
                         NEXT FIELD lua01

                      WHEN INFIELD(lua04)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua04"
                        #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                         LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua04
                         NEXT FIELD lua04
                     WHEN INFIELD(lua06)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua06_1"
                        #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                         LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua06
                         NEXT FIELD lua06
                       
                      WHEN INFIELD(lua061)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua061_1"
                        #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                         LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua061
                         NEXT FIELD lua061
                      WHEN INFIELD(lua07)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua07_1"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua07
                         NEXT FIELD lua07

                     #FUN-BB0117 Mark Begin ---
                     #WHEN INFIELD(lua19)
                     #   CALL cl_init_qry_var()
                     #   LET g_qryparam.state = 'c'
                     #   LET g_qryparam.form = "q_lua19"
                     #   LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041
                     #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     #   DISPLAY g_qryparam.multiret TO lua19
                     #   NEXT FIELD lua19
                     #FUN-BB0117 Mark End -----

                      WHEN INFIELD(lua21)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua21"
                        #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                         LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua21
                         NEXT FIELD lua21

                     #FUN-BB0117 Add Begin ---
                      WHEN INFIELD(luaplant)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_luaplant"
                         LET g_qryparam.where = " luaplant IN ",g_auth
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO luaplant
                         NEXT FIELD luaplant

                      WHEN INFIELD(lualegal)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lualegal"
                         LET g_qryparam.where = " luaplant IN ",g_auth
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lualegal
                         NEXT FIELD lualegal

                      WHEN INFIELD(lua38)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua38"
                         LET g_qryparam.where = " luaplant IN ",g_auth
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua38
                         NEXT FIELD lua38

                      WHEN INFIELD(lua39)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua39"
                         LET g_qryparam.where = " luaplant IN ",g_auth
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua39
                         NEXT FIELD lua39

                      WHEN INFIELD(lua16)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = 'c'
                         LET g_qryparam.form = "q_lua16"
                         LET g_qryparam.where = " luaplant IN ",g_auth
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO lua16
                         NEXT FIELD lua16
                     #FUN-BB0117 Add End -----

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
                  CALL cl_qbe_save()
            END CONSTRUCT
            IF INT_FLAG THEN
               RETURN
            END IF
         END IF
         IF g_prog = 'artt610' THEN
#FUN-B50007 -------------END

#FUN-A80105--begin--
#  CONSTRUCT BY NAME g_wc ON lua01,lua02,lua04,lua20,lua06,
#                            lua21,lua22,lua23,lua08,lua08t,luaplant,lua19,lua09,lua10,
#                            lua11,lua12,lua24,lua13,lua14, lua15,lua16,lua17,lua18,
#                            luauser,luagrup,luacrat,luamodu,luaacti,luadate
  #FUN-BB0117 Mark Begin ---
  #CONSTRUCT BY NAME g_wc ON lua01,lua02,lua32,lua04,lua20,lua06,lua061,lua07,
  #                          lua21,lua22,lua23,lua08,lua08t,luaplant,lua19,lua09,lua10,
  #         #                 lua11,lua12,lua24,lua13,lua14, lua15,lua16,lua17,lua18,                    #TQC-AB0369  mark
  #                          lua11,lua12,lua24,lua15,lua16,lua17,lua18,                           #TQC-AB0369
  #                          luauser,luagrup,luaoriu,luacrat,luamodu,luaorig,luaacti,luadate #No.FUN-A80105 Add orig,oriu
  #FUN-BB0117 Mark End -----
#FUN-A80105--end--
  #FUN-BB0117 Add Begin ---
            CONSTRUCT BY NAME g_wc ON lua01,lua09,luaplant,lualegal,lua32,lua06,lua061,
                                      lua07,lua05,lua04,lua20,lua33,lua34,lua37,lua10,lua11,lua12,
                                      lua21,lua22,lua23,lua08,lua08t,lua35,lua36,
                                      lua38,lua39,lua14,lua15,lua16,lua17,lua18,
                                      luauser,luagrup,luaoriu,luamodu,luadate,luaorig,luaacti,luacrat
  #FUN-BB0117 Add End -----

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               ON ACTION controlp
                  CASE
                     WHEN INFIELD(lua01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua01_1"
                       #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                        LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua01
                        NEXT FIELD lua01
                     
                     WHEN INFIELD(lua04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua04"
                       #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                        LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua04
                        NEXT FIELD lua04
   
                     WHEN INFIELD(lua06)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua06_1"
                       #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                        LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua06
                        NEXT FIELD lua06

#FUN-A80105--begin--
                     WHEN INFIELD(lua061)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua061_1"
                       #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                        LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua061
                        NEXT FIELD lua061
                     WHEN INFIELD(lua07)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua07_1"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua07
                        NEXT FIELD lua07
#FUN-A80105--end--
          
                    #FUN-BB0117 Mark Begin ---
                    #WHEN INFIELD(lua19)
                    #   CALL cl_init_qry_var()
                    #   LET g_qryparam.state = 'c'
                    #   LET g_qryparam.form = "q_lua19"
                    #   LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041
                    #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    #   DISPLAY g_qryparam.multiret TO lua19
                    #   NEXT FIELD lua19
                    #FUN-BB0117 Mark End -----
         
                     WHEN INFIELD(lua21)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua21"
                       #LET g_qryparam.where = " lua19 IN ",g_auth #FUN-B40041 #FUN-BB0117 Mark
                        LET g_qryparam.where = " luaplant IN ",g_auth          #FUN-BB0117 Add
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua21
                        NEXT FIELD lua21

                    #FUN-BB0117 Add Begin ---
                     WHEN INFIELD(luaplant)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_luaplant"
                        LET g_qryparam.where = " luaplant IN ",g_auth
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO luaplant
                        NEXT FIELD luaplant

                     WHEN INFIELD(lualegal)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lualegal"
                        LET g_qryparam.where = " luaplant IN ",g_auth
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lualegal
                        NEXT FIELD lualegal
                        
                     WHEN INFIELD(lua38)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua38"
                        LET g_qryparam.where = " luaplant IN ",g_auth
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua38
                        NEXT FIELD lua38
                    
                     WHEN INFIELD(lua39)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua39"
                        LET g_qryparam.where = " luaplant IN ",g_auth
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua39
                        NEXT FIELD lua39
                        
                     WHEN INFIELD(lua16)
                        CALL cl_init_qry_var() 
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form = "q_lua16"
                        LET g_qryparam.where = " luaplant IN ",g_auth
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO lua16
                        NEXT FIELD lua16
                    #FUN-BB0117 Add End -----

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
                 CALL cl_qbe_save()
            END CONSTRUCT
            IF INT_FLAG THEN
               RETURN
            END IF
         END IF                                       #FUN-B50007 add      
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                       
   #      LET g_wc = g_wc clipped," AND luauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                     
   #      LET g_wc = g_wc clipped," AND luagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN       
   #      LET g_wc = g_wc clipped," AND luagrup IN ",cl_chk_tgrup_list()
   #   END IF
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('luauser', 'luagrup')
   #End:FUN-980030
 
  #FUN-BB0117 Add&Mark Begin ---
  #CONSTRUCT g_wc2 ON lub02,lub03,lub04,lub04t,lub05
  #     FROM s_lub[1].lub02,s_lub[1].lub03,s_lub[1].lub04,s_lub[1].lub04t,
  #          s_lub[1].lub05
         CONSTRUCT g_wc2 ON lub02,lub03,lub09,lub07,lub08,lub10,lub04,lub04t,
                            lub11,lub12,lub13,lub14,lub15,lub05
                       FROM s_lub[1].lub02,s_lub[1].lub03,s_lub[1].lub09,s_lub[1].lub07,
                            s_lub[1].lub08,s_lub[1].lub10,s_lub[1].lub04,s_lub[1].lub04t,
                            s_lub[1].lub11,s_lub[1].lub12,s_lub[1].lub13,s_lub[1].lub14,
                            s_lub[1].lub15,s_lub[1].lub05
  #FUN-BB0117 Add&Mark End -----
       
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
             
            ON ACTION controlp
               CASE
                  WHEN INFIELD(lub03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form = "q_lub03"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lub03
                     NEXT FIELD lub03
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
 
            ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT
         IF INT_FLAG THEN
            RETURN
         END IF
 
      END IF
   END IF
 
#FUN-B50007 ----------------STA
#  IF g_wc2 = " 1=1" THEN              
#     LET g_sql = "SELECT lua01",
#                 " FROM lua_file WHERE ", g_wc CLIPPED,
#                 "  AND lua19 IN ",g_auth,
#                 " ORDER BY lua01"
#  ELSE                              
#     LET g_sql = "SELECT UNIQUE lua01",
#                 "  FROM lua_file, lub_file ",
#                 " WHERE lua01 = lub01",
#                 "  AND lua19 IN ",g_auth,
#                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                 " ORDER BY lua01"
#  END IF
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT lua01",
                  " FROM lua_file WHERE ", g_wc CLIPPED,
                 #"  AND lua19 IN ",g_auth    #FUN-BB0117 Mark
                  "  AND luaplant IN ",g_auth #FUN-BB0117 Add
   ELSE
     LET g_sql = "SELECT UNIQUE lua01",
                  "  FROM lua_file, lub_file ",
                  " WHERE lua01 = lub01",
                 #"  AND lua19 IN ",g_auth,
                  "  AND luaplant IN ",g_auth,#FUN-BB0117 Add
                  "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
   IF g_argv1 = '1' THEN
      LET g_sql = g_sql," AND lua32 IN ('0','1','2','3','5') " #FUN-BB0117 Add '5'
   END IF
   IF g_argv1 = '2' THEN
     #LET g_sql = g_sql," AND lua32 = '4' AND lua02 = '10' AND lua11 = '0' " #FUN-BB0117 Mark
      LET g_sql = g_sql," AND lua32 = '4' AND lua11 = '0' "                  #FUN-BB0117 Add
   END IF
   LET g_sql = g_sql," ORDER BY lua01" 

#FUN-B50007 ----------------END
 
   PREPARE t610_prepare FROM g_sql
   DECLARE t610_cs SCROLL CURSOR WITH HOLD FOR t610_prepare
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM lua_file ",
                " WHERE ",g_wc CLIPPED,
               #"   AND lua19 IN ",g_auth    #FUN-BB0117 Mark
                "   AND luaplant IN ",g_auth #FUN-BB0117 Add
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lua01) FROM lua_file,lub_file",
                " WHERE lua01 = lub01",
               #"   AND lua19 IN ",g_auth,    #FUN-BB0117 Mark
                "   AND luaplant IN ",g_auth, #FUN-BB0117 Add
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
#FUN-B50007 ----------------STA
   IF g_argv1 = '1' THEN
      LET g_sql = g_sql," AND lua32 IN ('0','1','2','3','5') " #FUN-BB0117 Add '5'
   END IF
   IF g_argv1 = '2' THEN
     #LET g_sql = g_sql," AND lua32 = '4' AND lua02 = '10' AND lua11 = '0' " #FUN-BB0117 Mark
      LET g_sql = g_sql," AND lua32 = '4' AND lua11 = '0' "                  #FUN-BB0117 Add
   END IF
#FUN-B50007 ----------------END
   PREPARE t610_precount FROM g_sql
   DECLARE t610_count CURSOR FOR t610_precount
END FUNCTION
 
FUNCTION t610_menu()
DEFINE l_cmd STRING #FUN-BB0117 Add

   WHILE TRUE
      CALL t610_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t610_q()
            END IF
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t610_a()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t610_u()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t610_r()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t610_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t610_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t610_b("u")
            ELSE
               LET g_action_choice=NULL
            END IF
    
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t610_out()
            END IF
         #FUN-CB0076------add----end
    #TQC-B10002 -----------mark     
    #    WHEN "ef_approval"
    #       IF cl_chk_act_auth() THEN
    #             CALL t610_ef()
    #       END IF
    #TQC-B10002 -----------mark

         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
                  CALL t610_y()
            END IF 
 
         WHEN "undo_confirm"      
            IF cl_chk_act_auth() THEN
                  CALL t610_z()
            END IF
        
         #MOD-B90154 MARK begin---------- 
         #WHEN "output"
         #   IF cl_chk_act_auth() THEN
         #  #    CALL t610_out()
         #   END IF
         #MOD-B90154 MARK end------------
        
         WHEN "void"
            IF cl_chk_act_auth() THEN
                  CALL t610_v()
            END IF
 
         WHEN "pay_money"
            IF cl_chk_act_auth() THEN
                  CALL t610_pay()
            END IF
 
         WHEN "money_detail"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lua.lua01) THEN    #FUN-C30072 add
                  IF g_lua.lua37 = 'Y' THEN
                     CALL s_pay_detail('07',g_lua.lua01,g_lua.luaplant,g_lua.lua15)
                  #FUN-C30072 add begin ---
                  ELSE 
                     CALL cl_err('','art-579',0) #該費用單非直接收款,請通過交款單交款！
                  END IF 
               ELSE 
                  CALL cl_err('',-400,0)
               #FUN-C30072 add end -----
               END IF
            END IF

        #FUN-BB0117 Add Begin ---
         #交款單交款
         WHEN "pay_from_paynote"
            IF cl_chk_act_auth() THEN
               CALL t610_pay_from_paynote()
            END IF

         #交款單查詢
         WHEN "qry_paynote"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lua.lua01) THEN
                  #FUN-C30072 add begin ---
                  CALL t610_chk_paynote()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)       #费用支出类型的费用不可交款单查询
                  ELSE 
                  #FUN-C30072 add end -----
                     LET l_cmd = 'artt611 "',g_lua.lua01,'"'
                     CALL cl_cmdrun_wait(l_cmd)
                     CALL t610_show()
                  END IF                             #FUN-C30072 add
               END IF
            END IF

         #支出單查詢
         WHEN "qry_expendnote"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lua.lua01) THEN
                 #LET l_cmd = 'artt614 "2" "',g_lua.lua01,'"'
                  LET l_cmd = "artt614 '2' '",g_lua.lua01,"'"
                  CALL cl_cmdrun_wait(l_cmd)
                  CALL t610_show()
               END IF
            END IF
        #FUN-BB0117 Add End -----

        #FUN-C20004 ---start--- add
         WHEN "spin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               CALL t610_axrp601()
            END IF
        #FUN-C20004 ---end---   add

        #FUN-C30029 ---start--- add
         WHEN "unspin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               CALL t610_axrp605()
            END IF
        #FUN-C30029 ---end---   add

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lub),'','')
            END IF
        
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lua.lua01 IS NOT NULL THEN
                 LET g_doc.column1 = "lua01"
                 LET g_doc.value1 = g_lua.lua01
                 CALL cl_doc()
               END IF
         END IF
       END CASE
   END WHILE
END FUNCTION
 
FUNCTION t610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lub TO s_lub.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
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
          
      ON ACTION reproduce 
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail 
         LET g_action_choice="detail"
         LET l_ac=1
         EXIT DISPLAY
 
      #FUN-CB0076------add-----str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-CB0076------add-----end
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION first
         CALL t610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL t610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL t610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL t610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
     #FUN-BB0117 Mark Begin ---
     #暫時Mark無效功能
     #ON ACTION invalid
     #   LET g_action_choice="invalid"
     #   EXIT DISPLAY
     #FUN-BB0117 Mark End -----
   
   #TQC-B10002 -------------mark
   #  ON ACTION ef_approval 
   #     LET g_action_choice="ef_approval"
   #     EXIT DISPLAY
   #TQC-B10002 -------------mark
 
      ON ACTION pay_money
         LET g_action_choice="pay_money"
         EXIT DISPLAY
 
      ON ACTION money_detail
         LET g_action_choice = "money_detail"
         EXIT DISPLAY

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
  
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
     #FUN-BB0117 Mark Begin ---
     #暫時Mark作廢功能
     #ON ACTION void
     #   LET g_action_choice="void"
     #   EXIT DISPLAY
     #FUN-BB0117 Mark End -----
 
     #FUN-BB0117 Add Begin ---
      #交款單付款
      ON ACTION pay_from_paynote
         LET g_action_choice = "pay_from_paynote"
         EXIT DISPLAY

      #交款單查詢
      ON ACTION qry_paynote
         LET g_action_choice = "qry_paynote"
         EXIT DISPLAY

      #支出單查詢
      ON ACTION qry_expendnote
         LET g_action_choice = "qry_expendnote"
         EXIT DISPLAY
     #FUN-BB0117 Add End -----

     #FUN-C20004 ---start--- Add
     #拋轉財務
      ON ACTION spin_fin
         LET g_action_choice = "spin_fin"
         EXIT DISPLAY
     #FUN-C20004 ---end---   Add

     #FUN-C30029 ---start--- Add
     #拋轉財務還原
      ON ACTION unspin_fin
         LET g_action_choice = "unspin_fin"
         EXIT DISPLAY
     #FUN-C30029 ---end---   Add

     #MOD-B90154 MARK begin----------
     # ON ACTION output
     #    LET g_action_choice="output"
     #    EXIT DISPLAY
     #MOD-B90154 MARK end------------
      
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
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t610_pay()
DEFINE l_sum    LIKE type_file.num20_6
DEFINE l_rtz06  LIKE rtz_file.rtz06
DEFINE l_flag   LIKE type_file.num5     #FUN-A80105--add--

  #No.FUN-A80105 Begin---
   IF g_lua.lua01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lua.* FROM lua_file WHERE lua01=g_lua.lua01
  #No.FUN-A80105 End-----

   IF g_lua.luaacti = 'N' THEN
      CALL cl_err('','mfg1000',1)
      RETURN  
   END IF
   
   #FUN-A80105 --------------add by vealxu  start------------------
   IF g_lua.lua15 = 'Y' THEN
      CALL cl_err('','art-811',1)
      RETURN 
   END IF 
   #FUN-A80105 -------------add end----------------------------

  #FUN-BB0117 Add&Mark Begin ---
  #IF g_lua.lua11 != '0' THEN
  #   CALL cl_err('','art-579',1)
  #   RETURN
  #END IF

   IF g_lua.lua37 <> 'Y' THEN
      CALL cl_err('','art-579',0) #該費用單非直接收款,請通過交款單交款！
      RETURN
   END IF
  #FUN-BB0117 Add&Mark End -----
 
#FUN-BB0117 Mark Begin ---
##FUN-A80105--begin--
#   CALL s_chk_lne(g_lua.lua06) RETURNING l_flag
#  #FUN-BB0117 Note:客戶來源1.潛在商戶變更為2.潛在商戶,并添加1.預登記商戶(邏輯與潛在商戶一致)
#  #IF l_flag = TRUE OR (g_lua.lua32='1' AND g_lua.lua06='MISC')THEN #FUN-BB0117 Mark
#   IF l_flag = TRUE OR ((g_lua.lua32='1' OR g_lua.lua32='2') AND g_lua.lua06='MISC') THEN #FUN-BB0117 Add
#      CALL cl_err("",'art-681',1)
#      RETURN
#   END IF 
##FUN-A80105--end--
#  #SELECT rtz06 INTO l_rtz06 FROM rtz_file WHERE rtz01 = g_lua.lua19    #FUN-BB0117 Mark
#   SELECT rtz06 INTO l_rtz06 FROM rtz_file WHERE rtz01 = g_lua.luaplant #FUN-BB0117 Add
#   IF NOT cl_null(l_rtz06) THEN
#      IF g_lua.lua06 != l_rtz06 THEN
#         CALL cl_err('','art-580',1)
#         RETURN
#      END IF
#   ELSE
#      CALL cl_err('','art-580',1)
#      RETURN
#   END IF
#FUN-BB0117 Mark End -----
 
   SELECT SUM(lub04t) INTO l_sum FROM lub_file 
       WHERE lub01 = g_lua.lua01
#        AND plant = g_lua.luaplant                  #FUN-A80105--mark--
         AND lubplant = g_lua.luaplant                  #FUN-A80105--mod--
   IF l_sum IS NULL THEN LET l_sum = 0 END IF
   IF g_lua.lua08t IS NULL THEN LET g_lua.lua08t = 0 END IF
 
   IF l_sum != g_lua.lua08t THEN
      CALL cl_err('','art-581',1)
      RETURN
   END IF

   BEGIN WORK
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_lua.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL s_pay("07",g_lua.lua01,g_lua.luaplant,g_lua.lua08t,g_lua.lua15)

   CALL t610_upd_money()

   CLOSE t610_cl
   COMMIT WORK
END FUNCTION

FUNCTION t610_a()
 DEFINE li_result   LIKE type_file.num5
 #DEFINE l_lrkdmy2   LIKE lrk_file.lrkdmy2   #FUN-A70130  mark
 DEFINE l_oayconf   LIKE oay_file.oayconf    #FUN-A70130
 
    MESSAGE ""
    CLEAR FORM
    CALL g_lub.clear()
    LET g_wc = NULL
    LET g_wc2 = NULL
    
    IF s_shut(0) THEN
       RETURN
    END IF
    INITIALIZE g_lua.* LIKE lua_file.*
    LET g_lua01_t = NULL
    LET g_lua_t.* = g_lua.*
    LET g_lua_o.* = g_lua.*
    CALL cl_opmsg('a')
    WHILE TRUE
#FUN-B50007 ------------STA
        IF g_prog = 'artt802' THEN
           #LET g_lua.lua02 = '10' #FUN-BB0117 Mark
            LET g_lua.lua32 = '4'
            SELECT rtz29 INTO g_lua.lua06 FROM rtz_file WHERE rtz01 = g_plant
            IF SQLCA.sqlcode OR cl_null(g_lua.lua06) THEN
               CALL cl_err('','art-832',1)
               RETURN
            END IF
        END IF        
#FUN-B50007 ------------END
        LET g_lua.lua03 = ' '
       #LET g_lua.lua05 = ' ' #FUN-BB0117 Mark
        LET g_lua.lua05 = 'N' #FUN-BB0117 Add
        LET g_lua.lua08 = 0
        LET g_lua.lua09 = g_today
        LET g_lua.lua10 = 'N'
        LET g_lua.lua13 = 'N'        
        LET g_lua.lua14 = '0'
        LET g_lua.lua11 = '0'
        LET g_lua.lua15 = 'N'
        LET g_lua.lua23 = 'N'
       #LET g_lua.lua19 = g_plant #FUN-BB0117 Mark
        LET g_lua.luauser = g_user
        LET g_lua.luaoriu = g_user #FUN-980030
        LET g_lua.luaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #TQC-A10128 ADD
        LET g_lua.luagrup = g_grup 
        LET g_lua.luaacti = 'Y'
        LET g_lua.luacrat = g_today
        LET g_lua.luaplant = g_plant
        LET g_lua.lualegal = g_legal
       #FUN-BB0117 Add Begin ---
        LET g_lua.lua08t = 0
        LET g_lua.lua35  = 0
        LET g_lua.lua36  = 0
        LET g_lua.lua37  = 'Y'
        IF g_argv1='2' THEN
           LET g_lua.lua37  = 'N'
        END IF
        LET g_lua.lua38  = g_user
        LET g_lua.lua39  = g_grup
       #FUN-BB0117 Add End -----
        CALL t610_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lua.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lua.lua01 IS NULL THEN 
            CONTINUE WHILE
        END IF
        
        BEGIN WORK
        #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
#       CALL s_auto_assign_no("alm",g_lua.lua01,g_today,'01',"lua_file","lua01","","","")   #FUN-A80105--mark--
       # CALL s_auto_assign_no("art",g_lua.lua01,g_today,'B9',"lua_file","lua01","","","")   #FUN-A80105--mod--   #TQC-C20261 mark
        CALL s_auto_assign_no("art",g_lua.lua01,g_lua.lua09,'B9',"lua_file","lua01","","","")  #TQC-C20261 add 
           RETURNING li_result,g_lua.lua01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lua.lua01
 
        IF cl_null(g_lua.lua08t) THEN
           LET g_lua.lua08t = 0 
        END IF
        INSERT INTO lua_file VALUES(g_lua.*)
        IF SQLCA.sqlcode THEN
        #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
           CALL cl_err3("ins","lua_file",g_lua.lua01,"",SQLCA.sqlcode,"","",0)
           ROLLBACK WORK          #FUN-B80085--add--
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        LET g_lua01_t = g_lua.lua01
        LET g_lua_t.* = g_lua.*
        LET g_lua_o.* = g_lua.*
 
        CALL g_lub.clear()
        LET g_rec_b = 0
        CALL t610_b("a")
        EXIT WHILE
    END WHILE
    LET g_wc=' '
#FUN-B50007 ------------STA
    IF g_prog = 'artt802' THEN
      #LET g_lua.lua02 = '10' #FUN-BB0117 Mark
       LET g_lua.lua32 = '4'
       LET g_lua.lua11 = '0'
      #DISPLAY BY NAME g_lua.lua02,g_lua.lua32,g_lua.lua11 #FUN-BB0117 Mark
       DISPLAY BY NAME g_lua.lua32,g_lua.lua11             #FUN-BB0117 Add
    END IF
#FUN-B50007 ------------END
     LET g_t1=s_get_doc_no(g_lua.lua01)
     #單別設置里有維護單別，則找出是否需要自動審核
     IF NOT cl_null(g_t1) THEN
   #FUN-A70130 ---------------------start-----------------------------
   #     SELECT lrkdmy2
   #       INTO l_lrkdmy2
   #       FROM lrk_file
   #      WHERE lrkslip = g_t1
        #需要自動審核，則調用審核段
   #     IF l_lrkdmy2 = 'Y' THEN
         SELECT oayconf INTO l_oayconf FROM oay_file
         WHERE oayslip = g_t1
         IF l_oayconf = 'Y' THEN
   #FUN-A70130 ------------------------end-----------------------------
        #自動審核傳2
           CALL t610_y()
        END IF
     END IF
END FUNCTION
 
FUNCTION t610_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lua.lua01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lua.* FROM lua_file
    WHERE lua01 = g_lua.lua01
      
   IF g_lua.luaacti ='N' THEN         
      CALL cl_err(g_lua.lua01,'mfg1000',0)
      RETURN
   END IF

   IF g_lua.lua14 = '2' THEN
      CALL cl_err('','axr-369',0)
      RETURN
   END IF
   
   IF g_lua.lua15='Y' THEN            #已審核，不允許更改
      CALL cl_err(g_lua.lua09,'9003',0)
      RETURN
   END IF
 
   IF g_lua.lua15='X' THEN             #已作廢，不允許更改
      CALL cl_err(g_lua.lua09,'9024',0)
      RETURN
   END IF

  #FUN-BB0117 Add Begin ---
   IF g_lua.lua10 = 'Y' THEN 
      CALL cl_err('','art-761',0) #自動產生的單據不可進行修改和單身操作
      RETURN 
   END IF

   IF g_lua.lua35 > 0 THEN
      CALL cl_err('','art-762',0) #已付款，不可異動
      RETURN
   END IF
  #FUN-BB0117 Add End -----
 
   MESSAGE ""
   CALL cl_opmsg('u')
      
   BEGIN WORK
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t610_cl INTO g_lua.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t610_show()
   WHILE TRUE
      LET g_lua01_t = g_lua.lua01
      LET g_lua_o.* = g_lua.*
      LET g_lua.luamodu=g_user
      LET g_lua.luadate=g_today
      CALL t610_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lua.*=g_lua_t.*
         CALL t610_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lua.lua14 MATCHES '[SsWwRr1]' THEN
         LET g_lua.lua14 = '0'
      END IF
 
      UPDATE lua_file SET lua_file.* = g_lua.*
       WHERE lua01 = g_lua.lua01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lua_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lua.lua01,'U')
   CALL t610_show()
   CALL t610_b_fill( "1=1")
END FUNCTION
 
FUNCTION t610_i(p_cmd)
 DEFINE l_n         LIKE type_file.num5
 DEFINE l_input     LIKE type_file.chr1
 DEFINE p_cmd       LIKE type_file.chr1     
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE l_azp02     LIKE azp_file.azp02
 DEFINE l_lua21_t   LIKE lua_file.lua21
 DEFINE l_lua22_t   LIKE lua_file.lua22
 DEFINE l_lua23_t   LIKE lua_file.lua23
 DEFINE l_lub04     LIKE lub_file.lub04
 DEFINE li_result   LIKE type_file.num5
 DEFINE l_lub       DYNAMIC ARRAY OF RECORD
           lub02    LIKE lub_file.lub02,
           lub04    LIKE lub_file.lub04,
           lub04t   LIKE lub_file.lub04t
                    END RECORD
 DEFINE l_flag      LIKE type_file.num5   #FUN-A80105--add--
 DEFINE lua32_t     LIKE lua_file.lua32   #FUN-A80105--add--

   IF s_shut(0) THEN
      RETURN
   END IF
 
  #FUN-BB0117 Add&Mark Begin ---
  #DISPLAY BY NAME g_lua.lua02,g_lua.lua04,g_lua.lua06,
  #                g_lua.lua08,g_lua.lua19,g_lua.lua11,g_lua.lua12,g_lua.lua19,
  #  #              g_lua.lua09,g_lua.lua10,g_lua.lua13,g_lua.lua14,g_lua.lua15,        #TQC-AB0369  mark
  #                g_lua.lua09,g_lua.lua10,g_lua.lua15,                     #TQC-AB0369
  #                g_lua.luauser,g_lua.luamodu,g_lua.luagrup,g_lua.luadate,
  #                g_lua.luaacti,g_lua.luacrat,g_lua.luaplant
   DISPLAY BY NAME g_lua.lua01,g_lua.lua09,g_lua.luaplant,g_lua.lualegal,
                   g_lua.lua32,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua05,g_lua.lua04,
                   g_lua.lua20,g_lua.lua33,g_lua.lua34,g_lua.lua37,g_lua.lua10,g_lua.lua11,
                   g_lua.lua12,g_lua.lua21,g_lua.lua22,g_lua.lua23,g_lua.lua08,
                   g_lua.lua08t,g_lua.lua35,g_lua.lua36,g_lua.lua38,
                   g_lua.lua39,g_lua.lua14,g_lua.lua15,g_lua.lua16,g_lua.lua17,
                   g_lua.lua18,g_lua.luauser,g_lua.luagrup,g_lua.luaoriu,
                   g_lua.luamodu,g_lua.luadate,g_lua.luaorig,g_lua.luaacti,g_lua.luacrat
  #FUN-BB0117 Add&Mark End -----
 
  #FUN-BB0117 Mark&Add Begin ---
  #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_lua.luaplant
  #DISPLAY l_azp02 TO plant_desc
  #LET l_azp02 = ""
  #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_lua.lua19
  #DISPLAY l_azp02 TO lua19_desc
   CALL t610_fill_head()
  #FUN-BB0117 Mark&Add End -----
 
   CALL cl_set_head_visible("","YES")          

#FUN-A80105--begin--
#  INPUT BY NAME g_lua.lua01,g_lua.lua02,g_lua.lua04, g_lua.luaoriu,g_lua.luaorig,
#                g_lua.lua06,g_lua.lua21,g_lua.lua19,g_lua.lua09,
#                g_lua.lua13,g_lua.lua18
#                WITHOUT DEFAULTS
   IF p_cmd = 'a' THEN
      LET g_lua.lua11 = '0'
      CALL cl_set_comp_entry("lua11",FALSE)
   END IF
  #FUN-BB0117 Mark Begin ---
  #INPUT BY NAME g_lua.lua01,g_lua.lua02,g_lua.lua32,g_lua.lua04, g_lua.luaoriu,g_lua.luaorig,
  #              g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua21,g_lua.lua19,g_lua.lua09,
  #  #            g_lua.lua13,g_lua.lua18                                                #TQC-AB0369  mark
  #              g_lua.lua18                                                             #TQC-AB0369
  #              WITHOUT DEFAULTS
  #FUN-BB0117 Mark End -----
#FUN-A80105--end--
  #FUN-BB0117 Add Begin ---
   INPUT BY NAME g_lua.lua01,g_lua.lua09,g_lua.lua32,g_lua.lua06,g_lua.lua061,g_lua.lua07,
                 g_lua.lua04,g_lua.lua20,g_lua.lua33,g_lua.lua34,g_lua.lua37,g_lua.lua10,g_lua.lua11,
                 g_lua.lua12,g_lua.lua21,g_lua.lua08,g_lua.lua08t,g_lua.lua35,g_lua.lua36,
                 g_lua.lua38,g_lua.lua39,g_lua.lua18
                 WITHOUT DEFAULTS
  #FUN-BB0117 Add End -----
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t610_set_entry(p_cmd)
        CALL t610_set_no_entry(p_cmd)
        CALL t610_set_entry_lua04()
        IF p_cmd = 'u' THEN
          #CALL cl_set_comp_entry("lua02",FALSE) #FUN-BB0117 Mark
           IF g_lua.lua11 = '2' THEN
              CALL cl_set_comp_entry("lua04",FALSE)
           ELSE
              CALL cl_set_comp_entry("lua04",TRUE)
           END IF
        ELSE
          #CALL cl_set_comp_entry("lua02",TRUE) #FUN-BB0117 Mark
        END IF
#FUN-B50007 --------------STA
        IF g_prog = 'artt802' THEN
          #CALL cl_set_comp_entry("lua02,lua32",FALSE) #FUN-BB0117 Mark
           CALL cl_set_comp_entry("lua32",FALSE)       #FUN-BB0117 Add
        END IF
#FUN-B50007 --------------END
        LET g_before_input_done = TRUE
        CALL t610_lua06(p_cmd)
        IF p_cmd ="a" THEN
           CALL cl_set_comp_entry("lua061",TRUE)
        END IF
       #TQC-B10084 Begin---
       #FUN-BB0117 Note:客戶來源3.散客變更為5.散客
       #IF g_lua.lua32='3' THEN #FUN-BB0117 Mark
        IF g_lua.lua32='5' THEN #FUN-BB0117 Add
           CALL cl_set_comp_entry("lua04",FALSE)
        END IF
       #TQC-B10084 End-----
    #    IF g_lua.lua32 = '2' THEN                    #FUN-AC0062     #FUN-B50007 mark
       #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
       #IF g_lua.lua32 = '2' OR g_lua.lua32 = '4' THEN                #FUN-B50007 add #FUN-BB0117 Mark
        IF g_lua.lua32 = '3' OR g_lua.lua32 = '4' THEN #FUN-BB0117 Add
           CALL cl_set_comp_entry("lua061",FALSE)    
        END IF 
                                             
        INITIALIZE lua32_t TO NULL               #FUN-A80105--add-- 
        CALL cl_set_docno_format("lua01")
 
     AFTER FIELD lua01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_lua.lua01) THEN
#           CALL s_check_no("alm",g_lua.lua01,g_lua01_t,'01',"lua_file","lua01","")   #FUN-A80105--mark--
            CALL s_check_no("art",g_lua.lua01,g_lua01_t,'B9',"lua_file","lua01","")   #FUN-A80105--mod--
                 RETURNING li_result,g_lua.lua01
            IF (NOT li_result) THEN
               LET g_lua.lua01=g_lua_o.lua01
               NEXT FIELD lua01
            END IF
            DISPLAY BY NAME g_lua.lua01
         END IF 
   
         
 
      AFTER FIELD lua04
         IF g_lua.lua04 IS NOT NULL THEN
            CALL t610_lua04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lua.lua04,g_errno,1)
               LET g_lua.lua04 = g_lua_o.lua04
               NEXT FIELD lua04
            ELSE
             # LET g_lua.lua05 = '2'           #FUN-AC0062
             # DISPLAY BY NAME g_lua.lua05,g_lua.lua06,g_lua.lua061     #FUN-A80105 add lua06,lua061 by vealxu  #FUN-AC0062
               DISPLAY BY NAME g_lua.lua06,g_lua.lua061   #FUN-AC0062
               CALL t610_set_entry_lua04()
               CALL t610_get_lnt30('a') #FUN-BB0117 Add
            END IF            
         ELSE
            #FUN-A80105--begin--
#           LET g_lua.lua04 = ' '
#           LET g_lua.lua20 = ' '
            INITIALIZE g_lua.lua04,g_lua.lua20 TO NULL  
            DISPLAY BY NAME g_lua.lua04,g_lua.lua20,g_lua.lua06,g_lua.lua061      #FUN-A80105 add lua06,lua061 by vealxu 
            #FUN-A80105--end--
            CALL t610_set_entry_lua04()
         END IF
 
      AFTER FIELD lua06
         IF g_lua.lua06 IS NOT NULL THEN
#FUN-BB0117 Mark Begin ---
##FUN-A80105--begin--
#            IF g_lua.lua02 = '10' THEN
#               CALL s_chk_lne(g_lua.lua06) RETURNING l_flag
#               IF l_flag = FALSE THEN
#                  CALL cl_err("",'art-940',0)
#                  NEXT FIELD lua06
#               END IF
#            END IF
##FUN-A80105--end--
#FUN-BB0117 Mark End -----
            CALL t610_lua06(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lua.lua06,g_errno,1)
               LET g_lua.lua06 = g_lua_o.lua06
               NEXT FIELD lua06
#FUN-A80105--begin--
            ELSE
               DISPLAY BY NAME g_lua.lua061
               CALL cl_set_comp_entry("lua061",FALSE)
#FUN-A80105--end--
            END IF
            CALL t610_get_lnt30('a') #FUN-BB0117 Add
            CALL t610_get_lua05()    #FUN-BB0117 Add
         END IF     

#FUN-A80105--begin--
     AFTER FIELD lua07
       #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
       #IF g_lua.lua32 = '2' AND cl_null(g_lua.lua04)  THEN #FUN-BB0117 Mark
        IF g_lua.lua32 = '3' AND cl_null(g_lua.lua04)  THEN #FUN-BB0117 Add
           IF not cl_null(g_lua.lua07) THEN
              SELECT count(*) INTO l_n FROM lmf_file
               WHERE lmf01 = g_lua.lua07
              IF l_n = 0 THEN
                 CALL cl_err("",'alm-042',0)
                 NEXT FIELD lua07
              END IF
           END IF
        END IF
           

     AFTER FIELD lua061
       #FUN-BB0117 Note:客戶來源1.潛在商戶變更為2.潛在商戶
       #IF g_lua.lua32 = '1' THEN #FUN-BB0117 Mark
        IF g_lua.lua32 = '2' THEN #FUN-BB0117 Add
           IF not cl_null(g_lua.lua061) THEN
#             CALL cl_err("",'alm-917',0)
#             NEXT FIELD lua061
#          ELSE
              SELECT count(*) INTO l_n FROM lnb_file
               WHERE lnb05 = g_lua.lua061
                 AND lnb33 = 'Y' #TQC-C30265 Add
              IF l_n = 0  THEN
                #CALL cl_err("",'lua061',0)  #TQC-C30265 Mark
                 CALL cl_err("",'art1058',0) #TQC-C30265 Add
                 NEXT FIELD lua061
              END IF
           END IF
        END IF
       #FUN-BB0117 Add Begin ---
       #預登記商戶
        IF g_lua.lua32 = '1' THEN
           IF NOT cl_null(g_lua.lua061) THEN
              #抓預登記商戶里的商戶簡稱
             #SELECT COUNT(*) INTO l_n FROM lna_file WHERE lna04 = g_lua.lua061                 #TQC-C30265 Mark
              SELECT COUNT(*) INTO l_n FROM lna_file WHERE lna04 = g_lua.lua061 AND lna26 = 'Y' #TQC-C30265 Add
              IF l_n = 0 THEN
                #CALL cl_err("",'lua061',0)  #TQC-C30265 Mark
                 CALL cl_err("",'art1058',0) #TQC-C30265 Add
                 NEXT FIELD lua061
              END IF
           END IF
        END IF
       #FUN-BB0117 Add End -----


     AFTER FIELD lua32      
        IF NOT cl_null(g_lua.lua32) THEN #FUN-BB0117 Add
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lua_t.lua32 <> g_lua.lua32) THEN #FUN-BB0117 Add
             #IF lua32_t != g_lua.lua32 THEN #FUN-BB0017 Mark
                #FUN-BB0117 Note:客戶來源1.潛在商戶變更為2.潛在商戶,并添加1.預登記商戶(邏輯與潛在商戶一致)
                #IF g_lua.lua32 = '1' THEN #FUN-BB0117 Mark
                #IF g_lua.lua32 = '1' OR g_lua.lua32 = '2' THEN #FUN-BB0117 Add   #TQC-C30340 mark
                 IF g_lua.lua32 = '1' OR g_lua.lua32 = '2' OR g_lua.lua32 = '5' THEN   ##TQC-C30340 add
                    INITIALIZE g_lua.lua04,g_lua.lua20,g_lua.lua061 TO NULL
                    LET g_lua.lua06 = 'MISC' 
                    LET g_lua.lua07 = ''
                    DISPLAY BY NAME g_lua.lua04,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua20
                    CALL cl_set_comp_entry("lua04,lua06,lua07",FALSE)
                    CALL cl_set_comp_entry("lua061",TRUE)
                    CALL cl_set_comp_required("lua061",TRUE)
                 END IF
                 IF g_lua.lua32 = '0'  THEN
                    LET g_lua.lua07 = ''
                    INITIALIZE g_lua.lua04,g_lua.lua20,g_lua.lua06,g_lua.lua061 TO NULL
                    DISPLAY BY NAME g_lua.lua04,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua20
                    CALL cl_set_comp_entry("lua04,lua06",TRUE)
                    CALL cl_set_comp_entry("lua061",FALSE)
                    CALL cl_set_comp_entry("lua07",FALSE)
                 END IF
                #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
                #IF g_lua.lua32 = '2'  THEN #FUN-BB0117 Mark
                 IF g_lua.lua32 = '3'  THEN #FUN-BB0117 Add
                    INITIALIZE g_lua.lua04,g_lua.lua20,g_lua.lua06,g_lua.lua061,g_lua.lua07 TO NULL
                    DISPLAY BY NAME g_lua.lua04,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua20
                    CALL cl_set_comp_entry("lua04,lua06,lua07",TRUE)
                    CALL cl_set_comp_entry("lua061",FALSE)
                 END IF
                #TQC-B10084 Begin---
                #FUN-BB0117 Note:客戶類型3.散客變更為5.散客
                #IF g_lua.lua32 = '3'  THEN #FUN-BB0117 Mark
                 IF g_lua.lua32 = '5'  THEN #FUN-BB0117 Add
                    INITIALIZE g_lua.lua04,g_lua.lua20,g_lua.lua06,g_lua.lua061 TO NULL
                    SELECT rtz06,occ02 INTO g_lua.lua06,g_lua.lua061
                      FROM rtz_file LEFT OUTER JOIN occ_file ON occ01=rtz06
                     WHERE rtz01 = g_plant
                    IF cl_null(g_lua.lua06) THEN
                       CALL cl_err('','alm-984',0)
                       NEXT FIELD lua32
                    END IF
#MOD-C30098 ------ add ------ begin
                    SELECT occ41 INTO g_lua.lua21   
                      FROM occ_file
                     WHERE occ01 = g_lua.lua06
                    IF NOT cl_null(g_lua.lua21) THEN
                      SELECT gec04,gec07 INTO g_lua.lua22,g_lua.lua23 FROM gec_file
                       WHERE gec01 = g_lua.lua21 AND gec011 = '2'
                    END IF
#MOD-C30098 ------ add ------ end
                    DISPLAY BY NAME g_lua.lua04,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua20
                    DISPLAY BY NAME g_lua.lua21,g_lua.lua22,g_lua.lua23   #MOD-C30098 add
                   #CALL cl_set_comp_entry("lua07",TRUE)  #FUN-C30170 mark
                    CALL cl_set_comp_entry("lua04,lua06,lua061",FALSE)
                    CALL cl_set_comp_entry("lua07",FALSE)  #FUN-C30170 add
                 END IF
                #TQC-B10084 End-----
             #FUN-BB0017 Mark Begin ---
             #ELSE 
             #  #TQC-B10084 Begin---
             #   INITIALIZE g_lua.lua04,g_lua.lua20,g_lua.lua06,g_lua.lua061 TO NULL
             #   SELECT rtz06,occ02 INTO g_lua.lua06,g_lua.lua061
             #     FROM rtz_file LEFT OUTER JOIN occ_file ON occ01=rtz06
             #    WHERE rtz01 = g_plant
             #   IF cl_null(g_lua.lua06) THEN
             #      CALL cl_err('','alm-984',0)
             #      NEXT FIELD lua32
             #   END IF
             #   DISPLAY BY NAME g_lua.lua04,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua20
             #  #FUN-BB0117 Note:客戶類型3.散客變更為5.散客
             #  #IF g_lua.lua32 = '3'  THEN #FUN-BB0117 Mark
             #   IF g_lua.lua32 = '5'  THEN #FUN-BB0117 Add
             #      CALL cl_set_comp_entry("lua07",TRUE)
             #      CALL cl_set_comp_entry("lua04,lua06,lua061",FALSE)
             #   END IF
             #  #TQC-B10084 End-----
             #  #FUN-BB0117 Note:客戶來源1.潛在商戶變更為2.潛在商戶,并添加1.預登記商戶(邏輯與潛在商戶一致)
             #  #IF g_lua.lua32 = '1' THEN #FUN-BB0117 Mark
             #   IF g_lua.lua32 = '1' OR g_lua.lua32 = '2' THEN #FUN-BB0117 Add
             #      INITIALIZE g_lua.lua04,g_lua.lua20 TO NULL
             #      LET g_lua.lua06 = 'MISC' 
             #      LET g_lua.lua07 = ' '
             #      DISPLAY BY NAME g_lua.lua04,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua20
             #      CALL cl_set_comp_entry("lua04,lua06,lua07",FALSE)
             #      CALL cl_set_comp_entry("lua061",TRUE)
             #      CALL cl_set_comp_required("lua061",TRUE)
             #   END IF
             #   IF g_lua.lua32 = '0' THEN
             #      CALL cl_set_comp_entry("lua04,lua06",TRUE)     #FUN-A80105 mark lua07 by vealxu
             #      CALL cl_set_comp_entry("lua061,lua07",FALSE)   #FUN-A80105 add lua07 by vealxu
             #   END IF
             #  #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
             #  #IF g_lua.lua32 = '2' THEN #FUN-BB0117 Mark
             #   IF g_lua.lua32 = '3' THEN #FUN-BB0117 Add
             #      CALL cl_set_comp_entry("lua04,lua06,lua07",TRUE)
             #      CALL cl_set_comp_entry("lua061",FALSE)
             #   END IF
             #END IF
             #FUN-BB0017 Mark End -----
             #LET lua32_t = g_lua.lua32 #FUN-BB0117 Mark
                 CALL t610_get_lnt30('a') #FUN-BB0117 Add
           END IF #FUN-BB0117 Add
        END IF    #FUN-BB0117 Add

       #FUN-BB0117 Mark Begin ---
       #IF g_lua.lua02 = '10' THEN
       #   IF g_lua.lua32 = '0' THEN
       #      CALL cl_err("",'art-941',0)
       #      NEXT FIELD lua32
       #   END IF
       #END IF
       #FUN-BB0117 Mark End -----
#FUN-A80105--end--
        
 
    #FUN-BB0117 Mark Begin ---
    #AFTER FIELD lua19
    #   IF NOT cl_null(g_lua.lua19) THEN
    #      CALL t610_lua19()
    #      IF NOT cl_null(g_errno) THEN
    #         CALL cl_err(g_lua.lua19,g_errno,0)
    #         NEXT FIELD lua19
    #      END IF
    #   END IF
    #FUN-BB0117 Mark End -----
 
#FUN-B50007 ------------STA
    AFTER FIELD lua09
       IF NOT cl_null(g_lua.lua09) AND  g_lua.lua32 = '4' THEN
          IF g_lua.lua09 <= g_rcj.rcj01 THEN
             CALL cl_err('','art-829',0)
             NEXT FIELD lua09
          END IF
       END IF 
#FUN-B50007 ------------END
     AFTER FIELD lua21
        IF NOT cl_null(g_lua.lua21) THEN
           SELECT gec04,gec07
             INTO g_lua.lua22,g_lua.lua23
             FROM gec_file
            WHERE gec01=g_lua.lua21
              AND gec011='2'
           IF STATUS THEN
#             CALL cl_err3("sel","gec_file",g_lua.lua21,"",STATUS,"","select gec",1)  #FUN-A80105--mark--
              CALL cl_err("",'alm-921',0)                                             #FUN-A80105--mod--
              LET g_lua.lua21 = g_lua_o.lua21
              NEXT FIELD lua21
           END IF  
           DISPLAY BY NAME g_lua.lua22,g_lua.lua23
        END IF
        #No.TQC-AB0019  --Begin
        #CHI-CB0008 mark begin---
        #IF p_cmd = 'u' AND (g_lua.lua22 <> g_lua_t.lua22 OR cl_null(g_lua_t.lua22)  OR
        #                   g_lua.lua23 <> g_lua_t.lua23 OR cl_null(g_lua_t.lua23)) THEN
        #  CALL t610_upd_lua21()
        #END IF
        #CHI-CB0008 mark end-----
        #CHI-CB0008 add begin---
        IF p_cmd = 'u' THEN
           IF g_lua.lua22 <> g_lua_t.lua22 OR cl_null(g_lua_t.lua22) THEN
              CALL t610_upd_lua21('N')
           END IF
           IF (g_lua.lua22 = g_lua_t.lua22 AND g_lua.lua23 <> g_lua_t.lua23) OR cl_null(g_lua_t.lua23) THEN
              CALL t610_upd_lua21('Y')
           END IF
        END IF
        #CHI-CB0008 add end-----

        #No.TQC-AB0019  --End  

    #FUN-BB0117 Add Begin ---
     #直接收款
     AFTER FIELD lua37
        IF NOT cl_null(g_lua.lua37) AND NOT cl_null(g_lua.lua06) THEN
           IF NOT cl_null(g_lua.lua32) AND (g_lua.lua32 = '0' OR g_lua.lua32 = '3') THEN
              IF s_chk_own(g_lua.lua06) AND g_lua.lua37 = 'Y' THEN
                 CALL cl_err('','art1034',0)
                 NEXT FIELD lua37
              END IF
           END IF
        END IF
        #FUN-C30072 add begin ---
        IF NOT cl_null(g_lua.lua37) THEN
           CALL t610_chk_lua37_lub03()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_lua.lua37 = g_lua_t.lua37
              NEXT FIELD lua37
           END IF 
        END IF 
        #FUN-C30072 add end ----- 

     #業務人員
     AFTER FIELD lua38
        IF NOT cl_null(g_lua.lua38) THEN
           CALL t610_lua38('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_lua.lua38 = g_lua_t.lua38
              DISPLAY BY NAME g_lua.lua38
              NEXT FIELD lua38
           END IF
        END IF

     #部門編號
     AFTER FIELD lua39
        IF NOT cl_null(g_lua.lua39) THEN
           CALL t610_lua39('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              LET g_lua.lua39 = g_lua_t.lua39
              DISPLAY BY NAME g_lua.lua39
              NEXT FIELD lua39
           END IF
        END IF
    #FUN-BB0117 Add End -----
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(lua01)
              LET g_t1=s_get_doc_no(g_lua.lua01)
             # CALL q_lrk(FALSE,FALSE,g_t1,'01','ALM') RETURNING g_t1     #FUN-A70130   mark
              CALL q_oay(FALSE,FALSE,g_t1,'B9','ART') RETURNING g_t1     #FUN-A70130  add
              LET g_lua.lua01 = g_t1
              DISPLAY BY NAME g_lua.lua01
              NEXT FIELD lua01
 
           WHEN INFIELD(lua04)
#FUN-A80105--begin--
#             CALL cl_init_qry_var()
#             LET g_qryparam.form="q_rto01"
#             LET g_qryparam.default1 =g_lua.lua04
#             CALL cl_create_qry() RETURNING g_lua.lua04
#             DISPLAY BY NAME g_lua.lua04
#             NEXT FIELD lua04
                
              IF cl_null(g_lua.lua32) THEN
                 CALL cl_err("",'art-801',0)
                 NEXT FIELD lua04
              END IF
              IF g_lua.lua32 = '0' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_rto01"
                 LET g_qryparam.default1 =g_lua.lua04
                 CALL cl_create_qry() RETURNING g_lua.lua04
                 DISPLAY BY NAME g_lua.lua04
                 NEXT FIELD lua04
              END IF
             #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
             #IF g_lua.lua32 = '2' THEN #FUN-BB0117 Mark
              IF g_lua.lua32 = '3' THEN #FUN-BB0117 Add
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_lnt_01"
                 LET g_qryparam.default1 =g_lua.lua04
                 CALL cl_create_qry() RETURNING g_lua.lua04
                 DISPLAY BY NAME g_lua.lua04
                 NEXT FIELD lua04
              END IF
#FUN-A80105--end--
 
#FUN-A80105--begin--
#          WHEN INFIELD(lua06)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form="q_occ91"
#                LET g_qryparam.default1 =g_lua.lua06
#                CALL cl_create_qry() RETURNING g_lua.lua06
#                DISPLAY BY NAME g_lua.lua06
#                NEXT FIELD lua06
           WHEN INFIELD(lua06)
              IF cl_null(g_lua.lua32) THEN
                 CALL cl_err("",'art-801',0)
                 NEXT FIELD lua06
              END IF
              IF g_lua.lua32 = '0' THEN
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_occ02"
                 LET g_qryparam.default1 =g_lua.lua06
                 CALL cl_create_qry() RETURNING g_lua.lua06
                 DISPLAY BY NAME g_lua.lua06
                 NEXT FIELD lua06
              END IF
             #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
             #IF g_lua.lua32 = '2' THEN #FUN-BB0117 Mark
              IF g_lua.lua32 = '3' THEN #FUN-BB0117 Add
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_lne_1"
                 LET g_qryparam.default1 =g_lua.lua06
                 CALL cl_create_qry() RETURNING g_lua.lua06
                 DISPLAY BY NAME g_lua.lua06
                 NEXT FIELD lua06
              END IF
 
           WHEN INFIELD(lua061)
             #FUN-BB0117 Add&Mark Begin ---
             #CALL cl_init_qry_var()
             #LET g_qryparam.form="q_lnb05"
             #LET g_qryparam.default1 =g_lua.lua061
             #CALL cl_create_qry() RETURNING g_lua.lua061
             #DISPLAY BY NAME g_lua.lua061
             #NEXT FIELD lua061

              IF NOT cl_null(g_lua.lua32) THEN
                 CALL cl_init_qry_var()
                 IF g_lua.lua32 = '1' THEN
                    LET g_qryparam.form="q_lna04"
                    LET g_qryparam.where = " lna26 = 'Y' " #TQC-C30265 Add
                 END IF
                 IF g_lua.lua32 = '2' THEN
                    LET g_qryparam.form="q_lnb05"
                    LET g_qryparam.where = " lnb33 = 'Y' " #TQC-C30265 Add
                 END IF
                 LET g_qryparam.default1 =g_lua.lua061 
                 CALL cl_create_qry() RETURNING g_lua.lua061
                 DISPLAY BY NAME g_lua.lua061
                 NEXT FIELD lua061
              ELSE
                 CALL cl_err('','alm1511',0)
              END IF
             #FUN-BB0117 Add&Mark End -----
               

           WHEN INFIELD(lua07) 
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_lmf1"
              LET g_qryparam.default1 =g_lua.lua07
              CALL cl_create_qry() RETURNING g_lua.lua07
              DISPLAY BY NAME g_lua.lua07
              NEXT FIELD lua07
              
#FUN-A80105--end--
 
          #FUN-BB0117 Mark Begin ---
          #WHEN INFIELD(lua19)
          #   CALL cl_init_qry_var()
#         #   LET g_qryparam.form="q_tqb01_2"               #FUN-A80105--mark--
          #   LET g_qryparam.form="q_azp"                   #FUN-A80105--mod--
          #   LET g_qryparam.default1 =g_lua.lua19
          #   CALL cl_create_qry() RETURNING g_lua.lua19
          #   DISPLAY BY NAME g_lua.lua19
          #   NEXT FIELD lua19
          #FUN-BB0117 Mark End -----
 
           WHEN INFIELD(lua21)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_gec"
              LET g_qryparam.arg1='2'
              LET g_qryparam.default1 =g_lua.lua21
              CALL cl_create_qry() RETURNING g_lua.lua21
              DISPLAY BY NAME g_lua.lua21
              NEXT FIELD lua21

          #FUN-BB0117 Add Begin ---
           WHEN INFIELD(lua38)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_gen"
              LET g_qryparam.default1 =g_lua.lua38
              CALL cl_create_qry() RETURNING g_lua.lua38
              DISPLAY BY NAME g_lua.lua38
              CALL t610_lua38('d')
              NEXT FIELD lua38

           WHEN INFIELD(lua39)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_gem"
              LET g_qryparam.default1 =g_lua.lua39
              CALL cl_create_qry() RETURNING g_lua.lua39
              DISPLAY BY NAME g_lua.lua39
              CALL t610_lua39('d')
              NEXT FIELD lua39
          #FUN-BB0117 Add End -----

           OTHERWISE EXIT CASE
        END CASE       
           
      ON ACTION CONTROLO                 
         IF INFIELD(lua01) THEN
            LET g_lua.* = g_lua_t.*
            CALL t610_show()
            NEXT FIELD lua01
         END IF
    
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
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
    END INPUT
END FUNCTION
#FUN-BB0117 Mark Begin ---
#FUNCTION t610_lua19()
#DEFINE l_azp02    LIKE azp_file.azp02
# 
#   LET g_errno = ""
#   
#   SELECT azp02 INTO l_azp02 FROM azp_file
#       WHERE azp01 = g_lua.lua19
#   CASE
##     WHEN SQLCA.SQLCODE = 100  LET g_errno = "art-551"    #FUN-A80105--mark--
#      WHEN SQLCA.SQLCODE = 100  LET g_errno = "aap-025"    #FUN-A80105--mod--
#   END CASE 
#   IF g_errno IS NULL THEN
#      DISPLAY l_azp02 TO lua19_desc
#   END IF
#END FUNCTION
#FUN-BB0117 Mark End -----
 
FUNCTION t610_auto_code()
   DEFINE l_lua01 LIKE lua_file.lua01
   DEFINE l_date  LIKE lua_file.luacrat
  #SELECT max(SUBSTR(lua01,9))+1 INTO l_lua01 FROM lua_file
   SELECT max(lua01[9,20])+1 INTO l_lua01 FROM lua_file       #FUN-B40029
    WHERE luacrat=g_today  
   IF cl_null(l_lua01) THEN
      LET l_lua01 = l_lua01 using '&&&&'
      LET l_lua01 = YEAR(g_today) USING '&&&&' ,MONTH(g_today) USING '&&',DAY(g_today) USING '&&',"0001"
   ELSE
      LET l_lua01 = l_lua01 using '&&&&' 
      LET l_lua01 = YEAR(g_today) USING '&&&&' ,MONTH(g_today) USING '&&',DAY(g_today) USING '&&',l_lua01 
   END IF
   RETURN l_lua01
END FUNCTION
 
FUNCTION t610_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lub.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t610_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lua.* TO NULL
      RETURN
   END IF
 
   OPEN t610_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lua.* TO NULL
   ELSE
      OPEN t610_count
      FETCH t610_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t610_fetch('F')
   END IF
END FUNCTION
 
FUNCTION t610_fetch(p_flag)
DEFINE         p_flag         LIKE type_file.chr1                 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t610_cs INTO g_lua.lua01
      WHEN 'P' FETCH PREVIOUS t610_cs INTO g_lua.lua01
      WHEN 'F' FETCH FIRST    t610_cs INTO g_lua.lua01
      WHEN 'L' FETCH LAST     t610_cs INTO g_lua.lua01
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
          FETCH ABSOLUTE g_jump t610_cs INTO g_lua.lua01
          LET mi_no_ask = FALSE    
     END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      INITIALIZE g_lua.* TO NULL               
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
 
   SELECT * INTO g_lua.* FROM lua_file WHERE lua01 = g_lua.lua01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lua_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_lua.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lua.luauser      
   LET g_data_group = g_lua.luagrup      
   LET g_data_plant = g_lua.luaplant  #TQC-A10128 ADD
   CALL t610_show()
END FUNCTION
 
FUNCTION t610_show()
DEFINE l_azp02    LIKE azp_file.azp02
 
   LET g_lua_t.* = g_lua.* 
   LET g_lua_o.* = g_lua.*

#FUN-A80105--begin--
#  DISPLAY BY NAME g_lua.lua01,g_lua.lua02,g_lua.lua04, g_lua.luaoriu,g_lua.luaorig,
#                  g_lua.lua06,g_lua.lua08,g_lua.lua09,g_lua.lua10,
#                  g_lua.lua11,g_lua.lua12,g_lua.lua13,g_lua.lua14,g_lua.lua15,
#                  g_lua.lua16,g_lua.lua17,g_lua.lua18,g_lua.lua20,
#                  g_lua.luauser,g_lua.luamodu,g_lua.luagrup,g_lua.luadate,
#                  g_lua.luaacti,g_lua.luacrat,g_lua.lua21,g_lua.lua22,g_lua.lua19,
#                  g_lua.lua23,g_lua.lua08t,g_lua.lua24,g_lua.luaplant
  #FUN-BB0117 Mark Begin ---
  #DISPLAY BY NAME g_lua.lua01,g_lua.lua02,g_lua.lua32,g_lua.lua04, g_lua.luaoriu,g_lua.luaorig,
  #                g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua08,g_lua.lua09,g_lua.lua10,
  ##                g_lua.lua11,g_lua.lua12,g_lua.lua13,g_lua.lua14,g_lua.lua15,                        #TQC-AB0369  mark
  #                g_lua.lua11,g_lua.lua12,g_lua.lua15,                                     #TQC-AB0369
  #                g_lua.lua16,g_lua.lua17,g_lua.lua18,g_lua.lua20,
  #                g_lua.luauser,g_lua.luamodu,g_lua.luagrup,g_lua.luadate,
  #                g_lua.luaacti,g_lua.luacrat,g_lua.lua21,g_lua.lua22,g_lua.lua19,
  #                g_lua.lua23,g_lua.lua08t,g_lua.lua24,g_lua.luaplant
  #FUN-BB0117 Mark End -----
#FUN-A80105--end--
  #FUN-BB0117 Add Begin ---
   DISPLAY BY NAME g_lua.lua01,g_lua.lua09,g_lua.luaplant,g_lua.lualegal,
                   g_lua.lua32,g_lua.lua06,g_lua.lua061,g_lua.lua07,g_lua.lua05,g_lua.lua04,
                   g_lua.lua20,g_lua.lua33,g_lua.lua34,g_lua.lua10,g_lua.lua11,
                   g_lua.lua12,g_lua.lua21,g_lua.lua22,g_lua.lua23,g_lua.lua08,
                   g_lua.lua08t,g_lua.lua35,g_lua.lua36,g_lua.lua37,g_lua.lua38,
                   g_lua.lua39,g_lua.lua14,g_lua.lua15,g_lua.lua16,g_lua.lua17,
                   g_lua.lua18,g_lua.luauser,g_lua.luagrup,g_lua.luaoriu,
                   g_lua.luamodu,g_lua.luadate,g_lua.luaorig,g_lua.luaacti,g_lua.luacrat
  #FUN-BB0117 Add End -----
 
  #FUN-BB0117 Add&Mark Begin ---
  #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_lua.luaplant
  #DISPLAY l_azp02 TO plant_desc
  #LET l_azp02 = ""
  #SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_lua.lua19
  #DISPLAY l_azp02 TO lua19_desc
   CALL t610_fill_head()
  #FUN-BB0117 Add&Mark End -----
 
   CALL t610_b_fill(g_wc2)
   CALL t610_field_pic() 
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION t610_field_pic()
     LET g_void=NULL
     LET g_approve=NULL
     LET g_confirm=NULL
     IF g_lua.lua15 MATCHES '[Yy]' THEN
        IF g_lua.lua14 MATCHES '[SsRrWw0]' THEN
           LET g_confirm='Y'
           LET g_approve='N'
           LET g_void='N'
        END IF
        IF g_lua.lua14 MATCHES '[1]' THEN
           LET g_confirm='Y'
           LET g_approve='Y'
           LET g_void='N'
        END IF
     ELSE
        IF g_lua.lua15 ='X' THEN
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='Y'
        ELSE
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(g_confirm,g_approve,"","",g_void,g_lua.luaacti)
END FUNCTION
 
FUNCTION t610_lua06(p_cmd)  
   DEFINE l_occ02     LIKE occ_file.occ02
   DEFINE l_occacti   LIKE occ_file.occacti
   DEFINE l_occ1004   LIKE occ_file.occ1004
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE l_n         LIKE type_file.num5     #FUN-B50007
   LET g_errno=''

#FUN-A80105--begin--
#  SELECT occ02,occ1004,occacti INTO l_occ02,l_occ1004,l_occacti
#    FROM occ_file
#   WHERE occ01=g_lua.lua06
#     CASE WHEN SQLCA.sqlcode=100 LET g_errno='apc-098'
#                                 LET l_occ02=NULL
#          WHEN l_occ1004 != '1'  LET g_errno='art-578'
#          WHEN l_occacti != 'Y'  LET g_errno='9029'
#          OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#     END CASE
   IF g_lua.lua32 = '0' THEN
     #SELECT occ02,occ1004,occacti INTO g_lua.lua061,l_occ1004,l_occacti
     #  FROM occ_file,pmc_file,rto_file
     # WHERE occ01 = g_lua.lua06
     #   AND occ01 = pmc01
     #   AND occ01 = rto05
      SELECT occ02,occ41,occacti INTO g_lua.lua061,g_lua.lua21,l_occacti #MOD-C30098 add occ41,lua21
        FROM occ_file
       WHERE occ01 = g_lua.lua06

      CASE WHEN SQLCA.sqlcode=100 LET g_errno='apc-098'
                                  LET g_lua.lua061=NULL
                                  LET g_lua.lua21 =NULL #MOD-C30098 add
           WHEN l_occacti != 'Y'  LET g_errno='9029'
           OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE
   END IF                    

  #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
  #IF g_lua.lua32 = '2' THEN #FUN-BB0117 Mark
   IF g_lua.lua32 = '3' THEN #FUN-BB0117 Add
      SELECT lne05,lne40 INTO g_lua.lua061,g_lua.lua21 FROM lne_file #MOD-C30098 add lne40,lua21
       WHERE lne01 = g_lua.lua06
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='apc-098'
                                  LET g_lua.lua061=NULL
                                  LET g_lua.lua21 =NULL #MOD-C30098 add
           OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE
   END IF
#FUN-A80105--end--
#FUN-B50007 ---------------STA
   IF g_prog = 'artt802' THEN
       SELECT occ02,occ41 INTO g_lua.lua061,g_lua.lua21 FROM occ_file
        WHERE occ01 = g_lua.lua06 AND occ1004 = '1'
       SELECT gec04,gec07 INTO g_lua.lua22,g_lua.lua23 FROM gec_file
        WHERE gec01 = g_lua.lua21 AND gecacti = 'Y'
      DISPLAY BY NAME g_lua.lua061,g_lua.lua21,g_lua.lua22,g_lua.lua23
      CALL cl_set_comp_entry("lua06,lua061,lua21",FALSE)
   END IF
#FUN-B50007 ---------------END
#MOD-C30098 ------ add ------ begin
   IF NOT cl_null(g_lua.lua21) THEN
      SELECT gec04,gec07 INTO g_lua.lua22,g_lua.lua23 FROM gec_file
       WHERE gec01 = g_lua.lua21 AND gec011 = '2'
   END IF
   DISPLAY BY NAME g_lua.lua061,g_lua.lua21,g_lua.lua22,g_lua.lua23
#MOD-C30098 ------ add ------ end
END FUNCTION
 
FUNCTION t610_lua04(p_cmd)  
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_rto02   LIKE rto_file.rto02
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_lnt26   LIKE lnt_file.lnt26       #TQC-C30340 add
 
   LET g_errno=''
 
#FUN-A80105--begin--
#  SELECT MAX(rto02)
#    INTO g_lua.lua20
#    FROM rto_file
#   WHERE rto01=g_lua.lua04
#     AND rtoplant = g_lua.luaplant
#  CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-132'
#                              LET g_lua.lua20 = NULL
#                              LET g_lua.lua07 = NULL
#  OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#  END CASE
#  IF cl_null(g_errno) THEN
#     SELECT COUNT(*) INTO l_n FROM rto_file WHERE rto01=g_lua.lua04
#         AND rtoplant = g_lua.luaplant AND rto02 = g_lua.lua20
#         AND rtoconf = 'Y'
#     IF l_n IS NULL THEN LET l_n = 0 END IF
#     IF l_n = 0 THEN LET g_errno='9029' RETURN END IF
#     DISPLAY BY NAME g_lua.lua20                   
#     CALL cl_set_comp_entry("lua07",FALSE)         
#  END IF

   IF g_lua.lua32 = '0'  THEN
#     SELECT MAX(rto02) INTO g_lua.lua20 FROM rto_file
     #TQC-C30265 Add Begin ---
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM rto_file
       WHERE rto01=g_lua.lua04
         AND rtoplant = g_lua.luaplant
      IF l_n = 0 THEN
         LET g_errno='alm-132'
         LET g_lua.lua20 = NULL
         LET g_lua.lua07 = NULL
      ELSE
         LET l_n = 0
     #TQC-C30265 Add End -----
         SELECT MAX(rto02) INTO l_n FROM rto_file
          WHERE rto01=g_lua.lua04
            AND rtoplant = g_lua.luaplant
         LET g_lua.lua20 = l_n
         CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-132'
                                     LET g_lua.lua20 = NULL
                                     LET g_lua.lua07 = NULL
         OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
         END CASE
      END IF #TQC-C30265 Add
      IF cl_null(g_errno) THEN
         SELECT rto05 INTO g_lua.lua06
           FROM rto_file 
          WHERE rto01=g_lua.lua04
            AND rtoplant = g_lua.luaplant AND rto02 = g_lua.lua20
            AND rtoconf = 'Y'
#        IF SQLCA.sqlcode = 100 THEN LET g_errno='9029' RETURN END IF
        #FUN-A80105 --------------add start by vealxu--------
         SELECT count(*) INTO l_n FROM occ_file
          WHERE occ01 = g_lua.lua06
         IF cl_null(l_n) OR l_n = 0 THEN
            LET g_errno = 'art-813'
         ELSE
        #FUN-A80105 -------------add end by vealxu -----------
            SELECT occ02 INTO g_lua.lua061
              FROM occ_file
             WHERE occ01 = g_lua.lua06
         END IF    #FUN-A80105 add by vealxu
         LET g_lua.lua07 = ' '
         DISPLAY BY NAME g_lua.lua20,g_lua.lua07,g_lua.lua06,g_lua.lua061       
      END IF
   END IF

  #FUN-BB0117 Note:客戶來源2.正式商戶變更為3.正式商戶
  #IF g_lua.lua32 = '2'  THEN #FUN-BB0117 Mark
   IF g_lua.lua32 = '3'  THEN #FUN-BB0117 Add
      SELECT MAX(lnt02) INTO g_lua.lua20 FROM lnt_file
       WHERE lnt01 = g_lua.lua04
      SELECT lnt06 INTO g_lua.lua07 FROM lnt_file
       WHERE lnt01 = g_lua.lua04
         AND lnt02 = g_lua.lua20
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-132'
                                  LET g_lua.lua20 = NULL
                                  LET g_lua.lua07 = NULL
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE
      IF cl_null(g_errno) THEN    
         #SELECT lnt04,lnt06 INTO g_lua.lua06,g_lua.lua07 FROM lnt_file  #TQC-C30340 mark
         SELECT lnt04,lnt06,lnt26 INTO g_lua.lua06,g_lua.lua07 ,l_lnt26 FROM lnt_file   #TQC-C30340 add
          WHERE lnt01 = g_lua.lua04
            AND lnt02 = g_lua.lua20
         IF SQLCA.sqlcode = 100 THEN LET g_errno='9029' RETURN END IF
         IF l_lnt26 = 'N' THEN LET g_errno = 'alm1615' RETURN END IF     #TQC-C30340 add
         SELECT lne05 INTO g_lua.lua061
           FROM lne_file
          WHERE lne01 = g_lua.lua06
         DISPLAY BY NAME g_lua.lua20,g_lua.lua07,g_lua.lua06,g_lua.lua061       
      END IF
   END IF
#FUN-A80105--end--

END FUNCTION
 
FUNCTION t610_lua07(p_cmd)  
   DEFINE l_lmf02   LIKE lmf_file.lmf02
   DEFINE l_lmf06   LIKE lmf_file.lmf06
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_lmfacti LIKE lmf_file.lmfacti
   LET g_errno=''
   
   SELECT lmf02,lmf06,lmfacti INTO l_lmf02,l_lmf06,l_lmfacti 
     FROM lmf_file
    WHERE lmf01=g_lua.lua07
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-042'
        WHEN l_lmfacti='N'     LET g_errno='9028'
        WHEN l_lmf06!='Y'       LET g_errno='9029'
        WHEN l_lmf02 <> g_plant LET g_errno='alm-376'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
   END IF
END FUNCTION
 
FUNCTION t610_lub03(p_cmd) 
   DEFINE l_oaj02   LIKE oaj_file.oaj02
   DEFINE l_lnj02   LIKE lnj_file.lnj02
   DEFINE l_oaj031   LIKE oaj_file.oaj031
   DEFINE l_oaj04   LIKE oaj_file.oaj04
   DEFINE l_oaj041  LIKE oaj_file.oaj041
   DEFINE l_oaj05   LIKE oaj_file.oaj05
   DEFINE l_aag02   LIKE aag_file.aag02
   DEFINE l_aag02_1 LIKE aag_file.aag02
#   DEFINE l_oaj06   LIKE oaj_file.oaj06     #FUN-A80105
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_oajacti   LIKE oaj_file.oajacti
   DEFINE l_cnt       LIKE type_file.num5    #TQC-B50132
   #FUN-C10024--add--str--
   DEFINE l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
   #FUN-C10024--add--end--
   LET g_errno=''
 
#   SELECT oaj02,oaj031,oaj04,oaj041,oaj05,oaj06,oajacti                 #FUN-A80105
#     INTO l_oaj02,l_oaj031,l_oaj04,l_oaj041,l_oaj05,l_oaj06,l_oajacti   #FUN-A80105
   SELECT oaj02,oaj031,oaj04,oaj041,oaj05,oajacti               #FUN-A80105
     INTO l_oaj02,l_oaj031,l_oaj04,l_oaj041,l_oaj05,l_oajacti   #FUN-A80105
     FROM oaj_file
    WHERE oaj01=g_lub[l_ac].lub03
     #AND oaj05=g_lua.lua02    #TQC-B60278 add #FUN-BB0117 Mark
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-075'
                               LET l_oaj02=NULL
                               LET l_oaj04=NULL
                               LET l_oaj041=NULL
#                              LET l_oaj06=NULL       #FUN-A80105
        WHEN l_oajacti='N'       LET g_errno='9028'
       #WHEN l_oaj05 != g_lua.lua02  LET g_errno = 'alm-130' #FUN-BB0117 Mark
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   #TQC-B50132--add--srt--
   IF NOT cl_null(l_oaj04) AND (p_cmd = 'a' OR p_cmd = 'u') THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM aag_file
       WHERE aag01 = l_oaj04
         AND aag00 = g_aza.aza81
      IF l_cnt < 1 THEN
         LET g_errno='art1004'
      END IF   
   END IF
   #TQC-B50132--add--end--
   CALL s_get_bookno(YEAR(g_lua.lua09)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
   SELECT lnj02 INTO l_lnj02 FROM lnj_file
    WHERE lnj01=l_oaj031
   SELECT aag02 INTO l_aag02 FROM aag_file
    WHERE aag01=l_oaj04
      #AND aag00=g_aza.aza81  #FUN-C10024
      AND aag00 =l_bookno1   #FUN-C10024 add
   SELECT aag02 INTO l_aag02_1 FROM aag_file
    WHERE aag01=l_oaj041
      #AND aag00=g_aza.aza81  #FUN-C10024
      AND aag00 =l_bookno2  #FUN-C10024 add 
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      LET g_lub[l_ac].oaj02 = l_oaj02
      LET g_lub[l_ac].oaj04 = l_oaj04
      LET g_lub[l_ac].oaj041 = l_oaj041
#      LET g_lub[l_ac].oaj06 = l_oaj06      #FUN-A80105
      LET g_lub[l_ac].oaj031 = l_oaj031
      LET g_lub[l_ac].lnj02 = l_lnj02
      LET g_lub[l_ac].aag02 = l_aag02
      LET g_lub[l_ac].aag02_1 = l_aag02_1
#      DISPLAY BY NAME g_lub[l_ac].oaj02,g_lub[l_ac].oaj04,g_lub[l_ac].oaj06,   #FUN-A80105
      DISPLAY BY NAME g_lub[l_ac].oaj02,g_lub[l_ac].oaj04,                      #FUN-A80105
                      g_lub[l_ac].oaj031,g_lub[l_ac].lnj02,g_lub[l_ac].aag02
     #FUN-BB0117 Add Begin ---
      IF p_cmd = 'a' OR p_cmd = 'u' THEN
         LET g_lub[l_ac].lub09 = l_oaj05
      END IF
     #FUN-BB0117 Add End -----
   END IF
END FUNCTION

#FUN-C30072 add begin --- 
FUNCTION t610_chk_lub03(p_cmd) 
   DEFINE l_lub09   LIKE lub_file.lub09
   DEFINE p_cmd     LIKE type_file.chr1
   LET g_errno = ''
   IF p_cmd = 'u' THEN
      LET g_sql = "SELECT DISTINCT lub09 FROM lub_file WHERE lub01 = '",g_lua.lua01,"' AND lub02 <> '",g_lub_t.lub02,"'"
   ELSE  
      LET g_sql = "SELECT DISTINCT lub09 FROM lub_file WHERE lub01 = '",g_lua.lua01,"'"
   END IF 
   PREPARE sel_lub_pre_1 FROM g_sql 
   DECLARE sel_lub_cur_1 CURSOR FOR sel_lub_pre_1
   FOREACH sel_lub_cur_1 INTO l_lub09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach sel_lub_cur',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF  
      IF g_lub[l_ac].lub09 = '10' THEN
         IF l_lub09 <> '10' THEN
            LET g_errno = 'art1063'       
            EXIT FOREACH
         END IF 
      ELSE 
         IF l_lub09 = '10' THEN
            LET g_errno = 'art1063'
            EXIT FOREACH
         END IF 
      END IF  
   END FOREACH 
END FUNCTION

FUNCTION t610_chk_lua37_lub03()
   DEFINE l_cnt   LIKE type_file.num10
   LET g_errno = ''
   CASE 
      WHEN INFIELD(lua37)
         IF g_lua.lua37 = 'Y' THEN
            SELECT COUNT(*) INTO l_cnt
              FROM lub_file 
             WHERE lub01 = g_lua.lua01
               AND lub09 = '10' 
            IF l_cnt > 0 THEN
               LET g_errno = 'art1064'
            END IF 
         END IF
      WHEN INFIELD(lub03)
         IF g_lua.lua37 = 'Y' AND g_lub[l_ac].lub09 = '10' THEN
            LET g_errno = 'art1064'
         END IF
   END CASE 
END FUNCTION

FUNCTION t610_chk_paynote()
   DEFINE l_n  LIKE type_file.num10
   LET g_errno = ''
   SELECT COUNT(*) INTO l_n
     FROM lub_file
    WHERE lub01 = g_lua.lua01
      AND lub09 = '10'
   IF l_n > 0 THEN
      LET g_errno = 'art1066'    #费用支出类型的费用不可收款单收款和收款单查询
   END IF
END FUNCTION 
#FUN-C30072 add end -----

FUNCTION t610_b(p_c)
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    p_c             LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lua.lua01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_lua.* FROM lua_file
     WHERE lua01=g_lua.lua01
 
    IF g_lua.luaacti ='N' THEN 
       CALL cl_err(g_lua.lua01,'mfg1000',0)
       RETURN
    END IF

    IF g_lua.lua14 = '2' THEN
       CALL cl_err('','axr-369',0)
       RETURN
    END IF
 
    IF g_lua.lua15='Y' THEN            #已審核
       CALL cl_err(g_lua.lua09,'9003',0)
       RETURN
    END IF
 
    IF g_lua.lua15='X' THEN             #已作廢
       CALL cl_err(g_lua.lua09,'9024',0)
       RETURN
    END IF

  #FUN-BB0117 Add Begin ---
    IF g_lua.lua10 = 'Y' THEN
       CALL cl_err('','art-761',0) #自動產生的單據不可進行修改和單身操作
       RETURN
    END IF

    IF g_lua.lua35 > 0 THEN
       CALL cl_err('','art-762',0) #已付款，不可異動
       RETURN
    END IF
  #FUN-BB0117 Add End -----
 
    CALL cl_opmsg('b')
 
#   LET g_forupd_sql = "SELECT lub02,lub03,'','','','','','','','',lub04,lub04t,lub05",    #FUN-A80105--mark--
   #LET g_forupd_sql = "SELECT lub02,lub03,'','','','','','','',lub04,lub04t,lub05",    #FUN-A80105--mod-- #FUN-BB0117 Mark
    LET g_forupd_sql = "SELECT lub02,lub03,'','','',lub09,lub07,lub08,lub10,lub04,lub04t, ", #FUN-BB0117 Add
                       "       lub11,'',lub12,'','','','',lub13,lub14,lub15,lub05,lub16 ",   #FUN-BB0117 Add
                       "  FROM lub_file",
                       " WHERE lub01=? AND lub02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t610_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

 
    INPUT ARRAY g_lub WITHOUT DEFAULTS FROM s_lub.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t610_cl USING g_lua.lua01
           IF STATUS THEN
              CALL cl_err("OPEN t610_cl:", STATUS, 1)
              CLOSE t610_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t610_cl INTO g_lua.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0) 
              CLOSE t610_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lub_t.* = g_lub[l_ac].*  #BACKUP
              LET g_lub_o.* = g_lub[l_ac].*  #BACKUP
              OPEN t610_bcl USING g_lua.lua01,g_lub_t.lub02
              IF STATUS THEN
                 CALL cl_err("OPEN t610_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t610_bcl INTO g_lub[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lub_t.lub02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t610_lub03('d')
              END IF
              CALL t610_set_entry_lua23()
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lub[l_ac].* TO NULL
           LET g_lub[l_ac].lub04 = 0
           LET g_lub[l_ac].lub04t = 0     #FUN-A80105--add--
           CALL t610_b_get_default() #FUN-BB0117 Add
           LET g_lub_t.* = g_lub[l_ac].* 
           LET g_lub_o.* = g_lub[l_ac].* 
           CALL t610_set_entry_lua23()
           CALL cl_show_fld_cont()
           NEXT FIELD lub02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
          #FUN-BB0117 Add&Mark Begin ---
          #INSERT INTO lub_file(lub01,lub02,lub03,lub04,lub04t,lub05,lub06,lubplant,lublegal)
          #VALUES(g_lua.lua01,g_lub[l_ac].lub02,g_lub[l_ac].lub03,
          #       g_lub[l_ac].lub04,g_lub[l_ac].lub04t,g_lub[l_ac].lub05,
          #       g_lua.lua19,g_lua.luaplant,g_lua.lualegal)
           INSERT INTO lub_file(lub01,lub02,lub03,lub04,lub04t,lub05,lub07,lub08,lub09,
                                lub10,lub11,lub12,lub13,lub14,lub15,lubplant,lublegal)
           VALUES(g_lua.lua01,g_lub[l_ac].lub02,g_lub[l_ac].lub03,g_lub[l_ac].lub04,
                  g_lub[l_ac].lub04t,g_lub[l_ac].lub05,g_lub[l_ac].lub07,g_lub[l_ac].lub08,
                  g_lub[l_ac].lub09,g_lub[l_ac].lub10,g_lub[l_ac].lub11,g_lub[l_ac].lub12,
                  g_lub[l_ac].lub13,g_lub[l_ac].lub14,g_lub[l_ac].lub15,g_lua.luaplant,g_lua.lualegal)
          #FUN-BB0117 Add&Mark End -----
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lub_file",g_lua.lua01,g_lub[l_ac].lub02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
       
        BEFORE FIELD lub02
           IF cl_null(g_lub[l_ac].lub02) THEN 
              SELECT max(lub02)+1 INTO g_lub[l_ac].lub02
                FROM lub_file
               WHERE lub01 = g_lua.lua01
              IF cl_null(g_lub[l_ac].lub02) THEN 
                 LET g_lub[l_ac].lub02 = 1
              END IF 
           END IF
        
        AFTER FIELD lub02 
           IF NOT cl_null(g_lub[l_ac].lub02) THEN
              IF g_lub[l_ac].lub02 != g_lub_t.lub02
                 OR g_lub_t.lub02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM lub_file
                  WHERE lub01 = g_lua.lua01
                    AND lub02 = g_lub[l_ac].lub02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lub[l_ac].lub02 = g_lub_t.lub02
                    NEXT FIELD lub02
                 END IF
              END IF
           END IF
 
        AFTER FIELD lub03 
           IF NOT cl_null(g_lub[l_ac].lub03) THEN
              CALL t610_lub03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lub[l_ac].lub03,g_errno,1)
                 LET g_lub[l_ac].lub03 = g_lub_t.lub03
                 NEXT FIELD lub03
              END IF
             #FUN-C30072 add begin ----
              CALL t610_chk_lua37_lub03()                       #直接交款费用类型不能是支出费用
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lub[l_ac].lub03,g_errno,0)
                 LET g_lub[l_ac].lub03 = g_lub_t.lub03
                 NEXT FIELD lub03
              END IF
              CALL t610_chk_lub03(p_cmd)                             #单身中支出费用不能与收入/预收同在
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lub[l_ac].lub03,g_errno,0)
                 LET g_lub[l_ac].lub03 = g_lub_t.lub03
                 NEXT FIELD lub03
              END IF
             #FUN-C30072 add end ---
             #FUN-BB0117 Add Begin ---
             #IF NOT cl_null(g_lua.lua04) THEN                       #TQC-C30265 Mark
              IF NOT cl_null(g_lua.lua04) AND g_lua.lua32 = '3' THEN #TQC-C30265 Add
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n
                   FROM lij_file 
                  WHERE lij02 = g_lub[l_ac].lub03
                    AND lij01 IN (SELECT lnt71 FROM lnt_file WHERE lnt01 = g_lua.lua04)
                 IF l_n = 0 THEN
                    CALL cl_err('','art-768',0)
                    LET g_lub[l_ac].lub03 = g_lub_t.lub03
                    NEXT FIELD lub03
                 END IF
              END IF
             #FUN-BB0117 Add End -----
           END IF
 
        AFTER FIELD lub04 
           IF NOT cl_null(g_lub[l_ac].lub04) THEN
              IF g_lub[l_ac].lub04 <= 0 THEN
                 CALL cl_err(g_lub[l_ac].lub04,'alm-719',1)
                 LET g_lub[l_ac].lub04 = g_lub_t.lub04
                 NEXT FIELD lub04
              ELSE 
                 CALL cl_digcut(g_lub[l_ac].lub04,g_azi04) RETURNING g_lub[l_ac].lub04 #FUN-BB0117 Add
                 LET g_lub[l_ac].lub04t = g_lub[l_ac].lub04 * (1+g_lua.lua22/100)
                 CALL cl_digcut(g_lub[l_ac].lub04t,g_azi04) RETURNING g_lub[l_ac].lub04t #FUN-BB0117 Add
              END IF
           END IF
 
        AFTER FIELD lub04t
           IF NOT cl_null(g_lub[l_ac].lub04t) THEN
              IF g_lub[l_ac].lub04t <= 0 THEN
                 CALL cl_err(g_lub[l_ac].lub04t,'alm-719',1)
                 LET g_lub[l_ac].lub04t = g_lub_t.lub04t
                 NEXT FIELD lub04t
              ELSE 
                 CALL cl_digcut(g_lub[l_ac].lub04t,g_azi04) RETURNING g_lub[l_ac].lub04t #FUN-BB0117 Add
                 LET g_lub[l_ac].lub04 = g_lub[l_ac].lub04t / (1+g_lua.lua22/100)
                 CALL cl_digcut(g_lub[l_ac].lub04,g_azi04) RETURNING g_lub[l_ac].lub04 #FUN-Bb0117 Add
              END IF
           END IF

       #FUN-BB0117 Add Begin ---
        #開始日期
        AFTER FIELD lub07
           IF NOT cl_null(g_lub[l_ac].lub07) THEN
              IF NOT cl_null(g_lub[l_ac].lub08) THEN
                 IF g_lub[l_ac].lub07 > g_lub[l_ac].lub08 THEN
                    CALL cl_err('','alm1038',0) #開始日期要小於等於結束日期
                    LET g_lub[l_ac].lub07 = g_lub_t.lub07
                    NEXT FIELD lub07
                 END IF
                 IF YEAR(g_lub[l_ac].lub07) <> YEAR(g_lub[l_ac].lub08) OR 
                    MONTH(g_lub[l_ac].lub07) <> MONTH(g_lub[l_ac].lub08) THEN
                    CALL cl_err('','art-767',0) #開始日期與結束日期的期別必須一致
                    LET g_lub[l_ac].lub07 = g_lub_t.lub07
                    NEXT FIELD lub07
                 END IF
              END IF
              CALL t610_get_lub10()
           END IF

        #結束日期
        AFTER FIELD lub08
           IF NOT cl_null(g_lub[l_ac].lub08) THEN
              IF NOT cl_null(g_lub[l_ac].lub07) THEN
                 IF g_lub[l_ac].lub07 > g_lub[l_ac].lub08 THEN
                    CALL cl_err('','alm1038',0) #開始日期要小於等於結束日期
                    LET g_lub[l_ac].lub08 = g_lub_t.lub08
                    NEXT FIELD lub08
                 END IF
                 IF YEAR(g_lub[l_ac].lub07) <> YEAR(g_lub[l_ac].lub08) OR 
                    MONTH(g_lub[l_ac].lub07) <> MONTH(g_lub[l_ac].lub08) THEN
                    CALL cl_err('','art-767',0) #開始日期與結束日期的期別必須一致
                    LET g_lub[l_ac].lub08 = g_lub_t.lub08
                    NEXT FIELD lub08
                 END IF
              END IF
           END IF

        #立帳日期
        AFTER FIELD lub10
           IF NOT cl_null(g_lub[l_ac].lub10) THEN
              IF NOT cl_null(g_lub[l_ac].lub07) THEN
                 IF g_lub[l_ac].lub10 < g_lub[l_ac].lub07 OR g_lub[l_ac].lub10 <= g_ooz.ooz09 THEN
                    CALL cl_err('','art-770',0)
                    NEXT FIELD lub10
                 END IF
              END IF
           END IF
       #FUN-BB0117 Add End -----
 
        BEFORE DELETE 
           DISPLAY "BEFORE DELETE"
           IF g_lub_t.lub02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lub_file
               WHERE lub01 = g_lua.lua01
                 AND lub02 = g_lub_t.lub02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lub_file",g_lua.lua01,g_lub_t.lub02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lub[l_ac].* = g_lub_t.*
              CLOSE t610_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lub[l_ac].lub02,-263,1)
              LET g_lub[l_ac].* = g_lub_t.*
           ELSE
              UPDATE lub_file SET lub02=g_lub[l_ac].lub02,
                                  lub03=g_lub[l_ac].lub03,
                                  lub04=g_lub[l_ac].lub04,
                                  lub04t=g_lub[l_ac].lub04t,
                                 #FUN-BB0117 Add Begin ---
                                  lub09=g_lub[l_ac].lub09,
                                  lub07=g_lub[l_ac].lub07,
                                  lub08=g_lub[l_ac].lub08,
                                  lub10=g_lub[l_ac].lub10,
                                 #FUN-BB0117 Add End -----
                                  lub05=g_lub[l_ac].lub05
               WHERE lub01=g_lua.lua01
                 AND lub02=g_lub_t.lub02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lub_file",g_lua.lua01,g_lub_t.lub02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_lub[l_ac].* = g_lub_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
          #FUN-BB0117 Add&Mark Begin ---
          #SELECT sum(lub04),SUM(lub04t) INTO g_lua.lua08,g_lua.lua08t
          #  FROM lub_file
          # WHERE lub01=g_lua.lua01
          #UPDATE lua_file set lua08 = g_lua.lua08,
          #                    lua08t = g_lua.lua08t
          # WHERE lua01=g_lua.lua01
          #DISPLAY BY NAME g_lua.lua08,g_lua.lua08t
          #匯總單身金額計算出當頭金額
           CALL t610_get_sum()
          #FUN-BB0117 Add&Mark End -----
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lub[l_ac].* = g_lub_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_lub.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t610_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t610_bcl
           COMMIT WORK
        
        ON ACTION CONTROLO
           IF INFIELD(lub02) AND l_ac > 1 THEN
              LET g_lub[l_ac].* = g_lub[l_ac-1].*
              LET g_lub[l_ac].lub02 = g_rec_b + 1
              NEXT FIELD lub02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(lub03)
               CALL cl_init_qry_var()
              #LET g_qryparam.form ="q_oaj2" #FUN-BB0117 Mark
               #LET g_qryparam.form ="q_oaj1" #FUN-BB0117 Add #TQC-C30290 mark
               LET g_qryparam.form = "q_oaj11"  #TQC-C30290 add
               #TQC-C30340--start add-------------------------------------
               IF NOT cl_null(g_lua.lua04) AND g_lua.lua32 = '3' THEN
                  LET g_qryparam.where = " oaj01 IN (SELECT lij02 FROM lij_file,lnt_file WHERE lnt01 = '",g_lua.lua04,"' AND lij01 = lnt71) "
               END IF
               #TQC-C30340--end add---------------------------------------
               LET g_qryparam.arg1 = g_aza.aza81
              #LET g_qryparam.arg2 = g_lua.lua02 #FUN-BB0117 Mark
               LET g_qryparam.default1 = g_lub[l_ac].lub03
               CALL cl_create_qry() RETURNING g_lub[l_ac].lub03
               DISPLAY BY NAME g_lub[l_ac].lub03
               CALL t610_lub03('d')
               NEXT FIELD lub03
               OTHERWISE EXIT CASE
            END CASE
 
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
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    IF p_c="u" THEN
       LET g_lua.luamodu = g_user
       LET g_lua.luadate = g_today
       LET g_lua.lua14 = '0'
       UPDATE lua_file SET luamodu = g_lua.luamodu,luadate = g_lua.luadate,
                           lua14 = '0'
        WHERE lua01 = g_lua.lua01
   #    DISPLAY BY NAME g_lua.luamodu,g_lua.luadate,g_lua.lua14      #TQC-AB0369 mark
       DISPLAY BY NAME g_lua.luamodu,g_lua.luadate                   #TQC-AB0369
    END IF
 
    CLOSE t610_bcl
    COMMIT WORK
    
#CHI-C30002 -------- mark -------- begin
#   SELECT COUNT(*) INTO g_cnt FROM lub_file
#    WHERE lub01 = g_lua.lua01 
#   IF g_cnt = 0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM lua_file WHERE lua01 = g_lua.lua01
#   END IF
#CHI-C30002 -------- mark -------- end
    CALL t610_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t610_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM lua_file WHERE lua01 = g_lua.lua01
         INITIALIZE g_lua.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t610_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lua.lua01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lua.* FROM lua_file
    WHERE lua01=g_lua.lua01
   
   IF g_lua.lua15='X' THEN
      CALL cl_err('','9024',0) 
      RETURN 
   END IF
   
   IF g_lua.lua15='Y' THEN
      CALL cl_err('','9023',0) 
      RETURN 
   END IF
    
   IF g_lua.lua14 MATCHES '[Ss1]' THEN
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t610_cl INTO g_lua.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL t610_show()
   IF cl_exp(0,0,g_lua.luaacti) THEN
      LET g_chr=g_lua.luaacti
      IF g_lua.luaacti='Y' THEN
         LET g_lua.luaacti='N'
      ELSE
         LET g_lua.luaacti='Y'
      END IF
 
      UPDATE lua_file SET luaacti=g_lua.luaacti,
                          luamodu=g_user,
                          luadate=g_today
       WHERE lua01=g_lua.lua01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lua_file",g_lua.lua01,"",SQLCA.sqlcode,"","",1)
         LET g_lua.luaacti=g_chr
      END IF
   END IF
   CLOSE t610_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lua.lua01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT luaacti,luamodu,luadate
     INTO g_lua.luaacti,g_lua.luamodu,g_lua.luadate FROM lua_file
    WHERE lua01 = g_lua.lua01
   DISPLAY BY NAME g_lua.luaacti,g_lua.luamodu,g_lua.luadate
   CALL t610_field_pic()
END FUNCTION
 
#FUN-BB0117 Mark Begin ---
#FUNCTION t610_y()       
#DEFINE l_n       LIKE type_file.num5
#DEFINE l_lub04t  LIKE lub_file.lub04t #FUN-BB0117 Add
#DEFINE l_rxx04   LIKE rxx_file.rxx04  #FUN-BB0117 Add
#
#   IF cl_null(g_lua.lua01) THEN 
#        CALL cl_err('','-400',0) 
#        RETURN 
#   END IF
#   
#   SELECT * INTO g_lua.* FROM lua_file
#    WHERE lua01=g_lua.lua01
#      
#   IF g_lua.luaacti='N' THEN       #
#        CALL cl_err('','alm-048',0)
#        RETURN
#   END IF
#   
#   IF g_lua.lua15='Y' THEN #眒机瞄
#        CALL cl_err('','9023',0)
#        RETURN
#   END IF
#   
#   IF g_lua.lua15='X' THEN #眒釬煙
#        CALL cl_err('','9024',0)
#        RETURN
#   END IF
#   
#   #TQC-AC0138 add begin--------
#   IF g_rec_b = 0 THEN    #單身無資料
#      CALL cl_err('','atm-228',0)
#      RETURN
#   END IF
#   #TQC-AC0138 add end----------
##FUN-B50007 --------------STA
#   IF g_lua.lua32 = '4' AND g_lua.lua09 <= g_rcj.rcj01 THEN
#       CALL cl_err('','art-829',0)
#      RETURN
#   END IF
##FUN-B50007 --------------END
#
#   IF NOT cl_confirm('alm-006') THEN 
#      RETURN
#   END IF
# 
#   CALL s_showmsg_init()
#   CALL t610_y1()
#   
##FUN-A80105--begin--
##  CALL t610_y2()
#   IF NOT t610_own(g_lua.lua06) THEN
#      CALL t610_y2()
#   END IF
##FUN-A80105--end--
#   MESSAGE ""  #FUN-B90056 Add
#END FUNCTION
#FUN-BB0117 Mark End -----
 
#FUN-BB0117 Add Begin ---
FUNCTION t610_y()
DEFINE l_n       LIKE type_file.num5
DEFINE l_lub04t  LIKE lub_file.lub04t
DEFINE l_rxx04   LIKE rxx_file.rxx04
DEFINE l_lua14   LIKE lua_file.lua14

   IF cl_null(g_lua.lua01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF

#CHI-C30107 ----------------- add ----------------- begin
   IF g_lua.luaacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_lua.lua14 = '2' THEN
      CALL cl_err('','axr-369',0)
      RETURN
   END IF

   IF g_lua.lua15='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_lua.lua15='X' THEN
        CALL cl_err('','9024',0)
        RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
      RETURN
   END IF
#CHI-C30107 ----------------- add ----------------- end
   SELECT * INTO g_lua.* FROM lua_file
    WHERE lua01=g_lua.lua01

   IF g_lua.luaacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_lua.lua14 = '2' THEN
      CALL cl_err('','axr-369',0)
      RETURN
   END IF

   IF g_lua.lua15='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_lua.lua15='X' THEN
        CALL cl_err('','9024',0)
        RETURN
   END IF

   IF g_rec_b = 0 THEN    #單身無資料
      CALL cl_err('','atm-228',0)
      RETURN
   END IF

   IF g_lua.lua32 = '4' AND g_lua.lua09 <= g_rcj.rcj01 THEN
      CALL cl_err('','art-829',0)
      RETURN
   END IF

   #直接收款 = 'Y'，需要全部付清才允許確認
   IF g_lua.lua37 = 'Y' THEN
      SELECT SUM(lub04t-lub12) INTO l_lub04t FROM lub_file WHERE lub01 = g_lua.lua01
      IF SQLCA.sqlcode = 100 THEN LET l_lub04t = NULL END IF
      IF cl_null(l_lub04t) THEN LET l_lub04t = 0 END IF
      CALL cl_digcut(l_lub04t,g_azi04) RETURNING l_lub04t
      SELECT SUM(rxx04) INTO l_rxx04
        FROM rxx_file
       WHERE rxx00 = '07' AND rxx01 = g_lua.lua01 AND rxxplant = g_lua.luaplant
      IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
      IF l_rxx04 < l_lub04t THEN
         CALL cl_err('','art-760',0) #直接收款 = 'Y'，需要全部付清才允許確認
         RETURN
      END IF
   END IF

#CHI-C30107 ------------- mark -------------- begin
#  IF NOT cl_confirm('alm-006') THEN
#     RETURN
#  END IF
#CHI-C30107 ------------- mark -------------- end

   CALL s_showmsg_init()
   LET g_success = 'Y'

   BEGIN WORK
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_lua.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF

   #若為內部商戶,確認之後更新狀況碼為2.結案,反之按標準處理
   IF g_lua.lua05 = 'Y' THEN
      LET l_lua14 = '2'
   ELSE
      LET l_lua14 = '1'
   END IF

   UPDATE lua_file SET lua14 = l_lua14,lua15 = 'Y',lua16 = g_user,lua17 = g_today   
    WHERE lua01 = g_lua.lua01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lua_file",g_lua.lua01,"",STATUS,"","",1)
      LET g_success = 'N'
   END IF

   #如果直接收款 = 'Y'
   IF g_lua.lua37 = 'Y' THEN
      #TQC-C20525--start add---------------------------
      UPDATE lua_file
         SET lua14 = '2' 
       WHERE lua01 = g_lua.lua01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lua_file",g_lua.lua01,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF 
      LET l_lua14 = '2'   
   
      UPDATE lub_file
         SET lub13 = 'Y'
       WHERE lub01 = g_lua.lua01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lub_file",g_lua.lua01,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   
      #TQC-C20525--end add-----------------------------
 
      CALL t610_ins_luiluj() #產生交款單
      CALL t610_cp_rxxyz()   #複製對應的收款信息
      CALL t610_ins_luklul() #產生待抵單
   END IF

   #若为内部商户,且资料来源为5.百货卖场合同费用,则结案费用单的同时将费用单对应的账单结案
   IF g_lua.lua05 = 'Y' AND g_lua.lua11 = '5' THEN
      UPDATE liw_file SET liw17 = 'Y'
       WHERE liw16 = g_lua.lua01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('liw16',g_lua.lua01,'upd liw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lua.lua14 = l_lua14
      LET g_lua.lua15 = 'Y'
      LET g_lua.lua16 = g_user
      LET g_lua.lua17 = g_today
      DISPLAY BY NAME g_lua.lua14,g_lua.lua15,g_lua.lua16,g_lua.lua17
      CALL t610_show()
      CALL t610_field_pic()
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
   END IF

   MESSAGE ""
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Mark Begin ---
#FUNCTION t610_z()
#DEFINE l_n   LIKE type_file.num5 #FUN-BB0117 Add
# 
#   LET g_success = 'Y'
#   IF cl_null(g_lua.lua01) THEN 
#        CALL cl_err('','-400',0) 
#        RETURN 
#   END IF
#   
#   SELECT * INTO g_lua.* FROM lua_file
#    WHERE lua01=g_lua.lua01
#   
#   IF g_lua.luaacti='N' THEN
#        CALL cl_err('','alm-048',0)
#        RETURN
#   END IF
#   
#   IF g_lua.lua15='X' THEN 
#        CALL cl_err('','9024',0)
#        RETURN
#   END IF
#   
#   IF g_lua.lua15='N' THEN 
#        CALL cl_err('','9025',0)
#        RETURN
#   END IF
##FUN-B50007 -------------STA
#   IF g_lua.lua32 = '4' AND g_rcj.rcj01 >= g_lua.lua09 THEN
#      CALL cl_err('','art-829',0)
#      RETURN
#   END IF
##FUN-B50007 -------------END
#
#  IF NOT t610_own(g_lua.lua06) THEN  #No.FUN-A80105 Add
#     CALL t610_z_chk() 
#     IF g_success = 'N' THEN RETURN END IF
#  END IF                             #No.FUN-A80105 Add
#   IF NOT cl_confirm('alm-008') THEN 
#      RETURN
#   END IF
#  IF NOT t610_own(g_lua.lua06) THEN  #No.FUN-A80105 Add
#     CALL t610_z2()   
#  END IF                             #No.FUN-A80105 Add
#   CALL t610_z1()  
#END FUNCTION
#FUN-BB0117 Mark End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_z()
DEFINE l_n   LIKE type_file.num5 

   LET g_success = 'Y'
   IF cl_null(g_lua.lua01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF

   SELECT * INTO g_lua.* FROM lua_file
    WHERE lua01=g_lua.lua01

   IF g_lua.luaacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   #IF g_lua.lua14 = '2' THEN    #TQC-C20525 mark
   IF g_lua.lua14 = '2' AND g_lua.lua37 <> 'Y' THEN   #TQC-C20525 add     
      CALL cl_err('','axr-369',0)
      RETURN
   END IF

   IF g_lua.lua15='X' THEN
        CALL cl_err('','9024',0)
        RETURN
   END IF

   IF g_lua.lua15='N' THEN
        CALL cl_err('','9025',0)
        RETURN
   END IF

   IF g_lua.lua32 = '4' AND g_rcj.rcj01 >= g_lua.lua09 THEN
      CALL cl_err('','art-829',0)
      RETURN
   END IF

   IF g_lua.lua37 = 'Y' THEN
      SELECT COUNT(*) INTO l_n
        FROM lub_file
       WHERE lub01 = g_lua.lua01 AND lub14 IS NOT NULL
      IF l_n > 0 THEN
         CALL cl_err('','art-135',0)  #直接收款且財務單號不為空，不允許取消確認
         RETURN
      END IF
      SELECT COUNT(*) INTO l_n
        FROM lul_file
       WHERE lul03 IN(SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
         AND (lul07 > 0 OR lul08 > 0)
      IF l_n > 0 THEN
         CALL cl_err('','art-136',0) #直接收款，存在待抵單，且已沖金額或已退金額不為0，不允取消確認
         RETURN
      END IF
      SELECT COUNT(*) INTO l_n
        FROM lup_file
       WHERE lup03 = g_lua.lua01 AND lup07 > 0
      IF l_n > 0 THEN
         CALL cl_err('','art-137',0) #直接收款，存在支出單，且已退金額不為0，不允許取消確認
         RETURN
      END IF
   ELSE
      SELECT COUNT(*) INTO l_n
        FROM luj_file
       WHERE luj03 = g_lua.lua01
      IF l_n > 0 THEN
         CALL cl_err('','art-648',0) #非直接收款，存在交款單，不允許取消確認
         RETURN
      END IF
   END IF

   IF NOT cl_confirm('alm-008') THEN
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      LET g_success='N'
   END IF

   FETCH t610_cl INTO g_lua.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      CLOSE t610_cl
      LET g_success='N'
   END IF

   UPDATE lua_file SET lua15 = 'N',
                      #lua16 = '',     #CHI-D20015
                      #lua17 = '',     #CHI-D20015
                       lua16 = g_user, #CHI-D20015
                       lua17 = g_today, #CHI-D20015
                       lua14 = '0'   
    WHERE lua01 = g_lua.lua01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lua_file",g_lua.lua01,"",STATUS,"","",1)
      LET g_success = 'N'
   END IF

   #TQC-C20525--start add-----------------------------------
   IF g_lua.lua37 = 'Y' THEN 
      UPDATE lub_file
         SET lub13 = 'N'
       WHERE lub01 = g_lua.lua01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lub_file",g_lua.lua01,"",SQLCA.sqlcode,"","lub",1)
         LET g_success = 'N'
      END IF
   END IF 
   #TQC-C20525--end add-------------------------------------
  

   IF g_lua.lua32 <> '4' THEN
     #刪除對應的交款單、待抵單、支出單
      DELETE FROM rxx_file WHERE rxx01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM rxy_file WHERE rxy01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM rxz_file WHERE rxz01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM lul_file WHERE lul01 IN (SELECT luk01 FROM luk_file WHERE luk05 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01))
      DELETE FROM luk_file WHERE luk05 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM lup_file WHERE lup01 IN (SELECT luo01 FROM luo_file WHERE luo04 = g_lua.lua01)
      DELETE FROM luo_file WHERE luo04 = g_lua.lua01
      DELETE FROM luj_file WHERE luj01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM lui_file WHERE lui04 = g_lua.lua01
   END IF

   IF g_success = 'Y' THEN
      LET g_lua.lua14 = '0'
      LET g_lua.lua15 = 'N'
     #LET g_lua.lua16 = ''       #CHI-D20015
     #LET g_lua.lua17 = ''       #CHI-D20015
      LET g_lua.lua16 = g_user       #CHI-D20015
      LET g_lua.lua17 = g_today       #CHI-D20015
      DISPLAY BY NAME g_lua.lua14,g_lua.lua15,g_lua.lua16,g_lua.lua17
      CALL t610_show()
      CALL t610_field_pic()
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#FUN-BB0117 Add End -----
 
#TQC-B10002 ------------------mark
#FUNCTION t610_ef()                  #送簽
#  IF cl_null(g_lua.lua01) THEN 
#     CALL cl_err('','-400',0) 
#     RETURN 
#  END IF
#  
#  SELECT * INTO g_lua.* FROM lua_file
#   WHERE lua01=g_lua.lua01
#  
#  IF g_lua.luaacti='N' THEN
#     CALL cl_err('','alm-131',0)
#     RETURN
#  END IF
#  
#  IF g_lua.lua15='X' THEN          #已作廢
#     CALL cl_err('','9024',0)
#     RETURN
#  END IF
#  
#  IF g_lua.lua14 MATCHES '[Ss1]' THEN  #已簽核或送簽中
#     CALL cl_err('','mfg3557',0)
#     RETURN
#  END IF
# 
#  IF g_lua.lua13='N' THEN              #不需送簽
#     CALL cl_err('','mfg3549',0)
#     RETURN
#  END IF
#
#  IF g_success = "N" THEN
#     RETURN
#  END IF
#
#  CALL aws_condition()      #瓚剿冞訧蹋
#  IF g_success = 'N' THEN
#     RETURN
#  END IF
#
###########
## CALL aws_efcli2()
## 換杅: (1)等芛訧蹋, (2-6)等旯訧蹋料
## 隙換硉  : 0 羲等囮啖; 1 羲等傖髡功
###########
#
#  IF aws_efcli2(base.TypeInfo.create(g_lua),base.TypeInfo.create(g_lub),'','','','')
#  THEN
#      LET g_success = 'Y'
#      LET g_lua.lua14 = 'S' 
# #     DISPLAY BY NAME g_lua.lua14              #TQC-AB0369   mark
#  ELSE
#      LET g_success = 'N'
#  END IF
#END FUNCTION
#TQC-B10002  --------------------mark

FUNCTION t610_v()             #作廢/取消作廢
   IF g_lua.lua01 IS NULL THEN
      CALL cl_err('','-400',0)
      RETURN 
   END IF
   
   SELECT * INTO g_lua.* FROM lua_file
    WHERE lua01=g_lua.lua01
      
   IF g_lua.lua15='Y' THEN CALL cl_err('','9023',0) RETURN END IF   
   IF g_lua.luaacti='N' THEN CALL cl_err('','alm-004',0) RETURN END IF
   IF g_lua.lua14 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y' 
 
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t610_cl INTO g_lua.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0) 
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_lua.lua15) THEN
      IF g_lua.lua15 ='N' THEN
         LET g_lua.lua15='X'
      ELSE
         LET g_lua.lua15='N'
         LET g_lua.lua14='0'
      END IF
      UPDATE lua_file SET
             lua15=g_lua.lua15,
             luamodu=g_user,
             luadate=g_today,
             lua14 =g_lua.lua14
       WHERE lua01=g_lua.lua01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","lua_file",g_lua.lua01,"","apm-266","","upd lua_file",1)
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lua.lua01,'V')
      DISPLAY BY NAME g_lua.lua15
 #     DISPLAY BY NAME g_lua.lua14                        #TQC-AB0369 mark
      CALL t610_field_pic()
   ELSE
      LET g_lua.lua15= g_lua_t.lua15
      LET g_lua.lua14 = g_lua_t.lua14
      DISPLAY BY NAME g_lua.lua15
 #     DISPLAY BY NAME g_lua.lua14                        #TQC-AB0369 mark
      ROLLBACK WORK
   END IF
 
   SELECT lua15,luamodu,luadate
   INTO g_lua.lua15,g_lua.luamodu,g_lua.luadate FROM lua_file
    WHERE lua01=g_lua.lua01 
 
    DISPLAY BY NAME g_lua.lua15,g_lua.luamodu,g_lua.luadate
    CALL t610_field_pic()
END FUNCTION
 
FUNCTION t610_r()
DEFINE l_rxx04  LIKE rxx_file.rxx04
DEFINE l_sql    STRING
DEFINE l_rxy06  LIKE rxy_file.rxy06
DEFINE l_rxy32  LIKE rxy_file.rxy32
DEFINE l_rxy05  LIKE rxy_file.rxy05
DEFINE l_lul07  LIKE lul_file.lul07
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lua.lua01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lua.* FROM lua_file
    WHERE lua01=g_lua.lua01
   IF g_lua.luaacti ='N' THEN    
      CALL cl_err(g_lua.lua01,'mfg1000',0)
      RETURN
   END IF

   IF g_lua.lua14 = '2' THEN
      CALL cl_err('','axr-369',0)
      RETURN
   END IF
  
   IF g_lua.lua15 ='Y' THEN    
      CALL cl_err(g_lua.lua01,'9023',0)
      RETURN
   END IF
 
   IF g_lua.lua14 MATCHES '[Ss1]' THEN
      CALL cl_err(g_lua.lua01,'mfg3557',0)
      RETURN
   END IF   
 
   IF g_lua.lua15 ='X' THEN    
      CALL cl_err(g_lua.lua01,'9024',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t610_cl INTO g_lua.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t610_show()
   IF cl_delh(0,0) THEN 
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "lua01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_lua.lua01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
     #FUN-BB0117 Add Begin ---
     #若存在待抵單交款，則更新待抵單
      SELECT rxx04 INTO l_rxx04 FROM rxx_file
       WHERE rxx02 = '07' AND rxx00 = '07'
         AND rxx01 = g_lua.lua01 AND rxxplant = g_lua.luaplant
      IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF

      IF l_rxx04 > 0 THEN
         LET l_sql = "SELECT rxy06,rxy32,rxy05 ",
                     "  FROM rxy_file ",
                     " WHERE rxy00 = '07' AND rxy01 = '",g_lua.lua01, "' ",
                     "   AND rxy03 = '07' AND rxyplant = '",g_lua.luaplant,"' ",
                     "   AND rxy19 = '3' "
         PREPARE sel_rxy_pre2 FROM l_sql
         DECLARE sel_rxy_cs2 CURSOR FOR sel_rxy_pre2
         FOREACH sel_rxy_cs2 INTO l_rxy06,l_rxy32,l_rxy05
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            UPDATE lul_file SET lul07 = COALESCE(lul07,0) - l_rxy05
             WHERE lul01 = l_rxy06 AND lul02 = l_rxy32
            SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = l_rxy06
            UPDATE luk_file SET luk11 = l_lul07
             WHERE luk01 = l_rxy06
         END FOREACH
      END IF
     #FUN-BB0117 Add End -----
      DELETE FROM lua_file WHERE lua01=g_lua.lua01
      DELETE FROM lub_file WHERE lub01=g_lua.lua01
      DELETE FROM rxx_file WHERE rxx01=g_lua.lua01      #TQC-B20160
      DELETE FROM rxy_file WHERE rxy01=g_lua.lua01      #TQC-B20160      
      DELETE FROM rxz_file WHERE rxz01=g_lua.lua01      #FUN-BB0117 Add
     #FUN-BB0117 Add Begin ---
     #來源類型不為0.手動錄入，刪除后需清空來源單據的費用單信息
      IF g_lua.lua11 <> '0' THEN
         CASE g_lua.lua11
            WHEN '1' #採購合同費用
            WHEN '2' #促銷費用
            WHEN '3' #攤位意向協議
               IF NOT cl_null(g_lua.lua12) THEN
                  UPDATE lig_file SET lig11 = NULL
                   WHERE lig01 = g_lua.lua12
               END IF
            WHEN '4' #攤位預租協議
               IF NOT cl_null(g_lua.lua12) THEN
                  UPDATE lih_file SET lih12 = NULL
                   WHERE lih01 = g_lua.lua12
               END IF
            WHEN '5' #百貨賣場合同費用
               IF NOT cl_null(g_lua.lua12) THEN
                  IF NOT cl_null(g_lua.lua33) AND NOT cl_null(g_lua.lua34) THEN
                     UPDATE liw_file SET liw16 = NULL
                      WHERE liw05 = g_lua.lua33 AND liw06 = g_lua.lua34 AND liw16 = g_lua.lua01 AND liw01 = g_lua.lua12
                  END IF
               END IF
            WHEN '6' #廣告位合同費用
               #FUN-C30137--start add---------------------------------------------------
               IF NOT cl_null(g_lua.lua12) THEN
                  UPDATE lsc_file
                     SET lsc23 = NULL
                   WHERE lsc01 = g_lua.lua12
               END IF  
               #FUN-C30137--end add-----------------------------------------------------
         END CASE
      END IF
     #FUN-BB0117 Add End -----
      CLEAR FORM
      CALL g_lub.clear()
      OPEN t610_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t610_cl
         CLOSE t610_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t610_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t610_cl
         CLOSE t610_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t610_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t610_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      
         CALL t610_fetch('/')
      END IF
   END IF
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lua.lua01,'D')
END FUNCTION
 
FUNCTION t610_copy()
 DEFINE l_newno    LIKE lua_file.lua01,
        l_oldno    LIKE lua_file.lua01,
        p_cmd      LIKE type_file.chr1,
        l_n        LIKE type_file.num5,
        l_input    LIKE type_file.chr1 
 DEFINE li_result  LIKE type_file.num5
 
    IF g_lua.lua01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL t610_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM lua01
        BEFORE INPUT
            CALL cl_set_docno_format("lua01")
 
        AFTER FIELD lua01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(l_newno) THEN
#           CALL s_check_no("alm",l_newno,'','01',"lua_file","lua01","")  #FUN-A80105--mark--
            CALL s_check_no("art",l_newno,'','B9',"lua_file","lua01","")  #FUN-A80105--mod--
                 RETURNING li_result,l_newno
            IF (NOT li_result) THEN
               NEXT FIELD lua01
            END IF
            DISPLAY l_newno TO lua01
         END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lua01)
                 LET g_t1=s_get_doc_no(l_newno)
              #  CALL q_lrk(FALSE,FALSE,g_t1,'01','ALM') RETURNING g_t1       #FUN-A70130 mark
                 CALL q_oay(FALSE,FALSE,g_t1,'B9','ART') RETURNING g_t1       #FUN-A70130 add
                 LET l_newno = g_t1
                 DISPLAY l_newno TO lua01
                 NEXT FIELD lua01
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
        DISPLAY BY NAME g_lua.lua01
        RETURN
    END IF
 
    #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
#   CALL s_auto_assign_no("alm",l_newno,g_today,'01',"lua_file","lua01","","","")   #FUN-A80105--mark--
    #CALL s_auto_assign_no("art",l_newno,g_today,'B9',"lua_file","lua01","","","")   #FUN-A80105--mod--   #TQC-C20261 mark
    CALL s_auto_assign_no("art",l_newno,g_lua.lua09,'B9',"lua_file","lua01","","","")    #TQC-C20261  add
       RETURNING li_result,l_newno
    IF (NOT li_result) THEN
       RETURN 
    END IF    
    DISPLAY l_newno TO lua01   
 
    DROP TABLE y
    SELECT * FROM lua_file  
        WHERE lua01=g_lua.lua01
        INTO TEMP y
    UPDATE y
        SET lua01=l_newno,
            luaplant = g_plant,
            lualegal = g_legal,
           #lua19 = g_plant, #FUN-BB0117 Mark
            lua09 = g_today,
            lua10 = 'N',
            lua11 = '0', #FUN-BB0117 Mod 0.手動錄入
            lua12 = '',
           #lua13 = 'N', #FUN-BB0117 Mark
            lua14 = '0',
            lua15 = 'N',
            lua16='',
            lua17='',
           #FUN-BB0117 Add Begin ---
            lua33 = '',
            lua34 = '',
            lua35 = 0,
            lua36 = 0,
           #FUN-BB0117 Add ENd -----
            luaacti='Y', 
            luauser=g_user,
            luagrup=g_grup, 
            luamodu=NULL,  
            luadate=g_today,
            luacrat=g_today
      
    INSERT INTO lua_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lua_file",g_lua.lua01,"",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    
    DROP TABLE x
    SELECT * FROM lub_file WHERE lub01 = g_lua.lua01
                       INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET lub01 = l_newno,lubplant=g_plant,lublegal=g_legal,     #FUN-BB0117 Add ,
                 lub11 = 0,lub12 = 0,lub13 = 'N',lub14 = '',lub15 = ''  #FUN-BB0117 Add
    
    INSERT INTO lub_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
       CALL cl_err3("ins","lub_file","","",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK          #FUN-B80085--add--
       RETURN
    ELSE 
       COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE'(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
    
    LET l_oldno = g_lua.lua01
    LET g_lua.lua01 = l_newno
    SELECT lua_file.* INTO g_lua.* FROM lua_file
     WHERE lua01 = l_newno
    CALL t610_show()
    CALL t610_u()
    CALL t610_b("a")
    UPDATE lua_file SET luadate=NULL,luamodu=NULL 
                    WHERE lua01 = l_newno
    #SELECT lua_file.* INTO g_lua.* FROM lua_file  #FUN-C80046
    # WHERE lua01 = l_oldno  #FUN-C80046
    #CALL t610_show()        #FUN-C80046
END FUNCTION
 
FUNCTION t610_b_fill(p_wc2)
   DEFINE p_wc2   STRING
#FUN-C10024--add--str--
   DEFINE l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--
#  LET g_sql = "SELECT lub02,lub03,'','','','','','','','',lub04,lub04t,lub05 ",   #FUN-A80105--mark--
  #LET g_sql = "SELECT lub02,lub03,'','','','','','','',lub04,lub04t,lub05 ",   #FUN-A80105--mod-- #FUN-BB0117 Mark
   LET g_sql = "SELECT lub02,lub03,'','','',lub09,lub07,lub08,lub10,lub04,lub04t, ", #FUN-BB0117 Add
               "       lub11,'',lub12,'','','','',lub13,lub14,lub15,lub05,lub16 ",   #FUN-BB0117 Add
               " FROM lub_file",
               " WHERE lub01 ='",g_lua.lua01,"' "
  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lub02 "
   DISPLAY g_sql
   PREPARE t610_pb FROM g_sql
   DECLARE lub_cs CURSOR FOR t610_pb
   CALL g_lub.clear()
   LET g_cnt = 1
    CALL s_get_bookno(YEAR(g_lua.lua09)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
   FOREACH lub_cs INTO g_lub[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
#       SELECT oaj02,oaj031,oaj04,oaj041,oaj06     #FUN-A80105
#         INTO g_lub[g_cnt].oaj02,g_lub[g_cnt].oaj031,g_lub[g_cnt].oaj04,g_lub[g_cnt].oaj041,g_lub[g_cnt].oaj06  #FUN-A80105
       SELECT oaj02,oaj031,oaj04,oaj041            #FUN-A80105
         INTO g_lub[g_cnt].oaj02,g_lub[g_cnt].oaj031,g_lub[g_cnt].oaj04,g_lub[g_cnt].oaj041       #FUN-A80105
        FROM oaj_file
       WHERE oaj01=g_lub[g_cnt].lub03
        #AND oaj05=g_lua.lua02 #FUN-BB0117 Mark
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","oaj_file",g_lub[g_cnt].lub03,"",SQLCA.sqlcode,"","",0)
          LET g_lub[g_cnt].oaj02 = NULL
          LET g_lub[g_cnt].oaj031 = NULL
          LET g_lub[g_cnt].oaj04 = NULL
          LET g_lub[g_cnt].oaj041 = NULL
#          LET g_lub[g_cnt].oaj06 = NULL      #FUN-A80105
       END IF
       
       SELECT lnj02 INTO g_lub[g_cnt].lnj02 FROM lnj_file
        WHERE lnj01=g_lub[g_cnt].oaj031
       IF SQLCA.sqlcode THEN
       #  CALL cl_err3("sel","lnj_file",g_lub[g_cnt].lub03,"",SQLCA.sqlcode,"","",0)  #No.TQC-AB0013
          CALL cl_err3("sel","lnj_file",g_lub[g_cnt].oaj031,"",SQLCA.sqlcode,"","",0)  #No.TQC-AB0013
          LET g_lub[g_cnt].lnj02 = NULL
       END IF
       SELECT aag02 INTO g_lub[g_cnt].aag02 FROM aag_file
        WHERE aag01=g_lub[g_cnt].oaj04
          #AND aag00=g_aza.aza81    #FUN-C10024
          AND aag00 =l_bookno1   #FUN-C10024 add
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","aag_file",g_lub[g_cnt].oaj04,"",SQLCA.sqlcode,"","",0)
          LET g_lub[g_cnt].aag02 = NULL
       END IF
      
       SELECT aag02 INTO g_lub[g_cnt].aag02_1 FROM aag_file
        WHERE aag01=g_lub[g_cnt].oaj041
          #AND aag00=g_aza.aza81   #FUN-C10024
          AND aag00 =l_bookno2  #FUN-C10024 add

      #FUN-BB0117 Add Begin ---
       LET g_lub[g_cnt].amt_2 = g_lub[g_cnt].lub04t - g_lub[g_cnt].lub11 - g_lub[g_cnt].lub12
      #FUN-BB0117 Add End -----
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lub.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t610_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lua01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t610_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lua01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t610_set_entry_lua04()
     IF g_lua.lua04 IS NULL THEN
#       CALL cl_set_comp_entry("lua05,lua06,lua061,lua07",TRUE)   #FUN-A80105--mark--
#       CALL cl_set_comp_entry("lua05,lua06,lua07",TRUE)          #FUN-A80105--mod--      #FUN-AC0062
        CALL cl_set_comp_entry("lua06,lua07",TRUE)                #FUN-AC0062
        IF g_lua.lua32='0' THEN
           CALL cl_set_comp_entry("lua07",FALSE)
        END IF
     ELSE
#       CALL cl_set_comp_entry("lua05,lua06,lua061,lua07",FALSE)  #FUN-A80105--mark--
        CALL cl_set_comp_entry("lua06,lua061,lua07",FALSE)        #FUN-A80105--mod--          
     END IF
END FUNCTION
 
FUNCTION t610_set_entry_lua23()
   IF g_lua.lua23 = 'N' THEN
      CALL cl_set_comp_entry("lub04",TRUE)
      CALL cl_set_comp_entry("lub04t",FALSE)
   ELSE
      CALL cl_set_comp_entry("lub04t",TRUE)
      CALL cl_set_comp_entry("lub04",FALSE)
   END IF
END FUNCTION
 
FUNCTION t610_z1()
DEFINE l_amt1 LIKE type_file.num5,
       l_amt2 LIKE type_file.num5,
       l_oob RECORD LIKE oob_file.*,
       l_sum  LIKE type_file.num5,
       l_cnt  LIKE type_file.num5,
       l_t1    LIKE type_file.chr20,
       l_dbs   LIKE type_file.chr10,
       l_aba19 LIKE aba_file.aba19
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t610_cl USING g_lua.lua01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      LET g_success='N'
   END IF
 
   FETCH t610_cl INTO g_lua.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)      
      CLOSE t610_cl
      LET g_success='N'
   END IF
   
   UPDATE lua_file SET lua15 = 'N',lua16 = '',lua17 = '',lua14 = '0' #FUN-BB0117 Add lua14
                      #lua24 = ''  #FUN-BB0117 Mark
    WHERE lua01 = g_lua.lua01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lua_file",g_lua.lua01,"",STATUS,"","",1) 
      LET g_success = 'N'
   END IF
   
   IF NOT t610_own(g_lua.lua06) THEN  #No.FUN-A80105 Add
      IF g_lua.lua32 <> '4' THEN
     #FUN-BB0117 Mark Begin ---
     #IF g_lua.lua02='01' THEN
     #   DELETE FROM oma_file 
     #   WHERE oma01 IN
     #    (SELECT oma19 FROM oma_file WHERE oma16=g_lua.lua01 AND oma66=g_lua.luaplant and oma00='15')
     #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                               
     #      CALL cl_err3("del","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","del oma",1)                                                 
     #      LET g_success = 'N'                                                                                                        
     #   END IF 
     #   DELETE FROM omc_file 
     #    WHERE omc01 IN(SELECT oma19 FROM oma_file WHERE oma16=g_lua.lua01 AND oma66=g_lua.luaplant and oma00='15')
     #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                  
     #      CALL cl_err3("del","omc_file",g_omc.omc01,"",SQLCA.sqlcode,"","del omc",1)                                                  
     #      LET g_success = 'N'                                                                                                         
     #   END IF  
     #END IF
     #FUN-BB0117 Mark End -----
      DELETE FROM npp_file 
        WHERE npp01 = g_oma.oma01 AND npp011=1 AND nppsys='AR' AND npp00=2 #dongbg modify
      DELETE FROM npq_file 
        WHERE npq01 = g_oma.oma01 AND npq011=1 AND npqsys='AR' AND npq00=2   #dongbg modify
      #FUN-B40056 --Begin
      DELETE FROM tic_file
       WHERE tic04 = g_oma.oma01
      #FUN-B40056 --End

     #FUN-BB0117 Add Begin ---
     #刪除對應的交款單、待抵單、支出單
      DELETE FROM rxx_file WHERE rxx01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM rxy_file WHERE rxy01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM rxz_file WHERE rxz01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM luj_file WHERE luj01 IN (SELECT lui01 FROM lui_file WHERE lui04 = g_lua.lua01)
      DELETE FROM lui_file WHERE lui04 = g_lua.lua01
      DELETE FROM lul_file WHERE lul01 IN (SELECT luk01 FROM luk_file WHERE luk05 = g_lua.lua01)
      DELETE FROM luk_file WHERE luk05 = g_lua.lua01
      DELETE FROM lup_file WHERE lup01 IN (SELECT luo01 FROM luo_file WHERE luo04 = g_lua.lua01)
      DELETE FROM luo_file WHERE luo04 = g_lua.lua01
     #FUN-BB0117 Add End -----

      LET g_sql1 =
         "SELECT * FROM oob_file",
           " WHERE oob01 ='", g_oma.oma01,"' AND oob04 = '3' AND oob03 = '1' AND oob06 IS NOT NULL AND oob09 > 0"
      PREPARE t610_pb6 FROM g_sql1
      DECLARE t610_cs6 SCROLL CURSOR FOR t610_pb6
      FOREACH t610_cs6 INTO l_oob.*
         IF SQLCA.sqlcode THEN                                                                                                        
            CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
            EXIT FOREACH                                                                                                              
         END IF 
         UPDATE oma_file SET oma55 = oma55 - l_oob.oob09,
                             oma57 = oma57 - l_oob.oob10
         WHERE oma01 = l_oob.oob06
         SELECT oma55, oma57 INTO l_amt1,l_amt2 FROM oma_file 
            WHERE oma01 = l_oob.oob06
         IF l_amt1<0 OR l_amt2 <0 THEN
            CALL cl_err('','alm-205',1)
         END IF
      END FOREACH
 
      SELECT sum(rxx04) + SUM(rxx05) INTO l_sum FROM rxx_file                                                                          
          WHERE rxx01=g_lua.lua01 and rxxplant=g_lua.luaplant and rxx00='07'                                                            
      IF cl_null(l_sum) THEN LET l_sum=0 END IF                                                                                        
      IF l_sum > 0 THEN LET g_flag = '1' LET g_oma.oma65 = '2' ELSE LET g_flag = '0' LET g_oma.oma65 = '1' END IF
      LET g_sql1 = "SELECT * FROM oob_file WHERE oob01 = '",g_oma.oma01,"' AND oob03 = '1' AND oob02 > 0 "
      PREPARE t610_pb7 FROM g_sql1
      DECLARE t610_cs7 SCROLL CURSOR FOR t610_pb7
      FOREACH t610_cs7 INTO l_oob.*
         IF SQLCA.sqlcode THEN                                                                                                        
            CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
            EXIT FOREACH                                                                                                              
         END IF 
         IF l_oob.oob04 = '1' THEN
            DELETE FROM nmh_file WHERE nmh01 = l_oob.oob06
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                 
               CALL cl_err3("del","nmh_file","l_oob.oob06","",SQLCA.sqlcode,"","del nmh",1)                                                          
               LET g_success = 'N'                                                                                                        
            END IF                                                                                                                        
         END IF
         IF l_oob.oob04 = '2' THEN
            DELETE FROM nme_file WHERE nme12 = l_oob.oob06
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                      
               CALL cl_err3("del","nme_file",'','',SQLCA.sqlcode,"","del nme",1)                                                               
               LET g_success = 'N'                                                                                                             
            END IF 
            IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
            #FUN-B40056  --begin
            DELETE FROM tic_file WHERE tic04 = l_oob.oob06
            IF SQLCA.sqlcode THEN                                                                                      
               CALL cl_err3("del","tic_file",'','',SQLCA.sqlcode,"","del tic",1)                                                               
               LET g_success = 'N'                                                                                                             
            END IF 
            #FUN-B40056  --end   
            END IF                 #No.TQC-B70021 
         END IF
      END FOREACH
      IF g_flag = '1' THEN
         DELETE FROM ooa_file WHERE ooa01 = g_oma.oma01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
            CALL cl_err3("del","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","del ooa",1)                                           
            LET g_success = 'N'                                                                                                            
         END IF 
         DELETE FROM oob_file WHERE oob01 = g_oma.oma01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
            CALL cl_err3("del","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","del oob",1)                                           
            LET g_success = 'N'                                                                                                            
         END IF 
      END IF
      DELETE FROM oma_file WHERE oma01 = g_oma.oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
         CALL cl_err3("del","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","del oma",1)                                           
         LET g_success = 'N'                                                                                                            
      END IF 
      DELETE FROM omb_file WHERE omb01 = g_oma.oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
         CALL cl_err3("del","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","del omb",1)                                           
         LET g_success = 'N'                                                                                                            
      END IF 
      DELETE FROM omc_file WHERE omc01 = g_oma.oma01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
         CALL cl_err3("del","omc_file",g_omc.omc01,g_omc.omc02,SQLCA.sqlcode,"","del omc",1)                                           
         LET g_success = 'N'                                                                                                            
      END IF
   END IF    #FUN-B50007
   END IF  #No.FUN-A80105

   IF g_success = 'Y' THEN
      LET g_lua.lua14 = '0'
      LET g_lua.lua15 = 'N'                                                                                                         
      LET g_lua.lua16 = ''                                                                                                          
      LET g_lua.lua17 = ''                                                                                                          
      LET g_lua.lua24 = ''                                                                                                          
      DISPLAY BY NAME g_lua.lua15,g_lua.lua16,g_lua.lua17                                                                           
      DISPLAY BY NAME g_lua.lua24
      CALL t610_field_pic()  
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t610_gen_npq()
DEFINE l_aag371 LIKE aag_file.aag371,
       l_occ02  LIKE occ_file.occ02,
       l_occ37  LIKE occ_file.occ37,
       l_oob09  LIKE oob_file.oob09,
       l_oob10  LIKE oob_file.oob10
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = 'AR'  
   LET g_npq.npq00 = 2  
   LET g_npq.npq01 = g_oma.oma01
   LET g_npq.npq011 = 1    
   LET g_npq.npq02 = 0 
   LET g_npq.npqtype = 0        
   LET g_npq.npq04 = NULL     
   LET g_npq.npq05 = g_oma.oma15 
   LET g_npq.npq21 = g_oma.oma03 
   LET g_npq.npq22 = g_oma.oma032
   LET g_npq.npq24 = g_oma.oma23 
   LET g_npq.npq25 = g_oma.oma24
   LET g_npq.npq02 = g_npq.npq02 + 1 
   LET g_npq.npq03 = g_oma.oma18
   ###是否做部門管理
   LET g_aag05 = NULL  LET g_aag23 = NULL
   SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno3
   IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN LET g_npq.npq05 = ' ' END IF
   IF g_aag05='Y' THEN  LET g_npq.npq05=s_t300_gl_set_npq05(g_oma.oma15,g_oma.oma930) END IF 
   LET g_npq.npq06 = '1' LET g_npq.npq07f = g_oma.oma54t LET g_npq.npq07 = g_oma.oma56t
   IF g_aag23 = 'Y' THEN LET g_npq.npq08 = g_oma.oma63 ELSE LET g_npq.npq08 = null END IF #專案 
   LET g_npq.npq23 = g_oma.oma01
   LET l_aag371=' ' LET g_npq.npq37=''
   SELECT aag371 INTO l_aag371 FROM aag_file                                 
    WHERE aag01=g_npq.npq03                                                  
      AND aag00 = g_bookno3 
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) RETURNING  g_npq.*
   IF l_aag371 MATCHES '[23]' THEN
      SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file WHERE occ01=g_oma.oma03
      IF cl_null(g_npq.npq37) THEN
         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF
      END IF
   END IF
   IF g_npq.npq07 <> 0 THEN  INSERT INTO npq_file VALUES (g_npq.*)  END IF
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                 
      CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq",1)                                        
      LET g_success = 'N'                                                                                                        
   END IF  
     
   SELECT oma_file.*,ool_file.* INTO g_oma.*,g_ool.*                            
     FROM oma_file, OUTER ool_file WHERE oma01 = g_trno                    
      AND oma13=ool_file.ool01
   LET g_npq.npq02 = g_npq.npq02 + 1 
   LET g_npq.npq04 = NULL
   LET g_npq.npq03 = g_ool.ool21
   LET g_npq.npq06 = '2'
   LET g_npq.npq07f = g_oma.oma54
   LET g_npq.npq07 = g_oma.oma56
   LET g_npq.npq23 = g_oma.oma19 
   ###是否做部門管理
   LET g_aag05 = NULL
   LET g_aag23 = NULL
   SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file                     
    WHERE aag01 = g_npq.npq03                                                
      AND aag00 = g_bookno3 
   IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN LET g_npq.npq05 = ' ' END IF
      IF g_aag05='Y' THEN LET g_npq.npq05=s_t300_gl_set_npq05(g_oma.oma15,g_oma.oma930) END IF
         IF g_aag23 = 'Y' THEN LET g_npq.npq08 = g_oma.oma63 ELSE LET g_npq.npq08 = null END IF
            LET l_aag371=' ' LET g_npq.npq37=''
            SELECT aag371 INTO l_aag371 FROM aag_file                                 
             WHERE aag01=g_npq.npq03                                                  
              AND aag00 = g_bookno3
            IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)
            RETURNING  g_npq.*
            IF l_aag371 MATCHES '[23]' THEN
               #-->for 合并報表-關系人                                                
               SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file                  
                WHERE occ01=g_oma.oma03                                               
               IF cl_null(g_npq.npq37) THEN                                           
                  IF l_occ37='Y' THEN                                                 
                     LET g_npq.npq37=l_occ02 CLIPPED                                  
                  END IF                                                              
               END IF      
           END IF 
           IF g_npq.npq07 <> 0 THEN INSERT INTO npq_file VALUES (g_npq.*) END IF
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                    
              CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq",1)                                           
              LET g_success = 'N'                                                                                                           
           END IF    
 
   ###稅:
           IF g_oma.oma54x > 0 THEN 
              LET g_npq.npq02 = g_npq.npq02 + 1
              LET g_npq.npq04 = NULL
              LET g_npq.npq03 = g_ool.ool28
              LET g_npq.npq06 = '2'
              LET g_npq.npq07f = g_oma.oma54x 
              LET g_npq.npq07 = g_oma.oma56x
              LET g_npq.npq23 = g_oma.oma01 
              LET g_aag05 = NULL 
              LET g_aag23 = NULL
              SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file                  
               WHERE aag01 = g_npq.npq03                                             
                AND aag00 = g_bookno3
              IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
                 LET g_npq.npq05 = ' '
              END IF
              IF g_aag05='Y' THEN LET g_npq.npq05=s_t300_gl_set_npq05(g_oma.oma15,g_oma.oma930) END IF
              IF g_aag23 = 'Y' THEN LET g_npq.npq08 = g_oma.oma63 ELSE LET g_npq.npq08 = null END IF
              LET l_aag371=' ' LET g_npq.npq37='' 
              SELECT aag371 INTO l_aag371 FROM aag_file
               WHERE aag01=g_npq.npq03 
                AND aag00 = g_bookno3
              IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) RETURNING  g_npq.* 
              IF l_aag371 MATCHES '[23]' THEN                                        
              #-->for 合并報表-關系人                                             
                 SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file               
                   WHERE occ01=g_oma.oma03                                            
                 IF cl_null(g_npq.npq37) THEN                                        
                    IF l_occ37='Y' THEN                                              
                       LET g_npq.npq37=l_occ02 CLIPPED                               
                    END IF                                                           
                 END IF                                                              
             END IF
             IF g_npq.npq07 <> 0 THEN INSERT INTO npq_file VALUES (g_npq.*)  END IF
             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                    
                CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq",1)                                           
                LET g_success = 'N'                                                                                                           
             END IF   
          END IF
         DELETE FROM npq_file WHERE npq01=g_trno AND npq03='-' AND npq00 = 2          
                              AND npqsys = 'AR' AND npq011 = 1
         #FUN-B40056 --Begin
         DELETE FROM tic_file WHERE tic04 = g_trno
         #FUN-B40056 --END
   ###稅結束
 
 
   ###若存在直接收款 
   ###借 oob03 = '1' 記錄當前直接收款之總金額
        SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file              
        WHERE oob01 = g_oma.oma01 AND oob03='1'
        IF cl_null(l_oob09) THEN LET l_oob09= 0 END IF 
        IF cl_null(l_oob10) THEN LET l_oob10= 0 END IF 
 
   ###開始
        CALL s_t300_rgl_d()
        CALL s_t300_rgl_c("e",g_bookno3)
        IF l_oob10 != g_oma.oma56t THEN   #匯兌損益
           CALL s_t300_rgl_c("r",g_bookno3)
        END IF
        CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
END FUNCTION 
 
FUNCTION t610_y2()
DEFINE   l_wc_gl   LIKE type_file.chr1000
###若設置自動拋磚ooydmy1='Y且立即拋磚總賬
  IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
    #LET l_wc_gl = 'npp01 = "',g_oma.oma01,'" AND npp011 = 1' #TQC-B20095
     LET l_wc_gl = 'npp01 = "',g_lua.lua24,'" AND npp011 = 1' #TQC-B20095
     LET g_str="axrp590 '",l_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",
                g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",
                g_oma.oma02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
     CALL cl_cmdrun_wait(g_str)
  END IF
END FUNCTION

FUNCTION t610_z2()
 DEFINE l_t1 LIKE type_file.chr20

  #No.FUN-A80105 Begin--
  #IF g_lua.lua02 = '10' THEN                                                                                                       
  #   SELECT * INTO g_oma.* from oma_file                                                                                           
  #    WHERE oma70 = g_lua.lua01 AND oma71=g_lua.luaplant and oma00='22'                                                          
  #ELSE                                                                                                                             
  #   IF g_lua.lua02 = '01' THEN                                                                                                    
  #     SELECT * INTO g_oma.* from oma_file                                                                                         
  #       WHERE oma70 = g_lua.lua01 AND oma71=g_lua.luaplant and oma00='15'                                                       
  #   ELSE                                                                                                                          
  #     IF g_lua.lua02 = '02' THEN                                                                                                  
  #        SELECT * INTO g_oma.* from oma_file                                                                                      
  #       WHERE oma70 = g_lua.lua01 AND oma71=g_lua.luaplant and oma00='17'                                                       
  #     END IF                                                                                                                      
  #   END IF                                                                                                                        
  #END IF
   SELECT * INTO g_oma.* from oma_file WHERE oma01=g_lua.lua24
  #No.FUN-A80105 End-----

   CALL s_get_doc_no(g_oma.oma01) RETURNING l_t1                                                                                    
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=l_t1                                                                           
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND NOT cl_null(g_oma.oma33) THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_oma.oma33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)			
   END IF
END FUNCTION

FUNCTION t610_y1()
DEFINE l_amt1    LIKE oma_file.oma55
DEFINE l_amt2    LIKE oma_file.oma55
DEFINE l_t1      LIKE type_file.chr20
DEFINE l_ooydmy1 LIKE ooy_file.ooydmy1
DEFINE l_oob RECORD LIKE oob_file.*
 
   CALL s_showmsg_init()          #dongbg add                                                                                       
   LET g_success = 'Y'                                                                                                              
  
   #MOD-B80180--add--str--
   DROP TABLE x
   SELECT * FROM npq_file WHERE 1=2 INTO TEMP x
   #MOD-B80180--add--end--

   INITIALIZE g_oma.* LIKE oma_file.* #No.FUN-A80105
   BEGIN WORK                                                                                                                       
   OPEN t610_cl USING g_lua.lua01                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN t610_cl:", STATUS, 1)                                                                                       
      CLOSE t610_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF                                                                                                                           
   FETCH t610_cl INTO g_lua.*                                                                                                       
      IF SQLCA.sqlcode THEN                                                                                                         
      CALL cl_err(g_lua.lua01,SQLCA.sqlcode,0)                                                                                      
      CLOSE t610_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF                                                                                                                           
  #UPDATE lua_file SET lua15 = 'Y',lua16 = g_user,lua17 = g_today #FUN-BB0117 Mark
   UPDATE lua_file SET lua14 = '1',lua15 = 'Y',lua16 = g_user,lua17 = g_today #FUN-BB0117 Add
    WHERE lua01 = g_lua.lua01                                                                                                       
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err3("upd","lua_file",g_lua.lua01,"",STATUS,"","",1)                                                                  
      LET g_success = 'N'                                                                                                           
   END IF

#FUN-A80105--begin--
# CALL s_costs_ar(g_lua.lua01) RETURNING g_oma.oma01
# IF cl_null(g_oma.oma01) OR g_success = 'N'  THEN 
#    LET g_success = 'N'
# END IF 
  IF g_lua.lua32 <> '4'  THEN              #FUN-B50007 add  
     IF NOT t610_own(g_lua.lua06) THEN
        CALL s_costs_ar(g_lua.lua01) RETURNING g_oma.oma01
        IF cl_null(g_oma.oma01) OR g_success = 'N'  THEN 
           LET g_success = 'N'
        END IF                 
     END IF
#FUN-A80105--end--
     IF g_success = 'Y' THEN
       #LET g_lua.lua24 = g_oma.oma01 #FUN-BB0117 Mark
        INITIALIZE g_oma.oma01 TO NULL            #FUN-A80105 by vealxu
        UPDATE lua_file SET lua15 = 'Y',lua16 = g_user,lua17 = g_today,
                            lua24 = g_lua.lua24                     
         WHERE lua01 = g_lua.lua01                                                                                                       
        IF SQLCA.sqlcode THEN                                                                                                            
           CALL cl_err3("upd","lua_file",g_lua.lua01,"",STATUS,"","",1)                                                                  
           LET g_success = 'N'                                                                                                           
        END IF
     END IF
  END IF                                   #FUN-B50007 add

   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lua.lua14 = '1'
      LET g_lua.lua15 = 'Y'
      LET g_lua.lua16 = g_user
      LET g_lua.lua17 = g_today
      DISPLAY BY NAME g_lua.lua15,g_lua.lua16,g_lua.lua17
      DISPLAY BY NAME g_lua.lua24
      CALL t610_field_pic()
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
   END IF
END FUNCTION
 
FUNCTION t610_z_chk()
 DEFINE l_cnt   SMALLINT
 DEFINE l_t1    LIKE type_file.chr20
 DEFINE l_dbs   LIKE type_file.chr10
 DEFINE l_aba19 LIKE aba_file.aba19
 DEFINE l_oma55 LIKE oma_file.oma55
 DEFINE l_oma57 LIKE oma_file.oma57

  #No.FUN-A80105 Begin--
  #IF g_lua.lua02 = '10' THEN
  #   SELECT * INTO g_oma.* from oma_file                                                                                      
  #    WHERE oma70 = g_lua.lua01 AND oma71=g_lua.luaplant and oma00='22'
  #ELSE
  #   IF g_lua.lua02 = '01' THEN
  #     SELECT * INTO g_oma.* from oma_file
  #       WHERE oma70 = g_lua.lua01 AND oma71=g_lua.luaplant and oma00='15'
  #   ELSE
  #     IF g_lua.lua02 = '02' THEN
  #        SELECT * INTO g_oma.* from oma_file                                                                                         
  #       WHERE oma70 = g_lua.lua01 AND oma71=g_lua.luaplant and oma00='17'
  #     END IF
  #   END IF
  #END IF
   SELECT * INTO g_oma.* from oma_file WHERE oma01=g_lua.lua24
  #No.FUN-A80105 End-----
   CALL s_get_doc_no(g_oma.oma01) RETURNING l_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=l_t1
   IF NOT cl_null(g_oma.oma33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL cl_err(g_oma.oma01,'axr-370',0) 
         LET g_success = 'N'
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_dbs=l_dbs CLIPPED
      #LET g_sql1 = " SELECT aba19 FROM ",l_dbs,"aba_file", #FUN-A50102
      LET g_sql1 = " SELECT aba19 FROM ",cl_get_target_table(g_ooz.ooz02p, 'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_oma.oma33,"'"
      CALL cl_replace_sqldb(g_sql1) RETURNING g_sql1             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql1, g_ooz.ooz02p) RETURNING g_sql1  #FUN-A50102            
      PREPARE aba_pre FROM g_sql1
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_oma.oma33,'axr-071',1)
         LET g_success = 'N'
      END IF
   END IF
 
  #FUN-BB0117 Markn Begin ---
  #IF g_lua.lua02 = '01' THEN 
  #   SELECT count(*) INTO l_cnt FROM oob_file,ooa_file 
  #    WHERE ooa01=oob01 
  #     AND oob06 IN 
  #         (SELECT oma01 from oma_file 
  #         # WHERE oma70=g_lua.lua01 and oma71=g_lua.luaplant and oma00='15') #No.FUN-A80105
  #           WHERE oma16=g_lua.lua01 AND oma66=g_lua.luaplant AND oma00='15') #No.FUN-A80105
  #     AND ooa01 != g_oma.oma01
  #   IF l_cnt>0 THEN call cl_err('','alm-122',1) 
  #      LET g_success = 'N'
  #   END IF
  #END IF
  #IF g_lua.lua02 = '02' THEN
  #   SELECT COUNT(*) INTO l_cnt FROM oob_file,ooa_file
  #    WHERE ooa01 = oob01
  #      AND oob06 IN
  #          (SELECT oma01 from oma_file
  #          # WHERE oma70=g_lua.lua01 and oma71=g_lua.luaplant and oma00='17') #No.FUN-A80105
  #            WHERE oma16=g_lua.lua01 AND oma66=g_lua.luaplant AND oma00='17') #No.FUN-A80105
  #      AND ooa01 != g_oma.oma01
  #   IF l_cnt > 0 THEN 
  #      CALL cl_err('','alm-122',1)
  #      LET g_success = 'N'
  #   END IF 
  #END IF 
  #IF g_lua.lua02 = '10' THEN
  #   SELECT oma55,oma57 INTO l_oma55,l_oma57 FROM oma_file
  #    WHERE oma01 = (SELECT oma01 from oma_file
  #                  # WHERE oma70=g_lua.lua01 and oma71=g_lua.luaplant AND oma00='22')#No.FUN-A80105
  #                    WHERE oma16=g_lua.lua01 AND oma66=g_lua.luaplant AND oma00='22') #No.FUN-A80105
  #   IF cl_null(l_oma55) THEN LET l_oma55 = 0 END IF
  #   IF cl_null(l_oma57) THEN LET l_oma57 = 0 END IF
  #   IF l_oma55 > 0 OR l_oma57 > 0 THEN
  #      CALL cl_err('','alm-975',1)
  #      LET g_success = 'N'
  #   END IF
  #END IF
  #FUN-BB0117 Mark End -----
END FUNCTION

#FUN-A80105--begin--
#判斷是否為同法人自營櫃商戶(同法人的營運中心)
FUNCTION t610_own(l_occ01)
   DEFINE l_occ01 LIKE occ_file.occ01
   DEFINE l_occ930 LIKE occ_file.occ930
   DEFINE l_azw02  LIKE azw_file.azw02

   SELECT occ930 INTO l_occ930 FROM occ_file
    WHERE occ01 = l_occ01
   IF cl_null(l_occ930) THEN
      RETURN FALSE
   ELSE
      SELECT azw02 INTO l_azw02 FROM azw_file 
       WHERE azw01 = l_occ930
      IF l_azw02 != g_legal THEN
         RETURN FALSE
      ELSE 
         RETURN TRUE
      END IF
   END IF  
END FUNCTION
#FUN-A80105--end--

#FUN-960130

#No.TQC-AB0019  --Begin
#FUNCTION t610_upd_lua21()                   #CHI-CB0008 mark
FUNCTION t610_upd_lua21(p_chkwind)           #CHI-CB0008 add
  DEFINE p_chkwind     LIKE type_file.chr1   #CHI-CB0008 add
  DEFINE l_cnt         LIKE type_file.num5
  DEFINE l_lub02       LIKE lub_file.lub02
  DEFINE l_lub04       LIKE lub_file.lub04
  DEFINE l_lub04t      LIKE lub_file.lub04t
  DEFINE l_conu        LIKE type_file.chr1   #CHI-CB0008 add

   LET l_conu = NULL                         #CHI-CB0008 add
   SELECT COUNT(*) INTO l_cnt from lub_file
    WHERE lub01 = g_lua.lua01
   IF l_cnt > 0 THEN
      #CHI-CB0008 add begin---
      IF p_chkwind = 'N' THEN
         LET l_conu = 'Y'
      END IF
      IF p_chkwind = 'Y' THEN
         #稅別改變，是否跟新單身金額
         IF cl_confirm('axm-936') THEN
            LET l_conu = 'Y'
         END IF
      END IF
      #CHI-CB0008 add end-----

      ##稅別改變，是否跟新單身金額         #CHI-CB0008 mark
      #IF cl_confirm('axm-936') THEN       #CHI-CB0008 mark
      IF l_conu = 'Y' THEN                 #CHI-CB0008 add
         DECLARE lua21_cs CURSOR FOR
          SELECT lub02,lub04,lub04t FROM lub_file
           WHERE lub01 = g_lua.lua01
         FOREACH lua21_cs INTO l_lub02,l_lub04,l_lub04t
            IF g_lua.lua23 = 'N' THEN
               LET l_lub04t=l_lub04*(1+g_lua.lua22/100)
            ELSE
               LET l_lub04 =l_lub04t/(1+g_lua.lua22/100)
            END IF
            CALL cl_digcut(l_lub04t,g_azi04) RETURNING l_lub04t
            CALL cl_digcut(l_lub04,g_azi04)  RETURNING l_lub04
            UPDATE lub_file SET lub04 = l_lub04,
                                lub04t= l_lub04t
             WHERE lub01 = g_lua.lua01 AND lub02 = l_lub02
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("upd","lub_file",g_lua.lua01,l_lub02,STATUS,"","upd lub04,lub04t:",1)
               EXIT FOREACH
            END IF
         END FOREACH
         CALL t610_b_fill(' 1=1')
         SELECT SUM(lub04),SUM(lub04t) INTO g_lua.lua08,g_lua.lua08t FROM lub_file
          WHERE lub01 = g_lua.lua01
         CALL cl_digcut(g_lua.lua08,g_azi04)  RETURNING g_lua.lua08
         CALL cl_digcut(g_lua.lua08t,g_azi04) RETURNING g_lua.lua08t
         IF cl_null(g_lua.lua08)  THEN LET g_lua.lua08 = 0 END IF
         IF cl_null(g_lua.lua08t) THEN LET g_lua.lua08t= 0 END IF
         DISPLAY BY NAME g_lua.lua08
         DISPLAY BY NAME g_lua.lua08t
      END IF
   END IF
END FUNCTION

#FUN-BB0117 Add Begin ---
FUNCTION t610_fill_head()
DEFINE l_rtz13 LIKE rtz_file.rtz13
DEFINE l_azt02 LIKE azt_file.azt02
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_gem02 LIKE gem_file.gem02
DEFINE l_amt   LIKE lua_file.lua08t

   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lua.luaplant
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lua.lualegal
   DISPLAY l_azt02 TO FORMONLY.azt02
   CALL t610_get_lnt30('d')
   IF NOT cl_null(g_lua.lua38) THEN
      INITIALIZE l_gen02 TO NULL
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lua.lua38
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
   IF NOT cl_null(g_lua.lua39) THEN
      INITIALIZE l_gem02 TO NULL
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_lua.lua39
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
   IF NOT cl_null(g_lua.lua16) THEN
      INITIALIZE l_gen02 TO NULL
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lua.lua16
      DISPLAY l_gen02 TO FORMONLY.gen02_2
   ELSE
      DISPLAY '' TO FORMONLY.gen02_2
   END IF
   IF NOT cl_null(g_lua.lua08t) AND NOT cl_null(g_lua.lua35) AND NOT cl_null(g_lua.lua36) THEN
      LET l_amt = g_lua.lua08t - g_lua.lua35 - g_lua.lua36
      DISPLAY l_amt TO FORMONLY.amt
   END IF
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_get_lnt30(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_lnt30 LIKE lnt_file.lnt30 #主品牌
DEFINE l_tqa02 LIKE tqa_file.tqa02 #品牌名稱

   IF NOT cl_null(g_lua.lua04) THEN
      INITIALIZE l_lnt30 TO NULL
      SELECT lnt30 INTO l_lnt30 FROM lnt_file WHERE lnt01 = g_lua.lua04
      IF p_cmd = 'a' THEN
         SELECT lnt35,lnt36,lnt37 INTO g_lua.lua21,g_lua.lua22,g_lua.lua23
           FROM lnt_file
          WHERE lnt01 = g_lua.lua04
         DISPLAY BY NAME g_lua.lua21,g_lua.lua22,g_lua.lua23
      END IF
   ELSE
      IF NOT cl_null(g_lua.lua06) THEN
         IF NOT cl_null(g_lua.lua32) THEN
            IF g_lua.lua32 <> '1' AND g_lua.lua32 <> '2' AND g_lua.lua32 <> '5' THEN
               INITIALIZE l_lnt30 TO NULL
               SELECT lne08 INTO l_lnt30 FROM lne_file WHERE lne01 = g_lua.lua06
               IF p_cmd = 'a' THEN
                  SELECT lne40 INTO g_lua.lua21 FROM lne_file WHERE lne01 = g_lua.lua06
                  IF NOT cl_null(g_lua.lua21) THEN
                     SELECT gec04,gec07 INTO g_lua.lua22,g_lua.lua23
                       FROM gec_file
                      WHERE gec01 = g_lua.lua21
                        AND gec011 = '2'
                  END IF
                  DISPLAY BY NAME g_lua.lua21,g_lua.lua22,g_lua.lua23
               END IF
            END IF
         END IF
      END IF
   END IF
   IF NOT cl_null(l_lnt30) THEN
      INITIALIZE l_tqa02 TO NULL
      SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = l_lnt30 AND tqa03 = '2'
   END IF
   DISPLAY l_lnt30 TO FORMONLY.lnt30
   DISPLAY l_tqa02 TO FORMONLY.tqa02
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_lua38(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_gen02   LIKE gen_file.gen02
DEFINE l_genacti LIKE gen_file.genacti
DEFINE l_gem02   LIKE gem_file.gem02

   LET g_errno = ''
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_lua.lua38
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'anm-207'
                               LET l_gen02 = NULL
                               LET g_lua.lua39 = NULL
      WHEN l_genacti <> 'Y'    LET g_errno = 'alm-879'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_errno) AND p_cmd = 'a' THEN
      SELECT gen03 INTO g_lua.lua39
        FROM gen_file
       WHERE gen01 = g_lua.lua38
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT gem02 INTO l_gem02
        FROM gem_file
       WHERE gem01 = g_lua.lua39
      DISPLAY BY NAME g_lua.lua39
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION 

FUNCTION t610_lua39(p_cmd)
DEFINE l_n       LIKE type_file.num5
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_gem02   LIKE gem_file.gem02
DEFINE l_gemacti LIKE gem_file.gemacti

   LET g_errno = ''
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_lua.lua39
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-039'
                               LET l_gem02 = NULL
      WHEN l_gemacti <> 'Y'    LET g_errno = 'asf-472'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_b_get_default()

   LET g_lub[l_ac].lub07 = g_today
   LET g_lub[l_ac].lub08 = g_today
   LET g_lub[l_ac].lub11 = 0
   LET g_lub[l_ac].lub12 = 0
   LET g_lub[l_ac].amt_2 = 0
   LET g_lub[l_ac].lub13 = 'N'
   CALL t610_get_lub10()
   IF NOT cl_null(g_lua.lua04) THEN
      IF g_lua.lua32 = '0' THEN
         SELECT rto02 INTO g_lub[l_ac].lub16 FROM rto_file WHERE rto01 = g_lua.lua04 AND rtoconf = 'Y'
      END IF
      IF g_lua.lua32 = '3' THEN
         SELECT lnt02 INTO g_lub[l_ac].lub16 FROM lnt_file WHERE lnt01 = g_lua.lua04 AND lnt26 = 'Y'
      END IF
   END IF
END FUNCTION 

FUNCTION t610_get_lub10()

   #立帳日期預設取值邏輯：
   #1.若開始日期大於關帳日期，則立帳日期=開始日期
   #2.反之，立帳日期等於關帳日期+1
   IF g_lub[l_ac].lub07 > g_ooz.ooz09 THEN
      LET g_lub[l_ac].lub10 = g_lub[l_ac].lub07
   ELSE
      LET g_lub[l_ac].lub10 = g_ooz.ooz09 + 1
   END IF
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_get_sum()
DEFINE l_amt LIKE lua_file.lua08t
DEFINE l_cnt LIKE type_file.num10      #FUN-C30072 add

   SELECT sum(lub04),SUM(lub04t),SUM(lub11),SUM(lub12) INTO g_lua.lua08,g_lua.lua08t,g_lua.lua35,g_lua.lua36
     FROM lub_file
    WHERE lub01=g_lua.lua01
   #FUN-C30072 add begin ---
   SELECT COUNT(*) INTO l_cnt
     FROM lub_file 
    WHERE lub01 = g_lua.lua01
      AND lub09 = '10'
   IF l_cnt > 0 THEN
      LET g_lua.lua08 = g_lua.lua08 * (-1) 
      LET g_lua.lua08t = g_lua.lua08t * (-1)
      LET g_lua.lua35 = g_lua.lua35 * (-1)
      LET g_lua.lua36 = g_lua.lua36 * (-1)
   END IF 
   #FUN-C30072 add end ---
   UPDATE lua_file set lua08  = g_lua.lua08,
                       lua08t = g_lua.lua08t,
                       lua35  = g_lua.lua35,
                       lua36  = g_lua.lua36
    WHERE lua01=g_lua.lua01
   LET l_amt = g_lua.lua08t - g_lua.lua35 - g_lua.lua36
   DISPLAY l_amt TO FORMONLY.amt
   DISPLAY BY NAME g_lua.lua08,g_lua.lua08t,g_lua.lua35,g_lua.lua36
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_pay_from_paynote()
 DEFINE l_n          LIKE type_file.num5
 DEFINE l_lui        RECORD LIKE lui_file.*
 DEFINE l_luj        RECORD LIKE luj_file.*
 DEFINE l_luj06_sum  LIKE luj_file.luj06
 DEFINE l_sql        STRING
 DEFINE l_lub02      LIKE lub_file.lub02
 DEFINE l_lub03      LIKE lub_file.lub03
 DEFINE l_lub04t     LIKE lub_file.lub04t
 DEFINE l_cmd        STRING
 DEFINE l_luj06_sum2 LIKE luj_file.luj06
 DEFINE l_lup06      LIKE lup_file.lup06 #TQC-C30008
 DEFINE l_luj06      LIKE luj_file.luj06 #TQC-C30008

   IF cl_null(g_lua.lua01) THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF

   IF g_lua.lua37 = 'Y' THEN
      CALL cl_err('','art-758',0) #直接收款不可以通過交款單交款！
      RETURN
   END IF

   IF g_lua.lua15 <> 'Y' THEN
      CALL cl_err('','art-766',0)
      RETURN
   END IF

   IF g_lua.lua14 = '2' THEN
      CALL cl_err('','axr-369',0)
      RETURN
   END IF

   #FUN-C30072 add begin ---
   CALL t610_chk_paynote()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)       #费用支出类型的费用不可交款单交款
      RETURN
   END IF 
   #FUN-C30072 add end  ----
   SELECT COUNT(*) INTO l_n FROM lub_file WHERE (lub04t - lub11 - lub12) > 0 
   IF l_n = 0 THEN
      CALL cl_err('','art-759',0) #費用已收清，不用再交款
      RETURN
   END IF
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lub_file
    WHERE lub01 = g_lua.lua01
      AND lub04t > 0
   IF g_cnt = 0 THEN
      CALL cl_err('','alm1376',0)
      RETURN
   END IF

  #TQC-C30008 Begin---
  #LET l_n = 0 
  #SELECT COUNT(*) INTO l_n FROM lui_file WHERE lui04 = g_lua.lua01
  #IF l_n > 0 THEN
  #   LET l_cmd = 'artt611 "',g_lua.lua01,'" '
  #   CALL cl_cmdrun_wait(l_cmd)
  #   CALL t610_show()
  #ELSE
  #   CALL s_showmsg_init()
  #   BEGIN WORK
  #   LET g_success = 'Y'

  #   INITIALIZE l_lui.* TO NULL
  #   INITIALIZE l_luj.* TO NULL

  #   SELECT rye03 INTO l_lui.lui01 FROM rye_file
  #    WHERE rye01 = 'art'
  #      AND rye02 = 'B1'
  #   IF cl_null(l_lui.lui01) THEN
  #      CALL s_errmsg('lui01',l_lui.lui01,'sel_rye','art-330',1)
  #      LET g_success = 'N'
  #      RETURN
  #   END IF
  #  #CALL s_auto_assign_no("art",l_lui.lui01,g_today,'B2',"lui_file","lui01","","","") #TQC-C30008
  #   CALL s_auto_assign_no("art",l_lui.lui01,g_today,'B1',"lui_file","lui01","","","") #TQC-C30008
  #      RETURNING li_result,l_lui.lui01
  #   IF (NOT li_result) THEN
  #      LET g_success = 'N'
  #      RETURN
  #   END IF

  #   LET l_lui.lui02 = g_today
  #   LET l_lui.lui03 = g_lua.lua09 #立帳日期
  #   LET l_lui.lui04 = g_lua.lua01
  #   LET l_lui.lui05 = g_lua.lua06
  #   LET l_lui.lui06 = g_lua.lua07
  #   LET l_lui.lui07 = g_lua.lua04
  #   LET l_lui.lui08 = g_lua.lua20
  #   LET l_lui.lui09 = ''
  #   LET l_lui.lui10 = 0
  #   LET l_lui.lui11 = g_user
  #   LET l_lui.lui12 = g_grup
  #   LET l_lui.lui13 = ''
  #   LET l_lui.lui14 = ''
  #   LET l_lui.lui15 = 'N' #FUN-C20009
  #   LET l_lui.luiconf = 'N'
  #   LET l_lui.luicond = ''
  #   LET l_lui.luicont = ''
  #   LET l_lui.luiconu = ''
  # # LET l_lui.luimksg = 'N'
  #   LET l_lui.luiacti = 'Y'
  #   LET l_lui.luicrat = g_today
  #   LET l_lui.luidate = g_today
  #   LET l_lui.luigrup = g_grup
  #   LET l_lui.luimodu = ''
  #   LET l_lui.luiuser = g_user
  #   LET l_lui.luioriu = g_user
  #   LET l_lui.luiorig = g_grup
  #   LET l_lui.luiplant = g_lua.luaplant
  #   LET l_lui.luilegal = g_lua.lualegal

  #   INSERT INTO lui_file VALUES(l_lui.*)
  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #      CALL s_errmsg('ins lui',l_lui.lui01,'',SQLCA.sqlcode,1)
  #      LET g_success = 'N'
  #      RETURN
  #   ELSE
  #      LET l_sql = "SELECT lub02,lub03,lub04t - lub11 - lub12 ",
  #                  "  FROM lub_file ",
  #                  " WHERE lub01 = '",g_lua.lua01,"' ",
  #                  "   AND lub03 IN (SELECT lub03 ",
  #                  "                   FROM lub_file ",
  #                  "                  WHERE lub01 = '",g_lua.lua01,"' ",
  #                  "                    AND (lub04t - lub11 - lub12) > 0) ",
  #                  " ORDER BY lub02 "
  #      PREPARE sel_lub_pre1 FROM l_sql
  #      DECLARE sel_lub_cs1 CURSOR FOR sel_lub_pre1
  #      FOREACH sel_lub_cs1 INTO l_lub02,l_lub03,l_lub04t
  #         IF SQLCA.sqlcode THEN
  #            CALL cl_err('foreach:',SQLCA.sqlcode,0)
  #            EXIT FOREACH
  #         END IF
  #         LET l_luj.luj01 = l_lui.lui01
  #         SELECT MAX(luj02) +1 INTO l_luj.luj02
  #           FROM luj_file
  #          WHERE luj01 = l_lui.lui01
  #         IF cl_null(l_luj.luj02) THEN LET l_luj.luj02 = 1 END IF
  #         LET l_luj.luj03 = g_lua.lua01
  #         LET l_luj.luj04 = l_lub02
  #         LET l_luj.luj05 = l_lub03
  #         LET l_luj.luj06 = l_lub04t
  #         LET l_luj.luj07 = ''
  #         LET l_luj.lujplant = l_lui.luiplant
  #         LET l_luj.lujlegal = l_lui.luilegal

  #         INSERT INTO luj_file VALUES(l_luj.*)
  #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #            CALL s_errmsg('ins luj',l_luj.luj01,'',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #            RETURN
  #         END IF
  #         SELECT SUM(luj06) INTO l_luj06_sum2 FROM luj_file WHERE luj01 = l_lui.lui01
  #         IF cl_null(l_luj06_sum2) THEN LET l_luj06_sum2 = 0 END IF
  #         UPDATE lui_file SET lui09 = l_luj06_sum2
  #          WHERE lui01 = l_lui.lui01
  #         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #            CALL s_errmsg('upd lui',l_lui.lui01,'',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #            RETURN
  #         END IF
  #      END FOREACH
  #   END IF
  #   IF g_success = 'Y' THEN
  #      COMMIT WORK
  #      LET l_cmd = 'artt611 "',g_lua.lua01,'" '
  #      CALL cl_cmdrun_wait(l_cmd)
  #      CALL t610_show()
  #   ELSE
  #      CALL s_showmsg()
  #      ROLLBACK WORK
  #   END IF
  #END IF

   CALL s_showmsg_init()
   BEGIN WORK
   LET g_success = 'Y'

   INITIALIZE l_lui.* TO NULL
   INITIALIZE l_luj.* TO NULL

   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_lui.lui01 FROM rye_file
   # WHERE rye01 = 'art'
   #   AND rye02 = 'B1'
   #FUN-C90050 mark end-----
 
   CALL s_get_defslip('art','B1',g_plant,'N') RETURNING l_lui.lui01   #FUN-C90050 add

   IF cl_null(l_lui.lui01) THEN
      CALL s_errmsg('lui01',l_lui.lui01,'sel_rye','art-330',1)
      LET g_success = 'N'
   END IF
   CALL s_auto_assign_no("art",l_lui.lui01,g_today,'B1',"lui_file","lui01","","","")
      RETURNING li_result,l_lui.lui01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF

   LET l_lui.lui02 = g_today
   LET l_lui.lui03 = g_lua.lua09 #立帳日期
   LET l_lui.lui04 = g_lua.lua01
   LET l_lui.lui05 = g_lua.lua06
   LET l_lui.lui06 = g_lua.lua07
   LET l_lui.lui07 = g_lua.lua04
   LET l_lui.lui08 = g_lua.lua20
   LET l_lui.lui09 = ''
   LET l_lui.lui10 = 0
   LET l_lui.lui11 = g_user
   LET l_lui.lui12 = g_grup
   LET l_lui.lui13 = ''
   LET l_lui.lui14 = ''
   LET l_lui.lui15 = 'N' #FUN-C20009
   LET l_lui.luiconf = 'N'
   LET l_lui.luicond = ''
   LET l_lui.luicont = ''
   LET l_lui.luiconu = ''
  #LET l_lui.luimksg = 'N'
   LET l_lui.luiacti = 'Y'
   LET l_lui.luicrat = g_today
   LET l_lui.luidate = g_today
   LET l_lui.luigrup = g_grup
   LET l_lui.luimodu = ''
   LET l_lui.luiuser = g_user
   LET l_lui.luioriu = g_user
   LET l_lui.luiorig = g_grup
   LET l_lui.luiplant = g_lua.luaplant
   LET l_lui.luilegal = g_lua.lualegal

   LET l_sql = "SELECT lub02,lub03,lub04t ",
               "  FROM lub_file ",
               " WHERE lub01 = '",g_lua.lua01,"' ",
               "   AND lub03 IN (SELECT lub03 ",
               "                   FROM lub_file ",
               "                  WHERE lub01 = '",g_lua.lua01,"' ",
               "                    AND (lub04t - lub11 - lub12) <> 0) ",
               " ORDER BY lub02 "
   PREPARE sel_lub_pre1 FROM l_sql
   DECLARE sel_lub_cs1 CURSOR FOR sel_lub_pre1
   FOREACH sel_lub_cs1 INTO l_lub02,l_lub03,l_lub04t
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET l_luj.luj01 = l_lui.lui01
      SELECT MAX(luj02) +1 INTO l_luj.luj02
        FROM luj_file
       WHERE luj01 = l_lui.lui01
      IF cl_null(l_luj.luj02) THEN LET l_luj.luj02 = 1 END IF
      LET l_luj.luj03 = g_lua.lua01
      LET l_luj.luj04 = l_lub02
      LET l_luj.luj05 = l_lub03
     #LET l_luj.luj06 = l_lub04t
      LET l_lup06 = 0 #TQC-C30027
      LET l_luj06 = 0 #TQC-C30027
      #汇总已支出金额,不区分审核/未审核
      IF l_lub04t < 0 THEN
         SELECT SUM(lup06) INTO l_lup06
           FROM lup_file,luo_file
          WHERE lup01 = luo01
            AND luo03 = '2'
            AND lup03 = g_lua.lua01
            AND lup04 = l_lub02
            AND luoconf <> 'X'  #CHI-C80041
      END IF
      IF cl_null(l_lup06) THEN LET l_lup06 = 0 END IF

      #汇总已交款金额，不区分审核/未审核
      SELECT sum(luj06) INTO l_luj06
        FROM luj_file,lui_file
       WHERE lui01 = luj01
         AND luj03 = g_lua.lua01
         AND luj04 = l_lub02
         AND luiconf <> 'X'  #CHI-C80041
      IF cl_null(l_luj06) THEN LET l_luj06=0 END IF
      LET l_luj.luj06 = l_lub04t - l_luj06 + l_lup06
      IF l_luj.luj06 = 0 THEN
          CONTINUE FOREACH
      END IF

      LET l_luj.luj07 = ''
      LET l_luj.lujplant = l_lui.luiplant
      LET l_luj.lujlegal = l_lui.luilegal

      INSERT INTO luj_file VALUES(l_luj.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins luj',l_luj.luj01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   END FOREACH
   #只要有一个大于0就产生到单身，删除同一个费用编号都小于0的项次
   DELETE FROM luj_file WHERE luj01 = l_lui.lui01
                          AND luj05 NOT IN (SELECT DISTINCT luj05 FROM luj_file
                                             WHERE luj01 = l_lui.lui01
                                               AND luj06 > 0  )
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","lui_file",g_lui.lui01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF

   SELECT SUM(luj06) INTO l_lui.lui09 FROM luj_file WHERE luj01 = l_lui.lui01
   IF cl_null(l_lui.lui09) THEN LET l_lui.lui09 = 0 END IF
   INSERT INTO lui_file VALUES(l_lui.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ins lui',l_lui.lui01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET l_cmd = 'artt611 "',g_lua.lua01,'" '
      CALL cl_cmdrun_wait(l_cmd)
      CALL t610_show()
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
   END IF
  #TQC-C30008 End-----
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
#產生交款單
FUNCTION t610_ins_luiluj()
DEFINE l_sql  STRING

   IF g_success = 'N' THEN RETURN END IF

   INITIALIZE g_lui.* TO NULL
   INITIALIZE g_luj.* TO NULL
   
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO g_lui.lui01 FROM rye_file
   # WHERE rye01 = 'art'
   #   AND rye02 = 'B1'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','B1',g_plant,'N') RETURNING g_lui.lui01   #FUN-C90050 add

   IF cl_null(g_lui.lui01) THEN
      CALL s_errmsg('lui01',g_lui.lui01,'sel_rye','art-330',1)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_auto_assign_no("art",g_lui.lui01,g_today,'B1',"lui_file","lui01","","","")
      RETURNING li_result,g_lui.lui01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF

   LET g_lui.lui02 = g_today
   IF g_today > g_ooz.ooz09 THEN
      LET g_lui.lui03 = g_today
   ELSE
      LET g_lui.lui03 = g_ooz.ooz09 + 1
   END IF
   LET g_lui.lui04 = g_lua.lua01
   LET g_lui.lui05 = g_lua.lua06
   LET g_lui.lui06 = g_lua.lua07
   LET g_lui.lui07 = g_lua.lua04
   LET g_lui.lui08 = g_lua.lua20
   LET g_lui.lui09 = g_lua.lua08t
   LET g_lui.lui10 = g_lua.lua08t
   LET g_lui.lui11 = g_user
   LET g_lui.lui12 = g_grup
   LET g_lui.lui13 = ''
   LET g_lui.lui14 = ''
   LET g_lui.lui15 = 'Y' #FUN-C20009
   LET g_lui.luiconf = 'Y'
   LET g_lui.luicond = g_today
   LET g_lui.luicont = TIME
   LET g_lui.luiconu = g_user
  #LET g_lui.luimksg = 'N'
   LET g_lui.luiacti = 'Y'
   LET g_lui.luicrat = g_today
   LET g_lui.luidate = g_today
   LET g_lui.luigrup = g_grup
   LET g_lui.luimodu = ''
   LET g_lui.luiuser = g_user
   LET g_lui.luioriu = g_user
   LET g_lui.luiorig = g_grup
   LET g_lui.luiplant = g_lua.luaplant
   LET g_lui.luilegal = g_lua.lualegal

   INSERT INTO lui_file VALUES(g_lui.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ins lui',g_lui.lui01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   ELSE
      LET l_sql = "SELECT lub02,lub03,lub04t ",
                  "  FROM lub_file ",
                  " WHERE lub01 = '",g_lua.lua01,"' ",
                  " ORDER BY lub02 "
      PREPARE sel_lub_pre FROM l_sql
      DECLARE sel_lub_cs CURSOR FOR sel_lub_pre
      FOREACH sel_lub_cs INTO g_luj.luj04,g_luj.luj05,g_luj.luj06
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         SELECT MAX(luj02)+1 INTO g_luj.luj02
           FROM luj_file
          WHERE luj01 = g_lui.lui01
         IF cl_null(g_luj.luj02) THEN
            LET g_luj.luj02 = 1
         END IF
         LET g_luj.luj01 = g_lui.lui01
         LET g_luj.luj03 = g_lua.lua01
         LET g_luj.luj07 = ''
         LET g_luj.lujplant = g_lui.luiplant
         LET g_luj.lujlegal = g_lui.luilegal
         INSERT INTO luj_file VALUES(g_luj.*)
         DISPLAY g_luj.luj03,g_luj.luj04
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('ins luj',g_luj.luj01,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         INITIALIZE g_luj.* TO NULL
      END FOREACH
   END IF
END FUNCTION

#複製交款信息
FUNCTION t610_cp_rxxyz()
DEFINE l_rxx RECORD LIKE rxx_file.*
DEFINE l_rxy RECORD LIKE rxy_file.*
DEFINE l_rxz RECORD LIKE rxz_file.*
DEFINE l_sql STRING

   IF g_success = 'N' THEN RETURN END IF

   LET l_sql = "SELECT * ",
               "  FROM rxx_file ",
               " WHERE rxx00 = '07' AND rxx01 = '",g_lua.lua01,"' "
   PREPARE t610_cp_rxx_pre FROM l_sql
   DECLARE t610_cp_rxx_cs CURSOR FOR t610_cp_rxx_pre
   FOREACH t610_cp_rxx_cs INTO l_rxx.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_rxx.rxx01 = g_lui.lui01
      LET l_rxx.rxx00 = '11'
      INSERT INTO rxx_file VALUES(l_rxx.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins rxx',l_rxx.rxx01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   LET l_sql = "SELECT *",
               "  FROM rxy_file ",
               " WHERE rxy00 = '07' AND rxy01 = '",g_lua.lua01,"' "
   PREPARE t610_cp_rxy_pre FROM l_sql
   DECLARE t610_cp_rxy_cs CURSOR FOR t610_cp_rxy_pre
   FOREACH t610_cp_rxy_cs INTO l_rxy.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_rxy.rxy01 = g_lui.lui01
      LET l_rxy.rxy00 = '11'
      INSERT INTO rxy_file VALUES(l_rxy.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins rxy',l_rxy.rxy01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

   LET l_sql = "SELECT * ",
               "  FROM rxz_file ",
               " WHERE rxz00 = '07' AND rxz01 = '",g_lua.lua01,"' "
   PREPARE t610_cp_rxz_pre FROM l_sql
   DECLARE t610_cp_rxz_cs CURSOR FOR t610_cp_rxz_pre
   FOREACH t610_cp_rxz_cs INTO l_rxz.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_rxz.rxz01 = g_lui.lui01
      LET l_rxz.rxz00 = '11'
      INSERT INTO rxz_file VALUES(l_rxz.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins rxz',l_rxz.rxz01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH

END FUNCTION

#產生待抵單
FUNCTION t610_ins_luklul()
DEFINE l_luk        RECORD LIKE luk_file.*
DEFINE l_lul        RECORD LIKE lul_file.*
DEFINE l_sql        STRING
DEFINE l_luj06_sum  LIKE luj_file.luj06
DEFINE l_luj02      LIKE luj_file.luj02
DEFINE l_luj05      LIKE luj_file.luj05
DEFINE l_luj06      LIKE luj_file.luj06
DEFINE l_luj03      LIKE luj_file.luj03
DEFINE l_luj04      LIKE luj_file.luj04
DEFINE l_oaj05      LIKE oaj_file.oaj05

   IF g_success = 'N' THEN RETURN END IF

   INITIALIZE l_luk.* TO NULL
   INITIALIZE l_lul.* TO NULL

   SELECT SUM(luj06) INTO l_luj06_sum 
     FROM luj_file,oaj_file 
    WHERE luj05 = oaj01 AND oaj05 = '01' AND luj01 = g_lui.lui01 AND luj06 > 0
   IF l_luj06_sum > 0 THEN
      #FUN-C90050 mark begin---
      #SELECT rye03 INTO l_luk.luk01 FROM rye_file
      # WHERE rye01 = 'art'
      #   AND rye02 = 'B2'
      #FUN-C90050 mark end-----

      CALL s_get_defslip('art','B2',g_plant,'N') RETURNING l_luk.luk01   #FUN-C90050 add

      IF cl_null(l_luk.luk01) THEN
         CALL s_errmsg('luk01',l_luk.luk01,'sel_rye','art-330',1)
         LET g_success = 'N'
         RETURN
      END IF
      CALL s_auto_assign_no("art",l_luk.luk01,g_today,'B2',"luk_file","luk01","","","")
         RETURNING li_result,l_luk.luk01
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF

      LET l_luk.luk02 = g_today
      IF g_today > g_ooz.ooz09 THEN
         LET l_luk.luk03 = g_today
      ELSE
         LET l_luk.luk03 = g_ooz.ooz09 + 1
      END IF
      LET l_luk.luk04 = 1
      LET l_luk.luk05 = g_lui.lui01
      LET l_luk.luk06 = g_lui.lui05
      LET l_luk.luk07 = g_lui.lui06
      LET l_luk.luk08 = g_lui.lui07
      LET l_luk.luk09 = g_lui.lui08
      LET l_luk.luk10 = l_luj06_sum
      LET l_luk.luk11 = 0
      LET l_luk.luk12 = 0
      LET l_luk.luk13 = g_user
      LET l_luk.luk14 = g_grup
      LET l_luk.luk15 = ''
      LET l_luk.lukconf = 'Y'
      LET l_luk.lukcond = g_today
      LET l_luk.lukcont = TIME
      LET l_luk.lukconu = g_user
      LET l_luk.lukmksg = 'N'
      LET l_luk.lukacti = 'Y'
      LET l_luk.lukcrat = g_today
      LET l_luk.lukdate = g_today
      LET l_luk.lukgrup = g_grup
      LET l_luk.lukmodu = ''
      LET l_luk.lukuser = g_user
      LET l_luk.lukoriu = g_user
      LET l_luk.lukorig = g_grup
      LET l_luk.lukplant = g_lui.luiplant
      LET l_luk.luklegal = g_lui.luilegal

      INSERT INTO luk_file VALUES(l_luk.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL s_errmsg('ins luk',l_luk.luk01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      ELSE
         LET l_sql = "SELECT luj02,luj05,luj06,luj03,luj04 ",
                     "  FROM luj_file ",
                     " WHERE luj01 = '",g_lui.lui01,"' ",
                     "   AND luj06 > 0 ",
                     " ORDER BY luj02,luj05 "
         PREPARE sel_luj_pre FROM l_sql
#        DECLARE sel_luj_cs CURSOR FOR sel_lub_pre       #FUN-C30072  MARK
         DECLARE sel_luj_cs CURSOR FOR sel_luj_pre       #FUN-C30072  add
         FOREACH sel_luj_cs INTO l_luj02,l_luj05,l_luj06,l_luj03,l_luj04
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            SELECT oaj05 INTO l_oaj05 FROM oaj_file WHERE oaj01 = l_luj05
            IF l_oaj05 <> '01' OR cl_null(l_oaj05)  THEN CONTINUE FOREACH END IF
            SELECT MAX(lul02) + 1 INTO l_lul.lul02
              FROM lul_file
             WHERE lul01 = l_luk.luk01
            IF cl_null(l_lul.lul02) THEN LET l_lul.lul02 = 1 END IF
            LET l_lul.lul01 = l_luk.luk01
            LET l_lul.lul03 = g_lui.lui01
            LET l_lul.lul04 = l_luj02
            LET l_lul.lul05 = l_luj05
            LET l_lul.lul06 = l_luj06
            LET l_lul.lul07 = 0
            LET l_lul.lul08 = 0
            LET l_lul.lul09 = l_luj03
            LET l_lul.lul10 = l_luj04
            LET l_lul.lulplant = l_luk.lukplant
            LET l_lul.lullegal = l_luk.luklegal
            INSERT INTO lul_file VALUES(l_lul.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('ins lul',l_lul.lul01,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
            UPDATE luj_file SET luj07 = l_luk.luk01
             WHERE luj01 = g_lui.lui01 AND luj02 = l_lul.lul04
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('upd luj',g_lui.lui01,l_lul.lul04,SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
   END IF
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_upd_money()
DEFINE l_lub02  LIKE lub_file.lub02
DEFINE l_lub04t LIKE lub_file.lub04t
DEFINE l_lub12  LIKE lub_file.lub12
DEFINE l_sql    STRING
DEFINE l_rxx04  LIKE rxx_file.rxx04
DEFINE l_rxy06  LIKE rxy_file.rxy06
DEFINE l_rxy32  LIKE rxy_file.rxy32
DEFINE l_rxy05  LIKE rxy_file.rxy05
DEFINE l_lul07  LIKE lul_file.lul07

   SELECT SUM(rxx04) INTO g_lua.lua35
     FROM rxx_file
    WHERE rxx00 = '07'
      AND rxx01 = g_lua.lua01 AND rxxplant = g_lua.luaplant
   IF cl_null(g_lua.lua35) THEN LET g_lua.lua35 = 0 END IF

   UPDATE lua_file SET lua35 = g_lua.lua35
    WHERE lua01 = g_lua.lua01
   IF g_lua.lua35 = g_lua.lua08t - g_lua.lua36 THEN
      LET l_sql = "SELECT lub02,lub04t,lub12 FROM lub_file WHERE lub01 = '",g_lua.lua01,"' "
      PREPARE sel_lub_pre4 FROM l_sql
      DECLARE sel_lub_cs4 CURSOR FOR sel_lub_pre4
      FOREACH sel_lub_cs4 INTO l_lub02,l_lub04t,l_lub12
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         UPDATE lub_file SET lub11 = l_lub04t - l_lub12
          WHERE lub01 = g_lua.lua01 AND lub02 = l_lub02
         INITIALIZE l_lub02,l_lub04t,l_lub12 TO NULL 
      END FOREACH
   END IF

   CALL t610_show()
   CALL t610_b_fill( "1=1")
END FUNCTION
#FUN-BB0117 Add End -----

#FUN-BB0117 Add Begin ---
FUNCTION t610_get_lua05()

   IF NOT cl_null(g_lua.lua32) AND (g_lua.lua32 = '0' OR g_lua.lua32 = '3') THEN
      IF s_chk_own(g_lua.lua06) THEN
         LET g_lua.lua05 = 'Y'
         LET g_lua.lua37 = 'N'
      ELSE
         LET g_lua.lua05 = 'N'
      END IF
      DISPLAY BY NAME g_lua.lua05,g_lua.lua37
   END IF
END FUNCTION
#FUN-BB0117 Add End -----

#No.TQC-AB0019  --End  

#FUN-C20004 --start---   Add
FUNCTION t610_axrp601()
  DEFINE l_cnt    LIKE type_file.num5
  DEFINE li_wc     STRING
  DEFINE li_wc1    STRING
  DEFINE li_str    STRING

  IF s_shut(0) THEN
      RETURN
  END IF
  IF cl_null(g_lua.lua01) THEN
     RETURN
  END IF

  SELECT COUNT(*) INTO l_cnt FROM lua_file,lub_file
   WHERE lua15 = 'Y' AND lub14 IS NULL 
     AND lua32 <> '6' AND lub04t > 0
  #TQC-C20430--add--begin
     AND lua01=lub01
     AND lua01=g_lua.lua01 
  #TQC-C20430--add--end
  
  IF l_cnt = 0 THEN
     CALL cl_err('','aim-162',0)   #TQC-C40019
     RETURN
  END IF

  IF g_lua.lua15 != 'Y' THEN
     RETURN
  END IF

  IF NOT (cl_confirm("axr119")) THEN
     RETURN
  END IF

#TQC-C20163--mod--str--
# LET li_wc  = " azp01 = '",g_lua.luaplant,"'"
# LET li_wc1 = "lua01 = '",g_lua.lua01,"' AND lua06 = '",g_lua.lua06,"' AND lua09 = '",g_lua.lua09,"'"
# LET li_str = "axrp601",
#              ' "',li_wc,'" ',
#              ' "',li_wc1,'" ',
#              ' " "',
#              ' " " ',
#              ' "',YEAR(g_today),'" ',
#              ' "',MONTH(g_today),'" ',
#              ' "Y" '
  LET li_wc  = 'azp01 = "',g_lua.luaplant,'"'
  LET li_wc1 = 'lua01 = "',g_lua.lua01,'" AND lua06 = "',g_lua.lua06,'" AND lua09 = "',g_lua.lua09,'"'
  LET li_str = "axrp601 '",li_wc CLIPPED,"' '",li_wc1,"' '' '' '",YEAR(g_today),"' '",MONTH(g_today),"' 'Y'" 
  
#TQC-C20163--mod--end

  CALL cl_cmdrun_wait(li_str)
 #---TQC-C20204--mark--str No.TQC-C20204
 #IF g_success = 'Y' THEN
 #   CALL cl_err('','lib-284',0)
 #ELSE
 #   CALL cl_err('','abm-020',0)
 #END IF
 #--TQC-C20204--mark--end
  CALL t610_b_fill( "1=1")

END FUNCTION
#FUN-C20004 --end---     Add

#FUN-C30029 ---start---   Add
FUNCTION t610_axrp605()
  DEFINE l_cnt    LIKE type_file.num5
  DEFINE li_wc     STRING
  DEFINE li_wc1    STRING
  DEFINE li_str    STRING
  DEFINE l_mm      LIKE type_file.num5   #No.TQC-C40058   Add
  DEFINE l_lub10   LIKE type_file.num5   #No.TQC-C40058   Add

  SELECT COUNT(*) INTO l_cnt FROM lua_file,lub_file
   WHERE lua15 = 'Y' AND lub14 IS NOT NULL
     AND lua32 <> '6' AND lub04t > 0
     AND lua01=lub01
     AND lua01=g_lua.lua01

  IF l_cnt = 0 THEN
     RETURN
  END IF

  IF g_lua.lua15 != 'Y' THEN
     RETURN
  END IF

  IF NOT (cl_confirm("axr-391")) THEN
     RETURN
  END IF

 #No.TQC-C40058   ---start---   Add
  SELECT MAX(MONTH(lub10)) INTO l_lub10 FROM lub_file WHERE lub01 = g_lua.lua01
                                                        AND lub14 IS NOT NULL
  LET l_mm = MONTH(g_today)
  IF l_mm < l_lub10 THEN
     CALL cl_err('','axr-421',1)
     RETURN
  END IF
 #No.TQC-C40058   ---end---     Add

  LET li_wc  = 'azp01 = "',g_lua.luaplant,'"'
  LET li_wc1 = 'lua01 = "',g_lua.lua01,'"'
 #LET li_str = "axrp605 '",li_wc CLIPPED,"' '",li_wc1,"' 'Y'"   #No.TQC-C40058   Mark
  LET li_str = "axrp605 '",li_wc CLIPPED,"' '",li_wc1,"' '",YEAR(g_today),"' '",MONTH(g_today),"' 'Y'"   #No.TQC-C40058   Add
 
  CALL cl_cmdrun_wait(li_str)

  CALL t610_b_fill( "1=1")

END FUNCTION
#FUN-C30029 ---end---     Add

#FUN-CB0076-------add------str
FUNCTION t610_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_amt     LIKE ogb_file.ogb11,
       sr        RECORD
                 luaplant  LIKE lua_file.luaplant,
                 lua01     LIKE lua_file.lua01,
                 lua04     LIKE lua_file.lua04,
                 lua20     LIKE lua_file.lua20,
                 lua06     LIKE lua_file.lua06,
                 lua061    LIKE lua_file.lua061,
                 lua09     LIKE lua_file.lua09,
                 lua07     LIKE lua_file.lua07,
                 lua17     LIKE lua_file.lua17,
                 lua16     LIKE lua_file.lua16,
                 lub02     LIKE lub_file.lub02,
                 lub03     LIKE lub_file.lub03,
                 lub05     LIKE lub_file.lub05,
                 lub06     LIKE lub_file.lub06,
                 lub09     LIKE lub_file.lub09,
                 lub07     LIKE lub_file.lub07,
                 lub08     LIKE lub_file.lub08,
                 lub04t    LIKE lub_file.lub04t,
                 lub11     LIKE lub_file.lub11,
                 lub12     LIKE lub_file.lub12,
                 lua18     LIKE lua_file.lua18
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('luauser', 'luagrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lua01 = '",g_lua.lua01,"'" END IF
     LET l_sql = "SELECT luaplant,lua01,lua04,lua20,lua06,lua061,lua09,lua07,",
                 "       lua17,lua16,lub02,lub03,lub05,lub06,lub09,lub07,lub08,lub04t,lub11,lub12,lua18",
                 "  FROM lua_file,lub_file",
                 " WHERE lua01 = lub01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t610_cs1 CURSOR FOR t610_prepare1

     DISPLAY l_table
     FOREACH t610_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.luaplant
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lua16
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.lub03
       LET l_amt = 0
       LET l_amt = sr.lub04t-sr.lub11-sr.lub12
       EXECUTE insert_prep USING sr.*,l_rtz13,l_gen02,l_oaj02,l_amt
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lua01,lua09,luaplant,lualegal,lua32,lua06,lua061,lua07,lua05,lua04,lua20,lua33,lua34,lua37,lua10,lua11,lua12,lua21,lua22,lua23,lua08,lua08t,lua35,lua36,lua38,lua39,lua14,lua15,lua16,lua17,lua18,luauser,luagrup,luaoriu,luamodu,luadate,luaorig,luaacti,luacrat')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lub02,lub03,lub09,lub07,lub08,lub10,lub04,lub04t,lub11,lub12,lub13,lub14,lub15,lub05')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3=''
     END IF
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF
     END IF
     CALL t610_grdata()
END FUNCTION

FUNCTION t610_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt610")
       IF handler IS NOT NULL THEN
           START REPORT t610_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lua01,lub02"
           DECLARE t610_datacur1 CURSOR FROM l_sql
           FOREACH t610_datacur1 INTO sr1.*
               OUTPUT TO REPORT t610_rep(sr1.*)
           END FOREACH
           FINISH REPORT t610_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t610_rep(sr1)
    DEFINE sr1           sr1_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lub04t_sum  LIKE lub_file.lub04t
    DEFINE l_lub11_sum   LIKE lub_file.lub11
    DEFINE l_amt_sum     LIKE lub_file.lub11
    DEFINE l_lub12_sum   LIKE lub_file.lub12
    DEFINE l_lub09       STRING
    DEFINE l_plant       STRING
    
    ORDER EXTERNAL BY sr1.lua01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
            PRINTX g_wc3
            PRINTX g_wc4
              
        BEFORE GROUP OF sr1.lua01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX sr1.*
            LET l_plant  = sr1.luaplant,' ',sr1.rtz13
            PRINTX l_plant
            LET l_lub09 = cl_gr_getmsg('gre-316',g_lang,sr1.lub09)
            PRINTX l_lub09

        AFTER GROUP OF sr1.lua01
            LET l_lub04t_sum = GROUP SUM(sr1.lub04t)
            LET l_amt_sum = GROUP SUM(sr1.amt)
            LET l_lub11_sum = GROUP SUM(sr1.lub11)
            LET l_lub12_sum = GROUP SUM(sr1.lub12)
            PRINTX l_lub04t_sum
            PRINTX l_amt_sum
            PRINTX l_lub11_sum
            PRINTX l_lub12_sum
            
        ON LAST ROW

END REPORT
#FUN-CB0076-------add------end

