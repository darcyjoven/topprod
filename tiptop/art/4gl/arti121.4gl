# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: arti121.4gl
# Descriptions...: 價格策略維護作業
# Date & Author..: NO.FUN-960130 08/07/15 By  Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO. 
# Modify.........: No:TQC-A10086 10/01/29 By Cockroach 單位開窗修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/11 By Cockroach 添加pos相關管控
# Modify.........: No.TQC-A30041 10/03/15 By Cockroach add orig/oriu
# Modify.........: No.TQC-A80045 10/08/11 By houlia 錄入計價單位后，不應該更新rtf03_desc欄位
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.TQC-AB0110 10/11/28 By huangtao
# Modify.........: No:FUN-B40044 11/04/26 By shiwuying MISC*料号产品名称修改
# Modify.........: No:FUN-B50023 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B40103 11/05/04 By shiwuying 增加开价否栏位rtg10
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B80177 11/08/30 By pauline 新增取消確認ACTION
# Modify.........: No.FUN-C50036 12/05/17 By fanbj 單身增加rtg11,rtg12欄位
# Modify.........: No.CHI-C30002 12/05/28 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/15 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C60086 12/06/25 By xjll   修改服飾流通行業料號開窗問題
# Modify.........: No:FUN-C80049 12/08/13 By xumeimei 開窗多選時給rtg11，rtg12賦值
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80102 12/08/16 By yangxf 解決查詢時按上下筆會報錯BUG
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-D20063 13/02/20 By Sakura 單身rtg05,rtg06,rtg07,rtg11欄位控卡金額不可小於0
# Modify.........: No.CHI-D20015 12/03/26 By lujh 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40044 13/04/19 By dongsz 維護單位時，檢查是否存在庫存單位轉化率，存在時才能維護

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rtf         RECORD LIKE rtf_file.*,
       g_rtf_t       RECORD LIKE rtf_file.*,
       g_rtf_o       RECORD LIKE rtf_file.*,
       g_rtf01_t     LIKE rtf_file.rtf01,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rtg         DYNAMIC ARRAY OF RECORD
           rtg02          LIKE rtg_file.rtg02,
           rtg03          LIKE rtg_file.rtg03,
           rtg03_desc     LIKE azp_file.azp02,
           rtg04          LIKE rtg_file.rtg04,
           rtg04_desc     LIKE gfe_file.gfe02,
           rtg05          LIKE rtg_file.rtg05,
           rtg06          LIKE rtg_file.rtg06,
           rtg07          LIKE rtg_file.rtg07,
           rtg11          LIKE rtg_file.rtg11, #FUN-C50036 add 
           rtg12          LIKE rtg_file.rtg12, #FUN-C50036 add
           rtg08          LIKE rtg_file.rtg08,
           rtg10          LIKE rtg_file.rtg10, #FUN-B40103
           rtg09          LIKE rtg_file.rtg09,
           rtgpos         LIKE rtg_file.rtgpos           
                     END RECORD,
       g_rtg_t       RECORD
           rtg02          LIKE rtg_file.rtg02,
           rtg03          LIKE rtg_file.rtg03,
           rtg03_desc     LIKE azp_file.azp02,
           rtg04          LIKE rtg_file.rtg04,
           rtg04_desc     LIKE gfe_file.gfe02,
           rtg05          LIKE rtg_file.rtg05,
           rtg06          LIKE rtg_file.rtg06,
           rtg07          LIKE rtg_file.rtg07,
           rtg11          LIKE rtg_file.rtg11, #FUN-C50036 add
           rtg12          LIKE rtg_file.rtg12, #FUN-C50036 add
           rtg08          LIKE rtg_file.rtg08,
           rtg10          LIKE rtg_file.rtg10, #FUN-B40103
           rtg09          LIKE rtg_file.rtg09,    
           rtgpos         LIKE rtg_file.rtgpos           
                     END RECORD,
       g_rtg_o       RECORD 
           rtg02          LIKE rtg_file.rtg02,
           rtg03          LIKE rtg_file.rtg03,
           rtg03_desc     LIKE azp_file.azp02,
           rtg04          LIKE rtg_file.rtg04,
           rtg04_desc     LIKE gfe_file.gfe02,
           rtg05          LIKE rtg_file.rtg05,
           rtg06          LIKE rtg_file.rtg06,
           rtg07          LIKE rtg_file.rtg07,
           rtg11          LIKE rtg_file.rtg11, #FUN-C50036 add
           rtg12          LIKE rtg_file.rtg12, #FUN-C50036 add
           rtg08          LIKE rtg_file.rtg08,
           rtg10          LIKE rtg_file.rtg10, #FUN-B40103
           rtg09          LIKE rtg_file.rtg09,    
           rtgpos         LIKE rtg_file.rtgpos           
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
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
DEFINE g_argv1             LIKE rtf_file.rtf01
DEFINE g_argv2             STRING 
DEFINE g_flag              LIKE type_file.num5
 
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
 
   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rtf_file WHERE rtf01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW i121_w AT p_row,p_col WITH FORM "art/42f/arti121"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   #FUN-A30030 ADD---------------------------
   IF g_aza.aza88='N'  THEN
      CALL cl_set_comp_visible("rtgpos",FALSE)
   END IF  
   #FUN-A30030 END---------------------------

   CALL cl_set_comp_visible("rtg12",FALSE)   #FUN-C50036 add

   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL i121_q()
   END IF
 
   CALL i121_menu()
   CLOSE WINDOW i121_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i121_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rtg.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " rtf01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rtf.* TO NULL
      CONSTRUCT BY NAME g_wc ON rtf01,rtf02,rtf03,rtf04,rtf05,
                                rtfconf,rtfcond,rtfconu,rtfuser,
                                rtfgrup,rtfmodu,rtfdate,rtfacti,
                                rtfcrat,rtforiu,rtforig      #TQC-A30041 ADD 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rtf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtf01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtf01
                  NEXT FIELD rtf01
      
               WHEN INFIELD(rtf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtf03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtf03
                  NEXT FIELD rtf03
       
               WHEN INFIELD(rtfconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rtfconu" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rtfconu  
                  NEXT FIELD rtfconu
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
   #      LET g_wc = g_wc clipped," AND rtfuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND rtfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND rtfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtfuser', 'rtfgrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      #CONSTRUCT g_wc2 ON rtg02,rtg03,rtg04,rtg05,rtg06,rtg07,rtg08,rtg10,rtg09,rtgpos #FUN-B40103  #FUN-C50036 mark
      CONSTRUCT g_wc2 ON rtg02,rtg03,rtg04,rtg05,rtg06,rtg07,rtg11,rtg12,       #FUN-C50036 add             
                         rtg08,rtg10,rtg09,rtgpos                               #FUN-C50036 add    
              FROM s_rtg[1].rtg02,s_rtg[1].rtg03,s_rtg[1].rtg04,
                   s_rtg[1].rtg05,s_rtg[1].rtg06,s_rtg[1].rtg07, 
                   s_rtg[1].rtg11,s_rtg[1].rtg12,                               #FUN-C50036 add   
                   s_rtg[1].rtg08,s_rtg[1].rtg10,s_rtg[1].rtg09,s_rtg[1].rtgpos #FUN-B40103
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rtg03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtg03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtg03
                  NEXT FIELD rtg03
                  
                WHEN INFIELD(rtg04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rtg04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtg04
                  NEXT FIELD rtg04
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
      LET g_sql = "SELECT rtf01 FROM rtf_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY rtf01"
   ELSE
      LET g_sql = "SELECT UNIQUE rtf01 ",
                  "  FROM rtf_file, rtg_file ",
                  " WHERE rtf01 = rtg01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rtf01"
   END IF
 
   PREPARE i121_prepare FROM g_sql
   DECLARE i121_cs
       SCROLL CURSOR WITH HOLD FOR i121_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rtf_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM rtf_file,rtg_file WHERE ",
                "rtg01=rtf01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i121_precount FROM g_sql
   DECLARE i121_count CURSOR FOR i121_precount
 
END FUNCTION
 
FUNCTION i121_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL i121_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i121_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i121_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i121_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i121_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i121_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i121_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i121_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i121_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i121_yes()
            END IF

#FUN-B80177  add START
        WHEN "un_confirm"
           IF cl_chk_act_auth() THEN
              CALL i121_no()
           END IF
#FUN-B80177  add END
 
        WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL i121_void(1)
            END IF
 
        #FUN-D20039 ----------sta
        WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i121_void(2)
            END IF
        #FUN-D20039 ----------end
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rtg),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rtf.rtf01 IS NOT NULL THEN
                 LET g_doc.column1 = "rtf01"
                 LET g_doc.value1 = g_rtf.rtf01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i121_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rtg TO s_rtg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i121_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i121_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i121_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i121_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i121_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
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

#FUN-B80177  add START
      ON ACTION un_confirm
         LET g_action_choice="un_confirm"
         EXIT DISPLAY
#FUN-B80177  add END
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      
      #FUN-D20039 -----------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -----------------end
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
FUNCTION i121_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
 
   IF g_rtf.rtf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 ------------------ add ------------------ begin
   IF g_rtf.rtfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtf.rtfconf = 'X' THEN CALL cl_err(g_rtf.rtf01,'9024',0) RETURN END IF
   IF g_rtf.rtfacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF 
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ------------------ add ------------------ end 
   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01=g_rtf.rtf01
   IF g_rtf.rtfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtf.rtfconf = 'X' THEN CALL cl_err(g_rtf.rtf01,'9024',0) RETURN END IF 
   IF g_rtf.rtfacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
#TQC-AB0110 ----------STA
   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
#TQC-AB0110 ----------END
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rtg_file
    WHERE rtg01=g_rtf.rtf01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
   OPEN i121_cl USING g_rtf.rtf01
   
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i121_cl INTO g_rtf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
      CLOSE i121_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE rtf_file SET rtfconf='Y',
                       rtfcond=g_today, 
                       rtfconu=g_user
     WHERE rtf01=g_rtf.rtf01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rtf.rtfconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rtf.rtf01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01=g_rtf.rtf01
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtf.rtfconu
   DISPLAY BY NAME g_rtf.rtfconf                                                                                         
   DISPLAY BY NAME g_rtf.rtfcond                                                                                         
   DISPLAY BY NAME g_rtf.rtfconu
   DISPLAY l_gen02 TO FORMONLY.rtfconu_desc
    #CKP
   IF g_rtf.rtfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtf.rtfconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rtf.rtf01,'V')
END FUNCTION
 
FUNCTION i121_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01=g_rtf.rtf01
   IF g_rtf.rtf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rtf.rtfconf='X' THEN RETURN END IF
    ELSE
       IF g_rtf.rtfconf<>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end
   IF g_rtf.rtfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#   IF g_rtf.rtfconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF       #TQC-AB0110 mark
   IF g_rtf.rtfacti = 'N' THEN CALL cl_err('','art-146',0) RETURN END IF
#TQC-AB0110 ----------STA
   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
#TQC-AB0110 ----------END
   BEGIN WORK
 
   OPEN i121_cl USING g_rtf.rtf01
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i121_cl INTO g_rtf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_rtf.rtfconf) THEN
      LET g_chr = g_rtf.rtfconf
      IF g_rtf.rtfconf = 'N' THEN
         LET g_rtf.rtfconf = 'X'
      ELSE
         LET g_rtf.rtfconf = 'N'
      END IF
 
      UPDATE rtf_file SET rtfconf=g_rtf.rtfconf,
                          rtfmodu=g_user,
                          rtfdate=g_today
       WHERE rtf01 = g_rtf.rtf01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rtf_file",g_rtf.rtf01,"",SQLCA.sqlcode,"","up rtfconf",1)
          LET g_rtf.rtfconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE i121_cl
   COMMIT WORK
 
   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01=g_rtf.rtf01
   DISPLAY BY NAME g_rtf.rtfconf                                                                                        
   DISPLAY BY NAME g_rtf.rtfmodu                                                                                        
   DISPLAY BY NAME g_rtf.rtfdate
    #CKP
   IF g_rtf.rtfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtf.rtfconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_rtf.rtf01,'V')
