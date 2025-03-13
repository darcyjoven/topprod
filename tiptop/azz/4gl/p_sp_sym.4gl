# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: p_sp_sym.4gl
# Descriptions...: 特殊符號建立作業(單檔多欄)
# Date & Author..: 11/12/02 By Henry
# Modify.........: No.FUN-BB0168 11/12/07 By Henry
# Note...........: 本程式為維護Table：gfq_file,gfq01:項次,gfq02:特殊符號
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"#No.FUN-BB0168

DEFINE
   g_gfq                 DYNAMIC ARRAY OF RECORD   #程式變數
      gfq01                 LIKE gfq_file.gfq01,   #項次
      gfq02                 LIKE gfq_file.gfq02    #特殊符號
                         END RECORD,
   g_gfq_t               RECORD                    #程式變數 (舊值)
      gfq01                 LIKE gfq_file.gfq01,   #項次
      gfq02                 LIKE gfq_file.gfq02    #特殊符號
                         END RECORD,
   g_wc2,g_sql           STRING,  
   g_rec_b               LIKE type_file.num5,      #目前單身總筆數
   l_ac                  LIKE type_file.num5,      #目前處理的單身筆數
   g_forupd_sql          STRING,                   #SELECT ... FOR UPDATE SQL
   g_cnt                 LIKE type_file.num10,     #填充單身時用的筆數
   g_before_input_done   LIKE type_file.num5       #判斷是否已執行BEFORE INPUT指令


MAIN                                                     #主程式
   OPTIONS
      INPUT NO WRAP                                      #輸入的方式: 不打轉
   DEFER INTERRUPT                                       #擷取中斷鍵

   IF (NOT cl_user()) THEN                               #預設部分參數(g_prog,g_user,...)
      EXIT PROGRAM                                       #切換成使用者預設的營運中心
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log                    #遇錯則記錄log檔
  
   IF (NOT cl_setup("AZZ")) THEN                         #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                                       #判斷使用者程式執行權限
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time       #程式進入時間
       
   OPEN WINDOW p_sp_sym_w WITH FORM "azz/42f/p_sp_sym"   #開啟畫面檔
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()                                     #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_wc2 = '1=1'                                     #設WHERE條件永遠為真，提取全部數據

   CALL p_sp_sym_b_fill(g_wc2)                           #抓取單身資料

   CALL p_sp_sym_menu()                                  #進入主視窗選單

   CLOSE WINDOW p_sp_sym_w                               #結束畫面
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time       #程式結束時間
END MAIN


FUNCTION p_sp_sym_menu()      #主視窗選單
   WHILE TRUE
      CALL p_sp_sym_bp("G")   #顯示單身資料，利用ON ACTION設定g_action_choice的值
      CASE g_action_choice    #根據g_action_choice的值執行對應動作
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_sp_sym_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_sp_sym_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p_sp_sym_out()
            END IF
         WHEN "locale" 
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont() 
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gfq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION


FUNCTION p_sp_sym_bp(p_ud)   #顯示單身資料並驅動ACTION
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_gfq TO s_gfq.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION locale
         LET g_action_choice="locale"
         EXIT DISPLAY           

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION p_sp_sym_q()   #查詢資料
   CLEAR FORM
   CALL g_gfq.clear()

   CONSTRUCT g_wc2 ON gfq01,gfq02
      FROM s_gfq[1].gfq01,s_gfq[1].gfq02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
	
   END CONSTRUCT

#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --

   CALL p_sp_sym_b_fill(g_wc2)

END FUNCTION


