# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt830.4gl
# Descriptions...: 初盤點維護作業－現有庫存
# Date & Author..: 08/08/06 No.FUN-870155 By xiaofeizhu
# Modify.........: No.FUN-8A0147 08/12/08 By douzh 批序號-盤點調整參數傳入邏輯
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-940074 09/05/25 By Pengu 只有需要做批序號的料件才需要呼叫s_lotcheck
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AA0119 10/10/22 By houlia 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/11/02 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.MOD-AC0243 10/12/21 By sabrina 若單別設定超過3碼，則產生出來的單號會多一碼
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.MOD-B70016 11/07/08 By Vampire 修改 IF ~ END IF 判斷式
# Modify.........: No.MOD-B70015 11/07/08 By Vampire 將t830_mul_unit()裡取ima906欄位
# Modify.........: No.FUN-B70032 11/08/11 By jason 刻號/BIN盤點
# Modify.........: No:FUN-BB0086 11/12/12 By tanxc 增加數量欄位小數取位 
# Modify.........: No.MOD-C20216 12/02/28 By Elise 修改點選批序號盤點查詢時，若無庫存資料，點選第二次會跳出錯誤訊息
# Modify.........: No:MOD-C60184 12/06/21 By bart  pia16='Y' 可執行lotcheck
# Modify.........: No:FUN-CB0087 12/12/13 By qiull 庫存單據理由碼改善
# Modify.........: No:TQC-D10103 13/01/30 By qiull 理由碼檢查放在必輸條件下
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No.TQC-D20047 13/02/27 By qiull 修改理由碼改善測試問題
# Modify.........: No:TQC-DB0056 13/11/25 By wangrr 標籤編號欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pia   RECORD LIKE pia_file.*,
    g_pia_t RECORD LIKE pia_file.*,
    g_pia_o RECORD LIKE pia_file.*,
    g_pia01_t LIKE pia_file.pia01,
    g_peo               LIKE pia_file.pia44,
    g_peo_t,g_peo_o     LIKE pia_file.pia44,
    g_tagdate           LIKE pia_file.pia45,
    g_tagdate_o         LIKE pia_file.pia45,
    g_tagdate_t         LIKE pia_file.pia45,
    g_wc,g_sql          string,  
    g_qty               LIKE pia_file.pia30,
    g_argv1             LIKE type_file.chr1,    
    g_t1                LIKE type_file.chr1,    
    g_before_input_done LIKE type_file.num5,    
    g_ima906            LIKE ima_file.ima906,  
    g_ima25             LIKE ima_file.ima25
DEFINE p_row,p_col      LIKE type_file.num5     
 
DEFINE g_forupd_sql STRING   
DEFINE g_chr            LIKE type_file.chr1     
DEFINE g_cnt            LIKE type_file.num10    
DEFINE g_msg            LIKE type_file.chr1000  
DEFINE g_row_count      LIKE type_file.num10    
DEFINE g_curs_index     LIKE type_file.num10    
DEFINE g_jump           LIKE type_file.num10    
DEFINE mi_no_ask        LIKE type_file.num5     
DEFINE g_no_ep_1        LIKE type_file.num5
DEFINE g_qty_t          LIKE pia_file.pia30    #No.FUN-8A0147
DEFINE l_y              LIKE type_file.chr1    #No.FUN-8A0147
DEFINE l_qty            LIKE pia_file.pia30    #No.FUN-8A0147
DEFINE g_pia09_t        LIKE pia_file.pia09    #No.FUN-BB0086
DEFINE g_azf03          LIKE azf_file.azf03    #FUN-CB0087

MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   IF g_argv1 = '1' THEN
      LET g_prog="aimt830"
   ELSE
      LET g_prog="aimt831"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time 
    INITIALIZE g_pia.* TO NULL
    INITIALIZE g_pia_t.* TO NULL
    INITIALIZE g_pia_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM pia_file WHERE pia01 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t830_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_tagdate=g_today
    LET g_peo=g_user 
 
    LET p_row = 3 LET p_col = 27
 
    OPEN WINDOW t8301_w AT p_row,p_col WITH FORM "aim/42f/aimt8301" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_set_locale_frm_name("aimt8301")
    CALL cl_ui_init()
    CALL cl_set_comp_required("pia70",g_aza.aza115='Y')        #FUN-CB0087 add
    CALL cl_set_comp_visible("pia930,gem02",g_aaz.aaz90='Y') 
    #FUN_B70032 --START--
    IF s_industry('icd') THEN
       CALL cl_set_act_visible("icdcheck,icd_checking",TRUE)
    ELSE
       CALL cl_set_act_visible("icdcheck,icd_checking",FALSE)
    END if 
    #FUN_B70032 --END--
 
    WHILE TRUE
      LET g_action_choice=""
    CALL t830_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t8301_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t830_cs()
    CLEAR FORM
    INITIALIZE g_pia.* TO NULL
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        pia01, pia19, pia16, pia02, pia03, pia04, pia05,
        pia06, pia09, pia07, pia931,pia930,pia70       #FUN-930122 Add pia931  #FUN-CB0087 add>pia70
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
            CASE
               #TQC-DB0056--add--str--
               WHEN INFIELD(pia01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  ='c'
                  LET g_qryparam.form = "q_pia01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia01
                  NEXT FIELD pia01
               #TQC-DB0056--add--end
               WHEN INFIELD(pia02) #查詢料件編號
#FUN-AA0059 --Begin--
            #      CALL cl_init_qry_var()
            #      LET g_qryparam.state    = "c"
            #      LET g_qryparam.form     ="q_ima"
            #      CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO pia02 
		  CALL t830_pia02('a')
                  NEXT FIELD pia02
               WHEN INFIELD(pia03) #倉庫
#TQC-AA0119 --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state    = "c"
#                 LET g_qryparam.form     ="q_imd"
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
#TQC-AA0119 --end
                  DISPLAY g_qryparam.multiret TO pia03 
                  NEXT FIELD pia03
               WHEN INFIELD(pia07) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     ="q_aag"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia07 
                  NEXT FIELD pia07
               WHEN INFIELD(pia09) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_gfe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia09 
                  NEXT FIELD pia09
               WHEN INFIELD(peo) #初盤人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO peo
    		  CALL t830_peo('d')
                  NEXT FIELD peo
                 #--No.MOD-4A0248--# 
                WHEN INFIELD(pia04) #儲位
#TQC-AA0119  --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state    = "c"
#                 LET g_qryparam.form     = "q_ime"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
#TQC-AA0119  --end
                  DISPLAY g_qryparam.multiret TO pia04
                  NEXT FIELD pia04 
                WHEN INFIELD(pia05) #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_img"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia05
                  NEXT FIELD pia05
                #-------END--------#
                WHEN INFIELD(pia930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_pia.pia930
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia930
                  NEXT FIELD pia930
                #FUN-930122--Begin--#  
                WHEN INFIELD(pia931)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pia931"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_pia.pia931
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia931
                  NEXT FIELD pia931
               #FUN-930122--End--#                                                     
               #FUN-CB0087---add---str---
               WHEN INFIELD(pia70)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     ="q_azf41"
                  LET g_qryparam.default1 = g_pia.pia70
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia70
                  NEXT FIELD pia70
               #FUN-CB0087---add---end---
               OTHERWISE EXIT CASE
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
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
 
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT pia01 FROM pia_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED,
		" ORDER BY pia01"
    PREPARE t830_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t830_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t830_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pia_file WHERE ",g_wc CLIPPED
    PREPARE t830_precount FROM g_sql
    DECLARE t830_count CURSOR FOR t830_precount
END FUNCTION
 
FUNCTION t830_menu()
    MENU ""
 
        BEFORE MENU
 
            IF g_sma.sma115 = 'N' THEN
               CALL cl_set_act_visible("multi_unit_taking",FALSE)
            ELSE
               CALL cl_set_act_visible("multi_unit_taking",TRUE)
            END IF
 
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
            IF g_prog="aimt831" THEN
               HIDE OPTION "insert"
            END IF
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t830_q()
            END IF
 
        ON ACTION next 
            CALL t830_fetch('N') 
 
        ON ACTION previous 
            CALL t830_fetch('P')
        ON ACTION register 
            CALL t830_u()
        ON ACTION quick_input 
            LET g_action_choice="quick_input" 
            IF cl_chk_act_auth() THEN
               CALL t830_z() 
            END IF
 
        ON ACTION multi_unit_taking
            IF g_argv1='1' THEN
               LET g_sql = "aimt822"," '",g_pia.pia01 CLIPPED,"'"
            ELSE
               LET g_sql = "aimt823"," '",g_pia.pia01 CLIPPED,"'"
            END IF
            CALL cl_cmdrun_wait(g_sql)
            CALL t830_mul_unit('Y')
 
#No.FUN-8A0147--begin
        ON ACTION lot_checking
            LET g_action_choice = "lot_checking"         #MOD-C20216 add
            IF NOT cl_chk_act_auth() THEN RETURN END IF
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM pias_file
             WHERE pias01=g_pia.pia01
            IF g_cnt= 0 THEN RETURN END IF
            CALL s_lotcheck(g_pia.pia01,g_pia.pia02, 
                            g_pia.pia03,g_pia.pia04, 
                            g_pia.pia05,g_qty,'QRY')
                  RETURNING l_y,l_qty                 
            IF l_y = 'Y' THEN                        
               LET g_qty = l_qty          
            END IF                                 
#No.FUN-8A0147--begin
 
        #FUN-B70032 --START--
        ON ACTION icd_checking
           LET g_action_choice="icd_checking"
           IF NOT cl_chk_act_auth() THEN RETURN END IF
           LET g_cnt=0
           SELECT COUNT(*) INTO g_cnt FROM piad_file
            WHERE piad01=g_pia.pia01
           IF g_cnt= 0 THEN RETURN END IF
           CALL s_icdcount(g_pia.pia01,g_pia.pia02, 
                           g_pia.pia03,g_pia.pia04, 
                           g_pia.pia05,g_qty,'QRY')
                 RETURNING l_y,l_qty                            
        #FUN-B70032 --END--     
 
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
            CALL cl_set_field_pic("","",g_pia.pia19,"","","")
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t830_fetch('/')
        ON ACTION first
            CALL t830_fetch('F')
        ON ACTION last
            CALL t830_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()     
 
            LET g_action_choice = "exit"
          CONTINUE MENU
          
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_pia.pia01 IS NOT NULL THEN
                 LET g_doc.column1 = "pia01"
                 LET g_doc.value1 = g_pia.pia01
                 CALL cl_doc()
              END IF
          END IF          
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t830_cs
END FUNCTION
 
FUNCTION t830_z()		#quick_input     
 DEFINE l_msg1,l_msg2  VARCHAR(60)
 DEFINE l_pia16 LIKE pia_file.pia16 
 DEFINE l_pia19 LIKE pia_file.pia19
 DEFINE l_no_ep LIKE type_file.num5 
 DEFINE l_i     SMALLINT 
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
 
    IF g_pia.pia19 ='Y' THEN
       CALL cl_err(g_pia.pia01,'mfg0132',0) RETURN
    END IF
    
    LET l_no_ep=LENGTH(g_pia.pia01)
     IF l_no_ep = 0 OR cl_null(l_no_ep) THEN
        LET l_no_ep = 16
     END IF    
 
    CLEAR FORM                                      # 清螢墓欄位內容
    INITIALIZE g_pia.* LIKE pia_file.*
    LET g_pia01_t = NULL
    LET g_peo_o   = NULL
    LET g_tagdate_o = NULL
    LET l_msg1 = 'Del:register結束,<^F>:欄位說明'
    LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       MESSAGE l_msg1,l_msg2
   ELSE
       DISPLAY l_msg1 AT 1,1
       DISPLAY l_msg2 AT 2,1
   END IF
    LET l_i=0 
    WHILE TRUE
     #MOD-AC0243---modify---start---
     #CASE l_no_ep
     #  WHEN 5  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&'
     #  WHEN 6  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&'
     #  WHEN 7  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&'
     #  WHEN 8  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&'
     #  WHEN 9  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&'
     #  WHEN 10 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&'
     #  WHEN 11 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&'
     #  WHEN 12 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&'
     #  WHEN 13 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&'
     #  WHEN 14 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&'
     #  WHEN 15 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&&'
     #  WHEN 16 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
     #                            g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&&&'
      CASE g_no_sp
        WHEN 5  
           IF l_no_ep = 12 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&'
           END IF
           IF l_no_ep = 13 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&'
           END IF
           IF l_no_ep = 14 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&'
           END IF
        WHEN 6  
           IF l_no_ep = 13 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&'
           END IF
           IF l_no_ep = 14 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&'
           END IF
           IF l_no_ep = 15 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&'
           END IF
        WHEN 7  
           IF l_no_ep = 14 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&'
           END IF
           IF l_no_ep = 15 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&'
           END IF
           IF l_no_ep = 16 THEN
              LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
                                g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&'
           END IF
     #MOD-AC0243---modify---end---
      END CASE                                                                                                                                                                                                                                                                                                                                                                                                                                                       
 
        LET l_i=1 
 
        SELECT pia16,pia19 INTO l_pia16,l_pia19 FROM pia_file
        WHERE pia01=g_pia.pia01
        LET g_pia.pia16 = l_pia16
        LET g_pia.pia19 = l_pia19
 
        CLEAR FORM                                  # 清螢墓欄位內容
        CALL t830_i("z")                            # 各欄位輸入
        LET l_no_ep = g_no_ep_1
        IF INT_FLAG THEN                            # 若按了DEL鍵
            LET INT_FLAG = 0
 
            INITIALIZE g_pia.* TO NULL
            LET g_pia.*=g_pia_o.*         
            INITIALIZE g_pia_o.* TO NULL 
            LET g_qty     = NULL
            LET g_peo     = NULL
            LET g_tagdate = NULL
            CALL t830_show()             
            EXIT WHILE
        END IF
        IF g_pia.pia01 IS NULL THEN                 # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_pia.pia03 IS NULL THEN LET g_pia.pia03 = ' ' END IF
        IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
        IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
        IF g_argv1 = '1' THEN 
            LET g_pia.pia30 = g_qty
            LET g_pia.pia31 = g_user
            LET g_pia.pia32 = g_today
            LET g_pia.pia33 = TIME  
            LET g_pia.pia34 = g_peo
            LET g_pia.pia35 = g_tagdate
        ELSE 
            LET g_pia.pia40 = g_qty
            LET g_pia.pia41 = g_user
            LET g_pia.pia42 = g_today
            LET g_pia.pia43 = TIME
            LET g_pia.pia44 = g_peo
            LET g_pia.pia45 = g_tagdate
        END IF
        UPDATE pia_file SET pia_file.* = g_pia.*    # 更新DB
            WHERE pia01 = g_pia.pia01               # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pia_file",g_pia_t.pia01,"",SQLCA.sqlcode,"","",1)   
            CONTINUE WHILE
        END IF
        LET g_pia_t.* = g_pia.*                # 保存上筆資料
        LET g_pia_o.* = g_pia.*                # 保存上筆資料
        LET g_tagdate_t = g_tagdate
        LET g_peo_t     = g_peo
        CLEAR FORM                                      # 清螢墓欄位內容
        INITIALIZE g_pia.* TO NULL
        INITIALIZE g_pia_o.* TO NULL
        LET g_qty = ' '
        LET g_peo = ' '
        LET g_tagdate = ' '
    END WHILE
END FUNCTION
 
FUNCTION t830_i(p_cmd)
    DEFINE
        p_cmd           VARCHAR(1),
        l_flag          VARCHAR(1),               #判斷必要欄位是否有輸入
		l_ime09         LIKE ime_file.ime09,
        l_mesg,l_str    VARCHAR(80),
        l_n             SMALLINT,
        l_pia16         LIKE pia_file.pia16,
        l_pia19         LIKE pia_file.pia19
    DEFINE l_cnt1          LIKE type_file.num5    #No.MOD-940074 add
    DEFINE l_ima918     LIKE ima_file.ima918  #MOD-C60184
    DEFINE l_ima921     LIKE ima_file.ima921  #MOD-C60184
    DEFINE l_sql        STRING                #FUN-CB0087
    DEFINE l_where      STRING                #FUN-CB0087
 
    IF g_sma.sma115='Y' AND p_cmd='z' THEN
       CALL t830_pia01(p_cmd)
    END IF
 
    INPUT g_pia.pia01,g_pia.pia02,g_pia.pia03,g_pia.pia04,
          g_pia.pia05,g_pia.pia06,g_pia.pia09,g_pia.pia07,
          g_qty,g_tagdate,g_peo,g_pia.pia930,g_pia.pia70      #FUN-CB0087 add>pia70
          WITHOUT DEFAULTS 
      FROM pia01,pia02,pia03,pia04,
           pia05,pia06,pia09,pia07,
           qty,tagdate,peo,pia930,pia70               #FUN-CB0087 add>pia70
 
      BEFORE INPUT                                                              
         LET g_before_input_done = FALSE                                        
          CALL t830_set_entry(p_cmd)                                              
          CALL t830_set_no_entry(p_cmd)                                       
         LET g_before_input_done = TRUE  
         #No.FUN-BB0086--add--begin--
         IF p_cmd = 'u' THEN 
            LET g_pia09_t = g_pia.pia09   
            LET g_qty_t = g_qty
         END IF 
         IF p_cmd = 'a' THEN 
            LET g_pia09_t = NULL
            LET g_qty_t = NULL 
         END IF 
         #No.FUN-BB0086--add--end--
 
        BEFORE FIELD pia01
 
        AFTER FIELD pia01 
          #IF p_cmd='z' #AND g_pia.pia01 IS NULL OR g_pia.pia01 = ' '
           IF p_cmd='z' AND g_pia.pia01 IS NULL OR g_pia.pia01 = ' '
              THEN NEXT FIELD pia01
           END IF
           CALL t830_pia01(p_cmd)
           IF NOT cl_null(g_errno)  THEN
           #  IF g_errno = '9028' OR '9038' THEN               #MOD-B70016 mark
              IF g_errno = '9028' OR g_errno = '9038' THEN     #MOD-B70016 add
                 CALL cl_err(g_pia.pia02,g_errno,1)
              ELSE   
                 CALL cl_err(g_pia.pia01,'mfg0114',0)
              END IF
              IF p_cmd='u' THEN
                 RETURN
              ELSE
              	 NEXT FIELD pia01  
              END IF                    
           END IF
 
           SELECT pia16,pia19 INTO l_pia16,l_pia19 FROM pia_file
           WHERE pia01=g_pia.pia01
           LET g_pia.pia16 = l_pia16
           LET g_pia.pia19 = l_pia19
           DISPLAY BY NAME g_pia.pia16,g_pia.pia19
           CALL t830_set_entry(p_cmd)
           CALL t830_set_no_entry(p_cmd)
 
           IF g_pia.pia19 ='Y' THEN 
              CALL cl_err(g_pia.pia01,'mfg0132',0) 
              EXIT INPUT
           END IF
           LET g_pia_o.pia02 = g_pia.pia02
           LET g_no_ep_1 = LENGTH(g_pia.pia01)
            IF g_no_ep_1 = 0 OR cl_null(g_no_ep_1) THEN
               LET g_no_ep_1 = 16
            END IF           
 
        BEFORE FIELD pia02
	    IF g_sma.sma60 = 'Y' THEN                # 若須分段輸入
	       CALL s_inp5(7,23,g_pia.pia02) RETURNING g_pia.pia02
	       DISPLAY BY NAME g_pia.pia02
               IF INT_FLAG THEN LET INT_FLAG = 0 END IF
            END IF
 
        AFTER FIELD pia02      #料件編號
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_pia.pia02) THEN
               IF NOT s_chk_item_no(g_pia.pia02,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_pia.pia02= g_pia_t.pia02
                  NEXT FIELD pia02
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_pia_o.pia02 IS NULL OR 
                (g_pia_o.pia02 != g_pia.pia02) 
            THEN CALL t830_pia02('a')
                 IF NOT cl_null(g_errno)  THEN 
                    CALL cl_err(g_pia.pia02,g_errno,1)
                    LET g_pia.pia02 = g_pia_o.pia02
                    DISPLAY BY NAME g_pia.pia02
                    NEXT FIELD pia02
                 END IF
            END IF
			#使用者為單倉時，只須檢查盤點資料檔中是否有此料號
			IF g_sma.sma12 = 'N' THEN
			   SELECT COUNT(*) INTO l_n FROM pia_file
         				  WHERE pia02=g_pia.pia02 
			    IF l_n IS NOT NULL AND l_n > 0 THEN
			       CALL cl_err(g_pia.pia02,'mfg0131',1)
                   LET g_pia.pia02 = g_pia_o.pia02
                   DISPLAY BY NAME g_pia.pia02
                   NEXT FIELD pia02
                END IF
            END IF
            LET g_pia_o.pia02 = g_pia.pia02
 
        #倉庫編號  
        AFTER FIELD pia03 
            #---->依系統參數的設定,檢查倉庫的使用
            IF NOT s_stkchk(g_pia.pia03,'A') THEN 
                CALL cl_err(g_pia.pia03,'mfg6076',1)    
                LET g_pia.pia03 = g_pia_o.pia03
                DISPLAY BY NAME g_pia.pia03
                NEXT FIELD pia03
            END IF
#TQC-AA0119 --add    
            IF NOT s_chk_ware(g_pia.pia03) THEN
               NEXT FIELD pia03
            END IF   
#TQC-AA0119 --end  
            LET g_pia_o.pia03 = g_pia.pia03
                   
        AFTER FIELD pia04  #儲位
            IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
            IF g_pia.pia04 IS NOT NULL AND g_pia.pia04 != ' ' THEN
                    DISPLAY BY NAME g_pia.pia07
               #---->檢查料件儲位的使用
               CALL s_prechk(g_pia.pia02,g_pia.pia03,g_pia.pia04)
                    RETURNING g_cnt,g_chr  
                    IF NOT g_cnt THEN
                       CALL cl_err(g_pia.pia04,'mfg1102',1)
                       LET g_pia.pia04 = g_pia_o.pia04
                       DISPLAY BY NAME g_pia.pia04
                       NEXT FIELD pia04
                    END IF
            END IF
            LET g_pia_o.pia04 = g_pia.pia04
 
 
        AFTER FIELD pia05  #批號
            IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
            #---->資料是否重複檢查
            IF g_pia.pia02 != g_pia_t.pia02 or g_pia_t.pia02 is null  
               or g_pia.pia03 != g_pia_t.pia03 or g_pia_t.pia03 is null  
               or g_pia.pia04 != g_pia_t.pia04 or g_pia_t.pia04 is null  
               or g_pia.pia05 != g_pia_t.pia05 or g_pia_t.pia05 is null  
            THEN SELECT COUNT(*) INTO l_n
      		     FROM pia_file
                WHERE pia02=g_pia.pia02 
                  AND pia03=g_pia.pia03
     		  AND pia04=g_pia.pia04
                  AND pia05=g_pia.pia05
                  AND pia19 != 'Y' #BugNo:4390
   	  	         	IF l_n > 0 THEN
   	  	            CALL cl_err(g_pia.pia05,'mfg0131',1)
                    LET g_pia.pia05 = g_pia_o.pia05
                    DISPLAY BY NAME g_pia.pia05
                    NEXT FIELD pia02
                  END IF
            END IF
            LET g_pia_o.pia05 = g_pia.pia05
 
 
        AFTER FIELD pia09 
          IF g_pia.pia09 IS NOT NULL OR g_pia.pia09 != ' ' THEN
               IF g_pia_o.pia09 IS NULL OR (g_pia.pia09 !=g_pia_o.pia09) 
               THEN CALL t830_unit('a') 
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pia.pia09,g_errno,1)
                       LET g_pia.pia09 = g_pia_o.pia09
                       DISPLAY BY NAME g_pia.pia09
                       NEXT FIELD pia09
                    END IF
               END IF
            END IF
            CALL s_umfchk(g_pia.pia02,g_pia.pia09,g_ima25)
                 RETURNING g_cnt,g_pia.pia10
            IF g_cnt THEN 
               CALL cl_err('','mfg3075',1)
               LET g_pia.pia09 = g_pia_o.pia09
               DISPLAY BY NAME g_pia.pia09
               NEXT FIELD pia09
            END IF
            IF g_pia.pia10 IS NULL OR g_pia.pia10 = ' '
            THEN LET g_pia.pia10 = 1
            END IF
            LET g_pia_o.pia09 = g_pia.pia09
            #No.FUN-BB0086---add--start--
            IF g_sma.sma115='Y' AND g_ima906='2' THEN
               LET g_qty = s_digqty(g_qty,g_pia.pia09)
               DISPLAY g_qty TO FORMONLY.qty
            ELSE 
               IF NOT t830_qty_check(l_cnt1) THEN 
                  LET g_pia09_t = g_pia.pia09
                  NEXT FIELD qty
               END IF 
            END IF 
            LET g_pia09_t = g_pia.pia09
            #No.FUN-BB0086---add--end--
 
        AFTER FIELD pia07  
            IF g_pia.pia07 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_pia.pia07,g_aza.aza81) THEN
                     #FUN-B10049--begin
                     #CALL cl_err(g_pia.pia07,'mfg0018',1)
                     CALL cl_err(g_pia.pia07,'mfg0018',0)
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_pia.pia07  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_aza.aza81  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_pia.pia07 CLIPPED,"%' "            
                     CALL cl_create_qry() RETURNING g_pia.pia07
                     DISPLAY BY NAME g_pia.pia07  
                     #FUN-B10049--end                        
                     NEXT FIELD pia07 
                  END IF
               END IF
            END IF
        #FUN-CB0087---add---str---
        BEFORE FIELD pia70
           IF g_aza.aza115 = 'Y' AND cl_null(g_pia.pia70) THEN
              CALL s_reason_code(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,g_peo,'') RETURNING g_pia.pia70
              CALL t830_pia70()
              DISPLAY BY NAME g_pia.pia70
           END IF

        AFTER FIELD pia70
           IF g_pia.pia70 IS NOT NULL THEN
              LET l_n = 0
              CALL s_get_where(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,g_peo,'') RETURNING l_flag,l_where
              IF g_aza.aza115='Y' AND l_flag THEN
                 LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pia.pia70,"' AND ",l_where
                 PREPARE ggc08_pre FROM l_sql
                 EXECUTE ggc08_pre INTO l_n
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD pia70
                 END IF
              ELSE
                 SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_pia.pia70 AND azf02='2'
                 IF l_n < 1 THEN 
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD pia70
                 END IF
              END IF
          END IF              #TQC-D20047---add---
          CALL t830_pia70()
          #END IF              #TQC-D20047---mark---
        #FUN-CB0087---add---end---           
 
        BEFORE FIELD qty
            IF g_sma.sma115='Y' THEN
               LET g_ima906=NULL
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01=g_pia.pia02
 
               IF (g_ima906='2') OR (g_ima906='3') THEN 
                  IF g_argv1='1' THEN
                     LET g_sql = "aimt822"," '",g_pia.pia01 CLIPPED,"'"
                  ELSE
                     LET g_sql = "aimt823"," '",g_pia.pia01 CLIPPED,"'"
                  END IF
                  CALL cl_cmdrun_wait(g_sql)
                  CALL t830_mul_unit('N')
                  CALL t830_set_entry(p_cmd)
                  CALL t830_set_no_entry(p_cmd)
               END IF
            END IF
 
        AFTER FIELD qty
           IF NOT t830_qty_check(l_cnt1) THEN NEXT FIELD qty END IF   #No.FUN-BB0086
           
            ##No.FUN-8A0147--begin
            #IF NOT cl_null(g_qty) THEN
            #   IF g_qty < 0 THEN 
            #      LET g_qty = g_qty_t
            #      NEXT FIELD qty
            #   END IF 
            #   IF g_qty != g_qty_t OR g_qty_t IS NULL THEN
            #     #-----------No.MOD-940074 add
            #      LET l_cnt1=0
            #      SELECT COUNT(*) INTO l_cnt1 FROM pias_file
            #       WHERE pias01=g_pia.pia01
            #      IF l_cnt1 > 0 THEN
            #     #-----------No.MOD-940074 end
            #         CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
            #                         g_pia.pia03,g_pia.pia04,
            #                         g_pia.pia05,g_qty,'SET')
            #              RETURNING l_y,l_qty  
            #      END IF      #No.MOD-940074 add
            #      
            #      #FUN-B70032 --START--
            #      IF s_industry('icd') THEN
            #         LET l_cnt1=0
            #         SELECT COUNT(*) INTO l_cnt1 FROM piad_file
            #          WHERE piad01=g_pia.pia01
            #         IF l_cnt1 > 0 THEN
            #            CALL s_icdcount(g_pia.pia01,g_pia.pia02,
            #                            g_pia.pia03,g_pia.pia04,
            #                            g_pia.pia05,g_qty,'SET')
            #                 RETURNING l_y,l_qty
            #         END IF
            #      END IF    
            #      #FUN-B70032 --END--
            #   END IF
            #   IF l_y = 'Y' THEN   
            #      LET g_qty = l_qty
            #      LET g_qty_t = g_qty   #FUN-B70032                
            #      DISPLAY g_qty TO FORMONLY.qty
            #   END IF
            #END IF 
            ##No.FUN-8A0147--end
 
       AFTER FIELD peo    
            IF g_peo IS NOT NULL AND g_peo !=' ' THEN   
               CALL t830_peo('a')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err(g_peo,g_errno,0)
                  LET g_peo = g_peo_o
                  DISPLAY g_peo TO FORMONLY.peo
                  NEXT FIELD peo  
                END IF
            END IF  
            IF g_peo IS NOT NULL THEN LET g_peo_o = g_peo END IF
                   
       AFTER FIELD tagdate #盤點日期 
          IF g_tagdate IS NULL THEN
			 LET g_tagdate = g_today
             DISPLAY g_tagdate TO FORMONLY.tagdate
             NEXT FIELD tagdate
          END IF
          IF g_tagdate IS NOT NULL THEN LET g_tagdate_o = g_tagdate END IF
 
       AFTER FIELD pia930
          IF NOT s_costcenter_chk(g_pia.pia930) THEN
             LET g_pia.pia930=g_pia_t.pia930
             DISPLAY NULL TO FORMONLY.gem02
             DISPLAY BY NAME g_pia.pia930
             NEXT FIELD pia930
          ELSE
             DISPLAY s_costcenter_desc(g_pia.pia930) TO FORMONLY.gem02
          END IF                   
			
        AFTER INPUT
          IF g_pia.pia03 IS NULL THEN LET g_pia.pia03 = ' ' END IF
          IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
          IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
          LET l_flag='N'
          IF INT_FLAG THEN EXIT INPUT  END IF
 
          IF cl_null(g_pia.pia10) THEN LET l_flag='Y' END IF
          IF l_flag='Y' THEN 
             CALL cl_err('','mfg2719',0) NEXT FIELD pia09 
          END IF
          LET l_flag='N'
 
          IF g_pia.pia02 IS NULL OR g_pia.pia02 = ' ' THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_pia.pia02 
          END IF    
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD pia02
          END IF
          IF g_aza.aza115 = 'Y' THEN                  #TQC-D10103---add---
             #FUN-CB0087---add---str---
             LET l_n = 0
             CALL s_get_where(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,g_peo,'') RETURNING l_flag,l_where
             IF g_aza.aza115='Y' AND l_flag AND NOT cl_null(g_pia.pia70) THEN
                LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pia.pia70,"' AND ",l_where
                PREPARE ggc08_pre1 FROM l_sql
                EXECUTE ggc08_pre1 INTO l_n
                IF l_n < 1 THEN
                   CALL cl_err('','aim-425',0)
                   NEXT FIELD pia70
                END IF
             ELSE
                SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_pia.pia70 AND azf02='2'
                IF l_n < 1 THEN
                   CALL cl_err('','aim-425',0)
                   NEXT FIELD pia70
                END IF
             END IF
             #FUN-CB0087---add---end---
          END IF                                     #TQC-D10103---add---
          CALL t830_pia70()                          #TQC-D20042
 
        ON ACTION controlp
            CASE
               #TQC-DB0056--add--str--
               WHEN INFIELD(pia01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pia01"
                  CALL cl_create_qry() RETURNING g_pia.pia01
                  DISPLAY BY NAME g_pia.pia01
                  NEXT FIELD pia01
               #TQC-DB0056--add--end
               WHEN INFIELD(pia02) #查詢料件編號
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form     ="q_ima"
                #  LET g_qryparam.default1 = g_pia.pia02
                #  CALL cl_create_qry() RETURNING g_pia.pia02
                  CALL q_sel_ima(FALSE, "q_ima", "", g_pia.pia02, "", "", "", "" ,"",'' )  RETURNING g_pia.pia02
#FUN-AA0059 --End--
		  CALL t830_pia02('a')
                   DISPLAY BY NAME g_pia.pia02          
                  NEXT FIELD pia02
               WHEN INFIELD(pia03) #倉庫
#TQC-AA0119 --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     ="q_imd"
#                 LET g_qryparam.default1 = g_pia.pia03
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#                 CALL cl_create_qry() RETURNING g_pia.pia03
                  CALL q_imd_1(FALSE,TRUE,g_pia.pia03,"","","","") RETURNING g_pia.pia03
#TQC-AA0119 --end
                   DISPLAY BY NAME  g_pia.pia03         
                  NEXT FIELD pia03
               WHEN INFIELD(pia04) #儲位
#TQC-AA0119 --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     ="q_ime"
#                 LET g_qryparam.default1 = g_pia.pia04
#                  LET g_qryparam.arg1     = g_pia.pia03 #倉庫編號 
#                  LET g_qryparam.arg2     = 'SW'        #倉庫類別 
#                 CALL cl_create_qry() RETURNING g_pia.pia04
                  CALL q_ime_1(FALSE,TRUE,g_pia.pia04,g_pia.pia03,"",g_plant,"","","") RETURNING g_pia.pia04
#TQC-AA0119 --end
                   DISPLAY BY NAME g_pia.pia04           
                  NEXT FIELD pia04
               WHEN INFIELD(pia05) #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_img1"
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.default1 = g_pia.pia03
                  LET g_qryparam.default2 = g_pia.pia04
                  LET g_qryparam.default3 = g_pia.pia05
                  LET g_qryparam.arg1     = g_pia.pia02
                  IF g_pia.pia03 IS NOT NULL THEN
                     LET g_qryparam.where = " img02='",g_pia.pia03,"'"
                  END IF
                  IF g_pia.pia04 IS NOT NULL THEN
                     IF cl_null(g_qryparam.where) THEN
                       LET g_qryparam.where = "img03='",g_pia.pia04,"'"
                     ELSE
                       LET g_qryparam.where = g_qryparam.where CLIPPED,
                                              " AND img03='",g_pia.pia04,"'"
                     END IF
                  END IF
                  CALL cl_create_qry() RETURNING g_pia.pia03,g_pia.pia04,g_pia.pia05
                  DISPLAY BY NAME g_pia.pia03,g_pia.pia04,g_pia.pia05
               WHEN INFIELD(pia07) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_aag"
                  LET g_qryparam.default1 = g_pia.pia07
                  LET g_qryparam.arg1 = g_aza.aza81
                   CALL cl_create_qry() RETURNING g_pia.pia07 
                   DISPLAY BY NAME g_pia.pia07            
                  NEXT FIELD pia07
               WHEN INFIELD(pia09) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_pia.pia09
                  CALL cl_create_qry() RETURNING g_pia.pia09
                   DISPLAY BY NAME g_pia.pia09            
                  NEXT FIELD pia09
               #FUN-CB0087---add---str---
               WHEN INFIELD(pia70)
                  CALL s_get_where(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,g_peo,'') RETURNING l_flag,l_where
                  IF g_aza.aza115='Y' AND l_flag THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_pia.pia70
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_azf41"
                     LET g_qryparam.default1 = g_pia.pia70
                  END IF
                  CALL cl_create_qry() RETURNING g_pia.pia70
                  DISPLAY BY NAME g_pia.pia70
                  CALL t830_pia70()
                  NEXT FIELD pia70
               #FUN-CB0087---add---end---
               WHEN INFIELD(peo) #初盤人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.default1 = g_peo
                  CALL cl_create_qry() RETURNING g_peo
 		  CALL t830_peo('d')
                   DISPLAY BY NAME g_peo                  
                  NEXT FIELD peo
               WHEN INFIELD(pia930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_pia.pia930
                  DISPLAY BY NAME g_pia.pia930
                  NEXT FIELD pia930                                   
               OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION mntn_unit
             #WHEN INFIELD(pia09) #單位換算
                   CALL cl_cmdrun("aooi101 ")
 
       ON ACTION mntn_unit_conv
             #WHEN INFIELD(pia09) #單位換算
                   CALL cl_cmdrun("aooi102 ")
 
       ON ACTION mntn_item_unit_conv
             #WHEN INFIELD(pia09) #料件單位換算資料
                   CALL cl_cmdrun("aooi103")
   
 
       ON ACTION def_imf
             #WHEN INFIELD(pia03) #預設倉庫/ 儲位
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imf"
                LET g_qryparam.default1 = g_pia.pia03       
                LET g_qryparam.default2 = g_pia.pia04          
                LET g_qryparam.arg1     = g_pia.pia02
                LET g_qryparam.arg2     = "A"
                IF g_qryparam.arg2 != 'A' THEN
                   LET g_qryparam.where=g_qryparam.where CLIPPED, 
                                        " AND ime04 matches'",g_qryparam.arg2,"'"
                END IF
                CALL cl_create_qry() RETURNING g_pia.pia03,g_pia.pia04
                DISPLAY BY NAME g_pia.pia03,g_pia.pia04
                NEXT FIELD pia03 
 
#No.FUN-8A0147--begin
        ON ACTION lotcheck
           #MOD-C60184---begin
           IF g_pia.pia16 ='Y' THEN
              LET l_ima918 = 'N'
              LET l_ima921 = 'N'
              SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
               WHERE ima01=g_pia.pia02
              IF l_ima918 = 'Y' OR l_ima921 ='Y' THEN
                 CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
                                 g_pia.pia03,g_pia.pia04,
                                 g_pia.pia05,g_qty,'SET')
                      RETURNING l_y,l_qty  
              END IF 
           ELSE 
           #MOD-C60184---end
             #-----------No.MOD-940074 add
              LET l_cnt1=0
              SELECT COUNT(*) INTO l_cnt1 FROM pias_file
               WHERE pias01=g_pia.pia01
              IF l_cnt1 > 0 THEN
             #-----------No.MOD-940074 end
                 CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
                                 g_pia.pia03,g_pia.pia04,
                                 g_pia.pia05,g_qty,'SET')
                       RETURNING l_y,l_qty             
              END IF       #No.MOD-940074 add
           END IF  #MOD-C60184
           IF l_y = 'Y' THEN                    
              LET g_qty = l_qty      
           END IF                             
