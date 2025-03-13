# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aemi105.4gl
# Descriptions...: 儀表基本資料維護作業
# Date & Author..: 04/07/07 By Carrier
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.MOD-540141 05/04/20 By vivien  刪除HELP FILE 
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760085 07/07/04 By sherry 報表改寫由Crystal Report產出
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910088 11/12/27 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fif           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        fif01       LIKE fif_file.fif01,
        fif02       LIKE fif_file.fif02,
        fif03       LIKE fif_file.fif03,
        fif04       LIKE fif_file.fif04,
        fif05       LIKE fif_file.fif05,
        fif06       LIKE fif_file.fif06,
        fif07       LIKE fif_file.fif07,
        fif08       LIKE fif_file.fif08,
        fif09       LIKE fif_file.fif09
                    END RECORD,
    g_fif_t         RECORD                 #程式變數 (舊值)
        fif01       LIKE fif_file.fif01,
        fif02       LIKE fif_file.fif02,
        fif03       LIKE fif_file.fif03,
        fif04       LIKE fif_file.fif04,
        fif05       LIKE fif_file.fif05,
        fif06       LIKE fif_file.fif06,
        fif07       LIKE fif_file.fif07,
        fif08       LIKE fif_file.fif08,
        fif09       LIKE fif_file.fif09
                    END RECORD,
    g_wc2,g_sql     STRING,        #No.FUN-580092 HCN     
    g_rec_b         LIKE type_file.num5,          #單身筆數                   #No.FUN-680072 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
#FUN-760085--start                                                              
   DEFINE  l_table    STRING                                                    
   DEFINE  g_str      STRING                                                    
#FUN-760085--end    
DEFINE   p_row,p_col     LIKE type_file.num5      #No.FUN-680072 SMALLINT
DEFINE   g_forupd_sql    STRING    #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680072 INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           STRING                 
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680072 SMALLINT
DEFINE   g_fif04_t       LIKE  fif_file.fif04     #FUN-910088 add
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
          RETURNING g_time    #No.FUN-6A0068
  #No.FUN-760085---Begin
    LET g_sql = "fif01.fif_file.fif01,",
                "fif02.fif_file.fif02,",
                "fif03.fif_file.fif03,",
                "fif04.fif_file.fif04,",
                "fif05.fif_file.fif05,",
                "fif06.fif_file.fif06,",
                "l_a1.type_file.chr20,",
                "fif07.fif_file.fif07,",
                "l_b1.type_file.chr20,",
                "fif08.fif_file.fif08,",
                "fif09.fif_file.fif09"
  
    LET l_table = cl_prt_temptable('aemi105',g_sql) CLIPPED                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                                     
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
                " VALUES(?,?,?,?,?,?,?,?,?,?,?) "                      
    PREPARE insert_prep FROM g_sql                                               
    IF STATUS THEN                                                               
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
    END IF                    
  #No.FUN-760085---End
    LET p_row = 3 LET p_col = 3
 
    OPEN WINDOW i105_w AT p_row,p_col WITH FORM "aem/42f/aemi105"
        ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL g_x.clear()
 
    LET g_wc2 = '1=1' CALL i105_b_fill(g_wc2)
    CALL i105_menu()
    CLOSE WINDOW i105_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
FUNCTION i105_menu()
   WHILE TRUE
      CALL i105_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i105_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN
                  CALL g_fif.deleteElement(1)
               END IF
               CALL i105_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i105_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i105_q()
   CALL i105_b_askkey()
END FUNCTION
 
