# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: artt700.4gl
# Descriptions...: 交款明細作業
# Date & Author..: NO.FUN-960130 08/09/03 By  Sunyanchun
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.TQC-A10032 10/01/09 By destiny 查询时上一笔资料会带到下一笔 
# Modify.........: No.TQC-A10121 10/01/18 By destiny 预收款栏位查询时上一笔资料会带到下一笔 
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30041 10/03/41 By Cockroach add oriu/orig
# Modify.........: No.FUN-A50071 10/05/19 By lixia 程序增加POS單號字段 并增加相应管控
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-B30028 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60061 11/06/08 By zhangll 增加控制：rxa05已退金額大于0才能審核
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.TQC-C20225 12/02/22 By yangxf mark掉alm-832此段报错逻辑.
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C80045 12/08/22 By nanbing 檢查POS單別，不允許在ERP中錄入
# Modify.........: No.TQC-C90016 12/09/06 By yangxf 审核时未带出审核人名称
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20015 13/03/27 By minpp 將確認人，確認日期改為確認異動人員，確認異動日期，取消審核時，回寫確認異動人員及日期
# Modify.........: No:FUN-D30097 13/04/01 By Sakura 訂金退回單據優化

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rxa         RECORD LIKE rxa_file.*,
       g_rxa_t       RECORD LIKE rxa_file.*,
       g_rxa_o       RECORD LIKE rxa_file.*,
       g_rxa01_t     LIKE rxa_file.rxa01,
       g_rxaplant_t    LIKE rxa_file.rxaplant,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rxb         DYNAMIC ARRAY OF RECORD
           rxb02          LIKE rxb_file.rxb02,
           rxb03          LIKE rxb_file.rxb03,
           rxb04          LIKE rxb_file.rxb04,
           rxb05          LIKE rxb_file.rxb05,
           rxb05_desc     LIKE gen_file.gen02,
           rxb06          LIKE rxb_file.rxb06
                     END RECORD,
       g_sql         STRING,
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
DEFINE g_argv1             LIKE rxa_file.rxa01
DEFINE g_argv2             STRING 
DEFINE g_sum1              LIKE rxx_file.rxx04
DEFINE g_sum2              LIKE rxx_file.rxx04
DEFINE g_sum3              LIKE rxx_file.rxx04
DEFINE g_sum4              LIKE rxx_file.rxx04
DEFINE g_sum5              LIKE rxx_file.rxx04
DEFINE g_sum               LIKE rxx_file.rxx04
DEFINE g_sum6              LIKE rxx_file.rxx04
DEFINE g_sum7              LIKE rxx_file.rxx04

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
 
   LET g_forupd_sql = "SELECT * FROM rxa_file WHERE rxa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t700_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t700_w AT p_row,p_col WITH FORM "art/42f/artt700"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("rxa08",g_aza.aza88 = 'Y')  #No.FUN-A50071 
   IF NOT cl_null(g_argv1) THEN
      CALL t700_q()
   END IF
 
   CALL t700_menu()
   CLOSE WINDOW t700_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t700_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rxb.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rxa01 = '",g_argv1,"' AND rxaplant = '",g_argv2,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rxa.* TO NULL
      CONSTRUCT BY NAME g_wc ON rxa01,rxa09,rxa02,rxa03,rxa04,rxa05,rxa06,                #FUN-D30097 add rxa09
 #                               rxaconf,rxacond,rxaconu,rxacont,rxamksg,rxa900,          #FUN-B30028 mark
                                rxaconf,rxacond,rxaconu,rxacont,                          #FUN-B30028
                                rxaplant,rxa07,rxa08,rxauser,
                                rxagrup,rxamodu,rxadate,rxaacti,
                                rxacrat,rxaoriu,rxaorig     #TQC-A30041 ADD #FUN-A50010 add rxa08
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rxa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxa01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxa01
                  NEXT FIELD rxa01
      
               WHEN INFIELD(rxa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxa02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxa02
                  NEXT FIELD rxa02
                  
               WHEN INFIELD(rxa03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxa03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxa03
                  NEXT FIELD rxa03
       
               WHEN INFIELD(rxaconu)                                                                                      
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rxaconu"
                  LET g_qryparam.arg1 = g_plant                                                                           
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rxaconu                                                                              
                  NEXT FIELD rxaconu
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
   #      LET g_wc = g_wc clipped," AND rxauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND rxagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND rxagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxauser', 'rxagrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON rxb02,rxb03,rxb04,rxb05,rxb06
              FROM s_rxb[1].rxb02,s_rxb[1].rxb03,s_rxb[1].rxb04,
                   s_rxb[1].rxb05,s_rxb[1].rxb06
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rxb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxb03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxb03
                  NEXT FIELD rxb03
                  
               WHEN INFIELD(rxb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxb05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxb05
                  NEXT FIELD rxb05
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
      LET g_sql = "SELECT rxa01,rxaplant FROM rxa_file ",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY rxa01"
   ELSE
      LET g_sql = "SELECT UNIQUE rxa01,rxaplant ",
                  "  FROM rxa_file, rxb_file ",
                  " WHERE rxa01 = rxb01 ",   
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rxa01"
   END IF
 
   PREPARE t700_prepare FROM g_sql
   DECLARE t700_cs
       SCROLL CURSOR WITH HOLD FOR t700_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rxa_file WHERE ",
                 g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM rxa_file,rxb_file WHERE ",
                " rxb01=rxa01 AND ",
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t700_precount FROM g_sql
   DECLARE t700_count CURSOR FOR t700_precount
 
END FUNCTION
 
FUNCTION t700_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t700_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t700_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t700_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t700_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t700_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t700_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t700_copy()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t700_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL t700_yes()
            END IF
         
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
                  CALL t700_no()
            END IF
            
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t700_void(1)
            END IF
         #FUN-D20039 ----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t700_void(2)
            END IF
         #FUN-D20039 ----------end
         WHEN "exit_money"
            IF cl_chk_act_auth() THEN
               CALL t700_pay()
            END IF
    
         WHEN "money_detail"
            IF cl_chk_act_auth() THEN
               CALL s_pay_detail('04',g_rxa.rxa01,g_rxa.rxaplant,g_rxa.rxaconf)
            END IF
            
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxb),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rxa.rxa01 IS NOT NULL THEN
                 LET g_doc.column1 = "rxa01"
                 LET g_doc.value1 = g_rxa.rxa01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rxb TO s_rxb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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
         CALL t700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
 
      ON ACTION exit_money
         LET g_action_choice="exit_money"
         EXIT DISPLAY
 
      ON ACTION money_detail
         LET g_action_choice = "money_detail"
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
#退款
FUNCTION t700_pay()
DEFINE l_rxx04    LIKE rxx_file.rxx04
 
   IF g_rxa.rxa01 IS NULL AND g_rxa.rxaplant IS NULL THEN 
      CALL cl_err('',-400,1) 
      RETURN 
   END IF
 
   IF g_rxa.rxaacti = 'N' THEN
      CALL cl_err('','mfg1000',0)
      RETURN
   END IF
      
   CALL t700_rxa05()
   IF g_rxa.rxa06 != g_rxa_t.rxa06 AND g_rxa.rxaconf = 'N' THEN
      UPDATE rxa_file SET rxa04 = g_rxa.rxa04,rxa05 = g_rxa.rxa05,rxa06 = g_rxa.rxa06
         WHERE rxa01 = g_rxa.rxa01
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","rxa_file","","",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
      LET g_rxa_t.* = g_rxa.*
      CALL cl_err('','art-908',1)
   END IF
   CALL s_pay('04',g_rxa.rxa01,g_rxa.rxaplant,g_rxa.rxa06,g_rxa.rxaconf)                                                
   CALL t700_compute_money() 
   #CALL t700_upd_money()
   #SELECT * INTO g_rxa.* FROM rxa_file WHERE rxa01 = g_rxa.rxa01 
   #   AND rxaplant = g_rxa.rxaplant
   #DISPLAY BY NAME g_rxa.rxa04,g_rxa.rxa05,g_rxa.rxa06
 
END FUNCTION                                                                                     
FUNCTION t700_no()
DEFINE l_i  LIKE type_file.num5  #dongbg add
DEFINE l_rxaconu  LIKE rxa_file.rxaconu        #CHI-D20015
DEFINE l_gen02    LIKE gen_file.gen02          #CHI-D20015
   IF g_rxa.rxa01 IS NULL OR g_rxa.rxaplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF

   #No.FUN-A50071 -----start---------   
   #-->POS單號不為空時不可取消確認
   IF NOT cl_null(g_rxa.rxa08) THEN
      CALL cl_err(' ','axm-743',0)
      RETURN
   END IF 
   #No.FUN-A50071 -----end---------
   
   SELECT * INTO g_rxa.* FROM rxa_file 
       WHERE rxa01=g_rxa.rxa01 
       
   IF g_rxa.rxaconf = 'N' THEN RETURN END IF
   IF g_rxa.rxaconf = 'X' THEN CALL cl_err(g_rxa.rxa01,'9024',0) RETURN END IF  
   #dongbg add 判此退回是否生axrt400据
   SELECT COUNT(*) INTO l_i FROM ooa_file
    WHERE ooa35 = '3' AND ooa36 = g_rxa.rxa01
   IF l_i > 0 THEN
      CALL cl_err('','art-577',0)
      RETURN
   END IF
 
   #End
   
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   OPEN t700_cl USING g_rxa.rxa01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t700_cl INTO g_rxa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
      CLOSE t700_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
  
   LET l_rxaconu = TIME      #CHI-D20015 
   UPDATE rxa_file SET rxaconf='N',
                      #CHI-D20015---mod--str
                      #rxacond=NULL, 
                      #rxaconu=NULL,
                      #rxacont=''     
                       rxacond=g_today,
                       rxaconu=g_user,
                       rxacont=l_rxaconu
                       #CHI-D20015---mod---end
     WHERE rxa01=g_rxa.rxa01 AND rxaplant = g_rxa.rxaplant
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rxa_file","","",SQLCA.sqlcode,"","",1)
      LET g_success='N'
   END IF
   
   IF g_success = 'Y' THEN
      LET g_rxa.rxaconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_rxa.rxa01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   
   SELECT * INTO g_rxa.* FROM rxa_file WHERE rxa01=g_rxa.rxa01 AND rxaplant=g_rxa.rxaplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rxa.rxaconu    #CHI-D20015 
   DISPLAY BY NAME g_rxa.rxaconf                                                                                         
   DISPLAY BY NAME g_rxa.rxacond                                                                                         
   DISPLAY BY NAME g_rxa.rxaconu
   DISPLAY BY NAME g_rxa.rxacont     
  #DISPLAY ''TO FORMONLY.rvaconu_desc           #TQC-C90016 add   #CHI-D20015
   DISPLAY l_gen02 TO FORMONLY.rvaconu_desc                       #CHI-D20015
    #CKP
   IF g_rxa.rxaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxa.rxaconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxa.rxa01,'V')
END FUNCTION
FUNCTION t700_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_rxa05    LIKE rxa_file.rxa05
DEFINE l_rxa01    LIKE rxa_file.rxa01
DEFINE l_exit_sum LIKE rxx_file.rxx04
DEFINE l_rxx04_1  LIKE rxx_file.rxx04
DEFINE l_rxx04_2  LIKE rxx_file.rxx04
DEFINE l_rxacont  LIKE rxa_file.rxacont     

   IF g_rxa.rxa01 IS NULL OR g_rxa.rxaplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
#CHI-C30107 -------------- add -------------- begin
   IF g_rxa.rxaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxa.rxaconf = 'X' THEN CALL cl_err(g_rxa.rxa01,'9024',0) RETURN END IF
   IF g_rxa.rxaacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 -------------- add -------------- end
   SELECT * INTO g_rxa.* FROM rxa_file 
       WHERE rxa01=g_rxa.rxa01
   IF g_rxa.rxaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxa.rxaconf = 'X' THEN CALL cl_err(g_rxa.rxa01,'9024',0) RETURN END IF 
   IF g_rxa.rxaacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
#  IF g_rxa.rxa05 = 0 THEN CALL cl_err('','alm-832',0) RETURN END IF  #MOD-B60061 add  #TQC-C20225 mark
 
   #查詢當前訂單付的總訂金
   SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file 
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 
         AND rxx03 = '1' 
   #計算所有單的已經退的金額                                                                                                       
   LET g_sql = "SELECT DISTINCT rxa01 FROM rxa_file WHERE rxa02 = '",                                                              
               g_rxa.rxa02,"'",                                                                    
               " AND rxaconf = 'Y' "                                                                                               
   PREPARE t700_rxa3 FROM g_sql                                                                                                    
   DECLARE rxa_cs3 CURSOR FOR t700_rxa3                                                                                            
   LET l_exit_sum = 0                                                                                                              
                                                                                                                                    
   FOREACH rxa_cs3 INTO l_rxa01                                                                                                    
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
          EXIT FOREACH                                                                                                              
       END IF                                                                                                                       
       SELECT SUM(rxx04) INTO l_rxx04_1 FROM rxx_file                                                                               
           WHERE rxx00 = '04' AND rxx01 = l_rxa01                                                          
       IF cl_null(l_rxx04_1) THEN LET l_rxx04_1 = 0 END IF                                                                  
                                                                                                                                    
       LET l_exit_sum = l_rxx04_1 + l_exit_sum                                                                            
   END FOREACH                                                                                                                     
   IF cl_null(l_exit_sum) THEN LET l_exit_sum = 0 END IF
   
   SELECT SUM(rxx04) INTO l_rxx04_2 FROM rxx_file WHERE rxx00 = '04'
      AND rxx01 = g_rxa.rxa01 
   IF l_rxx04_2 IS NULL THEN LET l_rxx04_2 = 0 END IF
   #TQC-C20225 add begin ----
   IF cl_null(l_rxx04_2) OR l_rxx04_2 = 0 THEN
      CALL cl_err(g_rxa.rxa01,'art1053',0)
      RETURN
   END IF
   #TQC-C20225 add end ------  
   IF l_exit_sum + l_rxx04_2 > l_rxx04 THEN
      CALL cl_err('','art-262',1)
      RETURN
   END IF
 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t700_cl USING g_rxa.rxa01
   
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t700_cl INTO g_rxa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
      CLOSE t700_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   LET l_rxacont=TIME    
   UPDATE rxa_file SET rxaconf='Y',
                       rxacond=g_today, 
                       rxaconu=g_user,
                       rxacont=l_rxacont  
     WHERE rxa01=g_rxa.rxa01
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rxa_file","","",SQLCA.sqlcode,"","",1)
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rxa.rxaconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rxa.rxa01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rxa.* FROM rxa_file WHERE rxa01=g_rxa.rxa01 AND rxaplant=g_rxa.rxaplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxa.rxaconu
   DISPLAY BY NAME g_rxa.rxaconf                                                                                         
   DISPLAY BY NAME g_rxa.rxacond                                                                                         
   DISPLAY BY NAME g_rxa.rxaconu
  #DISPLAY l_gen02 TO FORMONLY.rxaconu_desc           #TQC-C90016 mark
   DISPLAY l_gen02 TO FORMONLY.rvaconu_desc           #TQC-C90016 add
   DISPLAY BY NAME g_rxa.rxacont         
    #CKP
   IF g_rxa.rxaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxa.rxaconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxa.rxa01,'V')
