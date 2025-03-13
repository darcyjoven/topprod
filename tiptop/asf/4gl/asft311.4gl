# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft311.4gl
# Descriptions...: Run Card 合併作業
# Date & Author..: 00/05/26 By Melody
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-640450 06/04/13 By Carol 不同生產料號，應不可併單處理
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-630180 06/06/09 By Pengu 在計算wip量時應考慮需要check in的情況
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710026 07/01/26 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720063 07/93/21 By Judy 錄入時,開窗字段"合并單號"錄入任何值不報錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-8B0007 08/11/15 By Pengu 調整TQC-630180的SQL語法
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-940173 09/05/11 By mike 資料無效后立即顯示圖章  
# Modify.........: No.MOD-940062 09/05/25 By Pengu 如果都沒有輸入資料就按[放棄]時,會將單頭資料一起清除,但未將畫面欄位清空顯示
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0038 09/10/23 By Smapmin 合併後生產數量也要update
# Modify.........: No:MOD-A10037 10/01/13 By Pengu 確認時在判斷合併數量是否超過WIP量
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60092 10/07/15 By lilingyu 平行工藝
# Modify.........: No.TQC-AB0282 10/11/29 By jan shr012給預設值
# Modify.........: No.TQC-AC0374 10/12/29 By lixh1  從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取 
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0085 11/12/07 By xianghui 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20183 12/02/20 By xiaghui 調整小數取位
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30163 12/12/27 By pauline CALL q_sgm(時增加參數
# Modify.........: No:CHI-C80041 13/01/18 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_shr           RECORD LIKE shr_file.*,
    g_shr_t         RECORD LIKE shr_file.*,
    g_shr_o         RECORD LIKE shr_file.*,
    g_shr01_t       LIKE shr_file.shr01,
    g_shs           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        shs011      LIKE shs_file.shs011,
        shs02       LIKE shs_file.shs02,
        shs03       LIKE shs_file.shs03,
        shs04       LIKE shs_file.shs04,
        shs05       LIKE shs_file.shs05
                    END RECORD,
    g_shs_t         RECORD
        shs011      LIKE shs_file.shs011,
        shs02       LIKE shs_file.shs02,
        shs03       LIKE shs_file.shs03,
        shs04       LIKE shs_file.shs04,
        shs05       LIKE shs_file.shs05
                    END RECORD,
    g_sgm57         LIKE sgm_file.sgm57,
    g_sgm58         LIKE sgm_file.sgm58,
    g_sgm54         LIKE sgm_file.sgm54,     #No.TQC-630180 add
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
#   g_t1                VARCHAR(03),
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550067        #No.FUN-680121 VARCHAR(5)
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE g_argv1      LIKE oea_file.oea01,                #No.FUN-680121 VARCHAR(16)#TQC-630068
       g_argv2      STRING      #TQC-630068
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_no_ask       LIKE type_file.num5         #No.FUN-680121 SMALLINT
DEFINE g_void          LIKE type_file.chr1          #CHI-C80041
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP #,                  #FUN-A60092 
#       FIELD ORDER FORM                  #FUN-A60092 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
  #start TQC-630068
   LET g_argv1=ARG_VAL(1)   #合併單號
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
 
    LET g_forupd_sql = "SELECT * FROM shr_file WHERE shr01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t311_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t311_w WITH FORM "asf/42f/asft311"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

#FUN-A60092 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("shr012",TRUE)
   ELSE
      CALL cl_set_comp_visible("shr012",FALSE)   
   END IF 	   
#FUN-A60092 --end--
 
    FOR g_cnt = 1 TO 50
        INITIALIZE g_x[g_cnt] TO NULL
    END FOR
 
    #start TQC-630068
     # 先以g_argv2判斷直接執行哪種功能：
     IF NOT cl_null(g_argv1) THEN
        CASE g_argv2
           WHEN "query"
              LET g_action_choice = "query"
              IF cl_chk_act_auth() THEN
                 CALL t311_q()
              END IF
           WHEN "insert"
              LET g_action_choice = "insert"
              IF cl_chk_act_auth() THEN
                 CALL t311_a()
              END IF
           OTHERWISE          #TQC-660067 add
              CALL t311_q()   #TQC-660067 add
        END CASE
     END IF
    #end TQC-630068
 
    CALL t311_menu()
 
    CLOSE WINDOW t311_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
 
END MAIN
 
#QBE 查詢資料
FUNCTION t311_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_shs.clear()
 
 #start TQC-630068
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " shr01 = '",g_argv1,"'"
     LET g_wc2= " 1=1"
  ELSE
 #end TQC-630068
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031
   INITIALIZE g_shr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
       #shr01,shr02,shrtime,shr03,shr04,shr05,shr06,shr07,shrtime,shrconf, #MOD-940062 mark
        shr01,shr02,shr03,shr012,shr04,shr05,shr06,shr07,shrtime,shrconf,         #MOD-940062 add
                           #FUN-A60092 add shr012
        shruser,shrgrup,shrmodu,shrdate,shracti
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE WHEN INFIELD(shr01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shr"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shr01
                     NEXT FIELD shr01
#FUN-A60092 --begin--
                WHEN INFIELD(shr012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shr012"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shr012
                     NEXT FIELD shr012
#FUN-A60092 --end--
                WHEN INFIELD(shr03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shm"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shr03
                     NEXT FIELD shr03
                 WHEN INFIELD(shr04)
                     #CALL q_sgm(FALSE,FALSE,g_shr.shr03,'','1')     #No.MOD-640138  #FUN-C30163 mark
                      CALL q_sgm(FALSE,FALSE,g_shr.shr03,'','1','','','')     #FUN-C30163 add
                           RETURNING g_shr.shr05,g_shr.shr04
#                      CALL FGL_DIALOG_SETBUFFER( g_shr.shr05 )
#                      CALL FGL_DIALOG_SETBUFFER( g_shr.shr04 )
                      DISPLAY BY NAME g_shr.shr05
                      DISPLAY BY NAME g_shr.shr04
#                     DISPLAY g_qryparam.multiret TO shr04
                      NEXT FIELD shr04
 
                WHEN INFIELD(shr07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_gen"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shr07
                     NEXT FIELD shr07
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
 
    CONSTRUCT g_wc2 ON shs011,she02,shs03,shs04   # 螢幕上取單身條件
         FROM s_shs[1].shs011,s_shs[1].shs02,s_shs[1].shs03,s_shs[1].shs04
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(shs02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_shm"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shs02
                     NEXT FIELD shs02
              OTHERWISE EXIT CASE
            END CASE
 
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
    #        LET g_wc = g_wc clipped," AND shruser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shrgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND shrgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shruser', 'shrgrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  shr01 FROM shr_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY shr01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  shr01 ",
                   "  FROM shr_file, shs_file ",
                   " WHERE shr01 = shs01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY shr01"
    END IF
 
    PREPARE t311_prepare FROM g_sql
    DECLARE t311_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t311_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM shr_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT shr01) FROM shr_file,shs_file WHERE ",
                  "shs01=shr01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t311_precount FROM g_sql
    DECLARE t311_count CURSOR FOR t311_precount
 
END FUNCTION
 
FUNCTION t311_menu()
 
   WHILE TRUE
      CALL t311_bp("G")   
         
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t311_a()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t311_u()
            END IF
                  
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t311_r()
            END IF
                  
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t311_x()
            END IF
            #圖形顯示                                                       #TQC-940173  
            CALL cl_set_field_pic(g_shr.shrconf,"","","","",g_shr.shracti)  #TQC-940173 
      
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t311_q()
            END IF
                  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t311_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t311_y()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_shr.shrconf,"","","","",g_shr.shracti)
            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()    
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shs),'','')
            END IF
##
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_shr.shr01 IS NOT NULL THEN
                 LET g_doc.column1 = "shr01"
                 LET g_doc.value1 = g_shr.shr01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0164-------add--------end----              
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t311_v()   #CHI-D20010
               CALL t311_v(1)  #CHI-D20010
               IF g_shr.shrconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_shr.shrconf,"","","",g_void,g_shr.shracti)
            END IF
         #CHI-C80041---end 
        #CHI-D20010---begin
        WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t311_v(2)
               IF g_shr.shrconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_shr.shrconf,"","","",g_void,g_shr.shracti)
            END IF
        #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION t311_a()
  DEFINE l_shrtime   LIKE type_file.chr8          #No.FUN-680121 VARCHAR(08)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_shs.clear()
    INITIALIZE g_shr.* LIKE shr_file.*             #DEFAULT 設定
    LET g_shr01_t = NULL
    #預設值及將數值類變數清成零
    LET g_shr_o.* = g_shr.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_shr.shr02=g_today
        LET g_shr.shr07=g_user
        LET g_shr.shrconf='N'
        LET l_shrtime = TIME
        LET g_shr.shrtime=l_shrtime
        LET g_shr.shruser=g_user
        LET g_shr.shroriu = g_user #FUN-980030
        LET g_shr.shrorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shr.shrgrup=g_grup
        LET g_shr.shrdate=g_today
        LET g_shr.shracti='Y'              #資料有效
 
        LET g_shr.shrplant = g_plant #FUN-980008 add
        LET g_shr.shrlegal = g_legal #FUN-980008 add
 
