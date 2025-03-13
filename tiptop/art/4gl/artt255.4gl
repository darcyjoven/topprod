# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artt255.4gl
# Descriptions...: 調撥差異調整單
# Date & Author..: NO.FUN-AA0023 10/11/23 By lixia 
# Modify.........: No.TQC-AC0384 10/12/29 By lixia 畫面刪除已傳pos欄位
# Modify.........: No.TQC-BA0150 11/11/09 By pauline 放大num(申請量與核准量之差)欄位大小
# Modify.........: No:FUN-BB0086 11/12/31 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C20145 12/02/14 By yangxf g_ruo.ruo04改成l_ruo.ruo04,调整拨入拨出营运中心。 
# Modify.........: No:FUN-C80095 12/08/29 By yangxf 撥入審核參數錯誤，導致差異調整多角異常
# Modify.........: No:TQC-C90058 12/09/11 By yangxf 添加来源项次栏位
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CC0057 12/12/17 By xumm INSERT INTO rup_file時rup22給撥入營運中心
# Modify.........: No.CHI-C80041 12/12/28 By bart 排除作廢
# Modify.........: No.FUN-D10047 13/01/10 By xumm BUG调整
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:TQC-D70073 13/07/22 By SunLM 临时表p801_file，且都链接了sapmp801，应该在临时表创建时同步新增一个栏位so_price2

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
 
MAIN
    OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   LET g_prog='artt255'
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
       
   LET g_forupd_sql="SELECT * FROM rvq_file WHERE rvq01 = ? AND rvqplant = ? AND rvq00 = '2' FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t255_cl    CURSOR FROM g_forupd_sql
    
   OPEN WINDOW t255_w WITH FORM "art/42f/artt250" ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('rvq05,rvq05_desc,rvq06,qry_out,qry_in',FALSE)
   CALL t255_menu()
   CLOSE WINDOW t255_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t255_bp(p_ud)
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
      ON ACTION approve
         LET g_action_choice="approve"  #核准
         EXIT DISPLAY          
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 ------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ------------end
      ON ACTION Allocate_condition
         LET g_action_choice="Allocate_condition" #調撥状况
         EXIT DISPLAY          
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY     
      ON ACTION first
         CALL t255_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL t255_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t255_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL t255_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t255_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
FUNCTION t255_menu() 
   WHILE TRUE
      CALL t255_bp("G")
      CASE g_action_choice
         WHEN "void"                  #作廢
           IF cl_chk_act_auth() THEN 
              CALL t255_void(1)
           END IF
         #FUN-D20039 ----------sta
         WHEN "undo_void"                  
           IF cl_chk_act_auth() THEN
              CALL t255_void(2)
           END IF
         #FUN-D20039 ----------end
         WHEN "approve"               #核准
           IF cl_chk_act_auth() THEN
              CALL t255_c()
           END IF   
        WHEN "Allocate_condition"    #調撥状况
           IF cl_chk_act_auth() THEN
              CALL t255_con()
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
               CALL t255_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t255_b()
            ELSE
               LET g_action_choice = NULL
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
      END CASE
   END WHILE
END FUNCTION

FUNCTION t255_cs()
   DEFINE  lc_qbe_sn   LIKE  gbm_file.gbm01 
   CLEAR FORM
   CALL g_rvr.clear()
   CONSTRUCT BY NAME g_wc ON  rvq01,rvq02,rvq14,rvq03,rvq04,rvq07,rvq08,rvq15,rvq904,rvq99,rvqconf,
                              #rvqpos,rvqplant,rvq09,rvquser,rvqgrup,rvqmodu,rvqdate,rvqoriu,rvqorig,
                              rvqplant,rvq09,rvquser,rvqgrup,rvqmodu,rvqdate,rvqoriu,rvqorig, #TQC-AC0384
                              rvqcrat,rvqacti,rvq11,rvq10,rvq10t,rvq13,rvq12,rvq12t                               
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
              
   ON ACTION controlp
      CASE
         WHEN INFIELD(rvq01) #申請單號
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1 = '2'
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
        WHEN INFIELD(rvqplant)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvqplant
            NEXT FIELD rvqplant     
        WHEN INFIELD(rvq14) #調撥單號
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq14"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq01
            NEXT FIELD rvq01  
        WHEN INFIELD(rvq15) #在途倉
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq15"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq01
            NEXT FIELD rvq01  
        WHEN INFIELD(rvq99) #多角流轉序號
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq99"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq01
            NEXT FIELD rvq01  
        WHEN INFIELD(rvq904) #多角流程代碼
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rvq904"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rvq01
            NEXT FIELD rvq01      
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
    
    CONSTRUCT g_wc2 ON rvr02,rvr03,rvr04,rvr06,rvr07,rvr08,rvr09,rvr10,rvr11                          #TQC-C90058 add rvr03 
                    FROM s_rvr[1].rvr02,s_rvr[1].rvr03,s_rvr[1].rvr04,s_rvr[1].rvr06,                 #TQC-C90058 add rvr03
                         s_rvr[1].rvr07,s_rvr[1].rvr08,s_rvr[1].rvr09,
                         s_rvr[1].rvr10,s_rvr[1].rvr11
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
          WHEN INFIELD(rvr10)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azf01a"                         
             LET g_qryparam.state = 'c'
             LET g_qryparam.arg1 = '6'                    
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO rvr10
             NEXT FIELD rvr10
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
                   "   AND rvq00 = '2' ",
                   " ORDER BY rvq01"
    ELSE                                 
       LET g_sql = "SELECT UNIQUE rvq_file.rvq01,rvq_file.rvqplant",
                   " FROM rvq_file,rvr_file",
                   " WHERE rvq01 = rvr01 ",
                   "   AND rvq00 = rvr00 ",
                   "   AND rvr00 = '2' ",
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY rvq01"
    END IF    
    PREPARE t255_prepare FROM g_sql
    DECLARE t255_cs SCROLL CURSOR WITH HOLD FOR t255_prepare
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM rvq_file WHERE ",g_wc CLIPPED,
                 "   AND rvq00 = '2' "
    ELSE
       LET g_sql="SELECT COUNT(*) FROM ",
                 "(SELECT DISTINCT rvq_file.rvq01 ",
                 "   FROM rvq_file,rvr_file ",
                 "  WHERE rvq01 = rvr01 ",
                 "    AND rvq00 = rvr00 ",
                 "    AND rvr00 = '2' ",
                 "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,")"
    END IF 
    PREPARE t255_precount FROM g_sql
    DECLARE t255_count CURSOR FOR t255_precount
