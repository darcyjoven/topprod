# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acoi102.4gl
# Descriptions...: 料件基本資料維護作業
# Date & Author..: 00/04/21 By Kammy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-510042 05/01/20 By pengu 報表轉XML
# Modify.........: No.FUN-570109 05/07/15 By day   修正建檔程式key值是否可更改     
# Modify.........: No.FUN-660045 06/06/12 BY cheunl  cl_err --->cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-790066 07/09/11 By Judy 1.打印報表中，表頭在制表日期下方
#                                                 2.匯出Excel多一空白行 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0055 09/12/08 By Carrier 出现btn01等20个action内容
# Modify.........: No:MOD-AC0044 10/12/06 By sabrina (1)單身不可新增和刪除
#                                                    (2)非保稅料號不可撈出
# Modify.........: No:FUN-C30190 12/03/20 By tanxc 將老報表轉成CR報表
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ima_paimao    LIKE type_file.num5,         #No.FUN-680069 SMALLINT #頁數
    g_ima           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ima01       LIKE ima_file.ima01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名規格 
        ima08       LIKE ima_file.ima08,   #來源碼
        ima75       LIKE ima_file.ima75,   #商品編號
        cob02       LIKE cob_file.cob02,   #說明 
        ima77       LIKE ima_file.ima77    #轉換率
                    END RECORD,
    g_ima_t         RECORD                 #程式變數 (舊值)
        ima01       LIKE ima_file.ima01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名規格 
        ima08       LIKE ima_file.ima08,   #來源碼
        ima75       LIKE ima_file.ima75,   #商品編號
        cob02       LIKE cob_file.cob02,   #說明 
        ima77       LIKE ima_file.ima77    #轉換率
                    END RECORD,
    g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_wc           STRING,  #No.FUN-C30190 ADD
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT         #No.FUN-680069 SMALLINT
 
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109         #No.FUN-680069 SMALLINT
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-9C0055 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-9C0055 add
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW i102_w WITH FORM "aco/42f/acoi102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
        
    CALL i102_menu()
    CLOSE WINDOW i102_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i102_menu()
 
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i102_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i102_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_q()
   CALL i102_b_askkey()
   LET g_ima_paimao = 0
END FUNCTION
 
