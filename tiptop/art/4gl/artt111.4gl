# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artt111.4gl
# Descriptions...: 採購類型變更單
# Date & Author..: No:FUN-870007 08/12/08 By Zhangyajun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:TQC-A30041 10/03/15 By Cockroach ADD oriu/orig
# Modify.........: No:TQC-A40117 10/06/03 By Cockroach 單身無資料，單頭刪除
# Modify.........: No:FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No:FUN-A70130 10/08/18 By shiwuying q_smy改为q_oay
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.MOD-AC0173 10/12/18 By huangtao 修改單身輸入時候報錯提示
# Modify.........: No.TQC-A90080 11/01/07 By lilingyu 1.批量錄入功能鈕,下條件後資料未能整批產生到單身 2.採購中心錄入無效值,報錯信息不准確
# Modify.........: No:MOD-B20065 11/02/16 By baogc 增加狀況碼欄位(rym900)來標識是否為發出的資料，確認時更新狀況碼為已核准(1)，發出后更新狀況碼為已發出(2)
#                                                  增加發出按鈕用來更新變更的數據(當且僅當生效日期等於當前日期的時候才允許發出)
# Modify.........: No:FUN-B40050 11/04/18 By shiwuying 批量产生时原采购策略中如果不存在，变更类型改为2:新增；bug修改
# Modify.........: No:FUN-B40044 11/04/26 By shiwuying MISC*料号产品名称修改
# Modify.........: No:FUN-B50112 11/05/17 By shiwuying FUN-B40044 BUG修改
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60116 11/06/16 By huangtao 單身批量錄入的時候，料號要根據採購策略過濾
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:MOD-BA0168 11/10/21 By suncx 變更發出後，未更新arti110中採購中心欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rym         RECORD LIKE rym_file.*,
       g_rym_t       RECORD LIKE rym_file.*,
       g_rym_o       RECORD LIKE rym_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_ryn         DYNAMIC ARRAY OF RECORD
           ryn02          LIKE ryn_file.ryn02,   #變更類型
           ryn03          LIKE ryn_file.ryn03,   #變更機構
           ryn03_desc     LIKE azp_file.azp02,   #機構名
           ryn04          LIKE ryn_file.ryn04,   #商品編號
           ryn04_desc     LIKE ima_file.ima02,   #商品名稱
           ryn04_desc1    LIKE ima_file.ima131,  #產品分類
           ryn05          LIKE ryn_file.ryn05,   #採購類型
           ryn06          LIKE ryn_file.ryn06,   #配送中心
           ryn06_desc     LIKE geu_file.geu02,   #配送中心名稱
           ryn07          LIKE ryn_file.ryn07,   #主供應商
           ryn08          LIKE ryn_file.ryn08,   #經營方式
           ryn09          LIKE ryn_file.ryn09,   #可超交比率%
           ryn10          LIKE ryn_file.ryn10,   #安全庫存量
           ryn11          LIKE ryn_file.ryn11,   #再補貨點量
           ryn12          LIKE ryn_file.ryn12,   #採購多角流程代碼
           ryn13          LIKE ryn_file.ryn13,   #退貨多角流程代碼
           ryn15          LIKE ryn_file.ryn15,   #採購中心
           ryn15_desc     LIKE geu_file.geu02,   #採購中心名稱
           ryn14          LIKE ryn_file.ryn14    #有效否
                     END RECORD,
       g_ryn_t       RECORD
           ryn02          LIKE ryn_file.ryn02,   #變更類型
           ryn03          LIKE ryn_file.ryn03,   #變更機構
           ryn03_desc     LIKE azp_file.azp02,   #機構名
           ryn04          LIKE ryn_file.ryn04,   #商品編號
           ryn04_desc     LIKE ima_file.ima02,   #商品名稱
           ryn04_desc1    LIKE ima_file.ima131,  #產品分類
           ryn05          LIKE ryn_file.ryn05,   #採購類型
           ryn06          LIKE ryn_file.ryn06,   #配送中心
           ryn06_desc     LIKE geu_file.geu02,   #配送中心名稱
           ryn07          LIKE ryn_file.ryn07,   #主供應商
           ryn08          LIKE ryn_file.ryn08,   #經營方式
           ryn09          LIKE ryn_file.ryn09,   #可超交比率%
           ryn10          LIKE ryn_file.ryn10,   #安全庫存量
           ryn11          LIKE ryn_file.ryn11,   #再補貨點量
           ryn12          LIKE ryn_file.ryn12,   #採購多角流程代碼
           ryn13          LIKE ryn_file.ryn13,   #退貨多角流程代碼
           ryn15          LIKE ryn_file.ryn15,   #採購中心
           ryn15_desc     LIKE geu_file.geu02,   #採購中心名稱
           ryn14          LIKE ryn_file.ryn14    #有效否
                     END RECORD,
       g_ryn_o       RECORD 
           ryn02          LIKE ryn_file.ryn02,   #變更類型
           ryn03          LIKE ryn_file.ryn03,   #變更機構
           ryn03_desc     LIKE azp_file.azp02,   #機構名
           ryn04          LIKE ryn_file.ryn04,   #商品編號
           ryn04_desc     LIKE ima_file.ima02,   #商品名稱
           ryn04_desc1    LIKE ima_file.ima131,  #產品分類
           ryn05          LIKE ryn_file.ryn05,   #採購類型
           ryn06          LIKE ryn_file.ryn06,   #配送中心
           ryn06_desc     LIKE geu_file.geu02,   #配送中心名稱
           ryn07          LIKE ryn_file.ryn07,   #主供應商
           ryn08          LIKE ryn_file.ryn08,   #經營方式
           ryn09          LIKE ryn_file.ryn09,   #可超交比率%
           ryn10          LIKE ryn_file.ryn10,   #安全庫存量
           ryn11          LIKE ryn_file.ryn11,   #再補貨點量
           ryn12          LIKE ryn_file.ryn12,   #採購多角流程代碼
           ryn13          LIKE ryn_file.ryn13,   #退貨多角流程代碼
           ryn15          LIKE ryn_file.ryn15,   #採購中心
           ryn15_desc     LIKE geu_file.geu02,   #採購中心名稱
           ryn14          LIKE ryn_file.ryn14    #有效否
                     END RECORD
