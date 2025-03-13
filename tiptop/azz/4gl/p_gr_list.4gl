# Prog. Version..: '5.30.06-13.03.12(00007)'     #
# Pattern name...: p_gr_list.4gl
# Descriptions...: 歷史報表查詢作業
# Date & Author..: FUN-C40050 2012/04/12 By odyliao
# Modify.........: TQC-C50132 2012/05/15 By odyliao 抓取資料應考慮客製模組(CXX)
# Modify.........: FUN-C70095 2012/07/23 By janet 1.重新掃描完後立刻刷新畫面樹狀內容 2.只顯示營運中心查詢
# Modify.........: FUN-C70103 2012/07/24 By downheal 新增預覽SVG檔案功能
# Modify.........: FUN-C80028 2012/08/08 By janet 若下載至c:\tiptop失敗顯示訊息
# Modify.........: FUN-C80015 2012/08/30 By janet 歷史報表檔案自定命名
# Modify.........: TQC-CC0033 2012/12/06 By odyliao 修正展開樹狀圖可能會造成的錯誤

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_file_plant       LIKE azp_file.azp01,   #檔案營運中心  
         g_file_creator     LIKE zx_file.zx01,     #檔案建立者    
         g_file_progid      LIKE zz_file.zz01,     #檔案程式代號  
         g_file_classid     LIKE zx_file.zx04,     #檔案權限類別  
         g_file_createtime  LIKE type_file.dat,    #檔案建立日期  
         g_list      DYNAMIC ARRAY OF RECORD   #右下列表的陣列
                       prog_id       LIKE zz_file.zz01,      #程式代號
                       prog_name     LIKE gaz_file.gaz03,    #程式名稱
                       create_time   LIKE type_file.chr100,  #建立日期時間
                       file_size     LIKE type_file.chr20,   #檔案大小(Kb)
                       creator_id    LIKE zx_file.zx01,      #製表人
                       creator_name  LIKE zx_file.zx02,      #製表人姓名
                       svg_file_name LIKE type_file.chr100   #SVG檔案名稱
                     END RECORD,
         g_list_t    RECORD                   #程式變數 (舊值)
                       prog_id       LIKE zz_file.zz01,      #程式代號
                       prog_name     LIKE gaz_file.gaz03,    #程式名稱
                       create_time   LIKE type_file.chr100,  #建立日期時間
                       file_size     LIKE type_file.chr20,   #檔案大小(Kb)
                       creator_id    LIKE zx_file.zx01,      #製表人
                       creator_name  LIKE zx_file.zx02,      #製表人姓名
                       svg_file_name LIKE type_file.chr100   #SVG檔案名稱
                      END RECORD,
         g_wc,g_sql   STRING,  
         g_rec_b      LIKE type_file.num5,         #單身筆數            
         l_ac         LIKE type_file.num5          #目前處理的ARRAY
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL  #FUN-C40050
DEFINE   g_row_count     LIKE type_file.num10    
DEFINE   g_curs_index    LIKE type_file.num10   
DEFINE   g_str           STRING
DEFINE   g_items,g_texts STRING
DEFINE   g_sel           LIKE type_file.chr1
DEFINE   g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
             name           STRING,                 #節點名稱          
             pid            STRING,                 #父節點id
             id             STRING,                 #節點id
             has_children   BOOLEAN,                #1:有子節點 null:無子節點          
             expanded       BOOLEAN,                #0:不展開 1:展開
             level          LIKE type_file.num5,    #階層
             path           STRING,                 #節點路徑，以"."隔開
             values         LIKE type_file.chr1000, #此節點的值
             azp01          LIKE azp_file.azp01,    #此節點歸屬的營運中心(最上階)
             bdate          LIKE type_file.dat,     #起始日 (for時間查詢)
             edate          LIKE type_file.dat,     #截止日 (for時間查詢)
             image          STRING                  #文字前的圖片
         END RECORD
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_msg             LIKE ze_file.ze03        
DEFINE g_curr_idx        INTEGER 
DEFINE g_cnt             LIKE type_file.num10 
TYPE   g_tmp_t       RECORD
                        prog_id       LIKE zz_file.zz01,      #程式代號
                        prog_name     LIKE gaz_file.gaz03,    #程式名稱
                        create_time   LIKE type_file.chr100,  #建立日期時間
                        file_size     LIKE type_file.chr20,   #檔案大小(Kb)
                        creator_id    LIKE zx_file.zx01,      #製表人
                        creator_name  LIKE zx_file.zx02,      #製表人姓名
                        svg_file_name LIKE type_file.chr100,  #SVG檔案名稱
                        plant_id      LIKE azp_file.azp01,    #營運中心代碼
                        file_date     LIKE type_file.dat,     #SVG檔案日期
                        classid       LIKE zx_file.zx04,      #製表人對應的權限類別
                        module_id     LIKE type_file.chr10    #模組代號
                     END RECORD

                  
MAIN
   OPTIONS                                #改變一些系統預設值        
       INPUT NO WRAP,                     #輸入的方式: 不打轉        
       FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL p_gr_list_create_tmp()

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW p_gr_list_w WITH FORM "azz/42f/p_gr_list"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_wc = '1=1'             
   IF g_user = 'tiptop' THEN    #tiptop帳號才提供全部種類查詢,其餘使用者僅能查1.時間2.模組
      LET g_items = "1,2,3,4"
      LET g_texts = cl_getmsg('azz1214',g_lang)
     # CALL cl_set_comp_visible('creator,svg_file_name',TRUE) #tiptop才看的見 QBE的製表者和svg檔名欄位 #FUN-C80015 mark
      CALL cl_set_comp_visible('gcl03,svg_file_name',TRUE) #tiptop才看的見 QBE的製表者和svg檔名欄位  #FUN-C80015 add
   ELSE
      LET g_items = "1,2"
      LET g_texts = cl_getmsg('azz1215',g_lang)
      #CALL cl_set_comp_visible('creator,svg_file_name',FALSE)  #FUN-C80015 mark
      CALL cl_set_comp_visible('gcl03,svg_file_name',FALSE)   #FUN-C80015 add
   END IF
   CALL cl_set_combo_items("sel",g_items,g_texts CLIPPED)

   CALL p_gr_list_ins_time_tmp() #預先準備'時間'查詢時的間距範圍
   
   CALL p_gr_list_menu()

   CLOSE WINDOW p_gr_list_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN



#QBE 查詢資料
FUNCTION p_gr_list_cs()
   DEFINE l_i     LIKE type_file.num5
   CLEAR FORM 
   CALL g_list.clear() 
   CALL g_tree.clear() 
   LET g_sel = '1'

  #清空畫面 Tree的部份
   DISPLAY ARRAY g_tree TO tree.*
       BEFORE DISPLAY 
          EXIT DISPLAY
   END DISPLAY
                                                                                     
   DIALOG ATTRIBUTE(unbuffered)
      #CONSTRUCT BY NAME g_wc ON plant,progid,createtime,creator,classid  #FUN-C80015 mark
      CONSTRUCT BY NAME g_wc ON gcl01,gcl02,gcl05,gcl03,gcl04  #FUN-C80015 add     
          BEFORE CONSTRUCT                                                         
             CALL cl_qbe_init()               
      END CONSTRUCT

      INPUT g_sel FROM sel ATTRIBUTE(WITHOUT DEFAULTS)

         AFTER FIELD sel
            IF NOT cl_null(g_sel) THEN
               IF g_sel NOT MATCHES '[1234]' THEN
                  NEXT FIELD CURRENT
               END IF
            END IF

      END INPUT
 
      ON ACTION CONTROLP
         CASE
           # WHEN INFIELD(plant)  #查詢營運中心           #FUN-C80015 mark
            WHEN INFIELD(gcl01)  #查詢營運中心            #FUN-C80015 add
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_azp"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO plant            #FUN-C80015 mark  
               DISPLAY g_qryparam.multiret TO gcl01             #FUN-C80015 add           
            #WHEN INFIELD(progid)  #查詢程式代號                  #FUN-C80015 mark
            WHEN INFIELD(gcl02)  #查詢程式代號                    #FUN-C80015 add
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_zz"
               LET g_qryparam.state ="c"
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO progid          #FUN-C80015 mark
               DISPLAY g_qryparam.multiret TO gcl02            #FUN-C80015 add
            #WHEN INFIELD(creator)  #查詢製表人                  #FUN-C80015 mark
            WHEN INFIELD(gcl03)  #查詢製表人                     #FUN-C80015 add  
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_zx"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO creator         #FUN-C80015 mark
               DISPLAY g_qryparam.multiret TO gcl03            #FUN-C80015 add 
            #WHEN INFIELD(classid)  #查詢權限類別                #FUN-C80015 mark                 
            WHEN INFIELD(gcl04)  #查詢權限類別                   #FUN-C80015 add
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_zw"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO classid         #FUN-C80015 mark  
               DISPLAY g_qryparam.multiret TO gcl04            #FUN-C80015 add
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
            
      ON ACTION CONTROLG
         CALL cl_cmdask()
               
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
            
      ON ACTION about
         CALL cl_about()
                 
      ON ACTION help 
         CALL cl_show_help()
                 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
                 
      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION ACCEPT
         
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG

   END DIALOG
   IF INT_FLAG THEN
      RETURN
   END IF
   
   IF cl_null(g_wc) THEN
      LET g_wc="1=1"
   END IF
   DISPLAY "g_wc:",g_wc
   IF g_user <> 'tiptop' THEN #非tiptop只能查詢自己的報表
     #FUN-C80015 --start--
      #LET g_wc = g_wc , " AND creator = '",g_user,"'"
      LET g_wc = g_wc , " AND gcl03 = '",g_user,"'"
     #FUN-C80015 --end--
   END IF
   
   CALL p_gr_list_ins_tmp(NULL)      #掃描TEMPDIR檔案資訊存入TEMP TABLE
    
END FUNCTION

FUNCTION p_gr_list_menu()
   DEFINE l_tree_ac          LIKE type_file.num5
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer

   WHILE TRUE
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept", FALSE) 
      DIALOG ATTRIBUTES(UNBUFFERED)      
         #顯示子節點
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE ROW #可用來設定"選取"時的動作.
                LET l_tree_arr_curr = ARR_CURR()            
                IF g_sel = '1' AND g_tree[l_tree_arr_curr].level MATCHES '[23]' THEN
                   LET g_msg = cl_getmsg('azz1219',g_lang),g_tree[l_tree_arr_curr].bdate ,"-",g_tree[l_tree_arr_curr].edate
                   CALL cl_msg(g_msg)
                   CALL ui.Interface.refresh()
                ELSE
                   CALL cl_msg(' ')
                   CALL ui.Interface.refresh()
                END IF
                CALL p_gr_fill_list(l_tree_arr_curr)
            #ON ACTION controln  #FUN-C70103 add 不為任何作用 
               
              
         END DISPLAY #TREE end

         DISPLAY ARRAY g_list TO s_list.* ATTRIBUTE(COUNT=g_rec_b)
           BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )

           BEFORE ROW 
              LET l_ac = ARR_CURR()
              CALL cl_show_fld_cont()

           AFTER DISPLAY
             CONTINUE DIALOG   #因為外層是DIALOG  
             
             #END DISPLAY     #FUN-C70103 mark
           #FUN-C70103 --START--
           ON ACTION VIEW_SVG
             #IF cl_chk_act_auth() THEN #權限控管 
              LET l_ac = ARR_CURR()
              CALL p_gr_list_view(g_list[l_ac].svg_file_name)
             #END IF 
           ON ACTION ACCEPT 
            # IF cl_chk_act_auth() THEN #權限控管 
              LET l_ac = ARR_CURR()              
              CALL p_gr_list_view(g_list[l_ac].svg_file_name) 
            # END IF              
            END DISPLAY 
           #FUN-C70103 ---END---
           BEFORE DIALOG


           ON ACTION reload_file
              LET g_action_choice="reload_file"
              EXIT DIALOG
                       
           ON ACTION exit
              LET g_action_choice="exit"
              EXIT DIALOG

           ON ACTION query
              LET g_action_choice="query"
              EXIT DIALOG

           ON ACTION controlg
              LET g_action_choice="controlg"
              EXIT DIALOG

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


      END DIALOG
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      CALL cl_set_act_visible("accept,cancel", TRUE)

      CASE g_action_choice
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL p_gr_list_q() 
              END IF 
           WHEN "reload_file"
              IF cl_chk_act_auth() THEN
                #FUN-C80015---start---
                 #CALL p_gr_list_ins_tmp(g_action_choice) 
                 CALL p_gr_list_ins_tmp(NULL) 
                #FUN-C80015---end---
                 CALL p_gr_list_tree_fill() #FUN-C70095 add
              END IF 
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
      END CASE
    END WHILE