END FUNCTION
 
FUNCTION t255_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rvr.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt    
    CALL t255_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_rvr.clear()
       RETURN
    END IF
    OPEN t255_cs 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_rvr.clear()
    ELSE
       OPEN t255_count
       FETCH t255_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt                                 
          CALL t255_fetch('F') 
       ELSE 
          CALL cl_err('',100,0)
       END IF             
    END IF
END FUNCTION
 
FUNCTION t255_fetch(p_flrvq)
DEFINE p_flrvq         LIKE type_file.chr1           
    CASE p_flrvq
        WHEN 'N' FETCH NEXT     t255_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN 'P' FETCH PREVIOUS t255_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN 'F' FETCH FIRST    t255_cs INTO g_rvq.rvq01,g_rvq.rvqplant
        WHEN 'L' FETCH LAST     t255_cs INTO g_rvq.rvq01,g_rvq.rvqplant
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
            FETCH ABSOLUTE g_jump t255_cs INTO g_rvq.rvq01,g_rvq.rvqplant
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
        CALL t255_show()                   
    END IF
END FUNCTION
 
FUNCTION t255_show()
    
    DISPLAY BY NAME g_rvq.rvq01,g_rvq.rvq02,g_rvq.rvq03,g_rvq.rvq04,g_rvq.rvq07,g_rvq.rvq08,
                    #g_rvq.rvq14,g_rvq.rvq15,g_rvq.rvq904,g_rvq.rvq99,g_rvq.rvqconf,g_rvq.rvqpos,                    
                    g_rvq.rvq14,g_rvq.rvq15,g_rvq.rvq904,g_rvq.rvq99,g_rvq.rvqconf,  #TQC-AC0384
                    g_rvq.rvqplant,g_rvq.rvq09,g_rvq.rvquser,g_rvq.rvqgrup,g_rvq.rvqmodu,
                    g_rvq.rvqdate,g_rvq.rvqoriu,g_rvq.rvqorig,g_rvq.rvqcrat,g_rvq.rvqacti,
                    g_rvq.rvq11,g_rvq.rvq10,g_rvq.rvq10t,g_rvq.rvq13,g_rvq.rvq12,g_rvq.rvq12t 
                    
    CALL t255_rvq04('d')   
    CALL t255_rvq07('d')
    CALL t255_rvq08('d')
                                                                      
    CALL t255_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t255_b_fill(p_wc2)              
    DEFINE   p_wc2       STRING
    DEFINE   l_sql       STRING
    
    LET g_sql = "SELECT rvr02,rvr03,rvr04,'',rvr06,rvr07,rvr08,rvr09,'','',rvr10,rvr11 ",               #TQC-C90058 add rvr03
                "  FROM rvr_file ",
                " WHERE rvr01 = '",g_rvq.rvq01,"'",
                "   AND rvr00 = '2' ",
                "   AND rvrplant = '",g_rvq.rvqplant,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql =g_sql CLIPPED,' ORDER BY rvr02'
    PREPARE t255_pb FROM g_sql
    DECLARE rvr_cs1 CURSOR FOR t255_pb 
    CALL g_rvr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rvr_cs1 INTO g_rvr[g_cnt].*  
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH
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

