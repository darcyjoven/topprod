# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: axmi122.4gl                                                                                                      
# Descriptions...: 產品替代原則維護作業                                                                                             
# Date & Author..: 05/12/23 By Rayven   
# Modify.........: No.FUN-640188 06/04/13 By Sarah 增加判斷,當oaz23=Y AND oaz42=2時,不可執行此程式show訊息提示
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
        g_ocl       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
	ocl01       LIKE ocl_file.ocl01,      #產品分類 
        ocl02       LIKE ocl_file.ocl02,      #起始碼
        ocl03       LIKE ocl_file.ocl03,      #截止碼
        ocl04       LIKE ocl_file.ocl04,      #原值
        ocl05       LIKE ocl_file.ocl05,      #可替代值
        ocl06       LIKE ocl_file.ocl06,      #生效日期
        ocl07       LIKE ocl_file.ocl07       #失效日期
                    END RECORD,
        g_ocl_t     RECORD                    #程式變數 (舊值)
	ocl01       LIKE ocl_file.ocl01,      #產品分類 
        ocl02       LIKE ocl_file.ocl02,      #起始碼
        ocl03       LIKE ocl_file.ocl03,      #截止碼
        ocl04       LIKE ocl_file.ocl04,      #原值
        ocl05       LIKE ocl_file.ocl05,      #可替代值
        ocl06       LIKE ocl_file.ocl06,      #生效日期
        ocl07       LIKE ocl_file.ocl07       #失效日期
                    END RECORD,
        g_wc2,g_sql STRING,                
        g_rec_b     LIKE type_file.num5,                   #單身筆數        #No.FUN-680137 SMALLINT
        l_ac        LIKE type_file.num5                    #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE  p_row,p_col         LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  g_forupd_sql        STRING   #SELECT ... FOR UPDATE SQL    
DEFINE  g_cnt               LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE  g_before_input_done LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_oaz23             LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
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
    
    #判定產品是否可被替代(oaz23),出貨時成品替代方式(oaz42)
    SELECT oaz23,oaz42 INTO g_oaz.oaz23,g_oaz.oaz42 FROM oaz_file  #FUN-640188 add oaz42
    IF g_oaz.oaz23 = "N" THEN
       CALL cl_err("","axm-519",1)  
       EXIT PROGRAM
   #start FUN-640188 add
    ELSE
       IF g_oaz.oaz23 = "Y" AND g_oaz.oaz42 = "2" THEN   #2.依替代群組
          CALL cl_err("","axm-526",1)  
          EXIT PROGRAM
       END IF       
   #end FUN-640188 add
    END IF 
 
    LET p_row = 3 LET p_col = 3
 
    OPEN WINDOW i122_w AT p_row,p_col WITH FORM "axm/42f/axmi122"
       ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()                   #帶入程序toolbar topmenu等信息
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i122_b_fill(g_wc2)
    CALL i122_menu() 
    CLOSE WINDOW i122_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)   #No.FUN-6A0094
       
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i122_menu()
   WHILE TRUE                                                                   
      CALL i122_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i122_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i122_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN      
               CALL i122_out()                                                  
            END IF
         WHEN "help" 
            CALL cl_show_help()   
         WHEN "exit"                                                            
            EXIT WHILE
         WHEN "controlg"                                                        
            CALL cl_cmdask()
         WHEN "exporttoexcel"                                                                                          
            IF cl_chk_act_auth() THEN                                                                                               
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocl),'','') 
            END IF
 
      END CASE                                                                  
   END WHILE  
END FUNCTION
 
FUNCTION i122_q()
   CALL i122_b_askkey()
END FUNCTION
 
