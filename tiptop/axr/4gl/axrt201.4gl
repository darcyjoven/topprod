# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axrt201.4gl
# Descriptions...: 銷售信用狀修改作業
# Date & Author..: 96/02/06 By Danny
#                  96-09-23 By Charis 1.立即確認 2.單頭之單別可按,<^P>查詢
#                  3.取消確認序號須為最後一之修改序號 、確認須為較小序號
# Modify.........: No.9345 04/03/15 By Kitty 同一單號 多項次 無法確認
# Modify.........: No.9591 04/05/24 By Kitty 在_b詢問是否要自動產生若選N,則直接進入單身
# Modify.........: No.9592 04/05/24 By Kitty 預設序號時少判斷變更次數
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0049 04/12/09 By Nicola 權限控管修改
# Modify.........: No.MOD-530379 05/03/31 By Smapmin 無法做財務進出口取消確認
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.MOD-5B0008 05/11/08 By Smapmin 已結案之收狀單不可新增
# Modify.........: No.TQC-630014 06/03/06 By Smapmin 顯示錯誤訊息有誤
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/07/28 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-670088 06/08/07 By Sarah 單頭增加部門、成本中心欄位,單身增加成本中心欄位 
# Modify.........: No.FUN-670047 06/08/16 By day 多帳套修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0042 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6C0033 06/12/07 By Smapmin 數量抓取計價數量
# Modify.........: No.FUN-710050 07/01/29 By yjkhero 錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/09 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860075 08/06/10 By Carrier 直接拋轉總帳時，aba07(來源單號)沒有取得值
# Modify.........: No.MOD-970088 09/07/10 By Sarah t201_5()段抓取ole_file的SQL,key值應為ole01與ole02
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-810036 09/08/19 By xiaofeizhu 拋轉憑証時，傳入參數內的user應為資料所有者
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整l_n使用型態
# Modify.........: No:TQC-B20147 11/02/22 By yinhy 點擊“財務/進出口取消審核”，畫面下方提示“9023 conf=Y 此筆資料已經審核”
# Modify.........: No:FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80167 11/08/23 By guoch 查询时资料建立部门和资料建立者无法下条件
# Modify.........: No.FUN-910088 11/12/29 By chenjing 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C20288 12/09/24 By wangwei 取消審核時，ole30審核人員未被清除
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭時，一併刪除相關table
# Modify.........: No:FUN-D20058 13/03/28 By chenjing 取消確認賦值確認異動人員
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: NO:FUN-E80012 18/11/27 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ola   RECORD LIKE ola_file.*,
    g_ole   RECORD LIKE ole_file.*,
    b_olf   RECORD LIKE olf_file.*,
    g_ole_t RECORD LIKE ole_file.*,
    g_ole_o RECORD LIKE ole_file.*,
    g_olf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    olf02     LIKE olf_file.olf02,      #項次
                    olf04     LIKE olf_file.olf04,      #訂單單號
                    olf05     LIKE olf_file.olf05,      #訂單項次
                    olf11     LIKE olf_file.olf11,      #料件編號
                    ima02     LIKE ima_file.ima02,      #品名規格
                    olf03     LIKE olf_file.olf03,      #單位
                    olf06     LIKE olf_file.olf06,      #單價
                    olf07     LIKE olf_file.olf07,      #數量
                    olf08     LIKE olf_file.olf08,      #金額
                    olf930    LIKE olf_file.olf930,     #成本中心       #FUN-670088 add
                    gem02     LIKE gem_file.gem02,       #成本中心名稱   #FUN-670088 add
                    #FUN-850038 --start---
                    olfud01   LIKE olf_file.olfud01,
                    olfud02   LIKE olf_file.olfud02,
                    olfud03   LIKE olf_file.olfud03,
                    olfud04   LIKE olf_file.olfud04,
                    olfud05   LIKE olf_file.olfud05,
                    olfud06   LIKE olf_file.olfud06,
                    olfud07   LIKE olf_file.olfud07,
                    olfud08   LIKE olf_file.olfud08,
                    olfud09   LIKE olf_file.olfud09,
                    olfud10   LIKE olf_file.olfud10,
                    olfud11   LIKE olf_file.olfud11,
                    olfud12   LIKE olf_file.olfud12,
                    olfud13   LIKE olf_file.olfud13,
                    olfud14   LIKE olf_file.olfud14,
                    olfud15   LIKE olf_file.olfud15
                    #FUN-850038 --end--
                    END RECORD,
    g_olf_t         RECORD
                    olf02     LIKE olf_file.olf02,      #項次
                    olf04     LIKE olf_file.olf04,      #訂單單號
                    olf05     LIKE olf_file.olf05,      #訂單項次
                    olf11     LIKE olf_file.olf11,      #料件編號
                    ima02     LIKE ima_file.ima02,      #品名規格
                    olf03     LIKE olf_file.olf03,      #單位
                    olf06     LIKE olf_file.olf06,      #單價
                    olf07     LIKE olf_file.olf07,      #數量
                    olf08     LIKE olf_file.olf08,      #金額
                    olf930    LIKE olf_file.olf930,     #成本中心       #FUN-670088 add
                    gem02     LIKE gem_file.gem02,      #成本中心名稱   #FUN-670088 add
                    #FUN-850038 --start---
                    olfud01   LIKE olf_file.olfud01,
                    olfud02   LIKE olf_file.olfud02,
                    olfud03   LIKE olf_file.olfud03,
                    olfud04   LIKE olf_file.olfud04,
                    olfud05   LIKE olf_file.olfud05,
                    olfud06   LIKE olf_file.olfud06,
                    olfud07   LIKE olf_file.olfud07,
                    olfud08   LIKE olf_file.olfud08,
                    olfud09   LIKE olf_file.olfud09,
                    olfud10   LIKE olf_file.olfud10,
                    olfud11   LIKE olf_file.olfud11,
                    olfud12   LIKE olf_file.olfud12,
                    olfud13   LIKE olf_file.olfud13,
                    olfud14   LIKE olf_file.olfud14,
                    olfud15   LIKE olf_file.olfud15
                    #FUN-850038 --end--
                    END RECORD,
    g_ola05             LIKE ola_file.ola05,
     g_wc,g_wc2      string,  #No.FUN-580092 HCN
     g_sql           string,  #No.FUN-580092 HCN
    g_t1            LIKE ooy_file.ooyslip,                #No.FUN-680123 VARCHAR(5),                            #No.FUN-550071
    g_buf           LIKE gem_file.gem03,                #No.FUN-680123 VARCHAR(40),
    g_rec_b         LIKE type_file.num5,                #No.FUN-680123 SMALLINT,              #單身筆數
    g_tot           LIKE olf_file.olf08,
    g_argv1         LIKE ola_file.ola01,
    g_rate,m_rate   LIKE oga_file.oga907,
    l_ac            LIKE type_file.num5,                #No.FUN-680123 SMALLINT,              #目前處理的ARRAY CNT
    l_n             LIKE type_file.num5                 #No.FUN-680123 SMALLINT               #目前處理的SCREEN LINE
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   LIKE type_file.num5      #No.FUN-680123 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1            #No.FUN-680123 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680123 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000         #No.FUN-680123 VARCHAR(72)
DEFINE   g_str           STRING                         #No.FUN-670060
DEFINE   g_wc_gl         STRING                         #No.FUN-670060
DEFINE   g_dbs_gl 	     LIKE type_file.chr21           #No.FUN-680123 VARCHAR(21)    #No.FUN-670060
DEFINE   g_row_count     LIKE type_file.num10           #No.FUN-680123 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10           #No.FUN-680123 INTEGER
DEFINE   g_jump          LIKE type_file.num10           #No.FUN-680123 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5            #No.FUN-680123 SMALLINT
DEFINE   g_void          LIKE type_file.chr1            #CHI-C80041
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0095
 
    LET g_forupd_sql = " SELECT * FROM ole_file WHERE ole01 = ? AND ole02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t201_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t201_w WITH FORM "axr/42f/axrt201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL t201_q() END IF
 
    CALL cl_set_comp_visible("ole930,gem02b,olf930,gem02",g_aaz.aaz90='Y')   #FUN-670088 add
 
    CALL t201_menu()
    CLOSE WINDOW t201_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0095
END MAIN
 
FUNCTION t201_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "ole01 = '",g_argv1,"'"
       LET g_wc2=" 1=1 "
    ELSE
       CLEAR FORM                             #清除畫面
       CALL g_olf.clear()
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_ole.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
             ole01,ole02,ole09,
             ole32,ole930,                           #FUN-670088 add
             ole15,ole11,ole03,ole04,ole05,ole12,
             ole06,ole07,ole10,
             ole14,ole13,
             ole28,ole29,
             oleconf,ole30,
             ole081,
             oleuser,olegrup,olemodu,oledate,oleorig,oleoriu, #TQC-B80167  add oleorig,oleoriu
             #FUN-850038   ---start---
             oleud01,oleud02,oleud03,oleud04,oleud05,
             oleud06,oleud07,oleud08,oleud09,oleud10,
             oleud11,oleud12,oleud13,oleud14,oleud15
             #FUN-850038    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp   #ok
             CASE
                WHEN INFIELD(ole01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ola"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ole01
                     NEXT FIELD ole01
                WHEN INFIELD(ole06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oag"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ole06
                     NEXT FIELD ole06
               WHEN INFIELD(ole12)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ool"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ole12
                     NEXT FIELD ole12
               WHEN INFIELD(ole15)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ole15
                    NEXT FIELD ole15
              #start FUN-670088 add
               WHEN INFIELD(ole32)   #部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_gem"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ole32
                    NEXT FIELD ole32
               WHEN INFIELD(ole930)   #成本中心
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_gem4"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ole930
                    NEXT FIELD ole930
              #end FUN-670088 add
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('oleuser', 'olegrup') #FUN-980030
       IF INT_FLAG THEN
          RETURN
       END IF
       CONSTRUCT g_wc2 ON olf02,olf04,olf05,olf11,olf03,olf06,olf07,olf08,olf930   #FUN-670088 add olf930
                          #No.FUN-850038 --start--
                          ,olfud01,olfud02,olfud03,olfud04,olfud05
                          ,olfud06,olfud07,olfud08,olfud09,olfud10
                          ,olfud11,olfud12,olfud13,olfud14,olfud15
                          #No.FUN-850038 ---end---
                     FROM s_olf[1].olf02, s_olf[1].olf04,s_olf[1].olf05,
                          s_olf[1].olf11, s_olf[1].olf03,s_olf[1].olf06,
                          s_olf[1].olf07, s_olf[1].olf08,s_olf[1].olf930   #FUN-670088 add s_olf[1].olf930
                          #No.FUN-850038 --start--
                          ,s_olf[1].olfud01,s_olf[1].olfud02,s_olf[1].olfud03
                          ,s_olf[1].olfud04,s_olf[1].olfud05,s_olf[1].olfud06
                          ,s_olf[1].olfud07,s_olf[1].olfud08,s_olf[1].olfud09
                          ,s_olf[1].olfud10,s_olf[1].olfud11,s_olf[1].olfud12
                          ,s_olf[1].olfud13,s_olf[1].olfud14,s_olf[1].olfud15
                          #No.FUN-850038 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
             WHEN INFIELD(olf04)
               CALL q_oea(TRUE,TRUE,g_olf[1].olf04,g_ola.ola05,'3')
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO olf04
               NEXT FIELD olf04
            #start FUN-670088 add
             WHEN INFIELD(olf930)   #成本中心
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO olf930
               NEXT FIELD olf930
            #end FUN-670088 add
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
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
 
    IF g_wc2 = " 1=1" THEN		# 若單身未輸入條件
       LET g_sql = "SELECT ole01,ole02 FROM ole_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ole_file.ole01, ole02 ",
                   "  FROM ole_file, olf_file",
                   " WHERE ole01 = olf01",
                   "   AND ole02 = olf011",
                   "   AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t201_prepare FROM g_sql
    DECLARE t201_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t201_prepare
 
    IF g_wc2 = " 1=1 " THEN		# 若單身未輸入條件
       LET g_sql = "SELECT COUNT(*) FROM ole_file WHERE ", g_wc CLIPPED
     ELSE					# 若單身有輸入條件
       LET g_sql ="SELECT COUNT(DISTINCT ole01) FROM ole_file,olf_file ",
                  "WHERE ole01=olf01 AND ole02=olf011",
                  "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE t201_precount FROM g_sql
    DECLARE t201_count CURSOR FOR t201_precount
END FUNCTION
 
FUNCTION t201_menu()
 
   WHILE TRUE
      CALL t201_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t201_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t201_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t201_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t201_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_olf),'','')
             END IF
         #--
 
         WHEN "fin_imp_exp_confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_5()
            END IF
         WHEN "undo_fin_imp_exp_confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_6()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_z()
            END IF
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               CALL t201_v()
            END IF
         #No.FUN-670047--begin
