# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: asfq800.4gl
# Descriptions...: 工單查詢
# Date & Author..: FUN-A50010 10/05/10 By huangtao
# Modify.........: No.FUN-A50010 10/05/10 by huangtao

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE 
    g_sfb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        sfb01       LIKE sfb_file.sfb01,
        sfb02       LIKE sfb_file.sfb02,
        sfb81       LIKE sfb_file.sfb81,
        sfb05       LIKE sfb_file.sfb05,
        ima02       LIKE ima_file.ima02
                    END RECORD,
    g_sfb_t         RECORD   #程式變數(Program Variables)
        sfb01       LIKE sfb_file.sfb01,
        sfb02       LIKE sfb_file.sfb02,
        sfb81       LIKE sfb_file.sfb81,
        sfb05       LIKE sfb_file.sfb05,
        ima02       LIKE ima_file.ima02
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
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
        RETURNING g_time               
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q800_w AT p_row,p_col WITH FORM "asf/42f/asfq800"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()

   #FUN-A50010   ---START---
   LET g_wc2 = '1=1'
   LET g_wc_o = g_wc2   
   CALL q800_b_fill(g_wc2)
   LET l_ac = 1 
   LET g_tree_reload = "N"      
   LET g_tree_b = "N"          
   LET g_tree_focus_idx = 0 
   CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)
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
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
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
               END IF

               #以最上層的id當作單頭的g_curs_index
             # CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               LET g_curs_index = l_curs_index
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
                #目前在tree的row 
               LET l_tree_arr_curr = ARR_CURR()
               CALL DIALOG.setSelectionMode( "tree", 1 )  # FUN-50010
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)
            #double click tree node
            ON ACTION accept
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節鹿               
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL q800_tree_idxbypath()   #依tree path指定focus節鹿               
               END IF

               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
               CALL q800_q(l_tree_arr_curr)
               
         END DISPLAY


         DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)

            #double click tree node
            ON ACTION accept
               CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)

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
            CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) 
            
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
                LET l_ac = 1
                CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q800_out()
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
            
         WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_sfb[l_ac].sfb01 IS NOT NULL THEN
                  LET g_doc.column1 = "sfb01"
                  LET g_doc.value1 = g_sfb[l_ac].sfb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q800_q(p_idx)      #FUN-A50010 加參數p_idx
DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index
    CALL q800_b_askkey(p_idx)
END FUNCTION

FUNCTION q800_show()

    CALL q800_b_fill(g_wc)             #單身

    CALL cl_show_fld_cont()           
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
               LET l_wc = "sfb01='",g_tree[p_idx].treekey1 CLIPPED,"'"
            ELSE
               LET l_wc = "sfb01='",g_tree[p_idx].treekey1 CLIPPED,"'"
                         
            END IF
         END IF
      END IF
   END IF
   ###FUN-A50010 END ###

   CLEAR FORM                             #清除畫面
   CALL g_sfb.clear()    

   IF p_idx = 0 THEN   #FUN-A50010
      CONSTRUCT g_wc2 ON sfb01,sfb02,sfb81,sfb05
                FROM s_sfb[1].sfb01,s_sfb[1].sfb02,s_sfb[1].sfb81,s_sfb[1].sfb05       #螢幕上取條件
                   
                BEFORE CONSTRUCT
                   CALL cl_qbe_init()

      ON ACTION CONTROLP 
       CASE          
          WHEN INFIELD(sfb01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_sfb01"
             LET g_qryparam.state    = "c"
             LET g_qryparam.default1 = g_sfb[1].sfb01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_sfb[1].sfb01

          WHEN INFIELD(sfb05)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_bma"
             LET g_qryparam.state    = "c"
             LET g_qryparam.default1 = g_sfb[1].sfb05
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_sfb[1].sfb05
          
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
      CALL g_tree.clear()
      RETURN
   END IF
 
   CALL q800_b_fill(g_wc2)
  
 
END FUNCTION

FUNCTION q800_b_fill(p_wc2)              
   DEFINE p_wc2   LIKE type_file.chr1000    
   LET g_sql = " SELECT sfb01,sfb02,sfb81,sfb05,''",
               "  FROM sfb_file",
               " WHERE ", p_wc2 , 
               " ORDER BY sfb01"   
   IF g_azw.azw04='2' THEN
   LET g_sql = " SELECT sfb01,sfb02,sfb81,sfb05,'' ",
               " FROM sfb_file",
               " WHERE ", p_wc2 , 
               " AND sfbplant IN ",g_auth,  #單身
               " ORDER BY sfb01 "
   END IF  
   PREPARE q800_pb FROM g_sql
   DECLARE sfb_curs CURSOR FOR q800_pb
 
   CALL g_sfb.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH sfb_curs INTO g_sfb[g_cnt].*   #單身 ARRAY 填充
   
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
   SELECT ima02 INTO g_sfb[g_cnt].ima02 FROM ima_file WHERE ima01 = g_sfb[g_cnt].sfb05 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_sfb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION


FUNCTION q800_out()
 
END FUNCTION
 
FUNCTION q800_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) ) THEN
       CALL cl_set_comp_entry("sfb01",TRUE)
    END IF                                                                                                 
                                                                                              
END FUNCTION  
               
FUNCTION q800_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                    
                                                                                
    IF p_cmd = 'u' AND ( NOT g_before_input_done )  THEN                                                             
      CALL cl_set_comp_entry("sfb01",FALSE)                                                                                       
    END IF
 
END FUNCTION            