FUNCTION i102_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_aag02         LIKE aag_file.aag02,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ima01,ima02,ima08,ima75,'',ima77 FROM ima_file WHERE ima01= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET g_ima_paimao = 1
       #LET l_allow_insert = cl_detail_input_auth("insert")        #MOD-AC0044 mark  
       #LET l_allow_delete = cl_detail_input_auth("delete")        #MOD-AC0044 mark  
 
        INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_ima_t.ima01 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i102_set_entry(p_cmd)                                                                                           
               CALL i102_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--            
               BEGIN WORK
               OPEN i102_bcl USING g_ima_t.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i102_bcl INTO g_ima[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ima_t.ima01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i102_ima75('d')
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD ima01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CALL g_ima.deleteElement(l_ac)   #取消 Array Element
               IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
               EXIT INPUT
            END IF
            #--Move original INSERT block from AFTER ROW to here
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                         
            CALL i102_set_entry(p_cmd)                                                                                              
            CALL i102_set_no_entry(p_cmd)                                                                                           
            LET g_before_input_done = TRUE                                                                                          
#No.FUN-570109 --end--    
            INITIALIZE g_ima[l_ac].* TO NULL      #900423
            LET g_ima_t.* = g_ima[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ima01
 
        AFTER FIELD ima75
            IF NOT cl_null(g_ima[l_ac].ima75) THEN
               SELECT COUNT(*) INTO l_cnt FROM cob_file
                    WHERE cob01 = g_ima[l_ac].ima75
               IF l_cnt <=0  THEN
                  LET g_ima[l_ac].ima75 = g_ima_t.ima75
                  CALL cl_err(g_ima[l_ac].ima75,'aco-001',0)
                  NEXT FIELD ima75
               END IF
               IF p_cmd = 'u' AND g_ima[l_ac].ima75 != g_ima_t.ima75 THEN
                  CALL i102_ima75('a')
                  IF NOT cl_null(g_errno) THEN
                       LET g_ima[l_ac].ima75 = g_ima_t.ima75
                       CALL cl_err(g_ima[l_ac].ima75,g_errno,0) 
                       NEXT FIELD ima75
                  END IF
               END IF
            END IF
            CALL i102_ima75('a')
 
        AFTER FIELD ima77
            IF NOT cl_null(g_ima[l_ac].ima77) THEN
               IF g_ima[l_ac].ima77 <=0 THEN 
                  NEXT FIELD ima77 
               END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ima[l_ac].* = g_ima_t.*
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ima[l_ac].ima01,-263,1)
               LET g_ima[l_ac].* = g_ima_t.*
            ELSE
               UPDATE ima_file SET ima75=g_ima[l_ac].ima75,
                                   ima77=g_ima[l_ac].ima77,
                                   imadate = g_today              #FUN-C30315 add
                WHERE ima01=g_ima_t.ima01
               IF SQLCA.sqlcode THEN
                # CALL cl_err(g_ima[l_ac].ima01,SQLCA.sqlcode,0) #No.TQC-660045
                  CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1) #No.TQC-660045
                  LET g_ima[l_ac].* = g_ima_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i102_bcl
                  COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ima[l_ac].* = g_ima_t.*
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_ima_t.* = g_ima[l_ac].*
            CLOSE i102_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i102_b_askkey()
            EXIT INPUT
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ima75) #商品類別
#                CALL q_cob(10,3,g_ima[l_ac].ima75,g_ima[l_ac].ima76)
#                     RETURNING g_ima[l_ac].ima75,g_ima[l_ac].ima76
#                CALL FGL_DIALOG_SETBUFFER( g_ima[l_ac].ima75 )
#                CALL FGL_DIALOG_SETBUFFER( g_ima[l_ac].ima76 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cob"
                 #LET g_qryparam.default1 = g_ima[l_ac].ima75,g_ima[l_ac].ima76
                 LET g_qryparam.default1 = g_ima[l_ac].ima75
                 CALL cl_create_qry() RETURNING g_ima[l_ac].ima75
