# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt400.4gl
# Descriptions...: 壓貨單
# Date & Author..: NO.FUN-870006 08/11/14 By Sunyanchun
# Modify.........: No.FUN-870007 08/12/08 By Zhangyajun 功能調整，增加整批錄入，撤銷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960130 09/11/23 By bnlent get tra-db
# Modify.........: No.FUN-9C0069 09/12/14 By bnlent mark or replace rucplant/ruclegal 
# Modify.........: No.FUN-9C0079 09/12/16 By bnlent get the sqlca.sqlcode number details
# Modify.........: No.FUN-A10036 10/01/07 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-A10037 10/01/07 By bnlent 增加採購類型統采代采insert into ruc_file
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.TQC-A20007 10/02/04 By Cockroach RUFCONT賦值 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40005 10/06/02 By Cockroach pml91賦值'N'並插入 
# Modify.........: No.FUN-A50102 10/06/10 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-A90048 10/09/28 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.FUN-AB0101 10/11/26 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號，否則抓ima_file
# Modify.........: No.TQC-AB0241 10/11/29 By shenyang GP5.2 SOP流程修改
# Modify.........: No.TQC-AC0198 10/12/20 By huangrh  鋪貨單產生請購單數據異常,單頭欄位取出營運中心，單身欄位統購否、採購中心代碼
# Modify.........: No.TQC-AC0371 10/12/29 By huangrh  修改單身輸入營運中心報錯，增加取消功能。
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.MOD-B80203 11/08/22 By lixia 取消審核條件
# Modify.........: No.FUN-BB0085 11/12/26 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/13 By xianghui 修改FUN-BB0085的一些問題
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-C80061 12/08/20 By xumeimei 產生單身效能優化
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-CC0057 12/12/18 By xumeimei INSERT INTO ruc_file 时ruc33=' '
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/15 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ruf         RECORD LIKE ruf_file.*,
       g_ruf_t       RECORD LIKE ruf_file.*,
       g_ruf_o       RECORD LIKE ruf_file.*,
       g_ruf01_t     LIKE ruf_file.ruf01,
       g_t1          LIKE oay_file.oayslip,
       g_rug         DYNAMIC ARRAY OF RECORD
           rug02          LIKE rug_file.rug02,
           rug09          LIKE rug_file.rug09,  #FUN-870007-add
           rug09_desc     LIKE azp_file.azp02,  #FUN-870007-add
           rug03          LIKE rug_file.rug03,
           rug03_desc     LIKE ima_file.ima02,
           rug04          LIKE rug_file.rug04,
           rug04_desc     LIKE gfe_file.gfe02,
           rug05          LIKE rug_file.rug05,
           rug06          LIKE rug_file.rug06,
           rug07          LIKE rug_file.rug07,
           rug08          LIKE rug_file.rug08           
                     END RECORD,
       g_rug_t       RECORD
           rug02          LIKE rug_file.rug02,
           rug09          LIKE rug_file.rug09,  #FUN-870007-add
           rug09_desc     LIKE azp_file.azp02,  #FUN-870007-add
           rug03          LIKE rug_file.rug03,
           rug03_desc     LIKE ima_file.ima02,
           rug04          LIKE rug_file.rug04,
           rug04_desc     LIKE gfe_file.gfe02,
           rug05          LIKE rug_file.rug05,
           rug06          LIKE rug_file.rug06,
           rug07          LIKE rug_file.rug07,
           rug08          LIKE rug_file.rug08
                     END RECORD,
       g_rug_o       RECORD 
           rug02          LIKE rug_file.rug02,
           rug09          LIKE rug_file.rug09,  #FUN-870007-add
           rug09_desc     LIKE azp_file.azp02,  #FUN-870007-add
           rug03          LIKE rug_file.rug03,
           rug03_desc     LIKE ima_file.ima02,
           rug04          LIKE rug_file.rug04,
           rug04_desc     LIKE gfe_file.gfe02,
           rug05          LIKE rug_file.rug05,
           rug06          LIKE rug_file.rug06,
           rug07          LIKE rug_file.rug07,
           rug08          LIKE rug_file.rug08
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_wc3         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num20
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE ruf_file.ruf01
DEFINE g_argv2             STRING 
DEFINE g_n                 LIKE type_file.num5
DEFINE g_author            STRING
DEFINE g_rtz04             LIKE rtz_file.rtz04
DEFINE g_rug04_t           LIKE rug_file.rug04    #FUN-BB0085

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
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM ruf_file WHERE ruf01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t400_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t400_w WITH FORM "art/42f/artt400"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01=g_plant    
   IF NOT cl_null(g_argv1) THEN
      CALL t400_q()
   END IF
 
   CALL t400_menu()
   CLOSE WINDOW t400_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t400_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rug.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " ruf01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_ruf.* TO NULL
      CONSTRUCT BY NAME g_wc ON ruf01,ruf02,ruf03,rufconf,rufcond,
                                rufcont,rufconu,rufplant,rufuser,
                                rufgrup,rufmodu,rufdate,rufacti,
                                rufcrat
                               ,ruforiu,ruforig                #TQC-A20007 ADD
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruf01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruf01
                  NEXT FIELD ruf01
       
               WHEN INFIELD(rufconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rufconu"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rufconu                                                                              
                  NEXT FIELD rufconu
               WHEN INFIELD(rufplant)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_azp"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rufplant                                                                             
                  NEXT FIELD rufplant
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
   #      LET g_wc = g_wc clipped," AND rufuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND rufgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND rufgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rufuser', 'rufgrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON rug02,rug09,rug03,rug04,rug05,rug06,rug07,rug08        #FUN-870007-add rug09
              FROM s_rug[1].rug02,s_rug[1].rug09,s_rug[1].rug03,s_rug[1].rug04,
                   s_rug[1].rug05,s_rug[1].rug06,s_rug[1].rug07,
                   s_rug[1].rug08
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rug03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rug03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rug03
                  NEXT FIELD rug03
               WHEN INFIELD(rug04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rug04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rug04
                  NEXT FIELD rug04
#FUN-870007-start-
              WHEN INFIELD(rug09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rug09"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rug09
                  NEXT FIELD rug09
#FUN-870007--end--
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
      LET g_sql = "SELECT ruf01,rufplant FROM ruf_file ",
                  " WHERE ", g_wc CLIPPED," AND rufplant IN ",g_auth,
                  " ORDER BY ruf01"
   ELSE
      LET g_sql = "SELECT UNIQUE ruf01,rufplant ",
                  "  FROM ruf_file, rug_file ",
                  " WHERE ruf01 = rug01 AND rufplant = rugplant ",
                  "   AND rufplant IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY ruf01"
   END IF
 
   PREPARE t400_prepare FROM g_sql
   DECLARE t400_cs
       SCROLL CURSOR WITH HOLD FOR t400_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM ruf_file WHERE ",g_wc CLIPPED,
                " AND rufplant IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT ruf01) FROM ruf_file,rug_file ",
                " WHERE rug01=ruf01 AND rugplant=rufplant ",
                "   AND rufplant IN ",g_auth," AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t400_precount FROM g_sql
   DECLARE t400_count CURSOR FOR t400_precount
 
END FUNCTION
 
FUNCTION t400_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t400_bp("G")
      CASE g_action_choice
#FUN-870007-start-
        WHEN "add_input"
            IF cl_chk_act_auth() THEN
                  CALL t400_create_b('u')
                  CALL t400_b_fill(" 1=1")
                  CALL t400_bp_refresh()
            END IF
        WHEN "del_input"
            IF cl_chk_act_auth() THEN
                  CALL t400_del_b()
                  CALL t400_b_fill(" 1=1")
                  CALL t400_bp_refresh()
            END IF
#FUN-870007--end--
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t400_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t400_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t400_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t400_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t400_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t400_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t400_b()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t400_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL t400_yes()
            END IF
         WHEN "un_confirm"
            IF cl_chk_act_auth() THEN
                  CALL t400_no()
            END IF
        
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t400_void(1)
            END IF
         #FUN-D20039 -------------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t400_void(2)
            END IF
         #FUN-D20039 -------------end
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rug),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                    IF g_ruf.ruf01 IS NOT NULL THEN
                       LET g_doc.column1 = "ruf01"
                       LET g_doc.value1 = g_ruf.ruf01
                       CALL cl_doc()
                    END IF
              END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rug TO s_rug.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
#FUN-870007-start-
      ON ACTION add_input
         LET g_action_choice="add_input"
         EXIT DISPLAY
      ON ACTION del_input
         LET g_action_choice="del_input"
         EXIT DISPLAY
#FUN-870007--end--
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
         CALL t400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t400_no()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_rug09    LIKE rug_file.rug09         #TQC-AC0371
DEFINE l_flag     LIKE type_file.chr1         #TQC-AC0371
DEFINE l_sql      STRING                      #TQC-AC0371
DEFINE l_success  LIKE type_file.chr1         #TQC-AC0371
DEFINE l_rufcont  LIKE ruf_file.rufcont       #CHI-D20015 Add
DEFINE l_gen02    LIKE gen_file.gen02         #CHI-D20015 Add

 
   IF g_ruf.ruf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01=g_ruf.ruf01 
   IF g_ruf.rufconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF
 
#TQC-AC0371-------------begin-------------------------------------------------
   LET l_sql = "SELECT DISTINCT rug09 FROM rug_file ",
               " WHERE rug01= '",g_ruf.ruf01,"' AND rugplant='",g_ruf.rufplant,"'"
   PREPARE pre_check_rug FROM l_sql
   DECLARE check_rug CURSOR FOR pre_check_rug

   LET l_flag='Y' 
   FOREACH check_rug INTO l_rug09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rug09 IS NULL THEN 
         CONTINUE FOREACH 
      END IF

      LET l_cnt=0
      LET l_sql = "SELECT count(*) FROM ",cl_get_target_table(l_rug09, 'pmk_file'),
                  ",",cl_get_target_table(l_rug09, 'pml_file'),
#                  "  WHERE pmk01=pml01 AND pmk25='1' AND pmk18='Y'",
                  "  WHERE pmk01=pml01 AND pmk18 <> 'N' ",  #MOD-B80203
                  "    AND pml24='",g_ruf.ruf01,"'",
                  "    AND pmkplant=pmkplant AND pmkplant='",l_rug09,"'"

     PREPARE pre_check_pml FROM l_sql
     EXECUTE pre_check_pml INTO l_cnt          

     IF l_cnt >0 THEN
        LET l_flag='N'
        EXIT FOREACH
     END IF
   END FOREACH
   IF l_flag='N' THEN
      CALL cl_err('','art508',0) 
      RETURN 
   END IF

#TQC-AC0371------------end-----------------------------------------------------------

   IF NOT cl_confirm('aim-302') THEN RETURN END IF 
   BEGIN WORK
   LET l_success='Y'
   OPEN t400_cl USING g_ruf.ruf01  
   IF STATUS THEN 
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl  
      ROLLBACK WORK 
      RETURN 
   END IF
    
   FETCH t400_cl INTO g_ruf.* 
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
      CLOSE t400_cl ROLLBACK WORK RETURN 
   END IF
                                          
#TQC-AC0371-------------------------begin--------------------------------------
   LET l_sql = "SELECT DISTINCT rug09 FROM rug_file ",
               " WHERE rug01= '",g_ruf.ruf01,"' AND rugplant='",g_ruf.rufplant,"'"
   PREPARE pre_check_rug2 FROM l_sql
   DECLARE check_rug2 CURSOR FOR pre_check_rug2

   FOREACH check_rug2 INTO l_rug09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rug09 IS NULL THEN
         CONTINUE FOREACH
      END IF

      LET l_sql = "DELETE FROM ",cl_get_target_table(l_rug09, 'pmk_file'),
                  "  WHERE pmk01 in (SELECT DISTINCT(pml01) FROM ",
                  cl_get_target_table(l_rug09, 'pml_file'),
                  "                     WHERE pml24='",g_ruf.ruf01,"' AND pmlplant='",l_rug09,"')",
                  "    AND pmkplant='",l_rug09,"'"

     PREPARE pre_del_pmk FROM l_sql
     EXECUTE pre_del_pmk 
     IF SQLCA.SQLCODE THEN
        CALL cl_err('',SQLCA.SQLCODE,1)
        LET l_success='N'
        EXIT FOREACH
     END IF
     LET l_sql = "DELETE FROM ",cl_get_target_table(l_rug09, 'pml_file'),
                 "   WHERE pml24='",g_ruf.ruf01,"' AND pmlplant='",l_rug09,"'"

     PREPARE pre_del_pml FROM l_sql
     EXECUTE pre_del_pml
     IF SQLCA.SQLCODE THEN
        CALL cl_err('',SQLCA.SQLCODE,1)
        LET l_success='N'
        EXIT FOREACH
     END IF
   END FOREACH
#TQC-AC0371------------end-----------------------------------------------------------

   UPDATE ruf_file SET rufconf='N', 
                      #CHI-D20015 Mark&Add Str
                      #rufcond=NULL,
                      #rufconu=NULL
                      #,rufcont=NULL    #TQC-A20007 ADD
                       rufcond=g_today,
                       rufconu=g_user,
                       rufcont=l_rufcont
                      #CHI-D20015 Mark&Add End
     WHERE ruf01=g_ruf.ruf01
   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
      CALL cl_err('',SQLCA.SQLCODE,1)
      LET l_success='N'                   #TQC-AC0371
#      CLOSE t400_cl                      #TQC-AC0371
#      ROLLBACK WORK                      #TQC-AC0371
#      RETURN                             #TQC-AC0371
   END IF
  
   CLOSE t400_cl                          #TQC-AC0371
   IF l_success='N' THEN                  #TQC-AC0371
      ROLLBACK WORK                       #TQC-AC0371
      RETURN                              #TQC-AC0371
   ELSE                                   #TQC-AC0371
      COMMIT WORK       
   END IF                                 #TQC-AC0371
   
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01=g_ruf.ruf01  
   DISPLAY BY NAME g_ruf.rufconf                                                                                                    
   DISPLAY BY NAME g_ruf.rufcond                                                                                                    
   DISPLAY BY NAME g_ruf.rufconu                                                                                                    
  #DISPLAY '' TO FORMONLY.rufconu_desc    #CHI-D20015 Mark
   #CHI-D20015---------Add-----Str
   DISPLAY BY NAME g_ruf.rufcont
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruf.rufconu
   DISPLAY l_gen02 TO FORMONLY.rufconu_desc
   #CHI-D20015---------Add-----End
    #CKP                                                                                                                            
   IF g_ruf.rufconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_ruf.rufconf,"","","",g_chr,"")                                                                           
                                                                                                                                    
   CALL cl_flow_notify(g_ruf.ruf01,'V')
END FUNCTION

FUNCTION t400_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_time     LIKE type_file.chr8  #TQC-A20007 ADD
 
   IF g_ruf.ruf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 ----------------- add --------------------- begin
   IF g_ruf.rufconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruf.rufconf = 'X' THEN CALL cl_err(g_ruf.ruf01,'9024',0) RETURN END IF
   IF g_ruf.rufacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ----------------- add --------------------- end
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01=g_ruf.ruf01
   IF g_ruf.rufconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruf.rufconf = 'X' THEN CALL cl_err(g_ruf.ruf01,'9024',0) RETURN END IF 
   IF g_ruf.rufacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rug_file
    WHERE rug01=g_ruf.ruf01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t400_cl USING g_ruf.ruf01
   
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t400_cl INTO g_ruf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
      CLOSE t400_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   LET l_time = TIME  #TQC-A20007 
   UPDATE ruf_file SET rufconf='Y',
                       rufcond=g_today, 
                       rufconu=g_user,
                       rufcont = l_time,   #TQC-A20007 ADD
                       rufmodu =g_user,
                       rufdate =g_today
     WHERE ruf01=g_ruf.ruf01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   #為每個壓貨機構產生請購單
   CALL t400_buy()
   IF g_success = 'Y' THEN
      LET g_ruf.rufconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_ruf.ruf01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01=g_ruf.ruf01 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruf.rufconu
   DISPLAY BY NAME g_ruf.rufconf                                                                                         
   DISPLAY BY NAME g_ruf.rufcond                                                                                         
   DISPLAY BY NAME g_ruf.rufconu
   DISPLAY BY NAME g_ruf.rufcont
   DISPLAY BY NAME g_ruf.rufmodu  #TQC-A20007 ADD
   DISPLAY BY NAME g_ruf.rufdate
   DISPLAY l_gen02 TO FORMONLY.rufconu_desc
    #CKP
   IF g_ruf.rufconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruf.rufconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruf.ruf01,'V')
