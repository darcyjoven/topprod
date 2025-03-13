# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdp200.4gl
# Descriptions...: 標準成本更新料件主檔標準成本作業
# Date & Author..: 06/11/23 By rainy
# Modify.........: No.TQC-6B0193 06/12/05 By jamie 將asdp200改為asdp200
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920378 09/03/02 By Pengu 在INSERT/UPDTE _imb_file時會出現不可將null寫入不可空白欄位訊息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy,mm      SMALLINT,
       g_wc       STRING,                  #No.FUN-580092   HCN
       g_flag          LIKE type_file.chr1
DEFINE l_flag          LIKE type_file.chr1,
       g_change_lang   LIKE type_file.chr1,
       ls_date         STRING              #->No.FUN-570153

MAIN
   OPTIONS                                 #No.TQC-6B0193 add
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc  = ARG_VAL(1)                      
   LET yy    = ARG_VAL(2)                      
   LET mm    = ARG_VAL(3)                      
   LET g_bgjob  = ARG_VAL(4)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N"  THEN 
         CLEAR FORM
         CALL p200_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL p200()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p200_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p200_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p200()
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
 
FUNCTION p200_ask()
   DEFINE   c     LIKE type_file.chr20
   DEFINE lc_cmd  LIKE type_file.chr500
 
   OPEN WINDOW p200_w WITH FORM "asd/42f/asdp200" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   CALL cl_opmsg('q')
 
   LET yy = YEAR(g_today)
   LET mm = MONTH(g_today)
 
   CONSTRUCT BY NAME g_wc ON stb01 
      BEFORE CONSTRUCT
             CALL cl_qbe_init()
      ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(stb01) 
#FUN-AA0059---------mod------------str-----------------                                                            
#            CALL cl_init_qry_var()                                              
#            LET g_qryparam.form = "q_ima"                                       
#            LET g_qryparam.state = "c"                                          
#            CALL cl_create_qry() RETURNING g_qryparam.multiret  
             CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------                
            DISPLAY g_qryparam.multiret TO stb01                                
            NEXT FIELD stb01                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_wc=g_wc CLIPPED," AND stb01 NOT MATCHES 'MISC*'"
   LET g_bgjob = 'N'    # FUN-570153
 
   INPUT BY NAME yy,mm,g_bgjob WITHOUT DEFAULTS    #NO.FUN-570153 
 
      AFTER FIELD yy
         IF cl_null(yy) THEN 
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
         IF cl_null(mm) THEN
            NEXT FIELD mm
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p200_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
 
         #IF yy*12+mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
         #   NEXT FIELD yy
         #END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
 
