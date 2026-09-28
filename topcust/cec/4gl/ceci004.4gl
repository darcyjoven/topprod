# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: ceci004.4gl
# Descriptions...: 
# Date & Author..: 16/05/09 By guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_tc_ecb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_ecb06       LIKE tc_ecb_file.tc_ecb06,
        tc_ecb01       LIKE tc_ecb_file.tc_ecb01,   
        tc_ecb02       LIKE tc_ecb_file.tc_ecb02,   
        tc_ecb03       LIKE tc_ecb_file.tc_ecb03,  
        tc_ecb04       LIKE tc_ecb_file.tc_ecb04,   
        ima02          LIKE ima_file.ima02,
        ima021         LIKE ima_file.ima021,
        tc_ecb05       LIKE tc_ecb_file.tc_ecb05
                    END RECORD,
    g_tc_ecb_t         RECORD                 #程式變數 (舊值)
        tc_ecb06       LIKE tc_ecb_file.tc_ecb06,
        tc_ecb01       LIKE tc_ecb_file.tc_ecb01,   
        tc_ecb02       LIKE tc_ecb_file.tc_ecb02,   
        tc_ecb03       LIKE tc_ecb_file.tc_ecb03,  
        tc_ecb04       LIKE tc_ecb_file.tc_ecb04,
        ima02          LIKE ima_file.ima02,
        ima021         LIKE ima_file.ima021,   
        tc_ecb05       LIKE tc_ecb_file.tc_ecb05
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5      #No.FUN-680102 SMALLINT   #FUN-550077
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_str        STRING                    #No.FUN-760083     
DEFINE g_argv1      LIKE tc_ecb_file.tc_ecb01       #FUN-A80148--add--
DEFINE g_argv2      LIKE tc_ecb_file.tc_ecb02       #FUN-A80148--add--
DEFINE g_argv3      LIKE tc_ecb_file.tc_ecb03       #FUN-A80148--add--
DEFINE g_argv4      LIKE tc_ecb_file.tc_ecb04       #FUN-A80148--add--
DEFINE g_argv5      LIKE tc_ecb_file.tc_ecb03       #FUN-A80148--add--

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               #FUN-A80148--add--
   LET g_argv2 = ARG_VAL(2) 
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4) 
   LET g_argv5 = ARG_VAL(5) 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i004_w AT p_row,p_col WITH FORM "cec/42f/ceci004"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
    LET g_wc2 = '1=1'
    CALL i004_b_fill(g_wc2)
    CALL i004_menu()
    CLOSE WINDOW i004_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i004_menu()
 
   WHILE TRUE
      CALL i004_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i004_b()
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
               IF g_tc_ecb[l_ac].tc_ecb01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_ecb01"
                  LET g_doc.value1 = g_tc_ecb[l_ac].tc_ecb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ecb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i004_q()
   CALL i004_b_askkey()
END FUNCTION
 
FUNCTION i004_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    l_tc_ecb06      LIKE tc_ecb_file.tc_ecb06,                 #MOD-B20155 ADD
    l_a             LIKE type_file.num5,
    v               STRING  
