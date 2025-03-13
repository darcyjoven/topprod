# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft721.4gl
# Descriptions...: Run Card品質異常處理記錄維護作業
# Date & Author..: 99/06/25 by apple
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.MOD-530461 05/05/03 By pengu 1.加列印功能，直接與asfr721串接列印
                                               #   2.若有後續流程資料輸入，則不可取消確認
# Modify.........: No.TQC-630013 06/03/03 By Claire 串報表傳參數
# Modify.........: No.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-650114 06/06/02 By Sarah 1.shh08增加選項3.Check in hold,4.Check out hold,一定要輸入run card,製程序,留置碼
#                                                  2.當確認時如類型為3,4時,以留置碼更新Run card制程追蹤檔中的Check-in留置碼(sgm55),Check-out留置碼(sgm56)
# Modify.........: No.MOD-660030 06/06/16 By Pengu 按U修改時，會一直說單號重複
# Modify.........: No.TQC-660088 06/06/21 By Claire 流程訊息通知功能修改
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0164 06/11/13 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-880098 08/08/12 By claire shh031誤傳shh03
# Modify.........: No.TQC-940121 09/05/08 By mike 畫面中無desc欄位  
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0054 09/11/16 By Carrier INPUT时出现相同字段,导致INPUT失败
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50106 10/06/01 By houlia 留置碼shh061增加開窗
# Modify.........: No.TQC-A50111 10/06/13 By xiaofeizhu 錄入時當"類型"欄位為:3:Check in hold ,"留置碼shh061"需抓取asfi310中sgm55的值做為其預設值 
#                                                       錄入時當"類型"欄位為:4:Check out hold ,"留置碼shh061"需抓取asfi310中sgm56的值做為其預設值
# Modify.........: No.FUN-A60080 10/07/08 By destiny 增加平行工艺逻辑
# Modify.........: No.FUN-A70143 10/07/30 By destiny 平行工艺bug修改
# Modify.........: No.TQC-A50125 10/09/01 By destiny 1.作业编号输入完后未带出作业名称
#                                                    2.工艺序输入完后报无此留置码错 
# Modify.........: No.TQC-AB0281 10/11/29 By jan shh012給預設值
# Modify.........: No.TQC-AC0374 10/12/29 By liweie 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:MOD-BC0012 11/12/05 By ck2yuan 欄位在NOT NULL AND 有修改時才進入AFTER FIELD
# Modify.........: No.TQC-BC0109 11/12/15 By destiny 同一张单据审核前将作业编号置为空审核通过,但取消审核会报错,审核时管控应加严
# Modify.........: No.FUN-C30163 12/12/27 By pauline CALL q_sgm(時增加參數
# Modify.........: No:FUN-D20059 13/03/26 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_shh   RECORD LIKE shh_file.*,
    g_shh_t RECORD LIKE shh_file.*,
    g_shh_o RECORD LIKE shh_file.*,        #MOD-BC0012 add
    g_shh01_t LIKE shh_file.shh01,
    g_flag   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_h1,g_m1,g_s1 LIKE type_file.num5,    #No.FUN-680121 SMALLINT
     g_wc,g_sql          string     #No.FUN-580092 HCN
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE g_msg           LIKE type_file.chr1000      #TQC-630013        #No.FUN-680121 VARCHAR(72)
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(120)#TQC-630013
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_confirm      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_approve      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_post         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_close        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_void         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_valid        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_argv1        LIKE oea_file.oea01          #No.FUN-680121 VARCHAR(16)# No.FUN-4A0081 單號
DEFINE g_argv2         STRING              # No.FUN-4A0081 指定執行的功能
 
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680121 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)           #No.TQC-630066
   LET g_argv2=ARG_VAL(2)           #No.TQC-630066
   # LET p_row = ARG_VAL(1)
   # LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
    INITIALIZE g_shh.* TO NULL
    INITIALIZE g_shh_o.* TO NULL    #MOD-BC0012 add 

    LET g_forupd_sql = "SELECT * FROM shh_file WHERE shh01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t721_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t721_w AT p_row,p_col
         WITH FORM "asf/42f/asft721"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #NO.FUN-A60080--begin
   IF g_sma.sma541='N' THEN 
     #CALL cl_set_comp_visible("shh012,euc014",FALSE)  #No.FUN-A70143
      CALL cl_set_comp_visible("shh012,ecu014",FALSE)  #No.FUN-A70143
   ELSE 
   	  CALL cl_set_comp_entry("shh05",FALSE)   
   END IF 
   #NO.FUN-A60080--end    
    #No.TQC-630066 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t721_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t721_a()
            END IF
         OTHERWISE             #TQC-660088 
               CALL t721_q()   #TQC-660088
      END CASE
    END IF
    #No.TQC-630066 --end--
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t721_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t721_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION t721_curs()
  DEFINE l_slip LIKE aab_file.aab02        #No.FUN-680121 VARCHAR(5)#No.FUN-550067
    CLEAR FORM
    IF cl_null(g_argv1) THEN #No.TQC-630066
   INITIALIZE g_shh.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        shh01,shh02,shh021,shh022,shh08,shh04,shh031,shh03,
        shh05,shh012,shh06,shh07,shh061,shh14,                #NO.FUN-A60080  add shh012 
        shh111,shh112,shh113,shh101,shh10,
        shh131,shh132,shh121,shh12,shh151,shh152,
        shh141,shh142,shh143,shh161,shh162,shh163,shh164,shh165,
                             shh171,shh172,shh173,shh174,shh175,
        shhuser,shhgrup,shhmodu,shhdate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(shh01)
                   LET l_slip = g_shh.shh01[1,g_doc_len]
                  #CALL q_smy(TRUE,FALSE,l_slip,'asf','E')  #TQC-670008
                   CALL q_smy(TRUE,FALSE,l_slip,'ASF','E')  #TQC-670008
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh01
                WHEN INFIELD(shh031)
                  #CALL q_shm(0,0,g_shh.shh031) RETURNING g_shh.shh031
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_shm"
                   LET g_qryparam.default1 = g_shh.shh031
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh031
                   NEXT FIELD shh031
                WHEN INFIELD(shh04)
                  #CALL q_occ(0,0,g_shh.shh04) RETURNING g_shh.shh04
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_occ"
                   LET g_qryparam.default1 = g_shh.shh04
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh04
                   NEXT FIELD shh04
                WHEN INFIELD(shh05)
                  #CALL q_sgm(TRUE,FALSE,g_shh.shh031,'','1')      #No.MOD-640138  #FUN-C30163 mark
                   CALL q_sgm(TRUE,FALSE,g_shh.shh031,'','1','','','')       #FUN-C30163 add
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh05
                   NEXT FIELD shh05
                #NO.FUN-A60080--begin
                WHEN INFIELD(shh012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_shh012"
                   LET g_qryparam.default1 = g_shh.shh012
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh012
                   NEXT FIELD shh012                
                #NO.FUN-A60080--edn                    
                WHEN INFIELD(shh101)
                  #CALL q_gen(10,3,g_shh.shh101) RETURNING g_shh.shh101
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_gen"
                   LET g_qryparam.default1 = g_shh.shh101
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh101
                   NEXT FIELD shh101
                WHEN INFIELD(shh10)
                  #CALL q_gem(0,0,g_shh.shh10) RETURNING g_shh.shh10
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_gem"
                   LET g_qryparam.default1 = g_shh.shh10
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh10
                   NEXT FIELD shh10
                WHEN INFIELD(shh121)
                  #CALL q_gen(10,3,g_shh.shh121) RETURNING g_shh.shh121
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_gen"
                   LET g_qryparam.default1 = g_shh.shh121
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh121
                   NEXT FIELD shh121
                WHEN INFIELD(shh12)
                  #CALL q_gem(0,0,g_shh.shh12) RETURNING g_shh.shh12
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_gem"
                   LET g_qryparam.default1 = g_shh.shh12
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh12
                   NEXT FIELD shh12
#TQC-A50106 --add
                WHEN INFIELD(shh061)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form     = "q_sha061_1"
                   LET g_qryparam.default1 = g_shh.shh061
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO shh061
                   NEXT FIELD shh061
#TQC-A50106 --edd
               OTHERWISE
                   EXIT CASE
            END CASE
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
#No.TQC-630066 --start--
    ELSE
       LET g_wc =" shh01 = '",g_argv1,"'"    
    END IF
#No.TQC-630066 --end--
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND shhuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shhgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND shhgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT shh01 FROM shh_file ", # 組合出 SQL 指令
        " WHERE shh031 IS NOT NULL AND shh031!=' ' AND ",g_wc CLIPPED, " ORDER BY shh01"
    PREPARE t721_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t721_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t721_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM shh_file WHERE shh031 IS NOT NULL AND shh031!=' ' AND ",g_wc CLIPPED
    PREPARE t721_precount FROM g_sql
    DECLARE t721_count CURSOR FOR t721_precount
END FUNCTION
 
FUNCTION t721_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t721_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t721_q()
            END IF
        ON ACTION next
            CALL t721_fetch('N')
        ON ACTION previous
            CALL t721_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t721_u()
            END IF
        ON ACTION delete
            IF cl_chk_act_auth() THEN
                 CALL t721_r()
            END IF
 
         #------------------------No.MOD-530461--------------------------
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
           LET g_wc=' shh01= "',g_shh.shh01,'"'  #TQC-630013
               LET g_msg="asfr821 ",
                         "'",g_today,"'",
                         " '",g_user,"'",
                         " '",g_lang,"'",
                        #TQC-630013-begin
                        #" 'N' ",
                         " 'Y' ",
                         " ' ' ",
                         " '1'",
                         " '",g_wc,"'",
                         " '3'"
                        #" ' ' ",
                        #" 'N' ",
                        #"'",g_shh.shh01,"'"
                        #" '",l_no CLIPPED,"' ",l_wc2
                        #TQC-630013-end
               CALL cl_cmdrun(g_msg)
            END IF
        #-----------------------No.MOD-530461-----------------------
 
#        ON ACTION 確認
         ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t721_y()
            END IF
            CASE g_shh.shh14
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
#        ON ACTION 取消確認
         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t721_z()
            END IF
            CASE g_shh.shh14
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
#        ON ACTION 對策維護
{         ON ACTION maintain_solution
            LETg_action_choice="maintain_solution"
            IF cl_chk_act_auth() THEN
               CALL t721_1()
            END IF
}
#        ON ACTION 作廢
#        ON ACTION void
#           IF cl_chk_act_auth() THEN
#              CALL t721_x()
#           END IF
            CASE g_shh.shh14
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
           CALL t721_fetch('/')
        ON ACTION first
            CALL t721_fetch('F')
        ON ACTION last
            CALL t721_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       #No.FUN-6A0164-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_shh.shh01 IS NOT NULL THEN
                 LET g_doc.column1 = "shh01"
                 LET g_doc.value1 = g_shh.shh01
                 CALL cl_doc()
              END IF
          END IF
       #No.FUN-6A0164-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t721_cs
END FUNCTION
 
 
FUNCTION t721_a()
   DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_shh.* LIKE shh_file.*
    LET g_shh_t.* = g_shh.*
    LET g_shh_o.* = g_shh.*                      #MOD-BC0012 add
    LET g_shh01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        #No.TQC-630066 --start--
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_shh.shh01 = g_argv1
        END IF
        #No.TQC-630066 --end--
        LET g_shh.shhuser = g_user
        LET g_shh.shhoriu = g_user #FUN-980030
        LET g_shh.shhorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shh.shhgrup = g_grup               #使用者所屬群
        LET g_shh.shhdate = g_today
        LET g_shh.shh02   =g_today
        LET g_shh.shh021  =TIME
        LET g_shh.shh14   ='N'
        LET g_shh.shh06   =' '
        LET g_shh.shhplant = g_plant #FUN-980008 add
        LET g_shh.shhlegal = g_legal #FUN-980008 add
        #NO.TQC-AB0281--begin
        IF g_sma.sma541='N' THEN
           LET g_shh.shh012=' '
        END IF
        #NO.TQC-AB0281---end

        CALL t721_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_shh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_shh.shh01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK    #No:7829
       #No.FUN-550067 --start--
        CALL s_auto_assign_no("asf",g_shh.shh01,g_shh.shh02,"E","shh_file","shh01","","","")
        RETURNING li_result,g_shh.shh01
      IF (NOT li_result) THEN
         ROLLBACK WORK   #No:7829
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_shh.shh01
#       IF g_smy.smyauno='Y' THEN #自動賦予單據編號
#          CALL s_smyauno(g_shh.shh01,g_shh.shh02) RETURNING g_i,g_shh.shh01
#          IF g_i THEN #有問題
#             ROLLBACK WORK   #No:7829
#             CONTINUE WHILE
#          END IF
#          DISPLAY BY NAME g_shh.shh01
#       END IF
      #No.FUN-550067 --end--
        INSERT INTO shh_file VALUES(g_shh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)   #No.FUN-660128
           CALL cl_err3("ins","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        ELSE
           COMMIT WORK     #No:7829
           CALL cl_flow_notify(g_shh.shh01,'I')
 
           SELECT shh01 INTO g_shh.shh01 FROM shh_file
            WHERE shh01 = g_shh.shh01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t721_i(p_cmd)
DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_sgm45         LIKE sgm_file.sgm45,
        l_sgm55         LIKE sgm_file.sgm55,
        l_sgm56         LIKE sgm_file.sgm56,
       #l_desc          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20) #TQC-940121 
        l_slip          LIKE aab_file.aab02,          #No.FUN-680121 VARCHAR(5)#No.FUN-550067
        l_n             LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
    DISPLAY BY NAME
        g_shh.shh14,g_shh.shhuser,g_shh.shhgrup,g_shh.shhmodu,g_shh.shhdate
 
    INPUT BY NAME g_shh.shhoriu,g_shh.shhorig,
        g_shh.shh01,g_shh.shh02,g_shh.shh021,g_shh.shh022,
        g_shh.shh08,g_shh.shh04,g_shh.shh061,g_shh.shh14,g_shh.shh031,g_shh.shh03,
        g_shh.shh05,g_shh.shh012,g_shh.shh06,g_shh.shh07,#g_shh.shh061,   #FUN-650114 add g_shh.shh061  #No.TQC-9B0054  #NO.FUN-A60080  add shh012 
        g_shh.shh111,g_shh.shh112,g_shh.shh113,
        g_shh.shh101,g_shh.shh10,
        g_shh.shh131,g_shh.shh132,g_shh.shh121,g_shh.shh12,
        g_shh.shh151,g_shh.shh152,g_shh.shh141,g_shh.shh142,g_shh.shh143,
        g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
        g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175,
        g_shh.shhuser,g_shh.shhgrup,g_shh.shhmodu,g_shh.shhdate
        WITHOUT DEFAULTS
  
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t721_set_entry(p_cmd)
            CALL t721_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL t721_set_no_required()   #FUN-650114 add
            CALL t721_set_required()      #FUN-650114 add
            #No.FUN-550067 --start--
            CALL cl_set_docno_format("shh01")
            #No.FUN-550067 ---end---
 
        AFTER FIELD shh01
        #No.FUN-550067 --start--
        #IF p_cmd = 'a' THEN  #No.MOD-660030 add  #FUN-B50026 mark
           #IF NOT cl_null(g_shh.shh01) THEN      #FUN-B50026 mark
            IF NOT cl_null(g_shh.shh01)  AND (g_shh.shh01 != g_shh_t.shh01 OR g_shh_t.shh01 IS NULL) THEN  #FUN-B50026 add
               CALL s_check_no("asf",g_shh.shh01,"","E","shh_file","shh01","")
               RETURNING li_result,g_shh.shh01
               DISPLAY BY NAME g_shh.shh01
               IF (NOT li_result) THEN
                  LET g_shh.shh01=g_shh_t.shh01
                  NEXT FIELD shh01
               END IF
#              IF NOT cl_null(g_shh.shh01) THEN
#                 IF g_shh.shh01 ='   -      ' THEN LET g_shh.shh01='' END IF
#                 IF g_shh.shh01 IS NOT NULL THEN
#                    IF g_shh_t.shh01 IS NULL OR g_shh.shh01 != g_shh_t.shh01
#                    THEN LET l_slip=g_shh.shh01[1,3]
#                         CALL s_mfgslip(l_slip,'asf','E')	#檢查單別
#                         IF NOT cl_null(g_errno) THEN		#抱歉, 有問題
#                            CALL cl_err(l_slip,g_errno,0)
#                            LET g_shh.shh01=g_shh_t.shh01
#                            NEXT FIELD shh01
#                         END IF
#                    END IF
#                    IF p_cmd = 'a'  THEN
#                        IF NOT cl_null(g_shh.shh01[1,3]) AND #並且單號空白時,
#                           cl_null(g_shh.shh01[5,10]) THEN   #請使用者自行輸入
#                            IF g_smy.smyauno='N' THEN        #新增並要不自動編號
#                                NEXT FIELD shh01
#                            ELSE			       #要不, 則單號不用輸入
#                                NEXT FIELD shh02	
#                            END IF
#                        END IF
#                    END IF
#                END IF
#                IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#                   (p_cmd = "u" AND g_shh.shh01 != g_shh01_t) THEN
#                     IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_shh.shh01[5,10])
#                     THEN CALL cl_err('','9056',0)
#                          NEXT FIELD shh01
#                     END IF
#                     SELECT count(*) INTO l_n FROM shh_file
#                         WHERE shh01 = g_shh.shh01
#                     IF l_n > 0 THEN                  # Duplicated
#                         CALL cl_err(g_shh.shh01,-239,0)
#                         LET g_shh.shh01 = g_shh01_t
#                         DISPLAY BY NAME g_shh.shh01
#                         NEXT FIELD shh01
#                     END IF
#                END IF
            #No.FUN-550067 ---end---
              END IF
       #END IF   #No.MOD-660030 add  #FUN-B50026 mark
 
        AFTER FIELD shh021
           #IF NOT cl_null(g_shh.shh021) THEN                                                                   #MOD-BC0012 mark
           IF NOT cl_null(g_shh.shh021) AND (cl_null(g_shh_o.shh021) OR g_shh_o.shh021 != g_shh.shh021 )  THEN  #MOD-BC0012 add
              LET g_h1=g_shh.shh021[1,2]
              LET g_m1=g_shh.shh021[4,5]
              LET g_s1=g_shh.shh021[7,8]
              IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>23 OR g_m1>=60
              THEN CALL cl_err(g_shh.shh021,'asf-807',1)
                   NEXT FIELD sha021
              END IF
           END IF
           LET g_shh_o.shh021 = g_shh.shh021   #MOD-BC0012 add
 
       AFTER FIELD shh08
          #IF g_shh.shh08 NOT MATCHES '[1234]' THEN   #FUN-650114 add 34                                          #MOD-BC0012 mark
          IF g_shh.shh08 NOT MATCHES '[1234]' AND (cl_null(g_shh_o.shh08) OR g_shh_o.shh08 != g_shh.shh08) THEN   #MOD-BC0012 add
             NEXT FIELD shh08
          END IF
         #CALL s_shh08(g_shh.shh08) RETURNING l_desc #TQC-940121 
         #DISPLAY l_desc TO FORMONLY.desc #TQC-940121 
         #start FUN-650114 add
          CALL t721_set_no_entry(p_cmd)
          CALL t721_set_entry(p_cmd)
          CALL t721_set_no_required()
          CALL t721_set_required()
         #end FUN-650114 add
          LET g_shh_o.shh08 = g_shh.shh08   #MOD-BC0012 add
 
       AFTER FIELD shh04
          #IF not cl_null(g_shh.shh04) THEN                                                             #MOD-BC0012 mark
          IF not cl_null(g_shh.shh04) AND (cl_null(g_shh_o.shh04) OR g_shh_o.shh04 != g_shh.shh04 )THEN #MOD-BC0012 add
             CALL t721_shh04('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_shh.shh04,g_errno,0)
                LET g_shh.shh04 = g_shh_t.shh04
                DISPLAY BY NAME g_shh.shh04
                NEXT FIELD shh04
             END IF
          END IF
          LET g_shh_o.shh04 = g_shh.shh04   #MOD-BC0012 add

        AFTER FIELD shh031
            #IF NOT cl_null(g_shh.shh031) THEN                                                                 #MOD-BC0012 mark
            IF NOT cl_null(g_shh.shh031) AND (cl_null(g_shh_o.shh031) OR g_shh_o.shh031 != g_shh.shh031) THEN  #MOD-BC0012 add
                 CALL t721_shh031('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_shh.shh031,g_errno,0)
                    LET g_shh.shh031 = g_shh_t.shh031
                    DISPLAY BY NAME g_shh.shh031
                    NEXT FIELD shh031
                 END IF
            #END IF      #MOD-BC0012 mark 往下移11行
            #--------MOD-BC0012 START-----------
                IF NOT cl_null(g_shh.shh05) THEN
                    CALL t721_after_field_shh05() RETURNING l_n
                    IF l_n = 1 THEN
                        NEXT FIELD shh05
                    END IF
                    IF l_n = 2 THEN
                        NEXT FIELD shh08
                    END IF
                END IF
            END IF
            LET g_shh_o.shh031 = g_shh.shh031
            #--------MOD-BC0012 END  -----------
 
        AFTER FIELD shh05   #作業編號
         IF NOT cl_null(g_shh.shh05) AND (cl_null(g_shh_o.shh05) OR g_shh_o.shh05 != g_shh.shh05) THEN   #MOD-BC0012 add
            #No.TQC-A50125--begin
            IF cl_null(g_shh.shh012) THEN 
               LET g_shh.shh012=' '
            END IF 
            #No.TQC-A50125--end
          #--------MOD-BC0012 START-----------
            CALL t721_after_field_shh05() RETURNING l_n
            IF l_n = 1 THEN
                NEXT FIELD shh05
            END IF
            IF l_n = 2 THEN
                NEXT FIELD shh08
            END IF
          END IF
          LET g_shh_o.shh05 = g_shh.shh05
          #--------MOD-BC0012 END  -----------

        AFTER FIELD shh06   #製程序號
           #IF NOT cl_null(g_shh.shh06) THEN                                                              #MOD-BC0012 mark
           IF NOT cl_null(g_shh.shh06) AND (cl_null(g_shh_o.shh06) OR g_shh_o.shh06 != g_shh.shh06) THEN  #MOD-BC0012 add
              IF g_sma.sma541='N' THEN  #NO.FUN-A60080
                 CALL t721_shh06('a')
              #NO.FUN-A60080--begin   
              ELSE                     
              	 CALL t721_sgm_chk(g_shh.shh031,g_shh.shh012,g_shh.shh06)  
              	 IF cl_null(g_errno) THEN
              	    CALL t721_sgm_show()
              	 END IF  
              END IF 	
              #NO.FUN-A60080--end 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh06,g_errno,0)
                  LET g_shh.shh06 = g_shh_t.shh06
                  DISPLAY BY NAME g_shh.shh06
                  NEXT FIELD shh06
               END IF
           END IF
       #No.TQC-A50125--begin
           LET g_shh_o.shh06 = g_shh.shh06     #MOD-BC0012 add

       AFTER FIELD shh061  
          #IF NOT cl_null(g_shh.shh061) THEN                                                                #MOD-BC0012 mark
          IF NOT cl_null(g_shh.shh061) AND (cl_null(g_shh_o.shh061) OR g_shh_o.shh061 != g_shh.shh061) THEN #MOD-BC0012 add
             CALL t721_shh061('a')
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,0)
                LET g_shh.shh061 = g_shh_t.shh061
                DISPLAY BY NAME g_shh.shh061
                NEXT FIELD shh061
               END IF
          END IF 
       #No.TQC-A50125--end
          LET g_shh_o.shh061 = g_shh.shh061   #MOD-BC0012 add

       AFTER FIELD shh101
          #IF NOT cl_null(g_shh.shh101) THEN                                                                #MOD-BC0012 mark
          IF NOT cl_null(g_shh.shh101) AND (cl_null(g_shh_o.shh101) OR g_shh_o.shh101 != g_shh.shh101) THEN #MOD-BC0012 add
               CALL t721_gen02('a','1',g_shh.shh101)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh101,g_errno,0)
                  LET g_shh.shh101 = g_shh_t.shh101
                  DISPLAY BY NAME g_shh.shh101
                  NEXT FIELD shh101
               END IF
          END IF
          LET g_shh_o.shh101 = g_shh.shh101   #MOD-BC0012 add
 
       AFTER FIELD shh10
          #IF NOT cl_null(g_shh.shh10) THEN                                                                 #MOD-BC0012 mark
          IF NOT cl_null(g_shh.shh121) AND (cl_null(g_shh_o.shh121) OR g_shh_o.shh121 != g_shh.shh121)THEN  #MOD-BC0012 add
               CALL t721_gem02('a','1',g_shh.shh10)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh10,g_errno,0)
                  LET g_shh.shh10 = g_shh_t.shh10
                  DISPLAY BY NAME g_shh.shh10
                  NEXT FIELD shh10
               END IF
          END IF
          LET g_shh_o.shh10 = g_shh.shh10   #MOD-BC0012 add
 
       AFTER FIELD shh121
          #IF NOT cl_null(g_shh.shh121) THEN                                                                #MOD-BC0012 mark
          IF NOT cl_null(g_shh.shh121) AND (cl_null(g_shh_o.shh121) OR g_shh_o.shh121 != g_shh.shh121)THEN  #MOD-BC0012 add
               CALL t721_gen02('a','2',g_shh.shh121)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh121,g_errno,0)
                  LET g_shh.shh121 = g_shh_t.shh121
                  DISPLAY BY NAME g_shh.shh121
                  NEXT FIELD shh121
               END IF
          END IF
          LET g_shh_o.shh121 = g_shh.shh121   #MOD-BC0012 add

       AFTER FIELD shh12
          #IF NOT cl_null(g_shh.shh12) THEN                                                              #MOD-BC0012 mark
          IF NOT cl_null(g_shh.shh12) AND (cl_null(g_shh_o.shh12) OR g_shh_o.shh12 != g_shh.shh12)THEN   #MOD-BC0012 add
               CALL t721_gem02('a','2',g_shh.shh12)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shh.shh12,g_errno,0)
                  LET g_shh.shh12 = g_shh_t.shh12
                  DISPLAY BY NAME g_shh.shh12
                  NEXT FIELD shh12
               END IF
          END IF
          LET g_shh_o.shh12 = g_shh.shh12   #MOD-BC0012 add
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
                WHEN INFIELD(shh01)
