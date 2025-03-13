# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: askp001.4gl
# Descriptions...: 飛票整批產生作業
# Date & Author..:#No.FUN-810016 08/01/24 By ve007
# Modify.........:#No.FUN-840001 08/03/28 BY ve007
# Modify.........:#No.FUN-870117 08/05/28 by ve007  增加根據作業編號產生飛票功能
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........:#No.TQC-A70106 10/07/22 by yinhy DEFINE段LIKE語法zld_file.zld19改為skh_file.skh03
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
        a1     LIKE sfc_file.sfc01,   
        a2     LIKE ima_file.ima01, 
        a3_b   LIKE type_file.num5,
        a3_e   LIKE type_file.num5, 
        a4_b   LIKE type_file.num5,
        a4_e   LIKE type_file.num5,
        a5     LIKE type_file.chr1,
        a6     LIKE ecm_file.ecm04     #No.FUN-870117
        END RECORD
DEFINE   l_flag          LIKE type_file.chr1   
DEFINE   l_sma124        LIKE sma_file.sma124   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   
   LET tm.a1 = ARG_VAL(1)
   LET tm.a2 = ARG_VAL(2)
   LET tm.a3_b = ARG_VAL(3)
   LET tm.a3_e = ARG_VAL(4)
   LET tm.a4_b = ARG_VAL(5)
   LET tm.a4_e = ARG_VAL(6) 
   LET g_bgjob = ARG_VAL(7)
   IF cl_null(g_bgjob)  THEN
      LET g_bgjob = "N"
   END IF  
   
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup('ASK')) THEN
      EXIT PROGRAM
   END IF 

   IF NOT s_industry('slk') THEN                                                
      CALL cl_err("","-1000",1)                                                 
      EXIT PROGRAM                                                              
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
      
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p001_tm(0,0)
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p001()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               DISPLAY ' ' TO FORMONLY.a2_ima02
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p001_w
               EXIT WHILE
            END IF
         ELSE
         	  DISPLAY ' ' TO FORMONLY.a2_ima02
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p001()
         IF g_success = "Y" THEN
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
 
