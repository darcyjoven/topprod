DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE 
       g_tc_prog   DYNAMIC ARRAY OF RECORD
         tc_prog01  LIKE tc_prog_file.tc_prog01,
         tc_prog02  LIKE tc_prog_file.tc_prog02
                   END RECORD,
      g_tc_prog_t  RECORD
         tc_prog01  LIKE tc_prog_file.tc_prog01,
         tc_prog02  LIKE tc_prog_file.tc_prog02
                   END RECORD,

       g_wc        STRING,
       g_wc2       STRING,                       #單身CONSTRUCT結果
       g_rec_b     LIKE type_file.num5,
       l_ac        LIKE type_file.num5,
       l_ac_t      LIKE type_file.num5,
       g_sql       STRING

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        #No.FUN-680102
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_chr                 LIKE azb_file.azbacti        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   CALL g_tc_prog.clear()

   LET g_forupd_sql = "SELECT * FROM tc_prog_file WHERE tc_prog01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i001_w WITH FORM "aoo/42f/aooi001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()


   LET g_action_choice = ""
   CALL i001_menu()

   CLOSE WINDOW i001_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i001_b_askkey()

    CLEAR FORM
    CALL g_tc_prog.clear()
    CONSTRUCT g_wc ON                     # 螢幕上取條件
        tc_prog01,tc_prog02
        FROM s_tc_prog[l_ac].tc_prog01,s_tc_prog[l_ac].tc_prog02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        --ON ACTION controlp
           --CASE
              --WHEN INFIELD(tc_prog01)
                 --CALL cl_init_qry_var()
                 --LET g_qryparam.form = "cq_tc_prog"
                 --LET g_qryparam.state = "c"
                 --CALL cl_create_qry() RETURNING g_qryparam.multiret
                 --DISPLAY g_qryparam.multiret TO tc_prog01
                 --NEXT FIELD tc_prog01
              --
              --OTHERWISE
                 --EXIT CASE
           --END CASE
       
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i001_b_fill(g_wc)

END FUNCTION

FUNCTION i001_menu()

   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_prog),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i001_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_prog TO s_tc_prog.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
       
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
#      ON ACTION related_document                #No.FUN-6A0162  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i001_q()

   CALL i001_b_askkey()
END FUNCTION

