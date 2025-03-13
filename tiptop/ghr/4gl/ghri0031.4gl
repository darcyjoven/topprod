# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri0031.4gl
# Descriptions...: 职称维护作业
# Date & Author..: 13/04/15 By yangjian

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hraqa           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hraqa01       LIKE hraqa_file.hraqa01,        #序号
        hraqa02       LIKE hraqa_file.hraqa02,        #职称类别
        hraqa06       LIKE hraqa_file.hraqa06,        #职称编码#add by zhangbo130830
        hraqa03       LIKE hraqa_file.hraqa03,        #职称名称  
        hraqa04       LIKE hraqa_file.hraqa04,        #职称等级代码
        hrag07        LIKE hrag_file.hrag07,          #职称等级名称
        hraqa05       LIKE hraqa_file.hraqa05,        #备注
        hraqaacti     LIKE hraqa_file.hraqaacti       #资料有效否
                    END RECORD,
    g_hraqa_t         RECORD                 #程式變數 (舊值)
        hraqa01       LIKE hraqa_file.hraqa01,        #序号
        hraqa02       LIKE hraqa_file.hraqa02,        #职称类别
        hraqa06       LIKE hraqa_file.hraqa06,        #职称编码#add by zhangbo130830
        hraqa03       LIKE hraqa_file.hraqa03,        #职称名称  
        hraqa04       LIKE hraqa_file.hraqa04,        #职称等级代码
        hrag07        LIKE hrag_file.hrag07,          #职称等级名称
        hraqa05       LIKE hraqa_file.hraqa05,        #备注
        hraqaacti     LIKE hraqa_file.hraqaacti       #资料有效否
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
    OPEN WINDOW i0031_w AT p_row,p_col WITH FORM "ghr/42f/ghri0031"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    LET g_wc2 = '1=1' CALL i0031_b_fill(g_wc2)
    CALL i0031_menu()
    CLOSE WINDOW i0031_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i0031_menu()
 
   WHILE TRUE
      CALL i0031_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i0031_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0031_b()
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
               IF g_hraqa[l_ac].hraqa01 IS NOT NULL THEN
                  LET g_doc.column1 = "hraqa01"
                  LET g_doc.value1 = g_hraqa[l_ac].hraqa01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hraqa),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i0031_q()
   CALL i0031_b_askkey()
END FUNCTION
 
