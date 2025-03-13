# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt604.4gl
# Descriptions...: 贈品退還單維護作業
# Date & Author..: NO.FUN-960130 09/10/07 By  Sunyanchun
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:TQC-A10131 10/01/19 By destiny rxn05开窗有错 
# Modify.........: No:TQC-A20013 10/02/05 By destiny销售单不能重复
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0016 10/11/05 By houlia 倉庫權限使用控管修改
# Modify.........: No.FUN-B30028 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:FUN-BB0086 11/12/31 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C20183 12/02/15 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_rxm         RECORD LIKE rxm_file.*,
       g_rxm_t       RECORD LIKE rxm_file.*,
       g_rxm_o       RECORD LIKE rxm_file.*,
       g_t1          LIKE oay_file.oayslip,
       g_rxn         DYNAMIC ARRAY OF RECORD
           rxn02          LIKE rxn_file.rxn02,
           rxn03          LIKE rxn_file.rxn03,
           rxn04          LIKE rxn_file.rxn04,
           rxn04_desc     LIKE rxn_file.rxn05,
           rxn06          LIKE rxn_file.rxn06,
           rxn07          LIKE rxn_file.rxn07,
           rxn08          LIKE rxn_file.rxn08
                     END RECORD,
       g_rxn_t       RECORD
           rxn02          LIKE rxn_file.rxn02,
           rxn03          LIKE rxn_file.rxn03,
           rxn04          LIKE rxn_file.rxn04,
           rxn04_desc     LIKE rxn_file.rxn05,
           rxn06          LIKE rxn_file.rxn06,
           rxn07          LIKE rxn_file.rxn07,
           rxn08          LIKE rxn_file.rxn08
                     END RECORD,
       g_rxn_o       RECORD 
           rxn02          LIKE rxn_file.rxn02,
           rxn03          LIKE rxn_file.rxn03,
           rxn04          LIKE rxn_file.rxn04,
           rxn04_desc     LIKE rxn_file.rxn05,
           rxn06          LIKE rxn_file.rxn06,
           rxn07          LIKE rxn_file.rxn07,
           rxn08          LIKE rxn_file.rxn08
                     END RECORD,
       g_rxo         DYNAMIC ARRAY OF RECORD
           rxo02          LIKE rxo_file.rxo02,
           rxo03          LIKE rxo_file.rxo03,
           rxo04          LIKE rxo_file.rxo04,
           rxo04_desc     LIKE imd_file.imd02,
           rxo05          LIKE rxo_file.rxo05,
           rxo05_desc     LIKE gfe_file.gfe02,
           rxo06          LIKE rxo_file.rxo06,
           rxo07_old      LIKE rxo_file.rxo07,
           rxo08          LIKE rxo_file.rxo08, 
           rxo07          LIKE rxo_file.rxo07,
           rxo09          LIKE rxo_file.rxo09,
           rxo10          LIKE rxo_file.rxo10,
           rxo11          LIKE rxo_file.rxo11,
           rxo12          LIKE rxo_file.rxo12,
           rxo13          LIKE rxo_file.rxo13
                     END RECORD,
       g_rxo_t       RECORD
           rxo02          LIKE rxo_file.rxo02,
           rxo03          LIKE rxo_file.rxo03,
           rxo04          LIKE rxo_file.rxo04,
           rxo04_desc     LIKE imd_file.imd02,
           rxo05          LIKE rxo_file.rxo05,
           rxo05_desc     LIKE gfe_file.gfe02,
           rxo06          LIKE rxo_file.rxo06, 
           rxo07_old      LIKE rxo_file.rxo07, 
           rxo08          LIKE rxo_file.rxo08,
           rxo07          LIKE rxo_file.rxo07,
           rxo09          LIKE rxo_file.rxo09,
           rxo10          LIKE rxo_file.rxo10,
           rxo11          LIKE rxo_file.rxo11,
           rxo12          LIKE rxo_file.rxo12,
           rxo13          LIKE rxo_file.rxo13
                     END RECORD,
       g_rxo_o       RECORD
           rxo02          LIKE rxo_file.rxo02,
           rxo03          LIKE rxo_file.rxo03,
           rxo04          LIKE rxo_file.rxo04,
           rxo04_desc     LIKE imd_file.imd02,
           rxo05          LIKE rxo_file.rxo05,
           rxo05_desc     LIKE gfe_file.gfe02,
           rxo06          LIKE rxo_file.rxo06, 
           rxo07_old      LIKE rxo_file.rxo07,
           rxo08          LIKE rxo_file.rxo08,
           rxo07          LIKE rxo_file.rxo07,
           rxo09          LIKE rxo_file.rxo09,
           rxo10          LIKE rxo_file.rxo10,
           rxo11          LIKE rxo_file.rxo11,
           rxo12          LIKE rxo_file.rxo12,
           rxo13          LIKE rxo_file.rxo13
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac1         LIKE type_file.num5,
       l_ac3         LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
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
DEFINE g_argv1             LIKE rxm_file.rxm01
DEFINE g_argv2             STRING 
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rec_b1            LIKE type_file.num5
DEFINE g_rec_b3            LIKE type_file.num5
DEFINE g_rec_b4            LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE g_member            LIKE type_file.chr1
DEFINE g_rxo05_t           LIKE rxo_file.rxo05
 
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

   LET g_rxm.rxm00 = '2'
   LET g_forupd_sql = "SELECT * FROM rxm_file WHERE rxm00 = ? AND rxm01 = ? AND rxmplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t604_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t604_w AT p_row,p_col WITH FORM "art/42f/artt604"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   #CALL cl_set_comp_entry("rxm03",FALSE) 
   IF NOT cl_null(g_argv1) THEN
      CALL t604_q()
   END IF
   
   DISPLAY BY NAME g_rxm.rxm00 
   CALL t604_menu()
   CLOSE WINDOW t604_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t604_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rxn.clear()
   DISPLAY BY NAME g_rxm.rxm00 
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rxm01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '2' 
      CONSTRUCT BY NAME g_wc ON rxm01,rxm08,rxm02,rxm03,rxm04,rxm05,
                                rxm06,rxm07,rxmplant,rxmconf,rxmcond,rxmconu,
 #                               rxmmksg,rxm900,rxmuser,                    #FUN-B30028  mark
                                rxmuser,                                    #FUN-B30028 
                                rxmgrup,rxmmodu,rxmdate,rxmacti,
                                rxmcrat,rxmoriu,rxmorig
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rxm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1='2'                             #No.TQC-A10131
                  LET g_qryparam.form ="q_rxm01"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxm01
                  NEXT FIELD rxm01
      
               WHEN INFIELD(rxm08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxm08"
#                 LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxm08
                  NEXT FIELD rxm08

               WHEN INFIELD(rxm06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxm06"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxm06
                  NEXT FIELD rxm06
       
               WHEN INFIELD(rxmconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rxmconu"                                                                                    
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rxmconu                                                                              
                  NEXT FIELD rxmconu
               WHEN INFIELD(rxmplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rxmplant"                                                                                    
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rxmplant                                                                              
                  NEXT FIELD rxmplant
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxmuser', 'rxmgrup')
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc1 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc1 ON rxn02,rxn03,rxn04,rxn06,rxn07,rxn08   
              FROM s_rxn[1].rxn02,s_rxn[1].rxn03,s_rxn[1].rxn04,
                   s_rxn[1].rxn06,
                   s_rxn[1].rxn07,s_rxn[1].rxn08
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rxn04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxn04_1"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxn04
                  NEXT FIELD rxn04 
               WHEN INFIELD(rxn05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxn05"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxn05
                  NEXT FIELD rxn05
               WHEN INFIELD(rxn06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxn06"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxn06
                  NEXT FIELD rxn06
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
       CONSTRUCT g_wc2 ON rxo02,rxo03,rxo04,rxo05,rxo06,rxo08,rxo07,
                          rxo09,rxo10,rxo11,rxo12,rxo13   
              FROM s_rxo[1].rxo02,s_rxo[1].rxo03,s_rxo[1].rxo04,
                   s_rxo[1].rxo05,s_rxo[1].rxo06, s_rxo[1].rxo07,
                   s_rxo[1].rxo08, s_rxo[1].rxo09,s_rxo[1].rxo10,
                   s_rxo[1].rxo11,s_rxo[1].rxo12,s_rxo[1].rxo13
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rxo02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo02
                  NEXT FIELD rxo02
               WHEN INFIELD(rxo03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo03"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo03
                  NEXT FIELD rxo03
               WHEN INFIELD(rxo04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  #FUN-AB0016  --modify
                  #LET g_qryparam.form ="q_rxo04"
                  LET g_qryparam.form ="q_imd01_1"
                  #LET g_qryparam.arg1 = g_rxm.rxm00
                  #FUN-AB0016  --end
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo04
                  NEXT FIELD rxo04
               WHEN INFIELD(rxo05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo05"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo05
                  NEXT FIELD rxo05 
               WHEN INFIELD(rxo11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rxo11"
                  LET g_qryparam.arg1 = g_rxm.rxm00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rxo11
                  NEXT FIELD rxo11
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
    END IF
 
    LET g_sql = "SELECT DISTINCT rxm00,rxm01,rxmplant ",
                "  FROM (rxm_file LEFT OUTER JOIN rxn_file ",
                "    ON (rxm00=rxn00 AND rxm01=rxn01 AND rxmplant=rxnplant AND ",g_wc1,")) ",
                "    LEFT OUTER JOIN rxo_file ON ( rxm00=rxO00 AND rxm01=rxO01 ",
                "     AND rxmplant=rxoplant AND ",g_wc2,") ",
                "  WHERE rxm00 = '2' AND ", g_wc CLIPPED,  
                " ORDER BY rxm01"
 
   PREPARE t604_prepare FROM g_sql
   DECLARE t604_cs
       SCROLL CURSOR WITH HOLD FOR t604_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT rxm00||rxm01||rxmplant) ",
                "  FROM (rxm_file LEFT OUTER JOIN rxn_file ",
                "    ON (rxm00=rxn00 AND rxm01=rxn01 AND rxmplant=rxnplant AND ",g_wc1,")) ",
                "    LEFT OUTER JOIN rxo_file ON ( rxm00=rxO00 AND rxm01=rxO01 ",
                "     AND rxmplant=rxoplant AND ",g_wc2,") ",
                "  WHERE rxm00 = '2' AND ", g_wc CLIPPED,  
                " ORDER BY rxm01"

   PREPARE t604_precount FROM g_sql
   DECLARE t604_count CURSOR FOR t604_precount
 
END FUNCTION
 
FUNCTION t604_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t604_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t604_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t604_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t604_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t604_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t604_x()
            END IF
 
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL t604_copy()
#           END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_flag_b = '1' THEN
                  CALL t604_b()
               ELSE
                  CALL t604_b1()
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t604_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t604_yes()
            END IF
 
        WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t604_void(1)
            END IF
       
        #FUN-D20039 -------------sta
        WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t604_void(2)
            END IF
        #FUN-D20039 -------------end

        WHEN "pay_money"
           IF cl_chk_act_auth() THEN
              CALL t604_pay()
           END IF
        WHEN "money_detail"   
           IF cl_chk_act_auth() THEN   
              CALL s_pay_detail('09',g_rxm.rxm01,g_rxm.rxmplant,g_rxm.rxmconf)  
           END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxn),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rxm.rxm01 IS NOT NULL THEN
                 LET g_doc.column1 = "rxm01"
                 LET g_doc.value1 = g_rxm.rxm01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t604_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rxn TO s_rxn.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
 
         ON ACTION first
            CALL t604_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t604_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t604_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t604_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t604_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
#        ON ACTION reproduce
#           LET g_action_choice="reproduce"
#           EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = 1
            EXIT DIALOG
 
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
         ON ACTION void
            LET g_action_choice="void"
            EXIT DIALOG
          
         #FUN-D20039 -------------sta
         ON ACTION undo_void
            LET g_action_choice="undo_void"
            EXIT DIALOG
         #FUN-D20039 -------------end

         ON ACTION pay_money      
            LET g_action_choice = "pay_money"  
            EXIT DIALOG
                                                                                                                                    
         ON ACTION money_detail      
            LET g_action_choice = "money_detail"
            EXIT DIALOG
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '1'
            LET l_ac = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
 
         AFTER DISPLAY
            CONTINUE DIALOG
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
    
      DISPLAY ARRAY g_rxo TO s_rxo.* ATTRIBUTE(COUNT=g_rec_b1)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
 
         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
 
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG
 
         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
 
         ON ACTION first
            CALL t604_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION previous
            CALL t604_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION jump
            CALL t604_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION next
            CALL t604_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION last
            CALL t604_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DIALOG
 
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG
 
#        ON ACTION reproduce
#           LET g_action_choice="reproduce"
#           EXIT DIALOG
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = 1
            EXIT DIALOG
 
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG
 
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      
         ON ACTION confirm
            LET g_action_choice="confirm"
            EXIT DIALOG
         ON ACTION kefa
            LET g_action_choice="kefa" 
            EXIT DIALOG
 
         ON ACTION void
            LET g_action_choice="void"
            EXIT DIALOG

         #FUN-D20039 -------------sta
         ON ACTION undo_void
            LET g_action_choice="undo_void"
            EXIT DIALOG
         #FUN-D20039 -------------end
 
         ON ACTION pay_money      
            LET g_action_choice = "pay_money"  
            EXIT DIALOG
                                                                                                                                    
         ON ACTION money_detail      
            LET g_action_choice = "money_detail"
            EXIT DIALOG
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET g_flag_b = '2'
            LET l_ac1 = ARR_CURR()
            EXIT DIALOG
 
         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
 
         ON ACTION controls       
            CALL cl_set_head_visible("","AUTO")
 
         ON ACTION related_document
            LET g_action_choice="related_document"          
            EXIT DIALOG
      END DISPLAY 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

FUNCTION t604_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rxx04    LIKE rxx_file.rxx04
DEFINE l_rxo10    LIKE rxo_file.rxo10
DEFINE l_rxo02    LIKE rxo_file.rxo02
DEFINE l_rxo07    LIKE rxo_file.rxo07
 
   IF g_rxm.rxm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF   
#CHI-C30107 ----------------- add ----------------- begin 
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err(g_rxm.rxm01,'9024',0) RETURN END IF
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF   
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ----------------- add ----------------- end
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err(g_rxm.rxm01,'9024',0) RETURN END IF 
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rxn_file
    WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01
      AND rxnplant = g_rxm.rxmplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file
       WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
         AND rxoplant = g_rxm.rxmplant
   IF l_rxo10 IS NULL THEN LET l_rxo10 = 0 END IF
   SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file WHERE rxx00 = '09'
       AND rxx01 = g_rxm.rxm01 AND rxxplant = g_rxm.rxmplant 
   IF l_rxx04 IS NULL THEN LET l_rxx04 = 0 END IF
   IF l_rxx04 < l_rxo10 THEN
      CALL cl_err('','art-919',0)
      RETURN
   END IF
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t604_cl:", STATUS, 1)
      CLOSE t604_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t604_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      CLOSE t604_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE rxm_file SET rxmconf='Y',
                       rxmcond=g_today, 
                       rxmconu=g_user
     WHERE  rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
       AND rxmplant = g_rxm.rxmplant
    IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","up rxmconf",1)
       LET g_success='N'
    END IF
   LET g_sql = "SELECT rxo02,rxo07 FROM rxo_file WHERE rxo00 = '2' ",
               "   AND rxo01 = '",g_rxm.rxm01,"' AND rxoplant = '",g_rxm.rxmplant,"'"
   PREPARE pre_sel_rxo01 FROM g_sql
   DECLARE cur_rxo01 CURSOR FOR pre_sel_rxo01
   FOREACH cur_rxo01 INTO l_rxo02,l_rxo07

      UPDATE rxo_file SET rxo08 = rxo08 + l_rxo07
         WHERE rxo00 = '1' AND rxo01 = g_rxm.rxm08
           AND rxoplant = g_rxm.rxmplant
           AND rxo02 = l_rxo02
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","rxo_file",g_rxm.rxm08,"",SQLCA.sqlcode,"","up rxm08",1)
         LET g_success='N'
      END IF
   END FOREACH 
   IF g_success = 'Y' THEN
      LET g_rxm.rxmconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rxm.rxm01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01 
        AND rxmplant = g_rxm.rxmplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxm.rxmconu
   DISPLAY BY NAME g_rxm.rxmconf                                                                                         
   DISPLAY BY NAME g_rxm.rxmcond                                                                                         
   DISPLAY BY NAME g_rxm.rxmconu
   DISPLAY l_gen02 TO FORMONLY.rxmconu_desc
    #CKP
   IF g_rxm.rxmconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxm.rxmconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxm.rxm01,'V')
END FUNCTION
 
FUNCTION t604_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
  
   IF g_rxm.rxm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmacti = 'N' THEN CALL cl_err(g_rxm.rxm01,'art-142',0) RETURN END IF
  #IF g_rxm.rxmconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF  #FUN-D20039 mark
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rxm.rxmconf ='X' THEN RETURN END IF
    ELSE
       IF g_rxm.rxmconf <>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   BEGIN WORK
 
   OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   IF STATUS THEN
      CALL cl_err("OPEN t604_cl:", STATUS, 1)
      CLOSE t604_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t604_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      CLOSE t604_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rxm.rxmconf) THEN
      LET g_chr = g_rxm.rxmconf
      IF g_rxm.rxmconf = 'N' THEN
         LET g_rxm.rxmconf = 'X'
      ELSE
         LET g_rxm.rxmconf = 'N'
      END IF
 
      UPDATE rxm_file SET rxmconf=g_rxm.rxmconf,
                          rxmmodu=g_user,
                          rxmdate=g_today
       WHERE rxm01 = g_rxm.rxm01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","up rxmconf",1)
          LET g_rxm.rxmconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t604_cl
   COMMIT WORK
 
   SELECT * INTO g_rxm.* FROM rxm_file WHERE rxm01=g_rxm.rxm01
   DISPLAY BY NAME g_rxm.rxmconf                                                                                        
   DISPLAY BY NAME g_rxm.rxmmodu                                                                                        
   DISPLAY BY NAME g_rxm.rxmdate
    #CKP
   IF g_rxm.rxmconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rxm.rxmconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rxm.rxm01,'V')
END FUNCTION
 
FUNCTION t604_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02

   MESSAGE ""
   CLEAR FORM
   CALL g_rxn.clear() 
   CALL g_rxo.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rxm.* LIKE rxm_file.*
   LET g_rxm.rxm00 = '2' 
   LET g_rxm_t.* = g_rxm.*
   LET g_rxm_o.* = g_rxm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rxm.rxmuser=g_user
      LET g_rxm.rxmoriu = g_user  
      LET g_rxm.rxmorig = g_grup  
      LET g_rxm.rxmgrup=g_grup
      LET g_rxm.rxmacti='Y'
      LET g_rxm.rxmcrat = g_today
      LET g_rxm.rxmconf = 'N'
      LET g_rxm.rxm00 = '2'
      LET g_rxm.rxm02 = g_today
      LET g_rxm.rxm03 = '1'
      LET g_rxm.rxm06 = g_user
      LET g_rxm.rxmplant = g_plant
      LET g_rxm.rxmlegal = g_legal
      LET g_rxm.rxmmksg = 'N'
      LET g_rxm.rxm900 = '0'
      LET g_data_plant = g_plant #TQC-A10128 ADD
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rxm.rxmplant
      DISPLAY l_azp02 TO rxmplant_desc
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rxm.rxm06
      DISPLAY l_gen02 TO rxm06_desc
      CALL t604_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rxm.* TO NULL
         LET g_rxm.rxm00 = '2' 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rxm.rxm01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_rxm.rxm01,g_today,"","rxm_file","rxm01",g_rxm.rxmplant,"","")  #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rxm.rxm01,g_today,"D2","rxm_file","rxm01",g_rxm.rxmplant,"","")  #FUN-A70130 mod
         RETURNING li_result,g_rxm.rxm01 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rxm.rxm01
      INSERT INTO rxm_file VALUES (g_rxm.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("ins","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rxm.rxm01,'I')
      END IF
 
      LET g_rxm_t.* = g_rxm.*
      LET g_rxm_o.* = g_rxm.*
      CALL g_rxn.clear()
      CALL g_rxo.clear()
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      CALL t604_b()
      CALL t604_b1()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t604_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmacti ='N' THEN
      CALL cl_err(g_rxm.rxm01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rxm.rxmconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
      
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t604_cl:", STATUS, 1)
      CLOSE t604_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t604_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
       CLOSE t604_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t604_show()
 
   WHILE TRUE
      LET g_rxm_o.* = g_rxm.*
      LET g_rxm.rxmmodu=g_user
      LET g_rxm.rxmdate=g_today
 
      CALL t604_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rxm.*=g_rxm_t.*
         CALL t604_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rxm.rxm01 != g_rxm_t.rxm01 THEN
         UPDATE rxn_file SET rxn01 = g_rxm.rxm01
           WHERE rxn00 = g_rxm_t.rxm00 AND rxn01 = g_rxm_t.rxm01
             AND rxnplant = g_rxm_t.rxmplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxn_file",g_rxm_t.rxm01,"",SQLCA.sqlcode,"","rxn",1)
            CONTINUE WHILE
         END IF 
         UPDATE rxo_file SET rxo01 = g_rxm.rxm01
           WHERE rxo00 = g_rxm_t.rxm00 AND rxo01 = g_rxm_t.rxm01
             AND rxoplant = g_rxm_t.rxmplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxo_file",g_rxm_t.rxm01,"",SQLCA.sqlcode,"","rxn",1)
            CONTINUE WHILE
         END IF 
          UPDATE rxm_file SET  rxm01 =  g_rxm.rxm01
             WHERE rxm00 = g_rxm_t.rxm00 AND rxm01 = g_rxm_t.rxm01
             AND rxmplant = g_rxm_t.rxmplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxm_file",g_rxm_t.rxm01,"",SQLCA.sqlcode,"","rxn",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rxm_file SET rxm_file.* = g_rxm.*
         WHERE rxm00 = g_rxm.rxm00 AND rxm01 = g_rxm.rxm01  
           AND rxmplant = g_rxm.rxmplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rxm_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t604_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rxm.rxm01,'U')
 
   CALL t604_b_fill("1=1")
   CALL t604_b1_fill("1=1")

END FUNCTION
 
FUNCTION t604_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rxm.rxm00,g_rxm.rxm08,g_rxm.rxm02,g_rxm.rxm03,g_rxm.rxm06,
 #                  g_rxm.rxmplant,g_rxm.rxmconf,g_rxm.rxmmksg,g_rxm.rxm900,     #FUN-B30028 mark
                   g_rxm.rxmplant,g_rxm.rxmconf,                                 #FUN-B30028
                   g_rxm.rxmuser,g_rxm.rxmmodu,g_rxm.rxmgrup,g_rxm.rxmdate,
                   g_rxm.rxmacti,g_rxm.rxmcrat,g_rxm.rxmoriu,g_rxm.rxmorig
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rxm.rxm01,g_rxm.rxm08,g_rxm.rxm02,
                 g_rxm.rxm04,g_rxm.rxm05,
 #                g_rxm.rxm06,g_rxm.rxm07,g_rxm.rxmmksg,                         #FUN-B30028 mark
                 g_rxm.rxm06,g_rxm.rxm07,                                        #FUN-B30028
                 g_rxm.rxmoriu,g_rxm.rxmorig,
                 g_rxm.rxmmodu,g_rxm.rxmacti,g_rxm.rxmgrup,
                 g_rxm.rxmdate,g_rxm.rxmcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t604_set_entry(p_cmd)
         CALL t604_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rxm01")
          
      AFTER FIELD rxm01
         IF NOT cl_null(g_rxm.rxm01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxm.rxm01 != g_rxm_t.rxm01) THEN 
#              CALL s_check_no("art",g_rxm.rxm01,g_rxm_t.rxm01,"A","rxm_file","rxm01","") #FUN-A70130 mark
               CALL s_check_no("art",g_rxm.rxm01,g_rxm_t.rxm01,"D2","rxm_file","rxm01","") #FUN-A70130 mod
                  RETURNING li_result,g_rxm.rxm01
               DISPLAY BY NAME g_rxm.rxm01
               IF (NOT li_result) THEN                                                                                              
                  LET g_rxm.rxm01=g_rxm_t.rxm01                                                                                     
                  NEXT FIELD rxm01                                                                                                  
               END IF
            END IF
         END IF
      AFTER FIELD rxm06
         IF NOT cl_null(g_rxm.rxm06) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxm.rxm06 != g_rxm_t.rxm06) THEN
               CALL t604_rxm06()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD rxm06                                                                                                   
               END IF
            END IF
         END IF
      AFTER FIELD rxm08
         IF NOT cl_null(g_rxm.rxm08) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rxm.rxm08 != g_rxm_t.rxm08) THEN
               CALL t604_rxm08()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD rxm08                                                                                                   
               END IF
            END IF
         END IF
      
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rxm01)                                                                                                      
              LET g_t1=s_get_doc_no(g_rxm.rxm01)                                                                                    
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','A') RETURNING g_t1  #FUN-A70130--mark--                                                               
              CALL q_oay(FALSE,FALSE,g_t1,'D2','ART') RETURNING g_t1  #FUN-A70130--mod--                                                               
              LET g_rxm.rxm01 = g_t1                                                                                                
              DISPLAY BY NAME g_rxm.rxm01                                                                                           
              NEXT FIELD rxm01
            WHEN INFIELD(rxm06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_rxm.rxm06
               CALL cl_create_qry() RETURNING g_rxm.rxm06
               DISPLAY BY NAME g_rxm.rxm06
               CALL t604_rxm06()
               NEXT FIELD rxm06 
            WHEN INFIELD(rxm08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rxm01"
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 = g_rxm.rxm08
               CALL cl_create_qry() RETURNING g_rxm.rxm08
               DISPLAY BY NAME g_rxm.rxm08
               NEXT FIELD rxm08
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
FUNCTION t604_rxm08() 
DEFINE l_n     LIKE type_file.num5

   LET g_errno = ' '
   
   SELECT COUNT(*) INTO l_n FROM rxm_file WHERE rxm00 = '1'
      AND rxm01 = g_rxm.rxm08 AND rxmplant = g_rxm.rxmplant
      AND rxmconf = 'Y'
   IF l_n = 0 THEN  
      LET g_errno = 'art-915'   
   ELSE 
    	SELECT rxm03 INTO g_rxm.rxm03 FROM rxm_file WHERE rxm00 = '1'
      AND rxm01 = g_rxm.rxm08 AND rxmplant = g_rxm.rxmplant
      AND rxmconf = 'Y'
      DISPLAY BY NAME g_rxm.rxm03
   END IF
   
END FUNCTION

FUNCTION t604_rxm06()
DEFINE l_gen02    LIKE gen_file.gen02

   LET g_errno = ' '
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rxm.rxm06 AND genacti = 'Y'

   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'proj-15'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   DISPLAY l_gen02 TO rxm06_desc
END FUNCTION
FUNCTION t604_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rxn.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t604_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '2' 
      RETURN
   END IF
 
   OPEN t604_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '2' 
   ELSE
      OPEN t604_count
      FETCH t604_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t604_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t604_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t604_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
      WHEN 'P' FETCH PREVIOUS t604_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
      WHEN 'F' FETCH FIRST    t604_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
      WHEN 'L' FETCH LAST     t604_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
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
        FETCH ABSOLUTE g_jump t604_cs INTO g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '2' 
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
 
   SELECT * INTO g_rxm.* FROM rxm_file 
       WHERE rxm00 = g_rxm.rxm00 AND rxm01 = g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rxm_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rxm.* TO NULL
      LET g_rxm.rxm00 = '2' 
      RETURN
   END IF
 
   LET g_data_owner = g_rxm.rxmuser
   LET g_data_group = g_rxm.rxmgrup
   LET g_data_plant = g_rxm.rxmplant #TQC-A10128 ADD
 
   CALL t604_show()
 
END FUNCTION
 
FUNCTION t604_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
 
   LET g_rxm_t.* = g_rxm.*
   LET g_rxm_o.* = g_rxm.*
   DISPLAY BY NAME g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxm02,g_rxm.rxm03,  
                   g_rxm.rxm04,g_rxm.rxm05,g_rxm.rxm06,g_rxm.rxm07,
                   g_rxm.rxmplant,g_rxm.rxmconf,g_rxm.rxmcond,
 #                  g_rxm.rxmconu,g_rxm.rxm900,g_rxm.rxmmksg,           #FUN-B30028 mark
                   g_rxm.rxmconu,                                       #FUN-B30028
                   g_rxm.rxmoriu,g_rxm.rxmorig,g_rxm.rxmuser,
                   g_rxm.rxmmodu,g_rxm.rxmacti,g_rxm.rxmgrup,
                   g_rxm.rxmdate,g_rxm.rxmcrat,g_rxm.rxm08
 
   IF g_rxm.rxmconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rxm.rxmconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rxm.rxm01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxm.rxmconu
   DISPLAY l_gen02 TO FORMONLY.rxmconu_desc
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rxm.rxm06
   DISPLAY l_gen02 TO FORMONLY.rxm06_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rxm.rxmplant
   DISPLAY l_azp02 TO FORMONLY.rxmplant_desc

   IF g_rxm.rxm03 = '1' THEN
      CALL cl_set_comp_visible("rxo11,rxo12",TRUE)
   ELSE
      CALL cl_set_comp_visible("rxo11,rxo12",FALSE)
   END IF
   CALL cl_set_act_visible("kefa",FALSE)
   CALL t604_b_fill(g_wc1)
   CALL t604_b1_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t604_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rxm.rxmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rxm.rxmconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   IF STATUS THEN
      CALL cl_err("OPEN t604_cl:", STATUS, 1)
      CLOSE t604_cl
      RETURN
   END IF
 
   FETCH t604_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t604_show()
 
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF 
   
   IF cl_exp(0,0,g_rxm.rxmacti) THEN
      LET g_chr=g_rxm.rxmacti
      IF g_rxm.rxmacti='Y' THEN
         LET g_rxm.rxmacti='N'
      ELSE
         LET g_rxm.rxmacti='Y'
      END IF
 
      UPDATE rxm_file SET rxmacti=g_rxm.rxmacti,
                          rxmmodu=g_user,
                          rxmdate=g_today
       WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rxm_file",g_rxm.rxm01,"",SQLCA.sqlcode,"","",1) 
         LET g_rxm.rxmacti=g_chr
      END IF
   END IF
 
   CLOSE t604_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rxm.rxm01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rxmacti,rxmmodu,rxmdate
     INTO g_rxm.rxmacti,g_rxm.rxmmodu,g_rxm.rxmdate FROM rxm_file
    WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
      AND rxmplant = g_rxm.rxmplant

   DISPLAY BY NAME g_rxm.rxmacti,g_rxm.rxmmodu,g_rxm.rxmdate
 
END FUNCTION
 
FUNCTION t604_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rxm.* FROM rxm_file
     WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
      AND rxmplant = g_rxm.rxmplant
 
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rxm.rxmconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_rxm.rxmacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
  
   BEGIN WORK
 
   OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
   IF STATUS THEN
      CALL cl_err("OPEN t604_cl:", STATUS, 1)
      CLOSE t604_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t604_cl INTO g_rxm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t604_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rxm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rxm.rxm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rxm_file WHERE rxm00 = g_rxm.rxm00 AND rxm01 = g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
      DELETE FROM rxn_file WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
         AND rxnplant = g_rxm.rxmplant 
      DELETE FROM rxo_file WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
         AND rxoplant = g_rxm.rxmplant

      CLEAR FORM
      CALL g_rxn.clear() 
      CALL g_rxo.clear()

      OPEN t604_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t604_cs
         CLOSE t604_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t604_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t604_cs
         CLOSE t604_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t604_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t604_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t604_fetch('/')
      END IF
   END IF
 
   CLOSE t604_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rxm.rxm01,'D')
END FUNCTION
 
FUNCTION t604_b()
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
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rxm.rxm01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rxm.* FROM rxm_file
     WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
       AND rxmplant = g_rxm.rxmplant
 
    IF g_rxm.rxmacti ='N' THEN
       CALL cl_err(g_rxm.rxm01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rxm.rxmconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rxm.rxmconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rxn02,rxn03,rxn04,'',rxn06,rxn07,rxn08", 
                       "  FROM rxn_file ",
                       " WHERE rxn00 = ? AND rxn01=? AND rxn02=? AND rxnplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t604_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rxn WITHOUT DEFAULTS FROM s_rxn.*
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
 
           OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
           IF STATUS THEN
              CALL cl_err("OPEN t604_cl:", STATUS, 1)
              CLOSE t604_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t604_cl INTO g_rxm.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
              CLOSE t604_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rxn_t.* = g_rxn[l_ac].*  #BACKUP
              LET g_rxn_o.* = g_rxn[l_ac].*  #BACKUP
              OPEN t604_bcl USING g_rxm.rxm00,g_rxm.rxm01,g_rxn_t.rxn02,g_rxm.rxmplant
              IF STATUS THEN
                 CALL cl_err("OPEN t604_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t604_bcl INTO g_rxn[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxn_t.rxn02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
          END IF 
          IF g_rxn[l_ac].rxn04 IS NOT NULL THEN
             CALL cl_set_comp_entry("rxn05",FALSE)
          ELSE
             CALL cl_set_comp_entry("rxn05",TRUE)
          END IF
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxn[l_ac].* TO NULL
           LET g_rxn[l_ac].rxn03 = g_today            #Body default
 
           LET g_rxn_t.* = g_rxn[l_ac].*
           LET g_rxn_o.* = g_rxn[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rxn02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_rxn[l_ac].rxn04) AND cl_null(g_rxn[l_ac].rxn06) THEN
              CALL cl_err('','art-643',0)
              DISPLAY BY NAME g_rxn[l_ac].rxn07
              NEXT FIELD rxn04
           END IF
           IF g_rxn[l_ac].rxn07 IS NULL THEN LET g_rxn[l_ac].rxn07 = 0 END IF
           INSERT INTO rxn_file(rxn00,rxn01,rxn02,rxn03,rxn04,rxn05,rxn06,
                                rxn07,rxn08,rxnplant,rxnlegal)   
           VALUES(g_rxm.rxm00,g_rxm.rxm01,g_rxn[l_ac].rxn02,
                  g_rxn[l_ac].rxn03,g_rxn[l_ac].rxn04,
                  NULL,g_rxn[l_ac].rxn06,
                  g_rxn[l_ac].rxn07,g_rxn[l_ac].rxn08,
                  g_rxm.rxmplant,g_rxm.rxmlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rxn_file",g_rxm.rxm01,g_rxn[l_ac].rxn02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rxn02
           IF g_rxn[l_ac].rxn02 IS NULL OR g_rxn[l_ac].rxn02 = 0 THEN
              SELECT max(rxn02)+1
                INTO g_rxn[l_ac].rxn02
                FROM rxn_file
               WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
                 AND rxnplant = g_rxm.rxmplant
              IF g_rxn[l_ac].rxn02 IS NULL THEN
                 LET g_rxn[l_ac].rxn02 = 1
              END IF
           END IF
 
        AFTER FIELD rxn02
           IF NOT cl_null(g_rxn[l_ac].rxn02) THEN
              IF g_rxn[l_ac].rxn02 != g_rxn_t.rxn02
                 OR g_rxn_t.rxn02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rxn_file
                  WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
                    AND rxn02 = g_rxn[l_ac].rxn02 AND rxnplant = g_rxm.rxmplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rxn[l_ac].rxn02 = g_rxn_t.rxn02
                    NEXT FIELD rxn02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rxn03
         IF NOT cl_null(g_rxn[l_ac].rxn03) THEN
            CALL t604_rxn04_3()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
               NEXT FIELD rxn04
            END IF
         END IF
      AFTER FIELD rxn04
         IF NOT cl_null(g_rxn[l_ac].rxn04) THEN
            IF g_rxn_o.rxn04 IS NULL OR
               (g_rxn[l_ac].rxn04 != g_rxn_o.rxn04 ) THEN
               CALL t604_rxn04()    #檢查其有效性及帶出值          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
               CALL t604_rxn04_3()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
               CALL t604_check_rxn04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxn[l_ac].rxn04,g_errno,0)
                  NEXT FIELD rxn04
               END IF
            END IF  
         END IF  
             
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rxn_t.rxn02 > 0 AND g_rxn_t.rxn02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rxn_file
               WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
                 AND rxn02 = g_rxn_t.rxn02  AND rxnplant = g_rxm.rxmplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rxn_file",g_rxm.rxm01,g_rxn_t.rxn02,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rxn[l_ac].* = g_rxn_t.*
              CLOSE t604_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rxn[l_ac].rxn04) AND cl_null(g_rxn[l_ac].rxn06) THEN
              CALL cl_err('','art-643',0)
              NEXT FIELD rxn04
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rxn[l_ac].rxn02,-263,1)
              LET g_rxn[l_ac].* = g_rxn_t.*
           ELSE
              SELECT COUNT(*) INTO l_n FROM rxn_file
               WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01
                 AND rxn02=g_rxn_t.rxn02 AND rxnplant = g_rxm.rxmplant
              IF l_n = 0 THEN
                 INSERT INTO rxn_file(rxn00,rxn01,rxn02,rxn03,rxn04,rxn05,rxn06,
                                      rxn07,rxn08,rxnplant,rxnlegal)   
                    VALUES(g_rxm.rxm00,g_rxm.rxm01,g_rxn[l_ac].rxn02,
                           g_rxn[l_ac].rxn03,g_rxn[l_ac].rxn04,
                           NULL,g_rxn[l_ac].rxn06,
                           g_rxn[l_ac].rxn07,g_rxn[l_ac].rxn08,
                           g_rxm.rxmplant,g_rxm.rxmlegal)   
              ELSE
                 UPDATE rxn_file SET rxn02=g_rxn[l_ac].rxn02,
                                     rxn03=g_rxn[l_ac].rxn03,
                                     rxn04=g_rxn[l_ac].rxn04,
                                     rxn06=g_rxn[l_ac].rxn06,
                                     rxn07=g_rxn[l_ac].rxn07,
                                     rxn08=g_rxn[l_ac].rxn08
                   WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01
                     AND rxn02=g_rxn_t.rxn02 AND rxnplant = g_rxm.rxmplant
              END IF
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rxn_file",g_rxm.rxm01,g_rxn_t.rxn02,SQLCA.sqlcode,"","",1) 
                 LET g_rxn[l_ac].* = g_rxn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rxn[l_ac].* = g_rxn_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rxn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                    LET g_flag_b = '1'
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t604_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE t604_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rxn02) AND l_ac > 1 THEN
              LET g_rxn[l_ac].* = g_rxn[l_ac-1].*
              LET g_rxn[l_ac].rxn02 = g_rec_b + 1
              NEXT FIELD rxn02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxn04)
                 CALL cl_init_qry_var()
                 IF g_rxn[l_ac].rxn03 IS NULL THEN
                    LET g_qryparam.form ="q_oha1"
                 ELSE
                    LET g_qryparam.form ="q_oha04_1"
                    LET g_qryparam.arg1 = g_rxn[l_ac].rxn03
                 END IF
                 LET g_qryparam.default1 = g_rxn[l_ac].rxn04
                 CALL cl_create_qry() RETURNING g_rxn[l_ac].rxn04
                 DISPLAY BY NAME g_rxn[l_ac].rxn04
                 CALL t604_rxn04()
                 NEXT FIELD rxn04 
              #WHEN INFIELD(rxn06)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_oga3"
              #   LET g_qryparam.default1 = g_rxn[l_ac].rxn06
              #   CALL cl_create_qry() RETURNING g_rxn[l_ac].rxn06                 
              #   DISPLAY BY NAME g_rxn[l_ac].rxn06                 
              #   #CALL t604_rxn06()
              #   NEXT FIELD rxn06
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
    
    UPDATE rxm_file SET rxmmodu = g_rxm.rxmmodu,rxmdate = g_rxm.rxmdate
       WHERE rxm01 = g_rxm.rxm01
         AND rxm00 = g_rxm.rxm00
         AND rxmplant = g_rxm.rxmplant 
    DISPLAY BY NAME g_rxm.rxmmodu,g_rxm.rxmdate
     
    CLOSE t604_bcl
    COMMIT WORK
    CALL t604_delall()
 
END FUNCTION
#No.TQC-A20013--BEGIN
FUNCTION t604_check_rxn04()
DEFINE l_n          LIKE type_file.num5
   
   LET g_errno=''
   SELECT COUNT(*) INTO l_n FROM rxn_file 
    WHERE rxn00=g_rxm.rxm00 
      AND rxnplant=g_rxm.rxmplant
      AND rxn04=g_rxn[l_ac].rxn04
   IF l_n>0 THEN 
      LET g_errno='art-642'
   END IF 
END FUNCTION 
#No.TQC-A20013--END 
FUNCTION t604_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rxn_file
    WHERE rxn00 = g_rxm.rxm00 AND rxn01 = g_rxm.rxm01
      AND rxnplant = g_rxm.rxmplant
 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rxm_file WHERE rxm01 = g_rxm.rxm01
      CALL g_rxn.clear()
   END IF
END FUNCTION

FUNCTION t604_b1()
DEFINE
    l_ac1_t         LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rxm.rxm01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rxm.* FROM rxm_file
     WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
       AND rxmplant = g_rxm.rxmplant
 
    IF g_rxm.rxmacti ='N' THEN
       CALL cl_err(g_rxm.rxm01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rxm.rxmconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rxm.rxmconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
    IF g_rxm.rxm03 = '1' THEN
       CALL cl_set_comp_visible("rxo11,rxo12",TRUE)
    ELSE
       CALL cl_set_comp_visible("rxo11,rxo12",FALSE)
    END IF
  
    LET g_forupd_sql = "SELECT rxo02,rxo03,rxo04,'',rxo05,'',rxo06,'',", 
                       "rxo08,rxo07,rxo09,rxo10,rxo11,rxo12,rxo13 ",
                       "  FROM rxo_file ",
                       " WHERE rxo00 = ? AND rxo01=? AND rxo02=? AND rxoplant = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t6041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rxo WITHOUT DEFAULTS FROM s_rxo.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
           
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t604_cl USING g_rxm.rxm00,g_rxm.rxm01,g_rxm.rxmplant
           IF STATUS THEN
              CALL cl_err("OPEN t604_cl:", STATUS, 1)
              CLOSE t604_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t604_cl INTO g_rxm.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rxm.rxm01,SQLCA.sqlcode,0)
              CLOSE t604_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
              LET g_rxo_t.* = g_rxo[l_ac1].*  #BACKUP
              LET g_rxo_o.* = g_rxo[l_ac1].*  #BACKUP
              LET g_rxo05_t = g_rxo[l_ac].rxo05   #No.FUN-BB0086
              OPEN t6041_bcl USING g_rxm.rxm00,g_rxm.rxm01,g_rxo_t.rxo02,g_rxm.rxmplant
              IF STATUS THEN
                 CALL cl_err("OPEN t6041_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t6041_bcl INTO g_rxo[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxo_t.rxo02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t604_rxo04()
                 CALL t604_rxo05()
                 SELECT rxo07 INTO g_rxo[l_ac1].rxo07_old FROM rxo_file
                    WHERE rxo00 = '1' AND rxo01 = g_rxm.rxm08
                      AND rxo02 = g_rxo[l_ac1].rxo02 
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rxo[l_ac1].* TO NULL
           LET g_rxo05_t = NULL   #No.FUN-BB0086
           LET g_rxo[l_ac1].rxo08 = 0            #Body default
           LET g_rxo[l_ac1].rxo07 =  0            #Body default   
           LET g_rxo[l_ac1].rxo09 =  0
           LET g_rxo[l_ac1].rxo10 =  0 
           LET g_rxo[l_ac1].rxo12 = 1
           LET g_rxo_t.* = g_rxo[l_ac1].*
           LET g_rxo_o.* = g_rxo[l_ac1].*
           CALL cl_show_fld_cont()
           NEXT FIELD rxo02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rxo_file(rxo00,rxo01,rxo02,rxo03,rxo04,rxo05,rxo06,
                                rxo07,rxo08,rxo09,rxo10,rxo11,rxo12,rxo13,
                                rxoplant,rxolegal)   
           VALUES(g_rxm.rxm00,g_rxm.rxm01,g_rxo[l_ac1].rxo02,
                  g_rxo[l_ac1].rxo03,g_rxo[l_ac1].rxo04,
                  g_rxo[l_ac1].rxo05,g_rxo[l_ac1].rxo06,
                  g_rxo[l_ac1].rxo07,g_rxo[l_ac1].rxo08,
                  g_rxo[l_ac1].rxo09,g_rxo[l_ac1].rxo10,
                  g_rxo[l_ac1].rxo11,g_rxo[l_ac1].rxo12,
                  g_rxo[l_ac1].rxo13,
                  g_rxm.rxmplant,g_rxm.rxmlegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rxo_file",g_rxm.rxm01,g_rxo[l_ac1].rxo02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1
           END IF
 
       #BEFORE FIELD rxo02
       #   IF g_rxo[l_ac1].rxo02 IS NULL OR g_rxo[l_ac1].rxo02 = 0 THEN
       #      SELECT max(rxo02)+1
       #        INTO g_rxo[l_ac1].rxo02
       #        FROM rxo_file
       #       WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
       #         AND rxoplant = g_rxm.rxmplant
       #      IF g_rxo[l_ac1].rxo02 IS NULL THEN
       #         LET g_rxo[l_ac1].rxo02 = 1
       #      END IF
       #   END IF
 
       #AFTER FIELD rxo02
       #   IF NOT cl_null(g_rxo[l_ac1].rxo02) THEN
       #      IF g_rxo[l_ac1].rxo02 != g_rxo_t.rxo02
       #         OR g_rxo_t.rxo02 IS NULL THEN
       #         SELECT count(*)
       #           INTO l_n
       #           FROM rxo_file
       #          WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
       #            AND rxo02 = g_rxo[l_ac1].rxo02 AND rxoplant = g_rxm.rxmplant
       #         IF l_n > 0 THEN
       #            CALL cl_err('',-239,0)
       #            LET g_rxo[l_ac1].rxo02 = g_rxo_t.rxo02
       #            NEXT FIELD rxo02
       #         END IF
       #      END IF
       #   END IF
 
       AFTER FIELD rxo02
          IF NOT cl_null(g_rxo[l_ac1].rxo02) THEN
             IF g_rxo[l_ac1].rxo02 != g_rxo_t.rxo02
                OR g_rxo_t.rxo02 IS NULL THEN
                CALL t604_rxo02()  
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rxo[l_ac1].rxo02,g_errno,0)
                   NEXT FIELD rxo02
                END IF
                CALL t604_money()
             END IF
          END IF
      AFTER FIELD rxo03
         IF NOT cl_null(g_rxo[l_ac1].rxo03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rxo[l_ac1].rxo03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rxo[l_ac1].rxo03= g_rxo_t.rxo03
               NEXT FIELD rxo03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_rxo_o.rxo03 IS NULL OR
               (g_rxo[l_ac1].rxo03 != g_rxo_o.rxo03 ) THEN
               CALL t604_rxo03()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxo[l_ac1].rxo03,g_errno,0)
                  LET g_rxo[l_ac1].rxo03 = g_rxo_o.rxo03
                  NEXT FIELD rxo03
               END IF
               CALL t604_chk_rxo()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_rxo[l_ac1].rxo03,g_errno,0)
                  NEXT FIELD rxo03
               END IF
               CALL t604_compute()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_rxo[l_ac1].rxo03,g_errno,0)
                  NEXT FIELD rxo03
               END IF
            END IF  
         END IF 
      AFTER FIELD rxo04
         IF NOT cl_null(g_rxo[l_ac1].rxo04) THEN
            IF g_rxo_o.rxo04 IS NULL OR
               (g_rxo[l_ac1].rxo04 != g_rxo_o.rxo04 ) THEN
               CALL t604_rxo04()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxo[l_ac1].rxo04,g_errno,0)
                  LET g_rxo[l_ac1].rxo04 = g_rxo_o.rxo04
                  NEXT FIELD rxo04
               END IF
            END IF  
         END IF  
         #FUN-AB0016  --add
           IF NOT s_chk_ware1(g_rxo[l_ac1].rxo04,g_rxm.rxmplant) THEN
              NEXT FIELD rxo04
           END IF 
         #FUN-AB0016  --end
      AFTER FIELD rxo05
         IF NOT cl_null(g_rxo[l_ac1].rxo05) THEN
            IF g_rxo_o.rxo05 IS NULL OR
               (g_rxo[l_ac1].rxo05 != g_rxo_o.rxo05 ) THEN
               CALL t604_rxo05()    #檢查其有效性          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxo[l_ac1].rxo05,g_errno,0)
                  LET g_rxo[l_ac1].rxo05 = g_rxo_o.rxo05
                  NEXT FIELD rxo05
               END IF 
               CALL t604_compute()
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_rxo[l_ac1].rxo04,g_errno,0)
                  NEXT FIELD rxo05
               END IF
            END IF  
            #No.FUN-BB0086--add--begin--
            IF NOT cl_null(g_rxo[l_ac].rxo07) AND g_rxo[l_ac].rxo07 <> 0 THEN  #TQC-C20183 add
               IF NOT t603_rxo07_check() THEN 
                  LET g_rxo05_t = g_rxo[l_ac].rxo05
                  NEXT FIELD rxo07 
               END IF 
            END IF                                                             #TQC-C20183 add
            LET g_rxo05_t = g_rxo[l_ac].rxo05
            #No.FUN-BB0086--add--end--
         END IF
        
        
        AFTER FIELD rxo07
           IF NOT t603_rxo07_check() THEN NEXT FIELD rxo07 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--add--begin--
           #IF NOT cl_null(g_rxo[l_ac1].rxo07) THEN
           #   IF g_rxo[l_ac1].rxo07 <= 0 THEN
           #      CALL cl_err('','aem-042',0)
           #      NEXT FIELD rxo07                
           #   END IF 
           #   IF g_rxo[l_ac1].rxo07 > g_rxo[l_ac1].rxo07_old - g_rxo[l_ac1].rxo08 THEN 
           #      CALL cl_err('','art-918',0)
           #      NEXT FIELD rxo07  
           #   END IF 
           #   CALL t604_money()
           #END IF
           #No.FUN-BB0086--add--end--
        #AFTER FIELD rxo09
        #   IF NOT cl_null(g_rxo[l_ac1].rxo09) THEN
        #      IF g_rxo[l_ac1].rxo09 <= 0 THEN
        #         CALL cl_err('','alm-342',0)
        #         NEXT FIELD rxo09                
        #      END IF
        #   END IF  
        #AFTER FIELD rxo10
        #   IF NOT cl_null(g_rxo[l_ac1].rxo10) THEN
        #      IF g_rxo[l_ac1].rxo10 <= 0 THEN
        #         CALL cl_err('','alm-342',0)
        #         NEXT FIELD rxo10                
        #      END IF
        #   END IF 
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rxo_t.rxo02 > 0 AND g_rxo_t.rxo02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rxo_file
               WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
                 AND rxo02 = g_rxo_t.rxo02 AND rxoplant = g_rxm.rxmplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rxo_file",g_rxm.rxm01,g_rxo_t.rxo02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rxo[l_ac1].* = g_rxo_t.*
              CLOSE t6041_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rxo[l_ac1].rxo02,-263,1)
              LET g_rxo[l_ac1].* = g_rxo_t.*
           ELSE
              UPDATE rxo_file SET rxo02=g_rxo[l_ac1].rxo02,
                                  rxo03=g_rxo[l_ac1].rxo03,
                                  rxo04=g_rxo[l_ac1].rxo04,
                                  rxo05=g_rxo[l_ac1].rxo05,
                                  rxo06=g_rxo[l_ac1].rxo06,
                                  rxo07=g_rxo[l_ac1].rxo07,
                                  rxo08=g_rxo[l_ac1].rxo08,
                                  rxo09=g_rxo[l_ac1].rxo09,
                                  rxo10=g_rxo[l_ac1].rxo10,
                                  rxo11=g_rxo[l_ac1].rxo11,
                                  rxo12=g_rxo[l_ac1].rxo12,
                                  rxo13=g_rxo[l_ac1].rxo13
               WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
                 AND rxo02=g_rxo_t.rxo02 AND rxoplant = g_rxm.rxmplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rxo_file",g_rxm.rxm01,g_rxo_t.rxo02,SQLCA.sqlcode,"","",1) 
                 LET g_rxo[l_ac1].* = g_rxo_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
          #LET l_ac1_t = l_ac1   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rxo[l_ac1].* = g_rxo_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rxo.deleteElement(l_ac1)
                 IF g_rec_b1 != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac1 = l_ac1_t
                    LET g_flag_b = '2'
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t6041_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac1_t = l_ac1  #FUN-D30033 add
           CLOSE t6041_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rxo02) AND l_ac1 > 1 THEN
              LET g_rxo[l_ac1].* = g_rxo[l_ac1-1].*
              LET g_rxo[l_ac1].rxo02 = g_rec_b1 + 1
              NEXT FIELD rxo02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxo02) OR INFIELD(rxo03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxo02_3"
                 LET g_qryparam.arg1 = g_rxm.rxm08
                 LET g_qryparam.arg2 = g_rxm.rxmplant
                 LET g_qryparam.default1 = g_rxo[l_ac1].rxo02
                 CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo02,g_rxo[l_ac1].rxo03
                 NEXT FIELD rxo03
             WHEN INFIELD(rxo04)
                #FUN-AB0016 --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_imd"
                #LET g_qryparam.default1 = g_rxo[l_ac1].rxo04
                #CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo04
                 CALL q_imd_1(FALSE,TRUE,g_rxo[l_ac1].rxo04,"","","","") RETURNING g_rxo[l_ac1].rxo04
                #FUN-AB0016  --end
                NEXT FIELD rxo04
              WHEN INFIELD(rxo05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_rxo[l_ac1].rxo05
                 CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo05
                 NEXT FIELD rxo05
              WHEN INFIELD(rxo11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imd"
                 LET g_qryparam.default1 = g_rxo[l_ac1].rxo11
                 CALL cl_create_qry() RETURNING g_rxo[l_ac1].rxo11
                 NEXT FIELD rxo11
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
    
    UPDATE rxm_file SET rxmmodu = g_rxm.rxmmodu,rxmdate = g_rxm.rxmdate
       WHERE rxm01 = g_rxm.rxm01
     
    DISPLAY BY NAME g_rxm.rxmmodu,g_rxm.rxmdate
    
    CLOSE t6041_bcl
    COMMIT WORK
 
END FUNCTION
FUNCTION t604_money()

   IF g_rxo[l_ac1].rxo09 IS NULL OR g_rxo[l_ac1].rxo07 IS NULL THEN
      LET g_rxo[l_ac1].rxo10 = 0
   END IF

   LET g_rxo[l_ac1].rxo10 = g_rxo[l_ac1].rxo07*g_rxo[l_ac1].rxo09
END FUNCTION
FUNCTION t604_rxo02()
DEFINE l_n       LIKE type_file.num5

    LET g_errno = ' '
    
    SELECT count(*) INTO l_n FROM rxo_file 
       WHERE rxo00 = '1' AND rxo01 = g_rxm.rxm08
         AND rxoplant = g_rxm.rxmplant AND rxo02 = g_rxo[l_ac1].rxo02
    IF l_n = 0 THEN
       LET g_errno = 'art-920'  
       RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM rxo_file WHERE rxo00 = g_rxm.rxm00
       AND rxm01 = g_rxm.rxm01 AND rxoplant = g_rxm.rxmplant
       AND rxo02 = g_rxo[l_ac1].rxo02
    IF l_n > 1 THEN
       LET g_errno = -239
       RETURN
    END IF

    SELECT rxo02,rxo03,rxo04,imd02,rxo05,gfe02,rxo06,rxo07,rxo08,rxo07-rxo08,rxo09,rxo10,rxo11,rxo12,''
        INTO g_rxo[l_ac1].*
        FROM (rxo_file LEFT OUTER JOIN imd_file ON rxo04=imd01) 
           LEFT OUTER JOIN gfe_file ON rxo05 = gfe01
       WHERE rxo00 = '1' AND rxo01 = g_rxm.rxm08
         AND rxoplant = g_rxm.rxmplant
         AND rxo02 = g_rxo[l_ac1].rxo02
    CALL t604_chk_rxo()
END FUNCTION

FUNCTION t604_chk_rxo()
DEFINE l_n       LIKE type_file.num5

   LET g_errno = ' '
   IF cl_null(g_rxo[l_ac1].rxo03) OR cl_null(g_rxo[l_ac1].rxo02) THEN
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n FROM rxo_file 
      WHERE rxo00 = '1' AND rxo01 = g_rxm.rxm08
        AND rxoplant = g_rxm.rxmplant  AND rxo03 =  g_rxo[l_ac1].rxo03
        AND rxo02 = g_rxo[l_ac1].rxo02

   IF l_n = 0 THEN LET g_errno = 'art-916' END IF
    
END FUNCTION
FUNCTION t604_rxo03() 
DEFINE l_ima1010     LIKE ima_file.ima1010
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_n           LIKE type_file.num5

   LET g_errno = ' '

   SELECT imaacti,ima1010 INTO l_imaacti,l_ima1010 FROM ima_file 
      WHERE ima01 = g_rxo[l_ac1].rxo03
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aco-001'
      WHEN l_imaacti = 'N'     LET g_errno = 'art-433'
      WHEN l_ima1010 != '1'    LET g_errno = 'art-434'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'  
   END CASE  
END FUNCTION 
FUNCTION t604_compute()
DEFINE l_rxo05       LIKE rxo_file.rxo05
DEFINE l_rxo07       LIKE rxo_file.rxo07
DEFINE l_rxo08       LIKE rxo_file.rxo08
DEFINE l_flag        LIKE type_file.num5                                                                                           
DEFINE l_fac         LIKE ima_file.ima31_fac

   LET g_errno = ' '
   IF cl_null(g_rxo[l_ac1].rxo03) OR cl_null(g_rxo[l_ac1].rxo05) THEN RETURN END IF
   IF cl_null(g_rxo[l_ac1].rxo02) THEN RETURN END IF

   SELECT rxo05,rxo07,rxo08 INTO l_rxo05,l_rxo07,l_rxo08 FROM rxo_file WHERE rxo02 = g_rxo[l_ac1].rxo02
      AND rxo00 = '1' AND rxo01 = g_rxm.rxm08 AND rxoplant = g_rxm.rxmplant
   CALL s_umfchk(g_rxo[l_ac1].rxo03,g_rxo[l_ac1].rxo05,l_rxo05)
      RETURNING l_flag,l_fac
   IF l_flag = 1 THEN 
      LET g_errno = 'art-032'  
   ELSE
      LET g_rxo[l_ac1].rxo06 = l_fac
   END IF
   LET g_rxo[l_ac1].rxo07_old = l_rxo07*l_fac
   LET g_rxo[l_ac1].rxo08 = l_rxo08*l_fac
 
END FUNCTION
FUNCTION t604_rxn04()
DEFINE l_oga51      LIKE oga_file.oga51
DEFINE l_oga02      LIKE oga_file.oga02
DEFINE l_n          LIKE type_file.num5

   LET g_errno = ' '
   SELECT oha16 INTO g_rxn[l_ac].rxn04_desc FROM oha_file
      WHERE oha01 = g_rxn[l_ac].rxn04
        AND ohaconf = 'Y'
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'atm-351'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM rxn_file WHERE rxn00 = '1' 
      AND rxn01 = g_rxm.rxm08 AND rxn04 = g_rxn[l_ac].rxn04_desc
   IF l_n = 0 THEN
      LET g_errno = 'art-921'
      RETURN
   END IF 
   SELECT SUM(rxx04) INTO g_rxn[l_ac].rxn07 FROM rxx_file
        WHERE rxx00 = '03' AND rxx01 = g_rxn[l_ac].rxn04
END FUNCTION

FUNCTION t604_rxn04_3()
DEFINE l_oha02      LIKE oha_file.oha02

   LET g_errno = ' '
   IF  g_rxn[l_ac].rxn03 IS NULL OR  g_rxn[l_ac].rxn04 IS NULL THEN RETURN END IF
   SELECT oha02 INTO l_oha02 FROM oha_file
      WHERE oha01 = g_rxn[l_ac].rxn04
        AND ohaconf = 'Y'
   IF l_oha02 != g_rxn[l_ac].rxn03 THEN LET g_errno = 'art-914' END IF
END FUNCTION
 
FUNCTION t604_rxo04()
DEFINE l_imd11     LIKE imd_file.imd11
DEFINE l_imdacti   LIKE imd_file.imdacti

   LET g_errno = ' '
   SELECT imd02,imd11,imdacti INTO g_rxo[l_ac1].rxo04_desc,l_imd11,l_imdacti FROM imd_file 
      WHERE imd01 = g_rxo[l_ac1].rxo04 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg0094'
      WHEN  l_imd11 = 'N' OR l_imdacti = 'N' LET g_errno = 'axm-993 '
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
END FUNCTION

FUNCTION t604_rxo05()

   LET g_errno = ' '
   SELECT gfe02 INTO g_rxo[l_ac1].rxo05_desc FROM gfe_file 
      WHERE gfe01 = g_rxo[l_ac1].rxo05 AND gfeacti = 'Y' 
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3377'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE
      
END FUNCTION 
 
FUNCTION t604_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rxn02,rxn03,rxn04,'',rxn06,rxn07,rxn08 ", 
               "  FROM rxn_file",
               " WHERE rxn00 = '",g_rxm.rxm00,"' AND rxn01 ='",g_rxm.rxm01,"' ",
               "   AND rxnplant = '",g_rxm.rxmplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rxn02 "
 
   DISPLAY g_sql
 
   PREPARE t604_pb FROM g_sql
   DECLARE rxn_cs CURSOR FOR t604_pb
 
   CALL g_rxn.clear()
   LET g_cnt = 1
 
   FOREACH rxn_cs INTO g_rxn[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT  oha16 INTO g_rxn[g_cnt].rxn04_desc FROM oha_file
          WHERE oha01 =  g_rxn[g_cnt].rxn04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rxn.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
 
END FUNCTION
  
FUNCTION t604_b1_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rxo02,rxo03,rxo04,'',rxo05,'',rxo06,'',",
               "rxo08,rxo07,rxo09,rxo10,rxo11,rxo12,rxo13 ", 
               "  FROM rxo_file",
               " WHERE rxo00 = '",g_rxm.rxm00,"' AND rxo01 ='",g_rxm.rxm01,"' ",
               "   AND rxoplant = '",g_rxm.rxmplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rxo02 "
 
   DISPLAY g_sql
 
   PREPARE t604_pb1 FROM g_sql
   DECLARE rxo_cs CURSOR FOR t604_pb1
 
   CALL g_rxo.clear()
   LET g_cnt = 1
 
   FOREACH rxo_cs INTO g_rxo[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT imd02 INTO g_rxo[g_cnt].rxo04_desc FROM imd_file
           WHERE imd01 = g_rxo[g_cnt].rxo04
       SELECT gfe02 INTO g_rxo[g_cnt].rxo05_desc FROM gfe_file
           WHERE gfe01 = g_rxo[g_cnt].rxo05 
       #SELECT SUM(rxo08) INTO g_rxo[g_cnt].rxo07_old FROM rxo_file
       #    WHERE rxo00 = g_rxm.rxm00 AND rxo01 = g_rxm.rxm01
       #      AND rxoplant = g_rxm.rxmplant
       #      AND rxo03 = g_rxo[g_cnt].rxo03
       #      AND rxo05 = g_rxo[g_cnt].rxo05

       SELECT rxo08 INTO g_rxo[g_cnt].rxo07_old FROM rxo_file
           WHERE rxo00 = '1' AND rxo01 = g_rxm.rxm08
             AND rxoplant = g_rxm.rxmplant
             AND rxo02 = g_rxo[g_cnt].rxo02
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rxo.deleteElement(g_cnt)
 
   LET g_rec_b1=g_cnt-1
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t604_copy()
   DEFINE l_newno     LIKE rxm_file.rxm01,
          l_oldno     LIKE rxm_file.rxm01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t604_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rxm01
       BEFORE INPUT
         CALL cl_set_docno_format("rxm01")
         
       AFTER FIELD rxm01
          IF l_newno IS NULL THEN
             NEXT FIELD rxm01
          ELSE 
#     	     CALL s_check_no("art",l_newno,"","A","rxm_file","rxm01","")  #FUN-A70130 mark                                                           
      	     CALL s_check_no("art",l_newno,"","D2","rxm_file","rxm01","")  #FUN-A70130 mod                                                         
                RETURNING li_result,l_newno 
             IF (NOT li_result) THEN                                                                                               
                LET g_rxm.rxm01=g_rxm_t.rxm01                                                                                      
                NEXT FIELD rxm01                                                                                                   
             END IF 
             BEGIN WORK                                                                                                            
#            CALL s_auto_assign_no("art",l_newno,g_today,"","rxm_file","rxm01",g_plant,"","")  #FUN-A70130 mark                                         
             CALL s_auto_assign_no("art",l_newno,g_today,"D2","rxm_file","rxm01",g_plant,"","")  #FUN-A70130 mod                                         
                RETURNING li_result,l_newno  
             IF (NOT li_result) THEN                                                                                               
                ROLLBACK WORK                                                                                                      
                NEXT FIELD rxm01                                                                                                   
             ELSE                                                                                                                  
                COMMIT WORK                                                                                                        
             END IF
          END IF
      ON ACTION controlp
         CASE 
            WHEN INFIELD(rxm01)                                                                                                      
              LET g_t1=s_get_doc_no(g_rxm.rxm01)                                                                                    
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','A') RETURNING g_t1   #FUN-A70130--mark--                                                              
              CALL q_oay(FALSE,FALSE,g_t1,'D2','ART') RETURNING g_t1  #FUN-A70130--mod--                                                               
              LET l_newno = g_t1                                                                                                
              DISPLAY l_newno TO rxm01                                                                                           
              NEXT FIELD rxm01
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
      DISPLAY BY NAME g_rxm.rxm01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rxm_file
       WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
         AND rxmplant = g_rxm.rxmplant
       INTO TEMP y
 
   UPDATE y
       SET rxm01=l_newno,
           rxmplant=g_plant, 
           rxmlegal=g_legal,
           rxmconf = 'N',
           rxmcond = NULL,
           rxmconu = NULL,
           rxmuser=g_user,
           rxmgrup=g_grup,
           rxmmodu=NULL,
           rxmdate=g_today,
           rxmacti='Y',
           rxmcrat=g_today ,
           rxmoriu = g_user,
           rxmorig = g_grup
           
   INSERT INTO rxm_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rxm_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rxn_file
       WHERE rxn00 = g_rxm.rxm00 AND rxn01=g_rxm.rxm01 
         AND rxnplant = g_rxm.rxmplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rxn01=l_newno,
                rxnplant = g_plant,
                rxnlegal = g_legal 
 
   INSERT INTO rxn_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rxn_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK         #FUN-B80085--add--
      RETURN
   ELSE
      COMMIT WORK
   END IF 
    
   DROP TABLE z
 
   SELECT * FROM rxo_file
       WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01 
         AND rxoplant = g_rxm.rxmplant
       INTO TEMP z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE z SET rxo01=l_newno,
                rxoplant = g_plant,
                rxolegal = g_legal 
 
   INSERT INTO rxo_file
       SELECT * FROM z   
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK          # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rxo_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK         #FUN-B80085--add-- 
      RETURN
   ELSE
      COMMIT WORK
   END IF    
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rxm.rxm01
   SELECT rxm_file.* INTO g_rxm.* FROM rxm_file 
      WHERE rxm00=g_rxm.rxm00 AND rxm01 = l_newno
        AND rxmplant = g_rxm.rxmplant
   CALL t604_u()
   CALL t604_b()
   #FUN-C80046---begin
   #SELECT rxm_file.* INTO g_rxm.* FROM rxm_file 
   #    WHERE rxm00=g_rxm.rxm00 AND rxm01 = l_oldno 
   #      AND rxmplant = g_rxm.rxmplant
   #
   #CALL t604_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t604_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_rxm.rxm01 IS NOT NULL THEN
       LET g_wc = "rxm01='",g_rxm.rxm01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt604" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t604_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rxm01,rxm02,rxm03",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t604_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rxm01,rxm02,rxm03",FALSE)
    END IF
 
END FUNCTION
FUNCTION t604_pay() 
DEFINE l_rxo10    LIKE rxo_file.rxo10
  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rxm.rxm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rxm.* FROM rxm_file 
      WHERE rxm00 = g_rxm.rxm00 AND rxm01=g_rxm.rxm01
        AND rxmplant = g_rxm.rxmplant
   IF g_rxm.rxmacti ='N' THEN
      CALL cl_err(g_rxm.rxm01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rxm.rxmconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rxm.rxmconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF

   SELECT SUM(rxo10) INTO l_rxo10 FROM rxo_file
       WHERE rxo00 = g_rxm.rxm00 AND rxo01=g_rxm.rxm01
         AND rxoplant = g_rxm.rxmplant
   IF l_rxo10 IS NULL THEN LET l_rxo10 = 0 END IF
   CALL s_pay('09',g_rxm.rxm01,g_rxm.rxmplant,l_rxo10,g_rxm.rxmconf)      
END FUNCTION
#NO.FUN-960130------end------

#No.FUN-BB0086---add---begin---
FUNCTION t603_rxo07_check()
   IF NOT cl_null(g_rxo[l_ac].rxo07) AND NOT cl_null(g_rxo[l_ac].rxo05) THEN
      IF cl_null(g_rxo_t.rxo07) OR cl_null(g_rxo05_t) OR g_rxo_t.rxo07 != g_rxo[l_ac].rxo07 OR g_rxo05_t != g_rxo[l_ac].rxo05 THEN
         LET g_rxo[l_ac].rxo07=s_digqty(g_rxo[l_ac].rxo07,g_rxo[l_ac].rxo05)
         DISPLAY BY NAME g_rxo[l_ac].rxo07
      END IF
   END IF
   
   IF NOT cl_null(g_rxo[l_ac1].rxo07) THEN
      IF g_rxo[l_ac1].rxo07 <= 0 THEN
         CALL cl_err('','aem-042',0)
         RETURN FALSE          
      END IF 
      IF g_rxo[l_ac1].rxo07 > g_rxo[l_ac1].rxo07_old - g_rxo[l_ac1].rxo08 THEN 
         CALL cl_err('','art-918',0)
         RETURN FALSE 
      END IF 
      CALL t604_money()
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---
