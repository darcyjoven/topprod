# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# Pattern name...: axmi223.4gl
# Descriptions...: 客戶交貨運輸天數基本資料維護
# Note...........: 
# Date & Author..: 11/07/18 By belle (FUN-B60011)
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-B60011
DEFINE 
    g_oat DYNAMIC ARRAY OF RECORD          #程式變數(Program Variables)
        oat01       LIKE oat_file.oat01,
        oat02       LIKE oat_file.oat02,
        oat03       LIKE oat_file.oat03,
        oat04       LIKE oat_file.oat04,
        oat05       LIKE oat_file.oat05
                    END RECORD,
    g_oat_t         RECORD                 #程式變數 (舊值)
        oat01       LIKE oat_file.oat01,
        oat02       LIKE oat_file.oat02,
        oat03       LIKE oat_file.oat03,
        oat04       LIKE oat_file.oat04,
        oat05       LIKE oat_file.oat05
                    END RECORD,
    g_wc2,g_sql     string,
    g_rec_b         LIKE type_file.num5,    #單身筆數
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5      

DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt                 LIKE type_file.num10 
DEFINE g_i                   LIKE type_file.num5  #count/index for any purpose        #No.FUN-680137 SMALLINT

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

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

   OPEN WINDOW i223_w AT p_row,p_col WITH FORM "axm/42f/axmi223"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()

   LET g_wc2 = '1=1'

   CALL i223_b_fill(g_wc2)

   CALL i223_menu()

   CLOSE WINDOW i223_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
       RETURNING g_time              

END MAIN

FUNCTION i223_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i223_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i223_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i223_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oat),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i223_q()

   CALL i223_b_askkey()

END FUNCTION