FUNCTION p_sp_sym_b()   #維護單身資料
DEFINE
   l_ac_t           LIKE type_file.num5,   #未取消的ARRAY CNT
   l_n              LIKE type_file.num5,   #檢查重複用
   l_lock_sw        LIKE type_file.chr1,   #單身鎖住否
   p_cmd            LIKE type_file.chr1,   #處理狀態
   l_allow_insert   LIKE type_file.num5,   #可新增否
   l_allow_delete   LIKE type_file.num5    #可刪除否

   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT gfq01,gfq02 FROM gfq_file",
   " WHERE gfq01=? FOR UPDATE"
   
   DECLARE p_sp_sym_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR

   INPUT ARRAY g_gfq WITHOUT DEFAULTS FROM s_gfq.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
         INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)

      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()

         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'

            LET g_before_input_done = FALSE
            CALL p_sp_sym_set_entry(p_cmd)
            CALL p_sp_sym_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
     
            LET g_gfq_t.* = g_gfq[l_ac].*
            OPEN p_sp_sym_bcl USING g_gfq_t.gfq01
            IF STATUS THEN
               CALL cl_err("OPEN p_sp_sym_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_sp_sym_bcl INTO g_gfq[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gfq_t.gfq01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'

         LET g_before_input_done = FALSE
         CALL p_sp_sym_set_entry(p_cmd)
         CALL p_sp_sym_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   
         INITIALIZE g_gfq[l_ac].* TO NULL

         LET g_gfq_t.* = g_gfq[l_ac].*
         CALL cl_show_fld_cont()    
         NEXT FIELD gfq01

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE p_sp_sym_bcl
            CANCEL INSERT
         END IF

         INSERT INTO gfq_file(gfq01,gfq02)
            VALUES(g_gfq[l_ac].gfq01,g_gfq[l_ac].gfq02)

         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfq_file",g_gfq[l_ac].gfq01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE FIELD gfq01   #自動遞增項次值
         IF cl_null(g_gfq[l_ac].gfq01) OR cl_null(g_gfq_t.gfq01) THEN
            SELECT max(gfq01)+1
              INTO g_gfq[l_ac].gfq01
              FROM gfq_file
              
            IF cl_null(g_gfq[l_ac].gfq01) OR g_gfq[l_ac].gfq01 <= 0 THEN
               LET g_gfq[l_ac].gfq01 = 1
            END IF
         END IF

      AFTER FIELD gfq01   #check 編號是否重複
         IF NOT cl_null(g_gfq[l_ac].gfq01) THEN
            IF g_gfq[l_ac].gfq01 != g_gfq_t.gfq01 OR
               g_gfq_t.gfq01 IS NULL THEN
               SELECT count(*) INTO l_n FROM gfq_file
               WHERE gfq01 = g_gfq[l_ac].gfq01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,1)
                  LET g_gfq[l_ac].gfq01 = g_gfq_t.gfq01
                  NEXT FIELD gfq01
               END IF
            END IF
         END IF

      AFTER FIELD gfq02
         IF NOT cl_null(g_gfq[l_ac].gfq02) THEN
            IF NOT cl_null(g_gfq[l_ac].gfq02[2,10]) THEN   #判斷特殊符號的是否只有1個字元
               CALL cl_err('',"azz1159",1)
               LET g_gfq[l_ac].gfq02 = ""   #若超過1個字元，則清空欄位
               NEXT FIELD gfq02
            END IF

            IF g_gfq[l_ac].gfq02 != g_gfq_t.gfq02 OR   #判斷特殊符號是否有重複
               g_gfq_t.gfq02 IS NULL THEN
            SELECT count(*) INTO l_n FROM gfq_file
            WHERE gfq02 = g_gfq[l_ac].gfq02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,1)
                  LET g_gfq[l_ac].gfq02 = ""   #若特殊符號有重複，則清空欄位
                  NEXT FIELD gfq02
               END IF
            END IF 
         END IF
      
      BEFORE DELETE   #是否取消單身
         IF g_gfq_t.gfq01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gfq_file WHERE gfq01 = g_gfq_t.gfq01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gfq_file",g_gfq_t.gfq01,"",SQLCA.sqlcode,"","",1)  
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN   #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gfq[l_ac].* = g_gfq_t.*
            CLOSE p_sp_sym_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_gfq[l_ac].gfq01,-263,0)
            LET g_gfq[l_ac].* = g_gfq_t.*
         ELSE
            UPDATE gfq_file SET gfq01=g_gfq[l_ac].gfq01,
               gfq02=g_gfq[l_ac].gfq02
            WHERE gfq01 = g_gfq_t.gfq01
           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gfq_file",g_gfq_t.gfq01,"",SQLCA.sqlcode,"","",1)  
               LET g_gfq[l_ac].* = g_gfq_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()   # 新增
         #LET l_ac_t = l_ac      # 新增  #FUN-D30034

         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gfq[l_ac].* = g_gfq_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_gfq.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_sp_sym_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      # 新增  #FUN-D30034
         CLOSE p_sp_sym_bcl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
   CLOSE p_sp_sym_bcl
   COMMIT WORK

END FUNCTION

FUNCTION p_sp_sym_b_fill(p_wc2)   #抓取單身資料
DEFINE   p_wc2   LIKE   type_file.chr1000

   LET g_sql =
      "SELECT gfq01,gfq02",
      " FROM gfq_file",
      " WHERE ", p_wc2 CLIPPED,
      " ORDER BY 1"
   PREPARE p_sp_sym_pb FROM g_sql
   DECLARE gfq_curs CURSOR FOR p_sp_sym_pb

   CALL g_gfq.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 

   FOREACH gfq_curs INTO g_gfq[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_gfq.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
END FUNCTION


FUNCTION p_sp_sym_out()   #印出報表
   DEFINE
      l_gfq         RECORD LIKE gfq_file.*,
      l_name        LIKE type_file.chr20     # External(Disk) file name
      
   IF g_wc2 IS NULL THEN 
      CALL cl_err('','9057',0)
      RETURN 
   END IF

   CALL cl_wait()

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

   LET g_sql="SELECT * FROM gfq_file ",   # 組合出 SQL 指令
   " WHERE ",g_wc2 CLIPPED
   PREPARE p_sp_sym_p1 FROM g_sql         # RUNTIME 編譯
   DECLARE p_sp_sym_co                    # SCROLL CURSOR
   CURSOR FOR p_sp_sym_p1

   CALL cl_outnam('p_sp_sym') RETURNING l_name

   START REPORT p_sp_sym_rep TO l_name
 
   FOREACH p_sp_sym_co INTO l_gfq.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT p_sp_sym_rep(l_gfq.*)
   END FOREACH

   FINISH REPORT p_sp_sym_rep
   CLOSE p_sp_sym_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION


REPORT p_sp_sym_rep(sr)   #設定報表格式
   DEFINE
      l_trailer_sw   LIKE type_file.chr1,
      sr RECORD LIKE gfq_file.*
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line

   ORDER BY sr.gfq01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         PRINT g_head CLIPPED,pageno_total
         PRINT g_dash[1,1]
         PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
         PRINT g_dash1
         LET l_trailer_sw = 'y'

      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.gfq01,
              COLUMN g_c[32],sr.gfq02

      ON LAST ROW
         PRINT g_dash[1,1]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT


FUNCTION p_sp_sym_set_entry(p_cmd)   #設定欄位可輸入
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gfq01",TRUE)
   END IF
   

END FUNCTION

FUNCTION p_sp_sym_set_no_entry(p_cmd)   #設定欄位不可輸入
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("gfq01",FALSE)
   END IF

END FUNCTION