#No.FUN-8A0147--begin

        #FUN-B70032 --START--
        ON ACTION icdcheck          
           LET l_cnt1=0
           SELECT COUNT(*) INTO l_cnt1 FROM piad_file
            WHERE piad01=g_pia.pia01
           IF l_cnt1 > 0 THEN          
              CALL s_icdcount(g_pia.pia01,g_pia.pia02,
                              g_pia.pia03,g_pia.pia04,
                              g_pia.pia05,g_qty,'SET')
                    RETURNING l_y,l_qty             
           END IF       
           IF l_y = 'Y' THEN                    
              LET g_qty = l_qty
              LET g_qty_t = g_qty 
              DISPLAY g_qty TO FORMONLY.qty      
           END IF    
        #FUN-B70032 --END-- 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
    END INPUT
END FUNCTION
   
FUNCTION t830_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1   
 
   CALL cl_set_comp_entry("qty",TRUE)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pia01,pia02,pia03,pia04,pia05,pia06,pia09,pia07",TRUE)
   END IF
   IF p_cmd = 'u' AND (g_pia.pia16='Y') THEN
      CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07",TRUE)
   END IF
   IF p_cmd = 'z' THEN
      CALL cl_set_comp_entry("pia01",TRUE)
   END IF
   IF p_cmd = 'z' AND (g_pia.pia16='Y') THEN
      CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07",TRUE)
   END IF
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("qty",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t830_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pia01",FALSE)
   END IF
   IF g_pia.pia16 = 'N' AND ((p_cmd = 'u') OR (p_cmd = 'z'))THEN
     CALL cl_set_comp_entry("pia02,pia03,pia04,pia05,pia06,pia09,pia07",FALSE)
   END IF
   IF g_sma.sma12 = 'N' THEN
     CALL cl_set_comp_entry("pia03,pia04,pia05",FALSE)
   END IF
 
   IF INFIELD(qty) THEN
      IF g_sma.sma115='Y' AND g_ima906='2' THEN
         CALL cl_set_comp_entry("qty",FALSE)
      END IF
   END IF
  
END FUNCTION
 
 
FUNCTION t830_pia01(p_cmd)  
    DEFINE p_cmd	   LIKE type_file.chr1,   
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    IF p_cmd='a' THEN RETURN END IF
    SELECT pia_file.*, ima02,ima021,ima25,imaacti 
      INTO g_pia.*, l_ima02,l_ima021,g_ima25,l_imaacti 
      FROM pia_file, OUTER ima_file
      WHERE pia01 = g_pia.pia01 AND pia_file.pia02 = ima_file.ima01
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002' 
               LET g_pia.pia02  = NULL 
              LET g_pia.pia03 = NULL LET g_pia.pia04 = NULL
              LET g_pia.pia05 = NULL LET g_pia.pia06 = NULL 
              LET g_pia.pia07 = NULL LET g_pia.pia09 = NULL  
              LET l_ima02     = NULL LET l_ima021    = NULL 
              LET l_imaacti   = NULL
       WHEN l_imaacti='N'            LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]' LET g_errno = '9038'   	 
		OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
    LET g_pia_t.* = g_pia.* 
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pia.pia02,g_pia.pia03,g_pia.pia04,
                       g_pia.pia05,g_pia.pia06,g_pia.pia07,
                       g_pia.pia09
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       IF g_argv1 = '1' THEN 
          LET g_qty = g_pia.pia30
          LET g_peo     = g_pia.pia34
          LET g_tagdate = g_pia.pia35
          IF g_tagdate IS NULL OR g_tagdate = ' '
          THEN LET g_tagdate = g_tagdate_o
          END IF
          IF g_tagdate IS NULL OR g_tagdate = ' '
          THEN LET g_tagdate = g_today
          END IF
          IF g_peo IS NULL OR g_peo = '' 
          THEN LET g_peo = g_peo_o 
          END IF
          DISPLAY g_pia.pia30 TO FORMONLY.qty  
          DISPLAY g_peo      TO FORMONLY.peo
          DISPLAY g_tagdate  TO FORMONLY.tagdate
       ELSE 
          LET g_qty = g_pia.pia40
          LET g_peo     = g_pia.pia44
          LET g_tagdate = g_pia.pia45
          IF g_tagdate IS NULL OR g_tagdate = ' '
          THEN LET g_tagdate = g_tagdate_o
          END IF
          IF g_tagdate IS NULL OR g_tagdate = ' '
          THEN LET g_tagdate = g_today
          END IF
          IF g_peo IS NULL OR g_peo = '' THEN LET g_peo = g_peo_o END IF
          DISPLAY g_pia.pia40 TO FORMONLY.qty  
          DISPLAY g_peo      TO FORMONLY.peo
          DISPLAY g_tagdate  TO FORMONLY.tagdate
       END IF
       IF g_peo IS NOT NULL AND g_peo != ' ' THEN 
          CALL t830_peo('d')
       END IF
    END IF