FUNCTION t255_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_n             LIKE type_file.num5,
          l_lock_sw       LIKE type_file.chr1,
          p_cmd           LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.num5,
          l_allow_delete  LIKE type_file.num5,
          li_reslut       LIKE type_file.num5,
          l_azw07         LIKE azw_file.azw07
 
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
        
   IF cl_null(g_rvq.rvq01) OR cl_null(g_rvq.rvqplant) THEN
      RETURN 
   END IF 
        
   SELECT * INTO g_rvq.* FROM rvq_file
    WHERE rvq01 = g_rvq.rvq01
      AND rvqplant = g_rvq.rvqplant
      AND rvq00 = '2'
   IF g_rvq.rvqconf ='X' THEN RETURN END IF  #CHI-C80041            
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
   LET g_forupd_sql = "SELECT rvr02,rvr03,rvr04,'',rvr06,rvr07,rvr08,rvr09,'','',rvr10,rvr11 ",           #TQC-C90058 add rvr03
                      "  FROM rvr_file",
                      " WHERE rvr01 = ? ",
                      "   AND rvr02 = ? ",
                      "   AND rvrplant = ? ",
                      "   AND rvr00 = '2' ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t255_bcl CURSOR FROM g_forupd_sql
   LET l_allow_insert=cl_detail_input_auth("insert")
   LET l_allow_delete=cl_detail_input_auth("delete")
   
   LET l_allow_insert=FALSE
   LET l_allow_delete=FALSE
   
   INPUT ARRAY g_rvr WITHOUT DEFAULTS FROM s_rvr.*
   ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW= l_allow_insert)                     
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
         OPEN t255_cl USING g_rvq.rvq01,g_rvq.rvqplant
         IF STATUS THEN
            CALL cl_err("OPEN t255_cl:",STATUS,1)
            CLOSE t255_cl
            ROLLBACK WORK
         END IF
                
         FETCH t255_cl INTO g_rvq.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
               CLOSE t255_cl
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN 
               LET p_cmd ='u'
               LET g_rvr_t.*=g_rvr[l_ac].*
               OPEN t255_bcl USING g_rvq.rvq01,g_rvr_t.rvr02,g_rvq.rvqplant
               IF STATUS THEN
                  CALL cl_err("OPEN t255_bcl:",STATUS,1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t255_bcl INTO g_rvr[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rvr_t.rvr02,SQLCA.sqlcode,1)
                        LET l_lock_sw="Y"
                     END IF
                     SELECT ima02 INTO g_rvr[l_ac].rvr04_desc
                       FROM ima_file
                      WHERE ima01 = g_rvr[l_ac].rvr04
               END IF
               CALL cl_set_comp_entry("rvr09,rvr10,rvr11",TRUE) 
               CALL cl_set_comp_entry("rvr02,rvr03,rvr04,rvr06,rvr07,rvr08",FALSE)       #TQC-C90058 add rvr03          
            END IF
  
   AFTER FIELD rvr09
      #No.FUN-BB0086--add--begin--
      LET g_rvr[l_ac].rvr09 = s_digqty(g_rvr[l_ac].rvr09,g_rvr[l_ac].rvr06)
      DISPLAY BY NAME g_rvr[l_ac].rvr09
      #No.FUN-BB0086--add--end--
      IF NOT cl_null(g_rvr[l_ac].rvr09) THEN
         IF g_rvr[l_ac].rvr09 < 0 THEN
            CALL cl_err('','art-565',0)
            NEXT FIELD rvr09
         END IF
         #核准數量不能大于申請數量
         IF g_rvr[l_ac].rvr09 IS NOT NULL THEN
            IF g_rvr[l_ac].rvr09 > g_rvr[l_ac].rvr08 THEN
               CALL cl_err('','art-575',0)
               NEXT FIELD rvr09
            END IF
          END IF
       END IF
 
   ON ROW CHANGE
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
          LET g_rvr[l_ac].* = g_rvr_t.*
          CLOSE t255_bcl
          ROLLBACK WORK
          EXIT INPUT
      END IF      
      IF l_lock_sw = 'Y' THEN
         CALL cl_err(g_rvr[l_ac].rvr02,-263,1)
         LET g_rvr[l_ac].* = g_rvr_t.*
      ELSE
         UPDATE rvr_file SET rvr09 = g_rvr[l_ac].rvr09,
                             rvr10 = g_rvr[l_ac].rvr10,
                             rvr11 = g_rvr[l_ac].rvr11
          WHERE rvr01 = g_rvq.rvq01 
            AND rvr02 = g_rvr_t.rvr02
            AND rvrplant = g_rvq.rvqplant
            AND rvr00 = '2'
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
      LET l_ac_t = l_ac
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         IF p_cmd = 'u' THEN
            LET g_rvr[l_ac].* = g_rvr_t.*
         END IF
         CLOSE t255_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF           
      CLOSE t255_bcl
      COMMIT WORK
           
   ON ACTION CONTROLO                        
      IF INFIELD(rvr02) AND l_ac > 1 THEN
         LET g_rvr[l_ac].* = g_rvr[l_ac-1].*
         LET g_rvr[l_ac].rvr02 = g_rec_b + 1
         NEXT FIELD rvr02
      END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
   ON ACTION CONTROLG
      CALL cl_cmdask()   
             
   ON ACTION controlp                         
      CASE
         WHEN INFIELD(rvr10)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf01a" 
            LET g_qryparam.default1 = g_rvr[l_ac].rvr10 
            LET g_qryparam.arg1 = '6'                    
            CALL cl_create_qry() RETURNING g_rvr[l_ac].rvr10 
            DISPLAY BY NAME g_rvr[l_ac].rvr10
            NEXT FIELD rvr10                   
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
  
    CLOSE t255_bcl
    COMMIT WORK
    CALL t255_show()
END FUNCTION  

FUNCTION t255_out()    
  
END FUNCTION  

FUNCTION t255_rvq04(p_cmd)         
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

FUNCTION t255_rvq07(p_cmd)         
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

FUNCTION t255_rvq08(p_cmd)         
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

FUNCTION t255_rvr04(p_cmd)
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

FUNCTION t255_c() #核准
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_azw07    LIKE azw_file.azw07
   DEFINE l_imd20    LIKE imd_file.imd20
   DEFINE l_sql      STRING
   DEFINE l_rvq12t   LIKE rvq_file.rvq12t
   DEFINE l_rvqconf  LIKE rvq_file.rvqconf
   
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
      AND rvq00 = '2'
   
   IF g_rvq.rvqplant <> g_plant THEN
      CALL cl_err(g_rvq.rvqplant,'art-985',0)
      RETURN
   END IF

   IF g_rvq.rvqconf ='2' THEN #已核准    
      CALL cl_err(g_rvq.rvq01,'mfg3212',0)
      RETURN
   END IF   

   IF g_rvq.rvqconf <> '1' THEN #不為審核的單據不可使用
      CALL cl_err('','art-472',0)
      RETURN
   END IF
   
   LET l_cnt=0   
   LET l_rvq12t = TIME
   SELECT COUNT(*) INTO l_cnt
     FROM rvr_file
    WHERE rvr01 = g_rvq.rvq01
      AND rvrplant = g_rvq.rvqplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('atm-358') THEN RETURN END IF

   CALL t255_temp(1) 
  
   BEGIN WORK
   OPEN t255_cl USING g_rvq.rvq01,g_rvq.rvqplant   
   IF STATUS THEN
      CALL cl_err("OPEN t255_cl:", STATUS, 1)
      CLOSE t255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t255_cl INTO g_rvq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
      CLOSE t255_cl 
      ROLLBACK WORK 
      RETURN
   END IF 
   
   IF cl_null(g_rvq.rvq15) THEN
      CALL cl_err('','aap-129',0)
      CLOSE t255_cl 
      ROLLBACK WORK 
      RETURN
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   CALL t255_ruins(g_rvq.rvq07) #产生调拨单    
   IF g_success = 'Y' THEN
      IF g_rvq.rvq02 = '1' THEN
         LET l_rvqconf = '3'
      ELSE
         LET l_rvqconf = '2'
      END IF
      UPDATE rvq_file SET rvqconf = l_rvqconf,
                          rvq12 = g_today,
                          rvq12t = l_rvq12t,
                          rvq13 = g_user
                    WHERE rvq01 = g_rvq.rvq01
                      AND rvqplant = g_rvq.rvqplant   
      IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','upd rvq_file',SQLCA.sqlcode,1)
      END IF
   END IF
   IF g_success = 'Y' THEN         
      COMMIT WORK
      CLOSE t255_cl
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
      CLOSE t255_cl
   END IF     
    
   CALL t255_temp('2')
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01=g_rvq.rvq01 
      AND rvqplant = g_rvq.rvqplant
      
   DISPLAY BY NAME g_rvq.rvqconf
   DISPLAY BY NAME g_rvq.rvq13,g_rvq.rvq12,g_rvq.rvq12t 
   CALL t255_b_fill(' 1=1 ') 
END FUNCTION

FUNCTION t255_ruins(p_plant) #产生调拨单
   DEFINE   p_plant    LIKE azw_file.azw01
   DEFINE   l_plant    LIKE azw_file.azw01
   DEFINE   l_legal    LIKE azw_file.azw02
   DEFINE   l_ruo      RECORD LIKE ruo_file.*
   DEFINE   li_result  LIKE type_file.num5
   DEFINE   l_no       LIKE oay_file.oayslip
   DEFINE   l_cnt      LIKE type_file.num5  
   DEFINE   l_cnt1     LIKE type_file.num5  
   DEFINE   l_sql      STRING

   IF g_success = 'N' THEN
      RETURN
   END IF

   CALL s_getlegal(p_plant) RETURNING l_legal   
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE  rvq01 = g_rvq.rvq01
      AND  rvqplant = g_rvq.rvqplant      

  #TQC-C20145 begin ----
   LET l_sql = "SELECT imd20 FROM ",cl_get_target_table(g_rvq.rvq07,'imd_file'),",",
                                    cl_get_target_table(g_rvq.rvq07,'ruo_file'),
               " WHERE imd01 = ruo14 AND ruo01 = '",g_rvq.rvq14,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_rvq.rvq07) RETURNING l_sql
   PREPARE pre_sel_imd FROM l_sql
   EXECUTE pre_sel_imd INTO l_plant
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('imd20',g_rvq.rvq14,'','art-438',1)
      RETURN
   END IF
   IF NOT cl_null(l_plant) THEN LET p_plant = l_plant END IF
  #TQC-C20145 end -----
   
   LET l_ruo.ruo02 = '4'
   LET l_ruo.ruo03 = g_rvq.rvq01 #來源單號
   LET l_ruo.ruo04 = p_plant     #撥出營運中心（在途營運中心）
   LET l_ruo.ruo06 = NULL        #no use
   LET l_ruo.ruo07 = g_today
   LET l_ruo.ruo08 = g_user
   LET l_ruo.ruo09 = g_rvq.rvq09 #備註
