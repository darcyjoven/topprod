# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi700.4gl  
# Descriptions...: 程序自動執行設置作業
# Date & Author..: NO.FUN-C80092 12/09/03 By lixh1
# Modify.........: No.TQC-CC0113 12/12/24 By xianghui 將action的位置移動到DISPLAY中
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_gga           RECORD LIKE gga_file.*,
       g_gga_t         RECORD LIKE gga_file.*,
       g_gga_o         RECORD LIKE gga_file.*,
       b_ggb           RECORD LIKE ggb_file.*
DEFINE g_ggb           DYNAMIC ARRAY OF RECORD    #程式變數 
           ggb02           LIKE ggb_file.ggb02,
           ggb03           LIKE ggb_file.ggb03,  
           gaz03           LIKE type_file.chr100, 
           ggb04           LIKE ggb_file.ggb04,
           ggb05           LIKE ggb_file.ggb05, 
           ggb06           LIKE ggb_file.ggb06,
           ggb07           LIKE ggb_file.ggb07, 
           ggbacti         LIKE ggb_file.ggbacti          
                       END RECORD, 
       g_ggb_t         RECORD
           ggb02           LIKE ggb_file.ggb02,
           ggb03           LIKE ggb_file.ggb03,  
           gaz03           LIKE type_file.chr100, 
           ggb04           LIKE ggb_file.ggb04,
           ggb05           LIKE ggb_file.ggb05, 
           ggb06           LIKE ggb_file.ggb06,
           ggb07           LIKE ggb_file.ggb07, 
           ggbacti         LIKE ggb_file.ggbacti 
                       END RECORD             
DEFINE g_gga01_t       LIKE gga_file.gga01
DEFINE l_ac            LIKE type_file.num10                    
DEFINE g_i             LIKE type_file.num5
DEFINE g_str           STRING
DEFINE g_sql           STRING
DEFINE g_wc_o          STRING
DEFINE g_idx           LIKE type_file.num5
DEFINE g_tree DYNAMIC ARRAY OF RECORD
             name           STRING,                 #节点名称
             pid            LIKE ima_file.ima01,    #父节点id
             id             LIKE ima_file.ima01,    #节点id
             has_children   BOOLEAN,                #1:有子节点, null:无子节点
             expanded       BOOLEAN,                #0:不展开, 1展开
             level          LIKE type_file.num5,    #层级
             path           STRING,
             treekey1       STRING,
             treekey2       STRING 
        END RECORD
DEFINE g_tree_focus_idx     STRING                  #当前节点数
DEFINE g_tree_focus_path    STRING
DEFINE g_path_add           DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE g_tree_arr_curr      LIKE type_file.num5
DEFINE g_tree_reload        LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_item          LIKE gga_file.gga01
DEFINE g_tree_upd           LIKE gga_file.gga01
DEFINE g_gga01_tree         LIKE gga_file.gga01
DEFINE g_curr_idx           INTEGER
DEFINE p_row,p_col          LIKE type_file.num5 
DEFINE g_forupd_sql         STRING 
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10 
DEFINE g_jump               LIKE type_file.num10
DEFINE g_msg                LIKE ze_file.ze03
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_rec_b              LIKE type_file.num10 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_wc                 STRING
DEFINE g_wc2                STRING
DEFINE g_argv1              LIKE gga_file.gga01
DEFINE g_zz13               LIKE zz_file.zz13     

MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 1 LET p_col = 3

   OPEN WINDOW i700_w AT p_row,p_col WITH FORM "aoo/42f/aooi700"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_init()

   LET g_argv1 = ARG_VAL(1)
   LET g_tree_reload = "Y"                             #tree是否要重新整理 Y/N
   LET g_tree_focus_idx = 0                            #focus节点index

   SELECT zz13 INTO g_zz13 FROM zz_file                #是否可以更改索引欄位
    WHERE zz01 = g_prog

   IF NOT cl_null(g_argv1) THEN
      CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_argv1)
   END IF

   CALL i700()

   CLOSE WINDOW i700_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN

FUNCTION i700()
   INITIALIZE g_gga.* TO NULL
   INITIALIZE g_gga_t.* TO NULL
   INITIALIZE g_gga_o.* TO NULL
   LET g_forupd_sql = "SELECT * FROM gga_file WHERE gga01 = ? FOR UPDATE"  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i700_cl CURSOR FROM g_forupd_sql
   LET g_action_choice = ''

   CALL i700_menu()

END FUNCTION 

FUNCTION i700_menu()

DEFINE  l_msg          STRING    

   WHILE TRUE
      CALL i700_bp("G")

      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i700_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i700_q(0)
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i700_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i700_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i700_x()
               CALL i700_show()
            #  CALL cl_set_field_pic(g_confirm,"","","","",g_gga.ggaacti)
            END IF

         WHEN "tree"
            CALL i700_q(0)
            LET g_action_choice=''
            
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i700_copy()                
            END IF

         WHEN "detail"
            IF NOT cl_null(g_gga.gga01) THEN
               IF cl_chk_act_auth() THEN
                  CALL i700_b()
               END IF
            ELSE
               CALL cl_err('',-400,0)
            END IF
            #LET g_action_choice = ""  #FUN-D40030 mark

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ggb),'','')
            END IF

         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_gga.gga01 IS NOT NULL THEN
                  LET g_doc.column1 = "gga01"
                  LET g_doc.column2 = "gga02"
                  LET g_doc.value1 = g_gga.gga01
                  LET g_doc.value2 = g_gga.gga02
                  CALL cl_doc()
               END IF
            END IF
       # WHEN "output"
       #    IF cl_chk_act_auth() THEN
       #       CALL i700_out()
       #    END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i700_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_ggb.clear()
