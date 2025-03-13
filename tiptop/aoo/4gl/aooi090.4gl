# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi090.4gl
# Descriptions...: 部門名稱
# Date & Author..: 91/06/21 By Lee
# Modify.........: 95/03/11 By Danny (加OUTER gea_file)
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.MOD-550119 05/05/17 By pengu  報表格式錯誤
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-640194 06/04/17 By Echo  在 ON LAST ROW 用 NEED 控制跳頁正常
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/09/15 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/06 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_geb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        geb01       LIKE geb_file.geb01,   #員工編號
        geb02       LIKE geb_file.geb02,   #員工姓名
        geb03       LIKE geb_file.geb03,   #部門編號
        gea02       LIKE gea_file.gea02,   #部門名稱
        gebacti     LIKE geb_file.gebacti     #No.FUN-680102 VARCHAR(1) 
                    END RECORD,
    g_geb_t         RECORD                 #程式變數 (舊值)
        geb01       LIKE geb_file.geb01,   #員工編號
        geb02       LIKE geb_file.geb02,   #員工姓名
        geb03       LIKE geb_file.geb03,   #部門編號
        gea02       LIKE gea_file.gea02,   #部門名稱
        gebacti     LIKE geb_file.gebacti     #No.FUN-680102 VARCHAR(1) 
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
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-760083  --BEGIN--
    LET g_sql="geb01.geb_file.geb01,",
              "geb02.geb_file.geb02,",
              "geb03.geb_file.geb03,",
              "gebacti.geb_file.gebacti,",
              "gebdate.geb_file.gebdate,",
              "gebgrup.geb_file.gebgrup,",
              "gebmodu.geb_file.gebmodu,",
              "gebuser.geb_file.gebuser,",
              "gea02.gea_file.gea02"
    LET l_table=cl_prt_temptable("aooi090",g_sql) CLIPPED
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err("insert_prep:",status,1)
    END IF
#No.FUN-760083  --END--
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i090_w AT p_row,p_col WITH FORM "aoo/42f/aooi090"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i090_b_fill(g_wc2)
    CALL i090_menu()
    CLOSE WINDOW i090_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i090_menu()
 
   WHILE TRUE
      CALL i090_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i090_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i090_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i090_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_geb[l_ac].geb01 IS NOT NULL THEN
                  LET g_doc.column1 = "geb01"
                  LET g_doc.value1 = g_geb[l_ac].geb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_geb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i090_q()
   CALL i090_b_askkey()
END FUNCTION
 
