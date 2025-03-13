# Prog. Version..: '5.30.06-13.04.09(00005)'     #
#
# Pattern name...: almi557.4gl
# Descriptions...: 會員紀念日換贈設定作業
# Date & Author..: FUN-BC0121 11/12/29 BY yuhuabao
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60032 12/06/28 By Lori 紀念日增加判斷lpc05 = 'Y'
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds

GLOBALS "../../config/top.global"

#全局變量定義--begin
DEFINE    g_lra              RECORD LIKE    lra_file.*,
          g_lra_t            RECORD LIKE    lra_file.*,
          g_lra_o            RECORD LIKE    lra_file.*, 
          g_lra01_t                 LIKE    lra_file.lra01
DEFINE    g_lrb              DYNAMIC ARRAY OF RECORD
             lrb02                  LIKE    lrb_file.lrb02,   #項次
             lrb03                  LIKE    lrb_file.lrb03,   #卡種代號
             lrb04                  LIKE    lrb_file.lrb04,   #卡種說明
             lrb05                  LIKE    lrb_file.lrb05,   #紀念日代碼
             lpc02                  LIKE    lpc_file.lpc02,   #紀念日說明
             lrb06                  LIKE    lrb_file.lrb06,   #日期類型
             lrb07                  LIKE    lrb_file.lrb07,   #最多可選品種個數
             lrb08                  LIKE    lrb_file.lrb08,   #允許重複換贈
             lrbacti                LIKE    lrb_file.lrbacti  #有效否
                             END RECORD,
          g_lrb_t            RECORD
             lrb02                  LIKE    lrb_file.lrb02,
             lrb03                  LIKE    lrb_file.lrb03,
             lrb04                  LIKE    lrb_file.lrb04,
             lrb05                  LIKE    lrb_file.lrb05,
             lpc02                  LIKE    lpc_file.lpc02,
             lrb06                  LIKE    lrb_file.lrb06,
             lrb07                  LIKE    lrb_file.lrb07,
             lrb08                  LIKE    lrb_file.lrb08,
             lrbacti                LIKE    lrb_file.lrbacti
                             END RECORD,
          g_lrb_o            RECORD
             lrb02                  LIKE    lrb_file.lrb02,
             lrb03                  LIKE    lrb_file.lrb03,
             lrb04                  LIKE    lrb_file.lrb04,
             lrb05                  LIKE    lrb_file.lrb05,
             lpc02                  LIKE    lpc_file.lpc02,
             lrb06                  LIKE    lrb_file.lrb06,
             lrb07                  LIKE    lrb_file.lrb07,
             lrb08                  LIKE    lrb_file.lrb08,
             lrbacti                LIKE    lrb_file.lrbacti
                             END RECORD

DEFINE    g_lrc              DYNAMIC ARRAY OF RECORD
             lrc02                  LIKE    lrc_file.lrc02,   #項次
             lrc03                  LIKE    lrc_file.lrc03,   #資料類型
             lrc04                  LIKE    lrc_file.lrc04,   #代碼
             tqa02                  LIKE    tqa_file.tqa02,   #代碼說明                          
             lrc05                  LIKE    lrc_file.lrc05,   #單位
             gfe02                  LIKE    gfe_file.gfe02,   #單位名稱
             lrcacti                LIKE    lrc_file.lrcacti  #有效碼
                             END RECORD,
          g_lrc_t            RECORD
             lrc02                  LIKE    lrc_file.lrc02,   #項次
             lrc03                  LIKE    lrc_file.lrc03,   #資料類型
             lrc04                  LIKE    lrc_file.lrc04,   #代碼
             tqa02                  LIKE    tqa_file.tqa02,   #代碼說明                          
             lrc05                  LIKE    lrc_file.lrc05,   #單位
             gfe02                  LIKE    gfe_file.gfe02,   #單位名稱
             lrcacti                LIKE    lrc_file.lrcacti  #有效碼
                             END RECORD,
          g_lrc_o            RECORD
             lrc02                  LIKE    lrc_file.lrc02,   #項次
             lrc03                  LIKE    lrc_file.lrc03,   #資料類型
             lrc04                  LIKE    lrc_file.lrc04,   #代碼
             tqa02                  LIKE    tqa_file.tqa02,   #代碼說明                          
             lrc05                  LIKE    lrc_file.lrc05,   #單位
             gfe02                  LIKE    gfe_file.gfe02,   #單位名稱
             lrcacti                LIKE    lrc_file.lrcacti  #有效碼
                             END RECORD
DEFINE    g_lrd              DYNAMIC ARRAY OF RECORD
            lrd02                   LIKE    lrd_file.lrd02,   #門店代號
            azp02                   LIKE    azp_file.azp02,   #門店名稱
            lrdacti                 LIKE    lrd_file.lrdacti  #有效碼
                             END RECORD,
          g_lrd_t            RECORD
            lrd02                   LIKE    lrd_file.lrd02,
            azp02                   LIKE    azp_file.azp02,   #門店名稱
            lrdacti                 LIKE    lrd_file.lrdacti
                             END RECORD                  
DEFINE g_sql                STRING,                    #cursor暫存
       g_wc                 STRING,                    #單頭的construct結果
       g_wc2                STRING,                    #單身一的construct结果
       g_wc3                STRING,                    #單身二的construct结果
       g_rec_b              LIKE type_file.num5,       #單身一的總筆數
       g_rec_b2             LIKE type_file.num5,       #單身二的總筆數
       g_rec_b3             LIKE type_file.num5,       #生效範圍的單身總筆數
       l_ac                 LIKE type_file.num5,       #單身一的當前指標
       l_ac2                LIKE type_file.num5,       #單身二的當前指標
       l_ac3                LIKE type_file.num5        #生效範圍的單身當前指標
