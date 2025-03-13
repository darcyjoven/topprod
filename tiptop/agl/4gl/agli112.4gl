# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli112.4gl
# Descriptions...: 部門層級維護
# Date & Author..: 96/08/26 By Melody
# Modify.........: No:MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No:MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No:FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: NO.MOD-590002 05/09/06 By will m_gem02長度加大
# Modify.........: No:FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No:FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No:FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No:FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:TQC-750022 07/05/09 By Lynn 打印時,"FROM:"位置在報表名之上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:FUN-760085 07/07/31 By sherry  報表改由Crystal Report輸出
# Modify.........: No:FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:FUN-840198 08/06/17 By sherry  建議單身輸入時可以自動產生,簡化輸入 (可參考科目拒絕部門輸入方式)
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:TQC-940122 09/04/21 By Sarah 產生CR Temptable的g_sql,最後多一個","
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0002 09/10/02 By tsai_yen 1.部門層級加Tree的應用 2.檢查是否為無窮迴圈
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30120 10/04/06 By tommas 上下筆時,tree的focus要同步移動
# Modify.........: No:MOD-A10117 10/04/08 By wujie 單身部門只能對應一個上層部門
# Modify.........: No:FUN-A50010 10/05/05 By lixia 單擊樹狀節點，且按下按钮後，將此節點的部門資料加到右方的單身中
# Modify.........: No:TQC-A60039 10/06/17 By sunchenxu tree功能修改
# Modify.........: No:FUN-B40024 11/04/13 By jason 新增部門層級結構表
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_abd01         LIKE abd_file.abd01,
    g_abd01_t       LIKE abd_file.abd01,
    g_abd01_o       LIKE abd_file.abd01,
    #g_abd_rowid     LIKE type_file.num10,       #ROWID    #No.FUN-680098 INT # saki 20070821 rowid chr18 -> num10 #FUN-9A0002 mark
    g_abd           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        abd02       LIKE abd_file.abd02,
        gem02       LIKE gem_file.gem02
                    END RECORD,
    g_abd_t         RECORD                       #程式變數 (舊值)
        abd02       LIKE abd_file.abd02,
        gem02       LIKE gem_file.gem02
                    END RECORD,
    m_gem02         LIKE gem_file.gem02,         #No.MOD-590002            #No.FUN-680098 CHAR(40)
    i               LIKE type_file.num5,         #No.FUN-680098   SMALLINT
    j               LIKE type_file.num5,         #No.FUN-760085
    g_wc,g_sql,g_wc2    STRING,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680098  SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680098  SMALLINT

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680098  CHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680098 SMALLINT
#No:FUN-760085---Begin
DEFINE   g_str           STRING
DEFINE   l_sql           STRING
DEFINE   l_table         STRING
#No:FUN-760085---End
###FUN-9A0002 START ###
DEFINE g_wc_o            STRING                #g_wc舊值備份   #dxfwo  mark
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey1       STRING,
          treekey2       STRING
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE g_abd01_a         DYNAMIC ARRAY OF RECORD 
             abd01       LIKE abd_file.abd01
             END RECORD
DEFINE g_abd_del    DYNAMIC ARRAY OF RECORD      #刪除前的暫存檔，將於save之後，統一刪除
             abd02       LIKE abd_file.abd02
                      END RECORD   
###FUN-9A0002 END ###

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680098   SMALLINT

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,                     #輸入的方式: 不打轉
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   #No:FUN-760085---Begin
   LET g_sql = "abd01.abd_file.abd01,",
               "abd02_1.abd_file.abd02,",
               "abd02_2.abd_file.abd02,",
               "abd02_3.abd_file.abd02,",
               "gem02.gem_file.gem02,",
               "gem02_1.gem_file.gem02,",
               "gem02_2.gem_file.gem02,",
               "gem02_3.gem_file.gem02"  #TQC-940122 mod

   LET l_table = cl_prt_temptable('agli112',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?) "

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #NO:FUN-760085---End

    LET i=0
    LET g_abd01_t = NULL
    LET p_row = 4 LET p_col = 12
    OPEN WINDOW i112_w AT p_row,p_col WITH FORM "agl/42f/agli112"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

    CALL cl_ui_init()

    LET g_wc = '1=1'             #No:FUN-840198
    LET g_tree_reload = "N"      #tree是否要重新整理 Y/N  #FUN-9A0002
    LET g_tree_b = "N"           #tree是否進入單身 Y/N    #FUN-9A0002
    LET g_tree_focus_idx = 0     #focus節點index       #FUN-9A0002

    CALL i112_menu()
    CLOSE FORM i112_w                      #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#QBE 查詢資料
FUNCTION i112_cs(p_idx)    #FUN-9A0002 加參數p_idx  #dxfwo  mark 不傳 p_idx
#FUNCTION i112_cs()          #dxfwo  mark 不傳 p_idx
   DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-9A0002
   DEFINE l_wc   STRING                #雙按Tree的節點時的查詢條件 #FUN-9A0002
   DEFINE l_sql1 LIKE type_file.num5   #FUN-A50010
   DEFINE l_i                LIKE type_file.num5
   ###FUN-9A0002 START ###
  #dxfwo mark --begin