DEFINE g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_rtz04             LIKE rtz_file.rtz04
DEFINE g_author            LIKE type_file.chr1000
DEFINE l_err RECORD
          field LIKE type_file.chr1000,
          data  LIKE type_file.chr1000,
          msg   LIKE type_file.chr50,
          errcode LIKE type_file.chr7,
          n     LIKE type_file.num5
          END RECORD
          
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
 
   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rym_file WHERE rym01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t111_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t111_w AT p_row,p_col WITH FORM "art/42f/artt111"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT rtz04 INTO g_rtz04 FROM rtz_file
    WHERE rtz01 = g_plant
 
   CALL t111_menu()
   CLOSE WINDOW t111_w
 
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION t111_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_ryn.clear()
  
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rym.* TO NULL
   #  CONSTRUCT BY NAME g_wc ON rym01,rym02,rym03,rymconf,rymcond,        #MOD-B20065 MARK
      CONSTRUCT BY NAME g_wc ON rym01,rym02,rym03,rym900,rymconf,rymcond, #MOD-B20065 ADD
                                rymconu,rymplant,rymuser,
                                rymgrup,rymmodu,rymdate,rymcrat
                               ,rymoriu,rymorig      #TQC-A30041 ADD
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rym01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rym01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rym01
                  NEXT FIELD rym01
       
               WHEN INFIELD(rymconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rymconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rymconu                                                                              
                  NEXT FIELD rymconu
               WHEN INFIELD(rymplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rymplant
                 NEXT FIELD rymplant
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
 
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN
      #         LET g_wc = g_wc clipped," AND rymuser = '",g_user,"'"
      #      END IF
 
      #      IF g_priv3='4' THEN
      #         LET g_wc = g_wc clipped," AND rymgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN
      #         LET g_wc = g_wc clipped," AND rymgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rymuser', 'rymgrup')
      #End:FUN-980030
 
      CONSTRUCT g_wc2 ON ryn02,ryn03,ryn04,ryn05,ryn06,ryn07,ryn08,
                         ryn09,ryn10,ryn11,ryn12,ryn13,ryn14,ryn15   
              FROM s_ryn[1].ryn02,s_ryn[1].ryn03,s_ryn[1].ryn04,
                   s_ryn[1].ryn05,s_ryn[1].ryn06,s_ryn[1].ryn07,
                   s_ryn[1].ryn08,s_ryn[1].ryn09,s_ryn[1].ryn10,
                   s_ryn[1].ryn11,s_ryn[1].ryn12,s_ryn[1].ryn13,
                   s_ryn[1].ryn15,s_ryn[1].ryn14
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ryn03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn03
                  NEXT FIELD ryn03
               WHEN INFIELD(ryn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn04
                  NEXT FIELD ryn04
              WHEN INFIELD(ryn06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn06
                  NEXT FIELD ryn06
              WHEN INFIELD(ryn07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn07"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn07
                  NEXT FIELD ryn07
              WHEN INFIELD(ryn12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn12
                  NEXT FIELD ryn12
              WHEN INFIELD(ryn13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryn13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn13
                  NEXT FIELD ryn13
              WHEN INFIELD(ryn15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form="q_rvn15"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryn15
                  NEXT FIELD ryn15
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT rym01 FROM rym_file ",
                  " WHERE ", g_wc CLIPPED," AND rymplant IN ",g_auth,
                  " ORDER BY rym01"
   ELSE
      LET g_sql = "SELECT DISTINCT rym01 ",
                  "  FROM rym_file, ryn_file ",
                  " WHERE rym01 = ryn01 ",
                  "   AND rymplant = rynplant ",
                  "   AND rymplant IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rym01"
   END IF
 
   PREPARE t111_prepare FROM g_sql
   DECLARE t111_cs
       SCROLL CURSOR WITH HOLD FOR t111_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rym_file WHERE ",g_wc CLIPPED,
                " AND rymplant IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT rym01) FROM rym_file,ryn_file ",
                " WHERE ryn01=rym01 ",
                "   AND rynplant=rymplant ",
                "   AND rymplant IN ",g_auth," AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t111_precount FROM g_sql
   DECLARE t111_count CURSOR FOR t111_precount
 
END FUNCTION
 
FUNCTION t111_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t111_bp("G")
      CASE g_action_choice
        WHEN "confirm" #變更發出
            IF cl_chk_act_auth() THEN
                  CALL t111_y()
            END IF
#MOD-B20065 ADD-BEGIN---
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t111_z()
            END IF
                  
         WHEN "ch_issued" 
            IF cl_chk_act_auth() THEN
               CALL t111_ch() 
            END IF   
#MOD-B20065 ADD-END-----
        WHEN "add_input" #批量錄入
            IF cl_chk_act_auth() THEN
                  CALL t111_create_b('u')
                  CALL t111_b_fill(" 1=1")
                  CALL t111_bp_refresh()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t111_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t111_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t111_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t111_u()
            END IF
 
#         WHEN "reproduce"
#            IF cl_chk_act_auth() THEN
#                  CALL t111_copy()
#            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t111_b()
            END IF
 
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t111_out()
#            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ryn),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                    IF g_rym.rym01 IS NOT NULL THEN
                       LET g_doc.column1 = "rym01"
                       LET g_doc.column1 = "rymplant"
                       LET g_doc.value1 = g_rym.rym01
                       LET g_doc.value1 = g_rym.rymplant
                       CALL cl_doc()
                    END IF
              END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      LET g_action_choice = " "                              #MOD-AC0173  add
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ryn TO s_ryn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION add_input
         LET g_action_choice="add_input"
         EXIT DISPLAY
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
         CALL t111_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t111_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t111_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t111_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t111_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

#MOD-B20065 ADD-BEGIN---
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      
      ON ACTION ch_issued
         LET g_action_choice="ch_issued"
         EXIT DISPLAY
#MOD-B20065 ADD-END-----
 
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
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 

#MOD-B20065 MARK-BEGIN--#######################################################
#
#FUNCTION t111_y()
#DEFINE l_cnt      LIKE type_file.num5
#DEFINE l_gen02    LIKE gen_file.gen02 
#
#  IF g_rym.rym01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#
#  SELECT * INTO g_rym.* FROM rym_file 
#   WHERE rym01=g_rym.rym01
#   
#  IF g_rym.rymconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#
#  LET l_cnt=0
#  SELECT COUNT(*) INTO l_cnt
#    FROM ryn_file
#   WHERE ryn01=g_rym.rym01
#  IF l_cnt=0 OR l_cnt IS NULL THEN
#     CALL cl_err('','mfg-009',0)
#     RETURN
#  END IF
#
#  IF NOT cl_confirm('art-026') THEN RETURN END IF
#  
#  SELECT * FROM ryn_file WHERE 1=0 INTO TEMP ryn_temp
#  
#  SELECT chr1000 field,chr1000 data,chr50 msg,chr7 errcode,num5 n 
#    FROM type_file WHERE 1=0 INTO TEMP err_temp
#    
#  BEGIN WORK
#  OPEN t111_cl USING g_rym.rym01
#  
#  IF STATUS THEN
#     CALL cl_err("OPEN t111_cl:", STATUS, 1)
#     CLOSE t111_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  FETCH t111_cl INTO g_rym.*
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
#     CLOSE t111_cl ROLLBACK WORK RETURN
#  END IF
#  LET g_success = 'Y'
#  CALL s_showmsg_init()
#  CALL t111_trans()
#  IF g_success = 'N' THEN
#     CALL s_showmsg()
#     ROLLBACK WORK
#     DROP TABLE ryn_temp
#     DROP TABLE err_temp
#     RETURN
#  END IF
#  
#  UPDATE rym_file SET rymconf='Y',
#                      rymcond=g_today, 
#                      rymconu=g_user
#   WHERE rym01=g_rym.rym01
#
#  IF SQLCA.sqlerrd[3]=0 THEN
#     LET g_success='N'
#  END IF
#
#  IF g_success = 'Y' THEN
#     LET g_rym.rymconf='Y'
#     COMMIT WORK
#     CALL cl_flow_notify(g_rym.rym01,'Y')
#     SELECT * INTO g_rym.* FROM rym_file WHERE rym01=g_rym.rym01
#     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rym.rymconu
#     DISPLAY BY NAME g_rym.rymconf,g_rym.rymcond,g_rym.rymconu
#     DISPLAY l_gen02 TO FORMONLY.rymconu_desc
#     CALL cl_set_field_pic('Y',"","","","","")
#  ELSE
#     ROLLBACK WORK
#  END IF
#  DROP TABLE ryn_temp
#  DROP TABLE err_temp
#END FUNCTION
#
#MOD-B20065 MARK-END----#######################################################

#MOD-B20065 ADD-BEGIN---
##-確認-##
FUNCTION t111_y()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02

   IF g_rym.rym01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rym.* FROM rym_file
    WHERE rym01=g_rym.rym01

   IF g_rym.rymconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM ryn_file
    WHERE ryn01=g_rym.rym01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   IF NOT cl_confirm('art-026') THEN RETURN END IF

   BEGIN WORK
   OPEN t111_cl USING g_rym.rym01

   IF STATUS THEN
      CALL cl_err("OPEN t111_cl:", STATUS, 1)
      CLOSE t111_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t111_cl INTO g_rym.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
      CLOSE t111_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   CALL s_showmsg_init()
   UPDATE rym_file SET rymconf='Y',
                       rym900 = '1',
                       rymcond=g_today,
                       rymconu=g_user
    WHERE rym01=g_rym.rym01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rym_file",g_rym.rym01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_rym.rymconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rym.rym01,'Y')
      SELECT * INTO g_rym.* FROM rym_file WHERE rym01=g_rym.rym01
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rym.rymconu
      DISPLAY BY NAME g_rym.rymconf,g_rym.rymcond,g_rym.rymconu,g_rym.rym900
      DISPLAY l_gen02 TO FORMONLY.rymconu_desc
      CALL cl_set_field_pic('Y',"","","","","")
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#MOD-B20065 ADD-END----

#MOD-B20065 ADD-BEGIN--
##-取消確認-##
FUNCTION t111_z()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02

   IF g_rym.rym01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rym.* FROM rym_file
    WHERE rym01=g_rym.rym01

   IF g_rym.rym900 = '2' THEN CALL cl_err('','art-123',0) RETURN END IF
   IF g_rym.rymconf = 'N' THEN CALL cl_err('',9025,0) RETURN END IF
   IF g_rym.rymconf = 'X' THEN CALL cl_err(g_rym.rym01,'9024',0) RETURN END IF

   IF NOT cl_confirm('aco-729') THEN RETURN END IF

   BEGIN WORK
   OPEN t111_cl USING g_rym.rym01

   IF STATUS THEN
      CALL cl_err("OPEN t111_cl:", STATUS, 1)
      CLOSE t111_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t111_cl INTO g_rym.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
      CLOSE t111_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   UPDATE rym_file SET rymconf='N',
                       rym900 = '0',
                       rymcond='',
                       rymconu=''
    WHERE rym01=g_rym.rym01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rym_file",g_rym.rym01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_rym.rymconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_rym.rym01,'Y')
      SELECT * INTO g_rym.* FROM rym_file WHERE rym01=g_rym.rym01
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rym.rymconu
      DISPLAY BY NAME g_rym.rymconf,g_rym.rymcond,g_rym.rymconu,g_rym.rym900
      DISPLAY l_gen02 TO FORMONLY.rymconu_desc
      CALL cl_set_field_pic('N',"","","","","")
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#MOD-B20065 ADD-END----

#MOD-B20065 ADD-GEGIN--
##-變更發出-##
FUNCTION t111_ch()

   IF g_rym.rym01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_rym.* FROM rym_file
    WHERE rym01=g_rym.rym01
   IF g_rym.rym900 = '0' THEN CALL cl_err('','art-124',0) RETURN END IF
   IF g_rym.rym900 = '2' THEN CALL cl_err('','art-125',0) RETURN END IF

   IF NOT cl_confirm('alm-207') THEN RETURN END IF

   SELECT * FROM ryn_file WHERE 1=0 INTO TEMP ryn_temp

   SELECT chr1000 field,chr1000 data,chr50 msg,chr7 errcode,num5 n
     FROM type_file WHERE 1=0 INTO TEMP err_temp

   BEGIN WORK
   OPEN t111_cl USING g_rym.rym01

   IF STATUS THEN
      CALL cl_err("OPEN t111_cl:", STATUS, 1)
      CLOSE t111_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t111_cl INTO g_rym.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
      CLOSE t111_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   CALL s_showmsg_init()
   CALL t111_trans()

   UPDATE rym_file
      SET rym900 = '2'
    WHERE rym01=g_rym.rym01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rym_file",g_rym.rym01,"",SQLCA.sqlcode,"","",0)
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CALL s_showmsg()  #FUN-B40050 Add

   SELECT * INTO g_rym.* FROM rym_file WHERE rym01=g_rym.rym01
   DISPLAY BY NAME g_rym.rym900
   DROP TABLE ryn_temp
   DROP TABLE err_temp

END FUNCTION
#MOD-B20065 ADD-END----
 
FUNCTION t111_trans()
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_n LIKE type_file.num5
DEFINE l_rty01 LIKE rty_file.rty01
 
    DELETE FROM ryn_temp
    DELETE FROM err_temp
   
    INSERT INTO err_temp
    SELECT 'ryn04',ryn04,'','art-119',1
      FROM ryn_temp,ima_file
     WHERE ryn04=ima01
       AND ima913='Y'
       AND (ryn05='1' OR ryn05='3')
           
    SELECT COUNT(*) INTO l_n FROM ryn_file
     WHERE ryn03 = '*'
       AND ryn01 = g_rym.rym01
       AND rynplant = g_rym.rymplant
    IF l_n > 0 THEN              
       
       LET l_sql = "SELECT DISTINCT rty01 FROM rty_file"
       DECLARE rty01_cs CURSOR FROM l_sql
       FOREACH rty01_cs INTO l_rty01
         DELETE FROM ryn_temp
         INSERT INTO ryn_temp
         SELECT ryn_file.* FROM ryn_file
          WHERE ryn03 = '*'
            AND ryn01 = g_rym.rym01
            AND rynplant = g_rym.rymplant
         UPDATE ryn_temp SET ryn03 = l_rty01
         CALL t111_trans_s(l_rty01)
       END FOREACH
    END IF
    
    SELECT COUNT(*) INTO l_n FROM ryn_file
     WHERE ryn03 <> '*'
       AND ryn01 = g_rym.rym01
       AND rynplant = g_rym.rymplant
    IF l_n > 0 THEN
       DELETE FROM ryn_temp
       INSERT INTO ryn_temp
       SELECT ryn_file.* FROM ryn_file
        WHERE ryn03 <> '*'
          AND ryn01 = g_rym.rym01
          AND rynplant = g_rym.rymplant
       DECLARE ryn03_cs CURSOR FOR SELECT DISTINCT ryn03 FROM ryn_temp
       FOREACH ryn03_cs INTO l_rty01         
#更新但arti110机构不存在           
           INSERT INTO err_temp
           SELECT 'ryn03',ryn03,'','100',1 FROM ryn_temp
            WHERE NOT EXISTS (SELECT 1 FROM rty_file
                               WHERE rty01 = ryn03)
              AND ryn02 = '1'
           DELETE FROM ryn_temp
            WHERE NOT EXISTS (SELECT 1 FROM rty_file
                               WHERE rty01 = ryn03)
              AND ryn02 = '1'
           CALL t111_trans_s(l_rty01)           
       END FOREACH
    END IF
    SELECT COUNT(*) INTO l_n FROM err_temp
    IF l_n >0 THEN
       LET g_success = 'N'
       DECLARE err_cs CURSOR FOR SELECT * FROM err_temp
       FOREACH err_cs INTO l_err.*
          CALL s_errmsg(l_err.field,l_err.data,l_err.msg,l_err.errcode,l_err.n)
       END FOREACH
       DELETE FROM err_temp
    END IF
END FUNCTION
 
FUNCTION t111_trans_s(l_ryn03)
DEFINE l_sql STRING
DEFINE l_ryn03 LIKE ryn_file.ryn03
DEFINE l_ryn RECORD LIKE ryn_file.*
#新增
         INSERT INTO err_temp 
         SELECT 'ryn02,ryn03,ryn04',ryn02||'|'||ryn03||'|'||ryn04,'','-239',1
           FROM ryn_temp
          WHERE EXISTS (SELECT 1 FROM rty_file
                         WHERE rty01 = ryn03
                           AND rty02 = ryn04)
            AND ryn02 = '2'
            AND ryn03 = l_ryn03
         DELETE FROM ryn_temp
          WHERE EXISTS (SELECT 1 FROM rty_file
                         WHERE rty01 = ryn03
                           AND rty02 = ryn04)
            AND ryn02 = '2'
            AND ryn03 = l_ryn03
         INSERT INTO rty_file(rty01,rty02,rty03,rty04,rty05,rty06,
                              rty07,rty08,rty09,rty10,rty11,rty12,rtyacti)
         SELECT ryn03,ryn04,ryn05,ryn06,ryn07,ryn08,
                ryn09,ryn10,ryn11,ryn12,ryn13,ryn15,ryn14
           FROM ryn_temp
          WHERE ryn02 = '2'
            AND ryn03 = l_ryn03
#變更
         INSERT INTO err_temp 
         SELECT 'ryn02,ryn03,ryn04',ryn02||'|'||ryn03||'|'||ryn04,'','100',1
           FROM ryn_temp
          WHERE NOT EXISTS (SELECT 1 FROM rty_file
                             WHERE rty01 = ryn03
                               AND rty02 = ryn04)
            AND ryn02 = '1'
            AND ryn03 = l_ryn03
         DELETE FROM ryn_temp
          WHERE NOT EXISTS (SELECT 1 FROM rty_file
                             WHERE rty01 = ryn03
                               AND rty02 = ryn04)
            AND ryn02 = '1'
            AND ryn03 = l_ryn03
         DECLARE upd_cs CURSOR FOR SELECT * FROM ryn_temp WHERE ryn02='1' AND ryn03 = l_ryn03
         FOREACH upd_cs INTO l_ryn.*
             UPDATE rty_file
                SET rty03 = l_ryn.ryn05,
                    rty05 = l_ryn.ryn07,
                    rty06 = l_ryn.ryn08,
                    rty08 = l_ryn.ryn10,
                    rty09 = l_ryn.ryn11,
                    rty12 = l_ryn.ryn15,   #MOD-BA0168
                    rtyacti = l_ryn.ryn14
              WHERE rty01 = l_ryn.ryn03
                AND rty02 = l_ryn.ryn04
             IF l_ryn.ryn06 IS NOT NULL THEN
                UPDATE rty_file SET rty04 = l_ryn.ryn06
                 WHERE rty01 = l_ryn.ryn03
                   AND rty02 = l_ryn.ryn04
             END IF
             IF l_ryn.ryn09 IS NOT NULL THEN
                UPDATE rty_file SET rty07 = l_ryn.ryn09
                 WHERE rty01 = l_ryn.ryn03
                   AND rty02 = l_ryn.ryn04
             END IF
             IF l_ryn.ryn12 IS NOT NULL THEN
                UPDATE rty_file SET rty10 = l_ryn.ryn12
                 WHERE rty01 = l_ryn.ryn03
                   AND rty02 = l_ryn.ryn04
             END IF
             IF l_ryn.ryn13 IS NOT NULL THEN
                UPDATE rty_file SET rty11 = l_ryn.ryn13
                 WHERE rty01 = l_ryn.ryn03
                   AND rty02 = l_ryn.ryn04
             END IF
         END FOREACH
END FUNCTION
 
FUNCTION t111_bp_refresh()
  DISPLAY ARRAY g_ryn TO s_ryn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t111_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_ryn.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rym.* LIKE rym_file.*
 
   LET g_rym_t.* = g_rym.*
   LET g_rym_o.* = g_rym.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rym.rym900 = '0'
      LET g_rym.rymuser=g_user
      LET g_rym.rymoriu = g_user #FUN-980030
      LET g_rym.rymorig = g_grup #FUN-980030
      LET g_data_plant =  g_plant #TQC-A10128 ADD
      LET g_rym.rymgrup=g_grup
      LET g_rym.rymcrat = g_today
      LET g_rym.rymconf = 'N'
      LET g_rym.rym02 = g_today
      LET g_rym.rymplant = g_plant
     #SELECT azw01 INTO g_rym.rymlegal FROM azw_file
     # WHERE azw02 = g_plant
      SELECT azw02 INTO g_rym.rymlegal FROM azw_file   #TQC-A40117
       WHERE azw01 = g_plant
 
      CALL t111_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rym.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rym.rym01) OR cl_null(g_rym.rymplant) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_rym.rym01,g_rym.rym02,"","rym_file",      #FUN-A70130 mark                                                       
#                           "rym01","","","")                                 #FUN-A70130 mark                                               
      CALL s_auto_assign_no("art",g_rym.rym01,g_rym.rym02,"E6","rym_file",    #FUN-A70130 mod                                                        
                            "rym01","","","")                                 #FUN-A70130 mod                                               
                RETURNING li_result,g_rym.rym01
      IF (NOT li_result) THEN                                                                                                      
         CONTINUE WHILE                                                                                                           
      END IF                                                                                                                       
      DISPLAY BY NAME g_rym.rym01
      
      INSERT INTO rym_file VALUES (g_rym.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK          #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rym_file",g_rym.rym01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK           #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rym.rym01,'I')
      END IF
 
      LET g_rym_t.* = g_rym.*
      LET g_rym_o.* = g_rym.*
      CALL g_ryn.clear()
 
      CALL t111_create_b('a')
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         EXIT WHILE
      END IF
      CALL t111_b_fill(" 1=1")
      LET l_ac = g_rec_b   
      CALL t111_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t111_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rym.rym01 IS NULL OR g_rym.rymplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rym.* FROM rym_file
    WHERE rym01=g_rym.rym01 
 
   IF g_rym.rymconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t111_cl USING g_rym.rym01
 
   IF STATUS THEN
      CALL cl_err("OPEN t111_cl:", STATUS, 1)
      CLOSE t111_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t111_cl INTO g_rym.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
       CLOSE t111_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t111_show()
 
   WHILE TRUE
      LET g_rym_t.* = g_rym.*
      LET g_rym_o.* = g_rym.*
      LET g_rym.rymmodu=g_user
      LET g_rym.rymdate=g_today
 
      CALL t111_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rym.*=g_rym_t.*
         CALL t111_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rym.rym01 != g_rym_t.rym01 THEN
         UPDATE ryn_file SET ryn01 = g_rym.rym01
          WHERE ryn01 = g_rym_t.rym01
 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ryn_file",g_rym_t.rym01,"",SQLCA.sqlcode,"","ryn",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rym_file SET rym_file.* = g_rym.*
       WHERE rym01 = g_rym.rym01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rym_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t111_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rym.rym01,'U')
 
END FUNCTION
 
FUNCTION t111_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   l_azp02   LIKE azp_file.azp02,
   li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   DISPLAY BY NAME g_rym.rym02,g_rym.rymconf,g_rym.rymplant,
                   g_rym.rymmodu,g_rym.rymgrup,g_rym.rymuser,
                   g_rym.rymdate,g_rym.rymcrat
                  ,g_rym.rymoriu,g_rym.rymorig        #TQC-A30041 ADD
                  ,g_rym.rym900                       #MOD-B20065 ADD
 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rym.rymplant
   DISPLAY l_azp02 TO FORMONLY.rymplant_desc
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rym.rym01,g_rym.rym02,g_rym.rym03,g_rym.rymoriu,g_rym.rymorig
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t111_set_entry(p_cmd)
         CALL t111_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rym01")
 
      AFTER FIELD rym01
         IF NOT cl_null(g_rym.rym01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rym.rym01 != g_rym_t.rym01) THEN
#              CALL s_check_no("art",g_rym.rym01,g_rym_t.rym01,"Q","rym_file","rym01","") #FUN-A70130 mark                                             
               CALL s_check_no("art",g_rym.rym01,g_rym_t.rym01,"E6","rym_file","rym01","") #FUN-A70130 mod                                              
                    RETURNING li_result,g_rym.rym01                                                                                 
               IF (NOT li_result) THEN                                                                                              
                   LET g_rym.rym01=g_rym_t.rym01
                   DISPLAY BY NAME g_rym.rym01                                                                                        
                   NEXT FIELD rym01                                                                                                 
               END IF
            END IF
         END IF
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rym01)
               LET g_t1=s_get_doc_no(g_rym.rym01)
              #CALL q_smy(FALSE,FALSE,g_t1,'ART','Q') RETURNING g_t1  #No.FUN-A70130
               CALL q_oay(FALSE,FALSE,g_t1,'E6','ART') RETURNING g_t1 #No.FUN-A70130
               LET g_rym.rym01 = g_t1
               DISPLAY BY NAME g_rym.rym01
               NEXT FIELD rym01
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
 
FUNCTION t111_ryn03(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_n        LIKE type_file.num5
DEFINE l_ryn03_desc LIKE azp_file.azp02
 
       LET g_errno = ''
       SELECT azp02 INTO l_ryn03_desc FROM azp_file
           WHERE azp01 = g_ryn[l_ac].ryn03
       CASE
          WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-002'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
 
       IF cl_null(g_errno) OR p_cmd = 'd' THEN
          LET g_ryn[l_ac].ryn03_desc = l_ryn03_desc
          DISPLAY BY NAME g_ryn[l_ac].ryn03_desc
       END IF
END FUNCTION
 
FUNCTION t111_chk_in()
DEFINE l_rtz04    LIKE rtz_file.rtz04
DEFINE l_rte04    LIKE rte_file.rte04
DEFINE l_rte07    LIKE rte_file.rte07
 
   LET g_errno = ""
 
   SELECT rtz04 INTO l_rtz04 FROM rtz_file 
      WHERE rtz01 = g_ryn[l_ac].ryn03
#MOD-AC0173 --------------STA
   IF cl_null(l_rtz04) THEN
      RETURN 
   END IF
#MOD-AC0173 --------------END
   SELECT rte04,rte07 INTO l_rte04,l_rte07 FROM rte_file
       WHERE rte01 = l_rtz04
   IF SQLCA.SQLCODE = 100 THEN
      LET g_errno = 'art-054'
   END IF
   IF cl_null(g_errno) THEN
      IF l_rte07 = 'N' THEN LET g_errno = 'art-522' END IF
   END IF   
   IF cl_null(g_errno) THEN
      IF l_rte04 = 'N' THEN LET g_errno = 'art-523' END IF
   END IF
END FUNCTION
 
FUNCTION t111_ryn04(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_ima02 LIKE ima_file.ima02
DEFINE l_ima131 LIKE ima_file.ima131
 
   LET g_errno = " "
 
  #FUN-B40044 Begin---
   IF g_ryn[l_ac].ryn04[1,4] = 'MISC' THEN
      SELECT ima02,ima131,imaacti
        INTO l_ima02,l_ima131,l_imaacti
        FROM ima_file
       WHERE ima01 = 'MISC'
   ELSE
  #FUN-B40044 End-----
      SELECT ima02,ima131,imaacti
        INTO l_ima02,l_ima131,l_imaacti
        FROM ima_file 
       WHERE ima01 = g_ryn[l_ac].ryn04
   END IF  #FUN-B40044
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_ryn[l_ac].ryn04_desc = l_ima02
      LET g_ryn[l_ac].ryn04_desc1 = l_ima131
      DISPLAY BY NAME g_ryn[l_ac].ryn04_desc,g_ryn[l_ac].ryn04_desc1
   END IF
END FUNCTION
 
FUNCTION t111_ryn05()
DEFINE l_ima913 LIKE ima_file.ima913
DEFINE l_ima914 LIKE ima_file.ima914
  
   LET g_errno='' 
   IF NOT cl_null(g_ryn[l_ac].ryn04) THEN
      SELECT ima913,ima914 
        INTO l_ima913,l_ima914
        FROM ima_file
       WHERE ima01 = g_ryn[l_ac].ryn04
      IF l_ima913='Y' THEN
         IF g_ryn[l_ac].ryn05 MATCHES '[24]' THEN
            CALL cl_set_comp_entry("ryn15",FALSE)
            LET g_ryn[l_ac].ryn15=l_ima914
            CALL t111_ryn15('d',g_ryn[l_ac].ryn15)
         ELSE
            LET g_errno='art-119'
         END IF
      ELSE
         CALL cl_set_comp_entry("ryn15",TRUE)
      END IF
   END IF
END FUNCTION
 
FUNCTION t111_ryn06(p_cmd,p_ryn06)
DEFINE p_cmd LIKE type_file.chr1
DEFINE p_ryn06 LIKE ryn_file.ryn06
DEFINE l_geu02 LIKE geu_file.geu02
DEFINE l_geuacti LIKE geu_file.geuacti
 
    LET g_errno = ''
    SELECT geu02,geuacti INTO l_geu02,l_geuacti
      FROM geu_file
     WHERE geu01 = p_ryn06
       AND geu00 = '8'
    CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-188'
        WHEN l_geuacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF (cl_null(g_errno) AND p_cmd='a') OR p_cmd = 'd' THEN
      LET g_ryn[l_ac].ryn06_desc = l_geu02
      DISPLAY BY NAME g_ryn[l_ac].ryn06_desc
   END IF
END FUNCTION
 
FUNCTION t111_ryn15(p_cmd,p_ryn15)
DEFINE p_cmd LIKE type_file.chr1
DEFINE p_ryn15 LIKE ryn_file.ryn15
DEFINE l_geu02 LIKE geu_file.geu02
DEFINE l_geuacti LIKE geu_file.geuacti
 
    LET g_errno = ''
    SELECT geu02,geuacti INTO l_geu02,l_geuacti
      FROM geu_file
     WHERE geu01 = p_ryn15
       AND geu00 = '4'
    CASE WHEN SQLCA.SQLCODE = 100  
#                          LET g_errno = 'art-188'         #TQC-A90080
                           LET g_errno = 'art-122'         #TQC-A90080
        WHEN l_geuacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF (cl_null(g_errno) AND p_cmd='a') OR p_cmd = 'd' THEN
      LET g_ryn[l_ac].ryn15_desc = l_geu02
      DISPLAY BY NAME g_ryn[l_ac].ryn15_desc
   END IF
END FUNCTION
 
FUNCTION t111_ryn07(p_cmd,p_ryn07)
DEFINE p_cmd LIKE type_file.chr1
DEFINE p_ryn07 LIKE ryn_file.ryn07
DEFINE l_pmc03 LIKE pmc_file.pmc03
DEFINE l_pmcacti LIKE pmc_file.pmcacti
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_ryn08 LIKE ryn_file.ryn08
    
    LET g_errno = ''
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
      FROM pmc_file
     WHERE pmc01 = p_ryn07
    CASE
        WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-312'
        WHEN l_pmcacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) AND p_cmd<>'s' THEN
       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_ryn[l_ac].ryn03
       #LET g_sql =" SELECT DISTINCT rto06 FROM ",s_dbstring(l_dbs CLIPPED),"rtt_file,", #FUN-A50102
       #                                 s_dbstring(l_dbs CLIPPED),"rts_file,",           #FUN-A50102
       #                                 s_dbstring(l_dbs CLIPPED),"rto_file ",           #FUN-A50102
       LET g_sql =" SELECT DISTINCT rto06 FROM ",cl_get_target_table(g_ryn[l_ac].ryn03, 'rtt_file'),",", #FUN-A50102
                                        cl_get_target_table(g_ryn[l_ac].ryn03, 'rts_file'),",",           #FUN-A50102
                                        cl_get_target_table(g_ryn[l_ac].ryn03, 'rto_file'),           #FUN-A50102
                  " WHERE rtt04 = '",g_ryn[l_ac].ryn04,"' ",
                  "   AND rttplant = '",g_ryn[l_ac].ryn03,"' AND rtt15 = 'Y' ",
                  "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                  "   AND rto01 = rts04 AND rto03 = rts02  ",
                  "   AND rtsplant = '",g_ryn[l_ac].ryn03,"' ",
                  "   AND rtsconf = 'Y' AND rto05 = '",g_ryn[l_ac].ryn07,"' ", 
                  "   AND rtoconf ='Y' ",
                  "   AND rto08 <= '",g_today,"' ",
                  "   AND rto09 >= '",g_today,"' ",
                  "   AND rtoplant = '",g_ryn[l_ac].ryn03,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
       CALL cl_parse_qry_sql(g_sql, g_ryn[l_ac].ryn03) RETURNING g_sql  #FUN-A50102
       PREPARE rto06_cs FROM g_sql
       EXECUTE rto06_cs INTO l_ryn08
       IF l_ryn08 IS NULL THEN
          LET l_ryn08 = '1'
       END IF
    END IF
    IF (cl_null(g_errno) AND p_cmd='a') OR p_cmd = 'd' THEN
       LET g_ryn[l_ac].ryn08 = l_ryn08
       DISPLAY BY NAME g_ryn[l_ac].ryn08
    END IF
END FUNCTION
 
FUNCTION t111_chk_flowno(p_flowno)
DEFINE p_flowno LIKE poz_file.poz01
DEFINE l_poz20 LIKE poz_file.poz20
DEFINE l_n LIKE type_file.num5
 
   IF NOT cl_null(p_flowno) THEN
      SELECT poz20 INTO l_poz20
        FROM poz_file
       WHERE poz01 = p_rvnn08
         AND poz00 = '2'
         AND pozacti = 'Y'
      IF l_poz20 = 'Y' THEN
        SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 = 'xxx'
          AND poy02 = (SELECT MIN(poy02) FROM poy_file 
                                        WHERE poy01 = p_flowno)
       SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 = 'yyy'
          AND poy02 = (SELECT MAX(poy02) FROM poy_file 
                                        WHERE poy01 = p_flowno)
     ELSE
       SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 <> 'xxx'
          AND poy02 = (SELECT MIN(poy02) FROM poy_file 
                                        WHERE poy01 = p_flowno)
       SELECT COUNT(*) INTO l_n
         FROM poy_file
        WHERE poy48 <> 'yyy'
          AND poy02 = (SELECT MAX(poy02) FROM poy_file 
                                        WHERE poy01 = p_flowno)
     END IF
       IF l_n = 0 THEN
          LET g_errno = 'art-285'
       END IF
   END IF
END FUNCTION
 
FUNCTION t111_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ryn.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t111_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rym.* TO NULL
      RETURN
   END IF
 
   OPEN t111_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rym.* TO NULL
   ELSE
      OPEN t111_count
      FETCH t111_count INTO g_row_count
      IF g_row_count>0 THEN
         DISPLAY g_row_count TO FORMONLY.cnt
         CALL t111_fetch('F')
      ELSE 
         CALL cl_err('',100,0) 
         INITIALIZE g_rym.* TO NULL
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t111_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t111_cs INTO g_rym.rym01
      WHEN 'P' FETCH PREVIOUS t111_cs INTO g_rym.rym01
      WHEN 'F' FETCH FIRST    t111_cs INTO g_rym.rym01
      WHEN 'L' FETCH LAST     t111_cs INTO g_rym.rym01
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
               LET g_jump = g_curs_index
               EXIT CASE
            END IF
        END IF
        FETCH ABSOLUTE g_jump t111_cs INTO g_rym.rym01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
      INITIALIZE g_rym.* TO NULL
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
 
   SELECT * INTO g_rym.* FROM rym_file 
    WHERE rym01 = g_rym.rym01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rym_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rym.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rym.rymuser
   LET g_data_group = g_rym.rymgrup
   LET g_data_plant = g_rym.rymplant  #TQC-A10128 ADD
 
   CALL t111_show()
 
END FUNCTION
 
FUNCTION t111_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
 
   LET g_rym_t.* = g_rym.*
   LET g_rym_o.* = g_rym.*
   DISPLAY BY NAME g_rym.rym01,g_rym.rym02,g_rym.rym03, g_rym.rymoriu,g_rym.rymorig,
                   g_rym.rymconf,g_rym.rymcond,g_rym.rymconu,
                   g_rym.rymplant,g_rym.rymuser,g_rym.rymmodu,
                   g_rym.rymgrup,g_rym.rymdate,g_rym.rymcrat
   DISPLAY BY NAME g_rym.rym900               #MOD-B20065 ADD
 
   CASE g_rym.rymconf
        WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
        WHEN "N"
          CALL cl_set_field_pic("N","","","","","")
   END CASE                                                                    
   CALL cl_flow_notify(g_rym.rym01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rym.rymconu
   DISPLAY l_gen02 TO FORMONLY.rymconu_desc
   
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rym.rymplant
   DISPLAY l_azp02 TO FORMONLY.rymplant_desc
 
   CALL t111_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t111_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rym.rym01 IS NULL OR g_rym.rymplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rym.* FROM rym_file
    WHERE rym01=g_rym.rym01 
 
   IF g_rym.rymconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t111_cl USING g_rym.rym01
   IF STATUS THEN
      CALL cl_err("OPEN t111_cl:", STATUS, 1)
      CLOSE t111_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t111_cl INTO g_rym.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t111_show()
 
   IF cl_delh(0,0) THEN 
      DELETE FROM rym_file WHERE rym01 = g_rym.rym01
      DELETE FROM ryn_file WHERE ryn01 = g_rym.rym01
      CLEAR FORM
      CALL g_ryn.clear()
      OPEN t111_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t111_cs
         CLOSE t111_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t111_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t111_cs
         CLOSE t111_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      IF g_row_count > 0 THEN
      OPEN t111_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t111_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t111_fetch('/')
      END IF
      END IF
   END IF
 
   CLOSE t111_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rym.rym01,'D')
END FUNCTION
 
FUNCTION t111_b_init(p_cnt)
DEFINE p_cnt LIKE type_file.num5
    
    SELECT azp02 INTO g_ryn[p_cnt].ryn03_desc
      FROM azp_file
     WHERE azp01 = g_ryn[p_cnt].ryn03
    SELECT ima02,ima131 INTO g_ryn[p_cnt].ryn04_desc,g_ryn[p_cnt].ryn04_desc1
      FROM ima_file
     WHERE ima01 = g_ryn[p_cnt].ryn04
       AND imaacti = 'Y'
  #FUN-B40044 Begin---
   #FUN-B50112 Begin---
   #IF g_ryn[g_cnt].ryn04[1,4] = 'MISC' THEN
   #   SELECT ima02 INTO g_ryn[g_cnt].ryn04_desc FROM ima_file
    IF g_ryn[p_cnt].ryn04[1,4] = 'MISC' THEN
       SELECT ima02 INTO g_ryn[p_cnt].ryn04_desc FROM ima_file
   #FUN-B50112 End-----
        WHERE ima01 = 'MISC'
    END IF
  #FUN-B40044 End-----
    SELECT geu02 INTO g_ryn[p_cnt].ryn06_desc
      FROM geu_file
     WHERE geu01 = g_ryn[p_cnt].ryn06
       AND geu00='8'
       AND geuacti='Y'
    SELECT geu02 INTO g_ryn[p_cnt].ryn15_desc
      FROM geu_file
     WHERE geu01 = g_ryn[p_cnt].ryn15
       AND geu00='4'
       AND geuacti='Y'
    
END FUNCTION
 
FUNCTION t111_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE l_flowno LIKE ryn_file.ryn12
DEFINE l_rtz04 LIKE rtz_file.rtz04
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rym.rym01 IS NULL OR g_rym.rymplant IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rym.* FROM rym_file
     WHERE rym01=g_rym.rym01
    
    IF g_rym.rymconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    CALL t111_get_author()
    
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ryn02,ryn03,'',ryn04,'','',ryn05,ryn06,'',",
                       "ryn07,ryn08,ryn09,ryn10,ryn11,ryn12,ryn13,ryn15,'',ryn14 ",
                       "  FROM ryn_file ",
                       " WHERE ryn01=? AND ryn03=? ",
                       "   AND ryn04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ryn WITHOUT DEFAULTS FROM s_ryn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t111_cl USING g_rym.rym01
           IF STATUS THEN
              CALL cl_err("OPEN t111_cl:", STATUS, 1)
              CLOSE t111_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t111_cl INTO g_rym.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)
              CLOSE t111_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_ryn_t.* = g_ryn[l_ac].*  #BACKUP
              LET g_ryn_o.* = g_ryn[l_ac].*  #BACKUP
              OPEN t111_bcl USING g_rym.rym01,g_ryn_t.ryn03,g_ryn_t.ryn04
              IF STATUS THEN
                 CALL cl_err("OPEN t111_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t111_bcl INTO g_ryn[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ryn_t.ryn04,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t111_b_init(l_ac)
              END IF
          END IF 
           
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ryn[l_ac].* TO NULL
           LET g_ryn[l_ac].ryn02 = '1'
           LET g_ryn[l_ac].ryn14 = 'Y'
 
           LET g_ryn_t.* = g_ryn[l_ac].*
           LET g_ryn_o.* = g_ryn[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD ryn02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO ryn_file(ryn01,ryn02,ryn03,ryn04,ryn05,ryn06,ryn07,ryn08,
                                ryn09,ryn10,ryn11,ryn12,ryn13,ryn14,ryn15,rynplant,rynlegal)
           VALUES(g_rym.rym01,g_ryn[l_ac].ryn02,g_ryn[l_ac].ryn03,
                  g_ryn[l_ac].ryn04,g_ryn[l_ac].ryn05,g_ryn[l_ac].ryn06,
                  g_ryn[l_ac].ryn07,g_ryn[l_ac].ryn08,g_ryn[l_ac].ryn09,
                  g_ryn[l_ac].ryn10,g_ryn[l_ac].ryn11,g_ryn[l_ac].ryn12,
                  g_ryn[l_ac].ryn13,g_ryn[l_ac].ryn14,g_ryn[l_ac].ryn15,
                  g_rym.rymplant,g_rym.rymlegal)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","ryn_file",g_rym.rym01,g_ryn[l_ac].ryn04,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
      AFTER FIELD ryn03 #變更機構
         IF NOT cl_null(g_ryn[l_ac].ryn03) THEN
            IF g_ryn[l_ac].ryn03 <> '*' THEN
            IF g_ryn_o.ryn03 IS NULL OR
               (g_ryn[l_ac].ryn03 != g_ryn_o.ryn03 ) THEN
               CALL t111_ryn03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryn[l_ac].ryn03,g_errno,0)
                  LET g_ryn[l_ac].ryn03 = g_ryn_o.ryn03
                  DISPLAY BY NAME g_ryn[l_ac].ryn03
                  NEXT FIELD ryn03
               END IF
            END IF
            END IF
         END IF
#MOD-AC0173 -------------STA
      BEFORE FIELD ryn04 
          IF cl_null(g_ryn[l_ac].ryn03) THEN
             NEXT FIELD ryn03
          END IF
#MOD-AC0173 -------------END 
      AFTER FIELD ryn04 #商品編號
         IF NOT cl_null(g_ryn[l_ac].ryn04) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_ryn[l_ac].ryn04,g_ryn[l_ac].ryn03) THEN
               CALL cl_err('',g_errno,1)
               LET g_ryn[l_ac].ryn04= g_ryn_o.ryn04
               NEXT FIELD ryn04
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_ryn_o.ryn04 IS NULL OR
               (g_ryn[l_ac].ryn04 != g_ryn_o.ryn04 ) THEN 
               CALL t111_ryn04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryn[l_ac].ryn04,g_errno,0)
                  LET g_ryn[l_ac].ryn04 = g_ryn_o.ryn04
                  DISPLAY BY NAME g_ryn[l_ac].ryn04
                  NEXT FIELD ryn04
               END IF
               #檢查該商品是否是商品策略範圍內的商品
               CALL t111_chk_in()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryn[l_ac].ryn04,g_errno,0)       
                  NEXT FIELD ryn04
               END IF
            END IF  
         END IF  
 
      AFTER FIELD ryn05 #採購類型
         IF NOT cl_null(g_ryn[l_ac].ryn05) THEN 
            CALL t111_ryn05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ryn05
            END IF
         END IF
 
        AFTER FIELD ryn06
          IF NOT cl_null(g_ryn[l_ac].ryn06) THEN
             IF p_cmd ='a' OR (p_cmd = 'u' AND g_ryn[l_ac].ryn06<>g_ryn_o.ryn06 OR cl_null(g_ryn_o.ryn06)) THEN
                CALL t111_ryn06('a',g_ryn[l_ac].ryn06)
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryn[l_ac].ryn06,g_errno,0)
                  LET g_ryn[l_ac].ryn06 = g_ryn_o.ryn06
                  DISPLAY BY NAME g_ryn[l_ac].ryn06
                  NEXT FIELD ryn06
                END IF
             END IF
           END IF
           
        AFTER FIELD ryn07 #主供商
          IF NOT cl_null(g_ryn[l_ac].ryn07) THEN
             IF p_cmd ='a' OR (p_cmd = 'u' AND g_ryn[l_ac].ryn07<>g_ryn_o.ryn07) THEN
                CALL t111_ryn07('a',g_ryn[l_ac].ryn07)
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryn[l_ac].ryn07,g_errno,0)
                  LET g_ryn[l_ac].ryn07 = g_ryn_o.ryn07
                  DISPLAY BY NAME g_ryn[l_ac].ryn07
                  NEXT FIELD ryn07
                END IF
             END IF
           END IF
           
        AFTER FIELD ryn09,ryn10,ryn11
          IF FGL_DIALOG_GETBUFFER()<0 THEN
             CALL cl_err('','aic-005',0)
             NEXT FIELD CURRENT
          END IF
           
        AFTER FIELD ryn12,ryn13
          LET l_flowno = FGL_DIALOG_GETBUFFER()
          IF NOT cl_null(l_flowno) THEN
             CALL t111_chk_flowno(l_flowno)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
             END IF
          END IF
        
        AFTER FIELD ryn15   #採購中心
           IF NOT cl_null(g_ryn[l_ac].ryn15) THEN
             IF p_cmd ='a' OR (p_cmd = 'u' AND g_ryn[l_ac].ryn15<>g_ryn_o.ryn15) THEN
                CALL t111_ryn15('a',g_ryn[l_ac].ryn15)
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ryn[l_ac].ryn15,g_errno,0)
                  LET g_ryn[l_ac].ryn15 = g_ryn_o.ryn15
                  DISPLAY BY NAME g_ryn[l_ac].ryn15
                  NEXT FIELD ryn15
                END IF
             END IF
           END IF
 
        BEFORE DELETE
           IF g_ryn_t.ryn03 IS NOT NULL AND 
              g_ryn_t.ryn04 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ryn_file
               WHERE ryn01 = g_rym.rym01
                 AND ryn03 = g_ryn_t.ryn03
                 AND ryn04 = g_ryn_t.ryn04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ryn_file",g_rym.rym01,g_ryn_t.ryn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_ryn[l_ac].* = g_ryn_t.*
              CLOSE t111_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ryn[l_ac].ryn02,-263,1)
              LET g_ryn[l_ac].* = g_ryn_t.*
           ELSE
              UPDATE ryn_file SET ryn02=g_ryn[l_ac].ryn02,
                                  ryn03=g_ryn[l_ac].ryn03,
                                  ryn04=g_ryn[l_ac].ryn04,
                                  ryn05=g_ryn[l_ac].ryn05,
                                  ryn06=g_ryn[l_ac].ryn06,
                                  ryn07=g_ryn[l_ac].ryn07,
                                  ryn08=g_ryn[l_ac].ryn08,
                                  ryn09=g_ryn[l_ac].ryn09,
                                  ryn10=g_ryn[l_ac].ryn10,
                                  ryn11=g_ryn[l_ac].ryn11,
                                  ryn12=g_ryn[l_ac].ryn12,
                                  ryn13=g_ryn[l_ac].ryn13,
                                  ryn14=g_ryn[l_ac].ryn14,
                                  ryn15=g_ryn[l_ac].ryn15
               WHERE ryn01=g_rym.rym01
                 AND ryn03=g_ryn_t.ryn03
                 AND ryn04=g_ryn_t.ryn04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ryn_file",g_rym.rym01,g_ryn_t.ryn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_ryn[l_ac].* = g_ryn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ryn[l_ac].* = g_ryn_t.*
              END IF
              CLOSE t111_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t111_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(ryn02) AND l_ac > 1 THEN
              LET g_ryn[l_ac].* = g_ryn[l_ac-1].*
              LET g_ryn[l_ac].ryn02 = g_rec_b + 1
              NEXT FIELD ryn02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ryn04)   #商品
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                IF g_rtz04 IS NULL THEN
#                   LET g_qryparam.form = "q_ima"
#                ELSE
#                   LET g_qryparam.form ="q_ruf01_1"
#                   SELECT rtz04 INTO l_rtz04 FROM rtz_file
#                     WHERE rtz01 = g_ryn[l_ac].ryn03
#                   LET g_qryparam.arg1 = l_rtz04
#                END IF
#                 LET g_qryparam.default1 = g_ryn[l_ac].ryn04
#                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn04
                  CALL q_sel_ima(FALSE, "q_ima","",g_ryn[l_ac].ryn04,"","","","","",g_ryn[l_ac].ryn03 ) #FUN-AA0059 add 
                    RETURNING  g_ryn[l_ac].ryn04                                         #FUN-AA0059 add
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_ryn[l_ac].ryn04
                 CALL t111_ryn04('d')
                 NEXT FIELD ryn04                 
             WHEN INFIELD(ryn03)  #變更機構
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = g_ryn[l_ac].ryn03
                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn03
                 DISPLAY BY NAME g_ryn[l_ac].ryn03
                 CALL t111_ryn03('d')
                 NEXT FIELD ryn03
             WHEN INFIELD(ryn06)  #配送中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.arg1='8'
                 LET g_qryparam.default1 = g_ryn[l_ac].ryn06
                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn06
                 DISPLAY BY NAME g_ryn[l_ac].ryn06
                 CALL t111_ryn06('d',g_ryn[l_ac].ryn06)
                 NEXT FIELD ryn06
             WHEN INFIELD(ryn07)  #主供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc2"
                 LET g_qryparam.default1 = g_ryn[l_ac].ryn07
                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn07
                 DISPLAY BY NAME g_ryn[l_ac].ryn07
                 CALL t111_ryn07('d',g_ryn[l_ac].ryn07)
                 NEXT FIELD ryn07
             WHEN INFIELD(ryn12)  #採購多角貿易流程代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz01"
                 LET g_qryparam.default1 = g_ryn[l_ac].ryn12
                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn12
                 DISPLAY BY NAME g_ryn[l_ac].ryn12
                 NEXT FIELD ryn12
             WHEN INFIELD(ryn13)  #退貨多角貿易流程代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz01"
                 LET g_qryparam.default1 = g_ryn[l_ac].ryn13
                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn13
                 DISPLAY BY NAME g_ryn[l_ac].ryn13
                 NEXT FIELD ryn13
             WHEN INFIELD(ryn15)  #採購中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.default1 = g_ryn[l_ac].ryn15
                 CALL cl_create_qry() RETURNING g_ryn[l_ac].ryn15
                 DISPLAY BY NAME g_ryn[l_ac].ryn15
                 CALL t111_ryn15('d',g_ryn[l_ac].ryn15)
                 NEXT FIELD ryn15
              OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
 
    UPDATE rym_file SET rymmodu = g_rym.rymmodu,rymdate = g_rym.rymdate
       WHERE rym01 = g_rym.rym01 AND rymplant = g_rym.rymplant
     
    DISPLAY BY NAME g_rym.rymmodu,g_rym.rymdate
 
    CLOSE t111_bcl
    COMMIT WORK
    CALL t111_delall()
    CALL t111_show()   #TQC-A40117
 