END FUNCTION
 
FUNCTION t700_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
DEFINE l_rxacont  LIKE rxa_file.rxacont  
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rxa.* FROM rxa_file 
       WHERE rxa01=g_rxa.rxa01 AND rxaplant = g_rxa.rxaplant
       
   IF g_rxa.rxa01 IS NULL OR g_rxa.rxaplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rxa.rxaconf ='X' THEN RETURN END IF
    ELSE
       IF g_rxa.rxaconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_rxa.rxaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxa.rxaacti = 'N' THEN CALL cl_err(g_rxa.rxa01,'art-142',0) RETURN END IF
  #IF g_rxa.rxaconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF    #FUN-D20039 mark
   
   BEGIN WORK
 
   OPEN t700_cl USING g_rxa.rxa01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t700_cl INTO g_rxa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rxa.rxaconf) THEN
      LET g_chr = g_rxa.rxaconf
      IF g_rxa.rxaconf = 'N' THEN
         LET g_rxa.rxaconf = 'X'
      ELSE
         LET g_rxa.rxaconf = 'N'
      END IF
      LET l_rxacont=TIME   
      UPDATE rxa_file SET rxaconf=g_rxa.rxaconf,
                          rxamodu=g_user,
                          rxadate=g_today,
                          rxacont=l_rxacont    
       WHERE rxa01 = g_rxa.rxa01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rxa_file",g_rxa.rxa01,"",SQLCA.sqlcode,"","up rxaconf",1)
          LET g_rxa.rxaconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t700_cl
   COMMIT WORK
 
   SELECT * INTO g_rxa.* FROM rxa_file WHERE rxa01=g_rxa.rxa01
   DISPLAY BY NAME g_rxa.rxaconf                                                                                        
   DISPLAY BY NAME g_rxa.rxamodu                                                                                        
   DISPLAY BY NAME g_rxa.rxadate
   DISPLAY BY NAME g_rxa.rxacont    
    #CKP
   IF g_rxa.rxaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxa.rxaconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxa.rxa01,'V')