#  LET l_ruo.ruo14 = g_rvq.rvq15       #TQC-C20145 add
   LET l_ruo.ruoacti = 'Y'   
   LET l_ruo.ruoconf = '0'
   LET l_ruo.ruocrat = g_today
   LET l_ruo.ruodate = NULL
   LET l_ruo.ruogrup = g_grup
   LET l_ruo.ruolegal = l_legal 
   LET l_ruo.ruomodu = NULL
   LET l_ruo.ruoplant = p_plant
   LET l_ruo.ruouser = g_user
   LET l_ruo.ruooriu = g_user
   LET l_ruo.ruoorig = g_grup
   IF g_rvq.rvq02 = 'P' THEN
      LET l_ruo.ruopos = 'N'
   ELSE
      LET l_ruo.ruopos = 'Y'
   END IF
   #LET l_ruo.ruopos = 'Y'
   LET l_ruo.ruo15 = 'N'
   LET l_ruo.ruo904 = g_rvq.rvq904
   LET l_ruo.ruo99 = g_rvq.rvq99
   #FUN-C90050 mark begin---
   #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(p_plant,'rye_file'),
   #            " WHERE rye01 = 'art' AND rye02 = 'J1'" 
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   #CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   #PREPARE pre_sel_rye1 FROM l_sql
   #EXECUTE pre_sel_rye1 INTO l_no   
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','J1',p_plant,'N') RETURNING l_no    #FUN-C90050 add

   #核准量大於0，在途和撥入營運中心的調撥單，多角走倉退
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvr_file
    WHERE rvr01 = g_rvq.rvq01
      AND rvrplant = g_rvq.rvqplant