END FUNCTION
 
FUNCTION t111_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM ryn_file
    WHERE ryn01 = g_rym.rym01 AND rynplant = g_rym.rymplant
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rym_file WHERE rym01 = g_rym.rym01 
          AND rymplant = g_rym.rymplant
      CLEAR FORM
   END IF
END FUNCTION
 
FUNCTION t111_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT ryn02,ryn03,'',ryn04,'','',ryn05,ryn06,'',",
               "       ryn07,ryn08,ryn09,ryn10,ryn11,ryn12,ryn13,ryn15,'',ryn14",
               "  FROM ryn_file",
               " WHERE ryn01 ='",g_rym.rym01,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ryn03 "
 
   DISPLAY g_sql
 
   PREPARE t111_pb FROM g_sql
   DECLARE ryn_cs CURSOR FOR t111_pb
 
   CALL g_ryn.clear()
   LET g_cnt = 1
 
   FOREACH ryn_cs INTO g_ryn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t111_b_init(g_cnt)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ryn.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t111_copy()
   DEFINE l_newno     LIKE rym_file.rym01,
          l_oldno     LIKE rym_file.rym01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rym.rym01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t111_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rym01
       AFTER FIELD rym01
          IF l_newno IS NULL THEN
             NEXT FIELD rym01
          ELSE
