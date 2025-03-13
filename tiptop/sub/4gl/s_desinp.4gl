# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_desinp.4gl
# Descriptions...: 此程式為分段輸入品名規格時使用
# Date & Author..: 92/02/11 By Lin
# Usage..........: CALL s_desinp(p_row,p_col,p_key) RETURNING p_key
# Input Parameter: p_row  視窗左上角x坐標
#                  p_col  視窗左上角y坐標
#                  p_key  品名規格
# Return code....: p_key  品名規格
# Moidfy.........: No.MOD-480192 04/09/03 By Nicola 細部品名規格組不出來...按enter可以..但用滑鼠點'確定' 就不行
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Moidfy.........: No.MOD-580346 06/03/21 By Claire 品名規格單身畫面可用滑鼠點進去修改,要取消修改...
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-7C0065 08/03/01 By Pengu 調整j從1開始
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
# Modify.........: No:MOD-A50096 10/05/14 By Sarah 將單身顯示資料筆數放大到單身最大筆數(g_max_rec)
# Modify.........: No:MOD-B70164 11/07/17 By Vampire 將  p_key LIKE ima_file.ima02
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cnt           LIKE type_file.num10               #No.FUN-680147 INTEGER
FUNCTION s_desinp(p_row,p_col,p_key)
   DEFINE   p_row,p_col        LIKE type_file.num5,         #No.FUN-680147 SMALLINT
#           p_key              LIKE imu_file.imu02,         #MOD-B70164 mark
            p_key              LIKE ima_file.ima02,         #MOD-B70164 add
            l_imu              RECORD LIKE imu_file.*,
            l_des              LIKE imw_file.imw03,
            l_imw              DYNAMIC ARRAY of RECORD
            imw03              LIKE imw_file.imw03 
                               END RECORD,
               sr              DYNAMIC ARRAY of RECORD
            imu11              LIKE imu_file.imu11,
            imu12              LIKE imu_file.imu12 
                               END RECORD,
            l_arrno            LIKE type_file.num5,          #No.FUN-680147 SMALLINT
            l_maxac            LIKE type_file.num5,          #No.FUN-680147 SMALLINT
            l_num,l_lenth      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
            l_n,l_ac,l_sl,i,j  LIKE type_file.num5,          #No.FUN-680147 SMALLINT
            l_exit_sw          LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
            l_wc               LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
            l_sql              LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
            l_priv             LIKE cre_file.cre08

   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_key=''
   LET l_arrno = 30
 
   OPEN WINDOW s_desinp_w WITH FORM "sub/42f/s_desinp"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("s_desinp")
 
   WHILE TRUE
     LET l_exit_sw = "y"
     CALL cl_opmsg('q')
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME l_imu.imu01 WITHOUT DEFAULTS 
 
   AFTER FIELD imu01  #品名種類
      IF l_imu.imu01 IS NULL THEN
         NEXT FIELD imu01
      END IF
      CALL s_imu(l_imu.imu01) RETURNING l_imu.*
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(l_imu.imu01,g_errno,0)
         NEXT FIELD imu01
      END IF
      LET sr[1].imu11=l_imu.imu11
      LET sr[2].imu11=l_imu.imu21
      LET sr[3].imu11=l_imu.imu31
      LET sr[4].imu11=l_imu.imu41
      LET sr[5].imu11=l_imu.imu51
      LET sr[6].imu11=l_imu.imu61
      LET sr[1].imu12=l_imu.imu12
      LET sr[2].imu12=l_imu.imu22
      LET sr[3].imu12=l_imu.imu32
      LET sr[4].imu12=l_imu.imu42
      LET sr[5].imu12=l_imu.imu52
      LET sr[6].imu12=l_imu.imu62
       
      ON ACTION controlp
         CASE
            WHEN INFIELD(imu01) #品名種類
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imu"
               LET g_qryparam.construct = "Y"
               LET g_qryparam.default1 = l_imu.imu01
               CALL cl_create_qry() RETURNING l_imu.imu01
#               CALL FGL_DIALOG_SETBUFFER( l_imu.imu01 )
               DISPLAY BY NAME l_imu.imu01
               CALL s_imu(l_imu.imu01) RETURNING l_imu.*
               NEXT FIELD imu01
            OTHERWISE EXIT CASE
         END CASE
        
      ON KEY(CONTROL-Y)
         CASE
            WHEN INFIELD(imu01) #建立品名種類
               CALL cl_cmdrun("aimi191")
         END CASE
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0 
      EXIT WHILE
   END IF
 
   CALL cl_opmsg('w')
 
   LET j=1     #No.MOD-7C0065 modify
   LET l_lenth=0
   LET l_maxac=0   #MOD-A50096 add
   FOR i=1 TO 6
      DISPLAY i TO FORMONLY.a  
      DISPLAY sr[i].imu11 TO FORMONLY.d  
      IF sr[i].imu11 IS NULL THEN
         EXIT FOR
      END IF
      CALL l_imw.clear()
      IF sr[i].imu11 IS NOT NULL AND sr[i].imu12 IS NULL THEN
         IF l_maxac!=0 THEN LET l_arrno=l_maxac END IF   #MOD-A50096 add
         FOR g_cnt = 1 TO l_arrno
            DISPLAY l_imw[g_cnt].* TO s_imw[g_cnt].*
         END FOR
         CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
         INPUT l_des  WITHOUT DEFAULTS  FROM c   HELP 1
 
            AFTER FIELD c  #自行輸入臨時的品名規格描述
               IF l_des IS NOT NULL THEN
                  LET l_num=LENGTH(l_des)
                  #輸入之長度不可大於所設定之位數
                  IF l_num > sr[i].imu11 THEN  
                     CALL cl_err(l_num,'mfg6034',0)
                     NEXT FIELD c
                  END IF
                  IF p_key IS NOT NULL THEN
