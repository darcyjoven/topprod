# Prog. Version..: '5.30.08-13.07.05(00000)'     #
# Pattern name...: axcp800.4gl
# Descriptions...: 移動加權平均成本法結轉作業 
# Date & Author..: NO.FUN-BC0062 12/03/15 BY lilingyu
# Modify.........: No.TQC-D40037 13/04/17 By fengrui 抓取結存時應抓取最後一筆數據
# Modify.........: No.FUN-D60090 13/06/19 By fengrui 結存數量抓取不到時進行預設
# Modify.........: No.FUN-D60091 13/06/20 By lixh1 FUN-BC0062規格調整
# Modify.........: No.TQC-D80002 13/08/01 By lixh1 ccc214/ccc224欄位的值不需要給默認值0,其值在程式中有計算

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_change_lang  LIKE type_file.chr1     
DEFINE g_yy           LIKE type_file.num5
DEFINE g_mm           LIKE type_file.num5
DEFINE g_ccc          RECORD LIKE ccc_file.*
 
MAIN
DEFINE l_flag         LIKE type_file.num5 
 
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
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   IF cl_null(g_bgjob) THEN 
      LET g_bgjob = 'N' 
   END IF
   
   WHILE TRUE
      IF g_ccz.ccz28 != '6' THEN
          CALL cl_err('','axc-027',1)
          EXIT WHILE
       END IF
   
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p800_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'   
            BEGIN WORK
            CALL p800_process()     
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p800_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK    
         CALL p800_process()                 
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p800_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5    
   DEFINE  lc_cmd         LIKE type_file.chr1000
                
   LET p_row = 4 
   LET p_col = 26
    
   OPEN WINDOW p800_w AT p_row,p_col WITH FORM "axc/42f/axcp800" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
  
      LET g_bgjob = 'N'   
      LET g_yy   = g_ccz.ccz01
      LET g_mm   = g_ccz.ccz02
      DISPLAY g_bgjob TO g_bgjob
      DISPLAY g_yy   TO yy
      DISPLAY g_mm   TO mm

      INPUT g_yy,g_mm,g_bgjob WITHOUT DEFAULTS FROM yy,mm,g_bgjob  
 
        BEFORE INPUT
           CALL cl_qbe_init()
            
         AFTER FIELD yy
           IF cl_null(g_yy) OR g_yy<0 OR LENGTH(g_yy) != 4 THEN 
              NEXT FIELD CURRENT 
           ELSE 
              IF g_yy < g_sma.sma51 THEN 
                 CALL cl_err('','axc-196',0)
                 NEXT FIELD CURRENT 
              END IF    
           END IF 
 
         AFTER FIELD mm
           IF cl_null(g_mm) THEN  
              NEXT FIELD CURRENT 
           ELSE
              SELECT azm02 INTO g_azm.azm02 FROM azm_file
               WHERE azm01 = g_yy
              IF g_azm.azm02 = 1 THEN 
                IF g_mm > 12 OR g_mm < 1 THEN 
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD CURRENT 
                END IF 
              ELSE 
              	 IF g_mm > 13 OR g_mm < 1 THEN 
                   CALL cl_err('','agl-020',0)
                   NEXT FIELD CURRENT 
              	 END IF 
              END IF   
              
              IF g_yy=g_sma.sma51 AND g_mm<g_sma.sma52 THEN 
                 CALL cl_err('','axc-196',0)
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
 
         ON ACTION exit                         
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axcp800"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('axcp800','9031',1)  
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp800',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p800_process()
DEFINE  l_sql            STRING
DEFINE  l_cfa01          LIKE cfa_file.cfa01
DEFINE  l_count          LIKE type_file.num5

   INITIALIZE g_ccc.* TO NULL 
 
   DECLARE p800_curs CURSOR FOR 
     SELECT DISTINCT cfa01 FROM cfa_file 
      WHERE YEAR(cfa18) = g_yy
        AND MONTH(cfa18)= g_mm
   FOREACH p800_curs INTO l_cfa01     
     IF STATUS THEN 
        CALL cl_err('',STATUS,1)
        LET g_success = 'N'
        EXIT FOREACH 
     END IF 
     
     INITIALIZE g_ccc.* TO NULL    #FUN-D60091
     LET g_ccc.ccc01    = l_cfa01  #料號
     LET g_ccc.ccc02    = g_yy     #年度 
     LET g_ccc.ccc03    = g_mm     #月份
                     
     IF g_azm.azm02 = 1 THEN   #12
        IF g_mm =1 THEN 
           #TQC-D40037--modify--str--
      	   #SELECT SUM(cfa10),SUM(cfa11) INTO g_ccc.ccc11,g_ccc.ccc12 FROM cfa_file 
      	   # WHERE cfa01 = g_ccc.ccc01
           #   AND YEAR(cfa18) = g_yy - 1 
           #   AND MONTH(cfa18)= 12           
           SELECT cfa10,cfa11 INTO g_ccc.ccc11,g_ccc.ccc12 FROM
                 (SELECT cfa_file.* FROM cfa_file
                   WHERE cfa01 = g_ccc.ccc01
                     AND YEAR(cfa18) = g_yy - 1
                     AND MONTH(cfa18)= 12
                   ORDER BY cfa02 desc,cfa18 desc)  
            WHERE rownum = 1 
           #TQC-D40037--modify--end--
        #FUN-D60091 ------Begin------
           IF SQLCA.sqlcode = 100 THEN
              SELECT cca11,cca12 INTO g_ccc.ccc11,g_ccc.ccc12 FROM cca_file 
               WHERE cca01 = g_ccc.ccc01
                 AND cca02 = g_yy-1
                 AND cca03 = 12
                 AND cca06 = '6'
                 AND cca07 = ' '
           END IF
        #FUN-D60091 ------End--------
        ELSE 
           #TQC-D40037--modify--str--
      	   #SELECT SUM(cfa10),SUM(cfa11) INTO g_ccc.ccc11,g_ccc.ccc12 FROM cfa_file 
      	   # WHERE cfa01 = g_ccc.ccc01
           #   AND YEAR(cfa18) = g_yy
           #   AND MONTH(cfa18)= g_mm - 1
       #FUN-D60091 ------Begin-------
         # SELECT cfa10,cfa11 INTO g_ccc.ccc11,g_ccc.ccc12 FROM
         #       (SELECT rownum rn,cfa_file.* FROM cfa_file
         #         WHERE cfa01 = g_ccc.ccc01
         #           AND YEAR(cfa18) = g_yy
         #           AND MONTH(cfa18)= g_mm - 1
         #         ORDER BY cfa02,cfa18) 
         #  WHERE rn =(SELECT COUNT(*) FROM cfa_file WHERE cfa01 = g_ccc.ccc01
         #                                             AND YEAR(cfa18) = g_yy AND MONTH(cfa18)= g_mm-1 )
            SELECT cfa10,cfa11 INTO g_ccc.ccc11,g_ccc.ccc12 FROM
                   (SELECT cfa_file.* FROM cfa_file
                     WHERE cfa01 = g_ccc.ccc01
                       AND YEAR(cfa18) = g_yy
                       AND MONTH(cfa18)= g_mm - 1
                       ORDER BY cfa02 desc,cfa18 desc)
            WHERE rownum = 1  
       #FUN-D60091 ------End----------
           #TQC-D40037--modify--end--
        #FUN-D60091 --------Begin--------
           IF SQLCA.sqlcode = 100 THEN
              SELECT cca11,cca12 INTO g_ccc.ccc11,g_ccc.ccc12 FROM cca_file 
               WHERE cca01 = g_ccc.ccc01
                 AND cca02 = g_yy
                 AND cca03 = g_mm-1 
                 AND cca06 = '6'
                 AND cca07 = ' '
           END IF
        #FUN-D60091 --------End----------
      	END IF 
       #FUN-D60091 ------------Begin---------
       #IF cl_null(g_ccc.ccc11) THEN 
       #   SELECT cfa10 INTO g_ccc.ccc11 FROM
       #         (SELECT rownum rn,cfa_file.* FROM cfa_file
       #           WHERE cfa01 = g_ccc.ccc01 
       #             AND (( YEAR(cfa18)= g_yy AND MONTH(cfa18)<= g_mm-1 )  #TQC-D40037 add
       #                 OR YEAR(cfa18)< g_yy )                            #TQC-D40037 add
       #         # ORDER BY cfa03,cfa18) 
       #           ORDER BY cfa02,cfa18)  #lixh1
       #    WHERE rn =(SELECT COUNT(*) FROM cfa_file WHERE cfa01 = g_ccc.ccc01)             
       #END IF              
       #IF cl_null(g_ccc.ccc12) THEN 
       #   SELECT cfa11 INTO g_ccc.ccc12 FROM
       #         (SELECT rownum rn,cfa_file.* FROM cfa_file
       #           WHERE cfa01 = g_ccc.ccc01 
       #             AND (( YEAR(cfa18)= g_yy AND MONTH(cfa18)<= g_mm-1 )  #TQC-D40037 add
       #                 OR YEAR(cfa18)< g_yy )                            #TQC-D40037 add
       #         # ORDER BY cfa03,cfa18) 
       #           ORDER BY cfa02,cfa18)  #lixh1
       #    WHERE rn =(SELECT COUNT(*) FROM cfa_file WHERE cfa01 = g_ccc.ccc01)            
       #END IF                      	
       #FUN-D60091 ------------End-----------
     ELSE ########13
        IF g_mm = 1 THEN 
           #TQC-D40037--modify--str-- 
      	   #SELECT SUM(cfa10),SUM(cfa11) INTO g_ccc.ccc11,g_ccc.ccc12 FROM cfa_file 
      	   # WHERE cfa01 = g_ccc.ccc01
           #   AND YEAR(cfa18) = g_yy - 1 
           #   AND MONTH(cfa18)= 13             	     
           SELECT cfa10,cfa11 INTO g_ccc.ccc11,g_ccc.ccc12 FROM 
                 (SELECT cfa_file.* FROM cfa_file
                   WHERE cfa01 = g_ccc.ccc01
                     AND YEAR(cfa18) = g_yy - 1
                     AND MONTH(cfa18)= 13
                   ORDER BY cfa02 desc,cfa18 desc)  
            WHERE rownum = 1
 
           #TQC-D40037--modify--end--
        #FUN-D60091 -------Begin--------
           IF SQLCA.sqlcode = 100 THEN
              SELECT cca11,cca12 INTO g_ccc.ccc11,g_ccc.ccc12 FROM cca_file
               WHERE cca01 = g_ccc.ccc01
                 AND cca02 = g_yy-1
                 AND cca03 = 13
                 AND cca06 = '6'
                 AND cca07 = ' '
           END IF
        #FUN-D60091 -------End----------
        ELSE 
           #TQC-D40037--modify--str-- 
      	   #SELECT SUM(cfa10),SUM(cfa11) INTO g_ccc.ccc11,g_ccc.ccc12 FROM cfa_file 
      	   # WHERE cfa01 = g_ccc.ccc01
           #   AND YEAR(cfa18) = g_yy
           #   AND MONTH(cfa18)= g_mm - 1    	  	
           SELECT cfa10,cfa11 INTO g_ccc.ccc11,g_ccc.ccc12 FROM
                 (SELECT cfa_file.* FROM cfa_file
                   WHERE cfa01 = g_ccc.ccc01
                     AND YEAR(cfa18) = g_yy
                     AND MONTH(cfa18)= g_mm - 1
                   ORDER BY cfa02,cfa18)  
            WHERE rn =(SELECT COUNT(*) FROM cfa_file WHERE cfa01 = g_ccc.ccc01)
           #TQC-D40037--modify--end--
        #FUN-D60091 -------Begin--------
           IF SQLCA.sqlcode = 100 THEN
              SELECT cca11,cca12 INTO g_ccc.ccc11,g_ccc.ccc12 FROM cca_file
               WHERE cca01 = g_ccc.ccc01
                 AND cca02 = g_yy
                 AND cca03 = g_mm-1 
                 AND cca06 = '6'
                 AND cca07 = ' '
           END IF
        #FUN-D60091 -------End----------
        END IF 	
     #FUN-D60091 --------Begin---------
       #IF cl_null(g_ccc.ccc11) THEN 
       #   SELECT cfa10 INTO g_ccc.ccc11 FROM
       #         (SELECT rownum rn,cfa_file.* FROM cfa_file
       #           WHERE cfa01 = g_ccc.ccc01 
       #             AND (( YEAR(cfa18)= g_yy AND MONTH(cfa18)<= g_mm-1 )  #TQC-D40037 add
       #                 OR YEAR(cfa18)< g_yy )                            #TQC-D40037 add
       #         # ORDER BY cfa03,cfa18) 
       #           ORDER BY cfa02,cfa18)   #lixh1
       #    WHERE rn =(SELECT COUNT(*) FROM cfa_file WHERE cfa01 = g_ccc.ccc01)             
       #END IF              
       #IF cl_null(g_ccc.ccc12) THEN 
       #   SELECT cfa11 INTO g_ccc.ccc12 FROM
       #         (SELECT rownum rn,cfa_file.* FROM cfa_file
       #           WHERE cfa01 = g_ccc.ccc01 
       #             AND (( YEAR(cfa18)= g_yy AND MONTH(cfa18)<= g_mm-1 )  #TQC-D40037 add
       #                 OR YEAR(cfa18)< g_yy )                            #TQC-D40037 add
       #         # ORDER BY cfa03,cfa18) 
       #           ORDER BY cfa02,cfa18)   #lixh1
       #    WHERE rn =(SELECT COUNT(*) FROM cfa_file WHERE cfa01 = g_ccc.ccc01)            
       #END IF          	  
     #FUN-D60091 --------End-----------
     END IF 
     IF cl_null(g_ccc.ccc11) THEN LET g_ccc.ccc11 = 0 END IF  #FUN-D60090 add
     IF cl_null(g_ccc.ccc12) THEN LET g_ccc.ccc12 = 0 END IF  #FUN-D60090 add
     LET g_ccc.ccc12a=g_ccc.ccc12
     

     SELECT SUM(cfa07),SUM(cfa09) INTO g_ccc.ccc21,g_ccc.ccc22 FROM cfa_file   #lixh1
      WHERE cfa01 = g_ccc.ccc01
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
        AND cfa04 = 1
        
     IF cl_null(g_ccc.ccc21) THEN LET g_ccc.ccc21 = 0 END IF         
     IF cl_null(g_ccc.ccc22) THEN LET g_ccc.ccc22 = 0 END IF 
     LET g_ccc.ccc22a = g_ccc.ccc22
     LET g_ccc.ccc23a = g_ccc.ccc22
     LET g_ccc.ccc23 = g_ccc.ccc22/g_ccc.ccc21
     
     SELECT SUM(cfa07),SUM(cfa07*cfa12) INTO g_ccc.ccc41,g_ccc.ccc42 FROM cfa_file
      WHERE cfa01 = g_ccc.ccc01 
        AND cfa04 = -1
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
      # AND (cfa03 = 'aimt301' OR cfa03 = 'aimt311')             #FUN-D60091 mark 
        AND cfa03 IN ('aimt301','aimt311','aimt303','aimt313')   #FUN-D60091

     SELECT SUM(cfa07),SUM(cfa09) INTO g_ccc.ccc43,g_ccc.ccc44 FROM cfa_file
      WHERE cfa01 = g_ccc.ccc01
        AND cfa04 = 1
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
     #  AND (cfa03 = 'aimt302' OR cfa03 = 'aimt312')              #FUN-D60091 mark
         AND cfa03 IN ('aimt302','aimt312','aimt306','aimt309')   #FUN-D60091

     IF cl_null(g_ccc.ccc41) THEN LET g_ccc.ccc41 = 0 END IF         
     IF cl_null(g_ccc.ccc42) THEN LET g_ccc.ccc42 = 0 END IF        
     IF cl_null(g_ccc.ccc43) THEN LET g_ccc.ccc43 = 0 END IF
     IF cl_null(g_ccc.ccc44) THEN LET g_ccc.ccc44 = 0 END IF
     LET g_ccc.ccc214 = g_ccc.ccc43
     LET g_ccc.ccc22a4 = g_ccc.ccc44
     LET g_ccc.ccc224 = g_ccc.ccc44
     
     SELECT SUM(cfa07),SUM(cfa07*cfa12) INTO g_ccc.ccc61,g_ccc.ccc62 FROM cfa_file
      WHERE cfa01 = g_ccc.ccc01
        AND cfa04 = -1
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
    #   AND cfa03 = 'axmt620'   #FUN-D60091 mark
        AND (cfa03 LIKE 'axmt%' OR cfa03 = 'aomt800')   #FUN-D60091
     SELECT SUM(cfa07),SUM(cfa09) INTO g_ccc.ccc64,g_ccc.ccc65 FROM cfa_file
      WHERE cfa01 = g_ccc.ccc01
      # AND cfa04 = 1    #FUN-D60091 mark 
        AND cfa04 = -1   #FUN-D60091
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
        AND cfa03 = 'aomt800'           
     IF cl_null(g_ccc.ccc61) THEN LET g_ccc.ccc61 = 0 END IF    
     IF cl_null(g_ccc.ccc62) THEN LET g_ccc.ccc62 = 0 END IF 
     IF cl_null(g_ccc.ccc64) THEN LET g_ccc.ccc64 = 0 END IF  #TQC-D40037 add
     IF cl_null(g_ccc.ccc65) THEN LET g_ccc.ccc65 = 0 END IF  #TQC-D40037 add
     LET g_ccc.ccc216 = g_ccc.ccc64
     LET g_ccc.ccc22a6 = g_ccc.ccc65
     LET g_ccc.ccc226 = g_ccc.ccc65
     
     SELECT SUM(cfa07),SUM(cfa09) INTO g_ccc.ccc71,g_ccc.ccc72 FROM cfa_file   #lixh1
      WHERE cfa01 = g_ccc.ccc01
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
     #  AND cfa03 = 'aimp880'               #FUN-D60091  mark
        AND cfa03 IN ('aimp880','artt215')  #FUN-D60091
     IF cl_null(g_ccc.ccc71) THEN LET g_ccc.ccc71 = 0 END IF 
     IF cl_null(g_ccc.ccc72) THEN LET g_ccc.ccc72 = 0 END IF  
     
     SELECT SUM(cfa07),SUM(cfa09) INTO g_ccc.ccc211,g_ccc.ccc22a1 FROM cfa_file
      WHERE cfa01 = g_ccc.ccc01
        AND cfa04 = 1
        AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
        AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
      # AND (cfa03 = 'apmt150' OR cfa03 = 'apmt230')  #FUN-D60091 mark
        AND cfa03 IN ('apmt150','apmt230','apmt1072') #FUN-D60091
     IF cl_null(g_ccc.ccc211)  THEN LET g_ccc.ccc211  = 0 END IF  #TQC-D40037 add
     IF cl_null(g_ccc.ccc22a1) THEN LET g_ccc.ccc22a1 = 0 END IF  #TQC-D40037 add
     LET g_ccc.ccc221 = g_ccc.ccc22a1
