# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: asfq302.4gl
# Descriptions...: 工單樹狀查詢
# Date & Author..: 12/08/03 By bart(FUN-C30114)
# Modify.........: No.TQC-D70078 13/07/23 By qirl 單頭員工姓名顯示單身增加料件品名和規格欄位的顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_sfb              RECORD LIKE sfb_file.*
DEFINE   g_ima              RECORD LIKE ima_file.*
DEFINE   g_row_count        LIKE type_file.num10       
DEFINE   g_curs_index       LIKE type_file.num10  
DEFINE   g_rec_b            LIKE type_file.num5
DEFINE   g_wc               STRING 
DEFINE   g_sql              STRING
DEFINE   g_msg              STRING 
DEFINE   g_no_ask           LIKE type_file.num5
DEFINE   g_jump             LIKE type_file.num10
DEFINE   g_buf              LIKE type_file.chr20
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
            name           STRING,                 #節點名禿    
            s1             LIKE sfb_file.sfb05,
      #TQC-D70078---add--star--
            a02             LIKE ima_file.ima02,
            a021            LIKE ima_file.ima021,
      #TQC-D70078---add--end--
            s2             LIKE sfb_file.sfb08,      
            pid            STRING,                 #父節點id
            id             STRING,                 #節點id
            has_children   BOOLEAN,                #TRUE:有子節鹿 FALSE:無子節鹿          
            expanded       BOOLEAN,                #TRUE:展開, FALSE:不展锿          
            level          LIKE type_file.num5,    #階層
            path           STRING,                 #節點路徑，乿."隔開
            #各程式key的數量會不同，單身和單頭的key都要記錄
            #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空痿          
            treekey1       LIKE sfb_file.sfb05,
            treekey2       STRING
            END RECORD
DEFINE g_wc_o            STRING
DEFINE g_idx             LIKE type_file.num5
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整玿Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路弿check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING
          
MAIN
   DEFINE   p_row,p_col   LIKE type_file.num5        
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
      
   LET p_row = 2 LET p_col = 3
   
   OPEN WINDOW t302_w AT p_row,p_col WITH FORM "asf/42f/asfq302"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL q302_q()
   CALL q302_menu()
   CLOSE WINDOW t302_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q302_cs()
   CLEAR FORM                             #清除畫面
   LET g_action_choice=" "   

   INITIALIZE g_sfb.* TO NULL 
   CALL g_tree.clear()   
   CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
          sfb01, sfb81, sfb02, sfb44, sfb05,
          sfb08, sfb87, sfb04
# 2004/03/29 by saki : 加此段的on action是怕 如果在construct的時候 被指定其中之一的table
#                      來查詢, 就要出現相符的資料
        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE WHEN INFIELD(sfb05) #item
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ima"
                     LET g_qryparam.default1 = g_sfb.sfb05
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb05
                     NEXT FIELD sfb05
                WHEN INFIELD(sfb01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb"
                     LET g_qryparam.default1 = g_sfb.sfb01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb01
                     NEXT FIELD sfb01
                WHEN INFIELD(sfb44)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_gen"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret 
                     DISPLAY g_qryparam.multiret TO sfb44 
                     NEXT FIELD sfb44
                OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
         	CALL cl_qbe_select()
            
         ON ACTION qbe_save
		    CALL cl_qbe_save()
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
   END CONSTRUCT
 
   IF INT_FLAG OR g_action_choice = "exit" THEN  
      RETURN
   END IF

   #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
   LET g_sql = "SELECT  sfb01 FROM sfb_file",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY sfb01"
 
   PREPARE q302_prepare FROM g_sql
   DECLARE q302_cs SCROLL CURSOR FOR q302_prepare  #WITH HOLD
 
   LET g_sql="SELECT COUNT(*) FROM sfb_file WHERE ",g_wc CLIPPED
   PREPARE q302_precount FROM g_sql
   DECLARE q302_count CURSOR FOR q302_precount
END FUNCTION

FUNCTION q302_menu()
DEFINE l_i                LIKE type_file.num5
DEFINE l_tree_arr_curr    LIKE type_file.num5
   
   WHILE TRUE
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
                #目前在tree的row 
               LET l_tree_arr_curr = ARR_CURR()
               CALL DIALOG.setSelectionMode( "tree", 1 ) 
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)
               CALL cl_show_fld_cont()

            ON ACTION accept
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
                           
               LET g_msg="asfi301 '",g_tree[l_tree_arr_curr].name,"' 'query'"
               CALL cl_cmdrun_wait(g_msg)

         END DISPLAY


         BEFORE DIALOG
            
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")                   
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)  
            END IF

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION cancel     #FUN-A50010 mark
             LET INT_FLAG=FALSE
             LET g_action_choice="exit"
             EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION FIRST
            CALL q302_fetch('F')
            EXIT DIALOG
 
         ON ACTION PREVIOUS
            CALL q302_fetch('P')
            EXIT DIALOG
 
         ON ACTION jump
            CALL q302_fetch('/')
            EXIT DIALOG
 
         ON ACTION NEXT
            CALL q302_fetch('N')
            EXIT DIALOG
 
         ON ACTION LAST
            CALL q302_fetch('L')
            EXIT DIALOG

         ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         #@WHEN "查詢"
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q302_q()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q302_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q302_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_sfb.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN q302_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_sfb.* TO NULL
   ELSE
      OPEN q302_count
      FETCH q302_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q302_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION

FUNCTION q302_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1                #處理方式                
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q302_cs INTO g_sfb.sfb01
      WHEN 'P' FETCH PREVIOUS q302_cs INTO g_sfb.sfb01
      WHEN 'F' FETCH FIRST    q302_cs INTO g_sfb.sfb01
      WHEN 'L' FETCH LAST     q302_cs INTO g_sfb.sfb01
      WHEN '/'
         IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump q302_cs INTO g_sfb.sfb01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_sfb.* TO NULL
      CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
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
   SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_sfb.sfb01
   IF SQLCA.sqlcode THEN
      INITIALIZE g_sfb.* TO NULL
      CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
   CALL q301_show()
END FUNCTION
 
FUNCTION q301_show()
   DEFINE l_smydesc LIKE smy_file.smydesc 
   DEFINE l_gen02 LIKE gen_file.gen02     #TQC-D70078--add-
   DISPLAY BY NAME
      g_sfb.sfb01, g_sfb.sfb81, g_sfb.sfb02,
      g_sfb.sfb44, g_sfb.sfb05, g_sfb.sfb08,
      g_sfb.sfb87, g_sfb.sfb04
      
   LET g_buf = s_get_doc_no(g_sfb.sfb01)
   SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf
   DISPLAY l_smydesc TO smydesc
#TQC-D70078--add--star---
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_sfb.sfb44
   DISPLAY l_gen02 TO gen02
#TQC-D70078--add--add---
 
   INITIALIZE g_ima.* TO NULL
   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_sfb.sfb05
   DISPLAY BY NAME g_ima.ima02,g_ima.ima021
 
   CALL q302_tree_fill(NULL,0,NULL,g_sfb.sfb01,NULL)
   
   CALL cl_show_fld_cont()    
END FUNCTION

FUNCTION q302_tree_fill(p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             LIKE sfb_file.sfb05
   DEFINE p_key2             STRING
   
   DEFINE max_level          LIKE type_file.num5
   DEFINE l_sql              STRING
   DEFINE l_sfb     DYNAMIC ARRAY OF RECORD 
                    sfb01    LIKE sfb_file.sfb01, 
                    sfb05    LIKE sfb_file.sfb05, 
                    sfb08    LIKE sfb_file.sfb08 
                    #sfb86    LIKE sfb_file.sfb86 
                    END RECORD 
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child_cnt        LIKE type_file.num5
   
   LET max_level = 20 #設定最大階層數為20

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_sfb.clear()
      
      #讓QBE出來的單頭都當作Tree的最上層
      LET l_sql = " SELECT DISTINCT sfb01, sfb05, sfb08 FROM sfb_file ",
                  " WHERE sfb01 = '",p_key1 CLIPPED,"'"

      PREPARE q302_tree_pre1 FROM l_sql
      DECLARE q302_tree_cs1 CURSOR FOR q302_tree_pre1

      LET l_i = 1
      FOREACH q302_tree_cs1 INTO l_sfb[l_i].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         LET g_idx = g_idx + 1   
         LET g_tree[g_idx].pid = NULL
         LET g_tree[g_idx].id = l_i
         LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
         LET g_tree[g_idx].name = l_sfb[l_i].sfb01
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_sfb[l_i].sfb01
         LET g_tree[g_idx].treekey1 = l_sfb[l_i].sfb01

        # 有子節點
         LET l_child_cnt = 0
         SELECT COUNT(*)
           INTO l_child_cnt
           FROM sfb_file
          WHERE sfb89 = p_key1
         IF l_child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL q302_tree_fill(g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH 
   ELSE
      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","agl1001",max_level,0)
         RETURN
      END IF
      LET l_sql = " SELECT DISTINCT sfb01, sfb05, sfb08 FROM sfb_file ",
                  " WHERE sfb89 = '",p_key1 CLIPPED,"'"

      PREPARE q302_tree_pre2 FROM l_sql
      DECLARE q302_tree_cs2 CURSOR FOR q302_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_sfb.clear() 
      FOREACH q302_tree_cs2 INTO l_sfb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_sfb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1
      
      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_i
            LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
            LET g_tree[g_idx].name = l_sfb[l_i].sfb01
            LET g_tree[g_idx].s1= l_sfb[l_i].sfb05
#-TQC-D70078-add--star---
            SELECT ima02,ima021 INTO g_tree[g_idx].a02,g_tree[g_idx].a021
             FROM ima_file
            WHERE ima01 = l_sfb[l_i].sfb05
#-TQC-D70078-add--end---
            LET g_tree[g_idx].s2= l_sfb[l_i].sfb08
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_sfb[l_i].sfb01
            LET g_tree[g_idx].treekey1 = l_sfb[l_i].sfb01

            LET l_child_cnt = 0
            SELECT COUNT(*)
              INTO l_child_cnt
              FROM sfb_file
             WHERE sfb89 = p_key1
            IF l_child_cnt > 0 AND p_level <= max_level THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL q302_tree_fill(g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
         END FOR 
      END IF
      
   END IF 
END FUNCTION 
#FUN-C30114
