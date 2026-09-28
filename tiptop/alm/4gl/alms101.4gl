# Prog. Version..: '5.30.01-12.03.22(00004)'     
#
# Pattern name...: alms101.4gl
# Descriptions...: 招商門店參數設置作業
# DATE&Author....: NO.FUN-B90056 11/09/07 By yuhuabao
# Modify.........: No.FUN-B80141 11/11/11 By baogc 添加金額小數位與面積小數位欄位
# Modify.........: No.TQC-C20132 12/02/13 By nanbing單身產品分類欄位開窗錄入值重複時，清空分類名稱
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_lla              RECORD LIKE    lla_file.*,
         g_lla_t            RECORD LIKE    lla_file.*,
         g_lla_o            RECORD LIKE    lla_file.*,
         g_llastore_t       LIKE  lla_file.llastore

DEFINE   g_llb              DYNAMIC ARRAY OF RECORD
            llb01           LIKE  llb_file.llb01,      #费用编号
            oaj02           LIKE  oaj_file.oaj02,      #费用名称
            llb02           LIKE  llb_file.llb02       #退款推迟月
                            END RECORD,
         g_llb_t            RECORD
            llb01           LIKE  llb_file.llb01,      #费用编号
            oaj02           LIKE  oaj_file.oaj02,      #费用名称
            llb02           LIKE  llb_file.llb02       #退款推迟月
                            END RECORD,          
         g_llb_o            RECORD
            llb01           LIKE  llb_file.llb01,      #费用编号
            oaj02           LIKE  oaj_file.oaj02,      #费用名称
            llb02           LIKE  llb_file.llb02       #退款推迟月
                            END RECORD
DEFINE   g_llc              DYNAMIC ARRAY OF RECORD
            llc01           LIKE  llc_file.llc01,      #产品分类
            oba02           LIKE  oba_file.oba02,      #分类名称
            llc02           LIKE  llc_file.llc02,      #最大免租天数
            llc03           LIKE  llc_file.llc03       #出账
                            END RECORD,
         g_llc_t            RECORD
            llc01           LIKE  llc_file.llc01,      #产品分类
            oba02           LIKE  oba_file.oba02,      #分类名称
            llc02           LIKE  llc_file.llc02,      #最大免租天数
            llc03           LIKE  llc_file.llc03       #出账
                            END RECORD,
         g_llc_o            RECORD
            llc01           LIKE  llc_file.llc01,      #产品分类
            oba02           LIKE  oba_file.oba02,      #分类名称
            llc02           LIKE  llc_file.llc02,      #最大免租天数
            llc03           LIKE  llc_file.llc03       #出账
                            END RECORD
DEFINE g_sql                STRING,                    #cursor暂存
       g_wc                 STRING,                    #单头的construct结果
       g_wc2                STRING,                    #单身一的construct结果
       g_wc3                STRING,                    #单身二的construct结果
       g_rec_b              LIKE type_file.num5,       #单身一的总笔数
       g_rec_b2             LIKE type_file.num5,       #单身二的总笔数
       l_ac                 LIKE type_file.num5,       #单身一当前指标
       l_ac2                LIKE type_file.num5        #单身一当前指标
DEFINE g_forupd_sql         STRING                     #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_chr                LIKE type_file.chr1    
DEFINE g_cnt                LIKE type_file.num10   
DEFINE g_i                  LIKE type_file.num5        #count/index for any purpose  
DEFINE g_msg                LIKE ze_file.ze03      
DEFINE g_curs_index         LIKE type_file.num10  
DEFINE g_row_count          LIKE type_file.num10       #總筆數  
DEFINE g_jump               LIKE type_file.num10       #查詢指定的筆數  
DEFINE g_no_ask             LIKE type_file.num5         #是否開啟指定筆視窗 

MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面會依照p_per設定的欄位順序做輸入，忽略INPUT寫的順
    END IF


   #若录入多个程序代码，在主程序呼叫cl_user()之前
   #需要设定全局变量g_prog的值,对应的p_zz设定
   IF(NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF(NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lla_file WHERE llastore = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s101_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW s101_w  WITH FORM "alm/42f/alms101"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL s101_menu()
   CLOSE WINDOW s101_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN 

FUNCTION s101_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_llb.clear()
   CALL g_llc.clear()

   CALL cl_set_head_visible("","YES")         
   INITIALIZE g_lla.* TO NULL 
   DIALOG ATTRIBUTE(UNBUFFERED)     
      CONSTRUCT BY NAME g_wc ON llastore,llalegal,lla01,lla02,lla03,lla04 #FUN-B80141 Add lla03,lla04 
                                ,lla05                      #FUN-B80141 add lla05
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT g_wc2 ON llb01,llb02
           FROM s_llb[1].llb01,s_llb[1].llb02
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT

      CONSTRUCT g_wc3 ON llc01,llc02,llc03
           FROM s_llc[1].llc01,s_llc[1].llc02,s_llc[1].llc03
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(llastore)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_llastore"
               LET g_qryparam.where = " llastore IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO llastore
               NEXT FIELD llastore
            WHEN INFIELD(llalegal)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_llalegal"
               LET g_qryparam.where = " llastore IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO llalegal
               NEXT FIELD llalegal
            WHEN INFIELD(llb01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_llb01"
               LET g_qryparam.where = " llbstore IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO llb01
               NEXT FIELD llb01
            WHEN INFIELD(llc01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_llc01"
               LET g_qryparam.where = " llcstore IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO llc01
               NEXT FIELD llc01
            OTHERWISE EXIT CASE
         END CASE
       
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
    
      ON ACTION about         
         CALL cl_about()      
    
      ON ACTION help          
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
   
   IF INT_FLAG THEN
         RETURN
   END IF
    
   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN
         LET   g_sql = " SELECT llastore FROM lla_file ",
                       "  WHERE ",g_wc CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"
      ELSE
         LET   g_sql = " SELECT llastore FROM lla_file,llb_file",
                       "  WHERE llbstore = llastore",
                       "    AND ",g_wc CLIPPED,
                       "    AND ",g_wc2 CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN
         LET   g_sql = " SELECT llastore FROM lla_file,llc_file",
                       "  WHERE llcstore = llastore",
                       "    AND ",g_wc CLIPPED,
                       "    AND ",g_wc3 CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"
      ELSE
         LET   g_sql = " SELECT llastore FROM lla_file,llb_file,llc_file",
                       "  WHERE  llbstore = llastore",
                       "    AND llcstore = llastore",
                       "    AND llbstore = llcstore",
                       "    AND ",g_wc CLIPPED,
                       "    AND ",g_wc2 CLIPPED,
                       "    AND ",g_wc3 CLIPPED,
                       "    AND llastore IN ",g_auth," ",                     
                       "  ORDER BY llastore"       
      END IF
   END IF
 
   PREPARE s101_prepare FROM g_sql
   DECLARE s101_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR s101_prepare 
 
   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN
         LET   g_sql = " SELECT COUNT(DISTINCT llastore) FROM lla_file ",
                       "  WHERE ",g_wc CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"
      ELSE
         LET   g_sql = " SELECT COUNT(DISTINCT llastore) FROM lla_file,llb_file",
                       "  WHERE llbstore = llastore",
                       "    AND ",g_wc CLIPPED,
                       "    AND ",g_wc2 CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN
         LET   g_sql = " SELECT COUNT(DISTINCT llastore) FROM lla_file,llc_file",
                       "  WHERE llcstore = llastore",
                       "    AND ",g_wc CLIPPED,
                       "    AND ",g_wc3 CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"
      ELSE
         LET   g_sql = " SELECT COUNT(DISTINCT llastore) FROM lla_file,llb_file,llc_file",
                       "  WHERE llbstore = llastore",
                       "    AND llcstore = llastore",
                       "    AND llbstore = llcstore",
                       "    AND ",g_wc CLIPPED,
                       "    AND ",g_wc2 CLIPPED,
                       "    AND ",g_wc3 CLIPPED,
                       "    AND llastore IN ",g_auth," ",
                       "  ORDER BY llastore"       
      END IF
   END IF
 
   PREPARE s101_precount FROM g_sql
   DECLARE s101_count CURSOR FOR s101_precount
 
END FUNCTION

FUNCTION s101_menu()
   WHILE TRUE
      CALL s101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s101_q()
            END IF

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL s101_a()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL s101_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL s101_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s101_b()
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
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_llb),base.TypeInfo.create(g_llc),'')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_lla.llastore IS NOT NULL THEN
                    LET g_doc.column1 = "llastore"
                    LET g_doc.value1 = g_lla.llastore
                 CALL cl_doc()
                 END IF
              END IF 
      END CASE
   END WHILE
END FUNCTION

FUNCTION s101_bp(p_ud)
   DEFINE p_ud  LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = ""

   CALL cl_set_act_visible("accept,cancel",FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_llb TO s_llb.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("s_llb")  #存放当前单身停留指针至共享变量l_ac
            CALL s101_b_fill(g_wc2)
            CALL s101_bp_refresh()
            CALL cl_show_fld_cont()                   #单身数据comment变更
         #TQC-C30136--mark--str--
         #ON ACTION accept
         #   LET g_action_choice = "detail"
         #   EXIT DIALOG
         #TQC-C30136--mark--end--
      END DISPLAY

      DISPLAY ARRAY g_llc TO s_llc.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting(g_curs_index,g_row_count)
         BEFORE ROW
            LET l_ac2 = DIALOG.getCurrentRow("s_llc")  #存放当前单身停留指针至共享变量l_ac
            CALL s101_b_fill_2(g_wc3)
            CALL s101_bp_refresh_2()
            CALL cl_show_fld_cont()                    #单身数据comment变更
        #TQC-C30136--mark--str--
        #ON ACTION accept
        #    LET g_action_choice = "detail"
        #    EXIT DIALOG
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
 
      ON ACTION first
         CALL s101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION previous
         CALL s101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 
 
      ON ACTION jump
         CALL s101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION next
         CALL s101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG  
 
      ON ACTION last
         CALL s101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

FUNCTION s101_bp_refresh()
   DISPLAY ARRAY g_llb TO s_llb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION s101_bp_refresh_2()
   DISPLAY ARRAY g_llc TO s_llc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION s101_q()
   LET g_curs_index = 0
   LET g_row_count  = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_llb.clear()
   CALL g_llc.clear()
   DISPLAY '' TO FORMONLY.cnt

   CALL s101_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lla.* TO NULL
      RETURN
   END IF

   OPEN s101_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lla.* TO NULL
   ELSE
      OPEN s101_count
      FETCH s101_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL s101_fetch('F')
   END IF
END FUNCTION

FUNCTION s101_a()
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_n         LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM
   CALL g_llb.clear()
   CALL g_llc.clear()
   LET g_wc = NULL
   LET g_wc2 = NULL
   LET g_wc3 = NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lla.*   LIKE  lla_file.*
   LET g_llastore_t = NULL

   LET g_lla_t.* = g_lla.*
   LET g_lla_o.* = g_lla.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET  g_lla.llastore = g_plant
      LET  g_lla.llalegal = g_legal
      LET  g_lla.lla02    = 'N'
      LET  g_lla.lla05    = 'N'     #FUN-B80141 add

      SELECT COUNT(*) INTO l_n
        FROM lla_file
       WHERE llastore = g_lla.llastore
      IF l_n > 0 THEN
         INITIALIZE g_lla.* TO NULL
         CALL cl_err('','alm1054',0)
         CLEAR FORM
         EXIT WHILE
      END IF

      CALL s101_llastore()
      CALL s101_llalegal()
         
      CALL s101_i("a")

      IF INT_FLAG THEN
         INITIALIZE g_lla.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lla.llastore) THEN
         CONTInue while
      END IF

      BEGIN WORK
     
      DISPLAY BY NAME g_lla.llastore
      
      INSERT INTO lla_file VALUES(g_lla.*)

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lla_file",g_lla.llastore,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lla.llastore,'I')
      END IF

      LET g_llastore_t = g_lla.llastore
      LET g_lla_t.* = g_lla.*
      LET g_lla_o.* = g_lla.*
      CALL g_llb.clear()
      CALL g_llc.clear()

      LET g_rec_b  = 0
      LET g_rec_b2 = 0
      CALL s101_b()   #单身输入
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION s101_u()

   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lla.llastore IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lla.llastore != g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
 
   SELECT * INTO g_lla.* FROM lla_file
    WHERE llastore = g_lla.llastore
    
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_llastore_t = g_lla.llastore
   BEGIN WORK
 
   OPEN s101_cl USING g_llastore_t
   IF STATUS THEN
      CALL cl_err("OPEN s101_cl:", STATUS, 1)
      CLOSE s101_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH s101_cl INTO g_lla.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lla.llastore,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE s101_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL s101_show()
 
   WHILE TRUE
      LET g_llastore_t = g_lla.llastore
      LET g_lla_o.* = g_lla.*
      CALL s101_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lla.* = g_lla_t.*
         CALL s101_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lla.llastore != g_llastore_t THEN            # 更改單號
         UPDATE llb_file SET llbstore = g_lla.llastore
          WHERE llbstore = g_llastore_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","llb_file",g_llastore_t,"",SQLCA.sqlcode,"","llb",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF

         UPDATE llc_file SET llcstore = g_lla.llastore
          WHERE llcstore = g_llastore_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","llc_file",g_llastore_t,"",SQLCA.sqlcode,"","llc",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lla_file SET lla_file.* = g_lla.*
       WHERE llastore = g_llastore_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lla_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE s101_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lla.llastore,'U')
 
   CALL s101_b_fill("1=1")
   CALL s101_b_fill_2("1=1")
   CALL s101_bp_refresh()
   CALL s101_bp_refresh_2()
END FUNCTION

FUNCTION s101_i(p_cmd)
   DEFINE  p_cmd  LIKE type_file.chr1
   DEFINE  l_n    LIKE type_file.num5
   DEFINE  li_result  LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lla.llastore,g_lla.llalegal,g_lla.lla02
 
   CALL cl_set_head_visible("","YES")          
   INPUT BY NAME g_lla.lla01,g_lla.lla02,g_lla.lla03,g_lla.lla04 #FUN-B80141 Add g_lla.lla03,g_lla.lla04
                 ,g_lla.lla05                                    #FUN-B80141 add
       WITHOUT DEFAULTS

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION

FUNCTION s101_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lla.llastore IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lla.llastore != g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
 
   SELECT * INTO g_lla.* FROM lla_file
    WHERE llastore = g_lla.llastore
   BEGIN WORK
 
   OPEN s101_cl USING g_lla.llastore
   IF STATUS THEN
      CALL cl_err("OPEN s101_cl:", STATUS, 1)
      CLOSE s101_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH s101_cl INTO g_lla.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lla.llastore,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL s101_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "llastore"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_lla.llastore      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lla_file WHERE llastore = g_lla.llastore
      DELETE FROM llb_file WHERE llbstore = g_lla.llastore
      DELETE FROM llc_file WHERE llcstore = g_lla.llastore
      CLEAR FORM
      CALL g_llb.clear()
      CALL g_llc.clear()
      OPEN s101_count
      FETCH s101_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN s101_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL s101_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL s101_fetch('/')
      END IF
   END IF
 
   CLOSE s101_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lla.llastore,'D')