#FUN-D60091 ----------Begin---------
   # SELECT SUM(cfa13) INTO g_ccc.ccc93 FROM cfa_file 
   #  WHERE cfa01 = g_ccc.ccc01 
   #    AND YEAR(cfa18) = g_ccc.ccc02    #lixh1
   #    AND MONTH(cfa18) = g_ccc.ccc03   #lixh1
     SELECT cfa13 INTO g_ccc.ccc93 FROM (SELECT cfa_file.* FROM cfa_file
                                          WHERE cfa01 = g_ccc.ccc01
                                            AND YEAR(cfa18) = g_yy
                                            AND MONTH(cfa18)= g_mm
                                           ORDER BY cfa02 desc) 
      WHERE rownum =1 
#FUN-D60091 ----------End-----------
     IF cl_null(g_ccc.ccc93) THEN LET g_ccc.ccc93 = 0 END IF    
     
     SELECT cfa10 INTO g_ccc.ccc91 FROM (SELECT cfa_file.* FROM cfa_file 
                                          WHERE cfa01 = g_ccc.ccc01
                                            AND YEAR(cfa18) = g_yy
                                            AND MONTH(cfa18)= g_mm
                                          ORDER BY cfa02 desc)
      WHERE rownum = 1
     SELECT cfa11 INTO g_ccc.ccc92 FROM (SELECT cfa_file.* FROM cfa_file 
                                          WHERE cfa01 = g_ccc.ccc01
                                            AND YEAR(cfa18) = g_yy
                                            AND MONTH(cfa18)= g_mm                                          
                                           ORDER BY cfa02 desc)  #lixh1
      WHERE rownum = 1 
     IF cl_null(g_ccc.ccc91) THEN LET g_ccc.ccc91 = 0 END IF         
     IF cl_null(g_ccc.ccc92) THEN LET g_ccc.ccc92 = 0 END IF       
     LET g_ccc.ccc92a = g_ccc.ccc92
               
     LET g_ccc.ccc02    = g_yy     LET g_ccc.ccc03    = g_mm     LET g_ccc.ccc07    = '6'
     LET g_ccc.ccc08    = ' '      LET g_ccc.ccc04    = 0        LET g_ccc.ccc05    = 0
     LET g_ccc.ccc06    = 0        LET g_ccc.ccc12b   = 0
     LET g_ccc.ccc12c   = 0        LET g_ccc.ccc12d   = 0        LET g_ccc.ccc12e   = 0 
     LET g_ccc.ccc22b   = 0        LET g_ccc.ccc22c   = 0 
     LET g_ccc.ccc22d   = 0        LET g_ccc.ccc22e   = 0     
     LET g_ccc.ccc23b   = 0        LET g_ccc.ccc23c   = 0        LET g_ccc.ccc23d   = 0
     LET g_ccc.ccc23e   = 0        LET g_ccc.ccc25    = 0        LET g_ccc.ccc26    = 0             
     LET g_ccc.ccc26a   = 0        LET g_ccc.ccc26b   = 0        LET g_ccc.ccc26c   = 0            
     LET g_ccc.ccc26d   = 0        LET g_ccc.ccc26e   = 0        LET g_ccc.ccc27    = 0      
     LET g_ccc.ccc28    = 0        LET g_ccc.ccc28a   = 0        LET g_ccc.ccc28b   = 0
     LET g_ccc.ccc28c   = 0        LET g_ccc.ccc28d   = 0        LET g_ccc.ccc28e   = 0
     LET g_ccc.ccc31    = 0        LET g_ccc.ccc32    = 0        LET g_ccc.ccc51    = 0 
     LET g_ccc.ccc52    = 0        LET g_ccc.ccc63    = 0    
     LET g_ccc.ccc92b   = 0        LET g_ccc.ccc92c   = 0        LET g_ccc.ccc92d   = 0 
     LET g_ccc.ccc92e   = 0        LET g_ccc.ccclegal = g_legal  LET g_ccc.cccoriu = g_user 
     LET g_ccc.cccuser = g_user    LET g_ccc.cccdate = g_today   LET g_ccc.cccorig = g_grup 