END FUNCTION
#為每個壓貨機構產生請購單
FUNCTION t400_buy()
DEFINE l_rug09   LIKE rug_file.rug09
DEFINE l_dbs     LIKE azp_file.azp03
DEFINE l_rug     RECORD LIKE rug_file.*
DEFINE l_flag    LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_no      LIKE pmk_file.pmk01
DEFINE l_rty03   LIKE rty_file.rty03
DEFINE l_fac     LIKE type_file.num20_6
DEFINE l_flag1   LIKE type_file.chr1
DEFINE l_ima155  LIKE ima_file.ima155
DEFINE l_rtb02   LIKE rtb_file.rtb02
DEFINE l_rtb03   LIKE rtb_file.rtb03
DEFINE l_rtc02   LIKE rtc_file.rtc02
DEFINE l_rtc03   LIKE rtc_file.rtc03
DEFINE l_rtc04   LIKE rtc_file.rtc04
DEFINE l_msg     LIKE type_file.chr1000
DEFINE l_shop    RECORD LIKE rug_file.*
 
   LET g_sql = "SELECT DISTINCT rug09 FROM rug_file ",
               " WHERE rug01= '",g_ruf.ruf01,"' AND rugplant='",g_ruf.rufplant,"'"
   PREPARE pre_ruh FROM g_sql
   DECLARE ruh_curs CURSOR FOR pre_ruh
 
   FOREACH ruh_curs INTO l_rug09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rug09 IS NULL THEN CONTINUE FOREACH END IF
 
      #No.FUN-960130 ..begin
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rug09
      LET g_plant_new = l_rug09
      CALL s_gettrandbs()
      LET l_dbs=g_dbs_tra
      #No.FUN-960130 ..end
      IF l_dbs IS NULL THEN
         CALL cl_err(l_rug09,'art-516',1)
         LET g_success = 'N'
         RETURN
      END IF  
      LET l_dbs = s_dbstring(l_dbs CLIPPED)
      #產生請購單單頭檔
      CALL t400_inspmk(l_dbs,l_rug09) RETURNING l_flag,l_no
      IF l_flag = 0 THEN
         LET g_success = 'N' 
         RETURN
      END IF
 
      LET g_sql = "SELECT * ",
                  " FROM rug_file",    
                  " WHERE rug01 ='",g_ruf.ruf01,"' ",
                  "   AND rugplant = '",g_ruf.rufplant,"'",
                  "   AND rug09 = '",l_rug09,"'"       #FUN-870007
      PREPARE t400_pb1 FROM g_sql
      DECLARE rug_cs1 CURSOR FOR t400_pb1
      LET g_n = 1
      FOREACH rug_cs1 INTO l_rug.*
         IF SQLCA.sqlcode THEN
            LET g_success = 'N' 
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT ima155 INTO l_ima155 FROM ima_file WHERE ima01 = l_rug.rug03
         #該商品是否為組裝商品
         IF l_ima155 = 'Y' THEN
            LET g_sql = "SELECT rtb02,rtb03,rtc02,rtc03,rtc04 ",
                        " FROM rtb_file,rtc_file ",
                        " WHERE rtb01 = rtc01 AND rtb01 = '",l_rug.rug03,"'"
            PREPARE pre_rtb FROM g_sql
            DECLARE rtb_cs CURSOR FOR pre_rtb
            LET l_n = 0
            FOREACH rtb_cs INTO l_rtb02,l_rtb03,l_rtc02,l_rtc03,l_rtc04
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N' 
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag1 = NULL
               LET l_fac = NULL
               CALL s_umfchk(l_rug.rug03,l_rug.rug04,l_rtb02) RETURNING l_flag1,l_fac
               IF l_flag1 = 1 THEN
                  LET l_msg = l_rug.rug04 CLIPPED,'->',l_rtb02 CLIPPED
                  CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                  LET l_fac = NULL
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_shop.* = l_rug.*
               LET l_shop.rug03 = l_rtc02
               LET l_shop.rug05 = l_rug.rug05*l_fac*(l_rtc04/l_rtb03)
               LET l_shop.rug04 = l_rtc03
               LET l_shop.rug05 = s_digqty(l_shop.rug05,l_shop.rug04)  #FUN-BB0085
               #產生請購單單身
               CALL t400_inspml(l_no,l_shop.*,l_dbs,l_rug09) RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N' 
                  RETURN
               END IF
               SELECT rty03 INTO l_rty03 
                  FROM rty_file WHERE rty01 = l_rug09 AND rty02 = l_shop.rug03
               IF l_rty03 = '2' OR l_rty03 = '3' OR l_rty03 ='4' THEN #No.FUN-A10037
                  #產生需求匯總表
                  CALL t400_insruc(l_shop.*,l_no,l_rug09) RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N' 
                     RETURN
                  END IF
               END IF
               LET l_n = l_n + 1
               LET g_n = g_n + 1
            END FOREACH
         END IF
         #該商品不是組裝商品，或是組裝商品但是沒有維護子項商品
         IF l_ima155 = 'N' OR l_n = 0 OR l_n IS NULL THEN
            #產生請購單單身
            CALL t400_inspml(l_no,l_rug.*,l_dbs,l_rug09) RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N' 
               RETURN
            END IF
            SELECT rty03 INTO l_rty03 
                FROM rty_file WHERE rty01 = l_rug09 AND rty02 = l_rug.rug03
            IF l_rty03 = '2' OR l_rty03 = '3' OR l_rty03 ='4' THEN  #No.FUN-A10037
               #產生需求匯總表
               CALL t400_insruc(l_rug.*,l_no,l_rug09) RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N' 
                  RETURN
               END IF
            END IF
            LET g_n = g_n + 1
         END IF
      END FOREACH
   END FOREACH
END FUNCTION
FUNCTION t400_inspmk(p_dbs,p_org)
DEFINE l_pmk     RECORD LIKE pmk_file.*
DEFINE p_dbs     LIKE azp_file.azp03
DEFINE p_org     LIKE azp_file.azp01
DEFINE l_doc     LIKE rye_file.rye03
DEFINE li_result LIKE type_file.num5
 
   LET g_errno = ""
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_doc FROM rye_file WHERE rye01 = 'apm' 
   #    AND rye02 = '1' AND ryeacti = 'Y'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('apm','1',g_plant,'N')  RETURNING l_doc   #FUN-C90050 add

   IF l_doc IS NULL THEN 
      CALL cl_err('','art-330',1)
      RETURN 0,''
   END IF
   CALL s_auto_assign_no("apm",l_doc,g_today,"1","pmk_file","pmk01",p_org,"","")
      RETURNING li_result,l_pmk.pmk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN 0,''
   END IF
   
   LET l_pmk.pmk46 = '6'
   LET l_pmk.pmk02 = 'REG'
   LET l_pmk.pmk03 = 0
   LET l_pmk.pmk04 = g_today
   LET l_pmk.pmk48 = TIME(CURRENT)
   LET l_pmk.pmk18 = 'Y' 
   LET l_pmk.pmkcond = g_today
   LET l_pmk.pmkconu = g_user
