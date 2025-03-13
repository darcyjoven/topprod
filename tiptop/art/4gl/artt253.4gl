# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt253.4gl
# Descriptions...: 配送分配調整單
# Date & Author..: No.FUN-870007 08/09/27 By Zhangyajun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0045 09/11/13 By xiaofeizhu DECODE寫法調整
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30041 10/03/41 By Cockroach add oriu/orig
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.TQC-B30114 11/03/17 By lilingyu 去掉套號欄位rvnn06
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.MOD-B80222 11/08/25 By suncx 去掉有关rvnn_file的相关逻辑

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rvo    RECORD LIKE rvo_file.*,
        g_rvo_t  RECORD LIKE rvo_file.*,
        g_rvo_o  RECORD LIKE rvo_file.*,
        g_rvp   DYNAMIC ARRAY OF RECORD 
                rvp02       LIKE rvp_file.rvp02, #項次
                rvp03       LIKE rvp_file.rvp03, #分貨單號
                rvp04       LIKE rvp_file.rvp04, #分貨項次
                ruc07       LIKE rvn_file.rvn05, #來源類型
               #rvnn05      LIKE rvn_file.rvn06, #要貨/需求機構   #MOD-B80222 mark
               #rvnn05_desc LIKE azp_file.azp02, #機構名稱        #MOD-B80222 mark
                rvn06       LIKE rvn_file.rvn06, #要貨/需求機構   #MOD-B80222 add
                rvn06_desc  LIKE azp_file.azp02, #機構	名稱      #MOD-B80222 add
                rvn12       LIKE rvn_file.rvn07, #出貨機構
                rvn12_desc  LIKE azp_file.azp02, #機構名稱
               #rvnn06      LIKE rvn_file.rvn07, #套號            #MOD-B80222 mark
                rvn09       LIKE rvn_file.rvn09, #产品编号        #MOD-B80222 add    
                ima02       LIKE ima_file.ima02, #套號名稱
                ima131      LIKE ima_file.ima131,#產品分類
                ruc16       LIKE ruc_file.ruc16, #分貨單位
                ruc16_desc  LIKE gfe_file.gfe02, #單位名稱
                ruc18       LIKE ruc_file.ruc18, #需求量
                ruc18_1     LIKE rvp_file.rvp05, #未分貨量
                rvp05       LIKE rvp_file.rvp05, #分貨量
                rvp06       LIKE rvp_file.rvp06, #調整方式
                rvp07       LIKE rvp_file.rvp07  #調整量
                        END RECORD,
        g_rvp_t RECORD
                rvp02       LIKE rvp_file.rvp02, #項次
                rvp03       LIKE rvp_file.rvp03, #分貨單號
                rvp04       LIKE rvp_file.rvp04, #分貨項次
                ruc07       LIKE rvn_file.rvn05, #來源類型
               #rvnn05      LIKE rvn_file.rvn06, #要貨/需求機構   #MOD-B80222 mark
               #rvnn05_desc LIKE azp_file.azp02, #機構名稱        #MOD-B80222 mark
                rvn06       LIKE rvn_file.rvn06, #要貨/需求機構   #MOD-B80222 add
                rvn06_desc  LIKE azp_file.azp02, #機構	名稱      #MOD-B80222 add
                rvn12       LIKE rvn_file.rvn07, #出貨機構
                rvn12_desc  LIKE azp_file.azp02, #機構名稱
               #rvnn06      LIKE rvn_file.rvn07, #套號            #MOD-B80222 mark
                rvn09       LIKE rvn_file.rvn09, #产品编号        #MOD-B80222 add
                ima02       LIKE ima_file.ima02, #套號名稱
                ima131      LIKE ima_file.ima131,#產品分類
                ruc16       LIKE ruc_file.ruc16, #分貨單位
                ruc16_desc  LIKE gfe_file.gfe02, #單位名稱
                ruc18       LIKE ruc_file.ruc18, #需求量
                ruc18_1     LIKE rvp_file.rvp05, #未分貨量
                rvp05       LIKE rvp_file.rvp05, #分貨量
                rvp06       LIKE rvp_file.rvp06, #調整方式
                rvp07       LIKE rvp_file.rvp07  #調整量
                        END RECORD,
       g_rvp_o RECORD
                rvp02       LIKE rvp_file.rvp02, #項次
                rvp03       LIKE rvp_file.rvp03, #分貨單號
                rvp04       LIKE rvp_file.rvp04, #分貨項次
                ruc07       LIKE rvn_file.rvn05, #來源類型
               #rvnn05      LIKE rvn_file.rvn06, #要貨/需求機構   #MOD-B80222 mark
               #rvnn05_desc LIKE azp_file.azp02, #機構名稱        #MOD-B80222 mark
                rvn06       LIKE rvn_file.rvn06, #要貨/需求機構   #MOD-B80222 add
                rvn06_desc  LIKE azp_file.azp02, #機構	名稱      #MOD-B80222 add
                rvn12       LIKE rvn_file.rvn07, #出貨機構
                rvn12_desc  LIKE azp_file.azp02, #機構名稱
               #rvnn06      LIKE rvn_file.rvn07, #套號            #MOD-B80222 mark 
                rvn09       LIKE rvn_file.rvn09, #产品编号        #MOD-B80222 add
                ima02       LIKE ima_file.ima02, #套號名稱
                ima131      LIKE ima_file.ima131,#產品分類
                ruc16       LIKE ruc_file.ruc16, #分貨單位
                ruc16_desc  LIKE gfe_file.gfe02, #單位名稱
                ruc18       LIKE ruc_file.ruc18, #需求量
                ruc18_1     LIKE rvp_file.rvp05, #未分貨量
                rvp05       LIKE rvp_file.rvp05, #分貨量
                rvp06       LIKE rvp_file.rvp06, #調整方式
                rvp07       LIKE rvp_file.rvp07  #調整量
                        END RECORD
 
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE  l_table  STRING
DEFINE  g_t1       LIKE oay_file.oayslip         #自動編號
DEFINE  g_sma133   LIKE sma_file.sma133
 
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
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
       
    LET g_forupd_sql="SELECT * FROM rvo_file WHERE rvo01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t253_cl    CURSOR FROM g_forupd_sql
   
    SELECT sma133 INTO g_sma133 FROM sma_file 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t253_w AT p_row,p_col WITH FORM "art/42f/artt253"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL t253_menu()
    
    CLOSE WINDOW t253_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t253_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rvp TO s_rvp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      ON ACTION confirm #審核
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION void #作廢
         LET g_action_choice="void"      
         EXIT DISPLAY
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION add_input #追加
         LET g_action_choice = "add_input"
         EXIT DISPLAY         
      ON ACTION coverage_input #覆蓋
         LET g_action_choice = "coverage_input"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t253_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL t253_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t253_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL t253_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t253_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
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
#      ON ACTION output
#        LET g_action_choice="output"
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
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
FUNCTION t253_menu()
 
   WHILE TRUE
      CALL t253_bp("G")
      CASE g_action_choice
         WHEN "confirm" #審核
            IF cl_chk_act_auth() THEN
                  CALL t253_y()
            END IF
         WHEN "void" #作廢
            IF cl_chk_act_auth() THEN
                  CALL t253_v()
            END IF
         WHEN "related_document"#相關文件
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rvo.rvo01) THEN
                 LET g_doc.column1 = "rvo01"
                 LET g_doc.column2 = "rvoplant"
                 LET g_doc.value1 = g_rvo.rvo01
                 LET g_doc.value2 = g_rvo.rvoplant
                 CALL cl_doc()
              END IF
           END IF  
         WHEN "add_input" #追加
            IF cl_chk_act_auth() THEN
                  CALL t253_b_fill(' 1=1')
                  CALL t253_bp_refresh()
            END IF
         WHEN "coverage_input" #覆蓋
            IF cl_chk_act_auth() THEN
                  CALL t253_collect('2')
                  CALL t253_b_fill(' 1=1')
                  CALL t253_bp_refresh()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t253_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t253_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t253_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t253_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t253_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t253_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t253_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t253_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvp),'','')
             END IF                            
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t253_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CONSTRUCT BY NAME g_wc ON                               
        rvo01,rvo02,rvo03,rvoplant,
        rvoconf,rvocond,rvoconu,rvo04,
        rvouser,rvogrup,rvomodu,rvodate,rvoacti,rvocrat
       ,rvooriu,rvoorig       #TQC-A30041 ADD
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvo01)#分貨調整單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvo01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvo01
                 NEXT FIELD rvo01
              WHEN INFIELD(rvo02)#配送分貨單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvo02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvo02
                 NEXT FIELD rvo02
              WHEN INFIELD(rvoconu)#審核人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvoconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvoconu
                 NEXT FIELD rvoconu
              WHEN INFIELD(rvoplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvoplant
                 NEXT FIELD rvoplant
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        ON ACTION about         
          CALL cl_about()      
 
        ON ACTION help         
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
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rvouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rvogrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rvogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvouser', 'rvogrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2  ON rvp02,rvp03,rvp04,rvp05,rvp06,rvp07
                   FROM s_rvp[1].rvp02,s_rvp[1].rvp03,s_rvp[1].rvp04,s_rvp[1].rvp05,
                        s_rvp[1].rvp06,s_rvp[1].rvp07
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvp03)#分貨單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvp03"
                 LET g_qryparam.state = "c"
                 LEt g_qryparam.arg1 = g_plant
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvp03
                 NEXT FIELD rvp03
              OTHERWISE
                 EXIT CASE
           END CASE
 
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
		
    END CONSTRUCT
    
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    LET g_wc2 = g_wc2 CLIPPED
    IF  g_wc2 = " 1=1" THEN       
         LET g_sql = "SELECT rvo01 FROM rvo_file ", 
                      " WHERE rvoplant IN ",g_auth,
                      " AND ",g_wc CLIPPED," ORDER BY rvo01"
    ELSE                                 
        LET g_sql = "SELECT UNIQUE rvo01",
                    " FROM rvo_file,rvp_file",
                    " WHERE rvo01 = rvp01 AND rvoplant = rvpplant",
                    "   AND rvoplant IN ",g_auth,
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY rvo01"
    END IF
    
    PREPARE t253_prepare FROM g_sql
    DECLARE t253_cs SCROLL CURSOR WITH HOLD FOR t253_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM rvo_file WHERE rvoplant IN ",g_auth," AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*)",
                  "  FROM rvo_file,rvp_file",
                  " WHERE rvo01 = rvp01 AND rvoplant = rvpplant",
                  "   AND rvoplant IN ",g_auth,
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t253_precount FROM g_sql
    DECLARE t253_count CURSOR FOR t253_precount
END FUNCTION
 
FUNCTION t253_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rvp.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL t253_cs()              
            
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rvo.* TO NULL
        CLEAR FORM
        CALL g_rvp.clear()
        RETURN
    END IF
    
    OPEN t253_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CLEAR FORM
        CALL g_rvp.clear()
    ELSE
        OPEN t253_count
        FETCH t253_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt                                 
           CALL t253_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION t253_fetch(p_flrvo)
DEFINE p_flrvo         LIKE type_file.chr1           
    CASE p_flrvo
        WHEN 'N' FETCH NEXT     t253_cs INTO g_rvo.rvo01
        WHEN 'P' FETCH PREVIOUS t253_cs INTO g_rvo.rvo01
        WHEN 'F' FETCH FIRST    t253_cs INTO g_rvo.rvo01
        WHEN 'L' FETCH LAST     t253_cs INTO g_rvo.rvo01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         
                     CALL cl_about()      
 
                  ON ACTION help          
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
            FETCH ABSOLUTE g_jump t253_cs INTO g_rvo.rvo01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rvo.rvo01,SQLCA.sqlcode,0)
        INITIALIZE g_rvo.* TO NULL
        RETURN
    ELSE
      CASE p_flrvo
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rvo.* FROM rvo_file    
       WHERE rvo01 = g_rvo.rvo01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rvo_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rvo.rvouser           
        LET g_data_group=g_rvo.rvogrup
        LET g_data_plant =g_rvo.rvoplant   #TQC-A10128 ADD 
        CALL t253_show()                   
    END IF
