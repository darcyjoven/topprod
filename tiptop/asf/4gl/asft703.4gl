# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft703.4gl
# Descriptions...: 生產日報工單轉出維護作業
# Date & Author..: 06/08/10 By kim
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710026 07/01/26 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.MOD-750009 07/05/03 By kim 產生的工單查aecq700的工單轉入量沒有產生
# Modify.........: No.CHI-750006 07/05/08 By kim 單身無法退出，也無法回到上一行進行修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-730003 07/05/28 By kim 將列印拿掉
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/02/20 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/04/01 By hellen 修改delete sfa_file
# Modify.........: No.MOD-860022 08/06/03 By claire 產生退料時,當備料檔同作業編號有二筆時,套數會重複計算
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代時，讓sfs27=sfa27
# Modify.........: No.FUN-940008 09/05/15 By hongmei發料改善
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.FUN-A60027 10/06/17 By sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60027 10/06/23 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70125 10/07/26 By lilingyu 平行工藝整批調整
# Modify.........: No.FUN-AA0085 10/10/27 By zhangll 控制只能查询和选择属于该营运中心的仓库
# Modify.........: No.FUN-AB0054 10/11/18 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No.TQC-AC0238 10/12/17 By zhangweib 工單單別排除smy73='Y'的單別
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)
# Modify.........: No.FUN-A70095 11/07/06 By lixh1 已確認的報工單不可以刪除
# Modify.........: No:FUN-B70074 11/07/25 By lixh1 增加行業別TABLE(sfsi_file)的處理
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y'
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正  
# Modify.........; No.CHI-B80096 11/09/02 By xianghui 對組成用量(ecm62)/底數(63)/ecm66(關鍵報工點否)的預設值處理
# Modify.........: No:CHI-B80094 11/10/11 By johung 產生退料單時判斷該料倉儲批若不存在img必須新增
# Modify.........: NO.FUN-BB0085 11/12/05 By xianghui 增加數量欄位小數取位
# Modify.........: NO.FUN-BB0084 11/12/21 By lixh1 增加數量欄位小數取位(ecm_file)
# Modify.........: No:TQC-C20011 12/02/01 By lilingyu 退料單號和發料單號兩個欄位增加smy72的限定條件
# Modify.........: No:MOD-B90264 12/02/17 By bart 產生新工單製程追蹤檔，機時與工時應考慮數量的換算
# Modify.........: No:TQC-BC0081 11/12/13 By SunLM 當生產日報單已經審核,生產日報工單轉出作業不能進行取消審核 
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70100 12/07/16 By fengrui 修改程式點選維護工單按鈕down出問題
# Modify.........: No.FUN-C70014 12/08/28 By suncx 新增sfq014,sfe014,sfs014
# Modify.........: No.TQC-C90044 12/09/12 By chenjing 修改工單轉出時，刪除生成單據時工單資料刪除問題
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50116 13/05/27 By lixh1 報錯信息修改
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 修正FUN-D40103邏輯檢查 
# Modify.........: No:TQC-D50126 13/06/06 By lixh1 倉庫出錯跳到儲位欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_shj             RECORD LIKE shj_file.*,
    g_shj_o           RECORD LIKE shj_file.*,
    g_shb             RECORD LIKE shb_file.*,
    b_shj             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        shj10         LIKE shj_file.shj10,
        shj11         LIKE shj_file.shj11,
        shj12         LIKE shj_file.shj12
                      END RECORD,
    b_shj_t           RECORD                 #程式變數 (舊值)
        shj10         LIKE shj_file.shj10,
        shj11         LIKE shj_file.shj11,
        shj12         LIKE shj_file.shj12
                      END RECORD,
    m_shj             DYNAMIC ARRAY OF RECORD
        shj10         LIKE shj_file.shj10,
        shj11         LIKE shj_file.shj11,
        shj12         LIKE shj_file.shj12
                      END RECORD,                      
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_rec_b           LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    g_flag            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_ss              LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_ac              LIKE type_file.num5,          #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    g_argv1           LIKE shj_file.shj01,
    g_argv2           STRING,
    g_t1              LIKE oay_file.oayslip        #No.FUN-680121 VARCHAR(5)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680121 SMALLINT
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_cnt        LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_msg        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index LIKE type_file.num10         #No.FUN-680121 INTEGER
 
MAIN
#DEFINE
#       l_time   LIKE type_file.chr8            #No.FUN-6A0090
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW t703_w AT p_row,p_col
     WITH FORM "asf/42f/asft703"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   #FUN-A60027 ----------start----------------
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_set_comp_visible("shb012",TRUE)
   ELSE
      CALL cl_set_comp_visible("shb012",FALSE)
   END IF 
   #FUN-A60027 ---------end------------------
   CALL t703_cur1()
   CALL t703_sfa_cur()
   CALL t703_ecm_cur()
   # 先以g_argv2判斷直接執行哪種功能：
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t703_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               LET g_wc = " shj01 = '",g_argv1,"'"
               CALL t703_a()
            END IF
         OTHERWISE
            CALL t703_q()
      END CASE
   END IF
   CALL t703_menu()
 
   CLOSE WINDOW t703_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
#QBE 查詢資料
FUNCTION t703_cs()
DEFINE l_sql STRING
 
    IF NOT (cl_null(g_argv1)) THEN
       LET g_wc = " shj01 = '",g_argv1,"'"
    ELSE
       CLEAR FORM                         #清除畫面
       CALL b_shj.clear()
       CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031
   INITIALIZE g_shj.* TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON shj01,shj02,shj03,shj04,shj05,
                         shj06,shj07,shj08,shj09,shj10,
                         shj11,shj12,shj13,shjconf
                    FROM shj01,shj02,shj03,shj04,shj05,
                         shj06,shj07,shj08,shj09,
                         s_shj[1].shj10,s_shj[1].shj11,s_shj[1].shj12,
                         shj13,shjconf
               
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(shj01) #查詢單据
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     ="q_shb"
                 LET g_qryparam.where    ="shb17>0"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shj01
                 NEXT FIELD shj01
              WHEN INFIELD(shj02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  = "c"
                 LET g_qryparam.form   = "q_sfp"
                 LET g_qryparam.arg1   = '6'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shj02
              WHEN INFIELD(shj03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  = "c"
                 LET g_qryparam.form   = "q_sfp"
                 LET g_qryparam.arg1   = '1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shj03
              WHEN INFIELD(shj04)
                #---> Mod No.FUN-AA0085
                #CALL cl_init_qry_var()
                #LET g_qryparam.state  = "c"
                #LET g_qryparam.form   = "q_imd"
                #LET g_qryparam.arg1   = "S"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","S",g_plant,"","")  #只能开当前门店的
                      RETURNING g_qryparam.multiret
                #---> End Mod No.FUN-AA0085
                 DISPLAY g_qryparam.multiret TO shj04
                 NEXT FIELD shj04
              WHEN INFIELD(shj05)
                #---> Mod No.FUN-AA0085
                #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_ime"
                #LET g_qryparam.state    = "c"
                #LET g_qryparam.arg1     = "S"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                      RETURNING g_qryparam.multiret
                #---> End Mod No.FUN-AA0085
                 DISPLAY g_qryparam.multiret TO shj05
                 NEXT FIELD shj05             
              WHEN INFIELD(shj07)
                #---> Mod No.FUN-AA0085
                #CALL cl_init_qry_var()
                #LET g_qryparam.state  = "c"
                #LET g_qryparam.form   = "q_imd"
                #LET g_qryparam.arg1   = "W"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","W",g_plant,"","")  #只能开当前门店的
                      RETURNING g_qryparam.multiret
                #---> End Mod No.FUN-AA0085
                 DISPLAY g_qryparam.multiret TO shj07
                 NEXT FIELD shj07
              WHEN INFIELD(shj08)
                #---> Mod No.FUN-AA0085
                #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_ime"
                #LET g_qryparam.state    = "c"
                #LET g_qryparam.arg1     = "W"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                      RETURNING g_qryparam.multiret
                #---> End Mod No.FUN-AA0085
                 DISPLAY g_qryparam.multiret TO shj08
                 NEXT FIELD shj08
              WHEN INFIELD(shj11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_sfb"
                 LET g_qryparam.where = "smy73 <> 'Y'"         #TQC-AC0238
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO shj11
                 NEXT FIELD shj11
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
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
       
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE shj01 FROM shj_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY shj01"
    PREPARE t703_prepare FROM g_sql      #預備一下
    DECLARE t703_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t703_prepare
 
    DROP TABLE t703_cnttmp
#   LET l_sql=l_sql," INTO TEMP t703_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP t703_cnttmp"  #No.TQC-720019
    
#   PREPARE t703_cnttmp_pre FROM l_sql            #No.TQC-720019
    PREPARE t703_cnttmp_pre FROM g_sql_tmp        #No.TQC-720019
    EXECUTE t703_cnttmp_pre    
 
    LET g_sql="SELECT COUNT(*) FROM t703_cnttmp"
 
    PREPARE t703_precount FROM g_sql
    DECLARE t703_count CURSOR FOR t703_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_shj.shj01=g_argv1
    END IF
 
    CALL t703_show()
END FUNCTION
 
FUNCTION t703_menu()
DEFINE l_cmd STRING
 
   WHILE TRUE
      CALL t703_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL t703_a()
               END IF
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t703_u()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t703_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t703_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t703_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t703_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "gen_note"
            IF cl_chk_act_auth() THEN
               CALL t703_g()
            END IF
         WHEN "undo_gen_note"
            IF cl_chk_act_auth() THEN
               CALL t703_k()
            END IF
         WHEN "maintain_return_note"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_shj.shj02) THEN
                  LET l_cmd= "asfi526 '",g_shj.shj02,"'"
                  CALL cl_cmdrun_wait(l_cmd)
               END IF
            END IF
         WHEN "maintain_issue_note"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_shj.shj03) THEN
                  LET l_cmd= "asfi511 '",g_shj.shj03,"'"
                  CALL cl_cmdrun_wait(l_cmd)
               END IF
            END IF
         WHEN "maintain_wo"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(l_ac) AND l_ac > 0 THEN  #TQC-C70100 add
                  IF NOT cl_null(b_shj[l_ac].shj11) THEN
                     LET l_cmd= "asfi301 '",b_shj[l_ac].shj11,"'"
                     CALL cl_cmdrun_wait(l_cmd)
                  END IF
               END IF
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t703_y_chk()
               IF g_success = "Y" THEN
                  CALL t703_y_upd()
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t703_z()
            END IF
         #WHEN "void"
         #   IF cl_chk_act_auth() THEN
         #      CALL t703_x()
         #   END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #CHI-730003..............begin
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL t703_out()
        #   END IF
        #CHI-730003..............end
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(b_shj),'','')
            END IF
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_shj.shj01 IS NOT NULL THEN
                 LET g_doc.column1 = "shj01"
                 LET g_doc.value1 = g_shj.shj01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0164-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t703_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL b_shj.clear()
   INITIALIZE g_shj.* TO NULL
   CALL cl_opmsg('a')
   
   
   WHILE TRUE
      LET g_shj.shj13=g_today
      LET g_shj.shjconf='N'
      DISPLAY BY NAME g_shj.shj13,g_shj.shjconf
      IF NOT cl_null(g_argv1) AND (g_argv2='insert') THEN
         LET g_shj.shj01=g_argv1
         DISPLAY BY NAME g_shj.shj01
      END IF
      CALL t703_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_shj.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b=0                               #No.FUN-680064
      IF g_ss='N' THEN
         CALL b_shj.clear()
      ELSE
         CALL t703_b_fill('1=1')            #單身
      END IF
 
      CALL t703_b()                      #輸入單身
 
      LET g_shj_o.* = g_shj.*
      
      EXIT WHILE
   END WHILE
   
END FUNCTION
 
