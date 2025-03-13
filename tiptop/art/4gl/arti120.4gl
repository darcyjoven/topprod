# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arti120.4gl
# Descriptions...: 商品策略維護作業
# Date & Author..: NO.FUN-960130 08/07/07 By  Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/11 By Cockroach 添加pos相關管控
# Modify.........: No.TQC-A30041 10/03/15 By Cockroach add orig/oriu
# Modify.........: No.FUN-A70132 10/08/19 By huangtao 單身新增稅別欄位，新增產品策略稅別明細ACTION
# Modify.........: No:FUN-A90049 10/09/27 By shaoyong 若為商戶料件時是否可採不允許='Y'
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0037 10/10/26 By huangtao 去掉rvyacti 
# Modify.........: No.FUN-AB0039 10/11/09 By huangtao 修改稅別明細相關bug
# Modify.........: No.TQC-AB0109 10/11/28 By shenyang GP5.2 SOP流程修改 
# Modify.........: No:FUN-B40044 11/04/26 By shiwuying MISC*料号产品名称修改
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B50054 11/05/11 By shiwuying Bug修改
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B80177 11/08/31 By pauline 當已有變更記錄時不可取消確認
# Modify.........: No.FUN-BC0076 12/01/11 By fanbj 確認時判斷同一產品策略所使用的稅別含税否是否一致
# Modify.........: No.FUN-BC0130 12/02/29 By yangxf 取消確認時判斷同一產品策略所使用的稅別含税否是否一致
# Modify.........: No:TQC-C30076 12/03/07 by pauline 輸入的稅別必須要與almi660互相控卡
# Modify.........: No:FUN-C30306 12/04/02 By pauline 產品多稅別設定不自動彈窗供使用者維護 
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60086 12/06/25 By xjll   arti120 產品策略開窗在服飾流通行業下不可開母料件編號
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑
# Modify.........: No:TQC-D20004 13/02/05 By pauline 點選確認時,確認是否單身資料都存在rvy_file,不存在則新增完後才可確認
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30050 13/03/18 By dongsz 產品為券時,增加稅種的檢查
# Modify.........: No.CHI-D20015 12/03/26 By lujh 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rtd         RECORD LIKE rtd_file.*,
       g_rtd_t       RECORD LIKE rtd_file.*,
       g_rtd_o       RECORD LIKE rtd_file.*,
       g_rtd01_t     LIKE rtd_file.rtd01,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rte         DYNAMIC ARRAY OF RECORD
           rte02          LIKE rte_file.rte02,
           rte03          LIKE rte_file.rte03,
           rte03_desc     LIKE azp_file.azp02,
           rte08          LIKE rte_file.rte08,             #No.FUN-A70132
           gec02          LIKE gec_file.gec02,             #No.FUN-A70132
           rte04          LIKE rte_file.rte04,             
           rte05          LIKE rte_file.rte05,
           rte06          LIKE rte_file.rte06,
           rte07          LIKE rte_file.rte07,
           rtepos         LIKE rte_file.rtepos           
                     END RECORD,
       g_rte_t       RECORD
           rte02          LIKE rte_file.rte02,
           rte03          LIKE rte_file.rte03,
           rte03_desc     LIKE azp_file.azp02,
           rte08          LIKE rte_file.rte08,             #No.FUN-A70132           
           gec02          LIKE gec_file.gec02,             #No.FUN-A70132
           rte04          LIKE rte_file.rte04,
           rte05          LIKE rte_file.rte05,
           rte06          LIKE rte_file.rte06,
           rte07          LIKE rte_file.rte07,
           rtepos         LIKE rte_file.rtepos
                     END RECORD,
       g_rte_o       RECORD 
           rte02          LIKE rte_file.rte02,
           rte03          LIKE rte_file.rte03,
           rte03_desc     LIKE azp_file.azp02,
           rte08          LIKE rte_file.rte08,             #No.FUN-A70132           
           gec02          LIKE gec_file.gec02,             #No.FUN-A70132
           rte04          LIKE rte_file.rte04,
           rte05          LIKE rte_file.rte05,
           rte06          LIKE rte_file.rte06,
           rte07          LIKE rte_file.rte07,
           rtepos         LIKE rte_file.rtepos
                     END RECORD,
#No.FUN-A70132   -----start
       g_rvy          DYNAMIC ARRAY OF RECORD
           rvy02          LIKE rvy_file.rvy02,
           rte03          LIKE rte_file.rte03,
           rte03_n        LIKE ima_file.ima02,
           rvy03          LIKE rvy_file.rvy03,
           rvy04          LIKE rvy_file.rvy04,
           gec02          LIKE gec_file.gec02,
           gec04          LIKE gec_file.gec04,
           rvy06          LIKE rvy_file.rvy06
     #      rvyacti        LIKE rvy_file.rvyacti                #FUN-AA0037
                      END RECORD, 
       g_rvy_t         RECORD
           rvy02          LIKE rvy_file.rvy02,
           rte03          LIKE rte_file.rte03,
           rte03_n        LIKE ima_file.ima02,
           rvy03          LIKE rvy_file.rvy03,
           rvy04          LIKE rvy_file.rvy04,
           gec02          LIKE gec_file.gec02,
           gec04          LIKE gec_file.gec04,
           rvy06          LIKE rvy_file.rvy06
     #      rvyacti        LIKE rvy_file.rvyacti                #FUN-AA0037
                      END RECORD, 
        g_rvy_o        RECORD
           rvy02          LIKE rvy_file.rvy02,
           rte03          LIKE rte_file.rte03,
           rte03_n        LIKE ima_file.ima02,
           rvy03          LIKE rvy_file.rvy03,
           rvy04          LIKE rvy_file.rvy04,
           gec02          LIKE gec_file.gec02,
           gec04          LIKE gec_file.gec04,
           rvy06          LIKE rvy_file.rvy06
    #       rvyacti        LIKE rvy_file.rvyacti                #FUN-AA0037
                      END RECORD, 