#   INITIALIZE g_gga.* LIKE gga_file.*
    INITIALIZE g_gga.* TO NULL 
    LET g_gga01_t = NULL   
    LET g_gga.gga01  = ' '      
    LET g_gga.gga02 = ' '
    LET g_gga.gga03 = ' '
    LET g_gga.ggaacti = 'Y'                       
    LET g_gga.ggauser = g_user
    LET g_gga.ggagrup = g_grup
    LET g_gga.ggaorig = g_grup  
    LET g_gga.ggaoriu = g_user  
    LET g_gga.ggadate = TODAY
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i700_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ggb.clear()
            EXIT WHILE
        END IF
        BEGIN WORK
        IF cl_null(g_gga.gga01) THEN LET g_gga.gga01=' ' END IF
        IF cl_null(g_gga.gga02) THEN LET g_gga.gga02 = ' ' END IF    
        LET g_gga.ggaoriu = g_user      
        LET g_gga.ggaorig = g_grup      
        INSERT INTO gga_file VALUES(g_gga.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gga_file",g_gga.gga01,g_gga.gga02,SQLCA.sqlcode,"","",1) 
           ROLLBACK WORK 
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           LET g_gga_t.* = g_gga.*                      # 保存上筆資料
           SELECT gga01,gga02,gga03 INTO g_gga.gga01,g_gga.gga02,g_gga.gga03 FROM gga_file  
                  WHERE gga01 = g_gga.gga01
        END IF
        CALL g_ggb.clear()
        LET g_rec_b = 0
        CALL i700_b()
        EXIT WHILE
    END WHILE
END FUNCTION


FUNCTION i700_i(p_cmd)
   DEFINE  p_cmd     LIKE type_file.chr1
   DEFINE  l_count   LIKE type_file.num5

   CALL cl_set_head_visible("","YES")

   DISPLAY BY NAME g_gga.ggaorig,g_gga.ggaoriu 

   INPUT BY NAME g_gga.gga01,g_gga.gga02,g_gga.gga03  
             WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i700_set_entry(p_cmd)
          CALL i700_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD gga01    #流程編號不可與程式編號相同
         IF cl_null(g_gga.gga01) THEN
            NEXT FIELD gga01
         END IF    
         IF NOT cl_null(g_gga.gga01) THEN #流程編號不可與程式編號相同
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM gga_file
             WHERE gga01 = g_gga.gga01
            IF l_count > 0 THEN
               CALL cl_err(g_gga.gga01,-239,0)
               NEXT FIELD gga01
            END IF
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM zz_file
             WHERE zz01 = g_gga.gga01 
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN 
               CALL cl_err(g_gga.gga01,'aoo-103',0)
               NEXT FIELD gga01  
            END IF    
            IF p_cmd = 'u' AND g_zz13 = 'Y' THEN
               LET l_count = 0
               SELECT COUNT(*) INTO l_count FROM ggb_file
                WHERE ggb03 = g_gga01_t 
               IF l_count > 0 THEN
                  CALL cl_err(g_gga01_t,'aoo-173',0)
                  NEXT FIELD gga01
               END IF
            END IF
         END IF        
       
     AFTER INPUT 
        IF INT_FLAG THEN EXIT INPUT END IF

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLF                        # 欄位說明
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

FUNCTION i700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY 
    l_n             LIKE type_file.num5,         #檢查重復用    
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否    
    l_sw_aps        LIKE type_file.num5,         
    p_cmd           LIKE type_file.chr1,         #處理狀態      
    l_allow_insert  LIKE type_file.num5,         #可新增否      
    l_allow_delete  LIKE type_file.num5          #可刪除否     

DEFINE  l_cnt       LIKE type_file.num5  
DEFINE  l_loop      LIKE type_file.chr1  
DEFINE  l_wc_new    STRING
DEFINE  l_count     LIKE type_file.num5 

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_gga.gga01 IS NULL THEN RETURN END IF
   LET g_forupd_sql = " SELECT ggb02,ggb03,' ',ggb04,ggb05,ggb06,ggb07,ggbacti FROM ggb_file",
                      "  WHERE ggb01 = ? AND ggb02 = ? FOR UPDATE"   
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i700_bcl CURSOR FROM g_forupd_sql     

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")  

   INPUT ARRAY g_ggb WITHOUT DEFAULTS FROM s_ggb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF  

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            BEGIN WORK

            OPEN i700_cl USING g_gga.gga01
            IF STATUS THEN
               CALL cl_err("OPEN i700_cl_b:", STATUS, 1)
               CLOSE i700_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i700_cl INTO g_gga.*               # 對DB鎖定
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock gga:',SQLCA.sqlcode,0)
                  CLOSE i700_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ggb_t.* = g_ggb[l_ac].*  #BACKUP
                OPEN i700_bcl USING g_gga.gga01,g_ggb_t.ggb02
                IF STATUS THEN
                   CALL cl_err("OPEN i700_bcl:", STATUS, 1)
                   CLOSE i700_bcl
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i700_bcl INTO g_ggb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ggb_t.ggb03,SQLCA.sqlcode,1)
                       CLOSE i700_bcl
                       LET l_lock_sw = "Y"
                   END IF
            IF NOT cl_null(g_ggb[l_ac].ggb03) THEN
               SELECT COUNT(*) INTO l_count FROM gga_file,ggb_file
                WHERE gga01 = ggb01
                  AND ggb01 = g_ggb[l_ac].ggb03
               IF cl_null(l_count) THEN LET l_count = 0 END IF
               IF l_count > 0 THEN  #流程編號
                  SELECT gga02 INTO g_ggb[l_ac].gaz03 FROM gga_file
                   WHERE gga01 = g_ggb[l_ac].ggb03
               ELSE
                  SELECT gaz03 INTO g_ggb[l_ac].gaz03 FROM gaz_file
                   WHERE gaz01 = g_ggb[l_ac].ggb03
                     AND gaz02 = g_lang
               END IF
               DISPLAY g_ggb[l_ac].gaz03 TO gaz03
            END IF   
                END IF
                CALL cl_show_fld_cont()     
            END IF  
            
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ggb[l_ac].* TO NULL   
            LET g_ggb[l_ac].ggb04 = 'Y'
            LET g_ggb[l_ac].ggb05 = 'Y'
            LET g_ggb[l_ac].ggbacti = 'Y' 
            CALL cl_show_fld_cont()     
            NEXT FIELD ggb02            
                      
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL i700_tree_loop(g_gga.gga01,g_ggb[l_ac].ggb03,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
            IF l_loop = "Y" THEN
               CALL cl_err(g_ggb[l_ac].ggb03,"agl1000",1)
               CANCEL INSERT
               ROLLBACK WORK  
            ELSE
               CALL i700_b_move_back()   RETURNING b_ggb.*   #變量的賦值 lixh1
               INSERT INTO ggb_file VALUES (b_ggb.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","ggb_file",b_ggb.ggb01,b_ggb.ggb02,STATUS,"","ins ggb:",1) #FUN-660091
                  ROLLBACK WORK
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
                  IF NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0 THEN
                     LET g_gga01_tree = g_tree[1].treekey2
                  ELSE
                     LET g_gga01_tree = g_gga.gga01
                  END IF
                  CALL g_tree.clear()
               END IF
            END IF
            LET l_wc_new = "gga01 = '",g_gga01_tree,"'"      #不能傳入上次查詢是的條件，這樣會撈不到資料
            CALL i700_tree_fill(l_wc_new,NULL,0,NULL,NULL,NULL,g_gga01_tree)                 
          # CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga.gga01)
            
        BEFORE FIELD ggb02
            IF cl_null(g_ggb[l_ac].ggb02) OR g_ggb[l_ac].ggb02 = 0 THEN
               SELECT MAX(ggb02)+10 INTO g_ggb[l_ac].ggb02 FROM ggb_file
                WHERE ggb01 = g_gga.gga01
               IF cl_null(g_ggb[l_ac].ggb02) THEN
                  LET g_ggb[l_ac].ggb02 = 10   
               END IF              
            END IF   

        AFTER FIELD ggb02  #FUN-C80092 add
            IF cl_null(g_ggb_t.ggb02) OR (g_ggb_t.ggb02<>g_ggb[l_ac].ggb02) THEN 
               SELECT COUNT(*) INTO l_n FROM ggb_file 
                WHERE ggb01 = g_gga.gga01
                  AND ggb02 = g_ggb[l_ac].ggb02  
               IF l_n >= 1 THEN 
                  CALL cl_err('','aoo-279',1)
                  NEXT FIELD ggb02
               END IF
            END IF

        AFTER FIELD ggb03 
            IF NOT cl_null(g_ggb[l_ac].ggb03) THEN
               IF g_ggb[l_ac].ggb03 = g_gga.gga01 THEN
                  CALL cl_err(g_ggb[l_ac].ggb03,'aoo-129',0)
                  NEXT FIELD ggb03
               END IF
               IF cl_null(g_ggb_t.ggb03) OR g_ggb_t.ggb03 <> g_ggb[l_ac].ggb03 THEN  #檢查是否重複只給出提示讓用戶選擇是否允許
                  SELECT COUNT(*) INTO l_n FROM ggb_file
                   WHERE ggb01=g_gga.gga01
                     AND ggb03=g_ggb[l_ac].ggb03
                  IF l_n>0 THEN
                     IF NOT cl_confirm('aoo-101') THEN NEXT FIELD ggb03 END IF
                  END IF
               END IF
               SELECT gaz03 INTO g_ggb[l_ac].gaz03 FROM gaz_file    #檢查是否存在gaz_file
                WHERE gaz01 = g_ggb[l_ac].ggb03
                  AND gaz02 = g_lang
               IF SQLCA.sqlcode THEN
                  SELECT gga02 INTO g_ggb[l_ac].gaz03 FROM gga_file #檢查是否存在gga_file
                   WHERE gga01 = g_ggb[l_ac].ggb03
                     AND ggaacti = 'Y' 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ggb[l_ac].ggb03,'aoo-128',0)
                     NEXT FIELD ggb03
                  END IF
               END IF  
            END IF

        BEFORE DELETE 
            IF g_ggb_t.ggb02 > 0 AND g_ggb_t.ggb02 IS NOT NULL THEN               
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF  
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ggb_file 
                 WHERE ggb01 = g_gga.gga01
                   AND ggb02 = g_ggb_t.ggb02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ecb_file",g_gga.gga01,g_ggb_t.ggb02,SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   COMMIT WORK   
                END IF                 
            END IF  
            IF NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0 THEN  #lixh1
               LET g_gga01_tree = g_tree[1].treekey2
            ELSE
               LET g_gga01_tree = g_gga.gga01
            END IF
            CALL g_tree.clear()
            CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga01_tree)            
           #CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga.gga01)

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ggb[l_ac].* = g_ggb_t.*
              CLOSE i700_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ggb[l_ac].ggb02,-263,1)
              LET g_ggb[l_ac].* = g_ggb_t.*
           ELSE
              CALL i700_tree_loop(g_gga.gga01,g_ggb[l_ac].ggb03,NULL) RETURNING l_loop
              IF l_loop = "Y" THEN
                 CALL cl_err(g_ggb[l_ac].ggb03,"agl1000",1)
                 CLOSE i700_bcl
                 ROLLBACK WORK
                 LET g_ggb[l_ac].* = g_ggb_t.*
                 NEXT FIELD ggb02
              END IF
              CALL i700_b_move_back() RETURNING b_ggb.*
              UPDATE ggb_file SET * = b_ggb.*
               WHERE ggb01 = g_gga.gga01
                 AND ggb02 = g_ggb_t.ggb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ggb_file",g_gga.gga01,g_ggb_t.ggb02,SQLCA.sqlcode,"","",1) 
                 LET g_ggb[l_ac].* = g_ggb_t.*
                 CLOSE i700_bcl
                 ROLLBACK WORK
              ELSE
                 UPDATE gga_file SET ggadate = g_today
                  WHERE gga01=g_gga.gga01
                 COMMIT WORK
              END IF
              IF NOT cl_null(g_tree_item) OR g_tree_arr_curr > 0 THEN  #lixh1
                 LET g_gga01_tree = g_tree[1].treekey2
              ELSE
                 LET g_gga01_tree = g_gga.gga01
              END IF
              CALL g_tree.clear()
              CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga01_tree)
           END IF

        #FUN-D40030--add--begin--
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ggb[l_ac].* = g_ggb_t.*
               ELSE
                  CALL g_ggb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    
            CLOSE i700_bcl 
            COMMIT WORK
        #FUN-D40030--add--end--

        ON ACTION CONTROLP 
           IF INFIELD(ggb03) THEN
              CALL q_zz01(FALSE,FALSE,g_gga.gga01,'') RETURNING g_ggb[l_ac].ggb03    
              DISPLAY g_ggb[l_ac].ggb03 TO ggb03
           END IF

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
          CONTINUE INPUT

        ON ACTION about     
           CALL cl_about()   

        ON ACTION help        
           CALL cl_show_help() 

   END INPUT 

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF

   CALL i700_b_fill('1=1')  