END FUNCTION
   
FUNCTION t830_pia02(p_cmd)  #料件編號
    DEFINE p_cmd	   LIKE type_file.chr1,    
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
	LET l_ima02=' '
	LET l_ima021=' '
    SELECT ima02,ima021,ima08,ima25,imaacti INTO l_ima02,l_ima021,l_ima08,g_ima25,l_imaacti
           FROM ima_file WHERE ima01 = g_pia.pia02
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002' 
		        					LET l_ima02 = NULL 
    	WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'  	 
		OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
	END CASE
    CALL s_cost('1',l_ima08,g_pia.pia02) RETURNING g_pia.pia66 
    CALL s_cost('2',l_ima08,g_pia.pia02) RETURNING g_pia.pia67 
    CALL s_cost('3',l_ima08,g_pia.pia02) RETURNING g_pia.pia68 
    IF g_pia.pia08 IS NULL OR g_pia.pia08 =' '
    THEN LET g_pia.pia08 = 0
    END IF
    IF p_cmd = 'a' THEN LET g_pia.pia09 = g_ima25 END IF
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY BY NAME g_pia.pia09      
    END IF
END FUNCTION
 
#檢查單位是否存在於單位檔中
FUNCTION t830_unit(p_cmd)  
    DEFINE p_cmd	   LIKE type_file.chr1,    
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = g_pia.pia09
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
   
