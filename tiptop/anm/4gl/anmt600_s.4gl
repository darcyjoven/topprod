# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmt600_s.4gl
# Descriptions...: 投資費用資料維護作業
#Date & Author..: 00/07/14 By Mandy
 # Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/02/03 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740049 07/04/12 By hongmei 會計科目加帳套
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/25 By lilingyu 科目查詢自動過濾 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION anmt600_s(p_no,p_cmd)
#   DEFINE p_no	 VARCHAR(10)
   DEFINE p_no		LIKE gsg_file.gsg01     #No.FUN-680107 VARCHAR(16)   #No.FUN-550057
   DEFINE p_cmd		LIKE type_file.chr1     # u:update d:display only        #No.FUN-680107 VARCHAR(1)
   DEFINE i,j,s		LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_gsg   DYNAMIC ARRAY OF RECORD
                    gsg02		LIKE gsg_file.gsg02,
                    gsg03		LIKE gsg_file.gsg03,
                    gsf02   LIKE gsf_file.gsf02,
                    gsg05   LIKE gsg_file.gsg05,
                    gsg06   LIKE gsg_file.gsg06
                    END RECORD,
    l_n             LIKE type_file.num5,                #No.FUN-680107 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680107 SMALLINT
    l_gsg02_t       LIKE gsg_file.gsg02
   WHENEVER ERROR CONTINUE
   IF p_no IS NULL THEN RETURN END IF
   OPEN WINDOW t600_s_w AT 5,3 WITH FORM "anm/42f/anmt600_s"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("anmt600_s")
 
       
   DECLARE t600_s_c CURSOR FOR
    SELECT gsg02,gsg03,gsf02,gsg05,gsg06
      FROM gsg_file LEFT JOIN gsf_file ON gsg03 = gsf_file.gsf01
     WHERE gsg01 = p_no 
     ORDER BY gsg02
 
   CALL l_gsg.clear()
   LET i = 1
   FOREACH t600_s_c INTO l_gsg[i].*
      IF STATUS THEN
         CALL cl_err('foreach gsg',STATUS,0)    
         EXIT FOREACH
      END IF 
      LET i = i + 1
      IF i > 100 THEN
         EXIT FOREACH
      END IF
   END FOREACH
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_gsg TO s_gsg.*
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END DISPLAY
      CLOSE WINDOW t600_s_w
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_gsg WITHOUT DEFAULTS FROM s_gsg.* 
    #    ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
         ATTRIBUTE(COUNT=l_gsg.getLength(),MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         CALL fgl_set_arr_curr(i)
      
      BEFORE ROW
         LET i=ARR_CURR()
         LET l_gsg02_t=l_gsg[i].gsg02
      
      BEFORE FIELD gsg02                        #default 序號
         IF cl_null(l_gsg[i].gsg02) OR l_gsg[i].gsg02 = 0 THEN
            IF i=1 THEN
               LET l_gsg[i].gsg02 = 1
            ELSE
               LET l_gsg[i].gsg02=l_gsg[i-1].gsg02+1
            END IF
         END IF
      
      AFTER FIELD gsg02
         IF NOT cl_null(l_gsg[i].gsg02) THEN
            IF l_gsg[i].gsg02 != l_gsg02_t OR l_gsg02_t IS NULL THEN
               FOR j=1 TO 100 
                  IF j!=i THEN
                     IF l_gsg[i].gsg02=l_gsg[j].gsg02 THEN
                        LET l_gsg[i].gsg02 = l_gsg02_t      
                        CALL cl_err('',-239,0) NEXT FIELD gsg02
                     END IF
                  END IF
               END FOR 
            END IF
         END IF
           
      AFTER FIELD gsg03
         IF NOT cl_null(l_gsg[i].gsg03) THEN 
            SELECT gsf02 INTO l_gsg[i].gsf02 FROM gsf_file
                WHERE gsf01 = l_gsg[i].gsg03
            IF STATUS THEN
#              CALL cl_err ('select gsf',STATUS,0)   #No.FUN-660148
               CALL cl_err3("sel","gsf_file",l_gsg[i].gsg03,"",STATUS,"","select gsf",1)  #No.FUN-66014
               NEXT FIELD gsg03 
            ELSE
               DISPLAY l_gsg[i].gsf02 TO s_gsg[i].gsf02
               SELECT gsf04 INTO l_gsg[i].gsg06 FROM gsf_file
                WHERE gsf01=l_gsg[i].gsg03
               DISPLAY l_gsg[i].gsg06 TO s_gsg[i].gsg06
            END IF   
         END IF
      
      AFTER FIELD gsg06
         IF NOT cl_null(l_gsg[i].gsg06) THEN 
            SELECT aag01 FROM aag_file
             WHERE aag01 = l_gsg[i].gsg06
               AND aag00 = g_aza.aza81     #No.FUN-740049
            IF STATUS THEN
#              CALL cl_err ('select aag',STATUS,0)   #No.FUN-660148
               CALL cl_err3("sel","aag_file",l_gsg[i].gsg06,"",STATUS,"","select aag",0)  #No.FUN-660148   #FUN-B10052 "1"->"0"
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = l_gsg[i].gsg06
               LET g_qryparam.construct = 'N'
               LET g_qryparam.arg1 = g_aza.aza81           
               LET g_qryparam.where = " aag01 LIKE '",l_gsg[i].gsg06 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_gsg[i].gsg06
                DISPLAY l_gsg[i].gsg06 TO gsg06             
#FUN-B10052 --end--
               NEXT FIELD gsg06
            END IF   
         END IF
      
      AFTER DELETE
         LET l_n = ARR_COUNT()
         INITIALIZE l_gsg[l_n+1].* TO NULL
      
      ON ACTION controlp
         CASE
            WHEN INFIELD (gsg03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gsf"
               LET g_qryparam.default1 = l_gsg[i].gsg03
               CALL cl_create_qry() RETURNING l_gsg[i].gsg03
#               CALL FGL_DIALOG_SETBUFFER( l_gsg[i].gsg03 )
               SELECT gsf02,gsf04 INTO l_gsg[i].gsf02,l_gsg[i].gsg06
                 FROM gsf_file
                WHERE gsf01 = l_gsg[i].gsg03
                DISPLAY l_gsg[i].gsf02 TO gsf02            #No.MOD-490344
                DISPLAY l_gsg[i].gsg06 TO gsg06            #No.MOD-490344
               NEXT FIELD gsg03
            WHEN INFIELD (gsg06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = l_gsg[i].gsg06
               LET g_qryparam.arg1 = g_aza.aza81            #No.FUN-740049
               CALL cl_create_qry() RETURNING l_gsg[i].gsg06
#               CALL FGL_DIALOG_SETBUFFER( l_gsg[i].gsg06 )
                DISPLAY l_gsg[i].gsg06 TO gsg06             #No.MOD-490344
               NEXT FIELD gsg06
            OTHERWISE EXIT CASE
         END CASE 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
   CLOSE WINDOW t600_s_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_success ='Y' 
   BEGIN WORK
   DELETE FROM gsg_file WHERE gsg01 = p_no
   CALL s_showmsg_init()    #No.FUN-710028
   FOR i = 1 TO l_gsg.getLength()
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
      IF cl_null(l_gsg[i].gsg02) THEN CONTINUE FOR END IF
      IF cl_null(l_gsg[i].gsg03) THEN CONTINUE FOR END IF
      #FUN-980005 add legal 
      INSERT INTO gsg_file(gsg01,gsg02,gsg03,gsg05,gsg06,gsglegal)VALUES
                          (p_no,l_gsg[i].gsg02,l_gsg[i].gsg03
                               ,l_gsg[i].gsg05,l_gsg[i].gsg06,g_legal) 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('INS-gsg',SQLCA.sqlcode,0)   #No.FUN-660148
#        CALL cl_err3("ins","gsg_file",p_no,l_gsg[i].gsg02,SQLCA.sqlcode,"","INS-gsg",1)  #No.FUN-660148 #No.FUN-710024
         LET g_showmsg = p_no,"/",l_gsg[i].gsg02  #No.FUN-710024
         CALL s_errmsg('gsg01,gsg02',g_showmsg,'INS-gsg',SQLCA.sqlcode,1)   #No.FUN-710024
#        LET g_success = 'N' EXIT FOR      #No.FUN-710024 
         LET g_success = 'N' CONTINUE FOR  #No.FUN-710024
      END IF
   END FOR
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 -end
 
   CALL s_showmsg() #No.FUN-710028
   IF g_success='Y' THEN 
      COMMIT WORK
   ELSE 
      ROLLBACK WORK
   END IF
END FUNCTION