#                  LET l_slip = g_shh.shh01[1,3]
                   LET l_slip = s_get_doc_no(g_shh.shh01)        #No.FUN-550067
                  #CALL q_smy(FALSE,FALSE,l_slip,'asf','E')  #TQC-670008
                   CALL q_smy(FALSE,FALSE,l_slip,'ASF','E')  #TQC-670008
                        RETURNING g_shh.shh01
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh01 )
                   DISPLAY BY NAME g_shh.shh01
                   NEXT FIELD shh01
                WHEN INFIELD(shh031)
                  #CALL q_shm(0,0,g_shh.shh031) RETURNING g_shh.shh031
                  #CALL FGL_DIALOG_SETBUFFER( g_shh.shh031 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_shm"
                   LET g_qryparam.default1 = g_shh.shh031
                   CALL cl_create_qry() RETURNING g_shh.shh031
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh031 )
                   DISPLAY BY NAME g_shh.shh031
                   NEXT FIELD shh031
                WHEN INFIELD(shh04)
                  #CALL q_occ(0,0,g_shh.shh04) RETURNING g_shh.shh04
                  #CALL FGL_DIALOG_SETBUFFER( g_shh.shh04 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_occ"
                   LET g_qryparam.default1 = g_shh.shh04
                   CALL cl_create_qry() RETURNING g_shh.shh04
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh04 )
                   DISPLAY BY NAME g_shh.shh04
                   NEXT FIELD shh04
                WHEN INFIELD(shh05)
                  #CALL q_sgm(FALSE,FALSE,g_shh.shh031,'','1')   #FUN-C30163 mark
                   CALL q_sgm(FALSE,FALSE,g_shh.shh031,'','1','','','')   #FUN-C30163 add
                        RETURNING g_shh.shh05,g_shh.shh06