FUNCTION i090_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #No.FUN-680102 SMALLINT,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),               #處理狀態
    l_allow_insert  LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1       #No.FUN-680102 VARCHAR(01)               #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT geb01,geb02,geb03,'',gebacti FROM geb_file",
                       " WHERE geb01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i090_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_geb WITHOUT DEFAULTS FROM s_geb.*
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
#No.FUN-570110 --start                                                          
               LET g_before_input_done = FALSE                                  
               CALL i090_set_entry(p_cmd)                                       
               CALL i090_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570110 --end             
               LET g_geb_t.* = g_geb[l_ac].*  #BACKUP
 
               OPEN i090_bcl USING g_geb_t.geb01 
               IF STATUS THEN
                  CALL cl_err("OPEN i090_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i090_bcl INTO g_geb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_geb_t.geb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               SELECT gea02  INTO g_geb[l_ac].gea02 FROM gea_file
                WHERE g_geb[l_ac].geb03 = gea01
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i090_set_entry(p_cmd)                                           
           CALL i090_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end        
           INITIALIZE g_geb[l_ac].* TO NULL      #900423
           LET g_geb[l_ac].gebacti = 'Y'       #Body default
           LET g_geb_t.* = g_geb[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD geb01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i090_bcl
              CANCEL INSERT
           END IF
           INSERT INTO geb_file(geb01,geb02,geb03,gebacti,gebuser,gebdate,geboriu,geborig)
                         VALUES(g_geb[l_ac].geb01,g_geb[l_ac].geb02,
                                g_geb[l_ac].geb03,g_geb[l_ac].gebacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
 #             CALL cl_err(g_geb[l_ac].geb01,SQLCA.sqlcode,0)    #No.FUN-660131
               CALL cl_err3("ins","geb_file",g_geb[l_ac].geb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD geb01                        #check 編號是否重複
            IF NOT cl_null(g_geb[l_ac].geb01) THEN
               IF g_geb[l_ac].geb01 != g_geb_t.geb01 OR
                  g_geb_t.geb01 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM geb_file
                       WHERE geb01 = g_geb[l_ac].geb01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_geb[l_ac].geb01 = g_geb_t.geb01
                       NEXT FIELD geb01
                   END IF
               END IF
            END IF
 
 
       AFTER FIELD geb03
           IF NOT cl_null(g_geb[l_ac].geb03) THEN
              CALL i090_geb03('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD geb03
              END IF
          END IF
                                                  	
       AFTER FIELD gebacti
          IF NOT cl_null(g_geb[l_ac].gebacti) THEN
             IF g_geb[l_ac].gebacti NOT MATCHES '[YN]' THEN
                LET g_geb[l_ac].gebacti = g_geb_t.gebacti
                NEXT FIELD gebacti
             END IF
          END IF
      
        BEFORE DELETE                            #是否取消單身
            IF g_geb_t.geb01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "geb01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_geb[l_ac].geb01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM geb_file WHERE geb01 = g_geb_t.geb01
                IF SQLCA.sqlcode THEN
 #                   CALL cl_err(g_geb_t.geb01,SQLCA.sqlcode,0)    #No.FUn-660131
                     CALL cl_err3("del","geb_file",g_geb_t.geb01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
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
              LET g_geb[l_ac].* = g_geb_t.*
              CLOSE i090_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_geb[l_ac].geb01,-263,0)
               LET g_geb[l_ac].* = g_geb_t.*
           ELSE
               UPDATE geb_file SET geb01=g_geb[l_ac].geb01,
                                   geb02=g_geb[l_ac].geb02,
                                   geb03=g_geb[l_ac].geb03,
                                   gebacti=g_geb[l_ac].gebacti,
                                   gebmodu=g_user,
                                   gebdate=g_today
                WHERE geb01 = g_geb_t.geb01 
               IF SQLCA.sqlcode THEN
 #                 CALL cl_err(g_geb[l_ac].geb01,SQLCA.sqlcode,0)   #No.FUN-660131
                   CALL cl_err3("upd","geb_file",g_geb_t.geb01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_geb[l_ac].* = g_geb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
          #LET l_ac_t = l_ac             # 新增  #FUN-D40030 Mark
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_geb[l_ac].* = g_geb_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_geb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i090_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac             #FUN-D40030 Add
           CLOSE i090_bcl
           COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(geb03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gea"
                   LET g_qryparam.default1 = g_geb[l_ac].geb03
                   CALL cl_create_qry() RETURNING g_geb[l_ac].geb03
                   DISPLAY g_geb[l_ac].geb03 TO geb03
#                  CALL FGL_DIALOG_SETBUFFER( g_geb[l_ac].geb03 )
                   CALL i090_geb03('a')
                OTHERWISE
                   EXIT CASE
            END CASE
 
       #ON ACTION CONTROLN
       #    CALL i090_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(geb01) AND l_ac > 1 THEN
                LET g_geb[l_ac].* = g_geb[l_ac-1].*
                NEXT FIELD geb01
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
 
 
    CLOSE i090_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i090_geb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
    l_geaacti       LIKE gea_file.geaacti
 
    LET g_errno = ' '
    SELECT gea02,geaacti INTO g_geb[l_ac].gea02,l_geaacti
        FROM gea_file
        WHERE gea01 = g_geb[l_ac].geb03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-061'
                            LET g_geb[l_ac].gea02 = NULL
         WHEN l_geaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i090_b_askkey()
 
    CLEAR FORM
   CALL g_geb.clear()
 
    CONSTRUCT g_wc2 ON geb01,geb02,geb03,gebacti
         FROM s_geb[1].geb01,s_geb[1].geb02,s_geb[1].geb03,s_geb[1].gebacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
             CASE WHEN INFIELD(geb03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gea"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_geb[1].geb03            
                     CALL i090_geb03('a')
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gebuser', 'gebgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i090_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i090_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT geb01,geb02,geb03,gea02,gebacti",
        "  FROM geb_file LEFT OUTER JOIN gea_file ON geb03 = gea01",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i090_pb FROM g_sql
    DECLARE geb_curs CURSOR FOR i090_pb
 
    CALL g_geb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH geb_curs INTO g_geb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_geb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i090_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_geb TO s_geb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i090_out()
    DEFINE
        l_geb           RECORD LIKE geb_file.*,
        l_i             LIKE type_file.num5,      #No.FUN-680102 SMALLINT,
        l_name          LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(20),                # External(Disk) file name
        l_za05          LIKE type_file.chr1000    #No.FUN-680102 VARCHAR(40)                 #
    DEFINE l_gea02      LIKE gea_file.gea02       #No.FUN-760083 
     
    IF g_wc2 IS NULL THEN 
     # CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    #CALL cl_wait()                                       #No.FUN-760083
    #LET l_name = 'aooi090.out'                           #No.FUN-760083
    #CALL cl_outnam('aooi090') RETURNING l_name           #No.FUN-760083
    CALL cl_del_data(l_table)                             #No.FUN-760083
    LET g_str=''                                          #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM geb_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i090_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i090_co                         # SCROLL CURSOR
         CURSOR FOR i090_p1
 
    #START REPORT i090_rep TO l_name                        #No.FUN-760083
 
    FOREACH i090_co INTO l_geb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT gea02 INTO l_gea02 FROM gea_file WHERE gea01 = l_geb.geb03               #No.FUN-760083                              
        #OUTPUT TO REPORT i090_rep(l_geb.*)                 #No.FUN-760083
        EXECUTE insert_prep USING l_geb.geb01,l_geb.geb02,l_geb.geb03,          #No.FUN-760083
                                  l_geb.gebacti,l_geb.gebdate,l_geb.gebgrup,    #No.FUN-760083
                                  l_geb.gebmodu,l_geb.gebuser,l_gea02           #No.FUN-760083
    END FOREACH
 
    #FINISH REPORT i090_rep                                 #No.FUN-760083
 
    CLOSE i090_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                      #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED     #No.FUN-760083 
    IF g_zz05='Y' THEN                                                 #No.FUN-760083
        CALL cl_wcchp(g_wc2,'geb01,geb02,geb03,gebacti')               #No.FUN-760083
        RETURNING   g_wc2                                              #No.FUN-760083
    END IF                                                             #No.FUN-760083
    LET g_str=g_wc2                                                    #No.FUN-760083
    CALL cl_prt_cs3("aooi090","aooi090",g_sql,g_str)                   #No.FUN-760083 
END FUNCTION
 
#No.FUN-760083
{
REPORT i090_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE geb_file.*,
        l_gea02   LIKE gea_file.gea02,
        l_chr           LIKE type_file.chr1,      #No.FUN-680102 VARCHAR(1),
        l_area          LIKE type_file.chr20,     #No.FUN-680102 VARCHAR(20), 
        l_need_lines    LIKE type_file.num10      #No.FUN-680102 INTEGER
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.geb01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'                
 
        ON EVERY ROW
	    SELECT gea02 INTO l_gea02 FROM gea_file WHERE gea01 = sr.geb03
            LET l_area=sr.geb03,'   ',l_gea02
            IF sr.gebacti = 'N' 
                #THEN PRINT g_c[31],'* ';            #No.MOD-550119
                 THEN PRINT COLUMN g_c[31],'* ';     #No.MOD-550119
            END IF
            PRINT COLUMN g_c[32],sr.geb01,
                  COLUMN g_c[33],sr.geb02,
                  COLUMN g_c[34],l_area
 
        ON LAST ROW
            #FUN-640194
            LET l_need_lines = 2
            NEED l_need_lines LINES
            #END FUN-640194
            
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
END REPORT
}
#No.FUN-760083
 
#No.FUN-570110 --start                                                          
FUNCTION i090_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("geb01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i090_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)                                                       
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("geb01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end     