END FUNCTION
FUNCTION i121_bp_refresh()
  DISPLAY ARRAY g_rtg TO s_rtg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i121_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtg.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF NOT s_data_center(g_plant) THEN RETURN END IF
 
   INITIALIZE g_rtf.* LIKE rtf_file.*
   LET g_rtf01_t = NULL
 
   LET g_rtf_t.* = g_rtf.*
   LET g_rtf_o.* = g_rtf.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rtf.rtfuser=g_user
      LET g_rtf.rtforiu = g_user #FUN-980030
      LET g_rtf.rtforig = g_grup #FUN-980030
      LET g_rtf.rtfgrup=g_grup
      LET g_rtf.rtfacti='Y'
      LET g_rtf.rtfcrat = g_today
      LET g_rtf.rtfconf = 'N'
      LET g_rtf.rtf04 = 0
      LET g_rtf.rtf03 = g_plant
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rtf.rtf03                                                             
      DISPLAY l_azp02 TO rtf03_desc
 
      CALL i121_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rtf.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rtf.rtf01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      INSERT INTO rtf_file VALUES (g_rtf.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK       #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rtf_file",g_rtf.rtf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK        #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rtf.rtf01,'I')
      END IF
 
      LET g_rtf01_t = g_rtf.rtf01
      LET g_rtf_t.* = g_rtf.*
      LET g_rtf_o.* = g_rtf.*
      CALL g_rtg.clear()
 
      LET g_rec_b = 0
      CALL i121_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i121_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtf.rtf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtf.* FROM rtf_file
    WHERE rtf01=g_rtf.rtf01
 
   IF g_rtf.rtfacti ='N' THEN
      CALL cl_err(g_rtf.rtf01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rtf.rtfconf = 'Y' THEN
      CALL cl_err('','art-149',0)
      RETURN
   END IF
 
   IF g_rtf.rtfconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
   
#TQC-AB0110 ----------STA
   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
#TQC-AB0110 ----------END

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtf01_t = g_rtf.rtf01
   BEGIN WORK
 
   OPEN i121_cl USING g_rtf.rtf01
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i121_cl INTO g_rtf.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
       CLOSE i121_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i121_show()
 
   WHILE TRUE
      LET g_rtf01_t = g_rtf.rtf01
      LET g_rtf_o.* = g_rtf.*
      LET g_rtf.rtfmodu=g_user
      LET g_rtf.rtfdate=g_today
 
      CALL i121_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtf.*=g_rtf_t.*
         CALL i121_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rtf.rtf01 != g_rtf01_t THEN
         UPDATE rtg_file SET rtg01 = g_rtf.rtf01
           WHERE rtg01 = g_rtf01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtg_file",g_rtf01_t,"",SQLCA.sqlcode,"","rtg",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rtf_file SET rtf_file.* = g_rtf.*
       WHERE rtf01 = g_rtf.rtf01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtf_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i121_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtf.rtf01,'U')
 
   CALL i121_b_fill("1=1")
 
END FUNCTION
 
FUNCTION i121_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rtf.rtf01,g_rtf.rtf02,g_rtf.rtf03,
                   g_rtf.rtf04,g_rtf.rtf05,g_rtf.rtfconf,
                   g_rtf.rtfconu,g_rtf.rtfcond,g_rtf.rtfuser,
                   g_rtf.rtfgrup,g_rtf.rtfdate,g_rtf.rtfacti,
                   g_rtf.rtfcrat,g_rtf.rtfmodu
                  ,g_rtf.rtforiu,g_rtf.rtforig       #TQC-A30041 ADD
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rtf.rtf01,g_rtf.rtf02,g_rtf.rtf03, g_rtf.rtforiu,g_rtf.rtforig,
                 g_rtf.rtfconf,g_rtf.rtfconu,g_rtf.rtfcond,
                 g_rtf.rtf05
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i121_set_entry(p_cmd)
         CALL i121_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD rtf01
         IF NOT cl_null(g_rtf.rtf01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtf.rtf01 != g_rtf_t.rtf01) THEN
               SELECT COUNT(*) INTO l_n FROM rtf_file
                  WHERE rtf01=g_rtf.rtf01
               IF l_n > 0 THEN
                  CALL cl_err(g_rtf.rtf01,'art-062',0)
                  NEXT FIELD rtf01
               END IF
            END IF
         END IF
      AFTER FIELD rtf03
         IF NOT cl_null(g_rtf.rtf03) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rtf.rtf03 != g_rtf_t.rtf03) THEN
               CALL i121_rtf03()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD rtf03                                                                                                   
               END IF
               #IF NOT i121_chk_end() THEN
               #   CALL cl_err(g_rtf.rtf03,'art-058',0)
               #   NEXT FIELD rtf03
               #END IF
               #IF NOT i121_chk_ishq() THEN
               #   IF NOT i121_chk_haveon() THEN
               #      CALL cl_err('','art-059',0)
               #      NEXT FIELD rtf03
               #   END IF
               #END IF
            END IF
         END IF
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtf03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_rtf.rtf03
                CALL cl_create_qry() RETURNING g_rtf.rtf03
                DISPLAY BY NAME g_rtf.rtf03
                CALL i121_rtf03()
                NEXT FIELD rtf03
              OTHERWISE EXIT CASE
         END CASE            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