END FUNCTION

FUNCTION s101_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT  s101_cs INTO g_lla.llastore
      WHEN 'P' FETCH PREVIOUS s101_cs INTO g_lla.llastore
      WHEN 'F' FETCH FIRST s101_cs INTO g_lla.llastore
      WHEN 'L' FETCH LAST  s101_cs INTO g_lla.llastore
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
         FETCH ABSOLUTE g_jump s101_cs INTO g_lla.llastore
         LET g_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lla.llastore,SQLCA.sqlcode,0)
      INITIALIZE g_lla.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
   SELECT * INTO g_lla.* FROM lla_file WHERE llastore = g_lla.llastore
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lla_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_lla.* TO NULL
      RETURN
   END IF

   CALL s101_show()
END FUNCTION

FUNCTION s101_show()
   DEFINE  l_rtz13  LIKE rtz_file.rtz13,
           l_azt02  LIKE azt_file.azt02
           
   LET g_lla_t.* = g_lla.*
   LET g_lla_o.* = g_lla.*
   DISPLAY BY NAME g_lla.*
   CALL s101_llastore()
   CALL s101_llalegal()

   CALL s101_b_fill(g_wc2)
   CALL s101_b_fill_2(g_wc3)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION s101_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
      l_n             LIKE type_file.num5,                #檢查重複用 
      l_n1            LIKE type_file.num5,              
      l_n2            LIKE type_file.num5,                
      l_n3            LIKE type_file.num5,                
      l_cnt           LIKE type_file.num5,                #檢查重複用  
      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
      p_cmd           LIKE type_file.chr1,                #處理狀態  
      p_flag          LIKE type_file.chr1,                #修改状态
      l_misc          LIKE gef_file.gef01,                
      l_allow_insert  LIKE type_file.num5,                #可新增否  
      l_allow_delete  LIKE type_file.num5                 #可刪除否  

   DEFINE  l_s      LIKE type_file.chr1000 
   DEFINE  l_m      LIKE type_file.chr1000 
   DEFINE  i        LIKE type_file.num5
   DEFINE  l_s1     LIKE type_file.chr1000 
   DEFINE  l_m1     LIKE type_file.chr1000 
   DEFINE  i1       LIKE type_file.num5
   DEFINE  l_tot    LIKE type_file.num10
   LET g_action_choice = ""
   LET g_success = "N"
   IF s_shut(0) THEN
       RETURN
    END IF
 
   IF g_lla.llastore IS NULL THEN
       RETURN
   END IF

   IF g_lla.llastore != g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
 
   SELECT * INTO g_lla.* FROM lla_file
    WHERE llastore = g_lla.llastore
 
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT llb01,'',llb02",
                      "  FROM llb_file",
                      " WHERE llbstore=? AND llb01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
                      
   DECLARE s101_bcl_b CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET g_forupd_sql = "SELECT llc01,'',llc02,llc03",
                      "  FROM llc_file",
                      " WHERE llcstore=? AND llc01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
                      
   DECLARE s101_bcl_c CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT ARRAY g_llb  FROM s_llb.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            DISPLAY g_rec_b TO FORMONLY.cn2
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN s101_cl USING g_lla.llastore
            IF STATUS THEN
               CALL cl_err("OPEN s101_cl:", STATUS, 1)
               CLOSE s101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH s101_cl INTO g_lla.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lla.llastore,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE s101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_llb_t.* = g_llb[l_ac].*  #BACKUP
               LET g_llb_o.* = g_llb[l_ac].*  #BACKUP
               OPEN s101_bcl_b USING g_lla.llastore,g_llb_t.llb01
               IF STATUS THEN
                  CALL cl_err("OPEN s101_bcl_b:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH s101_bcl_b INTO g_llb[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_llb_t.llb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
 
                  SELECT oaj02 INTO g_llb[l_ac].oaj02 FROM oaj_file
                   WHERE oaj01 = g_llb[l_ac].llb01
               END IF

               CALL cl_show_fld_cont()     
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_llb[l_ac].* TO NULL      
            LET g_llb[l_ac].llb02 = 0
            LET g_llb_t.* = g_llb[l_ac].*         #新輸入資料
            LET g_llb_o.* = g_llb[l_ac].*         #新輸入資料

            CALL cl_show_fld_cont()         
            NEXT FIELD llb01
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO llb_file(llbstore,llblegal,llb01,llb02)
            VALUES(g_lla.llastore,g_lla.llalegal,
                   g_llb[l_ac].llb01,g_llb[l_ac].llb02)
           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","llb_file",g_lla.llastore,g_llb[l_ac].llb01,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_success = "Y"
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            
         AFTER FIELD llb01
            IF NOT cl_null(g_llb[l_ac].llb01) THEN
               IF g_llb[l_ac].llb01 != g_llb_t.llb01
                  OR g_llb_t.llb01 IS NULL THEN      
                  SELECT  COUNT(*) INTO l_n
                    FROM  llb_file
                   WHERE  llbstore = g_lla.llastore
                     AND  llb01    = g_llb[l_ac].llb01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_llb[l_ac].llb01 = g_llb_t.llb01
                     LET g_llb[l_ac].oaj02 = g_llb_t.oaj02 #TQC-C20132 add 
                     NEXT FIELD llb01
                  END IF
               END IF #TQC-C20132 add
                  CALL s101_llb01(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET  g_llb[l_ac].llb01 = g_llb_t.llb01
                     NEXT FIELD llb01
                  END IF
          #     END IF                                  #TQC-C20132 MARK
            END IF

         AFTER FIELD llb02
            IF NOT cl_null(g_llb[l_ac].llb02) THEN
               IF  g_llb[l_ac].llb02 < 0 THEN
                   CALL cl_err(g_llb[l_ac].llb02,'alm-061',0)
                   LET g_llb[l_ac].llb02 = g_llb_t.llb02
                   NEXT FIELD llb02
               END IF
            END IF

         BEFORE DELETE                      #是否取消單身
            IF g_llb_t.llb01 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM llb_file
                WHERE llbstore = g_lla.llastore
                  AND llb01    = g_llb_t.llb01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","llb_file",g_lla.llastore,g_llb_t.llb01,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
            LET g_success = "Y"
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_llb[l_ac].* = g_llb_t.*
               CLOSE s101_bcl_b
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_llb[l_ac].llb01,-263,1)
               LET g_llb[l_ac].* = g_llb_t.*
            ELSE
               UPDATE llb_file SET llblegal= g_lla.llalegal,
                                   llb01   = g_llb[l_ac].llb01,
                                   llb02   = g_llb[l_ac].llb02
               WHERE llbstore = g_lla.llastore
                 AND llb01    = g_llb_t.llb01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","llb_file",g_lla.llastore,g_llb_t.llb01,SQLCA.sqlcode,"","",1) 
                  LET g_llb[l_ac].* = g_llb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  LET g_success = "Y"
               END IF
            END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' THEN
                  CALL g_llb.deleteElement(l_ac)
               END IF
               IF p_cmd = 'u' THEN
                  LET g_llb[l_ac].* = g_llb_t.*
               END IF
               CLOSE s101_bcl_b
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE s101_bcl_b
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(llb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_llb01_i"
                  LET g_qryparam.default1 = g_llb[l_ac].llb01
                  CALL cl_create_qry() RETURNING g_llb[l_ac].llb01
                  DISPLAY g_llb[l_ac].llb01 TO llb01
                  CALL s101_llb01('d')
                  NEXT FIELD llb01
               OTHERWISE EXIT CASE
            END CASE        
      END INPUT

      INPUT ARRAY g_llc  FROM s_llc.*
        ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            DISPLAY g_rec_b2 TO FORMONLY.cn2
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN s101_cl USING g_lla.llastore
            IF STATUS THEN
               CALL cl_err("OPEN s101_cl:", STATUS, 1)
               CLOSE s101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH s101_cl INTO g_lla.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lla.llastore,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE s101_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b2 >= l_ac2 THEN
               LET p_cmd='u'
               LET g_llc_t.* = g_llc[l_ac2].*  #BACKUP
               LET g_llc_o.* = g_llc[l_ac2].*  #BACKUP
               OPEN s101_bcl_c USING g_lla.llastore,g_llc_t.llc01
               IF STATUS THEN
                  CALL cl_err("OPEN s101_bcl_c:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH s101_bcl_c INTO g_llc[l_ac2].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_llc_t.llc01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
 
                  SELECT oba02 INTO g_llc[l_ac2].oba02 FROM oba_file
                   WHERE oba01 = g_llc[l_ac2].llc01
               END IF

               CALL cl_show_fld_cont()     
            END IF

         BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_llc[l_ac2].* TO NULL      
            LET g_llc_t.* = g_llc[l_ac2].*         #新輸入資料
            LET g_llc_o.* = g_llc[l_ac2].*         #新輸入資料

            CALL cl_show_fld_cont()         
            NEXT FIELD llc01
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO llc_file(llcstore,llclegal,llc01,llc02,llc03)
            VALUES(g_lla.llastore,g_lla.llalegal,g_llc[l_ac2].llc01,
                   g_llc[l_ac2].llc02,g_llc[l_ac2].llc03)
           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","llc_file",g_lla.llastore,g_llc[l_ac2].llc01,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b2=g_rec_b2+1
               DISPLAY g_rec_b2 TO FORMONLY.cn2
            END IF
            
         AFTER FIELD llc01
            IF NOT cl_null(g_llc[l_ac2].llc01) THEN
               IF g_llc[l_ac2].llc01 != g_llc_t.llc01   
                  OR g_llc_t.llc01 IS NULL THEN         
                  SELECT  COUNT(*) INTO l_n
                    FROM  llc_file
                   WHERE  llcstore = g_lla.llastore
                     AND  llc01    = g_llc[l_ac2].llc01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_llc[l_ac2].llc01 = g_llc_t.llc01
                     LET g_llc[l_ac2].oba02 = g_llc_t.oba02 #TQC-C20132 add
                     NEXT FIELD llc01
                  END IF
               END IF #TQC-C20132 add
                  CALL s101_llc01(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_llc[l_ac2].llc01 = g_llc_t.llc01
                     NEXT FIELD llc01
                  END IF
            #   END IF                                 #TQC-C20132 MARK
            END IF

         AFTER FIELD llc02
            IF NOT cl_null(g_llc[l_ac2].llc02) THEN
               IF  g_llc[l_ac2].llc02 < 0 THEN
                   CALL cl_err(g_llc[l_ac2].llc02,'alm-061',0)
                   LET g_llc[l_ac2].llc02 = g_llc_t.llc02
                   NEXT FIELD llc02
               END IF
            END IF

         BEFORE DELETE                      #是否取消單身
            IF g_llc_t.llc01 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM llc_file
                WHERE llcstore = g_lla.llastore
                  AND llc01    = g_llc_t.llc01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","llc_file",g_lla.llastore,g_llc_t.llc01,SQLCA.sqlcode,"","",1)  
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b2=g_rec_b2-1
               DISPLAY g_rec_b2 TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_llc[l_ac2].* = g_llc_t.*
               CLOSE s101_bcl_c
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_llc[l_ac2].llc01,-263,1)
               LET g_llc[l_ac2].* = g_llc_t.*
            ELSE
               UPDATE llc_file SET llclegal= g_lla.llalegal,
                                   llc01   = g_llc[l_ac2].llc01,
                                   llc02   = g_llc[l_ac2].llc02,
                                   llc03   = g_llc[l_ac2].llc03
               WHERE llcstore = g_lla.llastore
                 AND llc01    = g_llc_t.llc01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","llc_file",g_lla.llastore,g_llc_t.llc01,SQLCA.sqlcode,"","",1) 
                  LET g_llc[l_ac2].* = g_llc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
         AFTER ROW
            LET l_ac2 = ARR_CURR()
            LET l_ac_t = l_ac2
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' THEN
                  CALL g_llc.deleteElement(l_ac2)
               END IF
               IF p_cmd = 'u' THEN
                  LET g_llc[l_ac2].* = g_llc_t.*
               END IF
               CLOSE s101_bcl_c
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE s101_bcl_c
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(llc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_llc01_i"
                  LET g_qryparam.default1 = g_llc[l_ac2].llc01
                  CALL cl_create_qry() RETURNING g_llc[l_ac2].llc01
                  DISPLAY g_llc[l_ac2].llc01 TO llc01
                  CALL s101_llc01('d')
                  NEXT FIELD llc01
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

    CLOSE s101_bcl_b
    CLOSE s101_bcl_c
    COMMIT WORK
END FUNCTION

FUNCTION s101_b_fill(p_wc2)
   DEFINE p_wc2    STRING
   DEFINE l_oaj02    LIKE  oaj_file.oaj02
   LET g_sql = "SELECT llb01,'',llb02",
               "  FROM llb_file",
               " WHERE llbstore ='",g_lla.llastore,"'",
               "   AND llbstore IN ",g_auth," "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY llbstore,llb01"

   PREPARE s101_pb FROM g_sql
   DECLARE llb_cs CURSOR FOR s101_pb

   CALL g_llb.clear()
   LET g_cnt = 1

   FOREACH llb_cs INTO g_llb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT oaj02 INTO g_llb[g_cnt].oaj02 FROM oaj_file
         WHERE oaj01 = g_llb[g_cnt].llb01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oaj_file",g_llb[g_cnt].oaj02,"",SQLCA.sqlcode,"","",0)    
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_llb.deleteElement(g_cnt)  

   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION s101_b_fill_2(p_wc3)
   DEFINE p_wc3    STRING

   LET g_sql = "SELECT llc01,'',llc02,llc03",
               "  FROM llc_file",
               " WHERE llcstore ='",g_lla.llastore,"'",
               "   AND llcstore IN ",g_auth," "
   IF NOT cl_null(p_wc3) THEN
      LET g_sql = g_sql CLIPPED," AND ",p_wc3 CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY llcstore,llc01"

   PREPARE s101_pb_llc FROM g_sql
   DECLARE llc_cs CURSOR FOR s101_pb_llc

   CALL g_llc.clear()
   LET g_cnt = 1

   FOREACH llc_cs INTO g_llc[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT oba02 INTO g_llc[g_cnt].oba02 FROM oba_file
         WHERE oba01 = g_llc[g_cnt].llc01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oba_file",g_llc[g_cnt].oba02,"",SQLCA.sqlcode,"","",0)    
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_llc.deleteElement(g_cnt)  

   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION s101_llb01(p_cmd)
   DEFINE    p_cmd     LIKE  type_file.chr1,
             l_oaj02   LIKE  oaj_file.oaj02,
             l_oajacti LIKE oaj_file.oajacti
   LET   g_errno = ''
   SELECT oaj02,oajacti INTO l_oaj02,l_oajacti
     FROM oaj_file
    WHERE oaj01 = g_llb[l_ac].llb01
   CASE
      WHEN SQLCA.sqlcode = 100
         LET  g_errno = 'alm1031'
         LET  l_oaj02 = NULL
      WHEN l_oajacti = 'N'
         LET  g_errno = 'alm1032'
         LET  l_oaj02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '--------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_oaj02 TO oaj02
      LET  g_llb[l_ac].oaj02 = l_oaj02
   END IF
END FUNCTION

FUNCTION s101_llc01(p_cmd)
   DEFINE    p_cmd     LIKE  type_file.chr1,
             l_oba01   LIKE  oba_file.oba01,
             l_oba02   LIKE  oba_file.oba02,
             l_oba12   LIKE  oba_file.oba12,
             l_oba14   LIKE  oba_file.oba14,
             l_oba15   LIKE  oba_file.oba15,
             l_obaacti LIKE oba_file.obaacti
   LET   g_errno = ''
   SELECT oba01,oba02,oba12,oba14,oba15,obaacti
     INTO l_oba01,l_oba02,l_oba12,l_oba14,l_oba15,l_obaacti
     FROM oba_file
    WHERE oba01 = g_llc[l_ac2].llc01
   CASE
      WHEN SQLCA.sqlcode = 100
         LET  g_errno = 'alm1033'
         LET  l_oba02 = NULL
      WHEN l_obaacti = 'N'
         LET  g_errno = 'alm1034'
         LET  l_oba02 = NULL
     #WHEN l_oba14 <> 0
     #   LET  g_errno = 'alm-846'
     #   LET  l_oba02 = NULL
      WHEN l_oba15 <> l_oba01
         LET  g_errno = 'alm-681'
         LET  l_oba02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '--------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_oba02 TO oba02
      LET  g_llc[l_ac2].oba02 = l_oba02
   END IF
END FUNCTION

FUNCTION s101_llastore()
   DEFINE  l_rtz13   LIKE  rtz_file.rtz13
   SELECT rtz13 INTO l_rtz13 FROM rtz_file 
    WHERE rtz01 = g_lla.llastore 
   DISPLAY l_rtz13 TO rtz13
END FUNCTION

FUNCTION s101_llalegal()
   DEFINE  l_azt02  LIKE  azt_file.azt02
   SELECT azt02 INTO l_azt02 FROM azt_file 
    WHERE azt01 = g_lla.llalegal
   DISPLAY l_azt02 TO azt02
END FUNCTION
#FUN-B90056
