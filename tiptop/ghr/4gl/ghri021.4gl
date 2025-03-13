# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri021.4gl
# Descriptions...: 合同类型维护作业 
# Date & Author..: 13/04/24 By yangjian

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrbe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrbe01       LIKE hrbe_file.hrbe01,        #合同编码
        hrbe02       LIKE hrbe_file.hrbe02,        #名称
        hrbe03       LIKE hrbe_file.hrbe03,        #合同类型编码
        hrag07       LIKE hrag_file.hrag07,        #类型名称
        hrbe04       LIKE hrbe_file.hrbe04,        #是否作为劳动合同附件
        hrbe05       LIKE hrbe_file.hrbe05,        #是否与劳动合同同时解除
        hrbe06       LIKE hrbe_file.hrbe06,        #是否生效
        hrbe07       LIKE hrbe_file.hrbe07,        #生效日期
        hrbeacti     LIKE hrbe_file.hrbeacti,      #资料有效否
        hrbeud01     LIKE hrbe_file.hrbeud01,
        hrbeud02     LIKE hrbe_file.hrbeud02,
        hrbeud03     LIKE hrbe_file.hrbeud03,
        hrbeud04     LIKE hrbe_file.hrbeud04,
        hrbeud05     LIKE hrbe_file.hrbeud05,
        hrbeud06     LIKE hrbe_file.hrbeud06,
        hrbeud07     LIKE hrbe_file.hrbeud07,
        hrbeud08     LIKE hrbe_file.hrbeud08,
        hrbeud09     LIKE hrbe_file.hrbeud09,
        hrbeud10     LIKE hrbe_file.hrbeud10,
        hrbeud11     LIKE hrbe_file.hrbeud11,
        hrbeud12     LIKE hrbe_file.hrbeud12,
        hrbeud13     LIKE hrbe_file.hrbeud13,
        hrbeud14     LIKE hrbe_file.hrbeud14,
        hrbeud15     LIKE hrbe_file.hrbeud15
                    END RECORD,
    g_hrbe_t         RECORD                 #程式變數 (舊值)
        hrbe01       LIKE hrbe_file.hrbe01,        #合同编码
        hrbe02       LIKE hrbe_file.hrbe02,        #名称
        hrbe03       LIKE hrbe_file.hrbe03,        #合同类型编码
        hrag07       LIKE hrag_file.hrag07,        #类型名称
        hrbe04       LIKE hrbe_file.hrbe04,        #是否作为劳动合同附件
        hrbe05       LIKE hrbe_file.hrbe05,        #是否与劳动合同同时解除
        hrbe06       LIKE hrbe_file.hrbe06,        #是否生效
        hrbe07       LIKE hrbe_file.hrbe07,        #生效日期
        hrbeacti     LIKE hrbe_file.hrbeacti,      #资料有效否
        hrbeud01     LIKE hrbe_file.hrbeud01,
        hrbeud02     LIKE hrbe_file.hrbeud02,
        hrbeud03     LIKE hrbe_file.hrbeud03,
        hrbeud04     LIKE hrbe_file.hrbeud04,
        hrbeud05     LIKE hrbe_file.hrbeud05,
        hrbeud06     LIKE hrbe_file.hrbeud06,
        hrbeud07     LIKE hrbe_file.hrbeud07,
        hrbeud08     LIKE hrbe_file.hrbeud08,
        hrbeud09     LIKE hrbe_file.hrbeud09,
        hrbeud10     LIKE hrbe_file.hrbeud10,
        hrbeud11     LIKE hrbe_file.hrbeud11,
        hrbeud12     LIKE hrbe_file.hrbeud12,
        hrbeud13     LIKE hrbe_file.hrbeud13,
        hrbeud14     LIKE hrbe_file.hrbeud14,
        hrbeud15     LIKE hrbe_file.hrbeud15
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN       
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110          #No.FUN-680102 SMALLINT
DEFINE   g_str               STRING                     #No.FUN-760083
MAIN
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680102 SMALLINT
     
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 25
    OPEN WINDOW i021_w AT p_row,p_col WITH FORM "ghr/42f/ghri021"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    LET g_wc2 = '1=1' CALL i021_b_fill(g_wc2)
    CALL i021_menu()
    CLOSE WINDOW i021_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i021_menu()
 
   WHILE TRUE
      CALL i021_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i021_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i021_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrbe[l_ac].hrbe01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbe01"
                  LET g_doc.value1 = g_hrbe[l_ac].hrbe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i021_q()
   CALL i021_b_askkey()
