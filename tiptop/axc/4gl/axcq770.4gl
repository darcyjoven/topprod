# Prog. Version..: '5.30.06-13.03.29(00004)'     #
#
# Pattern name...: axcq770.4gl
# Descriptions...: 
# Date & Author..: 10/05/24 By xiaofeizhu #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C70138 12/07/11 By yinhy 增加類別代碼,部門,理由參數
# Modify.........: No:MOD-D30247 13/03/28 By ck2yuan 系統ina09已無使用，故抓取ina09程式Mark 
 
DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-AA0025 
DEFINE
   g_tlf01        LIKE tlf_file.tlf01, 
   g_tlf DYNAMIC ARRAY OF RECORD
         tlf14    LIKE tlf_file.tlf14,
         tlf19    LIKE tlf_file.tlf19,
         gem02    LIKE gem_file.gem02,            
         tlf021   LIKE tlf_file.tlf021,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf026,    
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlfccost LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         ccc23a   LIKE    ccc_file.ccc23a,
         ccc23b   LIKE    ccc_file.ccc23b,
         ccc23c   LIKE    ccc_file.ccc23c,
         ccc23d   LIKE    ccc_file.ccc23d,
         ccc23e   LIKE    ccc_file.ccc23e,
         ccc23f   LIKE    ccc_file.ccc23f,
         ccc23g   LIKE    ccc_file.ccc23g,
         ccc23h   LIKE    ccc_file.ccc23h,
         ccc23a2  LIKE    ccc_file.ccc23a                    
             END RECORD,
   g_tlf_t       RECORD                  
         tlf14    LIKE tlf_file.tlf14,
         tlf19    LIKE tlf_file.tlf19,
         gem02    LIKE gem_file.gem02,            
         tlf021   LIKE tlf_file.tlf021,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf026,    
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlfccost LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         ccc23a   LIKE    ccc_file.ccc23a,
         ccc23b   LIKE    ccc_file.ccc23b,
         ccc23c   LIKE    ccc_file.ccc23c,
         ccc23d   LIKE    ccc_file.ccc23d,
         ccc23e   LIKE    ccc_file.ccc23e,
         ccc23f   LIKE    ccc_file.ccc23f,
         ccc23g   LIKE    ccc_file.ccc23g,
         ccc23h   LIKE    ccc_file.ccc23h,
         ccc23a2  LIKE    ccc_file.ccc23a 
             END RECORD,
   g_argv1       LIKE tlf_file.tlf01,
   g_argv2       LIKE cdj_file.cdj02,
   g_argv3       LIKE cdj_file.cdj03,   
   g_argv4       LIKE tlf_file.tlfcost,           #MOD-C70138
   g_argv5       LIKE cdl_file.cdl06,             #MOD-C70138
   g_argv6       LIKE cdl_file.cdl05,             #MOD-C70138
   g_argv7       LIKE type_file.chr1,             #MOD-C70138
   g_wc,g_sql    STRING,     
   g_rec_b       LIKE type_file.num5,        
   l_ac          LIKE type_file.num5        
DEFINE   g_forupd_sql    STRING                       
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_msg           LIKE ze_file.ze03           
DEFINE   g_row_count     LIKE type_file.num10         
DEFINE   g_curs_index    LIKE type_file.num10        
DEFINE   g_jump          LIKE type_file.num10         
DEFINE   mi_no_ask       LIKE type_file.num5          
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#  CALL cl_used('axcq770',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   LET g_argv1   = ARG_VAL(1)
   LET g_argv2   = ARG_VAL(2)
   LET g_argv3   = ARG_VAL(3)            
   LET g_argv4   = ARG_VAL(4)           #MOD-C70138
   LET g_argv5   = ARG_VAL(5)           #MOD-C70138
   LET g_argv6   = ARG_VAL(6)           #MOD-C70138
   LET g_argv7   = ARG_VAL(7)           #MOD-C70138
   LET g_tlf01   = NULL                  
   LET g_tlf01   = g_argv1
   
   OPEN WINDOW q770_w WITH FORM "axc/42f/axcq770"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL q770_q()
   END IF
   CALL q770_menu()
   CLOSE WINDOW q770_w                

