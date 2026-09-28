# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri093.4gl
# Descriptions...: 刷卡资料维护
# Date & Author..: 13/07/18 By yangjian
# Modified.......: 13/08/07 By yeap NO.130807
# MODIFY.........: 20130909 BY ZHUZW 失效,取消失效逻辑调整
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrby             DYNAMIC ARRAY OF RECORD   
        chk             LIKE type_file.chr1,
        hrby12          LIKE hrby_file.hrby12,
        hrby01          LIKE hrby_file.hrby01,   
        hrby02          LIKE hrby_file.hrby02,
        hrby03          LIKE hrby_file.hrby03,
        hrby04          LIKE hrby_file.hrby04,
        hrby05          LIKE hrby_file.hrby05,
        hrby06          LIKE hrby_file.hrby06, 
        hrby07          LIKE hrby_file.hrby07,
        hrby08          LIKE hrby_file.hrby08,
        hrby09          LIKE hrby_file.hrby09, 
        hrat02          LIKE hrat_file.hrat02,
        hrat04          LIKE hrat_file.hrat04, #add by nixiang 170705
        hrao02          LIKE hrao_file.hrao02, #add by nixiang 170705
        hrby10          LIKE hrby_file.hrby10,
        hrby11          LIKE hrby_file.hrby11,
        hrby13          LIKE hrby_file.hrby13,
        hrby13_desc     LIKE type_file.chr100,
        hrbyacti        LIKE hrby_file.hrbyacti,
        hrbyud01        LIKE hrby_file.hrbyud01,
        hrbyud02        LIKE hrby_file.hrbyud02,
        hrbyud03        LIKE hrby_file.hrbyud03,
        hrbyud04        LIKE hrby_file.hrbyud04,
        hrbyud05        LIKE hrby_file.hrbyud05,
        hrbyud06        LIKE hrby_file.hrbyud06,
        hrbyud07        LIKE hrby_file.hrbyud07,
        hrbyud08        LIKE hrby_file.hrbyud08,
        hrbyud09        LIKE hrby_file.hrbyud09,
        hrbyud10        LIKE hrby_file.hrbyud10,
        hrbyud11        LIKE hrby_file.hrbyud11,
        hrbyud12        LIKE hrby_file.hrbyud12,
        hrbyud13        LIKE hrby_file.hrbyud13,
        hrbyud14        LIKE hrby_file.hrbyud14,
        hrbyud15        LIKE hrby_file.hrbyud15
                    END RECORD,
     g_hrby_t         RECORD   
        chk             LIKE type_file.chr1,             
        hrby12          LIKE hrby_file.hrby12,
        hrby01          LIKE hrby_file.hrby01,   
        hrby02          LIKE hrby_file.hrby02,
        hrby03          LIKE hrby_file.hrby03,
        hrby04          LIKE hrby_file.hrby04,
        hrby05          LIKE hrby_file.hrby05,
        hrby06          LIKE hrby_file.hrby06, 
        hrby07          LIKE hrby_file.hrby07,
        hrby08          LIKE hrby_file.hrby08,
        hrby09          LIKE hrby_file.hrby09, 
        hrat02          LIKE hrat_file.hrat02,
        hrat04          LIKE hrat_file.hrat04, #add by nixiang 170705
        hrao02          LIKE hrao_file.hrao02, #add by nixiang 170705 
        hrby10          LIKE hrby_file.hrby10,
        hrby11          LIKE hrby_file.hrby11,
        hrby13          LIKE hrby_file.hrby13,
        hrby13_desc     LIKE type_file.chr100,
        hrbyacti        LIKE hrby_file.hrbyacti,
        hrbyud01        LIKE hrby_file.hrbyud01,
        hrbyud02        LIKE hrby_file.hrbyud02,
        hrbyud03        LIKE hrby_file.hrbyud03,
        hrbyud04        LIKE hrby_file.hrbyud04,
        hrbyud05        LIKE hrby_file.hrbyud05,
        hrbyud06        LIKE hrby_file.hrbyud06,
        hrbyud07        LIKE hrby_file.hrbyud07,
        hrbyud08        LIKE hrby_file.hrbyud08,
        hrbyud09        LIKE hrby_file.hrbyud09,
        hrbyud10        LIKE hrby_file.hrbyud10,
        hrbyud11        LIKE hrby_file.hrbyud11,
        hrbyud12        LIKE hrby_file.hrbyud12,
        hrbyud13        LIKE hrby_file.hrbyud13,
        hrbyud14        LIKE hrby_file.hrbyud14,
        hrbyud15        LIKE hrby_file.hrbyud15
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING
DEFINE g_msg        LIKE type_file.chr1000
#added by yeap NO.130807-----str------
DEFINE g_max        LIKE type_file.num10
DEFINE 
     g_chexiao             DYNAMIC ARRAY OF RECORD   
        hrby01          LIKE hrby_file.hrby01,   
        hrby02          LIKE hrby_file.hrby02,
        hrby05          LIKE hrby_file.hrby05,   
        hrby09          LIKE hrby_file.hrby09,
        hrby12          LIKE hrby_file.hrby12
                    END RECORD
