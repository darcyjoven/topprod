# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: almi001.4gl
# Descriptions...: 招商系統單據性質維護作業
# Date & Author..: FUN-960081 08/11/06 By dxfwo
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10167 10/01/19 by dxfwo  命名變為almi001，名稱改為“招商系統單據性質維護作業”
# Modify.........: No:TQC-A10158 10/02/09 By shiwuying 加有效碼oayacti
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-A70130 10/07/30 BY huangtao 將資料來源lrk_file改成oay_file
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960081 
#NO.TQC-A10167 
DEFINE 
    m_oay           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oayslip     LIKE oay_file.oayslip,     #FUN-A70130
        oaydesc     LIKE oay_file.oaydesc,     #FUN-A70130
        oaytype     LIKE oay_file.oaytype,     #FUN-A70130
        oayauno     LIKE oay_file.oayauno,    #FUN-A70130
       #oaydmy1     LIKE oay_file.oaydmy1,   #FUN-A10109 
        oayprnt     LIKE oay_file.oayprnt,    #FUN-A70130
        oayconf     LIKE oay_file.oayconf,    #FUN-A70130
        oayapr      LIKE oay_file.oayapr,      #FUN-A70130
        oayacti     LIKE oay_file.oayacti    #No.TQC-A10158   #FUN-A70130

                    END RECORD,
    g_buf           LIKE ima_file.ima01,        
    m_oay_t         RECORD                 #程式變數 (舊值)
        oayslip     LIKE oay_file.oayslip,  #FUN-A70130
        oaydesc     LIKE oay_file.oaydesc,  #FUN-A70130
        oaytype     LIKE oay_file.oaytype,  #FUN-A70130
        oayauno     LIKE oay_file.oayauno,    #FUN-A70130
       #oaydmy1     LIKE oay_file.oaydmy1,  #FUN-A10109  
        oayprnt     LIKE oay_file.oayprnt,   #FUN-A70130
        oayconf     LIKE oay_file.oayconf,   #FUN-A70130
        oayapr      LIKE oay_file.oayapr,     #FUN-A70130
        oayacti     LIKE oay_file.oayacti    #No.TQC-A10158  #FUN-A70130
                    END RECORD,
    g_wc2,g_sql     string,   
    g_rec_b         LIKE type_file.num5,            #單身筆數         
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT    
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10             
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time               #NO.FUN-6A0094
 
   OPEN WINDOW i001_w WITH FORM "alm/42f/almi001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
   CALL s_getgee('almi001',g_lang,'oaytype') #FUN-A10109   #FUN-A70130
   CALL i001_b_fill(g_wc2)
 
   CALL i001_menu()
 
   CLOSE WINDOW i001_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time                        
END MAIN
 
FUNCTION i001_menu()
DEFINE l_cmd  LIKE type_file.chr1000           
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       #  WHEN "output"
       #     IF cl_chk_act_auth() THEN
       #        CALL i001_out()      
       #     END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_oay),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF m_oay[l_ac].oayslip IS NOT NULL THEN
                  LET g_doc.column1 = "oayslip"             #FUN-A70130
                  LET g_doc.value1 = m_oay[l_ac].oayslip
                  CALL cl_doc()
               END IF
            END IF            
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_q()
 
   CALL s_getgee('almi001',g_lang,'oaytype') #FUN-A10109    #FUN-A70130
   CALL i001_b_askkey()
 
END FUNCTION
 