#   LET l_pmk.pmk47 = ""         #TQC-AC0198
   LET l_pmk.pmk47 = p_org       #TQC-AC0198
   LET l_pmk.pmkplant = p_org
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk22 = g_aza.aza17 #本幣幣別
   LET l_pmk.pmk42 = 1
   LET l_pmk.pmk45 = 'Y' 
   LET l_pmk.pmkmksg = 'N'
   LET l_pmk.pmk25 = '1'
   LET l_pmk.pmk30 = 'Y' 
   LET l_pmk.pmkuser = g_user
   LET l_pmk.pmkoriu = g_user #FUN-980030
   LET l_pmk.pmkorig = g_grup #FUN-980030
  #LET g_data_plant = g_plant #FUN-980030  #TQC-A10128 MARK
   LET l_pmk.pmkgrup = g_grup
   LET l_pmk.pmkacti = 'Y'  
   LET l_pmk.pmkcrat = g_today
   LET l_pmk.pmkcont = TIME(CURRENT)
 
   SELECT azn02,azn04 INTO l_pmk.pmk31,l_pmk.pmk32 FROM azn_file 
        WHERE azn01 = l_pmk.pmk04
   SELECT azw02 INTO l_pmk.pmklegal FROM azw_file WHERE azw01=p_org
   LET l_pmk.pmkprsw = 'Y'
   LET l_pmk.pmkprno = 0
   LET l_pmk.pmkdays = 0
   LET l_pmk.pmksseq = 0
   LET l_pmk.pmksmax = 0
   #LET g_sql = "INSERT INTO ",p_dbs,"pmk_file(pmk01,pmk46,pmk02,pmk03,pmk04,pmk48,pmk18,", #FUN-A50102
   LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'pmk_file'),"(pmk01,pmk46,pmk02,pmk03,pmk04,pmk48,pmk18,", #FUN-A50102
               "pmk47,pmkplant,pmk12,pmk13,pmk22,pmk42,pmk45,pmkmksg,pmk25,pmk30,",
               "pmkuser,pmkgrup,pmkacti,pmkcrat,pmkcond,pmkconu,pmkcont, ",
               "pmk31,pmk32,pmkprsw,pmkprno,pmkdays,pmksseq,pmksmax,pmklegal,pmkoriu,pmkorig) ", #FUN-A10036
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?)" #FUN-A10036
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
   PREPARE pre_inspmk FROM g_sql
   EXECUTE pre_inspmk USING l_pmk.pmk01,l_pmk.pmk46,l_pmk.pmk02,l_pmk.pmk03,l_pmk.pmk04,
                            l_pmk.pmk48,l_pmk.pmk18,l_pmk.pmk47,l_pmk.pmkplant,l_pmk.pmk12,
                            l_pmk.pmk13,l_pmk.pmk22,l_pmk.pmk42,l_pmk.pmk45,l_pmk.pmkmksg,
                            l_pmk.pmk25,l_pmk.pmk30,l_pmk.pmkuser,l_pmk.pmkgrup,l_pmk.pmkacti,
                            l_pmk.pmkcrat,l_pmk.pmkcond,l_pmk.pmkconu,l_pmk.pmkcont,
                            l_pmk.pmk31,l_pmk.pmk32,l_pmk.pmkprsw,l_pmk.pmkprno,l_pmk.pmkdays,
                            l_pmk.pmksseq,l_pmk.pmksmax,l_pmk.pmklegal,g_user,g_grup
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pmk_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
      RETURN 0,''
   END IF
 
   RETURN 1,l_pmk.pmk01
END FUNCTION
FUNCTION t400_inspml(p_no,p_rug,p_dbs,p_org)
DEFINE p_rug    RECORD LIKE rug_file.*
DEFINE p_dbs    LIKE azp_file.azp03
DEFINE p_org    LIKE azp_file.azp01
DEFINE l_pml    RECORD LIKE pml_file.*
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_rty03  LIKE rty_file.rty03
DEFINE l_rty05  LIKE rty_file.rty05
DEFINE l_rty06  LIKE rty_file.rty06
DEFINE p_no     LIKE pmk_file.pmk01
DEFINE l_msg    LIKE type_file.chr1000
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE l_fac    LIKE type_file.num20_6
DEFINE l_flag   LIKE type_file.num5
DEFINE l_rty12  LIKE rty_file.rty12  #TQC-AC0198
 
   SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file WHERE ima01 = p_rug.rug03
   SELECT rty03,rty05,rty06,rty12 INTO l_rty03,l_rty05,l_rty06,l_rty12              #TQC-AC0198 add rty12 
       FROM rty_file WHERE rty01 = p_org AND rty02 = p_rug.rug03
   IF SQLCA.SQLCODE = 100 THEN
      LET l_msg = p_org,"-->",p_rug.rug03
      CALL cl_err(p_org,'art-517',1)
      RETURN 0
   END IF
 
   LET l_pml.pml01 = p_no
   LET l_pml.pml02 = g_n
   LET l_pml.pml24 = g_ruf.ruf01
   LET l_pml.pml25 = p_rug.rug02
   LET l_pml.pml04 = p_rug.rug03
   LET l_pml.pml041 = l_ima02
   LET l_pml.pml07 = p_rug.rug04
   LET l_pml.pml48 = l_rty05
   #LET l_pml.pml49 = l_rty06      #FUN-C80061 mark
   #LET l_pml.pml50 = l_rty03      #FUN-C80061 mark
   #FUN-C80061----add----str---
   IF cl_null(l_rty05) THEN
      LET l_pml.pml49 = '1'
   ELSE
      LET l_pml.pml49 = l_rty06
   END IF
   IF cl_null(l_rty03) THEN
      LET l_pml.pml50 = '1'
   ELSE
      LET l_pml.pml50 = l_rty03
   END IF
   LET l_pml.pml92 = 'N'
   #FUN-C80061----add----end---
   LET l_pml.pml190 = 'N'          #TQC-AC0198
   IF l_rty03 = '2' OR l_rty03='4' THEN  #No.FUN-A10037
      LET l_pml.pml52 = l_pml.pml01
      LET l_pml.pml53 = l_pml.pml02
      LET l_pml.pml51 = p_org
      LET l_pml.pml190 = 'Y'           #TQC-AC0198
      LET l_pml.pml191 = l_rty12       #TQC-AC0198
   ELSE
      LET l_pml.pml52 = NULL
      LET l_pml.pml53 = NULL
      LET l_pml.pml51 = NULL
   END IF
   LET l_pml.pml06 = p_rug.rug08
   LET l_pml.pml54 = '1'
   LET l_pml.pml20 = p_rug.rug05
   LET l_pml.pml33 = p_rug.rug06
   LET l_pml.pml34 = p_rug.rug06  
   LET l_pml.pml35 = p_rug.rug06  
   LET l_pml.pml55 = p_rug.rug07
#   LET l_pml.pml190 = 'N'         #TQC-AC0198
   LET l_pml.pml192 = 'N'
   LET l_pml.pml38 = 'Y'
   LET l_pml.pml11 = 'N'
   LET l_pml.pml56 = '1'
   LET l_pml.pml42 = '0'
   LET l_pml.pmlplant = p_org
   LET l_pml.pml16 = '1'
 
   LET l_pml.pml011 = 'REG'
   LET l_pml.pml08 = l_ima25
   CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_ima25) RETURNING l_flag,l_fac
   LET l_pml.pml09 = l_fac
   CALL s_overate(l_pml.pml04) RETURNING l_pml.pml13
   LET l_pml.pml14 =g_sma.sma886[1,1]         #部份交貨
   LET l_pml.pml15 =g_sma.sma886[2,2]         #部份交貨
   LET l_pml.pml21 = 0
   LET l_pml.pml23 = 'Y'
   LET l_pml.pml91 = 'N'    #TQC-A40005 ADD
   LET l_pml.pml30 = 0
   LET l_pml.pml32 = 0
   LET l_pml.pml44 = 0
   LET l_pml.pml67 = g_grup
   LET l_pml.pml86 = l_pml.pml07
   LET l_pml.pml87 = l_pml.pml20
   LET l_pml.pml88 = 0
   LET l_pml.pml88t = 0
   SELECT azw02 INTO l_pml.pmllegal FROM azw_file WHERE azw01=p_org
   #LET g_sql = "INSERT INTO ",p_dbs,"pml_file(pml01,pml02,pml24,pml25,pml04,", #FUN-A50102
   LET g_sql = "INSERT INTO ",cl_get_target_table(p_org, 'pml_file'),"(pml01,pml02,pml24,pml25,pml04,", #FUN-A50102
               "                              pml41,pml07,pml48,pml49,pml50,",
               "                              pml52,pml53,pml06,pml54,pml20,",
               "                              pml33,pml34,pml35,pml55,pml190,",
               "                              pml192,pml38,pml11,pml56,pml42,",
               "                              pmlplant,pml041,pml51,pml16,pml011,",
               "                              pml08,pml09,pml13,pml14,pml15,",
               "                              pml21,pml23,pml30,pml32,pml44,",
               "                              pml67,pml86,pml87,pml88,pml88t,pmllegal,pml91,pml191) ",   #TQC-A40005 ADD pml91 #TQC-AC0198 add pml191
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"     #TQC-A40005 ADD pml91_?     #TQC-AC0198 add pml191      
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
   CALL cl_parse_qry_sql(g_sql, p_org) RETURNING g_sql  #FUN-A50102            
   PREPARE pre_inspml FROM g_sql
   EXECUTE pre_inspml USING l_pml.pml01,l_pml.pml02,l_pml.pml24,l_pml.pml25,l_pml.pml04,
                            l_pml.pml41,l_pml.pml07,l_pml.pml48,l_pml.pml49,l_pml.pml50,
                            l_pml.pml52,l_pml.pml53,l_pml.pml06,l_pml.pml54,l_pml.pml20,
                            l_pml.pml33,l_pml.pml34,l_pml.pml35,l_pml.pml55,l_pml.pml190,
                            l_pml.pml192,l_pml.pml38,l_pml.pml11,l_pml.pml56,l_pml.pml42,
                            l_pml.pmlplant,l_pml.pml041,l_pml.pml51,l_pml.pml16,l_pml.pml011,
                            l_pml.pml08,l_pml.pml09,l_pml.pml13,l_pml.pml14,l_pml.pml15,
                            l_pml.pml21,l_pml.pml23,l_pml.pml30,l_pml.pml32,l_pml.pml44,
                            l_pml.pml67,l_pml.pml86,l_pml.pml87,l_pml.pml88,l_pml.pml88t,l_pml.pmllegal,l_pml.pml91,l_pml.pml191    #TQC-A40005 ADD pml91 #TQC-AC0198 add pml191
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pml_file",l_pml.pml01,"",SQLCA.sqlcode,"","",1)
      RETURN 0
   END IF
 
   RETURN 1
