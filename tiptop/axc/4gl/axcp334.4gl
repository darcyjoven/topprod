# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcp334.4gl
# Descriptions...: 標準成本更新料件主檔標準成本作業
# Date & Author..: 06/11/23 By rainy
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-790087 07/09/17 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-8A0086 08/12/21 By lutingting完善報錯訊息修改 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy,mm      LIKE type_file.num5,     #No.FUN-680098   SMALLINT
       g_wc       string,                  #No.FUN-580092   HCN
       g_flag     LIKE type_file.chr1      #No.FUN-680098   VARCHAR(01)
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570153   #No.FUN-680098 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    #是否有做語言切換 No.FUN-570153 VARCHAR(1)
       ls_date         STRING                  #->No.FUN-570153
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680098  SMALLINT
MAIN
 
   OPTIONS
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
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N"  THEN 
         CLEAR FORM
         CALL p334_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL p334()
            CALL s_showmsg()        #No.FUN-710027
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
               CLOSE WINDOW p334_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p334_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p334()
         CALL s_showmsg()        #No.FUN-710027  
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#  CALL cl_used('axcp334',g_time,2) RETURNING g_time   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN
 
FUNCTION p334_ask()
   DEFINE   c     LIKE type_file.chr20       #No.FUN-680098  VARCHAR(10)
   DEFINE lc_cmd  LIKE type_file.chr1000     #No.FUN-570153  #No.FUN-680098 VARCHAR(500)
 
   LET p_row = 1 LET p_col = 1
   
   OPEN WINDOW p334_w AT p_row,p_col WITH FORM "axc/42f/axcp334" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   
   CALL cl_opmsg('q')
 
   LET yy = YEAR(g_today)
   LET mm = MONTH(g_today)
 
 
   DISPLAY BY NAME yy,mm
 
   ERROR ''
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
    #--
 
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
      CLOSE WINDOW p334_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_wc=g_wc CLIPPED," AND stb01 NOT LIKE 'MISC%'"
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
            CLOSE WINDOW p334_w
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
      CLOSE WINDOW p334_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp334"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp334','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",yy CLIPPED ,"'",
                      " '",mm CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp334',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p334_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#->No.FUN-570153 ---end---   
 
END FUNCTION
 
FUNCTION p334()
  DEFINE l_sql     LIKE type_file.chr1000,  #No.FUN-680098 VARCHAR(300)
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
               " FROM stb_file, sta_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND stb01 = sta_file.sta01",
               "   AND stb02 = '",yy,"'",
               "   AND stb03 = ",mm
   PREPARE p334_pre FROM l_sql
   DECLARE p334_c1 CURSOR FOR p334_pre
 
   CALL s_showmsg_init()   #No.FUN-710027 
   FOREACH p334_c1 INTO l_stb.*
      IF STATUS THEN 
#         CALL cl_err('foreach:',STATUS,0)         #No.FUN-710027
         CALL s_errmsg('','','foreach:',STATUS,0)  #No.FUN-710027
         LET g_success = 'N'                       #No.FUN-8A0086
         EXIT FOREACH 
      END IF
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success='Y'   
         END IF 
#No.FUN-710027--end
      LET l_imb121  = l_stb.stb07 - l_stb.stb04
      LET l_imb1231 = l_stb.stb08 - l_stb.stb05
      LET l_imb124  = l_stb.stb09 - l_stb.stb06
      LET l_imb130  = l_stb.stb09a - l_stb.stb06a
 
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
     #IF SQLCA.SQLCODE=-239 OR SQLCA.SQLCODE=-268 THEN   #TQC-790087 mark
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN            #TQC-790087
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
          IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
#             CALL cl_err3("upd","imb_file",l_stb.stb01,"",SQLCA.SQLCODE,"","upd imb",0)    #No.FUN-710027
             CALL s_errmsg('imb01',l_stb.stb01,'upd imb',SQLCA.SQLCODE,1)                      #No.FUN-710027
             LET g_success = 'N'
          END IF
       ELSE
          IF SQLCA.SQLCODE THEN
#             CALL cl_err3("upd","imb_file",l_stb.stb01,"",SQLCA.SQLCODE,"","ins imb:",1)    #No.FUN-710027
             CALL s_errmsg('imb01',l_stb.stb01,'upd imb',SQLCA.SQLCODE,1)                      #No.FUN-710027
             LET g_success = 'N'
          END IF
       END IF
    END FOREACH
#No.FUN-710027--begin 
    IF g_totsuccess="N" THEN
         LET g_success="N"
    END IF 
#No.FUN-710027--end
 
                         
END FUNCTION
