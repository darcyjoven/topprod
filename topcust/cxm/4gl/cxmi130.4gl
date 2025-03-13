# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi130.4gl
# Descriptions...: 員工資料
# Date & Author..: 161123  tianry

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_tc_obe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_obe01       LIKE tc_obe_file.tc_obe01, 
        ima02          LIKE ima_file.ima02,
        ima021         LIKE ima_file.ima021,
        tc_obe011      LIKE tc_obe_file.tc_obe011,
        tc_obe02       LIKE tc_obe_file.tc_obe02,  
        tc_obe021      LIKE tc_obe_file.tc_obe021,
        tc_obe03       LIKE tc_obe_file.tc_obe03, 
        tc_obe031      LIKE tc_obe_file.tc_obe031,
        tc_obe04       LIKE tc_obe_file.tc_obe04,
        tc_obe041      LIKE tc_obe_file.tc_obe041,   
        tc_obe05       LIKE tc_obe_file.tc_obe05,
        tc_obe06       LIKE tc_obe_file.tc_obe06,   
        tc_obe07       LIKE tc_obe_file.tc_obe07,
        tc_obe081      LIKE tc_obe_file.tc_obe081,
        tc_obe082      LIKE tc_obe_file.tc_obe082,
        tc_obe083      LIKE tc_obe_file.tc_obe083,
        tc_obe091      LIKE tc_obe_file.tc_obe091,
        tc_obe092      LIKE tc_obe_file.tc_obe092,
        tc_obe093      LIKE tc_obe_file.tc_obe093
                    END RECORD,
    g_tc_obe_t         RECORD                 #程式變數 (舊值)
        tc_obe01       LIKE tc_obe_file.tc_obe01,   
        ima02          LIKE ima_file.ima02,
        ima021         LIKE ima_file.ima021,
        tc_obe011      LIKE tc_obe_file.tc_obe011,
        tc_obe02       LIKE tc_obe_file.tc_obe02,   
        tc_obe021      LIKE tc_obe_file.tc_obe021,
        tc_obe03       LIKE tc_obe_file.tc_obe03,   
        tc_obe031      LIKE tc_obe_file.tc_obe031,
        tc_obe04       LIKE tc_obe_file.tc_obe04,
        tc_obe041      LIKE tc_obe_file.tc_obe041, 
        tc_obe05       LIKE tc_obe_file.tc_obe05,
        tc_obe06       LIKE tc_obe_file.tc_obe06,
        tc_obe07       LIKE tc_obe_file.tc_obe07,
        tc_obe081      LIKE tc_obe_file.tc_obe081,
        tc_obe082      LIKE tc_obe_file.tc_obe082,
        tc_obe083      LIKE tc_obe_file.tc_obe083,
        tc_obe091      LIKE tc_obe_file.tc_obe091,
        tc_obe092      LIKE tc_obe_file.tc_obe092,
        tc_obe093      LIKE tc_obe_file.tc_obe093
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
DEFINE g_argv1      LIKE tc_obe_file.tc_obe07       #FUN-A80148--add--

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               #FUN-A80148--add--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i130_w AT p_row,p_col WITH FORM "cxm/42f/cxmi130"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    LET g_wc2 = '1=1'
    CALL i130_b_fill(g_wc2)
    CALL i130_menu()
    CLOSE WINDOW i130_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i130_menu()
 
   WHILE TRUE
      CALL i130_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i130_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i130_b()
            ELSE
               LET g_action_choice = NULL
            END IF
  {       WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i130_out()
            END IF  }
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_tc_obe[l_ac].tc_obe01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_obe01"
                  LET g_doc.value1 = g_tc_obe[l_ac].tc_obe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_obe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i130_q()
   CALL i130_b_askkey()
END FUNCTION
 
