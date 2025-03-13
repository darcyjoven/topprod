# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: arti300.4gl
# Descriptions...: 要貨模板作業
# Date & Author..: FUN-D10014 12/10/25 By jingll
# Modify.........: WEB-D10015 13/02/04 By huangrh 添加取消確認
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:WEB-D20009 13/02/21 By jingll 添加狀態圖片 
# Modify.........: No:WEB-D20011 13/02/25 By jingll 料號開窗可多選錄入
# Modify.........: No.CHI-D20015 12/03/26 By lujh 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/10 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_rda01    LIKE rda_file.rda01,
       g_rda02    LIKE rda_file.rda02,
       g_rda03    LIKE rda_file.rda03,
       
       g_rda01_t  LIKE rda_file.rda01,
       g_rda02_t  LIKE rda_file.rda02,
       g_rda03_t  LIKE rda_file.rda03,       
          
       g_rda    DYNAMIC ARRAY of RECORD       
            rda04      LIKE rda_file.rda04,
            rda04_desc LIKE ima_file.ima02,
            rdaacti    LIKE rda_file.rdaacti
                END RECORD,
      
       g_rda_t  RECORD  
            rda04      LIKE rda_file.rda04,
            rda04_desc LIKE ima_file.ima02,
            rdaacti    LIKE rda_file.rdaacti
                END RECORD,   
       g_wc                    STRING,  
       g_sql                   STRING,  
       g_ss                    LIKE type_file.chr1,    # 決定後續步驟 
       g_rec_b                 LIKE type_file.num5,    # 單身筆數     
       l_ac                    LIKE type_file.num5           
DEFINE   g_cnt                 LIKE type_file.num10   
DEFINE   g_msg                 LIKE type_file.chr1000  
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5    
DEFINE   g_curs_index          LIKE type_file.num10   
DEFINE   g_row_count           LIKE type_file.num10   
DEFINE   g_jump                LIKE type_file.num10    
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_rdaconf             LIKE rda_file.rdaconf    #確認碼         
DEFINE   g_chr                 LIKE type_file.chr1      #WEB-D20009--add


MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
   OPEN WINDOW i300_w WITH FORM "art/42f/arti300"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
   LET g_forupd_sql =" SELECT * FROM rda_file ",  
                      "  WHERE rda01 = ? ",  
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_lock_u CURSOR FROM g_forupd_sql
   CALL i300_menu() 
 
   CLOSE WINDOW i300_w                       
     CALL  cl_used(g_prog,g_time,2)            
         RETURNING g_time   
END MAIN      
       
FUNCTION i300_curs()

   DEFINE l_sql STRING 
   CLEAR FORM                           
   CALL g_rda.clear() 
   INITIALIZE g_rda01 TO NULL 
   INITIALIZE g_rda02 TO NULL   
   INITIALIZE g_rda03 TO NULL  
   CALL cl_set_head_visible("","YES")   
 
   CONSTRUCT g_wc ON rda01,rda02,rda03,rdaconf,rdacond,rdacont,
                     rdaconu,rda04,rdaacti,rdauser,rdagrup,rdaoriu,
                     rdaorig,rdamodu,rdadate  
                FROM rda01,rda02,rda03,rdaconf,rdacond,rdacont,
                    rdaconu, s_rda[1].rda04,s_rda[1].rdaacti,rdauser,
                    rdagrup,rdaoriu,rdaorig,rdamodu,rdadate
                    
      ON ACTION controlp
         CASE
            WHEN INFIELD(rda01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rda01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rda01
               NEXT FIELD rda01
            WHEN INFIELD(rda04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rda04"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rda04
               NEXT FIELD rda04
           WHEN INFIELD(rdaconu)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rdaconu"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rdaconu
               NEXT FIELD rdaconu
               OTHERWISE
                  EXIT CASE
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED
 
   IF INT_FLAG THEN
      CLEAR FORM	
      CALL g_rda.clear() 
      RETURN 
   END IF
   LET g_sql= " SELECT DISTINCT rda01 FROM rda_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY rda01 "
   PREPARE i300_prepare FROM g_sql
   DECLARE i300_b_curs SCROLL CURSOR WITH HOLD FOR i300_prepare
   
   LET g_sql= " SELECT COUNT(UNIQUE rda01) FROM rda_file ",
              " WHERE ",g_wc CLIPPED
   PREPARE i300_precount FROM g_sql
   DECLARE i300_count CURSOR FOR i300_precount
END FUNCTION 

FUNCTION i300_menu()   
   WHILE TRUE
      CALL i300_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i300_a()
            END IF
       
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i300_copy()
            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL i300_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "modify"                          # u.修改
	        IF cl_chk_act_auth() THEN
               CALL i300_u()
	        END IF   
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rda),'','')
            END IF

         WHEN "effective"
            IF cl_chk_act_auth() THEN
               CALL i300_effective()
            END IF 
            CALL i300_show()

         WHEN "allinvalid"
           IF cl_chk_act_auth() THEN
               CALL i300_invalid()
           END IF  
           CALL i300_show()
           
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
               CALL i300_yes()
           END IF    

         #WEB-D10015--add--begin------
         WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
               CALL i300_no()
           END IF
         #WEB-D10015--add--end-------- 
         
         WHEN "void"
           IF cl_chk_act_auth() THEN
              CALL i300_v(1)
           END IF 
        
         #FUN-D20039 -----------sta
         WHEN "undo_void"
           IF cl_chk_act_auth() THEN
              CALL i300_v(2)
           END IF
         #FUN-D20039 -----------end

      END CASE
   END WHILE
