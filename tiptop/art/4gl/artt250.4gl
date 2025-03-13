# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt250.4gl
# Descriptions...: 調撥申請單
# Date & Author..: NO.FUN-AA0023 10/10/19 By lixia 
# Modify.........: No.TQC-AC0369 10/12/28 By lixia 取消POS相關的內容
# Modify.........: No.TQC-AC0384 10/12/29 By lixia 畫面刪除已傳POS欄位
# Modify.........: No.TQC-B10079 11/01/12 By lixia
# Modify.........: No.MOD-B20068 11/02/15 By Summer l_no改為LIKE oayslip 
# Modify.........: No.MOD-B30256 11/03/12 By lixia 產品編號管控判斷修改
# Modify.........: No.FUN-B40038 11/04/13 By huangtao 修改撥出和撥入數量抓取方式
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60012 11/06/02 By lixia 重新過單
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B90068 11/09/08 By pauline 母料號不可調撥
# Modify.........: No:FUN-BB0086 11/12/31 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20068 12/02/13 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:TQC-C90058 12/09/11 By yangxf 添加来源项次栏位
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rvq        RECORD LIKE rvq_file.*,
        g_rvq_t      RECORD LIKE rvq_file.*,
        g_rvr        DYNAMIC ARRAY OF RECORD
                     rvr02          LIKE rvr_file.rvr02,
                     rvr03          LIKE rvr_file.rvr03,          #TQC-C90058 add
                     rvr04          LIKE rvr_file.rvr04,
                     rvr04_desc     LIKE ima_file.ima02,
                     rvr06          LIKE rvr_file.rvr06,
                     rvr07          LIKE rvr_file.rvr07,
                     rvr08          LIKE rvr_file.rvr08,
                     rvr09          LIKE rvr_file.rvr09,           
                     qry_out        LIKE rup_file.rup12,
                     qry_in         LIKE rup_file.rup16,
                     rvr10          LIKE rvr_file.rvr10,
                     rvr11          LIKE rvr_file.rvr11
                     END RECORD,
        g_rvr_t      RECORD
                     rvr02          LIKE rvr_file.rvr02,
                     rvr03          LIKE rvr_file.rvr03,          #TQC-C90058 add
                     rvr04          LIKE rvr_file.rvr04,
                     rvr04_desc     LIKE ima_file.ima02,
                     rvr06          LIKE rvr_file.rvr06,
                     rvr07          LIKE rvr_file.rvr07,
                     rvr08          LIKE rvr_file.rvr08,
                     rvr09          LIKE rvr_file.rvr09,           
                     qry_out        LIKE rup_file.rup12,
                     qry_in         LIKE rup_file.rup16,
                     rvr10          LIKE rvr_file.rvr10,
                     rvr11          LIKE rvr_file.rvr11
                     END RECORD
 
DEFINE  g_sql                STRING,
        g_wc                 STRING,
        g_wc2                STRING,
        g_rec_b              LIKE type_file.num5,
        l_ac                 LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_chr1               LIKE type_file.chr1
DEFINE  g_chr2               LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  g_no_ask             LIKE type_file.num5
DEFINE  g_flag               LIKE type_file.chr1
DEFINE  g_total_count        LIKE type_file.num5
DEFINE  g_current_count      LIKE type_file.num5
DEFINE  g_errnomsg           STRING
DEFINE  g_rtz04              LIKE rtz_file.rtz04   #
DEFINE  g_rvr06_t            LIKE rvr_file.rvr06

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
       
   LET g_forupd_sql="SELECT * FROM rvq_file WHERE rvq01 = ? AND rvqplant = ? AND rvq00 = '1' FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t250_cl    CURSOR FROM g_forupd_sql
    
   OPEN WINDOW t250_w WITH FORM "art/42f/artt250" ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('rvq14,rvq15,rvq99,rvq904,rvr10,rvr11',FALSE)
   #CALL cl_set_comp_visible('rvq02,rvqpos',FALSE)  #TQC-AC0369
   CALL cl_set_comp_visible('rvq02',FALSE)  #TQC-AC0384
   CALL cl_set_comp_visible('rvr03',FALSE)  #TQC-C90058 add
   CALL t250_menu()
   CLOSE WINDOW t250_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t250_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF 
   LET g_action_choice = '' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rvr TO s_rvr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    
      ON ACTION confirm
         LET g_action_choice="confirm"   #確認
         EXIT DISPLAY
      ON ACTION approve
         LET g_action_choice="approve"  #核准
         EXIT DISPLAY          
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION Allocate_condition
         LET g_action_choice="Allocate_condition" #調撥状况
         EXIT DISPLAY          
      ON ACTION related_document
         LET g_action_choice="related_document"
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
         CALL t250_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL t250_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t250_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL t250_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t250_fetch('L')
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
 
FUNCTION t250_menu() 
   WHILE TRUE
      CALL t250_bp("G")
      CASE g_action_choice
         WHEN "confirm"          #審核
           IF cl_chk_act_auth() THEN
              CALL t250_y()
           END IF
         WHEN "approve"          #核准
           IF cl_chk_act_auth() THEN
              CALL t250_c()
           END IF
         WHEN "Allocate_condition"   #調撥状况
           IF cl_chk_act_auth() THEN
                  CALL t250_con()
           END IF
         WHEN "related_document"   
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rvq.rvq01) THEN
                 LET g_doc.column1 = "rvq01"
                 LET g_doc.value1 = g_rvq.rvq01
                 CALL cl_doc()
              END IF
           END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t250_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t250_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t250_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t250_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t250_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t250_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t250_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t250_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvr),'','')
             END IF   
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t250_v()
            END IF
         #CHI-C80041---end     
      END CASE
   END WHILE
END FUNCTION

FUNCTION t250_cs()
   DEFINE  lc_qbe_sn   LIKE  gbm_file.gbm01 
   CLEAR FORM
   CALL g_rvr.clear()
   #CONSTRUCT BY NAME g_wc ON  rvq01,rvq02,rvq03,rvq04,rvq07,rvq08,rvq05,rvq06,rvqconf,
   #                           rvqpos,rvqplant,rvq09,rvquser,rvqgrup,rvqmodu,rvqdate,
   CONSTRUCT BY NAME g_wc ON  rvq01,rvq03,rvq04,rvq07,rvq08,rvq05,rvq06,rvqconf, #TQC-AC0369
                              rvqplant,rvq09,rvquser,rvqgrup,rvqmodu,rvqdate,    #TQC-AC0369
                              rvqoriu,rvqorig,rvqcrat,rvqacti,rvq11,rvq10,rvq10t,
                              rvq13,rvq12,rvq12t 
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
              
   ON ACTION controlp
      CASE
         WHEN INFIELD(rvq01) #申請單號
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1 = "1" 
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq01
            NEXT FIELD rvq01
         WHEN INFIELD(rvq04) #申請人員    
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq04
            NEXT FIELD rvq04
         WHEN INFIELD(rvq07) #撥出營運中心
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq07
            NEXT FIELD rvq07
         WHEN INFIELD(rvq08) #撥入營運中心
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq08
            NEXT FIELD rvq08
        WHEN INFIELD(rvq05)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq05"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq05
            NEXT FIELD rvq05
         WHEN INFIELD(rvq06)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq06"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq06
            NEXT FIELD rvq06
        WHEN INFIELD(rvqplant)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvqplant
            NEXT FIELD rvqplant            
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
    IF INT_FLAG THEN RETURN END IF
    
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvquser', 'rvqgrup')
    
    CONSTRUCT g_wc2 ON rvr02,rvr03,rvr04,rvr06,rvr07,rvr08,rvr09                             #TQC-C90058 add rvr03 
                    FROM s_rvr[1].rvr02,s_rvr[1].rvr03,s_rvr[1].rvr04,s_rvr[1].rvr06,        #TQC-C90058 add rvr03
                         s_rvr[1].rvr07,s_rvr[1].rvr08,s_rvr[1].rvr09
    BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
            
    ON ACTION controlp
       CASE
          WHEN INFIELD(rvr04)
             CALL q_sel_ima(TRUE, "q_ima01_1","","","","","","","",'')  RETURNING  g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO rvr04
             NEXT FIELD rvr04
          WHEN INFIELD(rvr06)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gfe"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO rvr06
             NEXT FIELD rvr06
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
    IF g_wc2 = " 1=1" THEN        
       LET g_sql = "SELECT DISTINCT rvq01,rvqplant FROM rvq_file ", 
                   " WHERE ",g_wc CLIPPED,
                   "   AND rvq00 = '1' ",
                   " ORDER BY rvq01"
    ELSE                                 
       LET g_sql = "SELECT UNIQUE rvq_file.rvq01,rvq_file.rvqplant",
                   " FROM rvq_file,rvr_file",
                   " WHERE rvq01 = rvr01 ",
                   "   AND rvq00 = '1' ",
                   "   AND rvr00 = '1' ",
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY rvq01"
    END IF    
    PREPARE t250_prepare FROM g_sql
    DECLARE t250_cs SCROLL CURSOR WITH HOLD FOR t250_prepare
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM rvq_file WHERE ",g_wc CLIPPED,
                 "   AND rvq00 = '1' "
    ELSE
       LET g_sql="SELECT COUNT(*) FROM ",
                 "(SELECT DISTINCT rvq_file.rvq01 ",
                 "   FROM rvq_file,rvr_file ",
                 "  WHERE rvq01 = rvr01 ",
                 "   AND rvq00 = '1' ",
                 "   AND rvr00 = '1' ",
                 "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,")"
    END IF 
    PREPARE t250_precount FROM g_sql
    DECLARE t250_count CURSOR FOR t250_precount
END FUNCTION
 
FUNCTION t250_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rvr.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt    
    CALL t250_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_rvr.clear()
       RETURN
    END IF
    OPEN t250_cs 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_rvr.clear()
    ELSE
       OPEN t250_count
       FETCH t250_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt                                 
          CALL t250_fetch('F') 
       ELSE 
          CALL cl_err('',100,0)
       END IF             
    END IF
END FUNCTION
 
FUNCTION t250_fetch(p_flrvq)
DEFINE p_flrvq         LIKE type_file.chr1           
    CASE p_flrvq
        WHEN 'N' FETCH NEXT     t250_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN 'P' FETCH PREVIOUS t250_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN 'F' FETCH FIRST    t250_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN 'L' FETCH LAST     t250_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN '/'
           IF (NOT g_no_ask) THEN                   
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
            FETCH ABSOLUTE g_jump t250_cs INTO g_rvq.rvq01,g_rvq.rvqplant
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
        INITIALIZE g_rvq.* TO NULL  
        RETURN
    ELSE
      CASE p_flrvq
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rvq.* FROM rvq_file    
     WHERE rvq01 = g_rvq.rvq01
       AND rvqplant = g_rvq.rvqplant
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rvq_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rvq.rvquser           
        LET g_data_group=g_rvq.rvqgrup
        LET g_data_plant=g_rvq.rvqplant 
        CALL t250_show()                   
    END IF
END FUNCTION
 
