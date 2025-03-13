# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_guiauno.4gl
# Descriptions...: 本 sub 提供二種功能:
#            	   (1)自動賦予發票號碼     (當 p_no is null)
#            	   (2)更新發票簿檔最大單號 (當 p_no is not null)
# Date & Author..: 
# Usage..........: CALL s_guiauno(p_no,p_date,p_oma05,p_oma212)
#		                  RETURNING l_stat,l_slip
# Input Parameter: p_slip  單號
# Return code....: l_stat  結果碼 0:OK, 1:FAIL
#                  l_slip  單號
# Modify.........: No.FUN-540023 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-560198 05/07/05 By vivien 發票欄位加大后截位修改
# Modify.........: No.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60167 10/06/25 By Dido 若發票別有多本發票簿時,應可找下一本發票簿
# Modify.........: No.MOD-AA0044 10/10/11 By Dido 增加 lock cursor 
# Modify.........: No.MOD-B90276 11/10/03 By Dido 發票預設值調整 
# Modify.........: No.MOD-BA0058 11/10/09 By Dido l_chknum 變數調整 
# Modify.........: No.FUN-B90130 11/10/29 BY wujie 大陆版时，oom04-->oom15,增加发票代码的传入和传出 
# Modify.........: No.MOD-CA0157 12/10/23 By SunLM 修正SQL條件,將NULL--->' '
# Modify.........: No.TQC-CA0054 12/10/24 By SunLM SQL加上OR oom16 IS NULL 条件,oom16赋初始值为 ' ',但过去旧资料有可能是NULL
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
DEFINE g_waitsec	LIKE type_file.num5         #No.FUN-680147 SMALLINT
DEFINE g_forupd_sql     STRING                      #SELECT ... FOR UPDATE SQL #MOD-AA0044
END GLOBALS
 
FUNCTION s_guiauno(p_no,p_code,p_date,p_oma05,p_oma212)   #No.FUN-B90130 add p_code
DEFINE p_no     LIKE oom_file.oom09          #No.FUN-680147 VARCHAR(16)  #INVOICE#
                                             #No.FUN-540023
DEFINE p_date   LIKE type_file.dat           #No.FUN-680147 DATE		#發票日期
DEFINE p_oma05  LIKE oom_file.oom03          #No.FUN-680147 VARCHAR(1)
DEFINE p_oma212 LIKE oom_file.oom04          #No.FUN-680147 VARCHAR(1)
DEFINE l_n      LIKE type_file.num5          #        #No.FUN-680147 SMALLINT
DEFINE i        LIKE type_file.num5          #        #No.FUN-680147 SMALLINT
DEFINE l_cnt    LIKE type_file.num5          #        #No.FUN-680147 SMALLINT
DEFINE l_cnt1   LIKE type_file.num5          #MOD-A60167
DEFINE l_cnt2   LIKE type_file.num5          #MOD-A60167 
DEFINE l_yy,l_mm	        LIKE type_file.num10         #No.FUN-680147 INTEGER
DEFINE l_oom			RECORD LIKE oom_file.*
DEFINE g_format LIKE oom_file.oom09          #No.FUN-680147  VARCHAR(16)    #No.FUN-560198
DEFINE l_lock_sw                LIKE type_file.chr1          #MOD-AA0044
DEFINE l_chknum LIKE type_file.num20_6       #MOD-B90276 #MOD-BA0058 mod num5 -> num20_6 
DEFINE l_sql    STRING                       #No.FUN-B90130 
DEFINE p_code   LIKE oom_file.oom16          #No.FUN-B90130   #发票代码  
 
    WHENEVER ERROR CONTINUE
    LET l_yy=YEAR(p_date) LET l_mm=MONTH(p_date)
         #99.01.28 配合2個月申報一次發票修改
       #  IF l_mm=2 THEN LET l_mm=1 END IF
       #  IF l_mm=4 THEN LET l_mm=3 END IF
       #  IF l_mm=6 THEN LET l_mm=5 END IF
       #  IF l_mm=8 THEN LET l_mm=7 END IF
       #  IF l_mm=10 THEN LET l_mm=9 END IF
       #  IF l_mm=12 THEN LET l_mm=11 END IF
    IF NOT cl_null(p_no) THEN #人工開立發票,不需自動編號,但要更新最大單號
      #-MOD-AA0044-add-
       SELECT * INTO l_oom.*
         FROM oom_file
       WHERE oom07 <= p_no AND p_no <= oom08
        #AND (p_no > oom09 OR oom09 IS NULL)      #MOD-BA0058 mark
         #AND (oom16 = p_code OR oom16 IS NULL )   #No.FUN-B90130 #MOD-CA0157
         AND (oom16 = p_code OR oom16 =' ' OR oom16 IS NULL)  #MOD-CA0157 add TQC-CA0054 add
       LET g_forupd_sql = "SELECT * FROM oom_file ", 
                          " WHERE oom01 = ? AND oom02 = ? AND oom021= ? ",
