# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: atmi010.4gl
# Descriptions...: 流通零售系統單別設定作業
# Date & Author..: FUN-A70130 10/08/04 By huangtao
# Modify.........: No:FUN-AA0046 10/10/21 By huangtao 修改模組別錯誤
# Modify.........: No:TQC-D10056 13/01/10 By xuxz gee07 = ’adk01‘的時候對應的單據類型的簽核處理為’N'，且noentry
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40117 13/04/16 By Sakura smy53或smy56為null時,預設smy56=Y、smy53=N

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    m_oay           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oayslip     LIKE oay_file.oayslip,  
        oaydesc     LIKE oay_file.oaydesc,
        oayauno     LIKE oay_file.oayauno,
        oayconf     LIKE oay_file.oayconf, 
        oayprnt     LIKE oay_file.oayprnt,
        oaytype     LIKE oay_file.oaytype,
        oayapr      LIKE oay_file.oayapr, 
        oayacti     LIKE oay_file.oayacti  
                    END RECORD,
    g_buf           LIKE ima_file.ima01,        
    m_oay_t         RECORD                 #程式變數 (舊值)
        oayslip     LIKE oay_file.oayslip,  
        oaydesc     LIKE oay_file.oaydesc,
        oayauno     LIKE oay_file.oayauno,  
        oayconf     LIKE oay_file.oayconf,
        oayprnt     LIKE oay_file.oayprnt,
        oaytype     LIKE oay_file.oaytype,
        oayapr      LIKE oay_file.oayapr,  
        oayacti     LIKE oay_file.oayacti    
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
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time               
 
   OPEN WINDOW i010_w WITH FORM "art/42f/arti010"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
   CALL cl_set_comp_visible("gr4",FALSE) #No.FUN-A70130 Add by shi
 
   LET g_wc2 = '1=1'
   CALL s_getgee('atmi010',g_lang,'oaytype') 
   CALL i010_b_fill(g_wc2)
 
   CALL i010_menu()
 
   CLOSE WINDOW i010_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time                        
END MAIN
 
FUNCTION i010_menu()
DEFINE l_cmd  LIKE type_file.chr1000           
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_oay),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF m_oay[l_ac].oayslip IS NOT NULL THEN
                  LET g_doc.column1 = "oayslip"
                  LET g_doc.value1 = m_oay[l_ac].oayslip
                  CALL cl_doc()
               END IF
            END IF            
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i010_q()
 
   CALL s_getgee('atmi010',g_lang,'oaytype')
   CALL i010_b_askkey()
 
END FUNCTION
 
