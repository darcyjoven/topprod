# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglq800.4gl
# Descriptions...: 傳票追蹤查詢
# Date & Author..: FUN-A50010 10/05/07 By lixia
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE
    g_aba01         LIKE aba_file.aba01,
    g_aba01_t       LIKE aba_file.aba01,
    g_aba01_o       LIKE aba_file.aba01,
    g_bookno        LIKE aba_file.aba00,      #全局變數 帳別
    g_aba           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        aba01       LIKE aba_file.aba01,  
        aba02       LIKE aba_file.aba02,
        aba06       LIKE aba_file.aba06,
        aba20       LIKE aba_file.aba20        
                    END RECORD,            
    g_aba_t         RECORD                 #程式變數 (舊便
        aba01       LIKE aba_file.aba01,  
        aba02       LIKE aba_file.aba02,
        aba06       LIKE aba_file.aba06,
        aba20       LIKE aba_file.aba20        
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
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整玿Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路弿check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路弿check loop)
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5          

   OPTIONS                               #改變一些系統預設便   
   INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鋿 由程式處玿 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time               
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q800_w AT p_row,p_col WITH FORM "agl/42f/aglq800"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)    
   CALL cl_ui_init()

   LET g_bookno = g_aaz.aaz64    #帳憋賦值
   LET g_wc2 = '1=1'       
   CALL q800_b_fill(g_wc2)
   LET g_tree_reload = "N"      
   LET g_tree_b = "N"          
   LET g_tree_focus_idx = 0     

   CALL q800_menu()
   CLOSE WINDOW q800_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使锿 
        RETURNING g_time                        
 
END MAIN
 
FUNCTION q800_menu()  #FUN-A50010 
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   DEFINE p_vchno            LIKE aba_file.aba03  
   DEFINE g_cmd              LIKE type_file.chr1000 
   
   WHILE TRUE      
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)

      #讓各個交談指令可以互剿      
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_aba[l_ac].aba01,null)         
 
            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

            &include "qry_string.4gl"
         END DISPLAY
         
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正砿               #因為double click tree node弿focus tree的節點會改變
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF

               #以最上層的id當作單頭的g_curs_index
               LET g_curs_index = l_curs_index
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 
               CALL DIALOG.setSelectionMode( "tree", 1 )                 
                          
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
            CALL q800_tree_fill(g_wc_o,NULL,0,NULL,g_aba[l_ac].aba01,null) 

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

          ON ACTION cancel     
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
      
      CASE g_action_choice
        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q800_q(0)           
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
                   LET g_cmd = "aglt110 '",g_aba[l_ac].aba01,"'"
                   CALL cl_cmdrun_wait(g_cmd)
                END IF
             END IF
              
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_aba[l_ac].aba01 IS NOT NULL THEN
                  LET g_doc.column1 = "aba01"
                  LET g_doc.value1 = g_aba[l_ac].aba01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aba),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION 

