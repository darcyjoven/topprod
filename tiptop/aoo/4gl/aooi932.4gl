# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aooi932.4gl
# Descriptions...: 管理組織架構建立作業
# Date & Author..: 2009/10/27 By tommas
# Modify.........: No:TQC-9A0163 2010/04/21 By tommas
# Modify.........: No:FUN-A50010 2010/05/06 By WangX 添加查詢，上下筆功能
# Modify.........: No:TQC-A60039 10/06/10 By sunchenxu tree功能修改
# Modify.........: No:TQC-B10239 11/01/25 By rainy Action修正
# Modify.........: No:FUN-B30157 11/03/21 By rainy 新增樹狀報表

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_azw07      LIKE azw_file.azw07,
         g_azw07_t    LIKE azw_file.azw07,
         g_azw07_o    LIKE azw_file.azw07,
         g_azw        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
            azw01     LIKE azw_file.azw01,
            azp02     LIKE azp_file.azp02,
            azw02     LIKE azw_file.azw02
                      END RECORD,
         g_azw_t      RECORD                   #程式變數 (舊值)
            azw01     LIKE azw_file.azw01,
            azp02     LIKE azp_file.azp02,
            azw02     LIKE azw_file.azw02
                      END RECORD,
         m_azp02      LIKE azp_file.azp02,         
         i            LIKE type_file.num5,         
         g_wc,g_sql   STRING,  
         g_rec_b      LIKE type_file.num5,         #單身筆數            
         g_azw_del    DYNAMIC ARRAY OF RECORD      #刪除前的暫存檔，將於save之後，統一刪除
         azw01        LIKE azw_file.azw01
                      END RECORD,
         g_azwe       DYNAMIC ARRAY OF RECORD
            azwe01    LIKE azwe_file.azwe01,    #Table名稱
            azwe02    LIKE azwe_file.azwe02,    #資料群組代碼
            azwc02    LIKE azwc_file.azwc02     #資料群組代碼說明
                      END RECORD ,
         g_azw01      DYNAMIC ARRAY OF RECORD
            azw01    LIKE azw_file.azw01
                      END RECORD ,
         l_ac         LIKE type_file.num5                 #目前處理的ARRAY
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL  #FUN-A50010
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        
DEFINE   g_row_count     LIKE type_file.num10    
DEFINE   g_curs_index    LIKE type_file.num10   

DEFINE   g_str           STRING
DEFINE   l_sql           STRING

DEFINE   l_table         STRING
DEFINE g_wc_o            STRING                #g_wc舊值備份 #FUN-A50010
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱          
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #1:有子節點 null:無子節點          
          expanded       BOOLEAN,                #0:不展開 1:展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以"."隔開     #FUN-A50010
          treekey1       STRING,                                       #FUN-A50010 
          azp02_t        LIKE azp_file.azp02,
          azw02          LIKE azw_file.azw02
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path         #FUN-A50010
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N   #FUN-A50010
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop) #FUN-A50010
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop) #FUN-A50010
DEFINE g_abso            LIKE type_file.num10    #跳頁頁數
DEFINE mi_no_ask         LIKE type_file.num5
DEFINE g_msg             LIKE ze_file.ze03        
DEFINE g_curr_idx        INTEGER 
DEFINE g_cnt             LIKE type_file.num10    #No.FUN-A50010
        
MAIN
    OPTIONS                                #改變一些系統預設值        
        INPUT NO WRAP,                     #輸入的方式: 不打轉        
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

#FUN-B30157 begin
   #LET g_sql = "azw07.azw_file.azw07,",
   #            "azw02_1.azw_file.azw01,",
   #            "azw02_2.azw_file.azw01,",
   #            "azw02_3.azw_file.azw01,",
   #            "azp02.azp_file.azp02,",
   #            "azp02_1.azp_file.azp02,",
   #            "azp02_2.azp_file.azp02,",
   #            "azp02_3.azp_file.azp02"  
   LET g_sql = "azw01.azw_file.azw01,",
               "azp02.azp_file.azp02,",
               "azw07.azw_file.azw07,"
#FUN-B30157 end

   LET l_table = cl_prt_temptable('aooi932',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

#FUN-B30157 begin
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
   #            " VALUES(?,?,?,?,?,?,?,?) "
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?) "
#FUN-B30157 end
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET i=0
    LET g_azw07_t = NULL

    OPEN WINDOW i932_w WITH FORM "aoo/42f/aooi932"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    LET g_wc = '1=1'             
    LET g_tree_reload = "Y"      #tree是否要重新整理Y/N  
#    LET g_tree_b = "N"           #tree是否進入單身 Y/N    
    LET g_tree_focus_idx = 0     #focus節點index       

    CALL i932_menu()
    CLOSE WINDOW i932_w                      #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