#        WHEN "entry_sheet"
#           IF cl_chk_act_auth() THEN
#              CALL t201_vc()
#              CALL t201_npp02()  #No.+085 010426 by plum
#           END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               CALL t201_vc()
               CALL t201_npp02('0')
            END IF
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() THEN
               CALL t201_vc_1()
               CALL t201_npp02('1')  
            END IF
         #No.FUN-670047--end  
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               #CALL cl_cmdrun('axrp590')      #FUN-660216 remark
               #CALL cl_cmdrun_wait('axrp590')  #FUN-660216 add #FUN-670060 mark
               IF g_ole.oleconf = 'Y' THEN
                  CALL t201_carry_voucher()       #No.FUN-670060
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         #No.FUN-670060  --Begin
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_ole.oleconf = 'Y' THEN
                  CALL t201_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         #No.FUN-670060  --End  
         #No.FUN-6B0042-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ole.ole01 IS NOT NULL THEN
                LET g_doc.column1 = "ole01"
                LET g_doc.column2 = "ole02"
                LET g_doc.value1 = g_ole.ole01
                LET g_doc.value2 = g_ole.ole02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0042-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t201_x()
               IF g_ole.oleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_ole.oleconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t201_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_olf.clear()
    INITIALIZE g_ole.* TO NULL
    LET g_ole_t.* = g_ole.*
    CALL cl_opmsg('a')
    WHILE TRUE
        IF NOT cl_null(g_argv1) THEN LET g_ole.ole01=g_argv1 END IF
        LET g_ole.ole09   = g_today
        LET g_ole.ole10   = 0
        LET g_ole.oleconf = 'N'
        LET g_ole.ole28   = 'N'
        LET g_ole.ole32   = g_grup   #FUN-670088 add
        LET g_ole.ole930  = s_costcenter(g_ole.ole32)  #FUN-670088 add
        LET g_ole.oleuser = g_user
        LET g_ole.oleoriu = g_user #FUN-980030
        LET g_ole.oleorig = g_grup #FUN-980030
        LET g_ole.oledate = g_today
        LET g_ole.olegrup = g_grup
        LET g_ole.olelegal = g_legal #FUN-980011 add
        BEGIN WORK
        CALL t201_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_ole.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_ole.ole01 IS NULL THEN CONTINUE WHILE END IF
        
        INSERT INTO ole_file VALUES (g_ole.*)
        #No.+041 010330 by plum
        #IF STATUS THEN CALL cl_err(g_ole.ole01,STATUS,1) CONTINUE WHILE END IF
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_ole.ole01,SQLCA.SQLCODE,1)   #No.FUN-660116
            CALL cl_err3("ins","ole_file",g_ole.ole01,g_ole.ole02,SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
         END IF
        #No.+041..end
        COMMIT WORK
 
        SELECT ole01,ole02 INTO g_ole.ole01,g_ole.ole02 FROM ole_file WHERE ole01 = g_ole.ole01
                                                      AND ole02 = g_ole.ole02
        LET g_ole_t.* = g_ole.*
        CALL g_olf.clear()
        LET g_rec_b=0
        CALL t201_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t201_u()
   DEFINE l_n  LIKE ole_file.ole02    #FUN-A70120
   DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
   DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add

    IF s_shut(0) THEN RETURN END IF
    IF g_ole.ole01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                          AND ole02 = g_ole.ole02
    IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041                                   
    IF g_ole.oleconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ole.ole02 = 0 THEN RETURN END IF

    SELECT MAX(ole02) INTO l_n FROM ole_file WHERE ole01 = g_ole.ole01

    LET g_ole_t.* = g_ole.*
    BEGIN WORK
 
    OPEN t201_cl USING g_ole.ole01,g_ole.ole02
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)  
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t201_cl ROLLBACK WORK RETURN
    END IF
    CALL t201_show()
    WHILE TRUE
        LET g_ole.olemodu = g_user
        LET g_ole.oledate = g_today
        CALL t201_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ole.*=g_ole_t.*
            CALL t201_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ole_file SET * = g_ole.* WHERE ole01 = g_ole_t.ole01 AND ole02=g_ole_t.ole02
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("upd","ole_file",g_ole_t.ole01,g_ole_t.ole02,SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        END IF
        IF g_ole.ole01 != g_ole_t.ole01 THEN            # 更改單號
            UPDATE olf_file SET olf01 = g_ole.ole01
             WHERE olf01 = g_ole_t.ole01
               AND olf011 = g_ole_t.ole02
            IF SQLCA.sqlcode THEN
#               CALL cl_err('update olf01',SQLCA.sqlcode,0)   #No.FUN-660116
                CALL cl_err3("upd","olf_file",g_ole_t.ole01,g_ole_t.ole02,SQLCA.sqlcode,"","update olf01",1)  #No.FUN-660116
                CONTINUE WHILE 
            END IF
        END IF
       #No.+085 010426 by plum
        IF g_ole.ole09 != g_ole_t.ole09 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_ole.ole09
            WHERE npp01=g_ole.ole01 AND npp011 = g_ole.ole02
              AND npp00=42          AND nppsys = 'AR'
           IF STATUS THEN
#             CALL cl_err('upd npp02:',STATUS,1)   #No.FUN-660116
              CALL cl_err3("upd","ole_file",g_ole.ole01,g_ole.ole02,STATUS,"","upd npp02:",1)  #No.FUN-660116
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=YEAR(g_ole.ole09)
              LET l_tic02=MONTH(g_ole.ole09)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_ole.ole01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_ole.ole01,g_ole.ole02,STATUS,"","upd tic01 tic02",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
       #No.+085..end
        EXIT WHILE
    END WHILE
    CLOSE t201_cl
    COMMIT WORK
# 新增自動確認功能 Modify by Charis 96-09-23
#    LET g_t1=g_ole.ole01[1,3]
    CALL s_get_doc_no(g_ole.ole01) RETURNING g_t1                            #No.FUN-550071
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF STATUS THEN 
#      CALL cl_err('sel ooy_file',STATUS,0)  #No.FUN-660116
       CALL cl_err3("sel","ooy_file",g_t1,"",STATUS,"","sel ooy_file",1)  #No.FUN-660116
       RETURN 
    END IF
    IF (g_ole.oleconf='Y' OR g_ooy.ooyconf='N') #單據已確認或單據不需自動確認
       THEN RETURN
    ELSE CALL t201_y()
    END IF
# ----------------- :-)
END FUNCTION
 
#No.+085 010426 by plum
#FUNCTION t201_npp02()              #No.FUN-670047
FUNCTION t201_npp02(p_npptype)      #No.FUN-670047
DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-670047
DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
 
  IF g_ole.ole14 IS NULL OR g_ole.ole14=' ' THEN
     UPDATE npp_file SET npp02=g_ole.ole09
      WHERE npp01=g_ole.ole01 AND npp011 = g_ole.ole02
        AND npp00=42          AND nppsys = 'AR'
        AND npptype = p_npptype   #No.FUN-670047
     IF STATUS THEN 
#       CALL cl_err('upd npp02:',STATUS,1)  #No.FUN-660116
        CALL cl_err3("upd","npp_file",g_ole.ole01,g_ole.ole02,STATUS,"","upd npp02:",1)  #No.FUN-660116
     END IF
     #FUN-E80012---add---str---
     SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
     IF g_nmz.nmz70 = '3' THEN
        LET l_tic01=YEAR(g_ole.ole09)
        LET l_tic02=MONTH(g_ole.ole09)
        UPDATE tic_file SET tic01=l_tic01,
                            tic02=l_tic02
        WHERE tic04=g_ole.ole01
        IF STATUS THEN
           CALL cl_err3("upd","tic_file",g_ole.ole01,g_ole.ole02,STATUS,"","upd tic01 tic02",1)
        END IF
     END IF
     #FUN-E80012---add---end---
  END IF
END FUNCTION
#No.+085..end
 
#處理INPUT
FUNCTION t201_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)                #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)               #判斷必要欄位是否有輸入
  DEFINE l_n1            LIKE type_file.num5       #No.FUN-680123 SMALLINT
  DEFINE l_ola           RECORD LIKE ola_file.*
  DEFINE l_ool           RECORD LIKE ool_file.*
  DEFINE l_ola09         LIKE ola_file.ola09
  DEFINE l_cnt           LIKE type_file.num5       #No.FUN-680123 SMALLINT   #MOD-5B0008
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_ole.oleoriu,g_ole.oleorig,
       g_ole.ole01,g_ole.ole02,g_ole.ole09,
       g_ole.ole32,g_ole.ole930,   #FUN-670088 add
       g_ole.ole15,g_ole.ole11,g_ole.ole03,g_ole.ole04,g_ole.ole05,g_ole.ole12,
       g_ole.ole06,g_ole.ole07,g_ole.ole10,
       g_ole.ole14,g_ole.ole13,
       g_ole.ole28,g_ole.ole29,
       g_ole.oleconf,g_ole.ole30,
       g_ole.ole081,
       g_ole.oleuser,g_ole.olegrup,g_ole.olemodu,g_ole.oledate,
       #FUN-850038     ---start---
       g_ole.oleud01,g_ole.oleud02,g_ole.oleud03,g_ole.oleud04,
       g_ole.oleud05,g_ole.oleud06,g_ole.oleud07,g_ole.oleud08,
       g_ole.oleud09,g_ole.oleud10,g_ole.oleud11,g_ole.oleud12,
       g_ole.oleud13,g_ole.oleud14,g_ole.oleud15 
       #FUN-850038     ----end----
        WITHOUT DEFAULTS
 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t201_set_entry(p_cmd)
           CALL t201_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
        #No.FUN-550071 --start--
           CALL cl_set_docno_format("ole01")
        #No.FUN-550071 ---end---
       {
        BEFORE FIELD ole01
          DISPLAY "BEFORE FIELD ole01"
          IF p_cmd = 'u' AND g_chkey = 'N' THEN
             NEXT FIELD ole02
          END IF
       }
        AFTER FIELD ole01
          IF NOT cl_null(g_ole.ole01) THEN
#MOD-5B0008
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM ola_file
                WHERE ola01=g_ole.ole01 AND ola40='Y'
             IF l_cnt > 0 THEN
                CALL cl_err('','axr-015',0)
                NEXT FIELD ole01
             END IF
#END MOD-5B0008
             SELECT * INTO l_ola.* FROM ola_file WHERE ola01 = g_ole.ole01
                                                   AND olaconf !='X' #0108006增
             IF STATUS THEN