#         	 CALL s_check_no("art",l_newno,"","Q","rym_file","rym01","") #FUN-A70130 mark
          	 CALL s_check_no("art",l_newno,"","E6","rym_file","rym01","") #FUN-A70130 mod
          	    RETURNING li_result,l_newno
          	 IF (NOT li_result) THEN
          	    LET g_rym.rym01=g_rym_t.rym01 
          	    NEXT FIELD rym01
          	 END IF         	 
          END IF
          
      ON ACTION controlp
         CASE
             WHEN INFIELD(rym01)
                LET g_t1=s_get_doc_no(l_newno)
               #CALL q_smy(FALSE,FALSE,g_t1,'ART','Q') RETURNING g_t1  #No.FUN-A70130
                CALL q_oay(FALSE,FALSE,g_t1,'E6','ART') RETURNING g_t1 #No.FUN-A70130
                LET l_newno = g_t1
                DISPLAY l_newno TO rym01
                NEXT FIELD rym01
         END CASE
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
      DISPLAY BY NAME g_rym.rym01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rym_file
    WHERE rym01 = g_rym.rym01
     INTO TEMP y 
   
#  CALL s_auto_assign_no("art",l_newno,g_today,"","rym_file","rym01","","","") #FUN-A70130 mark
   CALL s_auto_assign_no("art",l_newno,g_today,"E6","rym_file","rym01","","","") #FUN-A70130 mod
       RETURNING li_result,l_newno
   IF (NOT li_result) THEN
       CALL cl_err('','sub-145',0)
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE y
       SET rym01=l_newno,
           rymconf = 'N',
           rymcont = NULL,
           rymcond = NULL,
           rymconu = NULL,
           rymuser=g_user,
           rymgrup=g_grup,
           rymmodu=NULL,
           rymcrat=g_today
 
   INSERT INTO rym_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rym_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ryn_file
    WHERE ryn01=g_rym.rym01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET ryn01=l_newno
 
   INSERT INTO ryn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK         #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","ryn_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK          #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
   
   DROP TABLE x
   DROP TABLE y
   
   LET l_oldno = g_rym.rym01
   SELECT rym_file.* INTO g_rym.* 
     FROM rym_file
    WHERE rym01 = l_newno
   CALL t111_u()
   CALL t111_b()
   SELECT rym_file.* INTO g_rym.* 
     FROM rym_file
    WHERE rym01 = l_oldno
   CALL t111_show()
 
