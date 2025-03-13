# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi090.4gl     
# Descriptions...: 訂單/采購單別拋轉設置作業 
# Date & Author..: 06/01/25 By cl
# Modify.........: No.TQC-650128 06/05/29 By Rayven 增加對單別屬性群組一致性的判定
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.MOD-6A0099 06/10/23 By Mandy 不限制此支程式只能在使用流通配銷系統時才能執行
# Modify.........: No.TQC-6A0055 06/10/23 By Mandy AFTER FIELD tsi02 多判斷不能重複
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0183 06/12/29 By chenl 增加查詢無效資料時的報錯信息。
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_tsi         DYNAMIC ARRAY OF RECORD
               tsi01  LIKE tsi_file.tsi01,
               tsi02  LIKE tsi_file.tsi02      
                      END RECORD, 
        g_tsi_t       RECORD
               tsi01  LIKE tsi_file.tsi01,
               tsi02  LIKE tsi_file.tsi02      
                      END RECORD, 
        g_tsi_o       RECORD
               tsi01  LIKE tsi_file.tsi01,
               tsi02  LIKE tsi_file.tsi02      
                      END RECORD, 
        g_wc2,g_sql   STRING, 
        g_rec_b       LIKE type_file.num5,                   #單身筆數        #No.FUN-680137 SMALLINT
        l_ac          LIKE type_file.num5                    #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE  p_row,p_col         LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  g_forupd_sql        STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_cnt,g_cn2         LIKE type_file.num10         #No.FUN-680137 INTEGER 
DEFINE  g_before_input_done LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_aza50             LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
DEFINE  g_t                 LIKE aba_file.aba00           #No.FUN-680137 VARCHAR(5)
 
#No.TQC-650128 --start--
DEFINE  lg_smy62      LIKE smy_file.smy62
DEFINE  lg_oay22      LIKE oay_file.oay22
#No.TQC-650128 --end--
 
MAIN
#     DEFINEl_time  LIKE type_file.chr8              #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log    
 
    IF (NOT cl_setup("AXM")) THEN                                               
       EXIT PROGRAM                                                             
    END IF
 
    CALL  cl_used(g_prog,g_time,1)            #計算使用時間 (進入時間)   #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    
   #MOD-6A0099 mark  #不限制此支程式只能在使用流通配銷系統時才能執行
   #SELECT aza50 INTO l_aza50 FROM aza_file  #當aza50=Y時
   #IF l_aza50 = "N" OR (l_aza50 IS NULL) THEN
   #   CALL cl_err("","axm-904",1)
   #   EXIT PROGRAM
   #END IF 
 
    LET p_row = 3 LET p_col = 3
 
    OPEN WINDOW i090_w AT p_row,p_col WITH FORM "axm/42f/axmi090"
       ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()  
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i090_b_fill(g_wc2)
    CALL i090_menu() 
    CLOSE WINDOW i090_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)   #No.FUN-6A0094
       
         RETURNING g_time    #No.FUN-6A0094
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
         WHEN "exporttoexcel"                                                                                          
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tsi),'','') 
            END IF
 
      END CASE                                                                  
   END WHILE  
END FUNCTION
 
FUNCTION i090_q()
   CALL i090_b_askkey()
END FUNCTION
 
