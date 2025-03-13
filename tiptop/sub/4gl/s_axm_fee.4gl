# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_axm_fee.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: 95/11/06 By Danny 1.加^P查詢費用明細
#                                    2.在after field oef04 加判斷
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: NO.FUN-670091 06/07/24 BY yiting cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-960158 09/06/24 By lilingyu 費用資料ACTION:單身輸入完一行后,進入到下一行沒有做KEY值檢查,重復也可以輸入
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_chr		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
FUNCTION s_axm_fee(p_no,p_cmd)
   DEFINE ls_tmp    STRING
   DEFINE p_no      LIKE oef_file.oef01 	#No.FUN-680147 VARCHAR(10)
   DEFINE p_cmd     LIKE type_file.chr1  	# u:update d:display only 	#No.FUN-680147 VARCHAR(1)
   DEFINE i,j,s     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_oef     DYNAMIC ARRAY OF RECORD
                    oef03	LIKE oef_file.oef03,
                    oef04	LIKE oef_file.oef04,
                    oaj02	LIKE oaj_file.oaj02,
                    oef05	LIKE oef_file.oef05,
                    oef06	LIKE oef_file.oef06
                    END RECORD,
          l_buf            LIKE oef_file.oef04,
          l_i              LIKE type_file.num5,                #No.FUN-680147 SMALLINT
          l_oef03_t        LIKE oef_file.oef03, 
          l_allow_insert   LIKE type_file.num5,                #可新增否 	#No.FUN-680147 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否 	#No.FUN-680147 SMALLINT
  DEFINE  l_cnt            LIKE type_file.num5                 #TQC-960158        
  DEFINE  g_chr            LIKE type_file.chr1                 #TQC-960158       
  
   WHENEVER ERROR CONTINUE
   IF p_no IS NULL THEN RETURN END IF
 
   OPEN WINDOW s_axm_fee_w AT 5,5 WITH FORM "sub/42f/s_axm_fee"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("s_axm_fee")
 
   DECLARE s_axm_fee_c CURSOR FOR
      SELECT oef03,oef04,oaj02,oef05,oef06
        FROM oef_file LEFT OUTER JOIN oaj_file ON oef_file.oef04 = oaj_file.oaj01
        WHERE oef01 = p_no
        ORDER BY oef03,oef04
 
   CALL l_oef.clear() 
   LET i = 1
   FOREACH s_axm_fee_c INTO l_oef[i].*
      IF STATUS THEN
         CALL cl_err('foreach oef',STATUS,0) 
         EXIT FOREACH
      END IF 
      LET i = i + 1
      #No.TQC-630109 --start--
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #No.TQC-630109 ---end---
   END FOREACH
 
   LET l_i = i-1
 
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_oef TO s_oef.* ATTRIBUTE(COUNT=l_i)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
      
      END DISPLAY
      CLOSE WINDOW s_axm_fee_w
      RETURN 
   END IF
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_oef WITHOUT DEFAULTS FROM s_oef.* 
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         CALL fgl_set_arr_curr(i)
 
     BEFORE ROW
        LET i=ARR_CURR()
 
#TQC-960158 --begin--
    BEFORE FIELD oef03
      LET g_chr = 'Y'
      
    AFTER FIELD oef03 
      IF NOT cl_null(l_oef[i].oef03) AND i > 0 THEN 
        FOR l_cnt = 1 TO l_oef.getLength() 
           IF l_oef[l_cnt].oef03 = l_oef[i].oef03 AND
              l_oef[l_cnt].oef04 = l_oef[i].oef04 AND l_cnt != i THEN 
              LET g_chr = 'N'
              EXIT FOR 
           END IF    
        END FOR 
        IF g_chr = 'N' THEN 
           CALL cl_err('','axm-165',0)
           NEXT FIELD oef03
        END IF 
      END IF 
      
      BEFORE FIELD oef04
        LET g_chr = 'Y'
#TQC-960158  --end--
 
     #95/11/06 By Danny 
     AFTER FIELD oef04
#TQC-960158 --begin--
      IF NOT cl_null(l_oef[i].oef04) AND i > 0 THEN 
        FOR l_cnt = 1 TO l_oef.getLength() 
           IF l_oef[l_cnt].oef03 = l_oef[i].oef03 AND
              l_oef[l_cnt].oef04 = l_oef[i].oef04 AND l_cnt != i THEN 
              LET g_chr = 'N'
              EXIT FOR 
           END IF    
        END FOR 
        IF g_chr = 'N' THEN 
           CALL cl_err('','axm-165',0)
           NEXT FIELD oef04
        END IF 
      END IF 
#TQC-960158 --end--          
        IF NOT cl_null(l_oef[i].oef04) THEN
           SELECT oaj01,oaj02 INTO l_buf,l_oef[i].oaj02 FROM oaj_file 
            WHERE oaj01 = l_oef[i].oef04
           IF STATUS THEN
              #CALL cl_err('select oaj',STATUS,1) NEXT FIELD oef04 #FUN-670091
               CALL cl_err3("sel","oaj_file",l_oef[i].oef04,"",STATUS,"","",1) NEXT FIELD oef04 #FUN-670091
           END IF
        END IF
     ####
     AFTER FIELD oef05
        IF cl_null(l_oef[i].oef05) THEN
           NEXT FIELD oef05
        END IF
        #95/11/06 By Danny 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(oef04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_oaj'
               LET g_qryparam.default1 = l_oef[i].oef04
               CALL cl_create_qry() RETURNING l_oef[i].oef04
#               CALL FGL_DIALOG_SETBUFFER( l_oef[i].oef04 )
               NEXT FIELD oef04
          END CASE
        ####
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW s_axm_fee_w
      RETURN
   END IF
   CLOSE WINDOW s_axm_fee_w
 
   LET g_success ='Y' 
 
   BEGIN WORK
 
   DELETE FROM oef_file WHERE oef01 = p_no
   FOR i = 1 TO l_oef.getLength()
       IF cl_null(l_oef[i].oef05) THEN CONTINUE FOR END IF
       INSERT INTO oef_file (oef01,oef03,oef04,oef05,oef06,oefplant,oeflegal)  #FUN-980012 add
                      VALUES(p_no,l_oef[i].oef03,l_oef[i].oef04,l_oef[i].oef05,
                             l_oef[i].oef06,g_plant,g_legal)   #FUN-980012 add
       IF SQLCA.sqlcode THEN
          #CALL cl_err('INS-oef',SQLCA.sqlcode,0)  #FUN-670091
          CALL cl_err3("ins","oef_file","","",STATUS,"","",0) #FUN-670091
          LET g_success = 'N' EXIT FOR
       END IF
 
   END FOR
 
   IF g_success='Y' THEN 
      COMMIT WORK
   ELSE 
      ROLLBACK WORK
   END IF
 
END FUNCTION
