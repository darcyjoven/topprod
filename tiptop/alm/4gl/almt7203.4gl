# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: almt7203.4gl
# Descriptions...: 維護生效時間作業
# Date & Author..: NO.FUN-870010 08/09/01 By lilingyu 
# Modify.........: No.FUN-960134 09/07/20 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lqj           DYNAMIC ARRAY OF RECORD    
         lqj03       LIKE lqj_file.lqj03,
         lqj04       LIKE lqj_file.lqj04,
         lqj05       LIKE lqj_file.lqj05,
         lqj06       LIKE lqj_file.lqj06,
         lqj07       LIKE lqj_file.lqj07,
         lqj08       LIKE lqj_file.lqj08
                    END RECORD,
     g_lqj_t        RECORD    
         lqj03       LIKE lqj_file.lqj03,
         lqj04       LIKE lqj_file.lqj04,
         lqj05       LIKE lqj_file.lqj05,
         lqj06       LIKE lqj_file.lqj06,
         lqj07       LIKE lqj_file.lqj07,
         lqj08       LIKE lqj_file.lqj08
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5 
    
DEFINE g_argv1               LIKE lqj_file.lqj01
DEFINE g_argv2               LIKE lqj_file.lqj02
 
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
   
    OPEN WINDOW t7203_w WITH FORM "alm/42f/almt7203" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()     
   
    LET g_argv1 = ARG_VAL(1) 
    LET g_argv2 = ARG_VAL(2) 
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = " lqj01 = '",g_argv1,"'  and lqj02 = '",g_argv2,"'"     
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t7203_b_fill(g_wc2)
    
    CALL t7203_menu()
    CLOSE WINDOW t7203_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t7203_menu()
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t7203_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t7203_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t7203_b()
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
               IF g_lqj[l_ac].lqj03 IS NOT NULL THEN
                  LET g_doc.column1 = "lqj03"
                  LET g_doc.value1 = g_lqj[l_ac].lqj03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lqj),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t7203_q()
   CALL t7203_askkey()
END FUNCTION
 
