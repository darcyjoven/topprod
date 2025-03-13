# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi351.4gl
# Descriptions...: MDS沖銷-料號優先序設定作業
# Date & Author..: No:FUN-AB0090 2010/11/25 By Mandy
# Modify.........: No.FUN-B50022 11/05/10 By Mandy---(1)GP5.25 追版:以上為GP5.1 的單號---
# Modify.........:                                   (2)AFTER FIELD vlp03 資料重覆判斷有誤 

DATABASE ds

GLOBALS "../../config/top.global"

#page1
DEFINE 
     g_vlp       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        vlp02       LIKE vlp_file.vlp02,   #
        vlp03       LIKE vlp_file.vlp03,   #
        ima02       LIKE ima_file.ima02,   #
        ima131      LIKE ima_file.ima131,  #
        oba02       LIKE oba_file.oba02,   #
        vlpacti     LIKE vlp_file.vlpacti     
                 END RECORD,
     g_vlp_t     RECORD                 #程式變數 (舊值)
        vlp02       LIKE vlp_file.vlp02,   #
        vlp03       LIKE vlp_file.vlp03,   #
        ima02       LIKE ima_file.ima02,   #
        ima131      LIKE ima_file.ima131,  #
        oba02       LIKE oba_file.oba02,   #
        vlpacti     LIKE vlp_file.vlpacti     
                 END RECORD,
     g_wc2,g_sql    string,  
     g_rec_b         LIKE type_file.num5,     
     l_ac            LIKE type_file.num5      

DEFINE g_forupd_sql STRING   
DEFINE g_cnt                 LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5     
DEFINE g_i                   LIKE type_file.num5    
DEFINE l_table      STRING         
DEFINE g_str        STRING        
DEFINE g_vlp01               LIKE vlp_file.vlp01
DEFINE l_action_flag         STRING

MAIN
DEFINE p_row,p_col   LIKE type_file.num5      
    #FUN-B50022--mod---str---
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    #FUN-B50022--mod---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
   LET p_row = 5 LET p_col = 22
   OPEN WINDOW i351_w AT p_row,p_col WITH FORM "aps/42f/apsi351"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("vlpacti",FALSE)
   LET g_vlp01 = '1'
   LET g_wc2 = '1=1' CALL i351_b_fill(g_wc2)
   CALL i351_menu()
   CLOSE WINDOW i351_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
        RETURNING g_time    
END MAIN

FUNCTION i351_menu()
   WHILE TRUE
      CALL i351_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i351_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i351_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vlp),'','')
            END IF

         #匯入料號
         WHEN "auto_gen_item"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("apsp351")
               CALL i351_b_fill(' 1=1')
            END IF

         #依料件編號排序
         WHEN "reorder_vlp_item"   
            IF cl_chk_act_auth() THEN
               LET g_success = 'Y'
               BEGIN WORK
               CALL s_reorder_vlp_3(g_vlp01)
               IF g_success = 'Y' THEN
                   COMMIT WORK
               ELSE
                   ROLLBACK WORK
               END IF
               CALL i351_b_fill(' 1=1')
            END IF

         #依產品分類碼排序
         WHEN "reorder_vlp_2"   
            IF cl_chk_act_auth() THEN
               LET g_success = 'Y'
               BEGIN WORK
               CALL s_reorder_vlp_2()
               IF g_success = 'Y' THEN
                   COMMIT WORK
               ELSE
                   ROLLBACK WORK
               END IF
               CALL i351_b_fill(' 1=1')
            END IF
         #項次由10重排
         WHEN "reorder_vlp_1"   
            IF cl_chk_act_auth() THEN
               LET g_success = 'Y'
               BEGIN WORK
               CALL s_reorder_vlp_1(g_vlp01)
               IF g_success = 'Y' THEN
                   COMMIT WORK
               ELSE
                   ROLLBACK WORK
               END IF
               CALL i351_b_fill(' 1=1')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i351_q()
   CALL i351_b_askkey()
END FUNCTION

