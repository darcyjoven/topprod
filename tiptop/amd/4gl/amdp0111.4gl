# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: amdp011.4gl
# Descriptions...: 銷項憑證資料產生作業-門市營業資料
# Date & Author..: NO:FUN-B40040 11/08/04 By yangxf 
# Modify.........: No:FUN-B90079 11/09/14 By yangxf
# Modify.........: No:FUN-B90144 11/09/30 By yangxf 作廢發票誤與非作廢發票金額加在一起.
# Modify.........: No:MOD-BC0254 11/12/28 By Polly 作廢發票轉至amdi101時，銷售金額、稅額、含稅金額和統一編號需歸0
# Modify.........: No:CHI-C90016 12/09/21 By pauline 批次拋轉發票資料時,抓取發票結束號碼時必須要考慮是否為同一台POS雞號開出
# Modify.........: No:MOD-D10130 13/01/15 By apo   增加amd22的AFTER FIELD

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_amd05           LIKE amd_file.amd05, 
       g_amd25           LIKE amd_file.amd25,
       g_amd22           LIKE amd_file.amd22,
       g_wc              STRING,                
       g_row,g_col       LIKE type_file.num5,    
       g_cnt             LIKE type_file.num10,   
       g_change_lang     LIKE type_file.chr1,    
       l_flag            LIKE type_file.chr1    
DEFINE g_sql             STRING                  
DEFINE begin_no          LIKE amd_file.amd01     
DEFINE g_bgjob           LIKE type_file.chr1 
DEFINE l_sql             STRING 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob TO NULL
   LET g_wc      = ARG_VAL(1)
   LET g_amd22   = ARG_VAL(2)
   LET g_bgjob   = ARG_VAL(3)
   LET begin_no = NULL     
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   WHILE TRUE
      LET g_success = 'Y'   
      IF g_bgjob = 'N' THEN
         CALL p011_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p011_p()
            CALL s_showmsg()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
              CONTINUE WHILE
            ELSE
              CLOSE WINDOW p011_w
              EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p011_w
      ELSE
         BEGIN WORK
         CALL s_showmsg_init()
         CALL p011_p()
         CALL s_showmsg()
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
 