#FUNCTION i121_chk_end()
#DEFINE l_tqa06   LIKE  tqa_file.tqa06
#  
#  SELECT tqa06 INTO l_tqa06 FROM azp_file,tqa_file
#     WHERE azp03=tqa01 AND azp01=g_rtf.rtf03 AND tqa03='14'
 
#  IF l_tqa06 = 'Y' THEN
#     RETURN FALSE
#  END IF
 
#  RETURN TRUE
#END FUNCTION
 
FUNCTION i121_chk_rtg03()
DEFINE  l_n  LIKE  type_file.num5
    IF NOT cl_null(g_rtg[l_ac].rtg03) AND NOT cl_null(g_rtg[l_ac].rtg04) THEN
       SELECT COUNT(*) INTO l_n FROM rtg_file
           WHERE rtg01=g_rtf.rtf01 AND rtg03=g_rtg[l_ac].rtg03
             AND rtg04 = g_rtg[l_ac].rtg04
       IF l_n > 0 THEN
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION
 
#FUNCTION i121_chk_haveon()
#DEFINE l_azp06   LIKE  azp_file.azp06
 
#   SELECT azp06 INTO l_azp06 FROM azp_file
#      WHERE azp01=g_rtf.rtf03 AND azpacti = 'Y'
 
#   IF cl_null(l_azp06) THEN
#      RETURN FALSE
#   END IF
 
#   RETURN TRUE
#END FUNCTION
 
#FUNCTION i121_chk_ishq()
#DEFINE l_tqa05   LIKE  tqa_file.tqa05                                                                                       
#                                                                                                                            
#  SELECT tqa05 INTO l_tqa05 FROM azp_file,tqa_file                                                                                      
#     WHERE azp03=tqa01 AND azp01=g_rtf.rtf03 AND tqa03='14'            
#                                                                 
#  IF l_tqa05 = 'Y' THEN                                                                                                    
#     RETURN TRUE                                                                                                          
#  END IF                                                                                                                   
#                                                                                                                               
#  RETURN FALSE   
#END FUNCTION
FUNCTION i121_chk_include()
DEFINE l_n         LIKE type_file.num5,
       l_rtz05     LIKE rtz_file.rtz05
 
    IF NOT cl_null(g_rtg[l_ac].rtg03) AND NOT cl_null(g_rtg[l_ac].rtg04) THEN
       SELECT rtz05 INTO l_rtz05 FROM rtz_file    
          WHERE rtz01=g_rtf.rtf03 
       IF cl_null(l_rtz05) THEN RETURN TRUE END IF
       SELECT COUNT(*) INTO l_n FROM rtg_file,rtf_file
          WHERE rtg01=rtf01 AND rtf01=l_rtz05 AND rtg03=g_rtg[l_ac].rtg03
            AND rtg04=g_rtg[l_ac].rtg04
       IF l_n > 0 THEN
          RETURN TRUE
       ELSE 
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION
 
FUNCTION i121_rtf03()
DEFINE l_azp02 LIKE azp_file.azp02
 
   LET g_errno = " "
 
   SELECT azp02
     INTO l_azp02
     FROM azp_file WHERE azp01 = g_rtf.rtf03
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-044'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_azp02 TO FORMONLY.rtf03_desc
   END CASE
 
END FUNCTION
 