#No.FUN-B90130 --begin
#                         "   AND oom03 = ? AND oom04 = ? AND oom05 = ? FOR UPDATE "
                          "   AND oom03 = ? AND oom04 = ? AND oom05 = ? AND oom15 = ? FOR UPDATE "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE oom_lock_cl CURSOR FROM g_forupd_sql 
       OPEN oom_lock_cl USING l_oom.oom01,l_oom.oom02,l_oom.oom021,l_oom.oom03,l_oom.oom04,l_oom.oom05,l_oom.oom15   
#No.FUN-B90130--end            
  
       IF STATUS THEN
          CALL cl_err("OPEN oom_lock_cl:",STATUS,1)
          LET l_lock_sw = 'Y'
          RETURN 1,'',''  #No.FUN-B90130 
       ELSE
          FETCH oom_lock_cl INTO l_oom.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(p_no,SQLCA.sqlcode,1)
             LET l_lock_sw = 'Y'
          RETURN 1,'',''  #No.FUN-B90130 
          END IF
       END IF
       IF l_lock_sw = 'Y' THEN
          CALL cl_err(p_no,-263,1)
          LET p_no = '' 
          RETURN 1,'',''  #No.FUN-B90130 
       ELSE
      #-MOD-AA0044-end-
          UPDATE oom_file SET oom09=p_no, oom10=p_date
           WHERE oom07 <= p_no AND p_no <= oom08
             AND (p_no > oom09 OR oom09 IS NULL)
            # AND (oom16 = p_code OR oom16 IS NULL )    #No.FUN-B90130   #MOD-CA0157
             AND (oom16 = p_code OR oom16 = ' ' OR oom16 IS NULL) #MOD-CA0157 add TQC-CA0054 add           
          IF SQLCA.SQLCODE THEN
             #CALL cl_err('upd oom09:',SQLCA.SQLCODE,1) RETURN 1,''  #FUN-670091
              CALL cl_err3("upd","oom_file","","",STATUS,"","upd oom09",0) RETURN 1,'',''  #FUN-670091  #No.FUN-B90130 
          END IF
          RETURN 0,p_no,p_code    #No.FUN-B90130       
       END IF            #MOD-AA0044
    END IF
    LET l_cnt2 = 1    #MOD-A60167 
#No.FUN-B90130 --begin   
    LET l_sql = "SELECT oom_file.* FROM oom_file ", 
                " WHERE oom01 = '",l_yy,"' AND '",l_mm,"' BETWEEN oom02 AND oom021", 
                "   AND oom03 = '",p_oma05,"' AND oom06 ='1' AND (oom08>oom09 OR oom09 IS NULL) "
    IF g_aza.aza26 ='2' THEN 
       IF NOT cl_null(p_code) THEN 
          LET l_sql = l_sql," AND oom15 = '",p_oma212,"' AND oom16 = '",p_code,"' ORDER BY oom05 "  
       ELSE
          LET l_sql = l_sql," AND oom15 = '",p_oma212,"' ORDER BY oom05 "  
       END IF       
    ELSE 
       LET l_sql = l_sql," AND oom04 = '",p_oma212,"' ORDER BY oom05 "        
    END IF  
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    PREPARE sel_oom_pre01 FROM l_sql
    DECLARE oom_curl CURSOR FOR sel_oom_pre01   