FUNCTION i122_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #可新增否         #No.FUN-680137 VARCHAR(1)                          
    l_allow_delete  LIKE type_file.chr1                 #可刪除否         #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""  
 
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ocl01,ocl02,ocl03,ocl04,ocl05,ocl06,ocl07",
                       "  FROM ocl_file  WHERE ocl01 = ?", 
                       "   AND ocl02 = ? AND ocl03 = ?",
		       "   AND ocl04 = ? AND ocl06 = ?",
                       "   FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i122_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR 
 
    LET l_ac_t=0
    INPUT ARRAY g_ocl WITHOUT DEFAULTS FROM s_ocl.*                             
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
            LET g_ocl_t.* = g_ocl[l_ac].*  #BACKUP
            
            OPEN i122_bcl USING g_ocl_t.ocl01,g_ocl_t.ocl02,g_ocl_t.ocl03,g_ocl_t.ocl04,g_ocl_t.ocl06       #表示更改狀態
            IF STATUS THEN                
               CALL cl_err("OPEN i122_bcl:", STATUS, 1)         
               LET l_lock_sw = "Y"                      
            ELSE 
               FETCH i122_bcl INTO g_ocl[l_ac].* 
               IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ocl_t.ocl01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
               END IF
            END IF
        END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ocl[l_ac].* TO NULL      
            LET g_ocl_t.* = g_ocl[l_ac].*         #新輸入資料
            LET g_ocl[l_ac].ocl06 = g_today
            NEXT FIELD ocl01
 
    AFTER INSERT
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CANCEL INSERT
           END IF
 
           IF LENGTH(g_ocl[l_ac].ocl04)<>(g_ocl[l_ac].ocl03-g_ocl[l_ac].ocl02+1) THEN
              CALL cl_err("","axm-520",1)
              NEXT FIELD ocl02
           END IF
 
           INSERT INTO ocl_file(ocl01,ocl02,ocl03,ocl04,ocl05,ocl06,ocl07)
                         VALUES(g_ocl[l_ac].ocl01,g_ocl[l_ac].ocl02,  
                                g_ocl[l_ac].ocl03,g_ocl[l_ac].ocl04,    
                                g_ocl[l_ac].ocl05,g_ocl[l_ac].ocl06,    
                                g_ocl[l_ac].ocl07) 
           IF SQLCA.sqlcode THEN                                   