FUNCTION i121_rtg03()
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_n       LIKE type_file.num5
    
   LET g_errno = " "
 
  #FUN-B40044 Begin---
   IF g_rtg[l_ac].rtg03[1,4] = 'MISC' THEN
      SELECT ima02,imaacti
        INTO g_rtg[l_ac].rtg03_desc,l_imaacti
        FROM ima_file 
       WHERE ima01 = 'MISC'
   ELSE
  #FUN-B40044 End-----
   SELECT ima02,imaacti
     INTO g_rtg[l_ac].rtg03_desc,l_imaacti
     FROM ima_file 
     WHERE ima01 = g_rtg[l_ac].rtg03
   END IF #FUN-B40044
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_rtg[l_ac].rtg03_desc TO FORMONLY.rtg03_desc
   END CASE
 
END FUNCTION
 
FUNCTION i121_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rtg.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   DISPLAY ' ' TO FORMONLY.cn2
 
   CALL i121_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rtf.* TO NULL
      RETURN
   END IF
 
   OPEN i121_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rtf.* TO NULL
   ELSE
      OPEN i121_count
      FETCH i121_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cn2
 
      CALL i121_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION i121_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i121_cs INTO g_rtf.rtf01
      WHEN 'P' FETCH PREVIOUS i121_cs INTO g_rtf.rtf01
      WHEN 'F' FETCH FIRST    i121_cs INTO g_rtf.rtf01
      WHEN 'L' FETCH LAST     i121_cs INTO g_rtf.rtf01
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
        FETCH ABSOLUTE g_jump i121_cs INTO g_rtf.rtf01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
      INITIALIZE g_rtf.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.cnt
   END IF
 
   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01 = g_rtf.rtf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rtf_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rtf.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rtf.rtfuser
   LET g_data_group = g_rtf.rtfgrup
 
   CALL i121_show()
 
END FUNCTION
 
FUNCTION i121_show()
DEFINE  l_gen02  LIKE gen_file.gen02
 
   LET g_rtf_t.* = g_rtf.*
   LET g_rtf_o.* = g_rtf.*
   DISPLAY BY NAME g_rtf.rtf01,g_rtf.rtf05,g_rtf.rtf02, g_rtf.rtforiu,g_rtf.rtforig,
                   g_rtf.rtfconf,g_rtf.rtf03,g_rtf.rtfcond,
                   g_rtf.rtf04,g_rtf.rtfconu,g_rtf.rtfuser,
                   g_rtf.rtfmodu,g_rtf.rtfacti,g_rtf.rtfgrup,
                   g_rtf.rtfdate,g_rtf.rtfcrat
 
   IF g_rtf.rtfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_rtf.rtfconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_rtf.rtf01,'V')
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtf.rtfconu
   DISPLAY l_gen02 TO FORMONLY.rtfconu_desc
 
   CALL i121_rtf03()
   CALL i121_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i121_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtf.rtf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_rtf.rtfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rtf.rtfconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF NOT s_data_center(g_plant) THEN RETURN END IF
#TQC-AB0110 ----------STA
   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
#TQC-AB0110 ----------END
   BEGIN WORK
   OPEN i121_cl USING g_rtf.rtf01
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      RETURN
   END IF
 
   FETCH i121_cl INTO g_rtf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i121_show()
 
   IF g_rtf.rtfconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   IF cl_exp(0,0,g_rtf.rtfacti) THEN
      LET g_chr=g_rtf.rtfacti
      IF g_rtf.rtfacti='Y' THEN
         LET g_rtf.rtfacti='N'
      ELSE
         LET g_rtf.rtfacti='Y'
      END IF
 
      UPDATE rtf_file SET rtfacti=g_rtf.rtfacti,
                          rtfmodu=g_user,
                          rtfdate=g_today
       WHERE rtf01=g_rtf.rtf01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rtf_file",g_rtf.rtf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_rtf.rtfacti=g_chr
      END IF
   END IF
 
   CLOSE i121_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rtf.rtf01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtfacti,rtfmodu,rtfdate
     INTO g_rtf.rtfacti,g_rtf.rtfmodu,g_rtf.rtfdate FROM rtf_file
    WHERE rtf01=g_rtf.rtf01
   DISPLAY BY NAME g_rtf.rtfacti,g_rtf.rtfmodu,g_rtf.rtfdate
 
END FUNCTION
 
FUNCTION i121_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtf.rtf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rtf.* FROM rtf_file
    WHERE rtf01=g_rtf.rtf01
 
   IF g_rtf.rtfconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rtf.rtfconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_rtf.rtfacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
 
   IF NOT s_data_center(g_plant) THEN RETURN END IF
#TQC-AB0110 ----------STA
   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
#TQC-AB0110 ----------END
   BEGIN WORK
 
   OPEN i121_cl USING g_rtf.rtf01
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i121_cl INTO g_rtf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i121_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rtf01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rtf.rtf01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM rtf_file WHERE rtf01 = g_rtf.rtf01
      DELETE FROM rtg_file WHERE rtg01 = g_rtf.rtf01
      CLEAR FORM
      CALL g_rtg.clear()
      OPEN i121_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i121_cs
          CLOSE i121_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      FETCH i121_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i121_cs
          CLOSE i121_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cn2
      OPEN i121_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i121_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i121_fetch('/')
      END IF
   END IF
 
   CLOSE i121_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtf.rtf01,'D')
END FUNCTION
FUNCTION i121_get_price()
DEFINE l_rtz05     LIKE rtz_file.rtz05
 
    IF cl_null(g_rtg[l_ac].rtg03) OR cl_null(g_rtg[l_ac].rtg04) THEN
       RETURN 
    END IF
 
    SELECT rtz05 INTO l_rtz05 FROM rtz_file WHERE rtz01 = g_plant
    IF cl_null(l_rtz05) THEN RETURN END IF
    #SELECT rtg05,rtg06,rtg07,rtg08                                                 #FUN-C80049 mark
    SELECT rtg05,rtg06,rtg07,rtg08,rtg11                                            #FUN-C80049 add
       INTO g_rtg[l_ac].rtg05,g_rtg[l_ac].rtg06,
    #        g_rtg[l_ac].rtg07,g_rtg[l_ac].rtg08                                    #FUN-C80049 mark
            g_rtg[l_ac].rtg07,g_rtg[l_ac].rtg08,g_rtg[l_ac].rtg11                   #FUN-C80049 add
       FROM rtg_file 
      WHERE rtg01 = l_rtz05 AND rtg03 = g_rtg[l_ac].rtg03
        AND rtg04 = g_rtg[l_ac].rtg04
   #LET g_rtg[l_ac].rtg11 = g_rtg[l_ac].rtg05                 #FUN-C50036 add       #FUN-C80049 mark
   #FUN-C80049--------add----str
   IF cl_null(g_rtg[l_ac].rtg05) THEN LET g_rtg[l_ac].rtg05 = 0 END IF
   IF cl_null(g_rtg[l_ac].rtg06) THEN LET g_rtg[l_ac].rtg06 = 0 END IF
   IF cl_null(g_rtg[l_ac].rtg07) THEN LET g_rtg[l_ac].rtg07 = 0 END IF
   IF cl_null(g_rtg[l_ac].rtg11) THEN LET g_rtg[l_ac].rtg11 = 0 END IF
   #FUN-C80049--------add----end
   IF cl_null(g_rtg[l_ac].rtg08) THEN LET g_rtg[l_ac].rtg08 = 'N' END IF 
