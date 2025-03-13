# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcq760.4gl
# Descriptions...: 
# Date & Author..: 10/05/24 By xiaofeizhu #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-BB0038 11/11/30 By elva 成本改善
# Modify.........: No:MOD-C70126 12/07/10 By yinhy 排除oga65='Y'的的單據
# Modify.........: No:MOD-C70127 12/07/10 By yinhy 制費三取值錯誤
# Modify.........: No:FUN-C80009 12/08/06 By elva 增加开票单来源
# Modify.........: No:TQC-C80050 12/08/07 By elva 语法错误
 
DATABASE ds

#No.FUN-AA0025
GLOBALS "../../config/top.global"
 
DEFINE
   g_tlf01        LIKE tlf_file.tlf01, 
   g_tlf DYNAMIC ARRAY OF RECORD          
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlfccost   LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt_d    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222                       
             END RECORD,
   g_tlf_t       RECORD                  
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlfccost   LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt_d    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222
             END RECORD,
   g_argv1       LIKE tlf_file.tlf01,
   g_argv2       LIKE cdj_file.cdj02,
   g_argv3       LIKE cdj_file.cdj03,
   g_argv4       LIKE cdj_file.cdj14, #FUN-BB0038
   g_argv5       LIKE cdj_file.cdj15, #FUN-BB0038
   g_argv6       LIKE cdj_file.cdj142, #FUN-BB0038
   g_argv7       LIKE type_file.chr1, #FUN-BB0038
   g_argv8       LIKE cdj_file.cdj07, #FUN-C80009
   g_wc,g_sql,g_wc1    STRING,     #FUN-C80009
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
 
#  CALL cl_used('axcq760',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

   LET g_argv1   = ARG_VAL(1)
   LET g_argv2   = ARG_VAL(2)
   LET g_argv3   = ARG_VAL(3)               
   LET g_argv4   = ARG_VAL(4)  #FUN-BB0038              
   LET g_argv5   = ARG_VAL(5)  #FUN-BB0038  
   LET g_argv6   = ARG_VAL(6)  #FUN-BB0038  
   LET g_argv7   = ARG_VAL(7)  #FUN-BB0038  
   LET g_argv8   = ARG_VAL(8)  #FUN-C80009  
   LET g_tlf01   = NULL                  
   LET g_tlf01   = g_argv1
   
   OPEN WINDOW q760_w WITH FORM "axc/42f/axcq760"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_set_comp_visible("tlf62,ima021,",FALSE)
  
   IF NOT cl_null(g_argv1) THEN
      CALL q760_q()
   END IF
   CALL q760_menu()
   CLOSE WINDOW q760_w                

#  CALL cl_used('axcq760',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION q760_curs()
   CLEAR FORM                            
   CALL g_tlf.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")          
   INITIALIZE g_tlf01 TO NULL 
           
     CONSTRUCT BY NAME g_wc ON tlf021,tlf06,tlf026,tlf01

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
      #FUN-BB0038 --begin
     #LET g_wc = " tlf01 = '",g_argv1,"' AND YEAR(tlf06) = '",g_argv2,"' AND MONTH(tlf06) = '",g_argv3,"'"  #FUN-BB0038
      LET g_wc = " tlf01 = '",g_argv1,"' AND YEAR(tlf06) = '",g_argv2,"' AND MONTH(tlf06) = '",g_argv3,"' AND tlf19='",g_argv4,"' AND oga15='",g_argv5,
                 "' AND oga032='",g_argv6,"'"  
      #FUN-C80009 --begin
      IF NOT cl_null(g_argv8) THEN
         LET g_wc = g_wc," AND tlf14='",g_argv8,"'"
      ELSE
         LET g_wc = g_wc," AND (tlf14 is NULL OR tlf14=' ')"
      END IF
    # IF g_argv7 = '2' THEN  
       # LET g_wc1 = cl_replace_str(g_wc,"oga15","oha15")
       # LET g_wc1 = cl_replace_str(g_wc1,"oga032","oha032")
    # END IF  
      #FUN-C80009 --end
      #FUN-BB0038 --end
   END IF
   #FUN-C80009 --begin
   LET g_wc1 = cl_replace_str(g_wc,"oga15","oha15")
   LET g_wc1 = cl_replace_str(g_wc1,"oga032","oha032")
   #FUN-C80009 --end

END FUNCTION

 
FUNCTION q760_menu()
   WHILE TRUE
      CALL q760_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q760_q()
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
 
FUNCTION q760_q()

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q760_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
      INITIALIZE g_tlf01 TO NULL
      RETURN
   END IF
 
   CALL q760_show()               

END FUNCTION
 
FUNCTION q760_show()          
   CALL q760_b_fill(g_wc)                
 
END FUNCTION
 
FUNCTION q760_b_fill(p_wc)               
DEFINE   p_wc        STRING,
         l_sql       STRING      
         