#             CALL cl_err(g_ocl[l_ac].ocl01,SQLCA.sqlcode,0)       #No.FUN-660167
              CALL cl_err3("ins","ocl_file",g_ocl[l_ac].ocl01,g_ocl[l_ac].ocl02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
              CANCEL INSERT   
           ELSE                                                    
              MESSAGE 'INSERT O.K'                                
              LET g_rec_b=g_rec_b+1                           
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF 
 
       AFTER FIELD ocl01
         IF NOT cl_null(g_ocl[l_ac].ocl01) THEN
            SELECT count(*) INTO l_n FROM oba_file WHERE oba01=g_ocl[l_ac].ocl01 
            IF l_n=0 THEN
                CALL cl_err("","aom-005",1)
                LET g_ocl[l_ac].ocl01=NULL
                NEXT FIELD ocl01
            END IF
         END IF
 
       AFTER FIELD ocl02
         IF NOT cl_null(g_ocl[l_ac].ocl02) THEN
            IF g_ocl[l_ac].ocl02<=0 OR g_ocl[l_ac].ocl02>40 THEN
               CALL cl_err("","axm-514",1)
               NEXT FIELD ocl02
            ELSE  
               IF g_ocl[l_ac].ocl03<g_ocl[l_ac].ocl02 THEN
                  CALL cl_err("","aim-919",1)
                  NEXT FIELD ocl02
	       END IF
            END IF
         END IF
 
       AFTER FIELD ocl03
         IF NOT cl_null(g_ocl[l_ac].ocl03) THEN
            IF g_ocl[l_ac].ocl03<=0 OR g_ocl[l_ac].ocl03>40 THEN
               CALL cl_err("","axm-515",1)
               NEXT FIELD ocl03
            ELSE  
               IF g_ocl[l_ac].ocl03<g_ocl[l_ac].ocl02 THEN
                  CALL cl_err("","aim-919",1)
                  NEXT FIELD ocl03
               END IF
            END IF
         END IF
 
       AFTER FIELD ocl04
         IF NOT cl_null(g_ocl[l_ac].ocl04) THEN
            IF LENGTH(g_ocl[l_ac].ocl04)<>(g_ocl[l_ac].ocl03-g_ocl[l_ac].ocl02+1) THEN
               CALL cl_err("","axm-516",1)
               NEXT FIELD ocl04
            ELSE
               IF g_ocl[l_ac].ocl04=g_ocl[l_ac].ocl05 THEN
                  CALL cl_err("","axm-518",1)
                  NEXT FIELD ocl04
               END IF
            END IF
         END IF
 
       AFTER FIELD ocl05
         IF NOT cl_null(g_ocl[l_ac].ocl05) THEN
            IF LENGTH(g_ocl[l_ac].ocl05)<>(g_ocl[l_ac].ocl03-g_ocl[l_ac].ocl02+1) THEN
               CALL cl_err("","axm-517",1)
               NEXT FIELD ocl05
            ELSE                                                                                                                       
               IF g_ocl[l_ac].ocl04=g_ocl[l_ac].ocl05 THEN                                                                             
                  CALL cl_err("","axm-518",1)
                  NEXT FIELD ocl05                                                                                                    
               END IF            
            END IF
         END IF
 
       AFTER FIELD ocl06
         IF NOT cl_null(g_ocl[l_ac].ocl01)
            AND NOT cl_null(g_ocl[l_ac].ocl02)
            AND NOT cl_null(g_ocl[l_ac].ocl03)
            AND NOT cl_null(g_ocl[l_ac].ocl04)
            AND NOT cl_null(g_ocl[l_ac].ocl06) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND (g_ocl[l_ac].ocl01 != g_ocl_t.ocl01
                             OR  g_ocl[l_ac].ocl02 != g_ocl_t.ocl02
                             OR  g_ocl[l_ac].ocl03 != g_ocl_t.ocl03
                             OR  g_ocl[l_ac].ocl04 != g_ocl_t.ocl04
                             OR  g_ocl[l_ac].ocl06 != g_ocl_t.ocl06)) THEN
               SELECT count(*) INTO l_n FROM ocl_file WHERE ocl01 = g_ocl[l_ac].ocl01
		 					AND ocl02 = g_ocl[l_ac].ocl02
                                                        AND ocl03 = g_ocl[l_ac].ocl03
							AND ocl04 = g_ocl[l_ac].ocl04
							AND ocl06 = g_ocl[l_ac].ocl06
               IF l_n > 0 THEN                  
                  CALL cl_err("",-239,1) 
                  NEXT FIELD ocl01 
	       END IF                                            
            END IF 
	 END IF   
 
       AFTER FIELD ocl07
               IF g_ocl[l_ac].ocl07<g_ocl[l_ac].ocl06 THEN
                    CALL cl_err(g_ocl[l_ac].ocl07,-9913,1)
                    LET g_ocl[l_ac].ocl07 = NULL
                    NEXT FIELD ocl07
               END IF
 
 
       BEFORE DELETE                            #是否取消單身
          IF NOT cl_null(g_ocl[l_ac].ocl01)                                                                                          
             AND NOT cl_null(g_ocl[l_ac].ocl02)                                                                                      
             AND NOT cl_null(g_ocl[l_ac].ocl03)                                                                                      
             AND NOT cl_null(g_ocl[l_ac].ocl04)                                                                                      
             AND NOT cl_null(g_ocl[l_ac].ocl06) THEN  
                IF NOT cl_delete() THEN                         
                   CANCEL DELETE                               
                END IF                                               
                IF l_lock_sw = "Y" THEN                       
                   CALL cl_err("", -263, 1)                       
                   CANCEL DELETE                     
                END IF  
                DELETE FROM ocl_file WHERE ocl01 = g_ocl_t.ocl01                                                    
                                       AND ocl02 = g_ocl_t.ocl02                                               
                                       AND ocl03 = g_ocl_t.ocl03                                               
                                       AND ocl04 = g_ocl_t.ocl04                                               
                                       AND ocl06 = g_ocl_t.ocl06    
                IF SQLCA.sqlcode THEN