END FUNCTION 


FUNCTION i700_curs(p_idx)
DEFINE  p_idx           LIKE type_file.num5 
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
   CLEAR FORM
   CALL g_ggb.clear()
   CALL cl_set_head_visible("","YES")    
   INITIALIZE g_gga.* TO NULL    
   INITIALIZE g_gga.gga01 TO NULL        

   IF NOT cl_null(g_argv1) OR NOT cl_null(g_tree_item) THEN
      IF NOT cl_null(g_argv1) THEN
         LET g_wc = " gga01 = '",g_argv1,"'"
      ELSE
         IF NOT cl_null(g_tree_item) AND g_tree_arr_curr > 0 THEN
            LET g_wc = " gga01 = '",g_tree_item,"'"  
         END IF
      END IF
    
   ELSE
      CONSTRUCT BY NAME g_wc ON gga01,gga02,gga03,ggauser,ggamodu,ggaacti,ggagrup,ggadate,ggaoriu,ggaorig
       
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(gga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form = "q_gga"          
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gga01
                 NEXT FIELD gga01
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
	 CALL cl_qbe_list() RETURNING lc_qbe_sn
	 CALL cl_qbe_display_condition(lc_qbe_sn)
         
   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF

   CONSTRUCT g_wc2 ON ggb02,ggb03,ggb04,ggb05,ggb05,ggb07,ggbacti  
   
           FROM s_ggb[1].ggb02,s_ggb[1].ggb03,s_ggb[1].ggb04,s_ggb[1].ggb05,
                s_ggb[1].ggb06,s_ggb[1].ggb07,s_ggb[1].ggbacti


      BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlp                        
         CASE
            WHEN INFIELD(ggb03)                 #流程編號/程序編號
                 CALL q_zz01(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ggb03
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

   IF INT_FLAG THEN RETURN END IF
   END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ggauser', 'ggagrup')
   
   IF cl_null(g_wc) THEN
      LET g_wc = " 1=1"
   END IF    
   IF p_idx = 0 AND g_tree_arr_curr <= 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
      LET g_wc_o = g_wc CLIPPED
   END IF   

   IF g_wc2=' 1=1' THEN
   
      LET g_sql="SELECT gga01 FROM gga_file ",            
                " WHERE ",g_wc CLIPPED, " ORDER BY gga01"  
   ELSE 
   
      LET g_sql="SELECT UNIQUE gga01", 
                "  FROM gga_file,ggb_file ",
                " WHERE gga01=ggb01 ",                  
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY gga01"             
   END IF
   PREPARE i700_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE i700_curs SCROLL CURSOR WITH HOLD FOR i700_prepare   

   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT COUNT(*) FROM gga_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*)",
                "  FROM gga_file,ggb_file ",
                " WHERE gga01=ggb01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   
   PREPARE i700_precount FROM g_sql
   DECLARE i700_count CURSOR FOR i700_precount
END FUNCTION

FUNCTION i700_q(p_idx)
    DEFINE p_idx  LIKE type_file.num5
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gga.* TO NULL             
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ggb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i700_curs(p_idx)      
    IF INT_FLAG THEN
       INITIALIZE g_gga.* TO NULL
       CALL g_tree.clear()
       LET g_tree_focus_idx =0
       LET INT_FLAG = 0
       RETURN
    END IF

    MESSAGE " SEARCHING ! "
    OPEN i700_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                     
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gga.* TO NULL
    ELSE
        OPEN i700_count
        FETCH i700_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        IF g_row_count <= 0 THEN
           CALL g_tree.clear()
        END IF 
        IF p_idx = 0 THEN
           CALL i700_fetch('F',0)        #讀出TEMP第一筆並顯示
        ELSE
           #Tree的最上層是QBE結果，才可以指定jump
           IF g_tree[p_idx].level = 1 THEN
              CALL i700_fetch('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
           ELSE
              CALL i700_fetch('F',0)
           END IF
        END IF
    END IF
    MESSAGE " "
END FUNCTION

FUNCTION i700_fetch(p_flag,p_idx)
   DEFINE p_flag     LIKE type_file.chr1    #處理方式
   DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  
   DEFINE l_i       LIKE type_file.num5     
   DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 

    MESSAGE ""

    IF p_flag = 'T' AND p_idx <= 0 THEN      #Tree index錯誤就改讀取第一筆資料
       LET p_flag = 'F'
    END IF

   CASE p_flag
        WHEN 'N' FETCH NEXT     i700_curs INTO g_gga.gga01
        WHEN 'P' FETCH PREVIOUS i700_curs INTO g_gga.gga01
        WHEN 'F' FETCH FIRST    i700_curs INTO g_gga.gga01
        WHEN 'L' FETCH LAST     i700_curs INTO g_gga.gga01
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i700_curs INTO g_gga.gga01

  
        #Tree雙點指定筆
        WHEN 'T'
           #讀出TEMP中，雙點Tree的指定節點並顯示
           LET l_jump = 0
           IF g_tree[p_idx].level = 1 THEN   #最高層
              LET l_jump = g_tree[p_idx].id  #ex:當id=5，表示要跳到第5筆
           END IF
           IF l_jump <= 0 THEN
              LET l_jump = 1
           END IF
           LET g_jump = l_jump
           FETCH ABSOLUTE g_jump i700_curs INTO g_gga.gga01

    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_gga.gga01,SQLCA.sqlcode,0)
       INITIALIZE g_gga.* TO NULL   #No.TQC-6B0105
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
    END IF
    SELECT * INTO g_gga.* FROM gga_file WHERE gga01=g_gga.gga01 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gga_file",g_gga.gga01,g_gga.gga02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
        INITIALIZE g_gga.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_gga.ggauser     
        LET g_data_group = g_gga.ggagrup      
    END IF
    CALL i700_show()

END FUNCTION

FUNCTION i700_show()
    DEFINE l_wc_new1      STRING
    DEFINE l_wc_new2      STRING
    LET g_gga_t.* = g_gga.*
    DISPLAY BY NAME
        g_gga.gga01, g_gga.gga02, g_gga.gga03,  
        g_gga.ggaoriu,g_gga.ggaorig,        
        g_gga.ggauser,g_gga.ggagrup,g_gga.ggamodu,g_gga.ggadate,g_gga.ggaacti   

    IF cl_null(g_wc2) THEN
      LET g_wc2 = " 1=1"
    END IF
    IF cl_null(g_tree_item) OR  g_tree_arr_curr < = 0    #刷新樹結構 
       OR g_row_count > 1 OR g_action_choice = "query"  
       OR g_action_choice = "modify" THEN
       CALL g_tree.clear()
       IF g_action_choice = "modify" THEN   
       #  IF g_gga01_t <> g_tree_upd OR (g_zz13 = 'N' AND g_gga01_t = g_tree_upd)  THEN
          IF g_gga01_t <> g_tree_upd THEN
             LET l_wc_new1 = "gga01 = '",g_tree_upd,"'"  
             CALL i700_tree_fill(l_wc_new1,NULL,0,NULL,NULL,NULL,g_tree_upd)
          ELSE
          #  IF g_zz13 = 'Y' AND g_gga01_t = g_tree_upd THEN
                LET l_wc_new2 = "gga01 = '",g_gga.gga01,"'"
                CALL i700_tree_fill(l_wc_new2,NULL,0,NULL,NULL,NULL,g_gga.gga01)
          #  END IF
          END IF
       ELSE
          CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga.gga01)    
       END IF
    END IF
    CALL i700_b_fill(g_wc2)                      
    CALL cl_show_fld_cont()                  