#                  CALL FGL_DIALOG_SETBUFFER( g_shh.shh05 )
#                  CALL FGL_DIALOG_SETBUFFER( g_shh.shh06 )
                   IF NOT cl_null(g_shh.shh05) AND NOT cl_null(g_shh.shh06) THEN
                     SELECT sgm03,sgm05
                       INTO g_shh.shh06,g_shh.shh07
                       FROM sgm_file
                      WHERE sgm01=g_shh.shh031 AND sgm04=g_shh.shh05
                        AND sgm03=g_shh.shh06
                     IF STATUS THEN  #資料資料不存在
#                       CALL cl_err(g_shh.shh05,g_errno,0)   #No.FUN-660128
                        CALL cl_err3("sel","sgm_file",g_shh.shh031,g_shh.shh05,g_errno,"","",1)  #No.FUN-660128
                        LET g_shh.shh05 = g_shh_t.shh05
                        DISPLAY BY NAME g_shh.shh05
                        NEXT FIELD shh05
                     END IF
                     DISPLAY BY NAME g_shh.shh06, g_shh.shh07
                  ELSE
                     LET g_shh.shh05 = g_shh_t.shh05
                     DISPLAY BY NAME g_shh.shh05
                  END IF
                   NEXT FIELD shh05
                #NO.FUN-A60080--begin
                WHEN INFIELD(shh012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form= "q_sgm_2"
                   LET g_qryparam.arg1=g_shh.shh031
                   LET g_qryparam.default1 = g_shh.shh012
                   LET g_qryparam.default2 = g_shh.shh06
                   LET g_qryparam.default3 = g_shh.shh05
                   CALL cl_create_qry() RETURNING g_shh.shh012,g_shh.shh06,g_shh.shh05
                   DISPLAY g_shh.shh012 TO shh012
                   DISPLAY g_shh.shh02 TO shh06
                   DISPLAY g_shh.shh05 TO shh05
                   NEXT FIELD shh012
                #NO.FUN-A60080--end                          
                WHEN INFIELD(shh101)
                  #CALL q_gen(10,3,g_shh.shh101) RETURNING g_shh.shh101
                  #CALL FGL_DIALOG_SETBUFFER( g_shh.shh101 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gen"
                   LET g_qryparam.default1 = g_shh.shh101
                   CALL cl_create_qry() RETURNING g_shh.shh101
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh101 )
                   DISPLAY BY NAME g_shh.shh101
                   NEXT FIELD shh101
                WHEN INFIELD(shh10)
                  #CALL q_gem(0,0,g_shh.shh10) RETURNING g_shh.shh10
                  #CALL FGL_DIALOG_SETBUFFER( g_shh.shh10 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gem"
                   LET g_qryparam.default1 = g_shh.shh10
                   CALL cl_create_qry() RETURNING g_shh.shh10
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh10 )
                    DISPLAY BY NAME g_shh.shh10    #No.MOD-490371
                   NEXT FIELD shh10
                WHEN INFIELD(shh121)
                  #CALL q_gen(10,3,g_shh.shh121) RETURNING g_shh.shh121
                  #CALL FGL_DIALOG_SETBUFFER( g_shh.shh121 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gen"
                   LET g_qryparam.default1 = g_shh.shh121
                   CALL cl_create_qry() RETURNING g_shh.shh121
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh121 )
                   DISPLAY BY NAME g_shh.shh121
                   NEXT FIELD shh121
                WHEN INFIELD(shh12)
                  #CALL q_gem(0,0,g_shh.shh12) RETURNING g_shh.shh12
                  #CALL FGL_DIALOG_SETBUFFER( g_shh.shh12 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gem"
                   LET g_qryparam.default1 = g_shh.shh12
                   CALL cl_create_qry() RETURNING g_shh.shh12
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh12 )
                   DISPLAY BY NAME g_shh.shh12
                   NEXT FIELD shh12