#                   CALL cl_err("",SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("del","ocl_file",g_ocl_t.ocl01,g_ocl_t.ocl02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
              LET g_ocl[l_ac].* = g_ocl_t.*                      
              CLOSE i122_bcl                                     
              ROLLBACK WORK                                      
              EXIT INPUT                                         
           END IF                                                
 
           IF g_ocl[l_ac].ocl02>g_ocl[l_ac].ocl03 THEN                                                                             
              CALL cl_err("","aim-919",1)                                                                                          
              LET g_ocl[l_ac].ocl02 = g_ocl_t.ocl02            
              LET g_ocl[l_ac].ocl03 = g_ocl_t.ocl03
              RETURN
           END IF  
 
           IF LENGTH(g_ocl[l_ac].ocl04)<>(g_ocl[l_ac].ocl03-g_ocl[l_ac].ocl02+1) THEN
              CALL cl_err("","axm-516",1)
              NEXT FIELD ocl04
           END IF
 
           IF LENGTH(g_ocl[l_ac].ocl05)<>(g_ocl[l_ac].ocl03-g_ocl[l_ac].ocl02+1) THEN
              CALL cl_err("","axm-517",1)
              NEXT FIELD ocl05
           END IF
 
           IF l_lock_sw="Y" THEN                       
              CALL cl_err(g_ocl[l_ac].ocl01,-263,0)                
              LET g_ocl[l_ac].* = g_ocl_t.*            
           ELSE 
              UPDATE ocl_file 
                 SET ocl01=g_ocl[l_ac].ocl01,ocl02=g_ocl[l_ac].ocl02,
                     ocl03=g_ocl[l_ac].ocl03,ocl04=g_ocl[l_ac].ocl04,
                     ocl05=g_ocl[l_ac].ocl05,ocl06=g_ocl[l_ac].ocl06,   
                     ocl07=g_ocl[l_ac].ocl07   
              WHERE ocl01 = g_ocl_t.ocl01                                                                
                AND ocl02 = g_ocl_t.ocl02                                                                
                AND ocl03 = g_ocl_t.ocl03                                                                
                AND ocl04 = g_ocl_t.ocl04                                                                
                AND ocl06 = g_ocl_t.ocl06   
              IF SQLCA.sqlcode THEN                     
