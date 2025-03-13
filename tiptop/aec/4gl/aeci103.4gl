# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aeci103.4gl
# Descriptions...: 製程段号基本資料維護作業
# Date & Author..: No.FUN-B20078 11/02/28 By lixh1
# Modify.........: No.TQC-B60165 11/06/17 By xianghui 增加未使用平行工藝時不能運行程式的提示
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_ecr           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecr01       LIKE ecr_file.ecr01,   #製程段号 
        ecr02       LIKE ecr_file.ecr02,   #製程說明 
        ecracti     LIKE ecr_file.ecracti  #資料有效碼
                    END RECORD,
      
    g_ecr_t         RECORD
        ecr01       LIKE ecr_file.ecr01,   #製程段号
        ecr02       LIKE ecr_file.ecr02,   #製程說明
        ecracti     LIKE ecr_file.ecracti  #資料有效碼
                    END RECORD
DEFINE 
     g_wc1          STRING,  
     g_wc2          STRING,
     g_sql          STRING,
     g_flag         LIKE type_file.chr1,     #判斷誤動作存入        
     g_rec_b        LIKE type_file.num5,     #單身筆數        
     p_row,p_col    LIKE type_file.num5,    
     l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT                      
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10            
DEFINE   g_i             LIKE type_file.num5            #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5                         
DEFINE   l_cmd                  LIKE type_file.chr1000 

MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   #TQC-B60165-add-str--
   IF g_sma.sma541='N' OR cl_null(g_sma.sma541) THEN 
      CALL cl_err(g_sma.sma541,'aec-056',1)
      EXIT PROGRAM
    END IF
   #TQC-B6-165-add-end--
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
    LET p_row = 4 LET p_col = 4 
    IF g_sma.sma541 = 'Y' THEN
       
       OPEN WINDOW i103_w AT p_row,p_col WITH FORM "aec/42f/aeci103"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
       CALL cl_ui_init()
    ELSE
       EXIT PROGRAM
    END IF  
 
 
    LET g_wc2 = '1=1' 
    CALL i103_b_fill(g_wc2)
    ERROR ""
    CALL i103_menu()
    CLOSE WINDOW i103_w                    #結束畫面
    CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN

FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                 
              LET l_cmd = 'p_query "aeci103" "',g_wc2 CLIPPED,'"'              
              CALL cl_cmdrun(l_cmd)   
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecr),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i103_q()
   CALL i103_b_askkey()
END FUNCTION
 
FUNCTION i103_b()
DEFINE
    l_ecr01         LIKE  ecr_file.ecr01,
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    s_acct          LIKE aab_file.aab02,     # No.FUN-680073  VARCHAR(06),   #SELECT npu_cost number880110 
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,     # No.FUN-680073  VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1      # No.FUN-680073  VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ecr01,ecr02,ecracti FROM ecr_file WHERE ecr01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_ecr WITHOUT DEFAULTS FROM s_ecr.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'               #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ecr_t.* = g_ecr[l_ac].*  #BACKUP
               CALL i103_set_entry(p_cmd)                                                                                           
               CALL i103_set_no_entry(p_cmd)  
               LET g_before_input_done = FALSE                                                                                      
               LET g_before_input_done = TRUE                                                                                       

               BEGIN WORK
               OPEN i103_bcl USING g_ecr_t.ecr01
               IF STATUS THEN
                  CALL cl_err("OPEN i103_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i103_bcl INTO g_ecr[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ecr_t.ecr01,STATUS,1) 
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                                                                                                           
            LET g_before_input_done = FALSE                                                                                      
            CALL i103_set_entry(p_cmd)                                                                                           
            CALL i103_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
  
            INITIALIZE g_ecr[l_ac].* TO NULL      
            LET g_ecr_t.* = g_ecr[l_ac].*          #新輸入資料
            LET g_ecr[l_ac].ecracti = 'Y'
            CALL cl_show_fld_cont()     
            NEXT FIELD ecr01
 
      AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
#         LET g_ecr[l_ac].ecrdate = g_today
#         LET g_ecr[l_ac].ecrgrup = g_grup  
#         LET g_ecr[l_ac].ecrorig = g_grup
#         LET g_ecr[l_ac].ecroriu = g_user 
#         LET g_ecr[l_ac].ecruser = g_user      
         INSERT INTO ecr_file(ecr01,ecr02,ecracti,ecrdate,ecrgrup,ecrorig,ecroriu,ecruser)
         VALUES (g_ecr[l_ac].ecr01,g_ecr[l_ac].ecr02,g_ecr[l_ac].ecracti,g_today,
                 g_grup,g_grup,g_user,g_user)
                 
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ecr_file",g_ecr[l_ac].ecr01,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cnt  
           END IF
 
        AFTER FIELD ecr01                        # CHK 異常代號
            IF NOT cl_null(g_ecr[l_ac].ecr01) THEN
               IF g_ecr[l_ac].ecr01 IS NOT NULL AND
               (g_ecr[l_ac].ecr01 != g_ecr_t.ecr01  OR
                g_ecr_t.ecr01 IS  NULL)  THEN
                  IF cl_null(g_ecr[l_ac].ecr01) THEN
                     NEXT FIELD ecr01
                  END IF
                  SELECT COUNT(*) INTO l_n FROM ecr_file
                               WHERE ecr01 = g_ecr[l_ac].ecr01
                  IF l_n > 0 THEN 
                     CALL cl_err('','aec-007',0) NEXT FIELD ecr01
                  END IF
               END IF
            END IF
 
         AFTER FIELD ecracti                       # CHK 異常屬性
            IF NOT cl_null(g_ecr[l_ac].ecracti) THEN
               IF (g_ecr[l_ac].ecracti NOT MATCHES "[YN]" ) THEN
                  NEXT FIELD ecracti
               END IF
            ELSE 
               NEXT FIELD ecracti   
            END IF

        BEFORE DELETE                            #是否取消單身
             IF NOT cl_null( g_ecr_t.ecr01) THEN 
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM ecr_file
                WHERE ecr01 = g_ecr_t.ecr01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ecr_file",g_ecr_t.ecr01,"",SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cnt  
            MESSAGE "Delete OK" 
            CLOSE i103_bcl     
            COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ecr[l_ac].* = g_ecr_t.*
              CLOSE i103_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ecr[l_ac].ecr01,-263,1)
              LET g_ecr[l_ac].* = g_ecr_t.*
           ELSE
