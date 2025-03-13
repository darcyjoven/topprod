# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...:s_upd_ime_img.4gl
# Descriptions...:
# Date & Author..: 09/02/10 By jan
# Modify.........: No.FUN-920053 09/02/18 By jan 過單
# Modify.........: No.MOD-960158 09/06/12 By Carrier p_imd01_1 變成 p_imd01_t
# Modify.........: No.FUN-AA0048 10/10/25 By Carrier 加入unique
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_upd_ime_img(p_imd01_t,p_imd01,p_imd10,p_imd10_t,p_imd14,p_imd14_t,p_imd15,p_imd15_t,
                       p_imd11,p_imd11_t,p_imd12,p_imd12_t,p_imd13,p_imd13_t)
DEFINE l_img01 LIKE img_file.img01,
       l_flag  LIKE type_file.chr1, 
       g_i     LIKE type_file.num5,
       g_cnt   LIKE type_file.num5
DEFINE p_imd01      LIKE imd_file.imd01
DEFINE p_imd01_t    LIKE imd_file.imd01
DEFINE p_imd10      LIKE imd_file.imd10
DEFINE p_imd10_t    LIKE imd_file.imd10
DEFINE p_imd14      LIKE imd_file.imd14
DEFINE p_imd14_t    LIKE imd_file.imd14
DEFINE p_imd15      LIKE imd_file.imd15
DEFINE p_imd15_t    LIKE imd_file.imd15
DEFINE p_imd11      LIKE imd_file.imd11
DEFINE p_imd11_t    LIKE imd_file.imd11
DEFINE p_imd12      LIKE imd_file.imd12
DEFINE p_imd12_t    LIKE imd_file.imd12
DEFINE p_imd13      LIKE imd_file.imd13
DEFINE p_imd13_t    LIKE imd_file.imd13
 
    LET g_success='Y'
 
    IF p_imd10<>p_imd10_t #倉儲類別
       THEN
       UPDATE ime_file SET ime04=p_imd10
         WHERE ime01=p_imd01_t
        IF SQLCA.SQLCODE  THEN 
           LET g_success='N'
           CALL cl_err3("upd","ime_file",p_imd01_t,"",SQLCA.sqlcode,"","upd ime",1) 
        END IF
        UPDATE img_file SET img22=p_imd10
         WHERE img02=p_imd01_t
        IF SQLCA.SQLCODE THEN 
           LET g_success='N'
           CALL cl_err3("upd","img_file",p_imd01_t,"",SQLCA.sqlcode,"","upd img",1) 
        END IF
     END IF
 
#----------------No.TQC-690047 add ---------------
    IF p_imd14<>p_imd14_t THEN     #生產發料優先順序
       UPDATE ime_file SET ime10=p_imd14
         WHERE ime01=p_imd01_t
 
        IF SQLCA.SQLCODE  THEN
           LET g_success='N'
           CALL cl_err('upd ime',SQLCA.SQLCODE,1)
        END IF
 
        UPDATE img_file SET img27=p_imd14
         WHERE img02=p_imd01_t
 
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err('upd img',SQLCA.SQLCODE,1)
        END IF
     END IF
 
    IF p_imd15<>p_imd15_t THEN     #銷售出貨憂先順序
       UPDATE ime_file SET ime11=p_imd15
         WHERE ime01=p_imd01_t
 
        IF SQLCA.SQLCODE  THEN
           LET g_success='N'
           CALL cl_err('upd ime',SQLCA.SQLCODE,1)
        END IF
 
        UPDATE img_file SET img28=p_imd15
         WHERE img02=p_imd01_t
 
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err('upd img',SQLCA.SQLCODE,1)
        END IF
     END IF