FUNCTION t250_show()
    DEFINE  l_gen02   LIKE gen_file.gen02 
    DEFINE  l_azp02   LIKE azp_file.azp02
    DEFINE  l_azp02_1 LIKE azp_file.azp02
    DEFINE  l_azp02_2 LIKE azp_file.azp02
    DEFINE  l_azp02_3 LIKE azp_file.azp02
    LET g_rvq_t.* = g_rvq.*
    #DISPLAY BY NAME g_rvq.rvq01,g_rvq.rvq02,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07,
    #                g_rvq.rvq08,g_rvq.rvq05,g_rvq.rvq06,g_rvq.rvqconf,g_rvq.rvqpos,
    DISPLAY BY NAME g_rvq.rvq01,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07,  #TQC-AC0369
                    g_rvq.rvq08,g_rvq.rvq05,g_rvq.rvq06,g_rvq.rvqconf,#TQC-AC0369
                    g_rvq.rvqplant,g_rvq.rvq09,g_rvq.rvquser,g_rvq.rvqgrup,g_rvq.rvqmodu,
                    g_rvq.rvqdate,g_rvq.rvqoriu,g_rvq.rvqorig,g_rvq.rvqcrat,g_rvq.rvqacti,
                    g_rvq.rvq11,g_rvq.rvq10,g_rvq.rvq10t,g_rvq.rvq13,g_rvq.rvq12,g_rvq.rvq12t 
                    
    CALL t250_rvq04('d')
    CALL t250_rvq05('d')
    CALL t250_rvq07('d')
    CALL t250_rvq08('d')
                                                                      
    CALL t250_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t250_b_fill(p_wc2)              
    DEFINE   p_wc2       STRING
    DEFINE   l_sql       STRING
    DEFINE   l_ruo03     LIKE ruo_file.ruo03    #FUN-B40038 add

    LET g_sql = "SELECT rvr02,rvr03,rvr04,'',rvr06,rvr07,rvr08,rvr09,'','','','' ",            #TQC-C90058 add rvr03
                "  FROM rvr_file ",
                " WHERE rvr01 = '",g_rvq.rvq01,"'",
                "   AND rvr00 = '1' ",
                "   AND rvrplant = '",g_rvq.rvqplant,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql =g_sql CLIPPED,' ORDER BY rvr02'
    PREPARE t250_pb FROM g_sql
    DECLARE rvr_cs1 CURSOR FOR t250_pb 
    CALL g_rvr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"

#FUN-B40038 -------------------STA
     IF g_rvq.rvqplant = g_rvq.rvq07 THEN
        LET l_ruo03 = g_rvq.rvq01
     ELSE
        IF g_rvq.rvq05 <> g_rvq.rvq07 THEN
           IF g_rvq.rvq05 = g_rvq.rvqplant THEN
              LET l_sql = "SELECT rvq01 FROM ",cl_get_target_table(g_rvq.rvq07,'rvq_file'),
                          " WHERE rvqplant = '",g_rvq.rvq07,"'",
                          "   AND rvq06 = '",g_rvq.rvq01,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvq.rvq07) RETURNING l_sql
               PREPARE pre_ruo03_2 FROM l_sql
               EXECUTE pre_ruo03_2 INTO l_ruo03
           ELSE
              LET l_sql = "SELECT rvq01 FROM ",cl_get_target_table(g_rvq.rvq07,'rvq_file'),
                          " WHERE rvqplant = '",g_rvq.rvq07,"'",
                          "   AND rvq06 = '",g_rvq.rvq06,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,g_rvq.rvq07) RETURNING l_sql
               PREPARE pre_ruo03_3 FROM l_sql
               EXECUTE pre_ruo03_3 INTO l_ruo03               
           END IF
         ELSE
            LET l_ruo03 = g_rvq.rvq06
         END IF   
     END IF
#FUN-B40038 -------------------END 

    FOREACH rvr_cs1 INTO g_rvr[g_cnt].*  
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH
       END IF
       IF g_rvq.rvqconf = 3 THEN      #撥入撥出量
   
          LET l_sql = "SELECT rup12,rup16 ", #在撥出營運中心查找
                      "  FROM ",cl_get_target_table(g_rvq.rvq07,'rup_file'),",",
                                cl_get_target_table(g_rvq.rvq07,'ruo_file'),
                      #" WHERE ruo02='5'  AND ruoconf='1'  AND ruo01=rup01  AND ruoplant=rupplant ",																																																																																																																																																																																																																																																															
                      " WHERE ruo02='5'  AND ruoconf<>'0'  AND ruo01=rup01  AND ruoplant=rupplant ",
                      #"   AND ruo03 = '",g_rvq.rvq01,"'",	#FUN-B40038 mark																																																																																																																																																																																																																																																							
                      "   AND ruo03 = '",l_ruo03,"'",           #lx
                      "   AND rup02 = '",g_rvr[g_cnt].rvr02,"'",																																																																																																																																																																																																																																																														
                      "   AND rupplant = '",g_rvq.rvq07,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
          CALL cl_parse_qry_sql(l_sql, g_rvq.rvq07) RETURNING l_sql
          PREPARE pre_rvp FROM l_sql
          EXECUTE pre_rvp INTO g_rvr[g_cnt].qry_out,g_rvr[g_cnt].qry_in
          IF SQLCA.sqlcode  AND SQLCA.sqlcode <> '100' THEN
             CALL cl_err(g_rvr[g_cnt].rvr02,SQLCA.sqlcode,0)
          END IF          
       ELSE
          LET g_rvr[g_cnt].qry_out = 0
          LET g_rvr[g_cnt].qry_in = 0
       END IF   
       SELECT ima02 INTO g_rvr[g_cnt].rvr04_desc
         FROM ima_file
        WHERE ima01 = g_rvr[g_cnt].rvr04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH 
    CALL g_rvr.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION 

