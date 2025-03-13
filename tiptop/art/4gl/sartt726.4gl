# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sartt726.4gl
# Descriptions...:
# Modify.........: No:FUN-9B0025 09/11/11 By Cockroach 
# Modify.........: FUN-9B0025 09/12/09 By cockroach PASS NO.
# Modify.........: FUN-A10008 10/01/06 By Cockroach 調整一些字段管控
# Modify.........: FUN-A10047 10/01/18 By destiny bug修改     
# Modify.........: TQC-A20021 10/02/09 By Cockroach bug處理
# Modify.........: TQC-A20022 10/02/21 By destiny 审核时报错有误 
# Modify.........: TQC-A20039 10/02/22 By Cockroach 儲位、批號賦空值
# Modify.........: TQC-A20048 10/02/22 By Cockroach BUG處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: TQC-A30002 10/03/01 By Cockroach BUG處理
# Modify.........: TQC-A30058 10/03/17 By Cockroach bug 處理
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AB0067 10/11/17 by destiny  增加倉庫的權限控管
# Modify.........: No.TQC-AC0249 10/12/22 by huangrh  自动带出单身去掉不已出量大于入场量的，修改来源单号开窗
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-BB0085 11/12/27 By xianghui 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20183 12/02/21 By fengrui 數量欄位小數取位處理
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70087 12/08/03 By bart 整批寫入img_file
# Modify.........: No:FUN-C80046 12/08/16 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-CC0095 12/12/18 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds                  #FUN-9B0025 

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt726.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
DEFINE g_run06_t LIKE run_file.run06   #FUN-BB0085--add--
#DEFINE   l_img_table      STRING              #FUN-C70087 #FUN-CC0095

FUNCTION t726(p_argv1)
DEFINE p_argv1 LIKE type_file.chr1
 
    WHENEVER ERROR CALL cl_err_msg_log
    #CALL s_padd_img_create() RETURNING l_img_table  #FUN-C70087 #FUN-CC0095
    LET g_rum00 = p_argv1
    LET g_forupd_sql="SELECT * FROM rum_file ",
                     " WHERE rum00='",g_rum00,"' AND rum01=? AND rumplant=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t726_cl CURSOR FROM g_forupd_sql
    

       LET p_row = 4 LET p_col = 10
       OPEN WINDOW t726_w AT p_row,p_col WITH FORM "art/42f/artt726"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_init()
    CALL cl_set_comp_visible("rum02,run08",g_rum00='2') 
    CALL t726_g_form()
 
    CALL t726_menu()
    
    CLOSE WINDOW t726_w
    #CALL s_padd_img_drop(l_img_table)  #FUN-C70087 #FUN-CC0095
END FUNCTION
 
FUNCTION t726_g_form()
DEFINE l_rum01 LIKE gae_file.gae04
DEFINE l_rum04 LIKE gae_file.gae04
DEFINE l_run06 LIKE gae_file.gae04
DEFINE l_run10 LIKE gae_file.gae04
DEFINE l_inx   LIKE type_file.num5
DEFINE l_str STRING

    SELECT gae04 INTO l_rum01 FROM gae_file
     WHERE gae01 = 'artt726'
       AND gae12 = 'std'
       AND gae02 = 'rum01'
       AND gae03 = g_lang
    SELECT gae04 INTO l_rum04 FROM gae_file
     WHERE gae01 = 'artt726'
       AND gae12 = 'std'
       AND gae02 = 'rum04'
       AND gae03 = g_lang
    SELECT gae04 INTO l_run06 FROM gae_file
     WHERE gae01 = 'artt726'
       AND gae12 = 'std'
       AND gae02 = 'run06'
       AND gae03 = g_lang
    SELECT gae04 INTO l_run10 FROM gae_file
     WHERE gae01 = 'artt726'
       AND gae12 = 'std'
       AND gae02 = 'run10'
       AND gae03 = g_lang
       
    IF g_rum00='1' THEN
       LET l_str = l_rum01
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rum01",l_str.subString(1,l_inx-1))
       LET l_str = l_rum04
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rum04",l_str.subString(1,l_inx-1))  
       LET l_str = l_run06
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("run06",l_str.subString(1,l_inx-1))
       LET l_str = l_run10
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("run10",l_str.subString(1,l_inx-1)) 
    ELSE
       LET l_str = l_rum01
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rum01",l_str.subString(l_inx+1,l_str.getLength()))
       LET l_str = l_rum04
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("rum04",l_str.subString(l_inx+1,l_str.getLength()))
       LET l_str = l_run06
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("run06",l_str.subString(l_inx+1,l_str.getLength()))
       LET l_str = l_run10
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("run10",l_str.subString(l_inx+1,l_str.getLength()))
    END IF
    DISPLAY g_rum00 TO rum00  #FUN-A10008 ADD
END FUNCTION
 
FUNCTION t726_menu()
 
   WHILE TRUE
      CALL t726_bp("G")
      CASE g_action_choice
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t726_y()
            END IF
            
        WHEN "unconfirm"
           IF cl_chk_act_auth() THEN    
              CALL t726_unconfirm()
           END IF       
                  
         WHEN "void" 
            IF cl_chk_act_auth() THEN
               CALL t726_v()
            END IF 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t726_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t726_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t726_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t726_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t726_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t726_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t726_m_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
    
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t726_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_run),'','')
             END IF        
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rum.rum01) THEN
                 LET g_doc.column1 = "rum00"
                 LET g_doc.column2 = "rum01"
                 LET g_doc.value1 = g_rum00
                 LET g_doc.value2 = g_rum.rum01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t726_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_run TO s_run.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY  
      ON ACTION void
         LET g_action_choice="void"
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
         CALL t726_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL t726_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t726_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL t726_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t726_fetch('L')
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
         CALL t726_g_form()       #TQC-A20048 ADD
  
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
 
