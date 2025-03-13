# Prog. Version..: '5.30.06-13.03.12(00006)'     #
# Pattern name...: s_aecp110.4gl
# Descriptions...: 
# Date & Author..: FUN-A50100 10/06/01 By lilingyu 
# Modify.........: FUN-A60028 10/06/10 BY lilingyu 
# Modify.........: FUN-B20078 11/03/02 By lixh1 檢查下製程段號存在於aeci100製程段號 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷

DATABASE ds


GLOBALS "../../../tiptop/config/top.global"

GLOBALS "../../../tiptop/aec/4gl/aecp110.global"


FUNCTION p110_sub()    #FUN-A50100
 
 IF g_confirm_p110 = 'Y' THEN 
    LET g_arg1 = g_ecu.ecu01
    LET g_arg2 = g_ecu.ecu02
    LET g_success  = 'Y'
 END IF 

   WHILE TRUE
      LET g_max_level =20                    #FUN-A60028 
      IF g_confirm_p110 = 'Y' THEN ELSE      #FUN-A60028 
        CALL p110_tm(0,0)
      END IF                                 #FUN-A60028 
      
      IF g_confirm_p110 = 'Y' AND g_success = 'N' THEN 
        EXIT WHILE 
      END IF 
#FUN-A60028 --begin--
      IF g_confirm_p110 = 'Y' THEN 
         CALL p110()          
         EXIT WHILE     #add         
      ELSE 
#FUN-A60028 --end--
      IF cl_sure(18,20) THEN  
         CALL cl_wait()
         LET g_success = 'Y'
      
#        CALL p110(g_arg1,'aecp110') RETURNING g_i_p110        
         CALL p110()      
         
         IF g_success = 'Y' THEN 
            CALL cl_err('','mfg2641',1)         
            CALL cl_end2(1) RETURNING l_flag_p110   
         ELSE
            CALL cl_end2(2) RETURNING l_flag_p110             
         END IF 	   
         IF l_flag_p110 THEN
             CLOSE WINDOW p110_w
             CONTINUE WHILE
         ELSE
             CLOSE WINDOW p110_w
             EXIT WHILE
         END IF
      ELSE
         CLOSE WINDOW p110_w
         EXIT WHILE          
      END IF
    END IF      #FUN-A60028 
     
      CLOSE WINDOW p110_w
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END FUNCTION 

FUNCTION p110_tm(p_row,p_col)
DEFINE p_row,p_col	LIKE type_file.num5    
 
   OPEN WINDOW p110_w WITH FORM "cec/42f/aecp110"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
#  LET g_max_level =20                    #FUN-A60028 

WHILE TRUE
   LET g_change_lang_p110 = FALSE                           
 
   CLEAR FORM 

   DISPLAY g_arg1 TO ecu01
   DISPLAY g_arg2 TO ecu02
   DISPLAY g_max_level TO max_level   
   
   IF NOT cl_null(g_arg1) AND NOT cl_null(g_arg2) THEN
      CALL cl_set_comp_entry("ecu01,ecu02",FALSE)
   ELSE
   	  CALL cl_set_comp_entry("ecu01,ecu02",TRUE) 
     
      CONSTRUCT BY NAME g_wc_p110 ON ecu01,ecu02
   
        BEFORE CONSTRUCT 
           CALL cl_qbe_init()            
                
        ON ACTION controlp
           CASE
             WHEN INFIELD(ecu01)
                CALL cl_init_qry_var()
                LET g_qryparam.state    = "c"
                LET g_qryparam.form = "q_ecu01_1"      
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecu01
                NEXT FIELD ecu01               
              
             WHEN INFIELD(ecu02)
                CALL cl_init_qry_var()
                LET g_qryparam.state =  "c"
                LET g_qryparam.form = "q_ecu02_2"      
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ecu02
                NEXT FIELD ecu02                  
           END CASE     
          
     END CONSTRUCT    	    
   END IF   
      
   
   INPUT g_max_level WITHOUT DEFAULTS FROM max_level

   AFTER FIELD max_level
     IF NOT cl_null(g_max_level) THEN
       IF g_max_level <=0 THEN
          NEXT FIELD CURRENT 
       END IF
     END IF   
    
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
   ON ACTION CONTROLG 
      CALL cl_cmdask()	
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION locale
          LET g_change_lang_p110 = TRUE
          EXIT INPUT

      ON ACTION exit                            
          LET INT_FLAG = 1
          EXIT INPUT

         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p110_w
      IF g_confirm_p110 = 'Y' THEN
         LET g_success = 'N'
         EXIT WHILE 
      ELSE
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
         EXIT PROGRAM
      END IF 
   ELSE
   	  EXIT WHILE    
   END IF
