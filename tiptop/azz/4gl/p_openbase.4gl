# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_openbase.4gl
# Descriptions...: 開帳資料設定作業
# Input parameter:
# Date & Author..: FUN-810012 08/03/13 By ice 作業新增
# Modify.........: No.FUN-8A0021 08/10/06 By douzh 若型態為日期,
#                  且資料類型為1.預設值,則自動給資料預設值為當天日期
#                  08/10/20 匯出excel時再多匯出型態和長度
#                  08/11/18 更改p_openbase單身一和單身二都可新增和修改,但不可刪除
#                  08/11/19 匯出excel時再多匯出NOT NULL和是否為primary key
# Modify.........: No.FUN-8A0050 08/10/28 By Nicola
# Modify.........: No.FUN-910030 09/01/12 By douzh 加上運行前開啟aoos901和選擇資料庫功能
# Modify.........: No.FUN-980014 09/08/04 By rainy GP5.2 新增抓取 g_legal 值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-9B0082 09/11/17 By liuxqa standard sql
# Modify.........: No.FUN-A50026 10/05/12 By Jay cl_get_column_info傳入參數修改 
# Modify.........: No.FUN-A90024 10/12/01 By Jay 1.修改Oracle SQL語法多一個逗點
#                                                2.調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.MOD-B50029 11/05/05 By lilingyu 單身二應該可以刪除資料
# Modify.........: No.FUN-B80037 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-B90041 11/09/05 By minpp 程序撰写规范修改 
# Modify.........: No:FUN-9B0110 12/07/30 By Sakura 於EXCEL匯入時多放第四列為額外說明欄位資訊
# Modify.........: No:FUN-CB0015 12/11/05 By amdo 調整excel活頁簿名稱改為抓取系統預設的方式;匯出excle時mkdir.bat目的路徑指定為c:\tiptop
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
   g_zoa           DYNAMIC ARRAY OF RECORD 
       zoa01       LIKE zoa_file.zoa01,   #資料類型
       zoa03       LIKE zoa_file.zoa03,   #資料代號
       gaz03       LIKE gaz_file.gaz03,   #資料內容
       zoa04       LIKE zoa_file.zoa04,   #單別
       zoa05       LIKE zoa_file.zoa05,   #最後匯入日期
       zoa06       LIKE zoa_file.zoa06,   #最後匯入者
       zoa07       LIKE zoa_file.zoa07    #匯入筆數
                   END RECORD,
   g_zoa_t         RECORD                 #程式變數 (舊值)
       zoa01       LIKE zoa_file.zoa01,   #資料類型
 
       zoa03       LIKE zoa_file.zoa03,   #資料代號
       gaz03       LIKE gaz_file.gaz03,   #資料內容
       zoa04       LIKE zoa_file.zoa04,   #單別
       zoa05       LIKE zoa_file.zoa05,   #最後匯入日期
       zoa06       LIKE zoa_file.zoa06,   #最後匯入者
       zoa07       LIKE zoa_file.zoa07    #匯入筆數
                   END RECORD,
   g_zob           DYNAMIC ARRAY OF RECORD 
       zob02       LIKE zob_file.zob02,   #檔案代號
       gat03       LIKE gat_file.gat03,   #檔案名稱
       zob05       LIKE zob_file.zob05,   #僅會出人工輸入欄位
       zob06       LIKE zob_file.zob06
                   END RECORD,
   g_zob_t         RECORD                 #程式變數 (舊值)
       zob02       LIKE zob_file.zob02,   #檔案代號
       gat03       LIKE gat_file.gat03,   #檔案名稱
       zob05       LIKE zob_file.zob05,   #僅會出人工輸入欄位
       zob06       LIKE zob_file.zob06
                   END RECORD,
   g_ss            LIKE type_file.chr1,
   g_wc,g_sql      STRING,
   g_wc2           STRING,
   g_rec_b         LIKE type_file.num5,   #單身筆數
   l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT
   g_rec_b2        LIKE type_file.num5,   #單身筆數
   l_ac2           LIKE type_file.num5    #目前處理的ARRAY CNT
 
#主程式開始
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_i                  LIKE type_file.num5
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_str                STRING            
DEFINE g_flag_xls           LIKE type_file.chr1   #是否是第一次生成xls資料 Y:是 N:否
DEFINE g_db_type            LIKE type_file.chr3   #No.FUN-910030
DEFINE g_pid                STRING                #No.FUN-910030
DEFINE g_tcp_servername     LIKE type_file.chr30  #No.FUN-910030
DEFINE l_sheet              STRING                #sheetname modify    #FUN-CB0015
 