#->No.FUN-570153 ---start---   
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "asdp200"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('asdp200','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",yy CLIPPED ,"'",
                      " '",mm CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('asdp200',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#->No.FUN-570153 ---end---   
 
END FUNCTION
 
FUNCTION p200()
  DEFINE l_sql        STRING,       #NO.FUN-910082  
         l_stb RECORD 
                 stb01  LIKE stb_file.stb01,
                 stb04  LIKE stb_file.stb04,
                 stb05  LIKE stb_file.stb05,
                 stb06  LIKE stb_file.stb06,
                 stb06a LIKE stb_file.stb06a,
                 stb07  LIKE stb_file.stb07,
                 stb08  LIKE stb_file.stb08,
                 stb09  LIKE stb_file.stb09,
                 stb09a LIKE stb_file.stb09a,
                 sta08  LIKE sta_file.sta08
               END RECORD
 
  DEFINE l_imb121  LIKE imb_file.imb121,
         l_imb1231 LIKE imb_file.imb1231,
         l_imb124  LIKE imb_file.imb124,
         l_imb130  LIKE imb_file.imb130
  
   LET l_sql = "SELECT stb01,stb04,stb05,stb06,stb06a,",
               "       stb07,stb08,stb09,stb09a,sta08 ",
               " FROM stb_file LEFT OUTER JOIN sta_file ON stb_file.stb01=sta_file.sta01  ",
               " WHERE ",g_wc CLIPPED,
               "   AND stb02 = '",yy,"'",
               "   AND stb03 = ",mm
   PREPARE p200_pre FROM l_sql
   DECLARE p200_c1 CURSOR FOR p200_pre
 
   FOREACH p200_c1 INTO l_stb.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
      LET l_imb121  = l_stb.stb07 - l_stb.stb04
      LET l_imb1231 = l_stb.stb08 - l_stb.stb05
      LET l_imb124  = l_stb.stb09 - l_stb.stb06
      LET l_imb130  = l_stb.stb09a - l_stb.stb06a
     #-----------------No.MOD-920378 add
      IF cl_null(l_imb121) THEN LET l_imb121 = 0 END IF
      IF cl_null(l_imb1231) THEN LET l_imb1231 = 0 END IF
      IF cl_null(l_imb124) THEN LET l_imb124 = 0 END IF
      IF cl_null(l_imb130) THEN LET l_imb130 = 0 END IF
      IF cl_null(l_stb.stb04) THEN LET l_stb.stb04 = 0 END IF
      IF cl_null(l_stb.stb05) THEN LET l_stb.stb05 = 0 END IF
      IF cl_null(l_stb.stb06) THEN LET l_stb.stb06 = 0 END IF
      IF cl_null(l_stb.stb06a) THEN LET l_stb.stb06a = 0 END IF
     #-----------------No.MOD-920378 end
 
      INSERT INTO imb_file(imb01    ,imb111  ,imb1131 ,imb114  ,imb120  ,
                           imb121   ,imb1231 ,imb124  ,imb130  ,imb116  ,
                           imb112   ,imb1132 ,imb115  ,imb1151 ,imb1171 ,
                           imb1172  ,imb119  ,imb118  ,imb122  ,imb1232 ,
                           imb125   ,imb1251 ,imb126  ,imb1271 ,imb1272 ,
                           imb129   ,imb211  ,imb212  ,imb2131 ,imb2132 ,
                           imb214   ,imb215  ,imb2151 ,imb216  ,imb2171 ,
                           imb2172  ,imb219  ,imb218  ,imb220  ,imb221  ,
                           imb222   ,imb2231 ,imb2232 ,imb224  ,imb225  ,
                           imb2251  ,imb226  ,imb2271 ,imb2272 ,imb229  ,
                           imb230   ,imb311  ,imb312  ,imb3131 ,imb3132 ,
                           imb314   ,imb315  ,imb3151 ,imb316  ,imb3171 ,
                           imb3172  ,imb319  ,imb318  ,imb320  ,imb321  ,
                           imb322   ,imb3231 ,imb3232 ,imb324  ,imb325  ,
                           imb3251  ,imb326  ,imb3271 ,imb3272 ,imb329  ,
                           imb330   , 
                           imbacti  ,imbuser ,imbgrup ,imbmodu ,imbdate,imboriu,imborig)
                  VALUES(l_stb.stb01 ,l_stb.stb04 ,l_stb.stb05 ,l_stb.stb06,
                         l_stb.stb06a,l_imb121    ,l_imb1231   ,l_imb124,
                         l_imb130    ,l_stb.sta08 ,
                         0,0,0,0,0,0,0,0,0,0,
                         0,0,0,0,0,0,0,0,0,0,
                         0,0,0,0,0,0,0,0,0,0,
                         0,0,0,0,0,0,0,0,0,0,
                         0,0,0,0,0,0,0,0,0,0,
                         0,0,0,0,0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         'Y' ,g_user ,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
     #IF STATUS=-239 OR STATUS=-268 THEN #CHI-790021
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #CHI-790021
         UPDATE imb_file SET imb111  = l_stb.stb04,
                             imb1131 = l_stb.stb05,
                             imb114  = l_stb.stb06,
                             imb120  = l_stb.stb06a,   
                             imb121  = l_imb121,
                             imb1231 = l_imb1231,
                             imb124  = l_imb124,
                             imb130  = l_imb130,
                             imb116  = l_stb.sta08
          WHERE imb01 = l_stb.stb01
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("upd","imb_file",l_stb.stb01,"",STATUS,"","upd imb",0)   
             LET g_success = 'N'
          END IF
       ELSE
          IF STATUS THEN
             CALL cl_err3("upd","imb_file",l_stb.stb01,"",STATUS,"","ins imb:",1)   
             LET g_success = 'N'
          END IF
       END IF
    END FOREACH
                         
END FUNCTION
