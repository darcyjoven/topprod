# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: agli940.4gl
# Date & Author..: 12/03/07 By Lori(FUN-BC0123)
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BC0123
DEFINE 
    g_giq           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
       giq01           LIKE giq_file.giq01,   #群組代碼
       giq02           LIKE giq_file.giq02,   #說明
       giq03           LIKE giq_file.giq03,   #變動分類
       giq04           LIKE giq_file.giq04
                    END RECORD,
    g_giq_t         RECORD                    #程式變數 (舊值)
       giq01           LIKE giq_file.giq01,   #群組代碼
       giq02           LIKE giq_file.giq02,   #說明
       giq03           LIKE giq_file.giq03,   #變動分類
       giq04           LIKE giq_file.giq04    #行次
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,                #單身筆數
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_argv1      LIKE type_file.chr1

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW i940_w AT p_row,p_col
   WITH FORM "agl/42f/agli940"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()

   LET g_wc2 = '1=1'

   CALL i940_b_fill(g_wc2)

   CALL i940_menu()

   CLOSE WINDOW i940_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION i940_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i940_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i940_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i940_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i940_out()
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_giq[l_ac].giq01 IS NOT NULL THEN
                  LET g_doc.column1 = "giq01"
                  LET g_doc.value1 = g_giq[l_ac].giq01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_giq),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i940_q()

   CALL i940_b_askkey()

END FUNCTION

FUNCTION i940_b()
DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,      #檢查重複用
       l_lock_sw       LIKE type_file.chr1,      #單身鎖住否
       p_cmd           LIKE type_file.chr1,      #處理狀態
       l_possible      LIKE type_file.num5,      #用來設定判斷重複的可能性
       l_allow_insert  LIKE type_file.chr1,      #可新增否
       l_allow_delete  LIKE type_file.chr1       #可刪除否
DEFINE l_giq04         LIKE giq_file.giq04

   IF s_shut(0) THEN RETURN END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT giq01,giq02,giq03,giq04",
                      "   FROM giq_file ",
                      "  WHERE giq01 = ? FOR UPDATE "
   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   

   DECLARE i940_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_giq WITHOUT DEFAULTS FROM s_giq.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL i940_set_entry(p_cmd)
            CALL i940_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_giq_t.* = g_giq[l_ac].*  #BACKUP
            OPEN i940_bcl USING g_giq_t.giq01
            IF STATUS THEN
               CALL cl_err("OPEN i940_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i940_bcl INTO g_giq[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_giq_t.giq01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET  g_before_input_done = FALSE
         CALL i940_set_entry(p_cmd)
         CALL i940_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
         INITIALIZE g_giq[l_ac].* TO NULL
         LET g_giq[l_ac].giq03 = '1'
         LET g_giq[l_ac].giq04 = '1'       #Body default
         LET g_giq_t.* = g_giq[l_ac].*     #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD giq01

      AFTER FIELD giq01                    #check 編號是否重複
         IF g_giq[l_ac].giq01 != g_giq_t.giq01 OR
            (g_giq[l_ac].giq01 IS NOT NULL AND g_giq_t.giq01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM giq_file
             WHERE giq01 = g_giq[l_ac].giq01
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_giq[l_ac].giq01 = g_giq_t.giq01
               NEXT FIELD giq01
            END IF
         END IF

      AFTER FIELD giq03
         IF g_giq[l_ac].giq03 NOT MATCHES '[123456]' OR
            cl_null(g_giq[l_ac].giq03) THEN
            LET g_giq[l_ac].giq03 = g_giq_t.giq03
            NEXT FIELD giq03
         END IF
      
      AFTER FIELD giq04
         IF g_giq[l_ac].giq04 < 0 THEN
            CALL cl_err(g_giq[l_ac].giq04,'agl-888',1)
            NEXT FIELD giq04
         END IF               

      BEFORE DELETE                            #是否取消單身
         IF g_giq_t.giq01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL
            LET g_doc.column1 = "giq01"
            LET g_doc.value1 = g_giq[l_ac].giq01
            CALL cl_del_doc()
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM giq_file 
             WHERE giq01 = g_giq_t.giq01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","giq_file",g_giq_t.giq01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK 
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_giq[l_ac].* = g_giq_t.*
            CLOSE i940_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_giq[l_ac].giq01,-263,1)
            LET g_giq[l_ac].* = g_giq_t.*
         ELSE
            UPDATE giq_file SET giq01 = g_giq[l_ac].giq01
                               ,giq02 = g_giq[l_ac].giq02
                               ,giq03 = g_giq[l_ac].giq03
                               ,giq04 = g_giq[l_ac].giq04
             WHERE giq01 = g_giq_t.giq01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","giq_file",g_giq_t.giq01,"",SQLCA.sqlcode,"","",1)
               LET g_giq[l_ac].* = g_giq_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_giq[l_ac].* = g_giq_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_giq.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i940_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i940_bcl
         COMMIT WORK

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i940_bcl
         END IF
         INSERT INTO giq_file(giq01,giq02,giq03,giq04)
                       VALUES(g_giq[l_ac].giq01,g_giq[l_ac].giq02
                             ,g_giq[l_ac].giq03,g_giq[l_ac].giq04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","giq_file",g_giq[l_ac].giq01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(giq01) AND l_ac > 1 THEN
            LET g_giq[l_ac].* = g_giq[l_ac-1].*
            NEXT FIELD giq01
         END IF

      ON ACTION CONTROLZ
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
       
   END INPUT

   CLOSE i940_bcl
   COMMIT WORK 

END FUNCTION

FUNCTION i940_b_askkey()

   CLEAR FORM
   CALL g_giq.clear()

   CONSTRUCT g_wc2 ON giq01,giq02,giq03,giq04
        FROM s_giq[1].giq01,s_giq[1].giq02,s_giq[1].giq03,s_giq[1].giq04
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
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   
   CALL i940_b_fill(g_wc2)
   
END FUNCTION

FUNCTION i940_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2    LIKE type_file.chr1000
DEFINE l_cmd    LIKE type_file.chr1000
DEFINE l_giq04  LIKE giq_file.giq04

   LET g_sql = "SELECT giq01,giq02,giq03,giq04 ",
               " FROM giq_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY giq01"
   PREPARE i940_pb FROM g_sql
   DECLARE giq_curs CURSOR FOR i940_pb

   CALL g_giq.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 

   FOREACH giq_curs INTO g_giq[g_cnt].*   #單身 ARRAY 填充
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

   CALL g_giq.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i940_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_giq TO s_giq.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
   
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION i940_out()
DEFINE l_cmd  LIKE type_file.chr1000  
   IF g_wc2 IS NULL THEN 
      CALL cl_err('','9057',0)
      RETURN 
   END IF
   IF g_argv1 = '1' THEN
      LET l_cmd = 'p_query "agli940" "',g_wc2 CLIPPED,'"'
   END IF
   CALL cl_cmdrun(l_cmd)
   RETURN
END FUNCTION

FUNCTION i940_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("giq01",TRUE)
   END IF
END FUNCTION

FUNCTION i940_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("giq01",FALSE)
   END IF
END FUNCTION
