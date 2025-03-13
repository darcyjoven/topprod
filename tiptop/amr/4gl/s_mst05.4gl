# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
 # Modify.........: NO.MOD-520115 05/02/24 by ching 中文改入p_ze
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
FUNCTION s_mst05(p_lang,p1)
   DEFINE p_lang    LIKE type_file.chr1      #NO FUN-680082
#  DEFINE p_lang    STRING                   #NO FUN-680082   VARCHAR(1)
#   DEFINE p1       LIKE ooy_flie.ooytype    #NO FUN-680082
    DEFINE p1       LIKE type_file.chr2      #NO FUN-680082   VARCHAR(2)  
# DEFINE p2         LIKE faj_file.faj02
 DEFINE p2          LIKE type_file.chr20     #NO FUN-680082   VARCHAR(10) 
 CASE
    WHEN p1='40' # '安全庫存' 
       LET p2=cl_getmsg('amr-240',p_lang) 
    WHEN p1='41' #'獨立需求' 
       LET p2=cl_getmsg('amr-241',p_lang)  
    WHEN p1='42' #'受訂量'  
       LET p2=cl_getmsg('amr-242',p_lang)  
    WHEN p1='43' #'計劃備料' 
       LET p2=cl_getmsg('amr-243',p_lang)  
    WHEN p1='44' #'工單備料' 
       LET p2=cl_getmsg('amr-244',p_lang)  
    WHEN p1='45' #'PLM 備料'
       LET p2=cl_getmsg('amr-245',p_lang)  
    WHEN p1='46' #'備品需求' 
       LET p2=cl_getmsg('amr-246',p_lang)  
    WHEN p1='51' #'庫存量'
       LET p2=cl_getmsg('amr-251',p_lang)  
    WHEN p1='52' #'在驗量' 
       LET p2=cl_getmsg('amr-252',p_lang)  
    WHEN p1='53' #'替代量' 
       LET p2=cl_getmsg('amr-253',p_lang)  
    WHEN p1='61' #'請購量'
       LET p2=cl_getmsg('amr-261',p_lang)  
    WHEN p1='62' #'在採量' 
       LET p2=cl_getmsg('amr-262',p_lang)  
    WHEN p1='63' #'在外量' 
       LET p2=cl_getmsg('amr-263',p_lang)  
    WHEN p1='64' #'在製量'
       LET p2=cl_getmsg('amr-264',p_lang)  
    WHEN p1='65' #'計劃產' 
       LET p2=cl_getmsg('amr-265',p_lang)  
    OTHERWISE LET p2 = ''
   END CASE
   RETURN p2
END FUNCTION