FUNCTION t250_a()
   DEFINE  li_result  LIKE type_file.num5
   DEFINE  l_gen02    LIKE gen_file.gen02 
   DEFINE  l_azp02    LIKE azp_file.azp02
   DEFINE  l_azp02_1  LIKE azp_file.azp02
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rvr.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF   
 
   INITIALIZE g_rvq.* LIKE rvq_file.*                  
   LET g_rvq_t.* = g_rvq.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rvq.rvq00 = '1'
      LET g_rvq.rvq02 = '1'        #來源類型
      LET g_rvq.rvq03 = g_today    #申請日期
      LET g_rvq.rvq04 = g_user     #申請人員
      LET g_rvq.rvq05 = g_plant    #申請營運中心
      LET g_rvq.rvqconf = '0'      #審核碼
      LET g_rvq.rvqpos = 'Y'       #已傳POS
      LET g_rvq.rvqplant = g_plant #所屬營運中心
            
      LET g_rvq.rvqacti  ='Y'
      LET g_rvq.rvqoriu = g_user     
      LET g_rvq.rvqorig = g_grup 
      LET g_rvq.rvquser  = g_user
      LET g_rvq.rvqgrup  = g_grup
      LET g_rvq.rvqcrat  = g_today
      LET g_rvq.rvqlegal = g_legal
      LET g_data_plant   = g_plant

      CALL t250_rvq04('d')
      CALL t250_rvq05('d')
      
      CALL t250_i("a")                          
      IF INT_FLAG THEN                          
         INITIALIZE g_rvq.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rvq.rvq01) THEN       
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      CALL s_auto_assign_no("art",g_rvq.rvq01,g_today,"C4","rvq_file","rvq01,rvqplant","","","") 
      RETURNING li_result,g_rvq.rvq01 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rvq.rvq01
      INSERT INTO rvq_file VALUES (g_rvq.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                     
         CALL cl_err3("ins","rvq_file",g_rvq.rvq01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF 
      LET g_rvq_t.* = g_rvq.*
      CALL g_rvr.clear()
 
      LET g_rec_b = 0  
      CALL t250_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t250_i(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,                
          l_n        LIKE type_file.num5           
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_msg      STRING

   #DISPLAY BY NAME g_rvq.rvq01,g_rvq.rvq02,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07,
   #                g_rvq.rvq08,g_rvq.rvq05,g_rvq.rvq06,g_rvq.rvqconf,g_rvq.rvqpos,
   DISPLAY BY NAME g_rvq.rvq01,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07,    #TQC-AC0369
                   g_rvq.rvq08,g_rvq.rvq05,g_rvq.rvq06,g_rvq.rvqconf,  #TQC-AC0369
                   g_rvq.rvqplant,g_rvq.rvq09,g_rvq.rvquser,g_rvq.rvqgrup,g_rvq.rvqmodu,
                   g_rvq.rvqdate,g_rvq.rvqoriu,g_rvq.rvqorig,g_rvq.rvqcrat,g_rvq.rvqacti,
                   g_rvq.rvq11,g_rvq.rvq10,g_rvq.rvq10t,g_rvq.rvq13,g_rvq.rvq12,g_rvq.rvq12t 
                   
   CALL cl_set_head_visible("","YES")
   
   #INPUT BY NAME  g_rvq.rvq01,g_rvq.rvq02,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07,
   INPUT BY NAME  g_rvq.rvq01,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07, #TQC-AC0369
                  g_rvq.rvq08,g_rvq.rvq09
   WITHOUT DEFAULTS
 
   BEFORE INPUT
      LET g_before_input_done = FALSE
      CALL t250_set_entry(p_cmd)
      CALL t250_set_no_entry(p_cmd)
      LET g_before_input_done = TRUE
      CALL cl_set_docno_format("rvq01") 

      AFTER FIELD rvq01  #申請單號
         IF NOT cl_null(g_rvq.rvq01) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_rvq.rvq01 <> g_rvq_t.rvq01) THEN     
               CALL s_check_no("art",g_rvq.rvq01,g_rvq_t.rvq01,"C4","rvq_file","rvq01,rvqplant","")  
                    RETURNING li_result,g_rvq.rvq01
                 IF (NOT li_result) THEN                                                            
                    LET g_rvq.rvq01=g_rvq_t.rvq01                                                                
                    NEXT FIELD rvq01                                                                                     
                 END IF
            END IF
         END IF

      AFTER FIELD rvq04  #申請人員
         IF NOT cl_null(g_rvq.rvq04) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rvq.rvq04 != g_rvq_t.rvq04) THEN
               CALL t250_rvq04('a')                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                        
                  CALL cl_err('',g_errno,0)                                                                                         
                  NEXT FIELD rvq04                                                                                                  
               END IF
            END IF
         END IF         
         
      AFTER FIELD rvq07  #撥出營運中心
         IF NOT cl_null(g_rvq.rvq07) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rvq.rvq07 != g_rvq_t.rvq07) THEN
               CALL t250_rvq07('a')                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                        
                  CALL cl_err('',g_errno,0)                                                                                         
                  NEXT FIELD rvq07                                                                                                  
               END IF
            END IF
            IF p_cmd='u' AND g_rvq.rvq07 != g_rvq_t.rvq07 THEN
               BEGIN WORK
               CALL t250_chkrvr04(g_rvq.rvq01,g_rvq.rvqplant,'2') RETURNING l_msg
               IF NOT cl_null(l_msg) THEN   
                  IF cl_confirm('art-967') THEN
                     COMMIT WORK       
                  ELSE  
                     ROLLBACK WORK
                     LET g_rvq.rvq07 = g_rvq_t.rvq07
                     NEXT FIELD rvq07  
                  END IF                 
               END IF  
            END IF      
         END IF       
       
      AFTER FIELD rvq08  #撥入營運中心
         IF NOT cl_null(g_rvq.rvq08) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rvq.rvq08 != g_rvq_t.rvq08) THEN
               CALL t250_rvq08('a')                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                        
                  CALL cl_err('',g_errno,0)                                                                                         
                  NEXT FIELD rvq08                                                                                                  
               END IF
            END IF
            IF p_cmd='u' AND g_rvq.rvq08 != g_rvq_t.rvq08 THEN
               BEGIN WORK
               CALL t250_chkrvr04(g_rvq.rvq01,g_rvq.rvqplant,'2') RETURNING l_msg
               IF NOT cl_null(l_msg) THEN
                  IF cl_confirm('art-967') THEN
                     COMMIT WORK    
                  ELSE
                     ROLLBACK WORK
                     LET g_rvq.rvq08 = g_rvq_t.rvq08
                     NEXT FIELD rvq08
                  END IF                
               END IF
            END IF   
         END IF       

      AFTER INPUT 
         LET g_rvq.rvquser = s_get_data_owner("rvq_file") #FUN-C10039
         LET g_rvq.rvqgrup = s_get_data_group("rvq_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_rvq.rvq07 <> g_plant AND g_rvq.rvq08 <> g_plant THEN
            SELECT COUNT(*) INTO l_n FROM  azw_file WHERE azw07 = g_plant 
               AND (azw01 = g_rvq.rvq07 OR azw01 = g_rvq.rvq08)
            IF l_n = '0' THEN
               CALL cl_err('','art-968',1)
               NEXT FIELD rvq07
            END IF
         END IF

      ON ACTION controlp
        CASE
          WHEN INFIELD(rvq01)
            LET g_rvq.rvq01=s_get_doc_no(g_rvq.rvq01)
            CALL q_oay(FALSE,FALSE,g_rvq.rvq01,'C4','art') RETURNING g_rvq.rvq01  
            DISPLAY BY NAME g_rvq.rvq01
            NEXT FIELD rvq01                     
         WHEN INFIELD(rvq04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            CALL cl_create_qry() RETURNING g_rvq.rvq04
            DISPLAY BY NAME g_rvq.rvq04
            CALL t250_rvq04('d')
            NEXT FIELD rvq04
         WHEN INFIELD(rvq07)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            CALL cl_create_qry() RETURNING g_rvq.rvq07
            DISPLAY BY NAME g_rvq.rvq07
            CALL t250_rvq07('d')
            NEXT FIELD rvq07
         WHEN INFIELD(rvq08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            CALL cl_create_qry() RETURNING g_rvq.rvq08
            DISPLAY BY NAME g_rvq.rvq08
            CALL t250_rvq08('d')
            NEXT FIELD rvq08 
        OTHERWISE
            EXIT CASE
     END CASE
 
     ON ACTION CONTROLZ
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

FUNCTION t250_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rvq01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t250_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rvq01",FALSE)
   END IF 
END FUNCTION

FUNCTION t250_b()
DEFINE l_ac_t          LIKE type_file.num5,
       l_n             LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5,
       li_reslut       LIKE type_file.num5,
       l_azw07         LIKE azw_file.azw07
DEFINE l_ima151        LIKE type_file.chr1   #FUN-B90068 add
DEFINE l_case          STRING   #No.FUN-BB0086
 
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rvq.rvq01) THEN
           RETURN 
        END IF 
        
        SELECT * INTO g_rvq.* FROM rvq_file
           WHERE rvq01 = g_rvq.rvq01
             AND rvqplant = g_rvq.rvqplant
#        SELECT azw07 INTO l_azw07 FROM azw_file
#         WHERE azw01 = g_rvq.rvq07
#        IF cl_null(l_azw07) THEN
#           LET l_azw07 = g_rvq.rvq07
#        END IF
        CALL t250_getazw07(g_rvq.rvq07,g_rvq.rvq08) RETURNING l_azw07 #獲取撥入撥出的上級營運中心#TQC-B10079
        IF g_rvq.rvqconf ='X' THEN RETURN END IF  #CHI-C80041
        IF g_rvq.rvqconf ='1' AND l_azw07 <> g_plant THEN    
           CALL cl_err(g_rvq.rvq01,'art-955',0)
           RETURN
        END IF
        IF g_rvq.rvqconf ='2' THEN    
           CALL cl_err(g_rvq.rvq01,'mfg3168',0)
           RETURN
        END IF        
        IF g_rvq.rvqconf ='3' THEN    
           CALL cl_err(g_rvq.rvq01,'9004',0)
           RETURN
        END IF                
        IF g_rvq.rvqacti = 'N' THEN 
           CALL cl_err(g_rvq.rvq01,'mfg1000',0)
           RETURN 
        END IF
        MESSAGE ""
        CALL cl_opmsg('b')        
        LET g_forupd_sql = "SELECT rvr02,rvr03,rvr04,'',rvr06,rvr07,rvr08,rvr09,'','','','' ",            #TQC-C90058 add rvr03
                           " FROM rvr_file",
                           " WHERE rvr01 = ? ",
                           "   AND rvr02 = ? ",
                           "   AND rvrplant = ? ",
                           "   AND rvr00 = '1' ",
                           " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t250_bcl CURSOR FROM g_forupd_sql
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        IF g_rvq.rvqconf =  '1' THEN
           LET l_allow_insert=FALSE
           LET l_allow_delete=FALSE
        END IF
        INPUT ARRAY g_rvr WITHOUT DEFAULTS FROM s_rvr.*
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
                OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant
                IF STATUS THEN
                   CALL cl_err("OPEN t250_cl:",STATUS,1)
                   CLOSE t250_cl
                   ROLLBACK WORK
                END IF
                
                FETCH t250_cl INTO g_rvq.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
                   CLOSE t250_cl
                   ROLLBACK WORK 
                   RETURN
                END IF
                IF g_rec_b >= l_ac THEN 
                   LET p_cmd ='u'
                   LET g_rvr_t.*=g_rvr[l_ac].*
                   LET g_rvr06_t = g_rvr[l_ac].rvr06   #No.FUN-BB0086
                   OPEN t250_bcl USING g_rvq.rvq01,g_rvr_t.rvr02,g_rvq.rvqplant
                   IF STATUS THEN
                      CALL cl_err("OPEN t250_bcl:",STATUS,1)
                      LET l_lock_sw='Y'
                   ELSE
                      FETCH t250_bcl INTO g_rvr[l_ac].*
                      IF SQLCA.sqlcode THEN
                         CALL cl_err(g_rvr_t.rvr02,SQLCA.sqlcode,1)
                         LET l_lock_sw="Y"
                      END IF
                      SELECT ima02 INTO g_rvr[l_ac].rvr04_desc
                        FROM ima_file
                       WHERE ima01 = g_rvr[l_ac].rvr04
                   END IF
                   CALL t250_set_entry_b(p_cmd)
                   CALL t250_set_no_entry_b(p_cmd)                   
                END IF
            BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rvr[l_ac].* TO NULL
                LET g_rvr06_t = NULL   #No.FUN-BB0086
                LET g_rvr_t.*=g_rvr[l_ac].*
                CALL cl_show_fld_cont()
                CALL t250_set_entry_b(p_cmd)
                CALL t250_set_no_entry_b(p_cmd)
                NEXT FIELD rvr02
                
            AFTER INSERT
                IF INT_FLAG THEN
                   CALL cl_err('',9001,0)
                   LET INT_FLAG=0
                   CANCEL INSERT
                END IF
                INSERT INTO rvr_file(rvr00,rvr01,rvr02,rvr04,rvr06,rvr07,rvr08,rvr09,rvrlegal,rvrplant)
                VALUES('1',g_rvq.rvq01,g_rvr[l_ac].rvr02,g_rvr[l_ac].rvr04,g_rvr[l_ac].rvr06,
                       g_rvr[l_ac].rvr07,g_rvr[l_ac].rvr08,g_rvr[l_ac].rvr09,g_rvq.rvqlegal,g_rvq.rvqplant)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","rvr_file",g_rvq.rvq01,g_rvr[l_ac].rvr02,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
          BEFORE FIELD rvr02     #項次
              IF cl_null(g_rvr[l_ac].rvr02) OR g_rvr[l_ac].rvr02 = 0 THEN 
                 SELECT MAX(rvr02)+1 INTO g_rvr[l_ac].rvr02 
                   FROM rvr_file
                  WHERE rvr01 = g_rvq.rvq01
                    AND rvrplant = g_rvq.rvqplant
                 IF g_rvr[l_ac].rvr02 IS NULL THEN
                    LET g_rvr[l_ac].rvr02=1
                 END IF
              END IF
              
          AFTER FIELD rvr02
             IF NOT cl_null(g_rvr[l_ac].rvr02) THEN 
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                   g_rvr[l_ac].rvr02 <> g_rvr_t.rvr02) THEN
                   SELECT COUNT(*) INTO l_n FROM rvr_file
                    WHERE rvr01 = g_rvq.rvq01 
                      AND rvr02 = g_rvr[l_ac].rvr02
                      AND rvrplant = g_rvq.rvqplant
                   IF l_n>0 THEN
                      CALL cl_err('',-239,0)
                      LET g_rvr[l_ac].rvr02=g_rvr_t.rvr02
                      NEXT FIELD rvr02
                   END IF
                END IF
             END IF
             
          AFTER FIELD rvr04  #產品編號
             IF NOT cl_null(g_rvr[l_ac].rvr04) THEN
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                   g_rvr[l_ac].rvr04 <> g_rvr_t.rvr04) THEN
                   CALL t250_rvr04('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rvr[l_ac].rvr04,g_errno,0)
                      NEXT FIELD rvr04
                   END IF
                   SELECT COUNT(*) INTO l_n FROM rvr_file 
                    WHERE rvr01 = g_rvq.rvq01
                      AND rvr04 = g_rvr[l_ac].rvr04
                      AND rvrplant = g_rvq.rvqplant
                   IF l_n IS NULL THEN LET l_n = 0 END IF 
                   IF l_n >0 THEN
                      CALL cl_err(g_rvr[l_ac].rvr04,'art-573',0)
                      NEXT FIELD rvr04
                   END IF
                   CALL s_showmsg_init()
                   CALL t250_check_rvr04(g_rvr[l_ac].rvr04)
                   IF NOT cl_null(g_errnomsg) THEN
                      CALL s_showmsg()
                      NEXT FIELD rvr04
                   END IF
                   CALL t250_check_rvr04_1(g_rvr[l_ac].rvr04)  
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rvr[l_ac].rvr04,g_errno,0)
                      NEXT FIELD rvr04
                   END IF
                   CALL t250_check_rvr06()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rvr[l_ac].rvr06,g_errno,0)
                      LET g_rvr[l_ac].rvr06 = g_rvr_t.rvr06
                      DISPLAY BY NAME g_rvr[l_ac].rvr06
                      NEXT FIELD rvr06
                   END IF      
                END IF
              #FUN-B90068 add START
                   SELECT ima151 INTO l_ima151 FROM ima_file where ima01 = g_rvr[l_ac].rvr04
                   IF l_ima151 = 'Y' THEN
                      CALL cl_err('','art-865',0)
                      NEXT FIELD rvr04
                   END IF
              #FUN-B90068 add END
             END IF

          AFTER FIELD rvr06 #單位
             LET l_case = ""   #No.FUN-BB0086
             IF NOT cl_null(g_rvr[l_ac].rvr06) THEN
                IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                   g_rvr[l_ac].rvr06 <> g_rvr_t.rvr06) THEN                   
                   CALL t250_check_rvr06()
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rvr[l_ac].rvr06,g_errno,0)
                      LET g_rvr[l_ac].rvr06 = g_rvr_t.rvr06
                      DISPLAY BY NAME g_rvr[l_ac].rvr06
                      NEXT FIELD rvr06
                   END IF   
                END IF
                #No.FUN-BB0086--add--begin--
                IF g_rvq.rvqconf = '1' THEN
                   IF NOT t250_rvr09_check() THEN 
                      LET l_case = "rvr09"
                   END IF 
                ELSE 
                   LET g_rvr[l_ac].rvr09 = s_digqty(g_rvr[l_ac].rvr09,g_rvr[l_ac].rvr06)
                   DISPLAY BY NAME g_rvr[l_ac].rvr09
                END IF 
                IF NOT cl_null(g_rvr[l_ac].rvr08) AND g_rvr[l_ac].rvr08<>0 THEN #FUN-C20068
                   IF NOT t250_rvr08_check() THEN 
                      LET l_case = "rvr08"
                   END IF                            
                END IF                                                          #FUN-C20068
                LET g_rvr06_t = g_rvr[l_ac].rvr06
                CASE l_case
                   WHEN "rvr08" NEXT FIELD rvr08
                   WHEN "rvr09" NEXT FIELD rvr09
                   OTHERWISE EXIT CASE 
                END CASE 
                #No.FUN-BB0086--add--end--
             END IF  

          AFTER FIELD rvr08
             IF NOT t250_rvr08_check() THEN NEXT FIELD rvr08 END IF   #No.FUN-BB0086
             #No.FUN-BB0086--mark--begin--
             #IF NOT cl_null(g_rvr[l_ac].rvr08) THEN
             #   IF g_rvr[l_ac].rvr08 <= 0 THEN
             #      CALL cl_err('','axr-034',0)
             #      NEXT FIELD rvr08
             #   END IF
             #END IF
             #No.FUN-BB0086--mark--end--
             
          ON CHANGE rvr08 #新增時核准數量=申請數量
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rvq.rvqconf = '0'
                AND g_rvr[l_ac].rvr08 <> g_rvr_t.rvr08)THEN                   
                LET g_rvr[l_ac].rvr09 = g_rvr[l_ac].rvr08
                DISPLAY BY NAME g_rvr[l_ac].rvr09                             
             END IF   

         AFTER FIELD rvr09
            IF NOT t250_rvr09_check() THEN NEXT FIELD rvr09 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            # IF NOT cl_null(g_rvr[l_ac].rvr09) THEN
            #    IF g_rvr[l_ac].rvr09 < 0 THEN
            #       CALL cl_err('','art-565',0)
            #       NEXT FIELD rvr09
            #    END IF
            #    #核准數量不能大于申請數量
            #    IF g_rvr[l_ac].rvr09 IS NOT NULL THEN
            #       IF g_rvr[l_ac].rvr09 > g_rvr[l_ac].rvr08 THEN
            #          CALL cl_err('','art-575',0)
            #          NEXT FIELD rvr09
            #       END IF
            #    END IF
            # END IF
            #No.FUN-BB0086--mark--end--
             
          BEFORE DELETE                      
             IF g_rvr_t.rvr02 > 0 AND NOT cl_null(g_rvr_t.rvr02) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rvr_file
                 WHERE rvr01 = g_rvq.rvq01
                   AND rvr02 = g_rvr_t.rvr02
                   AND rvrplant = g_rvq.rvqplant
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rvr_file",g_rvq.rvq01,g_rvr_t.rvr02,SQLCA.sqlcode,"","",1)  
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
              LET g_rvr[l_ac].* = g_rvr_t.*
              CLOSE t250_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CALL t250_set_entry_b(p_cmd)
           CALL t250_set_no_entry_b(p_cmd)
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvr[l_ac].rvr02,-263,1)
              LET g_rvr[l_ac].* = g_rvr_t.*
           ELSE
             
              UPDATE rvr_file SET rvr02 = g_rvr[l_ac].rvr02,
                                  rvr04 = g_rvr[l_ac].rvr04,
                                  rvr06 = g_rvr[l_ac].rvr06,
                                  rvr07 = g_rvr[l_ac].rvr07,
                                  rvr08 = g_rvr[l_ac].rvr08,
                                  rvr09 = g_rvr[l_ac].rvr09
                 WHERE rvr01 = g_rvq.rvq01 
                   AND rvr02 = g_rvr_t.rvr02
                   AND rvrplant = g_rvq.rvqplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rvr_file",g_rvq.rvq01,g_rvr_t.rvr02,SQLCA.sqlcode,"","",1) 
                 LET g_rvr[l_ac].* = g_rvr_t.*
              ELSE
                 LET g_rvq.rvqmodu = g_user
                 LET g_rvq.rvqdate = g_today
                 UPDATE rvq_file 
                    SET rvqmodu = g_rvq.rvqmodu,
                        rvqdate = g_rvq.rvqdate
                  WHERE rvq01 = g_rvq.rvq01
                    AND rvqplant = g_rvq.rvqplant
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rvq_file",g_rvq.rvq01,"",SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_rvq.rvqmodu,g_rvq.rvqdate
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac         #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvr[l_ac].* = g_rvr_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rvr.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t250_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF           
           LET l_ac_t = l_ac         #FUN-D30033 add
           CLOSE t250_bcl
           COMMIT WORK
           
        ON ACTION CONTROLO                        
           IF INFIELD(rvr02) AND l_ac > 1 THEN
              LET g_rvr[l_ac].* = g_rvr[l_ac-1].*
              LET g_rvr[l_ac].rvr02 = g_rec_b + 1
              NEXT FIELD rvr02
           END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()   
             
         ON ACTION controlp                         
          CASE
            WHEN INFIELD(rvr04)
               #CALL q_sel_ima(FALSE, "q_ima01_1","",g_rvr[l_ac].rvr04,"","","","","",'' )
               CALL q_sel_ima(FALSE, "q_ima01_1","",g_rvr[l_ac].rvr04,"","","","","",g_rvq.rvq07)#MOD-B30256
                 RETURNING g_rvr[l_ac].rvr04
               DISPLAY BY NAME g_rvr[l_ac].rvr04
               CALL t250_rvr04('d')
               NEXT FIELD rvr04
          
            WHEN INFIELD(rvr06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_rvr[l_ac].rvr06
               CALL cl_create_qry() RETURNING g_rvr[l_ac].rvr06
               DISPLAY BY NAME g_rvr[l_ac].rvr06
               NEXT FIELD rvr06            
            OTHERWISE 
               EXIT CASE
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
  
    CLOSE t250_bcl
    COMMIT WORK
#   CALL t250_delall() #CHI-C30002 mark
    CALL t250_delHeader()     #CHI-C30002 add
    CALL t250_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION t250_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rvq.rvq01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rvq_file ",
                  "  WHERE rvq01 LIKE '",l_slip,"%' ",
                  "    AND rvq01 > '",g_rvq.rvq01,"'"
      PREPARE t250_pb1 FROM l_sql 
      EXECUTE t250_pb1 INTO l_cnt       
      
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
         CALL t250_v()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rvq_file WHERE rvq01 = g_rvq.rvq01 AND rvqplant = g_rvq.rvqplant
         INITIALIZE g_rvq.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t250_delall()
#  DEFINE l_cnt LIKE type_file.num5

#  SELECT COUNT(*) INTO l_cnt 
#    FROM rvr_file
#   WHERE rvr01 = g_rvq.rvq01
#     AND rvrplant = g_rvq.rvqplant
#
#  IF l_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rvq_file WHERE rvq01 = g_rvq.rvq01 AND rvqplant = g_rvq.rvqplant
#     CLEAR FORM
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t250_set_entry_b(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1   
   IF p_cmd = 'a' THEN
     CALL cl_set_comp_entry("rvr02,rvr04,rvr06,rvr08",TRUE)
   END IF
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      IF g_rvq.rvqconf = '1' THEN
         CALL cl_set_comp_entry("rvr09",TRUE)
      ELSE
         CALL cl_set_comp_entry("rvr02,rvr04,rvr06,rvr08",TRUE)
      END IF   
   END IF   
END FUNCTION
 
FUNCTION t250_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
   IF p_cmd = 'a' THEN
     IF g_rvq.rvqconf = '1' THEN
        CALL cl_set_comp_entry("rvr02,rvr04,rvr06,rvr07,rvr08,qry_out,qry_in",FALSE)
     ELSE   
        CALL cl_set_comp_entry("rvr07,rvr09,qry_out,qry_in",FALSE)
     END IF
   END IF
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      IF g_rvq.rvqconf = '1' THEN
         CALL cl_set_comp_entry("rvr02,rvr04,rvr06,rvr07,rvr08,qry_out,qry_in",FALSE)
      ELSE
         CALL cl_set_comp_entry("rvr07,rvr09,qry_out,qry_in",FALSE)
      END IF   
   END IF    
END FUNCTION                  
                                
FUNCTION t250_u()   
   IF s_shut(0) THEN
      RETURN
   END IF 
   IF cl_null(g_rvq.rvq01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_rvq.* FROM rvq_file
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant
 
    IF g_rvq.rvqconf <> '0' THEN    
      CALL cl_err(g_rvq.rvq01,'atm-226',0)
      RETURN
    END IF                  
    IF g_rvq.rvqacti = 'N' THEN 
       CALL cl_err(g_rvq.rvq01,'mfg1000',0)
       RETURN 
    END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK
 
   OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t250_cl INTO g_rvq.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)    
       CLOSE t250_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t250_show()
 
   WHILE TRUE
      LET g_rvq_t.* = g_rvq.*
      LET g_rvq.rvqmodu = g_user
      LET g_rvq.rvqdate = g_today
 
      CALL t250_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rvq.*=g_rvq_t.*
         CALL t250_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rvq.rvq01 <> g_rvq_t.rvq01 THEN            
         UPDATE rvr_file SET rvr01 = g_rvq.rvq01
          WHERE rvr01 = g_rvq_t.rvq01
            AND rvrplant = g_rvq.rvqplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rvr_file",g_rvq_t.rvq01,"",SQLCA.sqlcode,"","rvr",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rvq_file SET rvq_file.* = g_rvq.*
       WHERE rvq01 = g_rvq.rvq01
         AND rvqplant = g_rvq.rvqplant
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvq_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF      
      EXIT WHILE
   END WHILE 
   CLOSE t250_cl
   COMMIT WORK
   CALL t250_show() 
   CALL t250_bp_refresh()
END FUNCTION          
                
FUNCTION t250_r() 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvq.rvq01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_rvq.* 
     FROM rvq_file
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant

    IF g_rvq.rvqconf <> '0' THEN    
      CALL cl_err(g_rvq.rvq01,'atm-226',0)
      RETURN
    END IF                    
    IF g_rvq.rvqacti = 'N' THEN 
       CALL cl_err(g_rvq.rvq01,'mfg1000',0)
       RETURN 
    END IF   
   
   BEGIN WORK
 
   OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t250_cl INTO g_rvq.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t250_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          
       LET g_doc.column1 = "rvq01"         
       LET g_doc.value1 = g_rvq.rvq01      
       CALL cl_del_doc()                                                            
      DELETE FROM rvq_file WHERE rvq01 = g_rvq.rvq01 AND rvqplant = g_rvq.rvqplant
      DELETE FROM rvr_file WHERE rvr01 = g_rvq.rvq01 AND rvrplant = g_rvq.rvqplant
      CLEAR FORM
      CALL g_rvr.clear()
      OPEN t250_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t250_cs
         CLOSE t250_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t250_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t250_cs
         CLOSE t250_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t250_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t250_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE      
            CALL t250_fetch('/')
         END IF
      END IF
   END IF 
   CLOSE t250_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t250_copy()
   DEFINE l_newno     LIKE rvq_file.rvq01,
          l_oldno     LIKE rvq_file.rvq01,
          l_cnt       LIKE type_file.num5 
   DEFINE li_result   LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rvq.rvq01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET g_before_input_done = FALSE
   CALL t250_set_entry('a')
   
   CALL cl_set_head_visible("","YES") 
         
   INPUT l_newno FROM rvq01
       BEFORE INPUT
          CALL cl_set_docno_format("rvq01")
          
       AFTER FIELD rvq01
          IF NOT cl_null(l_newno) THEN
             CALL s_check_no("art",l_newno,g_rvq.rvq01,"C4","rvq_file","rvq01,rvqplant","") 
             RETURNING li_result,l_newno
             IF (NOT li_result) THEN                                                            
                 NEXT FIELD rvq01                                                                                      
             END IF
             BEGIN WORK                                                                                                            
             CALL s_auto_assign_no("art",l_newno,g_today,"C4","rvq_file","rvq01,rvqplant","","","")              
             RETURNING li_result,l_newno  
             IF (NOT li_result) THEN                                                                                               
                ROLLBACK WORK                                                                                                      
                NEXT FIELD rvq01                                                                                                   
             ELSE                                                                                                                  
                COMMIT WORK                                                                                                        
             END IF  
          END IF               
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rvq01)                        
                LET l_newno=s_get_doc_no(g_rvq.rvq01)
                CALL q_oay(FALSE,FALSE,g_rvq.rvq01,'C4','art') RETURNING l_newno   
                DISPLAY l_newno TO rvq01
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
      DISPLAY BY NAME g_rvq.rvq01   
      ROLLBACK WORK  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rvq_file         
    WHERE rvq01 = g_rvq.rvq01 AND rvqplant = g_rvq.rvqplant
     INTO TEMP y
   
   UPDATE y
      SET rvq01 = l_newno, 
          rvq03 = g_today,    #申請日期
          rvq04 = g_user,     #申請人員
          rvq05 = g_plant,
          rvq06 = NULL,      
          rvqplant = g_plant,   
          rvquser = g_user,   
          rvqgrup = g_grup,   
          rvqoriu = g_user,   
          rvqorig = g_grup,  
          rvqmodu = NULL,     
          rvqdate = NULL,     
          rvqcrat = g_today,  
          rvqacti = 'Y',
          rvqpos = 'Y',
          rvqconf = '0',
          rvq11 = NULL,
          rvq10 = NULL,
          rvq10t = NULL,
          rvq13 = NULL,
          rvq12t = NULL,
          rvq12 = NULL      
 
   INSERT INTO rvq_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rvq_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rvr_file         
    WHERE rvr01 = g_rvq.rvq01 AND rvrplant = g_rvq.rvqplant
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rvr01 = l_newno
 
   INSERT INTO rvr_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK           #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rvr_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK            #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rvq.rvq01
   SELECT rvq_file.* INTO g_rvq.* 
     FROM rvq_file 
    WHERE rvq01 = l_newno
      AND rvqplant = g_rvq.rvqplant
   CALL t250_u()
   CALL t250_b()
   #FUN-C80046---begin
   #SELECT rvq_file.* INTO g_rvq.* 
   #  FROM rvq_file 
   # WHERE rvq01 = l_oldno
   #   AND rvqplant = g_rvq.rvqplant
   #CALL t250_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t250_x()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvq.rvq01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_rvq.* 
     FROM rvq_file
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant   
   IF g_rvq.rvqconf <> '0' THEN    
      CALL cl_err(g_rvq.rvq01,'atm-226',0)
      RETURN
   END IF 
    
   BEGIN WORK
 
   OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t250_cl INTO g_rvq.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t250_show()
 
   IF cl_exp(0,0,g_rvq.rvqacti) THEN                   
      LET g_chr=g_rvq.rvqacti
      IF g_rvq.rvqacti='Y' THEN
         LET g_rvq.rvqacti='N'
      ELSE
         LET g_rvq.rvqacti='Y'
      END IF
 
      UPDATE rvq_file SET rvqacti=g_rvq.rvqacti,
                          rvqmodu=g_user,
                          rvqdate=g_today
       WHERE rvq01 = g_rvq.rvq01
         AND rvqplant = g_rvq.rvqplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rvq_file",g_rvq.rvq01,"",SQLCA.sqlcode,"","",1)  
         LET g_rvq.rvqacti=g_chr
      END IF
   END IF
 
   CLOSE t250_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rvqacti,rvqmodu,rvqdate
     INTO g_rvq.rvqacti,g_rvq.rvqmodu,g_rvq.rvqdate 
     FROM rvq_file
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant
   DISPLAY BY NAME g_rvq.rvqacti,g_rvq.rvqmodu,g_rvq.rvqdate
END FUNCTION
 
FUNCTION t250_bp_refresh()
   DISPLAY ARRAY g_rvr TO s_rvr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
 
FUNCTION t250_out()    
  
END FUNCTION  

FUNCTION t250_rvq04(p_cmd)         
   DEFINE p_cmd   LIKE type_file.chr1 
   DEFINE l_gen02 LIKE gen_file.gen02
          
   LET g_errno = ''
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_rvq.rvq04    
   CASE                          
      WHEN SQLCA.sqlcode=100   LET g_errno='mfg3096' 
                               LET l_gen02=NULL 
      OTHERWISE   
                                LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.rvq04_desc
   END IF 
END FUNCTION

FUNCTION t250_rvq05(p_cmd)         
   DEFINE p_cmd    LIKE type_file.chr1 
   DEFINE l_azp02  LIKE azp_file.azp02 
   LET g_errno = ''
   SELECT azp02 INTO l_azp02
     FROM azp_file 
     WHERE azp01 = g_rvq.rvq05    
   CASE                          
      WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                               LET l_azp02=NULL 
      OTHERWISE   
                               LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE     
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_azp02 TO FORMONLY.rvq05_desc
   END IF 
END FUNCTION

FUNCTION t250_rvq07(p_cmd)         
   DEFINE p_cmd    LIKE type_file.chr1 
   DEFINE l_azp02  LIKE azp_file.azp02 
   LET g_errno = ''
   SELECT azp02 INTO l_azp02
     FROM azp_file 
     WHERE azp01 = g_rvq.rvq07    
   CASE                          
      WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                               LET l_azp02=NULL 
      OTHERWISE   
                               LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE     
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_azp02 TO FORMONLY.rvq07_desc
   END IF 
END FUNCTION

FUNCTION t250_rvq08(p_cmd)         
   DEFINE p_cmd    LIKE type_file.chr1 
   DEFINE l_azp02  LIKE azp_file.azp02 
   LET g_errno = ''
   SELECT azp02 INTO l_azp02
     FROM azp_file 
     WHERE azp01 = g_rvq.rvq08    
   CASE                          
      WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                               LET l_azp02=NULL 
      OTHERWISE   
                               LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE     
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_azp02 TO FORMONLY.rvq08_desc
   END IF 
END FUNCTION

FUNCTION t250_rvr04(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_ima1010 LIKE ima_file.ima1010          
          
   LET g_errno = ''   
   SELECT ima02,ima25,imaacti,ima1010
     INTO l_ima02,l_ima25,l_imaacti,l_ima1010
     FROM ima_file
    WHERE ima01 = g_rvr[l_ac].rvr04
   CASE                          
      WHEN SQLCA.sqlcode=100   LET g_errno='art-037' 
                               LET l_ima02=NULL 
      WHEN l_ima1010 <> '1'    LET g_errno='9029'
      WHEN l_imaacti = 'N'     LET g_errno='9028'     
   OTHERWISE   
      LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rvr[l_ac].rvr04_desc = l_ima02
      LET g_rvr[l_ac].rvr06 = l_ima25
      DISPLAY BY NAME g_rvr[l_ac].rvr04_desc,g_rvr[l_ac].rvr06
   END IF 
END FUNCTION

FUNCTION t250_check_rvr06()
    DEFINE l_flag      LIKE type_file.chr1
    DEFINE l_fac       LIKE type_file.num20_6
    DEFINE l_ima25     LIKE ima_file.ima25
 
    LET g_errno = ''
    IF g_rvr[l_ac].rvr04 IS NULL OR g_rvr[l_ac].rvr06 IS NULL THEN
       RETURN
    END IF
    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rvr[l_ac].rvr04
    LET l_flag = NULL
    LET l_fac = NULL
    CALL s_umfchk(g_rvr[l_ac].rvr04,g_rvr[l_ac].rvr06,l_ima25)
    RETURNING l_flag,l_fac
    IF l_flag = 1 THEN        
       LET g_errno = 'aqc-500'       
    ELSE 
       LET g_rvr[l_ac].rvr07 = l_fac       
    END IF
    DISPLAY BY NAME g_rvr[l_ac].rvr07
END FUNCTION

FUNCTION t250_check_rvr04(l_rvr04)
   DEFINE  l_rvr04                     LIKE rvr_file.rvr04   #產品編號
   DEFINE  l_rtz04_1                   LIKE rtz_file.rtz04   #拨出营运中心產品策略
   #DEFINE  l_rtz05_1                   LIKE rtz_file.rtz05  #拨出营运中心價格策略#MOD-B30256
   DEFINE  l_rtz04_2                   LIKE rtz_file.rtz04   #拨入营运中心產品策略
   #DEFINE  l_rtz05_2                   LIKE rtz_file.rtz05  #拨入营运中心價格策略#MOD-B30256 　
   DEFINE  l_sql                       STRING
   DEFINE  l_cnt,l_cnt1,l_cnt2,l_cnt3  LIKE type_file.num5
   DEFINE  l_msg,l_msg_name            STRING
   #DEFINE  l_aza88_1                   LIKE aza_file.aza88 #MOD-B30256
   #DEFINE  l_aza88_2                   LIKE aza_file.aza88 #MOD-B30256
   DEFINE  l_msg11                     STRING
   DEFINE  l_ima02                     LIKE ima_file.ima02,      #
           l_ima25                     LIKE ima_file.ima25,      #
           l_imaacti                   LIKE ima_file.imaacti     # 
   
     LET g_errno = "" 
     LET l_msg = ''
     LET l_msg11 = ''
     LET l_msg_name = ''
     LET g_errnomsg = ''
     #LET l_cnt2 = '1'
     #LET l_cnt3 = '1'
     #判斷產品編號是否存在于aimi100或arti120中
     IF NOT s_chk_item_no(l_rvr04,g_rvq.rvq07) THEN
        LET l_msg11 = l_rvr04,"/",g_rvq.rvq07
        CALL s_errmsg('rvr04,rvq07',l_msg11,'',g_errno,1)
        CALL cl_getmsg(g_errno,g_lang) RETURNING l_msg_name
        LET l_msg = l_msg,g_rvq.rvq07,l_msg_name,'/'
     END IF
     IF NOT s_chk_item_no(l_rvr04,g_rvq.rvq08) THEN
        LET l_msg11 = l_rvr04,"/",g_rvq.rvq08
        CALL s_errmsg('rvr04,rvq08',l_msg11,'',g_errno,1)
        CALL cl_getmsg(g_errno,g_lang) RETURNING l_msg_name
        LET l_msg = l_msg,g_rvq.rvq08,l_msg_name,'/'
     END IF
     IF NOT cl_null(l_msg) THEN
        LET g_errnomsg = l_msg
     END IF
#MOD-B30256--mark--str--
#    # -----add start----------------
#    #對應營運中心有設產品策略，則抓產品策略的料號
#     SELECT rtz04 INTO g_rtz04 FROM rtz_file WHERE rtz01=g_plant
#     IF NOT cl_null(g_rtz04) THEN
#        SELECT DISTINCT ima02,ima25,rte07
#          INTO l_ima02,l_ima25,l_imaacti
#          FROM ima_file,rte_file
#         WHERE ima01 = rte03 AND ima01= l_rvr04
#           AND rte01 = g_rtz04          
#        CASE
#           WHEN SQLCA.sqlcode=100   LET g_errno='art-030'
#                                    LET l_ima02=NULL
#           WHEN l_imaacti='N'       LET g_errno='9028'
#           OTHERWISE
#           LET g_errno=SQLCA.sqlcode USING '------' 
#        END CASE
#        CALL s_errmsg('rvr04',l_rvr04,'',g_errno,1)
#        CALL cl_getmsg(g_errno,g_lang) RETURNING l_msg_name
#        LET l_msg = l_msg,l_msg_name,'/'
#     END IF 
#    #-----add end---------------------
#    LET l_sql = " SELECT aza88 FROM ",cl_get_target_table(g_rvq.rvq07,'aza_file'),
#               "  WHERE aza01 = '0'"
#    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#    CALL cl_parse_qry_sql(l_sql, g_rvq.rvq07) RETURNING l_sql
#    PREPARE pre_aza1  FROM l_sql
#    EXECUTE pre_aza1  INTO l_aza88_1
#    LET l_sql = " SELECT aza88 FROM ",cl_get_target_table(g_rvq.rvq08,'aza_file'),
#               "  WHERE aza01 = '0'"
#    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#    CALL cl_parse_qry_sql(l_sql, g_rvq.rvq08) RETURNING l_sql
#    PREPARE pre_aza2  FROM l_sql
#    EXECUTE pre_aza2  INTO l_aza88_2
#    IF l_aza88_1 = 'Y' THEN
#       SELECT rtz05 INTO l_rtz05_1 FROM rtz_file  #獲取拨出营运中心價格策略代碼                                
#        WHERE rtz01 = g_rvq.rvq07  
#       IF NOT cl_null(l_rtz05_1) THEN 
#          LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_rvq.rvq07, 'rtg_file'),",",
#                                              cl_get_target_table(g_rvq.rvq07, 'rtf_file'),
#                      " WHERE rtg01=rtf01 AND rtfacti='Y' AND rtg09='Y' ",
#                      "   AND rtg03= '",l_rvr04,"'",
#                      "   AND rtg01= '",l_rtz05_1,"'"
#          CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
#          CALL cl_parse_qry_sql(l_sql, g_rvq.rvq07) RETURNING l_sql
#          PREPARE pre2 FROM l_sql
#          EXECUTE pre2 INTO l_cnt2
#          IF l_cnt2<=0 THEN
#             LET g_errno = 'art-961' 
#             CALL s_errmsg('rvr04',l_rvr04,'',g_errno,1)
#             CALL cl_getmsg('art-961',g_lang) RETURNING l_msg_name   
#             LET l_msg = l_msg,l_msg_name,'/' 
#          END IF 
#       END IF
#    END IF
#
#    IF l_aza88_2 = 'Y' THEN
#       SELECT rtz05 INTO l_rtz05_2 FROM rtz_file  #獲取拨入营运中心價格策略代碼
#        WHERE rtz01 = g_rvq.rvq08
#       IF NOT  cl_null(l_rtz05_2) THEN
#          LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_rvq.rvq08, 'rtg_file'),",",
#                                              cl_get_target_table(g_rvq.rvq08, 'rtf_file'),
#                      " WHERE rtg01=rtf01 AND rtfacti='Y' AND rtg09='Y' ",
#                      "   AND rtg03= '",l_rvr04,"'",
#                      "   AND rtg01= '",l_rtz05_2,"'"
#          CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
#          CALL cl_parse_qry_sql(l_sql, g_rvq.rvq07) RETURNING l_sql
#          PREPARE pre3 FROM l_sql
#          EXECUTE pre3 INTO l_cnt3  
#          IF l_cnt3<=0 THEN
#             LET g_errno = 'art-962' 
#             CALL s_errmsg('rvr04',l_rvr04,'',g_errno,1)
#             CALL cl_getmsg('art-962',g_lang) RETURNING l_msg_name   
#             LET l_msg = l_msg,l_msg_name,'/' 
#          END IF   
#       END IF
#    END IF
#
#    IF l_cnt2<=0 OR l_cnt3<=0 THEN
#       LET g_errnomsg = l_msg
#    END IF   
##MOD-B30256--mark--end--
    
END FUNCTION

FUNCTION t250_check_rvr04_1(l_rvr04)    #經營方式
   DEFINE  l_rvr04      LIKE rvr_file.rvr04   #產品編號
   DEFINE l_rtyacti     LIKE rty_file.rtyacti
   DEFINE l_rty06_1     LIKE rty_file.rty06
   DEFINE l_rty06_2     LIKE rty_file.rty06
   DEFINE l_cnt         LIKE type_file.num5

   LET g_errno = ''
    #查詢該商品在撥出營運中心的經營方式
    SELECT rty06,rtyacti INTO l_rty06_1,l_rtyacti
       FROM rty_file WHERE rty01 = g_rvq.rvq07 
        AND rty02 = l_rvr04
    IF l_rtyacti='N' THEN
       LET g_errno = 'art-295'
       RETURN
    END IF
    #查詢該商品在撥入營運中心的經營方式
    LET l_rtyacti = ''
    SELECT rty06,rtyacti INTO l_rty06_2,l_rtyacti
       FROM rty_file WHERE rty01 = g_rvq.rvq08
        AND rty02 = l_rvr04
    IF l_rtyacti='N' THEN
       LET g_errno = 'art-295'
       RETURN
    END IF
    IF l_rty06_1 IS NULL THEN LET l_rty06_1 = '1' END IF
    IF l_rty06_2 IS NULL THEN LET l_rty06_2 = '1' END IF    
    
     SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = g_rvq.rvq07 AND azw02 IN
    (SELECT azw02 FROM  azw_file WHERE azw01 = g_rvq.rvq08)    
     IF l_cnt > 0 THEN
     #如果該商品在撥出營運中心和撥入營運中心的經營方式不相同，報錯
        IF l_rty06_1 <> l_rty06_2 THEN
            LET g_errno = 'art-311'
            RETURN
        END IF
     ELSE
        IF l_rty06_1 <> '1' OR l_rty06_2 <> '1' THEN
            LET g_errno = 'art-333'
            RETURN
        END IF        
     END IF   　　
END FUNCTION

FUNCTION t250_y() #審核
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_sma144   LIKE sma_file.sma144   #核准方式1自動2手動
   DEFINE l_azw07    LIKE azw_file.azw07    #上級營運中心 
   DEFINE l_rvq01    LIKE rvq_file.rvq01  
   
   IF s_shut(0) THEN
      RETURN
   END IF 
   
   IF g_rvq.rvq01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
#CHI-C30107 ----------- add --------------begin 
   IF g_rvq.rvqconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rvq.rvqconf = '1' THEN
      CALL cl_err('',1208,0)
      RETURN
   END IF
   IF g_rvq.rvqconf ='2' THEN
      CALL cl_err(g_rvq.rvq01,'mfg3212',0)
      RETURN
   END IF
   IF g_rvq.rvqconf ='3' THEN
      CALL cl_err(g_rvq.rvq01,'9004',0)
      RETURN
   END IF
   IF g_rvq.rvqacti = 'N' THEN
      CALL cl_err(g_rvq.rvq01,'mfg1000',0)
      RETURN
   END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF 
#CHI-C30107 ----------- add -------------- end
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant
   IF g_rvq.rvqconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rvq.rvqconf = '1' THEN 
      CALL cl_err('',1208,0) 
      RETURN 
   END IF
   IF g_rvq.rvqconf ='2' THEN    
      CALL cl_err(g_rvq.rvq01,'mfg3212',0)
      RETURN
   END IF        
   IF g_rvq.rvqconf ='3' THEN    
      CALL cl_err(g_rvq.rvq01,'9004',0)
      RETURN
   END IF                
   IF g_rvq.rvqacti = 'N' THEN 
      CALL cl_err(g_rvq.rvq01,'mfg1000',0)
      RETURN 
   END IF 
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rvr_file
    WHERE rvr01 = g_rvq.rvq01
      AND rvrplant = g_rvq.rvqplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark

   DROP TABLE rvq_temp
   SELECT * FROM rvq_file WHERE 1 = 0 INTO TEMP rvq_temp
   DROP TABLE rvr_temp
   SELECT * FROM rvr_file WHERE 1 = 0 INTO TEMP rvr_temp
   
   BEGIN WORK
   OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t250_cl INTO g_rvq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
      CLOSE t250_cl 
      ROLLBACK WORK 
      RETURN
   END IF
#   SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = g_rvq.rvq07 AND azwacti='Y' #查出撥出的上級營運中心
#   IF cl_null(l_azw07) THEN
#      LET l_azw07 = g_rvq.rvq07
#   END IF
   CALL t250_getazw07(g_rvq.rvq07,g_rvq.rvq08) RETURNING l_azw07 #獲取撥入撥出的上級營運中心
   
   LET l_sql = "SELECT sma144 FROM ",cl_get_target_table(l_azw07,'sma_file')#是否自動核准               
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_azw07) RETURNING l_sql 
   PREPARE trans_ins_sma FROM l_sql
   EXECUTE trans_ins_sma INTO l_sma144
   IF SQLCA.sqlcode THEN
      CALL cl_err("SELECT sma144",SQLCA.sqlcode,0)
      CLOSE t250_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   
   LET g_success = 'Y'
   LET g_time =TIME   

   UPDATE rvq_file 
      SET rvqconf='1',rvq10=g_today, 
          rvq10t=g_time,rvq11=g_user
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","rvq_file",g_rvq.rvq01,"",STATUS,"","",1) 
      LET g_success='N'
   END IF  
   
   IF g_success = 'Y' THEN
      CALL s_showmsg_init()
      IF l_azw07 <> g_rvq.rvqplant THEN    #上级营运中心与拨出营运中心不同，拋轉資料到上級
         CALL t250_trans(l_azw07)
         IF g_success = 'N' THEN
            ROLLBACK WORK
         END IF
      END IF
   END IF   
   IF g_success = 'Y' AND l_sma144 = '1' THEN #核准方式為自動
      CALL t250_approve(l_azw07) #核准段
      IF g_success = 'Y' AND l_azw07 <> g_rvq.rvqplant THEN 
         LET l_sql = "SELECT rvq01 FROM ",cl_get_target_table(l_azw07, 'rvq_file'),
                     " WHERE rvq06 = '",g_rvq.rvq01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql, l_azw07) RETURNING l_sql
         PREPARE ins_rvq1 FROM l_sql
         EXECUTE ins_rvq1 INTO l_rvq01
         IF SQLCA.sqlcode THEN
            #CALL cl_err("SELECT rvq01",SQLCA.sqlcode,0)
            CALL s_errmsg('rvqplant',l_azw07,'sel rvq01',SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE      
            CALL t250_wback(l_rvq01,l_azw07) #回寫核准資料
         END IF   
      END IF      
   END IF  
              
   IF g_success = 'Y' THEN         
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
   END IF    
    
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01=g_rvq.rvq01 
      AND rvqplant = g_rvq.rvqplant
   DISPLAY BY NAME g_rvq.rvqconf                                                                                         
   DISPLAY BY NAME g_rvq.rvq11,g_rvq.rvq10,g_rvq.rvq10t                                                                                         
   DISPLAY BY NAME g_rvq.rvq13,g_rvq.rvq12,g_rvq.rvq12t
   IF l_sma144 = '1' THEN #核准方式為自動
      CALL t250_b_fill(' 1=1 ')  
   END IF
   DROP TABLE rvq_temp
   DROP TABLE rvr_temp
END FUNCTION

FUNCTION t250_trans(l_azw07)      #拋轉資料
   DEFINE l_azw07    LIKE azw_file.azw07     #營運中心
   DEFINE l_rvqlegal LIKE rvq_file.rvqlegal  #法人
   DEFINE l_sql      STRING
   DEFINE l_rvq01    LIKE rvq_file.rvq01     #申請單號（新）
  #DEFINE l_no       LIKE type_file.num5   #MOD-B20068 mark
   DEFINE l_no       LIKE oay_file.oayslip #MOD-B20068
   DEFINE l_flag     LIKE type_file.num5
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rvr      RECORD LIKE rvr_file.*
   DEFINE l_rvq06    LIKE rvq_file.rvq06     #TQC-AC0384

   LET l_cnt = 1
   #將數據放入臨時表中處理
   DELETE FROM rvq_temp
   DELETE FROM rvr_temp

   SELECT azw02 INTO l_rvqlegal FROM azw_file WHERE azw01 = l_azw07 AND azwacti='Y' #查出法人
   LET l_no = s_get_doc_no(g_rvq.rvq01)  #取出單別
#   #TQC-B60012--add--srt--
#   LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_azw07,'rye_file'),
#               " WHERE rye01 = 'art'",
#               "   AND rye02 = 'C4'",
#               "   AND ryeacti = 'Y'" 
#   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#   CALL cl_parse_qry_sql(l_sql,l_azw07) RETURNING l_sql
#   PREPARE pre_selrye FROM l_sql
#   EXECUTE pre_selrye INTO l_no
#   IF SQLCA.sqlcode THEN
#      CALL s_errmsg('rvqplant',l_azw07,'sel rye03',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#   #TQC-B60012--add--end--
   CALL s_auto_assign_no("art",l_no,g_today,"C4","rvq_file","rvq01,rvqplant",l_azw07,"","")
   RETURNING l_flag,l_rvq01 #自動生成新的申請單號 
   IF (NOT l_flag) THEN  
      LET g_success = 'N'
      CALL s_errmsg('rvq01',l_no,'','sub-145',1) 
      RETURN
   END IF 

#TQC-AC0384--add--str--
   IF cl_null(g_rvq.rvq06) THEN
      LET l_rvq06 = g_rvq.rvq01
   ELSE
      LET l_rvq06 = g_rvq.rvq06
   END IF
#TQC-AC0384--add--end--
      
   #插入單頭資料     
   INSERT INTO rvq_temp SELECT rvq_file.* FROM rvq_file
                         WHERE rvq01 = g_rvq.rvq01 
                           AND rvqplant = g_rvq.rvqplant
   UPDATE rvq_temp SET rvq01=l_rvq01,        #單號
                      # rvq06=g_rvq.rvq01,   #來源單號
                       rvq06=l_rvq06,        #TQC-AC0384
                       rvqplant=l_azw07,     #所屬營運中心
                       rvqlegal = l_rvqlegal #法人
   LET l_sql = "INSERT INTO ",cl_get_target_table(l_azw07, 'rvq_file'),
              " SELECT * FROM rvq_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
   CALL cl_parse_qry_sql(l_sql, l_azw07) RETURNING l_sql
   PREPARE trans_ins_rvq FROM l_sql
   EXECUTE trans_ins_rvq
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO rvq_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   #插入單身資料
   DECLARE cur_rvr1 CURSOR FOR SELECT rvr_file.* FROM rvr_file
                                WHERE rvr01 = g_rvq.rvq01 
                                  AND rvrplant = g_rvq.rvqplant 
   FOREACH cur_rvr1 INTO l_rvr.*
      INSERT INTO rvr_temp (rvr00,rvr01,rvr02,rvr03,rvr04,rvr05,rvr06,rvr07,rvr08,rvr09,rvrplant,rvrlegal)
      VALUES(l_rvr.rvr00,l_rvq01,l_cnt,l_rvr.rvr02,l_rvr.rvr04,l_rvr.rvr05,l_rvr.rvr06,l_rvr.rvr07,l_rvr.rvr08,
             l_rvr.rvr09,l_azw07,l_rvqlegal)  

      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rvr_temp',SQLCA.sqlcode,1)
      END IF
      LET l_cnt = l_cnt + 1      
   END FOREACH
      
   LET l_sql = "INSERT INTO ",cl_get_target_table(l_azw07, 'rvr_file'), 
              " SELECT * FROM rvr_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_azw07) RETURNING l_sql 
   PREPARE trans_ins_rvr FROM l_sql
   EXECUTE trans_ins_rvr
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO rvr_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
END FUNCTION

FUNCTION t250_c() #核准
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_azw07    LIKE azw_file.azw07
   
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_rvq.rvq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01=g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant
#   SELECT azw07 INTO l_azw07 FROM azw_file
#    WHERE azw01 = g_rvq.rvq07
#   IF cl_null(l_azw07) THEN
#      LET l_azw07 = g_rvq.rvq07
#   END IF
   CALL t250_getazw07(g_rvq.rvq07,g_rvq.rvq08) RETURNING l_azw07 #獲取撥入撥出的上級營運中心
   
   IF g_rvq.rvqconf ='2' THEN    
      CALL cl_err(g_rvq.rvq01,'mfg3212',0)
      RETURN
   END IF   

   IF g_rvq.rvqconf <> '1' OR l_azw07 <> g_rvq.rvqplant THEN #已審核的單據在上級營運中心才可使用
      CALL cl_err('','art-956',0)
      RETURN
   END IF
   
   LET l_cnt=0   
   SELECT COUNT(*) INTO l_cnt
     FROM rvr_file
    WHERE rvr01 = g_rvq.rvq01
      AND rvrplant = g_rvq.rvqplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('atm-358') THEN RETURN END IF

   DROP TABLE rvq_temp
   SELECT * FROM rvq_file WHERE 1 = 0 INTO TEMP rvq_temp
   DROP TABLE rvr_temp
   SELECT * FROM rvr_file WHERE 1 = 0 INTO TEMP rvr_temp
   
   BEGIN WORK
   OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant   
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t250_cl INTO g_rvq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
      CLOSE t250_cl 
      ROLLBACK WORK 
      RETURN
   END IF  
   
   LET g_success = 'Y'
   CALL s_showmsg_init()
   CALL t250_approve(l_azw07) #核准段
   
   IF g_success = 'Y' THEN         
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
   END IF    
    
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01=g_rvq.rvq01 
      AND rvqplant = g_rvq.rvqplant
      
   DISPLAY BY NAME g_rvq.rvqconf                                                                                         
   DISPLAY BY NAME g_rvq.rvq13,g_rvq.rvq12,g_rvq.rvq12t 
   CALL t250_b_fill(' 1=1 ') 
   DROP TABLE rvq_temp
   DROP TABLE rvr_temp
END FUNCTION

FUNCTION t250_approve(l_azw07) #核准段
   DEFINE l_sql      STRING
   DEFINE l_azw07    LIKE azw_file.azw07
   DEFINE l_rvr02    LIKE rvr_file.rvr02        #項次      
   DEFINE l_rvr04    LIKE rvr_file.rvr04        #核准數量
   DEFINE l_msg      STRING
   DEFINE l_msg_name STRING
   
   LET g_success = 'Y'
   LET l_msg = ''
   LET l_msg_name = ''
   LET g_time =TIME   

   #IF g_rvq.rvq02 = '1' THEN   #TQC-AC0369
      UPDATE rvq_file 
         SET rvqconf='2',rvq12=g_today, 
             rvq12t=g_time,rvq13=g_user
       WHERE rvq01 = g_rvq.rvq01
         AND rvqplant = g_rvq.rvqplant
#TQC-AC0369--mark--str--
   #ELSE
   #   UPDATE rvq_file 
   #      SET rvqconf='2',rvq12=g_today, 
   #          rvq12t=g_time,rvq13=g_user,
   #          rvqpos='N'
   #    WHERE rvq01 = g_rvq.rvq01
   #      AND rvqplant = g_rvq.rvqplant
   #END IF
#TQC-AC0369--mark--end--
   IF SQLCA.sqlcode THEN
      #CALL cl_err3("upd","rvq_file",g_rvq.rvq01,"",STATUS,"","",1)
      CALL s_errmsg('rvq01',g_rvq.rvq01,'upd rvq_file:',SQLCA.sqlcode,1) 
      LET g_success='N'
   END IF  

   IF g_success = 'Y' THEN  #資料有效性檢查
#      DECLARE cur_rvr3 CURSOR FOR SELECT rvr02,rvr04 FROM rvr_file  
#                                   WHERE rvr01 = g_rvq.rvq01 
#                                     AND rvrplant = g_rvq.rvqplant 
#      FOREACH cur_rvr3 INTO l_rvr02,l_rvr04
#         CALL t250_check_rvr04(l_rvr04)      #檢查價格和產品策略
#         IF NOT cl_null(g_errnomsg) THEN  
#            UPDATE rvr_file SET rvr09 = '0'  #檢查有問題直接把審核量置為0 
#             WHERE rvr01 = g_rvq.rvq01 
#               AND rvr02 = l_rvr02
#               AND rvr04 = l_rvr04
#               AND rvrplant = g_rvq.rvqplant 
#            LET l_msg = l_msg,l_rvr04,'/',g_errnomsg,'\n'    
#         END IF
#         CALL t250_check_rvr04_1(l_rvr04)   #檢查採購策略的經營方式
#         IF NOT cl_null(g_errno) THEN  
#            UPDATE rvr_file SET rvr09 = '0' #檢查有問題直接把審核量置為0 
#             WHERE rvr01 = g_rvq.rvq01 
#               AND rvr02 = l_rvr02
#               AND rvr04 = l_rvr04
#               AND rvrplant = g_rvq.rvqplant 
#            CALL cl_getmsg(g_errno,g_lang) RETURNING l_msg_name   
#            LET l_msg = l_msg,l_rvr04,'/',l_msg_name,'\n'     
#         END IF                      
#      END FOREACH
      CALL t250_chkrvr04(g_rvq.rvq01,g_rvq.rvqplant,'1') RETURNING l_msg
      
      IF NOT cl_null(l_msg) THEN 
         CALL cl_getmsg('art-958',g_lang) RETURNING l_msg_name 
         LET l_msg = l_msg,l_msg_name,'\n'       
         IF cl_confirm(l_msg) THEN
            LET g_success = 'Y' 
         ELSE
            LET g_success = 'N'    
         END IF
     END IF    
   END IF
   
   IF g_success = 'Y' THEN      
#      IF g_rvq.rvq05 = l_azw07 THEN                     #申請營運中心為上級營運中心 
#         IF g_rvq.rvq07 <> l_azw07 THEN                 #申請營運中心不為撥出
#            CALL t250_trans(g_rvq.rvq07)                #資料拋轉到撥出營運中心
#         END IF
#      ELSE
#         IF g_rvq.rvq05 = g_rvq.rvq08 THEN              #申請方為撥入營運中心
#            IF g_rvq.rvq07 <> l_azw07 THEN
#               CALL t250_trans(g_rvq.rvq07)             #資料拋轉到撥出營運中心
#            END IF
#            CALL t250_wback(g_rvq.rvq06,g_rvq.rvq08)    #回寫核准資料
#         ELSE         
#            IF g_rvq.rvq05 = g_rvq.rvq07 THEN           #申請方為撥出營運中心 
#               CALL t250_wback(g_rvq.rvq06,g_rvq.rvq07) #回寫核准資料 
#            ELSE
#               IF g_rvq.rvq07 <> l_azw07 THEN
#                  CALL t250_trans(g_rvq.rvq07)          #資料拋轉到撥出營運中心
#               END IF
#               CALL t250_wback(g_rvq.rvq06,g_rvq.rvq05) #回寫核准資料
#            END IF
#         END IF   
#      END IF
      IF g_rvq.rvq08 = l_azw07 THEN                        #撥入方為上級
         IF g_rvq.rvq05 = g_rvq.rvq07 THEN                 #申請方為撥出方
            CALL t250_wback(g_rvq.rvq06,g_rvq.rvq05)       #回寫撥出方核准資料
         ELSE
            IF g_rvq.rvq05 = g_rvq.rvq08 THEN              #申請方為撥入方
               CALL t250_trans(g_rvq.rvq07)                #資料拋轉到撥出營運中心
            ELSE
               CALL t250_trans(g_rvq.rvq07)                #資料拋轉到撥出營運中心
               CALL t250_wback(g_rvq.rvq06,g_rvq.rvq05)    #回寫申請方核准資料
            END IF
         END IF   
      ELSE
         IF g_rvq.rvq07 = l_azw07 THEN                     #撥出方為上級
            IF g_rvq.rvq05 <> g_rvq.rvq07 THEN             #申請方不為撥出方 
               CALL t250_wback(g_rvq.rvq06,g_rvq.rvq05)    #回寫申請方核准資料 
             END IF  
         ELSE                                              #撥入撥出無上下級關係
            IF g_rvq.rvq05 = l_azw07 THEN                  #申請營運中心為上級營運中心 
               CALL t250_trans(g_rvq.rvq07)                #資料拋轉到撥出營運中心
            ELSE
               IF g_rvq.rvq05 = g_rvq.rvq07 THEN           #申請方為撥出營運中心 
                  CALL t250_wback(g_rvq.rvq06,g_rvq.rvq05) #回寫申請方核准資料 
               ELSE
                  CALL t250_trans(g_rvq.rvq07)             #資料拋轉到撥出營運中心
                  CALL t250_wback(g_rvq.rvq06,g_rvq.rvq05) #回寫申請方核准資料
               END IF
            END IF
         END IF
      END IF
   END IF    
END FUNCTION

FUNCTION t250_wback(l_rvq06,l_rvqplant)         #回寫核准資料
   DEFINE l_rvqplant LIKE rvq_file.rvqplant     #營運中心
   DEFINE l_rvq06    LIKE rvq_file.rvq06        #來源單號
   DEFINE l_rvqpos   LIKE rvq_file.rvqpos       #pos
   DEFINE l_sql      STRING
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rvr      RECORD LIKE rvr_file.*
   DEFINE l_rvr03    LIKE rvr_file.rvr03        #項次      
   DEFINE l_rvr09    LIKE rvr_file.rvr09        #核准數量   

   LET l_cnt = 1
   
   #更改單頭資料
   #IF g_rvq.rvq02 = '1' THEN   #TQC-AC0369
      LET l_rvqpos = 'Y'
   #ELSE                        #TQC-AC0369
   #   LET l_rvqpos = 'N'       #TQC-AC0369
   #END IF                      #TQC-AC0369
   LET l_sql = "UPDATE ",cl_get_target_table(l_rvqplant, 'rvq_file'),
               "   SET rvqconf='2', ",
               "       rvq12 = '",g_today,"',", 
               "       rvq12t= '",g_time,"',",
               "       rvq13 = '",g_user,"',",
               "       rvqpos = '",l_rvqpos,"'",
               " WHERE rvq01 = '", l_rvq06,"'",
               "   AND rvqplant = '",l_rvqplant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
   CALL cl_parse_qry_sql(l_sql, l_rvqplant) RETURNING l_sql
   PREPARE trans_ins_rvq1 FROM l_sql
   EXECUTE trans_ins_rvq1
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','UPDATE rvq_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   #更改單身資料
   DECLARE cur_rvr2 CURSOR FOR SELECT rvr03,rvr09 FROM rvr_file  
                                WHERE rvr01 = g_rvq.rvq01 
                                  AND rvrplant = g_rvq.rvqplant 
   FOREACH cur_rvr2 INTO l_rvr03,l_rvr09
      LET l_sql = "UPDATE ",cl_get_target_table(l_rvqplant, 'rvr_file'),
                  "   SET rvr09 = '",l_rvr09,"'",    #核准數量
                  " WHERE rvr01 = '", l_rvq06,"'",   
                  "   AND rvr02 = '",l_rvr03,"'",
                  "   AND rvrplant = '",l_rvqplant,"'"                  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql, l_rvqplant) RETURNING l_sql
      PREPARE trans_ins_rvr2 FROM l_sql
      EXECUTE trans_ins_rvr2
   
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','UPDATE rvr_file',SQLCA.sqlcode,1)
      END IF   
   END FOREACH   
