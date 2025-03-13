# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi930.4gl
# Descriptions...: 法人基本資料建立
# Date & Author..: FUN-980025 09/08/04 By dxfwo

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0202 09/09/24 By jan insert/update 時， aztuser / grup / date / modi 等欄位無資料
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50010 10/05/05 by WangX  加入TREE
# Modify.........: No.TQC-B10239 11/01/25 by rainy Action修正
# Modify.........: No.FUN-B30165 11/03/22 By huangtao 將法人編號轉換成大寫
# Modify.........: No:FUN-B40024 11/04/12 By jason 新增樹狀報表
# Modify.........: No:TQC-B50119 11/05/20 By zhangll 上级名称显示刷新
# Modify.........: No:TQC-B50123 11/05/23 By zhangll 修正语法错误
# Modify.........: No:MOD-BB0130 11/11/10 By suncx 查詢上層法人開窗BUG
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-980025
DEFINE
    g_azt           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        azt01       LIKE azt_file.azt01,
        azt02       LIKE azt_file.azt02,
        azt03       LIKE azt_file.azt03,
        azt02_t     LIKE azt_file.azt02,
        aztacti     LIKE azt_file.aztacti
                    END RECORD,
    g_buf           LIKE ima_file.ima01,
    g_azt_t         RECORD                 #程式變數 (舊值)
        azt01       LIKE azt_file.azt01,
        azt02       LIKE azt_file.azt02,
        azt03       LIKE azt_file.azt03,
        azt02_t     LIKE azt_file.azt02,
        aztacti     LIKE azt_file.aztacti
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,            #單身筆數
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT
DEFINE p_row,p_col     LIKE type_file.num5

DEFINE g_str STRING #No:FUN-B40024
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_jump          LIKE type_file.num10
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_cnt           LIKE type_file.num10
DEFINE mi_no_ask       LIKE type_file.num5
DEFINE l_sql           STRING                  #FUN-A50010
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
###FUN-A50010 START ###
DEFINE g_wc2_o            STRING                #g_wc2舊值備份
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_idx1            LIKE type_file.num5
DEFINE g_idx2            LIKE type_file.num5
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節點 FALSE:無子節點
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空格
          treekey1       STRING
          END RECORD
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑check loop)
###FUN-A50010 END ###
DEFINE g_key1              LIKE azt_file.azt01
DEFINE colors DYNAMIC ARRAY OF RECORD
                      color1 STRING,
                      color2 STRING
                      END RECORD
DEFINE l_table STRING #No:FUN-B40024

MAIN
#     DEFINE l_time LIKE type_file.chr8            #No.FUN-A50010
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-A50010   SMALLINT

   OPTIONS                               #改變一些系統預設值
   INPUT NO WRAP,
   FIELD ORDER FORM
   DEFER INTERRUPT                       #擷取中斷鋿 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

   #No:FUN-B40024 --START--
   LET g_sql = "azt01.azt_file.azt01,",
               "azt02.azt_file.azt02,",
               "azt03.azt_file.azt03,"
   LET l_table = cl_prt_temptable('aooi930',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?) "

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No:FUN-B40024 --END--


   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
        RETURNING g_time

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW i930_w AT p_row,p_col WITH FORM "aoo/42f/aooi930"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-A50010   ---START---
   LET g_wc2 = '1=1'
   #CALL i930_b_fill(g_wc2)
   LET g_tree_reload = "N"
   LET g_tree_b = "N"
   LET g_tree_focus_idx = 0
   #FUN-A50010   ---END---


   CALL i930_menu()
   CLOSE WINDOW i930_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
       RETURNING g_time

END MAIN

#FUNCTION i930_cs(p_idx)    #FUN-A50010 加參數p_idx
#  DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-A50010
#  DEFINE l_wc   STRING                #雙按Tree的節點時的查詢䞣FUN-A50010

#  CLEAR FORM                             #清除畫面
#  CALL g_azt.clear()
#  CALL cl_set_head_visible("","YES")    #No.FUN-6B0029

#  INITIALIZE g_azt[l_ac].azt01 TO NULL    #No.FUN-750051

#  IF p_idx = 0 THEN   #FUN-A50010
#     CONSTRUCT g_wc2 ON azt01 FROM s_azt[1].azt01  #螢幕上取條件
#               #No:FUN-580031 --start--     HCN
#               BEFORE CONSTRUCT
#                  CALL cl_qbe_init()
#               #No:FUN-580031 --end--       HCN
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT

#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121

#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121

#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121

