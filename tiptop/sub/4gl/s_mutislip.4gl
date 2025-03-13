# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_mutislip.4gl
# Descriptions...: 多角貿易取得各單據單別
# Date & Author..: No.7993 03/09/1 By Kammy 
# Usage..........: CALL s_mutislip(p_type1,p_type2,p_slip)
# Input Parameter: p_type1      1.出貨/入庫  2.銷退/倉退
#                  p_type2      1.銷售開始   2.採購開始
#                  p_slip       單別
# Return code....: 
# Modify.........: No.FUN-550070 05/05/26 By wujie 單據編號格式放大 
# Modify.........: No.FUN-620025 06/02/15 By cl 增加對訂單，采購單單別的獲取
# Modify.........: NO.FUN-670007 06/08/15 BY yiting 1.tsi_file改合併到poy_file單別設定,多傳入一個站別參數 
#                                                   2.oan_file合併到poy_file
#                                                   3.oaq_file合併到poy_file
#                                                   4.多傳入一個p_poy02站別參數及流程代碼，以取得apmi000設定之站別資料
#                                                   5.多加入出貨通知單別
# Modify.........: No.FUN-680147 06/09/15 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-720003 07/02/04 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_mutislip(p_type1,p_type2,p_slip,p_poz01,p_poy02)
 DEFINE p_type1,p_type2 LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
 DEFINE p_slip          LIKE poy_file.poy36         #No.FUN-680147 VARCHAR(5) #No.FUN-550070
 DEFINE p_sw            LIKE type_file.num5         #No.FUN-680147 SMALLINT
 DEFINE l_cnt           LIKE type_file.num5         #No.FUN-680147 SMALLINT
 DEFINE l_t1,l_t2,l_t3  LIKE poy_file.poy36         #No.FUN-680147 VARCHAR(5) #No.FUN-550070
 DEFINE l_t4,l_t5       LIKE poy_file.poy39         #No.FUN-680147 VARCHAR(5) #No.FUN-550070
 DEFINE l_oan           RECORD LIKE oan_file.*
 DEFINE l_oaq           RECORD LIKE oaq_file.*
 DEFINE l_tsi           RECORD LIKE tsi_file.*  #No.FUN-620025
 DEFINE l_poy           RECORD LIKE poy_file.*  #No.FUN-670007
 DEFINE p_poy02         LIKE poy_file.poy02     #NO.FUN-670007
 DEFINE p_poz01         LIKE poz_file.poz01     #NO.FUN-670007
 
 LET p_sw = 0 
 