FUNCTION i001_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
          l_n             LIKE type_file.num5,                #檢查重複用      
          l_n1            LIKE type_file.num5,                #檢查重複用   #sunyanchun add   
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      
          p_cmd           LIKE type_file.chr1,                #處理狀態        
          l_allow_insert  LIKE type_file.num5,                #可新增否        
          l_allow_delete  LIKE type_file.num5                 #可刪除否        
   DEFINE l_i             LIKE type_file.num5                  
   DEFINE l_oaysys        LIKE oay_file.oaysys                #No.FUN-A70130 Add By shi
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT oayslip,oaydesc,oaytype,oayauno,",   #FUN-A70130
                      #"      oaydmy1," #FUN-A10109
                      "       oayprnt,oayconf,",                   #FUN-A70130
                      "       oayapr,oayacti ", #No.TQC-A10158      #FUN-A70130
                      "  FROM oay_file WHERE oayslip=? AND oaysys='alm' FOR UPDATE"   #FUN-A70130
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY m_oay WITHOUT DEFAULTS FROM s_oay.*                 #FUN-A70130
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_doctype_format("oayslip")                     #FUN-A70130
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'        
 
         IF g_rec_b >= l_ac THEN
            LET m_oay_t.* = m_oay[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i001_bcl USING m_oay_t.oayslip
            IF STATUS THEN
               CALL cl_err("OPEN i001_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i001_bcl INTO m_oay[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(m_oay_t.oayslip,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i001_set_entry(p_cmd)                                        
            CALL i001_set_no_entry(p_cmd)
           #CALL i001_set_entry_b(p_cmd)                    #FUN-A70130
           #CALL i001_set_no_entry_b(p_cmd)                 #FUN-A70130                         
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE m_oay[l_ac].* TO NULL     
         LET m_oay_t.* = m_oay[l_ac].*         #新輸入資料  #FUN-A70130
         LET g_before_input_done = FALSE                                   
         CALL i001_set_entry(p_cmd)                                        
         CALL i001_set_no_entry(p_cmd) 
         #CALL i001_set_entry_b(p_cmd)                #FUN-A70130
         #CALL i001_set_no_entry_b(p_cmd)             #FUN-A70130                                 
         LET g_before_input_done = TRUE
         LET m_oay[l_ac].oayauno= 'Y'                 #FUN-A70130
         LET m_oay[l_ac].oayprnt= 'N'                 #FUN-A70130
         LET m_oay[l_ac].oayconf= 'N'                 #FUN-A70130
         LET m_oay[l_ac].oayprnt= 'N'                 #FUN-A70130
         LET m_oay[l_ac].oayapr = 'N'                 #FUN-A70130
         LET m_oay[l_ac].oayacti= 'Y'  #No.TQC-A10158    #FUN-A70130
         CALL cl_show_fld_cont()     
         NEXT FIELD oayslip
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO oay_file(oayslip,oaydesc,oaytype,oayauno,           #FUN-A70130
                              #oaydmy1, #FUN-A10109
                              oayprnt,oayconf,oayapr,oayacti,oaysys) #No.TQC-A10158  #FUN-A70130
              VALUES(m_oay[l_ac].oayslip,m_oay[l_ac].oaydesc,          #FUN-A70130
                     m_oay[l_ac].oaytype,m_oay[l_ac].oayauno,         #FUN-A70130
                     #m_oay[l_ac].oaydmy1,#FUN-A10109
                     m_oay[l_ac].oayprnt,                               #FUN-A70130
                     m_oay[l_ac].oayconf,m_oay[l_ac].oayapr,            #FUN-A70130
                     m_oay[l_ac].oayacti,'alm')                #No.TQC-A10158  #FUN-A70130
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oay_file",m_oay[l_ac].oayslip,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
             #FUN-A10109  ===S===
             CALL s_access_doc('a',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,        #FUN-A70130
                               m_oay[l_ac].oayslip,'ALM',m_oay[l_ac].oayacti)      #FUN-A70130     
             #FUN-A10109  ===E===
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD oayslip                        #check 編號是否重複
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN                                 #FUN-A70130
            IF p_cmd = 'a' OR (p_cmd='u' AND m_oay[l_ac].oayslip != m_oay_t.oayslip) THEN
              #No.FUN-A70130 -BEGIN----- Add By shi
              ##sunyanchun 把l_n-->l_n1
              #SELECT count(*) INTO l_n1 FROM oay_file
              # WHERE oayslip = m_oay[l_ac].oayslip 
              #IF l_n1 IS NULL THEN LET l_n1 = 0 END IF
              #IF l_n1 > 0 THEN
              #   CALL cl_err('','axm0000',0)
              #   LET m_oay[l_ac].oayslip = m_oay_t.oayslip
              #   NEXT FIELD oayslip
              #END IF
              ##sunyanchun end-----
               LET l_oaysys = NULL
               SELECT oaysys INTO l_oaysys FROM oay_file                    
                WHERE oayslip = m_oay[l_ac].oayslip                          
               IF NOT cl_null(l_oaysys) THEN                                  
                  CALL cl_err_msg(m_oay[l_ac].oayslip,'alm-766',l_oaysys CLIPPED,1)
                  LET m_oay[l_ac].oayslip = m_oay_t.oayslip 
                  NEXT FIELD oayslip
               END IF                    
              #No.FUN-A70130 -END-------
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(m_oay[l_ac].oayslip[l_i,l_i]) THEN               #FUN-A70130
                     CALL cl_err('','sub-146',0)
                     LET m_oay[l_ac].oayslip = m_oay_t.oayslip                #FUN-A70130   
                     NEXT FIELD oayslip                                       #FUN-A70130 
                  END IF
               END FOR
            END IF
            IF m_oay[l_ac].oayslip != m_oay_t.oayslip THEN                    #FUN-A70130
               UPDATE smv_file  SET smv01=m_oay[l_ac].oayslip                 #FUN-A70130
                WHERE smv01=m_oay_t.oayslip   #NO:單別                         #FUN-A70130
                  AND upper(smv03)='ALM'   #g_sys    #NO:系統別   
               IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","smv_file",m_oay_t.oayslip,"alm",SQLCA.sqlcode,"","UPDATE smv_file",1)  #FUN-A70130  
                  EXIT INPUT
               END IF
 
               UPDATE smu_file  SET smu01=m_oay[l_ac].oayslip                 #FUN-A70130
                WHERE smu01=m_oay_t.oayslip   #NO:單別                         #FUN-A70130
                  AND upper(smu03)='ALM'   #g_sys    #NO:系統別                 
               IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","smu_file",m_oay_t.oayslip,"alm",SQLCA.sqlcode,"","UPDATE smu_file",1) #FUN-A70130
                  EXIT INPUT
               END IF
            END IF
         END IF

        
      #FUN-A10109 TSD.zeak ===S===
      BEFORE FIELD oaytype
          CALL s_getgee('almi001',g_lang,'oaytype')                    #FUN-A70130

       
        

 
      BEFORE DELETE                            #是否取消單身 
         IF m_oay_t.oayslip IS NOT NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM smy_file WHERE smyslip = m_oay_t.oayslip   #FUN-A70130
            IF g_cnt > 0 THEN
               CALL cl_err(m_oay_t.oayslip,'axm-047',1)                                #FUN-A70130
            END IF
 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
          
            DELETE FROM oay_file WHERE oayslip = m_oay_t.oayslip AND oaysys='alm'        #FUN-A70130
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1)   #FUN-A70130
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
 
            DELETE FROM smv_file WHERE smv01 = m_oay_t.oayslip AND upper(smv03)='ALM'                  
            IF SQLCA.sqlcode THEN
              CALL cl_err3("del","smv_file",m_oay_t.oayslip,"alm",SQLCA.sqlcode,"","smv_file",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            DELETE FROM smu_file WHERE smu01 = m_oay_t.oayslip AND upper(smu03)='ALM'    
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","smu_file",m_oay_t.oayslip,"alm",SQLCA.sqlcode,"","smu_file",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            #FUN-A10109  ===S===
            CALL s_access_doc('r','','',m_oay_t.oayslip,'ALM','')
            #FUN-A10109  ===E===
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i001_bcl
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET m_oay[l_ac].* = m_oay_t.*
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(m_oay[l_ac].oayslip,-263,1)
            LET m_oay[l_ac].* = m_oay_t.*
         ELSE 
            UPDATE oay_file SET
                   oayslip=m_oay[l_ac].oayslip,oaydesc=m_oay[l_ac].oaydesc, #FUN-A70130
                   oaytype=m_oay[l_ac].oaytype,                             #FUN-A70130
                   #oaydmy1=m_oay[l_ac].oaydmy1, #FUN-A10109                
                   oayauno=m_oay[l_ac].oayauno,                             #FUN-A70130 
                   oayprnt=m_oay[l_ac].oayprnt,                             #FUN-A70130
                   oayconf=m_oay[l_ac].oayconf,                             #FUN-A70130
                   oayapr=m_oay[l_ac].oayapr,                               #FUN-A70130
                   oayacti=m_oay[l_ac].oayacti  #No.TQC-A10158              #FUN-A70130
             WHERE oayslip = m_oay_t.oayslip
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1)  
               LET m_oay[l_ac].* = m_oay_t.*
            ELSE
               #FUN-A10109  ===S===
               CALL s_access_doc('u',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype, #FUN-A70130
                                 m_oay_t.oayslip,'ALM',m_oay[l_ac].oayacti)   #FUN-A70130
               #FUN-A10109 ===E===
                    MESSAGE 'UPDATE O.K'
                    CLOSE i001_bcl
                    COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30033
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET m_oay[l_ac].* = m_oay_t.*
            #FUN-D30033----add--str
            ELSE
               CALL m_oay.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t 
               END IF
            #FUN-D30033---add--end 
            END IF
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30033
         CLOSE i001_bcl
         COMMIT WORK
 
      ON ACTION user_authorization  
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN
            LET g_action_choice="user_authorization"  
            IF cl_chk_act_auth() THEN
               CALL s_smu(m_oay[l_ac].oayslip,"ALM")   
            END IF
         ELSE
            CALL cl_err('','anm-217',0)
         END IF
 
      ON ACTION dept_authorization  
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN
             LET g_action_choice="dept_authorization"   
            IF cl_chk_act_auth() THEN
               CALL s_smv(m_oay[l_ac].oayslip,"ALM")   
            END IF
         ELSE
            CALL cl_err('','anm-217',0)
         END IF 
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(oayslip) AND l_ac > 1 THEN
            LET m_oay[l_ac].* = m_oay[l_ac-1].*
            NEXT FIELD oayslip
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
    
 
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
 
   CLOSE i001_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b_askkey()
 
   CLEAR FORM
   CALL m_oay.clear()
 
   CONSTRUCT g_wc2 ON oayslip,oaydesc,oaytype,oayauno,                 #FUN-A70130
                      #oaydmy1, #FUN-A10109
                      oayprnt,oayconf,oayapr,oayacti   #No.TQC-A10158  #FUN-A70130
           FROM s_oay[1].oayslip,s_oay[1].oaydesc,s_oay[1].oaytype,    #FUN-A70130
                s_oay[1].oayauno,                                      #FUN-A70130
                #s_oay[1].oaydmy1, #FUN-A10109
                s_oay[1].oayprnt,                                      #FUN-A70130
                s_oay[1].oayconf,s_oay[1].oayapr,s_oay[1].oayacti      #FUN-A70130
                  #No.TQC-A10158
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
         CALL cl_cmdask()     #
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = '0'
      RETURN
   END IF
 
   CALL i001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              
   DEFINE p_wc2   LIKE type_file.chr1000       
 
   LET g_sql = "SELECT oayslip,oaydesc,oaytype,oayauno,",                #FUN-A70130
               #"      oaydmy1,", #FUN-A10109
               "       oayprnt,oayconf,oayapr,oayacti ", #No.TQC-A10158  #FUN-A70130
               "  FROM oay_file",                                        #FUN-A70130
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " AND oaysys ='alm' ",                                    #FUN-A70130
               " ORDER BY oayslip"                                       #FUN-A70130
   PREPARE i001_pb FROM g_sql
   DECLARE oay_curs CURSOR FOR i001_pb
 
   CALL m_oay.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH oay_curs INTO m_oay[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL m_oay.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_oay TO s_oay.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
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
 
      ON ACTION related_document    #相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#FUNCTION i001_out()
 
#END FUNCTION
 
FUNCTION i001_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y' ) THEN
       CALL cl_set_comp_entry("oayslip",TRUE)
    END IF                                                                                                 
                                                                                              
END FUNCTION  
               
FUNCTION i001_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                    
                                                                                
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                             
      CALL cl_set_comp_entry("oayslip",FALSE)                                                                                       
    END IF
 
END FUNCTION            
 