#QBE 查詢資料
FUNCTION i932_cs(p_idx)    #FUN-A50010 加參數p_idx   
   DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-A50010
   DEFINE l_wc   STRING                #雙按Tree的節點時的查詢條件#FUN-A50010  
   DEFINE l_count LIKE type_file.num5 
   DEFINE l_i     LIKE type_file.num5  ##FUN-A50010 by suncx1
     ###FUN-A50010 START ###
   LET l_wc = NULL
   IF p_idx > 0 THEN
      IF g_tree_b = "N" THEN
         LET l_wc = g_wc_o             #還原QBE的查詢條件      
         ELSE
         IF g_tree[p_idx].level = 1 THEN
            LET l_wc = g_wc_o
         ELSE
           #IF g_tree[p_idx].has_children THEN
              
             #  LET l_wc = "g_azw[].azw01='",g_tree[p_idx].treekey1 CLIPPED,"'"
                        
           # END IF
         END IF
      END IF
   END IF
   ###FUN-A50010 END ###                                                    
   CLEAR FORM 
   CALL g_azw.clear() 
                                                                                     
       INITIALIZE g_azw07 TO NULL   
   IF p_idx = 0 THEN   #FUN-A50010            
       CONSTRUCT g_wc ON azw01 FROM s_azw[1].azw01  #螢幕上取條件
                
       BEFORE CONSTRUCT                                                         
          CALL cl_qbe_init()                     
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(azw07)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_azw06"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                LET g_azw07 = g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO azw07
          END CASE

         CASE
           WHEN INFIELD(azw01)
              CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_azw06"
                LET g_qryparam.state ="c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO azw01
              NEXT FIELD azw01
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
       ###FUN-A50010 START ###
      ELSE
         IF cl_null(l_wc) THEN
            LET l_wc = "1=1"
         END IF 
         LET g_wc = l_wc #CLIPPED , "  AND azw07 is null  " 
      END IF
 
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('azwuser', 'azwgrup') 
      IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
         LET g_wc_o = g_wc CLIPPED
      END IF
      ###FUN-A50010 END ###   
       
 
       IF INT_FLAG THEN
          RETURN
       END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET g_sql="SELECT UNIQUE azw01 FROM azw_file ", #FUN-A50010 mark
              " WHERE ", g_wc CLIPPED
    #SELECT COUNT(azw07) INTO l_count FROM azw_file WHERE azw07 IS NOT NULL ##FUN-A50010  by suncx1
    #IF l_count >0 THEN 
    #   LET g_sql="SELECT DISTINCT azw01 FROM azw_file ",  #FUN-A50010 
    #          " WHERE ", g_wc CLIPPED,
    #          " AND azw07 is null ",
    #          " ORDER BY azw01"  
    #ELSE 
    #   LET g_sql="SELECT DISTINCT azw01 FROM azw_file ",  #FUN-A50010 
    #          " WHERE ", g_wc CLIPPED,
    #          " ORDER BY azw01"  
    #END IF 
    PREPARE i932_prepare FROM g_sql                                  
    DECLARE i932_bcs                                           
      SCROLL CURSOR WITH HOLD FOR i932_prepare 
   LET l_i = 1
   ##FUN-A50010 start by suncx1
   PREPARE i932_prepare1 FROM g_sql
   DECLARE i932_bcs1 CURSOR FOR i932_prepare1
   FOREACH i932_bcs1  INTO g_azw01[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_i = l_i + 1
   END FOREACH
   ##FUN-A50010 end
#   LET g_sql = "SELECT COUNT(UNIQUE azw07) FROM azw_file WHERE ",g_wc CLIPPED  #FUN-A50010 mark
    LET g_sql = "SELECT COUNT(*) FROM azw_file WHERE ",g_wc CLIPPED#,"  AND azw07 is null" #FUN-A50010
    PREPARE i932_precount FROM g_sql
    DECLARE i932_count CURSOR FOR i932_precount
 
END FUNCTION

FUNCTION i932_menu()
   DEFINE l_tree_ac          LIKE type_file.num5
   DEFINE l_s_azw_curr       INTEGER
   ###FUN-A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   ###FUN-A50010 END ###

   CALL cl_set_act_visible("query",TRUE)
   #CALL i932_show()
#  CALL cl_set_act_visible("delete_2,save_2", FALSE)
   CALL cl_set_act_visible("delete_2,save_2,cancel_2", FALSE)
   WHILE TRUE
      LET g_action_choice = " "
      #TREE
      #讓各個交談指令可以互動
      CALL cl_set_act_visible("accept", FALSE) 
      DIALOG ATTRIBUTES(UNBUFFERED)      
         #顯示子節點

         #TREE
         
         DISPLAY ARRAY g_tree TO tree.*
            ###FUN-A50010 ---START---
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正確
               #因為double click tree node後,focus tree的節點會改變
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF

               #以最上層的id當作單頭的g_curs_index
               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               CALL i932_jump() RETURNING g_curs_index  ##FUN-A50010  by suncx1
               CALL cl_navigator_setting( g_curs_index, g_row_count )
            ###FUN-A50010 ---END---
            
            BEFORE ROW #可用來設定"選取"時的動作.
                LET l_tree_arr_curr = ARR_CURR()            
                CALL DIALOG.setSelectionMode( "tree", 1 )     #設定樹能多選
#                CALL i932_dat_gup_show(g_tree[l_tree_ac].id)  #顯示該營運中心所屬資料群組資訊  mark by tommas 10/05/10
                CALL cl_set_act_visible("addchild",TRUE)   # FUN-A50010
                
            #double click tree node
            ON ACTION accept
               ###FUN-A50010 ---START---
               #CALL cl_set_act_visible("accept", FALSE)  #FUN-A50010
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL i932_tree_idxbypath()   #依tree path指定focus節點
                END IF
                LET g_tree_b = "Y"             #tree是否進入單身 Y/N
                CALL i932_fetch('T',l_tree_arr_curr)
                ###FUN-A50010 ---END---
                LET l_tree_ac = ARR_CURR()
                CALL i932_fill_b(l_tree_ac)
                
                DISPLAY g_row_count TO FORMONLY.cnt
              
            ON ACTION addchild
                CALL cl_set_act_visible("save_2,cancel_2", TRUE) 
                CALL cl_set_act_visible("accept", FALSE)  #FUN-A50010
                CALL i932_add_sub_b(DIALOG)  # 多選樹後，新增至單身
                
         END DISPLAY #TREE end

         DISPLAY ARRAY g_azw TO s_azw.* ATTRIBUTE(COUNT=g_rec_b)
           ###FUN-A50010 ---START---
           BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
           ###FUN-A50010 ---END---    
           BEFORE ROW 
              ###FUN-A50010 ---START---
              LET l_ac = ARR_CURR()
              #LET g_row_count = ARR_COUNT() 
              CALL cl_show_fld_cont()
              ###FUN-A50010 ---END---
              CALL cl_set_act_visible("delete_2",TRUE) 

          # ON ACTION accept            
           #   LET g_action_choice="detail"
              
           ON ACTION delete_2
              CALL cl_set_act_visible("delete_2",TRUE)
              LET l_s_azw_curr = ARR_CURR()
              LET g_action_choice="delete_2"
              EXIT DIALOG

          ###FUN-A50010 ---START---
           AFTER DISPLAY
             CONTINUE DIALOG   #因為外層是DIALOG   
          ###FUN-A50010 ---END---
         END DISPLAY

# mark by tommas 10/05/10
#         DISPLAY ARRAY g_azwe TO s_azwe.*
#            BEFORE ROW
#            ON ACTION adj_gup
#         END DISPLAY
# mark by tommas 10/05/10
            ###FUN-A50010 ---START---
            BEFORE DIALOG
            #判斷是否要focus到tree的正確row
            CALL i932_tree_idxbykey()  
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")                   #No.FUN-A30120 add by tommas   利用NEXT FIELD達到focus另一個table
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A30120 add by tommas   指定tree要focus的row
            END IF
                       
             #ON ACTION detail
             #  LET g_action_choice="detail"
             #  LET l_ac = 1
             #  EXIT DIALOG  

             ON ACTION output
                 LET g_action_choice="output"
                 EXIT DIALOG   
             ###FUN-A50010 ---END---  
              ON ACTION exit
                 LET g_action_choice="exit"
                 EXIT DIALOG

              ON ACTION query
                 LET g_action_choice="query"
                 EXIT DIALOG

              ON ACTION controlg
                 LET g_action_choice="controlg"
                 EXIT DIALOG

             #ON ACTION accept
             #   LET g_action_choice="detail"
             #   LET l_ac = ARR_CURR()
             #   EXIT DIALOG
                
               ON ACTION save_2
                  LET g_action_choice="save_2"
                  EXIT DIALOG
                   
               ON ACTION cancel_2
                   LET g_action_choice="cancel_2"
                   EXIT DIALOG
                  
              ON ACTION first
                 CALL i932_fetch('F',0)      #FUN-A50010 加參數p_idx
                 CALL i932_tree_idxbykey()   #FUN-A50010
                 CALL cl_navigator_setting(g_curs_index, g_row_count)   
                 IF g_rec_b != 0 THEN        #FUN-A50010
                    CALL fgl_set_arr_curr(1)
                 END IF                      #FUN-A50010
                 ACCEPT DIALOG               #FUN-A50010

              ON ACTION previous
                 CALL i932_fetch('P',0)      #FUN-A50010 加參數p_idx
                 CALL i932_tree_idxbykey()   #FUN-A50010
                 CALL cl_navigator_setting(g_curs_index, g_row_count)   
                 IF g_rec_b != 0 THEN        #FUN-A50010
                    CALL fgl_set_arr_curr(1)
                 END IF                      #FUN-A50010
                 ACCEPT DIALOG               #FUN-A50010

              ON ACTION jump
                 CALL i932_fetch('/',0)      #FUN-A50010 加參數p_idx
                 CALL i932_tree_idxbykey()   #FUN-A50010
                 CALL cl_navigator_setting(g_curs_index, g_row_count)   
                 IF g_rec_b != 0 THEN        #FUN-A50010
                    CALL fgl_set_arr_curr(1)
                 END IF                      #FUN-A50010
                 ACCEPT DIALOG               #FUN-A50010

              ON ACTION next
                 CALL i932_fetch('N',0)      #FUN-A50010 加參數p_idx
                 CALL i932_tree_idxbykey()   #FUN-A50010
                 CALL cl_navigator_setting(g_curs_index, g_row_count)  
                 IF g_rec_b != 0 THEN        #FUN-A50010
                    CALL fgl_set_arr_curr(1)
                 END IF                      #FUN-A50010
                 ACCEPT DIALOG               #FUN-A50010

              ON ACTION last
                 CALL i932_fetch('L',0)      #FUN-A50010 加參數p_idx
                 CALL i932_tree_idxbykey()   #FUN-A50010
                 CALL cl_navigator_setting(g_curs_index, g_row_count)   
                 IF g_rec_b != 0 THEN        #FUN-A50010
                    CALL fgl_set_arr_curr(1)
                 END IF                      #FUN-A50010
                 ACCEPT DIALOG               #FUN-A50010

              ON ACTION close                #視窗右上角的"x"
                 LET INT_FLAG=FALSE
                 LET g_action_choice="exit"
                 EXIT DIALOG

              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DIALOG

              ON ACTION about
                 CALL cl_about()           
       
              ON ACTION locale
                 CALL cl_dynamic_locale()
                 CALL cl_show_fld_cont()
             ###FUN-A50010 ---START---   
             #相關文件
             ON ACTION related_document
                 LET g_action_choice="related_document"
                 EXIT DIALOG

           #TQC-B10239 begin
             #ON ACTION exporttoexcel
             #   LET g_action_choice = 'exporttoexcel'
             #   EXIT DIALOG
           #TQC-B10239 end

             # ON ACTION controls
             #    CALL cl_set_head_visible("","AUTO")
             ###FUN-A50010 ---END---
       #BEFORE DIALOG                      
        #      CALL cl_navigator_setting( g_curs_index, g_row_count )

      END DIALOG
    #   CALL cl_set_act_visible("save_2,cancel_2", TRUE)
    CALL cl_set_act_visible("accept,cancel", TRUE)



    CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i932_q(0)   #加參數p_idx
			  # CALL cl_set_act_visible("save_2,cancel_2,delete_2", FALSE)
            END IF 
            
         WHEN "delete_2"
            #CALL cl_set_act_visible("cancel_2,save_2",TRUE)
            IF cl_chk_act_auth() THEN
               CALL i932_r(l_s_azw_curr)
            END IF
 
         WHEN "cancel_2"
            CALL i932_fill_b(g_curr_idx)
            CALL g_azw_del.clear()
            CALL cl_set_act_visible("save_2,cancel_2",FALSE)
            
         WHEN "save_2"
            CALL i932_save()
            CALL i932_show()
            CALL cl_set_act_visible("save_2,cancel_2",FALSE) 

                  
         #WHEN "detail"
         #   IF cl_chk_act_auth() THEN
               #CALL i932_b()
         #  ELSE
         #      LET g_action_choice = NULL
         #   END IF
            
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i932_out()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_azw07 IS NOT NULL THEN
                  LET g_doc.column1 = "azw07"
                  LET g_doc.value1 = g_azw07
                  CALL cl_doc()
               END IF
            END IF

       #TQC-B10239 begin
         #WHEN "exporttoexcel"   
         #   IF cl_chk_act_auth() THEN
         #     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azw),'','')
         #   END IF
       #TQC-B10239 end
#            #NO.FUN-A50010 --start--
#           WHEN "cancel"
#            # CALL i932_b_fill(g_wc_o)
#             CALL cl_set_act_visible("save,cancel",FALSE)
#          WHEN "save"
#             CALL i932_save()
#             CALL i932_show()
#             CALL i932_tree_fill(g_wc_o,NULL,0,NULL,NULL)
#             CALL cl_set_act_visible("save,cancel",FALSE)
#          #NO.FUN-A50010 --end--  
      END CASE
   END WHILE
   CLOSE i932_bcs  
END FUNCTION

FUNCTION i932_dat_gup_show(p_plant)
   DEFINE p_plant  LIKE azwe_file.azwe03
   DEFINE l_sql    STRING
   DEFINE l_i      LIKE type_file.num5

   INITIALIZE g_azwe TO NULL
   LET l_sql = "SELECT azwe01, azwe02 FROM azwe_file WHERE azwe03 = ? "

   PREPARE i932_dat_p1 FROM l_sql
   DECLARE i932_dat_c1 CURSOR FOR i932_dat_p1  
   LET l_i = 1
   FOREACH i932_dat_c1 USING p_plant INTO g_azwe[l_i].azwe01, g_azwe[l_i].azwe02
      SELECT azwc02 INTO g_azwe[l_i].azwc02 FROM azwc_file WHERE azwc01 = g_azwe[l_i].azwe02
      LET l_i = l_i + 1
   END FOREACH
   CALL g_azwe.deleteElement(l_i)
END FUNCTION

#double click樹節點後，將相關父子節點填僿
FUNCTION i932_fill_b(p_idx)
       DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index
       IF p_idx > 1 THEN
           LET g_azw07 = g_tree[p_idx].treekey1
           CALL i932_fill_head(g_tree[p_idx].treekey1)
       ELSE
           CALL i932_fill_head(g_azw07)
       END IF
       CALL i932_b_fill(g_wc)
END FUNCTION

#將操作結果儲存。先將g_azw_del中的azw07 = NULL，再將g_azw中的azw07 = g_azw07
FUNCTION i932_save()
    DEFINE l_idx    INTEGER
   
    BEGIN WORK
        FOR l_idx = 1 TO g_azw_del.getlength()        #將要刪陎的上層設為NULL
            IF NOT cl_null(g_azw_del[l_idx].azw01) THEN  #要新增的azw01不為空值，則UPDATE

                #CALL s_del_all_user_plant(g_azw_del[l_idx].azw01)  #移除節點   #FUN-A50080  mark
                UPDATE azw_file SET azw_file.azw07 = NULL
                    WHERE azw_file.azw01 = g_azw_del[l_idx].azw01
                IF SQLCA.sqlcode THEN EXIT FOR END IF
            END IF
        END FOR
        CALL g_azw_del.clear()                       #清空要刪的暫嫿        
        FOR l_idx = 1 TO g_azw.getLength()           #修改子節點的上層
           IF NOT cl_null(g_azw[l_idx].azw01) THEN   
               #CALL s_move_all_user_plant(g_azw[l_idx].azw01, g_azw07) #所有的節點移動都視為搬移  #FUN-A50080  mark

           END IF
           UPDATE azw_file SET azw_file.azw07 = g_azw07
                 WHERE azw_file.azw01 = g_azw[l_idx].azw01
            IF SQLCA.sqlcode THEN EXIT FOR END IF
        END FOR
    IF SQLCA.sqlcode THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
END FUNCTION

#No:TQC-9A0163
##################################################
# Descriptions...: 多選樹後，新增至單身
#                  檢查步驟ﺿ1.檢查不為法人節點#                          
#                          2.檢查azw05 != azw06 
#                          3.檢查不為節點本踿  
#                          4.檢查不重覆加入節? 
#                          5.不形成環狀節點 
#                          凿加入成為子節點# Input Parameter: p_dialog  ui.Dialog
# Return code....: void
##################################################
FUNCTION i932_add_sub_b(p_dialog)
    DEFINE r INTEGER
    DEFINE p_dialog ui.Dialog
    DEFINE l_azw01 LIKE azw_file.azw01
    DEFINE l_azw02 LIKE azw_file.azw02
    DEFINE l_chk BOOLEAN
    DEFINE l_chk1 BOOLEAN
    DEFINE l_errmsg STRING
    DEFINE loop INTEGER
    LET l_errmsg = ""
        FOR r = 1 TO p_dialog.getArrayLength("tree")
        LET l_chk = TRUE
        LET l_chk1 = TRUE
           IF p_dialog.isRowSelected("tree",r) THEN
                LET l_azw01 = g_tree[r].treekey1              
                #2.檢查azw05 != azw06 
                IF l_chk1 THEN
                    SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw05 = azw06 AND azw01 = l_azw01
                    IF NOT cl_null(l_azw02) THEN  #若存在，表示azw05 = azw06，不給調擿                       
                    LET l_chk1 = FALSE
                       CALL cl_err('','aoo-932',0)
                    END IF
                END IF
                
                #3.不能加入自己本身成為子節點                
                IF l_chk1 THEN
                    IF g_tree[r].id == g_azw07 THEN       
                       LET l_chk1 = FALSE
                    END IF
                END IF
                
                #4.檢查重覆加入的子節點                
                IF l_chk1 THEN                                     #上一規則檢查OK，進行下一個檢板                   
                 LET loop = 1
                    FOR loop =1 TO g_azw.getLength()        #4.檢查重覆加入的子節點                       
                     IF l_azw01 == g_azw[loop].azw01 THEN 
                           LET l_chk1 = FALSE
                           CALL cl_err("","agl-116",0)
                        END IF
                    END FOR
                END IF
                
                #5.檢查是否成環狀(自己的上層節點加到自己的下層)   
                IF l_chk1 THEN                                     #乤¸規則檢查OK，進行下一個檢板                 
                  CALL chk_ring(l_azw01,g_azw07, l_errmsg) RETURNING l_chk, l_errmsg   #5.檢查是否成環狀(自己的上層節點加到自己的下層)   
                   IF NOT l_chk THEN CALL cl_err("","axd-079",0) END IF
                END IF                         

                # 沒重覆也沒加自己本身也沒形成環狀，則加入子節點               
                 IF l_chk AND l_chk1 THEN       
                    CALL g_azw.appendElement()
                    LET g_azw[g_azw.getLength()].azw01 = l_azw01
                    LET g_azw[g_azw.getLength()].azp02 = g_tree[r].azp02_t
                    LET g_azw[g_azw.getLength()].azw02 = g_tree[r].azw02
                END IF

           END IF
        END FOR

END FUNCTION

#No:TQC-9A0163
##################################################
# Descriptions...: 新增子節點時，檢查該子節點是否為母節點的上層，避免形成環狀
# Input Parameter: p_end  終止節點#                : p_curr 起始節點#                : p_path 搜尋路徑
# Return code....: p_chk  TRUE:樹狀  FALSE:環狀
#                  p_path 搜尋路徑
##################################################
FUNCTION chk_ring(p_end,p_curr, p_path)
    DEFINE p_end        LIKE azw_file.azw01,
           p_curr       LIKE azw_file.azw07,
           p_path       STRING
    DEFINE p_chk        BOOLEAN,
           p_azw07      LIKE azw_file.azw07
           
    LET p_curr = p_curr CLIPPED
    SELECT azw07 INTO p_azw07 FROM azw_file WHERE azw01 = p_curr  
    LET p_path = p_path, " / ", p_azw07      #搜尋路徑
    IF p_azw07 = p_end THEN                  #環狀，檢查失敗，結束
        LET p_chk = FALSE
        RETURN p_chk, p_path
    END IF
    IF cl_null(p_azw07) THEN                 #搜尋到根，檢查成功，結束
        LET p_chk = TRUE
        RETURN p_chk, ""
    END IF
    CALL chk_ring(p_end, p_azw07,p_path) RETURNING p_chk, p_path  #未搜尋到根或環狀，繼縿    
    RETURN p_chk, p_path
END FUNCTION

#FUNCTION i932_a()
# Prog. Version..: '5.30.06-13.03.12(0) THEN RETURN END IF                #判斷目前系統是否可用
#    MESSAGE ""
#    CLEAR FORM
#    CALL g_azw.clear()
#    INITIALIZE g_azw07 LIKE azw_file.azw07         #DEFAULT 設定
#    CALL cl_opmsg('a')
#    WHILE TRUE
#        CALL i932_i("a")                           #輸入單頭
#        IF INT_FLAG THEN                           #使用者不玩了
#            LET g_azw07=NULL
#            LET INT_FLAG = 0
#            CALL cl_err('',9001,0)
#            EXIT WHILE
#        END IF
#        IF g_azw07 IS NULL THEN # KEY 不可空白
#            CONTINUE WHILE
#        END IF
#        CALL g_azw.clear()
#        LET g_rec_b = 0
#        #CALL i932_g()     #FUN-840198
#        #CALL i932_b()                              #輸入單身
#        #SELECT ROWID INTO g_azw_rowid FROM azw_file  #FUN-A50010 mark
#        SELECT azw07 INTO g_azw07 FROM azw_file       #FUN-A50010
#            WHERE azw07 = g_azw07
#        LET g_azw07_t = g_azw07                    #保留舊值        
#        EXIT WHILE
#    END WHILE
#END FUNCTION
#
#FUNCTION i932_i(p_cmd)
#DEFINE
#    l_n             LIKE type_file.num5,          
#    p_cmd           LIKE type_file.chr1           #a:輸入 u:更改     
#
#    DISPLAY g_azw07 TO azw07
#    CALL cl_set_head_visible("","YES")            
#
#    INPUT  g_azw07 FROM azw07 
#
#        AFTER FIELD azw07
#            IF NOT cl_null(g_azw07) THEN
#               IF g_azw07 != g_azw07_t OR cl_null(g_azw07_t) THEN
#                  SELECT azp02 INTO m_azp02 FROM azp_file
#                   WHERE azp01 = g_azw07    # AND azpacti='Y'
#                  IF STATUS=100 THEN        #資料不存圈                     
#                  CALL cl_err3("sel","azp_file",g_azw07,"",100,"","",1)  
#                     LET g_azw07 = g_azw07_t
#                     DISPLAY g_azw07 TO azw07
#                     NEXT FIELD azw07
#                  END IF
#               END IF
#               DISPLAY m_azp02 TO FORMONLY.azp02n
#               SELECT COUNT(*) INTO l_n FROM azw_file
#                  WHERE azw07=g_azw07
#               IF l_n>0 THEN
#                  CALL cl_err(g_azw07,-239,0)
#                  NEXT FIELD azw07
#               END IF
#               LET g_azw07_o = g_azw07
#            END IF
#
#        ON ACTION CONTROLF                  #欄位說明
#           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
#           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
#
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#            CALL cl_cmdask()
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(azw07)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_azw06"
#                 LET g_qryparam.default1 = g_azw07
#                 CALL cl_create_qry() RETURNING g_azw07
#                 DISPLAY g_azw07 TO azw07
#                 NEXT FIELD azw07
#              OTHERWISE EXIT CASE
#           END CASE
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#
#      ON ACTION about         
#          CALL cl_about()      
#
#      ON ACTION help         
#          CALL cl_show_help()  
#
#
#    END INPUT
#END FUNCTION
#

#Query 查詢
FUNCTION i932_q(p_idx)      #FUN-A50010 加參數p_idx
    DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index  #FUN-A50010
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_azw.clear()
    CALL i932_cs(p_idx)                   #取得查詢條件   #FUN-A50010傳入參數p_idx                   
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        CALL g_tree.clear()
        RETURN
    END IF
    OPEN i932_bcs                            #從DB產生合乎條件TEMP(0-30祿
    IF SQLCA.sqlcode THEN                    #有問響        
    CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_azw07 TO NULL
    ELSE
        OPEN i932_count
        FETCH i932_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        #CALL i932_fetch('F')  #FUN-A50010 mark
        
        ###FUN-A50010 START ###
        IF p_idx = 0 THEN
           CALL i932_fetch('F',0)        #讀出TEMP第一筆並顯示
           LET g_tree_focus_idx= 0 
           CALL i932_tree_fill_1()   #Tree填充
        ELSE
           #Tree的最上層是QBE結果，才可以指定jump
           IF g_tree[p_idx].level = 1 THEN
              CALL i932_fetch('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
           ELSE
              CALL i932_fetch('F',0)
           END IF
        END IF
        ###FUN-A50010 END ###
    END IF
   
END FUNCTION


FUNCTION i932_fill_head(p_azw01)
    DEFINE p_azw01  LIKE azw_file.azw01,
           l_azp02  LIKE azp_file.azp02
    LET g_azw07 = p_azw01

    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_azw07
    DISPLAY g_azw07 TO azw07
    DISPLAY l_azp02 TO FORMONLY.azp02n
END FUNCTION

#將資料顯示在畫面䶿
FUNCTION i932_show()
   DISPLAY g_azw07 TO azw07
   CALL i932_b_fill(g_wc)
   CALL cl_set_act_visible("save_2,delete_2",FALSE)
   CALL g_azw_del.clear()
   CALL i932_azw02(g_azw07,'d')                                                                             
#   CALL cl_show_fld_cont()
   CALL i932_tree_fill_1()
END FUNCTION

#處理資料的讀卿                                                                
FUNCTION i932_fetch(p_flag,p_idx)            #FUN-A50010 加參數p_idx                                                   
    DEFINE p_flag    LIKE type_file.chr1     #處理方式 
    DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  #FUN-A50010
    DEFINE l_i       LIKE type_file.num5     #FUN-A50010
    DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 #FUN-A50010

   CASE p_flag                                                                  
       WHEN 'N' FETCH NEXT     i932_bcs INTO g_azw07                  
       WHEN 'P' FETCH PREVIOUS i932_bcs INTO g_azw07            
       WHEN 'F' FETCH FIRST    i932_bcs INTO g_azw07      
       WHEN 'L' FETCH LAST     i932_bcs INTO g_azw07
       WHEN '/'  
         IF (NOT mi_no_ask) THEN                                                              
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                      
            LET INT_FLAG = 0                            
            PROMPT g_msg CLIPPED,': ' FOR g_abso  
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
            FETCH ABSOLUTE g_abso i932_bcs 
                  INTO g_azw07
            LET mi_no_ask = FALSE
            
           ##FUN-A50010 START ###
           #Tree雙點指定筆        
           WHEN 'T'
           #讀出TEMP中，雙點Tree的指定節點並顯示
           LET l_jump  = 0
           #IF g_tree[p_idx].level = 1 THEN   #最高層              
           #   LET l_jump  = g_tree[p_idx].treekey1  #ex:當id=5，表示要跳到窿筆           
           #   END IF
           CALL i932_jump() RETURNING l_jump   ##FUN-A50010  by suncx1
           IF l_jump  <= 0 THEN
              LET l_jump  = 1
           END IF
           LET g_abso = l_jump
           FETCH ABSOLUTE g_abso i932_bcs INTO g_azw07
        ##FUN-A50010 END ###
   END CASE
 
   IF SQLCA.sqlcode THEN                     #有麻煩      
   CALL cl_err(g_azw07,SQLCA.sqlcode,0)
      INITIALIZE g_azw07 TO NULL  
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_abso
         WHEN 'T' LET g_curs_index = g_abso
      END CASE
      DISPLAY g_curs_index TO FORMONLY.cn2
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   CALL i932_show()
END FUNCTION


FUNCTION i932_azw02(l_azw01,p_cmd)   
   DEFINE
      p_cmd           LIKE type_file.chr1,
      l_azp02         LIKE azt_file.azt01,
      l_azw01         LIKE azw_file.azw01
       
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02
                FROM azp_file WHERE azp01 = l_azw01
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aoo-416'
                                 LET l_azp02 = NULL
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02  TO azp02n
   END IF
 
END FUNCTION

FUNCTION i932_r(p_idx)
    DEFINE p_idx INTEGER
    ###FUN-A50010 START ###
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_prev   STRING  #前一個節點    
    DEFINE l_next   STRING  #後一個節點    
    ###FUN-A50010 END ###
    
    IF p_idx == 0 THEN 
           CALL cl_set_act_visible("delete_2", FALSE)
    ELSE
        CALL g_azw_del.appendelement()
    LET g_azw_del[g_azw_del.getLength()].azw01 = g_azw[p_idx].azw01     #將要刪除的先暫存
    #CALL g_azw.deleteelement(p_idx)
    
    IF s_shut(0) THEN RETURN END IF
    IF g_azw07 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    ###FUN-A50010 START ###
    BEGIN WORK
    IF (cl_confirm("aoo-888")) THEN
        INITIALIZE g_doc.* TO NULL      
        LET g_doc.column1 = "azw01"      
        LET g_doc.value1 = g_azw[p_idx].azw01     
        CALL cl_del_doc()               
        
               
        #在Tree節點刪除之前先找出刪除後要focus的節點path
        #CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
        #刪除子節點後，focus在它的父節點        
        #IF l_i > 1 THEN
        #   CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
        #刪除的是最上層節點，focus在它的後一個節點或前一個節點        
        #ELSE
        #   CALL i932_tree_idxbypath()               #依tree path指定focus節點           
        #   LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
        #   LET l_i = l_i + 1
        #   LET l_next = l_i
           
        #  LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
        #   LET l_i = l_i - 1
        #   LET l_prev = l_i
           
        #   FOR l_i = g_tree.getlength() TO 1 STEP -1
        #      IF g_tree[l_i].id = l_next THEN       #後一個節點                    
        #     LET g_tree_focus_path = g_tree[l_i].path
        #            EXIT FOR
        #      END IF
        #      IF g_tree[l_i].id = l_prev THEN       #前一個節點                    
        #   LET g_tree_focus_path = g_tree[l_i].path
        #            EXIT FOR
        #      END IF
        #   END FOR
        #END IF
        
        
        #DELETE FROM azw_file WHERE azw07=g_azw07
        UPDATE azw_file SET azw07 = NULL WHERE azw01 = g_azw[p_idx].azw01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN

           CALL cl_err3("del","azw_file",g_azw[p_idx].azw01,"",SQLCA.sqlcode,"","",1) 
        ELSE
           CLEAR FORM
           CALL g_azw.clear()
           CALL g_azw.clear()
                     
           CALL i932_tree_update()       
        END IF
      END IF
    END IF
    COMMIT WORK
    ###FUN-A50010 END ###
END FUNCTION

###FUN-A50010 mark
#FUNCTION i932_g()
#   DEFINE l_azp01      LIKE azw_file.azw01
#   DEFINE  l_wc,l_sql   STRING      
#
#   OPEN WINDOW i932_g_w AT 8,20
#     WITH FORM "aoo/42f/aooi932g"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#   CALL cl_ui_locale("aooi932g")
#
#   CONSTRUCT BY NAME l_wc ON azw01
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#
#      ON ACTION CONTROLP
#         CASE
#           WHEN INFIELD(azp01)
#              CALL cl_init_qry_var()
#                LET g_qryparam.form  ="q_azw06"
#                LET g_qryparam.state ="c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
#              DISPLAY g_qryparam.multiret TO azw07
#              NEXT FIELD azp01
#           OTHERWISE
#              EXIT CASE
#         END CASE
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
#
#       ON ACTION about         
#          CALL cl_about()     
#
#       ON ACTION help          
#          CALL cl_show_help() 
#
#       ON ACTION controlg      
#          CALL cl_cmdask()     
#
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
#
#       ON ACTION qbe_save
#          CALL cl_qbe_save()
#   END CONSTRUCT
#
#   IF INT_FLAG THEN
#      CLOSE WINDOW i932_g_w
#      LET INT_FLAG = 0
#      RETURN
#   END IF
#
#   IF NOT cl_sure(16,16) THEN
#      CLOSE WINDOW i932_g_w
#      RETURN
#   END IF
#
#   LET l_sql="SELECT azp01 FROM azp_file",
#             " WHERE  azpacti='Y' ",
#             "   AND ",l_wc CLIPPED
#   PREPARE i932_g_p FROM l_sql
#   DECLARE i932_g_c CURSOR FOR i932_g_p
#
#
#   FOREACH i932_g_c INTO l_azp01
#      MESSAGE l_azp01
#      IF g_azw07 != l_azp01 THEN
#         INSERT INTO azw_file (azw07,azw01) VALUES(g_azw07,l_azp01)
#      ELSE
#         CALL cl_err(l_azp01,'agl-226',0)
#      END IF
#   END FOREACH
#
#   CLOSE WINDOW i932_g_w
#   CALL i932_b_fill(l_wc)
#   DISPLAY ARRAY g_azw TO s_azw.* ATTRIBUTE(COUNT=g_rec_b)
#     BEFORE DISPLAY
#       EXIT DISPLAY
#   END DISPLAY
#
#END FUNCTION

###FUN-A50010 START ###
#FUNCTION i932_b()
#   DEFINE
#    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT       
#    l_n             LIKE type_file.num5,      #檢查重複用     
#    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否     
#    p_cmd           LIKE type_file.chr1,      #處理狀態       
#    l_allow_insert  LIKE type_file.num5,      #可新增否       
#    l_allow_delete  LIKE type_file.num5       #可刪除否      
#    DEFINE l_loop   LIKE type_file.chr1       #是否為無窮迴圈Y/N   
#    DEFINE l_i      LIKE type_file.num5                        
#
#    LET g_action_choice = ""
#    IF s_shut(0) THEN RETURN END IF
#    CALL cl_opmsg('b')
#
#    LET g_forupd_sql =
#        "SELECT azw01 FROM azw_file WHERE azw01= ?  FOR UPDATE"
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE i932_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#    LET l_ac_t = 0
#    LET l_allow_insert = cl_detail_input_auth("insert")
#    LET l_allow_delete = cl_detail_input_auth("delete")
#
#    INPUT ARRAY g_azw WITHOUT DEFAULTS FROM s_azw.*
#        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
#
#        BEFORE INPUT
#            IF g_rec_b!=0 THEN
#               CALL fgl_set_arr_curr(l_ac)
#            END IF
#
#        BEFORE ROW
#            LET p_cmd=''
#            LET l_ac = ARR_CURR()
#            LET l_lock_sw = 'N'            #DEFAULT
#            LET l_n  = ARR_COUNT()
#
#            IF g_rec_b >= l_ac THEN
#               BEGIN WORK
#               LET p_cmd='u'
#               LET g_azw_t.* = g_azw[l_ac].*  #BACKUP
#               OPEN i932_bcl USING g_azw_t.azw01
#               IF STATUS THEN
#                  CALL cl_err("OPEN i932_bcl:", STATUS, 1)
#                  LET l_lock_sw = "Y"
#               ELSE
#                  FETCH i932_bcl INTO g_azw[l_ac].*
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_azw_t.azw01,SQLCA.sqlcode,1)
#                     LET l_lock_sw = "Y"
#                  END IF
#               END IF
#               CALL cl_show_fld_cont()     
#            END IF
#
#            IF l_ac <= l_n THEN
#               SELECT azp02 INTO g_azw[l_ac].azp02 FROM azp_file
#                WHERE azp01 = g_azw[l_ac].azw01
#               IF SQLCA.sqlcode THEN LET g_azw[l_ac].azp02 = ' ' 
#               END IF
#            END IF
#
#        BEFORE INSERT
#            LET l_n = ARR_COUNT()
#            LET p_cmd='a'
#            INITIALIZE g_azw[l_ac].* TO NULL      
#            LET g_azw_t.* = g_azw[l_ac].*         
#            CALL cl_show_fld_cont()    
#            NEXT FIELD azw01
#
#        AFTER INSERT
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               CANCEL INSERT
#            END IF
#
#          
#            CALL i932_tree_loop(g_azw[l_ac].azw01,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
#            IF l_loop = "Y" THEN
#               CALL cl_err(g_azw[l_ac].azw01,"aoo1000",1)
#               CANCEL INSERT
#            ELSE
#          
#               INSERT INTO azw_file(azw07,azw01,azwuser,azwgrup,azwmodu,azwdate,azworiu,azworig)
#                             VALUES(g_azw07,g_azw[l_ac].azw01,g_user,
#                                    g_grup,g_user,g_today, g_user, g_grup)     
#               IF SQLCA.sqlcode THEN
#                
#                   CALL cl_err3("ins","azw_file",g_azw[l_ac].azw01,"",SQLCA.sqlcode,"","",1)  
#                   CANCEL INSERT
#               ELSE
#                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   
#                   LET g_rec_b = g_rec_b + 1
#                   DISPLAY g_rec_b TO FORMONLY.cn2
#                   MESSAGE 'INSERT O.K'
#               END IF
#            END IF   
#
#
#        AFTER FIELD azw01
#            IF NOT cl_null(g_azw[l_ac].azw01) THEN
#               IF g_azw[l_ac].azw01 = g_azw07 THEN
#                  CALL cl_err('','a00-226',0)    
#                  NEXT FIELD azw01
#               END IF
#
#               IF g_azw[l_ac].azw01 != g_azw_t.azw01 OR
#                 (g_azw[l_ac].azw01 IS NOT NULL AND g_azw_t.azw01 IS NULL) THEN
#                   SELECT count(*) INTO l_n FROM azw_file
#
#                    WHERE azw01 = g_azw[l_ac].azw01
#
#                   IF l_n > 0 THEN
#                      CALL cl_err(g_azw[l_ac].azw01,-239,0)
#                      LET g_azw[l_ac].azw01 = g_azw_t.azw01
#                      LET g_azw[l_ac].azp02 = g_azw_t.azp02
#                      NEXT FIELD azw01
#                   ELSE
#                      SELECT azp02 INTO g_azw[l_ac].azp02 FROM azp_file
#                       WHERE azp01 = g_azw[l_ac].azw01 AND azpacti='Y'
#                      IF STATUS=100 THEN   #資料不存在
#
#                         CALL cl_err3("sel","azp_file", g_azw[l_ac].azw01,"",SQLCA.sqlcode,"","",1)  
#                         LET g_azw[l_ac].azw01 = g_azw_t.azw01
#                         NEXT FIELD azw01
#                      END IF
#                   END IF
#               END IF
#            END IF
#
#        BEFORE DELETE                            #是否取消單身
#            IF g_azw_t.azw01 IS NOT NULL THEN
#                IF NOT cl_delb(0,0) THEN
#                     CANCEL DELETE
#                END IF
#
#                IF l_lock_sw = "Y" THEN
#                   CALL cl_err("", -263, 1)
#                   CANCEL DELETE
#                END IF
#
#                DELETE FROM azw_file
#                 WHERE  azw01 = g_azw[l_ac].azw01
#                IF SQLCA.sqlcode THEN
#                   CALL cl_err3("del","azw_file",g_azw_t.azw01,"",SQLCA.sqlcode,"","",1)  
#                   ROLLBACK WORK
#                   CANCEL DELETE
#                ELSE
#                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N  
#                END IF
#                LET g_rec_b = g_rec_b-1
#                DISPLAY g_rec_b TO FORMONLY.cn2
#            END IF
#
#            COMMIT WORK
#
#        ON ROW CHANGE
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               LET g_azw[l_ac].* = g_azw_t.*
#               CLOSE i932_bcl
#               ROLLBACK WORK
#               EXIT INPUT
#            END IF
#            IF l_lock_sw = 'Y' THEN
#               CALL cl_err(g_azw[l_ac].azw01,-263,1)
#               LET g_azw[l_ac].* = g_azw_t.*
#            ELSE
#               
#               CALL i932_tree_loop(g_azw[l_ac].azw01,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
#               IF l_loop = "Y" THEN
#                  CALL cl_err(g_azw[l_ac].azw01,"aoo1000",1)
#                  LET g_azw[l_ac].* = g_azw_t.*
#               ELSE
#               
#                  UPDATE azw_file SET azw01 = g_azw[l_ac].azw01,
#                                      azwmodu = g_user,
#                                      azwdate = g_today
#                     WHERE azw01 = g_azw[l_ac].azw01
#                  IF SQLCA.sqlcode THEN
#                   
#                     CALL cl_err3("upd","azw_file",g_azw_t.azw01,"",SQLCA.sqlcode,"","",1)  
#                     LET g_azw[l_ac].* = g_azw_t.*
#                  ELSE
#                     LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   
#                     MESSAGE 'UPDATE O.K'
#                     COMMIT WORK
#                  END IF
#               END IF #FUN-9A0002
#            END IF
#
#        AFTER ROW
#            LET l_ac = ARR_CURR()
#            LET l_ac_t = l_ac
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               LET g_azw[l_ac].* = g_azw_t.*
#               CLOSE i932_bcl
#               ROLLBACK WORK
#               EXIT INPUT
#            END IF
#            
#            LET g_azw_t.* = g_azw[l_ac].*
#            CLOSE i932_bcl
#            COMMIT WORK
#
#
#        ON ACTION CONTROLO                        #沿用所有欄位
#           IF INFIELD(azw01) AND l_ac > 1 THEN
#              LET g_azw[l_ac].* = g_azw[l_ac-1].*
#              NEXT FIELD azw01
#           END IF
#
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(azw01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_azp"
#                   LET g_qryparam.default1 = g_azw[l_ac].azw01
#                   CALL cl_create_qry() RETURNING g_azw[l_ac].azw01
#                    DISPLAY BY NAME g_azw[l_ac].azw01    
#                   NEXT FIELD azw01
#              OTHERWISE EXIT CASE
#           END CASE
#
#        ON ACTION CONTROLF
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#
#      ON ACTION about        
#         CALL cl_about()      
#
#      ON ACTION help         
#         CALL cl_show_help()  
#
#      ON ACTION controls
#         CALL cl_set_head_visible("","AUTO")
#
#
#    END INPUT
#
#    CLOSE i932_bcl
#    COMMIT WORK
#
#    
#    IF g_tree_b = "Y" AND g_tree_reload = "Y" THEN 
#       CALL i932_tree_update() #Tree 資料有異動 
#       LET g_tree_reload = "N"
#    END IF
# 
#END FUNCTION

#FUNCTION i932_b_askkey()
#DEFINE
#    l_wc     LIKE type_file.chr1000    
#
#    CLEAR FORM
#    CALL g_azw.clear()
#    CALL g_azw.clear()
#
#      #螢幕上取條件
#       CONSTRUCT l_wc ON azw01 FROM s_azw[1].azw01
#             
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#            
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
#
#      ON ACTION about         
#         CALL cl_about()     
#
#      ON ACTION help         
#         CALL cl_show_help()  
#
#      ON ACTION controlg      
#         CALL cl_cmdask()     
#
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#        
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#		
#    END CONSTRUCT
#    IF INT_FLAG THEN RETURN END IF
#    CALL i932_b_fill(l_wc)
#END FUNCTION
###FUN-A50010 END ###

###FUN-A50010  mark
#FUNCTION i932_b_fill(p_wc)              #No.FUN-A50010加入p_wc
#DEFINE  p_wc      LIKE type_file.chr1000   #No.FUN-A50010
#DEFINE  l_azw     RECORD
#        azw01     LIKE azw_file.azw01
#                  END RECORD
#
#    LET g_sql = "SELECT azw01 FROM azw_file ",
#                " WHERE azw07 = '",g_azw07,"' ",
#                " ORDER BY azw01"
#    PREPARE i932_prepare2 FROM g_sql      #預備一䶿   
#     DECLARE azw_cs CURSOR FOR i932_prepare2

#    CALL g_azw.clear()

#    FOREACH azw_cs INTO l_azw.*   #單身 ARRAY 填充
#      IF SQLCA.sqlcode THEN
#          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#      END IF
      
#      CALL g_azw.appendElement()
#      LET g_azw[g_azw.getLength()].azw01 = l_azw.azw01
      
#      SELECT azp02 INTO g_azw[g_azw.getLength()].azp02 FROM azp_file
#          WHERE azp01=g_azw[g_azw.getLength()].azw01

#      IF SQLCA.sqlcode THEN LET g_azw[g_azw.getLength()].azp02='' END IF
#      IF g_azw.getLength() > g_max_rec THEN
#         CALL cl_err( '', 9035, 0 )
#      END IF
#    END FOREACH

#END FUNCTION

###FUN-A50010  ---START---
FUNCTION i932_b_fill(p_wc)             
   DEFINE p_wc      LIKE type_file.chr1000   

    LET g_sql = "SELECT azw01 FROM azw_file ",
                " WHERE azw07 = '",g_azw07,"' ",
                " ORDER BY azw01"
   PREPARE i932_prepare2 FROM g_sql      #預備一下
   DECLARE azw_cs CURSOR FOR i932_prepare2

   CALL g_azw.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH azw_cs INTO g_azw[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT azp02 INTO g_azw[g_cnt].azp02 FROM azp_file
       WHERE azp01=g_azw[g_cnt].azw01
      IF SQLCA.sqlcode THEN LET g_azw[g_cnt].azp02='' END IF
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
   END FOREACH
   CALL g_azw.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1

   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
###FUN-A50010  ---END---

#FUN-B30157 begin
##FUNCTION i932_out()
##    DEFINE l_azw        RECORD LIKE azw_file.*
##    DEFINE  i,j         LIKE type_file.num5
##    DEFINE  l_azp02     LIKE azp_file.azp02
##    DEFINE  l_azp02_1   LIKE azp_file.azp02
##    DEFINE  l_azp02_2   LIKE azp_file.azp02
##    DEFINE  l_azp02_3   LIKE azp_file.azp02
##    DEFINE  l_azw02_1   LIKE azw_file.azw01
##    DEFINE  l_azw02_2   LIKE azw_file.azw01
##    DEFINE  l_azw02_3   LIKE azw_file.azw01
##    DEFINE  l_azw01_t   LIKE azw_file.azw07
##
##    IF g_wc IS NULL THEN
##        CALL cl_err('','9057',0)
##        RETURN
##    END IF
##    CALL cl_wait()
##
##    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
##    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aooi932'
##    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
##    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
##    LET g_sql="SELECT * FROM azw_file ",          # 組合兿SQL 指令
##              " WHERE ",g_wc CLIPPED,
##              " ORDER BY azw07,azw01"
##    PREPARE i932_p1 FROM g_sql                # RUNTIME 編譯
##    DECLARE i932_co  CURSOR FOR i932_p1
##
##    #START REPORT i932_rep TO l_name
##    CALL cl_del_data(l_table)
##
##    LET i=1                         #循環計數,實現每行3筆排筆    
##    LET j=0                         #累加計數,判斷當前FOREACH到的筆數
##    INITIALIZE l_azw01_t TO NULL    #初始化分組key舊值
##    FOREACH i932_co INTO l_azw.*
##       IF SQLCA.sqlcode THEN
##           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
##           EXIT FOREACH
##       END IF
##
##       #OUTPUT TO REPORT i932_rep(l_azw.*)
##       IF (cl_null(l_azw01_t) OR l_azw.azw07<>l_azw01_t) THEN   #分組重新排列處理
##
##           IF j>0 AND i<>1 THEN                                 #若上一組最后一行未排滿3筆
##                                                                #則插入上一分組最后一行排筆              
##               EXECUTE insert_prep USING l_azw01_t,l_azw02_1,l_azw02_2,
##                                         l_azw02_3,l_azp02,l_azp02_1,l_azp02_2,
##                                         l_azp02_3
##               INITIALIZE l_azw02_1,l_azw02_2,l_azw02_3,        #每次插入后清空舊值
##                          l_azp02_1,l_azp02_2,l_azp02_3 TO NULL #以防當前筆值為空時使用舊值           
##                          END IF
##           LET l_azw01_t = l_azw.azw07
##           LET i=1                                              #切換分組旿
##           LET j=0                                              #重新計數
##       END IF
##       SELECT azp02 INTO l_azp02 FROM azp_file
##           WHERE azp01 = l_azw.azw07
##           AND azpacti='Y'
##       IF STATUS=100 THEN LET l_azp02='' END IF
##       LET j = j+1                                              #組內計數累加
##       IF i =1 THEN
##          LET l_azw02_1 = l_azw.azw01                           #存儲排列值
##          SELECT azp02 INTO l_azp02_1 FROM azp_file
##             WHERE azp01=l_azw.azw01
##             AND azpacti='Y'
##          LET i = i+1                                           #組內循環計數
##       ELSE
##          IF i=2 THEN
##             LET l_azw02_2 = l_azw.azw01                        #存儲排列值
##             SELECT azp02 INTO l_azp02_2 FROM azp_file
##                WHERE azp01=l_azw.azw01
##                AND azpacti='Y'
##             LET i = i+1
##          ELSE
##             IF i=3 THEN                                        #排滿3筆插入當前排列蟿                
##             LET l_azw02_3 = l_azw.azw01                     #存儲排列值
##                LET i = 1
##                SELECT azp02 INTO l_azp02_3 FROM azp_file
##                   WHERE azp01=l_azw.azw01
##                   AND azpacti='Y'
##                IF STATUS=100 THEN LET l_azp02_3=' ' END IF
##                EXECUTE insert_prep USING l_azw.azw07,l_azw02_1,l_azw02_2,
##                                          l_azw02_3,l_azp02,l_azp02_1,l_azp02_2,
##                                          l_azp02_3
##                INITIALIZE l_azw02_1,l_azw02_2,l_azw02_3,        #每次插入后清空舊值
##                           l_azp02_1,l_azp02_2,l_azp02_3 TO NULL #以防當前筆值為空時使用舊值             
##                           END IF
##          END IF
##       END IF
##       #No:FUN-760085---End
##    END FOREACH
##    IF i <> 1 THEN                                               #若查詢的最后一次排列未排滿3筆
##                                                                 #則插入最后一行排列值       
##       EXECUTE insert_prep USING l_azw.azw07,l_azw02_1,l_azw02_2,
##                                 l_azw02_3,l_azp02,l_azp02_1,l_azp02_2,
##                                 l_azp02_3
##       INITIALIZE l_azw02_1,l_azw02_2,l_azw02_3,
##                  l_azp02_1,l_azp02_2,l_azp02_3 TO NULL
##    END IF
##    #FINISH REPORT i932_rep                
##
##    CLOSE i932_co
##    ERROR ""
##
##    #CALL cl_prt(l_name,' ','1',g_len)
##    IF g_zz05 = 'Y' THEN
##       CALL cl_wcchp(g_wc,'azw07,azw01')
##            RETURNING g_wc
##       LET g_str = g_wc
##    END IF
##    LET g_str = g_wc
##    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
##    CALL cl_prt_cs3('aooi932','aooi932',l_sql,g_str)
##
##END FUNCTION

FUNCTION i932_out()
    DEFINE l_azw  DYNAMIC ARRAY OF RECORD 
           azw01   LIKE azw_file.azw01,
           azp02   LIKE azp_file.azp02,
           azw07   LIKE azw_file.azw07
          END RECORD
    DEFINE l_i,l_n LIKE type_file.num5


    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF

    CALL cl_wait()

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    LET g_sql="SELECT azw01,azp02,azw07 FROM azw_file,azp_file ",          # 組合兿SQL 指令
              " WHERE azw01 = azp01 ",
              #"   AND (azw07 IS NULL OR azw07 IN (SELECT DISTINCT azw01 FROM azw_file WHERE ", g_wc CLIPPED, ") )",
              #"   AND (   azw01 IN (SELECT DISTINCT azw01 FROM azw_file WHERE ", g_wc CLIPPED, ")",
              #"        OR azw07 IN (SELECT DISTINCT azw01 FROM azw_file WHERE ", g_wc CLIPPED, ") )",
              "   AND azw01 IN (SELECT DISTINCT azw01 FROM azw_file WHERE ", g_wc CLIPPED, ")",
              "   AND (azw07 NOT IN (SELECT DISTINCT azw01 FROM azw_file WHERE ", g_wc CLIPPED, " AND azw07 IS NOT NULL )", 
              "       OR azw07 IS NULL)",
              " ORDER BY azw01"

    PREPARE i932_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i932_co  CURSOR FOR i932_p1

    CALL cl_del_data(l_table)

    LET l_n = 1
    FOREACH i932_co INTO l_azw[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       
       #EXECUTE insert_prep USING l_azw[l_n].azw01,l_azw[l_n].azp02,l_azw[l_n].azw07

       LET l_n = l_n + 1
    END FOREACH
    CALL l_azw.deleteElement(l_n)
    LET l_n = l_n - 1

    FOR l_i = 1 TO l_n
       IF cl_null(l_azw[l_i].azw07) THEN
         CALL i932_rec(l_azw[l_i].azw01,'0')
       ELSE
         CALL i932_rec(l_azw[l_i].azw07,'0')
       END IF
    END FOR

    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aooi932'
    IF g_zz05='Y' THEN 
        CALL cl_wcchp(g_wc,'azw01')   #FUN-A30030 ADD POS  #FUN-A80148--mod--
        RETURNING g_wc
    END IF
    LET g_str=g_wc
   #CALL cl_prt_cs1("aooi932","aooi932",g_sql,g_str)
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('aooi932','aooi932',l_sql,g_str)
END FUNCTION

FUNCTION i932_rec(l_azw01,l_flag)
  DEFINE l_azw01 LIKE azw_file.azw01
  DEFINE l_flag  LIKE type_file.chr1
  
  DEFINE l_azw  DYNAMIC ARRAY OF RECORD 
         azw01   LIKE azw_file.azw01,
         azp02   LIKE azp_file.azp02,
         azw07   LIKE azw_file.azw07
        END RECORD
  DEFINE l_i,l_n LIKE type_file.num5


  IF l_flag = '0' THEN
   LET g_sql="SELECT azw01,azp02,azw07 FROM azw_file,azp_file ",          
             " WHERE azw01 = azp01 ",
             "   AND azw01 ='", l_azw01 CLIPPED,"'",
             " ORDER BY azw01"
  ELSE
   LET g_sql="SELECT azw01,azp02,azw07 FROM azw_file,azp_file ",          
             " WHERE azw01 = azp01 ",
             "   AND azw07 ='", l_azw01 CLIPPED,"'",
             " ORDER BY azw01"
  END IF

   PREPARE i932_p2 FROM g_sql                
   DECLARE i932_c2  CURSOR FOR i932_p2
   
   LET l_n = 1
   FOREACH i932_c2 INTO l_azw[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       EXECUTE insert_prep USING l_azw[l_n].azw01,l_azw[l_n].azp02,l_azw[l_n].azw07
       LET l_n = l_n + 1 
   END FOREACH
   CALL l_azw.deleteELEMENT(l_n)
   LET l_n = l_n - 1
  

   FOR l_i = 1 TO l_n
       CALL i932_rec(l_azw[l_i].azw01,'1')
   END FOR


END FUNCTION
#FUN-B30157 end

##################################################
# Descriptions...: 以法人做分類，填充根的子節點
# Date & Author..: tommas
# Input Parameter: 
# Return code....: void
##################################################
FUNCTION i932_tree_fill_1()
    DEFINE p_level      LIKE type_file.num5,
           l_child      INTEGER

    INITIALIZE g_tree TO NULL
      
      #設虛擬根節點      
      LET p_level = 0
      LET g_idx = 0
 #暫時先將root節點拿掉⾿      #LET g_tree[g_idx].image = "open"
#      LET g_tree[g_idx].expanded = 1          #0:不展開 1:展開
#      LET g_tree[g_idx].name = "\\"   #樹名稱
#      LET g_tree[g_idx].id = "root"                              #樹id
#      LET g_tree[g_idx].pid = NULL                                         #根，所以pid = NULL
      
#      SELECT COUNT(*) INTO l_child FROM azw_file WHERE azw07 IS NULL
      
#      LET g_tree[g_idx].has_children = FALSE                               #是否有子子節點
#      IF l_child > 0 THEN
#          LET g_tree[g_idx].has_children = TRUE
#      END IF
      
#      LET g_tree[g_idx].level = 1                                          #節點層數
#      LET g_tree[g_idx].azp02_t = NULL       #本身名稱
#      LET g_tree[g_idx].azw02 = NULL         
      
#      IF l_child > 0 THEN   
#          CALL i932_tree_fill_2("root",p_level)
#      END IF
       CALL i932_tree_fill_2(NULL,p_level)    

END FUNCTION

##################################################
# Descriptions...: azw7 = NULL 
# Date & Author..: tommas
# Input Parameter: p_azw02：所屬法人
# Return code....:
##################################################
FUNCTION i932_tree_fill_2(p_pid,p_level)
    DEFINE p_level           LIKE type_file.num5,
           p_pid             STRING,
           l_child           INTEGER
    DEFINE l_loop            INTEGER,
           l_azp02           LIKE azp_file.azp02
    DEFINE l_azw             DYNAMIC ARRAY OF RECORD
                azw01        LIKE azw_file.azw01,
                azw07        LIKE azw_file.azw07,
                azw02        LIKE azw_file.azw02
                             END RECORD
    DEFINE l_cnt             LIKE type_file.num5
    DEFINE l_str              STRING
    
    
      LET g_sql = "SELECT azw01, azw01 as azw07, azw02 ",
                  " FROM azw_file ",
                  " WHERE azw07 IS NULL ",
#                  "AND azw02 ='",g_azw02,"' ",               #取得最上層
                  " AND ", g_wc_o CLIPPED,
                  #TQC-A60039 begin
                  " UNION  ",
                  "SELECT azw01,azw01 as azw07, azw02 ", 
                  " FROM azw_file ",
                  " WHERE azw07 IS NULL",
                  " AND azw01 IN (SELECT azw07 FROM azw_file", 
                  " WHERE azw07 NOT IN(SELECT azw01",
                  " FROM azw_file", 
                  " WHERE azw07 IS NULL", 
                  " AND ", g_wc_o CLIPPED,")",
                  " AND ", g_wc_o CLIPPED,")",
                  " ORDER BY azw01 "
                  #TQC-A60039 end
      
      PREPARE i932_tree_pre1 FROM g_sql
      DECLARE i932_tree_cs1 CURSOR FOR i932_tree_pre1
      
      # LEVEL 3
      LET l_loop = 1
      LET l_cnt = 1
      LET p_level = p_level + 1
      CALL l_azw.clear()
      FOREACH i932_tree_cs1 INTO l_azw[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      FREE i932_tree_cs1
      
      CALL l_azw.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列      
      LET l_cnt = l_cnt - 1
      IF l_cnt >0 THEN
         FOR l_loop=1 TO l_cnt
              LET g_idx = g_idx + 1
              LET g_tree[g_idx].expanded = 1          #0:不展開 1:展開
              
              SELECT azp02 INTO l_azp02 FROM azp_file
                WHERE azp01 = l_azw[l_loop].azw01

              LET g_tree[g_idx].name = l_azw[l_loop].azw01,"(",l_azp02,")" 
              LET l_str = l_loop 
              LET g_tree[g_idx].id = l_str
              LET g_tree[g_idx].treekey1 = l_azw[l_loop].azw01
              LET g_tree[g_idx].pid = p_pid
              LET g_tree[g_idx].path = l_azw[l_loop].azw01 ##FUN-A50010 by suncx1
              LET g_tree[g_idx].has_children = FALSE

             #找出子營運中彿         
              SELECT COUNT(*) INTO l_child FROM azw_file 
                     WHERE azw07 = l_azw[l_loop].azw01

              LET g_tree[g_idx].level = p_level
              LET g_tree[g_idx].azp02_t = l_azp02       #本身名稱
              LET g_tree[g_idx].azw02 = l_azw[l_loop].azw02

              IF l_child > 0 THEN 
                 LET g_tree[g_idx].has_children = TRUE
                 CALL i932_tree_fill(g_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1)
              END IF
          END FOR
      END IF
      
END FUNCTION


##################################################
# Descriptions...: Tree填充
# Date & Author..: 
# Input Parameter: p_wc,p_pid,p_level,p_key1
# Return code....:
##################################################
FUNCTION i932_tree_fill(p_wc,p_pid,p_level,p_path,p_key1) #FUN-A50010 加入p_wc，p_key1
   DEFINE p_wc            STRING               #查詢條件     #FUN-A50010
   DEFINE p_pid           LIKE azw_file.azw07               #父節點id
   DEFINE p_level         LIKE type_file.num5  #階層
   DEFINE p_path             STRING            #節點路徑     #FUN-A50010
   DEFINE p_key1             STRING                         #FUN-A50010
   DEFINE l_child         INTEGER
   DEFINE l_azw           DYNAMIC ARRAY OF RECORD
          azw07           LIKE azw_file.azw07,
          azw01           LIKE azw_file.azw01,
          azw02           LIKE azw_file.azw02
                          END RECORD
   DEFINE l_azp02         LIKE azp_file.azp02  #部門名稱
   DEFINE l_str           STRING
   DEFINE max_level       LIKE type_file.num5  #最大階層數,可避免無窮迴圈
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5

   LET max_level = 20 #設定最大階層數為20(和abmp611相同設定,之後改為傳參擿）

      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","aoo1001",max_level,0) 
         RETURN
      END IF

      LET g_sql = "SELECT azw01,azw01 as azw07, azw02 ",
                  "FROM azw_file ",
                  "WHERE azw07 = '",p_key1,"' "
#                 , " AND azw02 = '",g_azw02,"' "
                 
      PREPARE i932_tree_pre2 FROM g_sql
      DECLARE i932_tree_cs2 CURSOR FOR i932_tree_pre2

      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_azw.clear()
      FOREACH i932_tree_cs2 INTO l_azw[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      FREE i932_tree_cs2
      CALL l_azw.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列      
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = p_pid,".",l_str
            LET g_tree[g_idx].treekey1 = l_azw[l_i].azw01
            LET g_tree[g_idx].expanded = 1    #0:不展開 1:展開
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_azw[l_i].azw01  ##FUN-A50010 by suncx1
            
            SELECT azp02 INTO l_azp02 FROM azp_file
               WHERE azp01 = l_azw[l_i].azw01
               
            LET g_tree[g_idx].name =l_azw[l_i].azw01,"(",l_azp02,")"
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].azp02_t = l_azp02
            LET g_tree[g_idx].azw02 = l_azw[l_i].azw02
            #有子節點             
            SELECT COUNT(*) INTO l_child FROM azw_file WHERE azw07 = l_azw[l_i].azw01
            
            LET g_tree[g_idx].has_children = FALSE
            IF l_child > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL i932_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1) #FUN-A50010
            END IF
          END FOR
      END IF

END FUNCTION

#FUN-A50010  
##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION i932_tree_idxbykey()   # fetch單頭後，利用g_azw01來搜尋該資料目前位於g_tree的哪個索引中。
   DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 0
   FOR l_idx = 1 TO g_tree.getLength()
   #   IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey1 == g_azw07 ) CLIPPED THEN  # 尋找節點
       IF  g_tree[l_idx].treekey1  == g_azw07  CLIPPED THEN  # 尋找節點
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
       END IF
   END FOR
END FUNCTION


#FUN-A50010  
##################################################
# Descriptions...: 依tree path指定focus節點
# Date & Author..: 10/05/06  
# Input Parameter:
# Return code....:
##################################################
FUNCTION i932_tree_idxbypath()
   DEFINE l_i       LIKE type_file.num5
   
   LET g_tree_focus_idx = 1
   FOR l_i = 1 TO g_tree.getlength()
      IF g_tree[l_i].path = g_tree_focus_path THEN
            LET g_tree_focus_idx = l_i
            EXIT FOR
      END IF
   END FOR
END FUNCTION

#FUN-A50010
##################################################
# Descriptions...: 展開節點
# Date & Author..: 10/05/06
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION i932_tree_open(p_idx)
   DEFINE p_idx        LIKE type_file.num10  #index
   DEFINE l_pid        STRING                #父節id
   DEFINE l_openpidx   LIKE type_file.num10  #展開父index
   DEFINE l_arrlen     LIKE type_file.num5   #array length
   DEFINE l_i          LIKE type_file.num5

   LET l_openpidx = 0
   LET l_arrlen = g_tree.getLength()

   IF p_idx > 0 THEN
      IF g_tree[p_idx].has_children THEN
         LET g_tree[p_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
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
         #展開父節點
         IF (l_openpidx > 0) AND (NOT cl_null(g_tree[p_idx].path)) THEN
            CALL i932_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION

#FUN-A50010
##################################################
# Descriptions...: 檢查是否為無窮迴圈
# Date & Author..: 10/05/06
# Input Parameter: p_key1,p_flag
# Return code....: l_loop
##################################################
FUNCTION i932_tree_loop(p_key1,p_flag)
   DEFINE p_key1             STRING
   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_azw              DYNAMIC ARRAY OF RECORD
             azw07           LIKE azw_file.azw07,
             azw01           LIKE azw_file.azw01,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_azp02            LIKE azp_file.azp02  #名稱
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N

   IF cl_null(p_flag) THEN   #第一次進遞迴
      LET g_idx = 1
      LET g_path_add[g_idx] = p_key1
   END IF
   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF

   IF NOT cl_null(p_key1) THEN
      LET g_sql = "SELECT DISTINCT azw_file.azw01,cnt.child_cnt",
                  " FROM (",
                  "   SELECT DISTINCT azw01 FROM azw_file",
                  "   WHERE azw01='",p_key1 CLIPPED,"'",
                  " ) azw_file"
      PREPARE i932_tree_pre3 FROM g_sql
      DECLARE i932_tree_cs3 CURSOR FOR i932_tree_pre3

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_azw.clear()
      FOREACH i932_tree_cs3 INTO l_azw[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_azw.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_path_add[g_idx] = l_azw[l_i].azw01
            IF g_path_add[g_idx] = p_key1 THEN
               LET l_loop = "Y"
               RETURN l_loop
            END IF
            #有子節點
            IF l_azw[l_i].child_cnt > 0 THEN
               CALL i932_tree_loop(p_key1,p_flag) RETURNING l_loop
            END IF
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION

#FUN-A50010   
##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/06 
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i932_tree_update()
   #Tree重查並展開focus節點
   CALL i932_tree_fill_1() #Tree填充
   CALL i932_tree_idxbypath()                        #依tree path指定focus節點
   CALL i932_tree_open(g_tree_focus_idx)             #展開節點
   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單身
   ELSE
      LET g_tree_b = "Y"
   END IF
   CALL i932_q(g_tree_focus_idx)
END FUNCTION

#No:FUN-A50010
##################################################
# Descriptions...: 獲取正確的g_jump和g_curs_index
# Date & Author..: 10/05/05 By suncx1
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i932_jump()
    DEFINE l_idx   INTEGER
    DEFINE l_jump    LIKE type_file.num10
    LET l_jump = 1
    FOR l_idx = 1 TO g_azw01.getLength()
       IF g_azw01[l_idx].azw01 == g_tree[g_tree_focus_idx].treekey1 THEN 
          LET l_jump = l_idx
       END IF
    END FOR  
    RETURN l_jump
END FUNCTION
