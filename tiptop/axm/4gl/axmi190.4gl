# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: axmi190.4gl
# Descriptions...: 業務人員借出信用額度維護作業
# Date & Author..: No.FUN-740016 07/04/09 By Nicola 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ocn           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
           ocn01   LIKE ocn_file.ocn01,  
           gen02   LIKE gen_file.gen02,
           ocn02   LIKE ocn_file.ocn02, 
           ocn03   LIKE ocn_file.ocn03,
           ocn04   LIKE ocn_file.ocn04,
           ocn05   LIKE ocn_file.ocn05,
           ocn06   LIKE ocn_file.ocn06,
           ocn07   LIKE ocn_file.ocn07
                       END RECORD,
       g_ocn_t         RECORD 
           ocn01   LIKE ocn_file.ocn01,  
           gen02   LIKE gen_file.gen02,
           ocn02   LIKE ocn_file.ocn02, 
           ocn03   LIKE ocn_file.ocn03,
           ocn04   LIKE ocn_file.ocn04,
           ocn05   LIKE ocn_file.ocn05,
           ocn06   LIKE ocn_file.ocn06,
           ocn07   LIKE ocn_file.ocn07
                       END RECORD,
       g_wc2,g_sql           STRING,
       g_rec_b               LIKE type_file.num5,
       l_ac                  LIKE type_file.num5
DEFINE p_row,p_col           LIKE type_file.num5
DEFINE g_forupd_sql          STRING
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
 
MAIN   #No.FUN-740016
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) 
       RETURNING g_time 
 
   LET p_row = 3 LET p_col = 3
 
   OPEN WINDOW i190_w AT p_row,p_col WITH FORM "axm/42f/axmi190"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
 
   CALL i190_b_fill(g_wc2)
 
   CALL i190_menu()
 
   CLOSE WINDOW i190_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION i190_menu()
 
   WHILE TRUE
      CALL i190_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i190_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i190_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocn),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i190_q()
 
   CALL i190_b_askkey()
 
END FUNCTION
 