END FUNCTION
FUNCTION t700_bp_refresh()
  DISPLAY ARRAY g_rxb TO s_rxb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t700_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
  
   MESSAGE ""
   CLEAR FORM
   CALL g_rxb.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rxa.* LIKE rxa_file.*
   LET g_rxa01_t = NULL
   LET g_rxaplant_t = NULL 
   LET g_rxa_t.* = g_rxa.*
   LET g_rxa_o.* = g_rxa.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rxa.rxauser=g_user
      LET g_rxa.rxaoriu = g_user #FUN-980030
      LET g_rxa.rxaorig = g_grup #FUN-980030
      LET g_data_plant =g_plant  #TQC-A10128 ADD
      LET g_rxa.rxagrup=g_grup
      LET g_rxa.rxaacti='Y'
      LET g_rxa.rxacrat = g_today
      LET g_rxa.rxaconf = 'N'
      LET g_rxa.rxacont = '00:00:00'     #No.TQC-A10121
      LET g_rxa.rxacond = NULL  #No.TQC-A10032
      LET g_rxa.rxamksg = 'N'
      LET g_rxa.rxa900 = '0'
      LET g_rxa.rxaplant = g_plant
      LET g_rxa.rxalegal = g_legal
      LET g_rxa.rxa09 = g_today #FUN-D30097 add 
      DISPLAY g_rxa.rxacont TO rxacont 
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rxa.rxaplant
      DISPLAY l_azp02 TO rxaplant_desc
 
      CALL t700_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rxa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rxa.rxa01) OR cl_null(g_rxa.rxaplant)THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rxa.rxa01,g_today,"","rxa_file","rxa01,rxaplant","","","")  #FUN-A70130 mark                                     
     #CALL s_auto_assign_no("art",g_rxa.rxa01,g_today,"B6","rxa_file","rxa01,rxaplant","","","")  #FUN-A70130 mod     #FUN-D30097 mark                                
      CALL s_auto_assign_no("art",g_rxa.rxa01,g_rxa.rxa09,"B6","rxa_file","rxa01,rxaplant","","","")  #FUN-A70130 mod #FUN-D30097 add                                    
          RETURNING li_result,g_rxa.rxa01                                                                                           
      IF (NOT li_result) THEN                                                                                                      
         CONTINUE WHILE                                                                                                           
      END IF                                                                                                                       
      DISPLAY BY NAME g_rxa.rxa01
      INSERT INTO rxa_file VALUES (g_rxa.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rxa_file",g_rxa.rxa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK          # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rxa.rxa01,'I')
      END IF
 
      LET g_rxa01_t = g_rxa.rxa01
      LET g_rxaplant_t = g_rxa.rxaplant
      LET g_rxa_t.* = g_rxa.*
      LET g_rxa_o.* = g_rxa.*
      CALL t700_ins_detail()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#在單身中插入資料
FUNCTION t700_ins_detail()
DEFINE l_rxy01      LIKE rxy_file.rxy01
DEFINE l_rxy05      LIKE rxy_file.rxy05
DEFINE l_rxb02      LIKE rxb_file.rxb02
DEFINE l_ogaconf    LIKE oga_file.ogaconf
DEFINE l_ogaconu    LIKE oga_file.ogaconu
DEFINE l_ogacond    LIKE oga_file.ogacond
DEFINE l_oeaconf    LIKE oea_file.oeaconf
 
    LET g_sql = " SELECT rxy01,rxy05 FROM rxy_file ",
                " WHERE rxy00 = '02' AND rxy03 = '07' AND ",
                " rxy04 = '1' AND rxy06 = '",g_rxa.rxa02,
                "' AND rxy19 = '1' "
 
    PREPARE t700_rxy FROM g_sql
    DECLARE t700_rxy_cur CURSOR FOR t700_rxy
 
    FOREACH t700_rxy_cur INTO l_rxy01,l_rxy05
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT oeaconf INTO l_oeaconf FROM oea_file WHERE oea01 = g_rxa.rxa02
       IF l_oeaconf = 'X' THEN CONTINUE FOREACH END IF
       #項次自動加1
       SELECT MAX(rxb02) INTO l_rxb02 FROM rxb_file
          WHERE rxb01 = g_rxa.rxa01 
       IF cl_null(l_rxb02) THEN LET l_rxb02 = 0 END IF
       LET l_rxb02 = l_rxb02 + 1
      
       #抓出貨單的審核人和審核日期---->衝帳人和衝帳日期
       SELECT ogaconf,ogaconu,ogacond INTO l_ogaconf,l_ogaconu,l_ogacond FROM oga_file
          WHERE oga01 = l_rxy01 
       IF l_ogaconf = 'X' THEN CONTINUE FOREACH END IF
 
       INSERT INTO rxb_file(rxb01,rxb02,rxb03,rxb04,rxb05,rxb06,rxblegal,rxbplant)
                     VALUES(g_rxa.rxa01,l_rxb02,l_rxy01,l_ogacond,
                            l_ogaconu,l_rxy05,g_rxa.rxalegal,g_rxa.rxaplant)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("ins","rxa_file",g_rxa.rxa01,"",SQLCA.sqlcode,"","",1)
          DELETE FROM rxa_file WHERE rxa01 = g_rxa.rxa01
          EXIT FOREACH
       END IF
    END FOREACH
    CALL t700_b_fill('1=1')
END FUNCTION
 
FUNCTION t700_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxa.rxa01 IS NULL OR g_rxa.rxaplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rxa.* FROM rxa_file
    WHERE rxa01=g_rxa.rxa01 
 
   IF g_rxa.rxaacti ='N' THEN
      CALL cl_err(g_rxa.rxa01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rxa.rxaconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rxa.rxaconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rxa01_t = g_rxa.rxa01
   LET g_rxaplant_t = g_rxa.rxaplant
   
   BEGIN WORK
 
   OPEN t700_cl USING g_rxa.rxa01
 
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t700_cl INTO g_rxa.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t700_show()
 
   WHILE TRUE
      LET g_rxa01_t = g_rxa.rxa01
      LET g_rxaplant_t = g_rxa.rxaplant
      LET g_rxa_o.* = g_rxa.*
      LET g_rxa.rxamodu=g_user
      LET g_rxa.rxadate=g_today
 
      CALL t700_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rxa.*=g_rxa_t.*
         CALL t700_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rxa.rxa01 != g_rxa01_t THEN
         UPDATE rxb_file SET rxb01 = g_rxa.rxa01
           WHERE rxb01 = g_rxa01_t  
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxb_file",g_rxa01_t,"",SQLCA.sqlcode,"","rxb",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rxa_file SET rxa_file.* = g_rxa.*
       WHERE rxa01 = g_rxa.rxa01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rxa_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t700_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rxa.rxa01,'U')
 
   CALL t700_b_fill("1=1")
   CALL t700_bp_refresh()
 
END FUNCTION
 
FUNCTION t700_i(p_cmd)
DEFINE
   l_pmc05     LIKE pmc_file.pmc05,
   l_pmc30     LIKE pmc_file.pmc30,
   l_n         LIKE type_file.num5,
   p_cmd       LIKE type_file.chr1,
   li_result   LIKE type_file.num5
DEFINE l_cnt   LIKE type_file.num5 #FUN-C80045 add 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rxa.rxa01,g_rxa.rxa09,g_rxa.rxa02,g_rxa.rxa03,g_rxa.rxa04, #FUN-D30097 add rxa09
                   g_rxa.rxa05,g_rxa.rxa06,g_rxa.rxaconf,
#FUN-B30028 ----------------STA
#                  g_rxa.rxacond,g_rxa.rxaconu,g_rxa.rxacont,g_rxa.rxamksg, 
#                  g_rxa.rxa900,g_rxa.rxaplant,g_rxa.rxa07,g_rxa.rxa08,
                   g_rxa.rxacond,g_rxa.rxaconu,g_rxa.rxacont,
                   g_rxa.rxaplant,g_rxa.rxa07,g_rxa.rxa08,
#FUN-B30028 ----------------END
                   g_rxa.rxauser,g_rxa.rxamodu,g_rxa.rxagrup,
                   g_rxa.rxadate,g_rxa.rxaacti,g_rxa.rxacrat
                  ,g_rxa.rxaoriu,g_rxa.rxaorig          #TQC-A30041 ADD #FUN-A50071 add rxa08
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rxa.rxa01,g_rxa.rxa09,g_rxa.rxa02,g_rxa.rxa03,g_rxa.rxa04, g_rxa.rxaoriu,g_rxa.rxaorig, #FUN-D30097 add rxa09
#                 g_rxa.rxa05,g_rxa.rxa06,g_rxa.rxamksg,g_rxa.rxa07,g_rxa.rxa08,      #FUN-B30028  mark
                 g_rxa.rxa05,g_rxa.rxa06,g_rxa.rxa07,g_rxa.rxa08,                     #FUN-B30028 
                 g_rxa.rxaconf,g_rxa.rxacond,
                 g_rxa.rxaconu,g_rxa.rxauser,
                 g_rxa.rxamodu,g_rxa.rxaacti,g_rxa.rxagrup,  #FUN-A50071 add rxa08
                 g_rxa.rxadate,g_rxa.rxacrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t700_set_entry(p_cmd)
         CALL t700_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rxa01")
 
      AFTER FIELD rxa01
         IF NOT cl_null(g_rxa.rxa01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxa.rxa01 != g_rxa_t.rxa01) THEN
               #FUN-C80045 add sta
               LET g_t1=s_get_doc_no(g_rxa.rxa01)
               SELECT COUNT(*) INTO l_cnt FROM  rye_file WHERE rye04 = g_t1 AND ryeacti = 'Y' AND rye01 = 'art'
               IF l_cnt > 0 THEN
                  CALL cl_err(g_t1,'apc1036',0)
                  NEXT FIELD rxa01
               END IF
               #FUN-C80045 add end
#              CALL s_check_no("axm",g_rxa.rxa01,g_rxa01_t,"B6","rxa_file","rxa01","") #FUN-A70130 mark                                    
               CALL s_check_no("art",g_rxa.rxa01,g_rxa01_t,"B6","rxa_file","rxa01","") #FUN-A70130 mod                                    
                    RETURNING li_result,g_rxa.rxa01                                                                                 
               IF (NOT li_result) THEN                                                                                            
                   LET g_rxa.rxa01=g_rxa01_t                                                                                   
                   NEXT FIELD rxa01                                                                                                
               END IF
            END IF
         END IF
         
      AFTER FIELD rxa02
         IF NOT cl_null(g_rxa.rxa02) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxa.rxa02 != g_rxa_t.rxa02) THEN
              #CALL t700_rxa02()              #No.TQC-A10032
               CALL t700_rxa02('a')           #No.TQC-A10032
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                        
                  NEXT FIELD rxa02                                                                                                  
               END IF
               CALL t700_rxa05()
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
            WHEN INFIELD(rxa01)
               LET g_t1=s_get_doc_no(g_rxa.rxa01)                                                                                  
               CALL q_oay(FALSE,FALSE,g_t1,'B6','art') RETURNING g_t1      #FUN-A70130                                                          
               LET g_rxa.rxa01 = g_t1                                                                                               
               DISPLAY BY NAME g_rxa.rxa01                                                                                         
               NEXT FIELD rxa01
                
            WHEN INFIELD(rxa02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oea01_1"
               LET g_qryparam.arg1 = g_plant
               LET g_qryparam.default1 = g_rxa.rxa02
               CALL cl_create_qry() RETURNING g_rxa.rxa02
               DISPLAY BY NAME g_rxa.rxa02
               CALL t700_rxa02('a')
               CALL t700_rxa05()
               NEXT FIELD rxa02
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
FUNCTION t700_rxa02(p_cmd)
DEFINE l_cnt     LIKE type_file.num5
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_oea02   LIKE oea_file.oea02 #FUN-D30097 add
DEFINE l_oea72   LIKE oea_file.oea72
DEFINE l_oeaconu   LIKE oea_file.oeaconu
DEFINE l_oea93   LIKE oea_file.oea93
DEFINE l_oea87   LIKE oea_file.oea87
DEFINE l_oeb70   LIKE oeb_file.oeb70
DEFINE l_oea92   LIKE oea_file.oea92
DEFINE l_occ02   LIKE occ_file.occ02
DEFINE l_gen02   LIKE gen_file.gen02
DEFINE l_oeaconf LIKE oea_file.oeaconf
 
    LET l_cnt = 0
    LET g_errno = '' 
 
    SELECT oeaconf INTO l_oeaconf FROM oea_file WHERE oea01 = g_rxa.rxa02
 
    IF l_oeaconf <> 'Y' THEN
       LET g_errno = 'art-260'
       RETURN
    END IF
   
    LET g_sql = "SELECT oeb70 FROM oeb_file WHERE oeb01 = '",g_rxa.rxa02,"'"
    PREPARE t700_oeb FROM g_sql                                                                                                 
    DECLARE t121_oeb CURSOR FOR t700_oeb
    FOREACH t121_oeb INTO l_oeb70
       IF SQLCA.SQLCODE THEN                                                                                                        
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)                                                                                    
         EXIT FOREACH                                                                                                               
       END IF
       IF l_oeb70 = 'N' OR l_oeb70 IS NULL THEN
          LET g_errno = 'art-257'
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt + 1
    END FOREACH
    IF l_cnt = 0 AND cl_null(g_errno) THEN 
       LET g_errno = 'art-258'
    END IF
    IF NOT cl_null(g_errno) AND p_cmd='a' THEN 
       RETURN
    END IF 
    SELECT oea03,oea72,oea02,oeaconu,oea92,oea93,oea87 #FUN-D30097 add oea02
        INTO g_rxa.rxa03,l_oea72,l_oea02,l_oeaconu,l_oea92,l_oea93,l_oea87 #FUN-D30097 add oea02 
        FROM oea_file WHERE oea01 = g_rxa.rxa02
        
    DISPLAY BY NAME g_rxa.rxa03
    DISPLAY l_oea02 TO oea02 #FUN-D30097 add
    DISPLAY l_oea72 TO oea72
    DISPLAY l_oeaconu TO oeaconu
    DISPLAY l_oea93 TO oea93
    DISPLAY l_oea87 TO oea87
    DISPLAY l_oea92 TO oea92
    
    SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_rxa.rxa03
    DISPLAY l_occ02 TO FORMONLY.rxa03_desc
    
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01= l_oeaconu
    DISPLAY l_gen02 TO FORMONLY.oeaconu_desc     
    CALL t700_compute_money()