END FUNCTION
FUNCTION i121_b()
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
       l_ima25    LIKE ima_file.ima25,    #TQC-D40044 add
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
DEFINE  l_rtz05  LIKE rtz_file.rtz05
DEFINE  l_line   LIKE type_file.num5
DEFINE  l_line1 STRING 
DEFINE  l_flag   LIKE type_file.chr1      #TQC-D40044 add
DEFINE  l_fac    LIKE type_file.num20_6   #TQC-D40044 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rtf.rtf01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rtf.* FROM rtf_file
     WHERE rtf01=g_rtf.rtf01
 
    IF g_rtf.rtfacti ='N' THEN
       CALL cl_err(g_rtf.rtf01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rtf.rtfconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rtf.rtfconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    IF NOT s_data_center(g_plant) THEN RETURN END IF
#TQC-AB0110 ----------STA
   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
#TQC-AB0110 ----------END
    CALL cl_opmsg('b')
 
    #LET g_forupd_sql = "SELECT rtg02,rtg03,'',rtg04,'',rtg05,rtg06,rtg07,rtg08,rtg10,rtg09 ", #FUN-B40103 #FUN-C50036 mark
    LET g_forupd_sql = "SELECT rtg02,rtg03,'',rtg04,'',rtg05,rtg06,rtg07,rtg11,rtg12,rtg08,rtg10,rtg09 ",  #FUN-C50036 add 
                       "  FROM rtg_file ",
                       " WHERE rtg01=? AND rtg02=? "," FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i121_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rtg WITHOUT DEFAULTS FROM s_rtg.*
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
 
           OPEN i121_cl USING g_rtf.rtf01
           IF STATUS THEN
              CALL cl_err("OPEN i121_cl:", STATUS, 1)
              CLOSE i121_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i121_cl INTO g_rtf.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
              CLOSE i121_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rtg_t.* = g_rtg[l_ac].*  #BACKUP
              LET g_rtg_o.* = g_rtg[l_ac].*  #BACKUP
              OPEN i121_bcl USING g_rtf.rtf01,g_rtg_t.rtg02
              IF STATUS THEN
                 CALL cl_err("OPEN i121_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i121_bcl INTO g_rtg[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rtg_t.rtg02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i121_rtg03() 
                 CALL i121_rtg04()
                 #IF NOT cl_null(g_rtg[l_ac].rtg03) AND 
                 #   NOT cl_null(g_rtg[l_ac].rtg04) THEN                                                       
                 #   SELECT rth07 INTO l_rth07 FROM rth_file   
                 #      WHERE rth01 = g_rtg[l_ac].rtg03 AND rth02 = g_rtg[l_ac].rtg04  
                 #   IF l_rth07 = 'Y' THEN  
                 #      CALL cl_set_comp_entry("rtg05,rtg06,rtg07,rtg08",TRUE) 
                 #   ELSE
                 #      CALL cl_set_comp_entry("rtg05,rtg06,rtg07,rtg08",FALSE)
                 #   END IF
                 #END IF
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rtg[l_ac].* TO NULL
           LET g_rtg[l_ac].rtg08 = 'N'
           LET g_rtg[l_ac].rtg10 = 'N'  #FUN-B40103
           LET g_rtg[l_ac].rtg09 = 'Y'
           LET g_rtg[l_ac].rtgpos = '1' #NO.FUN-B50023
           LET g_rtg[l_ac].rtg12 = g_today #FUN-C50050 add
           LET g_rtg_t.* = g_rtg[l_ac].*
           LET g_rtg_o.* = g_rtg[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rtg02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rtg_file(rtg01,rtg02,rtg03,rtg04,rtg05,rtg06,
                                #rtg07,rtg08,rtg10,rtg09,rtgpos) #FUN-B40103 #FUN-C50036 mark
                                rtg07,rtg11,rtg12,rtg08,rtg10,rtg09,rtgpos)  #FUN-C50056 add
           VALUES(g_rtf.rtf01,g_rtg[l_ac].rtg02,
                  g_rtg[l_ac].rtg03,g_rtg[l_ac].rtg04,
                  g_rtg[l_ac].rtg05,g_rtg[l_ac].rtg06,
                  #g_rtg[l_ac].rtg07,g_rtg[l_ac].rtg08, #FUN-C50036 mark
                  g_rtg[l_ac].rtg07,g_rtg[l_ac].rtg11,  #FUN-C50036 add
                  g_rtg[l_ac].rtg12,g_rtg[l_ac].rtg08,  #FUN-C50036 add
                  g_rtg[l_ac].rtg10,                    #FUN-B40103
                  g_rtg[l_ac].rtg09,g_rtg[l_ac].rtgpos)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rtg_file",g_rtf.rtf01,g_rtg[l_ac].rtg02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rtg02
           IF g_rtg[l_ac].rtg02 IS NULL OR g_rtg[l_ac].rtg02 = 0 THEN
              SELECT max(rtg02)+1
                INTO g_rtg[l_ac].rtg02
                FROM rtg_file
               WHERE rtg01 = g_rtf.rtf01
              IF g_rtg[l_ac].rtg02 IS NULL THEN
                 LET g_rtg[l_ac].rtg02 = 1
              END IF
           END IF
 
        AFTER FIELD rtg02
           IF NOT cl_null(g_rtg[l_ac].rtg02) THEN
              IF g_rtg[l_ac].rtg02 != g_rtg_t.rtg02
                 OR g_rtg_t.rtg02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rtg_file
                  WHERE rtg01 = g_rtf.rtf01
                    AND rtg02 = g_rtg[l_ac].rtg02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rtg[l_ac].rtg02 = g_rtg_t.rtg02
                    NEXT FIELD rtg02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rtg03
         IF NOT cl_null(g_rtg[l_ac].rtg03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rtg[l_ac].rtg03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rtg[l_ac].rtg03= g_rtg_t.rtg03
               NEXT FIELD rtg03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-C60086----add--begin-----------------
            IF s_industry("slk") AND g_azw.azw04 = '2' THEN
               SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_rtg[l_ac].rtg03 AND ima151 = 'Y'
               IF l_cnt > 0 THEN
                  CALL cl_err('','mfg-789',0)
                  LET g_rtg[l_ac].rtg03= g_rtg_t.rtg03
                  NEXT FIELD rtg03
               END IF
            END IF
#FUN-C60086 ---add---end------------------ 
            IF g_rtg_o.rtg03 IS NULL OR
               (g_rtg[l_ac].rtg03 != g_rtg_o.rtg03 ) THEN
              #TQC-D40044--add--str---
               IF NOT cl_null(g_rtg[l_ac].rtg04) THEN
                  SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rtg[l_ac].rtg03
                  IF l_ima25 != g_rtg[l_ac].rtg04 THEN
                     CALL s_umfchk(g_rtg[l_ac].rtg03,l_ima25,g_rtg[l_ac].rtg04)
                        RETURNING l_flag,l_fac
                     IF l_flag = 1 THEN
                        CALL cl_err('','art-214',0)
                        NEXT FIELD rtg03
                     END IF
                  END IF 
               END IF
              #TQC-D40044--add--end---  
               CALL i121_rtg03()          
              #:UN-B40044 Begin--- #在s_chk_item_no中已检查
              #IF NOT cl_null(g_errno) THEN
              #   CALL cl_err(g_rtg[l_ac].rtg03,g_errno,0)
              #   LET g_rtg[l_ac].rtg03 = g_rtg_o.rtg03
              #   DISPLAY BY NAME g_rtg[l_ac].rtg03
              #   NEXT FIELD rtg03
              #END IF
              #FUN-B40044 End-----
               IF NOT i121_chk_rtg03() THEN
                  CALL cl_err(g_rtg[l_ac].rtg03,'art-064',0)
                  NEXT FIELD rtg03
               END IF
               IF NOT i121_chk_include() THEN                                                                                   
                  CALL cl_err('','art-060',0)                                                                                   
                  NEXT FIELD rtg03                                                                                              
               END IF
               CALL i121_get_price()
            END IF  
         END IF  
 
        AFTER FIELD rtg04
           IF NOT cl_null(g_rtg[l_ac].rtg04) THEN
              IF g_rtg_o.rtg04 IS NULL OR
                 (g_rtg[l_ac].rtg04 != g_rtg_o.rtg04 ) THEN
                #TQC-D40044--add--str---
                 IF NOT cl_null(g_rtg[l_ac].rtg03) THEN
                    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_rtg[l_ac].rtg03 
                    IF l_ima25 != g_rtg[l_ac].rtg04 THEN
                       CALL s_umfchk(g_rtg[l_ac].rtg03,l_ima25,g_rtg[l_ac].rtg04)
                          RETURNING l_flag,l_fac
                       IF l_flag = 1 THEN
                          CALL cl_err('','art-214',0)
                          NEXT FIELD rtg04
                       END IF
                    END IF
                 END IF    
                #TQC-D40044--add--end---
                 CALL i121_rtg04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rtg[l_ac].rtg04,g_errno,0)
                    LET g_rtg[l_ac].rtg04 = g_rtg_o.rtg04
                    DISPLAY BY NAME g_rtg[l_ac].rtg04
                    NEXT FIELD rtg04
                 END IF
                 IF NOT i121_chk_rtg03() THEN  
                     CALL cl_err(g_rtg[l_ac].rtg04,'art-064',0)
                     NEXT FIELD rtg04  
                 END IF
                 IF NOT i121_chk_include() THEN                                                                                   
                    CALL cl_err('','art-060',0)                                                                                   
                    NEXT FIELD rtg04  
                 END IF
                 CALL i121_get_price()                  
              END IF     
           END IF
#FUN-D20063---add---START
        AFTER FIELD rtg05
           IF NOT cl_null(g_rtg[l_ac].rtg05) THEN
              IF g_rtg[l_ac].rtg05 < 0 THEN
                 CALL cl_err('','alm-450',0)
                 NEXT FIELD rtg05
              END IF
           END IF
        AFTER FIELD rtg11
           IF NOT cl_null(g_rtg[l_ac].rtg11) THEN
              IF g_rtg[l_ac].rtg11 < 0 THEN
                 CALL cl_err('','alm-450',0)
                 NEXT FIELD rtg11
              END IF
           END IF         
#FUN-D20063---add-----END
  
#TQC-AB0110 ---------------STA
        AFTER FIELD rtg06
           IF NOT cl_null(g_rtg[l_ac].rtg06) THEN
              IF g_rtg[l_ac].rtg06>g_rtg[l_ac].rtg05 THEN
                 CALL cl_err('','art-981',0)
              END IF
           #FUN-D20063---add---START
              IF g_rtg[l_ac].rtg06 < 0 THEN
                 CALL cl_err('','alm-450',0)
                 NEXT FIELD rtg06
              END IF              
           #FUN-D20063---add-----END
           END IF

        AFTER FIELD rtg07
           IF NOT cl_null(g_rtg[l_ac].rtg07) THEN
              IF g_rtg[l_ac].rtg07>g_rtg[l_ac].rtg05 OR g_rtg[l_ac].rtg07>g_rtg[l_ac].rtg06 THEN
                 CALL cl_err('','art-980',0)
              END IF
           #FUN-D20063---add---START
              IF g_rtg[l_ac].rtg07 < 0 THEN
                 CALL cl_err('','alm-450',0)
                 NEXT FIELD rtg07
              END IF
           #FUN-D20063---add-----END
           END IF

#TQC-AB0110 ---------------END
        AFTER FIELD rtg08
           IF NOT cl_null(g_rtg[l_ac].rtg08) THEN
              IF g_rtg[l_ac].rtg08 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rtg08                
              END IF
           END IF
        
        AFTER FIELD rtg09
           IF NOT cl_null(g_rtg[l_ac].rtg09) THEN
              IF g_rtg[l_ac].rtg09 NOT MATCHES '[YN]' THEN
                 NEXT FIELD rtg09                
              END IF
           END IF
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rtg_t.rtg02 > 0 AND g_rtg_t.rtg02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
             #FUN-A30030 ADD------------------------------------
              IF g_aza.aza88='Y' THEN
                #FUN-B50023 --START--
                 #IF NOT (g_rtg[l_ac].rtg09='N' AND g_rtg[l_ac].rtgpos='Y') THEN
                 #   CALL cl_err('', 'art-648', 1)
                 #   CANCEL DELETE
                 #END IF
                 IF NOT ((g_rtg[l_ac].rtgpos='3' AND g_rtg[l_ac].rtg09='N') 
                            OR (g_rtg[l_ac].rtgpos='1'))  THEN                  
                    CALL cl_err('','apc-139',0)   
                    CANCEL DELETE
                    RETURN
                 END IF     
                #FUN-B50023 --END--
              END IF
             #FUN-A30030 END-----------------------------------
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtg_file
               WHERE rtg01 = g_rtf.rtf01
                 AND rtg02 = g_rtg_t.rtg02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtg_file",g_rtf.rtf01,g_rtg_t.rtg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rtg[l_ac].* = g_rtg_t.*
              CLOSE i121_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #FUN-A30030 ADD--------------------
           IF g_aza.aza88='Y' THEN
             #FUN-B50023 --START--
              #LET g_rtg[l_ac].rtgpos='N'
              IF g_rtg[l_ac].rtgpos <> '1' THEN
                 LET g_rtg[l_ac].rtgpos='2'
              END IF
             #FUN-B50023 --END--
              DISPLAY BY NAME g_rtg[l_ac].rtgpos
           END IF
           #FUN-A30030 END-------------------
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtg[l_ac].rtg02,-263,1)
              LET g_rtg[l_ac].* = g_rtg_t.*
           ELSE
              UPDATE rtg_file SET rtg02=g_rtg[l_ac].rtg02,
                                  rtg03=g_rtg[l_ac].rtg03,
                                  rtg04=g_rtg[l_ac].rtg04,
                                  rtg05=g_rtg[l_ac].rtg05,
                                  rtg06=g_rtg[l_ac].rtg06,
                                  rtg07=g_rtg[l_ac].rtg07,
                                  rtg11=g_rtg[l_ac].rtg11, #FUN-C50036 add
                                  rtg12=g_rtg[l_ac].rtg12, #FUN-C50036 add   
                                  rtg08=g_rtg[l_ac].rtg08,
                                  rtg10=g_rtg[l_ac].rtg10, #FUN-B40103
                                  rtg09=g_rtg[l_ac].rtg09,
                                  rtgpos = g_rtg[l_ac].rtgpos
               WHERE rtg01=g_rtf.rtf01
                 AND rtg02=g_rtg_t.rtg02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtg_file",g_rtf.rtf01,g_rtg_t.rtg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rtg[l_ac].* = g_rtg_t.*
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
                 LET g_rtg[l_ac].* = g_rtg_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rtg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i121_bcl
              ROLLBACK WORK
              CALL i121_b_fill("1=1")
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE i121_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rtg02) AND l_ac > 1 THEN
              LET g_rtg[l_ac].* = g_rtg[l_ac-1].*
              LET g_rtg[l_ac].rtg02 = g_rec_b + 1
              NEXT FIELD rtg02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtg03)
                IF p_cmd = 'u' THEN