#                CALL cl_err('upd ocl:',9050,1)             #No.FUN-660167
                 CALL cl_err3("upd","ocl_file",g_ocl_t.ocl01,g_ocl_t.ocl02,9050,"","upd ocl",1)  #No.FUN-660167
                 LET g_ocl[l_ac].* = g_ocl_t.*
                 ROLLBACK WORK
              ELSE                                       
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK
              END IF
           END IF
 
    AFTER ROW
           LET l_ac = ARR_CURR()                                
          #LET l_ac_t = l_ac       #FUN-D30034 mark                         
 
           IF INT_FLAG THEN                                
              CALL cl_err('',9001,0)                         
              LET INT_FLAG = 0                               
              IF p_cmd = 'u' THEN
                 LET g_ocl[l_ac].* = g_ocl_t.*            
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_ocl.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF        
              CLOSE i122_bcl                            
              ROLLBACK WORK                          
              EXIT INPUT                                 
           END IF      
           LET l_ac_t = l_ac   #FUN-D30034 add  
           CLOSE i122_bcl
           COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i122_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(ocl01) AND l_ac > 1 THEN
                LET g_ocl[l_ac].* = g_ocl[l_ac-1].*
                NEXT FIELD ocl01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE                                                 
               WHEN INFIELD(ocl01)                                   
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_oba"                                    
               LET g_qryparam.default1 = g_ocl[l_ac].ocl01
               CALL cl_create_qry() RETURNING g_ocl[l_ac].ocl01              
               DISPLAY BY NAME g_ocl[l_ac].ocl01
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
 
    CLOSE i122_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i122_b_askkey()
    CLEAR FORM
    CALL g_ocl.clear()
    CONSTRUCT g_wc2 ON ocl01,ocl02,ocl03,ocl04,ocl05,ocl06,ocl07
         FROM s_ocl[1].ocl01,s_ocl[1].ocl02,s_ocl[1].ocl03,s_ocl[1].ocl04,
              s_ocl[1].ocl05,s_ocl[1].ocl06,s_ocl[1].ocl07
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE                                                 
             WHEN INFIELD(ocl01)                                   
             CALL cl_init_qry_var()                                           
             LET g_qryparam.form = "q_oba"                                    
             LET g_qryparam.state = "c"                                       
             LET g_qryparam.default1 = g_ocl[1].ocl01
             CALL cl_create_qry() RETURNING g_qryparam.multiret           
             DISPLAY g_qryparam.multiret TO s_ocl[1].ocl01         
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
    CALL i122_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i122_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        "SELECT ocl01,ocl02,ocl03,ocl04,ocl05,ocl06,ocl07",
        " FROM ocl_file",
        " WHERE ", p_wc2 CLIPPED,                     
        " ORDER BY ocl01,ocl02,ocl03,ocl04,ocl06"
    PREPARE i122_pb FROM g_sql
    DECLARE ocl_curs CURSOR FOR i122_pb
 
    CALL g_ocl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ocl_curs INTO g_ocl[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_ocl.deleteElement(g_cnt)       
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i122_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_ocl TO s_ocl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
#No.FUN-7C0043--start--
FUNCTION i122_out()
     DEFINE
         l_ocl           RECORD LIKE ocl_file.*,
         l_name          LIKE type_file.chr20                         #No.FUN-680137 VARCHAR(20)
    
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                
    IF g_wc2 IS NULL THEN                                                                                                          
       CALL cl_err('',-400,0) RETURN                                                                                               
    END IF                                                                                                                         
    IF cl_null(g_wc2) THEN                                                                                                          
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axmi122" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN    
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('',-400,0) RETURN 
#    END IF
#   IF cl_null(g_wc2) THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
#No.TQC-710076 -- end --
#    CALL cl_wait()
#    CALL cl_outnam('axmi122') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM ocl_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i122_p1 FROM g_sql                  
##    DECLARE i122_co                           
#        CURSOR FOR i122_p1
#
#    START REPORT i122_rep TO l_name
#
#    FOREACH i122_co INTO l_ocl.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i122_rep(l_ocl.*)
#   END FOREACH
 
#   FINISH REPORT i122_rep
 
#   CLOSE i122_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i122_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680137 VARCHAR(1)
#       sr RECORD LIKE ocl_file.*
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ocl01,sr.ocl02,sr.ocl03,sr.ocl04,sr.ocl06
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           PRINT ' '
#           PRINT g_dash[1,g_len]
 
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#                 g_x[35],g_x[36],g_x[37]
#                    
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.ocl01 CLIPPED,
#                 COLUMN g_c[32],sr.ocl02 USING"######",
#                 COLUMN g_c[33],sr.ocl03 USING"######",
#                 COLUMN g_c[34],sr.ocl04 CLIPPED,
#                 COLUMN g_c[35],sr.ocl05 CLIPPED, 
#                 COLUMN g_c[36],sr.ocl06,
#                 COLUMN g_c[37],sr.ocl07
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#              PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#              SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
FUNCTION i122_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1                      #No.FUN-680137 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("ocl01",TRUE)                                                                                         
   END IF                                                                                                                           
END FUNCTION           
 
FUNCTION i122_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1                      #No.FUN-680137 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ocl01",FALSE)                                                                                        
   END IF                                                                                                                           
END FUNCTION     