END FUNCTION

FUNCTION i700_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_gga.gga01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')

    BEGIN WORK
    
    LET g_tree_upd = g_tree[1].treekey2

    OPEN i700_cl USING g_gga.gga01
    IF STATUS THEN
       CALL cl_err("OPEN i700_cl:", STATUS, 1)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i700_cl INTO g_gga.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock gga:',SQLCA.sqlcode,0)
        CLOSE i700_cl 
        ROLLBACK WORK 
        RETURN
    END IF

    LET g_gga01_t = g_gga.gga01
    LET g_gga_o.*=g_gga.*
    LET g_gga.ggamodu = g_user
    LET g_gga.ggadate = g_today               #修改日期
    CALL i700_show()                          # 顯示最新資料

    WHILE TRUE
        CALL i700_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gga.*=g_gga_t.*
            CALL i700_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gga.gga01 IS NULL THEN
           LET g_gga.gga01 = ' '
        END IF
        IF g_gga.gga02 IS NULL THEN LET g_gga.gga02 = ' ' END IF   
        UPDATE gga_file SET gga_file.* = g_gga.*                   # 更新DB
         WHERE gga01 = g_gga01_t

        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gga_file",g_gga01_t,'',SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF

        IF g_zz13 = 'Y' THEN     #如果參數設置可與建檔作業更改索引欄位，則一併更改單身的索引
           UPDATE ggb_file SET ggb01 = g_gga.gga01
            WHERE ggb01 = g_gga01_t

           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","ggb_file",g_gga01_t,'',SQLCA.sqlcode,"","",1)
              CONTINUE WHILE
           END IF
        END IF
 
        EXIT WHILE
    END WHILE
    CLOSE i700_cl
    COMMIT WORK
    CALL i700_show()
    LET g_tree_upd = ''