END FUNCTION 
#得到畫面上各項金額
FUNCTION t700_compute_money()
DEFINE l_rxx04     LIKE rxx_file.rxx04
DEFINE l_rxa01     LIKE rxa_file.rxa01
DEFINE l_exit_sum  LIKE rxx_file.rxx04
 
    #查詢已經收取現金金額
    LET g_sum1 = ''
    SELECT rxx04 INTO g_sum1 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '01' 
    IF cl_null(g_sum1) THEN LET g_sum1 = 0 END IF
    DISPLAY g_sum1 TO FORMONLY.sum1
 
    #查詢已經收取支票的金額
    LET g_sum2 = ''
    SELECT rxx04 INTO g_sum2 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '03'
    IF cl_null(g_sum2) THEN LET g_sum2 = 0 END IF
    DISPLAY g_sum2 TO FORMONLY.sum2
 
    #查詢已經收取銀聯卡的金額
    LET g_sum3 = ''
    SELECT rxx04 INTO g_sum3 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '02'
    IF cl_null(g_sum3) THEN LET g_sum3 = 0 END IF
    DISPLAY g_sum3 TO FORMONLY.sum3
 
    #查詢已經收取券的金額
    LET g_sum4 = ''
    SELECT rxx04 INTO g_sum4 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '04'
    IF cl_null(g_sum4) THEN LET g_sum4 = 0 END IF
    DISPLAY g_sum4 TO FORMONLY.sum4
 
    #查詢已經收取儲值卡的金額
    LET g_sum5 = ''
    SELECT rxx04 INTO g_sum5 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '06'
    IF cl_null(g_sum5) THEN LET g_sum5 = 0 END IF
    DISPLAY g_sum5 TO FORMONLY.sum5
 
    #查詢已經收取聯盟卡的金額
    LET g_sum6 = ''    #No.TQC-A10121
    SELECT rxx04 INTO g_sum6 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '05' 
    IF cl_null(g_sum6) THEN LET g_sum6 = 0 END IF
    DISPLAY g_sum6 TO FORMONLY.sum6 
  
    #查詢手工轉帳的金額
    LET g_sum7 = ''    #No.TQC-A10121
    SELECT rxx04 INTO g_sum7 FROM rxx_file
       WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02 AND rxx02 = '08'
    IF cl_null(g_sum7) THEN LET g_sum7 = 0 END IF 
    DISPLAY g_sum7 TO FORMONLY.sum7
 
    #計算該單已經退了的總金額                                                                                                       
    #SELECT SUM(rxx04) INTO g_rxa.rxa05 FROM rxx_file WHERE rxx00 = '04'                                                         
    #  AND rxx01 = g_rxa.rxa01 AND rxxplant = g_rxa.rxaplant