END FUNCTION

FUNCTION t250_con() #調撥狀況
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE g_cmd      LIKE type_file.chr1000 
   DEFINE l_ruo01    LIKE ruo_file.ruo01
   
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_rvq.rvq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01=g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant

   IF g_rvq.rvqconf <> '3' THEN #未結案不可使用
      CALL cl_err(g_rvq.rvq01,'art-984',0)
      RETURN
   END IF
   
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rvr_file
    WHERE rvr01 = g_rvq.rvq01
      AND rvrplant = g_rvq.rvqplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   SELECT ruo01  INTO  l_ruo01  FROM ruo_file 
    WHERE ruo03 = g_rvq.rvq01 AND ruoplant = g_plant 
   LET g_cmd = "artt256   '",l_ruo01,"'"
   CALL cl_cmdrun_wait(g_cmd)
END FUNCTION

FUNCTION t250_getazw07(p_rvq07,p_rvq08)  #獲取撥入和撥出的上級營運中心 1104 add
   DEFINE p_rvq07     LIKE rvq_file.rvq07   #撥出營運中心
   DEFINE p_rvq08     LIKE rvq_file.rvq08   #撥入營運中心
   DEFINE l_rvqplant  LIKE rvq_file.rvqplant 
   DEFINE l_cnt       LIKE type_file.num5
   
   LET l_rvqplant = ''
   LET l_cnt = ''
   #判讀撥出營運中心的上級是否是撥入營運中心
   SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw07 = p_rvq08 AND azw01 = p_rvq07 AND azwacti='Y'																																																																																																																																																																																																																																																														
 　IF l_cnt > 0 THEN            #撥出營運中心的上級是撥入營運中心																																																																																																																																																																																																																																																														
       LET l_rvqplant = p_rvq08																																																																																																																																																																																																																																																															
   ELSE	
      #判讀撥入營運中心的上級是否是撥出營運中心																   
      SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw07 = p_rvq07 AND azw01 = p_rvq08  AND azwacti='Y'																																																																																																																																																																																																																																															
