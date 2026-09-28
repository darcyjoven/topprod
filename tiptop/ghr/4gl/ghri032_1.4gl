# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri032_1.4gl
# Descriptions...: 批量插入员工考勤方式作业
# Date & Author..: 13/05/09 by lijun

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_hrbn02           LIKE hrbn_file.hrbn02,  
  g_hrbn02_t         LIKE hrbn_file.hrbn02,  
  g_hrbn04           LIKE hrbn_file.hrbn04, 
  g_hrbn04_t         LIKE hrbn_file.hrbn04,
  g_hrbn03           LIKE hrbn_file.hrbn03, 
  g_hrbn05           LIKE hrbn_file.hrbn05,
  g_hrag07           LIKE hrag_file.hrag07,
  g_hrbnuser         LIKE hrbn_file.hrbnuser, #資料所有者
  g_hrbngrup         LIKE hrbn_file.hrbngrup, #資料所有部門
  g_hrbnmodu         LIKE hrbn_file.hrbnmodu, #資料修改者
  g_hrbndate         LIKE hrbn_file.hrbndate, #最后修改日期
  g_hrbnoriu         LIKE hrbn_file.hrbnoriu,   #TQC-AA0103
  g_hrbnorig         LIKE hrbn_file.hrbnorig,   #TQC-AA0103
  l_cnt             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
  g_hrbn             DYNAMIC ARRAY OF RECORD   #單身數組
           num       LIKE type_file.num5,
           hrbn01    LIKE hrbn_file.hrbn01,
           hrat02    LIKE hrat_file.hrat02,
           hrao02    LIKE hrao_file.hrao02,
           hrat05    LIKE hrap_file.hrap06,
           hrat25    LIKE hrat_file.hrat25,
           hrbn06    LIKE hrbn_file.hrbn06
                    END RECORD,
  g_hrbn_t           RECORD   #單身數組舊值
           num       LIKE type_file.num5,
           hrbn01    LIKE hrbn_file.hrbn01,
           hrat02    LIKE hrat_file.hrat02,
           hrao02    LIKE hrao_file.hrao02,
           hrat05    LIKE hrap_file.hrap06,
           hrat25    LIKE hrat_file.hrat25,
           hrbn06    LIKE hrbn_file.hrbn06
                    END RECORD,
  g_hrbn1            DYNAMIC ARRAY OF RECORD   #hrbn_file
           hrbn01    LIKE hrbn_file.hrbn01,
           hrbn02    LIKE hrbn_file.hrbn02,
           hrbn03    LIKE hrbn_file.hrbn03,
           hrbn04    LIKE hrbn_file.hrbn04,
           hrbn05    LIKE hrbn_file.hrbn05,
           hrbn06    LIKE hrbn_file.hrbn06
                    END RECORD,
  g_wc,g_wc2,g_sql  STRING,
  g_delete          LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
  g_rec_b           LIKE type_file.num5,          #No.FUN-680136 SMALLINT 
  l_ac              LIKE type_file.num5           #No.FUN-680136 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680136 SMALLINT 
DEFINE g_forupd_sql        STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10         #No.FUN-680136  INTEGER
DEFINE g_i                 LIKE type_file.num5          #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index        LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump              LIKE type_file.num10         #No.FUN-680136 INTEGER                                                  #No.FUN-680136
DEFINE g_no_ask           LIKE type_file.num5          #No.FUN-680136 INTEGER   #No.FUN-6A0067
 
MAIN
    OPTIONS                                #改變一些系統預設值 
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理  
 
    IF (NOT cl_user()) THEN 
       EXIT PROGRAM 
    END IF 
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("GHR")) THEN #MOD-990167 AXM-->ghr     
       EXIT PROGRAM
    END IF
    
    DROP TABLE hrbn_tmp
    CREATE TEMP TABLE hrbn_tmp(
     num     LIKE type_file.num5,
     hrbn01  LIKE hrbn_file.hrbn01,
     hrbn02  LIKE hrbn_file.hrbn02,
     hrbn03  LIKE hrbn_file.hrbn03,
     hrbn04  LIKE hrbn_file.hrbn04,
     hrbn05  LIKE hrbn_file.hrbn05,
     hrbn06  LIKE hrbn_file.hrbn06);
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    INITIALIZE g_hrbn TO NULL                                                
    INITIALIZE g_hrbn_t.* TO NULL                                                                    
 
    OPEN WINDOW i032_1_w WITH FORM "ghr/42f/ghri032_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_delete='N'
    CALL i032_1_menu()   
    CLOSE WINDOW i032_1_w     
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i032_1_menu()
    WHILE TRUE
      CALL i032_1_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i032_1_a()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i032_1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "date_out"
            CALL i032_1_date_out()       
      END CASE
    END WHILE