#TQC-AB0282--begin--
            IF g_sma.sma541 = 'N' THEN
               LET g_shr.shr012 = ' ' 
            END IF 
#TQC-AB0282 --end--            
        CALL t311_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_shr.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_shr.shr01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK   #No:7829
       #No.FUN-550067 --start--
        CALL s_auto_assign_no("asf",g_shr.shr01,g_shr.shr02,"I","shr_file","shr01","","","")
        RETURNING li_result,g_shr.shr01
      IF (NOT li_result) THEN
 
#       IF g_smy.smyauno='Y' THEN
#   CALL s_smyauno(g_shr.shr01,g_shr.shr02) RETURNING g_i,g_shr.shr01
#          IF g_i THEN #有問題
      #No.FUN-550067---end---
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_shr.shr01
#       END IF     #No.FUN-550067

#FUN-A60092 --begin--
        IF cl_null(g_shr.shr012) THEN 
           LET g_shr.shr012 = ' ' 
        END IF 
#FUN-A60092 --end--

        INSERT INTO shr_file VALUES (g_shr.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#          CALL cl_err(g_shr.shr01,SQLCA.sqlcode,1)   #No.FUN-660128
           CALL cl_err3("ins","shr_file",g_shr.shr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
        COMMIT WORK        #No:7829
        CALL cl_flow_notify(g_shr.shr01,'I')
 
        SELECT shr01 INTO g_shr.shr01 FROM shr_file
            WHERE shr01 = g_shr.shr01
 
        LET g_shr01_t = g_shr.shr01        #保留舊值
        LET g_shr_t.* = g_shr.*
 
        CALL g_shs.clear()
        LET g_rec_b = 0
 
        CALL t311_b()                   #輸入單身
 
        EXIT WHILE
 
    END WHILE
END FUNCTION
 
FUNCTION t311_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_shr.shr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shr.* FROM shr_file WHERE shr01=g_shr.shr01
    IF g_shr.shracti ='N' THEN CALL cl_err(g_shr.shr01,9027,0) RETURN END IF
    IF g_shr.shrconf='Y' THEN CALL cl_err(g_shr.shr01,9023,0) RETURN END IF
    IF g_shr.shrconf='X' THEN RETURN END IF  #CHI-C80041
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_shr01_t = g_shr.shr01
    LET g_shr_o.* = g_shr.*
    BEGIN WORK
 
    OPEN t311_cl USING g_shr.shr01
    IF STATUS THEN
       CALL cl_err("OPEN t311_cl:", STATUS, 1)
       CLOSE t311_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t311_cl INTO g_shr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t311_cl ROLLBACK WORK RETURN
    END IF
    CALL t311_show()
    WHILE TRUE
        LET g_shr01_t = g_shr.shr01
        LET g_shr.shrmodu=g_user
        LET g_shr.shrdate=g_today
        CALL t311_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_shr.*=g_shr_t.*
            CALL t311_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_shr.shr01 != g_shr01_t THEN            # 更改單號
            UPDATE shs_file SET shs01 = g_shr.shr01
                WHERE shs01 = g_shr01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('shs',SQLCA.sqlcode,0)    #No.FUN-660128
                
                CALL cl_err3("upd","shs_file",g_shr01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
                CONTINUE WHILE  
       
            END IF
        END IF
        UPDATE shr_file SET shr_file.* = g_shr.*
            WHERE shr01 = g_shr.shr01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shr_file",g_shr01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t311_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shr.shr01,'I')
 
END FUNCTION
 
#處理INPUT
FUNCTION t311_i(p_cmd)
DEFINE li_result   LIKE type_file.num5            #No.FUN-550067        #No.FUN-680121 SMALLINT
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_gen02         LIKE gen_file.gen02
#FUN-A60092 --begin--
DEFINE l_shm012     LIKE shm_file.shm012
DEFINE l_sfb05      LIKE sfb_file.sfb05
DEFINE l_sfb06      LIKE sfb_file.sfb06
DEFINE l_ecu012     LIKE ecu_file.ecu012
#FUN-A60092 --end--
DEFINE l_flag       LIKE type_file.num5       #TQC-AC0374

    DISPLAY BY NAME
        g_shr.shr01,g_shr.shr02,g_shr.shrtime,g_shr.shr03,g_shr.shr04,
        g_shr.shr05,g_shr.shr06,g_shr.shr07,g_shr.shrconf,
        g_shr.shruser,g_shr.shrgrup,g_shr.shrmodu,g_shr.shrdate,g_shr.shracti
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031
  
    INPUT BY NAME g_shr.shroriu,g_shr.shrorig,
                  g_shr.shr01,g_shr.shr02,g_shr.shr03,
                  g_shr.shr012,     #FUN-A60092 add
#                 g_shr.shr04,      #FUN-A60092
                  g_shr.shr05,g_shr.shr06,g_shr.shr07,g_shr.shrconf,g_shr.shrtime,
                  g_shr.shruser,g_shr.shrgrup,g_shr.shrmodu,g_shr.shrdate,g_shr.shracti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t311_set_entry(p_cmd)
            CALL t311_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#FUN-A60092 --begin--
#           IF g_sma.sma541 = 'N' THEN
#              LET g_shr.shr012 = ' ' 
#           END IF 
#FUN-A60092 --end--            
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("shr01")
         #No.FUN-550067 ---end---
 
 
        AFTER FIELD shr01
        #No.FUN-550067 --start--
#        IF NOT cl_null(g_shr.shr01) AND g_shr.shr01 != g_shr01_t THEN  #TQC-720063
         IF NOT cl_null(g_shr.shr01) AND (g_shr.shr01 != g_shr01_t OR g_shr01_t IS NULL) THEN  #TQC-720063
            CALL s_check_no("asf",g_shr.shr01,g_shr01_t,"I","shr_file","shr01","")
            RETURNING li_result,g_shr.shr01
            DISPLAY BY NAME g_shr.shr01
            IF (NOT li_result) THEN
               LET g_shr.shr01=g_shr_o.shr01
               NEXT FIELD shr01
            END IF
#           DISPLAY g_smy.smydesc TO smydesc   #TQC-720063
 
#           IF NOT cl_null(g_shr.shr01) THEN
#              LET g_t1=g_shr.shr01[1,3]
#              CALL s_mfgslip(g_t1,'asf','I')
#       IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#           CALL cl_err(g_t1,g_errno,0) NEXT FIELD shr01
#       END IF
#              IF p_cmd = 'a' AND cl_null(g_shr.shr01[5,10]) AND g_smy.smyauno = 'N'
#           THEN NEXT FIELD shr01
#              END IF
#              IF g_shr.shr01 != g_shr_t.shr01 OR g_shr_t.shr01 IS NULL THEN
#                  IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_shr.shr01[5,10]) THEN
#                     CALL cl_err('','9056',0) NEXT FIELD shr01
#                  END IF
#                  SELECT count(*) INTO g_cnt FROM shr_file
#                      WHERE shr01 = g_shr.shr01
#                  IF g_cnt > 0 THEN   #資料重複
#                      CALL cl_err(g_shr.shr01,-239,0)
#                      LET g_shr.shr01 = g_shr_t.shr01
#                      DISPLAY BY NAME g_shr.shr01
#                      NEXT FIELD shr01
#                  END IF
#              END IF
         #No.FUN-550067 ---end---
            END IF
 
 #FUN-A60092 --begin--
        BEFORE FIELD shr012 
            IF cl_null(g_shr.shr03) THEN 
               NEXT FIELD shr03
            END IF 
        
        AFTER FIELD shr012
         IF g_sma.sma541 = 'Y' THEN 
           IF g_shr.shr012  IS NOT NULL THEN 
             SELECT shm012 INTO l_shm012 FROM shm_file
              WHERE shm01 = g_shr.shr03
                AND shm28  != 'Y'
          #  SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file         #TQC-AC0374
             SELECT sfb06 INTO l_sfb06 FROM sfb_file                         #TQC-AC0374
              WHERE sfb01 = l_shm012
            #FUN-B10056 --------mod start------------
            #CALL s_schdat_sel_ima571(l_shm012) RETURNING l_flag,l_sfb05     #TQC-AC0374
            #SELECT COUNT(*),ecu012 INTO l_cnt,l_ecu012 FROM ecu_file
            # WHERE ecu01 = l_sfb05
            #   AND ecu02 = l_sfb06
            #   AND ecu012= g_shr.shr012      
            # GROUP BY ecu012
            # IF l_cnt = 0 THEN 
             IF NOT s_runcard_sgm012(g_shr.shr03,g_shr.shr012) THEN 
            #FUN-B10056 -------mod end--------------
                 CALL cl_err('','abm-214',0)
                 NEXT FIELD CURRENT 
              ELSE
                  SELECT sgm03,sgm04,sgm301+sgm302+sgm303+sgm304-
                        (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)   
                        #sgm57,sgm58
                    INTO g_shr.shr04,g_shr.shr05,g_shr.shr06 #,g_sgm57,g_sgm58
                    FROM sgm_file
                   WHERE sgm01=g_shr.shr03
                     AND sgm012 = g_shr.shr012 
                     AND (sgm301+sgm302+sgm303+sgm304-
                         (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0  
                     AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
                                 WHERE sgm01=g_shr.shr03
                                   AND sgm012 = g_shr.shr012  
                                   AND (sgm301+sgm302+sgm303+sgm304-
                                       (sgm311+sgm312+sgm313+sgm314+  
                                        sgm316+sgm317))>0)
                  IF STATUS THEN
                     LET g_shr.shr04=''
                     LET g_shr.shr05=''
                     LET g_shr.shr06=''
                     CALL cl_err('',STATUS,0) 
                     NEXT FIELD shr012
                  END IF
                  DISPLAY BY NAME g_shr.shr04,g_shr.shr05,g_shr.shr06          	    
              END IF     
            END IF              
          END IF     
 #FUN-A60092 --end--        
 
        AFTER FIELD shr03
            IF NOT cl_null(g_shr.shr03) THEN
               SELECT COUNT(*) INTO g_cnt FROM shm_file
                WHERE shm01=g_shr.shr03 AND shm28!='Y'
               IF g_cnt=0 THEN
                  CALL cl_err(g_shr.shr03,'asf-910',0)
                  NEXT FIELD shr03
               ELSE
                 IF g_sma.sma541 = 'N' THEN  #FUN-A60092 add               	
                  SELECT sgm03,sgm04,sgm301+sgm302+sgm303+sgm304-
#                        sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317),   #FUN-A60092
                               (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)    #FUN-A60092
                        #sgm57,sgm58   #FUN-A60092
                    INTO g_shr.shr04,g_shr.shr05,g_shr.shr06 #,g_sgm57,g_sgm58  #FUN-A60092
                    FROM sgm_file
                   WHERE sgm01=g_shr.shr03
                     AND sgm012 = g_shr.shr012   #FUN-A60092 add
                     AND (sgm301+sgm302+sgm303+sgm304-
#                          sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0  #FUN-A60092 
                                 (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317))>0  #FUN-A60092 
                     AND sgm03=(SELECT MAX(sgm03) FROM sgm_file
                                 WHERE sgm01=g_shr.shr03
                                   AND sgm012 = g_shr.shr012   #FUN-A60092
                                   AND (sgm301+sgm302+sgm303+sgm304-
#                                       sgm59*(sgm311+sgm312+sgm313+sgm314+   #FUN-A60092
                                              (sgm311+sgm312+sgm313+sgm314+   #FUN-A60092
                                               sgm316+sgm317))>0)
                  IF STATUS THEN
                     LET g_shr.shr04=''
                     LET g_shr.shr05=''
                     LET g_shr.shr06=''
#                    CALL cl_err(g_shr.shr03,'asf-910',0)   #No.FUN-660128
                     CALL cl_err3("sel","sgm_file",g_shr.shr03,"","asf-910","","",1)  #No.FUN-660128
                     NEXT FIELD shr03
                  END IF
                  DISPLAY BY NAME g_shr.shr04,g_shr.shr05,g_shr.shr06
                 END IF  #FUN-A60092 add 
               END IF
            END IF
 
        AFTER FIELD shr07
            IF NOT cl_null(g_shr.shr07) THEN
               SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_shr.shr07
               IF STATUS THEN
#                 CALL cl_err(g_shr.shr07,'mfg1312',0)   #No.FUN-660128
                  CALL cl_err3("sel","gen_file",g_shr.shr07,"","mfg1312","","",1)  #No.FUN-660128
                  NEXT FIELD shr07
               ELSE DISPLAY l_gen02 TO FORMONLY.gen02
               END IF
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_shr.shruser = s_get_data_owner("shr_file") #FUN-C10039
           LET g_shr.shrgrup = s_get_data_group("shr_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(shr01)
#                    LET g_t1=g_shr.shr01[1,3]
                     LET g_t1 = s_get_doc_no(g_shr.shr01)     #No.FUN-550067
                    #CALL q_smy(FALSE,TRUE,g_t1,'asf','I') RETURNING g_t1   #TQC-670008
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','I') RETURNING g_t1   #TQC-670008
#                     CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                    LET g_shr.shr01[1,3]=g_t1
                     LET g_shr.shr01=g_t1    #No.FUN-550067
                     DISPLAY BY NAME g_shr.shr01
                     NEXT FIELD shr01

#FUN-A60092 --begin--
                WHEN INFIELD(shr012)
                 #FUN-B10056 -----mark start--------
                 #SELECT shm012 INTO l_shm012 FROM shm_file
                 # WHERE shm01 = g_shr.shr03
                 #   AND shm28  != 'Y'
                 #SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file
                 # WHERE sfb01 = l_shm012             
                 #FUN-B10056 -----mark end---------- 
                     CALL cl_init_qry_var()
                   # LET g_qryparam.form     = "q_shr012_1"    #FUN-B10056 mark
                     LET g_qryparam.form     = "q_sgm_3"       #FUN-B10056
                     LET g_qryparam.default1 = g_shr.shr012
                   # LET g_qryparam.arg1     = l_sfb05         #FUN-B10056 mark
                   # LET g_qryparam.arg2     = l_sfb06         #FUN-B10056 mark
                     LET g_qryparam.arg1     = g_shr.shr03     #FUN-B10056              
                     CALL cl_create_qry() RETURNING g_shr.shr012
                     DISPLAY BY NAME g_shr.shr012
                     NEXT FIELD shr012
#FUN-A60092 --end--
                     
                WHEN INFIELD(shr03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shm"
                     LET g_qryparam.default1 = g_shr.shr03
                     CALL cl_create_qry() RETURNING g_shr.shr03
#                     CALL FGL_DIALOG_SETBUFFER( g_shr.shr03 )
                     DISPLAY BY NAME g_shr.shr03
                     NEXT FIELD shr03
                 WHEN INFIELD(shr04)
                     #CALL q_sgm(FALSE,FALSE,g_shr.shr03,'','1')       #No.MOD-640138   #FUN-C30163 mark
                      CALL q_sgm(FALSE,FALSE,g_shr.shr03,'','1','','','')        #FUN-C30163 ad
                           RETURNING g_shr.shr05,g_shr.shr04
#                      CALL FGL_DIALOG_SETBUFFER( g_shr.shr05 )
#                      CALL FGL_DIALOG_SETBUFFER( g_shr.shr04 )
                      DISPLAY BY NAME g_shr.shr05
                      DISPLAY BY NAME g_shr.shr04
                      NEXT FIELD shr04
 
                WHEN INFIELD(shr07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_gen"
                     LET g_qryparam.default1 = g_shr.shr07
                     CALL cl_create_qry() RETURNING g_shr.shr07
#                     CALL FGL_DIALOG_SETBUFFER( g_shr.shr07 )
                     DISPLAY BY NAME g_shr.shr07
                     NEXT FIELD shr07
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(shr01) THEN
       #         LET g_shr.* = g_shr_t.*
       #         DISPLAY BY NAME g_shr.*
       #         NEXT FIELD shr01
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
 
FUNCTION t311_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("shr01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t311_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shr01,shr04",FALSE)  #FUN-A60092 add shr04
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION t311_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shr.* TO NULL              #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_shs.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t311_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t311_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_shr.* TO NULL
    ELSE
        OPEN t311_count
        FETCH t311_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t311_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t311_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t311_cs INTO g_shr.shr01
        WHEN 'P' FETCH PREVIOUS t311_cs INTO g_shr.shr01
        WHEN 'F' FETCH FIRST    t311_cs INTO g_shr.shr01
        WHEN 'L' FETCH LAST     t311_cs INTO g_shr.shr01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t311_cs INTO g_shr.shr01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)
        INITIALIZE g_shr.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_shr.* FROM shr_file WHERE shr01 = g_shr.shr01
#FUN-4C0035
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)   #No.FUN-660128
       CALL cl_err3("sel","shr_file",g_shr.shr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_shr.* TO NULL
    ELSE
       LET g_data_owner = g_shr.shruser      #FUN-4C0035
       LET g_data_group = g_shr.shrgrup      #FUN-4C0035
       LET g_data_plant = g_shr.shrplant #FUN-980030
       CALL t311_show()
    END IF
##
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t311_show()
    DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_gen02    LIKE gen_file.gen02
 
    LET g_shr_t.* = g_shr.*                      #保存單頭舊值
    DISPLAY BY NAME g_shr.shroriu,g_shr.shrorig,
        g_shr.shr01,g_shr.shr02,g_shr.shr03,g_shr.shr04,
        g_shr.shr05,g_shr.shr06,g_shr.shr07,g_shr.shrconf,g_shr.shrtime,
        g_shr.shruser,g_shr.shrgrup,g_shr.shrmodu,g_shr.shrdate,g_shr.shracti
       ,g_shr.shr012       #FUN-A60092 add
        
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_shr.shr07
    IF STATUS THEN LET l_gen02='' END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
 
    #圖形顯示
    CALL cl_set_field_pic(g_shr.shrconf,"","","","",g_shr.shracti)
 
    CALL t311_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t311_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_shr.shr01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_shr.shrconf='Y' THEN CALL cl_err(g_shr.shr01,9023,0) RETURN END IF
    IF g_shr.shrconf='X' THEN RETURN END IF  #CHI-C80041
 
    BEGIN WORK
 
    OPEN t311_cl USING g_shr.shr01
    IF STATUS THEN
       CALL cl_err("OPEN t311_cl:", STATUS, 1)
       CLOSE t311_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t311_cl INTO g_shr.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t311_cl ROLLBACK WORK RETURN
    END IF
    CALL t311_show()
    IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "shr01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_shr.shr01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM shr_file WHERE shr01 = g_shr.shr01
       DELETE FROM shs_file WHERE shs01 = g_shr.shr01
       INITIALIZE g_shr.* TO NULL
       CLEAR FORM
       CALL g_shs.clear()
       OPEN t311_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t311_cl
          CLOSE t311_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t311_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t311_cl
          CLOSE t311_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t311_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t311_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t311_fetch('/')
       END IF
 
    END IF
 
    CLOSE t311_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shr.shr01,'I')
 
END FUNCTION
 
FUNCTION t311_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_shr.shr01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_shr.shrconf='Y' THEN CALL cl_err(g_shr.shr01,9023,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t311_cl USING g_shr.shr01
    IF STATUS THEN
       CALL cl_err("OPEN t311_cl:", STATUS, 1)
       CLOSE t311_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t311_cl INTO g_shr.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t311_cl ROLLBACK WORK RETURN
    END IF
    CALL t311_show()
    IF cl_exp(0,0,g_shr.shracti) THEN                   #確認一下
        LET g_chr=g_shr.shracti
        IF g_shr.shracti='Y' THEN
            LET g_shr.shracti='N'
        ELSE
            LET g_shr.shracti='Y'
        END IF
        UPDATE shr_file                    #更改有效碼
            SET shracti=g_shr.shracti
            WHERE shr01=g_shr.shr01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shr_file",g_shr01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_shr.shracti=g_chr
        END IF
        DISPLAY BY NAME g_shr.shracti
    END IF
 
    CLOSE t311_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shr.shr01,'V')
 
END FUNCTION
 
#單身
FUNCTION t311_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_cnt           LIKE type_file.num5,                #MOD-640450 add        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_shs04         LIKE shs_file.shs04,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_shr.shr01 IS NULL THEN
        RETURN
    END IF
 
    SELECT * INTO g_shr.* FROM shr_file WHERE shr01=g_shr.shr01
    IF g_shr.shracti='N' THEN CALL cl_err(g_shr.shr01,'aom-000',0) RETURN END IF
    IF g_shr.shrconf='Y' THEN CALL cl_err(g_shr.shr01,9023,0) RETURN END IF
    IF g_shr.shrconf='X' THEN RETURN END IF  #CHI-C80041
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = "SELECT shs011,shs02,shs03,shs04,shs05 FROM shs_file",
                       " WHERE shs01= ? AND shs011 = ?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t311_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_shs.clear() END IF
 
    INPUT ARRAY g_shs WITHOUT DEFAULTS FROM s_shs.*
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
 
            OPEN t311_cl USING g_shr.shr01
            IF STATUS THEN
               CALL cl_err("OPEN t311_cl:", STATUS, 1)
               CLOSE t311_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t311_cl INTO g_shr.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock shr:',SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t311_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_shs_t.* = g_shs[l_ac].*  #BACKUP
               OPEN t311_bcl USING g_shr.shr01,g_shs_t.shs011
               IF STATUS THEN
                  CALL cl_err("OPEN t311_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t311_bcl INTO g_shs[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_shs_t.shs011,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
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
            INSERT INTO shs_file(shs01,shs011,shs02,shs03,shs04,shs05,
                                 shsplant,shslegal) #FUN-980008 add
                          VALUES(g_shr.shr01,g_shs[l_ac].shs011,g_shs[l_ac].shs02,
                                 g_shs[l_ac].shs03,g_shs[l_ac].shs04,
                                 g_shs[l_ac].shs05,
                                 g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_shs[l_ac].shs02,SQLCA.sqlcode,0)   #No.FUN-660128
               CALL cl_err3("ins","shs_file",g_shr.shr01,g_shs[l_ac].shs02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shs[l_ac].* TO NULL      #900423
            LET g_shs_t.* = g_shs[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shs011
 
        BEFORE FIELD shs011                       #default 序號
            IF g_shs[l_ac].shs011 IS NULL OR
               g_shs[l_ac].shs011 = 0 THEN
                SELECT max(shs011)+1 INTO g_shs[l_ac].shs011
                   FROM shs_file WHERE shs01 = g_shr.shr01
                IF g_shs[l_ac].shs011 IS NULL THEN
                    LET g_shs[l_ac].shs011 = 1
                END IF
            END IF
 
       AFTER FIELD shs011
            IF NOT cl_null(g_shs[l_ac].shs011) THEN
               IF g_shs[l_ac].shs011 != g_shs_t.shs011 OR
                  g_shs_t.shs011 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM shs_file
                       WHERE shs01 = g_shr.shr01 AND shs011= g_shs[l_ac].shs011
                   IF l_n > 0 THEN
                       LET g_shs[l_ac].shs011= g_shs_t.shs011
                       CALL cl_err('',-239,0) NEXT FIELD shs011
                   END IF
               END IF
            END IF
 
       AFTER FIELD shs02 		
            IF NOT cl_null(g_shs[l_ac].shs02) THEN
               IF g_shs[l_ac].shs02=g_shr.shr03 THEN
                  CALL cl_err(g_shs[l_ac].shs02,'asf-914',0)
                  NEXT FIELD shs02
               END IF
#MOD-640450-add
              #不同生產料號的run card 不可合併
               LET l_cnt = 0 
               SELECT COUNT(*) INTO l_cnt FROM shm_file,sfb_file 
                WHERE shm01 = g_shs[l_ac].shs02
                  AND shm012= sfb01
                  AND sfb05 IN 
                      ( SELECT sfb05 FROM shm_file,sfb_file
                         WHERE shm01 = g_shr.shr03 
                           AND shm012 = sfb01 )
               IF l_cnt = 0 THEN
                  CALL cl_err(g_shs[l_ac].shs02,'asf-862',1)
                  NEXT FIELD shs02
               END IF
#MOD-640450-end
           #-------------No.TQC-630180 modify 增加判斷是否做check in
               SELECT sgm54 INTO g_sgm54 FROM sgm_file
                WHERE sgm01=g_shs[l_ac].shs02 AND sgm04=g_shr.shr05
                  AND sgm03 = g_shr.shr04     #No.MOD-8B0007 add
                 #AND sgm57=g_sgm57 AND sgm58=g_sgm58   #FUN-A60092
                  AND sgm012 = g_shr.shr012             #FUN-A60092 
                  
               IF g_sgm54='Y' THEN   #check in 否
                  SELECT sgm291+sgm304-
#                         sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)  #FUN-A60092 
                                (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)  #FUN-A60092 
                    INTO g_shs[l_ac].shs03
                    FROM sgm_file
                   WHERE sgm01=g_shs[l_ac].shs02 AND sgm04=g_shr.shr05
                     AND sgm03 = g_shr.shr04     #No.MOD-8B0007 add
                    #AND sgm57=g_sgm57 AND sgm58=g_sgm58  #FUN-A60092
                     AND sgm012 = g_shr.shr012            #FUN-A60092 
               ELSE
                  SELECT sgm301+sgm302+sgm303+sgm304-
#                         sgm59*(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)  #FUN-A60092
                                (sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)  #FUN-A60092
                    INTO g_shs[l_ac].shs03
                    FROM sgm_file
                   WHERE sgm01=g_shs[l_ac].shs02 AND sgm04=g_shr.shr05
                     AND sgm03 = g_shr.shr04     #No.MOD-8B0007 add
                    #AND sgm57=g_sgm57 AND sgm58=g_sgm58   #FUN-A60092
                     AND sgm012 = g_shr.shr012  #FUN-A60092 
               END IF
           #-------------No.TQC-630180 end
               IF STATUS THEN
      #           CALL cl_err(g_shs[l_ac].shs02,'asf-910',0)   #No.FUN-660128
                  CALL cl_err3("sel","sgm_file",g_shs[l_ac].shs02,"","asf-910","","",1)   #No.FUN-660128
                  NEXT FIELD shs02
               END IF
 
              #FUN-640190...............begin
              #如果相同產品,不同工單,不應可以合併(因為入庫時的最小套數檢查是以工單為主)
               LET l_cnt = 0 
               SELECT COUNT(*) INTO l_cnt FROM shm_file,sfb_file 
                WHERE shm01 = g_shs[l_ac].shs02
                  AND shm012= sfb01
                  AND sfb01 IN 
                      (SELECT sfb01 FROM shm_file,sfb_file
                         WHERE shm01 = g_shr.shr03 
                           AND shm012 = sfb01)
               IF l_cnt = 0 THEN
                  CALL cl_err(g_shs[l_ac].shs02,'asf-863',1)
                  NEXT FIELD shs02
               END IF
              #FUN-640190...............end
            END IF
 
        AFTER FIELD shs04		
            IF NOT cl_null(g_shs[l_ac].shs04) THEN
               IF g_shs[l_ac].shs04>g_shs[l_ac].shs03 THEN
                  CALL cl_err(g_shs[l_ac].shs04,'asf-913',0)
                  NEXT FIELD shs04
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_shs_t.shs011 > 0 AND
               g_shs_t.shs011 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM shs_file
                WHERE shs01 = g_shr.shr01
                  AND shs011= g_shs_t.shs011
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_shs_t.shs011,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("del","shs_file",g_shr.shr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
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
               LET g_shs[l_ac].* = g_shs_t.*
               CLOSE t311_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shs[l_ac].shs011,-263,1)
               LET g_shs[l_ac].* = g_shs_t.*
            ELSE
               UPDATE shs_file SET shs02=g_shs[l_ac].shs02,
                                   shs03=g_shs[l_ac].shs03,
                                   shs04=g_shs[l_ac].shs04,
                                   shs05=g_shs[l_ac].shs05
                WHERE shs01=g_shr.shr01 AND shs011=g_shs_t.shs011
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_shs[l_ac].shs011,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("upd","shs_file",g_shr.shr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  LET g_shs[l_ac].* = g_shs_t.*
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
               IF p_cmd='u' THEN
                  LET g_shs[l_ac].* = g_shs_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shs.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t311_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add 
            CLOSE t311_bcl
            COMMIT WORK
#NO.FUN-6B0031--BEGIN                                                                                           
      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
#NO.FUN-6B0031--END        
 
#       ON ACTION CONTROLN
#           CALL t311_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(shs011) AND l_ac > 1 THEN
                LET g_shs[l_ac].* = g_shs[l_ac-1].*
                NEXT FIELD shs011
            END IF
 
 
        ON ACTION controlp
           CASE WHEN INFIELD(shs02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_shm"
                   LET g_qryparam.default1 = g_shs[l_ac].shs02
                   CALL cl_create_qry() RETURNING g_shs[l_ac].shs02
#                   CALL FGL_DIALOG_SETBUFFER( g_shs[l_ac].shs02 )
                    DISPLAY BY NAME g_shs[l_ac].shs02    #No.MOD-490371
               NEXT FIELD shs02
              OTHERWISE EXIT CASE
            END CASE
 
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
     LET g_shr.shrmodu = g_user
     LET g_shr.shrdate = g_today
     UPDATE shr_file SET shrmodu = g_shr.shrmodu,shrdate = g_shr.shrdate
      WHERE shr01 = g_shr.shr01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd shr',SQLCA.SQLCODE,1)   #No.FUN-660128
        CALL cl_err3("upd","shr_file",g_shr01_t,"",SQLCA.sqlcode,"","upd shr",1)  #No.FUN-660128
     END IF
     DISPLAY BY NAME g_shr.shrmodu,g_shr.shrdate
    #FUN-5B0113-end
 
    CLOSE t311_bcl
    COMMIT WORK
 
#   CALL t311_delall() #CHI-C30002 mark
    CALL t311_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t311_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_shr.shr01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM shr_file ",
                  "  WHERE shr01 LIKE '",l_slip,"%' ",
                  "    AND shr01 > '",g_shr.shr01,"'"
      PREPARE t311_pb1 FROM l_sql 
      EXECUTE t311_pb1 INTO l_cnt      
      
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
        #CALL t311_v()   #CHI-D20010
         CALL t311_v(1)  #CHI-D20010
         IF g_shr.shrconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_shr.shrconf,"","","",g_void,g_shr.shracti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM shr_file WHERE shr01 = g_shr.shr01
         INITIALIZE g_shr.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t311_delall()
#   SELECT COUNT(*) INTO g_cnt FROM shs_file
#       WHERE shs01 = g_shr.shr01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM shr_file WHERE shr01 = g_shr.shr01
#      CLEAR FORM    #No.MOD-940062  add
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

#FUN-A60092 --begin-- 
#FUNCTION t311_b_askkey()
#DEFINE
#    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
# 
#    CLEAR gen02                           #清除FORMONLY欄位
#    CALL g_shs.clear()
#    CONSTRUCT l_wc2 ON shs011,shs02,shs03,shs04,shs05
#            FROM s_shs[1].shs011,s_shs[1].shs02,s_shs[1].shs03,s_shs[1].shs04,
#                 s_shs[1].shs05
#              #No.FUN-580031 --start--     HCN
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#              #No.FUN-580031 --end--       HCN
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#		#No.FUN-580031 --start--     HCN
#                 ON ACTION qbe_select
#         	   CALL cl_qbe_select()
#                 ON ACTION qbe_save
#		   CALL cl_qbe_save()
#		#No.FUN-580031 --end--       HCN
#    END CONSTRUCT
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        RETURN
#    END IF
#    CALL t311_b_fill(l_wc2)
#END FUNCTION
#FUN-A60092 --end--
 
FUNCTION t311_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET g_sql =
        "SELECT shs011,shs02,shs03,shs04,shs05 ",
        " FROM shs_file",
        " WHERE shs01 ='",g_shr.shr01,"'"  # AND ",  #單頭  #No.FUN-8B0123 mark
    #No.FUN-8B0123 mark---Begin
    #   p_wc2 CLIPPED,                     #單身
    #   " ORDER BY shs011"
    #No.FUN-8B0123--------End
    #No.FUN-8B0123---Begin
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY shs011" 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t311_pb FROM g_sql
    DECLARE shs_curs CURSOR FOR t311_pb
 
    CALL g_shs.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH shs_curs INTO g_shs[g_cnt].*   #單身 ARRAY 填充
 
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_shs.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t311_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shs TO s_shs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t311_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t311_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t311_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t311_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t311_fetch('L')
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
         CALL cl_set_field_pic(g_shr.shrconf,"","","","",g_shr.shracti)
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
 
 
FUNCTION t311_y()
    DEFINE l_shs   RECORD LIKE shs_file.*
#   DEFINE l_sgm59  LIKE sgm_file.sgm59     #FUN-A60092 
    DEFINE l_sgm   RECORD LIKE sgm_file.*    #No:MOD-A10037 add
    DEFINE l_shs03 LIKE shs_file.shs03       #No:MOD-A10037 add
    DEFINE l_shm08_old1,l_shm08_old2 LIKE shm_file.shm08  #FUN-A60092
    DEFINE l_shm08_new1,l_shm08_new2 LIKE shm_file.shm08  #FUN-A60092
    DEFINE l_shs04 LIKE shs_file.shs04   #FUN-A60092
    #FUN-BB0085-add-str---
    DEFINE l_sgm012 LIKE sgm_file.sgm012
    DEFINE l_sgm03  LIKE sgm_file.sgm03
    DEFINE l_sgm58  LIKE sgm_file.sgm58
    DEFINE l_sgm62  LIKE sgm_file.sgm62
    DEFINE l_sgm63  LIKE sgm_file.sgm63
    DEFINE l_sgm65  LIKE sgm_file.sgm65
    DEFINE l_sgm304 LIKE sgm_file.sgm304
    DEFINE l_sgm317 LIKE sgm_file.sgm317
    #FUN-BB0085-add-end---

 
    IF g_shr.shrconf='Y' THEN RETURN END IF
    IF g_shr.shrconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shr.shracti='N' THEN RETURN END IF
 
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------- add ---------  begin
    SELECT * INTO g_shr.* FROM shr_file WHERE shr01 = g_shr.shr01
    IF g_shr.shrconf='Y' THEN RETURN END IF
    IF g_shr.shrconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_shr.shracti='N' THEN RETURN END IF
#CHI-C30107 --------- add ---------  end
 
    BEGIN WORK
 
    LET g_success='Y'
 
    OPEN t311_cl USING g_shr.shr01
    IF STATUS THEN
       CALL cl_err("OPEN t311_cl:", STATUS, 1)
       CLOSE t311_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t311_cl INTO g_shr.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t311_cl ROLLBACK WORK RETURN
    END IF
 
    SELECT shm08 INTO l_shm08_old1 FROM shm_file WHERE shm01=g_shr.shr03  #FUN-A60092
    DECLARE shs_cury CURSOR FOR
        SELECT * FROM shs_file WHERE shs01=g_shr.shr01 ORDER BY shs011
    CALL s_showmsg_init()              #NO.FUN-710026
    FOREACH shs_cury INTO l_shs.*
      SELECT shm08 INTO l_shm08_old2 FROM shm_file WHERE shm01=l_shs.shs02  #FUN-A60092
      #-------------------No:MOD-A10037 add
       INITIALIZE l_sgm.* TO NULL   
       LET l_shs03 = 0 
       SELECT * INTO l_sgm.* FROM sgm_file 
                WHERE sgm01 = l_shs.shs02
                  AND sgm03 = g_shr.shr04
                  AND sgm012= g_shr.shr012   #FUN-A60092 
       IF l_sgm.sgm54 = 'Y' THEN
#          LET l_shs03 = l_sgm.sgm291+l_sgm.sgm304-l_sgm.sgm59*(l_sgm.sgm311+   #FUN-A60092 
           LET l_shs03 = l_sgm.sgm291+l_sgm.sgm304-(l_sgm.sgm311+               #FUN-A60092 
                        l_sgm.sgm312+l_sgm.sgm313+l_sgm.sgm314+l_sgm.sgm316+
                        l_sgm.sgm317)
       ELSE
          LET l_shs03 = l_sgm.sgm301+l_sgm.sgm302+l_sgm.sgm303+l_sgm.sgm304-
#                       l_sgm.sgm59*(l_sgm.sgm311+l_sgm.sgm312+l_sgm.sgm313+  #FUN-A60092 
                                    (l_sgm.sgm311+l_sgm.sgm312+l_sgm.sgm313+  #FUN-A60092 
                        l_sgm.sgm314+l_sgm.sgm316+l_sgm.sgm317)
       END IF
       IF cl_null(l_shs03) THEN LET l_shs03 = 0 END IF
       IF l_shs.shs04 > l_shs03 THEN 
          LET g_showmsg=l_shs.shs02,"/",g_shr.shr04,"/",l_shs03     
          CALL s_errmsg('shs02,shr04,shs03',g_showmsg,'','asf-913',1)  
          LET g_success='N' 
       END IF
      #-------------------No:MOD-A10037 end
       UPDATE shm_file SET shm86=g_shr.shr03, 
                           shm08=shm08-l_shs.shs04/l_sgm.sgm62*l_sgm.sgm63   #CHI-9A0038 #FUN-A60092
         WHERE shm01=l_shs.shs02
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
          CALL s_errmsg('shm01',l_shs.shs02,'upd shm86',STATUS,1)        #NO.FUN-710026
          LET g_success='N' 
       END IF

       #-----CHI-9A0038---------
       UPDATE shm_file SET shm08=shm08+l_shs.shs04/l_sgm.sgm62*l_sgm.sgm63  #FUN-A60092
          WHERE shm01=g_shr.shr03
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
          CALL s_errmsg('shm01',g_shr.shr03,'upd shm08',STATUS,1)   
          LET g_success='N' 
       END IF
       #-----END CHI-9A0038----- 
 
       #FUN-A60092--begin--add----------
       IF g_sma.sma541 = 'Y' THEN
          LET l_shs04=l_shs.shs04/l_sgm.sgm62*l_sgm.sgm63
          #FUN-BB0085--modify--str-----------------
          DECLARE t311_sgm304 SCROLL CURSOR FOR 
           SELECT sgm62,sgm63,sgm304,sgm03,sgm012 FROM sgm_file
            WHERE sgm01=g_shr.shr03
              AND ((sgm54='Y' AND (sgm291+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0))
               OR (sgm54='N' AND (sgm301+sgm302+sgm303+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0)))
          FOREACH t311_sgm304 INTO l_sgm62,l_sgm63,l_sgm304,l_sgm03,l_sgm012
             SELECT sgm58 INTO l_sgm58 FROM sgm_file
              WHERE sgm01 = g_shr.shr03 AND sgm03 = l_sgm03 AND sgm012 = l_sgm012
             LET l_sgm304 = l_sgm304+(l_shs04*l_sgm62/l_sgm63)
             LET l_sgm304 = s_digqty(l_sgm304,l_sgm58)
             UPDATE sgm_file SET sgm304 = l_sgm304
              WHERE sgm01= g_shr.shr03 AND sgm03 = l_sgm03 AND sgm012 = l_sgm012
          END FOREACH  
          #UPDATE sgm_file SET sgm304=sgm304+(l_shs04*sgm62/sgm63)
          # WHERE sgm01=g_shr.shr03 
          #   AND ((sgm54='Y' AND (sgm291+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0)) 
          #    OR (sgm54='N' AND (sgm301+sgm302+sgm303+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0))) 
          #FUN-BB0085--modify--end-----------------
       ELSE
       #FUN-A60092--end--add-----------
          #FUN-BB0085--add-----str-----------------
          SELECT sgm58 INTO l_sgm58 FROM sgm_file 
           WHERE sgm01=g_shr.shr03 AND sgm03=g_shr.shr04 AND sgm012 = g_shr.shr012
          LET l_shs.shs04 = s_digqty(l_shs.shs04,l_sgm58) 
          #FUN-BB0085--add-----end-----------------
          UPDATE sgm_file SET sgm304=sgm304+l_shs.shs04
           WHERE sgm01=g_shr.shr03 AND sgm03=g_shr.shr04
            AND sgm012 = g_shr.shr012   #FUN-A60092 
       END IF
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
          LET g_showmsg=g_shr.shr03,"/",g_shr.shr04                        #NO.FUN-710026 
          CALL s_errmsg('sgm01,sgm03',g_showmsg,'upd sgm304',STATUS,1)     #NO.FUN-710026
          LET g_success='N' 
       END IF

#FUN-A60092 --begin-- 
#       #--------------
#       SELECT sgm59 INTO l_sgm59 FROM sgm_file
#        WHERE sgm01=g_shr.shr03 AND sgm03=g_shr.shr04
#       IF NOT cl_null(l_sgm59) AND l_sgm59!=0 THEN
#          LET l_shs.shs04=l_shs.shs04/l_sgm59
#       END IF
#FUN-A60092 --end--
       #FUN-A60092--begin--add----------
       IF g_sma.sma541 = 'Y' THEN
          LET l_shs04=l_shs.shs04/l_sgm.sgm62*l_sgm.sgm63
          #FUN-BB0085-----modify-----str-------------------------
          DECLARE t311_sgm317 SCROLL CURSOR FOR
           SELECT sgm62,sgm63,sgm317,sgm03,sgm012 FROM sgm_file
           #WHERE sgm01=g_shr.shr02    #TQC-C20183
            WHERE sgm01=l_shs.shs02    #TQC-C20183
              AND ((sgm54='Y' AND (sgm291+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0))
               OR (sgm54='N' AND (sgm301+sgm302+sgm303+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0)))
          FOREACH t311_sgm317 INTO l_sgm62,l_sgm63,l_sgm317,l_sgm03,l_sgm012
             SELECT sgm58 INTO l_sgm58 FROM sgm_file
              WHERE sgm01 = l_shs.shs02 AND sgm03 = l_sgm03 AND sgm012 = l_sgm012
             LET l_sgm317 = l_sgm317+(l_shs04*l_sgm62/l_sgm63)
             LET l_sgm317 = s_digqty(l_sgm317,l_sgm58)
             UPDATE sgm_file SET sgm317 = l_sgm317
              WHERE sgm01= l_shs.shs02 AND sgm03 = l_sgm03 AND sgm012 = l_sgm012
          END FOREACH
          #UPDATE sgm_file SET sgm317=sgm317+(l_shs04*sgm62/sgm63)
          # WHERE sgm01=l_shs.shs02 
          #   AND ((sgm54='Y' AND (sgm291+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0)) 
          #    OR (sgm54='N' AND (sgm301+sgm302+sgm303+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)>0))) 
          #FUN-BB0085-----modify-----end-------------------------
       ELSE
       #FUN-A60092--end--add-----------
          #FUN-BB0085--add-----str-----------------
          SELECT sgm58 INTO l_sgm58 FROM sgm_file
           WHERE sgm01=g_shr.shr02 AND sgm03=g_shr.shr04 AND sgm012 = g_shr.shr012
          LET l_shs.shs04 = s_digqty(l_shs.shs04,l_sgm58)
          #FUN-BB0085--add-----end-----------------
          UPDATE sgm_file SET sgm317=sgm317+l_shs.shs04
           WHERE sgm01=l_shs.shs02 AND sgm03=g_shr.shr04
             AND sgm012 = g_shr.shr012  #FUN-A60092 
       END IF
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN 
          LET g_showmsg=l_shs.shs02,"/",g_shr.shr04                         #NO.FUN-710026 
          CALL s_errmsg('sgm01,sgm03',g_showmsg,'upd sgm317', STATUS,1)     #NO.FUN-710026 
          LET g_success='N' 
       END IF
       #FUN-A60092--begin--add----------------
       SELECT shm08 INTO l_shm08_new2 FROM shm_file WHERE shm01=l_shs.shs02
       UPDATE sgm_file SET sgm65=sgm65*l_shm08_new2/l_shm08_old2
        WHERE sgm01=l_shs.shs02 
       #FUN-A60092--end--add-------------------
    END FOREACH
    #FUN-A60092--begin--add----------------
    SELECT shm08 INTO l_shm08_new1 FROM shm_file WHERE shm01=g_shr.shr03
    #FUN-BB0085-----modify-----str-------------------------
    DECLARE t311_sgm65 SCROLL CURSOR FOR
     SELECT sgm65,sgm03,sgm012 FROM sgm_file
      WHERE sgm01=g_shr.shr03
    FOREACH t311_sgm65 INTO l_sgm65,l_sgm03,l_sgm012
       SELECT sgm58 INTO l_sgm58 FROM sgm_file
        WHERE sgm01 = g_shr.shr03 AND sgm03 = l_sgm03 AND sgm012 = l_sgm012
       LET l_sgm65 = l_sgm65*l_shm08_new1/l_shm08_old1
       LET l_sgm65 = s_digqty(l_sgm65,l_sgm58)
       UPDATE sgm_file SET sgm65 = l_sgm65
        WHERE sgm01= g_shr.shr03 AND sgm03 = l_sgm03 AND sgm012 = l_sgm012
    END FOREACH
    #UPDATE sgm_file SET sgm65=sgm65*l_shm08_new1/l_shm08_old1
    #WHERE sgm01=g_shr.shr03
    #FUN-A60092--end--add-------------------
    CALL s_showmsg()           #NO.FUN-710026   
    IF g_success = 'Y' THEN
       LET g_shr.shrconf='Y'
       DISPLAY BY NAME g_shr.shrconf
       UPDATE shr_file SET shrconf='Y' WHERE shr01=g_shr.shr01
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_shr.shr01,'Y')
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION

#CHI-C80041---begin
#FUNCTION t311_v()      #CHI-D20010
FUNCTION t311_v(p_type) #CHI-D20010
DEFINE l_chr     LIKE type_file.chr1
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_shr.shr01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_shr.shrconf ='X' THEN RETURN END IF
   ELSE
      IF g_shr.shrconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t311_cl USING g_shr.shr01
   IF STATUS THEN
      CALL cl_err("OPEN t311_cl:", STATUS, 1)
      CLOSE t311_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t311_cl INTO g_shr.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shr.shr01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t311_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_shr.shrconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_shr.shrconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
#  IF cl_void(0,0,g_shr.shrconf)   THEN #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #CHI-D20010
        LET l_chr=g_shr.shrconf
       #IF g_shr.shrconf='N' THEN  #CHI-D20010
        IF p_type=1 THEN           #CHI-D20010 
            LET g_shr.shrconf='X' 
        ELSE
            LET g_shr.shrconf='N'
        END IF
        UPDATE shr_file
            SET shrconf=g_shr.shrconf,  
                shrmodu=g_user,
                shrdate=g_today
            WHERE shr01=g_shr.shr01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","shr_file",g_shr.shr01,"",SQLCA.sqlcode,"","",1)  
            LET g_shr.shrconf=l_chr 
        END IF
        DISPLAY BY NAME g_shr.shrconf
   END IF
 
   CLOSE t311_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shr.shr01,'V')
 
END FUNCTION
#CHI-C80041---end
