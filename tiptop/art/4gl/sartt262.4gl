# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sartt262.4gl
# Descriptions...: 商品借出/返還單 
# Date & Author..: No:FUN-870100 09/10/21 By Cockroach
# Modify.........: No:FUN-9B0025 09/11/06 By Cockroach 
# Modify.........: No:FUN-A10047 10/01/12 By destiny 修改商品和单位的开窗
# Modify.........: No:TQC-A10086 10/01/12 By Cockroach 非當前plant的權限管控
# Modify.........: No:TQC-A20025 10/02/09 By Cockroach 調整
# Modify.........: No:TQC-A20039 10/02/22 By Cockroach BUG處理
# Modify.........: No:TQC-A20023 10/02/23 By Cockroach BUG處理
# Modify.........: No:TQC-A20024 10/02/23 By Cockroach BUG處理
# Modify.........: No:TQC-A20046 10/02/23 By Cockroach BUG處理
# Modify.........: No:TQC-A20048 10/02/23 By Cockroach BUG處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30002 10/03/01 By Cockroach BUG處理
# Modify.........: No:TQC-A30055 10/03/17 By Cockroach 過賬增加確認對話框
# Modify.........: No:TQC-A30060 10/03/17 By Cockroach  BUG處理
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AB0067 10/11/17 by destiny  增加倉庫的權限控管
# Modify.........: No.TQC-AC0223 11/01/07 by wangxin rur06新增開窗調整
# Modify.........: No.TQC-B30149 11/03/18 By huangtao s_fetch_price_A2少了一個參數
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60067 11/06/10 By baogc s_fetch_price_A2增加參數
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-BB0117 11/11/24 By fanbj 將t615替換為t624
# Modify.........: No.FUN-910088 12/01/16 By chenjing 增加數量欄位小數取位
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
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:FUN-BC0062 13/02/28 By xujing 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D30019 13/03/11 By dongsz 產生異動記錄邏輯調整
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds                    

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt262.global"
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
DEFINE g_rur06_t  LIKE rur_file.rur06     #FUN-910088--add--
#DEFINE l_img_table      STRING             #FUN-C70087 #FUN-CC0095

FUNCTION t262(p_argv1)
DEFINE p_argv1 LIKE type_file.chr1
 
    WHENEVER ERROR CALL cl_err_msg_log
    #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087 #FUN-CC0095
    LET g_ruq00 = p_argv1
    LET g_forupd_sql="SELECT * FROM ruq_file ",
                     " WHERE ruq00='",g_ruq00,"' AND ruq01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t262_cl CURSOR FROM g_forupd_sql
    

       LET p_row = 4 LET p_col = 10
       OPEN WINDOW t262_w AT p_row,p_col WITH FORM "art/42f/artt262"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_init()
    CALL cl_set_comp_visible("ruq02,rur14",g_ruq00='2') 
    IF g_ruq00 ='1' THEN
       CALL cl_set_act_visible("pledge_receiving",TRUE) 
       CALL cl_set_act_visible("pledge_returning",FALSE)   
    ELSE 
       CALL cl_set_act_visible("pledge_receiving",FALSE) 
       CALL cl_set_act_visible("pledge_returning",TRUE) 
    END IF           
    CALL t262_g_form()
 
    CALL t262_menu()
    
    CLOSE WINDOW t262_w
    #CALL s_padd_img_drop(l_img_table)  #FUN-C70087 #FUN-CC0095
END FUNCTION
 
FUNCTION t262_g_form()
DEFINE l_ruq01 LIKE gae_file.gae04
DEFINE l_ruq03 LIKE gae_file.gae04
DEFINE l_ruq04 LIKE gae_file.gae04
DEFINE l_inx   LIKE type_file.num5
DEFINE l_str STRING

    SELECT gae04 INTO l_ruq01 FROM gae_file
     WHERE gae01 = 'artt262'
       AND gae12 = 'std'
       AND gae02 = 'ruq01'
       AND gae03 = g_lang
    SELECT gae04 INTO l_ruq03 FROM gae_file
     WHERE gae01 = 'artt262'
       AND gae12 = 'std'
       AND gae02 = 'ruq03'
       AND gae03 = g_lang
    SELECT gae04 INTO l_ruq04 FROM gae_file
     WHERE gae01 = 'artt262'
       AND gae12 = 'std'
       AND gae02 = 'ruq04'
       AND gae03 = g_lang
 
    IF g_ruq00='1' THEN
       LET l_str = l_ruq01
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("ruq01",l_str.subString(1,l_inx-1))
       LET l_str = l_ruq03
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("ruq03",l_str.subString(1,l_inx-1))
       LET l_str = l_ruq04
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("ruq04",l_str.subString(1,l_inx-1))   
    ELSE
       LET l_str = l_ruq01
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("ruq01",l_str.subString(l_inx+1,l_str.getLength()))
       LET l_str = l_ruq03
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("ruq03",l_str.subString(l_inx+1,l_str.getLength()))
       LET l_str = l_ruq04
       LET l_inx=l_str.getIndexOf("/",1)
       CALL cl_set_comp_att_text("ruq04",l_str.subString(l_inx+1,l_str.getLength()))
    END IF
END FUNCTION
 
FUNCTION t262_menu()
DEFINE l_n   LIKE type_file.num5   #TQC-A10086 add
   WHILE TRUE
      CALL t262_bp("G")
      CASE g_action_choice
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t262_y()
            END IF
        #TQC-A10086 ADD-----------    
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t262_n()
            END IF            
        #TQC-A10086 ADD-----------  
         WHEN "void" 
            IF cl_chk_act_auth() THEN
               CALL t262_v(1)
            END IF 
         #FUN-D20039 ---------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t262_v(2)
            END IF
         #FUN-D20039 ---------end
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t262_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t262_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t262_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t262_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t262_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t262_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t262_m_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t262_p() 
               IF g_ruq.ruqconf='X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_ruq.ruqconf,"",g_ruq.ruq12,"",g_void,"")
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN 
               CALL t262_rp() 
            END IF         
            
         WHEN "pledge_receiving"        #-->artt624 
            IF g_ruq.ruq01 IS NULL THEN
               CALL cl_err("",-400,1) 
            ELSE	  
               IF g_ruq.ruqconf<>'Y' THEN 
                  CALL cl_err(g_ruq.ruq01,'art-615',1)
               ELSE	
                  LET g_cmd = "artt624 '",g_ruq.ruq01,"'" #FUN-BB0117
                  CALL cl_cmdrun(g_cmd)            
               END IF 
            END IF   
         WHEN "pledge_returning"        # -->artt625     
            IF g_ruq.ruq01 IS NULL THEN
               CALL cl_err("",-400,1) 
            ELSE
               IF g_ruq.ruqconf<>'Y' THEN 
                  CALL cl_err(g_ruq.ruq01,'art-615',1)
               ELSE
                  IF g_ruq00='2'  THEN
                     SELECT COUNT(*) INTO l_n 
                       FROM rxr_file
                      WHERE rxr00='1'
                        AND rxr02=g_ruq.ruq02 
                        AND rxrconf='Y'
                     IF l_n<>1 THEN
                        CALL cl_err('','art-626',1)
                     ELSE 
                        LET g_cmd = "artt625 '",g_ruq.ruq01,"'"
                        CALL cl_cmdrun(g_cmd)               
                     END IF
                  END IF
               END IF  
            END IF                   
             
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL t262_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rur),'','')
             END IF        
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_ruq.ruq01) THEN
                 LET g_doc.column1 = "ruq01"
                 LET g_doc.value1 = g_ruq.ruq01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t262_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rur TO s_rur.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm          #TQC-A10086 ADD
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY 
      #FUN-D20039 ----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ----------end
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
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      ON ACTION pledge_receiving
         LET g_action_choice="pledge_receiving"
         EXIT DISPLAY
      ON ACTION pledge_returning
         LET g_action_choice="pledge_returning"
         EXIT DISPLAY
         
      ON ACTION first
         CALL t262_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL t262_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t262_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL t262_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t262_fetch('L')
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
         CALL t262_g_form()

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
 
