# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft310.4gl
# Descriptions...: Run Card 分割作業
# Date & Author..: 00/05/25 By Melody
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.MOD-550193 05/06/10 By Carol [確認]後單身資料會消失-> letg_wc2 = '1=1'
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強 
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-650113 06/10/16 By Sarah t310_y()取消sgm03>=g_shp.shp04條件
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710026 07/01/25 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720063 07/03/21 By Judy 錄入時,開窗字段"分割單號"錄入任何值不報錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0038 09/10/23 By Smapmin 分割後生產數量也要update
# Modify.........: No:TQC-A10161 10/01/26 By sherry 查詢報錯-201
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60080 10/07/04 by destiny 增加制程段号和制程序  
# Modify.........: No.FUN-A70125 10/07/26 By lilingyu 平行工藝整批處理
# Modify.........: No.FUN-A70138 10/07/29 By jan 程式調整
# Modify.........: No.FUN-A70143 10/08/03 By jan 平行製程功能調整
# Modify.........: No.FUN-A80027 10/08/03 By jan 更新原RUNCARD單sgm65的算法
# Modify.........: No.TQC-AC0374 10/12/29 By lixh1 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取 
# Modify.........: No.MOD-B10075 11/01/11 By sabrina (1)單頭輸入Run Card時需判斷是否有其他張輸入且未確認
#                                                    (2)單身輸入數量時應判斷是否大於wip數
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO sgm_file給sgm66預設值'Y' 
# Modify.........: No.TQC-B90056 11/09/07 By houlia 審核時取位調整
# Modify.........: No.FUN-BB0085 11/12/06 By xianghui 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_shp           RECORD LIKE shp_file.*,
    g_shp_t         RECORD LIKE shp_file.*,
    g_shp_o         RECORD LIKE shp_file.*,
    g_shp01_t       LIKE shp_file.shp01,
    g_shq           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        shq011      LIKE shq_file.shq011,
        shq02       LIKE shq_file.shq02,
        shq03       LIKE shq_file.shq03,
        shq04       LIKE shq_file.shq04
                    END RECORD,
    g_shq_t         RECORD
        shq011      LIKE shq_file.shq011,
        shq02       LIKE shq_file.shq02,
        shq03       LIKE shq_file.shq03,
        shq04       LIKE shq_file.shq04
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_t1            LIKE oay_file.oayslip,      #No.FUN-550067        #No.FUN-680121 VARCHAR(5) #TQC-840066
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE g_argv1      LIKE oea_file.oea01,                #No.FUN-680121 VARCHAR(16)#TQC-630068
       g_argv2      STRING      #TQC-630068
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1               #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10              #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5               #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680121 SMALLINT
DEFINE g_t            LIKE type_file.chr1          #NO.FUN-A60080 
DEFINE g_success1     LIKE type_file.chr1          #FUN-A70143
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041

MAIN
DEFINE
    p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
  #start TQC-630068
   LET g_argv1=ARG_VAL(1)   #分割單號
   LET g_argv2=ARG_VAL(2)   #執行功能
  #start TQC-630068
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
 
    LET g_forupd_sql = "SELECT * FROM shp_file WHERE shp01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t310_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW t310_w AT p_row,p_col      #顯示畫面
         WITH FORM "asf/42f/asft310"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL g_x.clear()
   #NO.FUN-A60080--begin
   IF g_sma.sma541='N' THEN 
      CALL cl_set_comp_visible("shp012",FALSE)
   END IF 
   #NO.FUN-A60080--end   
   #start TQC-630068
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t310_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t310_a()
             END IF
          OTHERWISE          #TQC-660067 add
             CALL t310_q()   #TQC-660067 add
       END CASE
    END IF
   #end TQC-630068
 
    CALL t310_menu()
 
    CLOSE WINDOW t310_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
 
END MAIN
 
#QBE 查詢資料
FUNCTION t310_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_shq.clear()
 
 #start TQC-630068
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " shp01 = '",g_argv1,"'"
     LET g_wc2= " 1=1"
  ELSE
 #end TQC-630068
   CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031
   INITIALIZE g_shp.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        #shp01,shp02,shptime,shp03,shp04,shp05,shp06,shp07,shptime,shpconf, #TQC-A10161
        shp01,shp02,shp03,shp012,shp04,shp05,shp06,shp07,shptime,shpconf,   #TQC-A10161 #NO.FUN-A60080 
        shpuser,shpgrup,shpmodu,shpdate,shpacti
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE WHEN INFIELD(shp01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shp"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shp01
                     NEXT FIELD shp01
                WHEN INFIELD(shp03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shm"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shp03
                     NEXT FIELD shp03
                #NO.FUN-A60080--begin
                WHEN INFIELD(shp012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shp012"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shp012
                     NEXT FIELD shp012                
                #NO.FUN-A60080--end                     
                WHEN INFIELD(shp07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_gen"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shp07
                     NEXT FIELD shp07
                OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON shq011,shq02,shq03,shq04          # 螢幕上取單身條件
            FROM s_shq[1].shq011,s_shq[1].shq02,s_shq[1].shq03,s_shq[1].shq04
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  END IF   #TQC-630068
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND shpuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shpgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND shpgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shpuser', 'shpgrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  shp01 FROM shp_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY shp01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  shp01 ",
                   "  FROM shp_file, shq_file ",
                   " WHERE shp01 = shq01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY shp01"
    END IF
 
    PREPARE t310_prepare FROM g_sql
    DECLARE t310_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t310_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM shp_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT shp01) FROM shp_file,shq_file WHERE ",
                  "shq01=shp01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t310_precount FROM g_sql
    DECLARE t310_count CURSOR FOR t310_precount
 
END FUNCTION
 
FUNCTION t310_menu()
 
   WHILE TRUE
      CALL t310_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t310_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t310_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t310_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t310_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t310_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t310_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t310_y()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_shp.shpconf,"","","","",g_shp.shpacti)
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shq),'','')
            END IF
##
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_shp.shp01 IS NOT NULL THEN
                 LET g_doc.column1 = "shp01"
                 LET g_doc.value1 = g_shp.shp01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0164-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t310_v()    #CHI-D20010
               CALL t310_v(1)   #CHI-D20010
               IF g_shp.shpconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_shp.shpconf,"","","",g_void,g_shp.shpacti)
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t310_v(2)
               IF g_shp.shpconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_shp.shpconf,"","","",g_void,g_shp.shpacti)
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t310_a()
  DEFINE l_shptime   LIKE type_file.chr8          #No.FUN-680121 VARCHAR(08)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_shq.clear()
    INITIALIZE g_shp.* LIKE shp_file.*             #DEFAULT 設定
    LET g_shp01_t = NULL
    #預設值及將數值類變數清成零
    LET g_shp_o.* = g_shp.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_shp.shp02=g_today
        LET g_shp.shp07=g_user
        LET g_shp.shpconf='N'
        LET l_shptime = TIME
        LET g_shp.shptime=l_shptime
        LET g_shp.shpuser=g_user
        LET g_shp.shporiu = g_user #FUN-980030
        LET g_shp.shporig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shp.shpgrup=g_grup
        LET g_shp.shpdate=g_today
        LET g_shp.shpacti='Y'              #資料有效
        LET g_shp.shpplant = g_plant       #FUN-980008 add
        LET g_shp.shplegal = g_legal       #FUN-980008 add
        #NO.FUN-A60080--begin
        IF g_sma.sma541='N' THEN 
           LET g_shp.shp012=' '
        END IF 
        #NO.FUN-A60080--end
       #start TQC-630068
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_shp.shp03 = g_argv1
        END IF
       #end TQC-630068
        CALL t310_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_shp.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_shp.shp01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK   #No:7829
       #No.FUN-550067 --start--
        CALL s_auto_assign_no("asf",g_shp.shp01,g_shp.shp02,"H","shp_file","shp01","","","")
        RETURNING li_result,g_shp.shp01
      IF (NOT li_result) THEN
 