#No.FUN-A70132 ---end        
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5,
       l_ac1          LIKE type_file.num5 ,     #No.FUN-A70132
       l_flag         LIKE type_file.chr1      #No.FUN-A70132
      
       
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_gec07             LIKE gec_file.gec07
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
DEFINE g_argv1             LIKE rtd_file.rtd01
DEFINE g_argv2             STRING 
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rte08_t           LIKE rte_file.rte08
DEFINE g_cmd               LIKE type_file.chr1           #No.FUN-A70132 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rtd_file WHERE rtd01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW i120_w AT p_row,p_col WITH FORM "art/42f/arti120"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('rtepos',FALSE)
   END IF
 
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL i120_q()
   END IF
   
   CALL i120_menu()
   CLOSE WINDOW i120_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i120_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rte.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rtd01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rtd.* TO NULL
      CONSTRUCT BY NAME g_wc ON rtd01,rtd02,rtd03,rtd04,rtd05,
                                rtdconf,rtdcond,rtdconu,rtduser,
                                rtdgrup,rtdmodu,rtddate,rtdacti,
                                rtdcrat,rtdoriu,rtdorig         #TQC-A30041 ADD
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rtd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtd01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtd01
                  NEXT FIELD rtd01
      
               WHEN INFIELD(rtd03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtd03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtd03
                  NEXT FIELD rtd03
       
               WHEN INFIELD(rtdconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rtdconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rtdconu                                                                              
                  NEXT FIELD rtdconu
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
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_wc = g_wc clipped," AND rtduser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND rtdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND rtdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtduser', 'rtdgrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON rte02,rte03,rte08,rte04,rte05,rte06,rte07,rtepos                  #No.FUN-A70132
              FROM s_rte[1].rte02,s_rte[1].rte03,s_rte[1].rte08,s_rte[1].rte04,            #No.FUN-A70132
                   s_rte[1].rte05,s_rte[1].rte06,
                   s_rte[1].rte07,s_rte[1].rtepos
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rte03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rte03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rte03
                  NEXT FIELD rte03
#No.FUN-A70132 ----start
               WHEN INFIELD(rte08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_gec011"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rte08
                  NEXT FIELD rte08
#No.FUN-A70132 -----end
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
    END IF
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT rtd01 FROM rtd_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY rtd01"
   ELSE
      LET g_sql = "SELECT UNIQUE rtd01 ",
                  "  FROM rtd_file, rte_file ",
                  " WHERE rtd01 = rte01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rtd01"
   END IF
   PREPARE i120_prepare FROM g_sql
   DECLARE i120_cs
       SCROLL CURSOR WITH HOLD FOR i120_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rtd_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM rtd_file,rte_file WHERE ",
                "rte01=rtd01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i120_precount FROM g_sql
   DECLARE i120_count CURSOR FOR i120_precount
 
END FUNCTION
 
FUNCTION i120_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i120_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i120_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i120_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i120_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i120_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i120_yes()
            END IF
        WHEN "un_confirm"
           IF cl_chk_act_auth() THEN
              CALL i120_no()
           END IF
 
        WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL i120_void(1)
            END IF
        #FUN-D20039 --------sta
        WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i120_void(2)
            END IF
        #FUN-D20039 --------end
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rte),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rtd.rtd01 IS NOT NULL THEN
                 LET g_doc.column1 = "rtd01"
                 LET g_doc.value1 = g_rtd.rtd01
                 CALL cl_doc()
               END IF
         END IF
#FUN-A70132 -----start
         WHEN "tax_detail"
            IF cl_chk_act_auth() THEN
               CALL arti120_a('N')
            END IF
#FUN-A70132 ------end
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_cmd = ' '                  #No.FUN-A70132
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rte TO s_rte.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #IF g_flag AND g_rte.getlength()>0 THEN
         #   CALL fgl_set_arr_curr(g_rte.getlength())
         #   LET l_ac = ARR_CURR()
         #   CALL i120_b()
         #END IF
 
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
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION un_confirm
         LET g_action_choice = "un_confirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 -----------sta
      ON ACTION undo_void
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
#FUN-A70132  ----start
      ON ACTION tax_detail 
         LET g_action_choice="tax_detail"
         EXIT DISPLAY
#FUN-A70132  ----end
         
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i120_no()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_rtd04    LIKE rtd_file.rtd04   #FUN-B80177 add
DEFINE l_gen02    LIKE gen_file.gen02   #CHI-D20015 add
 
   IF g_rtd.rtd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01=g_rtd.rtd01
   IF g_rtd.rtdconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END--
   #判斷該商品策略是否已經被機構所應用
   SELECT COUNT(*) INTO l_cnt FROM rtz_file WHERE rtz04 = g_rtd.rtd01 
   IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
   IF l_cnt != 0 THEN
      CALL cl_err('','art-466',0)
      RETURN
   END IF

#FUN-B80177 add START
   SELECT rtd04 INTO l_rtd04 FROM rtd_file WHERE rtd01 = g_rtd.rtd01
   IF l_rtd04 IS NULL THEN LET l_rtd04 = 0 END IF
   IF l_rtd04 != 0 THEN
      CALL cl_err('','art-863',0)
      RETURN
   END IF
#FUN-B80177 add END
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF 
   BEGIN WORK
   OPEN i120_cl USING g_rtd.rtd01  
   IF STATUS THEN 
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl  
      ROLLBACK WORK 
      RETURN 
   END IF
    
   FETCH i120_cl INTO g_rtd.* 
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
      CLOSE i120_cl ROLLBACK WORK RETURN 
   END IF
                                          
   UPDATE rtd_file SET rtdconf='N', 
                       #rtdcond=NULL,     #CHI-D20015 mark
                       #rtdconu=NULL      #CHI-D20015 mark
                       rtdcond=g_today,   #CHI-D20015 add
                       rtdconu=g_user     #CHI-D20015 add
     WHERE rtd01=g_rtd.rtd01
   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
      CALL cl_err('',SQLCA.SQLCODE,1)
      RETURN
   END IF
   COMMIT WORK
   
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01=g_rtd.rtd01  
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtd.rtdconu    #CHI-D20015 add
   DISPLAY BY NAME g_rtd.rtdconf                                                                                                    
   DISPLAY BY NAME g_rtd.rtdcond                                                                                                    
   DISPLAY BY NAME g_rtd.rtdconu                                                                                                    
   #DISPLAY '' TO FORMONLY.rtdconu_desc    #CHI-D20015 mark                                                                                     
   DISPLAY l_gen02 TO FORMONLY.rtdconu_desc   #CHI-D20015 add


    #CKP                                                                                                                            
   IF g_rtd.rtdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rtd.rtdconf,"","","",g_chr,"")                                                                           
                                                                                                                                    
   CALL cl_flow_notify(g_rtd.rtd01,'V')
END FUNCTION
FUNCTION i120_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_sql      STRING                 #TQC-D20004 add
DEFINE l_rte02    LIKE rte_file.rte02    #TQC-D20004 add 
DEFINE l_rte08    LIKE rte_file.rte08    #TQC-D20004 add
 
   IF NOT s_data_center(g_plant) THEN RETURN END IF
#CHI-C30107 --------------- add ---------------- begin
   IF g_rtd.rtd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_rtd.rtdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtd.rtdconf = 'X' THEN CALL cl_err(g_rtd.rtd01,'9024',0) RETURN END IF
   IF g_rtd.rtdacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 --------------- add ---------------- end
   IF g_rtd.rtd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01=g_rtd.rtd01
   IF g_rtd.rtdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtd.rtdconf = 'X' THEN CALL cl_err(g_rtd.rtd01,'9024',0) RETURN END IF 
   IF g_rtd.rtdacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END-- 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rte_file
    WHERE rte01=g_rtd.rtd01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#FUN-BC0130 MARK begin----- 
#   #FUN-BC0076--start add--------------------------------
#   SELECT COUNT(DISTINCT gec07) INTO l_cnt
#     FROM rte_file
#    INNER JOIN rvy_file
#       ON rte01 = rvy01
#      AND rte02 = rvy02
#    INNER JOIN gec_file
#       ON rvy04 = gec01
#      AND rvy05 = gec011
#    WHERE rvy01 = g_rtd.rtd01
#      AND rte07 = 'Y'
#   IF l_cnt > 1 THEN 
#      CALL cl_err('','art1039',0)
#      RETURN  
#   END IF    
#   #FUN-BC0076--end add----------------------------------
#FUN-BC0130 MARK end -----

  #TQC-D20004 add START
   LET l_sql = " SELECT rte02,rte08 FROM rte_file ",
               " WHERE rte01 ='",g_rtd.rtd01,"' ",
               " ORDER BY rte02 "

   PREPARE i120_pre2 FROM l_sql
   DECLARE i120_cs2 CURSOR FOR i120_pre2
   BEGIN WORK
   FOREACH i120_cs2 INTO l_rte02,l_rte08 
      LET g_success = 'Y'
      LET g_rte_t.rte08 = l_rte08 
      IF cl_null(l_rte08) OR cl_null(l_rte02) THEN
         CONTINUE FOREACH 
      END IF
      CALL i120_rte08(l_rte02,l_rte08) 
      IF g_success = 'N' THEN
         ROLLBACK WORK 
         RETURN 
      END IF
      LET l_rte02 = ''
      LET l_rte08 = '' 
      LET g_rte_t.rte08 = ''
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF  
  #TQC-D20004 add END

#  IF NOT cl_confirm('art-026') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
   OPEN i120_cl USING g_rtd.rtd01
   
   IF STATUS THEN
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i120_cl INTO g_rtd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
      CLOSE i120_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE rtd_file SET rtdconf='Y',
                       rtdcond=g_today, 
                       rtdconu=g_user
     WHERE rtd01=g_rtd.rtd01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rtd.rtdconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rtd.rtd01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01=g_rtd.rtd01
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtd.rtdconu
   DISPLAY BY NAME g_rtd.rtdconf                                                                                         
   DISPLAY BY NAME g_rtd.rtdcond                                                                                         
   DISPLAY BY NAME g_rtd.rtdconu
   DISPLAY l_gen02 TO FORMONLY.rtdconu_desc
    #CKP
   IF g_rtd.rtdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtd.rtdconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rtd.rtd01,'V')
END FUNCTION
 
FUNCTION i120_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01=g_rtd.rtd01
   IF g_rtd.rtd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rtd.rtdconf='X' THEN RETURN END IF
    ELSE
       IF g_rtd.rtdconf<>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end
   IF g_rtd.rtdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtd.rtdacti = 'N' THEN CALL cl_err(g_rtd.rtd01,'art-142',0) RETURN END IF
  #IF g_rtd.rtdconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF #TQC-AB0109
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END--
   BEGIN WORK
 
   OPEN i120_cl USING g_rtd.rtd01
   IF STATUS THEN
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i120_cl INTO g_rtd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rtd.rtdconf) THEN
      LET g_chr = g_rtd.rtdconf
      IF g_rtd.rtdconf = 'N' THEN
         LET g_rtd.rtdconf = 'X'
      ELSE
         LET g_rtd.rtdconf = 'N'
      END IF
 
      UPDATE rtd_file SET rtdconf=g_rtd.rtdconf,
                          rtdmodu=g_user,
                          rtddate=g_today
       WHERE rtd01 = g_rtd.rtd01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rtd_file",g_rtd.rtd01,"",SQLCA.sqlcode,"","up rtdconf",1)
          LET g_rtd.rtdconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE i120_cl
   COMMIT WORK
 
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01=g_rtd.rtd01
   DISPLAY BY NAME g_rtd.rtdconf                                                                                        
   DISPLAY BY NAME g_rtd.rtdmodu                                                                                        
   DISPLAY BY NAME g_rtd.rtddate
    #CKP
   IF g_rtd.rtdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtd.rtdconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rtd.rtd01,'V')