#added by yeap NO.130807-----end------

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i093_w AT p_row,p_col WITH FORM "ghr/42f/ghri093"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    CALL cl_set_comp_visible("chk",FALSE)    #added by yeap NO.130807
    CALL cl_set_comp_entry("hrby12,hrby01,hrby02,hrby03,hrby04,hrby07,hrby10,hrby11",FALSE)
     LET g_max = 0                           #added by yeap NO.130807

#    LET g_wc2 = '1=1'
#    CALL i093_b_fill(g_wc2)
    CALL i093_menu()
    CLOSE WINDOW i093_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i093_menu()
 
   WHILE TRUE
      CALL i093_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i093_q()
            END IF
    #marked by yeap NO.130807----str----
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i093_b()
            ELSE
               LET g_action_choice = NULL
            END IF
    #marked by yeap NO.130807----end----
         #added by yeap NO.130807----str----
         WHEN "ghri093_b"
            IF cl_chk_act_auth() THEN
#MARK BY ZHUZW 20130909   
 #            	 IF g_max = 0 THEN 
 #            	 	  CALL cl_err('','ghr-164',0)
 #            	 ELSE         	 	
 #           	 	  CALL i093_chexiao()
 #          	 	  CALL i093_b_fill(g_wc2) 
 #            	 	   LET g_max = 0
 #            	 END IF 
               CALL i093_b1() #ADD BY ZHUZW 20130909
            END IF
         WHEN "ghri093_a" 
            IF cl_chk_act_auth() THEN
               CALL i093_b1()
            END IF

         #added by yeap NO.130807----end----
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrby),'','')
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
            	CALL i093_x()
            END IF 
         WHEN "import"
            CALL i093_import()
#         WHEN "p_import"
#            CALL i093_p_import()            
            
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i093_q()
   CALL i093_b_askkey()
END FUNCTION
	
FUNCTION i093_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                   
    l_i             LIKE type_file.num5,    #added by yeap NO.130807                
    l_j             LIKE type_file.num5,    #added by yeap NO.130807                 
    l_k             LIKE type_file.num5,    #added by yeap NO.130807          
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid
DEFINE l_sql        STRING 
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING
DEFINE l_no         LIKE type_file.chr10   
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
    LET g_forupd_sql =
        "SELECT '',hrby12,hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby08,hrby09,'',hrby10,hrby11,hrby13,'',hrbyacti,
                hrbyud01,hrbyud02,hrbyud03,hrbyud04,hrbyud05,hrbyud06,hrbyud07,hrbyud08,hrbyud09,hrbyud10,hrbyud11,hrbyud12,hrbyud13,hrbyud14,hrbyud15
                 FROM hrby_file ",
        "  WHERE hrby01 = ? AND hrby09 = ?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i093_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