#TQC-A50106 --add
                WHEN INFIELD(shh061)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_sha061"
                   LET g_qryparam.default1 = g_shh.shh061
                   CALL cl_create_qry() RETURNING g_shh.shh061
                   DISPLAY BY NAME g_shh.shh061
                   NEXT FIELD shh061
#TQC-A50106 --edd
               OTHERWISE
                   EXIT CASE
            END CASE
 
#MOD-650015 --start
#       ON ACTION CONTROLO                        # 沿用所有欄位
#           IF INFIELD(shh01) THEN
#               LET g_shh.* = g_shh_t.*
#               CALL t721_show()
#               NEXT FIELD shh01
#           END IF
#MOD-650015 --end
 
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
 
    END INPUT
END FUNCTION

#No.FUN-A60080  --Begin
FUNCTION t721_sgm_chk(p_sgm01,p_sgm012,p_sgm03)
   DEFINE p_sgm01     LIKE sgm_file.sgm01
   DEFINE p_sgm012    LIKE sgm_file.sgm012
   DEFINE p_sgm03     LIKE sgm_file.sgm03
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_sgm54     LIKE sgm_file.sgm54
   DEFINE l_sgm55     LIKE sgm_file.sgm55

   LET g_errno = ''

   IF cl_null(g_shh.shh031) OR g_shh.shh012 IS NULL THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sgm_file
    WHERE sgm01 = g_shh.shh031
      AND sgm012= g_shh.shh012
   #当前工单的工艺追踪档中无此工艺段号信息,请检查!
   IF l_cnt = 0 THEN
      LET g_errno = 'aec-311'
      RETURN
   END IF

   IF cl_null(g_shh.shh06) THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sgm_file
    WHERE sgm01 = g_shh.shh031
      AND sgm012= g_shh.shh012
      AND sgm03 = g_shh.shh06
   #无此工艺序号
   IF l_cnt = 0 THEN
      LET g_errno = 'abm-215'
      RETURN
   END IF