FUNCTION i010_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
          l_n             LIKE type_file.num5,                #檢查重複用      
          l_n1            LIKE type_file.num5,                #檢查重複用    
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      
          p_cmd           LIKE type_file.chr1,                #處理狀態        
          l_allow_insert  LIKE type_file.num5,                #可新增否        
          l_allow_delete  LIKE type_file.num5                 #可刪除否        
   DEFINE l_i             LIKE type_file.num5  
   DEFINE l_oaysys        LIKE oay_file.oaysys   
   DEFINE l_count         LIKE type_file.num10                #TQC-D10056 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT oayslip,oaydesc,oayauno,oayconf,",
                      "       oayprnt,oaytype,", 
                      "       oayapr,oayacti ", 
                      "  FROM oay_file WHERE oayslip=? AND oaysys='atm' FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY m_oay WITHOUT DEFAULTS FROM s_oay.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_doctype_format("oayslip")
 
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
            OPEN i010_bcl USING m_oay_t.oayslip
            IF STATUS THEN
               CALL cl_err("OPEN i010_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i010_bcl INTO m_oay[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(m_oay_t.oayslip,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i010_set_entry(p_cmd)                                        
            CALL i010_set_no_entry(p_cmd)                                    
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE m_oay[l_ac].* TO NULL     
         LET m_oay_t.* = m_oay[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i010_set_entry(p_cmd)                                        
         CALL i010_set_no_entry(p_cmd) 
         LET g_before_input_done = TRUE
         LET m_oay[l_ac].oayauno= 'Y'
         LET m_oay[l_ac].oayprnt= 'N'
         LET m_oay[l_ac].oayconf= 'N'
         LET m_oay[l_ac].oayprnt= 'N'
         LET m_oay[l_ac].oayapr = 'N'
         LET m_oay[l_ac].oayacti= 'Y'  
         CALL cl_show_fld_cont()     
         NEXT FIELD oayslip
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO oay_file(oayslip,oaydesc,oayauno,oayconf, oayprnt,oaytype,
                             oayapr,oayacti,oaysys) 
              VALUES(m_oay[l_ac].oayslip,m_oay[l_ac].oaydesc,m_oay[l_ac].oayauno,
                    m_oay[l_ac].oayconf,m_oay[l_ac].oayprnt, m_oay[l_ac].oaytype,
                     
                     m_oay[l_ac].oayapr, m_oay[l_ac].oayacti,'atm') 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oay_file",m_oay[l_ac].oayslip,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE


             CALL s_access_doc('a',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,
                               m_oay[l_ac].oayslip,'ATM',m_oay[l_ac].oayacti)
 #FUN-A70130 add 10/10/14----- start         
          IF m_oay[l_ac].oaytype ='U6' OR m_oay[l_ac].oaytype ='U7' THEN
             IF m_oay[l_ac].oaytype ='U6' THEN
                CALL i010_ins_smy('F')
             ELSE
                CALL i010_ins_smy('G')
             END IF
          END IF
#FUN-A70130 add 10/10/14------end 

            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
 
      AFTER FIELD oayslip                        #check 編號是否重複
         IF m_oay[l_ac].oayslip IS NOT NULL THEN
            IF m_oay[l_ac].oayslip != m_oay_t.oayslip OR
               (NOT cl_null(m_oay[l_ac].oayslip) AND cl_null(m_oay_t.oayslip)) THEN
              LET l_oaysys = NULL
              SELECT oaysys INTO l_oaysys FROM oay_file                    
                WHERE oayslip = m_oay[l_ac].oayslip                          
               IF NOT cl_null(l_oaysys) THEN                                  
                  CALL cl_err_msg(m_oay[l_ac].oayslip,'alm-766',l_oaysys CLIPPED,1)
                  LET m_oay[l_ac].oayslip = m_oay_t.oayslip 
                  NEXT FIELD oayslip
               END IF           
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(m_oay[l_ac].oayslip[l_i,l_i]) THEN
                     CALL cl_err('','sub-146',0)
                     LET m_oay[l_ac].oayslip = m_oay_t.oayslip
                     NEXT FIELD oayslip
                  END IF
               END FOR
            END IF
            IF m_oay[l_ac].oayslip != m_oay_t.oayslip THEN  
               UPDATE smv_file  SET smv01=m_oay[l_ac].oayslip
                WHERE smv01=m_oay_t.oayslip   #NO:單別
          #        AND upper(smv03)='ALM'   #g_sys    #NO:系統別     #FUN-AA0046 mark
                   AND upper(smv03)='ATM'                                #FUN-AA0046  
               IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","smv_file",m_oay_t.oayslip,"atm",SQLCA.sqlcode,"","UPDATE smv_file",1)  
                  EXIT INPUT
               END IF
 
               UPDATE smu_file  SET smu01=m_oay[l_ac].oayslip
                WHERE smu01=m_oay_t.oayslip   #NO:單別
          #        AND upper(smu03)='ALM'   #g_sys    #NO:系統別     #FUN-AA0046  mark
                   AND upper(smu03)='ATM'   #g_sys    #NO:系統別     #FUN-AA0046
               IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","smu_file",m_oay_t.oayslip,"atm",SQLCA.sqlcode,"","UPDATE smu_file",1) 
                  EXIT INPUT
               END IF
            END IF
         END IF
 
 
 
      BEFORE FIELD oaytype
          CALL s_getgee('atmi010',g_lang,'oaytype')

     #TQC-D10056--add-str
      #判斷單據類型對應的gee07 是否為adk07，且gee04 = ‘atmi010’，gee01 = ‘ATM’
      AFTER FIELD oaytype
         LET l_count = 0
          SELECT COUNT(*) INTO l_count FROM gee_file
           WHERE gee04 = 'atmi010'
             AND gee01 = 'ATM'
             AND gee07 = 'adk01'
             AND gee02 = m_oay[l_ac].oaytype
         IF l_count > 0 THEN
            LET m_oay[l_ac].oayapr = 'N'
            DISPLAY BY NAME m_oay[l_ac].oayapr
            CALL cl_set_comp_entry("oayapr",FALSE)
         ELSE
            CALL cl_set_comp_entry("oayapr",TRUE)
         END IF
      ON CHANGE oaytype
         LET l_count = 0
          SELECT COUNT(*) INTO l_count FROM gee_file
           WHERE gee04 = 'atmi010'
             AND gee01 = 'ATM'
             AND gee07 = 'adk01'
             AND gee02 = m_oay[l_ac].oaytype
         IF l_count > 0 THEN
            LET m_oay[l_ac].oayapr = 'N'
            DISPLAY BY NAME m_oay[l_ac].oayapr
            CALL cl_set_comp_entry("oayapr",FALSE)
         ELSE
            CALL cl_set_comp_entry("oayapr",TRUE)
         END IF
     #TQC-D10056--add--end
      
 
      BEFORE DELETE                            #是否取消單身 
         IF m_oay_t.oayslip IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF

            IF m_oay_t.oaytype = 'U6' OR m_oay_t.oaytype = 'U7' THEN #20101015 BY shi Add
               SELECT COUNT(*) INTO g_cnt FROM smy_file WHERE smyslip = m_oay_t.oayslip
               IF g_cnt > 0 THEN
                  CALL cl_err(m_oay_t.oayslip,'axm-047',1)
               END IF
            END IF
          
            DELETE FROM oay_file WHERE oayslip = m_oay_t.oayslip AND oaysys='atm'
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
 
            IF m_oay_t.oaytype = 'U6' OR m_oay_t.oaytype = 'U7' THEN
               DELETE FROM smy_file WHERE smyslip = m_oay_t.oayslip
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","smy_file",m_oay_t.oayslip,"aim",SQLCA.sqlcode,"","smy_file",1)  
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
            END IF
            DELETE FROM smv_file WHERE smv01 = m_oay_t.oayslip AND upper(smv03)='ATM'                  
            IF SQLCA.sqlcode THEN
              CALL cl_err3("del","smv_file",m_oay_t.oayslip,"atm",SQLCA.sqlcode,"","smv_file",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            DELETE FROM smu_file WHERE smu01 = m_oay_t.oayslip AND upper(smu03)='ATM'    
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","smu_file",m_oay_t.oayslip,"atm",SQLCA.sqlcode,"","smu_file",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            CALL s_access_doc('r','','',m_oay_t.oayslip,'ATM','')
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i010_bcl
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET m_oay[l_ac].* = m_oay_t.*
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(m_oay[l_ac].oayslip,-263,1)
            LET m_oay[l_ac].* = m_oay_t.*
         ELSE 
            UPDATE oay_file SET
                   oayslip=m_oay[l_ac].oayslip,
                   oaydesc=m_oay[l_ac].oaydesc,
                   oayauno=m_oay[l_ac].oayauno,
                   oayconf=m_oay[l_ac].oayconf,
                   oayprnt=m_oay[l_ac].oayprnt,
                   oaytype=m_oay[l_ac].oaytype,
                   oayapr=m_oay[l_ac].oayapr,
                   oayacti=m_oay[l_ac].oayacti  
             WHERE oayslip = m_oay_t.oayslip
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","oay_file",m_oay_t.oayslip,"",SQLCA.sqlcode,"","",1)  
               LET m_oay[l_ac].* = m_oay_t.*
            ELSE

               CALL s_access_doc('u',m_oay[l_ac].oayauno,m_oay[l_ac].oaytype,
                                 m_oay_t.oayslip,'ATM',m_oay[l_ac].oayacti)
#FUN-A70130  add ----start
               IF ( m_oay[l_ac].oaytype = 'U6' OR m_oay[l_ac].oaytype = 'U7') 
                   AND m_oay_t.oaytype <> 'U6'
                   AND m_oay_t.oaytype <> 'U7'  THEN
         #         CALL cl_err('','atm-890',1)           #FUN-AA0046
                  IF m_oay[l_ac].oaytype ='U6' THEN
                     CALL i010_ins_smy('F')
                  ELSE
                      CALL i010_ins_smy('G')
                  END IF
               ELSE
                 #IF m_oay[l_ac].oaytype = 'U6' AND m_oay_t.oaytype = 'U7' THEN       #U7改成U6
                 #   CALL i010_upd_smy('F')
                 #END IF
                 #IF m_oay[l_ac].oaytype = 'U7' AND m_oay_t.oaytype = 'U6' THEN       #U6改成U7
                 #   CALL i010_upd_smy('G')
                 #END IF
                  IF m_oay[l_ac].oaytype = 'U6' THEN
                     CALL i010_upd_smy('F')
                  END IF
                  IF m_oay[l_ac].oaytype = 'U7' THEN
                     CALL i010_upd_smy('G')
                  END IF
#FUN-AA0046 ---------start
                  IF m_oay[l_ac].oaytype <> 'U6' AND  m_oay[l_ac].oaytype <> 'U7' AND 
                     m_oay_t.oaytype = 'U6' OR m_oay_t.oaytype = 'U7' THEN
                     CALL cl_err('','axm-061',1)
                  END IF
#FUN-AA0046 ----------end
               END IF
               IF g_success = 'N' THEN
                  LET m_oay[l_ac].* = m_oay_t.*
                  ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i010_bcl
                   COMMIT WORK
               END IF
#FUN-A70130 add  -----end
#               MESSAGE 'UPDATE O.K'
#               CLOSE i010_bcl
#               COMMIT WORK
            END IF
         END IF

 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET m_oay[l_ac].* = m_oay_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL m_oay.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30033 add
         CLOSE i010_bcl
         COMMIT WORK
 
      ON ACTION user_authorization  
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN
            LET g_action_choice="user_authorization"  
            IF cl_chk_act_auth() THEN
               CALL s_smu(m_oay[l_ac].oayslip,"ATM")   
            END IF
         ELSE
            CALL cl_err('','anm-217',0)
         END IF
 
      ON ACTION dept_authorization  
         IF NOT cl_null(m_oay[l_ac].oayslip) THEN
             LET g_action_choice="dept_authorization"   
            IF cl_chk_act_auth() THEN
               CALL s_smv(m_oay[l_ac].oayslip,"ATM")   
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
 
   CLOSE i010_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_b_askkey()
 
   CLEAR FORM
   CALL m_oay.clear()
 
   CONSTRUCT g_wc2 ON oayslip,oaydesc,oayauno,oayconf,oayprnt,oaytype,
                      oayapr,oayacti   
           FROM s_oay[1].oayslip,s_oay[1].oaydesc, s_oay[1].oayauno,
                     s_oay[1].oayconf,s_oay[1].oayprnt,s_oay[1].oaytype, 
                   s_oay[1].oayapr,s_oay[1].oayacti
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
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) 
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = '0'
      RETURN
   END IF
 
   CALL i010_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              
   DEFINE p_wc2   LIKE type_file.chr1000       
 
   LET g_sql = "SELECT oayslip,oaydesc,oayauno,oayconf,oayprnt,oaytype,",
               "       oayapr,oayacti ", 
               "  FROM oay_file",
               " WHERE ", p_wc2 CLIPPED,                    
               " AND oaysys ='atm' ",
               " ORDER BY oayslip"
   PREPARE i010_pb FROM g_sql
   DECLARE oay_curs CURSOR FOR i010_pb
 
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
 
FUNCTION i010_bp(p_ud)
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
 

 
FUNCTION i010_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y' ) THEN
       CALL cl_set_comp_entry("oayslip",TRUE)
    END IF                                                                                                 
                                                                                              
END FUNCTION  
               
FUNCTION i010_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                    
                                                                                
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                             
      CALL cl_set_comp_entry("oayslip",FALSE)                                                                                       
    END IF
 
END FUNCTION  
#FUN-A70130 add 10/10/15-------start
FUNCTION i010_ins_smy(l_kind)
   DEFINE l_smy   RECORD LIKE smy_file.*
   DEFINE l_kind LIKE smy_file.smykind
   DEFINE l_oay12 LIKE oay_file.oay12
   DEFINE l_oay24 LIKE oay_file.oay24
   DEFINE l_oaysign LIKE oay_file.oaysign
   SELECT oay12,oay24,oaysign INTO l_oay12,l_oay24,l_oaysign FROM oay_file
    WHERE oayslip = m_oay[l_ac].oayslip

   INITIALIZE l_smy.* TO NULL
   LET l_smy.smyslip = m_oay[l_ac].oayslip
   LET l_smy.smydesc = m_oay[l_ac].oaydesc
   LET l_smy.smyauno = m_oay[l_ac].oayauno
   LET l_smy.smysys  = 'aim'                     #系統別
   LET l_smy.smykind = l_kind                    #單據性質(mfg出貨單)
   LET l_smy.smyatsg = 'N'                       #自動簽核
   LET l_smy.smyprint= m_oay[l_ac].oayprnt       #立即列印

   LET l_smy.smydmy1 = 'Y'                       #成本入項
   LET l_smy.smydmy2 = '2'                       #成會分類(銷)
   LET l_smy.smydmy4 = m_oay[l_ac].oayconf       #立即確認
   LET l_smy.smyware = '0'                       #倉庫設限方式
   LET l_smy.smy53   = l_oay24
   LET l_smy.smy56   = l_oay12
#MOD-D40117---add---START
   IF cl_null(l_smy.smy53) THEN LET l_smy.smy53 = 'N' END IF
   IF cl_null(l_smy.smy56) THEN LET l_smy.smy56 = 'Y' END IF 
#MOD-D40117---add-----END
   LET l_smy.smyacti = 'Y'
   LET l_smy.smyuser = g_user
   LET l_smy.smygrup = g_grup
   LET l_smy.smydate = g_today
   LET l_smy.smymxno = '0'                       #倉庫設限方式
   LET l_smy.smyapr  = m_oay[l_ac].oayapr        #簽核處理
   LET l_smy.smysign = l_oaysign       #簽核處理
   LET l_smy.smydays = '0'
   LET l_smy.smyprit = '0'
   LET l_smy.smy57   = 'NNNNN1'
   LET l_smy.smy58   = 'N'
   LET l_smy.smy59   = 'N'
   LET l_smy.smy74   = 'N'

   LET l_smy.smyoriu = g_user
   LET l_smy.smyorig = g_grup
   INSERT INTO smy_file VALUES(l_smy.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","smy_file",l_smy.smyslip,"","axm-278","","ins smy",1)
   ELSE                                              #FUN-AA0046
      CALL cl_err('','atm-890',1)                    #FUN-AA0046
   END IF

   CALL s_access_doc('a',l_smy.smyauno,l_smy.smykind,l_smy.smyslip,UPSHIFT(l_smy.smysys),l_smy.smyacti)
END FUNCTION

FUNCTION i010_upd_smy(l_kind)
DEFINE l_sql      STRING
DEFINE l_smy   RECORD LIKE smy_file.*
DEFINE l_kind LIKE smy_file.smykind
DEFINE l_oay12 LIKE oay_file.oay12
DEFINE l_oay24 LIKE oay_file.oay24
DEFINE l_oaysign LIKE oay_file.oaysign
   SELECT oay12,oay24,oaysign INTO l_oay12,l_oay24,l_oaysign FROM oay_file
    WHERE oayslip = m_oay[l_ac].oayslip

     LET l_sql = "SELECT * FROM smy_file WHERE smyslip=? FOR UPDATE"
     LET l_sql=cl_forupd_sql(l_sql)

     DECLARE i010_smy_bcl CURSOR FROM l_sql      # LOCK CURSOR

     OPEN i010_smy_bcl USING m_oay[l_ac].oayslip
     IF STATUS THEN
        CALL cl_err("OPEN i010_smy_bcl:", STATUS, 1)
        CLOSE i010_smy_bcl
        LET g_success = 'N'
        RETURN
     END IF
     UPDATE smy_file SET
            smy53    = l_oay24,        #內部交易單據否  #No.TQC-7B0149
            smydesc  = m_oay[l_ac].oaydesc,
            smyauno  = m_oay[l_ac].oayauno,
            smykind  = l_kind,
            smyprint = m_oay[l_ac].oayprnt,      #立即列印
            smydmy4  = m_oay[l_ac].oayconf,      #立即確認
            #smydmy5  = m_oay[l_ac].oaydmy6,      #編號方式 #FUN-A10109
            smy56    = l_oay12,        #呆滯日期
            smyapr   = m_oay[l_ac].oayapr,       #簽核處理
            smysign  = l_oaysign       #簽核處理
            WHERE smyslip = m_oay[l_ac].oayslip
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","smy_file",m_oay[l_ac].oayslip,"","axm-820","","upd smy",1)  #No.FUN-660167  #No.TQC-680137 modify
        LET g_success = 'N'
     ELSE
        CALL cl_err('','axm-820',1)   #MOD-750144 add
     END IF
     #FUN-A10109  ===S===
     SELECT * INTO l_smy.* FROM smy_file
      WHERE smyslip = m_oay[l_ac].oayslip
     CALL s_access_doc('u',l_smy.smyauno,l_smy.smykind,l_smy.smyslip,UPSHIFT(l_smy.smysys),l_smy.smyacti)
     #FUN-A10109  ===E===

     CLOSE i010_smy_bcl
END FUNCTION
#FUN-A70130 add 10/10/15------end