#   CALL i093_tmp()    #added by yeap NO.130807
    CALL cl_set_comp_visible("chk",TRUE)    #added by yeap NO.130807
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    INPUT ARRAY g_hrby WITHOUT DEFAULTS FROM s_hrby.*
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
        #CALL i093_auto_hrby01()
        CALL cl_set_comp_visible("chk",FALSE) 
        IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_hrby_t.* = g_hrby[l_ac].*    #BACKUP
                sELECT hratid INTO g_hrby_t.hrby09 FROM hrat_file WHERE hrat01=g_hrby_t.hrby09
                OPEN i093_bcl USING g_hrby[l_ac].hrby01,g_hrby[l_ac].hrby09
                IF STATUS THEN
                   CALL cl_err("OPEN i058_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE 
                   FETCH i093_bcl INTO g_hrby[l_ac].* 
                   SELECT hrat01,hrat02 INTO g_hrby[l_ac].hrby09,g_hrby[l_ac].hrat02 FROM hrat_file WHERE hratid=g_hrby[l_ac].hrby09
                   SELECT hrbm04 INTO g_hrby[l_ac].hrby13_desc FROM hrbm_file 
                   WHERE hrbm03 =g_hrby[l_ac].hrby13  AND hrbm07 ='Y' AND hrbm02 = '009'

                END IF

                CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF            
        CALL cl_set_comp_entry("hrby05,hrby06,hrby08,hrby09",TRUE)
        CALL cl_set_comp_entry("hrby13,hrbyacti",TRUE)
        CALL cl_set_comp_entry("hrbyud01,hrbyud02,hrbyud03,hrbyud04,hrbyud05,hrbyud06,hrbyud07,hrbyud08,hrbyud09,hrbyud10",TRUE)
        CALL cl_set_comp_entry("hrbyud11,hrbyud12,hrbyud13,hrbyud14,hrbyud15",TRUE)

    BEFORE INSERT
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
        INITIALIZE g_hrby[l_ac].* TO NULL
        LET g_hrby_t.* = g_hrby[l_ac].*        #新輸入資料        
        CALL cl_set_comp_entry("hrby05,hrby06,hrby09,hrby13,hrby08",TRUE) 
        LET g_hrby[l_ac].hrby12='2'
        CALL i093_auto_hrby01() RETURNING g_hrby[l_ac].hrby01
        LET g_hrby[l_ac].hrby02=1
        LET g_hrby[l_ac].hrby10='6'
        LET g_hrby[l_ac].hrby11='1'
        LET g_hrby[l_ac].hrbyacti='Y'
        CALL cl_show_fld_cont()     #FUN-550037(smin)

    AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CANCEL INSERT
        END IF
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrby[l_ac].hrby09
         INSERT INTO hrby_file(hrby01,hrby02,
                               hrby03,hrby04,
                               hrby05,hrby06,
                               hrby07,hrby08,
                               hrby09,hrby10,
                               hrby11,hrby12,
                               hrby13,hrbyacti)
              VALUES(g_hrby[l_ac].hrby01,g_hrby[l_ac].hrby02,
                     g_hrby[l_ac].hrby03,g_hrby[l_ac].hrby04,
                     g_hrby[l_ac].hrby05,g_hrby[l_ac].hrby06,
                     g_hrby[l_ac].hrby07,g_hrby[l_ac].hrby08,
                     l_hratid,g_hrby[l_ac].hrby10,
                     g_hrby[l_ac].hrby11,g_hrby[l_ac].hrby12,
                     g_hrby[l_ac].hrby13,g_hrby[l_ac].hrbyacti)

        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrby_file",g_hrby_t.hrby01,g_hrby_t.hrby09,SQLCA.sqlcode,"","",1) #FUN-660105
            CANCEL INSERT
        ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1    
            DISPLAY g_rec_b TO FORMONLY.cn2     
        END IF
    
        
    
    AFTER FIELD hrby09
       IF NOT cl_null(g_hrby[l_ac].hrby09) THEN 
          LET l_n=0 
          SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hratconf='Y' AND hrat01= g_hrby[l_ac].hrby09
          IF l_n=0 THEN 
             CALL cl_err('工号不存在','!',1)
             NEXT FIELD hrby09
          ELSE 
             SELECT hrat02 INTO g_hrby[l_ac].hrat02 FROM hrat_file WHERE hrat01=g_hrby[l_ac].hrby09
             DISPLAY g_hrby[l_ac].hrat02 TO hrat02  
          END IF 
 
       END IF    
       
    AFTER FIELD hrby13  
       IF NOT cl_null(g_hrby[l_ac].hrby13) THEN 
          SELECT hrbm04 INTO g_hrby[l_ac].hrby13_desc FROM hrbm_file 
                WHERE hrbm03 =g_hrby[l_ac].hrby13  AND hrbm07 ='Y' AND hrbm02 = '009'
          DISPLAY g_hrby[l_ac].hrby13_desc TO hrby13_desc

       END IF 

    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrby[l_ac].* = g_hrby_t.*
         CLOSE i093_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrby[l_ac].hrby01,-263,0)
          LET g_hrby[l_ac].* = g_hrby_t.*
       ELSE
          SELECT hratid INTO l_hratid FROM hrat_file
          WHERE hrat01 = g_hrby[l_ac].hrby09 
          UPDATE hrby_file SET hrby05=g_hrby[l_ac].hrby05,
                               hrby06=g_hrby[l_ac].hrby06,
                               hrby08=g_hrby[l_ac].hrby08,    
                               hrby09=l_hratid,   
                               hrby13=g_hrby[l_ac].hrby13,
                               hrbyacti=g_hrby[l_ac].hrbyacti
          WHERE hrby01 = g_hrby_t.hrby01 AND hrby09=g_hrby_t.hrby09
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrby_file",g_hrby_t.hrby01,g_hrby_t.hrat02,SQLCA.sqlcode,"","",1) 
             ROLLBACK WORK    
             LET g_hrby[l_ac].* = g_hrby_t.*
          END IF
       END IF
        	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrby[l_ac].* = g_hrby_t.*
          END IF
          CLOSE i093_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i093_bcl                
        COMMIT WORK  

    BEFORE DELETE                           
       IF g_hrby_t.hrby01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL               
          LET g_doc.column1 = "hrby01"               
          LET g_doc.value1 = g_hrby[l_ac].hrby01      
          CALL cl_del_doc()                                          
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      
             CANCEL DELETE 
          END IF 
          
          IF g_hrby_t.hrby12='1' THEN 
             CALL cl_err('数据采集数据不可删除','!',1)
             ROLLBACK WORK      
             CANCEL DELETE
          END IF  
         
          DELETE FROM hrby_file WHERE hrby01 = g_hrby_t.hrby01 AND hrby09 =g_hrby_t.hrby09
                                 
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrby_file",g_hrby_t.hrby01,g_hrby_t.hrat02,SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK      
              CANCEL DELETE
              EXIT INPUT
          ELSE
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF 
       END IF

     ON ACTION controlp 
        CASE 
        WHEN INFIELD(hrby09)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrat01"
            LET g_qryparam.default1 = g_hrby[l_ac].hrby09
            CALL cl_create_qry() RETURNING g_hrby[l_ac].hrby09
            DISPLAY g_hrby[l_ac].hrby01 TO hrby09
            NEXT FIELD hrby09
        WHEN INFIELD(hrby13)
            CALL cl_init_qry_var()
            LET g_qryparam.arg1 = "('009')"
            LET g_qryparam.form ="q_hrbm033"
            LET g_qryparam.default1 = g_hrby[l_ac].hrby13
            CALL cl_create_qry() RETURNING g_hrby[l_ac].hrby13
            DISPLAY BY NAME g_hrby[l_ac].hrby13
            NEXT FIELD hrby13
        OTHERWISE
            EXIT CASE
        END CASE 
                   
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
    END INPUT
    
    CLOSE i093_bcl
    COMMIT WORK
   # CALL i093_b_fill(g_wc2)