END FUNCTION 
 
FUNCTION i032_1_a() 
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM
    CALL g_hrbn.clear()
    INITIALIZE g_hrbn02 LIKE hrbn_file.hrbn02

    LET g_hrbn02_t = NULL
    CALL cl_opmsg('a')
    LET g_hrbnuser=g_user
    LET g_hrbngrup=g_grup
    LET g_hrbndate=g_today
    LET g_hrbnoriu = g_user   #TQC-AA0103
    LET g_hrbnorig = g_grup   #TQC-AA0103
    SELECT trunc(to_date('9999/12/31','yyyy/mm/dd')) INTO g_hrbn05 FROM dual
    LET g_hrbn04 = NULL
    LET g_hrbn03 = g_today
    WHILE TRUE
        CALL i032_1_i("a")     #輸入單頭
        IF INT_FLAG THEN     #使用者不玩了 
           LET g_hrbn02 = NULL
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i032_1_b()                    
        LET g_hrbn02_t = g_hrbn02         
        EXIT WHILE
    END WHILE        
END FUNCTION
 
FUNCTION i032_1_i(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
         l_n             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         l_pma02         LIKE pma_file.pma02
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
    INPUT g_hrbn02,g_hrbn04,g_hrbn03 WITHOUT DEFAULTS FROM hrbn02,hrbn04,hrbn03
 
        BEFORE INPUT
            LET g_before_input_done = FALSE 
            CALL i032_1_set_entry(p_cmd) 
            CALL i032_1_set_no_entry(p_cmd) 
            LET g_before_input_done = TRUE
 
        AFTER FIELD hrbn02
           IF NOT cl_null(g_hrbn02) THEN
               SELECT hrag07 INTO g_hrag07 FROM hrag_file
                 WHERE hrag01='505' AND hrag06=g_hrbn02
               DISPLAY g_hrag07 TO hrag07	  
           ELSE
               CALL cl_err('','ghr-068',0)
               NEXT FIELD hrbn02
           END IF
        
        AFTER FIELD hrbn04
           IF cl_null(g_hrbn04) THEN	  
               CALL cl_err('','ghr-070',0)
               NEXT FIELD hrbn04
           END IF

        AFTER FIELD hrbn03
           IF cl_null(g_hrbn03) THEN
               CALL cl_err('','',0)
               NEXT FIELD hrbn03
           END IF        
 
        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(hrbn02)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_hrag07"
                   LET g_qryparam.default1 = g_hrbn02
                   CALL cl_create_qry() RETURNING g_hrbn02
                   DISPLAY g_hrbn02 TO hrbn02
                   NEXT FIELD hrbn02        
            END CASE
   
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
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END INPUT
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i032_1_show()

    SELECT hrag07
      INTO g_hrag07
      FROM hrag_file
     WHERE hrag01='505' AND hrag06=g_hrbn02  
 
    DISPLAY g_hrbn02 TO hrbn02  #ATTRIBUTE(YELLOW)    #單頭
    DISPLAY g_hrbn04 TO hrbn04
    DISPLAY g_hrbn03 TO hrbn03
    DISPLAY g_hrag07 TO hrag07

    CALL i032_1_b_fill('1=1')                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i032_1_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用         #No.FUN-680136 SMALLINT
    l_ac_o          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_rows          LIKE type_file.num5,                #No.FUN-680136 SMALLINT
    l_success       LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #可刪除否        #No.FUN-680136 SMALLINT
 
DEFINE l_hrbnuser    LIKE hrbn_file.hrbnuser,  #判斷修改者和資料所有者是否為同一人
       l_hrbngrup    LIKE hrbn_file.hrbngrup
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_hrbn02) THEN RETURN END IF
    IF cl_null(g_hrbn04) THEN RETURN END IF
    IF cl_null(g_hrbn03) THEN RETURN END IF
 
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT num,hrbn01,'','','','',hrbn06 ",
                       "   FROM hrbn_tmp  ",
                       "   WHERE hrbn02=?   ",
                       "    AND hrbn04=? AND hrbn03=? AND num=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i032_1_bcl CURSOR FROM g_forupd_sql 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_hrbn WITHOUT DEFAULTS FROM s_hrbn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i032_1_set_entry_b()
            CALL i032_1_set_no_entry_b()
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_hrbn_t.* = g_hrbn[l_ac].*      #BACKUP
                OPEN i032_1_bcl USING g_hrbn02,g_hrbn04,g_hrbn03,g_hrbn_t.num
                IF STATUS THEN
                   CALL cl_err("OPEN i032_1_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i032_1_bcl INTO g_hrbn[l_ac].* 
                   IF STATUS THEN
                      CALL cl_err(g_hrbn_t.hrbn01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                    SELECT hrat02,hrat05,hrat25 INTO g_hrbn[l_ac].hrat02,g_hrbn[l_ac].hrat05,g_hrbn[l_ac].hrat25
                      FROM hrat_file WHERE hratid=g_hrbn[l_ac].hrbn01
                    SELECT hrap06 INTO g_hrbn[l_ac].hrat05 FROM hrap_file WHERE hrap05 = g_hrbn[l_ac].hrat05  #No:130823
                    SELECT hrao02 INTO g_hrbn[l_ac].hrao02 FROM hrao_file
                      WHERE hrao01=(SELECT hrat04 FROM hrat_file WHERE hratid = g_hrbn[l_ac].hrbn01)                     
                    LET g_hrbn_t.*=g_hrbn[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrbn[l_ac].* TO NULL      #900423
            LET g_hrbn_t.* = g_hrbn[l_ac].*         #輸入新資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD hrbn01
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO hrbn_tmp(num,hrbn02,hrbn04,hrbn03,hrbn01,hrbn06,hrbn05)
                          VALUES(l_ac,g_hrbn02,g_hrbn04,g_hrbn03,g_hrbn[l_ac].hrbn01,g_hrbn[l_ac].hrbn06,g_hrbn05)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","hrbn_tmp",g_hrbn02,g_hrbn[l_ac].hrbn01,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
#               UPDATE hrbn_file SET hrbnmodu = g_hrbnmodu
#                WHERE hrbn01=g_hrbn01
               MESSAGE 'INSERT O.K'
               COMMIT WORK 
               LET g_rec_b=g_rec_b+1
            END IF
 
        AFTER FIELD hrbn01
            IF g_hrbn[l_ac].hrbn01 != g_hrbn_t.hrbn01 OR g_hrbn_t.hrbn01 IS NULL THEN
               SELECT COUNT(hrbn01) INTO l_n FROM hrbn_tmp
                WHERE hrbn02=g_hrbn02 AND hrbn04=g_hrbn04 AND hrbn03=g_hrbn03 AND hrbn01=g_hrbn[l_ac].hrbn01
               IF l_n>=1 THEN
                  CALL cl_err(g_hrbn[l_ac].hrbn01,"",0)
                  LET g_hrbn[l_ac].hrbn01=g_hrbn_t.hrbn01
                  NEXT FIELD hrbn01
               END IF
               SELECT hrat02,hrat05,hrat25 INTO g_hrbn[l_ac].hrat02,g_hrbn[l_ac].hrat05,g_hrbn[l_ac].hrat25
                    FROM hrat_file WHERE hratid=g_hrbn[l_ac].hrbn01
               SELECT hrap06 INTO g_hrbn[l_ac].hrat05 FROM hrap_file WHERE hrap05 = g_hrbn[l_ac].hrat05   #No:130823
               SELECT hrao02 INTO g_hrbn[l_ac].hrao02 FROM hrao_file
                    WHERE hrao01=(SELECT hrat04 FROM hrat_file WHERE hratid = g_hrbn[l_ac].hrbn01)
            END IF
 
        BEFORE DELETE                            #刪除單身
            IF g_hrbn_t.hrbn01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM hrbn_tmp
                 WHERE hrbn02 = g_hrbn02
                   AND hrbn04 = g_hrbn04
                   AND hrbn03 = g_hrbn03 
                   AND hrbn01 = g_hrbn_t.hrbn01 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","hrbn_tmp",g_hrbn_t.hrbn01,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrbn[l_ac].* = g_hrbn_t.*
               CLOSE i032_1_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrbn[l_ac].hrbn01,-263,1)
               LET g_hrbn[l_ac].* = g_hrbn_t.*
            ELSE
               UPDATE hrbn_tmp SET hrbn02  =g_hrbn02,
                                   hrbn04  =g_hrbn04,
                                   hrbn03 = g_hrbn03,
                                   hrbn01=g_hrbn[l_ac].hrbn01,
                                   hrbn06=g_hrbn[l_ac].hrbn06,
                                   num  = g_hrbn[l_ac].num
                WHERE hrbn02 = g_hrbn02
                  AND hrbn04 = g_hrbn04
                  AND hrbn03 = g_hrbn03 
                  AND hrbn01 = g_hrbn_t.hrbn01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","hrbn_tmp",g_hrbn[l_ac].hrbn01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_hrbn[l_ac].* = g_hrbn_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
 
    AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_hrbn[l_ac].* = g_hrbn_t.*
               END IF
               CLOSE i032_1_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i032_1_bcl
            COMMIT WORK
#No.TQC-6C0019  --begin
    AFTER INPUT 
#        SELECT SUM(hrbn05) INTO l_hrbn05 FROM hrbn_file WHERE hrbn01=g_hrbn01
#        IF l_hrbn05 <>100 THEN
#           CALL cl_err(' ','agl-107',0)
#           NEXT FIELD hrbn05
#        END IF
#No.TQC-6C0019  --end  
          
 
        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(hrbn01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_hrat03"
#                   LET g_qryparam.default1 = g_hrbn[l_ac].hrbn01
#                   CALL cl_create_qry() RETURNING g_hrbn[l_ac].hrbn01
#                   NEXT FIELD hrbn01
#           END CASE
            CASE
            	 WHEN INFIELD(hrbn01)
            	    CALL i032_1_hrbn01()
                    EXIT INPUT
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
#        ON ACTION CONTROLO                        #沿用所有欄位                                                                     
#           IF INFIELD(hrbn03) AND l_ac > 1 THEN                                                                                      
#               LET g_hrbn[l_ac].* = g_hrbn[l_ac-1].* 
#               LET g_hrbn[l_ac].hrbn03 = g_rec_b+1
#               NEXT FIELD hrbn03                                                                                                     
#           END IF      
 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
    CLOSE i032_1_bcl
    COMMIT WORK
    CALL i032_1_b_fill(" 1=1")
    #No.TQC-6C0019  --begin
#    FOR l_ac=1 TO g_rec_b 
#        IF g_hrbn[l_ac].hrbn05 <=0 THEN
#           CALL cl_err(' ','agl-105',0)
#           CALL i032_1_b()
#        END IF
#    END FOR
 
#    SELECT SUM(hrbn05) INTO l_hrbn05 FROM hrbn_file WHERE  hrbn01=g_hrbn01
#       IF l_hrbn05 <>100 THEN
#          CALL cl_err(' ','agl-107',0)
#          CALL i032_1_b() 
#       END IF
    #No.TQC-6C0019  --end
#    SELECT COUNT(hrbn03) INTO l_n FROM hrbn_file WHERE hrbn01=g_hrbn01
#    IF l_n = 0 THEN
#       CALL i032_1_delall() 
#    END IF
 
END FUNCTION
 
FUNCTION i032_1_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT num,hrbn01,'','','','',hrbn06 ",
                "  FROM hrbn_tmp",
                " WHERE hrbn02 = '",g_hrbn02,"' AND hrbn04 = '",g_hrbn04,"' AND hrbn03 = '",g_hrbn03,"' ",
                " ORDER BY 1"
    PREPARE i032_1_prepare2 FROM g_sql      
    DECLARE hrbn_cs CURSOR FOR i032_1_prepare2
    CALL g_hrbn.clear()
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH hrbn_cs INTO g_hrbn[g_cnt].*   #單身ARRAY填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT hrat02,hrat05,hrat25 INTO g_hrbn[g_cnt].hrat02,g_hrbn[g_cnt].hrat05,g_hrbn[g_cnt].hrat25
          FROM hrat_file WHERE hratid=g_hrbn[g_cnt].hrbn01
        SELECT hrap06 INTO g_hrbn[l_ac].hrat05 FROM hrap_file WHERE hrap05 = g_hrbn[l_ac].hrat05  #No:130823
        SELECT hrao02 INTO g_hrbn[g_cnt].hrao02 FROM hrao_file
          WHERE hrao01=(SELECT hrat04 FROM hrat_file WHERE hratid = g_hrbn[g_cnt].hrbn01)
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
        CALL g_hrbn.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1
    DISPLAY  g_rec_b TO cnt
       #LET g_cnt = 0
END FUNCTION
 
FUNCTION i032_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbn TO s_hrbn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()   
 
      ON ACTION insert
         LET g_action_choice="insert"
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION date_out
         LET g_action_choice="date_out"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i032_1_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("hrbn02,hrbn04,hrbn03",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i032_1_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("hrbn02,hrbn04,hrbn03",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION
 
FUNCTION i032_1_set_entry_b()
#    IF g_hrbn02='1' THEN
#       CALL cl_set_comp_entry("hrbn05",TRUE)
#    END IF
END FUNCTION
 
FUNCTION i032_1_set_no_entry_b()
#    IF g_hrbn02='2' THEN
#       CALL cl_set_comp_entry("hrbn05",FALSE)
#    END IF
END FUNCTION
 
FUNCTION i032_1_date_out()
DEFINE l_sql LIKE type_file.chr1000
DEFINE l_insert LIKE type_file.chr1000
DEFINE l_cnt LIKE type_file.num5
DEFINE l_count LIKE type_file.num5
DEFINE l_old_hrbn03 LIKE hrbn_file.hrbn03
DEFINE l_old_hrbn04 LIKE hrbn_file.hrbn04
DEFINE l_new_hrbn05 LIKE hrbn_file.hrbn05

   LET l_sql = "SELECT hrbn01,hrbn02,hrbn03,hrbn04,hrbn05,hrbn06 FROM hrbn_tmp WHERE hrbn02='",g_hrbn02,"' AND hrbn04='",g_hrbn04,"'"
   PREPARE i032_1_sql FROM l_sql      
   DECLARE hrbn_cs_out CURSOR FOR i032_1_sql
   CALL g_hrbn1.clear()
   LET l_cnt = 1
 
   FOREACH hrbn_cs_out INTO g_hrbn1[l_cnt].*
    IF NOT cl_null(g_hrbn1[l_cnt].hrbn01) AND NOT cl_null(g_hrbn1[l_cnt].hrbn02) AND NOT cl_null(g_hrbn1[l_cnt].hrbn04)THEN
      LET l_insert = " INSERT INTO hrbn_file(hrbn01,hrbn02,hrbn03,hrbn04,hrbn05,hrbn06,",
                     " hrbnuser,hrbngrup,hrbndate,hrbnorig,hrbnoriu)",
                     " VALUES(?,?,?,?,?,?, ",
                     " ?,?,?,?,?)"
      PREPARE i032_1_insert FROM l_insert
      DECLARE hrbn_cs_insert CURSOR FOR i032_1_insert
      EXECUTE hrbn_cs_insert USING g_hrbn1[l_cnt].hrbn01,g_hrbn1[l_cnt].hrbn02,g_hrbn1[l_cnt].hrbn03,g_hrbn1[l_cnt].hrbn04,
                                   g_hrbn1[l_cnt].hrbn05,g_hrbn1[l_cnt].hrbn06,g_user,g_grup,g_today,g_grup,g_user
      IF STATUS THEN
      	CALL cl_err('insert hrbn_file:',STATUS,0)
      ELSE
        SELECT COUNT(*) INTO l_count FROM hrbn_file WHERE hrbn01=g_hrbn1[l_cnt].hrbn01
           IF l_count > 0 THEN
           	  SELECT hrbn03,hrbn04 INTO l_old_hrbn03,l_old_hrbn04 
           	    FROM (SELECT hrbn03,hrbn04,rownum r FROM hrbn_file WHERE hrbn01 = g_hrbn1[l_cnt].hrbn01 ORDER BY hrbn04 DESC)tt
                WHERE tt.r = 2
              SELECT trunc(g_hrbn1[l_cnt].hrbn04)-1 INTO l_new_hrbn05 FROM dual
                UPDATE hrbn_file SET hrbn05 = l_new_hrbn05
                	WHERE hrbn01 = g_hrbn1[l_cnt].hrbn01 AND hrbn03=l_old_hrbn03 AND hrbn04=l_old_hrbn04
           END IF 
        UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02 = g_hrbn1[l_cnt].hrbn01 AND hrcp03 >= g_hrbn1[l_cnt].hrbn04
      END IF
    END IF
    LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_hrbn1.deleteElement(l_cnt)
   CALL cl_err('','ghr-071',1)
END FUNCTION

FUNCTION i032_1_hrbn01()
DEFINE   l_sql      STRING
DEFINE   i          LIKE   type_file.num5
DEFINE   j          LIKE   type_file.num5
DEFINE   gs_wc      STRING
DEFINE   l_hrbn     RECORD LIKE hrbn_file.*
DEFINE   lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE   l_hrat   DYNAMIC ARRAY OF RECORD
            sel      LIKE type_file.chr1,
           #hratid   LIKE hrat_file.hratid,
            hrat01   LIKE hrat_file.hrat01,
            hrat02   LIKE hrat_file.hrat02,
            hrao02   LIKE hrao_file.hrao02,
            hrat05   LIKE hrap_file.hrap06,
            hrat25   LIKE hrat_file.hrat25
                 END RECORD
DEFINE   p_row,p_col  LIKE type_file.num5
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_delete  LIKE type_file.num5
DEFINE l_num           LIKE type_file.num5
			 
			 DROP TABLE hrat_tmp
   		 
   		 SELECT hratid,hrat01,hrat02,hrao02,hrat05,hrat25 FROM hrat_file,hrao_file
   		  WHERE hrat04=hrao01 AND hratacti='Y'
   		 INTO TEMP hrat_tmp
   		 
   		 IF STATUS THEN CALL cl_err('ins hrat_tmp:',STATUS,1) RETURN END IF 
   		 	
   		 LET p_row=3   LET p_col=6

       OPEN WINDOW i032_m_w AT p_row,p_col WITH FORM "ghr/42f/ghri032_m"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("ghri032_m")

      CONSTRUCT gs_wc ON hrat01,hrat02,hrat05,hrat25
           FROM s_hrat_m[1].hrat01,s_hrat_m[1].hrat02,s_hrat_m[1].hrat05,
                s_hrat_m[1].hrat25

      BEFORE CONSTRUCT
#           CALL cl_qbe_display_condition(lc_qbe_sn)
           CALL cl_qbe_init()
           

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
          
       ON ACTION controlp
#          CASE
#          	 WHEN INFIELD(hras02)
#          	 LET g_qryparam.form = "q_hraa01"
#             LET g_qryparam.state = "c"
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
#             DISPLAY g_qryparam.multiret TO hras02
#             NEXT FIELD hras02
#          END CASE      

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()
      

     END CONSTRUCT

     IF INT_FLAG THEN
     	  LET INT_FLAG='0'
        DELETE FROM hrap_tmp
        CLOSE WINDOW i032_m_w
        RETURN
     END IF	
     	
     LET l_sql=" SELECT 'N',hrat01,hrat02,hrao02,hrat05,hrat25 ",
               "   FROM hrat_tmp ",
               "  WHERE ",gs_wc CLIPPED,
               "  ORDER BY hrat01"


      PREPARE i002_m_pre FROM l_sql
      DECLARE i002_m_cs CURSOR FOR i002_m_pre

      LET i=1
      CALL l_hrat.clear()
      FOREACH i002_m_cs INTO l_hrat[i].*

        SELECT hrap06 INTO l_hrat[i].hrat05 FROM hrap_file WHERE hrap05 = l_hrat[i].hrat05  #No:130823
        LET i=i+1

      END FOREACH
      
      CALL l_hrat.deleteElement(i)
      LET i=i-1
      DISPLAY i TO cn2

      INPUT ARRAY l_hrat WITHOUT DEFAULTS FROM s_hrat_m.*
#            ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
             ATTRIBUTE(COUNT=i,MAXCOUNT=i,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        
         ON ACTION reconstruct
            CLEAR FORM
            CALL l_hrat.clear()
            CONSTRUCT gs_wc ON hrat01,hrat02,hrat05,hrat25
            FROM s_hrat_m[1].hrat01,s_hrat_m[1].hrat02,s_hrat_m[1].hrat05,
                s_hrat_m[1].hrat25

           BEFORE CONSTRUCT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
             CALL cl_qbe_init()
           

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
    
           ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121

           ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121

           ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()
      

         END CONSTRUCT

          IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET gs_wc = NULL
              EXIT INPUT
          END IF	
          	
          LET l_sql=" SELECT 'N',hrat01,hrat02,hrao02,hrat05,hrat25 ",
                    "   FROM hrat_tmp ",
                    "  WHERE ",gs_wc CLIPPED,
                    "  ORDER BY hrat01"
        
        
           PREPARE i002_m_pre_1 FROM l_sql
           DECLARE i002_m_c1 CURSOR FOR i002_m_pre_1
        
           LET i=1
           CALL l_hrat.clear()
           FOREACH i002_m_c1 INTO l_hrat[i].*
        
             SELECT hrap06 INTO l_hrat[i].hrat05 FROM hrap_file WHERE hrap05 = l_hrat[i].hrat05  #No:130823
             LET i=i+1
        
           END FOREACH
           
           CALL l_hrat.deleteElement(i)
           LET i=i-1
           DISPLAY i TO cn2              
        ON ACTION select_all      
            LET l_sql=" SELECT 'Y',hrat01,hrat02,hrao02,hrat05,hrat25 ",
                         "   FROM hrat_tmp ",
                         "  WHERE ",gs_wc CLIPPED,
                         "  ORDER BY hrat01"
            PREPARE i002_m_pre1 FROM l_sql
            DECLARE i002_m_cs1 CURSOR FOR i002_m_pre1

            LET j=1
            CALL l_hrat.clear()
            FOREACH i002_m_cs1 INTO l_hrat[j].*
               SELECT hrap06 INTO l_hrat[i].hrat05 FROM hrap_file WHERE hrap05 = l_hrat[i].hrat05  #No:130823
               LET j=j+1
            END FOREACH
            
        ON ACTION select_no      
            LET l_sql=" SELECT 'N',hrat01,hrat02,hrao02,hrat05,hrat25 ",
                         "   FROM hrat_tmp ",
                         "  WHERE ",gs_wc CLIPPED,
                         "  ORDER BY hrat01"
            PREPARE i002_m_pre3 FROM l_sql
            DECLARE i002_m_cs3 CURSOR FOR i002_m_pre3

            LET j=1
            CALL l_hrat.clear()
            FOREACH i002_m_cs3 INTO l_hrat[j].*
               SELECT hrap06 INTO l_hrat[i].hrat05 FROM hrap_file WHERE hrap05 = l_hrat[i].hrat05  #No:130823
               LET j=j+1
            END FOREACH 
       
        AFTER INPUT
           FOR g_cnt=1 TO i
            IF l_hrat[g_cnt].sel = 'Y' THEN
            	   IF INT_FLAG THEN
            	   	LET INT_FLAG='0'
                  DELETE FROM hrap_tmp
                  CLOSE WINDOW i032_m_w
                  RETURN
                  ELSE 
                 	CONTINUE FOR
                 END IF	     
            ELSE
               DELETE FROM hrat_tmp WHERE hrat01=l_hrat[g_cnt].hrat01
            END IF
            IF l_hrat[g_cnt].hrat01 IS NULL THEN CONTINUE FOR END IF
           END FOR
         
       

      END INPUT
      
      IF INT_FLAG THEN 
      	LET INT_FLAG=0
      	DELETE FROM hrat_tmp
      END IF

      CLOSE WINDOW i032_m_w

      LET l_sql="  SELECT hratid ",
                "  FROM hrat_tmp ",
                "  WHERE ",gs_wc CLIPPED,
                " ORDER BY hrat01"

      PREPARE i002_m_pre2 FROM l_sql
      DECLARE i002_m_ins CURSOR FOR i002_m_pre2

      FOREACH i002_m_ins INTO l_hrbn.hrbn01

         SELECT MAX(num)+1 INTO l_num FROM hrbn_tmp
          WHERE hrbn02=g_hrbn02 AND hrbn04=g_hrbn04 AND hrbn03=g_hrbn03
         IF cl_null(l_num) THEN
         	  LET l_num = 1
         END IF
         LET l_hrbn.hrbn02=g_hrbn02
         LET l_hrbn.hrbn03=g_hrbn03
         LET l_hrbn.hrbn04=g_hrbn04
         LET l_hrbn.hrbn05=g_hrbn05
         LET l_hrbn.hrbn06=''
         
         INSERT INTO hrbn_tmp(num,hrbn01,hrbn02,hrbn03,hrbn04,hrbn05,hrbn06)
                      VALUES (l_num,l_hrbn.hrbn01,l_hrbn.hrbn02,l_hrbn.hrbn03,l_hrbn.hrbn04,l_hrbn.hrbn05,l_hrbn.hrbn06)

      END FOREACH

      DROP TABLE hrat_tmp
     
      CALL i032_1_b_fill(" 1=1")
      CALL i032_1_b() 
END FUNCTION
