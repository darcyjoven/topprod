# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cecp100.4gl
# Descriptions...: 
# Date & Author..: 17/09/15 By zyq

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_ecu DYNAMIC ARRAY OF RECORD    
                select      LIKE type_file.chr1,
                ecu01       LIKE ecu_file.ecu01,
                ima02       LIKE ima_file.ima02,  
                ima021      LIKE ima_file.ima021,
                ecu02       LIKE ecu_file.ecu02,
                ecu06       LIKE ecu_file.ecu06
            END RECORD,
     g_ecu_t RECORD     
                select      LIKE type_file.chr1,
                ecu01       LIKE ecu_file.ecu01,
                ima02       LIKE ima_file.ima02,  
                ima021      LIKE ima_file.ima021,
                ecu02       LIKE ecu_file.ecu02,
                ecu06       LIKE ecu_file.ecu06
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
DEFINE g_argv1      LIKE ecu_file.ecu01      #FUN-A80148--add--
DEFINE g_argv2      LIKE ecu_file.ecu02       #FUN-A80148--add--
DEFINE g_argv3      LIKE ecu_file.ecu06       #FUN-A80148--add--

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               #FUN-A80148--add--
   LET g_argv2 = ARG_VAL(2) 
   LET g_argv3 = ARG_VAL(3)

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
    OPEN WINDOW i100_w AT p_row,p_col WITH FORM "cec/42f/cecp100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
    LET g_wc2 = '1=1'
    #CALL i100_b_fill(g_wc2)
    CALL i100_menu()
    CLOSE WINDOW i100_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "pstopuse"
             IF cl_chk_act_auth() THEN
                CALL p100_pstopuse() 
             END IF 

         WHEN "punstopuse"
             IF cl_chk_act_auth() THEN 
                 CALL p100_punstopuse()
             END IF
         
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
            
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i100_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecu),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

#批量停用
FUNCTION p100_pstopuse()
   DEFINE l_k         LIKE type_file.num5
   DEFINE l_ecu06     LIKE ecu_file.ecu06 