#                    LET p_key=p_key CLIPPED,' ',l_des 
                     LET p_key=p_key[1,j],l_des
                  ELSE
                     LET p_key=l_des
                  END IF
               END IF
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
         
         END INPUT
 
         IF INT_FLAG THEN
            LET INT_FLAG=0
            EXIT WHILE
         END IF
      ELSE
         LET l_sql = "SELECT imw03 FROM imw_file",
                     " WHERE imw01='",sr[i].imu12,"' "
         PREPARE s_desinp_p FROM l_sql
         DECLARE imw_curs CURSOR FOR s_desinp_p
         LET l_ac = 1
         FOREACH imw_curs INTO l_imw[l_ac].*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_ac = l_ac + 1
           #IF l_ac > l_arrno THEN      #MOD-A50096 mark
            IF l_ac > g_max_rec THEN    #MOD-A50096
               CALL cl_err('','9035',0)
               EXIT FOREACH
            END IF
         END FOREACH
         LET l_maxac = l_ac - 1
         CALL SET_COUNT(l_maxac)
 
        #INPUT ARRAY l_imw WITHOUT DEFAULTS FROM s_imw.* ATTRIBUTE(MAXCOUNT=l_arrno) #No.TQC-630109  #MOD-580346 mark
         DISPLAY ARRAY l_imw TO s_imw.*    #MOD-580346 
 
            BEFORE ROW
               LET l_ac = ARR_CURR()
               LET l_sl = SCR_LINE()
               IF l_imw[l_ac].imw03 IS NOT NULL AND l_ac <= l_maxac THEN
                  DISPLAY l_imw[l_ac].imw03 TO s_imw[l_sl].imw03 
               END IF
 
            AFTER ROW
               DISPLAY l_imw[l_ac].imw03 TO s_imw[l_sl].imw03
 
      	    ON KEY (control-n) LET l_exit_sw = 'n'
               CLEAR FORM
               EXIT DISPLAY                                #MOD-580346 INPUT->DISPLAY  
 
            ON KEY (control-m)
               LET l_ac = ARR_CURR()
               IF p_key IS NOT NULL THEN
                  IF l_ac IS NULL THEN
                     LET l_ac=1
                  END IF
                  LET p_key=p_key[1,j],l_imw[l_ac].imw03
               ELSE
                  LET p_key=l_imw[l_ac].imw03
               END IF
 
             #-----No.MOD-480192-----
            ON ACTION ACCEPT 
               LET l_ac = ARR_CURR()
               IF p_key IS NOT NULL THEN
                  IF l_ac IS NULL THEN 
                     LET l_ac=1
                  END IF
                  LET p_key=p_key[1,j],l_imw[l_ac].imw03
               ELSE
                  LET p_key=l_imw[l_ac].imw03
               END IF
             #-----No.MOD-480192 END-----
 
            EXIT DISPLAY                         #MOD-580346 INPUT->DISPLAY
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DISPLAY                 #MOD-580346 INPUT->DISPLAY
            ON ACTION controls                       #No.FUN-6B0033                                                                       
               CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
         END DISPLAY                            #MOD-580346 INPUT->DISPLAY
         IF INT_FLAG THEN
            LET INT_FLAG=0
            EXIT WHILE
         END IF
      END IF
      DISPLAY p_key TO b 
      LET j=j+sr[i].imu11
     #IF j >= 30 THEN EXIT FOR END IF    #MOD-A50096 mark
      IF j >= 120 THEN EXIT FOR END IF   #MOD-A50096
   END FOR
   EXIT WHILE
   END WHILE
   CLOSE WINDOW s_desinp_w

   RETURN p_key
END FUNCTION
 
FUNCTION s_imu(p_key)  #品名
   DEFINE   p_cmd       LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
            p_key       LIKE imu_file.imu01,
            l_imu       RECORD LIKE imu_file.*,
            l_imu02     LIKE imu_file.imu02,
            l_imuacti   LIKE imu_file.imuacti
 
 
   LET g_errno = ' '
   IF p_key IS NULL THEN
      LET l_imu.imu02=NULL
   ELSE
      SELECT *    INTO l_imu.*
        FROM imu_file WHERE imu01 = p_key
      IF SQLCA.sqlcode THEN
         LET g_errno = 'mfg6031'
         LET l_imu.imu02 = NULL
      END IF
      IF l_imu.imuacti='N' THEN
         LET g_errno = '9028'
      END IF
   END IF
   DISPLAY l_imu.imu02 TO imu02    #ATTRIBUTE(MAGENTA)   #FUN-9B0156
   RETURN l_imu.*
END FUNCTION