END FUNCTION
#產生需求匯總表
FUNCTION t400_insruc(p_rug,p_no,p_org)
DEFINE p_rug    RECORD LIKE rug_file.*
DEFINE p_no     LIKE pmk_file.pmk01
DEFINE p_org    LIKE azp_file.azp01
DEFINE p_shop   LIKE ima_file.ima01
DEFINE l_ruc    RECORD LIKE ruc_file.*
DEFINE l_rty03  LIKE rty_file.rty03
DEFINE l_rty04  LIKE rty_file.rty04
DEFINE l_rty05  LIKE rty_file.rty05
DEFINE l_rty06  LIKE rty_file.rty06
DEFINE l_rty12  LIKE rty_file.rty12
DEFINE l_ima25  LIKE ima_file.ima25
DEFINE l_ima02  LIKE ima_file.ima02
DEFINE l_fac    LIKE type_file.num20_6
DEFINE l_flag   LIKE type_file.num5
 
   SELECT ima02,ima25 INTO l_ima02,l_ima25 FROM ima_file WHERE ima01 = p_rug.rug03
 
   SELECT rty03,rty04,rty05,rty06,rty12          #No.FUN-A10037 
     INTO l_rty03,l_rty04,l_rty05,l_rty06,l_rty12 #No.FUN-A10037 
       FROM rty_file WHERE rty01 = p_org AND rty02 = p_rug.rug03
  
   #No.FUN-A10037 ...begin 
   IF l_rty03 ='2' OR l_rty03='4' THEN
      IF cl_null(l_rty12) THEN
         CALL cl_err3("sel","rty_file",l_ruc.ruc01,p_rug.rug03,'art-619',"","",1)
         RETURN 0
      END IF
   END IF
   #No.FUN-A10037 ... end
   LET l_ruc.ruc00 = '1'
   LET l_ruc.ruc01 = p_org
   LET l_ruc.ruc02 = p_no           #請購單單號
   LET l_ruc.ruc03 = g_n            #請購單項次
   LET l_ruc.ruc04 = p_rug.rug03
   LET l_ruc.ruc05 = g_today
   LET l_ruc.ruc06 = p_org
   LET l_ruc.ruc07 = '6'
   LET l_ruc.ruc08 = p_rug.rug01
   LET l_ruc.ruc09 = p_rug.rug02
   LET l_ruc.ruc10 = l_rty05
   LET l_ruc.ruc11 = l_rty06
   LET l_ruc.ruc12 = l_rty03
   LET l_ruc.ruc13 = l_ima25
   LET l_ruc.ruc14 = NULL                        
   LET l_ruc.ruc15 = l_ima02
   LET l_ruc.ruc16 = p_rug.rug04
   CALL s_umfchk(p_rug.rug03,p_rug.rug04,l_ima25) RETURNING l_flag,l_fac
   LET l_ruc.ruc17 = l_fac
   LET l_ruc.ruc18 = p_rug.rug05
   LET l_ruc.ruc19 = 0
   LET l_ruc.ruc20 = 0
   LET l_ruc.ruc21 = 0
   LET l_ruc.ruc22 = NULL
   IF l_rty03 = '2' OR l_rty03='4' THEN  #No.FUN-A10037
      LET l_ruc.ruc24 = p_no
      LET l_ruc.ruc25 = g_n
      LET l_ruc.ruc23 = p_org
   ELSE
      LET l_ruc.ruc24 = NULL
      LET l_ruc.ruc25 = NULL
      LET l_ruc.ruc23 = NULL
   END IF
   LET l_ruc.ruc26 = l_rty04
   LET l_ruc.ruc27 = p_rug.rug06
   LET l_ruc.ruc28 = '1'
   #LET l_ruc.rucplant = p_org  #No.FUN-9C0069
   #SELECT azw02 INTO l_ruc.ruclegal FROM azw_file WHERE azw01=p_org#No.FUN-9C0069
   LET l_ruc.ruc29 = 'N'
   LET l_ruc.ruc30 = l_rty12     #No.FUN-A10037
   LET l_ruc.ruc31 = p_rug.rug07 #No.FUN-870007
   LET l_ruc.ruc33 = ' '         #FUN-CC0057 add
   INSERT INTO ruc_file VALUES(l_ruc.*)
   #IF SQLCA.SQLCODE = 100 THEN  #No.FUN-9C0079
   IF SQLCA.SQLCODE THEN         #No.FUN-9C0079
      CALL cl_err3("ins","ruc_file",l_ruc.ruc01,"",SQLCA.sqlcode,"","",1)
      RETURN 0
   END IF
  
   RETURN 1
END FUNCTION
FUNCTION t400_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n      LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF g_ruf.ruf01 IS NULL OR g_ruf.rufplant IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01=g_ruf.ruf01 AND rufplant = g_ruf.rufplant
     
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ruf.rufconf='X' THEN RETURN END IF
    ELSE
       IF g_ruf.rufconf <>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_ruf.rufconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruf.rufacti = 'N' THEN CALL cl_err(g_ruf.ruf01,'art-142',0) RETURN END IF
  #IF g_ruf.rufconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF  #TQC-AB0241
   BEGIN WORK
 
   OPEN t400_cl USING g_ruf.ruf01
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t400_cl INTO g_ruf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_ruf.rufconf) THEN
      LET g_chr = g_ruf.rufconf
      IF g_ruf.rufconf = 'N' THEN
         LET g_ruf.rufconf = 'X'
      ELSE
         LET g_ruf.rufconf = 'N'
      END IF
      UPDATE ruf_file SET rufconf=g_ruf.rufconf,
                          rufmodu=g_user,
                          rufdate=g_today
       WHERE ruf01 = g_ruf.ruf01 AND rufplant = g_ruf.rufplant
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ruf_file",g_ruf.ruf01,"",SQLCA.sqlcode,"","up rufconf",1)
          LET g_ruf.rufconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t400_cl
   COMMIT WORK
 
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01=g_ruf.ruf01  AND rufplant = g_ruf.rufplant
   DISPLAY BY NAME g_ruf.rufconf                                                                                         
   DISPLAY BY NAME g_ruf.rufmodu                                                                                         
   DISPLAY BY NAME g_ruf.rufdate
    #CKP
   IF g_ruf.rufconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruf.rufconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruf.ruf01,'V')
END FUNCTION
FUNCTION t400_bp_refresh()
  DISPLAY ARRAY g_rug TO s_rug.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t400_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
  
   MESSAGE ""
   CLEAR FORM
   CALL g_rug.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruf.* LIKE ruf_file.*
   LET g_ruf01_t = NULL
 
   LET g_ruf_t.* = g_ruf.*
   LET g_ruf_o.* = g_ruf.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruf.rufuser=g_user
      LET g_ruf.rufgrup=g_grup
      LET g_ruf.rufacti='Y'
      LET g_ruf.rufcrat = g_today
      LET g_ruf.rufconf = 'N'
      LET g_ruf.ruf02 = g_today
      LET g_ruf.rufplant = g_plant
      LET g_data_plant =g_plant   #TQC-A10128 ADD
      LET g_ruf.ruforiu = g_user  #TQC-A20007 ADD    
      LET g_ruf.ruforig = g_grup     
      SELECT azw02 INTO g_ruf.ruflegal FROM azw_file
       WHERE azw01 = g_plant
 
      CALL t400_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_ruf.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruf.ruf01) OR cl_null(g_ruf.rufplant) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_ruf.ruf01,g_ruf.ruf02,"","ruf_file",  #FUN-A70130 mark                                                           
#                           "ruf01","","","")                             #FUN-A70130 mark                                                   
      CALL s_auto_assign_no("art",g_ruf.ruf01,g_ruf.ruf02,"D6","ruf_file",  #FUN-A70130 mod                                                           
                            "ruf01","","","")                             #FUN-A70130 mod                                                   
                RETURNING li_result,g_ruf.ruf01
      IF (NOT li_result) THEN                                                                                                      
         CONTINUE WHILE                                                                                                           
      END IF                                                                                                                       
      DISPLAY BY NAME g_ruf.ruf01

    #TQC-A20007 MARK  
    # LET g_ruf.ruforiu = g_user      #No.FUN-980030 10/01/04
    # LET g_ruf.ruforig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ruf_file VALUES (g_ruf.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK          # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","ruf_file",g_ruf.ruf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK           #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ruf.ruf01,'I')
      END IF
 
      SELECT * INTO g_ruf.* FROM ruf_file
       WHERE ruf01 = g_ruf.ruf01 
      LET g_ruf01_t = g_ruf.ruf01
      LET g_ruf_t.* = g_ruf.*
      LET g_ruf_o.* = g_ruf.*
      CALL g_rug.clear()
#FUN-870007-start-
      CALL t400_create_b('a')
      CALL t400_b_fill(" 1=1")
      LET l_ac = g_rec_b   
#FUN-870007--end--
#      LET g_rec_b = 0
      CALL t400_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t400_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruf.ruf01 IS NULL OR g_ruf.rufplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruf.* FROM ruf_file
    WHERE ruf01=g_ruf.ruf01 
 
   IF g_ruf.rufacti ='N' THEN
      CALL cl_err(g_ruf.ruf01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_ruf.rufconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_ruf.rufconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ruf01_t = g_ruf.ruf01
 
   BEGIN WORK
 
   OPEN t400_cl USING g_ruf.ruf01
 
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t400_cl INTO g_ruf.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t400_show()
 
   WHILE TRUE
      LET g_ruf01_t = g_ruf.ruf01
      LET g_ruf_o.* = g_ruf.*
      LET g_ruf.rufmodu=g_user
      LET g_ruf.rufdate=g_today
 
      CALL t400_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruf.*=g_ruf_t.*
         CALL t400_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruf.ruf01 != g_ruf01_t THEN
         UPDATE rug_file SET rug01 = g_ruf.ruf01
           WHERE rug01 = g_ruf01_t AND rugplant = g_ruf.rufplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rug_file",g_ruf01_t,"",SQLCA.sqlcode,"","rug",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ruf_file SET ruf_file.* = g_ruf.*
       WHERE ruf01 = g_ruf.ruf01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruf_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t400_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruf.ruf01,'U')
 
   CALL t400_b_fill("1=1")
   CALL t400_bp_refresh()
 
END FUNCTION
 
FUNCTION t400_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   l_azp02   LIKE azp_file.azp02,
   li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   DISPLAY BY NAME g_ruf.ruf01,g_ruf.ruf02,g_ruf.ruf03,
                   g_ruf.rufconf,g_ruf.rufcond,g_ruf.rufcont,
                   g_ruf.rufconu,g_ruf.rufplant,g_ruf.rufuser,
                   g_ruf.rufmodu,g_ruf.rufacti,g_ruf.rufgrup,
                   g_ruf.rufdate,g_ruf.rufcrat
                  ,g_ruf.ruforiu,g_ruf.ruforig                 #TQC-A20007 ADD
 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruf.rufplant
   DISPLAY l_azp02 TO FORMONLY.rufplant_desc
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_ruf.ruf01,g_ruf.ruf02,g_ruf.ruf03,
                 g_ruf.rufconf,g_ruf.rufcond,g_ruf.rufcont,
                 g_ruf.rufconu,g_ruf.rufuser,
                 g_ruf.rufmodu,g_ruf.rufacti,g_ruf.rufgrup,
                 g_ruf.rufdate,g_ruf.rufcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t400_set_entry(p_cmd)
         CALL t400_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ruf01")
 
      AFTER FIELD ruf01
         IF NOT cl_null(g_ruf.ruf01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruf.ruf01 != g_ruf_t.ruf01) THEN