END FUNCTION
FUNCTION i120_bp_refresh()
  DISPLAY ARRAY g_rte TO s_rte.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        CALL SET_COUNT(g_rec_b+1)
        CALL fgl_set_arr_curr(g_rec_b+1)
        CALL cl_show_fld_cont()
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i120_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
  
   MESSAGE ""
   CLEAR FORM
   CALL g_rte.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF NOT s_data_center(g_plant) THEN RETURN END IF
 
   INITIALIZE g_rtd.* LIKE rtd_file.*
   LET g_rtd01_t = NULL
 
   LET g_rtd_t.* = g_rtd.*
   LET g_rtd_o.* = g_rtd.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rtd.rtduser=g_user
      LET g_rtd.rtdoriu = g_user #FUN-980030
      LET g_rtd.rtdorig = g_grup #FUN-980030
      LET g_rtd.rtdgrup=g_grup
      LET g_rtd.rtdacti='Y'
      LET g_rtd.rtdcrat = g_today
      LET g_rtd.rtdconf = 'N'
      LET g_rtd.rtd04 = 0
      LET g_rtd.rtd03 = g_plant
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rtd.rtd03
      DISPLAY l_azp02 TO rtd03_desc
 
      CALL i120_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rtd.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rtd.rtd01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      INSERT INTO rtd_file VALUES (g_rtd.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK         #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rtd_file",g_rtd.rtd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK          #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rtd.rtd01,'I')
      END IF
 
      LET g_rtd01_t = g_rtd.rtd01
      LET g_rtd_t.* = g_rtd.*
      LET g_rtd_o.* = g_rtd.*
      CALL g_rte.clear()
 
      LET g_rec_b = 0
      CALL i120_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i120_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
 
   IF g_rtd.rtd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtd.* FROM rtd_file
    WHERE rtd01=g_rtd.rtd01
 
   IF g_rtd.rtdacti ='N' THEN
      CALL cl_err(g_rtd.rtd01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rtd.rtdconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rtd.rtdconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END-- 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtd01_t = g_rtd.rtd01
 
   BEGIN WORK
 
   OPEN i120_cl USING g_rtd.rtd01
 
   IF STATUS THEN
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i120_cl INTO g_rtd.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
       CLOSE i120_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i120_show()
 
   WHILE TRUE
      LET g_rtd01_t = g_rtd.rtd01
      LET g_rtd_o.* = g_rtd.*
      LET g_rtd.rtdmodu=g_user
      LET g_rtd.rtddate=g_today
 
      CALL i120_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtd.*=g_rtd_t.*
         CALL i120_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rtd.rtd01 != g_rtd01_t THEN
         UPDATE rte_file SET rte01 = g_rtd.rtd01
           WHERE rte01 = g_rtd01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rte_file",g_rtd01_t,"",SQLCA.sqlcode,"","rte",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rtd_file SET rtd_file.* = g_rtd.*
       WHERE rtd01 = g_rtd.rtd01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtd_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i120_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtd.rtd01,'U')
 
   CALL i120_b_fill("1=1")
   #CALL i120_bp_refresh()
 
END FUNCTION
 
FUNCTION i120_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_rtd.rtd04,g_rtd.rtduser,g_rtd.rtdmodu,
       g_rtd.rtdgrup,g_rtd.rtddate,g_rtd.rtdacti
      ,g_rtd.rtdoriu,g_rtd.rtdorig         #TQC-A30041 ADD
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rtd.rtd01,g_rtd.rtd02,g_rtd.rtd05, g_rtd.rtdoriu,g_rtd.rtdorig,
                 g_rtd.rtdconf,g_rtd.rtd03,g_rtd.rtdcond,
                 #g_rtd.rtdconu,g_rtd.rtduser,
                 g_rtd.rtdmodu,g_rtd.rtdacti,g_rtd.rtdgrup,
                 g_rtd.rtddate,g_rtd.rtdcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i120_set_entry(p_cmd)
         CALL i120_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD rtd01
         IF NOT cl_null(g_rtd.rtd01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtd.rtd01 != g_rtd_t.rtd01) THEN
               SELECT COUNT(*) INTO l_n FROM rtd_file
                  WHERE rtd01=g_rtd.rtd01
               IF l_n > 0 THEN
                  CALL cl_err(g_rtd.rtd01,'art-020',0)
                  NEXT FIELD rtd01
               END IF
            END IF
         END IF
      AFTER FIELD rtd03
         IF NOT cl_null(g_rtd.rtd03) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtd.rtd03 != g_rtd_t.rtd03) THEN
               CALL i120_rtd03()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD rtd03                                                                                                   
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
            WHEN INFIELD(rtd03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_rtd.rtd03
               CALL cl_create_qry() RETURNING g_rtd.rtd03
               DISPLAY BY NAME g_rtd.rtd03
               CALL i120_rtd03()
               NEXT FIELD rtd03
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
#檢查單身中是否有重復商品
#如果有返回FALSE，否則返回TRUE
FUNCTION i120_chk_rte03()
DEFINE  l_n  LIKE  type_file.num5
 
    SELECT COUNT(*) INTO l_n FROM rte_file
       WHERE rte01=g_rtd.rtd01 AND rte03=g_rte[l_ac].rte03
         AND rte02 <> g_rte[l_ac].rte02  #add
    IF l_n > 0 THEN
       RETURN FALSE
    END IF
  
    RETURN TRUE
END FUNCTION
#檢查當前商品策略中的商品是否超出aooi901中商品策略的範圍
#如果超出返回FALSE，否則返回TRUE
FUNCTION i120_chk_include()
DEFINE l_n         LIKE type_file.num5,
       l_azp06     LIKE azp_file.azp06,    #上級結構
       l_rtz04     LIKE rtz_file.rtz04     #商品策略
 
    #獲取當前機構指定的商品策略代碼
    SELECT rtz04 INTO l_rtz04 FROM rtz_file    
       WHERE rtz01=g_rtd.rtd03 
    #若沒有維護商品策略，那應該是可以錄入料件主檔中的所有商品
    IF cl_null(l_rtz04) THEN RETURN TRUE END IF    
 
    #檢查當前營運中心維護的商品策略中是否有此商品
    SELECT COUNT(*) INTO l_n FROM rte_file,rtd_file
       WHERE rte01=rtd01 AND rtd01=l_rtz04 AND rte03=g_rte[l_ac].rte03
 
    IF l_n > 0 THEN
       RETURN TRUE
    END IF
 
    RETURN FALSE     
END FUNCTION
#檢查當前機構的有效性，并帶出機構名稱 
FUNCTION i120_rtd03()
    DEFINE l_azp02 LIKE azp_file.azp02
 
   LET g_errno = " "
 
   SELECT azp02
     INTO l_azp02
     FROM azp_file WHERE azp01 = g_rtd.rtd03
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-044'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_azp02 TO FORMONLY.rtd03_desc
   END CASE
 
END FUNCTION
 
FUNCTION i120_rte03()
    DEFINE l_imaacti LIKE ima_file.imaacti
 
   LET g_errno = " "
 
  #FUN-B40044 Begin---
   IF g_rte[l_ac].rte03[1,4] = 'MISC' THEN
      SELECT ima02,imaacti
        INTO g_rte[l_ac].rte03_desc,l_imaacti
        FROM ima_file WHERE ima01 = 'MISC'
   ELSE
  #FUN-B40044 End-----
      SELECT ima02,imaacti
        INTO g_rte[l_ac].rte03_desc,l_imaacti
        FROM ima_file WHERE ima01 = g_rte[l_ac].rte03
   END IF #FUN-B40044
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_rte[l_ac].rte03_desc TO FORMONLY.rte03_desc
   END CASE
 
END FUNCTION
 
FUNCTION i120_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rte.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i120_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rtd.* TO NULL
      RETURN
   END IF
 
   OPEN i120_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rtd.* TO NULL
   ELSE
      OPEN i120_count
      FETCH i120_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i120_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION i120_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i120_cs INTO g_rtd.rtd01
      WHEN 'P' FETCH PREVIOUS i120_cs INTO g_rtd.rtd01
      WHEN 'F' FETCH FIRST    i120_cs INTO g_rtd.rtd01
      WHEN 'L' FETCH LAST     i120_cs INTO g_rtd.rtd01
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
        FETCH ABSOLUTE g_jump i120_cs INTO g_rtd.rtd01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
      INITIALIZE g_rtd.* TO NULL
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
 
   SELECT * INTO g_rtd.* FROM rtd_file WHERE rtd01 = g_rtd.rtd01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rtd_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rtd.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rtd.rtduser
   LET g_data_group = g_rtd.rtdgrup
 
   CALL i120_show()
 
END FUNCTION
 
FUNCTION i120_show()
DEFINE  l_gen02  LIKE gen_file.gen02
 
   LET g_rtd_t.* = g_rtd.*
   LET g_rtd_o.* = g_rtd.*
   DISPLAY BY NAME g_rtd.rtd01,g_rtd.rtd05,g_rtd.rtd02, g_rtd.rtdoriu,g_rtd.rtdorig,
                   g_rtd.rtdconf,g_rtd.rtd03,g_rtd.rtdcond,
                   g_rtd.rtd04,g_rtd.rtdconu,g_rtd.rtduser,
                   g_rtd.rtdmodu,g_rtd.rtdacti,g_rtd.rtdgrup,
                   g_rtd.rtddate,g_rtd.rtdcrat
 
   IF g_rtd.rtdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rtd.rtdconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rtd.rtd01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtd.rtdconu
   DISPLAY l_gen02 TO FORMONLY.rtdconu_desc
 
   CALL i120_rtd03()
   CALL i120_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i120_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtd.rtd01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rtd.rtdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtd.rtdconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END--
   BEGIN WORK 
   OPEN i120_cl USING g_rtd.rtd01
   IF STATUS THEN
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl
      RETURN
   END IF
 
   FETCH i120_cl INTO g_rtd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i120_show()
 
   IF g_rtd.rtdconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   #BEGIN WORK 
   IF cl_exp(0,0,g_rtd.rtdacti) THEN
      LET g_chr=g_rtd.rtdacti
      IF g_rtd.rtdacti='Y' THEN
         LET g_rtd.rtdacti='N'
      ELSE
         LET g_rtd.rtdacti='Y'
      END IF
 
      UPDATE rtd_file SET rtdacti=g_rtd.rtdacti,
                          rtdmodu=g_user,
                          rtddate=g_today
       WHERE rtd01=g_rtd.rtd01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rtd_file",g_rtd.rtd01,"",SQLCA.sqlcode,"","",1) 
         LET g_rtd.rtdacti=g_chr
      END IF
   END IF
 
   CLOSE i120_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rtd.rtd01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtdacti,rtdmodu,rtddate
     INTO g_rtd.rtdacti,g_rtd.rtdmodu,g_rtd.rtddate FROM rtd_file
    WHERE rtd01=g_rtd.rtd01
   DISPLAY BY NAME g_rtd.rtdacti,g_rtd.rtdmodu,g_rtd.rtddate
 
END FUNCTION
 
FUNCTION i120_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtd.rtd01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtd.* FROM rtd_file
    WHERE rtd01=g_rtd.rtd01
 
   IF g_rtd.rtdconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rtd.rtdconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rtd.rtdacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END--
 
   BEGIN WORK
 
   OPEN i120_cl USING g_rtd.rtd01
   IF STATUS THEN
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i120_cl INTO g_rtd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i120_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rtd01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rtd.rtd01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rtd_file WHERE rtd01 = g_rtd.rtd01
      DELETE FROM rte_file WHERE rte01 = g_rtd.rtd01
      DELETE FROM rvy_file WHERE rvy01 = g_rtd.rtd01        #No.FUN-A70132
      CLEAR FORM
      CALL g_rte.clear()
      OPEN i120_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i120_cs
         CLOSE i120_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i120_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i120_cs
         CLOSE i120_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i120_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i120_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i120_fetch('/')
      END IF
   END IF
 
   CLOSE i120_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtd.rtd01,'D')
END FUNCTION
 