#     AND rvr09 > 0                          #TQC-C20145   mark
      AND (rvr09 = 0 OR (rvr08-rvr09) > 0)   #TQC-C20145   add
   IF l_cnt > 0 THEN #核准量>0，在途營運中心到撥入營運中心的調撥單
      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01,ruoplant",p_plant,"","")
      RETURNING li_result,l_ruo.ruo01
      IF (NOT li_result) THEN
         LET g_success="N"
         CALL s_errmsg('','','','asf-377',1)
         RETURN
      END IF
      LET l_ruo.ruo05 = g_rvq.rvq08  #撥入營運中心

      #查看是否要走多角的流程
      SELECT COUNT(*) INTO l_cnt1 FROM azw_file WHERE azw01 = p_plant AND azw02 NOT IN
      (SELECT azw02 FROM  azw_file WHERE azw01 = l_ruo.ruo05)
       IF l_cnt1 > 0 THEN          #多角流程，走倉退
          LET l_ruo.ruo901 = 'Y'
       ELSE                        #直接倉庫間異動
          LET l_ruo.ruo901 = 'N'
       END IF
       CALL t255_ruoins_1(p_plant,l_ruo.*,'1')
       #CALL s_transfer(l_ruo.*,'1','Y')
      #CALL t256_sub(l_ruo.*,'1','Y') #FUN-C80095 MARK
       CALL t256_sub(l_ruo.*,'1','N') #FUN-C80095 add #在途仓到原拨入营运中心
   END IF

   #申請量-核准量>0，在途營運中心到撥出營運中心的調撥單，原調撥單的邏輯
   LET l_cnt = 0  
   SELECT COUNT(*) INTO l_cnt FROM rvr_file 
    WHERE rvr01 = g_rvq.rvq01
      AND rvrplant = g_rvq.rvqplant 
#     AND (rvr09 = 0 OR (rvr08-rvr09) > 0)      #TQC-C20145   mark
      AND rvr09 > 0                             #TQC-C20145   add
   IF l_cnt > 0 AND g_success = 'Y' THEN 
      CALL s_auto_assign_no("art",l_no,g_today,"J1","ruo_file","ruo01,ruoplant",p_plant,"","")
      RETURNING li_result,l_ruo.ruo01
      IF (NOT li_result) THEN
         LET g_success="N"
         CALL s_errmsg('','','','asf-377',1)
         RETURN
      END IF   