END FUNCTION
 
FUNCTION i021_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102               #可刪除否
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
DEFINE l_hrag       RECORD LIKE hrag_file.*
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbe01 FROM hrbe_file",
                       " WHERE hrbe01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrbe WITHOUT DEFAULTS FROM s_hrbe.*
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
               LET g_before_input_done = FALSE                                  
               CALL i021_set_entry(p_cmd)                                       
               CALL i021_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               LET g_hrbe_t.* = g_hrbe[l_ac].*  #BACKUP
               OPEN i021_bcl USING g_hrbe_t.hrbe01
               IF STATUS THEN
                  CALL cl_err("OPEN i021_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i021_bcl INTO g_hrbe[l_ac].hrbe01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrbe_t.hrbe01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                      
           CALL i021_set_entry(p_cmd)                                           
           CALL i021_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           INITIALIZE g_hrbe[l_ac].* TO NULL      #900423
           LET g_hrbe[l_ac].hrbeacti = 'Y'         #Body default
           LET g_hrbe[l_ac].hrbe04 = 'Y'
           LET g_hrbe[l_ac].hrbe05 = 'Y'
           LET g_hrbe[l_ac].hrbe06 = 'Y'
           LET g_hrbe[l_ac].hrbeacti = 'Y'
           LET g_hrbe_t.* = g_hrbe[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrbe01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i021_bcl
              CANCEL INSERT
           END IF
           INSERT INTO hrbe_file(hrbe01,hrbe02,hrbe03,hrbe04,hrbe05,hrbe06,hrbe07,
                                 hrbeacti,hrbeuser,hrbegrup,hrbemodu,hrbedate,hrbeoriu,hrbeorig,
                                 hrbeud01,hrbeud02,hrbeud03,hrbeud04,hrbeud05,hrbeud06,hrbeud07,
                                 hrbeud08,hrbeud09,hrbeud10,hrbeud11,hrbeud12,hrbeud13,hrbeud14,
                                 hrbeud15)      
                         VALUES(g_hrbe[l_ac].hrbe01,g_hrbe[l_ac].hrbe02,g_hrbe[l_ac].hrbe03,
                                g_hrbe[l_ac].hrbe04,g_hrbe[l_ac].hrbe05,g_hrbe[l_ac].hrbe06,
                                g_hrbe[l_ac].hrbe07,g_hrbe[l_ac].hrbeacti,
                                g_user,g_grup,g_user,g_today, g_user, g_grup,
                                g_hrbe[l_ac].hrbeud01,g_hrbe[l_ac].hrbeud02,g_hrbe[l_ac].hrbeud03,
                                g_hrbe[l_ac].hrbeud04,g_hrbe[l_ac].hrbeud05,g_hrbe[l_ac].hrbeud06,
                                g_hrbe[l_ac].hrbeud07,g_hrbe[l_ac].hrbeud08,g_hrbe[l_ac].hrbeud09,
                                g_hrbe[l_ac].hrbeud10,g_hrbe[l_ac].hrbeud11,g_hrbe[l_ac].hrbeud12,
                                g_hrbe[l_ac].hrbeud13,g_hrbe[l_ac].hrbeud14,g_hrbe[l_ac].hrbeud15)     
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrbe_file",g_hrbe[l_ac].hrbe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
     
      AFTER FIELD hrbe01
           IF NOT cl_null(g_hrbe[l_ac].hrbe01) THEN 
              SELECT COUNT(*) INTO l_n FROM hrbe_file WHERE hrbe01 = g_hrbe[l_ac].hrbe01
              IF l_n > 0 THEN 
                 CALL cl_err('',-239,0)
                 LET g_hrbe[l_ac].hrbe01 = g_hrbe_t.hrbe01 
                 NEXT FIELD hrbe01
              END IF 
           END IF 
    
     AFTER FIELD hrbe03
          IF NOT cl_null(g_hrbe[l_ac].hrbe03) THEN 
             CALL s_code('401',g_hrbe[l_ac].hrbe03) RETURNING l_hrag.*
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err(g_hrbe[l_ac].hrbe03,g_errno,0)
                LET g_hrbe[l_ac].hrbe03 = g_hrbe_t.hrbe03 
                NEXT FIELD hrbe03
             ELSE
                LET g_hrbe[l_ac].hrag07 = l_hrag.hrag07
                DISPLAY BY NAME g_hrbe[l_ac].hrag07
             END IF 
          END IF 

     AFTER FIELD hrbe04
           IF NOT cl_null(g_hrbe[l_ac].hrbe04) THEN
              IF g_hrbe[l_ac].hrbe04 NOT MATCHES '[YN]' OR
                 cl_null(g_hrbe[l_ac].hrbe04) THEN
                 LET g_hrbe[l_ac].hrbe04 = g_hrbe_t.hrbe04
                 NEXT FIELD hrbe04
              END IF
           END IF
           
     AFTER FIELD hrbe05
           IF NOT cl_null(g_hrbe[l_ac].hrbe05) THEN
              IF g_hrbe[l_ac].hrbe05 NOT MATCHES '[YN]' OR
                 cl_null(g_hrbe[l_ac].hrbe05) THEN
                 LET g_hrbe[l_ac].hrbe05 = g_hrbe_t.hrbe05
                 NEXT FIELD hrbe05
              END IF
           END IF   
           
     AFTER FIELD hrbe06
           IF NOT cl_null(g_hrbe[l_ac].hrbe06) THEN
              IF g_hrbe[l_ac].hrbe06 NOT MATCHES '[YN]' OR
                 cl_null(g_hrbe[l_ac].hrbe06) THEN
                 LET g_hrbe[l_ac].hrbe06 = g_hrbe_t.hrbe06
                 NEXT FIELD hrbe06
              END IF
              IF g_hrbe[l_ac].hrbe06 = 'Y' THEN 
              	 LET g_hrbe[l_ac].hrbe07 = g_today
              	 CALL cl_set_comp_entry("hrbe07",TRUE)
              	 CALL cl_set_comp_required("hrbe07",TRUE)
              ELSE 
                 LET g_hrbe[l_ac].hrbe07 = NULL 
                 CALL cl_set_comp_required("hrbe07",FALSE) 
              	 CALL cl_set_comp_entry("hrbe07",FALSE)
              END IF 
           END IF                      
                            
        AFTER FIELD hrbeacti
           IF NOT cl_null(g_hrbe[l_ac].hrbeacti) THEN
              IF g_hrbe[l_ac].hrbeacti NOT MATCHES '[YN]' OR
                 cl_null(g_hrbe[l_ac].hrbeacti) THEN
                 LET g_hrbe[l_ac].hrbeacti = g_hrbe_t.hrbeacti
                 NEXT FIELD hrbeacti
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_hrbe_t.hrbe01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "hrbe01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_hrbe[l_ac].hrbe01      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM hrbe_file WHERE hrbe01 = g_hrbe_t.hrbe01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","hrbe_file",g_hrbe_t.hrbe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
              LET g_hrbe[l_ac].* = g_hrbe_t.*
              CLOSE i021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrbe[l_ac].hrbe01,-263,0)
               LET g_hrbe[l_ac].* = g_hrbe_t.*
           ELSE
               UPDATE hrbe_file 
                  SET hrbe01=g_hrbe[l_ac].hrbe01,hrbe02=g_hrbe[l_ac].hrbe02,
                      hrbe03=g_hrbe[l_ac].hrbe03,hrbe04=g_hrbe[l_ac].hrbe04,
                      hrbe05=g_hrbe[l_ac].hrbe05,hrbe06=g_hrbe[l_ac].hrbe06,
                      hrbe07=g_hrbe[l_ac].hrbe07,hrbeacti=g_hrbe[l_ac].hrbeacti,
                      hrbemodu=g_user,hrbedate=g_today,
                      hrbeud01=g_hrbe[l_ac].hrbeud01,hrbeud02=g_hrbe[l_ac].hrbeud02,
                      hrbeud03=g_hrbe[l_ac].hrbeud03,hrbeud04=g_hrbe[l_ac].hrbeud04,
                      hrbeud05=g_hrbe[l_ac].hrbeud05,hrbeud06=g_hrbe[l_ac].hrbeud06,
                      hrbeud07=g_hrbe[l_ac].hrbeud07,hrbeud08=g_hrbe[l_ac].hrbeud08,
                      hrbeud09=g_hrbe[l_ac].hrbeud09,hrbeud10=g_hrbe[l_ac].hrbeud10,
                      hrbeud11=g_hrbe[l_ac].hrbeud11,hrbeud12=g_hrbe[l_ac].hrbeud12,
                      hrbeud13=g_hrbe[l_ac].hrbeud13,hrbeud14=g_hrbe[l_ac].hrbeud14,
                      hrbeud15=g_hrbe[l_ac].hrbeud15
                WHERE hrbe01=g_hrbe_t.hrbe01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrbe_file",g_hrbe_t.hrbe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_hrbe[l_ac].* = g_hrbe_t.*
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
                 LET g_hrbe[l_ac].* = g_hrbe_t.*
              END IF
              CLOSE i021_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE i021_bcl            # 新增
           COMMIT WORK

        ON ACTION controlp
           CASE 
              WHEN INFIELD(hrbe03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrag06"
                  LET g_qryparam.default1 = g_hrbe[l_ac].hrbe03
                  LET g_qryparam.arg1 = '401'
                  LET g_qryparam.construct='N'
                  CALL cl_create_qry() RETURNING g_hrbe[l_ac].hrbe03
                  DISPLAY BY NAME g_hrbe[l_ac].hrbe03
                  NEXT FIELD hrbe03
           END CASE

        ON ACTION controlo
            IF INFIELD(hrbe01) AND l_ac > 1 THEN
                LET g_hrbe[l_ac].* = g_hrbe[l_ac-1].*
                NEXT FIELD hrbe01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
    CLOSE i021_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i021_b_askkey()
    CLEAR FORM
   CALL g_hrbe.clear()
    CONSTRUCT g_wc2 ON hrbe01,hrbe02,hrbe03,hrbe04,hrbe05,hrbe06,hrbe07,hrbeacti,
                       hrbeud01,hrbeud02,hrbeud03,hrbeud04,hrbeud05,
                       hrbeud06,hrbeud07,hrbeud08,hrbeud09,hrbeud10,
                       hrbeud11,hrbeud12,hrbeud13,hrbeud14,hrbeud15
         FROM s_hrbe[1].hrbe01,s_hrbe[1].hrbe02,s_hrbe[1].hrbe03,s_hrbe[1].hrbe04,
              s_hrbe[1].hrbe05,s_hrbe[1].hrbe06,s_hrbe[1].hrbe07,s_hrbe[1].hrbeacti,
              s_hrbe[1].hrbeud01,s_hrbe[1].hrbeud02,s_hrbe[1].hrbeud03,s_hrbe[1].hrbeud04,s_hrbe[1].hrbeud05,
              s_hrbe[1].hrbeud06,s_hrbe[1].hrbeud07,s_hrbe[1].hrbeud08,s_hrbe[1].hrbeud09,s_hrbe[1].hrbeud10,
              s_hrbe[1].hrbeud11,s_hrbe[1].hrbeud12,s_hrbe[1].hrbeud13,s_hrbe[1].hrbeud14,s_hrbe[1].hrbeud15
              
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121


      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbe01) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hrbe01"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrbe01
                NEXT FIELD hrbe01
            WHEN INFIELD(hrbe03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hrag06"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1 = '401'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrbe03
                NEXT FIELD hrbe03
         END CASE 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbeuser', 'hrbegrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i021_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i021_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*
 
    LET g_sql =
        "SELECT hrbe01,hrbe02,hrbe03,'',hrbe04,hrbe05,hrbe06,hrbe07,hrbeacti,",
        "       hrbeud01,hrbeud02,hrbeud03,hrbeud04,hrbeud05,",
        "       hrbeud06,hrbeud07,hrbeud08,hrbeud09,hrbeud10,",
        "       hrbeud11,hrbeud12,hrbeud13,hrbeud14,hrbeud15 ",
        "  FROM hrbe_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY hrbe01 "
        
    PREPARE i021_pb FROM g_sql
    DECLARE hrbe_curs CURSOR FOR i021_pb
 
    CALL g_hrbe.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbe_curs INTO g_hrbe[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL s_code('401',g_hrbe[g_cnt].hrbe03) RETURNING l_hrag.*
        LET g_hrbe[g_cnt].hrag07 = l_hrag.hrag07
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbe TO s_hrbe.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i021_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1   
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrbe01",TRUE)                                 
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i021_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1  
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("hrbe01",FALSE)                                
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

 