FUNCTION i120_b()
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
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_azp03   LIKE azp_file.azp03
DEFINE l_line    LIKE type_file.num5
DEFINE l_count1  LIKE type_file.num5        #No.FUN-A70132          
DEFINE l_ima120  LIKE ima_file.ima120       #No.FUN-A90049 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rtd.rtd01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rtd.* FROM rtd_file
     WHERE rtd01=g_rtd.rtd01
 
    IF g_rtd.rtdacti ='N' THEN
       CALL cl_err(g_rtd.rtd01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rtd.rtdconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rtd.rtdconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    IF NOT s_data_center(g_plant) THEN RETURN END IF 
# TQC-AB0109  ----ADD ---begin--
   IF g_rtd.rtd03 <> g_plant THEN
      CALL cl_err('','art-977',0)                                               
      RETURN                                                                    
   END IF
# TQC-AB0109  ----ADD ---END--
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rte02,rte03,'',rte08,'',rte04,rte05,rte06,rte07,rtepos",   #No.FUN-A70132
                       "  FROM rte_file ",
                       " WHERE rte01=? AND rte02=? "," FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rte WITHOUT DEFAULTS FROM s_rte.*
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
 
           OPEN i120_cl USING g_rtd.rtd01
           IF STATUS THEN
              CALL cl_err("OPEN i120_cl:", STATUS, 1)
              CLOSE i120_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i120_cl INTO g_rtd.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)
              CLOSE i120_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_cmd = p_cmd               #No.FUN-A70132 
              LET g_rte_t.* = g_rte[l_ac].*  #BACKUP
              LET g_rte_o.* = g_rte[l_ac].*  #BACKUP
              OPEN i120_bcl USING g_rtd.rtd01,g_rte_t.rte02
              IF STATUS THEN
                 CALL cl_err("OPEN i120_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i120_bcl INTO g_rte[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rte_t.rte02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i120_rte03()
                 SELECT gec02 INTO g_rte[l_ac].gec02 FROM gec_file
                  WHERE  gec01 = g_rte[l_ac].rte08 AND gec011 = '2'
              END IF
              CALL i120_ima120() #FUN-A90049
          END IF 
           
        BEFORE INSERT
#          DISPLAY "BEFORE INSERT!"        #No.FUN-A70132 
           LET l_n = ARR_COUNT()
           BEGIN WORK                      #No.FUN-A70132 
           LET p_cmd='a'
           LET g_cmd = p_cmd               #No.FUN-A70132 
           INITIALIZE g_rte[l_ac].* TO NULL
           LET g_rte[l_ac].rte04 =  'Y'            #Body default
           LET g_rte[l_ac].rte05 =  'Y'            #Body default
           LET g_rte[l_ac].rte06=   'Y'
           LET g_rte[l_ac].rte07 =  'Y'            #Body default
           LET g_rte[l_ac].rtepos = '1' #NO.FUN-B40071
           IF l_ac <= 1 THEN 
              LET g_rte[l_ac].rte08 = ''
           ELSE 
              LET g_rte[l_ac].rte08 = g_rte[l_ac-1].rte08 
           END IF
           DISPLAY BY NAME g_rte[l_ac].rtepos      
           CALL cl_set_comp_entry("rtepos",FALSE)    #FUN-A30030 ADD
           LET g_rte_t.* = g_rte[l_ac].*
           LET g_rte_o.* = g_rte[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rte02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rte_file(rte01,rte02,rte03,rte04,rte05,rte06,
                                rte07,rtepos,rte08,rte09)                        #No.FUN-A70132
           VALUES(g_rtd.rtd01,g_rte[l_ac].rte02,
                  g_rte[l_ac].rte03,g_rte[l_ac].rte04,
                  g_rte[l_ac].rte05,g_rte[l_ac].rte06,
                  g_rte[l_ac].rte07,g_rte[l_ac].rtepos,g_rte[l_ac].rte08,'2')  #No.FUN-A70132
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rte_file",g_rtd.rtd01,g_rte[l_ac].rte02,SQLCA.sqlcode,"","",1)
              ROLLBACK WORK               #FUN-A70132
              CANCEL INSERT
           ELSE
         #FUN-AB0039 --------------mark------------------
         #     CALL i120_rte08()
         #     IF l_flag = 'Y' THEN
         #        CALL arti120_a('Y')
         #     END IF
         #FUN-AB0039 --------------mark ------------------
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rte02
           IF g_rte[l_ac].rte02 IS NULL OR g_rte[l_ac].rte02 = 0 THEN
              SELECT max(rte02)+1
                INTO g_rte[l_ac].rte02
                FROM rte_file
               WHERE rte01 = g_rtd.rtd01
              IF g_rte[l_ac].rte02 IS NULL THEN
                 LET g_rte[l_ac].rte02 = 1
              END IF
           END IF
 
        AFTER FIELD rte02
           IF NOT cl_null(g_rte[l_ac].rte02) THEN
              IF g_rte[l_ac].rte02 != g_rte_t.rte02
                 OR g_rte_t.rte02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rte_file
                  WHERE rte01 = g_rtd.rtd01
                    AND rte02 = g_rte[l_ac].rte02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rte[l_ac].rte02 = g_rte_t.rte02
                    NEXT FIELD rte02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rte03
         IF NOT cl_null(g_rte[l_ac].rte03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rte[l_ac].rte03,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_rte[l_ac].rte03= g_rte_t.rte03
             NEXT FIELD rte03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-C60086----add--begin-----------------
            IF s_industry("slk") AND g_azw.azw04 = '2' THEN
               SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_rte[l_ac].rte03 AND ima151 = 'Y'
               IF l_cnt > 0 THEN
                  CALL cl_err('','mfg-789',0)
                  LET g_rte[l_ac].rte03= g_rte_t.rte03
                  NEXT FIELD rte03
               END IF
            END IF
#FUN-C60086 ---add---end------------------
#No.FUN-A90049 add start------------------
            INITIALIZE l_ima120 TO NULL
            SELECT ima120 INTO l_ima120 FROM ima_file
             WHERE ima01 = g_rte[l_ac].rte03
            IF l_ima120 = '2' THEN
               CALL cl_set_comp_entry("rte04",FALSE)
               LET g_rte[l_ac].rte04 = 'N'
               DISPLAY BY NAME g_rte[l_ac].rte04
            ELSE
               CALL cl_set_comp_entry("rte04",TRUE)
            END IF
#No.FUN-A90049 add end------------------
            IF g_rte_o.rte03 IS NULL OR
               (g_rte[l_ac].rte03 != g_rte_o.rte03 ) THEN
               CALL i120_rte03()    #檢查其有效性及帶出值          
              #FUN-B40044 Begin---  #在s_chk_item_no中已检查
              #IF NOT cl_null(g_errno) THEN
              #   CALL cl_err(g_rte[l_ac].rte03,g_errno,0)
              #   LET g_rte[l_ac].rte03 = g_rte_o.rte03
              #   DISPLAY BY NAME g_rte[l_ac].rte03
              #   NEXT FIELD rte03
              #END IF
              #FUN-B40044 End-----
               #檢查單身中商品是否重復
               IF NOT i120_chk_rte03() THEN
                  CALL cl_err(g_rte[l_ac].rte03,'art-033',0)
                  NEXT FIELD rte03
               END IF
               #檢查當前營運中心錄入的商品是否包含在aooi901的商品策略中
               IF NOT i120_chk_include() THEN   
                  CALL cl_err('','art-035',0)
                  NEXT FIELD rte03
               END IF
              #TQC-C30076 add START
               CALL i120_chk_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte03,g_rte[l_ac].rte08,0)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_errno = ' '
                  NEXT FIELD rte03
               END IF 
              #TQC-C30076 add END
            END IF  
         END IF  

#No.FUN-A70132  ----start
        AFTER FIELD rte08
            IF NOT cl_null(g_rte[l_ac].rte08)  THEN 
               IF p_cmd = 'a' THEN         
                 #FUN-D30050--add--str---         #稅別需先檢查再做相應處理
                  CALL i120_chk_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte03,g_rte[l_ac].rte08,0)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rte08
                  END IF
                 #FUN-D30050--add--end--- 
                #CALL i120_rte08()  #TQC-D20004 mark 
                 CALL i120_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte08)  #TQC-D20004 add
                 IF l_flag = 'Y' THEN
                   #FUN-D30050--mark--str---
                  ##TQC-C30076 add START
                  # CALL i120_chk_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte03,g_rte[l_ac].rte08,0) 
                  # IF NOT cl_null(g_errno) THEN
                  #    CALL cl_err('',g_errno,0)
                  #    NEXT FIELD rte08
                  # END IF
                  ##TQC-C30076 add END
                   #FUN-D30050--mark--end---
                   #CALL arti120_a('Y')  #FUN-C30306 mark
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    NEXT FIELD rte08 
                 ELSE
                    LET g_rte_t.rte08 = g_rte[l_ac].rte08
                 END IF
               ELSE
                 IF g_rte[l_ac].rte08 <> g_rte_t.rte08 THEN
                   #FUN-D30050--add--str---         #稅別需先檢查再做相應處理
                    CALL i120_chk_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte03,g_rte[l_ac].rte08,0)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD rte08
                    END IF
                   #CALL i120_rte08()  #TQC-D20004 mark  
                    CALL i120_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte08)  #TQC-D20004 add
                    IF l_flag = 'Y' THEN
                      #FUN-D30050--mark--str--- 
                      ##TQC-C30076 add START
                      # CALL i120_chk_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte03,g_rte[l_ac].rte08,0)   
                      # IF NOT cl_null(g_errno) THEN 
                      #    CALL cl_err('',g_errno,0)
                      #    LET g_errno = ' '
                      #    NEXT FIELD rte08
                      # END IF
                      ##TQC-C30076 add END
                      #FUN-D30050--mark--end---
                       #CALL arti120_a('Y')  #FUN-C30306 mark
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       NEXT FIELD rte08 
                    END IF 
                 END IF
               END IF
             END IF