FUNCTION t726_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_run.clear()
    CONSTRUCT BY NAME g_wc ON                  #TQC-A20021 MARK  rum00,                             
        rum01,rum02,rum03,rum04,rum05,
        rum06,rumconf,rumcond,
        rumconu,rumplant,rumuser,
        rumgrup,rummodu,rumdate,rumacti,
        rumcrat,rumoriu,rumorig
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init() 
           DISPLAY g_rum00 TO rum00
        ON ACTION controlp
           CASE
              WHEN INFIELD(rum01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rum01"
                 LET g_qryparam.arg1=g_rum00
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rum01
                 NEXT FIELD rum01
              WHEN INFIELD(rum02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rum02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rum02
                 NEXT FIELD rum02
              WHEN INFIELD(rum03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rum03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rum03
                 NEXT FIELD rum03   
              WHEN INFIELD(rum05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rum05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rum05
                 NEXT FIELD rum05
              WHEN INFIELD(rumconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rumconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rumconu
                 NEXT FIELD rumconu
              WHEN INFIELD(rumplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rumplant"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rumplant
                 NEXT FIELD rumplant
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rumuser', 'rumgrup')
   
    CONSTRUCT g_wc2 ON run02,run03,run04,run05,run06,run07,
                       run08,run09,run10,run11,run12,run13
                  FROM s_run[1].run02,s_run[1].run03,s_run[1].run04,
                       s_run[1].run05,s_run[1].run06,s_run[1].run07,
                       s_run[1].run08,s_run[1].run09,s_run[1].run10,
                       s_run[1].run11,s_run[1].run12,s_run[1].run13
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
            # WHEN INFIELD(run02)                         #TQC-A20021 mark 
            #    CALL cl_init_qry_var()
            #    LET g_qryparam.form = "q_run02"
            #    LET g_qryparam.state = "c"
            #    CALL cl_create_qry() RETURNING g_qryparam.multiret
            #    DISPLAY g_qryparam.multiret TO run02
            #    NEXT FIELD run02
              WHEN INFIELD(run05)                         #TQC-A20021 ADD
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_run05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO run05
                 NEXT FIELD run05
              WHEN INFIELD(run03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_run03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO run03
                 NEXT FIELD run03
              WHEN INFIELD(run04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_run04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO run04
                 NEXT FIELD run04
              WHEN INFIELD(run06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_run06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO run06
                 NEXT FIELD run06
              WHEN INFIELD(run11)
                 #No.FUN-AA0049--begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_run11"
                 #LET g_qryparam.state = "c"
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                 #No.FUN-AA0049--end
                 DISPLAY g_qryparam.multiret TO run11
                 NEXT FIELD run11
              WHEN INFIELD(run12)
                 #No.FUN-AA0049--begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_run12"
                 #LET g_qryparam.state = "c"
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                 #No.FUN-AA0049--end
                 DISPLAY g_qryparam.multiret TO run12
                 NEXT FIELD run12
              WHEN INFIELD(run13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_run13"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO run13
                 NEXT FIELD run13
                    
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
        LET g_sql = "SELECT rum00,rum01,rumplant FROM rum_file ", 
                    " WHERE rum00 = '",g_rum00,"'",
                    "   AND ",g_wc CLIPPED," ORDER BY rum01"
    ELSE                                 
        LET g_sql = "SELECT UNIQUE rum00,rum01,rumplant ",
                    "  FROM rum_file,run_file",
                    " WHERE rum01=run01",
                    "   AND rum00=run00",
                    "   AND rum00='",g_rum00,"'",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY rum01"
    END IF 
    PREPARE t726_prepare FROM g_sql
    DECLARE t726_cs SCROLL CURSOR WITH HOLD FOR t726_prepare
    
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(rum00||rum01||rumplant) FROM rum_file ",
                 " WHERE rum00='",g_rum00,"' AND ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(rum00||rum01||rumplant) FROM rum_file,run_file",
                 " WHERE rum01=run01 ",
                 "   AND rum00=run00",
                 "   AND rum00='",g_rum00,"'",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t726_precount FROM g_sql
    DECLARE t726_count CURSOR FOR t726_precount
END FUNCTION
 
FUNCTION t726_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_run.clear()
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
 
    CALL t726_cs()
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rum.* TO NULL
        CALL g_run.clear()
        RETURN
    END IF
 
    OPEN t726_cs
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_run.clear()
    ELSE
       OPEN t726_count
       FETCH t726_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL t726_fetch('F')
       ELSE
          CALL cl_err('',100,0)
       END IF
    END IF
END FUNCTION
 
FUNCTION t726_fetch(p_flrum)
DEFINE p_flrum         LIKE type_file.chr1    
       
    CASE p_flrum
        WHEN 'N' FETCH NEXT     t726_cs INTO g_rum.rum00,g_rum.rum01,g_rum.rumplant
        WHEN 'P' FETCH PREVIOUS t726_cs INTO g_rum.rum00,g_rum.rum01,g_rum.rumplant
        WHEN 'F' FETCH FIRST    t726_cs INTO g_rum.rum00,g_rum.rum01,g_rum.rumplant
        WHEN 'L' FETCH LAST     t726_cs INTO g_rum.rum00,g_rum.rum01,g_rum.rumplant
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
            FETCH ABSOLUTE g_jump t726_cs INTO g_rum.rum00,g_rum.rum01,g_rum.rumplant
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rum.rum01,SQLCA.sqlcode,0)
        INITIALIZE g_rum.* TO NULL  
        RETURN
    ELSE
      CASE p_flrum
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rum.* FROM rum_file    
     WHERE rum00 = g_rum00
       AND rum01 = g_rum.rum01
       AND rumplant=g_rum.rumplant
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rum_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rum.rumuser           
        LET g_data_group=g_rum.rumgrup
        LET g_data_plant=g_rum.rumplant
        CALL t726_show()                   
    END IF
END FUNCTION
 
FUNCTION t726_show()
DEFINE l_gen02  LIKE gen_file.gen02
DEFINE l_gen021 LIKE gen_file.gen02
DEFINE l_occ02  LIKE occ_file.occ02
DEFINE l_azp02  LIKE azp_file.azp02
DEFINE l_pmc03  LIKE pmc_file.pmc03
 
    LET g_rum_t.* = g_rum.*
    DISPLAY BY NAME g_rum.rum00,g_rum.rum01,g_rum.rum02,g_rum.rum03,
                    g_rum.rum04,g_rum.rum05,g_rum.rum06,g_rum.rumconf,
                    g_rum.rumcond,g_rum.rumconu,g_rum.rumplant,
                    g_rum.rumuser,g_rum.rumgrup,g_rum.rummodu,
                    g_rum.rumdate,g_rum.rumacti,g_rum.rumcrat,
                    g_rum.rumoriu,g_rum.rumorig

    IF cl_null(g_rum.rum05) THEN
       DISPLAY '' TO rum05_desc
    ELSE
       SELECT gen02 INTO l_gen02 FROM gen_file
        WHERE gen01 = g_rum.rum05
          AND genacti = 'Y'
       DISPLAY l_gen02 TO rum05_desc
    END IF
    
    IF cl_null(g_rum.rumconu) THEN
       DISPLAY '' TO rumconu_desc
    ELSE
       SELECT gen02 INTO l_gen021 FROM gen_file
        WHERE gen01 = g_rum.rumconu
          AND genacti = 'Y'
       DISPLAY l_gen021 TO rumconu_desc
    END IF
    
    SELECT pmc03 INTO l_pmc03   #TQC-A30058
      FROM pmc_file
     WHERE pmc01 = g_rum.rum03
    DISPLAY l_pmc03 TO FORMONLY.rum03_desc
   
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_rum.rumplant

    DISPLAY l_azp02 TO rumplant_desc
    CALL t726_rum05('d')
    CASE g_rum.rumconf
       WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
       WHEN "N"
          CALL cl_set_field_pic('',"","","","",g_rum.rumacti)
       WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    CALL t726_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t726_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
       LET g_sql = "SELECT run02,run05,run03,'',run04,'',run06,'',run07,run08,",
                   "       run09,run10,run11,run12,run13",
                   "  FROM run_file ",
                   " WHERE run01 = '",g_rum.rum01,"'",
                   "   AND run00 = '",g_rum00,"'"
       IF NOT cl_null(p_wc2) THEN
          LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
       END IF
    PREPARE t726_pb FROM g_sql
    DECLARE run_cs CURSOR FOR t726_pb
 
    CALL g_run.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH run_cs INTO g_run[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH
        END IF

        SELECT ima02 INTO g_run[g_cnt].run03_desc FROM ima_file
         WHERE ima01 = g_run[g_cnt].run03
           AND imaacti = 'Y'        
        SELECT gfe02 INTO g_run[g_cnt].run04_desc FROM gfe_file
         WHERE gfe01 = g_run[g_cnt].run04
           AND gfeacti = 'Y'        
        SELECT gfe02 INTO g_run[g_cnt].run06_desc FROM gfe_file
         WHERE gfe01 = g_run[g_cnt].run06
           AND gfeacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_run.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t726_a_default()
DEFINE l_azp02 LIKE azp_file.azp02

      LET g_rum.rum00 = g_rum00
      LET g_rum.rum04 = g_today
      LET g_rum.rum05 = g_user
      LET g_rum.rumconf = 'N'
      LET g_rum.rumplant = g_plant
      LET g_rum.rumuser = g_user
      LET g_rum.rumgrup = g_grup
      LET g_rum.rumcrat = g_today
      LET g_rum.rumacti = 'Y' 
      LET g_rum.rumoriu = g_user
      LET g_rum.rumorig = g_grup 
      LET g_data_plant=g_plant
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
      SELECT azw02 INTO g_rum.rumlegal FROM azw_file
       WHERE azw01 = g_plant
         AND azwacti = 'Y'
      DISPLAY BY NAME g_rum.rum03,g_rum.rum05,
                      g_rum.rumconf,g_rum.rumplant,g_rum.rumuser,
                      g_rum.rumgrup,g_rum.rumcrat,g_rum.rumacti,
                      g_rum.rumoriu,g_rum.rumorig
      DISPLAY l_azp02 TO rumplant_desc

END FUNCTION
 
FUNCTION t726_a()
DEFINE li_result LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_run.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rum.* LIKE rum_file.*                  
 
   LET g_rum_t.* = g_rum.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t726_a_default()                   
      CALL t726_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rum.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rum.rum01) THEN       
         CONTINUE WHILE
      END IF
      BEGIN WORK
      IF g_rum00 ='1' THEN  #FUN-A10008 ADD 
#        CALL s_auto_assign_no("art",g_rum.rum01,g_today,"7","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mark
         CALL s_auto_assign_no("art",g_rum.rum01,g_today,"I5","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mod
         RETURNING li_result,g_rum.rum01
      ELSE
#        CALL s_auto_assign_no("art",g_rum.rum01,g_today,"8","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mark
         CALL s_auto_assign_no("art",g_rum.rum01,g_today,"I6","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mod
         RETURNING li_result,g_rum.rum01
      END IF 
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rum.rum01
     
      INSERT INTO rum_file VALUES (g_rum.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err(g_rum.rum01,SQLCA.sqlcode,1)   
         CALL cl_err3("ins","rum_file",g_rum.rum01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rum.* FROM rum_file
       WHERE rum01 = g_rum.rum01
         AND rum00 = g_rum00  
         AND rumplant=g_rum.rumplant
      LET g_rum_t.* = g_rum.*
      CALL g_run.clear()
      IF g_rum00 = '2' THEN
         IF cl_confirm("art-221") THEN
            BEGIN WORK
            CALL t726_b_create()
            IF g_success = 'Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
#              CALL t726_delall() #CHI-C30002 mark
               CALL t726_delHeader()     #CHI-C30002 add
               RETURN
            END IF
            CALL t726_b_fill(" 1=1")
            LET l_ac=1
         ELSE
            LET g_rec_b=0
         END IF
      END IF

      CALL t726_m_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION

FUNCTION t726_b_create()
DEFINE l_run RECORD LIKE run_file.*
  
   LET g_success='Y' 
   LET g_sql = "SELECT * FROM run_file ",
               " WHERE run01 = '",g_rum.rum02,"'",
               "   AND run00 = '1' AND runplant='",g_rum.rumplant,"' ",
               "   AND run10 > run09 "           #TQC-AC0249
    PREPARE t726_pb1 FROM g_sql
    DECLARE run_cs1 CURSOR FOR t726_pb1                   
 
     #LET g_cnt=1
      LET g_cnt=0
      FOREACH run_cs1 INTO l_run.*
         IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
         END IF
         LET l_run.run00 = g_rum00
         LET l_run.run01 = g_rum.rum01
         LET l_run.run08 = l_run.run10
         LET l_run.run10 = l_run.run08-l_run.run09
         INSERT INTO run_file VALUES (l_run.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH

END FUNCTION
 
FUNCTION t726_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1
     
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME
      g_rum.rum01,g_rum.rum02,g_rum.rum03,
      g_rum.rum04,g_rum.rum05,g_rum.rum06   
      WITHOUT DEFAULTS
 
      BEFORE INPUT
        
         LET g_before_input_done = FALSE
         CALL t726_set_entry(p_cmd)
         CALL t726_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rum01")      #TQC-A20021 ADD
         DISPLAY g_rum00 TO rum00   #FUN-A10008 ADD	

         IF g_rum00 = '2' THEN
            CALL  cl_set_comp_entry("rum03",FALSE)
         END IF
   
      AFTER FIELD rum01
         IF NOT cl_null(g_rum.rum01) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rum.rum01 <> g_rum_t.rum01) THEN
               IF g_rum00='1' THEN
#                 CALL s_check_no("art",g_rum.rum01,g_rum_t.rum01,"7","rum_file","rum00,rum01,rumplant","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_rum.rum01,g_rum_t.rum01,"I5","rum_file","rum00,rum01,rumplant","")  #FUN-A70130 mod
                    RETURNING li_result,g_rum.rum01
               ELSE  
#                 CALL s_check_no("art",g_rum.rum01,g_rum_t.rum01,"8","rum_file","rum00,rum01,rumplant","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_rum.rum01,g_rum_t.rum01,"I6","rum_file","rum00,rum01,rumplant","")  #FUN-A70130 mod
                    RETURNING li_result,g_rum.rum01
               END IF 
               IF (NOT li_result) THEN
                  LET g_rum.rum01=g_rum_t.rum01
                  NEXT FIELD rum01
               END IF
            END IF
         END IF
      
       AFTER FIELD rum02
           IF NOT cl_null(g_rum.rum02) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_rum.rum02!=g_rum_t.rum02) THEN
                 CALL t726_rum02()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rum02
                 END IF
              END IF
           END IF

       AFTER FIELD rum03
           IF NOT cl_null(g_rum.rum03) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_rum.rum03!=g_rum_t.rum03) THEN
                 CALL t726_rum03()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD rum03
                 END IF
              END IF
           END IF
              
       #退場日期應該小于等于入場日期
     # AFTER FIELD rum04
         
      AFTER FIELD rum05
         IF NOT cl_null(g_rum.rum05) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rum.rum05 != g_rum_t.rum05) THEN
               CALL t726_rum05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rum.rum05,g_errno,0)
                  LET g_rum.rum05 = g_rum.rum05
                  DISPLAY BY NAME g_rum.rum05
                  NEXT FIELD rum05
               END IF
            END IF
         END IF    
         
      AFTER INPUT
         LET g_rum.rumuser = s_get_data_owner("rum_file") #FUN-C10039
         LET g_rum.rumgrup = s_get_data_group("rum_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rum.rum01) THEN
               NEXT FIELD rum01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rum01) THEN
            LET g_rum.* = g_rum_t.*
            CALL t726_show()
            NEXT FIELD rum01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rum01)
              LET g_t1=s_get_doc_no(g_rum.rum01)
              IF g_rum00 = '1' THEN
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','7') RETURNING g_t1  #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'I5','ART') RETURNING g_t1  #FUN-A70130--mod--
              ELSE
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','8') RETURNING g_t1  #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'I6','ART') RETURNING g_t1  #FUN-A70130--mod--
              END IF
              LET g_rum.rum01=g_t1
              DISPLAY BY NAME g_rum.rum01
              NEXT FIELD rum01
           WHEN INFIELD(rum02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rum1"
              LET g_qryparam.default1 = g_rum.rum02
              LET g_qryparam.arg1 = '1'
              CALL cl_create_qry() RETURNING g_rum.rum02
              DISPLAY BY NAME g_rum.rum02
              CALL t726_rum02()
              NEXT FIELD rum02
           WHEN INFIELD(rum03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc2"
              LET g_qryparam.default1 = g_rum.rum03
              CALL cl_create_qry() RETURNING g_rum.rum03
              DISPLAY BY NAME g_rum.rum03
              CALL t726_rum03()
              NEXT FIELD rum03
           WHEN INFIELD(rum05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rum.rum05
              CALL cl_create_qry() RETURNING g_rum.rum05
              DISPLAY BY NAME g_rum.rum05
              CALL t726_rum05('d')
              NEXT FIELD rum05
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
 
FUNCTION t726_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rum.rum01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rum.* FROM rum_file
    WHERE rum01 = g_rum.rum01
      AND rum00 = g_rum00
      AND rumplant=g_rum.rumplant
   IF g_rum.rumacti ='N' THEN    
      CALL cl_err(g_rum.rum01,'mfg1000',0)
      RETURN
   END IF
   IF g_rum.rumconf <>'N' THEN
      CALL cl_err(g_rum.rum01,'9022',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK
 
   OPEN t726_cl USING g_rum.rum01,g_plant
   IF STATUS THEN
      CALL cl_err("OPEN t726_cl:", STATUS, 1)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t726_cl INTO g_rum.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rum.rum01,SQLCA.sqlcode,0)    
       CLOSE t726_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t726_show()
 
   WHILE TRUE
      LET g_rum.rummodu = g_user
      LET g_rum.rumdate = g_today
 
      CALL t726_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rum.*=g_rum_t.*
         CALL t726_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rum.rum01 <> g_rum_t.rum01 THEN            
         UPDATE run_file SET run01 = g_rum.rum01
          WHERE run01 = g_rum_t.rum01
            AND run00 = g_rum00
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","run_file",g_rum_t.rum01,"",SQLCA.sqlcode,"","run",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rum_file SET rum_file.* = g_rum.*
       WHERE rum00 = g_rum00
         AND rum01 = g_rum.rum01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rum_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t726_cl
   COMMIT WORK
   CALL t726_show()
 
END FUNCTION
 
FUNCTION t726_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          
 
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rum01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t726_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rum01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t726_b()
DEFINE l_ac_t LIKE type_file.num5
DEFINE l_n    LIKE type_file.num5
DEFINE l_lock_sw LIKE type_file.chr1
DEFINE p_cmd  LIKE type_file.chr1
#FUN-A10008 ADD-----------------
DEFINE l_flag          LIKE type_file.chr1 
DEFINE l_fac           LIKE type_file.num20_6 
DEFINE l_msg           LIKE type_file.chr1000,
       sn1             LIKE type_file.num5,
       sn2             LIKE type_file.num5
DEFINE l_imd20         LIKE imd_file.imd20
DEFINE l_imd20_1         LIKE imd_file.imd20   
#FUN-A10008 ADD---------------                
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_t             LIKE type_file.num5
DEFINE i               LIKE type_file.num5
DEFINE l_ima906  LIKE ima_file.ima906  #FUN-C30300

   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
        
   IF cl_null(g_rum.rum01) THEN
      RETURN 
   END IF
       
   SELECT * INTO g_rum.* FROM rum_file
    WHERE rum01=g_rum.rum01
      AND rum00=g_rum.rum00
      AND rumplant=g_rum.rumplant  
   IF g_rum.rumacti='N' THEN 
      CALL cl_err(g_rum.rum01,'aec-024',0)
      RETURN 
   END IF
   IF g_rum.rumconf<>'N' THEN
      CALL cl_err(g_rum.rum01,'9022',0)
      RETURN
   END IF    
   CALL cl_opmsg('b')
        
   LET g_forupd_sql="SELECT run02,run05,run03,'',run04,'',",
                    "       run06,'',run07,run08,run09,run10,",
                    "       run11,run12,run13",
                    "  FROM run_file",
                    " WHERE run00 = '",g_rum00,"'",
                    "   AND run01=? AND run02=?",
                    "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t726_bcl CURSOR FROM g_forupd_sql
        
#   IF g_rum00 = '2' THEN
#      LET l_allow_insert = FALSE
#      LET l_allow_delete = FALSE
#   END IF

   INPUT ARRAY g_run WITHOUT DEFAULTS FROM s_run.*
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
         OPEN t726_cl USING g_rum.rum01,g_plant
         IF STATUS THEN
            CALL cl_err("OPEN t726_cl:",STATUS,1)
            CLOSE t726_cl
            ROLLBACK WORK
         END IF
                
         FETCH t726_cl INTO g_rum.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_rum.rum01,SQLCA.sqlcode,0)
            CLOSE t726_cl
            ROLLBACK WORK 
            RETURN
         END IF
         IF g_rec_b>=l_ac THEN 
            LET p_cmd ='u'
            LET g_run_t.*=g_run[l_ac].*
            LET g_run06_t=g_run[l_ac].run06    #FUN-BB0085
            OPEN t726_bcl USING g_rum.rum01,g_run_t.run02
            IF STATUS THEN
               CALL cl_err("OPEN t726_bcl:",STATUS,1)
               LET l_lock_sw='Y'
            ELSE
               FETCH t726_bcl INTO g_run[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_run_t.run03,SQLCA.sqlcode,1)
                  LET l_lock_sw="Y"
               END IF
               SELECT ima02 INTO g_run[l_ac].run03_desc FROM ima_file
                WHERE ima01 = g_run[l_ac].run03
                  AND imaacti = 'Y'
               SELECT gfe02 INTO g_run[l_ac].run04_desc FROM gfe_file
                WHERE gfe01 = g_run[l_ac].run04
                  AND gfeacti = 'Y'
               SELECT gfe02 INTO g_run[l_ac].run06_desc FROM gfe_file
                WHERE gfe01 = g_run[l_ac].run06
                  AND gfeacti = 'Y'   
            END IF
         END IF
         
      BEFORE INSERT
         LET l_n=ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_run[l_ac].* TO NULL
         CALL cl_set_comp_entry("run03",TRUE)
         LET g_run[l_ac].run08 = 0      #FUN-A10008 ADD
         LET g_run[l_ac].run09 = 0      #FUN-A10008 ADD
         LET g_run[l_ac].run10 = 0      #FUN-A10008 ADD
         LET g_run_t.*=g_run[l_ac].*
         LET g_run06_t= NULL            #FUN-BB0085
         CALL cl_show_fld_cont()
         NEXT FIELD run02
                
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            CANCEL INSERT
         END IF
         INSERT INTO run_file(
                run00,run01,run02,run03,run04,run05,run06,run07,
                run08,run09,run10,run11,run12,run13,runplant,runlegal)
         VALUES(g_rum.rum00,g_rum.rum01,g_run[l_ac].run02,g_run[l_ac].run03,
                g_run[l_ac].run04,g_run[l_ac].run05,g_run[l_ac].run06,
                g_run[l_ac].run07,g_run[l_ac].run08,g_run[l_ac].run09,
                g_run[l_ac].run10,g_run[l_ac].run11,g_run[l_ac].run12,
                g_run[l_ac].run13,g_rum.rumplant,g_rum.rumlegal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","run_file",g_rum.rum01,g_run[l_ac].run02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K.'
            CALL t726_upd_log()
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
                
      BEFORE FIELD run02
        IF g_rum00='1' THEN 
           IF cl_null(g_run[l_ac].run02) OR g_run[l_ac].run02 = 0 THEN 
              SELECT MAX(run02)+1 INTO g_run[l_ac].run02 FROM run_file
               WHERE run01 = g_rum.rum01
                 AND run00 = g_rum00
              IF g_run[l_ac].run02 IS NULL THEN
                 LET g_run[l_ac].run02=1
              END IF
           END IF
        END IF 
         
      AFTER FIELD run02
        IF NOT cl_null(g_run[l_ac].run02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_run[l_ac].run02 <> g_run_t.run02) THEN
              SELECT COUNT(*) INTO l_n FROM run_file
               WHERE run00 = g_rum00
                 AND run01= g_rum.rum01 
                 AND run02=g_run[l_ac].run02
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_run[l_ac].run02=g_run_t.run02
                 NEXT FIELD run02
              END IF
              IF g_rum00='2' THEN
                 CALL t726_run02()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_run[l_ac].run02=g_run_t.run02
                    NEXT FIELD run02
                 END IF    
              END IF 
           END IF
         END IF

        AFTER FIELD run05
           IF NOT cl_null(g_run[l_ac].run05) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_run[l_ac].run05,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_run[l_ac].run05= g_run_t.run05
                 NEXT FIELD run05
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_run_t.run05 IS NULL OR 
                 (g_run[l_ac].run05 != g_run_t.run05 ) THEN
                 CALL t726_run03()      
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_run[l_ac].run05,g_errno,0)
                    LET g_run[l_ac].run05 = g_run_t.run05
                    LET g_run[l_ac].run03 = g_run_t.run03
                    DISPLAY BY NAME g_run[l_ac].run05,g_run[l_ac].run03
                    NEXT FIELD run05
                 ELSE
                    IF g_run[l_ac].run04 IS NOT NULL AND
                       g_run[l_ac].run06 IS NOT NULL THEN
                       LET l_flag = NULL
                       LET l_fac = NULL
                       CALL s_umfchk(g_run[l_ac].run03,g_run[l_ac].run06,
                                     g_run[l_ac].run04)
                          RETURNING l_flag,l_fac
                       IF l_flag = 1 THEN
                          LET l_msg = g_run[l_ac].run06 CLIPPED,'->',
                                      g_run[l_ac].run04 CLIPPED
                          CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                          LET g_run[l_ac].run03 = g_run_t.run03
                          LET g_run[l_ac].run05 = g_run_t.run05
                          LET g_run[l_ac].run03_desc = g_run_t.run03_desc
                          LET g_run[l_ac].run04 = g_run_t.run04
                          LET g_run[l_ac].run04_desc = g_run_t.run04_desc
                          DISPLAY BY NAME g_run[l_ac].run03,g_run[l_ac].run05,g_run[l_ac].run03_desc,
                                          g_run[l_ac].run04,g_run[l_ac].run04_desc
                          NEXT FIELD run05
                       ELSE
                          CALL t726_check_img10()
                          IF NOT cl_null(g_errno) THEN
                             CALL cl_err('',g_errno,0)
                             LET g_run[l_ac].run03 = g_run_t.run03
                             LET g_run[l_ac].run05 = g_run_t.run05
                             LET g_run[l_ac].run03_desc = g_run_t.run03_desc
                             LET g_run[l_ac].run04 = g_run_t.run04
                             LET g_run[l_ac].run04_desc = g_run_t.run04_desc
                             DISPLAY BY NAME g_run[l_ac].run03,g_run[l_ac].run05,g_run[l_ac].run03_desc,
                                             g_run[l_ac].run04,g_run[l_ac].run04_desc
                             NEXT FIELD run05
                          ELSE
                             LET g_run[l_ac].run07 = l_fac
                             DISPLAY BY NAME g_run[l_ac].run07
                          END IF
                       END IF
                    END IF
                 END IF
              END IF
           ELSE     
               CALL cl_set_comp_entry("run03",TRUE)
           END IF      
           
#FUN-A10008 ADD START-------------------------------------------
      BEFORE FIELD run03
         IF cl_null(g_run[l_ac].run05)  THEN
            CALL cl_set_comp_entry("run03",TRUE)
         ELSE
     	      CALL cl_set_comp_entry("run03",FALSE)
         END IF
          
      AFTER FIELD run03
         IF NOT cl_null(g_run[l_ac].run03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_run[l_ac].run03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_run[l_ac].run03= g_run_t.run03
               NEXT FIELD run03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_run_t.run03 IS NULL OR
               (g_run[l_ac].run03 != g_run_t.run03 ) THEN
               CALL t726_run03()      
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_run[l_ac].run03,g_errno,0)
                  LET g_run[l_ac].run03 = g_run_t.run03
                  LET g_run[l_ac].run03_desc = g_run_t.run03_desc
                  LET g_run[l_ac].run04 = g_run_t.run04
                  LET g_run[l_ac].run04_desc = g_run_t.run04_desc
                  DISPLAY BY NAME g_run[l_ac].run03,g_run[l_ac].run03_desc,
                                  g_run[l_ac].run04,g_run[l_ac].run04_desc
                  NEXT FIELD run03
               ELSE 
                  IF g_run[l_ac].run04 IS NOT NULL AND 
                     g_run[l_ac].run06 IS NOT NULL THEN 
                     LET l_flag = NULL
                     LET l_fac = NULL
                     CALL s_umfchk(g_run[l_ac].run03,g_run[l_ac].run06,
                                   g_run[l_ac].run04)
                        RETURNING l_flag,l_fac
                     IF l_flag = 1 THEN
                        LET l_msg = g_run[l_ac].run06 CLIPPED,'->',
                                    g_run[l_ac].run04 CLIPPED
                        CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                        LET g_run[l_ac].run03 = g_run_t.run03
                        LET g_run[l_ac].run03_desc = g_run_t.run03_desc
                        LET g_run[l_ac].run04 = g_run_t.run04
                        LET g_run[l_ac].run04_desc = g_run_t.run04_desc
                        DISPLAY BY NAME g_run[l_ac].run03,g_run[l_ac].run03_desc,
                                        g_run[l_ac].run04,g_run[l_ac].run04_desc
                        NEXT FIELD run03
                     ELSE
                        CALL t726_check_img10() 
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                           LET g_run[l_ac].run03 = g_run_t.run03
                           LET g_run[l_ac].run03_desc = g_run_t.run03_desc
                           LET g_run[l_ac].run04 = g_run_t.run04
                           LET g_run[l_ac].run04_desc = g_run_t.run04_desc
                           DISPLAY BY NAME g_run[l_ac].run03,g_run[l_ac].run03_desc,
                                           g_run[l_ac].run04,g_run[l_ac].run04_desc
                           NEXT FIELD run03
                        ELSE
                           LET g_run[l_ac].run07 = l_fac
                           DISPLAY BY NAME g_run[l_ac].run07
                        END IF    
                     END IF
                  END IF
               END IF
            END IF  
         ELSE
          	LET g_run[l_ac].run03_desc=NULL
            LET g_run[l_ac].run04=NULL
            LET g_run[l_ac].run04_desc=NULL
            DISPLAY '' TO g_run[l_ac].run04
            DISPLAY '' TO g_run[l_ac].run03_desc
            DISPLAY '' TO g_run[l_ac].run04_desc
         END IF          
             
        AFTER FIELD run06
           IF NOT cl_null(g_run[l_ac].run06) THEN
              CALL t726_run06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_run[l_ac].run06,g_errno,0)
                 LET g_run[l_ac].run06 = g_run_t.run06
                 DISPLAY BY NAME g_run[l_ac].run06
                 NEXT FIELD run06
              END IF
              IF g_run[l_ac].run03 IS NOT NULL AND 
                 g_run[l_ac].run04 IS NOT NULL THEN
                 LET l_flag = NULL
                 LET l_fac = NULL
                 CALL s_umfchk(g_run[l_ac].run03,g_run[l_ac].run06,
                               g_run[l_ac].run04)
                    RETURNING l_flag,l_fac
                 IF l_flag = 1 THEN
                    LET l_msg = g_run[l_ac].run06 CLIPPED,'->',
                                g_run[l_ac].run04 CLIPPED
                    CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                    LET g_run[l_ac].run06 = g_run_t.run06 
                    DISPLAY BY NAME g_run[l_ac].run06
                    NEXT FIELD run06
                 ELSE
                    LET g_run[l_ac].run07 = l_fac 
                 END IF
              END IF 
         #FUN-BB0085--add--str--
              IF NOT cl_null(g_run[l_ac].run10) AND g_run[l_ac].run10<>0 THEN  #TQC-C20183
                 IF NOT t726_run10_check() THEN
                    LET g_run06_t = g_run[l_ac].run06
                    NEXT FIELD run10
                 END IF
              END IF
              LET g_run06_t = g_run[l_ac].run06
         #FUN-BB0085--add--end--
           END IF   

        AFTER FIELD run10
           IF NOT t726_run10_check() THEN NEXT FIELD run10 END IF   #FUN-BB0085
           #FUN-BB0085-mark-str--
           #IF NOT cl_null(g_run[l_ac].run10) THEN
           #   IF g_run[l_ac].run10 <= 0 THEN
           #      CALL cl_err('','alm-808',0)
           #      LET g_run[l_ac].run10 = g_run_t.run10
           #      DISPLAY g_run[l_ac].run10
           #      NEXT FIELD run10
           #   ELSE
           #      IF g_rum00 = '2' THEN
           #         IF g_run[l_ac].run10 > (g_run[l_ac].run08-g_run[l_ac].run09) THEN
           #            CALL cl_err('','art-620',0)
           #            LET g_run[l_ac].run10 = g_run_t.run10
           #            DISPLAY g_run[l_ac].run10
           #            NEXT FIELD run10 
           #         ELSE
           #            CALL t726_check_img10() 
           #            IF NOT cl_null(g_errno) THEN
           #               CALL cl_err('',g_errno,0)
           #               LET g_run[l_ac].run10 = g_run_t.run10 
           #               DISPLAY BY NAME g_run[l_ac].run10                
           #               NEXT FIELD run10
           #            END IF     
           #         END IF
           #      END IF 
           #   END IF
           #END IF
           #FUN-BB0085-mark--end--
                      
        AFTER FIELD run11 
           IF NOT cl_null(g_run[l_ac].run11) THEN
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(g_run[l_ac].run11) THEN
                 NEXT FIELD run11
              END IF 
              #No.FUN-AA0049--end           
              IF NOT s_stkchk(g_run[l_ac].run11,'A') THEN
                 CALL cl_err(g_run[l_ac].run11,'mfg6076',0)
                 LET g_run[l_ac].run11 = g_run_t.run11
                 DISPLAY BY NAME g_run[l_ac].run11
                 NEXT FIELD run11
              ELSE
                 CALL s_swyn(g_run[l_ac].run11) RETURNING sn1,sn2
                 IF sn1 != 0 THEN
                    CALL cl_err(g_run[l_ac].run11,'mfg6080',0)
                    LET g_run[l_ac].run11 = g_run_t.run11
                    DISPLAY BY NAME g_run[l_ac].run11
                    NEXT FIELD run11
                 ELSE 
                    CALL t726_chk_jce02('2',g_run[l_ac].run11)
                    IF NOT cl_null(g_errno) THEN 
                       CALL cl_err('',g_errno,1) 
                       LET g_run[l_ac].run11 = g_run_t.run11
                       NEXT FIELD run11 
                    END IF 
                    IF g_rum00='2' THEN
                       CALL t726_check_img10() 
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_run[l_ac].run11 = g_run_t.run11
                          DISPLAY BY NAME g_run[l_ac].run11
                          NEXT FIELD run11
                       END IF
                    END IF
                 END IF
              END IF
           END IF   
 
        AFTER FIELD run12 
           IF NOT cl_null(g_run[l_ac].run12) THEN  
              IF g_run_t.run12 IS NULL OR 
                 (g_run[l_ac].run12 != g_run_t.run12 ) THEN
                 CALL t726_check_img10() 
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_run[l_ac].run12 = g_run_t.run12
                  DISPLAY BY NAME g_run[l_ac].run12
                  NEXT FIELD run12
                 END IF    
              END IF
           END IF   
 
        AFTER FIELD run13 
           IF NOT cl_null(g_run[l_ac].run13) THEN  
           	  IF g_run_t.run13 IS NULL OR 
                 (g_run[l_ac].run13 != g_run_t.run13 ) THEN
                 CALL t726_check_img10() 
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_run[l_ac].run13 = g_run_t.run13
                  DISPLAY BY NAME g_run[l_ac].run13
                  NEXT FIELD run13
                 END IF    
              END IF
           END IF              
#FUN-A10008 ADD END------------------------------------------------------
        
    # AFTER FIELD run08
    #   IF NOT cl_null(g_run[l_ac].run08) THEN
    #      IF p_cmd = 'a' OR (p_cmd = 'u' AND
    #            g_run[l_ac].run08 <> g_run_t.run08) THEN
    #         IF g_run[l_ac].run08>g_run[l_ac].run07 THEN
    #            IF g_rum00='1' THEN
    #               CALL cl_err('','art-604',0)
    #            ELSE
    #               CALL cl_err('','art-605',0)
    #            END IF
    #            LET g_run[l_ac].run08=g_run_t.run08
    #            DISPLAY BY NAME g_run[l_ac].run08
    #            NEXT FIELD run08
    #         END IF
    #      END IF
    #   END IF 
      BEFORE DELETE                      
           IF g_run_t.run02 > 0 AND NOT cl_null(g_run_t.run02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM run_file
               WHERE run01 = g_rum.rum01
                 AND run02 = g_run_t.run02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","run_file",g_rum.rum01,g_run_t.run02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 CALL t726_upd_log()
                 COMMIT WORK
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_run[l_ac].* = g_run_t.*
              CLOSE t726_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF NOT cl_null(g_run[l_ac].run11) THEN        #TQC-A20021 ADD 
              CALL t726_chk_jce02('2',g_run[l_ac].run11)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,1) 
                 LET g_run[l_ac].run11 = g_run_t.run11
                 NEXT FIELD run11 
              END IF 
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_run[l_ac].run02,-263,1)
              LET g_run[l_ac].* = g_run_t.*
           ELSE
             #TQC-A20039 ADD-----------------------------
              IF cl_null(g_run[l_ac].run12) THEN
                 LET g_run[l_ac].run12= ' '
              END IF
              IF cl_null(g_run[l_ac].run13) THEN
                 LET g_run[l_ac].run13= ' '
              END IF
             #TQC-A20039---------------------------------
              UPDATE run_file SET run02=g_run[l_ac].run02,
                                  run03=g_run[l_ac].run03,
                                  run04=g_run[l_ac].run04,
                                  run05=g_run[l_ac].run05,
                                  run06=g_run[l_ac].run06,
                                  run07=g_run[l_ac].run07,
                                  run08=g_run[l_ac].run08,
                                  run09=g_run[l_ac].run09,
                                  run10=g_run[l_ac].run10,
                                  run11=g_run[l_ac].run11,
                                  run12=g_run[l_ac].run12,
                                  run13=g_run[l_ac].run13
               WHERE run00=g_rum00
                 AND run01=g_rum.rum01
                 AND run02=g_run_t.run02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","run_file",g_rum.rum01,g_run_t.run02,SQLCA.sqlcode,"","",1) 
                 LET g_run[l_ac].* = g_run_t.*
              ELSE
                 CALL t726_upd_log()
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
                 LET g_run[l_ac].* = g_run_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_run.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t726_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t726_bcl
           COMMIT WORK
                     
       ON ACTION CONTROLO                        
           IF INFIELD(run02) AND l_ac > 1 THEN
              LET g_run[l_ac].* = g_run[l_ac-1].*
              LET g_run[l_ac].run02 = g_rec_b + 1
              NEXT FIELD run02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(run02)     
               IF g_rum00='2' THEN                
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_run1"                     
                  LET g_qryparam.arg1 = g_rum.rum02                  
                  LET g_qryparam.default1 = g_run[l_ac].run02
                  CALL cl_create_qry() RETURNING g_run[l_ac].run02,g_run[l_ac].run03
                  DISPLAY BY NAME g_run[l_ac].run02,g_run[l_ac].run03
                  CALL t726_run03()
               END IF
            WHEN INFIELD(run03)
#FUN-AA0059---------mod------------str-----------------                                 
#               CALL cl_init_qry_var()
#               #No.FUN-A10047--begin
#               SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_rum.rumplant
#               IF cl_null(l_rtz04) THEN
#                  LET g_qryparam.form = "q_ima"
#               ELSE
#                  LET g_qryparam.form ="q_rte03_1"       
#                  LET g_qryparam.arg1 = l_rtz04
#               END IF               
#               #No.FUN-A10047--end                 
#               LET g_qryparam.default1 = g_run[l_ac].run03
#               CALL cl_create_qry() RETURNING g_run[l_ac].run03
               CALL q_sel_ima(FALSE, "q_ima","",g_run[l_ac].run03,"","","","","",'' ) 
                   RETURNING  g_run[l_ac].run03

#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_run[l_ac].run03
               CALL t726_run03()
               NEXT FIELD run03
           WHEN INFIELD(run05)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rta1"  
               LET g_qryparam.default1 = g_run[l_ac].run05
               CALL cl_create_qry() RETURNING g_run[l_ac].run05
               DISPLAY BY NAME g_run[l_ac].run05 
               NEXT FIELD run05
           WHEN INFIELD(run06)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_smd1"
               LET g_qryparam.arg1 = g_run[l_ac].run03
               LET g_qryparam.arg2 = g_run[l_ac].run04
#               LET g_qryparam.form ="q_gfe"  
               LET g_qryparam.default1 = g_run[l_ac].run06
               CALL cl_create_qry() RETURNING g_run[l_ac].run06
               DISPLAY BY NAME g_run[l_ac].run06 
               NEXT FIELD run06                  
           WHEN INFIELD(run11) OR INFIELD(run12) OR INFIELD(run13) 
              #FUN-C30300---begin
              LET l_ima906 = NULL
              SELECT ima906 INTO l_ima906 FROM ima_file
               WHERE ima01 = g_run[l_ac].run03
              #IF s_industry("icd") AND l_ima906='3' THEN  #TQC-C60028
              IF s_industry("icd") THEN  #TQC-C60028
                 CALL q_idc(FALSE,TRUE,g_run[l_ac].run03,g_run[l_ac].run11,     
                                 g_run[l_ac].run12,g_run[l_ac].run13)
                    RETURNING    g_run[l_ac].run11,
                                 g_run[l_ac].run12,g_run[l_ac].run13
              ELSE
              #FUN-C30300---end
                 CALL q_img4(FALSE,TRUE,g_run[l_ac].run03,g_run[l_ac].run11,     
                                 g_run[l_ac].run12,g_run[l_ac].run13,'A')
                    RETURNING    g_run[l_ac].run11,
                                 g_run[l_ac].run12,g_run[l_ac].run13
              END IF  #FUN-C30300
               DISPLAY BY NAME g_run[l_ac].run11 
               DISPLAY BY NAME g_run[l_ac].run12  
               DISPLAY BY NAME g_run[l_ac].run13 
               IF cl_null(g_run[l_ac].run12) THEN LET g_run[l_ac].run12 = ' ' END IF
               IF cl_null(g_run[l_ac].run13) THEN LET g_run[l_ac].run13 = ' ' END IF
               IF INFIELD(run11) THEN NEXT FIELD run11 END IF
               IF INFIELD(run12) THEN NEXT FIELD run12 END IF
               IF INFIELD(run13) THEN NEXT FIELD run13 END IF
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
  
    CLOSE t726_bcl
    COMMIT WORK
#   CALL t726_delall() #CHI-C30002 mark
    CALL t726_delHeader()     #CHI-C30002 add
    CALL t726_show()
END FUNCTION                
 
FUNCTION t726_upd_log()
    LET g_rum.rummodu = g_user
    LET g_rum.rumdate = g_today
    UPDATE rum_file SET rummodu = g_rum.rummodu,rumdate = g_rum.rumdate
     WHERE rum01 = g_rum.rum01
       AND rum00 = g_rum00
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","rum_file",g_rum.rummodu,g_rum.rumdate,SQLCA.sqlcode,"","",1)
    END IF
    DISPLAY BY NAME g_rum.rummodu,g_rum.rumdate
    MESSAGE 'UPDATE O.K.'
END FUNCTION

FUNCTION t726_run02()
DEFINE  l_n         LIKE type_file.num5
DEFINE  l_run10     LIKE run_file.run10
    LET g_errno=''
    SELECT COUNT(*) INTO l_n FROM run_file 
     WHERE run00='1'
       AND run01=g_rum.rum02
       AND run02=g_run[l_ac].run02
       AND runplant=g_rum.rumplant
    IF l_n=0 THEN 
       LET g_errno='art-628'
       RETURN 
    END IF 
    SELECT run05,run03,run04,run06,run07,run08,run09,run11,run12,run13,run10
      INTO g_run[l_ac].run05,g_run[l_ac].run03,g_run[l_ac].run04,g_run[l_ac].run06,
           g_run[l_ac].run07,g_run[l_ac].run08,g_run[l_ac].run09,g_run[l_ac].run11,
           g_run[l_ac].run12,g_run[l_ac].run13,l_run10
      FROM run_file
     WHERE run00='1'
       AND run01=g_rum.rum02
       AND run02=g_run[l_ac].run02
       AND runplant=g_rum.rumplant
    IF g_run[l_ac].run08=0 THEN LET g_run[l_ac].run08=l_run10 END IF 
    LET g_run[l_ac].run10=g_run[l_ac].run08-g_run[l_ac].run09
    SELECT ima02 INTO g_run[l_ac].run03_desc
      FROM ima_file WHERE ima01 = g_run[l_ac].run03
    SELECT gfe02 INTO g_run[l_ac].run04_desc
      FROM gfe_file WHERE gfe01 = g_run[l_ac].run04
    SELECT gfe02 INTO g_run[l_ac].run06_desc
       FROM gfe_file
     WHERE gfe01 = g_run[l_ac].run06       
    DISPLAY BY NAME g_run[l_ac].run05,g_run[l_ac].run03,g_run[l_ac].run04,g_run[l_ac].run06,
                    g_run[l_ac].run07,g_run[l_ac].run08,g_run[l_ac].run09,g_run[l_ac].run10,
                    g_run[l_ac].run11,g_run[l_ac].run12,g_run[l_ac].run13,g_run[l_ac].run03_desc,
                    g_run[l_ac].run04_desc,g_run[l_ac].run06_desc 
    
END FUNCTION  

#CHI-C30002 -------- add -------- begin
FUNCTION t726_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
  SELECT COUNT(*) INTO g_cnt FROM run_file
   WHERE run01 = g_rum.rum01
     AND run00 = g_rum00
   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rum.rum01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rum_file ",
                  "  WHERE rum01 LIKE '",l_slip,"%' ",
                  "    AND rum01 > '",g_rum.rum01,"'"
      PREPARE t726_pb2 FROM l_sql 
      EXECUTE t726_pb2 INTO l_cnt
      
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
         CALL t726_v()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rum_file
          WHERE rum01 = g_rum.rum01 AND rum00 = g_rum00
            AND rumplant=g_rum.rumplant
         INITIALIZE g_rum.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t726_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM run_file
#   WHERE run01 = g_rum.rum01
#     AND run00 = g_rum00
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rum_file 
#      WHERE rum01 = g_rum.rum01 AND rum00 = g_rum00
#        AND rumplant=g_rum.rumplant
#     CLEAR FORM
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t726_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rum.rum01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rum.* FROM rum_file
    WHERE rum01=g_rum.rum01
      AND rum00=g_rum00
      AND rumplant=g_rum.rumplant
   IF g_rum.rumacti ='N' THEN    
      CALL cl_err(g_rum.rum01,'abm-033',0)
      RETURN
   END IF
   IF g_rum.rumconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t726_cl USING g_rum.rum01,g_plant
   IF STATUS THEN
      CALL cl_err("OPEN t726_cl:", STATUS, 1)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t726_cl INTO g_rum.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rum.rum01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t726_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rum00"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "rum01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rum00          #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_rum.rum01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM rum_file WHERE rum01 = g_rum.rum01 AND rum00 = g_rum00 
         AND rumplant=g_rum.rumplant
      DELETE FROM run_file WHERE run01 = g_rum.rum01 AND run00 = g_rum00
         AND runplant=g_rum.rumplant
      CLEAR FORM
      CALL g_run.clear()
      OPEN t726_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t726_cs
          CLOSE t726_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      FETCH t726_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t726_cs
          CLOSE t726_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t726_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t726_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t726_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t726_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t726_copy()
DEFINE l_newno     LIKE rum_file.rum01,
       l_oldno     LIKE rum_file.rum01,
       l_cnt       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rum.rum01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t726_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   CALL cl_set_docno_format("rum01")   #TQC-A30058 ADD
   INPUT l_newno FROM rum01
      AFTER FIELD rum01
         IF l_newno IS NOT NULL THEN                                          
            IF g_rum00 = '1' THEN
#              CALL s_check_no("art",l_newno,"","7","rum_file","rum00,rum01,rumplant","") #FUN-A70130 mark
               CALL s_check_no("art",l_newno,"","I5","rum_file","rum00,rum01,rumplant","") #FUN-A70130 mod
                  RETURNING li_result,l_newno                                    
            ELSE
#              CALL s_check_no("art",l_newno,"","8","rum_file","rum00,rum01,rumplant","") #FUN-A70130 mark
               CALL s_check_no("art",l_newno,"","I6","rum_file","rum00,rum01,rumplant","") #FUN-A70130 mod
                  RETURNING li_result,l_newno
            END IF
            IF (NOT li_result) THEN                                                 
                NEXT FIELD rum01                                              
            END IF                                                                                                                        
         END IF                 
        
       ON ACTION controlp
          CASE
             WHEN INFIELD(rum01)                        
                LET g_t1=s_get_doc_no(l_newno)
                LET g_qryparam.state = 'i' 
                LET g_qryparam.plant = g_plant
              IF g_rum00 = '1' THEN
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','7') RETURNING g_t1   #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'I5','ART') RETURNING g_t1  #FUN-A70130--mod--
              ELSE
#                CALL q_smy(FALSE,FALSE,g_t1,'art','8') RETURNING g_t1   #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'I6','ART') RETURNING g_t1  #FUN-A70130--mod--
              END IF
                LET l_newno=g_t1
                DISPLAY l_newno TO rum01            
                NEXT FIELD rum01
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
      DISPLAY BY NAME g_rum.rum01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rum_file         
    WHERE rum01=g_rum.rum01
      AND rumplant=g_rum.rumplant
      AND rum00=g_rum00
     INTO TEMP y
   IF g_rum00='1' THEN #FUN-A10008 ADD 
#     CALL s_auto_assign_no("art",l_newno,g_today,"7","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_newno,g_today,"I5","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mod
      RETURNING li_result,l_newno
   ELSE 
#     CALL s_auto_assign_no("art",l_newno,g_today,"8","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_newno,g_today,"I6","rum_file","rum00,rum01,rumplant","","","") #FUN-A70130 mod
      RETURNING li_result,l_newno
   END IF
   IF (NOT li_result) THEN
       RETURN
   END IF
   UPDATE y
       SET rum00=g_rum00,
           rum01=l_newno,    
           rumuser=g_user,   
           rumgrup=g_grup,   
           rummodu=NULL,     
           rumdate=g_today,  
           rumacti='Y',
           rumplant=g_plant,
           rumlegal=g_legal,
           rumcrat =g_today,
           rumorig =g_grup,
           rumoriu =g_user,
           rumconu =NULL,
           rumconf ='N',
           rumcond =NULL    
 
   INSERT INTO rum_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rum_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM run_file         
       WHERE run01=g_rum.rum01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET run01=l_newno
 
   INSERT INTO run_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK           # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","run_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK            # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rum.rum01
   SELECT rum_file.* INTO g_rum.* FROM rum_file WHERE rum01 = l_newno
     AND rum00=g_rum00  AND rumplant=g_rum.rumplant
   CALL t726_u()
   CALL t726_m_b()
   #SELECT rum_file.* INTO g_rum.* FROM rum_file WHERE rum01 = l_oldno  #FUN-C80046
   #  AND rum00=g_rum00  AND rumplant=g_rum.rumplant                    #FUN-C80046
   #CALL t726_show()   #FUN-C80046
 
END FUNCTION
 
FUNCTION t726_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rum.rum01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t726_cl USING g_rum.rum01,g_plant
   IF STATUS THEN
      CALL cl_err("OPEN t726_cl:", STATUS, 1)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t726_cl INTO g_rum.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rum.rum01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   IF g_rum.rumconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   LET g_success = 'Y'
 
   CALL t726_show()
 
   IF cl_exp(0,0,g_rum.rumacti) THEN                   
      LET g_chr=g_rum.rumacti
      IF g_rum.rumacti='Y' THEN
         LET g_rum.rumacti='N'
      ELSE
         LET g_rum.rumacti='Y'
      END IF
      UPDATE rum_file SET rumacti=g_rum.rumacti,
                          rummodu=g_user,
                          rumdate=g_today
       WHERE rum01=g_rum.rum01
         AND rum00=g_rum00
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rum_file",g_rum.rum01,"",SQLCA.sqlcode,"","",1)  
         LET g_rum.rumacti=g_chr
      END IF
   END IF
 
   CLOSE t726_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rumacti,rummodu,rumdate
     INTO g_rum.rumacti,g_rum.rummodu,g_rum.rumdate FROM rum_file
    WHERE rum01=g_rum.rum01
      AND rum00=g_rum00
      AND rumplant=g_rum.rumplant
   DISPLAY BY NAME g_rum.rumacti,g_rum.rummodu,g_rum.rumdate

  #TQC-A30002 ADD-----------------------------
   IF g_rum.rumacti='Y' THEN
      CALL cl_set_field_pic("","","","","","Y")
   ELSE
      CALL cl_set_field_pic("","","","","","N")
   END IF
  #TQC-A30002 END----------------------------- 
END FUNCTION
 
FUNCTION t726_bp_refresh()
 
  DISPLAY ARRAY g_run TO s_run.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION t726_y()
DEFINE   l_run09   LIKE run_file.run09
DEFINE   i         LIKE type_file.num5
DEFINE   l_gen02   LIKE gen_file.gen02 
DEFINE   l_run11   LIKE run_file.run11 #No.FUN-AB0067   
DEFINE   l_run       RECORD LIKE run_file.*   #FUN-C70087
DEFINE   l_cnt_img   LIKE type_file.num5      #FUN-C70087
 
    IF cl_null(g_rum.rum01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
#CHI-C30107 ----------------- add ---------------- begin 
   IF g_rum.rumacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   IF g_rum.rumconf = 'Y' THEN
      CALL cl_err(g_rum.rum01,'alm-005',1)
      RETURN
   END IF
   IF g_rum.rumconf = 'X' THEN
      CALL cl_err(g_rum.rum01,'alm-134',1)
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN
      RETURN
   END IF
   SELECT * INTO g_rum.* FROM rum_file WHERE rum00 = g_rum00
                                         AND rum01 = g_rum.rum01
                                         AND rumplant = g_rum.rumplant
#CHI-C30107 ----------------- add ---------------- end
   IF g_rum.rumacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   IF g_rum.rumconf = 'Y' THEN
      CALL cl_err(g_rum.rum01,'alm-005',1)
      RETURN
   END IF
   IF g_rum.rumconf = 'X' THEN
      CALL cl_err(g_rum.rum01,'alm-134',1)
      RETURN
   END IF
#No.FUN-AB0067--begin    
   LET g_success='Y' 
   CALL s_showmsg_init()   
   DECLARE t726_chk_ware CURSOR FOR SELECT run11 FROM run_file
                                   WHERE run01=g_rum.rum01 AND run00=g_rum00
   FOREACH t726_chk_ware INTO l_run11           
      IF NOT s_chk_ware(l_run11) THEN
         LET g_success='N' 
      END IF 
   END FOREACH 
   CALL s_showmsg()
   IF g_success='N' THEN 
      RETURN 
   END IF    
#No.FUN-AB0067--end    
   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   
   DECLARE t726_s1_c1 CURSOR FOR SELECT * FROM run_file 
                                  WHERE run00=g_rum00
                                    AND run01=g_rum.rum01
                                    AND runplant = g_rum.rumplant

   FOREACH t726_s1_c1 INTO l_run.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = l_run.run03
         AND img02 = l_run.run11
         AND img03 = l_run.run12
         AND img04 = l_run.run13
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(l_run.run03,l_run.run11,l_run.run12,l_run.run13,g_rum.rum01,l_run.run02,g_rum.rum04,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_run.run03,l_run.run11,l_run.run12,l_run.run13,g_rum.rum01,l_run.run02,g_rum.rum04) #FUN-CC0095
       END IF
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #FUN-CC0095---end
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND l_cnt_img > 0 THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
      ELSE
         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #FUN-C70087---end
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t726_cl USING g_rum.rum01,g_plant
   IF STATUS THEN
      CALL cl_err("OPEN t60_cl:", STATUS, 1)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t726_cl INTO g_rum.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_rum_t.* = g_rum.*
#   IF cl_upsw(0,0,g_rum.rumconf) THEN 
#CHI-C30107 --------- mark ------------- begin
#  IF NOT cl_confirm("alm-006") THEN
#     RETURN 
#  ELSE 
#CHI-C30107 --------- mark ------------- end
      IF g_rum00='2' THEN 
         FOR i=1 TO g_rec_b
            SELECT run09 INTO l_run09 FROM run_file 
             WHERE run01=g_rum.rum02
               AND run00='1' 
               AND run02=g_run[i].run02
           #IF l_run09+g_run[i].run10>l_run08 THEN         #TQC-A30058 MARK
            IF l_run09+g_run[i].run10>g_run[i].run08 THEN  #ADD
               CALL cl_err('','art-646',1)                #No.TQC-A20022
               RETURN 
            END IF 
         END FOR 
      END IF 

      UPDATE rum_file SET rumconf ='Y',
                          rumconu = g_user,
                          rumcond = g_today,
                          rummodu = g_user,
                          rumdate = g_today
       WHERE rum01 = g_rum.rum01
         AND rum00 = g_rum00
         AND rumplant=g_rum.rumplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","rum_file",g_rum.rum01,"",STATUS,"","",1)
         LET g_success = 'N'
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rum_file",g_rum.rum01,"","9050","","",1)
            LET g_success = 'N'
         END IF
      END IF 
      CALL t726_ins_img('Y')

      IF g_rum00 = '2' THEN
         FOR i=1 TO g_rec_b
            UPDATE run_file SET run09=run09+g_run[i].run10    
             WHERE run00='1'
               AND run01=g_rum.rum02                    
               AND run02=g_run[i].run02                   
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rum_file",g_rum.rum02,"",STATUS,"","",1)
               LET g_success = 'N'
               ROLLBACK WORK
               RETURN
            END IF 

            UPDATE run_file SET run09=run09+g_run[i].run10    
             WHERE run00='2'
               AND run01 IN (SELECT rum01 FROM rum_file
                              WHERE rum02 = g_rum.rum02 AND rum00='2')           #=g_rum.rum01                    
               AND run02=g_run[i].run02  
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rum_file",g_rum.rum01,"",STATUS,"","",1)
               LET g_success = 'N'
              ROLLBACK WORK
              RETURN
            END IF    
         END FOR
      END IF
#  END IF  #CHI-C30107 mark
   IF g_success = 'Y' THEN
      LET g_rum.rumconf='Y'
      LET g_rum.rumconu = g_user
      LET g_rum.rumcond = g_today
      LET g_rum.rummodu = g_user
      LET g_rum.rumdate = g_today
      COMMIT WORK
     #TQC-A20021 ADD---------------
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01=g_rum.rumconu 
         AND genacti='Y'
      IF cl_null(l_gen02) THEN LET l_gen02=' ' END IF
      DISPLAY l_gen02 TO rumconu_desc
      DISPLAY BY NAME g_rum.rumconf,g_rum.rumconu,g_rum.rumcond,
                      g_rum.rumuser,g_rum.rumdate
      IF g_rum.rumconf='Y' THEN
         CALL cl_set_field_pic("Y","","","","","")
      END IF
      CALL t726_b_fill(g_wc2)
      CALL t726_bp_refresh()
   ELSE
      ROLLBACK WORK
   END IF 
   
END FUNCTION

FUNCTION t726_ins_img(p_kind)
DEFINE   p_img01     LIKE img_file.img01
DEFINE   p_img02     LIKE img_file.img02
DEFINE   p_img03     LIKE img_file.img03
DEFINE   p_img04     LIKE img_file.img04
DEFINE   l_run       RECORD LIKE run_file.* 
DEFINE   l_sql       STRING
DEFINE   p_kind      LIKE type_file.chr1
DEFINE   i           LIKE type_file.num5 

#Y OR U Y表示審核 U表示取消審核
       
      IF g_rum00='1' AND p_kind='Y' THEN  
         FOR i=1 TO g_rec_b 
            IF cl_null(g_run[i].run03) THEN 
               LET g_run[i].run03 =' '
            END IF 
            IF cl_null(g_run[i].run11) THEN 
               LET g_run[i].run11 =' '
            END IF  
            IF cl_null(g_run[i].run12) THEN 
               LET g_run[i].run12 =' '
            END IF  
            IF cl_null(g_run[i].run13) THEN 
               LET g_run[i].run13 =' '
            END IF 
            SELECT * FROM img_file
            WHERE img01=g_run[i].run03
              AND img02=g_run[i].run11
              AND img03=g_run[i].run12
              AND img04=g_run[i].run13
            IF STATUS=100 THEN
               CALL s_add_img(g_run[i].run03,g_run[i].run11,g_run[i].run12,g_run[i].run13,
                              g_rum.rum01,g_run[l_ac].run02,g_today)
               IF g_errno='N' THEN 
                  LET g_success='N'
                  EXIT FOR  
               END IF 
            END IF 
         END FOR 
         IF g_success='N' THEN 
            RETURN 
         END IF 
      END IF
          
#          	INITIALIZE l_run.* TO NULL 
#          	LET l_sql = "SELECT * FROM run_file ",
#                        " WHERE run01 = '",g_rum.rum01,"'",
#                        "   AND run00 = '",g_rum00,"'"
#            PREPARE t726_p11 FROM l_sql
#            DECLARE t726_c11 CURSOR FOR t726_p11
#            FOREACH t726_c11 INTO l_run.*
#                CALL s_upimg(l_run.run03,l_run.run11,l_run.run12,l_run.run13,1,l_run.run10,g_today,   
#                    '','','','',g_rum.rum01,l_run.run02,'','','','','','','','','','','','')   
#                IF g_success = 'N' THEN 
#                   EXIT FOREACH  
#                END IF      
#            END FOREACH     	
#            IF g_success='N' THEN 
#               RETURN 
#            END IF 
#         END IF
#      END IF  
      
      IF g_rum00='2' AND p_kind='U' OR (g_rum00='1' AND p_kind='Y') THEN
         INITIALIZE l_run.* TO NULL 
         LET l_sql = "SELECT * FROM run_file ",
                     " WHERE run01 = '",g_rum.rum01,"'",
                     "   AND run00 = '",g_rum00,"'"
         PREPARE t726_p12 FROM l_sql
         DECLARE t726_c12 CURSOR FOR t726_p12
         FOREACH t726_c12 INTO l_run.*
             CALL s_upimg(l_run.run03,l_run.run11,l_run.run12,l_run.run13,1,l_run.run10,g_today,   
                 '','','','',g_rum.rum01,l_run.run02,'','','','','','','','','','','','')   
             IF g_success = 'N' THEN 
                EXIT FOREACH   
             ELSE 
              	CALL t726_upd_tlff(l_run.run01,l_run.run02,l_run.runplant,'1')
              	IF g_success = 'N' THEN
              	   EXIT FOREACH 
              	END IF 
             END IF      
         END FOREACH     	
         IF g_success='N' THEN 
            RETURN 
         END IF 
      END IF 
      
      IF (g_rum00='2' AND p_kind='Y') OR (g_rum00='1' AND p_kind='U')THEN
         INITIALIZE l_run.* TO NULL 
         LET l_sql = "SELECT * FROM run_file ",
                     " WHERE run01 = '",g_rum.rum01,"'",
                     "   AND run00 = '",g_rum00,"'"
         PREPARE t726_p13 FROM l_sql
         DECLARE t726_c13 CURSOR FOR t726_p13
         FOREACH t726_c13 INTO l_run.*
             CALL s_upimg(l_run.run03,l_run.run11,l_run.run12,l_run.run13,-1,l_run.run10,g_today,   
                 '','','','',g_rum.rum01,l_run.run02,'','','','','','','','','','','','')   
             IF g_success = 'N' THEN 
                EXIT FOREACH  
             ELSE 
              	CALL t726_upd_tlff(l_run.run01,l_run.run02,l_run.runplant,'2')
              	IF g_success = 'N' THEN
              	   EXIT FOREACH 
              	END IF 
             END IF      
         END FOREACH     	
         IF g_success='N' THEN 
            RETURN 
         END IF 
      END IF  
      
END FUNCTION 

FUNCTION t726_upd_tlff(p_run01,p_run02,p_runplant,p_kind)
DEFINE p_run01     LIKE run_file.run01
DEFINE p_run02     LIKE run_file.run02
DEFINE p_runplant  LIKE run_file.runplant
DEFINE p_kind      LIKE type_file.num5
DEFINE l_run       RECORD LIKE run_file.*
DEFINE l_img09     LIKE img_file.img09,       #庫存單位                                                                           
       l_img10     LIKE img_file.img10,       #庫存數量                                                                           
       l_img26     LIKE img_file.img26 
    
    INITIALIZE g_tlf.* TO NULL   
    INITIALIZE l_run.* TO NULL
    LET l_run.run00=g_rum00
    LET l_run.run01=p_run01
    LET l_run.run02=p_run02
    LET l_run.runplant=p_runplant
    SELECT * INTO l_run.* FROM run_file 
     WHERE run00=l_run.run00 
       AND run01=l_run.run01
       AND run02=l_run.run02
       AND runplant=l_run.runplant
    IF cl_null(l_run.run03) THEN 
       LET l_run.run03 =' '
    END IF 
    IF cl_null(l_run.run11) THEN 
       LET l_run.run11 =' '
    END IF  
    IF cl_null(l_run.run12) THEN 
       LET l_run.run12 =' '
    END IF  
    IF cl_null(l_run.run13) THEN 
       LET l_run.run13 =' '
    END IF     
    SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
        FROM img_file WHERE img01 = l_run.run03 AND img02 = l_run.run11
                        AND img03 =l_run.run12 AND img04 = l_run.run13
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","img_file",l_run.run03,"",SQLCA.sqlcode,"","ckp#log",1)
       LET g_success = 'N'
       RETURN
    END IF
    IF p_kind='1' THEN
       LET g_tlf.tlf02=20
       LET g_tlf.tlf03=50
       LET g_tlf.tlf020 = l_run.runplant       #機構別
       LET g_tlf.tlf021 = ' '                  #倉庫別
       LET g_tlf.tlf022 = ' '                  #儲位別
       LET g_tlf.tlf023 = ' '                  #批號
       LET g_tlf.tlf024 = ' '                  #異動後庫存數量
       LET g_tlf.tlf025 = ' '                  #庫存單位(ima_file or img_file)
       LET g_tlf.tlf026 = l_run.run01          #參考號碼
       LET g_tlf.tlf030 = l_run.runplant 
       LET g_tlf.tlf031 = l_run.run11          #倉庫(目的)
       LET g_tlf.tlf032 = l_run.run12          #儲位(目的)
       LET g_tlf.tlf033 = l_run.run13          #批號(目的)
       LET g_tlf.tlf034 = l_run.run10          #異動後存數量
       LET g_tlf.tlf035 = l_run.run04          #庫存單位
       LET g_tlf.tlf036 = l_run.run01          #參考號碼
       LET g_tlf.tlf037 = l_run.run02          #單據項次
       LET g_tlf.tlf907 = 1
    ELSE
       LET g_tlf.tlf02=50 
       LET g_tlf.tlf03=20
       LET g_tlf.tlf907 = -1
       LET g_tlf.tlf020 = l_run.runplant       #機構別                                  
       LET g_tlf.tlf021 = l_run.run11          #倉庫別
       LET g_tlf.tlf022 = l_run.run12          #儲位別
       LET g_tlf.tlf023 = l_run.run13          #批號
       LET g_tlf.tlf024 = l_run.run10          #異動後庫存數量
       LET g_tlf.tlf025 = l_run.run04          #庫存單位(ima_file or img_file)
       LET g_tlf.tlf026 = l_run.run01          #參考號碼
       LET g_tlf.tlf027 = l_run.run02          #單據項次  
       LET g_tlf.tlf031 = ' '                  #倉庫(目的)
       LET g_tlf.tlf032 = ' '                  #儲位(目的)
       LET g_tlf.tlf033 = ' '                  #批號(目的) 
       LET g_tlf.tlf034 = ' '                  #異動後存數量
       LET g_tlf.tlf035 = ' '                  #庫存單位   	 
    END IF                                     
    LET g_tlf.tlf01 = l_run.run03              #異動料件編號
    LET g_tlf.tlf04 = ' '                      #工作站   
    LET g_tlf.tlf05 = ' ' 
    IF g_rum00='1' THEN                                                                                  
       LET g_tlf.tlf13 = 'artt726'     
    ELSE 
     	 LET g_tlf.tlf13 = 'artt727'    
    END IF 
    LET g_tlf.tlf06 = g_today            #日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=l_run.run10          #收料數量
    LET g_tlf.tlf11=l_run.run06          #收料單位 
    LET g_tlf.tlf12=l_run.run07          #收料/庫存轉換率
    LET g_tlf.tlf15=l_img26              #倉儲會計科目
    LET g_tlf.tlf60=l_run.run07          #異動單據單位對庫存單位之換算率
    LET g_tlf.tlf930 = l_run.runplant
    LET g_tlf.tlf903 = ' '
    LET g_tlf.tlf904 = ' '
    LET g_tlf.tlf905 = l_run.run01
    LET g_tlf.tlf906 = l_run.run02
    CALL s_tlf(1,0)    
END FUNCTION 

FUNCTION t726_unconfirm()
   DEFINE l_rumcond         LIKE rum_file.rumcond
   DEFINE l_rumconu         LIKE rum_file.rumconu
   DEFINE l_n               LIKE type_file.num5
   DEFINE i                 LIKE type_file.num5
   DEFINE l_run09           LIKE run_file.run09 
   IF cl_null(g_rum.rum01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rum.* FROM rum_file
    WHERE rum01 = g_rum.rum01
      AND rum00=g_rum00
      AND rumplant=g_rum.rumplant 
    LET l_rumcond = g_rum.rumcond
    LET l_rumconu = g_rum.rumconu
  
   IF g_rum.rumacti ='N' THEN
      CALL cl_err(g_rum.rum01,'alm-973',1)
      RETURN
   END IF
 
   IF g_rum.rumconf = 'N' THEN
      CALL cl_err(g_rum.rum01,'alm-007',1)
      RETURN
   END IF
   IF g_rum.rumconf = 'X' THEN
      CALL cl_err(g_rum.rum01,'alm-134',1)
      RETURN
   END IF
   IF g_rum00='1' THEN 
      SELECT COUNT(*) INTO l_n FROM rum_file 
       WHERE rum02=g_rum.rum01
         AND rumplant=g_rum.rumplant
         AND rum00='2'
      IF l_n > 0 THEN 
         CALL cl_err('','art-623',1) 
         RETURN 
      END IF 
   END IF  
   BEGIN WORK 
   OPEN t726_cl USING g_rum.rum01,g_plant
   IF STATUS THEN 
       CALL cl_err("open t726_cl:",STATUS,1)
       CLOSE t726_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t726_cl INTO g_rum.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_rum.rum01,SQLCA.sqlcode,0)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN 
    END IF    
   LET g_success='N'  
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
 
       UPDATE rum_file
          SET rumconf = 'N',
              rumcond = NULL,
              rumconu = NULL,
              rummodu=g_user,
              rumdate=g_today
        WHERE rum01 = g_rum.rum01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd rum:',SQLCA.SQLCODE,0)
          LET g_success='N'
          LET g_rum.rumconf = "Y"
          LET g_rum.rumcond = l_rumcond
          LET g_rum.rumconu = l_rumconu
          DISPLAY BY NAME g_rum.rumconf,g_rum.rumcond,g_rum.rumconu,g_rum.rummodu,g_rum.rumdate
          RETURN
         ELSE  
            IF g_rum00='2' THEN 
               FOR i=1 TO g_rec_b
                  UPDATE run_file SET run09=run09-g_run[i].run10    
                   WHERE run00='1'
                     AND run01=g_rum.rum02                    
                     AND run02=g_run[i].run02                   
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rum_file",g_rum.rum02,"",STATUS,"","",1)
                     LET g_success = 'N'
                     ROLLBACK WORK
                     RETURN
                  END IF 

                  UPDATE run_file SET run09=run09-g_run[i].run10    
                   WHERE run00='2'
                     AND run01 IN (SELECT rum01 FROM rum_file
                                    WHERE rum02 = g_rum.rum02 AND rum00='2')           #=g_rum.rum01                    
                     AND run02=g_run[i].run02  
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rum_file",g_rum.rum01,"",STATUS,"","",1)
                     LET g_success = 'N'
                    ROLLBACK WORK
                    RETURN
                  END IF    
               END FOR
            END IF 
            
            MESSAGE "DELETE FROM TLF_FILE!"
            DELETE FROM tlf_file 
             WHERE tlf026 = g_rum.rum01        #異動單號
               AND tlf13 = g_prog             #程序代號
               AND tlf020= g_rum.rumplant     #營運中心
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("del","tlf_file",g_rum.rum01,"",SQLCA.SQLCODE,"","del_tlf",1)
               LET g_success = 'N'
               RETURN
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('del tlf:','axm-176',1)
               LET g_success = 'N'
               RETURN
            END IF
 
            LET g_success='Y'  
            CALL t726_ins_img('U')
         END IF
   END IF 
   IF g_success='N' THEN 
      ROLLBACK WORK 
   ELSE 
      LET g_rum.rumconf = 'N'
      LET g_rum.rumcond = NULL
      LET g_rum.rumconu = NULL
      LET g_rum.rummodu = g_user
      LET g_rum.rumdate = g_today
      COMMIT WORK  
      DISPLAY BY NAME g_rum.rumconf,g_rum.rumcond,g_rum.rumconu,g_rum.rummodu,g_rum.rumdate
      CALL cl_set_field_pic("N","","","","",g_rum.rumacti)
      CALL t726_b_fill(g_wc2)
      CALL t726_bp_refresh()
   END IF 
   CLOSE t726_cl
#   COMMIT WORK   
END FUNCTION
 
FUNCTION t726_v() #作廢
DEFINE l_n LIKE type_file.num5
 
   IF cl_null(g_rum.rum01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   
   IF g_rum.rumacti='N' THEN
      CALL cl_err('','art-146',0)
      RETURN
   END IF
   
   IF g_rum.rumconf = 'Y' THEN
#      CALL cl_err('','apy-705',0)   #CHI-B40058
      CALL cl_err('','apc-122',0)    #CHI-B40058
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t726_cl USING g_rum.rum01,g_plant
   IF STATUS THEN
      CALL cl_err("OPEN t726_cl:", STATUS, 1)
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t726_cl INTO g_rum.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t726_cl
      ROLLBACK WORK
      RETURN
   END IF
    LET g_rum_t.* = g_rum.*      
    IF cl_void(0,0,g_rum.rumconf) THEN
       IF g_rum.rumconf='X' THEN
         LET g_rum.rumconf='N'
         LET g_rum.rumconu = ''
         LET g_rum.rumcond = ''
       ELSE
         LET g_rum.rumconf='X'
         LET g_rum.rumconu = g_user
         LET g_rum.rumcond = g_today
       END IF 
       LET g_rum.rummodu = g_user
       LET g_rum.rumdate = g_today
       UPDATE rum_file SET rumconf = g_rum.rumconf,
                           rumconu = g_rum.rumconu,
                           rumcond = g_rum.rumcond,
                           rummodu = g_rum.rummodu,
                           rumdate = g_rum.rumdate
        WHERE rum01 = g_rum.rum01 
          AND rum00 = g_rum00
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","rum_file",g_rum.rum01,"",STATUS,"","",1) 
          LET g_rum.rumconf=g_rum_t.rumconf
          LET g_rum.rumconu=g_rum_t.rumconu
          LET g_rum.rumcond=g_rum_t.rumcond
          LET g_success = 'N'
       ELSE
          IF SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("upd","rum_file",g_rum.rum01,"","9050","","",1) 
             LET g_rum.rumconf=g_rum_t.rumconf
             LET g_rum.rumconu=g_rum_t.rumconu
             LET g_rum.rumcond=g_rum_t.rumcond
             LET g_success = 'N'            
          END IF
       END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_rum.rumconf,g_rum.rumconu,g_rum.rumcond,
                      g_rum.rumuser,g_rum.rumdate
      IF g_rum.rumconf='X' THEN
        CALL cl_set_field_pic("","","","",'Y',"")
      ELSE
        CALL cl_set_field_pic("","","","",'N',"")
      END IF
   ELSE
      ROLLBACK WORK
   END IF   
END FUNCTION
 
 
FUNCTION t726_rum05(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_genacti LIKE gen_file.genacti
DEFINE l_gen02 LIKE gen_file.gen02

   LET g_errno=''
   SELECT gen02,genacti 
     INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_rum.rum05
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='aoo-017'
        WHEN l_genacti='N'     LET g_errno='9028'
        OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO rum05_desc
    END IF
END FUNCTION
 
 
FUNCTION t726_m_b()
   
   IF g_action_choice="detail" OR g_action_choice="insert" THEN
      LET l_allow_insert=cl_detail_input_auth("insert")
      LET l_allow_delete=cl_detail_input_auth("delete")
     # CALL cl_set_comp_entry("run02,run03,run09",TRUE)
      CALL cl_set_comp_entry("run13",FALSE)
   ELSE
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   #   CALL cl_set_comp_entry("run02,run03,run09",FALSE)
      CALL cl_set_comp_entry("run13",TRUE)
   END IF
   CALL t726_b()
END FUNCTION
 
FUNCTION t726_tlff_1(p_flag,p_run,p_type)
DEFINE
   p_run      RECORD LIKE run_file.*,
   p_flag     LIKE type_file.chr1,    
   p_type     LIKE type_file.num5,    
   l_imgg10_s LIKE imgg_file.imgg10,
   l_imgg10_t LIKE imgg_file.imgg10

    IF p_run.run04 IS NULL THEN
       CALL cl_err('p_run04 null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

    IF p_run.run06 IS NULL THEN
       CALL cl_err('p_run06 null:','asf-031',1) LET g_success = 'N' RETURN
    END IF

 
    INITIALIZE g_tlff.* TO NULL
    SELECT imgg10 INTO l_imgg10_s FROM imgg_file
     WHERE imgg01=p_run.run03  AND imgg02=p_run.run11
       AND imgg03=p_run.run12  AND imgg04=p_run.run13
       AND imgg09=p_run.run04
    IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
 
    SELECT imgg10 INTO l_imgg10_t FROM imgg_file
     WHERE imgg01=p_run.run03  AND imgg02=p_run.run11
       AND imgg03=p_run.run12  AND imgg04=p_run.run13
       AND imgg09=p_run.run06
    IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF

    LET g_tlff.tlff01=p_run.run03             
    LET g_tlff.tlff02=50                          
    LET g_tlff.tlff020=g_plant                   
    LET g_tlff.tlff021=p_run.run11             
    LET g_tlff.tlff022=p_run.run12              
    LET g_tlff.tlff023=p_run.run13             
    LET g_tlff.tlff024=l_imgg10_s 
    LET g_tlff.tlff025=p_run.run04              
    LET g_tlff.tlff026=p_run.run01              
    LET g_tlff.tlff027=p_run.run02          
    LET g_tlff.tlff03=50                          
    LET g_tlff.tlff030=g_plant                    
    LET g_tlff.tlff031=p_run.run11              
    LET g_tlff.tlff032=p_run.run12               
    LET g_tlff.tlff033=p_run.run13             
    LET g_tlff.tlff034=l_imgg10_t 
    LET g_tlff.tlff035=p_run.run06            
    LET g_tlff.tlff036=p_run.run01              
    LET g_tlff.tlff037=p_run.run02           
 
    IF p_type=-1 THEN  
       LET g_tlff.tlff02=50
       LET g_tlff.tlff03=99
       LET g_tlff.tlff030=' '
       LET g_tlff.tlff031=' '
       LET g_tlff.tlff032=' '
       LET g_tlff.tlff033=' '
       LET g_tlff.tlff034=0
       LET g_tlff.tlff035=' '
       LET g_tlff.tlff036=' '
       LET g_tlff.tlff037=0
       LET g_tlff.tlff10=p_run.run08                 
       LET g_tlff.tlff11=p_run.run04             
       LET g_tlff.tlff12=p_run.run07              
       LET g_tlff.tlff930=p_run.runplant    
    ELSE               
       LET g_tlff.tlff02=99
       LET g_tlff.tlff03=50
       LET g_tlff.tlff020=' '
       LET g_tlff.tlff021=' '
       LET g_tlff.tlff022=' '
       LET g_tlff.tlff023=' '
       LET g_tlff.tlff024=0
       LET g_tlff.tlff025=' '
       LET g_tlff.tlff026=' '
       LET g_tlff.tlff027=0
       LET g_tlff.tlff10=p_run.run09               
       LET g_tlff.tlff11=p_run.run06              
       LET g_tlff.tlff12=p_run.run07               
       LET g_tlff.tlff930=p_run.runplant     
    END IF
 
    LET g_tlff.tlff04=' '                         
    LET g_tlff.tlff05=' '                         
    LET g_tlff.tlff06=g_rum.rum04                 
    LET g_tlff.tlff07=g_today                    
    LET g_tlff.tlff08=TIME                        
    LET g_tlff.tlff09=g_user                      
    LET g_tlff.tlff13='artt726'                    
    LET g_tlff.tlff14=' '                 
    LET g_tlff.tlff15=g_debit                   
    LET g_tlff.tlff16=g_credit                    
    LET g_tlff.tlff17=g_rum.rum06               
    LET g_tlff.tlff19=' '                 
    LET g_tlff.tlff20= ' '                       
    IF p_type=-1 THEN
       IF cl_null(p_run.run08) OR p_run.run08 = 0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,p_run.run04)
       END IF
    ELSE
       IF cl_null(p_run.run09) OR p_run.run09 = 0 THEN
          CALL s_tlff(p_flag,NULL)
       ELSE
          CALL s_tlff(p_flag,p_run.run06)
       END IF
    END IF
END FUNCTION

#FUN-A10008 ADD START------------------------------------------
FUNCTION t726_rum02()
DEFINE l_rum01     LIKE rum_file.rum01
DEFINE l_rumconf   LIKE rum_file.rumconf
DEFINE l_rumacti   LIKE rum_file.rumacti
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_pmcacti   LIKE pmc_file.pmcacti
 
   SELECT rum03,rumacti,rumconf INTO g_rum.rum03,l_rumacti,l_rumconf
     FROM rum_file 
    WHERE rum00='1' AND rum01 = g_rum.rum02 AND rumplant=g_rum.rumplant
      CASE
         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-616'
         WHEN l_rumacti='N'        LET g_errno = '9028'
         WHEN l_rumconf <> 'Y'     LET g_errno = 'art-616' 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
                                   DISPLAY BY NAME  g_rum.rum03
      END CASE


   IF NOT cl_null(g_rum.rum03) THEN
      SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
        FROM pmc_file WHERE pmc01 = g_rum.rum03
      CASE
         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-056'
         WHEN l_pmcacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
                                   DISPLAY l_pmc03 TO FORMONLY.rum03_desc
      END CASE
   END IF
      
END FUNCTION


FUNCTION t726_rum03()
DEFINE l_pmc03     LIKE pmc_file.pmc03
DEFINE l_pmcacti   LIKE pmc_file.pmcacti

   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
      FROM pmc_file WHERE pmc01 = g_rum.rum03

   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-056'
      WHEN l_pmcacti='N'        LET g_errno = '9028'
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
                                DISPLAY l_pmc03 TO FORMONLY.rum03_desc
   END CASE

END FUNCTION



FUNCTION t726_check_img10()
DEFINE l_img10     LIKE img_file.img10
 
    LET g_errno = ''
    IF cl_null(g_run[l_ac].run03) OR cl_null(g_run[l_ac].run11)
       OR cl_null(g_run[l_ac].run10) THEN
       RETURN
    END IF

     IF cl_null(g_run[l_ac].run12) THEN
        LET g_run[l_ac].run12 = ' '
     END IF
 
     IF cl_null(g_run[l_ac].run13) THEN
        LET g_run[l_ac].run13 = ' '
     END IF 
 
 
    SELECT SUM(img10) INTO l_img10 FROM img_file
         WHERE img01 = g_run[l_ac].run03
           AND img02 = g_run[l_ac].run11
           AND img03 = g_run[l_ac].run12
           AND img04 = g_run[l_ac].run13
           AND img18 > g_today
    IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
 
    IF l_img10 < g_run[l_ac].run10 THEN
       LET g_errno = 'art-475'
    END IF
END FUNCTION

FUNCTION t726_run03()
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_rtyacti     LIKE rty_file.rtyacti
DEFINE l_rtz04       LIKE rtz_file.rtz04
DEFINE l_rte07       LIKE rte_file.rte07
DEFINE l_rtaacti     LIKE rta_file.rtaacti
DEFINE l_rty06_1     LIKE rty_file.rty06
DEFINE l_rty06_2     LIKE rty_file.rty06
    
    LET g_errno = ""
    
    IF NOT cl_null(g_run[l_ac].run05) THEN 
       SELECT rta01,rtaacti INTO g_run[l_ac].run03,l_rtaacti
          FROM rta_file WHERE rta05 = g_run[l_ac].run05
          
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'art-298'
                               RETURN
            WHEN l_rtaacti='N' LET g_errno = '9028'
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE          
    END IF 
    
    SELECT ima02,ima25,imaacti
        INTO g_run[l_ac].run03_desc,g_run[l_ac].run04,l_imaacti
        FROM ima_file WHERE ima01 = g_run[l_ac].run03
 
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-037'
                            RETURN
         WHEN l_imaacti='N' LET g_errno = '9028'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
    SELECT gfe02,gfeacti INTO g_run[l_ac].run04_desc,l_gfeacti 
       FROM gfe_file WHERE gfe01 = g_run[l_ac].run04
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'mfg1200'
                            RETURN
         WHEN l_gfeacti='N' LET g_errno = 'art-293'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE  
    
    SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_ruq.ruqplant
    IF NOT cl_null(l_rtz04) THEN
       SELECT rte07 INTO l_rte07 FROM rte_file,rtd_file 
        WHERE rtd01 = rte01 AND rtd01 = l_rtz04 AND rtdconf = 'Y'
          AND rte03 = g_run[l_ac].run03
       IF SQLCA.SQLCODE = 100 THEN
          LET g_errno = 'art-296'
          RETURN
       END IF 
       IF l_rte07 = 'N' OR l_rte07 IS NULL THEN
          LET g_errno = 'art-297'
          RETURN
       END IF
    END IF  

    DISPLAY g_run[l_ac].run03_desc,g_run[l_ac].run04,
            g_run[l_ac].run04_desc 
END FUNCTION
 
FUNCTION t726_run06()
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_smcacti     LIKE smc_file.smcacti
 
    LET g_errno = ""
    
    SELECT gfe02,gfeacti INTO g_run[l_ac].run06_desc ,l_gfeacti 
      FROM gfe_file
     WHERE gfe01 = g_run[l_ac].run06  
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'afa-319'
                            RETURN
         WHEN l_gfeacti='N' LET g_errno = 'art-061'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     
END FUNCTION

FUNCTION t726_chk_jce02(p_kind,p_jce02) 
DEFINE   p_kind    LIKE type_file.chr1
DEFINE   l_n       LIKE type_file.num5
DEFINE   p_jce02   LIKE jce_file.jce02
#p_kind='1' 時為成本倉
#p_kind='2' 時為非成本倉
    LET g_errno=''
    SELECT COUNT(*) INTO l_n FROM jce_file 
     WHERE jce02=p_jce02 
    IF p_kind='1' THEN 
       IF l_n>0 THEN 
          LET g_errno='art-628'
          RETURN 
       END IF 
    ELSE    
       IF l_n=0 THEN 
          LET g_errno='art-627'
          RETURN 
       END IF 
    END IF 
END FUNCTION 
#FUN-A10008 ADD END-------------------------------------------------------------
#FUN-BB0085----add----str----
FUNCTION t726_run10_check()
   IF NOT cl_null(g_run[l_ac].run10) AND NOT cl_null(g_run[l_ac].run06) THEN 
      IF cl_null(g_run06_t) OR g_run06_t != g_run[l_ac].run06 OR
         cl_null(g_run_t.run10) OR g_run_t.run10 != g_run[l_ac].run10 THEN 
         LET g_run[l_ac].run10 = s_digqty(g_run[l_ac].run10,g_run[l_ac].run06) 
         DISPLAY BY NAME g_run[l_ac].run10
      END IF
   END IF

   IF NOT cl_null(g_run[l_ac].run10) THEN
      IF g_run[l_ac].run10 <= 0 THEN
         CALL cl_err('','alm-808',0)
         LET g_run[l_ac].run10 = g_run_t.run10
         DISPLAY g_run[l_ac].run10
         RETURN FALSE    
      ELSE
         IF g_rum00 = '2' THEN
            IF g_run[l_ac].run10 > (g_run[l_ac].run08-g_run[l_ac].run09) THEN
               CALL cl_err('','art-620',0)
               LET g_run[l_ac].run10 = g_run_t.run10
               DISPLAY g_run[l_ac].run10
               RETURN FALSE    
            ELSE
               CALL t726_check_img10()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_run[l_ac].run10 = g_run_t.run10
                  DISPLAY BY NAME g_run[l_ac].run10
                  RETURN FALSE    
               END IF
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE 
END FUNCTION
#FUN-BB0085----add----end----
#No.FUN-9B0025 PASS NO.