END FUNCTION

#Query 查詢
FUNCTION p_gr_list_q()
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_list.clear()
    CALL g_tree.clear()
    CALL p_gr_list_cs()                 #取得查詢條件 
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        CALL g_tree.clear()
        RETURN
    END IF
    CALL p_gr_list_tree_fill()   #Tree填充
   
END FUNCTION

FUNCTION p_gr_list_tree_fill()
DEFINE l_sql   STRING
DEFINE l_azp02 LIKE azp_file.azp02
DEFINE l_id    LIKE type_file.chr100
DEFINE l_plant LIKE azp_file.azp01
    
    INITIALIZE g_tree TO NULL
    LET g_idx = 0
    LET l_id = 1 

   #無論用哪一種排序, 最上層的節點都是營運中心
    #LET l_sql = "SELECT DISTINCT plant FROM p_gr_tmp ORDER BY plant " #FUN-C70095 mark
    #FUN-C70095 add-start---    
    LET l_sql = "SELECT DISTINCT plant FROM p_gr_tmp "
    #FUN-C80015 mark (s)----------
    #IF NOT cl_null(g_wc) THEN
        #LET l_sql = l_sql," where ",g_wc
    #END IF 
    #FUN-C80015 mark (s)----------
    LET l_sql=l_sql, "ORDER BY plant "    
    #FUN-C70095 add-start---    
    
    PREPARE p_gr_fill_pr1 FROM l_sql
    DECLARE p_gr_fill_cs1 CURSOR FOR p_gr_fill_pr1
    FOREACH p_gr_fill_cs1 INTO l_plant
      IF NOT cl_null(l_plant) THEN  #FUN-C80015 add 營運中心不為null才做
        LET g_idx = g_idx + 1
        SELECT azp02 INTO l_azp02 FROM azp_file
         WHERE azp01 = l_plant
         
        
        LET g_tree[g_idx].expanded = 1          #0:不展開 1:展開
        LET g_tree[g_idx].name = l_azp02 CLIPPED,"(",l_plant CLIPPED,")" 
        LET g_tree[g_idx].id = l_id
        LET g_tree[g_idx].values = l_plant
        LET g_tree[g_idx].azp01  = l_plant
        LET g_tree[g_idx].pid = NULL   #父節點
        LET g_tree[g_idx].level = 1
        LET g_tree[g_idx].path = l_plant
        LET g_tree[g_idx].has_children = TRUE
       #往下列出子節點
        CALL p_gr_list_tree_fill1(l_id,1,l_plant)
        LET l_id = l_id + 1
      END IF  #FUN-C80015 add 營運中心不為null才做
    END FOREACH

END FUNCTION

FUNCTION p_gr_list_tree_fill1(p_pid,p_level,p_plant)
DEFINE p_plant           LIKE azp_file.azp01
DEFINE p_level           LIKE type_file.num5,
       p_pid             STRING,
       l_child           INTEGER
DEFINE l_loop            INTEGER
DEFINE l_cnt             LIKE type_file.num5
DEFINE l_str             STRING
DEFINE l_sql             STRING
DEFINE l_value           LIKE type_file.chr1000
DEFINE l_bdate,l_edate   LIKE type_file.dat
DEFINE l_key1            LIKE type_file.chr1000
    

    CASE g_sel
      WHEN "1" #時間
         LET l_sql = "SELECT time_value,bdate,edate FROM p_gr_time_tmp ORDER BY sn " 

      WHEN "2" #模組
         LET l_sql = "SELECT UNIQUE module_id FROM p_gr_tmp ",
                     " WHERE ",g_wc,
                     "   AND plant = '",p_plant,"'"
         LET l_sql = cl_replace_str(l_sql,"gcl03","creator") #TQC-CC0033
      WHEN "3" #權限類別
         LET l_sql = "SELECT UNIQUE classid FROM p_gr_tmp ",
                     " WHERE ",g_wc,
                     "   AND plant = '",p_plant,"'"
         LET l_sql = cl_replace_str(l_sql,"gcl03","creator") #TQC-CC0033
      WHEN "4" #使用者
         LET l_sql = "SELECT UNIQUE creator FROM p_gr_tmp ",
                     " WHERE ",g_wc,
                     "   AND plant = '",p_plant,"'"
         LET l_sql = cl_replace_str(l_sql,"gcl03","creator") #TQC-CC0033
    END CASE
    PREPARE p_gr_fill_pr2 FROM l_sql
    DECLARE p_gr_fill_cs2 CURSOR FOR p_gr_fill_pr2

    LET l_loop = 1
    LET l_cnt = 1
    LET p_level = p_level + 1
    IF g_sel = '1' THEN
       FOREACH p_gr_fill_cs2 INTO l_value,l_bdate,l_edate
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF

            LET g_idx = g_idx + 1
            LET g_tree[g_idx].expanded = 1          #0:不展開 1:展開
            LET g_tree[g_idx].name = l_value
            LET l_str = l_cnt
            LET g_tree[g_idx].id = p_pid,'.',l_str
            LET g_tree[g_idx].pid = p_pid
            LET g_tree[g_idx].path = p_plant CLIPPED,'.',l_value
            LET g_tree[g_idx].has_children = TRUE
            LET g_tree[g_idx].values = l_value
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].azp01 = p_plant
            LET g_tree[g_idx].bdate = l_bdate
            LET g_tree[g_idx].edate = l_edate
            CALL p_gr_list_tree_fill2(g_tree[g_idx].id,p_level,g_tree[g_idx].path,p_plant,l_key1,l_bdate,l_edate) 
            LET l_cnt = l_cnt + 1
       END FOREACH
    ELSE
       FOREACH p_gr_fill_cs2 INTO l_key1
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].expanded = 1          #0:不展開 1:展開
            LET g_tree[g_idx].name = p_gr_list_treename(l_key1)
            LET l_str = l_cnt
            LET g_tree[g_idx].id = p_pid,'.',l_str
            LET g_tree[g_idx].pid = p_pid
            LET g_tree[g_idx].path = p_plant CLIPPED,'.',l_key1
            LET g_tree[g_idx].has_children = TRUE
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].values = l_key1
            LET g_tree[g_idx].azp01 = p_plant
            LET l_cnt = l_cnt + 1
            CALL p_gr_list_tree_fill2(g_tree[g_idx].id,p_level,g_tree[g_idx].path,p_plant,l_key1,NULL,NULL) 

       END FOREACH
    END IF
      