#FUN-D60091 --------Begin---------
     LET g_ccc.ccc62a   = 0        LET g_ccc.ccc62b   = 0        LET g_ccc.ccc62c   = 0
     LET g_ccc.ccc62d   = 0        LET g_ccc.ccc62e   = 0   
     LET g_ccc.ccc66a   = 0        LET g_ccc.ccc66b   = 0        LET g_ccc.ccc66c   = 0
     LET g_ccc.ccc66d   = 0        LET g_ccc.ccc66e   = 0        LET g_ccc.ccc66    = 0
     LET g_ccc.ccc93a   = 0        LET g_ccc.ccc93b   = 0        LET g_ccc.ccc93c   = 0
     LET g_ccc.ccc93d   = 0        LET g_ccc.ccc93e   = 0     
     LET g_ccc.ccc92b   = 0        LET g_ccc.ccc92c   = 0        LET g_ccc.ccc92d   = 0     
     LET g_ccc.ccc92e   = 0        LET g_ccc.ccc212   = 0        LET g_ccc.ccc213   = 0  
   # LET g_ccc.ccc214   = 0        LET g_ccc.ccc215   = 0                                 #TQC-D80002 mark 
   # LET g_ccc.ccc222   = 0        LET g_ccc.ccc223   = 0        LET g_ccc.ccc224   = 0   #TQC-D80002 mark
     LET g_ccc.ccc215   = 0        LET g_ccc.ccc222   = 0        LET g_ccc.ccc223   = 0   #TQC-D80002 add
     LET g_ccc.ccc225   = 0        LET g_ccc.ccc22a2  = 0        LET g_ccc.ccc22a3  = 0
     LET g_ccc.ccc22a4  = 0        LET g_ccc.ccc22a5  = 0        LET g_ccc.ccc22b1  = 0
     LET g_ccc.ccc22b2  = 0        LET g_ccc.ccc22b3  = 0        LET g_ccc.ccc22b4  = 0
     LET g_ccc.ccc22b5  = 0        LET g_ccc.ccc22c1  = 0        LET g_ccc.ccc22c2  = 0
     LET g_ccc.ccc22c3  = 0        LET g_ccc.ccc22c4  = 0        LET g_ccc.ccc22c5  = 0 
     LET g_ccc.ccc22d1  = 0        LET g_ccc.ccc22d2  = 0        LET g_ccc.ccc22d3  = 0
     LET g_ccc.ccc22d4  = 0        LET g_ccc.ccc22d5  = 0        LET g_ccc.ccc22e1  = 0
     LET g_ccc.ccc22e2  = 0        LET g_ccc.ccc22e3  = 0        LET g_ccc.ccc22e4  = 0
     LET g_ccc.ccc22e5  = 0        LET g_ccc.ccc81    = 0        LET g_ccc.ccc82    = 0
     LET g_ccc.ccc82a   = 0        LET g_ccc.ccc82b   = 0        LET g_ccc.ccc82c   = 0
     LET g_ccc.ccc82d   = 0        LET g_ccc.ccc82e   = 0        LET g_ccc.ccc12f   = 0
     LET g_ccc.ccc12g   = 0        LET g_ccc.ccc12h   = 0        LET g_ccc.ccc22f   = 0
     LET g_ccc.ccc22f1  = 0        LET g_ccc.ccc22f2  = 0        LET g_ccc.ccc22f3  = 0
     LET g_ccc.ccc22f4  = 0        LET g_ccc.ccc22f5  = 0        LET g_ccc.ccc22g   = 0 
     LET g_ccc.ccc22g1  = 0        LET g_ccc.ccc22g2  = 0        LET g_ccc.ccc22g3  = 0
     LET g_ccc.ccc22g4  = 0        LET g_ccc.ccc22g5  = 0        LET g_ccc.ccc22h  = 0
     LET g_ccc.ccc22h1  = 0        LET g_ccc.ccc22h2  = 0        LET g_ccc.ccc22h3  = 0
     LET g_ccc.ccc22h4  = 0        LET g_ccc.ccc22h5  = 0        LET g_ccc.ccc23f   = 0 
     LET g_ccc.ccc23g   = 0        LET g_ccc.ccc23h   = 0        LET g_ccc.ccc26f   = 0
     LET g_ccc.ccc26g   = 0        LET g_ccc.ccc26h   = 0        LET g_ccc.ccc28f   = 0
     LET g_ccc.ccc28g   = 0        LET g_ccc.ccc28h   = 0        LET g_ccc.ccc62f   = 0
     LET g_ccc.ccc62g   = 0        LET g_ccc.ccc62h   = 0        LET g_ccc.ccc66f   = 0
     LET g_ccc.ccc66g   = 0        LET g_ccc.ccc66h   = 0        LET g_ccc.ccc82f   = 0
     LET g_ccc.ccc82g   = 0        LET g_ccc.ccc82h   = 0        LET g_ccc.ccc92f   = 0 
     LET g_ccc.ccc92g   = 0        LET g_ccc.ccc92h   = 0        LET g_ccc.ccc93f   = 0
     LET g_ccc.ccc93g   = 0        LET g_ccc.ccc93h   = 0        LET g_ccc.ccc22b6  = 0
     LET g_ccc.ccc22c6  = 0        LET g_ccc.ccc22d6  = 0        LET g_ccc.ccc22e6  = 0
     LET g_ccc.ccc22f6  = 0        LET g_ccc.ccc22g6  = 0        LET g_ccc.ccc22h6  = 0
#FUN-D60091 --------End-----------

     LET l_count = 0 
     SELECT COUNT(*) INTO l_count FROM ccc_file
      WHERE ccc01 = g_ccc.ccc01 
        AND ccc02 = g_yy
        AND ccc03 = g_mm 
        AND ccc07 = g_ccc.ccc07  
        AND ccc08 = g_ccc.ccc08
     IF l_count > 0  THEN
     DELETE FROM ccc_file
      WHERE ccc01 = g_ccc.ccc01
        AND ccc02 = g_yy
        AND ccc03 = g_mm
        AND ccc07 = g_ccc.ccc07
        AND ccc08 = g_ccc.ccc08
     END IF 
    
     INSERT INTO ccc_file VALUES(g_ccc.*)    
       
  END FOREACH 
END FUNCTION
#FUN-BC0062
