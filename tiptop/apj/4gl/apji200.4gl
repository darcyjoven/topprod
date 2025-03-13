# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apji200.4gl
# Descriptions...: 費用代號名稱作業維護
# Date & Author..: 00/04/12 By Carol
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬aag02
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/14 By kim 報表轉XML功能
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改  
# Modify.........: No.MOD-590003 05/09/05 By will 報表格式對齊 
# Modify.........: No.FUN-660053 06/06/12 By Carrier cl_err --> cl_err3
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/23 By xumin結束靠右顯示
# Modify.........: No.TQC-6C0169 06/12/27 By xufeng 修改報表格式
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730033 07/03/23 By Carrier 會計科目加帳套
# Modify.........: No.FUN-790050 07/09/28 By Carrier _out()轉p_query實現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/26 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_pjg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pjg01       LIKE pjg_file.pjg01,   #費用代號
        pjg02       LIKE pjg_file.pjg02,   #費用代號名稱
        pjg03       LIKE pjg_file.pjg03,   #會計科目
        aag02       LIKE aag_file.aag02,   #會計科目名稱  
        pjg04       LIKE pjg_file.pjg04,   #會計科目二    
        aag02_2     LIKE aag_file.aag02,   #會計科目二名稱
        pjg05       LIKE pjg_file.pjg05,   #費用性質      
        pjgacti     LIKE pjg_file.pjgacti  #FUN-680103 VARCHAR(1) 
                    END RECORD,
    g_pjg_t         RECORD                 #程式變數 (舊值)
        pjg01       LIKE pjg_file.pjg01,   #費用代號
        pjg02       LIKE pjg_file.pjg02,   #費用代號名稱
        pjg03       LIKE pjg_file.pjg03,   #會計科目
        aag02       LIKE aag_file.aag02,   #會計科目名稱   
        pjg04       LIKE pjg_file.pjg04,   #會計科目二    
        aag02_2     LIKE aag_file.aag02,   #會計科目二名稱 
        pjg05       LIKE pjg_file.pjg05,   #費用性質      
        pjgacti     LIKE pjg_file.pjgacti  #FUN-680103 VARCHAR(1) 
                    END RECORD,
    g_wc2,g_sql     STRING,                #No.FUN-580092 HCN     
    g_rec_b         LIKE type_file.num5,   #單身筆數             #No.FUN-680103 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680103 SMALLINT
 
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE g_msg                LIKE type_file.chr1000  #No.FUN-790050
DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570109 #No.FUN-680103 SMALLINT
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680103 SMALLINT
 
MAIN
  DEFINE p_row,p_col	LIKE type_file.num5         #No.FUN-680103   SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0083
         RETURNING g_time    #No.FUN-6A0083
    LET p_row = 4 LET p_col = 2  
    OPEN WINDOW i200_w AT p_row,p_col WITH FORM "apj/42f/apji200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i200_b_fill(g_wc2)
    CALL i200_menu()
    CLOSE WINDOW i200_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0083
         RETURNING g_time    #No.FUN-6A0083
END MAIN
 
FUNCTION i200_menu()
 
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i200_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "apji200" "',g_wc2 CLIPPED,'" "',g_aza.aza81,'" "',g_aza.aza82,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i200_q()
   CALL i200_b_askkey()