DEFINE  sr  RECORD
        ima12  LIKE ima_file.ima12,
        ima01  LIKE ima_file.ima01,
        ima02  LIKE ima_file.ima02,
        ima06  LIKE ima_file.ima06,
        tlfccost LIKE tlfc_file.tlfccost,   
        tlf02  LIKE tlf_file.tlf02,
        tlf021 LIKE tlf_file.tlf021,
        tlf03  LIKE tlf_file.tlf03,
        tlf031 LIKE tlf_file.tlf031,
        tlf06  LIKE tlf_file.tlf06,
        tlf026 LIKE tlf_file.tlf026,
        tlf027 LIKE tlf_file.tlf027,
        tlf036 LIKE tlf_file.tlf036,
        tlf037 LIKE tlf_file.tlf037,
        tlf01  LIKE tlf_file.tlf01,
        tlf10  LIKE tlf_file.tlf10,
        tlfc21 LIKE tlfc_file.tlfc21,      
        tlf13  LIKE tlf_file.tlf13,
        tlf905 LIKE tlf_file.tlf905,
        tlf906 LIKE tlf_file.tlf906,
        tlf19  LIKE tlf_file.tlf19 ,
        tlf907 LIKE tlf_file.tlf907,
        amt01  LIKE tlfc_file.tlfc221,    
        amt02  LIKE tlfc_file.tlfc222,    
        amt03  LIKE tlfc_file.tlfc2231,   
        amt_d  LIKE tlfc_file.tlfc2232,   
        amt05  LIKE tlfc_file.tlfc224,    
        amt06  LIKE tlfc_file.tlfc2241,   
        amt07  LIKE tlfc_file.tlfc2242,   
        amt08  LIKE tlfc_file.tlfc2243,   
        amt04  LIKE ccc_file.ccc23,   
        wsaleamt  LIKE omb_file.omb16 
        END RECORD
   DEFINE   wtlf01  LIKE type_file.chr3   
   DEFINE l_tlf905 LIKE tlf_file.tlf905      
   DEFINE l_tlf906 LIKE tlf_file.tlf906      
   DEFINE l_azf03       LIKE azf_file.azf03
   DEFINE wocc02        LIKE occ_file.occ02   
   DEFINE wticket       LIKE oma_file.oma33  
   DEFINE wima202       LIKE ima_file.ima131
   DEFINE l_wima201     LIKE tlf_file.tlf01
   DEFINE l_wsale_tlf21 LIKE tlf_file.tlf21
   DEFINE l_tlf14    LIKE tlf_file.tlf14     
   DEFINE l_oga00       LIKE oga_file.oga00    
   DEFINE l_oga65       LIKE oga_file.oga65   #MOD-C70126
   DEFINE l_azf08    LIKE azf_file.azf08
                        
   #FUN-BB0038 --begin
   #FUN-C80009  --begin
   IF cl_null(g_wc1) THEN LET g_wc1 = ' 1=1'  END IF  #TQC-C80050
   SELECT oaz02 INTO g_oaz.oaz92 FROM oaz_file
#  IF g_argv7 = '1' THEN
     LET l_sql = "SELECT ima12,ima01,ima02,ima06,tlfccost,",   
                 " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                 " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                 " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08",
                 "  FROM ima_file,oga_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                 " WHERE ima01 = tlf01 AND tlf905=oga01 ", 
                #" AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%')",   #FUN-BB0038       
                 " AND (tlf13 LIKE 'axmt6%')",  #FUN-BB0038        
                 " AND tlf13 <> 'axmt670' ", #FUN-C80009
                 " AND ",p_wc CLIPPED,
                 " and tlf902 not in (select jce02 from jce_file)" 
               # " ORDER BY ima01,tlf905,tlf906 "             
  IF g_oaz.oaz92 = 'Y' THEN
     LET l_sql = l_sql CLIPPED," UNION ",
                 " SELECT ima12,ima01,ima02,ima06,tlfccost,",   
                 " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                 " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                 " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08",
                 "  FROM ima_file,omf_file,oga_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                 " WHERE ima01 = tlf01 AND tlf905=omf00 AND tlf906=omf21", 
                 " AND tlf13 = 'axmt670' ", 
                 " AND omf10 = '1' ",
                 " AND omf11 = oga01 ",
                 " AND ",p_wc CLIPPED,
                 " and tlf902 not in (select jce02 from jce_file)" 
             #   " ORDER BY ima01,tlf905,tlf906 "             
  END IF
#  ELSE
     LET l_sql = l_sql CLIPPED," UNION ",
                 " SELECT ima12,ima01,ima02,ima06,tlfccost,",   
                 " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                 " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                 " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08",
                 "  FROM ima_file,oha_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                 " WHERE ima01 = tlf01 AND tlf905=oha01 ", 
                #" AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%')",   #FUN-BB0038       
                 " AND (tlf13 ='aomt800')",  #FUN-BB0038        
                 " AND ",g_wc1 CLIPPED,
                 " and tlf902 not in (select jce02 from jce_file)" 
            #    " ORDER BY ima01,tlf905,tlf906 "             
  IF g_oaz.oaz92 = 'Y' THEN
     LET l_sql = l_sql CLIPPED," UNION ",
                 " SELECT ima12,ima01,ima02,ima06,tlfccost,",   
                 " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf027,", 
                 " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
                 " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08",
                 "  FROM ima_file,oha_file,omf_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",
                 " WHERE ima01 = tlf01 AND tlf905=omf00 AND tlf906=omf21 ", 
                 " AND tlf13 = 'axmt670' ", 
                 " AND omf10 = '2' ",
                 " AND omf11 = oha01 ",
                 " AND ",g_wc1 CLIPPED,
                 " and tlf902 not in (select jce02 from jce_file)",
                 " ORDER BY ima01,tlf905,tlf906 "             
  END IF