END FUNCTION    
	
FUNCTION i093_b_askkey()
    CLEAR FORM
    CALL g_hrby.clear()
 
    CONSTRUCT g_wc2 ON hrby12,hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,
                       hrby08,hrby09,hrby10,hrby11,hrby13,hrbyacti,
                       hrbyud01,hrbyud02,hrbyud03,hrbyud04,hrbyud05,
                       hrbyud06,hrbyud07,hrbyud08,hrbyud09,hrbyud10,
                       hrbyud11,hrbyud12,hrbyud13,hrbyud14,hrbyud15                       
         FROM s_hrby[1].hrby12,s_hrby[1].hrby01,s_hrby[1].hrby02,s_hrby[1].hrby03,s_hrby[1].hrby04,s_hrby[1].hrby05,
              s_hrby[1].hrby06,s_hrby[1].hrby07, s_hrby[1].hrby08,s_hrby[1].hrby09,s_hrby[1].hrby10,s_hrby[1].hrby11,
              s_hrby[1].hrby13,s_hrby[1].hrbyacti,
              s_hrby[1].hrbyud01,s_hrby[1].hrbyud02,s_hrby[1].hrbyud03,s_hrby[1].hrbyud04,s_hrby[1].hrbyud05,
              s_hrby[1].hrbyud06,s_hrby[1].hrbyud07,s_hrby[1].hrbyud08,s_hrby[1].hrbyud09,s_hrby[1].hrbyud10,
              s_hrby[1].hrbyud11,s_hrby[1].hrbyud12,s_hrby[1].hrbyud13,s_hrby[1].hrbyud14,s_hrby[1].hrbyud15 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrby03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrby03
                 NEXT FIELD hrby03
               
            WHEN INFIELD(hrby09)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrby09
               NEXT FIELD hrby09
               
         OTHERWISE
              EXIT CASE
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
 
    
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbyuser', 'hrbygrup')
   CALL cl_replace_str(g_wc2,'hrby09','hrat01') RETURNING g_wc2  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i093_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i093_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	