#               CALL cl_err('sel ola',STATUS,1)    #No.FUN-660116
                CALL cl_err3("sel","ola_file",g_ole.ole01,"",STATUS,"","sel ola",1)  #No.FUN-660116
                NEXT FIELD ole01
             ELSE
                #-----modify by kammy 99/05/14
                IF l_ola.ola40='Y' THEN
                   CALL cl_err(g_ole.ole01,'axr-369',0) 
                   EXIT INPUT
                END IF
                IF l_ola.olaconf='N' THEN
                   CALL cl_err(g_ole.ole01,'9029',1)    #No:8887
                   EXIT INPUT
                END IF
                ##---------
                IF l_ola.ola09 IS NULL THEN LET l_ola.ola09=0 END IF
                IF cl_null(g_ole.ole07) THEN LET g_ole.ole07=l_ola.ola09 END IF
                LET g_ole.ole12 = l_ola.ola32 #科目類別
                LET g_ole.ole15 = l_ola.ola06 #幣別
                LET g_ole.ole11 = l_ola.ola07 #匯率
                LET g_ole.ole03 = l_ola.ola24 #開狀日
                LET g_ole.ole06 = l_ola.ola15 #收款條件
                LET g_ole.ole04 = l_ola.ola14 #有效日
                LET g_ole.ole05 = l_ola.ola25 #裝船日
                LET g_ole.ole31 = l_ola.ola41 #FUN-A60056
                DISPLAY BY NAME g_ole.ole12,g_ole.ole15,g_ole.ole11,
                                g_ole.ole03,g_ole.ole04,g_ole.ole05,
                                g_ole.ole06,g_ole.ole07
             END IF
          END IF
    #    BEFORE FIELD ole09
    #      DISPLAY "BEFORE FIELD ole09"
          IF cl_null(g_ole.ole02) OR g_ole.ole02 = 0 THEN
             SELECT max(ole02)+1 INTO g_ole.ole02
               FROM ole_file WHERE ole01 = g_ole.ole01
             IF cl_null(g_ole.ole02) THEN LET g_ole.ole02 = 1 END IF
             DISPLAY BY NAME g_ole.ole02
          END IF
          IF NOT cl_null(g_ole.ole02) THEN
             IF g_ole.ole02 != g_ole_t.ole02 OR g_ole_t.ole02 IS NULL THEN
                SELECT count(*) INTO l_n FROM ole_file
                 WHERE ole01 = g_ole.ole01 AND ole02 = g_ole.ole02
                IF l_n > 0 THEN
                   LET g_ole.ole02 = g_ole_t.ole02
                   CALL cl_err('',-239,0)
                   NEXT FIELD ole02
                END IF
                IF g_ole.ole02 >=1 THEN
                   SELECT count(*) INTO l_n FROM ole_file
                    WHERE ole01=g_ole.ole01 AND ole02<g_ole.ole02 AND oleconf='N'
                   IF l_n <> 0 THEN
                      LET g_ole.ole02 = g_ole_t.ole02
                      CALL cl_err(g_ole.ole01,'axm-184',0)
                      DISPLAY BY NAME g_ole.ole02
                      NEXT FIELD ole01
                   END IF
               END IF
             END IF
          END IF
 
       #start FUN-670088 add
        AFTER FIELD ole32   #部門
           IF NOT cl_null(g_ole.ole32) THEN
              SELECT gem02 INTO g_buf FROM gem_file
               WHERE gem01=g_ole.ole32
                 AND gemacti='Y'   #NO:6950
                 AND gem05 = 'Y'   #No.MOD-530272
              IF STATUS THEN
                 CALL cl_err3("sel","gem_file",g_ole.ole32,"","agl-202","","sel gem",1)
                 NEXT FIELD ole32
              END IF
              CALL t201_ole32(p_cmd)       #No.MOD-490461
              IF STATUS THEN
                 CALL cl_err('select gem',STATUS,0)
                 NEXT FIELD ole32
              END IF
              LET g_ole.ole930=s_costcenter(g_ole.ole32)
              DISPLAY BY NAME g_ole.ole930
              DISPLAY s_costcenter_desc(g_ole.ole930) TO FORMONLY.gem02b
           END IF
 
        AFTER FIELD ole930   #成本中心
           IF NOT s_costcenter_chk(g_ole.ole930) THEN
              LET g_ole.ole930=NULL
              DISPLAY BY NAME g_ole.ole930
              DISPLAY NULL TO FORMONLY.gem02b
              NEXT FIELD ole930
           ELSE
              DISPLAY s_costcenter_desc(g_ole.ole930) TO FORMONLY.gem02b
           END IF
       #end FUN-670088 add
 
        AFTER FIELD ole06
          DISPLAY "AFTER FIELD ole06"
          IF NOT cl_null(g_ole.ole06) THEN
             SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_ole.ole06
             IF STATUS THEN
#               CALL cl_err('select oag',STATUS,1)    #No.FUN-660116
                CALL cl_err3("sel","oag_file",g_ole.ole06,"",STATUS,"","select oag",1)  #No.FUN-660116
                NEXT FIELD ole06
             END IF
             ERROR g_buf
          END IF
        AFTER FIELD ole07
          DISPLAY "AFTER FIELD ole07"
          IF cl_null(g_ole.ole07) THEN
             LET g_ole.ole07 = 0
             DISPLAY BY NAME g_ole.ole07
          END IF
          IF NOT cl_null(g_ole.ole07) THEN
             SELECT ola09 INTO l_ola09 FROM ola_file WHERE ola01 = g_ole.ole01
                                                      AND olaconf !='X'#010806增
             LET g_ole.ole10 = g_ole.ole07 - l_ola09
             DISPLAY BY NAME g_ole.ole10
          END IF
        AFTER FIELD ole12
          DISPLAY "AFTER FIELD ole12"
          IF NOT cl_null(g_ole.ole12) THEN
             SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_ole.ole12
             IF STATUS THEN
#               CALL cl_err('select ool',STATUS,0)    #No.FUN-660116
                CALL cl_err3("sel","ool_file",g_ole.ole12,"",STATUS,"","select ool",1)  #No.FUN-660116
                NEXT FIELD ole12
             END IF
          END IF
 
       AFTER FIELD ole15
          DISPLAY "AFTER FIELD ole15"
          IF NOT cl_null(g_ole.ole15) THEN
             LET g_buf = NULL
             SELECT azi02 INTO g_buf FROM azi_file WHERE azi01=g_ole.ole15
             IF SQLCA.SQLCODE THEN
#               CALL cl_err('select azi',STATUS,0)   #No.FUN-660116
                CALL cl_err3("sel","azi_file",g_ole.ole15,"",STATUS,"","select azi",1)  #No.FUN-660116
                NEXT FIELD ole15 
             END IF
             IF g_ole.ole11 IS NULL THEN
                CALL s_curr3(g_ole.ole15,g_ole.ole02,g_ooz.ooz17)
                RETURNING g_ole.ole11
                DISPLAY BY NAME g_ole.ole11
             END IF
          END IF
 
       #FUN-850038     ---start---
       AFTER FIELD oleud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD oleud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #FUN-850038     ----end----
 
 
       AFTER INPUT   #97/05/22 modify
          LET g_ole.oleuser = s_get_data_owner("ole_file") #FUN-C10039
          LET g_ole.olegrup = s_get_data_group("ole_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF
 
       ON ACTION default_date                    # default today
          CASE
              WHEN INFIELD(ole09)
                LET g_ole.ole09 = g_today
                DISPLAY BY NAME g_ole.ole09
                NEXT FIELD ole09
              WHEN INFIELD(ole03)
                LET g_ole.ole03 = g_today
                DISPLAY BY NAME g_ole.ole03
                NEXT FIELD ole03
              WHEN INFIELD(ole04)
                LET g_ole.ole04 = g_today
                DISPLAY BY NAME g_ole.ole04
                NEXT FIELD ole04
              WHEN INFIELD(ole05)
                LET g_ole.ole05 = g_today
                DISPLAY BY NAME g_ole.ole05
                NEXT FIELD ole05
          END CASE
 
        ON ACTION controlp   #ok
             CASE
                WHEN INFIELD(ole01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ola"
                     LET g_qryparam.default1 = g_ole.ole01
                     CALL cl_create_qry() RETURNING g_ole.ole01
#                     CALL FGL_DIALOG_SETBUFFER( g_ole.ole01 )
                     DISPLAY BY NAME g_ole.ole01
                     NEXT FIELD ole01
                WHEN INFIELD(ole06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oag"
                     LET g_qryparam.default1 = g_ole.ole06
                     CALL cl_create_qry() RETURNING g_ole.ole06
#                     CALL FGL_DIALOG_SETBUFFER( g_ole.ole06 )
                     DISPLAY BY NAME g_ole.ole06
                     NEXT FIELD ole06
               WHEN INFIELD(ole12)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ool"
                     LET g_qryparam.default1 = g_ole.ole12
                     CALL cl_create_qry() RETURNING g_ole.ole12
#                     CALL FGL_DIALOG_SETBUFFER( g_ole.ole12 )
                     DISPLAY BY NAME g_ole.ole12
                     NEXT FIELD ole12
              #start FUN-670088 add
               WHEN INFIELD(ole32)    #部門
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem1"
                     LET g_qryparam.default1 = g_ole.ole32
                     CALL cl_create_qry() RETURNING g_ole.ole32
                     DISPLAY BY NAME g_ole.ole32
                     NEXT FIELD ole32
               WHEN INFIELD(ole930)   #成本中心
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gem4"
                     CALL cl_create_qry() RETURNING g_ole.ole930
                     DISPLAY BY NAME g_ole.ole930
                     NEXT FIELD ole930
              #end FUN-670088 add
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t201_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680123 VARCHAR(01)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ole01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t201_set_no_entry(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1       #No.FUN-680123  VARCHAR(01)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ole01",FALSE)
    END IF
END FUNCTION
 
#start FUN-670088 add
FUNCTION t201_ole32(p_cmd)  #部門名稱
   DEFINE p_cmd     LIKE type_file.chr1       #No.FUN-680123 VARCHAR(01)
   DEFINE l_gem02   LIKE gem_file.gem02
 
   LET g_errno = ' '
   LET l_gem02 = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_ole.ole32
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg-3097'
                                  LET l_gem02 = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02a
   END IF
 
END FUNCTION
#end FUN-670088 add
 
FUNCTION t201_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ole.* TO NULL              #No.FUN-6B0042
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t201_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_ole.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ole.* TO NULL
    ELSE
        OPEN t201_count
        FETCH t201_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t201_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t201_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1),               #處理方式
    l_abso          LIKE type_file.num10       #No.FUN-680123 INTEGER                #絕對的筆數
 
    CASE p_flag
       WHEN 'N' FETCH NEXT     t201_cs INTO g_ole.ole01,g_ole.ole02
       WHEN 'P' FETCH PREVIOUS t201_cs INTO g_ole.ole01,g_ole.ole02
       WHEN 'F' FETCH FIRST    t201_cs INTO g_ole.ole01,g_ole.ole02
       WHEN 'L' FETCH LAST     t201_cs INTO g_ole.ole01,g_ole.ole02
       WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
        FETCH ABSOLUTE g_jump t201_cs INTO g_ole.ole01,g_ole.ole02
        LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)
        INITIALIZE g_ole.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01 AND ole02=g_ole.ole02 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)   #No.FUN-660116
       CALL cl_err3("sel","ole_file",g_ole.ole01,g_ole.ole02,SQLCA.sqlcode,"","",1)  #No.FUN-660116
       INITIALIZE g_ole.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_ole.oleuser     #No.FUN-4C0049
       LET g_data_group = g_ole.olegrup     #No.FUN-4C0049
       CALL t201_show()
    END IF
END FUNCTION
 
FUNCTION t201_show()
    LET g_ole_t.* = g_ole.*                #保存單頭舊值
    SELECT ola05 INTO g_ola05 FROM ola_file WHERE ola01 = g_ole.ole01
                                              AND olaconf !='X' #010806 增
    IF STATUS THEN 
#      CALL cl_err('sel ola',STATUS,1) #No.FUN-660116
       CALL cl_err3("sel","ola_file",g_ole.ole01,"",STATUS,"","sel ola",1)  #No.FUN-660116
       RETURN 
    END IF
    DISPLAY BY NAME g_ole.oleoriu,g_ole.oleorig,
       g_ole.ole01,g_ole.ole02,g_ole.ole09,
       g_ole.ole32,g_ole.ole930,   #FUN-670088 add
       g_ole.ole15,g_ole.ole11,g_ole.ole03,g_ole.ole04,g_ole.ole05,g_ole.ole12,
       g_ole.ole06,g_ole.ole07,g_ole.ole10,
       g_ole.ole14,g_ole.ole13,
       g_ole.ole28,g_ole.ole29,
       g_ole.oleconf,g_ole.ole30,
       g_ole.ole081,
       g_ole.oleuser,g_ole.olegrup,g_ole.olemodu,g_ole.oledate,
       #FUN-850038     ---start---
       g_ole.oleud01,g_ole.oleud02,g_ole.oleud03,g_ole.oleud04,
       g_ole.oleud05,g_ole.oleud06,g_ole.oleud07,g_ole.oleud08,
       g_ole.oleud09,g_ole.oleud10,g_ole.oleud11,g_ole.oleud12,
       g_ole.oleud13,g_ole.oleud14,g_ole.oleud15 
       #FUN-850038     ----end----
   #start FUN-670088 add
    CALL t201_ole32('d')
    DISPLAY s_costcenter_desc(g_ole.ole930) TO FORMONLY.gem02b
   #end FUN-670088 add
    #CKP
    #CALL cl_set_field_pic(g_ole.oleconf,"","","","","")  #CHI-C80041
    IF g_ole.oleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_ole.oleconf,"","","",g_void,"")  #CHI-C80041
    CALL t201_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t201_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ole.ole01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                          AND ole02 = g_ole.ole02
    IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
    IF g_ole.oleconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ole.ole28='Y'   THEN CALL cl_err('','axr-355',0) RETURN END IF
    IF g_ole.ole02 = 0 THEN RETURN END IF
    BEGIN WORK
 
    OPEN t201_cl USING g_ole.ole01,g_ole.ole02
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_ole.*
    IF STATUS THEN CALL cl_err('sel ole',STATUS,0) ROLLBACK WORK RETURN END IF
    CALL t201_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ole01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ole02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ole.ole01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ole.ole02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete ole,olf!"
       DELETE FROM ole_file WHERE ole01 = g_ole.ole01 AND ole02 = g_ole.ole02
       IF SQLCA.SQLERRD[3]=0