END FUNCTION   

FUNCTION t721_sgm_show()
   DEFINE l_sgm04  LIKE sgm_file.sgm04
   DEFINE l_sgm45  LIKE sgm_file.sgm45
   DEFINE l_sgm06  LIKE sgm_file.sgm06
   DEFINE l_sgm05  LIKE sgm_file.sgm05
   DEFINE l_sfb06  LIKE sfb_file.sfb06
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_ecu014 LIKE ecu_file.ecu014
   DEFINE l_flag   LIKE type_file.num5    #TQC-AC0374

   SELECT sgm04,sgm45
     INTO l_sgm04,l_sgm45
     FROM sgm_file
    WHERE sgm01 = g_shh.shh031
      AND sgm012= g_shh.shh012
      AND sgm03 = g_shh.shh06

   LET g_shh.shh05 = l_sgm04
   
  #FUN-B10056 ---------mod start----------- 
  ##SELECT sfb06,sfb05 INTO l_sfb06,l_sfb05 FROM sfb_file    #TQC-AC0374 mark
  ## WHERE sfb01 = g_shh.shh03                               #TQC-AC0374 mark
  #SELECT sfb06 INTO l_sfb06 FROM sfb_file        #TQC-AC0374
  # WHERE sfb01 = g_shh.shh03
  #CALL s_schdat_sel_ima571(g_shh.shh03) RETURNING l_flag,l_sfb05 #TQC-AC0374 
  #
  #SELECT ecu014 INTO l_ecu014 
  #  FROM ecu_file
  # WHERE ecu01 = l_sfb05
  #   AND ecu02 = l_sfb06
  #   AND ecu012= g_shh.shh012
   CALL s_runcard_sgm014(g_shh.shh031,g_shh.shh012) RETURNING l_ecu014
  #FUN-B10056 ---------mod end-------------- 

   DISPLAY l_sgm04 TO shh05
   DISPLAY l_sgm45 TO FORMONLY.ecm45
   DISPLAY l_ecu014 TO FORMONLY.ecu014

END FUNCTION
#NO.FUN-A60080--end   
 