DEFINE l_n  LIKE type_file.num5 
DEFINE l_hrbk05 LIKE hrbk_file.hrbk05
DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT 'N',hrby12,hrby01,hrby02,hrby03,hrby04,hrby05,",
                   "       hrby06,hrby07,hrby08,hrby09,hrat02,hrby10,hrby11,hrby13,hrbm04,hrbyacti, ",
                   "       hrbyud01,hrbyud02,hrbyud03,hrbyud04,hrbyud05,",
                   "       hrbyud06,hrbyud07,hrbyud08,hrbyud09,hrbyud10,",
                   "       hrbyud11,hrbyud12,hrbyud13,hrbyud14,hrbyud15 ",
                   " FROM hrby_file,hrat_file,hrbm_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid(+)=hrby09 ",
                   "   AND hrbm03(+)=hrby13 ",
                   "   AND (hrby03 IN('1','2','3','4','5','6','7','8','9','10','18','20') OR hrby12='2')",  #add by nixiang170718 只显示1-10号考勤机的数据
                   " ORDER BY hrby09,hrby05,hrby06 " 
 
    PREPARE i093_pb FROM g_sql
    DECLARE hrby_curs CURSOR FOR i093_pb
 
    CALL g_hrby.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrby_curs INTO g_hrby[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
      
        #显示工号
        SELECT hrat01 INTO g_hrby[g_cnt].hrby09 FROM hrat_file 
         WHERE hratid=g_hrby[g_cnt].hrby09
           AND hratacti='Y'
           AND hratconf='Y'
        #姓名   
#        SELECT hrat02 INTO g_hrby[g_cnt].hrat02
#          FROM hrat_file
#         WHERE hrat01=g_hrby[g_cnt].hrby01
#           AND hratacti='Y'
#           AND hratconf='Y'

        #显示部门代号/名称 #add by nixiang 170705
        SELECT hrat04 INTO g_hrby[g_cnt].hrat04 FROM hrat_file
         WHERE hrat01=g_hrby[g_cnt].hrby09
         
        SELECT hrao02 INTO g_hrby[g_cnt].hrao02 FROM hrao_file
         WHERE hrao01=g_hrby[g_cnt].hrat04

#added by yeap NO.130807---------str---------
       CASE g_hrby[g_cnt].hrby10
       	    WHEN 1 LET g_hrby[g_cnt].hrby10 = "考勤"
       	    WHEN 2 LET g_hrby[g_cnt].hrby10 = "上班"
       	    WHEN 3 LET g_hrby[g_cnt].hrby10 = "下班"
       	    WHEN 4 LET g_hrby[g_cnt].hrby10 = "门禁"
       	    WHEN 5 LET g_hrby[g_cnt].hrby10 = "就餐"
       	    WHEN 6 LET g_hrby[g_cnt].hrby10 = "通用" 
       END CASE 
#added by yeap NO.130807---------end---------
           
        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
					IF g_cnt > 50000 THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrby.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i093_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrby TO s_hrby.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
     
     #marked by yeap NO.130807----str----
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
     #marked by yeap NO.130807----end----    
 
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
 
      
      #marked by yeap NO.130807----str----
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      #marked by yeap NO.130807----end----
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
       
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      
      #added by yeap NO.130807----str----     
      ON ACTION ghri093_a
         LET g_action_choice="ghri093_a"
         EXIT DISPLAY
         
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY

#      ON ACTION p_import
#         LET g_action_choice="p_import"
#         EXIT DISPLAY         

      ON ACTION ghri093_b
         LET g_action_choice="ghri093_b"
         EXIT DISPLAY
      #added by yeap NO.130807----end----
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
      
      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	  
FUNCTION i093_import()
DEFINE l_file     LIKE type_file.chr200
DEFINE l_count    LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE xlApp      INTEGER
DEFINE iRes       INTEGER
DEFINE iRow       INTEGER
DEFINE l_code     LIKE hrat_file.hrat01
DEFINE l_name     LIKE hrat_file.hrat02
DEFINE l_date     LIKE hrby_file.hrby05
DEFINE l_time     LIKE hrby_file.hrby06
DEFINE l_reason   LIKE hrby_file.hrby13
DEFINE l_remark   LIKE hrby_file.hrby08
DEFINE l_hrby01   LIKE hrby_file.hrby01
DEFINE i          LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_hrby     RECORD LIKE hrby_file.*

   LET l_sql = "SELECT to_char(SYSDATE,'yyyymmdd')||LPAD(to_number(nvl(substr(MAX(hrby01),9,6),0))+1,6,0) FROM hrby_file"
   PREPARE i093_01 FROM l_sql
   DECLARE i093_01_cs CURSOR FOR i093_01
   FOREACH i093_01_cs INTO l_hrby01
   END FOREACH 
   IF cl_null(l_hrby01) THEN 
      CALL cl_err('自动生成ID失败','!',1)
      RETURN 
   END IF 
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   IF NOT cl_null(l_file) THEN
      LET l_count=length(l_file)
      IF l_count=0 THEN 
         RETURN
      END IF 
      LET l_sql=l_file
      CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_sql],[iRes])
         IF iRes<>-1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            CALL cl_progress_bar(iROW-1)
            FOR i=2 TO iRow
                INITIALIZE l_hrby.* TO NULL
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_code])  #读取员工工号
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_name])  #读取员工姓名
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_date]) #读取补刷卡日期
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[l_time]) #读取补刷卡时间
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[l_reason]) #读取补刷卡原因
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[l_remark]) #读取补刷卡备注^M
                IF cl_null(l_code) THEN 
                   CALL cl_progressing('')

                   CONTINUE FOR
                END IF
                LET l_hrby.hrby01=l_hrby01
                LET l_hrby.hrby02=i-1
                LET l_hrby.hrby05=l_date
                LET l_hrby.hrby06=l_time
                LET l_n = 0
                SELECT LENGTH(l_time) INTO l_n FROM DUAL
                IF l_n <> 5 THEN
                   CALL cl_err('日期格式不对','!',1)
                   CALL cl_progressing(l_time)
                   CONTINUE FOR
                END IF 
                LET l_hrby.hrby08=l_remark
                SELECT hratid INTO l_hrby.hrby09 FROM hrat_file WHERE hrat01=l_code
                LET l_hrby.hrby10=6
                LET l_hrby.hrby11=1
                LET l_hrby.hrby12='2'
                LET l_hrby.hrby13=l_reason 
                LET l_hrby.hrbyacti='Y'
                INSERT INTO hrby_file VALUES (l_hrby.*)
                UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05
                CALL cl_progressing(l_name)
            END FOR 
         END IF 
      END IF 
   END IF 