#  CALL cl_used('axcq770',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION q770_curs()
   CLEAR FORM                            
   CALL g_tlf.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")          
   INITIALIZE g_tlf01 TO NULL 
           
     CONSTRUCT BY NAME g_wc ON tlf14,tlf19,tlf06,tlf01

     BEFORE CONSTRUCT
       CALL cl_qbe_init()

     ON ACTION controlp                                                      
        IF INFIELD(tlf01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO tlf01                             
           NEXT FIELD tlf01                                                 
        END IF 
 
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
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " tlf01 = '",g_argv1,"' AND YEAR(tlf06) = '",g_argv2,"' AND MONTH(tlf06) =  '",g_argv3,"'
                 AND tlfccost = '",g_argv4,"' AND tlf14 = '",g_argv5,"' AND  tlf19 = '",g_argv6,"' "         #MOD-C70138
   END IF

END FUNCTION
 
FUNCTION q770_menu()
   WHILE TRUE
      CALL q770_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q770_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlf),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q770_q()

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q770_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
      INITIALIZE g_tlf01 TO NULL
      RETURN
   END IF
 
   CALL q770_show()               

END FUNCTION
 
FUNCTION q770_show()          
   CALL q770_b_fill(g_wc)                
 
END FUNCTION
 
FUNCTION q770_b_fill(p_wc)               
DEFINE   p_wc        STRING,
         l_sql       STRING      
         