#   LET l_wc = NULL
   IF p_idx > 0 THEN
      #IF g_tree_b = "N" THEN
         LET l_wc = g_wc_o             #還原QBE的查詢條件
     # ELSE
         #IF g_tree[p_idx].level = 1 THEN
          #  LET l_wc = g_wc_o
         #ELSE
            #IF g_tree[p_idx].has_children THEN
            #  LET l_wc = "abd01='",g_tree[p_idx].treekey2 CLIPPED,"'"
            #ELSE
            #    LET l_wc = "abd01='",g_tree[p_idx].treekey1 CLIPPED,"'",
            #               " AND abd02='",g_tree[p_idx].treekey2 CLIPPED,"'"
            #    LET l_wc = "abd01='",g_tree[p_idx].treekey1 CLIPPED,"'"   #FUN-A50010
            #END IF
         #END IF
      #END IF
   END IF
  #dxfwo mark --end
   ###FUN-9A0002 END ###

   CLEAR FORM                             #清除畫面
   CALL g_abd.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

   INITIALIZE g_abd01 TO NULL    #No.FUN-750051

  IF p_idx = 0 THEN   #FUN-9A0002  #dxfwo  mark
      CONSTRUCT g_wc ON abd01,abd02 FROM abd01,s_abd[1].abd02  #螢幕上取條件
                #No:FUN-580031 --start--     HCN
                BEFORE CONSTRUCT
                   CALL cl_qbe_init()
                #No:FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(abd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO abd01
                 NEXT FIELD abd01
            WHEN INFIELD(abd02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO abd02
                 NEXT FIELD abd02
            OTHERWISE EXIT CASE
         END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121

         #No:FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select()
            ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 --end--       HCN
      END CONSTRUCT
   ###FUN-9A0002 START ###      

   ELSE      
      LET g_wc = l_wc CLIPPED
   END IF


   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abduser', 'abdgrup') #FUN-980030
   IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
      LET g_wc_o = g_wc CLIPPED
   END IF

   ###FUN-9A0002 END ###   

   IF INT_FLAG THEN RETURN END IF
   IF cl_null(g_wc) THEN
      LET g_wc="1=1"
   END IF

#    IF g_wc=" 1=1"  THEN 
#       LET g_sql= "SELECT DISTINCT abd01 FROM abd_file ",    
#                  " WHERE ", g_wc CLIPPED,               
#                  " AND  abd01 NOT IN (SELECT abd02 FROM abd_file)",
#                  " ORDER BY abd01"
#    ELSE   

      LET g_sql= "SELECT DISTINCT abd01 FROM abd_file ", 
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY abd01"

#  END IF 

   PREPARE i112_prepare FROM g_sql        #預備一下
   DECLARE i112_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i112_prepare
   LET l_i = 1
   PREPARE i112_prepare1 FROM g_sql
   DECLARE i112_bcs1 CURSOR FOR i112_prepare1

   #FUN-A50010--------start------    
   #IF  p_idx > 0 THEN
   #   IF g_tree[p_idx].level > 1 AND g_tree[p_idx].has_children THEN
   #      LET g_sql="SELECT COUNT(DISTINCT abd01)  ",
   #                 " FROM abd_file WHERE  ", g_wc CLIPPED
   #   ELSE
   #     IF g_tree[p_idx].level <3 THEN  
   #         LET g_sql="SELECT COUNT(DISTINCT abd01)  ",
   #                    " FROM abd_file WHERE abd01 NOT IN(SELECT abd02 FROM abd_file) AND ", g_wc CLIPPED
   #    ELSE
            LET g_sql="SELECT COUNT(DISTINCT abd01)  ",
                       " FROM abd_file WHERE  ", g_wc CLIPPED," ORDER BY abd01" 
                      
   #     END IF    
   #   END IF        
  #ELSE
   #   LET g_sql="SELECT COUNT(DISTINCT abd01)  ",
   #              " FROM abd_file WHERE abd01 NOT IN(SELECT abd02 FROM abd_file) AND ", g_wc CLIPPED    
  # END IF 
   #FUN-A50010--------start------   
   PREPARE i112_precount FROM g_sql
   DECLARE i112_count CURSOR FOR i112_precount
END FUNCTION

FUNCTION i112_menu()
   ###FUN-9A0002 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   ###FUN-9A0002 END ###
   DEFINE l_act_accept       LIKE type_file.chr1  #TQC-C30136 add 

   WHILE TRUE
      #CALL i112_bp("G")   #FUN-9A0002 mark

      ###FUN-9A0002 START ###
      #FUN-D30032--add--str--
      IF g_action_choice = "detail" THEN 
         IF cl_chk_act_auth() THEN
            CALL i112_b()
            IF g_action_choice = "detail" THEN 
               CONTINUE WHILE
            END IF 
         END IF
      END IF  
      #FUN-D30032--add--end--
     
      LET g_action_choice = " "
      #CALL cl_set_act_visible("accept,cancel", FALSE)
      CALL cl_set_act_visible("accept,cancel,save", FALSE) # FUN-A50010 
      CALL cl_set_act_visible("delete_2", FALSE)
      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               LET l_act_accept = TRUE #TQC-C30136 add
               #重算g_curs_index，按上下筆按鈕才會正確
               #因為double click tree node後,focus tree的節點會改變
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF

               #以最上層的id當作單頭的g_curs_index
               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               CALL i112_jump() RETURNING g_curs_index
               CALL cl_navigator_setting(g_curs_index, g_row_count)

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 
               CALL DIALOG.setSelectionMode( "tree", 1 )  # FUN-A50010
               CALL cl_set_act_visible("addchild",TRUE)   # FUN-A50010
               
         #TQC-C30136--mark--str--
         #   #double click tree node
         #   ON ACTION accept     
         #      LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
         #      #有子節點就focus在此，沒有子節點就focus在它的父節點
         #      IF g_tree[l_tree_arr_curr].has_children THEN
         #         LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
         #      ELSE
         #         CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
         #         IF l_i > 1 THEN
         #            CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
         #         END IF
         #         CALL i112_tree_idxbypath()   #依tree path指定focus節點
         #      END IF
         #
         #      LET g_tree_b = "Y"             #tree是否進入單身 Y/N
         #      #CALL i112_q(l_tree_arr_curr)          #dxfwo  mark 
         #      CALL i112_fetch('T',l_tree_arr_curr)  # dxfwo
         #TQC-C30136--mark--    

            #NO.FUN-A50010 --start--   
            ON ACTION addchild
               CALL cl_set_act_visible("save,cancel", TRUE)
               CALL i112_add_sub_b(DIALOG)
            #NO.FUN-A50010 --end--  
            
         END DISPLAY


         DISPLAY ARRAY g_abd TO s_abd.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               LET l_act_accept = FALSE #TQC-C30136 add
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               CALL cl_set_act_visible("delete_2",TRUE) #dxfwo add   

           ON ACTION delete_2
              CALL cl_set_act_visible("delete_2",TRUE)
              LET l_wc = ARR_CURR()
              LET g_action_choice="delete_2"
              EXIT DIALOG

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

            &include "qry_string.4gl"
         END DISPLAY

         BEFORE DIALOG
            #No.FUN-A30120 add by tommas   判斷是否要focus到tree的正確row
            CALL  i112_tree_idxbykey()
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")                   #No.FUN-A30120 add by tommas   利用NEXT FIELD達到focus另一個table
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A30120 add by tommas   指定tree要focus的row
            END IF

         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION delete
            LET g_action_choice="delete"
            EXIT DIALOG

         ON ACTION first
            CALL i112_fetch('F',0)      #FUN-9A0002 加參數p_idx
            CALL i112_tree_idxbykey()   #No.FUN-A30120
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DIALOG

         ON ACTION previous
            CALL i112_fetch('P',0)      #FUN-9A0002 加參數p_idx
            CALL i112_tree_idxbykey()   #No.FUN-A30120
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
                ACCEPT DIALOG

         ON ACTION jump
            CALL i112_fetch('/',0)      #FUN-9A0002 加參數p_idx
            CALL i112_tree_idxbykey()   #No.FUN-A30120
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
                ACCEPT DIALOG

         ON ACTION next
            CALL i112_fetch('N',0)      #FUN-9A0002 加參數p_idx
            CALL i112_tree_idxbykey()   #No.FUN-A30120
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
                ACCEPT DIALOG

         ON ACTION last
            CALL i112_fetch('L',0)      #FUN-9A0002 加參數p_idx
            CALL i112_tree_idxbykey()   #No.FUN-A30120
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
              ACCEPT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
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

         ON ACTION accept
          #TQC-C30136--add--str
            IF NOT cl_null(l_act_accept) AND l_act_accept THEN
            #double click tree node
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL i112_tree_idxbypath()   #依tree path指定focus節點
               END IF

               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
#              CALL i112_q(l_tree_arr_curr)          #dxfwo  mark 
               CALL i112_fetch('T',l_tree_arr_curr)  # dxfwo
            ELSE
          #TQC-C30136--add--end--
               LET g_action_choice="detail"
               LET l_ac = ARR_CURR()
               EXIT DIALOG
            END IF #TQC-C30136  add

         #ON ACTION cancel
         #   LET INT_FLAG=FALSE
         #   LET g_action_choice="exit"
         #   EXIT DIALOG

         #NO.FUN-A50010 --start--         
         ON ACTION save
            LET g_action_choice="save"
            EXIT DIALOG 
            
         ON ACTION cancel
            LET g_action_choice="cancel"
            EXIT DIALOG
         #NO.FUN-A50010 --end--
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

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
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i112_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
              CALL i112_q(0)           #FUN-9A0002 加參數p_idx
#               CALL i112_q()            #FUN-9A0002 加參數p_idx     #dxfwo 需要傳p_idx
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i112_r()
            END IF

         WHEN "delete_2"
            IF cl_chk_act_auth() THEN
               CALL i112_r1(l_wc)
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i112_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i112_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            #NO.FUN-B40024  --start--
            MENU "" ATTRIBUTE(STYLE="popup")
                ON ACTION level_r112
                    IF cl_chk_act_auth() THEN
                        CALL i112_out()
                    END IF
                ON ACTION structure_r112
                    IF cl_chk_act_auth() THEN
                        CALL i112_out2()
                    END IF
            END MENU
            #NO.FUN-B40024  --end--            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_abd01 IS NOT NULL THEN
                  LET g_doc.column1 = "abd01"
                  LET g_doc.value1 = g_abd01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abd),'','')
            END IF

         #NO.FUN-A50010 --start--
         WHEN "cancel"
#           CALL i112_b_fill(g_wc_o)  # dxfwo  mark
            CALL i112_b_fill(g_wc)    # dxfwo  
            CALL cl_set_act_visible("save,cancel",FALSE)
         WHEN "save"
            CALL i112_save()
            CALL i112_show()
#           CALL i112_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #dxfwo  mark
            CALL i112_tree_fill(g_wc ,NULL,0,NULL,NULL,NULL)    #dxfwo   
            CALL i112_tree_open(g_tree_focus_idx)             #®i _   c
            CALL cl_set_act_visible("save,cancel",FALSE)
         #NO.FUN-A50010 --end--  
      END CASE
   END WHILE
END FUNCTION


FUNCTION i112_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_abd.clear()
    INITIALIZE g_abd01 LIKE abd_file.abd01         #DEFAULT 設定
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i112_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_abd01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_abd01 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL g_abd.clear()
        LET g_rec_b = 0
        CALL i112_g()     #FUN-840198
        CALL i112_b()                              #輸入單身
        #SELECT ROWID INTO g_abd_rowid FROM abd_file  #FUN-9A0002 mark
        SELECT abd01 INTO g_abd01 FROM abd_file       #FUN-9A0002
            WHERE abd01 = g_abd01
        LET g_abd01_t = g_abd01                    #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i112_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680098 CHAR(1)
    l_n1,l_n        LIKE type_file.num5,          #No.FUN-680098 SMALLINT
    p_cmd           LIKE type_file.chr1           #a:輸入 u:更改     #No.FUN-680098  CHAR(1)

    DISPLAY g_abd01 TO abd01
    CALL cl_set_head_visible("","YES")            #No.FUN-6B0029

    INPUT  g_abd01 FROM abd01 #WITHOUT DEFAULTS

        AFTER FIELD abd01
            IF NOT cl_null(g_abd01) THEN
               IF g_abd01 != g_abd01_t OR cl_null(g_abd01_t) THEN
                  SELECT gem02 INTO m_gem02 FROM gem_file
                   WHERE gem01 = g_abd01 AND gemacti='Y'
                  IF STATUS=100 THEN   #資料不存在