#              CALL s_check_no("art",g_ruf.ruf01,g_ruf01_t,"E","ruf_file","ruf01","") #FUN-A70130 mark                                             
               CALL s_check_no("art",g_ruf.ruf01,g_ruf01_t,"D6","ruf_file","ruf01","") #FUN-A70130 mod                                              
                    RETURNING li_result,g_ruf.ruf01                                                                                 
               IF (NOT li_result) THEN                                                                                              
                   LET g_ruf.ruf01=g_ruf01_t                                                                                        
                   NEXT FIELD ruf01                                                                                                 
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
            WHEN INFIELD(ruf01)
               LET g_t1=s_get_doc_no(g_ruf.ruf01)
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','E') RETURNING g_t1   #FUN-A70130--mark--
               CALL q_oay(FALSE,FALSE,g_t1,'D6','ART') RETURNING g_t1   #FUN-A70130--mod--
               LET g_ruf.ruf01 = g_t1
               DISPLAY BY NAME g_ruf.ruf01
               NEXT FIELD ruf01
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
 
FUNCTION t400_rug03()
    DEFINE l_imaacti LIKE ima_file.imaacti
 
   LET g_errno = " "
 
   SELECT ima02,imaacti
     INTO g_rug[l_ac].rug03_desc,l_imaacti
     FROM ima_file WHERE ima01 = g_rug[l_ac].rug03
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_rug[l_ac].rug03_desc TO FORMONLY.rug03_desc
   END CASE
 
END FUNCTION
 
FUNCTION t400_rug04()
DEFINE l_gfeacti LIKE gfe_file.gfeacti
 
   LET g_errno = " "
 
   SELECT gfe02,gfeacti
     INTO g_rug[l_ac].rug04_desc,l_gfeacti
     FROM gfe_file WHERE gfe01 = g_rug[l_ac].rug04
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = '100'
        WHEN l_gfeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_rug[l_ac].rug04_desc TO FORMONLY.rug04_desc
   END CASE
 
END FUNCTION
 
#FUN-870007-start-
FUNCTION t400_rug09(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_n        LIKE type_file.num5
DEFINE l_rug09_desc LIKE azp_file.azp02
 
       LET g_errno = ''
       SELECT azp02 INTO l_rug09_desc FROM azp_file
           WHERE azp01 = g_rug[l_ac].rug09
       CASE
          WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-511'
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
 
       IF cl_null(g_errno) THEN
          LET g_sql = "SELECT COUNT(*) FROM azp_file WHERE azp01 = '",
                      g_rug[l_ac].rug09,"' AND azp01 IN ",g_author
          PREPARE pre_azp1 FROM g_sql
          EXECUTE pre_azp1 INTO l_n
          IF l_n IS NULL THEN LET l_n = 0 END IF
          IF l_n = 0 THEN LET g_errno = 'art-500' END IF
       END IF
       IF cl_null(g_errno) OR p_cmd = 'd' THEN
          LET g_rug[l_ac].rug09_desc = l_rug09_desc
          DISPLAY BY NAME g_rug[l_ac].rug09_desc
       END IF
END FUNCTION
#FUN-870007--end--
 
FUNCTION t400_check_exchange()
DEFINE l_ima25    LIKE ima_file.ima25
 
    LET g_errno = ""
    IF g_rug[l_ac].rug03 IS NULL OR g_rug[l_ac].rug04 IS NULL THEN
       RETURN
    END IF
    
    IF g_rug[l_ac].rug03 IS NOT NULL THEN
       SELECT ima25 INTO l_ima25 FROM ima_file 
           WHERE ima01 = g_rug[l_ac].rug03 
       IF l_ima25 != g_rug[l_ac].rug04 THEN
          SELECT * FROM smc_file WHERE (smc01 = l_ima25 
                                 AND smc02 = g_rug[l_ac].rug04)
                                 OR (smc01 = g_rug[l_ac].rug04
                                 AND smc02 = l_ima25)
          IF SQLCA.sqlcode = 100 THEN
             LET g_errno = 'mfg2719'
          END IF
       END IF
    END IF   
END FUNCTION
 
FUNCTION t400_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rug.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t400_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ruf.* TO NULL
      RETURN
   END IF
 
   OPEN t400_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ruf.* TO NULL
   ELSE
      OPEN t400_count
      FETCH t400_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t400_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t400_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t400_cs INTO g_ruf.ruf01
      WHEN 'P' FETCH PREVIOUS t400_cs INTO g_ruf.ruf01
      WHEN 'F' FETCH FIRST    t400_cs INTO g_ruf.ruf01
      WHEN 'L' FETCH LAST     t400_cs INTO g_ruf.ruf01
      WHEN '/'
         IF (NOT g_no_ask) THEN
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
        FETCH ABSOLUTE g_jump t400_cs INTO g_ruf.ruf01
        LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
      INITIALIZE g_ruf.* TO NULL
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
 
   SELECT * INTO g_ruf.* FROM ruf_file WHERE ruf01 = g_ruf.ruf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruf_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ruf.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_ruf.rufuser
   LET g_data_group = g_ruf.rufgrup
   LET g_data_plant = g_ruf.rufplant  #TQC-A10128 ADD 
   CALL t400_show()
 
END FUNCTION
 
FUNCTION t400_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
 
   LET g_ruf_t.* = g_ruf.*
   LET g_ruf_o.* = g_ruf.*
   DISPLAY BY NAME g_ruf.ruf01,g_ruf.ruf02,g_ruf.ruf03,
                   g_ruf.rufconf,g_ruf.rufcond,g_ruf.rufcont,
                   g_ruf.rufconu,g_ruf.rufplant,g_ruf.rufuser,
                   g_ruf.rufmodu,g_ruf.rufacti,g_ruf.rufgrup,
                   g_ruf.rufdate,g_ruf.rufcrat
                  ,g_ruf.ruforiu,g_ruf.ruforig                 #TQC-A20007 ADD 

   IF g_ruf.rufconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_ruf.rufconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_ruf.ruf01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruf.rufconu
   DISPLAY l_gen02 TO FORMONLY.rufconu_desc
   
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruf.rufplant
   DISPLAY l_azp02 TO FORMONLY.rufplant_desc
 
   CALL t400_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t400_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruf.ruf01 IS NULL OR g_ruf.rufplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_ruf.rufconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruf.rufconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   
   BEGIN WORK 
   OPEN t400_cl USING g_ruf.ruf01
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      RETURN
   END IF
 
   FETCH t400_cl INTO g_ruf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   #BEGIN WORK 
   IF cl_exp(0,0,g_ruf.rufacti) THEN
      LET g_chr=g_ruf.rufacti
      IF g_ruf.rufacti='Y' THEN
         LET g_ruf.rufacti='N'
      ELSE
         LET g_ruf.rufacti='Y'
      END IF
      
      UPDATE ruf_file SET rufacti=g_ruf.rufacti,
                          rufmodu=g_user,
                          rufdate=g_today
       WHERE ruf01=g_ruf.ruf01 AND rufplant=g_ruf.rufplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruf_file",g_ruf.ruf01,"",SQLCA.sqlcode,"","",1) 
         LET g_ruf.rufacti=g_chr
      END IF
   END IF
 
   CLOSE t400_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruf.ruf01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rufacti,rufmodu,rufdate
     INTO g_ruf.rufacti,g_ruf.rufmodu,g_ruf.rufdate FROM ruf_file
    WHERE ruf01=g_ruf.ruf01
   DISPLAY BY NAME g_ruf.rufacti,g_ruf.rufmodu,g_ruf.rufdate
 
END FUNCTION
 
FUNCTION t400_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruf.ruf01 IS NULL OR g_ruf.rufplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruf.* FROM ruf_file
    WHERE ruf01=g_ruf.ruf01 
 
   IF g_ruf.rufconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_ruf.rufconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_ruf.rufacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t400_cl USING g_ruf.ruf01
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t400_cl INTO g_ruf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t400_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruf01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruf.ruf01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM ruf_file WHERE ruf01 = g_ruf.ruf01
      DELETE FROM rug_file WHERE rug01 = g_ruf.ruf01
      CLEAR FORM
      CALL g_rug.clear()
      OPEN t400_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t400_cs
         CLOSE t400_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t400_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t400_cs
         CLOSE t400_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t400_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t400_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t400_fetch('/')
      END IF
   END IF
 
   CLOSE t400_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruf.ruf01,'D')
END FUNCTION
 