#FUN-C80095 MARK BEGIN ---
##     LET l_sql = "SELECT ruo05 FROM ",cl_get_target_table(g_rvq.rvq08, 'ruo_file'),      #TQC-C20145 mark
#      LET l_sql = "SELECT ruo05 FROM ",cl_get_target_table(g_rvq.rvq07, 'ruo_file'),      #TQC-C20145 add
#                  " WHERE ruo01 = '",g_rvq.rvq14,"'",
##                 "   AND ruoplant = '",g_rvq.rvq08,"'"      #TQC-C20145 mark
#                  "   AND ruoplant = '",g_rvq.rvq07,"'"      #TQC-C20145 add
#      PREPARE pre_ruo05 FROM l_sql
#      EXECUTE pre_ruo05 INTO l_ruo.ruo05
#      IF SQLCA.sqlcode THEN
#         LET g_success="N"
#         CALL s_errmsg('SELECT ruo_file','','',SQLCA.sqlcode,1)
#         RETURN
#      END IF     
#FUN-C80095 MARK end ---
      #LET l_ruo.ruo05 = g_rvq.rvq07      #撥入營運中心
      LET l_ruo.ruo05 = g_rvq.rvq07       #TQC-C20145 add 
      #查看是否要走多角的流程
      SELECT COUNT(*) INTO l_cnt1 FROM azw_file WHERE azw01 = p_plant AND azw02 NOT IN
      (SELECT azw02 FROM  azw_file WHERE azw01 = l_ruo.ruo05)    
      IF l_cnt1 > 0 THEN          #多角流程
         LET l_ruo.ruo901 = 'Y' 
      ELSE
         LET l_ruo.ruo901 = 'N' 
      END IF
      CALL t255_ruoins_1(p_plant,l_ruo.*,'2')
      #CALL s_transfer(l_ruo.*,'1','N')
     #CALL t256_sub(l_ruo.*,'1','N') #FUN-C80095 mark
      CALL t256_sub(l_ruo.*,'1','Y') #FUN-C80095 add #在途仓到原拨出营运中心，如果有多角，走仓退
   END IF
END FUNCTION

FUNCTION t255_ruoins_1(p_plant,l_ruo,l_flag) #插入資料庫（调拨单）
   DEFINE   l_sql      STRING
   DEFINE   p_plant    LIKE azw_file.azw01   
   DEFINE   l_ruo      RECORD LIKE ruo_file.*
   DEFINE   l_rup      RECORD LIKE rup_file.*
   DEFINE   l_rvr      RECORD LIKE rvr_file.*
#   DEFINE   l_num      LIKE type_file.num5 #申請量與核准量之差  #TQC-BA0150 mark
   DEFINE   l_num      LIKE rvr_file.rvr08  #TQC-BA0150 add
   DEFINE   l_cnt      LIKE type_file.num5  
   DEFINE   l_flag     LIKE type_file.chr1

   IF g_success = 'N' THEN
      RETURN
   END IF
   #插入單頭的資料
   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant,'ruo_file'),
               "(ruo01,ruo02,ruo03,ruo04,ruo05,ruo06,ruo07,",
               "ruo08,ruo09,ruo10,ruo10t,ruo11,ruo12,ruo12t,",
               "ruo13,ruo14,ruo15,ruo901,ruo904,ruo99,ruoacti,",
               "ruoconf,ruocrat,ruodate,ruogrup,ruolegal,ruomodu,",
               "ruoplant,ruouser,ruopos,ruooriu,ruoorig)",
               "  VALUES(?,?,?,?,?, ?,?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?,?,",
               "         ?,?,?,?,?, ?,?,?,?,?)"               
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
   PREPARE ruo_ins2 FROM l_sql
   EXECUTE ruo_ins2 USING
   l_ruo.ruo01, l_ruo.ruo02, l_ruo.ruo03, l_ruo.ruo04, l_ruo.ruo05,
   l_ruo.ruo06, l_ruo.ruo07, l_ruo.ruo08, l_ruo.ruo09, l_ruo.ruo10,
   l_ruo.ruo10t,l_ruo.ruo11, l_ruo.ruo12, l_ruo.ruo12t,l_ruo.ruo13,
   l_ruo.ruo14, l_ruo.ruo15, l_ruo.ruo901,l_ruo.ruo904,l_ruo.ruo99, l_ruo.ruoacti,
   l_ruo.ruoconf, l_ruo.ruocrat, l_ruo.ruodate, l_ruo.ruogrup, l_ruo.ruolegal,
   l_ruo.ruomodu, l_ruo.ruoplant,l_ruo.ruouser, l_ruo.ruopos,  l_ruo.ruooriu,l_ruo.ruoorig
    
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',l_ruo.ruo01,SQLCA.sqlcode,1)
      LET g_success="N"
      RETURN
   END IF   
#TQC-C20145 mark begin ----   
#   IF l_flag = '1' THEN      
#      LET l_sql = "SELECT rvr_file.*,rvr09  FROM rvr_file",  
#                  " WHERE rvr01 = '",g_rvq.rvq01,"'",
#                  "   AND rvrplant = '",g_rvq.rvqplant,"'",
#                  "   AND rvr09 > 0 "     
#   ELSE
#      LET l_sql = "SELECT rvr_file.*,rvr08-rvr09 FROM rvr_file",  
#                  " WHERE rvr01 = '",g_rvq.rvq01,"'",
#                  "   AND rvrplant = '",g_rvq.rvqplant,"'",
#                  "   AND (rvr09 = 0 OR (rvr08-rvr09) > 0)"
#   END IF
#TQC-C20145 mark end -------
#TQC-C20145 add begin -----
   IF l_flag = '1' THEN
      LET l_sql = "SELECT rvr_file.*,rvr08-rvr09 FROM rvr_file",
                  " WHERE rvr01 = '",g_rvq.rvq01,"'",
                  "   AND rvrplant = '",g_rvq.rvqplant,"'",
                  "   AND (rvr09 = 0 OR (rvr08-rvr09) > 0)"
   ELSE
      LET l_sql = "SELECT rvr_file.*,rvr09  FROM rvr_file",      
                  " WHERE rvr01 = '",g_rvq.rvq01,"'",
                  "   AND rvrplant = '",g_rvq.rvqplant,"'",
                  "   AND rvr09 > 0 "
   END IF  
