# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmq800.4gl
# Descriptions...: 採買追蹤查詢作業
# Date & Author..: 10/05/07 BY suncx1
# Modify.........: No.FUN-A50010 10/05/05 by suncx1 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_wc2,g_sql    STRING
DEFINE g_wc_o        STRING
DEFINE g_pmm DYNAMIC ARRAY OF RECORD
             pmm01   LIKE pmm_file.pmm01,
             pmm04   LIKE pmm_file.pmm04,
             pmm02   LIKE pmm_file.pmm02,
             pmm09   LIKE pmm_file.pmm09,
             pmc02   LIKE pmc_file.pmc02,
             pmm12   LIKE pmm_file.pmm12,
             gen02   LIKE gen_file.gen02,
             pmm18   LIKE pmm_file.pmm18,
             pmn02   LIKE pmn_file.pmn02,
             pmn04   LIKE pmn_file.pmn04,
             pmn041  LIKE pmn_file.pmn041
         END RECORD
DEFINE g_pmm_t RECORD
             pmm01   LIKE pmm_file.pmm01,
             pmm04   LIKE pmm_file.pmm04,
             pmm02   LIKE pmm_file.pmm02,
             pmm09   LIKE pmm_file.pmm09,
             pmc02   LIKE pmc_file.pmc02,
             pmm12   LIKE pmm_file.pmm12,
             gen02   LIKE gen_file.gen02,
             pmm18   LIKE pmm_file.pmm18,
             pmn02   LIKE pmn_file.pmn02,
             pmn04   LIKE pmn_file.pmn04,
             pmn041  LIKE pmn_file.pmn041
         END RECORD
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名禿          
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節鹿 FALSE:無子節鹿          
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展锿          
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，乿."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空痿          
          treekey1       STRING,
          treekey2       STRING
          END RECORD
DEFINE g_name DYNAMIC ARRAY OF STRING
DEFINE g_idx             LIKE type_file.num5     #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE g_rec_b           LIKE type_file.num5   
DEFINE g_forupd_sql      STRING
DEFINE l_ac              LIKE type_file.num5                 #目前處理的ARRAY CNT 
DEFINE g_row_count       LIKE type_file.num5      
DEFINE g_curs_index      LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10

MAIN
   DEFINE p_row,p_col     LIKE type_file.num5 
   OPTIONS                               #改變一些系統預設便   
   INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鋿 由程式處玿 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time               
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q800_w AT p_row,p_col WITH FORM "apm/42f/apmq800"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()

   #FUN-A50010   ---START---
   LET g_wc2 = '1=1'       
   CALL q800_b_fill(g_wc2)
   LET g_tree_reload = "N"      
   LET g_tree_b = "N"          
   LET g_tree_focus_idx = 0 
   #FUN-A50010   ---END---
   

   CALL q800_menu()
   CLOSE WINDOW q800_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使锿 
       RETURNING g_time                        
 
END MAIN 

FUNCTION q800_menu()
   ###FUN-A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_index            STRING 
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   DEFINE l_cmd              LIKE type_file.chr1000 
   ###FUN-A50010 END ###
   WHILE TRUE

      ###FUN-A50010 START ###
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)

      #讓各個交談指令可以互剿      
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正砿               #因為double click tree node弿focus tree的節點會改變
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
                  LET l_tree_arr_curr = 0
               ELSE
                  LET l_tree_arr_curr = ARR_CURR()
               END IF

               #以最上層的id當作單頭的g_curs_index
               IF l_tree_arr_curr > 0 THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED  
                  LET g_tree_focus_path = g_tree[l_tree_arr_curr].path 
               END IF      
          
            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               LET g_tree_focus_idx = l_tree_arr_curr CLIPPED                     
               CALL DIALOG.setSelectionMode( "tree", 1 )  # FUN-50010
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)
               
         END DISPLAY


         DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_pmm[l_ac].pmm01,NULL)

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

            &include "qry_string.4gl"
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

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET l_ac = ARR_CURR()  
            CALL q800_tree_fill(g_wc_o,NULL,0,NULL,
                               g_pmm[l_ac].pmm01,NULL)

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

         #相關文件
         ON ACTION detailed
            LET g_action_choice="detailed" 
            EXIT DIALOG  
            
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG
            
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG

         ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
      ###FUN-9A0002 END ###

     
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q800_q(0)           #FUN-A50010 加參數p_idx
            END IF
      
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "detailed"
            IF cl_chk_act_auth() THEN  
               IF l_tree_arr_curr>0 THEN
                  CALL q800_run(l_tree_arr_curr)
               END IF
            END IF
            
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_pmm[l_ac].pmm01 IS NOT NULL THEN
                  LET g_doc.column1 = "abd01"
                  LET g_doc.value1 = g_pmm[l_ac].pmm01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmm),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q800_q(p_idx)
    DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index
    CALL q800_b_askkey(p_idx)
END FUNCTION

FUNCTION q800_b_askkey(p_idx)
   DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-A50010
   DEFINE l_wc   STRING                #雙按Tree的節點時的查詢䞣FUN-A50010

   ###FUN-A50010 START ###
   LET l_wc = NULL
   IF p_idx > 0 THEN
      IF g_tree_b = "N" THEN
         LET l_wc = g_wc_o             #還原QBE的查詢條乿      
      ELSE
         IF g_tree[p_idx].level = 1 THEN
            LET l_wc = g_wc_o
         ELSE
            IF g_tree[p_idx].has_children THEN
               LET l_wc = "pmm01='",g_tree[p_idx].treekey1 CLIPPED
            ELSE
               LET l_wc = "pmm01='",g_tree[p_idx].treekey1 CLIPPED,"'",
                         " AND pmn02='",g_tree[p_idx].treekey2 CLIPPED,"'"
            END IF
         END IF
      END IF
   END IF
   ##FUN-A50010 END ###
   CLEAR FORM
   CALL g_pmm.clear()
