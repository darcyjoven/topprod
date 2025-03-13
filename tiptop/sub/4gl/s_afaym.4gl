# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_afaym.4gl
# Descriptions...: 預設附件之耐用年限
# Date & Author..: 97/01/28 By Apple  
# Usage..........: CALL s_afaym(p_no,p_ym,p_type)
# Input Parameter: p_no 財產編號 
#                  p_ym 附件開始提列 
#                  p_type  1.財簽 2.稅簽 
# Return Code....: NONE
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_afaym(p_no,p_ym,p_type)  
DEFINE p_no           LIKE faj_file.faj02,           #財產編號            
       p_ym           LIKE faj_file.faj27,           #附件開始提列        
       p_type         LIKE type_file.chr1,   	     #No.FUN-680147 VARCHAR(1)
       l_faj27        LIKE faj_file.faj27,
       l_faj29        LIKE faj_file.faj29,
       l_faj64        LIKE faj_file.faj64,
       l_eym,l_emm    LIKE type_file.num10,  	     #No.FUN-680147 INTEGER
       l_bym,l_bmm    LIKE type_file.num10,  	     #No.FUN-680147 INTEGER
       l_mm           LIKE type_file.num5,   	     #No.FUN-680147 SMALLINT
       l_totem,l_totbm,l_totm LIKE type_file.num10,  #No.FUN-680147 INTEGER
       l_chrtotm      LIKE aab_file.aab02 	     #No.FUN-680147 VARCHAR(06)
DEFINE l_faj272       LIKE faj_file.faj272           #FUN-AB0088 add
DEFINE l_faj292       LIKE faj_file.faj292           #FUN-AB0088 add 
 
     WHENEVER ERROR CALL cl_err_msg_log
        SELECT faj27,faj29,faj64 INTO l_faj27,l_faj29,l_faj64 FROM faj_file 
                           WHERE faj02 = p_no
                             AND faj021= '1' 
        IF SQLCA.sqlcode THEN  RETURN ' ' END IF
        #FUN-AB0088---add---str-------------
        IF g_faa.faa31 = 'Y' THEN
            SELECT faj272,faj292 INTO l_faj272,l_faj292 FROM faj_file 
                               WHERE faj02 = p_no
                                 AND faj021= '1' 
            IF SQLCA.sqlcode THEN  RETURN ' ' END IF
        END IF
        #FUN-AB0088---add---end------------  

       #FUN-AB0088---mark----str------    
       #IF p_type = '1' THEN 
       #     LET l_mm = l_faj29 
       #ELSE LET l_mm = l_faj64 
       #END IF
       #FUN-AB0088---mark---end-------

       #FUN-AB0088---add----str-------
       CASE 
            WHEN p_type = '1'
                LET l_mm = l_faj29 
            WHEN p_type = '2'
                LET l_mm = l_faj64 
            WHEN p_type = '3'
                LET l_mm = l_faj292 
        END CASE
       #FUN-AB0088---add----end-------
        
       IF p_type <> '3' THEN                        #FUN-AB0088 add  
          LET l_eym   = (l_faj27[1,4]-1911) * 12  
          LET l_emm   = l_faj27[5,6] 
          LET l_totem = l_eym + l_emm + l_mm        #主件止截日期
       #FUN-AB0088---add---str-----------
       ELSE
          LET l_eym   = (l_faj272[1,4]-1911) * 12  
          LET l_emm   = l_faj272[5,6] 
          LET l_totem = l_eym + l_emm + l_mm        #主件止截日期
       END IF
       #FUN-AB0088---add---end----------
 
        LET l_bym   = (p_ym[1,4] -1911 )* 12        #附件開始提列
        LET l_bmm   = p_ym[5,6]
        LET l_totbm = l_bym + l_bmm 
        LET l_totm = l_totem - l_totbm 
        RETURN l_totm
END FUNCTION