#  END IF
   #FUN-BB0038 --end
   #FUN-C80009  --end
     PREPARE axcq760_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE axcq760_curs1 CURSOR FOR axcq760_prepare1

     CALL g_tlf.clear()
     LET g_cnt = 1

     FOREACH axcq760_curs1 INTO sr.*,l_tlf14,l_azf08  
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

       LET l_oga00 = NULL
       LET l_oga65 = NULL   #MOD-C70126
       IF sr.tlf13 MATCHES 'axmt*' THEN
          SELECT oga00,oga65 INTO l_oga00,l_oga65 FROM oga_file WHERE oga01=sr.tlf905  #MOD-C70126 add oga65
          IF l_oga00 = '3' OR l_oga00 ='A' OR l_oga00='7' OR l_oga65='Y' THEN          #MOD-C70126 add oga65
             CONTINUE FOREACH
          END IF
       END IF

#       IF cl_null(l_azf08) THEN LET l_azf08='N' END IF
#       IF tm.b='N' THEN
#          IF l_azf08='Y' THEN CONTINUE FOREACH END IF
#       ELSE
#          IF l_azf08='N' THEN CONTINUE FOREACH END IF
#       END IF
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
       IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
       IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
       IF  cl_null(sr.tlfc21) THEN LET sr.tlfc21=0 END IF  
       IF  cl_null(sr.amt_d)  THEN LET sr.amt_d=0 END IF
       IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
       IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF  
       IF  cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF   
       IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF   
       IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF
       IF sr.tlf907 = 1 THEN
          LET sr.tlf02  = sr.tlf03
          LET sr.tlf021 = sr.tlf031
          LET sr.tlf026 = sr.tlf036
       ELSE
          LET sr.tlf10= sr.tlf10 * -1
          LET sr.amt01= sr.amt01 * -1
          LET sr.amt02= sr.amt02 * -1
          LET sr.amt03= sr.amt03 * -1
          LET sr.amt_d= sr.amt_d * -1
          LET sr.amt05= sr.amt05 * -1   
          #LET sr.amt06= sr.amt07 * -1    #MOD-C70127 mark
          LET sr.amt06= sr.amt06 * -1     #MOD-C70127
          LET sr.amt07= sr.amt07 * -1   
          LET sr.amt08= sr.amt08 * -1   
       END IF
       LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt_d + sr.amt05  
       IF  cl_null(sr.amt04)  THEN LET sr.amt01=0 END IF
#       LET sr.wsaleamt = 0

#     IF (sr.tlf905 <> l_tlf905 OR sr.tlf906 <> l_tlf906) THEN
#        SELECT SUM(omb16) INTO sr.wsaleamt FROM oma_file,omb_file
#          WHERE omb31 = sr.tlf905 AND omb32 = sr.tlf906
#            AND oma01=omb01 AND oma02 BETWEEN tm.bdate AND tm.edate
#            AND omavoid<>'Y'
#         LET l_tlf905 = sr.tlf905    
#         LET l_tlf906 = sr.tlf906    
#      END IF                         
# 
#     IF  cl_null(sr.wsaleamt)  THEN LET sr.wsaleamt=0 END IF

       LET g_tlf[g_cnt].tlf021 = sr.tlf021
       LET g_tlf[g_cnt].tlf06 = sr.tlf06
       LET g_tlf[g_cnt].tlf026 = sr.tlf026
#      LET g_tlf[g_cnt].tlf62 = sr.tlf62       
       LET g_tlf[g_cnt].tlf01 = sr.tlf01
       LET g_tlf[g_cnt].ima02 = sr.ima02
#      LET g_tlf[g_cnt].ima021 = sr.ima021
       LET g_tlf[g_cnt].tlfccost = sr.tlfccost
       LET g_tlf[g_cnt].tlf10 = sr.tlf10
       LET g_tlf[g_cnt].amt01 = sr.amt01
       LET g_tlf[g_cnt].amt02 = sr.amt02
       LET g_tlf[g_cnt].amt03 = sr.amt03
       LET g_tlf[g_cnt].amt04 = sr.amt04
       LET g_tlf[g_cnt].amt05 = sr.amt05
       LET g_tlf[g_cnt].amt06 = sr.amt06
       LET g_tlf[g_cnt].amt07 = sr.amt07
       LET g_tlf[g_cnt].amt08 = sr.amt08
       LET g_tlf[g_cnt].amt_d = sr.amt_d

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
 
FUNCTION q760_bp(p_ud)
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
 
    # ON ACTION about      
    #    CALL cl_about()  
   
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")       
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