DEFINE   sr     RECORD 
              order1    LIKE type_file.chr20,          
              tlf037    LIKE    tlf_file.tlf037, 
              tlf907    LIKE    tlf_file.tlf907, 
              tlf13     LIKE    tlf_file.tlf13,  
              tlf14     LIKE    tlf_file.tlf14,  
              tlf17     LIKE    tlf_file.tlf17,  
              tlf19     LIKE    tlf_file.tlf19,  
              tlf021    LIKE    tlf_file.tlf021, 
              tlf031    LIKE    tlf_file.tlf031, 
              tlf06     LIKE    tlf_file.tlf06,  
              tlf026    LIKE    tlf_file.tlf026, 
              tlf027    LIKE    tlf_file.tlf027, 
              tlf036    LIKE    tlf_file.tlf036, 
              tlf01     LIKE    tlf_file.tlf01, 
              tlf10     LIKE    tlf_file.tlf10,  
              ccc23a    LIKE    ccc_file.ccc23a, 
              ccc23b    LIKE    ccc_file.ccc23b, 
              ccc23c    LIKE    ccc_file.ccc23c, 
              ccc23d    LIKE    ccc_file.ccc23d, 
              ccc23e    LIKE    ccc_file.ccc23e, 
              ccc23f    LIKE    ccc_file.ccc23f,                                                               
              ccc23g    LIKE    ccc_file.ccc23g,                                                               
              ccc23h    LIKE    ccc_file.ccc23h,   
              ima02     LIKE    ima_file.ima02,  
              tlfccost  LIKE    tlfc_file.tlfccost, 
              ima021    LIKE    ima_file.ima021, 
              ima12     LIKE    ima_file.ima12,  
              l_ccc23a  LIKE    ccc_file.ccc23a,
              l_ccc23b  LIKE    ccc_file.ccc23b,
              l_ccc23c  LIKE    ccc_file.ccc23c,
              l_ccc23d  LIKE    ccc_file.ccc23d,
              l_ccc23e  LIKE    ccc_file.ccc23e,
              l_ccc23f  LIKE    ccc_file.ccc23f,                                                                                          
              l_ccc23g  LIKE    ccc_file.ccc23g,                                                                                          
              l_ccc23h  LIKE    ccc_file.ccc23h,    
              l_tot     LIKE    ccc_file.ccc23a         #MOD-D30247
             #ina09     LIKE    ina_file.ina09          #MOD-D30247 mark
              END RECORD
 DEFINE l_inb13   LIKE   inb_file.inb13  
 DEFINE l_inb14   LIKE    inb_file.inb14    
 DEFINE l_exp_tot    LIKE     cmi_file.cmi08  
 DEFINE l_azf03      LIKE     azf_file.azf03  
 DEFINE l_gem02      LIKE gem_file.gem02      
 DEFINE l_i          LIKE type_file.num5                 
 DEFINE l_dbs        LIKE azp_file.azp03                 
 DEFINE i            LIKE type_file.num5                 
 DEFINE l_ima57      LIKE ima_file.ima57                 
 DEFINE l_ima08      LIKE ima_file.ima08                 
 DEFINE l_inb        RECORD LIKE inb_file.*               
 DEFINE l_tlfctype   LIKE tlfc_file.tlfctype  
 DEFINE l_slip       LIKE smy_file.smyslip    
 DEFINE l_smydmy1    LIKE smy_file.smydmy1    
 DEFINE l_azt02        LIKE azt_file.azt02        
 DEFINE l_n            LIKE type_file.num5        
 DEFINE l_tlf14        LIKE tlf_file.tlf14    
 DEFINE l_tlf19        LIKE tlf_file.tlf19   
                                            
               
    LET l_sql = "SELECT '',tlf037,tlf907,tlf13,tlf14,tlf17,tlf19,tlf021,tlf031,",          
                "       tlf06,tlf026,tlf027,",  
                "       tlf036,tlf01,tlf10*tlf60,tlfc221,tlfc222,tlfc2231,tlfc2232,", 
               #"       tlfc224,tlfc2241,tlfc2242,tlfc2243,ima02,tlfccost,ima021,ima12,'','','','','','','','','','',ima57,ima08,tlfctype",   #MOD-D30247 mark 
                "       tlfc224,tlfc2241,tlfc2242,tlfc2243,ima02,tlfccost,ima021,ima12,'','','','','','','','','',ima57,ima08,tlfctype",      #MOD-D30247 
                "  FROM tlf_file LEFT OUTER JOIN tlfc_file ON tlfc01 = tlf01  AND tlfc06 = tlf06 AND ",
                " tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",
                " tlfc13 = tlf13  AND ",
                " tlfc902= tlf902 AND tlfc903= tlf903 AND",
                " tlfc904= tlf904 AND tlfc907= tlf907 AND",
                " tlfc905= tlf905 AND tlfc906= tlf906 ",
                "   AND tlfclegal = tlflegal ",
                " ,ima_file ",
                " WHERE tlf01=ima01 ",
                "   AND (tlf13='aimt301' or tlf13='aimt311' ", 
                "    OR  tlf13='aimt302' or tlf13='aimt312'",
                "    OR  tlf13='aimt303' or tlf13='aimt313')",                
                "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ", 
                "   AND " ,p_wc CLIPPED

    PREPARE axcq770_prepare1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  
       EXIT PROGRAM 
    END IF
    DECLARE axcq770_curs1 CURSOR FOR axcq770_prepare1

    CALL g_tlf.clear()
    LET g_cnt = 1

    LET g_success = 'Y'                              
    CALL s_showmsg_init()                           
    FOREACH axcq770_curs1 INTO sr.*,l_ima57,l_ima08,l_tlfctype   
       IF STATUS THEN
          LET g_success = 'N'              
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH 
       END IF
                                                                                                     
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success='Y'                                                                                                         
       END IF                                                                                                                       

#       IF NOT cl_null(l_tlfctype) AND l_tlfctype <> tm.type THEN 
#          CONTINUE FOREACH
#       END IF

       IF sr.tlf907>0 THEN
          LET l_slip = s_get_doc_no(sr.tlf036)
       ELSE
          LET l_slip = s_get_doc_no(sr.tlf026)
       END IF
       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
        WHERE smyslip = l_slip
       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
          CONTINUE FOREACH
       END IF

#      IF tm.b = 'Y' THEN     
          LET l_sql = "SELECT * ",                                                                              
                      "  FROM inb_file",
                      " WHERE inb01 = '",sr.tlf026,"'",
                      "   AND inb03 = '",sr.tlf027,"'",
#                     "   AND inblegal = '",g_aaalegal CLIPPED,"'",
                      "   AND inb908 IS NULL"                                                                                                                                                                                   
          PREPARE inb_prepare3 FROM l_sql                                                                                          
          DECLARE inb_c3  CURSOR FOR inb_prepare3                                                                                 
          OPEN inb_c3                                                                                    
          FETCH inb_c3 INTO l_inb.*

