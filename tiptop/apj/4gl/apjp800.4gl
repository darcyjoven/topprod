# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apjp800.4gl
# Descriptions...: WBS狀態修改批次作業
# Date & Author..: No.FUN-790025 08/02/26 By douzh
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm1        RECORD
                  pjk01    LIKE pjk_file.pjk01 
                  END RECORD
DEFINE g_pjk01    LIKE pjk_file.pjk01
DEFINE g_rec_b    LIKE type_file.num10
DEFINE g_rec_b1   LIKE type_file.num10
DEFINE g_rec_b2   LIKE type_file.num10
DEFINE g_pjk      DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  pjk02    LIKE pjk_file.pjk02,
                  pjk03    LIKE pjk_file.pjk03,
                  pjk11    LIKE pjk_file.pjk11,
                  pjk27_o  LIKE pjk_file.pjk27,
                  pjk27_n  LIKE pjk_file.pjk27 
                  END RECORD
DEFINE g_pjk_t    RECORD         #程式變數(Program Variables)
                  pjk02    LIKE pjk_file.pjk02,
                  pjk03    LIKE pjk_file.pjk03,
                  pjk11    LIKE pjk_file.pjk11,
                  pjk27_o  LIKE pjk_file.pjk27,
                  pjk27_n  LIKE pjk_file.pjk27 
                  END RECORD
DEFINE g_pjk_o    RECORD         #程式變數(Program Variables)
                  pjk02    LIKE pjk_file.pjk02,
                  pjk03    LIKE pjk_file.pjk03,
                  pjk11    LIKE pjk_file.pjk11,
                  pjk27_o  LIKE pjk_file.pjk27,
                  pjk27_n  LIKE pjk_file.pjk27 
                  END RECORD
DEFINE #g_sql      LIKE type_file.chr1000
       g_sql        STRING       #NO.FUN-910082
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
 