END FUNCTION
 
FUNCTION t253_rvp03()#分貨單號   
#DEFINE l_rvnn RECORD LIKE rvnn_file.*  #MOD-B80222 mark
DEFINE l_rvn RECORD LIKE rvn_file.*     #MOD-B80222 add
DEFINE l_ruc18,l_ruc18_1 LIKE ruc_file.ruc18
#DEFINE l_pcnm07 LIKE u_pcnm.pcnm07
DEFINE l_pcnm07 LIKE ruc_file.ruc18
DEFINE l_n LIKE type_file.num5
DEFINE l_rvn11 LIKE rvn_file.rvn11
DEFINE l_rugplant LIKE rug_file.rugplant
DEFINE l_ruc08 LIKE ruc_file.ruc08   #MOD-B80222 add
DEFINE l_ruc09 LIKE ruc_file.ruc09   #MOD-B80222 add
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_ruc06 LIKE ruc_file.ruc06

    #MOD-B80222 mark begin------------------
    #SELECT rvnn03,rvnn04,rvnn05,rvnn06,rvnn07  
    #  INTO l_rvnn.rvnn03,l_rvnn.rvnn04,g_rvp[l_ac].rvnn05,g_rvp[l_ac].rvnn06, 
    #  FROM rvnn_file
    # WHERE rvnn01 = g_rvp[l_ac].rvp03
    #   AND rvnn02 = g_rvp[l_ac].rvp04
    #MOD-B80222 mark end--------------------
    #MOD-B80222 add begin-----------------------
    SELECT rvn03,rvn04,rvn06,rvn09,rvn10
      INTO l_rvn.rvn03,l_rvn.rvn04,g_rvp[l_ac].rvn06,g_rvp[l_ac].rvn09,   
           g_rvp[l_ac].rvp05
      FROM rvn_file
     WHERE rvn01 = g_rvp[l_ac].rvp03
       AND rvn02 = g_rvp[l_ac].rvp04
    #MOD-B80222 add end--------------------------
#MOD-B80222 mark begin------------------        
#    SELECT COUNT(*) INTO l_n FROM ruc_file
#    #WHERE ruc01 = g_rvp[l_ac].rvnn05 #MOD-B80222 mark
#     WHERE ruc01 = g_rvp[l_ac].rvn06  #MOD-B80222 add
#       AND ruc02 = ruc08
#       AND ruc03 = ruc09
#      #AND ruc08 = l_rvnn.rvnn03  #MOD-B80222 mark
#      #AND ruc09 = l_rvnn.rvnn04  #MOD-B80222 mark
#       AND ruc08 = l_rvn.rvn03    #MOD-B80222  add
#       AND ruc09 = l_rvn.rvn04    #MOD-B80222  add
#    IF l_n = 0 THEN
#      #LET g_sql = "SELECT DISTINCT ruc06,ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)", 
#       LET g_sql = "SELECT DISTINCT ruc08,ruc09,ruc06,ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)", #MOD-B80222  add              
#                   "  FROM ruc_file LEFT JOIN gfe_file ",
#                   "    ON ruc16 = gfe01 AND gfeacti = 'Y'",
#                   " WHERE ruc01 = ?",
#                  #"   AND ruc08 = ?", #MOD-B80222 mark
#                  #"   AND ruc09 = ?"  #MOD-B80222 mark
#                   "   AND ruc02 = ?", #MOD-B80222 add
#                   "   AND ruc03 = ?"  #MOD-B80222 add
#       DECLARE ruc_cs1 CURSOR FROM g_sql
#      #FOREACH ruc_cs1 USING g_rvp[l_ac].rvnn05,l_rvnn.rvnn03,l_rvnn.rvnn04    #MOD-B80222 mark  
#       FOREACH ruc_cs1 USING g_rvp[l_ac].rvn06,l_rvn.rvn03,l_rvn.rvn04         #MOD-B80222 add     
#                #INTO l_ruc06,g_rvp[l_ac].ruc07,g_rvp[l_ac].ruc16,g_rvp[l_ac].ruc16_desc,
#                INTO l_ruc08,l_ruc09,l_ruc06,g_rvp[l_ac].ruc07,g_rvp[l_ac].ruc16,g_rvp[l_ac].ruc16_desc,  #MOD-B80222 add  
#                     l_ruc18,l_ruc18_1
#          IF g_rvp[l_ac].ruc07 = '5' THEN
##             SELECT pcnm07,pcnm08 INTO l_pcnm07,l_rvn11 FROM u_pcnm
##              WHERE pcnm00 = g_rvp[l_ac].rvnn05
##                AND pcnm01 = l_rvnn.rvnn03
##                AND pcnm02 = l_rvnn.rvnn04  
#          END IF   
#          IF g_rvp[l_ac].ruc07='6' THEN
#               #SELECT azw07 INTO l_rugplant FROM azw_file WHERE azw01 = g_rvp[l_ac].rvnn05 #MOD-B80222 mark
#                SELECT azw07 INTO l_rugplant FROM azw_file WHERE azw01 = g_rvp[l_ac].rvn06  #MOD-B80222 add
#                SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rugplant
#                #LET g_sql = "SELECT rug03,rug04,rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
#               LET g_sql = "SELECT rug03,rug04,rug05 FROM ",cl_get_target_table(l_rugplant, 'rug_file'), #FUN-A50102   
#                            " WHERE rug01 = ?",
#                            "   AND rug02 = ?",
#                            "   AND rugplant = ?"
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql, l_rugplant) RETURNING g_sql  #FUN-A50102            
#                PREPARE rug_cs5 FROM g_sql
#               #EXECUTE rug_cs5 USING l_rvnn.rvnn03,l_rvnn.rvnn04,l_rugplant   #MOD-B80222 mark
#               #                INTO l_rvnn.rvnn06,g_rvp[l_ac].ruc16,l_pcnm07  #MOD-B80222 mark
#                EXECUTE rug_cs5 USING l_ruc08,l_ruc09,l_rugplant       #MOD-B80222 add
#                                INTO l_rvn.rvn09,g_rvp[l_ac].ruc16,l_pcnm07    #MOD-B80222 add
#                SELECT gfe02 INTO g_rvp[l_ac].ruc16_desc FROM gfe_file
#                 WHERE gfe01 = g_rvp[l_ac].ruc16 AND gfeacti = 'Y'
#               #CALL t253_get_store(l_ruc06,l_rvnn.rvnn06,l_ac) RETURNING l_rvn11
#                CALL t253_get_store(l_ruc06,l_rvn.rvn09,l_ac) RETURNING l_rvn11  #MOD-B80222 add
#          END IF        
#          LET l_ruc18_1 = l_ruc18_1/(l_ruc18/l_pcnm07)
#          LET g_rvp[l_ac].ruc18_1 = 0
#          LET g_rvp[l_ac].ruc18_1 = g_rvp[l_ac].ruc18_1 + l_ruc18_1
#          LET g_rvp[l_ac].ruc18 = l_pcnm07
#       END FOREACH
#    ELSE  
#MOD-B80222 mark end--------------------
          SELECT ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)
            INTO g_rvp[l_ac].ruc07,g_rvp[l_ac].ruc16,g_rvp[l_ac].ruc16_desc,
                 g_rvp[l_ac].ruc18,g_rvp[l_ac].ruc18_1
            FROM ruc_file LEFT JOIN gfe_file
              ON ruc16 = gfe01 AND gfeacti = 'Y'
          #MOD-B80222 mark begin----------
          #WHERE ruc01 = g_rvp[l_ac].rvnn05
          #  AND ruc02 = l_rvnn.rvnn03
          #  AND ruc03 = l_rvnn.rvnn04
          #MOD-B80222 mark end------------
          #MOD-B80222 add begin-----------
           WHERE ruc01 = g_rvp[l_ac].rvn06
             AND ruc02 = l_rvn.rvn03
             AND ruc03 = l_rvn.rvn04
          #MOD-B80222 add end-------------
          SELECT rvk03 INTO l_rvn11
            FROM rvk_file,ima_file,rvm_file
           WHERE rvk01 = rvm03
             AND rvm01 = g_rvo.rvo02
             AND rvmplant = g_rvo.rvoplant
             AND rvkacti = 'Y'
             AND rvk02 = ima131
            #AND ima01 = g_rvp[l_ac].rvnn06 #MOD-B80222 mark
             AND ima01 = g_rvp[l_ac].rvn09  #MOD-B80222 add
             AND imaacti = 'Y'
          IF cl_null(l_rvn11) THEN
             SELECT rvk03 INTO l_rvn11
               FROM rvk_file,rvm_file
              WHERE rvk01 = rvm03
                AND rvm01 = g_rvo.rvo02
                AND rvmplant = g_rvo.rvoplant
                AND rvk02 = '*'
                AND rvkacti = 'Y'
          END IF
    #END IF #MOD-B80222 mark
    SELECT imd20 INTO g_rvp[l_ac].rvn12
      FROM imd_file
     WHERE imd01 = l_rvn11
       AND imd11 = 'Y'
       AND imdacti = 'Y'
   #SELECT DISTINCT (SELECT azp02 FROM azp_file WHERE azp01 = g_rvp[l_ac].rvnn05 ),  
    SELECT DISTINCT (SELECT azp02 FROM azp_file WHERE azp01 = g_rvp[l_ac].rvn06 ),  #MOD-B80222 add
                    (SELECT azp02 FROM azp_file WHERE azp01 = g_rvp[l_ac].rvn12 )
   #   INTO g_rvp[l_ac].rvnn05_desc,g_rvp[l_ac].rvn12_desc
       INTO g_rvp[l_ac].rvn06_desc,g_rvp[l_ac].rvn12_desc   #MOD-B80222 add
      FROM azp_file
   SELECT ima02,ima131 INTO g_rvp[l_ac].ima02,g_rvp[l_ac].ima131
     FROM ima_file
   #WHERE ima01 = g_rvp[l_ac].rvnn06 AND imaacti = 'Y'
    WHERE ima01 = g_rvp[l_ac].rvn09 AND imaacti = 'Y'   #MOD-B80222 add
END FUNCTION
 
FUNCTION t253_show()
DEFINE l_rvoconu_desc LIKE gen_file.gen02
DEFINE l_rvoplant_desc  LIKE azp_file.azp02
 
    LET g_rvo_t.* = g_rvo.*
    DISPLAY BY NAME g_rvo.rvo01,g_rvo.rvo02,g_rvo.rvo03,g_rvo.rvo04, g_rvo.rvooriu,g_rvo.rvoorig,
                    g_rvo.rvoconf,g_rvo.rvocond,g_rvo.rvoconu,g_rvo.rvoplant,
                    g_rvo.rvouser,g_rvo.rvogrup,g_rvo.rvomodu,
                    g_rvo.rvodate,g_rvo.rvoacti,g_rvo.rvocrat
    CASE g_rvo.rvoconf
        WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
        WHEN "N"
          CALL cl_set_field_pic("","","","","",g_rvo.rvoacti)
        WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    IF NOT cl_null(g_rvo.rvoconu) THEN
       SELECT gen02 INTO l_rvoconu_desc FROM gen_file 
        WHERE gen01=g_rvo.rvoconu AND genacti='Y'
       DISPLAY l_rvoconu_desc TO rvoconu_desc
    ELSE
       CLEAR rvoconu_desc
    END IF
    SELECT azp02 INTO l_rvoplant_desc
      FROM azp_file
     WHERE azp01 = g_rvo.rvoplant
    DISPLAY l_rvoplant_desc TO rvoplant_desc
    CALL t253_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t253_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT rvp02,rvp03,rvp04,'','','','',",
                "'','','','','','','','',rvp05,rvp06,rvp07",
                " FROM rvp_file ",
                " WHERE rvp01 = '",g_rvo.rvo01 CLIPPED,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t253_pb FROM g_sql
    DECLARE rvp_cs CURSOR FOR t253_pb
 
    CALL g_rvp.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rvp_cs INTO g_rvp[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,0) 
           EXIT FOREACH
        END IF
        CALL t253_b_init(g_cnt)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rvp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t253_i_init()