FUNCTION t262_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
 
    CLEAR FORM
    CALL g_rur.clear()
    CONSTRUCT BY NAME g_wc ON                               
        ruq01,ruq02,ruq03,ruq04,ruq05,
        ruq06,ruq07,ruq08,ruq09,ruq10,
        ruq11,ruq12,ruqconf,ruqcond,
        ruqconu,ruqplant,ruquser,
        ruqgrup,ruqmodu,ruqdate,ruqacti,
        ruqcrat,ruqoriu,ruqorig
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init() 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ruq01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruq01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = g_ruq00
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruq01
                 NEXT FIELD ruq01
              WHEN INFIELD(ruq02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruq01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruq02
                 NEXT FIELD ruq02
              WHEN INFIELD(ruq05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruq05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruq05
                 NEXT FIELD ruq05
              WHEN INFIELD(ruq11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruq11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruq11
                 NEXT FIELD ruq11
              WHEN INFIELD(ruqconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruqconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruqconu
                 NEXT FIELD ruqconu
              WHEN INFIELD(ruqplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruqplant
                 NEXT FIELD ruqplant
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruquser', 'ruqgrup')
   
    CONSTRUCT g_wc2 ON rur02,rur03,rur04,rur05,rur06,
                       rur07,rur08,rur09,rur10,rur11,
                       rur12,rur13,rur14,rur15,rur16,
                       rur17,rur18,rur19,rur20,rur21
                  FROM s_rur[1].rur02,s_rur[1].rur03,s_rur[1].rur04,
                       s_rur[1].rur05,s_rur[1].rur06,s_rur[1].rur07,
                       s_rur[1].rur08,s_rur[1].rur09,s_rur[1].rur10,
                       s_rur[1].rur11,s_rur[1].rur12,s_rur[1].rur13,
                       s_rur[1].rur14,s_rur[1].rur15,s_rur[1].rur16,
                       s_rur[1].rur17,s_rur[1].rur18,s_rur[1].rur19,
                       s_rur[1].rur20,s_rur[1].rur21
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
            WHEN INFIELD(rur02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rur02"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = g_ruq00 
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY  g_qryparam.multiret TO rur02
               NEXT FIELD rur02 
            WHEN INFIELD(rur03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rur03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rur03
               NEXT FIELD rur03
            WHEN INFIELD(rur04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rur04"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rur04
               NEXT FIELD rur04   

            WHEN INFIELD(rur06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rur06"  
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rur06
               NEXT FIELD rur06
            WHEN INFIELD(rur09)
               #No.FUN-AA0049--begin
               #CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_rur09"
               #LET g_qryparam.state = "c"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
               #No.FUN-AA0049--end 
               DISPLAY g_qryparam.multiret TO rur09
               NEXT FIELD rur09
            WHEN INFIELD(rur10)
               #No.FUN-AB0067--begin    
               #CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_rur10"
               #LET g_qryparam.state = "c"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
               #No.FUN-AB0067--end
               DISPLAY g_qryparam.multiret TO rur10
               NEXT FIELD rur10
            WHEN INFIELD(rur11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rur11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rur11
               NEXT FIELD rur11
            WHEN INFIELD(rur16)
               #No.FUN-AA0049--begin
               #CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_rur16"
               #LET g_qryparam.state = "c"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
               #No.FUN-AA0049--end
               DISPLAY g_qryparam.multiret TO rur16
               NEXT FIELD rur16
            WHEN INFIELD(rur17)
               #No.FUN-AB0067--begin 
               #CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_rur17"
               #LET g_qryparam.state = "c"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
               #No.FUN-AB0067--end
               DISPLAY g_qryparam.multiret TO rur17
               NEXT FIELD rur17
            WHEN INFIELD(rur18)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rur18"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rur18
               NEXT FIELD rur18
            WHEN INFIELD(rur20)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rur20"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rur20
               NEXT FIELD rur20
                  
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
        LET g_sql = "SELECT ruq01 FROM ruq_file ", 
                    " WHERE ruq00 = '",g_ruq00,"'",
                    "   AND ",g_wc CLIPPED," ORDER BY ruq01"
    ELSE                                 
        LET g_sql = "SELECT UNIQUE ruq01",
                    "  FROM ruq_file,rur_file",
                    " WHERE ruq01=rur01",
                    "   AND ruq00=rur00",
                    "   AND ruq00='",g_ruq00,"'",
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " ORDER BY ruq01"
    END IF 
    PREPARE t262_prepare FROM g_sql
    DECLARE t262_cs SCROLL CURSOR WITH HOLD FOR t262_prepare
    
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM ruq_file ",
                 " WHERE ruq00='",g_ruq00,"' AND ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT ruq01) FROM ruq_file,rur_file",
                 " WHERE ruq01=rur01 ",
                 "   AND ruq00=rur00",
                 "   AND ruq00='",g_ruq00,"'",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t262_precount FROM g_sql
    DECLARE t262_count CURSOR FOR t262_precount
END FUNCTION
 
FUNCTION t262_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_rur.clear()
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
 
    CALL t262_cs()
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ruq.* TO NULL
        CALL g_rur.clear()
        RETURN
    END IF
 
    OPEN t262_cs
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_rur.clear()
    ELSE
       OPEN t262_count
       FETCH t262_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL t262_fetch('F')
       ELSE
          CALL cl_err('',100,0)
       END IF
    END IF
END FUNCTION
 
FUNCTION t262_fetch(p_flruq)
DEFINE p_flruq         LIKE type_file.chr1    
       
    CASE p_flruq
        WHEN 'N' FETCH NEXT     t262_cs INTO g_ruq.ruq01
        WHEN 'P' FETCH PREVIOUS t262_cs INTO g_ruq.ruq01
        WHEN 'F' FETCH FIRST    t262_cs INTO g_ruq.ruq01
        WHEN 'L' FETCH LAST     t262_cs INTO g_ruq.ruq01
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
            FETCH ABSOLUTE g_jump t262_cs INTO g_ruq.ruq01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0)
        INITIALIZE g_ruq.* TO NULL  
        RETURN
    ELSE
      CASE p_flruq
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_ruq.* FROM ruq_file    
     WHERE ruq00 = g_ruq00
       AND ruq01 = g_ruq.ruq01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ruq_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_ruq.ruquser           
        LET g_data_group=g_ruq.ruqgrup
        LET g_data_plant=g_ruq.ruqplant   #TQC-A10086 ADD
        CALL t262_show()                   
    END IF
END FUNCTION
 
FUNCTION t262_show()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE l_occ02 LIKE occ_file.occ02
DEFINE l_azp02 LIKE azp_file.azp02
 
    LET g_ruq_t.* = g_ruq.*
    DISPLAY BY NAME g_ruq.ruq01,g_ruq.ruq02,g_ruq.ruq03,g_ruq.ruq04,
                    g_ruq.ruq05,g_ruq.ruq06,g_ruq.ruq07,g_ruq.ruq08,
                    g_ruq.ruq09,g_ruq.ruq10,g_ruq.ruq11,g_ruq.ruq12,
                    g_ruq.ruqconf,g_ruq.ruqcond,g_ruq.ruqconu,
                    g_ruq.ruqplant,g_ruq.ruquser,g_ruq.ruqgrup,
                    g_ruq.ruqmodu,g_ruq.ruqdate,g_ruq.ruqacti,
                    g_ruq.ruqcrat,g_ruq.ruqoriu,g_ruq.ruqorig

    IF cl_null(g_ruq.ruq05) THEN
       DISPLAY '' TO ruq05_desc
    ELSE
       SELECT gen02 INTO l_gen02 FROM gen_file
        WHERE gen01 = g_ruq.ruq05
          AND genacti = 'Y'
       DISPLAY l_gen02 TO ruq05_desc
    END IF
    
    IF cl_null(g_ruq.ruqconu) THEN
       DISPLAY '' TO ruqconu_desc
    ELSE
       SELECT gen02 INTO l_gen02 FROM gen_file
        WHERE gen01 = g_ruq.ruqconu
          AND genacti = 'Y'
       DISPLAY l_gen02 TO ruqconu_desc
    END IF
    
    IF cl_null(g_ruq.ruq11) THEN
       DISPLAY '' TO ruq11_desc
    ELSE
       SELECT occ02 INTO l_occ02 FROM occ_file
        WHERE occ01 = g_ruq.ruq11
          AND occacti = 'Y'
       DISPLAY l_occ02 TO ruq11_desc
    END IF
    
    SELECT azp02 INTO l_azp02 FROM azp_file
     WHERE azp01 = g_ruq.ruqplant
    DISPLAY l_azp02 TO ruqplant_desc
    #CALL t262_ruq05('d')
    CASE g_ruq.ruqconf
       WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
       WHEN "N"
          CALL cl_set_field_pic('',"","","","",g_ruq.ruqacti)
       WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    CALL t262_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t262_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
       LET g_sql = "SELECT rur02,rur03,'',rur04,'',rur05,rur06,'',rur07,rur08,",
                   "       rur09,rur10,rur11,rur12,rur13,rur14,rur15,rur16,",
                   "       rur17,rur18,rur19,rur20,rur21 ",
                   "  FROM rur_file ",
                   " WHERE rur01 = '",g_ruq.ruq01,"'",
                   "   AND rur00 = '",g_ruq00,"'"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t262_pb FROM g_sql
    DECLARE rur_cs CURSOR FOR t262_pb
 
    CALL g_rur.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rur_cs INTO g_rur[g_cnt].*  
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH
        END IF

        SELECT ima02 INTO g_rur[g_cnt].rur03_desc FROM ima_file
         WHERE ima01 = g_rur[g_cnt].rur03
           AND imaacti = 'Y'        
        SELECT gfe02 INTO g_rur[g_cnt].rur04_desc FROM gfe_file
         WHERE gfe01 = g_rur[g_cnt].rur04
           AND gfeacti = 'Y'        
        SELECT gfe02 INTO g_rur[g_cnt].rur06_desc FROM gfe_file
         WHERE gfe01 = g_rur[g_cnt].rur06
           AND gfeacti = 'Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rur.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t262_a_default()
DEFINE l_azp02 LIKE azp_file.azp02
DEFINE l_occ02 LIKE occ_file.occ02 

      LET g_ruq.ruq00 = g_ruq00
      LET g_ruq.ruq03 = g_today
      LET g_ruq.ruq05 = g_user
      LET g_ruq.ruq08 = '1'    #TQC-A20048 ADD 
      LET g_ruq.ruq12 = 'N'
      LET g_ruq.ruqconf = 'N'
      LET g_ruq.ruqplant = g_plant
      LET g_ruq.ruquser = g_user
      LET g_ruq.ruqgrup = g_grup
      LET g_ruq.ruqcrat = g_today
      LET g_ruq.ruqacti = 'Y' 
      LET g_ruq.ruqoriu = g_user
      LET g_ruq.ruqorig = g_grup
      LET g_data_plant = g_plant          #TQC-A10086 ADD 
      SELECT rtz06 INTO g_ruq.ruq11 FROM rtz_file
       WHERE rtz01 = g_plant     
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
      SELECT azw02 INTO g_ruq.ruqlegal FROM azw_file
       WHERE azw01 = g_plant
         AND azwacti = 'Y'
      DISPLAY BY NAME g_ruq.ruq03,g_ruq.ruq05,g_ruq.ruq11,g_ruq.ruq12,
                      g_ruq.ruqconf,g_ruq.ruqplant,g_ruq.ruquser,
                      g_ruq.ruqgrup,g_ruq.ruqcrat,g_ruq.ruqacti,
                      g_ruq.ruqoriu,g_ruq.ruqorig
      DISPLAY l_azp02 TO ruqplant_desc
      IF cl_null(g_ruq.ruq11) THEN
         DISPLAY '' TO ruq11_desc
      ELSE
         SELECT occ02 INTO l_occ02 FROM occ_file
          WHERE occ01 = g_ruq.ruq11
            AND occacti = 'Y'
         DISPLAY l_occ02 TO ruq11_desc
      END IF
END FUNCTION
 
FUNCTION t262_a()
DEFINE li_result LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rur.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruq.* LIKE ruq_file.*                  
 
   LET g_ruq_t.* = g_ruq.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t262_a_default()                   
 
      CALL t262_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_ruq.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruq.ruq01) THEN       
         CONTINUE WHILE
      END IF
      BEGIN WORK
      IF g_ruq00 = '1'  THEN
#        CALL s_auto_assign_no("art",g_ruq.ruq01,g_today,"G","ruq_file","ruq00,ruq01","","","") #FUN-A10008 ADD #FUN-A70130 mark
         CALL s_auto_assign_no("art",g_ruq.ruq01,g_today,"J2","ruq_file","ruq00,ruq01","","","") #FUN-A10008 ADD #FUN-A70130 mod
         RETURNING li_result,g_ruq.ruq01
      ELSE
#        CALL s_auto_assign_no("art",g_ruq.ruq01,g_today,"H","ruq_file","ruq00,ruq01","","","") #FUN-A10008 ADD #FUN-A70130 mark
         CALL s_auto_assign_no("art",g_ruq.ruq01,g_today,"J3","ruq_file","ruq00,ruq01","","","") #FUN-A10008 ADD #FUN-A70130 mod
         RETURNING li_result,g_ruq.ruq01  
      END IF   
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ruq.ruq01
      IF g_ruq.ruq08 IS NULL THEN LET g_ruq.ruq08=' ' END IF 
      INSERT INTO ruq_file VALUES (g_ruq.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,1)   
         CALL cl_err3("ins","ruq_file",g_ruq.ruq01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_ruq.* FROM ruq_file
       WHERE ruq01 = g_ruq.ruq01
         AND ruq00 = g_ruq00  
      LET g_ruq_t.* = g_ruq.*
      CALL g_rur.clear()
      IF g_ruq00='2' THEN  
         IF cl_confirm("art-221") THEN
            BEGIN WORK
            CALL t262_b_create()
            IF g_success = 'Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
#              CALL t262_delall() #CHI-C30002 mark
               CALL t262_delHeader()     #CHI-C30002 add
               RETURN
            END IF
            CALL t262_b_fill(" 1=1")
            LET l_ac=1
         ELSE
            LET g_rec_b=0
         END IF
      END IF
     
      CALL t262_m_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION

FUNCTION t262_b_create()
DEFINE l_rur RECORD LIKE rur_file.*
  
   LET g_success='Y' 
   LET g_sql = "SELECT * FROM rur_file ",
               " WHERE rur01 = '",g_ruq.ruq02,"'",
               "   AND rur00 = '1'"
    PREPARE t262_pb1 FROM g_sql
    DECLARE rur_cs1 CURSOR FOR t262_pb1                   
 
      LET g_cnt=1
      FOREACH rur_cs1 INTO l_rur.*
         IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
         END IF
         LET l_rur.rur00 = g_ruq00
         LET l_rur.rur01 = g_ruq.ruq01
         LET l_rur.rur15 = 0
         LET l_rur.rur19 = 'N'
         INSERT INTO rur_file VALUES (l_rur.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
         LET g_cnt=g_cnt+1
      END FOREACH

END FUNCTION
 
FUNCTION t262_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1
DEFINE     l_occ02   LIKE occ_file.occ02
DEFINE     l_n       LIKE type_file.num5
DEFINE     l_ruq03   LIKE ruq_file.ruq03
     
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME
      g_ruq.ruq01,g_ruq.ruq02,g_ruq.ruq03,g_ruq.ruq04,
      g_ruq.ruq05,g_ruq.ruq06,g_ruq.ruq07,g_ruq.ruq08,
      g_ruq.ruq09,g_ruq.ruq10,g_ruq.ruq11,g_ruq.ruq12   
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL t262_set_entry(p_cmd)
          CALL t262_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ruq01")    #TQC-A20025 ADD

        IF p_cmd="a" THEN
      	  SELECT rtz06 INTO g_ruq.ruq11 FROM rtz_file
      	   WHERE rtz01 = g_plant
      	  IF NOT cl_null(g_ruq.ruq11)  THEN
             SELECT occ02 INTO l_occ02  FROM occ_file
              WHERE occ01 = g_ruq.ruq11
             IF l_occ02 IS NULL  THEN
                LET l_occ02 = ' '
             END IF 	
          ELSE 
       	     LET g_ruq.ruq11 = ' '
       	     LET l_occ02     = ' '    
          END IF	     
          DISPLAY BY NAME g_ruq.ruq11
          DISPLAY l_occ02 TO FORMONLY.ruq11_desc 
        END IF

	
      AFTER FIELD ruq01
         IF NOT cl_null(g_ruq.ruq01) THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_ruq.ruq01 <> g_ruq_t.ruq01) THEN
               IF g_ruq00 = '1' THEN
#                 CALL s_check_no("art",g_ruq.ruq01,g_ruq_t.ruq01,"G","ruq_file","ruq00,ruq01","") #FUN-A70130 mark
                  CALL s_check_no("art",g_ruq.ruq01,g_ruq_t.ruq01,"J2","ruq_file","ruq00,ruq01","") #FUN-A70130 mod
                  RETURNING li_result,g_ruq.ruq01
               ELSE 
#                 CALL s_check_no("art",g_ruq.ruq01,g_ruq_t.ruq01,"H","ruq_file","ruq00,ruq01","") #FUN-A70130 mark
                  CALL s_check_no("art",g_ruq.ruq01,g_ruq_t.ruq01,"J3","ruq_file","ruq00,ruq01","") #FUN-A70130 mod
              	   RETURNING li_result,g_ruq.ruq01
               END IF  	
               IF (NOT li_result) THEN
                  LET g_ruq.ruq01=g_ruq_t.ruq01
                  NEXT FIELD ruq01
               END IF
            END IF
         END IF
         
         
      AFTER FIELD ruq02
         IF NOT cl_null(g_ruq.ruq02) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruq.ruq02 != g_ruq_t.ruq02) THEN
               SELECT COUNT(*) INTO l_n FROM ruq_file
                WHERE ruq00='1' AND ruq01=g_ruq.ruq02 AND ruqplant=g_ruq.ruqplant
                IF SQLCA.SQLCODE THEN
                   CALL cl_err('',SQLCA.SQLCODE,0)
                   NEXT FIELD ruq02 
                ELSE   
                  IF cl_null(l_n) OR l_n = 0 THEN 
                     CALL cl_err("",'art-244',0)
                     NEXT FIELD ruq02            
                  ELSE
                     CALL t262_ruq02()
                     IF NOT cl_null(g_errno) THEN 
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD ruq02
                     END IF
                  END IF
               END IF  
            END IF
         END IF          
      
      AFTER FIELD ruq03
         IF NOT cl_null(g_ruq.ruq03) THEN
            IF p_cmd='a' OR
               (p_cmd='u' AND g_ruq.ruq03!= g_ruq_t.ruq03) THEN
               IF g_ruq00='2' AND NOT cl_null(g_ruq.ruq02)  THEN
                  SELECT ruq03 INTO l_ruq03 FROM ruq_file
                   WHERE ruq00 = '1'
                     AND ruq01 = g_ruq.ruq02
                  IF g_ruq.ruq03<l_ruq03 THEN
                     CALL cl_err('','art-640',0)
                     LET g_ruq.ruq03=g_ruq_t.ruq03
                     NEXT FIELD ruq03
                  END IF
               END IF
            END IF
         END IF           
 
      AFTER FIELD ruq05
         IF NOT cl_null(g_ruq.ruq05) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_ruq.ruq05 != g_ruq_t.ruq05) THEN
               CALL t262_ruq05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ruq.ruq05,g_errno,0)
                  LET g_ruq.ruq05 = g_ruq_t.ruq05
                  DISPLAY BY NAME g_ruq.ruq05
                  NEXT FIELD ruq05
               END IF
            END IF
         END IF    
         
     #BEFORE FIELD ruq11
     #	 SELECT rtz06 INTO g_ruq.ruq11 FROM rtz_file
     #	  WHERE rtz01 = g_plant
     #	 IF NOT cl_null(g_ruq.ruq11)  THEN
     #      SELECT occ02 INTO l_occ02  FROM occ_file
     #       WHERE occ01 = g_ruq.ruq11
     #       IF l_occ02 IS NULL  THEN
     #       	  LET l_occ02 = ' '
     #       END IF 	
     #   ELSE 
     #   	  LET g_ruq.ruq11 = ' '
     #   	  LET l_occ02     = ' '    
     #   END IF	     
     #   DISPLAY BY NAME g_ruq.ruq11
     #   DISPLAY l_occ02 TO FORMONLY.ruq11_desc       
         
      AFTER FIELD ruq11
         IF NOT cl_null(g_ruq.ruq11) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_ruq.ruq11 != g_ruq_t.ruq11) THEN
               CALL t262_ruq11('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ruq.ruq11,g_errno,0)
                  LET g_ruq.ruq11 = g_ruq_t.ruq11
                  DISPLAY BY NAME g_ruq.ruq11
                  NEXT FIELD ruq11
               END IF
            END IF
         END IF             
         
      AFTER FIELD ruq12
         IF cl_null(g_ruq.ruq12) THEN
            CALL cl_err(g_ruq.ruq12,'aim-927',0)
            NEXT FIELD ruq12
         END IF	       
                  
         
         
      AFTER INPUT
         LET g_ruq.ruquser = s_get_data_owner("ruq_file") #FUN-C10039
         LET g_ruq.ruqgrup = s_get_data_group("ruq_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(g_ruq.ruq01) THEN
            NEXT FIELD ruq01
         END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(ruq01) THEN
            LET g_ruq.* = g_ruq_t.*
            CALL t262_show()
            NEXT FIELD ruq01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(ruq01)
              LET g_t1=s_get_doc_no(g_ruq.ruq01)
              IF g_ruq00 = '1' THEN 
#                CALL q_smy(FALSE,FALSE,g_t1,'ART','G') RETURNING g_t1 #FUN-A70130--mark--
                 CALL q_oay(FALSE,FALSE,g_t1,'J2','ART') RETURNING g_t1 #FUN-A70130--mod--
              ELSE
#             	 CALL q_smy(FALSE,FALSE,g_t1,'ART','H') RETURNING g_t1 #FUN-A70130--mark-- 
              	 CALL q_oay(FALSE,FALSE,g_t1,'J3','ART') RETURNING g_t1 #FUN-A70130--mod-- 
              END IF	 
              LET g_ruq.ruq01=g_t1
              DISPLAY BY NAME g_ruq.ruq01
              NEXT FIELD ruq01
           WHEN INFIELD(ruq02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ruq01"
              LET g_qryparam.default1 = g_ruq.ruq02
              LET g_qryparam.arg1 = "1"
              CALL cl_create_qry() RETURNING g_ruq.ruq02
              DISPLAY BY NAME g_ruq.ruq02
              NEXT FIELD ruq02
           WHEN INFIELD(ruq05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ruq.ruq05
              CALL cl_create_qry() RETURNING g_ruq.ruq05
              DISPLAY BY NAME g_ruq.ruq05
              CALL t262_ruq05('d')
              NEXT FIELD ruq05
           WHEN INFIELD(ruq11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.default1 = g_ruq.ruq11
              CALL cl_create_qry() RETURNING g_ruq.ruq11
              DISPLAY BY NAME g_ruq.ruq11
              CALL t262_ruq11('d')
              NEXT FIELD ruq11
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
 
FUNCTION t262_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ruq.ruq01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruq.* FROM ruq_file
    WHERE ruq01 = g_ruq.ruq01
      AND ruq00 = g_ruq00
 
   IF g_ruq.ruqacti ='N' THEN    
      CALL cl_err(g_ruq.ruq01,'9027',0)
      RETURN
   END IF
   IF g_ruq.ruqconf <>'N' THEN
      CALL cl_err(g_ruq.ruq01,'9022',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK
 
   OPEN t262_cl USING g_ruq.ruq01
   IF STATUS THEN
      CALL cl_err("OPEN t262_cl:", STATUS, 1)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t262_cl INTO g_ruq.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0)    
       CLOSE t262_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t262_show()
 
   WHILE TRUE
      LET g_ruq.ruqmodu = g_user
      LET g_ruq.ruqdate = g_today
 
      CALL t262_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruq.*=g_ruq_t.*
         CALL t262_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruq.ruq01 <> g_ruq_t.ruq01 THEN            
         UPDATE rur_file SET rur01 = g_ruq.ruq01
          WHERE rur01 = g_ruq_t.ruq01
            AND rur00 = g_ruq00
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rur_file",g_ruq_t.ruq01,"",SQLCA.sqlcode,"","rur",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ruq_file SET ruq_file.* = g_ruq.*
       WHERE ruq00 = g_ruq00
         AND ruq01 = g_ruq.ruq01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruq_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t262_cl
   COMMIT WORK
   CALL t262_show()
 
END FUNCTION
 
FUNCTION t262_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          
 
    IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ruq01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t262_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ruq01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t262_b()
DEFINE l_ac_t LIKE type_file.num5
DEFINE l_n    LIKE type_file.num5
DEFINE l_lock_sw LIKE type_file.chr1
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_flag          LIKE type_file.chr1 
DEFINE l_fac           LIKE type_file.num20_6 
DEFINE l_msg           LIKE type_file.chr1000,
       sn1             LIKE type_file.num5,
       sn2             LIKE type_file.num5
DEFINE l_imd20         LIKE imd_file.imd20
DEFINE l_imd20_1       LIKE imd_file.imd20   
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_case  STRING    #FUN-910088--add--
DEFINE l_ima906  LIKE ima_file.ima906  #FUN-C30300
             
   LET g_action_choice=""
   IF s_shut(0) THEN 
      RETURN
   END IF
        
   IF cl_null(g_ruq.ruq01) THEN
      RETURN 
   END IF
       
   SELECT * INTO g_ruq.* FROM ruq_file
    WHERE ruq01=g_ruq.ruq01
      AND ruq00=g_ruq.ruq00
        
   IF g_ruq.ruqacti='N' THEN 
      CALL cl_err(g_ruq.ruq01,'9027',0)
      RETURN 
   END IF
   IF g_ruq.ruqconf<>'N' THEN
      CALL cl_err(g_ruq.ruq01,'9022',0)
      RETURN
   END IF    
   CALL cl_opmsg('b')
        
   LET g_forupd_sql="SELECT rur02,rur03,'',rur04,'',rur05,",
                    "       rur06,'',rur07,rur08,rur09,rur10,",
                    "       rur11,rur12,rur13,rur14,rur15,",
                    "       rur16,rur17,rur18,rur19,rur20,rur21", 
                    "  FROM rur_file",
                    " WHERE rur00 = '",g_ruq00,"'",
                    "   AND rur01=? AND rur02=?",
                    "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t262_bcl CURSOR FROM g_forupd_sql
        
#TQC-A10086 ADD-----
#  IF g_ruq00 = '2' THEN
#     LET l_allow_insert = FALSE
#     LET l_allow_delete = FALSE
#  END IF
#TQC-A10086 ADD-----
   INPUT ARRAY g_rur WITHOUT DEFAULTS FROM s_rur.*
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
         OPEN t262_cl USING g_ruq.ruq01
         IF STATUS THEN
            CALL cl_err("OPEN t262_cl:",STATUS,1)
            CLOSE t262_cl
            ROLLBACK WORK
         END IF
                
         FETCH t262_cl INTO g_ruq.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0)
            CLOSE t262_cl
            ROLLBACK WORK 
            RETURN
         END IF
         IF g_rec_b>=l_ac THEN 
            LET p_cmd ='u'
            LET g_rur_t.*=g_rur[l_ac].*
            LET g_rur06_t = g_rur[l_ac].rur06      #FUN-910088--add--
            OPEN t262_bcl USING g_ruq.ruq01,g_rur_t.rur02
            CALL t262_set_entry_b()               #ADD 
            IF STATUS THEN
               CALL cl_err("OPEN t262_bcl:",STATUS,1)
               LET l_lock_sw='Y'
            ELSE
               FETCH t262_bcl INTO g_rur[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rur_t.rur03,SQLCA.sqlcode,1)
                  LET l_lock_sw="Y"
               END IF
               SELECT ima02 INTO g_rur[l_ac].rur03_desc FROM ima_file
                WHERE ima01 = g_rur[l_ac].rur03
                  AND imaacti = 'Y'
               SELECT gfe02 INTO g_rur[l_ac].rur04_desc FROM gfe_file
                WHERE gfe01 = g_rur[l_ac].rur04
                  AND gfeacti = 'Y'
               SELECT gfe02 INTO g_rur[l_ac].rur06_desc FROM gfe_file
                WHERE gfe01 = g_rur[l_ac].rur06
                  AND gfeacti = 'Y'   
               DISPLAY BY NAME g_rur[l_ac].rur03_desc,g_rur[l_ac].rur04_desc,g_rur[l_ac].rur06_desc   
            END IF
         END IF
         
      BEFORE INSERT
         LET l_n=ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_rur[l_ac].* TO NULL
         LET g_rur[l_ac].rur12=0
         LET g_rur[l_ac].rur13=0
         LET g_rur[l_ac].rur14=0
         LET g_rur[l_ac].rur15=0     #FUN-A10008 ADD
         LET g_rur[l_ac].rur19='N'
         LET g_rur_t.*=g_rur[l_ac].*
         LET g_rur06_t = NULL        #FUN-910088--add--
         CALL cl_show_fld_cont()
         CALL t262_set_entry_b()                
         NEXT FIELD rur02
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG=0
            CANCEL INSERT
         END IF
         INSERT INTO rur_file(
                rur00,rur01,rur02,rur03,rur04,rur05,rur06,rur07,
                rur08,rur09,rur10,rur11,rur12,rur13,rur14,rur15,
                rur16,rur17,rur18,rur19,rur20,rur21,rurplant,rurlegal)
         VALUES(g_ruq.ruq00,g_ruq.ruq01,g_rur[l_ac].rur02,g_rur[l_ac].rur03,
                g_rur[l_ac].rur04,g_rur[l_ac].rur05,g_rur[l_ac].rur06,
                g_rur[l_ac].rur07,g_rur[l_ac].rur08,g_rur[l_ac].rur09,
                g_rur[l_ac].rur10,g_rur[l_ac].rur11,g_rur[l_ac].rur12,
                g_rur[l_ac].rur13,g_rur[l_ac].rur14,g_rur[l_ac].rur15,
                g_rur[l_ac].rur16,g_rur[l_ac].rur17,g_rur[l_ac].rur18,
                g_rur[l_ac].rur19,g_rur[l_ac].rur20,g_rur[l_ac].rur21,
                g_ruq.ruqplant,g_ruq.ruqlegal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rur_file",g_ruq.ruq01,g_rur[l_ac].rur02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE  'INSERT O.K.'
            CALL t262_upd_log()
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
                
      BEFORE FIELD rur02
        IF cl_null(g_rur[l_ac].rur02) OR g_rur[l_ac].rur02 = 0 THEN 
           SELECT MAX(rur02)+1 INTO g_rur[l_ac].rur02 FROM rur_file
            WHERE rur01 = g_ruq.ruq01
              AND rur00 = g_ruq00
           IF g_rur[l_ac].rur02 IS NULL THEN
              LET g_rur[l_ac].rur02=1
           END IF
        END IF
         
      AFTER FIELD rur02
        IF NOT cl_null(g_rur[l_ac].rur02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                 g_rur[l_ac].rur02 <> g_rur_t.rur02) THEN
              SELECT COUNT(*) INTO l_n FROM rur_file
               WHERE rur00 = g_ruq00
                 AND rur01= g_ruq.ruq01 
                 AND rur02=g_rur[l_ac].rur02
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_rur[l_ac].rur02=g_rur_t.rur02
                 NEXT FIELD rur02
              END IF
              IF g_ruq00='2' THEN
                 CALL t262_rur02()
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_rur[l_ac].rur02=g_rur_t.rur02
                    NEXT FIELD rur02
                 END IF    
              END IF 
           END IF
         END IF
         
      BEFORE FIELD rur03
         IF g_rur[l_ac].rur05 IS NULL THEN
            CALL cl_set_comp_entry("rur03",TRUE)
         ELSE
     	    CALL cl_set_comp_entry("rur03",FALSE)
         END IF
         
      AFTER FIELD rur03
         IF NOT cl_null(g_rur[l_ac].rur03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rur[l_ac].rur03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rur[l_ac].rur03= g_rur_t.rur03
               NEXT FIELD rur03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_rur_t.rur03 IS NULL OR
               (g_rur[l_ac].rur03 != g_rur_t.rur03 ) THEN
               CALL t262_rur03()      
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rur[l_ac].rur03,g_errno,0)
                  LET g_rur[l_ac].rur03 = g_rur_t.rur03
                  DISPLAY BY NAME g_rur[l_ac].rur03
                  NEXT FIELD rur03
               ELSE  
                  IF g_rur[l_ac].rur04 IS NOT NULL AND 
                     g_rur[l_ac].rur06 IS NOT NULL THEN 
                     LET l_flag = NULL
                     LET l_fac = NULL
                     CALL s_umfchk(g_rur[l_ac].rur03,g_rur[l_ac].rur06,
                                   g_rur[l_ac].rur04)
                        RETURNING l_flag,l_fac
                     IF l_flag = 1 THEN
                        LET l_msg = g_rur[l_ac].rur06 CLIPPED,'->',
                                    g_rur[l_ac].rur04 CLIPPED
                        CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                        LET g_rur[l_ac].rur03 = g_rur_t.rur03
                        DISPLAY BY NAME g_rur[l_ac].rur03
                        NEXT FIELD rur03
                     ELSE
                        CALL t262_check_img10() 
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                        LET g_rur[l_ac].rur03 = g_rur_t.rur03
                        DISPLAY BY NAME g_rur[l_ac].rur03
                           NEXT FIELD rur03
                        ELSE
                           LET g_rur[l_ac].rur07 = l_fac
                           DISPLAY BY NAME g_rur[l_ac].rur07
                           CALL t262_rur08()
                        END IF   
                     END IF
                  END IF 
               END IF  
            END IF
        #ELSE 
        # 	DISPLAY '' TO g_rur[l_ac].rur03_desc
        # 	DISPLAY '' TO g_rur[l_ac].rur04
        #   DISPLAY '' TO g_rur[l_ac].rur04_desc 
         END IF          
         
         
        AFTER FIELD rur05
           IF NOT cl_null(g_rur[l_ac].rur05) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_rur[l_ac].rur05,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rur[l_ac].rur05= g_rur_t.rur05
                 NEXT FIELD rur05
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_rur_t.rur05 IS NULL OR 
                 (g_rur[l_ac].rur05 != g_rur_t.rur05 ) THEN
                 CALL t262_rur03()      
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rur[l_ac].rur05,g_errno,0)
                    LET g_rur[l_ac].rur05 = g_rur_t.rur05
                    LET g_rur[l_ac].rur03 = g_rur_t.rur03
                    DISPLAY BY NAME g_rur[l_ac].rur05,g_rur[l_ac].rur03
                    NEXT FIELD rur05
                 END IF
              END IF
           END IF           
         
        AFTER FIELD rur06
           IF NOT cl_null(g_rur[l_ac].rur06) THEN
              CALL t262_rur06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_rur[l_ac].rur06,g_errno,0)
                 LET g_rur[l_ac].rur06 = g_rur_t.rur06
                 DISPLAY BY NAME g_rur[l_ac].rur06
                 NEXT FIELD rur06
              ELSE
                 IF g_rur[l_ac].rur03 IS NOT NULL AND 
                    g_rur[l_ac].rur04 IS NOT NULL THEN
                    LET l_flag = NULL
                    LET l_fac = NULL
                    CALL s_umfchk(g_rur[l_ac].rur03,g_rur[l_ac].rur06,
                                  g_rur[l_ac].rur04)
                       RETURNING l_flag,l_fac
                    IF l_flag = 1 THEN
                       LET l_msg = g_rur[l_ac].rur06 CLIPPED,'->',
                                   g_rur[l_ac].rur04 CLIPPED
                       CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                       LET g_rur[l_ac].rur06 = g_rur_t.rur06
                       DISPLAY BY NAME g_rur[l_ac].rur06
                       NEXT FIELD rur06
                    ELSE
                       LET g_rur[l_ac].rur07 = l_fac 
                       DISPLAY BY NAME g_rur[l_ac].rur07
                       CALL t262_rur08()
                    END IF
                 END IF 
              END IF
        #FUN-910088--add--start--
              LET l_case = NULL
              IF NOT cl_null(g_rur[l_ac].rur12) AND g_rur[l_ac].rur12<>0 THEN  #TQC-C20183 add
                 IF NOT t262_rur12_check() THEN
                    LET l_case = "rur12"
                 END IF
              END IF
              IF g_ruq00 != '2' THEN                                                      #TQC-C20183 add
                 LET g_rur[l_ac].rur14 = s_digqty(g_rur[l_ac].rur14,g_rur[l_ac].rur06)    #TQC-C20183 add
                 DISPLAY BY NAME g_rur[l_ac].rur14                                        #TQC-C20183 add
              ELSE                                                                        #TQC-C20183 add
                 IF NOT cl_null(g_rur[l_ac].rur14) AND g_rur[l_ac].rur14<>0 THEN          #TQC-C20183 add
                    IF NOT t262_rur14_check() THEN
                       LET l_case = "rur14"
                    END IF      
                 END IF
              END IF
              LET g_rur06_t = g_rur[l_ac].rur06
              CASE l_case
                 WHEN "rur12"
                    NEXT FIELD rur12
                 WHEN "rur14"
                    NEXT FIELD rur14
                 OTHERWISE EXIT CASE
              END CASE
        #FUN-910088--add--end--
           END IF   
                 
        AFTER FIELD rur08
           IF NOT cl_null(g_rur[l_ac].rur08) THEN
              IF g_rur[l_ac].rur08<=0 THEN
                 LET g_rur[l_ac].rur08 =g_rur_t.rur08
                 CALL cl_err('','alm-466',0)
              ELSE
                IF g_ruq00='1' THEN
                   LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur12
                ELSE   
                   LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur14
                END IF
             END IF	     	
          END IF    
           
        AFTER FIELD rur09 
           IF NOT cl_null(g_rur[l_ac].rur09) THEN
              SELECT COUNT(*) INTO l_n FROM imd_file
               WHERE imd01=g_rur[l_ac].rur09 
                 AND imdacti='Y'              
              IF l_n<1 THEN
                 CALL cl_err('','aic-034',0)
                 LET g_rur[l_ac].rur09 = g_rur_t.rur09
                 DISPLAY BY NAME g_rur[l_ac].rur09
                 NEXT FIELD rur09
              END IF
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(g_rur[l_ac].rur09) THEN
                 NEXT FIELD rur09
              END IF 
              #No.FUN-AA0049--end
              IF NOT s_stkchk(g_rur[l_ac].rur09,'A') THEN
                 CALL cl_err(g_rur[l_ac].rur09,'mfg6076',0)
                 LET g_rur[l_ac].rur09 = g_rur_t.rur09
                 DISPLAY BY NAME g_rur[l_ac].rur09
                 NEXT FIELD rur09
              END IF              

              CALL s_swyn(g_rur[l_ac].rur09) RETURNING sn1,sn2
              IF sn1 != 0 THEN
                 CALL cl_err(g_rur[l_ac].rur09,'mfg6080',0)
                 LET g_rur[l_ac].rur09 = g_rur_t.rur09
                 DISPLAY BY NAME g_rur[l_ac].rur09
                 NEXT FIELD rur09
              END IF

              CALL t262_check_img10() 
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_rur[l_ac].rur09 = g_rur_t.rur09
                  DISPLAY BY NAME g_rur[l_ac].rur09
                  NEXT FIELD rur09
              END IF   

              IF NOT cl_null(g_rur[l_ac].rur16) THEN
                 SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=g_rur[l_ac].rur09 AND imd11='Y' AND imdacti='Y'
                 SELECT imd20 INTO l_imd20_1 FROM imd_file WHERE imd01=g_rur[l_ac].rur16 AND imd11='Y' AND imdacti='Y'
                 IF l_imd20<>l_imd20_1 THEN
                    CALL cl_err('','aim-943',0)
                    LET g_rur[l_ac].rur09=g_rur_t.rur09
                    DISPLAY BY NAME g_rur[l_ac].rur09
                    NEXT FIELD rur09
                 END IF
              END IF
           END IF   
 
        AFTER FIELD rur10 
           IF NOT cl_null(g_rur[l_ac].rur10) THEN  
              IF g_rur_t.rur10 IS NULL OR 
                 (g_rur[l_ac].rur10 != g_rur_t.rur10 ) THEN
                 CALL t262_check_img10() 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_rur[l_ac].rur10 = g_rur_t.rur10
                    DISPLAY BY NAME g_rur[l_ac].rur10
                    NEXT FIELD rur10
                 END IF    
              END IF
           END IF   
 
        AFTER FIELD rur11 
           IF NOT cl_null(g_rur[l_ac].rur11) THEN  
              IF g_rur_t.rur11 IS NULL OR 
                 (g_rur[l_ac].rur11 != g_rur_t.rur11 ) THEN
                 CALL t262_check_img10() 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_rur[l_ac].rur11 = g_rur_t.rur11
                    DISPLAY BY NAME g_rur[l_ac].rur11
                    NEXT FIELD rur11
                 END IF    
              END IF
           END IF              
  
 
        AFTER FIELD rur12
           IF NOT t262_rur12_check() THEN NEXT FIELD rur12 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       #   IF NOT cl_null(g_rur[l_ac].rur12) THEN
       #      IF g_rur[l_ac].rur12 <= 0 THEN
       #         CALL cl_err('','axm4011',0)    #TQC-A30055 ADD 
       #        #CALL cl_err('','agl-105',0)    #TQC-A30055 MARK
       #         LET g_rur[l_ac].rur12 = g_rur_t.rur12  
       #         DISPLAY BY NAME g_rur[l_ac].rur12               
       #         NEXT FIELD rur12
       #      ELSE
       #         CALL t262_check_img10() 
       #         IF NOT cl_null(g_errno) THEN
       #            CALL cl_err('',g_errno,0)
       #            LET g_rur[l_ac].rur12 = g_rur_t.rur12 
       #            DISPLAY BY NAME g_rur[l_ac].rur12                
       #            NEXT FIELD rur12
       #         ELSE
       #            IF g_ruq00='1' THEN
       #               LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur12 
       #            END IF
       #         END IF
       #      END IF	     	
       #   END IF
       #FUN-910088--mark--end--
          
 
  #     AFTER FIELD rur13
  #        IF NOT cl_null(g_rur[l_ac].rur13) THEN
  #           IF g_rur[l_ac].rur13 < 0 THEN
  #              CALL cl_err('','art-',0)  #305
  #              LET g_rur[l_ac].rur13 = g_rur_t.rur13 
  #              DISPLAY BY NAME g_rur[l_ac].rur13                
  #              NEXT FIELD rur13
  #           END IF
  #           IF g_rur[l_ac].rur13<>g_rur_t.rur13 THEN
  #              IF ( NOT cl_null(g_rur[l_ac].rur12)) AND 
  #                 ( NOT cl_null(g_rur[l_ac].rur14)) THEN
  #            	    IF g_rur[l_ac].rur14 > g_rur[l_ac].rur12-g_rur[l_ac].rur13 THEN
  #                    CALL cl_err('','art-',0) ##
  #                    LET g_rur[l_ac].rur13 = g_rur_t.rur13  
  #                    DISPLAY BY NAME g_rur[l_ac].rur13               
  #                    NEXT FIELD rur13
  #                 END IF   
  #              END IF    
  #           END IF 
  #        END IF  
  
        AFTER FIELD rur14
           IF NOT t262_rur14_check() THEN NEXT FIELD rur14 END IF    #FUN-910088--add--
        #FUN-910088--mark--start--
        #  IF NOT cl_null(g_rur[l_ac].rur14) THEN
        #     IF g_rur[l_ac].rur14 <= 0 THEN
        #        CALL cl_err('','axr-034',0)  
        #        LET g_rur[l_ac].rur14 = g_rur_t.rur14 
        #        DISPLAY BY NAME g_rur[l_ac].rur14                
        #        NEXT FIELD rur14
        #     ELSE 
        #        IF ( NOT cl_null(g_rur[l_ac].rur13)) AND 
        #           ( NOT cl_null(g_rur[l_ac].rur13)) THEN
        #           IF g_rur[l_ac].rur14 > g_rur[l_ac].rur12-g_rur[l_ac].rur13 THEN
        #              CALL cl_err('','art-630',0) ##
        #              LET g_rur[l_ac].rur14 = g_rur_t.rur14
        #              DISPLAY BY NAME g_rur[l_ac].rur14                 
        #              NEXT FIELD rur14
        #           END IF    
        #           IF g_rur[l_ac].rur14<>g_rur_t.rur14 THEN
        #              IF g_ruq00='2' THEN 
        #                 LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur14
        #              END IF   
        #           END IF
        #        END IF	     	
        #     END IF	     	
        #  END IF  
        #FUN-910088--mark--end--
   
         AFTER FIELD rur16
           IF NOT cl_null(g_rur[l_ac].rur16) THEN
              SELECT COUNT(*) INTO l_n FROM imd_file
               WHERE imd01=g_rur[l_ac].rur16
                 AND imdacti='Y'
                 AND imd18='4'
              IF l_n<1 THEN
                 CALL cl_err('','art-639',0)
                 LET g_rur[l_ac].rur16=g_rur_t.rur16
                 DISPLAY BY NAME g_rur[l_ac].rur16
                 NEXT FIELD rur16
              END IF
              #No.FUN-AA0049--begin
              IF NOT s_chk_ware(g_rur[l_ac].rur16) THEN
                 NEXT FIELD rur16
              END IF 
              #No.FUN-AA0049--end              
              IF NOT cl_null(g_rur[l_ac].rur09) THEN
                 SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=g_rur[l_ac].rur09 AND imd11='Y' AND imdacti='Y'
                 SELECT imd20 INTO l_imd20_1 FROM imd_file WHERE imd01=g_rur[l_ac].rur16 AND imd11='Y' AND imdacti='Y'
                 IF l_imd20<>l_imd20_1 THEN
                    CALL cl_err('','aim-943',0)
                    LET g_rur[l_ac].rur16=g_rur_t.rur16
                    DISPLAY BY NAME g_rur[l_ac].rur16
                    NEXT FIELD rur16
                 END IF
              END IF
           END IF   

        #TQC-A20039 ADD START----------------------------- 
         AFTER FIELD rur17
           IF NOT cl_null(g_rur[l_ac].rur17) THEN
              IF NOT cl_null(g_rur[l_ac].rur16) THEN
                 SELECT COUNT(*) INTO l_n FROM img_file
                  WHERE img02=g_rur[l_ac].rur16
                    AND img03=g_rur[l_ac].rur17 
                 IF l_n<1 THEN
                    CALL cl_err('','aps-715',0)
                    LET g_rur[l_ac].rur17=g_rur_t.rur17
                    DISPLAY BY NAME g_rur[l_ac].rur17
                    NEXT FIELD rur17
                 END IF
              END IF
           END IF

         AFTER FIELD rur18
           IF NOT cl_null(g_rur[l_ac].rur18) THEN
              IF NOT cl_null(g_rur[l_ac].rur16) THEN
                 SELECT COUNT(*) INTO l_n FROM img_file
                  WHERE img02=g_rur[l_ac].rur16
                    AND img04=g_rur[l_ac].rur18
                 IF l_n<1 THEN
                    CALL cl_err('','asf-401',0)
                    LET g_rur[l_ac].rur18=g_rur_t.rur18
                    DISPLAY BY NAME g_rur[l_ac].rur18
                    NEXT FIELD rur18
                 END IF
              END IF
           END IF 	
        #TQC-A20039 ADD END--------------------------------

         AFTER FIELD rur20
           IF NOT cl_null(g_rur[l_ac].rur20) THEN
              IF p_cmd = "a" OR
                 (p_cmd = "u" AND g_rur[l_ac].rur20 != g_rur_t.rur20) THEN
                 SELECT count(*) INTO l_n FROM azf_file
                  WHERE azf01=g_rur[l_ac].rur20 AND azf09='6'
                    AND azf02='2'  AND azfacti='Y'
                 IF l_n<1 THEN
                    CALL cl_err(g_rur[l_ac].rur20,'1306',0)
                    LET g_rur[l_ac].rur20 = g_rur_t.rur20
                    DISPLAY BY NAME g_rur[l_ac].rur20
                    NEXT FIELD rur20
                 END IF
              END IF    
           END IF   
     	
          	  
  
      BEFORE DELETE                      
           IF g_rur_t.rur02 > 0 AND NOT cl_null(g_rur_t.rur02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rur_file
               WHERE rur01 = g_ruq.ruq01
                 AND rur02 = g_rur_t.rur02
                 AND rur00 = g_ruq00
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rur_file",g_ruq.ruq01,g_rur_t.rur02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 CALL t262_upd_log()
                 COMMIT WORK
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rur[l_ac].* = g_rur_t.*
              CLOSE t262_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rur[l_ac].rur02,-263,1)
              LET g_rur[l_ac].* = g_rur_t.*
           ELSE
              #TQC-A20039 ADD-------------------------------
              IF cl_null(g_rur[l_ac].rur10) THEN
                 LET g_rur[l_ac].rur10=' '
              END IF
              IF cl_null(g_rur[l_ac].rur11) THEN
                 LET g_rur[l_ac].rur11=' '
              END IF
              IF cl_null(g_rur[l_ac].rur17) THEN
                 LET g_rur[l_ac].rur17=' '
              END IF
              IF cl_null(g_rur[l_ac].rur18) THEN
                 LET g_rur[l_ac].rur18=' '
              END IF
              #TQC-A20039 ADD END---------------------------
              UPDATE rur_file SET rur02=g_rur[l_ac].rur02,
                                  rur03=g_rur[l_ac].rur03,
                                  rur04=g_rur[l_ac].rur04,
                                  rur05=g_rur[l_ac].rur05,
                                  rur06=g_rur[l_ac].rur06,
                                  rur07=g_rur[l_ac].rur07,
                                  rur08=g_rur[l_ac].rur08,
                                  rur09=g_rur[l_ac].rur09,
                                  rur10=g_rur[l_ac].rur10,
                                  rur11=g_rur[l_ac].rur11,
                                  rur12=g_rur[l_ac].rur12,
                                  rur13=g_rur[l_ac].rur13,
                                  rur14=g_rur[l_ac].rur14,
                                  rur15=g_rur[l_ac].rur15,
                                  rur16=g_rur[l_ac].rur16,
                                  rur17=g_rur[l_ac].rur17,
                                  rur18=g_rur[l_ac].rur18,
                                  rur19=g_rur[l_ac].rur19,
                                  rur20=g_rur[l_ac].rur20,
                                  rur21=g_rur[l_ac].rur21
               WHERE rur00=g_ruq00
                 AND rur01=g_ruq.ruq01
                 AND rur02=g_rur_t.rur02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rur_file",g_ruq.ruq01,g_rur_t.rur02,SQLCA.sqlcode,"","",1) 
                 LET g_rur[l_ac].* = g_rur_t.*
              ELSE
                 CALL t262_upd_log()
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
                 LET g_rur[l_ac].* = g_rur_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rur.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t262_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t262_bcl
           COMMIT WORK
           
       ON ACTION CONTROLO                        
           IF INFIELD(rur02) AND l_ac > 1 THEN
              LET g_rur[l_ac].* = g_rur[l_ac-1].*
              LET g_rur[l_ac].rur02 = g_rec_b + 1
              NEXT FIELD rur02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rur03)                     
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               #No.FUN-A10047--begin
#               SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruq.ruqplant
#               IF cl_null(l_rtz04) THEN
#                  LET g_qryparam.form = "q_ima"
#               ELSE
#                  LET g_qryparam.form ="q_rte03_1"       
#                  LET g_qryparam.arg1 = l_rtz04
#               END IF               
#               #No.FUN-A10047--end  
#               LET g_qryparam.default1 = g_rur[l_ac].rur03
#               CALL cl_create_qry() RETURNING g_rur[l_ac].rur03
                CALL q_sel_ima(FALSE, "q_ima","",g_rur[l_ac].rur03,"","","","","",'' ) 
                 RETURNING  g_rur[l_ac].rur03

#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_rur[l_ac].rur03
               CALL t262_rur03()
               NEXT FIELD rur03
            WHEN INFIELD(rur02)                     
            IF g_ruq00='2' THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rur02"   
               LET g_qryparam.arg1 = g_ruq.ruq02
               LET g_qryparam.default1 = g_rur[l_ac].rur02
               CALL cl_create_qry() RETURNING g_rur[l_ac].rur02
               DISPLAY BY NAME g_rur[l_ac].rur02 
               CALL t262_rur02()
               NEXT FIELD rur02
            END IF    
            WHEN INFIELD(rur06)                     
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_gfe"   
               #LET g_qryparam.form="q_smd1"    #TQC-AC0223 mark
               LET g_qryparam.form = "q_gfe"    #TQC-AC0223 add
               LET g_qryparam.arg1 = g_rur[l_ac].rur03
               LET g_qryparam.arg2 = g_rur[l_ac].rur04
               LET g_qryparam.default1 = g_rur[l_ac].rur06
               CALL cl_create_qry() RETURNING g_rur[l_ac].rur06
               DISPLAY BY NAME g_rur[l_ac].rur06 
               CALL t262_rur06()
               NEXT FIELD rur06    
               
             WHEN INFIELD(rur09) OR INFIELD(rur10) OR INFIELD(rur11) 
                #FUN-C30300---begin
                LET l_ima906 = NULL
                SELECT ima906 INTO l_ima906 FROM ima_file
                 WHERE ima01 = g_rur[l_ac].rur03
                #IF s_industry("icd") AND l_ima906='3' THEN  #TQC-C60028
                IF s_industry("icd") THEN  #TQC-C60028
                   CALL q_idc(FALSE,TRUE,g_rur[l_ac].rur03,g_rur[l_ac].rur09,     
                                   g_rur[l_ac].rur10,g_rur[l_ac].rur11)
                   RETURNING g_rur[l_ac].rur09,g_rur[l_ac].rur10,g_rur[l_ac].rur11
                ELSE
                #FUN-C30300---end
                   CALL q_img4(FALSE,TRUE,g_rur[l_ac].rur03,g_rur[l_ac].rur09,     
                                   g_rur[l_ac].rur10,g_rur[l_ac].rur11,'A')
                      RETURNING    g_rur[l_ac].rur09,
                                   g_rur[l_ac].rur10,g_rur[l_ac].rur11
                END IF #FUN-C30300
                   DISPLAY BY NAME g_rur[l_ac].rur09 
                   DISPLAY BY NAME g_rur[l_ac].rur10  
                   DISPLAY BY NAME g_rur[l_ac].rur11 
                   IF cl_null(g_rur[l_ac].rur10) THEN LET g_rur[l_ac].rur10 = ' ' END IF
                   IF cl_null(g_rur[l_ac].rur11) THEN LET g_rur[l_ac].rur11 = ' ' END IF
                   IF INFIELD(rur09) THEN NEXT FIELD rur09 END IF
                   IF INFIELD(rur10) THEN NEXT FIELD rur10 END IF
                   IF INFIELD(rur11) THEN NEXT FIELD rur11 END IF

               WHEN INFIELD(rur16) #TQC-A20046 ADD
                    #No.FUN-AA0049--begin
                    #CALL cl_init_qry_var() 
                    #LET g_qryparam.form     = "q_imd1_1"      
                    #LET g_qryparam.default1 = g_rur[l_ac].rur16 
                    #CALL cl_create_qry() RETURNING g_rur[l_ac].rur16                     
                    CALL q_imd_1(FALSE,TRUE,g_rur[l_ac].rur16,"","",""," imd18='4' ") RETURNING g_rur[l_ac].rur16
                    #No.FUN-AA0049--end
                    DISPLAY BY NAME g_rur[l_ac].rur16   
                    NEXT FIELD rur16 

                WHEN INFIELD(rur16) OR INFIELD(rur17) OR INFIELD(rur18)
                   #FUN-C30300---begin
                   LET l_ima906 = NULL
                   SELECT ima906 INTO l_ima906 FROM ima_file
                    WHERE ima01 = g_rur[l_ac].rur03
                   #IF s_industry("icd") AND l_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_rur[l_ac].rur03,g_rur[l_ac].rur16,
                                   g_rur[l_ac].rur17,g_rur[l_ac].rur18)
                      RETURNING g_rur[l_ac].rur16,g_rur[l_ac].rur17,g_rur[l_ac].rur18
                   ELSE
                   #FUN-C30300---end
                   CALL q_img4(FALSE,FALSE,g_rur[l_ac].rur03,g_rur[l_ac].rur16,
                                   g_rur[l_ac].rur17,g_rur[l_ac].rur18,'A')
                      RETURNING    g_rur[l_ac].rur16,
                                   g_rur[l_ac].rur17,g_rur[l_ac].rur18 
                   END IF #FUN-C30300
                   DISPLAY BY NAME g_rur[l_ac].rur16  
                   DISPLAY BY NAME g_rur[l_ac].rur17  
                   DISPLAY BY NAME g_rur[l_ac].rur18  
                   IF cl_null(g_rur[l_ac].rur17) THEN LET g_rur[l_ac].rur17 = ' ' END IF
                   IF cl_null(g_rur[l_ac].rur18) THEN LET g_rur[l_ac].rur18 = ' ' END IF
                   IF INFIELD(rur16) THEN NEXT FIELD rur16 END IF
                   IF INFIELD(rur17) THEN NEXT FIELD rur17 END IF
                   IF INFIELD(rur18) THEN NEXT FIELD rur18 END IF
               WHEN INFIELD(rur20) 
                    CALL cl_init_qry_var() 
                    LET g_qryparam.form     = "q_azf01a"      
                    LET g_qryparam.default1 = g_rur[l_ac].rur20 
                    LET g_qryparam.arg1     = "6"          
                    CALL cl_create_qry() RETURNING g_rur[l_ac].rur20 
                    DISPLAY BY NAME g_rur[l_ac].rur20   
                    NEXT FIELD rur20 
                             
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
  
    CLOSE t262_bcl
    COMMIT WORK
#   CALL t262_delall() #CHI-C30002 mark
    CALL t262_delHeader()     #CHI-C30002 add
    CALL t262_show()
END FUNCTION                
 
 
FUNCTION t262_rur03()
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_rtyacti     LIKE rty_file.rtyacti
DEFINE l_rtz04       LIKE rtz_file.rtz04
DEFINE l_rte07       LIKE rte_file.rte07
DEFINE l_rtaacti     LIKE rta_file.rtaacti
DEFINE l_rty06_1     LIKE rty_file.rty06
DEFINE l_rty06_2     LIKE rty_file.rty06
    
    LET g_errno = ""
    
    IF NOT cl_null(g_rur[l_ac].rur05) THEN 
       SELECT rta01,rtaacti INTO g_rur[l_ac].rur03,l_rtaacti
          FROM rta_file WHERE rta05 = g_rur[l_ac].rur05
          
       CASE WHEN SQLCA.SQLCODE = 100  
                               LET g_errno = 'art-298'
                               RETURN
            WHEN l_rtaacti='N' LET g_errno = '9028'
                               RETURN
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE          
    END IF 
    
    SELECT ima02,ima25,imaacti
        INTO g_rur[l_ac].rur03_desc,g_rur[l_ac].rur04,l_imaacti
        FROM ima_file WHERE ima01 = g_rur[l_ac].rur03
 
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-037'
                            RETURN
         WHEN l_imaacti='N' LET g_errno = '9028'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
    SELECT gfe02,gfeacti INTO g_rur[l_ac].rur04_desc,l_gfeacti 
       FROM gfe_file WHERE gfe01 = g_rur[l_ac].rur04
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
          AND rte03 = g_rur[l_ac].rur03
       IF SQLCA.SQLCODE = 100 THEN
          LET g_errno = 'art-296'
          RETURN
       END IF 
       IF l_rte07 = 'N' OR l_rte07 IS NULL THEN
          LET g_errno = 'art-297'
          RETURN
       END IF
    END IF 
                                                                                             
        

    DISPLAY g_rur[l_ac].rur03_desc,g_rur[l_ac].rur04,
            g_rur[l_ac].rur04_desc 
END FUNCTION 
  
 
FUNCTION t262_upd_log()
    LET g_ruq.ruqmodu = g_user
    LET g_ruq.ruqdate = g_today
    UPDATE ruq_file SET ruqmodu = g_ruq.ruqmodu,ruqdate = g_ruq.ruqdate
     WHERE ruq01 = g_ruq.ruq01
       AND ruq00 = g_ruq00
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","ruq_file",g_ruq.ruqmodu,g_ruq.ruqdate,SQLCA.sqlcode,"","",1)
    END IF
    DISPLAY BY NAME g_ruq.ruqmodu,g_ruq.ruqdate
    MESSAGE 'UPDATE O.K.'
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t262_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   SELECT COUNT(*) INTO g_cnt FROM rur_file
    WHERE rur01 = g_ruq.ruq01
      AND rur00 = g_ruq00

   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruq.ruq01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruq_file ",
                  "  WHERE ruq01 LIKE '",l_slip,"%' ",
                  "    AND ruq01 > '",g_ruq.ruq01,"'"
      PREPARE t262_pb2 FROM l_sql 
      EXECUTE t262_pb2 INTO l_cnt
      
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
         CALL t262_v(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruq_file WHERE ruq01 = g_ruq.ruq01 AND ruq00 = g_ruq00
         INITIALIZE g_ruq.* TO NULL
         LET g_ruq00 = NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t262_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rur_file
#   WHERE rur01 = g_ruq.ruq01
#     AND rur00 = g_ruq00
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ruq_file WHERE ruq01 = g_ruq.ruq01 AND ruq00 = g_ruq00
#     CLEAR FORM
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t262_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ruq.ruq01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruq.* FROM ruq_file
    WHERE ruq01=g_ruq.ruq01
      AND ruq00=g_ruq00
   IF g_ruq.ruqacti ='N' THEN    
      CALL cl_err(g_ruq.ruq01,'abm-033',0)
      RETURN
   END IF
   IF g_ruq.ruqconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t262_cl USING g_ruq.ruq01
   IF STATUS THEN
      CALL cl_err("OPEN t262_cl:", STATUS, 1)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t262_cl INTO g_ruq.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t262_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruq01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruq.ruq01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM ruq_file WHERE ruq01 = g_ruq.ruq01 AND ruq00 = g_ruq00
      DELETE FROM rur_file WHERE rur01 = g_ruq.ruq01 AND rur00 = g_ruq00
      CLEAR FORM
      CALL g_rur.clear()
      OPEN t262_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t262_cs
          CLOSE t262_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      FETCH t262_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t262_cs
          CLOSE t262_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t262_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t262_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t262_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t262_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t262_copy()
DEFINE l_newno     LIKE ruq_file.ruq01,
       l_oldno     LIKE ruq_file.ruq01,
       l_cnt       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_ruq.ruq01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t262_set_entry('a')
   LET l_oldno = g_ruq.ruq01    #FUN-A10008 ADD 
   CALL cl_set_head_visible("","YES")       
   CALL cl_set_docno_format("ruq01")    #TQC-A30060 ADD
   INPUT l_newno FROM ruq01
      AFTER FIELD ruq01
         IF l_newno IS NULL THEN               
            NEXT FIELD ruq01
         ELSE 
            IF g_ruq00 = '1' THEN          	                           
#              CALL s_check_no("art",l_newno,"","G","ruq_file","ruq00,ruq01","") #FUN-A70130 mark
               CALL s_check_no("art",l_newno,"","J2","ruq_file","ruq00,ruq01","") #FUN-A70130 mod
               RETURNING li_result,l_newno     
            ELSE
#              CALL s_check_no("art",l_newno,"","H","ruq_file","ruq00,ruq01","") #FUN-A70130 mark
               CALL s_check_no("art",l_newno,"","J3","ruq_file","ruq00,ruq01","") #FUN-A70130 mod
               RETURNING li_result,l_newno        
            END IF                	                                  
            IF (NOT li_result) THEN                                                 
               NEXT FIELD ruq01                                              
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
 
     ON ACTION controlp
          CASE
             WHEN INFIELD(ruq01)                        
                LET g_t1=s_get_doc_no(l_newno)
                LET g_qryparam.state = 'i' 
                LET g_qryparam.plant = g_plant
                IF g_ruq00 = '1' THEN 
#                  CALL q_smy(FALSE,FALSE,g_t1,'ART','G') RETURNING g_t1  #FUN-A70130--mark--
                   CALL q_oay(FALSE,FALSE,g_t1,'J2','ART') RETURNING g_t1 #FUN-A70130--mod--
                ELSE
#              	   CALL q_smy(FALSE,FALSE,g_t1,'ART','H') RETURNING g_t1  #FUN-A70130--mark--
              	   CALL q_oay(FALSE,FALSE,g_t1,'J3','ART') RETURNING g_t1 #FUN-A70130--mod-- 
                END IF	 
                LET l_newno=g_t1
                DISPLAY l_newno TO ruq01            
                NEXT FIELD ruq01
              OTHERWISE EXIT CASE
           END CASE
 
   END INPUT
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_ruq.ruq01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
    SELECT * FROM ruq_file         
     WHERE ruq01=l_oldno     #g_ruq.ruq01
       AND ruqplant = g_ruq.ruqplant
       AND ruq00 = g_ruq00

     INTO TEMP y
   IF g_ruq00 = '1'  THEN
     #CALL s_auto_assign_no("art",g_ruq.ruq01,g_today,"G","ruq_file","ruq01","","","")   #FUN-A10008 MARK
#     CALL s_auto_assign_no("art",l_newno,g_today,"G","ruq_file","ruq00,ruq01","","","")  #FUN-A10008 ADD #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_newno,g_today,"J2","ruq_file","ruq00,ruq01","","","")  #FUN-A10008 ADD #FUN-A70130 mod
      RETURNING li_result,l_newno
   ELSE
     #CALL s_auto_assign_no("art",g_ruq.ruq01,g_today,"H","ruq_file","ruq01","","","")   #FUN-A10008 MARK
#     CALL s_auto_assign_no("art",l_newno,g_today,"H","ruq_file","ruq00,ruq01","","","")  #FUN-A10008 ADD #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_newno,g_today,"J3","ruq_file","ruq00,ruq01","","","")  #FUN-A10008 ADD #FUN-A70130 mod
     RETURNING li_result,l_newno  
   END IF        
   IF (NOT li_result) THEN
       RETURN
   END IF
   DISPLAY l_newno to ruq01
   UPDATE y
       SET ruq00=g_ruq00,
           ruq01=l_newno,    
           ruq04=' ',
           ruq12='N',
           ruquser=g_user,   
           ruqgrup=g_grup,   
           ruqmodu=NULL,     
           ruqdate=NULL,  
           ruqacti='Y', 
           ruqplant=g_plant,
           ruqlegal=g_legal,
           ruqcrat=g_today,
           ruqorig=g_grup,
           ruqoriu=g_user,
           ruqconu=NULL,
           ruqconf='N',
           ruqcond=NULL    
 
   INSERT INTO ruq_file SELECT * FROM y 
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruq_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rur_file         
       WHERE rur01=l_oldno   #g_ruq.ruq01
         AND rur00=g_ruq00 
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rur01=l_newno
               ,rur19='N'
               ,rurplant=g_plant
               ,rurlegal=g_legal
 
   INSERT INTO rur_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK              # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rur_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK               # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
  #LET l_oldno = g_ruq.ruq01
   SELECT ruq_file.* INTO g_ruq.* FROM ruq_file WHERE ruq01 = l_newno AND ruq00=g_ruq00
   CALL t262_u()
   CALL t262_m_b()
   #SELECT ruq_file.* INTO g_ruq.* FROM ruq_file WHERE ruq01 = l_oldno AND ruq00=g_ruq00 #FUN-C80046
   #CALL t262_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t262_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ruq.ruq01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t262_cl USING g_ruq.ruq01
   IF STATUS THEN
      CALL cl_err("OPEN t262_cl:", STATUS, 1)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t262_cl INTO g_ruq.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   IF g_ruq.ruqconf<>'N' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF
   LET g_success = 'Y'
 
   CALL t262_show()
 
   IF cl_exp(0,0,g_ruq.ruqacti) THEN                   
      LET g_chr=g_ruq.ruqacti
      IF g_ruq.ruqacti='Y' THEN
         LET g_ruq.ruqacti='N'
      ELSE
         LET g_ruq.ruqacti='Y'
      END IF
      UPDATE ruq_file SET ruqacti=g_ruq.ruqacti,
                          ruqmodu=g_user,
                          ruqdate=g_today
       WHERE ruq01=g_ruq.ruq01
         AND ruq00=g_ruq00
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"",SQLCA.sqlcode,"","",1)  
         LET g_ruq.ruqacti=g_chr
      END IF
   END IF
 
   CLOSE t262_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ruqacti,ruqmodu,ruqdate
     INTO g_ruq.ruqacti,g_ruq.ruqmodu,g_ruq.ruqdate FROM ruq_file
    WHERE ruq01=g_ruq.ruq01
      AND ruq00=g_ruq00
   DISPLAY BY NAME g_ruq.ruqacti,g_ruq.ruqmodu,g_ruq.ruqdate
  #TQC-A30002 ADD-----------------------------
   IF g_ruq.ruqacti='Y' THEN
      CALL cl_set_field_pic("","","","","","Y")
   ELSE
      CALL cl_set_field_pic("","","","","","N")
   END IF
  #TQC-A30002 END-----------------------------
 
END FUNCTION
 
FUNCTION t262_bp_refresh()
 
  DISPLAY ARRAY g_rur TO s_rur.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION t262_y()
DEFINE l_rur13  LIKE rur_file.rur13
DEFINE l_gen02  LIKE gen_file.gen02
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azp02  LIKE azp_file.azp02
DEFINE i        LIKE type_file.num5   #FUN-A10008 
DEFINE l_sql    STRING
DEFINE l_rur02  LIKE rur_file.rur02  
DEFINE l_rur03  LIKE rur_file.rur03
DEFINE l_rur09  LIKE rur_file.rur09
DEFINE l_rur12  LIKE rur_file.rur12
DEFINE l_rur14  LIKE rur_file.rur14
DEFINE l_rur16  LIKE rur_file.rur16  #No.FUN-AB0067
   IF cl_null(g_ruq.ruq01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
 
#CHI-C30107 -------------- add --------------- begin
   IF g_ruq.ruqconf <> 'N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF

   IF g_ruq.ruqacti='N' THEN
      CALL cl_err('','atm-364',0)
      RETURN
   END IF
   IF NOT cl_upsw(0,0,g_ruq.ruqconf) THEN RETURN END IF
   SELECT * INTO g_ruq.* FROM ruq_file WHERE ruq01 = g_ruq.ruq01
#CHI-C30107 --------------- add --------------- end
   IF g_ruq.ruqconf <> 'N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF

   IF g_ruq.ruqacti='N' THEN
      CALL cl_err('','atm-364',0)
      RETURN
   END IF

  #IF g_sma.sma894[1,1]<>'Y' THEN
  #   CALL cl_err('','art-572',1)
  #   RETURN
  #END IF	  

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rur_file
    WHERE rur01=g_ruq.ruq01 
      AND rur00=g_ruq00
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#No.FUN-AB0067--begin    
   LET g_success='Y' 
   CALL s_showmsg_init()   
   DECLARE t262_chk_ware CURSOR FOR SELECT rur09,rur16 FROM rur_file
                                   WHERE rur01=g_ruq.ruq01 AND rur00=g_ruq00
   FOREACH t262_chk_ware INTO l_rur09,l_rur16           
      IF NOT s_chk_ware(l_rur09) THEN
         LET g_success='N' 
      END IF 
      IF NOT s_chk_ware(l_rur16) THEN
         LET g_success='N' 
      END IF       
   END FOREACH 
   CALL s_showmsg()
   LET g_bgerr=0 
   IF g_success='N' THEN 
      RETURN 
   END IF    
#No.FUN-AB0067--end
#TQC-A10086 ADD-----------------------------------------------------
   IF g_ruq00= '2' THEN
      LET l_sql = "SELECT rur02,rur03,rur09,rur12,rup14 FROM rur_file WHERE rur01 = '",
                  g_ruq.ruq01,"' AND rur00 = '",g_ruq00,"'"
      PREPARE t262_rurx FROM l_sql
      DECLARE rur_csx CURSOR FOR t262_rurx
      FOREACH rur_csx INTO l_rur02,l_rur03,l_rur09,l_rur12,l_rur14
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         SELECT rur13 INTO l_rur13 FROM rur_file
          WHERE rur00= '1'
            AND rur01= g_ruq.ruq02
            AND rur02= l_rur02
         IF l_rur14 > l_rur12-l_rur13 THEN
            CALL cl_err(l_rur03,'art-630',1)
            RETURN
         END IF
      END FOREACH
   END IF
#TQC-A10086 ADD----------------------------------------------------------

   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t262_cl USING g_ruq.ruq01
   IF STATUS THEN
      CALL cl_err("OPEN t60_cl:", STATUS, 1)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t262_cl INTO g_ruq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_ruq_t.* = g_ruq.*
#  IF cl_upsw(0,0,g_ruq.ruqconf) THEN  #CHI-C30107 mark
      LET g_ruq.ruqconf='Y'
      LET g_ruq.ruqconu = g_user
      LET g_ruq.ruqcond = g_today
      LET g_ruq.ruqmodu = g_user
      LET g_ruq.ruqdate = g_today
      UPDATE ruq_file SET ruqconf = g_ruq.ruqconf,
                          ruqconu = g_ruq.ruqconu,
                          ruqcond = g_ruq.ruqcond,
                          ruqmodu = g_ruq.ruqconu,
                          ruqdate = g_ruq.ruqdate
       WHERE ruq01 = g_ruq.ruq01
         AND ruq00 = g_ruq00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"",STATUS,"","",1)
         LET g_ruq.ruqconf=g_ruq_t.ruqconf
         LET g_ruq.ruqconu=g_ruq_t.ruqconu
         LET g_ruq.ruqcond=g_ruq_t.ruqcond
         LET g_success = 'N'
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"","9050","","",1)
            LET g_ruq.ruqconf=g_ruq_t.ruqconf
            LET g_ruq.ruqconu=g_ruq_t.ruqconu
            LET g_ruq.ruqcond=g_ruq_t.ruqcond
            LET g_success = 'N'
         END IF
      END IF
   
      IF g_ruq00='2' THEN 
         FOR i=1 TO g_rur.getlength()
            UPDATE rur_file 
               SET rur13 = rur13 + g_rur[i].rur14
             WHERE rur00 = '1'
               AND rur01 = g_ruq.ruq02
               AND rur02 = g_rur[i].rur02
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
               CALL cl_err3("upd","rur_file",g_ruq.ruq01,"",STATUS,"","",1) 
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            END IF 
            UPDATE rur_file
               SET rur13 = rur13 + g_rur[i].rur14
             WHERE rur00 = '2'
               AND rur01 = g_ruq.ruq01
               AND rur02 = g_rur[i].rur02
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
               CALL cl_err3("upd","rur_file",g_ruq.ruq01,"",STATUS,"","",1)
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            END IF
            UPDATE rur_file SET rur19 = 'Y'
             WHERE rur01 = g_ruq.ruq02
               AND rur00 = '1'
               AND rur12 = rur13
               AND rur02 = g_rur[i].rur02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rur_file",g_ruq.ruq02,"",STATUS,"","",1)
               LET g_success = 'N'
               ROLLBACK WORK
               RETURN
            END IF
            UPDATE rur_file SET rur19 = 'Y'
             WHERE rur01 = g_ruq.ruq01
               AND rur00 = g_ruq00
               AND rur12 = rur13
               AND rur02 = g_rur[i].rur02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rur_file",g_ruq.ruq01,"",STATUS,"","",1)
               LET g_success = 'N'
               ROLLBACK WORK
               RETURN
            END IF
         END FOR
      END IF 
# END IF              #CHI-C30107 mark
    
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_ruq.ruqconu
         AND genacti = 'Y'

      DISPLAY l_gen02 TO ruqconu_desc
      DISPLAY BY NAME g_ruq.ruqconf,g_ruq.ruqconu,g_ruq.ruqcond,
                      g_ruq.ruquser,g_ruq.ruqdate
      IF g_ruq.ruqconf='Y' THEN      	
        CALL cl_set_field_pic("Y","","","","","")
      ELSE
        CALL cl_set_field_pic("N","","","","","")
      END IF
      CALL t262_b_fill(g_wc2)
      CALL t262_bp_refresh()
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

#TQC-A10086 ADD START------------------------------ 
FUNCTION t262_n()
DEFINE l_rur13  LIKE rur_file.rur13
DEFINE l_gen02  LIKE gen_file.gen02
DEFINE l_azp02  LIKE azp_file.azp02
DEFINE i        LIKE type_file.num5    
DEFINE l_n      LIKE type_file.num5  

   IF cl_null(g_ruq.ruq01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_ruq.ruqconf<>'Y' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   
   IF g_ruq.ruq12='Y' THEN
      CALL cl_err('','art-631',0)
      RETURN             
   END IF

   IF g_ruq00 = '1' THEN
      SELECT COUNT(*) INTO l_n FROM ruq_file
       WHERE ruq00 = '2'
         AND ruq02 = g_ruq.ruq01
      IF l_n<>0 THEN 
      	 CALL cl_err('','art-625',1) 
      	 RETURN 
      END IF
      SELECT COUNT(*) INTO l_n FROM rxr_file
       WHERE rxr00 = '1' 
         AND rxr02 = g_ruq.ruq01
         AND rxracti='Y'
         AND rxrconf<>'X'
      IF l_n<>0 THEN 
      	 CALL cl_err('','art-624',1) 
      	 RETURN 
      END IF
   ELSE
      SELECT COUNT(*) INTO l_n FROM rxr_file
       WHERE rxr00 = '2' 
         AND rxr02 = g_ruq.ruq01
         AND rxracti='Y'
         AND rxrconf<>'X'
      IF l_n<>0 THEN 
      	 CALL cl_err('','art-624',1) 
      	 RETURN 
      END IF
   END IF
         	             	 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t262_cl USING g_ruq.ruq01
   IF STATUS THEN
      CALL cl_err("OPEN t60_cl:", STATUS, 1)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t262_cl INTO g_ruq.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_ruq_t.* = g_ruq.*
   IF cl_upsw(0,0,g_ruq.ruqconf) THEN 
      LET g_ruq.ruqconf='N'
     #CHI-D20015 Mark&Add Str
     #LET g_ruq.ruqconu = ''
     #LET g_ruq.ruqcond = ''
      LET g_ruq.ruqconu = g_user
      LET g_ruq.ruqcond = g_today
     #CHI-D20015 Mark&Add End
      LET g_ruq.ruqmodu = g_user
      LET g_ruq.ruqdate = g_today
      UPDATE ruq_file SET ruqconf = g_ruq.ruqconf,
                          ruqconu = g_ruq.ruqconu,
                          ruqcond = g_ruq.ruqcond,
                          ruqmodu = g_ruq.ruqconu,
                          ruqdate = g_ruq.ruqdate
       WHERE ruq01 = g_ruq.ruq01
         AND ruq00 = g_ruq00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"",STATUS,"","",1)
         LET g_ruq.ruqconf=g_ruq_t.ruqconf
         LET g_ruq.ruqconu=g_ruq_t.ruqconu
         LET g_ruq.ruqcond=g_ruq_t.ruqcond
         LET g_success = 'N'
         RETURN  
      ELSE
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"","9050","","",1)
            LET g_ruq.ruqconf=g_ruq_t.ruqconf
            LET g_ruq.ruqconu=g_ruq_t.ruqconu
            LET g_ruq.ruqcond=g_ruq_t.ruqcond
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   
      IF g_ruq00='2' THEN 
         FOR i=1 TO g_rur.getlength()
            UPDATE rur_file 
               SET rur13 = rur13 - g_rur[i].rur14 , rur19 ='N'
             WHERE rur00 = '1'
               AND rur01 = g_ruq.ruq02
               AND rur02 = g_rur[i].rur02
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
               CALL cl_err3("upd","rur_file",g_ruq.ruq01,"",STATUS,"","",1) 
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            END IF 
            UPDATE rur_file
               SET rur13 = rur13 - g_rur[i].rur14 , rur19 ='N'
             WHERE rur00 = '2'
               AND rur01 = g_ruq.ruq01
               AND rur02 = g_rur[i].rur02
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
               CALL cl_err3("upd","rur_file",g_ruq.ruq01,"",STATUS,"","",1)
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            END IF

         END FOR
      END IF 
   END IF              
    
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_ruq.ruqconu
         AND genacti = 'Y'

      DISPLAY l_gen02 TO ruqconu_desc
      DISPLAY BY NAME g_ruq.ruqconf,g_ruq.ruqconu,g_ruq.ruqcond,
                      g_ruq.ruquser,g_ruq.ruqdate
      IF g_ruq.ruqconf='Y' THEN      	
        CALL cl_set_field_pic("Y","","","","","")
      ELSE
        CALL cl_set_field_pic("N","","","","","")
      END IF
      CALL t262_b_fill(g_wc2)
      CALL t262_bp_refresh()
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#TQC-A10086 ADD END------------------------------  
 
FUNCTION t262_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废  
DEFINE l_n LIKE type_file.num5
 
   IF cl_null(g_ruq.ruq01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ruq.ruqconf='X' THEN RETURN END IF
    ELSE
       IF g_ruq.ruqconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   
   IF g_ruq.ruqacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_ruq.ruqconf = 'Y' THEN
#      CALL cl_err('','apy-705',0)   #CHI-B40058
      CALL cl_err('','apc-122',0)    #CHI-B40058
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t262_cl USING g_ruq.ruq01
   IF STATUS THEN
      CALL cl_err("OPEN t262_cl:", STATUS, 1)
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t262_cl INTO g_ruq.*    
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   END IF
    LET g_ruq_t.* = g_ruq.*      
    IF cl_void(0,0,g_ruq.ruqconf) THEN
       IF g_ruq.ruqconf='X' THEN
         LET g_ruq.ruqconf='N'
         LET g_ruq.ruqconu = ''
         LET g_ruq.ruqcond = ''
       ELSE
         LET g_ruq.ruqconf='X'
         LET g_ruq.ruqconu = g_user
         LET g_ruq.ruqcond = g_today
       END IF 
       LET g_ruq.ruqmodu = g_user
       LET g_ruq.ruqdate = g_today
       UPDATE ruq_file SET ruqconf = g_ruq.ruqconf,
                           ruqconu = g_ruq.ruqconu,
                           ruqcond = g_ruq.ruqcond,
                           ruqmodu = g_ruq.ruqmodu,
                           ruqdate = g_ruq.ruqdate
        WHERE ruq01 = g_ruq.ruq01 
          AND ruq00 = g_ruq00
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"",STATUS,"","",1) 
          LET g_ruq.ruqconf=g_ruq_t.ruqconf
          LET g_ruq.ruqconu=g_ruq_t.ruqconu
          LET g_ruq.ruqcond=g_ruq_t.ruqcond
          LET g_success = 'N'
       ELSE
          IF SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("upd","ruq_file",g_ruq.ruq01,"","9050","","",1) 
             LET g_ruq.ruqconf=g_ruq_t.ruqconf
             LET g_ruq.ruqconu=g_ruq_t.ruqconu
             LET g_ruq.ruqcond=g_ruq_t.ruqcond
             LET g_success = 'N'            
          END IF
       END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      DISPLAY BY NAME g_ruq.ruqconf,g_ruq.ruqconu,g_ruq.ruqcond,
                      g_ruq.ruquser,g_ruq.ruqdate
      IF g_ruq.ruqconf='X' THEN
        CALL cl_set_field_pic("","","","",'Y',"")
      ELSE
        CALL cl_set_field_pic("","","","",'N',"")
      END IF
   ELSE
      ROLLBACK WORK
   END IF   
END FUNCTION
 
 
FUNCTION t262_ruq05(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_genacti LIKE gen_file.genacti
DEFINE l_gen02 LIKE gen_file.gen02

   LET g_errno=''
   SELECT gen02,genacti 
     INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_ruq.ruq05
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='aoo-017'
        WHEN l_genacti='N'     LET g_errno='9028'
        OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO ruq05_desc
    END IF
END FUNCTION
 
 
FUNCTION t262_ruq11(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1000,
       l_occacti       LIKE occ_file.occacti,
       l_occ02         LIKE occ_file.occ02

    LET g_errno = ' '
    SELECT occ02,occacti INTO l_occ02,l_occacti
        FROM occ_file
      WHERE occ01 = g_ruq.ruq11
    CASE 
        WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'anm-045'
                            LET l_occ02 = NULL
         WHEN l_occacti='N' LET g_errno = '9028'
                            LET l_occ02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    DISPLAY BY NAME g_ruq.ruq11
    DISPLAY l_occ02 TO FORMONLY.ruq11_desc
    END CASE

END FUNCTION 
 

 
FUNCTION t262_m_b()
   
   IF g_action_choice="detail" OR g_action_choice="insert" THEN
      LET l_allow_insert=cl_detail_input_auth("insert")
      LET l_allow_delete=cl_detail_input_auth("delete")
     # CALL cl_set_comp_entry("rur02,rur03,rur09",TRUE)
     # CALL cl_set_comp_entry("rur13",FALSE)
   ELSE
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   #   CALL cl_set_comp_entry("rur02,rur03,rur09",FALSE)
   #   CALL cl_set_comp_entry("rur13",TRUE)
   END IF
   CALL t262_b()
END FUNCTION
 

FUNCTION t262_p()
   DEFINE l_cnt    LIKE type_file.num10 
   DEFINE l_sql    LIKE type_file.chr1000 
   DEFINE l_rur12  LIKE rur_file.rur12
   DEFINE l_rur19  LIKE rur_file.rur19
   DEFINE l_rur03  LIKE rur_file.rur03
   DEFINE l_qcs01  LIKE qcs_file.qcs01
   DEFINE l_qcs02  LIKE qcs_file.qcs02
   DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
   
   IF s_shut(0) THEN RETURN END IF

   SELECT * INTO g_ruq.* FROM ruq_file
    WHERE ruq01 = g_ruq.ruq01
      AND ruq00 = g_ruq00 

   IF g_ruq.ruq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_ruq.ruqconf <> 'Y' THEN 
      CALL cl_err('','aba-100',0)
      RETURN
   END IF

   IF g_ruq.ruq12 = 'Y' THEN
      CALL cl_err('','asf-812',0) 
      RETURN
   END IF
   

   IF g_sma.sma53 IS NOT NULL AND g_ruq.ruq03 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF

   CALL s_yp(g_ruq.ruq03) RETURNING g_yy,g_mm
   IF g_yy > g_sma.sma51 THEN    
      CALL cl_err(g_yy,'mfg6090',0)
      RETURN
   ELSE
      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
         CALL cl_err(g_mm,'mfg6091',0)
         RETURN
      END IF
   END IF

   SELECT COUNT(*) INTO l_cnt
     FROM rur_file
    WHERE rur01 = g_ruq.ruq01 
      AND rur00 = g_ruq00

   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
   #TQC-A30055 ADD--------------------  
   IF NOT cl_confirm('mfg0176') THEN
      RETURN
   END IF
   #TQC-A30055 END-------------------

   IF g_ruq00 ='1' THEN 
      LET l_sql = "SELECT rur12,rur19,rur03,rur01,rur02 FROM rur_file",
                  " WHERE rur01= '",g_ruq.ruq01,"' AND rur00= '",g_ruq00,"'"
      PREPARE t262_curs1 FROM l_sql
      DECLARE t262_pre1 CURSOR FOR t262_curs1
   
      FOREACH t262_pre1 INTO l_rur12,l_rur19,l_rur03,l_qcs01,l_qcs02
         IF l_rur19='Y' THEN
            LET l_qcs091=0
            SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
             WHERE qcs01 = l_qcs01
               AND qcs02 = l_qcs02
               AND qcs14 = 'Y'
   
            IF cl_null(l_qcs091) THEN
               LET l_qcs091 = 0
            END IF
   
            IF l_qcs091 < l_rur12 THEN
               CALL cl_err(l_rur03,'aim1003',1)
               RETURN
               END IF
         END IF
      END FOREACH
   END IF

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   
   DECLARE t262_s1_c1 CURSOR FOR SELECT * FROM rur_file 
                                  WHERE rur00=g_ruq00 
                                    AND rur01=g_ruq.ruq01

   FOREACH t262_s1_c1 INTO b_rur.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = b_rur.rur03
         AND img02 = b_rur.rur09
         AND img03 = b_rur.rur10
         AND img04 = b_rur.rur11
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(b_rur.rur03,b_rur.rur09,b_rur.rur10,b_rur.rur11,g_ruq.ruq01,b_rur.rur02,g_ruq.ruq03,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(b_rur.rur03,b_rur.rur09,b_rur.rur10,b_rur.rur11,g_ruq.ruq01,b_rur.rur02,g_ruq.ruq03) #FUN-CC0095
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
               #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
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
   
   DECLARE t262_s1_c CURSOR FOR
     SELECT * FROM rur_file WHERE rur00=g_ruq00 AND rur01=g_ruq.ruq01 

   BEGIN WORK

   OPEN t262_cl USING g_ruq.ruq01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0) 
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t262_cl INTO g_ruq.*      
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0) 
         CLOSE t262_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   
   CALL s_showmsg_init() 

   FOREACH t262_s1_c INTO b_rur.*
      IF STATUS THEN EXIT FOREACH END IF

      LET g_cmd= 's_ read parts:',b_rur.rur03
      CALL cl_msg(g_cmd)
      
      IF cl_null(b_rur.rur09) THEN CONTINUE FOREACH END IF
   
      SELECT *
        FROM img_file WHERE img01=b_rur.rur03 AND
                            img02=b_rur.rur09 AND
                            img03=b_rur.rur10 AND
                            img04=b_rur.rur11
      IF SQLCA.sqlcode THEN
            CALL s_add_img(b_rur.rur03,b_rur.rur09,
                           b_rur.rur10,b_rur.rur11,
                           g_ruq.ruq01,b_rur.rur02,
                           g_today)
      END IF
      
      IF t262_t('Y',b_rur.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH   
      END IF
 
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg() 
  
   UPDATE ruq_file SET ruq12 = 'Y'
    WHERE ruq01 = g_ruq.ruq01 AND ruq00=g_ruq00

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ruq01',g_ruq.ruq01,'up ruq_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruq.ruq01,'S')
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF

   SELECT ruq12 INTO g_ruq.ruq12 
     FROM ruq_file 
    WHERE ruq01 = g_ruq.ruq01  
      AND ruq00 = g_ruq00

   DISPLAY BY NAME g_ruq.ruq12

   
   IF g_ruq.ruqconf='X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_ruq.ruqconf,"",g_ruq.ruq12,"",g_void,"")   

END FUNCTION

FUNCTION t262_rp()
   DEFINE l_cnt    LIKE type_file.num10 
   DEFINE l_sql    LIKE type_file.chr1000 
   DEFINE l_rur14  LIKE rur_file.rur12
   DEFINE l_rur19  LIKE rur_file.rur19
   DEFINE l_rur03  LIKE rur_file.rur03
   DEFINE l_qcs01  LIKE qcs_file.qcs01
   DEFINE l_qcs02  LIKE qcs_file.qcs02
   IF s_shut(0) THEN RETURN END IF

   SELECT * INTO g_ruq.* FROM ruq_file
    WHERE ruq01 = g_ruq.ruq01
      AND ruq00 = g_ruq00 

   IF g_ruq.ruq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

  #IF g_ruq.ruqconf <> 'Y' THEN 
  #   CALL cl_err('','aba-100',0)
  #   RETURN
  #END IF

   IF g_ruq.ruq12 = 'N' THEN
      CALL cl_err('','art-635',0) 
      RETURN
   END IF
  
   IF g_sma.sma53 IS NOT NULL AND g_ruq.ruq03 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF

   #FUN-BC0062 ---------Begin--------
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-936',1)
      RETURN
   END IF
   #FUN-BC0062 ---------End----------
   CALL s_yp(g_ruq.ruq03) RETURNING g_yy,g_mm
   IF g_yy > g_sma.sma51 THEN    
      CALL cl_err(g_yy,'mfg6090',0)
      RETURN
   ELSE
      IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
         CALL cl_err(g_mm,'mfg6091',0)
         RETURN
      END IF
   END IF

   SELECT COUNT(*) INTO l_cnt
     FROM rur_file
    WHERE rur01 = g_ruq.ruq01 
      AND rur00 = g_ruq00

   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF g_ruq00 ='2' THEN 
      LET l_sql = "SELECT rur14,rur19,rur03,rur01,rur02 FROM rur_file",
                  " WHERE rur01= '",g_ruq.ruq01,"' AND rur00= '",g_ruq00,"'"
      PREPARE t262_curs2 FROM l_sql
      DECLARE t262_pre2 CURSOR FOR t262_curs2
   
      FOREACH t262_pre2 INTO l_rur14,l_rur19,l_rur03,l_qcs01,l_qcs02
         IF l_rur19='Y' THEN
            LET l_qcs091=0
            SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
             WHERE qcs01 = l_qcs01
               AND qcs02 = l_qcs02
               AND qcs14 = 'Y'
   
            IF cl_null(l_qcs091) THEN
               LET l_qcs091 = 0
            END IF
   
            IF l_qcs091 < l_rur14 THEN
               CALL cl_err(l_rur03,'aim1003',1)
               RETURN
               END IF
         END IF
      END FOREACH
   END IF

   DECLARE t262_s2_c CURSOR FOR
     SELECT * FROM rur_file WHERE rur00=g_ruq00 AND rur01=g_ruq.ruq01 

   BEGIN WORK

   OPEN t262_cl USING g_ruq.ruq01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0) 
      CLOSE t262_cl
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH t262_cl INTO g_ruq.*      
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_ruq.ruq01,SQLCA.sqlcode,0) 
         CLOSE t262_cl
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   
   CALL s_showmsg_init() 

   FOREACH t262_s2_c INTO b_rur.*
      IF STATUS THEN EXIT FOREACH END IF

      LET g_cmd= 's_ read parts:',b_rur.rur03
      CALL cl_msg(g_cmd)
      
      IF cl_null(b_rur.rur09) THEN CONTINUE FOREACH END IF
   
      SELECT *
        FROM img_file WHERE img01=b_rur.rur03 AND
                            img02=b_rur.rur09 AND
                            img03=b_rur.rur10 AND
                            img04=b_rur.rur11
      IF SQLCA.sqlcode THEN
            CALL s_add_img(b_rur.rur03,b_rur.rur09,
                           b_rur.rur10,b_rur.rur11,
                           g_ruq.ruq01,b_rur.rur02,
                           g_today)
      END IF
      
      IF t262_t('N',b_rur.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH   
      END IF
 
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg() 
  
   UPDATE ruq_file SET ruq12 = 'N'
    WHERE ruq01 = g_ruq.ruq01 AND ruq00=g_ruq00

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ruq01',g_ruq.ruq01,'up ruq_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

  #TQC-A30002 ADD-----------------------------------------------------------------
   MESSAGE "DELETE FROM TLF_FILE!"
   DELETE FROM tlf_file
    WHERE tlf026 = g_ruq.ruq01        #異動單號
      AND tlf13 = g_prog             #程序代號
      AND tlf020= g_ruq.ruqplant     #營運中心
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("del","tlf_file",g_ruq.ruq01,"",SQLCA.SQLCODE,"","del_tlf",1)
      LET g_success = 'N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('del tlf:','axm-176',1)
      LET g_success = 'N'
      RETURN
   END IF
  #TQC-A30002 END----------------------------------------------------------------

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruq.ruq01,'S')
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF

   SELECT ruq12 INTO g_ruq.ruq12 
     FROM ruq_file 
    WHERE ruq01 = g_ruq.ruq01  
      AND ruq00 = g_ruq00

   DISPLAY BY NAME g_ruq.ruq12

   
   IF g_ruq.ruqconf='X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_ruq.ruqconf,"",g_ruq.ruq12,"",g_void,"")   

END FUNCTION

FUNCTION t262_t(p_kind,p_rur)
DEFINE p_kind   LIKE type_file.chr1  #Y--posting,N--undo_post 
DEFINE
    p_rur   RECORD LIKE rur_file.*,
    l_img   RECORD
            img16      LIKE img_file.img16,
            img23      LIKE img_file.img23,
            img24      LIKE img_file.img24,
            img09      LIKE img_file.img09,
            img21      LIKE img_file.img21
            END RECORD,
    l_qty   LIKE img_file.img10

    CALL cl_msg("update img_file ...")
    IF cl_null(p_rur.rur10) THEN LET p_rur.rur10=' ' END IF
    IF cl_null(p_rur.rur11) THEN LET p_rur.rur11=' ' END IF

    LET g_forupd_sql =
        "SELECT img16,img23,img24,img09,img21,img26,img10 FROM img_file ",
        " WHERE img01= ? AND img02=  ? AND img03= ? AND img04=  ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING p_rur.rur03,p_rur.rur09,p_rur.rur10,p_rur.rur11
    IF SQLCA.sqlcode THEN
       CALL cl_err("img_lock fail:", STATUS, 1)   
       LET g_success = 'N'
       RETURN 1
    ELSE
       FETCH img_lock INTO l_img.*,g_debit,g_img10
       IF SQLCA.sqlcode THEN
          CALL cl_err("sel img_file", STATUS, 1)    
          LET g_success = 'N'
          RETURN 1
       END IF
    END IF
    IF g_ruq00 = '1' THEN 
       IF p_kind ='Y' THEN
          CALL s_upimg(p_rur.rur03,p_rur.rur09,p_rur.rur10,p_rur.rur11,-1,p_rur.rur12,g_ruq.ruq03,    
               '','','','',p_rur.rur01,p_rur.rur02,'','','','','','','','','','','','')   
       ELSE
          CALL s_upimg(p_rur.rur03,p_rur.rur09,p_rur.rur10,p_rur.rur11,1,p_rur.rur12,g_ruq.ruq03,    
               '','','','',p_rur.rur01,p_rur.rur02,'','','','','','','','','','','','')   
       END IF
    ELSE
       IF p_kind ='Y' THEN
          CALL s_upimg(p_rur.rur03,p_rur.rur09,p_rur.rur10,p_rur.rur11,1,p_rur.rur14,g_ruq.ruq03,
               '','','','',p_rur.rur01,p_rur.rur02,'','','','','','','','','','','','')
       ELSE
          CALL s_upimg(p_rur.rur03,p_rur.rur09,p_rur.rur10,p_rur.rur11,-1,p_rur.rur14,g_ruq.ruq03,
               '','','','',p_rur.rur01,p_rur.rur02,'','','','','','','','','','','','')
       END IF
    END IF
    IF g_success = 'N' THEN 
       RETURN 1 
    ELSE
       IF p_kind='Y' THEN
          CALL t262_upd_tlf(1,0,p_rur.*)
       END IF
    END IF
 
    CALL cl_msg("update ima_file ...")

    LET g_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql

    OPEN ima_lock USING p_rur.rur03
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF

    FETCH ima_lock INTO g_ima25  
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF 
    IF g_ruq00 = '1' THEN
       LET l_qty=p_rur.rur12 * l_img.img21
       IF cl_null(l_qty)  THEN RETURN 1 END IF
       IF s_udima(p_rur.rur03,l_img.img23,             
                  l_img.img24,l_qty,             
                  l_img.img16, -1)           
        THEN RETURN 1
       END IF
    ELSE
       LET l_qty=p_rur.rur14 * l_img.img21
       IF cl_null(l_qty)  THEN RETURN 1 END IF
       IF s_udima(p_rur.rur03,l_img.img23,             
                  l_img.img24,l_qty,             
                  l_img.img16, 1)           
        THEN RETURN 1
       END IF
    END IF
    IF g_success = 'N' THEN RETURN 1 END IF
 
    CLOSE img_lock
 
        RETURN 0
END FUNCTION
 

FUNCTION t262_upd_tlf(p_stdc,p_reason,p_rur)
DEFINE
    p_stdc          LIKE type_file.num5,      
    p_reason        LIKE type_file.num5,     
    p_rur           RECORD LIKE rur_file.* 
DEFINE
    l_img09         LIKE img_file.img09,
    l_factor        LIKE ima_file.ima31_fac,  
    l_qty           LIKE img_file.img10

    LET l_qty=0
    SELECT img09 INTO l_img09 FROM img_file
       WHERE img01=p_rur.rur03 AND img02=p_rur.rur09
         AND img03=p_rur.rur10 AND img04=p_rur.rur11
    CALL s_umfchk(p_rur.rur03,p_rur.rur06,l_img09) RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       CALL cl_err('','mfg3075',1)
       LET g_success = 'N'
       RETURN 1
    END IF
    IF g_ruq00='1' THEN
          LET l_qty = p_rur.rur12 * l_factor
    ELSE
       LET l_qty = p_rur.rur14 * l_factor
      #LET l_qty = -1 * l_qty                  #FUN-D30019 MARK
    END IF
    LET g_tlf.tlf01=p_rur.rur03                 
   #FUN-D30019--MARK--STR---
   #LET g_tlf.tlf02=50   
   #LET g_tlf.tlf020=p_rur.rurplant           
   #LET g_tlf.tlf021=p_rur.rur09          
   #LET g_tlf.tlf022=p_rur.rur10             
   #LET g_tlf.tlf023=p_rur.rur11           
   #LET g_tlf.tlf024=g_img10 - l_qty    
   #LET g_tlf.tlf025=p_rur.rur04              
   #LET g_tlf.tlf026=p_rur.rur01            
   #LET g_tlf.tlf027=p_rur.rur02               

   #LET g_tlf.tlf03=20                     
   #LET g_tlf.tlf030=p_rur.rurplant               
   #LET g_tlf.tlf031=p_rur.rur16             
   #LET g_tlf.tlf032=p_rur.rur17            
   #LET g_tlf.tlf033=p_rur.rur18           
   #LET g_tlf.tlf034=l_qty            #g_img10 + l_qty    
   #LET g_tlf.tlf035=p_rur.rur06          
   #LET g_tlf.tlf036=p_rur.rur01             
   #LET g_tlf.tlf037=p_rur.rur02 
   #FUN-D30019--MARK--END---            

   #FUN-D30019--ADD--STR---
    IF g_ruq00='1' THEN
       LET g_tlf.tlf02=50
       LET g_tlf.tlf020=p_rur.rurplant
       LET g_tlf.tlf021=p_rur.rur09
       LET g_tlf.tlf022=p_rur.rur10
       LET g_tlf.tlf023=p_rur.rur11
       LET g_tlf.tlf024=g_img10 - l_qty
       LET g_tlf.tlf025=p_rur.rur04
       LET g_tlf.tlf026=p_rur.rur01
       LET g_tlf.tlf027=p_rur.rur02
       LET g_tlf.tlf03 =91
       LET g_tlf.tlf036=p_rur.rur01
    ELSE
       LET g_tlf.tlf03 =50
       LET g_tlf.tlf030=p_rur.rurplant
       LET g_tlf.tlf031=p_rur.rur09
       LET g_tlf.tlf032=p_rur.rur10
       LET g_tlf.tlf033=p_rur.rur11
       LET g_tlf.tlf034=g_img10 + l_qty
       LET g_tlf.tlf035=p_rur.rur04
       LET g_tlf.tlf036=p_rur.rur01
       LET g_tlf.tlf037=p_rur.rur02
       LET g_tlf.tlf02 =91
       LET g_tlf.tlf026=p_rur.rur01
    END IF
   #FUN-D30019--ADD--END---

    IF g_ruq00='1' THEN
       LET g_tlf.tlf10=p_rur.rur12   
       LET g_tlf.tlf11=p_rur.rur06         
       LET g_tlf.tlf12=p_rur.rur07                           
       LET g_tlf.tlf930="" 
       LET g_tlf.tlf907=-1   #add
    ELSE               
       LET g_tlf.tlf10=p_rur.rur14    
       LET g_tlf.tlf11=p_rur.rur06         
       LET g_tlf.tlf12=p_rur.rur07                   
       LET g_tlf.tlf930=''
       LET g_tlf.tlf907=1    #add
    END IF
    
    LET g_tlf.tlf04=' '                          
    LET g_tlf.tlf05=' '                         
    LET g_tlf.tlf06=g_ruq.ruq03                 
    LET g_tlf.tlf07=g_today                      
    LET g_tlf.tlf08=TIME                        
    LET g_tlf.tlf09=g_user                       
    LET g_tlf.tlf13=g_prog                  
    LET g_tlf.tlf14=' '             
    LET g_tlf.tlf15=' '                     
    LET g_tlf.tlf16=' '                     
    LET g_tlf.tlf17=p_rur.rur21                 #remark
    CALL s_imaQOH(p_rur.rur03)
         RETURNING g_tlf.tlf18                   
    LET g_tlf.tlf19=  g_ruq.ruq11 
    LET g_tlf.tlf20= ' '           
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION

 
FUNCTION t262_check_img10()
DEFINE l_img10     LIKE img_file.img10
 
    LET g_errno = ''
    IF cl_null(g_rur[l_ac].rur03) OR cl_null(g_rur[l_ac].rur09)
       OR cl_null(g_rur[l_ac].rur12) THEN
       RETURN
    END IF

     IF cl_null(g_rur[l_ac].rur10) THEN
        LET g_rur[l_ac].rur10 = ' '
     END IF
 
     IF cl_null(g_rur[l_ac].rur11) THEN
        LET g_rur[l_ac].rur11 = ' '
     END IF 
 
 
    SELECT SUM(img10) INTO l_img10 FROM img_file
         WHERE img01 = g_rur[l_ac].rur03
           AND img02 = g_rur[l_ac].rur09
           AND img03 = g_rur[l_ac].rur10
           AND img04 = g_rur[l_ac].rur11
           AND img18 > g_today
    IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
 
    IF l_img10 < g_rur[l_ac].rur12 THEN
       LET g_errno = 'art-475'
    END IF
END FUNCTION


FUNCTION t262_rur06()
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_smcacti     LIKE smc_file.smcacti
 
    LET g_errno = ""
    
    SELECT gfe02,gfeacti INTO g_rur[l_ac].rur06_desc ,l_gfeacti 
       FROM gfe_file
     WHERE gfe01 = g_rur[l_ac].rur06  
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'afa-319'
                            RETURN
         WHEN l_gfeacti='N' LET g_errno = 'art-061'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     
END FUNCTION


FUNCTION t262_rur08()
   DEFINE l_occ930      LIKE occ_file.occ930
   DEFINE l_res         LIKE type_file.num5    #TRUE&FALSE
   DEFINE l_price       LIKE rur_file.rur08   #FUN-B60067 ADD
   
   IF cl_null(g_rur[l_ac].rur03) OR cl_null(g_rur[l_ac].rur06) THEN
      RETURN
   END IF 
   SELECT occ930 INTO l_occ930 FROM occ_file
    WHERE occ01=g_ruq.ruq11

   IF cl_null(l_occ930) THEN        #外部客戶取價
#      CALL s_fetch_price_A2(g_rur[l_ac].rur03,g_rur[l_ac].rur06,g_ruq.ruqplant) 
#      CALL s_fetch_price_A2(g_rur[l_ac].rur03,g_rur[l_ac].rur06,g_ruq.ruqplant,g_aza.aza17)     #TQC-B30149 add   #FUN-B60067 MARK
       CALL s_fetch_price_A2(g_ruq.ruq01,'4',g_rur[l_ac].rur03,g_rur[l_ac].rur06,g_ruq.ruqplant,g_aza.aza17,'','') #FUN-B60067 ADD
           RETURNING g_rur[l_ac].rur08,l_price
   ELSE                             #內部客戶取價  
      CALL s_trade_price(g_ruq.ruqplant,l_occ930,l_occ930,g_rur[l_ac].rur03,g_rur[l_ac].rur06)
           RETURNING l_res,g_rur[l_ac].rur08
   END IF
   IF cl_null(g_rur[l_ac].rur08) OR g_rur[l_ac].rur08<=0 THEN
      CALL cl_set_comp_entry("rur08",TRUE)
   ELSE
      IF g_ruq00='1' THEN      #金額計算
         LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur12
      ELSE   
         LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur14
      END IF
   END IF     

END FUNCTION



#FUNCTION t262_rur08(p_cmd)
#  DEFINE l_occacti     LIKE occ_file.occacti
#  DEFINE l_occ44       LIKE occ_file.occ44 
#  DEFINE l_occ42       LIKE occ_file.occ42
#  DEFINE l_occ45       LIKE occ_file.occ45
#  DEFINE p_cmd         LIKE type_file.chr1 
#
#   LET g_errno = ""
#   
#   SELECT occ44,occ42,occ45,occacti INTO l_occ44,l_occ42,l_occ45,l_occacti 
#      FROM occ_file
#    WHERE occ01 = g_ruq.ruq11  
#   CASE WHEN SQLCA.SQLCODE = 100  
#                           LET g_errno = 'art-613'
#                           RETURN
#        WHEN l_occacti='N' LET g_errno = 'art-613'
#                           RETURN
#        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE
#   CALL s_fetch_price_new(g_ruq.ruq11,g_rur[l_ac].rur03,g_rur[l_ac].rur04,g_today,'2',
#                          g_ruq.ruqplant,l_occ42,l_occ44,l_occ45,g_ruq.ruq01, g_rur[l_ac].rur02,
#                          g_rur[l_ac].rur12,"",p_cmd)
#                RETURNING g_rur[l_ac].rur08
#   IF cl_null(g_rur[l_ac].rur08) OR g_rur[l_ac].rur08=0 THEN
#      CALL cl_set_comp_entry("rur08",TRUE)
#   END IF
#   DISPLAY BY NAME g_rur[l_ac].rur08	 
#END FUNCTION

#TQC-A10086 ADD-------------------
FUNCTION t262_ruq02()
   DEFINE l_ruqacti   LIKE ruq_file.ruqacti
   DEFINE l_ruqconf   LIKE ruq_file.ruqconf
   DEFINE l_occ02     LIKE occ_file.occ02
   DEFINE l_gen02     LIKE gen_file.gen02

   LET g_errno = ' ' 
   
   SELECT ruq05,ruq06,ruq07,ruq08,ruq09,ruq10,ruq11,ruqacti,ruqconf
     INTO g_ruq.ruq05,g_ruq.ruq06,g_ruq.ruq07,g_ruq.ruq08,g_ruq.ruq09,
          g_ruq.ruq10,g_ruq.ruq11,l_ruqacti,l_ruqconf
     FROM ruq_file
    WHERE ruq00='1'
      AND ruq01=g_ruq.ruq02 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'mfg9329'
                           RETURN
        WHEN l_ruqacti='N' LET g_errno = 'aap-084'
                           RETURN
        WHEN l_ruqconf<>'Y' LET g_errno = 'aap-084'
                           RETURN
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT gen02 INTO l_gen02 
        FROM gen_file
       WHERE gen01=g_ruq.ruq05 AND genacti='Y'
      DISPLAY l_gen02 TO ruq05_desc
 
      SELECT occ02 INTO l_occ02 
        FROM occ_file
       WHERE occ01=g_ruq.ruq11 AND occacti='Y'
      DISPLAY l_occ02 TO ruq11_desc

      DISPLAY BY NAME g_ruq.ruq05,g_ruq.ruq06,g_ruq.ruq07,g_ruq.ruq08,g_ruq.ruq09,
                      g_ruq.ruq10,g_ruq.ruq11   
   END IF
END FUNCTION

FUNCTION t262_rur02()
DEFINE l_n       LIKE type_file.num5
DEFINE l_rur14   LIKE rur_file.rur14
  
     LET g_errno=''
     SELECT COUNT(*) INTO l_n FROM rur_file
      WHERE rur00='1'
        AND rur01=g_ruq.ruq02
        AND rur02=g_rur[l_ac].rur02
     IF l_n=0 THEN
        LET g_errno = 'art-649'
        RETURN
     END IF
      
     SELECT COUNT(*) INTO l_n FROM rur_file
      WHERE rur00='1'
        AND rur01=g_ruq.ruq02
        AND rur02=g_rur[l_ac].rur02
        AND rur19='Y'
     IF l_n=1 THEN
        LET g_errno = 'axm-202'
        RETURN
     END IF

     SELECT rur03,rur04,rur05,rur06,rur07,rur08,rur09,rur10,rur11,
            rur12,rur13,rur14,rur16,rur17,rur18,rur20
       INTO g_rur[l_ac].rur03,g_rur[l_ac].rur04,g_rur[l_ac].rur05,
            g_rur[l_ac].rur06,g_rur[l_ac].rur07,g_rur[l_ac].rur08,
            g_rur[l_ac].rur09,g_rur[l_ac].rur10,g_rur[l_ac].rur11,
            g_rur[l_ac].rur12,g_rur[l_ac].rur13,g_rur[l_ac].rur14,
            g_rur[l_ac].rur16,g_rur[l_ac].rur17,g_rur[l_ac].rur18,
            g_rur[l_ac].rur20
       FROM rur_file
      WHERE rur00 = '1'
        AND rur01 = g_ruq.ruq02
        AND rur02 = g_rur[l_ac].rur02
    #IF 
    #LET
    SELECT ima02 INTO g_rur[l_ac].rur03_desc
      FROM ima_file WHERE ima01=g_rur[l_ac].rur03
    SELECT gfe02 INTO g_rur[l_ac].rur04_desc
      FROM gfe_file WHERE gfe01=g_rur[l_ac].rur04
    SELECT gfe02 INTO g_rur[l_ac].rur06_desc
      FROM gfe_file WHERE gfe01=g_rur[l_ac].rur06
 
    DISPLAY BY NAME g_rur[l_ac].rur03,g_rur[l_ac].rur04,g_rur[l_ac].rur05,
                    g_rur[l_ac].rur06,g_rur[l_ac].rur07,g_rur[l_ac].rur08,
                    g_rur[l_ac].rur09,g_rur[l_ac].rur10,g_rur[l_ac].rur11,
                    g_rur[l_ac].rur12,g_rur[l_ac].rur13,g_rur[l_ac].rur14,
                    g_rur[l_ac].rur16,g_rur[l_ac].rur17,g_rur[l_ac].rur18,
                    g_rur[l_ac].rur20, g_rur[l_ac].rur03_desc,
                    g_rur[l_ac].rur04_desc,g_rur[l_ac].rur06_desc

END FUNCTION


FUNCTION t262_set_entry_b()
   CALL cl_set_comp_entry("rur13,rur08,rur15",FALSE)   
   IF g_ruq00 = '2' THEN
      CALL cl_set_comp_entry("rur02,rur14,rur20,rur21",TRUE)
      CALL cl_set_comp_entry("rur03,rur04,rur05,rur06,rur07,
                              rur08,rur09,rur10,rur11,rur12,
                              rur16,rur17,rur18,rur19",FALSE)
   END IF
END FUNCTION

#TQC-A10086 ADD------------------

#FUN-9B0025
#TQC-A20023 PASS NO.
#TQC-A20024 PASS NO.

#FUN-910088--add--start--
FUNCTION t262_rur12_check()
   IF NOT cl_null(g_rur[l_ac].rur12) AND NOT cl_null(g_rur[l_ac].rur06) THEN
      IF cl_null(g_rur06_t) OR cl_null(g_rur_t.rur12) OR g_rur06_t != g_rur[l_ac].rur06 OR g_rur_t.rur12 != g_rur[l_ac].rur12 THEN
         LET g_rur[l_ac].rur12 = s_digqty(g_rur[l_ac].rur12,g_rur[l_ac].rur06)   
         DISPLAY BY NAME g_rur[l_ac].rur12
      END IF
   END IF
   IF NOT cl_null(g_rur[l_ac].rur12) THEN
      IF g_rur[l_ac].rur12 <= 0 THEN
         CALL cl_err('','axm4011',0)     
         LET g_rur[l_ac].rur12 = g_rur_t.rur12  
         DISPLAY BY NAME g_rur[l_ac].rur12               
         RETURN FALSE    
      ELSE
         CALL t262_check_img10() 
         IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            LET g_rur[l_ac].rur12 = g_rur_t.rur12 
            DISPLAY BY NAME g_rur[l_ac].rur12                
            RETURN FALSE     
         ELSE
            IF g_ruq00='1' THEN
               LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur12 
            END IF
         END IF
      END IF	     	
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t262_rur14_check()
   IF NOT cl_null(g_rur[l_ac].rur14) AND NOT cl_null(g_rur[l_ac].rur06) THEN
      IF cl_null(g_rur06_t) OR cl_null(g_rur_t.rur14) OR g_rur06_t != g_rur[l_ac].rur06 OR g_rur_t.rur14 != g_rur[l_ac].rur14 THEN
         LET g_rur[l_ac].rur14 = s_digqty(g_rur[l_ac].rur14,g_rur[l_ac].rur06)
         DISPLAY BY NAME g_rur[l_ac].rur14
      END IF
   END IF
   IF NOT cl_null(g_rur[l_ac].rur14) THEN
      IF g_rur[l_ac].rur14 <= 0 THEN
         CALL cl_err('','axr-034',0)  
         LET g_rur[l_ac].rur14 = g_rur_t.rur14 
         DISPLAY BY NAME g_rur[l_ac].rur14                
         RETURN FALSE
      ELSE 
         IF ( NOT cl_null(g_rur[l_ac].rur13)) AND 
            ( NOT cl_null(g_rur[l_ac].rur13)) THEN
            IF g_rur[l_ac].rur14 > g_rur[l_ac].rur12-g_rur[l_ac].rur13 THEN
               CALL cl_err('','art-630',0) ##
               LET g_rur[l_ac].rur14 = g_rur_t.rur14
               DISPLAY BY NAME g_rur[l_ac].rur14                 
               RETURN FALSE
            END IF    
            IF g_rur[l_ac].rur14<>g_rur_t.rur14 THEN
               IF g_ruq00='2' THEN 
                  LET g_rur[l_ac].rur15=g_rur[l_ac].rur08*g_rur[l_ac].rur14
               END IF   
            END IF
         END IF	     	
      END IF	     	
   END IF  
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