###FUN-A50010 START ###
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

   DEFINE l_sfb             DYNAMIC ARRAY OF RECORD
             sfb01           LIKE sfb_file.sfb01,
             sfb02           LIKE sfb_file.sfb02,
             sfb05           LIKE sfb_file.sfb03, 
             ima02           LIKE ima_file.ima02,
             sfb08           LIKE sfb_file.sfb08, 
             sfb13           LIKE sfb_file.sfb13,   
             sfb15           LIKE sfb_file.sfb15  #子節點數
             END RECORD
   DEFINE l_snb             DYNAMIC ARRAY OF RECORD 
             snb01           LIKE snb_file.snb01,
             snb02           LIKE snb_file.snb02,
             snb022          LIKE snb_file.snb022,
             snb08a          LIKE snb_file.snb08a,
             snb13a          LIKE snb_file.snb13a, 
             snb15a          LIKE snb_file.snb15a
             END RECORD    
   DEFINE l_sfp             DYNAMIC ARRAY OF RECORD 
             sfp01           LIKE sfp_file.sfp01,
             sfp02           LIKE sfp_file.sfp02,
             sfp06           LIKE sfp_file.sfp06,
             sfpconf         LIKE sfp_file.sfpconf,
             sfp04           LIKE sfp_file.sfp04
             END RECORD 
   DEFINE  l_ecm            DYNAMIC ARRAY OF RECORD 
              ecm01          LIKE  ecm_file.ecm01,
              ecm03          LIKE  ecm_file.ecm03,
              ecm04          LIKE  ecm_file.ecm04,
              ecm45          LIKE  ecm_file.ecm45,
              ecm06          LIKE  ecm_file.ecm06,
             # eca02          LIKE  eca_file.eca02,
              ecm50          LIKE  ecm_file.ecm50,
              ecm51          LIKE  ecm_file.ecm51,
              ecm54          LIKE  ecm_file.ecm54,
              ecm59          LIKE  ecm_file.ecm59,
              wipqty         INTEGER,
              ecm301         LIKE  ecm_file.ecm301,
              ecm302         LIKE  ecm_file.ecm302,
              ecm303         LIKE  ecm_file.ecm303,
              ecm311         LIKE  ecm_file.ecm311,
              ecm312         LIKE  ecm_file.ecm312,
              ecm316         LIKE  ecm_file.ecm316,
              ecm313         LIKE  ecm_file.ecm313,
              ecm314         LIKE  ecm_file.ecm314,
              ecm315         LIKE  ecm_file.ecm315,
              ecm321         LIKE  ecm_file.ecm321,
              ecm322         LIKE  ecm_file.ecm322,
              ecm291         LIKE  ecm_file.ecm291,
              ecm292         LIKE  ecm_file.ecm292
              END RECORD
    DEFINE l_shm            DYNAMIC ARRAY OF RECORD
              shm01          LIKE  shm_file.shm01,
              shm06          LIKE  shm_file.shm06,
              shm13          LIKE  shm_file.shm13,
              shm15          LIKE  shm_file.shm15
              END RECORD 
    DEFINE l_sfu            DYNAMIC ARRAY OF RECORD
             sfu01           LIKE sfu_file.sfu01,
             sfu02           LIKE sfu_file.sfu02,
             sfuconf         LIKE sfu_file.sfuconf
             END RECORD

   DEFINE l_eca02            LIKE eca_file.eca02              
   DEFINE l_str              STRING
   DEFINE l_str1              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_cnt1             LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_count1           LIKE type_file.num5
   DEFINE l_prog_name        STRING
   DEFINE l_sfb02           STRING,
          l_sfb08           STRING 
  
   LET max_level = 20 #設定最大階層數瀿0
  
  
   
   IF l_ac > 0  THEN
   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET l_str = "1"
      LET g_tree[g_idx].id = l_str
      LET g_tree[g_idx].expanded = TRUE 
      CALL get_prog_name1("asf1016") RETURNING l_prog_name
      LET g_tree[g_idx].name= l_prog_name
      LET g_tree[g_idx].level = p_level
      
      
      CALL l_sfb.clear()
      

      #讓QBE出來的單頭都當作Tree的最上層
      LET g_sql=" SELECT DISTINCT sfb01,sfb02,sfb05,ima02,sfb08,sfb13,sfb15 FROM sfb_file ",
              " LEFT OUTER JOIN ima_file ON ima01 = sfb05 ",
              " WHERE sfb01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
      LET g_sql=" SELECT DISTINCT sfb01,sfb02,sfb05,ima02,sfb08,sfb13,sfb15 FROM sfb_file ",
              " LEFT OUTER JOIN ima_file ON ima01 = sfb05 ",
              " WHERE sfb01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
              " AND sfbplant IN ",g_auth
      END IF


 
      PREPARE q800_tree_pre1 FROM g_sql
      DECLARE q800_tree_cs1 CURSOR FOR q800_tree_pre1      

      LET l_i = 1      
      FOREACH q800_tree_cs1 INTO l_sfb[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF         
         LET p_level = p_level+1   
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".1"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿    
         LET l_sfb02 = l_sfb[l_i].sfb02  
         LET l_sfb08 = l_sfb[l_i].sfb08 
          CASE l_sfb[l_i].sfb02
           WHEN  "1" 
              LET l_prog_name = "sfb02_1"
           WHEN  "11"
              LET l_prog_name = "sfb02_11"   
           WHEN  "13"
              LET l_prog_name = "sfb02_13"   
           WHEN  "15"
              LET l_prog_name = "sfb02_15"      
           WHEN  "5"
              LET l_prog_name = "sfb02_5"      
           WHEN  "7"
              LET l_prog_name = "sfb02_7"
           WHEN  "8"
              LET l_prog_name = "sfb02_8"
         END CASE
         CALL  get_field_name1(l_prog_name,"asfi301") RETURNING  l_prog_name
         LET g_tree[g_idx].name = get_field_name("sfb01"),":",l_sfb[l_i].sfb01 CLIPPED," ",
                                  get_field_name("sfb02"),":",l_prog_name CLIPPED," ",
                                  get_field_name("sfb05"),":",l_sfb[l_i].sfb05 CLIPPED,"(",
                                  get_field_name("ima02"),":",l_sfb[l_i].ima02 CLIPPED,")",
                                  get_field_name("sfb08"),":",l_sfb08 CLIPPED," ",
                                  get_field_name("sfb13"),":",l_sfb[l_i].sfb13 CLIPPED," ",
                                  get_field_name("sfb15"),":",l_sfb[l_i].sfb15 CLIPPED
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi301"
         LET g_tree[g_idx].treekey1 = l_sfb[l_i].sfb01
         LET g_tree[g_idx].treekey2 = p_key2
         LET p_key1 = l_sfb[l_i].sfb01
         --LET l_i = l_i + 1

         
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".2"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
          CALL get_prog_name1("asf1004") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT COUNT(snb01) INTO l_count FROM snb_file WHERE snb01 = g_sfb[l_ac].sfb01
         IF l_count >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF         
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asft803"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level + 1
         LET g_sql= " SELECT DISTINCT snb01,snb02,snb022,snb08a,snb13a,snb15a ",
                    "  FROM snb_file ",
                    " WHERE snb01 = '" ,g_sfb[l_ac].sfb01 CLIPPED,"'"
         IF g_azw.azw04='2' THEN
         LET g_sql= " SELECT DISTINCT snb01,snb02,snb022,snb08a,snb13a,snb15a ",
                    "  FROM snb_file ",
                    " WHERE snb01 = '" ,g_sfb[l_ac].sfb01 CLIPPED,"'",
                    " AND snbplant IN ",g_auth
         END IF
         PREPARE q800_tree_pre2 FROM g_sql
         DECLARE q800_tree_cs2 CURSOR FOR q800_tree_pre2
         LET l_cnt = 1 
         FOREACH q800_tree_cs2 INTO l_snb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".2"
         LET l_str1 = l_cnt
         LET g_tree[g_idx].id = l_str+".2"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name = get_field_name("snb01"),":",l_snb[l_cnt].snb01 CLIPPED," ",
                                  get_field_name("snb02"),":",l_snb[l_cnt].snb02 CLIPPED," ",
                                  get_field_name("snb022"),":",l_snb[l_cnt].snb022 CLIPPED," ",
                                  get_field_name("snb08a"),":",l_snb[l_cnt].snb08a CLIPPED," ",
                                  get_field_name("snb13a"),":",l_snb[l_cnt].snb13a CLIPPED," ",
                                  get_field_name("snb15a"),":",l_snb[l_cnt].snb15a CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asft803"
         LET g_tree[g_idx].treekey1 = l_snb[l_cnt].snb01
         LET g_tree[g_idx].treekey2 = l_snb[l_cnt].snb02
         LET l_cnt = l_cnt+1
         END FOREACH
         ELSE  LET p_level = p_level+1  
         END IF

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".3"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
         CALL get_prog_name1("asf1005") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='1'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='1'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF         
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi511"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='1'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='1' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"			

         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='1'",
                     " AND sfpplant IN ",g_auth ,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='1' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         END IF

         PREPARE q800_tree_pre3 FROM g_sql
         DECLARE q800_tree_cs3 CURSOR FOR q800_tree_pre3
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs3 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".3"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".3"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name = get_field_name("sfp01"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi511"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill2(p_wc,g_tree[g_idx].id,p_level,NULL,
                                g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".4"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1006") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='2'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='2'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF          
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi512"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='2'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='2' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='2'",
                     " AND sfpplant IN ",g_auth ,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='2' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         END IF
         PREPARE q800_tree_pre5 FROM g_sql
         DECLARE q800_tree_cs5 CURSOR FOR q800_tree_pre5
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs5 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".4"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".4"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_field_name("sfp01"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi512"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill3(p_wc,g_tree[g_idx].id,p_level,NULL,
                                g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".5"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1007") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
          SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='3'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='3'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF            
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi513"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql ="  SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='3'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='3' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"
         IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='3'",
                     " AND sfpplant IN ",g_auth,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='3' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"
         END IF
         PREPARE q800_tree_pre7 FROM g_sql
         DECLARE q800_tree_cs7 CURSOR FOR q800_tree_pre7
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs7 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".5"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".5"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_field_name("sfp01"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi513"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill4(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF      


         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".6"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1008") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='4'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='4'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF         
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi514"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='4'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='4' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='4'",
                     " AND sfpplant IN ",g_auth,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='4' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         END IF
         PREPARE q800_tree_pre9 FROM g_sql
         DECLARE q800_tree_cs9 CURSOR FOR q800_tree_pre9
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs9 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".6"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".6"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_field_name("sfp01"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi514"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill5(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF      

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".7"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1009") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='6'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='6'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF           
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi526"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='6'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='6' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='6'",
                     " AND sfpplant IN ",g_auth,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='6' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         END IF

         PREPARE q800_tree_pre11 FROM g_sql
         DECLARE q800_tree_cs11 CURSOR FOR q800_tree_pre11
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs11 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".7"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".7"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_prog_name1("asf1017"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi526"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill6(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF   

            
         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".8"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1010") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='7'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='7'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF            
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi527"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='7'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='7' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='7'",
                     " AND sfpplant IN ",g_auth,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='7' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         END IF
         PREPARE q800_tree_pre13 FROM g_sql
         DECLARE q800_tree_cs13 CURSOR FOR q800_tree_pre13
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs13 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".8"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".8"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_prog_name1("asf1017"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi527"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill7(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF   
          

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".9"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1011") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='8'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='8'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF          
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi528"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='8'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='8' ",		
                     " AND sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='8'",
                     " AND sfpplant IN ",g_auth,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='8' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"
         END IF
         PREPARE q800_tree_pre15 FROM g_sql
         DECLARE q800_tree_cs15 CURSOR FOR q800_tree_pre15
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs15 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".9"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".9"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_prog_name1("asf1017"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi528"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill8(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF   

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".10"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1012") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT count(sfp01) INTO l_count FROM sfp_file, sfs_file 				
         WHERE sfp01 = sfs01 							
         AND sfp06 ='9'
         AND sfs03 = g_sfb[l_ac].sfb01
         
         SELECT count(sfp01) INTO l_count1 FROM sfp_file,sfe_file				
         WHERE sfp01 = sfe02				
         AND sfp04 ='Y' 				
         AND sfp06 ='9'	
          AND sfe01 = g_sfb[l_ac].sfb01	                      
         IF l_count >0 OR l_count1 >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF           
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi529"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='9'",
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='9' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04 ",
                     " FROM sfp_file,sfs_file ",
                     " WHERE  sfs01 = sfp01 ",
                     " AND sfs03 = '",g_sfb[l_ac].sfb01,"'",
                     " AND sfp06 ='9'",
                     " AND sfpplant IN ",g_auth,
                     " UNION ",				
                     " SELECT DISTINCT sfp01,sfp02,sfp06,sfpconf,sfp04",			
                     " FROM sfp_file,sfe_file ",				
                     " WHERE sfp01 = sfe02",				
                     " AND sfp04 ='Y' ",
                     " AND sfp06 ='9' ",		
                     " AND  sfe01 = '",g_sfb[l_ac].sfb01,"'"	
         END IF
         PREPARE q800_tree_pre17 FROM g_sql
         DECLARE q800_tree_cs17 CURSOR FOR q800_tree_pre17
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs17 INTO l_sfp[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".10"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".10"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name =  get_prog_name1("asf1017"),":",l_sfp[l_cnt1].sfp01 CLIPPED," ",
                                  get_field_name("sfp02"),":",l_sfp[l_cnt1].sfp02 CLIPPED," ",
                                  get_field_name("sfp06"),":",l_sfp[l_cnt1].sfp06 CLIPPED," ",
                                  get_field_name("sfpconf"),":",l_sfp[l_cnt1].sfpconf CLIPPED," "
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi529"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfp[l_cnt1].sfp01
         CALL q800_tree_fill9(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_sfp[l_cnt1].sfp04)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF   


         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".11"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1013") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT COUNT(ecm01) INTO l_count FROM  ecm_file
                WHERE ecm01 = g_sfb[l_ac].sfb01
         IF l_count >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF         
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "aeci700"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1
         LET g_sql = " SELECT DISTINCT ecm01,ecm03,ecm04,ecm45,ecm06,ecm50,ecm51 ",
                     " ,ecm54,ecm59,0, ecm301,ecm302,ecm303,ecm311,ecm312,ecm316,",
                     " ecm313,ecm314,ecm315,ecm321,ecm322,ecm291,ecm292",
                     " FROM ecm_file ",
                     " WHERE ecm01 = '",g_sfb[l_ac].sfb01,"'",
                     " ORDER BY ecm03 "
         IF g_azw.azw04='2' THEN
         LET g_sql = " SELECT DISTINCT ecm01,ecm03,ecm04,ecm45,ecm06,ecm50,ecm51 ",
                     " ,ecm54,ecm59,0, ecm301,ecm302,ecm303,ecm311,ecm312,ecm316,",
                     " ecm313,ecm314,ecm315,ecm321,ecm322,ecm291,ecm292",
                     " FROM ecm_file ",
                     " WHERE ecm01 = '",g_sfb[l_ac].sfb01,"'",
                     " AND ecmplant IN ",g_auth,
                     " ORDER BY ecm03 "
                      
         END IF
         PREPARE q800_tree_pre19 FROM g_sql
         DECLARE q800_tree_cs19 CURSOR FOR q800_tree_pre19
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs19 INTO l_ecm[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF  
         IF l_ecm[l_cnt1].ecm54='Y' THEN
            LET l_ecm[l_cnt1].wipqty = l_ecm[l_cnt1].ecm291 
                                     - l_ecm[l_cnt1].ecm311*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm312*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm313*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm314*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm316*l_ecm[l_cnt1].ecm59
         ELSE 
            LET l_ecm[l_cnt1].wipqty = l_ecm[l_cnt1].ecm301
                                     + l_ecm[l_cnt1].ecm302
                                     + l_ecm[l_cnt1].ecm303
                                     - l_ecm[l_cnt1].ecm311*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm312*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm313*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm314*l_ecm[l_cnt1].ecm59
                                     - l_ecm[l_cnt1].ecm316*l_ecm[l_cnt1].ecm59
         END IF
         SELECT DISTINCT eca02 INTO l_eca02 FROM eca_file WHERE eca01 = l_ecm[l_cnt1].ecm06
         
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".11"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".11"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        
         
         LET g_tree[g_idx].name = get_field_name("ecm01"),":",l_ecm[l_cnt1].ecm01 CLIPPED," ",
                                  get_field_name("ecm03"),":",l_ecm[l_cnt1].ecm03 CLIPPED," ",
                                  get_field_name("ecm04"),":",l_ecm[l_cnt1].ecm04 CLIPPED,"(",
                                  get_field_name("ecm45"),":",l_ecm[l_cnt1].ecm45 CLIPPED," )",
                                  get_field_name("ecm06"),":",l_ecm[l_cnt1].ecm06 CLIPPED,"(",
                                  get_field_name("eca02"),":", l_eca02 CLIPPED,")",
                                  get_field_name("ecm50"),":",l_ecm[l_cnt1].ecm50 CLIPPED," ",
                                  get_field_name("ecm51"),":",l_ecm[l_cnt1].ecm51 CLIPPED," ",
                                  " WIP :",l_ecm[l_cnt1].wipqty CLIPPED," ",
                                  "+",get_field_name("ecm301"),":",l_ecm[l_cnt1].ecm301 CLIPPED," ",
                                  "+",get_field_name("ecm302"),":",l_ecm[l_cnt1].ecm302 CLIPPED," ",
                                  "+",get_field_name("ecm303"),":",l_ecm[l_cnt1].ecm303 CLIPPED," ",
                                  "-",get_field_name("ecm311"),":",l_ecm[l_cnt1].ecm311 CLIPPED," ",
                                  "-",get_field_name("ecm312"),":",l_ecm[l_cnt1].ecm312 CLIPPED," ",
                                  "-",get_field_name("ecm316"),":",l_ecm[l_cnt1].ecm316 CLIPPED," ",
                                  "-",get_field_name("ecm313"),":",l_ecm[l_cnt1].ecm313 CLIPPED," ",
                                  "-",get_field_name("ecm314"),":",l_ecm[l_cnt1].ecm314 CLIPPED," ",
                                  get_field_name("ecm315"),":",l_ecm[l_cnt1].ecm315 CLIPPED," ",
                                  get_field_name("ecm321"),":",l_ecm[l_cnt1].ecm321 CLIPPED," ",
                                  get_field_name("ecm322"),":",l_ecm[l_cnt1].ecm322 CLIPPED," ",
                                  get_field_name("ecm291"),":",l_ecm[l_cnt1].ecm291 CLIPPED," ",
                                  get_field_name("ecm292"),":",l_ecm[l_cnt1].ecm292 CLIPPED," "
                                  
                                  
                                  
                                  
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "aeci700"
         LET g_tree[g_idx].treekey1 = l_ecm[l_cnt1].ecm01
         LET g_tree[g_idx].treekey2 = l_ecm[l_cnt1].ecm01
         --CALL q800_tree_fill10(p_wc,g_tree[g_idx].id,p_level,NULL,
                                 --g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF  

         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".12"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1014") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED 
         SELECT COUNT(shm01) INTO l_count FROM  shm_file
                WHERE shm012 = g_sfb[l_ac].sfb01
         
         IF l_count >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF         
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi310"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1 
       LET g_sql ="  SELECT DISTINCT shm01,shm06,shm13,shm15 ",
                    "  FROM shm_file " ,
                    "  WHERE  shm012 ='",g_sfb[l_ac].sfb01,"'",
                    "  ORDER BY shm01"   
         IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT shm01,shm06,shm13,shm15 ",
                    "  FROM shm_file " ,
                    "  WHERE  shm012 ='",g_sfb[l_ac].sfb01,"'",
                    " AND shmplant IN ",g_auth,
                    "  ORDER BY shm01" 
         END IF
         PREPARE q800_tree_pre20 FROM g_sql
         DECLARE q800_tree_cs20 CURSOR FOR q800_tree_pre20
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs20 INTO l_shm[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".12"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".12"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
         LET g_tree[g_idx].name = get_field_name("shm01"),":",l_shm[l_cnt1].shm01 CLIPPED," ",
                                  get_field_name("shm06"),":",l_shm[l_cnt1].shm06 CLIPPED," ",
                                  get_field_name("shm13"),":",l_shm[l_cnt1].shm13 CLIPPED," ", 
                                  get_field_name("shm15"),":",l_shm[l_cnt1].shm15 CLIPPED," "
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asfi310"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_shm[l_cnt1].shm01
         CALL q800_tree_fill10(p_wc,g_tree[g_idx].id,p_level,NULL,
                                  g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF  


         LET p_level = p_level-1
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str
         LET g_tree[g_idx].id = l_str+".13"
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿   
         CALL get_prog_name1("asf1015") RETURNING l_prog_name
         LET g_tree[g_idx].name = l_prog_name CLIPPED
         SELECT COUNT(sfu01) INTO l_count FROM sfu_file,sfv_file
         WHERE  sfu01 = sfv01  AND sfv11 = g_sfb[l_ac].sfb01
         AND (sfv11 NOT IN ( SELECT tsc19 FROM tsc_file WHERE tsc19 IS NOT NULL) 
         AND sfv11 NOT IN ( SELECT tse19 FROM tse_file WHERE tse19 IS NOT NULL))
         IF l_count >0 THEN 
             LET g_tree[g_idx].has_children = TRUE
         ELSE
             LET g_tree[g_idx].has_children = FALSE
         END IF         
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asft620"
         LET g_tree[g_idx].treekey1 = NULL
         LET g_tree[g_idx].treekey2 = p_key2
         IF g_tree[g_idx].has_children THEN
         LET p_level = p_level+1  
         LET g_sql = " SELECT DISTINCT sfu01,sfu02,sfuconf " ,
                     "  FROM sfu_file,sfv_file ",
                     "  WHERE  sfu01 = sfv01 ",
                     " AND sfv11 = '",g_sfb[l_ac].sfb01,"'",
                     " AND (sfv11 NOT IN (",
                     " SELECT tsc19 FROM tsc_file WHERE tsc19 IS NOT NULL)", 
                     " AND sfv11 NOT IN ( ",
                     "SELECT tse19 FROM tse_file WHERE tse19 IS NOT NULL))"
         IF g_azw.azw04='2' THEN 
         LET g_sql = " SELECT DISTINCT sfu01,sfu02,sfuconf " ,
                     "  FROM sfu_file,sfv_file ",
                     "  WHERE  sfu01 = sfv01 ",
                     " AND sfv11 = '",g_sfb[l_ac].sfb01,"'",
                     " AND (sfv11 NOT IN (",
                     " SELECT tsc19 FROM tsc_file WHERE tsc19 IS NOT NULL)", 
                     " AND sfv11 NOT IN ( ",
                     "SELECT tse19 FROM tse_file WHERE tse19 IS NOT NULL))",
                     " AND sfvplant IN ",g_auth
         END IF
         PREPARE q800_tree_pre22 FROM g_sql
         DECLARE q800_tree_cs22 CURSOR FOR q800_tree_pre22
         LET l_cnt1 = 1 
         FOREACH q800_tree_cs22 INTO l_sfu[l_cnt1].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = l_str+".13"
         LET l_str1 = l_cnt1  #數值轉字串
         LET g_tree[g_idx].id = l_str+".13"+"."+l_str1
         LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿 
         LET g_tree[g_idx].name = get_field_name("sfu01"),":",l_sfu[l_cnt1].sfu01 CLIPPED," ",
                                  get_field_name("sfu02"),":",l_sfu[l_cnt1].sfu02 CLIPPED," ",
                                  get_field_name("sfuconf"),":",l_sfu[l_cnt1].sfuconf CLIPPED," "
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = "asft620"
         LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
         LET g_tree[g_idx].treekey2 = l_sfu[l_cnt1].sfu01
         CALL q800_tree_fill11(p_wc,g_tree[g_idx].id,p_level,NULL,
                                  g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
         LET l_cnt1 =l_cnt1 +1                       
         END FOREACH
         ELSE  LET p_level = p_level+1 
         END IF              
                     
         
          
         
      END FOREACH
   END IF
   END IF
  
  
END FUNCTION 


FUNCTION  q800_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
   DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
   IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF

   PREPARE q800_tree_pre4 FROM g_sql
   DECLARE q800_tree_cs4 CURSOR FOR q800_tree_pre4
   LET l_i = 1
   FOREACH q800_tree_cs4 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05  
         
       LET g_tree[g_idx].name = get_field_name("sfs01"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi511"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH             


   


END FUNCTION

FUNCTION  q800_tree_fill3(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
   DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
   IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre6 FROM g_sql
   DECLARE q800_tree_cs6 CURSOR FOR q800_tree_pre6
   LET l_i = 1
   FOREACH q800_tree_cs6 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05          
         
       LET g_tree[g_idx].name = get_field_name("sfs01"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi512"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH             


END FUNCTION

FUNCTION  q800_tree_fill4(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
      DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre8 FROM g_sql
   DECLARE q800_tree_cs8 CURSOR FOR q800_tree_pre8
   LET l_i = 1
   FOREACH q800_tree_cs8 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05          
         
       LET g_tree[g_idx].name = get_field_name("sfs01"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi513"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH             


END FUNCTION

FUNCTION  q800_tree_fill5(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
      DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
   IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre10 FROM g_sql
   DECLARE q800_tree_cs10 CURSOR FOR q800_tree_pre10
   LET l_i = 1
   FOREACH q800_tree_cs10 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05          
         
       LET g_tree[g_idx].name = get_field_name("sfs01"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi514"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH          

END FUNCTION

FUNCTION  q800_tree_fill6(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
    DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
      DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre12 FROM g_sql
   DECLARE q800_tree_cs12 CURSOR FOR q800_tree_pre12
   LET l_i = 1
   FOREACH q800_tree_cs12 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05          
         
       LET g_tree[g_idx].name = get_prog_name1("asf1017"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi526"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH          



END FUNCTION

FUNCTION  q800_tree_fill7(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
    DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
      DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
   IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre14 FROM g_sql
   DECLARE q800_tree_cs14 CURSOR FOR q800_tree_pre14
   LET l_i = 1
   FOREACH q800_tree_cs14 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05          
         
       LET g_tree[g_idx].name = get_prog_name1("asf1017"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path ="asfi527"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH          



END FUNCTION

FUNCTION  q800_tree_fill8(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
    DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
      DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING
   LET p_level= p_level+1 
   IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre16 FROM g_sql
   DECLARE q800_tree_cs16 CURSOR FOR q800_tree_pre16
   LET l_i = 1
   FOREACH q800_tree_cs16 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
        LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05         
         
       LET g_tree[g_idx].name = get_prog_name1("asf1017"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                               get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi528"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH          



END FUNCTION

FUNCTION  q800_tree_fill9(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_sfp04)
    DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_sfp04            LIKE sfp_file.sfp04
   DEFINE l_sfs             DYNAMIC ARRAY OF RECORD 
             sfs01           LIKE sfs_file.sfs01,
             sfs02           LIKE sfs_file.sfs02,
             sfs04           LIKE sfs_file.sfs04,
             ima02           LIKE ima_file.ima02,
             sfs05           LIKE sfs_file.sfs05, 
             sfs06           LIKE sfs_file.sfs06
             END RECORD  

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
   DEFINE l_sfs02 STRING
   DEFINE l_sfs05 STRING   
   LET p_level= p_level+1 
   IF p_sfp04 = 'N' THEN
      LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'"
      IF g_azw.azw04='2' THEN
         LET g_sql ="  SELECT DISTINCT sfs01,sfs02,sfs04,ima02,sfs05,sfs06 ",
                "  FROM sfp_file,sfs_file ",
                "  LEFT OUTER JOIN ima_file ON ima01 = sfs04 ",
                "  WHERE  sfs01 = sfp01 ",
                "  AND sfs01 ='",p_key2 CLIPPED,"'",
                "  AND sfs03 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",
                " AND sfsplant IN ",g_auth
      END IF
   ELSE
      LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'"	
      IF g_azw.azw04='2' THEN
         LET g_sql = "SELECT DISTINCT sfe02,sfe28,sfe07,ima02,sfe16,sfe17",					
                  " FROM  sfe_file	",				
                  " LEFT OUTER JOIN ima_file ON ima01 = sfe07",					
                  " WHERE  sfe01 = '",g_sfb[l_ac].sfb01 CLIPPED,"'",				
                  " AND sfe02 = '",p_key2,"'",
                  " AND sfeplant IN ",g_auth
      END IF
   END IF
   PREPARE q800_tree_pre18 FROM g_sql
   DECLARE q800_tree_cs18 CURSOR FOR q800_tree_pre18
   LET l_i = 1
   FOREACH q800_tree_cs18 INTO l_sfs[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_sfs02 = l_sfs[l_i].sfs02 
       LET l_sfs05 = l_sfs[l_i].sfs05          
         
       LET g_tree[g_idx].name = get_prog_name1("asf1017"),":",l_sfs[l_i].sfs01 CLIPPED ," ",
                                get_field_name("sfs02"),":",l_sfs02 CLIPPED ," ",
                                get_field_name("sfs04"),":",l_sfs[l_i].sfs04 CLIPPED ," ",
                                get_field_name("ima02"),":",l_sfs[l_i].ima02 CLIPPED ," ",
                                get_field_name("sfs05"),":",l_sfs05 CLIPPED ," ",
                               get_field_name("sfs06"),":",l_sfs[l_i].sfs06 CLIPPED ," "
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi529"
        LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = l_sfs[l_i].sfs01
       LET l_i = l_i +1
    END FOREACH          



END FUNCTION

FUNCTION  q800_tree_fill10(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_sgm             DYNAMIC ARRAY OF RECORD
            sgm03            LIKE sgm_file.sgm03,
            sgm04            LIKE sgm_file.sgm04,
            sgm45            LIKE sgm_file.sgm45,
            sgm06            LIKE sgm_file.sgm06,
            sgm50            LIKE sgm_file.sgm50,
            sgm51            LIKE sgm_file.sgm51,
            wipqty           LIKE type_file.num5,
            sgm54            LIKE sgm_file.sgm54,
            sgm59            LIKE sgm_file.sgm59,
            sgm301            LIKE sgm_file.sgm301,
            sgm302            LIKE sgm_file.sgm302,
            sgm303            LIKE sgm_file.sgm303,
            sgm304            LIKE sgm_file.sgm304,
            sgm311            LIKE sgm_file.sgm311,
            sgm312            LIKE sgm_file.sgm312,
            sgm313            LIKE sgm_file.sgm313,
            sgm314            LIKE sgm_file.sgm314,
            sgm315            LIKE sgm_file.sgm315,
            sgm316            LIKE sgm_file.sgm316,
            sgm317            LIKE sgm_file.sgm317,
            sgm321            LIKE sgm_file.sgm321,
            sgm322            LIKE sgm_file.sgm322,
            sgm291            LIKE sgm_file.sgm291,
            sgm292            LIKE sgm_file.sgm292
            END RECORD
       DEFINE l_wipqty           STRING,
              l_sgm54            STRING,
              l_sgm59            STRING,
              l_sgm301           STRING,
              l_sgm302           STRING,
              l_sgm303           STRING,
              l_sgm304           STRING,
              l_sgm311           STRING,
              l_sgm312           STRING,
              l_sgm313           STRING,
              l_sgm314           STRING,
              l_sgm315           STRING,
              l_sgm316           STRING,
              l_sgm317           STRING,
              l_sgm321           STRING,
              l_sgm322           STRING,
              l_sgm291           STRING,
              l_sgm292           STRING

   DEFINE l_eca02            LIKE eca_file.eca02
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING
   LET p_level= p_level+1 
   LET g_sql =" SELECT DISTINCT sgm03,sgm04,sgm45,sgm06,sgm50,sgm51,0,sgm54,",
              " sgm59,sgm301,sgm302,sgm303,sgm304,sgm311,sgm312,sgm313,",
              " sgm314,sgm315,sgm316,sgm317,sgm321,sgm322,sgm291,sgm292",
              "  FROM sgm_file ",
              "  WHERE  sgm01 = '",p_key2,"'",
              "  AND sgm02 = '",g_sfb[l_ac].sfb01,"'",
              "  ORDER BY sgm03"
   IF g_azw.azw04='2' THEN
   LET g_sql =" SELECT DISTINCT sgm03,sgm04,sgm45,sgm06,sgm50,sgm51,0,sgm54,",
              " sgm59,sgm301,sgm302,sgm303,sgm304,sgm311,sgm312,sgm313,",
              " sgm314,sgm315,sgm316,sgm317,sgm321,sgm322,sgm291,sgm292",
              "  FROM sgm_file ",
              "  WHERE  sgm01 = '",p_key2,"'",
              "  AND sgm02 = '",g_sfb[l_ac].sfb01,"'",
               " AND sgmplant IN ",g_auth,
              "  ORDER BY sgm03"
    END IF
   PREPARE q800_tree_pre21 FROM g_sql
   DECLARE q800_tree_cs21 CURSOR FOR q800_tree_pre21
   LET l_i = 1
   FOREACH q800_tree_cs21 INTO l_sgm[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF  
   IF l_sgm[l_i].sgm54='Y' THEN
            LET l_sgm[l_i].wipqty = l_sgm[l_i].sgm291 
                                     - l_sgm[l_i].sgm311*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm312*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm313*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm314*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm316*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm317*l_sgm[l_i].sgm59
         ELSE 
            LET l_sgm[l_i].wipqty = l_sgm[l_i].sgm301
                                     + l_sgm[l_i].sgm302
                                     + l_sgm[l_i].sgm303
                                     + l_sgm[l_i].sgm304
                                     - l_sgm[l_i].sgm311*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm312*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm313*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm314*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm316*l_sgm[l_i].sgm59
                                     - l_sgm[l_i].sgm317*l_sgm[l_i].sgm59
         END IF
    SELECT DISTINCT eca02 INTO l_eca02 FROM eca_file WHERE eca01 = l_sgm[l_i].sgm06
   
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:不展锿       
       LET l_wipqty = l_sgm[l_i].wipqty
       LET l_sgm301 = l_sgm[l_i].sgm301
       LET l_sgm302 = l_sgm[l_i].sgm302
       LET l_sgm303 = l_sgm[l_i].sgm303
       LET l_sgm311 = l_sgm[l_i].sgm311
       LET l_sgm312 = l_sgm[l_i].sgm312
       LET l_sgm313 = l_sgm[l_i].sgm313
       LET l_sgm314 = l_sgm[l_i].sgm314
       LET l_sgm315 = l_sgm[l_i].sgm315
       LET l_sgm316 = l_sgm[l_i].sgm316
       LET l_sgm317 = l_sgm[l_i].sgm317
       LET l_sgm321 = l_sgm[l_i].sgm321
       LET l_sgm322 = l_sgm[l_i].sgm322
       LET l_sgm291 = l_sgm[l_i].sgm291
       LET l_sgm292 = l_sgm[l_i].sgm292
       LET g_tree[g_idx].name = l_sgm[l_i].sgm03 CLIPPED," ",
                                l_sgm[l_i].sgm04 CLIPPED,"(",
                                l_sgm[l_i].sgm45 CLIPPED,")",
                                l_sgm[l_i].sgm06 CLIPPED," ",
                                get_field_name("sgm50"),":",l_sgm[l_i].sgm50 CLIPPED," ",
                                get_field_name("sgm51"),":",l_sgm[l_i].sgm51 CLIPPED," ",
                                "WIP :",l_wipqty CLIPPED," ",
                                "+",get_field_name("sgm301"),":",l_sgm301 CLIPPED," ",
                                "+",get_field_name("sgm302"),":",l_sgm302 CLIPPED," ",
                                "+",get_field_name("sgm303"),":",l_sgm303 CLIPPED," ",
                                "+",get_field_name("sgm304"),":",l_sgm304 CLIPPED," ",
                                "-",get_field_name("sgm311"),":",l_sgm311 CLIPPED," ",
                                "-",get_field_name("sgm312"),":",l_sgm312 CLIPPED," ",
                                "-",get_field_name("sgm313"),":",l_sgm313 CLIPPED," ",
                                "-",get_field_name("sgm314"),":",l_sgm314 CLIPPED," ",
                                get_field_name("sgm315"),":",l_sgm315 CLIPPED," ",
                                "-",get_field_name("sgm316"),":",l_sgm316 CLIPPED," ",
                                "-",get_field_name("sgm317"),":",l_sgm317 CLIPPED," ",
                                get_field_name("sgm321"),":",l_sgm321 CLIPPED," ",
                                get_field_name("sgm322"),":",l_sgm322 CLIPPED," ",
                                get_field_name("sgm291"),":",l_sgm291 CLIPPED," ",
                                get_field_name("sgm292"),":",l_sgm292 CLIPPED," "
                                
                                  
       LET g_tree[g_idx].level = p_level
       LET g_tree[g_idx].path = "asfi310"
       LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
       LET g_tree[g_idx].treekey2 = p_key2
       LET l_i = l_i +1
    END FOREACH           
              
              

   
END FUNCTION 

FUNCTION  q800_tree_fill11(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_sfv              DYNAMIC ARRAY OF RECORD
            sfv01            LIKE sfv_file.sfv01,
            sfv03            LIKE sfv_file.sfv03,
            sfv09            LIKE sfv_file.sfv09,
            sfv08            LIKE sfv_file.sfv08
            END RECORD
   DEFINE l_sfv03            STRING,
          l_sfv09            STRING
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_prog_name        STRING

   LET p_level= p_level+1 
    LET g_sql =" SELECT DISTINCT sfv01,sfv03,sfv09,sfv08 ",
             "  FROM sfu_file,sfv_file",
             "  WHERE  sfu01 = sfv01 ",
             "  AND sfv01 = '",p_key2,"'",
             " AND sfv11 = '",g_sfb[l_ac].sfb01,"'",
             " AND (sfv11 NOT IN (",
             " SELECT tsc19 FROM tsc_file WHERE tsc19 IS NOT NULL)", 
             " AND sfv11 NOT IN ( ",
             "SELECT tse19 FROM tse_file WHERE tse19 IS NOT NULL))"
   IF g_azw.azw04='2' THEN
   LET g_sql =" SELECT DISTINCT sfv01,sfv03,sfv09,sfv08 ",
             "  FROM sfu_file,sfv_file",
             "  WHERE  sfu01 = sfv01 ",
             "  AND sfv01 = '",p_key2,"'",
             " AND sfv11 = '",g_sfb[l_ac].sfb01,"'",
             " AND (sfv11 NOT IN (",
             " SELECT tsc19 FROM tsc_file WHERE tsc19 IS NOT NULL)", 
             " AND sfv11 NOT IN ( ",
             "SELECT tse19 FROM tse_file WHERE tse19 IS NOT NULL))",
             " AND sfvplant IN ",g_auth
    END IF
   PREPARE q800_tree_pre23 FROM g_sql
   DECLARE q800_tree_cs23 CURSOR FOR q800_tree_pre23
   LET l_i = 1
   FOREACH q800_tree_cs23 INTO l_sfv[l_i].*
   IF SQLCA.sqlcode THEN
      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
      EXIT FOREACH
   END IF   
   LET g_idx = g_idx + 1
       LET g_tree[g_idx].pid = p_pid
       LET l_str = l_i  #數值轉字串
       LET g_tree[g_idx].id = p_pid+"."+l_str
       LET g_tree[g_idx].expanded = TRUE     #TRUE:展開, FALSE:
       LET l_sfv03 = l_sfv[l_i].sfv03
       LET l_sfv09 = l_sfv[l_i].sfv09
    LET g_tree[g_idx].name =  get_field_name("sfv01"),":",l_sfv[l_i].sfv01 CLIPPED," ",
                              get_field_name("sfv03"),":",l_sfv03 CLIPPED," ",
                              get_field_name("sfv09"),":",l_sfv09 CLIPPED," ", 
                              get_field_name("sfv08"),":",l_sfv[l_i].sfv08 CLIPPED," "
    LET g_tree[g_idx].level = p_level
    LET g_tree[g_idx].path = "asft620"
    LET g_tree[g_idx].treekey1 = g_sfb[l_ac].sfb01
    LET g_tree[g_idx].treekey2 = l_sfv[l_i].sfv01
    LET l_i = l_i +1
    END FOREACH          
   

END FUNCTION



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
# Descriptions...: 展開節鹿
# Date & Author..: 10/05/10
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

#################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/10 
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION q800_tree_update()
   #Tree重查並展開focus節鹿  
   #CALL q800_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充
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
      IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey1 == g_sfb[l_ac].sfb01) CLIPPED THEN  # 尋找節鹿        
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
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

FUNCTION q800_run(p_index)
   DEFINE p_index       STRING
   DEFINE l_cmd         LIKE type_file.chr1000 
   DEFINE l_name        STRING
   LET l_name = g_tree[p_index].path CLIPPED
   
   CASE l_name 
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
      WHEN "asft803"
         LET l_cmd = "asft803 '",g_tree[p_index].treekey1,"' '",g_tree[p_index].treekey2,"'"
         CALL cl_cmdrun_wait(l_cmd)
      WHEN "asfi511"
         CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi511 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi511_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd) 
           WHEN "icd"
              LET l_cmd = "asfi511_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                
        END CASE
      WHEN "asfi512"
         CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi512 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi512_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi512_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "asfi513"
        CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi513 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi513_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi513_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "asfi514"
          CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi514 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi514_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi514_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "asfi526"
          CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi526 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi526_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi526_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "asfi527"
         CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi527 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi527_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi527_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "asfi528"
         CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi528 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi528_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi528_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "asfi529"
         CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asfi529 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asfi529_slk '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asfi529_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
      WHEN "aeci700"
         CASE g_sma.sma124 
           WHEN "std"
               LET l_cmd = "aeci700 '",g_tree[p_index].treekey2,"'"
               CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
               LET l_cmd = "aeci700_slk '",g_tree[p_index].treekey2,"'"
               CALL cl_cmdrun_wait(l_cmd)               
           WHEN "icd"
               LET l_cmd = "aeci700_icd '",g_tree[p_index].treekey2,"'"
               CALL cl_cmdrun_wait(l_cmd)
        END CASE
      WHEN "asfi310"
         LET l_cmd = "asfi310 '",g_tree[p_index].treekey2,"'"
         CALL cl_cmdrun_wait(l_cmd)
      WHEN "asft620"
         CASE g_sma.sma124 
           WHEN "std"
              LET l_cmd = "asft620 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)
           WHEN "slk"
              LET l_cmd = "asft620 '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)                  
           WHEN "icd"
              LET l_cmd = "asft620_icd '",g_tree[p_index].treekey2,"'"
              CALL cl_cmdrun_wait(l_cmd)  
        END CASE
   END CASE
END FUNCTION














 