#          IF NOT STATUS OR sr.tlf907 = 1 THEN
#             CONTINUE FOREACH
#          END IF
#      END IF

       IF sr.ccc23a IS NULL THEN LET sr.ccc23a=0 END IF
       IF sr.ccc23b IS NULL THEN LET sr.ccc23b=0 END IF
       IF sr.ccc23c IS NULL THEN LET sr.ccc23c=0 END IF
       IF sr.ccc23d IS NULL THEN LET sr.ccc23d=0 END IF
       IF sr.ccc23e IS NULL THEN LET sr.ccc23e=0 END IF
       IF sr.ccc23f IS NULL THEN LET sr.ccc23f=0 END IF                                                                            
       IF sr.ccc23g IS NULL THEN LET sr.ccc23g=0 END IF                                                                           
       IF sr.ccc23h IS NULL THEN LET sr.ccc23h=0 END IF              
       IF sr.tlf14 IS NULL THEN LET sr.tlf14=' ' END IF
       IF sr.tlf17 IS NULL THEN LET sr.tlf17=' ' END IF
       IF sr.tlf19 IS NULL THEN LET sr.tlf19=' ' END IF
      #IF sr.tlf907>0 THEN
      #   LET sr.order1=sr.tlf036      
      #   LET l_sql = "SELECT ina09 ",                                                                              
      #               "  FROM ina_file",
      #               " WHERE ina01='",sr.tlf036,"' AND ina00 IN ('3','4')", 
      #               "   AND ina02='",sr.tlf06,"'"                                                                                                                                                                                 
      #   PREPARE ina_prepare3 FROM l_sql                                                                                          
      #   DECLARE ina_c3  CURSOR FOR ina_prepare3                                                                                 
      #   OPEN ina_c3                                                                                    
      #   FETCH ina_c3 INTO sr.ina09                         
      #ELSE
      #   LET sr.order1=sr.tlf026      
      #   LET l_sql = "SELECT ina09 ",                                                                              
      #               "  FROM ina_file",
      #               " WHERE ina01='",sr.tlf026,"' AND ina00 NOT IN ('3','4')",  
#     #               "   AND inalegal = '",g_aaalegal CLIPPED,"'",
      #               "   AND ina02='",sr.tlf06,"'"                                                                                                                                                                                 
      #   PREPARE ina_prepare2 FROM l_sql                                                                                          
      #   DECLARE ina_c2  CURSOR FOR ina_prepare2                                                                                 
      #   OPEN ina_c2                                                                                    
      #   FETCH ina_c2 INTO sr.ina09            
      #END IF
       IF STATUS THEN
          CALL s_errmsg('','',sr.order1,STATUS,1)    
       END IF
 
       LET sr.tlf10 = sr.tlf10 * sr.tlf907

       IF sr.tlf13='aimt302' OR sr.tlf13='aimt312' THEN 
       IF sr.ccc23a = 0 THEN         
         LET l_inb14 = 0                                                                        
          LET l_sql = "SELECT inb13*inb09 ",                                                                           
                      "  FROM inb_file",
                      " WHERE inb01 = '",sr.tlf036,"'",
#                     "   AND inblegal = '",g_aaalegal CLIPPED,"'",
                      "   AND inb03 = '",sr.tlf037,"'"                                                                                                                                                                                 
          PREPARE inb_prepare2 FROM l_sql                                                                                          
          DECLARE inb_c2  CURSOR FOR inb_prepare2                                                                                 
          OPEN inb_c2                                                                                    
          FETCH inb_c2 INTO l_inb14                     
         IF cl_null(l_inb14) THEN LET l_inb14 = 0 END IF
         LET sr.l_ccc23a=l_inb14
       ELSE                                       
          LET sr.l_ccc23a = sr.ccc23a*sr.tlf907   
       END IF                        
       ELSE
           LET sr.l_ccc23a = sr.ccc23a*sr.tlf907
       END IF

       LET sr.l_ccc23b = sr.ccc23b*sr.tlf907
       LET sr.l_ccc23c = sr.ccc23c*sr.tlf907
       LET sr.l_ccc23d = sr.ccc23d*sr.tlf907
       LET sr.l_ccc23e = sr.ccc23e*sr.tlf907
       LET sr.l_ccc23f = sr.ccc23f*sr.tlf907  
       LET sr.l_ccc23g = sr.ccc23g*sr.tlf907   
       LET sr.l_ccc23h = sr.ccc23h*sr.tlf907  
 
       LET sr.l_tot=sr.l_ccc23a+sr.l_ccc23b+sr.l_ccc23c+sr.l_ccc23d+sr.l_ccc23e
                   +sr.l_ccc23f+sr.l_ccc23g+sr.l_ccc23h       