#        #No:FUN-580031 --start--     HCN
#        ON ACTION qbe_select
#           CALL cl_qbe_select()
#           ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No:FUN-580031 --end--       HCN
#     END CONSTRUCT
#  ###FUN-A50010 START ###
#  ELSE
#     LET g_wc2 = l_wc CLIPPED
#  END IF
#
#  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('aztuser', 'aztgrup') #FUN-980030
#  IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
#     LET g_wc2_o = g_wc2 CLIPPED
#  END IF
#  ###FUN-A50010 END ###

#  IF INT_FLAG THEN RETURN END IF
#  #LET g_sql= "SELECT UNIQUE azt01 FROM azt_file ",     #FUN-A50010 mark
#  LET g_sql= "SELECT DISTINCT azt01 FROM azt_file ",    #FUN-A50010
#             " WHERE ", g_wc2 CLIPPED,
#             " ORDER BY azt01"
#  PREPARE i930_prepare FROM g_sql        #預備一䶿
#   DECLARE i930_bcs
#    SCROLL CURSOR WITH HOLD FOR i930_prepare

#  LET g_sql="SELECT COUNT(DISTINCT azt01)  ",
#            " FROM azt_file WHERE ", g_wc2 CLIPPED
#  PREPARE i930_precount FROM g_sql
#  DECLARE i930_count CURSOR FOR i930_precount
# END FUNCTION

FUNCTION i930_menu()
   ###FUN-A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   DEFINE l_idx              LIKE type_file.num5
   ###FUN-A50010 END ###
   WHILE TRUE
      #CALL i930_bp("G")   #FUN-A50010 mark

      ###FUN-A50010 START ###
      #FUN-D30032--add--str--               
      IF g_action_choice = "detail" THEN
         IF cl_chk_act_auth() THEN
            CALL i930_b() 
            IF g_action_choice = "detail" THEN    
               CONTINUE WHILE
            END IF        
         END IF
      END IF   
      #FUN-D30032--add--end--

      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)

      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_azt TO s_azt.* ATTRIBUTE(COUNT=g_rec_b)
            BEFORE DISPLAY
               CALL cl_navigator_setting(g_curs_index, g_row_count)

            BEFORE ROW
               LET l_ac = ARR_CURR()
               CALL cl_show_fld_cont()
               LET g_row_count= ARR_COUNT()
               CALL i930_tree_fill(g_wc2,NULL,0,NULL,g_azt[l_ac].azt01) #FUN-A50010
               CALL i930_tree_idxbykey()
               LET colors[g_idx1].color1 = "blue reverse"
               LET colors[g_idx1].color2 = "blue reverse"
               CALL change_idx(g_idx1)
# EXIT DIALOG
            ON ACTION accept
              LET g_action_choice="detail"
               EXIT DIALOG



            AFTER ROW
               LET colors[g_idx1].color1 = NULL
               LET colors[g_idx1].color2 = NULL
               LET g_key1 = 0
               LET g_idx1 = 0
               LET g_idx2 = 0
            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG
            &include "qry_string.4gl"
         END DISPLAY



         BEFORE DIALOG
            CALL DIALOG.setArrayAttributes("tree", colors)
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)

            END IF


         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG

       #TQC-B10239 begin
         #ON ACTION output
         #   LET g_action_choice="output"
         #   EXIT DIALOG
       #TQC-B10239 end

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



         #ON ACTION cancel     #FUN-A50010 mark
         #   LET INT_FLAG=FALSE
         #   LET g_action_choice="exit"
         #   EXIT DIALOG

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

         #No:FUN-B40024 --START--
         ON ACTION OUTPUT
            LET g_action_choice = 'output'
            EXIT DIALOG
         #No:FUN-B40024 --END--
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
      ###FUN-9A0002 END ###


      CASE g_action_choice

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i930_q(0)           #FUN-A50010 加參數p_idx
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i930_r()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i930_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       #TQC-B10239 begin
         #WHEN "output"
         #   IF cl_chk_act_auth() THEN
         #      CALL i930_out()
         #   END IF
       #TQC-B10239 end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_azt[l_ac].azt01 IS NOT NULL THEN
                  LET g_doc.column1 = "azt01"
                  LET g_doc.value1 = g_azt[l_ac].azt01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azt),'','')
            END IF
         #No:FUN-B40024 --START--
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i930_out()
            END IF
         #No:FUN-B40024 --END--
      END CASE
   END WHILE
END FUNCTION


FUNCTION i930_q(p_idx)
DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index
     CALL i930_b_askkey(p_idx)

END FUNCTION

FUNCTION i930_b_askkey(p_idx)
 DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-A50010
 DEFINE l_wc   STRING                #雙按Tree的節點時的查詢䞣FUN-A50010

   ###FUN-A50010 START ###
   LET l_wc = NULL
   IF p_idx > 0 THEN
      IF g_tree_b = "N" THEN
         LET l_wc = g_wc2_o             #還原QBE的查詢條件
         ELSE
         IF g_tree[p_idx].level = 1 THEN
            LET l_wc = g_wc2_o
         ELSE
            IF g_tree[p_idx].has_children THEN
               LET l_wc = "oea01='",g_tree[p_idx].treekey1 CLIPPED
            END IF
         END IF
      END IF
   END IF
   ###FUN-A50010 END ###
   CLEAR FORM
   CALL g_azt.clear()

   CONSTRUCT g_wc2 ON azt01,azt02,azt03,aztacti
        FROM s_azt[1].azt01,s_azt[1].azt02,
             s_azt[1].azt03,s_azt[1].aztacti

   BEFORE CONSTRUCT
      CALL cl_qbe_init()

      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(azt03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_azt03"
             LET g_qryparam.state    = "c"
            #LET g_qryparam.default1 = g_azt[l_ac].azt03   #MOD-BB0130
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO s_azt[1].azt03
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('aztuser', 'aztgrup') #FUN-980030


   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL i930_b_fill(g_wc2)
   #CALL i930_tree_fill(g_wc2,NULL,0,NULL,NULL)
END FUNCTION


FUNCTION i930_show()

    DISPLAY g_azt[l_ac].azt01 TO azt01           #單頭
    CALL i930_b_fill(g_wc2)             #單身

    CALL cl_show_fld_cont()            #No:FUN-550037 hmf
END FUNCTION
###FUN-A50010 END ###

FUNCTION i930_r()
    DEFINE l_chr    LIKE type_file.chr1          #No.FUN-680098 CHAR(1)
    ###FUN-A50010 START ###
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_prev   STRING  #前一個節點
    DEFINE l_next   STRING  #後一個節點    ###FUN-A50010 END ###

    IF s_shut(0) THEN RETURN END IF
    IF g_azt[l_ac].azt01 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    BEGIN WORK
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "azt01"
        LET g_doc.value1 = g_azt[l_ac].azt01
        CALL cl_del_doc()

        ###FUN-A50010 START ###
        #在Tree節點刪除之前先找出刪除後要focus的節點path
        CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
        #刪除子節點後，focus在它的父節點
        IF l_i > 1 THEN
           CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
        #刪除的是最上層節點，focus在它的後一個節點或前一個節點
         ELSE
           CALL i930_tree_idxbypath()               #依tree path指定focus節點
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
        ###FUN-A50010 END ###

        DELETE FROM azt_file WHERE azt01=g_azt[l_ac].azt01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_azt[l_ac].azt01,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("del","azt_file",g_azt[l_ac].azt01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL g_azt.clear()
           CALL g_azt.clear()

           CALL i930_tree_update() #Tree 資料有異剿#FUN-A50010
           ###FUN-A50010 mark STRAT ###
           #  OPEN i930_count
           #  FETCH i930_count INTO g_row_count
           #  DISPLAY g_row_count TO FORMONLY.cnt
           #
           #  ###FUN-A50010 mark STRAT ###
           #  OPEN i930_bcs
           #  IF g_curs_index = g_row_count + 1 THEN
           #     LET g_jump = g_row_count
           #     CALL i930_fetch('L')
           #  ELSE
           #     LET g_jump = g_curs_index
           #     LET mi_no_ask = TRUE
           #     CALL i930_fetch('/')
           #  END IF
           ###FUN-A50010 mark END ###
        END IF
    END IF
    COMMIT WORK
END FUNCTION


FUNCTION i930_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,                #檢查重複用
          l_n1            LIKE type_file.num5,                #檢查重複用  #sunyanchun add
          l_n2            LIKE type_file.num5,
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
          p_cmd           LIKE type_file.chr1,                #處理狀態
          l_allow_insert  LIKE type_file.num5,                #可新增否
          l_allow_delete  LIKE type_file.num5                 #可刪除否
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_loop   LIKE type_file.chr1       #是否為無窮迴圈Y/N   #FUN-50010
   DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index  #FUN-A50010

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT azt01,azt02,azt03,'',aztacti",
                      "  FROM azt_file WHERE azt01=? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i930_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_azt WITHOUT DEFAULTS FROM s_azt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'

         IF g_rec_b >= l_ac THEN
            LET g_azt_t.* = g_azt[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i930_bcl USING g_azt_t.azt01
            IF STATUS THEN
               CALL cl_err("OPEN i930_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i930_bcl INTO g_azt[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_azt_t.azt01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
             IF l_ac <= l_n then                   #DISPLAY NEWEST
               SELECT  azt02 INTO g_azt[l_ac].azt02_t
                 FROM  azt_file
                WHERE  azt01 = g_azt[l_ac].azt03
             END IF
            LET g_before_input_done = FALSE
            CALL i930_set_entry(p_cmd)
            CALL i930_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_azt[l_ac].* TO NULL
         LET g_azt_t.* = g_azt[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE
         CALL i930_set_entry(p_cmd)
         CALL i930_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         LET g_azt[l_ac].azt03= g_azt[l_ac].azt01
         LET g_azt[l_ac].aztacti= 'Y'
         CALL cl_show_fld_cont()
         NEXT FIELD azt01

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

      ###FUN-A50010 START ###
            CALL i930_tree_loop(g_azt[l_ac].azt01,NULL) RETURNING l_loop
            IF l_loop = "Y" THEN
               CALL cl_err(g_azt[l_ac].azt01,"agl1000",1)
               CANCEL INSERT
            ELSE
      ###FUN-A50010 END ###
         LET g_azt[l_ac].azt01 = UPSHIFT(g_azt[l_ac].azt01)     #FUN-B30165 add
         INSERT INTO azt_file(azt01,azt02,azt03,aztacti,
                              aztdate,aztgrup,aztuser,aztoriu,aztorig)   #TQC-9B0202
              VALUES(g_azt[l_ac].azt01,g_azt[l_ac].azt02,
                     g_azt[l_ac].azt03,g_azt[l_ac].aztacti,
                     g_today,g_grup,g_user, g_user, g_grup)  #TQC-9B0202       #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","azt_file",g_azt[l_ac].azt01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            LET g_tree_reload = "Y"    #FUN-A50010
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
      END IF  #FUN-A50010

      AFTER FIELD azt01
         IF g_azt[l_ac].azt01 IS NOT NULL THEN
            IF  g_azt[l_ac].azt03 IS NULL THEN
                LET g_azt[l_ac].azt01 = UPSHIFT(g_azt[l_ac].azt01)     #FUN-B30165 add
                LET g_azt[l_ac].azt03= g_azt[l_ac].azt01
            END IF
            IF g_azt[l_ac].azt01 != g_azt_t.azt01 OR
               (NOT cl_null(g_azt[l_ac].azt01) AND cl_null(g_azt_t.azt01)) THEN
               LET g_azt[l_ac].azt01 = UPSHIFT(g_azt[l_ac].azt01)     #FUN-B30165 add
               SELECT count(*) INTO l_n1 FROM azt_file
                WHERE azt01 = g_azt[l_ac].azt01
               IF l_n1 IS NULL THEN LET l_n1 = 0 END IF
               IF l_n1 > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_azt[l_ac].azt01 = g_azt_t.azt01
                  NEXT FIELD azt01
               END IF
             END IF
           END IF

       #Add TQC-B50119
       AFTER FIELD  azt02
         IF  g_azt[l_ac].azt03 = g_azt[l_ac].azt01  THEN
             LET g_azt[l_ac].azt02_t = g_azt[l_ac].azt02
             DISPLAY BY NAME g_azt[l_ac].azt02_t
         END IF
       #End Add TQC-B50119

       AFTER FIELD  azt03
         IF  g_azt[l_ac].azt03 = g_azt[l_ac].azt01  THEN
             LET g_azt[l_ac].azt02_t = g_azt[l_ac].azt02
         END IF
         IF  g_azt[l_ac].azt03 <> g_azt[l_ac].azt01 THEN
               SELECT count(*) INTO l_n2 FROM azt_file
                WHERE azt01 = g_azt[l_ac].azt03
               IF l_n2 < = 0 THEN
                  CALL cl_err('','azt-001',0)
                  LET g_azt[l_ac].azt03 = g_azt_t.azt03
                  NEXT FIELD azt03
               END IF
               SELECT  azt02 INTO g_azt[l_ac].azt02_t
                 FROM  azt_file
                WHERE  azt01 = g_azt[l_ac].azt03
                DISPLAY BY NAME g_azt[l_ac].azt02_t
          END IF

      BEFORE DELETE                            #是否取消單身
         IF g_azt_t.azt01 IS NOT NULL THEN

            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "azt01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_azt[l_ac].azt01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                         #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF

            DELETE FROM azt_file WHERE azt01 = g_azt_t.azt01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","azt_file",g_azt_t.azt01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_tree_reload = "Y"
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_azt[l_ac].* = g_azt_t.*
            CLOSE i930_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_azt[l_ac].azt01,-263,1)
            LET g_azt[l_ac].* = g_azt_t.*
         ELSE
         ###FUN-A50010 START ###
               CALL i930_tree_loop(g_azt[l_ac].azt01,NULL) RETURNING l_loop
               IF l_loop = "Y" THEN
                  CALL cl_err(g_azt[l_ac].azt01,"aoo1000",1)
                  LET g_azt[l_ac].* = g_azt_t.*
               ELSE
         ###FUN-A50010 END ###
            UPDATE azt_file SET
                   azt01=g_azt[l_ac].azt01,azt02=g_azt[l_ac].azt02,
                   azt03=g_azt[l_ac].azt03,
                   aztacti=g_azt[l_ac].aztacti,
                   aztmodu=g_user,   #TQC-9B0202
                   aztdate=g_today   #TQC-9B0202
             WHERE azt01 = g_azt_t.azt01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","azt_file",g_azt_t.azt01,"",SQLCA.sqlcode,"","",1)
               LET g_azt[l_ac].* = g_azt_t.*
            ELSE
               LET g_tree_reload = "Y"     #FUN-A50010
               MESSAGE 'UPDATE O.K'
               CLOSE i930_bcl
               COMMIT WORK
            END IF
           END IF  #FUN-A50010
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D40030
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_azt[l_ac].* = g_azt_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_azt.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i930_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D40030
         CLOSE i930_bcl
         COMMIT WORK


      ON ACTION CONTROLO
      IF INFIELD(azt01) AND l_ac > 1 THEN
            LET g_azt[l_ac].* = g_azt[l_ac-1].*
            NEXT FIELD azt01
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(azt03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_azt03"
             LET g_qryparam.default1 = g_azt[l_ac].azt03
             CALL cl_create_qry() RETURNING g_azt[l_ac].azt03
             DISPLAY BY NAME g_azt[l_ac].azt03
             NEXT FIELD azt03
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

   END INPUT

   CLOSE i930_bcl
   COMMIT WORK


   ###FUN-A50010 START ###
    #從Tree進來，且單身資料有異動時
    IF g_tree_b = "Y" AND g_tree_reload = "Y" THEN
       CALL i930_tree_update() #Tree 資料有異動
       LET g_tree_reload = "N"
    END IF
    ###FUN-A50010 END ###
END FUNCTION


FUNCTION i930_b_fill(p_wc2)
   DEFINE p_wc2   LIKE type_file.chr1000

   LET g_sql = "SELECT azt01,azt02,azt03,'',aztacti",
               "  FROM azt_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY azt01"
   PREPARE i930_pb FROM g_sql
   DECLARE azt_curs CURSOR FOR i930_pb

   CALL g_azt.clear()

   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH azt_curs INTO g_azt[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF

       SELECT  azt02 INTO g_azt[g_cnt].azt02_t
         FROM  azt_file
        WHERE  azt01 = g_azt[g_cnt].azt03
      DISPLAY BY NAME g_azt[g_cnt].azt02_t
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_azt.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   ###FUN-A50010 START ###
   #CALL i930_tree_fill(g_wc2,NULL,0,NULL,NULL)   #Tree填充
   ###FUN-A50010 END ###
END FUNCTION

###FUN-A50010 mark START ###
#FUNCTION i930_bp(p_ud)
#   DEFINE p_ud   LIKE type_file.chr1
#
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
#
#   LET g_action_choice = " "
#
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_azt TO s_azt.* ATTRIBUTE(COUNT=g_rec_b)
#
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()
#
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()
#
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
#
#      ON ACTION cancel
#             LET INT_FLAG=FALSE
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#
#      ON ACTION about
#         CALL cl_about()
#
#
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#      ON ACTION related_document    #相關文件
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
###FUN-A50010 mark END ###


FUNCTION i930_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) ) THEN
       CALL cl_set_comp_entry("azt01",TRUE)
    END IF

END FUNCTION

FUNCTION i930_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND ( NOT g_before_input_done )  THEN
     #CALL cl_set_comp_entry("g_azt[l_ac].azt01",FALSE) 
      CALL cl_set_comp_entry("azt01",FALSE)   #TQC-B50123 mod
    END IF

END FUNCTION

###FUN-A50010 START ###
##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/05
# Input Parameter: p_wc,p_pid,p_level,p_key1
# Return code....:
##################################################
FUNCTION i930_tree_fill(p_wc,p_pid,p_level,p_path,p_key1)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1              LIKE azt_file.azt01

   DEFINE l_azt             DYNAMIC ARRAY OF RECORD
             azt01           LIKE azt_file.azt01,
             azt02           LIKE azt_file.azt02,
             azt03           LIKE azt_file.azt03,
             aztacti         LIKE azt_file.aztacti
             END RECORD

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5
   DEFINE l_azt02            LIKE azt_file.azt02
   DEFINE l_idx              LIKE type_file.num5
   LET max_level = 20 #設定最大階層數為20

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      LET g_key1 = p_key1
      CALL g_tree.clear()
      CALL l_azt.clear()



       #讓QBE出來的單頭都當作Tree的最上層
      CALL i930_tree(p_key1)     RETURNING p_key1
      --LET g_sql=" SELECT UNIQUE azt01,azt02,azt03,aztacti FROM azt_file",
                --" WHERE ", p_wc CLIPPED,
                --"   AND azt01 = azt03",
                --"  ORDER BY azt01,azt02,azt03"
      --PREPARE i930_tree_pre1 FROM g_sql
      --DECLARE i930_tree_cs1 CURSOR FOR i930_tree_pre1
      --
      --LET l_i = 1
      --FOREACH i930_tree_cs1 INTO l_azt[l_i].*
         --IF SQLCA.sqlcode THEN
             --CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             --EXIT FOREACH
         --END IF
         --
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = FALSE    #TRUE:展開, FALSE:不展開
         SELECT azt02 INTO l_azt02 FROM azt_file
          WHERE azt01 =  p_key1
         LET g_tree[g_idx].name = p_key1,"(",l_azt02,")"
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = p_key1
         LET g_tree[g_idx].treekey1 = p_key1

         SELECT COUNT(azt03) INTO l_child FROM azt_file
          WHERE azt01 = p_key1
         #有子節��?
         IF l_child > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL i930_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF


      ELSE
         LET p_level = p_level + 1   #下一階層
         IF p_level > max_level THEN
            CALL cl_err_msg("","aoo1001",max_level,0)
            RETURN
         END IF


            LET g_sql = "SELECT UNIQUE azt01,azt02,azt03,aztacti",
               "  FROM azt_file ",
               "  WHERE azt03  = '",p_key1,"' ",    #所属上层法人编号
               "  AND azt01 != azt03",
               "  AND aztacti = 'Y' ",
               "  ORDER BY azt01,azt02,azt03"

      PREPARE i930_tree_pre2 FROM g_sql
      DECLARE i930_tree_cs2 CURSOR FOR i930_tree_pre2

      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_azt.clear()
      FOREACH i930_tree_cs2 INTO l_azt[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_azt.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = FALSE    #T  #TRUE:展開, FALSE:不展開
            LET g_tree[g_idx].name = l_azt[l_i].azt01,"(",l_azt[l_i].azt02,")"
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path
            LET g_tree[g_idx].treekey1 = l_azt[l_i].azt01
            IF g_key1 = l_azt[l_i].azt01 THEN
               LET g_idx2 = g_idx
            END IF

            #有子節點
            LET g_tree[g_idx].has_children = TRUE
            CALL i930_tree_fill(p_wc,g_tree[g_idx].id,p_level,
                                   g_tree[g_idx].path,g_tree[g_idx].treekey1)
          END FOR
      ELSE
          LET g_tree[g_idx].has_children = FALSE
      END IF
  END IF
  IF g_idx2 IS NULL OR g_idx2 = 0  THEN
      LET g_idx1 = 1
  ELSE
      LET g_idx1 = g_idx2
  END IF
END FUNCTION

#FUN-A50010   ---START---
FUNCTION  i930_tree(p_azt01)
     DEFINE p_azt01 LIKE azt_file.azt01
     DEFINE p_azt03 LIKE azt_file.azt03
     DEFINE l_i     LIKE type_file.num5

     SELECT azt03 INTO p_azt03
       FROM azt_file
      WHERE azt01 = p_azt01
     IF p_azt03 = p_azt01	THEN
        RETURN p_azt01
     ELSE
        CALL i930_tree(p_azt03)  RETURNING p_azt01
     END IF
  	 RETURN p_azt01
END FUNCTION
#FUN-A50010   ---END---

#FUN-A50010   ---START---
#FUNCTION  i930_tree(p_azt01)
#     DEFINE p_azt01 LIKE azt_file.azt01
#     LET g_sql = SELECT azt03 FROM azt_file
#                  WHERE azt01 = p_azt01
#     IF g_azt[l_ac].azt03 = p_azt01	THEN
#        RETURN p_azt01
#     ELSE
#        CALL i930_tree(g_azt[l_ac].azt03)
#        RETURNING p_azt01
#     END IF
#     RETURN p_azt01
#END FUNCTION
#FUN-A50010   ---END---

##################################################
# Descriptions...: 依tree path指定focus節點
# Date & Author..: 10/05/05
# Input Parameter:
# Return code....:
##################################################
FUNCTION i930_tree_idxbypath()
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
# Date & Author..: 10/05/05
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION i930_tree_open(p_idx)
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
            CALL i930_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION


##################################################
# Descriptions...: 檢查是否為無窮迴圈
# Date & Author..: 10/05/05
# Input Parameter: p_key1,p_flag
# Return code....: l_loop
##################################################
FUNCTION i930_tree_loop(p_key1,p_flag)
   DEFINE p_key1             STRING

   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_azt              DYNAMIC ARRAY OF RECORD
             azt01           LIKE azt_file.azt01,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N


   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF

   IF NOT cl_null(p_key1) THEN
      LET g_sql = "SELECT DISTINCT azt_file.azt01,cnt.child_cnt",
                  " FROM (",
                  "   SELECT DISTINCT azt01 FROM azt_file",
                  "   WHERE azt01='",p_key1 CLIPPED,"'",
                  " ) azt_file"
      PREPARE i930_tree_pre3 FROM g_sql
      DECLARE i930_tree_cs3 CURSOR FOR i930_tree_pre3

      #在FOREACH中直接使用遞轿資料會錯丿所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_azt.clear()
      FOREACH i930_tree_cs3 INTO l_azt[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_azt.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白冿
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_path_add[g_idx] = l_azt[l_i].azt01
            IF g_path_add[g_idx] = p_key1 THEN
               LET l_loop = "Y"
               RETURN l_loop
            END IF
            #有子節點
             IF l_azt[l_i].child_cnt > 0 THEN
               CALL i930_tree_loop(l_azt[l_i].azt01,p_flag) RETURNING l_loop
            END IF
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION


##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/05
# Input Parameter:
# Return code....:
##################################################
FUNCTION i930_tree_update()
   #Tree重查並展開focus節點
   CALL i930_tree_fill(g_wc2_o,NULL,0,NULL,NULL)     #Tree填充
   CALL i930_tree_idxbypath()                        #依tree path指定focus節點
   CALL i930_tree_open(g_tree_focus_idx)             #展開節點   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單踿
   ELSE
      LET g_tree_b = "Y"
   END IF
   CALL i930_q(g_tree_focus_idx)
END FUNCTION
###FUN-A50010 END ###

##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION i930_tree_idxbykey()
DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 1
   FOR l_idx = 1 TO g_tree.getLength()
      IF g_tree[l_idx].treekey1 == g_azt[l_ac].azt01 CLIPPED THEN  # 尋找節點
         LET g_tree[l_idx].expanded = FALSE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
END FUNCTION

 FUNCTION display_customer(p_key,p_ac)
    DEFINE p_ac   LIKE type_file.num5
    DEFINE p_key  LIKE azt_file.azt01
    DEFINE l_azt             DYNAMIC ARRAY OF RECORD
              azt01           LIKE azt_file.azt01,
              azt02           LIKE azt_file.azt02,
              azt03           LIKE azt_file.azt03,
              aztacti         LIKE azt_file.aztacti
              END RECORD
    DEFINE att DYNAMIC ARRAY OF RECORD
                  azt01 STRING,
                  name  STRING
               END RECORD

       LET g_azt[p_ac].azt01 = p_key
       LET g_tree[p_ac].name = p_key,"(",l_azt[p_ac].azt02,")"
       LET att[p_ac].azt01 = "red"
       LET att[p_ac].name = "magenta reverse"

 END FUNCTION

FUNCTION change_idx(p_ac)
   ###FUN-A50010 START ###
   DEFINE p_ac               LIKE type_file.num5
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   DEFINE l_idx              LIKE type_file.num5
   ###FUN-A50010 END ###
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY

#               IF g_tree_focus_idx <= 0 THEN
#                  LET g_tree_focus_idx = ARR_CURR()
#               END IF

               #以最上層的id當作單頭的g_curs_index
#               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
#               LET g_curs_index = l_curs_index
#               CALL cl_navigator_setting( g_curs_index, g_row_count )
               CALL DIALOG.setArrayAttributes("tree", colors)
               EXIT DISPLAY
#            BEFORE ROW
#               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
#               CALL DIALOG.setSelectionMode( "tree", 1 )  # FUN-A50010
#               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)
#
#               #LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
#               # CALL i930_tree_idxbypath()
#               ##有子節點就focus在此，沒有子節點就focus在它的父節點
#               #IF g_tree[l_tree_arr_curr].has_children THEN
#               #   LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
#               #ELSE
#               #   CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
#               #   IF l_i > 1 THEN
#               #      CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
#               #   END IF
#               #   CALL i930_tree_idxbypath()   #依tree path指定focus節點
#               #END IF
#
#            #double click tree node
#            ON ACTION accept
#               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
#               #有子節點就focus在此，沒有子節點就focus在它的父節點
#               IF g_tree[l_tree_arr_curr].has_children THEN
#                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
#               ELSE
#                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
#                  IF l_i > 1 THEN
#                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
#                  END IF
#                  CALL i930_tree_idxbypath()   #依tree path指定focus節點
#              END IF
            #   LET g_tree_b = "Y"             #tree是否進入單身 Y/N
            #   CA LL i930_q(l_tree_arr_curr)
         END DISPLAY




END FUNCTION

#No:FUN-B40024 --START--
FUNCTION i930_out()
DEFINE l_azt DYNAMIC ARRAY OF RECORD
           azt01   LIKE azt_file.azt01,
           azt02   LIKE azt_file.azt02,
           azt03   LIKE azt_file.azt03
          END RECORD
DEFINE l_azt2 DYNAMIC ARRAY OF RECORD
           azt01   LIKE azt_file.azt01,
           azt02   LIKE azt_file.azt02,
           azt03   LIKE azt_file.azt03
          END RECORD
DEFINE l_n LIKE type_file.num5
DEFINE l_n2 LIKE type_file.num5

    IF g_wc2 IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF

    CALL cl_wait()

    LET g_sql="SELECT azt01,azt02,azt03 FROM azt_file ",
              " WHERE ",g_wc2 CLIPPED, " ORDER BY azt01 "

    PREPARE i930_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i930_co  CURSOR FOR i930_p1

    CALL cl_del_data(l_table)

    LET l_n = 1

    FOREACH i930_co INTO l_azt[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
          EXECUTE insert_prep USING l_azt[l_n].azt01,l_azt[l_n].azt02,l_azt[l_n].azt03
       LET l_n = l_n + 1
    END FOREACH
    CALL l_azt.deleteElement(l_n)
    LET l_n = l_n - 1
    LET g_str=g_wc2

    #第一層 --start--
    WHILE TRUE
        LET l_n2 = 1                
        CALL l_azt2.clear()
        
        LET l_sql = "SELECT azt01,azt02,azt03 FROM azt_file ",
                    " where azt01 in (select azt03 from ", g_cr_db_str CLIPPED, l_table CLIPPED ,
                                     " WHERE  azt01 <> azt03) ",
                    " and not azt01 in (select azt01 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) "

        PREPARE i930_p2 FROM l_sql
        DECLARE i930_co2 CURSOR FOR i930_p2

        FOREACH i930_co2 INTO l_azt2[l_n2].*
           IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT WHILE
           END IF
           EXECUTE insert_prep USING l_azt2[l_n2].azt01,l_azt2[l_n2].azt02,l_azt2[l_n2].azt03
           LET l_n2 = l_n2 + 1
        END FOREACH
        LET l_n2 = l_n2 - 1
        IF l_n2 < 1 THEN EXIT WHILE END IF
    END WHILE
    #第一層 --end--
    
    #其它層 --start--
    WHILE TRUE
        LET l_n2 = 1                
        CALL l_azt2.clear()
        LET l_sql = "SELECT azt01,azt02,azt03 FROM azt_file ",
                    " where azt03 in (select azt01 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) ",                                     
                    " and not azt01 in (select azt01 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) "
        PREPARE i930_p3 FROM l_sql
        DECLARE i930_co3 CURSOR FOR i930_p3
        FOREACH i930_co3 INTO l_azt2[l_n2].*
           IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT WHILE
           END IF
           EXECUTE insert_prep USING l_azt2[l_n2].azt01,l_azt2[l_n2].azt02,l_azt2[l_n2].azt03
           LET l_n2 = l_n2 + 1
        END FOREACH
        LET l_n2 = l_n2 - 1
        IF l_n2 < 1 THEN EXIT WHILE END IF
    END WHILE    
    #其它層 --end--

    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('aooi930','aooi930',l_sql,g_str)
END FUNCTION
#No:FUN-B40024 --END--