END FUNCTION
 
FUNCTION t111_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rym01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t111_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rym01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t111_get_author()
DEFINE l_azw01 LIKE azw_file.azw01
 
   LET g_sql = "SELECT azw01 FROM azw_file WHERE azw07 = '",g_rym.rymplant,"'",
                "   AND azwacti = 'Y' "
    PREPARE pre_azw FROM g_sql
    DECLARE cur1_azw CURSOR FOR pre_azw
    LET g_author = " ('"
    FOREACH cur1_azw INTO l_azw01
       IF l_azw01 IS NULL THEN CONTINUE FOREACH END IF
       LET g_author = g_author,l_azw01,"','"
    END FOREACH
    LET g_author = g_author[1,LENGTH(g_author)-2]
    IF LENGTH(g_author) != 0 THEN
       LET g_author = g_author,") "
    END IF
END FUNCTION
 
FUNCTION t111_create_b(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_ryn RECORD LIKE ryn_file.*
DEFINE l_n,l_cnt LIKE type_file.num5
DEFINE l_wc,l_wc_t STRING
DEFINE l_tok base.StringTokenizer
DEFINE l_buf STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rtz04 LIKE rtz_file.rtz04
DEFINE l_str STRING
DEFINE l_flowno LIKE poz_file.poz01
DEFINE l_azw01  LIKE azw_file.azw01                   #TQC-B60116 add
          
    IF cl_null(g_rym.rym01) THEN
       RETURN
    END IF
    BEGIN WORK
    IF p_cmd = 'u' THEN
       OPEN t111_cl USING g_rym.rym01
       IF STATUS THEN
          CALL cl_err("OPEN t111_cl:", STATUS, 1)
          CLOSE t111_cl
          RETURN
       END IF
 
       FETCH t111_cl INTO g_rym.*                      
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_rym.rym01,SQLCA.sqlcode,0)    
          CLOSE t111_cl
          RETURN
       END IF
       IF g_rym.rymconf <> 'N' THEN
          CALL cl_err(g_rym.rym01,'9022',0)
          RETURN
       END IF
    END IF
    LET INT_FLAG = 0
    LET p_row = 2 LET p_col = 21
    OPEN WINDOW t111a AT p_row,p_col WITH FORM "art/42f/artt111a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt111a")
 
    CALL t111_get_author()
    
    CONSTRUCT BY NAME l_wc_t ON ima01,ima131,ryn03
       BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
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
          
      ON ACTION controlp
           CASE
              WHEN INFIELD(ima01)     #商品
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                  LET g_qryparam.state ="c"
#                  IF g_rtz04 IS NULL THEN
#                     LET g_qryparam.form = "q_ima"
#                  ELSE
#                    CALL cl_init_qry_var()
#                    SELECT rtz04 INTO l_rtz04 FROM rtz_file
#                      WHERE rtz01 = g_rym.rymplant
#                    LET g_qryparam.state ="c"
#                    LET g_qryparam.arg1 = l_rtz04
#                    LET g_qryparam.form ="q_ruf01_1"
#                  END IF
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",g_rym.rymplant) #FUN-AA0059 add 
                      RETURNING  g_qryparam.multiret                      #FUN-AA0059 add 
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
              WHEN INFIELD(ryn03)     #變更機構
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
#TQC-B60116 ------------STA
#                  LET g_qryparam.form ="q_azp"
                   LET g_qryparam.form = "q_azw01_1"
                   LET g_qryparam.where = " azw01 IN ",g_auth
