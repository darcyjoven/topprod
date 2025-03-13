# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri017.4gl
# Descriptions...: 奖惩项目维护 
# Date & Author..: 13/04/15 By yangjian
# Modify.........:  By zhangbo 新增生成奖惩参数逻辑,单身删除功能去掉

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrba           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrba01       LIKE hrba_file.hrba01,        #奖惩编码
        hrba02       LIKE hrba_file.hrba02,        #奖惩名称
        hrba03       LIKE hrba_file.hrba03,        #奖惩类型编码
        hrag07       LIKE hrag_file.hrag07,        #类型名称
        hrba04       LIKE hrba_file.hrba04,        #公司代码
        hraa12       LIKE hraa_file.hraa12,        #公司名称
        hrba05       LIKE hrba_file.hrba05,        #备注
        hrbaacti     LIKE hrba_file.hrbaacti       #资料有效否
                    END RECORD,
    g_hrba_t         RECORD                 #程式變數 (舊值)
        hrba01       LIKE hrba_file.hrba01,        #奖惩编码
        hrba02       LIKE hrba_file.hrba02,        #奖惩名称
        hrba03       LIKE hrba_file.hrba03,        #奖惩类型编码
        hrag07       LIKE hrag_file.hrag07,        #类型名称
        hrba04       LIKE hrba_file.hrba04,        #公司代码
        hraa12       LIKE hraa_file.hraa12,        #公司名称
        hrba05       LIKE hrba_file.hrba05,        #备注
        hrbaacti     LIKE hrba_file.hrbaacti       #资料有效否
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
    OPEN WINDOW i017_w AT p_row,p_col WITH FORM "ghr/42f/ghri017"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    LET g_wc2 = '1=1' CALL i017_b_fill(g_wc2)
    CALL i017_menu()
    CLOSE WINDOW i017_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i017_menu()
 
   WHILE TRUE
      CALL i017_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i017_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i017_b()
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
               IF g_hrba[l_ac].hrba01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrba01"
                  LET g_doc.value1 = g_hrba[l_ac].hrba01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrba),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i017_q()
   CALL i017_b_askkey()
END FUNCTION
 