END FUNCTION

FUNCTION i093_x()
 DEFINE l_n  LIKE  type_file.num5
    
    IF NOT cl_confirm('abx-080') THEN RETURN END IF 
    LET g_success = 'Y'
    BEGIN WORK
    FOR l_n = 1 TO g_rec_b
       IF g_hrby[l_n].chk = 'Y' THEN 
          IF g_hrby[l_n].hrbyacti='Y' THEN
            LET g_hrby[l_n].hrbyacti='N'
          ELSE
            LET g_hrby[l_n].hrbyacti='Y'
          END IF
          UPDATE hrby_file
             SET hrbyacti=g_hrby[l_n].hrbyacti
            WHERE hrby12 = g_hrby[l_n].hrby12
              AND hrby01 = g_hrby[l_n].hrby01
              AND hrby02 = g_hrby[l_n].hrby02
          IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrby[l_n].hrby01,SQLCA.sqlcode,0)
            LET g_success = 'N'
          END IF
       END IF 
    END FOR
    IF g_success = 'Y' THEN
    	 COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF 
    CALL cl_set_comp_visible("chk",FALSE) 
    CALL i093_b_fill(g_wc2)
END FUNCTION
	
	
#added by yeap NO.130807-----str------	
FUNCTION i093_chexiao()
	DEFINE l_n        LIKE type_file.num10
  DEFINE l_k        LIKE type_file.num5,    
         l_hratid    LIKE hrat_file.hratid
	
	
	DECLARE i093_cl_1 CURSOR FOR SELECT * FROM hrby_tmp
   
    LET g_cnt = 1
    MESSAGE "Searching!"
    CALL g_chexiao.clear() 
    FOREACH i093_cl_1 INTO g_chexiao[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
        	
    IF NOT cl_null(g_chexiao[g_cnt].hrby01) THEN
       UPDATE hrby_file
          SET hrbyacti = 'Y'
        WHERE hrby01 = g_chexiao[g_cnt].hrby01
          AND hrby02 = g_chexiao[g_cnt].hrby02
          AND hrby12 = g_chexiao[g_cnt].hrby12
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","hrby_file",g_chexiao[g_cnt].hrby01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ELSE
            	MESSAGE 'UPDATE O.K'
            	SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_chexiao[g_cnt].hrby09
            	SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 = g_chexiao[g_cnt].hrby05
            	IF l_k > 0 THEN 
            	   UPDATE hrcp_file
            	     	SET hrcp35 = 'N'
            	   WHERE hrcp02 = l_hratid AND hrcp03 = g_chexiao[g_cnt].hrby05
            	END IF
           END IF 
    END IF 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max THEN
       #    CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DROP TABLE hrby_tmp
    CALL g_chexiao.deleteElement(g_cnt)
    MESSAGE ""
    LET g_cnt = 0
END FUNCTION 
	
FUNCTION i093_tmp()
	 DROP TABLE hrby_tmp
   CREATE TEMP TABLE hrby_tmp
   (
    hrby01       VARCHAR(20),
    hrby02       DEC(5), 
    hrby05       DATE,
    hrby09       VARCHAR(50),
    hrby12       VARCHAR(1)
    )
END FUNCTION	
#added by yeap NO.130807-----end------
#add by zhuzw 20130909 start
FUNCTION i093_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                   
    l_i             LIKE type_file.num5,    #added by yeap NO.130807                
    l_j             LIKE type_file.num5,    #added by yeap NO.130807                 
    l_k             LIKE type_file.num5,    #added by yeap NO.130807          
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid
DEFINE l_sql        STRING 
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING
DEFINE l_no         LIKE type_file.chr10   
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
    CALL cl_set_comp_visible("chk",TRUE)
#    CALL i093_tmp()    #added by yeap NO.130807
    
    INPUT ARRAY g_hrby WITHOUT DEFAULTS FROM s_hrby.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        CALL cl_set_comp_entry('chk',TRUE)
        CALL cl_set_comp_entry("hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby08,hrby09,hrby10",FALSE)
        CALL cl_set_comp_entry("hrby11,hrby12,hrby13,hrbyacti",FALSE)
        CALL cl_set_comp_entry("hrbyud01,hrbyud02,hrbyud03,hrbyud04,hrbyud05,hrbyud06,hrbyud07,hrbyud08,hrbyud09,hrbyud10",FALSE)
        CALL cl_set_comp_entry("hrbyud11,hrbyud12,hrbyud13,hrbyud14,hrbyud15",FALSE)
        	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrby[l_ac].* = g_hrby_t.*
          END IF
          EXIT INPUT
        END IF
        	
#added by yeap NO.130807-----str-----------
    AFTER INPUT 
    LET l_i = 0
    LET l_j = 0
    IF cl_confirm('ghr-167') THEN 
       FOR l_i = 1 TO g_rec_b
           IF g_hrby[l_i].chk = 'Y' THEN 
           	  IF NOT cl_null(g_hrby[l_i].hrbyacti)  THEN 
           	  	IF g_hrby[l_i].hrbyacti='N' THEN 
        	       LET g_hrby[l_i].hrbyacti = 'Y'
        	       ELSE 
        	       LET g_hrby[l_i].hrbyacti = 'N'
        	     END IF 
        	       DISPLAY BY NAME g_hrby[l_i].hrbyacti
        	       IF SQLCA.sqlcode THEN
                    CALL cl_err('g_hrby[l_i].hrby01',"ghr-163",0) 
                 ELSE 
                  	UPDATE hrby_file
              	       SET hrbyacti = g_hrby[l_i].hrbyacti
              	     WHERE hrby01 = g_hrby[l_i].hrby01
              	       AND hrby02 = g_hrby[l_i].hrby02
              	       AND hrby12 = g_hrby[l_i].hrby12
              	   
               	        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","hrby_file",g_hrby[l_i].hrby01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                        ELSE
            	             MESSAGE 'UPDATE O.K'
            	             SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrby[l_i].hrby09
            	             SELECT COUNT(*) INTO l_k FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 = g_hrby[l_i].hrby05
            	             IF l_k > 0 THEN 
            	              	UPDATE hrcp_file
            	              	   SET hrcp35 = 'N'
            	           	     WHERE hrcp02 = l_hratid AND hrcp03 = g_hrby[l_i].hrby05
            	             END IF 
                    	  END IF 
              	 END IF 
              LET g_hrby[l_i].chk = 'N'
             	DISPLAY BY NAME g_hrby[l_i].chk
              END IF   
        	 END IF 
       END FOR 
    END IF 
#added by yeap NO.130807-----end-----------       
        
     ON ACTION sel_all
        FOR l_n = 1 TO g_rec_b
           LET g_hrby[l_n].chk = 'Y'
        END FOR

     ON ACTION sel_none
        FOR l_n = 1 TO g_rec_b
           LET g_hrby[l_n].chk = 'N'
        END FOR
         
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
    END INPUT
    CALL cl_set_comp_visible("chk",FALSE)    
END FUNCTION    
#add by zhuzw 20130909 end 


FUNCTION i093_p_import()
DEFINE l_file     LIKE type_file.chr200
DEFINE l_name     LIKE type_file.chr200
DEFINE l_count    LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE xlApp      INTEGER
DEFINE iRes       INTEGER
DEFINE iRow       INTEGER
DEFINE iColumn    INTEGER
DEFINE iDay       INTEGER
DEFINE i,j,k      LIKE type_file.num5
DEFINE l_hrby     RECORD LIKE hrby_file.*
DEFINE p_hrcp     RECORD LIKE hrcp_file.*
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_hrboa02  LIKE hrboa_file.hrboa02
DEFINE l_hrboa05  LIKE hrboa_file.hrboa05
DEFINE l_date     LIKE hrcp_file.hrcp03
DEFINE l_hrbo03     LIKE hrbo_file.hrbo03
DEFINE l_hrby01   LIKE hrby_file.hrby01
DEFINE l_err     LIKE type_file.chr200
DEFINE l_hrat01  LIKE hrat_file.hrat01
DEFINE l_hrat04  LIKE hrat_file.hrat04

   LET l_sql = "SELECT to_char(SYSDATE,'yyyymmdd')||LPAD(to_number(nvl(substr(MAX(hrby01),9,6),0))+1,6,0) FROM hrby_file"
   PREPARE i093_02 FROM l_sql
   DECLARE i093_02_cs CURSOR FOR i093_02
   FOREACH i093_02_cs INTO l_hrby01
   END FOREACH 
   IF cl_null(l_hrby01) THEN 
      CALL cl_err('自动生成ID失败','!',1)
      RETURN 
   END IF 

    INITIALIZE l_hrby.* TO NULL

   LET l_file = cl_browse_file()
   LET l_file = l_file CLIPPED
   IF NOT cl_null(l_file) THEN
      LET l_count=length(l_file)
      IF l_count=0 THEN
         RETURN
      END IF
      LET l_sql=l_file
      CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_sql],[iRes])
         IF iRes<>-1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Columns.Count'],[iColumn])
            CALL cl_progress_bar(iROW-1)
            FOR i=2 TO iRow
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_hrby.hrby09])  #读取员工工号
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_name])  #读取员工姓名
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_hrby.hrby05]) #读取日期
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[l_hrby.hrby13]) #补卡原因
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[l_hrby.hrby08]) #备注
                
                IF (cl_null(l_hrby.hrby09) OR l_hrby.hrby09=' ') THEN
                   CONTINUE FOR
                END IF
                FOR j=4 TO 9 STEP 1
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||j||').Value'],[l_hrby.hrby06]) #读取刷卡
                   IF cl_null(l_hrby.hrby06) OR l_hrby.hrby06=' ' THEN
                      CONTINUE FOR
                   END IF
                   SELECT hratid INTO l_hrby.hrby09 FROM hrat_file WHERE hrat01=l_hrby.hrby09 AND rownum=1  #获取员工ID

                      LET l_hrby.hrby01=l_hrby01
                      SELECT MAX(hrby02)+1 INTO l_hrby.hrby02 FROM hrby_file 
                      IF cl_null(l_hrby.hrby02) THEN LET l_hrby.hrby02=1 END IF 
                      LET l_hrby.hrby10=6
                      LET l_hrby.hrby11=1
                      LET l_hrby.hrby12='2'
                      LET l_hrby.hrbyacti='Y'
                      INSERT INTO hrby_file VALUES (l_hrby.*)
                      UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05
               END FOR

               CALL cl_progressing(l_name)

            END FOR
            CALL cl_err('导入结束','!',1)
         END IF
      END IF
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
   END IF