END FUNCTION

FUNCTION i700_r()
    DEFINE l_chr      LIKE type_file.chr1,         
           l_cnt      LIKE type_file.num5         
    DEFINE l_n        LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_gga.gga01)  THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF

    BEGIN WORK

    OPEN i700_cl USING g_gga.gga01
    IF STATUS THEN
       CALL cl_err("OPEN i700_cl:", STATUS, 1)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH i700_cl INTO g_gga.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock gga:',SQLCA.sqlcode,0)
       CLOSE i700_cl
       ROLLBACK WORK
       RETURN
    END IF

    CALL i700_show()

    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "gga01"         
        LET g_doc.column2 = "gga02"         
        LET g_doc.value1 = g_gga.gga01      
        LET g_doc.value2 = g_gga.gga02      
        CALL cl_del_doc()                   

        IF cl_null(g_gga.gga02) THEN LET g_gga.gga02 = ' ' END IF 
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM ggb_file
         WHERE ggb03 = g_gga.gga01
        IF l_n > 0 THEN
           CALL cl_err(g_gga.gga01,'aoo-172',0)
           RETURN
        END IF

        DELETE FROM gga_file WHERE gga01 = g_gga.gga01

        IF STATUS THEN
           CALL cl_err3("del","gga_file",g_gga.gga01,g_gga.gga02,STATUS,"","del gga:",1)
           RETURN
        END IF

        DELETE FROM ggb_file WHERE ggb01 = g_gga.gga01 
        
        IF STATUS THEN
           CALL cl_err3("del","ggb_file",g_gga.gga01,g_gga.gga02,STATUS,"","del ggb:",1)
           RETURN 
        END IF

        INITIALIZE g_gga.* TO NULL
        CLEAR FORM
        CALL g_ggb.clear()
 
        OPEN i700_count

     #  IF STATUS THEN
     #     CLOSE i700_cl
     #     CLOSE i700_count
     #     COMMIT WORK
     #     RETURN
     #  END IF

        FETCH i700_count INTO g_row_count

        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i700_cl
           CLOSE i700_count
           COMMIT WORK
           CALL g_tree.clear()           
           RETURN
        END IF
 
#       IF g_row_count > 0 THEN  
#          LET g_row_count = g_row_count - 1 
#       END IF 
        DISPLAY g_row_count TO FORMONLY.cnt


        IF g_row_count >=1 THEN
           OPEN i700_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i700_fetch('L',0)
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i700_fetch('/',0)
           END IF
        END IF
    END IF
    CLOSE i700_cl
    COMMIT WORK
    CALL g_tree.clear()
    CALL i700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga.gga01)
END FUNCTION