FUNCTION i190_b()
   DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,    #檢查重複用
          l_lock_sw       LIKE type_file.chr1,    #單身鎖住否
          p_cmd           LIKE type_file.chr1,    #處理狀態
          l_allow_insert  LIKE type_file.num5,    #可新增否
          l_allow_delete  LIKE type_file.num5     #可刪除否
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ocn01,'',ocn02,ocn03,ocn04,ocn05,",
                      "       ocn06,ocn07 FROM ocn_file ",
                      " WHERE ocn01=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i190_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ocn WITHOUT DEFAULTS FROM s_ocn.*
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
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ocn_t.* = g_ocn[l_ac].*  #BACKUP
            BEGIN WORK
 
            OPEN i190_bcl USING g_ocn_t.ocn01
            IF STATUS THEN
               CALL cl_err("OPEN i190_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i190_bcl INTO g_ocn[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ocn_t.ocn01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT gen02 INTO g_ocn[l_ac].gen02
                    FROM gen_file WHERE gen01=g_ocn[l_ac].ocn01
                  IF STATUS THEN LET g_ocn[l_ac].gen02='' END IF
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO ocn_file(ocn01,ocn02,ocn03,ocn04,ocn05,ocn06,ocn07)
                       VALUES(g_ocn[l_ac].ocn01,g_ocn[l_ac].ocn02,
                              g_ocn[l_ac].ocn03,g_ocn[l_ac].ocn04,
                              g_ocn[l_ac].ocn05,g_ocn[l_ac].ocn06,
                              g_ocn[l_ac].ocn07)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ocn_file",g_ocn[l_ac].ocn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ocn[l_ac].* TO NULL      #900423
         LET g_ocn_t.* = g_ocn[l_ac].*         #新輸入資料
         LET g_ocn[l_ac].ocn02=0 
         LET g_ocn[l_ac].ocn03=0
         LET g_ocn[l_ac].ocn04=0
         LET g_ocn[l_ac].ocn06="Y"
         CALL cl_show_fld_cont()  
         NEXT FIELD ocn01
 
      AFTER FIELD ocn01  
         IF NOT cl_null(g_ocn[l_ac].ocn01) THEN
            IF cl_null(g_ocn_t.ocn01) OR g_ocn_t.ocn01 <> g_ocn[l_ac].ocn01 THEN 
               SELECT gen02 INTO g_ocn[l_ac].gen02
                 FROM gen_file WHERE gen01=g_ocn[l_ac].ocn01
               IF STATUS THEN 
                  CALL cl_err(g_ocn[l_ac].ocn01,SQLCA.sqlcode,0) #No.TQC-6B0089
                  LET g_ocn[l_ac].gen02='' 
                  NEXT FIELD ocn01 
               END IF
               SELECT COUNT(*) INTO l_n FROM ocn_file
                WHERE ocn01 = g_ocn[l_ac].ocn01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ocn[l_ac].ocn01 = g_ocn_t.ocn01
                  NEXT FIELD ocn01
               END IF
            END IF
         END IF
      
      AFTER FIELD ocn02
         IF cl_null(g_ocn[l_ac].ocn02) OR g_ocn[l_ac].ocn02<0 THEN
            CALL cl_err("","aap-022",0)
            LET g_ocn[l_ac].ocn02 = g_ocn_t.ocn02
            NEXT FIELD ocn02
         ELSE   
            LET g_ocn[l_ac].ocn04 = g_ocn[l_ac].ocn02 - g_ocn[l_ac].ocn03
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ocn_t.ocn01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ocn_file 
             WHERE ocn01 = g_ocn_t.ocn01 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ocn_file",g_ocn_t.ocn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
 
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i190_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ocn[l_ac].* = g_ocn_t.*
            CLOSE i190_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ocn[l_ac].ocn01,-263,1)
            LET g_ocn[l_ac].* = g_ocn_t.*
         ELSE
            UPDATE ocn_file SET ocn01=g_ocn[l_ac].ocn01,
                                ocn02=g_ocn[l_ac].ocn02,
                                ocn03=g_ocn[l_ac].ocn03,
                                ocn04=g_ocn[l_ac].ocn04,
                                ocn05=g_ocn[l_ac].ocn05,
                                ocn06=g_ocn[l_ac].ocn06,
                                ocn07=g_ocn[l_ac].ocn07
              WHERE ocn01=g_ocn_t.ocn01 
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ocn_file",g_ocn_t.ocn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                LET g_ocn[l_ac].* = g_ocn_t.*
            ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i190_bcl
                COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ocn[l_ac].* = g_ocn_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_ocn.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i190_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE i190_bcl
         COMMIT WORK
 
      ON ACTION CONTROLN
         CALL i190_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO 
         IF INFIELD(ocn01) AND l_ac > 1 THEN
            LET g_ocn[l_ac].* = g_ocn[l_ac-1].*
            NEXT FIELD ocn01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(ocn01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_ocn[l_ac].ocn01
               CALL cl_create_qry() RETURNING g_ocn[l_ac].ocn01
               DISPLAY BY NAME g_ocn[l_ac].ocn01
               NEXT FIELD ocn01
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
 
        
   END INPUT
 
   CLOSE i190_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i190_b_askkey()
 
   CLEAR FORM
   CALL g_ocn.clear()
 
   CONSTRUCT g_wc2 ON ocn01,ocn02,ocn03,ocn04,ocn05,ocn06,ocn07
         FROM s_ocn[1].ocn01,s_ocn[1].ocn02,s_ocn[1].ocn03,s_ocn[1].ocn04,
              s_ocn[1].ocn05,s_ocn[1].ocn06,s_ocn[1].ocn07 
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(ocn01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_ocn[1].ocn01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_ocn[1].ocn01
               NEXT FIELD ocn01
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i190_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i190_b_fill(p_wc2)
   DEFINE 
       #p_wc2   LIKE type_file.chr1000
        p_wc2        STRING       #NO.FUN-910082
 
   LET g_sql = "SELECT ocn01,'',ocn02,ocn03,ocn04,",
               "       ocn05,ocn06,ocn07",
               "  FROM ocn_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY ocn01"
 
   PREPARE i190_pb FROM g_sql
   DECLARE ocn_curs CURSOR FOR i190_pb
 
   CALL g_ocn.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH ocn_curs INTO g_ocn[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT gen02 INTO g_ocn[g_cnt].gen02 FROM gen_file
       WHERE gen01 = g_ocn[g_cnt].ocn01
 
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
     
   END FOREACH
 
   CALL g_ocn.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i190_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ocn TO s_ocn.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
