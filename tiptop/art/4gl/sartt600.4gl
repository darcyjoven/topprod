# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sartt600.4gl
# Descriptions...: 商品寄存/送貨單
# Date & Author..: FUN-870007 09/09/21 By Zhangyajun
# Modify.........: No:FUN-9B0034 09/11/05 By Cockroach PASS NO. 
# Modify.........: FUN-A10047 10/01/18 By destiny 修改单别 
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.TQC-A20048 10/02/23 By Cockroach BUG處理
# Modify.........: No.FUN-9B0098 10/02/24 By tommas delete cl_doc
# Modify.........: No.TQC-A70111 10/07/30 by yinhy 更改copy（）函數里的單別開窗
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.TQC-AA0060 10/10/12 By yinhy 已經作廢的資料不可再審核
# Modify.........: No.TQC-AA0089 10/10/12 By Carrier 经办人字段录入检查时错误
# Modify.........: No.TQC-AA0142 10/10/29 By Carrier 加入"取消审核"的action
# Modify.........: No:TQC-AC0109 10/12/14 BY shenyang 去掉pos幾號 ，修改來源類型
# Modify.........: No:TQC-B10046 11/01/07 By shenyang
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:FUN-BB0086 12/01/04 By tanxc 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No.FUN-C80043 12/08/24 By yangxf 修改中间库表
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20015 13/03/36 By minpp 修改审核人员，审核日期为审核异动人员，审核异动日期
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt600.global"
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds                             #FUN-9B0034 

FUNCTION t600(p_argv1)
DEFINE p_argv1 LIKE type_file.chr1
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_rxp00 = p_argv1
    LET g_forupd_sql="SELECT * FROM rxp_file ",
                     " WHERE rxp00='",g_rxp00,"' AND rxp01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t600_w AT p_row,p_col WITH FORM "art/42f/artt605"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL t600_g_form()
 
    CALL t600_menu()
    
    CLOSE WINDOW t600_w
END FUNCTION
 
FUNCTION t600_g_form()
DEFINE l_rxq07 LIKE gae_file.gae04
DEFINE l_rxq08 LIKE gae_file.gae04
DEFINE l_inx   LIKE type_file.num5
DEFINE l_str STRING
DEFINE cb      ui.ComboBox    # TQC-AC0109
    # TQC-AC0109 --add--begin
      IF g_aza.aza88 = 'N' THEN
         LET cb = ui.ComboBox.forName("rxp03") 
         CALL cb.removeItem('P')
         CALL cb.removeItem('S')
      END IF   
   # TQC-AC0109 --add--edd 
    CALL cl_set_comp_visible("rxp15",g_rxp00='2')
    SELECT gae04 INTO l_rxq07 FROM gae_file
     WHERE gae01 = 'artt605'
       AND gae12 = 'std'
       AND gae02 = 'rxq07'
       AND gae03 = g_lang
    SELECT gae04 INTO l_rxq08 FROM gae_file
     WHERE gae01 = 'artt605'
       AND gae12 = 'std'
       AND gae02 = 'rxq08'
       AND gae03 = g_lang
 
    IF g_rxp00='1' THEN
       LET l_str = l_rxq07
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rxq07",l_str.subString(1,l_inx-1))
       LET l_str = l_rxq08
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rxq08",l_str.subString(1,l_inx-1))   
    ELSE
       LET l_str = l_rxq07
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rxq07",l_str.subString(l_inx+1,l_str.getLength()))
       LET l_str = l_rxq08
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rxq08",l_str.subString(l_inx+1,l_str.getLength()))
    END IF
END FUNCTION
 
