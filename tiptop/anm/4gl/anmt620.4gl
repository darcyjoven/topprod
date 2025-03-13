# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt620.4gl
# Descriptions...: 投資現值維護作業(Multi-line process)
# Date & Author..: 06/06/22 Rainy 
# Modify.........: No.FUN-660148 06/06/28 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-680075 06/08/22 By Sarah 按下Action"單身",投資日期、投資種類、投資標的三個欄位值會不見
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/27 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B20104 11/02/22 by Dido 需檢核 gsb12 > 0 才可輸入 
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gsl          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gsl01       LIKE gsl_file.gsl01,   #投資單號
        gsb03       LIKE gsb_file.gsb03,   #投資日期
        gsb05       LIKE gsb_file.gsb05,
        gsb06       LIKE gsb_file.gsb06,   #投資標的
        gsl02       LIKE gsl_file.gsl02,   #現值日期
        gsl03       LIKE gsl_file.gsl03,   #現價
        gsl04       LIKE gsl_file.gsl04,   #備註
        gslacti     LIKE gsl_file.gslacti
                    END RECORD,
    g_gsl_t         RECORD                 #程式變數 (舊值)
        gsl01       LIKE gsl_file.gsl01,   #投資單號
        gsb03       LIKE gsb_file.gsb03,   #投資日期
        gsb05       LIKE gsb_file.gsb05,
        gsb06       LIKE gsb_file.gsb06,   #投資標的
        gsl02       LIKE gsl_file.gsl02,   #現值日期
        gsl03       LIKE gsl_file.gsl03,   #現價
        gsl04       LIKE gsl_file.gsl04,   #備註
        gslacti     LIKE gsl_file.gslacti 
                    END RECORD,
    g_wc2,g_sql     STRING,            
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5                 #No.FUN-680107 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0082
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW t620_w AT p_row,p_col WITH FORM "anm/42f/anmt620"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL t620_b_fill(g_wc2)
    CALL t620_menu()
    CLOSE WINDOW t620_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
 
 
FUNCTION t620_menu()
 
   WHILE TRUE
      CALL t620_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t620_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t620_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t620_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_gsl[l_ac].gsl01 IS NOT NULL THEN
                  LET g_doc.column1 = "gsl01"
                  LET g_doc.value1 = g_gsl[l_ac].gsl01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gsl),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t620_q()
   CALL t620_b_askkey()
END FUNCTION
 