FUNCTION i351_b()
DEFINE
    l_syc06         LIKE type_file.chr30, #110519 add
    l_cnt           LIKE type_file.num5,  #110519 add
    l_ac_t          LIKE type_file.num5,      
    l_n             LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,      
    p_cmd           LIKE type_file.chr1,      
    l_allow_insert  LIKE type_file.chr1,      
    l_allow_delete  LIKE type_file.chr1       

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT vlp02,vlp03,'','','',vlpacti ",
                       "  FROM vlp_file",
                       " WHERE vlp01=? ",
                       "   AND vlp03=? ",
                      #"FOR UPDATE NOWAIT" #FUN-B50022 mark
                       "FOR UPDATE "       #FUN-B50022 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50022 add
    DECLARE i351_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_vlp WITHOUT DEFAULTS FROM s_vlp.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_vlp_t.* = g_vlp[l_ac].*  #BACKUP
               OPEN i351_bcl USING g_vlp01,g_vlp_t.vlp03
               IF STATUS THEN
                  CALL cl_err("OPEN i351_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i351_bcl INTO g_vlp[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_vlp_t.vlp03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL i351_vlp03('d')
               CALL cl_show_fld_cont()     
            END IF

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_vlp[l_ac].* TO NULL      
           LET g_vlp[l_ac].vlpacti = 'Y'         #Body default
           LET g_vlp_t.* = g_vlp[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()   
           NEXT FIELD vlp02

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i351_bcl
              CANCEL INSERT
           END IF
           INSERT INTO vlp_file(vlp01,vlp02,vlp03,vlpacti,vlpuser,vlpdate)
                         VALUES(g_vlp01,g_vlp[l_ac].vlp02,
                                g_vlp[l_ac].vlp03,g_vlp[l_ac].vlpacti,g_user,g_today)
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","vlp_file",g_vlp01,g_vlp[l_ac].vlp03,SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF

        BEFORE FIELD vlp02                        #default 順序
           IF g_vlp[l_ac].vlp02 IS NULL OR g_vlp[l_ac].vlp02 = 0 THEN
              SELECT max(vlp02)+10
                INTO g_vlp[l_ac].vlp02
                FROM vlp_file
               WHERE vlp01 = g_vlp01
              IF cl_null(g_vlp[l_ac].vlp02) THEN
                 LET g_vlp[l_ac].vlp02 = 10
              END IF
           END IF

       AFTER FIELD vlp03
           IF NOT cl_null(g_vlp[l_ac].vlp03) THEN
               IF g_vlp[l_ac].vlp03 != g_vlp_t.vlp03 OR
                  g_vlp_t.vlp03 IS NULL THEN
                    SELECT COUNT(*) 
                      INTO l_n FROM vlp_file
                     WHERE vlp03 = g_vlp[l_ac].vlp03
                       AND vlp01 = g_vlp01 #FUN-B50022(2) add
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_vlp[l_ac].vlp03 = g_vlp_t.vlp03
                        NEXT FIELD vlp03
                    END IF
                    CALL i351_vlp03('a')
                    IF NOT cl_null(g_errno)  THEN
                        CALL cl_err('',g_errno,0) 
                        LET g_vlp[l_ac].vlp03 = g_vlp_t.vlp03
                        NEXT FIELD vlp03
                    END IF
               END IF
          END IF
                                                  	
       AFTER FIELD vlpacti
          IF NOT cl_null(g_vlp[l_ac].vlpacti) THEN
             IF g_vlp[l_ac].vlpacti NOT MATCHES '[YN]' THEN
                LET g_vlp[l_ac].vlpacti = g_vlp_t.vlpacti
                NEXT FIELD vlpacti
             END IF
          END IF
      
        BEFORE DELETE                            #是否取消單身
            IF g_vlp_t.vlp03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM vlp_file 
                 WHERE vlp01 = g_vlp01
                   AND vlp03 = g_vlp_t.vlp03
                IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","vlp_file",g_vlp01,g_vlp_t.vlp03,SQLCA.sqlcode,"","",1)   
                     EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_vlp[l_ac].* = g_vlp_t.*
              CLOSE i351_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_vlp[l_ac].vlp03,-263,0)
               LET g_vlp[l_ac].* = g_vlp_t.*
           ELSE
               UPDATE vlp_file 
                  SET vlp02=g_vlp[l_ac].vlp02,
                      vlp03=g_vlp[l_ac].vlp03,
                      vlpacti=g_vlp[l_ac].vlpacti,
                      vlpmodu=g_user,
                      vlpdate=g_today
                WHERE vlp01 = g_vlp01
                  AND vlp03 = g_vlp_t.vlp03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","vlp_file",g_vlp01,g_vlp_t.vlp03,SQLCA.sqlcode,"","",1) 
                   LET g_vlp[l_ac].* = g_vlp_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_vlp[l_ac].* = g_vlp_t.*
              END IF
              CLOSE i351_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i351_bcl
           COMMIT WORK

       ON ACTION controlp
           CASE WHEN INFIELD(vlp03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.default1 = g_vlp[l_ac].vlp03
                   CALL cl_create_qry() RETURNING g_vlp[l_ac].vlp03
                   DISPLAY g_vlp[l_ac].vlp03 TO vlp03
                   CALL i351_vlp03('a')
                OTHERWISE
                   EXIT CASE
            END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vlp02) AND l_ac > 1 THEN
                LET g_vlp[l_ac].* = g_vlp[l_ac-1].*
                NEXT FIELD vlp02
            END IF

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
        
        END INPUT


    CLOSE i351_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i351_vlp03(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1    
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima131   LIKE ima_file.ima131
   DEFINE l_imaacti  LIKE ima_file.imaacti
   DEFINE l_oba02    LIKE oba_file.oba02   


   LET g_errno = ' '
   SELECT   ima02,  ima131,  imaacti,  oba02
     INTO l_ima02,l_ima131,l_imaacti,l_oba02
     FROM ima_file,OUTER oba_file
    WHERE ima01 = g_vlp[l_ac].vlp03
      AND ima131 = oba_file.oba01

   CASE WHEN SQLCA.SQLCODE = 100       LET g_errno = 'mfg3006'
                                       LET l_ima02 = NULL
                                       LET l_ima131 = NULL
                                       LET l_imaacti = NULL
        WHEN l_imaacti='N'             LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'
        OTHERWISE                      LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_vlp[l_ac].ima02  = l_ima02
      LET g_vlp[l_ac].ima131 = l_ima131
      LET g_vlp[l_ac].oba02  = l_oba02
      DISPLAY BY NAME g_vlp[l_ac].ima02
      DISPLAY BY NAME g_vlp[l_ac].ima131
      DISPLAY BY NAME g_vlp[l_ac].oba02
   END IF

END FUNCTION

FUNCTION i351_b_askkey()

    CLEAR FORM
   CALL g_vlp.clear()

    CONSTRUCT g_wc2 ON vlp02,vlp03,vlpacti
         FROM s_vlp[1].vlp02,s_vlp[1].vlp03,s_vlp[1].vlpacti

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION controlp
             CASE WHEN INFIELD(vlp03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_vlp[1].vlp03            
                     CALL i351_vlp03('a')
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

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL i351_b_fill(g_wc2)

END FUNCTION

FUNCTION i351_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No:FUN-680102 VARCHAR(200)

    LET g_sql =
        "SELECT vlp02,vlp03,ima02,ima131,oba02,vlpacti",
        " FROM vlp_file,OUTER ima_file,OUTER oba_file",
        " WHERE vlp03 = ima_file.ima01 ",
        "   AND vlp01 = '",g_vlp01,"'",
        "   AND ima131 = oba_file.oba01 ",
        "   AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY vlp02,vlp03"
    PREPARE i351_pb FROM g_sql
    DECLARE vlp_curs CURSOR FOR i351_pb

    CALL g_vlp.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH vlp_curs INTO g_vlp[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vlp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0

END FUNCTION

FUNCTION i351_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No:FUN-680102 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vlp TO s_vlp.* ATTRIBUTE(COUNT=g_rec_b)

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

      #匯入料號
      ON ACTION auto_gen_item
         LET g_action_choice="auto_gen_item"
         EXIT DISPLAY

      #依料件編號排序
      ON ACTION reorder_vlp_item
         LET g_action_choice="reorder_vlp_item"
         EXIT DISPLAY

      #依產品分類碼排序
      ON ACTION reorder_vlp_2
         LET g_action_choice="reorder_vlp_2"
         EXIT DISPLAY

      #項次由10重排
      ON ACTION reorder_vlp_1
         LET g_action_choice="reorder_vlp_1"
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

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-AB0090