END FUNCTION

FUNCTION i300_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  
   CALL g_rda.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i300_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN i300_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_rda01 TO NULL
      INITIALIZE g_rda02 TO NULL
      INITIALIZE g_rda03 TO NULL

   ELSE
     OPEN i300_count
     FETCH i300_count INTO g_row_count

      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i300_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rda TO s_rda.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY   
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   

 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
         LET INT_FLAG=FALSE                         #利用單身驅動menu時，cancel代表右上角的"X"
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION exporttoexcel                       #匯出Excel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                            #單頭摺疊，可利用hot key "Ctrl-s"開啟/關閉單頭區塊
         CALL cl_set_head_visible("","AUTO")      
 
     #ON ACTION related_document                    #相關文件
     #   LET g_action_choice="related_document"          
     #   EXIT DISPLAY

     #整批有效
      ON ACTION effective
         LET g_action_choice="effective"
         EXIT DISPLAY
     #整批无效
     ON ACTION allinvalid
         LET g_action_choice="allinvalid"
         EXIT DISPLAY

     #审核
     ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY    
   
     #WEB-D10015--add--begin---------
     #取消审核
     ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY   
     #WEB-D10015--add--end-----------
   
     #作废
     ON ACTION void
         LET g_action_choice="void"                 
         EXIT DISPLAY     
    
     #FUN-D20039 ----------sta
     ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
     #FUN-D20039 ----------end
         

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i300_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_rda.clear()

   INITIALIZE g_rda01  LIKE rda_file.rda01
   INITIALIZE g_rda02  LIKE rda_file.rda02
   INITIALIZE g_rda03  LIKE rda_file.rda03
   
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_rda03 = 0          #要貨天數 
      LET g_rdaconf = 'N'      #確認碼
      CALL i300_i("a")
      IF INT_FLAG THEN         # 使用者退出
         LET g_rda01=NULL
         LET g_rda02=NULL
         LET g_rda03=NULL          
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM   
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL i300_b()
      LET g_rda01_t=g_rda01
      EXIT WHILE 
   END WHILE
END FUNCTION

#修改
FUNCTION i300_u()
DEFINE l_success LIKE type_file.chr1

   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_rda01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT rdaconf INTO g_rdaconf FROM rda_file
    WHERE rda01 = g_rda01 AND rownum=1

   IF g_rdaconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK

   OPEN i300_lock_u USING g_rda01
   IF STATUS THEN
      CALL cl_err("OPEN i300_lock_u:", STATUS, 1)
      CLOSE i300_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   CALL i300_show()

   WHILE TRUE
      LET g_rda01_t=g_rda01
      LET g_rda02_t=g_rda02
      LET g_rda03_t=g_rda03
      DISPLAY g_user,g_today TO rdamodu,rdadate

      CALL i300_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rda01=g_rda01_t
         LET g_rda02=g_rda02_t
         LET g_rda03=g_rda03_t
         CALL i300_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_rda02 <> g_rda02_t OR g_rda03 <> g_rda03_t THEN
         UPDATE rda_file SET rda02 = g_rda02,
                             rda03 = g_rda03,
                             rdamodu = g_user,
                             rdadate = g_today 
           WHERE rda01 = g_rda01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rda_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         ELSE
            COMMIT WORK    
         END IF
      END IF   
      EXIT WHILE
   END WHILE

   CLOSE i300_lock_u
   CALL i300_b_fill(' 1=1')

