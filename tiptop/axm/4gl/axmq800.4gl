# Prog. Version..: '5.30.06-13.03.19(00002)'     #
#
# Pattern name...: axmq800.4gl
# Descriptions...: 訂單追蹤查詢
# Date & Author..: FUN-A50010 10/05/05 By dxfwo
# Modify.........: No.FUN-A50010 10/05/05 by dxfwo 
# Modify.........: No.MOD-CC0116 13/01/29 By Elise (1) FOR l_i=1 TO l_index中不需要再增加LET l_i = l_i + 1
#                                                  (2) PREPARE q800_tree_pre3的SQL請依變更版本oep02排序
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-980025
DEFINE 
    g_oea           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oea01       LIKE oea_file.oea01,  
        oea02       LIKE oea_file.oea02,
        oea00       LIKE oea_file.oea00,
        oea08       LIKE oea_file.oea08,
        oea03       LIKE oea_file.oea03,
        occ02       LIKE occ_file.occ02,
        oea14       LIKE oea_file.oea14,
        gen02       LIKE gen_file.gen02,
        oeaconf     LIKE oea_file.oeaconf,
        oeb03       LIKE oeb_file.oeb03,
        oeb04       LIKE oeb_file.oeb04,
        oeb06       LIKE oeb_file.oeb06 
                    END RECORD,
    g_buf           LIKE ima_file.ima01,        
    g_oea_t         RECORD                 #程式變數 (舊便
        oea01       LIKE oea_file.oea01,  
        oea02       LIKE oea_file.oea02,
        oea00       LIKE oea_file.oea00,
        oea08       LIKE oea_file.oea08,
        oea03       LIKE oea_file.oea03,
        occ02       LIKE occ_file.occ02,
        oea14       LIKE oea_file.oea14,
        gen02       LIKE gen_file.gen02,
        oeaconf     LIKE oea_file.oeaconf,
        oeb03       LIKE oeb_file.oeb03,
        oeb04       LIKE oeb_file.oeb04,
        oeb06       LIKE oeb_file.oeb06 
                    END RECORD,
    g_wc,g_sql,g_wc2    STRING,  
    g_rec_b         LIKE type_file.num5,            #單身筆數         
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT    
DEFINE p_row,p_col     LIKE type_file.num5 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_msg           LIKE type_file.chr1000 
DEFINE g_jump          LIKE type_file.num10
DEFINE g_row_count     LIKE type_file.num10 
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_cnt           LIKE type_file.num10   
DEFINE mi_no_ask       LIKE type_file.num5           
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE g_oeb03         LIKE oeb_file.oeb03        
###FUN-A50010 START ###
DEFINE g_wc_o            STRING                #g_wc舊值備乿
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
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
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_name DYNAMIC ARRAY OF STRING
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整玿Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路弿check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路弿check loop)
###FUN-A50010 END ###
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5           #No.FUN-A50010   SMALLINT 

   OPTIONS                               #改變一些系統預設便   
   INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鋿 由程式處玿 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time               
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q800_w AT p_row,p_col WITH FORM "axm/42f/axmq800"
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
   DEFINE l_index            STRING 
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   ###FUN-A50010 END ###
   WHILE TRUE

      ###FUN-A50010 START ###
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)

      #讓各個交談指令可以互剿      
      DIALOG ATTRIBUTES(UNBUFFERED)
#---chenmoyan
         DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_ac = ARR_CURR()
               LET g_row_count= ARR_COUNT()
               CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_oea[l_ac].oea01,g_oea[l_ac].oeb03)
               CALL cl_show_fld_cont()

            #double click tree node
#           ON ACTION accept
#              CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_oea[l_ac].oea01,g_oea[l_ac].oeb03)
                                   
            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

            &include "qry_string.4gl"
         END DISPLAY
#---chenmoyan
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正砿               #因為double click tree node弿focus tree的節點會改變
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF

               #以最上層的id當作單頭的g_curs_index
#              CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               LET g_curs_index = l_curs_index
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 
               CALL DIALOG.setSelectionMode( "tree", 1 )  # FUN-A50010
               CALL Dialog.setCurrentRow("tree", l_tree_arr_curr)
            #double click tree node
#            ON ACTION accept
#               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
#               #有子節點就focus在此，沒有子節點就focus在它的父節鹿               
#               IF g_tree[l_tree_arr_curr].has_children THEN
#                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
#               ELSE
#                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
#                  IF l_i > 1 THEN
#                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
#                  END IF
#                  CALL q800_tree_idxbypath()   #依tree path指定focus節鹿               
#               END IF
#
#               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
#               CALL q800_q(l_tree_arr_curr)
             
         END DISPLAY


#        DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b)
#           BEFORE DISPLAY
#              CALL cl_navigator_setting( g_curs_index, g_row_count )

#           BEFORE ROW
#              LET l_ac = ARR_CURR()
#              CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_oea[l_ac].oea01,g_oea[l_ac].oeb03)
#              CALL cl_show_fld_cont()

#           #double click tree node
#           ON ACTION accept
#              CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_oea[l_ac].oea01,g_oea[l_ac].oeb03)

#           AFTER DISPLAY
#              CONTINUE DIALOG   #因為外層是DIALOG

#           &include "qry_string.4gl"
#        END DISPLAY

         BEFORE DIALOG
            
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")                   
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)  
            END IF

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET l_ac = ARR_CURR()  
           CALL q800_tree_fill(g_wc_o,NULL,0,NULL,
                               g_oea[l_ac].oea01,g_oea[l_ac].oeb03)
            
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

          ON ACTION detailed
            LET g_action_choice="detailed" 
            EXIT DIALOG 
            
         #相關文件
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
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q800_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "detailed"
            IF cl_chk_act_auth() THEN  
                LET l_index=l_tree_arr_curr       
                CALL q800_run(l_index)
            END IF
            
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_oea[l_ac].oea01 IS NOT NULL THEN
                  LET g_doc.column1 = "abd01"
                  LET g_doc.value1 = g_oea[l_ac].oea01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 

FUNCTION q800_q(p_idx)      #FUN-A50010 加參數p_idx
DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index
    CALL q800_b_askkey(p_idx)
END FUNCTION

FUNCTION q800_show()

    DISPLAY g_oea[l_ac].oea01 TO oea01           #單頭
    CALL q800_b_fill(g_wc)             #單身

    CALL cl_show_fld_cont()            #No:FUN-550037 hmf
END FUNCTION
###FUN-A50010 END ###
 
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
               LET l_wc = "oea01='",g_tree[p_idx].treekey1 CLIPPED
            ELSE
               LET l_wc = "oea01='",g_tree[p_idx].treekey1 CLIPPED,"'",
                          " AND oeb03='",g_tree[p_idx].treekey2 CLIPPED,"'"
            END IF
         END IF
      END IF
   END IF
   ###FUN-A50010 END ###

   CLEAR FORM                             #清除畫面
   CALL g_oea.clear()    

   IF p_idx = 0 THEN   #FUN-A50010
      CONSTRUCT g_wc2 ON oea01,oea02,oea00,oea08,oea03,oea14,oeaconf,oeb03,oeb04,oeb06
                FROM s_oea[1].oea01,s_oea[1].oea02,s_oea[1].oea00,s_oea[1].oea08,       #螢幕上取條件
                     s_oea[1].oea03,s_oea[1].oea14,s_oea[1].oeaconf,s_oea[1].oeb03,
                     s_oea[1].oeb04,s_oea[1].oeb06
                BEFORE CONSTRUCT
                   CALL cl_qbe_init()

        ON ACTION controlp
         CASE
           WHEN INFIELD(oea01) #查詢單据             
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_oea01_7" 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea01
              NEXT FIELD oea01
           WHEN INFIELD(oea03)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              IF g_aza.aza50='Y' THEN
                 LET g_qryparam.form ="q_occ3"
              ELSE
                 LET g_qryparam.form ="q_occ"
              END IF
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           WHEN INFIELD(oea14)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gen"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea14
              NEXT FIELD oea14
           WHEN INFIELD(oeb04)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              IF g_aza.aza50='Y' THEN
                 LET g_qryparam.form ="q_ima15"   #FUN-610055
              ELSE 
                 LET g_qryparam.form ="q_ima"   #FUN-610055
              END IF
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oeb04
              NEXT FIELD oeb04 
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
   ###FUN-A50010 START ###
   ELSE
      LET g_wc2 = l_wc CLIPPED
   END IF

   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
   IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
      LET g_wc_o = g_wc2 CLIPPED
   END IF
   ###FUN-A50010 END ###   
  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL q800_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION q800_b_fill(p_wc2)              
   DEFINE p_wc2   LIKE type_file.chr1000       
 
   LET g_sql = " SELECT DISTINCT oea01,oea02,oea00,oea08,oea03,oea032,oea14,'',oeaconf,",
               " oeb03,oeb04,oeb06",   
               "  FROM oea_file,oeb_file",
               " WHERE oea01 = oeb01 AND oeaplant = oebplant ",
               "   AND (oea901 = 'N' OR oea901 IS NULL) ",  
               "   AND oeaplant IN ",g_auth CLIPPED," AND  ",p_wc2 CLIPPED,                     #單身
               " ORDER BY oea01"
   PREPARE q800_pb FROM g_sql
   DECLARE oea_curs CURSOR FOR q800_pb
 
   CALL g_oea.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH oea_curs INTO g_oea[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
      LET g_oeb03 = g_oea[g_cnt].oeb03
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oea.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
   CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_oea[1].oea01,g_oea[1].oeb03) 
END FUNCTION
 
FUNCTION q800_out()
 
END FUNCTION
 
FUNCTION q800_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) ) THEN
       CALL cl_set_comp_entry("oea01",TRUE)
    END IF                                                                                                 
                                                                                              
END FUNCTION  
               
FUNCTION q800_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                    
                                                                                
    IF p_cmd = 'u' AND ( NOT g_before_input_done )  THEN                                                             
      CALL cl_set_comp_entry("oea01",FALSE)                                                                                       
    END IF
 
END FUNCTION            