END FUNCTION
 
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680103 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680103 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680103 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680103 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,     #FUN-680103 VARCHAR(01)  
    l_allow_delete  LIKE type_file.chr1      #FUN-680103 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pjg01,pjg02,pjg03,'',pjg04,'',pjg05,pjgacti ",  
                       " FROM pjg_file WHERE pjg01=? FOR UPDATE"              
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_pjg WITHOUT DEFAULTS FROM s_pjg.*
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
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_pjg_t.* = g_pjg[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                        
               LET  g_before_input_done = FALSE                                 
               CALL i200_set_entry(p_cmd)                                       
               CALL i200_set_no_entry(p_cmd)                                    
               LET  g_before_input_done = TRUE                                  
#No.FUN-570109 --end--        
               OPEN i200_bcl USING g_pjg_t.pjg01
               IF STATUS THEN
                  CALL cl_err("OPEN i200_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i200_bcl INTO g_pjg[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pjg_t.pjg01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE                           
                     CALL i200_aag('d',l_ac)       
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
#No.FUN-570109 --start--                                                        
            LET  g_before_input_done = FALSE                                    
            CALL i200_set_entry(p_cmd)                                          
            CALL i200_set_no_entry(p_cmd)                                       
            LET  g_before_input_done = TRUE                                     
#No.FUN-570109 --end-- 
            LET l_n = ARR_COUNT()
            INITIALIZE g_pjg[l_ac].* TO NULL      #900423
            LET g_pjg[l_ac].pjgacti = 'Y'       #Body default
            LET g_pjg_t.* = g_pjg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pjg01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjg_file(pjg01,pjg02,pjg03,pjg04,pjg05,pjgacti,          
                              pjguser,pjgdate,pjgoriu,pjgorig)
         VALUES(g_pjg[l_ac].pjg01,g_pjg[l_ac].pjg02,
                g_pjg[l_ac].pjg03,g_pjg[l_ac].pjg04,                         
                g_pjg[l_ac].pjg05,g_pjg[l_ac].pjgacti,                      
                g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_pjg[l_ac].pjg01,SQLCA.sqlcode,0)  #No.FUN-660053
             CALL cl_err3("ins","pjg_file",g_pjg[l_ac].pjg01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD pjg01                        #check 編號是否重複
            IF NOT cl_null(g_pjg[l_ac].pjg01) THEN 
            IF g_pjg[l_ac].pjg01 != g_pjg_t.pjg01 OR
               (g_pjg[l_ac].pjg01 IS NOT NULL AND g_pjg_t.pjg01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM pjg_file
                    WHERE pjg01 = g_pjg[l_ac].pjg01
                IF l_n > 0 THEN      #資料重複
                    CALL cl_err('',-239,0)
                    LET g_pjg[l_ac].pjg01 = g_pjg_t.pjg01
                    NEXT FIELD pjg01
                END IF
            END IF
            END IF
 

	  AFTER FIELD pjg03
	         IF NOT cl_null(g_pjg[l_ac].pjg03)  THEN
               SELECT * FROM aag_file WHERE aag01=g_pjg[l_ac].pjg03
                                        AND aag00=g_aza.aza81  #No.FUN-730033
               IF STATUS  THEN 
                  #CALL cl_err('sel_aag',STATUS,0)   #No.FUN-660053
#FUN-B10052 --begin--                  
#                 CALL cl_err3("sel","aag_file",g_pjg[l_ac].pjg03,"",STATUS,"","sel_aag",1) #No.FUN-660053
                  CALL cl_err3("sel","aag_file",g_pjg[l_ac].pjg03,"",STATUS,"","sel_aag",0) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_pjg[l_ac].pjg03
                  LET g_qryparam.arg1 = g_aza.aza81 
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.where = " aag01 LIKE '",g_pjg[l_ac].pjg03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_pjg[l_ac].pjg03
                  CALL i200_aag('d',l_ac)                   
                  DISPLAY BY NAME g_pjg[l_ac].pjg03                      
#FUN-B10052 --end--
                  NEXT FIELD pjg03
               END IF 
               CALL i200_aag('d',l_ac)     
            END IF 
 
	AFTER FIELD pjg04
	    IF NOT cl_null(g_pjg[l_ac].pjg04)  THEN
               SELECT * FROM aag_file WHERE aag01=g_pjg[l_ac].pjg04
                                        AND aag00=g_aza.aza82  #No.FUN-730033
               IF STATUS  THEN 
#FUN-B10052 --begin--
#                  CALL cl_err3("sel","aag_file",g_pjg[l_ac].pjg04,"",STATUS,"","sel_aag",1) #No.FUN-660053
                   CALL cl_err3("sel","aag_file",g_pjg[l_ac].pjg04,"",STATUS,"","sel_aag",0)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.construct = 'N'
                   LET g_qryparam.default1 = g_pjg[l_ac].pjg04
                   LET g_qryparam.arg1 = g_aza.aza82  
                   LET g_qryparam.where = " aag01 LIKE '",g_pjg[l_ac].pjg04 CLIPPED,"%'"
                   CALL cl_create_qry() RETURNING g_pjg[l_ac].pjg04
                   CALL i200_aag('d',l_ac)
                   DISPLAY BY NAME g_pjg[l_ac].pjg04     
#FUN-B10052 --end--                  
                  NEXT FIELD pjg04
               END IF 
               CALL i200_aag('d',l_ac)
            ELSE
               IF g_aza.aza63 = 'Y' THEN
                  CALL i200_aag('d',l_ac)
                  CALL 	cl_err(g_pjg[l_ac].pjg04,'apj-039',0)
                  NEXT FIELD pjg04
               END IF
            END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF g_pjg_t.pjg01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM pjg_file WHERE pjg01 = g_pjg_t.pjg01
                IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_pjg_t.pjg01,SQLCA.sqlcode,0)  #No.FUN-660053
                   CALL cl_err3("del","pjg_file",g_pjg_t.pjg01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
                   ROLLBACK WORK 
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK 
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pjg[l_ac].* = g_pjg_t.*
              CLOSE i200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjg[l_ac].pjg01,-263,1)
              LET g_pjg[l_ac].* = g_pjg_t.*
           ELSE
              UPDATE pjg_file SET pjg01=g_pjg[l_ac].pjg01,
                                  pjg02=g_pjg[l_ac].pjg02,
                                  pjg03=g_pjg[l_ac].pjg03,
                                  pjg04=g_pjg[l_ac].pjg04,         
                                  pjg05=g_pjg[l_ac].pjg05,        
                                  pjgacti=g_pjg[l_ac].pjgacti,
                                  pjgmodu=g_user,
                                  pjgdate=g_today
               WHERE pjg01=g_pjg_t.pjg01
              IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_pjg[l_ac].pjg01,SQLCA.sqlcode,0) #No.FUN-660053
                 CALL cl_err3("upd","pjg_file",g_pjg_t.pjg01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
                 LET g_pjg[l_ac].* = g_pjg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
                 CLOSE i200_bcl
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                   LET g_pjg[l_ac].* = g_pjg_t.*                                    
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pjg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i200_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i200_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i200_b_askkey()
            EXIT INPUT
 
        ON ACTION controlp                        #沿用所有欄位
            CASE
                WHEN INFIELD(pjg03) # Account number
#                  CALL q_aag(0,0,g_pjg[l_ac].pjg03,'','','')
#                       RETURNING g_pjg[l_ac].pjg03
#                  CALL FGL_DIALOG_SETBUFFER( g_pjg[l_ac].pjg03 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.default1 = g_pjg[l_ac].pjg03
                   LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                   CALL cl_create_qry() RETURNING g_pjg[l_ac].pjg03
                  #CALL FGL_DIALOG_SETBUFFER( g_pjg[l_ac].pjg03 )
                    CALL i200_aag('d',l_ac)                   
                    DISPLAY BY NAME g_pjg[l_ac].pjg03        
                WHEN INFIELD(pjg04) # Account number
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.default1 = g_pjg[l_ac].pjg04
                   LET g_qryparam.arg1 = g_aza.aza82  
                   CALL cl_create_qry() RETURNING g_pjg[l_ac].pjg04
                   CALL i200_aag('d',l_ac)
                   DISPLAY BY NAME g_pjg[l_ac].pjg04     
                OTHERWISE 
            END CASE 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pjg01) AND l_ac > 1 THEN
               LET g_pjg[l_ac].* = g_pjg[l_ac-1].*
               LET g_pjg[l_ac].pjg01 = NULL
               NEXT FIELD pjg01
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
 
    CLOSE i200_bcl
    COMMIT WORK 
 
END FUNCTION
 
FUNCTION i200_b_askkey()
    CLEAR FORM
    CALL g_pjg.clear()
    CONSTRUCT g_wc2 ON pjg01,pjg02,pjg03,pjg04,pjg05,pjgacti          
            FROM s_pjg[1].pjg01,s_pjg[1].pjg02,s_pjg[1].pjg03,
                 s_pjg[1].pjg04,s_pjg[1].pjg05,s_pjg[1].pjgacti      
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        #沿用所有欄位
            CASE
               WHEN INFIELD(pjg03) # Account number
#                 CALL q_aag(0,0,g_pjg[1].pjg03,'','','')
#                      RETURNING g_pjg[1].pjg03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_pjg[1].pjg03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjg03
               WHEN INFIELD(pjg04) # Account number
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_pjg[1].pjg04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjg04
               OTHERWISE 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjguser', 'pjggrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i200_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680103 VARCHAR(200)
 
    LET g_sql = "SELECT pjg01,pjg02,pjg03,'',pjg04,'',pjg05,pjgacti FROM pjg_file",
                " WHERE ", p_wc2 CLIPPED," ORDER BY 1"  #單身
 
    PREPARE i200_pb FROM g_sql
    DECLARE pjg_curs CURSOR FOR i200_pb
 
    CALL g_pjg.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pjg_curs INTO g_pjg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL i200_aag('d',g_cnt)          
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pjg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i200_aag(p_cmd,l_cnt)
    DEFINE   p_cmd     LIKE type_file.chr1   
    DEFINE   l_cnt     LIKE type_file.num10   
    DEFINE   l_aag02   LIKE aag_file.aag02
    DEFINE   l_aagacti LIKE aag_file.aagacti
    DEFINE   l_aag02_2 LIKE aag_file.aag02
 
    LET g_errno = " "
        SELECT aag02 INTO l_aag02 FROM aag_file
         WHERE aag01 = g_pjg[l_cnt].pjg03
           AND aag00 = g_aza.aza81
        SELECT aag02 INTO l_aag02_2 FROM aag_file
         WHERE aag01 = g_pjg[l_cnt].pjg04
           AND aag00 = g_aza.aza81
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
         WHEN l_aagacti='N' LET g_errno = '9028'
         OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
 
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET g_pjg[l_cnt].aag02 = l_aag02
       LET g_pjg[l_cnt].aag02_2 = l_aag02_2
       DISPLAY BY NAME g_pjg[l_cnt].aag02  
       DISPLAY BY NAME g_pjg[l_cnt].aag02_2  
    END IF
 
END FUNCTION
 
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680103 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("pjg04,aag02_2",FALSE)
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjg TO s_pjg.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i200_out()
#    DEFINE
#        l_pjg           RECORD LIKE pjg_file.*,
#        l_aag02         LIKE aag_file.aag02,
#        l_i             LIKE type_file.num5,     #No.FUN-680103 SMALLINT 
#        l_name          LIKE type_file.chr20,    #FUN-680103 VARCHAR(20),  # External(Disk) file name 
#        l_za05          LIKE type_file.chr1000   #FUN-680103 VARCHAR(40) 
#
#    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    # 組合出 SQL 指令
#    LET g_sql="SELECT pjg_file.*,aag02 FROM pjg_file LEFT OUTER JOIN aag_file ON pjg_file.pjg03=aag_file.aag01  ",
#              " WHERE ",g_wc2 CLIPPED,  #No.FUN-730033
#              "   AND aag_file.aag00='",g_aza.aza81,"'"          #No.FUN-730033
#    PREPARE i200_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i200_co                         # CURSOR
#        CURSOR FOR i200_p1
#
#    CALL cl_outnam('apji200') RETURNING l_name
#    START REPORT i200_rep TO l_name          
#    FOREACH i200_co INTO l_pjg.*,l_aag02
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i200_rep(l_pjg.*,l_aag02)
#    END FOREACH
#
#     FINISH REPORT i200_rep
#     ERROR ""
#     CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i200_rep(sr,l_aag02)
#    DEFINE
#        l_str           LIKE aba_file.aba18,     #FUN-680103  VARCHAR(2)
#        l_trailer_sw    LIKE type_file.chr1,     #FUN-680103  VARCHAR(1)
#        l_aag02         LIKE aag_file.aag02,
#        sr RECORD LIKE pjg_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.pjg01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           #PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6C0169
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6C0169
#            PRINT 
#            PRINT g_dash[1,g_len]  #TQC-6A0080
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            LET l_str=''
#            IF sr.pjgacti = 'N' 
#                THEN LET l_str= '* ';
#                ELSE LET l_str= '  ';
#            END IF
#            PRINT COLUMN g_c[31],l_str CLIPPED,sr.pjg01 CLIPPED, #TQC-6A0080
#                  COLUMN g_c[32],sr.pjg02 CLIPPED, #TQC-6A0080
#                  COLUMN g_c[33],sr.pjg03 CLIPPED, #TQC-6A0080
#                   COLUMN g_c[34],l_aag02 CLIPPED, #MOD-4A0238  #TQC-6A0080
#                  COLUMN g_c[35],sr.pjgacti CLIPPED  #TQC-6A0080
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
##           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[7] CLIPPED
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED    #No.MOD-590003
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.MOD-590003
##               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --End  
 
#No.FUN-570109 --start--                                                        
FUNCTION i200_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680103 VARCHAR(01)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                           
     CALL cl_set_comp_entry("pjg01",TRUE)                                       
  END IF                                                                        
END FUNCTION                                                                    
                                                                                
FUNCTION i200_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680103 VARCHAR(01)
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("pjg01",FALSE)                                      
  END IF                                                                        
END FUNCTION                                                                    
#No.FUN-570109 --end--      