DEFINE g_forupd_sql         STRING                     #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_chr                LIKE type_file.chr1    
DEFINE g_cnt                LIKE type_file.num10   
DEFINE g_i                  LIKE type_file.num5        #count/index for any purpose  
DEFINE g_msg                LIKE ze_file.ze03      
DEFINE g_curs_index         LIKE type_file.num10  
DEFINE g_row_count          LIKE type_file.num10       #總筆數  
DEFINE g_jump               LIKE type_file.num10       #查詢指定的筆數  
DEFINE g_no_ask             LIKE type_file.num5        #是否開啟指定筆視窗                              
#全局變量定義--end
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF(NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF 
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   LET g_forupd_sql = "SELECT * FROM lra_file WHERE lra01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i557_cl CURSOR FROM g_forupd_sql 

   OPEN WINDOW i557_w WITH FORM "alm/42f/almi557"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL i557_menu()
   CLOSE WINDOW i557_w 
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i557_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM 
   CALL g_lrb.clear()
   CALL g_lrc.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lra.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON lra01,lra02,lrapos,lraconf,lra03,lra04,lra05,
                                lrauser,lragrup,lraoriu,lraorig,lramodu,lradate,lraacti
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT 

      CONSTRUCT g_wc2 ON lrb02,lrb03,lrb05,lrb06,lrb07,lrb08,lrbacti
           FROM s_lrb[1].lrb02,s_lrb[1].lrb03,s_lrb[1].lrb05,s_lrb[1].lrb06,
                s_lrb[1].lrb07,s_lrb[1].lrb08,s_lrb[1].lrbacti
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT  

      CONSTRUCT g_wc3 ON lrc02,lrc03,lrc04,lrc05,lrcacti
           FROM s_lrc[1].lrc02,s_lrc[1].lrc03,s_lrc[1].lrc04,
                s_lrc[1].lrc05,s_lrc[1].lrcacti
                
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT 

      ON ACTION controlp
         CASE 
            WHEN INFIELD(lra01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lra01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lra01
               NEXT FIELD lra01              
            WHEN INFIELD(lra03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_zx01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lra03
               NEXT FIELD lra03              
            WHEN INFIELD(lrb03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrb03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrb03
               NEXT FIELD lrb03              
            WHEN INFIELD(lrb05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrb05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrb05
               NEXT FIELD lrb05
            WHEN INFIELD(lrc04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrc04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrc04
               NEXT FIELD lrc04
            WHEN INFIELD(lrc05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrc05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrc05
               NEXT FIELD lrc05
            OTHERWISE EXIT CASE            
         END CASE  

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION HELP          
         CALL cl_show_help()  
      
      ON ACTION controlg      
         CALL cl_cmdask()


      ON ACTION accept
         EXIT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
   END DIALOG

   IF INT_FLAG THEN RETURN END IF 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrauser', 'lragrup')
   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT UNIQUE lra01 FROM lra_file",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY lra01"
      ELSE
         LET g_sql="SELECT UNIQUE lra01 FROM lra_file,lrb_file",
                   " WHERE lra01 = lrb01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY lra01 "
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT UNIQUE lra01 FROM lra_file,lrc_file",
                   " WHERE lra01 = lrc01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc3 CLIPPED,
                   " ORDER BY lra01 "
      ELSE
         LET g_sql="SELECT UNIQUE lra01 FROM lra_file,lrb_file,lrc_file",
                   " WHERE lra01 = lrb01  AND lra01 = lrc01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   "   AND ",g_wc3 CLIPPED,
                   " ORDER BY lra01 "
      END IF
   END IF
   PREPARE i557_prepare FROM g_sql
   DECLARE i557_cs SCROLL CURSOR WITH HOLD FOR i557_prepare

   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(DISTINCT lra01) FROM lra_file",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY lra01"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT lra01) FROM lra_file,lrb_file",
                   " WHERE lra01 = lrb01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY lra01 "
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(DISTINCT lra01) FROM lra_file,lrc_file",
                   " WHERE lra01 = lrc01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc3 CLIPPED,
                   " ORDER BY lra01 "
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT lra01) FROM lra_file,lrb_file,lrc_file",
                   " WHERE lra01 = lrb01  AND lra01 = lrc01 ",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   "   AND ",g_wc3 CLIPPED,
                   " ORDER BY lra01 "
      END IF
   END IF
   PREPARE i557_precount FROM g_sql
   DECLARE i557_count CURSOR FOR i557_precount

END FUNCTION

FUNCTION i557_menu()   

   WHILE TRUE
      CALL i557_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i557_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i557_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i557_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i557_u('u')
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i557_x()
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i557_copy()
            END IF
  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i557_b('u')
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i557_confirm()
            END IF

         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL i557_unconfirm()
            END IF

        #生效範圍
         WHEN "effective_range"
            IF cl_chk_act_auth() THEN
               CALL i557_effective_range()
            END IF 
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrb),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_lra.lra01 IS NOT NULL THEN
                    LET g_doc.column1 = "lra01"
                    LET g_doc.value1 = g_lra.lra01
                 CALL cl_doc()
                 END IF
              END IF 
      END CASE
   END WHILE
END FUNCTION   

FUNCTION i557_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lrb TO s_lrb.* ATTRIBUTE(COUNT=g_rec_b)   
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("s_lrb")     #存放当前单身停留指针至共享变量l_ac
            CALL i557_b_fill(g_wc2)
            CALL cl_show_fld_cont()   #单身数据comment变更
         #TQC-C30136--mark--str--
         #ON ACTION ACCEPT
         #   LET g_action_choice = "detail"
         #   EXIT DIALOG
         #TQC-C30136--mark--end--
      END DISPLAY 

      DISPLAY ARRAY g_lrc TO s_lrc.* ATTRIBUTE(COUNT=g_rec_b2)   
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_lrc")     #存放当前单身停留指针至共享变量l_ac
            CALL i557_b_fill_2(g_wc3)
            CALL cl_show_fld_cont()   #单身数据comment变更
         #TQC-C30136--mark--str--   
         #ON ACTION ACCEPT
         #   LET g_action_choice = "detail"
         #   EXIT DIALOG
         #TQC-C30136--mark--end--
      END DISPLAY
      
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
         
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG 

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
          
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
         
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG

      ON ACTION effective_range
         LET g_action_choice="effective_range"
         EXIT DIALOG
         
      ON ACTION first
         CALL i557_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION previous
         CALL i557_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 
 
      ON ACTION jump
         CALL i557_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION next
         CALL i557_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG  
 
      ON ACTION last
         CALL i557_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
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
 
      AFTER DIALOG
         CONTINUE DIALOG
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document               
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel",TRUE)
    
END FUNCTION

FUNCTION i557_q()
   LET g_curs_index = 0
   LET g_row_count  = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lrb.clear()
   CALL g_lrc.clear()
   DISPLAY '' TO FORMONLY.cnt

   CALL i557_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lra.* TO NULL
      RETURN
   END IF

   OPEN i557_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lra.* TO NULL
   ELSE
      OPEN i557_count
      FETCH i557_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL i557_fetch('F')
   END IF
END FUNCTION

FUNCTION i557_a()
   DEFINE l_n         LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM
   CALL g_lrb.clear()
   CALL g_lrc.clear()
   LET g_wc = NULL
   LET g_wc2 = NULL
   LET g_wc3 = NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lra.*   LIKE  lra_file.*
   LET g_lra01_t = NULL
   LET g_lra_t.* = g_lra.*
   LET g_lra_o.* = g_lra.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_lra.lrapos   = '1'
      LET g_lra.lraconf  = 'N'
      LET g_lra.lraacti  = 'Y'
      LET g_lra.lrauser  = g_user
      LET g_lra.lragrup  = g_grup
      LET g_lra.lraoriu  = g_user
      LET g_lra.lraorig  = g_grup
      CALL i557_i("a")

      IF INT_FLAG THEN
         INITIALIZE g_lra.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lra.lra01) THEN
         CONTINUE WHILE 
      END IF

      BEGIN WORK
     
      DISPLAY BY NAME g_lra.lra01
      
      INSERT INTO lra_file VALUES(g_lra.*)

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lra_file",g_lra.lra01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lra.lra01,'I')
      END IF

      LET g_lra01_t = g_lra.lra01
      LET g_lra_t.* = g_lra.*
      LET g_lra_o.* = g_lra.*
      CALL g_lrb.clear()
      CALL g_lrc.clear()

      LET g_rec_b  = 0
      LET g_rec_b2 = 0
      CALL i557_b('a')   #单身输入
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i557_u(p_flag)
DEFINE p_flag   LIKE type_file.chr1

   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','abm-880',0)
      RETURN
   END IF

   IF g_lra.lraacti = 'N' THEN
      CALL cl_err('','aic-200',0)
      RETURN
   END IF
   SELECT * INTO g_lra.* FROM lra_file
    WHERE lra01 = g_lra.lra01
    
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lra01_t = g_lra.lra01
   BEGIN WORK
 
   OPEN i557_cl USING g_lra01_t
   IF STATUS THEN
      CALL cl_err("OPEN i557_cl:", STATUS, 1)
      CLOSE i557_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i557_cl INTO g_lra.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lra.lra01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i557_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i557_show()
 
   WHILE TRUE
      LET g_lra01_t = g_lra.lra01
      LET g_lra_o.* = g_lra.*
      IF p_flag != 'c' THEN
         LET g_lra.lramodu = g_user
         LET g_lra.lradate = g_today
      END IF
      CALL i557_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lra.* = g_lra_t.*
         CALL i557_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lra.lra01 != g_lra01_t THEN            # 更改單號
         UPDATE lrb_file SET lrb01 = g_lra.lra01
          WHERE lrb01 = g_lra01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lrb_file",g_lra01_t,"",SQLCA.sqlcode,"","lrb",1) 
            CONTINUE WHILE
         END IF

         UPDATE lrc_file SET lrc01 = g_lra.lra01
          WHERE lrb01 = g_lra01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lrc_file",g_lra01_t,"",SQLCA.sqlcode,"","lrc",1)  
            CONTINUE WHILE
         END IF
      END IF

      IF g_lra_t.lrapos = '3' THEN 
         LET g_lra.lrapos = '2'
         DISPLAY g_lra.lrapos TO lrapos
      END IF 
      UPDATE lra_file SET lra_file.* = g_lra.*
       WHERE lra01 = g_lra01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lra_file","","",SQLCA.sqlcode,"","",1) 
         LET g_lra.lrapos = g_lra_t.lrapos
         DISPLAY g_lra.lrapos TO lrapos
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i557_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lra.lra01,'U')
 
   CALL i557_b_fill("1=1")
   CALL i557_b_fill_2("1=1")
END FUNCTION

FUNCTION i557_i(p_cmd)
DEFINE    p_cmd    LIKE  type_file.chr1
DEFINE  l_n    LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_lra.lrapos,g_lra.lraconf,g_lra.lraacti,
                   g_lra.lrauser,g_lra.lragrup,g_lra.lraoriu,g_lra.lraorig
   CALL cl_set_head_visible("","YES")  
   INPUT BY NAME  g_lra.lra01,g_lra.lra02,g_lra.lra05
      WITHOUT DEFAULTS
      
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i557_set_entry(p_cmd)
         CALL i557_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD lra01
         IF NOT cl_null(g_lra.lra01) THEN
            IF p_cmd='a' 
               OR (p_cmd ='u' AND g_lra.lra01 != g_lra_t.lra01) THEN
               SELECT COUNT(*) INTO l_n  FROM lra_file
                WHERE lra01 = g_lra.lra01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lra.lra01=g_lra_t.lra01
                  DISPLAY BY NAME g_lra.lra01
                  NEXT FIELD lra01
               END IF 
            END IF
         END IF 

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
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

FUNCTION i557_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','abm-881',0)
      RETURN
   END IF
   SELECT * INTO g_lra.* FROM lra_file
    WHERE lra01 = g_lra.lra01

   IF g_lra.lrapos='2' 
      OR (g_lra.lrapos='3' AND g_lra.lraacti='Y') THEN
      CALL cl_err('','alm1518',1)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i557_cl USING g_lra.lra01
   IF STATUS THEN
      CALL cl_err("OPEN i557_cl:", STATUS, 1)
      CLOSE i557_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i557_cl INTO g_lra.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lra.lra01,SQLCA.sqlcode,0)        
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i557_show()
 
   IF cl_delh(0,0) THEN                   
      INITIALIZE g_doc.* TO NULL         
      LET g_doc.column1 = "lra01"        
      LET g_doc.value1 = g_lra.lra01     
      CALL cl_del_doc()                
      DELETE FROM lra_file WHERE lra01 = g_lra.lra01
      DELETE FROM lrb_file WHERE lrb01 = g_lra.lra01
      DELETE FROM lrc_file WHERE lrc01 = g_lra.lra01
      DELETE FROM lrd_file WHERE lrd01 = g_lra.lra01
      CLEAR FORM
      CALL g_lrb.clear()
      CALL g_lrc.clear()
      OPEN i557_count
      FETCH i557_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i557_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i557_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE    
         CALL i557_fetch('/')
      END IF
   END IF
 
   CLOSE i557_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lra.lra01,'D')