MAIN
  DEFINE p_row,p_col     LIKE type_file.num5
 
  OPTIONS
     INPUT NO WRAP
  DEFER INTERRUPT
 
  LET g_db_type = cl_db_get_database_type()        #No.FUN-910030
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (NOT cl_setup("AZZ")) THEN
     EXIT PROGRAM
  END IF
 
 
  CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
  LET g_pid= FGL_GETPID()                        #No.FUN-910030
  LET p_row = 4 LET p_col = 30
 
  OPEN WINDOW p_openbase_w AT p_row,p_col
       WITH FORM "azz/42f/p_openbase"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  CALL cl_ui_init()
 
  CALL p_openbase_select_db("close")     #No.FUN-910030
 
  CALL p_openbase_q()
 
  CALL p_openbase_menu()
 
  CLOSE WINDOW p_openbase_w              #結束畫面
  CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p_openbase_curs()
 
   CLEAR FORM                             #清除畫面
 
   CALL g_zoa.clear()
 
   CALL g_zob.clear()
 
   CONSTRUCT g_wc ON zoa01,zoa03,zoa04,zoa05,zoa06,zoa07
        FROM s_zoa[1].zoa01,s_zoa[1].zoa03,s_zoa[1].zoa04,
             s_zoa[1].zoa05,s_zoa[1].zoa06,s_zoa[1].zoa07
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(zoa03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zoa"
               LET g_qryparam.state  = "c" 
               LET g_qryparam.arg1  = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zoa03
               NEXT FIELD zoa03
            OTHERWISE
               EXIT CASE
         END CASE           
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   #No.FUN-8A0021--begin
   CONSTRUCT g_wc2 ON zob02,zob05,zob06
        FROM s_zob[1].zob02,s_zob[1].zob05,s_zob[1].zob06
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
   #No.FUN-8A0021--end
 
   IF INT_FLAG THEN RETURN END IF
 
   IF cl_null(g_wc2) THEN LET g_wc2= " 1=1" END IF    #No.FUN-8A0021
 
   CALL p_openbase_b_fill(g_wc,g_wc2)  
   LET l_ac = 1
   CALL p_openbase_b_fill2(" 1=1")   
 
END FUNCTION
 
FUNCTION p_openbase_menu()
 
   WHILE TRUE
      CALL p_openbase_bp("G")
   
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_openbase_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_openbase_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
#No.FUN-910030--begin
        WHEN "select_db"
           IF cl_chk_act_auth() THEN
              CALL p_openbase_select_db("continue") 
              CALL p_openbase_q()
           END IF
#No.FUN-910030--end
 
#No.FUN-8A0021--begin
         WHEN "field_set"
            IF cl_chk_act_auth() THEN
               CALL p_openbase_table()
            END IF
#No.FUN-8A0021--end
         WHEN "detail_2"
            IF cl_chk_act_auth() THEN
               CALL p_openbase_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
#No.FUN-8A0021--begin
#        WHEN "field_set"
#           IF cl_chk_act_auth() THEN
#              CALL p_openbase_table()
#           END IF
#No.FUN-8A0021--end
         WHEN "outtoexcel"
            IF cl_chk_act_auth() THEN
               CALL p_openbase_outtoexcel()
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_openbase_zoa03(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gaz03   LIKE gaz_file.gaz03   
 
   LET g_errno = ' '
 
   SELECT gaz03 INTO l_gaz03
     FROM gaz_file 
    WHERE gaz01 = g_zoa[l_ac].zoa03
      AND gaz02 = g_lang   
 
   CASE
      WHEN STATUS=100
         LET g_errno = 100
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN 
      LET l_gaz03 = NULL
      LET g_zoa[l_ac].gaz03 = NULL
   END IF
 
   IF p_cmd = 'd' OR g_errno IS NULL THEN
      LET g_zoa[l_ac].gaz03 = l_gaz03
   END IF
 
   DISPLAY BY NAME g_zoa[l_ac].gaz03
 
END FUNCTION
 
FUNCTION p_openbase_zob02(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gat03   LIKE gat_file.gat03   
 
   LET g_errno = ' '
 
   SELECT gat03 INTO l_gat03
     FROM gat_file 
    WHERE gat01 = g_zob[l_ac2].zob02
      AND gat02 = g_lang
 
   CASE
      WHEN STATUS=100      LET g_errno = 100
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN 
      LET l_gat03 = NULL
      LET g_zob[l_ac2].gat03 = NULL
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_zob[l_ac2].gat03 = l_gat03
   END IF
 
   DISPLAY BY NAME g_zob[l_ac2].gat03
 
END FUNCTION
 
#Query 查詢
FUNCTION p_openbase_q()
 
   CALL p_openbase_curs()                    #取得查詢條件
 
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
END FUNCTION
 
#單身
FUNCTION p_openbase_b()
   DEFINE l_ac_t         LIKE type_file.num5            #未取消的ARRAY CNT
   DEFINE l_n            LIKE type_file.num5            #檢查重復用       
   DEFINE l_lock_sw      LIKE type_file.chr1            #單身鎖住否       
   DEFINE p_cmd          LIKE type_file.chr1            #處理狀態         
   DEFINE l_allow_insert LIKE type_file.num5            #可新增否         
   DEFINE l_allow_delete LIKE type_file.num5            #可刪除否         
   DEFINE l_i            LIKE type_file.num5
 
   LET g_action_choice = ""
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT zoa01,zoa03,'',zoa04,zoa05,zoa06,zoa07 FROM zoa_file ",
                      " WHERE zoa01= ? AND zoa03 = ? FOR UPDATE  "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_openbase_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
#No.FUN-8A0021--begin
#  LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
   LET l_allow_insert = cl_detail_input_auth("insert")
#No.FUN-8A0021--end
 
   CALL ui.Interface.refresh()
 
   IF g_rec_b=0 THEN CALL g_zoa.clear() END IF
 
   INPUT ARRAY g_zoa WITHOUT DEFAULTS FROM s_zoa.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'   
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            CALL p_openbase_b_fill2(" 1=1")
            CALL p_openbase_bp2_refresh()
            BEGIN WORK
            LET p_cmd='u'
            LET g_zoa_t.* = g_zoa[l_ac].*      #BACKUP
            OPEN p_openbase_bcl USING g_zoa_t.zoa01,g_zoa_t.zoa03
            IF STATUS THEN
               CALL cl_err("OPEN p_openbase_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_openbase_bcl INTO g_zoa[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zoa_t.zoa04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL p_openbase_zoa03('d')
            END IF
            CALL p_openbase_set_no_required(p_cmd)
            CALL p_openbase_set_required(p_cmd)
            CALL cl_show_fld_cont()
         END IF
 
#No.FUN-8A0021--begin
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zoa[l_ac].* TO NULL      #900423
         LET g_zoa_t.* = g_zoa[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD zoa01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zoa_file(zoa01,zoa02,zoa03,zoa04,zoa05,zoa06,zoa07)
                VALUES(g_zoa[l_ac].zoa01,'Y',g_zoa[l_ac].zoa03,
                       g_zoa[l_ac].zoa04,g_zoa[l_ac].zoa05,g_zoa[l_ac].zoa06,
                       g_zoa[l_ac].zoa07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zoa_file",g_zoa[l_ac].zoa01,g_zoa[l_ac].zoa03,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
#No.FUN-8A0021--end
 
#No.FUN-8A0021--begin
      AFTER FIELD zoa03 
         IF NOT cl_null(g_zoa[l_ac].zoa03) THEN
            CALL p_openbase_zoa03('d')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_zoa[l_ac].zoa03,g_errno,1)
               LET g_zoa[l_ac].zoa03 = g_zoa_t.zoa03
               NEXT FIELD zoa03
            END IF 
         END IF 
#No.FUN-8A0021--end
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zoa[l_ac].* = g_zoa_t.*
            CLOSE p_openbase_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zoa[l_ac].zoa03,-263,1)
            LET g_zoa[l_ac].* = g_zoa_t.*
         ELSE
            UPDATE zoa_file SET zoa03 = g_zoa[l_ac].zoa03,
                                zoa04 = g_zoa[l_ac].zoa04,
                                zoa05 = g_zoa[l_ac].zoa05,
                                zoa06 = g_zoa[l_ac].zoa06,                                  
                                zoa07 = g_zoa[l_ac].zoa07 
                          WHERE zoa01= g_zoa_t.zoa01 
                            AND zoa03= g_zoa_t.zoa03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","zoa_file",g_zoa_t.zoa01,g_zoa_t.zoa03,SQLCA.sqlcode,"","",1)
               LET g_zoa[l_ac].* = g_zoa_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zoa[l_ac].* = g_zoa_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zoa.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_openbase_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D30034 add
         CLOSE p_openbase_bcl
         COMMIT WORK
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
#No.FUN-8A0021--begin
      ON ACTION CONTROLP 
         CASE
            WHEN INFIELD(zoa03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1= g_zoa[l_ac].zoa03
               CALL cl_create_qry() RETURNING g_zoa[l_ac].zoa03
               CALL p_openbase_zoa03('d')
               NEXT FIELD zoa03
            OTHERWISE 
               EXIT CASE
         END CASE
#No.FUN-8A0021--end
 
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
                      
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
 
   CLOSE p_openbase_bcl
   COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION p_openbase_b2()
   DEFINE  l_ac2_t        LIKE type_file.num5            #未取消的ARRAY CNT
   DEFINE  l_n            LIKE type_file.num5            #檢查重復用       
   DEFINE  l_lock_sw      LIKE type_file.chr1            #單身鎖住否       
   DEFINE  p_cmd          LIKE type_file.chr1            #處理狀態         
   DEFINE  l_allow_insert LIKE type_file.num5            #可新增否         
   DEFINE  l_allow_delete LIKE type_file.num5            #可刪除否         
 
   LET g_action_choice = ""
 
   IF g_zoa[l_ac].zoa01 IS NULL OR g_zoa[l_ac].zoa03 IS NULL THEN
      RETURN
   END IF
 
   IF l_ac < 1 OR l_ac > g_rec_b THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT zob02,'',zob05,zob06 FROM zob_file ",
                      " WHERE zob01= ? AND zob02 = ?  FOR UPDATE  "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_openbase_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac2_t = 0
#No.FUN-8A0021--begin
#  LET l_allow_insert = FALSE
#  LET l_allow_delete = FALSE                              #MOD-B50029
   LET l_allow_delete = cl_detail_input_auth("delete")     #MOD-B50029
   LET l_allow_insert = cl_detail_input_auth("insert")
#No.FUN-8A0021--end
 
   INPUT ARRAY g_zob WITHOUT DEFAULTS FROM s_zob.*
      ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b2!=0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'   
         LET l_n  = ARR_COUNT()
         IF g_rec_b2 >= l_ac2 THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zob_t.* = g_zob[l_ac2].*  #BACKUP
            OPEN p_openbase_bcl2 USING g_zoa[l_ac].zoa03,g_zob_t.zob02
            IF STATUS THEN
               CALL cl_err("OPEN p_openbase_bcl2:", STATUS, 1)
              LET l_lock_sw = "Y"
            ELSE
               FETCH p_openbase_bcl2 INTO g_zob[l_ac2].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zob_t.zob05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL p_openbase_zob02('d')
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zob[l_ac2].* TO NULL      #900423
         LET g_zob[l_ac2].zob05 = 'Y'
         LET g_zob[l_ac2].zob06=0
         LET g_zob_t.* = g_zob[l_ac2].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD zob02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zob_file(zob01,zob02,zob03,zob04,zob05,zob06)
                VALUES(g_zoa[l_ac].zoa03,g_zob[l_ac2].zob02,'Y','Y',
                       g_zob[l_ac2].zob05,g_zob[l_ac2].zob06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zob_file",g_zoa[l_ac].zoa03,g_zob[l_ac2].zob02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b2=g_rec_b2+1
            DISPLAY g_rec_b2 TO FORMONLY.cn3
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_zob_t.zob02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zob_file
             WHERE zob01 = g_zoa[l_ac].zoa03 
               AND zob02 = g_zob_t.zob02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","zob_file",g_zoa[l_ac].zoa03,g_zob_t.zob02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b2 = g_rec_b2-1
            DISPLAY g_rec_b2 TO FORMONLY.cn3
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zob[l_ac2].* = g_zob_t.*
            CLOSE p_openbase_bcl2
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zob[l_ac2].zob02,-263,1)
            LET g_zob[l_ac2].* = g_zob_t.*
         ELSE
            UPDATE zob_file SET zob02 = g_zob[l_ac2].zob02,
                                zob05 = g_zob[l_ac2].zob05,
                                zob06 = g_zob[l_ac2].zob06
             WHERE zob01 = g_zoa[l_ac].zoa03
               AND zob02 = g_zob_t.zob02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","zob_file",g_zoa[l_ac].zoa03,g_zob_t.zob02,SQLCA.sqlcode,"","",1)
               LET g_zob[l_ac2].* = g_zob_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac2 = ARR_CURR()
#        LET l_ac2_t = l_ac2           #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zob[l_ac2].* = g_zob_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zob.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail_2"
                  LET l_ac2 = l_ac2_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_openbase_bcl2
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac2_t = l_ac2           #FUN-D30034 add
         CLOSE p_openbase_bcl2
         COMMIT WORK
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
                      
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
   
   CLOSE p_openbase_bcl2
   COMMIT WORK
END FUNCTION
 
FUNCTION p_openbase_b_fill(p_wc,p_wc2)              #BODY FILL UP
   DEFINE p_wc     STRING
   DEFINE p_wc2    STRING
   DEFINE l_i      LIKE type_file.num10
 
   IF p_wc2 = " 1=1" THEN
      LET g_sql ="SELECT zoa01,zoa03,'',zoa04,zoa05,zoa06,zoa07 FROM zoa_file ",
                 " WHERE ",p_wc CLIPPED,
                 " ORDER BY zoa01,zoa03"
   ELSE
      LET g_sql ="SELECT zoa01,zoa03,'',zoa04,zoa05,zoa06,zoa07 FROM zoa_file,zob_file ",
                 " WHERE ",p_wc CLIPPED,
                 "   AND zob01=zoa03",
                 "   AND ",p_wc2 CLIPPED,
                 " ORDER BY zoa01,zoa03"
   END IF
 
   PREPARE p_openbase_p2 FROM g_sql           #預備一下
   DECLARE zoa_curs CURSOR FOR p_openbase_p2
 
   CALL g_zoa.clear()
 
   LET l_i = 1
   FOREACH zoa_curs INTO g_zoa[l_i].*         #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT gaz03 INTO g_zoa[l_i].gaz03
        FROM gaz_file
       WHERE gaz01 = g_zoa[l_i].zoa03
         AND gaz02 = g_lang 
      LET l_i = l_i + 1 
      IF l_i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_zoa.deleteElement(l_i)
 
   LET g_rec_b = l_i - 1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
 
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_openbase_b_fill2(p_wc2)              #BODY FILL UP
   DEFINE p_wc2     STRING
 
   LET g_sql ="SELECT zob02,'',zob05,zob06 FROM zob_file ",
              " WHERE zob01  = '",g_zoa[l_ac].zoa03,"'",
              "   AND ",p_wc2 CLIPPED,
              " ORDER BY zob02"
 
   PREPARE p_openbase_pb2 FROM g_sql      #預備一下
   DECLARE zob_curs CURSOR FOR p_openbase_pb2
 
   CALL g_zob.clear()
 
   LET g_cnt = 1
   FOREACH zob_curs INTO g_zob[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gat03 INTO g_zob[g_cnt].gat03
        FROM gat_file
       WHERE gat01=g_zob[g_cnt].zob02
         AND gat02=g_lang
 
      LET g_cnt = g_cnt + 1 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zob.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_openbase_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
#  IF p_ud <> "G" OR g_action_choice = "detail" THEN            #FUN-D30034 mark 
   IF p_ud <> "G" OR g_action_choice = "detail" OR g_action_choice = "detail_2" THEN  #FUN-D30034 add
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zoa TO s_zoa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
       # CALL cl_navigator_setting( g_curs_index, g_row_count )
       # IF g_row_count > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
       # END IF
 
      BEFORE ROW
        #IF g_row_count > 0 THEN
            LET l_ac = ARR_CURR()
            IF l_ac = 0 THEN
               LET l_ac = 1
            END IF
            CALL p_openbase_b_fill2(" 1=1")
            CALL p_openbase_bp2_refresh()
        #END IF
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#No.FUN-8A0021--begin
      ON ACTION field_set 
         LET g_action_choice="field_set"
         EXIT DISPLAY
#No.FUN-8A0021--end
 
      ON ACTION detail_2
         LET g_action_choice="detail_2"
         LET l_ac2 = 1
         EXIT DISPLAY
 
#No.FUN-910030--begin
       ON ACTION select_db
          LET g_action_choice="select_db"
          EXIT DISPLAY
#No.FUN-910030--end
 
#No.FUN-8A0021--begin
#     ON ACTION field_set 
#        LET g_action_choice="field_set"
#        EXIT DISPLAY
#No.FUN-8A0021--end
 
#單身二顯示
#     ON ACTION qry_condition_detail
#        LET g_action_choice="qry_condition_detail"
#        EXIT DISPLAY
        
      ON ACTION outtoexcel 
         LET g_action_choice = 'outtoexcel'
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_openbase_bp2_refresh()
 
   DISPLAY ARRAY g_zob TO s_zob.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
END FUNCTION
 
FUNCTION p_openbase_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_zob TO s_zob.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
         
      BEFORE DISPLAY
         CALL fgl_set_arr_curr(l_ac2)
         
      ON ACTION field_set 
         LET g_action_choice = 'field_set'
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
END FUNCTION
 
FUNCTION p_openbase_set_no_required(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  
# CALL cl_set_comp_required("zoa04",FALSE)         #No.FUN-8A0021
END FUNCTION
 
FUNCTION p_openbase_set_required(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
# CALL cl_set_comp_required("zoa04",TRUE)          #No.FUN-8A0021
END FUNCTION
 
FUNCTION p_openbase_outtoexcel()
   DEFINE l_zoa03   LIKE zoa_file.zoa03
   DEFINE l_zob02   LIKE zob_file.zob02
   DEFINE l_zob05   LIKE zob_file.zob05
   DEFINE l_cnt1    LIKE type_file.num5
   DEFINE l_cnt2    LIKE type_file.num5
   DEFINE l_cnt3    LIKE type_file.num5            #No.FUN-8A0021
   DEFINE l_string  LIKE type_file.chr1000
   DEFINE li_result LIKE type_file.chr1 
   DEFINE l_n       LIKE type_file.num5            #檢查重復用       
 
   IF g_zoa[l_ac].zoa01 IS NULL THEN
      RETURN
   END IF
 
  #IF g_row_count < 1 THEN
  #   RETURN
  #END IF
 
   CALL fgl_set_arr_curr(l_ac)
   IF l_ac = 0 THEN
      LET l_ac = 1
   END IF
   LET l_zoa03 = g_zoa[l_ac].zoa03
 
   SELECT COUNT(DISTINCT zob02) INTO l_cnt1
     FROM zob_file
    WHERE zob01 = l_zoa03
      AND zob05 = 'Y'
 
   SELECT COUNT(DISTINCT zob02) INTO l_cnt2
     FROM zob_file,zoc_file
    WHERE zob01 = l_zoa03
      AND zob02 = zoc01
      AND zob05 = 'Y'
 
   IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
   IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
   IF l_cnt1 > 0 AND l_cnt1 <> l_cnt2 THEN 
      CALL cl_err(l_zoa03,'azz-507',1)
      RETURN
   END IF
 
#No.FUN-8A0021--begin
  #SELECT COUNT(zoc01) INTO l_cnt3
  #  FROM zob_file,zoc_file
  # WHERE zob01 = l_zoa03
  #   AND zob02 = zoc01
  #   AND zoc05 = '6'
  #IF l_cnt3 =0 THEN
  #   CALL cl_err(l_zoa03,'azz-525',1)
  ##  RETURN
  #END IF
#No.FUN-8A0021--end
 
   DECLARE p_openbase_to_excel_dec CURSOR FOR
    SELECT zob02,zob05
      FROM zob_file
     WHERE zob01 = l_zoa03
 
   LET g_flag_xls = 'Y'
   LET g_success = 'Y'
 
   FOREACH p_openbase_to_excel_dec INTO l_zob02,l_zob05
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
 
      #-----No.FUN-8A0050-----
      #沒有定義"匯入序號"存放欄位不可匯出
      SELECT COUNT(*) INTO l_n FROM zoc_file
       WHERE zoc01 = l_zob02
         AND zoc05 = '6'
      IF l_n = 0 THEN
         CALL cl_err(l_zob02,'azz-525',1)
        #CALL cl_err(l_zob02,'azz-521',1)
        #EXIT FOREACH
      END IF
      #-----No.FUN-8A0050 END-----
 
      CALL p_openbase_excel_create(l_zoa03,l_zob02,l_zob05)
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
      LET g_flag_xls = 'N'
   END FOREACH
   #刪除模板xls文件
   LET l_string = "del C:\\TIPTOP\\cyclostyle.xls",ASCII 13
   CALL ui.interface.FrontCall('standard','shellexec',[l_string],li_result)
   IF g_success = 'Y' THEN
      CALL cl_err('','azz-520',1)
      CALL cl_err(l_zoa03,'azz-502',1)
   END IF
 
END FUNCTION
 
FUNCTION p_openbase_excel_create(p_zoa03,p_zob02,p_zob05)
   DEFINE p_zoa03   LIKE zoa_file.zoa03    #資料代號
   DEFINE p_zob02   LIKE zob_file.zob02    #檔案代號
   DEFINE p_zob05   LIKE zob_file.zob05    #僅輸入人工輸入字段
   DEFINE l_fname   LIKE type_file.chr50   #本次匯出檔名
   DEFINE l_dir1    LIKE type_file.chr50  
   DEFINE l_channel base.Channel
   DEFINE l_string  LIKE type_file.chr1000
   DEFINE unix_path LIKE type_file.chr1000
   DEFINE window_path LIKE type_file.chr1000
   DEFINE l_cmd     LIKE type_file.chr50  
   DEFINE li_result LIKE type_file.chr1 
   DEFINE l_column  DYNAMIC ARRAY of RECORD 
            col0    LIKE type_file.chr50, #本字段的數據類型 
            col1    LIKE gaq_file.gaq01,
            col2    LIKE gaq_file.gaq03,  #No.FUN-8A0021
            col7    LIKE gaq_file.gaq05,  #FUN-9B0110 add #額外說明
            col3    LIKE zoc_file.zoc03,  #No.FUN-8A0021  #型態
            col4    LIKE zoc_file.zoc04,  #No.FUN-8A0021  #長度
            col5    LIKE type_file.chr8,  #No.FUN-8A0021  #是否為NOT NULL欄位
            col6    LIKE type_file.chr12  #No.FUN-8A0021  #是否為primary key
                    END RECORD
   DEFINE l_zoc05   LIKE zoc_file.zoc05   #本字段的數據類型
   DEFINE l_gae02   LIKE gae_file.gae02   #字段名稱
   DEFINE l_cnt3    LIKE type_file.num5
   DEFINE li_i      LIKE type_file.num5
   DEFINE ls_cell   STRING
   DEFINE ls_value  STRING
   DEFINE l_data_length  LIKE type_file.num5      #No.FUN-8A0021
   DEFINE l_data_scale   LIKE type_file.num5      #No.FUN-8A0021
   DEFINE l_str          STRING                   #No.FUN-8A0021
   DEFINE l_data_notnull LIKE type_file.chr1      #No.FUN-8A0021
   DEFINE l_n            LIKE type_file.num5      #No.FUN-8A0021
   DEFINE l_azw05        LIKE azw_file.azw05      #FUN-A50026
 
   LET l_fname = g_dbs CLIPPED,'_',p_zoa03 CLIPPED,'_',p_zob02 CLIPPED
 
   IF p_zob05 = 'Y' THEN
#     LET g_sql = "SELECT zoc02 ",                       #No.FUN-8A0021 
      LET g_sql = "SELECT zoc02,zoc03,zoc04,'','' ",     #No.FUN-8A0021
                  " FROM zoc_file ",
                " WHERE zoc01 = '",p_zob02 CLIPPED,"' ",
                "   AND zoc05 IN ('0','5') ",   #'0'表示其為人工輸入欄位 '5'表示其為舊系統單號
                " ORDER BY zoc02 "
   ELSE
#     LET g_sql = "SELECT LOWER(column_name) ",                                #No.FUN-8A0021
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      ##FUN-9B0082 mod --begin
      #CASE g_db_type
      #    WHEN "ORA"
      #      #LET g_sql = "SELECT LOWER(column_name),data_type,",                      #No.FUN-8A0021
      #      LET g_sql = "SELECT LOWER(column_name),'','',",                      #No.FUN-8A0021
      #                  #"to_char(decode(data_precision,null,data_length,data_precision),'9999.99')",  #No.FUN-8A0021
      #                  ",data_scale,nullable " 
      #                  " FROM all_tab_columns ",
      #                  " WHERE LOWER(table_name) = '",p_zob02 CLIPPED,"'",
      #                # " AND owner = UPPER('",g_dbs CLIPPED,"') ",
      #                  " AND owner = 'DS' ",
      #                  " ORDER BY column_id "
      #    WHEN "IFX"
      #      #LET g_sql = "SELECT b.colname,b.coltype,b.collength,'','' ",
      #      LET g_sql = "SELECT b.colname,b.coltype,'','','' ",
      #                  "  FROM systables a,syscolumns b",
      #                  " WHERE a.tabname = '",p_zob02 CLIPPED,"'",
      #                  "   AND a.tabid = b.tabid",
      #                  " ORDER BY colno"
      #    WHEN "MSV"
      #      #LET g_sql = "SELECT a.name, b.name,a.max_length,a.scale,a.isnullable ",
      #      LET g_sql = "SELECT a.name, '','',a.scale,a.isnullable ",
      #                  "  FROM sys.all_columns a,sys.types b ",
      #                  " WHERE a.object_id = object_id('",p_zob02 CLIPPED,"')",
      #                  "   AND a.system_type_id = b.user_type_id ",
      #                  " ORDER BY column_id"   
      #END CASE
      ##FUN-9B0082 mod --end
      LET g_sql = "SELECT sch02, '', '', '', '' FROM sch_file ",
                  "  WHERE sch01 = '",p_zob02 CLIPPED,"'",
                  "  ORDER BY sch05"
      #---FUN-A90024---end-------
   END IF
 
   LET l_cnt3 = 1
   PREPARE p_openbase_prepare2 FROM g_sql 
   DECLARE p_openbase_curs2 CURSOR FOR p_openbase_prepare2
 
#  FOREACH p_openbase_curs2 INTO l_column[l_cnt3].col1                             #No.FUN-8A0021
   FOREACH p_openbase_curs2 INTO l_column[l_cnt3].col1,l_column[l_cnt3].col3,      #No.FUN-8A0021
                                 l_data_length,l_data_scale,                       #No.FUN-8A0021
                                 l_data_notnull                                    #No.FUN-8A0021
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
      #---FUN-A90024---start-----
      #統一用cl_get_column_info來取得欄位資訊
      ##FUN-9B0082 --begin
      #IF g_db_type="IFX" THEN
      #   LET l_data_scale = 0
      #   IF l_column[l_cnt3].col3>=256 THEN
      #      LET l_data_notnull = 'Y'
      #   END IF
      #   IF l_column[l_cnt3].col3=5 or l_column[l_cnt3].col3=261 THEN 
      #      LET l_data_scale = l_column[l_cnt3].col3 mod 16
      #   END IF
      #   CALL s_get_azw05(g_plant) RETURNING l_azw05                              #FUN-A50026
      #   #CALL cl_get_column_info(g_dbs,p_zob02,l_column[l_cnt3].col1)
      #   CALL cl_get_column_info(l_azw05,p_zob02,l_column[l_cnt3].col1)           #FUN-A50026 
      #     RETURNING l_column[l_cnt3].col3,l_data_length          
      #ELSE
      #   IF l_data_notnull=0 THEN
      #      LET l_data_notnull='Y'
      #   ELSE
      #      IF l_data_notnull=1 THEN
      #         LET l_data_notnull='N'
      #      ELSE
      #         IF l_data_notnull='Y' THEN
      #            LET l_data_notnull='N'
      #         ELSE
      #            LET l_data_notnull='Y'
      #         END IF
      #      END IF
      #   END IF
      #   CALL s_get_azw05(g_plant) RETURNING l_azw05                              #FUN-A50026
      #   #CALL cl_get_column_info(g_dbs,p_zob02,l_column[l_cnt3].col1)
      #   CALL cl_get_column_info(l_azw05,p_zob02,l_column[l_cnt3].col1)           #FUN-A50026
      #   RETURNING l_column[l_cnt3].col3,l_data_length
      #END IF
      ##FUN-9B0082 --end
      CALL s_get_azw05(g_plant) RETURNING l_azw05
      CALL cl_get_column_info(l_azw05, p_zob02, l_column[l_cnt3].col1)    
           RETURNING l_column[l_cnt3].col3, l_column[l_cnt3].col4
      #---FUN-A90024---end-------
      SELECT zoc05 INTO l_zoc05
        FROM zoc_file
       WHERE zoc01 = p_zob02
         AND zoc02 = l_column[l_cnt3].col1
      IF cl_null(l_zoc05) THEN
         LET l_zoc05 = '0'
      END IF
      LET l_gae02 = 'zoc05_',l_zoc05
      SELECT gae04 INTO l_column[l_cnt3].col0
        FROM gae_file
       WHERE gae01 = 'p_opentb'
         AND gae03 = g_lang
         AND gae02 = l_gae02
       
      SELECT gaq03 INTO l_column[l_cnt3].col2
        FROM gaq_file
       WHERE gaq01 = l_column[l_cnt3].col1
         AND gaq02 = g_lang

#FUN-9B0110---add---START
      SELECT gaq05 INTO l_column[l_cnt3].col7
        FROM gaq_file
       WHERE gaq01 = l_column[l_cnt3].col1
         AND gaq02 = g_lang
      CALL cl_replace_str(l_column[l_cnt3].col7,'\n',' ') RETURNING l_column[l_cnt3].col7
#FUN-9B0110---add-----END
 
      #No.FUN-8A0021--begin
      #---FUN-A90024---start-----
      #已在上面用cl_get_column_info()取代取得欄位長度資料
      #IF l_column[l_cnt3].col3 = 'NUMBER' AND NOT cl_null(l_data_scale) THEN
      #   IF l_data_scale= 0 THEN
      #      LET l_column[l_cnt3].col4= l_data_length
      #   ELSE
      #      LET l_str = l_data_length USING "<<<<<<<<",",",l_data_scale USING "<<<<<<<<"
      #      LET l_column[l_cnt3].col4= l_str CLIPPED
      #   END IF
      #ELSE
      #   LET l_column[l_cnt3].col4 = l_data_length USING "<<<<<<<<"
      #END IF
       
      #IF p_zob05 = 'Y' THEN
      #   SELECT nullable INTO l_data_notnull
      #     FROM user_tab_columns
      #    WHERE LOWER(table_name)  = p_zob02 
      #      AND LOWER(column_name) = l_column[l_cnt3].col1 
      #END IF
      LET l_data_notnull = cl_get_column_notnull(p_zob02, l_column[l_cnt3].col1)
      #---FUN-A90024---end------- 
      
      #IF l_data_notnull = 'N' THEN              #FUN-A90024 mark 因改用cl_get_column_notnull()判斷,not null傳回值是'Y'
      IF l_data_notnull = 'Y' THEN               #FUN-A90024
         LET l_column[l_cnt3].col5 ='not null'
      ELSE
         LET l_column[l_cnt3].col5 = NULL 
      END IF
 
      SELECT COUNT(*) INTO l_n FROM user_ind_columns,user_indexes 
       WHERE LOWER(user_indexes.table_name) = p_zob02
         AND uniqueness='UNIQUE'
         AND user_ind_columns.index_name=user_indexes.index_name
         AND LOWER(column_name)= l_column[l_cnt3].col1
      IF l_n > 0 THEN
         LET l_column[l_cnt3].col6 = 'primary key'
      ELSE
         LET l_column[l_cnt3].col6 = NULL
      END IF
      #No.FUN-8A0021--end
 
      LET l_cnt3 = l_cnt3 + 1
   END FOREACH
   CALL l_column.deleteElement(l_cnt3)
   LET l_cnt3 = l_cnt3 - 1
 
   IF g_flag_xls = 'Y' THEN
      CALL cl_err('','azz-519',1)
 
      #首先強制創建excel。 --> [如果同名的excel已存在,如何處理?]
#     LET unix_path = "$TEMPDIR/cyclostyle.xls"              #No.FUN-8A0021
      LET unix_path = "$TOP/ds4gl2/bin/cyclostyle.xls"       #No.FUN-8A0021
      LET window_path = "C:\\TIPTOP\\cyclostyle.xls"
      LET li_result = cl_download_file(unix_path,window_path)
      IF STATUS THEN
         CALL cl_err('',"amd-021",1)                                                                                         
         DISPLAY "Download fail!!"                                                                                                    
         LET g_success = 'N'
         RETURN
      END IF 
   END IF
 
   LET l_dir1 = FGL_GETENV("TEMPDIR") CLIPPED,'\/',l_fname CLIPPED,'.bat'           #No.FUN-8A0021
#  LET l_dir1 = FGL_GETENV("TOP") CLIPPED,'\/ds4gl2','\/bin','\/',l_fname CLIPPED,'.bat'    #No.FUN-8A0021
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_dir1 CLIPPED,"w")
   LET l_string = "copy C:\\TIPTOP\\cyclostyle.xls C:\\TIPTOP\\",l_fname CLIPPED,".xls",ASCII 13
   CALL l_channel.writeLine(l_string)
   CALL l_channel.close()
 
   LET unix_path = l_dir1
   LET window_path = "C:\\TIPTOP\\mkdir.bat"               #FUN-CB0015
   LET li_result = cl_download_file(unix_path,window_path) #FUN-CB0015
  #LET li_result = cl_download_file(unix_path,'mkdir.bat') #mark by FUN-CB0015
   IF STATUS THEN
      CALL cl_err('',"amd-021",1)                                                                                         
      DISPLAY "Download fail!!"                                                                                                    
      RETURN
   END IF 
 
  #CALL ui.interface.FrontCall('standard','shellexec',['mkdir.bat'],li_result) #mark by FUN-CB0015
   CALL ui.interface.FrontCall('standard','shellexec',[window_path],li_result) #FUN-CB0015
 
   #Excel
   LET l_cmd = "EXCEL C:\\TIPTOP\\",l_fname,".xls"
   CALL ui.Interface.frontCall("standard","shellexec",[l_cmd] ,li_result)
   CALL openbase_checkError(li_result,"Open File")
   SLEEP 5
   LET l_sheet=cl_getsheetname() CLIPPED ,'1' #FUN-CB0015 自動抓取目前啟動的excel版本預設的sheet name
  #CALL ui.Interface.frontCall("WINDDE","DDEConnect",[l_cmd,"Sheet1"],[li_result])#mark by FUN-CB0015
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",[l_cmd,l_sheet],[li_result]) #FUN-CB0015
   CALL openbase_checkError(li_result,"Connect File")
 
   FOR li_i = 1 TO l_column.getLength()
     LET ls_cell = "R1"|| "C" || li_i
     LET ls_value = l_column[li_i].col0
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
 
     LET ls_cell = "R2"|| "C" || li_i
     LET ls_value = l_column[li_i].col1
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
 
     LET ls_cell = "R3"|| "C" || li_i
     LET ls_value = l_column[li_i].col2
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015

#FUN-9B0110---add---START
     LET ls_cell = "R4"|| "C" || li_i
     LET ls_value = l_column[li_i].col7
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
#FUN-9B0110---add-----END

#No-FUN-8A0021--begin
    #LET ls_cell = "R4"|| "C" || li_i #FUN-9B0110 mark
     LET ls_cell = "R5"|| "C" || li_i #FUN-9B0110 add
     LET ls_value = l_column[li_i].col3
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
 
    #LET ls_cell = "R5"|| "C" || li_i #FUN-9B0110 mark
     LET ls_cell = "R6"|| "C" || li_i #FUN-9B0110 add
     LET ls_value = l_column[li_i].col4
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
 
    #LET ls_cell = "R6"|| "C" || li_i #FUN-9B0110 mark
     LET ls_cell = "R7"|| "C" || li_i #FUN-9B0110 add
     LET ls_value = l_column[li_i].col5
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
 
    #LET ls_cell = "R7"|| "C" || li_i #FUN-9B0110 mark
     LET ls_cell = "R8"|| "C" || li_i #FUN-9B0110 add
     LET ls_value = l_column[li_i].col6
    #CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,"Sheet1",ls_cell,ls_value],[li_result])#mark by FUN-CB0015
     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[l_cmd,l_sheet,ls_cell,ls_value],[li_result]) #FUN-CB0015
#No-FUN-8A0021--end
 
     CALL openbase_checkError(li_result,"Poke Cells")
   END FOR
   #關閉
  #CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,"Sheet1"],[li_result])#mark by FUN-CB0015
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,l_sheet],[li_result]) #FUN-CB0015
   CALL openbase_checkError(li_result,"Finish")
END FUNCTION
 
FUNCTION openbase_checkError(p_result,p_msg)
   DEFINE   p_result   SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  SMALLINT
 
   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  # FUN-B80037--add---
   EXIT PROGRAM
END FUNCTION
 
FUNCTION p_openbase_table()
   DEFINE l_cmd    STRING
   DEFINE l_zoa03  LIKE zoa_file.zoa03
 
   IF g_zoa[l_ac].zoa01 IS NULL THEN
      RETURN
   END IF
 
   IF l_ac > 0 THEN
      LET l_zoa03 = g_zoa[l_ac].zoa03
   ELSE
      RETURN
   END IF
 
   LET l_cmd = "p_opentb ",l_zoa03 CLIPPED
 
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
 
#No.FUN-910030--begin
FUNCTION p_openbase_select_db(ps_str)       
DEFINE l_dbs          LIKE type_file.chr50   
DEFINE l_ch           base.Channel
DEFINE l_aoos901_cmd  STRING
DEFINE ps_str         STRING                
 
 
################ for informix synonym ##############
    IF g_db_type="IFX" THEN
DISCONNECT ALL
DATABASE g_dbs
# CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
 CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
    END IF
####################################################
 
    IF g_action_choice = "create_synonym" THEN 
       IF g_db_type="ORA" THEN
 #        CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
         CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
         CLOSE DATABASE
         DATABASE g_dbs
 #        CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
         CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
       END IF
    ELSE
       LET l_aoos901_cmd="aoos901 '",ps_str,"' '",g_pid CLIPPED,"'"         
       display "l_aoos901_cmd:",l_aoos901_cmd
       CALL cl_cmdrun_wait("aoos901 '"||ps_str||"' '"||g_pid CLIPPED||"'") 
       CALL p_openbase_set_win_title()
    END IF
 
    IF g_db_type="IFX" THEN
       LET l_ch = base.Channel.create()
       CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERALIASES|awk '{ print $2 }'","r")
       WHILE l_ch.read(g_tcp_servername)
             DISPLAY "tcp_servername:",g_tcp_servername
       END WHILE
       CALL l_ch.close()   #FUN-B90041
       LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
CONNECT TO l_dbs AS "MAIN"
       IF status THEN
          CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERNAME|awk '{ print $2 }'","r")
          WHILE l_ch.read(g_tcp_servername)
                DISPLAY "tcp_servername:",g_tcp_servername
          END WHILE
          CALL l_ch.close()   #FUN-B90041
          LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
CONNECT TO l_dbs AS "MAIN"
       END IF
    END IF
 
    CALL p_openbase_b_fill(g_wc,g_wc2)  
    LET l_ac = 1
    CALL p_openbase_b_fill2(" 1=1")   
 
    IF g_db_type="IFX" THEN
 
       CREATE TEMP TABLE tempidx(
              idxname LIKE type_file.chr1000,
              tabid   LIKE type_file.num10, 
              idxtype LIKE type_file.chr1,  
              part1   LIKE type_file.num5,  
              part2   LIKE type_file.num5,  
              part3   LIKE type_file.num5,  
              part4   LIKE type_file.num5,  
              part5   LIKE type_file.num5,  
              part6   LIKE type_file.num5,  
              part7   LIKE type_file.num5,  
              part8   LIKE type_file.num5,  
              part9   LIKE type_file.num5,  
              part10  LIKE type_file.num5,  
              part11  LIKE type_file.num5,  
              part12  LIKE type_file.num5,  
              part13  LIKE type_file.num5,  
              part14  LIKE type_file.num5,  
              part15  LIKE type_file.num5,  
              part16  LIKE type_file.num5,  
              dbname  LIKE type_file.chr20)
       
       CREATE TEMP TABLE tempidx2(
              idxname LIKE type_file.chr1000,
              tabid   LIKE type_file.num10, 
              idxtype LIKE type_file.chr1,  
              part1   LIKE type_file.num5,  
              part2   LIKE type_file.num5,  
              part3   LIKE type_file.num5,  
              part4   LIKE type_file.num5,  
              part5   LIKE type_file.num5,  
              part6   LIKE type_file.num5,  
              part7   LIKE type_file.num5,  
              part8   LIKE type_file.num5,  
              part9   LIKE type_file.num5,  
              part10  LIKE type_file.num5,  
              part11  LIKE type_file.num5,  
              part12  LIKE type_file.num5,  
              part13  LIKE type_file.num5,  
              part14  LIKE type_file.num5,  
              part15  LIKE type_file.num5,  
              part16  LIKE type_file.num5,  
              dbname  LIKE type_file.chr20)
    END IF
 
END FUNCTION
 
FUNCTION p_openbase_set_win_title()
   DEFINE   lc_zo02     LIKE zo_file.zo02,
            lc_zx02     LIKE zx_file.zx02,
            lc_zz02     LIKE zz_file.zz02,
            ls_ze031    LIKE type_file.chr1000,
            ls_ze032    LIKE type_file.chr1000, 
            ls_msg      STRING,
            lwin_curr   ui.Window,
            l_sql       STRING,
            l_ch        base.channel
 
 
   # 選擇  使用者名稱(zx_file.zx02)
   LET l_sql="SELECT zx02,zx08 FROM zx_file WHERE zx01='",
             g_user CLIPPED,"'"
   PREPARE p_openbase_set_win_tit_pre1 FROM l_sql
   EXECUTE p_openbase_set_win_tit_pre1 INTO lc_zx02,g_plant
   IF (SQLCA.SQLCODE) THEN
      LET lc_zx02 = g_user
   END IF
   FREE p_openbase_set_win_tit_pre1
  
   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant  #FUN-980014 add  (抓出該營運中心所屬法人)
  
 
   LET l_ch=base.Channel.create()
   CALL l_ch.openPipe("cat $TEMPDIR/aoos901."||g_pid,"r")
   WHILE l_ch.read(g_plant)
   END WHILE
   CALL l_ch.close()   #FUN-B90041
 
   LET l_sql="SELECT azp03 FROM azp_file WHERE azp01='",
             g_plant CLIPPED,"'"
   PREPARE p_openbase_set_win_tit_pre2 FROM l_sql
   EXECUTE p_openbase_set_win_tit_pre2 INTO g_dbs
   IF (SQLCA.SQLCODE) THEN
      CALL cl_err3("sel","azp_file",g_plant,"",SQLCA.sqlcode,"","azp_file get error", 2)  #No.FUN-660081)   #No.FUN-660081
   END IF
   FREE p_openbase_set_win_tit_pre2
 
#   CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
   CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
   CLOSE DATABASE
   DATABASE g_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
   CALL cl_ins_del_sid(1,g_plant) #FUN-980030   #FUN-990069
   IF (SQLCA.SQLCODE) THEN
      RETURN FALSE
   END IF
 
   # 選擇  程式名稱(gaz_file.gaz03)
   LET l_sql="SELECT gaz03 FROM gaz_file WHERE gaz01='",
             g_prog CLIPPED,"' AND gaz02='",g_lang CLIPPED,"'"
   PREPARE p_openbase_set_win_tit_pre3 FROM l_sql
   EXECUTE p_openbase_set_win_tit_pre3 INTO lc_zz02
   FREE p_openbase_set_win_tit_pre3
 
   # 選擇  公司對內全名(zo_file.zo02)
   LET l_sql="SELECT zo02 FROM zo_file WHERE zo01='",
             g_lang CLIPPED,"'"
   PREPARE p_openbase_set_win_tit_pre4 FROM l_sql
   EXECUTE p_openbase_set_win_tit_pre4 INTO lc_zo02
   IF (SQLCA.SQLCODE) THEN
      LET lc_zo02 = "Empty"
   END IF
   FREE p_openbase_set_win_tit_pre4
 
   LET l_sql="SELECT ze03 FROM ze_file WHERE ze01 = 'lib-035' AND ze02 = '",g_lang CLIPPED,"'"
   PREPARE p_openbase_set_win_tit_pre5 FROM l_sql
   EXECUTE p_openbase_set_win_tit_pre5 INTO ls_ze031
   FREE p_openbase_set_win_tit_pre5
   LET l_sql="SELECT ze03 FROM ze_file WHERE ze01 = 'lib-036' AND ze02 = '",g_lang CLIPPED,"'"
   PREPARE p_openbase_set_win_tit_pre6 FROM l_sql
   EXECUTE p_openbase_set_win_tit_pre6 INTO ls_ze032
   FREE p_openbase_set_win_tit_pre6
 
   LET ls_msg = lc_zz02 CLIPPED, "(", g_prog CLIPPED, ")  [", lc_zo02 CLIPPED, "]", "(", g_dbs CLIPPED, ")"
   LET ls_msg = ls_msg, "  ", ls_ze031 CLIPPED, ":", g_today, "  ", ls_ze032 CLIPPED, ":", lc_zx02 CLIPPED
 
   LET lwin_curr = ui.Window.getCurrent()
   CALL lwin_curr.setText(ls_msg)
END FUNCTION
#No.FUN-910030--end
 
#No.FUN-810012
