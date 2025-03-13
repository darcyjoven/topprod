# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: aooi110.4gl
# Descriptions...: 地區資料維護作業
# Date & Author..: 05/05/25 By Smapmin
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-750041 07/05/15 By Lynn 打印無效資料標記
# Modify.........: No.FUN-760083 07/07/10 By mike 報表格式修改為crystal reports
# Modify.........: No.TQC-920044 09/02/16 By liuxqa FUNCTION i110_geo03(p_cmd)有錯，若敲錯值的話應該是清空geb02,而不是geo02
# Modify.........: No.MOD-940359 09/02/27 By Dido OUTER geb_file 設定
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B50049 11/05/11 by destiny 报错信息不准确     
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_geo          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        geo01       LIKE geo_file.geo01,       #地區編號
        geo02       LIKE geo_file.geo02,       #地區名稱
        geo03       LIKE geo_file.geo03,       #隸屬國別
        geb02       LIKE geb_file.geb02,       #國別名稱
        geoacti     LIKE geo_file.geoacti      #No.FUN-680102CHAR(1)  
                    END RECORD,
    g_geo_t         RECORD                 #程式變數 (舊值)
        geo01       LIKE geo_file.geo01,   #地區編號
        geo02       LIKE geo_file.geo02,   #地區名稱
        geo03       LIKE geo_file.geo03,   #隸屬國別
        geb02       LIKE geb_file.geb02,   #國別名稱
        geoacti     LIKE geo_file.geoacti  #No.FUN-680102CHAR(1)  
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN      
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   l_table         STRING                  #No.FUN-760083
DEFINE   g_str           STRING                  #No.FUN-760083
 
MAIN
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
 
#No.FUN-760083 --BEGIN--
   LET g_sql="geo01.geo_file.geo01,",
             "geo02.geo_file.geo02,",
             "geo03.geo_file.geo03,",
             "geoacti.geo_file.geoacti,",
             "geodate.geo_file.geodate,",
             "geogrup.geo_file.geogrup,",
             "geomodu.geo_file.geomodu,",
             "geouser.geo_file.geouser,",
             "geb02.geb_file.geb02"
   LET l_table=cl_prt_temptable("aooi110",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
 
    OPEN WINDOW i110_w WITH FORM "aoo/42f/aooi110" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i110_b_fill(g_wc2)
    CALL i110_menu()
    CLOSE WINDOW i110_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i110_menu()
 
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i110_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_geo[l_ac].geo01 IS NOT NULL THEN
                  LET g_doc.column1 = "geo01"
                  LET g_doc.value1 = g_geo[l_ac].geo01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_geo),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i110_q()
   CALL i110_b_askkey()
