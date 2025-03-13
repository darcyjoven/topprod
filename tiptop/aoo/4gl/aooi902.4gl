# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aooi902.4gl
# Descriptions...: 工廠使用系統關連性設定
# Date & Author..: 92/08/31 By LYS
# Modify.........: No.TQC-660018 06/06/06 By Smampin 簡體環境下,列印的Action應為打印
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0080 06/11/21 By cl     1.修改程序，增加bp(),q(),askkey()等程序段。
# Modify.........:                                  2.增加對欄位azr01控制。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_azp          RECORD LIKE azp_file.*,
    g_azp_t        RECORD LIKE azp_file.*,
    g_azp01_t      LIKE azp_file.azp01,
    g_wc,g_sql     STRING,  #No.FUN-580092 HCN   
    g_ac,g_sl      LIKE type_file.num5,               #No.FUN-680102 SMALLINT,
    g_cnt          LIKE type_file.num5,               #No.FUN-680102 SMALLINT,
    g_azr          DYNAMIC ARRAY OF RECORD
                        azr01	LIKE azr_file.azr01,
                        azr02	LIKE azr_file.azr02,
                        azr03	LIKE azr_file.azr03,
                        azr04	LIKE azr_file.azr04
                   END RECORD,
    g_azr_t        RECORD
                        azr01	LIKE azr_file.azr01,
                        azr02	LIKE azr_file.azr02,
                        azr03	LIKE azr_file.azr03,
                        azr04	LIKE azr_file.azr04
                   END RECORD,
    g_rec_b        LIKE type_file.num5,         #No.FUN-680102 SMALLINT
    g_forupd_sql   STRING                       #No.TQC-6B0080 
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680102 SMALLINT
#       l_time          LIKE type_file.chr8              #No.FUN-6A0081
 
    OPTIONS
	HELP	FILE "aoo/hlp/aooi902.hlp",
        INPUT NO WRAP
    DEFER INTERRUPT
 
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
    #LET g_lang = '0'   #TQC-660018
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
    LET p_row = 3 LET p_col = 10
    OPEN WINDOW aooi902_w AT p_row,p_col
        WITH FORM "aoo/42f/aooi902" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc = '1=1'      #No.TQC-6B0080  
    CALL i902_b_fill(g_wc)#No.TQC-6B0080 
   #CALL aooi902_b()      #No.TQC-6B0080 mark
    CALL i902_menu()      #No.TQC-6B0080
    CLOSE WINDOW aooi902_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
#No.TQC-6B0080--begin-- add
FUNCTION i902_menu()
 
  WHILE TRUE
    CALL i902_bp("G")
    CASE g_action_choice                                                                                                          
         WHEN "query"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i902_q()                                                                                                        
            END IF                                                                                                                  
         WHEN "detail"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i902_b()                                                                                                        
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azr),'','')  
            END IF                                                                                                                  
      END CASE 
  END WHILE
 
END FUNCTION
 
FUNCTION i902_q()
    CALL i902_b_askkey() 
END FUNCTION
 
FUNCTION i902_b_askkey()
 
    CLEAR FORM
    CALL g_azr.clear()
 
    CONSTRUCT g_wc  ON azr01,azr02,azr03,azr04 
         FROM s_azr[1].azr01,s_azr[1].azr02,s_azr[1].azr03,s_azr[1].azr04
 
      BEFORE CONSTRUCT                                                                                                              
         CALL cl_qbe_init()                                                                                                         
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE CONSTRUCT                                                                                                         
                                                                                                                                    
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
      ON ACTION help                                                                                                                
         CALL cl_show_help()                                                                                                        
  
      ON ACTION controlg                                                                                                            
         CALL cl_cmdask()
    END CONSTRUCT                                                                                                                    
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
                                                                                                                                    
    IF INT_FLAG THEN                                                                                                                 
       LET INT_FLAG = 0                                                                                                              
       RETURN                                                                                                                        
    END IF                                                                                                                           
                                                                                                                                    
    
    CALL i902_b_fill(g_wc) 
    
END FUNCTION
 
FUNCTION i902_b_fill(p_wc)
DEFINE p_wc       STRING
 
    LET g_sql=" SELECT * FROM azr_file WHERE ",g_wc CLIPPED
    PREPARE i902_pb FROM g_sql
    DECLARE azr_cs CURSOR FOR i902_pb
    CALL g_azr.clear()
    
    LET g_cnt=1
    
    MESSAGE "Searching!"
    FOREACH azr_cs INTO g_azr[g_cnt].*    #單身填充
       IF STATUS THEN
          CALL cl_err("foreach:",STATUS,1)
          EXIT FOREACH
       END IF
        
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN                                                                                                     
          CALL cl_err( '', 9035, 0 )                                                                                                 
          EXIT FOREACH                                                                                                               
       END IF 
    END FOREACH
    CALL g_azr.deleteElement(g_cnt)                                                                                                  
    MESSAGE ""                                                                                                                       
    LET g_rec_b = g_cnt-1                                                                                                            
    DISPLAY g_rec_b 
    LET g_cnt = 0  
 
END FUNCTION
 
FUNCTION i902_bp(p_ud)
    DEFINE p_ud       LIKE type_file.chr1
 
    IF p_ud<>'G' OR g_action_choice="detail" THEN
       RETURN
    END IF
 
    LET g_action_choice=" "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)                                                                                  
    DISPLAY ARRAY g_azr TO s_azr.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW                                                                                                                    
         LET g_ac = ARR_CURR()                                                                                                      
         CALL cl_show_fld_cont()                                                                                                    
                                                                                                                                    
      ON ACTION query                  
         LET g_action_choice="query"   
         EXIT DISPLAY                  
      ON ACTION detail                 
         LET g_action_choice="detail"  
         LET g_ac = 1                  
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
         LET g_ac = ARR_CURR()          
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
#No.TQC-6B0080--end-- add
 
#FUNCTION aooi902_b()                                    #No.TQC-6B0080 mark  
FUNCTION i902_b()                                        #No.TQC-6B0080    
 DEFINE   l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)            #可新增否
          l_allow_delete  LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)           #可刪除否
 DEFINE   g_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT    #No.TQC-6B0080                                                    
          l_n             LIKE type_file.num5,           #檢查重復用           #No.TQC-6B0080                                                    
          l_lock_sw       LIKE type_file.chr1,           #單身鎖住否           #No.TQC-6B0080                                                    
          p_cmd           LIKE type_file.chr1            #處理狀態             #No.TQC-6B0080                                                    
 
    LET g_action_choice = ""                                                                                                         
    IF s_shut(0) THEN RETURN END IF                                                                                                  
    CALL cl_opmsg('b')  
 
    LET g_forupd_sql=" SELECT * FROM azr_file ",
                     " WHERE azr01=? AND azr02=? AND azr03=? AND azr04=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i902_bcl CURSOR FROM g_forupd_sql           #Lock Cursor    
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    DISPLAY 'aooi902_b()'
  # DECLARE aooi902_bc CURSOR WITH HOLD FOR
  #No.TQC-6B0080--begin-- mark
  # DECLARE aooi902_bc CURSOR FOR
  #         SELECT azr01,azr02,azr03,azr04 FROM azr_file
  #          ORDER BY azr01,azr02
  # CALL g_azr.clear()
  # LET g_ac = 1
  # FOREACH aooi902_bc INTO g_azr[g_ac].*
  #     LET g_ac = g_ac + 1
  # END FOREACH
  # LET g_rec_b = g_ac - 1
  # DISPLAY g_rec_b
  # CALL set_count(g_ac-1)
  #No.TQC-6B0080--end-- mark
 
    INPUT ARRAY g_azr WITHOUT DEFAULTS FROM s_azr.*  
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(g_ac)
           END IF
 
     ##No.TQC-6B0080--begin-- mark
     # BEFORE ROW
     #    LET g_ac = ARR_CURR()
     #    DISPLAY g_ac
     #    CALL cl_show_fld_cont()     #FUN-550037(smin)
     ##No.TQC-6B0080--end-- mark
 
     ##No.TQC-6B0080--begin-- add
       BEFORE ROW
          LET p_cmd = ''  
          LET g_ac = ARR_CURR()     
          LET l_lock_sw = 'N'            #DEFAULT 
          LET l_n  = ARR_COUNT()   
          LET g_success = 'Y'    
          IF g_rec_b >= g_ac THEN
             LET g_azr_t.* = g_azr[g_ac].*      #BACKUP
             LET p_cmd='u'
             BEGIN WORK
             OPEN i902_bcl 
               USING g_azr[g_ac].azr01,g_azr[g_ac].azr02,g_azr[g_ac].azr03,g_azr[g_ac].azr04
             IF STATUS THEN
                CALL cl_err("OPEN i902_bcl:",STATUS,1)
                LET l_lock_sw = 'Y'
             ELSE
                FETCH i902_bcl INTO g_azr[g_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_azr_t.azr01,SQLCA.sqlcode,1)
                   LET l_lock_sw = 'Y'
                END IF
                CALL i902_b_fill(g_wc)
             END IF
             CALL cl_show_fld_cont()
          END IF
 
       BEFORE INSERT
          LET l_n= ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_azr[g_ac].* TO NULL                                                                                           
          LET g_azr_t.* = g_azr[g_ac].*         #新輸入資料                                                                          
 
          CALL cl_show_fld_cont()                                                                                                    
          NEXT FIELD azr01     
      
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             CANCEL INSERT
          END IF
          INSERT INTO azr_file(azr01,azr02,azr03,azr04)
                 VALUES(g_azr[g_ac].azr01,g_azr[g_ac].azr02,
                        g_azr[g_ac].azr03,g_azr[g_ac].azr04)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","azr_file",g_azr[g_ac].azr01,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K!'
             LET g_rec_b=g_rec_b+1
          END IF
     ##No.TQC-6B0080--end-- add 
 
       AFTER FIELD azr01
          IF g_azr[g_ac].azr01 IS NOT NULL THEN
             DISPLAY 'AFTER FIELD azr01'
           ##No.TQC-6B0080--begin-- mark
           # SELECT azp01 
           #   FROM azp_file 
           #  WHERE azp01 = g_azr[g_ac].azr01 
           # IF SQLCA.sqlcode THEN
           #    DISPLAY '錯誤'
           #    ERROR '(error no:',SQLCA.sqlcode,') Wrong Plant Code !'
           # END IF
           ##No.TQC-6B0080--end-- mark
           ##No.TQC-6B0080--begin-- add
             CALL i902_azr01(g_azr[g_ac].azr01)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_azr[g_ac].azr01,g_errno,1)
                NEXT FIELD azr01
             END IF
           ##No.TQC-6B0080--end-- add
          END IF
          DISPLAY 'AFTER FIELD azr01 end'
{-->genero拿掉azq部份 
       AFTER FIELD azr02
          IF g_azr[g_ac].azr02 IS NOT NULL THEN
             SELECT azq01 FROM azq_file
                WHERE azq01 = g_azr[g_ac].azr01 AND azq03 = g_azr[g_ac].azr02
             IF SQLCA.sqlcode THEN
                ERROR '(error no:',SQLCA.sqlcode,') Wrong Plant-Sys Code !'
                NEXT FIELD azr01
             END IF
          END IF
}
       AFTER FIELD azr03
          IF g_azr[g_ac].azr03 IS NOT NULL THEN
           ##No.TQC-6B0080--begin-- mark
           # SELECT azp01 FROM azp_file WHERE azp01 = g_azr[g_ac].azr03 
           # IF SQLCA.sqlcode THEN
           #    ERROR '(error no:',SQLCA.sqlcode,') Wrong Plant Code !'
           #    NEXT FIELD azr03
           # END IF
           ##No.TQC-6B0080--end-- mark
           ##No.TQC-6B0080--begin-- add
             CALL i902_azr01(g_azr[g_ac].azr03)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_azr[g_ac].azr03,g_errno,1)
                NEXT FIELD azr03
             END IF
           ##No.TQC-6B0080--end-- add
          END IF
{-->genero拿掉azq部份
       AFTER FIELD azr04
          IF g_azr[g_ac].azr04 IS NOT NULL THEN
             SELECT azq01 FROM azq_file
                WHERE azq01 = g_azr[g_ac].azr03 AND azq03 = g_azr[g_ac].azr04
             IF SQLCA.sqlcode THEN
                ERROR '(error no:',SQLCA.sqlcode,') Wrong Plant-Sys Code !'
                NEXT FIELD azr03
             END IF
          END IF
}
    #No.TQC-6B0080--begin-- add
    BEFORE DELETE
       IF NOT cl_null(g_azr_t.azr01) THEN
          IF NOT cl_delete() THEN
             CANCEL DELETE
          END IF
          IF l_lock_sw='Y' THEN
             CALL cl_err('',-263,1)
             CANCEL DELETE
          END IF
          DELETE FROM  azr_file 
           WHERE azr01= g_azr_t.azr01 AND azr02=g_azr_t.azr02
             AND azr03= g_azr_t.azr03 AND azr04=g_azr_t.azr04
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","azr_file",g_azr_t.azr01,g_azr_t.azr02,SQLCA.sqlcode,"","",1)
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b=g_rec_b-1
          DISPLAY g_rec_b
          MESSAGE "DELETE O.K!"
          CLOSE i902_bcl
          COMMIT WORK
       END IF
 
    ON ROW CHANGE
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          LET g_azr[g_ac].*=g_azr_t.*
          CALL i902_b_fill(g_wc)
          CLOSE i902_bcl
          ROLLBACK WORK
          EXIT INPUT
       END IF 
       IF l_lock_sw='Y' THEN
          CALL cl_err(g_azr[g_ac].azr01,-263,1)
          LET g_azr[g_ac].*=g_azr_t.*
       ELSE
          UPDATE azr_file SET
                 azr01=g_azr[g_ac].azr01,azr02=g_azr[g_ac].azr02,
                 azr03=g_azr[g_ac].azr03,azr04=g_azr[g_ac].azr04
          WHERE azr01=g_azr_t.azr01 AND azr02=g_azr_t.azr02
            AND azr03=g_azr_t.azr03 AND azr04=g_azr_t.azr04
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","azr_file",g_azr_t.azr01,g_azr_t.azr02,SQLCA.sqlcode,"","",1)
             LET g_azr[g_ac].* = g_azr_t.*
          END IF
       END IF
 
 
    AFTER ROW
       LET g_ac = ARR_CURR()
       #LET g_ac_t=g_ac  #FUN-D40030
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          #FUN-D40030--add--str--
          IF p_cmd='u' THEN 
             LET g_azr[g_ac].* = g_azr_t.*
          ELSE
             CALL g_azr.deleteElement(g_ac)
             IF g_rec_b != 0 THEN
                LET g_action_choice = "detail"
                LET g_ac = g_ac_t
             END IF
          END IF
          #FUN-D40030--add--end--
          CLOSE i902_bcl
          ROLLBACK WORK
          EXIT INPUT
       END IF
       LET g_ac_t=g_ac  #FUN-D40030
       CLOSE i902_bcl
       COMMIT WORK
    #No.TQC-6B0080--end-- add
    
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
   #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM END IF   #No.TQC-6B0080 mark
  ##No.TQC-6B0080--begin-- mark
  # DELETE FROM azr_file
  # FOR g_ac = 1 TO 100
  #    IF g_azr[g_ac].azr01 IS NULL OR g_azr[g_ac].azr01 = ' '
  #       THEN CONTINUE FOR
  #    END IF
  #    INSERT INTO azr_file(azr01, azr02, azr03, azr04)
  #                VALUES (g_azr[g_ac].*)
  # END FOR
  ##No.TQC-6B0080--end-- mark
  ##No.TQC-6B0080--begin-- add
    CLOSE i902_bcl
    COMMIT WORK
  ##No.TQC-6B0080--end-- add
END FUNCTION
 
#No.TQC-6B0080--begin-- add
FUNCTION i902_azr01(p_azr01)
DEFINE p_azr01       LIKE azr_file.azr01
 
    LET g_errno=''
    SELECT azp01 FROM azp_file 
     WHERE azp01 = p_azr01
    CASE
      WHEN SQLCA.sqlcode=100  LET g_errno="aap-025"
      OTHERWISE               LET g_errno=SQLCA.sqlcode  USING '------'
    END CASE
 
END FUNCTION
#No.TQC-6B0080--end-- add