FUNCTION t703_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_shj.shj01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_shj.* FROM shj_file WHERE shj01=g_shj.shj01
   IF g_shj.shjconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF
   IF g_shj.shjconf = 'X'   THEN CALL cl_err('','9024',1) RETURN END IF
 
   IF t703_issued() THEN
      CALL cl_err(' ','asf-768',0)
      RETURN
   END IF
   MESSAGE ""
 
   CALL cl_opmsg('u')
   LET g_shj_o.* = g_shj.*
   
   BEGIN WORK
 
   CALL t703_show()
   WHILE TRUE
       CALL t703_i("u")                      #欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_shj.*=g_shj_o.*
           CALL t703_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
       END IF
       UPDATE shj_file SET shj01=g_shj.shj01,
                           shj02=g_shj.shj02,
                           shj03=g_shj.shj03,
                           shj04=g_shj.shj04,
                           shj05=g_shj.shj05,
                           shj06=g_shj.shj06,
                           shj07=g_shj.shj07,
                           shj08=g_shj.shj08,
                           shj09=g_shj.shj09,
                           shj13=g_shj.shj13
                     WHERE shj01=g_shj_o.shj01
       IF STATUS THEN
          CALL cl_err3("upd","shj_file",g_shj_o.shj01,"",STATUS,"","",1)
          CONTINUE WHILE 
       END IF
       EXIT WHILE
   END WHILE
 
   COMMIT WORK
   CALL cl_flow_notify(g_shj.shj01,'U')
   MESSAGE "Update OK!"
END FUNCTION
 
FUNCTION t703_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
    l_cnt           LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE li_result    LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE l_t1         LIKE type_file.chr5           #TQC-AC0293
DEFINE l_smy73      LIKE smy_file.smy73           #TQC-AC0293 
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031
    INPUT BY NAME g_shj.shj01,g_shj.shj02,g_shj.shj03,g_shj.shj04,
                  g_shj.shj05,g_shj.shj06,g_shj.shj07,g_shj.shj08,
                  g_shj.shj09,g_shj.shj13 WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t703_set_entry(p_cmd)
           CALL t703_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("shj02")
           CALL cl_set_docno_format("shj03")
 
       AFTER FIELD shj01
          IF (NOT cl_null(g_shj.shj01)) AND (g_shj_o.shj01 IS NULL OR g_shj_o.shj01<>g_shj.shj01) THEN 
             IF NOT t703_chk_shj01(g_shj.shj01) THEN
                NEXT FIELD shj01
             END IF
          END IF
 
       AFTER FIELD shj02
          IF NOT cl_null(g_shj.shj02) THEN
             CALL s_check_no("asf",g_shj.shj02,g_shj_o.shj02,"4","sfp_file","sfp01","")
                RETURNING li_result,g_shj.shj02
             DISPLAY BY NAME g_shj.shj02
             IF (NOT li_result) THEN
                LET g_shj.shj02=g_shj_o.shj02
                NEXT FIELD shj02
             END IF
            #TQC-AC0293 -------------add start---------
             LET l_t1 = s_get_doc_no(g_shj.shj02) 
             SELECT smy73 INTO l_smy73 FROM smy_file
              WHERE smyslip = l_t1
             IF l_smy73 = 'Y' THEN
                CALL cl_err('','asf-874',0)
                NEXT FIELD shj02 
             END IF
           #TQC-AC0293 -------------add end------------ 
          END IF
 
       AFTER FIELD shj03
          IF NOT cl_null(g_shj.shj03) THEN
             CALL s_check_no("asf",g_shj.shj03,g_shj_o.shj03,"3","sfp_file","sfp01","")
                RETURNING li_result,g_shj.shj03
             DISPLAY BY NAME g_shj.shj03
             IF (NOT li_result) THEN
                LET g_shj.shj03=g_shj_o.shj03
                NEXT FIELD shj03
             END IF
            #TQC-AC0293 -------------add start---------
             LET l_t1 = s_get_doc_no(g_shj.shj03)
             SELECT smy73 INTO l_smy73 FROM smy_file
              WHERE smyslip = l_t1
             IF l_smy73 = 'Y' THEN
                CALL cl_err('','asf-874',0)
                NEXT FIELD shj03
             END IF
           #TQC-AC0293 -------------add end------------ 
          END IF
       
       AFTER FIELD shj04
          IF NOT cl_null(g_shj.shj04) THEN
             SELECT imd02 FROM imd_file
              WHERE imd01=g_shj.shj04
                AND imd10='S'
                AND imdacti = 'Y'
             IF STATUS THEN
                CALL cl_err3("sel","imd_file",g_shj.shj04,"",STATUS,"","sel imd",1)
                NEXT FIELD shj04
             END IF
             #---> Add No.FUN-AA0085
             IF NOT s_chk_ware(g_shj.shj04) THEN  #检查仓库是否属于当前门店
                NEXT FIELD shj04
             END IF
             #---> End Add No.FUN-AA0085
          END IF
         #FUN-D40103 ------Begin-------
             IF NOT t703_ime_chk(g_shj.shj04,g_shj.shj05) THEN
             #  NEXT FIELD shj04   #TQC-D50126
                NEXT FIELD shj05   #TQC-D50126 
             END IF
         #FUN-D40103 ------End---------
         
       AFTER FIELD shj05
          IF NOT cl_null(g_shj.shj05) THEN
             SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01=g_shj.shj04
                                                        AND ime02=g_shj.shj05
                                                        AND ime05='Y'
             IF l_cnt=0 OR (SQLCA.sqlcode) THEN
                CALL cl_err3("sel","ime_file",g_shj.shj05,"","100","","sel ime",1)
                NEXT FIELD shj05
             END IF
       #FUN-D40103 -------Begin-------
          ELSE
             LET g_shj.shj05 = ' '
       #FUN-D40103 -------End---------
          END IF
          
       #FUN-D40103 ------Begin-------
          IF NOT t703_ime_chk(g_shj.shj04,g_shj.shj05) THEN
             NEXT FIELD shj05
          END IF 
       #FUN-D40103 ------End---------
       
       AFTER FIELD shj07
          IF NOT cl_null(g_shj.shj07) THEN
             SELECT imd02 FROM imd_file
              WHERE imd01=g_shj.shj07
                AND imd10='W'
                AND imdacti = 'Y'
             IF STATUS THEN
                CALL cl_err3("sel","imd_file",g_shj.shj07,"",STATUS,"","sel imd",1)
                NEXT FIELD shj07
             END IF
             #---> Add No.FUN-AA0085
             IF NOT s_chk_ware(g_shj.shj07) THEN  #检查仓库是否属于当前门店
                NEXT FIELD shj07
             END IF
             #---> End Add No.FUN-AA0085
       #FUN-D40103 ------Begin-------
             IF NOT t703_ime_chk(g_shj.shj07,g_shj.shj08) THEN
                NEXT FIELD shj08
             END IF 
       #FUN-D40103 ------End---------
          END IF
 
       AFTER FIELD shj08
          IF NOT cl_null(g_shj.shj08) THEN
             SELECT COUNT(*) INTO l_cnt FROM ime_file WHERE ime01=g_shj.shj07
                                                        AND ime02=g_shj.shj08
                                                        AND ime05='Y'
             IF l_cnt=0 OR (SQLCA.sqlcode) THEN
                CALL cl_err3("sel","ime_file",g_shj.shj08,"","100","","sel ime",1)
                NEXT FIELD shj08
             END IF
       #FUN-D40103 -------Begin-------
          ELSE
             LET g_shj.shj08 = ' '
       #FUN-D40103 -------End---------
          END IF
       #FUN-D40103 ------Begin-------
          IF NOT t703_ime_chk(g_shj.shj07,g_shj.shj08) THEN
             NEXT FIELD shj08
          END IF
       #FUN-D40103 ------End---------
       
       AFTER INPUT
          IF cl_null(g_shj.shj05) THEN
             LET g_shj.shj05=' '
          END IF
          IF cl_null(g_shj.shj06) THEN
             LET g_shj.shj06=' '
          END IF
          IF cl_null(g_shj.shj08) THEN
             LET g_shj.shj08=' '
          END IF
          IF cl_null(g_shj.shj09) THEN
             LET g_shj.shj09=' '
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(shj01)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_shb"
                LET g_qryparam.where = "shb17>0"
                CALL cl_create_qry() RETURNING g_shj.shj01
                DISPLAY BY NAME g_shj.shj01
                NEXT FIELD shj01
             WHEN INFIELD(shj02)
                LET g_t1=s_get_doc_no(g_shj.shj02)
#               LET g_sql = " (smy73 <> 'Y' OR smy73 IS NULL)"             #TQC-AC0293          #TQC-C20011
                LET g_sql = " ((smy73 <> 'Y' OR smy73 IS NULL) AND smy72 = '6')"                #TQC-C20011
                CALL smy_qry_set_par_where(g_sql)                          #TQC-AC0293               
                CALL q_smy( FALSE, TRUE,g_t1,'ASF','4') RETURNING g_t1
                LET g_shj.shj02 = g_t1
                DISPLAY BY NAME g_shj.shj02
                NEXT FIELD shj02
             WHEN INFIELD(shj03)
                LET g_t1=s_get_doc_no(g_shj.shj03)
#               LET g_sql = " (smy73 <> 'Y' OR smy73 IS NULL)"             #TQC-AC0293         #TQC-C20011
                LET g_sql = " ((smy73 <> 'Y' OR smy73 IS NULL) AND smy72 = '1')"               #TQC-C20011
                CALL smy_qry_set_par_where(g_sql)                          #TQC-AC0293
                CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1
                LET g_shj.shj03 = g_t1
                DISPLAY BY NAME g_shj.shj03
                NEXT FIELD shj03
             WHEN INFIELD(shj04)
               #---> Mod No.FUN-AA0085
               #CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_imd"
               #LET g_qryparam.default1 = g_shj.shj04
               #LET g_qryparam.arg1     = 'S'        #倉庫類別
               #CALL cl_create_qry() RETURNING g_shj.shj04
                CALL q_imd_1(FALSE,TRUE,g_shj.shj04,"S",g_plant,"","")  #只能开当前门店的
                     RETURNING g_shj.shj04
               #---> End Mod No.FUN-AA0085
                NEXT FIELD shj04
             WHEN INFIELD(shj05)
               #---> Mod No.FUN-AA0085
               #CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_ime"
               #LET g_qryparam.default1 = g_shj.shj05
               #LET g_qryparam.arg1     = g_shj.shj04 #倉庫編號 
               #LET g_qryparam.arg2     = 'S'              #倉庫類別
               #CALL cl_create_qry() RETURNING g_shj.shj05
                CALL q_ime_1(FALSE,TRUE,g_shj.shj05,g_shj.shj04,"S",g_plant,"","","")
                     RETURNING g_shj.shj05
               #---> End Mod No.FUN-AA0085
                NEXT FIELD shj05             
             WHEN INFIELD(shj07)
               #---> Mod No.FUN-AA0085
               #CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_imd"
               #LET g_qryparam.default1 = g_shj.shj07
               #LET g_qryparam.arg1     = 'W'        #倉庫類別
               #CALL cl_create_qry() RETURNING g_shj.shj07
                CALL q_imd_1(FALSE,TRUE,g_shj.shj07,"W",g_plant,"","")  #只能开当前门店的
                     RETURNING g_shj.shj07
               #---> End Mod No.FUN-AA0085
                NEXT FIELD shj07
             WHEN INFIELD(shj08)
               #---> Mod No.FUN-AA0085
               #CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_ime"
               #LET g_qryparam.default1 = g_shj.shj07
               #LET g_qryparam.arg1     = g_shj.shj08 #倉庫編號 
               #LET g_qryparam.arg2     = 'W'              #倉庫類別
               #CALL cl_create_qry() RETURNING g_shj.shj08
                CALL q_ime_1(FALSE,TRUE,g_shj.shj07,g_shj.shj08,"W",g_plant,"","","")
                     RETURNING g_shj.shj08
               #---> End Mod No.FUN-AA0085
                NEXT FIELD shj08             
          END CASE
       
       ON ACTION CONTROLG
         CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION

#FUN-D40103 -------Begin--------
FUNCTION t703_ime_chk(p_ime01,p_ime02)
   DEFINE  p_ime01      LIKE ime_file.ime01
   DEFINE  p_ime02      LIKE ime_file.ime02
   DEFINE  l_imeacti    LIKE ime_file.imeacti
   DEFINE  l_n          LIKE type_file.num5     #TQC-D50116
   DEFINE  l_ime02      LIKE ime_file.ime02     #TQC-D50116
  #IF p_ime02 IS NOT NULL THEN                      #TQC-D50127 mark
   IF p_ime02 IS NOT NULL AND p_ime02 != ' ' THEN   #TQC-D50127
   #TQC-D50116 ------Begin-------
      SELECT COUNT(*) INTO l_n FROM ime_file
       WHERE ime01 = p_ime01 AND ime02 = p_ime02
      IF l_n = 0 THEN
         CALL cl_err(p_ime01||' '||p_ime02,'mfg1101',0)
         RETURN FALSE
      END IF
   #TQC-D50116 ------End---------
   END IF   #TQC-D50127
   IF p_ime02 IS NOT NULL THEN   #TQC-D50127
      LET l_imeacti = ''
      SELECT imeacti INTO l_imeacti FROM ime_file WHERE ime01=g_shj.shj04
                                                    AND ime02=g_shj.shj05
                                                    AND ime05='Y'
      IF l_imeacti = 'N' OR SQLCA.sqlcode THEN
      #  CALL cl_err('','aim-507',0)                  #TQC-D50116
      #TQC-D50116 ------Begin------
         LET l_ime02 = p_ime02
         IF cl_null(l_ime02) THEN
            LET l_ime02 = "' '"
         END IF
         CALL cl_err_msg("","aim-507",p_ime01 || "|" || l_ime02 ,0) 
      #TQC-D50116 ------End--------
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103 -------End----------

FUNCTION t703_q()
   INITIALIZE g_shj.* TO NULL
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL b_shj.clear()
   DISPLAY '' TO FORMONLY.cnt
   DISPLAY '' TO FORMONLY.cn2
 
   CALL t703_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_shj.* TO NULL
      CALL b_shj.clear()
      RETURN
   END IF
 
   OPEN t703_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_shj.* TO NULL
   ELSE
      OPEN t703_count
      FETCH t703_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t703_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t703_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t703_bcs INTO g_shj.shj01
       WHEN 'P' FETCH PREVIOUS t703_bcs INTO g_shj.shj01
       WHEN 'F' FETCH FIRST    t703_bcs INTO g_shj.shj01
       WHEN 'L' FETCH LAST     t703_bcs INTO g_shj.shj01
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso t703_bcs INTO g_shj.shj01
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_shj.shj01,SQLCA.sqlcode,0)
      INITIALIZE g_shj.* TO NULL          #No.FUN-6A0164
   ELSE
      CALL t703_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION t703_cur1()
  DEFINE l_sql STRING
 
   LET l_sql="SELECT * FROM shj_file WHERE shj01= ? ",
             " ORDER BY shj01,shj10"
   PREPARE t703_cur1_pre FROM l_sql
   DECLARE t703_cur1_c CURSOR FOR t703_cur1_pre
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t703_show()
 
   OPEN t703_cur1_c USING g_shj.shj01
   FETCH t703_cur1_c INTO g_shj.*
   CLOSE t703_cur1_c
   
   DISPLAY BY NAME g_shj.shj01,g_shj.shj02,g_shj.shj03,g_shj.shj04,
                   g_shj.shj05,g_shj.shj06,g_shj.shj07,g_shj.shj08,
                   g_shj.shj09,g_shj.shj13,g_shj.shjconf
   
   INITIALIZE g_shb.* TO NULL
   SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shj.shj01
                                    
   DISPLAY BY NAME g_shb.shb05,g_shb.shb012,g_shb.shb06,  #FUN-A60027 add shb012
                   g_shb.shb081,g_shb.shb082,g_shb.shb17
                                    
   CALL t703_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   
   CALL t703_pic()
END FUNCTION
 
#單身
FUNCTION t703_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用      #No.FUN-680121 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680121 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680121 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680121 SMALLINT
   l_cnt           LIKE type_file.num10,               #No.FUN-680121 INTEGER
   li_result       LIKE type_file.num5                 #No.FUN-680121 SMALLINT
