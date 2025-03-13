# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri062.4gl
# Descriptions...: 合同类型维护作业 
# Date & Author..: 13/04/24 By yangjian

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrcv           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrcv01       LIKE hrcv_file.hrcv01,       
        hrcv02       LIKE hrcv_file.hrcv02,       
        hrcv03       LIKE hrcv_file.hrcv03,       
        hrcv04       LIKE hrcv_file.hrcv04,       
        hrcv05       LIKE hrcv_file.hrcv05,       
        hrcv06       LIKE hrcv_file.hrcv06,       
        hrcv07       LIKE hrcv_file.hrcv07,   
        hrcv07_name  LIKE type_file.chr100,     
        hrcv08       LIKE hrcv_file.hrcv08,
        hrcvacti     LIKE hrcv_file.hrcvacti,     
        hrcvud01     LIKE hrcv_file.hrcvud01,
        hrcvud02     LIKE hrcv_file.hrcvud02,
        hrcvud03     LIKE hrcv_file.hrcvud03,
        hrcvud04     LIKE hrcv_file.hrcvud04,
        hrcvud05     LIKE hrcv_file.hrcvud05,
        hrcvud06     LIKE hrcv_file.hrcvud06,
        hrcvud07     LIKE hrcv_file.hrcvud07,
        hrcvud08     LIKE hrcv_file.hrcvud08,
        hrcvud09     LIKE hrcv_file.hrcvud09,
        hrcvud10     LIKE hrcv_file.hrcvud10,
        hrcvud11     LIKE hrcv_file.hrcvud11,
        hrcvud12     LIKE hrcv_file.hrcvud12,
        hrcvud13     LIKE hrcv_file.hrcvud13,
        hrcvud14     LIKE hrcv_file.hrcvud14,
        hrcvud15     LIKE hrcv_file.hrcvud15
                    END RECORD,
    g_hrcv_t         RECORD                 #程式變數 (舊值)
        hrcv01       LIKE hrcv_file.hrcv01,       
        hrcv02       LIKE hrcv_file.hrcv02,       
        hrcv03       LIKE hrcv_file.hrcv03,       
        hrcv04       LIKE hrcv_file.hrcv04,       
        hrcv05       LIKE hrcv_file.hrcv05,       
        hrcv06       LIKE hrcv_file.hrcv06,       
        hrcv07       LIKE hrcv_file.hrcv07,   
        hrcv07_name  LIKE type_file.chr100,     
        hrcv08       LIKE hrcv_file.hrcv08,
        hrcvacti     LIKE hrcv_file.hrcvacti,     
        hrcvud01     LIKE hrcv_file.hrcvud01,
        hrcvud02     LIKE hrcv_file.hrcvud02,
        hrcvud03     LIKE hrcv_file.hrcvud03,
        hrcvud04     LIKE hrcv_file.hrcvud04,
        hrcvud05     LIKE hrcv_file.hrcvud05,
        hrcvud06     LIKE hrcv_file.hrcvud06,
        hrcvud07     LIKE hrcv_file.hrcvud07,
        hrcvud08     LIKE hrcv_file.hrcvud08,
        hrcvud09     LIKE hrcv_file.hrcvud09,
        hrcvud10     LIKE hrcv_file.hrcvud10,
        hrcvud11     LIKE hrcv_file.hrcvud11,
        hrcvud12     LIKE hrcv_file.hrcvud12,
        hrcvud13     LIKE hrcv_file.hrcvud13,
        hrcvud14     LIKE hrcv_file.hrcvud14,
        hrcvud15     LIKE hrcv_file.hrcvud15
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
    OPEN WINDOW i062_w AT p_row,p_col WITH FORM "ghr/42f/ghri062"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    LET g_wc2 = '1=1' CALL i062_b_fill(g_wc2)
    CALL i062_menu()
    CLOSE WINDOW i062_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i062_menu()
 
   WHILE TRUE
      CALL i062_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i062_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i062_b()
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
               IF g_hrcv[l_ac].hrcv01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrcv01"
                  LET g_doc.value1 = g_hrcv[l_ac].hrcv01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcv),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i062_q()
   CALL i062_b_askkey()
END FUNCTION
 