END FUNCTION

FUNCTION i300_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  
   DEFINE   l_count      LIKE type_file.num5    
   DEFINE   l_n          LIKE type_file.num5 
   LET g_ss = 'Y'
 
   DISPLAY g_rda01 TO rda01
   DISPLAY g_rda03 TO rda03
   DISPLAY g_user  TO rdauser
   DISPLAY g_grup  TO rdagrup
   DISPLAY g_user  TO rdaoriu
   DISPLAY g_grup  TO rdaorig
   DISPLAY g_rdaconf TO rdaconf 

   CALL cl_set_head_visible("","YES")  
   INPUT g_rda01,g_rda02,g_rda03 WITHOUT DEFAULTS FROM rda01,rda02,rda03
      BEFORE INPUT 
         CALL i300_set_comp_entry(p_cmd)
         CALL i300_set_comp_no_entry(p_cmd)
      
      AFTER FIELD rda01
         IF (p_cmd='a' AND NOT cl_null(g_rda01)) THEN
            SELECT count(*) INTO l_n FROM rda_file WHERE rda01 = g_rda01
            IF l_n > 0 THEN 
               CALL cl_err('',-239,1)
               NEXT FIELD rda01
            END IF 
         END IF
         IF cl_null(g_rda01) THEN
            CALL cl_err('','art1120',1)
            NEXT FIELD rda01
         END IF   

      AFTER FIELD rda03
        IF NOT cl_null(g_rda03) OR (p_cmd = 'u' AND g_rda03 != g_rda03_t) THEN
           IF g_rda03 < 0 THEN
              CALL cl_err('','mfg-564',1)
              NEXT FIELD rda03
           END IF 
        END IF
                  
      AFTER INPUT
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
END FUNCTION

FUNCTION i300_set_comp_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd='a' THEN
      CALL cl_set_comp_entry("rda01,rda02,rda03",TRUE)
   END IF   
END FUNCTION 

FUNCTION i300_set_comp_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd='u' THEN
      CALL cl_set_comp_entry("rda01",FALSE)
   END IF   
END FUNCTION