END FUNCTION
 
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102   VARCHAR(01),           #可新增否
    l_allow_delete  LIKE type_file.chr1            #No.FUN-680102   VARCHAR(01),           #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT geo01,geo02,geo03,'',geoacti FROM geo_file",
                       " WHERE geo01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_geo WITHOUT DEFAULTS FROM s_geo.*
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
               LET g_geo_t.* = g_geo[l_ac].*  #BACKUP
 
               OPEN i110_bcl USING g_geo_t.geo01 
               IF STATUS THEN
                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i110_bcl INTO g_geo[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_geo_t.geo01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               SELECT geb02  INTO g_geo[l_ac].geb02 FROM geb_file
                WHERE g_geo[l_ac].geo03 = geb01
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_geo[l_ac].* TO NULL      #900423
           LET g_geo[l_ac].geoacti = 'Y'       #Body default
           LET g_geo_t.* = g_geo[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD geo01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i110_bcl
              CANCEL INSERT
           END IF
           INSERT INTO geo_file(geo01,geo02,geo03,geoacti,geouser,geodate,geooriu,geoorig)
                         VALUES(g_geo[l_ac].geo01,g_geo[l_ac].geo02,
                                g_geo[l_ac].geo03,g_geo[l_ac].geoacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_geo[l_ac].geo01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("ins","geo_file",g_geo[l_ac].geo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD geo01                        #check 編號是否重複
            IF NOT cl_null(g_geo[l_ac].geo01) THEN
               IF g_geo[l_ac].geo01 != g_geo_t.geo01 OR
                  g_geo_t.geo01 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM geo_file
                       WHERE geo01 = g_geo[l_ac].geo01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_geo[l_ac].geo01 = g_geo_t.geo01
                       NEXT FIELD geo01
                   END IF
               END IF
            END IF
 
 
       AFTER FIELD geo03
           IF NOT cl_null(g_geo[l_ac].geo03) THEN
              CALL i110_geo03('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD geo03
              END IF
          END IF
                                                  	
       AFTER FIELD geoacti
          IF NOT cl_null(g_geo[l_ac].geoacti) THEN
             IF g_geo[l_ac].geoacti NOT MATCHES '[YN]' THEN
                LET g_geo[l_ac].geoacti = g_geo_t.geoacti
                NEXT FIELD geoacti
             END IF
          END IF
      
        BEFORE DELETE                            #是否取消單身
            IF g_geo_t.geo01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "geo01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_geo[l_ac].geo01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM geo_file WHERE geo01 = g_geo_t.geo01
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_geo_t.geo01,SQLCA.sqlcode,0)   #No.FUN-660131
                    CALL cl_err3("del","geo_file",g_geo_t.geo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
              LET g_geo[l_ac].* = g_geo_t.*
              CLOSE i110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_geo[l_ac].geo01,-263,0)
               LET g_geo[l_ac].* = g_geo_t.*
           ELSE
               UPDATE geo_file SET geo01=g_geo[l_ac].geo01,
                                   geo02=g_geo[l_ac].geo02,
                                   geo03=g_geo[l_ac].geo03,
                                   geoacti=g_geo[l_ac].geoacti,
                                   geomodu=g_user,
                                   geodate=g_today
                WHERE geo01 = g_geo_t.geo01 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_geo[l_ac].geo01,SQLCA.sqlcode,0)   #No.FUN-660131
                  CALL cl_err3("upd","geo_file",g_geo_t.geo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  LET g_geo[l_ac].* = g_geo_t.*
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
                 LET g_geo[l_ac].* = g_geo_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_geo.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac                   #FUN-D40030 Add
           CLOSE i110_bcl
           COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(geo03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_geb"
                   LET g_qryparam.default1 = g_geo[l_ac].geo03
                   CALL cl_create_qry() RETURNING g_geo[l_ac].geo03
                   DISPLAY g_geo[l_ac].geo03 TO geo03
#                  CALL FGL_DIALOG_SETBUFFER( g_geo[l_ac].geo03 )
                   CALL i110_geo03('a')
                OTHERWISE
                   EXIT CASE
            END CASE
 
       #ON ACTION CONTROLN
       #    CALL i110_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(geo01) AND l_ac > 1 THEN
                LET g_geo[l_ac].* = g_geo[l_ac-1].*
                NEXT FIELD geo01
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
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
        
        END INPUT
 
 
    CLOSE i110_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i110_geo03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
    l_gebacti       LIKE geb_file.gebacti
 
    LET g_errno = ' '
    SELECT geb02,gebacti INTO g_geo[l_ac].geb02,l_gebacti
        FROM geb_file
        WHERE geb01 = g_geo[l_ac].geo03
   #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-061' #TQC-B50049
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-424' #TQC-B50049
#                            LET g_geo[l_ac].geo02 = NULL  #No.TQC-920044 mark by liuxqa
                             LET g_geo[l_ac].geb02 = NULL  #No.TQC-920044 mod  by liuxqa 
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i110_b_askkey()
 
    CLEAR FORM
   CALL g_geo.clear()
 
    CONSTRUCT g_wc2 ON geo01,geo02,geo03,geoacti
         FROM s_geo[1].geo01,s_geo[1].geo02,s_geo[1].geo03,s_geo[1].geoacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
             CASE WHEN INFIELD(geo03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_geb"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_geo[1].geo03            
                     CALL i110_geo03('a')
                  OTHERWISE
                     EXIT CASE
              END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg      
        CALL cl_cmdask()     
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('geouser', 'geogrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i110_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
 
    LET g_sql =
        "SELECT geo01,geo02,geo03,geb02,geoacti",
        " FROM geo_file LEFT OUTER JOIN geb_file ON geo03=geb01 ",
        " WHERE ", p_wc2 CLIPPED,         #單身 #MOD-940359
        " ORDER BY 1"
    PREPARE i110_pb FROM g_sql
    DECLARE geo_curs CURSOR FOR i110_pb
 
    CALL g_geo.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH geo_curs INTO g_geo[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_geo.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_geo TO s_geo.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
     ON ACTION about         
        CALL cl_about()      
 
   
#@    ON ACTION 相關文件  
      ON ACTION related_document 
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
 
FUNCTION i110_out()
    DEFINE
        l_geo           RECORD LIKE geo_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE za_file.za05,             #No.FUN-680102 VARCHAR(40)
        l_geb02         LIKE geb_file.geb02            #No.FUN-760083  
    IF g_wc2 IS NULL THEN 
     # CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                          #No.FUN-760083 
    LET g_str=''                                       #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
    CALL cl_outnam('aooi110') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM geo_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i110_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i110_co                         # SCROLL CURSOR
         CURSOR FOR i110_p1
 
    #START REPORT i110_rep TO l_name                    #No.FUN-760083 
 
    FOREACH i110_co INTO l_geo.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
        END IF
        SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = l_geo.geo03      #No.FUN-760083
        EXECUTE insert_prep USING l_geo.geo01,l_geo.geo02,l_geo.geo03,         #No.FUN-760083
                                  l_geo.geoacti,l_geo.geodate,l_geo.geogrup,   #No.FUN-760083
                                  l_geo.geomodu,l_geo.geouser,l_geb02          #No.FUN-760083 
        #OUTPUT TO REPORT i110_rep(l_geo.*)             #No.FUN-760083 
    END FOREACH
 
    #FINISH REPORT i110_rep                             #No.FUN-760083 
 
    CLOSE i110_co
    ERROR ""
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)        #No.FUN-760083
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED  #No.FUN-760083
    IF g_zz05='Y' THEN                                     #No.FUN-760083
        CALL cl_wcchp(g_wc2,'geo01,geo02,geo03,geoacti')   #No.FUN-760083
        RETURNING   g_wc2                                  #No.FUN-760083
    END IF                                                 #No.FUN-760083
    LET g_str=g_wc2                                        #No.FUN-760083
    CALL cl_prt_cs3("aooi110","aooi110",g_sql,g_str)       #No.FUN-760083
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i110_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)
        sr RECORD LIKE geo_file.*,
        l_geb02   LIKE geb_file.geb02,
        l_chr           LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
        l_area          LIKE type_file.chr20          #No.FUN-680102CHAR(20)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.geo01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED     # No.TQC-750041
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
	    SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = sr.geo03
            LET l_area=sr.geo03,'   ',l_geb02
            IF sr.geoacti = 'N' 
                THEN PRINT g_c[31],'* ';
            END IF
            PRINT COLUMN g_c[32],sr.geo01,
                  COLUMN g_c[33],sr.geo02,
                  COLUMN g_c[34],l_area,
                  COLUMN g_c[35],sr.geoacti         # No.TQC-750041
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
END REPORT
}
#No.FUN-760083  --end--
