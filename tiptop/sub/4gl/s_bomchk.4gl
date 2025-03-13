# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_bomchk.4gl
# DESCRIPTIONS...: 檢查產品結構建立是否正確
# Date & Author..: 92/07/29 By Nora
# Usage..........: IF s_bomchk(p_bbm01_h,p_bmb03_b,p_ima08_h,p_ima08_b)
# Input PARAMETER: p_bmb01_h  主件編號
#                  p_bmb03_b  元件編號
#                  p_ima08_h  主件來源碼
#                  p_ima08_b  元件來源碼
# RETURN Code....: 0  成功
#                  1  不成功
# Memo...........: 檢查g_errno看其錯誤代碼
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_bomchk(p_bmb01_h,p_bmb03_b,p_ima08_h,p_ima08_b)
	DEFINE p_bmb01_h    LIKE bmb_file.bmb01,
           p_bmb03_b    LIKE bmb_file.bmb03,
           p_ima08_h    LIKE ima_file.ima08,
		   p_ima08_b    LIKE ima_file.ima08,
		   l_bmb01	LIKE ima_file.ima01,
		   l_ima08	LIKE ima_file.ima08,
           l_n     LIKE type_file.num10     	     #No.FUN-680147 INTEGER
 
  LET g_errno = ' ' 
 
#主件料號不可與元件料號相同
    IF p_bmb01_h = p_bmb03_b 
     THEN LET g_errno = 'mfg2633'
          CALL cl_err('',g_errno,0)
     	  RETURN 1
    END IF
 
#主件來源碼為'P' ,元件source code一定為'P'
    IF p_ima08_h matches'[PVZ]' AND p_ima08_b not matches'[PVZ]'
      THEN LET g_errno = 'mfg2611'
           CALL cl_err('',g_errno,0)
     	   RETURN 1
    END IF 
 
#(1)主件為configure  則元件不可為 6.configure 4.family
    IF p_ima08_h = 'C' AND (p_ima08_b = 'C' OR p_ima08_b= 'A')
      THEN LET g_errno = 'mfg2612'
           CALL cl_err('',g_errno,0)
      	   RETURN 1
    END IF
 
#(2)元件為feature    則主件只能為 'D'.feature 'C'. configure 
#   IF p_ima08_b = 'D' AND (p_ima08_h != 'D' AND p_ima08_h != 'C')
#      THEN LET g_errno = 'mfg2613'
#           CALL cl_err('',g_errno,0)
#    	    RETURN 1
#   END IF
 
#主件為最後規格料件, 則元件不可為最後規格料件
    IF (p_ima08_h = 'T' AND p_ima08_b = 'T' ) 
      THEN LET g_errno = 'mfg0056'
           CALL cl_err('',g_errno,0)
     	   RETURN 1
    END IF
 
#若元件為family, 則只能為2 level 之 family BOM
    IF p_ima08_h = 'A' AND p_ima08_b = 'A' THEN
       LET l_n = 0
       SELECT count(*) INTO l_n
               FROM bmb_file,ima_file
              WHERE bmb03 = p_bmb01_h AND ima01 = bmb01
                AND ima08 = 'A'
       IF l_n = 0 THEN 
     	  SELECT count(*) INTO l_n
                  FROM bmb_file ,ima_file
		         WHERE bmb01 = p_bmb03_b AND bmb03 = ima01
                    AND ima08 = 'A'
          IF l_n != 0   THEN 
             LET g_errno ='mfg7010'
             CALL cl_err('',g_errno,0)
     	     RETURN 1
          ELSE RETURN 0
          END IF
       ELSE 
          LET g_errno ='mfg7010'
          LET g_errno ='mfg7010'
          CALL cl_err('',g_errno,0)
     	  RETURN 1
   	   END IF
    END IF
   RETURN 0
END FUNCTION