DEFINE l_rvoplant_desc LIKE azp_file.azp02  #機構名稱
      LET g_rvo.rvouser = g_user
      LET g_rvo.rvooriu = g_user #FUN-980030
      LET g_rvo.rvoorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #TQC-A10128 ADD
      LET g_rvo.rvogrup = g_grup
      LET g_rvo.rvocrat = g_today
      LET g_rvo.rvoacti = 'Y'
      
      LET g_rvo.rvo03 = g_today    #需求日期
      LET g_rvo.rvoconf = 'N'      #審核碼
      LET g_rvo.rvolegal = g_legal
      LET g_rvo.rvoplant = g_plant #當前機構
      SELECT azw02 INTO g_rvo.rvolegal FROM rvo_file WHERE azw01 = g_plant
      SELECT azp02 INTO l_rvoplant_desc 
        FROM azp_file
       WHERE azp01 = g_plant
      DISPLAY BY NAME g_rvo.rvouser,g_rvo.rvogrup,g_rvo.rvocrat,
                      g_rvo.rvoacti,g_rvo.rvoconf,g_rvo.rvoplant
                     ,g_rvo.rvooriu,g_rvo.rvoorig     #TQC-A30041 ADD
      DISPLAY l_rvoplant_desc TO rvoplant_desc
END FUNCTION
 
FUNCTION t253_a()
DEFINE li_result LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rvp.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rvo.* LIKE rvo_file.*                  
 
   LET g_rvo_t.* = g_rvo.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
                          
      CALL t253_i_init()
      CALL t253_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rvo.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rvo.rvo01) THEN       
         CONTINUE WHILE
      END IF
      BEGIN WORK
#     CALL s_auto_assign_no("art",g_rvo.rvo01,g_today,"4","rvo_file","rvo01,rvoplant","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rvo.rvo01,g_today,"C3","rvo_file","rvo01,rvoplant","","","") #FUN-A70130 mod
          RETURNING li_result,g_rvo.rvo01
      IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
      END IF
      DISPLAY BY NAME g_rvo.rvo01
      LET g_rvo.rvooriu = g_user      #No.FUN-980030 10/01/04
      LET g_rvo.rvoorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO rvo_file VALUES (g_rvo.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rvo_file",g_rvo.rvo01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rvo.* FROM rvo_file
       WHERE rvo01 = g_rvo.rvo01
 
      LET g_rvo_t.* = g_rvo.*
      CALL g_rvp.clear()
      
      CALL t253_collect('2')
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         EXIT WHILE
      END IF
      CALL t253_b_fill(" 1=1")
      IF g_rec_b = 0 THEN
         CALL t253_b()
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t253_collect(p_type)  #過濾條件
DEFINE lc_qbe_sn  LIKE gbm_file.gbm01       
DEFINE l_wc STRING
DEFINE l_rvp   RECORD LIKE rvp_file.*
#DEFINE l_rvnn  RECORD LIKE rvnn_file.*  #MOD-B80222 mark
DEFINE l_rvn  RECORD LIKE rvn_file.*     #MOD-B80222 add
DEFINE p_type  LIKE type_file.chr1    #1:追加 2:覆蓋
DEFINE li_n    LIKE type_file.num5
DEFINE l_ruc07 LIKE ruc_file.ruc07
DEFINE l_ruc08 LIKE ruc_file.ruc08   #MOD-B80222 add
DEFINE l_ruc09 LIKE ruc_file.ruc09   #MOD-B80222 add
DEFINE l_ruc18,l_ruc18_01,l_ruc18_1 LIKE ruc_file.ruc18
#DEFINE l_pcnm07 LIKE u_pcnm.pcnm07
DEFINE l_pcnm07 LIKE ruc_file.ruc18
DEFINE l_rvn03 LIKE rvn_file.rvn03
DEFINE l_rvn04 LIKE rvn_file.rvn04
DEFINE l_rvp07 LIKE rvp_file.rvp07
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_rugplant LIKE rug_file.rugplant
    
    IF cl_null(g_rvo.rvo01) THEN
       RETURN
    END IF
    SELECT * FROM rvp_file WHERE 1=0 INTO TEMP rvp_ins_temp
    BEGIN WORK
 
    OPEN t253_cl USING g_rvo.rvo01
    IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
    END IF
 
    FETCH t253_cl INTO g_rvo.*                      
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvo.rvo01,SQLCA.sqlcode,0)    
       CLOSE t253_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF g_rvo.rvoacti ='N' THEN    
      CALL cl_err(g_rvo.rvo01,'mfg1000',0)
      RETURN
    END IF
    IF g_rvo.rvoconf <> 'N' THEN
      CALL cl_err(g_rvo.rvo01,'9022',0)
      RETURN
    END IF
    LET INT_FLAG = 0
    LET p_row = 2 LET p_col = 21
    OPEN WINDOW t253a AT p_row,p_col WITH FORM "art/42f/artt253a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("artt253a")
    
#CONSTRUCT 好像不能動態設定字段為noentry,不知哪位高手知道
    IF NOT cl_null(g_rvo.rvo02) THEN
    CONSTRUCT BY NAME l_wc ON ima131,  #rvnn06,       #TQC-B30114
                              rvn06    #rvnn05        #MOD-B80222
      BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
         DISPLAY g_rvo.rvo02 TO rvm01
         CALL cl_set_comp_entry("rvm01",FALSE)
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
#TQC-B30114  --begin--           
#              WHEN INFIELD(rvnn06)     #套號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state ="c"
#                   LET g_qryparam.form ="q_rvnn06" 
#                   LET g_qryparam.where = " rvmconf = 'N' AND rvnnplant = '",g_plant,"'"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO rvnn06
#                   NEXT FIELD rvnn06
#TQC-B30114  --end--                   
             #WHEN INFIELD(rvnn05)     #需求機構
              WHEN INFIELD(rvn06)     #需求機構
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_rvn06"
                   LET g_qryparam.where = " rvmconf = 'N' AND rvnplant = '",g_plant,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO rvnn05
                  #NEXT FIELD rvnn05
                   DISPLAY g_qryparam.multiret TO rvn06  #MOD-B80222 add
                   NEXT FIELD rvn06                      #MOD-B80222 add
              WHEN INFIELD(ima131)     #類別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ima131_2"   
                   LET g_qryparam.arg1 = g_plant
                   LET g_qryparam.where = " rvmconf = 'N' "
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
              OTHERWISE EXIT CASE
           END CASE
           
   END CONSTRUCT
       LET l_wc = l_wc," AND rvm01 = '",g_rvo.rvo02,"'"
   ELSE
    CONSTRUCT BY NAME l_wc ON rvm01,ima131, #rvnn06,   #TQC-B30114
                              rvn06  #rvnn05   #MOD-B80222
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
              WHEN INFIELD(rvm01) #分貨單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_rvm01" 
                   LET g_qryparam.arg1 = g_plant
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rvm01
                   NEXT FIELD rvm01
#TQC-B30114  --begin--           
#              WHEN INFIELD(rvnn06)     #商品編號
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state ="c"
#                   LET g_qryparam.form ="q_rvnn06" 
#                   LET g_qryparam.where = " rvmconf = 'N' AND rvnplant = '",g_plant,"'"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO rvnn06
#                   NEXT FIELD rvnn06
#TQC-B30114  --end--                   
             #WHEN INFIELD(rvnn05)     #需求機構
              WHEN INFIELD(rvn06)      #需求機構 #MOD-B80222 add
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_rvn06"
                   LET g_qryparam.where = " rvmconf = 'N' AND rvnplant = '",g_plant,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO rvnn05
                  #NEXT FIELD rvnn05
                   DISPLAY g_qryparam.multiret TO rvn06   #MOD-B80222 add
                   NEXT FIELD rvn06                       #MOD-B80222 add
              WHEN INFIELD(ima131)     #類別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_ima131_2"   
                   LET g_qryparam.arg1 = g_plant
                   LET g_qryparam.where = " rvmconf = 'N' "
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
              OTHERWISE EXIT CASE
           END CASE           
   END CONSTRUCT
   END IF
   IF INT_FLAG THEN
      CLOSE WINDOW t253a
      RETURN
   END IF
 
   INPUT l_rvp.rvp06,l_rvp07 FROM rvp06,rvp07
 
      AFTER FIELD rvp07
         IF NOT cl_null(l_rvp07) THEN
           IF l_rvp07 < 0 THEN
              CALL cl_err(l_rvp07,'art-184',0)
              NEXT FIELD rvp07
           END IF
         END IF
         
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
       CLOSE WINDOW t253a
       RETURN
    END IF
    
   #LET g_sql = "SELECT rvnn_file.*",                    #MOD-B80222 mark
   #            " FROM rvm_file,rvnn_file,ima_file ",    #MOD-B80222 mark
   #            " WHERE rvm01 = rvnn01 ",                #MOD-B80222 mark
   #            "   AND rvmplant = rvnnplant",           #MOD-B80222 mark
    LET g_sql = "SELECT rvn_file.*",                     #MOD-B80222 add
                " FROM rvm_file,rvn_file,ima_file ",     #MOD-B80222 add
                " WHERE rvm01 = rvn01 ",                 #MOD-B80222 add
                "   AND rvmplant = rvnplant",            #MOD-B80222 add
                "   AND rvmplant = '",g_plant,"'",
                "   AND rvmconf = 'N'",
                "   AND rvmacti = 'Y'",
   #            "   AND rvnn06 = ima01 AND ",l_wc CLIPPED,  #MOD-B80222 mark
   #            "   ORDER BY rvnn01,rvnn02"                 #MOD-B80222 mark
                "   AND rvn09 = ima01 AND ",l_wc CLIPPED,   #MOD-B80222 add
                "   ORDER BY rvn01,rvn02"                 #MOD-B80222 add    
 
    IF l_wc <> " 1=1" THEN
    PREPARE rvn_pre FROM g_sql
    DECLARE rvn_cs CURSOR FOR rvn_pre   
    IF p_type = '2' THEN
       DELETE FROM rvp_file WHERE rvp01 = g_rvo.rvo01 AND rvpplant = g_rvo.rvoplant
    END IF
    
    LET l_rvp.rvp01 = g_rvo.rvo01
    LET l_rvp.rvpplant = g_rvo.rvoplant
    LET l_rvp.rvplegal = g_rvo.rvolegal
    SELECT COALESCE(MAX(rvp02),0)+1 INTO g_cnt FROM rvp_file 
     WHERE rvp01 = g_rvo.rvo01 AND rvpplant = g_rvo.rvoplant
   #FOREACH rvn_cs INTO l_rvnn.*
    FOREACH rvn_cs INTO l_rvn.*  #MOD-B80222 add
      IF STATUS THEN
          CALL cl_err('',STATUS,1)
          EXIT FOREACH
      END IF
     #LET l_rvp.rvp03 = l_rvnn.rvnn01  #MOD-B80222 mark
     #LET l_rvp.rvp04 = l_rvnn.rvnn02  #MOD-B80222 mark
     #LET l_rvp.rvp05 = l_rvnn.rvnn07  #MOD-B80222 mark
      LET l_rvp.rvp03 = l_rvn.rvn01  #MOD-B80222 add
      LET l_rvp.rvp04 = l_rvn.rvn02  #MOD-B80222 add
      LET l_rvp.rvp05 = l_rvn.rvn10  #MOD-B80222 add
      SELECT COUNT(*) INTO li_n
        FROM rvp_file
       WHERE rvp01 = g_rvo.rvo01 
         AND rvpplant = g_rvo.rvoplant
         AND rvp03 = l_rvp.rvp03
         AND rvp04 = l_rvp.rvp04
         
      IF li_n > 0 THEN
         CONTINUE FOREACH
      END IF
         #SELECT DISTINCT ruc07 INTO l_ruc07 FROM ruc_file
         #WHERE ruc01 = l_rvnn.rvnn05  #MOD-B80222 mark
         #  AND ruc08 = l_rvnn.rvnn03  #MOD-B80222 mark
         #  AND ruc09 = l_rvnn.rvnn04  #MOD-B80222 mark
         SELECT DISTINCT ruc07,ruc08,ruc09 #MOD-B80222 add
           INTO l_ruc07,l_ruc08,l_ruc09 FROM ruc_file #MOD-B80222 add
          WHERE ruc01 = l_rvn.rvn06  #MOD-B80222 add
            AND ruc02 = l_rvn.rvn03  #MOD-B80222 add
            AND ruc03 = l_rvn.rvn04  #MOD-B80222 add