END FUNCTION

FUNCTION i093_auto_hrby01()
   DEFINE l_yy                 SMALLINT
   DEFINE l_mm                 SMALLINT
   DEFINE l_dd,i                 SMALLINT
   DEFINE ls_date              STRING
   DEFINE l_max_no             LIKE hrby_file.hrby01
   DEFINE ls_max_no            STRING
   DEFINE ls_format            STRING
   DEFINE ls_max_pre           STRING
   DEFINE li_max_num           LIKE type_file.num20
   DEFINE li_max_comp          LIKE type_file.num20
   DEFINE l_hrby01             LIKE hrby_file.hrby01
   DEFINE l_sql                STRING
   LET ls_max_pre = '9999999999'    #marked by yeap  NO.130826
  # LET ls_max_pre = '999999999999'   #added by yeap  NO.130826
   LET li_max_num=0
   LET li_max_comp= 0
   LET l_yy   = YEAR(g_today)
   LET l_mm   = MONTH(g_today)
   LET l_dd   = DAY(g_today)
   LET ls_date = l_yy USING "&&&&",l_mm USING "&&",l_dd USING "&&" 
   LET ls_date = ls_date.substring(3,8)   #marked by yeap  NO.130826

   LET l_sql ="SELECT MAX(hrby01) FROM hrby_file ",
              " WHERE hrby01 LIKE '",ls_date CLIPPED,"%'"
   PREPARE auto_no_pre FROM l_sql
   EXECUTE auto_no_pre INTO l_max_no

   IF l_max_no IS NULL THEN
      LET l_hrby01 = ls_date CLIPPED,'0001'
   ELSE
      LET ls_max_no = l_max_no[7,10]   #marked by yeap  NO.130826
#      LET ls_max_no = l_max_no[9,12]    #added by yeap  NO.130826 
      LET li_max_num = ls_max_pre.subString(1,4)  #最大編號值
      FOR i=1 TO 4
          LET ls_format = ls_format,"&"
      END FOR
      LET li_max_comp = ls_max_no + 1
      IF li_max_comp > li_max_num THEN
         CALL cl_err("","sub-518",1)
      ELSE
         LET l_hrby01 = ls_date CLIPPED,li_max_comp USING ls_format
      END IF
    END IF    
    RETURN l_hrby01
END FUNCTION