#FUN-AA0059---------mod------------str-----------------                
#                   CALL cl_init_qry_var()
                   SELECT rtz05 INTO l_rtz05 FROM rtz_file 
                      WHERE rtz01=g_rtf.rtf03
                   IF cl_null(l_rtz05) THEN
                      #LET g_qryparam.arg1 = g_rtf.rtf03
                      #LET g_qryparam.form ="q_rth01_1" 
#                      LET g_qryparam.form ="q_ima" 
                      CALL q_sel_ima(FALSE, "q_ima","",g_rtg[l_ac].rtg03,"","","","","",'' ) 
                           RETURNING  g_rtg[l_ac].rtg03

                   ELSE
                   	  CALL cl_init_qry_var()
                      LET g_qryparam.arg1 = l_rtz05
                      LET g_qryparam.form ="q_rtg03"
                      #FUN-C60086---add--begin---------
                      IF s_industry("slk") AND g_azw.azw04 = '2' THEN
                         LET g_qryparam.where = "ima151 <> 'Y'"
                      END IF  
                      #FUN-C60086---add--end-----------
                      LET g_qryparam.default1 = g_rtg[l_ac].rtg03
                      CALL cl_create_qry() RETURNING g_rtg[l_ac].rtg03
                   END IF
                 
#                   LET g_qryparam.default1 = g_rtg[l_ac].rtg03
#                   CALL cl_create_qry() RETURNING g_rtg[l_ac].rtg03
#FUN-AA0059---------mod------------end----------------- 
                   DISPLAY BY NAME g_rtg[l_ac].rtg03
                   CALL i121_rtg03()
                   NEXT FIELD rtg03
                ELSE
                   CALL s_query('2',g_rtf.rtf03,g_rtf.rtf01) RETURNING l_line
                  # CALL q_ima(1,1,g_plant) RETURNING l_line1                 #TQC-AB0110  mark
                   IF l_line != 0 THEN
                      CALL i121_b_fill("1=1")
                      LET g_flag = TRUE
                      EXIT INPUT
                   END IF
                END IF
              WHEN INFIELD(rtg04)
                 CALL cl_init_qry_var()   
                 SELECT rtz05 INTO l_rtz05 FROM rtz_file   
                    WHERE rtz01=g_rtf.rtf03    
                 IF cl_null(l_rtz05) THEN
                    #LET g_qryparam.arg1 = g_rtg[l_ac].rtg03
                    #LET g_qryparam.form ="q_rth02_1" 
                    LET g_qryparam.form ="q_gfe"  #TQC-A10086 MODIFY "q_gef" 
                 ELSE
                    LET g_qryparam.arg1 = g_rtg[l_ac].rtg03
                    LET g_qryparam.arg2 = l_rtz05
                    LET g_qryparam.arg3 = l_rtz05
                    LET g_qryparam.form ="q_rtg04"
                 END IF
                 LET g_qryparam.default1 = g_rtg[l_ac].rtg04  
                 CALL cl_create_qry() RETURNING g_rtg[l_ac].rtg04
                 DISPLAY BY NAME g_rtg[l_ac].rtg04    
                 CALL i121_rtg04()                   
                 NEXT FIELD rtg04
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
    IF p_cmd = 'u' THEN
       LET g_rtf.rtfmodu = g_user
       LET g_rtf.rtfdate = g_today
       UPDATE rtf_file SET rtfmodu = g_rtf.rtfmodu,rtfdate = g_rtf.rtfdate
           WHERE rtf01 = g_rtf.rtf01
    END IF
    DISPLAY BY NAME g_rtf.rtfmodu,g_rtf.rtfdate
 
    IF g_flag THEN
       LET g_flag = FALSE
       CALL i121_b()
    END IF
 
    CLOSE i121_bcl
    COMMIT WORK
