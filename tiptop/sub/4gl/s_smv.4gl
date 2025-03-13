# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program Name...: s_smv.4gl
# Usage..........: s_smv(p_slip,p_smv03)
# Descriptions...: 單別限定使用部門
# Date & Author..: 03/03/04 By Wiky  add p_smv03
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-740137 07/04/19 By Carrier 非第一行開窗時按"取消",會將其他行的資料也變沒了
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-970280 09/07/31 By mike 1.將l_smv改成DYNAMIC ARRAY                                                        
#                                                 2.FOREACH s_smv_c里原先判斷i>30離開FOREACH,應改成i>g_max_rec,                     
#                                                   并提示9035訊息后再離開FOREACH                                                   
#                                                 3.FOR i=1 TO 30應改成FOR i=1 TO l_smv.l_smv.getLength()                           
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_smv(p_slip,p_smv03)
   DEFINE p_slip	LIKE smu_file.smu01        #No.FUN-680147 VARCHAR(5)   #No.FUN-560060
   DEFINE p_smv03 	LIKE smv_file.smv03        #No.FUN-680147 VARCHAR(3)
   DEFINE g_success	LIKE type_file.chr1        #No.FUN-680147 VARCHAR(1)
   DEFINE b_smv 	RECORD LIKE smv_file.*
  #DEFINE l_smv ARRAY[30] OF RECORD #MOD-970280                                                                                     
   DEFINE l_smv DYNAMIC ARRAY OF RECORD #MOD-970280 
   			smv02	LIKE smv_file.smv02,
   			gem02   LIKE gem_file.gem02
   			END RECORD
   DEFINE i,j,k,l_n	LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(p_slip) THEN    #NO:6842
      CALL  cl_err('','-400',0)
      RETURN
   END IF
   
   LET p_smv03 = UPSHIFT(p_smv03)  #TQC-670008 add
  
   LET p_row = 10 LET p_col = 25
   OPEN WINDOW s_smv_w AT p_row,p_col WITH FORM "sub/42f/s_smv"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("s_smv")
 
   DECLARE s_smv_c CURSOR FOR 
      SELECT smv02,gem02 FROM smv_file, OUTER gem_file
       #WHERE smv01=p_slip AND smv_file.smv02=gem_file.gem01  AND smv03=p_smv03        #TQC-670008 remark
       WHERE smv01=p_slip AND smv_file.smv02=gem_file.gem01  AND upper(smv03)=p_smv03  #TQC-670008
       ORDER BY 1
   LET i=1
   FOREACH s_smv_c INTO l_smv[i].*
      LET i=i+1
     #IF i > 30 THEN EXIT FOREACH END IF #MOD-970280                                                                                
      IF i > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF #MOD-970280  
   END FOREACH
   CALL SET_COUNT(i-1)
   INPUT ARRAY l_smv WITHOUT DEFAULTS FROM s_smv.*
      BEFORE ROW
         LET i = ARR_CURR()
         LET j = SCR_LINE()
      AFTER FIELD smv02
         IF l_smv[i].smv02 IS NOT NULL THEN
            SELECT gem02 INTO l_smv[i].gem02
              FROM gem_file
             WHERE gem01=l_smv[i].smv02 
            IF STATUS THEN
               #CALL cl_err('sel gem:',STATUS,0) #FUN-670091
                CALL cl_err3("sel","gem_file",l_smv[i].smv02,"",STATUS,"","",0)  #FUN-670091
                NEXT FIELD smv02
            END IF
            DISPLAY l_smv[i].gem02 TO s_smv[j].gem02
         END IF
      AFTER ROW       
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER DELETE       
         LET i = ARR_COUNT()
         INITIALIZE l_smv[i+1].* TO NULL
        ON ACTION controlp   #ok
           CASE
              WHEN INFIELD(smv02) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = l_smv[i].smv02
                 CALL cl_create_qry() RETURNING l_smv[i].smv02
#                 CALL FGL_DIALOG_SETBUFFER( l_smv[i].smv02 )
                 DISPLAY l_smv[i].smv02 TO s_smv[j].smv02  #No.TQC-740137
                 NEXT FIELD smv02
           END CASE
##
##      ON KEY(CONTROL-P)
##         CASE WHEN INFIELD(smv02)
##                 CALL q_gem(10,20,l_smv[i].smv02) RETURNING l_smv[i].smv02
##                 CALL FGL_DIALOG_SETBUFFER( l_smv[i].smv02 )
##                 DISPLAY l_smv[i].smv02 TO s_smv[j].smv02
##              OTHERWISE EXIT CASE 
##         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW s_smv_w RETURN END IF
   LET g_success='Y'
   #DELETE FROM smv_file WHERE smv01=p_slip AND smv03=p_smv03        #TQC-670008 remark
   DELETE FROM smv_file WHERE smv01=p_slip AND upper(smv03)=p_smv03  #TQC-670008
   IF STATUS THEN 
      #CALL cl_err('del smv:',STATUS,1)   #FUN-670091
      CALL cl_err3("del","smv_file",p_slip,p_smv03,STATUS,"","",1)  #FUN-670091
      LET g_success='N' 
   END IF
  #FOR i=1 TO 30 #MOD-970280                                                                                                        
   FOR i=1 TO l_smv.getLength() #MOD-970280  
      IF l_smv[i].smv02 IS NULL THEN CONTINUE FOR END IF
      LET b_smv.smv01=p_slip
      LET b_smv.smv02=l_smv[i].smv02
      LET b_smv.smv03=p_smv03
      INSERT INTO smv_file VALUES(b_smv.*)
      IF STATUS THEN 
         #CALL cl_err('ins smv:',STATUS,1)  #FUN-670091
         CALL cl_err3("ins","smv_file","","",STATUS,"","",1)  #FUN-670091
         LET g_success='N' 
      END IF
   END FOR
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CLOSE WINDOW s_smv_w
END FUNCTION
 
FUNCTION s_smv_d(p_slip,p_smv03)
   DEFINE p_slip	LIKE smu_file.smu01        #No.FUN-680147 VARCHAR(5) #No.FUN-560060
   DEFINE p_smv03	LIKE smv_file.smv03        #No.FUN-680147 VARCHAR(3)
   DEFINE x		LIKE smu_file.smu02        #No.FUN-680147 VARCHAR(10)
   DEFINE str		LIKE type_file.chr1000     #No.FUN-680147 VARCHAR(100)
 
   LET p_smv03 = UPSHIFT(p_smv03) #TQC-670008
   DECLARE s_smv_d_c CURSOR FOR 
      #SELECT smv02 FROM smv_file WHERE smv01=p_slip AND smv03=p_smv03 ORDER BY 1         #TQC-670008 remark
      SELECT smv02 FROM smv_file WHERE smv01=p_slip AND upper(smv03)=p_smv03 ORDER BY 1   #TQC-670008
   FOREACH s_smv_d_c INTO x
      IF str IS NULL
         THEN LET str=x
         ELSE LET str=str CLIPPED,',',x
      END IF
   END FOREACH
   RETURN str
END FUNCTION