#   IF g_change_lang_p110 = TRUE THEN
#      LET g_change_lang_p110 = FALSE                   
#      CALL cl_dynamic_locale()                 
#      CALL cl_show_fld_cont()                  
#       CONTINUE WHILE
#   END IF

 END WHILE
END FUNCTION
 
#FUNCTION p110(p_ecu01,p_prog) 
FUNCTION p110()
  DEFINE l_sql        STRING
  DEFINE l_cnt        LIKE type_file.num5 
  DEFINE l_count      LIKE type_file.num5 
  DEFINE i            LIKE type_file.num5 
  DEFINE l_ecu_p11001      LIKE ecu_file.ecu01
  DEFINE l_ecu_p11002      LIKE ecu_file.ecu02
  DEFINE l_cnt1       LIKE type_file.num5      #FUN-B20078
  
   IF NOT cl_null(g_arg1) AND NOT cl_null(g_arg2) THEN 
     LET l_sql = "SELECT * FROM ecu_file WHERE ecu01 = '",g_arg1,"'",
                 " AND ecu02 = '",g_arg2,"'",
                 " ORDER BY ecu01,ecu02" 
   ELSE
     IF cl_null(g_wc_p110) THEN LET g_wc_p110 = ' 1=1' END IF 
     LET l_sql = "SELECT * FROM ecu_file WHERE ",g_wc_p110 CLIPPED,
                 " ORDER BY ecu01,ecu02"
   END IF 	              
   
   PREPARE p110_pb FROM l_sql
   DECLARE p110_pb_cs CURSOR FOR p110_pb
   
   LET g_flag_p110 = 'N'
   LET l_count = 0 
   FOREACH p110_pb_cs INTO l_ecu_p110.*
     LET g_flag_p110 = 'Y'