#TQC-B60116 ------------END
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ryn03
                   NEXT FIELD ryn03
              WHEN INFIELD(ima131)    #產品分類
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ima131_1"   
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
              OTHERWISE EXIT CASE
           END CASE           
     AFTER CONSTRUCT
       IF INT_FLAG THEN
          EXIT CONSTRUCT
       END IF
       IF cl_null(GET_FLDBUF(ima01)) AND cl_null(GET_FLDBUF(ima131)) THEN          
          CALL cl_err('','art-557',0)
          CONTINUE CONSTRUCT
       END IF
       IF cl_null(GET_FLDBUF(ryn03)) THEN
          NEXT FIELD ryn03
          CONTINUE CONSTRUCT
       ELSE
          LET l_buf = GET_FLDBUF(ryn03)
       END IF
   END CONSTRUCT
 
   IF INT_FLAG THEN
      CLOSE WINDOW t111a
      RETURN
   END IF
   
   LET l_ryn.ryn02 = '1'
   LET l_ryn.ryn14 = 'Y'
   INPUT BY NAME l_ryn.ryn02,l_ryn.ryn05,l_ryn.ryn06,l_ryn.ryn15,l_ryn.ryn07,
                 l_ryn.ryn09,l_ryn.ryn12,l_ryn.ryn13,l_ryn.ryn14
    WITHOUT DEFAULTS
    
       AFTER FIELD ryn06
          IF NOT cl_null(l_ryn.ryn06) THEN
             CALL t111_ryn06('s',l_ryn.ryn06)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_ryn.ryn06,g_errno,0)
                NEXT FIELD ryn06
             END IF
           END IF
           
        AFTER FIELD ryn07 #主供應商
          IF NOT cl_null(l_ryn.ryn07) THEN
             CALL t111_ryn07('s',l_ryn.ryn07)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_ryn.ryn07,g_errno,0)
                NEXT FIELD ryn07
             END IF
           END IF
           
        AFTER FIELD ryn09
          IF FGL_DIALOG_GETBUFFER()<0 THEN
             CALL cl_err('','aic-005',0)
             NEXT FIELD CURRENT
          END IF
           
        AFTER FIELD ryn12,ryn13
          LET l_flowno = FGL_DIALOG_GETBUFFER()
          IF NOT cl_null(l_flowno) THEN
             CALL t111_chk_flowno(l_flowno)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
             END IF
          END IF
 
       AFTER FIELD ryn15
         IF NOT cl_null(l_ryn.ryn15) THEN
            CALL t111_ryn15('s',l_ryn.ryn15)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_ryn.ryn15,g_errno,0)
               NEXT FIELD ryn15
            END IF
         END IF         
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(ryn06)  #配送中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.arg1='8'
                 CALL cl_create_qry() RETURNING l_ryn.ryn06
                 DISPLAY BY NAME l_ryn.ryn06
                 NEXT FIELD ryn06
             WHEN INFIELD(ryn07)  #主供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc2"
                 CALL cl_create_qry() RETURNING l_ryn.ryn07
                 DISPLAY BY NAME l_ryn.ryn07
                 NEXT FIELD ryn07
             WHEN INFIELD(ryn12)  #採購多角貿易流程代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz01"
                 CALL cl_create_qry() RETURNING l_ryn.ryn12
                 DISPLAY BY NAME l_ryn.ryn12
                 NEXT FIELD ryn12
             WHEN INFIELD(ryn13)  #退貨多角貿易流程代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_poz01"
                 CALL cl_create_qry() RETURNING l_ryn.ryn13
                 DISPLAY BY NAME l_ryn.ryn13
                 NEXT FIELD ryn13
             WHEN INFIELD(ryn15) #採購中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_geu"
                 LET g_qryparam.arg1='4'
                 CALL cl_create_qry() RETURNING l_ryn.ryn15
                 DISPLAY BY NAME l_ryn.ryn15 
                 NEXT FIELD ryn15
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
       CLOSE WINDOW t111a
       RETURN
   END IF
 
   LET l_cnt = l_wc_t.getIndexOf('ryn03',1)
   LET l_wc = l_wc_t.substring(1,l_cnt-5)
   SELECT * FROM ryn_file WHERE 1=0 INTO TEMP ryn_temp
   SELECT chr1000 field,chr1000 data,chr50 msg,chr7 errcode,num5 n 
     FROM type_file WHERE 1=0 INTO TEMP err_temp
     
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   IF l_buf = '*' THEN
#TQC-B60116 --------------STA
#     LET g_sql = "INSERT INTO ryn_temp(ryn01,ryn02,ryn03,ryn08,ryn04,rynplant,rynlegal) ",  #FUN-A90063 add plant/legal
#                   "SELECT '",g_rym.rym01,"','",l_ryn.ryn02,"','*','1',ima01",",'",g_plant,"','",g_legal,"'",  #FUN-A90063
#                   "  FROM ima_file",
#                   " WHERE ",l_wc CLIPPED
#                  ,"   AND (ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') "  #FUN-B40050
#     EXECUTE IMMEDIATE g_sql
      LET g_sql = " SELECT azw01 FROM azw_file",
                  "  WHERE azw01 IN ",g_auth,
                  "    AND azwacti = 'Y'"
      PREPARE sel_azw01 FROM g_sql
      DECLARE sel_azw01_cs CURSOR FOR sel_azw01
      FOREACH sel_azw01_cs INTO l_azw01
         IF l_buf = '*' THEN
            LET l_buf ="'",l_azw01,"'"
         ELSE
            LET l_buf = l_buf,"|'",l_azw01,"'"
         END IF
      END FOREACH