#       IF g_smy.smyauno='Y' THEN
#          CALL s_smyauno(g_shp.shp01,g_shp.shp02) RETURNING g_i,g_shp.shp01
#          IF g_i THEN #有問題
      #No.FUN-550067 ---end---
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_shp.shp01
#       END IF    #No.FUN-550067
        #NO.FUN-A60080--begin
        IF cl_null(g_shp.shp012) THEN 
           LET g_shp.shp012=' '
        END IF 
        #NO.FUN-A60080--end
        INSERT INTO shp_file VALUES (g_shp.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_shp.shp01,SQLCA.sqlcode,1)   #No.FUN-660128
            CALL cl_err3("ins","shp_file",g_shp.shp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            ROLLBACK WORK   #No:7829
            CONTINUE WHILE
        END IF
        COMMIT WORK  #No:7829
        CALL cl_flow_notify(g_shp.shp01,'I')
 
        SELECT shp01 INTO g_shp.shp01 FROM shp_file
            WHERE shp01 = g_shp.shp01
        LET g_shp01_t = g_shp.shp01        #保留舊值
        LET g_shp_t.* = g_shp.*
 
        CALL g_shq.clear()
        LET g_rec_b=0
        CALL t310_b()                   #輸入單身
 
        EXIT WHILE
 
    END WHILE
END FUNCTION
 
FUNCTION t310_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_shp.shp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shp.* FROM shp_file WHERE shp01=g_shp.shp01
    IF g_shp.shpacti ='N' THEN CALL cl_err(g_shp.shp01,9027,0) RETURN END IF
    IF g_shp.shpconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shp.shpconf='Y' THEN CALL cl_err(g_shp.shp01,9023,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_shp01_t = g_shp.shp01
    LET g_shp_o.* = g_shp.*
    BEGIN WORK
 
    OPEN t310_cl USING g_shp.shp01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_shp.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
    CALL t310_show()
    WHILE TRUE
        LET g_shp01_t = g_shp.shp01
        LET g_shp.shpmodu=g_user
        LET g_shp.shpdate=g_today
        CALL t310_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_shp.*=g_shp_t.*
            CALL t310_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_shp.shp01 != g_shp01_t THEN            # 更改單號
            UPDATE shq_file SET shq01 = g_shp.shp01
                WHERE shq01 = g_shp01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('shq',SQLCA.sqlcode,0) #No.FUN-660128
                CALL cl_err3("upd","shq_file",g_shp01_t,"",SQLCA.sqlcode,"","shq",1)  #No.FUN-660128
                 CONTINUE WHILE   
            END IF
        END IF
        UPDATE shp_file SET shp_file.* = g_shp.*
            WHERE shp01 = g_shp.shp01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shp_file",g_shp01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t310_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shp.shp01,'U')
 
END FUNCTION
 
#處理INPUT
FUNCTION t310_i(p_cmd)
DEFINE li_result   LIKE type_file.num5            #No.FUN-550067        #No.FUN-680121 SMALLINT
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_gen02         LIKE gen_file.gen02
DEFINE l_ecu012     LIKE ecu_file.ecu012      #FUN-A70143
DEFINE l_sgm03      LIKE sgm_file.sgm03       #FUN-A70143
DEFINE l_shp04      LIKE shp_file.shp04       #add by jixf 160803
DEFINE l_shp06      LIKE shp_file.shp06       #add by jixf 160803
 
    DISPLAY BY NAME
        g_shp.shp01,g_shp.shp02,g_shp.shptime,g_shp.shp03,g_shp.shp04,
        g_shp.shp05,g_shp.shp06,g_shp.shp07,g_shp.shpconf,
        g_shp.shpuser,g_shp.shpgrup,g_shp.shpmodu,g_shp.shpdate,g_shp.shpacti
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031 
    INPUT BY NAME g_shp.shporiu,g_shp.shporig,
        g_shp.shp01,g_shp.shp02,g_shp.shp03,g_shp.shp012,g_shp.shp04,  #NO.FUN-A60080 add shp012 
        g_shp.shp05,g_shp.shp06,g_shp.shp07,g_shp.shpconf,g_shp.shptime,
        g_shp.shpuser,g_shp.shpgrup,g_shp.shpmodu,g_shp.shpdate,g_shp.shpacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t310_set_entry(p_cmd)
            CALL t310_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("shp01")
         #No.FUN-550067 ---end---
 
        AFTER FIELD shp01
        #No.FUN-550067 --start--
#         IF g_shp.shp01 != g_shp01_t OR g_shp01_t IS NULL THEN
#        IF NOT cl_null(g_shp.shp01) AND (g_shp.shp01 != g_shp01_t) THEN  #No.FUN-550067   #TQC-720063
         IF NOT cl_null(g_shp.shp01) AND (g_shp.shp01 != g_shp01_t OR g_shp01_t IS NULL) THEN  #TQC-720063
            CALL s_check_no("asf",g_shp.shp01,g_shp01_t,"H","shp_file","shp01","")
            RETURNING li_result,g_shp.shp01
            DISPLAY BY NAME g_shp.shp01
            IF (NOT li_result) THEN
               LET g_shp.shp01=g_shp_o.shp01
               NEXT FIELD shp01
            END IF
#           DISPLAY g_smy.smydesc TO smydesc   #TQC-720063
 
#           IF NOT cl_null(g_shp.shp01) THEN
#              LET g_t1=g_shp.shp01[1,3]
#              CALL s_mfgslip(g_t1,'asf','H')
#       IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#           CALL cl_err(g_t1,g_errno,0) NEXT FIELD shp01
#       END IF
#              IF p_cmd = 'a' AND cl_null(g_shp.shp01[5,10]) AND g_smy.smyauno = 'N'
#           THEN NEXT FIELD shp01
#              END IF
#              IF g_shp.shp01 != g_shp_t.shp01 OR g_shp_t.shp01 IS NULL THEN
#                  IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_shp.shp01[5,10]) THEN
#                     CALL cl_err('','9056',0) NEXT FIELD shp01
#                  END IF
#                  SELECT count(*) INTO g_cnt FROM shp_file
#                      WHERE shp01 = g_shp.shp01
#                  IF g_cnt > 0 THEN   #資料重複
#                      CALL cl_err(g_shp.shp01,-239,0)
#                      LET g_shp.shp01 = g_shp_t.shp01
#                      DISPLAY BY NAME g_shp.shp01
#                      NEXT FIELD shp01
#                  END IF
#              END IF
         #No.FUN-550067 ---end---
            END IF
 
        AFTER FIELD shp03
            IF NOT cl_null(g_shp.shp03) THEN
              #MOD-B10075---add---start---
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM shp_file
                WHERE shp03 = g_shp.shp03 AND shpconf = 'N'
                  AND shp01 != g_shp.shp01
               IF g_cnt > 0 THEN
                  CALL cl_err(g_shp.shp03,'asf-145',1)
                  NEXT FIELD shp03
               END IF
               LET g_cnt = 0
              #MOD-B10075---add---end---
               SELECT COUNT(*) INTO g_cnt FROM shm_file
                  WHERE shm01=g_shp.shp03 AND shm28!='Y'
               IF g_cnt=0 THEN
                  CALL cl_err(g_shp.shp03,'asf-910',0)
                  NEXT FIELD shp03
               ELSE
               	   #NO.FUN-A60080--begin
#                  SELECT sgm03,sgm04,sgm301+sgm302+sgm303+sgm304-
#                         #sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317) #NO.FUN-A60080
#                         (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)        #NO.FUN-A60080
#                    INTO g_shp.shp04,g_shp.shp05,g_shp.shp06
#                    FROM sgm_file
#                   WHERE sgm01=g_shp.shp03 AND sgm54='N'
#                     AND (sgm301+sgm302+sgm303+sgm304-
#                       #sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0  #NO.FUN-A60080
#                       (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0  #NO.FUN-A60080
#                     AND sgm012=g_shp.shp012 #NO.FUN-A60080  
#                     AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
#                                   WHERE sgm01=g_shp.shp03
#                                     AND sgm012=g_shp.shp012  #NO.FUN-A60080
#                                     AND (sgm301+sgm302+sgm303+sgm304-
#                                          #sgm59*(sgm311+sgm312+sgm313+sgm314+  #NO.FUN-A60080
#                                          (sgm311+sgm312+sgm313+sgm314+  #NO.FUN-A60080
#                                                 sgm316+sgm317))>0
#                                     AND sgm54='N')
#                  IF STATUS THEN
#                     SELECT sgm03,sgm04,sgm291-
#                            #sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317) #NO.FUN-A60080
#                            (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317) #NO.FUN-A60080
#                       INTO g_shp.shp04,g_shp.shp05,g_shp.shp06
#                       FROM sgm_file
#                      WHERE sgm01=g_shp.shp03 AND sgm54='Y'
#                        #AND (sgm291-sgm59*(sgm311+sgm312+sgm313+
#                        AND (sgm291-(sgm311+sgm312+sgm313+
#                             sgm314+sgm316+sgm317))>0
#                        AND sgm012=g_shp.shp012 #NO.FUN-A60080       
#                        AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
#                                      WHERE sgm01=g_shp.shp03
#                                        AND sgm012=g_shp.shp012  #NO.FUN-A60080
#                                        #AND (sgm291-sgm59*(sgm311+sgm312+sgm313+
#                                        AND (sgm291-(sgm311+sgm312+sgm313+
#                                             sgm314+sgm316+sgm317))>0
#                                        AND sgm54='Y')
#                     IF STATUS THEN
#                        LET g_shp.shp04=''
#                        LET g_shp.shp05=''
#                        LET g_shp.shp06=''
##                       CALL cl_err(g_shp.shp03,'asf-910',0)   #No.FUN-660128
#                        CALL cl_err3("sel","sgm_file",g_shp.shp03,"","asf-910","","",1)  #No.FUN-660128
#                        NEXT FIELD shp03                         
#                     END IF
                      #NO.FUN-A60080--end
                      #FUN-A70143--begin--add----------
                      IF g_sma.sma541='N' OR cl_null(g_sma.sma541) THEN 
                         CALL t310_shp012(g_shp.shp012)
                         RETURNING g_shp.shp012,g_shp.shp04,g_shp.shp05,g_shp.shp06
                      ELSE
                         CALL s_schdat_max_sgm03(g_shp.shp03)  #取得最終製程序
                         RETURNING l_ecu012,l_sgm03
                         CALL t310_shp012_a(l_ecu012)
                         RETURNING g_shp.shp012,g_shp.shp04,g_shp.shp05,g_shp.shp06
                      END IF 
                      IF g_shp.shp06 = 0 THEN 
                         CALL cl_err('','asf-910',1)
                         NEXT FIELD shp03
                      END IF 
                      #FUN-A70143--end--add--------------
                  #END IF  #NO.FUN-A60080
                  DISPLAY BY NAME g_shp.shp012,g_shp.shp04,g_shp.shp05,g_shp.shp06 #FUN-A70143
               END IF
            END IF      

        #str---add by jixf 160803
        AFTER FIELD shp04
           IF NOT cl_null(g_shp.shp04) THEN
              #MOD-B10075---add---start---
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM shp_file
                WHERE shp03 = g_shp.shp03 AND shpconf = 'N'
                  AND shp01 != g_shp.shp01
               IF g_cnt > 0 THEN
                  CALL cl_err(g_shp.shp03,'asf-145',1)
                  NEXT FIELD shp03
               END IF
               LET g_cnt = 0
              #MOD-B10075---add---end---
               SELECT COUNT(*) INTO g_cnt FROM shm_file
                  WHERE shm01=g_shp.shp03 AND shm28!='Y'
               IF g_cnt=0 THEN
                  CALL cl_err(g_shp.shp03,'asf-910',0)
                  NEXT FIELD shp03
               ELSE
                      IF g_sma.sma541='N' OR cl_null(g_sma.sma541) THEN 
                         CALL t310_shp012_1(g_shp.shp012)
                         RETURNING g_shp.shp012,l_shp04,g_shp.shp05,l_shp06
                      ELSE
                         CALL s_schdat_max_sgm03(g_shp.shp03)  #取得最終製程序
                         RETURNING l_ecu012,l_sgm03
                         CALL t310_shp012_a(l_ecu012)
                         RETURNING g_shp.shp012,l_shp04,g_shp.shp05,l_shp06
                      END IF 
                      IF l_shp06 = 0 THEN 
                         CALL cl_err('','asf-910',1)
                         NEXT FIELD shp03
                      END IF 
                      LET g_shp.shp06=l_shp06
                      DISPLAY BY NAME g_shp.shp012,g_shp.shp04,g_shp.shp05,g_shp.shp06
               END IF

            END IF      
        #end---add by jixf 160803
        AFTER FIELD shp07
            IF NOT cl_null(g_shp.shp07) THEN
               SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01=g_shp.shp07
               IF STATUS THEN
#                 CALL cl_err(g_shp.shp07,'mfg1312',0)   #No.FUN-660128
                  CALL cl_err3("sel","gen_file",g_shp.shp07,"","mfg1312","","",1)  #No.FUN-660128
                  NEXT FIELD shp07
               ELSE DISPLAY l_gen02 TO FORMONLY.gen02
               END IF
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_shp.shpuser = s_get_data_owner("shp_file") #FUN-C10039
           LET g_shp.shpgrup = s_get_data_group("shp_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(shp01)
#                    LET g_t1=g_shp.shp01[1,3]
                     LET g_t1 = s_get_doc_no(g_shp.shp01)     #No.FUN-550067                           
                     #CALL q_smy(FALSE,TRUE,g_t1,'asf','H') RETURNING g_t1  #TQC-670008
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','H') RETURNING g_t1   #TQC-670008
#                     CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                    LET g_shp.shp01[1,3]=g_t1
                     LET g_shp.shp01 = g_t1                 #No.FUN-550067
                     DISPLAY BY NAME g_shp.shp01
                     NEXT FIELD shp01
                WHEN INFIELD(shp03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shm"
                     LET g_qryparam.default1 = g_shp.shp03
                     CALL cl_create_qry() RETURNING g_shp.shp03
#                     CALL FGL_DIALOG_SETBUFFER( g_shp.shp03 )
                     DISPLAY BY NAME g_shp.shp03
                #NO.FUN-A60080--begin
                WHEN INFIELD(shp012)
                     CALL cl_init_qry_var()
                   # LET g_qryparam.form  = "q_sgm_1"      #FUN-B10056 mark
                     LET g_qryparam.form  = "q_sgm_3"      #FUN-B10056
                     LET g_qryparam.arg1 = g_shp.shp03
                     LET g_qryparam.default1 = g_shp.shp012
                     CALL cl_create_qry() RETURNING g_shp.shp012
                     DISPLAY g_shp.shp012 TO shp012
                     NEXT FIELD shp012
                #NO.FUN-A60080--end                
                WHEN INFIELD(shp07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_gen"
                     LET g_qryparam.default1 = g_shp.shp07
                     CALL cl_create_qry() RETURNING g_shp.shp07
#                     CALL FGL_DIALOG_SETBUFFER( g_shp.shp07 )
                     DISPLAY BY NAME g_shp.shp07
                     NEXT FIELD shp07
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(shp01) THEN
       #         LET g_shp.* = g_shp_t.*
       #         DISPLAY BY NAME g_shp.*
       #         NEXT FIELD shp01
       #     END IF
       #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION

#NO.FUN-A60080--begin
FUNCTION t310_shp012(p_ecu012)
DEFINE p_ecu012   LIKE ecu_file.ecu012
DEFINE l_shp04    LIKE shp_file.shp04
DEFINE l_shp05    LIKE shp_file.shp05
DEFINE l_shp06    LIKE shp_file.shp06

    IF cl_null(p_ecu012) THEN LET p_ecu012=' ' END IF
    LET g_t=0
    SELECT sgm03,sgm04,sgm301+sgm302+sgm303+sgm304-
           (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)       
      INTO l_shp04,l_shp05,l_shp06
      FROM sgm_file
     WHERE sgm01=g_shp.shp03 AND sgm54='N'
       AND (sgm301+sgm302+sgm303+sgm304-
         (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0 
       AND sgm012=p_ecu012
       AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
                     WHERE sgm01=g_shp.shp03
                       AND sgm012=p_ecu012  
                       AND (sgm301+sgm302+sgm303+sgm304-
                            (sgm311+sgm312+sgm313+sgm314+ 
                                   sgm316+sgm317))>0
                       AND sgm54='N')
    IF STATUS THEN
       SELECT sgm03,sgm04,sgm291-
              (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317) 
         INTO l_shp04,l_shp05,l_shp06
         FROM sgm_file
        WHERE sgm01=g_shp.shp03 AND sgm54='Y'
          AND (sgm291-(sgm311+sgm312+sgm313+
               sgm314+sgm316+sgm317))>0
          AND sgm012=p_ecu012 
          AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
                        WHERE sgm01=g_shp.shp03
                          AND sgm012=p_ecu012
                          AND (sgm291-(sgm311+sgm312+sgm313+
                               sgm314+sgm316+sgm317))>0
                          AND sgm54='Y')
       IF STATUS THEN
          LET l_shp04=''
          LET l_shp05=''
          LET l_shp06=0
         #CALL cl_err3("sel","sgm_file",g_shp.shp03,"","asf-910","","",1) 
          RETURN p_ecu012,l_shp04,l_shp05,l_shp06
          LET g_t=1 
       END IF
    END IF   
    RETURN p_ecu012,l_shp04,l_shp05,l_shp06
END FUNCTION 
#NO.FUN-A60080--end      

#str---add by jixf 160803
FUNCTION t310_shp012_1(p_ecu012)
DEFINE p_ecu012   LIKE ecu_file.ecu012
DEFINE l_shp04    LIKE shp_file.shp04
DEFINE l_shp05    LIKE shp_file.shp05
DEFINE l_shp06    LIKE shp_file.shp06

    IF cl_null(p_ecu012) THEN LET p_ecu012=' ' END IF
    LET g_t=0
    SELECT sgm03,sgm04,sgm301+sgm302+sgm303+sgm304-
           (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)       
      INTO l_shp04,l_shp05,l_shp06
      FROM sgm_file
     WHERE sgm01=g_shp.shp03 AND sgm54='N'
       AND (sgm301+sgm302+sgm303+sgm304-
         (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0 
       AND sgm012=p_ecu012
       AND sgm03=g_shp.shp04
       
    IF STATUS THEN
          LET l_shp04=''
          LET l_shp05=''
          LET l_shp06=0
         #CALL cl_err3("sel","sgm_file",g_shp.shp03,"","asf-910","","",1) 
          RETURN p_ecu012,l_shp04,l_shp05,l_shp06
          LET g_t=1 
    END IF   
    RETURN p_ecu012,l_shp04,l_shp05,l_shp06
END FUNCTION 
#end---add by jixf 160803
 
FUNCTION t310_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("shp01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t310_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shp01",FALSE)
    END IF
 
END FUNCTION
 
 
#Query 查詢
FUNCTION t310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shp.* TO NULL             #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_shq.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t310_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_shp.* TO NULL
    ELSE
        OPEN t310_count
        FETCH t310_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t310_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t310_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t310_cs INTO g_shp.shp01
        WHEN 'P' FETCH PREVIOUS t310_cs INTO g_shp.shp01
        WHEN 'F' FETCH FIRST    t310_cs INTO g_shp.shp01
        WHEN 'L' FETCH LAST     t310_cs INTO g_shp.shp01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t310_cs INTO g_shp.shp01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)
        INITIALIZE g_shp.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_shp.* FROM shp_file WHERE shp01 = g_shp.shp01
#FUN-4C0035
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shp.shp01,SQLCA.sqlcode,1)   #No.FUN-660128
       CALL cl_err3("sel","shp_file",g_shp.shp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_shp.* TO NULL
    ELSE
       LET g_data_owner = g_shp.shpuser      #FUN-4C0035
       LET g_data_group = g_shp.shpgrup      #FUN-4C0035
       LET g_data_plant = g_shp.shpplant #FUN-980030
       CALL t310_show()
    END IF
##
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t310_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_gen02    LIKE gen_file.gen02
 
    LET g_shp_t.* = g_shp.*                      #保存單頭舊值
    DISPLAY BY NAME g_shp.shporiu,g_shp.shporig,
        g_shp.shp01,g_shp.shp02,g_shp.shp03,g_shp.shp012,g_shp.shp04,  #NO.FUN-A60080 add shp012
        g_shp.shp05,g_shp.shp06,g_shp.shp07,g_shp.shpconf,g_shp.shptime,
        g_shp.shpuser,g_shp.shpgrup,g_shp.shpmodu,g_shp.shpdate,g_shp.shpacti
 
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_shp.shp07
    IF STATUS THEN LET l_gen02='' END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
 
    #圖形顯示
    #CALL cl_set_field_pic(g_shp.shpconf,"","","","",g_shp.shpacti)  #CHI-C80041
    IF g_shp.shpconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
    CALL cl_set_field_pic(g_shp.shpconf,"","","",g_void,g_shp.shpacti)  #CHI-C80041
    CALL t310_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t310_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_shp.shp01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_shp.shpconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shp.shpconf='Y' THEN CALL cl_err(g_shp.shp01,9023,0) RETURN END IF
    BEGIN WORK
 
    OPEN t310_cl USING g_shp.shp01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t310_cl INTO g_shp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t310_show()
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "shp01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_shp.shp01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM shp_file WHERE shp01 = g_shp.shp01
       DELETE FROM shq_file WHERE shq01 = g_shp.shp01
       INITIALIZE g_shp.* TO NULL
       CLEAR FORM
       CALL g_shq.clear()
       CALL g_shq.clear()
       OPEN t310_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t310_cl
          CLOSE t310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t310_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t310_cl
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
    END IF
 
    CLOSE t310_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shp.shp01,'D')
 
END FUNCTION
 
FUNCTION t310_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_shp.shp01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_shp.shpconf='Y' THEN CALL cl_err(g_shp.shp01,9023,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t310_cl USING g_shp.shp01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t310_cl INTO g_shp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t310_show()
 
    IF cl_exp(0,0,g_shp.shpacti) THEN                   #確認一下
        LET g_chr=g_shp.shpacti
        IF g_shp.shpacti='Y' THEN
            LET g_shp.shpacti='N'
        ELSE
            LET g_shp.shpacti='Y'
        END IF
        UPDATE shp_file                    #更改有效碼
            SET shpacti=g_shp.shpacti
            WHERE shp01=g_shp.shp01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shp_file",g_shp.shp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_shp.shpacti=g_chr
        END IF
        DISPLAY BY NAME g_shp.shpacti
    END IF
 
    CLOSE t310_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shp.shp01,'X')
 
END FUNCTION
 
#單身
FUNCTION t310_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n,i           LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_shq03         LIKE shq_file.shq03,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_shp.shp01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_shp.* FROM shp_file WHERE shp01=g_shp.shp01
    IF g_shp.shpacti='N' THEN CALL cl_err(g_shp.shp01,'aom-000',0) RETURN END IF
    IF g_shp.shpconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shp.shpconf='Y' THEN CALL cl_err(g_shp.shp01,9023,0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT shq011,shq02,shq03,shq04 FROM shq_file ",
                       " WHERE shq01= ? AND shq011= ?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_shq.clear() END IF
 
    INPUT ARRAY g_shq WITHOUT DEFAULTS FROM s_shq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t310_cl USING g_shp.shp01
            IF STATUS THEN
               CALL cl_err("OPEN t310_cl:", STATUS, 1)
               CLOSE t310_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t310_cl INTO g_shp.*          # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                   CALL cl_err('lock shp:',SQLCA.sqlcode,0)     # 資料被他人LOCK
                   CLOSE t310_cl ROLLBACK WORK RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_shq_t.* = g_shq[l_ac].*  #BACKUP
               OPEN t310_bcl USING g_shp.shp01,g_shq_t.shq011
               IF STATUS THEN
                  CALL cl_err("OPEN t310_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t310_bcl INTO g_shq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_shq_t.shq011,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shq[l_ac].* TO NULL      #900423
            LET g_shq_t.* = g_shq[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shq011
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO shq_file(shq01,shq011,shq02,shq03,shq04,
                                 shqplant,shqlegal) #FUN-980008 add
                          VALUES(g_shp.shp01,g_shq[l_ac].shq011,g_shq[l_ac].shq02,
                                 g_shq[l_ac].shq03,g_shq[l_ac].shq04,
                                 g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_shq[l_ac].shq02,SQLCA.sqlcode,0)   #No.FUN-660128
                CALL cl_err3("ins","shq_file",g_shp.shp01,g_shq[l_ac].shq011,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        BEFORE FIELD shq011                       #default 序號
            IF g_shq[l_ac].shq011 IS NULL OR
               g_shq[l_ac].shq011 = 0 THEN
                SELECT max(shq011)+1 INTO g_shq[l_ac].shq011
                  FROM shq_file WHERE shq01 = g_shp.shp01
                IF g_shq[l_ac].shq011 IS NULL THEN
                   LET g_shq[l_ac].shq011 = 1
                END IF
            END IF
 
        AFTER FIELD shq011
            IF NOT cl_null(g_shq[l_ac].shq011) THEN
               IF g_shq[l_ac].shq011 != g_shq_t.shq011
                  OR g_shq_t.shq011 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM shq_file
                   WHERE shq01 = g_shp.shp01 AND shq011= g_shq[l_ac].shq011
                  IF l_n > 0 THEN
                     LET g_shq[l_ac].shq011= g_shq_t.shq011
                     CALL cl_err('',-239,0)
                     NEXT FIELD shq011
                  END IF
               END IF
            END IF
 
        AFTER FIELD shq03		
            IF NOT cl_null(g_shq[l_ac].shq03) THEN
               LET l_shq03=0
{
               FOR i=1 TO 300
                   IF cl_null(g_shq[i].shq03) THEN LET g_shq[i].shq03 = 0 END IF
                   LET l_shq03=l_shq03+g_shq[i].shq03
               END FOR
}
               SELECT SUM(shq03) INTO l_shq03 FROM shq_file
                WHERE shq01=g_shp.shp01
                  AND shq011<> g_shq[l_ac].shq011
               IF cl_null(l_shq03) THEN LET l_shq03 = 0 END IF        #MOD-B10075 add
               LET l_shq03=l_shq03+g_shq[l_ac].shq03
               IF l_shq03>g_shp.shp06 THEN
                  CALL cl_err(g_shq[l_ac].shq03,'asf-913',0)
                  NEXT FIELD shq03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_shq_t.shq011 > 0 AND
               g_shq_t.shq011 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM shq_file
                WHERE shq01 = g_shp.shp01 AND
                      shq011= g_shq_t.shq011
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_shq_t.shq011,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("del","shq_file",g_shp.shp01,g_shq_t.shq011,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shq[l_ac].* = g_shq_t.*
               CLOSE t310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shq[l_ac].shq011,-263,1)
               LET g_shq[l_ac].* = g_shq_t.*
            ELSE
               UPDATE shq_file SET shq02=g_shq[l_ac].shq02,
                                   shq03=g_shq[l_ac].shq03,
                                   shq04=g_shq[l_ac].shq04
                WHERE shq01=g_shp.shp01 AND shq011=g_shq_t.shq011
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_shq[l_ac].shq011,SQLCA.sqlcode,0)   #No.FUN-660128
                   CALL cl_err3("upd","shq_file",g_shp.shp01,g_shq_t.shq011,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   LET g_shq[l_ac].* = g_shq_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shq[l_ac].* = g_shq_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t310_bcl
            COMMIT WORK
        
#NO.FUN-6B0031--BEGIN                                                                                           
      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
#NO.FUN-6B0031--END        
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(shq011) AND l_ac > 1 THEN
                LET g_shq[l_ac].* = g_shq[l_ac-1].*
                NEXT FIELD shq011
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
 
    END INPUT
 
     #FUN-5B0113-begin
      LET g_shp.shpmodu = g_user
      LET g_shp.shpdate = g_today
      UPDATE shp_file SET shpmodu = g_shp.shpmodu,shpdate = g_shp.shpdate
       WHERE shp01 = g_shp.shp01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('upd shp',SQLCA.SQLCODE,1)   #No.FUN-660128
         CALL cl_err3("upd","shp_file",g_shp01_t,"",SQLCA.sqlcode,"","upd shp",1)  #No.FUN-660128
      END IF
      DISPLAY BY NAME g_shp.shpmodu,g_shp.shpdate
     #FUN-5B0113-end
 
    CLOSE t310_bcl
 
    COMMIT WORK
 
#   CALL t310_delall() #CHI-C30002 mark
    CALL t310_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t310_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_shp.shp01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM shp_file ",
                  "  WHERE shp01 LIKE '",l_slip,"%' ",
                  "    AND shp01 > '",g_shp.shp01,"'"
      PREPARE t310_pb1 FROM l_sql 
      EXECUTE t310_pb1 INTO l_cnt       
      
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
        #CALL t310_v()    #CHI-D20010
         CALL t310_v(1)   #CHI-D20010
         IF g_shp.shpconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_shp.shpconf,"","","",g_void,g_shp.shpacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  shp_file WHERE shp01 = g_shp.shp01
         INITIALIZE g_shp.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t310_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM shq_file
#    WHERE shq01 = g_shp.shp01
#
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM shp_file WHERE shp01 = g_shp.shp01
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t310_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    CLEAR gen02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON shq011,shq03,shq04,shq02
            FROM s_shq[1].shq011,s_shq[1].shq03,s_shq[1].shq04,s_shq[1].shq02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t310_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t310_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET g_sql =
        "SELECT shq011,shq02,shq03,shq04 ",
        " FROM shq_file",
        " WHERE shq01 ='",g_shp.shp01,"'"        #AND ",  #單頭 No.FUN-8B0123
    #No.FUN-8B0123 mark---Begin
    #   p_wc2 CLIPPED,                           #單身
    #   " ORDER BY shq011"
    #No.FUN-8B0123--------End
    #No.FUN-8B0123---Begin
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY shq011 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t310_pb FROM g_sql
    DECLARE shq_curs CURSOR FOR t310_pb
 
    CALL g_shq.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH shq_curs INTO g_shq[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_shq.deleteElement(g_cnt)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_shq TO s_shq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
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
         #圖形顯示
         CALL cl_set_field_pic(g_shp.shpconf,"","","","",g_shp.shpacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
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
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t310_y()
    DEFINE l_shq   RECORD LIKE shq_file.*
    DEFINE l_sgm   RECORD LIKE sgm_file.*
    DEFINE l_shm   RECORD LIKE shm_file.*
    DEFINE l_no    LIKE aba_file.aba18          #No.FUN-680121 VARCHAR(02)
    DEFINE l_shp03 LIKE shp_file.shp03          #No.FUN-680121 VARCHAR(14)
    DEFINE l_flag  LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_shq03  LIKE shq_file.shq03
    DEFINE l_sgm316 LIKE sgm_file.sgm316
    DEFINE l_sgm59  LIKE sgm_file.sgm59
    DEFINE l_sgm01  LIKE sgm_file.sgm01
    DEFINE l_n      LIKE type_file.num10      #FUN-A60080
    DEFINE l_sgm62  LIKE sgm_file.sgm62       #FUN-A60080
    DEFINE l_sgm63  LIKE sgm_file.sgm63       #FUN-A60080
    DEFINE l_qty,l_shm08  LIKE shm_file.shm08 #FUN-A60080
    DEFINE l_sql1   STRING                    #FUN-A60080
    DEFINE l_sgm012 LIKE sgm_file.sgm012      #FUN-A80027
    DEFINE l_sgm03  LIKE sgm_file.sgm03       #FUN-A80027
    DEFINE l_sgm65  LIKE sgm_file.sgm65       #FUN-A80027
 
#CHI-C30107 ------------ add ------------- begin
    IF g_shp.shpconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shp.shpconf='Y' THEN RETURN END IF
    IF g_shp.shpacti='N' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 ------------ add ------------- end
    SELECT * INTO g_shp.* FROM shp_file WHERE shp01 = g_shp.shp01
    IF g_shp.shpconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shp.shpconf='Y' THEN RETURN END IF
    IF g_shp.shpacti='N' THEN RETURN END IF
 
#bugno:7338 add......................................................
    SELECT COUNT(*) INTO l_cnt FROM shq_file WHERE shq01 = g_shp.shp01
    IF l_cnt = 0 THEN
       CALL cl_err('','mfg-009',0)
       RETURN
    END IF
#bugno:7338 end......................................................
 
    SELECT SUM(shq03) INTO l_shq03 FROM shq_file WHERE shq01 = g_shp.shp01
    IF cl_null(l_shq03) THEN  LET l_shq03 = 0  END IF
    IF l_shq03 > g_shp.shp06 THEN
       CALL cl_err(l_shq03,'asf-913',0)
       RETURN
    END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
    BEGIN WORK
    LET g_success='Y'
 
    OPEN t310_cl USING g_shp.shp01
    IF STATUS THEN
       CALL cl_err("OPEN t310_cl:", STATUS, 1)
       CLOSE t310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t310_cl INTO g_shp.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t310_cl ROLLBACK WORK RETURN
    END IF
 
    LET l_no='00' LET l_sgm316=0
   #FUN-A60080--begin--add------------------------- 
    SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file
     WHERE sgm01=g_shp.shp03
       AND sgm03=g_shp.shp04
       AND sgm012=g_shp.shp012
    SELECT shm08 INTO l_shm08 FROM shm_file WHERE shm01=g_shp.shp03
   #FUN-A60080--end--add---------------------------

    DECLARE shq_cury CURSOR FOR
        SELECT * FROM shq_file WHERE shq01=g_shp.shp01 ORDER BY shq011
    CALL s_showmsg_init()    #NO.FUN-710026
    FOREACH shq_cury INTO l_shq.*
       #FUN-A60080--begin--modify--by jan---
   #   LET l_n = length(g_shp.shp03)-1     #TQC-B90056   mark 
       LET l_n = length(g_shp.shp03)-2     #TQC-B90056   modify
       LET l_shp03=g_shp.shp03[1,l_n] 
       LET l_sql1=" SELECT COUNT(*) FROM shm_file ", 
                  "  WHERE shm01[1,?]='",l_shp03,"'",
                  "    AND shm01!='",g_shp.shp03,"'"
       PREPARE shm_pre FROM l_sql1
       EXECUTE shm_pre USING l_n INTO g_cnt
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          FREE shm_pre 
          RETURN
       END IF
       FREE shm_pre
       #FUN-A60080--end--modify-------------
       LET l_no='00'
       IF g_cnt!=0 THEN
          LET l_no=l_no+g_cnt+1 USING '&&'
       ELSE
          LET l_no=l_no+1 USING '&&'
       END IF
       LET l_sgm01=g_shp.shp03[1,l_n],l_no USING '&&'  #FUN-A60080
       #--------------
       SELECT * INTO l_shm.* FROM shm_file WHERE shm01=g_shp.shp03
       LET l_shm.shm01=l_sgm01
       LET l_shm.shm08=l_shq.shq03/l_sgm62*l_sgm63  #FUN-A60080
       LET l_shm.shm86=g_shp.shp03
       LET l_shm.shmplant = g_plant #FUN-980008 add
       LET l_shm.shmlegal = g_legal #FUN-980008 add
       LET l_shm.shmoriu = g_user      #No.FUN-980030 10/01/04
       LET l_shm.shmorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO shm_file VALUES(l_shm.*)
       IF STATUS THEN
          CALL s_errmsg('shm01',g_shp.shp03,'ins shm',STATUS,1)       #NO.FUN-710026
          LET g_success='N' EXIT FOREACH END IF
       #--------------
       #-----CHI-9A0038---------
       UPDATE shm_file SET shm08=shm08-l_shq.shq03/l_sgm62*l_sgm63    #FUN-A60080
        WHERE shm01=g_shp.shp03
       IF STATUS THEN
          CALL s_errmsg('shm01',g_shp.shp03,'upd shm08',STATUS,1)    
          LET g_success='N' EXIT FOREACH 
       END IF
       #-----END CHI-9A0038-----
      #LET l_flag=1                      #FUN-650113 mark
       DECLARE sgm_cur CURSOR FOR
           SELECT * FROM sgm_file
              WHERE sgm01=g_shp.shp03 
      #         AND sgm03>=g_shp.shp04   #FUN-650113 mark
       FOREACH sgm_cur INTO l_sgm.*
          #start FUN-650113 add
           #IF l_sgm.sgm03=g_shp.shp04 THEN   #NO.FUN-A60080
            IF l_sgm.sgm03=g_shp.shp04 AND l_sgm.sgm012=g_shp.shp012 THEN  #NO.FUN-A60080
               LET l_flag=1 
            END IF   
          #end FUN-650113 add
           LET l_sgm.sgm01=l_sgm01
           LET l_sgm.sgm291=0
           LET l_sgm.sgm292=0
           LET l_sgm.sgm302=0
           IF l_flag=1 THEN
              LET l_sgm.sgm303=l_shq.shq03
              LET l_flag=0
           ELSE
              LET l_sgm.sgm303=0
           END IF
           LET l_sgm.sgm301=0
           LET l_sgm.sgm304=0
           LET l_sgm.sgm311=0
           LET l_sgm.sgm312=0
           LET l_sgm.sgm313=0
           LET l_sgm.sgm314=0
           LET l_sgm.sgm315=0
           LET l_sgm.sgm316=0
           LET l_sgm.sgm317=0
           LET l_sgm.sgmplant = g_plant    #FUN-980008 add
           LET l_sgm.sgmlegal = g_legal    #FUN-980008 add
           LET l_sgm.sgmoriu = g_user      #No.FUN-980030 10/01/04
           LET l_sgm.sgmorig = g_grup      #No.FUN-980030 10/01/04
           #FUN-A70143--begin--add--------
           IF g_sma.sma541 = 'Y' THEN
              LET l_sgm.sgm65 = l_sgm.sgm65 * (l_shm.shm08/l_shm08)  #FUN-A60080
           ELSE
              LET l_sgm.sgm65 = 0
           END IF
           #FUN-A70143--end--add----------
           LET l_sgm.sgm65 = s_digqty(l_sgm.sgm65,l_sgm.sgm58)        #FUN-BB0085
           IF cl_null(l_sgm.sgm66) THEN LET l_sgm.sgm66='Y' END IF    #TQC-B80022
#FUN-A70125 --begin--
           IF cl_null(l_sgm.sgm012) THEN
              LET l_sgm.sgm012 = ' '
           END IF
#FUN-A70125 --end--
           INSERT INTO sgm_file VALUES(l_sgm.*)
           IF STATUS THEN 
              CALL s_errmsg('sgm01',g_shp.shp03,'ins sgm',STATUS,1)         #NO.FUN-710026
              LET g_success='N' EXIT FOREACH 
           END IF
       END FOREACH
       #--------------
       #NO.FUN-A60080--mark sgm59
       #SELECT sgm59 INTO l_sgm59 FROM sgm_file
       #   WHERE sgm01=g_shp.shp03 AND sgm03=g_shp.shp04
       #IF NOT cl_null(l_sgm59) AND l_sgm59!=0 THEN
       #NO.FUN-A60080--end
       LET l_sgm316=l_sgm316+l_shq.shq03   #FUN-A60080
       #END IF     #NO.FUN-A60080
       #FUN-A70143--begin--add------
       IF g_sma.sma541 = 'Y' THEN
          CALL t310_upd_sgm(g_shp.shp012,l_shm.shm08,l_sgm01)      
          IF g_success1='N' THEN RETURN END IF
          CALL t310_upd_sgm65(g_shp.shp012,l_sgm01)
          UPDATE sgm_file SET sgm65=0
           WHERE sgm01=l_sgm01
             AND sgm012=g_shp.shp012
             AND sgm03 < g_shp.shp04
       END IF
       #FUN-A70143--end--add----------
       UPDATE shq_file SET shq02=l_sgm01
           WHERE shq01=g_shp.shp01 AND shq011=l_shq.shq011
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
          LET g_showmsg=g_shp.shp01,"/",l_shq.shq011                     #NO.FUN-710026
          CALL s_errmsg('shq01,shq011',g_showmsg,'upd shq02',STATUS,1)   #NO.FUN-710026 
          LET g_success='N' END IF
    END FOREACH
    #---------------
    UPDATE sgm_file SET sgm316=sgm316+l_sgm316
       WHERE sgm01=g_shp.shp03 AND sgm03=g_shp.shp04
         AND sgm012=g_shp.shp012   #FUN-A60080
    IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
       LET g_showmsg=g_shp.shp03,"/",g_shp.shp04                         #NO.FUN-710026
       CALL s_errmsg('sgm01,sgm03',g_showmsg,'upd sgm316', STATUS,1)     #NO.FUN-710026
       LET g_success='N' END IF
    #FUN-A80027--begin--add---------------------
    IF g_sma.sma541 = 'Y' THEN
       DECLARE t310_sgm_cs1 CURSOR FOR
        SELECT sgm012,sgm03,sum(sgm65) FROM sgm_file,shq_file
         WHERE shq01=g_shp.shp01
           AND sgm01=shq02
         GROUP BY sgm012,sgm03
       FOREACH t310_sgm_cs1 INTO l_sgm012,l_sgm03,l_sgm65
        UPDATE sgm_file SET sgm65=sgm65-l_sgm65
         WHERE sgm01=g_shp.shp03
           AND sgm012=l_sgm012
           AND sgm03=l_sgm03
       END FOREACH
    END IF
    #FUN-A80027--end--add------------------------
    #--------------- 若全數轉出則將後面製程刪除
    IF l_sgm316=g_shp.shp06 THEN
       IF g_sma.sma541 = 'N' THEN   #FUN-A60080
          DELETE FROM sgm_file WHERE sgm01=g_shp.shp03 AND sgm03>g_shp.shp04 
       END IF            #FUN-A60080
       IF STATUS THEN 
          CALL s_errmsg('sgm01',g_shp.shp03,'del sgm',STATUS,1)           #NO.FUN-710026
          LET g_success='N' END IF
    END IF
    #---------------
    CALL s_showmsg()           #NO.FUN-710026  
    IF g_success = 'Y' THEN
       LET g_shp.shpconf='Y'
       DISPLAY BY NAME g_shp.shpconf
       UPDATE shp_file SET shpconf='Y' WHERE shp01=g_shp.shp01
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_shp.shp01,'Y')
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
     LET g_wc2 = ' 1=1'  #MOD-550193
    CALL t310_show()
 
END FUNCTION

#FUN-A70143--begin--add-------------
FUNCTION t310_shp012_a(p_ecu012)           
DEFINE p_ecu012   LIKE ecu_file.ecu012   
DEFINE sr     DYNAMIC ARRAY OF RECORD
              ecu012   LIKE ecu_file.ecu012,
              shp04    LIKE shp_file.shp04,
              shp05    LIKE shp_file.shp05,
              shp06    LIKE shp_file.shp06
              END RECORD,
        tm    RECORD
              ecu012   LIKE ecu_file.ecu012,
              shp04    LIKE shp_file.shp04,
              shp05    LIKE shp_file.shp05,
              shp06    LIKE shp_file.shp06
              END RECORD,
        tm1   RECORD
              ecu012   LIKE ecu_file.ecu012,
              shp04    LIKE shp_file.shp04,
              shp05    LIKE shp_file.shp05,
              shp06    LIKE shp_file.shp06
              END RECORD
DEFINE l_sql  STRING
DEFINE l_sfb05     LIKE sfb_file.sfb05
DEFINE l_sfb06     LIKE sfb_file.sfb06
DEFINE l_i,i,l_t,t LIKE type_file.num5
DEFINE l_sfb01     LIKE sfb_file.sfb01        #TQC-AC0374
DEFINE l_flag      LIKE type_file.num5        #TQC-AC0374

# SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file,shm_file        #TQC-AC0374
  SELECT sfb01,sfb06 INTO l_sfb01,l_sfb06 FROM sfb_file,shm_file        #TQC-AC0374 
   WHERE shm01=g_shp.shp03
     AND shm012=sfb01

 #FUN-B10056 ----------mod start---------- 
 #CALL s_schdat_sel_ima571(l_sfb01) RETURNING l_flag,l_sfb05        #TQC-AC0374
 #LET l_sql=" SELECT ecu012 FROM ecu_file ",
 #          "  WHERE ecu01='",l_sfb05,"'",
 #          "    AND ecu02='",l_sfb06,"'",
 #          "    AND ecu015='",p_ecu012,"'"
  LET l_sql = " SELECT sgm012 FROM sgm_file ",
              "  WHERE sgm01  = '",g_shp.shp03,"'",
              "    AND sgm015 = '",p_ecu012,"'" 
 #FUN-B10056 ----------mod end----------- 
    PREPARE t310_ecu012 FROM l_sql
    DECLARE t310_ecu012_curs CURSOR FOR t310_ecu012
    LET l_i = 1
    FOREACH t310_ecu012_curs INTO sr[l_i].ecu012
      CALL t310_shp012(sr[l_i].ecu012)
      RETURNING sr[l_i].*
      LET l_i = l_i + 1
    END FOREACH
    LET l_t = l_i - 1 
  # IF l_t = 1 AND sr[l_t].shp06 > 0 THEN RETURN sr[l_t].* END IF    #FUN-B10056 mark
    IF l_t = 1 AND sr[1].shp06 > 0 THEN RETURN sr[1].* END IF        #FUN-B10056 
    FOR t=1 TO l_t
        IF t > 1 THEN
           IF sr[t].shp06 < tm.shp06 THEN
              LET tm.* = sr[t].*
           END IF
        ELSE
           LET tm.* = sr[t].*
        END IF
    END FOR
    IF tm.shp06 > 0 THEN 
       RETURN tm.* 
    END IF
    FOR i=1 TO l_t
        CALL t310_shp012_a(sr[i].ecu012) RETURNING tm1.*         
        RETURN tm1.*
    END FOR
    RETURN '','','',0
END FUNCTION

FUNCTION t310_upd_sgm(p_shp012,p_shm08,p_sgm01)     
DEFINE p_shp012    LIKE shp_file.shp012
DEFINE p_shm08     LIKE shm_file.shm08
DEFINE p_sgm01     LIKE sgm_file.sgm01
DEFINE l_ecu015    LIKE ecu_file.ecu015
DEFINE l_ecu012    LIKE ecu_file.ecu012
DEFINE l_sfb05     LIKE sfb_file.sfb05
DEFINE l_sfb06     LIKE sfb_file.sfb06
DEFINE l_shp04     LIKE shp_file.shp04
DEFINE l_shp05     LIKE shp_file.shp05
DEFINE l_shp06     LIKE shp_file.shp06
DEFINE l_sgm62     LIKE sgm_file.sgm62
DEFINE l_sgm63     LIKE sgm_file.sgm63
DEFINE l_sql       STRING
DEFINE l_sfb01     LIKE sfb_file.sfb01     #TQC-AC0374
DEFINE l_flag      LIKE type_file.num5     #TQC-AC0374
DEFINE l_sgm58_01  LIKE sgm_file.sgm58     #FUN-BB0085
DEFINE l_sgm58_02  LIKE sgm_file.sgm58     #FUN-BB0085
DEFINE l_qty1      LIKE type_file.num5     #FUN-BB0085
DEFINE l_qty2      LIKE type_file.num5     #FUN-BB0085

   LET g_success1 = 'Y'
  #FUN-B10056 -----------mod start-------------------- 
  ## SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file,shm_file         #TQC-AC0374
  #SELECT sfb01,sfb05 INTO l_sfb01,l_sfb05 FROM sfb_file,shm_file         #TQC-AC0374 
  # WHERE shm01=g_shp.shp03
  #   AND shm012=sfb01
  #CALL s_schdat_sel_ima571(l_sfb01) RETURNING l_flag,l_sfb05      #TQC-AC0374
  #SELECT ecu015 INTO l_ecu015 FROM ecu_file
  # WHERE ecu01=l_sfb05
  #   AND ecu02=l_sfb06
  #   AND ecu012=p_shp012
   SELECT DISTINCT sgm015 INTO l_ecu015 FROM sgm_file 
    WHERE sgm01 = g_shp.shp03
      AND sgm012 = p_shp012
  #FUN-B10056 ------------mod end---------------------
   IF NOT cl_null(l_ecu015) THEN
     #FUN-B10056 ----------mod start---------------
     #LET l_sql=" SELECT ecu012 FROM ecu_file",
     #          " WHERE ecu01='",l_sfb05,"'",
     #          "   AND ecu02='",l_sfb06,"'",
     #          "   AND ecu015='",l_ecu015,"'",
     #          "   AND ecu012<>'",p_shp012,"'",
     #          " ORDER BY ecu012 "
      LET l_sql = " SELECT sgm012 FROM sgm_file ",
                  "  WHERE sgm01 = '",p_sgm01,"'",
                  "    AND sgm015 = '",l_ecu015,"'",
                  "    AND sgm012 <> '",p_shp012,"'",
                  " ORDER BY sgm012 "
     #FUN-B10056 ---------mod end-----------------
      PREPARE t310_pre1 FROM l_sql
      DECLARE t310_curs1 CURSOR FOR t310_pre1
      FOREACH t310_curs1 INTO l_ecu012
        CALL t310_shp012(l_ecu012)
        RETURNING l_ecu012,l_shp04,l_shp05,l_shp06
        SELECT sgm62,sgm63 INTO l_sgm62,l_sgm63 FROM sgm_file
         WHERE sgm01=g_shp.shp03 AND sgm012=l_ecu012
           AND sgm03=l_shp04
        IF p_shm08*l_sgm62/l_sgm63 > l_shp06 THEN
           LET g_success1 = 'N'
           CALL cl_err('','asf-140',1) 
           RETURN
        END IF
        #FUN-BB0085-add-str----------
        LET l_qty1 = p_shm08*l_sgm62/l_sgm63
        SELECT sgm58 INTO l_sgm58_01 FROM sgm_file WHERE sgm01=p_sgm01 AND sgm012=l_ecu012 AND sgm03=l_shp04
        LET l_qty1 = s_digqty(l_qty1,l_sgm58_01) 
        UPDATE sgm_file SET sgm303=sgm303+l_qty1
         WHERE sgm01=p_sgm01 AND sgm012=l_ecu012
           AND sgm03=l_shp04
        LET l_qty2 = p_shm08*l_sgm62/l_sgm63
        SELECT sgm58 INTO l_sgm58_02 FROM sgm_file WHERE sgm01=g_shp.shp03 AND sgm012=l_ecu012 AND sgm03=l_shp04
        LET l_qty2 = s_digqty(l_qty2,l_sgm58_02)
        UPDATE sgm_file SET sgm316=sgm316+l_qty2
         WHERE sgm01=g_shp.shp03 AND sgm012=l_ecu012
           AND sgm03=l_shp04
        #FUN-BB0085-add-end----------
        #FUN-BB0085-mark-str--
        #UPDATE sgm_file SET sgm303=sgm303+p_shm08*l_sgm62/l_sgm63
        # WHERE sgm01=p_sgm01 AND sgm012=l_ecu012
        #   AND sgm03=l_shp04
        #UPDATE sgm_file SET sgm316=sgm316+p_shm08*l_sgm62/l_sgm63
        # WHERE sgm01=g_shp.shp03 AND sgm012=l_ecu012
        #   AND sgm03=l_shp04
        #FUN-BB0085-mark-end--
      END FOREACH
   ELSE  
      RETURN
   END IF
   CALL t310_upd_sgm(l_ecu015,p_shm08,p_sgm01)        
END FUNCTION

FUNCTION t310_upd_sgm65(p_shp012,p_sgm01)
DEFINE p_shp012    LIKE shp_file.shp012
DEFINE l_sfb05     LIKE sfb_file.sfb05
DEFINE l_sfb06     LIKE sfb_file.sfb06
DEFINE p_sgm01     LIKE sgm_file.sgm01
DEFINE l_sql       STRING
DEFINE i,t         LIKE type_file.num5
DEFINE sr     DYNAMIC ARRAY OF RECORD
              ecu012   LIKE ecu_file.ecu012
              END RECORD
DEFINE l_sfb01     LIKE sfb_file.sfb01     #TQC-AC0374
DEFINE l_flag      LIKE type_file.num5     #TQC-AC0374        

# SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file,shm_file    #TQC-AC0374
  SELECT sfb01,sfb05 INTO l_sfb01,l_sfb05 FROM sfb_file,shm_file    #TQC-AC0374 
    WHERE shm01=g_shp.shp03
      AND shm012=sfb01
 #FUN-B10056 ------------mod start--------
 #CALL s_schdat_sel_ima571(l_sfb01) RETURNING l_flag,l_sfb05      #TQC-AC0374
 #
 #LET l_sql=" SELECT ecu012 FROM ecu_file",
 #          " WHERE ecu01='",l_sfb05,"'",
 #          "   AND ecu02='",l_sfb06,"'",
 #          "   AND ecu015='",p_shp012,"'",
 #          "   AND ecu012<>'",g_shp.shp012,"'",
 #          " ORDER BY ecu012 "
  LET l_sql=" SELECT sgm012 FROM sgm_file",
            "  WHERE sgm01 = '",p_sgm01,"'",
            "    AND sgm015 = '",p_shp012,"'",
            "    AND sgm012 <>'",g_shp.shp012,"'",
            " ORDER BY sgm012 " 
 #FUN-B10056 ---------mod end---------------- 
      PREPARE t310_pre2 FROM l_sql
      DECLARE t310_curs2 CURSOR FOR t310_pre2
      LET i=1
      FOREACH t310_curs2 INTO sr[i].ecu012
        UPDATE sgm_file SET sgm65=0
         WHERE sgm01=p_sgm01 AND sgm012=sr[i].ecu012
        LET i=i+1
      END FOREACH
      FOR t=1 TO i-1
        CALL t310_upd_sgm65(sr[t].ecu012,p_sgm01)
      END FOR
END FUNCTION
#FUN-A70143--end--add------------------
#CHI-C80041---begin
#FUNCTION t310_v()    #CHI-D20010
FUNCTION t310_v(p_type)  #CHI-D20010
DEFINE l_chr     LIKE type_file.chr1
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_shp.shp01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_shp.shpconf ='X' THEN RETURN END IF
   ELSE
      IF g_shp.shpconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t310_cl USING g_shp.shp01
   IF STATUS THEN
      CALL cl_err("OPEN t310_cl:", STATUS, 1)
      CLOSE t310_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t310_cl INTO g_shp.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shp.shp01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t310_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_shp.shpconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_shp.shpconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_shp.shpconf)   THEN  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN      #CHI-D20010
        LET l_chr=g_shp.shpconf
       #IF g_shp.shpconf='N' THEN    #CHI-D20010
        IF p_type = 1 THEN #CHI-D20010
            LET g_shp.shpconf='X' 
        ELSE
            LET g_shp.shpconf='N'
        END IF
        UPDATE shp_file
            SET shpconf=g_shp.shpconf,  
                shpmodu=g_user,
                shpdate=g_today
            WHERE shp01=g_shp.shp01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","shp_file",g_shp.shp01,"",SQLCA.sqlcode,"","",1)  
            LET g_shp.shpconf=l_chr 
        END IF
        DISPLAY BY NAME g_shp.shpconf
   END IF
 
   CLOSE t310_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shp.shp01,'V')
 
END FUNCTION
#CHI-C80041---end