END FUNCTION
#計算已退金額、已衝金額、可退金額
FUNCTION t700_rxa05()
DEFINE l_rxa01      LIKE rxa_file.rxa01
DEFINE l_exit_sum   LIKE rxx_file.rxx04
DEFINE l_rxx04      LIKE rxx_file.rxx04
 
    #計算所有單的已經退的金額   
    LET g_sql = "SELECT DISTINCT rxa01 FROM rxa_file WHERE rxa02 = '",
                g_rxa.rxa02,"'",
                " AND rxaconf = 'Y' "
    PREPARE t700_rxa2 FROM g_sql
    DECLARE rxa_cs2 CURSOR FOR t700_rxa2
    LET l_exit_sum = 0
 
    FOREACH rxa_cs2 INTO l_rxa01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
           WHERE rxx00 = '04' AND rxx01 = l_rxa01 
       IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
 
       LET l_exit_sum = l_rxx04 + l_exit_sum
    END FOREACH
    IF cl_null(l_exit_sum) THEN LET l_exit_sum = 0 END IF
    LET g_rxa.rxa05 = l_exit_sum
 
    #計算訂金總額
    SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02
    IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
    
    #計算當前可退金額
    LET g_rxa.rxa06 = l_rxx04 - l_exit_sum
    
    #計算已經衝金額
    #SELECT SUM(rxb06) INTO g_rxa.rxa04 FROM rxb_file 
    #   WHERE rxb01 = g_rxa.rxa01 AND rxbplant = g_rxa.rxaplant
    SELECT SUM(rxy05) INTO g_rxa.rxa04 FROM rxy_file
        WHERE rxy00 = '02' AND rxy03 = '07' 
          AND rxy06 = g_rxa.rxa02
          AND rxy04 = '1'
    IF cl_null(g_rxa.rxa04) THEN LET g_rxa.rxa04 = 0 END IF 
 
    #計算當前可退金額
    LET g_rxa.rxa06 = l_rxx04 - l_exit_sum - g_rxa.rxa04
 
    DISPLAY BY NAME g_rxa.rxa04,g_rxa.rxa05,g_rxa.rxa06