###FUN-A50010 START ###
##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/05
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
FUNCTION q800_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單單號
   DEFINE p_key2             STRING               #項次
   DEFINE l_n                STRING
   DEFINE l_oea             DYNAMIC ARRAY OF RECORD
             oea01           LIKE oea_file.oea01,
             oea02           LIKE oea_file.oea02,
             oea03           LIKE oea_file.oea03,   
             occ02           LIKE occ_file.occ02  #子節點數
             END RECORD
   DEFINE l_oeb             DYNAMIC ARRAY OF RECORD 
             oeb01           LIKE oeb_file.oeb01,
             oeb03           LIKE oeb_file.oeb03,
             oeb04           LIKE oeb_file.oeb04,
             oeb06           LIKE oeb_file.oeb06,
             oeb12           LIKE oeb_file.oeb12, 
             oeb05           LIKE oeb_file.oeb05,
             oeb16           LIKE oeb_file.oeb16
             END RECORD                    
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5   
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_ima02            LIKE ima_file.ima021 
  
   LET max_level = 20 #設定最大階層數瀿0

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_oea.clear()

      #讓QBE出來的單頭都當作Tree的最上層
      LET g_sql=" SELECT DISTINCT oea01,oea02,oea03,occ02 FROM oea_file ",  						
                "   LEFT OUTER JOIN occ_file ON oea03 = occ01 ",						
                "  WHERE oea01 = '",p_key1,"'"						               
      IF g_azw.azw04 = '2' THEN 
         LET g_sql=" SELECT DISTINCT oea01,oea02,oea03,occ02 FROM oea_file ",  						
                   "   LEFT OUTER JOIN occ_file ON oea03 = occ01 ",						
                   "  WHERE oea01 = '",p_key1,"'",
                   "    AND oeaplant IN ",g_auth	
      END IF               		      
      PREPARE q800_tree_pre1 FROM g_sql
      DECLARE q800_tree_cs1 CURSOR FOR q800_tree_pre1      

      LET l_i = 1      
      FOREACH q800_tree_cs1 INTO l_oea[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF         
         SELECT COUNT(oeb03) INTO l_child FROM oeb_file
          WHERE oeb01 = l_oea[l_i].oea01 
            
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name = get_field_name("oeb01"),":",l_oea[l_i].oea01 CLIPPED," ",
                                  get_prog_name1("axm-483"),":",l_oea[l_i].oea02 CLIPPED," ",
                                  get_field_name("oea03"),":",l_oea[l_i].oea03 CLIPPED,"(",
                                  l_oea[l_i].occ02 CLIPPED,")"
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_oea[l_i].oea01
         LET g_tree[g_idx].treekey1 = l_oea[l_i].oea01
         LET g_tree[g_idx].treekey2 = p_key2
         LET g_name[g_idx] = "axmt410"
         #有子節鹿         
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
      IF p_level > max_level THEN
         CALL cl_err_msg("","aoo1001",max_level,0)
         RETURN
      END IF

      LET g_sql= " SELECT oeb01,oeb03,oeb04,oeb06,oeb12,oeb05,oeb16 ",						
                 "   FROM oeb_file ",						
                 "  WHERE oeb01 = '",p_key1,"' ",						
                 "    AND oeb03 = '",p_key2,"' ",
                 "    AND oebplant IN ",g_auth 						           
      PREPARE q800_tree_pre2 FROM g_sql
      DECLARE q800_tree_cs2 CURSOR FOR q800_tree_pre2

      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_oea.clear()
      FOREACH q800_tree_cs2 INTO l_oeb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF

         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_oea.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿      
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            SELECT ima02 INTO l_ima02 FROM ima_file
             WHERE ima01 = l_oeb[l_i].oeb04 
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = FALSE    #T  #TRUE:展開, FALSE:不展锿           
            LET l_n = l_oeb[l_i].oeb12 
               LET g_tree[g_idx].name = get_field_name("oeb01"),":",l_oeb[l_i].oeb01 CLIPPED,' ',
                                        get_field_name("oeb03"),":",l_oeb[l_i].oeb03 USING "<<<<<<",' ',
                                        get_field_name("oeb04"),":",l_oeb[l_i].oeb04 CLIPPED,"(",l_ima02,")",' ',
                                        get_field_name("oeb12"),":",l_n,' ',
                                        l_oeb[l_i].oeb05 CLIPPED,' ',
                                        get_field_name("oeb16"),":",l_oeb[l_i].oeb16 CLIPPED
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_oeb[l_i].oeb01   
            LET g_tree[g_idx].treekey1 = l_oeb[l_i].oeb01
            LET g_tree[g_idx].treekey2 = l_oeb[l_i].oeb03
            LET g_name[g_idx] = "axmt410"
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
               CALL q800_tree_fill4(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                   g_tree[l_idx].treekey1,g_tree[l_idx].treekey2) 
               CALL q800_tree_fill9(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                  g_tree[l_idx].treekey1,g_tree[l_idx].treekey2) 
               CALL q800_tree_fill17(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                   g_tree[l_idx].treekey1,g_tree[l_idx].treekey2) 
               CALL q800_tree_fill19(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                   g_tree[l_idx].treekey1,g_tree[l_idx].treekey2) 
               CALL q800_tree_fill21(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
                                   g_tree[l_idx].treekey1,g_tree[l_idx].treekey2) 
               CALL q800_tree_fill23(p_wc,g_tree[l_idx].id,p_level,g_tree[l_idx].path,
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
   DEFINE p_key1             STRING               #訂單單號
   DEFINE p_key2             STRING               #項次

   DEFINE l_oep             DYNAMIC ARRAY OF RECORD
             oep01           LIKE oep_file.oep01,
             oep02           LIKE oep_file.oep02,
             oep04           LIKE oep_file.oep04,
             oep12           LIKE oep_file.oep12,
             oepconf         LIKE oep_file.oepconf,
             oep09           LIKE oep_file.oep09 
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axmt800(訂單變更單)的程式名稱
      CALL get_prog_name1("axm-484") RETURNING l_prog_name

      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED      
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".2"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      #取得訂單變更單相關資訊
      LET g_sql=" SELECT DISTINCT oep01,oep02,oep04,oep12,oepconf,oep09 FROM oep_file, ",  						
                "  oeq_file ",						
                "  WHERE oep01 = oeq01",
                "    AND oep01 = '",p_key1,"'",
                "    AND oeq03 = '",p_key2,"'", 
                "    AND oepplant IN ",g_auth, #MOD-CC0116 add ,                						               
                "    ORDER BY oep02 "          #MOD-CC0116 add
      PREPARE q800_tree_pre3 FROM g_sql
      DECLARE q800_tree_cs3 CURSOR FOR q800_tree_pre3      

      LET l_index = 0
            
      FOREACH q800_tree_cs3 INTO l_oep[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx         
      END IF
      LET g_idx = l_idx
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       

         CASE l_oep[l_i].oep09
           WHEN  "0"
              LET l_prog_name = "oep09_0" 
           WHEN  "1"             
              LET l_prog_name = "oep09_1"
           WHEN  "2"             
              LET l_prog_name = "oep09_2"      
           WHEN  "R"             
              LET l_prog_name = "oep09_R"      
           WHEN  "S"             
              LET l_prog_name = "oep09_S"      
           WHEN  "W"             
              LET l_prog_name = "oep09_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"axmt800") RETURNING  l_prog_name             
         LET g_tree[l_idx].name = get_field_name("oep01"),":",l_oep[l_i].oep01 CLIPPED," ",
                                  get_prog_name1("axm-481"),":",l_oep[l_i].oep02 USING "<<<<<<<<"," ",
                                  get_field_name("oep04"),":",l_oep[l_i].oep04 CLIPPED," ",
                                  get_field_name("oep12"),":",l_oep[l_i].oep12 CLIPPED," ",
                                  get_field_name("oepconf"),":",l_oep[l_i].oepconf CLIPPED," ",
                                  get_field_name("oep09"),":",l_oep[l_i].oep09,".",l_prog_name CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid ,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_oep[l_i].oep01
         LET g_tree[l_idx].treekey1 = l_oep[l_i].oep01
         LET g_tree[l_idx].treekey2 = l_oep[l_i].oep02 
         LET g_idx = l_idx 
         LET g_name[g_idx] = "axmt800"
        #LET l_i = l_i + 1   #MOD-CC0116 mark             
      END FOR    

END FUNCTION

FUNCTION q800_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_oga             DYNAMIC ARRAY OF RECORD
             oga01           LIKE oga_file.oga01,
             oga02           LIKE oga_file.oga02,
             oga55           LIKE oga_file.oga55,
             ogaconf         LIKE oga_file.ogaconf 
             END RECORD

   DEFINE l_ogb             DYNAMIC ARRAY OF RECORD
             ogb01           LIKE ogb_file.ogb01,
             ogb03           LIKE ogb_file.ogb03,
             ogb12           LIKE ogb_file.ogb12,
             ogb05           LIKE ogb_file.ogb05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axmt610(出貨通知單)的程式名稱
      CALL get_prog_name1("axm-485") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".3"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT oga01,oga02,oga55,ogaconf FROM oga_file, ",  						
                "  ogb_file ",						
                "  WHERE oga01 = ogb01",
                "    AND oga09 = '1' ",
                "    AND ogb31 = '",p_key1,"'",
                "    AND ogb32 = '",p_key2,"'",
                "    AND ogaplant IN ",g_auth                 						               
      PREPARE q800_tree_pre4 FROM g_sql
      DECLARE q800_tree_cs4 CURSOR FOR q800_tree_pre4      

      LET l_index = 0
            
      FOREACH q800_tree_cs4 INTO l_oga[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx        
      END IF
      LET g_idx = l_idx 
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_oga[l_i].oga55
           WHEN  "1" 
              LET l_prog_name = "oga55_1"
           WHEN  "0"
              LET l_prog_name = "oga55_0"      
           WHEN  "R"
              LET l_prog_name = "oga55_R"      
           WHEN  "S"
              LET l_prog_name = "oga55_S"      
           WHEN  "W"
              LET l_prog_name = "oga55_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"axmt620") RETURNING  l_prog_name                                      
         LET g_tree[l_idx].name = get_prog_name1("axm-478"),":",l_oga[l_i].oga01 CLIPPED," ",
                                  get_prog_name1("axm-479"),":",l_oga[l_i].oga02 CLIPPED," ",
                                  get_field_name("oga55"),":",l_oga[l_i].oga55 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_prog_name1("axm-480"),":",l_oga[l_i].ogaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_oga[l_i].oga01
         LET g_tree[l_idx].treekey1 = l_oga[l_i].oga01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx 
         LET g_name[g_idx] = "axmt610"
         CALL q800_tree_fill3(p_wc,g_tree[l_idx].id,p_level,g_tree[g_idx].path,
                             g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key2)                                 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill3(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #出貨通知單
   DEFINE p_key2             STRING               #訂單單號 
   DEFINE p_key3             STRING               #項次 
   DEFINE l_ogb             DYNAMIC ARRAY OF RECORD
             ogb01           LIKE ogb_file.ogb01,
             ogb03           LIKE ogb_file.ogb03,
             ogb12           LIKE ogb_file.ogb12,
             ogb05           LIKE ogb_file.ogb05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT ogb01,ogb03,ogb12,ogb05 FROM oga_file, ",  						
                "  ogb_file ",						
                "  WHERE oga01 = ogb01",
                "    AND oga01 = '",p_key1,"'",
                "    AND oga09 = '1' ",
                "    AND ogb31 = '",p_key2,"'",
                "    AND ogb32 = '",p_key3,"'",
                "    AND ogbplant IN ",g_auth                 						               
      PREPARE q800_tree_pre5 FROM g_sql
      DECLARE q800_tree_cs5 CURSOR FOR q800_tree_pre5      

      LET l_i = 1
            
      FOREACH q800_tree_cs5 INTO l_ogb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
         LET l_n = l_ogb[l_i].ogb12  
         LET g_tree[g_idx].name = get_prog_name1("axm-478"),":",l_ogb[l_i].ogb01 CLIPPED," ",
                                  get_field_name("ogb03") CLIPPED,":",l_ogb[l_i].ogb03 USING "<<<<<<"," ",
                                  get_field_name("ogb12") CLIPPED,":",l_n," ",
                                  l_ogb[l_i].ogb05 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_ogb[l_i].ogb01
         LET g_tree[g_idx].treekey1 = l_ogb[l_i].ogb01
         LET g_tree[g_idx].treekey2 = p_key3
         LET g_name[g_idx] = "axmt610"        
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill4(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單單號
   DEFINE p_key2             STRING               #項次

   DEFINE l_oga             DYNAMIC ARRAY OF RECORD
             oga01           LIKE oga_file.oga01,
             oga02           LIKE oga_file.oga02,
             oga55           LIKE oga_file.oga55,
             ogaconf         LIKE oga_file.ogaconf 
             END RECORD  
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axmt620(出貨單)的程式名稱
      CALL get_prog_name1("axm-486") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED  
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".4"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT oga01,oga02,oga55,ogaconf FROM oga_file, ",  						
                "  ogb_file ",						
                "  WHERE oga01 = ogb01",
                "    AND oga09 = '2' ",
                "    AND ogb31 = '",p_key1,"'",
                "    AND ogb32 = '",p_key2,"'"
      IF g_azw.azw04 = '2' THEN 
         LET g_sql=" SELECT DISTINCT oga01,oga02,oga55,ogaconf FROM oga_file, ",  						
                   "  ogb_file ",						
                   "  WHERE oga01 = ogb01",
                   "    AND oga09 = '2' ",
                   "    AND ogb31 = '",p_key1,"'",
                   "    AND ogb32 = '",p_key2,"'",
                   "    AND ogaplant IN ",g_auth
      END IF                                                 						               
      PREPARE q800_tree_pre6 FROM g_sql
      DECLARE q800_tree_cs6 CURSOR FOR q800_tree_pre6      

      LET l_index = 0
            
      FOREACH q800_tree_cs6 INTO l_oga[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx
         CALL q800_tree_fill6(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,
                              p_key1,p_key2)         
      END IF
      LET g_idx = l_idx
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         LET l_child = 0    
         SELECT COUNT(*) INTO l_child 
         FROM ogb_file
         WHERE ogb01 = l_oga[l_i].oga01
         CASE l_oga[l_i].oga55
           WHEN  "1" 
              LET l_prog_name = "oga55_1"
           WHEN  "0"
              LET l_prog_name = "oga55_0"      
           WHEN  "R"
              LET l_prog_name = "oga55_R"      
           WHEN  "S"
              LET l_prog_name = "oga55_S"      
           WHEN  "W"
              LET l_prog_name = "oga55_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"axmt620") RETURNING  l_prog_name             
         LET g_tree[l_idx].name = get_field_name("oga01"),":",l_oga[l_i].oga01 CLIPPED," ",
                                  get_field_name("oga02"),":",l_oga[l_i].oga02 CLIPPED," ",
                                  get_field_name("oga55"),":",l_oga[l_i].oga55 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_prog_name1("axm-480"),":",l_oga[l_i].ogaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_oga[l_i].oga01
         LET g_tree[l_idx].treekey1 = l_oga[l_i].oga01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx 
         LET g_name[g_idx] = "axmt620"
         IF l_child > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL q800_tree_fill5(p_wc,g_tree[l_idx].id,p_level,g_tree[g_idx].path,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key2)                                 
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill5(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #出貨單
   DEFINE p_key2             STRING               #訂單單號
   DEFINE p_key3             STRING               #項次
   DEFINE l_ogb             DYNAMIC ARRAY OF RECORD
             ogb01           LIKE ogb_file.ogb01,
             ogb03           LIKE ogb_file.ogb03,
             ogb12           LIKE ogb_file.ogb12,
             ogb05           LIKE ogb_file.ogb05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT ogb01,ogb03,ogb12,ogb05 FROM oga_file, ",  						
                "  ogb_file ",						
                "  WHERE oga01 = ogb01",
                "    AND oga01 = '",p_key1,"'",
                "    AND oga09 = '2' ",
                "    AND ogb31 = '",p_key2,"'",
                "    AND ogb32 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2'  THEN   
         LET g_sql=" SELECT DISTINCT ogb01,ogb03,ogb12,ogb05 FROM oga_file, ",  						
                   "  ogb_file ",						
                   "  WHERE oga01 = ogb01",
                   "    AND oga01 = '",p_key1,"'",
                   "    AND oga09 = '2' ",
                   "    AND ogb31 = '",p_key2,"'",
                   "    AND ogb32 = '",p_key3,"'",
                   "    AND ogbplant IN ",g_auth
      END IF                   
      PREPARE q800_tree_pre7 FROM g_sql
      DECLARE q800_tree_cs7 CURSOR FOR q800_tree_pre7      

      LET l_i = 1
            
      FOREACH q800_tree_cs7 INTO l_ogb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n = l_ogb[l_i].ogb12  
         LET g_tree[g_idx].name = get_field_name("ogb01"),":",l_ogb[l_i].ogb01 CLIPPED," ",
                                  get_field_name("ogb03"),":",l_ogb[l_i].ogb03 USING "<<<<<<"," ",
                                  get_field_name("ogb12"),":",l_n," ",
                                l_ogb[l_i].ogb05 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_ogb[l_i].ogb01
         LET g_tree[g_idx].treekey1 = l_ogb[l_i].ogb01
         LET g_tree[g_idx].treekey2 = l_ogb[l_i].ogb03
         LET g_name[g_idx] = "axmt620"
         LET l_i = l_i+1
         CALL q800_tree_fill6(p_wc,g_tree[g_idx].pid,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key2,p_key3)
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill6(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3,p_key4)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #出貨單
   DEFINE p_key2             STRING               #出貨單項次
   DEFINE p_key3             STRING               #訂單單號 
   DEFINE p_key4             STRING               #訂單項次

   DEFINE l_oma             DYNAMIC ARRAY OF RECORD
             oma01           LIKE oma_file.oma01,
             oma00           LIKE oma_file.oma00,
             oma02           LIKE oma_file.oma02,
             omaconf         LIKE oma_file.omaconf 
             END RECORD

   DEFINE l_ogb             DYNAMIC ARRAY OF RECORD
             ogb01           LIKE ogb_file.ogb01,
             ogb03           LIKE ogb_file.ogb03,
             ogb12           LIKE ogb_file.ogb12,
             ogb05           LIKE ogb_file.ogb05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axrt300(應收賬款)的程式名稱
      CALL get_prog_name1("axm-487") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED       
      LET g_tree[l_idx].pid = p_pid
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".2"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT oma01,oma00,oma52,omaconf FROM oma_file, ",  						
                "  omb_file ",						
                "  WHERE oma01 = omb01",
                "    AND oma00 IN ('12','13' )",
                "    AND omb31 = '",p_key1,"'",
                "    AND omb32 = '",p_key2,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT oma01,oma00,oma52,omaconf FROM oma_file, ",  						
                   "  omb_file ",						
                   "  WHERE oma01 = omb01",
                   "    AND oma00 IN ('12','13' )",
                   "    AND omb31 = '",p_key1,"'",
                   "    AND omb32 = '",p_key2,"'",
                   "    AND omaplant IN ",g_auth 
      END IF                       
      PREPARE q800_tree_pre8 FROM g_sql
      DECLARE q800_tree_cs8 CURSOR FOR q800_tree_pre8      

      LET l_index = 0
            
      FOREACH q800_tree_cs8 INTO l_oma[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
         LET g_idx = l_idx 
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx 
         CALL q800_tree_fill8(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,p_key3,p_key4)         
      END IF
     
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_oma[l_i].oma00
           WHEN  "11"
              LET l_prog_name = "oma00_11" 
           WHEN  "12"             
              LET l_prog_name = "oma00_12"
           WHEN  "13"             
              LET l_prog_name = "oma00_13"      
           WHEN  "14"             
              LET l_prog_name = "oma00_1"      
           WHEN  "15"             
              LET l_prog_name = "oma00_15"      
           WHEN  "16"             
              LET l_prog_name = "oma00_16"
           WHEN  "17"             
              LET l_prog_name = "oma00_17"
           WHEN  "18"             
              LET l_prog_name = "oma00_18"
           WHEN  "21"             
              LET l_prog_name = "oma00_21"                            
           WHEN  "22"             
              LET l_prog_name = "oma00_22"
           WHEN  "23"             
              LET l_prog_name = "oma00_23"
           WHEN  "24"             
              LET l_prog_name = "oma00_24"
           WHEN  "25"             
              LET l_prog_name = "oma00_25"
           WHEN  "26"             
              LET l_prog_name = "oma00_26"
           WHEN  "27"             
              LET l_prog_name = "oma00_27"
           WHEN  "31"             
              LET l_prog_name = "oma00_31"              
         END CASE
         CALL  get_field_name1(l_prog_name,"axrt300") RETURNING  l_prog_name             
         LET g_tree[l_idx].name = get_field_name("oma01"),":",l_oma[l_i].oma01 CLIPPED," ",
                                  get_field_name("oma00"),":",l_oma[l_i].oma00 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_field_name("oma02"),":",l_oma[l_i].oma02 CLIPPED," ",
                                  get_field_name("omaconf"),":",l_oma[l_i].omaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_oma[l_i].oma01
         LET g_tree[l_idx].treekey1 = l_oma[l_i].oma01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx
         LET g_name[g_idx] = "axrt300"
         CALL q800_tree_fill7(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,
                              p_key2,p_key3,p_key4)
        #LET l_i = l_i + 1   #MOD-CC0116 mark                                                   
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill7(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3,p_key4,p_key5)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #應收單頭單號 
   DEFINE p_key2             STRING               #出貨單號
   DEFINE p_key3             STRING               #出貨單項次
   DEFINE p_key4             STRING               #訂單單號
   DEFINE p_key5             STRING               #訂單項次
   DEFINE l_omb             DYNAMIC ARRAY OF RECORD
             omb01           LIKE omb_file.omb01,
             omb03           LIKE omb_file.omb03,
             omb12           LIKE omb_file.omb12,
             omb05           LIKE omb_file.omb05,
             omb18t          LIKE omb_file.omb18t
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING 
   DEFINE l_n1               STRING 
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT omb01,omb03,omb12,omb05,omb18t FROM oma_file, ",  						
                "  omb_file ",						
                "  WHERE oma01 = omb01",
                "    AND oma00 IN ('12','13') ",
                "    AND omb01 = '",p_key1,"'",
                "    AND omb31 = '",p_key2,"'",
                "    AND omb32 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2' THEN 
         LET g_sql=" SELECT DISTINCT omb01,omb03,omb12,omb05,omb18t FROM oma_file, ",  						
                   "  omb_file ",						
                   "  WHERE oma01 = omb01",
                   "    AND oma00 IN ('12','13') ",
                   "    AND omb01 = '",p_key1,"'",
                   "    AND omb31 = '",p_key2,"'",
                   "    AND omb32 = '",p_key3,"'" ,
                   "    AND ombplant IN",g_auth
      END IF                        
      PREPARE q800_tree_pre9 FROM g_sql
      DECLARE q800_tree_cs9 CURSOR FOR q800_tree_pre9      

      LET l_i = 1
            
      FOREACH q800_tree_cs9 INTO l_omb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n  = l_omb[l_i].omb12
         LET l_n1 = l_omb[l_i].omb18t   
         LET g_tree[g_idx].name = get_field_name("oma01"),":",l_omb[l_i].omb01 CLIPPED," ",
                                  get_field_name("omb03"),":",l_omb[l_i].omb03 USING "<<<<<<<<"," ",
                                  get_field_name("omb12"),":",l_n CLIPPED," ",
                                  get_field_name("omb05"),":",l_omb[l_i].omb05 CLIPPED," ",
                                  get_field_name("omb18t"),":",l_n1 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_omb[l_i].omb01
         LET g_tree[g_idx].treekey1 = p_key1
         LET l_i = l_i + 1
         LET g_name[g_idx] = "axrt300"
         CALL q800_tree_fill8(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,p_key4,p_key5)         
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill8(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #應收賬款單號
   DEFINE p_key2             STRING               #訂單單號
   DEFINE p_key3             STRING               #項次
   DEFINE l_ooa             DYNAMIC ARRAY OF RECORD
             ooa01           LIKE ooa_file.ooa01,
             ooa02           LIKE ooa_file.ooa02,
             ooa34           LIKE ooa_file.ooa34,
             ooaconf         LIKE ooa_file.ooaconf 
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axrt400(收款沖帳單)的程式名稱
      CALL get_prog_name1("axm-492") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED   
      LET g_tree[l_idx].pid = p_pid
      IF  cl_null(p_key1)  THEN  
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".1"
      ELSE    
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".2"
      END IF          
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT ooa01,ooa02,ooa34,ooaconf FROM ooa_file, ",  						
                "  oob_file ",						
                "  WHERE ooa01 = oob01",
                "    AND oob03 = '2' ",
                "    AND oob04 = '1' ",
                "    AND oob06 = '",p_key1,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT ooa01,ooa02,ooa34,ooaconf FROM ooa_file, ",  						
                   "  oob_file ",						
                   "  WHERE ooa01 = oob01",
                   "    AND oob03 = '2' ",
                   "    AND oob04 = '1' ",
                   "    AND oob06 = '",p_key1,"'",
                   "    AND ooaplant IN",g_auth
      END IF                       
      PREPARE q800_tree_pre10 FROM g_sql
      DECLARE q800_tree_cs10 CURSOR FOR q800_tree_pre10      

      LET l_index = 0
            
      FOREACH q800_tree_cs10 INTO l_ooa[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             
      
      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
         LET g_idx = l_idx
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx      
      END IF
      
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_ooa[l_i].ooa34
           WHEN  "0"
              LET l_prog_name = "ooa34_0" 
           WHEN  "1"             
              LET l_prog_name = "ooa34_1"
           WHEN  "9"             
              LET l_prog_name = "ooa34_9"      
           WHEN  "R"             
              LET l_prog_name = "ooa34_R"      
           WHEN  "S"             
              LET l_prog_name = "ooa34_S"      
           WHEN  "W"             
              LET l_prog_name = "ooa34_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"axrt400") RETURNING  l_prog_name             
         LET g_tree[l_idx].name = get_field_name("ooa01"),":",l_ooa[l_i].ooa01 CLIPPED," ",
                                  get_field_name("ooa02"),":",l_ooa[l_i].ooa02 CLIPPED," ",
                                  get_field_name("ooa34"),":",l_ooa[l_i].ooa34 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_field_name("ooaconf"),":",l_ooa[l_i].ooaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_ooa[l_i].ooa01
         LET g_tree[l_idx].treekey1 = l_ooa[l_i].ooa01
         LET g_tree[l_idx].treekey2 = p_key3
         LET g_idx = l_idx 
         LET g_name[g_idx] = "axrt400"                                 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill9(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單單號 
   DEFINE p_key2             STRING               #項次 

   DEFINE l_oha             DYNAMIC ARRAY OF RECORD
             oha01           LIKE oha_file.oha01,
             oha02           LIKE oha_file.oha02,
             oha55           LIKE oha_file.oha55,
             oha09           LIKE oha_file.oha09,
             ohaconf         LIKE oha_file.ohaconf 
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_oha09            LIKE oha_file.oha09
   
      #取得axmt700(銷退單)的程式名稱
      CALL get_prog_name1("axm-488") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED      
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".5"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT oha01,oha02,oha55,oha09,ohaconf FROM oha_file, ",  						
                "  ohb_file ",						
                "  WHERE oha01 = ohb01",
                "    AND oha05 = '1' ",
                "    AND ohb33 = '",p_key1,"'",
                "    AND ohb34 = '",p_key2,"'"                 						               
      IF g_azw.azw04 = '2' THEN 
         LET g_sql=" SELECT DISTINCT oha01,oha02,oha55,oha09,ohaconf FROM oha_file, ",  						
                   "  ohb_file ",						
                   "  WHERE oha01 = ohb01",
                   "    AND oha05 = '1' ",
                   "    AND ohb33 = '",p_key1,"'",
                   "    AND ohb34 = '",p_key2,"'",
                   "    AND ohaplant IN ",g_auth
      END IF                         
      PREPARE q800_tree_pre11 FROM g_sql
      DECLARE q800_tree_cs11 CURSOR FOR q800_tree_pre11     

      LET l_index = 0
            
      FOREACH q800_tree_cs11 INTO l_oha[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx 
         CALL q800_tree_fill12(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key1,p_key2)
      END IF
      LET g_idx = l_idx
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿          
         CASE l_oha[l_i].oha55
           WHEN  "0"
              LET l_prog_name = "oha55_0" 
           WHEN  "1"             
              LET l_prog_name = "oha55_1"
           WHEN  "9"             
              LET l_prog_name = "oha55_9"      
           WHEN  "R"             
              LET l_prog_name = "oha55_R"      
           WHEN  "S"             
              LET l_prog_name = "oha55_S"      
           WHEN  "W"             
              LET l_prog_name = "oha55_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"axmt700") RETURNING  l_prog_name 
         LET g_tree[l_idx].name = get_field_name("oha01"),":",l_oha[l_i].oha01 CLIPPED," ",
                                  get_field_name("oha02"),":",l_oha[l_i].oha02 CLIPPED," ",
                                  get_field_name("oha55"),":",l_oha[l_i].oha55 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_field_name("ohaconf"),":",l_oha[l_i].ohaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_oha[l_i].oha01         
         LET g_tree[l_idx].treekey1 = l_oha[l_i].oha01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx
         LET g_name[g_idx] = "axmt700"
         CALL q800_tree_fill11(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,
                              p_key2,l_oha[l_i].oha09)                                          
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill11(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3,p_key4)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #銷退單
   DEFINE p_key2             STRING               #訂單單號
   DEFINE p_key3             STRING               #項次
   DEFINE p_key4             LIKE oha_file.oha09  #銷退方式
   DEFINE l_ohb             DYNAMIC ARRAY OF RECORD
             ohb01           LIKE ohb_file.ohb01,
             ohb03           LIKE ohb_file.ohb03,
             ohb12           LIKE ohb_file.ohb12,
             ohb05           LIKE ohb_file.ohb05
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT ohb01,ohb03,ohb12,ohb05 FROM oha_file, ",  						
                "  ohb_file ",						
                "  WHERE oha01 = ohb01",
                "    AND oha05 = '1' ",
                "    AND oha01 = '",p_key1,"'",
                "    AND ohb33 = '",p_key2,"'",
                "    AND ohb34 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2' THEN 
         LET g_sql=" SELECT DISTINCT ohb01,ohb03,ohb12,ohb05 FROM oha_file, ",  						
                   "  ohb_file ",						
                   "  WHERE oha01 = ohb01",
                   "    AND oha05 = '1' ",
                   "    AND oha01 = '",p_key1,"'",
                   "    AND ohb33 = '",p_key2,"'",
                   "    AND ohb34 = '",p_key3,"'",
                   "    AND ohbplant IN",g_auth
      END IF                        
      PREPARE q800_tree_pre12 FROM g_sql
      DECLARE q800_tree_cs12 CURSOR FOR q800_tree_pre12      

      LET l_i = 1
            
      FOREACH q800_tree_cs12 INTO l_ohb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n = l_ohb[l_i].ohb12   
         LET g_tree[g_idx].name = get_field_name("ohb01"),":",l_ohb[l_i].ohb01 CLIPPED," ",
                                  get_field_name("ohb03"),":",l_ohb[l_i].ohb03 USING "<<<<<<<"," ",
                                  get_field_name("ohb12"),":",l_n CLIPPED," ",
                                  l_ohb[l_i].ohb05 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str    #1.5.1.1     
         LET g_tree[g_idx].path = p_path,".",l_ohb[l_i].ohb01
         LET g_tree[g_idx].treekey1 = p_key1
         LET g_tree[g_idx].treekey2 = p_key3
         LET l_i = l_i + 1
         LET g_name[g_idx] = "axmt700"
         CALL q800_tree_fill12(p_wc,g_tree[g_idx].pid,p_level,g_tree[g_idx].path,
                              p_key1,p_key2,g_tree[g_idx].treekey2,p_key4)
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill12(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3,p_key4)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #銷退單
   DEFINE p_key2             STRING               #訂單
   DEFINE p_key3             STRING               #項次 
   DEFINE p_key4             LIKE oha_file.oha09  #銷退方式
   DEFINE l_oea             DYNAMIC ARRAY OF RECORD
             oea01           LIKE oea_file.oea01,
             oea02           LIKE oea_file.oea02,
             oea49           LIKE oea_file.oea49,
             oeaconf         LIKE oea_file.oeaconf 
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axmt410(銷退單)的程式名稱
      CALL get_prog_name1("axm-476") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED      
      LET g_tree[l_idx].pid = p_pid
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".2"       #1.5.1.2
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      IF p_key4 = '2'  THEN   
         #取得出貨通知單相關資訊
         LET g_sql=" SELECT DISTINCT oea01,oea02,oea49,oeaconf FROM ",  						
                   "  oea_file ",						
                   "  WHERE oea00 = '2'",
                   "    AND oea12 = '",p_key1,"'"                						               
         IF g_azw.azw04 = '2' THEN 
            LET g_sql=" SELECT DISTINCT oea01,oea02,oea49,oeaconf FROM ",  						
                      "  oea_file ",						
                      "  WHERE oea00 = '2'",
                      "    AND oea12 = '",p_key1,"'",
                      "    AND oeaplant IN ",g_auth
         END IF                 
         PREPARE q800_tree_pre13 FROM g_sql
         DECLARE q800_tree_cs13 CURSOR FOR q800_tree_pre13     
         
         LET l_index = 0
               
         FOREACH q800_tree_cs13 INTO l_oea[l_index+1].*
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF 
            LET l_index = l_index + 1
         END FOREACH             
         
         IF l_index > 0 THEN
            LET g_tree[l_idx].has_children = TRUE
            LET g_idx = l_idx
         ELSE
            LET g_tree[l_idx].has_children = FALSE
            LET g_idx = l_idx
            CALL q800_tree_fill14(p_wc,g_tree[g_idx].pid,p_level,g_tree[g_idx].path,
                                  p_key1,p_key3,p_key2)            
         END IF
         FOR l_i=1 TO l_index
            LET l_idx = g_idx + 1
            LET l_str = l_i  #數值轉字串
            LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
            CASE l_oea[l_i].oea49
              WHEN  "0"
                 LET l_prog_name = "oea49_0" 
              WHEN  "1"             
                 LET l_prog_name = "oea49_1"    
              WHEN  "R"             
                 LET l_prog_name = "oea49_R"      
              WHEN  "S"             
                 LET l_prog_name = "oea49_S"      
              WHEN  "W"             
                 LET l_prog_name = "oea49_W"
            END CASE
            CALL  get_field_name1(l_prog_name,"axmt410") RETURNING  l_prog_name                
            LET g_tree[l_idx].name = get_prog_name1("axm-476"),":",l_oea[l_i].oea01 CLIPPED," ",
                                     get_field_name("oea02"),":",l_oea[l_i].oea02 CLIPPED," ",
                                     get_field_name("oea49"),":",l_oea[l_i].oea49 CLIPPED,".",l_prog_name," ",
                                     get_field_name("oeaconf"),":",l_oea[l_i].oeaconf CLIPPED
            LET g_tree[l_idx].level = p_level
            LET g_tree[l_idx].pid = l_child_pid
            LET l_str = l_i
            LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
            LET g_tree[l_idx].path = p_path,".",l_oea[l_i].oea01         
            LET g_tree[l_idx].treekey1 = l_oea[l_i].oea01
            LET g_tree[l_idx].treekey2 = p_key3
            LET g_idx = l_idx
            LET g_name[g_idx] = "axmt410"
            CALL q800_tree_fill13(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key1)                                          
         END FOR   
      ELSE 
      	 LET g_idx = l_idx 
         CALL q800_tree_fill14(p_wc,g_tree[g_idx].pid,p_level,g_tree[g_idx].path,
                              p_key1,p_key2,p_key3)
       END IF                              	    
END FUNCTION

FUNCTION q800_tree_fill13(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單
   DEFINE p_key2             STRING               #項次
   DEFINE p_key3             STRING               #銷退單
   DEFINE l_oeb             DYNAMIC ARRAY OF RECORD
             oeb01           LIKE oeb_file.oeb01,
             oeb03           LIKE oeb_file.oeb03,
             oeb12           LIKE oeb_file.oeb12,
             oeb05           LIKE oeb_file.oeb05,
             oeb16           LIKE oeb_file.oeb16
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT  oeb01,oeb03,oeb12,oeb05,oeb16 FROM oea_file, ",  						
                "  oeb_file ",						
                "  WHERE oea01 = oeb01",
                "    AND oea00 = '2' ",
                "    AND oea01 = '",p_key1,"'"               						               
      IF g_azw.azw04 = '2' THEN  
         LET g_sql=" SELECT DISTINCT  oeb01,oeb03,oeb12,oeb05,oeb16 FROM oea_file, ",  						
                   "  oeb_file ",						
                   "  WHERE oea01 = oeb01",
                   "    AND oea00 = '2' ",
                   "    AND oea01 = '",p_key1,"'",
                   "    AND oebplant IN",g_auth 
      END IF                      
      PREPARE q800_tree_pre14 FROM g_sql
      DECLARE q800_tree_cs14 CURSOR FOR q800_tree_pre14      

      LET l_i = 1
            
      FOREACH q800_tree_cs14 INTO l_oeb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n = l_oeb[l_i].oeb12  
         LET g_tree[g_idx].name = get_prog_name1("axm-476"),":",l_oeb[l_i].oeb01 CLIPPED," ",
                                  get_field_name("oeb03"),":",l_oeb[l_i].oeb03 USING "<<<<<<<<"," ",
                                  get_field_name("oeb12"),":",l_n CLIPPED," ",
                                  get_field_name("oeb05"),":",l_oeb[l_i].oeb05 CLIPPED," ",
                                  get_field_name("oeb16"),":",l_oeb[l_i].oeb16 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_oeb[l_i].oeb01
         LET g_tree[g_idx].treekey1 = p_key1    #訂單
         LET g_tree[g_idx].treekey2 = p_key2    #項次
         LET l_i = l_i + 1
         LET g_name[g_idx] = "axmt410"
         CALL q800_tree_fill14(p_wc,'1.5.1',p_level,g_tree[g_idx].path,
                              p_key3,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill14(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #銷退單
   DEFINE p_key2             STRING               #訂單
   DEFINE p_key3             STRING               #項次
   DEFINE l_oma             DYNAMIC ARRAY OF RECORD
             oma01           LIKE oma_file.oma01,
             oma00           LIKE oma_file.oma00,
             oma02           LIKE oma_file.oma02,
             omaconf         LIKE oma_file.omaconf 
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axrt300(應收賬款)的程式名稱
      CALL get_prog_name1("axm-487") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = p_pid
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".3"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT oma01,oma00,oma02,omaconf FROM oma_file, ",  						
                "  omb_file ",						
                "  WHERE oma01 = omb01",
                "    AND oma00 IN ('21','25' )",
                "    AND omb31 = '",p_key1,"'",
                "    AND omb32 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2' THEN 
         LET g_sql=" SELECT DISTINCT oma01,oma00,oma02,omaconf FROM oma_file, ",  						
                   "  omb_file ",						
                   "  WHERE oma01 = omb01",
                   "    AND oma00 IN ('21','25' )",
                   "    AND omb31 = '",p_key1,"'",
                   "    AND omb32 = '",p_key3,"'",
                   "    AND omaplant IN ",g_auth   
      END IF                    
      PREPARE q800_tree_pre15 FROM g_sql
      DECLARE q800_tree_cs15 CURSOR FOR q800_tree_pre15      

      LET l_index = 0
            
      FOREACH q800_tree_cs15 INTO l_oma[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
         LET g_idx = l_idx
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx
         CALL q800_tree_fill16(p_wc,'1.5.3',p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,p_key2,p_key3)         
      END IF
      
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_oma[l_i].oma00
           WHEN  "11"
              LET l_prog_name = "oma00_11" 
           WHEN  "12"             
              LET l_prog_name = "oma00_12"
           WHEN  "13"             
              LET l_prog_name = "oma00_13"      
           WHEN  "14"             
              LET l_prog_name = "oma00_1"      
           WHEN  "15"             
              LET l_prog_name = "oma00_15"      
           WHEN  "16"             
              LET l_prog_name = "oma00_16"
           WHEN  "17"             
              LET l_prog_name = "oma00_17"
           WHEN  "18"             
              LET l_prog_name = "oma00_18"
           WHEN  "21"             
              LET l_prog_name = "oma00_21"                            
           WHEN  "22"             
              LET l_prog_name = "oma00_22"
           WHEN  "23"             
              LET l_prog_name = "oma00_23"
           WHEN  "24"             
              LET l_prog_name = "oma00_24"
           WHEN  "25"             
              LET l_prog_name = "oma00_25"
           WHEN  "26"             
              LET l_prog_name = "oma00_26"
           WHEN  "27"             
              LET l_prog_name = "oma00_27"
           WHEN  "31"             
              LET l_prog_name = "oma00_31"              
         END CASE
         CALL  get_field_name1(l_prog_name,"axrt300") RETURNING  l_prog_name            
         LET g_tree[l_idx].name = get_field_name("oma01"),":",l_oma[l_i].oma01 CLIPPED," ",
                                  get_field_name("oma00"),":",l_oma[l_i].oma00 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_field_name("oma02"),":",l_oma[l_i].oma02 CLIPPED," ",
                                  get_field_name("omaconf"),":",l_oma[l_i].omaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i 
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str   #1.5.1.3.1      
         LET g_tree[l_idx].path = p_path,".",l_oma[l_i].oma01
         LET g_tree[l_idx].treekey1 = l_oma[l_i].oma01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx 
         LET g_name[g_idx] = "axrt300"
         CALL q800_tree_fill15(p_wc,g_tree[l_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,
                              p_key3,p_key2)                                 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill15(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3,p_key4)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #應收單頭
   DEFINE p_key2             STRING               #銷退單號
   DEFINE p_key3             STRING               #項次
   DEFINE p_key4             STRING               #訂單 
   DEFINE l_omb             DYNAMIC ARRAY OF RECORD
             omb01           LIKE omb_file.omb01,
             omb03           LIKE omb_file.omb03,
             omb12           LIKE omb_file.omb12,
             omb05           LIKE omb_file.omb05,
             omb18t          LIKE omb_file.omb18t
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_n1               STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT omb01,omb03,omb12,omb05,omb18t FROM oma_file, ",  						
                "  omb_file ",						
                "  WHERE oma01 = omb01",
                "    AND oma00 IN ('21','25') ",
                "    AND omb01 = '",p_key1,"'",
                "    AND omb31 = '",p_key2,"'",
                "    AND omb32 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT omb01,omb03,omb12,omb05,omb18t FROM oma_file, ",  						
                   "  omb_file ",						
                   "  WHERE oma01 = omb01",
                   "    AND oma00 IN ('21','25') ",
                   "    AND omb01 = '",p_key1,"'",
                   "    AND omb31 = '",p_key2,"'",
                   "    AND omb32 = '",p_key3,"'",
                   "    AND ombplant IN ",g_auth
      END IF                      
      PREPARE q800_tree_pre16 FROM g_sql
      DECLARE q800_tree_cs16 CURSOR FOR q800_tree_pre16      

      LET l_i = 1
            
      FOREACH q800_tree_cs16 INTO l_omb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n  = l_omb[l_i].omb12   
         LET l_n1 = l_omb[l_i].omb12   
         LET g_tree[g_idx].name = get_field_name("oma01"),":",l_omb[l_i].omb01 CLIPPED," ",
                                  get_field_name("omb03"),":",l_omb[l_i].omb03 USING "<<<<<<<<"," ",
                                  get_field_name("omb12"),":",l_n CLIPPED," ",
                                  get_field_name("omb05"),":",l_omb[l_i].omb05 CLIPPED," ",
                                  get_field_name("omb18t"),":",l_n1 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str  #1.5.1.3.1.1       
         LET g_tree[g_idx].path = p_path,".",l_omb[l_i].omb01
         LET g_tree[g_idx].treekey1 = p_key1
         LET g_tree[g_idx].treekey2 = p_key3
         LET l_i = l_i + 1
         LET g_name[g_idx] = "axrt300"
         CALL q800_tree_fill16(p_wc,g_tree[g_idx].pid,p_level,g_tree[g_idx].path,
                              p_key1,p_key4,g_tree[g_idx].treekey2)
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill16(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #帳單單號
   DEFINE p_key2             STRING               #訂單
   DEFINE p_key3             STRING               #項次 
   DEFINE l_ooa             DYNAMIC ARRAY OF RECORD
             ooa01           LIKE ooa_file.ooa01,
             ooa02           LIKE ooa_file.ooa02,
             ooa34           LIKE ooa_file.ooa34,
             ooaconf         LIKE ooa_file.ooaconf 
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axrt400(應收賬款)的程式名稱
      CALL get_prog_name1("axm-492") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = p_pid
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".2"      #1.5.1.3.1.2
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT  ooa01,ooa02,ooa34,ooaconf FROM ooa_file, ",  						
                "  oob_file ",						
                "  WHERE ooa01 = oob01",
                "    AND oob03 = '1' ",
                "    AND oob04 = '3' ",
                "    AND oob06 = '",p_key1,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT  ooa01,ooa02,ooa34,ooaconf FROM ooa_file, ",  						
                   "  oob_file ",						
                   "  WHERE ooa01 = oob01",
                   "    AND oob03 = '1' ",
                   "    AND oob04 = '3' ",
                   "    AND oob06 = '",p_key1,"'",
                   "    AND ooaplant IN ",g_auth
      END IF                     
      PREPARE q800_tree_pre17 FROM g_sql
      DECLARE q800_tree_cs17 CURSOR FOR q800_tree_pre17      

      LET l_index = 0
            
      FOREACH q800_tree_cs17 INTO l_ooa[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx         
      END IF
      LET g_idx = l_idx  
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_ooa[l_i].ooa34
           WHEN  "0"
              LET l_prog_name = "ooa34_0" 
           WHEN  "1"             
              LET l_prog_name = "ooa34_1"
           WHEN  "9"             
              LET l_prog_name = "ooa34_9"      
           WHEN  "R"             
              LET l_prog_name = "ooa34_R"      
           WHEN  "S"             
              LET l_prog_name = "ooa34_S"      
           WHEN  "W"             
              LET l_prog_name = "ooa34_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"axrt400") RETURNING  l_prog_name             
         LET g_tree[l_idx].name = get_field_name("ooa01"),":",l_ooa[l_i].ooa01 CLIPPED," ",
                                  get_field_name("ooa02"),":",l_ooa[l_i].ooa02 CLIPPED," ",
                                  get_field_name("ooa34"),":",l_ooa[l_i].ooa34 CLIPPED,".",l_prog_name CLIPPED," ",
                                  get_field_name("ooaconf"),":",l_ooa[l_i].ooaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str  #1.5.1.3.1.2.1       
         LET g_tree[l_idx].path = p_path,".",l_ooa[l_i].ooa01
         LET g_tree[l_idx].treekey1 = l_ooa[l_i].ooa01
         LET g_tree[l_idx].treekey2 = p_key3
         LET g_idx = l_idx    
         LET g_name[g_idx] = "axrt400"                           
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill17(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單
   DEFINE p_key2             STRING               #項次
   DEFINE l_oma             DYNAMIC ARRAY OF RECORD
             oma01           LIKE oma_file.oma01,
             oma00           LIKE oma_file.oma00,
             oma02           LIKE oma_file.oma02,
             omaconf         LIKE oma_file.omaconf 
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得axrt300(應收賬款)的程式名稱
      CALL get_prog_name1("axm-477") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".6"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT oma01,oma00,oma02,omaconf FROM oma_file, ",  						
                "  omb_file ",						
                "  WHERE oma01 = omb01",
                "    AND oma00 IN ('11')",
                "    AND omb31 = '",p_key1,"'",
                "    AND omb32 = '",p_key2,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT oma01,oma00,oma02,omaconf FROM oma_file, ",  						
                   "  omb_file ",						
                   "  WHERE oma01 = omb01",
                   "    AND oma00 IN ('11')",
                   "    AND omb31 = '",p_key1,"'",
                   "    AND omb32 = '",p_key2,"'",
                   "    AND omaplant IN ",g_auth
      END IF                
      PREPARE q800_tree_pre18 FROM g_sql
      DECLARE q800_tree_cs18 CURSOR FOR q800_tree_pre18      

      LET l_index = 0
            
      FOREACH q800_tree_cs18 INTO l_oma[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx        
      END IF
      LET g_idx = l_idx
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_oma[l_i].oma00
           WHEN  "11"
              LET l_prog_name = "oma00_11" 
           WHEN  "12"             
              LET l_prog_name = "oma00_12"
           WHEN  "13"             
              LET l_prog_name = "oma00_13"      
           WHEN  "14"             
              LET l_prog_name = "oma00_1"      
           WHEN  "15"             
              LET l_prog_name = "oma00_15"      
           WHEN  "16"             
              LET l_prog_name = "oma00_16"
           WHEN  "17"             
              LET l_prog_name = "oma00_17"
           WHEN  "18"             
              LET l_prog_name = "oma00_18"
           WHEN  "21"             
              LET l_prog_name = "oma00_21"                            
           WHEN  "22"             
              LET l_prog_name = "oma00_22"
           WHEN  "23"             
              LET l_prog_name = "oma00_23"
           WHEN  "24"             
              LET l_prog_name = "oma00_24"
           WHEN  "25"             
              LET l_prog_name = "oma00_25"
           WHEN  "26"             
              LET l_prog_name = "oma00_26"
           WHEN  "27"             
              LET l_prog_name = "oma00_27"
           WHEN  "31"             
              LET l_prog_name = "oma00_31"              
         END CASE
         CALL  get_field_name1(l_prog_name,"axrt300") RETURNING  l_prog_name            
         LET g_tree[l_idx].name = get_field_name("oma01"),":",l_oma[l_i].oma01 CLIPPED," ",
                                  get_field_name("oma00"),":",l_oma[l_i].oma00 CLIPPED,".",l_prog_name CLIPPED," ", 
                                  get_field_name("oma02"),":",l_oma[l_i].oma02 CLIPPED," ",
                                  get_field_name("omaconf"),":",l_oma[l_i].omaconf CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_oma[l_i].oma01
         LET g_tree[l_idx].treekey1 = l_oma[l_i].oma01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx 
         LET g_name[g_idx] = "axrt300"
         CALL q800_tree_fill18(p_wc,g_tree[l_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key2)                                 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill18(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #應收單頭
   DEFINE p_key2             STRING               #訂單
   DEFINE p_key3             STRING               #項次
   DEFINE l_omb             DYNAMIC ARRAY OF RECORD
             omb01           LIKE omb_file.omb01,
             omb03           LIKE omb_file.omb03,
             omb12           LIKE omb_file.omb12,
             omb05           LIKE omb_file.omb05,
             omb18t          LIKE omb_file.omb18t
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_n1               STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT omb01,omb03,omb12,omb05,omb18t FROM oma_file, ",  						
                "  omb_file ",						
                "  WHERE oma01 = omb01",
                "    AND oma00 IN ('11') ",
                "    AND omb01 = '",p_key1,"'",
                "    AND omb31 = '",p_key2,"'",
                "    AND omb32 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT omb01,omb03,omb12,omb05,omb18t FROM oma_file, ",  						
                   "  omb_file ",						
                   "  WHERE oma01 = omb01",
                   "    AND oma00 IN ('11') ",
                   "    AND omb01 = '",p_key1,"'",
                   "    AND omb31 = '",p_key2,"'",
                   "    AND omb32 = '",p_key3,"'",
                   "    AND ombplant IN ",g_auth
      END IF                      
      PREPARE q800_tree_pre19 FROM g_sql
      DECLARE q800_tree_cs19 CURSOR FOR q800_tree_pre19      

      LET l_i = 1
            
      FOREACH q800_tree_cs19 INTO l_omb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n  = l_omb[l_i].omb12
         LET l_n1 = l_omb[l_i].omb18t   
         LET g_tree[g_idx].name = get_field_name("oma01"),":",l_omb[l_i].omb01 CLIPPED," ",
                                  get_field_name("omb03"),":",l_omb[l_i].omb03 USING "<<<<<<<<"," ",
                                  get_field_name("omb12"),":",l_n CLIPPED," ",
                                  l_omb[l_i].omb05 CLIPPED," ",
                                  get_field_name("omb18t"),":",l_n1 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_omb[l_i].omb01
         LET g_tree[g_idx].treekey1 = l_omb[l_i].omb01
         LET g_tree[g_idx].treekey2 = p_key3
         LET l_i = l_i + 1
         LET g_name[g_idx] = "axrt300"
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill19(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單
   DEFINE p_key2             STRING               #項次 
   DEFINE p_key3             STRING               #應收單號
   DEFINE l_pmk             DYNAMIC ARRAY OF RECORD
             pmk01           LIKE pmk_file.pmk01,
             pmk04           LIKE pmk_file.pmk04,
             pmk25           LIKE pmk_file.pmk25,
             pmk18           LIKE pmk_file.pmk18 
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得apmt420(應收賬款)的程式名稱
      CALL get_prog_name1("axm-489") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".7"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT  pmk01,pmk04,pmk25,pmk18 FROM pmk_file, ",  						
                "  pml_file ",						
                "  WHERE pmk01 = pml01",
                "    AND pml24 = '",p_key1,"'",
                "    AND pml25 = '",p_key2,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT  pmk01,pmk04,pmk25,pmk18 FROM pmk_file, ",  						
                   "  pml_file ",						
                   "  WHERE pmk01 = pml01",
                   "    AND pml24 = '",p_key1,"'",
                   "    AND pml25 = '",p_key2,"'",
                   "    AND pmkplant IN ",g_auth
      END IF                       
      PREPARE q800_tree_pre20 FROM g_sql
      DECLARE q800_tree_cs20 CURSOR FOR q800_tree_pre20      

      LET l_index = 0
            
      FOREACH q800_tree_cs20 INTO l_pmk[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx  
      END IF
      LET g_idx = l_idx 
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_pmk[l_i].pmk25
           WHEN  "0"
              LET l_prog_name = "pmk25_0" 
           WHEN  "1"             
              LET l_prog_name = "pmk25_1"
           WHEN  "2"             
              LET l_prog_name = "pmk25_2"
           WHEN  "6"             
              LET l_prog_name = "pmk25_6"              
           WHEN  "9"             
              LET l_prog_name = "pmk25_9"      
           WHEN  "R"             
              LET l_prog_name = "pmk25_R"      
           WHEN  "S"             
              LET l_prog_name = "pmk25_S"      
           WHEN  "W"             
              LET l_prog_name = "pmk25_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"apmt420") RETURNING  l_prog_name             
         LET g_tree[l_idx].name = get_field_name("pmk01"),":",l_pmk[l_i].pmk01 CLIPPED," ",
                                  get_field_name("pmk04"),":",l_pmk[l_i].pmk04 CLIPPED," ",
                                  get_field_name("pmk25"),":",l_pmk[l_i].pmk25 CLIPPED,".",l_prog_name," ",
                                  get_field_name("pmk18"),":",l_pmk[l_i].pmk18 CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_pmk[l_i].pmk01
         LET g_tree[l_idx].treekey1 = l_pmk[l_i].pmk01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx 
         LET g_name[g_idx] = "apmt420"
         CALL q800_tree_fill20(p_wc,g_tree[l_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,
                              g_tree[g_idx].treekey2,p_key2)                                 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill20(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #請購單號
   DEFINE p_key2             STRING               #訂單
   DEFINE p_key3             STRING               #項次
   DEFINE l_pml             DYNAMIC ARRAY OF RECORD
             pml01           LIKE pml_file.pml01,
             pml02           LIKE pml_file.pml02,
             pml20           LIKE pml_file.pml20,
             pml07           LIKE pml_file.pml07,
             pml21           LIKE pml_file.pml21
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_n1               STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT pml01,pml02,pml20,pml07,pml21 FROM pmk_file, ",  						
                "  pml_file ",						
                "  WHERE pmk01 = pml01",
                "    AND pml01 = '",p_key1,"'",
                "    AND pml24 = '",p_key2,"'",
                "    AND pml25 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT pml01,pml02,pml20,pml07,pml21 FROM pmk_file, ",  						
                   "  pml_file ",						
                   "  WHERE pmk01 = pml01",
                   "    AND pml01 = '",p_key1,"'",
                   "    AND pml24 = '",p_key2,"'",
                   "    AND pml25 = '",p_key3,"'",
                   "    AND pmlplant IN ",g_auth
      END IF                       
      PREPARE q800_tree_pre21 FROM g_sql
      DECLARE q800_tree_cs21 CURSOR FOR q800_tree_pre21      

      LET l_i = 1
            
      FOREACH q800_tree_cs21 INTO l_pml[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n  = l_pml[l_i].pml20 
         LET l_n1 = l_pml[l_i].pml21 
         LET g_tree[g_idx].name = get_field_name("pml01"),":",l_pml[l_i].pml01 CLIPPED," ",
                                  get_field_name("pml02"),":",l_pml[l_i].pml02 USING "<<<<<<<<"," ",
                                  get_field_name("pml20"),":",l_n CLIPPED," ",
                                  get_field_name("pml07"),":",l_pml[l_i].pml07 CLIPPED," ",
                                  get_field_name("pml21"),":",l_n1 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_pml[l_i].pml01
         LET g_tree[g_idx].treekey1 = l_pml[l_i].pml01
         LET g_tree[g_idx].treekey2 = p_key3
         LET l_i = l_i + 1
         LET g_name[g_idx] = "apmt420"
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill21(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單
   DEFINE p_key2             STRING               #項次
   DEFINE l_pmm             DYNAMIC ARRAY OF RECORD
             pmm01           LIKE pmm_file.pmm01,
             pmm04           LIKE pmm_file.pmm04,
             pmm02           LIKE pmm_file.pmm02,
             pmm25           LIKE pmm_file.pmm25,
             pmm18           LIKE pmm_file.pmm18 
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得apmt540(應收賬款)的程式名稱
      CALL get_prog_name1("axm-490") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".8"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT  pmm01,pmm04,pmm02,pmm25,pmm18 FROM pmm_file, ",  						
                "  pmn_file ",						
                "  WHERE pmm01 = pmn01",
                "    AND pmm909 = '3' ",
                "    AND pmn24 = '",p_key1,"'",
                "    AND pmn25 = '",p_key2,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT  pmm01,pmm04,pmm02,pmm25,pmm18 FROM pmm_file, ",  						
                   "  pmn_file ",						
                   "  WHERE pmm01 = pmn01",
                   "    AND pmm909 = '3' ",
                   "    AND pmn24 = '",p_key1,"'",
                   "    AND pmn25 = '",p_key2,"'",
                   "    AND pmmplant IN ",g_auth
      END IF                       
      PREPARE q800_tree_pre22 FROM g_sql
      DECLARE q800_tree_cs22 CURSOR FOR q800_tree_pre22      

      LET l_index = 0
            
      FOREACH q800_tree_cs22 INTO l_pmm[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             
      
      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
         LET g_idx = l_idx        
      END IF
      LET g_idx = l_idx
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[l_idx].id = l_str
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CASE l_pmm[l_i].pmm25
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
           WHEN  "R"             
              LET l_prog_name = "pmm25_R"      
           WHEN  "S"             
              LET l_prog_name = "pmm25_S"      
           WHEN  "W"             
              LET l_prog_name = "pmm25_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"apmt540") RETURNING  l_prog_name            
         LET g_tree[l_idx].name = get_field_name("pmm01"),":",l_pmm[l_i].pmm01 CLIPPED," ",
                                  get_field_name("pmm04"),":",l_pmm[l_i].pmm04 CLIPPED," ",
                                  get_field_name("pmm02"),":",l_pmm[l_i].pmm02 CLIPPED," ",
                                  get_field_name("pmm25"),":",l_pmm[l_i].pmm25 CLIPPED,".",l_prog_name," ",
                                  get_field_name("pmm18"),":",l_pmm[l_i].pmm18 CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_pmm[l_i].pmm01
         LET g_tree[l_idx].treekey1 = l_pmm[l_i].pmm01
         LET g_tree[l_idx].treekey2 = p_key1
         LET g_idx = l_idx 
         LET g_name[g_idx] = "apmt540"
         CALL q800_tree_fill22(p_wc,g_tree[l_idx].id,p_level,g_tree[g_idx].path,
                              g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,p_key2)                                 
      END FOR   

END FUNCTION

FUNCTION q800_tree_fill22(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_key3)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #請購單號
   DEFINE p_key2             STRING               #訂單
   DEFINE p_key3             STRING               #項次  
   DEFINE l_pmn             DYNAMIC ARRAY OF RECORD
             pmn01           LIKE pmn_file.pmn01,
             pmn02           LIKE pmn_file.pmn02,
             pmn20           LIKE pmn_file.pmn20,
             pmn07           LIKE pmn_file.pmn07,
             pmn33           LIKE pmn_file.pmn33
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
  
      #取得出貨通知單單身相關資訊
      LET g_sql=" SELECT DISTINCT pmn01,pmn02,pmn20,pmn07,pmn33 FROM pmm_file, ",  						
                "  pmn_file ",						
                "  WHERE pmm01 = pmn01",
                "    AND pmm909 = '3' ",
                "    AND pmn01 = '",p_key1,"'",
                "    AND pmn24 = '",p_key2,"'",
                "    AND pmn25 = '",p_key3,"'"                 						               
      IF g_azw.azw04 = '2'  THEN 
         LET g_sql=" SELECT DISTINCT pmn01,pmn02,pmn20,pmn07,pmn33 FROM pmm_file, ",  						
                   "  pmn_file ",						
                   "  WHERE pmm01 = pmn01",
                   "    AND pmm909 = '3' ",
                   "    AND pmn01 = '",p_key1,"'",
                   "    AND pmn24 = '",p_key2,"'",
                   "    AND pmn25 = '",p_key3,"'",
                   "    AND pmnplant IN ",g_auth
      END IF                    
      PREPARE q800_tree_pre23 FROM g_sql
      DECLARE q800_tree_cs23 CURSOR FOR q800_tree_pre23      

      LET l_i = 1
            
      FOREACH q800_tree_cs23 INTO l_pmn[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
            

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿  
         LET g_tree[g_idx].pid = p_pid
         LET l_str = l_i  #數值轉字串
         LET l_n = l_pmn[l_i].pmn20  
         LET g_tree[g_idx].name = get_field_name("pmn01"),":",l_pmn[l_i].pmn01 CLIPPED," ",
                                  get_field_name("pmn02"),":",l_pmn[l_i].pmn02 USING "<<<<<<<<"," ",
                                  get_field_name("pmn20"),":",l_n CLIPPED," ",
                                  get_field_name("pmn07"),":",l_pmn[l_i].pmn07 CLIPPED," ",
                                  get_field_name("pmn33"),":",l_pmn[l_i].pmn33 CLIPPED
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str         
         LET g_tree[g_idx].path = p_path,".",l_pmn[l_i].pmn01
         LET g_tree[g_idx].treekey1 = p_key1
         LET g_tree[g_idx].treekey2 = p_key3
         LET l_i = l_i + 1
         LET g_name[g_idx] = "apmt540"
      END FOREACH  

END FUNCTION

FUNCTION q800_tree_fill23(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               #訂單
   DEFINE p_key2             STRING               #項次 
   DEFINE l_sfb             DYNAMIC ARRAY OF RECORD
             sfb01           LIKE sfb_file.sfb01,
             sfb81           LIKE sfb_file.sfb81,
             sfb08           LIKE sfb_file.sfb08,
             ima55           LIKE ima_file.ima55,
             sfb09           LIKE sfb_file.sfb09,
             sfb04           LIKE sfb_file.sfb04,
             sfb87           LIKE sfb_file.sfb87 
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   DEFINE l_n                STRING
   DEFINE l_n1               STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   
      #取得asfi301(應收賬款)的程式名稱
      CALL get_prog_name1("axm-491") RETURNING l_prog_name
      
      LET l_idx = g_idx + 1
      LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[l_idx].name = l_prog_name CLIPPED    
      LET g_tree[l_idx].pid = g_tree[p_pid].id
      LET g_tree[l_idx].id = g_tree[l_idx].pid,".9"      
      LET l_child_pid = g_tree[l_idx].id     #數值轉字串
      
      #取得出貨通知單相關資訊
      LET g_sql=" SELECT DISTINCT  sfb01,sfb81,sfb08,ima55,sfb09,sfb04,sfb87  FROM sfb_file ",  						
                "  LEFT OUTER JOIN ima_file  ON ima01 = sfb05",						
                "  WHERE  sfb22 = '",p_key1,"'",
                "    AND sfb221 = '",p_key2,"'"              						                
      PREPARE q800_tree_pre24 FROM g_sql
      DECLARE q800_tree_cs24 CURSOR FOR q800_tree_pre24      

      LET l_index = 0
            
      FOREACH q800_tree_cs24 INTO l_sfb[l_index+1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_index = l_index + 1
      END FOREACH             

      IF l_index > 0 THEN
         LET g_tree[l_idx].has_children = TRUE
      ELSE
         LET g_tree[l_idx].has_children = FALSE
      END IF
      LET g_idx = l_idx 
      FOR l_i=1 TO l_index
         LET l_idx = g_idx + 1
         LET g_tree[l_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
         CASE l_sfb[l_i].sfb04
           WHEN  "1" 
              LET l_prog_name = "sfb04_1"
           WHEN  "2"
              LET l_prog_name = "sfb04_2"      
           WHEN  "3"
              LET l_prog_name = "sfb04_3"      
           WHEN  "4"
              LET l_prog_name = "sfb04_4"      
           WHEN  "5"
              LET l_prog_name = "sfb04_5"
           WHEN  "6"
              LET l_prog_name = "sfb04_6"
           WHEN  "7"
              LET l_prog_name = "sfb04_7"                            
           WHEN  "8"
              LET l_prog_name = "sfb04_8" 
         END CASE
         CALL  get_field_name1(l_prog_name,"asfi301") RETURNING  l_prog_name       
         LET l_n =  l_sfb[l_i].sfb08 
         LET l_n1 = l_sfb[l_i].sfb09    
            LET g_tree[l_idx].name = get_field_name("sfb01"),":",l_sfb[l_i].sfb01 CLIPPED," ",
                                     get_field_name("sfb81"),":",l_sfb[l_i].sfb81 CLIPPED," ",
                                     get_field_name("sfb08"),":",l_n," ",
                                     get_field_name("ima55"),":",l_sfb[l_i].ima55 CLIPPED," ",
                                     get_field_name("sfb09"),":",l_n1," ",
                                     get_field_name("sfb04"),":",l_sfb[l_i].sfb04 CLIPPED,".",l_prog_name CLIPPED," ",
                                     get_field_name("sfb87"),":",l_sfb[l_i].sfb87 CLIPPED
         LET g_tree[l_idx].level = p_level
         LET g_tree[l_idx].pid = l_child_pid
         LET l_str = l_i 
         LET g_tree[l_idx].id = g_tree[l_idx].pid,".",l_str         
         LET g_tree[l_idx].path = p_path,".",l_sfb[l_i].sfb01
         LET g_tree[l_idx].treekey1 = l_sfb[l_i].sfb01
         LET g_tree[l_idx].treekey2 = p_key2
         LET g_idx = l_idx
         LET g_name[g_idx] = "asfi301"                                 
      END FOR   

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


##################################################
# Descriptions...: 檢查是否為無窮迴嚿
# Date & Author..: 10/05/05 
# Input Parameter: p_key1,p_flag
# Return code....: l_loop
##################################################
#FUNCTION q800_tree_loop(p_key1,p_flag)
#   DEFINE p_key1             STRING
#  
#   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
#   DEFINE l_oea              DYNAMIC ARRAY OF RECORD
#             oea01           LIKE abd_file.abd01,
#             child_cnt       LIKE type_file.num5  #子節點數
#             END RECORD
#   DEFINE l_str              STRING
#   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
#   DEFINE l_i                LIKE type_file.num5
#   DEFINE l_cnt              LIKE type_file.num5
#   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N
#
#   
#   LET p_flag = "Y"
#   IF cl_null(l_loop) THEN
#      LET l_loop = "N"
#   END IF
#
#   IF NOT cl_null(p_key1) THEN
#      LET g_sql = "SELECT DISTINCT oea_file.oea01,cnt.child_cnt",
#                  " FROM (",
#                  "   SELECT DISTINCT oea01 FROM oea_file",
#                  "   WHERE oea01='",p_key1 CLIPPED,"'",
#                  " ) oea_file"
#      PREPARE q800_tree_pre3 FROM g_sql
#      DECLARE q800_tree_cs3 CURSOR FOR q800_tree_pre3
#
#      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
#      LET l_cnt = 1
#      CALL l_oea.clear()
#      FOREACH q800_tree_cs3 INTO l_oea[l_cnt].*
#         IF SQLCA.sqlcode THEN
#             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#             EXIT FOREACH
#         END IF
#         LET l_cnt = l_cnt + 1
#      END FOREACH
#      CALL l_oea.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿      
#      LET l_cnt = l_cnt - 1
#
#      IF l_cnt >0 THEN
#         FOR l_i=1 TO l_cnt
#            LET g_idx = g_idx + 1
#            LET g_path_add[g_idx] = l_oea[l_i].oea01
#            IF g_path_add[g_idx] = p_key1 THEN
#               LET l_loop = "Y"
#               RETURN l_loop
#            END IF
#            #有子節鹿           
#             IF l_oea[l_i].child_cnt > 0 THEN
#               CALL q800_tree_loop(l_oea[l_i].oea01,p_flag) RETURNING l_loop
#            END IF
#          END FOR
#      END IF
#   END IF
#   RETURN l_loop
#END FUNCTION


##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/05 
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION q800_tree_update()
   #Tree重查並展開focus節鹿  
   CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充
   CALL q800_tree_idxbypath()                        #依tree path指定focus節鹿   
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
      IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey1 == g_oea[l_ac].oea01) CLIPPED THEN  # 尋找節鹿        
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
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

FUNCTION q800_run(p_index)
  DEFINE p_index       STRING
  DEFINE l_cmd              LIKE type_file.chr1000 
  CASE g_name[p_index]
     WHEN "axmt410"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "axmt410 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "axmt410_slk '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "axmt410_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE       
     WHEN "axmt800"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "axmt800 '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)           
           WHEN "slk"
              LET l_cmd = "axmt800 '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
           WHEN "icd"
              LET l_cmd = "axmt800_icd '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
        END CASE 
     WHEN "axmt610"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "axmt610 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "axmt610 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "axmt610_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE   
     WHEN "axmt620"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "axmt620 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "axmt620 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "axmt620_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE 
     WHEN "axrt300"
        LET l_cmd = "axrt300 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
     WHEN "axrt400"
        LET l_cmd = "axrt400 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
     WHEN "axmt700"
        LET l_cmd = "axmt700 '",g_tree[p_index].treekey1,"'"
        CALL cl_cmdrun_wait(l_cmd)
     WHEN "apmt420"
        CASE g_sma.sma124   
           WHEN "std"
              LET l_cmd = "apmt420 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "apmt420_slk '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)   
           WHEN "icd"
              LET l_cmd = "apmt420 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE                
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
     WHEN "asfi301"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi301 '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi301_slk '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi301_icd '",g_tree[p_index].treekey1,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE 
  END CASE
END FUNCTION