　　　　IF l_cnt>0 THEN 
          LET l_rvqplant = p_rvq07 																																																																																																																																																																																																																																																														
       END IF
   END IF	       
   IF cl_null(l_rvqplant) THEN #撥入撥出沒有上下級關係，抓取撥出的上級營運中心
      SELECT azw07 INTO l_rvqplant FROM azw_file WHERE azw01 = p_rvq07  AND azwacti='Y'
   END IF 																																																																																																																																																																																																																																																														
　　IF cl_null(l_rvqplant) THEN 
       LET l_rvqplant = p_rvq07#撥出營運中心為最上級營運中心	
   END IF       
   RETURN l_rvqplant   
END FUNCTION

FUNCTION t250_chkrvr04(p_rvq01,p_rvqplant,p_flag)
   DEFINE p_rvq01     LIKE rvq_file.rvq01  
   DEFINE p_rvqplant  LIKE rvq_file.rvqplant
   DEFINE p_flag      LIKE type_file.chr1
   DEFINE l_rvr02     LIKE rvr_file.rvr02
   DEFINE l_rvr04     LIKE rvr_file.rvr04 
   DEFINE l_msg       STRING 
   DEFINE l_msg_name  STRING  

   LET l_msg = ''
   CALL s_showmsg_init()
   DECLARE cur_rvr3 CURSOR FOR SELECT rvr02,rvr04 FROM rvr_file  
                                WHERE rvr01 = p_rvq01
                                  AND rvrplant = p_rvqplant 
   FOREACH cur_rvr3 INTO l_rvr02,l_rvr04
      IF SQLCA.sqlcode = 100 THEN
         CALL cl_err('foreach rvr_file:','arm-034',0)
         RETURN
      END IF
      CALL t250_check_rvr04(l_rvr04)      #檢查價格和產品策略
      IF NOT cl_null(g_errnomsg) THEN
         IF p_flag = '1' THEN 
            UPDATE rvr_file SET rvr09 = '0'  #檢查有問題直接把審核量置為0 
             WHERE rvr01 = p_rvq01 
               AND rvr02 = l_rvr02
               AND rvr04 = l_rvr04
               AND rvrplant = p_rvqplant 
         ELSE
            DELETE FROM rvr_file 
             WHERE rvr01 = p_rvq01 
               AND rvr02 = l_rvr02
               AND rvr04 = l_rvr04
               AND rvrplant = p_rvqplant
         END IF         
         LET l_msg = l_msg,l_rvr04,'/',g_errnomsg,'\n'    
      END IF
      CALL t250_check_rvr04_1(l_rvr04)   #檢查採購策略的經營方式
      IF NOT cl_null(g_errno) THEN 
         IF p_flag = '1' THEN 
            UPDATE rvr_file SET rvr09 = '0' #檢查有問題直接把審核量置為0 
             WHERE rvr01 = p_rvq01 
               AND rvr02 = l_rvr02
               AND rvr04 = l_rvr04
               AND rvrplant = p_rvqplant 
         ELSE
            DELETE FROM rvr_file 
             WHERE rvr01 = p_rvq01 
               AND rvr02 = l_rvr02
               AND rvr04 = l_rvr04
               AND rvrplant = p_rvqplant 
         END IF     
         CALL cl_getmsg(g_errno,g_lang) RETURNING l_msg_name   
         LET l_msg = l_msg,l_rvr04,'/',l_msg_name,'\n'     
      END IF                      
   END FOREACH
   RETURN l_msg