#   CALL i121_delall()   #CHI-C30002 mark
    CALL i121_delHeader()     #CHI-C30002 add
 
    
END FUNCTION
 
FUNCTION i121_rtg04()
DEFINE  l_gfeacti      LIKE  gfe_file.gfeacti
     
     SELECT gfe02,gfeacti INTO g_rtg[l_ac].rtg04_desc,l_gfeacti
         FROM gfe_file WHERE gfe01 = g_rtg[l_ac].rtg04
      
     CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-061'
        WHEN l_gfeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#                          DISPLAY g_rtg[l_ac].rtg04_desc TO FORMONLY.rtf03_desc    #TQC-A80045 modify
                           DISPLAY g_rtg[l_ac].rtg04_desc TO FORMONLY.rtg04_desc    #TQC-A80045 modify
     END CASE 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i121_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  rtf_file WHERE rtf01 = g_rtf.rtf01
         INITIALIZE g_rtf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i121_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rtg_file
#   WHERE rtg01 = g_rtf.rtf01
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rtf_file WHERE rtf01 = g_rtf.rtf01
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i121_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = #"SELECT rtg02,rtg03,'',rtg04,'',rtg05,rtg06,rtg07,rtg08,rtg10,rtg09,rtgpos ", #FUN-B40103 #FUN-C50036 mark
               "SELECT rtg02,rtg03,'',rtg04,'',rtg05,rtg06,rtg07,rtg11,rtg12,rtg08,rtg10,rtg09,rtgpos ",  #FUN-C50036 add
               "  FROM rtg_file",
               " WHERE rtg01 ='",g_rtf.rtf01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rtg02 "
 
   DISPLAY g_sql
 
   PREPARE i121_pb FROM g_sql
   DECLARE rtg_cs CURSOR FOR i121_pb
 
   CALL g_rtg.clear()
   LET g_cnt = 1
 
   FOREACH rtg_cs INTO g_rtg[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
      #FUN-B40044 Begin---
       IF g_rtg[g_cnt].rtg03[1,4] = 'MISC' THEN
          SELECT ima02 INTO g_rtg[g_cnt].rtg03_desc FROM ima_file
           WHERE ima01 = 'MISC'
       ELSE
      #FUN-B40044 End-----
          SELECT ima02 INTO g_rtg[g_cnt].rtg03_desc FROM ima_file
           WHERE ima01 = g_rtg[g_cnt].rtg03
       END IF #FUN-B40044
      #TQC-C80102 mark begin ---
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","ima_file",g_rtg[g_cnt].rtg04,"",SQLCA.sqlcode,"","",0)  
      #   LET g_rtg[g_cnt].rtg03_desc = NULL
      #END IF
      #TQC-C80102 mark end ---           

       SELECT gfe02 INTO g_rtg[g_cnt].rtg04_desc  
         FROM gfe_file WHERE gfe01 = g_rtg[g_cnt].rtg04
      #TQC-C80102 mark begin ---
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","ima_file",g_rtg[g_cnt].rtg03,"",SQLCA.sqlcode,"","",0)  
      #   LET g_rtg[g_cnt].rtg04_desc = NULL
      #END IF
      #TQC-C80102 mark end ---
  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b = g_cnt-1                  #TQC-C80102 add
   CALL g_rtg.deleteElement(g_cnt)

  #LET g_rec_b = g_cnt-1                  #TQC-C80102 mark
   LET g_cnt = 0
 
   CALL i121_bp_refresh()
END FUNCTION
 
FUNCTION i121_copy()
   DEFINE l_newno     LIKE rtf_file.rtf01,
          l_oldno     LIKE rtf_file.rtf01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF NOT s_data_center(g_plant) THEN RETURN END IF
   IF g_rtf.rtf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i121_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rtf01
 
       AFTER FIELD rtf01
          IF l_newno IS NOT NULL THEN 
             SELECT COUNT(*) INTO l_n FROM rtf_file
                 WHERE rtf01=l_newno
             IF l_n > 0 THEN
                CALL cl_err(l_newno,'art-062',0)
                NEXT FIELD rtf01
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
      DISPLAY BY NAME g_rtf.rtf01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rtf_file
       WHERE rtf01=g_rtf.rtf01
       INTO TEMP y
 
   UPDATE y
       SET rtf01=l_newno,
           rtf03=g_plant,
           rtfconf = 'N',
           rtfcond = NULL,
           rtfconu = NULL,
           rtfuser=g_user,
           rtfgrup=g_grup,
           rtfmodu=NULL,
           rtfdate=NULL,
           rtfacti='Y',
           rtfcrat=g_today
 
   INSERT INTO rtf_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtf_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rtg_file
       WHERE rtg01=g_rtf.rtf01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
  #UPDATE x SET rtg01=l_newno,rtgpos = '1' #NO.FUN-B50023
   UPDATE x SET rtg01=l_newno,rtgpos = '1',rtg12 = g_today  #FUN-C50036
 
   INSERT INTO rtg_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK                 #FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rtg_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK                  #FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rtf.rtf01
   SELECT rtf_file.* INTO g_rtf.* FROM rtf_file WHERE rtf01 = l_newno
   CALL i121_u()
   CALL i121_b()
   #SELECT rtf_file.* INTO g_rtf.* FROM rtf_file WHERE rtf01 = l_oldno  #FUN-C80046
   #CALL i121_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION i121_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_rtf.rtf01 IS NOT NULL THEN
       LET g_wc = "rtf01='",g_rtf.rtf01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "arti121" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i121_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rtf01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i121_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rtf01",FALSE)
    END IF
 
END FUNCTION

#FUN-B80177  add START
FUNCTION i121_no()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_rtf04    LIKE rtf_file.rtf04
DEFINE l_gen02    LIKE gen_file.gen02   #CHI-D20015 add
   IF g_rtf.rtf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01=g_rtf.rtf01

   IF g_rtf.rtfconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF

   IF NOT s_data_center(g_plant) THEN RETURN END IF

   IF g_rtf.rtf03 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM rtz_file WHERE rtz05 = g_rtf.rtf01
   IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
   IF l_cnt != 0 THEN
      CALL cl_err('','art-466',0)
      RETURN
   END IF

   SELECT rtf04 INTO l_rtf04 FROM rtf_file WHERE rtf01 = g_rtf.rtf01
   IF l_rtf04 IS NULL THEN LET l_rtf04 = 0 END IF
   IF l_rtf04 != 0 THEN
      CALL cl_err('','art-863',0)
      RETURN
   END IF

   IF NOT cl_confirm('aim-302') THEN RETURN END IF

   BEGIN WORK
   OPEN i121_cl USING g_rtf.rtf01
   IF STATUS THEN
      CALL cl_err("OPEN i121_cl:", STATUS, 1)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i121_cl INTO g_rtf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rtf.rtf01,SQLCA.sqlcode,0)
      CLOSE i121_cl ROLLBACK WORK RETURN
   END IF

   UPDATE rtf_file SET rtfconf='N',
                       #rtfcond=NULL,       #CHI-D20015 mark
                       #rtfconu=NULL        #CHI-D20015 mark
                       rtfcond=g_today,     #CHI-D20015 add
                       rtfconu=g_user       #CHI-D20015 add
     WHERE rtf01=g_rtf.rtf01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   COMMIT WORK

   SELECT * INTO g_rtf.* FROM rtf_file WHERE rtf01=g_rtf.rtf01
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rtf.rtfconu    #CHI-D20015 add
   DISPLAY BY NAME g_rtf.rtfconf
   DISPLAY BY NAME g_rtf.rtfcond
   DISPLAY BY NAME g_rtf.rtfconu
   #DISPLAY '' TO FORMONLY.rtfconu_desc         #CHI-D20015 mark 
   DISPLAY l_gen02 TO FORMONLY.rtfconu_desc     #CHI-D20015 add
    #CKP
   IF g_rtf.rtfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_rtf.rtfconf,"","","",g_chr,"")

   CALL cl_flow_notify(g_rtf.rtf01,'V')

END FUNCTION
#FUN-B80177  add END

#FUN-960130