#MOD-B80222 mark begin-----------------------
#         IF l_ruc07 MATCHES '[56]' THEN
#            IF l_ruc07 = '5' THEN
##               SELECT pcnm07 INTO l_pcnm07 FROM u_pcnm
##                WHERE pcnm00 = l_rvnn.rvnn05
##                  AND pcnm01 = l_rvnn.rvnn03
##                  AND pcnm02 = l_rvnn.rvnn04
#            END IF
#            IF l_ruc07='6' THEN     
#               #SELECT azw07 INTO l_rugplant FROM azw_file WHERE azw01 = l_rvnn.rvnn05  #MOD-B80222 mark
#                SELECT azw07 INTO l_rugplant FROM azw_file WHERE azw01 = l_rvn.rvn06  #MOD-B80222 add 
#                SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_rugplant
#                #LET g_sql = "SELECT rug03,rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
#                LET g_sql = "SELECT rug03,rug05 FROM ",cl_get_target_table(l_rugplant, 'rug_file'), #FUN-A50102
#                            " WHERE rug01 = ?",
#                            "   AND rug02 = ?",
#                            "   AND rugplant = ?"
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql, l_rugplant) RETURNING g_sql  #FUN-A50102
#                PREPARE rug_cs2 FROM g_sql
#               #EXECUTE rug_cs2 USING l_rvnn.rvnn03,l_rvnn.rvnn04,l_rugplant   #MOD-B80222 mark
#               #                INTO l_rvnn.rvnn06,l_pcnm07                    #MOD-B80222 mark  
#                EXECUTE rug_cs2 USING l_ruc08,l_ruc09,l_rugplant   #MOD-B80222 add
#                                INTO l_rvn.rvn09,l_pcnm07                  #MOD-B80222 add         
#            END IF
#                LET g_sql = "SELECT ruc02,ruc03,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0) FROM ruc_file",
#                                " WHERE ruc01 = ?  AND ruc02 = ?",  #AND ruc08 = ?",  #MOD-B80222 ruc08>ruc02
#                                #"   AND ruc09 = ? AND ruc07 = ?"
#                                "   AND ruc03 = ? AND ruc07 = ?"    #MOD-B80222
#                DECLARE ruc_cs4 CURSOR FROM g_sql
#               #FOREACH ruc_cs4 USING l_rvnn.rvnn05,l_rvnn.rvnn03,l_rvnn.rvnn04,l_ruc07
#                FOREACH ruc_cs4 USING l_rvn.rvn06,l_rvn.rvn03,l_rvn.rvn04,l_ruc07   #MOD-B80222 add
#                                 INTO l_rvn03,l_rvn04,l_ruc18,l_ruc18_01
#                  LET l_ruc18_01 = l_ruc18_01/(l_ruc18/l_pcnm07)
#                  LET l_ruc18_1 = 0
#                  LET l_ruc18_1 = l_ruc18_1 + l_ruc18_01
#                END FOREACH
#         ELSE   
#MOD-B80222 mark end-----------------------
            SELECT COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0) 
              INTO l_pcnm07,l_ruc18_1 
              FROM ruc_file
            #WHERE ruc01 = l_rvnn.rvnn05
            #  AND ruc02 = l_rvnn.rvnn03
            #  AND ruc03 = l_rvnn.rvnn04
             WHERE ruc01 = l_rvn.rvn06   #MOD-B80222 add
               AND ruc02 = l_rvn.rvn03   #MOD-B80222 add
               AND ruc03 = l_rvn.rvn04   #MOD-B80222 add
            
         #END IF  #MOD-B80222 mark 
      CASE l_rvp.rvp06
                   #WHEN '1' IF l_rvp07 + l_rvnn.rvnn07 - l_ruc18_1 > l_pcnm07*g_sma133/100 THEN
                   #            LET l_rvp.rvp07 = l_ruc18_1 - l_rvnn.rvnn07 + l_pcnm07*g_sma133/100
                    WHEN '1' IF l_rvp07 + l_rvn.rvn10 - l_ruc18_1 > l_pcnm07*g_sma133/100 THEN      #MOD-B80222 add
                                LET l_rvp.rvp07 = l_ruc18_1 - l_rvn.rvn10 + l_pcnm07*g_sma133/100   #MOD-B80222 add
                             ELSE 
                                LET l_rvp.rvp07 = l_rvp07
                             END IF                 
                   #WHEN '2' IF l_rvp07 >= l_rvnn.rvnn07 THEN
                   #            LET l_rvp.rvp07 = l_rvnn.rvnn07
                    WHEN '2' IF l_rvp07 >= l_rvn.rvn10 THEN      #MOD-B80222 add
                                LET l_rvp.rvp07 = l_rvn.rvn10    #MOD-B80222 add
                             ELSE
                               #IF l_ruc18_1 - l_rvp07 > l_rvnn.rvnn07 THEN
                               #   LET l_rvp.rvp07 = l_ruc18_1 - l_rvnn.rvnn07
                                IF l_ruc18_1 - l_rvp07 > l_rvn.rvn10 THEN    #MOD-B80222 add
                                   LET l_rvp.rvp07 = l_ruc18_1 - l_rvn.rvn10 #MOD-B80222 add
                                ELSE 
                                   LET l_rvp.rvp07 = l_rvp07
                                END IF
                             END IF                                
                    WHEN '3' IF l_rvp07 - l_ruc18_1 > l_pcnm07*g_sma133/100 THEN
                                LET l_rvp.rvp07 = l_ruc18_1 + l_pcnm07*g_sma133/100
                             ELSE 
                                LET l_rvp.rvp07 = l_rvp07
                             END IF
      END CASE
      LET l_rvp.rvp02 = g_cnt
      
      INSERT INTO rvp_ins_temp VALUES(l_rvp.*)
      LET g_cnt=g_cnt+1
    END FOREACH
    INSERT INTO rvp_file SELECT * FROM rvp_ins_temp
    IF SQLCA.sqlcode = 0 THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    END IF
    DROP TABLE rvp_ins_temp
    CLOSE WINDOW t253a
END FUNCTION                                      
 
FUNCTION t253_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1,                
           l_n       LIKE type_file.num5           
DEFINE li_result LIKE type_file.num5
     
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_rvo.rvo01,g_rvo.rvo02,g_rvo.rvo03, g_rvo.rvooriu,g_rvo.rvoorig,
                 g_rvo.rvo04
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL t253_set_entry(p_cmd)
          CALL t253_set_no_entry(p_cmd)
          CALL cl_set_docno_format("rvo01")
          LET g_before_input_done = TRUE
	  
      AFTER FIELD rvo01  #分貨調整單號
         IF NOT cl_null(g_rvo.rvo01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rvo.rvo01 <> g_rvo_t.rvo01) THEN
#               CALL s_check_no("art",g_rvo.rvo01,g_rvo_t.rvo01,"4","rvo_file","rvo01,rvoplant","") #FUN-A70130 mark
                CALL s_check_no("art",g_rvo.rvo01,g_rvo_t.rvo01,"C3","rvo_file","rvo01,rvoplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rvo.rvo01
                IF (NOT li_result) THEN                                                            
                    LET g_rvo.rvo01=g_rvo_t.rvo01                                                                 
                    NEXT FIELD rvo01                                                                                      
                END IF  
            END IF
         END IF
      
 
     AFTER FIELD rvo02  #配送分貨單號
         IF NOT cl_null(g_rvo.rvo02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rvo.rvo02 <> g_rvo_t.rvo02) THEN
               LET g_errno = ''
               LET g_sql = "SELECT CASE WHEN rvmacti='N' THEN '9028'",
                           "WHEN rvmconf='Y' THEN '9023'",
                           "WHEN rvmconf='X' THEN '9024' END",
                           "  FROM rvm_file ",
                           " WHERE rvm01 = ?"
               PREPARE rvm_sel FROM g_sql
               EXECUTE rvm_sel USING g_rvo.rvo02 INTO g_errno
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rvo.rvo02,g_errno,0)
                  LET g_rvo.rvo02 = g_rvo_t.rvo02
                  DISPLAY BY NAME g_rvo.rvo02
                  NEXT FIELD rvo02
               END IF
            END IF
         END IF
         
      AFTER INPUT
         LET g_rvo.rvouser = s_get_data_owner("rvo_file") #FUN-C10039
         LET g_rvo.rvogrup = s_get_data_group("rvo_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rvo.rvo01) THEN
               NEXT FIELD rvo01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rvo01) THEN
            LET g_rvo.* = g_rvo_t.*
            CALL t253_show()
            NEXT FIELD rvo01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rvo01) #分貨調整單號
              LET g_t1=s_get_doc_no(g_rvo.rvo01)
#             CALL q_smy(FALSE,FALSE,g_t1,'art','4') RETURNING g_t1  #FUN-A70130--mark--
              CALL q_oay(FALSE,FALSE,g_t1,'C3','art') RETURNING g_t1  #FUN-A70130--add--
              LET g_rvo.rvo01=g_t1
              DISPLAY BY NAME g_rvo.rvo01
           WHEN INFIELD(rvo02) #配送分貨單號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rvm01"
              LET g_qryparam.default1 = g_rvo.rvo02
              LET g_qryparam.arg1 = g_plant
              CALL cl_create_qry() RETURNING g_rvo.rvo02
              DISPLAY BY NAME g_rvo.rvo02
              NEXT FIELD rvo02
           OTHERWISE
              EXIT CASE
        END CASE
 
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
END FUNCTION
 
FUNCTION t253_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rvo01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t253_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rvo01",FALSE)
       
    END IF
 
END FUNCTION
 