MAIN
  DEFINE p_row,p_col    LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_db_type=cl_db_get_database_type()
 
   OPEN WINDOW p800_w WITH FORM "apj/42f/apjp800"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL p800_tm()
   CALL p800_menu()
 
   CLOSE WINDOW p800_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p800_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL p800_bp("G")
      CASE g_action_choice
         WHEN "dantou"
            IF cl_chk_act_auth() THEN
               CALL p800_tm()
            END IF
 
         WHEN "pjk_detail"
            IF cl_chk_act_auth() THEN
               CALL p800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_pjk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p800_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    INITIALIZE tm1.* TO NULL            # Default condition
    LET tm1.pjk01=NULL
 
   #DISPLAY BY NAME tm1.*               #No.FUN-9A0024
    DISPLAY BY NAME tm1.pjk01           #No.FUN-9A0024
 
    INPUT BY NAME tm1.pjk01 WITHOUT DEFAULTS
 
       AFTER FIELD pjk01
          IF NOT cl_null(tm1.pjk01) THEN
             CALL p800_pjk01()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(tm1.pjk01,g_errno,0)
                NEXT FIELD pjk01
             END IF
          ELSE
             DISPLAY '' TO pjj02
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(pjk01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pjj3"
                CALL cl_create_qry() RETURNING tm1.pjk01
                DISPLAY BY NAME tm1.pjk01
                NEXT FIELD pjk01
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW p800_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
 
    CALL p800_b_fill()
    CALL p800_b()
 
END FUNCTION
 
FUNCTION p800_b_fill()
  DEFINE l_i         LIKE type_file.num10
 
    DECLARE sel_pjk_cur CURSOR FOR 
     SELECT pjk02,pjk03,pjk11,pjk27 
       FROM pjk_file
      WHERE pjk01 =tm1.pjk01
      ORDER BY pjk01
      
    CALL g_pjk.clear()
    LET l_i = 1
    FOREACH sel_pjk_cur INTO g_pjk[l_i].pjk02,g_pjk[l_i].pjk03,g_pjk[l_i].pjk11,g_pjk[l_i].pjk27_o   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_i = l_i + 1
        IF l_i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pjk.deleteElement(l_i)
    LET g_rec_b = l_i - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
 
FUNCTION p800_b()
DEFINE  l_n             LIKE type_file.num5
DEFINE  l_lock_sw       LIKE type_file.chr1                 #單身鎖住否 
DEFINE  p_cmd           LIKE type_file.chr1                 #處理狀態 
DEFINE  l_flag          LIKE type_file.chr1                 #檢查狀態 
  
    DISPLAY ARRAY g_pjk TO s_pjk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
    INPUT ARRAY g_pjk WITHOUT DEFAULTS FROM s_pjk.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
         #DISPLAY "BEFORE INPUT!"    #CHI-A70049 mark
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
         #DISPLAY "BEFORE ROW!"      #CHI-A70049 mark
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pjk_t.* = g_pjk[l_ac].*  #BACKUP
              LET g_pjk_o.* = g_pjk[l_ac].*  #BACKUP
              CALL cl_show_fld_cont()     
           END IF
 
        BEFORE INSERT
          #DISPLAY "BEFORE INSERT!"  #CHI-A70049 mark
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pjk[l_ac].* TO NULL      #900423
           LET g_pjk_t.* = g_pjk[l_ac].*         #新輸入資料
           LET g_pjk_o.* = g_pjk[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()         
           NEXT FIELD pjk02
 
        AFTER INSERT
          #DISPLAY "AFTER INSERT!"   #CHI-A70049 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
       AFTER FIELD pjk02
          IF NOT cl_null(g_pjk[l_ac].pjk02) THEN 
             SELECT count(*) INTO l_n FROM pjk_file 
              WHERE pjk01 = tm1.pjk01
                AND pjk02 = g_pjk[l_ac].pjk02
             IF l_n = 0 THEN
                CALL cl_err(g_pjk[l_ac].pjk02,'apj-060',1)
                LET g_pjk[l_ac].pjk02 = NULL
                NEXT FIELD pjk02
             END IF
          END IF
 
       AFTER FIELD pjk27_n
          IF NOT cl_null(g_pjk[l_ac].pjk27_n) THEN 
             IF g_pjk[l_ac].pjk27_n = '0' THEN
                CASE g_pjk[l_ac].pjk27_o
                  WHEN '1' 
                     CALL s_wbs_frontchk(g_pjk[l_ac].pjk02,'g_pjk[l_ac].pjk11','2') RETURNING l_flag
                  WHEN '2'
                     CALL s_wbs_frontchk(g_pjk[l_ac].pjk02,'g_pjk[l_ac].pjk11','2') RETURNING l_flag
                  WHEN '3'
                     CALL s_wbs_frontchk(g_pjk[l_ac].pjk02,'g_pjk[l_ac].pjk11','2') RETURNING l_flag
                  WHEN '4'
                     CALL s_wbs_frontchk(g_pjk[l_ac].pjk02,'g_pjk[l_ac].pjk11','2') RETURNING l_flag
                  OTHERWISE EXIT CASE
               END CASE
               IF l_flag ='1' THEN
                  CALL cl_err(g_pjk[l_ac].pjk02,'apj-065',1)
                  LET g_pjk[l_ac].pjk27_n = g_pjk[l_ac].pjk27_o
                  NEXT FIELD pjk27_n
               END IF
             END IF
          END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pjk[l_ac].* = g_pjk_t.*
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjk[l_ac].pjk02,-263,1)
              LET g_pjk[l_ac].* = g_pjk_t.*
           ELSE
              UPDATE pjk_file SET pjk27=g_pjk[l_ac].pjk27_n 
               WHERE pjk01=tm1.pjk01
                 AND pjk02=g_pjk_t.pjk02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","pjk_file",tm1.pjk01,g_pjk_t.pjk02,SQLCA.sqlcode,"","",1)
                 LET g_pjk[l_ac].* = g_pjk_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(pjk02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pjk"
                CALL cl_create_qry() RETURNING  g_pjk[l_ac].pjk02
                DISPLAY BY NAME g_pjk[l_ac].pjk02
                NEXT FIELD pjk02
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg  
          CALL cl_cmdask() 
 
    END INPUT
 
    LET g_action_choice=''
    IF INT_FLAG THEN
       LET INT_FLAG=0
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p800_pjk01()
    DEFINE l_pjj02   LIKE pjj_file.pjj02
    DEFINE l_pjjacti LIKE pjj_file.pjjacti
 
    LET g_errno = ' '
    SELECT pjj02,pjjacti INTO l_pjj02,l_pjjacti
      FROM pjj_file WHERE pjj01=tm1.pjk01
    CASE
        WHEN l_pjjacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       LET l_pjj02 = NULL
    END IF
    DISPLAY l_pjj02 TO FORMONLY.pjj02
END FUNCTION
 
FUNCTION p800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjk TO s_pjk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL cl_show_fld_cont()
 
      ON ACTION dantou
         LET g_action_choice="dantou"
         EXIT DISPLAY
 
      ON ACTION pjk_detail
         LET g_action_choice="pjk_detail"
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="pjk_detail"
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
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-790025