#盤點人員
FUNCTION t830_peo(p_cmd)  
    DEFINE p_cmd	   LIKE type_file.chr1,
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_peo
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION t830_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t830_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t830_count
    FETCH t830_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t830_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        INITIALIZE g_pia.* TO NULL
        INITIALIZE g_pia_o.* TO NULL
        LET g_qty     = NULL
        LET g_peo     = NULL
        LET g_tagdate = NULL
    ELSE
        CALL t830_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t830_fetch(p_flpia)
    DEFINE
        p_flpia          LIKE type_file.chr1
 
    CASE p_flpia
        WHEN 'N' FETCH NEXT     t830_cs INTO g_pia.pia01
        WHEN 'P' FETCH PREVIOUS t830_cs INTO g_pia.pia01
        WHEN 'F' FETCH FIRST    t830_cs INTO g_pia.pia01
        WHEN 'L' FETCH LAST     t830_cs INTO g_pia.pia01
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
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t830_cs INTO g_pia.pia01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        INITIALIZE g_pia.* TO NULL 
                
        RETURN
    ELSE
       CASE p_flpia
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_pia.* FROM pia_file   # 重讀DB,因TEMP有不被更新特性
       WHERE pia01 = g_pia.pia01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"","",1)   
    ELSE
 
        CALL t830_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t830_show()
    LET g_pia_t.* = g_pia.*
    LET g_pia_o.* = g_pia.*   
    DISPLAY BY NAME 
        g_pia.pia01,g_pia.pia16,g_pia.pia02,g_pia.pia03,g_pia.pia04,
        g_pia.pia05,g_pia.pia06,g_pia.pia09,
        g_pia.pia07,g_pia.pia19,g_pia.pia930,g_pia.pia931,        #FUN-930122 Add pia931
        g_pia.pia70                                               #FUN-CB0087 add
    IF g_argv1 = '1' THEN 
       LET g_qty     = g_pia.pia30
       LET g_peo     = g_pia.pia34
       LET g_tagdate = g_pia.pia35
       DISPLAY g_pia.pia30 TO FORMONLY.qty  
       DISPLAY g_tagdate   TO FORMONLY.tagdate
       DISPLAY g_peo       TO FORMONLY.peo
    ELSE 
       LET g_qty     = g_pia.pia40
       LET g_peo     = g_pia.pia44
       LET g_tagdate = g_pia.pia45
       DISPLAY g_pia.pia40 TO FORMONLY.qty  
       DISPLAY g_tagdate   TO FORMONLY.tagdate
       DISPLAY g_peo       TO FORMONLY.peo
    END IF
    IF g_peo IS NOT NULL THEN LET g_peo_o = g_peo END IF
    IF g_tagdate IS NOT NULL THEN LET g_tagdate_o = g_tagdate END IF
    CALL t830_pia02('d')
    CALL t830_peo('d')
    #FUN-CB0087---add---str---
    IF g_pia.pia70 IS NOT NULL THEN
       CALL t830_pia70()
    ELSE
       DISPLAY '' TO azf03
    END IF
    #FUN-CB0087---add---end---
    CALL cl_set_field_pic("","",g_pia.pia19,"","","")
    DISPLAY s_costcenter_desc(g_pia.pia930) TO FORMONLY.gem02
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t830_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pia.pia01 IS NULL THEN 
       CALL cl_err('',-400,0) RETURN 
    END IF
    SELECT * INTO g_pia.* FROM pia_file WHERE pia01=g_pia.pia01
    IF g_pia.pia19 ='Y' THEN 
       CALL cl_err(g_pia.pia01,'mfg0132',0) RETURN 
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pia01_t = g_pia.pia01
    LET g_qty_t = g_qty                 #No.FUN-8A0147
    BEGIN WORK
 
    OPEN t830_cl USING g_pia.pia01
    IF STATUS THEN
       CALL cl_err("OPEN t830_cl:", STATUS, 1)
       CLOSE t830_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t830_cl INTO g_pia.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t830_show()                          # 顯示最新資料
    IF g_tagdate_o IS NULL THEN LET g_tagdate_o = g_today END IF
    IF g_peo     IS NULL THEN LET g_peo = g_peo_o         END IF
    IF g_tagdate IS NULL THEN LET g_tagdate = g_tagdate_o END IF
    WHILE TRUE
        CALL t830_i("u")                      # 欄位更改
        CALL t830_pia02('d')                 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pia.*=g_pia_t.*
            CALL t830_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
{&}     IF g_pia.pia03 IS NULL THEN LET g_pia.pia03 = ' ' END IF
        IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
        IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
        LET g_pia.pia13 = g_today
        IF g_argv1 = '1' THEN 
            LET g_pia.pia30 = g_qty
            LET g_pia.pia31 = g_user
            LET g_pia.pia32 = g_today
            LET g_pia.pia33 = TIME  
            LET g_pia.pia34 = g_peo
            LET g_pia.pia35 = g_tagdate
        ELSE 
            LET g_pia.pia40 = g_qty
            LET g_pia.pia41 = g_user
            LET g_pia.pia42 = g_today
            LET g_pia.pia43 = TIME  
            LET g_pia.pia44 = g_peo
            LET g_pia.pia45 = g_tagdate
        END IF
        UPDATE pia_file SET pia_file.* = g_pia.*    # 更新DB
            WHERE pia01 = g_pia01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","pia_file",g_pia_t.pia01,"",SQLCA.sqlcode,"","",1)  
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t830_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t830_mul_unit(p_flag)
  DEFINE p_flag    LIKE type_file.chr1  #'Y/N'是否update pia_file 
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima25   LIKE ima_file.ima25  
  DEFINE l_pia10   LIKE pia_file.pia10  
 