FUNCTION t253_get_store(p_org,p_item,p_cnt)
DEFINE p_org LIKE rvn_file.rvn06
#DEFINE p_item LIKE rvnn_file.rvnn06
DEFINE p_item LIKE rvn_file.rvn09   #MOD-B80222 add
DEFINE p_cnt LIKE type_file.num5
DEFINE l_rvn11 LIKE rvn_file.rvn11
DEFINE l_rvm03 LIKE rvm_file.rvm03
 
       LET l_rvn11 = ''
       LET g_errno = ''
       SELECT rvm03 INTO l_rvm03 FROM rvm_file
        WHERE rvm01 = g_rvp[p_cnt].rvp03
       SELECT rvk03 INTO l_rvn11
         FROM rvk_file,ima_file
        WHERE rvk01 = l_rvm03
          AND rvkacti = 'Y'
          AND rvk02 = ima131
          AND rvk04 = p_org
          AND ima01 = p_item
          AND imaacti = 'Y'
       IF NOT cl_null(l_rvn11) THEN
          RETURN l_rvn11
       ELSE
          SELECT rvk03 INTO l_rvn11
            FROM rvk_file,ima_file
           WHERE rvk01 = l_rvm03
             AND rvkacti = 'Y'
             AND rvk02 = ima131
             AND rvk04 = '*'
             AND ima01 = p_item
             AND imaacti = 'Y'
          IF NOT cl_null(l_rvn11) THEN
             RETURN l_rvn11
          ELSE            
            SELECT rvk03 INTO l_rvn11
              FROM rvk_file
             WHERE rvk01 = l_rvm03
               AND rvkacti = 'Y'
               AND rvk02 = '*'
               AND rvk04 = p_org
            IF NOT cl_null(l_rvn11) THEN
             RETURN l_rvn11
            ELSE 
               SELECT rvk03 INTO l_rvn11
                 FROM rvk_file
                WHERE rvk01 = l_rvm03
                  AND rvkacti = 'Y'
                  AND rvk02 = '*'
                  AND rvk04 = '*'
              IF SQLCA.sqlcode=0 AND NOT cl_null(l_rvn11) THEN
                 RETURN l_rvn11
              ELSE
                 LET g_errno='art-245'
                 RETURN ''
              END IF
            END IF
         END IF
       END IF
          
END FUNCTION
 
FUNCTION t253_b_init(p_cnt)
DEFINE p_cnt LIKE type_file.num5
#DEFINE l_rvnn RECORD LIKE rvnn_file.* #MOD-B80222 mark
DEFINE l_rvn RECORD LIKE rvn_file.*    #MOD-B80222 add
DEFINE l_ruc18,l_ruc18_1 LIKE ruc_file.ruc18
DEFINE l_ruc08 LIKE ruc_file.ruc08   #MOD-B80222 add
DEFINE l_ruc09 LIKE ruc_file.ruc09   #MOD-B80222 add
#DEFINE l_pcnm07 LIKE u_pcnm.pcnm07
DEFINE l_pcnm07 LIKE ruc_file.ruc18
DEFINE l_n LIKE type_file.num5
DEFINE l_rvn11 LIKE rvn_file.rvn11
DEFINE l_rugplant LIKE rug_file.rugplant
DEFINE l_dbs LIKE azp_file.azp03

   #MOD-B80222 mark begin-----------------
   #SELECT rvnn03,rvnn04,rvnn05,rvnn06,rvnn07
   #  INTO l_rvnn.rvnn03,l_rvnn.rvnn04,g_rvp[p_cnt].rvnn05,
   #       g_rvp[p_cnt].rvnn06,g_rvp[p_cnt].rvp05
   #  FROM rvnn_file
   # WHERE rvnn01 = g_rvp[p_cnt].rvp03
   #   AND rvnn02 = g_rvp[p_cnt].rvp04
   #   AND rvnnplant = g_rvo.rvoplant
   #MOD-B80222 mark end-------------------
   #MOD-B80222 add begin-------------------
    SELECT rvn03,rvn04,rvn06,rvn09,rvn10
      INTO l_rvn.rvn03,l_rvn.rvn04,g_rvp[p_cnt].rvn06,
           g_rvp[p_cnt].rvn09,g_rvp[p_cnt].rvp05
      FROM rvn_file
     WHERE rvn01 = g_rvp[p_cnt].rvp03
       AND rvn02 = g_rvp[p_cnt].rvp04
       AND rvnplant = g_rvo.rvoplant
   #MOD-B80222 add end--------------------   
#MOD-B80222 mark begin-----------------  
#    SELECT COUNT(*) INTO l_n FROM ruc_file
#    #WHERE ruc01 = g_rvp[p_cnt].rvnn05
#     WHERE ruc01 = g_rvp[p_cnt].rvn06  #MOD-B80222 add
#       AND ruc02 = ruc08
#       AND ruc03 = ruc09
#      #AND ruc08 = l_rvnn.rvnn03
#      #AND ruc09 = l_rvnn.rvnn04
#       AND ruc08 = l_rvn.rvn03     #MOD-B80222 add
#       AND ruc09 = l_rvn.rvn04     #MOD-B80222 add
#    IF l_n = 0 THEN
#      #LET g_sql = "SELECT DISTINCT ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)",
#       LET g_sql = "SELECT DISTINCT ruc08,ruc09,ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)",               
#                   "  FROM ruc_file LEFT JOIN gfe_file ",
#                   "    ON ruc16 = gfe01 AND gfeacti = 'Y'",
#                   " WHERE ruc01 = ?",
#                  #"   AND ruc08 = ?", #MOD-B80222 mark
#                  #"   AND ruc09 = ?"  #MOD-B80222 mark
#                   "   AND ruc02 = ?", #MOD-B80222 add
#                   "   AND ruc03 = ?"  #MOD-B80222 add
#       DECLARE ruc_cs2 CURSOR FROM g_sql
#      #FOREACH ruc_cs2 USING g_rvp[p_cnt].rvnn05,l_rvnn.rvnn03,l_rvnn.rvnn04
#       FOREACH ruc_cs2 USING g_rvp[p_cnt].rvn06,l_rvn.rvn03,l_rvn.rvn04      #MOD-B80222 add   
#               #INTO g_rvp[p_cnt].ruc07,g_rvp[p_cnt].ruc16,g_rvp[p_cnt].ruc16_desc,       
#                INTO l_ruc08,l_ruc09,g_rvp[p_cnt].ruc07,g_rvp[p_cnt].ruc16,g_rvp[p_cnt].ruc16_desc, #MOD-B80222 add
#                     l_ruc18,l_ruc18_1
#          IF g_rvp[p_cnt].ruc07 = '5' THEN
##             SELECT pcnm07,pcnm08 INTO l_pcnm07,l_rvn11 FROM u_pcnm
##              WHERE pcnm00 = g_rvp[p_cnt].rvnn05
##                AND pcnm01 = l_rvnn.rvnn03
##                AND pcnm02 = l_rvnn.rvnn04  
#          END IF    
#          IF g_rvp[p_cnt].ruc07 ='6' THEN     
#                SELECT azw07 INTO l_rugplant FROM azw_file
#                #WHERE azw01 = g_rvp[p_cnt].rvnn05
#                 WHERE azw01 = g_rvp[p_cnt].rvn06 #MOD-B80222 add 
#                SELECT azp03 INTO l_dbs FROM azp_file
#                 WHERE azp01 = l_rugplant
#                #LET g_sql = "SELECT rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
#                LET g_sql = "SELECT rug05 FROM ",cl_get_target_table(l_rugplant, 'rug_file'), #FUN-A50102
#                            " WHERE rug01 = ?",
#                            "   AND rug02 = ?",
#                            "   AND rugplant = ?"
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql, l_rugplant) RETURNING g_sql  #FUN-A50102
#                PREPARE rug_cs3 FROM g_sql
#               #EXECUTE rug_cs3 USING l_rvnn.rvnn03,l_rvnn.rvnn04,l_rugplant
#                EXECUTE rug_cs3 USING l_ruc08,l_ruc09,l_rugplant   #MOD-B80222 add
#                                INTO l_pcnm07   
#               #CALL t253_get_store(g_rvp[p_cnt].rvnn05,g_rvp[p_cnt].rvnn06,p_cnt) RETURNING l_rvn11   
#                CALL t253_get_store(g_rvp[p_cnt].rvn06,g_rvp[p_cnt].rvn09,p_cnt) RETURNING l_rvn11     #MOD-B80222 add                       
#          END IF       
#          LET l_ruc18_1 = l_ruc18_1/(l_ruc18/l_pcnm07)
#          LET g_rvp[p_cnt].ruc18_1 = 0
#          LET g_rvp[p_cnt].ruc18_1 = g_rvp[p_cnt].ruc18_1 + l_ruc18_1
#          LET g_rvp[p_cnt].ruc18 = l_pcnm07
#       END FOREACH
#    ELSE 
#MOD-B80222 mark end-------------------
          SELECT ruc07,ruc16,gfe02,COALESCE(ruc18,0),COALESCE(ruc18,0)-COALESCE(ruc20,0)
            INTO g_rvp[p_cnt].ruc07,g_rvp[p_cnt].ruc16,g_rvp[p_cnt].ruc16_desc,
                 g_rvp[p_cnt].ruc18,g_rvp[p_cnt].ruc18_1
            FROM ruc_file LEFT JOIN gfe_file
              ON ruc16 = gfe01 AND gfeacti = 'Y'
          #WHERE ruc01 = g_rvp[p_cnt].rvnn05
          #  AND ruc02 = l_rvnn.rvnn03
          #  AND ruc03 = l_rvnn.rvnn04
           WHERE ruc01 = g_rvp[p_cnt].rvn06  #MOD-B80222 add
             AND ruc02 = l_rvn.rvn03         #MOD-B80222 add
             AND ruc03 = l_rvn.rvn04         #MOD-B80222 add
         #CALL t253_get_store(g_rvp[p_cnt].rvnn05,g_rvp[p_cnt].rvnn06,p_cnt) RETURNING l_rvn11
          CALL t253_get_store(g_rvp[p_cnt].rvn06,g_rvp[p_cnt].rvn09,p_cnt) RETURNING l_rvn11 #MOD-B80222 add
    #END IF #MOD-B80222 mark 
    SELECT imd20 INTO g_rvp[p_cnt].rvn12
      FROM imd_file
     WHERE imd01 = l_rvn11
       AND imd11 = 'Y'
       AND imdacti = 'Y'
   #SELECT DISTINCT (SELECT azp02 FROM azp_file WHERE azp01 = g_rvp[p_cnt].rvnn05 ),
    SELECT DISTINCT (SELECT azp02 FROM azp_file WHERE azp01 = g_rvp[p_cnt].rvn06 ),    #MOD-B80222 add
                    (SELECT azp02 FROM azp_file WHERE azp01 = g_rvp[p_cnt].rvn12 )
     #INTO g_rvp[p_cnt].rvnn05_desc,g_rvp[p_cnt].rvn12_desc
      INTO g_rvp[p_cnt].rvn06_desc,g_rvp[p_cnt].rvn12_desc #MOD-B80222 add
      FROM azp_file
   SELECT ima02,ima131 INTO g_rvp[p_cnt].ima02,g_rvp[p_cnt].ima131
     FROM ima_file
   #WHERE ima01 = g_rvp[p_cnt].rvnn06 AND imaacti = 'Y'
    WHERE ima01 = g_rvp[p_cnt].rvn09 AND imaacti = 'Y' #MOD-B80222 add
    
END FUNCTION
 