FUNCTION i223_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,                #檢查重複用
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
          p_cmd           LIKE type_file.chr1,                #處理狀態
          l_allow_insert  LIKE type_file.num5,                #可新增否
          l_allow_delete  LIKE type_file.num5                 #可刪除否
   DEFINE l_i             LIKE type_file.num5

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "  SELECT oat01,oat02,oat03,oat04,oat05 FROM oat_file",
                      "  WHERE oat01=? AND oat02=? AND oat03=? AND oat04=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i223_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_oat WITHOUT DEFAULTS FROM s_oat.*
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
            LET g_oat_t.* = g_oat[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i223_bcl USING g_oat_t.oat01,g_oat_t.oat02,g_oat_t.oat03,g_oat_t.oat04
            IF STATUS THEN
               CALL cl_err("OPEN i223_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i223_bcl INTO g_oat[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_oat_t.oat04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i223_set_entry(p_cmd)                                        
            CALL i223_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_oat[l_ac].* TO NULL
         LET g_oat_t.* = g_oat[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i223_set_entry(p_cmd)                                        
         CALL i223_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_oat[l_ac].oat01) THEN  LET g_oat[l_ac].oat01=' ' END IF
         IF cl_null(g_oat[l_ac].oat02) THEN  LET g_oat[l_ac].oat02=' ' END IF
         IF cl_null(g_oat[l_ac].oat03) THEN  LET g_oat[l_ac].oat03=' ' END IF
         INSERT INTO oat_file(oat01,oat02,oat03,oat04,oat05)
              VALUES(g_oat[l_ac].oat01,g_oat[l_ac].oat02,g_oat[l_ac].oat03,
                     g_oat[l_ac].oat04,g_oat[l_ac].oat05)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oat_file",g_oat[l_ac].oat01,g_oat[l_ac].oat02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

     BEFORE FIELD oat01
         CALL i223_set_no_required()

     AFTER FIELD oat01
         IF NOT cl_null(g_oat[l_ac].oat01) THEN
            SELECT COUNT(*) INTO l_n FROM gea_file
             WHERE gea01=g_oat[l_ac].oat01
               AND geaacti='Y'
            IF l_n=0 THEN
               CALL cl_err('','mfg9329',0)
               NEXT FIELD oat01
            END IF
         END IF

     AFTER FIELD oat02
         IF NOT cl_null(g_oat[l_ac].oat02) THEN
            SELECT COUNT(*) INTO l_n FROM geb_file
             WHERE geb01=g_oat[l_ac].oat02
               AND gebacti='Y'
            IF l_n=0 THEN
               CALL cl_err('','mfg9329',0)
               NEXT FIELD oat02
            END IF
         END IF

     AFTER FIELD oat03
         IF NOT cl_null(g_oat[l_ac].oat03) THEN
            SELECT COUNT(*) INTO l_n FROM geo_file
             WHERE geo01=g_oat[l_ac].oat03
               AND geoacti='Y'
            IF l_n=0 THEN
               CALL cl_err('','mfg9329',0)
               NEXT FIELD oat03
            END IF
         END IF

      AFTER FIELD oat04 #check 是否重複
          IF g_oat[l_ac].oat04 IS NOT NULL THEN
             SELECT COUNT(*) INTO l_n FROM oah_file
             WHERE oah01=g_oat[l_ac].oat04
            IF l_n=0 THEN
               CALL cl_err('','9028',0)
               NEXT FIELD oat04
            END IF
            IF g_oat[l_ac].oat04 != g_oat_t.oat04 OR
               (NOT cl_null(g_oat[l_ac].oat04) AND cl_null(g_oat_t.oat04)) THEN
               SELECT count(*) INTO l_n FROM oat_file
                WHERE oat01 = g_oat[l_ac].oat01
                  AND oat02 = g_oat[l_ac].oat02
                  AND oat03 = g_oat[l_ac].oat03
                  AND oat04 = g_oat[l_ac].oat04
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_oat[l_ac].oat04 = g_oat_t.oat04
                  NEXT FIELD oat04
               END IF
            END IF
           #判斷區域別/國別/地區欄位不能皆空白
            IF NOT cl_null(g_oat[l_ac].oat04) THEN
               IF cl_null(g_oat[l_ac].oat01) AND cl_null(g_oat[l_ac].oat02)
                  AND cl_null(g_oat[l_ac].oat03) THEN
                  CALL cl_err('','axm1031',1)
                  NEXT FIELD oat01
               END IF
            END IF
         END IF

     AFTER FIELD oat05
         IF g_oat[l_ac].oat05 < 0 THEN
            CALL cl_err('','atm-114',0)
            NEXT FIELD oat05
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gea'
                 LET g_qryparam.default1 = g_oat[l_ac].oat01
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat01
                 DISPLAY BY NAME g_oat[l_ac].oat01
                 NEXT FIELD oat01

            WHEN INFIELD(oat02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geb'
                 LET g_qryparam.default1 = g_oat[l_ac].oat02
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat02
                 DISPLAY BY NAME g_oat[l_ac].oat02
                 NEXT FIELD oat02

            WHEN INFIELD(oat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geo'
                 LET g_qryparam.default1 = g_oat[l_ac].oat03
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat03
                 DISPLAY BY NAME g_oat[l_ac].oat03
                 NEXT FIELD oat03

            WHEN INFIELD(oat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oah'
                 LET g_qryparam.default1 = g_oat[l_ac].oat04
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat04
                 DISPLAY BY NAME g_oat[l_ac].oat04
                 NEXT FIELD oat04
         END CASE


      BEFORE DELETE                            #是否取消單身 
         IF g_oat_t.oat04 IS NOT NULL THEN
 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
          
            DELETE FROM oat_file WHERE oat01 = g_oat_t.oat01 AND oat02 = g_oat_t.oat02
                                   AND oat03 = g_oat_t.oat03 AND oat04 = g_oat_t.oat04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","oat_file",g_oat_t.oat01,g_oat_t.oat02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i223_bcl
            COMMIT WORK 
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_oat[l_ac].* = g_oat_t.*
            CLOSE i223_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_oat[l_ac].oat02,-263,1)
            LET g_oat[l_ac].* = g_oat_t.*
         ELSE
            IF cl_null(g_oat[l_ac].oat01) THEN  LET g_oat[l_ac].oat01=' ' END IF
            IF cl_null(g_oat[l_ac].oat02) THEN  LET g_oat[l_ac].oat02=' ' END IF
            IF cl_null(g_oat[l_ac].oat03) THEN  LET g_oat[l_ac].oat03=' ' END IF
            IF cl_null(g_oat[l_ac].oat01) AND cl_null(g_oat[l_ac].oat02)
               AND cl_null(g_oat[l_ac].oat03) THEN
               CALL cl_err('','axm1034',1)
               LET g_oat[l_ac].* = g_oat_t.*
            ELSE
               UPDATE oat_file SET
                      oat01 = g_oat[l_ac].oat01,
                      oat02 = g_oat[l_ac].oat02,
                      oat03 = g_oat[l_ac].oat03,
                      oat04 = g_oat[l_ac].oat04,
                      oat05 = g_oat[l_ac].oat05
                WHERE oat01 = g_oat_t.oat01 AND oat02 = g_oat_t.oat02
                  AND oat03 = g_oat_t.oat03 AND oat04 = g_oat_t.oat04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oat_file",g_oat[l_ac].oat01,g_oat_t.oat02,SQLCA.sqlcode,"","",1)
                  LET g_oat[l_ac].* = g_oat_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i223_bcl
                  COMMIT WORK
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_oat[l_ac].* = g_oat_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_oat.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i223_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE i223_bcl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT

   CLOSE i223_bcl
   COMMIT WORK

END FUNCTION


FUNCTION i223_b_askkey()

   CLEAR FORM
   CALL g_oat.clear()

   CONSTRUCT g_wc2 ON oat01,oat02,oat03,oat04,oat05
           FROM s_oat[1].oat01,s_oat[1].oat02,s_oat[1].oat03,
                s_oat[1].oat04,s_oat[1].oat05
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gea'
                 LET g_qryparam.default1 = g_oat[l_ac].oat01
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat01
                 DISPLAY BY NAME g_oat[l_ac].oat01
                 NEXT FIELD oat01

            WHEN INFIELD(oat02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geb'
                 LET g_qryparam.default1 = g_oat[l_ac].oat02
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat02
                 DISPLAY BY NAME g_oat[l_ac].oat02
                 NEXT FIELD oat02

            WHEN INFIELD(oat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geo'
                 LET g_qryparam.default1 = g_oat[l_ac].oat03
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat03
                 DISPLAY BY NAME g_oat[l_ac].oat03
                 NEXT FIELD oat03

            WHEN INFIELD(oat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oah'
                 LET g_qryparam.default1 = g_oat[l_ac].oat04
                 CALL cl_create_qry() RETURNING g_oat[l_ac].oat04
                 DISPLAY BY NAME g_oat[l_ac].oat04
                 NEXT FIELD oat04
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

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL i223_b_fill(g_wc2)

END FUNCTION

FUNCTION i223_b_fill(p_wc2)
   DEFINE p_wc2   LIKE type_file.chr1000

   LET g_sql = "SELECT oat01,oat02,oat03,oat04,oat05",
               " FROM oat_file",
               " WHERE ", p_wc2 CLIPPED
   PREPARE i223_pb FROM g_sql
   DECLARE oat_curs CURSOR FOR i223_pb

   CALL g_oat.clear()

   LET g_cnt = 1
   MESSAGE "Searching!" 

   FOREACH oat_curs INTO g_oat[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_oat.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i223_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oat TO s_oat.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i223_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y' ) THEN
   #    CALL cl_set_comp_entry("oat01,oat02,oat03,oat04",TRUE)
    END IF
END FUNCTION            

FUNCTION i223_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
   #    CALL cl_set_comp_entry("oat01,oat02,oat03,oat04",FALSE)
    END IF                                                                                                                          
END FUNCTION

FUNCTION i223_set_no_required()
   CALL cl_set_comp_required("oat01,oat02,oat03",FALSE)
END FUNCTION