END FUNCTION
#更新可退金額，已退金額
FUNCTION t700_upd_money()
DEFINE  l_rxx04       LIKE rxx_file.rxx04
DEFINE  l_exit_sum    LIKE rxx_file.rxx04
DEFINE  l_rxa01       LIKE rxa_file.rxa01
 
   #計算該單已經退了的總金額                                                                                                       
   SELECT SUM(rxx04) INTO g_rxa.rxa05 FROM rxx_file WHERE rxx00 = '04'                                                             
      AND rxx01 = g_rxa.rxa01                                                                             
   UPDATE rxa_file SET rxa05 = g_rxa.rxa05 WHERE rxa01 = g_rxa.rxa01                                                               
 
   #計算所有單的已經退的金額                                                                                                       
    LET g_sql = "SELECT DISTINCT rxa01 FROM rxa_file WHERE rxa02 = '",                                                              
                g_rxa.rxa02,"'",                                                                    
                " AND rxaconf = 'Y' "                                                                                               
    PREPARE t700_rxa1 FROM g_sql                                                                                                    
    DECLARE rxa_cs1 CURSOR FOR t700_rxa1                                                                                            
    LET l_exit_sum = 0                                                                                                              
                                                                                                                                    
    FOREACH rxa_cs1 INTO l_rxa01                                                                                                    
       IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
          EXIT FOREACH                                                                                                              
       END IF                                                                                                                       
       SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file                                                                                 
           WHERE rxx00 = '04' AND rxx01 = l_rxa01                                                          
       IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF                                                                              
                                                                                                                                    
       LET l_exit_sum = l_rxx04 + l_exit_sum                                                                                        
    END FOREACH                                                                                                                     
    IF cl_null(l_exit_sum) THEN LET l_exit_sum = 0 END IF
   
    #計算訂金總額                                                                                                                   
    SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file WHERE rxx00 = '01' AND rxx01 = g_rxa.rxa02                                         
    IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
    #計算當前可退金額                                                                                                               
    LET g_rxa.rxa06 = l_rxx04 - l_exit_sum                                                                                          
    UPDATE rxa_file SET rxa06 = g_rxa.rxa06 WHERE rxa01 = g_rxa.rxa01                                                               