#           THEN CALL cl_err('No ole deleted','',0)   #No.FUN-660116
            THEN CALL cl_err3("del","ole_file",g_ole.ole01,g_ole.ole02,"","","No ole deleted",1)  #No.FUN-660116
               ROLLBACK WORK RETURN
       END IF
       DELETE FROM olf_file WHERE olf01 = g_ole.ole01 AND olf011 = g_ole.ole02
       #----modify by kammy (必須依序號刪除，否則會刪到別的)----#
       DELETE FROM npp_file WHERE npp01 = g_ole.ole01
                              AND nppsys= 'AR'
                              AND npp00 = 42
                              AND npp011= g_ole.ole02
       DELETE FROM npq_file WHERE npq01 = g_ole.ole01
                              AND npqsys= 'AR'
                              AND npq00 = 42
                              AND npq011= g_ole.ole02
     #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = g_ole.ole01
     #FUN-B40056--add--end--
       #---------------------------------------------------------#
       CLEAR FORM
       CALL g_olf.clear()
       INITIALIZE g_ole.* TO NULL
       MESSAGE ""
       OPEN t201_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t201_cl
          CLOSE t201_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       FETCH t201_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t201_cl
          CLOSE t201_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t201_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t201_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t201_fetch('/')
       END IF
 
    END IF
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #No.FUN-680123 SMALLINT,              #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,       #No.FUN-680123 SMALLINT,			   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,       #No.FUN-680123 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1),               #處理狀態
    l_b2      	    LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(30),
    l_flag          LIKE type_file.num10,      #No.FUN-680123 INTEGER,
    l_oeb           RECORD LIKE oeb_file.*,
    l_allow_insert  LIKE type_file.num5,       #No.FUN-680123 SMALLINT,              #可新增否
    l_allow_delete  LIKE type_file.num5        #No.FUN-680123 SMALLINT               #可刪除否
 DEFINE l_oea01     LIKE oea_file.oea01        #FUN-A60056

    LET g_action_choice = ""
    IF g_ole.ole01 IS NULL THEN RETURN END IF
    IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
    IF g_ole.oleconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ole.ole02 = 0 THEN RETURN END IF
    SELECT COUNT(*) INTO l_n FROM olf_file
     WHERE olf01 = g_ole.ole01 AND olf011 = g_ole.ole02
    IF l_n = 0 THEN
       #No:9591
       IF cl_confirm('axr-321') THEN
          CALL t201_g_b()
          CALL t201_b_fill('1=1')
       END IF
       #No:9591 end
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM olf_file ",
                       "  WHERE olf01  =? ",
                       "   AND olf011 =? ",
                       "   AND olf02  =? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t201_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_olf WITHOUT DEFAULTS FROM s_olf.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        #No.FUN-550071 --start--
           CALL cl_set_docno_format("ola01")
        #No.FUN-550071 ---end---
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t201_cl USING g_ole.ole01,g_ole.ole02
            IF STATUS THEN
               CALL cl_err("OPEN t201_cl:", STATUS, 1)
               CLOSE t201_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t201_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET g_olf_t.* = g_olf[l_ac].*  #BACKUP
                LET p_cmd='u'
                OPEN t201_bcl USING g_ole.ole01,g_ole.ole02,g_olf_t.olf02
                IF STATUS THEN
                   CALL cl_err("OPEN t201_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                   CLOSE t201_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t201_bcl INTO b_olf.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock olf',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL t201_b_move_to()
                      LET g_olf[l_ac].gem02=s_costcenter_desc(g_olf[l_ac].olf930)   #FUN-670088 add
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL t201_b_move_back()
            INSERT INTO olf_file VALUES(b_olf.*)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins olf',SQLCA.sqlcode,0)   #No.FUN-660116
               CALL cl_err3("ins","olf_file",b_olf.olf01,b_olf.olf02,SQLCA.sqlcode,"","ins olf",1)  #No.FUN-660116
               CANCEL INSERT
            ELSE
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE 'INSERT O.K'
	       COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_olf[l_ac].* TO NULL      #900423
            LET g_olf_t.* = g_olf[l_ac].*             #新輸入資料
            LET b_olf.olf01 = g_ole.ole01
            LET b_olf.olf011 = g_ole.ole02            #No:9592
           #start FUN-670088 add
            LET g_olf[l_ac].olf930=g_ole.ole930
            LET g_olf[l_ac].gem02 =s_costcenter_desc(g_olf[l_ac].olf930)
            DISPLAY BY NAME g_olf[l_ac].olf930,g_olf[l_ac].gem02
           #end FUN-670088 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD olf02
 
        BEFORE FIELD olf02                            #default 序號
            IF g_olf[l_ac].olf02 IS NULL OR g_olf[l_ac].olf02 = 0 THEN
                SELECT max(olf02)+1 INTO g_olf[l_ac].olf02
                   FROM olf_file WHERE olf01 = g_ole.ole01 AND olf011 = g_ole.ole02   #No:9592
                IF g_olf[l_ac].olf02 IS NULL THEN
                    LET g_olf[l_ac].olf02 = 1
                END IF
            END IF
        AFTER FIELD olf02                        #check 序號是否重複
            IF NOT cl_null(g_olf[l_ac].olf02) THEN
               IF g_olf[l_ac].olf02 != g_olf_t.olf02 OR
                  g_olf_t.olf02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM olf_file
                    WHERE olf01 = g_ole.ole01 AND olf011 = g_ole.ole02
                      AND olf02 = g_olf[l_ac].olf02
                   IF l_n > 0 THEN
                       LET g_olf[l_ac].olf02 = g_olf_t.olf02
                       CALL cl_err('',-239,0) NEXT FIELD olf02
                   END IF
               END IF
            END IF
        AFTER FIELD olf04
            IF NOT cl_null(g_olf[l_ac].olf04) THEN
               IF p_cmd='a' OR g_olf[l_ac].olf04 != g_olf_t.olf04 THEN
                 #FUN-A60056--mod--str--
                 #SELECT oea01 FROM oea_file WHERE oea01=g_olf[l_ac].olf04
                  LET g_sql = "SELECT oea01 FROM ",cl_get_target_table(g_plant,'oea_file'),
                              " WHERE oea01='",g_olf[l_ac].olf04,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                  PREPARE sel_oea01 FROM g_sql
                  EXECUTE sel_oea01 INTO l_oea01
                 #FUN-A60056--mod--end
                  IF STATUS THEN
#                    CALL cl_err(g_olf[l_ac].olf04,'axr-134',1)   #No.FUN-660116
                     CALL cl_err3("sel","oea_file",g_olf[l_ac].olf04,"","axr-134","","",1)  #No.FUN-660116
                     NEXT FIELD olf04
                  END IF
                  SELECT COUNT(*) INTO l_n FROM olb_file
                   WHERE olb04 = g_olf[l_ac].olf04 AND olb01 != g_ole.ole01
                  IF l_n > 0 THEN
                     #CALL cl_err(g_olf[l_ac].olf04,'axr-314',1) NEXT FIELD olf04   #TQC-630014
                     CALL cl_err(g_olf[l_ac].olf04,'axr-110',1) NEXT FIELD olf04   #TQC-630014
                  END IF
               END IF
            END IF
        AFTER FIELD olf05
            IF NOT cl_null(g_olf[l_ac].olf05) THEN
               IF p_cmd='a' OR g_olf[l_ac].olf04 != g_olf_t.olf04 OR
                  g_olf[l_ac].olf05 != g_olf_t.olf05 THEN
                  SELECT count(*) INTO l_n FROM olf_file
                   WHERE olf01 = g_ole.ole01
                     AND olf011= g_ole.ole02
                     AND olf04 = g_olf[l_ac].olf04
                     AND olf05 = g_olf[l_ac].olf05
                  IF l_n > 0 THEN
                     LET g_olf[l_ac].olf05 = g_olf_t.olf05
                     CALL cl_err('',-239,0) NEXT FIELD olf05
                  END IF
                 #FUN-A60056--mod--str--
                 #SELECT * INTO l_oeb.* FROM oeb_file
                 # WHERE oeb01=g_olf[l_ac].olf04 AND oeb03=g_olf[l_ac].olf05
                  LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant,'oeb_file'),
                              " WHERE oeb01='",g_olf[l_ac].olf04,"'",
                              "   AND oeb03='",g_olf[l_ac].olf05,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                  PREPARE sel_oeb FROM g_sql
                  EXECUTE sel_oeb INTO l_oeb.*
                 #FUN-A60056--mod--end
                  IF STATUS THEN
#                    CALL cl_err(g_olf[l_ac].olf05,'axr-134',1)   #No.FUN-660116
                     CALL cl_err3("sel","oeb_file",g_olf[l_ac].olf04,g_olf[l_ac].olf05,"axr-134","","",1)  #No.FUN-660116
                     NEXT FIELD olf05
                  END IF
                  LET g_olf[l_ac].olf11 =l_oeb.oeb04
                  LET g_olf[l_ac].ima02 =l_oeb.oeb06
                  #LET g_olf[l_ac].olf03 =l_oeb.oeb05   #MOD-6C0033
                  LET g_olf[l_ac].olf03=l_oeb.oeb916   #MOD-6C0033
                  LET g_olf[l_ac].olf06 =l_oeb.oeb13
                  #LET g_olf[l_ac].olf07 =l_oeb.oeb12   #MOD-6C0033
                  LET g_olf[l_ac].olf07=l_oeb.oeb917    #MOD-6C0033
                  LET g_olf[l_ac].olf08 =l_oeb.oeb14
                 #start FUN-670088 add
                  LET g_olf[l_ac].olf930=l_oeb.oeb930
                  LET g_olf[l_ac].gem02 =s_costcenter_desc(g_olf[l_ac].olf930)
                  DISPLAY BY NAME g_olf[l_ac].olf930,g_olf[l_ac].gem02
                 #end FUN-670088 add
               END IF
            END IF
        AFTER FIELD olf06
            IF NOT cl_null(g_olf[l_ac].olf06) THEN
               IF g_olf[l_ac].olf06 <=0 THEN
                  NEXT FIELD olf06
               END IF
            END IF
        AFTER FIELD olf07
            IF NOT cl_null(g_olf[l_ac].olf07) THEN
               IF  g_olf[l_ac].olf07 <=0 THEN
                  NEXT FIELD olf07
               END IF
               LET g_olf[l_ac].olf07 = s_digqty(g_olf[l_ac].olf07,g_olf[l_ac].olf03)    #FUN-910088--add--
               DISPLAY BY NAME g_olf[l_ac].olf07                                        #FUN-910088--add--
            END IF
            LET g_olf[l_ac].olf08 = g_olf[l_ac].olf06 * g_olf[l_ac].olf07
            #-------------NO.MOD-5A0095 START--------------
            DISPLAY BY NAME g_olf[l_ac].olf08
            #-------------NO.MOD-5A0095 END----------------
 
        #No.FUN-850038 --start--
        AFTER FIELD olfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850038 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_olf_t.olf02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM olf_file
                 WHERE olf01 = g_ole.ole01 AND olf011= g_ole.ole02
                   AND olf02 = g_olf_t.olf02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_olf_t.olf02,SQLCA.sqlcode,0)   #No.FUN-660116
                    CALL cl_err3("del","olf_file",g_ole.ole01,g_olf_t.olf02,SQLCA.sqlcode,"","",1)  #No.FUN-660116
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            CALL t201_b_move_back()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_olf[l_ac].* = g_olf_t.*
               CLOSE t201_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_olf[l_ac].olf02,-263,1)
               LET g_olf[l_ac].* = g_olf_t.*
            ELSE
               UPDATE olf_file SET * = b_olf.*
                WHERE olf01=g_ole.ole01 AND olf011=g_ole.ole02
                  AND olf02=g_olf_t.olf02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd olf',SQLCA.sqlcode,0)   #No.FUN-660116
                  CALL cl_err3("upd","olf_file",g_ole.ole01,g_olf_t.olf02,SQLCA.sqlcode,"","upd olf",1)  #No.FUN-660116
                  LET g_olf[l_ac].* = g_olf_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
   	          COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
             LET l_ac = ARR_CURR()
             #LET l_ac_t = l_ac  #FUN-D30032
             IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_olf[l_ac].* = g_olf_t.*
                #FUN-D30032--add--str--
                ELSE
                   CALL g_olf.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30032--add--end--
                END IF
                CLOSE t201_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac  #FUN-D30032
             CLOSE t201_bcl
             COMMIT WORK
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(olf04)
               CALL q_oea(FALSE,TRUE,g_olf[l_ac].olf04,g_ola.ola05,'3')
                    RETURNING g_olf[l_ac].olf04