FUNCTION t620_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680107 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #No.FUN-680107 VARCHAR(01)    #可新增否
   l_allow_delete  LIKE type_file.num5,                #No.FUN-680107 VARCHAR(01)    #可刪除否
   l_gsb12         LIKE gsb_file.gsb12                 #MOD-B20104
   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT gsl01,'','','',gsl02,gsl03,gsl04,gslacti",   
                      "  FROM gsl_file WHERE gsl01= ? AND gsl02= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t620_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gsl WITHOUT DEFAULTS FROM s_gsl.*
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
             LET g_before_input_done = FALSE                                    
             CALL t620_set_entry(p_cmd)                                         
             CALL t620_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_gsl_t.* = g_gsl[l_ac].*  #BACKUP
             OPEN t620_bcl USING g_gsl_t.gsl01,g_gsl_t.gsl02
             IF STATUS THEN
                CALL cl_err("OPEN t620_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t620_bcl INTO g_gsl[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_gsl_t.gsl01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
               #start TQC-680075 add
                SELECT gsb03,gsb05,gsb06
                  INTO g_gsl[l_ac].gsb03,g_gsl[l_ac].gsb05,g_gsl[l_ac].gsb06
                  FROM gsb_file
                 WHERE gsb01=g_gsl_t.gsl01
               #end TQC-680075 add
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                       
          CALL t620_set_entry(p_cmd)                                            
          CALL t620_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_gsl[l_ac].* TO NULL     
          LET g_gsl[l_ac].gslacti = 'Y'       #Body default
          LET g_gsl_t.* = g_gsl[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     
          NEXT FIELD gsl01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t620_bcl
             CANCEL INSERT
          END IF
          INSERT INTO gsl_file(gsl01,gsl02,gsl03,gsl04,gslacti,gsluser,gsldate,gslgrup,
                               gsllegal,gsloriu,gslorig)   #FUN-980005 add legal   
          VALUES(g_gsl[l_ac].gsl01,g_gsl[l_ac].gsl02,g_gsl[l_ac].gsl03,
                 g_gsl[l_ac].gsl04,g_gsl[l_ac].gslacti,g_user,g_today,g_grup,
                               g_legal, g_user, g_grup)         #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","gsl_file",g_gsl[l_ac].gsl01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD gsl01                        #check 編號是否重複
          IF NOT cl_null(g_gsl[l_ac].gsl01) THEN
             IF (g_gsl[l_ac].gsl01 != g_gsl_t.gsl01 OR
                cl_null(g_gsl_t.gsl01)) AND NOT cl_null(g_gsl[l_ac].gsl02) THEN
                SELECT count(*) INTO l_n FROM gsl_file
                 WHERE gsl01 = g_gsl[l_ac].gsl01
                   AND gsl02 = g_gsl[l_ac].gsl02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_gsl[l_ac].gsl01 = g_gsl_t.gsl01
                   NEXT FIELD gsl01
                END IF
             END IF
 
             SELECT count(*) INTO l_n FROM gsb_file WHERE gsb01 = g_gsl[l_ac].gsl01
             IF l_n < 1 THEN
                 CALL cl_err("","mfg0044",1)
                 LET g_gsl[l_ac].gsl01 = g_gsl_t.gsl01
                 NEXT FIELD gsl01
             ELSE 
                SELECT gsb03,gsb05,gsb06,gsb12 INTO g_gsl[l_ac].gsb03,g_gsl[l_ac].gsb05,g_gsl[l_ac].gsb06,l_gsb12 #MOD-B20104 add gsb12
                  FROM gsb_file WHERE gsb01 = g_gsl[l_ac].gsl01
               #-MOD-B20104-add-
                IF l_gsb12 <= 0 THEN
                   CALL cl_err("","anm-093",1)
                   LET g_gsl[l_ac].gsl01 = g_gsl_t.gsl01
                   NEXT FIELD gsl01
                END IF
               #-MOD-B20104-end-
             END IF 
             DISPLAY BY NAME g_gsl[l_ac].gsb03,g_gsl[l_ac].gsb05,g_gsl[l_ac].gsb06
 
          END IF
       
        AFTER FIELD gsl02   
          IF NOT cl_null(g_gsl[l_ac].gsl02) THEN
             IF g_gsl[l_ac].gsl02 != g_gsl_t.gsl02 OR
                cl_null(g_gsl_t.gsl02) AND NOT cl_null(g_gsl[l_ac].gsl01) THEN
                SELECT count(*) INTO l_n FROM gsl_file
                 WHERE gsl01 = g_gsl[l_ac].gsl01
                   AND gsl02 = g_gsl[l_ac].gsl02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_gsl[l_ac].gsl02 = g_gsl_t.gsl02
                   NEXT FIELD gsl02
                END IF
             END IF
          END IF
 
 
       AFTER FIELD gslacti
          IF NOT cl_null(g_gsl[l_ac].gslacti) THEN
             IF g_gsl[l_ac].gslacti NOT MATCHES '[YN]' THEN 
                LET g_gsl[l_ac].gslacti = g_gsl_t.gslacti
                NEXT FIELD gslacti
             END IF
          END IF
       		
       BEFORE DELETE                            #是否取消單身
          IF g_gsl_t.gsl01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "gsl01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_gsl[l_ac].gsl01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM gsl_file WHERE gsl01 = g_gsl_t.gsl01
                                    AND gsl02 = g_gsl_t.gsl02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","gsl_file",g_gsl_t.gsl01,g_gsl_t.gsl02,SQLCA.sqlcode,"","",1)  
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
             LET g_gsl[l_ac].* = g_gsl_t.*
             CLOSE t620_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_gsl[l_ac].gsl01,-263,0)
             LET g_gsl[l_ac].* = g_gsl_t.*
          ELSE
             UPDATE gsl_file SET gsl01=g_gsl[l_ac].gsl01,
                                 gsl02=g_gsl[l_ac].gsl02,
                                 gsl03=g_gsl[l_ac].gsl03,
                                 gsl04=g_gsl[l_ac].gsl04,
                                 gslacti=g_gsl[l_ac].gslacti,
                                 gslmodu=g_user,
                                 gsldate=g_today
              WHERE gsl01 = g_gsl_t.gsl01
                AND gsl02 = g_gsl_t.gsl02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gsl_file",g_gsl_t.gsl01,g_gsl_t.gsl02,SQLCA.sqlcode,"","",1)    #No.FUN-660148
                LET g_gsl[l_ac].* = g_gsl_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增   #FUN-D30032 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gsl[l_ac].* = g_gsl_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_gsl.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end-- 
             END IF
             CLOSE t620_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac            #FUN-D30032 Add
          CLOSE t620_bcl               # 新增
          COMMIT WORK
 
       ON ACTION CONTROLP
          IF INFIELD(gsl01)  THEN
             CALL cl_init_qry_var()
            #LET g_qryparam.form = "q_gsb"           #MOD-B20104 mark 
             LET g_qryparam.form = "q_gsb02"         #MOD-B20104
             CALL cl_create_qry() RETURNING g_gsl[l_ac].gsl01
             DISPLAY BY NAME g_gsl[l_ac].gsl01
             
             NEXT FIELD gsl01
          END IF
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gsl01) AND l_ac > 1 THEN
             LET g_gsl[l_ac].* = g_gsl[l_ac-1].*
             LET g_gsl[l_ac].gsl02 = NULL
             NEXT FIELD gsl02
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
   CLOSE t620_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t620_b_askkey()
 
   CLEAR FORM
   CALL g_gsl.clear()
   CONSTRUCT g_wc2 ON gsl01,gsl02,gsl03,gsl04,gslacti   
        FROM s_gsl[1].gsl01,s_gsl[1].gsl02,s_gsl[1].gsl03,
             s_gsl[1].gsl04,s_gsl[1].gslacti   
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
          IF INFIELD(gsl01)  THEN
             CALL cl_init_qry_var()
            #LET g_qryparam.form = "q_gsb"         #MOD-B20104 mark 
             LET g_qryparam.form = "q_gsl"         #MOD-B20104
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO gsl01
 
             NEXT FIELD gsl01
          END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gsluser', 'gslgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL t620_b_fill(g_wc2)