#  ELSE
   END IF 
#TQC-B60116 --------------END
      LET l_tok = base.StringTokenizer.create(l_buf,"|")
      WHILE l_tok.hasMoreTokens()
        LET l_ryn.ryn03 = l_tok.nextToken()     
#MOD-AC0173 ------------------STA
        SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01= l_ryn.ryn03
#       IF g_rtz04 IS NULL THEN
        IF cl_null(l_rtz04) THEN
#MOD-AC0173 ------------------END
           LET g_sql = "INSERT INTO ryn_temp(ryn01,ryn02,ryn03,ryn04,rynplant,rynlegal) ",  #FUN-A90063 add plant/legal
                    "SELECT '",g_rym.rym01,"','",l_ryn.ryn02,"','",l_ryn.ryn03,"',ima01", ",'",g_plant,"','",g_legal,"'",  #FUN-A90063
                    "  FROM ima_file",
                    " WHERE ",l_wc CLIPPED
                   ,"   AND (ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') <> '2' "  #FUN-B40050
#TQC-B60116 --------------STA
           IF l_ryn.ryn02 = '1' THEN
               LET g_sql =  g_sql," AND ima01 IN (SELECT rty02 FROM rty_file WHERE rty01= '",l_ryn.ryn03,"')"
           ELSE
               LET g_sql =  g_sql," AND ima01 NOT IN (SELECT rty02 FROM rty_file WHERE rty01= '",l_ryn.ryn03,"')"
           END IF