FUNCTION i090_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #可新增否         #No.FUN-680137 VARCHAR(01)                      
    l_allow_delete  LIKE type_file.chr1                 #可刪除否         #No.FUN-680137 VARCHAR(01)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""  
 
    #No.TQC-650128 --start--
    LET lg_smy62 = ''
    LET lg_oay22 = ''
    #No.TQC-650128 --end--
 
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT tsi01,tsi02 ",
                       "  FROM tsi_file  WHERE tsi01 = ?", 
                       "   AND tsi02 = ? ",
                       "   FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i090_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t=0
    INPUT ARRAY g_tsi WITHOUT DEFAULTS FROM s_tsi.*                             
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
            LET g_tsi_t.* = g_tsi[l_ac].*  #BACKUP
            
            OPEN i090_bcl USING g_tsi_t.tsi01,g_tsi_t.tsi02
            IF STATUS THEN            
               CALL cl_err("OPEN i090_bcl:", STATUS, 1)         
               LET l_lock_sw = "Y" 
            ELSE 
               FETCH i090_bcl INTO g_tsi[l_ac].* 
               IF SQLCA.sqlcode THEN
                      CALL cl_err(g_tsi_t.tsi01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
               END IF
            END IF
            CALL i090_set_entry_b(p_cmd)
            CALL i090_set_no_entry_b(p_cmd)
        END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tsi[l_ac].* TO NULL      
            LET g_tsi_t.* = g_tsi[l_ac].*         #新輸入資料
            LET g_tsi_o.* = g_tsi[l_ac].*
            CALL i090_set_entry_b(p_cmd)
            CALL i090_set_no_entry_b(p_cmd)
            NEXT FIELD tsi01
 
    AFTER INSERT
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CANCEL INSERT
           END IF
 
           INSERT INTO tsi_file(tsi01,tsi02)
                         VALUES(g_tsi[l_ac].tsi01,g_tsi[l_ac].tsi02)
           IF SQLCA.sqlcode THEN                                   
#             CALL cl_err(g_tsi[l_ac].tsi01,SQLCA.sqlcode,0)       #No.FUN-660167
              CALL cl_err3("ins","tsi_file",g_tsi[l_ac].tsi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
              CANCEL INSERT   
           ELSE                                                    
              MESSAGE 'INSERT O.K'                                
              LET g_rec_b=g_rec_b+1                           
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF 
 
       AFTER FIELD tsi01
         IF NOT cl_null(g_tsi[l_ac].tsi01) THEN
            SELECT count(*) INTO l_n FROM oay_file WHERE oayslip=g_tsi[l_ac].tsi01 AND oaytype='30' 
            IF l_n=0 THEN
                CALL cl_err("","mfg9329",1)
                LET g_tsi[l_ac].tsi01=NULL
                NEXT FIELD tsi01
            END IF
         END IF
         IF NOT cl_null(g_tsi[l_ac].tsi01) THEN
            IF g_tsi[l_ac].tsi01 != g_tsi_t.tsi01 OR g_tsi_t.tsi01 IS NULL THEN
               SELECT count(*) INTO l_n FROM tsi_file WHERE tsi01=g_tsi[l_ac].tsi01
               IF l_n>0 THEN
                  CALL cl_err("","atm-310",1)
                  LET g_tsi[l_ac].tsi01=NULL
                  NEXT FIELD tsi01
               END IF
            END IF
            #No.TQC-650128 --start--
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
               SELECT oay22 INTO lg_oay22 FROM oay_file WHERE oayslip = g_tsi[l_ac].tsi01
               IF NOT cl_null(g_tsi[l_ac].tsi02) THEN
                  SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_tsi[l_ac].tsi02
                  IF lg_oay22 <> lg_smy62 THEN
                     CALL cl_err(g_tsi[l_ac].tsi01,'axm-058',0)
                     IF g_chkey = 'Y' THEN
                        NEXT FIELD tsi01
                     ELSE 
                        NEXT FIELD tsi02
                     END IF
                  END IF
                  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR
                     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN
                     CALL cl_err(g_tsi[l_ac].tsi01,'axm-058',0)
                     IF g_chkey = 'Y' THEN
                        NEXT FIELD tsi01
                     ELSE
                        NEXT FIELD tsi02
                     END IF
                  END IF
               END IF
            ELSE
               LET lg_oay22 = ''
            END IF
            #No.TQC-650128 --end--
         END IF
 
 
       AFTER FIELD tsi02
         IF NOT cl_null(g_tsi[l_ac].tsi02) THEN
            SELECT count(*) INTO l_n FROM smy_file WHERE smyslip=g_tsi[l_ac].tsi02 AND smysys='apm' AND smykind='2'
            IF l_n=0 THEN
               CALL cl_err("","mfg9329",1)
               LET g_tsi[l_ac].tsi02=NULL
               NEXT FIELD tsi02
            END IF
            #No.TQC-650128 --start--
            IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') THEN 
               SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_tsi[l_ac].tsi02
               IF NOT cl_null(g_tsi[l_ac].tsi01) THEN
                  SELECT oay22 INTO lg_oay22 FROM oay_file WHERE oayslip = g_tsi[l_ac].tsi01
                  IF lg_oay22 <> lg_smy62 THEN
                     CALL cl_err(g_tsi[l_ac].tsi02,'axm-058',0)
                     NEXT FIELD tsi02
                  END IF
                  IF (cl_null(lg_oay22) AND NOT cl_null(lg_smy62)) OR
                     (NOT cl_null(lg_oay22) AND cl_null(lg_smy62)) THEN
                     CALL cl_err(g_tsi[l_ac].tsi01,'axm-058',0)
                     NEXT FIELD tsi02
                  END IF
               END IF
            ELSE
               LET lg_smy62 = ''
            END IF
            #No.TQC-650128 --end--
         END IF
         #TQC-6A0055----------------add------------str---------
         IF NOT cl_null(g_tsi[l_ac].tsi02) THEN
            IF g_tsi[l_ac].tsi02 != g_tsi_t.tsi02 OR g_tsi_t.tsi02 IS NULL THEN
               SELECT count(*) INTO l_n FROM tsi_file WHERE tsi02=g_tsi[l_ac].tsi02
               IF l_n>0 THEN
                  CALL cl_err("","atm-310",1)
                  LET g_tsi[l_ac].tsi02=NULL
                  NEXT FIELD tsi02
               END IF
            END IF
         END IF
         #TQC-6A0055----------------add------------end---------
 
       BEFORE DELETE                            #是否取消單身
          IF NOT cl_null(g_tsi[l_ac].tsi01)                                                                                          
             AND NOT cl_null(g_tsi[l_ac].tsi02) THEN 
                IF NOT cl_delete() THEN                         
                   CANCEL DELETE                               
                END IF                                               
                IF l_lock_sw = "Y" THEN                       
                   CALL cl_err("", -263, 1)                       
                   CANCEL DELETE                     
                END IF  
                DELETE FROM tsi_file WHERE tsi01 = g_tsi_t.tsi01                                                    
                                       AND tsi02 = g_tsi_t.tsi02                                               
                IF SQLCA.sqlcode THEN
#                   CALL cl_err("",SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("del","tsi_file",g_tsi_t.tsi01,g_tsi_t.tsi02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET l_ac_t = l_ac 
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete Ok"
          END IF
          COMMIT WORK                                   
 
    ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段          
              CALL cl_err('',9001,0)                             
              LET INT_FLAG = 0                                   
              LET g_tsi[l_ac].* = g_tsi_t.*                      
              CLOSE i090_bcl                                     
              ROLLBACK WORK                                      
              EXIT INPUT                                         
           END IF                                                
 
           #No.TQC-650128 --start--                                                                                                        
           LET lg_smy62 = ''                                                                                                               
           LET lg_oay22 = ''                                                                                                               
           #No.TQC-650128 --end--
 
           IF l_lock_sw="Y" THEN                       
              CALL cl_err(g_tsi[l_ac].tsi01,-263,0)                
              LET g_tsi[l_ac].* = g_tsi_t.*            
           ELSE 
              UPDATE tsi_file 
                 SET tsi01=g_tsi[l_ac].tsi01,tsi02=g_tsi[l_ac].tsi02
              WHERE tsi01 = g_tsi_t.tsi01                                                                
                AND tsi02 = g_tsi_t.tsi02                                                                
              IF SQLCA.sqlcode THEN                     
#                CALL cl_err('upd tsi:',9050,1)             #No.FUN-660167
                 CALL cl_err3("upd","tsi_file",g_tsi_t.tsi01,g_tsi_t.tsi02,9050,"","upd tsi",1)  #No.FUN-660167
                 LET g_tsi[l_ac].* = g_tsi_t.*
                 ROLLBACK WORK
              ELSE                                       
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK
              END IF
           END IF
 
    AFTER ROW
           LET l_ac = ARR_CURR()                                
          #LET l_ac_t = l_ac     #FUN-D30034 mark                           
 
           IF INT_FLAG THEN                                
              CALL cl_err('',9001,0)                         
              LET INT_FLAG = 0                               
              IF p_cmd = 'u' THEN
                 LET g_tsi[l_ac].* = g_tsi_t.*            
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_tsi.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF        
              CLOSE i090_bcl                            
              ROLLBACK WORK                          
              EXIT INPUT                                 
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add        
           CLOSE i090_bcl
           COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i090_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(tsi01) AND l_ac > 1 THEN
                LET g_tsi[l_ac].* = g_tsi[l_ac-1].*
                NEXT FIELD tsi01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE                                                 
             WHEN INFIELD(tsi01)     #查詢訂單單別                              
               #CALL q_oay(FALSE,FALSE,g_t,'30',g_sys) RETURNING g_t  #TQC-670008
               CALL q_oay(FALSE,FALSE,g_t,'30','AXM') RETURNING g_t   #TQC-670008
               LET g_tsi[l_ac].tsi01=g_t
               DISPLAY BY NAME g_tsi[l_ac].tsi01
               NEXT FIELD tsi01
             WHEN INFIELD(tsi02)     #查詢采購單別
              #CALL q_smy(FALSE,FALSE,g_t,'apm','2') RETURNING g_t  #TQC-670008
               CALL q_smy(FALSE,FALSE,g_t,'APM','2') RETURNING g_t  #TQC-670008
               LET g_tsi[l_ac].tsi02=g_t
               DISPLAY BY NAME g_tsi[l_ac].tsi02
               NEXT FIELD tsi02
             OTHERWISE EXIT CASE
           END CASE  
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds                                               
           CALL cl_on_idle()                                                 
           CONTINUE INPUT 
 
        ON ACTION about         
         CALL cl_about()      
 
        ON ACTION help       
         CALL cl_show_help()  
 
        END INPUT
 
    CLOSE i090_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i090_b_askkey()
    CLEAR FORM
    CALL g_tsi.clear()
    CONSTRUCT g_wc2 ON tsi01,tsi02
         FROM s_tsi[1].tsi01,s_tsi[1].tsi02
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE                                                 
             WHEN INFIELD(tsi01)                                   
                #CALL q_oay(TRUE,FALSE,g_t,'30',g_sys) RETURNING g_t   #TQC-670008
                CALL q_oay(TRUE,FALSE,g_t,'30','AXM') RETURNING g_t    #TQC-670008
                LET g_tsi[1].tsi01 = g_t
                DISPLAY g_t TO s_tsi[1].tsi01        
             WHEN INFIELD(tsi02)                                   
               #CALL q_smy(TRUE,FALSE,g_t,'apm','2') RETURNING g_t  #TQC-670008
                CALL q_smy(TRUE,FALSE,g_t,'APM','2') RETURNING g_t  #TQC-670008
                LET g_tsi[1].tsi01 = g_t
                DISPLAY g_t TO s_tsi[1].tsi02
             OTHERWISE EXIT CASE   
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
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
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    LET g_sql =
        "SELECT tsi01,tsi02 ",
        " FROM tsi_file",
        " WHERE ", p_wc2 CLIPPED,                     
        " ORDER BY tsi01,tsi02 "
    PREPARE i090_pb FROM g_sql
    DECLARE tsi_curs CURSOR FOR i090_pb
 
    CALL g_tsi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tsi_curs INTO g_tsi[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
	   CALL cl_err('foreach:',STATUS,1) 
	   EXIT FOREACH 
	END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tsi.deleteElement(g_cnt)       
    MESSAGE ""
    LET g_rec_b = g_cnt-1
   #No.TQC-6C0183--begin-- add
    IF g_rec_b=0 THEN
       CALL cl_err('',100,0)
    END IF
   #No.TQC-6C0183--end-- add
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i090_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_tsi TO s_tsi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
 
      ON ACTION close
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
 
FUNCTION i090_out()
    DEFINE
        l_tsi           RECORD LIKE tsi_file.*,
        l_name          LIKE type_file.chr20                         #No.FUN-680137 VARCHAR(20)
    
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('',-400,0) RETURN 
#    END IF
   IF cl_null(g_wc2) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL cl_wait()
    CALL cl_outnam('axmi090') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM tsi_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i090_p1 FROM g_sql                  
    DECLARE i090_co                           
        CURSOR FOR i090_p1
 
    START REPORT i090_rep TO l_name
 
    FOREACH i090_co INTO l_tsi.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i090_rep(l_tsi.*)
    END FOREACH
 
    FINISH REPORT i090_rep
 
    CLOSE i090_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i090_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,            #No.FUN-680137 VARCHAR(1)
        sr RECORD LIKE tsi_file.*
 
    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.tsi01,sr.tsi02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
 
            PRINT g_x[31],g_x[32]
                     
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.tsi01 CLIPPED,
                  COLUMN g_c[32],sr.tsi02 CLIPPED 
 
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
 
FUNCTION i090_set_entry_b(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1            #No.FUN-680137 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("tsi01",TRUE)                                                                                         
   END IF                                                                                                                           
END FUNCTION           
 
FUNCTION i090_set_no_entry_b(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1            #No.FUN-680137 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("tsi01",FALSE)                                                                                        
   END IF                                                                                                                           
END FUNCTION     
 
 
 
 