#               CALL FGL_DIALOG_SETBUFFER( g_olf[l_ac].olf04 )
               DISPLAY g_olf[l_ac].olf04 TO olf04
               NEXT FIELD olf04
            #start FUN-670088 add
             WHEN INFIELD(olf930)   #成本中心
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                CALL cl_create_qry() RETURNING g_olf[l_ac].olf930
                DISPLAY BY NAME g_olf[l_ac].olf930
                NEXT FIELD olf930
            #end FUN-670088 add
           END CASE
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(olf02) AND l_ac > 1 THEN
               LET g_olf[l_ac].* = g_olf[l_ac-1].*
               LET g_olf[l_ac].olf02 = NULL
               NEXT FIELD olf02
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
 
 
      END INPUT
      UPDATE ole_file SET olemodu = g_user,oledate= g_today
        WHERE ole01 = g_ole.ole01
    CLOSE t201_bcl
    COMMIT WORK
    CALL t201_delHeader()     #CHI-C30002 add
    IF cl_null(g_ole.ole01) THEN RETURN END IF #CHI-C30002若單身資料為空用戶選擇清空單頭則退出
# 新增自動確認功能 Modify by Charis 96-09-23
#    LET g_t1=g_ole.ole01[1,3]
    CALL s_get_doc_no(g_ole.ole01) RETURNING g_t1                            #No.FUN-550071
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF STATUS THEN 
#      CALL cl_err('sel ooy_file',STATUS,0)    #No.FUN-660116
       CALL cl_err3("sel","ooy_file",g_t1,"",STATUS,"","sel ooy_file",1)  #No.FUN-660116
       RETURN 
    END IF
    IF (g_ole.oleconf='Y' OR g_ooy.ooyconf='N') #單據已確認或單據不需自動確認
       THEN RETURN
    ELSE
       CALL t201_5()
       CALL t201_y()
    END IF
# -----------------
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t201_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ole.ole01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ole_file ",
                  "  WHERE ole01 LIKE '",l_slip,"%' ",
                  "    AND ole01 > '",g_ole.ole01,"'"
      PREPARE t201_pb1 FROM l_sql 
      EXECUTE t201_pb1 INTO l_cnt       
      
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
         CALL t201_x()
         IF g_ole.oleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_ole.oleconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE npp01 = g_ole.ole01
                                AND nppsys= 'AR'
                                AND npp00 = 42
                                AND npp011= g_ole.ole02
         DELETE FROM npq_file WHERE npq01 = g_ole.ole01
                                AND npqsys= 'AR'
                                AND npq00 = 42
                                AND npq011= g_ole.ole02
         DELETE FROM tic_file WHERE tic04 = g_ole.ole01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ole_file WHERE ole01 = g_ole.ole01
         INITIALIZE g_ole.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t201_g_b()
   DEFINE   l_olb  RECORD LIKE olb_file.*
    DECLARE olb_dec CURSOR FOR
       SELECT * FROM olb_file WHERE olb01 = g_ole.ole01
    IF STATUS THEN CALL cl_err('olb_dec',STATUS,1) END IF
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t201_cl USING g_ole.ole01,g_ole.ole02
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t201_cl ROLLBACK WORK RETURN
    END IF
    FOREACH olb_dec INTO l_olb.*
       IF STATUS THEN CALL cl_err('foreach',STATUS,1) EXIT FOREACH END IF
       INSERT INTO olf_file(olf01,olf011,olf02,olf03,olf04,olf05,olf06,
                            olf07,olf08,olf11,olf930,   #FUN-670088 add olf930
                            olflegal) #FUN-980011 add 
                     VALUES(l_olb.olb01,g_ole.ole02,l_olb.olb02,l_olb.olb03,
                            l_olb.olb04,l_olb.olb05,l_olb.olb06,l_olb.olb07,
                            l_olb.olb08,l_olb.olb11,l_olb.olb930,   #FUN-670088 add l_olb.olb930
                            g_legal) #FUN-980011 add
      #No.+041 010330 by plum
        #IF STATUS THEN CALL cl_err('ins olf',STATUS,1) LET g_success='N'  
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('ins olf',SQLCA.SQLCODE,1)   #No.FUN-660116
          CALL cl_err3("ins","olf_file",l_olb.olb01,l_olb.olb02,SQLCA.sqlcode,"","ins olf",1)  #No.FUN-660116
          LET g_success='N'
          EXIT FOREACH
       END IF
      #No.+041..end
    END FOREACH
    IF g_success = 'Y'
       THEN COMMIT WORK
       ELSE ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t201_b_move_to()
   LET g_olf[l_ac].olf02 = b_olf.olf02
   LET g_olf[l_ac].olf04 = b_olf.olf04
   LET g_olf[l_ac].olf05 = b_olf.olf05
   LET g_olf[l_ac].olf11 = b_olf.olf11
   LET g_olf[l_ac].olf03 = b_olf.olf03
   LET g_olf[l_ac].olf06 = b_olf.olf06
   LET g_olf[l_ac].olf07 = b_olf.olf07
   LET g_olf[l_ac].olf08 = b_olf.olf08
   LET g_olf[l_ac].olf930= b_olf.olf930   #FUN-670088 add
   #NO.FUN-850038 --start--
   LET g_olf[l_ac].olfud01 = b_olf.olfud01
   LET g_olf[l_ac].olfud02 = b_olf.olfud02
   LET g_olf[l_ac].olfud03 = b_olf.olfud03
   LET g_olf[l_ac].olfud04 = b_olf.olfud04
   LET g_olf[l_ac].olfud05 = b_olf.olfud05
   LET g_olf[l_ac].olfud06 = b_olf.olfud06
   LET g_olf[l_ac].olfud07 = b_olf.olfud07
   LET g_olf[l_ac].olfud08 = b_olf.olfud08
   LET g_olf[l_ac].olfud09 = b_olf.olfud09
   LET g_olf[l_ac].olfud10 = b_olf.olfud10
   LET g_olf[l_ac].olfud11 = b_olf.olfud11
   LET g_olf[l_ac].olfud12 = b_olf.olfud12
   LET g_olf[l_ac].olfud13 = b_olf.olfud13
   LET g_olf[l_ac].olfud14 = b_olf.olfud14
   LET g_olf[l_ac].olfud15 = b_olf.olfud15
   #NO.FUN-850038 --end--
END FUNCTION
 
FUNCTION t201_b_move_back()
   LET b_olf.olf011 = g_ole.ole02
   LET b_olf.olf02 = g_olf[l_ac].olf02
   LET b_olf.olf04 = g_olf[l_ac].olf04
   LET b_olf.olf05 = g_olf[l_ac].olf05
   LET b_olf.olf11 = g_olf[l_ac].olf11
   LET b_olf.olf03 = g_olf[l_ac].olf03
   LET b_olf.olf06 = g_olf[l_ac].olf06
   LET b_olf.olf07 = g_olf[l_ac].olf07
   LET b_olf.olf08 = g_olf[l_ac].olf08
   LET b_olf.olf930= g_olf[l_ac].olf930   #FUN-670088 add
   #No.FUN-850038 --start--
   LET b_olf.olfud01 = g_olf[l_ac].olfud01
   LET b_olf.olfud02 = g_olf[l_ac].olfud02
   LET b_olf.olfud03 = g_olf[l_ac].olfud03
   LET b_olf.olfud04 = g_olf[l_ac].olfud04
   LET b_olf.olfud05 = g_olf[l_ac].olfud05
   LET b_olf.olfud06 = g_olf[l_ac].olfud06
   LET b_olf.olfud07 = g_olf[l_ac].olfud07
   LET b_olf.olfud08 = g_olf[l_ac].olfud08
   LET b_olf.olfud09 = g_olf[l_ac].olfud09
   LET b_olf.olfud10 = g_olf[l_ac].olfud10
   LET b_olf.olfud11 = g_olf[l_ac].olfud11
   LET b_olf.olfud12 = g_olf[l_ac].olfud12
   LET b_olf.olfud13 = g_olf[l_ac].olfud13
   LET b_olf.olfud14 = g_olf[l_ac].olfud14
   LET b_olf.olfud15 = g_olf[l_ac].olfud15
   #NO.FUN-850038 --end--
   LET b_olf.olflegal = g_legal #FUN-980011 add
END FUNCTION
 
FUNCTION t201_b_askkey()
DEFINE l_wc2         LIKE type_file.chr1000    #No.FUN-680123  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON olf02,olf04,olf05,olf11,olf03,olf06,olf07,
                       olf08
                       #No.FUN-850038 --start--
                       ,olfud01,olfud02,olfud03,olfud04,olfud05
                       ,olfud06,olfud07,olfud08,olfud09,olfud10
                       ,olfud11,olfud12,olfud13,olfud14,olfud15
                       #No.FUN-850038 ---end---
                  FROM s_olf[1].olf02, s_olf[1].olf04,s_olf[1].olf05,
                       s_olf[1].olf11, s_olf[1].olf03,s_olf[1].olf06,
                       s_olf[1].olf07, s_olf[1].olf08
                       #No.FUN-850038 --start--
                       ,s_olf[1].olfud01,s_olf[1].olfud02,s_olf[1].olfud03
                       ,s_olf[1].olfud04,s_olf[1].olfud05,s_olf[1].olfud06
                       ,s_olf[1].olfud07,s_olf[1].olfud08,s_olf[1].olfud09
                       ,s_olf[1].olfud10,s_olf[1].olfud11,s_olf[1].olfud12
                       ,s_olf[1].olfud13,s_olf[1].olfud14,s_olf[1].olfud15
                       #No.FUN-850038 ---end---
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t201_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t201_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2     LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(200),
       l_tot     LIKE ole_file.ole10
 
    LET g_sql ="SELECT olf02,olf04,olf05,olf11,ima02,olf03,olf06,olf07,",
               "       olf08,olf930,'', ",   #FUN-670088 add olf930,''
               #No.FUN-850038 --start--
               "       olfud01,olfud02,olfud03,olfud04,olfud05,",
               "       olfud06,olfud07,olfud08,olfud09,olfud10,",
               "       olfud11,olfud12,olfud13,olfud14,olfud15 ", 
               #No.FUN-850038 ---end---
               " FROM olf_file,OUTER ima_file ",
               " WHERE olf01 ='",g_ole.ole01,"'",  #單頭
               "   AND olf011='",g_ole.ole02,"'",  #單頭
               "   AND ima_file.ima01 = olf_file.olf11 ",
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
    DISPLAY g_sql
 
    PREPARE t201_pb FROM g_sql
    DECLARE olf_curs                       #SCROLL CURSOR
        CURSOR FOR t201_pb
 
    CALL g_olf.clear()
    LET g_rec_b = 0
    LET l_tot = 0
    LET g_cnt = 1
    FOREACH olf_curs INTO g_olf[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_olf[g_cnt].gem02=s_costcenter_desc(g_olf[g_cnt].olf930)   #FUN-670088 add
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
       LET g_cnt=g_cnt+1
    END FOREACH
    CALL g_olf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t201_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_olf TO s_olf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #No.FUN-670047--begin
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_act_visible("entry_sheet2", TRUE)  
         ELSE
            CALL cl_set_act_visible("entry_sheet2", FALSE)  
         END IF
         #No.FUN-670047--end  
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
 
      ON ACTION next
         CALL t201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t201_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CKP
         #CALL cl_set_field_pic(g_ole.oleconf,"","","","","")  #CHI-C80041
         IF g_ole.oleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_ole.oleconf,"","","",g_void,"")  #CHI-C80041
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION fin_imp_exp_confirm #財務/進出口確認
         LET g_action_choice="fin_imp_exp_confirm"
         EXIT DISPLAY
 
      ON ACTION undo_fin_imp_exp_confirm  #財務/進出口取消確認
         LET g_action_choice="undo_fin_imp_exp_confirm"
         EXIT DISPLAY
 
      ON ACTION confirm #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION gen_entry  #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 
      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
 
      #No.FUN-670047--begin
      ON ACTION entry_sheet2 #分錄底稿
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #No.FUN-670047--end  
 
      ON ACTION carry_voucher  #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
 
      #No.FUN-670060  --Begin
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #No.FUN-670060  --End   
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0042  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#---- add in 99/05/12 NO:0134----
FUNCTION t201_5()
DEFINE l_cnt   LIKE type_file.num5       #No.FUN-680123  SMALLINT
   IF cl_null(g_ole.ole01) THEN RETURN END IF
   SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                        # AND oole011=g_ole.ole011    #No:9345 add
                                          AND ole02 = g_ole.ole02   #No.TQC-950121  #MOD-970088 mark回復
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ole.ole01
                                         AND olaconf !='X' #010806增
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM olf_file
    WHERE olf01= g_ole.ole01
      AND olf011= g_ole.ole02
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #bugno:7341 end......................................................
 
   IF g_ola.ola40='Y' THEN CALL cl_err(g_ola.ola01,'axr-248',0) RETURN END IF
   IF g_ole.ole28 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF NOT cl_confirm('axr-357') THEN RETURN END IF
   #更新確認碼、確認者:ala37,ala38
   BEGIN WORK
 
   OPEN t201_cl USING g_ole.ole01,g_ole.ole02
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t201_cl ROLLBACK WORK RETURN
   END IF
   UPDATE ole_file SET ole28 = 'Y',ole29 = g_user WHERE ole01 = g_ole.ole01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd oleconf',SQLCA.SQLCODE,1)   #No.FUN-660116
      CALL cl_err3("upd","ole_file",g_ole.ole01,"",SQLCA.sqlcode,"","upd oleconf",1)  #No.FUN-660116
      LET g_ole.ole28 = 'N'
      LET g_ole.ole29 = g_user
      ROLLBACK WORK
   ELSE
      LET g_ole.ole28 = 'Y'
      LET g_ole.ole29 = g_user
      COMMIT WORK
   END IF
   DISPLAY BY NAME g_ole.ole28,g_ole.ole29
