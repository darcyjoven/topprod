# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: anmi002.4gl
# Descriptions...: 內部銀行存款利率維護作業
# Date & Author..: 06/10/18 By Czl
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6B0167 06/11/27 By czl 修改cl_err3
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-790050 07/09/05 By Carrier _out()轉p_query實現
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-960066 09/06/09 By baofei 判斷修改狀態時應該多判斷nad02 
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nad           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nad01       LIKE nad_file.nad01,       #幣別
        azi02       LIKE azi_file.azi02,       #幣別說明
        nad02       LIKE nad_file.nad02,       #計息類型
        nad03       LIKE nad_file.nad03,       #利率
        nadacti     LIKE nad_file.nadacti      #資料有效碼
                    END RECORD,
    g_nad_t         RECORD                     #程式變數 (舊值)
        nad01       LIKE nad_file.nad01,       #幣別
        azi02       LIKE azi_file.azi02,       #幣別說明
        nad02       LIKE nad_file.nad02,       #計息類型
        nad03       LIKE nad_file.nad03,       #利率
        nadacti     LIKE nad_file.nadacti      #資料有效碼
                    END RECORD,
    g_wc,g_sql      STRING,                    
    g_rec_b         LIKE type_file.num5,       #單身筆數 
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT 
 
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose 
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-790050
DEFINE g_before_input_done  LIKE type_file.num5    
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5       
 
   OPTIONS                                     #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)      #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET p_row = 4 LET p_col = 11
   OPEN WINDOW i002_w AT p_row,p_col WITH FORM "anm/42f/anmi002"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_wc = '1=1' CALL i002_b_fill(g_wc)
   CALL i002_menu()
   CLOSE WINDOW i002_w                         #結束畫面
   CALL  cl_used(g_prog,g_time,2)      #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time      #No.FUN-6A0082
END MAIN
 
FUNCTION i002_menu()
 
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i002_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi002" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_nad),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i002_q()
   CALL i002_b_askkey()
END FUNCTION
 