END FUNCTION
FUNCTION t700_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rxb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t700_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rxa.* TO NULL
      RETURN
   END IF
 
   OPEN t700_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rxa.* TO NULL
   ELSE
      OPEN t700_count
      FETCH t700_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t700_fetch('F')
      CALL t700_rxa02('d')
   END IF
 
END FUNCTION
 
FUNCTION t700_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t700_cs INTO g_rxa.rxa01,g_rxa.rxaplant
      WHEN 'P' FETCH PREVIOUS t700_cs INTO g_rxa.rxa01,g_rxa.rxaplant
      WHEN 'F' FETCH FIRST    t700_cs INTO g_rxa.rxa01,g_rxa.rxaplant
      WHEN 'L' FETCH LAST     t700_cs INTO g_rxa.rxa01,g_rxa.rxaplant
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
        FETCH ABSOLUTE g_jump t700_cs INTO g_rxa.rxa01,g_rxa.rxaplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
      INITIALIZE g_rxa.* TO NULL
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
 
   SELECT * INTO g_rxa.* FROM rxa_file WHERE rxa01 = g_rxa.rxa01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rxa_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rxa.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rxa.rxauser
   LET g_data_group = g_rxa.rxagrup
   LET g_data_plant = g_rxa.rxaplant  #TQC-A10128 ADD
 
   CALL t700_show()
 
END FUNCTION
 
FUNCTION t700_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
 
   LET g_rxa_t.* = g_rxa.*
   LET g_rxa_o.* = g_rxa.*
   DISPLAY BY NAME g_rxa.rxa01,g_rxa.rxa09,g_rxa.rxa05,g_rxa.rxa02, g_rxa.rxaoriu,g_rxa.rxaorig, #FUN-D30097 add rxa09
#                   g_rxa.rxa06,g_rxa.rxa07,g_rxa.rxa08,g_rxa.rxamksg,g_rxa.rxa900,       #FUN-B30028 mark
                   g_rxa.rxa06,g_rxa.rxa07,g_rxa.rxa08,                                    #FUN-B30028
                   g_rxa.rxaplant, g_rxa.rxaconf,g_rxa.rxa03,g_rxa.rxacond,
                   g_rxa.rxa04,g_rxa.rxaconu,g_rxa.rxacont,g_rxa.rxauser,  
                   g_rxa.rxamodu,g_rxa.rxaacti,g_rxa.rxagrup,
                   g_rxa.rxadate,g_rxa.rxacrat   #FUN-A50071 add rxa08
 
   IF g_rxa.rxaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rxa.rxaconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rxa.rxa01,'V')
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rxa.rxaplant
   DISPLAY l_azp02 TO FORMONLY.rxaplant_desc
#TQC-C90016 add begin ---
   LET l_gen02 = ''
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxa.rxaconu
   DISPLAY l_gen02 TO FORMONLY.rvaconu_desc           
#TQC-C90016 add end ----
   CALL t700_rxa02('d')
   CALL t700_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t700_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxa.rxa01 IS NULL OR g_rxa.rxaplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rxa.rxaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxa.rxaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t700_cl USING g_rxa.rxa01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      RETURN
   END IF
 
   FETCH t700_cl INTO g_rxa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t700_show()
 
   IF g_rxa.rxaconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   #BEGIN WORK 
   IF cl_exp(0,0,g_rxa.rxaacti) THEN
      LET g_chr=g_rxa.rxaacti
      IF g_rxa.rxaacti='Y' THEN
         LET g_rxa.rxaacti='N'
      ELSE
         LET g_rxa.rxaacti='Y'
      END IF
 
      UPDATE rxa_file SET rxaacti=g_rxa.rxaacti,
                          rxamodu=g_user,
                          rxadate=g_today
       WHERE rxa01=g_rxa.rxa01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rxa_file",g_rxa.rxa01,"",SQLCA.sqlcode,"","",1) 
         LET g_rxa.rxaacti=g_chr
      END IF
   END IF
 
   CLOSE t700_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rxa.rxa01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rxaacti,rxamodu,rxadate
     INTO g_rxa.rxaacti,g_rxa.rxamodu,g_rxa.rxadate FROM rxa_file
    WHERE rxa01=g_rxa.rxa01 
   DISPLAY BY NAME g_rxa.rxaacti,g_rxa.rxamodu,g_rxa.rxadate
 
END FUNCTION
 