#TQC-C20145 add end -------
   #插入單身資料
   LET l_cnt = 1
   PREPARE rvr_rvr3 FROM l_sql
   DECLARE cur_rvr3 CURSOR FOR rvr_rvr3 
   FOREACH cur_rvr3 INTO l_rvr.*,l_num
      INITIALIZE l_rup.* TO NULL
      SELECT ima25 INTO l_rup.rup04 FROM ima_file WHERE ima01 = l_rvr.rvr04
#     SELECT rty06 INTO l_rup.rup05 FROM rty_file WHERE rty02 = l_rvr.rvr04 AND rty01 = g_ruo.ruo04    #TQC-C20145 mark 
      SELECT rty06 INTO l_rup.rup05 FROM rty_file WHERE rty02 = l_rvr.rvr04 AND rty01 = l_ruo.ruo04    #TQC-C20145 
      IF cl_null(l_rup.rup05) THEN
         LET l_rup.rup05 = '1'
      END IF
#TQC-C20145 MARK begin ---
#      IF l_flag = '1' THEN
#         #撥入倉庫抓原來調撥單的撥出倉庫
#         LET l_sql = "SELECT rup09,rup10,rup11 FROM ",cl_get_target_table(g_rvq.rvq08,'rup_file'),
#                     " WHERE rup01 = '",g_rvq.rvq14,"'",
#                     "   AND rup02 = '",l_rvr.rvr03,"'",
#                     "   AND rupplant = '",g_rvq.rvq08,"'"
#      ELSE
#         #撥入倉庫抓原來調撥單的撥入倉庫
#         LET l_sql = "SELECT rup13,rup14,rup15 FROM ",cl_get_target_table(g_rvq.rvq08,'rup_file'),
#                     " WHERE rup01 = '",g_rvq.rvq14,"'",
#                     "   AND rup02 = '",l_rvr.rvr03,"'",
#                     "   AND rupplant = '",g_rvq.rvq08,"'"
#      END IF      
#TQC-C20145 MARK end ------
#TQC-C20145 add begin ---
      IF l_flag = '1' THEN
         LET l_sql = "SELECT rup13,rup14,rup15 FROM ",cl_get_target_table(g_rvq.rvq07,'rup_file'),
                     " WHERE rup01 = '",g_rvq.rvq14,"'",
                     "   AND rup02 = '",l_rvr.rvr03,"'",
                     "   AND rupplant = '",g_rvq.rvq07,"'"
      ELSE
         LET l_sql = "SELECT rup09,rup10,rup11 FROM ",cl_get_target_table(g_rvq.rvq07,'rup_file'),
                     " WHERE rup01 = '",g_rvq.rvq14,"'",
                     "   AND rup02 = '",l_rvr.rvr03,"'",
                     "   AND rupplant = '",g_rvq.rvq07,"'"
      END IF
#TQC-C20145 add end -----
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
#TQC-C20145 add begin ---
#     CALL cl_parse_qry_sql(l_sql,g_rvq.rvq08) RETURNING l_sql     #TQC-C20145 MARK 
      CALL cl_parse_qry_sql(l_sql,g_rvq.rvq07) RETURNING l_sql     #TQC-C20145 add
      PREPARE rup_ins3 FROM l_sql
      EXECUTE rup_ins3 INTO l_rup.rup13,l_rup.rup14,l_rup.rup15
      IF SQLCA.sqlcode THEN 
         LET g_success="N"
         CALL s_errmsg('','','',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET l_rup.rup01 = l_ruo.ruo01
      LET l_rup.rup02 = l_cnt
      LET l_rup.rup03 = l_rvr.rvr04
      LET l_rup.rup07 = l_rvr.rvr06
      LET l_rup.rup08 = l_rvr.rvr07
      LET l_rup.rup09 = g_rvq.rvq15  #撥出倉庫均為在途倉
      LET l_rup.rup10 = ' '
      LET l_rup.rup11 = ' '
      LET l_rup.rup12 = l_num        #撥出數量
      LET l_rup.rup16 = l_num        #撥入數量
      LET l_rup.rup17 = l_rvr.rvr02
      LET l_rup.rup18 = 'Y'
      LET l_rup.ruplegal = l_ruo.ruolegal
      LET l_rup.rupplant = p_plant
      LET l_rup.rup22 = l_ruo.ruo05     #FUN-CC0057 add
      LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant,'rup_file'),"(", 
                  "              rup01,rup02,rup03,rup04,rup05,rup06,rup07,rup08,rup09,rup10,rup11,",
                  "              rup12,rup13,rup14,rup15,rup16,rup17,rup18,rup19,rup22,rupplant,ruplegal)",  #FUN-CC0057 add rup22
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "                                #FUN-D10047 add 1?
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql 
      PREPARE rup_ins2 FROM l_sql
      EXECUTE rup_ins2 USING l_rup.rup01,l_rup.rup02,l_rup.rup03,l_rup.rup04,l_rup.rup05,l_rup.rup06,l_rup.rup07,
                             l_rup.rup08,l_rup.rup09,l_rup.rup10,l_rup.rup11,l_rup.rup12,l_rup.rup13,l_rup.rup14,
                             l_rup.rup15,l_rup.rup16,l_rup.rup17,l_rup.rup18,l_rup.rup19,l_rup.rup22,l_rup.rupplant,l_rup.ruplegal  #FUN-CC0057 add rup22
      IF SQLCA.sqlcode THEN         
         LET g_success="N"
         CALL s_errmsg('','','',SQLCA.sqlcode,1)
         RETURN
      END IF
      LET l_cnt = l_cnt + 1     
   END FOREACH 