END FUNCTION


##################################################
# Descriptions...: 最底層Tree填充 (by 程式代號列出)
# Date & Author..: 
# Input Parameter: p_pid,p_level,p_path,p_key1
# Return code....:
##################################################
FUNCTION p_gr_list_tree_fill2(p_pid,p_level,p_path,p_plant,p_key1,p_bdate,p_edate)
   DEFINE p_pid           LIKE azw_file.azw07  #父節點id
   DEFINE p_level         LIKE type_file.num5  #階層
   DEFINE p_plant         LIKE azp_file.azp01  #營運中心
   DEFINE p_path          STRING               #節點路徑
   DEFINE p_bdate         LIKE type_file.dat
   DEFINE p_edate         LIKE type_file.dat
   DEFINE p_key1          STRING            
   DEFINE l_child         INTEGER
   DEFINE l_str           STRING
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_sql           STRING 
   DEFINE l_prog_id       LIKE zz_file.zz01
   DEFINE l_prog_name     LIKE gaz_file.gaz03


   LET p_level = p_level + 1   #下一階層
   CASE g_sel
      WHEN "1" #by時間列出程式代號
         LET l_sql = "SELECT UNIQUE progid,prog_name FROM p_gr_tmp ",
                    # " WHERE ",g_wc,  #FUN-C80015 mark
                     " WHERE 1=1",     #FUN-C80015 add
                     "   AND file_date >='",p_bdate,"'", 
                     "   AND file_date <='",p_edate,"'",
                     "   AND plant = '",p_plant,"'",
                     " ORDER BY progid "
      WHEN "2" #by模組列出程式代號
         LET l_sql = "SELECT UNIQUE progid,prog_name FROM p_gr_tmp ",
                    # " WHERE ",g_wc,  #FUN-C80015 mark
                     " WHERE 1=1",     #FUN-C80015 add
                     "   AND module_id='",p_key1,"'",
                     "   AND plant = '",p_plant,"'",
                     " ORDER BY progid "
      WHEN "3" #by權限類別列出程式代號
         LET l_sql = "SELECT UNIQUE progid,prog_name FROM p_gr_tmp ",
                    # " WHERE ",g_wc,  #FUN-C80015 mark
                     " WHERE 1=1",     #FUN-C80015 add
                     "   AND classid='",p_key1,"'",
                     "   AND plant = '",p_plant,"'",
                     " ORDER BY progid "
      WHEN "4" #by使用者列出程式代號
         LET l_sql = "SELECT UNIQUE progid,prog_name FROM p_gr_tmp ",
                    # " WHERE ",g_wc,  #FUN-C80015 mark
                     " WHERE 1=1",     #FUN-C80015 add
                     "   AND creator='",p_key1,"'",
                     "   AND plant = '",p_plant,"'",
                     " ORDER BY progid "
   END CASE

   PREPARE p_gr_list_tree_pr2 FROM l_sql
   DECLARE p_gr_list_tree_cs2 CURSOR FOR p_gr_list_tree_pr2
   LET l_cnt = 1
   FOREACH p_gr_list_tree_cs2 INTO l_prog_id,l_prog_name
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].expanded = 0          #0:不展開 1:展開
      LET g_tree[g_idx].name = l_prog_name,"(",l_prog_id,")"
      LET l_str = l_cnt
      LET g_tree[g_idx].id = p_pid,'.',l_str
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].pid = p_pid
      LET g_tree[g_idx].path = p_path CLIPPED,'.',l_prog_id
      LET g_tree[g_idx].has_children = FALSE
      LET g_tree[g_idx].values = l_prog_id
      LET g_tree[g_idx].azp01 = p_plant
      LET g_tree[g_idx].bdate = p_bdate
      LET g_tree[g_idx].edate = p_edate
      LET l_cnt = l_cnt + 1

   END FOREACH
   IF STATUS THEN CALL cl_err('list_tree2:',STATUS,1) END IF

END FUNCTION


FUNCTION p_gr_list_ins_tmp(p_act)
DEFINE   p_act       LIKE type_file.chr20
DEFINE   l_tempdir   STRING
DEFINE   l_h         LIKE type_file.num10  #ls的長度
DEFINE   l_items     STRING                #讀取的每一行資訊
DEFINE   l_idx       LIKE type_file.num5
DEFINE   l_size      LIKE type_file.num10
DEFINE   l_desc      LIKE type_file.chr1000
DEFINE   l_tmp       g_tmp_t
DEFINE   l_cnt       LIKE type_file.num5
#FUN-C80015 add-start----------------------------------------------
DEFINE   l_gcl       DYNAMIC ARRAY OF RECORD   
                       gcl01       LIKE gcl_file.gcl01,   #營運中心
                       gcl02       LIKE gcl_file.gcl02,   #程式代號
                       gcl03       LIKE gcl_file.gcl03,   #製表人
                       gcl04       LIKE gcl_file.gcl04,   #權限類別
                       gcl05       LIKE gcl_file.gcl05,   #製表日期
                       gcl06       LIKE gcl_file.gcl06,   #SVG檔案名稱
                       gcl07       LIKE gcl_file.gcl07,   #有效否
                       gcl08       LIKE gcl_file.gcl08    #製表時間
                     END RECORD 
DEFINE   l_time_str   LIKE type_file.chr20
DEFINE   i            LIKE type_file.num5
DEFINE   l_gcl_cnt    LIKE type_file.num5
DEFINE   l_flag       LIKE type_file.chr1
#FUN-C80015 add-end----------------------------------------------                    

   #FUN-C80015 MARK  ---start---
   # IF cl_null(p_act) THEN
   #    SELECT COUNT(*) INTO l_cnt FROM p_gr_tmp
   #    IF l_cnt > 0 THEN RETURN END IF
   # ELSE
   #    IF NOT cl_confirm('azz1216') THEN RETURN END IF 
   # END IF
   #FUN-C80015 MARK  ---start---

    DELETE FROM p_gr_tmp

    #FUN-C80015 mark start--------------------------------------------
    #LET l_tempdir = FGL_GETENV('TEMPDIR')   #目錄指定在 $TEMPDIR
    #LET l_h = os.Path.diropen(l_tempdir)     #OPEN (這等於是做 ls 指令)
    #LET l_cnt = 0
    #WHILE l_h > 0
        #LET l_items = os.Path.dirnext(l_h)