#    SELECT ima25 INTO l_ima25 FROM pia_file,ima_file                      #MOD-B70015 mark
     SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM pia_file,ima_file      #MOD-B70015 add
       WHERE pia01=g_pia.pia01 AND ima01=pia02
    CALL s_umfchk(g_pia.pia02,l_ima25,g_pia.pia09)
         RETURNING g_cnt,l_pia10
    IF g_cnt THEN
       LET l_pia10=1
    END IF
 
 
    IF cl_null(g_pia.pia01) THEN RETURN END IF
    IF (l_ima906 = '2') OR (l_ima906='3') THEN 
       IF g_argv1='1' THEN
          SELECT SUM(piaa30*piaa10) INTO g_pia.pia30 FROM piaa_file
           WHERE piaa01=g_pia.pia01
             AND piaa02=g_pia.pia02
             AND piaa03=g_pia.pia03
             AND piaa04=g_pia.pia04
             AND piaa05=g_pia.pia05
             AND piaa30 IS NOT NULL
             AND piaa10 IS NOT NULL
          LET g_pia.pia30 = g_pia.pia30*l_pia10   
          LET g_pia.pia30 = s_digqty(g_pia.pia30,g_pia.pia09)   #No.FUN-BB0086
          IF p_flag='Y' OR p_flag='y' THEN 
             UPDATE pia_file SET pia30=g_pia.pia30
              WHERE pia01=g_pia.pia01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"",
                             "update pia",1)  
             END IF
          END IF
          LET g_qty=g_pia.pia30
       ELSE
          SELECT SUM(piaa40*piaa10) INTO g_pia.pia40 FROM piaa_file
           WHERE piaa01=g_pia.pia01
             AND piaa02=g_pia.pia02
             AND piaa03=g_pia.pia03
             AND piaa04=g_pia.pia04
             AND piaa05=g_pia.pia05
             AND piaa40 IS NOT NULL
             AND piaa10 IS NOT NULL
          LET g_pia.pia40 = g_pia.pia40*l_pia10
          LET g_pia.pia40 = s_digqty(g_pia.pia40,g_pia.pia09)   #No.FUN-BB0086   
          IF p_flag='Y' OR p_flag='y' THEN 
             UPDATE pia_file SET pia40=g_pia.pia40
              WHERE pia01=g_pia.pia01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"",
                             "update pia",1)   
             END IF
          END IF
          LET g_qty=g_pia.pia40
       END IF
    END IF
    DISPLAY g_qty TO FORMONLY.qty