FUNCTION p001_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_n           LIKE type_file.num5
   DEFINE   lc_cmd        LIKE type_file.chr1000
 
   OPEN WINDOW p101_w WITH FORM "ask/42f/askp001"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL
   
    WHILE TRUE
      MESSAGE ""
      CALL ui.Interface.refresh()
      LET tm.a5="N"
      LET g_bgjob = "N"
      
   #  INPUT BY NAME tm.a1,tm.a2,tm.a3_b,tm.a3_e,tm.a4_b,tm.a4_e,tm.a5,g_bgjob WITHOUT DEFAULTS
      INPUT BY NAME tm.a1,tm.a2,tm.a6,tm.a3_b,tm.a3_e,tm.a4_b,tm.a4_e,tm.a5,g_bgjob WITHOUT DEFAULTS     #No.FUN-870117  
        ON ACTION locale       #開啟切換語言別功能
           EXIT INPUT   
           
        AFTER FIELD a1
          IF NOT cl_null(tm.a1)  THEN
             SELECT COUNT(*) INTO l_n FROM sfc_file,sfci_file
               WHERE sfc01=tm.a1 AND sfci_file.sfci01 = sfc01
               AND sfcislk05='Y' AND sfcacti='Y'
             IF l_n=0 THEN
               CALL cl_err('','ask-008',0)
               NEXT FIELD a1
             END IF
          ELSE 
              NEXT FIELD a1
          END IF
          
        AFTER FIELD a2
          IF NOT cl_null(tm.a2)  THEN
             SELECT COUNT(*) INTO l_n FROM imx_file,ima_file,sfb_file
               WHERE ima_file.ima01=imx_file.imx00 AND imx_file.imx000=sfb_file.sfb05
               AND sfb_file.sfb85=tm.a1 AND ima_file.ima01=tm.a2
             IF l_n=0 THEN
               CALL cl_err('','ask-008',0)
               NEXT FIELD a2
             END IF
          END IF     
         
         #No.FUN-870117 --begin--
         AFTER FIELD a6
          IF NOT cl_null(tm.a6)  THEN
             SELECT COUNT(*) INTO l_n FROM ecm_file,sfb_file
               WHERE ecm_file.ecm01= sfb_file.sfb01 AND sfb_file.sfb85 = tm.a1
                 AND ecm_file.ecm04= tm.a6
             IF l_n=0 THEN
               CALL cl_err('','ask-008',0)
               NEXT FIELD a6
             END IF
          END IF 
         #No.FUN-870117 --end--          
         AFTER FIELD a3_b
           IF NOT cl_null(tm.a3_b)  THEN
              IF tm.a3_b<0 THEN
                CALL cl_err(tm.a3_b,'aim-223',0)
               END IF
           END IF
           IF NOT cl_null(tm.a3_b) AND NOT cl_null(tm.a3_e) THEN 
             #No,FUN-840001 -begin--
             IF NOT  p001_bigger(tm.a3_b,tm.a3_e)  THEN 
                CALL cl_err('','ask-050',1)
                NEXT FIELD a3_b
             END IF 
             #No.FUN-840001 --end--     
           END IF
           
         AFTER FIELD a3_e
           IF NOT cl_null(tm.a3_e)  THEN
              IF tm.a3_e<0 THEN
                CALL cl_err(tm.a3_e,'aim-223',0)
               END IF
           END IF
           IF NOT cl_null(tm.a3_b) AND NOT cl_null(tm.a3_e) THEN 
               #No,FUN-840001 -begin--
             IF NOT  p001_bigger(tm.a3_b,tm.a3_e)  THEN 
               CALL cl_err('','ask-050',1)
               NEXT FIELD a3_e
             END IF  
              #No.FUN-840001 --end--
           END IF 
           
         AFTER FIELD a4_b
           IF NOT cl_null(tm.a4_b)  THEN
              IF tm.a4_b<0 THEN
                CALL cl_err(tm.a4_b,'aim-223',0)
               END IF
           END IF 
           IF NOT cl_null(tm.a4_b) AND NOT cl_null(tm.a4_e) THEN 
               #No,FUN-840001 -begin--
             IF NOT  p001_bigger(tm.a4_b,tm.a4_e)  THEN 
               CALL cl_err('','ask-051',1)
               NEXT FIELD a4_b
             END IF 
              #No.FUN-840001 --end--
           END IF 
              
         AFTER FIELD a4_e
           IF NOT cl_null(tm.a4_e)  THEN
              IF tm.a4_e<0 THEN
                CALL cl_err(tm.a4_e,'aim-223',0)
               END IF
           END IF 
           IF NOT cl_null(tm.a4_b) AND NOT cl_null(tm.a4_e) THEN
               #No,FUN-840001 -begin-- 
             IF NOT  p001_bigger(tm.a4_b,tm.a4_e)  THEN 
               CALL cl_err('','ask-051',1)
               NEXT FIELD a4_b
             END IF
              #No.FUN-840001 --end--
          END IF 
           
         ON ACTION controlp
            CASE
              WHEN INFIELD (a1)
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_skf01"
                CALL cl_create_qry() RETURNING tm.a1
                DISPLAY BY NAME tm.a1
                NEXT FIELD a1
              WHEN INFIELD (a2)
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_skf02"
                LET g_qryparam.arg1=tm.a1
                CALL cl_create_qry() RETURNING tm.a2
                DISPLAY BY NAME tm.a2
                CALL p001_a2('d')
                NEXT FIELD a2
               #No.FUN-870117 --begin--
               WHEN INFIELD (a6)
                CALL cl_init_qry_var()
                LET g_qryparam.form="q_ecm03"
                LET g_qryparam.arg1=tm.a1
                CALL cl_create_qry() RETURNING tm.a6
                DISPLAY BY NAME tm.a6
                NEXT FIELD a6    
                #No.FUN-870117
            END CASE
           
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG
            CALL cl_cmdask()
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT 
            
         ON ACTION about
            CALL cl_about()
 
         ON ACTION HELP
            CALL cl_show_help()
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT
            
       END INPUT 
       
        IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW p001_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM 
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "askp001"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('askp001','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.a1 CLIPPED ,"'",
                         " '",tm.a2 CLIPPED ,"'",
                         " '",tm.a3_b CLIPPED ,"'",
                         " '",tm.a3_e CLIPPED ,"'",
                         " '",tm.a4_b CLIPPED ,"'",
                         " '",tm.a4_e CLIPPED ,"'",
                         " '",tm.a5 CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('askp001',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p001_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
    EXIT WHILE
    
   END WHILE
 
END FUNCTION
 
FUNCTION p001()
   DEFINE l_name    LIKE type_file.chr20,        
          l_str     STRING,                     
          l_chr     LIKE type_file.chr1,         
          l_flag    LIKE type_file.chr1,              
          l_n       LIKE type_file.num5,      
          li_result LIKE type_file.num5,     
          l_skg     RECORD LIKE skg_file.*,
          l_sgd     RECORD LIKE sgd_file.*,
          l_skh99   LIKE skh_file.skh99,
          l_skh     RECORD LIKE skh_file.*,
          l_sfcislk01  LIKE sfci_file.sfcislk01,
          l_sql      string      #870117
   
       LET g_success = 'Y'
      #跦擂賒醱懷□腔沭璃蚰□笛散桶等芛ㄛ等旯紫訧蹋
        DECLARE p001_a CURSOR FOR
         SELECT skg_file.* FROM skg_file,skf_file
          WHERE skg_file.skg01=skf_file.skf01 AND skg_file.skg02=skf_file.skf02
            AND skg_file.skg03=skf_file.skf03 AND skf07='Y'
            AND skf_file.skf01=tm.a1 AND skf_file.skf02=tm.a2
            AND skf_file.skf03 BETWEEN tm.a3_b AND tm.a3_e
            AND skg_file.skg08 BETWEEN tm.a4_b AND tm.a4_e
        FOREACH p001_a INTO l_skg.*
          
        IF tm.a5!='Y' THEN
      #婬跦擂馱等瘍蚰□馱等馱眙袚趿紫笢腔剒惆馱腔等啋訧蹋  
       #FUN-870117--begin--
       IF NOT cl_null(tm.a6)  THEN 
          LET l_sql="SELECT sgd_file.* FROM sgd_file,ecm_file WHERE sgd_file.sgd00='",l_skg.skg12,"'",   #No.FUN-870117
               "AND sgd_file.sgd14='Y' ",
               "AND ecm01=sgd00 ",                 #No.FUN-870117
               "AND ecm04='",tm.a6,"'",                 #No.FUN-870117
               "AND ecm03=sgd03"                 #No.FUN-870117  
       ELSE 
          LET l_sql="SELECT sgd_file.* FROM sgd_file WHERE sgd_file.sgd00='",l_skg.skg12,"'",
                    "AND sgd_file.sgd14='Y'" 	
       END IF  
       #FUN-870117--end--  
       DECLARE p001_b CURSOR FROM l_sql
          FOREACH p001_b INTO l_sgd.*
             
          LET l_str=l_skg.skg01
          LET l_skh99=l_str.trim()
          LET l_str=l_skg.skg02
          LET l_skh99=l_skh99,'_',l_str.trim() 
          LET l_str=l_skg.skg03
          LET l_skh99=l_skh99,'_',l_str.trim()
          LET l_str=l_skg.skg08
          LET l_skh99=l_skh99,'_',l_str.trim()
          LET l_str=l_skg.skg12               
          LET l_skh99=l_skh99,'_',l_str.trim()   
          LET l_str=l_sgd.sgd03
          LET l_skh99=l_skh99,'_',l_str.trim()
          LET l_str=l_sgd.sgd05
          LET l_skh99=l_skh99,'_',l_str.trim() 
          
          IF l_skg.skg05 IS NOT NULL AND l_skg.skg05!=' ' THEN
            LET l_str=l_skg.skg05
            LET l_skh99=l_skh99,'_',l_str.trim()
          END IF
          
          IF l_skg.skg06 IS NOT NULL AND l_skg.skg06!=' ' THEN
            LET l_str=l_skg.skg06
            LET l_skh99=l_skh99,'_',l_str.trim()
          END IF
          
          IF l_skg.skg07 IS NOT NULL AND l_skg.skg07!=' ' THEN
            LET l_str=l_skg.skg07
            LET l_skh99=l_skh99,'_',l_str.trim()
          END IF 
#  Check l_skh99岆瘁湔婓迵滄き訧蹋紫笢ㄛ□祥湔婓ㄛ寀莉汜森滄き訧蹋ㄛ瘁寀,祥莉汜
          SELECT COUNT(*) INTO l_n FROM skh_file 
             WHERE skh_file.skh99=l_skh99
          IF l_n=0 THEN
             CALL p001_auto_no() RETURNING l_skh.skh01
    # 跦擂滄き晤瘍埻寀莉汜,寞寀峈:謗弇爛(yy),謗弇堎(mm),11弇霜阨瘍
              LET l_skh.skh02 = l_skg.skg01
              LET l_skh.skh03 = l_skg.skg02
              LET l_skh.skh04 = l_skg.skg03
              LET l_skh.skh05 = l_skg.skg08
              LET l_skh.skh06 = l_skg.skg12        
              LET l_skh.skh07 = l_sgd.sgd03
              IF l_sgd.sgd03 = 0  THEN
                LET l_skh.skh07 = ' '
              END IF   
              LET l_skh.skh08 = l_sgd.sgd05
              LET l_skh.skh09 = l_skg.skg05
              LET l_skh.skh10 = l_skg.skg06
              LET l_skh.skh11 = l_skg.skg07
              LET l_skh.skh12 = l_skg.skg09
              SELECT sfcislk01 INTO l_sfcislk01 FROM sfc_file,sfci_file
                WHERE sfc01 = l_skg.skg01 AND sfci_file.sfci01 = sfc_file.sfc01 
              LET l_skh.skh13 = l_sfcislk01 
              LET l_skh.skh14 = l_sgd.sgdslk05
              IF l_sgd.sgdslk05 = 0 THEN
                 LET l_skh.skh14 = ' '
              END IF    
              LET l_skh.skh99 = l_skh99
              LET l_skh.skh100 = 'N'  
              LET l_skh.skhplant=g_plant #FUN-980008 add
              LET l_skh.skhlegal=g_legal #FUN-980008 add
              INSERT INTO skh_file VALUES(l_skh.*)
              
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF  
              
          END IF      
          END FOREACH
       ELSE
          LET l_str=l_skg.skg01
          LET l_skh99=l_str.trim()
          LET l_str=l_skg.skg02
          LET l_skh99=l_skh99,'_',l_str.trim() 
          LET l_str=l_skg.skg03
          LET l_skh99=l_skh99,'_',l_str.trim()
          LET l_str=l_skg.skg08
          LET l_skh99=l_skh99,'_',l_str.trim()
          LET l_str=l_skg.skg12        
          LET l_skh99=l_skh99,'_',l_str.trim()    
 
          IF l_skg.skg05 IS NOT NULL AND l_skg.skg05!=' ' THEN
            LET l_str=l_skg.skg05
            LET l_skh99=l_skh99,'_',l_str.trim()
          END IF
          
          IF l_skg.skg06 IS NOT NULL AND l_skg.skg06!=' ' THEN
            LET l_str=l_skg.skg06
            LET l_skh99=l_skh99,'_',l_str.trim()
          END IF
          
          IF l_skg.skg07 IS NOT NULL AND l_skg.skg07!=' ' THEN
            LET l_str=l_skg.skg07
            LET l_skh99=l_skh99,'_',l_str.trim()
          END IF 
#  Check l_skh99岆瘁湔婓迵滄き訧蹋紫笢ㄛ□祥湔婓ㄛ寀莉汜森滄き訧蹋ㄛ瘁寀,祥莉汜
          SELECT COUNT(*) INTO l_n FROM skh_file 
             WHERE skh_file.skh99=l_skh99
          IF l_n=0 THEN
             CALL p001_auto_no() RETURNING l_skh.skh01
    # 跦擂滄き晤瘍埻寀莉汜,寞寀峈:謗弇爛(yy),謗弇堎(mm),11弇霜阨瘍
              LET l_skh.skh02=l_skg.skg01
              LET l_skh.skh03=l_skg.skg02
              LET l_skh.skh04=l_skg.skg03
              LET l_skh.skh05=l_skg.skg08
              LET l_skh.skh06=l_skg.skg12         
              LET l_skh.skh07 = ' '
              LET l_skh.skh09=l_skg.skg05
              LET l_skh.skh10=l_skg.skg06
              LET l_skh.skh11=l_skg.skg07
              LET l_skh.skh12=l_skg.skg09
              SELECT sfcislk01 INTO l_sfcislk01 FROM sfc_file,sfci_file
                WHERE sfc01=l_skg.skg01 AND sfci_file.sfci01 = sfc_file.sfc01 
              LET l_skh.skh13=l_sfcislk01 
              LET l_skh.skh14=l_sgd.sgdslk05
              IF l_sgd.sgdslk05 = 0 THEN
                 LET l_skh.skh14 = ' '
              END IF
              LET l_skh.skh99=l_skh99
              LET l_skh.skh100='N'
              LET l_skh.skhplant=g_plant #FUN-980008 add
              LET l_skh.skhlegal=g_legal #FUN-980008 add
              INSERT INTO skh_file VALUES(l_skh.*)
              
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF 
          END IF      
       END IF
       END FOREACH
END FUNCTION
            
FUNCTION p001_a2(p_cmd)
   DEFINE l_ima02   LIKE ima_file.ima02,    #員工姓名
          l_imaacti LIKE ima_file.imaacti,
          p_cmd     like type_file.chr1
 
   LET g_errno=''
   SELECT ima02 INTO l_ima02 FROM ima_file 
          WHERE ima01=tm.a2
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006' 
                          LET l_ima02=NULL
        WHEN l_imaacti='N' LET g_errno='9028' 
        OTHERWISE          LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE 
   IF cl_null(g_errno) OR p_cmd='d' THEN
   DISPLAY l_ima02 TO FORMONLY.a2_ima02
   END IF
END FUNCTION 
 
FUNCTION p001_auto_no()
DEFINE    li_month  LIKE azn_file.azn04,
          l_sql     STRING,
          li_year   LIKE azn_file.azn02
   DEFINE   ls_max_sn       STRING 
   DEFINE   ls_format       STRING
   DEFINE   ls_date         STRING
   DEFINE   lc_sn   LIKE skh_file.skh01
   DEFINE   li_i            LIKE type_file.num10
   #DEFINE   li_max_no       LIKE zld_file.zld19  #mark by No.TQC-A70106
   DEFINE   li_max_no       LIKE skh_file.skh03   #add by No.TQC-A70106
              SELECT azn02,azn04 INTO li_year,li_month
                 FROM azn_file WHERE azn01 = g_today 
              LET ls_date = li_year USING "&&&&",li_month USING "&&"
              LET ls_date = ls_date.subString(3,6)   
              LET l_sql="SELECT MAX(skh01)  FROM skh_file", 
                        " WHERE skh01 LIKE'",ls_date, "%'"
               PREPARE l_prepare1 FROM l_sql
               EXECUTE l_prepare1 INTO li_max_no
               LET ls_max_sn = li_max_no[5,15]
            IF ((ls_max_sn IS NULL) OR (ls_max_sn = " ")) THEN 
                LET ls_max_sn = ""
                LET ls_format = ""
                FOR li_i = 1 TO 11
                   LET ls_max_sn = ls_max_sn,"0"
                   LET ls_format = ls_format,"&"
                END FOR
                LET lc_sn = ls_date,(ls_max_sn + 1) USING ls_format
            ELSE
                LET ls_format = ""
                FOR li_i = 1 TO 11
                   LET ls_format = ls_format,"&"
                END FOR
                LET lc_sn = ls_date,(ls_max_sn.subString(5,11) + 1) USING ls_format
            END IF
            RETURN lc_sn
END FUNCTION 
#No.FUN-840001 --begin--
FUNCTION p001_bigger(p1,p2)
DEFINE  p1,p2   LIKE type_file.num5
   IF p1<=p2 THEN 
      RETURN TRUE 
   ELSE
  	  RETURN FALSE 
   END IF 
END FUNCTION    	     
#No.FUN-840001 --end--
#No.FUN-810016
