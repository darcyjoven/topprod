# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: abgi008.4gl
# Descriptions...: 勞健保費率維護作業
# Date & Author..: 02/09/25 By qazzaq
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660105 06/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-710058 07/02/05 By jamie 放寬項次位數
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770033 07/07/10 BY destiny 報表改為使用crystal report
# Modify.........: No.TQC-970281 09/07/27 By Carrier 非負控制
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bgt          DYNAMIC ARRAY of RECORD #程式變數(Program Variables)
     bgt01      LIKE bgt_file.bgt01,    #薪資級距
        bgt02      LIKE bgt_file.bgt02,    #同上
        bgt03      LIKE bgt_file.bgt03,    #勞保費
        bgt04      LIKE bgt_file.bgt04     #健保費
                    END RECORD,
    g_bgt_t        RECORD                  #程式變數 (舊值)
     bgt01      LIKE bgt_file.bgt01,    #薪資級距
        bgt02      LIKE bgt_file.bgt02,    #同上
        bgt03      LIKE bgt_file.bgt03,    #勞保費
        bgt04      LIKE bgt_file.bgt04     #健保費
                    END RECORD,
     g_wc2,g_sql   string,  #No.FUN-580092 HCN
    g_rec_b        LIKE type_file.num5,    #單身筆數 #No.FUN-680061 SMALLINT
    l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done  LIKE type_file.num5   #No.FUN-680061 SMALLINT
                                                                                
DEFINE g_cnt         LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg         LIKE ze_file.ze03     #No.FUN-680061 VARCHAR(72)
DEFINE p_row,p_col   LIKE type_file.num5   #No.FUN-680061 SMALLINT
DEFINE g_str         STRING                #No.FUN-770033
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0056
DEFINE p_row,p_col   LIKE type_file.num5   #No.FUN-680061  SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
                                                                                
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ABG")) THEN                                               
       EXIT PROGRAM                                                             
    END IF                     
 
      CALL  cl_used(g_prog,g_time,1)        #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
    LET p_row = 4 LET p_col = 10
 
    OPEN WINDOW i008_w AT p_row,p_col WITH FORM "abg/42f/abgi008"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)                                          #No.FUN-580092 HCN
    CALL cl_ui_init()
 
#    CALL i008_b_fill(' 1=1')
#    CALL i008_bp('D')
    CALL i008_menu()    #中文
 
    CLOSE WINDOW i008_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
FUNCTION i008_menu()
   WHILE TRUE                                                                   
      CALL i008_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i008_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i008_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i008_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgt),'','')
            END IF
      END CASE                                                                  
   END WHILE  
END FUNCTION
 
FUNCTION i008_q()
   CALL i008_b_askkey()
END FUNCTION
 
FUNCTION i008_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_bgt           RECORD LIKE bgt_file.*,#檢查重覆
    l_n             LIKE type_file.num5,   #檢查重複用 #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否 #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,   #處理狀態   #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,   #可新增否   #No.FUN-680061 VARCHAR(01)                      
    l_allow_delete  LIKE type_file.num5    #可刪除否   #No.FUN-680061 VARCHAR(01)                     
                                                                                
    LET g_action_choice = ""      
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql=" SELECT bgt01,bgt02,bgt03,bgt04 FROM bgt_file",
                     "   WHERE bgt01=?  AND bgt02=?",
                     "    FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i008_bcl CURSOR FROM g_forupd_sql
 
 
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')   
 
        INPUT ARRAY g_bgt WITHOUT DEFAULTS FROM s_bgt.*
            ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,             
                       INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,   
                       APPEND ROW = l_allow_insert)
        BEFORE INPUT                                                            
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF                                                              
                                                                                
        BEFORE ROW                                                              
            LET p_cmd=''                                                        
            LET l_ac = ARR_CURR()                                               
            LET l_lock_sw = 'N'            #DEFAULT                             
            LET l_n  = ARR_COUNT()                                              
#No.FUN-570108--begin                                                           
            LET p_cmd='u'                                                    
            LET g_before_input_done = FALSE                                  
            CALL i008_set_entry(p_cmd)                                       
            CALL i008_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE                                   