END FUNCTION

FUNCTION t255_con() #調撥狀況
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
      AND rvq00 = '2'
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
   LET g_cmd = "artt256  '",l_ruo01,"'"
   CALL cl_cmdrun_wait(g_cmd)
END FUNCTION

FUNCTION t255_void(p_type)              #作廢功能
   DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
   DEFINE l_n       LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rvq.* FROM rvq_file 
      WHERE rvq01 = g_rvq.rvq01 
        AND rvqplant = g_rvq.rvqplant 
        AND rvq00 = '2'
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rvq.rvqconf='X' THEN RETURN END IF
    ELSE
       IF g_rvq.rvqconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_rvq.rvqconf = '0' OR g_rvq.rvqconf = '1' OR g_rvq.rvqconf = '3' THEN 
      CALL cl_err('','art-976',0) 
      RETURN 
   END IF
  #IF g_rvq.rvqconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF   
   IF g_rvq.rvqacti = 'N' THEN CALL cl_err(g_rvq.rvq01,'art-142',0) RETURN END IF
   
   BEGIN WORK
 
   OPEN t255_cl USING g_rvq.rvq01,g_rvq.rvqplant
   IF STATUS THEN
      CALL cl_err("OPEN t255_cl:", STATUS, 1)
      CLOSE t255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t255_cl INTO g_rvq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvq.rvq01,SQLCA.sqlcode,0)
      CLOSE t255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rvq.rvqconf) THEN      
      #FUN-D20039 -----------sta
      IF g_rvq.rvqconf='2' THEN
         LET g_rvq.rvqconf='X'
      ELSE
         LET g_rvq.rvqconf='2'
      END IF
      #FUN-D20039 -----------end
      UPDATE rvq_file SET rvqconf = g_rvq.rvqconf,
                          rvqmodu = g_user,
                          rvqdate = g_today
       WHERE rvq01 = g_rvq.rvq01 
         AND rvqplant = g_rvq.rvqplant 
         AND rvq00 = '2' 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rvq_file",g_rvq.rvq01,"",SQLCA.sqlcode,"","up rvqconf",1)
          ROLLBACK WORK
          RETURN
       END IF
   END IF
   CLOSE t255_cl
   COMMIT WORK
   SELECT * INTO g_rvq.* FROM rvq_file 
    WHERE rvq01 = g_rvq.rvq01 AND rvqplant = g_rvq.rvqplant AND rvq00 = '2' 
   DISPLAY BY NAME g_rvq.rvqconf                                                                                        
   DISPLAY BY NAME g_rvq.rvqmodu                                                                                        
   DISPLAY BY NAME g_rvq.rvqdate
END FUNCTION

FUNCTION t255_temp(l_flag)
   DEFINE l_flag  LIKE type_file.num5
   IF l_flag = '1' THEN
      SELECT * FROM ruo_file WHERE 1=0 INTO TEMP ruo_temp
      SELECT * FROM rup_file WHERE 1=0 INTO TEMP rup_temp
      SELECT * FROM rvq_file WHERE 1 = 0 INTO TEMP rvq_temp
      SELECT * FROM rvr_file WHERE 1 = 0 INTO TEMP rvr_temp

      CREATE TEMP TABLE p801_file(
        p_no     LIKE type_file.num5,
        so_no    LIKE pmm_file.pmm01,   #採購單號
        so_item  LIKE type_file.num5,
        so_price LIKE oeb_file.oeb13,   #單價
        so_price2 LIKE pmn_file.pmn31t, #TQC-D70073
        so_curr  LIKE pmm_file.pmm22)   #幣種

      CREATE TEMP TABLE p900_file(
       p_no        LIKE type_file.num5,
       pab_no      LIKE oea_file.oea01, #訂單單號
       pab_item    LIKE type_file.num5,
       pab_price   LIKE type_file.num20_6)

      CREATE TEMP TABLE p840_file(
         p_no      LIKE type_file.num5,
         pab_no    LIKE pmn_file.pmn01,
         pab_item  LIKE type_file.num5,
         pab_price LIKE oeb_file.oeb13)
   ELSE
      DROP TABLE p801_file
      DROP TABLE p900_file   
      DROP TABLE p840_file
      DROP TABLE ruo_temp
      DROP TABLE rup_temp
      DROP TABLE rvr_temp
      DROP TABLE rvq_temp
   END IF
 
END FUNCTION

#FUN-AA0023--end---