FUNCTION t400_b()
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
DEFINE  i1       LIKE type_file.num5
DEFINE l_ima25   LIKE ima_file.ima25
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ruf.ruf01 IS NULL OR g_ruf.rufplant IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ruf.* FROM ruf_file
     WHERE ruf01=g_ruf.ruf01 
 
    IF g_ruf.rufacti ='N' THEN
       CALL cl_err(g_ruf.ruf01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_ruf.rufconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_ruf.rufconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
    CALL t400_get_author() #FUN-870007
    LET g_forupd_sql = "SELECT rug02,rug09,'',rug03,'',rug04,'',rug05,rug06,rug07,rug08 ", #FUN-870007-modify-add rug09
                       "  FROM rug_file ",
                       " WHERE rug01=? AND rug02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rug WITHOUT DEFAULTS FROM s_rug.*
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
 
           OPEN t400_cl USING g_ruf.ruf01
           IF STATUS THEN
              CALL cl_err("OPEN t400_cl:", STATUS, 1)
              CLOSE t400_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t400_cl INTO g_ruf.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
              CLOSE t400_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rug_t.* = g_rug[l_ac].*  #BACKUP
              LET g_rug_o.* = g_rug[l_ac].*  #BACKUP
              LET g_rug04_t = g_rug[l_ac].rug04   #FUN-BB0085
              OPEN t400_bcl USING g_ruf.ruf01,g_rug_t.rug02
              IF STATUS THEN
                 CALL cl_err("OPEN t400_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t400_bcl INTO g_rug[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rug_t.rug02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t400_rug03() 
                 CALL t400_rug04()
                 CALL t400_rug09('d')
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rug[l_ac].* TO NULL
           LET g_rug[l_ac].rug06 = g_today
           LET g_rug[l_ac].rug07 = TIME(CURRENT)         #Body default
 
           LET g_rug_t.* = g_rug[l_ac].*
           LET g_rug_o.* = g_rug[l_ac].*
           LET g_rug04_t = g_rug[l_ac].rug04             #FUN-BB0085
           CALL cl_show_fld_cont()
           NEXT FIELD rug02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rug_file(rug01,rug02,rug03,rug04,rug05,rug06,
                                rug07,rug08,rug09,rugplant,ruglegal)
           VALUES(g_ruf.ruf01,g_rug[l_ac].rug02,g_rug[l_ac].rug03,
                  g_rug[l_ac].rug04,g_rug[l_ac].rug05,g_rug[l_ac].rug06,
                  g_rug[l_ac].rug07,g_rug[l_ac].rug08,g_rug[l_ac].rug09,
                  g_ruf.rufplant,g_ruf.ruflegal)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rug_file",g_ruf.ruf01,g_rug[l_ac].rug02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rug02
           IF g_rug[l_ac].rug02 IS NULL OR g_rug[l_ac].rug02 = 0 THEN
              SELECT MAX(rug02)+1
                INTO g_rug[l_ac].rug02
                FROM rug_file
               WHERE rug01 = g_ruf.ruf01 
              IF g_rug[l_ac].rug02 IS NULL THEN
                 LET g_rug[l_ac].rug02 = 1
              END IF
           END IF
 
        AFTER FIELD rug02
           IF NOT cl_null(g_rug[l_ac].rug02) THEN
              IF g_rug[l_ac].rug02 != g_rug_t.rug02
                 OR g_rug_t.rug02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rug_file
                  WHERE rug01 = g_ruf.ruf01
                    AND rug02 = g_rug[l_ac].rug02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rug[l_ac].rug02 = g_rug_t.rug02
                    NEXT FIELD rug02
                 END IF
              END IF
           END IF
 
#FUN-870007-start-
      AFTER FIELD rug09
         IF NOT cl_null(g_rug[l_ac].rug09) THEN
            IF g_rug_o.rug09 IS NULL OR
               (g_rug[l_ac].rug09 != g_rug_o.rug09 ) THEN
               CALL t400_rug09('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rug[l_ac].rug09,g_errno,0)
                  LET g_rug[l_ac].rug09 = g_rug_o.rug09
                  DISPLAY BY NAME g_rug[l_ac].rug09
                  NEXT FIELD rug09
               END IF
            END IF
         END IF
#FUN-870007--end--
 
      AFTER FIELD rug03
         IF NOT cl_null(g_rug[l_ac].rug03) THEN
#NO.FUN-A90048 add -----------start--------------------     
          IF NOT s_chk_item_no(g_rug[l_ac].rug03,'') THEN
             CALL cl_err('',g_errno,1)
             LET g_rug[l_ac].rug03= g_rug_t.rug03 
             NEXT FIELD rug03
             ELSE 
                IF NOT s_chk_item_no(g_rug[l_ac].rug03,g_rug[l_ac].rug09) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_rug[l_ac].rug03= g_rug_t.rug03
                   NEXT FIELD rug03
                END IF 
          END IF
#NO.FUN-A90048 add ------------end --------------------         
            IF g_rug_o.rug03 IS NULL OR
               (g_rug[l_ac].rug03 != g_rug_o.rug03 ) THEN
               CALL t400_rug03()          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rug[l_ac].rug03,g_errno,0)
                  LET g_rug[l_ac].rug03 = g_rug_o.rug03
                  DISPLAY BY NAME g_rug[l_ac].rug03
                  NEXT FIELD rug03
               END IF
               #檢查該商品是否是商品策略範圍內的商品
               CALL t400_shop_method()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rug[l_ac].rug03,g_errno,0)
                  NEXT FIELD rug03
               END IF
               #檢查該商品的轉換率
               CALL t400_check_exchange()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rug[l_ac].rug03,g_errno,0)
                  LET g_rug[l_ac].rug03 = g_rug_o.rug03
                  DISPLAY BY NAME g_rug[l_ac].rug03
                  NEXT FIELD rug03
               END IF
               IF NOT t400_check_count() THEN
                  NEXT FIELD rug03
               END IF
            END IF  
         END IF  
 
        AFTER FIELD rug04
           IF NOT cl_null(g_rug[l_ac].rug04) THEN
              CALL t400_rug04()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rug[l_ac].rug04,g_errno,0)
                 LET g_rug[l_ac].rug04 = g_rug_o.rug04
                 DISPLAY BY NAME g_rug[l_ac].rug04
                 NEXT FIELD rug04
              END IF
              CALL t400_check_exchange()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rug[l_ac].rug04,g_errno,0)
                 LET g_rug[l_ac].rug04 = g_rug_o.rug04
                 DISPLAY BY NAME g_rug[l_ac].rug04
                 NEXT FIELD rug04
              END IF
              #FUN-BB0085-add-str--
              IF NOT cl_null(g_rug[l_ac].rug05) AND g_rug[l_ac].rug05 <> 0 THEN       #FUN-C20068
                 IF NOT t400_rug05_check() THEN 
                    LET g_rug04_t = g_rug[l_ac].rug04
                    NEXT FIELD rug05
                 END IF
                 LET g_rug04_t = g_rug[l_ac].rug04
              END IF                                   #FUN-C20068
              #FUN-BB0085-add-end--
           END IF
        
        AFTER FIELD rug05
           IF NOT t400_rug05_check() THEN NEXT FIELD rug05 END IF      #FUN-BB0085
           #FUN-BB0085-add-str--
           #IF NOT cl_null(g_rug[l_ac].rug05) THEN
           #   IF g_rug[l_ac].rug05 <= 0 THEN
           #      CALL cl_err('','art-514',0)
           #      NEXT FIELD rug05                
           #   END IF
           #   IF NOT t400_check_count() THEN
           #      NEXT FIELD rug05
           #   END IF
           #END IF
           #FUN-BB0085-add-end--
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rug_t.rug02 > 0 AND g_rug_t.rug02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rug_file
               WHERE rug01 = g_ruf.ruf01
                 AND rug02 = g_rug_t.rug02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rug_file",g_ruf.ruf01,g_rug_t.rug02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rug[l_ac].* = g_rug_t.*
              CLOSE t400_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rug[l_ac].rug02,-263,1)
              LET g_rug[l_ac].* = g_rug_t.*
           ELSE
              UPDATE rug_file SET rug02=g_rug[l_ac].rug02,
                                  rug03=g_rug[l_ac].rug03,
                                  rug04=g_rug[l_ac].rug04,
                                  rug05=g_rug[l_ac].rug05,
                                  rug06=g_rug[l_ac].rug06,
                                  rug07=g_rug[l_ac].rug07,
                                  rug08=g_rug[l_ac].rug08,
                                  rug09=g_rug[l_ac].rug09   #FUN-870007-add
               WHERE rug01=g_ruf.ruf01
                 AND rug02=g_rug_t.rug02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rug_file",g_ruf.ruf01,g_rug_t.rug02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rug[l_ac].* = g_rug_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rug[l_ac].* = g_rug_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rug.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t400_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033
           CLOSE t400_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rug02) AND l_ac > 1 THEN
              LET g_rug[l_ac].* = g_rug[l_ac-1].*
              LET g_rug[l_ac].rug02 = g_rec_b + 1
              NEXT FIELD rug02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rug03)
           #No.FUN-A90048 -----------------start--------------------------   
           #      CALL cl_init_qry_var()
           #      IF cl_null(g_rtz04) THEN
           #         LET g_qryparam.form = "q_ima"
           #      ELSE
           #         LET g_qryparam.form ="q_ruf01_1"
           #         LET g_qryparam.arg1 = g_rtz04
           #      END IF
           #      LET g_qryparam.default1 = g_rug[l_ac].rug03
           #      CALL cl_create_qry() RETURNING g_rug[l_ac].rug03
                  CALL q_sel_ima(FALSE, "q_ima", "",g_rug[l_ac].rug03, "", "", "", "" ,"",'' )
                                    RETURNING g_rug[l_ac].rug03
           #No.FUN-A90048 ---------------- end ----------------------------
                 DISPLAY BY NAME g_rug[l_ac].rug03
                 CALL t400_rug03()
                 NEXT FIELD rug03
                 
              WHEN INFIELD(rug04)
                 CALL cl_init_qry_var()
                 SELECT ima25 INTO l_ima25 FROM ima_file 
                     WHERE ima01 = g_rug[l_ac].rug03
                 LET g_qryparam.form = "q_smc01_1"
                 LET g_qryparam.default1 = g_rug[l_ac].rug04
                 LET g_qryparam.arg1 = l_ima25
                 CALL cl_create_qry() RETURNING g_rug[l_ac].rug04
                 DISPLAY BY NAME g_rug[l_ac].rug04
                 CALL t400_rug04()
                 NEXT FIELD rug04