#NO.FUN-670007 start-一律取poy_file設定
 SELECT * INTO l_poy.* FROM poy_file 
  WHERE poy01 = p_poz01 
    AND poy02 = p_poy02
 IF p_type1 = '1' THEN        #出貨/入庫
   IF p_type2 = '1' THEN
      SELECT * INTO l_poy.* FROM poy_file 
      #WHERE poy36 = p_slip
      WHERE poy01 = p_poz01 
         AND poy02 = p_poy02
   ELSE 
      SELECT * INTO l_poy.* FROM poy_file 
       #WHERE poy38 = p_slip
       WHERE poy02 = p_poy02
         AND poy01 = p_poz01 
   END IF
    
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('sel poy:','axm-899',1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','sel poy:','axm-899',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('sel poy:','axm-899',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end
       LET p_sw = 1
    END IF
    LET l_t1= l_poy.poy36
    LET l_t2= l_poy.poy37
    LET l_t3= l_poy.poy38
    LET l_t4= l_poy.poy39
    LET l_t5= l_poy.poy40
 END IF
 IF p_type1 = '2' THEN        #銷退/倉退 取 poy_file
   IF p_type2 = '1' THEN
      SELECT * INTO l_poy.* FROM poy_file 
       #WHERE poy41 = p_slip
        WHERE poy01 = p_poz01 
          AND poy02 = p_poy02
   ELSE
      SELECT * INTO l_poy.* FROM poy_file 
       #WHERE poy42 = p_slip
        WHERE poy01 = p_poz01 
         AND poy02 = p_poy02
   END IF
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('sel poy:','axm-900',1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','sel poy:','axm-900',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('sel poy:','axm-900',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end        
       LET p_sw = 1
    END IF
    LET l_t1= l_poy.poy41
    LET l_t2= l_poy.poy42
    LET l_t3= l_poy.poy43
    LET l_t4= l_poy.poy44
    LET l_t5= ' '
 END IF
 IF p_type1 = '3' THEN
   IF p_type2 = '1' THEN
      SELECT * INTO l_poy.* FROM poy_file 
       #WHERE poy34 = p_slip 
       WHERE poy01 = p_poz01 
         AND poy02 = p_poy02
   ELSE                     #采購開始                         
      SELECT * INTO l_poy.* FROM poy_file 
       #WHERE poy35 = p_slip
       WHERE poy01 = p_poz01 
         AND poy02 = p_poy02
   END IF
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('sel poy:','apm-801',1) 
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','sel poy:','apm-801',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('sel poy:','apm-801',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end         
       LET p_sw = 1  
    END IF 
    LET l_t1= l_poy.poy34 
    LET l_t2= l_poy.poy35
    LET l_t3= ' '   
    LET l_t4= ' '   
    LET l_t5= ' '   
 END IF
#NO.FUN-670007 start--
 IF p_type1 = '4' THEN        #出貨/入庫
   SELECT * INTO l_poy.* FROM poy_file 
    #WHERE poy47 = p_slip
    WHERE poy01 = p_poz01 
      AND poy02 = p_poy02
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('sel poy:','axm-907',1) 
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','sel poy:','axm-907',1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('sel poy:','axm-907',1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       LET p_sw = 1
    END IF
    LET l_t1= l_poy.poy47
    LET l_t2= ' '
    LET l_t3= ' '
    LET l_t4= ' '
    LET l_t5= ' '
 END IF
#NO.FUN-670007 end--------------
# IF p_type1 = '1' THEN        #出貨/入庫 取 ozn_file
#    IF p_type2 = '1' THEN
#       SELECT * INTO l_oan.* FROM oan_file WHERE oan01 = p_slip
#    ELSE
#       SELECT * INTO l_oan.* FROM oan_file WHERE oan03 = p_slip
#    END IF
#    IF SQLCA.SQLCODE THEN
#       CALL cl_err('sel oan:','axm-899',1) LET p_sw = 1
#    END IF
#    LET l_t1= l_oan.oan01
#    LET l_t2= l_oan.oan02
#    LET l_t3= l_oan.oan03
#    LET l_t4= l_oan.oan04
#    LET l_t5= l_oan.oan05
# END IF
# IF p_type1 = '2' THEN        #銷退/倉退 取 oaq_file
#    IF p_type2 = '1' THEN
#       SELECT * INTO l_oaq.* FROM oaq_file WHERE oaq01 = p_slip
#    ELSE
#       SELECT * INTO l_oaq.* FROM oaq_file WHERE oaq02 = p_slip
#    END IF
#    IF SQLCA.SQLCODE THEN
#       CALL cl_err('sel oaq:','axm-900',1) LET p_sw = 1
#    END IF
#    LET l_t1= l_oaq.oaq01
#    LET l_t2= l_oaq.oaq02
#    LET l_t3= l_oaq.oaq03
#    LET l_t4= l_oaq.oaq04
#    LET l_t5= ' '
# END IF
 #FUN-620025--begin--
# IF p_type1 = '3' THEN
#    IF p_type2 = '1' THEN
#       SELECT * INTO l_tsi.* FROM tsi_file WHERE tsi01 = p_slip 
#    ELSE                     #采購開始                         
#       SELECT * INTO l_tsi.* FROM tsi_file WHERE tsi02 = p_slip
#    END IF
#    IF SQLCA.SQLCODE THEN
#       CALL cl_err('sel tsi:','apm-801',1) 
#       LET p_sw = 1  
#    END IF 
#    LET l_t1= l_tsi.tsi01 
#    LET l_t2= l_tsi.tsi02
#    LET l_t3= ' '   
#    LET l_t4= ' '   
#    LET l_t5= ' '   
# END IF
 #FUN-620025--end--
#NO.FUN-670007 end-一律取poy_file設定------------------------
 RETURN p_sw,l_t1,l_t2,l_t3,l_t4,l_t5
END FUNCTION