FUNCTION t253_chkrvp03()
DEFINE l_rvmacti LIKE rvm_file.rvmacti
DEFINE l_rvmconf LIKE rvm_file.rvmconf
 
    LET g_errno = ''
    SELECT DISTINCT rvmacti,rvmconf 
      INTO l_rvmacti,l_rvmconf
      FROM rvm_file,rvn_file
     WHERE rvm01 = rvn01
       AND rvmplant = rvmplant
       AND rvn01 = COALESCE(g_rvp[l_ac].rvp03,rvn01)
       AND rvn02 = COALESCE(g_rvp[l_ac].rvp04,rvn02)
       AND rvnplant = g_rvo.rvoplant
   CASE                          
        WHEN SQLCA.sqlcode=100   
             IF INFIELD(rvp03) THEN 
                LET g_errno = 'art-244' 
             ELSE
                LET g_errno = 'art-362'
             END IF
        WHEN l_rvmacti='N'       LET g_errno = '9028'   
        WHEN l_rvmconf = 'Y'     LET g_errno = '9023'
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE   
END FUNCTION
 
FUNCTION t253_b()
DEFINE l_ac_t LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rvo.rvo01) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_rvo.* FROM rvo_file
         WHERE rvo01=g_rvo.rvo01
        IF g_rvo.rvoacti='N' THEN 
           CALL cl_err(g_rvo.rvo01,'mfg1000',0)
           RETURN 
        END IF
        
        IF g_rvo.rvoconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
        END IF
        
        CALL cl_opmsg('b')
        LET g_msg = cl_getmsg('art-422',g_lang) 
        LET g_forupd_sql="SELECT rvp02,rvp03,rvp04,'','','','','',",
                         "'','','','','','','',rvp05,rvp06,rvp07",
                         " FROM rvp_file",
                         " WHERE rvp01 = ? AND rvp02 = ?",
                         " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t253_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rvp WITHOUT DEFAULTS FROM s_rvp.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                   CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN t253_cl USING g_rvo.rvo01
                IF STATUS THEN
                        CALL cl_err("OPEN t253_cl:",STATUS,0)
                        CLOSE t253_cl
                        ROLLBACK WORK
                END IF
                
                FETCH t253_cl INTO g_rvo.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rvo.rvo01,SQLCA.sqlcode,0)
                        CLOSE t253_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rvp_t.*=g_rvp[l_ac].*
                        LET g_rvp_o.*=g_rvp[l_ac].*
                        OPEN t253_bcl USING g_rvo.rvo01,g_rvp_t.rvp02
                        IF STATUS THEN
                                CALL cl_err("OPEN t253_bcl:",STATUS,0)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH t253_bcl INTO g_rvp[l_ac].*
                                IF SQLCA.sqlcode THEN
                                    CALL cl_err(g_rvp_t.rvp03,SQLCA.sqlcode,0)
                                    LET l_lock_sw="Y"
                                END IF
                                CALL t253_b_init(l_ac)
                        END IF
               END IF
           
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rvp[l_ac].* TO NULL
                LET g_rvp_t.*=g_rvp[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rvp02
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO rvp_file(rvp01,rvp02,rvp03,rvp04,rvp05,rvp06,rvp07,rvpplant,rvplegal)
                              VALUES(g_rvo.rvo01,g_rvp[l_ac].rvp02,g_rvp[l_ac].rvp03,
                                     g_rvp[l_ac].rvp04,g_rvp[l_ac].rvp05,g_rvp[l_ac].rvp06,
                                     g_rvp[l_ac].rvp07,g_rvo.rvoplant,g_rvo.rvolegal)
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rvp_file",g_rvo.rvo01,g_rvp[l_ac].rvp02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT O.K.'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
      BEFORE FIELD rvp02
        IF cl_null(g_rvp[l_ac].rvp02) OR g_rvp[l_ac].rvp02 = 0 THEN 
            SELECT MAX(rvp02)+1 INTO g_rvp[l_ac].rvp02 FROM rvp_file
             WHERE rvp01=g_rvo.rvo01
                IF g_rvp[l_ac].rvp02 IS NULL THEN
                        LET g_rvp[l_ac].rvp02=1
                END IF
         END IF
         
      AFTER FIELD rvp02 #項次
        IF NOT cl_null(g_rvp[l_ac].rvp02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_rvp[l_ac].rvp02 <> g_rvp_t.rvp02) THEN
              IF g_rvp[l_ac].rvp02<=0 THEN
                 CALl cl_err('','aec-994',0)
                 NEXT FIELD rvp02
              ELSE
                 SELECT COUNT(*) INTO l_n FROM rvp_file
                  WHERE rvp01 = g_rvo.rvo01
                    AND rvp02 = g_rvp[l_ac].rvp02
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rvp[l_ac].rvp02=g_rvp_t.rvp02
                    NEXT FIELD rvp02
                 END IF
              END IF
           END IF
        END IF
         
      AFTER FIELD rvp03,rvp04 #分貨單號+分貨項次              
        IF NOT cl_null(g_rvp[l_ac].rvp03) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_rvp[l_ac].rvp03 <> g_rvp_o.rvp03 OR cl_null(g_rvp_o.rvp03)) THEN
              CALL t253_chkrvp03()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvp[l_ac].rvp03,g_errno,0)
                 LET g_rvp[l_ac].rvp03 = g_rvp_t.rvp03
                 DISPLAY BY NAME g_rvp[l_ac].rvp03
                 NEXT FIELD rvp03
              ELSE
                 LET g_rvp_o.rvp03 = g_rvp[l_ac].rvp03   
              END IF
           END IF
        ELSE 
            LET g_rvp_o.rvp03 = ''
        END IF      
        IF NOT cl_null(g_rvp[l_ac].rvp04) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_rvp[l_ac].rvp04 <> g_rvp_o.rvp04 OR cl_null(g_rvp_o.rvp04)) THEN
              CALL t253_chkrvp03()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rvp[l_ac].rvp04,g_errno,0)
                 LET g_rvp[l_ac].rvp04 = g_rvp_t.rvp04
                 DISPLAY BY NAME g_rvp[l_ac].rvp04
                 NEXT FIELD rvp04
              ELSE
                 LET g_rvp_o.rvp04 = g_rvp[l_ac].rvp04      
              END IF
           END IF
        ELSE 
            LET g_rvp_o.rvp04 = ''
        END IF      
        IF NOT cl_null(g_rvp[l_ac].rvp03) AND NOT cl_null(g_rvp[l_ac].rvp04) THEN
           IF p_cmd='a' OR (p_cmd='u' AND 
              (g_rvp[l_ac].rvp03<>g_rvp_t.rvp03 OR g_rvp[l_ac].rvp04<>g_rvp_t.rvp04)) THEN
              SELECT COUNT(*) INTO l_n FROM rvp_file
               WHERE rvp01=g_rvo.rvo01
                 AND rvp03=g_rvp[l_ac].rvp03
                 AND rvp04=g_rvp[l_ac].rvp04
              IF l_n>0 THEN
                 CALL cl_err('','-239',0)
                 NEXT FIELD CURRENT
              END IF
              CALL t253_rvp03()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD CURRENT
              END IF
           END IF
        END IF
       
      AFTER FIELD rvp07
        IF NOT cl_null(g_rvp[l_ac].rvp07) THEN
           IF g_rvp[l_ac].rvp07 < 0 THEN
              CALL cl_err(g_rvp[l_ac].rvp07,'art-184',0)
              LET g_rvp[l_ac].rvp07 = g_rvp_t.rvp07
              DISPLAY BY NAME g_rvp[l_ac].rvp07
              NEXT FIELD rvp07
           ELSE
              CASE g_rvp[l_ac].rvp06
                WHEN '1' 
                  IF (g_rvp[l_ac].rvp07 + g_rvp[l_ac].rvp05 - g_rvp[l_ac].ruc18_1) > g_rvp[l_ac].ruc18*g_sma133/100 THEN
                     ERROR g_rvp[l_ac].rvp07,'+',g_rvp[l_ac].rvp05,'+',(g_rvp[l_ac].ruc18 - g_rvp[l_ac].ruc18_1),
                           g_msg,g_sma133,'%)=',g_rvp[l_ac].ruc18*(100+g_sma133)/100
                     LET g_rvp[l_ac].rvp07 = g_rvp_t.rvp07
                     DISPLAY BY NAME g_rvp[l_ac].rvp07
                     NEXT FIELD rvp07
                  END IF
                WHEN '2'
                  IF g_rvp[l_ac].rvp07 > g_rvp[l_ac].rvp05 THEN
                     CALL cl_err('','art-366',0)
                     LET g_rvp[l_ac].rvp07 = g_rvp_t.rvp07
                     DISPLAY BY NAME g_rvp[l_ac].rvp07
                     NEXT FIELD rvp07
                  ELSE 
                     IF (g_rvp[l_ac].rvp05 - g_rvp[l_ac].rvp07) > g_rvp[l_ac].ruc18_1 THEN
                         CALL cl_err('','art-448',0)
                         LET g_rvp[l_ac].rvp07 = g_rvp_t.rvp07
                         DISPLAY BY NAME g_rvp[l_ac].rvp07
                         NEXT FIELD rvp07
                     END IF
                  END IF
                WHEN '3'
                  IF g_rvp[l_ac].rvp07 - g_rvp[l_ac].ruc18_1 > g_rvp[l_ac].ruc18*g_sma133/100 THEN
                     ERROR g_rvp[l_ac].rvp07,'+',(g_rvp[l_ac].ruc18 - g_rvp[l_ac].ruc18_1),
                           g_msg,g_sma133,'%)=',g_rvp[l_ac].ruc18*(100+g_sma133)/100
                     LET g_rvp[l_ac].rvp07 = g_rvp_t.rvp07
                     DISPLAY BY NAME g_rvp[l_ac].rvp07
                     NEXT FIELD rvp07
                  END IF
              END CASE
           END IF
         END IF
         
       BEFORE DELETE                      
           IF g_rvp_t.rvp02 > 0 AND NOT cl_null(g_rvp_t.rvp02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rvp_file
                    WHERE rvp01 = g_rvo.rvo01
                      AND rvp02 = g_rvp_t.rvp02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rvp_file",g_rvo.rvo01,g_rvp_t.rvp02,SQLCA.sqlcode,"","",1)  
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
              LET g_rvp[l_ac].* = g_rvp_t.*
              CLOSE t253_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvp[l_ac].rvp02,-263,1)
              LET g_rvp[l_ac].* = g_rvp_t.*
           ELSE
             
              UPDATE rvp_file SET  rvp02 = g_rvp[l_ac].rvp02,
                                   rvp03 = g_rvp[l_ac].rvp03,
                                   rvp04 = g_rvp[l_ac].rvp04,
                                   rvp05 = g_rvp[l_ac].rvp05,
                                   rvp06 = g_rvp[l_ac].rvp06,
                                   rvp07 = g_rvp[l_ac].rvp07
                 WHERE rvp01 = g_rvo.rvo01
                   AND rvp02 = g_rvp_t.rvp02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rvp_file",g_rvo.rvo01,g_rvp_t.rvp02,SQLCA.sqlcode,"","",1) 
                 LET g_rvp[l_ac].* = g_rvp_t.*
              ELSE
                 LET g_rvo.rvomodu = g_user
                 LET g_rvo.rvodate = g_today
                 UPDATE rvo_file SET rvomodu = g_rvo.rvomodu,
                                     rvodate = g_rvo.rvodate
                       WHERE rvo01 = g_rvo.rvo01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvo_file",g_rvo.rvomodu,g_rvo.rvodate,SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_rvo.rvomodu,g_rvo.rvodate
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvp[l_ac].* = g_rvp_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rvp.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t253_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t253_bcl
           COMMIT WORK
           
      ON ACTION add_input
         CALL t253_collect('1')
         CALL t253_b_fill(' 1=1')
         CALL t253_bp_refresh()
      ON ACTION coverage_input
         CALL t253_collect('2')
         CALL t253_b_fill(' 1=1')
         CALL t253_bp_refresh()
      ON ACTION CONTROLO                        
           IF INFIELD(rvp02) AND l_ac > 1 THEN
              LET g_rvp[l_ac].* = g_rvp[l_ac-1].*
              LET g_rvp[l_ac].rvp02 = g_rec_b + 1
              NEXT FIELD rvp02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rvp03)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rvn01_1" 
               LET g_qryparam.default1 = g_rvp[l_ac].rvp03
               LET g_qryparam.arg1 = g_plant
               CALL cl_create_qry() RETURNING g_rvp[l_ac].rvp03,g_rvp[l_ac].rvp04
               DISPLAY BY NAME g_rvp[l_ac].rvp03,g_rvp[l_ac].rvp04
               CALL t253_rvp03()
               NEXT FIELD rvp03          
            OTHERWISE EXIT CASE
          END CASE
     
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE t253_bcl
    COMMIT WORK
    CALL t253_delHeader()     #CHI-C30002 add
    CALL t253_show()