#
        #IF l_items IS NULL THEN  #讀取完跳出
           #EXIT WHILE
        #END IF
        #IF l_items = "." OR l_items = ".." THEN  #讀到目錄跳過
           #CONTINUE WHILE
        #END IF
#
        #LET l_idx = l_items.getIndexOf(".svg",1) #讀取檔案名稱是否有.svg
        #IF l_idx > 0 THEN                        #是 svg檔再繼續處理
           #CALL os.Path.size(l_items) RETURNING l_tmp.file_size         #取得檔案大小
           #LET l_tmp.file_size = l_tmp.file_size / 1000                 #換算成Kb
           #CALL os.Path.atime(l_items) RETURNING l_tmp.create_time      #取得檔案時間
           #CALL os.Path.basename(l_items) RETURNING l_tmp.svg_file_name #SVG檔案名稱
           #CALL p_gr_list_filedate(l_tmp.create_time) RETURNING l_tmp.file_date     #檔案日期
           #CALL p_gr_list_fileinfo(l_tmp.*) RETURNING l_tmp.* 
          #非 tiptop 時, 數量只計算該 user 的
           #IF g_user <> 'tiptop' AND l_tmp.creator_id <> g_user THEN CONTINUE WHILE END IF
           #INSERT INTO p_gr_tmp VALUES(l_tmp.*)            
           #IF STATUS THEN CALL cl_err('ins p_gr_tmp:',STATUS,1) END IF
           #LET l_cnt = l_cnt + 1
        #ELSE
           #CONTINUE WHILE
        #END IF
        #IF l_cnt MOD 100 = 0 THEN 
           #LET g_msg = cl_getmsg('azz1217',g_lang),l_cnt USING '<<<<<<&'
           #MESSAGE g_msg
           #CALL ui.Interface.refresh()
        #END IF
    #END WHILE
    #LET g_msg = cl_getmsg('azz1218',g_lang),l_cnt USING '<<<<<<&'
    #MESSAGE g_msg
    #CALL ui.Interface.refresh()
    #FUN-C80015 mark end --------------------------------------------

    
    #FUN-C80015 add start 直接從gcl_file抓資料存入tmp檔----------------------
    LET g_sql= "SELECT * from gcl_file ",
               " WHERE ",g_wc,
               "   AND gcl07 = 'Y'" #有效否
    #LET g_sql=g_sql,"WHERE ",g_wc
    IF g_user <> 'tiptop' THEN #非tiptop只能查詢自己的報表
        #LET g_sql=g_sql,"WHERE gcl03 = " ,g_user CLIPPED        
    END IF 
    PREPARE p_gr_ins_temp_pre FROM g_sql
    DECLARE p_gr_ins_temp_cur CURSOR FOR p_gr_ins_temp_pre
    CALL l_gcl.clear()
    LET l_gcl_cnt=1
    FOREACH p_gr_ins_temp_cur INTO l_gcl[l_gcl_cnt].*       
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF      

        LET l_gcl_cnt=l_gcl_cnt+1
    END FOREACH 
    SELECT count(*) INTO l_gcl_cnt FROM gcl_file

    FOR i = 1 TO l_gcl.getLength()
           LET l_tmp.plant_id =l_gcl[i].gcl01      #營運中心
           LET l_tmp.prog_id =l_gcl[i].gcl02       #程式代號           
           LET l_tmp.creator_id=l_gcl[i].gcl03     #製表者
           LET l_tmp.classid=l_gcl[i].gcl04        #權限
           LET l_time_str=l_gcl[i].gcl08
           LET l_time_str = l_gcl[i].gcl05," ",l_time_str[1,2],":",l_time_str[3,4],":",l_time_str[5,6]
           LET l_tmp.create_time =l_time_str           #取得檔案時間
           LET l_tmp.svg_file_name=l_gcl[i].gcl06  #SVG檔案名稱
           LET l_tmp.file_date =l_gcl[i].gcl05     #檔案日期                    
           CALL p_gr_list_fileinfo(l_tmp.*,l_gcl[i].gcl08) RETURNING l_tmp.*,l_flag
           IF l_flag = 'N' THEN CONTINUE FOR END IF
          #非 tiptop 時, 數量只計算該 user 的
           IF g_user <> 'tiptop' AND l_tmp.creator_id <> g_user THEN CONTINUE FOR END IF
           INSERT INTO p_gr_tmp VALUES(l_tmp.*)            
           IF STATUS THEN CALL cl_err('ins p_gr_tmp:',STATUS,1) END IF         
           IF i MOD 100 = 0 THEN 
              LET g_msg = cl_getmsg('azz1217',g_lang),i USING '<<<<<<&'
              MESSAGE g_msg
              CALL ui.Interface.refresh()
           END IF        
    END FOR 


    LET g_msg = cl_getmsg('azz1218',g_lang),l_cnt USING '<<<<<<&'
    MESSAGE g_msg
    CALL ui.Interface.refresh()
   #FUN-C80015 add start 直接從gcl_file抓資料存入tmp檔----------------------
    
END FUNCTION



#建立TEMP TABLE
FUNCTION p_gr_list_create_tmp()

   DROP TABLE p_gr_tmp
   CREATE TEMP TABLE p_gr_tmp(
            progid        LIKE zz_file.zz01,      #程式代號
            prog_name     LIKE gaz_file.gaz03,    #程式名稱
            createtime    LIKE type_file.chr100,  #建立日期時間
            file_size     LIKE type_file.chr20,   #檔案大小(Kb)
            creator       LIKE zx_file.zx01,      #製表人
            creator_name  LIKE zx_file.zx02,      #製表人姓名
            svg_file_name LIKE type_file.chr100,  #SVG檔案名稱
            plant         LIKE azp_file.azp01,    #營運中心代碼
            file_date     LIKE type_file.dat,     #SVG檔案日期
            classid       LIKE type_file.chr20,   #製表人對應的權限類別
            module_id     LIKE type_file.chr10)   #模組代號
   DELETE FROM p_gr_tmp

   DROP TABLE p_gr_time_tmp
   CREATE TEMP TABLE p_gr_time_tmp(
            sn         LIKE type_file.num5,      #排序
            time_value LIKE type_file.chr100,    #時間代號
            bdate      LIKE type_file.dat,       #起始日
            edate      LIKE type_file.dat)       #截止日
   DELETE FROM p_gr_time_tmp