#    DECLARE oom_curl CURSOR FOR
#        SELECT oom_file.* FROM oom_file
#         WHERE oom01=l_yy AND l_mm BETWEEN oom02 AND oom021
#           AND oom03=p_oma05 AND oom04=p_oma212 AND oom06='1'
#           AND (oom08>oom09 OR oom09 IS NULL)
#         ORDER BY oom05 
#No.FUN-B90130 --end     
    FOREACH oom_curl
    INTO l_oom.*
      IF STATUS THEN
         CALL cl_err('s_guiauno:foreach',STATUS,1)
         CLOSE oom_curl  RETURN 1,'',''    #失敗  #No.FUN-B90130 
      END IF
     #-MOD-A60167-add-
      LET l_cnt1 = 0
#No.FUN-B90130 --begin 
#      SELECT COUNT(*) INTO l_cnt1
#        FROM oom_file
#       WHERE oom01=l_yy AND l_mm BETWEEN oom02 AND oom021
#         AND oom03=p_oma05 AND oom04=p_oma212 AND oom06='1'
#         AND (oom08>oom09 OR oom09 IS NULL)

      LET l_sql = "SELECT COUNT(*) FROM oom_file ", 
                  " WHERE oom01 = '",l_yy,"' AND '",l_mm,"' BETWEEN oom02 AND oom021", 
                  "   AND oom03 = '",p_oma05,"' AND oom06 ='1' AND (oom08>oom09 OR oom09 IS NULL) "
      IF g_aza.aza26 ='2' THEN 
         IF NOT cl_null(p_code) THEN 
            LET l_sql = l_sql," AND oom15 = '",p_oma212,"' AND oom16 = '",p_code,"' ORDER BY oom05 "  
         ELSE
            LET l_sql = l_sql," AND oom15 = '",p_oma212,"' ORDER BY oom05 "  
         END IF       
      ELSE 
         LET l_sql = l_sql," AND oom04 = '",p_oma212,"' ORDER BY oom05 "        
      END IF   
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      PREPARE sel_oom_pre02 FROM l_sql
      EXECUTE sel_oom_pre02 INTO l_cnt1
#No.FUN-B90130 --end 
     #-MOD-A60167-add-
      IF p_date < l_oom.oom10 THEN
         IF l_cnt1 = l_cnt2 THEN                     #MOD-A60167
            CALL cl_err(l_oom.oom10,'axr-208',1)
            CLOSE oom_curl  RETURN 1,'',''    #失敗   #No.FUN-B90130 
         ELSE
            LET l_cnt2 = l_cnt2 + 1                  #MOD-A60167
            CONTINUE FOREACH                         #MOD-A60167
         END IF                                      #MOD-A60167
      END IF
      #####
      #No.FUN-560198 --start--
      #為了與舊寫法兼容，default初值
      IF cl_null(l_oom.oom11) THEN LET l_oom.oom11 = 3 END IF
      IF cl_null(l_oom.oom12) THEN LET l_oom.oom12 = 10 END IF
      LET l_cnt=length(l_oom.oom07[l_oom.oom11,l_oom.oom12])
      LET g_format = NULL
      FOR i = 1 TO l_cnt
         LET g_format = '&',g_format CLIPPED
      END FOR
      LET l_chknum = l_oom.oom07[l_oom.oom11,l_oom.oom11+l_cnt-1]-1  #MOD-B90276
      IF cl_null(l_oom.oom09) THEN                   #MOD-B90276 mark #MOD-BA0058 remark
     #IF cl_null(l_oom.oom09) AND l_chknum > 0 THEN  #MOD-B90276      #MOD-BA0058 mark
         LET l_oom.oom09 = l_oom.oom07   #MOD-BA0058 add
        #str MOD-BA0058 mark
        #IF l_oom.oom11 > 1 THEN
        #   LET l_oom.oom09 = l_oom.oom09[1,l_oom.oom11-1],
        #                    (l_oom.oom09[l_oom.oom11,l_oom.oom11+l_cnt-1]-1) USING g_format CLIPPED
        #ELSE
        #   LET l_oom.oom09 =(l_oom.oom09[l_oom.oom11,l_oom.oom11+l_cnt-1]-1) USING g_format CLIPPED
        #END IF
        #end MOD-BA0058 mark
      ELSE                              #MOD-B90276
        #LET l_oom.oom09 = l_oom.oom07  #MOD-B90276 #MOD-BA0058 mark
        #str MOD-BA0058 add
         IF l_oom.oom11 > 1 THEN
            LET l_oom.oom09 = l_oom.oom09[1,l_oom.oom11-1],
                             (l_oom.oom09[l_oom.oom11,l_oom.oom11+l_cnt-1]+1) USING g_format CLIPPED
         ELSE
            LET l_oom.oom09 =(l_oom.oom09[l_oom.oom11,l_oom.oom11+l_cnt-1]+1) USING g_format CLIPPED
         END IF
        #end MOD-BA0058 add
      END IF