FUNCTION i700_b_fill(p_wc2)              
DEFINE
    p_wc2         LIKE type_file.chr1000,      
    l_gga02       LIKE gga_file.gga02

    IF cl_null(p_wc2) THEN LET p_wc2=' 1=1' END IF  

    LET g_sql = "SELECT ggb02,ggb03,'',ggb04,ggb05,ggb06,ggb07,ggbacti FROM ggb_file",
                " WHERE ggb01 ='",g_gga.gga01,"'", 
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY ggb02 "

    PREPARE i700_pb FROM g_sql
    DECLARE ggb_curs CURSOR FOR i700_pb

    CALL g_ggb.clear()

    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ggb_curs INTO g_ggb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      #首先判斷是不是程序代號,撈取程式名稱
      SELECT gaz03 INTO g_ggb[g_cnt].gaz03 FROM gaz_file
       WHERE gaz01 = g_ggb[g_cnt].ggb03
         AND gaz02 = g_lang
      IF SQLCA.sqlcode AND cl_null(g_ggb[g_cnt].gaz03) THEN  
      #撈取流程編號
         SELECT gga02 INTO g_ggb[g_cnt].gaz03 FROM gga_file 
          WHERE gga01 = g_ggb[g_cnt].ggb03
         IF SQLCA.sqlcode THEN
            LET g_ggb[g_cnt].gaz03 = NULL
         END IF  
      END IF
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ggb.deleteElement(g_cnt)

    LET g_rec_b=g_cnt -1

    DISPLAY g_rec_b TO FORMONLY.cn2

    LET g_cnt = 0

END FUNCTION


#填充树
#填充树的父亲节点