FUNCTION i300_b()
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,               # 檢查重複用                       
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        
            p_cmd           LIKE type_file.chr1,               # 處理狀態         
            l_allow_insert  LIKE type_file.num5,              
            l_allow_delete  LIKE type_file.num5                               
   DEFINE   l_sql           STRING
   DEFINE   l_aag00         LIKE aag_file.aag00
   DEFINE   buf             base.StringBuffer
   DEFINE   l_errnum        LIKE type_file.num5 
   DEFINE   l_rda03         LIKE rda_file.rda03 
   DEFINE   l_aag02_desc    LIKE aag_file.aag02  
   DEFINE   l_rda02         LIKE rda_file.rda02
   DEFINE   l_wc            STRING 
   DEFINE   l_cnt           LIKE type_file.num5  
   DEFINE   l_rdaconf       LIKE rda_file.rdaconf
   DEFINE   l_rtz04         LIKE rtz_file.rtz04
   DEFINE   l_rtz04_1       LIKE rtz_file.rtz04   #WEB-D20011--add
   DEFINE   l_rda04         LIKE rda_file.rda04   #WEB-D20011--add
   DEFINE   l_tok base.StringTokenizer            #WEB-D20011--add
   DEFINE   l_str           STRING                #WEB-D20011--add
   
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_rda01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   SELECT DISTINCT rdaconf INTO l_rdaconf FROM rda_file WHERE rda01 =  g_rda01
   IF l_rdaconf = 'Y' THEN
      CALL cl_err('','asf-228',0)
      RETURN
   END IF
   IF l_rdaconf = 'X' THEN
      CALL cl_err('','art-102',0)
      RETURN
   END IF    
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

    LET g_forupd_sql= "SELECT rda04,'',rdaacti ",
                      " FROM rda_file ",
                      " WHERE rda01 = ? and rda04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql

    LET l_ac_t =0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_rda WITHOUT DEFAULTS FROM s_rda.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
       BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'           
           LET l_n  = ARR_COUNT()
           BEGIN WORK
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rda_t.* = g_rda[l_ac].*     
              OPEN i300_bcl USING g_rda01,g_rda_t.rda04
              IF STATUS THEN
                 CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i300_bcl INTO g_rda[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('g_rda01,g_rda_t.rda04',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                CALL i300_rda04()
              END IF   
           END IF 
       BEFORE INSERT       
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rda[l_ac].* TO NULL   
            LET g_rda[l_ac].rdaacti = 'Y'    
            LET g_rda_t.* = g_rda[l_ac].*         #輸入新資料
            CALL cl_show_fld_cont()     
            NEXT FIELD rda04
            
       AFTER FIELD rda04
          IF p_cmd='a' OR (p_cmd = "u" AND g_rda[l_ac].rda04 != g_rda_t.rda04) THEN
          IF NOT cl_null(g_rda[l_ac].rda04) THEN
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_rda[l_ac].rda04 AND imaacti = 'Y' AND ima1010 = '1'
             IF l_cnt = 0 THEN
                CALL cl_err('','mfg3403',0)
                LET g_rda[l_ac].rda04 = g_rda_t.rda04 
                NEXT FIELD rda04
             END IF
             #商品策略检查
             IF NOT s_chk_item_no(g_rda[l_ac].rda04,"") THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD rda04
             END IF
             IF g_rda[l_ac].rda04 <> g_rda_t.rda04 OR p_cmd = 'a' THEN 
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM rda_file WHERE rda01 = g_rda01 AND rda04 = g_rda[l_ac].rda04
                IF l_cnt > 0 THEN
                   CALL cl_err('','mfg-563',0)
                   LET g_rda[l_ac].rda04 = g_rda_t.rda04
                   NEXT FIELD rda04
                END IF
             END IF
             CALL i300_rda04()
          END IF
          END IF 

             
       AFTER INSERT
          IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
          END IF
          INSERT INTO rda_file(rda01,rda02,rda03,rda04,rdaacti,rdaconf,rdacond,rdacont,
                              rdaconu,rdauser,rdagrup,rdamodu,rdadate,rdaorig,rdaoriu)
               VALUES (g_rda01,g_rda02,g_rda03,g_rda[l_ac].rda04,g_rda[l_ac].rdaacti,
                       'N','','','',g_user,g_grup,'','',g_grup,g_user) 
               
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rda_file",g_rda01,g_rda[l_ac].rda04,SQLCA.sqlcode,"","",0)   
             CANCEL INSERT
          ELSE 
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
          END IF

       BEFORE DELETE                            #是否取消單身
          IF NOT cl_null(g_rda_t.rda04) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF
             
             DELETE FROM rda_file WHERE rda01 = g_rda01
                                    AND rda04 = g_rda_t.rda04

             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rda_file",g_rda01,g_rda_t.rda04,SQLCA.sqlcode,"","",0)  
                ROLLBACK WORK
                CANCEL DELETE
             END IF 
             LET g_rec_b = g_rec_b - 1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
          COMMIT WORK

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rda[l_ac].* = g_rda_t.*
             CLOSE i300_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
    
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_rda[l_ac].rda04,-263,1)
             LET g_rda[l_ac].* = g_rda_t.*
          ELSE
             UPDATE rda_file
                SET rda04= g_rda[l_ac].rda04,
                    rdaacti= g_rda[l_ac].rdaacti
              WHERE rda01 = g_rda01
                AND rda04 = g_rda_t.rda04  
 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rda_file",g_rda01,g_rda_t.rda04,SQLCA.sqlcode,"","",0)   
                LET g_rda[l_ac].* = g_rda_t.*
             END IF
             MESSAGE 'UPDATE O.K'
             COMMIT WORK
             #更新修改者和修改日期
             UPDATE rda_file
                SET rdamodu = g_user,
                    rdadate = g_today
              WHERE rda01 = g_rda01
             DISPLAY g_user  TO rdamodu
             DISPLAY g_today TO rdadate 
             #--------------
          END IF
          
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac    #FUN-D30033 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_rda[l_ac].* = g_rda_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rda.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
            END IF
            CLOSE i300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30033 add
         CLOSE i300_bcl
         COMMIT WORK
         
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(rda04) AND l_ac > 1 THEN
            LET g_rda[l_ac].* = g_rda[l_ac-1].*
            NEXT FIELD rda04
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rda04)
             IF p_cmd = 'u' THEN           #WEB-D20011--add 
               CALL cl_init_qry_var()
               SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_plant
               IF cl_null(l_rtz04) THEN
                  LET g_qryparam.form = "q_ima"
               ELSE
                  LET g_qryparam.form = "q_rte03"
                  LET g_qryparam.arg1 = l_rtz04
               END IF     
               LET g_qryparam.state = "i"
               LET g_qryparam.default1 = g_rda[l_ac].rda04
               CALL cl_create_qry() RETURNING g_rda[l_ac].rda04
               DISPLAY g_rda[l_ac].rda04 TO rda04
               CALL i300_rda04() 
               NEXT FIELD rda04
            #WEB-D20011---add--begin---------
             ELSE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               SELECT rtz04 INTO l_rtz04_1 FROM rtz_file WHERE rtz01=g_plant
               IF cl_null(l_rtz04_1) THEN
                  LET g_qryparam.form = "q_ima"
               ELSE
                  LET g_qryparam.form = "q_rte03"
                  LET g_qryparam.arg1 = l_rtz04_1
               END IF
               CALL cl_create_qry() RETURNING l_str
               LET l_tok = base.StringTokenizer.createExt(l_str,'|','',TRUE)
               IF l_tok.countTokens() > 0 THEN
                  LET l_n = 0
                  WHILE l_tok.hasMoreTokens()
                    LET l_rda04 = l_tok.nextToken()  
                    SELECT COUNT(*) INTO l_n FROM rda_file WHERE rda01 = g_rda01 AND rda04 = l_rda04
                    IF l_n = 0 THEN
                       INSERT INTO rda_file(rda01,rda02,rda03,rda04,rdaacti,rdaconf,rdacond,rdacont,
                              rdaconu,rdauser,rdagrup,rdamodu,rdadate,rdaorig,rdaoriu)
                        VALUES (g_rda01,g_rda02,g_rda03,l_rda04,'Y',
                               'N','','','',g_user,g_grup,'','',g_grup,g_user)
                    END IF 
                  END WHILE
                  CALL i300_b_fill(" 1=1")
               END IF
               EXIT INPUT
             END IF
            #WEB-D20011---add--end-----------
          
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
                                                                                            
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   END INPUT
 
   CLOSE i300_bcl
   COMMIT WORK