FUNCTION i002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT 
    l_azi02         LIKE azi_file.azi02,          #幣別說明
    l_n             LIKE type_file.num5,          #檢查重複用       
    l_nn            LIKE type_file.num5,          #檢查資料是否存在       
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否      
    p_cmd           LIKE type_file.chr1,          #處理狀態       
    l_allow_insert  LIKE type_file.num5,          #可新增否      
    l_allow_delete  LIKE type_file.num5           #可刪除否     
 
    LET g_action_choice = ""                                                    
 
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT nad01,'',nad02,nad03,nadacti",
                       " FROM nad_file",
                       "  WHERE nad01=? AND nad02=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
        INPUT ARRAY g_nad
            WITHOUT DEFAULTS
            FROM s_nad.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,
                         DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)                                           
         END IF
            
        BEFORE ROW
            LET p_cmd='' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                    #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                 
            CALL i002_set_entry(p_cmd)                                      
            CALL i002_set_no_entry(p_cmd)                                   
            LET g_before_input_done = TRUE                                  
            LET g_nad_t.* = g_nad[l_ac].*          #BACKUP
 
              OPEN i002_bcl USING g_nad_t.nad01,g_nad_t.nad02
              IF STATUS THEN
                 CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i002_bcl INTO g_nad[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_nad_t.nad01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT azi02 INTO g_nad[l_ac].azi02                            
                   FROM azi_file                                                
                  WHERE azi01 = g_nad[l_ac].nad01
#No.TQC-6B0167--begin--
#                 IF SQLCA.sqlcode THEN  
#                    CALL cl_err3("sel","azi_file",g_nad[g_cnt].nad01,"",
#                                  SQLCA.sqlcode,"","",1) 
#                 END IF                
#No.TQC-6B0167--end--
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                     
            CALL i002_set_entry(p_cmd)                                          
            CALL i002_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
            INITIALIZE g_nad[l_ac].* TO NULL
            LET g_nad[l_ac].nadacti = 'Y'           #Body default
            LET g_nad[l_ac].nad03=0
            LET g_nad_t.* = g_nad[l_ac].*           #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD nad01
 
        AFTER INSERT
            DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF NOT cl_null(g_nad[l_ac].nad03) THEN                               
              IF g_nad[l_ac].nad03 < 0 OR g_nad[l_ac].nad03 = 0 THEN            
                 CALL cl_err(g_nad[l_ac].nad03,'anm-101',0)
                 LET g_nad[l_ac].nad03 = g_nad_t.nad03                       
                   DISPLAY BY NAME g_nad[l_ac].nad03
                 NEXT FIELD nad03
              END IF
            END IF 
            INSERT INTO nad_file(nad01,nad02,nad03,
                                 nadacti,naduser,naddate,nadoriu,nadorig)
            VALUES(g_nad[l_ac].nad01,g_nad[l_ac].nad02,g_nad[l_ac].nad03,
                   g_nad[l_ac].nadacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","nad_file",g_nad[l_ac].nad01,"",
                             SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD nad01                                                       
             IF NOT cl_null(g_nad[l_ac].nad01) THEN                               
               IF g_nad_t.nad01 IS NULL OR g_nad_t.azi02 IS NULL OR             
                 (g_nad[l_ac].nad01 != g_nad_t.nad01 ) THEN                      
                  CALL i002_nad01('a')  
                  IF SQLCA.sqlcode THEN
                    CALL cl_err(g_nad_t.nad01,g_errno,0)
                    NEXT FIELD nad01  
                  END IF 
               END IF
             END IF 
 
        AFTER FIELD nad02
             IF NOT cl_null(g_nad[l_ac].nad01) THEN
                IF p_cmd = "a" OR
#                  (p_cmd = "u" AND g_nad[l_ac].nad01 != g_nad_t.nad01) THEN   #MOD-960066                                           
                  (p_cmd = "u" AND (g_nad[l_ac].nad01 != g_nad_t.nad01  OR     #MOD-960066                                          
                   g_nad[l_ac].nad02 != g_nad_t.nad02)) THEN                  #MOD-960066 
                  SELECT COUNT(*) INTO l_n FROM nad_file
                     WHERE nad01 = g_nad[l_ac].nad01
                       AND nad02 = g_nad[l_ac].nad02
                  IF l_n > 0 THEN
                    CALL cl_err(g_nad[l_ac].nad01,-239,1)
                    LET g_nad[l_ac].nad02 = g_nad_t.nad02
                    DISPLAY BY NAME g_nad[l_ac].nad02
                    NEXT FIELD nad02
                  END IF
                END IF
                SELECT COUNT(azi01) INTO l_nn FROM azi_file                       
                WHERE azi01 = g_nad[l_ac].nad01
                IF l_nn = 0 THEN                                                  
                   CALL cl_err(g_nad[l_ac].nad01,'axs-001',0)                    
                   NEXT FIELD nad01                                              
                END IF 
             END IF 
            NEXT FIELD nad03
 
        AFTER FIELD nad03
           IF NOT cl_null(g_nad[l_ac].nad03) THEN
              IF g_nad[l_ac].nad03 < 0 OR g_nad[l_ac].nad03 = 0 THEN
                 CALL cl_err(g_nad[l_ac].nad03,'anm-101',0)
                 NEXT FIELD nad03
              END IF
           END IF
 
        BEFORE DELETE                                 #是否取消單身
           IF g_nad_t.nad01 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM nad_file 
                WHERE nad01 = g_nad_t.nad01 AND nad02 = g_nad_t.nad02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nad_file",g_nad_t.nad01,"",
                               SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              MESSAGE "Delete OK"                                             
              CLOSE i002_bcl         
              COMMIT WORK
           END IF
 
        ON ROW CHANGE                                                           
           IF INT_FLAG THEN          
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nad[l_ac].* = g_nad_t.*
              CLOSE i002_bcl   
              ROLLBACK WORK     
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN                                               
              CALL cl_err(g_nad[l_ac].nad01,-263,1)                            
              LET g_nad[l_ac].* = g_nad_t.*                                      
           ELSE                                      
              UPDATE nad_file SET nad01 = g_nad[l_ac].nad01,
                                  nad02 = g_nad[l_ac].nad02,
                                  nad03 = g_nad[l_ac].nad03,
                                  nadacti = g_nad[l_ac].nadacti,
                                  nadmodu = g_user,
                                  naddate = g_today
              WHERE nad01=g_nad_t.nad01 AND nad02=g_nad_t.nad02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nad_file",g_nad_t.nad01,"",
                               SQLCA.sqlcode,"","",1)
                 LET g_nad[l_ac].* = g_nad_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i002_bcl         
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_nad[l_ac].* = g_nad_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_nad.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE i002_bcl                                                     
              ROLLBACK WORK  
              EXIT INPUT
           END IF     #FUN-D30032 add 
           LET l_ac_t = l_ac                                                     
           CLOSE i002_bcl                                                        
           COMMIT WORK   
       #   END IF   #FUN-D30032 mark
 
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(nad01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_nad[l_ac].nad01
                  CALL cl_create_qry() RETURNING g_nad[l_ac].nad01
                  DISPLAY BY NAME g_nad[l_ac].nad01
                  NEXT FIELD nad01
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLN
            CALL i002_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(nad01) AND l_ac > 1 THEN
               LET g_nad[l_ac].* = g_nad[l_ac-1].*
               NEXT FIELD nad01
            END IF	
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about    
           CALL cl_about()
 
        ON ACTION help   
           CALL cl_show_help()
        END INPUT
 
    CLOSE i002_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i002_b_askkey()
    CLEAR FORM
    CALL g_nad.clear()
    CONSTRUCT g_wc ON nad01,azi02,nad02,nad03,nadacti
            FROM s_nad[1].nad01,s_nad[1].azi02,s_nad[1].nad02,s_nad[1].nad03
			       ,s_nad[1].nadacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(nad01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi" 
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nad01
               NEXT FIELD nad01
            OTHERWISE
               EXIT CASE
         END CASE
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('naduser', 'nadgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i002_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i002_b_fill(p_wc2)                           #BODY FILL UP
#DEFINE p_wc2   LIKE type_file.chr1000,
DEFINE p_wc2  STRING,     #NO.FUN-910082
    l_azi02 LIKE azi_file.azi02
 
    LET g_sql =
        "SELECT nad01,'',nad02,nad03,nadacti",
        " FROM nad_file",
        " WHERE ",p_wc2 CLIPPED,
        " ORDER BY nad01"
    PREPARE i002_pb FROM g_sql
    DECLARE nad_curs CURSOR FOR i002_pb
 
    FOR g_cnt = 1 TO g_nad.getLength()                #單身 ARRAY 乾洗
       INITIALIZE g_nad[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH nad_curs INTO g_nad[g_cnt].*              #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT azi02 INTO g_nad[g_cnt].azi02 FROM azi_file 
          WHERE azi01=g_nad[g_cnt].nad01
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nad.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nad TO s_nad.*  ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i002_out()
#    DEFINE
#        l_nad           RECORD LIKE nad_file.*,
#        l_i             LIKE type_file.num5,  
#        l_name          LIKE type_file.chr20,             # External(Disk) file name
#        l_za05          LIKE type_file.chr1000
#   
#    IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0) 
#       RETURN 
#    END IF
#    CALL cl_wait()
#    CALL cl_outnam('anmi002') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    LET g_sql="SELECT * FROM nad_file ",                   # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE i002_p1 FROM g_sql                             # RUNTIME 編譯
#    DECLARE i002_co CURSOR FOR i002_p1
#
#    START REPORT i002_rep TO l_name
#
#    FOREACH i002_co INTO l_nad.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i002_rep(l_nad.*)
#    END FOREACH
#
#    FINISH REPORT i002_rep
#
#    CLOSE i002_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i002_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,
#        l_desc          LIKE ze_file.ze03,
#        l_azi02         LIKE azi_file.azi02,
#        sr              RECORD LIKE nad_file.*,
#        l_chr           LIKE type_file.chr1   
#
#    OUTPUT
#        TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#
#    ORDER BY sr.nad01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,
#                           g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        
#        
#
#        ON EVERY ROW
#          SELECT azi02 INTO l_azi02 FROM azi_file WHERE azi01=sr.nad01
#          CASE sr.nad02
#             WHEN "0"  CALL cl_getmsg('anm-199',g_lang) RETURNING l_desc
#             WHEN "1"  CALL cl_getmsg('anm-198',g_lang) RETURNING l_desc
#             WHEN "2"  CALL cl_getmsg('anm-197',g_lang) RETURNING l_desc
#             WHEN "3"  CALL cl_getmsg('anm-196',g_lang) RETURNING l_desc
#             WHEN "4"  CALL cl_getmsg('anm-195',g_lang) RETURNING l_desc
#             WHEN "5"  CALL cl_getmsg('anm-194',g_lang) RETURNING l_desc
#          END CASE
#             PRINT COLUMN g_c[31],sr.nad01,
#                   COLUMN g_c[32],l_azi02,
#                   COLUMN g_c[33],l_desc,
#                   COLUMN g_c[34],cl_numfor(sr.nad03,34,6),
#                   COLUMN g_c[35],sr.nadacti
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#               SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --End  
 
FUNCTION i002_nad01(p_cmd)
   DEFINE l_azi02     LIKE azi_file.azi02
   DEFINE p_cmd       LIKE type_file.chr1
   
   LET g_errno = ' '
   SELECT azi02 INTO l_azi02 FROM azi_file WHERE azi01 = g_nad[l_ac].nad01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axs-001'
                                  LET l_azi02 = NULL
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'a' THEN
      LET g_nad[l_ac].azi02 = l_azi02
      DISPLAY BY NAME g_nad[l_ac].azi02
   END IF  
END FUNCTION
 
FUNCTION i002_set_entry(p_cmd)                                                  
DEFINE p_cmd     LIKE type_file.chr1
  
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("nad01",TRUE)
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i002_set_no_entry(p_cmd)                                               
DEFINE p_cmd   LIKE type_file.chr1  
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nad01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
