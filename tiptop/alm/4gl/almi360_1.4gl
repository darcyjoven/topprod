# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: almi360_1.4gl
# Descriptions...: 費用設置攤位選擇作業
# Date & Author..: NO:FUN-870010 08/07/21 By lilingyu 
# Modify.........: No:FUN-960134 09/07/14 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:TQC-A10159 10/01/29 By shiwuying 攤位開窗增加全選功能
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lmx           DYNAMIC ARRAY OF RECORD    
         lmx08              LIKE lmx_file.lmx08,
         lmx09              LIKE lmx_file.lmx09
                     END RECORD,
     g_lmx_t         RECORD    
         lmx08              LIKE lmx_file.lmx08,
         lmx09              LIKE lmx_file.lmx09
                     END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lmx_file.lmx01
DEFINE g_argv2               LIKE lmx_file.lmxstore
DEFINE g_argv3               LIKE lmx_file.lmx03
DEFINE g_argv4               LIKE lmx_file.lmx04
DEFINE g_argv5               LIKE lmx_file.lmx05
DEFINE g_argv6               LIKE lmx_file.lmx06
DEFINE g_argv7               LIKE lmx_file.lmx07
DEFINE g_argv8               LIKE lmx_file.lmx08
DEFINE g_lmx01               LIKE lmx_file.lmx01
DEFINE g_lmxstore            LIKE lmx_file.lmxstore
DEFINE g_lmx03               LIKE lmx_file.lmx03
DEFINE g_lmx04               LIKE lmx_file.lmx04
DEFINE g_lmx05               LIKE lmx_file.lmx05
DEFINE g_lmx06               LIKE lmx_file.lmx06
DEFINE g_lmx07               LIKE lmx_file.lmx07
DEFINE g_lnl09               LIKE lnl_file.lnl09
DEFINE g_lnl10               LIKE lnl_file.lnl10
DEFINE g_lnl03               LIKE lnl_file.lnl03
DEFINE g_lnl04               LIKE lnl_file.lnl04
DEFINE g_lnl05               LIKE lnl_file.lnl05
DEFINE g_lnl06               LIKE lnl_file.lnl06 
DEFINE g_lnl07               LIKE lnl_file.lnl07
DEFINE g_lmx08               STRING              #No.TQC-A10159
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW i360_1_w WITH FORM "alm/42f/almi360_1" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    CALL i360_1_xxx()
      
    IF ((NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)))  THEN
       LET g_wc2 = "lmx01 = '",g_argv1,"' and lmxstore = '",g_argv2,"' and lmx03= '",g_argv3,"' and lmx04 = '",g_argv4,"'",
                   " and lmx05 = '",g_argv5,"' and lmx06 = '",g_argv6,"' and lmx07= '",g_argv7,"'"     
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  

   #No.TQC-A10159 -BEGIN-----
    DROP TABLE i3601_tmp;   
    CREATE TEMP TABLE i3601_tmp(
          lmx08 LIKE lmx_file.lmx08);
    CREATE UNIQUE INDEX i3601_tmp_01 ON i3601_tmp(lmx08);
   #No.TQC-A10159 -END-------

    CALL i360_1_b_fill(g_wc2)
    
    CALL i360_1_menu()
 
    CLOSE WINDOW i360_1_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i360_1_xxx()
 LET g_argv1 = ARG_VAL(1)
 LET g_argv2 = ARG_VAL(2)
 LET g_argv3 = ARG_VAL(3)
 LET g_argv4 = ARG_VAL(4)
 LET g_argv5 = ARG_VAL(5) 
 LET g_argv6 = ARG_VAL(6)
 LET g_argv7 = ARG_VAL(7)
 LET g_argv8 = ARG_VAL(8)
 IF cl_null(g_argv1) THEN 
    LET g_argv1 = ' '
 END IF    
 IF cl_null(g_argv2) THEN 
    LET g_argv2 = ' '
 END IF  
 IF cl_null(g_argv3) THEN 
    LET g_argv3 = ' '
 END IF 
 IF cl_null(g_argv4) THEN 
    LET g_argv4 = ' '
 END IF 
 IF cl_null(g_argv5) THEN 
    LET g_argv5 = ' '
 END IF 
 IF cl_null(g_argv6) THEN 
    LET g_argv6 = ' '
 END IF 
 IF cl_null(g_argv7) THEN 
    LET g_argv7 = ' '
 END IF 
 IF cl_null(g_argv8) THEN 
    LET g_argv8 = ' '
 END IF 
 
 LET g_lmx01   = NULL
 LET g_lmx01   = g_argv1
 
 LET g_lmxstore   = NULL
 LET g_lmxstore   = g_argv2
 
 LET g_lmx03   = NULL
 LET g_lmx03   = g_argv3
 
 LET g_lmx04   = NULL
 LET g_lmx04   = g_argv4
 
 LET g_lmx05   = NULL
 LET g_lmx05   = g_argv5
 
 LET g_lmx06   = NULL
 LET g_lmx06   = g_argv6
 
 LET g_lmx07   = NULL
 LET g_lmx07   = g_argv7 