#       IF NOT cl_null(sr.ima12) THEN      
#          LET l_sql = "SELECT azf03 ",                                                                              
#                      "  FROM azf_file",
#                      " WHERE azf01='",sr.ima12,"' AND azf02='G'"                                                                                                                                                                                
#          PREPARE azf_prepare2 FROM l_sql                                                                                          
#          DECLARE azf_c2  CURSOR FOR azf_prepare2                                                                                 
#          OPEN azf_c2                                                                                    
#          FETCH azf_c2 INTO l_azf03                    
#          IF SQLCA.sqlcode THEN
#             LET l_azf03 = ' '
#          END IF                
#       END IF
#      IF tm.a = 'Y' THEN     
          LET l_sql = "SELECT gem02 ",                                                                              
                      "  FROM gem_file",
                      " WHERE gem01='",sr.tlf19,"'"                                                                                                                                                                                
          PREPARE gem_prepare2 FROM l_sql                                                                                          
          DECLARE gem_c2  CURSOR FOR gem_prepare2                                                                                 
          OPEN gem_c2                                                                                    
          FETCH gem_c2 INTO l_gem02
         IF SQLCA.sqlcode THEN 
            LET l_gem02 = NULL
         END IF  
#      END IF
       LET l_tlf14 = sr.tlf14[1,4] 
       LET l_tlf19 = sr.tlf19[1,6]
       
       LET g_tlf[g_cnt].tlf14 = l_tlf14
       LET g_tlf[g_cnt].tlf19 = l_tlf19
       LET g_tlf[g_cnt].gem02 = l_gem02
       IF sr.tlf907 = -1 THEN
          LET g_tlf[g_cnt].tlf021 = sr.tlf021
       ELSE
       	  LET g_tlf[g_cnt].tlf021 = sr.tlf031
       END IF	    
       LET g_tlf[g_cnt].tlf06 = sr.tlf06
       IF sr.tlf907 = -1 THEN
          LET g_tlf[g_cnt].tlf026 = sr.tlf026
       ELSE
       	  LET g_tlf[g_cnt].tlf026 = sr.tlf036
       END IF            
       LET g_tlf[g_cnt].tlf01 = sr.tlf01
       LET g_tlf[g_cnt].ima02 = sr.ima02
       LET g_tlf[g_cnt].ima021 = sr.ima021
       LET g_tlf[g_cnt].tlf10 = sr.tlf01
       LET g_tlf[g_cnt].tlfccost = sr.tlfccost
       LET g_tlf[g_cnt].tlf10 = sr.tlf10       
       LET g_tlf[g_cnt].ccc23a = sr.l_ccc23a
       LET g_tlf[g_cnt].ccc23b = sr.l_ccc23b
       LET g_tlf[g_cnt].ccc23c = sr.l_ccc23c
       LET g_tlf[g_cnt].ccc23d = sr.l_ccc23d
       LET g_tlf[g_cnt].ccc23e = sr.l_ccc23e
       LET g_tlf[g_cnt].ccc23f = sr.l_ccc23f
       LET g_tlf[g_cnt].ccc23g = sr.l_ccc23g
       LET g_tlf[g_cnt].ccc23h = sr.l_ccc23h
       LET g_tlf[g_cnt].ccc23a2 = sr.l_tot

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	        EXIT FOREACH
       END IF       
     END FOREACH
     
   CALL g_tlf.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q770_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