FUNCTION t700_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxa.rxa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rxa.* FROM rxa_file
    WHERE rxa01=g_rxa.rxa01
 
   IF g_rxa.rxaconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rxa.rxaconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rxa.rxaacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t700_cl USING g_rxa.rxa01
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t700_cl INTO g_rxa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxa.rxa01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t700_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rxa01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rxa.rxa01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rxa_file WHERE rxa01 = g_rxa.rxa01
      DELETE FROM rxb_file WHERE rxb01 = g_rxa.rxa01
      DELETE FROM rxx_file WHERE rxx00 = '04' AND rxx01 = g_rxa.rxa01 
      DELETE FROM rxy_file WHERE rxy00 = '04' AND rxy01 = g_rxa.rxa01
      DELETE FROM rxz_file WHERE rxz00 = '04' AND rxz01 = g_rxa.rxa01 
      CLEAR FORM
      CALL g_rxb.clear()
      OPEN t700_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t700_cs
         CLOSE t700_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t700_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t700_cs
         CLOSE t700_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t700_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t700_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t700_fetch('/')
      END IF
   END IF
 
   CLOSE t700_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rxa.rxa01,'D')
END FUNCTION
 
FUNCTION t700_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rxb02,rxb03,rxb04,rxb05,'',rxb06 ",
               "  FROM rxb_file",
               " WHERE rxb01 ='",g_rxa.rxa01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rxb02 "
 
   DISPLAY g_sql
 
   PREPARE t700_pb FROM g_sql
   DECLARE rxb_cs CURSOR FOR t700_pb
 
   CALL g_rxb.clear()
   LET g_cnt = 1
 
   FOREACH rxb_cs INTO g_rxb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT gen02 INTO g_rxb[g_cnt].rxb05_desc FROM gen_file
           WHERE gen01 = g_rxb[g_cnt].rxb05
  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rxb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t700_copy()
   DEFINE l_newno     LIKE rxa_file.rxa01,
          l_oldno     LIKE rxa_file.rxa01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
   DEFINE l_cnt       LIKE type_file.num5 #FUN-C80045 add
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rxa.rxa01 IS NULL OR g_rxa.rxaplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t700_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rxa01
 
       AFTER FIELD rxa01
          IF l_newno IS NULL THEN 
             NEXT FIELD rxa01
          ELSE
             #FUN-C80045 add sta
             LET g_t1=s_get_doc_no(l_newno)
             SELECT COUNT(*) INTO l_cnt FROM  rye_file WHERE rye04 = g_t1 AND ryeacti = 'Y' AND rye01 = 'art'
             IF l_cnt > 0 THEN
                CALL cl_err(g_t1,'apc1036',0)
                NEXT FIELD rxa01
             END IF
             #FUN-C80045 add end
#            CALL s_check_no("axm",l_newno,"","B6","rxa_file","rxa01","")    #FUN-A70130 mark                                                 
             CALL s_check_no("art",l_newno,"","B6","rxa_file","rxa01","")    #FUN-A70130 mod                                                 
                RETURNING li_result,l_newno                                                                                      
             IF (NOT li_result) THEN                                                                                                
                LET g_rxa.rxa01=g_rxa_t.rxa01                                                                                       
                NEXT FIELD rxa01                                                                                                    
             END IF
             BEGIN WORK                                                                                                             
#            CALL s_auto_assign_no("axm",l_newno,g_today,"","rxa_file","rxa01","","","") #FUN-A70130 mark                                           
            #CALL s_auto_assign_no("art",l_newno,g_today,"B6","rxa_file","rxa01","","","") #FUN-A70130 mod     #FUN-D30097 mark                                       
             CALL s_auto_assign_no("art",l_newno,g_rxa.rxa09,"B6","rxa_file","rxa01","","","") #FUN-A70130 mod #FUN-D30097 add                                          
                RETURNING li_result,l_newno                                                                                          
             IF (NOT li_result) THEN                                                                                                
                ROLLBACK WORK                                                                                                       
                NEXT FIELD rxa01                                                                                                    
             ELSE                                                                                                                   
                COMMIT WORK                                                                                                         
             END IF                                                                                                                  
             DISPLAY l_newno TO rxa01
          END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rxa01)
              LET g_t1=s_get_doc_no(l_newno)
              CALL q_oay(FALSE,FALSE,g_t1,'B6','art') RETURNING g_t1    #FUN-A70130
              LET l_newno = g_t1 
              DISPLAY l_newno TO rxa01
              NEXT FIELD rxa01
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
      DISPLAY BY NAME g_rxa.rxa01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rxa_file
       WHERE rxa01=g_rxa.rxa01 
       INTO TEMP y
 
   UPDATE y
       SET rxa01=l_newno,
           rxaconf = 'N',
           rxacond = NULL,
           rxaconu = NULL,
           rxauser=g_user,
           rxagrup=g_grup,
           rxaoriu=g_user,    #TQC-A30041 ADD
           rxaorig=g_grup,    #TQC-A30041 ADD
           rxamodu=NULL,
           rxadate=g_today,
           rxaacti='Y',
           rxacrat=g_today,
           rxacont='',
           rxaplant=g_plant,
           rxalegal=g_legal
 
   INSERT INTO rxa_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rxa_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rxb_file
       WHERE rxb01=g_rxa.rxa01 
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rxb01=l_newno,
                rxaplant=g_plant,
                rxalegal=g_legal
 
   INSERT INTO rxb_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK            # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rxb_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK             # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rxa.rxa01
   SELECT rxa_file.* INTO g_rxa.* FROM rxa_file 
       WHERE rxa01 = l_newno 
   CALL t700_u()
   CALL t700_rxa05()
   UPDATE rxa_file SET rxa_file.* = g_rxa.*                                                                                      
       WHERE rxa01 = g_rxa.rxa01 
   #SELECT rxa_file.* INTO g_rxa.* FROM rxa_file #FUN-C80046 
   #    WHERE rxa01 = l_oldno                    #FUN-C80046
   CALL t700_show()
 
END FUNCTION
 
FUNCTION t700_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_rxa.rxa01 IS NOT NULL THEN
       LET g_wc = "rxa01='",g_rxa.rxa01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt700" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t700_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rxa01,rxa02,rxa09",TRUE) #FUN-D30097 add rxa09
    END IF
 
END FUNCTION
 
FUNCTION t700_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rxa01,rxa02",FALSE)
    END IF
 
END FUNCTION
#FUN-960130 