END FUNCTION 
 
FUNCTION i360_1_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL i360_1_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i360_1_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i360_1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lmx[l_ac].lmx08 IS NOT NULL THEN
                  LET g_doc.column1 = "lmx08"
                  LET g_doc.value1 = g_lmx[l_ac].lmx08
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmx),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i360_1_q()
   CALL i360_1_b_askkey()
END FUNCTION
 
FUNCTION i360_1_b()
DEFINE
   l_ac_t          LIKE type_file.num5,           
   l_n             LIKE type_file.num5, 
   l_lmfstore      LIKE lmf_file.lmfstore,
   l_lmf06         LIKE lmf_file.lmf06, 
   l_lnm10         LIKE lnm_file.lnm10,  
   l_lock_sw       LIKE type_file.chr1,          
   p_cmd           LIKE type_file.chr1,         
   l_allow_insert  LIKE type_file.chr1,         
   l_allow_delete  LIKE type_file.chr1           
DEFINE l_lnm12     LIKE lnm_file.lnm12
DEFINE l_lnmacti   LIKE lnm_file.lnmacti
    
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
    SELECT lnm12,lnmacti INTO l_lnm12,l_lnmacti 
      FROM lnm_file
     WHERE lnm01      = g_argv1
       AND lnmstore   = g_argv2
       AND lnm03      = g_argv3
       AND lnm04      = g_argv4
       AND lnm05      = g_argv5
       AND lnm06      = g_argv6
       AND lnm07      = g_argv7 
   IF l_lnm12 = 'Y' THEN 
      CALL cl_err('','alm-148',1)
      RETURN 
    END IF   
   IF l_lnmacti = 'N' THEN       
      CALL cl_err('','alm-150',1)
      RETURN 
   END IF 
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lmx08,lmx09", 
                      " FROM lmx_file WHERE ",
                      " lmx01= '",g_argv1,"' and lmxstore = '",g_argv2,"'",
                      " and lmx03 = '",g_argv3,"' and lmx04 = '",g_argv4,"'",
                      " and lmx05 = '",g_argv5,"' and lmx06 = '",g_argv6,"'",
                      " and lmx07 = '",g_argv7,"' and lmx08 =?  FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i360_1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lmx WITHOUT DEFAULTS FROM s_lmx.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'           
          LET l_n  = ARR_COUNT()
           
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL i360_1_set_entry(p_cmd)                                         
             CALL i360_1_set_no_entry(p_cmd) 
           ##################################
            CALL i360_1_check()
            CALL i360_1_lnl03(g_lnl03)
            CALL i360_1_lnl04(g_lnl04)
            CALL i360_1_lnl05(g_lnl05)
            CALL i360_1_lnl06(g_lnl06)
            CALL i360_1_lnl07(g_lnl07)
            ##############################                            
             LET g_before_input_done = TRUE   
             LET g_lmx_t.* = g_lmx[l_ac].*  
            OPEN i360_1_bcl USING g_lmx_t.lmx08 
        
             IF STATUS THEN
                CALL cl_err("OPEN i360_1_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
             	##
                FETCH i360_1_bcl INTO g_lmx[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lmx_t.lmx08,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL i360_1_set_entry(p_cmd)                                            
          CALL i360_1_set_no_entry(p_cmd) 
          CALL i360_1_check()
          CALL i360_1_lnl03(g_lnl03)
          CALL i360_1_lnl04(g_lnl04)
          CALL i360_1_lnl05(g_lnl05)
          CALL i360_1_lnl06(g_lnl06)
          CALL i360_1_lnl07(g_lnl07)                                         
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lmx[l_ac].* TO NULL    
          LET g_lmx_t.* = g_lmx[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lmx08
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i360_1_bcl
             CANCEL INSERT
          END IF
  
       INSERT INTO lmx_file(lmx01,lmxstore,lmx03,lmx04,lmx05,lmx06,lmx07,lmx08,lmx09,lmxlegal)   #FUN-A60064 add lmxlegal
           VALUES(g_lmx01,g_lmxstore,g_lmx03,g_lmx04,g_lmx05,g_lmx06,g_lmx07,
                  g_lmx[l_ac].lmx08,g_lmx[l_ac].lmx09,g_legal)    #FUN-A60064 add g_legal
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lmx_file",g_lmx[l_ac].lmx08,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       AFTER FIELD lmx08                        
          IF NOT cl_null(g_lmx[l_ac].lmx08) THEN
             IF g_lmx[l_ac].lmx08 != g_lmx_t.lmx08 OR
                g_lmx_t.lmx08 IS NULL THEN
                SELECT count(*) INTO l_n FROM lmf_file                
                 WHERE lmf01 = g_lmx[l_ac].lmx08
                IF l_n < 1 THEN
                   CALL cl_err('','alm-057',0)                  
                   NEXT FIELD lmx08
                ELSE
                	  SELECT lmf06 INTO l_lmf06 FROM lmf_file                	 
                	   WHERE lmf01  = g_lmx[l_ac].lmx08
                	  IF l_lmf06 != 'Y' THEN 
                	     CALL cl_err('','alm-059',0)                  	    
                       NEXT FIELD lmx08   
                    ELSE
                    	 LET l_n = 0 
                    	 IF NOT cl_null(g_argv4) THEN 
                    	   SELECT COUNT(*) INTO l_n FROM lmf_file
                    	    WHERE lmf06 = 'Y'
                    	      AND lmf01 = g_lmx[l_ac].lmx08
                    	      AND lmfstore = g_argv2
                    	      AND lmf03 = g_argv3
                    	      AND lmf04 = g_argv4 
                    	  ELSE
                    	  	IF cl_null(g_argv4) AND NOT cl_null(g_argv3) THEN 
                    	  	   SELECT COUNT(*) INTO l_n FROM lmf_file
                    	  	    WHERE lmf06 = 'Y'
                    	  	      AND lmf01 = g_lmx[l_ac].lmx08
                    	  	      AND lmfstore = g_argv2
                    	  	      AND lmf03 = g_argv3
                    	  	ELSE
                    	  		 SELECT COUNT(*) INTO l_n FROM lmf_file
                    	  	    WHERE lmf06 = 'Y'
                    	  	      AND lmf01 = g_lmx[l_ac].lmx08
                    	  	      AND lmfstore = g_argv2                    	  	      
                    	  	END IF  
                    	  END IF 	    
                    	  IF l_n < 1 THEN 
                    	     IF g_argv4 IS NOT NULL THEN 
                    	       CALL cl_err('','alm-502',1)
                    	     ELSE
                    	     	  IF g_argv4 IS NULL AND g_argv3 IS NOT NULL THEN 
                    	     	     CALL cl_err('','alm-621',1)
                    	     	   ELSE
                    	     	   	  CALL cl_err('','alm-620',1)
                    	     	   END IF 	  
                    	     	END IF   
                    	     NEXT FIELD lmx08
                    	 ELSE                    	 	   
                          CALL i360_1_check_lmx08(g_lmx[l_ac].lmx08)
                          IF g_success = 'N' THEN 
                             LET g_lmx[l_ac].lmx08 = g_lmx_t.lmx08
                             NEXT FIELD lmx08
                          END IF   
                       END IF    
                    END IF  	    
                END IF
             END IF
          END IF   
  
      AFTER FIELD lmx09
          IF NOT cl_null(g_lmx[l_ac].lmx09) THEN
              IF g_lmx[l_ac].lmx09 < 0 THEN 
                 CALL cl_err('','alm-107',0)
                 DISPLAY '' TO lmx09
                 NEXT FIELD lmx09
               END IF        
          END IF   
            		
            		
       BEFORE DELETE                            #是否取消單身
          IF g_lmx_t.lmx08 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lmx08"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lmx[l_ac].lmx08      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lmx_file WHERE lmx08 = g_lmx_t.lmx08
                                    AND lmx01 = g_argv1
                                    AND lmxstore = g_argv2 
                                    AND lmx03 = g_argv3
                                    AND lmx04 = g_argv4
                                    AND lmx05 = g_argv5
                                    AND lmx06 = g_argv6
                                    AND lmx07 = g_argv7
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lmx_file",g_lmx_t.lmx08,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lmx[l_ac].* = g_lmx_t.*
             CLOSE i360_1_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lmx[l_ac].lmx08,-263,0)
             LET g_lmx[l_ac].* = g_lmx_t.*
          ELSE
             UPDATE lmx_file SET lmx08=g_lmx[l_ac].lmx08,
                                 lmx09=g_lmx[l_ac].lmx09
              WHERE lmx08 = g_lmx_t.lmx08              
                AND lmx01 = g_argv1
                AND lmxstore = g_argv2 
                AND lmx03 = g_argv3
                AND lmx04 = g_argv4
                AND lmx05 = g_argv5
                AND lmx06 = g_argv6
                AND lmx07 = g_argv7
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lmx_file",g_lmx_t.lmx08,"",SQLCA.sqlcode,"","",1)  
                LET g_lmx[l_ac].* = g_lmx_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增  #FUN-D30033
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lmx[l_ac].* = g_lmx_t.*
             #FUN-D30033----add--str
             ELSE
                CALL g_lmx.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033---add--end
             END IF
             CLOSE i360_1_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                # 新增  #FUN-D30033 
          CLOSE i360_1_bcl            # 新增
          COMMIT WORK
 
   #    ON ACTION CONTROLO                        #沿用所有欄位
   #       IF INFIELD(lmx08) AND l_ac > 1 THEN
   #          LET g_lmx[l_ac].* = g_lmx[l_ac-1].*
   #          NEXT FIELD lmx08
   #       END IF
  
      ON ACTION controlp
         CASE
           WHEN INFIELD(lmx08)                                                                 
                 CALL cl_init_qry_var()  
              #  IF NOT cl_null(g_argv4) THEN                                                 
              #    LET g_qryparam.form ="q_lmf_4"                                                                       
              #    LET g_qryparam.arg1 = g_argv2    
              #    LET g_qryparam.arg2 = g_argv3
              #    LET g_qryparam.arg3 = g_argv4
              #   ELSE
              #     IF cl_null(g_argv4) AND NOT cl_null(g_argv3) THEN
              #        LET g_qryparam.form = 'q_lmf_5'
              #        LET g_qryparam.arg1 = g_argv2
              #        LET g_qryparam.arg2 = g_argv3
              #     ELSE
              #        LET g_qryparam.form = 'q_lmf_6'
              #        LET g_qryparam.arg1 = g_argv2                    	
              #     END IF 	
              #   END IF  	                                                                                
                  IF NOT cl_null(g_argv3) AND NOT cl_null(g_argv4) THEN
                     LET g_qryparam.form = 'q_lmf_7'
                  ELSE
                     IF NOT cl_null(g_argv3) AND cl_null(g_argv4) THEN
                        LET g_qryparam.form = 'q_lmf_8'
                     END IF
                     IF cl_null(g_argv3) AND cl_null(g_argv4) THEN
                        LET g_qryparam.form = 'q_lmf_9'
                     END IF
                  END IF
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.arg2 = g_argv2
                  LET g_qryparam.arg3 = g_argv3
                  LET g_qryparam.arg4 = g_argv4
                  LET g_qryparam.arg5 = g_argv5
                  LET g_qryparam.arg6 = g_argv6
                  LET g_qryparam.arg7 = g_argv7
                 #No.TQC-A10159 -BEGIN-----
                  IF p_cmd = 'u' THEN
                     CALL cl_create_qry() RETURNING g_lmx[l_ac].lmx08
                     DISPLAY g_lmx[l_ac].lmx08 TO lmx08
                     NEXT FIELD lmx08
                  ELSE
                     LET g_qryparam.state='c'
                     CALL cl_create_qry() RETURNING g_lmx08
                     CALL i360_1_lmx08()
                     CALL i360_1_b_fill(' 1=1')
                     EXIT INPUT
                  END IF
                 #No.TQC-A10159 -END-------
             END CASE  
   
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
 
   CLOSE i360_1_bcl
   COMMIT WORK
 
END FUNCTION

#No.TQC-A10159 -BEGIN-----
FUNCTION i360_1_lmx08()
 DEFINE l_i      LIKE type_file.num5
 DEFINE l_j      LIKE type_file.num5
 DEFINE l_length LIKE type_file.num5
 DEFINE l_cnt    LIKE type_file.num5
 DEFINE l_lmx08  LIKE lmx_file.lmx08

   DELETE FROM i3601_tmp
   
   LET l_length = g_lmx08.getLength()
   LET l_i = 1
   LET l_j = 1
   FOR l_i = 1 TO l_length
      IF g_lmx08.subString(l_i,l_i) = '|' THEN
         LET l_lmx08 = g_lmx08.subString(l_j,l_i - 1)
         INSERT INTO i3601_tmp VALUES (l_lmx08)
         LET l_j=l_i+1
      END IF
   END FOR
   LET l_lmx08 = g_lmx08.subString(l_j,l_length)
   INSERT INTO i3601_tmp VALUES (l_lmx08)

   LET g_sql = " DELETE FROM i3601_tmp ",
               "  WHERE EXISTS (SELECT 'X' FROM lmx_file ",
               "                 WHERE lmx01 = '",g_argv1,"'",
               "                   AND lmxstore = '",g_argv2,"'",
               "                   AND lmx03  = '",g_argv3,"'",
               "                   AND lmx04  = '",g_argv4,"'",
               "                   AND lmx05  = '",g_argv5,"'",
               "                   AND lmx06  = '",g_argv6,"'",
               "                   AND lmx07  = '",g_argv7,"'",
               "                   AND lmx_file.lmx08  = i3601_tmp.lmx08)"
     PREPARE i3601_pre01 FROM g_sql
     EXECUTE i3601_pre01

   LET g_sql = " INSERT INTO lmx_file(lmx01,lmxstore,lmx03,lmx04,lmx05,lmx06,lmxlegal,lmx07,lmx08,lmx09)",  #FUN-A60064 add lmxlegal
               " SELECT '",g_argv1,"',",
               "        '",g_argv2,"',",
               "        '",g_argv3,"',",
               "        '",g_argv4,"',",
               "        '",g_argv5,"',",
               "        '",g_argv6,"',",
               "        '",g_legal,"',",    #FUN-A60064 add
               "        '",g_argv7,"',lmx08,0 ",
               "  FROM i3601_tmp "
     PREPARE i3601_pre02 FROM g_sql
     EXECUTE i3601_pre02
END FUNCTION
#No.TQC-A10159 -END-------
 
FUNCTION i360_1_b_askkey()
 
   CLEAR FORM
   CALL g_lmx.clear()
   
      CONSTRUCT g_wc2 ON lmx08,lmx09               
                 FROM s_lmx[1].lmx08,s_lmx[1].lmx09
                  
 
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
         
       ON ACTION CONTROLP                                                                      
           CASE                                                                                    
            WHEN INFIELD(lmx08)                                                                  
                CALL cl_init_qry_var()                                                       
                 LET g_qryparam.form ="q_lmx08"                                         
                 LET g_qryparam.state='c'                                    
                 LET g_qryparam.arg1 = g_argv1
                 LET g_qryparam.arg2 = g_argv2 
                 LET g_qryparam.arg3 = g_argv3
                 LET g_qryparam.arg4 = g_argv4
                 LET g_qryparam.arg5 = g_argv5
                 LET g_qryparam.arg6 = g_argv6 
                 LET g_qryparam.arg7 = g_argv7 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                  
                 DISPLAY g_qryparam.multiret TO lmx08                                
                 NEXT FIELD lmx08                                                           
             END CASE        
    
	    ON ACTION qbe_select
    	   CALL cl_qbe_select() 
  
      ON ACTION qbe_save
	  	   CALL cl_qbe_save()
		
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0
      LET g_wc2 = NULL
      RETURN 
   END IF
 
   CALL i360_1_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i360_1_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
     LET g_sql ="SELECT lmx08,lmx09",  
               " FROM lmx_file ",
               " WHERE ", p_wc2 CLIPPED,      
               " and lmx01 = '",g_argv1,"' ",
               " and lmxstore = '",g_argv2,"' ",
               " and lmx03 = '",g_argv3,"' ",
               " and lmx04 = '",g_argv4,"' ",
               " and lmx05 = '",g_argv5,"' ",
               " and lmx06 = '",g_argv6,"' ",
               " and lmx07 = '",g_argv7,"' ",
               " ORDER BY lmx08"
    PREPARE i360_1_pb FROM g_sql
    DECLARE lmx_curs CURSOR FOR i360_1_pb
 
    CALL g_lmx.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lmx_curs INTO g_lmx[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_lmx.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i360_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lmx TO s_lmx.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()      
 
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
    
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                            
FUNCTION i360_1_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lmx08",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i360_1_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lmx08",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
      
FUNCTION i360_1_check_lmx08(p_cmd)
  DEFINE l_count    LIKE type_file.num5
  DEFINE p_cmd      LIKE lmx_file.lmx08
  
  SELECT COUNT(*) INTO l_count FROM lmx_file
   WHERE lmx01      = g_argv1 
     AND lmxstore      = g_argv2
     AND lmx03      = g_argv3
     AND lmx04      = g_argv4
     AND lmx05      = g_argv5
     AND lmx06      = g_argv6
     AND lmx07      = g_argv7
     AND lmx08      = p_cmd
    
   IF l_count > 0 THEN 
      CALL cl_err('','alm-129',0)
      LET g_success = 'N'
   END IF      
     
END FUNCTION 
 
FUNCTION i360_1_check()
   
   SELECT lnl03,lnl04,lnl05,lnl06,lnl07,lnl10 INTO
          g_lnl03,g_lnl04,g_lnl05,g_lnl06,g_lnl07,g_lnl10 FROM lnl_file
   WHERE lnl01 = g_argv1
     AND lnlstore = g_argv2
   
END FUNCTION 
###########################################
FUNCTION i360_1_lnl03(p_w)
DEFINE p_w    LIKE lnl_file.lnl03
 
  IF p_w = 'N' THEN 
     LET g_lmx03 = ' '
  END IF    
END FUNCTION 
 
FUNCTION i360_1_lnl04(p_w)
DEFINE p_w    LIKE lnl_file.lnl04
 
  IF p_w = 'N' THEN 
     LET g_lmx04 = ' '
  END IF    
END FUNCTION 
 
FUNCTION i360_1_lnl05(p_w)
DEFINE p_w    LIKE lnl_file.lnl05
 
  IF p_w = 'N' THEN 
     LET g_lmx05 = ' '
  END IF    
END FUNCTION 
 
FUNCTION i360_1_lnl06(p_w)
DEFINE p_w    LIKE lnl_file.lnl06
 
  IF p_w = 'N' THEN 
     LET g_lmx06 = ' '
  END IF    
END FUNCTION 
 
FUNCTION i360_1_lnl07(p_w)
DEFINE p_w    LIKE lnl_file.lnl07
 
  IF p_w = 'N' THEN 
     LET g_lmx07 = ' '
  END IF    
END FUNCTION 
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