FUNCTION i130_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    l_tc_obe07         LIKE tc_obe_file.tc_obe07,                 #MOD-B20155 ADD
    v               string,
    l_cnt           LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT tc_obe01,'','',tc_obe011,tc_obe02,tc_obe021,tc_obe03,tc_obe031,tc_obe04,tc_obe041,tc_obe05,tc_obe06,tc_obe07,tc_obe081,tc_obe082,tc_obe083,tc_obe091,tc_obe092,tc_obe093 ",
                       "  FROM tc_obe_file WHERE tc_obe01=? AND tc_obe011= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i130_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_tc_obe WITHOUT DEFAULTS FROM s_tc_obe.*
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
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           #CALL i130_set_entry(p_cmd)                                           
           #CALL i130_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_tc_obe_t.* = g_tc_obe[l_ac].*  #BACKUP
           OPEN i130_bcl USING g_tc_obe_t.tc_obe01,g_tc_obe_t.tc_obe011
           IF STATUS THEN
              CALL cl_err("OPEN i130_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i130_bcl INTO g_tc_obe[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_obe_t.tc_obe01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT ima02,ima021  INTO g_tc_obe[l_ac].ima02,g_tc_obe[l_ac].ima021 FROM ima_file
            WHERE g_tc_obe[l_ac].tc_obe01 = ima01
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         #CALL i130_set_entry(p_cmd)                                             
        # CALL i130_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_tc_obe[l_ac].* TO NULL      #900423
         IF NOT cl_null(g_argv1) THEN
            LET g_tc_obe[l_ac].tc_obe01 = g_argv1
            CALL cl_set_comp_entry("tc_obe01",FALSE)
         END IF
         LET g_tc_obe_t.* = g_tc_obe[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD tc_obe01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i130_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO tc_obe_file(tc_obe01,tc_obe011,tc_obe02,tc_obe021,tc_obe03,tc_obe031,tc_obe04,tc_obe041,tc_obe05,
                     tc_obe06,tc_obe07,tc_obe081,tc_obe082,tc_obe083,tc_obe091,tc_obe092,tc_obe093)
               VALUES(g_tc_obe[l_ac].tc_obe01,g_tc_obe[l_ac].tc_obe011,g_tc_obe[l_ac].tc_obe02,g_tc_obe[l_ac].tc_obe021,
               g_tc_obe[l_ac].tc_obe03,g_tc_obe[l_ac].tc_obe031,g_tc_obe[l_ac].tc_obe04,g_tc_obe[l_ac].tc_obe041,
               g_tc_obe[l_ac].tc_obe05,g_tc_obe[l_ac].tc_obe06,g_tc_obe[l_ac].tc_obe07,
               g_tc_obe[l_ac].tc_obe081,g_tc_obe[l_ac].tc_obe082,g_tc_obe[l_ac].tc_obe083,g_tc_obe[l_ac].tc_obe091,
               g_tc_obe[l_ac].tc_obe092,g_tc_obe[l_ac].tc_obe093)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","tc_obe_file",g_tc_obe[l_ac].tc_obe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE
           CALL cl_msg('INSERT O.K, INSERT MDM O.K')
           COMMIT WORK 
        END IF
 
     AFTER FIELD tc_obe01                        #check 編號是否重複
        IF NOT cl_null(g_tc_obe[l_ac].tc_obe01) THEN
           IF g_tc_obe[l_ac].tc_obe01 != g_tc_obe_t.tc_obe01 OR
              g_tc_obe_t.tc_obe01 IS NULL THEN
              SELECT count(*) INTO l_n FROM ima_file
               WHERE ima01 = g_tc_obe[l_ac].tc_obe01
              IF l_n = 0 THEN
                 CALL cl_err('','abm-202',1)
                 LET g_tc_obe[l_ac].tc_obe01 = g_tc_obe_t.tc_obe01
                 NEXT FIELD tc_obe01
              END IF
           END IF
           SELECT ima02,ima021,ima31,ima31,ima31 INTO g_tc_obe[l_ac].ima02,g_tc_obe[l_ac].ima021,g_tc_obe[l_ac].tc_obe021,
           g_tc_obe[l_ac].tc_obe031,g_tc_obe[l_ac].tc_obe041 FROM ima_file WHERE ima01=g_tc_obe[l_ac].tc_obe01
           DISPLAY BY NAME g_tc_obe[l_ac].ima02,g_tc_obe[l_ac].ima021,g_tc_obe[l_ac].tc_obe021,
           g_tc_obe[l_ac].tc_obe031,g_tc_obe[l_ac].tc_obe041
           SELECT COUNT(*) INTO l_cnt FROM tc_obe_file WHERE tc_obe01=g_tc_obe[l_ac].tc_obe01
           IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
           LET g_tc_obe[l_ac].tc_obe011=l_cnt+1 
           DISPLAY BY NAME g_tc_obe[l_ac].tc_obe011   #变更版次序号
        END IF
 
      AFTER FIELD tc_obe02 
        IF NOT cl_null(g_tc_obe[l_ac].tc_obe02) THEN
           IF g_tc_obe[l_ac].tc_obe02 <=0 THEN
              NEXT FIELD tc_obe02
           END IF 
        END IF
    
      AFTER FIELD tc_obe021
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe021) THEN
          CALL i130_unit(g_tc_obe[l_ac].tc_obe021)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_tc_obe[l_ac].tc_obe021,g_errno,1)  #MOD-640492 0->1
             LET g_tc_obe[l_ac].tc_obe021=g_tc_obe_t.tc_obe021
             DISPLAY BY NAME g_tc_obe[l_ac].tc_obe021
             NEXT FIELD tc_obe021
          END IF
       END IF

     AFTER FIELD tc_obe03
        IF NOT cl_null(g_tc_obe[l_ac].tc_obe03) THEN
           IF g_tc_obe[l_ac].tc_obe03<=0 THEN 
              NEXT FIELD tc_obe03
           END IF 
        END IF 

     AFTER FIELD tc_obe031
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe031) THEN
          CALL i130_unit(g_tc_obe[l_ac].tc_obe031)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_tc_obe[l_ac].tc_obe031,g_errno,1)  #MOD-640492 0->1
             LET g_tc_obe[l_ac].tc_obe031=g_tc_obe_t.tc_obe031
             DISPLAY BY NAME g_tc_obe[l_ac].tc_obe031
             NEXT FIELD tc_obe031
          END IF
       END IF 
     AFTER FIELD tc_obe04
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe04) THEN
          IF g_tc_obe[l_ac].tc_obe04<=0 THEN
             NEXT FIELD tc_obe04
          END IF
       END IF   

     AFTER FIELD tc_obe041
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe041) THEN
          CALL i130_unit(g_tc_obe[l_ac].tc_obe041)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_tc_obe[l_ac].tc_obe041,g_errno,1)  #MOD-640492 0->1
             LET g_tc_obe[l_ac].tc_obe041=g_tc_obe_t.tc_obe041
             DISPLAY BY NAME g_tc_obe[l_ac].tc_obe041
             NEXT FIELD tc_obe041
          END IF
       END IF  
     
     BEFORE FIELD tc_obe05
       LET g_tc_obe[l_ac].tc_obe05=1 
       DISPLAY BY NAME g_tc_obe[l_ac].tc_obe05

     AFTER FIELD tc_obe05
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe05) THEN
          IF g_tc_obe[l_ac].tc_obe05<=0 THEN
             NEXT FIELD tc_obe05
          END IF
       END IF

     AFTER FIELD tc_obe06
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe06) THEN
          IF g_tc_obe[l_ac].tc_obe06<=0 THEN
             NEXT FIELD tc_obe06
          END IF
       END IF
     AFTER FIELD tc_obe07
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe07) THEN
          IF g_tc_obe[l_ac].tc_obe07<=0 THEN
             NEXT FIELD tc_obe07
          END IF
       END IF

    AFTER FIELD tc_obe081
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe081) THEN
          IF g_tc_obe[l_ac].tc_obe081<=0 THEN
             NEXT FIELD tc_obe081
          END IF
       END IF

      AFTER FIELD tc_obe082
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe082) THEN
          IF g_tc_obe[l_ac].tc_obe082<=0 THEN
             NEXT FIELD tc_obe082
          END IF
       END IF 
      AFTER FIELD tc_obe083
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe083) THEN
          IF g_tc_obe[l_ac].tc_obe083<=0 THEN
             NEXT FIELD tc_obe083
          END IF
       END IF
  
      AFTER FIELD tc_obe091
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe091) THEN
          IF g_tc_obe[l_ac].tc_obe091<=0 THEN
             NEXT FIELD tc_obe091
          END IF
       END IF

      AFTER FIELD tc_obe092
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe092) THEN
          IF g_tc_obe[l_ac].tc_obe092<=0 THEN
             NEXT FIELD tc_obe092
          END IF
       END IF
      AFTER FIELD tc_obe093
       IF NOT cl_null(g_tc_obe[l_ac].tc_obe093) THEN
          IF g_tc_obe[l_ac].tc_obe093<=0 THEN
             NEXT FIELD tc_obe093
          END IF
       END IF 


     BEFORE DELETE                            #是否取消單身
         IF g_tc_obe_t.tc_obe01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "tc_obe01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_tc_obe[l_ac].tc_obe01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            DELETE FROM tc_obe_file WHERE tc_obe01 = g_tc_obe_t.tc_obe01 AND tc_obe011=g_tc_obe_t.tc_obe011 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_obe_file",g_tc_obe_t.tc_obe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      
                CANCEL DELETE
                EXIT INPUT
            END IF
 
 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_tc_obe[l_ac].* = g_tc_obe_t.*
          CLOSE i130_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_tc_obe[l_ac].tc_obe01,-263,0)
           LET g_tc_obe[l_ac].* = g_tc_obe_t.*
        ELSE
           UPDATE tc_obe_file SET 
                               tc_obe02=g_tc_obe[l_ac].tc_obe02,
                               tc_obe021=g_tc_obe[l_ac].tc_obe021,
                               tc_obe03=g_tc_obe[l_ac].tc_obe03,
                               tc_obe031=g_tc_obe[l_ac].tc_obe031,
                               tc_obe04=g_tc_obe[l_ac].tc_obe04,
                               tc_obe041=g_tc_obe[l_ac].tc_obe041,
                               tc_obe05=g_tc_obe[l_ac].tc_obe05,
                               tc_obe06=g_tc_obe[l_ac].tc_obe06,
                               tc_obe07=g_tc_obe[l_ac].tc_obe07,
                               tc_obe081=g_tc_obe[l_ac].tc_obe081,
                               tc_obe082=g_tc_obe[l_ac].tc_obe082,
                               tc_obe083=g_tc_obe[l_ac].tc_obe083,
                               tc_obe091=g_tc_obe[l_ac].tc_obe091,
                               tc_obe092=g_tc_obe[l_ac].tc_obe092,
                               tc_obe093=g_tc_obe[l_ac].tc_obe093
           WHERE tc_obe01 = g_tc_obe_t.tc_obe01 AND tc_obe011=g_tc_obe_t.tc_obe011
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_tc_obe[l_ac].tc_obe01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("upd","tc_obe_file",g_tc_obe_t.tc_obe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK    #FUN-680010
              LET g_tc_obe[l_ac].* = g_tc_obe_t.*
           ELSE
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
       #LET l_ac_t = l_ac                # 新增   #FUN-D40030 Mark
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_tc_obe[l_ac].* = g_tc_obe_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_tc_obe.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i130_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac                       #FUN-D40030 Add
         CLOSE i130_bcl                # 新增
         COMMIT WORK
 
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_obe01) AND l_ac > 1 THEN
             LET g_tc_obe[l_ac].* = g_tc_obe[l_ac-1].*
             NEXT FIELD tc_obe01
         END IF
 
       ON ACTION controlp
           CASE 
             WHEN INFIELD(tc_obe01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ima"
                     LET g_qryparam.default1 = g_tc_obe[l_ac].tc_obe01
                     CALL cl_create_qry() RETURNING g_tc_obe[l_ac].tc_obe01
                     DISPLAY g_tc_obe[l_ac].tc_obe01 TO tc_obe01
                     NEXT FIELD tc_obe01
             WHEN INFIELD(tc_obe021) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_tc_obe[l_ac].tc_obe021
                    CALL cl_create_qry() RETURNING g_tc_obe[l_ac].tc_obe021
                    DISPLAY g_tc_obe[l_ac].tc_obe021 TO tc_obe021
                    NEXT FIELD tc_obe021
              WHEN INFIELD(tc_obe031) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_tc_obe[l_ac].tc_obe031
                    CALL cl_create_qry() RETURNING g_tc_obe[l_ac].tc_obe031
                    DISPLAY g_tc_obe[l_ac].tc_obe031 TO tc_obe031
                    NEXT FIELD tc_obe031
             WHEN INFIELD(tc_obe041) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_tc_obe[l_ac].tc_obe041
                    CALL cl_create_qry() RETURNING g_tc_obe[l_ac].tc_obe041
                    DISPLAY g_tc_obe[l_ac].tc_obe041 TO tc_obe041
                    NEXT FIELD tc_obe041

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
 
    CLOSE i130_bcl
    COMMIT WORK
END FUNCTION

 
FUNCTION i130_b_askkey()
    CLEAR FORM
    CALL g_tc_obe.clear()
 
    CONSTRUCT g_wc2 ON tc_obe01,tc_obe011,tc_obe02,tc_obe021,tc_obe03,tc_obe031,tc_obe04,tc_obe041,tc_obe05,tc_obe06,tc_obe07,tc_obe081,tc_obe082,tc_obe083,tc_obe091,tc_obe092,tc_obe093 
         FROM s_tc_obe[1].tc_obe01,s_tc_obe[1].tc_obe011,s_tc_obe[1].tc_obe02,s_tc_obe[1].tc_obe021,s_tc_obe[1].tc_obe03,s_tc_obe[1].tc_obe031,
        s_tc_obe[1].tc_obe04,s_tc_obe[1].tc_obe041,s_tc_obe[1].tc_obe05,s_tc_obe[1].tc_obe06,s_tc_obe[1].tc_obe07,s_tc_obe[1].tc_obe081,s_tc_obe[1].tc_obe082,s_tc_obe[1].tc_obe083,s_tc_obe[1].tc_obe091,s_tc_obe[1].tc_obe092,s_tc_obe[1].tc_obe093
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(tc_obe021)
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_gfe"
         LET g_qryparam.state = 'c'
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO tc_obe021
          NEXT FIELD tc_obe021

         WHEN INFIELD(tc_obe031)
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_gfe"
         LET g_qryparam.state = 'c'
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO tc_obe031
          NEXT FIELD tc_obe031

        WHEN INFIELD(tc_obe041)
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_gfe"
         LET g_qryparam.state = 'c'
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO tc_obe041
         NEXT FIELD tc_obe041
       

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
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i130_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i130_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
   
    IF not cl_null(g_argv1) THEN
       LET g_sql = "SELECT tc_obe01,ima02,ima021,tc_obe011,tc_obe02,tc_obe021,tc_obe03,tc_obe031,tc_obe04,tc_obe041,tc_obe05,tc_obe06,tc_obe07,tc_obe081,tc_obe082,tc_obe083,tc_obe091,tc_obe092,tc_obe093  ",
                   " FROM tc_obe_file  ",
                   " LEFT JOIN ima_file ON tc_obe01=ima01  ",
                   " WHERE ", p_wc2 CLIPPED,    
                   " AND tc_obe01 ='",g_argv1,"' ",
                   " ORDER BY 1" 
    ELSE
       LET g_sql = " SELECT tc_obe01,ima02,ima021,tc_obe011,tc_obe02,tc_obe021,tc_obe03,tc_obe031,tc_obe04,tc_obe041,tc_obe05,tc_obe06,tc_obe07,tc_obe081,tc_obe082,tc_obe083,tc_obe091,tc_obe092,tc_obe093  ",
                   " FROM tc_obe_file  ",
                   " LEFT JOIN ima_file ON tc_obe01=ima01 ",
                   " WHERE  ", p_wc2 CLIPPED,           #單身
                   " ORDER BY 1" 
    END IF
 
 
    PREPARE i130_pb FROM g_sql
    DECLARE tc_obe_curs CURSOR FOR i130_pb
 
    CALL g_tc_obe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tc_obe_curs INTO g_tc_obe[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_tc_obe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_obe TO s_tc_obe.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
       ON ACTION related_document  #No.MOD-470515
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
 
{
FUNCTION i130_out()
    DEFINE
        l_tc_obe           RECORD LIKE tc_obe_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-680102 VARCHAR(40)
    IF g_wc2 IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'axmi130.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM tc_obe_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#No.FUN-760083 --BEGIN--
    PREPARE i130_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i130_co                         # SCROLL CURSOR
        CURSOR FOR i130_p1
 
    #CALL cl_outnam('axmi130') RETURNING l_name    
    #START REPORT i130_rep TO l_name               
 
    FOREACH i130_co INTO l_tc_obe.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        ELSE
          #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
          #   CALL cl_itemname_by_lang("tc_obe_file","tc_obe02",l_tc_obe.tc_obe01 CLIPPED,g_lang,l_tc_obe.tc_obe02) RETURNING l_tc_obe.tc_obe02
          #END IF
        END IF
        OUTPUT TO REPORT i130_rep(l_tc_obe.*)
    END FOREACH
 
    FINISH REPORT i130_rep
 
    CLOSE i130_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
        IF g_zz05='Y' THEN 
#          CALL cl_wcchp(g_wc2,'tc_obe01,tc_obe02,tc_obe03,tc_obe04,tc_obe05,tc_obe06,tc_obeacti,tc_obepos')   #FUN-A30030 ADD POS  #FUN-A80148--mark--
           CALL cl_wcchp(g_wc2,'tc_obe01,tc_obe02,tc_obe03,tc_obe04,tc_obe05,tc_obe06,tc_obe08,tc_obeacti,tc_obepos')   #FUN-A30030 ADD POS  #FUN-A80148--mod--
             RETURNING g_wc2  
        END IF
        LET g_str=g_wc2    
         CALL cl_prt_cs1("axmi130","axmi130",g_sql,g_str)   
#No.FUN-760083 --END--
 
END FUNCTION
 
 }
                                                                                

FUNCTION i130_unit(p_unit)  #單位
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti

    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