#                    CALL cl_err(g_abd01,100,0)   #No.FUN-660123
                     CALL cl_err3("sel","gem_file",g_abd01,"",100,"","",1)  #No.FUN-660123
                     LET g_abd01 = g_abd01_t
                     DISPLAY g_abd01 TO abd01
                     NEXT FIELD abd01
                  END IF
               END IF
               DISPLAY m_gem02 TO FORMONLY.gem02n
               SELECT COUNT(*) INTO l_n FROM abd_file
                  WHERE abd01=g_abd01
               IF l_n>0 THEN
                  CALL cl_err(g_abd01,-239,0)
                  NEXT FIELD abd01
               END IF
               LET g_abd01_o = g_abd01
            END IF

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(abd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_abd01
                 CALL cl_create_qry() RETURNING g_abd01
#                 CALL FGL_DIALOG_SETBUFFER( g_abd01 )
                 DISPLAY g_abd01 TO abd01
                 NEXT FIELD abd01
              OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


    END INPUT
END FUNCTION

#Query 查詢
FUNCTION i112_q(p_idx)      #FUN-9A0002 加參數p_idx #dxfwo  mark
#FUNCTION i112_q()            #dxfwo  
    DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index  #FUN-9A0002 #dxfwo  mark
    DEFINE li_i   LIKE type_file.num5    #dxfwo add
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_abd01 TO NULL                 #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_abd.clear()
    CALL i112_cs(p_idx)                   #取得查詢條件   #FUN-9A0002傳入參數p_idx #dxfwo  mark
#    CALL i112_cs()                        #dxfwo   
    IF INT_FLAG THEN                      #使用者不玩了
        LET INT_FLAG = 0
        CALL g_tree.clear()
        RETURN
    END IF
    OPEN i112_bcs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                 #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_abd01 TO NULL
    ELSE
        #dxfwo add--begin
        CALL g_abd01_a.clear()
        LET li_i = 1
        FOREACH i112_bcs1  INTO g_abd01_a[li_i].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                  EXIT FOREACH
              END IF 
              LET li_i = li_i + 1
        END FOREACH
        CALL g_abd01_a.deleteElement(li_i)          
        #dxfwo add--end
        #要在g_row_count取得之後CALL i112_fetch()，因為i112_fetch()裡面有用到g_row_count
        #CALL i112_fetch('F')  #FUN-9A0002 mark
        OPEN i112_count
        FETCH i112_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        ###FUN-9A0002 START ###
       #dxfwo modify 不判斷 p_idx,只保留原package程式段
        IF p_idx = 0 THEN
           CALL i112_fetch('F',0)        #讀出TEMP第一筆並顯示
           LET g_tree_focus_idx= 0    #FUN-A50010
           CALL i112_tree_fill(g_wc,NULL,0,NULL,NULL,NULL)     #Tree填充   #dxfwo
#          CALL i112_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #Tree填充   #dxfwo
        ELSE
#           #Tree的最上層是QBE結果，才可以指定jump
          IF g_tree[p_idx].level = 1 THEN
              CALL i112_fetch('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
           ELSE
              CALL i112_fetch('F',p_idx)
           END IF
        END IF
        #dxfwo -end
        ###FUN-9A0002 END ###
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i112_fetch(p_flag,p_idx)   #FUN-9A0002 加參數p_idx
    DEFINE
       p_flag        LIKE type_file.chr1,    #處理方式      #No.FUN-680098 CHAR(1)
       l_abso        LIKE type_file.num10    #絕對的筆數    #No.FUN-680098 INTEGER
    DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  #FUN-9A0002
    DEFINE l_i       LIKE type_file.num5     #FUN-9A0002
    DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 #FUN-9A0002

    MESSAGE ""
    ##FUN-9A0002 START ###
    IF p_flag = 'T' AND p_idx <= 0 THEN      #Tree index錯誤就改讀取第一筆資料
       LET p_flag = 'F'
    END IF
    ##FUN-9A0002 END ###

    CASE p_flag
        WHEN 'N' FETCH NEXT     i112_bcs INTO g_abd01
        WHEN 'P' FETCH PREVIOUS i112_bcs INTO g_abd01
        WHEN 'F' FETCH FIRST    i112_bcs INTO g_abd01
        WHEN 'L' FETCH LAST     i112_bcs INTO g_abd01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
                      #CONTINUE PROMPT

                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121

                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121

                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i112_bcs INTO g_abd01
            LET mi_no_ask = FALSE

        ##FUN-9A0002 START ###
        #Tree雙點指定筆
        WHEN 'T'
           #讀出TEMP中，雙點Tree的指定節點並顯示
           #dxfwo modify
           CALL i112_jump() RETURNING l_jump
           LET g_jump = l_jump
           FETCH ABSOLUTE g_jump i112_bcs  INTO g_abd01
            #dxfwo end 
    END CASE

    #SELECT unique abd01 FROM abd_file WHERE abd01 = g_abd01   #FUN-9A0002 mark
    SELECT DISTINCT abd01 FROM abd_file WHERE abd01 = g_abd01  #FUN-9A0002
    IF SQLCA.sqlcode THEN                         #有麻煩
       #CALL cl_err(g_abd01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel","abd_file",g_abd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        INITIALIZE g_abd01 TO NULL  #TQC-6B0105
    ELSE
        ##FUN-A50010 START  by suncx1###
        IF p_idx > 0 THEN
           IF g_tree[p_idx].has_children THEN
           ELSE
              LET g_abd01 = g_tree[p_idx].treekey2
           END IF
        END IF
        ##FUN-A50010 END ###
        CALL i112_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
           WHEN 'T' LET g_curs_index = g_jump   #dxfwo add
        END CASE

        CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i112_show()

    DISPLAY g_abd01 TO abd01           #單頭
    SELECT gem02 INTO m_gem02 FROM gem_file WHERE gem01=g_abd01
    IF STATUS=100 THEN 
       LET m_gem02='' 
    END IF
    DISPLAY m_gem02 TO FORMONLY.gem02n
     CALL cl_set_act_visible("delete_2",FALSE)
    CALL i112_b_fill(g_wc)             #單身

    CALL cl_show_fld_cont()            #No:FUN-550037 hmf

END FUNCTION

FUNCTION i112_r()
    DEFINE l_chr    LIKE type_file.chr1          #No.FUN-680098 CHAR(1)
    ###FUN-9A0002 START ###
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_prev   STRING  #前一個節點
    DEFINE l_next   STRING  #後一個節點
    ###FUN-9A0002 END ###

    IF s_shut(0) THEN RETURN END IF
    IF g_abd01 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    BEGIN WORK
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "abd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_abd01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        
        ###FUN-9A0002 START ###       
        #在Tree節點刪除之前先找出刪除後要focus的節點path
        CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
        #刪除子節點後，focus在它的父節點
        IF l_i > 1 THEN
           CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
        #刪除的是最上層節點，focus在它的後一個節點或前一個節點
        ELSE
           CALL i112_tree_idxbypath()               #依tree path指定focus節點
           LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
           LET l_i = l_i + 1
           LET l_next = l_i
           
           LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
           LET l_i = l_i - 1
           LET l_prev = l_i
           
           FOR l_i = g_tree.getlength() TO 1 STEP -1
              IF g_tree[l_i].id = l_next THEN       #後一個節點
                    LET g_tree_focus_path = g_tree[l_i].path
                    EXIT FOR
              END IF
              IF g_tree[l_i].id = l_prev THEN       #前一個節點
                    LET g_tree_focus_path = g_tree[l_i].path
                    EXIT FOR
              END IF
           END FOR
        END IF
        ###FUN-9A0002 END ###
        
        DELETE FROM abd_file WHERE abd01=g_abd01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_abd01,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("del","abd_file",g_abd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL g_abd.clear()
           CALL g_abd.clear()
                     
           CALL i112_tree_update() #Tree 資料有異動 #FUN-9A0002           
           ###FUN-9A0002 mark STRAT ###
           #  OPEN i112_count
           #  FETCH i112_count INTO g_row_count
           #  DISPLAY g_row_count TO FORMONLY.cnt
           #  
           #  ###FUN-9A0002 mark STRAT ###
           #  OPEN i112_bcs
           #  IF g_curs_index = g_row_count + 1 THEN
           #     LET g_jump = g_row_count
           #     CALL i112_fetch('L')
           #  ELSE
           #     LET g_jump = g_curs_index
           #     LET mi_no_ask = TRUE
           #     CALL i112_fetch('/')
           #  END IF
           ###FUN-9A0002 mark END ###
        END IF
    END IF
    COMMIT WORK
END FUNCTION

FUNCTION i112_r1(p_idx) 
    DEFINE p_idx    LIKE type_file.num5
    DEFINE l_chr    LIKE type_file.chr1          #No.FUN-680098 CHAR(1)
    ###FUN-9A0002 START ###
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_prev   STRING  #前一個節點
    DEFINE l_next   STRING  #後一個節點
    ###FUN-9A0002 END ###

    IF p_idx == 0 THEN 
           CALL cl_set_act_visible("delete_2", FALSE)
    ELSE
        CALL g_abd_del.appendelement()
    LET g_abd_del[g_abd_del.getLength()].abd02 = g_abd[p_idx].abd02     #將要刪除的先暫存

    IF s_shut(0) THEN RETURN END IF
    IF g_abd01 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    BEGIN WORK
    IF (cl_confirm("aoo-889")) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "abd02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_abd01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        
        ###FUN-9A0002 START ###       
        #在Tree節點刪除之前先找出刪除後要focus的節點path
        #CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
        ##刪除子節點後，focus在它的父節點
        #IF l_i > 1 THEN
        #   CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
        ##刪除的是最上層節點，focus在它的後一個節點或前一個節點
        #ELSE
        #   CALL i112_tree_idxbypath()               #依tree path指定focus節點
        #   LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
        #   LET l_i = l_i + 1
        #   LET l_next = l_i
        #   
        #   LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
        #   LET l_i = l_i - 1
        #   LET l_prev = l_i
        #   
        #   FOR l_i = g_tree.getlength() TO 1 STEP -1
        #      IF g_tree[l_i].id = l_next THEN       #後一個節點
        #            LET g_tree_focus_path = g_tree[l_i].path
        #            EXIT FOR
        #      END IF
        #      IF g_tree[l_i].id = l_prev THEN       #前一個節點
        #            LET g_tree_focus_path = g_tree[l_i].path
        #            EXIT FOR
        #      END IF
        #   END FOR
        #END IF
        ###FUN-9A0002 END ###
        
        DELETE FROM abd_file WHERE abd02 = g_abd[p_idx].abd02 AND abd01 = g_abd01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","abd_file",g_abd[p_idx].abd02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL g_abd.clear()
           CALL g_abd_del.clear()
                     
           CALL i112_tree_update() #Tree 資料有異動 #FUN-9A0002           
        END IF
      END IF
    END IF  
    COMMIT WORK
END FUNCTION

#No:FUN-840198---Begin
FUNCTION i112_g()
   DEFINE l_gem01     LIKE abd_file.abd02
  #DEFINE l_wc,l_sql  LIKE type_file.chr1000
   DEFINE l_wc,l_sql  STRING               #NO.FUN-910082
   DEFINE l_wc2       STRING               #FUN-9A0002
   DEFINE l_loop      LIKE type_file.chr1  #是否為無窮迴圈Y/N   #FUN-9A0002

   OPEN WINDOW i112_g_w AT 8,20
     WITH FORM "agl/42f/agli112g"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli112g")

   CONSTRUCT BY NAME l_wc ON gem01


      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(gem01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO gem01
              NEXT FIELD gem01
           OTHERWISE
              EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121

       ON ACTION qbe_select
          CALL cl_qbe_select()

       ON ACTION qbe_save
          CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN
      CLOSE WINDOW i112_g_w
      LET INT_FLAG = 0
      RETURN
   END IF

   IF NOT cl_sure(16,16) THEN
      CLOSE WINDOW i112_g_w
      RETURN
   END IF

   LET l_sql="SELECT gem01 FROM gem_file",
             " WHERE  gemacti='Y' ",
             "   AND ",l_wc CLIPPED
   PREPARE i112_g_p FROM l_sql
   DECLARE i112_g_c CURSOR FOR i112_g_p

   FOREACH i112_g_c INTO l_gem01
      MESSAGE l_gem01
#No.MOD-A10117 --begin
      SELECT count(*) INTO g_cnt FROM abd_file
       WHERE abd02 = l_gem01
      IF g_cnt > 0 THEN
         CALL cl_err(l_gem01,-239,0)
         CONTINUE FOREACH
      END IF
#No.MOD-A10117 --end
      IF g_abd01 != l_gem01 THEN
         ###FUN-9A0002 START ###
            CALL i112_tree_loop(g_abd01,l_gem01,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
            IF l_loop = "Y" THEN
               CALL cl_err(l_gem01,"agl1000",1)
            ELSE
               IF cl_null(l_wc2) THEN
                  LET l_wc2 = "'",l_gem01,"'"
               ELSE
                  LET l_wc2 = l_wc2, ",'",l_gem01,"'" 
               END IF
            ###FUN-9A0002 END ###
               INSERT INTO abd_file (abd01,abd02,abdoriu,abdorig) VALUES(g_abd01,l_gem01, g_user, g_grup)               #No.FUN-980030 10/01/04  insert columns oriu, orig
            END IF   #FUN-9A0002
      ELSE
         CALL cl_err(l_gem01,'agl-226',0)
      END IF
   END FOREACH
   
   ###FUN-9A0002 START ###
   IF NOT cl_null(l_wc2) THEN
      LET l_wc2 = "abd02 IN (",l_wc2,")"
   ELSE
      LET l_wc2 = "1=1"
   END IF
   ###FUN-9A0002 END ###

   CLOSE WINDOW i112_g_w
   #CALL i112_b_fill(g_wc)  #FUN-9A0002 mark
   CALL i112_b_fill(l_wc2)  #FUN-9A0002 
   DISPLAY ARRAY g_abd TO s_abd.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY

END FUNCTION
#No:FUN-840198---End

#單身
FUNCTION i112_b()
   DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用      #No.FUN-680098    SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否      #No.FUN-680098    CHAR(2)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680098    CHAR(2)
    l_allow_insert  LIKE type_file.num5,      #可新增否        #No.FUN-680098    SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否        #No.FUN-680098    SMALLINT
    DEFINE l_loop   LIKE type_file.chr1       #是否為無窮迴圈Y/N   #FUN-9A0002
    DEFINE l_i      LIKE type_file.num5                         #FUN-9A0002

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql =
        "SELECT abd02 FROM abd_file WHERE abd01= ? AND abd02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i112_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_abd WITHOUT DEFAULTS FROM s_abd.*
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

            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_abd_t.* = g_abd[l_ac].*  #BACKUP
               OPEN i112_bcl USING g_abd01,g_abd_t.abd02
               IF STATUS THEN
                  CALL cl_err("OPEN i112_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i112_bcl INTO g_abd[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_abd_t.abd02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

            IF l_ac <= l_n THEN
               SELECT gem02 INTO g_abd[l_ac].gem02 FROM gem_file
                WHERE gem01 = g_abd[l_ac].abd02
               IF SQLCA.sqlcode THEN LET g_abd[l_ac].gem02 = ' ' END IF
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_abd[l_ac].* TO NULL      #900423
            LET g_abd_t.* = g_abd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD abd02

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            ###FUN-9A0002 START ###
            CALL i112_tree_loop(g_abd01,g_abd[l_ac].abd02,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
            IF l_loop = "Y" THEN
               CALL cl_err(g_abd[l_ac].abd02,"agl1000",1)
               CANCEL INSERT
            ELSE
            ###FUN-9A0002 END ###
               INSERT INTO abd_file(abd01,abd02,abduser,abdgrup,abdmodu,abddate,abdoriu,abdorig)
                             VALUES(g_abd01,g_abd[l_ac].abd02,g_user,
                                    g_grup,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_abd[l_ac].abd02,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("ins","abd_file",g_abd01,g_abd[l_ac].abd02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   CANCEL INSERT
               ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A0002
                   LET g_rec_b = g_rec_b + 1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   MESSAGE 'INSERT O.K'
               END IF
            END IF   #FUN-9A0002


        AFTER FIELD abd02
            IF NOT cl_null(g_abd[l_ac].abd02) THEN
               IF g_abd[l_ac].abd02 = g_abd01 THEN
                  CALL cl_err('','agl-226',0)    #No:8737
                  NEXT FIELD abd02
               END IF

               IF g_abd[l_ac].abd02 != g_abd_t.abd02 OR
                 (g_abd[l_ac].abd02 IS NOT NULL AND g_abd_t.abd02 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM abd_file
#No.MOD-A10117 --begin
                    WHERE abd02 = g_abd[l_ac].abd02
#                   WHERE (abd01 = g_abd01 AND abd02 = g_abd[l_ac].abd02) OR
#                         (abd01 = g_abd01 AND abd02 = g_abd[l_ac].abd02)
#No.MOD-A10117 --end
                   IF l_n > =1 THEN
                      CALL cl_err(g_abd[l_ac].abd02,-239,0)
                      LET g_abd[l_ac].abd02 = g_abd_t.abd02
                      LET g_abd[l_ac].gem02 = g_abd_t.gem02
                      NEXT FIELD abd02
                   ELSE
                      SELECT gem02 INTO g_abd[l_ac].gem02 FROM gem_file
                       WHERE gem01 = g_abd[l_ac].abd02 AND gemacti='Y'
                      IF STATUS=100 THEN   #資料不存在
#                        CALL cl_err(g_abd[l_ac].abd02,100,0)   #No.FUN-660123
                         CALL cl_err3("sel","gem_file", g_abd[l_ac].abd02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                         LET g_abd[l_ac].abd02 = g_abd_t.abd02
                         NEXT FIELD abd02
                      END IF
                   END IF
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_abd_t.abd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

                DELETE FROM abd_file
                 WHERE abd01 = g_abd01 AND abd02 = g_abd[l_ac].abd02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_abd_t.abd02,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","abd_file",g_abd01,g_abd_t.abd02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                   LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A0002
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_abd[l_ac].* = g_abd_t.*
               CLOSE i112_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_abd[l_ac].abd02,-263,1)
               LET g_abd[l_ac].* = g_abd_t.*
            ELSE
               ###FUN-9A0002 START ###
               CALL i112_tree_loop(g_abd01,g_abd[l_ac].abd02,NULL) RETURNING l_loop  #檢查是否為無窮迴圈
               IF l_loop = "Y" THEN
                  CALL cl_err(g_abd[l_ac].abd02,"agl1000",1)
                  LET g_abd[l_ac].* = g_abd_t.*
               ELSE
               ###FUN-9A0002 END ###
                  UPDATE abd_file SET abd02 = g_abd[l_ac].abd02,
                                      abdmodu = g_user,
                                      abddate = g_today
                     WHERE abd01=g_abd01 AND abd02 = g_abd_t.abd02
                  IF SQLCA.sqlcode THEN
                     #CALL cl_err(g_abd[l_ac].abd02,SQLCA.sqlcode,0)   #No.FUN-660123
                     CALL cl_err3("upd","abd_file",g_abd01,g_abd_t.abd02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                     LET g_abd[l_ac].* = g_abd_t.*
                  ELSE
                     LET g_tree_reload = "Y"   #tree是否要重新整理 Y/N   #FUN-9A0002
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                  END IF
               END IF #FUN-9A0002
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #LET g_abd[l_ac].* = g_abd_t.* #FUN-D30032 MARK
               #FUN-D30032--add--begin--
               IF p_cmd='u' THEN
                  LET g_abd[l_ac].* = g_abd_t.*
               ELSE
                  CALL g_abd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               #FUN-D30032--add--end----
               CLOSE i112_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30032 add
            LET g_abd_t.* = g_abd[l_ac].*
            LET g_tree_reload = "Y"
            CLOSE i112_bcl
            COMMIT WORK

#       ON ACTION CONTROLN
#          CALL i112_b_askkey()
#          EXIT INPUT

        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(abd02) AND l_ac > 1 THEN
              LET g_abd[l_ac].* = g_abd[l_ac-1].*
              NEXT FIELD abd02
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(abd02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem"
                   LET g_qryparam.default1 = g_abd[l_ac].abd02
                   CALL cl_create_qry() RETURNING g_abd[l_ac].abd02
#                   CALL FGL_DIALOG_SETBUFFER( g_abd[l_ac].abd02 )
                    DISPLAY BY NAME g_abd[l_ac].abd02      #No:MOD-490344
                   NEXT FIELD abd02
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0029--end

    END INPUT

    CLOSE i112_bcl
    COMMIT WORK

    ###FUN-9A0002 START ###
    #從Tree進來，且單身資料有異動時
#    IF g_tree_b = "Y" AND g_tree_reload = "Y" THEN 
     IF  g_tree_reload = "Y" THEN   #FUN-A50010
       CALL i112_tree_update() #Tree 資料有異動 
       LET g_tree_reload = "N"
    END IF
    ###FUN-9A0002 END ###
END FUNCTION

FUNCTION i112_b_askkey()
DEFINE
    l_wc     LIKE type_file.chr1000     #No.FUN-680098  CHAR(200)

    CLEAR FORM
    CALL g_abd.clear()
    CALL g_abd.clear()

    CONSTRUCT l_wc ON abd02  #螢幕上取條件
       FROM s_abd[1].abd02
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i112_b_fill(l_wc)
END FUNCTION

FUNCTION i112_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc      LIKE type_file.chr1000   #No.FUN-680098 CHAR(200)

   LET g_sql = "SELECT abd02 FROM abd_file ",
               " WHERE abd01 = '",g_abd01,"' AND ",
               p_wc CLIPPED , " ORDER BY abd02"
   PREPARE i112_prepare2 FROM g_sql      #預備一下
   DECLARE abd_cs CURSOR FOR i112_prepare2

   CALL g_abd.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH abd_cs INTO g_abd[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      SELECT gem02 INTO g_abd[g_cnt].gem02 FROM gem_file
       WHERE gem01=g_abd[g_cnt].abd02
      IF SQLCA.sqlcode THEN LET g_abd[g_cnt].gem02='' END IF
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
   END FOREACH
   CALL g_abd.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1

   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

###FUN-9A0002 mark START ###
# FUNCTION i112_bp(p_ud)
#    DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 CHAR(1)
#
#
#    IF p_ud <> "G" OR g_action_choice = "detail" THEN
#       RETURN
#    END IF
#
#    LET g_action_choice = " "
#
#    CALL cl_set_act_visible("accept,cancel", FALSE)
#
#    DISPLAY ARRAY g_abd TO s_abd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#       BEFORE DISPLAY
#          CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#       BEFORE ROW
#          LET l_ac = ARR_CURR()
#       CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#
#       ON ACTION insert
#          LET g_action_choice="insert"
#          EXIT DISPLAY
#       ON ACTION query
#          LET g_action_choice="query"
#          EXIT DISPLAY
#       ON ACTION delete
#          LET g_action_choice="delete"
#          EXIT DISPLAY
#       ON ACTION first
#          CALL i112_fetch('F')
#          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#            IF g_rec_b != 0 THEN
#          CALL fgl_set_arr_curr(1)  ######add in 040505
#            END IF
#            ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#
#       ON ACTION previous
#          CALL i112_fetch('P')
#          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#            IF g_rec_b != 0 THEN
#          CALL fgl_set_arr_curr(1)  ######add in 040505
#            END IF
# 	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#
#       ON ACTION jump
#          CALL i112_fetch('/')
#          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#            IF g_rec_b != 0 THEN
#          CALL fgl_set_arr_curr(1)  ######add in 040505
#            END IF
# 	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#
#       ON ACTION next
#          CALL i112_fetch('N')
#          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#            IF g_rec_b != 0 THEN
#          CALL fgl_set_arr_curr(1)  ######add in 040505
#            END IF
# 	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#
#       ON ACTION last
#          CALL i112_fetch('L')
#          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#            IF g_rec_b != 0 THEN
#          CALL fgl_set_arr_curr(1)  ######add in 040505
#            END IF
# 	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#
#
#       ON ACTION detail
#          LET g_action_choice="detail"
#          LET l_ac = 1
#          EXIT DISPLAY
#       ON ACTION output
#          LET g_action_choice="output"
#          EXIT DISPLAY
#       ON ACTION help
#          LET g_action_choice="help"
#          EXIT DISPLAY
#
#       ON ACTION locale
#          CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
#
#       ON ACTION exit
#          LET g_action_choice="exit"
#          EXIT DISPLAY
#
#       ON ACTION controlg
#          LET g_action_choice="controlg"
#          EXIT DISPLAY
#
#    ON ACTION accept
#       LET g_action_choice="detail"
#       LET l_ac = ARR_CURR()
#       EXIT DISPLAY
#
#    ON ACTION cancel
#              LET INT_FLAG=FALSE 		#MOD-570244	mars
#       LET g_action_choice="exit"
#       EXIT DISPLAY
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE DISPLAY
#
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
#
#
# #@    ON ACTION 相關文件
#        ON ACTION related_document  #No:MOD-470515
#          LET g_action_choice="related_document"
#          EXIT DISPLAY
#
#       ON ACTION exporttoexcel   #No:FUN-4B0010
#          LET g_action_choice = 'exporttoexcel'
#          EXIT DISPLAY
#
#       # No:FUN-530067 --start--
#       AFTER DISPLAY
#          CONTINUE DISPLAY
#       # No:FUN-530067 ---end---
# #No.FUN-6B0029--begin
#       ON ACTION controls
#          CALL cl_set_head_visible("","AUTO")
# #No.FUN-6B0029--end
#
#       #No.FUN-7C0050 add
#       &include "qry_string.4gl"
#    END DISPLAY
#    CALL cl_set_act_visible("accept,cancel", TRUE)
# END FUNCTION
###FUN-9A0002 mark END ###

FUNCTION i112_copy()
DEFINE
    l_abd		RECORD LIKE abd_file.*,
    l_gem02             LIKE gem_file.gem02,
    l_oldno,l_newno	LIKE abd_file.abd01

    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_abd01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

    INPUT l_newno FROM abd01
        AFTER FIELD abd01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM abd_file
                WHERE abd01 = l_newno
               IF g_cnt > 0 THEN
                  CALL cl_err(l_newno,-239,0)
                  NEXT FIELD abd01
               END IF
               SELECT gem02 INTO l_gem02 FROM gem_file
                WHERE gem01 = l_newno AND gemacti ='Y'
               IF STATUS=100 THEN   #資料不存在
#                 CALL cl_err(g_abd01,100,0)   #No.FUN-660123
                  CALL cl_err3("sel","gem_file",l_newno,"",100,"","",1)  #No.FUN-660123
                  LET l_gem02 = '  '
                  DISPLAY l_gem02 TO FORMONLY.gem02n
                  NEXT FIELD abd01
               ELSE
                  DISPLAY l_gem02 TO FORMONLY.gem02n
	       END IF
             END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY g_abd01 TO abd01
        RETURN
    END IF

    DROP TABLE x
    SELECT * FROM abd_file         #單身複製
     WHERE abd01=g_abd01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_abd01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","x",g_abd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
       RETURN
    END IF
    UPDATE x
        SET abd01=l_newno
    INSERT INTO abd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err('abd:',SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","abd_file",l_newno,"",SQLCA.sqlcode,"","abd:",1)  #No.FUN-660123
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'

    LET l_oldno = g_abd01
    #SELECT unique abd01 INTO g_abd01 FROM abd_file WHERE abd01 = l_newno  #FUN-9A0002 mark
    SELECT DISTINCT abd01 INTO g_abd01 FROM abd_file WHERE abd01 = l_newno #FUN-9A0002
    CALL i112_b()
    #SELECT unique abd01 INTO g_abd01 FROM abd_file WHERE abd01 = l_oldno  #FUN-9A0002 mark
    #SELECT DISTINCT abd01 INTO g_abd01 FROM abd_file WHERE abd01 = l_oldno #FUN-9A0002  #FUN-C30027
    #CALL i112_show()  #FUN-C30027
END FUNCTION

FUNCTION i112_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name   #No.FUN-680098 CHAR(20)
        l_za05          LIKE za_file.za05,            #No.FUN-680098  CHAR(40)
        l_chr           LIKE type_file.chr1,          #No.FUN-680098  CHAR(1)
        l_abd           RECORD LIKE abd_file.*
    #No:FUN-760085---Begin    在FUNCTION內使用"l_"定義局部變量,通常計數變量不在全局變量中定義
    DEFINE  i,j         LIKE type_file.num5
    DEFINE  l_gem02     LIKE gem_file.gem02
    DEFINE  l_gem02_1   LIKE gem_file.gem02
    DEFINE  l_gem02_2   LIKE gem_file.gem02
    DEFINE  l_gem02_3   LIKE gem_file.gem02
    DEFINE  l_abd02_1   LIKE abd_file.abd02
    DEFINE  l_abd02_2   LIKE abd_file.abd02
    DEFINE  l_abd02_3   LIKE abd_file.abd02
    DEFINE  l_abd01_t   LIKE abd_file.abd01
    #No:FUN-760085---End
    IF g_wc IS NULL THEN
   #    CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    #CALL cl_outnam('agli112') RETURNING l_name        #No:FUN-760085
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli112'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM abd_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY abd01,abd02"
    PREPARE i112_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i112_co  CURSOR FOR i112_p1

    #No:FUN-760085---Begin
    #START REPORT i112_rep TO l_name
    CALL cl_del_data(l_table)

    LET i=1                         #循環計數,實現每行3筆排列
    LET j=0                         #累加計數,判斷當前FOREACH到的筆數
    INITIALIZE l_abd01_t TO NULL    #初始化分組key舊值
    #No:FUN-760085---End
    FOREACH i112_co INTO l_abd.*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       #No:FUN-760085---Begin
       #OUTPUT TO REPORT i112_rep(l_abd.*)
       IF (cl_null(l_abd01_t) OR l_abd.abd01<>l_abd01_t) THEN   #分組重新排列處理

           IF j>0 AND i<>1 THEN                                 #若上一組最后一行未排滿3筆,
                                                                #則插入上一分組最后一行排列
               EXECUTE insert_prep USING l_abd01_t,l_abd02_1,l_abd02_2,
                                         l_abd02_3,l_gem02,l_gem02_1,l_gem02_2,
                                         l_gem02_3
               INITIALIZE l_abd02_1,l_abd02_2,l_abd02_3,        #每次插入后清空舊值,
                          l_gem02_1,l_gem02_2,l_gem02_3 TO NULL #以防當前筆值為空時使用舊值
           END IF
           LET l_abd01_t = l_abd.abd01
           LET i=1                                              #切換分組時,
           LET j=0                                              #重新計數
       END IF
       SELECT gem02 INTO l_gem02 FROM gem_file
           WHERE gem01 = l_abd.abd01 AND gem05='Y' AND gemacti='Y'
       IF STATUS=100 THEN LET l_gem02='' END IF
       LET j = j+1                                              #組內計數累加
       IF i =1 THEN
          LET l_abd02_1 = l_abd.abd02                           #存儲排列值1
          SELECT gem02 INTO l_gem02_1 FROM gem_file
             WHERE gem01=l_abd.abd02 AND gem05='Y' AND gemacti='Y'
          LET i = i+1                                           #組內循環計數
       ELSE
          IF i=2 THEN
             LET l_abd02_2 = l_abd.abd02                        #存儲排列值2
             SELECT gem02 INTO l_gem02_2 FROM gem_file
                WHERE gem01=l_abd.abd02 AND gem05='Y' AND gemacti='Y'
             LET i = i+1
          ELSE
             IF i=3 THEN                                        #排滿3筆,插入當前排列行
                LET l_abd02_3 = l_abd.abd02                     #存儲排列值3
                LET i = 1
                SELECT gem02 INTO l_gem02_3 FROM gem_file
                   WHERE gem01=l_abd.abd02 AND gem05='Y' AND gemacti='Y'
                IF STATUS=100 THEN LET l_gem02_3=' ' END IF
                EXECUTE insert_prep USING l_abd.abd01,l_abd02_1,l_abd02_2,
                                          l_abd02_3,l_gem02,l_gem02_1,l_gem02_2,
                                          l_gem02_3
                INITIALIZE l_abd02_1,l_abd02_2,l_abd02_3,        #每次插入后清空舊值,
                           l_gem02_1,l_gem02_2,l_gem02_3 TO NULL #以防當前筆值為空時使用舊值
             END IF
          END IF
       END IF
       #No:FUN-760085---End
    END FOREACH
    IF i <> 1 THEN                                               #若查詢的最后一次排列未排滿3筆,
                                                                 #則插入最后一行排列值
       EXECUTE insert_prep USING l_abd.abd01,l_abd02_1,l_abd02_2,
                                 l_abd02_3,l_gem02,l_gem02_1,l_gem02_2,
                                 l_gem02_3
       INITIALIZE l_abd02_1,l_abd02_2,l_abd02_3,
                  l_gem02_1,l_gem02_2,l_gem02_3 TO NULL
    END IF
    #FINISH REPORT i112_rep                 #No:FUN-760085

    CLOSE i112_co
    ERROR ""
    #No:FUN-760085---Begin
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'abd01,abd02')
            RETURNING g_wc
       LET g_str = g_wc
    END IF
    LET g_str = g_wc
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('agli112','agli112',l_sql,g_str)
   #No:FUN-760085---End
END FUNCTION

#No:FUN-760085---Begin
#REPORT i112_rep(sr)
#   DEFINE
#        l_trailer_sw   LIKE type_file.chr1,          #No.FUN-680098   CHAR(1)
#        sr RECORD LIKE abd_file.*,
#        l_chr           LIKE type_file.chr1          #No.FUN-680098  CHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.abd01,sr.abd02
#
#    FORMAT
#        PAGE HEADER
#            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED       # No.TQC-750022
#            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#            PRINT ' '
#            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN (g_len-FGL_WIDTH(g_user)-18),'FROM:',g_user CLIPPED, COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'    # No.TQC-750022
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#           LET i=i+1
#           SELECT gem02 INTO m_gem02 FROM gem_file
#             WHERE gem01=sr.abd02 AND gem05='Y' AND gemacti='Y'
#           IF STATUS=100 THEN LET m_gem02=' ' END IF
#           IF i<=3 THEN
#              PRINT COLUMN 22*i,sr.abd02 CLIPPED,' ',m_gem02 CLIPPED;
#              IF i=3 THEN
#                 PRINT ''
#              ELSE
#                 PRINT '';
#              END IF
#           ELSE
#              LET i=1
#              PRINT COLUMN 22*i,sr.abd02 CLIPPED,' ',m_gem02 CLIPPED;
#           END IF
#
#        BEFORE GROUP OF sr.abd01
#           SELECT gem02 INTO m_gem02 FROM gem_file
#              WHERE gem01 = sr.abd01 AND gem05='Y' AND gemacti='Y'
#           IF STATUS=100 THEN LET m_gem02='' END IF
#           PRINT g_x[11] CLIPPED,' ',sr.abd01,COLUMN 18,m_gem02
#           PRINT ''
#           PRINT COLUMN 22,g_x[12] CLIPPED,COLUMN 44,g_x[12] CLIPPED,
#                 COLUMN 66,g_x[12] CLIPPED
#           PRINT COLUMN 22,'---------------       ---------------       ---------------'
#
#        AFTER GROUP OF sr.abd01
#           LET i=0
#           PRINT ''
#           PRINT ''
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No:FUN-760085---End
#Patch....NO:TQC-610035 <001> #


###FUN-9A0002 START ###
##################################################
# Descriptions...: Tree填充
# Date & Author..: 09/10/14 By tsai_yen
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
FUNCTION i112_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_abd              DYNAMIC ARRAY OF RECORD
             abd01           LIKE abd_file.abd01,
             abd02           LIKE abd_file.abd02,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_gem02            LIKE gem_file.gem02  #部門名稱
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5


   LET max_level = 20 #設定最大階層數為20

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_abd.clear()

      #讓QBE出來的單頭都當作Tree的最上層
#      IF g_wc_o = ' 1=1' THEN 
          LET g_sql = "SELECT DISTINCT abd01,abd01 as abd02,COUNT(abd02) as child_cnt FROM abd_file",
                      " WHERE ", p_wc CLIPPED,
                      " AND  abd01 NOT IN (SELECT DISTINCT abd02 FROM abd_file WHERE ", p_wc CLIPPED,")", #TQC-A60039 
                      " GROUP BY abd01",
                      " ORDER BY abd01"
#      ELSE 
#         LET g_sql = "SELECT DISTINCT abd01,abd01 as abd02,COUNT(abd02) as child_cnt FROM abd_file",
#                     " WHERE ", p_wc CLIPPED,
#                     " GROUP BY abd01",
#                     " ORDER BY abd01" 
#     END IF                     	            
      PREPARE i112_tree_pre1 FROM g_sql
      DECLARE i112_tree_cs1 CURSOR FOR i112_tree_pre1      

      LET l_i = 1      
      FOREACH i112_tree_cs1 INTO l_abd[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF         
         
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = FALSE    #TRUE:展開, FALSE:不展開
         LET l_gem02 = NULL
         SELECT gem02 INTO l_gem02 FROM gem_file
            WHERE gem01 = l_abd[l_i].abd02 AND gemacti='Y'
         LET g_tree[g_idx].name = l_abd[l_i].abd01,"(",l_gem02,")"
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_abd[l_i].abd02
         LET g_tree[g_idx].treekey1 = l_abd[l_i].abd01
         LET g_tree[g_idx].treekey2 = l_abd[l_i].abd02
         #有子節點
         IF l_abd[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL i112_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
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

      LET g_sql = "SELECT DISTINCT abd_file.abd01,abd_file.abd02,cnt.child_cnt",
                  " FROM (",
                  "   SELECT DISTINCT abd01,abd02 FROM abd_file",
                  "   WHERE abd01='",p_key2 CLIPPED,"'",
                  " ) abd_file",
                  " LEFT JOIN",
                  " (",
                  "   SELECT abd01,COUNT(abd01) as child_cnt FROM abd_file",
                  "   WHERE abd01 IN (",
                  "      SELECT DISTINCT abd02 FROM abd_file",
                  "      WHERE abd01='",p_key2 CLIPPED,"'",
                  "      )",
                  "   GROUP BY abd01",
                  " ) cnt",
                  " ON abd_file.abd02 = cnt.abd01",
                  " ORDER BY abd02"
      PREPARE i112_tree_pre2 FROM g_sql
      DECLARE i112_tree_cs2 CURSOR FOR i112_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_abd.clear()
      FOREACH i112_tree_cs2 INTO l_abd[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_abd.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = FALSE    #TRUE:展開, FALSE:不展開
            SELECT gem02 INTO l_gem02 FROM gem_file
               WHERE gem01 = l_abd[l_i].abd02 AND gemacti='Y'
            LET g_tree[g_idx].name = l_abd[l_i].abd02,"(",l_gem02,")"
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_abd[l_i].abd02
            LET g_tree[g_idx].treekey1 = l_abd[l_i].abd01
            LET g_tree[g_idx].treekey2 = l_abd[l_i].abd02
            #有子節點
            IF l_abd[l_i].child_cnt > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL i112_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
          END FOR
      END IF
   END IF
END FUNCTION


##################################################
# Descriptions...: 依tree path指定focus節點
# Date & Author..: 09/10/14 By tsai_yen
# Input Parameter:
# Return code....:
##################################################
FUNCTION i112_tree_idxbypath()
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
# Descriptions...: 展開節點
# Date & Author..: 09/10/14 By tsai_yen
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION i112_tree_open(p_idx)
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
            CALL i112_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION


##################################################
# Descriptions...: 檢查是否為無窮迴圈
# Date & Author..: 09/12/22 By tsai_yen
# Input Parameter: p_key1,p_addkey2,p_flag
# Return code....: l_loop
##################################################
FUNCTION i112_tree_loop(p_key1,p_addkey2,p_flag)
   DEFINE p_key1             STRING
   DEFINE p_addkey2          STRING               #要增加的節點key2
   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_abd              DYNAMIC ARRAY OF RECORD
             abd01           LIKE abd_file.abd01,
             abd02           LIKE abd_file.abd02,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_gem02            LIKE gem_file.gem02  #部門名稱
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N

   IF cl_null(p_flag) THEN   #第一次進遞迴
      LET g_idx = 1
      LET g_path_add[g_idx] = p_addkey2
   END IF
   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF

   IF NOT cl_null(p_addkey2) THEN
      LET g_sql = "SELECT DISTINCT abd_file.abd01,abd_file.abd02,cnt.child_cnt",
                  " FROM (",
                  "   SELECT DISTINCT abd01,abd02 FROM abd_file",
                  "   WHERE abd01='",p_addkey2 CLIPPED,"'",
                  " ) abd_file",
                  " LEFT JOIN",
                  " (",
                  "   SELECT abd01,COUNT(abd01) as child_cnt FROM abd_file",
                  "   WHERE abd01 IN (",
                  "      SELECT DISTINCT abd02 FROM abd_file",
                  "      WHERE abd01='",p_addkey2 CLIPPED,"'",
                  "      )",
                  "   GROUP BY abd01",
                  " ) cnt",
                  " ON abd_file.abd02 = cnt.abd01",
                  " ORDER BY abd02"
      PREPARE i112_tree_pre3 FROM g_sql
      DECLARE i112_tree_cs3 CURSOR FOR i112_tree_pre3

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_abd.clear()
      FOREACH i112_tree_cs3 INTO l_abd[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_abd.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_path_add[g_idx] = l_abd[l_i].abd02
            IF g_path_add[g_idx] = p_key1 THEN
               LET l_loop = "Y"
               RETURN l_loop
            END IF
            #有子節點
            IF l_abd[l_i].child_cnt > 0 THEN
               CALL i112_tree_loop(p_key1,l_abd[l_i].abd02,p_flag) RETURNING l_loop
            END IF
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION


##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 09/12/22 By tsai_yen
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i112_tree_update()
   #Tree重查並展開focus節點
#  CALL i112_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充  #dxfwo
   CALL i112_tree_fill(g_wc,NULL,0,NULL,NULL,NULL)   #Tree填充  #dxfwo
   CALL i112_tree_idxbypath()                        #依tree path指定focus節點
   CALL i112_tree_open(g_tree_focus_idx)             #展開節點
   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單身
   ELSE
      LET g_tree_b = "Y"
   END IF
   CALL i112_q(g_tree_focus_idx)          #dxfwo
#  CALL i112_fetch('T',g_tree_focus_idx)  #dxfwo
END FUNCTION
###FUN-9A0002 END ###

##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION i112_tree_idxbykey()   #No.FUN-A30120 add by tommas  fetch單頭後，利用g_abd01來搜尋該資料目前位於g_tree的哪個索引中。
   DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 0
   FOR l_idx = 1 TO g_tree.getLength()
   #   IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey2 == g_abd01 ) CLIPPED THEN  # 尋找節點
       IF g_tree[l_idx].treekey2 == g_abd01  CLIPPED THEN 

         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
END FUNCTION

#No:FUN-A50010  
##################################################
# Descriptions...: 多選樹後，新增至單身
#                  檢查步驟：1.檢查不為節點本身
#                          2.檢查不重覆加入節點
#                          3.檢查不形成環狀節點
#                          則 加入成為子節點
# Input Parameter: p_dialog  ui.Dialog
# Return code....: void
##################################################
FUNCTION i112_add_sub_b(p_dialog)
    DEFINE r INTEGER
    DEFINE p_dialog ui.Dialog
    DEFINE l_gem02 LIKE gem_file.gem02
    DEFINE l_abd02 LIKE abd_file.abd02
    DEFINE l_loop LIKE type_file.chr1 
    DEFINE l_chk1 BOOLEAN    
    DEFINE l_errmsg STRING
    DEFINE loop INTEGER
    LET l_errmsg = ""
        FOR r = 1 TO p_dialog.getArrayLength("tree")
        LET l_chk1 = TRUE      
           IF p_dialog.isRowSelected("tree",r) THEN
                LET l_abd02 = g_tree[r].treekey2 
                #1.不能加入自己本身成為子節點
                IF l_chk1 THEN
                    IF g_tree[r].treekey2 == g_abd01 THEN       
                       LET l_chk1 = FALSE
                       CALL cl_err("","agl-226",0)
                    END IF
                END IF
                #2.檢查重覆加入的子節點
                IF l_chk1 THEN                       #上一規則檢查OK，進行下一個檢查                 
                    LET loop = 1
                    FOR loop =1 TO g_abd.getLength()        
                        IF l_abd02 == g_abd[loop].abd02 THEN 
                           LET l_chk1 = FALSE
                           CALL cl_err("","agl-116",0)
                        END IF
                    END FOR
                END IF
                #3.檢查是否成環狀(自己的上層節點加到自己的下層)
                IF l_chk1 THEN                        #上一規則檢查OK，進行下一個檢查               
                   CALL i112_tree_loop(g_abd01,l_abd02,l_errmsg)  RETURNING l_loop                   
                   IF l_loop='Y' THEN
                      CALL cl_err("","agl1000",0) END IF
                END IF                         
                # 沒重覆也沒加自己本身也沒形成環狀，則加入子節點
                IF l_loop='N' AND l_chk1 THEN       
                    CALL g_abd.appendElement()                    
                    SELECT gem02 INTO l_gem02 FROM gem_file
                    WHERE gem01 = l_abd02 AND gemacti='Y'
                    LET g_abd[g_abd.getLength()].abd02 = l_abd02
                    LET g_abd[g_abd.getLength()].gem02 = l_gem02
                END IF
           END IF
        END FOR

END FUNCTION

#No:FUN-A50010
##################################################
# Descriptions...: 儲存操作結果
# Date & Author..: 10/05/05 By lixia
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i112_save()
    DEFINE l_idx    INTEGER                                                                                                          
    DEFINE l_count  INTEGER 
    BEGIN WORK    
        FOR l_idx = 1 TO g_abd.getLength()                                                                                          
           SELECT COUNT(*) INTO  l_count FROM abd_file WHERE abd02= g_abd[l_idx].abd02                                              
           IF l_count>0 THEN                                                                                                        
              UPDATE abd_file SET abd_file.abd01 = g_abd01                                                                          
               WHERE abd_file.abd02 = g_abd[l_idx].abd02                                                                            
           ELSE                                                                                                                     
              INSERT INTO abd_file (abd01,abd02,abdoriu,abdorig)                                                                    
              VALUES(g_abd01,g_abd[l_idx].abd02, g_user, g_grup)                                                                    
           END IF                                                                                                                   
           IF SQLCA.sqlcode THEN                                                                                                    
              EXIT FOR 
           END IF                                                                                                                   
        END FOR  
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
       CALL i112_tree_update()
    END IF
END FUNCTION

#No:FUN-A50010
##################################################
# Descriptions...: 獲取正確的g_jump和g_curs_index
# Date & Author..: 10/05/05 By suncx1
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i112_jump()
    DEFINE l_idx   INTEGER
    DEFINE l_jump    LIKE type_file.num10
    LET l_jump = 1
    FOR l_idx = 1 TO g_abd01_a.getLength()
       IF g_abd01_a[l_idx].abd01 == g_tree[g_tree_focus_idx].treekey2 THEN 
          LET l_jump = l_idx
       END IF
    END FOR  
    RETURN l_jump
END FUNCTION

#NO.FUN-B40024 --start--
FUNCTION i112_out2()
DEFINE sr DYNAMIC ARRAY OF RECORD
           abd01   LIKE abd_file.abd01,
           abd02   LIKE abd_file.abd02,
           gem02   LIKE gem_file.gem02
          END RECORD
DEFINE l_n LIKE type_file.num5

    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF

    CALL cl_wait()

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "(abd01,abd02_1,gem02) VALUES(?,?,?) "
    PREPARE insert_prep2 FROM g_sql
    CALL cl_del_data(l_table)
    
    LET g_sql="SELECT abd01,abd02,gem02 FROM abd_file ",    
              " left join gem_file on abd02 = gem01 ",
              " where ",g_wc CLIPPED,              
              " ORDER BY abd01,abd02 "

    PREPARE i112_p2 FROM g_sql                
    DECLARE i112_co2  CURSOR FOR i112_p2

    LET l_n = 1

    FOREACH i112_co2 INTO sr[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
          EXECUTE insert_prep2 USING sr[l_n].abd01,sr[l_n].abd02,sr[l_n].gem02
       LET l_n = l_n + 1
    END FOREACH
    CALL sr.deleteElement(l_n)
    LET l_n = l_n - 1
    LET g_str=g_wc

    #上層 --start--
    LET l_n = 1
    CALL sr.clear()
    LET g_sql="SELECT distinct abd01,abd02,gem_file.gem02 from ", g_cr_db_str CLIPPED, l_table CLIPPED,   
              " left join gem_file on abd01 = gem01 ",
              " where not abd02_1 in (select abd01 from abd_file )",
              " ORDER BY abd01"
    PREPARE i112_p4 FROM g_sql                
    DECLARE i112_co4  CURSOR FOR i112_p4   
    
    FOREACH i112_co4 INTO sr[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
          EXECUTE insert_prep2 USING sr[l_n].abd01,sr[l_n].abd01,sr[l_n].gem02
       LET l_n = l_n + 1
    END FOREACH
    #上層 --end--
    
    #下層 --start--
    WHILE TRUE
        LET l_n = 1                
        CALL sr.clear()
        LET l_sql = "SELECT abd01,abd02,gem02 FROM abd_file left join gem_file ",
                    " on abd02 = gem01 ",
                    " where abd01 in (select abd02_1 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) ",                                     
                    " and not abd02 in (select abd02_1 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) "
                    
        PREPARE i112_p3 FROM l_sql
        DECLARE i112_co3 CURSOR FOR i112_p3
        FOREACH i112_co3 INTO sr[l_n].*
           IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT WHILE
           END IF
           EXECUTE insert_prep2 USING sr[l_n].abd01,sr[l_n].abd02,sr[l_n].gem02
           LET l_n = l_n + 1
        END FOREACH
        LET l_n = l_n - 1
        IF l_n < 1 THEN EXIT WHILE END IF
    END WHILE    
    #下層  --end--

    #虛擬最頂層 --START--
    CALL sr.clear() 
    LET l_n = 1 
    LET l_sql = "SELECT DISTINCT abd01,abd01,gem_file.gem02 ",
                " FROM ", g_cr_db_str CLIPPED, l_table CLIPPED ,
                " LEFT JOIN gem_file ON abd01 = gem01 ",
                " WHERE not abd01 in(select abd02_1 FROM ", g_cr_db_str CLIPPED, l_table CLIPPED ,")"
    PREPARE i112_p5 FROM l_sql
    DECLARE i112_co5 CURSOR FOR i112_p5
    FOREACH i112_co5 INTO sr[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       EXECUTE insert_prep2 USING sr[l_n].abd01,sr[l_n].abd02,sr[l_n].gem02
       LET l_n = l_n + 1
    END FOREACH                    
                    
    #虛擬最底層 --END--
    

    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('agli112','agli112_1',l_sql,g_str)
END FUNCTION
#NO.FUN-B40024 --end--