END FUNCTION

FUNCTION i557_x()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   BEGIN WORK

   OPEN i557_cl USING g_lra.lra01
   IF STATUS THEN
      CALL cl_err("OPEN i557_cl:", STATUS, 1)
      CLOSE i557_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i557_cl INTO g_lra.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lra.lra01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL i557_show()

   IF cl_exp(0,0,g_lra.lraacti) THEN                   #確認一下
      LET g_chr=g_lra.lraacti
      IF g_lra.lraacti='Y' THEN
         LET g_lra.lraacti='N'
      ELSE
         LET g_lra.lraacti='Y'
      END IF
      IF g_lra.lrapos = '3' THEN
         UPDATE lra_file SET lraacti = g_lra.lraacti,
                             lramodu = g_user,
                             lrapos  = '2',          
                             lradate = g_today
          WHERE lra01 = g_lra.lra01
      ELSE
         UPDATE lra_file SET lraacti = g_lra.lraacti,
                             lramodu = g_user,
                             lradate = g_today
          WHERE lra01 = g_lra.lra01
      END IF
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lra_file",g_lra.lra01,"",SQLCA.sqlcode,"","",1)
         LET g_lra.lraacti=g_chr
      END IF
   END IF

   CLOSE i557_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lraacti,lramodu,lradate,lrapos                        
     INTO g_lra.lraacti,g_lra.lramodu,g_lra.lradate,g_lra.lrapos 
     FROM lra_file
    WHERE lra01=g_lra.lra01
   DISPLAY BY NAME g_lra.lramodu,g_lra.lradate,g_lra.lraacti,g_lra.lrapos 
END FUNCTION


FUNCTION i557_copy()
   DEFINE l_newno     LIKE lra_file.lra01,
          l_oldno     LIKE lra_file.lra01
   DEFINE li_result   LIKE type_file.num5 

   IF s_shut(0) THEN RETURN END IF
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL i557_set_entry('a')
  
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM lra01
      AFTER FIELD lra01
         IF l_newno IS NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM lra_file
             WHERE lra01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD lra01
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
      LET INT_FLAG = 0
      DISPLAY BY NAME g_lra.lra01
      ROLLBACK WORK
      RETURN
   END IF

   BEGIN WORK
   
   DROP TABLE y
   
   SELECT * FROM lra_file 
    WHERE lra01 = g_lra.lra01
     INTO TEMP y

   UPDATE y SET lra01    = l_newno,
                lrapos   = '1',
                lraconf  = 'N',
                lra03    = NULL,
                lra04    = NULL,
                lrauser  = g_user,
                lragrup  = g_grup,
                lramodu  = NULL,
                lradate  = NULL,
                lraacti  = 'Y'
   INSERT INTO lra_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lra_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x
   SELECT * FROM lrb_file
    WHERE lrb01 = g_lra.lra01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET lrb01 = l_newno
   INSERT INTO lrb_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lrb_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK 
   END IF

   DROP TABLE z
   SELECT * FROM lrc_file
    WHERE lrc01 = g_lra.lra01
     INTO TEMP z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF

   UPDATE z SET lrc01 = l_newno
   INSERT INTO lrc_file SELECT * FROM z
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lrc_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK
   END IF

   DROP TABLE w
   SELECT * FROM lrd_file
    WHERE lrd01 = g_lra.lra01
     INTO TEMP w
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","w","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE w SET lrd01 = l_newno
   INSERT INTO lrd_file SELECT * FROM w
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lrd_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

   LET l_oldno = g_lra.lra01
   SELECT lra_file.* INTO g_lra.* FROM lra_file WHERE lra01 = l_newno
   CALL i557_u('c')
   CALL i557_b('c')
   #SELECT lra_file.* INTO g_lra.* FROM lra_file WHERE lra01 = l_oldno  #FUN-C30027
   CALL i557_show()
END FUNCTION

FUNCTION i557_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT  i557_cs INTO g_lra.lra01
      WHEN 'P' FETCH PREVIOUS i557_cs INTO g_lra.lra01
      WHEN 'F' FETCH FIRST i557_cs INTO g_lra.lra01
      WHEN 'L' FETCH LAST  i557_cs INTO g_lra.lra01
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
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i557_cs INTO g_lra.lra01
         LET g_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lra.lra01,SQLCA.sqlcode,0)
      INITIALIZE g_lra.* TO NULL
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
   SELECT * INTO g_lra.* FROM lra_file WHERE lra01 = g_lra.lra01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lra_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_lra.* TO NULL
      RETURN
   END IF

   CALL i557_show()
END FUNCTION