END FUNCTION
 
FUNCTION t201_6()
   IF cl_null(g_ole.ole01) THEN RETURN END IF
   SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                         AND ole02 = g_ole.ole02   #TQC-B20147 add
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ole.ole01
                                         AND olaconf !='X' #010806增
   IF g_ola.ola40='Y' THEN CALL cl_err(g_ola.ola01,'axr-248',0) RETURN END IF
   IF g_ole.ole28 = 'N' THEN CALL cl_err('','axr-356',0) RETURN END IF
   #IF g_ole.oleconf = 'Y' THEN CALL cl_err('conf=Y ','aap-901',0) RETURN END IF
   IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
   IF g_ole.oleconf = 'Y' THEN CALL cl_err('conf=Y ',9023,0) RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t201_cl USING g_ole.ole01,g_ole.ole02
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t201_cl ROLLBACK WORK RETURN
   END IF
   #更新確認碼、確認者
   UPDATE ole_file SET ole28 = 'N',ole29 = g_user WHERE ole01 = g_ole.ole01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd oleconf',SQLCA.SQLCODE,1)   #No.FUN-660116
      CALL cl_err3("upd","ole_file",g_ole.ole01,"",SQLCA.sqlcode,"","upd oleconf",1)  #No.FUN-660116
      LET g_ole.ole28 = 'Y'
      LET g_ole.ole29 = g_user
      ROLLBACK WORK
   ELSE
      LET g_ole.ole28 = 'N'
      LET g_ole.ole29 = g_user
      COMMIT WORK
   END IF
   DISPLAY BY NAME g_ole.ole28,g_ole.ole29
END FUNCTION
#----------(end)
FUNCTION t201_y() 		  #確認
   DEFINE  l_ole30_o      LIKE ole_file.ole30
   DEFINE  l_count        LIKE type_file.num5       #No.FUN-680123 SMALLINT
   DEFINE  l_cnt          LIKE type_file.num5       #No.FUN-680123 SMALLINT
   DEFINE  l_n            LIKE type_file.num5       #No.FUN-680123 SMALLINT
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
 
   IF g_ole.ole01 IS NULL THEN RETURN END IF
#CHI-C30107 -------------- add ------------- begin
   IF g_ole.ole02 = 0 THEN RETURN END IF
   IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
   IF g_ole.oleconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM olf_file
    WHERE olf01 = g_ole.ole01
      AND olf011= g_ole.ole02
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_count FROM ole_file WHERE ole01=g_ole.ole01
                                   AND ole02 < g_ole.ole02 AND oleconf = 'N'
   IF l_count<>0 THEN  ##確認應判斷是否還有較少之序號未確認
      CALL cl_err('','axr-401',0)
      RETURN
   END IF
   IF g_ole.ole28='N'   THEN CALL cl_err('','axr-356',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------------- add ------------- end
   SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                         AND ole02 = g_ole.ole02
   IF g_ole.ole02 = 0 THEN RETURN END IF
   IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
   IF g_ole.oleconf='Y' THEN RETURN END IF
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM olf_file
    WHERE olf01 = g_ole.ole01
      AND olf011= g_ole.ole02
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #bugno:7341 end......................................................
  #### 96-09-23 By Charis
   SELECT COUNT(*) INTO l_count FROM ole_file WHERE ole01=g_ole.ole01
                                   AND ole02 < g_ole.ole02 AND oleconf = 'N'
   IF l_count<>0 THEN  ##確認應判斷是否還有較少之序號未確認
      CALL cl_err('','axr-401',0)
      RETURN
   END IF
   IF g_ole.ole28='N'   THEN CALL cl_err('','axr-356',0) RETURN END IF
#   LET g_t1=g_ole.ole01[1,3]
   CALL s_get_doc_no(g_ole.ole01) RETURNING g_t1                            #No.FUN-550071
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   LET g_success = 'Y'
   #No.FUN-740009 --begin
   CALL s_get_bookno(YEAR(g_ole.ole09)) RETURNING l_flag,l_bookno1,l_bookno2  
   IF l_flag = '1' THEN
      CALL cl_err(YEAR(g_ole.ole09),'aoo-081',1)
      LET g_success = 'N'
   END IF
   #No.FUN-740009 --end
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN  #No.FUN-670060
      #No.FUN-670047--begin
#     CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02)   #-->NO:0151
#     CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'0')         #No.FUN-740009
      CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'0',l_bookno1)         #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#        CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'1')       #No.FUN-740009
         CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'1',l_bookno2)       #No.FUN-740009
      END IF
      #No.FUN-670047--end  
   END IF
   IF g_success='N' THEN RETURN END IF
   BEGIN WORK
 
   OPEN t201_cl USING g_ole.ole01,g_ole.ole02
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t201_cl ROLLBACK WORK RETURN
   END IF
   LET l_ole30_o = g_ole.ole30
   #No.FUN-670060  --Begin
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_ole.ole01
         AND npq011 = g_ole.ole02
         AND npqsys = 'AR'
         AND npq00 = 42
      IF l_n = 0 THEN
#        CALL t201_gen_glcr(g_ole.*,g_ooy.*)       #No.FUN-740009
         CALL t201_gen_glcr(g_ole.*,g_ooy.*,l_bookno1,l_bookno2)       #No.FUN-740009
      END IF
      IF g_success = 'Y' THEN 
         #No.FUN-670047--begin
#        CALL s_chknpq(g_ole.ole01,'AR',0)
#        CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'0')       #No.FUN-740009
         CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'0',l_bookno1)       #No.FUN-740009
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#           CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'1')       #No.FUN-740009
            CALL s_chknpq(g_ole.ole01,'AR',g_ole.ole02,'1',l_bookno2)       #No.FUN-740009
         END IF
         #No.FUN-670047--end  
      END IF
      IF g_success = 'N' THEN RETURN END IF   #No.FUN-670047
   END IF
   #No.FUN-670060  --End  
   UPDATE ole_file SET oleconf = 'Y',ole30 = g_user
    WHERE ole01 = g_ole.ole01 AND ole02 = g_ole.ole02
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd oleconf',SQLCA.SQLCODE,1)    #No.FUN-660116
      CALL cl_err3("upd","ole_file",g_ole.ole01,g_ole.ole02,SQLCA.sqlcode,"","upd oleconf",1)  #No.FUN-660116
      LET g_success = 'N'
   END IF
   IF g_success='Y' THEN CALL t201_y1() END IF
   IF g_success = 'Y'
      THEN LET g_ole.oleconf='Y' LET g_ole.ole30 = g_user    COMMIT WORK
      ELSE LET g_ole.oleconf='N' LET g_ole.ole30 = l_ole30_o ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_ole.oleconf,g_ole.ole30
   #No.FUN-670060  --Begin
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_ole.ole01,'" AND npp011 = ',g_ole.ole02
#     LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ole.ole09,"' 'Y' '0' 'Y'"  #No.FUN-670047
     #LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ole.ole09,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.FUN-670047  #No.MOD-860075
#     LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ole.ole09,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.FUN-670047  #No.MOD-860075 #TQC-810036 Mark
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ole.oleuser,"' '",g_ole.oleuser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ole.ole09,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"    #No.TQC-810036 
      CALL cl_cmdrun_wait(g_str)
      SELECT ole14,ole13 INTO g_ole.ole14,g_ole.ole13 FROM ole_file
       WHERE ole01 = g_ole.ole01
         AND ole02 = g_ole.ole02
      DISPLAY BY NAME g_ole.ole14
      DISPLAY BY NAME g_ole.ole13
   END IF
   #No.FUN-670060  --End
   #CKP
   CALL cl_set_field_pic(g_ole.oleconf,"","","","","")
END FUNCTION
 
FUNCTION t201_y1() 		#更新相關檔案
    DEFINE l_olf      RECORD LIKE olf_file.*
    #更新信用狀單頭檔
    SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ole.ole01
                                          AND olaconf !='X' #010806增
    IF NOT cl_null(g_ole.ole03) THEN LET g_ola.ola24 = g_ole.ole03 END IF
    IF NOT cl_null(g_ole.ole04) THEN LET g_ola.ola14 = g_ole.ole04 END IF
    IF NOT cl_null(g_ole.ole05) THEN LET g_ola.ola25 = g_ole.ole05 END IF
    IF NOT cl_null(g_ole.ole06) THEN LET g_ola.ola15 = g_ole.ole06 END IF
    IF NOT cl_null(g_ole.ole07) AND g_ole.ole07 != 0 THEN
       LET g_ola.ola09 = g_ole.ole07
    END IF
    #---97/08/26 modify
    UPDATE ola_file SET ola09 = g_ola.ola09, ola14 = g_ola.ola14,
                        ola15 = g_ola.ola15, ola24 = g_ola.ola24,
                        ola25 = g_ola.ola25, ola011= g_ole.ole02
                  WHERE ola01 = g_ole.ole01
   #No.+041 010330 by plum
   #IF STATUS THEN CALL cl_err('upd ola',STATUS,1) LET g_success='N' END IF
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('upd ola',SQLCA.SQLCODE,1)   #No.FUN-660116
       CALL cl_err3("upd","ola_file",g_ole.ole01,"",SQLCA.sqlcode,"","upd ola",1)  #No.FUN-660116
       LET g_success='N'
    END IF
   #No.+041..end
 
    #更新信用狀單身檔
    DECLARE olf_cur CURSOR FOR
     SELECT * FROM olf_file WHERE olf01=g_ole.ole01 AND olf011=g_ole.ole02
    IF STATUS THEN CALL cl_err('olf_cur',STATUS,1) LET g_success='N' END IF
    FOREACH olf_cur INTO l_olf.*
       IF STATUS THEN
          CALL cl_err('foreach',STATUS,1) LET g_success='N'
          EXIT FOREACH
       END IF
       UPDATE olb_file SET olb03 = l_olf.olf03,olb04 = l_olf.olf04,
                           olb05 = l_olf.olf05,olb06 = l_olf.olf06,
                           olb07 = l_olf.olf07,olb08 = l_olf.olf08,
                           olb11 = l_olf.olf11
        WHERE olb01 = l_olf.olf01 AND olb02 = l_olf.olf02
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          INSERT INTO olb_file(olb01,olb02,olb03,olb04,olb05,olb06,olb07,
                               olb08,olb09,olb10,olb11,
                               olblegal) #FUN-980011 add
                        VALUES(l_olf.olf01,l_olf.olf02,l_olf.olf03,
                               l_olf.olf04,l_olf.olf05,l_olf.olf06,
                               l_olf.olf07,l_olf.olf08,0,0,l_olf.olf11,
                               g_legal) #FUN-980011 add
         #No.+041 010330 by plum
           #IF STATUS THEN CALL cl_err('ins olb',STATUS,1) LET g_success='N' 
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('ins olb',SQLCA.SQLCODE,1)   #No.FUN-660116
             CALL cl_err3("ins","olb_file",l_olf.olf01,l_olf.olf02,SQLCA.sqlcode,"","ins olb",1)  #No.FUN-660116
             LET g_success='N'
          END IF
         #No.+041..end
       END IF
       #更新訂單檔
       #-----97/08/25 modify by sophia
        IF NOT cl_null(g_ole.ole06) THEN
          #FUN-A60056--mod--str--
          #UPDATE oea_file SET oea32 = g_ole.ole06 WHERE oea01 = l_olf.olf04
           LET g_sql = "UPDATE ",cl_get_target_table(g_plant,'oea_file'),
                       "   SET oea32 = '",g_ole.ole06,"'",
                       " WHERE oea01 = '",l_olf.olf04,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
           PREPARE upd_oea FROM g_sql
           EXECUTE upd_oea 
          #FUN-A60056--mod--end
          #No.+041 010330 by plum
            #IF STATUS THEN CALL cl_err('upd oea',STATUS,1) LET g_success='N'  
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd oea',SQLCA.SQLCODE,1)   #No.FUN-660116
             CALL cl_err3("upd","oea_file",l_olf.olf04,"",SQLCA.sqlcode,"","upd oea",1)  #No.FUN-660116
             LET g_success='N'
             EXIT FOREACH
          END IF
         #No.+041..end
        END IF
      #---------------------
    END FOREACH