END FUNCTION


FUNCTION i300_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1         #處理方式     

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i300_b_curs INTO g_rda01  
      WHEN 'P' FETCH PREVIOUS i300_b_curs INTO g_rda01
      WHEN 'F' FETCH FIRST    i300_b_curs INTO g_rda01
      WHEN 'L' FETCH LAST     i300_b_curs INTO g_rda01
      WHEN '/' 
         IF (NOT g_no_ask) THEN          
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i300_b_curs INTO g_rda01
         LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rda01,SQLCA.sqlcode,0)
      INITIALIZE g_rda01 TO NULL  
     
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL i300_show()
   END IF
END FUNCTION
 
FUNCTION i300_show()                         # 將資料顯示在畫面上
  DEFINE l_rdaconf LIKE rda_file.rdaconf
  DEFINE l_rdacond LIKE rda_file.rdacond
  DEFINE l_rdacont LIKE rda_file.rdacont
  DEFINE l_rdaconu LIKE rda_file.rdaconu
  DEFINE l_rdauser LIKE rda_file.rdauser
  DEFINE l_rdagrup LIKE rda_file.rdagrup
  DEFINE l_rdamodu LIKE rda_file.rdamodu
  DEFINE l_rdadate LIKE rda_file.rdadate
  DEFINE l_rdaorig LIKE rda_file.rdaorig
  DEFINE l_rdaoriu LIKE rda_file.rdaoriu
  DEFINE l_rdaconu_desc LIKE gen_file.gen02
  
   DISPLAY g_rda01 TO rda01
   SELECT DISTINCT rda02,rda03,rdaconf,rdacond,rdacont,rdaconu,rdauser,
                   rdagrup,rdamodu,rdadate,rdaorig,rdaoriu
               INTO g_rda02,g_rda03,l_rdaconf,l_rdacond,l_rdacont,l_rdaconu,l_rdauser,
                   l_rdagrup,l_rdamodu,l_rdadate,l_rdaorig,l_rdaoriu    
               FROM rda_file WHERE rda01=  g_rda01   

   SELECT gen02 INTO l_rdaconu_desc  FROM gen_file WHERE gen01 = l_rdaconu
   DISPLAY  l_rdaconu_desc TO FORMONLY.rdaconu_desc
   DISPLAY g_rda02 TO rda02
   DISPLAY g_rda03 TO rda03
   DISPLAY l_rdaconf TO rdaconf
   DISPLAY l_rdacond TO rdacond
   DISPLAY l_rdacont TO rdacont
   DISPLAY l_rdaconu TO rdaconu
   DISPLAY l_rdauser TO rdauser
   DISPLAY l_rdagrup TO rdagrup
   DISPLAY l_rdamodu TO rdamodu
   DISPLAY l_rdadate TO rdadate
   DISPLAY l_rdaorig TO rdaorig
   DISPLAY l_rdaoriu TO rdaoriu
   IF l_rdaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  #WEB-D20009--add
   CALL cl_set_field_pic(l_rdaconf,"","","",g_chr,"")               #WEB-D20009--add
   
   CALL i300_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                  