#No.FUN-A70132  ----end       
        AFTER FIELD rte04
           IF NOT cl_null(g_rte[l_ac].rte04) THEN
              IF g_rte[l_ac].rte04 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte04                
              END IF
           END IF
        
        AFTER FIELD rte05
           IF NOT cl_null(g_rte[l_ac].rte05) THEN
              IF g_rte[l_ac].rte05 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte05                
              END IF
           END IF
           
        AFTER FIELD rte06
           IF NOT cl_null(g_rte[l_ac].rte06) THEN
              IF g_rte[l_ac].rte06 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte06                
              END IF
           END IF 
           
        AFTER FIELD rte07
           IF NOT cl_null(g_rte[l_ac].rte07) THEN
              IF g_rte[l_ac].rte07 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rte07                
              END IF
           END IF
        
        AFTER FIELD rtepos
           IF NOT cl_null(g_rte[l_ac].rtepos) THEN
              IF g_rte[l_ac].rtepos NOT MATCHES '[123]' THEN #NO.FUN-B40071
                 NEXT FIELD rtepos                
              END IF
           END IF
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rte_t.rte02 > 0 AND g_rte_t.rte02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
             #FUN-A30030 ADD------------------------------------  
              IF g_aza.aza88='Y' THEN
                #FUN-B40071 --START--
                 #IF NOT (g_rte[l_ac].rte07='N' AND g_rte[l_ac].rtepos='Y') THEN
                 #   CALL cl_err('', 'art-648', 1)
                 #   CANCEL DELETE
                 #END IF
                 IF NOT ((g_rte[l_ac].rtepos='3' AND g_rte[l_ac].rte07='N') 
                            OR (g_rte[l_ac].rtepos='1'))  THEN                  
                    CALL cl_err('','apc-139',0)            
                   #RETURN        #TQC-B50054
                    CANCEL DELETE #TQC-B50054
                 END IF      
                #FUN-B40071 --END--
              END IF
             #FUN-A30030 END-----------------------------------
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rte_file
               WHERE rte01 = g_rtd.rtd01
                 AND rte02 = g_rte_t.rte02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rte_file",g_rtd.rtd01,g_rte_t.rte02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              DELETE FROM rvy_file
               WHERE rvy01 =  g_rtd.rtd01
                 AND rvy02 = g_rte_t.rte02 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rvy_file",g_rtd.rtd01,g_rte_t.rte02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rte[l_ac].* = g_rte_t.*
              CLOSE i120_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_aza.aza88='Y' THEN         #FUN-A30030 ADD
              IF g_rte[l_ac].rte02<>g_rte_t.rte02 OR g_rte[l_ac].rte03<>g_rte_t.rte03 OR g_rte[l_ac].rte04<>g_rte_t.rte04 OR g_rte[l_ac].rte05<>g_rte_t.rte05
                 OR g_rte[l_ac].rte06<>g_rte_t.rte06 OR g_rte[l_ac].rte07<>g_rte_t.rte07 THEN  
                 #FUN-B40071 --START--
                 #LET g_rte[l_ac].rtepos = 'N'
                 IF g_rte[l_ac].rtepos <> '1' THEN
                    LET g_rte[l_ac].rtepos = '2'
                 END IF 
                 #FUN-B40071 --END--
                 DISPLAY BY NAME g_rte[l_ac].rtepos
              END IF
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rte[l_ac].rte02,-263,1)
              LET g_rte[l_ac].* = g_rte_t.*
           ELSE
              UPDATE rte_file SET rte02=g_rte[l_ac].rte02,
                                  rte03=g_rte[l_ac].rte03,
                                  rte08=g_rte[l_ac].rte08,        #No.FUN-A70132 
                                  rte04=g_rte[l_ac].rte04,
                                  rte05=g_rte[l_ac].rte05,
                                  rte06=g_rte[l_ac].rte06,
                                  rte07=g_rte[l_ac].rte07,
                                  rtepos=g_rte[l_ac].rtepos         #FUN-A30030 ADD
               WHERE rte01=g_rtd.rtd01
                 AND rte02=g_rte_t.rte02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rte_file",g_rtd.rtd01,g_rte_t.rte02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rte[l_ac].* = g_rte_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rte[l_ac].* = g_rte_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rte.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i120_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE i120_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rte02) AND l_ac > 1 THEN
              LET g_rte[l_ac].* = g_rte[l_ac-1].*
              LET g_rte[l_ac].rte02 = g_rec_b + 1
              NEXT FIELD rte02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rte03)
                 IF p_cmd = 'u' THEN
#FUN-AA0059---------mod------------str-----------------                    
#                   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_rtd.rtd03
#                    CALL cl_init_qry_var()
#                   IF cl_null(l_rtz04) THEN
#                       LET g_qryparam.form = "q_ima"
#                   ELSE
#                   	 CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_rtd01_1"
#                      LET g_qryparam.arg1 = l_rtz04
#                      LET g_qryparam.default1 = g_rte[l_ac].rte03
#                      CALL cl_create_qry() RETURNING g_rte[l_ac].rte03
#                   END IF
#                    LET g_qryparam.default1 = g_rte[l_ac].rte03
#                    CALL cl_create_qry() RETURNING g_rte[l_ac].rte03
                     CALL q_sel_ima(FALSE, "q_ima","",g_rte[l_ac].rte03,"","","","","",'' ) #FUN-AA0059 add 
                       RETURNING  g_rte[l_ac].rte03                                         #FUN-AA0059 add
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_rte[l_ac].rte03
                    CALL i120_rte03()
                    NEXT FIELD rte03
                 ELSE
                    CALL s_query('1',g_rtd.rtd03,g_rtd.rtd01) RETURNING l_line
                    IF l_line != 0 THEN
                      CALL i120_b_fill("1=1")
                       CALL i120_bp_refresh()
                      #FUN-D30050--mark--str---
                      #TQC-C30076 add START
                      #CALL i120_chk_rte08(g_rte[l_ac].rte02,g_rte[l_ac].rte03,g_rte[l_ac].rte08,0)
                      #IF NOT cl_null(g_errno) THEN
                      #   CALL cl_err('',g_errno,0)
                      #   DISPLAY BY NAME g_rte[l_ac].rte03
                      #   LET g_errno = ' '
                      #   NEXT FIELD rte03
                      #END IF
                      #TQC-C30076 add END
                      #FUN-D30050--mark--end---
                       LET g_flag = TRUE
                       EXIT INPUT
                    END IF
                 END IF
#No.FUN-A70132 ---start
                WHEN INFIELD(rte08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gec011"
                     LET g_qryparam.default1 = g_rte[l_ac].rte08
                     CALL cl_create_qry() RETURNING g_rte[l_ac].rte08
                     DISPLAY BY NAME g_rte[l_ac].rte08                   
                    NEXT FIELD rte08                
#No.FUN-A70132 ----end                 
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
         
      ON ACTION tax_detail
         CALL arti120_a('Y')
    END INPUT
    
    UPDATE rtd_file SET rtdmodu = g_rtd.rtdmodu,rtddate = g_rtd.rtddate
       WHERE rtd01 = g_rtd.rtd01
     
    DISPLAY BY NAME g_rtd.rtdmodu,g_rtd.rtddate
    
    #這里不能COMMIT、ROLLBACK,允許-535的錯誤發生，不會對結果產生影響
    IF g_flag THEN
       LET g_flag = FALSE
       CALL i120_b()
    END IF
 
    CLOSE i120_bcl
    COMMIT WORK
#   CALL i120_delall() #CHI-C30002 mark
    CALL t120_delHeader()     #CHI-C30002 add
    CALL i120_b_fill("1=1")   #add 
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t120_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM rtd_file WHERE rtd01 = g_rtd.rtd01
         INITIALIZE g_rtd.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i120_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rte_file
#   WHERE rte01 = g_rtd.rtd01
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rtd_file WHERE rtd01 = g_rtd.rtd01
#     CALL g_rte.clear()
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i120_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rte02,rte03,'',rte08,'',rte04,rte05,rte06,rte07,rtepos ",   #No.FUN-A70132  
               "  FROM rte_file",
               " WHERE rte01 ='",g_rtd.rtd01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rte02 "
 
   DISPLAY g_sql
 
   PREPARE i120_pb FROM g_sql
   DECLARE rte_cs CURSOR FOR i120_pb
 
   CALL g_rte.clear()
   LET g_cnt = 1
 
   FOREACH rte_cs INTO g_rte[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
      #FUN-B40044 Begin---
       IF g_rte[g_cnt].rte03[1,4] = 'MISC' THEN
          SELECT ima02 INTO g_rte[g_cnt].rte03_desc FROM ima_file
           WHERE ima01 = 'MISC'
       ELSE
      #FUN-B40044 End-----
          SELECT ima02 INTO g_rte[g_cnt].rte03_desc FROM ima_file
           WHERE ima01 = g_rte[g_cnt].rte03
       END IF  #FUN-B40044
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rte[g_cnt].rte03,"",SQLCA.sqlcode,"","",0)  
          LET g_rte[g_cnt].rte03_desc = NULL
       END IF
#No.FUN-A70132 ----start
       SELECT gec02 INTO g_rte[g_cnt].gec02  FROM gec_file
          WHERE gec01 = g_rte[g_cnt].rte08 AND gec011 = '2'
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","gec_file",g_rte[g_cnt].rte08,"",SQLCA.sqlcode,"","",0)  
          LET g_rte[g_cnt].gec02 = NULL
       END IF
#No.FUN-A70132 ----end  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rte.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i120_copy()
   DEFINE l_newno     LIKE rtd_file.rtd01,
          l_oldno     LIKE rtd_file.rtd01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF NOT s_data_center(g_plant) THEN RETURN END IF
   IF g_rtd.rtd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i120_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rtd01
 
       AFTER FIELD rtd01
          IF l_newno IS NOT NULL THEN 
             SELECT COUNT(*) INTO l_n FROM rtd_file
                 WHERE rtd01=l_newno
             IF l_n > 0 THEN
                CALL cl_err(l_newno,'art-020',0)
                NEXT FIELD rtd01
             END IF 
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
      DISPLAY BY NAME g_rtd.rtd01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rtd_file
       WHERE rtd01=g_rtd.rtd01
       INTO TEMP y
 
   UPDATE y
       SET rtd01=l_newno,
           rtd03=g_plant,
           rtdconf = 'N',
           rtdcond = NULL,
           rtdconu = NULL,
           rtdoriu = g_user,   #TQC-A30041 ADD
           rtdorig = g_grup,   #TQC-A30041 ADD
           rtduser=g_user,
           rtdgrup=g_grup,
           rtdmodu=NULL,
           rtddate=g_today,
           rtdacti='Y',
           rtdcrat=g_today
 
   INSERT INTO rtd_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtd_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rte_file
       WHERE rte01=g_rtd.rtd01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rte01=l_newno,rtepos='1' #NO.FUN-B40071 
 
   INSERT INTO rte_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK         #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rte_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK          #FUN-B80085--add--
      RETURN
#   ELSE                              #FUN-A70132
#       COMMIT WORK                   #FUN-A70132
   END IF
#FUN-A70132 -------------start-----------------------------------
   DROP TABLE r

   SELECT * FROM rvy_file
       WHERE rvy01 = g_rtd.rtd01 INTO TEMP r
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","r","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF  
   UPDATE r SET rvy01=l_newno
   INSERT INTO rvy_file 
      SELECT * FROM r
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK         #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rvy_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK          #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
#FUN-A70132 ---------------end------------------------------------
   
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rtd.rtd01
   SELECT rtd_file.* INTO g_rtd.* FROM rtd_file WHERE rtd01 = l_newno
   CALL i120_u()
   CALL i120_b() 
   #SELECT rtd_file.* INTO g_rtd.* FROM rtd_file WHERE rtd01 = l_oldno  #FUN-C80046
   #CALL i120_show()   #FUN-C80046
 
END FUNCTION
 
FUNCTION i120_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_rtd.rtd01 IS NOT NULL THEN
       LET g_wc = "rtd01='",g_rtd.rtd01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "arti120" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i120_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rtd01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i120_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rtd01",FALSE)
    END IF
 
END FUNCTION
#NO.FUN-960130 

#No.FUN-A70132 ----start
#FUNCTION  i120_rte08()  #TQC-D20004 mark 
FUNCTION i120_rte08(p_rte02,p_rte08)  #TQC-D20004 add
  DEFINE l_gec02   LIKE gec_file.gec02
  DEFINE l_gecacti LIKE gec_file.gecacti
  DEFINE l_count   LIKE type_file.num5
  DEFINE l_count1   LIKE type_file.num5
  DEFINE l_count2   LIKE type_file.num5
  DEFINE l_rvy03   LIKE rvy_file.rvy03
  DEFINE p_rte02   LIKE rte_file.rte02   #TQC-D20004 add
  DEFINE p_rte08   LIKE rte_file.rte08   #TQC-D20004 add
  
  LET g_errno = " "
  LET l_flag = 'N'
  SELECT gec02 ,gecacti INTO l_gec02,l_gecacti FROM gec_file
  #WHERE gec01 = g_rte[l_ac].rte08 AND gec011 = '2'   #TQC-D20004 mark 
   WHERE gec01 = p_rte08 AND gec011 = '2'             #TQC-D20004 add
   CASE  WHEN SQLCA.sqlcode = 100  
              LET g_errno = 'art-931'
         WHEN l_gecacti = 'N'  LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
     #LET g_rte[l_ac].gec02 = l_gec02   #TQC-D20004 mark 
      SELECT COUNT(*) INTO l_count FROM rvy_file 
      #WHERE rvy01= g_rtd.rtd01 AND rvy02 = g_rte[l_ac].rte02 AND rvy04 = g_rte[l_ac].rte08    #TQC-D20004 mark 
       WHERE rvy01= g_rtd.rtd01 AND rvy02 = p_rte02 AND rvy04 = p_rte08                        #TQC-D20004 add
      SELECT COUNT(*) INTO l_count1 FROM rvy_file
       #WHERE rvy01= g_rtd.rtd01 AND rvy02 = g_rte[l_ac].rte02 AND rvy04 = g_rte_t.rte08  #TQC-D20004 mark 
        WHERE rvy01= g_rtd.rtd01 AND rvy02 = p_rte02 AND rvy04 = g_rte_t.rte08  #TQC-D20004 add 
      SELECT COUNT(rvy03) INTO l_count2 FROM rvy_file
       WHERE rvy01 =  g_rtd.rtd01
        #AND rvy02 =  g_rte[l_ac].rte02   #TQC-D20004 mark 
         AND rvy02 =  p_rte02             #TQC-D20004 add
      IF l_count2 = 0 THEN
         LET l_rvy03 = 1
      ELSE
         SELECT MAX(rvy03)+1 INTO l_rvy03 FROM rvy_file
          WHERE rvy01 =  g_rtd.rtd01
           #AND rvy02 =  g_rte[l_ac].rte02   #TQC-D20004 mark 
            AND rvy02 =  p_rte02   #TQC-D20004 add
      END IF
      IF l_count1 >0 THEN
        #IF g_rte[l_ac].rte08 != g_rte_t.rte08 THEN   #TQC-D20004 mark 
         IF p_rte08 != g_rte_t.rte08 THEN   #TQC-D20004 add 
            IF cl_confirm('art-932') THEN
                DELETE  FROM  rvy_file  WHERE rvy01 = g_rtd.rtd01 
                       #AND rvy02 = g_rte[l_ac].rte02  #TQC-D20004 mark 
                        AND rvy02 = p_rte02            #TQC-D20004 add
                        AND rvy04 = g_rte_t.rte08
             ELSE 
               #LET g_rte[l_ac].rte08 = g_rte_t.rte08  #TQC-D20004 mark 
                LET p_rte08 = g_rte_t.rte08  #TQC-D20004 add
                LET  g_errno = '9001'
                RETURN
             END IF             
         END IF
         LET l_flag = 'Y'
      END IF 
     
#FUN-AB0039 --------------------STA
#    #FUN-AA0037 -----------------STA
#    #    INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvyacti) VALUES(g_rtd.rtd01,g_rte[l_ac].rte02,
#    #                            l_rvy03,g_rte[l_ac].rte08, '2','Y')  
#         INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05) VALUES(g_rtd.rtd01,g_rte[l_ac].rte02,
#                               l_rvy03,g_rte[l_ac].rte08, '2')
#    #FUN-AA0037 --------------- -END
      IF l_count = 0 THEN
         INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvygrup,rvyorig,rvyoriu,rvyuser)
           #VALUES(g_rtd.rtd01,g_rte[l_ac].rte02,l_rvy03,g_rte[l_ac].rte08, '2'   #TQC-D20004 mark 
            VALUES(g_rtd.rtd01,p_rte02,l_rvy03,p_rte08, '2'                       #TQC-D20004 add
                   ,g_grup,g_grup,g_user,g_user)