IF p_idx = 0 THEN 
   CONSTRUCT g_wc2 ON pmm01,pmm04,pmm02,pmm09,pmc02,
                      pmm12,gen02,pmm18,pmn02,pmn04,pmn041     
        FROM  s_pmm[1].pmm01,s_pmm[1].pmm04,s_pmm[1].pmm02,
              s_pmm[1].pmm09,s_pmm[1].pmc02,s_pmm[1].pmm12,
              s_pmm[1].gen02,s_pmm[1].pmm18,s_pmm[1].pmn02,
              s_pmm[1].pmn04,s_pmm[1].pmn041

      BEFORE CONSTRUCT
        LET l_ac = 1
        CALL cl_qbe_init()
        
      ON ACTION CONTROLP
         CASE WHEN INFIELD(pmm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_pmm01_a"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_pmm[1].pmm01

              WHEN INFIELD(pmm09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_pmm09"
                 LET g_qryparam.state = "c"   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_pmm[1].pmm09
                 CALL q800_pmc02()

             WHEN INFIELD(pmm12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_pmm12_a"
                 LET g_qryparam.state = "c"   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_pmm[1].pmm12
                 CALL q800_gen02()
                 
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
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
     
   END CONSTRUCT
   ELSE
      LET g_wc2 = l_wc CLIPPED
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
 
   CALL q800_b_fill(g_wc2)
END FUNCTION

FUNCTION q800_b_fill(p_wc2)
   DEFINE p_wc2           STRING
   LET g_sql = "SELECT pmm01,pmm04,pmm02,pmm09,'',pmm12,'',pmm18,pmn02,pmn04,pmn041",
               " FROM pmm_file,pmn_file",
               " WHERE pmm01 = pmn01 ",
               " AND ", p_wc2 CLIPPED,
               " ORDER BY pmm01"     
   IF g_azw.azw04='2' THEN 
      LET g_sql = "SELECT pmm01,pmm04,pmm02,pmm09,'',pmm12,'',pmm18,pmn02,pmn04,pmn041",
               " FROM pmm_file,pmn_file",
               " WHERE pmm01 = pmn01 ",
               " AND ", p_wc2 CLIPPED,
               " AND pmmplant IN ",g_auth,
               " ORDER BY pmm01"  
   END IF

   PREPARE q800_pb FROM g_sql
   DECLARE pmm_curs CURSOR FOR q800_pb
   CALL g_pmm.clear()
   LET g_cnt = 1 
   MESSAGE "Searching!" 
   FOREACH pmm_curs INTO g_pmm[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT pmc02 INTO g_pmm[g_cnt].pmc02 FROM pmc_file WHERE pmc01 = g_pmm[g_cnt].pmm09
      SELECT gen02 INTO g_pmm[g_cnt].gen02 FROM gen_file WHERE gen01 = g_pmm[g_cnt].pmm12
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmm.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
   CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_pmm[1].pmm01,NULL)
END FUNCTION 

##################################################
# Descriptions...: 依tree path指定focus節鹿
# Date & Author..: 10/05/05
# Input Parameter:
# Return code....:
##################################################
FUNCTION q800_tree_idxbypath()
   DEFINE l_i       LIKE type_file.num5
   
   LET g_tree_focus_idx = 1
   FOR l_i = 1 TO g_tree.getlength()
      IF g_tree[l_i].path = g_tree_focus_path THEN
            LET g_tree_focus_idx = l_i
            EXIT FOR
      END IF
   END FOR
END FUNCTION

FUNCTION q800_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_pmn02            LIKE pmn_file.pmn02
   DEFINE l_pmm             DYNAMIC ARRAY OF RECORD
             pmm01           LIKE pmm_file.pmm01,
             pmm04           LIKE pmm_file.pmm04,
             pmm09           LIKE pmm_file.pmm09,   
             pmc02           LIKE pmc_file.pmc02,
             pmm18           LIKE pmm_file.pmm18,
             pmm25           LIKE pmm_file.pmm25
             END RECORD
   DEFINE l_pmn             DYNAMIC ARRAY OF RECORD
             pmn01           LIKE pmn_file.pmn01,
             pmn02           LIKE pmn_file.pmn01,
             pmn04           LIKE pmn_file.pmn04,
             pmn041          LIKE pmn_file.pmn041,   
             pmn20           LIKE pmn_file.pmn20,
             pmn08           LIKE pmn_file.pmn08,
             pmn33           LIKE pmn_file.pmn33
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_prog_name        STRING
   DEFINE l_pmn20 STRING
   LET max_level = 20 #設定最大階層數瀿0
   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_pmm.clear()
      #讓QBE出來的單頭都當作Tree的最上層
      LET g_sql="SELECT DISTINCT pmm01,pmm04,pmm09,pmc02,pmm18,pmm25 FROM pmm_file",								
                " LEFT OUTER JOIN pmc_file ON pmc01 = pmm09",								
                " WHERE pmm01 = '",p_key1,"'"	
      IF g_azw.azw04='2' THEN 
         LET g_sql="SELECT DISTINCT pmm01,pmm04,pmm09,pmc02,pmm18,pmm25 FROM pmm_file",								
                " LEFT OUTER JOIN pmc_file ON pmc01 = pmm09",								
                " WHERE pmm01 = '",p_key1,"'",
                " AND pmmplant IN ",g_auth
      END IF 
      PREPARE q800_tree_pre1 FROM g_sql
      DECLARE q800_tree_cs1 CURSOR FOR q800_tree_pre1      

      LET l_i = 1 
      FOREACH q800_tree_cs1 INTO l_pmm[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         SELECT COUNT(pmn02) INTO l_child FROM pmn_file
          WHERE pmn01 = l_pmm[l_i].pmm01  
         SELECT pmn02 INTO l_pmn02 FROM pmn_file
          WHERE pmn01 = l_pmm[l_i].pmm01       
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
         CASE l_pmm[l_i].pmm25
            WHEN  "X" 
               LET l_prog_name = "pmm25_X"
            WHEN  "0" 
               LET l_prog_name = "pmm25_0"
            WHEN  "1"
               LET l_prog_name = "pmm25_1"   
            WHEN  "2"
               LET l_prog_name = "pmm25_2"   
            WHEN  "6"
               LET l_prog_name = "pmm25_6"      
            WHEN  "9"
               LET l_prog_name = "pmm25_9"      
            WHEN  "W"
               LET l_prog_name = "pmm25_W"
            WHEN  "S"
               LET l_prog_name = "pmm25_S"      
            WHEN  "R"
               LET l_prog_name = "pmm25_R"      
         END CASE
      
         CALL  get_field_name1(l_prog_name,"apmt540") RETURNING  l_prog_name
         LET g_tree[g_idx].name = get_field_name("pmm01"),":",l_pmm[l_i].pmm01 CLIPPED," ",
                                  get_field_name("pmm04"),":",l_pmm[l_i].pmm04 CLIPPED," ",
                                  get_field_name("pmm09"),":",l_pmm[l_i].pmm09 CLIPPED,"(",
                                  get_field_name("pmc02"),":",l_pmm[l_i].pmc02 CLIPPED,") ",
                                  get_field_name("pmm18"),":",l_pmm[l_i].pmm18 CLIPPED," ",
                                  get_field_name("pmm25"),":",l_pmm[l_i].pmm25 CLIPPED,".",l_prog_name CLIPPED
         LET g_tree[g_idx].path = p_path,".",l_pmm[l_i].pmm01
         LET g_tree[g_idx].treekey1 = l_pmm[l_i].pmm01
         LET g_tree[g_idx].treekey2 = l_pmn02
         LET g_name[g_idx] = "apmt540"
         IF l_child > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL q800_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH
   ELSE 
      LET p_level = p_level + 1   #下一階層
      LET max_level = 20 #設定最大階層數瀿0
      IF p_level > max_level THEN
         CALL cl_err_msg("","aoo1001",max_level,0)
         RETURN
      END IF
   	
      LET g_sql="SELECT DISTINCT pmn01,pmn02,pmn04,pmn041,pmn20,pmn08,pmn33",							
                " FROM pmn_file ",							
                " WHERE pmn01 = '",p_key1,"'",							
                " AND pmn02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN 
         LET g_sql="SELECT DISTINCT pmn01,pmn02,pmn04,pmn041,pmn20,pmn08,pmn33",							
                " FROM pmn_file ",							
                " WHERE pmn01 = '",p_key1,"'",							
                " AND pmn02 = '",p_key2,"'",
                " AND pmnplant IN ",g_auth
      END IF 
      PREPARE q800_tree_pre2 FROM g_sql
      DECLARE q800_tree_cs2 CURSOR FOR q800_tree_pre2

      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_pmn.clear()
      FOREACH q800_tree_cs2 INTO l_pmn[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_pmm.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿  
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = FALSE    #T  #TRUE:展開, FALSE:不展锿
            LET l_pmn20 = l_pmn[l_i].pmn20            
            LET g_tree[g_idx].name = get_field_name("pmn01"),":",l_pmn[l_i].pmn01 CLIPPED,' ',
                                     get_field_name("pmn02"),":",l_pmn[l_i].pmn02 CLIPPED,' ',
                                     get_field_name("pmn04"),":",l_pmn[l_i].pmn04 CLIPPED,' ',
                                     get_field_name("pmn041"),":",l_pmn[l_i].pmn041 CLIPPED,' ',
                                     get_field_name("pmn20"),":",l_pmn20 CLIPPED,' ',
                                     get_field_name("pmn08"),":",l_pmn[l_i].pmn08 CLIPPED,' ',
                                     get_field_name("pmn33"),":",l_pmn[l_i].pmn33 CLIPPED
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = l_pmn[l_i].pmn01 
            LET g_tree[g_idx].treekey1 = l_pmn[l_i].pmn01 
            LET g_tree[g_idx].treekey2 = p_key2
            LET g_name[g_idx] = "apmt540"
            LET l_idx = g_idx
            #有子節鹿            
            IF l_child > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL q800_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                   g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
               CALL q800_tree_fill1(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                   g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)

               CALL q800_tree_fill2(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
               CALL q800_tree_fill3(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
                                
               CALL q800_tree_fill4(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
            
            END IF
          END FOR
      END IF 
   END IF
END FUNCTION


FUNCTION q800_tree_fill1(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_pna             DYNAMIC ARRAY OF RECORD
             pna01          LIKE pna_file.pna01,
             pna02          LIKE pna_file.pna02,
             pna04          LIKE pna_file.pna04,  
             pnaconf        LIKE pna_file.pnaconf,
             pna05          LIKE pna_file.pna05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_pna02 STRING
   CALL get_prog_name1("apm1041") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
   LET g_tree[g_idx].name = l_prog_name CLIPPED      
   LET g_tree[g_idx].pid = g_tree[p_pid].id
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".2"      
   LET l_child_pid = g_tree[g_idx].id     #數值轉字串  

   LET g_sql = "SELECT DISTINCT pna01,pna02,pna04,pnaconf,pna05 ",					
               " FROM pna_file,pnb_file ",					
               " WHERE  pna01 = pnb01 ",					
               " AND pnb01 = '",p_key1,"' ",					
               " AND pnb03 = '",p_key2,"' "  
   IF g_azw.azw04='2' THEN 
          LET g_sql = "SELECT DISTINCT pna01,pna02,pna04,pnaconf,pna05",					
               " FROM pna_file,pnb_file ",					
               " WHERE  pna01 = pnb01 ",					
               " AND pnb01 = '",p_key1,"' ",					
               " AND pnb03 = '",p_key2,"' ",  
               " AND pnaplant IN ",g_auth
   END IF                
   PREPARE q800_tree_pre3 FROM g_sql
   DECLARE q800_tree_cs3 CURSOR FOR q800_tree_pre3      

   LET l_index = 0      
   FOREACH q800_tree_cs3 INTO l_pna[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             
   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿            
     
      LET l_pna02 = l_pna[l_i].pna02
      LET g_tree[g_idx].name = get_field_name("pna01"),":",l_pna[l_i].pna01 CLIPPED," ",
                               get_field_name("pna02"),":",l_pna02 CLIPPED," ",
                               get_field_name("pna04"),":",l_pna[l_i].pna04 CLIPPED," ",
                               get_field_name("pnaconf"),":",l_pna[l_i].pnaconf CLIPPED," ",
                               get_field_name("pna05"),":",l_pna[l_i].pna05 CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str      
      LET g_tree[g_idx].path = p_path,".",l_pna[l_i].pna01
      LET g_tree[g_idx].treekey1 = p_key1
      LET g_tree[g_idx].treekey2 = l_pna[l_i].pna02 
      LET l_idx = g_idx 
      LET g_tree[g_idx].has_children = FALSE
      LET g_name[g_idx] = "apmt910"
   END FOR    
   

END FUNCTION

FUNCTION q800_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_rva             DYNAMIC ARRAY OF RECORD
             rva01          LIKE rva_file.rva01,
             rva06          LIKE rva_file.rva06,
             rvaconf        LIKE rva_file.rvaconf
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1042") RETURNING l_prog_name

   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = g_tree[p_pid].id
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".3"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   
   
   LET g_sql="SELECT DISTINCT rva01,rva06,rvaconf",					
                " FROM rva_file,rvb_file ",					
                " WHERE  rva01 = rvb01 ",					
                " AND rvb04 = '",p_key1,"'",		    #採購單號
                " AND rvb03 = '",p_key2,"'"				#項次   
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT DISTINCT rva01,rva06,rvaconf",					
                " FROM rva_file,rvb_file ",					
                " WHERE  rva01 = rvb01 ",					
                " AND rvb04 = '",p_key1,"'",		    #採購單號
                " AND rvb03 = '",p_key2,"'",				#項次   
                " AND rvaplant IN ",g_auth
   END IF 
   PREPARE q800_tree_pre4 FROM g_sql
   DECLARE q800_tree_cs4 CURSOR FOR q800_tree_pre4     

   LET l_index = 0      
   FOREACH q800_tree_cs4 INTO l_rva[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
      LET l_idx = g_idx
      CALL q800_tree_fill2_rvu1(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                NULL,NULL)
      CALL q800_tree_fill2_rvu2(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                NULL,NULL)
   END IF
   FOR l_i=1 TO l_index
      LET g_idx =  g_idx + 1 
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET l_child = 0    
      SELECT COUNT(*) INTO l_child 
      FROM rvb_file
      WHERE rvb01 = l_rva[l_i].rva01
      LET g_tree[g_idx].name = get_field_name("rva01"),":",l_rva[l_i].rva01 CLIPPED," ",
                                  get_field_name("rva06"),":",l_rva[l_i].rva06 CLIPPED," ",
                                  get_field_name("rvaconf"),":",l_rva[l_i].rvaconf CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str   
       
      LET g_tree[g_idx].path = p_path,".",l_rva[l_i].rva01
      LET g_tree[g_idx].treekey1 = l_rva[l_i].rva01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx 
      LET g_name[g_idx] = "apmt110"
      IF l_child > 0 THEN
         LET g_tree[g_idx].has_children = TRUE
         CALL q800_tree_fill2_rvb(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,g_tree[l_idx].treekey2,l_rva[l_i].rva01)
      ELSE
         LET g_tree[g_idx].has_children = FALSE
      END IF
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill2_rvb(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_rvb             DYNAMIC ARRAY OF RECORD
             rvb01          LIKE rvb_file.rvb01,
             rvb02          LIKE rvb_file.rvb02,
             rvb07          LIKE rvb_file.rvb07
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_rvb02 STRING
   DEFINE l_rvb07 STRING

   LET g_sql="SELECT rvb01,rvb02,rvb07 ",					
             " FROM rva_file,rvb_file ",
             " WHERE rvb01 = rva01 ",         
             " AND rvb01 = '",p_key3,"'",				#收貨單號
             " AND rvb04 = '",p_key1,"'",				#採購單號	
             " AND rvb03 = '",p_key2,"'"				#項次	
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT rvb01,rvb02,rvb07 ",					
                " FROM rva_file,rvb_file ",
                " WHERE rvb01 = rva01 ",         
                " AND rvb01 = '",p_key3,"'",				#收貨單號
                " AND rvb04 = '",p_key1,"'",				#採購單號
                " AND rvb03 = '",p_key2,"'",				#項次	
                " AND rvbplant IN ",g_auth
   END IF          						               
   PREPARE q800_tree_pre7 FROM g_sql
   DECLARE q800_tree_cs7 CURSOR FOR q800_tree_pre7     

   LET l_index = 0      
   FOREACH q800_tree_cs7 INTO l_rvb[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      LET l_rvb02 = l_rvb[l_i].rvb02
      LET l_rvb07 = l_rvb[l_i].rvb07
      LET g_tree[g_idx].name = get_field_name("rvb01"),":",l_rvb[l_i].rvb01 CLIPPED," ",
                                  get_field_name("rvb02"),":",l_rvb02 CLIPPED," ",
                                  get_field_name("rvb07"),":",l_rvb07 CLIPPED," "
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = p_pid
      LET g_tree[g_idx].id = p_pid ,".",l_str      
      LET g_tree[g_idx].path = p_path,".",l_rvb[l_i].rvb01
      LET g_tree[g_idx].treekey1 = l_rvb[l_i].rvb01
      LET g_tree[g_idx].treekey2 = l_rvb[l_i].rvb02
      LET g_tree[g_idx].has_children = FALSE
      LET g_name[g_idx] = "apmt110"
      LET l_idx = g_idx
      CALL q800_tree_fill2_rvu1(p_wc,g_tree[l_idx].pid,p_level,g_tree[l_idx].path,
                                g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
      CALL q800_tree_fill2_rvu2(p_wc,g_tree[l_idx].pid,p_level,g_tree[l_idx].path,
                                g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
   END FOR
     
END FUNCTION

FUNCTION q800_tree_fill2_rvu1(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_rvu             DYNAMIC ARRAY OF RECORD
             rvu01          LIKE rvu_file.rvu01,
             rvu03          LIKE rvu_file.rvu03,
             rvuconf        LIKE rvu_file.rvuconf,
             rvv04          LIKE rvv_file.rvv04,  
             rvv05          LIKE rvv_file.rvv05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1043") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = p_pid
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".1"     #因為訂單變更單是訂單單身下的第一個節點 
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   
   
   LET g_sql="SELECT DISTINCT  rvu01,rvu03,rvuconf,rvv04,rvv05 ",
             " FROM rvu_file,rvv_file ",   
             " WHERE rvu01 = rvv01 ",					
             " AND rvu00 = '1' ",				#入庫	
             " AND rvv04 = '",p_key1,"'",		#收貨單號
             " AND rvv05 = '",p_key2,"'"		#項次	
   IF g_azw.azw04='2' THEN 
     LET g_sql="SELECT DISTINCT  rvu01,rvu03,rvuconf,rvv04,rvv05 ",
             " FROM rvu_file,rvv_file ",   
             " WHERE rvu01 = rvv01 ",					
             " AND rvu00 = '1' ",				#入庫	
             " AND rvv04 = '",p_key1,"'",		#收貨單號
             " AND rvv05 = '",p_key2,"'",		#項次	
             " AND rvuplant IN ",g_auth
   END IF 	
         						               
   PREPARE q800_tree_pre8 FROM g_sql
   DECLARE q800_tree_cs8 CURSOR FOR q800_tree_pre8     

   LET l_index = 0      
   FOREACH q800_tree_cs8 INTO l_rvu[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
      LET l_idx = g_idx
      CALL q800_tree_fill2_apa(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                               NULL,NULL)
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      LET l_child = 0
      SELECT COUNT(*) INTO l_child
      FROM rvv_file
      WHERE rvv01 = l_rvu[l_i].rvu01
      LET g_tree[g_idx].name = get_prog_name1("apm1040"),":",l_rvu[l_i].rvu01 CLIPPED," ",
                                  get_field_name("rvu03"),":",l_rvu[l_i].rvu03 CLIPPED," ",
                                  get_field_name("rvuconf"),":",l_rvu[l_i].rvuconf CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_rvu[l_i].rvu01
      LET g_tree[g_idx].treekey1 = l_rvu[l_i].rvu01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx 
      LET g_name[g_idx] = "apmt720"
      IF l_child > 0 THEN
         LET g_tree[g_idx].has_children = TRUE
         CALL q800_tree_fill2_rvv1(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,g_tree[l_idx].treekey2,l_rvu[l_i].rvu01)
      ELSE
         LET g_tree[g_idx].has_children = FALSE
      END IF
   END FOR    
END FUNCTION

FUNCTION q800_tree_fill2_rvv1(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_rvv             DYNAMIC ARRAY OF RECORD
             rvv01          LIKE rvv_file.rvv01,
             rvv02          LIKE rvv_file.rvv02,
             rvv17          LIKE rvv_file.rvv17,
             rvv35          LIKE rvv_file.rvv35
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_rvv02   STRING
   DEFINE l_rvv17   STRING
   LET g_sql="SELECT DISTINCT  rvv01,rvv02,rvv17,rvv35 ",					
             " FROM rvu_file,rvv_file",					
             " WHERE rvu01 = rvv01",					
             " AND rvu00 = '1'",				#入庫	
             " AND rvv01 = '",p_key3,"'",		#入庫單號	
             " AND rvv04 = '",p_key1,"'",		#收貨單號	
             " AND rvv05 = '",p_key2,"'"		#項次	
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT DISTINCT  rvv01,rvv02,rvv17,rvv35 ",					
             " FROM rvu_file,rvv_file",					
             " WHERE rvu01 = rvv01",					
             " AND rvu00 = '1'",				#入庫	
             " AND rvv01 = '",p_key3,"'",		#入庫單號	
             " AND rvv04 = '",p_key1,"'",		#收貨單號	
             " AND rvv05 = '",p_key2,"'",		#項次	
             " AND rvvplant IN ",g_auth
   END IF 	
         						               
   PREPARE q800_tree_pre10 FROM g_sql
   DECLARE q800_tree_cs10 CURSOR FOR q800_tree_pre10     

   LET l_index = 0      
   FOREACH q800_tree_cs10 INTO l_rvv[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      LET l_rvv02 = l_rvv[l_i].rvv02
      LET l_rvv17 = l_rvv[l_i].rvv17
      LET g_tree[g_idx].name = get_prog_name1("apm1040"),":",l_rvv[l_i].rvv01 CLIPPED," ",
                                  get_field_name("rvv02"),":",l_rvv02 CLIPPED," ",
                                  get_field_name("rvv17"),":",l_rvv17 CLIPPED," ",
                                  get_field_name("rvv35"),":",l_rvv[l_i].rvv35 CLIPPED
      LET g_tree[g_idx].level = p_level 
      LET g_tree[g_idx].pid = p_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_rvv[l_i].rvv01
      LET g_tree[g_idx].treekey1 = l_rvv[l_i].rvv01
      LET g_tree[g_idx].treekey2 = l_rvv[l_i].rvv02
      LET l_idx = g_idx
      LET g_tree[g_idx].has_children = FALSE
      LET g_name[g_idx] = "apmt720"
      CALL q800_tree_fill2_apa(p_wc,g_tree[l_idx].pid,p_level,g_tree[l_idx].path,
                               g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
   END FOR
END FUNCTION

FUNCTION q800_tree_fill2_apa(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_apa             DYNAMIC ARRAY OF RECORD
             apa01          LIKE apa_file.apa01,
             apa02          LIKE apa_file.apa02,
             apa63          LIKE apa_file.apa63,
             apa41          LIKE apa_file.apa41
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1044") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = p_pid
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".3"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   

   LET g_sql="SELECT DISTINCT  apa01,apa02,apa63,apa41",					
             " FROM apa_file,apb_file",					
             " WHERE apa01 = apb01",					
             " AND apa00 = '11'",				#進貨發票	
             " AND apb21 = '",p_key1,"'",		#入庫單號	
             " AND apb22 = '",p_key2,"'",		#項次	
             " AND apb29 = '1'"				    #進貨		
         						               
   PREPARE q800_tree_pre12 FROM g_sql
   DECLARE q800_tree_cs12 CURSOR FOR q800_tree_pre12     

   LET l_index = 0      
   FOREACH q800_tree_cs12 INTO l_apa[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
      LET l_idx = g_idx
      CALL q800_tree_fill2_apf(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                NULL)
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      SELECT COUNT(apb02) INTO l_child
      FROM apb_file
      WHERE apb01 = l_apa[l_i].apa01
      CASE l_apa[l_i].apa63
           WHEN  "1" 
              LET l_prog_name = "apa63_1"
           WHEN  "0"
              LET l_prog_name = "apa63_0"   
           WHEN  "9"
              LET l_prog_name = "apa63_9"   
           WHEN  "R"
              LET l_prog_name = "apa63_R"      
           WHEN  "S"
              LET l_prog_name = "apa63_S"      
           WHEN  "W"
              LET l_prog_name = "apa63_W"
      END CASE
      
      CALL  get_field_name1(l_prog_name,"aapt110") RETURNING  l_prog_name
      LET g_tree[g_idx].name = get_field_name("apa01"),":",l_apa[l_i].apa01 CLIPPED," ",
                                  get_field_name("apa02"),":",l_apa[l_i].apa02 CLIPPED," ",
                                  get_field_name("apa63"),":",l_apa[l_i].apa63 CLIPPED," ",".",l_prog_name CLIPPED," ",
                                  get_field_name("apa41"),":",l_apa[l_i].apa41 CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid

      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apa[l_i].apa01
      LET g_tree[g_idx].treekey1 = l_apa[l_i].apa01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx 
      LET g_name[g_idx] = "aapt110"
      IF l_child > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
         CALL q800_tree_fill2_apb(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,g_tree[l_idx].treekey2,l_apa[l_i].apa01)
      ELSE
         LET g_tree[l_idx].has_children = FALSE
      END IF
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill2_apb(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_apb             DYNAMIC ARRAY OF RECORD
             apb01          LIKE apb_file.apb01,
             apb02          LIKE apb_file.apb02,
             apb24          LIKE apb_file.apb24,
             apb10          LIKE apb_file.apb10
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_apb02 STRING
   DEFINE l_apb24 STRING
   DEFINE l_apb10 STRING
   LET g_sql="SELECT DISTINCT  apb01,apb02,apb24,apb10",					
             " FROM apa_file,apb_file",					
             " WHERE apa01 = apb01",					
             " AND apa00 = '11'",				#進貨發票	
             " AND apb01 = '",p_key3,"'",		#帳款編號	
             " AND apb21 = '",p_key1,"'",		#入庫單號	
             " AND apb22 = '",p_key2,"'",		#項次	
             " AND apb29 = '1'"				    #進貨	
   						               
   PREPARE q800_tree_pre13 FROM g_sql
   DECLARE q800_tree_cs13 CURSOR FOR q800_tree_pre13     

   LET l_index = 0      
   FOREACH q800_tree_cs13 INTO l_apb[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      LET l_apb02 = l_apb[l_i].apb02
      LET l_apb24 = l_apb[l_i].apb24
      LET l_apb10 = l_apb[l_i].apb10
      LET g_tree[g_idx].name = get_field_name("apb01"),":",l_apb[l_i].apb01 CLIPPED," ",
                                  get_field_name("apb02"),":",l_apb02 CLIPPED," ",
                                  get_field_name("apb24"),":",l_apb24 CLIPPED," ",
                                  get_field_name("apb10"),":",l_apb10 CLIPPED," "
      LET g_tree[g_idx].level = p_level 
      LET g_tree[g_idx].pid = p_pid

      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apb[l_i].apb01
      LET g_tree[g_idx].treekey1 = l_apb[l_i].apb01
      LET g_tree[g_idx].treekey2 = p_key2
      LET l_idx = g_idx
      LET g_tree[g_idx].has_children = FALSE
      LET g_name[g_idx] = "aapt110"
      CALL q800_tree_fill2_apf(p_wc,g_tree[l_idx].pid,p_level,g_tree[l_idx].path,
                               l_apb[l_i].apb01)
   END FOR
END FUNCTION

FUNCTION q800_tree_fill2_apf(p_wc,p_pid,p_level,p_path,p_key1)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_apf             DYNAMIC ARRAY OF RECORD
             apf01          LIKE apf_file.apf01,
             apf02          LIKE apf_file.apf02,
             apf10f         LIKE apf_file.apf10f,
             apf10          LIKE apf_file.apf10,
             apf42          LIKE apf_file.apf42,
             apf41          LIKE apf_file.apf41
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_apf10f  STRING
   DEFINE l_apf10  STRING

   CALL get_prog_name1("apm1045") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = p_pid
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".3"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   
   LET g_sql="SELECT DISTINCT apf01,apf02,apf10f,apf10,apf42,apf41",						
             " FROM apf_file,apg_file",						
             " WHERE apf01 = apg01",						
             " AND apf00 = '33'",				#付款		
             " AND apg04 = '",p_key1,"'"		#帳款編號		
	
   PREPARE q800_tree_pre14 FROM g_sql
   DECLARE q800_tree_cs14 CURSOR FOR q800_tree_pre14     

   LET l_index = 0      
   FOREACH q800_tree_cs14 INTO l_apf[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      LET l_apf10f = l_apf[l_i].apf10f
      LET l_apf10 = l_apf[l_i].apf10
       CASE l_apf[l_i].apf42
           WHEN  "1" 
              LET l_prog_name = "apf42_1"
           WHEN  "0"
              LET l_prog_name = "apf42_0"   
           WHEN  "9"
              LET l_prog_name = "apf42_9"   
           WHEN  "R"
              LET l_prog_name = "apf42_R"      
           WHEN  "S"
              LET l_prog_name = "apf42_S"      
           WHEN  "W"
              LET l_prog_name = "apf42_W"
      END CASE
      
      CALL  get_field_name1(l_prog_name,"aapt330") RETURNING  l_prog_name
      
      LET g_tree[g_idx].name = get_field_name("apf01"),":",l_apf[l_i].apf01 CLIPPED," ",
                                  get_field_name("apf02"),":",l_apf[l_i].apf02 CLIPPED," ",
                                  get_field_name("apf10f"),":",l_apf10f CLIPPED," ",
                                  get_field_name("apf10"),":",l_apf10 CLIPPED," ",
                                  get_field_name("apf42"),":",l_apf[l_i].apf42 CLIPPED," ",".",l_prog_name CLIPPED," ",
                                  get_field_name("apf41"),":",l_apf[l_i].apf41 CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apf[l_i].apf01
      LET g_tree[g_idx].treekey1 = l_apf[l_i].apf01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx 
      LET g_name[g_idx] = "aapt330"
      LET g_tree[g_idx].has_children = FALSE
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill2_rvu2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_rvu             DYNAMIC ARRAY OF RECORD
             rvu01          LIKE rvu_file.rvu01,
             rvu03          LIKE rvu_file.rvu03,
             rvuconf        LIKE rvu_file.rvuconf
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1046") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = p_pid
   LET g_tree[g_idx].name = l_prog_name CLIPPED 
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".1"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   

   LET g_sql="SELECT DISTINCT  rvu01,rvu03,rvuconf ",
             " FROM rvu_file,rvv_file ",   
             " WHERE rvu01 = rvv01 ",					
             " AND rvu00 = '2' ",				#驗退	
             " AND rvv04 = '",p_key1,"'",		#收貨單號
             " AND rvv05 = '",p_key2,"'"		#項次	
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT DISTINCT  rvu01,rvu03,rvuconf ",
             " FROM rvu_file,rvv_file ",   
             " WHERE rvu01 = rvv01 ",					
             " AND rvu00 = '2' ",				#驗退	
             " AND rvv04 = '",p_key1,"'",		#收貨單號
             " AND rvv05 = '",p_key2,"'",		#項次	
             " AND rvuplant IN ",g_auth
   END IF 	
         						               
   PREPARE q800_tree_pre9 FROM g_sql
   DECLARE q800_tree_cs9 CURSOR FOR q800_tree_pre9     

   LET l_index = 0      
   FOREACH q800_tree_cs9 INTO l_rvu[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      SELECT COUNT(*) INTO l_child
      FROM rvv_file
      WHERE rvv01 = l_rvu[l_i].rvu01
      LET g_tree[g_idx].name = get_prog_name1("apm1039"),":",l_rvu[l_i].rvu01 CLIPPED," ",
                                  get_field_name("rvu03"),":",l_rvu[l_i].rvu03 CLIPPED," ",
                                  get_field_name("rvuconf"),":",l_rvu[l_i].rvuconf CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_rvu[l_i].rvu01
      LET g_tree[g_idx].treekey1 = l_rvu[l_i].rvu01
      LET g_tree[g_idx].treekey2 = p_key2 
      
      LET l_idx = g_idx 
      LET g_name[g_idx] = "apmt721"
      IF l_child > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
         CALL q800_tree_fill2_rvv2(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,g_tree[l_idx].treekey2,l_rvu[l_i].rvu01)
      ELSE
         LET g_tree[l_idx].has_children = FALSE
      END IF
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill2_rvv2(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_rvv             DYNAMIC ARRAY OF RECORD
             rvv01          LIKE rvv_file.rvv01,
             rvv02          LIKE rvv_file.rvv02,
             rvv17          LIKE rvv_file.rvv17,
             rvv35          LIKE rvv_file.rvv35
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_rvv02 STRING
   DEFINE l_rvv17 STRING
   LET g_sql="SELECT DISTINCT  rvv01,rvv02,rvv17,rvv35 ",					
             " FROM rvu_file,rvv_file",					
             " WHERE rvu01 = rvv01",					
             " AND rvu00 = '2'",				#驗退	
             " AND rvv01 = '",p_key3,"'",		#驗退單號	
             " AND rvv04 = '",p_key1,"'",		#收貨單號	
             " AND rvv05 = '",p_key2,"'"		#項次	
	
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT DISTINCT  rvv01,rvv02,rvv17,rvv35 ",					
             " FROM rvu_file,rvv_file",					
             " WHERE rvu01 = rvv01",					
             " AND rvu00 = '2'",				#驗退	
             " AND rvv01 = '",p_key3,"'",		#驗退單號	
             " AND rvv04 = '",p_key1,"'",		#收貨單號	
             " AND rvv05 = '",p_key2,"'",		#項次	
             " AND rvvplant IN ",g_auth
   END IF 	      						               
   PREPARE q800_tree_pre11 FROM g_sql
   DECLARE q800_tree_cs11 CURSOR FOR q800_tree_pre11     

   LET l_index = 0      
   FOREACH q800_tree_cs11 INTO l_rvv[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      
      LET l_rvv02 = l_rvv[l_i].rvv02
      LET l_rvv17 = l_rvv[l_i].rvv17
      LET g_tree[g_idx].name = get_prog_name1("apm1039"),":",l_rvv[l_i].rvv01 CLIPPED," ",
                                  get_field_name("rvv02"),":",l_rvv02 CLIPPED," ",
                                  get_field_name("rvv17"),":",l_rvv17 CLIPPED," ",
                                  get_field_name("rvv35"),":",l_rvv[l_i].rvv35 CLIPPED
      LET g_tree[g_idx].level = p_level 
      LET g_tree[g_idx].pid = p_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_rvv[l_i].rvv01
      LET g_tree[g_idx].treekey1 = l_rvv[l_i].rvv01
      LET g_tree[g_idx].treekey2 = p_key2
      LET l_idx = g_idx
      LET g_name[g_idx] = "apmt721"
      LET g_tree[g_idx].has_children = FALSE
   END FOR
END FUNCTION

FUNCTION q800_tree_fill3(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_rvu             DYNAMIC ARRAY OF RECORD
             rvu01          LIKE rvu_file.rvu01,
             rvu03          LIKE rvu_file.rvu03,
             rvuconf        LIKE rvu_file.rvuconf
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1047") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = g_tree[p_pid].id
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".4"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   
   
   LET g_sql="SELECT DISTINCT  rvu01,rvu03,rvuconf ",
             " FROM rvu_file,rvv_file ",   
             " WHERE rvu01 = rvv01 ",					
             " AND rvu00 = '3' ",				#倉退	
             " AND rvv36 = '",p_key1,"'",		#採購單號	
             " AND rvv37 = '",p_key2,"'"		#項次	
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT DISTINCT  rvu01,rvu03,rvuconf ",
             " FROM rvu_file,rvv_file ",   
             " WHERE rvu01 = rvv01 ",					
             " AND rvu00 = '3' ",				#倉退	
             " AND rvv36 = '",p_key1,"'",		#採購單號	
             " AND rvv37 = '",p_key2,"'",		#項次	
             " AND rvuplant IN ",g_auth
   END IF 	    
         						               
   PREPARE q800_tree_pre5 FROM g_sql
   DECLARE q800_tree_cs5 CURSOR FOR q800_tree_pre5     

   LET l_index = 0      
   FOREACH q800_tree_cs5 INTO l_rvu[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
      LET l_idx = g_idx
      CALL q800_tree_fill3_apa(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                               g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      SELECT COUNT(*) INTO l_child
      FROM rvv_file
      WHERE rvv01 = l_rvu[l_i].rvu01
      LET g_tree[g_idx].name = get_prog_name1("apm1039"),":",l_rvu[l_i].rvu01 CLIPPED," ",
                                  get_field_name("rvu03"),":",l_rvu[l_i].rvu03 CLIPPED," ",
                                  get_field_name("rvuconf"),":",l_rvu[l_i].rvuconf CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str 
       
      LET g_tree[g_idx].path = p_path,".",l_rvu[l_i].rvu01
      LET g_tree[g_idx].treekey1 = l_rvu[l_i].rvu01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx 
      LET g_name[g_idx] = "apmt722"
      IF l_child > 0 THEN
         LET g_tree[g_idx].has_children = TRUE
         CALL q800_tree_fill3_rvv(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,p_key2,l_rvu[l_i].rvu01)
      ELSE
         LET g_tree[g_idx].has_children = FALSE
      END IF
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill3_rvv(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_rvv             DYNAMIC ARRAY OF RECORD
             rvv01          LIKE rvv_file.rvv01,
             rvv02          LIKE rvv_file.rvv02,
             rvv17          LIKE rvv_file.rvv17,
             rvv35          LIKE rvv_file.rvv35
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_rvv02 STRING
   DEFINE l_rvv17 STRING
   
   LET g_sql="SELECT DISTINCT  rvv01,rvv02,rvv17,rvv35 ",					
             " FROM rvu_file,rvv_file",					
             " WHERE rvu01 = rvv01",					
             " AND rvu00 = '3'",				#倉退	
             " AND rvv01 = '",p_key3,"'",		#驗退單號
             " AND rvv36 = '",p_key1,"'",		#採購單號
             " AND rvv37 = '",p_key2,"'"		#項次	
   IF g_azw.azw04='2' THEN 
      LET g_sql="SELECT DISTINCT  rvv01,rvv02,rvv17,rvv35 ",					
             " FROM rvu_file,rvv_file",					
             " WHERE rvu01 = rvv01",					
             " AND rvu00 = '3'",				#倉退	
             " AND rvv01 = '",p_key3,"'",		#驗退單號
             " AND rvv36 = '",p_key1,"'",		#採購單號
             " AND rvv37 = '",p_key2,"'",		#項次	
             " AND rvvplant IN ",g_auth
   END IF 	    
         						               
   PREPARE q800_tree_pre15 FROM g_sql
   DECLARE q800_tree_cs15 CURSOR FOR q800_tree_pre15     

   LET l_index = 0      
   FOREACH q800_tree_cs15 INTO l_rvv[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      
      LET l_rvv02 = l_rvv[l_i].rvv02
      LET l_rvv17 = l_rvv[l_i].rvv17
      LET g_tree[g_idx].name = get_prog_name1("apm1039"),":",l_rvv[l_i].rvv01 CLIPPED," ",
                                  get_field_name("rvv02"),":",l_rvv02 CLIPPED," ",
                                  get_field_name("rvv17"),":",l_rvv17 CLIPPED," ",
                                  get_field_name("rvv35"),":",l_rvv[l_i].rvv35 CLIPPED
      LET g_tree[g_idx].level = p_level 
      LET g_tree[g_idx].pid = p_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_rvv[l_i].rvv01
      LET g_tree[g_idx].treekey1 = l_rvv[l_i].rvv01
      LET g_tree[g_idx].treekey2 = l_rvv[l_i].rvv02
      LET l_idx = g_idx
      LET g_name[g_idx] = "apmt722"
      LET g_tree[g_idx].has_children = FALSE
      CALL q800_tree_fill3_apa(p_wc,g_tree[l_idx].pid,p_level,g_tree[l_idx].path,
                               g_tree[l_idx].treekey1,g_tree[l_idx].treekey2)
   END FOR
END FUNCTION

FUNCTION q800_tree_fill3_apa(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_apa             DYNAMIC ARRAY OF RECORD
             apa01          LIKE apa_file.apa01,
             apa02          LIKE apa_file.apa02,
             apa63          LIKE apa_file.apa63,
             apa41          LIKE apa_file.apa41
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1044") RETURNING l_prog_name
   
   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = p_pid
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".2"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   

   LET g_sql="SELECT DISTINCT  apa01,apa02,apa63,apa41",					
             " FROM apa_file,apb_file",					
             " WHERE apa01 = apb01",					
             " AND apa00 = '21'",				#進貨發票	
             " AND apb21 = '",p_key1,"'",		#倉退單號
             " AND apb22 = '",p_key2,"'",		#項次	
             " AND apb29 = '3'"				    #倉退	

	
         						               
   PREPARE q800_tree_pre16 FROM g_sql
   DECLARE q800_tree_cs16 CURSOR FOR q800_tree_pre16     

   LET l_index = 0      
   FOREACH q800_tree_cs16 INTO l_apa[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      SELECT COUNT(apb02) INTO l_child
      FROM apb_file
      WHERE apb01 = l_apa[l_i].apa01
       CASE l_apa[l_i].apa63
           WHEN  "1" 
              LET l_prog_name = "apa63_1"
           WHEN  "0"
              LET l_prog_name = "apa63_0"   
           WHEN  "9"
              LET l_prog_name = "apa63_9"   
           WHEN  "R"
              LET l_prog_name = "apa63_R"      
           WHEN  "S"
              LET l_prog_name = "apa63_S"      
           WHEN  "W"
              LET l_prog_name = "apa63_W"
      END CASE
      
      CALL  get_field_name1(l_prog_name,"aapt210") RETURNING  l_prog_name
      
      LET g_tree[g_idx].name = get_field_name("apa01"),":",l_apa[l_i].apa01 CLIPPED," ",
                                  get_field_name("apa02"),":",l_apa[l_i].apa02 CLIPPED," ",
                                  get_field_name("apa63"),":",l_apa[l_i].apa63 CLIPPED," ",".",l_prog_name CLIPPED," ",
                                  get_field_name("apa41"),":",l_apa[l_i].apa41 CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apa[l_i].apa01
      LET g_tree[g_idx].treekey1 = l_apa[l_i].apa01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx 
      LET g_name[g_idx] = "aapt210"
      IF l_child > 0 THEN
         LET g_tree[g_idx].has_children = TRUE
         CALL q800_tree_fill3_apb(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,g_tree[l_idx].treekey2,l_apa[l_i].apa01)
      ELSE
         LET g_tree[g_idx].has_children = FALSE
      END IF
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill3_apb(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_apb             DYNAMIC ARRAY OF RECORD
             apb01          LIKE apb_file.apb01,
             apb02          LIKE apb_file.apb02,
             apb24          LIKE apb_file.apb24,
             apb10          LIKE apb_file.apb10
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_apb02 STRING
   DEFINE l_apb24 STRING
   DEFINE l_apb10 STRING
   LET g_sql="SELECT DISTINCT  apb01,apb02,apb24,apb10",					
             " FROM apa_file,apb_file",					
             " WHERE apa01 = apb01",					
             " AND apa00 = '21'",				#進貨發票
             " AND apb01 = '",p_key3,"'",		#帳款編號	
             " AND apb21 = '",p_key1,"'",		#倉退單號
             " AND apb22 = '",p_key2,"'",		#項次	
             " AND apb29 = '3'"				    #倉退	
   						               
   PREPARE q800_tree_pre17 FROM g_sql
   DECLARE q800_tree_cs17 CURSOR FOR q800_tree_pre17     

   LET l_index = 0      
   FOREACH q800_tree_cs17 INTO l_apb[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      
      LET l_apb02 = l_apb[l_i].apb02
      LET l_apb24 = l_apb[l_i].apb24
      LET l_apb10 = l_apb[l_i].apb10
      LET g_tree[g_idx].name = get_field_name("apb01"),":",l_apb[l_i].apb01 CLIPPED," ",
                                  get_field_name("apb02"),":",l_apb02 CLIPPED," ",
                                  get_field_name("apb24"),":",l_apb24 CLIPPED," ",
                                  get_field_name("apb10"),":",l_apb10 CLIPPED," "
      LET g_tree[g_idx].level = p_level 
      LET g_tree[g_idx].pid = p_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apb[l_i].apb01
      LET g_tree[g_idx].treekey1 = l_apb[l_i].apb01
      LET g_tree[g_idx].treekey2 = l_apb[l_i].apb02
      LET l_idx = g_idx
      LET g_name[g_idx] = "aapt210"
      LET g_tree[g_idx].has_children = FALSE
   END FOR
END FUNCTION

FUNCTION q800_tree_fill4(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_apa             DYNAMIC ARRAY OF RECORD
             apa01          LIKE apa_file.apa01,
             apa02          LIKE apa_file.apa02,
             apa63          LIKE apa_file.apa63,
             apa41          LIKE apa_file.apa41
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   
   CALL get_prog_name1("apm1048") RETURNING l_prog_name

   LET g_idx = g_idx + 1
   LET g_tree[g_idx].pid = g_tree[p_pid].id
   LET g_tree[g_idx].name = l_prog_name CLIPPED
   LET g_tree[g_idx].id = g_tree[g_idx].pid,".5"     #因為訂單變更單是訂單單身下的第一個節點
   LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
   LET l_child_pid = g_tree[g_idx].id   

   LET g_sql="SELECT DISTINCT  apa01,apa02,apa63,apa41 ",					
            " FROM apa_file,apb_file ",					
            " WHERE apa01 = apb01 ",					
            " AND apa00 = '15' ",				#預付	
            " AND apb06 = '",p_key1,"' ",		#採購單號
            " AND apb07 = '",p_key2,"'"			#項次

   PREPARE q800_tree_pre6 FROM g_sql
   DECLARE q800_tree_cs6 CURSOR FOR q800_tree_pre6     

   LET l_index = 0      
   FOREACH q800_tree_cs6 INTO l_apa[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH             

   IF l_index > 0 THEN
      LET g_tree[g_idx].has_children = TRUE
   ELSE
      LET g_tree[g_idx].has_children = FALSE
   END IF
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿    
      SELECT COUNT(*) INTO l_child
      FROM apb_file
      WHERE apb01 = l_apa[l_i].apa01
       CASE l_apa[l_i].apa63
           WHEN  "1" 
              LET l_prog_name = "apa63_1"
           WHEN  "0"
              LET l_prog_name = "apa63_0"   
           WHEN  "9"
              LET l_prog_name = "apa63_9"   
           WHEN  "R"
              LET l_prog_name = "apa63_R"      
           WHEN  "S"
              LET l_prog_name = "apa63_S"      
           WHEN  "W"
              LET l_prog_name = "apa63_W"
      END CASE
      
      CALL  get_field_name1(l_prog_name,"aapt150") RETURNING  l_prog_name
      LET g_tree[g_idx].name = get_field_name("apa01"),":",l_apa[l_i].apa01 CLIPPED," ",
                                  get_field_name("apa02"),":",l_apa[l_i].apa02 CLIPPED," ",
                                  get_field_name("apa63"),":",l_apa[l_i].apa63 CLIPPED," ",".",l_prog_name CLIPPED," ",
                                  get_field_name("apa41"),":",l_apa[l_i].apa41 CLIPPED
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = l_child_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apa[l_i].apa01
      LET g_tree[g_idx].treekey1 = l_apa[l_i].apa01
      LET g_tree[g_idx].treekey2 = p_key2 
      LET l_idx = g_idx
      LET g_name[g_idx] = "aapt150"
      IF l_child > 0 THEN
         LET g_tree[g_idx].has_children = TRUE
         CALL q800_tree_fill4_apb(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                p_key1,p_key2,l_apa[l_i].apa01)
      ELSE
         LET g_tree[g_idx].has_children = FALSE
      END IF 
   END FOR    
   
END FUNCTION

FUNCTION q800_tree_fill4_apb(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_key3             STRING

   DEFINE l_apb             DYNAMIC ARRAY OF RECORD
             apb01          LIKE apb_file.apb01,
             apb02          LIKE apb_file.apb02,
             apb24          LIKE apb_file.apb24,
             apb10          LIKE apb_file.apb10
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING
   DEFINE l_apb02 STRING
   DEFINE l_apb24 STRING
   DEFINE l_apb10 STRING
   LET g_sql="SELECT DISTINCT  apb01,apb02,apb24,apb10",					
             " FROM apa_file,apb_file",					
             " WHERE apa01 = apb01",					
             " AND apa00 = '15'",				#預付
             " AND apb01 = '",p_key3,"'",		#帳款編號	
             " AND apb06 = '",p_key1,"'",		#採購單號
             " AND apb07 = '",p_key2,"'"		#項次	
   						               
   PREPARE q800_tree_pre18 FROM g_sql
   DECLARE q800_tree_cs18 CURSOR FOR q800_tree_pre18    

   LET l_index = 0      
   FOREACH q800_tree_cs18 INTO l_apb[l_index+1].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET l_index = l_index + 1
   END FOREACH  
   FOR l_i=1 TO l_index
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = p_pid
      LET l_str = l_i  #數值轉字串
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str 
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
      
      LET l_apb02 = l_apb[l_i].apb02
      LET l_apb24 = l_apb[l_i].apb24
      LET l_apb10 = l_apb[l_i].apb10
      LET g_tree[g_idx].name = get_field_name("apb01"),":",l_apb[l_i].apb01 CLIPPED," ",
                                  get_field_name("apb02"),":",l_apb02 CLIPPED," ",
                                  get_field_name("apb24"),":",l_apb24 CLIPPED," ",
                                  get_field_name("apb10"),":",l_apb10 CLIPPED," "
      LET g_tree[g_idx].level = p_level 
      LET g_tree[g_idx].pid = p_pid
       
      LET g_tree[g_idx].id = g_tree[g_idx].pid ,".",l_str         
      LET g_tree[g_idx].path = p_path,".",l_apb[l_i].apb01
      LET g_tree[g_idx].treekey1 = l_apb[l_i].apb01
      LET g_tree[g_idx].treekey2 = l_apb[l_i].apb02
      LET l_idx = g_idx
      LET g_name[g_idx] = "aapt150"
      LET g_tree[g_idx].has_children = FALSE
   END FOR
END FUNCTION

##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/05 
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION q800_tree_update()
   #Tree重查並展開focus節鹿  
   CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充                     #依tree path指定focus節鹿   
   CALL q800_tree_open(g_tree_focus_idx)             #展開節鹿   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單踿   
   ELSE
      LET g_tree_b = "Y"
   END IF
   CALL q800_q(g_tree_focus_idx)
END FUNCTION
###FUN-A50010 END ###

##################################################
# Descriptions...: 依key指定focus節鹿
##################################################
FUNCTION q800_tree_idxbykey()   
DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 1
   FOR l_idx = 1 TO g_tree.getLength()
      IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey1 == g_pmm[l_ac].pmm01) CLIPPED THEN  # 尋找節鹿        
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
END FUNCTION

FUNCTION q800_gen02()
   DEFINE l_genacti       LIKE gen_file.genacti
   LET g_errno = ' '
   SELECT gen02 INTO g_pmm[l_ac].gen02
       FROM gen_file
       WHERE gen01 = g_pmm[l_ac].pmm12
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'aoo-005'
           LET g_pmm[l_ac].gen02 = NULL
        OTHERWISE          
           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

##################################################
# Descriptions...: 展開節鹿
# Date & Author..: 10/05/05
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION q800_tree_open(p_idx)
   DEFINE p_idx        LIKE type_file.num10  #index
   DEFINE l_pid        STRING                #父節id
   DEFINE l_openpidx   LIKE type_file.num10  #展開父index
   DEFINE l_arrlen     LIKE type_file.num5   #array length
   DEFINE l_i          LIKE type_file.num5

   LET l_openpidx = 0
   LET l_arrlen = g_tree.getLength()

   IF p_idx > 0 THEN
      IF g_tree[p_idx].has_children THEN
         LET g_tree[p_idx].expanded = TRUE   #TRUE:展開, FALSE:不展锿      
      END IF
      LET l_pid = g_tree[p_idx].pid
      IF p_idx > 1 THEN
         #找父節點的index
         FOR l_i=p_idx TO 1 STEP -1
            IF g_tree[l_i].id = l_pid THEN
               LET l_openpidx = l_i
               EXIT FOR
            END IF
         END FOR
         #展開父節鹿       
           IF (l_openpidx > 0) AND (NOT cl_null(g_tree[p_idx].path)) THEN
            CALL q800_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION q800_pmc02()
   DEFINE l_pmcacti       LIKE pmc_file.pmcacti
   LET g_errno = ' '
   SELECT pmc02 INTO g_pmm[l_ac].pmc02
   FROM pmc_file
   WHERE pmc01 = g_pmm[l_ac].pmm09
   CASE WHEN SQLCA.SQLCODE = 100  
           LET g_errno = 'aoo-005'
           LET g_pmm[l_ac].pmc02 = NULL
        OTHERWISE          
           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION q800_show()
    CALL q800_b_fill(g_wc)             #單身
    CALL cl_show_fld_cont()           
END FUNCTION

FUNCTION get_field_name(p_field_code)
   DEFINE p_field_code STRING
   DEFINE l_sql        STRING,
          l_gaq03      LIKE gaq_file.gaq03

   LET l_sql = "SELECT gaq03 FROM gaq_file",
               " WHERE gaq01='",p_field_code,"' AND gaq02='",g_lang,"'"
   DECLARE gaq_curs SCROLL CURSOR FROM l_sql
   OPEN gaq_curs
   FETCH FIRST gaq_curs INTO l_gaq03
   CLOSE gaq_curs

   RETURN l_gaq03 CLIPPED
END FUNCTION

FUNCTION get_prog_name(p_prog_code)
   DEFINE p_prog_code STRING
   DEFINE l_sql       STRING,
          l_gaz03     LIKE gaz_file.gaz03

   LET l_sql = "SELECT gaz03 FROM gaz_file",
               " WHERE gaz01='",p_prog_code,"' AND gaz02='",g_lang,"'"
   DECLARE gaz_curs SCROLL CURSOR FROM l_sql
   OPEN gaz_curs
   FETCH FIRST gaz_curs INTO l_gaz03
   CLOSE gaz_curs

   RETURN l_gaz03 CLIPPED
END FUNCTION

FUNCTION get_prog_name1(p_prog_code)
   DEFINE p_prog_code STRING
   DEFINE l_sql       STRING,
          l_ze03      LIKE ze_file.ze03

   LET l_sql = "SELECT ze03 FROM ze_file",
               " WHERE ze01='",p_prog_code,"' AND ze02='",g_lang,"'"
   DECLARE ze_curs SCROLL CURSOR FROM l_sql
   OPEN ze_curs
   FETCH FIRST ze_curs INTO l_ze03
   CLOSE ze_curs

   RETURN l_ze03 CLIPPED
END FUNCTION

FUNCTION get_field_name1(p_field_code,p_prog_code)
   DEFINE p_field_code STRING
   DEFINE p_prog_code STRING
   DEFINE l_sql        STRING,
          l_gae04      LIKE gae_file.gae04
   LET l_sql = "SELECT gae04 FROM gae_file",
               " WHERE gae02='",p_field_code,"' AND gae01='",p_prog_code,"' AND gae03='",g_lang,"'"
   DECLARE gae_curs SCROLL CURSOR FROM l_sql
   OPEN gae_curs
   FETCH FIRST gae_curs INTO l_gae04
   CLOSE gae_curs

   RETURN l_gae04 CLIPPED
END FUNCTION

FUNCTION q800_run(p_index)
  DEFINE p_index       STRING
  DEFINE l_cmd              LIKE type_file.chr1000 
  CASE g_name[p_index]
     WHEN "apmt540"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "apmt540 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt540_slk '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "apmt540_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE       
     WHEN "apmt910"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "apmt910 '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt910_slk '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "apmt910 '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE 
     WHEN "apmt110"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "apmt110 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt110 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "apmt110_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE 
     WHEN "apmt720"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "apmt720 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt720 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "apmt720_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE 
     WHEN "aapt110"
        LET l_cmd = "aapt110 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
     WHEN "aapt330"
        LET l_cmd = "aapt330 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
     WHEN "apmt721"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "apmt721 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt721 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "apmt721_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE 
     WHEN "apmt722"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "apmt722 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt722 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "apmt722_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
     WHEN "aapt210"
        LET l_cmd = "aapt210 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
     WHEN "aapt150"
        LET l_cmd = "aapt150 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
  END CASE
END FUNCTION