#FUN-B20078 ---------------------Begin---------------------------
     IF NOT cl_null(l_ecu_p110.ecu015) THEN
        SELECT COUNT(*) INTO l_cnt1 FROM ecu_file
         WHERE ecu012 = l_ecu_p110.ecu015
           AND ecu01 = l_ecu_p110.ecu01
           AND ecu02 = l_ecu_p110.ecu02
           AND ecuacti = 'Y'  #CHI-C90006
        IF cl_null(l_cnt1) THEN LET l_cnt1= 0 END IF
        IF l_cnt1 < 1 THEN
           CALL cl_err(l_ecu_p110.ecu015,'aec-043',1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END IF
#FUN-B20078 ---------------------End-----------------------------
     SELECT COUNT(*) INTO l_cnt FROM ecu_file 
      WHERE ecu01 = l_ecu_p110.ecu01
        AND ecu02 = l_ecu_p110.ecu02
        AND ecu015 IS NOT NULL 
        AND ecuacti = 'Y'  #CHI-C90006
     IF l_cnt = 0 THEN 
        LET l_count = l_count + 1 
        IF l_count > 1  THEN 
           CALL cl_err('','aec-045',1)
           LET g_success = 'N'
           EXIT FOREACH 
        ELSE        	
          CONTINUE FOREACH 
        END IF   
     END IF    
   END FOREACH       
   
   IF g_success = 'Y' THEN 
      INITIALIZE l_ecu_p110.* TO NULL 
      FOREACH p110_pb_cs INTO l_ecu_p110.*
        IF g_success = 'Y' THEN 
          LET g_max = 1
          LET g_ecu012_a[1] = l_ecu_p110.ecu012 
          CALL p110_bom(0,l_ecu_p110.ecu012)
         ELSE
           EXIT FOREACH 
         END IF 	  
      END FOREACH 
   END IF  

   IF g_success = 'Y' THEN 
      INITIALIZE l_ecu_p110.* TO NULL    
      FOREACH p110_pb_cs INTO l_ecu_p110.*
        SELECT COUNT(*) INTO l_cnt FROM ecu_file 
         WHERE ecu01 = l_ecu_p110.ecu01
           AND ecu02 = l_ecu_p110.ecu02
           AND ecu015 IS NULL 
           AND ecuacti = 'Y'  #CHI-C90006
        IF l_cnt > 1 THEN 
           CALL cl_err('','aec-045',1)
           LET g_success = 'N'
           EXIT FOREACH 
        END IF      
     END FOREACH       
   END IF 

   IF g_flag_p110 = 'N' THEN 
      CALL cl_err('','aec-049',1)
      LET g_success  = 'N'
   END IF 
END FUNCTION
 
#FUNCTION p110_bom(p_level,p_key,p_acode) 
FUNCTION p110_bom(p_level,p_key)
DEFINE p_level	LIKE type_file.num5
DEFINE p_key		LIKE ecu_file.ecu012
DEFINE l_ac,i	  LIKE type_file.num5
DEFINE arrno		LIKE type_file.num5
DEFINE l_sql    STRING          
DEFINE sr       DYNAMIC ARRAY OF RECORD      
                  ecu012 LIKE ecu_file.ecu012,
                  ecu015 LIKE ecu_file.ecu015    
                END RECORD 
DEFINE l_tot    LIKE type_file.num5
DEFINE l_times  LIKE type_file.num5
 
    LET g_chr_p110 = 'Y'
    
    LET p_level = p_level + 1
    IF p_level=1 THEN
        LET sr[1].ecu015 = p_key
    END IF
    
    LET arrno = 600
    
  WHILE TRUE
    LET l_sql="SELECT ecu012,ecu015 FROM ecu_file",
              " WHERE ecu01 = '",l_ecu_p110.ecu01,"'",
              "   AND ecu02 = '",l_ecu_p110.ecu02,"'",
              "   AND ecu015= '",p_key,"'",
              "   AND ecuacti = 'Y' "  #CHI-C90006
    	  
    PREPARE p110_pb_1 FROM l_sql
    DECLARE p110_pb_1_cs CURSOR FOR p110_pb_1
    
	  LET l_times=1 
    LET l_ac = 1
    FOREACH p110_pb_1_cs INTO sr[l_ac].*
       LET l_ac = l_ac + 1	
       IF l_ac > arrno THEN 
          EXIT FOREACH 
       END IF
    END FOREACH
         
	  LET l_tot = l_ac - 1
    FOR i = 1 TO l_tot 	       
       FOR g_cnt_p110=1 TO g_max
#          IF sr[i].bmb03 = g_bma01[g_cnt_p110] THEN
#              LET sr[i].bma01=p_key
#              LET sr[i].bma01=''          #
#              LET g_err=g_err+1
#              EXIT FOR
#           END IF
            IF sr[i].ecu012 = l_ecu_p110.ecu015 THEN 
               CALL cl_err(l_ecu_p110.ecu015,'aec-047',1)
               LET g_chr_p110 = 'N'
               LET g_success = 'N'
               EXIT FOR
            END IF 
       END FOR
       IF g_chr_p110 = 'N' THEN 
          EXIT FOR
       END IF 
               
#       IF sr[i].bma01 IS NOT NULL THEN
#           LET g_max=g_max+1
#           IF g_max > g_max_level THEN   
#               EXIT FOR
#           END IF
#           LET g_bma01[g_max]=sr[i].bma01
#           CALL p110_bom(p_level,sr[i].bmb03,l_ima910[i]) 
#      END IF
       IF sr[i].ecu015 IS NOT NULL THEN 
          LET g_max = g_max + 1 
          IF g_max > g_max_level THEN 
             EXIT FOR 
          END IF 
       END IF 
       LET g_ecu012_a[g_max] = sr[i].ecu012
       CALL p110_bom(p_level,sr[i].ecu012)
  END FOR

  IF l_tot < arrno OR l_tot=0 THEN             
      EXIT WHILE
  END IF
 
  END WHILE
  LET g_max = g_max - 1
END FUNCTION 