FUNCTION i0031_b()
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
 
    LET g_forupd_sql = "SELECT hraqa01 FROM hraqa_file",
                       " WHERE hraqa01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i0031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hraqa WITHOUT DEFAULTS FROM s_hraqa.*
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
               CALL i0031_set_entry(p_cmd)                                       
               CALL i0031_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               LET g_hraqa_t.* = g_hraqa[l_ac].*  #BACKUP
               OPEN i0031_bcl USING g_hraqa_t.hraqa01
               IF STATUS THEN
                  CALL cl_err("OPEN i0031_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i0031_bcl INTO g_hraqa[l_ac].hraqa01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hraqa_t.hraqa01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                      
           CALL i0031_set_entry(p_cmd)                                           
           CALL i0031_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           INITIALIZE g_hraqa[l_ac].* TO NULL      #900423
           LET g_hraqa[l_ac].hraqaacti = 'Y'         #Body default
           LET g_hraqa_t.* = g_hraqa[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           SELECT MAX(hraqa01)+1 INTO g_hraqa[l_ac].hraqa01 FROM hraqa_file WHERE 1=1
           IF cl_null(g_hraqa[l_ac].hraqa01) THEN LET g_hraqa[l_ac].hraqa01 = 1 END IF 
           NEXT FIELD hraqa02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i0031_bcl
              CANCEL INSERT
           END IF
           INSERT INTO hraqa_file(hraqa01,hraqa02,hraqa03,hraqa04,hraqa05,hraqaacti,hraqauser,hraqagrup,
                                 hraqamodu,hraqadate,hraqaoriu,hraqaorig,hraqa06)    #add hraqa06 by zhangbo130830      
                         VALUES(g_hraqa[l_ac].hraqa01,g_hraqa[l_ac].hraqa02,g_hraqa[l_ac].hraqa03,
                                g_hraqa[l_ac].hraqa04,g_hraqa[l_ac].hraqa05,g_hraqa[l_ac].hraqaacti,
                                g_user,g_grup,g_user,g_today, g_user, g_grup,g_hraqa[l_ac].hraqa06)   #add hraqa06 by zhangbo130830     
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hraqa_file",g_hraqa[l_ac].hraqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
     
      AFTER FIELD hraqa01
           IF NOT cl_null(g_hraqa[l_ac].hraqa01) THEN 
              SELECT COUNT(*) INTO l_n FROM hraqa_file WHERE hraqa01 = g_hraqa[l_ac].hraqa01
              IF l_n > 0 THEN 
                 CALL cl_err('',-239,0)
                 LET g_hraqa[l_ac].hraqa01 = g_hraqa_t.hraqa01 
                 NEXT FIELD hraqa01
              END IF 
           END IF 
    
     AFTER FIELD hraqa04
          IF NOT cl_null(g_hraqa[l_ac].hraqa04) THEN 
             CALL s_code('206',g_hraqa[l_ac].hraqa04) RETURNING l_hrag.*
             IF cl_null(l_hrag.hrag01) THEN 
                CALL cl_err(g_hraqa[l_ac].hraqa04,'ghr-040',0)
                LET g_hraqa[l_ac].hraqa04 = g_hraqa_t.hraqa04 
                NEXT FIELD hraqa04
             ELSE
                LET g_hraqa[l_ac].hrag07 = l_hrag.hrag07
                DISPLAY BY NAME g_hraqa[l_ac].hrag07
             END IF 
          END IF 

     AFTER FIELD hraqa02
          IF NOT cl_null(g_hraqa[l_ac].hraqa02) THEN 
             CALL i0031_hraqa02('a')
             IF NOT cl_null(g_errno) THEN 
                LET g_hraqa[l_ac].hraqa02 = g_hraqa_t.hraqa02
                CALL cl_err('',g_errno,0)
                DISPLAY BY NAME g_hraqa[l_ac].hraqa02
                NEXT FIELD hraqa02
             END IF 
          END IF 
                 
        AFTER FIELD hraqaacti
           IF NOT cl_null(g_hraqa[l_ac].hraqaacti) THEN
              IF g_hraqa[l_ac].hraqaacti NOT MATCHES '[YN]' OR
                 cl_null(g_hraqa[l_ac].hraqaacti) THEN
                 LET g_hraqa[l_ac].hraqaacti = g_hraqa_t.hraqaacti
                 NEXT FIELD hraqaacti
              END IF
           END IF

        #add by zhangbo130830----begin
        AFTER FIELD hraqa06
           IF NOT cl_null(g_hraqa[l_ac].hraqa06) THEN
              IF g_hraqa[l_ac].hraqa06 != g_hraqa_t.hraqa06 OR g_hraqa_t.hraqa06 IS NULL THEN
                 LET l_n=0
                 SELECT COUNT(*) INTO l_n FROM hraqa_file WHERE hraqa06=g_hraqa[l_ac].hraqa06
                 IF l_n>0 THEN
                    CALL cl_err('已维护此职称编号','!',0)
                    NEXT FIELD hraqa06
                 END IF
              END IF
           END IF
        #add by zhangbo130830----end
 
        BEFORE DELETE                            #是否取消單身
            IF g_hraqa_t.hraqa01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "hraqa01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_hraqa[l_ac].hraqa01      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM hraqa_file WHERE hraqa01 = g_hraqa_t.hraqa01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","hraqa_file",g_hraqa_t.hraqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
              LET g_hraqa[l_ac].* = g_hraqa_t.*
              CLOSE i0031_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hraqa[l_ac].hraqa01,-263,0)
               LET g_hraqa[l_ac].* = g_hraqa_t.*
           ELSE
               UPDATE hraqa_file 
                  SET hraqa01=g_hraqa[l_ac].hraqa01,hraqa02=g_hraqa[l_ac].hraqa02,
                      hraqa03=g_hraqa[l_ac].hraqa03,hraqa04=g_hraqa[l_ac].hraqa04,
                      hraqa06=g_hraqa[l_ac].hraqa06,         #add by zhangbo130830
                      hraqa05=g_hraqa[l_ac].hraqa05,hraqaacti=g_hraqa[l_ac].hraqaacti,
                      hraqamodu=g_user,hraqadate=g_today
                WHERE hraqa01=g_hraqa_t.hraqa01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hraqa_file",g_hraqa_t.hraqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_hraqa[l_ac].* = g_hraqa_t.*
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
                 LET g_hraqa[l_ac].* = g_hraqa_t.*
              END IF
              CLOSE i0031_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE i0031_bcl            # 新增
           COMMIT WORK

        ON ACTION controlp
           CASE 
              WHEN INFIELD(hraqa04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrag06"
                  LET g_qryparam.default1 = g_hraqa[l_ac].hraqa04
                  LET g_qryparam.arg1 = '206'
                  CALL cl_create_qry() RETURNING g_hraqa[l_ac].hraqa04
                  DISPLAY BY NAME g_hraqa[l_ac].hraqa04
                  NEXT FIELD hraqa04
              WHEN INFIELD(hraqa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraq02"
                  LET g_qryparam.default1 = g_hraqa[l_ac].hraqa02
                  CALL cl_create_qry() RETURNING g_hraqa[l_ac].hraqa02
                  DISPLAY BY NAME g_hraqa[l_ac].hraqa02
                  NEXT FIELD hraqa02
           END CASE

        ON ACTION controlo
            IF INFIELD(hraqa01) AND l_ac > 1 THEN
                LET g_hraqa[l_ac].* = g_hraqa[l_ac-1].*
                NEXT FIELD hraqa01
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
 
    CLOSE i0031_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i0031_b_askkey()
    CLEAR FORM
   CALL g_hraqa.clear()
    CONSTRUCT g_wc2 ON hraqa01,hraqa02,hraqa06,hraqa03,hraqa04,hraqa05,hraqaacti   #add hraqa06 by zhangbo130830
         FROM s_hraqa[1].hraqa01,s_hraqa[1].hraqa02,
              s_hraqa[1].hraqa06,                               #add by zhangbo130830
              s_hraqa[1].hraqa03,s_hraqa[1].hraqa04,
              s_hraqa[1].hraqa05,s_hraqa[1].hraqaacti
              
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
            WHEN INFIELD(hraqa04)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hrag06"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1 = '206'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hraqa04
                NEXT FIELD hraqa04
            WHEN INFIELD(hraqa02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hraq02"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hraqa02
                NEXT FIELD hraqa02
         END CASE 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraqauser', 'hraqagrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i0031_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i0031_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*
 
    LET g_sql =
        "SELECT hraqa01,hraqa02,hraqa06,hraqa03,hraqa04,'',hraqa05,hraqaacti",    #add hraqa06 by zhangbo130830
        "  FROM hraqa_file ",
        "  LEFT JOIN hraq_file ON hraq01=hraqa02",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY hraqa01 "
        
    PREPARE i0031_pb FROM g_sql
    DECLARE hraqa_curs CURSOR FOR i0031_pb
 
    CALL g_hraqa.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hraqa_curs INTO g_hraqa[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL s_code('206',g_hraqa[g_cnt].hraqa04) RETURNING l_hrag.*
        LET g_hraqa[g_cnt].hrag07 = l_hrag.hrag07
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hraqa.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i0031_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hraqa TO s_hraqa.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
FUNCTION i0031_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1   
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hraqa01",TRUE)                                 
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i0031_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1  
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("hraqa01",FALSE)                                
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

FUNCTION i0031_hraqa02(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_hraq02   LIKE hraq_file.hraq02,
       l_hraqacti LIKE hraq_file.hraqacti

    LET g_errno = ' '
    SELECT hraq02,hraqacti INTO l_hraq02,l_hraqacti
      FROM hraq_file
     WHERE hraq01 = g_hraqa[l_ac].hraqa02
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'ghr-038'
                                LET l_hraq02= NULL
                                LET l_hraqacti = NULL
       WHEN l_hraqacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_hraqa[l_ac].hraqa02
    END IF
END FUNCTION
 