FUNCTION t721_shh031(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_shm012    LIKE shm_file.shm012,
        l_shm28     LIKE shm_file.shm28,
        l_sfb05     LIKE sfb_file.sfb05,
        l_ima02     LIKE ima_file.ima02,
        l_ima021    LIKE ima_file.ima021
 
    LET g_errno = ' '
    SELECT shm012,shm05,shm28 INTO l_shm012,l_sfb05,l_shm28
      FROM shm_file
     WHERE shm01 = g_shh.shh031
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-910'
                                         LET l_shm012= NULL LET l_sfb05 = NULL
               WHEN l_shm28  = 'Y' LET g_errno = 'asf-741'
               OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
 
    #-->工單編號
    IF p_cmd = 'a' THEN
       LET g_shh.shh03 = l_shm012
       DISPLAY BY NAME g_shh.shh03
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = l_sfb05
       IF SQLCA.sqlcode THEN LET l_ima02 = ' ' LET l_ima021 = ' ' END IF
       DISPLAY l_sfb05  TO FORMONLY.sfb05
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION t721_shh04(p_cmd)    #客戶編號
         DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                l_occ02     LIKE occ_file.occ02,
                l_occacti   LIKE occ_file.occacti
 
     LET g_errno = ' '
     SELECT occ02,occacti INTO l_occ02,l_occacti
       FROM occ_file WHERE occ01 = g_shh.shh04
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                        LET l_occ02 = NULL
              WHEN l_occacti='N' LET g_errno = '9028'
       #FUN-690023------mod-------
              WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
       #FUN-690023------mod------- 
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_occ02 TO FORMONLY.occ02
     END IF
END FUNCTION
 
FUNCTION t721_shh06(p_cmd)    #製程序
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_sgm04     LIKE sgm_file.sgm04,
         l_sgm05     LIKE sgm_file.sgm05,
         l_sgm11     LIKE sgm_file.sgm11,
         l_sgm45     LIKE sgm_file.sgm45,
         l_sgm55     LIKE sgm_file.sgm55,
         l_sgm56     LIKE sgm_file.sgm56
 
     LET g_errno = ' '
     SELECT sgm04,sgm05,sgm11,sgm45,sgm55,sgm56
       INTO l_sgm04,l_sgm05,l_sgm11,l_sgm45,l_sgm55,l_sgm56
       FROM sgm_file WHERE sgm01 = g_shh.shh031 AND sgm03 = g_shh.shh06
       AND sgm012=g_shh.shh012   #NO.FUN-A60080  
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-805'
                                        LET l_sgm04 = NULL LET l_sgm05 = NULL
                                        LET l_sgm11 = NULL LET l_sgm45 = NULL
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'a' THEN
        LET g_shh.shh05 = l_sgm04
        LET g_shh.shh07 = l_sgm05
#       IF g_shh.shh08 MATCHES '[12]' THEN   #FUN-650114 add  #TQC-A50111 Mark
        IF g_shh.shh08 MATCHES '[1234]' THEN                  #TQC-A50111 Add
#          IF g_shh.shh08 = '1' THEN                          #TQC-A50111 Mark
           IF g_shh.shh08 MATCHES '[13]' THEN                 #TQC-A50111 Add
              LET g_shh.shh061= l_sgm55
           ELSE 
         	    LET g_shh.shh061= l_sgm56
           END IF
           IF NOT cl_null(g_shh.shh061) THEN #No.TQC-A50125
              CALL t721_shh061('d')
           END IF 
        END IF                               #FUN-650114 add
        DISPLAY BY NAME g_shh.shh05,g_shh.shh07
     END IF
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_sgm45 TO FORMONLY.ecm45
     END IF
END FUNCTION
 
FUNCTION t721_shh061(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_sgg02     LIKE sgg_file.sgg02,
         l_sggacti   LIKE sgg_file.sggacti
 
     LET g_errno = ' '
     SELECT sgg02,sggacti INTO l_sgg02,l_sggacti
       FROM sgg_file WHERE sgg01 = g_shh.shh061
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-731'
                                        LET l_sgg02 = NULL
              WHEN l_sggacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN DISPLAY l_sgg02 TO FORMONLY.sgg02
          DISPLAY BY NAME g_shh.shh061
     END IF
END FUNCTION
 
FUNCTION t721_gen02(p_cmd,p_type,p_gen01)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_type      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_gen01     LIKE gen_file.gen01,
         l_gen02     LIKE gen_file.gen02,
         l_gen03     LIKE gen_file.gen03,
         l_genacti   LIKE gen_file.genacti
 
     LET g_errno = ' '
     SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
       FROM gen_file WHERE gen01 = p_gen01
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                        LET l_gen02 = NULL
              WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN CASE
           WHEN p_type = '1'
                 IF p_cmd = 'a' AND cl_null(g_shh.shh10) THEN
                    LET g_shh.shh10 = l_gen03
                    DISPLAY BY NAME g_shh.shh10
                 END IF
                 DISPLAY l_gen02 TO FORMONLY.gen02_1
           WHEN p_type = '2'
                 IF p_cmd = 'a' AND cl_null(g_shh.shh12) THEN
                    LET g_shh.shh12 = l_gen03
                    DISPLAY BY NAME g_shh.shh12
                 END IF
                 DISPLAY l_gen02 TO FORMONLY.gen02_2
           OTHERWISE EXIT CASE
          END CASE
     END IF
END FUNCTION
 
FUNCTION t721_gem02(p_cmd,p_type,p_gem01)    #部門
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_type      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         p_gem01     LIKE gem_file.gem01,
         l_gem02     LIKE gem_file.gem02,
         l_gemacti   LIKE gem_file.gemacti
 
     LET g_errno = ' '
     SELECT gem02,gemacti INTO l_gem02,l_gemacti
       FROM gem_file WHERE gem01 = p_gem01
         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                        LET l_gem02 = NULL
              WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
     IF p_cmd = 'd' OR cl_null(g_errno)
     THEN CASE
           WHEN p_type = '1'
                 DISPLAY l_gem02 TO FORMONLY.gem02_1
           WHEN p_type = '2'
                 DISPLAY l_gem02 TO FORMONLY.gem02_2
           OTHERWISE EXIT CASE
          END CASE
     END IF
END FUNCTION
 
FUNCTION t721_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shh.* TO NULL                #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t721_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t721_count
    FETCH t721_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t721_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
        INITIALIZE g_shh.* TO NULL
    ELSE
        CALL t721_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t721_fetch(p_flshh)
    DEFINE
        p_flshh         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flshh
        WHEN 'N' FETCH NEXT     t721_cs INTO g_shh.shh01
        WHEN 'P' FETCH PREVIOUS t721_cs INTO g_shh.shh01
        WHEN 'F' FETCH FIRST    t721_cs INTO g_shh.shh01
        WHEN 'L' FETCH LAST     t721_cs INTO g_shh.shh01
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
            FETCH ABSOLUTE g_jump t721_cs INTO g_shh.shh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
        INITIALIZE g_shh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flshh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_shh.* FROM shh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE shh01 = g_shh.shh01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)   #No.FUN-660128
       CALL cl_err3("sel","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_shh.* TO NULL            #FUN-4C0035
    ELSE
       LET g_data_owner = g_shh.shhuser      #FUN-4C0035
       LET g_data_group = g_shh.shhgrup      #FUN-4C0035
       LET g_data_plant = g_shh.shhplant #FUN-980030
       CALL t721_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t721_show()
    DEFINE
       #l_desc     LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20) #TQC-940121 
        l_ecb17    LIKE ecb_file.ecb17,
        l_sgm11    LIKE sgm_file.sgm11
 
    LET g_shh_t.* = g_shh.*
    DISPLAY BY NAME g_shh.shh01,g_shh.shh031,g_shh.shh03,g_shh.shh02, g_shh.shhoriu,g_shh.shhorig,
            g_shh.shh04,g_shh.shh021,g_shh.shh022,g_shh.shh05,g_shh.shh012,g_shh.shh06,  #NO.FUN-A60080  add shh012 
            g_shh.shh07,g_shh.shh061,g_shh.shh08,
            g_shh.shh111,g_shh.shh112,g_shh.shh113,
            g_shh.shh101,g_shh.shh10,g_shh.shh131,g_shh.shh132,
            g_shh.shh121,g_shh.shh12,g_shh.shh151,g_shh.shh152,
            g_shh.shh141,g_shh.shh142,g_shh.shh143,
            g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
            g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175,
            g_shh.shh14,g_shh.shhuser,g_shh.shhgrup,g_shh.shhmodu,
            g_shh.shhdate
   #CALL s_shh08(g_shh.shh08) RETURNING l_desc #TQC-940121 
   #DISPLAY l_desc TO FORMONLY.desc #TQC-940121 
    CALL t721_shh031('d')
    CALL t721_shh04('d')
    CALL t721_shh06('d')
    CALL t721_shh061('d')
    CALL t721_gen02('d','1',g_shh.shh101)
    CALL t721_gen02('d','2',g_shh.shh121)
    CALL t721_gem02('d','1',g_shh.shh10)
    CALL t721_gem02('d','2',g_shh.shh12)
    CALL t721_sgm_show() #NO.FUN-A60080
    CASE g_shh.shh14
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t721_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_shh.shh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_shh.* FROM shh_file WHERE shh01=g_shh.shh01
    LET g_shh_o.* = g_shh.*
    #-->已確認不可修改
    IF g_shh.shh14 = 'Y' THEN
       CALL cl_err(g_shh.shh14,'axm-101',0) RETURN
    END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_shh01_t = g_shh.shh01
    BEGIN WORK
 
    OPEN t721_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t721_cl:", STATUS, 1)
       CLOSE t721_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t721_cl INTO g_shh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_shh.shhmodu=g_user                     #修改者
    LET g_shh.shhdate = g_today                  #修改日期
    CALL t721_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t721_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_shh.*=g_shh_t.*
            CALL t721_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE shh_file SET shh_file.* = g_shh.*    # 更新DB
            WHERE shh01 = g_shh01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shh_file",g_shh01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t721_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shh.shh01,'U')
 
END FUNCTION
 
FUNCTION t721_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_shh.shh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
    IF SQLCA.sqlcode THEN
#      CALL cl_err('sel error',SQLCA.sqlcode,0)  #No.FUN-660128
       CALL cl_err3("sel","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","sel error",1)  #No.FUN-660128
       RETURN  
    END IF
    #-->已確認不可刪除
    IF g_shh.shh14 = 'Y' THEN
       CALL cl_err(g_shh.shh14,'axm-101',0) RETURN
    END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    BEGIN WORK
 
    OPEN t721_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t721_cl:", STATUS, 1)
       CLOSE t721_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t721_cl INTO g_shh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t721_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "shh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_shh.shh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM shh_file WHERE shh01 = g_shh.shh01
       CLEAR FORM
       OPEN t721_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t721_cs
          CLOSE t721_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t721_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t721_cs
          CLOSE t721_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t721_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t721_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t721_fetch('/')
       END IF
 
    END IF
 
    CLOSE t721_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shh.shh01,'D')
 
END FUNCTION
 
FUNCTION t721_y()
  DEFINE l_gen02 LIKE gen_file.gen02
  DEFINE  l_time LIKE type_file.chr8      #No.FUN-6A0090
 
  IF s_shut(0) THEN RETURN END IF
  IF g_shh.shh01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
  END IF
  SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
  IF SQLCA.sqlcode THEN
#    CALL cl_err('sel shh',SQLCA.sqlcode,0)    #No.FUN-660128
     CALL cl_err3("sel","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","sel shh",1)  #No.FUN-660128
     RETURN
  END IF
  IF g_shh.shh14 ='Y' THEN RETURN END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
  IF NOT cl_confirm('axm-108') THEN RETURN END IF
  LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t721_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t721_cl:", STATUS, 1)
       CLOSE t721_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t721_cl INTO g_shh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
       RETURN
    END IF
     CASE g_shh.shh08
       WHEN '1'
            UPDATE sgm_file SET sgm55 = ' '
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
                            AND (sgm55 is not null or sgm55 != ' ')
                                  #bugno:7338 mark
           #IF SQLCA.sqlcode THEN # OR SQLCA.sqlerrd[3] = 0 THEN #TQC-BC0109
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN        #TQC-BC0109
#              CALL cl_err('sgm55',STATUS,1) #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh031,g_shh.shh06,STATUS,"","sgm55",1)  #No.FUN-660128
                   LET g_success = 'N'  
            END IF
       WHEN '2'
            UPDATE sgm_file SET sgm56 = ' '
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
                            AND (sgm56 is not null or sgm56 != ' ')
                                  #bugno:7338 mark
           #IF SQLCA.sqlcode THEN # OR SQLCA.sqlerrd[3] = 0 THEN #TQC-BC0109
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN        #TQC-BC0109
#              CALL cl_err('sgm56',STATUS,1)    #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh031,g_shh.shh06,STATUS,"","sgm56",1)  #No.FUN-660128
               LET g_success = 'N'
            END IF
      #start FUN-650114 add
       WHEN '3'
            UPDATE sgm_file SET sgm55 = g_shh.shh061
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
                            AND (sgm55 is not null or sgm55 != ' ')
                                  #bugno:7338 mark
           #IF SQLCA.sqlcode THEN # OR SQLCA.sqlerrd[3] = 0 THEN #TQC-BC0109
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN        #TQC-BC0109
#              CALL cl_err('sgm55',STATUS,1)  #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh031,g_shh.shh06,STATUS,"","sgm55",1)  #No.FUN-660128
 
               LET g_success = 'N'  
 
            END IF
       WHEN '4'
            UPDATE sgm_file SET sgm56 = g_shh.shh061
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
                            AND (sgm56 is not null or sgm56 != ' ')
                                  #bugno:7338 mark
           #IF SQLCA.sqlcode THEN # OR SQLCA.sqlerrd[3] = 0 THEN #TQC-BC0109
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN        #TQC-BC0109
#              CALL cl_err('sgm56',STATUS,1)  #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh031,g_shh.shh06,STATUS,"","sgm56",1)  #No.FUN-660128
 
               LET g_success = 'N' 
 
            END IF
      #end FUN-650114 add
       OTHERWISE LET g_success = 'N'
     END CASE
     LET l_time = TIME
     UPDATE shh_file SET shh14  ='Y',
                         shh141 = g_user,
                         shh142 = g_today,
                         shh143 = l_time
                   WHERE shh01  = g_shh.shh01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
          THEN
#           CALL cl_err('upd shh_file',STATUS,1)    #No.FUN-660128
           CALL cl_err3("upd","shh_file",g_shh.shh01,"",STATUS,"","upd shh_file",1)  #No.FUN-660128
           LET g_success = 'N'
         END IF
     IF g_success='N' THEN
        CALL cl_rbmsg(1)
        ROLLBACK WORK
     ELSE
        CALL cl_cmmsg(1)
        COMMIT WORK
        CALL cl_flow_notify(g_shh.shh01,'Y')
 
        LET g_shh.shh14 = 'Y'    LET g_shh.shh141=g_user
        LET g_shh.shh142=g_today LET g_shh.shh143= l_time       #FUN-D20059 TIME-->l_time
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
        IF SQLCA.sqlcode THEN  LET l_gen02 = ' ' END IF
        DISPLAY BY NAME g_shh.shh14,g_shh.shh141,g_shh.shh142,g_shh.shh143
        DISPLAY l_gen02 TO FORMONLY.gen02_3
     END IF
END FUNCTION
 
FUNCTION t721_z()
  DEFINE l_gen02 LIKE gen_file.gen02
   DEFINE l_cnt  LIKE type_file.num5             #MOD-530461        #No.FUN-680121 SMALLINT
  DEFINE l_time LIKE type_file.chr8              #FUN-D20059
 
  IF s_shut(0) THEN RETURN END IF
  IF g_shh.shh01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
  END IF
 
   #--No.MOD-530461
  SELECT COUNT(*) INTO l_cnt FROM shh_file
     WHERE shh03 = g_shh.shh03  AND shh031=g_shh.shh031 AND shh06 > g_shh.shh06
  IF l_cnt > 0 THEN
     CALL cl_err('','asf-078',1)
     RETURN
  END IF
 #--end
 
  SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
  IF SQLCA.sqlcode THEN
#    CALL cl_err('sel shh',SQLCA.sqlcode,0)  #No.FUN-660128
     CALL cl_err3("sel","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","sel shh",1)  #No.FUN-660128
     RETURN  
  END IF
  IF g_shh.shh14 ='N' THEN RETURN END IF
    IF g_shh.shh14 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
  IF NOT cl_confirm('axm-109') THEN RETURN END IF
  LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t721_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t721_cl:", STATUS, 1)
       CLOSE t721_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t721_cl INTO g_shh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
       RETURN
    END IF
     CASE g_shh.shh08
       WHEN '1'
            UPDATE sgm_file SET sgm55 = g_shh.shh061
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err('sgm55',STATUS,1)   #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh061,g_shh.shh031,STATUS,"","sgm55",1)  #No.FUN-660128
               LET g_success = 'N' 
            END IF
       WHEN '2'
            UPDATE sgm_file SET sgm56 = g_shh.shh061
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err('sgm56',STATUS,1)    #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh061,g_shh.shh031,STATUS,"","sgm56",1)  #No.FUN-660128
               LET g_success = 'N'
            END IF
      #start FUN-650114 add
       WHEN '3'
            UPDATE sgm_file SET sgm55 = ' '
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err('sgm55',STATUS,1)    #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh031,g_shh.shh06,STATUS,"","sgm55",1)  #No.FUN-660128
               LET g_success = 'N'
            END IF
       WHEN '4'
            UPDATE sgm_file SET sgm56 = ' '
                          WHERE sgm01 = g_shh.shh031
                            AND sgm03 = g_shh.shh06
                            AND sgm012= g_shh.shh012   #NO.FUN-A60080
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err('sgm56',STATUS,1)   #No.FUN-660128
               CALL cl_err3("upd","sgm_file",g_shh.shh06,g_shh.shh031,STATUS,"","sgm56",1)  #No.FUN-660128
               LET g_success = 'N' 
            END IF
      #end FUN-650114 add
       OTHERWISE LET g_success = 'N'
     END CASE
#FUN-D20059--str--
#    UPDATE shh_file SET shh14 ='N',
#                        shh141=' ',
#                        shh142='',
#                        shh143=' '      #bugno:7451 modify
     LET l_time = TIME
     UPDATE shh_file SET shh14 = 'N',
                         shh141 = g_user,
                         shh142 = g_today,
                         shh143 = l_time
#FUN-D20059--end--
                   WHERE shh01 = g_shh.shh01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('upd shh_file',STATUS,1)   #No.FUN-660128
        CALL cl_err3("upd","shh_file",g_shh.shh01,"",STATUS,"","upd shh_file",1)  #No.FUN-660128
        LET g_success = 'N' 
     END IF
     IF g_success='N' THEN
        CALL cl_rbmsg(1) ROLLBACK WORK
     ELSE
        CALL cl_cmmsg(1) COMMIT WORK
       #bugno:7338 modify LET g_shh.shh14 = 'N'
    #FUN-D20059--str--
    #   LET g_shh.shh14 = 'N'    LET g_shh.shh141=' '
    #   LET g_shh.shh142= ''     LET g_shh.shh143=' '       #bugno:7451 modify
        LET g_shh.shh14 = 'N'         LET g_shh.shh141 = g_user
        LET g_shh.shh142 = g_today     LET g_shh.shh143 = l_time
    #FUN-D20059--end--
        DISPLAY BY NAME g_shh.shh14,g_shh.shh141,g_shh.shh142,g_shh.shh143
    #FUN-D20059--str--
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
        IF SQLCA.sqlcode THEN  LET l_gen02 = ' ' END IF
   #    LET l_gen02 = ' '   #FUN-D20059
     #FUN-D20059--end--
        DISPLAY l_gen02 TO FORMONLY.gen02_3
     END IF
END FUNCTION
 
FUNCTION t721_1()
   IF s_shut(0) THEN RETURN END IF
   IF g_shh.shh01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
   END IF
   LET g_success ='Y'
#  SELECT * INTO g_shh.* FROM shh_file WHERE shh01 = g_shh.shh01
    BEGIN WORK
 
    OPEN t721_cl USING g_shh.shh01
 
    IF STATUS THEN
       CALL cl_err("OPEN t721_cl:", STATUS, 1)
       CLOSE t721_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t721_cl INTO g_shh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    OPEN WINDOW t721_1_w AT 12,2
         WITH FORM "asf/42f/asft7211"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("asft7211")
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW t721_1_w
       RETURN
    END IF
 
    DISPLAY BY NAME g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
                    g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175
   INPUT BY NAME g_shh.shh161,g_shh.shh162,g_shh.shh163,g_shh.shh164,g_shh.shh165,
                 g_shh.shh171,g_shh.shh172,g_shh.shh173,g_shh.shh174,g_shh.shh175
                 WITHOUT DEFAULTS
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t721_1_w RETURN END IF
   UPDATE shh_file SET shh161 = g_shh.shh161,shh162= g_shh.shh162,
                       shh163 = g_shh.shh163,shh164= g_shh.shh164,
                       shh165 = g_shh.shh165,shh171= g_shh.shh171,
                       shh172 = g_shh.shh172,shh173= g_shh.shh173,
                       shh174 = g_shh.shh174,shh175= g_shh.shh175
         WHERE shh01 = g_shh.shh01
   IF SQLCA.sqlcode THEN LET g_success ='N'
         CALL cl_err('t721_1',STATUS,1) END IF
   IF g_success ='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CLOSE WINDOW t721_1_w
   RETURN
END FUNCTION
 
FUNCTION t721_x()
 
   IF s_shut(0) THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t721_cl USING g_shh.shh01
 
   IF STATUS THEN
      CALL cl_err("OPEN t721_cl:", STATUS, 1)
      CLOSE t721_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t721_cl INTO g_shh.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shh.shh01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t721_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_shh.shh01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_shh.shh14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF cl_void(0,0,g_shh.shh14)   THEN
        LET g_chr=g_shh.shh14
        IF g_shh.shh14='N' THEN
            LET g_shh.shh14='X'
        ELSE
            LET g_shh.shh14='N'
        END IF
        UPDATE shh_file
            SET shh14=g_shh.shh14,
                shhmodu=g_user,
                shhdate=g_today
            WHERE shh01  =g_shh.shh01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_shh.shh14,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","shh_file",g_shh.shh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_shh.shh14=g_chr
        END IF
        DISPLAY BY NAME g_shh.shh14
   END IF
 
   CLOSE t721_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shh.shh01,'V')
 