#TQC-B60116 --------------END
           EXECUTE IMMEDIATE g_sql
        ELSE
           SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_ryn.ryn03
           SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = l_ryn.ryn03
           LET g_sql = "INSERT INTO ryn_temp(ryn01,ryn02,ryn03,ryn04,rynplant,rynlegal) ",  #FUN-A90063 add plant/legal
                    "SELECT '",g_rym.rym01,"','",l_ryn.ryn02,"','",l_ryn.ryn03,"',ima01", ",'",g_plant,"','",g_legal,"'",  #FUN-A90063
                    "  FROM ima_file,rte_file",
                    " WHERE ",l_wc CLIPPED,
                    "   AND ima01 = rte03 ",
                    "   AND rte01 = '",l_rtz04,"'",
                    "   AND rte04 = 'Y'",
                    "   AND rte07 = 'Y'"
                   ,"   AND (ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') "  #FUN-B40050
#TQC-B60116 --------------STA
           IF l_ryn.ryn02 = '1' THEN
               LET g_sql =  g_sql," AND ima01 IN (SELECT rty02 FROM rty_file WHERE rty01= '",l_ryn.ryn03,"')"
           ELSE
               LET g_sql =  g_sql," AND ima01 NOT IN (SELECT rty02 FROM rty_file WHERE rty01= '",l_ryn.ryn03,"')"
           END IF
#TQC-B60116 --------------END
           EXECUTE IMMEDIATE g_sql      
        END IF
        LET g_sql = "UPDATE ryn_temp a ",
                    "   SET ryn08 = (SELECT DISTINCT rto06 FROM ",
                    #                    s_dbstring(l_dbs CLIPPED),"rtt_file,",  #FUN-A50102
                    #                    s_dbstring(l_dbs CLIPPED),"rts_file,",  #FUN-A50102
                    #                    s_dbstring(l_dbs CLIPPED),"rto_file ",  #FUN-A50102
                                        cl_get_target_table(l_ryn.ryn03, 'rtt_file'),",",  #FUN-A50102
                                        cl_get_target_table(l_ryn.ryn03, 'rts_file'),",",  #FUN-A50102
                                        cl_get_target_table(l_ryn.ryn03, 'rto_file'),      #FUN-A50102
                    "                 WHERE rtt04 = a.ryn04",
                    "                   AND rttplant = '",l_ryn.ryn03,"'",
                    "                   AND rtt15 = 'Y' ",
                    "                   AND rts01 = rtt01 AND rts02 = rtt02  ",
                    "                   AND rto01 = rts04 AND rto03 = rts02  ",
                    "                   AND rtsplant = '",l_ryn.ryn03,"' ",
                    "                   AND rtsconf = 'Y' AND rto05 = '",l_ryn.ryn07,"' ", 
                    "                   AND rtoconf ='Y' ",
                    "                   AND rto08 <= '",g_today,"' ",
                    "                   AND rto09 >= '",g_today,"' ",
                    "                   AND rtoplant = '",l_ryn.ryn03,"')",
                    " WHERE ryn08 IS NULL"
#TQC-B60116 ----------------STA
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
        CALL cl_parse_qry_sql(g_sql,l_ryn.ryn03) RETURNING g_sql
#TQC-B60116 ----------------END
        EXECUTE IMMEDIATE g_sql
        UPDATE ryn_temp SET ryn08 = '1' WHERE ryn08 IS NULL
       #FUN-B40050 Begin---
        LET g_sql = "UPDATE ryn_temp a SET ryn02='2' ",
                    " WHERE ryn02 = '1' ",
                    "   AND ryn03 = '",l_ryn.ryn03,"' ",
                    "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_ryn.ryn03,'rty_file'),
                    "                WHERE rty01 = a.ryn03 ",
                    "                  AND rty02 = a.ryn04 ",
                    "                  AND rty01 IS NOT NULL) "
#TQC-B60116 ----------------STA
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,l_ryn.ryn03) RETURNING g_sql
#TQC-B60116 ----------------END
        PREPARE t111_upd_ryn02 FROM g_sql
        EXECUTE t111_upd_ryn02
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('ryn02','','UPDATE ryn_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
       #FUN-B40050 End-----
                    
      END WHILE
#  END IF                               #TQC-B60116  mark
   UPDATE ryn_temp SET ryn05 = l_ryn.ryn05,
                       ryn06 = l_ryn.ryn06,
                       ryn07 = l_ryn.ryn07,
                       ryn09 = l_ryn.ryn09,
                       ryn12 = l_ryn.ryn12,
                       ryn13 = l_ryn.ryn13,
                       ryn14 = l_ryn.ryn14,
                       ryn15 = l_ryn.ryn15,
                       rynplant = g_rym.rymplant,
                       rynlegal = g_rym.rymlegal
   LET g_sql = "DELETE FROM ryn_temp a ",
               " WHERE EXISTS (SELECT 1 FROM ryn_file ",
               "                WHERE ryn03 = a.ryn03",
               "                  AND ryn04 = a.ryn04",
               "                  AND ryn01 = '",g_rym.rym01,"'",
               "                  AND rynplant = '",g_rym.rymplant,"')"
   EXECUTE IMMEDIATE g_sql
   INSERT INTO ryn_file SELECT * FROM ryn_temp
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rym01',g_rym.rym01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   DROP TABLE ryn_temp
   DROP TABLE err_temp
   CLOSE WINDOW t111a
END FUNCTION
#FUN-870007--end--
