# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri032.4gl
# Descriptions...: 部門名稱
# Date & Author..: 13/05/08 By lijun
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_hrbn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrbn01       LIKE hrbn_file.hrbn01,   #員工編號
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrao02       LIKE hrao_file.hrao02,   #部门
        hrat05       LIKE hrap_file.hrap06,   #职位
        hrat25       LIKE hrat_file.hrat25,   #入司日期
        hrbn02       LIKE hrbn_file.hrbn02,   #考勤方式代码
        hrag07       LIKE hrag_file.hrag07,   #考勤方式名称
        hrbn04       LIKE hrbn_file.hrbn04,   #生效日期
        hrbn05       LIKE hrbn_file.hrbn05,   #失效日期
        hrbn03       LIKE hrbn_file.hrbn03,   #设置日期
        hrbn06       LIKE hrbn_file.hrbn06    #备注
                    END RECORD,
    g_hrbn_t         RECORD                 #程式變數 (舊值)
        hrbn01       LIKE hrbn_file.hrbn01,   #員工編號
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrao02       LIKE hrao_file.hrao02,   #部门
        hrat05       LIKE hrap_file.hrap06,   #职位
        hrat25       LIKE hrat_file.hrat25,   #入司日期
        hrbn02       LIKE hrbn_file.hrbn02,   #考勤方式代码
        hrag07       LIKE hrag_file.hrag07,   #考勤方式名称
        hrbn04       LIKE hrbn_file.hrbn04,   #生效日期
        hrbn05       LIKE hrbn_file.hrbn05,   #失效日期
        hrbn03       LIKE hrbn_file.hrbn03,   #设置日期
        hrbn06       LIKE hrbn_file.hrbn06    #备注
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5      #No.FUN-680102 SMALLINT               #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680102 INTEGER   
DEFINE g_before_input_done   LIKE type_file.num5      #No.FUN-680102 SMALLINT      #FUN-570110
DEFINE   g_i             LIKE type_file.num5      #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE l_table           STRING                   #No.FUN-760083
DEFINE g_str             STRING                   #No.FUN-760083
DEFINE g_hratid          LIKE hrat_file.hratid
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
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
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i032_w AT p_row,p_col WITH FORM "ghr/42f/ghri032"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
#    LET g_wc2 = '1=1' CALL i032_b_fill(g_wc2)
    CALL i032_menu()
    CLOSE WINDOW i032_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i032_menu()
 
   WHILE TRUE
      CALL i032_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i032_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i032_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbn),'','')
            END IF
         WHEN "ghri032_a"
            IF cl_chk_act_auth() THEN
               CALL i032_p_insert()
            END IF  
         WHEN "ghri032_b"
            IF cl_chk_act_auth() THEN
               CALL i032_p_get()
            END IF           
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i032_q()
   CALL i032_b_askkey()
END FUNCTION
 
FUNCTION i032_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),               #處理狀態
    l_allow_insert  LIKE type_file.chr1,      # Prog. Version..: '5.30.03-12.09.18(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1       # Prog. Version..: '5.30.03-12.09.18(01)               #可刪除否