END FUNCTION
 
FUNCTION t721_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("shh01",TRUE)
   END IF
  #start FUN-650114 add
   IF INFIELD(shh08) AND g_shh.shh08 MATCHES '[34]' THEN
      CALL cl_set_comp_entry("shh061",TRUE)
   END IF
  #end FUN-650114 add
END FUNCTION
 
FUNCTION t721_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("shh01",FALSE)
   END IF
  #start FUN-650114 add
   IF INFIELD(shh08) AND g_shh.shh08 MATCHES '[12]' THEN
      CALL cl_set_comp_entry("shh061",FALSE)
   END IF
  #end FUN-650114 add
END FUNCTION
 
#start FUN-650114 add
FUNCTION t721_set_required()
 
  IF g_shh.shh08 MATCHES '[34]' THEN 
     CALL cl_set_comp_required("shh031,shh06,shh061",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t721_set_no_required()
 
  #CALL cl_set_comp_required("shh031,shh06,shh061",FALSE)   #MOD-BC0012 mark
  CALL cl_set_comp_required("shh06,shh061",FALSE)           #MOD-BC0012 add  shh031改為必填
   
END FUNCTION
#end FUN-650114 add
FUNCTION t721_after_field_shh05()  #MOD-BC0012 add  將AFTER FILED shh05判斷拿出來 方便AFTER FILED shh031呼叫

    DEFINE l_sgm45         LIKE sgm_file.sgm45,
           l_sgm55         LIKE sgm_file.sgm55,
           l_sgm56         LIKE sgm_file.sgm56,
           l_n             LIKE type_file.num5   #當有錯時 回傳1為NEXT FIELD shh05 
                                                 #         回傳2為NEXT FIELD shh08
   LET l_n = 0
   SELECT COUNT(*) INTO g_cnt FROM sgm_file
            WHERE sgm01=g_shh.shh031 AND sgm04=g_shh.shh05
            CASE
              WHEN g_cnt=0   
                   CALL cl_err(g_shh.shh05,100,0)
                   LET g_shh.shh05 = g_shh_t.shh05
                   LET g_shh.shh06 = g_shh_t.shh06
                   DISPLAY BY NAME g_shh.shh05,g_shh_t.shh06
                   LET l_n = 1
              WHEN g_cnt=1
                   IF NOT cl_null(g_shh.shh06) THEN
                       SELECT sgm03,sgm05,sgm45,sgm55,sgm56
                         INTO g_shh.shh06,g_shh.shh07,l_sgm45,l_sgm55,l_sgm56
                         FROM sgm_file
                        WHERE sgm01=g_shh.shh031 AND sgm04=g_shh.shh05
                          AND sgm03=g_shh.shh06
                          AND sgm012=g_shh.shh012
                   ELSE
                       SELECT sgm03,sgm05,sgm45,sgm55,sgm56
                         INTO g_shh.shh06,g_shh.shh07,l_sgm45,l_sgm55,l_sgm56
                         FROM sgm_file
                        WHERE sgm01=g_shh.shh031 AND sgm04=g_shh.shh05
                   END IF
                   IF STATUS THEN  #資料資料不存在
#                     CALL cl_err(g_shh.shh05,STATUS,0) #No.FUN-660128
                      CALL cl_err3("sel","sgm_file",g_shh.shh031,g_shh.shh05,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                      LET g_shh.shh05 = g_shh_t.shh05
                      LET g_shh.shh06 = g_shh_t.shh06
                      DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                      LET l_n = 1
                   END IF
                   DISPLAY l_sgm45 TO FORMONLY.ecm45   #No.TQC-A50125      
                   IF g_shh.shh08 MATCHES '[12]' THEN   #FUN-650114 add
                      #-->無hold
                      IF g_shh.shh08 ='1' AND cl_null(l_sgm55) THEN
                         CALL cl_err(g_shh.shh05,'asf-729',0)
                         LET g_shh.shh05 = g_shh_t.shh05
                         LET g_shh.shh06 = g_shh_t.shh06
                         DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                         LET l_n = 2
                      ELSE LET g_shh.shh061 = l_sgm55
                      END IF
                      IF g_shh.shh08 ='2' AND cl_null(l_sgm56) THEN
                         CALL cl_err(g_shh.shh05,'asf-730',0)
                         LET g_shh.shh05 = g_shh_t.shh05
                         LET g_shh.shh06 = g_shh_t.shh06
                         DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                         LET l_n = 2
                      ELSE LET g_shh.shh061 = l_sgm56
                      END IF
                   END IF                               #FUN-650114 add
              WHEN g_cnt>1
                  #CALL q_sgm(FALSE,FALSE,g_shh.shh031,g_shh.shh05,'1')     #No.MOD-640138   #MOD-880098 modify shh03->shh031   #FUN-C30163 mark
                   CALL q_sgm(FALSE,FALSE,g_shh.shh031,g_shh.shh05,'1','','','')     #FUN-C30163 add
                        RETURNING g_shh.shh05,g_shh.shh06
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh05 )
#                   CALL FGL_DIALOG_SETBUFFER( g_shh.shh06 )
                   SELECT sgm03,sgm05,sgm45,sgm55,sgm56
                     INTO g_shh.shh06,g_shh.shh07,l_sgm45,l_sgm55,l_sgm56
                     FROM sgm_file
                     WHERE sgm01=g_shh.shh03 AND sgm04=g_shh.shh05
                       AND sgm03=g_shh.shh06
                   IF STATUS THEN  #資料資料不存在
#                     CALL cl_err(g_shh.shh05,STATUS,0)   #No.FUN-660128
                      CALL cl_err3("sel","sgm_file",g_shh.shh03,g_shh.shh05,STATUS,"","",1)  #No.FUN-660128
                      LET g_shh.shh05 = g_shh_t.shh05
                      LET g_shh.shh06 = g_shh_t.shh06
                      DISPLAY BY NAME g_shh.shh05,g_shh.shh06
                      LET l_n = 1
                   END IF
                   DISPLAY l_sgm45 TO FORMONLY.ecm45   #No.TQC-A50125          
                   IF g_shh.shh08 MATCHES '[12]' THEN   #FUN-650114 add
                      #-->無hold
                      IF g_shh.shh08 ='1' AND cl_null(l_sgm55) THEN
                         CALL cl_err(g_shh.shh05,'asf-729',0)
                         LET g_shh.shh05 = g_shh_t.shh05
                         DISPLAY BY NAME g_shh.shh05
                         LET l_n = 1
                      ELSE LET g_shh.shh061 = l_sgm55
                      END IF
                      IF g_shh.shh08 ='2' AND cl_null(l_sgm56) THEN
                         CALL cl_err(g_shh.shh05,'asf-730',0)
                         LET g_shh.shh05 = g_shh_t.shh05
                         DISPLAY BY NAME g_shh.shh05
                         LET l_n = 1
                      ELSE LET g_shh.shh061 = l_sgm56
                      END IF
                   END IF                               #FUN-650114 add
              OTHERWISE EXIT CASE
            END CASE
            IF NOT cl_null(g_shh.shh061) THEN #No.TQC-A50125
               CALL t721_shh061('d') 
            END IF                            #No.TQC-A50125
            
       RETURN l_n
END FUNCTION
#MOD-BC0012 end 