END FUNCTION

#建立 p_gr_time_tmp 的資料
FUNCTION p_gr_list_ins_time_tmp()
DEFINE l_time_value     LIKE type_file.chr100
DEFINE i                LIKE type_file.num5
DEFINE l_yy,l_mm        LIKE type_file.num5
DEFINE l_sql            STRING
DEFINE l_bdate,l_edate  LIKE type_file.dat
DEFINE l_time_tmp     RECORD 
                         sn         LIKE type_file.num5,      #排序
                         time_value LIKE type_file.chr100,    #時間代號
                         bdate      LIKE type_file.dat,       #起始日
                         edate      LIKE type_file.dat        #截止日
                      END RECORD

    DELETE FROM p_gr_time_tmp

   #取得上週日的日期
    LET l_sql = "SELECT CASE WHEN TO_CHAR(sysdate,'D')=1 THEN ",
                " NEXT_DAY( TO_DATE ('",g_today-14,"','YY/MM/DD'),'SUNDAY') ",
                "  ELSE  NEXT_DAY( TO_DATE ('",g_today-7,"','YY/MM/DD'),'SUNDAY') END FROM DUAL "
    PREPARE p_gr_get_sunday_pr FROM l_sql
    EXECUTE p_gr_get_sunday_pr INTO l_bdate
    IF STATUS THEN CALL cl_err('p_gr_get_sunday_pr:',STATUS,0) END IF
    LET l_yy = YEAR(g_today)
    LET l_mm = MONTH(g_today)

    FOR i = 1 TO 18
        LET l_time_tmp.sn = i
        CASE i
          WHEN "1"  #今天
             LET l_time_tmp.time_value = cl_getmsg('azz1207',g_lang) #今天
             LET l_time_tmp.bdate = g_today
             LET l_time_tmp.edate = g_today
          WHEN "2"  #昨天
             LET l_time_tmp.time_value = cl_getmsg('azz1208',g_lang) #昨天
             LET l_time_tmp.bdate = g_today -1
             LET l_time_tmp.edate = g_today -1
          WHEN "3"  #前天
             LET l_time_tmp.time_value = cl_getmsg('azz1209',g_lang) #前天
             LET l_time_tmp.bdate = g_today -2
             LET l_time_tmp.edate = g_today -2
          WHEN "4"  #本週
             LET l_time_tmp.time_value = cl_getmsg('azz1210',g_lang) #本週
             LET l_time_tmp.bdate = l_bdate
             LET l_time_tmp.edate = g_today
          WHEN "5"  #上週
             LET l_bdate = l_bdate - 7
             LET l_time_tmp.time_value = cl_getmsg('azz1211',g_lang) #上週
             LET l_time_tmp.bdate = l_bdate 
             LET l_time_tmp.edate = l_bdate + 6
          WHEN "6"  #二週前
             LET l_bdate = l_bdate - 7
             LET l_time_tmp.time_value = cl_getmsg('azz1212',g_lang) #二週前
             LET l_time_tmp.bdate = l_bdate 
             LET l_time_tmp.edate = l_bdate + 6
          WHEN "7"  #三週前
             LET l_bdate = l_bdate - 7
             LET l_time_tmp.time_value = cl_getmsg('azz1213',g_lang) #三週前
             LET l_time_tmp.bdate = l_bdate 
             LET l_time_tmp.edate = l_bdate + 6
          WHEN "8"  #上1個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-1) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "9"  #上2個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-2) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "10"  #上3個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-3) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "11"  #上4個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-4) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "12"  #上5個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-5) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "13"  #上6個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-6) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "14"  #上7個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-7) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "15"  #上8個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-8) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "16"  #上9個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-9) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "17"  #上10個月(YYYY年MM月)
             CALL p_gr_month_days(l_yy,l_mm,-10) RETURNING
                  l_time_tmp.time_value,l_time_tmp.bdate,l_time_tmp.edate
          WHEN "18"  #其它
             LET l_time_tmp.time_value = cl_getmsg('afa-013',g_lang)
             LET l_time_tmp.edate = l_time_tmp.bdate - 1
             LET l_time_tmp.bdate = '01/01/01'
          OTHERWISE CONTINUE FOR
       END CASE
   
       INSERT INTO p_gr_time_tmp VALUES(l_time_tmp.*)
       IF STATUS THEN CALL cl_err('ins_time_tmp:',STATUS,1) EXIT FOR END IF
  
    END FOR
    

END FUNCTION

FUNCTION p_gr_list_fileinfo(p_tmp,p_gcl08) 
DEFINE   p_tmp       g_tmp_t
DEFINE   p_gcl08     LIKE gcl_file.gcl08 #FUN-C80015 add
DEFINE   l_idx1      LIKE type_file.num5 #第1個底線位置
DEFINE   l_idx2      LIKE type_file.num5 #第2個底線位置
DEFINE   l_idx3      LIKE type_file.num5 #第3個底線位置
DEFINE   l_idx4      LIKE type_file.num5 #第1個點的位置
DEFINE   l_filename_str  STRING
DEFINE   l_filename  LIKE type_file.chr100
DEFINE   l_size      LIKE TYPE_FILE.chr20  #FUN-C80015 add
DEFINE   l_file_path STRING                #FUN-C80015 add
DEFINE   l_flag      LIKE type_file.chr1   #FUN-C80015 add 

    #SVG檔名格式為 DS1_aapr121_coco_01r.svg (營運中心_程式代號_製表人_流水號.svg)
    #以此拆解出相關資訊

    #FUN-C80015 mark (S)-----------------------------
    #LET l_filename_str = p_tmp.svg_file_name
    #LET l_filename = p_tmp.svg_file_name
    #LET l_idx1 = l_filename_str.getIndexOf('_',1)
    #LET l_idx2 = l_filename_str.getIndexOf('_',l_idx1+1)
    #LET l_idx3 = l_filename_str.getIndexOf('_',l_idx2+1)
    #LET l_idx4 = l_filename_str.getIndexOf('.',1)