END FUNCTION
#No.FUN-870155 

#No.FUN-BB0086--add--start--
FUNCTION t830_qty_check(l_cnt1)
DEFINE l_cnt1          LIKE type_file.num5
DEFINE l_ima918        LIKE ima_file.ima918   #MOD-C60184
DEFINE l_ima921        LIKE ima_file.ima921   #MOD-C60184
   IF NOT cl_null(g_qty) AND NOT cl_null(g_pia.pia09) THEN
      IF cl_null(g_qty_t) OR cl_null(g_pia09_t) OR g_qty_t != g_qty OR g_pia.pia09 != g_pia09_t THEN
         LET g_qty=s_digqty(g_qty,g_pia.pia09)
         DISPLAY g_qty TO FORMONLY.qty
      END IF
   END IF

   IF NOT cl_null(g_qty) THEN
      IF g_qty < 0 THEN 
         LET g_qty = g_qty_t
         RETURN FALSE 
      END IF 
      IF g_qty != g_qty_t OR g_qty_t IS NULL THEN
         #MOD-C60184---begin
         IF g_pia.pia16 ='Y' THEN
            LET l_ima918 = 'N'
            LET l_ima921 = 'N'
            SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
             WHERE ima01=g_pia.pia02
            IF l_ima918 = 'Y' OR l_ima921 ='Y' THEN
               CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
                               g_pia.pia03,g_pia.pia04,
                               g_pia.pia05,g_qty,'SET')
                      RETURNING l_y,l_qty  
            END IF 
         ELSE 
         #MOD-C60184---end
            LET l_cnt1=0
            SELECT COUNT(*) INTO l_cnt1 FROM pias_file
             WHERE pias01=g_pia.pia01
            IF l_cnt1 > 0 THEN
               CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
                               g_pia.pia03,g_pia.pia04,
                               g_pia.pia05,g_qty,'SET')
                    RETURNING l_y,l_qty  
            END IF 
         END IF  #MOD-C60184
         
         IF s_industry('icd') THEN
            LET l_cnt1=0
            SELECT COUNT(*) INTO l_cnt1 FROM piad_file
             WHERE piad01=g_pia.pia01
            IF l_cnt1 > 0 THEN
               CALL s_icdcount(g_pia.pia01,g_pia.pia02,
                               g_pia.pia03,g_pia.pia04,
                               g_pia.pia05,g_qty,'SET')
                    RETURNING l_y,l_qty
            END IF
         END IF    
      END IF
      IF l_y = 'Y' THEN   
         LET g_qty = l_qty
         LET g_qty_t = g_qty               
         DISPLAY g_qty TO FORMONLY.qty
      END IF
   END IF 
   RETURN TRUE 
END FUNCTION 
#No.FUN-BB0086--add--end--
#FUN-CB0087---add---str---
FUNCTION t830_pia70()
 IF g_pia.pia70 IS NOT NULL THEN
   SELECT azf03 INTO g_azf03
     FROM azf_file
    WHERE azf01 = g_pia.pia70
      AND azf02 = '2'
   DISPLAY g_azf03 TO azf03
 ELSE
   DISPLAY '' TO azf03
 END IF
END FUNCTION
#FUN-CB0087---add---end---