#FUN-870007-start-
             WHEN INFIELD(rug09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.where = "azp01 IN ",g_author
                 LET g_qryparam.default1 = g_rug[l_ac].rug09
                 CALL cl_create_qry() RETURNING g_rug[l_ac].rug09
                 DISPLAY BY NAME g_rug[l_ac].rug09
                 CALL t400_rug09('d')
                 NEXT FIELD rug09
#FUN-870007--end--                 
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
 
    UPDATE ruf_file SET rufmodu = g_ruf.rufmodu,rufdate = g_ruf.rufdate
       WHERE ruf01 = g_ruf.ruf01 
     
    DISPLAY BY NAME g_ruf.rufmodu,g_ruf.rufdate
 
    CLOSE t400_bcl
    COMMIT WORK
#   CALL t400_delall()  #CHI-C30002 mark
    CALL t400_delHeader()     #CHI-C30002 add
 
END FUNCTION
FUNCTION t400_check_count()
DEFINE l_rtb03   LIKE rtb_file.rtb03
DEFINE l_rtb02   LIKE rtb_file.rtb02
DEFINE l_flag    LIKE type_file.num5
DEFINE l_fac     LIKE type_file.num20_6
DEFINE l_msg     LIKE type_file.chr1000
 
   IF g_rug[l_ac].rug03 IS NULL OR g_rug[l_ac].rug05 IS NULL THEN
      RETURN TRUE
   END IF
 
   SELECT rtb02,rtb03 INTO l_rtb02,l_rtb03 FROM rtb_file WHERE rtb01 = g_rug[l_ac].rug03
   IF l_rtb03 IS NOT NULL AND l_rtb02 IS NOT NULL THEN
      CALL s_umfchk(g_rug[l_ac].rug03,g_rug[l_ac].rug04,l_rtb02) 
         RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET l_msg = g_rug[l_ac].rug05 CLIPPED,'->',l_rtb03 CLIPPED
         CALL cl_err(l_msg CLIPPED,'aqc-500',1)
         LET l_fac = NULL
         RETURN FALSE
      END IF
      LET g_rug[l_ac].rug05 = g_rug[l_ac].rug05*l_fac
      LET g_rug[l_ac].rug05 = s_digqty(g_rug[l_ac].rug05,g_rug[l_ac].rug04)  #FUN-BB0085
      IF (g_rug[l_ac].rug05 MOD l_rtb03) != 0 THEN
         IF NOT cl_confirm('art-543') THEN
            RETURN FALSE
         END IF
      END IF
   END IF
 
   RETURN TRUE
END FUNCTION
FUNCTION t400_shop_method()
DEFINE l_rtz04    LIKE rtz_file.rtz04
DEFINE l_rte04    LIKE rte_file.rte04
DEFINE l_rte07    LIKE rte_file.rte07
 
   LET g_errno = ""
   SELECT rtz04 INTO l_rtz04 FROM rtz_file 
    WHERE rtz01 = g_rug[l_ac].rug09
   IF NOT cl_null(l_rtz04) THEN              #FUN-AB0101
      SELECT rte04,rte07 INTO l_rte04,l_rte07 FROM rte_file
       WHERE rte01 = l_rtz04 AND rte03 = g_rug[l_ac].rug03
      IF SQLCA.SQLCODE = 100 THEN
         LET g_errno = 'art-172'
      END IF
      IF cl_null(g_errno) THEN
         IF l_rte07 = 'N' THEN LET g_errno = 'art-522' END IF
      END IF   
      IF cl_null(g_errno) THEN
         IF l_rte04 = 'N' THEN LET g_errno = 'art-523' END IF
      END IF
    END IF       #FUN-AB0101
END FUNCTION 

#CHI-C30002 -------- add -------- begin
FUNCTION t400_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruf.ruf01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruf_file ",
                  "  WHERE ruf01 LIKE '",l_slip,"%' ",
                  "    AND ruf01 > '",g_ruf.ruf01,"'"
      PREPARE t400_pb2 FROM l_sql 
      EXECUTE t400_pb2 INTO l_cnt
      
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
         CALL t400_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruf_file WHERE ruf01 = g_ruf.ruf01
         INITIALIZE g_ruf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t400_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rug_file
#   WHERE rug01 = g_ruf.ruf01
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ruf_file WHERE ruf01 = g_ruf.ruf01 
#
#     CLEAR FORM
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t400_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rug02,rug09,'',rug03,'',rug04,'',rug05,rug06,rug07,rug08 ",#FUN-870007-modify-add rug09
               "  FROM rug_file",
               " WHERE rug01 ='",g_ruf.ruf01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rug02 "
 
   DISPLAY g_sql
 
   PREPARE t400_pb FROM g_sql
   DECLARE rug_cs CURSOR FOR t400_pb
 
   CALL g_rug.clear()
   LET g_cnt = 1
 
   FOREACH rug_cs INTO g_rug[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02 INTO g_rug[g_cnt].rug03_desc FROM ima_file
           WHERE ima01 = g_rug[g_cnt].rug03
       
       SELECT gfe02 INTO g_rug[g_cnt].rug04_desc FROM gfe_file
           WHERE gfe01 = g_rug[g_cnt].rug04
#FUN-870007-start-
       SELECT azp02 INTO g_rug[g_cnt].rug09_desc FROM azp_file
        WHERE azp01 = g_rug[g_cnt].rug09
#FUN-870007--end--           
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rug.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t400_copy()
   DEFINE l_newno     LIKE ruf_file.ruf01,
          l_oldno     LIKE ruf_file.ruf01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ruf.ruf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t400_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ruf01
       AFTER FIELD ruf01
          IF l_newno IS NULL THEN
             NEXT FIELD ruf01
          ELSE
#            CALL s_check_no("art",l_newno,"","E","ruf_file","ruf01","") #FUN-A70130 mark
             CALL s_check_no("art",l_newno,"","D6","ruf_file","ruf01","") #FUN-A70130 mod
                RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                LET g_ruf.ruf01=g_ruf_t.ruf01 
                NEXT FIELD ruf01
             END IF
             BEGIN WORK
#            CALL s_auto_assign_no("art",l_newno,g_today,"","rus_file","rus01","","","")  #FUN-A70130 mark
            #CALL s_auto_assign_no("art",l_newno,g_today,"D5","rus_file","rus01","","","")#FUN-A70130 mod
             CALL s_auto_assign_no("art",l_newno,g_today,"D6","ruf_file","ruf01","","","")#No.FUN-A70130 By shi
                RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                ROLLBACK WORK
                NEXT FIELD ruf01
             ELSE
                COMMIT WORK
             END IF
          END IF
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(ruf01)
               LET g_t1=s_get_doc_no(l_newno)
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','E') RETURNING g_t1    #FUN-A70130--mark--
               CALL q_oay(FALSE,FALSE,g_t1,'D6','ART') RETURNING g_t1   #FUN-A70130--mod--
               LET l_newno = g_t1
               DISPLAY l_newno TO ruf01
               NEXT FIELD ruf01
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
      DISPLAY BY NAME g_ruf.ruf01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM ruf_file
    WHERE ruf01=g_ruf.ruf01
     INTO TEMP y
 
   UPDATE y
       SET ruf01=l_newno,
           rufconf = 'N',
           rufcont = NULL,
           rufcond = NULL,
           rufconu = NULL,
           rufuser=g_user,
           rufgrup=g_grup,
           rufmodu=NULL,
           rufdate=g_today,
           rufacti='Y',
           rufcrat=g_today
 
   INSERT INTO ruf_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruf_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rug_file
    WHERE rug01=g_ruf.ruf01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rug01=l_newno
 
   INSERT INTO rug_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rug_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK         #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_ruf.ruf01
   SELECT ruf_file.* INTO g_ruf.* FROM ruf_file WHERE ruf01 = l_newno
   CALL t400_u()
   CALL t400_b()
   #SELECT ruf_file.* INTO g_ruf.* FROM ruf_file WHERE ruf01 = l_oldno  #FUN-C80046
   #CALL t400_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t400_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_ruf.ruf01 IS NOT NULL THEN
       LET g_wc = "ruf01='",g_ruf.ruf01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt400" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t400_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ruf01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t400_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ruf01",FALSE)
    END IF
 
END FUNCTION
 
#FUN-870007-start-
FUNCTION t400_get_author()
DEFINE l_azw01 LIKE azw_file.azw01
 
    LET g_sql = "SELECT azw01 FROM azw_file WHERE azw07 = '",g_ruf.rufplant,"'"
    PREPARE pre_azw FROM g_sql
    DECLARE cur1_azw CURSOR FOR pre_azw
#    LET g_author = " ('"                                 #TQC-AC0371
    LET g_author = " ('",g_plant,"','"                    #TQC-AC0371
    FOREACH cur1_azw INTO l_azw01
       IF l_azw01 IS NULL THEN CONTINUE FOREACH END IF
       LET g_author = g_author,l_azw01,"','"
    END FOREACH
    LET g_author = g_author.substring(1,(g_author.getlength()-2))
    IF g_author.getlength() != 0 THEN
       LET g_author = g_author,") "
    END IF
END FUNCTION
 
FUNCTION t400_create_b(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_rug RECORD LIKE rug_file.*
DEFINE l_n,l_cnt LIKE type_file.num10
DEFINE l_gfeacti LIKE gfe_file.gfeacti
DEFINE l_wc,l_wc_t STRING
DEFINE l_tok base.StringTokenizer
DEFINE l_flag    LIKE type_file.num5
DEFINE l_fac     LIKE ima_file.ima31_fac
DEFINE l_success LIKE type_file.chr1
DEFINE l_buf STRING
DEFINE l_ima25 LIKE ima_file.ima25
DEFINE l_rug04 LIKE rug_file.rug04
DEFINE l_tf    LIKE type_file.chr1   #FUN-BB0085
#FUN-C80061---add---str
DEFINE l_rug02   LIKE rug_file.rug02  
DEFINE l_rug02_1 LIKE rug_file.rug02
DEFINE l_sql     STRING
#FUN-C80061---add---end
    IF cl_null(g_ruf.ruf01) THEN
       RETURN
    END IF
    BEGIN WORK
    #IF p_cmd = 'u' THEN             #FUN-C80061 mark
       OPEN t400_cl USING g_ruf.ruf01
       IF STATUS THEN
          CALL cl_err("OPEN t400_cl:", STATUS, 1)
          CLOSE t400_cl
          ROLLBACK WORK              #FUN-C80061 add
          RETURN
       END IF
 
       FETCH t400_cl INTO g_ruf.*                      
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)    
          CLOSE t400_cl
          ROLLBACK WORK              #FUN-C80061 add
          RETURN
       END IF
       IF g_ruf.rufacti ='N' THEN    
          CALL cl_err(g_ruf.ruf01,'mfg1000',0)
          ROLLBACK WORK              #FUN-C80061 add
          RETURN
       END IF
       IF g_ruf.rufconf <> 'N' THEN
          CALL cl_err(g_ruf.ruf01,'9022',0)
          ROLLBACK WORK              #FUN-C80061 add
          RETURN
       END IF
    #END IF                          #FUN-C80061 mark
    LET INT_FLAG = 0
 
    OPEN WINDOW t400a WITH FORM "art/42f/artt400a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt400a")
 
    CALL t400_get_author()
 
    CONSTRUCT BY NAME l_wc_t ON ima01,ima131,rug09  
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
             #FUN-A90048 ---------------start------------------------
             #      CALL cl_init_qry_var()
             #      LET g_qryparam.state ="c"
             #      IF cl_null(g_rtz04) THEN
             #       LET g_qryparam.form = "q_ima"
             #      ELSE
             #       LET g_qryparam.form ="q_ruf01_1"
             #       LET g_qryparam.arg1 = g_rtz04
             #      END IF
             #      CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima", "","", "", "", "", "" ,"",'' )
                         RETURNING g_qryparam.multiret
             #FUN-A90048 ----------------end-------------------------       
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
              WHEN INFIELD(rug09)     #机构
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_azp"
                   LET g_qryparam.where = "azp01 IN ",g_author
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rug09
                   NEXT FIELD rug09
              WHEN INFIELD(ima131)     #
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
       IF cl_null(GET_FLDBUF(rug09)) THEN
          NEXT FIELD rug09
          CONTINUE CONSTRUCT
       ELSE
          LET l_buf = GET_FLDBUF(rug09)
       END IF
   END CONSTRUCT
 
   IF INT_FLAG THEN
      CLOSE WINDOW t400a
      RETURN
   END IF
 
   LET l_rug.rug06 = g_today
   LET l_rug.rug07 = TIME
   DISPLAY l_rug.rug06,l_rug.rug07 TO rug06,rug07
   INPUT l_rug.rug04,l_rug.rug05,l_rug.rug06,l_rug.rug07 
    WITHOUT DEFAULTS
    FROM rug04,rug05,rug06,rug07
      AFTER FIELD rug04 
         IF NOT cl_null(l_rug.rug04) THEN
            LET l_tf = TRUE
            SELECT COUNT(*),gfeacti INTO l_n,l_gfeacti FROM gfe_file
             WHERE gfe01 = l_rug.rug04
              GROUP BY gfeacti
            IF l_n = 0 THEN CALL cl_err('','art-031',0) NEXT FIELD rug04 END IF
            IF l_gfeacti = 'N' THEN CALL cl_err('','9028',0) NEXT FIELD rug04 END IF
            IF NOT cl_null(l_rug.rug05) AND l_rug.rug05 <> 0 THEN                          #FUN-C20068          
               CALL t400_rug05_check2(l_rug.rug04,l_rug.rug05) RETURNING l_tf,l_rug.rug05     #FUN-BB0085
               IF NOT l_tf THEN NEXT FIELD rug05 END IF                                       #FUN-BB0085
            END IF                                                                         #FUN-C20068
         END IF
 
      AFTER FIELD rug05 
         LET l_tf = TRUE
         CALL t400_rug05_check2(l_rug.rug04,l_rug.rug05) RETURNING l_tf,l_rug.rug05     #FUN-BB0085
         IF NOT l_tf THEN NEXT FIELD rug05 END IF                                       #FUN-BB0085
         #FUN-BB0085-mark-str--
         #IF NOT cl_null(l_rug.rug05) THEN
         #  IF l_rug.rug05 <= 0 THEN
         #     CALL cl_err(l_rug.rug05,'axr-034',0)
         #     NEXT FIELD rug05
         #  END IF
         #END IF
         #FUN-BB0085-mark-end--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rug04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = l_rug.rug04
                 CALL cl_create_qry() RETURNING l_rug.rug04
                 DISPLAY BY NAME l_rug.rug04   
                 NEXT FIELD rug04
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
       CLOSE WINDOW t400a
       RETURN
   END IF
   IF cl_null(l_rug.rug06) THEN LET l_rug.rug06 = g_today END IF
   IF cl_null(l_rug.rug07) THEN LET l_rug.rug07 = TIME END IF
   
   
   #FUN-C80061----mark-----str
   #LET l_cnt = l_wc_t.getIndexOf('rug09',1)
   #LET l_wc = l_wc_t.substring(1,l_cnt-5)
   #DROP TABLE rug_temp
   #SELECT * FROM rug_file WHERE 1=0 INTO TEMP rug_temp
   #BEGIN WORK
   #LET g_success = 'Y'
   #LET l_success = 'Y'
   #CALL s_showmsg_init()
   #LET l_tok = base.StringTokenizer.create(l_buf,"|")
   #SELECT COALESCE(MAX(rug02),0)+1 INTO g_cnt FROM rug_file
   # WHERE rug01 = g_ruf.ruf01 AND rugplant = g_ruf.rufplant
   #WHILE l_tok.hasMoreTokens()
   #LET l_rug.rug09 = l_tok.nextToken()
   #  SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01=l_rug.rug09
   #  IF l_n = 0 THEN
   #     CALL s_errmsg('rug09',l_rug.rug09,'','art-511',1)
   #     LET l_success = 'N'
   #     CONTINUE WHILE
   #  END IF
   #  IF cl_null(g_rtz04) THEN
   #   LET g_sql = "SELECT ima01,ima25 FROM ima_file ",
   #               " WHERE ",l_wc CLIPPED
   #  ELSE
   #   LET g_sql = "SELECT DISTINCT ima01,ima25 FROM ima_file,rte_file ",
   #               " WHERE ",l_wc CLIPPED,
   #               "   AND ima01 = rte03 ",
   #               "   AND rte01 = '",g_rtz04,"'",
   #               "   AND rte04 = 'Y'",
   #               "   AND rte07 = 'Y'"
   #  END IF
   #  DECLARE ima01_cs CURSOR FROM g_sql
   #  FOREACH ima01_cs INTO l_rug.rug03,l_ima25
   #No.FUN-A90048 -----------------start-----------------------    
   #    IF NOT s_chk_item_no(l_rug.rug03,g_ruf.rufplant) THEN
   #       CONTINUE FOREACH
   #    ELSE
   #       IF NOT s_chk_item_no(l_rug.rug03,l_rug.rug09) THEN
   #          CONTINUE FOREACH
   #       END IF
   #    END IF 
   #No.FUN-A90048 -----------------end----------------------
   #  
   #    IF cl_null(l_rug.rug04) THEN
   #       LET l_rug04 = l_ima25
   #    ELSE
   #       CALL s_umfchk(l_rug.rug03,l_ima25,l_rug.rug04) RETURNING l_flag,l_fac
   #       IF l_flag = 1 THEN
   #          LET g_showmsg = l_ima25,'|',l_rug.rug04
   #          CALL s_errmsg('ima25,rug04',g_showmsg,'','art-032',1)
   #          LET l_rug04 =l_ima25
   #          LET l_success = 'N'
   #       ELSE
   #          LET l_rug04 = l_rug.rug04
   #       END IF    
   #    END IF   
   #    INSERT INTO rug_temp(rug01,rug02,rug03,rug04,rug09,rugplant,ruglegal)
   #         VALUES(g_ruf.ruf01,g_cnt,
   #                l_rug.rug03,l_rug04,l_rug.rug09,g_ruf.rufplant,g_ruf.ruflegal)
   #    LET g_cnt = g_cnt + 1
   #  END FOREACH
   #END WHILE
   #UPDATE rug_temp SET rug05 = l_rug.rug05,
   #                    rug06 = l_rug.rug06,
   #                    rug07 = l_rug.rug07
   #INSERT INTO rug_file SELECT * FROM rug_temp
   #IF SQLCA.sqlcode THEN
   #   CALL s_errmsg('ruf01',g_ruf.ruf01,'',SQLCA.sqlcode,1)
   #   LET g_success = 'N'
   #END IF
   #IF SQLCA.sqlerrd[3]=0 THEN
   #   CALL cl_err('','art-187',0)
   #END IF 
   #FUN-C80061----mark-----end
   #FUN-C80061----add------str
   LET l_wc = cl_replace_str(l_wc_t, "rug09", "rtz01")
   LET g_success = 'Y'
   LET l_success = 'Y'
   CALL s_showmsg_init()
   SELECT MAX(rug02) INTO l_rug02
     FROM rug_file
    WHERE rug01 = g_ruf.ruf01
   IF cl_null(l_rug02) THEN
      LET l_rug02 = 0
   END IF
   IF cl_null(l_rug.rug04) THEN 
      LET l_rug.rug04 = ' '
   END IF
   IF NOT cl_null(g_rtz04) THEN
      LET l_sql = "ima01 IN (SELECT rte03 FROM rte_file",
                  "           WHERE rte04 = 'Y'",
                  "             AND rte07 = 'Y'",
                  "             AND rte01 = '",g_rtz04,"')"
   ELSE
      LET l_sql = " 1=1" 
   END IF
   LET g_sql = "INSERT INTO rug_file (rug01,rug02,rug03,rug04,rug05,rug06,rug07,rug08,rug09,ruglegal,rugplant)",
               "     SELECT '",g_ruf.ruf01,"',ROW_NUMBER() over(order by rtz01,ima01)+",l_rug02,",ima01,",
               "            CASE WHEN('",l_rug.rug04,"' = ' ') THEN ima25 ELSE '",l_rug.rug04,"' END,",
               "            ",l_rug.rug05,",'",l_rug.rug06,"','",l_rug.rug07,"','',rtz01,'",g_ruf.ruflegal,"','",g_ruf.rufplant,"'",
               "       FROM ima_file,rte_file,rtz_file",
               "      WHERE ima01 = rte03",
               "        AND rte01 = rtz04",
               "        AND rtz04 IS NOT NULL",
               "        AND rtz01 IN ",g_author,
               "        AND rte04= 'Y'",
               "        AND rte07 = 'Y'",
               "        AND ",l_sql CLIPPED,
               "        AND ", l_wc CLIPPED
   PREPARE pre_insrug FROM g_sql
   EXECUTE pre_insrug
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('rug01',g_ruf.ruf01,'ins rug',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   SELECT MAX(rug02) INTO l_rug02_1
     FROM rug_file
    WHERE rug01 = g_ruf.ruf01
   IF cl_null(l_rug02_1) THEN
      LET l_rug02_1 = 0
   END IF
   LET g_sql = "INSERT INTO rug_file (rug01,rug02,rug03,rug04,rug05,rug06,rug07,rug08,rug09,ruglegal,rugplant)",
               "     SELECT '",g_ruf.ruf01,"',ROW_NUMBER() over(order by rtz01,ima01)+",l_rug02_1,",ima01,",
               "            CASE WHEN('",l_rug.rug04,"' = ' ') THEN ima25 ELSE '",l_rug.rug04,"' END,",
               "            ",l_rug.rug05,",'",l_rug.rug06,"','",l_rug.rug07,"','',rtz01,'",g_ruf.ruflegal,"','",g_ruf.rufplant,"'",
               "       FROM ima_file,rtz_file",
               "      WHERE rtz04 IS NULL",
               "        AND rtz01 IN ",g_author,
               "        AND ",l_sql CLIPPED,
               "        AND ", l_wc CLIPPED
   PREPARE pre_insrug1 FROM g_sql
   EXECUTE pre_insrug1
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('rug01',g_ruf.ruf01,'ins rug',SQLCA.sqlcode,1) 
      LET g_success = 'N'
   END IF      
   IF g_success = 'Y' AND NOT cl_null(l_rug.rug04) THEN
      LET g_sql = " UPDATE rug_file SET rug04 = (SELECT ima25 FROM ima_file ",
                  "                               WHERE ima01 = rug03)",
                  "  WHERE rug01 = '",g_ruf.ruf01,"'",
                  "    AND rug02 > ",l_rug02,"",
                  "    AND EXISTS (SELECT 1 FROM ima_file ",
                  "                 WHERE ima01 = rug03",
                  "                   AND ima25 <> '",l_rug.rug04,"'",
                  "                   AND (NOT EXISTS (SELECT 1 FROM smd_file",
                  "                                     WHERE ima01 = smd01",
                  "                                       AND ((smd02 = ima25 AND smd03 = '",l_rug.rug04,"')",
                  "                                        OR (smd02 = '",l_rug.rug04,"' AND smd03 = ima25))))",
                  "                   AND (NOT EXISTS (SELECT 1 FROM smc_file",
                  "                                     WHERE smc01 = ima25 ",
                  "                                       AND smc02 = '",l_rug.rug04,"')))"
      PREPARE pre_updrug FROM g_sql
      EXECUTE pre_updrug
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('rug01',g_ruf.ruf01,'upd rug',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   #FUN-C80061----add------end
   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      IF l_success = 'N' THEN
         CALL s_showmsg()
      END IF 
      COMMIT WORK
   END IF
   CLOSE WINDOW t400a
END FUNCTION
 
FUNCTION t400_del_b()
DEFINE lc_qbe_sn   LIKE    gbm_file.gbm01
DEFINE l_wc STRING
      IF g_ruf.ruf01 IS NULL THEN
         RETURN
      END IF
      BEGIN WORK
      OPEN t400_cl USING g_ruf.ruf01
       IF STATUS THEN
          CALL cl_err("OPEN t400_cl:", STATUS, 1)
          CLOSE t400_cl
          RETURN
       END IF
 
       FETCH t400_cl INTO g_ruf.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_ruf.ruf01,SQLCA.sqlcode,0)
          CLOSE t400_cl
          RETURN
       END IF
       IF g_ruf.rufacti ='N' THEN
          CALL cl_err(g_ruf.ruf01,'mfg1000',0)
          RETURN
       END IF
       IF g_ruf.rufconf <> 'N' THEN
          CALL cl_err(g_ruf.ruf01,'9022',0)
          RETURN
       END IF
       LET INT_FLAG = 0
 
    OPEN WINDOW t400b WITH FORM "art/42f/artt400b"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("artt400b")
 
    CONSTRUCT BY NAME l_wc ON ima01,ima131,rug09
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
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rug03"
                  LET g_qryparam.where=" rug01='",g_ruf.ruf01,"' AND rugplant='",g_ruf.rufplant,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
              WHEN INFIELD(ima131)     #
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ima131_1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
              WHEN INFIELD(rug09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rug09"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rug09
                  NEXT FIELD rug09
        END CASE
   END CONSTRUCT
 
   IF INT_FLAG THEN
      CLOSE WINDOW t400b
      RETURN
   END IF
   IF l_wc = " 1=1" THEN
      CLOSE WINDOW t400b
      RETURN
   END IF
   LET g_sql = "DELETE FROM rug_file ",
               " WHERE rug01 = '",g_ruf.ruf01,"' AND rugplant = '",g_ruf.rufplant,"'",
               "   AND (rug03,rug09) IN (SELECT DISTINCT rug03,rug09 FROM rug_file,ima_file",
               "                          WHERE rug01 = '",g_ruf.ruf01,"' AND rugplant = '",g_ruf.rufplant,"'",
               "                            AND rug03 = ima01 AND ",l_wc CLIPPED,")"
   PREPARE del_rug FROM g_sql
   EXECUTE del_rug
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","rug_file",g_ruf.ruf01,g_ruf.rufplant,SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   CLOSE WINDOW t400b
END FUNCTION
#FUN-870007--end--

#FUN-BB0085----add----str----
FUNCTION t400_rug05_check()
   IF NOT cl_null(g_rug[l_ac].rug05) AND NOT cl_null(g_rug[l_ac].rug04) THEN 
      IF cl_null(g_rug04_t) OR g_rug04_t != g_rug[l_ac].rug04 OR 
         cl_null(g_rug_t.rug05) OR g_rug_t.rug05 != g_rug[l_ac].rug05 THEN
         LET g_rug[l_ac].rug05 = s_digqty(g_rug[l_ac].rug05,g_rug[l_ac].rug04)
         DISPLAY BY NAME g_rug[l_ac].rug05
      END IF
   END IF
 
   IF NOT cl_null(g_rug[l_ac].rug05) THEN
      IF g_rug[l_ac].rug05 <= 0 THEN
         CALL cl_err('','art-514',0)
         RETURN FALSE     
      END IF
      IF NOT t400_check_count() THEN
         RETURN FALSE    
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t400_rug05_check2(p_rug04,p_rug05)
DEFINE p_rug04  LIKE rug_file.rug04
DEFINE p_rug05  LIKE rug_file.rug05
   IF NOT cl_null(p_rug05) AND NOT cl_null(p_rug04) THEN
      LET p_rug05 = s_digqty(p_rug05,p_rug04)
      DISPLAY p_rug05 TO rug05
   END IF
   IF NOT cl_null(p_rug05) THEN
     IF p_rug05 <= 0 THEN
        CALL cl_err(p_rug05,'axr-034',0)
        RETURN FALSE,p_rug05    
     END IF
   END IF
   RETURN TRUE,p_rug05
END FUNCTION
#FUN-BB0085----add----end----