#
    #LET p_tmp.plant_id = l_filename[1,l_idx1-1]
    #LET p_tmp.prog_id = l_filename[l_idx1+1,l_idx2-1]
    #LET p_tmp.creator_id = l_filename[l_idx2+1,l_idx3-1]
    #FUN-C80015 mark (E)-----------------------------
    LET p_tmp.prog_name = p_gr_list_prog_name(p_tmp.prog_id)
    LET p_tmp.creator_name = p_gr_list_creator_name(p_tmp.creator_id)
    #FUN-C80015 add (s)-----------------------------------
    LET l_flag = 'Y'
    LET l_size= 0
    LET l_file_path=os.path.join(FGL_GETENV("TEMPDIR"),p_tmp.svg_file_name)
    IF os.Path.exists(l_file_path) THEN
       CALL os.Path.size(l_file_path) RETURNING l_size
       LET l_size=l_size/1000 #轉成kb      
    ELSE
       UPDATE gcl_file
       SET gcl07 = 'N'
       WHERE gcl01 = p_tmp.plant_id 
         AND gcl02 = p_tmp.prog_id 
         AND gcl03 = p_tmp.creator_id 
         AND gcl04 = p_tmp.classid 
         AND gcl05 = p_tmp.file_date
         AND gcl08 = p_gcl08
       LET l_flag = 'N'
    END IF 
    LET p_tmp.file_size=l_size
    #FUN-C80015 add (e)------------------------------------
    #LET p_tmp.classid = p_gr_list_class(p_tmp.creator_id) #FUN-C80015 mark
   #TQC-C50132   (S)
    #LET p_tmp.module_id = UPSHIFT(p_tmp.prog_id[1,3])
    IF p_tmp.prog_id[1,1] = 'c' THEN
       LET p_tmp.module_id = "A",UPSHIFT(p_tmp.prog_id[2,3])
    ELSE
       LET p_tmp.module_id = UPSHIFT(p_tmp.prog_id[1,3])
    END IF
   #TQC-C50132   (E)
 
    RETURN p_tmp.*,l_flag

END FUNCTION

#換算日期
FUNCTION p_gr_list_filedate(p_create_time) 
DEFINE p_create_time    LIKE type_file.chr100
DEFINE l_yy,l_mm,l_dd   LIKE type_file.num5
DEFINE l_mdy            LIKE type_file.dat

   LET l_yy = p_create_time[1,4]
   LET l_mm = p_create_time[6,7]
   LET l_dd = p_create_time[9,10]

   LET l_mdy = MDY(l_mm,l_dd,l_yy)
   RETURN l_mdy

END FUNCTION

#計算 YYYY年MM月 的第一天和最後一天
FUNCTION p_gr_month_days(p_yy,p_mm,p_add_month) 
DEFINE p_yy,p_mm,p_add_month   LIKE type_file.num5
DEFINE l_date        LIKE type_file.dat
DEFINE l_yy,l_mm     LIKE type_file.num5
DEFINE l_first_date  LIKE type_file.dat
DEFINE l_last_date   LIKE type_file.dat
DEFINE l_time_value  LIKE type_file.chr1000

    IF (p_mm+p_add_month>0) AND (p_mm+p_add_month<13) THEN #加減月份後落在合理範圍時
       LET l_date = MDY(p_mm+p_add_month,1,p_yy)
       CALL s_mothck(l_date) RETURNING l_first_date,l_last_date
       LET l_time_value = p_yy USING '&&&&',cl_getmsg('anm-156',g_lang),p_mm+p_add_month USING '&&',cl_getmsg('anm-157',g_lang)
    ELSE
       IF (p_mm+p_add_month) <= 0 THEN
          LET l_date = MDY(p_mm+p_add_month+12,1,p_yy-1)
          CALL s_mothck(l_date) RETURNING l_first_date,l_last_date
          LET l_time_value = p_yy-1 USING '&&&&',cl_getmsg('anm-156',g_lang),
                             p_mm+p_add_month+12 USING '&&',cl_getmsg('anm-157',g_lang)
       ELSE
          LET l_date = MDY(p_mm+p_add_month-12,1,p_yy+1)
          CALL s_mothck(l_date) RETURNING l_first_date,l_last_date
          LET l_time_value = p_yy+1 USING '&&&&',cl_getmsg('anm-156',g_lang),
                             p_mm+p_add_month-12 USING '&&',cl_getmsg('anm-157',g_lang)

       END IF
    END IF

    RETURN l_time_value,l_first_date,l_last_date

END FUNCTION