DEFINE l_ac        LIKE type_file.num5                 #NO.TQC-AC0238      
   LET g_action_choice = ""
 
   IF cl_null(g_shj.shj01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='Y'
   IF l_cnt>0 THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='X'
   IF l_cnt>0 THEN
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   
   IF t703_issued() THEN
      CALL cl_err(' ','asf-768',0)
      RETURN
   END IF
   
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT shj10,shj11,shj12 FROM shj_file",
                      " WHERE shj01 = ? AND shj10 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t703_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL b_shj.clear() END IF
 
   INPUT ARRAY b_shj WITHOUT DEFAULTS FROM s_shj.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_docno_format("shj11")
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET b_shj_t.* = b_shj[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN t703_bcl USING g_shj.shj01,b_shj[l_ac].shj10
            IF STATUS THEN
               CALL cl_err("OPEN t703_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t703_bcl INTO b_shj[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN t703_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET b_shj_t.*=b_shj[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE b_shj[l_ac].* TO NULL            #900423
         LET b_shj_t.* = b_shj[l_ac].*               #新輸入資料
         LET b_shj[l_ac].shj12=0
         CALL cl_show_fld_cont()
         NEXT FIELD shj10
 
      BEFORE FIELD shj10                        #default 項次
         IF b_shj[l_ac].shj10 IS NULL OR b_shj[l_ac].shj10 = 0 THEN
             SELECT max(shj10)
                INTO b_shj[l_ac].shj10
                FROM shj_file
               WHERE shj01 = g_shj.shj01
             IF b_shj[l_ac].shj10 IS NULL
                THEN LET b_shj[l_ac].shj10 = 0
             END IF
             LET b_shj[l_ac].shj10 = b_shj[l_ac].shj10 + g_sma.sma19
            #DISPLAY BY NAME b_shj[l_ac].shj10 #CHI-750006
         END IF
 
     #CHI-750006 .............mark begin
     #AFTER FIELD shj10                         # check data 是否重複
     #   IF NOT cl_null(b_shj[l_ac].shj10) THEN
     #      IF b_shj[l_ac].shj10 != b_shj_t.shj10 OR b_shj_t.shj10 IS NULL THEN
     #         LET l_cnt=0
     #      END IF
     #   END IF
     #CHI-750006 .............mark end
 
      AFTER FIELD shj11
         IF NOT cl_null(b_shj[l_ac].shj11) THEN
            CALL s_check_no("asf",b_shj[l_ac].shj11,b_shj_t.shj11,"1","sfb_file","sfb01","")
               RETURNING li_result,b_shj[l_ac].shj11
            DISPLAY BY NAME b_shj[l_ac].shj11
            IF (NOT li_result) THEN
              NEXT FIELD shj11
            END IF
            CALL t703_shj11(l_ac)                    #No.TQC-AC0238
               IF NOT cl_null(g_errno) THEN          #No.TQC-AC0238
               CALL cl_err(b_shj[l_ac].shj11,g_errno,0) #NO.TQC-AC0238 
               LET b_shj[l_ac].shj11 = b_shj_t.shj11      #No.TQC-AC0238
               DISPLAY BY NAME b_shj[l_ac].shj11         #No.TQC-AC0238
               NEXT FIELD shj11                           #No.TQC-AC0238
            END IF
         END IF
              
      AFTER FIELD shj12
         IF NOT cl_null(b_shj[l_ac].shj12) THEN
            IF b_shj[l_ac].shj12<=0 THEN
               CALL cl_err('','aim-391',1)
               NEXT FIELD shj12
            END IF
         END IF
 
      AFTER INPUT
         IF b_shj[l_ac].shj12<=0 THEN
            CALL cl_err('','aim-391',1)
            NEXT FIELD shj12
         END IF
         IF NOT t703_chk_total() THEN
            CONTINUE INPUT
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE b_shj[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY b_shj[l_ac].* TO s_shj.*
            CALL b_shj.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
         LET g_shj.shj10=b_shj[l_ac].shj10
         LET g_shj.shj11=b_shj[l_ac].shj11
         LET g_shj.shj12=b_shj[l_ac].shj12
         LET g_shj.shjplant = g_plant #FUN-980008 add
         LET g_shj.shjlegal = g_legal #FUN-980008 add
 
         INSERT INTO shj_file VALUES (g_shj.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","shj_file",b_shj[l_ac].shj10,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL cl_flow_notify(g_shj.shj01,'I')
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF b_shj_t.shj10 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM shj_file WHERE shj01 = g_shj.shj01
                                   AND shj10 = b_shj_t.shj10
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","shj_file",b_shj[l_ac].shj10,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET b_shj[l_ac].* = b_shj_t.*
            CLOSE t703_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(b_shj[l_ac].shj10,-263,1)
            LET b_shj[l_ac].* = b_shj_t.*
         ELSE
            UPDATE shj_file SET shj10 = b_shj[l_ac].shj10,
                                shj11 = b_shj[l_ac].shj11,
                                shj12 = b_shj[l_ac].shj12
                                 WHERE shj01 = g_shj.shj01
                                   AND shj10 = b_shj_t.shj10
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","shj_file",b_shj[l_ac].shj10,"",SQLCA.sqlcode,"","",1)
               LET b_shj[l_ac].* = b_shj_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET b_shj[l_ac].* = b_shj_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL b_shj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t703_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D40030 Add
         CLOSE t703_bcl
         COMMIT WORK
        #CALL b_shj.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
#NO.FUN-6B0031--BEGIN
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#NO.FUN-6B0031--END
  
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(shj11)
               LET g_t1 = s_get_doc_no(b_shj[l_ac].shj11)
               CALL q_smy( FALSE,TRUE,g_t1,'ASF','1') RETURNING g_t1
               LET b_shj[l_ac].shj11=g_t1
               DISPLAY BY NAME b_shj[l_ac].shj11
               NEXT FIELD shj11
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(shj10) AND l_ac > 1 THEN
            LET b_shj[l_ac].* = b_shj[l_ac-1].*
            LET b_shj[l_ac].shj10=null
            NEXT FIELD shj10
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
 
   CLOSE t703_bcl
   COMMIT WORK
   
   IF NOT t703_chk_total() THEN
      CALL t703_b()
   END IF
 
END FUNCTION
#-----------TQC-AC0238 add----------------- 
FUNCTION t703_shj11(l_ac)
   DEFINE l_ac      LIKE type_file.num5
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73
   LET g_errno = ' '
   IF cl_null(b_shj[l_ac].shj11) THEN RETURN END IF
   LET l_slip = s_get_doc_no(b_shj[l_ac].shj11)
    SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = l_slip
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-875'
   END IF
END FUNCTION
#-----------TQC-AC0238 add------------------
FUNCTION t703_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT shj10,shj11,shj12",
               "  FROM shj_file ",
               " WHERE shj01 = '",g_shj.shj01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY shj10"
   PREPARE t703_prepare2 FROM g_sql       #預備一下
   DECLARE shj_cs CURSOR FOR t703_prepare2
 
   CALL b_shj.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH shj_cs INTO b_shj[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL b_shj.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t703_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY b_shj TO s_shj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION controls                                                                                                            
         CALL cl_set_head_visible("","AUTO")                                                                                        
#NO.FUN-6B0031--END        
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t703_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t703_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t703_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t703_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t703_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION gen_note
         LET g_action_choice="gen_note"
         EXIT DISPLAY
 
      ON ACTION undo_gen_note
         LET g_action_choice="undo_gen_note"
         EXIT DISPLAY
 
      ON ACTION maintain_return_note
         LET g_action_choice="maintain_return_note"
         EXIT DISPLAY
 
      ON ACTION maintain_issue_note
         LET g_action_choice="maintain_issue_note"
         EXIT DISPLAY
 
      ON ACTION maintain_wo
         LET g_action_choice="maintain_wo"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      #ON ACTION void
      #   LET g_action_choice="void"
      #   EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t703_pic()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
     #CHI-730003..............begin
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY
     #CHI-730003..............end
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t703_copy()
DEFINE
   l_n             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   l_cnt           LIKE type_file.num10,         #No.FUN-680121 INTEGER
   l_newno1,l_oldno1  LIKE shj_file.shj01
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_shj.shj01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   CALL cl_set_comp_entry("shj01",TRUE)
   
   DISPLAY NULL TO shj01
 
   INPUT l_newno1 FROM shj01
       
       AFTER FIELD shj01
          IF (NOT cl_null(l_newno1))  THEN 
             IF NOT t703_chk_shj01(l_newno1) THEN
                NEXT FIELD shj01
             END IF
          END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(shj01)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_shb"
                LET g_qryparam.where = "shb17>0"
                CALL cl_create_qry() RETURNING l_newno1
                DISPLAY l_newno1 TO shj01
                NEXT FIELD shj01
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
      DISPLAY g_shj.shj01 TO shj01
      RETURN
   END IF
 
   DROP TABLE t703_x
 
   SELECT * FROM shj_file             #單身複製
    WHERE shj01 = g_shj.shj01
     INTO TEMP t703_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","t703_x",g_shj.shj01,'',SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE t703_x SET shj01=l_newno1,shj12=0
 
   INSERT INTO shj_file SELECT * FROM t703_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","shj_file",l_newno1,'',SQLCA.sqlcode,"",g_msg,1)
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_shj.shj01=l_newno1
      CALL cl_flow_notify(g_shj.shj01,'I')
      CALL t703_show()
   END IF
 
END FUNCTION
 
FUNCTION t703_r()
DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE l_shbconf  LIKE shb_file.shbconf   #FUN-A70095
   IF cl_null(g_shj.shj01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   SELECT * INTO g_shj.* FROM shj_file
                        WHERE shj01=g_shj.shj01
#FUN-A70095 ---------------Begin--------------------
   SELECT shbconf INTO l_shbconf FROM shb_file
    WHERE shb01 = g_shj.shj01
   IF l_shbconf = 'Y' THEN
      CALL cl_err(g_shj.shj01,'asf-224',0)
      RETURN
   END IF
#FUN-A70095 ---------------End----------------------
   #刪除前檢查相關發領單據是否存在
   SELECT COUNT(*) INTO l_cnt FROM sfp_file
                             WHERE sfp01=g_shj.shj02
                               OR  sfp01=g_shj.shj03
   IF l_cnt>0 THEN
      CALL cl_err('del chk','asf-763',1)
      RETURN
   END IF
   #刪除前檢查相關工單單據是否存在
   SELECT COUNT(*) INTO l_cnt FROM sfb_file,shj_file
                             WHERE shj11=sfb01
                               AND shj01=g_shj.shj01
   IF l_cnt>0 THEN
      CALL cl_err('del chk','asf-764',1)
      RETURN
   END IF
   #刪除前檢查相關ECM單據是否存在
   SELECT COUNT(*) INTO l_cnt FROM ecm_file,shj_file
                             WHERE ecm01=shj11
                               AND shj01=g_shj.shj01
   IF l_cnt>0 THEN
      CALL cl_err('del chk','asf-765',1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "shj01"         #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_shj.shj01      #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                             #No.FUN-9B0098 10/02/24
   DELETE FROM shj_file WHERE shj01=g_shj.shj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","shj_file",g_shj.shj01,'',SQLCA.sqlcode,"","del shj",1)
      RETURN      
   END IF   
 
   INITIALIZE g_shj.* TO NULL
   CLEAR FORM
   CALL b_shj.clear()
   MESSAGE ""
   DROP TABLE t703_cnttmp                         #No.TQC-720019
   PREPARE t703_cnttmp_pre2 FROM g_sql_tmp        #No.TQC-720019
   EXECUTE t703_cnttmp_pre2                       #No.TQC-720019
   OPEN t703_count
   #FUN-B50064-add-start--
   IF STATUS THEN
      CLOSE t703_bcs
      CLOSE t703_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end--
   FETCH t703_count INTO g_row_count
   #FUN-B50064-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE t703_bcs
      CLOSE t703_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN t703_bcs
      CALL t703_fetch('F') 
   ELSE
      CLEAR FORM
      DISPLAY 0 TO FORMONLY.cn2
      CALL b_shj.clear()
      CALL t703_menu()
   END IF
   CALL cl_flow_notify(g_shj.shj01,'D')                  
END FUNCTION
 
FUNCTION t703_out()
{
 
#   DEFINE
#       sr              RECORD LIKE shj_file.*,
#       l_i             LIKE type_file.num5,     #No.FUN-680121 SMALLINT
#       l_name          LIKE type_file.chr20,    #No.FUN-680121 VARCHAR(20),# External(Disk) file name
#       l_za05          LIKE type_file.chr1000   #No.FUN-680121 VARCHAR(40) #
#  
#   IF g_wc IS NULL THEN 
#      IF NOT cl_null(g_shj.shj01) THEN
#         LET g_wc=" shj01=",g_shj.shj01
#      ELSE
#         CALL cl_err('',-400,0)
#         RETURN 
#      END IF
#   END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM shj_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED,
#             " ORDER BY shj01,shj02,shj03"
#   PREPARE t703_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t703_co                         # SCROLL CURSOR
#        CURSOR FOR t703_p1
#
#   CALL cl_outnam('asft703') RETURNING l_name
#   START REPORT t703_rep TO l_name
#
#   FOREACH t703_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t703_rep(sr.*)
#   END FOREACH
#
#   FINISH REPORT t703_rep
#
#   CLOSE t703_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
}
END FUNCTION
{
#REPORT t703_rep(sr)
#   DEFINE
#       l_trailer_sw   LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
#       sr RECORD LIKE shj_file.*,
#       l_ima02   LIKE ima_file.ima02,
#       l_ima021  LIKE ima_file.ima021,
#       l_ima25   LIKE ima_file.ima25
#
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.shj01,sr.shj02,sr.shj03
#
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#
#       ON EVERY ROW
#           SELECT ima02,ima021,ima25 INTO 
#                l_ima02,l_ima021,l_ima25 
#               FROM ima_file WHERE ima01=sr.shj03
#           IF SQLCA.sqlcode THEN
#              LET l_ima02 =NULL
#              LET l_ima021=NULL
#           END IF
#           PRINT COLUMN g_c[31],sr.shj01 USING "####",
#                 COLUMN g_c[32],sr.shj02 USING "####",
#                 COLUMN g_c[33],sr.shj03,
#                 COLUMN g_c[34],l_ima02,
#                 COLUMN g_c[35],l_ima021,
#                 COLUMN g_c[36],l_ima25,
#                 COLUMN g_c[37],cl_numfor(sr.shj04,37,6),
#                 COLUMN g_c[38],cl_numfor(sr.shj05,38,6)
#
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
}
 
FUNCTION t703_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd='a' OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("shj01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t703_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("shj01",FALSE)
   END IF
END FUNCTION
 
FUNCTION t703_chk_shj01(p_shj01)
   DEFINE p_shj01 LIKE shj_file.shj01
   DEFINE l_shb17 LIKE shb_file.shb17,
          l_shbacti LIKE shb_file.shbacti,
          l_cnt   LIKE type_file.num10         #No.FUN-680121 INTEGER
 
   SELECT shbacti,shb17 INTO l_shbacti,l_shb17 FROM shb_file
                       WHERE shb01=p_shj01
   CASE
      WHEN SQLCA.sqlcode
         LET g_errno=SQLCA.sqlcode
      WHEN l_shbacti<>'Y' OR cl_null(l_shbacti)
         LET g_errno='9028'
      WHEN l_shb17<=0 OR cl_null(l_shb17)
         LET g_errno='asf-758'   
      OTHERWISE
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM shj_file 
                                   WHERE shj01=p_shj01
         IF l_cnt>0 THEN
            LET g_errno='asf-759'
         ELSE
            INITIALIZE g_shb.* TO NULL
            SELECT * INTO g_shb.* FROM shb_file WHERE shb01=p_shj01
            DISPLAY BY NAME g_shb.shb05,g_shb.shb06,g_shb.shb081,
                            g_shb.shb082,g_shb.shb17
            RETURN TRUE
         END IF
   END CASE
   CALL cl_err3("sel","shb_file",p_shj01,"",g_errno,"","",1)
   RETURN FALSE
END FUNCTION
 
FUNCTION t703_y_chk() #確認前檢查
DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
   LET g_success = 'Y'
 
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_shj.shj01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
#CHI-C30107 ------------- add -------------------- begin
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=g_shj.shj01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('',-400,0)
      RETURN
   END IF


   SELECT COUNT(*) INTO l_cnt FROM shj_file
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='Y'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM shj_file
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='X'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj10 IS NULL
   IF l_cnt > 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
      LET g_success='N'
      RETURN
   END IF
#CHI-C30107 ------------- add -------------------- end
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=g_shj.shj01
   IF l_cnt = 0 THEN
      LET g_success = 'N'   
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_shj.* FROM shj_file WHERE shj01=g_shj.shj01  #Add No.FUN-AB0054
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='Y'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='X'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj10 IS NULL
   IF l_cnt > 0 THEN
      LET g_success = 'N'   
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
   #Add No.FUN-AB0054 检查仓库
   IF NOT cl_null(g_shj.shj04) THEN
      IF NOT s_chk_ware(g_shj.shj04) THEN  #检查仓库是否属于当前门店
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   IF NOT cl_null(g_shj.shj07) THEN
      IF NOT s_chk_ware(g_shj.shj07) THEN  #检查仓库是否属于当前门店
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #End Add No.FUN-AB0054

   #check 單據是否已經產生
   SELECT COUNT(*) INTO l_cnt FROM sfp_file
                             WHERE sfp01=g_shj.shj02
                               OR sfp01=g_shj.shj03
   IF l_cnt<>2 THEN
      CALL cl_err('','asf-762',1)
      LET g_success='N'
      RETURN
   END IF
   
   #check 發/退料單是否都已經過帳
   IF NOT t703_chk_note() THEN
      LET g_success='N'
      RETURN
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
   
#CHI-C30107 ------------ mark ----------- begin
#  IF NOT cl_confirm('axm-108') THEN
#     LET g_success='N'
#     RETURN 
#  END IF
#CHI-C30107 ------------ mark ----------- end
END FUNCTION
 
FUNCTION t703_y_upd() #確認的更新動作
DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
 
   LET g_success = 'Y'
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM shj_file
                             WHERE shj01=g_shj.shj01
   BEGIN WORK
 
   UPDATE shj_file SET shjconf='Y' WHERE shj01=g_shj.shj01
   
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]<>l_cnt) THEN
      CALL cl_err('','azz-711',1)
      LET g_success='N'
   END IF
 
   IF NOT t703_ins_shi() THEN
      LET g_success='N'
   END IF
   
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_shj.shjconf='Y'
      CALL cl_flow_notify(g_shj.shj01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_shj.shjconf='N'
   END IF
   DISPLAY BY NAME g_shj.shjconf
   CALL t703_pic()
END FUNCTION
 
FUNCTION t703_z()  #取消確認
DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
 
   IF s_shut(0) THEN RETURN END IF
 
   LET g_success='Y'
   
   IF cl_null(g_shj.shj01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=g_shj.shj01
   IF l_cnt = 0 THEN
      LET g_success = 'N'   
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='N'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err('','9025',0)      
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='X'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
# TQC-BC0081  begin 
   SELECT COUNT(*) INTO l_cnt FROM shb_file
                             WHERE shb01   = g_shj.shj01
                               AND shbconf = 'Y'
   IF l_cnt > 0 THEN 
      LET g_success = 'N'
      CALL cl_err(g_shj.shj01,'asf-512',0)
      RETURN 
   END IF   
# TQC-BC0081  end 
   IF g_success = 'N' THEN RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM shj_file
                             WHERE shj01=g_shj.shj01
   BEGIN WORK
 
   UPDATE shj_file SET shjconf='N' WHERE shj01=g_shj.shj01
   
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]<>l_cnt) THEN
      CALL cl_err('','azz-711',1)
      LET g_success='N'
   END IF
 
   DELETE FROM shi_file WHERE shi01=g_shj.shj01
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
      CALL cl_err('','azz-711',1)
      LET g_success='N'
   END IF
   
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_shj.shjconf='N'
   ELSE
      ROLLBACK WORK
      LET g_shj.shjconf='Y'
   END IF
   DISPLAY BY NAME g_shj.shjconf
   CALL t703_pic()
END FUNCTION
 
{
FUNCTION t703_x() #作廢
  DEFINE l_cnt LIKE type_file.num5, 
         l_chr LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
       
 
   IF s_shut(0) THEN RETURN END IF
 
   LET g_success = 'Y'
   
   IF cl_null(g_shj.shj01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=g_shj.shj01
   IF l_cnt = 0 THEN
      LET g_success = 'N'   
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='Y'
   IF l_cnt>0 THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
 
   #作廢/作廢還原功能
   IF cl_void(0,0,g_shj.shjconf) THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM shj_file
                                WHERE shj01=g_shj.shj01
      BEGIN WORK
      IF g_shj.shjconf = 'N' THEN
          LET l_chr = 'X'
      ELSE
          LET l_chr = 'N'
      END IF
 
      UPDATE shj_file
          SET shjconf = l_chr
          WHERE shj01 = g_shj.shj01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]<>l_cnt THEN
          CALL cl_err('','azz-711',0)
          ROLLBACK WORK
          RETURN
      END IF
 
      LET g_shj.shjconf = l_chr
      DISPLAY BY NAME g_shj.shjconf
      COMMIT WORK
      CALL cl_flow_notify(g_shj.shj01,'V')
      CALL t703_pic()
   END IF
END FUNCTION
}
 
FUNCTION t703_pic() #圖形顯示
DEFINE l_void LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   IF g_shj.shjconf = 'X' THEN 
      LET l_void = 'Y'
   ELSE
      LET l_void = 'N'
   END IF
   CALL cl_set_field_pic(g_shj.shjconf,"","","",l_void,"")
END FUNCTION
 
FUNCTION t703_chk_note()  #檢查發/退料單是否已經過帳
DEFINE l_sql STRING
DEFINE sr DYNAMIC ARRAY OF RECORD
             sfp01  LIKE sfp_file.sfp01,
             sfp06  LIKE sfp_file.sfp06,
             sfpconf LIKE sfp_file.sfpconf,
             sfp04  LIKE sfp_file.sfp04
          END RECORD,
       l_n LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE l_msg    STRING
DEFINE l_msg2   STRING
DEFINE lc_gaq03 LIKE gaq_file.gaq03
DEFINE l_success LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   LET l_success='Y'
   LET l_sql="SELECT sfp01,sfp06,sfpconf,sfp04 FROM sfp_file,shj_file ",
             "                  WHERE sfp01=shj02 ",
             "                    AND sfp04<>'Y' ",
             "                    AND shj01='",g_shj.shj01,"' ",
             "                  UNION ",
             "SELECT sfp01,sfp06,sfpconf,sfp04 FROM sfp_file,shj_file ",
             "                  WHERE sfp01=shj03 ",
             "                    AND sfp04<>'Y' ",       
             "                    AND shj01='",g_shj.shj01,"' "
   PREPARE t703_chk_note_pre FROM l_sql
   DECLARE t703_chk_note_c CURSOR FOR t703_chk_note_pre
   CALL sr.clear()
   LET l_n=1
   FOREACH t703_chk_note_c INTO sr[l_n].*
      IF SQLCA.sqlcode THEN
         LET l_success='N'
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_n=l_n+1
   END FOREACH
   IF l_n>1 THEN
      CALL sr.deleteElement(l_n)      
   END IF
   LET l_n=l_n-1
   IF l_n > 0 THEN
      CALL cl_get_feldname("sfp01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("sfp06",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("sfpconf",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("sfp04",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_getmsg("asf-760",g_lang) RETURNING l_msg
      CALL cl_show_array(base.TypeInfo.create(sr),l_msg,l_msg2)
      LET l_success='N'
   END IF
   RETURN (l_success='Y')
END FUNCTION
 
FUNCTION t703_ins_shi()
DEFINE l_shb RECORD LIKE shb_file.*
DEFINE l_shj RECORD LIKE shj_file.*
DEFINE l_shi RECORD LIKE shi_file.*
DEFINE l_sql STRING
DEFINE l_success LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   
   LET l_success='Y'
   
   LET l_sql="SELECT shj_file.*,shb_file.* FROM shj_file,shb_file ",
                                        " WHERE shj01='",g_shj.shj01,"' ",
                                        "   AND shj01=shb01 ",
                                        " ORDER BY shj01,shj10"
   PREPARE t703_ins_shi_pre FROM l_sql
   DECLARE t703_ins_shi_c CURSOR FOR t703_ins_shi_pre
   FOREACH t703_ins_shi_c INTO l_shj.*,l_shb.*
      IF SQLCA.sqlcode THEN
         LET l_success='N'
         EXIT FOREACH
      END IF
      INITIALIZE l_shi.* TO NULL
      LET l_shi.shi01=l_shj.shj01   #移轉單號
      LET l_shi.shi02=l_shj.shj11   #轉入工單
      LET l_shi.shi03=l_shb.shb081  #作業編號
      LET l_shi.shi04=l_shb.shb06   #製程序號
      LET l_shi.shi05=l_shj.shj12   #轉入數量
 
      LET l_shi.shiplant = g_plant #FUN-980008 add
      LET l_shi.shilegal = g_legal #FUN-980008 add
      
#FUN-A70125 --begin--
      IF cl_null(l_shi.shi012) THEN
         LET l_shi.shi012 = ' '
      END IF
#FUN-A70125 --end--
      INSERT INTO shi_file VALUES (l_shi.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         LET l_success='N'
      END IF
   END FOREACH
   
   RETURN (l_success='Y')
END FUNCTION
 
FUNCTION t703_chk_total()  #檢查單身總轉入量
DEFINE l_tot LIKE shj_file.shj12
 
   LET l_tot=0
   SELECT SUM(shj12) INTO l_tot FROM shj_file
                               WHERE shj01=g_shj.shj01
   IF l_tot<>g_shb.shb17 THEN
      CALL cl_err('','asf-926',0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION t703_sfa_cur()
DEFINE l_sql STRING
#  {
#  LET l_sql="SELECT sfa_file.* FROM ecm_file,sfa_file ",
#                            " WHERE sfa01=ecm01 ",
#                            "   AND ecm04=sfa08 ",
#                            "   AND ecm01= ? ",         #工單編號
#                            "   AND ecm03<= ? "         #製程序
#  PREPARE t703_sfa_cur_pre FROM l_sql
#  DECLARE t703_sfa_cur_c CURSOR FOR t703_sfa_cur_pre #發退料
#  }
   LET l_sql="SELECT sfa_file.* FROM sfa_file ",
                             " WHERE sfa01= ? "
   PREPARE t703_sfa_cur_pre1 FROM l_sql
   DECLARE t703_sfa_cur_c1 CURSOR FOR t703_sfa_cur_pre1 #產生備料
END FUNCTION
 
FUNCTION t703_ecm_cur()
DEFINE l_sql STRING
   LET l_sql="SELECT * FROM ecm_file ",
                    " WHERE ecm01= ? ",         #工單編號
                    "   AND ecm03>= ? ",         #製程序
                    "   AND ecm012 = ?"          #FUN-A60027  add by huangtao
   PREPARE t703_ecm_cur_pre FROM l_sql
   DECLARE t703_ecm_cur_c CURSOR FOR t703_ecm_cur_pre
END FUNCTION
 
FUNCTION t703_g()  #產生發/退料單
DEFINE l_shj RECORD LIKE shj_file.*
DEFINE l_shb RECORD LIKE shb_file.*
DEFINE l_sfa RECORD LIKE sfa_file.*
DEFINE l_sql STRING
DEFINE l_cnt,l_n,l_i LIKE type_file.num10     #No.FUN-680121 INTEGER
DEFINE li_result LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE l_shj02 LIKE shj_file.shj02,
       l_shj03 LIKE shj_file.shj03,
       l_ecm03 LIKE ecm_file.ecm03
DEFINE sr RECORD
             shj10 LIKE shj_file.shj10,
             shj11 LIKE shj_file.shj11,
             shj12 LIKE shj_file.shj12
          END RECORD
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_shj.shj01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=g_shj.shj01
   IF l_cnt = 0 THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='Y'
   IF l_cnt>0 THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='X'
   IF l_cnt>0 THEN
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   LET l_sql=g_shj.shj02 CLIPPED
   
   IF l_sql.getlength() > g_doc_len+1 THEN
      CALL cl_err('','asf-761',1)
      RETURN
   END IF
   
   LET l_sql=g_shj.shj03 CLIPPED
   
   IF l_sql.getlength()-1 > g_doc_len+1 THEN
      CALL cl_err('','asf-761',1)
      RETURN
   END IF
 
   SELECT * INTO g_shj.* FROM shj_file
                        WHERE shj01=g_shj.shj01
   SELECT * INTO g_shb.* FROM shb_file
                        WHERE shb01=g_shj.shj01
   IF cl_null(g_shb.shb01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   IF cl_null(g_shj.shj04) AND cl_null(g_shj.shj07) THEN
      CALL cl_err('','asf-770',1)
      RETURN 
   END IF
 
   IF NOT cl_confirm('afa-347') THEN
      LET g_success='N'
      RETURN 
   END IF
 
   LET g_success='Y'
   BEGIN WORK
   LET l_shj02=g_shj.shj02
   #退料單單頭
   CALL s_auto_assign_no("asf",l_shj02,g_shj.shj13,"","sfp_file","sfp01","","","")
       RETURNING li_result,l_shj02
   IF (NOT li_result) THEN
      LET g_success='N'
   END IF
   CALL t703_g_sfp(l_shj02,'6')
   
   LET l_n=1
   #退料單單身  (小於轉出工單的製程序的所有作業的備料都退料)
   CALL s_showmsg_init()    #NO.FUN-710026
   FOREACH t703_sfa_cur_c1 USING g_shb.shb05 INTO l_sfa.*
      IF SQLCA.sqlcode THEN
#        CALL cl_err3("sel sfa","sfa_file",g_shb.shb05,"",SQLCA.sqlcode,"","",1)        #NO.FUN-710026
         CALL s_errmsg('','',g_shb.shb05,SQLCA.sqlcode,1)                               #NO.FUN-710026
         LET g_success='N'
      END IF
#NO.FUN-710026-----begin add
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
#NO.FUN-710026-----end
 
      IF l_sfa.sfa06 >= (g_shb.shb17*l_sfa.sfa161) THEN #已發>=套數*QPA 則產生退料套數  #消耗性料件的已發量必為0
      #  {
      #  SELECT ecm03 INTO l_ecm03 FROM ecm_file 
      #                           WHERE ecm01=l_sfa.sfa01
      #                             AND ecm04=l_sfa.sfa08
      #  IF l_ecm03<g_shb.shb06 THEN #小於轉出工作中心的製程序,則帶本轉出的作業編號,成本皆歸本轉出作業
      #     LET l_sfa.sfa08=g_shb.shb081
      #  END IF
      #  }
         CALL t703_g_sfq(l_shj02,g_shb.shb05,l_sfa.sfa08,g_shb.shb17)
         CALL t703_g_sfs(l_shj02,l_sfa.*,l_n,g_shb.shb17)
         LET l_n=l_n+1
      END IF
   END FOREACH
#NO.FUN-710026----begin 
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#NO.FUN-710026----end
   
   #未產生單身刪除單頭資料
   IF l_n=1 THEN
      DELETE FROM sfq_file WHERE sfq01=l_shj02
      DELETE FROM sfp_file WHERE sfp01=l_shj02
   END IF
 
   CALL m_shj.clear()
   #產生工單   備料單  製程追蹤單
   LET l_sql="SELECT shj10,shj11,shj12 FROM shj_file ",
                                    " WHERE shj01= ? ",
                                    " ORDER BY shj10"
   PREPARE t703_g_pre2 FROM l_sql
   DECLARE t703_g_c2 CURSOR FOR t703_g_pre2
   FOREACH t703_g_c2 USING g_shj.shj01 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel shj","shj_file",g_shj.shj01,"",SQLCA.sqlcode,"","",1)
         LET g_success='N'
      END IF
      CALL t703_g_wo(sr.*)
   END FOREACH
 
   #發料單單頭
   LET l_shj03=g_shj.shj03
   CALL s_auto_assign_no("asf",l_shj03,g_shj.shj13,"","sfp_file","sfp01","","","")
       RETURNING li_result,l_shj03
   IF (NOT li_result) THEN
      LET g_success='N'
   END IF
   CALL t703_g_sfp(l_shj03,'1')
 
   LET l_i=1
   #發料單單身  (小於轉出工單的製程序的所有作業的備料都發料)
   FOR l_n=1 TO m_shj.getlength()
      FOREACH t703_sfa_cur_c1 USING g_shb.shb05 INTO l_sfa.*
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel sfa","sfa_file",g_shb.shb05,"",SQLCA.sqlcode,"","",1)
            LET g_success='N'
         END IF
         SELECT ecm03 INTO l_ecm03 FROM ecm_file 
                                  WHERE ecm01=l_sfa.sfa01
                                    AND ecm04=l_sfa.sfa08
                                    AND ecm012=l_sfa.sfa012     #FUN-A60027 add by huangtao
         #MOD-750009.............begin
         IF SQLCA.sqlcode THEN #不存在製程檔的作業編號,視為本轉出製程序
            LET l_ecm03=g_shb.shb06
         END IF
         #MOD-750009.............end
         IF l_ecm03<g_shb.shb06 THEN #轉出站以前的作業,不產生套數
            LET l_sfa.sfa08=g_shb.shb081
         ELSE
            IF l_sfa.sfa06 >= (g_shb.shb17*l_sfa.sfa161) THEN #已發>=套數*QPA 則產生發料套數  #消耗性料件的已發量必為0
               LET l_sfa.sfa01=m_shj[l_n].shj11
               CALL t703_g_sfq(l_shj03,l_sfa.sfa01,l_sfa.sfa08,m_shj[l_n].shj12)
            END IF
         END IF
         IF l_sfa.sfa06 >= (g_shb.shb17*l_sfa.sfa161) THEN #已發>=套數*QPA 則產生發料套數  #消耗性料件的已發量必為0
            LET l_sfa.sfa01=m_shj[l_n].shj11
            CALL t703_g_sfs(l_shj03,l_sfa.*,l_i,m_shj[l_n].shj12)
            LET l_i=l_i+1
         END IF
      END FOREACH
   END FOR
   #未產生單身刪除單頭資料
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM sfs_file 
                             WHERE sfs01=l_shj03                             
   IF l_cnt=0 THEN
      DELETE FROM sfq_file WHERE sfq01=l_shj03
      DELETE FROM sfp_file WHERE sfp01=l_shj03
   END IF
   
   IF g_success='Y' THEN  #更新shj_file相關單據編號
      LET g_shj.shj02=l_shj02
      LET g_shj.shj03=l_shj03
      FOR l_n=1 TO m_shj.getlength()
         UPDATE shj_file SET shj02=g_shj.shj02,
                             shj03=g_shj.shj03,
                             shj11=m_shj[l_n].shj11
                       WHERE shj01=g_shj.shj01
                         AND shj10=m_shj[l_n].shj10
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","shj_file",g_shj.shj01,m_shj[l_n].shj10,SQLCA.sqlcode,"","",1)
         END IF
      END FOR
   END IF
   
   IF g_success='Y' THEN      
      COMMIT WORK
      CALL t703_show()
      CALL cl_err('','asr-026',0)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','9052',0)
   END IF   
END FUNCTION
 
FUNCTION t703_g_sfp(p_note,p_sfp06) #新增發退料單頭
DEFINE l_sfp RECORD LIKE sfp_file.*
DEFINE p_note LIKE sfp_file.sfp01
DEFINE p_sfp06 LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)#6:退料單 ; 1:發料單
 
   LET l_sfp.sfp01=p_note
   LET l_sfp.sfp02=g_shj.shj13
   LET l_sfp.sfp03=g_shj.shj13
   LET l_sfp.sfp04='N'
   LET l_sfp.sfpconf='N'
   LET l_sfp.sfp05='N'
   LET l_sfp.sfp06=p_sfp06
   LET l_sfp.sfp07=g_grup
   LET l_sfp.sfp09='N'
   LET l_sfp.sfpuser=g_user
   LET g_data_plant = g_plant #FUN-980030
   LET l_sfp.sfpdate=g_today
   LET l_sfp.sfpplant = g_plant #FUN-980008 add
   LET l_sfp.sfplegal = g_legal #FUN-980008 add
   LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
   LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
   #FUN-AB0001--add---str---
   LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET l_sfp.sfp15 = '0'            #簽核狀況
   LET l_sfp.sfp16 = g_user         #申請人
   #FUN-AB0001--add---end---

   INSERT INTO sfp_file VALUES(l_sfp.*)
   IF STATUS THEN
#     CALL cl_err3("ins sfp","sfp_file",p_note,"",STATUS,"","ins sfp:",1)       #NO.FUN-710026
      CALL s_errmsg('sfp01','',"ins sfp:",STATUS,1)                             #NO.FUN-710026
      LET g_success='N' 
   END IF
# { 
#  CASE p_sfp06
#     WHEN '6'
#        LET l_sfq.sfq01=l_sfp.sfp01
#        LET l_sfq.sfq02=g_shb.shb05
#        LET l_sfq.sfq03=g_shb.shb17
#        LET l_sfq.sfq04=g_shb.shb081
#        INSERT INTO sfq_file VALUES(l_sfq.*)
#        IF STATUS THEN
#           CALL cl_err3("ins sfq","sfq_file",p_note,"",STATUS,"","ins sfq:",1)           #NO.FUN-710026
#           CALL s_errmsg( 'sfq01,sfq02,sfq04,sfq05','',"ins sfq:",STATUS,1)              #NO.FUN-710026 
#           LET g_success='N'
#        END IF
#     WHEN '1' #必須在新增工單t703_g_wo()之後呼叫,m_shj才會有值
#        FOR l_n=1 TO m_shj.getlength()
#           LET l_sfq.sfq01=l_sfp.sfp01
#           LET l_sfq.sfq02=m_shj[l_n].shj11
#           LET l_sfq.sfq03=m_shj[l_n].shj12
#           LET l_sfq.sfq04=g_shb.shb081
#           INSERT INTO sfq_file VALUES(l_sfq.*)
#           IF STATUS THEN
#              CALL cl_err3("ins sfq","sfq_file",p_note,"",STATUS,"","ins sfq:",1)           #NO.FUN-710026
#              CALL s_errmsg( 'sfq01,sfq02,sfq04,sfq05','',"ins sfq:",STATUS,1)              #NO.FUN-710026
#              LET g_success='N'
#              RETURN
#           END IF
#        END FOR
#  END CASE
#  }
END FUNCTION
 
FUNCTION t703_g_sfq(p_note,l_sfa01,l_sfa08,l_sfq03)
DEFINE p_note LIKE sfq_file.sfq01,
       l_sfa01 LIKE sfa_file.sfa01,
       l_sfa08 LIKE sfa_file.sfa08,
       l_sfq03 LIKE sfq_file.sfq03
DEFINE l_sfq RECORD LIKE sfq_file.*
DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
   
   SELECT COUNT(*) INTO l_cnt FROM sfq_file WHERE sfq01=p_note
                                              AND sfq02=l_sfa01
                                              AND sfq04=l_sfa08
   IF l_cnt>0 THEN #小於本製程的作業,發料全部併到本轉出製程的作業發
     #MOD-860022-begin-mark
     #會重複計算發料套數
     # UPDATE sfq_file SET sfq03 = sfq03 + l_sfq03
     #               WHERE sfq01 = p_note
     #                 AND sfq02 = l_sfa01
     #                 AND sfq04 = l_sfa08
     # IF STATUS OR (SQLCA.sqlerrd[3]=0) THEN
#    #    CALL cl_err3("upd sfq","sfq_file",p_note,"",STATUS,"","ins sfq:",19)        #NO.FUN-710026
     #    LET g_showmsg=p_note,"/",l_sfa01,"/",l_sfa08                                #NO.FUN-710026
     #    CALL s_errmsg('sfq01,sfq02,sfq04',g_showmsg,"upd sfq:",STATUS,1)            #NO.FUN-710026
     #    LET g_success='N'
     # END IF
     #MOD-860022-end-mark
      RETURN   #MOD-860022 add
   ELSE
      LET l_sfq.sfq01=p_note
      LET l_sfq.sfq02=l_sfa01
      LET l_sfq.sfq03=l_sfq03
      LET l_sfq.sfq04=l_sfa08
      LET l_sfq.sfqplant = g_plant #FUN-980008 add
      LET l_sfq.sfqlegal = g_legal #FUN-980008 add
      LET l_sfq.sfq012 = ' '       #FUN-B20095
      LET l_sfq.sfq014 = ' '       #FUN-C70014
      INSERT INTO sfq_file VALUES(l_sfq.*)
      IF STATUS THEN
#        CALL cl_err3("ins sfq","sfq_file",p_note,"",STATUS,"","ins sfq:",1)           #NO.FUN-710026
         LET g_showmsg=p_note,"/",l_sfa01,"/",l_sfa08                                  #NO.FUN-710026
         CALL s_errmsg( 'sfq01,sfq02,sfq04,',g_showmsg,"ins sfq:",STATUS,1)            #NO.FUN-710026
         LET g_success='N'
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t703_g_sfs(p_note,l_sfa,l_cnt,l_sfs05) #新增發退料單身
   DEFINE p_note LIKE sfp_file.sfp01
   DEFINE l_sfa RECORD LIKE sfa_file.*
   DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
   DEFINE l_sfs RECORD LIKE sfs_file.*
   DEFINE l_sfsi  RECORD LIKE sfsi_file.*    #FUN-B70074 
   DEFINE l_ima55 LIKE ima_file.ima55,
          l_ima906 LIKE ima_file.ima906,
          l_ima907 LIKE ima_file.ima907,
          l_ima908 LIKE ima_file.ima908
   DEFINE l_factor LIKE ima_file.ima31_fac       #No.FUN-680121 DECIMAL(16,8)
   DEFINE l_sfs05  LIKE sfs_file.sfs05
   DEFINE l_ima108 LIKE ima_file.ima108
   #CHI-B80094 -- begin --
   DEFINE l_n      LIKE type_file.num10
   DEFINE l_sfp    RECORD LIKE sfp_file.*
   #CHI-B80094 -- end --
 
   LET l_sfs.sfs01=p_note
   LET l_sfs.sfs02=l_cnt
   LET l_sfs.sfs03=l_sfa.sfa01
   LET l_sfs.sfs04=l_sfa.sfa03
   LET l_sfs.sfs05=l_sfs05*l_sfa.sfa161
   LET l_sfs.sfs06=l_sfa.sfa12
   LET l_sfs.sfs05=s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #FUN-BB0084
   
   #CHI-B80094 -- begin --
   SELECT * INTO l_sfp.* FROM sfp_file
    WHERE sfp01 = p_note
   #CHI-B80094 -- end --

   #若為SMT料必須WIP倉
   SELECT ima108 INTO l_ima108 FROM ima_file
               WHERE ima01=l_sfs.sfs04
 
   CASE l_ima108
      WHEN 'Y'   #WIP倉
         LET l_sfs.sfs07=g_shj.shj07
         LET l_sfs.sfs08=g_shj.shj08
         LET l_sfs.sfs09=g_shj.shj09
         IF cl_null(l_sfs.sfs07) THEN #如果STK倉未指定,則代WIP倉
            LET l_sfs.sfs07=g_shj.shj04
            LET l_sfs.sfs08=g_shj.shj05
            LET l_sfs.sfs09=g_shj.shj06
         END IF
      OTHERWISE  #STK倉
         LET l_sfs.sfs07=g_shj.shj04
         LET l_sfs.sfs08=g_shj.shj05
         LET l_sfs.sfs09=g_shj.shj06
         IF cl_null(l_sfs.sfs07) THEN #如果WIP倉未指定,則代STK倉
            LET l_sfs.sfs07=g_shj.shj07
            LET l_sfs.sfs08=g_shj.shj08
            LET l_sfs.sfs09=g_shj.shj09
         END IF
   END CASE     
 
   IF cl_null(l_sfs.sfs07) THEN LET l_sfs.sfs07=' ' END IF
   IF cl_null(l_sfs.sfs08) THEN LET l_sfs.sfs08=' ' END IF
   IF cl_null(l_sfs.sfs09) THEN LET l_sfs.sfs09=' ' END IF

   #CHI-B80094 -- begin --
   IF l_sfp.sfp06 = '6' THEN
      SELECT COUNT(*) INTO l_n FROM img_file
       WHERE img01 = l_sfs.sfs04  #料號
         AND img02 = l_sfs.sfs07  #倉
         AND img03 = l_sfs.sfs08  #儲
         AND img04 = l_sfs.sfs09  #批
      IF l_n = 0 THEN
         CALL s_add_img(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,
                        l_sfp.sfp01,l_sfs.sfs02,l_sfp.sfp02)
      END IF
   END IF
   #CHI-B80094 -- end --
   
   LET l_sfs.sfs10=l_sfa.sfa08   
   IF g_aaz.aaz90='Y' THEN
      SELECT sfb98 INTO l_sfs.sfs930 FROM sfb_file
                                    WHERE sfb01=l_sfa.sfa01
   END IF
   IF g_sma.sma115 = 'Y' THEN
      LET l_sfs.sfs30 = l_sfs.sfs06
      SELECT ima55,ima906,ima907,ima908 INTO 
         l_ima55,l_ima906,l_ima907,l_ima908 FROM ima_file
                                           WHERE ima01=l_sfs.sfs04
      CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_ima55)
         RETURNING g_errno,l_factor
      LET l_sfs.sfs31 = l_factor
      LET l_sfs.sfs32 = l_sfs.sfs05 / l_factor
      LET l_sfs.sfs32 = s_digqty(l_sfs.sfs32,l_sfs.sfs30)   #FUN-BB0084
      IF l_ima906 = '1' THEN  #不使用雙單位
         LET l_sfs.sfs33 = NULL
         LET l_sfs.sfs34 = NULL
         LET l_sfs.sfs35 = NULL
      ELSE
         LET l_sfs.sfs33 = l_ima907
         CALL s_du_umfchk(l_sfs.sfs04,'','','',l_ima55,l_ima907,l_ima906)
              RETURNING g_errno,l_factor
         LET l_sfs.sfs34 = l_factor
         LET l_sfs.sfs35 = 0
      END IF
   END IF
   #No.MOD-8B0086 add --begin
   IF cl_null(l_sfs.sfs27) THEN
      LET l_sfs.sfs27 = l_sfs.sfs04
   END IF
   #No.MOD-8B0086 add --end
 
   LET l_sfs.sfsplant = g_plant #FUN-980008 add
   LET l_sfs.sfslegal = g_legal #FUN-980008 add
   LET l_sfs.sfs012 = l_sfa.sfa012 #FUN-A60027 add
   LET l_sfs.sfs013 = l_sfa.sfa013 #FUN-A60027 add
   
#FUN-A70125 --begin--
      IF cl_null(l_sfs.sfs012) THEN
         LET l_sfs.sfs012 = ' '
      END IF
      IF cl_null(l_sfs.sfs013) THEN
        LET l_sfs.sfs013 = 0
      END IF
#FUN-A70125 --end--
#FUN-C70014 --begin-------------------
   IF cl_null(l_sfs.sfs014) THEN
      LET l_sfs.sfs014 = ' '
   END IF   
#FUN-C70014 --end---------------------
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp.sfp16,l_sfp.sfp07) RETURNING l_sfs.sfs37
      IF cl_null(l_sfs.sfs37) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfs_file VALUES (l_sfs.*)
   IF SQLCA.sqlcode THEN
#     LET g_success='N'                                                     #NO.FUN-710026          
#     CALL cl_err3("ins sfs","sfs_file",p_note,"",SQLCA.sqlcode,"","",1)    #NO.FUN-710026
      CALl s_errmsg('sfs01,sfs02','',"ins sfs",SQLCA.sqlcode,1)             #NO.FUN-710026
      LET g_success='N'                                                     #NO.FUN-710026          
#FUN-B70074 --------------Begin---------------
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfsi.* TO NULL
         LET l_sfsi.sfsi01 = l_sfs.sfs01
         LET l_sfsi.sfsi02 = l_sfs.sfs02
         IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN          
            LET g_success='N'
         END IF 
      END IF
#FUN-B70074 --------------End-----------------
 END IF
END FUNCTION
 
FUNCTION t703_g_wo(sr) #新增工單  備料單  製程追蹤單
DEFINE sr RECORD
             shj10 LIKE shj_file.shj10,
             shj11 LIKE shj_file.shj11,
             shj12 LIKE shj_file.shj12
          END RECORD,
       l_sfb RECORD LIKE sfb_file.*,
       l_sfa RECORD LIKE sfa_file.*,
       l_ecm RECORD LIKE ecm_file.*
DEFINE li_result LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       l_sql     STRING,
       l_n       LIKE type_file.num10,         #No.FUN-680121 INTEGER
       l_ecm03   LIKE ecm_file.ecm03
DEFINE l_ima56   LIKE ima_file.ima56           #MOD-750009
DEFINE l_factor  LIKE ima_file.ima31_fac       #MOD-750009
DEFINE l_double  LIKE type_file.num10          #MOD-750009
DEFINE l_cnt     LIKE type_file.num5           #MOD-750009
DEFINE l_ima55   LIKE ima_file.ima55           #MOD-750009
DEFINE l_sfai    RECORD LIKE sfai_file.*       #No.FUN-7B0018
DEFINE l_sfbi    RECORD LIKE sfbi_file.*       #No.FUN-7B0018
DEFINE l_ecm012  LIKE ecm_file.ecm012          #CHI-B80096
DEFINE l_ecb19   LIKE ecb_file.ecb19           #No:MOD-B90264 add
DEFINE l_ecb21   LIKE ecb_file.ecb21           #No:MOD-B90264 add
DEFINE l_ecb38   LIKE ecb_file.ecb38           #No:MOD-B90264 add
 
   INITIALIZE l_sfb.* TO NULL
   INITIALIZE l_sfa.* TO NULL
   
   #產生工單
   SELECT * INTO l_sfb.* FROM sfb_file
                      WHERE sfb01=g_shb.shb05
   
   LET l_sfb.sfb01 =sr.shj11
   LET l_sfb.sfb04 ='2'
   LET l_sfb.sfb81=g_shj.shj13
   LET l_sfb.sfb13=g_shj.shj13
   LET l_sfb.sfb08=sr.shj12
   LET l_sfb.sfb87='Y'
   LET l_sfb.sfb25=''
   LET l_sfb.sfb081=0
   LET l_sfb.sfb09=0
   LET l_sfb.sfb10=0
   LET l_sfb.sfb11=0
   LET l_sfb.sfb12=0
   LET l_sfb.sfb121=0
   LET l_sfb.sfb1002='N' #保稅核銷否 #FUN-6B0044
   LET l_sfb.sfbplant = g_plant #FUN-980008 add
   LET l_sfb.sfblegal = g_legal #FUN-980008 add
   LET l_n=m_shj.getlength()+1
   CALL s_auto_assign_no("asf",l_sfb.sfb01,l_sfb.sfb81,"","sfb_file","sfb01","","","") 
   RETURNING li_result,l_sfb.sfb01                                                                                             
   IF (NOT li_result) THEN                                                                                                       
       LET g_success='N' 
       RETURN 
   END IF
   LET m_shj[l_n].shj10=sr.shj10
   LET m_shj[l_n].shj11=l_sfb.sfb01
   LET m_shj[l_n].shj12=sr.shj12
   LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
   LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
   LET l_sfb.sfb104 = 'N'          #NO.TQC-A50087 add
   INSERT INTO sfb_file VALUES (l_sfb.*)
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err('ins sfb',SQLCA.sqlcode,1)
      RETURN
   END IF
   #NO.FUN-7B0018 08/02/25 add --begin
   IF NOT s_industry('std') THEN
      INITIALIZE l_sfbi.* TO NULL
      LET l_sfbi.sfbi01 = l_sfb.sfb01
      IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
         RETURN
      END IF
   END IF
   #NO.FUN-7B0018 08/02/25 add --end
 
   #產生備料單
   FOREACH t703_sfa_cur_c1 USING g_shb.shb05 INTO l_sfa.* #,g_shb.shb06
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel sfa","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","",1)
         LET g_success='N'
         RETURN
      END IF
 
      SELECT ecm03 INTO l_ecm03 FROM ecm_file
                               WHERE ecm01=l_sfa.sfa01
                                 AND ecm04=l_sfa.sfa08
                                 AND ecm012=l_sfa.sfa012      #FUN-A60027 add by huangtao
      #MOD-750009.............begin
      IF SQLCA.sqlcode THEN #不存在製程檔的作業編號,視為本轉出製程序
         LET l_ecm03=g_shb.shb06
      END IF
      #MOD-750009.............end
      IF l_ecm03<g_shb.shb06 THEN #小於轉出工作中心的製程序,則帶本轉出的作業編號,成本皆歸本轉出作業
         LET l_sfa.sfa08=g_shb.shb081
      END IF
 
      LET l_sfa.sfa01  = l_sfb.sfb01
      LET l_sfa.sfa05  = sr.shj12*l_sfa.sfa161
      LET l_sfa.sfa05  = s_digqty(l_sfa.sfa05,l_sfa.sfa12)   #FUN-BB0085
      LET l_sfa.sfa06  = 0
   #  LET l_sfa.sfa07  = 0   #FUN-940008 mark
      LET l_sfa.sfa062 = 0
      LET l_sfa.sfa063 = 0
      LET l_sfa.sfa064 = 0
      LET l_sfa.sfaplant = g_plant #FUN-980008 add
      LET l_sfa.sfalegal = g_legal #FUN-980008 add
      
#FUN-A70125 --begin--
      IF cl_null(l_sfa.sfa012) THEN
         LET l_sfa.sfa012 = ' '
      END IF
      IF cl_null(l_sfa.sfa013) THEN
        LET l_sfa.sfa013 = 0
      END IF
#FUN-A70125 --end--
      INSERT INTO sfa_file VALUES (l_sfa.*)
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("ins sfa","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","",1)
      #NO.FUN-7B0018 08/02/25 add --begin
      ELSE 
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfai.* TO NULL
            LET l_sfai.sfai01 = l_sfa.sfa01
            LET l_sfai.sfai03 = l_sfa.sfa03
            LET l_sfai.sfai08 = l_sfa.sfa08
            LET l_sfai.sfai12 = l_sfa.sfa12
            LET l_sfai.sfai012 = l_sfa.sfa012   #FUN-A60027 add by vealxu 
            LET l_sfai.sfai013 = l_sfa.sfa013   #FUN-A60027 add by vealxu  
            IF NOT s_ins_sfai(l_sfai.*,'') THEN
               LET g_success='N'
            END IF
         END IF
      #NO.FUN-7B0018 08/02/25 add --end
      END IF
   END FOREACH
 
   #產生製程追蹤檔(ecm_file)
   FOREACH t703_ecm_cur_c USING g_shb.shb05,g_shb.shb06,g_shb.shb012 INTO l_ecm.*   #FUN-A60027 modify by huangtao
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel ecm","ecm_file",g_shb.shb05,g_shb.shb06,SQLCA.sqlcode,"","",1)
         LET g_success='N'
         RETURN
      END IF
 
      LET l_ecm.ecm01 = l_sfb.sfb01
      LET l_ecm.ecm65 =  0            #CHI-B80096
      LET l_ecm.ecm291 = 0
      LET l_ecm.ecm292 = 0
      LET l_ecm.ecm301 = 0
 #    LET l_ecm.ecm301 = 0   #FUN-BB0084  mark
      LET l_ecm.ecm302 = 0
      LET l_ecm.ecm303 = 0
      LET l_ecm.ecm311 = 0
      LET l_ecm.ecm312 = 0
      LET l_ecm.ecm313 = 0
      LET l_ecm.ecm314 = 0
      LET l_ecm.ecm315 = 0
      LET l_ecm.ecm316 = 0
      LET l_ecm.ecm321 = 0
      LET l_ecm.ecm322 = 0
      LET l_ecm.ecmplant = g_plant #FUN-980008 add
      LET l_ecm.ecmlegal = g_legal #FUN-980008 add
      
     #------------------No:MOD-B90264 add
      LET l_ecb19 = 0
      LET l_ecb21 = 0
      LET l_ecb38 = 0
      SELECT ecb19,ecb21,ecb38 INTO l_ecb19,l_ecb21,l_ecb38 FROM ecb_file,ecu_file
          WHERE ecb01 = l_sfb.sfb05
              AND ecb02 = l_sfb.sfb06
              AND ecb03 = l_ecm.ecm03
              AND ecbacti = 'Y'
              AND ecu01 = ecb01 
              AND ecu02 = ecb02 
              AND ecu10 = 'Y'   
              AND ecb012=ecu012

      IF cl_null(l_ecb19) THEN LET l_ecb19 = 0 END IF
      IF cl_null(l_ecb21) THEN LET l_ecb21 = 0 END IF
      IF cl_null(l_ecb38) THEN LET l_ecb38 = 0 END IF
      LET l_ecm.ecm14      =  l_ecb19*l_sfb.sfb08    #標準工時(秒)
      LET l_ecm.ecm16      =  l_ecb21*l_sfb.sfb08    #標準機時(秒)
      LET l_ecm.ecm49      =  l_ecb38*l_sfb.sfb08    #製程人力
     #------------------No:MOD-B90264 end
     
      #MOD-750009.............begin
      IF l_ecm.ecm03=g_shb.shb06 THEN #轉入的第一站,設定工單轉入數量
         SELECT ima55,ima56 INTO l_ima55,l_ima56
                            FROM ima_file
                           WHERE ima01=l_sfa.sfa03
         CALL s_umfchk(l_sfb.sfb05,l_sfa.sfa12,l_ima55) RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN LET l_factor=1 END IF
 
         IF l_ima56 != 0 THEN
            LET l_double=(l_sfb.sfb08*l_factor/l_ima56)+ 0.999999
            LET l_ecm.ecm303=l_double*l_ima56
         ELSE
            LET l_ecm.ecm303 = l_sfb.sfb08*l_factor
         END IF
         LET l_ecm.ecm303 = s_digqty(l_ecm.ecm303,l_ecm.ecm58)   #FUN-BB0084 
      END IF
      #MOD-750009.............end
      LET l_ecm.ecmoriu = g_user      #No.FUN-980030 10/01/04
      LET l_ecm.ecmorig = g_grup      #No.FUN-980030 10/01/04
#FUN-A70125 --begin--
      IF cl_null(l_ecm.ecm012) THEN
         LET l_ecm.ecm012 = ' '
      END IF
#FUN-A70125 --end--
      IF cl_null(l_ecm.ecm66) THEN LET l_ecm.ecm66 = 'Y' END IF #TQC-B80022
      IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1  END IF    #CHI-B80096
      IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1  END IF    #CHI-B80096
      INSERT INTO ecm_file VALUES (l_ecm.*)
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("ins ecm","ecm_file",l_ecm.ecm01,l_ecm.ecm03,SQLCA.sqlcode,"","",1)
      END IF
   END FOREACH
   #CHI-B80096-add-str--
   IF g_success='Y' THEN 
      DECLARE ecm012_cs CURSOR FOR
       SELECT DISTINCT ecm012 FROM ecm_file WHERE ecm01 = l_sfb.sfb01 AND (ecm015 IS NULL OR ecm015=' ')
      FOREACH ecm012_cs INTO l_ecm012
         EXIT FOREACH
      END FOREACH
      CALL s_schdat_output(l_ecm012,l_sfb.sfb08,l_sfb.sfb01)
   END IF
   #CHI-B80096-add-end--
END FUNCTION
 
FUNCTION t703_k() #刪除相關單據
DEFINE l_n,l_cnt LIKE type_file.num10  #No.FUN-680121 INTEGER
DEFINE l_sql STRING
DEFINE l_sfa RECORD LIKE sfa_file.*    #No.FUN-830132 0804041 add
DEFINE l_sfb RECORD LIKE sfb_file.*    #No.FUN-830132 0804041 add
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_shj.shj01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   SELECT * INTO g_shj.* FROM shj_file
                        WHERE shj01=g_shj.shj01
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file
    WHERE shj01=g_shj.shj01
   IF l_cnt = 0 THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='Y'
   IF l_cnt>0 THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM shj_file 
                             WHERE shj01 = g_shj.shj01
                               AND shjconf='X'
   IF l_cnt>0 THEN
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
 
   #刪除前檢查發退料單是否已確認
   SELECT COUNT(*) INTO l_cnt FROM sfp_file
                             WHERE (sfp01=g_shj.shj02
                               OR  sfp01=g_shj.shj03)
                               AND (sfpconf='Y' OR sfp04='Y')
   IF l_cnt>0 THEN
      CALL cl_err('del chk','asf-767',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('asf-766') THEN
      RETURN 
   END IF
   
   LET g_success='Y'   
   BEGIN WORK
   
   DELETE FROM sfs_file WHERE sfs01=g_shj.shj02
                           OR sfs01=g_shj.shj03
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err3("del sfs","sfs_file","","",SQLCA.sqlcode,"","",1)
#FUN-B70074 -----------Begin-----------------
   ELSE
      IF NOT s_industry('std') THEN
         IF NOT (s_del_sfsi(g_shj.shj02,'','') OR s_del_sfsi(g_shj.shj03,'','')) THEN
            LET g_success='N'
         END IF
      END IF      
#FUN-B70074 -----------End-------------------
   END IF
   
   DELETE FROM sfq_file WHERE sfq01=g_shj.shj02
                           OR sfq01=g_shj.shj03
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err3("del sfq","sfq_file","","",SQLCA.sqlcode,"","",1)
   END IF
 
   DELETE FROM sfp_file WHERE sfp01=g_shj.shj02
                           OR sfp01=g_shj.shj03
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err3("del sfp","sfp_file","","",SQLCA.sqlcode,"","",1)
   END IF
 
   DELETE FROM ecm_file WHERE ecm01 IN 
       (SELECT DISTINCT shj11 FROM shj_file WHERE shj01=g_shj.shj01)
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL cl_err3("del ecm","ecm_file","","",SQLCA.sqlcode,"","",1)
   END IF
   
   #No.FUN-830132 0804041 mark --begin
#  DELETE FROM sfa_file WHERE sfa01 IN 
#      (SELECT DISTINCT shj11 FROM shj_file WHERE shj01=g_shj.shj01)
   #No.FUN-830132 0804041 mark --end
 
   #No.FUN-830132 0804041 add --begin
   DECLARE sel_sfa CURSOR FOR
    SELECT * FROM sfa_file
     WHERE sfa01 IN
          (SELECT DISTINCT shj11 
             FROM shj_file 
            WHERE shj01 = g_shj.shj01)
   FOREACH sel_sfa INTO l_sfa.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      DELETE FROM sfa_file
       WHERE sfa01 = l_sfa.sfa01
         AND sfa03 = l_sfa.sfa03
         AND sfa08 = l_sfa.sfa08
         AND sfa12 = l_sfa.sfa12
         AND sfa27 = l_sfa.sfa27 #CHI-7B0034
   #No.FUN-830132 0804041 add --end
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("del sfa","sfa_file","","",SQLCA.sqlcode,"","",1)
   #No.FUN-830132 0804041 add --begin
      ELSE
         IF NOT s_industry('std') THEN
            IF NOT s_del_sfai(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
                              l_sfa.sfa12,l_sfa.sfa27,'',l_sfa.sfa012,l_sfa.sfa013) THEN #CHI-7B0034   #FUN-A60027 add sfa012,sfa013
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF
      END IF
   END FOREACH
   #No.FUN-830132 0804041 add --end
      #No.FUN-830132 0804041 mark --begin
#     #No.FUN-7B0018 add 08/02/25 --begin
#     IF NOT s_industry('std') THEN
#        DELETE FROM sfai_file
#         WHERE sfai01 IN
#               (SELECT sfai01 FROM sfa_file,sfai_file
#                 WHERE sfai01 = sfa01
#                   AND sfai03 = sfa03
#                   AND sfai08 = sfa08
#                   AND sfai12 = sfa12
#                   AND sfa01 IN 
#                      (SELECT DISTINCT shj11
#                         FROM shj_file
#                        WHERE shj01=g_shj.shj01))
#        IF SQLCA.sqlcode THEN
#           LET g_success = 'N'
#           CALL cl_err3("del sfai","sfai_file","","",SQLCA.sqlcode,"","",1) 
#        END IF
#     END IF
#  #No.FUN-7B0018 add 08/02/25 --end
#  END IF
   #No.FUN-830132 0804041 mark --end
   
   #No.FUN-830132 0804041 mark --begin
#  DELETE FROM sfb_file WHERE sfb01 IN 
#      (SELECT DISTINCT shj11 FROM shj_file WHERE shj01=g_shj.shj01)
   #No.FUN-830132 0804041 mark --end
 
   #No.FUN-830132 0804041 add --begin
   DECLARE sel_sfb CURSOR FOR
    SELECT * FROM sfb_file
     WHERE sfb01 IN
          (SELECT DISTINCT shj11 
             FROM shj_file 
            WHERE shj01 = g_shj.shj01)
#  FOREACH sel_sfa INTO l_sfb.*   #TQC-C90044
   FOREACH sel_sfb INTO l_sfb.*   #TQC-C90044
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      DELETE FROM sfb_file
       WHERE sfb01 = l_sfb.sfb01
   #No.FUN-830132 0804041 add --end
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("del sfb","sfb_file","","",SQLCA.sqlcode,"","",1)
   #No.FUN-830132 0804041 add --begin
      ELSE
         IF NOT s_industry('std') THEN
            IF NOT s_del_sfbi(l_sfb.sfb01,'') THEN
               LET g_success = 'N'
            END IF
         END IF
      END IF
   END FOREACH
   #No.FUN-830132 080401 mark --begin
#     IF NOT s_industry('std') THEN
#        DELETE FROM sfbi_file
#         WHERE sfbi01 IN
#               (SELECT sfbi01 FROM sfb_file,sfbi_file
#                 WHERE sfbi01 = sfb01
#                   AND sfb01 IN 
#                      (SELECT DISTINCT shj11
#                         FROM shj_file
#                        WHERE shj01=g_shj.shj01))
#        IF SQLCA.sqlcode THEN
#           LET g_success = 'N'
#           CALL cl_err3("del sfbi","sfbi_file","","",SQLCA.sqlcode,"","",1) 
#        END IF
#     END IF
#  #No.FUN-7B0018 add 08/02/25 --end
#  END IF
   #No.FUN-830132 080401 mark --end
   
   IF g_success='Y' THEN #還原單據編號
      LET l_n=1
      CALL m_shj.clear()
      LET g_shj.shj02=s_get_doc_no(g_shj.shj02)
      LET g_shj.shj03=s_get_doc_no(g_shj.shj03)
      LET l_sql="SELECT shj10,shj11,shj12 FROM shj_file ",
                                       " WHERE shj01='",g_shj.shj01,"'",
                                       " ORDER BY shj10 "
      PREPARE t703_k_pre FROM l_sql
      DECLARE t703_k_c CURSOR FOR t703_k_pre
      CALL s_showmsg_init()    #NO.FUN-710026
      FOREACH t703_k_c INTO m_shj[l_n].*
         IF SQLCA.sqlcode THEN
#           LET g_success='N'                                                     #NO.FUN-710026
#           CALL cl_err3("sel","shj_file",g_shj.shj01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-710026
            CALL s_errmsg('','',g_shj.shj01,SQLCA.sqlcode,1)                      #NO.FUN-710026     
            LET g_success='N'                                                     #NO.FUN-710026
            EXIT FOREACH
         END IF
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end 
 
         LET m_shj[l_n].shj11=s_get_doc_no(m_shj[l_n].shj11)  
         LET l_n=l_n+1     
      END FOREACH
#NO.FUN-710026----begin 
      IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
      END IF 
#NO.FUN-710026----end
 
      FOR l_n=1 TO m_shj.getlength()
         IF cl_null(m_shj[l_n].shj10) THEN
            CONTINUE FOR
         END IF
         UPDATE shj_file SET shj02=g_shj.shj02,
                             shj03=g_shj.shj03,
                             shj11=m_shj[l_n].shj11
                       WHERE shj01=g_shj.shj01
                         AND shj10=m_shj[l_n].shj10
         IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
#           LET g_success='N'                                                                       #NO.FUN-710026
#           CALL cl_err3("upd shj","shj_file",g_shj.shj01,m_shj[l_n].shj10,SQLCA.sqlcode,"","",1)   #NO.FUN-710026
            LET g_showmsg=g_shj.shj01,"/",m_shj[l_n].shj10                                          #NO.FUN-710026
            CALL s_errmsg('shj01,shj10',g_showmsg,'',SQLCA.sqlcode,1)                               #NO.FUN-710026 
            LET g_success='N'                                                                       #NO.FUN-710026
            EXIT FOR
         END IF
      END FOR
   END IF
    CALL s_showmsg()           #NO.FUN-710026
   IF g_success='Y' THEN
      COMMIT WORK
      CALL t703_show()
      CALL cl_err('','9062',0)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','9050',0)
   END IF   
END FUNCTION
 
FUNCTION t703_issued() #檢查是否已經發料
DEFINE l_str STRING
 
   LET l_str=g_shj.shj02 CLIPPED
   IF l_str.getlength() > g_doc_len+1 THEN
      RETURN TRUE
   END IF
   LET l_str=g_shj.shj03 CLIPPED
   IF l_str.getlength() > g_doc_len+1 THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION
#FUN-B80086
