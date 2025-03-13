# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aimq997.4gl
# Descriptions...: 
# Date & Author..: 10/05/24 By xiaofeizhu #No.FUN-AA0025
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.TQC-BB0133 11/12/26 By destiny  金额显示有问题                        
# Modify.........: No.TQC-D60031 13/06/06 By wangrr 欄位"倉庫編號""盤點編號"增加開窗
 
DATABASE ds
#No.FUN-AA0025
GLOBALS "../../config/top.global"
 
DEFINE
   g_pia02        LIKE pia_file.pia02, 
   g_tlf DYNAMIC ARRAY OF RECORD
         ccc02    LIKE ccc_file.ccc02,  #TQC-BB0133
         ccc03    LIKE ccc_file.ccc03,  #TQC-BB0133
         ccc07    LIKE ccc_file.ccc07,  #TQC-BB0133
         pia02    LIKE pia_file.pia02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ccc08    LIKE ccc_file.ccc08,
         pia03    LIKE pia_file.pia03, 
         pia04    LIKE pia_file.pia04, 
         pia05    LIKE pia_file.pia05,
         img09    LIKE img_file.img09,
         pia08    LIKE pia_file.pia08,
         pia08_c  LIKE ccc_file.ccc23,                                          
         pia01    LIKE pia_file.pia01,
         pia30    LIKE pia_file.pia30,
         pia30_c  LIKE ccc_file.ccc23,
         diff     LIKE pia_file.pia30,
         diff_c   LIKE ccc_file.ccc23,
         ccc23    LIKE ccc_file.ccc23                                        
             END RECORD,
   g_tlf_t       RECORD         
         ccc02    LIKE ccc_file.ccc02,  #TQC-BB0133
         ccc03    LIKE ccc_file.ccc03,  #TQC-BB0133
         ccc07    LIKE ccc_file.ccc07,  #TQC-BB0133   
         pia02    LIKE pia_file.pia02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ccc08    LIKE ccc_file.ccc08,
         pia03    LIKE pia_file.pia03, 
         pia04    LIKE pia_file.pia04, 
         pia05    LIKE pia_file.pia05,
         img09    LIKE img_file.img09,
         pia08    LIKE pia_file.pia08,
         pia08_c  LIKE ccc_file.ccc23,                                          
         pia01    LIKE pia_file.pia01,
         pia30    LIKE pia_file.pia30,
         pia30_c  LIKE ccc_file.ccc23,
         diff     LIKE pia_file.pia30,
         diff_c   LIKE ccc_file.ccc23,
         ccc23    LIKE ccc_file.ccc23 
             END RECORD,
   g_argv1       LIKE pia_file.pia02,
   g_argv2       LIKE cdj_file.cdj02,
   g_argv3       LIKE cdj_file.cdj03,   
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
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('aimq997',g_time,1) RETURNING g_time   #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   LET g_argv1   = ARG_VAL(1)
   LET g_argv2   = ARG_VAL(2)
   LET g_argv3   = ARG_VAL(3)            
   LET g_pia02   = NULL                  
   LET g_pia02   = g_argv1
   
   OPEN WINDOW q997_w WITH FORM "aim/42f/aimq997"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
      CALL q997_q()
   END IF
   CALL q997_menu()
   CLOSE WINDOW q997_w                

   #CALL cl_used('aimq997',g_time,2) RETURNING g_time  #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION q997_curs()
   CLEAR FORM                            
   CALL g_tlf.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")          
   INITIALIZE g_pia02 TO NULL 
           
     CONSTRUCT BY NAME g_wc ON ccc02,ccc03,ccc07,pia02,pia03,pia04,pia05,pia01

     BEFORE CONSTRUCT
       CALL cl_qbe_init()

     ON ACTION controlp                                                      
        IF INFIELD(pia02) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO pia02                             
           NEXT FIELD pia02                                                 
        END IF
        #TQC-D60031--add--str--
        IF INFIELD(pia03) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_pia03"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pia03
           NEXT FIELD pia03
        END IF
        IF INFIELD(pia01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_pia01_1"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO pia01
           NEXT FIELD pia01
        END IF
        #TQC-D60031--add--end
 
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
      LET g_wc = " pia02 = '",g_argv1,"' AND ccc02= '",g_argv2,"' AND ccc03= '",g_argv3,"' "
   END IF

END FUNCTION
 
FUNCTION q997_menu()
   WHILE TRUE
      CALL q997_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q997_q()
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
 
FUNCTION q997_q()

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q997_curs()                      
   IF INT_FLAG THEN                       
      LET INT_FLAG = 0
      INITIALIZE g_pia02 TO NULL
      RETURN
   END IF
 
   CALL q997_show()               

END FUNCTION
 
FUNCTION q997_show()          
   CALL q997_b_fill(g_wc)                
 
END FUNCTION
 
FUNCTION q997_b_fill(p_wc)               
DEFINE   p_wc        STRING,
         l_sql       STRING      
         
DEFINE      sr   RECORD
#	   		         order1 LIKE ima_file.ima01, #TQC-BB0133
#			           order2 LIKE ima_file.ima01, #TQC-BB0133
#			           order3 LIKE ima_file.ima01, #TQC-BB0133
			           ccc02  LIKE ccc_file.ccc02,  #TQC-BB0133
                 ccc03  LIKE ccc_file.ccc03,  #TQC-BB0133
                 ccc07  LIKE ccc_file.ccc07,  #TQC-BB0133
                 pia01  LIKE pia_file.pia01, 
                 pia02  LIKE pia_file.pia02, 
                 pia03  LIKE pia_file.pia03, 
                 pia04  LIKE pia_file.pia04, 
                 pia05  LIKE pia_file.pia05, 
                 pia08  LIKE pia_file.pia08, 
                 pia09  LIKE pia_file.pia09, 
                 pia30  LIKE pia_file.pia30, 
                 pia50  LIKE pia_file.pia50,
                 ima12  LIKE ima_file.ima12 ,
                 azf03  LIKE azf_file.azf03 ,
                 img09  LIKE img_file.img09, 
                 pia08_c LIKE ccc_file.ccc23,
                 pia30_c LIKE ccc_file.ccc23,
                 diff    LIKE pia_file.pia30,
                 diff_c  LIKE ccc_file.ccc23,
                 ccc23   LIKE ccc_file.ccc23,
                 ccc08   LIKE ccc_file.ccc08 
             END RECORD
  DEFINE l_ima02    LIKE ima_file.ima02      
  DEFINE l_ima021   LIKE ima_file.ima021     
  DEFINE l_i        LIKE type_file.num5                 
  DEFINE l_dbs      LIKE azp_file.azp03                 
  DEFINE l_azp03    LIKE azp_file.azp03                 
  DEFINE i          LIKE type_file.num5                 
  DEFINE l_pia40    LIKE pia_file.pia40        
  DEFINE l_pia60    LIKE pia_file.pia60
  DEFINE l_yy1      LIKE type_file.num5
  DEFINE l_mm1      LIKE type_file.num5        
  DEFINE l_str      STRING                     
  DEFINE l_str1     STRING                     
  DEFINE l_str2     STRING                    

      #TQC-BB0133--begin
#     LET l_sql = "SELECT '','','',",
#                 "pia01,pia02,pia03,pia04,pia05,pia08,pia09,pia30,pia50, ",
#                 "ima12,'',img09,pia08*ccc23,pia30*ccc23,pia30-pia08, ",
#                 "(pia30-pia08)*ccc23,ccc23 ",
#                 ",ccc08 ",  
#                 ",pia40,pia60",   
#                 "  FROM pia_file,ima_file,img_file,ccc_file "
#     LET l_str1 = " WHERE pia02=ima01 ",   
#                  "   AND pia02=ccc01 ",
#                  "   AND img01=pia02 ",
#                  "   AND img02=pia03 ",
#                  "   AND img03=pia04 ",
#                  "   AND img04=pia05 ",
##                 "   AND azf_file.azf01=ima12 ",
##                 "   AND azf_file.azf02='G'   ",   
#                  "   AND pia03 NOT IN (SELECT jce02 FROM jce_file)"
##                 "   AND ccc02= ",l_yy1,
##                 "   AND ccc00= '",g_aaa01 CLIPPED,"'",
##                 "   AND ccc07='",tm.ctype,"'",         
##                 "   AND ccc03= ",l_mm1
##     IF tm.ctype = '5' THEN
##         LET l_str  = ",", cl_get_target_table(m_dbs[l_i], 'imd_file')
##     ELSE
##        LET l_str = ''
##     END IF
##     CASE tm.ctype
##       WHEN '3'
##          LET l_str2 = " AND img04 = ccc08 "
##       WHEN '5'
##          LET l_str2 = " AND img02 = imd01 AND imd09=ccc08"
##       OTHERWISE
##          LET l_str2 = ''
##     END CASE
#     LET l_sql = l_sql,l_str,l_str1,l_str2
##     DISPLAY "l_sql:",l_sql
##     CASE WHEN tm.f = '1' LET l_sql = l_sql CLIPPED," AND pia19='Y' "
##          WHEN tm.f = '2' LET l_sql = l_sql CLIPPED," AND pia19<>'Y' "
##     END CASE
#     LET l_sql = l_sql CLIPPED," AND ",p_wc CLIPPED
#     CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   
  
     LET l_sql = "SELECT ccc02,ccc03,ccc07,",
                 "pia01,pia02,pia03,pia04,pia05,pia08,pia09,pia30,pia50, ",
                 "ima12,'',img09,pia08*ccc23,pia30*ccc23,pia30-pia08, ",
                 "(pia30-pia08)*ccc23,ccc23,",
                 " ccc08,pia40,pia60 ",   
                 "  FROM pia_file LEFT OUTER JOIN img_file ON img01=pia02 AND img02=pia03 AND img03=pia04 AND img04=pia05 ",
                 " ,ima_file,ccc_file ",
                 " WHERE pia02=ima01 ",   
                 "   AND pia02=ccc01 ",
                 "   AND pia19='Y' ",
                 "   AND pia03 NOT IN (SELECT jce02 FROM jce_file) "
     LET l_sql = l_sql CLIPPED," AND ",p_wc CLIPPED     
     LET l_sql = l_sql CLIPPED," ORDER BY ccc02,ccc03,ccc07,pia01 "
     #TQC-BB0133--end
     PREPARE q997_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE q997_curs1 CURSOR FOR q997_prepare1

    CALL g_tlf.clear()
    LET g_cnt = 1

     FOREACH q997_curs1 INTO sr.*,l_pia40,l_pia60  
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.pia30 IS NULL THEN LET sr.pia30=0 END IF
       IF not cl_null(l_pia60)  THEN
          LET sr.pia30 = l_pia60
       ELSE
          IF NOT cl_null(sr.pia50) THEN
             LET sr.pia30=sr.pia50
          ELSE
             IF NOT cl_null(l_pia40) THEN
                LET sr.pia30 = l_pia40
             END IF
          END IF
       END IF
       LET sr.pia08_c = sr.pia08*sr.ccc23
       LET sr.pia30_c = sr.pia30*sr.ccc23
       LET sr.diff    = sr.pia30-sr.pia08
       LET sr.diff_c  = sr.diff*sr.ccc23
#      IF tm.d='N' AND sr.pia08=sr.pia30 THEN CONTINUE FOREACH END IF
#      IF tm.e='1' AND sr.pia08>sr.pia30 THEN CONTINUE FOREACH END IF
#      IF tm.e='2' AND sr.pia08<sr.pia30 THEN CONTINUE FOREACH END IF

  IF sr.pia08    IS NULL THEN LET sr.pia08 = 0 END IF
  IF sr.pia30    IS NULL THEN LET sr.pia30 = 0 END IF
  IF sr.pia08_c  IS NULL THEN LET sr.pia08_c = 0 END IF
  IF sr.pia30_c  IS NULL THEN LET sr.pia30_c = 0 END IF
  IF sr.diff     IS NULL THEN LET sr.diff  = 0 END IF
  IF sr.diff_c   IS NULL THEN LET sr.diff_c= 0 END IF
  IF sr.ccc23    IS NULL THEN LET sr.ccc23 = 0 END IF

     LET l_sql = "SELECT ima02,ima021 ",
                 "  FROM ima_file",
                 " WHERE ima01 = '",sr.pia02,"'"
     PREPARE ima_prepare2 FROM l_sql                                                                                         
     DECLARE ima_c2  CURSOR FOR ima_prepare2                                                                               
     OPEN ima_c2                                                                                                             
     FETCH ima_c2 INTO l_ima02,l_ima021
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
      
       LET g_tlf[g_cnt].ccc02 = sr.ccc02    #TQC-BB0133
       LET g_tlf[g_cnt].ccc03 = sr.ccc03    #TQC-BB0133
       LET g_tlf[g_cnt].ccc07 = sr.ccc07    #TQC-BB0133
       LET g_tlf[g_cnt].pia02 = sr.pia02
       LET g_tlf[g_cnt].ima02 = l_ima02
       LET g_tlf[g_cnt].ima021 = l_ima021       
       LET g_tlf[g_cnt].ccc08 = sr.ccc08
       LET g_tlf[g_cnt].pia03 = sr.pia03
       LET g_tlf[g_cnt].pia04 = sr.pia04
       LET g_tlf[g_cnt].pia05 = sr.pia05
       LET g_tlf[g_cnt].img09 = sr.img09
       LET g_tlf[g_cnt].pia08 = sr.pia08
       #LET g_tlf[g_cnt].pia08 = sr.pia08_c   #TQC-BB0133
       LET g_tlf[g_cnt].pia08_c = sr.pia08_c  #TQC-BB0133
       LET g_tlf[g_cnt].pia01 = sr.pia01
       LET g_tlf[g_cnt].pia30 = sr.pia30
       #LET g_tlf[g_cnt].pia30 = sr.pia30_c   #TQC-BB0133
       LET g_tlf[g_cnt].pia30_c = sr.pia30_c  #TQC-BB0133
       LET g_tlf[g_cnt].diff = sr.diff
       LET g_tlf[g_cnt].diff_c = sr.diff_c
       LET g_tlf[g_cnt].ccc23 = sr.ccc23       

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
 
FUNCTION q997_bp(p_ud)
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
 