FUNCTION t600_menu()
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_y()
            END IF
         #No.TQC-AA0142  --Begin
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_y()
            END IF
         #No.TQC-AA0142  --End  
         WHEN "void" 
            IF cl_chk_act_auth() THEN
               CALL t600_v(1)
            END IF 
         #FUN-D20039 -----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t600_v(2)
            END IF
         #FUN-D20039 -----------end
         WHEN "maintain"
            IF cl_chk_act_auth() THEN
               CALL t600_m_b()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t600_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t600_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t600_m_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t600_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxq),'','')
             END IF        
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rxp.rxp01) THEN
                 LET g_doc.column1 = "rxp01"
                 LET g_doc.value1 = g_rxp.rxp01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t600_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rxq TO s_rxq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #No.TQC-AA0142  --Begin
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #No.TQC-AA0142  --End  
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY     
      #FUN-D20039 -----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -----------end
      ON ACTION maintain
         LET g_action_choice="maintain"
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
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL t600_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL t600_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t600_fetch('L')
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
         CALL t600_g_form()       #TQC-A20048 ADD
 
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
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
FUNCTION t600_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_rxq.clear()
    CONSTRUCT BY NAME g_wc ON                               
        rxp01,rxp02,rxp03,rxp04,rxp05,
      # rxp06,rxp07,rxp08,rxp09,rxp10,     # TQC-AC0109
        rxp07,rxp08,rxp09,rxp10,     # TQC-AC0109
        rxp11,rxp12,rxp13,rxp14,rxp15,
        rxp16,rxpconf,rxpcond,rxpcont,rxpconu,rxpplant,rxp17,
        rxpuser,rxpgrup,rxpmodu,rxpdate,rxpacti,rxpcrat,
        rxporiu,rxporig
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
           DISPLAY g_rxp00 TO rxp00   
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxp01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxp01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxp01
                 NEXT FIELD rxp01
              WHEN INFIELD(rxp04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxp04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxp04
                 NEXT FIELD rxp04
              WHEN INFIELD(rxp08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxp08"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxp08
                 NEXT FIELD rxp08
              WHEN INFIELD(rxp16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxp16"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxp16
                 NEXT FIELD rxp16
              WHEN INFIELD(rxpconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxpconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxpconu
                 NEXT FIELD rxpconu
              WHEN INFIELD(rxpplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxpplant
                 NEXT FIELD rxpplant
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rwpuser', 'rwpgrup')
   
    CONSTRUCT g_wc2 ON rxq02,rxq03,rxq04,rxq05,rxq06,
                       rxq07,rxq08,rxq09,rxq10
                  FROM s_rxq[1].rxq02,s_rxq[1].rxq03,s_rxq[1].rxq04,
                       s_rxq[1].rxq05,s_rxq[1].rxq06,s_rxq[1].rxq07,
                       s_rxq[1].rxq08,s_rxq[1].rxq09,s_rxq[1].rxq10
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rxq03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxq03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxq03
                 NEXT FIELD rxq03
              WHEN INFIELD(rxq04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxq04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxq04
                 NEXT FIELD rxq04
              WHEN INFIELD(rxq06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rxq06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rxq06
                 NEXT FIELD rxq06
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
        LET g_sql = "SELECT rxp01 FROM rxp_file ", 
                    " WHERE rxp00 = '",g_rxp00,"'",
                    "   AND ",g_wc CLIPPED," ORDER BY rxp01"
    ELSE                                 
        LET g_sql = "SELECT UNIQUE rxp01",
                    "  FROM rxp_file,rxq_file",
                    " WHERE rxp01=rxq01",
                    "   AND rxp00=rxq00",
                    "   AND rxp00='",g_rxp00,"'",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY rxp01"
    END IF
    
    PREPARE t600_prepare FROM g_sql
    DECLARE t600_cs SCROLL CURSOR WITH HOLD FOR t600_prepare
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM rxp_file ",
                 " WHERE rxp00='",g_rxp00,"' AND ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT rxp01) FROM rxp_file,rxq_file",
                 " WHERE rxp01=rxq01 ",
                 "   AND rxp00=rxq00",
                 "   AND rxp00='",g_rxp00,"'",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t600_precount FROM g_sql
    DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_rxq.clear()
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
 
    CALL t600_cs()
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rxp.* TO NULL
        CALL g_rxq.clear()
        RETURN
    END IF
 
    OPEN t600_cs
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_rxq.clear()
    ELSE
       OPEN t600_count
       FETCH t600_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL t600_fetch('F')
       ELSE
          CALL cl_err('',100,0)
       END IF
    END IF
END FUNCTION
 
FUNCTION t600_fetch(p_flrxp)
DEFINE p_flrxp         LIKE type_file.chr1    
       
    CASE p_flrxp
        WHEN 'N' FETCH NEXT     t600_cs INTO g_rxp.rxp01
        WHEN 'P' FETCH PREVIOUS t600_cs INTO g_rxp.rxp01
        WHEN 'F' FETCH FIRST    t600_cs INTO g_rxp.rxp01
        WHEN 'L' FETCH LAST     t600_cs INTO g_rxp.rxp01
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
            FETCH ABSOLUTE g_jump t600_cs INTO g_rxp.rxp01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxp.rxp01,SQLCA.sqlcode,0)
        INITIALIZE g_rxp.* TO NULL  
        RETURN
    ELSE
      CASE p_flrxp
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rxp.* FROM rxp_file    
     WHERE rxp00 = g_rxp00
       AND rxp01 = g_rxp.rxp01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rxp_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rxp.rxpuser           
        LET g_data_group=g_rxp.rxpgrup
        LET g_data_plant=g_rxp.rxpplant
        CALL t600_show()                   
    END IF
END FUNCTION
 
FUNCTION t600_show()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_occ02 LIKE occ_file.occ02
DEFINE l_azp02 LIKE azp_file.azp02
 
    LET g_rxp_t.* = g_rxp.*
    DISPLAY BY NAME g_rxp.rxp00,g_rxp.rxp01,g_rxp.rxp02,g_rxp.rxp03,
                  # g_rxp.rxp04,g_rxp.rxp05,g_rxp.rxp06,g_rxp.rxp07,   # TQC-AC0109
                    g_rxp.rxp04,g_rxp.rxp05,g_rxp.rxp07,               # TQC-AC0109
                    g_rxp.rxp08,g_rxp.rxp09,g_rxp.rxp10,g_rxp.rxp11,
                    g_rxp.rxp12,g_rxp.rxp13,g_rxp.rxp14,g_rxp.rxp15,
                    g_rxp.rxp16,g_rxp.rxp17,g_rxp.rxpconf,g_rxp.rxpcond,
                    g_rxp.rxpcont,g_rxp.rxpconu,g_rxp.rxpplant,g_rxp.rxpuser,
                    g_rxp.rxpgrup,g_rxp.rxpmodu,g_rxp.rxpdate,g_rxp.rxpacti,
                    g_rxp.rxpcrat,g_rxp.rxporiu,g_rxp.rxporig
    IF cl_null(g_rxp.rxpconu) THEN
       DISPLAY '' TO rxpconu_desc
    ELSE
       SELECT gen02 INTO l_gen02 FROM gen_file
        WHERE gen01 = g_rxp.rxpconu
          AND genacti = 'Y'
       DISPLAY l_gen02 TO rxpconu_desc
    END IF
    IF cl_null(g_rxp.rxp08) THEN
       DISPLAY '' TO rxp08_desc
    ELSE
       SELECT occ02 INTO l_occ02 FROM occ_file
        WHERE occ01 = g_rxp.rxp08
          AND occacti = 'Y'
       DISPLAY l_occ02 TO rxp08_desc
    END IF
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_rxp.rxpplant
    CALL t600_rxp16('d')
    CASE g_rxp.rxpconf
       WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
       WHEN "N"
          CALL cl_set_field_pic('',"","","","",g_rxp.rxpacti)
       WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    CALL t600_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t600_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT rxq02,rxq03,rxq04,rxq05,rxq06,'',rxq07,rxq08,rxq09,rxq10",
                "  FROM rxq_file ",
                " WHERE rxq01 = '",g_rxp.rxp01,"'",
                "   AND rxq00 = '",g_rxp00,"'"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t600_pb FROM g_sql
    DECLARE rxq_cs CURSOR FOR t600_pb
 
    CALL g_rxq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rxq_cs INTO g_rxq[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT gfe02 INTO g_rxq[g_cnt].rxq06_desc FROM gfe_file
         WHERE gfe01 = g_rxq[g_cnt].rxq06
           AND gfeacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rxq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
FUNCTION t600_a_default()
DEFINE l_azp02 LIKE azp_file.azp02
 
      LET g_rxp.rxp00 = g_rxp00
      LET g_rxp.rxp02 = g_today
      LET g_rxp.rxp05 = g_today
      LET g_rxp.rxpconf = 'N'
      LET g_rxp.rxpplant = g_plant
      LET g_rxp.rxpuser = g_user
      LET g_rxp.rxpgrup = g_grup
      LET g_rxp.rxpcrat = g_today
      LET g_rxp.rxpacti = 'Y' 
      LET g_rxp.rxporiu = g_user
      LET g_rxp.rxporig = g_grup
      LET g_data_plant = g_plant  #TQC-A10128 ADD
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
      SELECT azw02 INTO g_rxp.rxplegal FROM azw_file
       WHERE azw01 = g_plant
         AND azwacti = 'Y'
      DISPLAY BY NAME g_rxp.rxp00,g_rxp.rxp02,g_rxp.rxp05,
                      g_rxp.rxpconf,g_rxp.rxpplant,g_rxp.rxpuser,
                      g_rxp.rxpgrup,g_rxp.rxpcrat,g_rxp.rxpacti,
                      g_rxp.rxporiu,g_rxp.rxporig
      DISPLAY l_azp02 TO rxpplant_desc
END FUNCTION
 
FUNCTION t600_a()
DEFINE li_result LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rxq.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rxp.* LIKE rxp_file.*                  
   LET g_rxp_t.* = g_rxp.*
  #LET g_data_plant=g_rxp.rxpplant  #TQC-A10128 MARK
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t600_a_default()                   
 
      CALL t600_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rxp.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rxp.rxp01) THEN       
         CONTINUE WHILE
      END IF
      BEGIN WORK
      #No.FUN-A10047--begin
      IF g_rxp00='1' THEN
#        CALL s_auto_assign_no("art",g_rxp.rxp01,g_today,"B","rxp_file","rxp01","","","") #FUN-A70130 mark
         CALL s_auto_assign_no("art",g_rxp.rxp01,g_today,"D3","rxp_file","rxp01","","","") #FUN-A70130 mod
           RETURNING li_result,g_rxp.rxp01
      ELSE
#        CALL s_auto_assign_no("art",g_rxp.rxp01,g_today,"C","rxp_file","rxp01","","","") #FUN-A70130 mark 
         CALL s_auto_assign_no("art",g_rxp.rxp01,g_today,"D4","rxp_file","rxp01","","","") #FUN-A70130 mod
           RETURNING li_result,g_rxp.rxp01
      END IF 
      #No.FUN-A10047--end 
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rxp.rxp01
      IF g_rxp.rxp09 IS NULL THEN LET g_rxp.rxp09=' ' END IF
      IF g_rxp.rxp13 IS NULL THEN LET g_rxp.rxp13=' ' END IF
      LET g_rxp.rxporiu = g_user      #No.FUN-980030 10/01/04
      LET g_rxp.rxporig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO rxp_file VALUES (g_rxp.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err(g_rxp.rxp01,SQLCA.sqlcode,1)   
         CALL cl_err3("ins","rxp_file",g_rxp.rxp01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rxp.* FROM rxp_file
       WHERE rxp01 = g_rxp.rxp01
         AND rxp00 = g_rxp00  
      LET g_rxp_t.* = g_rxp.*
      CALL g_rxq.clear()
      IF cl_confirm("art-221") THEN
         BEGIN WORK
         CALL t600_b_create()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
#           CALL t600_delall() #CHI-C30002 mark
            CALL t600_delHeader()     #CHI-C30002 add
            RETURN
         END IF
         CALL t600_b_fill(" 1=1")
         LET l_ac=1
      ELSE
         LET g_rec_b=0
      END IF
    
      CALL t600_m_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t600_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1
DEFINE g_posdbs     LIKE ryg_file.ryg00
DEFINE g_posdbs_t   LIKE ryg_file.ryg00
DEFINE g_db_links   LIKE ryg_file.ryg02
DEFINE g_db_links_t LIKE ryg_file.ryg02
DEFINE l_sql        STRING
DEFINE l_posdbs     LIKE ryg_file.ryg00
DEFINE l_n        LIKE type_file.num5     
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME
         g_rxp.rxp01,g_rxp.rxp02,g_rxp.rxp03,g_rxp.rxp04,
       #  g_rxp.rxp05,g_rxp.rxp15,g_rxp.rxp16,g_rxp.rxp17             # No:TQC-AC0109
         g_rxp.rxp11,g_rxp.rxp12,g_rxp.rxp13,g_rxp.rxp14,            # No:TQC-AC0109
         g_rxp.rxp05,g_rxp.rxp07,g_rxp.rxp15,g_rxp.rxp16,g_rxp.rxp17 # No:TQC-AC0109
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL t600_set_entry(p_cmd)
          CALL t600_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
	
      AFTER FIELD rxp01
         IF NOT cl_null(g_rxp.rxp01) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rxp.rxp01 <> g_rxp_t.rxp01) THEN
               #No.FUN-A10047--begin
               IF g_rxp00='1' THEN 
#                 CALL s_check_no("art",g_rxp.rxp01,g_rxp_t.rxp01,"B","rxp_file","rxp01","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_rxp.rxp01,g_rxp_t.rxp01,"D3","rxp_file","rxp01","")  #FUN-A70130 mod
                       RETURNING li_result,g_rxp.rxp01
               ELSE
#                 CALL s_check_no("art",g_rxp.rxp01,g_rxp_t.rxp01,"C","rxp_file","rxp01","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_rxp.rxp01,g_rxp_t.rxp01,"D4","rxp_file","rxp01","")  #FUN-A70130 mod
                       RETURNING li_result,g_rxp.rxp01
               END IF  
               #No.FUN-A10047--end
               IF (NOT li_result) THEN
                  LET g_rxp.rxp01=g_rxp_t.rxp01
                  NEXT FIELD rxp01
               END IF
            END IF
         END IF
      
      ON CHANGE rxp03
         IF NOT cl_null(g_rxp.rxp03) THEN
            IF g_rxp.rxp03='1' OR g_rxp.rxp03='2' THEN   # TQC-AC0109
               CALL cl_set_comp_entry("rxp04",TRUE)      # No:TQC-AC0109
               CALL cl_set_comp_entry("rxp07",FALSE)     # No:TQC-AC0109
               LET g_rxp.rxp04=' '                       # No:TQC-AC0109
               LET g_rxp.rxp07=' '                       # No:TQC-AC0109
               LET g_rxp.rxp08=' '
               LET g_rxp.rxp09=' '
               LET g_rxp.rxp10=' '
               LET g_rxp.rxp11=' '
               LET g_rxp.rxp12=' '
               LET g_rxp.rxp13=' '
               LET g_rxp.rxp14=' '
               DISPLAY BY NAME g_rxp.rxp04,g_rxp.rxp07,g_rxp.rxp08,g_rxp.rxp09,g_rxp.rxp10,  # No:TQC-AC0109
                               g_rxp.rxp11,g_rxp.rxp12,g_rxp.rxp13,
                               g_rxp.rxp14
               DISPLAY '' TO rxp08_desc
            END IF                                        # No:TQC-AC0109
          # ELSE                                         # No:TQC-AC0109
            IF g_rxp.rxp03='P' OR g_rxp.rxp03='S' THEN  # No:TQC-AC0109 
               CALL cl_set_comp_entry("rxp04",FALSE)   # No:TQC-AC0109
               CALL cl_set_comp_entry("rxp07",TRUE)    # No:TQC-AC0109
       #       LET g_rxp.rxp06=''  # TQC-AC0109
               LET g_rxp.rxp07=' '
 # No:TQC-AC0109 --add--begin
               LET g_rxp.rxp04=' '
               LET g_rxp.rxp08=' '
               LET g_rxp.rxp09=' '
               LET g_rxp.rxp10=' '
               LET g_rxp.rxp11=' '
               LET g_rxp.rxp12=' '
               LET g_rxp.rxp13=' '
               LET g_rxp.rxp14=' '
               DISPLAY BY NAME g_rxp.rxp04,g_rxp.rxp08,g_rxp.rxp09,g_rxp.rxp10,
                               g_rxp.rxp11,g_rxp.rxp12,g_rxp.rxp13,
                               g_rxp.rxp14
               DISPLAY '' TO rxp08_desc
# No:TQC-AC0109--add--end
         #     DISPLAY BY NAME g_rxp.rxp06,g_rxp.rxp07    # TQC-AC0109
               DISPLAY BY NAME g_rxp.rxp07    # TQC-AC0109
            END IF
         END IF
              
      AFTER FIELD rxp04
         IF NOT cl_null(g_rxp.rxp04) THEN
            IF g_rxp.rxp03='1'   THEN
            LET l_n = 0
            SELECT count(*) INTO l_n FROM oea_file
            where oea01 = g_rxp.rxp04
            IF l_n=0 THEN
               CALL cl_err('','art502',0)
              NEXT FIELD rxp04
            END IF
            END IF
            IF g_rxp.rxp03='2'   THEN
                LET l_n=0
            SELECT count(*) INTO l_n FROM oga_file
             WHERE oga01 = g_rxp.rxp04
            IF l_n=0 THEN
                CALL cl_err('','art502',0)
              NEXT FIELD rxp04
            END IF
           END IF
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rxp.rxp04 != g_rxp_t.rxp04) THEN
               IF NOT cl_null(g_rxp.rxp03) THEN
                  CALL t600_rxp04('a',g_rxp.rxp03)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rxp.rxp04,g_errno,0)
                     LET g_rxp.rxp04 = g_rxp.rxp04
                     DISPLAY BY NAME g_rxp.rxp04
                     NEXT FIELD rxp04
                  END IF
               END IF
            END IF
         END IF
     AFTER FIELD rxp07
# No:TQC-AC0109 --add--begin
     IF NOT cl_null(g_rxp.rxp03) AND NOT cl_null(g_rxp.rxp07) THEN
        SELECT DISTINCT ryg00,ryg02 INTO g_posdbs_t,g_db_links_t FROM ryg_file  #未來如果有多筆傳輸DB可用FOREACH循環
        LET g_posdbs = s_dbstring(g_posdbs_t)
        LET g_db_links = p200_dblinks(g_db_links_t)
        IF g_rxp.rxp03='P'   THEN
           LET l_n = 0
           LET l_sql = " SELECT count(*) ",
                      #" FROM ",g_posdbs,"posda",g_db_links," ",                          #FUN-C80043 MARK
                      #" WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' "         #FUN-C80043 MARK
                       " FROM ",g_posdbs,"td_sale",g_db_links," ",                        #FUN-C80043 ADD
                       " WHERE SHOP = '",g_plant,"' AND SaleNO = '",g_rxp.rxp07,"' ",     #FUN-C80043 ADD
                       "   AND TYPE IN ('0','1','2') "                                    #FUN-C80043 ADD  
           PREPARE sel_posda_pre4 FROM l_sql
           EXECUTE sel_posda_pre4 INTO l_n
           IF l_n = 0 THEN 
              CALL cl_err('','art501',0) 
              NEXT FIELD rxp07
           END IF   
        END IF
        IF  g_rxp.rxp03='S'  THEN
           LET l_n = 0
           LET l_sql = " SELECT count(*) ",
                      #" FROM ",g_posdbs,"posdg",g_db_links," ",                           #FUN-C80043 MARK
                      #" WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' "          #FUN-C80043 MARK
                       " FROM ",g_posdbs,"td_sale",g_db_links," ",                         #FUN-C80043 ADD
                       " WHERE SHOP = '",g_plant,"' AND SaleNO = '",g_rxp.rxp07,"' ",      #FUN-C80043 ADD
                       "   AND TYPE = '3' "                                                #FUN-C80043 ADD
           PREPARE sel_posda_pre3 FROM l_sql
           EXECUTE sel_posda_pre3 INTO l_n
           IF l_n = 0 THEN
              CALL cl_err('','art501',0)
              NEXT FIELD rxp07
           END IF
        END IF
     END IF
# No:TQC-AC0109--add--end   
      AFTER FIELD rxp16
         IF NOT cl_null(g_rxp.rxp16) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rxp.rxp16 != g_rxp_t.rxp16) THEN
               CALL t600_rxp16('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rxp.rxp16,g_errno,0)
                  LET g_rxp.rxp16 = g_rxp.rxp16
                  DISPLAY BY NAME g_rxp.rxp16
                  NEXT FIELD rxp16
               END IF
            END IF
         END IF    
         
      AFTER INPUT
         LET g_rxp.rxpuser = s_get_data_owner("rxp_file") #FUN-C10039
         LET g_rxp.rxpgrup = s_get_data_group("rxp_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rxp.rxp01) THEN
               NEXT FIELD rxp01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rxp01) THEN
            LET g_rxp.* = g_rxp_t.*
            CALL t600_show()
            NEXT FIELD rxp01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rxp01)
              LET g_t1=s_get_doc_no(g_rxp.rxp01)
              IF g_rxp00='1' THEN 
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','B') RETURNING g_t1  #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'D3','ART') RETURNING g_t1  #FUN-A70130--mod--
              ELSE
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','C') RETURNING g_t1  #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'D4','ART') RETURNING g_t1  #FUN-A70130--mod--
              END IF
              LET g_rxp.rxp01=g_t1
              DISPLAY BY NAME g_rxp.rxp01
              NEXT FIELD rxp01
           WHEN INFIELD(rxp04)
              CALL cl_init_qry_var()
              IF g_rxp.rxp03 = '1' THEN                    #NO.TQC-AC0109
                 LET g_qryparam.form = "q_oea01"
              ELSE                                         #NO.TQC-AC0109
                 LET g_qryparam.form = "q_oga"             #NO.TQC-AC0109 
                 LET g_qryparam.where = " oga94 = 'N'"     #NO.TQC-AC0109
              END IF                                       #NO.TQC-AC0109
              LET g_qryparam.default1 = g_rxp.rxp04
              CALL cl_create_qry() RETURNING g_rxp.rxp04
              DISPLAY BY NAME g_rxp.rxp04
              CALL t600_rxp04('d',g_rxp.rxp03)
              NEXT FIELD rxp04
           WHEN INFIELD(rxp16)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rxp.rxp16
              CALL cl_create_qry() RETURNING g_rxp.rxp16
              DISPLAY BY NAME g_rxp.rxp16
              CALL t600_rxp16('d')
              NEXT FIELD rxp16
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
 
FUNCTION t600_u()
DEFINE l_n LIKE type_file.num5 #TQC-AC0109  
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rxp.rxp01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#TQC-AC0109---add--begin
   SELECT count(*) INTO l_n FROM rxq_file
   WHERE rxq01 = g_rxp.rxp01
   AND rxq00 = g_rxp00
   IF l_n > 0 THEN
      CALL cl_set_comp_entry("rxp11，rxp12,rxp13,rxp14",TRUE)
      CALL cl_set_comp_entry("rxp01,rxp02,rxp03,rxp04,rxp05,rxp07",FALSE)    
   END IF
#TQC-AC0109---add--end 
   SELECT * INTO g_rxp.* FROM rxp_file
    WHERE rxp01 = g_rxp.rxp01
      AND rxp00 = g_rxp00
 
   IF g_rxp.rxpacti ='N' THEN    
      CALL cl_err(g_rxp.rxp01,'mfg1600',0)
      RETURN
   END IF
   IF g_rxp.rxpconf <>'N' THEN
      CALL cl_err(g_rxp.rxp01,'9022',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK
 
   OPEN t600_cl USING g_rxp.rxp01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_rxp.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rxp.rxp01,SQLCA.sqlcode,0)    
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t600_show()
 
   WHILE TRUE
      LET g_rxp.rxpmodu = g_user
      LET g_rxp.rxpdate = g_today
 
      CALL t600_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rxp.*=g_rxp_t.*
         CALL t600_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rxp.rxp01 <> g_rxp_t.rxp01 THEN            
         UPDATE rxq_file SET rxq01 = g_rxp.rxp01
          WHERE rxq01 = g_rxp_t.rxp01
            AND rxq00 = g_rxp00
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rxq_file",g_rxp_t.rxp01,"",SQLCA.sqlcode,"","rxq",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rxp_file SET rxp_file.* = g_rxp.*
       WHERE rxp00 = g_rxp00
         AND rxp01 = g_rxp.rxp01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rxp_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t600_cl
   COMMIT WORK
   CALL t600_show()
 
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          
    IF p_cmd = 'u' THEN 
       CALL cl_set_comp_entry("rxp11,rxp12,rxp13,rxp14",TRUE)
    END IF 
    IF p_cmd = 'a' THEN          #TQC-B10046
       CALL cl_set_comp_entry("rxp11",TRUE)
    END IF
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rxp01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1         
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rxp01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t600_b()
DEFINE l_ac_t LIKE type_file.num5
DEFINE l_n    LIKE type_file.num5
DEFINE l_lock_sw LIKE type_file.chr1
DEFINE p_cmd  LIKE type_file.chr1
DEFINE g_posdbs     LIKE ryg_file.ryg00
DEFINE g_posdbs_t   LIKE ryg_file.ryg00
DEFINE g_db_links   LIKE ryg_file.ryg02
DEFINE g_db_links_t LIKE ryg_file.ryg02
DEFINE l_sql        STRING        
DEFINE l_m    LIKE type_file.num5        
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
        
   IF cl_null(g_rxp.rxp01) THEN
      RETURN 
   END IF
       
   SELECT * INTO g_rxp.* FROM rxp_file
    WHERE rxp01=g_rxp.rxp01
      AND rxp00=g_rxp.rxp00
        
   IF g_rxp.rxpacti='N' THEN 
      CALL cl_err(g_rxp.rxp01,'mfg1600',0)
      RETURN 
   END IF
   IF g_rxp.rxpconf<>'N' THEN
      CALL cl_err(g_rxp.rxp01,'9022',0)
      RETURN
   END IF    
   CALL cl_opmsg('b')
        
   LET g_forupd_sql="SELECT rxq02,rxq03,rxq04,rxq05,",
                    "       rxq06,'',rxq07,rxq08,rxq09,rxq10",
                    "  FROM rxq_file",
                    " WHERE rxq00 = '",g_rxp00,"'",
                    "   AND rxq01=? AND rxq02=?",
                    "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_bcl CURSOR FROM g_forupd_sql
        
   INPUT ARRAY g_rxq WITHOUT DEFAULTS FROM s_rxq.*
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
         OPEN t600_cl USING g_rxp.rxp01
         IF STATUS THEN
            CALL cl_err("OPEN t600_cl:",STATUS,1)
            CLOSE t600_cl
            ROLLBACK WORK
         END IF
                
         FETCH t600_cl INTO g_rxp.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_rxp.rxp01,SQLCA.sqlcode,0)
            CLOSE t600_cl
            ROLLBACK WORK 
            RETURN
         END IF
         IF g_rec_b>=l_ac THEN 
            LET p_cmd ='u'
            LET g_rxq_t.*=g_rxq[l_ac].*
            OPEN t600_bcl USING g_rxp.rxp01,g_rxq_t.rxq02
            IF STATUS THEN
               CALL cl_err("OPEN t600_bcl:",STATUS,1)
               LET l_lock_sw='Y'
            ELSE
               FETCH t600_bcl INTO g_rxq[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rxq_t.rxq03,SQLCA.sqlcode,1)
                  LET l_lock_sw="Y"
               END IF
               SELECT gfe02 INTO g_rxq[l_ac].rxq06_desc FROM gfe_file
                WHERE gfe01 = g_rxq[l_ac].rxq06
                  AND gfeacti = 'Y'
            END IF
         END IF
      BEFORE INSERT
         LET l_n=ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_rxq[l_ac].* TO NULL
         LET g_rxq[l_ac].rxq10='N'
         LET g_rxq_t.*=g_rxq[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD rxq02
                
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            CANCEL INSERT
         END IF
         INSERT INTO rxq_file(
                rxq00,rxq01,rxq02,rxq03,
                rxq04,rxq05,rxq06,rxq07,
                rxq08,rxq09,rxq10,rxqplant,
                rxqlegal)
         VALUES(g_rxp.rxp00,g_rxp.rxp01,g_rxq[l_ac].rxq02,g_rxq[l_ac].rxq03,
                g_rxq[l_ac].rxq04,g_rxq[l_ac].rxq05,g_rxq[l_ac].rxq06,g_rxq[l_ac].rxq07,
                g_rxq[l_ac].rxq08,g_rxq[l_ac].rxq09,g_rxq[l_ac].rxq10,g_rxp.rxpplant,
                g_rxp.rxplegal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rxq_file",g_rxp.rxp01,g_rxq[l_ac].rxq02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K.'
            CALL t600_upd_log()
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
                
      BEFORE FIELD rxq02
        IF cl_null(g_rxq[l_ac].rxq02) OR g_rxq[l_ac].rxq02 = 0 THEN 
           SELECT MAX(rxq02)+1 INTO g_rxq[l_ac].rxq02 FROM rxq_file
            WHERE rxq01 = g_rxp.rxp01
              AND rxq00 = g_rxp00
           IF g_rxq[l_ac].rxq02 IS NULL THEN
              LET g_rxq[l_ac].rxq02=1
           END IF
        END IF
         
      AFTER FIELD rxq02
        IF NOT cl_null(g_rxq[l_ac].rxq02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                 g_rxq[l_ac].rxq02 <> g_rxq_t.rxq02) THEN
              SELECT COUNT(*) INTO l_n FROM rxq_file
               WHERE rxq00 = g_rxp00
                 AND rxq01= g_rxp.rxp01 
                 AND rxq02=g_rxq[l_ac].rxq02
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_rxq[l_ac].rxq02=g_rxq_t.rxq02
                 NEXT FIELD rxq02
              END IF
           END IF
         END IF
         
      AFTER FIELD rxq03
        IF NOT cl_null(g_rxq[l_ac].rxq03) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                 g_rxq[l_ac].rxq03 <> g_rxq_t.rxq03) THEN
#NO.TQC-AC0109--add--begin
           IF g_rxp.rxp03 = '1' THEN
              SELECT count(*)
              INTO l_m
              FROM oeb_file
              WHERE oeb01 = g_rxp.rxp04
              AND oeb03 = g_rxq[l_ac].rxq03
           END IF
           IF g_rxp.rxp03 = '2' THEN
              SELECT count(*)
              INTO l_m
              FROM ogb_file
              WHERE ogb01 = g_rxp.rxp04
              AND ogb03 = g_rxq[l_ac].rxq03
              END IF
            SELECT DISTINCT ryg00,ryg02 INTO g_posdbs_t,g_db_links_t FROM ryg_file  #未來如果有多筆傳輸DB可用FOREACH循環
            LET g_posdbs = s_dbstring(g_posdbs_t)
            LET g_db_links = p200_dblinks(g_db_links_t)
            IF g_rxp.rxp03='P'  THEN
               LET l_sql = " SELECT count(*) ",
                          #" FROM ",g_posdbs,"posdb",g_db_links," ",                                                           #FUN-C80043 mark
                          #" WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' "       #FUN-C80043 mark
                           " FROM ",g_posdbs,"td_sale_detail",g_db_links,                                                      #FUN-C80043 add
                           " ,",g_posdbs,"td_sale",g_db_links,                                                                 #FUN-C80043 add
                           " WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' ",   #FUN-C80043 add
                           "   AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE IN ('0','1','2') "   #FUN-C80043 add
               PREPARE sel_posda_pre1 FROM l_sql
               EXECUTE sel_posda_pre1 INTO l_m
            END IF
            IF  g_rxp.rxp03='S'  THEN
                 LET l_sql = " SELECT count(*)  ",
                      #" FROM ",g_posdbs,"posdh",g_db_links," ",                                                         #FUN-C80043 mark
                      #" WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"'"      #FUN-C80043 mark
                       " FROM ",g_posdbs,"td_sale_detail",g_db_links,                                                    #FUN-C80043 add
                       " ,",g_posdbs,"td_sale",g_db_links,                                                               #FUN-C80043 add
                       " WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' ",   #FUN-C80043 add
                       "   AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE = '3' "              #FUN-C80043 add
                 PREPARE sel_posda_pre5 FROM l_sql
                 EXECUTE sel_posda_pre5 INTO l_m
            END IF
            IF l_m=0 THEN
               CALL cl_err(' ','art503',0)
               NEXT FIELD rxq03
            END IF
#NO.TQC-AC0109--add--end
              SELECT COUNT(*) INTO l_n FROM rxq_file
               WHERE rxq00 = g_rxp00
                 AND rxq01= g_rxp.rxp01 
                 AND rxq03=g_rxq[l_ac].rxq03
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_rxq[l_ac].rxq03=g_rxq_t.rxq03
                 NEXT FIELD rxq03
              ELSE
                 CALL t600_rxq03('a',g_rxp.rxp03)    # No:TQC-AC0109
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rxq[l_ac].rxq03,g_errno,0)
                    LET g_rxq[l_ac].rxq03=g_rxq_t.rxq03
                    DISPLAY BY NAME g_rxq[l_ac].rxq03
                    NEXT FIELD rxq03
                 END IF
              END IF
           END IF
        END IF  

#NO.TQC-AC0109--add--begin
   AFTER FIELD rxq04
   IF NOT cl_null(g_rxq[l_ac].rxq04) THEN 
      IF g_rxp.rxp03 = '1' THEN
       SELECT count(*)
        INTO l_m
       FROM oeb_file
       WHERE oeb01 = g_rxp.rxp04
       AND oeb03 = g_rxq[l_ac].rxq03
       AND oeb04 = g_rxq[l_ac].rxq04
     END IF
     IF g_rxp.rxp03 = '2' THEN
     SELECT count(*)
      INTO l_m
      FROM ogb_file
      WHERE ogb01 = g_rxp.rxp04
       AND ogb03 = g_rxq[l_ac].rxq03
       AND ogb04 = g_rxq[l_ac].rxq04
     END IF
     SELECT DISTINCT ryg00,ryg02 INTO g_posdbs_t,g_db_links_t FROM ryg_file  #未來如果有多筆傳輸DB可用FOREACH循環
        LET g_posdbs = s_dbstring(g_posdbs_t)
        LET g_db_links = p200_dblinks(g_db_links_t)
        IF g_rxp.rxp03='P'  THEN
           LET l_sql = " SELECT count(*) ",
                      #" FROM ",g_posdbs,"posdb",g_db_links," ",                                                         #FUN-C80043 mark
                      #" WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' ",    #FUN-C80043 mark
                      #" AND prod = '",g_rxq[l_ac].rxq04,"'"                                                             #FUN-C80043 mark
                       " FROM ",g_posdbs,"td_sale_detail",g_db_links,                                                    #FUN-C80043 add
                       " ,",g_posdbs,"td_sale",g_db_links,                                                               #FUN-C80043 add
                       " WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' ",   #FUN-C80043 add
                       "   AND PLUNO = '",g_rxq[l_ac].rxq04,"'",                                                                           #FUN-C80043 add
                       "   AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE IN ('0','1','2') "   #FUN-C80043 add
           PREPARE sel_posda_pre6 FROM l_sql
           EXECUTE sel_posda_pre6 INTO l_m
        END IF
      IF  g_rxp.rxp03='S'  THEN
                 LET l_sql = " SELECT count(*)  ",
                      # " FROM ",g_posdbs,"posdh",g_db_links," ",                                                         #FUN-C80043 mark
                      # " WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"'",     #FUN-C80043 mark
                      # " AND prod = '",g_rxq[l_ac].rxq04,"'"                                                             #FUN-C80043 mark
                       " FROM ",g_posdbs,"td_sale_detail",g_db_links,                                                    #FUN-C80043 add
                       " ,",g_posdbs,"td_sale",g_db_links,                                                               #FUN-C80043 add
                       " WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' ",   #FUN-C80043 add
                       "   AND PLUNO = '",g_rxq[l_ac].rxq04,"'",                                                                           #FUN-C80043 add
                       "   AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE = '3') "             #FUN-C80043 add
           PREPARE sel_posda_pre7 FROM l_sql
           EXECUTE sel_posda_pre7 INTO l_m
      END IF
      IF l_m=0 THEN
         CALL cl_err(' ','art504',0)
         NEXT FIELD rxq03
      END IF
    END IF
#NO.TQC-AC0109--add--end       
      AFTER FIELD rxq08
        #No.FUN-BB0086--add--begin--
        LET g_rxq[l_ac].rxq08 = s_digqty(g_rxq[l_ac].rxq08,g_rxq[l_ac].rxq06)
        DISPLAY BY NAME g_rxq[l_ac].rxq08
        #No.FUN-BB0086--add--end--
        IF NOT cl_null(g_rxq[l_ac].rxq08) THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND
                 g_rxq[l_ac].rxq08 <> g_rxq_t.rxq08) THEN
              IF g_rxq[l_ac].rxq08>g_rxq[l_ac].rxq07 THEN
                 IF g_rxp00='1' THEN
                    CALL cl_err('','art-604',0)
                 ELSE
                    CALL cl_err('','art-605',0)
                 END IF
                 LET g_rxq[l_ac].rxq08=g_rxq_t.rxq08
                 DISPLAY BY NAME g_rxq[l_ac].rxq08
                 NEXT FIELD rxq08
              END IF
           END IF
        END IF
      BEFORE DELETE                      
           IF g_rxq_t.rxq02 > 0 AND NOT cl_null(g_rxq_t.rxq02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rxq_file
               WHERE rxq01 = g_rxp.rxp01
                 AND rxq02 = g_rxq_t.rxq02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rxq_file",g_rxp.rxp01,g_rxq_t.rxq02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 CALL t600_upd_log()
                 COMMIT WORK
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rxq[l_ac].* = g_rxq_t.*
              CLOSE t600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rxq[l_ac].rxq02,-263,1)
              LET g_rxq[l_ac].* = g_rxq_t.*
           ELSE
              UPDATE rxq_file SET rxq02=g_rxq[l_ac].rxq02,
                                  rxq03=g_rxq[l_ac].rxq03,
                                  rxq04=g_rxq[l_ac].rxq04,
                                  rxq05=g_rxq[l_ac].rxq05,
                                  rxq06=g_rxq[l_ac].rxq06,
                                  rxq07=g_rxq[l_ac].rxq07,
                                  rxq08=g_rxq[l_ac].rxq08,
                                  rxq09=g_rxq[l_ac].rxq09,
                                  rxq10=g_rxq[l_ac].rxq10
               WHERE rxq00=g_rxp00
                 AND rxq01=g_rxp.rxp01
                 AND rxq02=g_rxq_t.rxq02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rxq_file",g_rxp.rxp01,g_rxq_t.rxq02,SQLCA.sqlcode,"","",1) 
                 LET g_rxq[l_ac].* = g_rxq_t.*
              ELSE
                 CALL t600_upd_log()
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rxq[l_ac].* = g_rxq_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rxq.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t600_bcl
           COMMIT WORK
           
       ON ACTION CONTROLO                        
           IF INFIELD(rxq02) AND l_ac > 1 THEN
              LET g_rxq[l_ac].* = g_rxq[l_ac-1].*
              LET g_rxq[l_ac].rxq02 = g_rec_b + 1
              NEXT FIELD rxq02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rxq03)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oeb03" 
               LET g_qryparam.arg1 = g_rxp.rxp04
               LET g_qryparam.default1 = g_rxq[l_ac].rxq03
               CALL cl_create_qry() RETURNING g_rxq[l_ac].rxq03
               DISPLAY BY NAME g_rxq[l_ac].rxq03
            #  CALL t600_rxq03('d')                # No:TQC-AC0109
               CALL t600_rxq03('d',g_rxp.rxp03)    # No:TQC-AC0109
               NEXT FIELD rxq03
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
  
    CLOSE t600_bcl
    COMMIT WORK
#   CALL t600_delall()        #CHI-C30002 mark
    CALL t600_delHeader()     #CHI-C30002 add
    CALL t600_show()
END FUNCTION                
 
FUNCTION t600_upd_log()
    LET g_rxp.rxpmodu = g_user
    LET g_rxp.rxpdate = g_today
    UPDATE rxp_file SET rxpmodu = g_rxp.rxpmodu,rxpdate = g_rxp.rxpdate
     WHERE rxp01 = g_rxp.rxp01
       AND rxp00 = g_rxp00
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","rxp_file",g_rxp.rxpmodu,g_rxp.rxpdate,SQLCA.sqlcode,"","",1)
    END IF
    DISPLAY BY NAME g_rxp.rxpmodu,g_rxp.rxpdate
    MESSAGE 'UPDATE O.K.'
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t600_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   SELECT COUNT(*) INTO g_cnt FROM rxq_file
    WHERE rxq01 = g_rxp.rxp01
      AND rxq00 = g_rxp00
   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rxp.rxp01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rxp_file ",
                  "  WHERE rxp01 LIKE '",l_slip,"%' ",
                  "    AND rxp01 > '",g_rxp.rxp01,"'"
      PREPARE t600_pb1 FROM l_sql 
      EXECUTE t600_pb1 INTO l_cnt
      
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
         CALL t600_v(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rxp_file WHERE rxp01 = g_rxp.rxp01 AND rxp00 = g_rxp00
         INITIALIZE g_rxp.* TO NULL
       # LET g_rxp00 = NULL      #FUN-C80043 mark 
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t600_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rxq_file
#   WHERE rxq01 = g_rxp.rxp01
#     AND rxq00 = g_rxp00
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rxp_file WHERE rxp01 = g_rxp.rxp01 AND rxp00 = g_rxp00
#     CLEAR FORM
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t600_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rxp.rxp01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rxp.* FROM rxp_file
    WHERE rxp01=g_rxp.rxp01
      AND rxp00=g_rxp00
   IF g_rxp.rxpacti ='N' THEN    
      CALL cl_err(g_rxp.rxp01,'mfg1600',0)
      RETURN
   END IF
   IF g_rxp.rxpconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t600_cl USING g_rxp.rxp01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_rxp.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxp.rxp01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t600_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rxp01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rxp.rxp01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM rxp_file WHERE rxp01 = g_rxp.rxp01 AND rxp00 = g_rxp00
      DELETE FROM rxq_file WHERE rxq01 = g_rxp.rxp01 AND rxq00 = g_rxp00
      CLEAR FORM
      CALL g_rxq.clear()
      OPEN t600_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t600_cs
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t600_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t600_cs
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t600_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t600_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t600_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t600_copy()
DEFINE l_newno     LIKE rxp_file.rxp01,
       l_oldno     LIKE rxp_file.rxp01,
       l_cnt       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rxp.rxp01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t600_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rxp01
      AFTER FIELD rxp01
      #No.FUN-A10047--begin
         IF l_newno IS NOT NULL THEN                                          
            #CALL s_check_no("axm",l_newno,g_rxp_t.rxp01,"A9","rxp_file","rxp01","")  #No.TQC-A70111 mark
            #No.TQC-A70111--start
            IF g_rxp00='1' THEN
#              CALL s_check_no("art",l_newno,g_rxp_t.rxp01,"B","rxp_file","rxp01","") #FUN-A70130 mark
              #CALL s_check_no("art",l_newno,g_rxp_t.rxp01,"D3","rxp_file","rxp01","") #FUN-A70130 mod
               CALL s_check_no("art",l_newno,"","D3","rxp_file","rxp01","") #FUN-A70130 mod  #FUN-B50026 mod
                 RETURNING li_result,l_newno 
            ELSE
#              CALL s_check_no("art",l_newno,g_rxp_t.rxp01,"C","rxp_file","rxp01","") #FUN-A70130 mark
              #CALL s_check_no("art",l_newno,g_rxp_t.rxp01,"D4","rxp_file","rxp01","") #FUN-A70130 mod
               CALL s_check_no("art",l_newno,"","D4","rxp_file","rxp01","") #FUN-A70130 mod  #FUN-B50026 mod
                 RETURNING li_result,l_newno 
            END IF
            #No.TQC-A70111--end
               #No.FUN-A10047--end
               IF (NOT li_result) THEN
                  LET g_rxp.rxp01=g_rxp_t.rxp01
                  NEXT FIELD rxp01
               END IF                                   
         END IF 
       
       ON ACTION controlp
       
          CASE
             WHEN INFIELD(rxp01)                        
                LET g_t1=s_get_doc_no(l_newno)
                LET g_qryparam.state = 'i' 
                LET g_qryparam.plant = g_plant
                #CALL q_smy(FALSE,FALSE,g_t1,'art','B') RETURNING g_t1  #No.TQC-A70111
                #No.TQC-A70111 --start
                IF g_rxp00='1' THEN 
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','B') RETURNING g_t1   #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'D3','ART') RETURNING g_t1  #FUN-A70130--mod--
                ELSE
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','C') RETURNING g_t1  #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'D4','ART') RETURNING g_t1  #FUN-A70130--mod--
                END IF
                #No.TQC-A70111 --end
                LET l_newno=g_t1
                DISPLAY l_newno TO rxp01            
                NEXT FIELD rxp01
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
      DISPLAY BY NAME g_rxp.rxp01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rxp_file         
    WHERE rxp01=g_rxp.rxp01
     INTO TEMP y

#FUN-A70130--begin--
#  CALL s_auto_assign_no("art",l_newno,g_today,"","rxp_file","rxp01","","","")       #FUN-A70130 mark
#         RETURNING li_result,l_newno                                                #FUN-A70130 mark
   IF g_rxp00='1' THEN 
      CALL s_auto_assign_no("art",l_newno,g_today,"D3","rxp_file","rxp01","","","")
             RETURNING li_result,l_newno
   ELSE
      CALL s_auto_assign_no("art",l_newno,g_today,"D4","rxp_file","rxp01","","","")
             RETURNING li_result,l_newno
   END IF
#FUN-A70130--end--
   IF (NOT li_result) THEN
       RETURN
   END IF
   UPDATE y
       SET rxp01=l_newno,    
           rxpuser=g_user,   
           rxpgrup=g_grup,   
           rxpmodu=NULL,     
           rxpdate=g_today,  
           rxpacti='Y'      
 
   INSERT INTO rxp_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rxp_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rxq_file         
       WHERE rxq01=g_rxp.rxp01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rxq01=l_newno
 
   INSERT INTO rxq_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK            # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rxq_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK             # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rxp.rxp01
   SELECT rxp_file.* INTO g_rxp.* FROM rxp_file WHERE rxp01 = l_newno
   CALL t600_u()
   CALL t600_m_b()
   #SELECT rxp_file.* INTO g_rxp.* FROM rxp_file WHERE rxp01 = l_oldno  #FUN-C80046
   #CALL t600_show()   #FUN-C80046
 
END FUNCTION
 
FUNCTION t600_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rxp.rxp01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t600_cl USING g_rxp.rxp01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_rxp.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rxp.rxp01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   IF g_rxp.rxpconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   LET g_success = 'Y'
 
   CALL t600_show()
 
   IF cl_exp(0,0,g_rxp.rxpacti) THEN                   
      LET g_chr=g_rxp.rxpacti
      IF g_rxp.rxpacti='Y' THEN
         LET g_rxp.rxpacti='N'
      ELSE
         LET g_rxp.rxpacti='Y'
      END IF
      UPDATE rxp_file SET rxpacti=g_rxp.rxpacti,
                          rxpmodu=g_user,
                          rxpdate=g_today
       WHERE rxp01=g_rxp.rxp01
         AND rxp00=g_rxp00
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rxp_file",g_rxp.rxp01,"",SQLCA.sqlcode,"","",1)  
         LET g_rxp.rxpacti=g_chr
      END IF
   END IF
 
   CLOSE t600_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rxpacti,rxpmodu,rxpdate
     INTO g_rxp.rxpacti,g_rxp.rxpmodu,g_rxp.rxpdate FROM rxp_file
    WHERE rxp01=g_rxp.rxp01
      AND rxp00=g_rxp00
   DISPLAY BY NAME g_rxp.rxpacti,g_rxp.rxpmodu,g_rxp.rxpdate
 
END FUNCTION
 
FUNCTION t600_bp_refresh()
 
  DISPLAY ARRAY g_rxq TO s_rxq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION t600_y()
 
    IF cl_null(g_rxp.rxp01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
 
#CHI-C30107 ----------------- add ---------------- begin
   IF g_rxp.rxpacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   IF g_rxp.rxpconf='X' THEN
        CALL cl_err('','alm-674',0)
        RETURN
   END IF   
   IF NOT cl_upsw(0,0,g_rxp.rxpconf) THEN RETURN END IF
   SELECT * INTO g_rxp.* FROM rxp_file WHERE rxp00 = g_rxp.rxp00
                                         AND rxp01 = g_rxp.rxp01
#CHI-C30107 ----------------- add ---------------- end
   IF g_rxp.rxpacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   #No.TQC-AA0060 -start--
   IF g_rxp.rxpconf='X' THEN
        CALL cl_err('','alm-674',0)
        RETURN
   END IF
   #No.TQC-AA0060 -end--
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t600_cl USING g_rxp.rxp01
   IF STATUS THEN
      CALL cl_err("OPEN t60_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_rxp.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_rxp_t.* = g_rxp.*
#  IF cl_upsw(0,0,g_rxp.rxpconf) THEN  #CHI-C30107 mark
      IF g_rxp.rxpconf='Y' THEN
         LET g_rxp.rxpconf='N'
        #CHI-D20015---mod--str
        #LET g_rxp.rxpconu = ''   
        #LET g_rxp.rxpcond = ''   
        #LET g_rxp.rxpcont = ''   
         LET g_rxp.rxpconu = g_user
         LET g_rxp.rxpcond = g_today
         LET g_rxp.rxpcont = TIME
        #CHI-D20015---mod--end 
         UPDATE rxq_file SET rxq10 = 'N'
          WHERE rxq01 = g_rxp.rxp01
            AND rxq00 = g_rxp00
      ELSE
         LET g_rxp.rxpconf='Y'
         LET g_rxp.rxpconu = g_user
         LET g_rxp.rxpcond = g_today
         LET g_rxp.rxpcont = TIME
         UPDATE rxq_file SET rxq10 = 'Y'
          WHERE rxq01 = g_rxp.rxp01
            AND rxq00 = g_rxp00
            AND rxq07 = rxq08
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rxq_file",g_rxp.rxp01,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
      LET g_rxp.rxpmodu = g_user
      LET g_rxp.rxpdate = g_today
      UPDATE rxp_file SET rxpconf = g_rxp.rxpconf,
                          rxpconu = g_rxp.rxpconu,
                          rxpcond = g_rxp.rxpcond,
                          rxpcont = g_rxp.rxpcont,
                          rxpmodu = g_rxp.rxpconu,
                          rxpdate = g_rxp.rxpdate
       WHERE rxp01 = g_rxp.rxp01
         AND rxp00 = g_rxp00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rxp_file",g_rxp.rxp01,"",STATUS,"","",1)
         LET g_rxp.rxpconf=g_rxp_t.rxpconf
         LET g_rxp.rxpconu=g_rxp_t.rxpconu
         LET g_rxp.rxpcond=g_rxp_t.rxpcond
         LET g_rxp.rxpcont=g_rxp_t.rxpcont
         LET g_success = 'N'
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rxp_file",g_rxp.rxp01,"","9050","","",1)
            LET g_rxp.rxpconf=g_rxp_t.rxpconf
            LET g_rxp.rxpconu=g_rxp_t.rxpconu
            LET g_rxp.rxpcond=g_rxp_t.rxpcond
            LET g_rxp.rxpcont=g_rxp_t.rxpcont
            LET g_success = 'N'
         END IF
      END IF
#  END IF  #CHI-C30107 mark
   CLOSE t600_cl        #No.TQC-AA0060 
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_rxp.rxpconf,g_rxp.rxpconu,g_rxp.rxpcond,
                      g_rxp.rxpcont,g_rxp.rxpuser,g_rxp.rxpdate
      IF g_rxp.rxpconf='Y' THEN
        CALL cl_set_field_pic("Y","","","","","")
      ELSE
        CALL cl_set_field_pic("N","","","","","")
      END IF
      CALL t600_b_fill(g_wc2)
      CALL t600_bp_refresh()
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_v(p_type) #作廢
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF cl_null(g_rxp.rxp01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rxp.rxpconf='X' THEN RETURN END IF
    ELSE
       IF g_rxp.rxpconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   

   IF g_rxp.rxpacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_rxp.rxpconf = 'Y' THEN
#      CALL cl_err('','apy-705',0)   #CHI-B40058
      CALL cl_err('','apc-122',0)    #CHI-B40058
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t600_cl USING g_rxp.rxp01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_rxp.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
    LET g_rxp_t.* = g_rxp.*      
    IF cl_void(0,0,g_rxp.rxpconf) THEN
       IF g_rxp.rxpconf='X' THEN
         LET g_rxp.rxpconf='N'
         LET g_rxp.rxpconu = ''
         LET g_rxp.rxpcond = ''
         LET g_rxp.rxpcont = ''
       ELSE
         LET g_rxp.rxpconf='X'
         LET g_rxp.rxpconu = g_user
         LET g_rxp.rxpcond = g_today
         LET g_rxp.rxpcont = TIME
       END IF 
       LET g_rxp.rxpmodu = g_user
       LET g_rxp.rxpdate = g_today
       UPDATE rxp_file SET rxpconf = g_rxp.rxpconf,
                           rxpconu = g_rxp.rxpconu,
                           rxpcond = g_rxp.rxpcond,
                           rxpcont = g_rxp.rxpcont,
                           rxpmodu = g_rxp.rxpmodu,
                           rxpdate = g_rxp.rxpdate
        WHERE rxp01 = g_rxp.rxp01 
          AND rxp00 = g_rxp00
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","rxp_file",g_rxp.rxp01,"",STATUS,"","",1) 
          LET g_rxp.rxpconf=g_rxp_t.rxpconf
          LET g_rxp.rxpconu=g_rxp_t.rxpconu
          LET g_rxp.rxpcond=g_rxp_t.rxpcond
          LET g_rxp.rxpcont=g_rxp_t.rxpcont
          LET g_success = 'N'
       ELSE
          IF SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("upd","rxp_file",g_rxp.rxp01,"","9050","","",1) 
             LET g_rxp.rxpconf=g_rxp_t.rxpconf
             LET g_rxp.rxpconu=g_rxp_t.rxpconu
             LET g_rxp.rxpcond=g_rxp_t.rxpcond
             LET g_rxp.rxpcont=g_rxp_t.rxpcont
             LET g_success = 'N'            
          END IF
       END IF
   END IF
   CLOSE t600_cl            #No.TQC-AA0060 
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_rxp.rxpconf,g_rxp.rxpconu,g_rxp.rxpcond,
                      g_rxp.rxpcont,g_rxp.rxpuser,g_rxp.rxpdate
      IF g_rxp.rxpconf='X' THEN
        CALL cl_set_field_pic("","","","",'Y',"")
      ELSE
        CALL cl_set_field_pic("","","","",'N',"")
      END IF
   ELSE
      ROLLBACK WORK
   END IF   
END FUNCTION
 
FUNCTION t600_rxp04(p_cmd,p_type)
DEFINE p_cmd LIKE type_file.chr1
DEFINE p_type LIKE rxp_file.rxp03
DEFINE l_oeaconf LIKE oea_file.oeaconf
DEFINE l_occ02 LIKE occ_file.occ02
DEFINE l_ogaconf  LIKE oga_file.ogaconf    # NO:TQC-AC0109
DEFINE l_oga94    LIKE oga_file.oga94       # NO:TQC-AC0109
    LET g_errno=''
    IF p_type='1'   THEN     # TQC-AC0109
    SELECT oea03,oea85,oea87,oea88,oea89,oea90,oea91,oea94,oeaconf    # TQC-AC0109
      INTO g_rxp.rxp08,g_rxp.rxp09,g_rxp.rxp10,g_rxp.rxp11,
           g_rxp.rxp12,g_rxp.rxp13,g_rxp.rxp14,g_rxp.rxp07,l_oeaconf   # TQC-AC0109
      FROM oea_file
     WHERE oea01 = g_rxp.rxp04
    END IF
    # NO:TQC-AC0109--add--begin
    IF p_type='2'   THEN 
    SELECT oga03,oga85,oga87,oga88,oga89,oga90,oga91,oga94,ogaconf
      INTO g_rxp.rxp08,g_rxp.rxp09,g_rxp.rxp10,g_rxp.rxp11,
           g_rxp.rxp12,g_rxp.rxp13,g_rxp.rxp14,l_oga94,l_ogaconf
      FROM oga_file
     WHERE oga01 = g_rxp.rxp04
    END IF 
    # NO:TQC-AC0109--add--end
    CASE WHEN SQLCA.sqlcode=100 LET g_errno=''
         WHEN l_oeaconf<>'Y'    LET g_errno='9029'
         WHEN l_ogaconf<>'Y'    LET g_errno='9029'     # NO:TQC-AC0109
         WHEN l_oga94 ='Y'      LET g_errno='art500'   # NO:TQC-AC0109
         OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       SELECT occ02 INTO l_occ02 FROM occ_file
        WHERE occ01 = g_rxp.rxp08
          AND occacti = 'Y'
       IF cl_null(g_rxp.rxp07) THEN LET g_rxp.rxp07= ' ' END IF
       IF cl_null(g_rxp.rxp09) THEN LET g_rxp.rxp09= ' ' END IF
       IF cl_null(g_rxp.rxp13) THEN LET g_rxp.rxp13= ' ' END IF
       DISPLAY BY NAME g_rxp.rxp08,g_rxp.rxp09,g_rxp.rxp10,g_rxp.rxp11,
                       g_rxp.rxp12,g_rxp.rxp13,g_rxp.rxp14,g_rxp.rxp07   # TQC-AC0109
       DISPLAY l_occ02 TO rxp08_desc
    END IF 
#  END IF  # NO:TQC-AC0109    
END FUNCTION
# NO:TQC-AC0109--add--begin
FUNCTION p200_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF

END FUNCTION
# NO:TQC-AC0109--add--end 
FUNCTION t600_rxp16(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_genacti LIKE gen_file.genacti
DEFINE l_gen02   LIKE gen_file.gen02       #No.TQC-AA0089
 
   LET g_errno=''
   SELECT gen02,genacti 
#    INTO g_rxp.rxp16,l_genacti            #No.TQC-AA0089
     INTO l_gen02,    l_genacti            #No.TQC-AA0089
     FROM gen_file
    WHERE gen01 = g_rxp.rxp16
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='aoo-017'
        WHEN l_genacti='N'     LET g_errno='9028'
        OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_rxp.rxp16
       DISPLAY l_gen02 TO FORMONLY.rxp16_desc    #No.TQC-AA0089
    END IF
END FUNCTION
 
FUNCTION t600_rxq03(p_cmd,p_type)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_oeb04 LIKE oeb_file.oeb04
DEFINE l_oeb05 LIKE oeb_file.oeb05
DEFINE l_oeb06 LIKE oeb_file.oeb06
DEFINE l_oeb12 LIKE oeb_file.oeb12
DEFINE p_type LIKE rxp_file.rxp03    #NO.TQC-AC0109
DEFINE g_posdbs     LIKE ryg_file.ryg00
DEFINE g_posdbs_t   LIKE ryg_file.ryg00
DEFINE g_db_links   LIKE ryg_file.ryg02
DEFINE g_db_links_t LIKE ryg_file.ryg02
DEFINE l_sql        STRING
    LET g_errno=''
    IF p_type = '1' THEN
    SELECT oeb04,oeb05,oeb12
      INTO l_oeb04,l_oeb05,l_oeb12
      FROM oeb_file
     WHERE oeb01 = g_rxp.rxp04
       AND oeb03 = g_rxq[l_ac].rxq03
    END IF
#NO.TQC-AC0109--add--begin
    IF p_type = '2' THEN
    SELECT ogb04,ogb05,ogb12
      INTO l_oeb04,l_oeb05,l_oeb12
      FROM ogb_file
     WHERE ogb01 = g_rxp.rxp04
       AND ogb03 = g_rxq[l_ac].rxq03
    END IF
    SELECT DISTINCT ryg00,ryg02 INTO g_posdbs_t,g_db_links_t FROM ryg_file  #未來如果有多筆傳輸DB可用FOREACH循環
        LET g_posdbs = s_dbstring(g_posdbs_t)
        LET g_db_links = p200_dblinks(g_db_links_t)
        IF p_type='P'  THEN
           #FUN-C80043 MARK begin ---
           #LET l_sql = " SELECT prod,unit,qty ",
           #            " FROM ",g_posdbs,"posdb",g_db_links," ",
           #            " WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"' "
           #FUN-C80043 MARK end ---
           #FUN-C80043 add begin --
            LET l_sql = " SELECT PLUNO,unit,qty ",
                        "   FROM ",g_posdbs,"td_sale_detail",g_db_links,
                        " ,",g_posdbs,"td_sale",g_db_links,
                        "  WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"'",
                        "    AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE IN ('0','1','2') "
           #FUN-C80043 add end ----
           PREPARE sel_posda_pre8 FROM l_sql
           EXECUTE sel_posda_pre8 INTO l_oeb04,l_oeb05,l_oeb12
        END IF
     IF p_type ='S'  THEN
           #FUN-C80043 MARK begin ---
           #     LET l_sql = " SELECT prod,unit,ordqty  ",
           #           " FROM ",g_posdbs,"posdh",g_db_links," ",
           #           " WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"'"
           #FUN-C80043 MARK end ---
           #FUN-C80043 add begin --
            LET l_sql = " SELECT PLUNO,unit,qty ",
                        "   FROM ",g_posdbs,"td_sale_detail",g_db_links,                                                 
                        " ,",g_posdbs,"td_sale",g_db_links,                                                              
                        "  WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"' AND item = '",g_rxq[l_ac].rxq03,"'",
                        "    AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE = '3' "
           #FUN-C80043 add end ----
           PREPARE sel_posda_pre9 FROM l_sql
           EXECUTE sel_posda_pre9 INTO l_oeb04,l_oeb05,l_oeb12
     END IF 
#NO.TQC-AC0109--add--end
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='atm-901'
         OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       SELECT gfe02 INTO g_rxq[l_ac].rxq06_desc 
         FROM gfe_file
        WHERE gfe01 = l_oeb05
          AND gfeacti = 'Y'
#NO.TQC-AC0109--add--begin
        SELECT ima02 INTO g_rxq[l_ac].rxq05
         FROM ima_file
        WHERE ima01 = l_oeb04
#NO.TQC-AC0109--add--end
       LET g_rxq[l_ac].rxq04 = l_oeb04
    #  LET g_rxq[l_ac].rxq05 = l_oeb06 #NO.TQC-AC0109
       LET g_rxq[l_ac].rxq06 = l_oeb05
       LET g_rxq[l_ac].rxq07 = l_oeb12
       LET g_rxq[l_ac].rxq08 = l_oeb12
       DISPLAY BY NAME g_rxq[l_ac].rxq04,g_rxq[l_ac].rxq05,
                       g_rxq[l_ac].rxq06,g_rxq[l_ac].rxq07,
                       g_rxq[l_ac].rxq08,g_rxq[l_ac].rxq06_desc
    END IF
END FUNCTION
 
FUNCTION t600_m_b()
   
   IF g_action_choice="detail" OR g_action_choice="insert" THEN
      LET l_allow_insert=cl_detail_input_auth("insert")
      LET l_allow_delete=cl_detail_input_auth("delete")
      CALL cl_set_comp_entry("rxq02,rxq03,rxq09",TRUE)
      CALL cl_set_comp_entry("rxq08",FALSE)
   ELSE
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
      CALL cl_set_comp_entry("rxq02,rxq03,rxq09",FALSE)
      CALL cl_set_comp_entry("rxq08",TRUE)
   END IF
   CALL t600_b()
END FUNCTION
 
FUNCTION t600_b_create()
DEFINE l_rxq RECORD LIKE rxq_file.*
DEFINE g_posdbs     LIKE ryg_file.ryg00
DEFINE g_posdbs_t   LIKE ryg_file.ryg00
DEFINE g_db_links   LIKE ryg_file.ryg02
DEFINE g_db_links_t LIKE ryg_file.ryg02
DEFINE l_sql        STRING
  
   LET g_success='Y' 
   IF g_rxp.rxp03=1 THEN
      DECLARE oeb_cs CURSOR FOR SELECT g_rxp00,g_rxp.rxp01,'',oeb03,oeb04,
                                       oeb06,oeb05,oeb12,oeb12,'','N',
                                       g_rxp.rxplegal,g_rxp.rxpplant
                                  FROM oeb_file
                                 WHERE oeb01 = g_rxp.rxp04
      LET g_cnt=1
      FOREACH oeb_cs INTO l_rxq.*
         IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
         END IF
         LET l_rxq.rxq02 = g_cnt
         INSERT INTO rxq_file VALUES (l_rxq.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH
   END IF
#TQC-AC0109 --add--begin
   IF g_rxp.rxp03=2 THEN
      DECLARE ogb_cs CURSOR FOR SELECT g_rxp00,g_rxp.rxp01,'',ogb03,ogb04,
                                       ogb06,ogb05,ogb12,ogb12,'','N',
                                       g_rxp.rxplegal,g_rxp.rxpplant
                                  FROM ogb_file
                                 WHERE ogb01 = g_rxp.rxp04
      LET g_cnt=1
      FOREACH ogb_cs INTO l_rxq.*
         IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
         END IF
         LET l_rxq.rxq02 = g_cnt
         INSERT INTO rxq_file VALUES (l_rxq.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH
   END IF
   SELECT DISTINCT ryg00,ryg02 INTO g_posdbs_t,g_db_links_t FROM ryg_file  #未來如果有多筆傳輸DB可用FOREACH循環
        LET g_posdbs = s_dbstring(g_posdbs_t)
        LET g_db_links = p200_dblinks(g_db_links_t)
   IF g_rxp.rxp03='P' THEN
     #FUN-C80043 MARK BEGIN ---
     #LET l_sql = " SELECT g_rxp00,g_rxp.rxp01,'',item,prod,ima02,unit,qty,qty,'','N',g_rxp.rxplegal,g_rxp.rxpplan ",
     #                 " FROM ",g_posdbs,"posdb",g_db_links,", ",
     #                 " ima_file ",
     #                 " WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND prod =ima01 "
     #FUN-C80043 MARK end ----
     #FUN-C80043 add begin ---
     LET l_sql = " SELECT '",g_rxp00,"','",g_rxp.rxp01,"','',item,PLUNO,ima02,unit,qty,qty,'','N','",g_rxp.rxplegal,"','",g_rxp.rxpplant,"'",
                       " FROM ",g_posdbs,"td_sale_detail",g_db_links,
                       " ,",g_posdbs,"td_sale",g_db_links,
                       " ,ima_file ",
                       " WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"'",
                       "   AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE IN ('0','1','2') ",
                       "   AND PLUNO = ima01 "
     #FUN-C80043 add end ----
    PREPARE sel_posdb_pre01 FROM l_sql
    DECLARE sel_posdb_cs    CURSOR FOR sel_posdb_pre01
    LET g_cnt=1           #FUN-C80043 add
    FOREACH sel_posdb_cs INTO l_rxq.*
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
         END IF
         LET l_rxq.rxq02 = g_cnt
         INSERT INTO rxq_file VALUES (l_rxq.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH
  END IF
  IF g_rxp.rxp03='S' THEN
     #FUN-C80043 MARK BEGIN ---
     #LET l_sql = " SELECT g_rxp00,g_rxp.rxp01,'',item,prod,ima02,unit,ordqty,ordqty,'','N',g_rxp.rxplegal,g_rxp.rxpplan ",
     #                 " FROM ",g_posdbs,"posdh",g_db_links,", ",
     #                 " ima_file",
     #                 " WHERE SHOP = '",g_plant,"' AND fno = '",g_rxp.rxp07,"' AND prod =ima01 "
     #FUN-C80043 MARK end ----
     #FUN-C80043 add begin ---
     LET l_sql = " SELECT '",g_rxp00,"','",g_rxp.rxp01,"','',item,PLUNO,ima02,unit,qty,qty,'','N','",g_rxp.rxplegal,"','",g_rxp.rxpplant,"'",
                       " FROM ",g_posdbs,"td_sale_detail",g_db_links,                                                    
                       " ,",g_posdbs,"td_sale",g_db_links,                                                               
                       " ,ima_file ",
                       " WHERE td_sale.SHOP = '",g_plant,"' AND td_sale.SaleNO = '",g_rxp.rxp07,"'",   
                       "   AND td_sale.SHOP = td_sale_detail.SHOP AND td_sale.SaleNO = td_sale_detail.SaleNO AND TYPE = '3' ",
                       "   AND PLUNO = ima01 "
     #FUN-C80043 add end ----
    PREPARE sel_posdh_pre01 FROM l_sql
    DECLARE sel_posdh_cs    CURSOR FOR sel_posdh_pre01
    LET g_cnt=1           #FUN-C80043 add
    FOREACH sel_posdh_cs INTO l_rxq.*
       IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
         END IF
         LET l_rxq.rxq02 = g_cnt
         INSERT INTO rxq_file VALUES (l_rxq.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH
  END IF
#TQC-AC0109 --add--end
END FUNCTION
#No.FUN-870007
#FUN-9B0034