FUNCTION i700_bp(p_ud)
   DEFINE  p_ud              LIKE type_file.chr1  
   DEFINE  l_wc              LIKE type_file.chr1000    
   DEFINE  l_tree_arr_curr   LIKE type_file.num5
   DEFINE  l_i               LIKE type_file.num5
   DEFINE  l_cnt             LIKE type_file.num5

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tree TO tree.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_tree_focus_idx <= 0 THEN
               LET g_tree_focus_idx = ARR_CURR()
            END IF

         BEFORE ROW
            LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
            LET g_tree_arr_curr = ARR_CURR()
            LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取
                  END IF
               #  CALL i700_tree_idxbypath()   #依tree path指定focus節點
               END IF
            ON ACTION accept             #双击时如果是锁定状态并且是尾阶料号，则让用户输入状态
                LET g_tree_item = g_tree[l_tree_arr_curr].treekey2
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM gga_file
                 WHERE gga01 = g_tree_item
                IF l_cnt > 0 THEN
                   CALL i700_q(0)
                END IF
                LET g_tree_item = ''
      END DISPLAY

   DISPLAY ARRAY g_ggb TO s_ggb.* ATTRIBUTE(COUNT=g_rec_b)              #FUN-B90117
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()  #TQC-B60171

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()       

      #TQC-CC0113--add---str---
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG            
      #TQC-CC0113--add---end---    

      AFTER DISPLAY
         CONTINUE DIALOG

   END DISPLAY

    BEFORE DIALOG
        LET l_tree_arr_curr = 1
        LET l_ac = 1
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG                     #FUN-B90117

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
      #  CALL cl_set_field_pic(g_confirm,"","","","",g_gga.ggaacti)
         EXIT DIALOG

      ON ACTION first
         CALL i700_fetch('F',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG        

      ON ACTION previous
         CALL i700_fetch('P',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DIALOG           

      ON ACTION jump
         CALL i700_fetch('/',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                                               #FUN-B90117

      ON ACTION next
         CALL i700_fetch('N',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                                               #FUN-B90117

      ON ACTION last
         CALL i700_fetch('L',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG             


      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG             

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
         EXIT DIALOG            

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG           

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG          

      #TQC-CC0113--mark---str---
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DIALOG            
      #TQC-CC0113--mark---end---    

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG       

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  

      ON ACTION about      
         CALL cl_about()  

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG             

      ON ACTION related_document   
         LET g_action_choice="related_document"
         EXIT DIALOG              

#     ON ACTION output
#          LET g_action_choice="output"
#          IF cl_chk_act_auth() THEN
#             CALL i700_out()
#          END IF

      &include "qry_string.4gl"

   END DIALOG  
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION i700_b_move_back()
   LET b_ggb.ggb01 = g_gga.gga01
   LET b_ggb.ggb02 = g_ggb[l_ac].ggb02
   LET b_ggb.ggb03 = g_ggb[l_ac].ggb03
   LET b_ggb.ggb04 = g_ggb[l_ac].ggb04
   LET b_ggb.ggb05 = g_ggb[l_ac].ggb05
   LET b_ggb.ggb06 = g_ggb[l_ac].ggb06
   LET b_ggb.ggb07 = g_ggb[l_ac].ggb07
   LET b_ggb.ggbacti = g_ggb[l_ac].ggbacti
   RETURN b_ggb.*
END FUNCTION

FUNCTION i700_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_gga.gga01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK

   OPEN i700_cl USING g_gga.gga01
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE i700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i700_cl INTO g_gga.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gga.gga01,SQLCA.sqlcode,0)          #資料被他人LOCK
      RETURN
   END IF
   CALL i700_show()
   IF cl_exp(0,0,g_gga.ggaacti) THEN
      LET g_chr=g_gga.ggaacti
      IF g_gga.ggaacti='Y' THEN
         LET g_gga.ggaacti='N'
      ELSE
         LET g_gga.ggaacti='Y'
      END IF
      UPDATE gga_file
         SET ggaacti=g_gga.ggaacti,
             ggamodu=g_user,
             ggadate=g_today
       WHERE gga01=g_gga.gga01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","gga_file",g_gga.gga01,g_gga.gga02,SQLCA.sqlcode,"","",1)
         LET g_gga.ggaacti = g_chr
      ELSE
         LET g_gga.ggamodu = g_user
         LET g_gga.ggadate = g_today
      END IF
      DISPLAY BY NAME g_gga.ggaacti
      DISPLAY BY NAME g_gga.ggamodu 
      DISPLAY BY NAME g_gga.ggadate  
   END IF
   CLOSE i700_cl
   COMMIT WORK
END FUNCTION

FUNCTION i700_copy()
   DEFINE l_newno     LIKE gga_file.gga01,
          l_oldno     LIKE gga_file.gga01
   DEFINE li_result   LIKE type_file.num5  
   DEFINE l_count     LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF

   IF g_gga.gga01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_before_input_done = FALSE
   CALL i700_set_entry('a')

   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno FROM gga01
      BEFORE INPUT

      AFTER FIELD gga01
         IF cl_null(l_newno) THEN
            NEXT FIELD gga01
         END IF
         IF NOT cl_null(l_newno) THEN
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM gga_file
             WHERE gga01 = l_newno 
            IF l_count > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD gga01
            END IF
            LET l_count = 0
            SELECT COUNT(*) INTO l_count FROM zz_file
             WHERE zz01 = l_newno 
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN
               CALL cl_err(l_newno,'aoo-103',0)
               NEXT FIELD gga01
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
      DISPLAY BY NAME g_gga.gga01
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y

   SELECT * FROM gga_file         #單頭複製
       WHERE gga01=g_gga.gga01
       INTO TEMP y

   UPDATE y
       SET gga01=l_newno,    #新的鍵值
           ggauser=g_user,   #資料所有者
           ggagrup=g_grup,   #資料所有者所屬群
           ggamodu=NULL,     #資料修改日期
           ggadate=g_today,  #資料建立日期
           ggaacti='Y',      #有效資料
           ggaoriu = g_user,
           ggaorig = g_grup

   INSERT INTO gga_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","gga_file",l_newno,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x

   SELECT * FROM ggb_file         #單身複製
       WHERE ggb01=g_gga.gga01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET ggb01=l_newno

   INSERT INTO ggb_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ggb_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]

   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

   LET l_oldno = g_gga.gga01
   SELECT gga_file.* INTO g_gga.* FROM gga_file WHERE gga01 = l_newno
   CALL i700_u()
   CALL i700_b()
   SELECT gga_file.* INTO g_gga.* FROM gga_file WHERE gga01 = l_oldno
   CALL i700_show()

END FUNCTION

#UNCTION i700_out()

#ND FUNCTION

FUNCTION i700_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_gga01)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_gga01            LIKE gga_file.gga01             
   DEFINE l_child            INTEGER
   DEFINE l_gga              DYNAMIC ARRAY OF RECORD
             gga01           LIKE gga_file.gga01,
             ggb03           LIKE ggb_file.ggb03,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_ggb              DYNAMIC ARRAY OF RECORD
              ggb02          LIKE ggb_file.ggb02,
              ggb03          LIKE ggb_file.ggb03,
              ggb04          LIKE ggb_file.ggb04
              END RECORD
   DEFINE  l_sql              STRING

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5 
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_gga02            LIKE gga_file.gga02
   DEFINE l_gaz03            LIKE gaz_file.gaz03

   LET max_level = 20 #設定最大階層數為20
   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF 
   
   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_gga.clear()
      
      #讓QBE出來的單頭都當作Tree的最上層
      LET l_ac = 1
      LET l_sql = "SELECT DISTINCT ggb01,ggb01 as ggb03,COUNT(ggb03) as child_cnt FROM ggb_file,gga_file", 
                  " WHERE ", p_wc CLIPPED,
                  "   AND ggb01 = gga_file.gga01 ",
                  "   AND gga01 = '",p_gga01 CLIPPED,"'", 
                  " GROUP BY ggb01",
                  " ORDER BY ggb01"  
      PREPARE i700_tree_pre1 FROM l_sql
      DECLARE i700_tree_cs1 CURSOR FOR i700_tree_pre1  
      LET l_i = 1
      FOREACH i700_tree_cs1 INTO l_gga[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF   
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
         SELECT gga02 INTO l_gga02 FROM gga_file
          WHERE gga01 = l_gga[l_i].gga01
         LET g_tree[g_idx].name = l_gga[l_i].gga01,' ',l_gga02
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_gga[l_i].ggb03
         LET g_tree[g_idx].treekey1 = l_gga[l_i].gga01
         LET g_tree[g_idx].treekey2 = l_gga[l_i].ggb03
       
         #   LET g_tree1[g_idx].img = " "

        # 有子節點
         IF l_gga[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL i700_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,
                                g_tree[g_idx].treekey2,l_gga[l_i].gga01)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH    
   ELSE
      IF p_level <= 20 THEN               #FUN-B90117
         LET p_level = p_level + 1   #下一階層
         IF p_level > max_level THEN
            CALL cl_err_msg("","agl1001",max_level,0)
            RETURN
         END IF      
         LET l_sql = "SELECT UNIQUE ggb02,ggb03,ggb04 ", 
                     " FROM  gga_file,ggb_file ",             
                     "WHERE  ggb01 = '", p_key1 CLIPPED,"'",                                        
                     " AND ggb01 = gga01",                                             
                     " ORDER BY ggb02"    
         PREPARE i700_tree_pre2 FROM l_sql
         DECLARE i700_tree_cs2 CURSOR FOR i700_tree_pre2

         #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
         LET l_cnt = 1
         CALL l_ggb.clear()
         FOREACH i700_tree_cs2 INTO l_ggb[l_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_ggb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
         LET l_cnt = l_cnt - 1
         IF l_cnt >0 THEN
            FOR l_i=1 TO l_cnt
               LET g_idx = g_idx + 1
               LET g_tree[g_idx].pid = p_pid CLIPPED
               LET l_str = l_i  #數值轉字串
               LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
               LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
               #判斷是流程編號還是程式編號
               SELECT COUNT(*) INTO l_count FROM gga_file,ggb_file 
                WHERE gga01 = ggb01
                  AND ggb01 = l_ggb[l_i].ggb03   
               IF cl_null(l_count) THEN LET l_count = 0 END IF
               IF l_count > 0 THEN  #流程編號
                  SELECT gga02 INTO l_gga02 FROM gga_file
                   WHERE gga01 = l_ggb[l_i].ggb03 
                  LET g_tree[g_idx].name = l_ggb[l_i].ggb03,' ',l_gga02
               ELSE        
                  SELECT gaz03 INTO l_gaz03 FROM gaz_file
                   WHERE gaz01 = l_ggb[l_i].ggb03
                     AND gaz02 = g_lang
                  LET g_tree[g_idx].name = l_ggb[l_i].ggb02,'  ',l_ggb[l_i].ggb03,'-',l_gaz03
               END IF                 
               LET g_tree[g_idx].level = p_level
               LET g_tree[g_idx].path = p_path CLIPPED,".",l_ggb[l_i].ggb03
               LET g_tree[g_idx].treekey1 = l_gga[l_i].gga01
               LET g_tree[g_idx].treekey2 = l_ggb[l_i].ggb03
               #有子節點
               SELECT COUNT(ggb03) INTO l_child FROM ggb_file WHERE ggb01 = l_ggb[l_i].ggb03
               IF l_child > 0 AND p_level <= max_level THEN 
                  LET g_tree[g_idx].has_children = TRUE
                  CALL i700_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                      g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
               ELSE
                  LET g_tree[g_idx].has_children = FALSE
               END IF
            END FOR
         END IF
      END IF            
   END IF
END FUNCTION 

FUNCTION i700_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_child            INTEGER
   DEFINE l_ggb              DYNAMIC ARRAY OF RECORD
              ggb02           LIKE ggb_file.ggb02,
              ggb03           LIKE ggb_file.ggb03,
              ggb04           LIKE ggb_file.ggb04              
              END RECORD
   DEFINE l_sql              STRING
   DEFINE l_count            LIKE type_file.num5 
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_gga02            LIKE gga_file.gga02
   DEFINE l_gaz03            LIKE gaz_file.gaz03

   LET max_level = 20 #設定最大階層數為20  
   LET p_level = p_level+1  
   IF p_level > max_level THEN
      CALL cl_err_msg("","mfg-087",max_level,1)
      RETURN
   END IF   
   LET l_sql = "SELECT UNIQUE ggb02,ggb03,ggb04 ",
                " FROM ggb_file ",
                "WHERE  ggb01 = '", p_key2 CLIPPED,"'",
                " ORDER BY ggb02"

   PREPARE i700_tree_pre3 FROM l_sql
   DECLARE i700_tree_cs3 CURSOR FOR i700_tree_pre3

   #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
   LET l_cnt = 1
   CALL l_ggb.clear()   
   FOREACH i700_tree_cs3 INTO l_ggb[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_ggb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
   LET l_cnt = l_cnt - 1
   IF l_cnt >0 THEN
      FOR l_i=1 TO l_cnt   
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
            
            #判斷是流程編號還是程式編號
            SELECT COUNT(*) INTO l_count FROM gga_file,ggb_file 
             WHERE gga01 = ggb01
               AND ggb01 = l_ggb[l_i].ggb03   
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN  #流程編號
               SELECT gga02 INTO l_gga02 FROM gga_file
                WHERE gga01 = l_ggb[l_i].ggb03
               LET g_tree[g_idx].name = l_ggb[l_i].ggb03,' ',l_gga02
            ELSE        
               SELECT gaz03 INTO l_gaz03 FROM gaz_file
                WHERE gaz01 = l_ggb[l_i].ggb03
                  AND gaz02 = g_lang
               LET g_tree[g_idx].name = l_ggb[l_i].ggb02,'  ',l_ggb[l_i].ggb03,'-',l_gaz03
            END IF               

            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_ggb[l_i].ggb03
            LET g_tree[g_idx].treekey2 = l_ggb[l_i].ggb03

            SELECT COUNT(ggb03) INTO l_child FROM ggb_file WHERE ggb01 = l_ggb[l_i].ggb03

            IF l_child > 0 AND p_level <= max_level THEN 
               LET g_tree[g_idx].has_children = TRUE
               CALL i700_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
      END FOR
   END IF            
END FUNCTION 

FUNCTION i700_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gga01",TRUE) 
   END IF

END FUNCTION

FUNCTION i700_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1       

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gga01",FALSE)   
   END IF

END FUNCTION

FUNCTION i700_tree_update()

END FUNCTION

##################################################
# Descriptions...: 檢查是否為無窮迴圈
# Date & Author..: 12/09/03 By lixh1
# Input Parameter: p_key1,p_addkey2,p_flag
# Return code....: l_loop
##################################################
#此函數用於檢測上階流程編號是否存在于下階流程編號
FUNCTION i700_tree_loop(p_key1,p_addkey2,p_flag)
   DEFINE p_key1             STRING
   DEFINE p_addkey2          STRING               #要增加的節點key2
   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_ggb              DYNAMIC ARRAY OF RECORD
              ggb01           LIKE ggb_file.ggb01,
              ggb03           LIKE ggb_file.ggb03
              END RECORD
   DEFINE l_child            INTEGER
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N

   IF cl_null(p_flag) THEN   #第一次進遞迴
      LET g_idx = 1
      LET g_path_add[g_idx] = p_addkey2
      IF g_path_add[g_idx] = p_key1 THEN
         LET l_loop = "Y"
         RETURN l_loop
      END IF
   END IF
   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF
   IF NOT cl_null(p_addkey2) THEN
      LET g_sql = "SELECT UNIQUE ggb01,ggb03 FROM ggb_file",
                  " WHERE  ggb01 = '", p_addkey2 CLIPPED,"'", 
                  " ORDER BY ggb03"
      PREPARE i700_tree_pre4 FROM g_sql
      DECLARE i700_tree_cs4 CURSOR FOR i700_tree_pre4

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_ggb.clear()
      FOREACH i700_tree_cs4 INTO l_ggb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_ggb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1
      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
             LET g_idx = g_idx + 1
             LET g_path_add[g_idx] = l_ggb[l_i].ggb03
             IF g_path_add[g_idx] = p_key1 THEN
                LET l_loop = "Y"
                RETURN l_loop
             END IF
             #有子節點
             SELECT COUNT(ggb03) INTO l_child FROM ggb_file WHERE ggb01 = l_ggb[l_i].ggb03
             IF l_child > 0 THEN
                CALL i700_tree_loop(p_key1,l_ggb[l_i].ggb03,p_flag) RETURNING l_loop
                IF l_loop = 'Y' THEN
                   RETURN l_loop
                END IF       
             END IF
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION
