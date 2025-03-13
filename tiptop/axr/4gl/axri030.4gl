# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axri030.4gl
# Descriptions...: 帳齡及備抵呆帳提列率維護作業
# Date & Author..: 95/03/06 By Danny
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0100 05/01/05 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-5A0026 05/10/05 By Smapmin 無法輸入帳齡類別
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-770015 07/07/03 By Rayven 天數,計提率不可為負數
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.TQC-930046 09/03/11 By mike 沒有cn3欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B10046 11/01/07 By Dido 各段天數需大於 0 
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_omi           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    omi01    LIKE omi_file.omi01,
                    omi11    LIKE omi_file.omi11,
                    omi21    LIKE omi_file.omi21,
                    omi12    LIKE omi_file.omi12,
                    omi22    LIKE omi_file.omi22,
                    omi13    LIKE omi_file.omi13,
                    omi23    LIKE omi_file.omi23,
                    omi14    LIKE omi_file.omi14,
                    omi24    LIKE omi_file.omi24,
                    omi15    LIKE omi_file.omi15,
                    omi25    LIKE omi_file.omi25,
                    omi16    LIKE omi_file.omi16,
                    omi26    LIKE omi_file.omi26
                    END RECORD,
    g_omi_t         RECORD                 #程式變數 (舊值)
                    omi01    LIKE omi_file.omi01,
                    omi11    LIKE omi_file.omi11,
                    omi21    LIKE omi_file.omi21,
                    omi12    LIKE omi_file.omi12,
                    omi22    LIKE omi_file.omi22,
                    omi13    LIKE omi_file.omi13,
                    omi23    LIKE omi_file.omi23,
                    omi14    LIKE omi_file.omi14,
                    omi24    LIKE omi_file.omi24,
                    omi15    LIKE omi_file.omi15,
                    omi25    LIKE omi_file.omi25, 
                    omi16    LIKE omi_file.omi16,
                    omi26    LIKE omi_file.omi26
                    END RECORD,
    g_wc2,g_sql     STRING,                   #No.FUN-580092 HCN    
    g_rec_b         LIKE type_file.num5,      #單身筆數      #No.FUN-680123 SMALLINT
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT  #No.FUN-680123 SMALLINT
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL      
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680123 INTEGER
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680123 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-570108   #No.FUN-680123 SMALLINT
 
MAIN
    OPTIONS                                         #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                 #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0095
 
    OPEN WINDOW i030_w WITH FORM "axr/42f/axri030"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i030_b_fill(g_wc2)
    CALL i030_menu()
    CLOSE WINDOW i030_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0095
END MAIN
 
FUNCTION i030_menu()
 
   WHILE TRUE
      CALL i030_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i030_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i030_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_omi),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i030_q()
   CALL i030_b_askkey()
END FUNCTION
 
FUNCTION i030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT #No.FUN-680123 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用        #No.FUN-680123 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否        #No.FUN-680123 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態          #No.FUN-680123 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT omi01,omi11,omi21,omi12,omi22,omi13,",
                       " omi23,omi14,omi24,omi15,omi25,omi16,omi26 ",
                       " FROM omi_file WHERE omi01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_omi WITHOUT DEFAULTS FROM s_omi.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac) 
         END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
           #DISPLAY l_ac TO FORMONLY.cn3  #TQC-930046
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_omi_t.omi01 IS NOT NULL THEN
               LET p_cmd='u'
               LET g_omi_t.* = g_omi[l_ac].*  #BACKUP
#No.FUN-570108 --start--                                                        
               LET g_before_input_done = FALSE                                  
               CALL i030_set_entry(p_cmd)                                       
               CALL i030_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570108 --end--           
               BEGIN WORK
               OPEN i030_bcl USING g_omi_t.omi01
               IF STATUS THEN
                  CALL cl_err("OPEN i030_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i030_bcl INTO g_omi[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_omi_t.omi01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_omi[l_ac].* TO NULL      #900423
            LET g_omi_t.* = g_omi[l_ac].*         #新輸入資料
#MOD-5A0026
            LET g_before_input_done = FALSE                                  
            CALL i030_set_entry(p_cmd)                                       
            CALL i030_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE                                   
#END MOD-5A0026
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD omi01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT 
         END IF
         INSERT INTO omi_file(omi01,omi11,omi12,omi13,omi14,
                              omi15,omi21,omi22,omi23,omi24,
                              omi25,omi16,omi26)
         VALUES(g_omi[l_ac].omi01,g_omi[l_ac].omi11,
                g_omi[l_ac].omi12,g_omi[l_ac].omi13,
                g_omi[l_ac].omi14,g_omi[l_ac].omi15,
                g_omi[l_ac].omi21,g_omi[l_ac].omi22,
                g_omi[l_ac].omi23,g_omi[l_ac].omi24,
                g_omi[l_ac].omi25,g_omi[l_ac].omi16,
                g_omi[l_ac].omi26)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_omi[l_ac].omi01,SQLCA.sqlcode,0)   #No.FUN-660116
             CALL cl_err3("ins","omi_file",g_omi[l_ac].omi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD omi01                        #check 編號是否重複
           IF NOT cl_null(g_omi[l_ac].omi01) THEN
           IF g_omi[l_ac].omi01 != g_omi_t.omi01 OR
           (NOT cl_null(g_omi[l_ac].omi01) AND cl_null(g_omi_t.omi01)) THEN
                SELECT count(*) INTO l_n FROM omi_file
                    WHERE omi01 = g_omi[l_ac].omi01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_omi[l_ac].omi01 = g_omi_t.omi01
                    NEXT FIELD omi01
                END IF
            END IF
            END IF
 
        #No.TQC-770015 --start--                                                                                                    
        AFTER FIELD omi11                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi11) THEN                                                                                   
              IF g_omi[l_ac].omi11 <= 0 THEN       #MOD-B10046 mod < 0 -> <= 0                                                                                        
                 CALL cl_err('','axr-958',1)       #MOD-B10046 mod mfg4012 -> axr-958 
                 NEXT FIELD omi11                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi21                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi21) THEN                                                                                   
              IF g_omi[l_ac].omi21 < 0 THEN                                                                                         
                 CALL cl_err('','mfg4012',1)                                                                                        
                 NEXT FIELD omi21                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi12                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi12) THEN                                                                                   
              IF g_omi[l_ac].omi12 <= 0 THEN       #MOD-B10046 mod < 0 -> <= 0                                                                                        
                 CALL cl_err('','axr-958',1)       #MOD-B10046 mod mfg4012 -> axr-958 
                 NEXT FIELD omi12                                                                                                   
              END IF
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi22                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi22) THEN                                                                                   
              IF g_omi[l_ac].omi22 < 0 THEN                                                                                         
                 CALL cl_err('','mfg4012',1)                                                                                        
                 NEXT FIELD omi22                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi13                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi13) THEN                                                                                   
              IF g_omi[l_ac].omi13 <= 0 THEN       #MOD-B10046 mod < 0 -> <= 0                                                                                        
                 CALL cl_err('','axr-958',1)       #MOD-B10046 mod mfg4012 -> axr-958 
                 NEXT FIELD omi13                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi23                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi23) THEN                                                                                   
              IF g_omi[l_ac].omi23 < 0 THEN                                                                                         
                 CALL cl_err('','mfg4012',1)                                                                                        
                 NEXT FIELD omi23
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi14                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi14) THEN                                                                                   
              IF g_omi[l_ac].omi14 <= 0 THEN       #MOD-B10046 mod < 0 -> <= 0                                                                                        
                 CALL cl_err('','axr-958',1)       #MOD-B10046 mod mfg4012 -> axr-958 
                 NEXT FIELD omi14                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi24                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi24) THEN                                                                                   
              IF g_omi[l_ac].omi24 < 0 THEN                                                                                         
                 CALL cl_err('','mfg4012',1)                                                                                        
                 NEXT FIELD omi24                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi15                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi15) THEN                                                                                   
              IF g_omi[l_ac].omi15 <= 0 THEN       #MOD-B10046 mod < 0 -> <= 0                                                                                        
                 CALL cl_err('','axr-958',1)       #MOD-B10046 mod mfg4012 -> axr-958 
                 NEXT FIELD omi15                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi25                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi25) THEN                                                                                   
              IF g_omi[l_ac].omi25 < 0 THEN                                                                                         
                 CALL cl_err('','mfg4012',1)                                                                                        
                 NEXT FIELD omi25                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi16                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi16) THEN                                                                                   
              IF g_omi[l_ac].omi16 <= 0 THEN       #MOD-B10046 mod < 0 -> <= 0                                                                                        
                 CALL cl_err('','axr-958',1)       #MOD-B10046 mod mfg4012 -> axr-958 
                 NEXT FIELD omi16                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD omi26                                                                                                           
           IF NOT cl_null(g_omi[l_ac].omi26) THEN                                                                                   
              IF g_omi[l_ac].omi26 < 0 THEN
                 CALL cl_err('','mfg4012',1)                                                                                        
                 NEXT FIELD omi26                                                                                                   
              END IF                                                                                                                
           END IF                                                                                                                   
        #No.TQC-770015 --end--
 
        BEFORE DELETE                            #是否取消單身
            IF g_omi_t.omi01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM omi_file WHERE omi01 = g_omi_t.omi01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_omi_t.omi01,SQLCA.sqlcode,0)   #No.FUN-660116
                   CALL cl_err3("del","omi_file",g_omi_t.omi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i030_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_omi[l_ac].* = g_omi_t.*
              CLOSE i030_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_omi[l_ac].omi01,-263,1)
              LET g_omi[l_ac].* = g_omi_t.*
           ELSE
              UPDATE omi_file
                 SET omi01=g_omi[l_ac].omi01,omi11=g_omi[l_ac].omi11,
                     omi12=g_omi[l_ac].omi12,omi13=g_omi[l_ac].omi13,
                     omi14=g_omi[l_ac].omi14,omi15=g_omi[l_ac].omi15,
                     omi21=g_omi[l_ac].omi21,omi22=g_omi[l_ac].omi22,
                     omi23=g_omi[l_ac].omi23,omi24=g_omi[l_ac].omi24,
                     omi25=g_omi[l_ac].omi25,omi16=g_omi[l_ac].omi16,
                     omi26=g_omi[l_ac].omi26
              WHERE omi01=g_omi_t.omi01
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_omi[l_ac].omi01,SQLCA.sqlcode,0)   #No.FUN-660116
                  CALL cl_err3("upd","omi_file",g_omi_t.omi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
                  LET g_omi[l_ac].* = g_omi_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                  LET g_omi[l_ac].* = g_omi_t.*                                    
               #FUN-D30032--add--str--
               ELSE
                  CALL g_omi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i030_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i030_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i030_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(omi01) AND l_ac > 1 THEN
                LET g_omi[l_ac].* = g_omi[l_ac-1].*
                NEXT FIELD omi01
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
 
    CLOSE i030_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i030_b_askkey()
    CLEAR FORM
    CALL g_omi.clear()
    CONSTRUCT g_wc2 ON omi01,omi11,omi21,omi12,omi22,omi13,
                       omi23,omi14,omi24,omi15,omi25,omi16,omi26
            FROM s_omi[1].omi01,s_omi[1].omi11,s_omi[1].omi21,
                 s_omi[1].omi12,s_omi[1].omi22,s_omi[1].omi13,
                 s_omi[1].omi23,s_omi[1].omi14,s_omi[1].omi24,
                 s_omi[1].omi15,s_omi[1].omi25,s_omi[1].omi16,
                 s_omi[1].omi26 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    CALL i030_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i030_b_fill(p_wc2)                   #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(200)
 
    LET g_sql =
        "SELECT omi01,omi11,omi21,omi12,omi22,omi13,omi23,omi14,",
        "       omi24,omi15,omi25,omi16,omi26 ",
        " FROM omi_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY omi01"
    PREPARE i030_pb FROM g_sql
    DECLARE omi_curs CURSOR FOR i030_pb
 
    CALL g_omi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH omi_curs INTO g_omi[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_omi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omi TO s_omi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start-- 
FUNCTION i030_out()
    DEFINE
        l_omi           RECORD LIKE omi_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680123 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680123 VARCHAR(20)  # External(Disk) file name
        l_za05          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(40)
    DEFINE l_cmd        LIKE type_file.chr1000   #No.FUN-7C0043 
  
    IF g_wc2 IS NULL THEN 
   #   CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    LET l_cmd = 'p_query "axri030" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN 
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM omi_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i030_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i030_co                         # SCROLL CURSOR
#        CURSOR FOR i030_p1
#   CALL cl_outnam('axri030') RETURNING l_name
#   START REPORT i030_rep TO l_name
 
#   FOREACH i030_co INTO l_omi.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i030_rep(l_omi.*)
#   END FOREACH
 
#   FINISH REPORT i030_rep
 
#   CLOSE i030_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i030_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(1) 
#       g_head1         STRING,
#       sr RECORD LIKE omi_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.omi01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#          PRINT  COLUMN g_c[31],sr.omi01,
#                 COLUMN g_c[32],sr.omi11 USING '#########&', 
#                 COLUMN g_c[33],sr.omi21 USING '########&.&&', 
#                 COLUMN g_c[34],sr.omi12 USING '#########&', 
#                 COLUMN g_c[35],sr.omi22 USING '########&.&&', 
#                 COLUMN g_c[36],sr.omi13 USING '#########&', 
#                 COLUMN g_c[37],sr.omi23 USING '########&.&&', 
#                 COLUMN g_c[38],sr.omi14 USING '#########&', 
#                 COLUMN g_c[39],sr.omi24 USING '########&.&&', 
#                 COLUMN g_c[40],sr.omi15 USING '#########&', 
#                 COLUMN g_c[41],sr.omi25 USING '########&.&&', 
#                 COLUMN g_c[42],sr.omi16 USING '#########&', 
#                 COLUMN g_c[43], sr.omi26 USING '########&.&&' 
#       ON LAST ROW
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
#No.FUN-7C0043--end--
 
#No.FUN-570108 --start--                                                        
FUNCTION i030_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680123 VARCHAR(01)                                                            #No.FUN-680123
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("omi01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i030_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680123 VARCHAR(01)                                                          #No.FUN-680123
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("omi01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--            