DEFINE l_hrbn05     LIKE hrbn_file.hrbn05
DEFINE l_count      LIKE type_file.num5
DEFINE l_hrbn03     LIKE hrbn_file.hrbn03
DEFINE l_hrbn04     LIKE hrbn_file.hrbn04
DEFINE l_old_hrbn03 LIKE hrbn_file.hrbn03
DEFINE l_old_hrbn04 LIKE hrbn_file.hrbn04
DEFINE l_new_hrbn05 LIKE hrbn_file.hrbn05


    SELECT trunc(to_date('2099/12/31','yyyy/mm/dd')) INTO l_hrbn05 FROM dual 
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbn01,'','','','',hrbn02,'',hrbn04,hrbn05,hrbn03,hrbn06 FROM hrbn_file",
                       " WHERE hrbn01=? AND hrbn02=? AND hrbn04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i032_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrbn WITHOUT DEFAULTS FROM s_hrbn.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=FALSE,APPEND ROW=l_allow_insert) 
 
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
#No.FUN-570110 --start                                                          
               LET g_before_input_done = FALSE                                  
               CALL i032_set_entry(p_cmd)                                       
               CALL i032_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570110 --end             
               LET g_hrbn_t.* = g_hrbn[l_ac].*  #BACKUP
 
               CALL i032_hrat012hratid(g_hrbn_t.hrbn01) RETURNING g_hratid
               OPEN i032_bcl USING g_hratid,g_hrbn_t.hrbn02,g_hrbn_t.hrbn04
               IF STATUS THEN
                  CALL cl_err("OPEN i032_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i032_bcl INTO g_hrbn[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrbn_t.hrbn01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT hrat01,hrat02,hrat05,hrat25 INTO 
                         g_hrbn[l_ac].hrbn01,g_hrbn[l_ac].hrat02,g_hrbn[l_ac].hrat05,g_hrbn[l_ac].hrat25
                    FROM hrat_file WHERE hratid=g_hrbn[l_ac].hrbn01
                  SELECT hrap06 INTO g_hrbn[l_ac].hrat05 FROM hrap_file WHERE hrap05=g_hrbn[l_ac].hrat05   #No:130822
                  SELECT hrao02 INTO g_hrbn[l_ac].hrao02 FROM hrao_file
                    WHERE hrao01=(SELECT hrat04 FROM hrat_file WHERE hrat01 = g_hrbn[l_ac].hrbn01)
                  SELECT hrag07 INTO g_hrbn[l_ac].hrag07 FROM hrag_file
                    WHERE hrag01='505' AND hrag06=g_hrbn[l_ac].hrbn02
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i032_set_entry(p_cmd)                                           
           CALL i032_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end        
           INITIALIZE g_hrbn[l_ac].* TO NULL      #900423
           LET g_hrbn[l_ac].hrbn05 = l_hrbn05
           LET g_hrbn[l_ac].hrbn03 = g_today
           LET g_hrbn_t.* = g_hrbn[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrbn01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i032_bcl
              CANCEL INSERT
           END IF
           CALL i032_hrat012hratid(g_hrbn[l_ac].hrbn01) RETURNING g_hratid
           INSERT INTO hrbn_file(hrbn01,hrbn02,hrbn04,hrbn05,
                                 hrbn03,hrbn06,hrbnuser,hrbndate,hrbnoriu,hrbnorig)
                         VALUES(g_hratid,g_hrbn[l_ac].hrbn02,g_hrbn[l_ac].hrbn04,g_hrbn[l_ac].hrbn05,
                                g_hrbn[l_ac].hrbn03,g_hrbn[l_ac].hrbn06,g_user,g_today, g_user, g_grup)      
           SELECT COUNT(*) INTO l_count FROM hrbn_file WHERE hrbn01=g_hrbn[l_ac].hrbn01
           IF l_count > 1 THEN
           	  SELECT hrbn03,hrbn04 INTO l_old_hrbn03,l_old_hrbn04 
           	    FROM (SELECT hrbn03,hrbn04,rownum r FROM hrbn_file WHERE hrbn01 = g_hratid ORDER BY hrbn04 DESC)tt
                WHERE tt.r = 2
              SELECT trunc(g_hrbn[l_ac].hrbn04)-1 INTO l_new_hrbn05 FROM dual
                UPDATE hrbn_file SET hrbn05 = l_new_hrbn05
                 WHERE hrbn01 = g_hratid AND hrbn03=l_old_hrbn03 AND hrbn04=l_old_hrbn04
           END IF
           UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02 = g_hratid AND hrcp03 >= g_hrbn[l_ac].hrbn04
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","hrbn_file",g_hrbn[l_ac].hrbn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD hrbn01
            IF NOT cl_null(g_hrbn[l_ac].hrbn01) THEN
#               IF g_hrbn[l_ac].hrbn01 != g_hrbn_t.hrbn01 OR
#                  g_hrbn_t.hrbn01 IS NULL THEN
#                   SELECT COUNT(*) INTO l_n FROM hrbn_file
#                       WHERE hrbn01 = g_hrbn[l_ac].hrbn01
#                   IF l_n > 0 THEN
#                       CALL cl_err('',-239,0)
#                       LET g_hrbn[l_ac].hrbn01 = g_hrbn_t.hrbn01
#                       NEXT FIELD hrbn01
#                   END IF
#               END IF
                SELECT hrat02,hrat05,hrat25 INTO g_hrbn[l_ac].hrat02,g_hrbn[l_ac].hrat05,g_hrbn[l_ac].hrat25
                  FROM hrat_file WHERE hrat01=g_hrbn[l_ac].hrbn01
                SELECT hrap06 INTO g_hrbn[l_ac].hrat05 FROM hrap_file WHERE hrap05=g_hrbn[l_ac].hrat05   #No:130822
                SELECT hrao02 INTO g_hrbn[l_ac].hrao02 FROM hrao_file
                  WHERE hrao01=(SELECT hrat04 FROM hrat_file WHERE hrat01 = g_hrbn[l_ac].hrbn01)
                DISPLAY g_hrbn[l_ac].hrat02,g_hrbn[l_ac].hrat05,g_hrbn[l_ac].hrat25,g_hrbn[l_ac].hrao02
                  TO hrat02,hrat05,hrat25,hrao02
            ELSE 
               CALL cl_err('','ghr-067',0)
               NEXT FIELD hrbn01        
            END IF

       AFTER FIELD hrbn02
           IF NOT cl_null(g_hrbn[l_ac].hrbn02) THEN
               SELECT hrag07 INTO g_hrbn[l_ac].hrag07 FROM hrag_file
                 WHERE hrag01='505' AND hrag06=g_hrbn[l_ac].hrbn02
               DISPLAY g_hrbn[l_ac].hrag07 TO hrag07	  
           ELSE
               CALL cl_err('','ghr-068',0)
               NEXT FIELD hrbn02
           END IF
                                                  	
       AFTER FIELD hrbn04
          IF NOT cl_null(g_hrbn[l_ac].hrbn04) THEN
             IF g_hrbn[l_ac].hrbn04 > g_hrbn[l_ac].hrbn05 THEN
             	  CALL cl_err('','',0)
             	  NEXT FIELD hrbn04
             END IF
             IF NOT cl_null(g_hrbn[l_ac].hrbn01) THEN
               CALL i032_hrat012hratid(g_hrbn[l_ac].hrbn01) RETURNING g_hratid
             	 SELECT COUNT(*) INTO l_count FROM hrbn_file WHERE hrbn01=g_hratid
             	 IF l_count > 1 THEN
             	 	  SELECT MAX(hrbn03) INTO l_hrbn03 FROM hrbn_file WHERE hrbn01=g_hratid AND hrbn05<g_hrbn[l_ac].hrbn05
             	 	  SELECT hrbn04 INTO l_hrbn04 FROM hrbn_file WHERE hrbn01=g_hratid AND hrbn03=l_hrbn03
             	 	  IF g_hrbn[l_ac].hrbn04 < l_hrbn04 THEN   #员工新生效日期不得小于前一次生效日期
             	 	  	 CALL cl_err(g_hrbn[l_ac].hrbn01,'ghr-069',0)    
             	 	  	 NEXT FIELD hrbn04
             	 	  END IF
             	 END IF
             END IF
          ELSE
             CALL cl_err('','ghr-070',0)
             NEXT FIELD hrbn04
          END IF
      
#        BEFORE DELETE                            #是否取消單身
#            IF g_hrbn_t.hrbn01 IS NOT NULL THEN
#                IF NOT cl_delete() THEN
#                     CANCEL DELETE
#                END IF
#                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
#                LET g_doc.column1 = "hrbn01"               #No.FUN-9B0098 10/02/24
#                LET g_doc.value1 = g_hrbn[l_ac].hrbn01      #No.FUN-9B0098 10/02/24
#                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
#                IF l_lock_sw = "Y" THEN 
#                   CALL cl_err("", -263, 1) 
#                   CANCEL DELETE 
#                END IF 
#                DELETE FROM hrbn_file WHERE hrbn01 = g_hrbn_t.hrbn01
#                IF SQLCA.sqlcode THEN
# #                   CALL cl_err(g_hrbn_t.hrbn01,SQLCA.sqlcode,0)    #No.FUn-660131
#                     CALL cl_err3("del","hrbn_file",g_hrbn_t.hrbn01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
#                    EXIT INPUT
#                END IF
#                LET g_rec_b=g_rec_b-1
#                DISPLAY g_rec_b TO FORMONLY.cn2  
#                COMMIT WORK
#            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrbn[l_ac].* = g_hrbn_t.*
              CLOSE i032_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrbn[l_ac].hrbn01,-263,0)
               LET g_hrbn[l_ac].* = g_hrbn_t.*
           ELSE
               CALL i032_hrat012hratid(g_hrbn[l_ac].hrbn01) RETURNING g_hratid
               UPDATE hrbn_file SET 
                                    hrbn02=g_hrbn[l_ac].hrbn02,
                                    hrbn03=g_hrbn[l_ac].hrbn03,
                                    hrbn04=g_hrbn[l_ac].hrbn04,
                                    hrbn05=g_hrbn[l_ac].hrbn05,
                                    hrbn06=g_hrbn[l_ac].hrbn06,
                                    hrbnmodu=g_user,
                                    hrbndate=g_today
                WHERE hrbn01 = g_hratid AND hrbn02=g_hrbn_t.hrbn02 AND hrbn04=g_hrbn_t.hrbn04
                SELECT COUNT(*) INTO l_count FROM hrbn_file WHERE hrbn01 = g_hrbn_t.hrbn01
                IF l_count > 1 THEN
                	 SELECT hrbn03,hrbn04 INTO l_old_hrbn03,l_old_hrbn04 
                	   FROM (SELECT hrbn03,hrbn04,rownum r FROM hrbn_file WHERE hrbn01 = g_hratid ORDER BY hrbn04 DESC)tt
                	   WHERE tt.r = '2'
                	 SELECT trunc(g_hrbn[l_ac].hrbn04)-1 INTO l_new_hrbn05 FROM dual
                	 UPDATE hrbn_file SET hrbn05 = l_new_hrbn05
                	   WHERE hrbn01 = g_hratid AND hrbn03=l_old_hrbn03 AND hrbn04=l_old_hrbn04
                END IF                  
           UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02 = g_hratid AND hrcp03 >= g_hrbn[l_ac].hrbn04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrbn_file",g_hrbn_t.hrbn01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrbn[l_ac].* = g_hrbn_t.*
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
                 LET g_hrbn[l_ac].* = g_hrbn_t.*
              END IF
              CLOSE i032_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i032_bcl
           COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(hrbn01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrat01"
                   LET g_qryparam.default1 = g_hrbn[l_ac].hrbn01
                   CALL cl_create_qry() RETURNING g_hrbn[l_ac].hrbn01
                   DISPLAY g_hrbn[l_ac].hrbn01 TO hrbn01
                WHEN INFIELD(hrbn02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrag07"
                   LET g_qryparam.default1 = g_hrbn[l_ac].hrbn02
                   CALL cl_create_qry() RETURNING g_hrbn[l_ac].hrbn02
                   DISPLAY g_hrbn[l_ac].hrbn02 TO hrbn02
                OTHERWISE
                   EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(hrbn01) AND l_ac > 1 THEN
                LET g_hrbn[l_ac].* = g_hrbn[l_ac-1].*
                NEXT FIELD hrbn01
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
 
 
    CLOSE i032_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i032_b_askkey()
 
    CLEAR FORM
   CALL g_hrbn.clear()
 
    CONSTRUCT g_wc2 ON hrbn01,hrbn02,hrbn04,hrbn05,hrbn03,hrbn06
         FROM s_hrbn[1].hrbn01,s_hrbn[1].hrbn02,s_hrbn[1].hrbn04,s_hrbn[1].hrbn05,s_hrbn[1].hrbn03,s_hrbn[1].hrbn06
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
             CASE WHEN INFIELD(hrbn01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_hrat01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_hrbn[1].hrbn01            
                  WHEN INFIELD(hrbn02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_hrag07"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_hrbn[1].hrbn02 
                  OTHERWISE
                     EXIT CASE
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
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbnuser', 'hrbngrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i032_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i032_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(200)
    LET p_wc2 = cl_replace_str(p_wc2,"hrbn01","hrat01") 
    LET g_sql =
       #"SELECT hrbn01,'','','','',hrbn02,'',hrbn04,hrbn05,hrbn03,hrbn06",
        "SELECT hrat01,'','','','',hrbn02,'',hrbn04,hrbn05,hrbn03,hrbn06",
        "  FROM hrbn_file,hrat_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hrbn01 = hratid ",
        " ORDER BY 1"
    PREPARE i032_pb FROM g_sql
    DECLARE hrbn_curs CURSOR FOR i032_pb
 
    CALL g_hrbn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbn_curs INTO g_hrbn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02,hrat05,hrat25 INTO g_hrbn[g_cnt].hrat02,g_hrbn[g_cnt].hrat05,g_hrbn[g_cnt].hrat25
          FROM hrat_file WHERE hrat01=g_hrbn[g_cnt].hrbn01
        SELECT hrap06 INTO g_hrbn[g_cnt].hrat05 FROM hrap_file WHERE hrap05=g_hrbn[g_cnt].hrat05   #No:130822
        SELECT hrao02 INTO g_hrbn[g_cnt].hrao02 FROM hrao_file
          WHERE hrao01=(SELECT hrat04 FROM hrat_file WHERE hrat01 = g_hrbn[g_cnt].hrbn01)
        SELECT hrag07 INTO g_hrbn[g_cnt].hrag07 FROM hrag_file
          WHERE hrag01='505' AND hrag06=g_hrbn[g_cnt].hrbn02
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i032_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbn TO s_hrbn.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         
 #     ON ACTION ghri032_a
 #        LET g_action_choice="ghri032_a"
 #        EXIT DISPLAY
         
      ON ACTION ghri032_b
         LET g_action_choice="ghri032_b"
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
                                                         
FUNCTION i032_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrbn01,hrbn03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i032_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("hrbn01,hrbn03",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
    
FUNCTION i032_p_insert()
DEFINE l_cmd  LIKE type_file.chr1000

  LET l_cmd = "ghri032_1"
  CALL cl_cmdrun(l_cmd)
END FUNCTION

FUNCTION i032_p_get()
   INSERT INTO hrbn_file (hrbn01,hrbn02,hrbn03,hrbn04,hrbn05,hrbnuser,hrbndate,hrbnorig,hrbnoriu)
   SELECT hratid,'003',trunc(SYSDATE),hrat25,NVL(hrat77,to_date('20991231','yyyymmdd')),'tiptop',trunc(SYSDATE),hrat04,'tiptop'
   FROM hrat_file
   WHERE NOT EXISTS(SELECT 1 FROM hrbn_file WHERE hrbn01=hratid)
   UPDATE hrcp_file SET hrcp35='N' WHERE EXISTS(SELECT 1 FROM hrbn_file where hrbn03=TRUNC(SYSDATE) AND hrbn01=hrcp02) AND hrcp03 >= TRUNC(SYSDATE)
END FUNCTION 

FUNCTION i032_hrat012hratid(p_hrat01)
   DEFINE p_hrat01  LIKE  hrat_file.hrat01
   DEFINE l_hratid  LIKE  hrat_file.hratid

   WHENEVER ERROR CONTINUE
   SELECT hratid INTO l_hratid FROM hrat_file
    WHERE hrat01  = p_hrat01
   IF SQLCA.sqlcode THEN
      LET l_hratid = NULL
   END IF
   RETURN l_hratid
END FUNCTION


