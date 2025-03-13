# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_smu.4gl
# Descriptions...: 單別限定使用者維護
# Date & Author..: 97/07/08 By Roger
# Usage..........: s_smu(p_slip,p_smu03)
# Input Parameter: 
# Return code....: 
# Date & MODIFY..: 03/04/19 By Wiky NO:6842 add p_smu03   
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........; NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-740137 07/04/19 By Carrier 非第一行開窗時按"取消",會將其他行的資料也變沒了
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-B40007 11/04/01 By yinhy 1.將l_smu改成DYNAMIC ARRAY                                                        
#                                                 2.FOREACH s_smu_c里原先判斷i>30離開FOREACH,應改成i>g_max_rec,                     
#                                                   并提示9035訊息后再離開FOREACH                                                   
#                                                 3.FOR i=1 TO 30應改成FOR i=1 TO l_smu.l_smu.getLength() 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_smu(p_slip,p_smu03)
   DEFINE p_slip	LIKE smu_file.smu01        #No.FUN-680147 VARCHAR(5) #No.FUN-560060
   DEFINE p_smu03	LIKE smu_file.smu03        #No.FUN-680147 VARCHAR(3)
   DEFINE g_success	LIKE type_file.chr1        #No.FUN-680147 VARCHAR(1)
   DEFINE b_smu 	RECORD LIKE smu_file.*
   #DEFINE l_smu ARRAY[30] OF RECORD    #TQC-B40007 mark 
   DEFINE l_smu DYNAMIC ARRAY OF RECORD #TQC-B40007
   			smu02	LIKE zx_file.zx01,      #No.FUN-680147 VARCHAR(10)
   			zx02 	LIKE smu_file.smu02     #No.FUN-680147 VARCHAR(10)
   			END RECORD
   DEFINE i,j,k		LIKE type_file.num10            #No.FUN-680147 INTEGER
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(p_slip) THEN    #NO:6842
      CALL cl_err('','-400',0) 
      RETURN
   END IF
 
   LET p_smu03 = UPSHIFT(p_smu03) #TQC-670008
 
   OPEN WINDOW s_smu_w AT 10,20 WITH FORM "sub/42f/s_smu"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("s_smu") 
 
   DECLARE s_smu_c CURSOR FOR 
      SELECT smu02,zx02 FROM smu_file, OUTER zx_file
       #WHERE smu01=p_slip AND smu_file.smu02=zx_file.zx01 AND smu03=p_smu03        #TQC-670008 remark
       WHERE smu01=p_slip AND smu_file.smu02=zx_file.zx01 AND upper(smu03)=p_smu03  #TQC-670008
       ORDER BY 1
   LET i=1
   FOREACH s_smu_c INTO l_smu[i].*
      LET i=i+1
      #IF i > 30 THEN EXIT FOREACH END IF  #TQC-B40007
      IF i > g_max_rec THEN CALL cl_err('',9035,0) EXIT FOREACH END IF #TQC-B40007
   END FOREACH
   CALL SET_COUNT(i-1)
   INPUT ARRAY l_smu WITHOUT DEFAULTS FROM s_smu.*
      BEFORE ROW
         LET i = ARR_CURR()
         LET j = SCR_LINE()
      AFTER FIELD smu02
         IF l_smu[i].smu02 IS NOT NULL THEN
            SELECT zx02 INTO l_smu[i].zx02
              FROM zx_file
             WHERE zx01=l_smu[i].smu02 
            IF STATUS THEN
               #CALL cl_err('sel zx:',STATUS,0)  #FUN-670091
                CALL cl_err3("sel","zx_file",l_smu[i].smu02,"",STATUS,"","",0)  #FUN-670091
                NEXT FIELD smu02
            END IF
            DISPLAY l_smu[i].zx02 TO s_smu[j].zx02
         END IF
      AFTER ROW       
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT  END IF
      AFTER DELETE       
         LET i = ARR_COUNT()
         INITIALIZE l_smu[i+1].* TO NULL
      ON ACTION controlp   #ok
           CASE
              WHEN INFIELD(smu02) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx"
                 LET g_qryparam.default1 = l_smu[i].smu02
                 CALL cl_create_qry() RETURNING l_smu[i].smu02
#                 CALL FGL_DIALOG_SETBUFFER( l_smu[i].smu02 )
                 DISPLAY l_smu[i].smu02 TO s_smu[j].smu02  #No.TQC-740137
                 NEXT FIELD smu02
           END CASE
{
      ON KEY(CONTROL-P)
         CASE WHEN INFIELD(smu02)
#                CALL q_zx(l_smu[i].smu02) RETURNING l_smu[i].smu02
#                CALL FGL_DIALOG_SETBUFFER( l_smu[i].smu02 )
#                DISPLAY l_smu[i].smu02 TO s_smu[j].smu02
              OTHERWISE EXIT CASE 
         END CASE
}
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW s_smu_w RETURN END IF
   LET g_success='Y'
   #DELETE FROM smu_file WHERE smu01=p_slip AND smu03=p_smu03        #TQC-670008 remark
   DELETE FROM smu_file WHERE smu01=p_slip AND upper(smu03)=p_smu03  #TQC-670008
 
   IF STATUS THEN 
      #CALL cl_err('del smu:',STATUS,1)  #FUN-670091
      CALL cl_err3("del","smu_file",p_slip,p_smu03,STATUS,"","",1) #FUN-670091
      LET g_success='N' 
   END IF
   #FOR i=1 TO 30 #TQC-B40007
   FOR i=1 TO l_smu.getLength() #TQC-B40007
      IF l_smu[i].smu02 IS NULL THEN CONTINUE FOR END IF
      LET b_smu.smu01=p_slip
      LET b_smu.smu02=l_smu[i].smu02
      LET b_smu.smu03=p_smu03
      INSERT INTO smu_file VALUES(b_smu.*)
      IF STATUS THEN 
         #CALL cl_err('ins smu:',STATUS,1) #FUN-670091
         CALL cl_err3("ins","smu_file","","",STATUS,"","",1)  #FUN-670091
         LET g_success='N' 
      END IF
   END FOR
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CLOSE WINDOW s_smu_w
END FUNCTION
 
FUNCTION s_smu_d(p_slip,p_smu03)
   DEFINE p_slip	LIKE smu_file.smu01        #No.FUN-680147 VARCHAR(5) #No.FUN-560060
   DEFINE p_smu03	LIKE smu_file.smu03        #No.FUN-680147 VARCHAR(3)
   DEFINE x		LIKE smu_file.smu02        #No.FUN-680147 VARCHAR(10)
   DEFINE str		LIKE type_file.chr1000     #No.FUN-680147 VARCHAR(100)
 
   LET p_smu03 = UPSHIFT(p_smu03) #TQC-670008
   DECLARE s_smu_d_c CURSOR FOR 
      #SELECT smu02 FROM smu_file WHERE smu01=p_slip  AND smu03=p_smu03 ORDER BY 1        #TQC-670008 remark
      SELECT smu02 FROM smu_file WHERE smu01=p_slip  AND upper(smu03)=p_smu03 ORDER BY 1  #TQC-670008
   FOREACH s_smu_d_c INTO x
      IF str IS NULL
         THEN LET str=x
         ELSE LET str=str CLIPPED,',',x
      END IF
   END FOREACH
   RETURN str
END FUNCTION