FUNCTION t7203_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5, 
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1           
DEFINE l_lqg07         LIKE lqg_file.lqg07
DEFINE l_lqgacti       LIKE lqg_file.lqgacti
 
   IF s_shut(0) THEN RETURN END IF
   
    SELECT lqg07,lqgacti INTO l_lqg07,l_lqgacti FROM lqg_file
     WHERE lqg01 = g_argv1
       AND lqg02 = g_argv2
   IF (l_lqg07 = 'Y' OR l_lqg07 = 'X' OR l_lqg07 = 'S') THEN 
      CALL cl_err('','alm-256',1)
      LET g_action_choice = NULL
      RETURN       
   END IF   
   IF l_lqgacti = 'N' THEN       
      CALL cl_err('','alm-150',0)
      LET g_action_choice = NULL
      RETURN        
   END IF 
    
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lqj03,lqj04,lqj05,lqj06,lqj07,lqj08", 
                      "  FROM lqj_file WHERE  " ,
                      "   lqj01= '",g_argv1,"' " ,
                      "   and lqj02 = '",g_argv2,"'",
                      "   and lqj03 = ? " ,
                      "   and lqj04 = ? ",
                      "   and lqj05 = ? ", 
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t7203_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lqj WITHOUT DEFAULTS FROM s_lqj.*
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
             CALL t7203_set_entry(p_cmd)                                         
             CALL t7203_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lqj_t.* = g_lqj[l_ac].*  
             OPEN t7203_bcl USING g_lqj_t.lqj03,g_lqj_t.lqj04,g_lqj_t.lqj05
             IF STATUS THEN
                CALL cl_err("OPEN t7203_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t7203_bcl INTO g_lqj[l_ac].*              
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lqj_t.lqj03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t7203_set_entry(p_cmd)                                            
         CALL t7203_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lqj[l_ac].* TO NULL    
          LET g_lqj_t.* = g_lqj[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lqj03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t7203_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lqj_file(lqj01,lqj02,lqj03,lqj04,lqj05,lqj06,lqj07,lqj08)
          VALUES(g_argv1,g_argv2,g_lqj[l_ac].lqj03,g_lqj[l_ac].lqj04,
                 g_lqj[l_ac].lqj05,g_lqj[l_ac].lqj06,g_lqj[l_ac].lqj07,g_lqj[l_ac].lqj08)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lqj_file",g_lqj[l_ac].lqj03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
        
        AFTER FIELD lqj03         
           IF NOT cl_null(g_lqj[l_ac].lqj03) THEN
              IF g_lqj[l_ac].lqj03 > g_lqj[l_ac].lqj06 THEN 
                 CALL cl_err('','alm-402',1)
                 NEXT FIELD lqj03 
              END IF             
           END IF   
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lqj[l_ac].lqj03 != g_lqj_t.lqj03 ) THEN 
             LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM lqj_file
               WHERE lqj01 = g_argv1
                 AND lqj03 = g_lqj[l_ac].lqj03
                 AND lqj04 = g_lqj[l_ac].lqj04
                 AND lqj05 = g_lqj[l_ac].lqj05
               IF l_n > 0 THEN 
                  CALL cl_err('','alm-109',1)
                  NEXT FIELD lqj03   
               END IF    
           END IF             
  
     AFTER FIELD lqj04 
       IF g_lqj[l_ac].lqj04 <0 OR g_lqj[l_ac].lqj04 > 23 THEN 
           CALL cl_err('','alm-406',1)
           NEXT FIELD lqj04 
        ELSE 
        	 IF g_lqj[l_ac].lqj04 = 0 THEN 
        	    LET g_lqj[l_ac].lqj04 = '00'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 1 THEN 
        	    LET g_lqj[l_ac].lqj04 = '01'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 2 THEN 
        	    LET g_lqj[l_ac].lqj04 = '02'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 3 THEN 
        	    LET g_lqj[l_ac].lqj04 = '03'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 4 THEN 
        	    LET g_lqj[l_ac].lqj04 = '04'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 5 THEN 
        	    LET g_lqj[l_ac].lqj04 = '05'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 6 THEN 
        	    LET g_lqj[l_ac].lqj04 = '06'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 7 THEN 
        	    LET g_lqj[l_ac].lqj04 = '07'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 8 THEN 
        	    LET g_lqj[l_ac].lqj04 = '08'
        	 END IF 
        	 IF g_lqj[l_ac].lqj04 = 9 THEN 
        	    LET g_lqj[l_ac].lqj04 = '09'
        	 END IF          	        
        END IF 
        IF NOT cl_null(g_lqj[l_ac].lqj04) THEN 
          IF g_lqj[l_ac].lqj03 = g_lqj[l_ac].lqj06 THEN 
             IF g_lqj[l_ac].lqj04 > g_lqj[l_ac].lqj07 THEN 
                CALL cl_err('','alm-404',1)
                NEXT FIELD lqj04                 
             END IF
          END IF 
        END IF 
         IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lqj[l_ac].lqj04 != g_lqj_t.lqj04 ) THEN 
            LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM lqj_file
               WHERE lqj01 = g_argv1
                 AND lqj03 = g_lqj[l_ac].lqj03
                 AND lqj04 = g_lqj[l_ac].lqj04
                 AND lqj05 = g_lqj[l_ac].lqj05
               IF l_n > 0 THEN 
                  CALL cl_err('','alm-109',1)
                  NEXT FIELD lqj04   
               END IF    
           END IF      
  
     AFTER FIELD lqj05 
         IF g_lqj[l_ac].lqj05 <0 OR g_lqj[l_ac].lqj05 > 60 THEN 
           CALL cl_err('','alm-408',1)
           NEXT FIELD lqj05 
        ELSE
        	  IF g_lqj[l_ac].lqj05 = 0 THEN 
        	    LET g_lqj[l_ac].lqj05 = '00'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 1 THEN 
        	    LET g_lqj[l_ac].lqj05 = '01'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 2 THEN 
        	    LET g_lqj[l_ac].lqj05 = '02'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 3 THEN 
        	    LET g_lqj[l_ac].lqj05 = '03'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 4 THEN 
        	    LET g_lqj[l_ac].lqj05 = '04'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 5 THEN 
        	    LET g_lqj[l_ac].lqj05 = '05'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 6 THEN 
        	    LET g_lqj[l_ac].lqj05 = '06'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 7 THEN 
        	    LET g_lqj[l_ac].lqj05 = '07'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 8 THEN 
        	    LET g_lqj[l_ac].lqj05 = '08'
        	 END IF 
        	 IF g_lqj[l_ac].lqj05 = 9 THEN 
        	    LET g_lqj[l_ac].lqj05 = '09'
        	 END IF      
        END IF 
        IF NOT cl_null(g_lqj[l_ac].lqj05) THEN 
          IF g_lqj[l_ac].lqj03 = g_lqj[l_ac].lqj06  AND g_lqj[l_ac].lqj04 = g_lqj[l_ac].lqj07 THEN 
             IF g_lqj[l_ac].lqj05 > g_lqj[l_ac].lqj08 THEN 
                CALL cl_err('','alm-407',1)
                NEXT FIELD lqj05 
             END IF
          END IF 
        END IF        
         IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lqj[l_ac].lqj05 != g_lqj_t.lqj05 ) THEN 
            LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM lqj_file
               WHERE lqj01 = g_argv1
                 AND lqj03 = g_lqj[l_ac].lqj03
                 AND lqj04 = g_lqj[l_ac].lqj04
                 AND lqj05 = g_lqj[l_ac].lqj05
               IF l_n > 0 THEN 
                  CALL cl_err('','alm-109',1)
                  NEXT FIELD lqj05   
               END IF    
           END IF      
        
      AFTER FIELD lqj06
       IF NOT cl_null(g_lqj[l_ac].lqj06) THEN 
           IF g_lqj[l_ac].lqj06 < g_lqj[l_ac].lqj03 THEN 
              CALL cl_err('','alm-403',1)
              NEXT FIELD lqj06 
          END IF             
       END IF 
     
       AFTER FIELD lqj07
        IF g_lqj[l_ac].lqj07 <0 OR g_lqj[l_ac].lqj07 > 23 THEN 
           CALL cl_err('','alm-406',1)
           NEXT FIELD lqj07 
        ELSE 
        	 IF g_lqj[l_ac].lqj07 = 0 THEN 
        	    LET g_lqj[l_ac].lqj07 = '00'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 1 THEN 
        	    LET g_lqj[l_ac].lqj07 = '01'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 2 THEN 
        	    LET g_lqj[l_ac].lqj07 = '02'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 3 THEN 
        	    LET g_lqj[l_ac].lqj07 = '03'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 4 THEN 
        	    LET g_lqj[l_ac].lqj07 = '04'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 5 THEN 
        	    LET g_lqj[l_ac].lqj07 = '05'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 6 THEN 
        	    LET g_lqj[l_ac].lqj07 = '06'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 7 THEN 
        	    LET g_lqj[l_ac].lqj07 = '07'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 8 THEN 
        	    LET g_lqj[l_ac].lqj07 = '08'
        	 END IF 
        	 IF g_lqj[l_ac].lqj07 = 9 THEN 
        	    LET g_lqj[l_ac].lqj07 = '09'
        	 END IF          	        
        END IF 
        IF NOT cl_null(g_lqj[l_ac].lqj07) THEN 
          IF g_lqj[l_ac].lqj03 = g_lqj[l_ac].lqj06 THEN 
             IF g_lqj[l_ac].lqj07 < g_lqj[l_ac].lqj04 THEN 
                CALL cl_err('','alm-405',1)
                NEXT FIELD lqj07 
             END IF
          END IF 
        END IF 
        
      
         AFTER FIELD lqj08
          IF g_lqj[l_ac].lqj08 <0 OR g_lqj[l_ac].lqj08 > 60 THEN 
           CALL cl_err('','alm-408',1)
           NEXT FIELD lqj08 
        ELSE
        	  IF g_lqj[l_ac].lqj08 = 0 THEN 
        	    LET g_lqj[l_ac].lqj08 = '00'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 1 THEN 
        	    LET g_lqj[l_ac].lqj08 = '01'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 2 THEN 
        	    LET g_lqj[l_ac].lqj08 = '02'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 3 THEN 
        	    LET g_lqj[l_ac].lqj08 = '03'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 4 THEN 
        	    LET g_lqj[l_ac].lqj08 = '04'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 5 THEN 
        	    LET g_lqj[l_ac].lqj08 = '05'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 6 THEN 
        	    LET g_lqj[l_ac].lqj08 = '06'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 7 THEN 
        	    LET g_lqj[l_ac].lqj08 = '07'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 8 THEN 
        	    LET g_lqj[l_ac].lqj08 = '08'
        	 END IF 
        	 IF g_lqj[l_ac].lqj08 = 9 THEN 
        	    LET g_lqj[l_ac].lqj08 = '09'
        	 END IF      
        END IF 
        IF NOT cl_null(g_lqj[l_ac].lqj08) THEN 
          IF g_lqj[l_ac].lqj03 = g_lqj[l_ac].lqj06  AND g_lqj[l_ac].lqj04 = g_lqj[l_ac].lqj07 THEN 
             IF g_lqj[l_ac].lqj08 < g_lqj[l_ac].lqj05 THEN 
                CALL cl_err('','alm-409',1)
                NEXT FIELD lqj08 
             END IF
          END IF 
        END IF 
       
        
       BEFORE DELETE                           
          IF g_lqj_t.lqj03 IS NOT NULL  THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lqj03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lqj[l_ac].lqj03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lqj_file WHERE lqj01 = g_argv1
                                    AND lqj02 = g_argv2
                                    AND lqj03 = g_lqj_t.lqj03
                                    AND lqj04 = g_lqj_t.lqj04 
                                    AND lqj05 = g_lqj_t.lqj05                             
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lqj_file",g_lqj_t.lqj03,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lqj[l_ac].* = g_lqj_t.*
             CLOSE t7203_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lqj[l_ac].lqj03,-263,0)
             LET g_lqj[l_ac].* = g_lqj_t.*
          ELSE
             UPDATE lqj_file SET lqj03 = g_lqj[l_ac].lqj03,
                                 lqj04 = g_lqj[l_ac].lqj04,
                                 lqj05 = g_lqj[l_ac].lqj05,
                                 lqj06 = g_lqj[l_ac].lqj06,
                                 lqj07 = g_lqj[l_ac].lqj07,
                                 lqj08 = g_lqj[l_ac].lqj08
              WHERE lqj01 = g_argv1
                AND lqj02 = g_argv2
                AND lqj03 = g_lqj_t.lqj03
                AND lqj04 = g_lqj_t.lqj04
                AND lqj05 = g_lqj_t.lqj05
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lqj_file",g_lqj_t.lqj03,"",SQLCA.sqlcode,"","",1)  
                LET g_lqj[l_ac].* = g_lqj_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增  #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lqj[l_ac].* = g_lqj_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lqj.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE t7203_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac          #FUN-D30033 Add 
          CLOSE t7203_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lqj03) AND l_ac > 1 THEN
             LET g_lqj[l_ac].* = g_lqj[l_ac-1].*
             NEXT FIELD lqj03
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
 
   CLOSE t7203_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t7203_askkey()
 
   CLEAR FORM
   CALL g_lqj.clear()
       CONSTRUCT g_wc2 ON lqj03,lqj04,lqj05,lqj06 
                     FROM s_lqj[1].lqj03,s_lqj[1].lqj04,
                          s_lqj[1].lqj05,s_lqj[1].lqj06
 
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN 
   END IF
 
   CALL t7203_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t7203_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
  
    LET g_sql ="SELECT lqj03,lqj04,lqj05,lqj06,lqj07,lqj08 ",   
               " FROM lqj_file ",
               " WHERE ", p_wc2 CLIPPED,                   
               " and lqj01 = '",g_argv1,"'",
               " and lqj02 = '",g_argv2,"'",
               " ORDER BY lqj03"
    PREPARE t7203_pb FROM g_sql
    DECLARE lqj_curs CURSOR FOR t7203_pb
 
    CALL g_lqj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lqj_curs INTO g_lqj[g_cnt].*   
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
    CALL g_lqj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t7203_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqj TO s_lqj.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t7203_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lqj03,lqj04,lqj05",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t7203_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lqj03,lqj04,lqj05",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134