FUNCTION i062_b()
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
 
    LET g_forupd_sql = "SELECT hrcv01 FROM hrcv_file",
                       " WHERE hrcv01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i062_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrcv WITHOUT DEFAULTS FROM s_hrcv.*
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
               CALL i062_set_entry(p_cmd)                                       
               CALL i062_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               LET g_hrcv_t.* = g_hrcv[l_ac].*  #BACKUP
               OPEN i062_bcl USING g_hrcv_t.hrcv01
               IF STATUS THEN
                  CALL cl_err("OPEN i062_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i062_bcl INTO g_hrcv[l_ac].hrcv01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrcv_t.hrcv01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                      
           CALL i062_set_entry(p_cmd)                                           
           CALL i062_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           INITIALIZE g_hrcv[l_ac].* TO NULL      #900423
           LET g_hrcv[l_ac].hrcvacti = 'Y'         #Body default
           LET g_hrcv[l_ac].hrcv06 = 'N'
           SELECT to_char(MAX(hrcv01)+1,'fm000000000000') INTO g_hrcv[l_ac].hrcv01 FROM hrcv_file
            WHERE to_date(substr(hrcv01,1,8),'yyyyMMdd') = g_today
           IF cl_null(g_hrcv[l_ac].hrcv01) THEN
                  LET g_hrcv[l_ac].hrcv01 = g_today USING 'yyyymmdd'||'0001'
           END IF           
           LET g_hrcv_t.* = g_hrcv[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           
           NEXT FIELD hrcv01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i062_bcl
              CANCEL INSERT
           END IF
           INSERT INTO hrcv_file(hrcv01,hrcv02,hrcv03,hrcv04,hrcv05,hrcv06,hrcv07,hrcv08,
                                 hrcvacti,hrcvuser,hrcvgrup,hrcvmodu,hrcvdate,hrcvoriu,hrcvorig,
                                 hrcvud01,hrcvud02,hrcvud03,hrcvud04,hrcvud05,hrcvud06,hrcvud07,
                                 hrcvud08,hrcvud09,hrcvud10,hrcvud11,hrcvud12,hrcvud13,hrcvud14,
                                 hrcvud15)      
                         VALUES(g_hrcv[l_ac].hrcv01,g_hrcv[l_ac].hrcv02,g_hrcv[l_ac].hrcv03,
                                g_hrcv[l_ac].hrcv04,g_hrcv[l_ac].hrcv05,g_hrcv[l_ac].hrcv06,
                                g_hrcv[l_ac].hrcv07,g_hrcv[l_ac].hrcv08,g_hrcv[l_ac].hrcvacti,
                                g_user,g_grup,g_user,g_today, g_user, g_grup,
                                g_hrcv[l_ac].hrcvud01,g_hrcv[l_ac].hrcvud02,g_hrcv[l_ac].hrcvud03,
                                g_hrcv[l_ac].hrcvud04,g_hrcv[l_ac].hrcvud05,g_hrcv[l_ac].hrcvud06,
                                g_hrcv[l_ac].hrcvud07,g_hrcv[l_ac].hrcvud08,g_hrcv[l_ac].hrcvud09,
                                g_hrcv[l_ac].hrcvud10,g_hrcv[l_ac].hrcvud11,g_hrcv[l_ac].hrcvud12,
                                g_hrcv[l_ac].hrcvud13,g_hrcv[l_ac].hrcvud14,g_hrcv[l_ac].hrcvud15)     
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrcv_file",g_hrcv[l_ac].hrcv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
     
      AFTER FIELD hrcv01
           IF NOT cl_null(g_hrcv[l_ac].hrcv01) THEN 
           	  IF g_hrcv[l_ac].hrcv01 != g_hrcv_t.hrcv01 OR g_hrcv_t.hrcv01 IS NULL THEN 
                 SELECT COUNT(*) INTO l_n FROM hrcv_file WHERE hrcv01 = g_hrcv[l_ac].hrcv01
                 IF l_n > 0 THEN 
                    CALL cl_err('',-239,0)
                    LET g_hrcv[l_ac].hrcv01 = g_hrcv_t.hrcv01 
                    NEXT FIELD hrcv01
                 END IF
              END IF  
           END IF 
    
     AFTER FIELD hrcv03
          IF NOT cl_null(g_hrcv[l_ac].hrcv03) THEN 
          	 IF g_hrcv[l_ac].hrcv03 <= 0 THEN 
          	 	   CALL cl_err('','axr-610',0)
          	 	   NEXT FIELD hrcv03
          	 END IF 
          END IF 

     AFTER FIELD hrcv06
           IF NOT cl_null(g_hrcv[l_ac].hrcv06) THEN
              IF g_hrcv[l_ac].hrcv06 NOT MATCHES '[YN]' OR
                 cl_null(g_hrcv[l_ac].hrcv06) THEN
                 LET g_hrcv[l_ac].hrcv06 = g_hrcv_t.hrcv06
                 NEXT FIELD hrcv06
              END IF
           END IF
           
     AFTER FIELD hrcvacti
           IF NOT cl_null(g_hrcv[l_ac].hrcvacti) THEN
              IF g_hrcv[l_ac].hrcvacti NOT MATCHES '[YN]' OR
                 cl_null(g_hrcv[l_ac].hrcvacti) THEN
                 LET g_hrcv[l_ac].hrcvacti = g_hrcv_t.hrcvacti
                 NEXT FIELD hrcvacti
              END IF
           END IF
           
     AFTER FIELD hrcv07
           IF NOT cl_null(g_hrcv[l_ac].hrcv07) THEN
           	  IF g_hrcv[l_ac].hrcv07 != g_hrcv_t.hrcv07 OR 
           	     g_hrcv_t.hrcv07 IS NULL THEN 
           	     CALL i062_hrcv07()
           	     IF NOT cl_null(g_errno) THEN
           	     	  CALL cl_err('',g_errno,0)
           	     	  NEXT FIELD hrcv07
           	     END IF 
              END IF
           END IF   
           
 
        BEFORE DELETE                            #是否取消單身
            IF g_hrcv_t.hrcv01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "hrcv01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_hrcv[l_ac].hrcv01      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM hrcv_file WHERE hrcv01 = g_hrcv_t.hrcv01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","hrcv_file",g_hrcv_t.hrcv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
              LET g_hrcv[l_ac].* = g_hrcv_t.*
              CLOSE i062_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrcv[l_ac].hrcv01,-263,0)
               LET g_hrcv[l_ac].* = g_hrcv_t.*
           ELSE
               UPDATE hrcv_file 
                  SET hrcv01=g_hrcv[l_ac].hrcv01,hrcv02=g_hrcv[l_ac].hrcv02,
                      hrcv03=g_hrcv[l_ac].hrcv03,hrcv04=g_hrcv[l_ac].hrcv04,
                      hrcv05=g_hrcv[l_ac].hrcv05,hrcv06=g_hrcv[l_ac].hrcv06,
                      hrcv07=g_hrcv[l_ac].hrcv07,hrcv08=g_hrcv[l_ac].hrcv08,
                      hrcvacti=g_hrcv[l_ac].hrcvacti,hrcvmodu=g_user,hrcvdate=g_today,
                      hrcvud01=g_hrcv[l_ac].hrcvud01,hrcvud02=g_hrcv[l_ac].hrcvud02,
                      hrcvud03=g_hrcv[l_ac].hrcvud03,hrcvud04=g_hrcv[l_ac].hrcvud04,
                      hrcvud05=g_hrcv[l_ac].hrcvud05,hrcvud06=g_hrcv[l_ac].hrcvud06,
                      hrcvud07=g_hrcv[l_ac].hrcvud07,hrcvud08=g_hrcv[l_ac].hrcvud08,
                      hrcvud09=g_hrcv[l_ac].hrcvud09,hrcvud10=g_hrcv[l_ac].hrcvud10,
                      hrcvud11=g_hrcv[l_ac].hrcvud11,hrcvud12=g_hrcv[l_ac].hrcvud12,
                      hrcvud13=g_hrcv[l_ac].hrcvud13,hrcvud14=g_hrcv[l_ac].hrcvud14,
                      hrcvud15=g_hrcv[l_ac].hrcvud15
                WHERE hrcv01=g_hrcv_t.hrcv01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrcv_file",g_hrcv_t.hrcv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_hrcv[l_ac].* = g_hrcv_t.*
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
                 LET g_hrcv[l_ac].* = g_hrcv_t.*
              END IF
              CLOSE i062_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE i062_bcl            # 新增
           COMMIT WORK

        ON ACTION controlp
           CASE 
              WHEN INFIELD(hrcv07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraa10"
                  LET g_qryparam.default1 = g_hrcv[l_ac].hrcv07
                  CALL cl_create_qry() RETURNING g_hrcv[l_ac].hrcv07
                  DISPLAY BY NAME g_hrcv[l_ac].hrcv07
                  NEXT FIELD hrcv07
           END CASE

        ON ACTION controlo
            IF INFIELD(hrcv01) AND l_ac > 1 THEN
                LET g_hrcv[l_ac].* = g_hrcv[l_ac-1].*
                NEXT FIELD hrcv01
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
 
    CLOSE i062_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i062_b_askkey()
    CLEAR FORM
   CALL g_hrcv.clear()
    CONSTRUCT g_wc2 ON hrcv01,hrcv02,hrcv03,hrcv04,hrcv05,hrcv06,hrcv07,hrcv08,hrcvacti,
                       hrcvud01,hrcvud02,hrcvud03,hrcvud04,hrcvud05,
                       hrcvud06,hrcvud07,hrcvud08,hrcvud09,hrcvud10,
                       hrcvud11,hrcvud12,hrcvud13,hrcvud14,hrcvud15
         FROM s_hrcv[1].hrcv01,s_hrcv[1].hrcv02,s_hrcv[1].hrcv03,s_hrcv[1].hrcv04,
              s_hrcv[1].hrcv05,s_hrcv[1].hrcv06,s_hrcv[1].hrcv07,s_hrcv[1].hrcv08,s_hrcv[1].hrcvacti,
              s_hrcv[1].hrcvud01,s_hrcv[1].hrcvud02,s_hrcv[1].hrcvud03,s_hrcv[1].hrcvud04,s_hrcv[1].hrcvud05,
              s_hrcv[1].hrcvud06,s_hrcv[1].hrcvud07,s_hrcv[1].hrcvud08,s_hrcv[1].hrcvud09,s_hrcv[1].hrcvud10,
              s_hrcv[1].hrcvud11,s_hrcv[1].hrcvud12,s_hrcv[1].hrcvud13,s_hrcv[1].hrcvud14,s_hrcv[1].hrcvud15
              
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
            WHEN INFIELD(hrcv07) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hraa10"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrcv07
                NEXT FIELD hrcv07
         END CASE 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcvuser', 'hrcvgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i062_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i062_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*
 
    LET g_sql =
        "SELECT hrcv01,hrcv02,hrcv03,hrcv04,hrcv05,hrcv06,hrcv07,hraa12,hrcv08,hrcvacti,",
        "       hrcvud01,hrcvud02,hrcvud03,hrcvud04,hrcvud05,",
        "       hrcvud06,hrcvud07,hrcvud08,hrcvud09,hrcvud10,",
        "       hrcvud11,hrcvud12,hrcvud13,hrcvud14,hrcvud15 ",
        "  FROM hrcv_file,hraa_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hrcv07 = hraa01 ",
        " ORDER BY hrcv01 "
        
    PREPARE i062_pb FROM g_sql
    DECLARE hrcv_curs CURSOR FOR i062_pb
 
    CALL g_hrcv.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcv_curs INTO g_hrcv[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i062_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcv TO s_hrcv.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
FUNCTION i062_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1   
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrcv01",TRUE)                                 
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i062_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1  
          
   CALL cl_set_comp_entry("hrcv01",FALSE)                                                                             
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
                                    
   END IF                                                                       
                                                                                
END FUNCTION                                                                    


FUNCTION i062_hrcv07() 
   DEFINE l_hraa02    LIKE hraa_file.hraa02 
   DEFINE l_hraaacti  LIKE hraa_file.hraaacti 

   WHENEVER ERROR CONTINUE  
   LET g_errno=''
   LET g_sql = "SELECT hraa02,hraaacti FROM hraa_file ",
               " WHERE hraa01= ? "
   PREPARE hrat03_prep FROM g_sql
   EXECUTE hrat03_prep USING g_hrcv[l_ac].hrcv07 INTO l_hraa02,l_hraaacti
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-001'
                                LET l_hraa02=NULL
  
       WHEN l_hraaacti='N'      LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      LET g_hrcv[l_ac].hrcv07_name = l_hraa02
   END IF 
END FUNCTION

