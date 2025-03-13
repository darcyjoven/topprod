# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aicp018.4gl                                                  
# Descriptions...: ICD料件光罩累計數統計作業                                       
# Date & Author..: 07/11/19 #No.FUN-7B0016 By ve007 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-C20068 12/02/14 By chenjing

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
        wc      STRING,           #NO.FUN-910082
        ict02   LIKE ict_file.ict02,
        ict03   LIKE ict_file.ict03
        END RECORD,
       g_ics RECORD
         ics01  LIKE ics_file.ics01,
         ics00  LIKE ics_file.ics00,
         ics02  LIKE ics_file.ics02,
         ics20  LIKE ics_file.ics20,
         ics06  LIKE ics_file.ics06,
         ics03  LIKE ics_file.ics03,
         ics04  LIKE ics_file.ics04,
         ics05  LIKE ics_file.ics05
         END RECORD 
DEFINE   l_flag          LIKE type_file.chr1
DEFINE   #l_sql           LIKE type_file.chr1000 
         l_sql      STRING     #NO.FUN-910082  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   
   IF cl_null(g_bgjob)  THEN
      LET g_bgjob = "N"
   END IF 
   
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("aic")) THEN
      EXIT PROGRAM
   END IF  
 
   IF NOT s_industry('icd') THEN                                                                                                    
     CALL cl_err('','aic-999',1)                                                                                                    
     EXIT PROGRAM                                                                                                                   
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  

   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p018_tm(0,0)
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p018()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               DISPLAY ' ' TO FORMONLY.ict02
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p018_w
               EXIT WHILE
            END IF
         ELSE
         	  DISPLAY ' ' TO FORMONLY.ict02
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p018()
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
 
FUNCTION p018_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_i           LIKE type_file.num5
   DEFINE   lc_cmd        LIKE type_file.chr1000
   
   OPEN WINDOW p101_w WITH FORM "aic/42f/aicp018"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   
    WHILE TRUE
      MESSAGE ""
      CALL ui.Interface.refresh()
      LET g_bgjob = "N"
      
      CONSTRUCT BY NAME tm.wc ON ics20,ics06,ics00,ics02,ics01
        
        ON ACTION controlp 
          CASE
            WHEN INFIELD(ics20)
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.form     = "q_imaicd"
            #  LET g_qryparam.where    = "imaicd05='3'"
            #  LET g_qryparam.state    = "c"
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_imaicd","imaicd05='3'","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
              DISPLAY g_qryparam.multiret TO ics20
              NEXT FIELD ics20
            WHEN INFIELD(ics06)
              CALL cl_init_qry_var()
              LET g_qryparam.form    = "q_occ"
              LET g_qryparam.state   = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ics06
              NEXT FIELD ics06
            WHEN INFIELD(ics00)
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_imaicd"
             #   LET g_qryparam.where= "imaicd05='3'"
             #   LET g_qryparam.state    = "c"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_imaicd","imaicd05='3'","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO ics00
                NEXT FIELD ics00   
            WHEN INFIELD(ics02)
              CALL cl_init_qry_var()
              LET g_qryparam.form  = "q_ice"
              LET g_qryparam.state = "c"
              LET g_qryparam.multiret_index=2
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO  ics02
              NEXT FIELD ics02    
            WHEN INFIELD(ics01)
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ice"
              LET g_qryparam.state    = "c"
              LET g_qryparam.default1 =g_ics.ics01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO  ics01
              NEXT FIELD ics01
          END CASE 
          
         ON ACTION locale
            LET g_action_choice='locale'
            CALL cl_show_fld_cont()                   
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
            
         ON ACTION exit     
            LET INT_FLAG = 1
            EXIT CONSTRUCT 
      END CONSTRUCT                      
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
                        
      INPUT BY NAME tm.ict02,tm.ict03,g_bgjob WITHOUT DEFAULTS
      
         ON ACTION locale       #開啟切換語言別功能
           EXIT INPUT   
           
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
         LET INT_FLAG = 0 CLOSE WINDOW p018_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "aicp018"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aicp018','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.ict02 CLIPPED ,"'",
                         " '",tm.ict03 CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aicp018',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p018_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
    EXIT WHILE
    
   END WHILE
 
END FUNCTION
 
FUNCTION p018()
   DEFINE l_name    LIKE type_file.chr20,        
          l_str     STRING,                     
          l_chr     LIKE type_file.chr1,         
          l_flag    LIKE type_file.chr1,              
          g_tot     LIKE type_file.num5,      
          li_result LIKE type_file.num5,
          l_ics00   LIKE ics_file.ics00,
          l_ics20   LIKE ics_file.ics20,
          l_ics06   LIKE ics_file.ics06       
   DEFINE l_ics14   LIKE ics_file.ics14     #FUN-C20068--add--
   
       LET g_success = 'Y'
       LET l_str="SELECT DISTINCT ics00 FROM ics_file WHERE icspost='N' AND ",tm.wc 
       PREPARE p018_a FROM l_str
       DECLARE p_018_a CURSOR FOR p018_a
       
       FOREACH p_018_a INTO l_ics00
        
         SELECT ics20,ics06 INTO l_ics20,l_ics06 FROM ics_file
           WHERE ics00 = l_ics00
         
         IF NOT cl_null(tm.ict03) THEN   
          SELECT SUM(oeb12*oeb05_fac) INTO g_tot
           FROM oeb_file,oea_file
             WHERE oeb01=oea01
             AND YEAR (oea02) = tm.ict02
             AND MONTH(oea02) = tm.ict03
             AND      oeaconf = 'Y'
             AND        oeb04 = l_ics20
             AND        oea03 = l_ics06
         ELSE 
       	 SELECT SUM(oeb12*oeb05_fac) INTO g_tot
           FROM oeb_file,oea_file
          WHERE      oeb01 = oea01
            AND  YEAR(oea02) = tm.ict02
            AND      oeaconf = 'Y'
            AND        oeb04 = l_ics20
            AND        oea03 = l_ics06 
         END IF        
             
        
        IF NOT cl_null(g_tot) THEN
         #FUN-C20068--add--start--
           SELECT ics14 INTO l_ics14
             FROM ics_file
            WHERE ics00 = l_ics00
              AND icspost = 'N' 
           LET g_tot = s_digqty(g_tot,l_ics14)    
         #FUN-C20068--add--end--
           UPDATE   ics_file 
              SET   ics15 = g_tot
            WHERE ics00 = l_ics00
              AND icspost = 'N'
        END IF 
        IF SQLCA.sqlcode THEN
          LET g_success='N'
          EXIT FOREACH
        END IF 
                  
        END FOREACH
        COMMIT WORK
 
END FUNCTION
#No.FUN-7B0016            
