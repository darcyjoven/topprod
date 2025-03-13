# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_get_so.4gl
# Descriptions...: 由採購單/項次,取得訂單/項次
#                  p_po-採購單號  
#                  p_item-採購項次 (p_item若傳入null,則抓第一筆採購單身的訂單/項次)
#                  RETURN 訂單單號,訂單項次
# Date & Author..: 08/01/08 By hellen
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_get_so(p_po,p_item)
   DEFINE p_po      LIKE pmn_file.pmn01
   DEFINE p_item    LIKE pmn_file.pmn02
   DEFINE l_pmm909  LIKE pmm_file.pmm909
   DEFINE l_pmm02   LIKE pmm_file.pmm02
   DEFINE l_pmn24   LIKE pmn_file.pmn24
   DEFINE l_pmn25   LIKE pmn_file.pmn25
   DEFINE l_pmn41   LIKE pmn_file.pmn41
   DEFINE l_sql     STRING
   DEFINE li_result LIKE type_file.num5
   DEFINE l_sfb22   LIKE sfb_file.sfb22
   DEFINE l_sfb221  LIKE sfb_file.sfb221
   DEFINE l_pml24   LIKE pml_file.pml24
   DEFINE l_pml25   LIKE pml_file.pml25
   DEFINE l_cnt     LIKE type_file.num5
   
   LET l_sql="SELECT pmm02,pmm909,pmn24,pmn25,pmn41 ",
             "  FROM pmm_file,pmn_file ",
             " WHERE pmm01=pmn01 ",
             "   AND pmn01='",p_po,"'"
   IF NOT cl_null(p_item) THEN
      LET l_sql=l_sql,"   AND pmn02=",p_item   
   END IF
   LET l_sql=l_sql," ORDER BY pmn01,pmn02"
   LET li_result=FALSE
   DECLARE s_get_so_c CURSOR FROM l_sql
   FOREACH s_get_so_c INTO l_pmm02,l_pmm909,l_pmn24,l_pmn25,l_pmn41
      LET li_result=TRUE
      EXIT FOREACH
   END FOREACH
   IF NOT li_result THEN 
      RETURN NULL,NULL 
   END IF                                         #無採購單資料
   IF l_pmm02='SUB' THEN                          #委外採購單,由工單取得 SO.
      SELECT sfb22,sfb221 INTO l_sfb22,l_sfb221
        FROM sfb_file
       WHERE sfb01=l_pmn41
   ELSE                                           #將訂單/項次統一丟到 l_sfb22,l_sfb221 然後回傳
      CASE l_pmm909                               #資料來源:1:人工輸入 2.請購單轉入 3.訂單轉入
         WHEN "3"
            LET l_sfb22 =l_pmn24
            LET l_sfb221=l_pmn25
         OTHERWISE
            LET l_sfb22 =NULL
            LET l_sfb221=NULL
            SELECT pml24,pml25 INTO l_pml24,l_pml25
              FROM pml_file WHERE pml01=l_pmn24
                              AND pml02=l_pmn25
            IF NOT cl_null(l_pml24) THEN          #請購單身號的pml24(來源單號),目前所知都是由訂單而來,未保險起見確認一下存在訂單單身
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt 
                 FROM oeb_file 
                WHERE oeb01=l_pml24
                  AND oeb03=l_pml25
               IF l_cnt>0 THEN
                  LET l_sfb22 =l_pml24
                  LET l_sfb221=l_pml25
               END IF
            END IF
      END CASE
   END IF
   RETURN l_sfb22,l_sfb221
END FUNCTION