END FUNCTION

FUNCTION i300_b_fill(p_wc)               
 
   DEFINE p_wc         STRING 
   IF cl_null(p_wc) THEN
      LET p_wc = "1=1 "
   END IF
   LET g_sql = "SELECT rda04,'',rdaacti",
                 " FROM rda_file ",
                " WHERE rda01 = '",g_rda01 CLIPPED,"' ",
                " AND ",p_wc CLIPPED,
                " ORDER BY rda04"
 
    PREPARE i300_prepare2 FROM g_sql           #預備一下
    DECLARE rda_curs CURSOR FOR i300_prepare2
 
    CALL g_rda.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH rda_curs INTO g_rda[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima02 INTO g_rda[g_cnt].rda04_desc 
         FROM ima_file WHERE ima01 = g_rda[g_cnt].rda04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rda.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    
    LET g_cnt = 0
END FUNCTION

FUNCTION i300_r()
DEFINE   l_rdaconf       LIKE rda_file.rdaconf

    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_rda01 IS NULL THEN 
       CALL cl_err("",-400,0)                 
       RETURN
    END IF
    SELECT DISTINCT rdaconf INTO l_rdaconf FROM rda_file WHERE rda01 =  g_rda01
    IF l_rdaconf = 'Y' THEN
       CALL cl_err('','asf-228',0)
       RETURN
    END IF
    IF l_rdaconf = 'X' THEN
       CALL cl_err('','art-102',0)
       RETURN
    END IF 
    
    IF cl_delh(0,0) THEN                   #確認一下 
        INITIALIZE g_doc.* TO NULL       
        LET g_doc.column1 = "rda01"      
        LET g_doc.value1 = g_rda01      
        CALL cl_del_doc()                
        DELETE FROM rda_file WHERE rda01 = g_rda01 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","rda_file",g_rda01,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  
        ELSE
            CLEAR FORM
            CALL g_rda.clear()
            LET g_rda01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i300_count                                                     
            FETCH i300_count INTO g_row_count                 
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i300_b_curs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i300_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET g_no_ask = TRUE                           
               CALL i300_fetch('/')                          
            END IF
        END IF
    END IF
END FUNCTION

FUNCTION i300_copy()
   DEFINE l_newno     LIKE rda_file.rda01,
          l_oldno     LIKE rda_file.rda01
   DEFINE li_result   LIKE type_file.num5   
   DEFINE l_aag01     LIKE aag_file.aag01,
          l_aag02     LIKE aag_file.aag02,
          l_sql       STRING ,
          l_aagacti   LIKE aag_file.aagacti,
          li_n        LIKE type_file.num5,
          l_n         LIKE type_file.num5
   DEFINE l_rda02     LIKE rda_file.rda02
   DEFINE l_rda03     LIKE rda_file.rda03   
 
   IF s_shut(0) THEN 
   RETURN 
   END IF
 
   IF g_rda01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i300_set_entry('a')
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")  
   
   INPUT l_newno,l_rda02,l_rda03 FROM rda01,rda02,rda03
    BEFORE INPUT 
       DISPLAY 'N' TO rdaconf
       DISPLAY '' TO rdacont
       DISPLAY '' TO rdaconu
       DISPLAY '' TO rdadate
       DISPLAY '' TO rdamodu
       LET l_rda03=g_rda03
       LET l_rda02=g_rda02
       DISPLAY l_rda03,l_rda02 TO rda03,rda02
 
       AFTER FIELD rda01
          IF NOT cl_null(l_newno) THEN
             SELECT count(*) INTO li_result FROM rda_file
              WHERE rda01=l_newno
             IF li_result>0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD rda01
             END IF 
          ELSE
             NEXT FIELD rda01
          END IF 
       AFTER FIELD rda03   
          IF l_rda03 < 0 THEN
             CALL cl_err('','mfg-564',1)
             NEXT FIELD rda03
          END IF  
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
  
       ON ACTION HELP          
          CALL cl_show_help() 
 
       ON ACTION controlg    
          CALL cl_cmdask() 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_rda01 TO rda01 
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
   DROP TABLE y
 
   SELECT * 
     FROM rda_file        
    WHERE rda01=g_rda01
     INTO TEMP y

      UPDATE y
         SET rda01=l_newno,               
             rda02=l_rda02,
             rda03=l_rda03,
             rdaacti = 'Y',
             rdaconf = 'N',
             rdacond = NULL,
             rdacont = NULL,
             rdaconu = NULL,
             rdauser=g_user,
             rdagrup=g_grup,
             rdaoriu=g_user,         
             rdaorig=g_grup,         
             rdamodu=NULL,
             rdadate=NULL

      INSERT INTO rda_file SELECT * FROM y
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rda_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF

      LET l_oldno= g_rda01
      LET g_rda01=l_newno
      CALL i300_b()
      LET g_rda01=l_oldno
      CALL i300_show()
END FUNCTION

FUNCTION i300_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1               
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("rda01",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION 

FUNCTION i300_set_no_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1               
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("rda01",FALSE )                               
   END IF                                                                       
                                                                                
END FUNCTION 


FUNCTION i300_rda04()
SELECT ima02 INTO g_rda[l_ac].rda04_desc FROM ima_file 
  WHERE ima01 = g_rda[l_ac].rda04
  DISPLAY g_rda[l_ac].rda04_desc  TO FORMONLY.rda04_desc
END FUNCTION 

#整批有效
FUNCTION i300_effective()

 DEFINE l_rdaconf LIKE rda_file.rdaconf

   IF cl_null(g_rda01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT DISTINCT rdaconf INTO l_rdaconf FROM rda_file WHERE rda01 =  g_rda01

   IF l_rdaconf = 'Y' THEN
      CALL cl_err('','asf-228',0)
      RETURN
   END IF

   IF l_rdaconf = 'X' THEN
      CALL cl_err('','art-102',0)
      RETURN
   END IF

   UPDATE rda_file SET rdaacti = 'Y'
          WHERE rda01 = g_rda01
          
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","rda_file",g_rda01,'',SQLCA.sqlcode,"","",0)   
      RETURN
  END IF      
END FUNCTION 

#整批无效
FUNCTION i300_invalid()
 DEFINE l_rdaconf LIKE rda_file.rdaconf

   IF cl_null(g_rda01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT DISTINCT rdaconf INTO l_rdaconf FROM rda_file WHERE rda01 =  g_rda01

   IF l_rdaconf = 'Y' THEN
      CALL cl_err('','asf-228',0)
      RETURN
   END IF

   IF l_rdaconf = 'X' THEN
      CALL cl_err('','art-102',0)
      RETURN
   END IF

   UPDATE rda_file SET rdaacti = 'N'
          WHERE rda01 = g_rda01
          
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","rda_file",g_rda01,'',SQLCA.sqlcode,"","",0)   
      RETURN
  END IF      
END FUNCTION 

#确认
FUNCTION i300_yes()
  DEFINE l_rdaconf LIKE rda_file.rdaconf
  DEFINE l_rdacond LIKE rda_file.rdacond
  DEFINE l_rdacont LIKE rda_file.rdacont
  DEFINE l_rdaconu LIKE rda_file.rdaconu 
  DEFINE l_rdaconu_desc LIKE gen_file.gen02   
         
     IF cl_null(g_rda01) THEN 
        CALL cl_err('',-400,0)
        RETURN
     END IF
     SELECT DISTINCT rdaconf INTO l_rdaconf  FROM rda_file WHERE rda01 = g_rda01
     IF l_rdaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
     IF l_rdaconf = 'X' THEN CALL cl_err(g_rda01,'9024',0) RETURN END IF
    
     IF NOT cl_confirm('art-026') THEN RETURN END IF
     LET l_rdaconf = 'Y'
     LET l_rdacond = g_today
     LET l_rdacont = TIME
     LET l_rdaconu = g_user
     
     UPDATE rda_file SET rdaconf = l_rdaconf,
                         rdacond = l_rdacond,
                         rdacont = l_rdacont,
                         rdaconu = l_rdaconu
                      WHERE rda01 = g_rda01
     IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('','-201',0)
        RETURN 
     END IF 
     SELECT gen02 INTO l_rdaconu_desc  FROM gen_file WHERE gen01 = l_rdaconu
     DISPLAY  l_rdaconu_desc TO FORMONLY.rdaconu_desc
     DISPLAY l_rdaconf TO rdaconf
     DISPLAY l_rdacond TO rdacond
     DISPLAY l_rdacont TO rdacont
     DISPLAY l_rdaconu TO rdaconu
     IF l_rdaconf = 'X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  #WEB-D20009--add
     CALL cl_set_field_pic(l_rdaconf,"","","",g_chr,"")               #WEB-D20009--add
END FUNCTION

#作废
FUNCTION i300_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_rdaconf LIKE rda_file.rdaconf
DEFINE l_rdamodu LIKE rda_file.rdamodu
DEFINE l_rdadate LIKE rda_file.rdadate  
         
   IF cl_null(g_rda01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT DISTINCT rdaconf INTO l_rdaconf  FROM rda_file WHERE rda01 = g_rda01
   #FUN-D20039 ----------sta
   IF p_type = 1 THEN
      IF l_rdaconf ='X' THEN RETURN END IF
   ELSE
      IF l_rdaconf<>'X' THEN RETURN END IF
   END IF
    #FUN-D20039 ----------end     
   IF l_rdaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF cl_void(0,0,l_rdaconf) THEN
      IF l_rdaconf = 'N' THEN
         LET l_rdaconf = 'X'
      ELSE
         LET l_rdaconf = 'N'
      END IF

      LET l_rdamodu = g_user
      LET l_rdadate = g_today
      UPDATE rda_file SET rdaconf=l_rdaconf,
                          rdamodu=l_rdamodu,
                          rdadate=l_rdadate
       WHERE rda01 = g_rda01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rda_file",g_rda01,"",SQLCA.sqlcode,"","up rdaconf",1)
          RETURN
       END IF
   END IF
   DISPLAY l_rdaconf TO rdaconf
   DISPLAY l_rdamodu TO rdamodu
   DISPLAY l_rdadate TO rdadate 

   IF l_rdaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  #WEB-D20009--add
   CALL cl_set_field_pic(l_rdaconf,"","","",g_chr,"")               #WEB-D20009--add
END FUNCTION

#WEB-D10015--add--begin-----------
#取消確認
FUNCTION i300_no()

 DEFINE l_rdaconf LIKE rda_file.rdaconf
 DEFINE l_rdacond LIKE rda_file.rdacond
 DEFINE l_rdacont LIKE rda_file.rdacont
 DEFINE l_rdaconu LIKE rda_file.rdaconu 
 DEFINE l_rdaconu_desc LIKE gen_file.gen02   #CHI-D20015 add

   IF cl_null(g_rda01) THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
   SELECT DISTINCT rdaconf INTO l_rdaconf  FROM rda_file WHERE rda01 = g_rda01
   IF l_rdaconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF  

   IF NOT cl_confirm('aim-304') THEN RETURN END IF

   LET l_rdaconf = 'N'
   #LET l_rdacond = NULL      #CHI-D20015 mark
   #LET l_rdaconu = NULL      #CHI-D20015 mark
   #LET l_rdacont = NULL      #CHI-D20015 mark
   LET l_rdacond = g_today    #CHI-D20015 add
   LET l_rdacont = TIME       #CHI-D20015 add
   LET l_rdaconu = g_user     #CHI-D20015 add

   UPDATE rda_file SET rdaconf='N',
                       #rdacond=NULL,              #CHI-D20015 mark
                       #rdaconu=NULL,              #CHI-D20015 mark 
                       #rdacont=NULL               #CHI-D20015 mark
                       rdacond = l_rdacond,        #CHI-D20015 add
                       rdacont = l_rdacont,        #CHI-D20015 add
                       rdaconu = l_rdaconu         #CHI-D20015 add
   WHERE rda01 = g_rda01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rda_file",g_rda01,"",SQLCA.sqlcode,"","up rdaconf",1)
      RETURN
   END IF
   SELECT gen02 INTO l_rdaconu_desc  FROM gen_file WHERE gen01 = l_rdaconu   #CHI-D20015 add
   DISPLAY  l_rdaconu_desc TO FORMONLY.rdaconu_desc                          #CHI-D20015 add
   #DISPLAY '' TO FORMONLY.rdaconu_desc                                      #CHI-D20015 mark
   DISPLAY l_rdaconf TO rdaconf
   DISPLAY l_rdacond TO rdacond 
   DISPLAY l_rdaconu TO rdaconu
   DISPLAY l_rdacont TO rdacont

   IF l_rdaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  #WEB-D20009--add
   CALL cl_set_field_pic(l_rdaconf,"","","",g_chr,"")               #WEB-D20009--add
END FUNCTION
#WEB-D10015--add--end-----------
#FUN-D10014--add