FUNCTION q800_b_askkey(p_idx)
   DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     
   DEFINE l_wc   STRING                #雙按Tree的節點時的查詢䞣
   
   LET l_wc = NULL
   IF p_idx > 0 THEN
      IF g_tree_b = "N" THEN
         LET l_wc = g_wc_o             #還原QBE的查詢條乿      
         ELSE
         IF g_tree[p_idx].level = 1 THEN
            LET l_wc = g_wc_o
         ELSE
            IF g_tree[p_idx].has_children THEN
               LET l_wc = "abb01='",g_tree[p_idx].treekey1 CLIPPED
            ELSE
               LET l_wc = "abb01='",g_tree[p_idx].treekey1 CLIPPED,"'",
                          " AND abb02='",g_tree[p_idx].treekey2 CLIPPED,"'"
            END IF
         END IF
      END IF
   END IF   

   CLEAR FORM                             #清除畫面
   CALL g_aba.clear()    
   INITIALIZE g_aba01 TO NULL

   IF p_idx = 0 THEN  
      CONSTRUCT g_wc2 ON aba01,aba02,aba06,aba20
                FROM s_aba[1].aba01,s_aba[1].aba02,s_aba[1].aba06,s_aba[1].aba20
                BEFORE CONSTRUCT
                   CALL cl_qbe_init()

      ON ACTION CONTROLP 
      CASE          
          WHEN INFIELD(aba01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aba02"
             LET g_qryparam.state    = "c"             
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_aba[1].aba01
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
   ELSE
      LET g_wc2 = l_wc CLIPPED
   END IF

   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('abauser', 'abagrup') 
   IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
      LET g_wc_o = g_wc2 CLIPPED
   END IF    
  
   IF INT_FLAG THEN 
      RETURN 
   END IF
   
   LET g_sql= "SELECT DISTINCT aba01 FROM aba_file ",   
              " WHERE ", g_wc2 CLIPPED,
              "   AND aba19 <> 'X' ",  #CHI-C80041
              "   AND aba00='",g_bookno,"'",
              " ORDER BY aba01"
   
   PREPARE q800_prepare FROM g_sql        #預備一下
   DECLARE q800_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q800_prepare

   LET g_sql="SELECT COUNT(DISTINCT aba01)",
             "  FROM aba_file",
             " WHERE ", g_wc2 CLIPPED,
             "   AND aba19 <> 'X' ",  #CHI-C80041
             "   AND aba00='",g_bookno,"'"
             
   PREPARE q800_precount FROM g_sql
   DECLARE q800_count CURSOR FOR q800_precount   
   CALL q800_show() 
 
END FUNCTION

FUNCTION q800_q(p_idx)     
    DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index  
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aba01 TO NULL               
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_aba.clear()
    CALL q800_b_askkey(p_idx)             #取得查詢條件  
    IF INT_FLAG THEN                      #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN q800_bcs                         #從DB產生合乎條件TEMP(0-30祿
    IF SQLCA.sqlcode THEN                 #有問響        
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_aba01 TO NULL
    ELSE        
       OPEN q800_count
       FETCH q800_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt        
    END IF
    
END FUNCTION

FUNCTION q800_show()    
    CALL q800_b_fill(g_wc2)             #單身
    CALL cl_show_fld_cont()     
END FUNCTION 
 
FUNCTION q800_b_fill(p_wc2)              
   DEFINE p_wc2   LIKE type_file.chr1000 
   LET g_sql = "SELECT DISTINCT aba01,aba02,aba06,aba20",
               "  FROM aba_file ",
               " WHERE ",p_wc2 CLIPPED,
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND aba00='",g_bookno,"'",
               " ORDER BY aba01"
  
   PREPARE q800_pb FROM g_sql
   DECLARE aba_curs CURSOR FOR q800_pb
 
   CALL g_aba.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH aba_curs INTO g_aba[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF 
   END FOREACH
 
   CALL g_aba.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
   CALL q800_tree_fill(p_wc2 ,NULL,0,NULL,g_aba[1].aba01,null) 
 
END FUNCTION

##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/10
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
FUNCTION q800_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_n                STRING       
   DEFINE l_n1               STRING

   DEFINE l_aba              DYNAMIC ARRAY OF RECORD
             aba01           LIKE aba_file.aba01,
             aba02           LIKE aba_file.aba02,
             aba06           LIKE aba_file.aba06,   
             aba20           LIKE aba_file.aba20  #子節點數
                             END RECORD
   DEFINE l_abb              DYNAMIC ARRAY OF RECORD 
             abb01           LIKE abb_file.abb01,
             abb02           LIKE abb_file.abb02,
             abb03           LIKE abb_file.abb03,
             aag02           LIKE aag_file.aag02,
             abb06           LIKE abb_file.abb06, 
             abb24           LIKE abb_file.abb24,
             abb07f          LIKE abb_file.abb07f,
             abb07           LIKE abb_file.abb07
                             END RECORD 

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_abh07            LIKE abh_file.abh07
   DEFINE l_abh08            LIKE abh_file.abh08
   DEFINE l_prog_name        STRING  #add by dxfwo 
   
   LET max_level = 20 #設定最大階層數瀿0

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_aba.clear()

      #[1]抓取傳票單頭資料
      LET g_sql="SELECT DISTINCT aba01,aba02,aba06,aba20",
                "  FROM aba_file ",
                " WHERE aba00 = '",g_bookno,"'",
                "   AND aba01 = '",p_key1,"'"      
                
      PREPARE q800_tree_pre1 FROM g_sql
      DECLARE q800_tree_cs1 CURSOR FOR q800_tree_pre1      

      LET l_i = 1      
      FOREACH q800_tree_cs1 INTO l_aba[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF         
         SELECT COUNT(abb01) INTO l_child FROM abb_file
          WHERE abb01 = l_aba[l_i].aba01 
            
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
#No.FUN-A50010  dxfwo add#
       
         CASE l_aba[l_i].aba20
           WHEN  "0"
              LET l_prog_name = "aba20_0" 
           WHEN  "1"             
              LET l_prog_name = "aba20_1"   
           WHEN  "R"             
              LET l_prog_name = "aba20_R"      
           WHEN  "S"             
              LET l_prog_name = "aba20_S"      
           WHEN  "W"             
              LET l_prog_name = "aba20_W"
         END CASE
         CALL  get_field_name1(l_prog_name,"aglt110") RETURNING  l_prog_name 
         
         LET g_tree[g_idx].name =get_field_name("aba01"),":",l_aba[l_i].aba01 CLIPPED," ",
                                 get_field_name("aba02"),":",l_aba[l_i].aba02 CLIPPED," ",
                                 get_field_name("aba06"),":",l_aba[l_i].aba06 CLIPPED," ",
                                 get_field_name("aba20"),":",l_aba[l_i].aba20 CLIPPED,".",l_prog_name CLIPPED 
#No.FUN-A50010  dxfwo add#
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_aba[l_i].aba01
         LET g_tree[g_idx].treekey1 = l_aba[l_i].aba01
         
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
      #[02] 抓取傳票單身資料	
      LET g_sql="SELECT DISTINCT abb01,abb02,abb03,aag02,abb06,abb24,abb07f,abb07", 
                "  FROM abb_file",
                "  LEFT OUTER JOIN aag_file ON aag00 = abb00  AND aag01 = abb03",
                " WHERE abb00 = '",g_bookno,"'",
                "   AND abb01 = '",p_key1,"' "
                
      PREPARE q800_tree_pre2 FROM g_sql
      DECLARE q800_tree_cs2 CURSOR FOR q800_tree_pre2

      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_abb.clear()
      FOREACH q800_tree_cs2 INTO l_abb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_aba.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿      
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #T  #TRUE:展開, FALSE:不展锿           
            LET l_n = l_abb[l_i].abb07f
            LET l_n1 = l_abb[l_i].abb07
            CASE l_abb[l_i].abb06             
              WHEN  "1"             
                 LET l_prog_name = "abb06_1"   
              WHEN  "2"             
                 LET l_prog_name = "abb06_2"
            END CASE
            
            CALL  get_field_name1(l_prog_name,"aglt110") RETURNING  l_prog_name 
            LET g_tree[g_idx].name = get_field_name("abb01"),":",l_abb[l_i].abb01 CLIPPED,' ',
                                     get_field_name("abb02"),":",l_abb[l_i].abb02 USING "<<<<<<<<",' ',
                                     get_field_name("abb03"),":",l_abb[l_i].abb03 CLIPPED,"(",l_abb[l_i].aag02,")",' ',
                                     get_field_name("abb06"),":",l_abb[l_i].abb06,".",l_prog_name CLIPPED,' ',
                                     get_field_name("abb24"),":",l_abb[l_i].abb24 CLIPPED,' ',
                                     get_field_name("abb07f"),":",l_n CLIPPED,' ',
                                     get_field_name("abb07"),":",l_n1 CLIPPED
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path 
            LET g_tree[g_idx].treekey1 = l_abb[l_i].abb01
            LET g_tree[g_idx].treekey2 = l_abb[l_i].abb02
            
            #有子節鹿            
            IF l_child > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL q800_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                   g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
               #根据傳票編號(abb01)項次(abb02)抓取立帳傳票號(abh07)及項次(abh08)
               SELECT abh07,abh08 INTO l_abh07,l_abh08
                 FROM abh_file
                WHERE abh00 = g_bookno
                  AND abh01 = l_abb[l_i].abb01
                  AND abh02 = l_abb[l_i].abb02 
               #增加沖帳資料傳票單頭檔节点   
               CALL q800_tree_fill1(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,                                                          
                                   l_abh07,l_abh08)               
            END IF
          END FOR
      END IF   
   END IF
END FUNCTION

FUNCTION q800_tree_fill1(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE l_pid              STRING
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_aba              DYNAMIC ARRAY OF RECORD
             aba01           LIKE aba_file.aba01,
             aba02           LIKE aba_file.aba02,
             aba06           LIKE aba_file.aba06,   
             aba20           LIKE aba_file.aba20  #子節點數
                             END RECORD  
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING
   
      #取得aglt110的程式名稱
      CALL get_prog_name1("axm-482") RETURNING l_prog_name
      LET p_level=p_level+1
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿
      LET g_tree[g_idx].name = l_prog_name CLIPPED       
      LET g_tree[g_idx].pid = p_pid
      LET g_tree[g_idx].id = g_tree[g_idx].pid,".1"      
      LET l_child_pid = g_tree[g_idx].id     #數值轉字串
      LET g_tree[g_idx].level = p_level 
      LET l_pid = g_tree[g_idx].id
      
      #[03] 抓取沖帳資料傳票單頭檔
      LET g_sql="SELECT DISTINCT aba01,aba02,aba06,aba20 ",
                "  FROM aba_file",
                " WHERE aba00 ='",g_bookno,"'",
                "   AND aba01 ='",p_key1,"'" 
                
      PREPARE q800_tree_pre3 FROM g_sql
      DECLARE q800_tree_cs3 CURSOR FOR q800_tree_pre3  
      LET l_cnt = 1
      CALL l_aba.clear()
      FOREACH q800_tree_cs3 INTO l_aba[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_aba.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿      
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         LET p_level=p_level+1
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = l_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded =  TRUE   #TRUE:展開, FALSE:不展锿  
            CASE l_aba[l_i].aba20
              WHEN  "0"
                 LET l_prog_name = "aba20_0" 
              WHEN  "1"             
                 LET l_prog_name = "aba20_1"   
              WHEN  "R"             
                 LET l_prog_name = "aba20_R"      
              WHEN  "S"             
                 LET l_prog_name = "aba20_S"      
              WHEN  "W"             
                 LET l_prog_name = "aba20_W"
            END CASE
         CALL  get_field_name1(l_prog_name,"aglt110") RETURNING  l_prog_name                  
            LET g_tree[g_idx].name = get_field_name("aba01"),":",l_aba[l_i].aba01 CLIPPED," ",
                                     get_field_name("aba02"),":",l_aba[l_i].aba02 CLIPPED," ",
                                     get_field_name("aba06"),":",l_aba[l_i].aba06 CLIPPED," ",
                                     get_field_name("aba20"),":",l_aba[l_i].aba20 CLIPPED,".",l_prog_name CLIPPED 
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path 
            LET g_tree[g_idx].treekey1 = l_aba[l_i].aba01
            LET g_tree[g_idx].treekey2 = p_key2                 
       #  END FOR 
         #增加傳票單身資料节点  
            CALL  q800_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,                                                          
                                   g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
         END FOR 
       END IF      
END FUNCTION

FUNCTION q800_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING               
   DEFINE p_key2             STRING
   DEFINE l_n                STRING       
   DEFINE l_n1               STRING
   DEFINE l_abb              DYNAMIC ARRAY OF RECORD 
             abb01           LIKE abb_file.abb01,
             abb02           LIKE abb_file.abb02,
             abb03           LIKE abb_file.abb03,
             aag02           LIKE aag_file.aag02,
             abb06           LIKE abb_file.abb06, 
             abb24           LIKE abb_file.abb24,
             abb07f          LIKE abb_file.abb07f,
             abb07           LIKE abb_file.abb07
                             END RECORD 
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_child_pid        STRING   
   DEFINE l_prog_name        STRING   
      
      #[04] 抓取傳票單身資料，以 l_abh07為 p_key1, l_abh08 為 p_key2
      LET g_sql="SELECT DISTINCT abb01,abb02,abb03,aag02,abb06,abb24,abb07f,abb07",
                "  FROM abb_file",
                "  LEFT OUTER JOIN aag_file ON aag00 = abb00  AND aag01 = abb03",
                " WHERE abb00 ='",g_bookno,"'",
                "   AND abb01 ='",p_key1,"'",
                "   AND abb02 ='",p_key2,"'" 
      
      PREPARE q800_tree_pre4 FROM g_sql
      DECLARE q800_tree_cs4 CURSOR FOR q800_tree_pre4 
      
      LET l_cnt = 1
      CALL l_abb.clear()
      FOREACH q800_tree_cs4 INTO l_abb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_abb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿      
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #T  #TRUE:展開, FALSE:不展锿  
            LET l_n = l_abb[l_i].abb07f
            LET l_n1 = l_abb[l_i].abb07 
            CASE l_abb[l_i].abb06             
              WHEN  "1"             
                 LET l_prog_name = "abb06_1"   
              WHEN  "2"             
                 LET l_prog_name = "abb06_2"
            END CASE
            
            CALL  get_field_name1(l_prog_name,"aglt110") RETURNING  l_prog_name                  
            LET g_tree[g_idx].name = get_field_name("abb01"),":",l_abb[l_i].abb01 CLIPPED,' ',
                                     get_field_name("abb02"),":",l_abb[l_i].abb02 USING "<<<<<<<<",' ',
                                     get_field_name("abb03"),":",l_abb[l_i].abb03 CLIPPED,"(",l_abb[l_i].aag02,")",' ',
                                     get_field_name("abb06"),":",l_abb[l_i].abb06 CLIPPED,".",l_prog_name CLIPPED,' ',
                                     get_field_name("abb24"),":",l_abb[l_i].abb24 CLIPPED,' ',
                                     get_field_name("abb07f"),":",l_n CLIPPED,' ',
                                     get_field_name("abb07"),":",l_n1 CLIPPED
             LET g_tree[g_idx].level = p_level
             LET g_tree[g_idx].path = p_path 
             LET g_tree[g_idx].treekey1 = l_abb[l_i].abb01
             LET g_tree[g_idx].treekey2 = l_abb[l_i].abb02                 
          END FOR           
       END IF      
END FUNCTION

#add by dxfwo
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
#add by dxfwo
##################################################
# Descriptions...: 依tree path指定focus節鹿
# Date & Author..: 10/05/10
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
# Descriptions...: 獲取字段名稱
##################################################
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

##################################################
# Descriptions...: 獲取作業名稱
##################################################
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