#FUN-AB0039 --------------------END
#        CALL arti120_a('Y')                 #FUN-AB0039  mark  
         LET l_flag = 'Y'                    #FUN-AB0039
      END IF
   ELSE 
        LET g_success = 'N'  #TQC-D20004 add
        CALL cl_err('',g_errno,0)
       #LET g_rte[l_ac].rte08 = g_rte_t.rte08  #TQC-D20004 mark
        LET p_rte08 = g_rte_t.rte08  #TQC-D20004 add
   END IF   
END FUNCTION  

FUNCTION  arti120_a(l_t)
   DEFINE l_allow_insert  LIKE type_file.num5
   DEFINE l_allow_delete  LIKE type_file.num5
   DEFINE l_n             LIKE type_file.num5
   DEFINE g_rvyk_sw       LIKE type_file.chr1
   DEFINE l_cnt           LIKE type_file.num5
  DEFINE  p_cmd           LIKE type_file.chr1
  DEFINE  l_t             LIKE type_file.chr1
  DEFINE l_gecacti LIKE gec_file.gecacti                       #FUN-AB0039
  LET l_ac1 =1
  
   IF cl_null(g_rtd.rtd01) THEN RETURN END IF
   IF g_cmd = 'a' OR g_cmd = 'u' THEN

      DECLARE i120_rvy_curs CURSOR FOR
  #      SELECT rvy02,'','',rvy03,rvy04,'','',rvy06,rvyacti               #FUN-AA0037   mark
         SELECT rvy02,'','',rvy03,rvy04,'','',rvy06                       #FUN-AA0037
        FROM rvy_file 
        WHERE rvy01 = g_rtd.rtd01 AND rvy02 = g_rte[l_ac].rte02
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare i120_rvy_curs',SQLCA.sqlcode,1)
      RETURN
      END IF
      CALL g_rvy.clear()
      LET g_cnt = 1
      FOREACH i120_rvy_curs INTO g_rvy[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach i120_rvy_curs',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET g_rvy[g_cnt].rte03 = g_rte[l_ac].rte03
         LET g_rvy[g_cnt].rte03_n = g_rte[l_ac].rte03_desc
         SELECT gec02,gec04 INTO g_rvy[g_cnt].gec02,g_rvy[g_cnt].gec04
         FROM gec_file
         WHERE gec01 = g_rvy[g_cnt].rvy04 AND gec011 = '2' 
      LET g_cnt = g_cnt + 1    
      END FOREACH  
      CALL g_rvy.deleteElement(g_cnt)
      LET g_cnt = g_cnt - 1
   ELSE 
      DECLARE i120_rvy_curs1 CURSOR FOR
  #      SELECT rvy02,'','',rvy03,rvy04,'','',rvy06,rvyacti             #FUN-AA0037  mark
        SELECT rvy02,'','',rvy03,rvy04,'','',rvy06                      #FUN-AA0037
        FROM rvy_file
        WHERE rvy01 = g_rtd.rtd01
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare i120_rvy_curs1',SQLCA.sqlcode,1)
      RETURN
      END IF
      CALL g_rvy.clear()
      LET g_cnt = 1
      FOREACH i120_rvy_curs1 INTO g_rvy[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach i120_rvy_curs1',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         SELECT rte03 INTO g_rvy[g_cnt].rte03 FROM rte_file
          WHERE rte01 = g_rtd.rtd01 AND rte02 = g_rvy[g_cnt].rvy02
         SELECT ima02 INTO g_rvy[g_cnt].rte03_n FROM ima_file
         WHERE ima01 = g_rvy[g_cnt].rte03 
         SELECT gec02,gec04 INTO g_rvy[g_cnt].gec02,g_rvy[g_cnt].gec04 FROM gec_file
         WHERE gec01 = g_rvy[g_cnt].rvy04 AND gec011 = '2' 
     LET g_cnt = g_cnt + 1
     END FOREACH    
     CALL g_rvy.deleteElement(g_cnt)
     LET g_cnt = g_cnt - 1        
        
   END IF

   OPEN WINDOW i120_a_w WITH FORM "art/42f/arti120_a"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("arti120_a")
   DISPLAY g_cnt TO FORMONLY.cnt
    DISPLAY ARRAY g_rvy TO s_rvy.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
        IF g_rtd.rtdconf = 'N' THEN
           EXIT DISPLAY
        END IF
    END DISPLAY
     IF g_rtd.rtdconf <> 'N' THEN
        CLOSE WINDOW i120_a_w
        LET INT_FLAG = 0
        RETURN
     END IF
 #     LET g_forupd_sql = " SELECT rvy02,'','',rvy03,rvy04,'','',rvy06,rvyacti ",         #FUN-AA0037  mark
       LET g_forupd_sql = " SELECT rvy02,'','',rvy03,rvy04,'','',rvy06 ",         #FUN-AA0037
                        " FROM rvy_file ",
                        " WHERE rvy01 = '",g_rtd.rtd01,"'",
                        " AND rvy02 = ? AND rvy03 = ?",
                        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i120_rvy_bcl CURSOR FROM g_forupd_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare i120_rvy_bcl',SQLCA.sqlcode,1)
      CLOSE WINDOW i120_a_w
      RETURN
   END IF

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_rvy WITHOUT DEFAULTS FROM s_rvy.*
         ATTRIBUTE(COUNT=g_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
         BEFORE INPUT
           IF g_cnt != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
         BEFORE ROW
           LET l_ac1 = ARR_CURR()
           LET g_rvyk_sw = 'N'
           LET l_n  = ARR_COUNT()
           IF l_t = 'N' THEN
              BEGIN WORK
              OPEN i120_cl USING g_rtd.rtd01 
              IF STATUS THEN
                 CALL cl_err("OPEN i120_cl:", STATUS, 1)
                 CLOSE i120_cl
                 ROLLBACK WORK
                 EXIT INPUT
              END IF
              FETCH i120_cl INTO g_rtd.*            # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rtd.rtd01,SQLCA.sqlcode,0)      # 資料被他人lnvK
                 CLOSE i120_cl
                 ROLLBACK WORK
                 EXIT INPUT
              END IF
            END IF
            IF g_cnt >= l_ac1 THEN
              LET p_cmd = 'u'
              LET g_rvy_t.* = g_rvy[l_ac1].*
              OPEN i120_rvy_bcl USING  g_rvy_t.rvy02,g_rvy_t.rvy03
              IF STATUS THEN
                 CALL cl_err("OPEN i120_rvy_bcl:", STATUS, 1)
                 LET g_rvyk_sw = "Y"
              END IF
              FETCH i120_rvy_bcl INTO g_rvy[l_ac1].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_rvy_t.rvy02,SQLCA.sqlcode,1)
                 LET g_rvyk_sw = "Y"
              END IF
            IF g_cmd = 'a' THEN
               LET g_rvy[l_ac1].rte03 = g_rte[l_ac].rte03
               LET g_rvy[l_ac1].rte03_n = g_rte[l_ac].rte03_desc
            ELSE
              SELECT rte03 INTO g_rvy[l_ac1].rte03 FROM rte_file
               WHERE rte01 = g_rtd.rtd01 AND rte02 = g_rvy[l_ac1].rvy02
               IF NOT cl_null(g_rvy[l_ac1].rte03) THEN
                  SELECT ima02 INTO g_rvy[l_ac1].rte03_n FROM ima_file
                   WHERE ima01 = g_rvy[l_ac1].rte03
               END IF
            END IF
              SELECT gec02,gec04 INTO g_rvy[l_ac1].gec02,g_rvy[l_ac1].gec04 FROM gec_file
              WHERE gec01 = g_rvy[l_ac1].rvy04 AND gec011 = '2'
              LET g_before_input_done = FALSE
              CALL i120_rvy_set_entry_b()
              CALL i120_rvy_set_no_entry_b()
              LET g_before_input_done = TRUE
              CALL cl_show_fld_cont()
           END IF

           
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rvy[l_ac1].* TO NULL
           IF g_cmd='a' OR g_cmd = 'u' THEN
              LET g_rvy[l_ac1].rvy02 = g_rte[l_ac].rte02
              LET g_rvy[l_ac1].rte03 = g_rte[l_ac].rte03
              LET g_rvy[l_ac1].rte03_n = g_rte[l_ac].rte03_desc
              CALL cl_set_comp_entry("rvy02",FALSE)
           SELECT COUNT(rvy03) INTO l_cnt FROM rvy_file
            WHERE rvy01 =  g_rtd.rtd01
              AND rvy02 =  g_rte[l_ac].rte02
               IF l_cnt = 0 THEN
                  LET g_rvy[l_ac1].rvy03 = 1
               ELSE              
               SELECT MAX(rvy03)+1 INTO g_rvy[l_ac1].rvy03 FROM rvy_file
                WHERE rvy01 =  g_rtd.rtd01
                  AND rvy02 =  g_rte[l_ac].rte02
               END IF
               LET g_rvy[l_ac1].rvy06 = '0'
           END IF
       #    LET g_rvy[l_ac1].rvyacti = 'Y'             #FUN-AA0037 mark
           LET g_rvy_t.* = g_rvy[l_ac1].*
           LET g_before_input_done = FALSE
           CALL i120_rvy_set_entry_b()
           CALL i120_rvy_set_no_entry_b()
           LET g_before_input_done = TRUE
           CALL cl_show_fld_cont()
           NEXT FIELD rvy02
           
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              CANCEL INSERT
           END IF
#FUN-AB0039 ----------------STA
#      #     INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvy06,rvyacti)               #FUN-AA0037 mark
#            INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvy06)                       #FUN-AA0037
#           VALUES(g_rtd.rtd01,g_rvy[l_ac1].rvy02,g_rvy[l_ac1].rvy03,
#      #             g_rvy[l_ac1].rvy04,'2',g_rvy[l_ac1].rvy06,g_rvy[l_ac1].rvyacti)         #FUN-AA0037 mark
#                   g_rvy[l_ac1].rvy04,'2',g_rvy[l_ac1].rvy06)         #FUN-AA0037 
              INSERT INTO rvy_file(rvy01,rvy02,rvy03,rvy04,rvy05,rvy06,rvygrup,rvyorig,rvyoriu,rvyuser)
              VALUES(g_rtd.rtd01,g_rvy[l_ac1].rvy02,g_rvy[l_ac1].rvy03,
                   g_rvy[l_ac1].rvy04,'2',g_rvy[l_ac1].rvy06,g_grup,g_grup,g_user,g_user)
#FUN-AB0039 ----------------END 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","rvy_file",g_rtd.rtd01,g_rvy[l_ac1].rvy02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              IF l_t = 'N' THEN
                 COMMIT WORK
              END IF
              LET g_cnt = g_cnt + 1
              DISPLAY g_cnt TO FORMONLY.cnt
           END IF
          AFTER FIELD rvy02
              IF g_cmd = 'a' OR g_cmd = 'u' THEN
              ELSE
                 IF p_cmd = 'a' THEN                          #FUN-AB0039 add
                    SELECT rte03 INTO g_rvy[l_ac1].rte03 FROM rte_file
                     WHERE rte01 = g_rtd.rtd01 AND rte02 = g_rvy[l_ac1].rvy02
                    SELECT ima02 INTO g_rvy[l_ac1].rte03_n FROM ima_file
                     WHERE ima01 = g_rvy[l_ac1].rte03
                    SELECT COUNT(rvy03) INTO l_cnt FROM rvy_file
                     WHERE rvy01 =  g_rtd.rtd01
                       AND rvy02 =  g_rvy[l_ac1].rvy02
                    IF l_cnt = 0 THEN
                       LET g_rvy[l_ac1].rvy03 = 1
                    ELSE 
                       SELECT MAX(rvy03)+1 INTO g_rvy[l_ac1].rvy03 FROM rvy_file
                        WHERE rvy01 =  g_rtd.rtd01
                         AND rvy02 =  g_rvy[l_ac1].rvy02 
                    END IF                
                END IF                                         #FUN-AB0039 add
             END IF    
          AFTER FIELD rvy03
           IF NOT cl_null(g_rvy[l_ac1].rvy03) THEN
            IF g_rvy[l_ac1].rvy03 != g_rvy_t.rvy03 OR
                 g_rvy_t.rvy03 IS NULL THEN
              SELECT COUNT(*) INTO l_cnt FROM rvy_file
               WHERE rvy01 = g_rtd.rtd01
                AND rvy02 = g_rvy[l_ac1].rvy02
                AND rvy03 = g_rvy[l_ac1].rvy03
                IF l_cnt > 0 THEN
                   CALL cl_err(g_rvy[l_ac1].rvy03,'art-934',0)
                   LET g_rvy[l_ac1].rvy03 = g_rvy_t.rvy03
                   NEXT FIELD rvy03
                 END IF
              END IF
            END IF              
               
              

          AFTER FIELD rvy04
            IF NOT cl_null(g_rvy[l_ac1].rvy04) THEN
               IF g_rvy[l_ac1].rvy04 != g_rvy_t.rvy04 OR
                  g_rvy_t.rvy04 IS NULL THEN
           #     SELECT COUNT(gec01) INTO l_cnt  FROM gec_file                    #FUN-AB0039   mark
                 SELECT gecacti INTO l_gecacti FROM gec_file    #FUN-AB0039
                  WHERE gec01 = g_rvy[l_ac1].rvy04 
                   AND gec011 = '2'  
                  IF STATUS = 100 THEN
                     CALL cl_err(g_rvy[l_ac1].rvy04,'art-931',0)
                     LET g_rvy[l_ac1].rvy04 = g_rvy_t.rvy04
                     NEXT FIELD rvy04
                  ELSE
#FUN-AB0039 -----------------------STA
                     IF l_gecacti = 'N' THEN
                        CALL cl_err('','9028',0)
                        LET g_rvy[l_ac1].rvy04 = g_rvy_t.rvy04
                        NEXT FIELD rvy04
                     END IF
#FUN-AB0039 -----------------------END
                     SELECT COUNT(*) INTO l_cnt FROM rvy_file
                     WHERE rvy01 = g_rtd.rtd01
                       AND rvy02 = g_rvy[l_ac1].rvy02
                       AND rvy04 = g_rvy[l_ac1].rvy04
                     IF l_cnt >0 THEN
                       CALL cl_err(g_rvy[l_ac1].rvy04,'art-935',0)
                       LET g_rvy[l_ac1].rvy04 = g_rvy_t.rvy04
                       NEXT FIELD rvy04
                     ELSE 
                        SELECT gec02,gec04 INTO g_rvy[l_ac1].gec02,g_rvy[l_ac1].gec04
                          FROM gec_file 
                         WHERE gec01 = g_rvy[l_ac1].rvy04 
                           AND gec011 = '2'
                     END IF 
                  END IF                    
                 #TQC-C30076 add START
                 #CALL i120_chk_rte08(g_rvy[l_ac1].rvy02,'',g_rvy[l_ac1].rvy04,g_rvy[l_ac1].rvy06)    #FUN-D30050 mark
                  CALL i120_chk_rte08(g_rvy[l_ac1].rvy02,g_rvy[l_ac1].rte03,g_rvy[l_ac1].rvy04,g_rvy[l_ac1].rvy06)  #FUN-D30050 add
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_errno = ' '
                     NEXT FIELD rvy04 
                  END IF
                 #TQC-C30076 add END
               END IF
            END IF  

          AFTER FIELD rvy06
             IF g_rvy[l_ac1].rvy06 < 0 OR cl_null(g_rvy[l_ac1].rvy06) THEN
                CALL cl_err('','art-939',0)
                NEXT FIELD rvy06
             END IF                       #FUN-D30050 add
            #TQC-C30076 add START
            #CALL i120_chk_rte08(g_rvy[l_ac1].rvy02,'',g_rvy[l_ac1].rvy04,g_rvy[l_ac1].rvy06)     #FUN0-D30050 mark
             CALL i120_chk_rte08(g_rvy[l_ac1].rvy02,g_rvy[l_ac1].rte03,g_rvy[l_ac1].rvy04,g_rvy[l_ac1].rvy06)  #FUN-D30050 add
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_errno = ' '
                NEXT FIELD rvy06
             END IF
            #TQC-C30076 add END
             #END IF                      #FUN-D30050 mark

          BEFORE DELETE 
             SELECT COUNT(*) INTO l_cnt FROM rte_file
              WHERE rte01 = g_rtd.rtd01
                AND rte02 = g_rvy[l_ac1].rvy02
                AND rte08 = g_rvy[l_ac1].rvy04 
             IF g_cmd <> 'a' AND g_cmd <>'u' AND l_cnt>0 THEN
                 CALL cl_err('','art-933',0)
                 CANCEL DELETE
             END IF            
             IF g_rvy[l_ac1].rvy04 = g_rte[l_ac].rte08 AND (g_cmd = 'a' OR g_cmd = 'u') THEN
                 CALL cl_err('','art-933',0)
                 CANCEL DELETE
             END IF
            IF g_rvyk_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
            END IF
            IF  cl_confirm('lib-001') THEN
                   DELETE FROM rvy_file
                    WHERE rvy01 = g_rtd.rtd01
                      AND rvy02 =  g_rvy[l_ac1].rvy02
                      AND rvy03 =  g_rvy[l_ac1].rvy03
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","rvy_file",g_rtd.rtd01,g_rvy[l_ac1].rvy02,SQLCA.sqlcode,"","",1)
                      IF l_t = 'N' THEN
                         ROLLBACK WORK
                      END IF
                      CANCEL DELETE
                   END IF
                    LET g_cnt = g_cnt - 1
                    DISPLAY g_cnt TO FORMONLY.cnt
            ELSE 
                CANCEL DELETE
            END IF
            IF l_t = 'N' THEN
              COMMIT WORK
            END IF
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET g_rvy[l_ac1].* = g_rvy_t.*
              CLOSE i120_rvy_bcl
              IF l_t = 'N' THEN
                 ROLLBACK WORK
              END IF
              EXIT INPUT
           END IF
           IF g_rvyk_sw = 'Y' THEN
              CALL cl_err(g_rvy[l_ac1].rvy03,-263,1)
              LET g_rvy[l_ac1].* = g_rvy_t.*
           ELSE
             UPDATE rvy_file SET
                rvy01 = g_rtd.rtd01,
                rvy02 = g_rvy[l_ac1].rvy02,
                rvy03 = g_rvy[l_ac1].rvy03,
                rvy04 = g_rvy[l_ac1].rvy04,
                rvy05 = '2',
                rvy06 = g_rvy[l_ac1].rvy06
         #      rvyacti = g_rvy[l_ac1].rvyacti                  #FUN-AA0037  mark
#FUN-AB0039 ----------------------STA
               ,rvydate = g_today,
                rvymodu = g_user
#FUN-AB0039 ----------------------END
            WHERE rvy01 = g_rtd.rtd01
             AND rvy02 = g_rvy[l_ac1].rvy02
             AND rvy03 = g_rvy_t.rvy03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","rvy_file",g_rtd.rtd01,g_rvy[l_ac1].rvy02,SQLCA.sqlcode,'','',1)
                 LET g_rvy[l_ac1].* = g_rvy_t.*
                 IF l_t = 'N' THEN
                    ROLLBACK WORK
                 END IF
              ELSE
                 MESSAGE 'UPDATE O.K'
                 IF l_t = 'N' THEN
                    COMMIT WORK
                 END IF
              END IF
           END IF            
         AFTER ROW
           LET l_ac1 = ARR_CURR()
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET g_rvy[l_ac1].* = g_rvy_t.*
              CLOSE i120_rvy_bcl
              IF l_t = 'N' THEN
                 ROLLBACK WORK
              END IF
              EXIT INPUT
           END IF
           CLOSE i120_rvy_bcl
           IF l_t = 'N' THEN
              COMMIT WORK
           END IF
        ON ACTION controlp
            CASE
               WHEN INFIELD(rvy04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gec011"
                     LET g_qryparam.default1 = g_rvy[l_ac1].rvy04
                     CALL cl_create_qry() RETURNING g_rvy[l_ac1].rvy04
                     DISPLAY BY NAME g_rvy[l_ac1].rvy04                   
                    NEXT FIELD rvy04
              OTHERWISE EXIT CASE
            END CASE        
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CALL cl_err('',9001,0)
   END IF
   CLOSE i120_rvy_bcl
   IF l_t = 'N' THEN
      COMMIT WORK
   END IF
   CLOSE WINDOW i120_a_w        

        
          
END FUNCTION 

FUNCTION i120_rvy_set_entry_b()
   IF g_before_input_done = FALSE THEN
      CALL cl_set_comp_entry("rvy04,rvy06",TRUE)
 #     CALL cl_set_comp_required("rvy04,rvy06",FALSE)
   END IF   


END FUNCTION
FUNCTION  i120_rvy_set_no_entry_b()
DEFINE  l_cnt LIKE type_file.num5
    IF g_rvy[l_ac1].rvy04 = g_rte[l_ac].rte08 
    AND (g_cmd = 'a' OR g_cmd = 'u')  THEN
      CALL cl_set_comp_entry("rvy04",FALSE)
    ELSE
      CALL cl_set_comp_required("rvy04",TRUE)
    END IF 
    IF g_cmd = 'a' OR g_cmd = 'u' THEN
      CALL cl_set_comp_entry("rvy02",FALSE)
    END IF 
    SELECT COUNT(*) INTO l_cnt FROM rte_file
    WHERE rte01 = g_rtd.rtd01
      AND rte02 = g_rvy[l_ac1].rvy02
      AND rte08 = g_rvy[l_ac1].rvy04
    IF g_cmd <> 'a' AND g_cmd <>'u' AND l_cnt>0 THEN
       CALL cl_set_comp_entry("rvy04",FALSE)
    ELSE
      CALL cl_set_comp_required("rvy04",TRUE)
    END IF 
    IF g_rvy[l_ac1].gec04>0 THEN
       CALL cl_set_comp_entry("rvy06",FALSE)
    END IF   
     
END FUNCTION

#No.FUN-A90049 add start------------------
FUNCTION i120_ima120()
   DEFINE l_ima120 LIKE ima_file.ima120
   INITIALIZE l_ima120 TO NULL
   SELECT ima120 INTO l_ima120 FROM ima_file
    WHERE ima01 = g_rte[l_ac].rte03
   IF l_ima120 = '2' THEN
      CALL cl_set_comp_entry("rte04",FALSE)
   ELSE
      CALL cl_set_comp_entry("rte04",TRUE)
   END IF
END FUNCTION
#No.FUN-A90049 add end------------------


#No.FUN-A70132  ---end
#TQC-C30076 add START
FUNCTION i120_chk_rte08(p_rvy02,p_rte03,p_rvy04,p_rvy06)
DEFINE p_rvy02   LIKE rvy_file.rvy02
DEFINE p_rte03   LIKE rte_file.rte03
DEFINE p_rvy04   LIKE rvy_file.rvy04
DEFINE p_rvy06   LIKE rvy_file.rvy06
DEFINE l_n       LIKE type_file.num10
DEFINE l_rte03   LIKE rte_file.rte03
#DEFINE l_lpx26   LIKE lpx_file.lpx26  #FUN-D10040 mark
DEFINE l_lpx38    LIKE lpx_file.lpx38  #FUN-D10040 add
DEFINE l_lpx33   LIKE lpx_file.lpx33
DEFINE l_sql     STRING
DEFINE l_gec04   LIKE gec_file.gec04
   LET g_errno = ' '
   LET l_n = 0 
   IF cl_null(p_rte03) THEN 
      SELECT rte03 INTO l_rte03 
       FROM rte_file
         WHERE rte01 = g_rtd.rtd01
           AND rte02 = p_rvy02
   ELSE
      LET l_rte03 = p_rte03
   END IF
   IF cl_null(l_rte03) THEN
      RETURN
   END IF  
   IF cl_null(p_rvy04) THEN 
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n
         FROM lpx_file
         WHERE lpx32 = l_rte03 
   IF l_n > 0 THEN  #almi660內存在同產品料的資料
      #LET l_sql= "SELECT DISTINCT lpx26,lpx33 ",  #FUN-D10040 mark
      LET l_sql= "SELECT DISTINCT lpx38,lpx33 ",   #FUN-D10040 add
                 "  FROM lpx_file",
                 "    WHERE lpx32 = '",l_rte03,"'" 
      PREPARE i120_lpx_pre FROM l_sql
      DECLARE i120_lpx_cs CURSOR FOR i120_lpx_pre   
      #FOREACH i120_lpx_cs INTO l_lpx26,l_lpx33    #FUN-D10040 mark
      FOREACH i120_lpx_cs INTO l_lpx38,l_lpx33     #FUN-D10040 add
         #IF l_lpx26 = '1' THEN  #已開發票的禮券   #FUN-D10040 mark
         IF l_lpx38 = 'Y' THEN   #已開發票的禮券   #FUN-D10040 add
            IF NOT cl_null(p_rvy04) THEN
               IF p_rvy04 <> l_lpx33 THEN
                  LET g_errno = 'alm-h18'
                  RETURN
               END IF
            END IF 
         END IF
         #IF l_lpx26 = '2' THEN  #未開發票的禮券   #FUN-D10040 mark
         IF l_lpx38 = 'N' THEN   #已開發票的禮券   #FUN-D10040 add
            SELECT gec04 INTO l_gec04 
              FROM gec_file
               WHERE gec01 = p_rvy04
                 AND gec011 = '2' 
            IF NOT cl_null(l_gec04) AND l_gec04 > 0 THEN
               LET g_errno = 'alm-h17'
               RETURN
            END IF 
            IF NOT cl_null(p_rvy06) AND p_rvy06 > 0 THEN
               LET g_errno = 'alm-h17'
               RETURN
            END IF
         END IF
      END FOREACH
   END IF
END FUNCTION
#TQC-C30076 add END