FUNCTION p011_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,      
          l_cmd          LIKE type_file.chr1000      
   DEFINE l_sql          STRING                           
   DEFINE lc_cmd         LIKE type_file.chr1000            
   DEFINE l_plant        LIKE azp_file.azp01               
   DEFINE l_n            LIKE type_file.num5   #MOD-D10130
 
   LET g_row = 4 LET g_col = 15
   OPEN WINDOW p011_w AT g_row,g_col WITH FORM "amd/42f/amdp011"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()

   WHILE TRUE
       MESSAGE ""
       LET g_amd05 = NULL 
       LET g_amd25 = NULL
       CALL ui.Interface.refresh()
       CONSTRUCT BY NAME g_wc ON amd05,amd25  
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
       ON ACTION CONTROLP
           IF INFIELD(amd25) THEN
               LET g_amd05 =  GET_FLDBUF(amd05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_amd25"
               LET g_qryparam.state = "c"
              #FUN-B90079 begin-----
               IF NOT cl_null(g_amd05) THEN
                  LET g_qryparam.where = " ome02 = '",g_amd05,"'" 
               END IF 
              #FUN-B90079 end-------
#              LET g_qryparam.arg1 = g_amd05                   #FUN-B90079 mark
               CALL cl_create_qry() RETURNING g_amd25
               DISPLAY g_amd25 TO amd25
               NEXT FIELD amd25
           END IF
 
       ON ACTION locale          
          LET g_change_lang = TRUE                  
          EXIT CONSTRUCT
    
       ON ACTION exit             
          LET INT_FLAG = 1
          EXIT CONSTRUCT
    
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
    
       END CONSTRUCT
       IF cl_null(g_wc) THEN 
           LET g_wc = " 1=1 "
       END IF   
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           CLOSE WINDOW p011_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      
           EXIT PROGRAM
       END IF
       IF g_change_lang THEN 
          LET g_change_lang  = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
          CONTINUE WHILE
       END IF

       INPUT g_amd22,g_bgjob 
             WITHOUT DEFAULTS
             FROM amd22,bgjob

      #MOD-D10130--str
       AFTER FIELD amd22
          SELECT COUNT(*) INTO l_n FROM ama_file
           WHERE ama01 = g_amd22
          IF l_n=0 THEN
             CALL cl_err3("sel","ama_file",g_amd22,"","amd-002","","",1) 
             NEXT FIELD amd22
          END IF
      #MOD-D10130--end       
    
       AFTER INPUT
     
       ON ACTION CONTROLP
     
           IF INFIELD(amd22) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ama"
               LET g_qryparam.default1 = g_amd22
               CALL cl_create_qry() RETURNING g_amd22
               DISPLAY BY NAME g_amd22
               NEXT FIELD amd22
           END IF
      
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
   
        ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
   
        ON ACTION about         
           CALL cl_about()      
   
        ON ACTION help          
           CALL cl_show_help()  
   
        ON ACTION exit      #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
           ON ACTION qbe_save
              CALL cl_qbe_save()
   
       END INPUT
       IF INT_FLAG THEN 
           LET INT_FLAG = 0 
           CLOSE WINDOW p011_w 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      
           EXIT PROGRAM
       END IF
     
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 ='amdp011'
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('amdp011','9031',1)
          ELSE
             LET g_wc = cl_replace_str(g_wc,"'","\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",g_wc CLIPPED,"'",
                          " '",g_amd22 CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'" 
             CALL cl_cmdat('amdp011',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p011_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
       END IF
     EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p011_p()
   DEFINE l_sql           STRING
   DEFINE l_str           STRING
   DEFINE l_str1          STRING  
#  DEFINE l_omj           RECORD LIKE omj_file.*          #FUN-B90079 mark
   DEFINE l_ome           RECORD LIKE ome_file.*          #FUN-B90079
   DEFINE l_amd           RECORD LIKE amd_file.*
   DEFINE l_msg           LIKE type_file.chr20
#FUN-B90079 add begin ---
   DEFINE l_ome01         LIKE ome_file.ome01      
   DEFINE l_ome011        LIKE ome_file.ome011  
   DEFINE l_ome011_s      STRING 
   DEFINE l_ome011_str    STRING                 
   DEFINE l_ome011_end    STRING     
   DEFINE l_ome011_new    LIKE ome_file.ome011,
          l_ome78         LIKE ome_file.ome78,
          l_ome79         LIKE ome_file.ome79,
          l_ome80         LIKE ome_file.ome80,
          l_sn            LIKE ome_file.ome011,
          l_ome59x        LIKE ome_file.ome59x    
   DEFINE   li_i          LIKE type_file.num10      
   DEFINE   ls_format     STRING
#FUN-B90079 add end ---
   LET l_sql = "DELETE FROM amd_file WHERE amd021 = '6' AND ",g_wc CLIPPED
   PREPARE del_pre FROM l_sql
   EXECUTE del_pre
   IF SQLCA.SQLCODE THEN
      LET l_msg = "DELETE FROM amd_file "
      CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)   
      LET g_success = 'N'
      RETURN
   END IF 
#  INITIALIZE l_omj.* TO NULL                                            #FUN-B90079 mark
   INITIALIZE l_ome.* TO NULL
   LET l_str1 = g_wc CLIPPED 
   IF g_wc != " 1=1 " THEN 
#     CALL cl_replace_str(l_str1,'amd05','omj001') RETURNING l_str1      #FUN-B90079 mark
#     CALL cl_replace_str(l_str1,'amd25','omj002') RETURNING l_str1      #FUN-B90079 mark
      CALL cl_replace_str(l_str1,'amd05','ome02') RETURNING l_str1       #FUN-B90079
      CALL cl_replace_str(l_str1,'amd25','ome73') RETURNING l_str1       #FUN-B90079
   END IF  
#  LET l_sql = "SELECT * FROM omj_file WHERE ",l_str1 CLIPPED            #FUN-B90079 mark 
   LET l_sql = "SELECT * FROM ome_file WHERE ome70 = 'Y' AND ome00 = '1' AND ",l_str1 CLIPPED,   #FUN-B90079
               " ORDER BY ome01 "                                                                #FUN-B90079
   PREPARE p011_pre FROM l_sql
   DECLARE p011_cur CURSOR FOR p011_pre
#  FOREACH p011_cur INTO l_omj.*                      #FUN-B90079 mark
   FOREACH p011_cur INTO l_ome.*                      #FUN-B90079
     INITIALIZE l_amd.* TO NULL 
     LET l_amd.amd173 = YEAR(l_ome.ome02) 
     LET l_amd.amd174 = MONTH(l_ome.ome02)
     LET l_amd.amd021 = '6'
     LET l_str = l_amd.amd173 using '&&&&',l_amd.amd174 using'&&'	
     CASE g_aza.aza41	
        WHEN "1"	
           LET l_amd.amd01 = 'zzz-',l_str	
        WHEN "2"	
           LET l_amd.amd01 = 'zzzz-',l_str	
        WHEN "3"	
           LET l_amd.amd01 = 'zzzzz-',l_str	
     END CASE	
#FUN-B90079 begin-----
#    LET l_amd.amd03 = l_omj.omj007
#    LET l_amd.amd031 = l_omj.omj005
#    LET l_amd.amd032 = l_omj.omj008
#    LET l_amd.amd033 = l_omj.omj020
#    LET l_amd.amd04 = l_omj.omj021
#    LET l_amd.amd05 = l_omj.omj001
#    LET l_amd.amd06 = l_omj.omj015
#    LET l_amd.amd07 = l_omj.omj017
#    LET l_amd.amd08 = l_omj.omj016
#    IF NOT cl_null(l_amd.amd032) AND l_amd.amd03 <> l_amd.amd032 THEN     
#      # 表示此為連續的發票號資料	
#       LET l_amd.amd09 = 'A'	
#    ELSE	
#      # 表示此為非連續的發票號資料	
#       LET l_amd.amd09 = NULL	
#   END IF
#    LET l_amd.amd171 = l_omj.omj019
#    LET l_amd.amd172 = l_omj.omj006
#    LET l_amd.amd22 = g_amd22
#    LET l_amd.amd25 = l_omj.omj002
#    LET l_amd.amd26 = YEAR(l_omj.omj001)
#    LET l_amd.amd27 = MONTH(l_omj.omj001)
#    LET l_amd.amd30 = 'Y'
#    LET l_amd.amd44 = '3'
#    LET l_amd.amd126 = l_omj.omj003
#    LET l_amd.amdacti = 'Y'
#    LET l_amd.amduser = g_user
#    LET l_amd.amdgrup = g_grup
#    LET l_amd.amddate = g_today
#    LET l_amd.amdlegal = g_legal
#    LET l_amd.amdoriu = g_user
#    LET l_amd.amdorig = g_grup
#    IF cl_null(l_amd.amd033) THEN 
#       LET l_amd.amd033 = '1' 
#    END IF 
#    IF cl_null(l_amd.amd06) THEN 
#       LET l_amd.amd06 = 0
#    END IF
#    IF cl_null(l_amd.amd07) THEN 
#       LET l_amd.amd07 = 0 
#    END IF
#    IF cl_null(l_amd.amd08) THEN 
#       LET l_amd.amd08 = 0
#    END IF
#    INSERT INTO amd_file VALUES (l_amd.*)   
#    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#       LET g_success = 'N'
#       LET l_msg = l_amd.amd01,'+',l_amd.amd02
#       CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
#       INITIALIZE l_omj.* TO NULL
#       CONTINUE FOREACH
#    END IF
#    INITIALIZE l_omj.* TO NULL 
#FUN-B90079 end-------
#FUN-B90079 ADD begin-----
     LET l_amd.amd021 = '6'
     LET l_amd.amd031 = l_ome.ome212
     LET l_amd.amd033 = l_ome.ome77
     LET l_amd.amd04 = l_ome.ome042
     LET l_amd.amd05 = l_ome.ome02
     LET l_amd.amd171 = l_ome.ome171
     LET l_amd.amd175 = NULL
     LET l_amd.amd22 = g_amd22
     LET l_amd.amd25 = l_ome.ome73
     LET l_amd.amd30 = 'Y'
     LET l_amd.amd44 = '3'
     LET l_amd.amd126 = l_ome.ome71
     LET l_amd.amdacti = 'Y'
     LET l_amd.amduser = g_user
     LET l_amd.amdgrup = g_grup
     LET l_amd.amddate = NULL
     LET l_amd.amdoriu = NULL   
     LET l_amd.amdlegal = l_ome.omelegal
     LET l_amd.amdoriu = g_user
     LET l_amd.amdorig = g_grup
#     LET l_sql = "SELECT ome01 FROM ome_file ",
#                 " WHERE ome70 = 'Y' AND ome00 = '1' AND ",l_str1 CLIPPED,
#                 " ORDER BY ome01 "
#     PREPARE p011_pre_1 FROM l_sql
#     DECLARE p011_cur_1 CURSOR FOR p011_pre_1
#     FOREACH p011_cur_1 INTO l_ome01 
    #FUN-B90144 add begin---
       SELECT omevoid INTO l_ome.omevoid
         FROM ome_file
        WHERE ome70 = 'Y'
          AND ome00 = '1'
          AND ome01 = l_ome.ome01
        IF l_ome.omevoid = 'Y' THEN
           LET l_amd.amd03 = l_ome.ome01
           LET l_amd.amd032 = ''    
          #------------MOD-BC0254------------start
          #LET l_amd.amd06 = l_ome.ome59t
          #LET l_amd.amd07 = l_ome.ome59x
          #LET l_amd.amd08 = l_ome.ome59
           LET l_amd.amd04 = ' '
           LET l_amd.amd06 = 0
           LET l_amd.amd07 = 0
           LET l_amd.amd08 = 0
          #------------MOD-BC0254--------------end
           LET l_amd.amd09 = NULL
           LET l_amd.amd172 = 'F'
           SELECT max(amd02) INTO l_amd.amd02
             FROM amd_file
            WHERE amd01 = l_amd.amd01
              AND amd021= l_amd.amd021
           IF cl_null(l_amd.amd02) THEN LET l_amd.amd02 = 0 END IF
           LET l_amd.amd02 = l_amd.amd02 + 1
           INSERT INTO amd_file VALUES (l_amd.*)
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
              LET g_success = 'N'
              LET l_msg = l_amd.amd01,'+',l_amd.amd02
              CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
           END IF
       END IF
    #FUN-B90144 add end----
       SELECT ome011 INTO l_ome011 
         FROM ome_file
        WHERE ome01 = l_ome.ome01
          AND ome00 = '1'
       IF SQLCA.sqlcode = 100 THEN
          CONTINUE FOREACH
       END IF          
       IF cl_null(l_ome011) THEN
          LET l_ome011 = l_ome.ome01
       END IF 
       IF l_ome011 <= l_ome011_new THEN
          CONTINUE FOREACH
       END IF 
       LET l_ome011_s = l_ome011
       WHILE TRUE
           LET l_ome011_str = l_ome011_s.subString(1,2)
           LET l_ome011_end = l_ome011_s.subString(3,l_ome011_s.getLength())
           LET ls_format = ""
           FOR li_i = 1 TO l_ome011_end.getLength()
               LET ls_format = ls_format,"&"
           END FOR
           LET l_sn = (l_ome011_end + 1) USING ls_format
           LET l_ome011_new = l_ome011_str,l_sn
           SELECT ome011  
             FROM ome_file
            WHERE ome01 = l_ome011_new
              AND ome00 = '1'
              AND ome71 = l_ome.ome71    #CHI-C90016 add
           IF SQLCA.sqlcode = 100 THEN
              LET l_ome011_new = l_ome011_str,l_ome011_end
              EXIT WHILE              
           ELSE             
              LET l_ome011_s = l_ome011_new
              CONTINUE WHILE
           END IF 
       END WHILE
       LET l_ome011 = l_ome011_new
       SELECT SUM(ome78),SUM(ome79),SUM(ome80),SUM(ome59x) 
         INTO l_ome78,l_ome79,l_ome80,l_ome59x
         FROM ome_file
        WHERE ome01 >= l_ome.ome01 
          AND ome011 <= l_ome011
          AND omevoid <> 'Y'                     #FUN-B90144  add
       IF l_ome78 >= 0 THEN       
         LET l_amd.amd03 = l_ome.ome01
         LET l_amd.amd032 = l_ome011
         LET l_amd.amd06 = l_ome78
         LET l_amd.amd07 = l_ome59x
         LET l_amd.amd08 = l_ome78 - l_ome59x
         IF l_amd.amd03 <> l_amd.amd032 THEN
            LET l_amd.amd09 = 'A' 
         ELSE 
            LET l_amd.amd09 = NULL
         END IF 
         LET l_amd.amd172 = '1'
         SELECT max(amd02) INTO l_amd.amd02
           FROM amd_file
          WHERE amd01 = l_amd.amd01
            AND amd021= l_amd.amd021
         IF cl_null(l_amd.amd02) THEN LET l_amd.amd02 = 0 END IF
         LET l_amd.amd02 = l_amd.amd02 + 1
         INSERT INTO amd_file VALUES (l_amd.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            LET l_msg = l_amd.amd01,'+',l_amd.amd02
            CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
            INITIALIZE l_ome.* TO NULL
            CONTINUE FOREACH
         END IF
       END IF  
       IF l_ome79 >= 0 THEN
          LET l_amd.amd03 = l_ome.ome01
          LET l_amd.amd032 = l_ome011
          LET l_amd.amd06 = l_ome79
          LET l_amd.amd07 = 0
          LET l_amd.amd08 = l_ome79
          IF l_amd.amd03 <> l_amd.amd032 THEN
             LET l_amd.amd09 = 'A'
          ELSE
             LET l_amd.amd09 = NULL
          END IF
          LET l_amd.amd172 = '2'
          SELECT max(amd02) INTO l_amd.amd02
            FROM amd_file
           WHERE amd01 = l_amd.amd01
             AND amd021= l_amd.amd021
          IF cl_null(l_amd.amd02) THEN LET l_amd.amd02 = 0 END IF
          LET l_amd.amd02 = l_amd.amd02 + 1
          INSERT INTO amd_file VALUES (l_amd.*)
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             LET g_success = 'N'
             LET l_msg = l_amd.amd01,'+',l_amd.amd02
             CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
             INITIALIZE l_ome.* TO NULL
             CONTINUE FOREACH
          END IF
       END IF
       IF l_ome80 >= 0 THEN
          LET l_amd.amd03 = l_ome.ome01
          LET l_amd.amd032 = l_ome011
          LET l_amd.amd06 = l_ome80
          LET l_amd.amd07 = 0
          LET l_amd.amd08 = l_ome80
          IF l_amd.amd03 <> l_amd.amd032 THEN
             LET l_amd.amd09 = 'A'
          ELSE
             LET l_amd.amd09 = NULL
          END IF
          LET l_amd.amd172 = '3'
          SELECT max(amd02) INTO l_amd.amd02
            FROM amd_file
           WHERE amd01 = l_amd.amd01
             AND amd021= l_amd.amd021
          IF cl_null(l_amd.amd02) THEN LET l_amd.amd02 = 0 END IF
          LET l_amd.amd02 = l_amd.amd02 + 1
          INSERT INTO amd_file VALUES (l_amd.*)
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             LET g_success = 'N'
             LET l_msg = l_amd.amd01,'+',l_amd.amd02
             CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
             INITIALIZE l_ome.* TO NULL
             CONTINUE FOREACH
          END IF
       END IF       
#FUN-B90144 mark begin-----
#       IF l_ome.omevoid = 'Y' THEN
#          LET l_amd.amd03 = l_ome.ome01
#          LET l_amd.amd032 = l_ome011
#          LET l_amd.amd06 = l_ome.ome59t
#          LET l_amd.amd07 = l_ome.ome59x
#          LET l_amd.amd08 = l_ome.ome59
#          IF l_amd.amd03 <> l_amd.amd032 THEN
#            LET l_amd.amd09 = 'A'
#          ELSE
#            LET l_amd.amd09 = NULL
#          END IF
#          LET l_amd.amd172 = 'F'
#          SELECT max(amd02) INTO l_amd.amd02
#            FROM amd_file
#           WHERE amd01 = l_amd.amd01
#             AND amd021= l_amd.amd021
#          IF cl_null(l_amd.amd02) THEN LET l_amd.amd02 = 0 END IF
#          LET l_amd.amd02 = l_amd.amd02 + 1
#          INSERT INTO amd_file VALUES (l_amd.*)
#          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            LET g_success = 'N'
#            LET l_msg = l_amd.amd01,'+',l_amd.amd02
#            CALL s_errmsg('ins','',l_msg,SQLCA.SQLCODE,1)
#            INITIALIZE l_ome.* TO NULL
#            CONTINUE FOREACH
#          END IF
#       END IF 
#FUN-B90144 mark end------
       INITIALIZE l_ome.* TO NULL
#FUN-B90079 ADD end-------
   END FOREACH 
END FUNCTION

#NO:FUN-B40040