FUNCTION i001_b()
DEFINE
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_n             LIKE type_file.num5,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,
    l_num           LIKE type_file.num5

    LET g_action_choice = ""
    
    IF s_shut(0) THEN
       RETURN
    END IF
    
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT tc_prog01,tc_prog02",
                       "  FROM tc_prog_file",
                       "  WHERE tc_prog01 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_tc_prog WITHOUT DEFAULTS FROM s_tc_prog.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_prog_t.* = g_tc_prog[l_ac].*
              OPEN i001_bcl USING g_tc_prog_t.tc_prog01
              IF STATUS THEN
                 CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i001_bcl INTO g_tc_prog[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_prog_t.tc_prog01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_prog[l_ac].* TO NULL      #900423
         #  LET g_tc_prog[l_ac].tc_progacti = 'Y'
           LET g_tc_prog_t.* = g_tc_prog[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
        #   NEXT FIELD tc_prog01

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO tc_prog_file(tc_prog01,tc_prog02)
           VALUES(g_tc_prog[l_ac].tc_prog01,g_tc_prog[l_ac].tc_prog02)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_prog_file",g_tc_prog_t.tc_prog01,"",SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'  
              COMMIT WORK
              LET g_rec_b=g_rec_b+1 
              DISPLAY g_rec_b TO FORMONLY.cn2    
           END IF

         AFTER FIELD tc_prog01                 
             IF NOT cl_null(g_tc_prog[l_ac].tc_prog01) THEN
                IF g_tc_prog_t.tc_prog01 IS NULL OR
                 (g_tc_prog_t.tc_prog01 != g_tc_prog[l_ac].tc_prog01 ) THEN
                     IF NOT cl_null(g_tc_prog_t.tc_prog01) THEN 
                       LET l_num=0
                       SELECT COUNT(*) INTO l_num FROM tc_auth_file WHERE tc_auth02= '2'
                                                                      AND tc_auth03=g_tc_prog_t.tc_prog01
                       IF l_num>0 THEN
                       	  CALL cl_err('此作业已被用户权限使用,不可修改','!',0)
                       	  NEXT FIELD tc_prog01
                       END IF
                       SELECT COUNT(*) INTO l_num FROM tc_authg_file WHERE tc_authg03=g_tc_prog_t.tc_prog01
                       IF l_num>0 THEN
                       	  CALL cl_err('此作业已被权限组使用,不可修改','!',0)
                       	  NEXT FIELD tc_prog01
                       END IF
                     END IF
                END IF
             END IF 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           LET l_num=0
           SELECT COUNT(*) INTO l_num FROM tc_auth_file WHERE tc_auth02= '2'
                                                          AND tc_auth03=g_tc_prog_t.tc_prog01
           IF l_num>0 THEN
           	  CALL cl_err('此作业已被用户权限使用,不可删除','!',0)
           	  CANCEL DELETE
           END IF
           SELECT COUNT(*) INTO l_num FROM tc_authg_file WHERE tc_authg03=g_tc_prog_t.tc_prog01
           IF l_num>0 THEN
           	  CALL cl_err('此作业已被权限组使用,不可删除','!',0)
           	  CANCEL DELETE
           END IF
           IF g_tc_prog_t.tc_prog01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE    
              END IF              
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE    
              END IF              
              DELETE FROM tc_prog_file
               WHERE tc_prog01 = g_tc_prog_t.tc_prog01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_prog_file",g_tc_prog_t.tc_prog01,"",SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tc_prog[l_ac].* = g_tc_prog_t.*
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_prog[l_ac].tc_prog01,-263,1)
              LET g_tc_prog[l_ac].* = g_tc_prog_t.*
           ELSE
              UPDATE tc_prog_file SET tc_prog01 = g_tc_prog[l_ac].tc_prog01,tc_prog02 = g_tc_prog[l_ac].tc_prog02 
              WHERE tc_prog01=g_tc_prog_t.tc_prog01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_prog_file",g_tc_prog_t.tc_prog01,"",SQLCA.sqlcode,"","",1)
                 LET g_tc_prog[l_ac].* = g_tc_prog_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_prog[l_ac].* = g_tc_prog_t.*
              END IF
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i001_bcl
           COMMIT WORK                
                                  
        ON ACTION CONTROLZ        
           CALL cl_show_req_fields()
                                  
        ON ACTION CONTROLG        
           CALL cl_cmdask()       
                 
        --ON ACTION controlp
           --CASE
             --WHEN INFIELD(tc_hfc03) #廠商編號
               --CALL cl_init_qry_var()
               --LET g_qryparam.form ="q_pmc1"   #MOD-920024 q_pmc2-->q_pmc1
               --LET g_qryparam.default1 = g_tc_hfc[l_ac].tc_hfc03
               --CALL cl_create_qry() RETURNING g_tc_hfc[l_ac].tc_hfc03
               --DISPLAY BY NAME g_tc_hfc[l_ac].tc_hfc03
               --NEXT FIELD tc_hfc03
           --END CASE

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
                    
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
              
    CLOSE i001_bcl 
    COMMIT WORK  

END FUNCTION

FUNCTION i001_b_fill(p_wc2)
DEFINE p_wc2  STRING
   LET g_sql = "SELECT tc_prog01,tc_prog02",
                       "  FROM tc_prog_file",
               " WHERE ",p_wc2 CLIPPED

   LET g_sql=g_sql CLIPPED," ORDER BY tc_prog01"
   DISPLAY g_sql

   PREPARE i001_pb FROM g_sql
   DECLARE tc_prog_cs CURSOR FOR i001_pb

   CALL g_tc_prog.clear()
   LET g_cnt = 1

   FOREACH tc_prog_cs INTO g_tc_prog[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_tc_prog.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