FUNCTION p_gr_fill_list(p_arr)
DEFINE p_level  LIKE type_file.num5
DEFINE p_arr    LIKE type_file.num5
DEFINE l_sql    STRING
DEFINe l_cnt    LIKE type_file.num5

    IF p_arr <=0 THEN RETURN END IF
    CASE g_tree[p_arr].level
      WHEN "1"
         LET l_sql = "SELECT progid,prog_name,createtime,file_size,creator,creator_name,svg_file_name ",
                     "  FROM p_gr_tmp ",
                    # " WHERE ",g_wc, #FUN-C80015 mark
                     " WHERE 1=1",    #FUN-C80015 add
                     "   AND plant ='",g_tree[p_arr].azp01,"'",  
                     " ORDER BY progid,createtime DESC"
                     #DISPLAY "l_sql:",l_sql #FUN-C70095
      WHEN "2"
         CASE g_sel
            WHEN "1" #日期LEVEL2
               LET l_sql = "SELECT progid,prog_name,createtime,file_size,creator,creator_name,svg_file_name ",
                           "  FROM p_gr_tmp ",
                           # " WHERE ",g_wc, #FUN-C80015 mark
                           " WHERE 1=1",    #FUN-C80015 add
                           "   AND plant ='",g_tree[p_arr].azp01,"'", 
                           "   AND file_date BETWEEN '",g_tree[p_arr].bdate,"' AND '",g_tree[p_arr].edate,"'",
                           " ORDER BY progid,createtime DESC"
            WHEN "2" #模組LEVEL2
               LET l_sql = "SELECT progid,prog_name,createtime,file_size,creator,creator_name,svg_file_name ",
                           "  FROM p_gr_tmp ",
                           # " WHERE ",g_wc, #FUN-C80015 mark
                           " WHERE 1=1",    #FUN-C80015 add
                           "   AND plant ='",g_tree[p_arr].azp01,"'", 
                           "   AND module_id = '",g_tree[p_arr].values,"'",
                           " ORDER BY progid,createtime DESC"
            WHEN "3" #權限類別LEVEL2
               LET l_sql = "SELECT progid,prog_name,createtime,file_size,creator,creator_name,svg_file_name ",
                           "  FROM p_gr_tmp ",
                           # " WHERE ",g_wc, #FUN-C80015 mark
                           " WHERE 1=1",    #FUN-C80015 add
                           "   AND plant ='",g_tree[p_arr].azp01,"'", 
                           "   AND classid = '",g_tree[p_arr].values,"'",
                           " ORDER BY progid,createtime DESC"
            WHEN "4" #使用者LEVEL2
               LET l_sql = "SELECT progid,prog_name,createtime,file_size,creator,creator_name,svg_file_name ",
                           "  FROM p_gr_tmp ",
                           # " WHERE ",g_wc, #FUN-C80015 mark
                           " WHERE 1=1",    #FUN-C80015 add
                           "   AND plant ='",g_tree[p_arr].azp01,"'", 
                           "   AND creator = '",g_tree[p_arr].values,"'",
                           " ORDER BY progid,createtime DESC"
  
         END CASE

      WHEN "3" 
         LET l_sql = "SELECT progid,prog_name,createtime,file_size,creator,creator_name,svg_file_name ",
                     "  FROM p_gr_tmp ",
                           # " WHERE ",g_wc, #FUN-C80015 mark
                           " WHERE 1=1",    #FUN-C80015 add
                     "   AND plant ='",g_tree[p_arr].azp01,"'", 
                     "   AND progid = '",g_tree[p_arr].values,"'",
                     " ORDER BY progid,createtime DESC"
    END CASE

    PREPARE p_gr_fill_list_pr FROM l_sql
    DECLARE p_gr_fill_list_cs CURSOR FOR p_gr_fill_list_pr
  
    CALL g_list.clear()
    LET l_cnt = 1
    FOREACH p_gr_fill_list_cs INTO g_list[l_cnt].*
        IF STATUS THEN CALL cl_err('fill list:',STATUS,1) EXIT FOREACH END IF        
        LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_list.deleteElement(l_cnt)
    LET g_rec_b = l_cnt - 1
   
END FUNCTION

FUNCTION p_gr_list_treename(p_key1)
DEFINE p_key1  LIKE type_file.chr1000
DEFINE l_name  LIKE type_file.chr1000
DEFINE l_desc  LIKE type_file.chr1000

   CASE g_sel
     WHEN "2" #模組(gao_file/gaz_file)
       LET l_desc = p_gr_list_prog_name(p_key1)
     WHEN "3" #權限類別(zw_file)
       LET l_desc = p_gr_list_class_name(p_key1)
     WHEN "4" #使用者(zx_file)
       LET l_desc = p_gr_list_creator_name(p_key1)
   END CASE

   LET l_desc = l_desc CLIPPED,"(",p_key1,")"
   RETURN l_desc

END FUNCTION

FUNCTION p_gr_list_class_name(p_zw01)
DEFINE p_zw01  LIKE zw_file.zw01
DEFINE l_zw02  LIKE zw_file.zw02

    LET l_zw02 = NULL
    SELECT zw02 INTO l_zw02
      FROM zw_file
     WHERE zw01 = p_zw01

    RETURN l_zw02

END FUNCTION

FUNCTION p_gr_list_class(p_zx01)
DEFINE p_zx01    LIKE zx_file.zx01
DEFINE l_zx04    LIKE zx_file.zx04

    LET l_zx04 = NULL
    SELECT zx04 INTO l_zx04 FROM zx_file
     WHERE zx01 = p_zx01
    RETURN l_zx04

END FUNCTION

FUNCTION p_gr_list_prog_name(p_prog_id)
DEFINE p_prog_id  LIKE zz_file.zz01
DEFINE l_gaz03    LIKE gaz_file.gaz03

   LET l_gaz03 = NULL
   LET p_prog_id = DOWNSHIFT(p_prog_id)
   SELECT gaz03 INTO l_gaz03 
     FROM gaz_file
    WHERE gaz01 = p_prog_id
      AND gaz02 = g_lang
   
   RETURN l_gaz03

END FUNCTION

FUNCTION p_gr_list_creator_name(p_creator_id)
DEFINE p_creator_id   LIKE zx_file.zx01
DEFINE l_zx02         LIKE zx_file.zx02
   
    LET l_zx02 = NULL
    SELECT zx02 INTO l_zx02 
      FROM zx_file
     WHERE zx01 = p_creator_id
    
    RETURN l_zx02

END FUNCTION


#FUN-C70103 --START--
FUNCTION p_gr_list_view(svg_name)
   DEFINE svg_name        STRING
   DEFINE svg_server_path STRING
   DEFINE svg_client_path STRING
   DEFINE ret_status      STRING 
   DEFINE gdc_path        STRING
   DEFINE l_execute_str   STRING 
   DEFINE l_msg           STRING  #FUN-C80080 add
  

    LET ret_status = NULL 
    LET svg_client_path = "C:\\tiptop\\",svg_name
    LET svg_server_path = os.path.join(FGL_GETENV("TEMPDIR"),svg_name)

    LET status = cl_download_file(svg_server_path, svg_client_path)
    IF status THEN
 
       CALL ui.interface.frontcall("standard", "feinfo", "fepath", gdc_path)
       DISPLAY "gdc_path:", gdc_path     

       LET l_execute_str=cl_replace_str(gdc_path,"/","\\")
       LET l_execute_str=l_execute_str,"\\reportviewer.exe -f c:\\tiptop\\",svg_name
       CALL ui.Interface.frontcall("standard","execute",[l_execute_str,1],ret_status)
    ELSE         
       ##FUN-C80028 add-start--
       LET l_msg= cl_getmsg_parm("aoo-042", g_lang, svg_name),"或",cl_getmsg_parm("azz1246", g_lang, "") 
       CALL cl_err(l_msg,"!",-1)
       ##FUN-C80028 add-end-- 
    END IF

END FUNCTION
#FUN-C70103 ---END--