FUNCTION i105_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                                          #No.FUN-680072 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                                           #No.FUN-680072 VARCHAR(1)
   
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT fif01,fif02,fif03,fif04,fif05,",
                       "       fif06,fif07,fif08,fif09",
                       "  FROM fif_file WHERE fif01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i105_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t=0
    INPUT ARRAY g_fif WITHOUT DEFAULTS FROM s_fif.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW = l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_fif_t.* = g_fif[l_ac].*  #BACKUP
               LET g_fif04_t = g_fif[l_ac].fif04    #FUN-910088--add--
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i105_set_entry_b(p_cmd)                                                                                         
               CALL i105_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--  
               OPEN i105_bcl USING g_fif_t.fif01       #表示更改狀態
               IF STATUS THEN
                  CALL cl_err("OPEN i105_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i105_bcl INTO g_fif[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fif_t.fif01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i105_set_entry_b(p_cmd)                                                                                         
            CALL i105_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--  
            INITIALIZE g_fif[l_ac].* TO NULL      #900423
            LET g_fif_t.* = g_fif[l_ac].*         #新輸入資料
            LET g_fif[l_ac].fif06 = '1'
            LET g_fif[l_ac].fif07 = '1'
            LET g_fif04_t = NULL          #FUN-910088--add--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fif01
 
        AFTER INSERT
            DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fif_file(fif01,fif02,fif03,fif04,fif05,
                                 fif06,fif07,fif08,fif09)
                          VALUES(g_fif[l_ac].fif01,g_fif[l_ac].fif02,
                                 g_fif[l_ac].fif03,g_fif[l_ac].fif04,
                                 g_fif[l_ac].fif05,g_fif[l_ac].fif06,
                                 g_fif[l_ac].fif07,g_fif[l_ac].fif08,
                                 g_fif[l_ac].fif09)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fif[l_ac].fif01,SQLCA.sqlcode,0)   #No.FUN-660092
               CALL cl_err3("ins","fif_file",g_fif[l_ac].fif01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
 
        AFTER FIELD fif01                        #check 編號是否重複
            IF NOT cl_null(g_fif[l_ac].fif01) THEN
               IF g_fif[l_ac].fif01 != g_fif_t.fif01
               OR cl_null(g_fif_t.fif01) THEN
                  SELECT COUNT(*) INTO l_n FROM fif_file
                   WHERE fif01 = g_fif[l_ac].fif01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fif[l_ac].fif01 = g_fif_t.fif01
                     NEXT FIELD fif01
                  END IF
               END IF
            END IF
 
        AFTER FIELD fif04
            IF NOT cl_null(g_fif[l_ac].fif04) THEN
               SELECT gfe01 FROM gfe_file WHERE  gfe01= g_fif[l_ac].fif04
               IF STATUS THEN
#                 CALL cl_err(g_fif[l_ac].fif04,STATUS ,0)   #No.FUN-660092
                  CALL cl_err3("sel","gfe_file",g_fif[l_ac].fif04,"",STATUS,"","",1)  #No.FUN-660092
                  LET g_fif[l_ac].fif04 = g_fif_t.fif04
                  NEXT FIELD fif04
               END IF
          #FUN-910088--add--start--
               IF NOT i105_fif09_check() THEN
                  LET g_fif04_t = g_fif[l_ac].fif04
                  NEXT FIELD fif09
               END IF
               LET g_fif04_t = g_fif[l_ac].fif04
          #FUN-910088--add--end--
            END IF
 
        AFTER FIELD fif05
            IF g_fif[l_ac].fif05 <0 THEN
               NEXT FIELD fif05
            END IF
 
        AFTER FIELD fif08
            IF g_fif[l_ac].fif08 <0 THEN
               NEXT FIELD fif08
            END IF
 
        AFTER FIELD fif09
           IF NOT i105_fif09_check() THEN NEXT FIELD fif09 END IF    #FUN-910088--add--
         #FUN-910088--mark-start--
         #  IF g_fif[l_ac].fif09 <0 THEN
         #     NEXT FIELD fif09
         #  END IF
         #FUN-910088--mark--end--
 
        BEFORE DELETE                            #是否取消單身
            IF g_fif_t.fif01 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM fif_file WHERE fif01 = g_fif_t.fif01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fif_t.fif01,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("del","fif_file",g_fif_t.fif01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               MESSAGE "Delete Ok"
               CLOSE i105_bcl
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fif[l_ac].* = g_fif_t.*
               CLOSE i105_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_fif[l_ac].fif01,-263,0)
               LET g_fif[l_ac].* = g_fif_t.*
            ELSE
               UPDATE fif_file
                  SET fif01=g_fif[l_ac].fif01,fif02=g_fif[l_ac].fif02,
                      fif03=g_fif[l_ac].fif03,fif04=g_fif[l_ac].fif04,
                      fif05=g_fif[l_ac].fif05,fif06=g_fif[l_ac].fif06,
                      fif07=g_fif[l_ac].fif07,fif08=g_fif[l_ac].fif08,
                      fif09=g_fif[l_ac].fif09
                WHERE fif01 = g_fif_t.fif01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fif[l_ac].fif01,SQLCA.sqlcode,1)   #No.FUN-660092
                  CALL cl_err3("upd","fif_file",g_fif_t.fif01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fif[l_ac].* = g_fif_t.*
                  CLOSE i105_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i105_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()         # 新增
            #LET l_ac_t = l_ac            # 新增  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fif[l_ac].* = g_fif_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fif.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i105_bcl            # 新增
               ROLLBACK WORK         # 新增
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i105_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO
            IF INFIELD(fif01) AND l_ac > 1 THEN
                LET g_fif[l_ac].* = g_fif[l_ac-1].*
                NEXT FIELD fif01
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fif04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_fif[l_ac].fif04
                  CALL FGL_DIALOG_SETBUFFER( g_fif[l_ac].fif04 )
                  CALL cl_create_qry() RETURNING g_fif[l_ac].fif04
                  NEXT FIELD fif04
           END CASE
        
           
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913       
 #No.MOD-540141--end  
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
    END INPUT
 
    CLOSE i105_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i105_fif06(l_fif06)
    DEFINE l_fif06 LIKE fif_file.fif06
 
    CASE l_fif06
        WHEN '1' LET g_msg= cl_getmsg('aem-001',g_lang)
        WHEN '2' LET g_msg= cl_getmsg('aem-002',g_lang)
    END CASE
    RETURN g_msg
END FUNCTION
 
FUNCTION i105_fif07(l_fif07)
    DEFINE l_fif07 LIKE fif_file.fif07
 
    CASE l_fif07
        WHEN '1' LET g_msg= cl_getmsg('aem-003',g_lang)
        WHEN '2' LET g_msg= cl_getmsg('aem-004',g_lang)
    END CASE
    RETURN g_msg
END FUNCTION
 
FUNCTION i105_b_askkey()
    CLEAR FORM
    CALL g_fif.clear()
    CONSTRUCT g_wc2 ON fif01,fif02,fif03,fif04,fif05,
                       fif06,fif07,fif08,fif09
            FROM s_fif[1].fif01,s_fif[1].fif02,s_fif[1].fif03,
                 s_fif[1].fif04,s_fif[1].fif05,s_fif[1].fif06,
                 s_fif[1].fif07,s_fif[1].fif08,s_fif[1].fif09
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fif04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_fif[1].fif04
                  NEXT FIELD fif04
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i105_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i105_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql =
        "SELECT fif01,fif02,fif03,fif04,fif05,",
        "       fif06,fif07,fif08,fif09",
        "  FROM fif_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY fif01"
    PREPARE i105_pb FROM g_sql
    DECLARE fif_curs CURSOR FOR i105_pb
 
    CALL g_fif.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH fif_curs INTO g_fif[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fif.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i105_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fif TO s_fif.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i105_out()
    DEFINE
        l_fif           RECORD LIKE fif_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680072 VARCHAR(20)
        l_za05          LIKE type_file.chr1000   #No.FUN-680072 VARCHAR(40)
   #No.FUN-760085---Begin
    DEFINE   
             #l_sql      LIKE type_file.chr1000 
             l_sql       STRING      #NO.FUN-910082      
    DEFINE   l_a1       LIKE type_file.chr20 
    DEFINE   l_b1       LIKE type_file.chr20             
   #No.FUN-760085---End
    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('aemi105') RETURNING l_name    #No.FUN-760085
    CALL cl_del_data(l_table)                     #No.FUN-760085     
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM fif_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i105_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i105_co                         # CURSOR
     CURSOR FOR i105_p1
 
#   START REPORT i105_rep TO l_name                #No.FUN-760085
 
    FOREACH i105_co INTO l_fif.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
#No.FUN-760085---Begin
        CALL i105_fif06(l_fif.fif06) RETURNING l_a1
        CALL i105_fif07(l_fif.fif07) RETURNING l_b1
#       OUTPUT TO REPORT i105_rep(l_fif.*)
        EXECUTE insert_prep USING l_fif.fif01,l_fif.fif02,l_fif.fif03,
                                  l_fif.fif04,l_fif.fif05,l_fif.fif06,
                                  l_a1,l_fif.fif07,l_b1,l_fif.fif08,
                                  l_fif.fif09           
#No.FUN-760085---End
    END FOREACH
#No.FUN-760085---Begin  
#   FINISH REPORT i105_rep                
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc2,'fif01,fif02,fif03,fif04,fif05,fif06,fif07,fif08,fif09')         
            RETURNING g_wc2                                                     
       LET g_str = g_wc2                                                        
    END IF
    LET g_str = g_wc2                                                        
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  
#No.FUN-760085---End  
    CLOSE i105_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)               #No.FUN-760085   
    CALL cl_prt_cs3('aemi105','aemi105',l_sql,g_str)   #No.FUN-760085