#     IF cl_null(l_oom.oom09) THEN
#        CASE WHEN l_cnt=1
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&' CLIPPED
#             WHEN l_cnt=2
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&' CLIPPED
#             WHEN l_cnt=3
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&' CLIPPED
#             WHEN l_cnt=4
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&' CLIPPED
#             WHEN l_cnt=5
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&' CLIPPED
#             WHEN l_cnt=6
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&&' CLIPPED
#             WHEN l_cnt=7
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&&&' CLIPPED
#             WHEN l_cnt=8
#             LET l_oom.oom09=l_oom.oom07[1,2],(l_oom.oom07[3,3+l_cnt-1]-1) USING '&&&&&&&&' CLIPPED
#        END CASE
#     END IF
#     CASE WHEN l_cnt=1
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&' CLIPPED
#          WHEN l_cnt=2
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&' CLIPPED
#          WHEN l_cnt=3
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&' CLIPPED
#          WHEN l_cnt=4
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&' CLIPPED
#          WHEN l_cnt=5
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&' CLIPPED
#          WHEN l_cnt=6
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&&' CLIPPED
#          WHEN l_cnt=7
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&&&' CLIPPED
#          WHEN l_cnt=8
#          LET l_oom.oom09=l_oom.oom09[1,2],(l_oom.oom09[3,3+l_cnt-1]+1) USING '&&&&&&&&' CLIPPED
#     END CASE
      #No.FUN-560198 --end--
      LET p_no = l_oom.oom09
      LET p_code = l_oom.oom16  #No.FUN-B90130 
      #####
      EXIT FOREACH
    END FOREACH
    IF p_no IS NULL THEN
#No.FUN-B90130 --begin    
      LET l_sql = "SELECT COUNT(*) FROM oom_file ", 
                  " WHERE oom01 = '",l_yy,"' AND '",l_mm,"' BETWEEN oom02 AND oom021", 
                  "   AND oom03 = '",p_oma05,"' AND oom06 ='2' "
      IF g_aza.aza26 ='2' THEN 
         IF NOT cl_null(p_code) THEN 
            LET l_sql = l_sql," AND oom15 = '",p_oma212,"' AND oom16 = '",p_code,"' ORDER BY oom05 "  
         ELSE
            LET l_sql = l_sql," AND oom15 = '",p_oma212,"' ORDER BY oom05 "  
         END IF       
      ELSE 
         LET l_sql = l_sql," AND oom04 = '",p_oma212,"' ORDER BY oom05 "        
      END IF   
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      PREPARE sel_oom_pre03 FROM l_sql
      EXECUTE sel_oom_pre03 INTO l_n
#      SELECT COUNT(*) INTO l_n FROM oom_file           #no:5607
#        WHERE oom01=l_yy AND l_mm BETWEEN oom02 AND oom021
#          AND oom03=p_oma05 AND oom15=p_oma212 AND oom06='2'  
#No.FUN-B90130 --end 
       IF l_n=0 THEN
          CALL cl_err('s_guiauno:','aap-760',1) RETURN 1,'',''   #No.FUN-B90130 
       END IF
    END IF
    CLOSE oom_curl
    RETURN 0,p_no,p_code   #No.FUN-B90130  
END FUNCTION
#Patch....NO.TQC-610035 <001> #