END FUNCTION
 
 
FUNCTION t620_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
        "SELECT gsl01,gsb03,gsb05,gsb06,gsl02,gsl03,gsl04,gslacti",   
        " FROM gsl_file LEFT OUTER JOIN gsb_file",
        " ON gsl01 = gsb_file.gsb01  WHERE  ", p_wc2 CLIPPED,                     #單身
        " ORDER BY gsl01"
    PREPARE t620_pb FROM g_sql
    DECLARE gsl_curs CURSOR FOR t620_pb
 
    CALL g_gsl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gsl_curs INTO g_gsl[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gsl.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t620_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gsl TO s_gsl.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                 
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t620_out()
   DEFINE
       l_gsl           RECORD LIKE gsl_file.*,
       l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_name          LIKE type_file.chr20           # External(Disk) file name        #No.FUN-680107 VARCHAR(20)
 
#No.FUN-820002 --begin  
   DEFINE l_cmd           LIKE type_file.chr1000
 
   IF cl_null(g_wc2) THEN 
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   #報表轉為使用 p_query                                                                                                            
   LET l_cmd = 'p_query "anmt620" "',g_wc2 CLIPPED,'"'                                                                              
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN
 
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM gsl_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE t620_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t620_co                         # SCROLL CURSOR
#        CURSOR FOR t620_p1
 
#   CALL cl_outnam('anmt620') RETURNING l_name
#   START REPORT t620_rep TO l_name
 
#   FOREACH t620_co INTO l_gsl.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t620_rep(l_gsl.*)
#   END FOREACH
 
#   FINISH REPORT t620_rep
 
#   CLOSE t620_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t620_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
#       sr RECORD LIKE gsl_file.*
#   DEFINE l_gsb03   LIKE gsb_file.gsb03,
#          l_gsb05   LIKE gsb_file.gsb05,
#          l_gsb06   LIKE gsb_file.gsb06
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line   
 
#   ORDER BY sr.gsl01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINTX g_x[30],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           SELECT gsb03,gsb05,gsb06 INTO l_gsb03,l_gsb05,l_gsb06
#             FROM gsb_file WHERE gsb01 = sr.gsl01
 
#           IF sr.gslacti = 'N'
#               THEN PRINT COLUMN g_c[30],'* ';     
#           END IF
 
 
#           PRINT  COLUMN g_c[31],sr.gsl01,
#                 COLUMN g_c[32],l_gsb03,
#                 COLUMN g_c[33],l_gsb05,
#                 COLUMN g_c[34],l_gsb06,
#                 COLUMN g_c[35],sr.gsl02,
#                 COLUMN g_c[36],cl_numfor(sr.gsl03,36,g_azi04),
#                 COLUMN g_c[37],sr.gsl04
#       ON LAST ROW
#           PRINT g_dash2 
#           PRINT  COLUMN g_c[35],g_x[9],
#                 COLUMN g_c[36],cl_numfor( SUM(sr.gsl03),36,g_azi04)
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
 
FUNCTION t620_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gsl01,gsl02",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t620_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1            #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gsl01,gsl02",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