DEFINE l_tc_ecb05_a  LIKE tc_ecb_file.tc_ecb05
DEFINE l_tc_ecb05_b  LIKE tc_ecb_file.tc_ecb05
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT tc_ecb06,tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb04,'','',tc_ecb05", 
                       "  FROM tc_ecb_file WHERE tc_ecb01=? AND tc_ecb02 =? AND tc_ecb03 =? AND tc_ecb06=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_tc_ecb WITHOUT DEFAULTS FROM s_tc_ecb.*
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
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'                                                         
           LET g_before_input_done = FALSE                                      
           CALL i004_set_entry(p_cmd)                                           
           CALL i004_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                                  
           LET g_tc_ecb_t.* = g_tc_ecb[l_ac].*  #BACKUP
           OPEN i004_bcl USING g_tc_ecb_t.tc_ecb01,g_tc_ecb_t.tc_ecb02,g_tc_ecb_t.tc_ecb03,g_tc_ecb_t.tc_ecb06
           IF STATUS THEN
              CALL cl_err("OPEN i004_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i004_bcl INTO g_tc_ecb[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_ecb_t.tc_ecb01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT ima02,ima021  INTO g_tc_ecb[l_ac].ima02,g_tc_ecb[l_ac].ima021 FROM ima_file
            WHERE g_tc_ecb[l_ac].tc_ecb04 = ima01
            IF NOT cl_null(g_argv1) THEN
               CALL cl_set_comp_entry("tc_ecb01,tc_ecb02,tc_ecb03",FALSE)
            END IF
           CALL cl_show_fld_cont()  
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'                                                        
         LET g_before_input_done = FALSE                                        
         CALL i004_set_entry(p_cmd)                                             
         CALL i004_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_tc_ecb[l_ac].* TO NULL      
         LET g_tc_ecb[l_ac].tc_ecb01 =g_argv1 
         LET g_tc_ecb[l_ac].tc_ecb02 =g_argv4
         LET g_tc_ecb[l_ac].tc_ecb03 =g_argv5
         IF NOT cl_null(g_argv1) THEN
            CALL cl_set_comp_entry("tc_ecb01,tc_ecb02,tc_ecb03",FALSE)
         END IF
         LET g_tc_ecb_t.* = g_tc_ecb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()   
         NEXT FIELD tc_ecb04
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i004_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO tc_ecb_file(tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb04,tc_ecb05,tc_ecb06)           
               VALUES(g_tc_ecb[l_ac].tc_ecb01,g_tc_ecb[l_ac].tc_ecb02,
               g_tc_ecb[l_ac].tc_ecb03,g_tc_ecb[l_ac].tc_ecb04,g_tc_ecb[l_ac].tc_ecb05,
               g_tc_ecb[l_ac].tc_ecb06) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","tc_ecb_file",g_tc_ecb[l_ac].tc_ecb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK             
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'  
           COMMIT WORK
           LET g_rec_b=g_rec_b+1 
           DISPLAY g_rec_b TO FORMONLY.cn2  
        END IF
 
     AFTER FIELD tc_ecb04
       IF NOT cl_null(g_tc_ecb[l_ac].tc_ecb04) THEN
          SELECT COUNT(*) INTO l_a FROM tc_eca_file 
           WHERE tc_eca01 = g_argv2
             AND tc_eca04 = g_argv3
             AND tc_eca05 = g_tc_ecb[l_ac].tc_ecb04
          IF cl_null(l_a) OR l_a = 0 THEN 
             CALL cl_err('','cec-009',0)
             NEXT FIELD tc_ecb04
          END IF 
          IF p_cmd='a' THEN 
             SELECT MAX(tc_ecb06) INTO l_tc_ecb06 
               FROM tc_ecb_file 
              WHERE tc_ecb02 = g_tc_ecb[l_ac].tc_ecb02
                AND tc_ecb03 = g_tc_ecb[l_ac].tc_ecb03
                AND tc_ecb01 = g_tc_ecb[l_ac].tc_ecb01
             IF cl_null(l_tc_ecb06) THEN 
                LET g_tc_ecb[l_ac].tc_ecb06 = 1
             ELSE  
                LET g_tc_ecb[l_ac].tc_ecb06 = 1+l_tc_ecb06
             END IF 
             DISPLAY BY NAME g_tc_ecb[l_ac].tc_ecb06
          END IF 
          CALL i004_tc_ecb04('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) NEXT FIELD tc_ecb04
          END IF
       END IF 

     AFTER FIELD tc_ecb05
        IF NOT cl_null(g_tc_ecb[l_ac].tc_ecb05) THEN 
           IF g_argv1 = '2' THEN
              LET l_tc_ecb05_a = 0
              LET l_tc_ecb05_b = 0
              SELECT SUM(tc_ecb05) INTO l_tc_ecb05_a FROM tc_ecb_file,rvb_file 
               WHERE  tc_ecb02 = rvb04 
                 AND  tc_ecb03 = rvb03
                 AND rvb01 = g_tc_ecb[l_ac].tc_ecb02 
                 AND rvb02 = g_tc_ecb[l_ac].tc_ecb03
              SELECT SUM(tc_ecb05) INTO l_tc_ecb05_b FROM tc_ecb_file
               WHERE tc_ecb02 = g_tc_ecb[l_ac].tc_ecb02 
                 AND tc_ecb03 = g_tc_ecb[l_ac].tc_ecb03
              IF cl_null(l_tc_ecb05_a) THEN  LET l_tc_ecb05_a = 0 END IF   
              IF cl_null(l_tc_ecb05_b) THEN  LET l_tc_ecb05_b = 0 END IF 
              IF g_tc_ecb[l_ac].tc_ecb05 >(l_tc_ecb05_a-l_tc_ecb05_b) THEN 
                 CALL cl_err('','cec-010',0)
                 NEXT FIELD tc_ecb05
              END IF 
           END IF 
        END IF 

 
     BEFORE DELETE                            #是否取消單身
         IF g_tc_ecb_t.tc_ecb01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
           #FUN-A30030 END--------------------
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "tc_ecb01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_tc_ecb[l_ac].tc_ecb01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            #TQC-6B0103---start---
            IF (NOT cl_del_itemname("tc_ecb_file","tc_ecb02", g_tc_ecb_t.tc_ecb01)) THEN 
               ROLLBACK WORK
               RETURN
            END IF
            DELETE FROM tc_ecb_file WHERE tc_ecb01 = g_tc_ecb_t.tc_ecb01 AND tc_ecb02 = g_tc_ecb_t.tc_ecb02
                                      AND tc_ecb03 = g_tc_ecb_t.tc_ecb03 AND tc_ecb04 = g_tc_ecb_t.tc_ecb04
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_ecb_file",g_tc_ecb_t.tc_ecb01,"",SQLCA.sqlcode,"","",1)  
                ROLLBACK WORK      #FUN-680010
                CANCEL DELETE
                EXIT INPUT
            END IF

            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_tc_ecb[l_ac].* = g_tc_ecb_t.*
          CLOSE i004_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_tc_ecb[l_ac].tc_ecb01,-263,0)
           LET g_tc_ecb[l_ac].* = g_tc_ecb_t.*
        ELSE
           UPDATE tc_ecb_file SET tc_ecb01=g_tc_ecb[l_ac].tc_ecb01,
                                  tc_ecb02=g_tc_ecb[l_ac].tc_ecb02,
                                  tc_ecb03=g_tc_ecb[l_ac].tc_ecb03,
                                  tc_ecb04=g_tc_ecb[l_ac].tc_ecb04,
                                  tc_ecb05=g_tc_ecb[l_ac].tc_ecb05,
                                  tc_ecb06=g_tc_ecb[l_ac].tc_ecb06
           WHERE tc_ecb01 = g_tc_ecb_t.tc_ecb01
             AND tc_ecb02 = g_tc_ecb_t.tc_ecb02
             AND tc_ecb03 = g_tc_ecb_t.tc_ecb03
             AND tc_ecb06 = g_tc_ecb_t.tc_ecb06
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","tc_ecb_file",g_tc_ecb_t.tc_ecb01,"",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK  
              LET g_tc_ecb[l_ac].* = g_tc_ecb_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_tc_ecb[l_ac].* = g_tc_ecb_t.*
           ELSE
              CALL g_tc_ecb.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           END IF
           CLOSE i004_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac                       #FUN-D40030 Add
         CLOSE i004_bcl                # 新增
         COMMIT WORK

 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_ecb01) AND l_ac > 1 THEN
             LET g_tc_ecb[l_ac].* = g_tc_ecb[l_ac-1].*
             NEXT FIELD tc_ecb01
         END IF
 
       ON ACTION controlp
           CASE 
             WHEN INFIELD(tc_ecb04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "cq_tc_eca"
                     LET g_qryparam.default1 = g_tc_ecb[l_ac].tc_ecb04
                     LET g_qryparam.arg1=g_argv2
                     LET g_qryparam.arg2=g_argv3
                     CALL cl_create_qry() RETURNING g_tc_ecb[l_ac].tc_ecb04
                     DISPLAY g_tc_ecb[l_ac].tc_ecb04 TO tc_ecb04
                     CALL FGL_DIALOG_SETBUFFER(g_tc_ecb[l_ac].tc_ecb04 )
                     CALL i004_tc_ecb04('a')
                OTHERWISE
                     EXIT CASE
            END CASE
 
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
 
    CLOSE i004_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i004_tc_ecb04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(1)
    l_gemacti       LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT ima02,ima021 INTO g_tc_ecb[l_ac].ima02,g_tc_ecb[l_ac].ima021
        FROM ima_file 
        WHERE ima01  = g_tc_ecb[l_ac].tc_ecb04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'cec-005'
                                   LET g_tc_ecb[l_ac].ima02 = NULL
                                   LET g_tc_ecb[l_ac].ima021 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i004_b_askkey()
    CLEAR FORM
    CALL g_tc_ecb.clear()
 
    CONSTRUCT g_wc2 ON tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb04,tc_ecb05,tc_ecb06           
         FROM s_tc_ecb[1].tc_ecb01,s_tc_ecb[1].tc_ecb02,s_tc_ecb[1].tc_ecb03,                              
              s_tc_ecb[1].tc_ecb04,s_tc_ecb[1].tc_ecb05,s_tc_ecb[1].tc_ecb06

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(tc_ecb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "cq_tc_eca"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.arg1=g_argv2
                   LET g_qryparam.arg2=g_argv3
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_tc_ecb[1].tc_ecb04
                   CALL i004_tc_ecb04('a')
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('tc_ecauser', 'tc_ecagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
    CALL i004_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i004_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
   
    IF not cl_null(g_argv1) THEN
       LET g_sql = "SELECT tc_ecb06,tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb04,ima02,ima021,tc_ecb05",
                   "  FROM tc_ecb_file LEFT JOIN ima_file ON ima01 = tc_ecb04",
                   " WHERE ", p_wc2 CLIPPED, 
                   "   AND tc_ecb02 = '",g_argv4,"'",
                   "   AND tc_ecb03 = '",g_argv5,"'",
                   " ORDER BY tc_ecb06"
    ELSE
       LET g_sql = "SELECT tc_ecb06,tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb04,ima02,ima021,tc_ecb05",
                   "  FROM tc_ecb_file LEFT JOIN ima_file ON ima01 = tc_ecb04",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY tc_ecb06"
    END IF
 
    PREPARE i004_pb FROM g_sql
    DECLARE tc_ecb_curs CURSOR FOR i004_pb
 
    CALL g_tc_ecb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tc_ecb_curs INTO g_tc_ecb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_ecb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ecb TO s_tc_ecb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION                                                        
FUNCTION i004_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("tc_ecb06",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i004_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("tc_ecb06",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