FUNCTION i017_b()
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
 
    LET g_forupd_sql = "SELECT hrba01 FROM hrba_file",
                       " WHERE hrba01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i017_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrba WITHOUT DEFAULTS FROM s_hrba.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 #INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   #mark by zhangbo130606
                INSERT ROW = l_allow_insert,DELETE ROW=FALSE,APPEND ROW=l_allow_insert)              #add by zhangbo130606
 
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
               CALL i017_set_entry(p_cmd)                                       
               CALL i017_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               LET g_hrba_t.* = g_hrba[l_ac].*  #BACKUP
               OPEN i017_bcl USING g_hrba_t.hrba01
               IF STATUS THEN
                  CALL cl_err("OPEN i017_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i017_bcl INTO g_hrba[l_ac].hrba01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrba_t.hrba01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                      
           CALL i017_set_entry(p_cmd)                                           
           CALL i017_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
           INITIALIZE g_hrba[l_ac].* TO NULL      #900423
           LET g_hrba[l_ac].hrbaacti = 'Y'         #Body default
           LET g_hrba_t.* = g_hrba[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrba01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i017_bcl
              CANCEL INSERT
           END IF
           INSERT INTO hrba_file(hrba01,hrba02,hrba03,hrba04,hrba05,hrbaacti,hrbauser,hrbagrup,
                                 hrbamodu,hrbadate,hrbaoriu,hrbaorig)      
                         VALUES(g_hrba[l_ac].hrba01,g_hrba[l_ac].hrba02,g_hrba[l_ac].hrba03,
                                g_hrba[l_ac].hrba04,g_hrba[l_ac].hrba05,g_hrba[l_ac].hrbaacti,
                                g_user,g_grup,g_user,g_today, g_user, g_grup)     
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrba_file",g_hrba[l_ac].hrba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
              CALL i017_ins_hrbh(g_hrba[l_ac].hrba01)   #add by zhangbo130606
           END IF
     
      AFTER FIELD hrba01
           IF NOT cl_null(g_hrba[l_ac].hrba01) THEN 
              SELECT COUNT(*) INTO l_n FROM hrba_file WHERE hrba01 = g_hrba[l_ac].hrba01
              IF l_n > 0 THEN 
                 CALL cl_err('',-239,0)
                 LET g_hrba[l_ac].hrba01 = g_hrba_t.hrba01 
                 NEXT FIELD hrba01
              END IF 
           END IF 
    
     AFTER FIELD hrba03
          IF NOT cl_null(g_hrba[l_ac].hrba03) THEN 
             CALL s_code('329',g_hrba[l_ac].hrba03) RETURNING l_hrag.*
             IF cl_null(l_hrag.hrag01) THEN 
                CALL cl_err(g_hrba[l_ac].hrba03,'ghr-039',0)
                LET g_hrba[l_ac].hrba03 = g_hrba_t.hrba03 
                NEXT FIELD hrba03
             ELSE
                LET g_hrba[l_ac].hrag07 = l_hrag.hrag07
                DISPLAY BY NAME g_hrba[l_ac].hrag07
             END IF 
          END IF 

     AFTER FIELD hrba04
          IF NOT cl_null(g_hrba[l_ac].hrba04) THEN 
             CALL i017_hrba04('a')
             IF NOT cl_null(g_errno) THEN 
                LET g_hrba[l_ac].hrba04 = g_hrba_t.hrba04
                CALL cl_err('',g_errno,0)
                DISPLAY BY NAME g_hrba[l_ac].hrba04
                NEXT FIELD hrba04
             END IF 
          END IF 
                 
        AFTER FIELD hrbaacti
           IF NOT cl_null(g_hrba[l_ac].hrbaacti) THEN
              IF g_hrba[l_ac].hrbaacti NOT MATCHES '[YN]' OR
                 cl_null(g_hrba[l_ac].hrbaacti) THEN
                 LET g_hrba[l_ac].hrbaacti = g_hrba_t.hrbaacti
                 NEXT FIELD hrbaacti
              END IF
           END IF
      
      #删除功能不要---mod by zhangbo130606---begin
      {   
        BEFORE DELETE                            #是否取消單身
            IF g_hrba_t.hrba01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "hrba01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_hrba[l_ac].hrba01      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM hrba_file WHERE hrba01 = g_hrba_t.hrba01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","hrba_file",g_hrba_t.hrba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK
            END IF
      }
      #mod by zhangbo130606---end  
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrba[l_ac].* = g_hrba_t.*
              CLOSE i017_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrba[l_ac].hrba01,-263,0)
               LET g_hrba[l_ac].* = g_hrba_t.*
           ELSE
               UPDATE hrba_file 
                  SET hrba01=g_hrba[l_ac].hrba01,hrba02=g_hrba[l_ac].hrba02,
                      hrba03=g_hrba[l_ac].hrba03,hrba04=g_hrba[l_ac].hrba04,
                      hrba05=g_hrba[l_ac].hrba05,hrbaacti=g_hrba[l_ac].hrbaacti,
                      hrbamodu=g_user,hrbadate=g_today
                WHERE hrba01=g_hrba_t.hrba01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrba_file",g_hrba_t.hrba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_hrba[l_ac].* = g_hrba_t.*
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
                 LET g_hrba[l_ac].* = g_hrba_t.*
              END IF
              CLOSE i017_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE i017_bcl            # 新增
           COMMIT WORK

        ON ACTION controlp
           CASE 
              WHEN INFIELD(hrba03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrag06"
                  LET g_qryparam.default1 = g_hrba[l_ac].hrba03
                  LET g_qryparam.arg1 = '329'
                  CALL cl_create_qry() RETURNING g_hrba[l_ac].hrba03
                  DISPLAY BY NAME g_hrba[l_ac].hrba03
                  NEXT FIELD hrba03
              WHEN INFIELD(hrba04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraa10"
                  LET g_qryparam.default1 = g_hrba[l_ac].hrba04
                  CALL cl_create_qry() RETURNING g_hrba[l_ac].hrba04
                  DISPLAY BY NAME g_hrba[l_ac].hrba04
                  NEXT FIELD hrba04
           END CASE

        ON ACTION controlo
            IF INFIELD(hrba01) AND l_ac > 1 THEN
                LET g_hrba[l_ac].* = g_hrba[l_ac-1].*
                NEXT FIELD hrba01
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
 
    CLOSE i017_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i017_b_askkey()
    CLEAR FORM
   CALL g_hrba.clear()
    CONSTRUCT g_wc2 ON hrba01,hrba02,hrba03,hrba04,hrba05,hrbaacti
         FROM s_hrba[1].hrba01,s_hrba[1].hrba02,s_hrba[1].hrba03,s_hrba[1].hrba04,
              s_hrba[1].hrba05,s_hrba[1].hrbaacti
              
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
            WHEN INFIELD(hrba01) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hrba01"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrba01
                NEXT FIELD hrba01
            WHEN INFIELD(hrba03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hrag06"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1 = '329'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrba03
                NEXT FIELD hrba03
            WHEN INFIELD(hrba04)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_hraa10"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrba04
                NEXT FIELD hrba04
         END CASE 
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbauser', 'hrbagrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i017_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i017_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*
 
    LET g_sql =
        "SELECT hrba01,hrba02,hrba03,'',hrba04,hraa12,hrba05,hrbaacti",
        "  FROM hrba_file LEFT OUTER JOIN hraa_file ON hrba04=hraa01",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY hrba01 "
        
    PREPARE i017_pb FROM g_sql
    DECLARE hrba_curs CURSOR FOR i017_pb
 
    CALL g_hrba.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrba_curs INTO g_hrba[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL s_code('329',g_hrba[g_cnt].hrba03) RETURNING l_hrag.*
        LET g_hrba[g_cnt].hrag07 = l_hrag.hrag07
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrba.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i017_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrba TO s_hrba.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
FUNCTION i017_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1   
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrba01",TRUE)                                 
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i017_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1  
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("hrba01",FALSE)                                
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

FUNCTION i017_hrba04(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_hraa12   LIKE hraa_file.hraa12,
       l_hraaacti LIKE hraa_file.hraaacti

    LET g_errno = ' '
    SELECT hraa12,hraaacti INTO l_hraa12,l_hraaacti
      FROM hraa_file
     WHERE hraa01 = g_hrba[l_ac].hrba04
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'ghr-001'
                                LET l_hraa12= NULL
                                LET l_hraaacti = NULL
       WHEN l_hraaacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_hrba[l_ac].hraa12 = l_hraa12
       DISPLAY BY NAME g_hrba[l_ac].hraa12
    END IF
END FUNCTION

FUNCTION i017_ins_hrbh(p_hrba01)
DEFINE  p_hrba01   LIKE  hrba_file.hrba01
DEFINE  l_hrba     RECORD LIKE hrba_file.*
DEFINE  l_hrdh     RECORD LIKE hrdh_file.*

        SELECT * INTO l_hrba.* FROM hrba_file WHERE hrba01=p_hrba01
        
        LET l_hrdh.hrdh02='005'
        LET l_hrdh.hrdh10='N'
        LET l_hrdh.hrdh07=l_hrba.hrba04
        LET l_hrdh.hrdhacti='Y'
        LET l_hrdh.hrdhuser=g_user
        LET l_hrdh.hrdhgrup=g_grup
        LET l_hrdh.hrdhoriu=g_user
        LET l_hrdh.hrdhorig=g_grup
        LET l_hrdh.hrdhdate=g_today
        #第一笔
        LET l_hrdh.hrdh06=l_hrba.hrba02 CLIPPED,"_累计次数"
        #LET l_hrdh.hrdh12="@hrbbLC",l_hrba.hrba01                       #mark by zhangbo130624--存储过程中参数不能包含@
        LET l_hrdh.hrdh12="hrbbLC",l_hrba.hrba01                         #add by zhangbo130624
        SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
        IF l_hrdh.hrdh01 IS NULL THEN
       	   LET l_hrdh.hrdh01=1
        ELSE
       	   LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
        END IF

        SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
 	
        INSERT INTO hrdh_file VALUES (l_hrdh.*)
        
        #第二笔
        LET l_hrdh.hrdh06=l_hrba.hrba02 CLIPPED,"_累计金额"
        #LET l_hrdh.hrdh12="@hrbbLJ",l_hrba.hrba01                       #mark by zhangbo130624--存储过程中参数不能包含@
        LET l_hrdh.hrdh12="hrbbLJ",l_hrba.hrba01                         #add by zhangbo130624
        SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
        IF l_hrdh.hrdh01 IS NULL THEN
       	   LET l_hrdh.hrdh01=1
        ELSE
       	   LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
        END IF

        SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
	
        INSERT INTO hrdh_file VALUES (l_hrdh.*)
        
END FUNCTION    	
        
        	
        
        	 