END FUNCTION                 
               
#CHI-C30002 -------- add -------- begin
FUNCTION t253_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rvo.rvo01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rvo_file ",
                  "  WHERE rvo01 LIKE '",l_slip,"%' ",
                  "    AND rvo01 > '",g_rvo.rvo01,"'"
      PREPARE t253_pb1 FROM l_sql 
      EXECUTE t253_pb1 INTO l_cnt
      
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
         CALL t253_v()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rvo_file WHERE rvo01 = g_rvo.rvo01
         INITIALIZE g_rvo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t253_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvo.rvo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t253_cl USING g_rvo.rvo01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t253_cl INTO g_rvo.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvo.rvo01,SQLCA.sqlcode,0)    
       CLOSE t253_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   IF g_rvo.rvoacti ='N' THEN    
      CALL cl_err(g_rvo.rvo01,'mfg1000',0)
      RETURN
   END IF
   IF g_rvo.rvoconf <> 'N' THEN
      CALL cl_err(g_rvo.rvo01,'9022',0)
      RETURN
   END IF
   CALL t253_show()
 
   WHILE TRUE
      LET g_rvo_t.* = g_rvo.*
      LET g_rvo.rvomodu=g_user
      LET g_rvo.rvodate=g_today
 
      CALL t253_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rvo.*=g_rvo_t.*
         CALL t253_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rvo.rvo01 <> g_rvo_t.rvo01 THEN            
         UPDATE rvp_file SET rvp01 = g_rvo.rvo01
          WHERE rvp01 = g_rvo_t.rvo01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rvp_file",g_rvo_t.rvo01,"",SQLCA.sqlcode,"","rvp",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rvo_file SET rvo_file.* = g_rvo.*
       WHERE rvo01 = g_rvo.rvo01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvo_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t253_cl
   COMMIT WORK
   CALL t253_show()
   CALL t253_bp_refresh()
 
END FUNCTION          
                
FUNCTION t253_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvo.rvo01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
   
   OPEN t253_cl USING g_rvo.rvo01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t253_cl INTO g_rvo.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvo.rvo01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rvo.rvoacti ='N' THEN    
      CALL cl_err(g_rvo.rvo01,'mfg1000',0)
      RETURN
   END IF
   IF g_rvo.rvoconf <> 'N' THEN
      CALL cl_err(g_rvo.rvo01,'9022',0)
      RETURN
   END IF
   CALL t253_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rvo01"            #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "rvoplant"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rvo.rvo01         #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_rvo.rvoplant      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                               #No.FUN-9B0098 10/02/24
      DELETE FROM rvo_file WHERE rvo01 = g_rvo.rvo01
      DELETE FROM rvp_file WHERE rvp01 = g_rvo.rvo01
      CLEAR FORM
      CALL g_rvp.clear()
      OPEN t253_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t253_cs
         CLOSE t253_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t253_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t253_cs
         CLOSE t253_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t253_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t253_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t253_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t253_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t253_copy()
DEFINE l_newno     LIKE rvo_file.rvo01,
       l_oldno     LIKE rvo_file.rvo01,
       li_result   LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rvo.rvo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t253_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rvo01
 
       BEFORE INPUT
          CALL cl_set_docno_format("rvo01")
	  
      AFTER FIELD rvo01  #分貨調整單號
         IF NOT cl_null(g_rvo.rvo01) THEN
#               CALL s_check_no("art",l_newno,g_rvo_t.rvo01,"4","rvo_file","rvo01,rvoplant","") #FUN-A70130 mark
               #CALL s_check_no("art",l_newno,g_rvo_t.rvo01,"C3","rvo_file","rvo01,rvoplant","") #FUN-A70130 mod
                CALL s_check_no("art",l_newno,"","C3","rvo_file","rvo01,rvoplant","") #FUN-A70130 mod  #FUN-B50026 mod
                    RETURNING li_result,l_newno
                IF (NOT li_result) THEN                                                            
                    NEXT FIELD rvo01                                                                                      
                END IF  
         END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rvo01)                        
              LET g_t1=s_get_doc_no(l_newno)
#             CALL q_smy(FALSE,FALSE,g_t1,'art','4') RETURNING g_t1   #FUN-A70130--mark--
              CALL q_oay(FALSE,FALSE,g_t1,'C3','art') RETURNING g_t1  #FUN-A70130--add--
              LET l_newno=g_t1
              DISPLAY l_newno TO rvo01
              OTHERWISE EXIT CASE
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
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rvo.rvo01  
      ROLLBACK WORK 
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rvo_file         
    WHERE rvo01=g_rvo.rvo01 
       INTO TEMP y
#  CALL s_auto_assign_no("art",l_newno,g_today,"4","rvo_file","rvo01,rvoplant","","","") #FUN-A70130 mark
   CALL s_auto_assign_no("art",l_newno,g_today,"C3","rvo_file","rvo01,rvoplant","","","") #FUN-A70130 mod
          RETURNING li_result,l_newno
   IF (NOT li_result) THEN        
       CALL cl_err('','sub-145',0)                                                                   
       RETURN                                                                     
   END IF
   UPDATE y
       SET rvo01 = l_newno,   
           rvo03 = g_today, 
           rvouser = g_user,   
           rvogrup = g_grup,   
           rvooriu=g_user,    #TQC-A30041 ADD
           rvoorig=g_grup,    #TQC-A30041 ADD
           rvomodu = NULL,     
           rvocrat = g_today,  
           rvoacti = 'Y',
           rvoconf = 'N',
           rvoconu = NULL,
           rvocond = NULL      
 
   INSERT INTO rvo_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rvo_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rvp_file         
    WHERE rvp01 = g_rvo.rvo01 
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rvp01 = l_newno
 
   INSERT INTO rvp_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK           #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rvp_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK            #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rvo.rvo01
   SELECT rvo_file.* INTO g_rvo.* 
     FROM rvo_file 
    WHERE rvo01 = l_newno
   CALL t253_u()
   CALL t253_b()
   #FUN-C80046---begin
   #SELECT rvo_file.* INTO g_rvo.* 
   #  FROM rvo_file
   # WHERE rvo01 = l_oldno
   #CALL t253_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t253_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvo.rvo01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t253_cl USING g_rvo.rvo01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t253_cl INTO g_rvo.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvo.rvo01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rvo.rvoconf <> 'N' THEN
      CALL cl_err(g_rvo.rvo01,'9022',0)
      RETURN
   END IF
   LET g_success = 'Y'
 
   CALL t253_show()
 
   IF cl_exp(0,0,g_rvo.rvoacti) THEN                   
      LET g_chr=g_rvo.rvoacti
      IF g_rvo.rvoacti='Y' THEN
         LET g_rvo.rvoacti='N'
      ELSE
         LET g_rvo.rvoacti='Y'
      END IF
 
      UPDATE rvo_file SET rvoacti=g_rvo.rvoacti,
                          rvomodu=g_user,
                          rvodate=g_today
       WHERE rvo01=g_rvo.rvo01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rvo_file",g_rvo.rvo01,"",SQLCA.sqlcode,"","",1)  
         LET g_rvo.rvoacti=g_chr
      END IF
   END IF
 
   CLOSE t253_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_set_field_pic("","","","","",g_rvo.rvoacti)
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rvoacti,rvomodu,rvodate
     INTO g_rvo.rvoacti,g_rvo.rvomodu,g_rvo.rvodate FROM rvo_file
    WHERE rvo01=g_rvo.rvo01
   DISPLAY BY NAME g_rvo.rvoacti,g_rvo.rvomodu,g_rvo.rvodate
   CALL cl_set_field_pic('','','','','',g_rvo.rvoacti)
END FUNCTION
 
FUNCTION t253_bp_refresh()
 
  DISPLAY ARRAY g_rvp TO s_rvp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION                                            
                    
