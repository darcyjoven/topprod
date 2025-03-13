# Prog. Version..: '5.30.06-13.04.22(00006)'     #
# Pattern name...: aeci621.4gl
# Descriptions...: 資源損耗係數維護作業 
# Date & Author..: NO.FUN-A60028 10/06/09 By lilingyu 平行工藝 
# Modify.........: NO.TQC-A60117 10/06/25 By lilingyu 數量區間增加控管 
# Modify.........: No.FUN-A60092 10/07/22 By lilingyu  
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AC0076 11/01/05 By wangxin 添加接受參數g_argv1，g_argv2
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds    #FUN-A60028
 
GLOBALS "../../config/top.global"   
 
DEFINE 
    g_eck00         LIKE eck_file.eck00,
    g_eck01         LIKE eck_file.eck01,  
    g_eck02         LIKE eck_file.eck02,  
    g_eck03         LIKE eck_file.eck03,
    g_eck00_t       LIKE eck_file.eck00,
    g_eck01_t       LIKE eck_file.eck01,          
    g_eck02_t       LIKE eck_file.eck02,   
    g_eck03_t       LIKE eck_file.eck03,        
    g_eckmodu       LIKE eck_file.eckmodu,
    g_eckacti       LIKE eck_file.eckacti,
    g_eckgrup       LIKE eck_file.eckgrup,
    g_eckuser       LIKE eck_file.eckuser,
    g_eckdate       LIKE eck_file.eckdate, 
    g_eck           DYNAMIC ARRAY OF RECORD    
        eck04       LIKE eck_file.eck04,   
        eck05       LIKE eck_file.eck05,
        eck06       LIKE eck_file.eck06,
        eck07       LIKE eck_file.eck07   
                    END RECORD,
    g_eck_t         RECORD                 
        eck04       LIKE eck_file.eck04,   
        eck05       LIKE eck_file.eck05,
        eck06       LIKE eck_file.eck06,
        eck07       LIKE eck_file.eck07     
                    END RECORD,
    g_wc,g_sql       STRING,                       
    g_rec_b          LIKE type_file.num5,             
    p_row,p_col      LIKE type_file.num5,          
    l_ac             LIKE type_file.num5   
DEFINE g_forupd_sql      STRING                    
#DEFINE   g_chr           LIKE type_file.chr1            #TQC-A60117
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_i             LIKE type_file.num5         
DEFINE   g_msg           LIKE type_file.chr1000       
DEFINE   g_row_count     LIKE type_file.num10        
DEFINE   g_curs_index    LIKE type_file.num10        
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
DEFINE   g_before_input_done    LIKE type_file.num5     
DEFINE   g_sql_tmp       STRING 
DEFINE   g_eck04         LIKE eck_file.eck04
DEFINE   g_eck05         LIKE eck_file.eck05
DEFINE   g_eck04_1       LIKE eck_file.eck04
DEFINE   g_eck05_1       LIKE eck_file.eck05
DEFINE   g_argv1         LIKE eck_file.eck00  #FUN-AC0076 add
DEFINE   g_argv2         LIKE eck_file.eck01  #FUN-AC0076 add


MAIN
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AEC")) THEN
       EXIT PROGRAM
    END IF
    
    LET g_argv1 = ARG_VAL(1)  #FUN-AC0076 add
    LET g_argv2 = ARG_VAL(2)  #FUN-AC0076 add
    
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
    LET g_eck00    = NULL
    LET g_eck01    = NULL  
    LET g_eck02    = NULL   
    LET g_eck03    = NULL
    LET g_eck00_t  = NULL
    LET g_eck01_t  = NULL
    LET g_eck02_t  = NULL
    LET g_eck03_t  = NULL
         
    LET p_row = 3 LET p_col = 25
    
    OPEN WINDOW i621_w AT p_row,p_col WITH FORM "aec/42f/aeci621"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
    #FUN-AC0076 add ---------begin----------
    IF NOT cl_null(g_argv1) THEN
       LET g_eck00 =  g_argv1
       LET g_eck01 =  g_argv2
       CALL i621_q()
       CALL i621_show()
    END IF
    #FUN-AC0076 add ----------end-----------
    CALL i621_menu()
    CLOSE WINDOW i621_w                
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time     
END MAIN
 