#                 CALL FGL_DIALOG_SETBUFFER( g_ima[l_ac].ima75 )
                  DISPLAY BY NAME g_ima[l_ac].ima75           #No.MOD-490371
                 NEXT FIELD ima75
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLZ
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
 
    CLOSE i102_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i102_b_askkey()
    CLEAR FORM
    CALL g_ima.clear()
    CONSTRUCT g_wc2 ON ima01,ima02,ima08,ima75,ima77
            FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima08,
                 s_ima[1].ima75,s_ima[1].ima77
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(ima75) #商品類別
#                CALL q_cob(10,3,g_ima[1].ima75,g_ima[1].ima76)
#                     RETURNING g_ima[1].ima75,g_ima[1].ima76
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_cob"
                 LET g_qryparam.default1 = g_ima[1].ima75
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_ima[1].ima75
                 NEXT FIELD ima75
              OTHERWISE EXIT CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    LET g_ima_paimao = 1
    CALL i102_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT ima01,ima02,ima08,ima75,cob02,ima77",
        "  FROM ima_file LEFT OUTER JOIN cob_file ON ima_file.ima75=cob_file.cob01",
        " WHERE  ",
        "  ", p_wc2 CLIPPED, #單身
        "   AND ima15 = 'Y' ",       #MOD-AC0044 add
        " ORDER BY 1"
    PREPARE i102_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR i102_pb
 
    CALL g_ima.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ima.deleteElement(g_cnt)   #TQC-790066
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-9C0055 add
   LET g_curs_index = 0              #No.TQC-9C0055 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
 
     #---------No.TQC-9C0055 add
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
     #---------No.TQC-9C0055 end

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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i102_ima75(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,                      #No.FUN-680069 VARCHAR(1)
           l_cob02   LIKE cob_file.cob02,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
    SELECT cobacti,cob02 INTO l_cobacti,l_cob02
           FROM cob_file WHERE cob01 = g_ima[l_ac].ima75
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET l_cob02 = NULL
         WHEN l_cobacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_ima[l_ac].cob02 = l_cob02
    DISPLAY g_ima[l_ac].cob02 TO s_ima[l_ac].cob02
    RETURN
 
END FUNCTION
 
FUNCTION i102_out()
    DEFINE
        l_ima           RECORD LIKE ima_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680069 VARCHAR(20) # External(Disk) file name
        l_za05          LIKE cob_file.cob01           #No.FUN-680069 VARCHAR(40)
    #FUN-C30190--begin---
    DEFINE l_table    STRING
    DEFINE l_str      STRING
    DEFINE l_cob02           LIKE cob_file.cob02
    DEFINE l_cob021          LIKE cob_file.cob021

    LET g_sql ="ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima75.ima_file.ima75,",
               "l_cob02.cob_file.cob02,",
               "l_cob021.cob_file.cob021,",
               "ima77.ima_file.ima77"

    LET l_table = cl_prt_temptable('acoi102',g_sql) CLIPPED
    IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
    END IF

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "      VALUES(?,?,?,?,?, ?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
    END IF

    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #FUN-C30190--end---
    
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
   # LET l_name = 'acoi102.out'
    CALL cl_outnam('acoi102') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ima_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i102_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i102_co CURSOR FOR i102_p1
 
    #START REPORT i102_rep TO l_name   #FUN-C30190--mark---
 
    FOREACH i102_co INTO l_ima.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #OUTPUT TO REPORT i102_rep(l_ima.*)   #FUN-C30190--mark---
        #FUN-C30190--add--begin---
        SELECT cob02,cob021 INTO l_cob02,l_cob021 
            FROM cob_file WHERE cob01=l_ima.ima75
        IF SQLCA.sqlcode THEN 
            LET l_cob02 = ' ' 
            LET l_cob021 = ' ' 
        END IF
        EXECUTE insert_prep USING l_ima.ima01,l_ima.ima02,l_ima.ima021,
                                  l_ima.ima75,l_cob02,l_cob021,l_ima.ima77
        #FUN-C30190--add--end---
    END FOREACH
 
    #FINISH REPORT i102_rep   #FUN-C30190--mark---
 
    CLOSE i102_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)    #FUN-C30190--mark---
    #FUN-C30190 add---srt---
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_wcchp(g_wc2,'ima01,ima02,ima08,ima75,ima77') RETURNING g_wc
    LET l_str = g_wc CLIPPED
    CALL cl_prt_cs3('acoi102','acoi102',g_sql,l_str)
    #FUN-C30190 add---end---
END FUNCTION
#FUN-C30190 mark---begin---
#REPORT i102_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
#        sr RECORD       LIKE ima_file.*,
#        l_cob02         LIKE cob_file.cob02,
#        l_cob021        LIKE cob_file.cob021,
#        l_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.ima01
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                     
#            PRINT ' '    #TQC-790066                                                            
#            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #TQC-790066                       
#                  LET g_pageno = g_pageno + 1                                         
#                  LET pageno_total = PAGENO USING '<<<',"/pageno"                     
#                  PRINT g_head CLIPPED,pageno_total                                   
##           PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #TQC-790066                       
##           PRINT ' '    #TQC-790066                                                            
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] clipped,g_x[32] clipped,g_x[36] clipped,
#                  g_x[33] clipped,g_x[34] clipped,g_x[35] clipped,g_x[37] clipped
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#        ON EVERY ROW
#            SELECT cob02,cob021 INTO l_cob02,l_cob021 
#              FROM cob_file WHERE cob01=sr.ima75
#            IF SQLCA.sqlcode THEN 
#               LET l_cob02 = ' ' 
#               LET l_cob021 = ' ' 
#            END IF
#            PRINT COLUMN g_c[31],sr.ima01,
#                  COLUMN g_c[32],sr.ima02,
#                  COLUMN g_c[36],sr.ima021,
#                  column g_c[33],sr.ima75,
#                  COLUMN g_c[34],l_cob02,
#                  COLUMN g_c[37],l_cob021,
#                  COLUMN g_c[35],sr.ima77 USING '############&.&&'
# 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
# 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190 mark---end---  

#No.FUN-570109 --begin                                                                                                              
FUNCTION i102_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680069 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("ima01",TRUE)                                                                                           
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i102_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680069 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ima01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end  
                   