#----------------No.TQC-690047 end ---------------
     LET l_flag = 'N'
     IF p_imd11_t='Y' AND  p_imd11='N' #是否為可用倉儲
        THEN
        LET l_flag = 'Y'
     ELSE
        IF p_imd11_t='N' AND  p_imd11='Y'
           THEN
              LET l_flag = 'Y' 
         END IF
     END IF
     IF l_flag = 'Y'
        THEN
        UPDATE ime_file SET ime05=p_imd11
         WHERE ime01=p_imd01_t
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","ime_file",p_imd01_t,"",SQLCA.sqlcode,"","upd ime",1)
        END IF
        UPDATE img_file SET img23=p_imd11
         WHERE img02=p_imd01_t
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","img_file",p_imd01_t,"",SQLCA.sqlcode,"","upd img",1)
        END IF
     END IF
 
     LET l_flag = 'N'
     IF p_imd12_t='Y' AND  p_imd12='N' #是否為MRP可用倉儲
        THEN
        LET l_flag = 'Y'
     ELSE
        IF p_imd12_t='N' AND  p_imd12='Y'
           THEN
              LET l_flag = 'Y'
        END IF
     END IF
     IF l_flag = 'Y'
        THEN
        UPDATE ime_file SET ime06=p_imd12
         WHERE ime01=p_imd01_t
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","ime_file",p_imd01_t,"",SQLCA.sqlcode,"","upd ime",0)
        END IF
        UPDATE img_file SET img24=p_imd12
         WHERE img02=p_imd01_t
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","img_file",p_imd01_t,"",SQLCA.sqlcode,"","upd img",1)
        END IF
     END IF
 
     IF p_imd13<>p_imd13_t #保稅否
        THEN
        UPDATE ime_file SET ime07=p_imd13
         WHERE ime01=p_imd01_t
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","ime_file",p_imd01_t,"",SQLCA.sqlcode,"","upd ime",1)  
        END IF
        UPDATE img_file SET img25=p_imd13
         WHERE img02=p_imd01_t   #No.MOD-960158
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","img_file",p_imd01_t,"",SQLCA.sqlcode,"","upd img",1) 
        END IF
     END IF
 
    IF p_imd01<>p_imd01_t #倉庫別
       THEN
       UPDATE ime_file SET ime01=p_imd01
         WHERE ime01=p_imd01_t
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           CALL cl_err3("upd","ime_file",p_imd01_t,"",SQLCA.sqlcode,"","upd ime",1) 
        END IF
        SELECT COUNT(*) INTO g_cnt FROM tlf_file
         WHERE tlf902=p_imd01_t
        IF g_cnt > 0 
           THEN
           LET g_success='N'
           CALL cl_err('','mfg9099',1)
           RETURN
        ELSE
           UPDATE img_file SET img02=p_imd01
            WHERE img02=p_imd01_t
           IF SQLCA.SQLCODE THEN
              LET g_success='N'
              CALL cl_err3("upd","img_file",p_imd01_t,"",SQLCA.sqlcode,"","upd img",1)  
           END IF
           UPDATE imf_file SET imf02=p_imd01
            WHERE imf02=p_imd01_t
           IF SQLCA.SQLCODE THEN
              LET g_success='N'
              CALL cl_err3("upd","imf_file",p_imd01_t,"",SQLCA.sqlcode,"","upd imf",1)  
           END IF
        END IF
     END IF
 
     DECLARE s_img_cur CURSOR FOR SELECT UNIQUE img01 FROM img_file   #No.FUN-AA0048
        WHERE img02=p_imd01
     IF STATUS THEN 
        LET g_success='N'
        CALL cl_err('decl img_cur',STATUS,1)
        RETURN
     END IF
 
     FOREACH s_img_cur INTO l_img01
        CALL s_udima(l_img01,                #料件編號
                     p_imd11,      #是否可用倉儲
                     p_imd12,      #是否為MRP可用倉儲
                     0,                      #
                     g_today,                #
                     2) RETURNING g_i        #from aimi200
     END FOREACH
     IF STATUS THEN 
        LET g_success='N'
        CALL cl_err('foreach img_cur',STATUS,1)
        RETURN
     END IF
     RETURN g_success
 
END FUNCTION
#FUN-920053