END FUNCTION
 
#No.FUN-760085---Begin
{REPORT i105_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680072CHAR(1)
        l_a1            LIKE type_file.chr20,     #No.FUN-680072CHAR(20)
        l_b1            LIKE type_file.chr20,     #No.FUN-680072CHAR(20)
        sr RECORD LIKE fif_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fif01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED             
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<', "/pageno"                    
            PRINT g_head CLIPPED, pageno_total                                  
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT 
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32], g_x[33],
                  g_x[34], g_x[35], g_x[36],
                  g_x[37], g_x[38], g_x[39]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            CALL i105_fif06(sr.fif06) RETURNING l_a1
            CALL i105_fif07(sr.fif07) RETURNING l_b1
            PRINT COLUMN  g_c[31],sr.fif01,
                  COLUMN  g_c[32],sr.fif02,
                  COLUMN  g_c[33],sr.fif03,
                  COLUMN  g_c[34],sr.fif04,
                  COLUMN  g_c[35],sr.fif05 USING '-----------&.&&',
                  COLUMN  g_c[36],sr.fif06,l_a1,
                  COLUMN  g_c[37],sr.fif07,l_b1,
                  COLUMN  g_c[38],sr.fif08 USING '<<<<<<<<',
                  COLUMN  g_c[39],sr.fif09 USING '-----------&.&&'
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085--END
#No.FUN-570110 --start--                                                                                                            
FUNCTION i105_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("fif01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i105_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("fif01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--     

#FUN-910088--add--start--
FUNCTION i105_fif09_check()
   IF NOT cl_null(g_fif[l_ac].fif09) AND NOT cl_null(g_fif[l_ac].fif04) THEN
      IF cl_null(g_fif04_t) OR cl_null(g_fif_t.fif09) OR g_fif04_t != g_fif[l_ac].fif04 OR g_fif_t.fif09 != g_fif[l_ac].fif09 THEN
         LET g_fif[l_ac].fif09 = s_digqty(g_fif[l_ac].fif09,g_fif[l_ac].fif04)
         DISPLAY BY NAME g_fif[l_ac].fif09
      END IF
   END IF
   IF g_fif[l_ac].fif09 <0 THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