END FUNCTION
#FUN-AA0023--end---

#No.FUN-BB0086---add---begin---
FUNCTION t250_rvr08_check()
   IF NOT cl_null(g_rvr[l_ac].rvr08) AND NOT cl_null(g_rvr[l_ac].rvr06) THEN
      IF cl_null(g_rvr_t.rvr08) OR cl_null(g_rvr06_t) OR g_rvr_t.rvr08 != g_rvr[l_ac].rvr08 OR g_rvr06_t != g_rvr[l_ac].rvr06 THEN
         LET g_rvr[l_ac].rvr08=s_digqty(g_rvr[l_ac].rvr08,g_rvr[l_ac].rvr06)
         DISPLAY BY NAME g_rvr[l_ac].rvr08
      END IF
   END IF
   
   IF NOT cl_null(g_rvr[l_ac].rvr08) THEN
      IF g_rvr[l_ac].rvr08 <= 0 THEN
         CALL cl_err('','axr-034',0)
         RETURN FALSE 
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t250_rvr09_check()
   IF NOT cl_null(g_rvr[l_ac].rvr09) AND NOT cl_null(g_rvr[l_ac].rvr06) THEN
      IF cl_null(g_rvr_t.rvr09) OR cl_null(g_rvr06_t) OR g_rvr_t.rvr09 != g_rvr[l_ac].rvr09 OR g_rvr06_t != g_rvr[l_ac].rvr06 THEN
         LET g_rvr[l_ac].rvr09=s_digqty(g_rvr[l_ac].rvr09,g_rvr[l_ac].rvr06)
         DISPLAY BY NAME g_rvr[l_ac].rvr09
      END IF
   END IF
   
   IF NOT cl_null(g_rvr[l_ac].rvr09) THEN
      IF g_rvr[l_ac].rvr09 < 0 THEN
         CALL cl_err('','art-565',0)
         RETURN FALSE 
      END IF
      IF g_rvr[l_ac].rvr09 IS NOT NULL THEN
         IF g_rvr[l_ac].rvr09 > g_rvr[l_ac].rvr08 THEN
            CALL cl_err('','art-575',0)
            RETURN FALSE 
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---
#CHI-C80041---begin
FUNCTION t250_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rvq.rvq01) OR cl_null(g_rvq.rvqplant) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t250_cl USING g_rvq.rvq01,g_rvq.rvqplant
   IF STATUS THEN
      CALL cl_err("OPEN t250_cl:", STATUS, 1)
      CLOSE t250_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t250_cl INTO g_rvq.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t250_cl ROLLBACK WORK RETURN
   END IF
   
   IF g_rvq.rvqconf <> '0' AND g_rvq.rvqconf <> 'X' THEN    
      CALL cl_err(g_rvq.rvq01,'atm-226',0)
      RETURN
   END IF 
   IF cl_void(0,0,g_rvq.rvqconf)   THEN 
        LET l_chr=g_rvq.rvqconf
        IF g_rvq.rvqconf='0' THEN 
            LET g_rvq.rvqconf='X' 
        ELSE
            LET g_rvq.rvqconf='0'
        END IF
        UPDATE rvq_file
            SET rvqconf=g_rvq.rvqconf,  
                rvqmodu=g_user,
                rvqdate=g_today
            WHERE rvq01=g_rvq.rvq01
              AND rvqplant=g_rvq.rvqplant
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rvq_file",g_rvq.rvq01,"",SQLCA.sqlcode,"","",1)  
            LET g_rvq.rvqconf=l_chr 
        END IF
        DISPLAY BY NAME g_rvq.rvqconf
   END IF
 
   CLOSE t250_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rvq.rvq01,'V')
 
END FUNCTION
#CHI-C80041---end