#              LET g_ecr[l_ac].ecrdate = g_today
#              LET g_ecr[l_ac].ecrgrup = g_grup  
#              LET g_ecr[l_ac].ecrmodu = g_user
#              LET g_ecr[l_ac].ecrorig = g_grup            
              UPDATE ecr_file SET ecr01=g_ecr[l_ac].ecr01,
                                  ecr02=g_ecr[l_ac].ecr02,
                                  ecracti=g_ecr[l_ac].ecracti,
                                  ecrdate=g_today,
                                  ecrgrup=g_grup,  
                                  ecrmodu=g_user                                  
              WHERE ecr01 = g_ecr_t.ecr01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ecr_file",g_ecr_t.ecr01,"",SQLCA.SQLCODE,"","update ecr error",1) 
                   LET g_ecr[l_ac].* = g_ecr_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i103_bcl
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd='u' THEN
                  LET g_ecr[l_ac].* = g_ecr_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecr.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i103_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i103_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i103_b_askkey()
            EXIT INPUT
 

 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
       
        ON ACTION CONTROLO                        #沿用所有欄位
            IF  l_ac > 1 THEN
                LET g_ecr[l_ac].* = g_ecr[l_ac-1].*
                NEXT FIELD ecr01
            END IF
  
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
        
        END INPUT
 
    CLOSE i103_bcl                                                         
    COMMIT WORK
END FUNCTION
  
FUNCTION i103_b_askkey()
    CLEAR FORM
    CALL g_ecr.clear()
    CONSTRUCT g_wc2 ON ecr01, ecr02, ecracti
            FROM s_ecr[1].ecr01, s_ecr[1].ecr02, s_ecr[1].ecracti

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(ecr01)  
                 CALL cl_init_qry_var()
		 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_ecr"
                 LET g_qryparam.default1 = g_ecr[1].ecr01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO ecr01 
                 NEXT FIELD ecr01 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL i103_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(200)
 
    LET g_sql = " SELECT ecr01,ecr02,ecracti FROM ecr_file",
                "  WHERE ", p_wc2 CLIPPED,
                "  ORDER BY ecr01"

    PREPARE i103_pb FROM g_sql
    DECLARE ecr_curs CURSOR FOR i103_pb
 
    CALL g_ecr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ecr_curs INTO g_ecr[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ecr.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecr TO s_ecr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
                                                                                                                       
FUNCTION i103_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1      
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ecr01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i103_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ecr01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION
#No.FUN-B20078 --end--   