FUNCTION i621_curs()

    CLEAR FORM                        
    CALL g_eck.clear()
    CALL cl_set_head_visible("","YES")    
    INITIALIZE g_eck00 TO NULL
    INITIALIZE g_eck01 TO NULL   
    INITIALIZE g_eck02 TO NULL  
    INITIALIZE g_eck03 TO NULL
    IF cl_null(g_argv1) THEN    #FUN-AC0076 add
       CONSTRUCT g_wc ON eck00,eck01,eck02,eck03,eckuser,eckgrup,eckmodu,eckdate,eckacti,
                         eck04,eck05,eck06,eck07   
                    FROM eck00,eck01,eck02,eck03,eckuser,eckgrup,eckmodu,eckdate,eckacti,
                         s_eck[1].eck04,s_eck[1].eck05,s_eck[1].eck06,s_eck[1].eck07
       
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
       
          ON ACTION controlp 
             CASE
               WHEN INFIELD(eck01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c' 
                   LET g_qryparam.form ="q_eck01_1" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO eck01
                   NEXT FIELD eck01
               WHEN INFIELD(eck02) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c' 
                   LET g_qryparam.form ="q_eck02_1" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO eck02
                   NEXT FIELD eck02
               WHEN INFIELD(eck03) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c' 
                   LET g_qryparam.form ="q_eck03_1" 
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO eck03
                   NEXT FIELD eck03
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
       
       
          ON ACTION qbe_select
            	   CALL cl_qbe_select() 
       
        ON ACTION qbe_save
		      CALL cl_qbe_save()
       
       
       END CONSTRUCT
    END IF #FUN-AC0076 add
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
    
    IF INT_FLAG THEN RETURN END IF
    
    IF cl_null(g_wc) THEN 
      LET g_wc = " 1=1"
    END IF    
    #FUN-AC0076 add  -------------begin-------------
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " eck00 = '",g_argv1,"' AND eck01 = '",g_argv2,"'"
    END IF 
    #FUN-AC0076 add  --------------end--------------
    LET g_sql= "SELECT UNIQUE eck00,eck01,eck02,eck03 FROM eck_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY eck00,eck01,eck02,eck03"
    PREPARE i621_prepare FROM g_sql   
    DECLARE i621_b_curs            
        SCROLL CURSOR WITH HOLD FOR i621_prepare
 
    LET g_sql_tmp= "SELECT UNIQUE eck00,eck01,eck02,eck03 FROM eck_file ", 
               " WHERE ", g_wc CLIPPED,
               "  INTO TEMP x "
    DROP TABLE x
    PREPARE i621_precount_x FROM g_sql_tmp 
    EXECUTE i621_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE i621_precount FROM g_sql
    DECLARE i621_count CURSOR FOR i621_precount
END FUNCTION
 
FUNCTION i621_menu()
 
   WHILE TRUE
      CALL i621_bp("G")
      
#      LET g_chr = NULL  #TQC-A60117
      
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i621_a()
            END IF
            
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i621_q()
            END IF
            
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i621_r()
            END IF
            
#         WHEN "modify" 
#            IF cl_chk_act_auth() THEN
#               CALL i621_u()
#            END IF

         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i621_copy()
            END IF    
                    
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i621_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_eck),'','')
            END IF

         WHEN "related_document"          
          IF cl_chk_act_auth() THEN
             IF g_eck01 IS NOT NULL THEN
                LET g_doc.column1 = "eck00"
                LET g_doc.column2 = "eck01"
                LET g_doc.column3 = "eck02"
                LET g_doc.column4 = "eck03"
                LET g_doc.value1  = g_eck00
                LET g_doc.value2  = g_eck01
                LET g_doc.value3  = g_eck02
                LET g_doc.value4  = g_eck03
                CALL cl_doc()
             END IF 
          END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i621_a()

    IF s_shut(0) THEN
       RETURN
    END IF
    
    CLEAR FORM
    CALL g_eck.clear() 
    INITIALIZE g_eck00 LIKE eck_file.eck00
    INITIALIZE g_eck01 LIKE eck_file.eck01
    INITIALIZE g_eck02 LIKE eck_file.eck02
    INITIALIZE g_eck03 LIKE eck_file.eck03
    LET g_eck00_t = NULL    
    LET g_eck01_t = NULL
    LET g_eck02_t = NULL
    LET g_eck03_t = NULL    
    
    LET g_eck00   = '1' 
    LET g_eckacti = 'Y'
    LET g_eckuser = g_user
    LET g_eckgrup = g_grup
    LET g_eckdate = g_today
     
    CALL cl_opmsg('a')
    
    WHILE TRUE
        CALL i621_i("a")                       
        IF INT_FLAG THEN                   
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        
        IF cl_null(g_eck01) OR cl_null(g_eck00) THEN 
           CONTINUE WHILE 
        END IF           
        
        LET g_rec_b = 0 
        CALL i621_b()    
        LET g_eck00_t = g_eck00
        LET g_eck01_t = g_eck01            
        LET g_eck02_t = g_eck02
        LET g_eck03_t = g_eck03
 
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i621_copy()
DEFINE l_oldno0     LIKE eck_file.eck00
DEFINE l_newno0     LIKE eck_file.eck00
DEFINE l_oldno1     LIKE eck_file.eck01
DEFINE l_newno1     LIKE eck_file.eck01
DEFINE l_oldno2     LIKE eck_file.eck02
DEFINE l_newno2     LIKE eck_file.eck02
DEFINE l_oldno3     LIKE eck_file.eck03
DEFINE l_newno3     LIKE eck_file.eck03
DEFINE l_cnt        LIKE type_file.num5 
DEFINE l_imaacti    LIKE ima_file.imaacti
DEFINE l_imzacti    LIKE imz_file.imzacti 
DEFINE l_ecdacti    LIKE ecd_file.ecdacti
DEFINE l_eciacti    LIKE eci_file.eciacti
DEFINE l_eck        RECORD LIKE eck_file.*
DEFINE l_ima02     LIKE ima_file.ima02   #TQC-A60117
DEFINE l_imz02     LIKE imz_file.imz02   #TQC-A60117
DEFINE l_eci06     LIKE eci_file.eci06   #TQC-A60117
DEFINE l_ecd02     LIKE ecd_file.ecd02   #TQC-A60117
 
   IF s_shut(0) THEN RETURN END IF 
   IF cl_null(g_eck01) OR cl_null(g_eck00) THEN 
      CALL cl_err('',-400,0)
      RETURN 
   END IF  
   
   LET l_oldno0 = g_eck00
   LET l_newno0 = NULL
   LET l_oldno1 = g_eck01 
   LET l_newno1 = NULL 
   LET l_oldno2 = g_eck02
   LET l_newno2 = NULL 
   LET l_oldno3 = g_eck03
   LET l_newno3 = NULL 
   
   LET g_before_input_done = FALSE   
   CALL i621_set_entry('a')          
   LET g_before_input_done = TRUE   
   CALL cl_set_head_visible("","YES")  
   
   INPUT l_newno0,l_newno1,l_newno2,l_newno3 WITHOUT DEFAULTS FROM eck00,eck01,eck02,eck03
                
         AFTER FIELD eck00
           IF NOT cl_null(l_newno0) THEN 
              IF l_newno0 NOT MATCHES '[12]' THEN 
                 NEXT FIELD CURRENT 
              END IF 
           ELSE
           	  NEXT FIELD CURRENT 
           END IF        
                
        AFTER FIELD eck01
          IF NOT cl_null(l_newno1) THEN 
            IF l_newno0 = '1' THEN 
              #FUN-AA0059 --------------------------add start--------
               IF NOT s_chk_item_no(l_newno1,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD eck01
               END IF 
              #FUN-AA0059 ------------------------add end--------------------  
               LET l_cnt =0 

               LET l_imaacti = NULL
               LET l_ima02   = NULL
               SELECT COUNT(*),imaacti,ima02 INTO l_cnt,l_imaacti,l_ima02   #TQC-A60117 add ima02 
                 FROM ima_file
                WHERE ima01 = l_newno1
                GROUP BY imaacti,ima02   #TQC-A60117 add ima02
               IF l_cnt = 0 THEN 
                  CALL cl_err('','aem-041',0)
                  NEXT FIELD eck01
               ELSE
             	    IF l_imaacti = 'N' THEN 
             	       CALL cl_err('','9028',0)
             	       NEXT FIELD eck01
             	    ELSE
             	    	 DISPLAY l_ima02 TO FORMONLY.ima02  #TQC-A60117 add   
             	    END IF    
               END IF  
             ELSE
                LET l_cnt = 0 
                LET l_imzacti = NULL
                LET l_imz02   = NULL
                SELECT COUNT(*),imzacti,imz02 INTO l_cnt,l_imzacti,l_imz02   #TQC-A60117 add imz02 
                  FROM imz_file
                 WHERE imz01 = l_newno1
                 GROUP BY imzacti,imz02 #TQC-A60117 add imz02 
                IF l_cnt = 0 THEN 
                   CALL cl_err('','mfg3022',0)
                   NEXT FIELD CURRENT 
                ELSE
                   IF l_imzacti = 'N' THEN 
                      CALL cl_err('','9028',0)
                      NEXT FIELD CURRENT 
                   ELSE
                   	  DISPLAY l_imz02 TO FORMONLY.ima02  #TQC-A60117    
                   END IF 
                END IF
             END IF 	  
          ELSE
             NEXT FIELD CURRENT 
          END IF 	   
          
        AFTER FIELD eck02
          IF NOT cl_null(l_newno2) THEN 
             LET l_cnt =0
             LET l_eciacti = NULL
             LET l_eci06   = NULL
             SELECT COUNT(*),eciacti,eci06 INTO l_cnt,l_eciacti,l_eci06   #TQC-A60117 add eci06 
               FROM eci_file
              WHERE eci01 = l_newno2
              GROUP BY eciacti,eci06   #TQC-A60117 add eci06
             IF l_cnt = 0 THEN 
                CALL cl_err('','aem-041',0)
                NEXT FIELD eck02
             ELSE
             	  IF l_eciacti = 'N' THEN 
             	     CALL cl_err('','9028',0)
             	     NEXT FIELD eck02
             	  ELSE
             	  	 DISPLAY l_eci06 TO FORMONLY.rpf02   #TQC-A60117 add   
             	  END IF    
             END IF           
          ELSE
          	 LET l_newno2 = ' '          
          END IF  
          
        AFTER FIELD eck03
          IF NOT cl_null(l_newno3) THEN 
             LET l_cnt =0
             LET l_ecdacti = NULL
             LET l_ecd02   = NULL
             SELECT COUNT(*),ecdacti,ecd02 INTO l_cnt,l_ecdacti,l_ecd02  #TQC-A60117 add ecd02 
               FROM ecd_file
              WHERE ecd01 = l_newno3
              GROUP BY ecdacti,ecd02   #TQC-A60117 add ecd02
             IF l_cnt = 0 THEN 
                CALL cl_err('','aem-041',0)
                NEXT FIELD eck03
             ELSE
             	  IF l_ecdacti = 'N' THEN 
             	     CALL cl_err('','9028',0)
             	     NEXT FIELD eck03
             	  ELSE
             	     DISPLAY l_ecd02 TO FORMONLY.ecb17  #TQC-A60117 add 	   
             	  END IF    
             END IF      
          ELSE
          	 LET l_newno3 = ' '              
          END IF             
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF 
            IF l_newno0 NOT MATCHES '[12]' THEN NEXT FIELD eck00 END IF 
            IF cl_null(l_newno2) THEN LET l_newno2 = ' ' END IF 
            IF cl_null(l_newno3) THEN LET l_newno3 = ' ' END IF 
                               
       ON ACTION controlp
         CASE 
           WHEN INFIELD(eck01)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   IF l_newno0 = '1' THEN 
            #      LET g_qryparam.form ="q_eck01"
            #   ELSE
            #      LET g_qryparam.form = "q_imz"
            #   END IF 	   
            #   LET g_qryparam.default1 = l_newno1
            #   CALL cl_create_qry() RETURNING l_newno1
               IF l_newno0 = '1' THEN 
                  CALL q_sel_ima(FALSE, "q_eck01", "", l_newno1, "", "", "", "" ,"",'' )  RETURNING l_newno1
               ELSE 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imz"
                  LET g_qryparam.default1 = l_newno1
                  CALL cl_create_qry() RETURNING l_newno1
               END IF 
#FUN-AA0059 --End--
               DISPLAY l_newno1 TO eck01
               NEXT FIELD eck01
                            
           WHEN INFIELD(eck02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_eck02"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO eck02
               NEXT FIELD eck02
                          
           WHEN INFIELD(eck03)
                CALL q_ecd(FALSE,TRUE,g_eck03) RETURNING l_newno3
                 DISPLAY l_newno3 TO eck03
                 NEXT FIELD eck03
         END CASE                   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()   
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      DISPLAY g_eck00 TO eck00
      DISPLAY g_eck01 TO eck01
      DISPLAY g_eck02 TO eck02
      DISPLAY g_eck03 TO eck03
      RETURN 
   END IF
  
#TQC-A60117 --begin--  
#   BEGIN WORK 
#   
#   DROP TABLE x
#   SELECT * FROM eck_file 
#    WHERE eck00 = g_eck00
#      AND eck01 = g_eck01
#      AND eck02 = g_eck02
#      AND eck03 = g_eck03
#     INTO TEMP x
#     
#   SELECT MAX(eck04),MAX(eck05) INTO g_eck04,g_eck05 FROM eck_file
#    WHERE eck00 = l_newno0
#      AND eck01 = l_newno1
#      AND eck02 = l_newno2
#      AND eck03 = l_newno3
#   IF cl_null(g_eck04) THEN LET g_eck04 = 0 END IF 
#   IF cl_null(g_eck05) THEN LET g_eck05 = 0 END IF    
#   LET g_eck04   = g_eck04 + 1
#   LET g_eck04_1 = g_eck04     
#   LET g_eck05   = g_eck05 + 1
#   LET g_eck05_1 = g_eck05
#        
#   UPDATE x
#      SET eck00 = l_newno0,
#          eck01 = l_newno1,
#          eck02 = l_newno2,
#          eck03 = l_newno3,
#          eck04 = g_eck04,
#          eck05 = g_eck05,
#          eckacti= 'Y',
#          eckuser= g_user,
#          eckgrup= g_grup,
#          eckdate= g_today,
#          eckoriu= g_user,   #TQC-A60117
#          eckorig= g_grup    #TQC-A60117   
#   LET g_sql = "SELECT * FROM x"
#
#   PREPARE copy_pre FROM g_sql   
#   DECLARE copy_curs CURSOR FOR copy_pre
#    
#   FOREACH copy_curs INTO l_eck.*
#     LET l_eck.eck04 = g_eck04
#     LET l_eck.eck05 = g_eck05
#     INSERT INTO eck_file VALUES l_eck.*
#     IF STATUS THEN 
#        CALL cl_err('',STATUS,0)
#        EXIT FOREACH 
#     END IF                     
#     LET g_eck04 = l_eck.eck04 + 1   
#     LET g_eck05 = l_eck.eck05 + 1
#   END FOREACH                     
#   
#   IF STATUS THEN 
#      CALL cl_err('',STATUS,1)      
#      ROLLBACK WORK       
#      RETURN
#   ELSE
#   	  COMMIT WORK    
#   END IF
#   
#   COMMIT WORK 
#TQC-A60117 --end--
      
   LET g_eck00 = l_newno0   
   LET g_eck01 = l_newno1
   LET g_eck02 = l_newno2
   LET g_eck03 = l_newno3
#   LET g_chr = 'c'         #TQC-A60117
#   CALL i621_show()        #TQC-A60117
    LET g_rec_b = 0         #TQC-A60117
    CALL g_eck.clear()      #TQC-A60117    
    CALL i621_b()           #TQC-A60117
END FUNCTION 
 
#FUNCTION i621_u()
#  DEFINE l_msg    LIKE type_file.chr1000  
#  
#    IF s_shut(0) THEN
#        RETURN
#    END IF
#  
#    IF cl_null(g_eck01) THEN 
#       CALL cl_err('',-400,0) 
#       RETURN 
#    END IF
#    
#    CALL cl_opmsg('u')
#    LET g_eck01_t = g_eck01
#    LET g_eck02_t = g_eck02
#    LET g_eck03_t = g_eck03
#    
#    BEGIN WORK
#    WHILE TRUE
#        CALL i621_i("u")                 
#        IF INT_FLAG THEN
#            LET g_eck01=g_eck01_t
#            LET g_eck02=g_eck02_t
#            LET g_eck03=g_eck03_t
#            DISPLAY g_eck01 TO eck01
#            DISPLAY g_eck02 TO eck02
#            DISPLAY g_eck03 TO eck03            
#                
#            LET INT_FLAG = 0
#            CALL cl_err('',9001,0)
#            EXIT WHILE
#        END IF
#        
#        IF g_eck01 != g_eck01_t OR g_eck02 != g_eck02_t OR g_eck03 != g_eck03_t THEN
#            UPDATE eck_file SET eck01 = g_eck01,
#                                eck02 = g_eck02, 
#                                eck03 = g_eck03,
#                                eckdate = g_today,
#                                eckmodu = g_user,
#                                eckgrup = g_grup  
#                WHERE eck01 = g_eck01_t   
#                  AND eck02 = g_eck02_t
#                  AND eck03 = g_eck03_t  
#            IF SQLCA.sqlcode THEN
#                LET l_msg = g_eck01 CLIPPED,'+',g_eck02 CLIPPED,'+',g_eck03 CLIPPED 
#                CALL cl_err3("upd","eck_file",g_eck01_t,'',SQLCA.sqlcode,"","",1) 
#                CONTINUE WHILE
#            END IF
#        END IF
#        EXIT WHILE
#    END WHILE
#    COMMIT WORK
#END FUNCTION
 
FUNCTION i621_i(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_ecdacti   LIKE ecd_file.ecdacti
DEFINE l_eciacti   LIKE eci_file.eciacti
DEFINE l_imaacti   LIKE ima_file.imaacti
DEFINE l_imzacti   LIKE imz_file.imzacti
DEFINE l_ima02     LIKE ima_file.ima02   #TQC-A60117
DEFINE l_imz02     LIKE imz_file.imz02   #TQC-A60117
DEFINE l_eci06     LIKE eci_file.eci06   #TQC-A60117
DEFINE l_ecd02     LIKE ecd_file.ecd02   #TQC-A60117

    CALL cl_set_head_visible("","YES")   
    
    DISPLAY g_eckacti,g_eckuser,g_eckgrup,g_eckdate,g_eck00
         TO eckacti,eckuser,eckgrup,eckdate,eck00
    
    INPUT g_eck00,g_eck01,g_eck02,g_eck03 WITHOUT DEFAULTS FROM eck00,eck01,eck02,eck03 
                                                            
          BEFORE INPUT                                                                                                             
               LET g_before_input_done = FALSE                                                                                     
               CALL i621_set_entry(p_cmd)                                                                                          
               CALL i621_set_no_entry(p_cmd)                                                                                       
               LET g_before_input_done = TRUE                                                             
        
        AFTER FIELD eck00
          IF NOT cl_null(g_eck00) THEN 
             IF g_eck00 NOT MATCHES '[12]' THEN 
                NEXT FIELD eck00
             END IF 
          ELSE
            NEXT FIELD CURRENT 
          END IF 	
        
        AFTER FIELD eck01
          IF NOT cl_null(g_eck01) THEN 
            IF g_eck00 = '1' THEN 
              #FUN-A0059 -----------------add start-------------
               IF NOT s_chk_item_no(g_eck01,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD eck01
               END IF 
              #FUN-AA0059 ----------------add end------------------
               LET l_cnt =0
               LET l_imaacti = NULL
               LET l_ima02   = NULL 
               SELECT COUNT(*),imaacti,ima02 INTO l_cnt,l_imaacti,l_ima02   #TQC-A60117 add ima02 
                 FROM ima_file
                WHERE ima01 = g_eck01
                GROUP BY imaacti,ima02   #TQC-A60117
               IF l_cnt = 0 THEN 
                  CALL cl_err('','aem-041',0)
                  NEXT FIELD eck01
               ELSE
             	    IF l_imaacti = 'N' THEN 
             	       CALL cl_err('','9028',0)
             	       NEXT FIELD eck01
             	    ELSE
             	    	 DISPLAY l_ima02 TO FORMONLY.ima02    #TQC-A60117 add    
             	    END IF    
                END IF  
             ELSE
                LET l_cnt = 0 
                LET l_imzacti = NULL
                LET l_imz02   = NULL
                SELECT COUNT(*),imzacti,imz02 INTO l_cnt,l_imzacti,l_imz02  #TQC-A60117 add imz02 
                  FROM imz_file
                 WHERE imz01 = g_eck01
                 GROUP BY imzacti,imz02   #TQC-A60117 add imz02 
                IF l_cnt = 0 THEN 
                   CALL cl_err('','mfg3022',0)
                   NEXT FIELD CURRENT 
                ELSE
                   IF l_imzacti = 'N' THEN 
                      CALL cl_err('','9028',0)
                      NEXT FIELD CURRENT 
                   ELSE
                   	  DISPLAY l_imz02 TO FORMONLY.ima02   #TQC-A60117 add   
                   END IF 
                END IF 	     
             END IF 	   
          ELSE
             NEXT FIELD CURRENT 
          END IF 	
          
        AFTER FIELD eck02
          IF NOT cl_null(g_eck02) THEN 
             LET l_cnt =0
             LET l_eciacti = NULL
             LET l_eci06   = NULL
             SELECT COUNT(*),eciacti,eci06 INTO l_cnt,l_eciacti,l_eci06   #TQC-A60117 add eci06
               FROM eci_file
              WHERE eci01 = g_eck02
              GROUP BY eciacti,eci06  #TQC-A60117 add eci06
             IF l_cnt = 0 THEN 
                CALL cl_err('','aem-041',0)
                NEXT FIELD eck02
             ELSE
             	  IF l_eciacti = 'N' THEN 
             	     CALL cl_err('','9028',0)
             	     NEXT FIELD eck02
             	  ELSE
             	  	 DISPLAY l_eci06 TO FORMONLY.rpf02   #TQC-A60117 add   
             	  END IF    
             END IF           
          ELSE
          	 LET g_eck02 = ' '          
          END IF  
          
        AFTER FIELD eck03
          IF NOT cl_null(g_eck03) THEN 
             LET l_cnt =0
             LET l_ecdacti = NULL
             LET l_ecd02   = NULL 
             SELECT COUNT(*),ecdacti,ecd02 INTO l_cnt,l_ecdacti,l_ecd02  #TQC-A60117 add ecd02 
               FROM ecd_file
              WHERE ecd01 = g_eck03
              GROUP BY ecdacti,ecd02    #TQC-A60117 add ecd02
             IF l_cnt = 0 THEN 
                CALL cl_err('','aem-041',0)
                NEXT FIELD eck03
             ELSE
             	  IF l_ecdacti = 'N' THEN 
             	     CALL cl_err('','9028',0)
             	     NEXT FIELD eck03
             	  ELSE
             	  	 DISPLAY l_ecd02 TO FORMONLY.ecb17   #TQC-A60117
             	  END IF    
             END IF      
          ELSE
          	 LET g_eck03 = ' '              
          END IF             
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF 
            IF g_eck00 NOT MATCHES '[12]' THEN NEXT FIELD eck00 END IF 
            IF cl_null(g_eck02) THEN LET g_eck02 = ' ' END IF 
            IF cl_null(g_eck03) THEN LET g_eck03 = ' ' END IF 
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(eck01)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  IF g_eck00 = '1' THEN 
             #    LET g_qryparam.form ="q_eck01"
             #  ELSE
             #    LET g_qryparam.form = "q_imz"
             #  END IF 	  
             #  LET g_qryparam.default1 = g_eck01
             #  CALL cl_create_qry() RETURNING g_eck01
               IF g_eck00 = '1' THEN
                   CALL q_sel_ima(FALSE, "q_eck01", "", g_eck01, "", "", "", "" ,"",'' )  RETURNING g_eck01
               ELSE 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imz"
                  LET g_qryparam.default1 = g_eck01
                  CALL cl_create_qry() RETURNING g_eck01              
               END IF 
#FUN-AA0059 --End--
               DISPLAY g_eck01 TO eck01
               NEXT FIELD eck01
                            
           WHEN INFIELD(eck02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_eck02"
               LET g_qryparam.default1 = g_eck02
               CALL cl_create_qry() RETURNING g_eck02
               DISPLAY g_eck02 TO eck02
               NEXT FIELD eck02
                          
           WHEN INFIELD(eck03)
                CALL q_ecd(FALSE,TRUE,g_eck03) RETURNING g_eck03
                 DISPLAY g_eck03 TO eck03
                 NEXT FIELD eck03
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
 
      ON ACTION controlg      
         CALL cl_cmdask()   
   
    END INPUT
END FUNCTION
   
FUNCTION i621_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    INITIALIZE g_eck00 TO NULL   
    INITIALIZE g_eck01 TO NULL   
    INITIALIZE g_eck02 TO NULL  
    INITIALIZE g_eck03 TO NULL
    
    MESSAGE ""

    CALL i621_curs()            
    IF INT_FLAG THEN                   
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i621_b_curs         
    IF SQLCA.sqlcode THEN                    
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_eck00 TO NULL 
        INITIALIZE g_eck01 TO NULL
        INITIALIZE g_eck02 TO NULL
        INITIALIZE g_eck03 TO NULL
    ELSE
        OPEN i621_count
        FETCH i621_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i621_fetch('F')         
    END IF
END FUNCTION
 
FUNCTION i621_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,  
    l_abso          LIKE type_file.num10  
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i621_b_curs INTO g_eck00,g_eck01,g_eck02,g_eck03
        WHEN 'P' FETCH PREVIOUS i621_b_curs INTO g_eck00,g_eck01,g_eck02,g_eck03
        WHEN 'F' FETCH FIRST    i621_b_curs INTO g_eck00,g_eck01,g_eck02,g_eck03
        WHEN 'L' FETCH LAST     i621_b_curs INTO g_eck00,g_eck01,g_eck02,g_eck03
        WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
               
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i621_b_curs INTO g_eck00,g_eck01,g_eck02,g_eck03
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                   
       CALL cl_err(g_eck01,SQLCA.sqlcode,0)
       INITIALIZE g_eck00 TO NULL
       INITIALIZE g_eck01 TO NULL  
       INITIALIZE g_eck02 TO NULL  
       INITIALIZE g_eck03 TO NULL
    ELSE
       CALL i621_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION

FUNCTION i621_show()
DEFINE l_ima02     LIKE ima_file.ima02   #TQC-A60117
DEFINE l_imz02     LIKE imz_file.imz02   #TQC-A60117
DEFINE l_eci06     LIKE eci_file.eci06   #TQC-A60117
DEFINE l_ecd02     LIKE ecd_file.ecd02   #TQC-A60117
    
    DISPLAY g_eck00 TO eck00
    DISPLAY g_eck01 TO eck01
    DISPLAY g_eck02 TO eck02
    DISPLAY g_eck03 TO eck03   

    IF cl_null(g_wc) THEN 
       LET g_wc = " 1=1"
    END IF 
    #FUN-AC0076 add  -------------begin-------------
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " eck00 = '",g_argv1,"' AND eck01 = '",g_argv2,"'"
    END IF 
    #FUN-AC0076 add  --------------end--------------
    IF cl_null(g_eck02) THEN 
       LET g_eck02 = ' ' 
    END IF 
    IF cl_null(g_eck03) THEN 
       LET g_eck03 = ' '
    END IF     

#TQC-A60117 --begin--
   LET l_ima02 = NULL 
   LET l_imz02 = NULL
   LET l_eci06 = NULL
   LET l_ecd02 = NULL
   IF g_eck00 = '1' THEN 
      SELECT ima02 INTO l_ima02 FROM ima_file 
       WHERE ima01 = g_eck01
      DISPLAY l_ima02 TO FORMONLY.ima02
   ELSE
  	  SELECT imz02 INTO l_imz02 FROM imz_file
  	   WHERE imz01 = g_eck01
  	  DISPLAY l_imz02 TO FORMONLY.ima02 
   END IF 	
  
  SELECT eci06 INTO l_eci06 FROM eci_file
   WHERE eci01 = g_eck02
   DISPLAY l_eci06 TO FORMONLY.rpf02
  SELECT ecd02 INTO l_ecd02 FROM ecd_file
   WHERE ecd01 = g_eck03
  DISPLAY l_ecd02 TO FORMONLY.ecb17  
#TQC-A60117 --end--
       
    CALL i621_b_fill(g_wc)                  
    
    CALL cl_show_fld_cont()   

#TQC-A60117 --begin--    
#    IF g_chr = 'c' THEN 
#       CALL i621_b()
#    END IF        
#TQC-A60117 --end--
END FUNCTION
 
FUNCTION i621_r()
#DEFINE l_cnt     LIKE type_file.num5 
 
    IF s_shut(0) THEN
        RETURN
    END IF
 
    IF cl_null(g_eck00) OR cl_null(g_eck01) THEN 
       CALL cl_err("",-400,0)                
       RETURN 
    END IF
    
#    SELECT COUNT(*) INTO l_cnt FROM eck_file
#     WHERE eck01 = g_eck01 
#       AND eck02 = g_eck02
#       AND eck03 = g_eck03
#    IF l_cnt = 0 THEN 
#       
#    END IF    
    
    BEGIN WORK
    IF cl_delh(0,0) THEN                  
        INITIALIZE g_doc.* TO NULL    
        LET g_doc.column1 = "eck00" 
        LET g_doc.column2 = "eck01"   
        LET g_doc.column3 = "eck02"
        LET g_doc.column4 = "eck03"   
        LET g_doc.value1 = g_eck00     
        LET g_doc.value2 = g_eck01
        LET g_doc.value3 = g_eck02
        LET g_doc.value4 = g_eck03      
        CALL cl_del_doc()              
        DELETE FROM eck_file WHERE eck00 = g_eck00
                               AND eck01 = g_eck01
                               AND eck02 = g_eck02
                               AND eck03 = g_eck03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","eck_file",g_eck01,'',SQLCA.sqlcode,"","del eck_file",1) 
        ELSE
            CLEAR FORM
            DROP TABLE x
            PREPARE i621_precount_x2 FROM g_sql_tmp  
            EXECUTE i621_precount_x2              
            CALL g_eck.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            
            OPEN i621_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i621_b_curs
               CLOSE i621_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i621_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i621_b_curs
               CLOSE i621_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i621_b_curs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i621_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i621_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION i621_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      
    l_n             LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,      
    p_cmd           LIKE type_file.chr1,      
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5      
DEFINE l_cnt        LIKE type_file.num5 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_eck01) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT eck04,eck05,eck06,eck07 FROM eck_file ",
                       "  WHERE eck00 = ? AND eck01=? AND eck02 = ? AND eck03 =? ",
                       "    AND eck04 = ? AND eck05 = ?",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i621_bcl CURSOR FROM g_forupd_sql     
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_eck WITHOUT DEFAULTS FROM s_eck.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'           
            LET l_n  = ARR_COUNT()
            
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_eck_t.* = g_eck[l_ac].*   
                OPEN i621_bcl USING g_eck00,g_eck01,g_eck02,g_eck03,g_eck_t.eck04,g_eck_t.eck05
 
                IF STATUS THEN
                   CALL cl_err("OPEN i621_bcl:", STATUS, 1)
                   CLOSE i621_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i621_bcl INTO g_eck[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_eck_t.eck04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()   
                CALL i621_set_entry_b(p_cmd)                  
#                CALL i621_set_no_entry_b(p_cmd)                    
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_eck[l_ac].eck04) OR cl_null(g_eck[l_ac].eck05) THEN  
                INITIALIZE g_eck[l_ac].* TO NULL
            END IF
            
            INSERT INTO eck_file(eck00,eck01,eck02,eck03,eck04,eck05,eck06,eck07,
                                 eckuser,eckgrup,eckmodu,eckacti,eckdate,eckorig,eckoriu)  #TQC-A60117 add eckorig,eckoriu
                 VALUES(g_eck00,g_eck01,g_eck02,g_eck03,g_eck[l_ac].eck04,g_eck[l_ac].eck05,
                        g_eck[l_ac].eck06,g_eck[l_ac].eck07,  
                        g_eckuser,g_eckgrup,g_eckmodu,g_eckacti,g_eckdate,g_grup,g_user)  #TQC-A60117 add g_grup,g_user
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","eck_file",g_eck01,'',SQLCA.sqlcode,"","",1) 
                CANCEL INSERT
              ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_eck[l_ac].* TO NULL      
            LET g_eck_t.* = g_eck[l_ac].*    
#           LET g_eck[l_ac].eck04 = 0   #TQC-A60117
#           LET g_eck[l_ac].eck05 = 0   #TQC-A60117 
            LET g_eck[l_ac].eck06 = 0 
            LET g_eck[l_ac].eck07 = 0            
#           DISPLAY g_eck[l_ac].eck04 TO eck04  #TQC-A60117
#           DISPLAY g_eck[l_ac].eck05 TO eck05  #TQC-A60117
            DISPLAY g_eck[l_ac].eck06 TO eck06
            DISPLAY g_eck[l_ac].eck07 TO eck07            
            CALL cl_show_fld_cont() 
            CALL i621_set_entry_b(p_cmd)                  
            CALL i621_set_no_entry_b(p_cmd)                  
            NEXT FIELD eck04
 
      AFTER FIELD eck04
         IF NOT cl_null(g_eck[l_ac].eck04) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_eck[l_ac].eck04 != g_eck_t.eck04) THEN 
            IF g_eck[l_ac].eck04 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD CURRENT 
            ELSE
            	  IF NOT cl_null(g_eck[l_ac].eck05) THEN 
            	     IF g_eck[l_ac].eck04 > g_eck[l_ac].eck05 THEN 
            	        CALL cl_err('','aec-302',0)
            	        NEXT FIELD eck04
            	     ELSE              	     
            	        SELECT COUNT(*) INTO l_cnt FROM eck_file
            	         WHERE eck00 = g_eck00
            	           AND eck01 = g_eck01
            	           AND eck02 = g_eck02
            	           AND eck03 = g_eck03
            	           AND eck04 = g_eck[l_ac].eck04
            	           AND eck05 = g_eck[l_ac].eck05
            	        IF l_cnt > 0 THEN             	     
            	           CALL cl_err('','-239',0)
#            	           LET g_eck[l_ac].eck04 = g_eck[l_ac].eck04 + 1   #TQC-A60117         	       
#            	           LET g_eck[l_ac].eck05 = g_eck[l_ac].eck05 + 1   #TQC-A60117
            	           NEXT FIELD CURRENT 
#TQC-A60117 --begin--            	           
            	        ELSE
            	        	  LET l_cnt = 0
            	        	  SELECT COUNT(*) INTO l_cnt FROM eck_file
            	        	   WHERE eck00 = g_eck00
            	        	     AND eck01 = g_eck01
            	        	     AND eck02 = g_eck02
            	        	     AND eck03 = g_eck03
            	        	     AND ((eck04<=g_eck[l_ac].eck04 AND g_eck[l_ac].eck05<=eck05) OR 
            	        	           (g_eck[l_ac].eck04<=eck04 AND eck05<=g_eck[l_ac].eck05) OR 
            	        	           (g_eck[l_ac].eck04<=eck04 AND eck04<=g_eck[l_ac].eck05) OR 
            	        	           (g_eck[l_ac].eck04<=eck05 AND eck05<=g_eck[l_ac].eck05))    #FUN-A60092             	        	                	        	     
            	        	  IF l_cnt > 0 THEN 
            	        	     CALL cl_err('','aec-314',0)
            	        	     NEXT FIELD CURRENT 
            	        	  END IF      
#TQC-A60117 --end--            	        	  
            	        END IF     
            	    END IF 
            	 END IF        
            END IF 
           END IF  
         ELSE
            NEXT FIELD CURRENT 
         END IF 

       AFTER FIELD eck05 
         IF NOT cl_null(g_eck[l_ac].eck05) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_eck[l_ac].eck05 != g_eck_t.eck05) THEN 
            IF g_eck[l_ac].eck05 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD CURRENT 
            ELSE
            	  IF NOT cl_null(g_eck[l_ac].eck04) THEN 
            	     IF g_eck[l_ac].eck05 < g_eck[l_ac].eck04 THEN 
            	        CALL cl_err('','aec-303',0)
            	        NEXT FIELD eck05
            	     ELSE              	     
            	        SELECT COUNT(*) INTO l_cnt FROM eck_file
            	         WHERE eck00 = g_eck00
            	           AND eck01 = g_eck01
            	           AND eck02 = g_eck02
            	           AND eck03 = g_eck03
            	           AND eck04 = g_eck[l_ac].eck04
            	           AND eck05 = g_eck[l_ac].eck05
            	        IF l_cnt > 0 THEN             	     
            	           CALL cl_err('','-239',0)
#            	           LET g_eck[l_ac].eck04 = g_eck[l_ac].eck04 + 1  #TQC-A60117          	       
#            	           LET g_eck[l_ac].eck05 = g_eck[l_ac].eck05 + 1  #TQC-A60117
            	           NEXT FIELD CURRENT 
#TQC-A60117 --begin--            	           
            	        ELSE
            	        	  LET l_cnt = 0
            	        	  SELECT COUNT(*) INTO l_cnt FROM eck_file
            	        	   WHERE eck00 = g_eck00
            	        	     AND eck01 = g_eck01
            	        	     AND eck02 = g_eck02
            	        	     AND eck03 = g_eck03
            	        	     AND (
            	        	           (eck04<=g_eck[l_ac].eck04 AND g_eck[l_ac].eck05<=eck05) OR 
            	        	           (g_eck[l_ac].eck04<=eck04 AND eck05<=g_eck[l_ac].eck05) OR 
            	        	           (g_eck[l_ac].eck04<=eck04 AND eck04<=g_eck[l_ac].eck05) OR 
            	        	           (g_eck[l_ac].eck04<=eck05 AND eck05<=g_eck[l_ac].eck05)    #FUN-A60092 
            	        	           )               	        	                       	        	                 	        	     
            	        	  IF l_cnt > 0 THEN 
            	        	     CALL cl_err('','aec-314',0)
            	        	     NEXT FIELD CURRENT 
            	        	  END IF      
#TQC-A60117 --end--               	           
            	        END IF     
            	    END IF 
            	 END IF        
            END IF 
           END IF  
         ELSE
            NEXT FIELD CURRENT 
         END IF                 
       
       AFTER FIELD eck06
         IF NOT cl_null(g_eck[l_ac].eck06) THEN 
            IF g_eck[l_ac].eck06 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD CURRENT    
            END IF 
         ELSE
            NEXT FIELD CURRENT 
         END IF 

       AFTER FIELD eck07
         IF NOT cl_null(g_eck[l_ac].eck07) THEN 
            IF g_eck[l_ac].eck07 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD CURRENT 
            END IF 
         ELSE
            NEXT FIELD CURRENT 
         END IF 
             
        BEFORE DELETE                           
            IF NOT cl_null(g_eck[l_ac].eck04) OR 
               NOT cl_null(g_eck[l_ac].eck05) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM eck_file
                 WHERE eck00 = g_eck00 
                   AND eck01 = g_eck01
                   AND eck02 = g_eck02
                   AND eck03 = g_eck03
                   AND eck04 = g_eck_t.eck04
                   AND eck05 = g_eck_t.eck05
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","eck_file",g_eck01,'',SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_eck[l_ac].* = g_eck_t.*
               CLOSE i621_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_eck[l_ac].eck04,-263,1)
               LET g_eck[l_ac].* = g_eck_t.*
            ELSE
               IF cl_null(g_eck[l_ac].eck04) OR cl_null(g_eck[l_ac].eck05) THEN 
                   INITIALIZE g_eck[l_ac].* TO NULL
               END IF
               UPDATE eck_file SET
                      eck04=g_eck[l_ac].eck04,
                      eck05=g_eck[l_ac].eck05,
                      eck06=g_eck[l_ac].eck06,
                      eck07=g_eck[l_ac].eck07
               WHERE eck00 = g_eck00
                 AND eck01 = g_eck01 
                 AND eck02 = g_eck02
                 AND eck03 = g_eck03
                 AND eck04 = g_eck_t.eck04
                 AND eck05 = g_eck_t.eck05
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","eck_file",g_eck01,'',SQLCA.sqlcode,"","",1) 
                   LET g_eck[l_ac].* = g_eck_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_eck[l_ac].* = g_eck_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_eck.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i621_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i621_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(eck04) AND l_ac > 1 THEN
                LET g_eck[l_ac].* = g_eck[l_ac-1].*
                NEXT FIELD eck04
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
                                         
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                                               
        
        END INPUT
    
    IF p_cmd = 'u' THEN 
       UPDATE eck_file SET eckmodu = g_user,
                           eckdate = g_today
        WHERE eck00 = g_eck00 
          AND eck01 = g_eck01
          AND eck02 = g_eck02
          AND eck03 = g_eck03
        DISPLAY g_user,g_today TO eckmodu,eckdate   
    END IF     
    CLOSE i621_bcl
    COMMIT WORK
    CALL i621_delall()
END FUNCTION

FUNCTION i621_delall()
 DEFINE l_cnt         LIKE type_file.num5 
 
 LET l_cnt = 0 
 SELECT COUNT(*) INTO l_cnt FROM eck_file
  WHERE eck00 = g_eck00
    AND eck01 = g_eck01
    AND eck02 = g_eck02
    AND eck03 = g_eck03    

   IF l_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM eck_file WHERE eck00 = g_eck00
                             AND eck01 = g_eck01
                             AND eck02 = g_eck02
                             AND eck03 = g_eck03
      CLEAR FORM 
      LET g_eck01 = NULL                        
   END IF
END FUNCTION
 
FUNCTION i621_b_fill(p_wc)              
DEFINE p_wc     LIKE type_file.chr1000

#TQC-A60117 --begin-- 
# IF g_chr = 'c' THEN 
#    LET g_sql ="SELECT eck04,eck05,eck06,eck07,eckacti,eckuser,eckgrup,eckdate,eckmodu FROM eck_file",
#               " WHERE eck00 = '",g_eck00,"'",
#               "   AND eck01 = '",g_eck01,"'",
#               "   AND eck02 = '",g_eck02,"'",
#               "   AND eck03 = '",g_eck03,"'",
#               "   AND eck04 >= ",g_eck04_1,
#               "   AND eck05 >= ",g_eck05_1,
#               " ORDER BY eck04,eck05"
#  ELSE  
#    LET g_sql ="SELECT eck04,eck05,eck06,eck07,eckacti,eckuser,eckgrup,eckdate,eckmodu FROM eck_file",
#               " WHERE eck00 = '",g_eck00,"'",
#               "   AND eck01 = '",g_eck01,"'", 
#               "   AND eck02 = '",g_eck02,"'",
#               "   AND eck03 = '",g_eck03,"'",
#               "   AND ",p_wc CLIPPED ,
#               " ORDER BY eck04,eck05"
#  END IF             
    IF cl_null(g_argv1) THEN     #FUN-AC0076 add
       LET g_sql ="SELECT eck04,eck05,eck06,eck07,eckacti,eckuser,eckgrup,eckdate,eckmodu FROM eck_file",
                  " WHERE eck00 = '",g_eck00,"'",
                  "   AND eck01 = '",g_eck01,"'", 
                  "   AND eck02 = '",g_eck02,"'",
                  "   AND eck03 = '",g_eck03,"'",
                  "   AND ",p_wc CLIPPED ,
                  " ORDER BY eck04,eck05"
    #FUN-AC0076 add ------------begin-----------              
    ELSE
       LET g_sql ="SELECT eck04,eck05,eck06,eck07,eckacti,eckuser,eckgrup,eckdate,eckmodu FROM eck_file", 
                  " WHERE ",p_wc CLIPPED ,
                  "   AND eck02 = '",g_eck02,"'",
                  "   AND eck03 = '",g_eck03,"'",
                  " ORDER BY eck04,eck05"
    END IF   
    #FUN-AC0076 add -------------end------------                           
#TQC-A60117 --end--
   
    PREPARE i621_prepare2 FROM g_sql   
    DECLARE eck_curs CURSOR FOR i621_prepare2
    CALL g_eck.clear()
    
    LET g_cnt = 1
    FOREACH eck_curs INTO g_eck[g_cnt].*,g_eckacti,g_eckuser,g_eckgrup,g_eckdate,g_eckmodu
       IF STATUS THEN
          CALL cl_err('FOREACH:',STATUS,0)
          EXIT FOREACH
       END IF 
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
       END IF     
    END FOREACH
    
    DISPLAY g_eckacti TO eckacti
    DISPLAY g_eckuser TO eckuser
    DISPLAY g_eckgrup TO eckgrup
    DISPLAY g_eckdate TO eckdate
    DISPLAY g_eckmodu TO eckmodu 
    
    CALL g_eck.deleteElement(g_cnt)
    LET g_rec_b= g_cnt -1 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0     
    
END FUNCTION
 
FUNCTION i621_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      
  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_eck TO s_eck.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
         
      ON ACTION first
         CALL i621_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY            
                              
      ON ACTION previous
         CALL i621_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	       ACCEPT DISPLAY                
                              
      ON ACTION jump
         CALL i621_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
       	ACCEPT DISPLAY                
                              
      ON ACTION next
         CALL i621_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
       	ACCEPT DISPLAY             
                              
      ON ACTION last
         CALL i621_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	       ACCEPT DISPLAY                
                              
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                      
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                                    
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                                                          
FUNCTION i621_set_entry(p_cmd)                                                                                                      
DEFINE p_cmd   LIKE type_file.chr1                 
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("eck00,eck01,eck02,eck03",TRUE)                                                                                     
  END IF                                                                                                                           
                                                                                                                                    
END FUNCTION
                                                                                                                                   
FUNCTION i621_set_no_entry(p_cmd)                                                                                                   
DEFINE p_cmd   LIKE type_file.chr1              
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN                                                              
     CALL cl_set_comp_entry("eck00,eck01,eck02,eck03",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        

FUNCTION i621_set_entry_b(p_cmd)                                                                                                      
DEFINE p_cmd   LIKE type_file.chr1                 
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("eck04,eck05",TRUE)                                                                                     
  END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                                                                                                                                          
                                                                                                                                    
FUNCTION i621_set_no_entry_b(p_cmd)                                                                                                   
DEFINE p_cmd   LIKE type_file.chr1              
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN                                                              
     CALL cl_set_comp_entry("eck04,eck05",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION         