#No.FUN-570108--end                                     
            BEGIN WORK                                                          
            IF g_rec_b>=l_ac THEN
            #IF (g_bgt_t.bgt01 !=0 AND g_bgt_t.bgt02 !=0) OR
            #   (g_bgt_t.bgt01 =0  AND g_bgt_t.bgt02 !=0) THEN
               LET p_cmd='u'
               LET g_bgt_t.* = g_bgt[l_ac].*  #BACKUP
               OPEN i008_bcl USING g_bgt_t.bgt01,g_bgt_t.bgt02
               IF STATUS THEN                                                  
                  CALL cl_err("OPEN i008_bcl:", STATUS, 1)                     
                  LET l_lock_sw = "Y"                                          
               ELSE     
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bgt_t.bgt01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  FETCH i008_bcl INTO g_bgt[l_ac].* 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD bgt01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108--begin                                                           
            LET g_before_input_done = FALSE                                      
            CALL i008_set_entry(p_cmd)                                           
            CALL i008_set_no_entry(p_cmd)                                        
            LET g_before_input_done = TRUE                                       
#No.FUN-570108--end          
            INITIALIZE g_bgt[l_ac].* TO NULL      #900423
            LET g_bgt_t.* = g_bgt[l_ac].*         #新輸入資料
            LET g_bgt[l_ac].bgt03=0
            LET g_bgt[l_ac].bgt04=0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bgt01
 
        AFTER INSERT                                                            
           IF INT_FLAG THEN                                                     
              CALL cl_err('',9001,0)                                            
              LET INT_FLAG = 0                                                  
              CANCEL INSERT                                                     
           END IF 
           INSERT INTO bgt_file(bgt01,bgt02,bgt03,bgt04,bgtoriu,bgtorig)
           VALUES(g_bgt[l_ac].bgt01,g_bgt[l_ac].bgt02,
                  g_bgt[l_ac].bgt03,g_bgt[l_ac].bgt04, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgt[l_ac].bgt01,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("ins","bgt_file",g_bgt[l_ac].bgt01,g_bgt[l_ac].bgt02,SQLCA.sqlcode,"","",1) #FUN-660105
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               COMMIT WORK
           END IF
 
        AFTER FIELD bgt01                        #check 編號是否重複
            IF NOT cl_null(g_bgt[l_ac].bgt01) THEN
               IF g_bgt[l_ac].bgt01 != g_bgt_t.bgt01 OR
                  cl_null(g_bgt_t.bgt01) THEN
                  #No.TQC-970281  --Begin
                  IF g_bgt[l_ac].bgt01 < 0 THEN
                     CALL cl_err(g_bgt[l_ac].bgt01,'aim-223',0)
                     NEXT FIELD bgt01
                  END IF
                  #No.TQC-970281  --End  
                  DECLARE i008_check_cur CURSOR FOR
                   SELECT * FROM bgt_file
                  FOREACH i008_check_cur INTO l_bgt.*
                     IF (g_bgt[l_ac].bgt01 > l_bgt.bgt01) AND
                        (g_bgt[l_ac].bgt01 < l_bgt.bgt02) THEN
                        LET g_bgt[l_ac].bgt01 = ''
                        CALL cl_err('','abg-005',0)
                        EXIT FOREACH
                     END IF
                  END FOREACH
               END IF
            END IF
 
        AFTER FIELD bgt02                        #check 編號是否重複
            IF NOT cl_null(g_bgt[l_ac].bgt02) THEN
               IF g_bgt[l_ac].bgt02 != g_bgt_t.bgt02 OR
                  cl_null(g_bgt_t.bgt02) THEN
                  #No.TQC-970281  --Begin
                  IF g_bgt[l_ac].bgt02 < 0 THEN
                     CALL cl_err(g_bgt[l_ac].bgt02,'aim-223',0)
                     NEXT FIELD bgt02
                  END IF
                  #No.TQC-970281  --End  
                  IF g_bgt[l_ac].bgt02 != g_bgt[l_ac].bgt01 THEN
                     DECLARE i008_check1_cur CURSOR FOR
                      SELECT * FROM bgt_file
                     FOREACH i008_check1_cur INTO l_bgt.*
                         IF (g_bgt[l_ac].bgt02 >  l_bgt.bgt01) AND
                            (g_bgt[l_ac].bgt02 <= l_bgt.bgt02) THEN
                            LET g_bgt[l_ac].bgt02 = ''
                            CALL cl_err('','abg-005',0)
                            NEXT FIELD bgt02
                            EXIT FOREACH
                         END IF
                     END FOREACH
                     SELECT MIN(bgt01) INTO l_bgt.bgt01 FROM bgt_file
                     IF (g_bgt[l_ac].bgt01 < l_bgt.bgt01) AND
                        (g_bgt[l_ac].bgt02 > l_bgt.bgt01) THEN
                        LET g_bgt[l_ac].bgt02 = ''
                        CALL cl_err('','abg-005',0)
                        NEXT FIELD bgt02
                     END IF
                     SELECT MAX(bgt02) INTO l_bgt.bgt02 FROM bgt_file
                     IF (g_bgt[l_ac].bgt01 < l_bgt.bgt02) AND
                        (g_bgt[l_ac].bgt02 > l_bgt.bgt02) THEN
                        LET g_bgt[l_ac].bgt02 = ''
                        CALL cl_err('','abg-005',0)
                        NEXT FIELD bgt02
                     END IF   
                  END IF
               END IF
            END IF
 
         BEFORE FIELD bgt03
            IF g_bgt[l_ac].bgt02 < g_bgt[l_ac].bgt01 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD bgt01
            END IF
 
        #No.TQC-970281  --Begin
        AFTER FIELD bgt03
            IF NOT cl_null(g_bgt[l_ac].bgt03) THEN
               IF g_bgt[l_ac].bgt03 < 0 THEN
                  CALL cl_err(g_bgt[l_ac].bgt03,'aim-223',0)
                  NEXT FIELD bgt03
               END IF
            END IF
 
        AFTER FIELD bgt04
            IF NOT cl_null(g_bgt[l_ac].bgt04) THEN
               IF g_bgt[l_ac].bgt04 < 0 THEN
                  CALL cl_err(g_bgt[l_ac].bgt04,'aim-223',0)
                  NEXT FIELD bgt04
               END IF
            END IF
        #No.TQC-970281  --End  
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgt_t.bgt01) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF
{ckp#1}         DELETE FROM bgt_file WHERE bgt01 = g_bgt_t.bgt01
                                       AND bgt02 = g_bgt_t.bgt02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgt_t.bgt01,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgt_file",g_bgt_t.bgt01,g_bgt_t.bgt02,SQLCA.sqlcode,"","",1) #FUN-660105
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                CLOSE i008_bcl
            END IF
            COMMIT WORK
 
        ON ROW CHANGE                                                           
           IF INT_FLAG THEN                 #新增程式段                         
              CALL cl_err('',9001,0)                                            
              LET INT_FLAG = 0                                                  
              LET g_bgt[l_ac].* = g_bgt_t.*                                     
              CLOSE i008_bcl                                                    
              ROLLBACK WORK                                                     
              EXIT INPUT                                                        
           END IF                                                               
                                                                                
           IF l_lock_sw="Y" THEN                                                
              CALL cl_err(g_bgt[l_ac].bgt01,-263,0)                             
              LET g_bgt[l_ac].* = g_bgt_t.*                                     
           ELSE          
                       UPDATE bgt_file SET bgt01=g_bgt[l_ac].bgt01,
                                           bgt02=g_bgt[l_ac].bgt02,
                                           bgt03=g_bgt[l_ac].bgt03,
                                           bgt04=g_bgt[l_ac].bgt04
                       WHERE CURRENT OF i008_bcl
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bgt[l_ac].bgt01,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bgt_file",g_bgt[l_ac].bgt01,g_bgt[l_ac].bgt02,SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bgt[l_ac].* = g_bgt_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i008_bcl                                                
                  COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac        #FUN-D30032 mark                                           
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_bgt[l_ac].* = g_bgt_t.*                                 
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF                                                           
               CLOSE i008_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                   
            LET l_ac_t = l_ac        #FUN-D30032 add                           
            CLOSE i008_bcl                                                      
            COMMIT WORK  
 
        ON ACTION CONTROLN
            CALL i008_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgt01) AND l_ac > 1 THEN
                LET g_bgt[l_ac].* = g_bgt[l_ac-1].*
                NEXT FIELD bgt01
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
 
    CLOSE i008_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i008_b_askkey()
    CLEAR FORM
    CALL g_bgt.clear()
 
    CONSTRUCT g_wc2 ON bgt01,bgt02,bgt03,bgt04 
         FROM s_bgt[1].bgt01,s_bgt[1].bgt02,s_bgt[1].bgt03,s_bgt[1].bgt04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            ON IDLE g_idle_seconds                                              
               CALL cl_on_idle()                                                
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
               CONTINUE CONSTRUCT                                               
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT 
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('bgtuser', 'bgtgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i008_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i008_b_fill(p_wc2)               #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000#No.FUN-680061 VARCHAR(200)
 
    LET g_sql =
        "SELECT bgt01,bgt02,bgt03,bgt04,''",
        " FROM bgt_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY bgt01"
    PREPARE i008_pb FROM g_sql
    DECLARE bgt_curs CURSOR FOR i008_pb
 
    CALL g_bgt.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" ATTRIBUTE(REVERSE)
    FOREACH bgt_curs INTO g_bgt[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bgt.deleteElement(g_cnt) 
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i008_bp(p_ud)
DEFINE                                                                          
   p_ud     LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
                                                                                
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bgt TO s_bgt.* ATTRIBUTE(COUNT=g_rec_b)                      
                                                                                
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
 
                                                                                
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
 
END FUNCTION
 
FUNCTION i008_out()
    DEFINE
        l_bgt          RECORD LIKE bgt_file.*,
        l_i            LIKE type_file.num5,    #No.FUN-680061 SMALLINT
        l_name LIKE type_file.chr20,           # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000          #NO.FUN-680061 VARCHAR(40)  
   
    IF g_wc2 IS NULL THEN 
     # CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM bgt_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#No.FUN-770033--begin-- 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
         IF g_zz05 = 'Y' THEN 
            CALL cl_wcchp(g_wc2,'bgt01,bgt02,bgt03,bgt04')                                                                              
            RETURNING g_wc2               
            LET g_str = g_wc2                                             
         END IF 
    LET g_str=g_str,";",g_azi04
    CALL cl_prt_cs1('abgi008','abgi008',g_sql,g_str)
#No.FUN-770033--end--
#No.FUN-770033--start--
{    PREPARE i008_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i008_co                         # SCROLL CURSOR
         CURSOR FOR i008_p1
 
    CALL cl_outnam('abgi008') RETURNING l_name
    START REPORT i008_rep TO l_name
 
    FOREACH i008_co INTO l_bgt.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i008_rep(l_bgt.*)
    END FOREACH
 
    FINISH REPORT i008_rep
 
    CLOSE i008_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)}
#No.FUN-770033--end--
END FUNCTION
#No.FUN-770033--start--
{REPORT i008_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
        str             STRING,
        sr RECORD LIKE bgt_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bgt01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           #LET str = sr.bgt01 USING "########&",'-',sr.bgt02 USING "#########"     #FUN-710058 mod
            LET str = sr.bgt01 USING "#########&",'-',sr.bgt02 USING "##########"   #FUN-710058 mod
            PRINT COLUMN g_c[31],str,
                  COLUMN g_c[32],cl_numfor(sr.bgt03,32,g_azi04),
                  COLUMN g_c[33],cl_numfor(sr.bgt04,33,g_azi04)
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770033--end--
 
#No.FUN-570108--begin                                                           
FUNCTION i008_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("bgt01,bgt02",TRUE)                                 
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i008_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
                                                                                
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("bgt01,bgt02",FALSE)                                
  END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108--end              