END FUNCTION
 
FUNCTION t201_z() 		#取消確認	
   DEFINE  l_ole30_o      LIKE ole_file.ole30
   DEFINE  l_count        LIKE type_file.num5   #No.FUN-680123 SMALLINT
   DEFINE  l_aba19        LIKE aba_file.aba19   #No.FUN-670060
   DEFINE  l_sql          LIKE type_file.chr1000#No.FUN-680123 VARCHAR(1000)            #No.FUN-670060
   DEFINE  l_dbs          STRING                #No.FUN-670060
 
 
   IF g_ole.ole01 IS NULL THEN RETURN END IF
   SELECT * INTO g_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                         AND ole02 = g_ole.ole02
   IF g_ole.ole02 = 0 THEN RETURN END IF
   IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
   IF g_ole.oleconf='N' THEN RETURN END IF
   IF g_ole.ole28='N'   THEN CALL cl_err('','axr-356',0) RETURN END IF
  #### 96-09-23 By Charis
   SELECT COUNT(*) INTO l_count FROM ole_file WHERE ole01=g_ole.ole01
                                   AND ole02 > g_ole.ole02 AND oleconf = 'Y'
   IF l_count<>0 THEN   ##取消確認應判斷最大修改序號才可以
      CALL cl_err('','axr-400',0)
      RETURN
   END IF
   #No.FUN-670060  --Begin
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_ole.ole01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_ole.ole14) OR NOT cl_null(g_ole.ole13) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL cl_err(g_ole.ole01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p 
      #CALL s_getdbs()             #FUN-A50102
      #LET l_dbs=g_dbs_new         #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_ole.ole14,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_ole.ole14,'axr-071',1)
         RETURN
      END IF
   END IF
   #No.FUN-670060  --End   
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success = 'Y'

   #CHI-C90052 begin---
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ole.ole14,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT ole14,ole13 INTO g_ole.ole14,g_ole.ole13 FROM ole_file
       WHERE ole01 = g_ole.ole01
         AND ole02 = g_ole.ole02
      IF NOT cl_null( g_ole.ole14) THEN
         CALL cl_err(g_ole.ole14,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_ole.ole14
      DISPLAY BY NAME g_ole.ole13
   END IF
   #CHI-C90052 end-----

   BEGIN WORK
 
   OPEN t201_cl USING g_ole.ole01,g_ole.ole02
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t201_cl INTO g_ole.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t201_cl ROLLBACK WORK RETURN
   END IF
   LET l_ole30_o = g_ole.ole30
   UPDATE ole_file SET oleconf = 'N',ole30 = g_user  #TQC-C20288   #FUN-D20058 remark
 # UPDATE ole_file SET oleconf = 'N',ole30 = ''       #TQC-C20288  #FUN-D20058 mark
    WHERE ole01 = g_ole.ole01 AND ole02 = g_ole.ole02
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd oleconf',SQLCA.SQLCODE,1)    #No.FUN-660116
      CALL cl_err3("upd","ole_file",g_ole.ole01,g_ole.ole02,SQLCA.sqlcode,"","upd oleconf",1)  #No.FUN-660116
      LET g_success = 'N'
   END IF
   IF g_success='Y' THEN CALL t201_z1() END IF
   CALL s_showmsg()                     #NO.FUN-710050
   IF g_success = 'Y'
      THEN LET g_ole.oleconf='N' LET g_ole.ole30 = g_user COMMIT WORK   #TQC-C20288   #FUN-D20058 remark
    # THEN LET g_ole.oleconf='N' LET g_ole.ole30 = '' COMMIT WORK        #TQC-C20288   #FUN-D20058 mark
      ELSE LET g_ole.oleconf='Y' LET g_ole.ole30 = l_ole30_o ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_ole.oleconf,g_ole.ole30

   #CHI-C90052 mark begin---
   ##No.FUN-670060  --Begin
   #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ole.ole14,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT ole14,ole13 INTO g_ole.ole14,g_ole.ole13 FROM ole_file
   #    WHERE ole01 = g_ole.ole01
   #      AND ole02 = g_ole.ole02
   #   DISPLAY BY NAME g_ole.ole14
   #   DISPLAY BY NAME g_ole.ole13
   #END IF
   ##No.FUN-670060  --End
   #CHI-C90052 mark end-----
   
   #CKP
   CALL cl_set_field_pic(g_ole.oleconf,"","","","","")
END FUNCTION
 
#-------NO:0134------
FUNCTION t201_z1()              #更新相關檔案: 取(ole02-1)之資料去update ola01
    DEFINE l_ole      RECORD LIKE ole_file.*
    DEFINE l_olf      RECORD LIKE olf_file.*
    DEFINE g_ole02           LIKE ole_file.ole02
 
    #更新信用狀單頭檔
    LET g_ole02=g_ole.ole02-1
    SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ole.ole01
                                          AND olaconf !='X' #010806 增
    SELECT * INTO l_ole.* FROM ole_file WHERE ole01 = g_ole.ole01
                                          AND ole02 = g_ole02
    IF NOT cl_null(l_ole.ole03) THEN LET g_ola.ola24 = l_ole.ole03 END IF
    IF NOT cl_null(l_ole.ole04) THEN LET g_ola.ola14 = l_ole.ole04 END IF
    IF NOT cl_null(l_ole.ole05) THEN LET g_ola.ola25 = l_ole.ole05 END IF
    IF NOT cl_null(l_ole.ole06) THEN LET g_ola.ola15 = l_ole.ole06 END IF
    IF NOT cl_null(l_ole.ole07) AND l_ole.ole07 != 0 THEN
       LET g_ola.ola09 = l_ole.ole07
    END IF
    #---97/08/26 modify
    UPDATE ola_file SET ola09 = g_ola.ola09, ola14 = g_ola.ola14,
                        ola15 = g_ola.ola15, ola24 = g_ola.ola24,
                        ola25 = g_ola.ola25, ola011= g_ole02,
                        ola271=l_ole.ole081, ola272=l_ole.ole082,
                        ola273=l_ole.ole083
                  WHERE ola01 = g_ole.ole01
   #No.+041 010330 by plum
     #IF STATUS THEN CALL cl_err('upd ola',SQLCA.SQLCODE,1) LET g_success='N' 
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('upd ola',SQLCA.SQLCODE,1)   #No.FUN-660116
       CALL cl_err3("upd","ola_file",g_ole.ole01,"",SQLCA.sqlcode,"","upd ola",1)  #No.FUN-660116
       LET g_success='N'
    END IF
   #No.+041..end
    #更新信用狀單身檔
    DELETE FROM olb_file WHERE olb01=g_ole.ole01
    DECLARE olf_cur2 CURSOR FOR
     SELECT * FROM olf_file WHERE olf01=g_ole.ole01 AND olf011=g_ole02
    IF STATUS THEN CALL cl_err('olf_cur2',STATUS,1) LET g_success='N' END IF
    CALL s_showmsg_init()
    FOREACH olf_cur2 INTO l_olf.*
       IF STATUS THEN
#         CALL cl_err('foreach',STATUS,1) LET g_success='N' #NO.FUN-710050
          CALL s_errmsg('olf01',g_ole.ole01,'foreach',STATUS,1) #NO.FUN-710050
          LET g_success='N'                                       #NO.FUN-710050  
          EXIT FOREACH
       END IF
#NO.FUN-710050--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710050--END
       UPDATE olb_file SET olb03 = l_olf.olf03,olb04 = l_olf.olf04,
                           olb05 = l_olf.olf05,olb06 = l_olf.olf06,
                           olb07 = l_olf.olf07,olb08 = l_olf.olf08,
                           olb11 = l_olf.olf11
        WHERE olb01 = l_olf.olf01 AND olb02 = l_olf.olf02
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          INSERT INTO olb_file(olb01,olb02,olb03,olb04,olb05,olb06,olb07,
                               olb08,olb09,olb10,olb11,
                               olblegal) #FUN-980011 add
                        VALUES(l_olf.olf01,l_olf.olf02,l_olf.olf03,
                               l_olf.olf04,l_olf.olf05,l_olf.olf06,
                               l_olf.olf07,l_olf.olf08,0,0,l_olf.olf11,
                               g_legal) #FUN-980011 add
         #No.+041 010330 by plum
           #IF STATUS THEN CALL cl_err('ins olb',STATUS,1) LET g_success='N'  
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('ins olb',SQLCA.SQLCODE,1)   #No.FUN-660116
#            CALL cl_err3("ins","olb_file",l_olf.olf01,l_olf.olf02,SQLCA.sqlcode,"","ins olb",1)  #No.FUN-660116 #NO.FUN-710050
             LET g_showmsg=l_olf.olf01,"/",l_olf.olf02,"/",l_olf.olf04,"/",l_olf.olf05            #NO.FUN-710050   
             CALL s_errmsg('olb01,olb02,olb04,olb05',g_showmsg,'ins olb',SQLCA.SQLCODE,1)            #NO.FUN-710050
             LET g_success='N'
#            EXIT FOREACH                                                                         #NO.FUN-710050
             CONTINUE FOREACH                                                                     #NO.FUN-710050
          END IF
         #No.+041..end
       END IF
       #更新訂單檔
       #-----97/08/25 modify by sophia
        IF NOT cl_null(g_ole.ole06) THEN
          #FUN-A60056--mod--str--
          #UPDATE oea_file SET oea32 = g_ole.ole06 WHERE oea01 = l_olf.olf04
           LET g_sql = "UPDATE ",cl_get_target_table(g_plant,'oea_file'),
                       "   SET oea32 = '",g_ole.ole06,"'",
                       " WHERE oea01 = '",l_olf.olf04,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
           PREPARE upd_oea1 FROM g_sql
           EXECUTE upd_oea1
          #FUN-A60056--mod--end
         #No.+041 010330 by plum
           #IF STATUS THEN CALL cl_err('upd oea',STATUS,1) LET g_success='N'  
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd oea',SQLCA.SQLCODE,1)   #No.FUN-660116
#            CALL cl_err3("upd","oea_file",l_olf.olf04,"",SQLCA.sqlcode,"","upd oea",1)  #No.FUN-660116 #NO.FUN-710050
             CALL s_errmsg('oea01',l_olf.olf04,'upd oea',SQLCA.SQLCODE,1)              #NO.FUN-710050
             LET g_success='N'
#            EXIT FOREACH                                                                #NO.FUN-710050
             CONTINUE FOREACH                                                            #NO.FUN-710050       
          END IF
         #No.+041..end
        END IF
      #---------------------
    END FOREACH
#NO.FUN-710050--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710050--END
END FUNCTION
 
FUNCTION t201_v()
   DEFINE l_wc    LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(100)
   DEFINE l_t1    LIKE aba_file.aba00       #No.FUN-680123 VARCHAR(05)  #No.FUN-550071
   DEFINE l_ole01 LIKE ole_file.ole01
   DEFINE l_ole02 LIKE ole_file.ole02
   DEFINE l_ole09 LIKE ole_file.ole09       #No.FUN-740009
   DEFINE only_one     LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
   DEFINE ls_tmp STRING
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
 
   #------97/06/16 modify
    SELECT * INTO g_ole.* FROM ole_file
     WHERE ole01 = g_ole.ole01 AND ole02 = g_ole.ole02
    IF g_ole.ole10   = 0   THEN RETURN END IF
    IF g_ole.oleconf = 'X' THEN RETURN END IF    #CHI-C80041  
    IF g_ole.oleconf = 'Y' THEN RETURN END IF

   OPEN WINDOW t2019_w WITH FORM "axr/42f/axrt2019"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axrt2019")
 
    LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF NOT cl_null(only_one) THEN
         IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t2019_w RETURN END IF
   IF only_one = '1' THEN
      LET l_wc = " ole01 = '",g_ole.ole01,"' AND ole02 = ",g_ole.ole02
   ELSE
      CONSTRUCT BY NAME l_wc ON ole01,ole09,oleuser,olegrup
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW t2019_w
         RETURN
      END IF
   END IF
   CLOSE WINDOW t2019_w
   MESSAGE "WORKING !"
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   #FUN-B50090 add -end--------------------------
#  LET g_sql = "SELECT ole01,ole02 FROM ole_file",       #No.FUN-740009
   LET g_sql = "SELECT ole01,ole02,ole09 FROM ole_file",       #No.FUN-740009
               " WHERE ",l_wc CLIPPED,
               "   AND oleconf <> 'X' "  #CHI-C80041
   IF NOT cl_null(g_ooz.ooz09) THEN
      LET g_sql = g_sql CLIPPED," AND ole09 >'",g_ooz.ooz09,"'"
   END IF
   PREPARE t201_v_p FROM g_sql
   DECLARE t201_v_c CURSOR FOR t201_v_p
 
   LET g_success='Y' #no.5573
BEGIN WORK #no.5573
   CALL s_showmsg_init()                 #NO.FUN-710050
   FOREACH t201_v_c INTO l_ole01,l_ole02,l_ole09       #No.FUN-740009
      IF STATUS THEN EXIT FOREACH END IF
#NO.FUN-710050--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710050--END
#     LET l_t1 = l_ole01[1,3]
      CALL s_get_doc_no(l_ole01) RETURNING l_t1                            #No.FUN-550071
      SELECT ooydmy1 INTO g_chr FROM ooy_file
      WHERE ooyslip = l_t1
      IF g_chr='N' THEN CONTINUE FOREACH END IF 
      #No.FUN-740009 --begin
      CALL s_get_bookno(YEAR(l_ole09)) RETURNING l_flag,l_bookno1,l_bookno2  
      IF l_flag = '1' THEN
         CALL cl_err(YEAR(l_ole09),'aoo-081',1)
         LET g_success = 'N'
      END IF
      #No.FUN-740009 --end
      #No.FUN-670047--begin
#     CALL s_t201_gl(l_ole01,l_ole02)
#     CALL s_t201_gl(l_ole01,l_ole02,'0')       #No.FUN-740009
      CALL s_t201_gl(l_ole01,l_ole02,'0',l_bookno1)       #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#        CALL s_t201_gl(l_ole01,l_ole02,'1')       #No.FUN-740009
         CALL s_t201_gl(l_ole01,l_ole02,'1',l_bookno2)       #No.FUN-740009
      END IF
      #No.FUN-670047--end  
   END FOREACH
#NO.FUN-710050--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
  END IF                                                                          
  CALL s_showmsg()   #NO.FUN-710050
#NO.FUN-710050--END
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF #no.5573
   MESSAGE ""
END FUNCTION
 
FUNCTION t201_vc()
DEFINE l_contl  LIKE type_file.num5       #No.FUN-680123 SMALLINT
    IF g_ole.ole01 IS NULL THEN RETURN END IF
 
    # 2004/05/24
#   IF NOT cl_prich3(g_ole.oleuser,g_ole.olegrup,'U')
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
IF g_ole.ole02 = 0 THEN LET l_contl = 41 ELSE LET l_contl = 42 END IF
    #No.FUN-670047--begin
#   CALL s_fsgl('AR',l_contl,g_ole.ole01,0,g_ooz.ooz02b,g_ole.ole02,
#               g_ole.oleconf)
    CALL s_showmsg_init()               #NO.FUN-710050          
    CALL s_fsgl('AR',l_contl,g_ole.ole01,0,g_ooz.ooz02b,g_ole.ole02,
                g_ole.oleconf,'0',g_ooz.ooz02p)
    CALL s_showmsg()                    #NO.FUN-710050    
    #No.FUN-670047--end  
END FUNCTION
 
#No.FUN-670047--begin
FUNCTION t201_vc_1()
DEFINE l_contl  LIKE type_file.num5       #No.FUN-680123 SMALLINT
    IF g_ole.ole01 IS NULL THEN RETURN END IF
 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
    IF g_ole.ole02 = 0 THEN LET l_contl = 41 ELSE LET l_contl = 42 END IF
    CALL s_showmsg_init()                 #NO.FUN-710050   
    CALL s_fsgl('AR',l_contl,g_ole.ole01,0,g_ooz.ooz02c,g_ole.ole02,
                g_ole.oleconf,'1',g_ooz.ooz02p)
    CALL s_showmsg()                      #NO.FUN-710050  
END FUNCTION
#No.FUN-670047--end  
 
#No.FUN-670060  --Begin
FUNCTION t201_gen_glcr(p_ole,p_ooy,p_bookno1,p_bookno2)       #No.FUN-740009
  DEFINE p_ole     RECORD LIKE ole_file.*
  DEFINE p_ooy     RECORD LIKE ooy_file.*
  DEFINE p_bookno1 LIKE aza_file.aza81       #No.FUN-740009
  DEFINE p_bookno2 LIKE aza_file.aza82       #No.FUN-740009
 
    IF cl_null(p_ooy.ooygslp) THEN
       CALL cl_err(p_ole.ole01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    #No.FUN-670047--begin
#   CALL s_t201_gl(p_ole.ole01,p_ole.ole02)
    CALL s_t201_gl(p_ole.ole01,p_ole.ole02,'0',p_bookno1)       #No.FUN-740009
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#      CALL s_t201_gl(p_ole.ole01,p_ole.ole02,'1')       #No.FUN-740009
       CALL s_t201_gl(p_ole.ole01,p_ole.ole02,'1',p_bookno2)       #No.FUN-740009
    END IF
    #No.FUN-670047--end  
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t201_carry_voucher()
  DEFINE l_ooygslp    LIKE ooy_file.ooygslp
  DEFINE li_result    LIKE type_file.num5       #No.FUN-680123 SMALLINT 
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5       #No.FUN-680123 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_ole.ole01) RETURNING g_t1
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF g_ooy.ooydmy1 = 'N' THEN RETURN END IF
    IF g_ooy.ooyglcr = 'Y' THEN
       LET g_plant_new=g_ooz.ooz02p 
       #CALL s_getdbs()      #FUN-A50102
       #LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                   "    AND aba01 = '",g_ole.ole14,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2 
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN 
          CALL cl_err(g_ole.ole14,'aap-991',1)
          RETURN
       END IF
 
       LET l_ooygslp = g_ooy.ooygslp
    ELSE
       CALL cl_err('','aap-992',1)
       RETURN
 
#      #開窗作業
#      LET g_plant_new= g_ooz.ooz02p
#      CALL s_getdbs()
#      LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
 
#      OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
#           ATTRIBUTE (STYLE = g_win_style CLIPPED)
#      CALL cl_ui_locale("axrt200_p")
#       
#      INPUT l_ooygslp WITHOUT DEFAULTS FROM FORMONLY.gl_no
#   
#         AFTER FIELD gl_no
#            CALL s_check_no("agl",l_ooygslp,"","1","aac_file","aac01",g_dbs_gl) #No.FUN-560190
#                  RETURNING li_result,l_ooygslp
#            IF (NOT li_result) THEN
#               NEXT FIELD gl_no
#            END IF
#    
#         AFTER INPUT
#            IF INT_FLAG THEN
#               EXIT INPUT 
#            END IF
#            IF cl_null(l_ooygslp) THEN
#               CALL cl_err('','9033',0)
#               NEXT FIELD gl_no  
#            END IF
#   
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
#         ON ACTION CONTROLP
#            IF INFIELD(gl_no) THEN
#               CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_ooygslp,'1',' ',' ','AGL') 
#               RETURNING l_ooygslp
#               DISPLAY l_ooygslp TO FORMONLY.gl_no
#               NEXT FIELD gl_no
#            END IF
#   
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#    
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#    
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
#    
#         ON ACTION exit  #加離開功能genero
#            LET INT_FLAG = 1
#            EXIT INPUT
 
#      END INPUT
#      CLOSE WINDOW t200p  
    END IF
    IF cl_null(l_ooygslp) THEN
       CALL cl_err(g_ole.ole01,'axr-070',1)
       RETURN
    END IF
    #No.FUN-670047--begin
    IF g_aza.aza63 = 'Y' AND cl_null(g_ooy.ooygslp1) THEN
       CALL cl_err(g_ole.ole01,'axr-070',1)
       RETURN
    END IF
    #No.FUN-670047--end  
    LET g_wc_gl = 'npp01 = "',g_ole.ole01,'" AND npp011 = ',g_ole.ole02
#   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ole.ole09,"' 'Y' '0' 'Y'"  #No.FUN-670047
   #LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ole.ole09,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.FUN-670047  #No.MOD-860075
#   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ole.ole09,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.FUN-670047  #No.MOD-860075 #TQC-810036 Mark
    LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ole.oleuser,"' '",g_ole.oleuser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ole.ole09,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"    #No.TQC-810036
    CALL cl_cmdrun_wait(g_str)
    SELECT ole14,ole13 INTO g_ole.ole14,g_ole.ole13 FROM ole_file
     WHERE ole01 = g_ole.ole01
       AND ole02 = g_ole.ole02
    DISPLAY BY NAME g_ole.ole14
    DISPLAY BY NAME g_ole.ole13
    
END FUNCTION
 
FUNCTION t201_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_ole.ole01) RETURNING g_t1 
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1 
    IF g_ooy.ooyglcr = 'N' THEN 
       CALL cl_err('','aap-990',1) 
       RETURN 
    END IF
 
    LET g_plant_new=g_ooz.ooz02p 
    #CALL s_getdbs()        #FUN-A50102 
    #LET l_dbs=g_dbs_new    #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                "    AND aba01 = '",g_ole.ole14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_ole.ole14,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ole.ole14,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT ole14,ole13 INTO g_ole.ole14,g_ole.ole13 FROM ole_file
     WHERE ole01 = g_ole.ole01
       AND ole02 = g_ole.ole02
    DISPLAY BY NAME g_ole.ole14
    DISPLAY BY NAME g_ole.ole13
END FUNCTION
#No.FUN-670060  --End   
#Patch....NO.MOD-5A0095 <001> #
#CHI-C80041---begin
FUNCTION t201_x()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ole.ole01) OR cl_null(g_ole.ole02) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t201_cl USING g_ole.ole01,g_ole.ole02
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t201_cl INTO g_ole.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ole.ole01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t201_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_ole.oleconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_ole.oleconf)   THEN 
        LET l_chr=g_ole.oleconf
        IF g_ole.oleconf='N' THEN 
            LET g_ole.oleconf='X' 
        ELSE
            LET g_ole.oleconf='N'
        END IF
        UPDATE ole_file
            SET oleconf=g_ole.oleconf,  
                olemodu=g_user,
                oledate=g_today
            WHERE ole01=g_ole.ole01
              AND ole02=g_ole.ole02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ole_file",g_ole.ole01,"",SQLCA.sqlcode,"","",1)  
            LET g_ole.oleconf=l_chr 
        END IF
        DISPLAY BY NAME g_ole.oleconf
   END IF
 
   CLOSE t201_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ole.ole01,'V')
 
END FUNCTION
#CHI-C80041---end