FUNCTION i557_show()
DEFINE l_zx02    LIKE zx_file.zx02           
   LET g_lra_t.* = g_lra.*
   LET g_lra_o.* = g_lra.*
   DISPLAY BY NAME g_lra.*

   SELECT zx02 INTO l_zx02 FROM zx_file
    WHERE zx01 = g_lra.lra03
   DISPLAY l_zx02 TO zx02
   CALL i557_b_fill(g_wc2)
   CALL i557_b_fill_2(g_wc3)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i557_b(p_flag)
   DEFINE
      l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
      l_n             LIKE type_file.num5,                #檢查重複用 
      l_n1            LIKE type_file.num5,              
      l_n2            LIKE type_file.num5,                
      l_n3            LIKE type_file.num5,                
      l_cnt           LIKE type_file.num5,                #檢查重複用  
      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
      p_cmd           LIKE type_file.chr1,                #處理狀態  
      p_flag          LIKE type_file.chr1,                #修改状           
      l_allow_insert  LIKE type_file.num5,                #可新增否  
      l_allow_delete  LIKE type_file.num5                 #可刪除否  
   DEFINE  l_change   LIKE type_file.chr1                 #是否有異動
   DEFINE  l_flag     LIKE type_file.chr1                 #是否為複製狀態
   DEFINE  l_modu     LIKE lra_file.lramodu,
           l_date     LIKE lra_file.lradate
   LET g_action_choice = ""
   LET l_change        = 'N'
   IF s_shut(0) THEN
       RETURN
    END IF
 
   IF g_lra.lra01 IS NULL THEN
       RETURN
   END IF

   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','abm-880',0)
      RETURN
   END IF

   IF g_lra.lraacti = 'N' THEN
      CALL cl_err('','aic-200',0)
      RETURN
   END IF      
 
   SELECT * INTO g_lra.* FROM lra_file
    WHERE lra01 = g_lra.lra01
 
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT lrb02,lrb03,lrb04,lrb05,'',lrb06,lrb07,lrb08,lrbacti ",
                      "  FROM lrb_file",
                      " WHERE lrb01=? AND lrb02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
                      
   DECLARE i557_bcl_b CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT lrc02,lrc03,lrc04,'',lrc05,'',lrcacti",
                      "  FROM lrc_file",
                      " WHERE lrc01=? AND lrc02=? AND lrc03=? AND lrc04=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
                      
   DECLARE i557_bcl_c CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT ARRAY g_lrb  FROM s_lrb.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
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
 
            OPEN i557_cl USING g_lra.lra01
            IF STATUS THEN
               CALL cl_err("OPEN i557_cl:", STATUS, 1)
               CLOSE i557_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i557_cl INTO g_lra.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lra.lra01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i557_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_lrb_t.* = g_lrb[l_ac].*  #BACKUP
               LET g_lrb_o.* = g_lrb[l_ac].*  #BACKUP
               OPEN i557_bcl_b USING g_lra.lra01,g_lrb_t.lrb02
               IF STATUS THEN
                  CALL cl_err("OPEN i557_bcl_b:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i557_bcl_b INTO g_lrb[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lra.lra01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
 
                  SELECT lpc02 INTO g_lrb[l_ac].lpc02
                    FROM lpc_file
                   WHERE lpc00 = '8' AND lpc01 = g_lrb[l_ac].lrb05 
               END IF

               CALL cl_show_fld_cont()     
            END IF
      
            IF p_cmd = 'u' THEN
               CALL cl_set_comp_entry("lrb02",FALSE)
            ELSE
               CALL cl_set_comp_entry("lrb02",TRUE)
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_lrb[l_ac].* TO NULL      
            LET g_lrb[l_ac].lrb08   = 'N'
            LET g_lrb[l_ac].lrbacti = 'Y'
            LET g_lrb_t.* = g_lrb[l_ac].*         #新輸入資料
            LET g_lrb_o.* = g_lrb[l_ac].*         #新輸入資料

            CALL cl_show_fld_cont()         
            NEXT FIELD lrb02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO lrb_file(lrb01,lrb02,lrb03,lrb04,lrb05,lrb06,lrb07,lrb08,
                                 lrbacti,lrbuser,lrbgrup,lrboriu,lrborig)
            VALUES(g_lra.lra01,g_lrb[l_ac].lrb02,g_lrb[l_ac].lrb03,g_lrb[l_ac].lrb04,
                   g_lrb[l_ac].lrb05,g_lrb[l_ac].lrb06,g_lrb[l_ac].lrb07,g_lrb[l_ac].lrb08,
                   g_lrb[l_ac].lrbacti,g_user,g_grup,g_user,g_grup)

           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lrb_file",g_lra.lra01,g_lrb[l_ac].lrb02,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET l_change = 'Y'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            
         BEFORE FIELD lrb02         #default 序號
            IF g_lrb[l_ac].lrb02 IS NULL OR g_lrb[l_ac].lrb02 = 0 THEN
               SELECT max(lrb02)+1 INTO g_lrb[l_ac].lrb02
                 FROM lrb_file
                WHERE lrb01 = g_lra.lra01
               IF g_lrb[l_ac].lrb02 IS NULL THEN
                  LET g_lrb[l_ac].lrb02 = 1
               END IF
            END IF

         AFTER FIELD lrb02          #check 序號是否重複
            IF NOT cl_null(g_lrb[l_ac].lrb02) THEN
               IF p_cmd='a' 
                  OR (p_cmd='u' AND g_lrb[l_ac].lrb02 != g_lrb_t.lrb02) THEN
                  SELECT count(*) INTO l_n FROM lrb_file
                   WHERE lrb01 = g_lra.lra01
                     AND lrb02 = g_lrb[l_ac].lrb02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_lrb[l_ac].lrb02 = g_lrb_t.lrb02
                     DISPLAY BY NAME g_lrb[l_ac].lrb02
                     NEXT FIELD lrb02
                  END IF
               END IF
            END IF
            
         AFTER FIELD lrb03
            IF NOT cl_null(g_lrb[l_ac].lrb03) THEN
               CALL i557_lrb03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lrb[l_ac].lrb03 = g_lrb_t.lrb03
                  NEXT FIELD lrb03
               END IF
            END IF

         AFTER FIELD lrb05
            IF NOT cl_null(g_lrb[l_ac].lrb05) THEN
               CALL i557_lrb05()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lrb[l_ac].lrb05 = g_lrb_t.lrb05
                  NEXT FIELD lrb05
               END IF
            END IF


         AFTER FIELD lrb07
            IF NOT cl_null(g_lrb[l_ac].lrb07) THEN
               IF g_lrb[l_ac].lrb07 <= 0 THEN
                  CALL cl_err('','aim-040',0)
                  LET g_lrb[l_ac].lrb07 = g_lrb_t.lrb07
                  NEXT FIELD lrb07
               END IF
            END IF
            
         BEFORE DELETE                      #是否取消單身
            IF g_lra.lrapos='2'
               OR (g_lra.lrapos='3' AND g_lra.lraacti='Y') THEN
               CALL cl_err('','alm1518',1)
               CANCEL DELETE
            END IF
            IF g_lrb_t.lrb02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lrb_file
                WHERE lrb01 = g_lra.lra01
                  AND lrb02 = g_lrb_t.lrb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lrb_file",g_lra.lra01,g_lrb_t.lrb02,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               DELETE FROM lrc_file
                WHERE lrc01 = g_lra.lra01
                  AND lrc02 = g_lrb_t.lrb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lrb_file",g_lra.lra01,g_lrb_t.lrb02,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               CALL i557_b_fill_2(g_wc3)
               LET g_rec_b = g_rec_b - 1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
            LET l_change = 'Y'
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lrb[l_ac].* = g_lrb_t.*
               CLOSE i557_bcl_b
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_lrb[l_ac].lrb02,-263,1)
               LET g_lrb[l_ac].* = g_lrb_t.*
            ELSE
               IF p_flag != 'c' THEN
                  LET l_modu = g_user
                  LET l_date = g_today
               ELSE
                  LET l_modu  = NULL
                  LET l_date  = NULL
               END IF
               UPDATE lrb_file SET lrb02     = g_lrb[l_ac].lrb02,
                                   lrb03     = g_lrb[l_ac].lrb03,
                                   lrb04     = g_lrb[l_ac].lrb04,
                                   lrb05     = g_lrb[l_ac].lrb05,
                                   lrb06     = g_lrb[l_ac].lrb06,
                                   lrb07     = g_lrb[l_ac].lrb07,
                                   lrb08     = g_lrb[l_ac].lrb08,
                                   lrbacti   = g_lrb[l_ac].lrbacti,
                                   lrbmodu   = l_modu,
                                   lrbdate   = l_date
               WHERE lrb01 = g_lra.lra01
                 AND lrb02 = g_lrb_t.lrb02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","lrb_file",g_lra.lra01,g_lra_t.lra02,SQLCA.sqlcode,"","",1) 
                  LET g_lrb[l_ac].* = g_lrb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  LET l_change = 'Y'
               END IF
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' THEN
                  CALL g_lrb.deleteElement(l_ac)
               END IF
               IF p_cmd = 'u' THEN
                  LET g_lrb[l_ac].* = g_lrb_t.*
               END IF
               CLOSE i557_bcl_b
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE i557_bcl_b
            COMMIT WORK

         ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(lrb02) AND l_ac > 1 THEN
               LET g_lrb[l_ac].* = g_lrb[l_ac-1].*
               LET g_lrb[l_ac].lrb02 = NULL
               NEXT FIELD lrb02
            END IF
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(lrb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lph04"
                  LET g_qryparam.default1 = g_lrb[l_ac].lrb03
                  CALL cl_create_qry() RETURNING g_lrb[l_ac].lrb03
                  DISPLAY g_lrb[l_ac].lrb03 TO lrb03
                  CALL i557_lrb03()
                  NEXT FIELD lrb03
                  
               WHEN INFIELD(lrb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpc01_8"
                  LET g_qryparam.default1 = g_lrb[l_ac].lrb05
                  CALL cl_create_qry() RETURNING g_lrb[l_ac].lrb05
                  DISPLAY g_lrb[l_ac].lrb05 TO lrb05
                  CALL i557_lrb05()
                  NEXT FIELD lrb05
               OTHERWISE EXIT CASE
            END CASE        
      END INPUT

      INPUT ARRAY g_lrc  FROM s_lrc.*
        ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i557_cl USING g_lra.lra01
            IF STATUS THEN
               CALL cl_err("OPEN i557_cl:", STATUS, 1)
               CLOSE i557_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i557_cl INTO g_lra.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lra.lra01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i557_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b2 >= l_ac2 THEN
               LET p_cmd='u'
               LET g_lrc_t.* = g_lrc[l_ac2].*  #BACKUP
               LET g_lrc_o.* = g_lrc[l_ac2].*  #BACKUP
               OPEN i557_bcl_c USING g_lra.lra01,g_lrc_t.lrc02,
                                     g_lrc_t.lrc03,g_lrc_t.lrc04
               IF STATUS THEN
                  CALL cl_err("OPEN i557_bcl_c:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i557_bcl_c INTO g_lrc[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lrc_t.lrc02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
 
                  CALL i557_lrc04()
                  CALL i557_lrc05()
               END IF
               CALL i557_set_entry_b(p_cmd)
               CALL i557_set_no_entry_b(p_cmd)
               CALL cl_show_fld_cont()     
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_lrc[l_ac2].* TO NULL  
            LET g_lrc[l_ac2].lrcacti = 'Y'    
            LET g_lrc_t.* = g_lrc[l_ac2].*         #新輸入資料
            LET g_lrc_o.* = g_lrc[l_ac2].*         #新輸入資料

            CALL i557_set_entry_b(p_cmd)
            CALL i557_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()         
            NEXT FIELD lrc02
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO lrc_file(lrc01,lrc02,lrc03,lrc04,lrc05,lrcacti,
                                 lrcuser,lrcgrup,lrcoriu,lrcorig)
            VALUES(g_lra.lra01,g_lrc[l_ac2].lrc02,g_lrc[l_ac2].lrc03,g_lrc[l_ac2].lrc04,
                   g_lrc[l_ac2].lrc05,g_lrc[l_ac2].lrcacti,g_user,g_grup,g_user,g_grup)
           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lrc_file",g_lra.lra01,g_lrc[l_ac2].lrc02,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET l_change = 'Y'
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn3
            END IF
            
         AFTER FIELD lrc02
            IF  NOT cl_null(g_lrc[l_ac2].lrc02) THEN
                SELECT COUNT(*) INTO l_n FROM lrb_file
                 WHERE lrb01 = g_lra.lra01
                   AND lrb02 = g_lrc[l_ac2].lrc02
                IF l_n = 0 THEN                    #需存在與第一個單身的項次中
                   CALL cl_err('','alm1520',0)
                   LET g_lrc[l_ac2].lrc02 = g_lrc_t.lrc02
                   NEXT FIELD lrc02
                END IF 
                IF NOT i557_chk_lrc_key(p_cmd) THEN
                   LET g_lrc[l_ac2].lrc02 = g_lrc_t.lrc02
                   NEXT FIELD lrc02
                END IF 
            END IF

         ON CHANGE lrc03
            LET g_lrc[l_ac2].lrc04 = NULL
            LET g_lrc[l_ac2].tqa02 = NULL
            CALL i557_set_entry_b(p_cmd)
            CALL i557_set_no_entry_b(p_cmd)

         AFTER FIELD lrc03
            IF NOT cl_null(g_lrc[l_ac2].lrc03) THEN 
               IF NOT i557_chk_lrc_key(p_cmd) THEN
                  LET g_lrc[l_ac2].lrc03 = g_lrc_t.lrc03
                  NEXT FIELD lrc03
               END IF
            END IF
            
         AFTER FIELD lrc04
            IF NOT cl_null(g_lrc[l_ac2].lrc04) THEN
               IF NOT i557_chk_lrc_key(p_cmd) THEN
                   LET g_lrc[l_ac2].lrc04 = g_lrc_t.lrc04
                   NEXT FIELD lrc04
               END IF
               CALL i557_lrc04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lrc[l_ac2].lrc04 = g_lrc_t.lrc04
                  NEXT FIELD lrc04 
               END IF
            END IF

         AFTER FIELD lrc05
            IF NOT cl_null(g_lrc[l_ac2].lrc05) THEN
               CALL i557_lrc05()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lrc[l_ac2].lrc05 = g_lrc_t.lrc05
                  NEXT FIELD lrc05 
               END IF
            END IF
            
         BEFORE DELETE                      #是否取消單身
            IF g_lra.lrapos='2'
               OR (g_lra.lrapos='3' AND g_lra.lraacti='Y') THEN
               CALL cl_err('','alm1518',1)
               CANCEL DELETE
            END IF
            IF g_lrc_t.lrc02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM lrc_file
                WHERE lrc01    = g_lra.lra01
                  AND lrc02    = g_lrc_t.lrc02
                  AND lrc03    = g_lrc_t.lrc03
                  AND lrc04    = g_lrc_t.lrc04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","lrc_file",g_lra.lra01,g_lrc_t.lrc02,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b2=g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn3
            END IF
            COMMIT WORK
            LET l_change = 'Y'
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_lrc[l_ac2].* = g_lrc_t.*
               CLOSE i557_bcl_c
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_lrc[l_ac2].lrc02,-263,1)
               LET g_lrc[l_ac2].* = g_lrc_t.*
            ELSE
               IF p_flag != 'c' THEN
                  LET l_modu = g_user
                  LET l_date = g_today
               ELSE
                  LET l_modu  = NULL
                  LET l_date  = NULL
               END IF
               UPDATE lrc_file SET lrc02     = g_lrc[l_ac2].lrc02,
                                   lrc03     = g_lrc[l_ac2].lrc03,
                                   lrc04     = g_lrc[l_ac2].lrc04,
                                   lrc05     = g_lrc[l_ac2].lrc05,
                                   lrcacti   = g_lrc[l_ac2].lrcacti,
                                   lrcmodu   = l_modu,
                                   lrcdate   = l_date
               WHERE lrc01    = g_lra.lra01
                 AND lrc02    = g_lrc_t.lrc02
                 AND lrc03    = g_lrc_t.lrc03
                 AND lrc04    = g_lrc_t.lrc04
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","lrc_file",g_lra.lra01,g_lrc_t.lrc02,SQLCA.sqlcode,"","",1) 
                  LET g_lrc[l_ac2].* = g_lrc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  LET l_change = 'Y'
               END IF
            END IF
 
         AFTER ROW
            LET l_ac2 = ARR_CURR()
            LET l_ac_t = l_ac2
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' THEN
                  CALL g_lrc.deleteElement(l_ac2)
               END IF
               IF p_cmd = 'u' THEN
                  LET g_lrc[l_ac2].* = g_lrc_t.*
               END IF
               CLOSE i557_bcl_c
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE i557_bcl_c
            COMMIT WORK

            
         ON ACTION controlp
            CASE
               WHEN INFIELD(lrc04)
                  IF g_lrc[l_ac2].lrc03 != '01' THEN 
                     CALL cl_init_qry_var()
                  END IF
                  
                  CASE g_lrc[l_ac2].lrc03
                     WHEN '01' #產品
                        CALL q_sel_ima(FALSE, "q_ima_1","",g_lrc[l_ac2].lrc04,"","","","","",'' )
                        RETURNING g_lrc[l_ac2].lrc04
                     WHEN '02' #產品分類
                        LET g_qryparam.form ="q_oba01"
                     WHEN '03'   #類別
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '1'
                     WHEN '04'   #品牌
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '2'
                     WHEN '05'   #系列
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '3'
                     WHEN '06'   #型別
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '4' 
                     WHEN '07'   #規格
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '5'
                     WHEN '08'   #屬性
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '6'
                     WHEN '09'   #價格區間
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1 = '27'
                     WHEN '10'    #券
                        LET g_qryparam.form ="q_lpx02"
                  END CASE

                  IF g_lrc[l_ac2].lrc03 != '01' THEN
                     LET g_qryparam.default1 = g_lrc[l_ac2].lrc04
                     CALL cl_create_qry() RETURNING g_lrc[l_ac2].lrc04
                  END IF
                  DISPLAY g_lrc[l_ac2].lrc04 TO lrc04
                  NEXT FIELD lrc04

               WHEN INFIELD(lrc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_lrc[l_ac2].lrc05
                  CALL cl_create_qry() RETURNING g_lrc[l_ac2].lrc05
                  DISPLAY BY NAME  g_lrc[l_ac2].lrc05
                  NEXT FIELD lrc05
                  
               OTHERWISE EXIT CASE
            END CASE        
      END INPUT

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         EXIT DIALOG

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                               
         CALL cl_set_head_visible("","AUTO")

    END DIALOG
    
    IF l_change = 'Y' THEN
       IF g_lra.lrapos = '3' THEN
          UPDATE lra_file SET lrapos  = '2',
                              lramodu = g_user,
                              lradate = g_today
           WHERE lra01 = g_lra.lra01
          LET g_lra.lrapos = '2'
          LET g_lra.lramodu = g_user
          LET g_lra.lradate = g_today
          DISPLAY BY NAME g_lra.lrapos,g_lra.lramodu,g_lra.lradate
       END IF
    END IF
    CLOSE i557_bcl_b
    CLOSE i557_bcl_c
    COMMIT WORK
    CALL i557_delall()
END FUNCTION

FUNCTION i557_b_fill(p_wc2)
DEFINE p_wc2    STRING
   LET g_sql = "SELECT lrb02,lrb03,lrb04,lrb05,'',lrb06,lrb07,lrb08,lrbacti ",
                      "  FROM lrb_file",
                      " WHERE lrb01='",g_lra.lra01,"'"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY lrb02"  
   PREPARE i557_pb FROM g_sql
   DECLARE lrb_cs CURSOR FOR i557_pb

   CALL g_lrb.clear()
   LET g_cnt = 1

   FOREACH lrb_cs INTO g_lrb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF   
      SELECT lpc02 INTO g_lrb[g_cnt].lpc02 FROM lpc_file
         WHERE lpc00 = '8'
           AND lpc01 = g_lrb[g_cnt].lrb05
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lrb.deleteElement(g_cnt)  

   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0                      
END FUNCTION

FUNCTION i557_b_fill_2(p_wc3)
DEFINE p_wc3    STRING
   LET g_sql = "SELECT lrc02,lrc03,lrc04,'',lrc05,'',lrcacti",
                      "  FROM lrc_file",
                      " WHERE lrc01='",g_lra.lra01,"'"
   IF NOT cl_null(p_wc3) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY lrc02"  
   PREPARE i557_pc FROM g_sql
   DECLARE lrc_cs CURSOR FOR i557_pc

   CALL g_lrc.clear()
   LET g_cnt = 1

   FOREACH lrc_cs INTO g_lrc[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF   
      CASE
         WHEN g_lrc[g_cnt].lrc03 = '01'  #產品
            SELECT ima02 INTO g_lrc[g_cnt].tqa02
              FROM ima_file
              WHERE ima01 = g_lrc[g_cnt].lrc04
         WHEN g_lrc[g_cnt].lrc03 = '02'  #產品分類
            SELECT oba02 INTO g_lrc[g_cnt].tqa02
              FROM oba_file
             WHERE oba01 = g_lrc[g_cnt].lrc04
         WHEN g_lrc[g_cnt].lrc03 = '03'  #類別
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '1'
         WHEN g_lrc[g_cnt].lrc03 = '04'  #品牌
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '2'
         WHEN g_lrc[g_cnt].lrc03 = '05'  #系列
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '3'
         WHEN g_lrc[g_cnt].lrc03 = '06'  #型別
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '4'
         WHEN g_lrc[g_cnt].lrc03 = '07'  #規格
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '5'
         WHEN g_lrc[g_cnt].lrc03 = '08'  #屬性
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '6'
         WHEN g_lrc[g_cnt].lrc03 = '09'  #價格
            SELECT tqa02 INTO g_lrc[g_cnt].tqa02
              FROM tqa_file
             WHERE tqa01 = g_lrc[g_cnt].lrc04
               AND tqa03 = '27'
         WHEN g_lrc[g_cnt].lrc03 = '10'  #券
            SELECT lpx02
              INTO g_lrc[g_cnt].tqa02
              FROM lpx_file
             WHERE lpx01 = g_lrc[g_cnt].lrc04
      END CASE   

      SELECT gfe02 INTO g_lrc[g_cnt].gfe02
        FROM gfe_file
       WHERE gfe01 = g_lrc[g_cnt].lrc05
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_lrc.deleteElement(g_cnt)  

   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn3
   LET g_cnt = 0 
END FUNCTION

FUNCTION i557_confirm()
DEFINE   l_i    LIKE type_file.num5,
         l_n    LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF 
#CHI-C30107 ------------ add ------------- begin
   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','alm-005',0)
      RETURN
   END IF

   IF g_lra.lraacti = 'N' THEN
      CALL cl_err('','aim-153',0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
   SELECT * INTO g_lra.* FROM lra_file WHERE lra01 = g_lra.lra01
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
#CHI-C30107 ------------ add ------------- end
   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','alm-005',0)
      RETURN
   END IF

   IF g_lra.lraacti = 'N' THEN
      CALL cl_err('','aim-153',0)
      RETURN
   END IF
   #應check 第一單身每個設定的項次於第二單身都有設定範圍時，才可確認，else報錯且不可確認
   FOR l_i=1 TO g_lrb.getLength()
      SELECT COUNT(*) INTO l_n FROM lrc_file
       WHERE lrc01 = g_lra.lra01
         AND lrc02 = g_lrb[l_i].lrb02
      IF l_n = 0 THEN
         CALL cl_err('','alm1521',0)
         RETURN
      END IF
   END FOR
   #應check 生效範圍有設定資料時，才可確認，else報錯且不可確認
   SELECT COUNT(*) INTO l_n FROM lrd_file
    WHERE lrd01 = g_lra.lra01
   IF l_n = 0 THEN
      CALL cl_err('','alm1522',0)
      RETURN
   END IF
   #確認時，應UPDATE 確認碼(lraconf='Y')，確認人員(lra03 = g_user)，
   #確認日期(lra04 = g_today) 及傳POS碼(lrapos)[if lrapos = '3' UPDATE lrapos ='2']
#  IF NOT cl_confirm('aap-222') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK

   OPEN i557_cl USING g_lra.lra01
   IF STATUS THEN
       CALL cl_err("OPEN i557_cl:", STATUS, 1)
       CLOSE i557_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i557_cl INTO g_lra.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF

   CALL i557_show()
   LET g_lra.lraconf = 'Y'
   IF g_lra.lrapos = '3' THEN
      UPDATE lra_file SET  lra03   = g_user,
                           lra04   = g_today,
                           lraconf = 'Y',
                           lrapos  = '2',
                           lramodu = g_user,
                          lradate = g_today
       WHERE lra01 = g_lra.lra01
   ELSE
      UPDATE lra_file SET  lra03   = g_user,
                           lra04   = g_today,
                           lraconf = 'Y',
                           lramodu = g_user,
                          lradate = g_today
       WHERE lra01 = g_lra.lra01
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","lra_file",g_lra.lra01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF

   CLOSE i557_cl
   COMMIT WORK
   SELECT * INTO g_lra.* FROM lra_file WHERE lra01 = g_lra.lra01
   CALL i557_show()
END FUNCTION

FUNCTION i557_unconfirm()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF 

   IF g_lra.lraconf = 'N' THEN
      CALL cl_err('','asf-216',0)
      RETURN
   END IF

   IF g_lra.lraacti = 'N' THEN
      CALL cl_err('','aim-153',0)
      RETURN
   END IF

   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   BEGIN WORK

   OPEN i557_cl USING g_lra.lra01
   IF STATUS THEN
       CALL cl_err("OPEN i557_cl:", STATUS, 1)
       CLOSE i557_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH i557_cl INTO g_lra.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF

   CALL i557_show()
   LET g_lra.lraconf = 'Y'
   IF g_lra.lrapos = '3' THEN
      #CHI-D20015--modify--str--
      #UPDATE lra_file SET  lra03   = NULL,
      #                     lra04   = NULL,
      UPDATE lra_file SET  lra03   = g_user,
                           lra04   = g_today,
      #CHI-D20015--modify--end--
                           lraconf = 'N',
                           lrapos  = '2',
                           lramodu = g_user,
                           lradate = g_today
       WHERE lra01 = g_lra.lra01
   ELSE
      #CHI-D20015--modify--str--
      #UPDATE lra_file SET  lra03   = NULL,
      #                     lra04   = NULL,
      UPDATE lra_file SET  lra03   = g_user,
                           lra04   = g_today,
      #CHI-D20015--modify--end--
                           lraconf = 'N',
                           lramodu = g_user,
                           lradate = g_today
       WHERE lra01 = g_lra.lra01
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","lra_file",g_lra.lra01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF

   CLOSE i557_cl
   COMMIT WORK
   SELECT * INTO g_lra.* FROM lra_file WHERE lra01 = g_lra.lra01
   CALL i557_show()
END FUNCTION

FUNCTION i557_effective_range()
   IF g_lra.lra01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF g_lra.lraconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF

   IF g_lra.lraacti = 'N' THEN
      CALL cl_err('','aim-153',0)
      RETURN
   END IF
   OPEN WINDOW i557_range_w WITH FORM "alm/42f/almi557_range"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almi557_range")
   CALL i557_range_show()
   CALL i557_range_menu()
   CLOSE WINDOW i557_range_w
END FUNCTION

FUNCTION i557_range_menu()
   WHILE TRUE
      CALL i557_range_bp("G")
      CASE g_action_choice
         WHEN "detail"
            CALL i557_range_b()

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            LET INT_FLAG = 0
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i557_range_bp(p_ud)
   DEFINE p_ud  LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = ""

   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_lrd TO s_lrd.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
      BEFORE ROW
         LET l_ac3 = ARR_CURR()   
         CALL cl_show_fld_cont()  

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac3 = 1
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
         LET l_ac3 = ARR_CURR()
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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION i557_range_show()
   CALL i557_range_b_fill()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i557_range_b_fill()
DEFINE  l_sql  STRING
   LET l_sql = "SELECT lrd02,'',lrdacti FROM lrd_file ",
               " WHERE lrd01 = '",g_lra.lra01,"'",
               " ORDER BY lrd02"
   PREPARE lrd_pre FROM l_sql
   DECLARE lrd_curs CURSOR FOR lrd_pre
   CALL g_lrd.clear()
   LET g_cnt = 1
   FOREACH lrd_curs INTO g_lrd[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT azp02 INTO g_lrd[g_cnt].azp02 FROM azp_file
       WHERE azp01 = g_lrd[g_cnt].lrd02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lrd.deleteElement(g_cnt)

   LET g_rec_b3 = g_cnt - 1
   DISPLAY g_rec_b3 TO FORMONLY.cnt_a
   LET g_cnt = 0
END FUNCTION

FUNCTION i557_range_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_n,l_cnt       LIKE type_file.num5,
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.chr1,
          l_allow_delete  LIKE type_file.chr1
   DEFINE l_change        LIKE type_file.chr1   #是否有異動
   DEFINE tok         base.StringTokenizer
   DEFINE l_plant     LIKE azp_file.azp01


   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT lrd02,'',lrdacti FROM lrd_file ",
                      " WHERE lrd01 = ? AND lrd02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i557_range_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_lrd WITHOUT DEFAULTS FROM s_lrd.*
          ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b3 >= l_ac3 THEN
            LET p_cmd = 'u'
            LET g_lrd_t.* = g_lrd[l_ac3].*
            OPEN i557_range_bcl USING g_lra.lra01,g_lrd_t.lrd02
            IF STATUS THEN
               CALL cl_err("OPEN i557_range_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i557_range_bcl INTO g_lrd[l_ac3].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_lrd_t.lrd02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i557_lrd02()
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_lrd[l_ac3].* TO NULL
         LET g_lrd[l_ac3].lrdacti = 'Y'
         LET g_lrd_t.* = g_lrd[l_ac3].*
         CALL cl_show_fld_cont()
         NEXT FIELD lrd02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO lrd_file(lrd01,lrd02,lrdacti,lrduser,lrdgrup,lrdoriu,lrdorig)
         VALUES(g_lra.lra01,g_lrd[l_ac3].lrd02,g_lrd[l_ac3].lrdacti,
                g_user,g_grup,g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lrd_file",g_lra.lra01,g_lrd[l_ac3].lrd02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET l_change = 'Y'
            LET g_rec_b3=g_rec_b3+1
            DISPLAY g_rec_b3 TO FORMONLY.cnt_a
         END IF

      AFTER FIELD lrd02
         IF NOT cl_null(g_lrd[l_ac3].lrd02) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u'
               AND g_lrd[l_ac3].lrd02 != g_lrd_t.lrd02) THEN
               SELECT COUNT(*) INTO l_n FROM lrd_file
                WHERE lrd01 = g_lra.lra01
                  AND lrd02 = g_lrd[l_ac3].lrd02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_lrd[l_ac3].lrd02 = g_lrd_t.lrd02
                  NEXT FIELD lrd02
               END IF
               CALL i557_lrd02()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lrd[l_ac3].lrd02 = g_lrd_t.lrd02
                  NEXT FIELD lrd02
               END IF
            END IF 
         END IF


      BEFORE DELETE
         IF g_lra.lrapos='2'
            OR (g_lra.lrapos='3' AND g_lra.lraacti='Y') THEN
            CALL cl_err('','alm1518',1)
            CANCEL DELETE
         END IF
         IF g_lrd_t.lrd02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM lrd_file
             WHERE lrd01 = g_lra.lra01
               AND lrd02 = g_lrd_t.lrd02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","lrd_file",g_lra.lra01,g_lrd_t.lrd02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b3=g_rec_b3-1
            DISPLAY g_rec_b3 TO FORMONLY.cnt_a
         END IF
         COMMIT WORK
         LET l_change = 'Y'

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_lrd[l_ac3].* = g_lrd_t.*
            CLOSE i557_range_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            LET g_lrd[l_ac3].* = g_lrd_t.*
         ELSE
            UPDATE lrd_file SET lrd02     = g_lrd[l_ac3].lrd02,
                                lrdacti   = g_lrd[l_ac3].lrdacti,
                                lrdmodu   = g_user,
                                lrddate   = g_today
             WHERE lrd01 = g_lra.lra01
               AND lrd02 = g_lrd_t.lrd02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lrd_file",g_lra.lra01,g_lrd_t.lrd02,SQLCA.sqlcode,"","",1)
               LET g_lrd[l_ac3].* = g_lrd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               LET l_change = 'Y'
            END IF
         END IF

      AFTER ROW
         LET l_ac3 = ARR_CURR()
         LET l_ac_t = l_ac3
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'a' THEN
               CALL g_lrd.deleteElement(l_ac3)
            END IF
            IF p_cmd = 'u' THEN
               LET g_lrd[l_ac3].* = g_lrd_t.*
            END IF
            CLOSE i557_range_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i557_range_bcl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION controlp
           CASE
              WHEN INFIELD(lrd02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azw"
                 IF p_cmd = 'u' THEN
                    LET g_qryparam.default1 = g_lrd[l_ac3].lrd02
                    CALL cl_create_qry() RETURNING g_lrd[l_ac3].lrd02
                    DISPLAY BY NAME g_lrd[l_ac3].lrd02
                 ELSE
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_n  FROM lrd_file
                          WHERE lrd01 = g_lra.lra01 AND lrd02 = l_plant
                         IF l_n > 0 THEN
                            CONTINUE WHILE
                         END IF
                       END IF
                       INSERT INTO lrd_file(lrd01,lrd02,lrdacti,lrduser,lrdgrup,lrdoriu,lrdorig)
                       VALUES (g_lra.lra01,l_plant,'Y',g_user,g_grup,g_user,g_grup)
                    END WHILE
                    LET l_change = 'Y'
                    EXIT INPUT
               END IF                    
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
    IF l_change = 'Y' THEN
       IF g_lra.lrapos = '3' THEN
          UPDATE lra_file SET lrapos  = '2',
                              lramodu = g_user,
                              lradate = g_today
           WHERE lra01 = g_lra.lra01
          LET g_lra.lrapos = '2'
          LET g_lra.lramodu = g_user
          LET g_lra.lradate = g_today
          DISPLAY BY NAME g_lra.lrapos,g_lra.lramodu,g_lra.lradate
       END IF
       CALL i557_range_b_fill()
    END IF
   CLOSE i557_range_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i557_delall()
   SELECT COUNT(*) INTO g_cnt FROM lrb_file
    WHERE lrb01 = g_lra.lra01
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lra_file WHERE lra01 = g_lra.lra01
      DELETE FROM lrd_file WHERE lrd01 = g_lra.lra01
   END IF
END FUNCTION

FUNCTION i557_lrb03()
DEFINE  l_lph02   LIKE lph_file.lph02,
        l_lph24   LIKE lph_file.lph24,
        l_lphacti LIKE lph_file.lphacti
   LET g_errno = ''
   SELECT lph02,lph24 INTO l_lph02,l_lph24 FROM lph_file
    WHERE lph01 = g_lrb[l_ac].lrb03
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'alm1523'  #不存在該卡種代號
      WHEN l_lph24 <> 'Y'
         LET g_errno = 'alm1524'  #未確認的卡種代號
      WHEN l_lphacti <> 'Y'
         LET g_errno = 'alm1525'   #無效的卡種代號
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
      LET g_lrb[l_ac].lrb04 = l_lph02
      DISPLAY g_lrb[l_ac].lrb04 TO lrb04
   END IF
END FUNCTION

FUNCTION i557_lrb05()
DEFINE l_lpc02   LIKE lpc_file.lpc02,
       l_lpcacti LIKE lpc_file.lpcacti,
       l_lpc05   LIKE lpc_file.lpc05        #FUN-C60032 add
   LET g_errno = ''
   SELECT lpc02,lpcacti,lpc05 INTO l_lpc02,l_lpcacti,l_lpc05    #FUN-C60032 add lpc05
     FROM lpc_file
    WHERE lpc01 = g_lrb[l_ac].lrb05
      AND lpc00 = '8'
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'alm1484'  #不存在該紀念日代碼
      WHEN l_lpcacti <> 'Y'
         LET g_errno = 'alm1485'  #無效的紀念日代碼
      WHEN l_lpc05 = 'N'          #FUN-C60032 add
         LET g_errno = 'alm1628'  #FUN-C60032 add    #非紀念日代碼
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
      LET g_lrb[l_ac].lpc02 = l_lpc02
      DISPLAY g_lrb[l_ac].lpc02 TO lpc02
   END IF   
END FUNCTION

FUNCTION i557_lrc04()
DEFINE   l_desc   LIKE  ima_file.ima02
DEFINE   l_acti   LIKE  tqa_file.tqaacti
DEFINE   l_lpx07  LIKE  lpx_file.lpx07,
         l_lpx15  LIKE  lpx_file.lpx15
   LET g_errno = ''
   CASE
      WHEN g_lrc[l_ac2].lrc03 = '01'  #產品
         IF  s_chk_item_no(g_lrc[l_ac2].lrc04,'')  THEN  
             SELECT ima02,imaacti INTO l_desc,l_acti
               FROM ima_file
              WHERE ima01 = g_lrc[l_ac2].lrc04
         END IF
      WHEN g_lrc[l_ac2].lrc03 = '02'  #產品分類
         SELECT oba02,obaacti INTO l_desc,l_acti
           FROM oba_file
          WHERE oba01 = g_lrc[l_ac2].lrc04
      WHEN g_lrc[l_ac2].lrc03 = '03'  #類別
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '1'
      WHEN g_lrc[l_ac2].lrc03 = '04'  #品牌
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '2'
      WHEN g_lrc[l_ac2].lrc03 = '05'  #系列
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '3'
      WHEN g_lrc[l_ac2].lrc03 = '06'  #型別
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '4'
      WHEN g_lrc[l_ac2].lrc03 = '07'  #規格
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '5'
      WHEN g_lrc[l_ac2].lrc03 = '08'  #屬性
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '6'
      WHEN g_lrc[l_ac2].lrc03 = '09'  #價格
         SELECT tqa02,tqaacti INTO l_desc,l_acti
           FROM tqa_file
          WHERE tqa01 = g_lrc[l_ac2].lrc04
            AND tqa03 = '27'
      WHEN g_lrc[l_ac2].lrc03 = '10'  #券
         SELECT lpx02,lpxacti,lpx07,lpx15
           INTO l_desc,l_acti,l_lpx07,l_lpx15
           FROM lpx_file
          WHERE lpx01 = g_lrc[l_ac2].lrc04
   END CASE

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'apy-591'  #不存在該資料類型的代碼
      WHEN l_acti <> 'Y'
         LET g_errno = 'alm1526'  #無效的代碼
      WHEN l_lpx07 <> 'Y'
         LET g_errno = 'alm1527'  #非可返券代碼
      WHEN l_lpx15 <> 'Y'
         LET g_errno = 'alm1528'  #未確認代碼
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '--------'
   END CASE

   IF cl_null(g_errno) THEN
      LET g_lrc[l_ac2].tqa02 = l_desc
      DISPLAY g_lrc[l_ac2].tqa02 TO tqa02
   END IF
END FUNCTION

FUNCTION i557_lrc05()
DEFINE  l_gfe02    LIKE  gfe_file.gfe02
DEFINE  l_gfeacti  LIKE  gfe_file.gfeacti
   LET g_errno = ''
   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_lrc[l_ac2].lrc05
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'mfg3098'  #不存在該單位代碼
      WHEN l_gfeacti <> 'Y'
         LET g_errno = 'alm1493'  #無效的單位代碼
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '--------'
   END CASE

   IF cl_null(g_errno) THEN
      LET g_lrc[l_ac2].gfe02 = l_gfe02
      DISPLAY g_lrc[l_ac2].gfe02 TO gfe02
   END IF
END FUNCTION 

FUNCTION i557_chk_lrc_key(p_cmd)
DEFINE   p_cmd LIKE type_file.chr1
DEFINE   l_n   LIKE type_file.num5
   IF p_cmd = 'a' OR (p_cmd = 'u'
      AND ((g_lrc[l_ac2].lrc02 != g_lrc_t.lrc02)
       OR (g_lrc[l_ac2].lrc03 != g_lrc_t.lrc03)
       OR (g_lrc[l_ac2].lrc04 != g_lrc_t.lrc04))) THEN
      SELECT COUNT(*) INTO l_n FROM lrc_file
       WHERE lrc01 = g_lra.lra01
         AND lrc02 = g_lrc[l_ac2].lrc02
         AND lrc03 = g_lrc[l_ac2].lrc03
         AND lrc04 = g_lrc[l_ac2].lrc04
      IF l_n > 0 THEN
         CALL cl_err('',-239,0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i557_lrd02()
DEFINE  l_azp02   LIKE azp_file.azp02
   LET g_errno = ''
   SELECT azp02 INTO l_azp02 FROM azp_file
    WHERE azp01 = g_lrd[l_ac3].lrd02
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'atm-383'  #不存在該門店代碼
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '--------'
   END CASE

   IF cl_null(g_errno) THEN
      LET g_lrd[l_ac3].azp02 = l_azp02
      DISPLAY g_lrd[l_ac3].azp02 TO azp02
   END IF
END FUNCTION 

FUNCTION i557_set_entry(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lra01",TRUE)
   END IF
END FUNCTION

FUNCTION i557_set_no_entry(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1
  IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey = 'N' THEN
    CALL cl_set_comp_entry("lra01",FALSE)
  END IF
END FUNCTION

FUNCTION i557_set_entry_b(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1
   CALL cl_set_comp_entry('lrc04',TRUE)
   CALL cl_set_comp_entry('lrc05',TRUE)
   CALL cl_set_comp_required('lrc05',FALSE)
END FUNCTION

FUNCTION i557_set_no_entry_b(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1
   IF g_lrc[l_ac2].lrc03 = '11' THEN
      CALL cl_set_comp_entry('lrc04',FALSE)
      LET g_lrc[l_ac2].lrc04 = 'MISCCARD'
      LET g_lrc[l_ac2].tqa02 = ''
   END IF
   IF g_lrc[l_ac2].lrc03 = '01' THEN
      CALL cl_set_comp_required('lrc05',TRUE)
   ELSE
      CALL cl_set_comp_entry('lrc05',FALSE)
      LET g_lrc[l_ac2].lrc05 = ''
      LET g_lrc[l_ac2].gfe02 = ''
   END IF
END FUNCTION
#No.FUN-BC0121