FUNCTION t253_y() #審核
DEFINE l_rvoconu_desc LIKE gen_file.gen02 
 
   IF cl_null(g_rvo.rvo01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF   
#CHI-C30107 ----------- add ---------- begin
   IF g_rvo.rvoacti ='N' THEN
      CALL cl_err(g_rvo.rvo01,'mfg1000',0)
      RETURN
   END IF
   IF g_rvo.rvoconf <> 'N' THEN
      CALL cl_err(g_rvo.rvo01,'9022',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
        RETURN
   END IF
#CHI-C30107 ----------- add ---------- end
   SELECT * INTO g_rvo.* FROM rvo_file
    WHERE rvo01 = g_rvo.rvo01 
 
   IF g_rvo.rvoacti ='N' THEN    
      CALL cl_err(g_rvo.rvo01,'mfg1000',0)
      RETURN
   END IF
   IF g_rvo.rvoconf <> 'N' THEN
      CALL cl_err(g_rvo.rvo01,'9022',0)
      RETURN
   END IF
   DROP TABLE rvp_temp
   SELECT * FROM rvp_file WHERE rvp01 = g_rvo.rvo01 AND rvp07 > 0
      INTO TEMP rvp_temp
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t253_cl USING g_rvo.rvo01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t253_cl INTO g_rvo.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
     END IF
   
#CHI-C30107 -------------- mark ------------ begin
#  IF NOT cl_confirm('axm-108') THEN 
#       RETURN
#  END IF      
#CHI-C30107 -------------- mark ------------ end
   CALL s_showmsg_init()
   CALL t253_update() #更新配送分貨單
   IF g_success = 'N' THEN
      CLOSE t253_cl
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF
        UPDATE rvo_file SET rvoconf = 'Y',
                            rvoconu = g_user,
                            rvocond = g_today,
                            rvomodu = g_user,
                            rvodate = g_today
               WHERE rvo01 = g_rvo.rvo01
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rvo_file",g_rvo.rvo01,"",STATUS,"","",1) 
              LET g_success = 'N'
            ELSE
             IF SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","rvo_file",g_rvo.rvo01,"","9050","","",1) 
              LET g_success = 'N'          
             END IF
            END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rvo.rvoconf = 'Y'
      LET g_rvo.rvoconu = g_user
      LET g_rvo.rvocond = g_today
      LET g_rvo.rvomodu = g_user
      LET g_rvo.rvodate = g_today
      DISPLAY BY NAME g_rvo.rvoconf,g_rvo.rvoconu,g_rvo.rvocond,
                      g_rvo.rvomodu,g_rvo.rvodate
      SELECT gen02 INTO l_rvoconu_desc
        FROM gen_file
       WHERE gen01 = g_rvo.rvoconu
         AND genacti = 'Y'
      DISPLAY l_rvoconu_desc TO rvoconu_desc
      CALL cl_set_field_pic('Y',"","","","","")
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION
 
FUNCTION t253_update() #更新配送分貨單
DEFINE l_rvp RECORD LIKE rvp_file.*
#DEFINE l_rvnn  RECORD LIKE rvnn_file.* #MOD-B80222 mark
DEFINE l_rvn  RECORD LIKE rvn_file.*    #MOD-B80222 add
DEFINE l_rvn03 LIKE rvn_file.rvn03
DEFINE l_rvn04 LIKE rvn_file.rvn04
DEFINE l_ruc18 LIKE ruc_file.ruc18
DEFINE l_ruc07 LIKE ruc_file.ruc07
DEFINE l_ruc08 LIKE ruc_file.ruc08   #MOD-B80222 add
DEFINE l_ruc09 LIKE ruc_file.ruc09   #MOD-B80222 add
#DEFINE l_pcnm07 LIKE u_pcnm.pcnm07
DEFINE l_pcnm07 LIKE ruc_file.ruc18
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rugplant LIKE rug_file.rugplant
#DEFINE l_rvnn07   LIKE rvnn_file.rvnn07                   #TQC-9B0045-Add  #MOD-B80222 mark
DEFINE l_rvn10   LIKE rvn_file.rvn10   #MOD-B80222 add
 
    DECLARE rvp_cs1 CURSOR FOR SELECT * FROM rvp_temp
    FOREACH rvp_cs1 INTO l_rvp.*
      IF STATUS THEN
            CALL s_errmsg('','','Foreach rvp_cs1',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
      END IF
      CASE l_rvp.rvp06
       WHEN '1'
       #UPDATE rvnn_file SET rvnn07 = rvnn07 + l_rvp.rvp07     #MOD-B80222 mark
       # WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04   #MOD-B80222 mark
        UPDATE rvn_file SET rvn10 = rvn10 + l_rvp.rvp07    #MOD-B80222 add
         WHERE rvn01 = l_rvp.rvp03 AND rvn02 = l_rvp.rvp04 #MOD-B80222 add
       WHEN '2'
        #TQC-9B0045-Mark-Begin
#       UPDATE rvnn_file SET rvnn07 = DECODE(SIGN(rvnn07-l_rvp.rvp07),-1,0,(rvnn07-l_rvp.rvp07))
#        WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04 
        #TQC-9B0045-Mark-End
#TQC-9B0045-Add-Begin
        #SELECT rvnn07 INTO l_rvnn07 FROM rvnn_file             #MOD-B80222 mark
        # WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04   #MOD-B80222 mark
        SELECT rvn10 INTO l_rvn10 FROM rvn_file                 #MOD-B80222 add
         WHERE rvn01 = l_rvp.rvp03 AND rvn02 = l_rvp.rvp04      #MOD-B80222 add
       #IF l_rvnn07-l_rvp.rvp07 < 0 THEN  #MOD-B80222 mark
        IF l_rvn10-l_rvp.rvp07 < 0 THEN   #MOD-B80222 add
          #UPDATE rvnn_file SET rvnn07 = 0                        #MOD-B80222 mark
          # WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04   #MOD-B80222 mark
           UPDATE rvn_file SET rvn10 = 0                          #MOD-B80222 add
            WHERE rvn01 = l_rvp.rvp03 AND rvn02 = l_rvp.rvp04     #MOD-B80222 add
        ELSE 
          #UPDATE rvnn_file SET rvnn07 = l_rvnn07-l_rvp.rvp07     #MOD-B80222 mark
          # WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04   #MOD-B80222 mark
           UPDATE rvn_file SET rvn10 = l_rvn10-l_rvp.rvp07        #MOD-B80222 add
            WHERE rvn01 = l_rvp.rvp03 AND rvn02 = l_rvp.rvp04     #MOD-B80222 add 
        END IF      
#TQC-9B0045-Add-End
       WHEN '3'        
         #UPDATE rvnn_file SET rvnn07 = l_rvp.rvp07               #MOD-B80222 mark
         # WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04    #MOD-B80222 mark
          UPDATE rvn_file SET rvn10 = l_rvp.rvp07                 #MOD-B80222 add
           WHERE rvn01 = l_rvp.rvp03 AND rvn02 = l_rvp.rvp04      #MOD-B80222 add
      END CASE
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_rvp.rvp03,"/",l_rvp.rvp04
         CALL s_errmsg('rvp03,rvp04',g_showmsg,'UPDATE rvn_file:',SQLCA.sqlcode,1)
      ELSE          
        #SELECT * INTO l_rvnn.* FROM rvnn_file                  #MOD-B80222 mark
        #  WHERE rvnn01 = l_rvp.rvp03 AND rvnn02 = l_rvp.rvp04  #MOD-B80222 mark
         SELECT * INTO l_rvn.* FROM rvn_file                  #MOD-B80222 add
          WHERE rvn01 = l_rvp.rvp03 AND rvn02 = l_rvp.rvp04   #MOD-B80222 add
         #SELECT DISTINCT ruc07 INTO l_ruc07 FROM ruc_file
         #WHERE ruc01 = l_rvnn.rvnn05  #MOD-B80222 mark
         #  AND ruc08 = l_rvnn.rvnn03  #MOD-B80222 mark
         #  AND ruc09 = l_rvnn.rvnn04  #MOD-B80222 mark
         SELECT DISTINCT ruc07,ruc08,ruc09 #MOD-B80222 add
           INTO l_ruc07,l_ruc08,l_ruc09    #MOD-B80222 add
           FROM ruc_file                   #MOD-B80222 add
          WHERE ruc01 = l_rvn.rvn06    #MOD-B80222 add
            AND ruc02 = l_rvn.rvn03    #MOD-B80222 add
            AND ruc03 = l_rvn.rvn04    #MOD-B80222 add   
#MOD-B80222 mark begin------------------------
#         IF l_ruc07 MATCHES '[56]' THEN
#            IF l_ruc07 = '5' THEN
##                SELECT pcnm07 INTO l_pcnm07 FROM u_pcnm
##                 WHERE pcnm00 = l_rvnn.rvnn05
##                   AND pcnm01 = l_rvnn.rvnn03
##                   AND pcnm02 = l_rvnn.rvnn04
#            END IF
#            IF l_ruc07 ='6' THEN     
#                SELECT azw07 INTO l_rugplant FROM azw_file
#                #WHERE azw01 = l_rvnn.rvnn05 #MOD-B80222 mark
#                 WHERE azw01 = l_rvn.rvn06   #MOD-B80222 add
#                SELECT azp03 INTO l_dbs FROM azp_file
#                 WHERE azp01 = l_rugplant
#                #LET g_sql = "SELECT rug05 FROM ",s_dbstring(l_dbs CLIPPED),"rug_file", #FUN-A50102
#                LET g_sql = "SELECT rug05 FROM ",cl_get_target_table(l_rugplant, 'rug_file'),  #FUN-A50102
#                            " WHERE rug01 = ?",
#                            "   AND rug02 = ?",
#                            "   AND rugplant = ?"
#                CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
#                CALL cl_parse_qry_sql(g_sql, l_rugplant) RETURNING g_sql  #FUN-A50102            
#                PREPARE rug_cs4 FROM g_sql
#               #EXECUTE rug_cs4 USING l_rvnn.rvnn03,l_rvnn.rvnn04,l_rugplant
#                EXECUTE rug_cs4 USING l_ruc08,l_ruc09,l_rugplant   #MOD-B80222 add
#                                INTO l_pcnm07                               
#            END IF
#                LET g_sql = "SELECT ruc02,ruc03,COALESCE(ruc18,0) FROM ruc_file",
#                            " WHERE ruc01 = ?  AND ruc02 = ?",  #AND ruc08 = ?",  #MOD-B80222 ruc08>ruc02
#                           #"   AND ruc09 = ? AND ruc07 = ?"
#                            "   AND ruc03 = ? AND ruc07 = ?"    #MOD-B80222
#                DECLARE ruc_cs3 CURSOR FROM g_sql
#               #FOREACH ruc_cs3 USING l_rvnn.rvnn05,l_rvnn.rvnn03,l_rvnn.rvnn04,l_ruc07
#                FOREACH ruc_cs3 USING l_rvn.rvn06,l_rvn.rvn03,l_rvn.rvn04,l_ruc07   #MOD-B80222 add
#                                 INTO l_rvn03,l_rvn04,l_ruc18
#                  #UPDATE rvn_file SET rvn10 = (l_ruc18/l_pcnm07)*l_rvnn.rvnn07
#                   UPDATE rvn_file SET rvn10 = (l_ruc18/l_pcnm07)*l_rvn.rvn10    #MOD-B80222 add
#                    WHERE rvn01 = l_rvp.rvp03
#                      AND rvn03 = l_rvn03
#                      AND rvn04 = l_rvn04
#                  IF SQLCA.sqlcode THEN
#                      LET g_showmsg = l_rvp.rvp03,"/",l_rvp.rvp04
#                      CALL s_errmsg('rvp03,rvp04',g_showmsg,'UPDATE rvn_file:',SQLCA.sqlcode,1)
#                  END IF
#                END FOREACH
#         ELSE
#MOD-B80222 mark end--------------------------------
            #UPDATE rvn_file SET rvn10 = l_rvnn.rvnn07
             UPDATE rvn_file SET rvn10 = l_rvn.rvn10    #MOD-B80222 add
              WHERE rvn01 = l_rvp.rvp03 
                AND rvn02 = l_rvp.rvp04
             IF SQLCA.sqlcode THEN
                LET g_showmsg = l_rvp.rvp03,"/",l_rvp.rvp04
                CALL s_errmsg('rvp03,rvp04',g_showmsg,'UPDATE rvn_file:',SQLCA.sqlcode,1)
             END IF
         #END IF #MOD-B80222 mark
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION t253_v() #作廢
DEFINE l_rvoconu_desc LIKE gen_file.gen02
 
   IF cl_null(g_rvo.rvo01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
   SELECT * INTO g_rvo.* FROM rvo_file
    WHERE rvo01 = g_rvo.rvo01
 
   IF g_rvo.rvoacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_rvo.rvoconf ='X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF g_rvo.rvoconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
   IF NOT cl_confirm('lib-016') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t253_cl USING g_rvo.rvo01
   IF STATUS THEN
      CALL cl_err("OPEN t253_cl:", STATUS, 1)
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t253_cl INTO g_rvo.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t253_cl
      ROLLBACK WORK
      RETURN
    END IF
          
            UPDATE rvo_file SET rvoconf = 'X',
                                rvoconu = g_user,
                                rvocond = g_today,
                                rvomodu = g_user,
                                rvodate = g_today
               WHERE rvo01 = g_rvo.rvo01
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rvo_file",g_rvo.rvo01,"",STATUS,"","",1) 
              LET g_success = 'N'
            ELSE
              IF SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","rvo_file",g_rvo.rvo01,"","9050","","",1) 
                 LET g_success = 'N'
              END IF
            END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rvo.rvoconf = 'X'
      LET g_rvo.rvoconu = g_user
      LET g_rvo.rvocond = g_today
      LET g_rvo.rvomodu = g_user
      LET g_rvo.rvodate = g_today
      DISPLAY BY NAME g_rvo.rvoconf,g_rvo.rvoconu,g_rvo.rvocond,
                      g_rvo.rvouser,g_rvo.rvodate
      SELECT gen02 INTO l_rvoconu_desc
        FROM gen_file
       WHERE gen01 = g_rvo.rvoconu
         AND genacti = 'Y'
      DISPLAY l_rvoconu_desc TO rvoconu_desc
      CALL cl_set_field_pic("","","","",'Y',"")
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION          
#FUN-870007