FOR l_ac = 1 TO g_ecu.getLength()
   IF g_ecu[l_ac].select = 'Y' THEN
      BEGIN WORK 
      UPDATE ecu_file 
      SET ecu06 = 'Y'
      WHERE ecu01 = g_ecu[l_ac].ecu01
      AND   ecu02 = g_ecu[l_ac].ecu02
    IF SQLCA.sqlcode THEN
     CALL cl_err3("upd","ecu_file",g_ecu[l_ac].ecu01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
     LET g_ecu[l_ac].* = g_ecu_t.*
     ROLLBACK WORK
    ELSE
     COMMIT WORK
    END IF
    SELECT ecu06 INTO l_ecu06 FROM ecu_file 
              WHERE ecu01=g_ecu[l_ac].ecu01
              AND ecu02=g_ecu[l_ac].ecu02
          DISPLAY l_ecu06 TO FORMONLY.ecu06 
  END IF 
END FOR 
         CALL i100_b_fill(g_wc2)
END FUNCTION

#批量取消停用
FUNCTION p100_punstopuse()
    DEFINE l_ac         LIKE type_file.num5
    DEFINE l_ecu06_2     LIKE ecu_file.ecu06
FOR l_ac = 1 TO g_ecu.getLength()
   IF g_ecu[l_ac].select = 'Y' AND g_ecu[l_ac].ecu06 = 'Y' THEN
      BEGIN WORK 
      UPDATE ecu_file 
      SET ecu06 = 'N'
      WHERE ecu01 = g_ecu[l_ac].ecu01
      AND   ecu02 = g_ecu[l_ac].ecu02
    IF SQLCA.sqlcode THEN
     CALL cl_err3("upd","ecu_file",g_ecu[l_ac].ecu01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
     LET g_ecu[l_ac].* = g_ecu_t.*
     ROLLBACK WORK
    ELSE
     COMMIT WORK
    END IF
    SELECT ecu06 INTO l_ecu06_2 FROM ecu_file 
              WHERE ecu01=g_ecu[l_ac].ecu01
              AND ecu02=g_ecu[l_ac].ecu02
          DISPLAY l_ecu06_2 TO FORMONLY.ecu06 
  END IF 
END FOR 
        CALL i100_b_fill(g_wc2)
END FUNCTION
FUNCTION i100_q()
   CALL i100_b_askkey()
END FUNCTION
 
FUNCTION i100_b()
 DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    #l_tc_ecb06      LIKE tc_ecb_file.tc_ecb06,                 #MOD-B20155 ADD
    l_a             LIKE type_file.num5,
    v               STRING  
 DEFINE l_k         LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    IF g_action_choice = "detail" THEN
        CALL cl_set_comp_entry("ecu01,ecu02,ima02,ima021",FALSE)
    END IF 
    
    LET g_action_choice = ""
    
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ecu01,'','',ecu02,ecu06",
                       "FROM ecu_file ",
                       "WHERE ecu01= ? AND ecu02= ? AND ecu12 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ecu WITHOUT DEFAULTS FROM s_ecu.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
       
     BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()

         BEGIN WORK
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ecu_t.* = g_ecu[l_ac].*  #BACKUP
            CALL cl_show_fld_cont()     
         END IF
         
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ecu01) AND l_ac > 1 THEN
             LET g_ecu[l_ac].* = g_ecu[l_ac-1].*
             NEXT FIELD ecu01
         END IF
 
       ON ACTION controlp
           CASE 
             WHEN INFIELD(ecu01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ecu01"     
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecu01
               NEXT FIELD ecu01
            WHEN INFIELD(ima02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_imap02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima02
               NEXT FIELD ima02
            WHEN INFIELD(ima021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_ima021"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO ima021 
               NEXT FIELD ima021
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
       #全选
       ON ACTION select_all
           LET g_action_choice = "select_all" 
           FOR l_k = 1 TO g_ecu.getLength()
               LET g_ecu[l_k].select = "Y" 
           END FOR
       #全不选
        ON ACTION un_select_all
           LET g_action_choice = "un_select_all"
           FOR l_k = 1 TO g_ecu.getLength()
               LET g_ecu[l_k].select = "N" 
           END FOR
     
           
    END INPUT
     
    CLOSE i100_bcl
END FUNCTION

FUNCTION i100_b_askkey()
   
    CLEAR FORM
    CALL g_ecu.clear()
 
    CONSTRUCT g_wc2 ON ecu01,ima02,ima021,ecu02,ecu06          
         FROM s_ecu[1].ecu01,s_ecu[1].ima02,s_ecu[1].ima021,s_ecu[1].ecu02,s_ecu[1].ecu06                             

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(ecu01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ecu01"     
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ecu01
               NEXT FIELD ecu01
            WHEN INFIELD(ima02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_imap02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima02
               NEXT FIELD ima02
            WHEN INFIELD(ima021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "cq_ima021"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO ima021 
               NEXT FIELD ima021
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i100_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
   
    LET g_sql ="SELECT DISTINCT 'N',ecu01,ima02,ima021,ecu02,ecu06",
            "  FROM ecu_file LEFT JOIN ima_file ON ima01 = ecu01",
            " WHERE ",g_wc2,
            "   AND ecu01 = ima01 ",
            "  AND ",  p_wc2 CLIPPED
 
    PREPARE i100_pb FROM g_sql
    DECLARE ecu_curs CURSOR FOR i100_pb
 
    CALL g_ecu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ecu_curs INTO g_ecu[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_ecu.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecu TO s_ecu.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      #批量停用
      ON ACTION pstopuse
          LET g_action_choice = "pstopuse"
      EXIT DISPLAY 
      #批量取消
      ON ACTION punstopuse
          LET g_action_choice = "punstopuse"
      EXIT DISPLAY 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                        
FUNCTION i100_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("ecu01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i100_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("ecu01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
